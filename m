Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFCB3504B19
	for <lists+kvm@lfdr.de>; Mon, 18 Apr 2022 04:54:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235899AbiDRC44 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 17 Apr 2022 22:56:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231827AbiDRC4y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 17 Apr 2022 22:56:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0C980186CC
        for <kvm@vger.kernel.org>; Sun, 17 Apr 2022 19:54:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650250456;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SAA55/OcVLuGltaWPBBCrOhinXHqpswrBBNXxyLN+Rc=;
        b=CESGYaGg18z+E04rRc/hSuisqqe+y7baqHIi+Xk6nPT61W+V0e91si/FcJzc+zIlNf3SX6
        ndFEVS9VNQZoDMX7B5HPgJUh3fK8H4KUHQ4rdj1dlCrpLbRdoka+WB2H5QL9LYjQn36ozg
        bT74j3+fyla/8Xu9SRHCVd5X1eNQGYU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-568-Qwn9yRcYNxGw18zXIgXPpA-1; Sun, 17 Apr 2022 22:54:12 -0400
X-MC-Unique: Qwn9yRcYNxGw18zXIgXPpA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4BB45101AA42;
        Mon, 18 Apr 2022 02:54:11 +0000 (UTC)
Received: from [10.72.13.171] (ovpn-13-171.pek2.redhat.com [10.72.13.171])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3608B40F4961;
        Mon, 18 Apr 2022 02:54:03 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v5 00/10] KVM: arm64: Add support for hypercall services
 selection
To:     Marc Zyngier <maz@kernel.org>
Cc:     Raghavendra Rao Ananta <rananta@google.com>,
        Andrew Jones <drjones@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
References: <20220407011605.1966778-1-rananta@google.com>
 <92eb2304-9259-0461-247f-d3a4e5eb4fd5@redhat.com>
 <8735iebu48.wl-maz@kernel.org>
From:   Gavin Shan <gshan@redhat.com>
Message-ID: <8d257221-e3bf-b5fc-5cf4-01f9fff53eca@redhat.com>
Date:   Mon, 18 Apr 2022 10:53:59 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <8735iebu48.wl-maz@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 4/15/22 4:58 PM, Marc Zyngier wrote:
> On Fri, 15 Apr 2022 07:44:55 +0100,
> Gavin Shan <gshan@redhat.com> wrote:
>> On 4/7/22 9:15 AM, Raghavendra Rao Ananta wrote:
>>> Continuing the discussion from [1], the series tries to add support
>>> for the userspace to elect the hypercall services that it wishes
>>> to expose to the guest, rather than the guest discovering them
>>> unconditionally. The idea employed by the series was taken from
>>> [1] as suggested by Marc Z.
>>>
>>> In a broad sense, the concept is similar to the current implementation
>>> of PSCI interface- create a 'firmware psuedo-register' to handle the
>>> firmware revisions. The series extends this idea to all the other
>>> hypercalls such as TRNG (True Random Number Generator), PV_TIME
>>> (Paravirtualized Time), and PTP (Precision Time protocol).
>>>
>>> For better categorization and future scaling, these firmware registers
>>> are categorized based on the service call owners. Also, unlike the
>>> existing firmware psuedo-registers, they hold the features supported
>>> in the form of a bitmap.
>>>
>>> During the VM initialization, the registers holds an upper-limit of
>>> the features supported by each one of them. It's expected that the
>>> userspace discover the features provided by each register via GET_ONE_REG,
>>> and writeback the desired values using SET_ONE_REG. KVM allows this
>>> modification only until the VM has started.
>>>
>>> Some of the standard function-ids, such as ARM_SMCCC_VERSION_FUNC_ID,
>>> need not be associated with a feature bit. For such ids, the series
>>> introduced an allowed-list, hvc_func_default_allowed_list[], that holds
>>> all such ids. As a result, the functions that are not elected by userspace,
>>> or if they are not a part of this allowed-list, will be denied for when
>>> the guests invoke them.
>>>
>>> Older VMMs can simply ignore this interface and the hypercall services
>>> will be exposed unconditionally to the guests, thus ensuring backward
>>> compatibility.
>>>
>>
>> [...]
>>
>> I rethinking about the design again and just get one question. Hopefully,
>> someone have the answer for us. The newly added 3 pseudo registers and
>> the existing ones like KVM_REG_ARM_PSCI_VERSION are all tied up with
>> vcpu, instead of VM. I don't think it's correct. I'm not sure if VM-scoped
>> pseudo registers aren't allowed by ARM architecture or the effort isn't
>> worthy to support it.
> 
> We have had that discussion before (around version 2 of this series,
> if I remember well).
> 

Yeah, I'm chime-in this series lately. There must be some discussions,
including this topic, I missed :)

>>
>> These pseudo registers are introduced to present the available hypercalls,
>> and then they can be disabled from userspace. In the implementation, these 3
>> registers are vcpu scoped. It means that multiple vcpus can be asymmetric
>> in terms of usable hypercalls. For example, ARM_SMCCC_TRNG hypercalls
>> can be enabled on vcpu0, but disabled on vcpu1. I don't think it's expected.
> 
> No, that's not the way this is supposed to work. These hypercalls are
> of course global, even if the accessor is per-vcpu. This is similar to
> tons of other things, such as some of the PMU data, the timer virtual
> offset... the list goes on. If that's not what this code does, then it
> is a bug and it needs to be fixed.
> 

Ok.

>> On the other hand, the information stored in these 3 registers needs to
>> be migrated through {GET,SET}_ONE_REG by VMM (QEMU). all the information
>> stored in these 3 registers are all same on all vcpus, which is exactly
>> as we expect. In migration circumstance, we're transporting identical
>> information for all vcpus and it's unnecessary.
> 
> Yes, we all understand that. My response to that was (and still is):
> 
> - There is no need to invent a new userspace interface. The one we
>    have is terrible enough, and we don't need another square wheel that
>    would need to be maintained beside the existing one.
> 
> - Let's say we have 1024 new pseudo-registers, 1024 vcpus, 64bit regs:
>    that's 8MB worth of extra data. This is not insignificant, but also
>    not really a problem given that such a large VM is probably attached
>    to a proportionally large amount of memory. In practice, we're
>    talking of less than 10 registers, and less than 100 vcpus. A crazy
>    8kB at most. Who cares?
> 
> - If this is eventually deemed to be a *real* scalability problem, we
>    can always expose a map of registers that are global, and let
>    userspace know that it can elide the rest. Problem solved, backward
>    compatibility preserved. And I'm willing to bet that we won't need
>    it in my lifetime.
> 

The reason why I raised question is just to check if it's a missed
point in the design. As I said, I obviously missed the previous
discussions and glad that this has been discussed through.

Thanks for the details. Yes, it's totally fine to migrate 8KB data.
Besides, VMM (QEMU) can choose to do migration on one single vcpu,
instead of all of them, as you said.

Thanks,
Gavin

