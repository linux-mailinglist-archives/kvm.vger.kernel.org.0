Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CCE4160DE0
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2020 09:57:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728665AbgBQI5q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Feb 2020 03:57:46 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:37984 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728627AbgBQI5q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Feb 2020 03:57:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581929864;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3kliMoTg8Lcr/Q7CgDewoOkhEDiCmvd3cNoaAkKHe/Y=;
        b=auCaW1VSjye6vuCMqNGupsLq8NZvDqMHsVofNwJmOvzSNDZ3RjbpO79gEM3E+p0fPh/MkA
        0+Qz1pKpyrKfutU8G/LTqUGQF6OPYOKcqDf5dargLPgWdf9zRm3p5IVjY9alsDCv9g88Gv
        CGMA6pbe9VsWDsdVRlwdsCWtq9tD2w4=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-109-ha0fjl83N-2ESdtwfYKHCw-1; Mon, 17 Feb 2020 03:57:42 -0500
X-MC-Unique: ha0fjl83N-2ESdtwfYKHCw-1
Received: by mail-wm1-f71.google.com with SMTP id t17so5939362wmi.7
        for <kvm@vger.kernel.org>; Mon, 17 Feb 2020 00:57:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=3kliMoTg8Lcr/Q7CgDewoOkhEDiCmvd3cNoaAkKHe/Y=;
        b=NdMJ/Gk2bcTzquX3wq/X3S/3K39QDw10zyUTrb3/xTpbIKU3TlJBSqu15+cfYQGRuy
         YBqOGoh+i9Rjstp7Wax6Vwo3fv7hSgEQWTfUIEtVEHEHOYqojdFiAX3PZJNc/jZs+8++
         PKgGgPcCVK6Yj59Fur1AlpO0Bz8ma4nSftZAqq5Fq9b0owwoR5IC0mzobXlf7CNhDE96
         T7e3eGEac+QGdcYV9TfbtoUuoFYRh3eF1b1KxdpLkh3gvGLlKvf9c3L1U6jFsbGqseVk
         hKTp3Hd8Wp4XdHP6ohIRClLfZU42yLOQZueEzOECEVPF2Nixu+1pIYY93wl6Sxrztshn
         /6KQ==
X-Gm-Message-State: APjAAAUotoml9QbTcx/eAq//Y5pghm05DOoDbcFr2k/xN4nqIr3nFZqO
        r3BEXTbXlMR42pxnR++wvJOoE94vYBVorjDghKcfoC9zUwgPC0I83faWZ6kBzLDGRIjH7/DFpC2
        R+8tN41kjCbBe
X-Received: by 2002:a1c:de55:: with SMTP id v82mr20900110wmg.48.1581929861776;
        Mon, 17 Feb 2020 00:57:41 -0800 (PST)
X-Google-Smtp-Source: APXvYqxRwndD3XkbOjhzvAUd57i0vfL669NBYdxTAMC8FbfyAoZr0mnZXFUeHf/l3jE2cYXdPNgHLA==
X-Received: by 2002:a1c:de55:: with SMTP id v82mr20900070wmg.48.1581929861516;
        Mon, 17 Feb 2020 00:57:41 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id t13sm19655105wrw.19.2020.02.17.00.57.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Feb 2020 00:57:40 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     linmiaohe <linmiaohe@huawei.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        pbonzini@redhat.com, rkrcmar@redhat.com,
        sean.j.christopherson@intel.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com
Subject: Re: [PATCH] KVM: x86: Fix print format and coding style
In-Reply-To: <1581734662-970-1-git-send-email-linmiaohe@huawei.com>
References: <1581734662-970-1-git-send-email-linmiaohe@huawei.com>
Date:   Mon, 17 Feb 2020 09:57:40 +0100
Message-ID: <87o8txbngb.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

linmiaohe <linmiaohe@huawei.com> writes:

> From: Miaohe Lin <linmiaohe@huawei.com>
>
> Use %u to print u32 var and correct some coding style.
>
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
> ---
>  arch/x86/kvm/i8254.c      | 2 +-
>  arch/x86/kvm/mmu/mmu.c    | 3 +--
>  arch/x86/kvm/vmx/nested.c | 2 +-
>  3 files changed, 3 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/kvm/i8254.c b/arch/x86/kvm/i8254.c
> index b24c606ac04b..febca334c320 100644
> --- a/arch/x86/kvm/i8254.c
> +++ b/arch/x86/kvm/i8254.c
> @@ -367,7 +367,7 @@ static void pit_load_count(struct kvm_pit *pit, int channel, u32 val)
>  {
>  	struct kvm_kpit_state *ps = &pit->pit_state;
>  
> -	pr_debug("load_count val is %d, channel is %d\n", val, channel);
> +	pr_debug("load_count val is %u, channel is %d\n", val, channel);
>  
>  	/*
>  	 * The largest possible initial count is 0; this is equivalent
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 7011a4e54866..9c228b9910b1 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3568,8 +3568,7 @@ static bool fast_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>  		 * write-protected for dirty-logging or access tracking.
>  		 */
>  		if ((error_code & PFERR_WRITE_MASK) &&
> -		    spte_can_locklessly_be_made_writable(spte))
> -		{
> +		    spte_can_locklessly_be_made_writable(spte)) {
>  			new_spte |= PT_WRITABLE_MASK;
>  
>  			/*
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index f2d8cb68dce8..6f3e515f28fd 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -4367,7 +4367,7 @@ int get_vmx_mem_address(struct kvm_vcpu *vcpu, unsigned long exit_qualification,
>  	if (base_is_valid)
>  		off += kvm_register_read(vcpu, base_reg);
>  	if (index_is_valid)
> -		off += kvm_register_read(vcpu, index_reg)<<scaling;
> +		off += kvm_register_read(vcpu, index_reg) << scaling;
>  	vmx_get_segment(vcpu, &s, seg_reg);
>  
>  	/*

I would've suggested we split such unrelated changes by source files in
the future to simplify (possible) stable backporting. Changes themselves
look good,

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

