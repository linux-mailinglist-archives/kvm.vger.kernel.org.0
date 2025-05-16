Return-Path: <kvm+bounces-46835-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5BC9BABA086
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 18:01:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3C804A000AE
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 16:00:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 158E01D54FE;
	Fri, 16 May 2025 16:00:20 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8FD0149E17;
	Fri, 16 May 2025 16:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747411219; cv=none; b=a7M/y2cu+X253GSCLU3Q7scvZv4AZXK2zDlvQroLPLqopfvpZ6hVXVWO4+rRG8xOO8/uK0y0jKGPWUcIYhNLAb5rHV67U4QKCj81PEJH13Id8JLlCsBC+WsNnDk5BtJbYF2CPONBLhcmjd9tJ43Sj7cxcnoXGqZKJKE+8R4V8ww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747411219; c=relaxed/simple;
	bh=dlfXNqe7fgW+ic4s5DLoOQjk+cTXyw5CXxEJwqYfkUE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=q2mUN9+jZJNHM4QSGMf7bkmdc1PvafpOBiBuXt3g/FFf4AUBs8ja69L8tEOmHalFzk2HV+HFUPQxDZAL/ngsSGK+wHUUPO9ad1aNFRBIB+nrQkXTAnxLRgnRalfdVUHLhr1nWe5qf4FNBJiCiQ25aXN9iFLH6PuXlob36J/QnYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 711D4169C;
	Fri, 16 May 2025 09:00:05 -0700 (PDT)
Received: from [10.1.27.17] (e122027.cambridge.arm.com [10.1.27.17])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BC4D63F63F;
	Fri, 16 May 2025 09:00:13 -0700 (PDT)
Message-ID: <64fd76aa-10b0-4b4f-875c-6c24977464f9@arm.com>
Date: Fri, 16 May 2025 17:00:11 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 00/43] arm64: Support for Arm CCA in KVM
To: Gavin Shan <gshan@redhat.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
References: <20250416134208.383984-1-steven.price@arm.com>
 <fa874ef5-5da5-44de-a9d0-24663eb684a0@redhat.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <fa874ef5-5da5-44de-a9d0-24663eb684a0@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Gavin,

On 02/05/2025 01:46, Gavin Shan wrote:
> On 4/16/25 11:41 PM, Steven Price wrote:
> 
> [...]
> 
>>
>> The ABI to the RMM (the RMI) is based on RMM v1.0-rel0 specification[1].
>>
>> This series is based on v6.15-rc1. It is also available as a git
>> repository:
>>
>> https://gitlab.arm.com/linux-arm/linux-cca cca-host/v8
>>
>> Work in progress changes for kvmtool are available from the git
>> repository below:
>>
>> https://gitlab.arm.com/linux-arm/kvmtool-cca cca/v6
>>
>> [1] https://developer.arm.com/documentation/den0137/1-0rel0/
>> [2] https://lore.kernel.org/r/20250408105225.4002637-17-maz%40kernel.org
>>
> 
> I got a chance to try the following combination, the guest can boot using
> qemu/kvmtool except a RCU stall is observed (more details provided below)
> 
> host.tf-rmm      https://git.codelinaro.org/linaro/dcap/
> rmm.git                      (cca/v8)
> host.edk2        git@github.com:tianocore/
> edk2.git                                   (edk2-stable202411)
> host.tf-a        https://git.codelinaro.org/linaro/dcap/tf-a/trusted-
> firmware-a.git  (cca/v4)
> host.qemu        https://git.qemu.org/git/
> qemu.git                                   (stable-9.2)
> host.linux       https://git.gitlab.arm.com/linux-arm/linux-
> cca.git                  (cca-host/v8)
> host.buildroot   https://github.com/buildroot/
> buildroot                              (master)
> guest.qemu       https://git.codelinaro.org/linaro/dcap/
> qemu.git                     (cca/latest)
> guest.kvmtool    https://gitlab.arm.com/linux-arm/kvmtool-
> cca                        (cca/latest)
> guest.buildroot  https://github.com/buildroot/
> buildroot                              (master)
> 
> RCU stall report
> ----------------
> 
> [ 7816.381336] rcu: INFO: rcu_preempt self-detected stall on CPU
> [ 7816.382816] rcu:     6-....: (5249 ticks this GP)
> idle=3a4c/1/0x4000000000000000 softirq=6001/6003 fqs=2624
> [ 7816.384399] rcu:     (t=5250 jiffies g=29821 q=47 ncpus=8)
> [ 7816.386059] CPU: 6 UID: 0 PID: 203 Comm: qemu-system-aar Not tainted
> 6.15.0-rc1-gavin-g78b23c56de79 #34 PREEMPT
> [ 7816.387133] Hardware name: QEMU QEMU Virtual Machine, BIOS unknown
> 02/02/2022
> [ 7816.387926] pstate: 61402009 (nZCv daif +PAN -UAO -TCO +DIT -SSBS
> BTYPE=--)
> [ 7816.388678] pc : realm_unmap_private_range+0x19c/0x2c0
> [ 7816.389878] lr : realm_unmap_private_range+0x94/0x2c0
> [ 7816.390388] sp : ffff80008095bb60
> [ 7816.390765] x29: ffff80008095bb60 x28: 000000007caef000 x27:
> ffffba3322764000
> [ 7816.392321] x26: 00007fffffffffff x25: 000000007caf0000 x24:
> 0001000000000000
> [ 7816.393168] x23: 00000000c4000155 x22: ffff8000801b5e98 x21:
> 0000000106481000
> [ 7816.393999] x20: 000000007caef000 x19: 0000000000000000 x18:
> 0000000000000000
> [ 7816.394833] x17: 0000000000000000 x16: 0000000000000000 x15:
> 0000ffff8e997058
> [ 7816.395668] x14: 0000000000000000 x13: 0000000000000000 x12:
> 0000000000000000
> [ 7816.396548] x11: 0000000038e38e39 x10: 0000000000000004 x9 :
> ffffba33218a2564
> [ 7816.397419] x8 : ffff8000801b5e98 x7 : 000000003fffffff x6 :
> 0000000000000001
> [ 7816.398243] x5 : 000000011e795000 x4 : 0000000000000002 x3 :
> 0000000000000000
> [ 7816.399062] x2 : 000000007caf0000 x1 : 000000011e796000 x0 :
> 0000000000000000
> [ 7816.400021] Call trace:
> [ 7816.400604]  realm_unmap_private_range+0x19c/0x2c0 (P)

So I suspect this is because I didn't have a cond_resched_rwlock_write()
in here - which was (as you pointed out) because I hadn't propagated
"may_block" down. Finger's crossed this will be fixed with that change.

Thanks,
Steve

> [ 7816.401347]  kvm_realm_unmap_range+0x94/0xb0
> [ 7816.401894]  __unmap_stage2_range+0x70/0xa0
> [ 7816.402421]  kvm_arch_post_set_memory_attributes+0x68/0xa8
> [ 7816.403011]  kvm_vm_ioctl+0x6bc/0x1b58
> [ 7816.403509]  __arm64_sys_ioctl+0xa4/0xe8
> [ 7816.404020]  invoke_syscall+0x50/0x120
> [ 7816.404562]  el0_svc_common.constprop.0+0x48/0xf0
> [ 7816.405113]  do_el0_svc+0x24/0x38
> [ 7816.405584]  el0_svc+0x34/0xf0
> [ 7816.406045]  el0t_64_sync_handler+0x10c/0x138
> [ 7816.406571]  el0t_64_sync+0x1ac/0x1b0
> 
> Thanks,
> Gavin
> 


