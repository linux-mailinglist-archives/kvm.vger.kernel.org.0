Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49B0C204EA8
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 12:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732261AbgFWKAU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 06:00:20 -0400
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:58589 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732168AbgFWKAT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 23 Jun 2020 06:00:19 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01419;MF=tianjia.zhang@linux.alibaba.com;NM=1;PH=DS;RN=37;SR=0;TI=SMTPD_---0U0VEqxu_1592906410;
Received: from 30.27.116.246(mailfrom:tianjia.zhang@linux.alibaba.com fp:SMTPD_---0U0VEqxu_1592906410)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 23 Jun 2020 18:00:12 +0800
Subject: Re: [PATCH v4 0/7] clean up redundant 'kvm_run' parameters
To:     Paolo Bonzini <pbonzini@redhat.com>, tsbogend@alpha.franken.de,
        paulus@ozlabs.org, mpe@ellerman.id.au, benh@kernel.crashing.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        cohuck@redhat.com, heiko.carstens@de.ibm.com, gor@linux.ibm.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        hpa@zytor.com, maz@kernel.org, james.morse@arm.com,
        julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
        christoffer.dall@arm.com, peterx@redhat.com, thuth@redhat.com,
        chenhuacai@gmail.com
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200427043514.16144-1-tianjia.zhang@linux.alibaba.com>
 <fe463233-d094-fca5-b4e9-c1d97124fd69@redhat.com>
From:   Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Message-ID: <3a2bee8b-20b4-5d33-7d12-09c374a5afde@linux.alibaba.com>
Date:   Tue, 23 Jun 2020 18:00:09 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <fe463233-d094-fca5-b4e9-c1d97124fd69@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020/6/23 17:42, Paolo Bonzini wrote:
> On 27/04/20 06:35, Tianjia Zhang wrote:
>> In the current kvm version, 'kvm_run' has been included in the 'kvm_vcpu'
>> structure. For historical reasons, many kvm-related function parameters
>> retain the 'kvm_run' and 'kvm_vcpu' parameters at the same time. This
>> patch does a unified cleanup of these remaining redundant parameters.
>>
>> This series of patches has completely cleaned the architecture of
>> arm64, mips, ppc, and s390 (no such redundant code on x86). Due to
>> the large number of modified codes, a separate patch is made for each
>> platform. On the ppc platform, there is also a redundant structure
>> pointer of 'kvm_run' in 'vcpu_arch', which has also been cleaned
>> separately.
> 
> Tianjia, can you please refresh the patches so that each architecture
> maintainer can pick them up?  Thanks very much for this work!
> 
> Paolo
> 

No problem, this is what I should do.
After I update, do I submit separately for each architecture or submit 
them together in a patchset?

Thanks,
Tianjia
