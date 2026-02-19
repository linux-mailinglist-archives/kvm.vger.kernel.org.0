Return-Path: <kvm+bounces-71306-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KBf6KiZYlmljeAIAu9opvQ
	(envelope-from <kvm+bounces-71306-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 01:24:06 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E22E15B1F7
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 01:24:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 9EE0730219AF
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 00:24:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E7FF1F8691;
	Thu, 19 Feb 2026 00:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="brnuokkt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D3451EE033
	for <kvm@vger.kernel.org>; Thu, 19 Feb 2026 00:23:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771460638; cv=none; b=rb2QKn/vT6j4uJYwkgpiloGV1x5z9ks3e05vPjC65bC/o3lbP8/GHvdEQgJp+suXXnyF+ktO4LitUld7BbipgtJx+CJwL/YwyYA4Tzbtds/Ixoqi4CQnyAOWv/9SfRzQ83H0jN65MWsMrrAG5SDKWsRaVrku5Di7ALklK6Qb6Us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771460638; c=relaxed/simple;
	bh=rAqBEYNAXysalhMNEUfVtcZYqwWPBkjaiVkQtV/AuZM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Content-Type; b=UgETDEN+DyIJ3c9AR2PhHyRpQZITcNjRKPROw1eH7AayhW+BR6k2YG3fzp1otCSQR60F3lOZ9zYe9Lwaj/zXK5aaA+O+HSZ2DB8g9QIZ1A6QBwx2Wg/WYJcy7XCo34/FAqAB8SVCy4V9whvnyExb0dvmW+tfo9wFvFg+Kv5La74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=brnuokkt; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c6e78c4aa50so223122a12.0
        for <kvm@vger.kernel.org>; Wed, 18 Feb 2026 16:23:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771460636; x=1772065436; darn=vger.kernel.org;
        h=content-transfer-encoding:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XiFD3m6s2/150lOsOI0Sohku+FRajAhs29dEKFHBFp8=;
        b=brnuokktGNXYjzhzoQZ9iEUQWGd1YkPVnFzCnotXTX0ikdyFpX/ortMYtlBzy6sDiY
         KohNXTFcld6cOb6Vfh3dSPIJ4BaejNF51wiDCeXWANeH4zC4evumYuv/oPueaSxEtRND
         DFRXr2L/y5VAKggGullk2cj900vtDu38YXsqhtmMbCk+0YlxM3TysN3GTDdKfpmG+KTz
         rGHVQmFYlPh3tiDF9AbswIl+w77bgvCoSdTOVE+3ACGSO9fzhDAEl9NvYjF6tbHufpd+
         UG61TUU2Ub5GjscuZUXl49UwhaPtzUbUL4cr/tVErss81d3qqdkQ6y6A/d6mma3C8Eoe
         19IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771460636; x=1772065436;
        h=content-transfer-encoding:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=XiFD3m6s2/150lOsOI0Sohku+FRajAhs29dEKFHBFp8=;
        b=XuUqe2pe57BxLF1HyRlsHglED38AJKh9pLuIdMRj7caAf+SWVqI062Lracqj+CewFi
         KFBPJhiX4rnUjGo40/54rPv+ej21LL3SNYduQzmBkvFXZTkUJ8JTETKrBvqbzOYvYudT
         O1AT8sr6hirUaRPycGvF5//NOjKinhxrlAd3QEVYZ2YWKokVZKC3cv1/JM57eHX8ciYR
         6nw/CyVtON469b+undsZV3LzlxH6qIQqPX0SQMtVRxAqy4EqcOQNKiY8aQMfJH2dwvNB
         RSDfXNGYTv9CSnbQfRu0nuMZkh1lZh/tTKptBy1LhFLy8DyB6lFAYMOznGT8X3GHSXHL
         b1tA==
X-Forwarded-Encrypted: i=1; AJvYcCV8hT0QRVyEj/b7iF/ucx/HfAmI+vha/RUuKfqmrGoKn+dC0v4QCFr3FcHXcuqUjOU2V6g=@vger.kernel.org
X-Gm-Message-State: AOJu0YwLD29Djt1kkQQijs9NgkCRGR38jzioPPN4Owy6gHQLdu72gkwI
	uIViZzWLmRi/bo+I8RVNUxTOUE0HwWW6zODxcz95B1xWfaIRG1TeVfhgtM01XOJgKQ4vE3EIU91
	djMYkDg==
X-Received: from pgbcq8.prod.google.com ([2002:a05:6a02:4088:b0:c6e:3a04:21e3])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:6e97:b0:366:2677:4b38
 with SMTP id adf61e73a8af0-394fc2010edmr3382519637.8.1771460636397; Wed, 18
 Feb 2026 16:23:56 -0800 (PST)
Date: Thu, 19 Feb 2026 00:23:55 +0000
In-Reply-To: <20260219002241.2908563-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260219002241.2908563-1-seanjc@google.com>
Message-ID: <aZZYG_TXe_kfvXh0@google.com>
Subject: Re: [PATCH] KVM: x86/mmu: Don't create SPTEs for addresses that
 aren't mappable
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Yan Zhao <yan.y.zhao@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71306-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.dev:email,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,intel.com:email]
X-Rspamd-Queue-Id: 3E22E15B1F7
X-Rspamd-Action: no action

On Wed, Feb 18, 2026, Sean Christopherson wrote:
> Track the mask of guest physical address bits that can actually be mapped
> by a given MMU instance that utilizes TDP, and either exit to userspace
> with -EFAULT or go straight to emulation without creating an SPTE (for
> emulated MMIO) if KVM can't map the address.  Attempting to create an SPT=
E
> can cause KVM to drop the unmappable bits, and thus install a bad SPTE.
> E.g. when starting a walk, the TDP MMU will round the GFN based on the
> root level, and drop the upper bits.
>=20
> Exit with -EFAULT in the unlikely scenario userspace is misbehaving and
> created a memslot that can't be addressed, e.g. if userspace installed
> memory above the guest.MAXPHYADDR defined in CPUID, as there's nothing KV=
M
> can do to make forward progress, and there _is_ a memslot for the address=
.
> For emulated MMIO, KVM can at least kick the bad address out to userspace
> via a normal MMIO exit.
>=20
> The flaw has existed for a very long time, and was exposed by commit
> 988da7820206 ("KVM: x86/tdp_mmu: WARN if PFN changes for spurious faults"=
)
> thanks to a syzkaller program that prefaults memory at GPA 0x100000000000=
0
> and then faults in memory at GPA 0x0 (the extra-large GPA gets wrapped to
> '0').
>=20
>   WARNING: arch/x86/kvm/mmu/tdp_mmu.c:1183 at kvm_tdp_mmu_map+0x5c3/0xa30=
 [kvm], CPU#125: syz.5.22/18468
>   CPU: 125 UID: 0 PID: 18468 Comm: syz.5.22 Tainted: G S      W          =
 6.19.0-smp--23879af241d6-next #57 NONE
>   Tainted: [S]=3DCPU_OUT_OF_SPEC, [W]=3DWARN
>   Hardware name: Google Izumi-EMR/izumi, BIOS 0.20250917.0-0 09/17/2025
>   RIP: 0010:kvm_tdp_mmu_map+0x5c3/0xa30 [kvm]
>   Call Trace:
>    <TASK>
>    kvm_tdp_page_fault+0x107/0x140 [kvm]
>    kvm_mmu_do_page_fault+0x121/0x200 [kvm]
>    kvm_arch_vcpu_pre_fault_memory+0x18c/0x230 [kvm]
>    kvm_vcpu_pre_fault_memory+0x116/0x1e0 [kvm]
>    kvm_vcpu_ioctl+0x3a5/0x6b0 [kvm]
>    __se_sys_ioctl+0x6d/0xb0
>    do_syscall_64+0x8d/0x900
>    entry_SYSCALL_64_after_hwframe+0x4b/0x53
>    </TASK>
>=20
> In practice, the flaw is benign (other than the new WARN) as it only
> affects guests that ignore guest.MAXPHYADDR (e.g. on CPUs with 52-bit
> physical addresses but only 4-level paging) or guests being run by a
> misbehaving userspace VMM (e.g. a VMM that ignored allow_smaller_maxphyad=
dr
> or is pre-faulting bad addresses).
>=20
> For non-TDP shadow paging, always clear the unmappable mask as the flaw
> only affects GPAs affected.  For 32-bit paging, 64-bit virtual addresses
> simply don't exist.  Even when software can shove a 64-bit address
> somewhere, e.g. into SYSENTER_EIP, the value is architecturally truncated
> before it reaches the page table walker.  And for 64-bit paging, KVM's us=
e
> of 4-level vs. 5-level paging is tied to the guest's CR4.LA57, i.e. KVM
> won't observe a 57-bit virtual address with a 4-level MMU.
>=20
> Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
> Cc: Yan Zhao <yan.y.zhao@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---

Here's the full syzkaller reproducer (found on a manual run internally, so =
syzbot
didn't do the work for us).

FWIW, I don't love this approach, but I couldn't come up with anything bett=
er.

ioctl$KVM_SET_LAPIC(0xffffffffffffffff, 0x4400ae8f, &(0x7f0000000100)=3D{"b=
46474f815e8d5535f0887c44335cc824dc6121bc72a77f532ff5dad4d643a9cab29d2310e04=
be14eb26c0af4985fe45e3b3b0680b3ec92725d74b9716e0f7c3119a2c9a0ae65ff4772e2e1=
2733cb013c4308fe40863480747c0a7ddb9361b1578015ca1bb2c1677ebae096f08345476f5=
67443842946ed946434c75916d1db83fe305920de65bfaf9bd940672216846cb16b8ae67cd3=
affc61375381f91b3b9f1cc5e38cafe5239aee71dcd481fbe1ecd2547ffbaad4469a74697c2=
8fb9beefa6a5d736712a55eb9110c2cf7964062ba8cbc1c038e84f0f5db7fc7053118bf5221=
e3efa6fc3edb5d0ca3cde7054dd0751a332520aa8478b1775d552c5cc24d3c2df9eb333e5ca=
3aa06c1c2cf8526714f5caff2f55b41976fc20b64f1fc61d5b44f50953582a1825d32130a31=
abfeafd1987317879e29ac51b93c9659e023fff3ddb5e39dd19cc3ef1d883c78b9e073d08a9=
197fb3717df238b9831831214b186693be9dd2568bb77272e80df5dfed03e8c467627bedfbd=
93359a9f79a3aa37e873dc1357b37b43d813ea85267b0dc8b1c4cc51bd985328833beb2679b=
7fb762555bbea2da936b36f8f1673fd5f606b2b6eb23b72bf947206e8dbfeb40ca6f265a348=
5c8446e0f0da652860b88328073d2282c14b48a7774e62754a968b60e92205e8fafcdd70a55=
c3c4d1a4821ff44e6e3681f15ae091262e3a3290a24d8ceae30ebbf9d24287bb8a5d73c608d=
47d287f9e716cf02b4796a83fb0c05e45b89de9ef8bce834e6d7a0be6e30d2c66cb6e640cb0=
1898454ad361bc0701d8fe56113335ae6adec59300db04691cc4a689034272a8e086a32ce70=
61b4f79fa8afbb48a6ce4b62bdc44af013d78980457e1fa61eb9204818606f4c3b03c0f33cd=
2a841ac9bc2b73151a96e31ab99e6ec969b5f2c3edd5f9abc69845e487af992758ba445368d=
a93dae1d44360d52a534a88276b8aaf349841d8a4788c60408618437c442308dbf70efeda2e=
54e9b9e4fe5f76997c9dcb945a26bd75748c85d19ca8b99264dce50580e8d4dbda401dad7df=
31e9a7a6a3a83bfbdfb5394abd581ac0824fbcd75d2f5205c0b7c9188e6f26bfd97734d9a20=
433f6cdba9d14a5f32a4d97a57f4603b21146fd1aebf082e863d463c224ad623c17d8043d3b=
f083f0322408dd6ead6915ac6a4222ab51480eb6e11a8913348219515170d9df90d72d7363b=
bda3e327d19f98c0a856f98076380e788e602e8a2ae0a1930786874dc21a2e99abda15f3545=
7cf1dcb440c4b41350d0eda352aad7f57a0adc8a6914da06460635ed21c4c11cd1a8ec77806=
4c9f62efba2927828b23f94b16619a5520731c2c40ab8583c9f2e73233d74b84f4877ce6b35=
bb1180300"})
r0 =3D openat$kvm(0xffffff9c, &(0x7f00000000c0), 0x0, 0x0)
r1 =3D ioctl$KVM_CREATE_VM(r0, 0xae01, 0x0)
r2 =3D ioctl$KVM_CREATE_VCPU(r1, 0xae41, 0x0)
ioctl$KVM_SET_USER_MEMORY_REGION(r1, 0x4020ae46, &(0x7f0000000080)=3D{0x0, =
0x0, 0x0, 0x2000, &(0x7f0000000000/0x2000)=3Dnil})
ioctl$KVM_SET_REGS(r2, 0x4090ae82, &(0x7f0000000200)=3D{[0x0, 0x6, 0xffffff=
fffffffffd, 0x0, 0xfffd, 0x1, 0x4002004c4, 0x1000, 0x0, 0x0, 0x0, 0x0, 0x3]=
, 0x25000, 0x2011c0})
ioctl$KVM_RUN(r2, 0xae80, 0x0)
ioctl$KVM_PRE_FAULT_MEMORY(r2, 0xc040aed5, &(0x7f0000000000)=3D{0x0, 0x1800=
0})
ioctl$KVM_SET_PIT2(0xffffffffffffffff, 0x4070aea0, &(0x7f0000000100)=3D{[{0=
x7ff, 0x93, 0x0, 0xc0, 0xc0, 0x92, 0x85, 0x8, 0x6, 0xa, 0x0, 0x7, 0x8001}, =
{0x5, 0x2, 0xf9, 0x8, 0x7c, 0xf, 0xd, 0x1, 0x5, 0x3, 0x7, 0xa, 0x7}, {0x7, =
0x71b0, 0x3, 0x3, 0xf8, 0x1, 0x8, 0x3, 0x8, 0x82, 0xc, 0xa4, 0x6}], 0xfffff=
ffa})

