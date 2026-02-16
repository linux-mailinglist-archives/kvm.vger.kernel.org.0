Return-Path: <kvm+bounces-71130-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cB6gNcZZk2k73wEAu9opvQ
	(envelope-from <kvm+bounces-71130-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 16 Feb 2026 18:54:14 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C2A2146D24
	for <lists+kvm@lfdr.de>; Mon, 16 Feb 2026 18:54:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 81B773004CA9
	for <lists+kvm@lfdr.de>; Mon, 16 Feb 2026 17:54:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC82E2EF64F;
	Mon, 16 Feb 2026 17:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="OdhuiIOE"
X-Original-To: kvm@vger.kernel.org
Received: from fra-out-002.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-002.esa.eu-central-1.outbound.mail-perimeter.amazon.com [3.65.3.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC9D72773E5;
	Mon, 16 Feb 2026 17:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=3.65.3.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771264444; cv=none; b=dZEkB3F0gBk8LIRQBE2zYqSzHPbdVJo6FeSuwVTjBwwXxn1ATz9mE436ZYBFFDG1J08Y9spJrYcLeA+eJu2Gbw52ugapOfxGjBJ9KYjhAtVCsGLMhSTjgKx6Rd0I8IT/bJHqCZAjA0tW9532T1ghoQe55+mDF0GO3BQxp2qZ4zI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771264444; c=relaxed/simple;
	bh=/OPoQ4m9Bh4larLwHoYLzwbNQTh8Xp/G9qiorISC+cA=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=IensaGwhdwTxhUysSSlic5VSfP6eDrJy8YRjQ15AryEGuP3nKMU60dqpgENWbJHdD2KhARrqZa0AKOJu3WUe0uMjuDo0NTedqVEE2mMljeOUQ7394FcJFL4vP/skkhhJak/Uq4e1H8oFwYjKC5vQrvgHaF5HUIyZsmCbj0wUqX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=OdhuiIOE; arc=none smtp.client-ip=3.65.3.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1771264442; x=1802800442;
  h=message-id:date:mime-version:reply-to:subject:to:cc:
   references:from:in-reply-to:content-transfer-encoding;
  bh=xRJr1BxUVy81vOLOHmZNuiLSIyY1c4pkA4AMT3x7FlM=;
  b=OdhuiIOEaSX5zYawBzir+sIKUTx7JeOmzWHy8dnfnBX76KWOTDJe3v9P
   UwYqoTlWIoUi/tY/z08G6UI46wiCLfAn13Xl4MZQ2aOY3Uo3guTSSFLo8
   aWw5eNiC3uqWAQ4DxP3GnpAWBwUl4ger7QbcUN5V5/ihaE78KI/QezuHK
   +JwVmlk9yEISnnyuYZ0YuX0bwhEVrVS0SiFCO1TkjMqwSdW8HBFpqQH2i
   DNowitw6Z884Fs1JQfdXbn4rSz13dTb7x72QsYtP6lVe24ff1KW8j6bz7
   7Z2LcbpAZAZsdlm1Y3HeBvM4fJ117LQUmEc2hPcKKE7Ne+2T7Ce3Tvlnh
   g==;
X-CSE-ConnectionGUID: efT7Zpy3QrulWZTje+jljA==
X-CSE-MsgGUID: Hxc3CJ4RTZuc556KvQ3Bow==
X-IronPort-AV: E=Sophos;i="6.21,294,1763424000"; 
   d="scan'208";a="9539976"
Received: from ip-10-6-6-97.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.6.97])
  by internal-fra-out-002.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2026 17:53:58 +0000
Received: from EX19MTAEUB001.ant.amazon.com [54.240.197.234:7682]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.19.89:2525] with esmtp (Farcaster)
 id 4dbc0cc7-432d-45ce-8078-fa45b54969a3; Mon, 16 Feb 2026 17:53:58 +0000 (UTC)
X-Farcaster-Flow-ID: 4dbc0cc7-432d-45ce-8078-fa45b54969a3
Received: from EX19D005EUB003.ant.amazon.com (10.252.51.31) by
 EX19MTAEUB001.ant.amazon.com (10.252.51.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Mon, 16 Feb 2026 17:53:55 +0000
Received: from [192.168.2.117] (10.106.83.6) by EX19D005EUB003.ant.amazon.com
 (10.252.51.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35; Mon, 16 Feb 2026
 17:53:55 +0000
Message-ID: <dcbd7a58-c961-4510-ae48-ef7fd4f4d75c@amazon.com>
Date: Mon, 16 Feb 2026 17:53:53 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: <kalyazin@amazon.com>
Subject: Re: [PATCH v4 4/4] KVM: Avoid synchronize_srcu() in
 kvm_io_bus_register_dev()
To: Sean Christopherson <seanjc@google.com>
CC: Keir Fraser <keirf@google.com>, <linux-arm-kernel@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, Eric Auger
	<eric.auger@redhat.com>, Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier
	<maz@kernel.org>, Will Deacon <will@kernel.org>, Paolo Bonzini
	<pbonzini@redhat.com>, Li RongQing <lirongqing@baidu.com>
References: <20250909100007.3136249-1-keirf@google.com>
 <20250909100007.3136249-5-keirf@google.com>
 <a84ddba8-12da-489a-9dd1-ccdf7451a1ba@amazon.com>
 <aY-x0OlJQEqInyNF@google.com>
Content-Language: en-US
From: Nikita Kalyazin <kalyazin@amazon.com>
Autocrypt: addr=kalyazin@amazon.com; keydata=
 xjMEY+ZIvRYJKwYBBAHaRw8BAQdA9FwYskD/5BFmiiTgktstviS9svHeszG2JfIkUqjxf+/N
 JU5pa2l0YSBLYWx5YXppbiA8a2FseWF6aW5AYW1hem9uLmNvbT7CjwQTFggANxYhBGhhGDEy
 BjLQwD9FsK+SyiCpmmTzBQJnrNfABQkFps9DAhsDBAsJCAcFFQgJCgsFFgIDAQAACgkQr5LK
 IKmaZPOpfgD/exazh4C2Z8fNEz54YLJ6tuFEgQrVQPX6nQ/PfQi2+dwBAMGTpZcj9Z9NvSe1
 CmmKYnYjhzGxzjBs8itSUvWIcMsFzjgEY+ZIvRIKKwYBBAGXVQEFAQEHQCqd7/nb2tb36vZt
 ubg1iBLCSDctMlKHsQTp7wCnEc4RAwEIB8J+BBgWCAAmFiEEaGEYMTIGMtDAP0Wwr5LKIKma
 ZPMFAmes18AFCQWmz0MCGwwACgkQr5LKIKmaZPNTlQEA+q+rGFn7273rOAg+rxPty0M8lJbT
 i2kGo8RmPPLu650A/1kWgz1AnenQUYzTAFnZrKSsXAw5WoHaDLBz9kiO5pAK
In-Reply-To: <aY-x0OlJQEqInyNF@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: EX19D006EUA002.ant.amazon.com (10.252.50.65) To
 EX19D005EUB003.ant.amazon.com (10.252.51.31)
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-9.16 / 15.00];
	WHITELIST_DMARC(-7.00)[amazon.com:D:+];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[amazon.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[amazon.com:s=amazoncorp2];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[amazon.com:+];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71130-lists,kvm=lfdr.de];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns];
	HAS_REPLYTO(0.00)[kalyazin@amazon.com];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kalyazin@amazon.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	PRECEDENCE_BULK(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 0C2A2146D24
X-Rspamd-Action: no action



On 13/02/2026 23:20, Sean Christopherson wrote:
> On Fri, Feb 13, 2026, Nikita Kalyazin wrote:
>>
>>
>> On 09/09/2025 11:00, Keir Fraser wrote:
>>> Device MMIO registration may happen quite frequently during VM boot,
>>> and the SRCU synchronization each time has a measurable effect
>>> on VM startup time. In our experiments it can account for around 25%
>>> of a VM's startup time.
>>>
>>> Replace the synchronization with a deferred free of the old kvm_io_bus
>>> structure.
>>
>>
>> Hi,
>>
>> We noticed that this change introduced a regression of ~20 ms to the first
>> KVM_CREATE_VCPU call of a VM, which is significant for our use case.
>>
>> Before the patch:
>> 45726 14:45:32.914330 ioctl(25, KVM_CREATE_VCPU, 0) = 28 <0.000137>
>> 45726 14:45:32.914533 ioctl(25, KVM_CREATE_VCPU, 1) = 30 <0.000046>
>>
>> After the patch:
>> 30295 14:47:08.057412 ioctl(25, KVM_CREATE_VCPU, 0) = 28 <0.025182>
>> 30295 14:47:08.082663 ioctl(25, KVM_CREATE_VCPU, 1) = 30 <0.000031>
>>
>> The reason, as I understand, it happens is call_srcu() called from
>> kvm_io_bus_register_dev() are adding callbacks to be called after a normal
>> GP, which is 10 ms with HZ=100.  The subsequent synchronize_srcu_expedited()
>> called from kvm_swap_active_memslots() (from KVM_CREATE_VCPU) has to wait
>> for the normal GP to complete before making progress.  I don't fully
>> understand why the delay is consistently greater than 1 GP, but that's what
>> we see across our testing scenarios.
>>
>> I verified that the problem is relaxed if the GP is reduced by configuring
>> HZ=1000.  In that case, the regression is in the order of 1 ms.
>>
>> It looks like in our case we don't benefit much from the intended
>> optimisation as the number of device MMIO registrations is limited and and
>> they don't cost us much (each takes at most 16 us, but most commonly ~6 us):
> 
> Maybe differences in platforms for arm64 vs x86?

Tested on ARM, and indeed kvm_io_bus_register_dev are occurring after 
KVM_CREATE_VCPU, and the patch produces a visible optimisation:

Without the patch (15-23 us per call):

      firecracker 19916 [033]   404.518430: 
probe:kvm_vm_ioctl_create_vcpu: (ffff800080059b18)
      firecracker 19916 [033]   404.518446: 
probe:kvm_vm_ioctl_create_vcpu: (ffff800080059b18)
      firecracker 19916 [033]   404.518462: 
probe:kvm_io_bus_register_dev: (ffff80008005f0e8)
      firecracker 19916 [032]   404.518495: 
probe:kvm_io_bus_register_dev__return: (ffff80008005f0e8 <- 
ffff8000800a198c)
      firecracker 19916 [032]   404.518498: 
probe:kvm_io_bus_register_dev: (ffff80008005f0e8)
      firecracker 19916 [033]   404.518521: 
probe:kvm_io_bus_register_dev__return: (ffff80008005f0e8 <- 
ffff8000800a198c)
      firecracker 19916 [033]   404.518524: 
probe:kvm_io_bus_register_dev: (ffff80008005f0e8)
      firecracker 19916 [032]   404.518539: 
probe:kvm_io_bus_register_dev__return: (ffff80008005f0e8 <- 
ffff8000800a6d2c)
      firecracker 19916 [032]   404.526900: 
probe:kvm_io_bus_register_dev: (ffff80008005f0e8)
      firecracker 19916 [033]   404.526924: 
probe:kvm_io_bus_register_dev__return: (ffff80008005f0e8 <- 
ffff800080060168)
      firecracker 19916 [033]   404.526926: 
probe:kvm_io_bus_register_dev: (ffff80008005f0e8)
      firecracker 19916 [032]   404.526941: 
probe:kvm_io_bus_register_dev__return: (ffff80008005f0e8 <- 
ffff800080060168)
        fc_vcpu 0 19924 [035]   404.530829: 
probe:kvm_io_bus_register_dev: (ffff80008005f0e8)
        fc_vcpu 0 19924 [035]   404.530848: 
probe:kvm_io_bus_register_dev__return: (ffff80008005f0e8 <- 
ffff80008009f6b4)

With the patch (1-6 us per call):

      firecracker 22806 [032]   427.687157: 
probe:kvm_vm_ioctl_create_vcpu: (ffff800080059b38)
      firecracker 22806 [032]   427.687174: 
probe:kvm_vm_ioctl_create_vcpu: (ffff800080059b38)
      firecracker 22806 [032]   427.687193: 
probe:kvm_io_bus_register_dev: (ffff80008005f128)
      firecracker 22806 [032]   427.687196: 
probe:kvm_io_bus_register_dev__return: (ffff80008005f128 <- 
ffff8000800a19cc)
      firecracker 22806 [032]   427.687196: 
probe:kvm_io_bus_register_dev: (ffff80008005f128)
      firecracker 22806 [032]   427.687197: 
probe:kvm_io_bus_register_dev__return: (ffff80008005f128 <- 
ffff8000800a19cc)
      firecracker 22806 [032]   427.687201: 
probe:kvm_io_bus_register_dev: (ffff80008005f128)
      firecracker 22806 [032]   427.687202: 
probe:kvm_io_bus_register_dev__return: (ffff80008005f128 <- 
ffff8000800a6d6c)
      firecracker 22806 [029]   427.707660: 
probe:kvm_io_bus_register_dev: (ffff80008005f128)
      firecracker 22806 [029]   427.707666: 
probe:kvm_io_bus_register_dev__return: (ffff80008005f128 <- 
ffff8000800601a8)
      firecracker 22806 [029]   427.707667: 
probe:kvm_io_bus_register_dev: (ffff80008005f128)
      firecracker 22806 [029]   427.707668: 
probe:kvm_io_bus_register_dev__return: (ffff80008005f128 <- 
ffff8000800601a8)
        fc_vcpu 0 22829 [030]   427.711642: 
probe:kvm_io_bus_register_dev: (ffff80008005f128)
        fc_vcpu 0 22829 [030]   427.711645: 
probe:kvm_io_bus_register_dev__return: (ffff80008005f128 <- 
ffff80008009f6f4)


Also, it is the KVM_SET_USER_MEMORY_REGION (not KVM_CREATE_VCPU) that is 
hit on ARM (but seems to be for the same reason):

45736 17:30:10.251430 ioctl(17, KVM_SET_USER_MEMORY_REGION, {slot=0, 
flags=0, guest_phys_addr=0x80000000, memory_size=12884901888, 
userspace_addr=0xfffcbedd6000}) = 0 <0.021021>

vs

30694 17:33:01.128985 ioctl(17, KVM_SET_USER_MEMORY_REGION, {slot=0, 
flags=0, guest_phys_addr=0x80000000, memory_size=12884901888, 
userspace_addr=0xfffc91fc9000}) = 0 <0.000016>

> 
>> I am not aware of way to make it fast for both use cases and would be more
>> than happy to hear about possible solutions.
> 
> What if we key off of vCPUS being created?  The motivation for Keir's change was
> to avoid stalling during VM boot, i.e. *after* initial VM creation.

It doesn't work as is on x86 because the delay we're seeing occurs after 
the created_cpus gets incremented so it doesn't allow to differentiate 
the two cases (below is kvm_vm_ioctl_create_vcpu):

	kvm->created_vcpus++; // <===== incremented here
	mutex_unlock(&kvm->lock);

	vcpu = kmem_cache_zalloc(kvm_vcpu_cache, GFP_KERNEL_ACCOUNT);
	if (!vcpu) {
		r = -ENOMEM;
		goto vcpu_decrement;
	}

	BUILD_BUG_ON(sizeof(struct kvm_run) > PAGE_SIZE);
	page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
	if (!page) {
		r = -ENOMEM;
		goto vcpu_free;
	}
	vcpu->run = page_address(page);

	kvm_vcpu_init(vcpu, kvm, id);

	r = kvm_arch_vcpu_create(vcpu); // <===== the delay is here


firecracker   583 [001]   151.297145: 
probe:synchronize_srcu_expedited: (ffffffff813e5cf0)
     ffffffff813e5cf1 synchronize_srcu_expedited+0x1 ([kernel.kallsyms])
     ffffffff81234986 kvm_swap_active_memslots+0x136 ([kernel.kallsyms])
     ffffffff81236cdd kvm_set_memslot+0x1cd ([kernel.kallsyms])
     ffffffff81237518 kvm_set_memory_region.part.0+0x478 ([kernel.kallsyms])
     ffffffff81264dbc __x86_set_memory_region+0xec ([kernel.kallsyms])
     ffffffff8127e2dc kvm_alloc_apic_access_page+0x5c ([kernel.kallsyms])
     ffffffff812b9ed3 vmx_vcpu_create+0x193 ([kernel.kallsyms])
     ffffffff8126788a kvm_arch_vcpu_create+0x1da ([kernel.kallsyms])
     ffffffff8123c54c kvm_vm_ioctl+0x5fc ([kernel.kallsyms])
     ffffffff8167b331 __x64_sys_ioctl+0x91 ([kernel.kallsyms])
     ffffffff8251a89c do_syscall_64+0x4c ([kernel.kallsyms])
     ffffffff8100012b entry_SYSCALL_64_after_hwframe+0x76 
([kernel.kallsyms])
               6512de ioctl+0x32 (/mnt/host/firecracker)
                d99a7 std::rt::lang_start+0x37 (/mnt/host/firecracker)


Also, given that it stumbles after the KVM_CREATE_VCPU on ARM (in 
KVM_SET_USER_MEMORY_REGION), it doesn't look like a universal solution.


> 
> --
> From: Sean Christopherson <seanjc@google.com>
> Date: Fri, 13 Feb 2026 15:15:01 -0800
> Subject: [PATCH] KVM: Synchronize SRCU on I/O device registration if vCPUs
>   haven't been created
> 
> TODO: Write a changelog if this works.
> 
> Fixes: 7d9a0273c459 ("KVM: Avoid synchronize_srcu() in kvm_io_bus_register_dev()")
> Reported-by: Nikita Kalyazin <kalyazin@amazon.com>
> Closes: https://lkml.kernel.org/r/a84ddba8-12da-489a-9dd1-ccdf7451a1ba%40amazon.com
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   virt/kvm/kvm_main.c | 25 ++++++++++++++++++++++++-
>   1 file changed, 24 insertions(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 571cf0d6ec01..043b1c3574ab 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -6027,7 +6027,30 @@ int kvm_io_bus_register_dev(struct kvm *kvm, enum kvm_bus bus_idx, gpa_t addr,
>          memcpy(new_bus->range + i + 1, bus->range + i,
>                  (bus->dev_count - i) * sizeof(struct kvm_io_range));
>          rcu_assign_pointer(kvm->buses[bus_idx], new_bus);
> -       call_srcu(&kvm->srcu, &bus->rcu, __free_bus);
> +
> +       /*
> +        * To optimize VM creation *and* boot time, use different tactics for
> +        * safely freeing the old bus based on where the VM is at in its
> +        * lifecycle.  If vCPUs haven't yet been created, simply synchronize
> +        * and free, as there are unlikely to be active SRCU readers; if not,
> +        * defer freeing the bus via SRCU callback.
> +        *
> +        * If there are active SRCU readers, synchronizing will stall until the
> +        * current grace period completes, which can meaningfully impact boot
> +        * time for VMs that trigger a large number of registrations.
> +        *
> +        * If there aren't SRCU readers, using an SRCU callback can be a net
> +        * negative due to starting a grace period of its own, which in turn
> +        * can unnecessarily cause a future synchronization to stall.  E.g. if
> +        * devices are registered before memslots are created, then creating
> +        * the first memslot will have to wait for a superfluous grace period.
> +        */
> +       if (!READ_ONCE(kvm->created_vcpus)) {
> +               synchronize_srcu_expedited(&kvm->srcu);
> +               kfree(bus);
> +       } else {
> +               call_srcu(&kvm->srcu, &bus->rcu, __free_bus);
> +       }
> 
>          return 0;
>   }
> 
> base-commit: 183bb0ce8c77b0fd1fb25874112bc8751a461e49
> --


