Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 563676EAEF3
	for <lists+kvm@lfdr.de>; Fri, 21 Apr 2023 18:22:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232630AbjDUQWN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Apr 2023 12:22:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232628AbjDUQWM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Apr 2023 12:22:12 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DE3314468
        for <kvm@vger.kernel.org>; Fri, 21 Apr 2023 09:22:10 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id 5b1f17b1804b1-3f1950f5628so6892525e9.3
        for <kvm@vger.kernel.org>; Fri, 21 Apr 2023 09:22:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682094129; x=1684686129;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GrYsNtgw74ztN7e3pvnyx/JwXWQAkNxk8bJ7YuN8gRw=;
        b=19P5qaQDD6Ir4qwcHLjD1JpIvWPpQH6x+LtIKYqRaa+8XtTyn5d1fWxl7foPysgIMt
         pzxBPWwJHKRLEEdXgOr/LCSqciy/szp5DwfCWCX/c//f8kqBoGYNuH9IfD0ewCxh7YCT
         owqAxrNvM/wufLhAfp200YLkcUVqmPV6sf5bbe04iIXMUEEjgGscfnVFcMTtiIrsb7As
         k3/2XcbvHRIpuPbtDxSlVQBkd9R9C9CoFLV6qOUM4USFJCoQ/ZGEMJ9EJ+7jhO9i3jEZ
         NOl98CeqvMKRZad4MnenhhK38PydTAGe7lQiBDsI0aTkZ3zE4JUiOntaj0eIZ1zaaJ2K
         3qHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682094129; x=1684686129;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GrYsNtgw74ztN7e3pvnyx/JwXWQAkNxk8bJ7YuN8gRw=;
        b=Gx9IIOrK6f3heGs9MZE6Y7OO0wWTQIzOE8vfxEbTCTVUrmv8UqUjRMslXf/3XBmQDv
         NlqPsxRTHUL4+hRR6u7ON+sFCorh7u3jc/CS2Q0vDpVp+ix5Zy2m1PWgsv279XSipqv6
         OiNrABGzjT1FmyfY6AAc4BAG2pBcdbO10iygqHdGilzjsrRi1pYwRR3GFkzV+hQ5Jiqe
         TyuKshrPLYtTJp4yZG3ax5Xwpms1V/0az75Os52ps7Mn6IMEx18H1UrzfFPYdSJq8YsB
         j9nByo6IfWEiBFd51vC2yVCvximqioRo2W1KhKp4LKY69yZ3oLv6m78AGTycrcjIRFED
         2aIA==
X-Gm-Message-State: AAQBX9dGLftFfkeOJ/LhkYlHEOjjiG29P5RY1lwWwGPzlOjKTJq0P+cA
        5Y/QNgDeu51POI6AWl8m2ALn5GiRywiGJ564t41nCA==
X-Google-Smtp-Source: AKy350YOOW/R09AMwTETRErtw1r2/Wun0ysqRNAv+E7XGPitF9a+Jc7pmelyd9j7FsmyFQSzUDUOVyUJzBF+0pPDXBc=
X-Received: by 2002:a1c:f30e:0:b0:3f1:6d22:eaa0 with SMTP id
 q14-20020a1cf30e000000b003f16d22eaa0mr2643410wmq.2.1682094128700; Fri, 21 Apr
 2023 09:22:08 -0700 (PDT)
MIME-Version: 1.0
References: <20230412213510.1220557-1-amoorthy@google.com> <20230412213510.1220557-2-amoorthy@google.com>
 <e73e9a97-3c76-fa71-b481-c0673e8562de@gmail.com> <CAF7b7mqMhQmQzJEhZJvEXGUzFB=jSXXOQUr22=Ef+oT-EDyEkg@mail.gmail.com>
 <CA+wubQC0rqteeDdU04vhWahBiwTU5ty5V+pTUXGYu9xd4ppM0g@mail.gmail.com>
In-Reply-To: <CA+wubQC0rqteeDdU04vhWahBiwTU5ty5V+pTUXGYu9xd4ppM0g@mail.gmail.com>
From:   Anish Moorthy <amoorthy@google.com>
Date:   Fri, 21 Apr 2023 09:21:30 -0700
Message-ID: <CAF7b7mp=f3PEfsC0+1QG9gOXDiZ-P+jX7XeX+49f+KgTmWS1NQ@mail.gmail.com>
Subject: Re: [PATCH v3 01/22] KVM: selftests: Allow many vCPUs and reader
 threads per UFFD in demand paging test
To:     Robert Hoo <robert.hoo.linux@gmail.com>
Cc:     pbonzini@redhat.com, maz@kernel.org, oliver.upton@linux.dev,
        seanjc@google.com, jthoughton@google.com, bgardon@google.com,
        dmatlack@google.com, ricarkol@google.com, axelrasmussen@google.com,
        peterx@redhat.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 21, 2023 at 5:15=E2=80=AFAM Robert Hoo <robert.hoo.linux@gmail.=
com> wrote:
>
> IIUC, you could say: in this on demand paging test case, even
> duplicate copy/continue doesn't do harm anyway. Am I right?

It's probably more accurate to say that it never happens in the first
place. I've added a sentence here,

> > > > +             /* See the note about EEXISTs in the UFFDIO_COPY bran=
ch. */
> > >
> > > Personally I would suggest copy the comments here. what if some day a=
bove
> > > code/comment was changed/deleted?
> >
> > You might be right: on the other hand, if the comment ever gets
> > updated then it would have to be done in two places. Anyone to break
> > the tie? :)
>
> The one who updates the place is responsible for the comments. make sense=
?:)

Fair enough, done.
