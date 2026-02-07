Return-Path: <kvm+bounces-70534-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id nriwGrmvhmkCQAQAu9opvQ
	(envelope-from <kvm+bounces-70534-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 07 Feb 2026 04:21:29 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B21DE104C70
	for <lists+kvm@lfdr.de>; Sat, 07 Feb 2026 04:21:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id DB6F8301739F
	for <lists+kvm@lfdr.de>; Sat,  7 Feb 2026 03:21:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A892D33D6F6;
	Sat,  7 Feb 2026 03:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="U3tNzHqP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f46.google.com (mail-oo1-f46.google.com [209.85.161.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A330D252917
	for <kvm@vger.kernel.org>; Sat,  7 Feb 2026 03:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770434484; cv=pass; b=bZr3waDgqUTX3dNRbRl/VcFOBIJTK6q8WIxVxu7D47yjiX4fSh12bA6VEJk7eCv66UXdCLgQBt8VWQUU3DaL6CbXbye5Yf4Ht66U5S6pML/9kez9GqcG6ubX1EgIqsxxxAmoz3QrXDtlTW3OXlu9bymCggNKB9Gnqw1SsKVrIKM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770434484; c=relaxed/simple;
	bh=W5mJvwHC/NVykufeQ+msSyj6wEsGgnLifWNe+ZddKGo=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=qaPWHAdFNoSaL/nmHx74O2maLmSpgs/rINnVQucWMAbrjx5BpOJoTQRWAVNAMXjcs2VGM8Di4uGRR1jmE+KBRh8VyB2kp1E/GFQPw7SNICaJohXvXbtjiwCGgqWYDV9LLwqN823Shj4SpvZ2x9bFg1OfCraybBaacInjdBKLRZE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=U3tNzHqP; arc=pass smtp.client-ip=209.85.161.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-oo1-f46.google.com with SMTP id 006d021491bc7-66a12c77a2cso1561511eaf.3
        for <kvm@vger.kernel.org>; Fri, 06 Feb 2026 19:21:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770434483; cv=none;
        d=google.com; s=arc-20240605;
        b=L9Oo7OTNMuDvrOAmXCbo6/0EMjNcHUxGg0sZfp9A2pvNGloMf+7spYkJ237awvXZcD
         7PVfXDv8uHMiOwiZg87faJdUKAq6ODS4ZmMbjvP9zc33xEFxoXuzbdzKkL52jl9GtJmo
         8U4PlJS02XeMNf4FqEH20MT5+5fwuFMXsHI9RAVfVNANaopiJOZiYCKm1VZJEqKdSqqj
         T0xpXdiVQcIGXMgArJxJ/6SqVQ5T/wpEmwGLyopCInX2On9a16vBmJoCJTCom3Vrs4vW
         9RAUpNTU81UcDsZZ/bpY0LC8OeLuFylLf7drY/OUbDaZOEppVkRMRPtOyIy5E4UB5/E/
         sNvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=DDnvhXep83DlBOrKWoBYx9m4Ze6xzsCfCU7TNyv34F8=;
        fh=6SVwKkNmmLwa7LUy5OrGKLxNdUyB35iQFAsQTtRvfBk=;
        b=WHK3JnVXy0ezCWRzXvVpG5mGA0gZnQX2gvXi+1xchVU+QNDLzayQjAq0j66SGxV6Vu
         TVx+DzTpuBgodgGmeV3UJmHGq99kNmRPpuhm3Gnr51h9jZanVLQnKQ9kX01Cfu4tzIka
         ZyjRtxYnw+d9g9iZVeyM2tjN+1dlK4+2zlE/uRpQPaMtAm04ITQaSWDFxeQlz3SyOL5/
         3OlGp2LNdNKH3bLKzYXkH8TKMKYHn42UArwWR27an8BBTwLiOWiMM08ZMOsiJa1s/zDE
         ejxFu8+jPLKCeasOHg1KpN1U87kxHmX0iKIVW2olUQIJZf9Ge+9TzTycVfwYQx1aI3d7
         ttIQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1770434483; x=1771039283; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=DDnvhXep83DlBOrKWoBYx9m4Ze6xzsCfCU7TNyv34F8=;
        b=U3tNzHqP7ymAIPqzOlaCocaOZoDwgEtHN5pOQiXaPjFKMZGNmK7PbsxwEdc+yFrew1
         hpLXIGw4Ld8GdQFBcoZdXCUTDkwkE9g0VqseXFfS48Z5pEV/wLEbH3Us8WB+02X6DA2l
         q4iAqlgw8lPPHARhYk9IrVzhTFo2GDaG+ocJvVl3tFiGbGsUeJt46wfNBnbeh4Fljn8P
         7dizx+Xnr7d+JCXirLA2qHbJqQ6pSAFN9oCjhGSgtO3llCmauMji/w/0yXqE1ozxjBjD
         DkJcUqkkEw/gRLIfSClO1EJ8O57G/3WdI3/sSPzk+p3IIPRgAS6aC42ggBZ7v9NCZikA
         0cmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770434483; x=1771039283;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DDnvhXep83DlBOrKWoBYx9m4Ze6xzsCfCU7TNyv34F8=;
        b=wrxveBs63LtoLPuEOaSc5xkX95ROQHc48P8VVZ7adp/yfb+aV4Vikq4Vz4bSZ3W0n8
         N6sY+AQPIWOkGyjxFafbbOAPcABc3Q5/Wx09OKNHRVBNvCch20yagj4Ssb8ip6B/G6VZ
         dbuZ3mybvCyhiYz2jhzSqGxhw8fX/FqfLVzMpLFHQxfOhC88jviHDx3pFPanR/tk/dQR
         5M31yJWINJYnQ53zBSu6A/i6iTW0vwgWRWnjjc2UeKrGdmQ0xpPGbv2xB0R64+q01MpE
         PAr2b2W/ygfdJ1GuWzPU4bw6OZebw6kaVJ/Dooljsiz/sEkxtCEmm5gb2z10VRoFF7PS
         7xuQ==
X-Forwarded-Encrypted: i=1; AJvYcCVRYfUT4f3V26aYsbb2yzoXheKBaapBTmEFPBjJeRZKVcB1jQ/enBnJnADoCgsAbtgcVBE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyjsTUd+kYpShOWZDV1uakuaxuRFvy66PljnAl7+tVYihqIVU+D
	yJqNaahAQHqtZ1tK4rwcdY8z/GVTSrM5a4nseSkb7fMK1JpiuYas51RvHYr6YCf5jrQ/CnY/l4X
	C8nCo6tKY5cijgZQjEghTz3Jq+DF3xfFyeN5cuukhJQ==
X-Gm-Gg: AZuq6aJpKxyeXpeSrRCut6eqR31Y3fGsx/r4aNs0xHdE6M72ATu5hbGJtOhHGrZX/k9
	PXPO0zkUPc0MNBz4icACrYyITLA+6HQy+X6xf6JXkyvTWtJ94RYyNvklUYJhQ1Fp7YCZcaXn9J0
	uv/cRxE977nEDdXxB5YOneCY+TUOyKfdt7UvLfdsuQm0WlabLylDGhYmNigqdEJjQOOUOJJRAbM
	CK2+FVZ6pjF6PitPMEOZCRgWsgXXRJN4ATBOKa0AovMvMhJkhe6TQtQx4tlQG9UBmHD/cGe9glM
	GRvBZONQR8LaQz9dXyvUvTllbPaz6HAar+tMJqrVK7a4y93IYXX+gWMY7A==
X-Received: by 2002:a05:6820:180e:b0:662:f347:75ea with SMTP id
 006d021491bc7-66d0a380580mr2281379eaf.28.1770434483383; Fri, 06 Feb 2026
 19:21:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Anup Patel <anup@brainfault.org>
Date: Sat, 7 Feb 2026 08:51:12 +0530
X-Gm-Features: AZwV_Qgt6jGZeh_4zfnnbt8_F11u5jr2-fPeHJpG-DyOXqW_XCH4wBnJqmdFURc
Message-ID: <CAAhSdy3z70oEePkgOBziVOKgFGae-0xMD+8xmsMV2PWM1v0ToA@mail.gmail.com>
Subject: [GIT PULL] KVM/riscv changes for 6.20
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>, 
	Andrew Jones <andrew.jones@oss.qualcomm.com>, Atish Patra <atish.patra@linux.dev>, 
	"open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" <kvm-riscv@lists.infradead.org>, KVM General <kvm@vger.kernel.org>, 
	linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64];
	R_DKIM_ALLOW(-0.20)[brainfault-org.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_ALL(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	DMARC_NA(0.00)[brainfault.org];
	TAGGED_FROM(0.00)[bounces-70534-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[brainfault-org.20230601.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[anup@brainfault.org,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[8];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,brainfault-org.20230601.gappssmtp.com:dkim,mail.gmail.com:mid]
X-Rspamd-Queue-Id: B21DE104C70
X-Rspamd-Action: no action

Hi Paolo,

We have the following KVM RISC-V changes for 6.20:
1) Fixes for issues discovered by KVM API fuzzing in
    AIA virtualization
2) Allow Zalasr, Zilsd and Zclsd extensions for Guest/VM
3) Add riscv vm satp modes in KVM selftests
4) Transparent huge support for G-stage
5) Adjust the number of available guest irq files based
    on MMIO register sizes

Please pull.

Also, please note that we have a conflict with kvm-x86
tree in tools/testing/selftests/kvm/lib/riscv/processor.c due
to patch "KVM: riscv: selftests: Add riscv vm satp modes"
discovered on linux-next. This can be resolved as follows:

diff --cc tools/testing/selftests/kvm/lib/riscv/processor.c
index 373cf4d1ed809,e6ec7c224fc3e..0000000000000
--- a/tools/testing/selftests/kvm/lib/riscv/processor.c
+++ b/tools/testing/selftests/kvm/lib/riscv/processor.c
@@@ -64,15 -68,15 +64,15 @@@ static uint64_t pte_index(struct kvm_v

  void virt_arch_pgd_alloc(struct kvm_vm *vm)
  {
 -      size_t nr_pages = page_align(vm, ptrs_per_pte(vm) * 8) / vm->page_size;
 +      size_t nr_pages = vm_page_align(vm, ptrs_per_pte(vm) * 8) /
vm->page_size;

-       if (vm->pgd_created)
+       if (vm->mmu.pgd_created)
                return;

-       vm->pgd = vm_phy_pages_alloc(vm, nr_pages,
-                                    KVM_GUEST_PAGE_TABLE_MIN_PADDR,
-                                    vm->memslots[MEM_REGION_PT]);
-       vm->pgd_created = true;
+       vm->mmu.pgd = vm_phy_pages_alloc(vm, nr_pages,
+                                        KVM_GUEST_PAGE_TABLE_MIN_PADDR,
+                                        vm->memslots[MEM_REGION_PT]);
+       vm->mmu.pgd_created = true;
  }

  void virt_arch_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr)
@@@ -220,14 -212,8 +221,14 @@@ void riscv_vcpu_mmu_setup(struct kvm_vc
                TEST_FAIL("Unknown guest mode, mode: 0x%x", vm->mode);
        }

 +      max_satp_mode = vcpu_get_reg(vcpu, RISCV_CONFIG_REG(satp_mode));
 +
 +      if ((satp_mode >> SATP_MODE_SHIFT) > max_satp_mode)
 +              TEST_FAIL("Unable to set satp mode 0x%lx, max mode 0x%lx\n",
 +                        satp_mode >> SATP_MODE_SHIFT, max_satp_mode);
 +
-       satp = (vm->pgd >> PGTBL_PAGE_SIZE_SHIFT) & SATP_PPN;
+       satp = (vm->mmu.pgd >> PGTBL_PAGE_SIZE_SHIFT) & SATP_PPN;
 -      satp |= SATP_MODE_48;
 +      satp |= satp_mode;

        vcpu_set_reg(vcpu, RISCV_GENERAL_CSR_REG(satp), satp);
  }
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c
b/tools/testing/selftests/kvm/lib/kvm_util.c
index 265e173b73709..1959bf556e88e 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -359,17 +359,17 @@ struct kvm_vm *____vm_create(struct vm_shape shape)
        case VM_MODE_P56V57_4K:
        case VM_MODE_P50V57_4K:
        case VM_MODE_P41V57_4K:
-               vm->pgtable_levels = 5;
+               vm->mmu.pgtable_levels = 5;
                break;
        case VM_MODE_P56V48_4K:
        case VM_MODE_P50V48_4K:
        case VM_MODE_P41V48_4K:
-               vm->pgtable_levels = 4;
+               vm->mmu.pgtable_levels = 4;
                break;
        case VM_MODE_P56V39_4K:
        case VM_MODE_P50V39_4K:
        case VM_MODE_P41V39_4K:
-               vm->pgtable_levels = 3;
+               vm->mmu.pgtable_levels = 3;
                break;
        default:
                TEST_FAIL("Unknown guest mode: 0x%x", vm->mode);

Regards,
Anup

The following changes since commit 63804fed149a6750ffd28610c5c1c98cce6bd377:

  Linux 6.19-rc7 (2026-01-25 14:11:24 -0800)

are available in the Git repository at:

  https://github.com/kvm-riscv/linux.git tags/kvm-riscv-6.20-1

for you to fetch changes up to 376e2f8cca2816c489a9196e65cc904d1a907fd2:

  irqchip/riscv-imsic: Adjust the number of available guest irq files
(2026-02-06 19:05:34 +0530)

----------------------------------------------------------------
KVM/riscv changes for 6.20

- Fixes for issues discovered by KVM API fuzzing in
  kvm_riscv_aia_imsic_has_attr(), kvm_riscv_aia_imsic_rw_attr(),
  and kvm_riscv_vcpu_aia_imsic_update()
- Allow Zalasr, Zilsd and Zclsd extensions for Guest/VM
- Add riscv vm satp modes in KVM selftests
- Transparent huge support for G-stage
- Adjust the number of available guest irq files based on
  MMIO register sizes in DeviceTree or ACPI

----------------------------------------------------------------
Jessica Liu (1):
      RISC-V: KVM: Transparent huge page support

Jiakai Xu (3):
      RISC-V: KVM: Fix null pointer dereference in
kvm_riscv_aia_imsic_has_attr()
      RISC-V: KVM: Fix null pointer dereference in kvm_riscv_aia_imsic_rw_attr()
      RISC-V: KVM: Skip IMSIC update if vCPU IMSIC state is not initialized

Pincheng Wang (2):
      riscv: KVM: allow Zilsd and Zclsd extensions for Guest/VM
      KVM: riscv: selftests: add Zilsd and Zclsd extension to get-reg-list test

Qiang Ma (1):
      RISC-V: KVM: Remove unnecessary 'ret' assignment

Wu Fei (1):
      KVM: riscv: selftests: Add riscv vm satp modes

Xu Lu (3):
      RISC-V: KVM: Allow Zalasr extensions for Guest/VM
      RISC-V: KVM: selftests: Add Zalasr extensions to get-reg-list test
      irqchip/riscv-imsic: Adjust the number of available guest irq files

 arch/riscv/include/uapi/asm/kvm.h                  |   3 +
 arch/riscv/kvm/aia.c                               |   2 +-
 arch/riscv/kvm/aia_imsic.c                         |  13 +-
 arch/riscv/kvm/mmu.c                               | 140 +++++++++++++++++++++
 arch/riscv/kvm/vcpu_onereg.c                       |   4 +
 arch/riscv/kvm/vcpu_pmu.c                          |   5 +-
 arch/riscv/mm/pgtable.c                            |   2 +
 drivers/irqchip/irq-riscv-imsic-state.c            |  12 +-
 include/linux/irqchip/riscv-imsic.h                |   3 +
 tools/testing/selftests/kvm/include/kvm_util.h     |  17 ++-
 .../selftests/kvm/include/riscv/processor.h        |   2 +
 tools/testing/selftests/kvm/lib/guest_modes.c      |  41 ++++--
 tools/testing/selftests/kvm/lib/kvm_util.c         |  33 +++++
 tools/testing/selftests/kvm/lib/riscv/processor.c  |  63 +++++++++-
 tools/testing/selftests/kvm/riscv/get-reg-list.c   |  12 ++
 15 files changed, 330 insertions(+), 22 deletions(-)

