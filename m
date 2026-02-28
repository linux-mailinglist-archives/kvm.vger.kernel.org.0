Return-Path: <kvm+bounces-72258-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GE1MOuQ8ommq1AQAu9opvQ
	(envelope-from <kvm+bounces-72258-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 28 Feb 2026 01:55:00 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 867FC1BF84E
	for <lists+kvm@lfdr.de>; Sat, 28 Feb 2026 01:55:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id AE8FF30A9AB0
	for <lists+kvm@lfdr.de>; Sat, 28 Feb 2026 00:54:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D2B826E16C;
	Sat, 28 Feb 2026 00:54:28 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD79324468B;
	Sat, 28 Feb 2026 00:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772240067; cv=none; b=sD55wlJbUXYERV13Gt+Nacuzu1wu3zbdDz8VlwPH3rxnWpQb/78RX2RPqkAgWQWsc1FwtyMESKhU1s001ny4etTGbRVXHanpY63mAEbo/giQa6gzj3ymDtr77qp6s6r+UVhpT6uGIi0gElnDQ8I3zg6Hw/w+uUPpeJ0SKAnmSnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772240067; c=relaxed/simple;
	bh=QIzrJqeMZz5zzLBAczS6NuGVz5oGpBmBJ8IpygPKlpw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=N3JkG7EkmrjT0Nlq0hp27z8EeKXdH9IN/UnjgQ0mYnqWMO0QvIMP3+xxMB64Y+TFOS73r5n+ngU5JbFAViuuC8J4hOxMEkkcnDfy5JChblKrHUzGLbnVAdjI2urayqujx3Y5pDB2J+6Cbo81FNLMXxatnUPsv1m98pMQz39okN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from fric.. (unknown [210.73.43.101])
	by APP-03 (Coremail) with SMTP id rQCowABXO+KkPKJpPMJ2CQ--.12049S2;
	Sat, 28 Feb 2026 08:53:57 +0800 (CST)
From: Jiakai Xu <xujiakai2025@iscas.ac.cn>
To: linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-kselftest@vger.kernel.org,
	kvm@vger.kernel.org
Cc: Alexandre Ghiti <alex@ghiti.fr>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atish.patra@linux.dev>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Jiakai Xu <xujiakai2025@iscas.ac.cn>
Subject: [PATCH v9 0/3] RISC-V: KVM: Validate SBI STA shmem alignment
Date: Sat, 28 Feb 2026 00:53:52 +0000
Message-Id: <20260228005355.823048-1-xujiakai2025@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:rQCowABXO+KkPKJpPMJ2CQ--.12049S2
X-Coremail-Antispam: 1UD129KBjvJXoW7Gw4DZFW8ZFyDCr4UJFy5Jwb_yoW8Jr45pa
	9xCa4FqFy8JayxA3Z3Aw4ktryfWw48CrsFyw17J342yay8KFy8tr47KFWUAasxGF1kXF1Y
	va4xK3WruF98ZaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBI14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Cr
	1j6rxdM2vYz4IE04k24VAvwVAKI4IrM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVAC
	Y4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJV
	W8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI2
	0VAGYxC7M4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0En4kS14v26r1q6r43MxAIw28Icx
	kI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2Iq
	xVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42
	IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY
	6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aV
	CY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUbQVy7UUUUU==
X-CM-SenderInfo: 50xmxthndljiysv6x2xfdvhtffof0/1tbiBgoKCWmgYKJ+jgADs3
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.04 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	NEURAL_HAM(-0.00)[-0.957];
	TO_DN_SOME(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCPT_COUNT_TWELVE(0.00)[15];
	MIME_TRACE(0.00)[0:+];
	TAGGED_RCPT(0.00)[kvm];
	R_DKIM_NA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[xujiakai2025@iscas.ac.cn,kvm@vger.kernel.org];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72258-lists,kvm=lfdr.de];
	DMARC_NA(0.00)[iscas.ac.cn];
	FROM_HAS_DN(0.00)[]
X-Rspamd-Queue-Id: 867FC1BF84E
X-Rspamd-Action: no action

This series fixes a missing validation in the RISC-V KVM SBI
steal-time accounting (STA) register handling.

Patch 1 validates the configured SBI STA shared memory GPA at
KVM_SET_ONE_REG, enforcing the 64-byte alignment requirement
defined by the SBI specification or allowing INVALID_GPA to explicitly
disable steal-time accounting. This prevents invalid userspace state
from reaching runtime code paths and avoids WARN_ON() triggers during
KVM_RUN.

Patch 2 refactors existing UAPI tests from steal_time_init() into
a dedicated check_steal_time_uapi() function for better code organization,
and adds an empty stub for RISC-V.

Patch 3 fills in the RISC-V stub with tests that verify KVM correctly
enforces the STA alignment requirements.

Jiakai Xu (3):
  RISC-V: KVM: Validate SBI STA shmem alignment in 
    kvm_sbi_ext_sta_set_reg()
  KVM: selftests: Refactor UAPI tests into dedicated function
  RISC-V: KVM: selftests: Add RISC-V SBI STA shmem alignment tests

 arch/riscv/kvm/vcpu_sbi_sta.c                 | 16 ++-
 .../selftests/kvm/include/kvm_util_types.h    |  2 +
 tools/testing/selftests/kvm/steal_time.c      | 98 ++++++++++++++++---
 3 files changed, 95 insertions(+), 21 deletions(-)

-- 
2.34.1


