Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9497E6BF329
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 21:55:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbjCQUy5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Mar 2023 16:54:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229644AbjCQUys (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Mar 2023 16:54:48 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D73AA19C54
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 13:54:46 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id l1-20020a170903244100b001a0468b4afcso3292814pls.12
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 13:54:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679086486;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=REFRiDrZb1prbFB+V0Z2eOotrpJFg6ljhcVayw2lSQ8=;
        b=PES197tQB99/TI2F99zbQicV4HW4lJpFQCxcfBNE7HoqAvZjmVAUa+7TueVTsxTYsQ
         Ii+XAacc9w/jYckT6UOvgFZOZZeCpfTTaH6Po6Zj9y2Tyb5fFpwhxNTCLISD/cdETiTl
         NXJRcH5+7d9JXEfTDbxQyTdcX3FZ5+hA3IuVTTN8vCjlcxQALLTLa1nDkJfjb3qxbalb
         hzNpDURx7vneR8eWS4lURvenjFyTKI+4zg6S0+f3Q8eFECcPoVAXTyEJ4RvRAUfCCleu
         2R7yFSL8HyH6xQQx9QHO0meAj6rIVBIew2BdT/D1ZESIW/PFdXlkSy7HzdqTZm2RzE73
         dcug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679086486;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=REFRiDrZb1prbFB+V0Z2eOotrpJFg6ljhcVayw2lSQ8=;
        b=yflnPK3NE6nzZ7pyrfO3HcgznOX36jtCf/upvTIidxqpiA+fDEbHA0l1sQ54LHoUFg
         LQ+YZsERWaz06K7Xu6fhiO6f65avzntJfZjjaEjSSZ6x14kS2mde2ID7UJJOmIk+0Sm3
         hHPqmX0J7NeoxwwPl2tDhAz+wmYZILbgLG19C0JnvqYJ138Ojr5zgPI+cBH8iaUWZi3P
         h3ixTqnNgXgdDYJSBaISRuCLlIBbEy0Z/FnO6JGlbNy6BOfR1smcidIJYKjRPbcOnhp9
         iserp/JlLNmpjh+LUYy6ctNfG0ox8kk8t24z+7+3ZgCGIRhdQSYzErk1+XDBU6Fb2YmM
         oN7w==
X-Gm-Message-State: AO0yUKW85nUays+wBNN4om2B6ajzKQMTNVk2kWedsh6CdF5yfuRk4rkU
        TcWa9OpzYryMMER7cbosU5dUi5PalCE=
X-Google-Smtp-Source: AK7set9UXJZI0aYpT0eAs9I4ZW1+09LHYcAg/bQtV0rbo0UZxAPYYmNN/5ALd7iN9kmspKnuxLcTePSPFLw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:a12:b0:622:f66f:25a1 with SMTP id
 p18-20020a056a000a1200b00622f66f25a1mr3961715pfh.0.1679086486392; Fri, 17 Mar
 2023 13:54:46 -0700 (PDT)
Date:   Fri, 17 Mar 2023 13:54:44 -0700
In-Reply-To: <CAF7b7mr9oJfY7Y2PQtHDRyM5-mtXYFamW3mR5_Ap8a4TjG34LQ@mail.gmail.com>
Mime-Version: 1.0
References: <20230315021738.1151386-1-amoorthy@google.com> <20230315021738.1151386-10-amoorthy@google.com>
 <ZBS4o75PVHL4FQqw@linux.dev> <CAF7b7mr9oJfY7Y2PQtHDRyM5-mtXYFamW3mR5_Ap8a4TjG34LQ@mail.gmail.com>
Message-ID: <ZBTTlNrWeT9f1mjZ@google.com>
Subject: Re: [WIP Patch v2 09/14] KVM: Introduce KVM_CAP_MEMORY_FAULT_NOWAIT
 without implementation
From:   Sean Christopherson <seanjc@google.com>
To:     Anish Moorthy <amoorthy@google.com>
Cc:     Oliver Upton <oliver.upton@linux.dev>, jthoughton@google.com,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 17, 2023, Anish Moorthy wrote:
> On Fri, Mar 17, 2023 at 11:59=E2=80=AFAM Oliver Upton <oliver.upton@linux=
.dev> wrote:
>=20
> > > +  #define KVM_MEM_ABSENT_MAPPING_FAULT (1UL << 2)
> >
> > call it KVM_MEM_EXIT_ABSENT_MAPPING
> > ...
> > I'm not a fan of this architecture-specific dependency. Userspace is al=
ready
> > explicitly opting in to this behavior by way of the memslot flag. These=
 sort
> > of exits are entirely orthogonal to the -EFAULT conversion earlier in t=
he
> > series.
>=20
> I'm not a fan of the semantics varying between architectures either:
> but the reason I have it like that (and that the EFAULT conversions
> exist in this series in the first place) is (a) not having
> KVM_CAP_MEMORY_FAULT_EXIT implemented for arm and (b) Sean's following
> statement from https://lore.kernel.org/kvm/Y%2FfS0eab7GG0NVKS@google.com/

Strictly speaking, if y'all buy my argument that the flag shouldn't control=
 the
gup behavior, there won't be semantic differences for the memslot flag.  KV=
M will
(obviously) behavior differently if KVM_CAP_MEMORY_FAULT_EXIT is not set, b=
ut that
will hold true for x86 as well.  The only difference is that x86 will also =
support
an orthogonal flag that makes the fast-only memslot flag useful in practice=
.

So yeah, there will be an arch dependency, but only because arch code needs=
 to
actually handle perform the exit, and that's true no matter what.

That said, there's zero reason to put X86 in the name.  Just add the capabi=
lity
as KVM_CAP_MEMORY_FAULT_EXIT or whatever and mark it as x86 in the document=
ation.
