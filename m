Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D5B64981BC
	for <lists+kvm@lfdr.de>; Mon, 24 Jan 2022 15:06:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238588AbiAXOG0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jan 2022 09:06:26 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:51955 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238491AbiAXOGZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 Jan 2022 09:06:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643033184;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3B10e921xZddkTw00BqLjragzZqDktB8hEHYxTuVaJs=;
        b=ajT0rKUhxtUaicpF2qii1kTWOcpyebuRCIWHT1n5lRe/IvtwzJzVdFRPLlJjTyeTSH4PAf
        1t+X2YWt0uLYmCxyotBAcTUMDdR9KfEN0+iZisSveuhkscIkePdRi+5wCukp+eJVve5bKY
        EL1SsQ52iGqurCL+3CM2iOR0PItbcJ0=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-193-lkHi5XIWMkOGpFmXyqcv4g-1; Mon, 24 Jan 2022 09:06:23 -0500
X-MC-Unique: lkHi5XIWMkOGpFmXyqcv4g-1
Received: by mail-ed1-f69.google.com with SMTP id h21-20020aa7c955000000b0040390b2bfc5so13149782edt.15
        for <kvm@vger.kernel.org>; Mon, 24 Jan 2022 06:06:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=3B10e921xZddkTw00BqLjragzZqDktB8hEHYxTuVaJs=;
        b=kskyM/24n+lyBrh8clQ+250QAg+zzzBdR6Om3TzMxeuzY/WAsXJu2QOcowxx2Q8BEC
         w13cZ64nMKxnoMIh9HWuj3WD2NDiZPVJf3+hjqp4uHexqktSXbqjJXryLz6WaON/PdbU
         nKOvfqpwihoQpsBgBzZ6ldfe3Y6M7hUCFbl6yABFBmJ38etR6Q7ZxtlCAjJQX9R4ONZO
         +zfd9aQ4gnHkTpXcndT1tfrZ5cmU1Vk7LsDzoI6fwx6q2/b6OqjiTTmpIViV1oM+QiYI
         U+wPdLc+1vxqO7rcsOWFo7/P81QNVVSJ90HhSG8puRlPFI3F3aEPVIqh/VwRYRtGzAsP
         4AIw==
X-Gm-Message-State: AOAM532XQWMusRsty7mRJ4RGY8TvnCNCqmfdDLZoh+SM5/1qOBUrOv72
        JXPgt/ow6HUlPTRDLRo1EhBHdCvp4D+ZaM9OVOTLdVsA9+Tpovuc/91J/16IL9T85S5E6ZvBV5L
        uRJ9iZNQDZns7
X-Received: by 2002:a17:906:a1d1:: with SMTP id bx17mr12613561ejb.602.1643033181955;
        Mon, 24 Jan 2022 06:06:21 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyTiLIGoxL9tWkKpHxm1x0zJkvBGM4dYpzQfw2LMSzTCvfMfDSiG+yUwBdyzgP4jBfEgX1s9g==
X-Received: by 2002:a17:906:a1d1:: with SMTP id bx17mr12613535ejb.602.1643033181656;
        Mon, 24 Jan 2022 06:06:21 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id cr8sm6638843edb.47.2022.01.24.06.06.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Jan 2022 06:06:21 -0800 (PST)
Message-ID: <5dcfe32a-1a1c-0f5b-6c4e-183236e86413@redhat.com>
Date:   Mon, 24 Jan 2022 15:06:20 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH] KVM: VMX: Set vmcs.PENDING_DBG.BS on #DB in STI/MOVSS
 blocking shadow
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        David Woodhouse <dwmw2@infradead.org>,
        Alexander Graf <graf@amazon.de>
References: <20220120000624.655815-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220120000624.655815-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/20/22 01:06, Sean Christopherson wrote:
> Set vmcs.GUEST_PENDING_DBG_EXCEPTIONS.BS, a.k.a. the pending single-step
> breakpoint flag, when re-injecting a #DB with RFLAGS.TF=1, and STI or
> MOVSS blocking is active.  Setting the flag is necessary to make VM-Entry
> consistency checks happy, as VMX has an invariant that if RFLAGS.TF is
> set and STI/MOVSS blocking is true, then the previous instruction must
> have been STI or MOV/POP, and therefore a single-step #DB must be pending
> since the RFLAGS.TF cannot have been set by the previous instruction,
> i.e. the one instruction delay after setting RFLAGS.TF must have already
> expired.
> 
> Normally, the CPU sets vmcs.GUEST_PENDING_DBG_EXCEPTIONS.BS appropriately
> when recording guest state as part of a VM-Exit, but #DB VM-Exits
> intentionally do not treat the #DB as "guest state" as interception of
> the #DB effectively makes the #DB host-owned, thus KVM needs to manually
> set PENDING_DBG.BS when forwarding/re-injecting the #DB to the guest.
> 
> Note, although this bug can be triggered by guest userspace, doing so
> requires IOPL=3, and guest userspace running with IOPL=3 has full access
> to all I/O ports (from the guest's perspective) and can crash/reboot the
> guest any number of ways.  IOPL=3 is required because STI blocking kicks
> in if and only if RFLAGS.IF is toggled 0=>1, and if CPL>IOPL, STI either
> takes a #GP or modifies RFLAGS.VIF, not RFLAGS.IF.
> 
> MOVSS blocking can be initiated by userspace, but can be coincident with
> a #DB if and only if DR7.GD=1 (General Detect enabled) and a MOV DR is
> executed in the MOVSS shadow.  MOV DR #GPs at CPL>0, thus MOVSS blocking
> is problematic only for CPL0 (and only if the guest is crazy enough to
> access a DR in a MOVSS shadow).  All other sources of #DBs are either
> suppressed by MOVSS blocking (single-step, code fetch, data, and I/O),
> are mutually exclusive with MOVSS blocking (T-bit task switch), or are
> already handled by KVM (ICEBP, a.k.a. INT1).
> 
> This bug was originally found by running tests[1] created for XSA-308[2].
> Note that Xen's userspace test emits ICEBP in the MOVSS shadow, which is
> presumably why the Xen bug was deemed to be an exploitable DOS from guest
> userspace.  KVM already handles ICEBP by skipping the ICEBP instruction
> and thus clears MOVSS blocking as a side effect of its "emulation".
> 
> [1] http://xenbits.xenproject.org/docs/xtf/xsa-308_2main_8c_source.html
> [2] https://xenbits.xen.org/xsa/advisory-308.html
> 
> Reported-by: David Woodhouse <dwmw2@infradead.org>
> Reported-by: Alexander Graf <graf@amazon.de>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/vmx/vmx.c | 25 +++++++++++++++++++++++++
>   1 file changed, 25 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index a02a28ce7cc3..3f7b09a24d1e 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -4901,8 +4901,33 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
>   		dr6 = vmx_get_exit_qual(vcpu);
>   		if (!(vcpu->guest_debug &
>   		      (KVM_GUESTDBG_SINGLESTEP | KVM_GUESTDBG_USE_HW_BP))) {
> +			/*
> +			 * If the #DB was due to ICEBP, a.k.a. INT1, skip the
> +			 * instruction.  ICEBP generates a trap-like #DB, but
> +			 * despite its interception control being tied to #DB,
> +			 * is an instruction intercept, i.e. the VM-Exit occurs
> +			 * on the ICEBP itself.  Note, skipping ICEBP also
> +			 * clears STI and MOVSS blocking.
> +			 *
> +			 * For all other #DBs, set vmcs.PENDING_DBG_EXCEPTIONS.BS
> +			 * if single-step is enabled in RFLAGS and STI or MOVSS
> +			 * blocking is active, as the CPU doesn't set the bit
> +			 * on VM-Exit due to #DB interception.  VM-Entry has a
> +			 * consistency check that a single-step #DB is pending
> +			 * in this scenario as the previous instruction cannot
> +			 * have toggled RFLAGS.TF 0=>1 (because STI and POP/MOV
> +			 * don't modify RFLAGS), therefore the one instruction
> +			 * delay when activating single-step breakpoints must
> +			 * have already expired.  Note, the CPU sets/clears BS
> +			 * as appropriate for all other VM-Exits types.
> +			 */
>   			if (is_icebp(intr_info))
>   				WARN_ON(!skip_emulated_instruction(vcpu));
> +			else if ((vmx_get_rflags(vcpu) & X86_EFLAGS_TF) &&
> +				 (vmcs_read32(GUEST_INTERRUPTIBILITY_INFO) &
> +				  (GUEST_INTR_STATE_STI | GUEST_INTR_STATE_MOV_SS)))
> +				vmcs_writel(GUEST_PENDING_DBG_EXCEPTIONS,
> +					    vmcs_readl(GUEST_PENDING_DBG_EXCEPTIONS) | DR6_BS);
>   
>   			kvm_queue_exception_p(vcpu, DB_VECTOR, dr6);
>   			return 1;
> 
> base-commit: edb9e50dbe18394d0fc9d0494f5b6046fc912d33

Queued, thanks.

Paolo

