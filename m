Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 927EF1FAF91
	for <lists+kvm@lfdr.de>; Tue, 16 Jun 2020 13:55:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727966AbgFPLzE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jun 2020 07:55:04 -0400
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:44277 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726261AbgFPLzE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Jun 2020 07:55:04 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e07484;MF=tianjia.zhang@linux.alibaba.com;NM=1;PH=DS;RN=37;SR=0;TI=SMTPD_---0U.mfflQ_1592308495;
Received: from 30.27.116.240(mailfrom:tianjia.zhang@linux.alibaba.com fp:SMTPD_---0U.mfflQ_1592308495)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 16 Jun 2020 19:54:57 +0800
Subject: Re: [PATCH v4 6/7] KVM: MIPS: clean up redundant 'kvm_run' parameters
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Huacai Chen <chenhuacai@gmail.com>
Cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>, paulus@ozlabs.org,
        mpe@ellerman.id.au,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        cohuck@redhat.com, heiko.carstens@de.ibm.com, gor@linux.ibm.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        Thomas Gleixner <tglx@linutronix.de>, mingo@redhat.com,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org, hpa@zytor.com,
        Marc Zyngier <maz@kernel.org>, james.morse@arm.com,
        julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
        christoffer.dall@arm.com, Peter Xu <peterx@redhat.com>,
        thuth@redhat.com, kvm@vger.kernel.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        kvmarm@lists.cs.columbia.edu,
        "open list:MIPS" <linux-mips@vger.kernel.org>,
        kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
References: <20200427043514.16144-1-tianjia.zhang@linux.alibaba.com>
 <20200427043514.16144-7-tianjia.zhang@linux.alibaba.com>
 <CAAhV-H7kpKUfQoWid6GSNL5+4hTTroGyL83EaW6yZwS2+Ti9kA@mail.gmail.com>
 <37246a25-c4dc-7757-3f5c-d46870a4f186@linux.alibaba.com>
 <30c2ac06-1a7e-2f85-fbe1-e9dc25bf2ae2@redhat.com>
From:   Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Message-ID: <5f0d01ad-d299-083b-70e4-995ad7596fbd@linux.alibaba.com>
Date:   Tue, 16 Jun 2020 19:54:54 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <30c2ac06-1a7e-2f85-fbe1-e9dc25bf2ae2@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020/5/29 17:48, Paolo Bonzini wrote:
> On 27/05/20 08:24, Tianjia Zhang wrote:
>>>>
>>>>
>>
>> Hi Huacai,
>>
>> These two patches(6/7 and 7/7) should be merged into the tree of the
>> mips architecture separately. At present, there seems to be no good way
>> to merge the whole architecture patchs.
>>
>> For this series of patches, some architectures have been merged, some
>> need to update the patch.
> 
> Hi Tianjia, I will take care of this during the merge window.
> 
> Thanks,
> 
> Paolo
> 

Hi Paolo,

The following individual patch is the v5 version of 5/7 in this group of 
patches.

https://lkml.org/lkml/2020/5/28/106
([v5] KVM: PPC: clean up redundant kvm_run parameters in assembly)

Thanks and best,
Tianjia
