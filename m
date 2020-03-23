Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36CD718F28D
	for <lists+kvm@lfdr.de>; Mon, 23 Mar 2020 11:17:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727884AbgCWKRw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Mar 2020 06:17:52 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:25752 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727860AbgCWKRv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 23 Mar 2020 06:17:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584958670;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SBegzobD/+JNyGfGs322NVPWPfzlbUT6K85bpST1U3Y=;
        b=WXsueIIxCCxu5+uYF3jYw/ubAvYvbHjfPvd8wZsMP6cDFQKwPzqPnUMobGWWqyn2GULzAG
        YEptbXZ63RdP0jrHvw9XNuPmIkRgyhtpBZGThyoMn6uJcpKguOqwr7EyGzmzR7OBsazyL6
        Xsuu1/MDKj8mS9u089UfmB8rBw7MBNI=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-150-p3ETFyIkO9K5DaUGa_yc-w-1; Mon, 23 Mar 2020 06:17:48 -0400
X-MC-Unique: p3ETFyIkO9K5DaUGa_yc-w-1
Received: by mail-wm1-f71.google.com with SMTP id f9so3799319wme.7
        for <kvm@vger.kernel.org>; Mon, 23 Mar 2020 03:17:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=SBegzobD/+JNyGfGs322NVPWPfzlbUT6K85bpST1U3Y=;
        b=tQb+IQ83ZPjAknC3/kLQ87/ZGUrkv04mQuo+Z5gxc2uWsGsXIPSPKR+cFE1FZPlNFT
         x3Qhkf12p5h77Rjk8+U5asBbbTnglhzInZZ0bhhOzU0VKNzv22uI65CRrMBTDFk+6q5x
         Jtpx1WuR6aaxU28Lr2CbYQlbJHsVOnpZy+3L7uvsCgin0+cqf/DEemVhGTyP4EVJLmUX
         hb/RIJci77HTl/YkQaOO7H9ZtFyV2uhqCcswPz2d0inzP/yUZT2tci23CYCFy8u0/wX1
         YobR+gor835A2Nri1ER3bzMVm8GP148GA5X9OyaA4siiZYVc/cOarWIazYGgcfg3/Azu
         JcGw==
X-Gm-Message-State: ANhLgQ3ZybK49Ikhop8wYg7blu4ZcKM3xmw94XpcrKYFVIxvm3ocshS+
        rYILTJPzbkR8eFMGyFI1EHhffzvz6D/obQ5YTu3yoaCC0/mUF21xgFMbWil95D5VRAvb+U8Axb9
        8d1rrD/xHmM33
X-Received: by 2002:a1c:8149:: with SMTP id c70mr26534813wmd.123.1584958667308;
        Mon, 23 Mar 2020 03:17:47 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vtnVvVp+WxtHTgJnh8GmsqpZ8e5y7hT6plLA9DFNNkhc65+F6nhcWa+VutEG9JNrplKbUbvqQ==
X-Received: by 2002:a1c:8149:: with SMTP id c70mr26534787wmd.123.1584958667059;
        Mon, 23 Mar 2020 03:17:47 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id f1sm12997578wrv.37.2020.03.23.03.17.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2020 03:17:46 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Jon Doron <arilou@gmail.com>
Cc:     kvm@vger.kernel.org, linux-hyperv@vger.kernel.org
Subject: Re: [PATCH v9 3/6] x86/hyper-v: Add synthetic debugger definitions
In-Reply-To: <20200320172839.1144395-4-arilou@gmail.com>
References: <20200320172839.1144395-1-arilou@gmail.com> <20200320172839.1144395-4-arilou@gmail.com>
Date:   Mon, 23 Mar 2020 11:17:45 +0100
Message-ID: <87tv2f9xyu.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Jon Doron <arilou@gmail.com> writes:

> Hyper-V synthetic debugger has two modes, one that uses MSRs and
> the other that use Hypercalls.
>
> Add all the required definitions to both types of synthetic debugger
> interface.
>
> Some of the required new CPUIDs and MSRs are not documented in the TLFS
> so they are in hyperv.h instead.
>
> The reason they are not documented is because they are subjected to be
> removed in future versions of Windows.
>
> Signed-off-by: Jon Doron <arilou@gmail.com>

You seem to have lost Michael's R-b tag from v8

> ---
>  arch/x86/include/asm/hyperv-tlfs.h |  6 ++++++
>  arch/x86/kvm/hyperv.h              | 27 +++++++++++++++++++++++++++
>  2 files changed, 33 insertions(+)
>
> diff --git a/arch/x86/include/asm/hyperv-tlfs.h b/arch/x86/include/asm/hyperv-tlfs.h
> index 92abc1e42bfc..671ce2a39d4b 100644
> --- a/arch/x86/include/asm/hyperv-tlfs.h
> +++ b/arch/x86/include/asm/hyperv-tlfs.h
> @@ -131,6 +131,8 @@
>  #define HV_FEATURE_FREQUENCY_MSRS_AVAILABLE		BIT(8)
>  /* Crash MSR available */
>  #define HV_FEATURE_GUEST_CRASH_MSR_AVAILABLE		BIT(10)
> +/* Support for debug MSRs available */
> +#define HV_FEATURE_DEBUG_MSRS_AVAILABLE			BIT(11)
>  /* stimer Direct Mode is available */
>  #define HV_STIMER_DIRECT_MODE_AVAILABLE			BIT(19)
>  
> @@ -376,6 +378,9 @@ struct hv_tsc_emulation_status {
>  #define HVCALL_SEND_IPI_EX			0x0015
>  #define HVCALL_POST_MESSAGE			0x005c
>  #define HVCALL_SIGNAL_EVENT			0x005d
> +#define HVCALL_POST_DEBUG_DATA			0x0069
> +#define HVCALL_RETRIEVE_DEBUG_DATA		0x006a
> +#define HVCALL_RESET_DEBUG_SESSION		0x006b
>  #define HVCALL_FLUSH_GUEST_PHYSICAL_ADDRESS_SPACE 0x00af
>  #define HVCALL_FLUSH_GUEST_PHYSICAL_ADDRESS_LIST 0x00b0
>  
> @@ -419,6 +424,7 @@ enum HV_GENERIC_SET_FORMAT {
>  #define HV_STATUS_INVALID_HYPERCALL_INPUT	3
>  #define HV_STATUS_INVALID_ALIGNMENT		4
>  #define HV_STATUS_INVALID_PARAMETER		5
> +#define HV_STATUS_OPERATION_DENIED		8
>  #define HV_STATUS_INSUFFICIENT_MEMORY		11
>  #define HV_STATUS_INVALID_PORT_ID		17
>  #define HV_STATUS_INVALID_CONNECTION_ID		18
> diff --git a/arch/x86/kvm/hyperv.h b/arch/x86/kvm/hyperv.h
> index 757cb578101c..5e4780bf6dd7 100644
> --- a/arch/x86/kvm/hyperv.h
> +++ b/arch/x86/kvm/hyperv.h
> @@ -23,6 +23,33 @@
>  
>  #include <linux/kvm_host.h>
>  
> +/*
> + * The #defines related to the synthetic debugger are required by KDNet, but
> + * they are not documented in the Hyper-V TLFS because the synthetic debugger
> + * functionality has been deprecated and is subject to removal in future versions
> + * of Windows.
> + */
> +#define HYPERV_CPUID_SYNDBG_VENDOR_AND_MAX_FUNCTIONS	0x40000080
> +#define HYPERV_CPUID_SYNDBG_INTERFACE			0x40000081
> +#define HYPERV_CPUID_SYNDBG_PLATFORM_CAPABILITIES	0x40000082
> +
> +/*
> + * Hyper-V synthetic debugger platform capabilities
> + * These are HYPERV_CPUID_SYNDBG_PLATFORM_CAPABILITIES.EAX bits.
> + */
> +#define HV_X64_SYNDBG_CAP_ALLOW_KERNEL_DEBUGGING	BIT(1)
> +
> +/* Hyper-V Synthetic debug options MSR */
> +#define HV_X64_MSR_SYNDBG_CONTROL		0x400000F1
> +#define HV_X64_MSR_SYNDBG_STATUS		0x400000F2
> +#define HV_X64_MSR_SYNDBG_SEND_BUFFER		0x400000F3
> +#define HV_X64_MSR_SYNDBG_RECV_BUFFER		0x400000F4
> +#define HV_X64_MSR_SYNDBG_PENDING_BUFFER	0x400000F5
> +#define HV_X64_MSR_SYNDBG_OPTIONS		0x400000FF
> +
> +/* Hyper-V HV_X64_MSR_SYNDBG_OPTIONS bits */
> +#define HV_X64_SYNDBG_OPTION_USE_HCALLS		BIT(2)
> +
>  static inline struct kvm_vcpu_hv *vcpu_to_hv_vcpu(struct kvm_vcpu *vcpu)
>  {
>  	return &vcpu->arch.hyperv;

-- 
Vitaly

