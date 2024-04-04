Return-Path: <kvm+bounces-13574-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8EC0F898BBE
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 18:04:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C28A9B2AB99
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 16:03:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 807F712AAF2;
	Thu,  4 Apr 2024 16:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b="SYBDOVFL"
X-Original-To: kvm@vger.kernel.org
Received: from madrid.collaboradmins.com (madrid.collaboradmins.com [46.235.227.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00F29839FC;
	Thu,  4 Apr 2024 16:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.227.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712246620; cv=none; b=N0XwL/kns7j7H2Ooka185B8zCJr3TlY5OHH8flnk+nbS1GcTRQUqCO77YStPGKTvLGJFlSEJ7pNLXkHU5LTurXSIJjI+R1wPI4XJvJCOrgHt2wGjuvLS5bqQpVAc+il7pdCpMFLr6nBVt3vS344P2BMEihdQIQYmPrt8wtskjzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712246620; c=relaxed/simple;
	bh=eUp921iF2Ni3+2GuUlziJBbNXocWXTpROaZ4SOL9tPg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IjFGal1jZBNOMmoJ+8cjMvuJAh316oLANHzGFyla6WGTJjrF9eokCwTrQ4Ol6w/6sON1ymL0ksLHbHDa8rdjDZvlrzQ1FtCT3P5bxZ9Ukvx/W6H3Dk3Jo8jxHYETW+iVzOfPisA6/+xxxIgxEF80LIBHeiSRqWXonVvFkkrMgD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b=SYBDOVFL; arc=none smtp.client-ip=46.235.227.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1712246617;
	bh=eUp921iF2Ni3+2GuUlziJBbNXocWXTpROaZ4SOL9tPg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=SYBDOVFLk741a5OQ5y1Gg32de6U+d/kU0L4bZkUiliMMYWcLa4ngbnnyBBqx0rNKf
	 4CQreXfppS223GWtwHvaAzBsS/oGTSf4+XKJ+2Wdwgrh70aoi3St2ylhFxoF4VjJx0
	 7ClPLSm0WY4kxn3CxeslnioNDutGGIhkP19xVlLrpYhJAKv4DTLSGWvC0LH06aNPzv
	 E4z0YWjpCzSkazlYVegkjGBBlwoY3Bk5/hBEuxW6/jckL7DcOrZYDRCDZhK4H3csLo
	 0bFgvzW2roIP/xu+IjFP8zsEb8Qp690i8+koNDLHm7mneX+NhDp961K7wW4AHutRrr
	 sJ19KTZyhxIeg==
Received: from [100.109.49.129] (cola.collaboradmins.com [195.201.22.229])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: dmitry.osipenko)
	by madrid.collaboradmins.com (Postfix) with ESMTPSA id 5C4A937813A4;
	Thu,  4 Apr 2024 16:03:36 +0000 (UTC)
Message-ID: <15865985-4688-4b7e-9f2d-89803adb8f5b@collabora.com>
Date: Thu, 4 Apr 2024 19:03:33 +0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 8/8] KVM: x86/mmu: Handle non-refcounted pages
To: David Stevens <stevensd@chromium.org>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>,
 Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>
Cc: Yu Zhang <yu.c.zhang@linux.intel.com>,
 Isaku Yamahata <isaku.yamahata@gmail.com>,
 Zhi Wang <zhi.wang.linux@gmail.com>, Maxim Levitsky <mlevitsk@redhat.com>,
 kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20240229025759.1187910-1-stevensd@google.com>
 <20240229025759.1187910-9-stevensd@google.com>
Content-Language: en-US
From: Dmitry Osipenko <dmitry.osipenko@collabora.com>
In-Reply-To: <20240229025759.1187910-9-stevensd@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi David,

On 2/29/24 05:57, David Stevens wrote:
> From: David Stevens <stevensd@chromium.org>
> 
> Handle non-refcounted pages in __kvm_faultin_pfn. This allows the
> host to map memory into the guest that is backed by non-refcounted
> struct pages - for example, the tail pages of higher order non-compound
> pages allocated by the amdgpu driver via ttm_pool_alloc_page.
> 
> Signed-off-by: David Stevens <stevensd@chromium.org>

This patch has a problem on v6.8 kernel. Pierre-Eric of AMD found that
Qemu crashes with "kvm bad address" error when booting Ubuntu 23.10 ISO
with a disabled virtio-gpu and I was able to reproduce it. Pierre-Eric
said this problem didn't exist with v6.7 kernel and using v10 kvm
patches. Could you please take a look at this issue?

To reproduce the bug, run Qemu like this and load the Ubuntu installer:

  qemu-system-x86_64 -boot d -cdrom ubuntu-23.10.1-desktop-amd64.iso -m
4G --enable-kvm -display gtk -smp 1 -machine q35

Qemu fails with "error: kvm run failed Bad address"

On the host kernel there is this warning:

 ------------[ cut here ]------------
 WARNING: CPU: 19 PID: 11696 at mm/gup.c:229 try_grab_page+0x64/0x100
 Call Trace:
  <TASK>
  ? try_grab_page+0x64/0x100
  ? __warn+0x81/0x130
  ? try_grab_page+0x64/0x100
  ? report_bug+0x171/0x1a0
  ? handle_bug+0x3c/0x80
  ? exc_invalid_op+0x17/0x70
  ? asm_exc_invalid_op+0x1a/0x20
  ? try_grab_page+0x64/0x100
  follow_page_pte+0xfa/0x4b0
  __get_user_pages+0xe5/0x6e0
  get_user_pages_unlocked+0xe7/0x370
  hva_to_pfn+0xa2/0x760 [kvm]
  ? free_unref_page+0xf9/0x180
  kvm_faultin_pfn+0x112/0x610 [kvm]
  kvm_tdp_page_fault+0x104/0x150 [kvm]
  kvm_mmu_page_fault+0x298/0x860 [kvm]
  kvm_arch_vcpu_ioctl_run+0xc7d/0x16b0 [kvm]
  ? srso_alias_return_thunk+0x5/0xfbef5
  ? kvm_arch_vcpu_put+0x128/0x190 [kvm]
  ? srso_alias_return_thunk+0x5/0xfbef5
  kvm_vcpu_ioctl+0x199/0x700 [kvm]
  __x64_sys_ioctl+0x94/0xd0
  do_syscall_64+0x86/0x170
  ? kvm_on_user_return+0x64/0x90 [kvm]
  ? srso_alias_return_thunk+0x5/0xfbef5
  ? fire_user_return_notifiers+0x37/0x70
  ? srso_alias_return_thunk+0x5/0xfbef5
  ? syscall_exit_to_user_mode+0x80/0x230
  ? srso_alias_return_thunk+0x5/0xfbef5
  ? do_syscall_64+0x96/0x170
  ? srso_alias_return_thunk+0x5/0xfbef5
  ? do_syscall_64+0x96/0x170
  ? do_syscall_64+0x96/0x170
  ? do_syscall_64+0x96/0x170
  ? srso_alias_return_thunk+0x5/0xfbef5
  ? do_syscall_64+0x96/0x170
  ? srso_alias_return_thunk+0x5/0xfbef5
  entry_SYSCALL_64_after_hwframe+0x6e/0x76
 ---[ end trace 0000000000000000 ]---

-- 
Best regards,
Dmitry


