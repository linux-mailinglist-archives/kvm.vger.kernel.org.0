Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8379B1E390F
	for <lists+kvm@lfdr.de>; Wed, 27 May 2020 08:24:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728143AbgE0GYT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 May 2020 02:24:19 -0400
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:52965 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726337AbgE0GYT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 27 May 2020 02:24:19 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R941e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e07425;MF=tianjia.zhang@linux.alibaba.com;NM=1;PH=DS;RN=37;SR=0;TI=SMTPD_---0TzmW8ts_1590560648;
Received: from 30.27.118.64(mailfrom:tianjia.zhang@linux.alibaba.com fp:SMTPD_---0TzmW8ts_1590560648)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 27 May 2020 14:24:10 +0800
Subject: Re: [PATCH v4 6/7] KVM: MIPS: clean up redundant 'kvm_run' parameters
To:     Huacai Chen <chenhuacai@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        paulus@ozlabs.org, mpe@ellerman.id.au,
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
From:   Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Message-ID: <37246a25-c4dc-7757-3f5c-d46870a4f186@linux.alibaba.com>
Date:   Wed, 27 May 2020 14:24:08 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <CAAhV-H7kpKUfQoWid6GSNL5+4hTTroGyL83EaW6yZwS2+Ti9kA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020/4/27 13:40, Huacai Chen wrote:
> Reviewed-by: Huacai Chen <chenhc@lemote.com>
> 
> On Mon, Apr 27, 2020 at 12:35 PM Tianjia Zhang
> <tianjia.zhang@linux.alibaba.com> wrote:
>>
>> In the current kvm version, 'kvm_run' has been included in the 'kvm_vcpu'
>> structure. For historical reasons, many kvm-related function parameters
>> retain the 'kvm_run' and 'kvm_vcpu' parameters at the same time. This
>> patch does a unified cleanup of these remaining redundant parameters.
>>
>> Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
>> ---
>>   arch/mips/include/asm/kvm_host.h |  28 +-------
>>   arch/mips/kvm/emulate.c          |  59 ++++++----------
>>   arch/mips/kvm/mips.c             |  11 ++-
>>   arch/mips/kvm/trap_emul.c        | 114 ++++++++++++++-----------------
>>   arch/mips/kvm/vz.c               |  26 +++----
>>   5 files changed, 87 insertions(+), 151 deletions(-)
>>

Hi Huacai,

These two patches(6/7 and 7/7) should be merged into the tree of the 
mips architecture separately. At present, there seems to be no good way 
to merge the whole architecture patchs.

For this series of patches, some architectures have been merged, some 
need to update the patch.

Thanks and best,
Tianjia
