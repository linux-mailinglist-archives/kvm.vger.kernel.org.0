Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCFA71B0282
	for <lists+kvm@lfdr.de>; Mon, 20 Apr 2020 09:14:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726378AbgDTHOp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Apr 2020 03:14:45 -0400
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:35886 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725815AbgDTHOp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 20 Apr 2020 03:14:45 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01f04428;MF=tianjia.zhang@linux.alibaba.com;NM=1;PH=DS;RN=37;SR=0;TI=SMTPD_---0Tw1zGGs_1587366866;
Received: from 30.27.118.66(mailfrom:tianjia.zhang@linux.alibaba.com fp:SMTPD_---0Tw1zGGs_1587366866)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 20 Apr 2020 15:14:28 +0800
Subject: Re: [PATCH] KVM: X86: Fix compile error in svm/sev.c
To:     Xiaoyao Li <xiaoyao.li@intel.com>, pbonzini@redhat.com,
        tsbogend@alpha.franken.de, paulus@ozlabs.org, mpe@ellerman.id.au,
        benh@kernel.crashing.org, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, david@redhat.com, cohuck@redhat.com,
        heiko.carstens@de.ibm.com, gor@linux.ibm.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        hpa@zytor.com, maz@kernel.org, james.morse@arm.com,
        julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
        christoffer.dall@arm.com, peterx@redhat.com, thuth@redhat.com
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200419073047.14413-1-tianjia.zhang@linux.alibaba.com>
 <82ce1798-1dab-d271-d084-e9a89bb44e71@intel.com>
From:   Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Message-ID: <8af45e72-2c68-7641-6968-70fad9c516b7@linux.alibaba.com>
Date:   Mon, 20 Apr 2020 15:14:26 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <82ce1798-1dab-d271-d084-e9a89bb44e71@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020/4/19 16:24, Xiaoyao Li wrote:
> On 4/19/2020 3:30 PM, Tianjia Zhang wrote:
>> The compiler reported the following compilation errors:
>>
>> arch/x86/kvm/svm/sev.c: In function ‘sev_pin_memory’:
>> arch/x86/kvm/svm/sev.c:361:3: error: implicit declaration of function
>> ‘release_pages’ [-Werror=implicit-function-declaration]
>>     release_pages(pages, npinned);
>>     ^~~~~~~~~~~~~
>>
>> The reason is that the 'pagemap.h' header file is not included.
>>
> 
> FYI.
> 
> Boris has sent the Patch:
> https://lkml.kernel.org/r/20200411160927.27954-1-bp@alien8.de
> 
> and it's already in kvm master/queue branch
> 
> 

This is the same fix, please ignore this patch.

Thanks and best,
Tianjia
