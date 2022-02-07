Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B19894ACA67
	for <lists+kvm@lfdr.de>; Mon,  7 Feb 2022 21:28:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242342AbiBGU1f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Feb 2022 15:27:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233089AbiBGUY1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Feb 2022 15:24:27 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0236BC0401DA
        for <kvm@vger.kernel.org>; Mon,  7 Feb 2022 12:24:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644265465;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9T/OvHQML0n7t8483X0s9RB1P7k3PGxeDBNyGeKNXxg=;
        b=gq1JiwiMhVRICsyRsLLPMuVjgxY3NuFaWNOyW3mIw1C3bCv7egaV8L8z1YeyRdPdG9TAQb
        h15HpVxTIPRuJ9nWzPi3GKlhQHu5alQQw5exNpK8mf24IsMq3fIDWukQsAm7//3E1VVt2E
        Bd65DYJYsIcjG+2BY6kE0Y+h+tei39k=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-272-ksjelnxHN6-XyXUj915e3g-1; Mon, 07 Feb 2022 15:24:24 -0500
X-MC-Unique: ksjelnxHN6-XyXUj915e3g-1
Received: by mail-lj1-f199.google.com with SMTP id a13-20020a2e88cd000000b002386c61ffe2so4963906ljk.7
        for <kvm@vger.kernel.org>; Mon, 07 Feb 2022 12:24:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9T/OvHQML0n7t8483X0s9RB1P7k3PGxeDBNyGeKNXxg=;
        b=M/YIEY9mzAsHpwhryFVzB04sgyce37LHVRzn5BFrNXY7K64w/rSMdxyUpEulpMADjW
         Qy/+Gdw5TJ77H3xTnycjtMGH3nB6SFJBzleiayl9ji8ne/b5blVlBwS0oDz1x/8Hl61f
         QKLxPcL2/SwSK0e6UFaiU6iH2M1U8DFxriG+ZMCa0sM3LSMPONKfoShwjyQiTuR8cg9V
         FRuSqFARbmADlGoqaFDY6LNNbaP0mxa4and/G3RYfVBCUI59zqFYU7FNDsdEBcOjd7Jz
         +J2wKspVAYozikmTp+FfMQp1dU6E2OB3el7iEHRrq1JnSJ1WB47G/QgUbTwMlNMDgnme
         rrUQ==
X-Gm-Message-State: AOAM531MG3kB2GlxA6m534+LZVWoSgPfz0cT0dSf/McMEmsK6+ZaWIdz
        zZLPQnNCUxwMNHijntCsWcvhdlYjAp+aReeFYQeDRCsoqN0oQ9bdatfUQrAV3wwOeCmUC1Dltqd
        RO9mBRkJZApXeF0tUx3MeudnKXkqr
X-Received: by 2002:a05:651c:1213:: with SMTP id i19mr745441lja.116.1644265463109;
        Mon, 07 Feb 2022 12:24:23 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwuUh1S24KOapaXqUTbR/PE5isBkVVKCEATv0reBXJDNNQwUC3D72GSr/G+3NpnX4u042B4PjJAmEV12JsYe7E=
X-Received: by 2002:a05:651c:1213:: with SMTP id i19mr745427lja.116.1644265462882;
 Mon, 07 Feb 2022 12:24:22 -0800 (PST)
MIME-Version: 1.0
References: <20220205081658.562208-1-leobras@redhat.com> <20220205081658.562208-2-leobras@redhat.com>
 <f2b0cac2-2f8a-60e8-616c-73825b3f62a6@redhat.com>
In-Reply-To: <f2b0cac2-2f8a-60e8-616c-73825b3f62a6@redhat.com>
From:   Leonardo Bras Soares Passos <leobras@redhat.com>
Date:   Mon, 7 Feb 2022 17:24:11 -0300
Message-ID: <CAJ6HWG7DV-AeWyXxGwMMV61BejcCdpTc=U+4U6eY4gx4hfhP-g@mail.gmail.com>
Subject: Re: [PATCH v1 1/2] x86/kvm/fpu: Mask guest fpstate->xfeatures with guest_supported_xcr0
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Paolo,

On Mon, Feb 7, 2022 at 10:30 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 2/5/22 09:16, Leonardo Bras wrote:
> > During host/guest switch (like in kvm_arch_vcpu_ioctl_run()), the kernel
> > swaps the fpu between host/guest contexts, by using fpu_swap_kvm_fpstate().
> >
> > When xsave feature is available, the fpu swap is done by:
> > - xsave(s) instruction, with guest's fpstate->xfeatures as mask, is used
> >    to store the current state of the fpu registers to a buffer.
> > - xrstor(s) instruction, with (fpu_kernel_cfg.max_features &
> >    XFEATURE_MASK_FPSTATE) as mask, is used to put the buffer into fpu regs.
> >
> > For xsave(s) the mask is used to limit what parts of the fpu regs will
> > be copied to the buffer. Likewise on xrstor(s), the mask is used to
> > limit what parts of the fpu regs will be changed.
> >
> > The mask for xsave(s), the guest's fpstate->xfeatures, is defined on
> > kvm_arch_vcpu_create(), which (in summary) sets it to all features
> > supported by the cpu which are enabled on kernel config.
> >
> > This means that xsave(s) will save to guest buffer all the fpu regs
> > contents the cpu has enabled when the guest is paused, even if they
> > are not used.
> >
> > This would not be an issue, if xrstor(s) would also do that.
> >
> > xrstor(s)'s mask for host/guest swap is basically every valid feature
> > contained in kernel config, except XFEATURE_MASK_PKRU.
> > According to kernel src, it is instead switched in switch_to() and
> > flush_thread().
>
> Hi Leonardo, is this an issue when patch 2 is applied?

Yes.
This issue happens on host/guest context switch, instead of KVM_{GET,SET}_XSAVE,
so this bug will be triggered whenever the guest doesn't support PKRU
but the host
does, without any interference of above IOCTLs.
In fact, IIUC,  even if we are able to fix the feature bit with
KVM_SET_XSAVE, it would
come back after another host/guest context switch if we don't fix
vcpu->arch.guest_fpu.fpstate->xfeatures.

> With this patch,
> we have to reason about the effect of calling KVM_SET_CPUID2 twice calls
> back to back.  I think an "&=" would be wrong in that case.

So, you suggest something like this ?

vcpu->arch.guest_fpu.fpstate->xfeatures =
        fpu_user_cfg.default_features & vcpu->arch.guest_supported_xcr0;


>
> On the other hand, with patch 2 the change is only in the KVM_SET_XSAVE
> output, which is much more self-contained.

Agree, but they solve different sources of the same issue.
Patch 2 will only address a bug that can happen if userspace mistakenly
tries to set a feature the guest does not support.

>
> Thanks,

Thank you!

Best regards,
Leo
[...]

