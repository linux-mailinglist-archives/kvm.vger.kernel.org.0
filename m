Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19DEE25D8D6
	for <lists+kvm@lfdr.de>; Fri,  4 Sep 2020 14:44:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730178AbgIDMoX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Sep 2020 08:44:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729897AbgIDMoU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Sep 2020 08:44:20 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E43EC061244;
        Fri,  4 Sep 2020 05:44:18 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id f18so4535495pfa.10;
        Fri, 04 Sep 2020 05:44:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7iNfDgkuDEGlftYpwjK5faW+HwOe3OLIUqc26Ik79ck=;
        b=ZyUdKXPv4L7VlJLBRTfQ1k+AOducABPqvLFELRrc5Os/rsaqYUW9AeQPROvE09jncF
         kODhQjLAZll+/V3KGaYYCIIZfCcbpIlReF1xsLcZBCZQrHEPz4mIRtXMMK9xAbm3piFB
         q97PcSvTx2KI3Jab8fyHaaOG1Hmi5oWCxaa9aCmsHbqrayZNxYB+sVkmrudLY81bJv6R
         6L+S5Ash4yl5e068RtnWtCuVDH8SFoO/45a4nE8XuWJvKuoTHHBxTaL70D/xU08E71zv
         wdqUcVAbmnC8jgnJZUOSEnXHIb+hDSvOB8Pl6ThrKHNhex4hXOmRWw1yAnPvs+oaTV8q
         KSCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7iNfDgkuDEGlftYpwjK5faW+HwOe3OLIUqc26Ik79ck=;
        b=QXhRBKPxpRG+BPdorui+fCoaqUNf64aJmzKATtA1y8zg7hVKTr/EdCJIdgJ3aBJ494
         Iox4zfqRDX+zl1ylrjQd1ctsAeFrAYNT7ixMkED0fIr9O1iFGulT0EUQ9JAEQAjU4iDl
         G4i266iC6NQ+1R9JqRQdIx6emhOZpPMhlhSCkrwYqERjh9KokCAuxz/FgHzDZ55b0nFW
         SvK42h/Mj2PQcnKdUmJwXxg23lbA3TS5baGS/4ywP0vrNxlDj1kYNHaykpPKbO3g8Voa
         YQLHQpoBIIkfZWu7+M6UJnZZkAmIz4LAqMkxQB4bM3Zz0W9YbAGJxUGT1r1Jrqego7Y9
         hTXw==
X-Gm-Message-State: AOAM531SGnY+P3ZZzqtD8PO1eo7K/H0Lx4DDRRZttvDxteHsCcbTqdgq
        Do6YQ8bIWW63K0aDhUiizg==
X-Google-Smtp-Source: ABdhPJz62AAdK4DRlYo37bxyMRoAXbSGodAX3uLmTR2FE/JhQILygGVywaZ19PyQEH5vs6fOIR6F5g==
X-Received: by 2002:a62:1888:: with SMTP id 130mr8320050pfy.220.1599223458054;
        Fri, 04 Sep 2020 05:44:18 -0700 (PDT)
Received: from [127.0.0.1] ([103.7.29.9])
        by smtp.gmail.com with ESMTPSA id v4sm5227320pjh.38.2020.09.04.05.44.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Sep 2020 05:44:17 -0700 (PDT)
Subject: Re: [PATCH] KVM: SVM: Add tracepoint for cr_interception
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     "hpa@zytor.com" <hpa@zytor.com>, "bp@alien8.de" <bp@alien8.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>, joro@8bytes.org,
        "jmattson@google.com" <jmattson@google.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        sean.j.christopherson@intel.com,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
References: <f3031602-db3b-c4fe-b719-d402663b0a2b@gmail.com>
 <87imctoinr.fsf@vitty.brq.redhat.com>
From:   Haiwei Li <lihaiwei.kernel@gmail.com>
Message-ID: <5b8d366f-db2d-489d-bb48-5c0287323ec6@gmail.com>
Date:   Fri, 4 Sep 2020 20:44:04 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <87imctoinr.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 20/9/4 20:01, Vitaly Kuznetsov wrote:
> Haiwei Li <lihaiwei.kernel@gmail.com> writes:
> 
>> From: Haiwei Li <lihaiwei@tencent.com>
>>
>> Add trace_kvm_cr_write and trace_kvm_cr_read for svm.
>>
>> Signed-off-by: Haiwei Li <lihaiwei@tencent.com>
>> ---
>>    arch/x86/kvm/svm/svm.c | 2 ++
>>    1 file changed, 2 insertions(+)
>>
>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>> index 03dd7bac8034..2c6dea48ba62 100644
>> --- a/arch/x86/kvm/svm/svm.c
>> +++ b/arch/x86/kvm/svm/svm.c
>> @@ -2261,6 +2261,7 @@ static int cr_interception(struct vcpu_svm *svm)
> 
> There are two special cases when we go to emulate_on_interception() and
> these won't be logged but I don't think this is a must.
> 
>>    	if (cr >= 16) { /* mov to cr */
>>    		cr -= 16;
>>    		val = kvm_register_read(&svm->vcpu, reg);
>> +		trace_kvm_cr_write(cr, val);
>>    		switch (cr) {
>>    		case 0:
>>    			if (!check_selective_cr0_intercepted(svm, val))
>> @@ -2306,6 +2307,7 @@ static int cr_interception(struct vcpu_svm *svm)
>>    			return 1;
>>    		}
>>    		kvm_register_write(&svm->vcpu, reg, val);
>> +		trace_kvm_cr_read(cr, val);
> 
> The 'default:' case above does 'return 1;' so we won't get the trace but
> I understand you put trace_kvm_cr_read() here so you can log the
> returned 'val', #UD should be clearly visible.
> 
>>    	}
>>    	return kvm_complete_insn_gp(&svm->vcpu, err);
>>    }
>> --
>> 2.18.4
>>
> 
> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

Thanks a lot.

> 
