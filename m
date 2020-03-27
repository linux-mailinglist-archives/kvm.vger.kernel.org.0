Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 820D619531B
	for <lists+kvm@lfdr.de>; Fri, 27 Mar 2020 09:42:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726133AbgC0Im1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Mar 2020 04:42:27 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:29977 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725956AbgC0Im1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 27 Mar 2020 04:42:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585298545;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=t+Tb0IZPRJANwosbtf0p5L1ru8U28gH5wb+hPaiCN9c=;
        b=aZLKvQWUUqhCm5g22Deadr2ckWP0Im3UO+nUaZal5RyM0UQIwoGM7bi+Jq0zgjMD/yALFI
        2Gxv6aUYufD0c67Ytm1LaaWIbyILli8HTV4095cVWYH5tqcqkapWwtAmd5l8jariffRnOZ
        UeJDXr6fqxkIPQXSeniTwr8Bf+yX8dE=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-236-TN8ft8M2OdS7NushsgykcA-1; Fri, 27 Mar 2020 04:42:22 -0400
X-MC-Unique: TN8ft8M2OdS7NushsgykcA-1
Received: by mail-wr1-f72.google.com with SMTP id t25so1852805wrb.16
        for <kvm@vger.kernel.org>; Fri, 27 Mar 2020 01:42:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=t+Tb0IZPRJANwosbtf0p5L1ru8U28gH5wb+hPaiCN9c=;
        b=MjZSZoXeqKFzUbohDH3ijTdWkbwsTgTvrExN9FOQuM2WYX6Lks6IfCBcSgR3hMameR
         yyqu2Ywb1R/Y3719qJRLQA5cQYx5D31j3sKUk/Mfyb3tF454rGcgDG492bjvCD144iPN
         9klgFWzIpFbE8C86vHHkzVBjRMNcTIOtWmrG0sqHxLe5tnZRCPggLdtUCLNX2/yaQXRU
         IZhRg11+CksTwqJs72xn4f/2ngjNln0OPht39VV91ScCrTU7GrnxS0sixaANQlEdN34B
         MKljt5TjpbgYhC20GyckZ8uJbcApI0VCqpQe2GAHrRNV+VyJwzGYj0rbNKvRGUq/2YuI
         poWg==
X-Gm-Message-State: ANhLgQ2B9iGqca5084IQKcXVUTpsQqmMyElUNfej7DEtnOdeyHsEbtVG
        8QbT+7Y5ku8T+9NEyPMmsnKgmC7NKNgxI/XVaJRo7c6nUaOPwC0d7f4xIfvPSEOIMMkU7B49o9C
        IXBF0hgkJXnmQ
X-Received: by 2002:a5d:5408:: with SMTP id g8mr13510300wrv.82.1585298541355;
        Fri, 27 Mar 2020 01:42:21 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vsUi7q3XToCZlqJWrdmC0DszB3dStdq0Fsdo8oiEe9XEJp8im2H77aSum2Z5eyCRp/ROrEkcQ==
X-Received: by 2002:a5d:5408:: with SMTP id g8mr13510279wrv.82.1585298541099;
        Fri, 27 Mar 2020 01:42:21 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ac:65bc:cc13:a014? ([2001:b07:6468:f312:ac:65bc:cc13:a014])
        by smtp.gmail.com with ESMTPSA id o9sm7522421wrx.48.2020.03.27.01.42.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Mar 2020 01:42:20 -0700 (PDT)
Subject: Re: [kvm:queue 276/278] arch/x86/kvm/svm/nested.c:88:49: error:
 invalid type argument of '->' (have 'struct kvm_x86_ops')
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        kbuild test robot <lkp@intel.com>
Cc:     Joerg Roedel <jroedel@suse.de>, kbuild-all@lists.01.org,
        kvm@vger.kernel.org, Robert Hu <robert.hu@intel.com>,
        Farrah Chen <farrah.chen@intel.com>,
        Danmei Wei <danmei.wei@intel.com>
References: <202003270843.uYmVPJ2b%lkp@intel.com>
 <20200327014021.GD28014@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <fdd8f236-3f5d-5687-4dd0-0e27c9f3d9d1@redhat.com>
Date:   Fri, 27 Mar 2020 09:42:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200327014021.GD28014@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/03/20 02:40, Sean Christopherson wrote:
> On Fri, Mar 27, 2020 at 08:29:47AM +0800, kbuild test robot wrote:
>> tree:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
>>    arch/x86/kvm/svm/nested.c: In function 'nested_svm_init_mmu_context':
>>>> arch/x86/kvm/svm/nested.c:88:49: error: invalid type argument of '->' (have 'struct kvm_x86_ops')
>>      vcpu->arch.mmu->shadow_root_level = kvm_x86_ops->get_tdp_level(vcpu);
>>                                                     ^~
>>
>> vim +88 arch/x86/kvm/svm/nested.c
>>
>>     78	
>>     79	static void nested_svm_init_mmu_context(struct kvm_vcpu *vcpu)
>>     80	{
>>     81		WARN_ON(mmu_is_nested(vcpu));
>>     82	
>>     83		vcpu->arch.mmu = &vcpu->arch.guest_mmu;
>>     84		kvm_init_shadow_mmu(vcpu);
>>     85		vcpu->arch.mmu->get_guest_pgd     = nested_svm_get_tdp_cr3;
>>     86		vcpu->arch.mmu->get_pdptr         = nested_svm_get_tdp_pdptr;
>>     87		vcpu->arch.mmu->inject_page_fault = nested_svm_inject_npf_exit;
>>   > 88		vcpu->arch.mmu->shadow_root_level = kvm_x86_ops->get_tdp_level(vcpu);
> 
> Tip of the iceberg.  kvm.git/queue is totally busted, the last two commits
> remove code from svm.c but don't create the new files.

Yes, totally.  I wanted to push before the split and messed up.

Paolo

