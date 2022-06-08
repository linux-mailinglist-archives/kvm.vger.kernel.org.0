Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52845543D9A
	for <lists+kvm@lfdr.de>; Wed,  8 Jun 2022 22:34:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232063AbiFHUei (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jun 2022 16:34:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229922AbiFHUeg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jun 2022 16:34:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4D522BC8B
        for <kvm@vger.kernel.org>; Wed,  8 Jun 2022 13:34:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654720473;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XRSme8wOBaM90PvfwVzl0l/m5nMDDm6ImTO1PuXLlu0=;
        b=d3e+mn0Gzw7z+maKB2bTcDOqHqJWgtjrmExAFC2INzWnvAH46uSU6aE+NbH+0+pCqdiHE/
        pqDvMj5b0ymPNHqfot8yP12ACYqXPoJc9b7AfPCtzIuskSzRRcv6l3wfdw9bdI3VX2i1K/
        mMaBjI9jon1Xe2SzUyrPf1S4MMUv2CM=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-543-IYSozLwMOkCB9rPkdvIxkg-1; Wed, 08 Jun 2022 16:34:32 -0400
X-MC-Unique: IYSozLwMOkCB9rPkdvIxkg-1
Received: by mail-ej1-f70.google.com with SMTP id v13-20020a170906b00d00b006f51e289f7cso9862029ejy.19
        for <kvm@vger.kernel.org>; Wed, 08 Jun 2022 13:34:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XRSme8wOBaM90PvfwVzl0l/m5nMDDm6ImTO1PuXLlu0=;
        b=nGbOzvNjkdvSrpkU/wvbBuFeda6cjXLrv2PGyEQ+HzQ0ktEGpTvgThatMWZfQa1OlI
         Mas/hNxAdbJZhDdj60N0s91TmDeIxH+Mc8pxvF8QOrQQW0i4gvpvjvanaAQCfcuQ4P4S
         lC3Ov61RuexGu9oycvg2VS++fmDi47b8ZiKyYQBkc1sCrxem9+hpYj53X0Q3AURxlt5J
         nrr9kRd4HrmUqV0/L1Q6qBJ0YKGb8PoxUaQfQz8l+bVUQOO7zD87EN1d9mV5irC0mQI/
         I4Br+Wu3KbaWev9lxKzR+G17/nFQVmNUGTJEiAvZxYIaakpA2+muRKT5U7A/3MoIE5E8
         ffCg==
X-Gm-Message-State: AOAM531LJuy1ducdSSw6mwHg6Caw9aKCls1Uk/BnhkvvlBo3r2yioQSP
        yEapxGplQDoJxTG+yZok9fUpP2FV9glXzvlmVIUa0iSV/LdvVBYVn1rwCQY6NYb4AaHYmbZGUJx
        fW2gIkyUxQdYXL3B8fCMZAAZ/6/PC
X-Received: by 2002:a17:906:824a:b0:70f:4c58:6ec6 with SMTP id f10-20020a170906824a00b0070f4c586ec6mr25916977ejx.648.1654720469951;
        Wed, 08 Jun 2022 13:34:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzN/b2zqi1/ofSnqXmKYZ+jg9/ys0C8DxSw3yD646fVpWjItubDhRgDutjwKrhZRWxEWSIEVQnQJwaAKMaz+8Y=
X-Received: by 2002:a17:906:824a:b0:70f:4c58:6ec6 with SMTP id
 f10-20020a170906824a00b0070f4c586ec6mr25916954ejx.648.1654720469668; Wed, 08
 Jun 2022 13:34:29 -0700 (PDT)
MIME-Version: 1.0
References: <20220301201344.18191-1-sashal@kernel.org> <20220301201344.18191-7-sashal@kernel.org>
 <5f2b7b93-d4c9-1d59-14df-6e8b2366ca8a@redhat.com> <YppVupW+IWsm7Osr@xz-m1.local>
 <2d9ba70b-ac18-a461-7a57-22df2c0165c6@redhat.com> <Yp5xSi6P3q187+A+@xz-m1.local>
 <9d336622-6964-454a-605f-1ca90b902836@redhat.com> <Yp9o+y0NcRW/0puA@google.com>
 <Yp+WUoA+6x7ZpsaM@xz-m1.local> <Yp+fBeyf7TjI1qgo@xz-m1.local>
In-Reply-To: <Yp+fBeyf7TjI1qgo@xz-m1.local>
From:   Leonardo Bras Soares Passos <leobras@redhat.com>
Date:   Wed, 8 Jun 2022 17:34:18 -0300
Message-ID: <CAJ6HWG7x_VA3JAsopojCq+t2-MDZ-rn4DXZqt0SoXEDxTzrRMQ@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 5.16 07/28] x86/kvm/fpu: Limit guest
 user_xfeatures to supported bits of XCR0
To:     Peter Xu <peterx@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "Chang S. Bae" <chang.seok.bae@intel.com>,
        Andy Lutomirski <luto@kernel.org>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Peter,

On Tue, Jun 7, 2022 at 5:07 PM Peter Xu <peterx@redhat.com> wrote:
>
> On Tue, Jun 07, 2022 at 02:17:54PM -0400, Peter Xu wrote:
> > On Tue, Jun 07, 2022 at 03:04:27PM +0000, Sean Christopherson wrote:
> > > On Tue, Jun 07, 2022, Paolo Bonzini wrote:
> > > > On 6/6/22 23:27, Peter Xu wrote:
> > > > > On Mon, Jun 06, 2022 at 06:18:12PM +0200, Paolo Bonzini wrote:
> > > > > > > However there seems to be something missing at least to me, on why it'll
> > > > > > > fail a migration from 5.15 (without this patch) to 5.18 (with this patch).
> > > > > > > In my test case, user_xfeatures will be 0x7 (FP|SSE|YMM) if without this
> > > > > > > patch, but 0x0 if with it.
> > > > > >
> > > > > > What CPU model are you using for the VM?
> > > > >
> > > > > I didn't specify it, assuming it's qemu64 with no extra parameters.
> > > >
> > > > Ok, so indeed it lacks AVX and this patch can have an effect.
> > > >
> > > > > > For example, if the source lacks this patch but the destination has it,
> > > > > > the source will transmit YMM registers, but the destination will fail to
> > > > > > set them if they are not available for the selected CPU model.
> > > > > >
> > > > > > See the commit message: "As a bonus, it will also fail if userspace tries to
> > > > > > set fpu features (with the KVM_SET_XSAVE ioctl) that are not compatible to
> > > > > > the guest configuration.  Such features will never be returned by
> > > > > > KVM_GET_XSAVE or KVM_GET_XSAVE2."
> > > > >
> > > > > IIUC you meant we should have failed KVM_SET_XSAVE when they're not aligned
> > > > > (probably by failing validate_user_xstate_header when checking against the
> > > > > user_xfeatures on dest host). But that's probably not my case, because here
> > > > > KVM_SET_XSAVE succeeded, it's just that the guest gets a double fault after
> > > > > the precopy migration completes (or for postcopy when the switchover is
> > > > > done).
> > > >
> > > > Difficult to say what's happening without seeing at least the guest code
> > > > around the double fault (above you said "fail a migration" and I thought
> > > > that was a different scenario than the double fault), and possibly which was
> > > > the first exception that contributed to the double fault.
> > >
> > > Regardless of why the guest explodes in the way it does, is someone planning on
> > > bisecting this (if necessary?) and sending a backport to v5.15?  There's another
> > > bug report that is more than likely hitting the same bug.
> >
> > What's the bisection you mentioned?  I actually did a bisection and I also
> > checked reverting Leo's change can also fix this issue.  Or do you mean
> > something else?
>
> Ah, I forgot to mention on the "stable tree decisions": IIUC it also means
> we should apply Leo's patch to all the stable trees if possible, then
> migrations between them won't trigger the misterous faults anymore,
> including when migrating to the latest Linux versions.
>
> However there's the delimma that other kernels (any kernel that does not
> have Leo's patch) will start to fail migrations to the stable branches that
> apply Leo's patch too..

IIUC, you commented before that the migration issue should be solved with a
QEMU fix, is that correct? That would mean something like 'QEMU is relying on a
kernel bug to work', and should be no blocker for fixing the kernel.

If that's the case, I think we should apply the fix to every supported
stable branch that
have the fpku issue, and in parallel come with a qemu fix for that.

What do you think about it?

Best regards,
Leo

> So that's kind of a slight pity.  It's just IIUC
> the stable trees are more important, because it should have a broader
> audience (most Linux distros)?
>
> >
> > >
> > > https://lore.kernel.org/all/48353e0d-e771-8a97-21d4-c65ff3bc4192@sentex.net
> >
> > That is kvm64, and I agree it could be the same problem since both qemu64
> > and kvm64 models do not have any xsave feature bit declared in cpuid 0xd,
> > so potentially we could be migrating some fpu states to it even with
> > user_xfeatures==0 on dest host.
> >
> > So today I continued the investigation, and I think what's really missing
> > is qemu seems to be ignoring the user_xfeatures check for KVM_SET_XSAVE and
> > continues even if it returns -EINVAL.  IOW, I'm wondering whether we should
> > fail properly and start to check kvm_arch_put_registers() retcode.  But
> > that'll be a QEMU fix, and it'll at least not causing random faults
> > (e.g. double faults) in guest but we should fail the migration gracefully.
> >
> > Sean: a side note is that I can also easily trigger one WARN_ON_ONCE() in
> > your commit 98c25ead5eda5 in kvm_arch_vcpu_ioctl_run():
> >
> >       WARN_ON_ONCE(kvm_lapic_hv_timer_in_use(vcpu));
> >
> > It'll be great if you'd like to check that up.
> >
> > Thanks,
> >
> > --
> > Peter Xu
>
> --
> Peter Xu
>

