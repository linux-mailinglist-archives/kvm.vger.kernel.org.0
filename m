Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17466492182
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 09:43:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344879AbiARInf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 03:43:35 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:52130 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344818AbiARInb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 Jan 2022 03:43:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642495411;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=M6WSOyTrhDloZTPPta4Kr3MKYBxUFxNqz9lLdzWwAxY=;
        b=A5erpjxj/r0L0A0CRagOSfZqgQO6ds6zFnKmG+O3GuIsEKRVVGdwh0Dg4AlMNSEDYd6J6m
        L8CO1CL5bSirSCVbe/G6k0NuS2xEKZlAuXBXF+tMWnANUq9Bo/Ktb6HYtExpC5GFqpUd/U
        JGHR5z5bc/OyxkSB2gDiVAw1D/vg3OY=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-471-vJTjnrsqMRuTZ2ppnNxuGQ-1; Tue, 18 Jan 2022 03:43:29 -0500
X-MC-Unique: vJTjnrsqMRuTZ2ppnNxuGQ-1
Received: by mail-wm1-f71.google.com with SMTP id a3-20020a05600c348300b0034a0dfc86aaso1280217wmq.6
        for <kvm@vger.kernel.org>; Tue, 18 Jan 2022 00:43:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=M6WSOyTrhDloZTPPta4Kr3MKYBxUFxNqz9lLdzWwAxY=;
        b=Xb0qLpfC/qP7po4SZ59UivlnJtcUEjLO4mFX+3U5V598odF4+CiYMoqm3qkBvqpQAT
         MhtUt2Wv/+eTt0ddxlTVXxdY+bJ1kwDYCFPKlt6Nezzo/r83a5QN+t2Ox7BRJpKEAagf
         Df8ATFEVUWz/lBp/2RHbw1Ub8G6VfkNh0m0fMASYapSsxSFO7xZiD4SJ5ZP33DmgSixG
         rawgdUNweiLC9wZ58RPNiJyyn4A1ashuK2NB4VwN4BQsZQ+AcIHZHp4eEIKwW23unQzZ
         N96e/ecHGW9heIlqhQXiholCTXJdW8hNcMAjVENR8/y4JUvqkqwO6zzNa5HrkG7+2gEz
         K1cg==
X-Gm-Message-State: AOAM5300nxKJnYDqZKvxQvFR0IPIix7SnS2uu1beJpR2+ovUFiCuC3W/
        nakkg3HnqSJ9om1I4F78TzV+Y1TBjzH2507/+XA+AWxB4LLyoxThNKrODQmFalMMwaWV8me2pE0
        MCFgwJ6yt33LM
X-Received: by 2002:a5d:5917:: with SMTP id v23mr23120358wrd.418.1642495407807;
        Tue, 18 Jan 2022 00:43:27 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzvU29MCHR7SEGIV9a+Z7IdTULOqQXA+cG8azt8N7/nG2d0MZCAoNYbHO2yyhAORrfGB78SYA==
X-Received: by 2002:a5d:5917:: with SMTP id v23mr23120342wrd.418.1642495407635;
        Tue, 18 Jan 2022 00:43:27 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id f5sm16896079wri.52.2022.01.18.00.43.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Jan 2022 00:43:27 -0800 (PST)
Message-ID: <a583d2a2-f489-e3a9-fc69-c5ba0e0b5372@redhat.com>
Date:   Tue, 18 Jan 2022 09:43:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH] kvm: selftests: conditionally build vm_xsave_req_perm()
Content-Language: en-US
To:     Wei Wang <wei.w.wang@intel.com>, scgl@linux.ibm.com,
        kvm@vger.kernel.org
Cc:     seanjc@google.com, guang.zeng@intel.com, jing2.liu@intel.com,
        yang.zhong@intel.com, tglx@linutronix.de, kevin.tian@intel.com
References: <20220118014817.30910-1-wei.w.wang@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220118014817.30910-1-wei.w.wang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/18/22 02:48, Wei Wang wrote:
> vm_xsave_req_perm() is currently defined and used by x86_64 only.
> Make it compiled into vm_create_with_vcpus() only when on x86_64
> machines. Otherwise, it would cause linkage errors, e.g. on s390x.
> 
> Fixes: 415a3c33e8 ("kvm: selftests: Add support for KVM_CAP_XSAVE2")
> Reported-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
> Signed-off-by: Wei Wang <wei.w.wang@intel.com>
> ---
>   tools/testing/selftests/kvm/lib/kvm_util.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index 4a645dc77f34..c22a17aac6b0 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -393,10 +393,12 @@ struct kvm_vm *vm_create_with_vcpus(enum vm_guest_mode mode, uint32_t nr_vcpus,
>   	struct kvm_vm *vm;
>   	int i;
>   
> +#ifdef __x86_64__
>   	/*
>   	 * Permission needs to be requested before KVM_SET_CPUID2.
>   	 */
>   	vm_xsave_req_perm();
> +#endif
>   
>   	/* Force slot0 memory size not small than DEFAULT_GUEST_PHY_PAGES */
>   	if (slot0_mem_pages < DEFAULT_GUEST_PHY_PAGES)

Queued, thanks.

Paolo

