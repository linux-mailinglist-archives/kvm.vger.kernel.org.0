Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B52513513AC
	for <lists+kvm@lfdr.de>; Thu,  1 Apr 2021 12:33:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234158AbhDAKcz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 06:32:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51667 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234130AbhDAKc2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 1 Apr 2021 06:32:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617273137;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1eUiXnpnH6n4/oGTREYOSpo6rDfrAd7KXaTmdQGW+OU=;
        b=BCLmn9iGp7XYYXfgFZqqrDI4KoF7pWCi6dZbOu2vPm8mcK9Nzrse+W7Ec2qf4csdc9VJeH
        S8nbARbx9yA385f41JFkfteEq3Stm5xK9INEkoRgqFL5mRBlRl/38bVbh0SKWZoMU4Lwgp
        ZWXGNkr43b9XvzdqTWCYmdmCxU3SN3w=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-309-IniLebvnMIWig_4HkIexuQ-1; Thu, 01 Apr 2021 06:32:16 -0400
X-MC-Unique: IniLebvnMIWig_4HkIexuQ-1
Received: by mail-ej1-f70.google.com with SMTP id t21so2028707ejf.14
        for <kvm@vger.kernel.org>; Thu, 01 Apr 2021 03:32:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1eUiXnpnH6n4/oGTREYOSpo6rDfrAd7KXaTmdQGW+OU=;
        b=s/bz6cQ1ZyqbMBZcLnmAm7klNDIAoL9Nie24nqOkS7jdxtHdN5BC3IU+bPCBsmadfJ
         h9vcdvnSGH0uqHoox+rSOZLQCZs/h1MiLyKMPr5mZx1u8qiCtkFRCcfSnlqCJmhLV3zQ
         ecKrRLR5E4gAO0b/oHJer5gEsLsesvGKgD399NML/W0fUoorWR2FrjFpcQ5ycKjS5HYE
         VRO9ZsKWKmvBjm1xsRxUgLVpgeTiX0QS2DREym65inQ4Tl2IPwDJy/ZaCbhe5L3u6tRi
         A9R1Cu6r+7oPYHW1Zh9aYqb5wMqfQ9ZlolvyuyHyPRvsvzF5ZRVWL7oqGiNvDEpvkQrv
         b4xw==
X-Gm-Message-State: AOAM532L8tuGVcYVD+6gyVnqx4vPIvEZffPgyPBt/vWZhIiLo35J9AhK
        AgvhSIZ/1CchzFYqlbpkcIG0vyTtNuErze9xU5Z6KpLQ3t/mvYG13GUbd6D174K3/X+LfECFuXu
        dCnru2FAWTXh/
X-Received: by 2002:a17:906:170f:: with SMTP id c15mr8251969eje.358.1617273135173;
        Thu, 01 Apr 2021 03:32:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxp7pLCchsEQe6GRgziondNEofsHQiuq/17gNPT5UApEqlYEhzeOqXUMZuIdD/PwJTrvx7Wlw==
X-Received: by 2002:a17:906:170f:: with SMTP id c15mr8251959eje.358.1617273134980;
        Thu, 01 Apr 2021 03:32:14 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id y24sm3386648eds.23.2021.04.01.03.32.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Apr 2021 03:32:14 -0700 (PDT)
To:     Ben Gardon <bgardon@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
References: <20210202185734.1680553-1-bgardon@google.com>
 <20210202185734.1680553-21-bgardon@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 20/28] KVM: x86/mmu: Use atomic ops to set SPTEs in TDP
 MMU map
Message-ID: <f4fca4d7-8795-533e-d2d9-89a73e1a9004@redhat.com>
Date:   Thu, 1 Apr 2021 12:32:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210202185734.1680553-21-bgardon@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/02/21 19:57, Ben Gardon wrote:
> @@ -720,7 +790,8 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
>   		 */
>   		if (is_shadow_present_pte(iter.old_spte) &&
>   		    is_large_pte(iter.old_spte)) {
> -			tdp_mmu_set_spte(vcpu->kvm, &iter, 0);
> +			if (!tdp_mmu_set_spte_atomic(vcpu->kvm, &iter, 0))
> +				break;
>   
>   			kvm_flush_remote_tlbs_with_address(vcpu->kvm, iter.gfn,
>   					KVM_PAGES_PER_HPAGE(iter.level));
>
>  			/*
>  			 * The iter must explicitly re-read the spte here
>  			 * because the new value informs the !present
>                          * path below.
>                          */
>                         iter.old_spte = READ_ONCE(*rcu_dereference(iter.sptep));
>                 }
> 
>                 if (!is_shadow_present_pte(iter.old_spte)) {

Would it be easier to reason about this code by making it retry, like:

retry:
                 if (is_shadow_present_pte(iter.old_spte)) {
			if (is_large_pte(iter.old_spte)) {
	                        if (!tdp_mmu_zap_spte_atomic(vcpu->kvm, &iter))
	                                break;

				/*
				 * The iter must explicitly re-read the SPTE because
				 * the atomic cmpxchg failed.
				 */
	                        iter.old_spte = READ_ONCE(*rcu_dereference(iter.sptep));
				goto retry;
			}
                 } else {
			...
		}

?

Paolo

