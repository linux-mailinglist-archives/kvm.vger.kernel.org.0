Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD1251AB5B8
	for <lists+kvm@lfdr.de>; Thu, 16 Apr 2020 04:01:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730628AbgDPCBC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Apr 2020 22:01:02 -0400
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:60307 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729707AbgDPCAw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 15 Apr 2020 22:00:52 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R851e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e07488;MF=tianjia.zhang@linux.alibaba.com;NM=1;PH=DS;RN=19;SR=0;TI=SMTPD_---0Tveg8zr_1587002446;
Received: from 30.27.118.45(mailfrom:tianjia.zhang@linux.alibaba.com fp:SMTPD_---0Tveg8zr_1587002446)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 16 Apr 2020 10:00:47 +0800
Subject: Re: [PATCH] KVM: Optimize kvm_arch_vcpu_ioctl_run function
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
        sean.j.christopherson@intel.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        maz@kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com,
        suzuki.poulose@arm.com
References: <20200413034523.110548-1-tianjia.zhang@linux.alibaba.com>
 <875ze2ywhy.fsf@vitty.brq.redhat.com>
 <cc29ce22-4c70-87d1-d7aa-9d38438ba8a5@linux.alibaba.com>
 <87a73dxgk6.fsf@vitty.brq.redhat.com>
 <9e122372-249d-3d93-99ed-a670fff33936@redhat.com>
From:   Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Message-ID: <4843f690-7071-aa4f-cc9d-d9cc2321e669@linux.alibaba.com>
Date:   Thu, 16 Apr 2020 10:00:46 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <9e122372-249d-3d93-99ed-a670fff33936@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020/4/15 22:53, Paolo Bonzini wrote:
> On 15/04/20 11:07, Vitaly Kuznetsov wrote:
>> In case this is no longer needed I'd suggest we drop 'kvm_run' parameter
>> and extract it from 'struct kvm_vcpu' when needed. This looks like a
>> natural add-on to your cleanup patch.
> 
> I agree, though I think it should be _instead_ of Tianjia's patch rather
> than on top.
> 
> Paolo
> 

Thank you very much for the comments of Vitaly and Paolo, I will make a 
v2 patch.

Thanks and best,
Tianjia
