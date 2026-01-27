Return-Path: <kvm+bounces-69211-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id v1ZnLLhneGkUpwEAu9opvQ
	(envelope-from <kvm+bounces-69211-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 08:22:32 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 43A4190B62
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 08:22:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 9771D3006121
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 07:22:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7D1732C942;
	Tue, 27 Jan 2026 07:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CLXstaOm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D64EE23B61E
	for <kvm@vger.kernel.org>; Tue, 27 Jan 2026 07:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769498549; cv=none; b=N2A0kZlmogyIhxQ9rWnfU6jEICQLwtpHAsjMd/4fT8HowcaxU454mnQ59w1eWxRqR8AbKHmONSMIQ1kaZufBXcyWcPJiienUoUX2PU6Mlw+igexF5+wFEInOm9wsAPHTKzT+y3g/ke7RFqiHpYXtAzRcAZhGQyWbi5DtI+sN/hA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769498549; c=relaxed/simple;
	bh=g+8Oigk3DYku8CFM6pj2mpmjdntIrEWCjERbGt/i3vQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=XotpOaMy9x4SOuIWX4CMcGjn9kaiJ5VwHoe46zcf3KH34cmOK3PFFQcMJVfsN8tE+CwRsE1M7UbiqpwX1QgDQ2uN5DFgUqhxPpeu5yWl5hh1uK65WyZeYXoG1sZ7mV+eD1+VsB9T0Y9xJaVRvY/MYeuxBWR2lnYZVJwZcOD4O7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CLXstaOm; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2a1022dda33so32015515ad.2
        for <kvm@vger.kernel.org>; Mon, 26 Jan 2026 23:22:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769498547; x=1770103347; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=WUonCIx+ZXd3QT2hTb6eW9uVCVHoiU5hLnPWwgxhDNA=;
        b=CLXstaOmBIBw7KrmY0Vy3men7/7/ifjzp4ia5yoaj05bd5zup7qtV6bq7WzLgtLT4m
         qEscNvXABV9JDpWyXIrvroFUybrk50RwiER+OoyUMt0HTHIn0Wh+TUg1cSzr6D4+YDG2
         l6nibmtw3DPq1bbstxChSLBWc3AG5xUsE49d9DzXod01Lp93UwCs/O6aAhQ/YqCA/OZk
         N7mdad3T9yFMSAgmRKYLfrSiX2pi0GdJd+xWrGSnWpRDSrSzBxjZqxZzfA1MxrKvYbJ7
         qQ2d4HcPAelounDUrlg8UneHof8H9qfxjpvE8oprQUm9t+isJUOWrHb55MPrRc2aPyh3
         zeuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769498547; x=1770103347;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WUonCIx+ZXd3QT2hTb6eW9uVCVHoiU5hLnPWwgxhDNA=;
        b=IWBdTO3fgu6WeFXZScVC/AKeTI9hXZE6oo/9I9wgWN+Vuukv+z9LsmTgtv13JLG5FN
         olZ52sAHr4D3/qzfahssDdNY1Hp3EHURc+f1ibWNtyG28qiqqI3Gi7KNFGfXlRS5//EV
         PxMKxNGyQvEGWhJYu4PY3bL0y8CawSaXwY95rDPTzGL5S3p/HGpO6HKpV/zsTAHq2zV2
         mrq7v2uuMWp5hhEXvs2Ut+CZQ3n6jYWeVg9BJJXDgnm6fkbcnF6RuEOHHgWc7NfnMOBL
         9HzISpFUM7/khFfWq9cHXYrw9eWtAMddvR15CiPTcpDMMImJIm0qHOdynC9LnQ/a49kh
         Iw8w==
X-Forwarded-Encrypted: i=1; AJvYcCUPDOaBK3EGRzlI9+ZDwXzENzkImXjzhQO+0rVQvWZDHRpEKrN48Tr9oTyk2GIe/3+iYkk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw1ELSdGc2xpWzniQkT2Ca3Zmck/FSbPeUDq88VZGJ1n7A1rNm0
	7ql+pK2Q7utst1AFGSf2J9PQmrs+784ADk+eeugaMGNUFbEs42OZJ7Iq
X-Gm-Gg: AZuq6aLAhLJRijapsckVdzjYm6WE9aRjUskrtGudqKviH7+PZv9qDiJVP+gSaEJCc7h
	O+wNd2e5CdW/tOSYJ+nof6Yuz6O96ylvh8httX9mjKq97Hut9SeXQtZAefAFNmoP76+mgX7/16O
	lNqRS+cH3+wq8GfELX2qbljirqRcURgp0xNER1rDQTK6DaTvspOj1K6S/eiK3Mv4Ik6gzo+/V5j
	Qm4XmSC6C/AuP0b6aMu1Ehgn9lVqjB1/ip+lIM+aPXK90G933wHkwmKm5OhnaUPiHRvt47sVfrU
	QwVOUtUrbEfJFXylV/7KVfbYmA4fwBGWD6YgpkfO5snCfoWEuULgKyXpRPgCTCmwq+efqgP97wH
	4Z+hsOub6gr9jO180Gf3dMTaQI60YvoJbFN+w5+weUepkcphp3OI4rI5czAUGYYk3VsuxGBtwS1
	Y0BtRFs86OTfu/7MefMmUeHrOuOr5zd3tF1pXSzNK9dM4YSn6b3i4=
X-Received: by 2002:a17:903:2344:b0:2a0:b461:c883 with SMTP id d9443c01a7336-2a870dd56e0mr9555815ad.45.1769498547192;
        Mon, 26 Jan 2026 23:22:27 -0800 (PST)
Received: from fric.. ([210.73.43.101])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a87842538bsm2505685ad.60.2026.01.26.23.22.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jan 2026 23:22:26 -0800 (PST)
From: Jiakai Xu <jiakaipeanut@gmail.com>
X-Google-Original-From: Jiakai Xu <xujiakai2025@iscas.ac.cn>
To: linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Anup Patel <anup@brainfault.org>,
	Atish Patra <atish.patra@linux.dev>,
	Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Jiakai Xu <xujiakai2025@iscas.ac.cn>,
	Jiakai Xu <jiakaiPeanut@gmail.com>
Subject: [PATCH] RISC-V: KVM: Fix null pointer dereference in kvm_riscv_aia_imsic_rw_attr()
Date: Tue, 27 Jan 2026 07:22:19 +0000
Message-Id: <20260127072219.3366607-1-xujiakai2025@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69211-lists,kvm=lfdr.de];
	FREEMAIL_CC(0.00)[brainfault.org,linux.dev,kernel.org,dabbelt.com,eecs.berkeley.edu,ghiti.fr,iscas.ac.cn,gmail.com];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCPT_COUNT_TWELVE(0.00)[12];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jiakaipeanut@gmail.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,iscas.ac.cn:mid,iscas.ac.cn:email]
X-Rspamd-Queue-Id: 43A4190B62
X-Rspamd-Action: no action

Add a null pointer check for imsic_state before dereferencing it in
kvm_riscv_aia_imsic_rw_attr(). While the function checks that the
vcpu exists, it doesn't verify that the vcpu's imsic_state has been
initialized, leading to a null pointer dereference when accessed.

The crash manifests as:
  Unable to handle kernel paging request at virtual address
  dfffffff00000006
  ...
  kvm_riscv_aia_imsic_rw_attr+0x2d8/0x854 arch/riscv/kvm/aia_imsic.c:958
  aia_set_attr+0x2ee/0x1726 arch/riscv/kvm/aia_device.c:354
  kvm_device_ioctl_attr virt/kvm/kvm_main.c:4744 [inline]
  kvm_device_ioctl+0x296/0x374 virt/kvm/kvm_main.c:4761
  vfs_ioctl fs/ioctl.c:51 [inline]
  ...

The fix adds a check to return -ENODEV if imsic_state is NULL and moves 
isel assignment after imsic_state NULL check.

Fixes: 5463091a51cfaa ("RISC-V: KVM: Expose IMSIC registers as attributes of AIA irqchip")
Signed-off-by: Jiakai Xu <xujiakai2025@iscas.ac.cn>
Signed-off-by: Jiakai Xu <jiakaiPeanut@gmail.com>
---
 arch/riscv/kvm/aia_imsic.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/kvm/aia_imsic.c b/arch/riscv/kvm/aia_imsic.c
index e597e86491c3b..bd7081e70036d 100644
--- a/arch/riscv/kvm/aia_imsic.c
+++ b/arch/riscv/kvm/aia_imsic.c
@@ -952,8 +952,10 @@ int kvm_riscv_aia_imsic_rw_attr(struct kvm *kvm, unsigned long type,
 	if (!vcpu)
 		return -ENODEV;
 
-	isel = KVM_DEV_RISCV_AIA_IMSIC_GET_ISEL(type);
 	imsic = vcpu->arch.aia_context.imsic_state;
+	if (!imsic)
+		return -ENODEV;
+	isel = KVM_DEV_RISCV_AIA_IMSIC_GET_ISEL(type);
 
 	read_lock_irqsave(&imsic->vsfile_lock, flags);
 
-- 
2.34.1


