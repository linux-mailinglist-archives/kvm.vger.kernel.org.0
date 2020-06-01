Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7794B1E9FDA
	for <lists+kvm@lfdr.de>; Mon,  1 Jun 2020 10:14:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728103AbgFAIOG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Jun 2020 04:14:06 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:29766 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726056AbgFAIOG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Jun 2020 04:14:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590999245;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FNZsFftjFj/Kx2i72iC8V1ENqeFsz9Ph8OJpbjresQI=;
        b=gYPKipsnrWJOwb5l+DMbW6njijIOSXy4UxYwH9ha3lQu8TYuc2HQr1faL5MDfvp3vLQb9+
        2KPHU0x01hA2l689pjxStrDhdRBZ4uXfsxcZp2ToACNoLM+w8v//yfRDxM6Mt1DLd/1fUI
        PTfjd4U36YvNvx3xv9i5w0welQfmE/4=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-74-ACOacakBPHOUFUC5Hovq9Q-1; Mon, 01 Jun 2020 04:14:03 -0400
X-MC-Unique: ACOacakBPHOUFUC5Hovq9Q-1
Received: by mail-ed1-f71.google.com with SMTP id x11so4683056edj.21
        for <kvm@vger.kernel.org>; Mon, 01 Jun 2020 01:14:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=FNZsFftjFj/Kx2i72iC8V1ENqeFsz9Ph8OJpbjresQI=;
        b=Gfash2kQ5fCEhrceKoT83hzcHAwY3A71jnA15/AYfwIUJqoqCpJKrAFjbp8+7qvTyZ
         a99Hki3kZJtfYsAYT1QaH6RTBkjLInAUwND7+bVNlM4mC97UE10X2bTaquWFaihQ7UNN
         zJsCtK5g6ONWMyhmbKE6eOdAfldF9ObyPuaqkFk6jeEbg9H1/nd4bYjfnnKP52KwTsB6
         XhstajOPaFMj4qUKtjbxrHgRLNLNiuvmL00McExeJuTVtYrcZ4nmTJaRAoJu27BYPAQS
         8Q7+Qi1PXqFPoFcwMHJtwuatIJnPOxBEpKtmpTdE1fzdgLxeebI/993cCv3aTh2DY6TZ
         2DPg==
X-Gm-Message-State: AOAM531zR1qSCSf6FpDMgYmIje2Wnc14k8opyQ9Bm14Do+ebdp2DlgF1
        cJFOTzv68cqodSAEc8FFiw9ScMouuM9cDgGXpEznUz5KPo5/98v7V9m5tdhkHll3S8OjrxlMpZR
        +TUJVx74Ruuup
X-Received: by 2002:a17:906:9243:: with SMTP id c3mr18268447ejx.400.1590999242191;
        Mon, 01 Jun 2020 01:14:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz6FPcr7MoU4UsYyZZjeDoN/PS/mKS4iHy0V7nYjhFO8rPEFEB7lXGKrMo3zHCjUh5aj0WLNg==
X-Received: by 2002:a17:906:9243:: with SMTP id c3mr18268433ejx.400.1590999241965;
        Mon, 01 Jun 2020 01:14:01 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id s8sm15552089edj.64.2020.06.01.01.14.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2020 01:14:01 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH 1/2] selftests: kvm: introduce cpu_has_svm() check
In-Reply-To: <20200529151822.GB520@linux.intel.com>
References: <20200529130407.57176-1-vkuznets@redhat.com> <20200529151822.GB520@linux.intel.com>
Date:   Mon, 01 Jun 2020 10:14:00 +0200
Message-ID: <87sgffgq47.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> On Fri, May 29, 2020 at 03:04:06PM +0200, Vitaly Kuznetsov wrote:
>> More tests may want to check if the CPU is Intel or AMD in
>> guest code, separate cpu_has_svm() and put it as static
>> inline to svm_util.h.
>> 
>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> ---
>>  tools/testing/selftests/kvm/include/x86_64/svm_util.h | 10 ++++++++++
>>  tools/testing/selftests/kvm/x86_64/state_test.c       |  9 +--------
>>  2 files changed, 11 insertions(+), 8 deletions(-)
>> 
>> diff --git a/tools/testing/selftests/kvm/include/x86_64/svm_util.h b/tools/testing/selftests/kvm/include/x86_64/svm_util.h
>> index cd037917fece..b1057773206a 100644
>> --- a/tools/testing/selftests/kvm/include/x86_64/svm_util.h
>> +++ b/tools/testing/selftests/kvm/include/x86_64/svm_util.h
>> @@ -35,4 +35,14 @@ void generic_svm_setup(struct svm_test_data *svm, void *guest_rip, void *guest_r
>>  void run_guest(struct vmcb *vmcb, uint64_t vmcb_gpa);
>>  void nested_svm_check_supported(void);
>>  
>> +static inline bool cpu_has_svm(void)
>> +{
>> +	u32 eax = 0x80000001, ecx;
>> +
>> +	asm volatile("cpuid" :
>> +		     "=a" (eax), "=c" (ecx) : "0" (eax) : "ebx", "edx");
>
> 	u32 eax, ecx;
>
> 	asm("cpuid" : "=a" (eax), "=c" (ecx) : "a" (0x80000001) : "ebx", "edx");
>
> The volatile shouldn't be needed, e.g. no one should be using this purely
> for its seralization properties, and I don't see any reason to put the leaf
> number into a variable.
>
> Alternatively, adding a proper cpuid framework to processor.h would likely
> be useful in the long run.
>

All true, even better would be to find a way to include the definition
of native_cpuid*() from arch/x86/include/asm/processor.h but I didn't
explore these options yet, was trying to address the immediate issue
with Paolo's SVM series. It can probably be done when there is a second
user of cpuid in tests which needs to check something different from SVM
bit.

-- 
Vitaly

