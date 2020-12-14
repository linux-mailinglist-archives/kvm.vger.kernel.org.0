Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3E202DA28F
	for <lists+kvm@lfdr.de>; Mon, 14 Dec 2020 22:29:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388054AbgLNV2v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Dec 2020 16:28:51 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36518 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387395AbgLNV2v (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 14 Dec 2020 16:28:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607981244;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AiHWHoEInnKT+64cA54IotGsqnxbMsYqQmAuPsXNvw0=;
        b=CNhWqpQzOE8u4IAYIXIdLZogGyDUuiPzNr02ZxwcZw616iqzBIO9vzNZ3A64madjHe2vR7
        2Yj30UahVwzLV+fGj4t6Tkayx+0nYTEDpTxItAYPtX7KKreiZUSk7zoefpooOZ85N07rhz
        60An58/zI1NvZ7BjNs9pPiVnKmVOIyE=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-27-nJ0HcvRwNtG3qSJtg-ZZvg-1; Mon, 14 Dec 2020 16:27:23 -0500
X-MC-Unique: nJ0HcvRwNtG3qSJtg-ZZvg-1
Received: by mail-ed1-f71.google.com with SMTP id bf13so8884188edb.10
        for <kvm@vger.kernel.org>; Mon, 14 Dec 2020 13:27:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=AiHWHoEInnKT+64cA54IotGsqnxbMsYqQmAuPsXNvw0=;
        b=SNmJfXeurOP4jSIETuetYn3g5/kOivnJGBbFoqcJcD4igtegSj7AKH7b1LqtfBIPGl
         QJQTFUjZDY+/eaKwJhaUWA28xPeHoKCwKUTV36q8p/I6if8T6aWE/XR5+T0Y4YP3pnKj
         vjXGlCpG2K7hS/uRIyPG4Jsdkc3zbj0LLxEIwbuGBi2lWzzKmbDedVdT7RKm6fEqhxIX
         hNR1jbLpU7R+tvAZ2Pbo9SfQ+ZTZUzSzu7AaOm2z9+/wgSP4YJoMNWi2/2V+CRYekjA+
         EpCppQxjQK0fpjGI5rFbcpT5x+HABCKRt2002x8eplSP257a4HUB8tMlUHItDXY3dyQD
         51JA==
X-Gm-Message-State: AOAM530y4fQz6cCHU1rPjGyvDu2NQ8wMjOZh0solzgGNzuFfBHQZ5Jxy
        ZYiSL2lNMf9JmwA5i9dyz/7SnmvBMcl3tDAdWdQ/+7qMS+m89/I2s/J/ZHBMLQtITyVHHgNqUc1
        H6DN9iDI8vgoO
X-Received: by 2002:a50:8004:: with SMTP id 4mr12549958eda.329.1607981241962;
        Mon, 14 Dec 2020 13:27:21 -0800 (PST)
X-Google-Smtp-Source: ABdhPJziFAtkatfh34lT8bfczq/qX7W16IvyDq3Fiy9+5Sc4QvPTfzbAArNmPqovKJ7O5f/KQcwHyQ==
X-Received: by 2002:a50:8004:: with SMTP id 4mr12549952eda.329.1607981241774;
        Mon, 14 Dec 2020 13:27:21 -0800 (PST)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id ak17sm15196440ejc.103.2020.12.14.13.27.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Dec 2020 13:27:21 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>, graf@amazon.com,
        iaslan@amazon.de, pdurrant@amazon.com, aagch@amazon.com,
        fandree@amazon.com
Subject: Re: [PATCH v3 02/17] KVM: x86/xen: fix Xen hypercall page msr handling
In-Reply-To: <20201214083905.2017260-3-dwmw2@infradead.org>
References: <20201214083905.2017260-1-dwmw2@infradead.org>
 <20201214083905.2017260-3-dwmw2@infradead.org>
Date:   Mon, 14 Dec 2020 22:27:19 +0100
Message-ID: <87czzcw020.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

David Woodhouse <dwmw2@infradead.org> writes:

> From: Joao Martins <joao.m.martins@oracle.com>
>
> Xen usually places its MSR at 0x40000000 or 0x40000200 depending on
> whether it is running in viridian mode or not. Note that this is not
> ABI guaranteed, so it is possible for Xen to advertise the MSR some
> place else.
>
> Given the way xen_hvm_config() is handled, if the former address is
> selected, this will conflict with Hyper-V's MSR
> (HV_X64_MSR_GUEST_OS_ID) which unconditionally uses the same address.
>
> Given that the MSR location is arbitrary, move the xen_hvm_config()
> handling to the top of kvm_set_msr_common() before falling through.
>

In case we're making MSR 0x40000000 something different from
HV_X64_MSR_GUEST_OS_ID we can and probably should disable Hyper-V
emulation in KVM completely -- or how else is it going to work?

> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---
>  arch/x86/kvm/x86.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index c7f1ba21212e..13ba4a64f748 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3001,6 +3001,9 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  	u32 msr = msr_info->index;
>  	u64 data = msr_info->data;
>  
> +	if (msr && (msr == vcpu->kvm->arch.xen_hvm_config.msr))
> +		return xen_hvm_config(vcpu, data);
> +

Can we generalize this maybe? E.g. before handling KVM and architectural
MSRs we check that the particular MSR is not overriden by an emulated
hypervisor, 

e.g.
	if (kvm_emulating_hyperv(kvm) && kvm_hyperv_msr_overriden(kvm,msr)
		return kvm_hyperv_handle_msr(kvm, msr);
	if (kvm_emulating_xen(kvm) && kvm_xen_msr_overriden(kvm,msr)
		return kvm_xen_handle_msr(kvm, msr);

	switch (msr) {
		...

>  	switch (msr) {
>  	case MSR_AMD64_NB_CFG:
>  	case MSR_IA32_UCODE_WRITE:
> @@ -3288,8 +3291,6 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  		vcpu->arch.msr_misc_features_enables = data;
>  		break;
>  	default:
> -		if (msr && (msr == vcpu->kvm->arch.xen_hvm_config.msr))
> -			return xen_hvm_config(vcpu, data);
>  		if (kvm_pmu_is_valid_msr(vcpu, msr))
>  			return kvm_pmu_set_msr(vcpu, msr_info);
>  		return KVM_MSR_RET_INVALID;

-- 
Vitaly

