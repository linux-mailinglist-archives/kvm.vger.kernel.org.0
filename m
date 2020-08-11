Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DC44241406
	for <lists+kvm@lfdr.de>; Tue, 11 Aug 2020 02:05:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727049AbgHKAFu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Aug 2020 20:05:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726733AbgHKAFt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Aug 2020 20:05:49 -0400
Received: from mail-oo1-xc43.google.com (mail-oo1-xc43.google.com [IPv6:2607:f8b0:4864:20::c43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 411CDC06174A
        for <kvm@vger.kernel.org>; Mon, 10 Aug 2020 17:05:49 -0700 (PDT)
Received: by mail-oo1-xc43.google.com with SMTP id k63so2267972oob.1
        for <kvm@vger.kernel.org>; Mon, 10 Aug 2020 17:05:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=T9Idy/BmZn9IZefa6c48sS4dzGuqqOJAnrsSY8u5SVQ=;
        b=Wlo1xYvYDQB5UdyjcPcvxlvHWnFaytS+xrKwjKz+c3yku1J3VSzdkf+McpueHAXTOH
         w+jVamW/qb6ODfCIJ8mZIpKlaeJZYnSdrnIBqRjQgZYtalgRpnRhvILtJPBfbqaqMlCU
         hGIPrr1tO1awZoW20/BaHmI8ZjVfnDh18iT6dNj2sd31L925WN9HEfthswKfyd4pQzX0
         torZq8FO2aECeynPebqR3fNvIcw6aLqMK6jKxOeSOqlGW0PFDRNQ0m11KZtpXnJqCpIV
         pYhrBJtKgQbmQ6/kveBVncPdslrJeYhquqAoCtV9WD8mUfCziuKCjKwna4qznykCZWAf
         giHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=T9Idy/BmZn9IZefa6c48sS4dzGuqqOJAnrsSY8u5SVQ=;
        b=dHfGU2SQ/2enUwrGM7D2WuqqR7yaLvhioK2HjEKiG60imh5sxpQLAuoL8SoL79OpUx
         4Zi792jTeea1ia/1aFvkm0wYB6D+wyiWbZ3xCbzdYPnNzoOwK4IImCu+woNYGLvroZ8d
         5xuTv2S9u/HzJ7WX9IqpjRO8adi4FK8SyMsv6dMGuGB2buHq65jzGS8As5Xgd4UHhkty
         zXVkHxapOFfV7ffK050/6PNa7FUuzX1CrE6kaTStQH6YVDuEYvrLO8SCqrpgn1aNyZdR
         jQDxWLk6WyuoUSFuhukwKISk9xJnNL3DcU6D4TXBHDReMZu6Gs0ywbMphf3QOnwEygq5
         Rubg==
X-Gm-Message-State: AOAM533Z3/FzBt5uHHrzVFeyBnZHpKzI5QHHhBBDbYZLBpNYHndm1zOf
        HxCD0bqmJVXi/BKjiYwDDZMsHxlRTGZmP4APKMc5og==
X-Google-Smtp-Source: ABdhPJxrKKgXuoMLuGb+Q0QiKVucIghYoqyd+lUBC1Ps0+X8ZsbGk0mjC6WsyUHWRr3Bc/Dyf7pIPhjh2yOG7Aq8IQU=
X-Received: by 2002:a4a:9c0f:: with SMTP id y15mr2933051ooj.81.1597104347968;
 Mon, 10 Aug 2020 17:05:47 -0700 (PDT)
MIME-Version: 1.0
References: <20200807084841.7112-1-chenyi.qiang@intel.com> <20200807084841.7112-8-chenyi.qiang@intel.com>
In-Reply-To: <20200807084841.7112-8-chenyi.qiang@intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 10 Aug 2020 17:05:36 -0700
Message-ID: <CALMp9eTAo3WO5Vk_LptTDZLzymJ_96=UhRipyzTXXLxWJRGdXg@mail.gmail.com>
Subject: Re: [RFC 7/7] KVM: VMX: Enable PKS for nested VM
To:     Chenyi Qiang <chenyi.qiang@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 7, 2020 at 1:47 AM Chenyi Qiang <chenyi.qiang@intel.com> wrote:
>
> PKS MSR passes through guest directly. Configure the MSR to match the
> L0/L1 settings so that nested VM runs PKS properly.
>
> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 32 ++++++++++++++++++++++++++++++++
>  arch/x86/kvm/vmx/vmcs12.c |  2 ++
>  arch/x86/kvm/vmx/vmcs12.h |  6 +++++-
>  arch/x86/kvm/vmx/vmx.c    | 10 ++++++++++
>  arch/x86/kvm/vmx/vmx.h    |  1 +
>  5 files changed, 50 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index df2c2e733549..1f9823d21ecd 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -647,6 +647,12 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
>                                         MSR_IA32_PRED_CMD,
>                                         MSR_TYPE_W);
>
> +       if (!msr_write_intercepted_l01(vcpu, MSR_IA32_PKRS))
> +               nested_vmx_disable_intercept_for_msr(
> +                                       msr_bitmap_l1, msr_bitmap_l0,
> +                                       MSR_IA32_PKRS,
> +                                       MSR_TYPE_R | MSR_TYPE_W);

What if L1 intercepts only *reads* of MSR_IA32_PKRS?

>         kvm_vcpu_unmap(vcpu, &to_vmx(vcpu)->nested.msr_bitmap_map, false);
>
>         return true;

> @@ -2509,6 +2519,11 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
>         if (kvm_mpx_supported() && (!vmx->nested.nested_run_pending ||
>             !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS)))
>                 vmcs_write64(GUEST_BNDCFGS, vmx->nested.vmcs01_guest_bndcfgs);
> +
> +       if (kvm_cpu_cap_has(X86_FEATURE_PKS) &&

Is the above check superfluous? I would assume that the L1 guest can't
set VM_ENTRY_LOAD_IA32_PKRS unless this is true.

> +           (!vmx->nested.nested_run_pending ||
> +            !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PKRS)))
> +               vmcs_write64(GUEST_IA32_PKRS, vmx->nested.vmcs01_guest_pkrs);

This doesn't seem right to me. On the target of a live migration, with
L2 active at the time the snapshot was taken (i.e.,
vmx->nested.nested_run_pending=0), it looks like we're going to try to
overwrite the current L2 PKRS value with L1's PKRS value (except that
in this situation, vmx->nested.vmcs01_guest_pkrs should actually be
0). Am I missing something?

>         vmx_set_rflags(vcpu, vmcs12->guest_rflags);
>
>         /* EXCEPTION_BITMAP and CR0_GUEST_HOST_MASK should basically be the


> @@ -3916,6 +3943,8 @@ static void sync_vmcs02_to_vmcs12_rare(struct kvm_vcpu *vcpu,
>                 vmcs_readl(GUEST_PENDING_DBG_EXCEPTIONS);
>         if (kvm_mpx_supported())
>                 vmcs12->guest_bndcfgs = vmcs_read64(GUEST_BNDCFGS);
> +       if (kvm_cpu_cap_has(X86_FEATURE_PKS))

Shouldn't we be checking to see if the *virtual* CPU supports PKS
before writing anything into vmcs12->guest_ia32_pkrs?

> +               vmcs12->guest_ia32_pkrs = vmcs_read64(GUEST_IA32_PKRS);
>
>         vmx->nested.need_sync_vmcs02_to_vmcs12_rare = false;
>  }
