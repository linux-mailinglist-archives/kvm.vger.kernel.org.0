Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6203498193
	for <lists+kvm@lfdr.de>; Mon, 24 Jan 2022 15:00:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237682AbiAXOAM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jan 2022 09:00:12 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:39121 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237761AbiAXOAK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 Jan 2022 09:00:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643032809;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SPUOW8uGzOaBnPqkdCVGj414reOKu6Qs0f5WCNo4Sjg=;
        b=J4YyPN8RdHqSQUNuTvcckW/qG3Pg6SnQqRQXaHK2jrRlhKhq7BNnuhiISDrpFgn7J0e2h9
        Hrt8n/A0uikJqCG09sp2MCRPWhOb2Z53tFG04Nl8kybOF1bNibkKZ8MgbOBOqKP41ZuVOU
        un36FFpojnlsBPnvuI48Ds3WrcYw9ms=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-584-4642lAmoNE6McCy3FlSUWg-1; Mon, 24 Jan 2022 09:00:08 -0500
X-MC-Unique: 4642lAmoNE6McCy3FlSUWg-1
Received: by mail-ed1-f72.google.com with SMTP id c23-20020a056402159700b00406aa42973eso6000522edv.2
        for <kvm@vger.kernel.org>; Mon, 24 Jan 2022 06:00:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=SPUOW8uGzOaBnPqkdCVGj414reOKu6Qs0f5WCNo4Sjg=;
        b=3DW7cY4fVWtVO54h3o3F7zjCrBcpOocNbT8e4aQYo8YzeFLbKSwaJo8+4g2EMhbUHt
         xPp5ejPDjmrPVAP82Czkn5BKnvYEU4tQP1fgHWJ+zKbURocn+0He1sDHQ+8KYizyvk75
         HmJ6xNXilxlN+dZsFMHYv8AkBFo+g2KZqyo2gMzMzPESr2okPfaPxsVVSEiCviVqtSwt
         MMIkXGk9HXvik4FU/IhFxoLZdtBFOg7+E4M7jBSKuo1ccmCc2nmstSrsUQkoO+75Olt+
         WRh2kHcmf8DU0D8lNEF+UlTSiO8xTyE6iEqPpDXOKDo2/GrZNlnTAg/KY09qO4JdUVnK
         OHjg==
X-Gm-Message-State: AOAM532wUk6vkjoSmAwq+lD1pBGOZOcJCz5mKlE16bkMZl1WuCq+Pgah
        3+cdVoC9eEznKmh4jGuLn2e2Twlj9xbp7tpDksHjSGX2a0Gg+ffqK0s8JEIR87mnjoSjQCv/CKd
        Xq6M82EM7PERP
X-Received: by 2002:aa7:c941:: with SMTP id h1mr16027026edt.319.1643032806975;
        Mon, 24 Jan 2022 06:00:06 -0800 (PST)
X-Google-Smtp-Source: ABdhPJza2S2Z2pNL/ZTCfC3bDTrVnvqz7iFrBysOjazndMzlCP6B/quM7sFTr3eiAnJp2HFdpgNA6Q==
X-Received: by 2002:aa7:c941:: with SMTP id h1mr16027001edt.319.1643032806779;
        Mon, 24 Jan 2022 06:00:06 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id dc24sm4894716ejb.201.2022.01.24.06.00.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Jan 2022 06:00:06 -0800 (PST)
Message-ID: <f4ddcedc-4a81-4f4e-f3f4-8388120a0776@redhat.com>
Date:   Mon, 24 Jan 2022 15:00:05 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH] KVM: x86/cpuid: Exclude unpermitted xfeatures sizes at
 KVM_GET_SUPPORTED_CPUID
Content-Language: en-US
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Tian Kevin <kevin.tian@intel.com>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220124080251.60558-1-likexu@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220124080251.60558-1-likexu@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/24/22 09:02, Like Xu wrote:
>   	case 0xd: {
> -		u64 guest_perm = xstate_get_guest_group_perm();
> +		u64 supported_xcr0 = supported_xcr0 & xstate_get_guest_group_perm();
>   
> -		entry->eax &= supported_xcr0 & guest_perm;
> +		entry->eax &= supported_xcr0;
>   		entry->ebx = xstate_required_size(supported_xcr0, false);
>   		entry->ecx = entry->ebx;
> -		entry->edx &= (supported_xcr0 & guest_perm) >> 32;
> +		entry->edx &= supported_xcr0 >> 32;
>   		if (!supported_xcr0)
>   			break;
>   

No, please don't use this kind of shadowing.  I'm not even sure it
works, and one would have to read the C standard or look at the
disassembly to be sure.  Perhaps this instead could be an idea:

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 3dcd58a138a9..03deb51d8d18 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -887,13 +887,14 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
  		}
  		break;
  	case 0xd: {
-		u64 supported_xcr0 = supported_xcr0 & xstate_get_guest_group_perm();
+		u64 permitted_xcr0 = supported_xcr0 & xstate_get_guest_group_perm();
  
-		entry->eax &= supported_xcr0;
-		entry->ebx = xstate_required_size(supported_xcr0, false);
+#define supported_xcr0 DO_NOT_USE_ME
+		entry->eax &= permitted_xcr0;
+		entry->ebx = xstate_required_size(permitted_xcr0, false);
  		entry->ecx = entry->ebx;
-		entry->edx &= supported_xcr0 >> 32;
-		if (!supported_xcr0)
+		entry->edx &= permitted_xcr0 >> 32;
+		if (!permitted_xcr0)
  			break;
  
  		entry = do_host_cpuid(array, function, 1);
@@ -902,7 +903,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
  
  		cpuid_entry_override(entry, CPUID_D_1_EAX);
  		if (entry->eax & (F(XSAVES)|F(XSAVEC)))
-			entry->ebx = xstate_required_size(supported_xcr0 | supported_xss,
+			entry->ebx = xstate_required_size(permitted_xcr0 | supported_xss,
  							  true);
  		else {
  			WARN_ON_ONCE(supported_xss != 0);
@@ -913,7 +914,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
  
  		for (i = 2; i < 64; ++i) {
  			bool s_state;
-			if (supported_xcr0 & BIT_ULL(i))
+			if (permitted_xcr0 & BIT_ULL(i))
  				s_state = false;
  			else if (supported_xss & BIT_ULL(i))
  				s_state = true;
@@ -942,6 +943,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
  			entry->edx = 0;
  		}
  		break;
+#undef supported_xcr0
  	}
  	case 0x12:
  		/* Intel SGX */

or alternatively add

	u64 permitted_xss = supported_xss;

so that you use "permitted" consistently.  Anybody can vote on what they
prefer (including "permitted_xcr0" and no #define/#undef).

Paolo

