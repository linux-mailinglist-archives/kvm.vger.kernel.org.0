Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 662C91C8BB7
	for <lists+kvm@lfdr.de>; Thu,  7 May 2020 15:04:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726572AbgEGNEq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 May 2020 09:04:46 -0400
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:58059 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725914AbgEGNEq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 May 2020 09:04:46 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R881e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e07425;MF=tianjia.zhang@linux.alibaba.com;NM=1;PH=DS;RN=37;SR=0;TI=SMTPD_---0TxqomBt_1588856677;
Received: from 30.27.116.247(mailfrom:tianjia.zhang@linux.alibaba.com fp:SMTPD_---0TxqomBt_1588856677)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 07 May 2020 21:04:38 +0800
Subject: Re: [PATCH v4 2/7] KVM: arm64: clean up redundant 'kvm_run'
 parameters
To:     Marc Zyngier <maz@kernel.org>
Cc:     pbonzini@redhat.com, tsbogend@alpha.franken.de, paulus@ozlabs.org,
        mpe@ellerman.id.au, benh@kernel.crashing.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        cohuck@redhat.com, heiko.carstens@de.ibm.com, gor@linux.ibm.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        hpa@zytor.com, james.morse@arm.com, julien.thierry.kdev@gmail.com,
        suzuki.poulose@arm.com, christoffer.dall@arm.com,
        peterx@redhat.com, thuth@redhat.com, chenhuacai@gmail.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200427043514.16144-1-tianjia.zhang@linux.alibaba.com>
 <20200427043514.16144-3-tianjia.zhang@linux.alibaba.com>
 <35eb095a344b4192b912385bc02c54e6@kernel.org>
From:   Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Message-ID: <f093f6cf-4892-7c8f-d3aa-e908d5740cba@linux.alibaba.com>
Date:   Thu, 7 May 2020 21:04:37 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <35eb095a344b4192b912385bc02c54e6@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020/5/5 16:39, Marc Zyngier wrote:
> Hi Tianjia,
> 
> On 2020-04-27 05:35, Tianjia Zhang wrote:
>> In the current kvm version, 'kvm_run' has been included in the 'kvm_vcpu'
>> structure. For historical reasons, many kvm-related function parameters
>> retain the 'kvm_run' and 'kvm_vcpu' parameters at the same time. This
>> patch does a unified cleanup of these remaining redundant parameters.
>>
>> Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
> 
> On the face of it, this looks OK, but I haven't tried to run the
> resulting kernel. I'm not opposed to taking this patch *if* there
> is an agreement across architectures to take the series (I value
> consistency over the janitorial exercise).
> 
> Another thing is that this is going to conflict with the set of
> patches that move the KVM/arm code back where it belongs (arch/arm64/kvm),
> so I'd probably cherry-pick that one directly.
> 
> Thanks,
> 
>          M.
> 

Do I need to submit this set of patches separately for each 
architecture? Could it be merged at once, if necessary, I will
resubmit based on the latest mainline.

Thanks,
Tianjia
