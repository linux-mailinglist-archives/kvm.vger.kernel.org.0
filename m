Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4EDB397DAA
	for <lists+kvm@lfdr.de>; Wed,  2 Jun 2021 02:27:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbhFBA3K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Jun 2021 20:29:10 -0400
Received: from prt-mail.chinatelecom.cn ([42.123.76.227]:42238 "EHLO
        chinatelecom.cn" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S229586AbhFBA3K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Jun 2021 20:29:10 -0400
HMM_SOURCE_IP: 172.18.0.48:35850.1746061569
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-110.184.66.8?logid-6a2457510f35480f852050c9164a9a69 (unknown [172.18.0.48])
        by chinatelecom.cn (HERMES) with SMTP id B234D28009A;
        Wed,  2 Jun 2021 08:27:23 +0800 (CST)
X-189-SAVE-TO-SEND: huangy81@chinatelecom.cn
Received: from  ([172.18.0.48])
        by app0024 with ESMTP id 6a2457510f35480f852050c9164a9a69 for dgilbert@redhat.com;
        Wed Jun  2 08:27:24 2021
X-Transaction-ID: 6a2457510f35480f852050c9164a9a69
X-filter-score:  filter<0>
X-Real-From: huangy81@chinatelecom.cn
X-Receive-IP: 172.18.0.48
X-MEDUSA-Status: 0
Sender: huangy81@chinatelecom.cn
Subject: Re: [PATCH v1 2/6] KVM: introduce dirty_pages into CPUState
To:     Peter Xu <peterx@redhat.com>
Cc:     qemu-devel@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        kvm@vger.kernel.org, Juan Quintela <quintela@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>
References: <cover.1622479161.git.huangy81@chinatelecom.cn>
 <78cc154863754a93d88070d1fae9fed6a1ec5f01.1622479161.git.huangy81@chinatelecom.cn>
 <YLbAoEWOE+no+a7H@t490s>
From:   Hyman Huang <huangy81@chinatelecom.cn>
Message-ID: <2749938b-f775-ec5a-6ac5-d59cde656999@chinatelecom.cn>
Date:   Wed, 2 Jun 2021 08:27:19 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <YLbAoEWOE+no+a7H@t490s>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



在 2021/6/2 7:20, Peter Xu 写道:
> On Tue, Jun 01, 2021 at 01:04:06AM +0800, huangy81@chinatelecom.cn wrote:
>> diff --git a/include/hw/core/cpu.h b/include/hw/core/cpu.h
>> index 044f668a6e..973c193501 100644
>> --- a/include/hw/core/cpu.h
>> +++ b/include/hw/core/cpu.h
>> @@ -375,6 +375,8 @@ struct CPUState {
>>       struct kvm_run *kvm_run;
>>       struct kvm_dirty_gfn *kvm_dirty_gfns;
>>       uint32_t kvm_fetch_index;
>> +    uint64_t dirty_pages;
>> +    bool stat_dirty_pages;
> 
> Shall we make this bool a global one?  As I don't think we'll be able to only
> enable it on a subset of cpus?
Yes, it's a reasonable advice, i'll apply this on the next version
> 

-- 
Best regard

Hyman Huang(黄勇)
