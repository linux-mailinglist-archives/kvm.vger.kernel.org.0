Return-Path: <kvm+bounces-72321-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0EJeBwVKpGkIcwUAu9opvQ
	(envelope-from <kvm+bounces-72321-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sun, 01 Mar 2026 15:15:33 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 69F2B1D0282
	for <lists+kvm@lfdr.de>; Sun, 01 Mar 2026 15:15:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 93468301A921
	for <lists+kvm@lfdr.de>; Sun,  1 Mar 2026 14:15:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B0EA32ED4C;
	Sun,  1 Mar 2026 14:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HewKKp6O";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="iVx7p01d"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2630F2620DE
	for <kvm@vger.kernel.org>; Sun,  1 Mar 2026 14:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772374514; cv=none; b=ZDuhSDhv5BfbdBKz3zpS1D0ZwaC2DcJxrgoSR3TETUQWUa/DQc4GXTFhWkiU34Ebxxm8D9ix1ames9aXIOGpSLITwZVlKhCP9APucyzizwGFAXJkrEZ29786ZKAWGRfJkBmY9TBBn+Ia3ddMDpDHYIysmMgR2l/cgzOCRo/ntuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772374514; c=relaxed/simple;
	bh=2erLxJys/8ST4HuXXbt2cei6PyVFQ4+4D5yIG0uxbA8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Y76NeulXONyNakXl434qUWETOVNUJUPJkt+vDmGL3GiY+6+peTdZMw/Ng8PfP7yK9p3+sTvBh4R0N/nCCDQdknGkZJI7EO9wqJCR0Q3i+FlYsaG+OyIVKtnXZWuk+fBoXqAMEo6OJn5UJANDwY+tkWAbhxsjhi3NYcB+yHPRLLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HewKKp6O; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=iVx7p01d; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772374512;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Cd5Yt4p2Ohi6NWhhqA2K2XaIYihSOy3vy6BtTMwuPA4=;
	b=HewKKp6OLWaM0CHnV6a2iFIi0nio+NZq5Ue6GexTc6gds4RjoewH/EoUJRd8UcWFnJtLoU
	9Ae76heiH8x1UjUWLZF79kzBxY5/GTYCAtMCPn5Fwcxb4TkioTsmbEeHGbHolE/1JNfLFp
	K72Pfz5D6xziUL3l1qegWcKNXDUfzC8=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-502-ZaeYm1JZN3Cjv2WGU8Aqww-1; Sun, 01 Mar 2026 09:15:10 -0500
X-MC-Unique: ZaeYm1JZN3Cjv2WGU8Aqww-1
X-Mimecast-MFC-AGG-ID: ZaeYm1JZN3Cjv2WGU8Aqww_1772374510
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4836e35292cso31130485e9.1
        for <kvm@vger.kernel.org>; Sun, 01 Mar 2026 06:15:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1772374509; x=1772979309; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Cd5Yt4p2Ohi6NWhhqA2K2XaIYihSOy3vy6BtTMwuPA4=;
        b=iVx7p01daS/fAn9P800Pl+Oylhm3OpxOdNtD43H5IZmqmizQlToDWu2ZW599qwlqm+
         dNFpWCuYHFxI9LE8z2Ib81InAFCz2+0Yl4oo8OcRPIvoTrZlbuk3hQpFeQ0fwC3+rUlG
         N2USCOKzMNHB+VLE2acaI9Uw2RO9BqFVfkqHfjaD/v3fj8H/7akBPpPvgtWQ1g/eJqRz
         dZXNM+URwxXfh51+7Okn+ppt0TZH34X24yjieHhVcPA6BRUNYRwqMjolqjHXNT6oSfaa
         pqcj3qW66+Zaw1mRyuw0oIiLm8RKy61EIUBLUJ2MlpELEZEgpifhHhJAzU85SBpS4LX/
         hkbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772374509; x=1772979309;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Cd5Yt4p2Ohi6NWhhqA2K2XaIYihSOy3vy6BtTMwuPA4=;
        b=V+AGSUV1g8HidQ+t4d66Z3K97XPz22d75oD0hYFfa8QaeB0QiA+RSunvBNMa2TwvRM
         TkHuHkBkwx+v0EihZFV38134R3OvN86RF4R9DrJO+BWYrzyMujdSKbzI8slzU7+0RgZQ
         WBCE67h834yoWJ0v/sw651v5OqudsJl6M6PuIz6ULdxeahSmqUJDXrs9gH5GIzIfjwq3
         LA+KZAPXEw7ouqd0Z8sRq5a94WJZyvRoYAOIUfO2rfNyTZ0/Q7xDPY7cfUyiiDBsklQf
         wNCzIBc/Dr7STLFbfx7HXOrMJpwqN/Z3oA9V1qZUdh4fzRNit58BfFLkylf26ZanKyIW
         ck4A==
X-Forwarded-Encrypted: i=1; AJvYcCUTveqF7PSR3MHcOMmo/YJNjtEmGdVe2FXj8EbNkc+wauYjj6CEdaawKrvEQvvveT7j0F8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyxD31ieISmc7QaG/ou8jjdjfvVnzcCombhJE5dxHE/TDTEZduB
	tFEVARGzivYh7/4LHkdmAb5g74GIzi56YYr+dLAsjckjejVyjCs0BslkUoJ9HwkMOx7bg+HHFX0
	yaCqb/u99nzHljPqKmE4qNsbFrvau7L9GX/v/vxPoXHscqsyh17StnA==
X-Gm-Gg: ATEYQzz328ZwUmJZ427DyQT7dRBZsjblRtOJQ38E6vwJkx4Om6CYHv915JdYzCfGckx
	0CCOv+t01NPLIxgv1bdmzX1Cp95Y8dKoMOct3QD1c5aXQ3Xe8i/enHb3XYpHZLPz+FpATXd7nxI
	8btfcVP4HVATsQmyI7VYbkXbRCsdSSXk6Kb/0zRJpxJF4rztC3b1+LGCuAFVNeXae8H9WchG+5+
	QPzlrGZPXLX6xMrqVGiQVSct483wnzrYEyPVwRkg7kQfe/kY9jWqaQp5Nv+uW5JEAgrY+kVsoDS
	DBBO71c7mJ/qHsTEtgsh6rJUJxWbJTbwbNYETx3N/P1i1/a0ZrCJuBM2tcGQvfZgB9dOQDXIIJz
	pBPSljL0hHkDF3DW5BzEyw8pCgX6S79EHK7+WCoOORe9V+7M1aS8ryTspGora771kU74qrorzHd
	GGC2M/XgBqA7lOpOilgXaoUAeX2gw=
X-Received: by 2002:a05:600c:6994:b0:477:c478:46d7 with SMTP id 5b1f17b1804b1-483c9c0b88amr156401625e9.22.1772374509503;
        Sun, 01 Mar 2026 06:15:09 -0800 (PST)
X-Received: by 2002:a05:600c:6994:b0:477:c478:46d7 with SMTP id 5b1f17b1804b1-483c9c0b88amr156401285e9.22.1772374509063;
        Sun, 01 Mar 2026 06:15:09 -0800 (PST)
Received: from [192.168.10.48] ([151.95.144.138])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483c3b3471asm241535715e9.3.2026.03.01.06.15.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Mar 2026 06:15:08 -0800 (PST)
From: Paolo Bonzini <pbonzini@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [GIT PULL] KVM changes for Linux 7.0-rc2
Date: Sun,  1 Mar 2026 15:15:07 +0100
Message-ID: <20260301141507.444155-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72321-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pbonzini@redhat.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_FIVE(0.00)[6];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 69F2B1D0282
X-Rspamd-Action: no action

Linus,

The following changes since commit 6de23f81a5e08be8fbf5e8d7e9febc72a5b5f27f:

  Linux 7.0-rc1 (2026-02-22 13:18:59 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 55365ab85a93edec22395547cdc7cbe73a98231b:

  Merge tag 'kvmarm-fixes-7.0-1' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD (2026-02-28 15:33:34 +0100)

----------------------------------------------------------------
Arm:

* Make sure we don't leak any S1POE state from guest to guest when
  the feature is supported on the HW, but not enabled on the host

* Propagate the ID registers from the host into non-protected VMs
  managed by pKVM, ensuring that the guest sees the intended feature set

* Drop double kern_hyp_va() from unpin_host_sve_state(), which could
  bite us if we were to change kern_hyp_va() to not being idempotent

* Don't leak stage-2 mappings in protected mode

* Correctly align the faulting address when dealing with single page
  stage-2 mappings for PAGE_SIZE > 4kB

* Fix detection of virtualisation-capable GICv5 IRS, due to the
  maintainer being obviously fat fingered... [his words, not mine]

* Remove duplication of code retrieving the ASID for the purpose of
  S1 PT handling

* Fix slightly abusive const-ification in vgic_set_kvm_info()

Generic:

* Remove internal Kconfigs that are now set on all architectures.

* Remove per-architecture code to enable KVM_CAP_SYNC_MMU, all
  architectures finally enable it in Linux 7.0.

----------------------------------------------------------------
Fuad Tabba (5):
      KVM: arm64: Hide S1POE from guests when not supported by the host
      KVM: arm64: Optimise away S1POE handling when not supported by host
      KVM: arm64: Fix ID register initialization for non-protected pKVM guests
      KVM: arm64: Remove redundant kern_hyp_va() in unpin_host_sve_state()
      KVM: arm64: Revert accidental drop of kvm_uninit_stage2_mmu() for non-NV VMs

Kees Cook (1):
      KVM: arm64: vgic: Handle const qualifier from gic_kvm_info allocation type

Marc Zyngier (2):
      KVM: arm64: Fix protected mode handling of pages larger than 4kB
      KVM: arm64: Deduplicate ASID retrieval code

Paolo Bonzini (3):
      KVM: remove CONFIG_KVM_GENERIC_MMU_NOTIFIER
      KVM: always define KVM_CAP_SYNC_MMU
      Merge tag 'kvmarm-fixes-7.0-1' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD

Sascha Bischoff (1):
      irqchip/gic-v5: Fix inversion of IRS_IDR0.virt flag

 Documentation/virt/kvm/api.rst      | 10 +++---
 arch/arm64/include/asm/kvm_host.h   |  3 +-
 arch/arm64/include/asm/kvm_nested.h |  2 ++
 arch/arm64/kvm/Kconfig              |  1 -
 arch/arm64/kvm/arm.c                |  1 -
 arch/arm64/kvm/at.c                 | 27 ++--------------
 arch/arm64/kvm/hyp/nvhe/pkvm.c      | 37 ++++++++++++++++++++--
 arch/arm64/kvm/mmu.c                | 12 +++----
 arch/arm64/kvm/nested.c             | 63 ++++++++++++++++++-------------------
 arch/arm64/kvm/sys_regs.c           |  3 ++
 arch/loongarch/kvm/Kconfig          |  1 -
 arch/loongarch/kvm/vm.c             |  1 -
 arch/mips/kvm/Kconfig               |  1 -
 arch/mips/kvm/mips.c                |  1 -
 arch/powerpc/kvm/Kconfig            |  4 ---
 arch/powerpc/kvm/powerpc.c          |  6 ----
 arch/riscv/kvm/Kconfig              |  1 -
 arch/riscv/kvm/vm.c                 |  1 -
 arch/s390/kvm/Kconfig               |  2 --
 arch/s390/kvm/kvm-s390.c            |  1 -
 arch/x86/kvm/Kconfig                |  1 -
 arch/x86/kvm/x86.c                  |  1 -
 drivers/irqchip/irq-gic-v5-irs.c    |  2 +-
 include/linux/kvm_host.h            |  7 +----
 virt/kvm/Kconfig                    |  9 +-----
 virt/kvm/kvm_main.c                 | 17 +---------
 26 files changed, 87 insertions(+), 128 deletions(-)


