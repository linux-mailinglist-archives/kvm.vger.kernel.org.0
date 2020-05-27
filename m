Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 233C41E37DD
	for <lists+kvm@lfdr.de>; Wed, 27 May 2020 07:24:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728922AbgE0FYE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 May 2020 01:24:04 -0400
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:50813 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725948AbgE0FYE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 27 May 2020 01:24:04 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01358;MF=tianjia.zhang@linux.alibaba.com;NM=1;PH=DS;RN=37;SR=0;TI=SMTPD_---0TzmMcE-_1590557034;
Received: from 30.27.118.64(mailfrom:tianjia.zhang@linux.alibaba.com fp:SMTPD_---0TzmMcE-_1590557034)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 27 May 2020 13:23:56 +0800
Subject: Re: [PATCH v4 3/7] KVM: PPC: Remove redundant kvm_run from vcpu_arch
To:     Paul Mackerras <paulus@ozlabs.org>
Cc:     pbonzini@redhat.com, tsbogend@alpha.franken.de, mpe@ellerman.id.au,
        benh@kernel.crashing.org, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, david@redhat.com, cohuck@redhat.com,
        heiko.carstens@de.ibm.com, gor@linux.ibm.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        hpa@zytor.com, maz@kernel.org, james.morse@arm.com,
        julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
        christoffer.dall@arm.com, peterx@redhat.com, thuth@redhat.com,
        chenhuacai@gmail.com, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200427043514.16144-1-tianjia.zhang@linux.alibaba.com>
 <20200427043514.16144-4-tianjia.zhang@linux.alibaba.com>
 <20200527042055.GG293451@thinks.paulus.ozlabs.org>
From:   Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Message-ID: <56064e35-583f-0dc8-9156-aabebdb8aff4@linux.alibaba.com>
Date:   Wed, 27 May 2020 13:23:54 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200527042055.GG293451@thinks.paulus.ozlabs.org>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020/5/27 12:20, Paul Mackerras wrote:
> On Mon, Apr 27, 2020 at 12:35:10PM +0800, Tianjia Zhang wrote:
>> The 'kvm_run' field already exists in the 'vcpu' structure, which
>> is the same structure as the 'kvm_run' in the 'vcpu_arch' and
>> should be deleted.
>>
>> Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
> 
> Thanks, patches 3 and 4 of this series applied to my kvm-ppc-next branch.
> 
> Paul.
> 

Thanks for your suggestion, for 5/7, I will submit a new version patch.

Thanks,
Tianjia
