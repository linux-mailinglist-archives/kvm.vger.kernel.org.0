Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7CCD2718CF
	for <lists+kvm@lfdr.de>; Mon, 21 Sep 2020 02:23:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726305AbgIUAXV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 20 Sep 2020 20:23:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726236AbgIUAXV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 20 Sep 2020 20:23:21 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81D89C061755;
        Sun, 20 Sep 2020 17:23:21 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id l191so7405319pgd.5;
        Sun, 20 Sep 2020 17:23:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=v3Vp5NrGGMOCiRkdb4Q/Xbdx+HabRr82jxca5q0JC98=;
        b=jDZKa9cs8Qv6XCzcFWRROK245g3fx/cngkkRLxpRAlCtgAxCX4YzCh//POGD2L6k2d
         cediQFlT2G+AYqdWE2lSUGD9Sg1d0o7/M2mEjNR8i5dfZ+BgH19Sv/Vv9/TEXWXKTspW
         4Lyw115+yZ4AS7zqZkr2NxCkyEHthOgtMayhOV7uYPZHlaATPrGXSspM2lMXfZHG0AlH
         IhhCdgOyI91t7P0FzsZJxBTrde9FbknVtPSWPjvckcgGUsmdU4R9CB/L3oexuL8cC7Jg
         jDTXHl597byvl9K7dPirdGnAaHU3QUIPW08e1TC6sgbT5V1GapR7hbcAdoATTJT/NAXh
         GqZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=v3Vp5NrGGMOCiRkdb4Q/Xbdx+HabRr82jxca5q0JC98=;
        b=YbPxDuuH7iXH6eWRenedAjZpX6/9lqPaa90PZwzWezduzwNLmThhBjIdy7QgUzcSfH
         uST0yAhjOP1W/o/cxImiFwUmzyC48PGMI7dHDQBtGoPyRVG0ZT+VGy1kmy6l1DpYATAN
         QccoaHSgxuCNOiqfcr9NsbScRmVyR1rGv41wRgWt9wLpPHd3jCkzgwPI3LDei12ntadr
         GIz5q2hj7JBSNtlflHj90A/PshF94FKXLAiflDvcrkvCbC/kFcEVCLV0hJNPwJ8qliMy
         n9lgjA+hlBKO+O3iBWXNZb8yot+GVUROPWxq0JKGOoEaYtVDgcfTR1cuJ48b3whKhgun
         Fqzg==
X-Gm-Message-State: AOAM533mDz5qNeeApkVnpKaeABKoBjihZhrg3Nq3UxnNd2fJoxtcBFHx
        daWbDnFgb3BQKBtytVMgIw==
X-Google-Smtp-Source: ABdhPJz+Z+eD2TTHxk4lHNb/eZhngZE4UQ9Lj4taKRcybhu6NoaBVoKliHNqfZ53mRETM1X0nEzKQw==
X-Received: by 2002:a63:63c7:: with SMTP id x190mr34821422pgb.90.1600647800787;
        Sun, 20 Sep 2020 17:23:20 -0700 (PDT)
Received: from [127.0.0.1] ([103.7.29.9])
        by smtp.gmail.com with ESMTPSA id q11sm9403983pgj.92.2020.09.20.17.23.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 20 Sep 2020 17:23:20 -0700 (PDT)
Subject: Re: [PATCH 1/2] KVM: Fix the build error
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org
Cc:     sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        lihaiwei@tencent.com, kernel test robot <lkp@intel.com>
References: <20200914091148.95654-1-lihaiwei.kernel@gmail.com>
 <20200914091148.95654-2-lihaiwei.kernel@gmail.com>
 <1810e3e5-8286-29e0-ff10-636d6c32df6d@redhat.com>
From:   Haiwei Li <lihaiwei.kernel@gmail.com>
Message-ID: <632965cf-e4e9-9c78-9664-df500410401f@gmail.com>
Date:   Mon, 21 Sep 2020 08:23:09 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <1810e3e5-8286-29e0-ff10-636d6c32df6d@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 20/9/20 21:09, Paolo Bonzini wrote:
> On 14/09/20 11:11, lihaiwei.kernel@gmail.com wrote:
>> From: Haiwei Li <lihaiwei@tencent.com>
>>
>> When CONFIG_SMP is not set, an build error occurs with message "error:
>> use of undeclared identifier 'kvm_send_ipi_mask_allbutself'"
>>
>> Fixes: 0f990222108d ("KVM: Check the allocation of pv cpu mask", 2020-09-01)
>> Reported-by: kernel test robot <lkp@intel.com>
>> Signed-off-by: Haiwei Li <lihaiwei@tencent.com>
>> ---
>>   arch/x86/kernel/kvm.c | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
>> index 1b51b727b140..7e8be0421720 100644
>> --- a/arch/x86/kernel/kvm.c
>> +++ b/arch/x86/kernel/kvm.c
>> @@ -797,7 +797,9 @@ static __init int kvm_alloc_cpumask(void)
>>   			}
>>   		}
>>   
>> +#if defined(CONFIG_SMP)
>>   	apic->send_IPI_mask_allbutself = kvm_send_ipi_mask_allbutself;
>> +#endif
>>   	pv_ops.mmu.flush_tlb_others = kvm_flush_tlb_others;
>>   	return 0;
>>   
>>
> 
> If CONFIG_SMP is not set you don't need kvm_alloc_cpumask or
> pv_ops.mmu.flush_tlb_others at all.  Can you squash these two into the
> original patch and re-submit for 5.10?

I will, thanks.

Haiwei Li
