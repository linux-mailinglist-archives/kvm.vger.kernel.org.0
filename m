Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3EA01B2639
	for <lists+kvm@lfdr.de>; Tue, 21 Apr 2020 14:37:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728735AbgDUMhK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Apr 2020 08:37:10 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:48003 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728316AbgDUMhH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Apr 2020 08:37:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587472626;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uHRH2SO9rgQg45MN9oy6mGEeOMByu5pPDg4n8AyabMg=;
        b=RZhpIuB9l4e9jLGT/YyGRlq0kWXCqYmni48yivdu1NBboUZHpXdAi0GpVThSgeubkreErk
        cl/R+PtL+8e6nXn2baOnypMqrSgw/mh0E8arPAxsU/rNbrkyNg7uB/S2ywc1CYaTUS14QB
        asvcRU7mm4xLQMV0o+04lAGXQf/oKAs=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-271-zVcifpL7Okm8nPle9PKnXg-1; Tue, 21 Apr 2020 08:37:04 -0400
X-MC-Unique: zVcifpL7Okm8nPle9PKnXg-1
Received: by mail-wm1-f72.google.com with SMTP id f128so1368763wmf.8
        for <kvm@vger.kernel.org>; Tue, 21 Apr 2020 05:37:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=uHRH2SO9rgQg45MN9oy6mGEeOMByu5pPDg4n8AyabMg=;
        b=kegYWup09Hlz8oRat9ktFo2il+nzN4jEHswa2p7+Zw3gZpOp+YvcnOMKXQcUG0LUOh
         Oy8VVFtQe6xDN0P25GlGNvP1Ja8b+uCf8dlnXbEglRkQLXnXE00ZP1fcfyylEN1xN+F9
         i6mAR8hZpi7fy8BefqDwZw3QlktsH2CI243rkhe4s5liA4y0KTUt7UnWdsCcTd7/i3UI
         f3L3GoR8f0BgPGZ5cNnyoKiNM320sBn1gFPycdp+4WRXlA2hx2UyJXLlZgaMbVrzUUDo
         bcWDUZmxUCjD2lVXViX+J2syV/DXb+x4yS8hFaj7qeh8885gQrvSNx2JQ+MOegWu31WF
         Ad3Q==
X-Gm-Message-State: AGi0PuYhWm0lX35Z65OLZ03Cq/pTjMGG2Ief4WJGfksulf4oJqRbvUUu
        eUsG56kfRwcAKGkS57bxyki6Na6W4XSyWWUm/oD/rishTd+7fI14yedKiUCFjsGswYYVlJokEFK
        V/KO3Z36on5ji
X-Received: by 2002:a1c:4946:: with SMTP id w67mr4950926wma.38.1587472623775;
        Tue, 21 Apr 2020 05:37:03 -0700 (PDT)
X-Google-Smtp-Source: APiQypKMxxoaz3tu+EP9Ew3Y/+Ep51ZZYDg6AT+0M4N/rJpFNjBwAZHddS937BZwbdysniVN2B1olQ==
X-Received: by 2002:a1c:4946:: with SMTP id w67mr4950904wma.38.1587472623567;
        Tue, 21 Apr 2020 05:37:03 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id b82sm3568902wmh.1.2020.04.21.05.37.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2020 05:37:02 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Michael Kelley <mikelley@microsoft.com>
Cc:     mikelley@microsoft.com, kys@microsoft.com, haiyangz@microsoft.com,
        sthemmin@microsoft.com, wei.liu@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        pbonzini@redhat.com, sean.j.christopherson@intel.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org
Subject: Re: [PATCH 1/4] KVM: x86: hyperv: Remove duplicate definitions of Reference TSC Page
In-Reply-To: <20200420173838.24672-2-mikelley@microsoft.com>
References: <20200420173838.24672-1-mikelley@microsoft.com> <20200420173838.24672-2-mikelley@microsoft.com>
Date:   Tue, 21 Apr 2020 14:37:01 +0200
Message-ID: <874ktdrp5e.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Michael Kelley <mikelley@microsoft.com> writes:

> The Hyper-V Reference TSC Page structure is defined twice. struct
> ms_hyperv_tsc_page has padding out to a full 4 Kbyte page size. But
> the padding is not needed because the declaration includes a union
> with HV_HYP_PAGE_SIZE.  KVM uses the second definition, which is
> struct _HV_REFERENCE_TSC_PAGE, because it does not have the padding.
>
> Fix the duplication by removing the padding from ms_hyperv_tsc_page.
> Fix up the KVM code to use it. Remove the no longer used struct
> _HV_REFERENCE_TSC_PAGE.
>
> There is no functional change.
>
> Signed-off-by: Michael Kelley <mikelley@microsoft.com>
> ---
>  arch/x86/include/asm/hyperv-tlfs.h | 8 --------
>  arch/x86/include/asm/kvm_host.h    | 2 +-
>  arch/x86/kvm/hyperv.c              | 4 ++--
>  3 files changed, 3 insertions(+), 11 deletions(-)
>
> diff --git a/arch/x86/include/asm/hyperv-tlfs.h b/arch/x86/include/asm/hyperv-tlfs.h
> index 29336574d0bc..0e4d76920957 100644
> --- a/arch/x86/include/asm/hyperv-tlfs.h
> +++ b/arch/x86/include/asm/hyperv-tlfs.h
> @@ -303,7 +303,6 @@ struct ms_hyperv_tsc_page {
>  	u32 reserved1;
>  	volatile u64 tsc_scale;
>  	volatile s64 tsc_offset;
> -	u64 reserved2[509];
>  }  __packed;
>  
>  /*
> @@ -433,13 +432,6 @@ enum HV_GENERIC_SET_FORMAT {
>   */
>  #define HV_CLOCK_HZ (NSEC_PER_SEC/100)
>  
> -typedef struct _HV_REFERENCE_TSC_PAGE {
> -	__u32 tsc_sequence;
> -	__u32 res1;
> -	__u64 tsc_scale;
> -	__s64 tsc_offset;
> -}  __packed HV_REFERENCE_TSC_PAGE, *PHV_REFERENCE_TSC_PAGE;
> -
>  /* Define the number of synthetic interrupt sources. */
>  #define HV_SYNIC_SINT_COUNT		(16)
>  /* Define the expected SynIC version. */
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 42a2d0d3984a..4698343b9a05 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -865,7 +865,7 @@ struct kvm_hv {
>  	u64 hv_crash_param[HV_X64_MSR_CRASH_PARAMS];
>  	u64 hv_crash_ctl;
>  
> -	HV_REFERENCE_TSC_PAGE tsc_ref;
> +	struct ms_hyperv_tsc_page tsc_ref;
>  
>  	struct idr conn_to_evt;
>  
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index bcefa9d4e57e..1f3c6fd3cdaa 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -900,7 +900,7 @@ static int kvm_hv_msr_set_crash_data(struct kvm_vcpu *vcpu,
>   * These two equivalencies are implemented in this function.
>   */
>  static bool compute_tsc_page_parameters(struct pvclock_vcpu_time_info *hv_clock,
> -					HV_REFERENCE_TSC_PAGE *tsc_ref)
> +					struct ms_hyperv_tsc_page *tsc_ref)
>  {
>  	u64 max_mul;
>  
> @@ -941,7 +941,7 @@ void kvm_hv_setup_tsc_page(struct kvm *kvm,
>  	u64 gfn;
>  
>  	BUILD_BUG_ON(sizeof(tsc_seq) != sizeof(hv->tsc_ref.tsc_sequence));
> -	BUILD_BUG_ON(offsetof(HV_REFERENCE_TSC_PAGE, tsc_sequence) != 0);
> +	BUILD_BUG_ON(offsetof(struct ms_hyperv_tsc_page, tsc_sequence) != 0);
>  
>  	if (!(hv->hv_tsc_page & HV_X64_MSR_TSC_REFERENCE_ENABLE))
>  		return;

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

