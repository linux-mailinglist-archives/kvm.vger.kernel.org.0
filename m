Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3005C6BF151
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 20:00:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230027AbjCQTAe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Mar 2023 15:00:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230046AbjCQTAb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Mar 2023 15:00:31 -0400
Received: from mail-vs1-xe30.google.com (mail-vs1-xe30.google.com [IPv6:2607:f8b0:4864:20::e30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A580110C0
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 12:00:11 -0700 (PDT)
Received: by mail-vs1-xe30.google.com with SMTP id 187so5366428vsq.10
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 12:00:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679079610;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gS7vY94TlNCCLH4sWXbXGkrnl2l2soULVAp3hnZoJBs=;
        b=F4SCwnwZ6o7lRgZPLC/veXwLkrynkPn1aevoHrgws/1tgOZh9L6JC/p15Vy+sAcDdl
         e9t3lFdNls88Unq7svNl5V6S/feFLM+0rCONJv9uX8mzKgzwH9eYAhK7RhvdEnuXNrQx
         MwkpJIYCXXG4gZD0zs5/BJDt0F4kU/bAp3e17xnG8Ope0o4Iyl+XN2Hz6HEAYKw0+tVY
         6eYQpor8ubtTz6eME8pHoq+F0zVAaQfclUZTFGJnyyadT2NnPNrs3vbhafFnNTWz2d7m
         59JQrV+24i4MwTZ29FyW7+lURn4bfgMWojN7rQMplpft0xV0DR/SlA4JYHFv08lp3eH7
         OWCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679079610;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gS7vY94TlNCCLH4sWXbXGkrnl2l2soULVAp3hnZoJBs=;
        b=oLuH0Kql3ZLGvNNYwxR7GVmAODYm1ZSsPeqLCOongvp22qmiSb9VxjAAMGW2gpLdrP
         10Vy94JlV+1QRaW0bv1sBszNDIaKLA/PCZigPygmOhpVeqxlro8xZFOcV3ObLWtPwruB
         TG3gcFlKBs3mXj2f2RZ40cy5N7PnD1KPHLbRDXkwfkYL6/vUYrDs+1hI9VAvvH9PNExY
         afWEkbR/9G6Y3nv8mSDumtUgO3jO4mmxy6qowTBkfUJGjJuW4lQsyhr6XKacbPwblEZi
         UFUMnGKden/AfRhHLQv94Rea1V9SVY2ViL9A9Woa1Vj+BirczhQPACPcxodahc85pC+N
         eWsg==
X-Gm-Message-State: AO0yUKXte5K6HSufyx7MAasjy9vrtTOi9Boi4cYtor8ZBcfxBAxYrWBy
        rP3KU7MQOfumdobS+3NbHZTqj0WcorfUo2RewP/KOQ==
X-Google-Smtp-Source: AK7set9BLsIuKmQiaA3wvDqHV3P0UYVoLl5+Pvk7WgWhEUGIoxHwWEUfBouYnBcPuLzIF8+vstihr8RU1FVXWLKI8o0=
X-Received: by 2002:a67:ca0e:0:b0:425:eb13:b07d with SMTP id
 z14-20020a67ca0e000000b00425eb13b07dmr505247vsk.4.1679079610090; Fri, 17 Mar
 2023 12:00:10 -0700 (PDT)
MIME-Version: 1.0
References: <20230315021738.1151386-1-amoorthy@google.com> <ZBSmz0JAgTrsF608@linux.dev>
 <ZBStyKk6H73/0z2r@google.com> <CALzav=dBJyr373jnBF_-uLJfZMwHOsKSVSR2u4xr83etjp6Daw@mail.gmail.com>
 <ZBS3UbrWFZJzLzOq@linux.dev>
In-Reply-To: <ZBS3UbrWFZJzLzOq@linux.dev>
From:   David Matlack <dmatlack@google.com>
Date:   Fri, 17 Mar 2023 11:59:43 -0700
Message-ID: <CALzav=fuZRrrMWHR+tRJ7R9hUDHyzhdBJ_Ak2V622TjRpFLoLw@mail.gmail.com>
Subject: Re: [WIP Patch v2 00/14] Avoiding slow get-user-pages via memory
 fault exit
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     Sean Christopherson <seanjc@google.com>,
        Anish Moorthy <amoorthy@google.com>, jthoughton@google.com,
        kvm@vger.kernel.org, maz@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 17, 2023 at 11:54=E2=80=AFAM Oliver Upton <oliver.upton@linux.d=
ev> wrote:
>
> David,
>
> On Fri, Mar 17, 2023 at 11:46:58AM -0700, David Matlack wrote:
> > On Fri, Mar 17, 2023 at 11:13=E2=80=AFAM Sean Christopherson <seanjc@go=
ogle.com> wrote:
> > >
> > > On Fri, Mar 17, 2023, Oliver Upton wrote:
> > > > On Wed, Mar 15, 2023 at 02:17:24AM +0000, Anish Moorthy wrote:
> > > > > Hi Sean, here's what I'm planing to send up as v2 of the scalable
> > > > > userfaultfd series.
> > > >
> > > > I don't see a ton of value in sending a targeted posting of a serie=
s to the
> > > > list.
> >
> > But isn't it already generating value as you were able to weigh in and
> > provide feedback on technical aspects that you would not have been
> > otherwise able to if Anish had just messaged Sean?
>
> No, I only happened upon this series looking at lore. My problem is that
> none of the affected maintainers or reviewers were cc'ed on the series.
>
> > > > IOW, just CC all of the appropriate reviewers+maintainers. I promis=
e,
> > > > we won't bite.
> >
> > I disagree. While I think it's fine to reach out to someone off-list
> > to discuss a specific question, if you're going to message all
> > reviewers and maintainers, you should also CC the mailing list. That
> > allows more people to follow along and weigh in if necessary.
>
> I think there may be a slight disconnect here :) I'm in no way encouragin=
g
> off-list discussion and instead asking that mail on the list arrives in
> the right folks' inboxes.
>
> Posting an RFC on the list was absolutely the right thing to do.

Doh. I misunderstood what you meant. We are in violent agreement!
