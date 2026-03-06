Return-Path: <kvm+bounces-73092-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wMELLL/8qmmcZAEAu9opvQ
	(envelope-from <kvm+bounces-73092-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 17:11:43 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 06DEA2249A1
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 17:11:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 01EC3316F088
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 16:06:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C60B33EF0AA;
	Fri,  6 Mar 2026 16:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="XX24DolS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D2A63ED11E
	for <kvm@vger.kernel.org>; Fri,  6 Mar 2026 16:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772813190; cv=pass; b=N8zTSTostMYAeuSQYGYe8xjNCGKunOSUIa+CBkXhqIjRB+8Dl0ZWfyTS6e0C7URhUfzcQV7YGKVLZ9kxCdIeSl3pnKI4mfFRJENYdkaRQ+Tdo1l69Z22HpH/2iASnsjdxG9s9cPEKFIQOIXClCluCmVPoCTd+EMx7nOK7eNtRiU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772813190; c=relaxed/simple;
	bh=j+ZoKRywQNpXTu14NSiVa3AGDNyglWvE2KX82iiRofE=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=appkJluJTCoxdtXlSsVH9sbT1uJ7n4khgQ759xh3k7w/nENZMebLxiAkVz28Zt2PUh9TmOCmP31NOFaoRaTkM02qIdu3HpNAIPqdvG5TYa0UO7K0avWcijbNFj6DnSub/6g89n8n9KSnUzxJR8Bu3NoAFltBdTvRYeHf3iL7RNM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=XX24DolS; arc=pass smtp.client-ip=209.85.210.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-ot1-f54.google.com with SMTP id 46e09a7af769-7d598f60eeaso7063991a34.2
        for <kvm@vger.kernel.org>; Fri, 06 Mar 2026 08:06:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772813188; cv=none;
        d=google.com; s=arc-20240605;
        b=EYRnW4Bo3FgGCoKooaPnBjWHP1sXyYmEBvODN64LaobCfkoUHhux3clz6XO9ReYT5t
         EaV1mKYsTA3trrA8+NfFY30HwWaq9B8/lLUxsKKmCVMwWWhf1MewMNzkMI7DhNhCL9sd
         MJuRM2Jv6X+JWA9F+Nxu2FAmu8WFrUOtzISZvsXj5X9Wz6qSlVaqpjffgjXxVQXxsNyo
         7e0C48+pOfhMcRT8un6OmHHm2CJcs70+xAIJb9bz5idEhx4gNjDQCx7tIpJgpCYb4ysT
         6V8/aLGmu3gJkmbNfVE2Teyo8HGxZHteZwGpklekv5vOT9XVv4Yab6C6Uj0ekGlASMRk
         hqcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:dkim-signature;
        bh=bq/d/mKtXxIR1+HyewF2kjtB/W3rkjxPeNkROtpkMok=;
        fh=Xp4vnfOoVJlJm0+ltFsc//528Fw6WicuhmhnERJoh5c=;
        b=Ql2Y4viAkedQdIMYFF0I5KjzdMwk9xuzfBVQMLMfJL33hGWU3hoeKwi5jDSCjppsKu
         9W64lXT2sPrc2l0R9mAbFchiF0YMsmrpH2RZYaYfvVGPChjj63SoBWA+9SbNyNY5cmlS
         ATfUjqcg8duxP9AZMSzpsXeeal9E4Txl2ZUexmMH70XhKg7Nzb1SwnDP2cWN7mx26JOZ
         EJsKJcLPBsExYjw0WQUtVvdXhC8Ck6IhzefyCSQOa74zcdWBm8V5UpUyIMHTld3Nzct/
         V+G9tHV0sizwuVj9sagkc9zjRVlFgpbIxit9v4jwtgZgOvE4aYF5sE+N+jBtaMDSxHPt
         h9fw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1772813188; x=1773417988; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=bq/d/mKtXxIR1+HyewF2kjtB/W3rkjxPeNkROtpkMok=;
        b=XX24DolSt3ZWaZIxF430fyGGbWinV/e8aE/dQFD/5AujAvYC2nMR6EB0O6AM/tiCcl
         JLZHi2DfK/pN81d74/9qwfAASzd8NR0KuLdtWkaiGc+NCpHdoDbmgOZtssJO0KsGW5pH
         rhly2iOqwUBbJqWQN/PrCtZ9zrXxFXItA2YD2zMmuQA26Fbrezjh2/1jbnqcSvKBC4IW
         tPpEbFv4QpxbZt46SRzoRVG1dAV3EhNBpnyObO2uCpGT//uWabnYVjxNzfhLImxf5ewS
         GMa3k688veDziz4Hpc/N6saspVXnGNYnqp4/D1OGvrvPS4JE+yKl28bGEXy6aWDrYQgF
         Z3OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772813188; x=1773417988;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bq/d/mKtXxIR1+HyewF2kjtB/W3rkjxPeNkROtpkMok=;
        b=e9K47WNQ56QhVwPMrQDwXuCxFd7bplMJQcFsGRGKZSM0rTQiENHrBQuRKIpcX9ZyUV
         H33h6yDVNVyBKx3MErlEitDoXnHi7RxZJSErenL8mLQpp2eBAc0dk3QREU720Sb0aFOC
         JKvjojLZ+Fgq6vtBoFINgOwCA84o7iaQEAffq/ow7sYYrtcob1cllBPTj4kJXhdELd1H
         XD4TQm9C6eaKkaD+y2XFOm3/D5LdyuSuOPY4ZtToxx9hnLOUqVeZBudQO6TvaCtSUew0
         CiTj+6zXvRiUuSTyAYwkqD4DDiLTQs0TqyVk93SGVAm+mOOBspLmadkDblQlPAr8Y6Ll
         MvhQ==
X-Forwarded-Encrypted: i=1; AJvYcCVHEUuPghAjJiXFn2X1bB3mr36WlndDr668+3RPbhgZNT9Or6EWrvYciLdcChS4qAMhVsE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyGeFq+Zjd0EDNj1/biTdyAMsTDlw1M7cJGEZXergnynxFqAvXi
	FuZgroiqqsNtLyNOEsk2B2zfyREiLjHXHBet24UnkNuMsMOD0caaEm7KNXKxIS2Ns9HMFgrjoBm
	fdoAjYYyNU2dPJ0cIaNHp5ce5GcPbLS5vEf4tMiaeig==
X-Gm-Gg: ATEYQzzTXU4pFc6UMEUxp8X2RYdC9eUF+pnnbCZ1xINey3oyGhDEd/p/ViocX4uI8FT
	IrRlDZI5coygTvHhKqorXSs4GZekdZ5ShqjlpJN7FO9KpZt/PVf3AwM0BwngbVqMdOyLF5Wa7+q
	QhIig9n+XZL2/zzNXBeXVa3qCGS9OJ/ZPnN3BgaxF/8z7XTCcgUg3dU40PQRRcIlngMx16Mi7uo
	sVD8hG6Ktrod1h1pksFm9CrfkAwzTX+EtMvXWavY47BucBKo0o2u7BRn7BNyHugCskqwP3CfnKM
	x33XItKAKabuexoPhXLkrq9Osuw8/0G7L8pkpNa7TLCqE0gfrzwXyQ2bYnpSpYCWGJGiQX9COA9
	W9REW1/UW+zJbcwVFiyY8G2RgChg=
X-Received: by 2002:a05:6820:1843:b0:679:f05e:f13c with SMTP id
 006d021491bc7-67b9bd45a8cmr1550538eaf.60.1772813187874; Fri, 06 Mar 2026
 08:06:27 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Anup Patel <anup@brainfault.org>
Date: Fri, 6 Mar 2026 21:36:16 +0530
X-Gm-Features: AaiRm53452UyUTlO6hp4cwRrPvadg006HyyZw7yrDpFC4S4tJGwcfOAoyhE4Kyg
Message-ID: <CAAhSdy2EuZu_KeZ1RaUEg3shtfSnSVo7eJWOA6-g4j9Hn2oY5A@mail.gmail.com>
Subject: [GIT PULL] KVM/riscv fixes for 7.0 take #1
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>, 
	Andrew Jones <andrew.jones@oss.qualcomm.com>, Atish Patra <atish.patra@linux.dev>, 
	"open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" <kvm-riscv@lists.infradead.org>, KVM General <kvm@vger.kernel.org>, 
	linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 06DEA2249A1
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[brainfault-org.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_ALL(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	DMARC_NA(0.00)[brainfault.org];
	TAGGED_FROM(0.00)[bounces-73092-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[brainfault-org.20230601.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[anup@brainfault.org,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.952];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[8];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,mail.gmail.com:mid,brainfault-org.20230601.gappssmtp.com:dkim]
X-Rspamd-Action: no action

Hi Paolo,

We have quite a few fixes this time for the 7.0 kernel.
These fixes address potential use-after-free issues, null
pointer dereferences, speculative out-of-bound accesses,
and others.

Please pull.

Regards,
Anup

The following changes since commit 11439c4635edd669ae435eec308f4ab8a0804808=
:

  Linux 7.0-rc2 (2026-03-01 15:39:31 -0800)

are available in the Git repository at:

  https://github.com/kvm-riscv/linux.git tags/kvm-riscv-fixes-7.0-1

for you to fetch changes up to c61ec3e8cc5d46fa269434a9ec16ca36d362e0dd:

  RISC-V: KVM: Check host Ssaia extension when creating AIA irqchip
(2026-03-06 11:20:30 +0530)

----------------------------------------------------------------
KVM/riscv fixes for 7.0, take #1

- Prevent speculative out-of-bounds access using array_index_nospec()
  in APLIC interrupt handling, ONE_REG regiser access, AIA CSR access,
  float register access, and PMU counter access
- Fix potential use-after-free issues in kvm_riscv_gstage_get_leaf(),
  kvm_riscv_aia_aplic_has_attr(), and kvm_riscv_aia_imsic_has_attr()
- Fix potential null pointer dereference in kvm_riscv_vcpu_aia_rmw_topei()
- Fix off-by-one array access in SBI PMU
- Skip THP support check during dirty logging
- Fix error code returned for Smstateen and Ssaia ONE_REG interface
- Check host Ssaia extension when creating AIA irqchip

----------------------------------------------------------------
Anup Patel (3):
      RISC-V: KVM: Fix error code returned for Smstateen ONE_REG
      RISC-V: KVM: Fix error code returned for Ssaia ONE_REG
      RISC-V: KVM: Check host Ssaia extension when creating AIA irqchip

Jiakai Xu (4):
      RISC-V: KVM: Fix use-after-free in kvm_riscv_gstage_get_leaf()
      RISC-V: KVM: Fix null pointer dereference in
kvm_riscv_vcpu_aia_rmw_topei()
      RISC-V: KVM: Fix use-after-free in kvm_riscv_aia_aplic_has_attr()
      RISC-V: KVM: Fix potential UAF in kvm_riscv_aia_imsic_has_attr()

Lukas Gerlach (5):
      KVM: riscv: Fix Spectre-v1 in APLIC interrupt handling
      KVM: riscv: Fix Spectre-v1 in ONE_REG register access
      KVM: riscv: Fix Spectre-v1 in AIA CSR access
      KVM: riscv: Fix Spectre-v1 in floating-point register access
      KVM: riscv: Fix Spectre-v1 in PMU counter access

Radim Kr=C4=8Dm=C3=A1=C5=99 (1):
      RISC-V: KVM: fix off-by-one array access in SBI PMU

Wang Yechao (1):
      RISC-V: KVM: Skip THP support check during dirty logging

 arch/riscv/kvm/aia.c         | 15 ++++++++++--
 arch/riscv/kvm/aia_aplic.c   | 23 ++++++++++---------
 arch/riscv/kvm/aia_device.c  | 18 +++++++++++----
 arch/riscv/kvm/aia_imsic.c   |  4 ++++
 arch/riscv/kvm/mmu.c         |  6 ++++-
 arch/riscv/kvm/vcpu_fp.c     | 17 ++++++++++----
 arch/riscv/kvm/vcpu_onereg.c | 54 +++++++++++++++++++++++++++++-----------=
----
 arch/riscv/kvm/vcpu_pmu.c    | 16 +++++++++----
 8 files changed, 109 insertions(+), 44 deletions(-)

