Return-Path: <kvm+bounces-5187-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B4DFB81D057
	for <lists+kvm@lfdr.de>; Sat, 23 Dec 2023 00:16:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7B0E4284C1F
	for <lists+kvm@lfdr.de>; Fri, 22 Dec 2023 23:16:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5C1535EF4;
	Fri, 22 Dec 2023 23:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="O3AfGcec"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F0FF33CED
	for <kvm@vger.kernel.org>; Fri, 22 Dec 2023 23:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1703286949;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=qWoEtrdNPasYMgjNknGsXEce5LCOLCYkYpqGX/DZgy0=;
	b=O3AfGcecZUoc6T+BsM4Rbz6KFoqvhsRctKKySMl/XCdiprc9y7Jq+5GsQ+8wP+HBGAl+2A
	bWhf8lmPVVGf/AV7wjEWUZfAv3gLIrGmeiT+hVY+IQW/jECh2Igu+rWM+nE9X16yQTYKMS
	Eb2sP9oqxnEtAXfwuOSCI1EuD2k+GJY=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-616-MJJUghEpN5mPW4RiWMpvTg-1; Fri,
 22 Dec 2023 18:15:45 -0500
X-MC-Unique: MJJUghEpN5mPW4RiWMpvTg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 73CCE1C0514C;
	Fri, 22 Dec 2023 23:15:45 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 56FA6492BC6;
	Fri, 22 Dec 2023 23:15:45 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [GIT PULL] KVM fixes for Linux 6.7-rc7
Date: Fri, 22 Dec 2023 18:15:44 -0500
Message-Id: <20231222231544.3333693-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9

Linus,

The following changes since commit a39b6ac3781d46ba18193c9dbb2110f31e9bffe9:

  Linux 6.7-rc5 (2023-12-10 14:33:40 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to ef5b28372c565128bdce7a59bc78402a8ce68e1b:

  Merge tag 'kvm-riscv-fixes-6.7-1' of https://github.com/kvm-riscv/linux into kvm-master (2023-12-22 18:05:07 -0500)

----------------------------------------------------------------
RISC-V

- Fix a race condition in updating external interrupt for
  trap-n-emulated IMSIC swfile

- Fix print_reg defaults in get-reg-list selftest

ARM:

- Ensure a vCPU's redistributor is unregistered from the MMIO bus
  if vCPU creation fails

- Fix building KVM selftests for arm64 from the top-level Makefile

x86:

- Fix breakage for SEV-ES guests that use XSAVES.

Selftests:

- Fix bad use of strcat(), by not using strcat() at all

----------------------------------------------------------------
Andrew Jones (1):
      KVM: riscv: selftests: Fix get-reg-list print_reg defaults

Marc Zyngier (5):
      KVM: arm64: vgic: Simplify kvm_vgic_destroy()
      KVM: arm64: vgic: Add a non-locking primitive for kvm_vgic_vcpu_destroy()
      KVM: arm64: vgic: Force vcpu vgic teardown on vcpu destroy
      KVM: arm64: vgic: Ensure that slots_lock is held in vgic_register_all_redist_iodevs()
      KVM: Convert comment into an assertion in kvm_io_bus_register_dev()

Michael Roth (1):
      KVM: SEV: Do not intercept accesses to MSR_IA32_XSS for SEV-ES guests

Oliver Upton (1):
      KVM: selftests: Ensure sysreg-defs.h is generated at the expected path

Paolo Bonzini (3):
      KVM: selftests: Fix dynamic generation of configuration names
      Merge tag 'kvmarm-fixes-6.7-2' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into kvm-master
      Merge tag 'kvm-riscv-fixes-6.7-1' of https://github.com/kvm-riscv/linux into kvm-master

Yong-Xuan Wang (1):
      RISCV: KVM: update external interrupt atomically for IMSIC swfile

 arch/arm64/kvm/arm.c                             |  2 +-
 arch/arm64/kvm/vgic/vgic-init.c                  | 55 ++++++++++++++----------
 arch/arm64/kvm/vgic/vgic-mmio-v3.c               |  4 +-
 arch/arm64/kvm/vgic/vgic.h                       |  1 +
 arch/riscv/kvm/aia_imsic.c                       | 13 ++++++
 arch/x86/kvm/svm/sev.c                           | 19 ++++++++
 arch/x86/kvm/svm/svm.c                           |  1 +
 arch/x86/kvm/svm/svm.h                           |  2 +-
 tools/testing/selftests/kvm/Makefile             | 26 ++++++-----
 tools/testing/selftests/kvm/get-reg-list.c       |  9 ++--
 tools/testing/selftests/kvm/riscv/get-reg-list.c | 10 +++--
 virt/kvm/kvm_main.c                              |  3 +-
 12 files changed, 101 insertions(+), 44 deletions(-)


