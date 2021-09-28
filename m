Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 121B341B37D
	for <lists+kvm@lfdr.de>; Tue, 28 Sep 2021 18:04:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241808AbhI1QFy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Sep 2021 12:05:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56682 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241405AbhI1QFx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 28 Sep 2021 12:05:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632845052;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zl4SSqGH76EGAl5YnV3M4ZHGi1GMO4rPMYPLM9TWK+w=;
        b=hYx2hIYIHrEFwNN6g1wHsoV/MAbcOx1OYWZonCg1/SRTPVtNEgCtlx7G9+CskNRaSVZgwQ
        UHZK4iSo6VVCOvZUlv6yiVSaXlOKO3s75LTzpj0JsnXLI7D1yprRI48IYAFSWtQWNObyLO
        6tQf0bcH8ZdgyLtwEbOBNIBlE4UxOGM=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-439-OW-DHaiFNwWeyNgNu7aIKA-1; Tue, 28 Sep 2021 12:04:11 -0400
X-MC-Unique: OW-DHaiFNwWeyNgNu7aIKA-1
Received: by mail-ed1-f70.google.com with SMTP id z6-20020a50cd06000000b003d2c2e38f1fso22373776edi.1
        for <kvm@vger.kernel.org>; Tue, 28 Sep 2021 09:04:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=zl4SSqGH76EGAl5YnV3M4ZHGi1GMO4rPMYPLM9TWK+w=;
        b=T75KWybQ3pQWA52bXKK56T1zkYixrgz9txYhSurzuaVoSvjsEquN8bVDQJcAmC7RJU
         DtxFCwozCOKBQV8EZNUDzdUbySDPwfWopVwMrlOKCWa2j3PxvoMXEwgRAqZrgfU8tkK5
         eWZOoyhe0H1DQwQC8e5wyH1q5gpsucJ1zE+3ovluW4AGkxU7O2D2uoCFYpU1pWhL+3Up
         p53UDzYuMzNvGazmzO3LeEyJufr/IV3c+v/5OwKVmi1qE9sCGFChKwDWXpl/iY8denRo
         hJ1GeQwLy9RMIVp8RKAneMGSnTwsja4Tgwnr2HP0su5cNEnxQoRWswVHjonio0GT7bAU
         uPQA==
X-Gm-Message-State: AOAM533pFzL7QXR6IA3W94juXeJOVdOooT/7Zaelb63HDyu/mVvpyg2X
        4SnyRmhyGMqvElPpRlV2ez36LTonMZjMVOuHoS3tyR67ELzGCOxpBJB2EnsAYoOE9WpPJtVyTWa
        g96EvAlF346yN
X-Received: by 2002:a50:d84c:: with SMTP id v12mr8488117edj.201.1632845049637;
        Tue, 28 Sep 2021 09:04:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzTQSWfk3hicqWEfOfkekIGdJOm0afNPMpMcA+BVeW/cZsGMpXcyKKS0muyTXfODxT/BRUN5Q==
X-Received: by 2002:a50:d84c:: with SMTP id v12mr8488091edj.201.1632845049421;
        Tue, 28 Sep 2021 09:04:09 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id s3sm10751005eja.87.2021.09.28.09.04.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Sep 2021 09:04:08 -0700 (PDT)
Message-ID: <d1b1e0da-29f0-c443-6c86-9549bbe1c79d@redhat.com>
Date:   Tue, 28 Sep 2021 18:04:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH] KVM: x86: Expose Predictive Store Forwarding Disable
Content-Language: en-US
To:     Babu Moger <babu.moger@amd.com>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org
Cc:     hpa@zytor.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tony.luck@intel.com, peterz@infradead.org,
        kyung.min.park@intel.com, wei.huang2@amd.com, jgross@suse.com,
        andrew.cooper3@citrix.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
References: <163244601049.30292.5855870305350227855.stgit@bmoger-ubuntu>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <163244601049.30292.5855870305350227855.stgit@bmoger-ubuntu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/09/21 03:15, Babu Moger wrote:
>   arch/x86/include/asm/cpufeatures.h |    1 +
>   arch/x86/kvm/cpuid.c               |    2 +-
>   2 files changed, 2 insertions(+), 1 deletion(-)

Queued, with a private #define instead of the one in cpufeatures.h:

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index fe03bd978761..343a01a05058 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -53,9 +53,16 @@ static u32 xstate_required_size(u64 xstate_bv, bool compacted)
  	return ret;
  }
  
+/*
+ * This one is tied to SSB in the user API, and not
+ * visible in /proc/cpuinfo.
+ */
+#define KVM_X86_FEATURE_PSFD		(13*32+28) /* Predictive Store Forwarding Disable */
+
  #define F feature_bit
  #define SF(name) (boot_cpu_has(X86_FEATURE_##name) ? F(name) : 0)
  
+
  static inline struct kvm_cpuid_entry2 *cpuid_entry2_find(
  	struct kvm_cpuid_entry2 *entries, int nent, u32 function, u32 index)
  {
@@ -500,7 +507,8 @@ void kvm_set_cpu_caps(void)
  	kvm_cpu_cap_mask(CPUID_8000_0008_EBX,
  		F(CLZERO) | F(XSAVEERPTR) |
  		F(WBNOINVD) | F(AMD_IBPB) | F(AMD_IBRS) | F(AMD_SSBD) | F(VIRT_SSBD) |
-		F(AMD_SSB_NO) | F(AMD_STIBP) | F(AMD_STIBP_ALWAYS_ON)
+		F(AMD_SSB_NO) | F(AMD_STIBP) | F(AMD_STIBP_ALWAYS_ON) |
+		__feature_bit(KVM_X86_FEATURE_PSFD)
  	);
  
  	/*

Paolo

