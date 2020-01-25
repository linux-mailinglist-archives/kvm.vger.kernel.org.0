Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 327E6149423
	for <lists+kvm@lfdr.de>; Sat, 25 Jan 2020 10:31:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726146AbgAYJbf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 25 Jan 2020 04:31:35 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:48263 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725710AbgAYJbf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 25 Jan 2020 04:31:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579944693;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=w3C93BinbxusfGVr43P81s4F7SqajmswbJ4wW+45gJM=;
        b=a1hQoCLpgUfwfQs+K81zKHYMs3o3WOV6ft7qtOTuCmMWVqtmPUe7LbCBym4pZCDmxVgn5J
        HXrUPedJI0/iyCLLMimTLlPiDr3BlY/r1kTlqae0iEogJOFj8vc1jGABmn382X1OSssS65
        0Uubi+ktJulHT3TS4Nal/tlnhr3qN3A=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-271-3Gn-WL8PO1-xQwAahBuEBQ-1; Sat, 25 Jan 2020 04:31:29 -0500
X-MC-Unique: 3Gn-WL8PO1-xQwAahBuEBQ-1
Received: by mail-wr1-f72.google.com with SMTP id u12so2742553wrt.15
        for <kvm@vger.kernel.org>; Sat, 25 Jan 2020 01:31:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=w3C93BinbxusfGVr43P81s4F7SqajmswbJ4wW+45gJM=;
        b=pHI4Z0/EEuJpnbptwecwoF504dmDPJHNSzeJGzNJSJpQzb82Ib5F48Hz0qJSSVG8bU
         936Tr4OOvCa5yYXmKgJlJUqOVtjksqmf+g1CkdqgbAddlSLQwr2IIvAxC+lO7DCRtLiW
         jFk9rmrquI9+qdmoLIaeqcjnkVcgs05b+7TeSmVF8UO5Z5Qp6eOkhsHkvgL1H6tL0iTY
         tNynv754jXUL6vCtiqvLxwfEiaAHcmtkGtgQ4WEPnsaHgyP9I5+EHI5sFQV3EQMiUCJu
         pcxziGB153y1Yvn87tBIg2oabdFdpi2/ezWQggJbJogXecerCPAeGxN1eWEdG7iOYtC9
         X48Q==
X-Gm-Message-State: APjAAAWuRuUMiMkPAn6K6dOVI7HYTDTAab8Rw0geUAaZOB6XqJRz7qqj
        2LkInzmcJvFsnLtKHGBceyW/OYD4/R2HtW4AbQB2Nf/JUYTkZj6CU68zt2hVitV+xvhXr+QYulZ
        m7QNWklZASTvw
X-Received: by 2002:a1c:5f41:: with SMTP id t62mr3678202wmb.42.1579944688821;
        Sat, 25 Jan 2020 01:31:28 -0800 (PST)
X-Google-Smtp-Source: APXvYqzyprNWPjj4kgM+zsDK8Mgyr5Qqe6eHHBA7DOiGFoXymjDrIwWn8EYy9Fvp3LLyGttP5TIM9Q==
X-Received: by 2002:a1c:5f41:: with SMTP id t62mr3678176wmb.42.1579944688587;
        Sat, 25 Jan 2020 01:31:28 -0800 (PST)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id b16sm11176356wrj.23.2020.01.25.01.31.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Jan 2020 01:31:28 -0800 (PST)
Subject: Re: force push to kvm/next coming
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        KVM list <kvm@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <8f43bd04-9f4e-5c06-8d1d-cb84bba40278@redhat.com>
 <c1564d41-0925-f0fd-c145-bea67a8b100e@de.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <6b568513-5646-29ae-2165-95dbeb185697@redhat.com>
Date:   Sat, 25 Jan 2020 10:31:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <c1564d41-0925-f0fd-c145-bea67a8b100e@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/01/20 09:29, Christian Borntraeger wrote:
> 
> 
> On 24.01.20 09:38, Paolo Bonzini wrote:
>> Linux-next merge reported some bad mistakes on my part, so I'm
>> force-pushing kvm/next.  Since it was pushed only yesterday and the code
>> is the same except for two changed lines, it shouldn't be a big deal.
>>
>> Paolo
>>
> current KVM/next has the following compile error (due to Seans rework).
> 
>   CC [M]  arch/s390/kvm/kvm-s390.o
> arch/s390/kvm/kvm-s390.c: In function ‘kvm_arch_vcpu_create’:
> arch/s390/kvm/kvm-s390.c:3026:32: error: ‘id’ undeclared (first use in this function); did you mean ‘fd’?
>  3026 |  vcpu->arch.sie_block->icpua = id;
>       |                                ^~
>       |                                fd
> arch/s390/kvm/kvm-s390.c:3026:32: note: each undeclared identifier is reported only once for each function it appears in
> arch/s390/kvm/kvm-s390.c:3028:39: error: ‘kvm’ undeclared (first use in this function)
>  3028 |  vcpu->arch.sie_block->gd = (u32)(u64)kvm->arch.gisa_int.origin;
>       |                                       ^~~
> make[2]: *** [scripts/Makefile.build:266: arch/s390/kvm/kvm-s390.o] Error 1
> make[1]: *** [scripts/Makefile.build:503: arch/s390/kvm] Error 2
> make: *** [Makefile:1693: arch/s390] Error 2
> 
> Is this part of the fixup that you will do or another issue?

Nope, I trusted Conny's review on that. :(

Is this enough?

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index c059b86aacd4..0f475af84c0a 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -3023,9 +3023,9 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	vcpu->arch.sie_block->mso = 0;
 	vcpu->arch.sie_block->msl = sclp.hamax;
 
-	vcpu->arch.sie_block->icpua = id;
+	vcpu->arch.sie_block->icpua = vcpu->vcpu_id;
 	spin_lock_init(&vcpu->arch.local_int.lock);
-	vcpu->arch.sie_block->gd = (u32)(u64)kvm->arch.gisa_int.origin;
+	vcpu->arch.sie_block->gd = (u32)(u64)vcpu->kvm->arch.gisa_int.origin;
 	if (vcpu->arch.sie_block->gd && sclp.has_gisaf)
 		vcpu->arch.sie_block->gd |= GISA_FORMAT1;
 	seqcount_init(&vcpu->arch.cputm_seqcount);
@@ -3061,9 +3061,9 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 			goto out_free_sie_block;
 	}
 
-	VM_EVENT(kvm, 3, "create cpu %d at 0x%pK, sie block at 0x%pK", id, vcpu,
+	VM_EVENT(kvm, 3, "create cpu %d at 0x%pK, sie block at 0x%pK", vcpu->vcpu_id, vcpu,
 		 vcpu->arch.sie_block);
-	trace_kvm_s390_create_vcpu(id, vcpu, vcpu->arch.sie_block);
+	trace_kvm_s390_create_vcpu(vcpu->vcpu_id, vcpu, vcpu->arch.sie_block);
 
 	rc = kvm_s390_vcpu_setup(vcpu);
 	if (rc)


Paolo

