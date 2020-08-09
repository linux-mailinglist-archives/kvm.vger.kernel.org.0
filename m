Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3319A23FF68
	for <lists+kvm@lfdr.de>; Sun,  9 Aug 2020 19:14:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726321AbgHIROV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 9 Aug 2020 13:14:21 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:46939 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726289AbgHIROV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 9 Aug 2020 13:14:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596993259;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5aIvYuYAfmzjU/4cUefgKnF7K6Yva+vu1KK2EKEvHYg=;
        b=IM1uvdDM4gGINObJ+SLWq2IuX6gJ094NeuunFv/UMs1fNqaKrnVOoI+ziz2mu1LmoFAk94
        wYkXRTHxn74DXgwAdX1ODPUswEhno6xcH/YQPfuk+K2BhSuoLFxtcDSDsrbHljxBcN/BQU
        MAAhC3rGsP5kw6EQ9pCsoh3CHYnHYOg=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-21-MxFmj-fvMlWkN5pEMVSang-1; Sun, 09 Aug 2020 13:14:17 -0400
X-MC-Unique: MxFmj-fvMlWkN5pEMVSang-1
Received: by mail-wr1-f69.google.com with SMTP id w7so3296255wrt.9
        for <kvm@vger.kernel.org>; Sun, 09 Aug 2020 10:14:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5aIvYuYAfmzjU/4cUefgKnF7K6Yva+vu1KK2EKEvHYg=;
        b=T53HRu7lF5qww+LWi0hhhFz74J/yG6cOPvLhfTNPa4PdFPdFZ/St3BHmt0DPvMEmPx
         OZxM6sGlfMFca4Zb+tbyVq2Zgm4TRbz5Ck5AjG6ruOLtqI2pWMQXIoKN5wyXim5zk3sx
         sbf5MhUmWtxuVUEhf58gCKqkE35SoZWdE72zjGiNrUB2bCy/c6ID2eRilYQcPcoUg0RR
         mISr9zQ1aBMgjAn/wDO1gFh4XReffdRXjTgLpT6l6n5H3vVUPqkkVIGQjnwHyJOJs+bC
         IL+92QtkO/0fVsk8T1KXwTDa94jo6G/kysBYIYCaIrJmIyrVYBAzAwErKVVnH8lMyEd/
         PrfA==
X-Gm-Message-State: AOAM531yTNIX+08or1RMYXQTjix9arv7cYavi1LvPklyLcllTNm39v1w
        GCooz/OZBwqt6kj6eNqfNOPlFJa6IKO+kFcI9Es8naAsO1Djj6DSEyWjEJ3sYhXKAvF7tMt+ifz
        V8XNP2CsZtcjE
X-Received: by 2002:adf:ed0c:: with SMTP id a12mr20743873wro.24.1596993256457;
        Sun, 09 Aug 2020 10:14:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzGfGVS8W1JBuwWvPc5P7ERK9kpactbm0lYtoqO2+fZ2kEMeys4tMDh0EgeZGZlleIsOevMiQ==
X-Received: by 2002:adf:ed0c:: with SMTP id a12mr20743843wro.24.1596993256133;
        Sun, 09 Aug 2020 10:14:16 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:8deb:6d34:4b78:b801? ([2001:b07:6468:f312:8deb:6d34:4b78:b801])
        by smtp.gmail.com with ESMTPSA id j145sm19845367wmj.12.2020.08.09.10.14.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 09 Aug 2020 10:14:15 -0700 (PDT)
Subject: Re: [PATCH v3 2/2] x86/kvm: Expose new features for supported cpuid
To:     Cathy Zhang <cathy.zhang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     sean.j.christopherson@intel.com, gregkh@linuxfoundation.org,
        tglx@linutronix.de, tony.luck@intel.com, dave.hansen@intel.com,
        kyung.min.park@intel.com, ricardo.neri-calderon@linux.intel.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        jpoimboe@redhat.com, ak@linux.intel.com, ravi.v.shankar@intel.com
References: <1596959242-2372-1-git-send-email-cathy.zhang@intel.com>
 <1596959242-2372-3-git-send-email-cathy.zhang@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d7e9fb9a-e392-73b1-5fc8-3876cb30665c@redhat.com>
Date:   Sun, 9 Aug 2020 19:14:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <1596959242-2372-3-git-send-email-cathy.zhang@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/08/20 09:47, Cathy Zhang wrote:
> Expose the SERIALIZE and TSX Suspend Load Address Tracking
> features in KVM CPUID, so when running on processors which
> support them, KVM could pass this information to guests and
> they can make use of these features accordingly.
> 
> SERIALIZE is a faster serializing instruction which does not modify
> registers, arithmetic flags or memory, will not cause VM exit. It's
> availability is indicated by CPUID.(EAX=7,ECX=0):ECX[bit 14].
> 
> TSX suspend load tracking instruction aims to give a way to choose
> which memory accesses do not need to be tracked in the TSX read set.
> It's availability is indicated as CPUID.(EAX=7,ECX=0):EDX[bit 16].
> 
> Those instructions are currently documented in the the latest "extensions"
> manual (ISE). It will appear in the "main" manual (SDM) in the future.
> 
> Signed-off-by: Cathy Zhang <cathy.zhang@intel.com>
> Reviewed-by: Tony Luck <tony.luck@intel.com>
> ---
> Changes since v2:
>  * Merge two patches into a single one. (Luck, Tony)
>  * Add overview introduction for features. (Sean Christopherson)
>  * Refactor commit message to explain why expose feature bits. (Luck, Tony)
> ---
>  arch/x86/kvm/cpuid.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 8a294f9..dcf48cc 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -341,7 +341,8 @@ void kvm_set_cpu_caps(void)
>  	kvm_cpu_cap_mask(CPUID_7_EDX,
>  		F(AVX512_4VNNIW) | F(AVX512_4FMAPS) | F(SPEC_CTRL) |
>  		F(SPEC_CTRL_SSBD) | F(ARCH_CAPABILITIES) | F(INTEL_STIBP) |
> -		F(MD_CLEAR) | F(AVX512_VP2INTERSECT) | F(FSRM)
> +		F(MD_CLEAR) | F(AVX512_VP2INTERSECT) | F(FSRM) |
> +		F(SERIALIZE) | F(TSXLDTRK)
>  	);
>  
>  	/* TSC_ADJUST and ARCH_CAPABILITIES are emulated in software. */
> 

TSXLDTRK is not going to be in 5.9 as far as I can see, so I split back
again the patches (this is why I prefer them to be split, sorry Tony :))
and committed the SERIALIZE part.

Paolo

