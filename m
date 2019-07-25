Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BC5B7495F
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2019 10:50:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389855AbfGYIuX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Jul 2019 04:50:23 -0400
Received: from foss.arm.com ([217.140.110.172]:53864 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388889AbfGYIuW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Jul 2019 04:50:22 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9005B344;
        Thu, 25 Jul 2019 01:50:21 -0700 (PDT)
Received: from [10.1.197.61] (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9F1113F694;
        Thu, 25 Jul 2019 01:50:20 -0700 (PDT)
Subject: Re: [PATCH v2 0/9] KVM: arm/arm64: vgic: ITS translation cache
To:     Andre Przywara <andre.przywara@arm.com>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, "Raslan, KarimAllah" <karahmed@amazon.de>,
        "Saidi, Ali" <alisaidi@amazon.com>
References: <20190611170336.121706-1-marc.zyngier@arm.com>
 <20190723121424.0b632efa@donnerap.cambridge.arm.com>
From:   Marc Zyngier <marc.zyngier@arm.com>
Openpgp: preference=signencrypt
Autocrypt: addr=marc.zyngier@arm.com; prefer-encrypt=mutual; keydata=
 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
 Z46HaNmN2hZS/oJ69c1DI5Rcww==
Organization: ARM Ltd
Message-ID: <a757bac1-41d1-8ce5-9393-ac2e8a5e1114@arm.com>
Date:   Thu, 25 Jul 2019 09:50:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190723121424.0b632efa@donnerap.cambridge.arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Andre,

On 23/07/2019 12:14, Andre Przywara wrote:
> On Tue, 11 Jun 2019 18:03:27 +0100
> Marc Zyngier <marc.zyngier@arm.com> wrote:
> 
> Hi,
> 
>> It recently became apparent[1] that our LPI injection path is not as
>> efficient as it could be when injecting interrupts coming from a VFIO
>> assigned device.
>>
>> Although the proposed patch wasn't 100% correct, it outlined at least
>> two issues:
>>
>> (1) Injecting an LPI from VFIO always results in a context switch to a
>>     worker thread: no good
>>
>> (2) We have no way of amortising the cost of translating a DID+EID pair
>>     to an LPI number
>>
>> The reason for (1) is that we may sleep when translating an LPI, so we
>> do need a context process. A way to fix that is to implement a small
>> LPI translation cache that could be looked up from an atomic
>> context. It would also solve (2).
>>
>> This is what this small series proposes. It implements a very basic
>> LRU cache of pre-translated LPIs, which gets used to implement
>> kvm_arch_set_irq_inatomic. The size of the cache is currently
>> hard-coded at 16 times the number of vcpus, a number I have picked
>> under the influence of Ali Saidi. If that's not enough for you, blame
>> me, though.
>>
>> Does it work? well, it doesn't crash, and is thus perfect. More
>> seriously, I don't really have a way to benchmark it directly, so my
>> observations are only indirect:
>>
>> On a TX2 system, I run a 4 vcpu VM with an Ethernet interface passed
>> to it directly. From the host, I inject interrupts using debugfs. In
>> parallel, I look at the number of context switch, and the number of
>> interrupts on the host. Without this series, I get the same number for
>> both IRQ and CS (about half a million of each per second is pretty
>> easy to reach). With this series, the number of context switches drops
>> to something pretty small (in the low 2k), while the number of
>> interrupts stays the same.
>>
>> Yes, this is a pretty rubbish benchmark, what did you expect? ;-)
>>
>> So I'm putting this out for people with real workloads to try out and
>> report what they see.
> 
> So I gave that a shot with some benchmarks. As expected, it is quite hard
> to show an improvement with just one guest running, although we could show
> a 103%(!) improvement of the memcached QPS score in one experiment when
> running it in a guest with an external load generator.

Is that a fluke or something that you have been able to reproduce
consistently? Because doubling the performance of anything is something
I have a hard time believing in... ;-)

> Throwing more users into the game showed a significant improvement:
> 
> Benchmark 1: kernel compile/FIO: Compiling a kernel on the host, while
> letting a guest run FIO with 4K randreads from a passed-through NVMe SSD:
> The IOPS with this series improved by 27% compared to pure mainline,
> reaching 80% of the host value. Kernel compilation time improved by 8.5%
> compared to mainline.

OK, that's interesting. I guess that's the effect of not unnecessarily
disrupting the scheduling with one extra context-switch per interrupt.

> 
> Benchmark 2: FIO/FIO: Running FIO on a passed through SATA SSD in one
> guest, and FIO on a passed through NVMe SSD in another guest, at the same
> time:
> The IOPS with this series improved by 23% for the NVMe and 34% for the
> SATA disk, compared to pure mainline.

I guess that's the same thing. Not context-switching means more
available resource to other processes in the system.

> So judging from these results, I think this series is a significant
> improvement, which justifies it to be merged, to receive wider testing.
> 
> It would be good if others could also do performance experiments and post
> their results.

Wishful thinking...

Anyway, I'll repost the series shortly now that Eric has gone through it.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
