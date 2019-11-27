Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 939C910ADF9
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2019 11:41:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727533AbfK0KlJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Nov 2019 05:41:09 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:36426 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727050AbfK0Kjg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 27 Nov 2019 05:39:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574851174;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=xlWX1Ny6pqFU4LHewnEHeIeuGhxS79zKsMZTSIq/B5g=;
        b=hRlTKatmcB8WULu5n/y4tWDMl0Bt5X/I0rTesF+1dZfoCSSnM2YR41oHtaaPztEuDbuDMe
        5vyVXSgHNs2MwT3UWxnA6Y0qfoTa1OXpIH5j/7wcb7LuCPNsSBi0GZCfvaEEtaax5AUpKd
        DzwGWWgzZQrJrB9t2NKyCzd0zDjGJ0k=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-176-4ndVCtynPlaA67zzyZR0SQ-1; Wed, 27 Nov 2019 05:39:33 -0500
Received: by mail-wm1-f69.google.com with SMTP id t203so2216065wmt.7
        for <kvm@vger.kernel.org>; Wed, 27 Nov 2019 02:39:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xlWX1Ny6pqFU4LHewnEHeIeuGhxS79zKsMZTSIq/B5g=;
        b=MlbU3026C0X6uFljK98exaRYSqjqkjp5F3xa6vGBJ7B34vz+IvpWxeO428kZDa8ddr
         ID1sWi2VSlxt7EhxlzzUCFLRSVixMHSXYdKlzln5k0jpRxdxENbRyUNaPJ0beeMO7Ouy
         25tS/sPo5n3+MrmQcjSzujMwQuXt/654PP9TdUlJ3xczeziCZA/MPApMugWgcxYoWC54
         zcr36a3bs5tigsucaYBxwFb6bXOmW3z7U6bjZZsbYYLOMBNMSqUqLQOYb6b3EU8E5sjJ
         toyXzipMRItv/DqerDaMb0piW8C1tMK5Y/qpg+WGvosBxdGEHoBLL0RdBshVoUaXPvoJ
         svMw==
X-Gm-Message-State: APjAAAVT4ZV/S+MbhuB5bvVr2WefwxlinK0hWxpXPjSslXWc/kVNIeCr
        rVxHLxG9w2SjS/f27oAX6pF6YF2X+viyWeuwrFtOUE64/MkDUgy+YXnZc1iwMYhHRdCkVx5rh8P
        TlhpNmRooK8bT
X-Received: by 2002:adf:f802:: with SMTP id s2mr10279690wrp.201.1574851172345;
        Wed, 27 Nov 2019 02:39:32 -0800 (PST)
X-Google-Smtp-Source: APXvYqx5QClQzhTKI4IJHgn637p/tJmCpHXQBovNvDXnxN3v+upY7s57WShMqK696GbL1Vg+sfqlCA==
X-Received: by 2002:adf:f802:: with SMTP id s2mr10279665wrp.201.1574851172064;
        Wed, 27 Nov 2019 02:39:32 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:14d1:f071:7005:15b2? ([2001:b07:6468:f312:14d1:f071:7005:15b2])
        by smtp.gmail.com with ESMTPSA id i71sm20510598wri.68.2019.11.27.02.39.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Nov 2019 02:39:31 -0800 (PST)
Subject: Re: [PATCH 1/2] KVM x86: Move kvm cpuid support out of svm
To:     Peter Gonda <pgonda@google.com>, kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <20191121203344.156835-1-pgonda@google.com>
 <20191121203344.156835-2-pgonda@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <57294522-0021-8d50-5027-6c4a8af77347@redhat.com>
Date:   Wed, 27 Nov 2019 11:39:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191121203344.156835-2-pgonda@google.com>
Content-Language: en-US
X-MC-Unique: 4ndVCtynPlaA67zzyZR0SQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/11/19 21:33, Peter Gonda wrote:
> Memory encryption support does not have module parameter dependencies
> and can be moved into the general x86 cpuid __do_cpuid_ent function.
> This changes maintains current behavior of passing through all of
> CPUID.8000001F.
> 
> Suggested-by: Jim Mattson <jmattson@google.com>
> Signed-off-by: Peter Gonda <pgonda@google.com>
> Reviewed-by: Jim Mattson <jmattson@google.com>
> ---
>  arch/x86/kvm/cpuid.c | 5 +++++
>  arch/x86/kvm/svm.c   | 7 -------
>  2 files changed, 5 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index f68c0c753c38..946fa9cb9dd6 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -778,6 +778,11 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
>  	case 0x8000001a:
>  	case 0x8000001e:
>  		break;
> +	/* Support memory encryption cpuid if host supports it */
> +	case 0x8000001F:
> +		if (!boot_cpu_has(X86_FEATURE_SEV))
> +			entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
> +		break;
>  	/*Add support for Centaur's CPUID instruction*/
>  	case 0xC0000000:
>  		/*Just support up to 0xC0000004 now*/
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index c5673bda4b66..79842329ebcd 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -5936,13 +5936,6 @@ static void svm_set_supported_cpuid(u32 func, struct kvm_cpuid_entry2 *entry)
>  		if (npt_enabled)
>  			entry->edx |= F(NPT);
>  
> -		break;
> -	case 0x8000001F:
> -		/* Support memory encryption cpuid if host supports it */
> -		if (boot_cpu_has(X86_FEATURE_SEV))
> -			cpuid(0x8000001f, &entry->eax, &entry->ebx,
> -				&entry->ecx, &entry->edx);
> -
>  	}
>  }
>  
> 

Queued patch 1, only.

Paolo

