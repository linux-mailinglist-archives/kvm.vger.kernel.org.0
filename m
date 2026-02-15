Return-Path: <kvm+bounces-71109-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WLhqJXrgkWkxngEAu9opvQ
	(envelope-from <kvm+bounces-71109-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sun, 15 Feb 2026 16:04:26 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id EEF6E13EEDB
	for <lists+kvm@lfdr.de>; Sun, 15 Feb 2026 16:04:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id EDE84301F982
	for <lists+kvm@lfdr.de>; Sun, 15 Feb 2026 15:03:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D17728C2BF;
	Sun, 15 Feb 2026 15:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cx2Xoyfl"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E42522D4D3;
	Sun, 15 Feb 2026 15:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771167819; cv=none; b=QP9/7owSgp1X4YIrbUJ5rBn8jh9Jbz90/3Zj3MmnIbcOG2qdRXDVCZA26UIj51BfjCOBpmD/mOyrLsBcLVPt0xep/lieMokzZo2zQZcrwublJu0iwNZLtYGtGlYWF1Ha3LtSWnNL/yhf/0pa07M0cshNSdfVPjCecAuOQEgG1ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771167819; c=relaxed/simple;
	bh=IiC1peG8g8mQra+e1gdqk8iHIl+MuKKrcRSX/qkzaDI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Pw6GksX95QCqluCKvnjDJIg213dsAITx91K62pPKmkBjDtMTII7Z/h4SRmnnKIa+LPCWo1GYUT26AxpGaYhS+ULY1tjG2wVn0181rH7w+sdBeJoaZ3spM0rc40sm43dXCR35sDU4L0UVpu1KbBBLp8V6GX5d+k+v6mQyWuOeXyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cx2Xoyfl; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CD76C4AF0B;
	Sun, 15 Feb 2026 15:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771167819;
	bh=IiC1peG8g8mQra+e1gdqk8iHIl+MuKKrcRSX/qkzaDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cx2XoyflwCbfy/+wdaIHhyKvAhm8Ikd7XgVW3+6DvmUC6w5q6vsxoujo+n/I6mucb
	 zNyxQQWphfaHXPjaG5+yTYhQpZJi1D/uekAr/Ak76S7uG46Ek4MSPBiRqc79qrezbx
	 3MwR3P8vQw0jueLd/J1w3sPMy+Uvg0yp0OaNVi4Lez3QTz/WaZQ6JfLJB65030tBfC
	 i6bNMHki0I/3MLgCBzSJgOq8KMSx1Oaeg61SZLdCDMiaBCJ89PgVjvc0m4mpVEOsOo
	 1+uwis75YoQrH07BdQ4T+TbIeuV0R71Fz4tBJJxRXGah7LzFKFwGJrjjC4o+Uv8AeN
	 QQNKQh6SYvY6A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Longfang Liu <liulongfang@huawei.com>,
	Alex Williamson <alex@shazbot.org>,
	Sasha Levin <sashal@kernel.org>,
	kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.1] hisi_acc_vfio_pci: update status after RAS error
Date: Sun, 15 Feb 2026 10:03:20 -0500
Message-ID: <20260215150333.2150455-3-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260215150333.2150455-1-sashal@kernel.org>
References: <20260215150333.2150455-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_FROM(0.00)[bounces-71109-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[sashal@kernel.org,kvm@vger.kernel.org];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_THREE(0.00)[4];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+]
X-Rspamd-Queue-Id: EEF6E13EEDB
X-Rspamd-Action: no action

From: Longfang Liu <liulongfang@huawei.com>

[ Upstream commit 8be14dd48dfee0df91e511acceb4beeb2461a083 ]

After a RAS error occurs on the accelerator device, the accelerator
device will be reset. The live migration state will be abnormal
after reset, and the original state needs to be restored during
the reset process.
Therefore, reset processing needs to be performed in a live
migration scenario.

Signed-off-by: Longfang Liu <liulongfang@huawei.com>
Link: https://lore.kernel.org/r/20260122020205.2884497-3-liulongfang@huawei.com
Signed-off-by: Alex Williamson <alex@shazbot.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This confirms the critical finding.

### 3. Bug Classification: Logic Error Causing Failed Reset After RAS
Error

The old condition was:
```c
if (hisi_acc_vdev->core_device.vdev.migration_flags !=
VFIO_MIGRATION_STOP_COPY)
    return;
```

But `migration_flags` is set to `VFIO_MIGRATION_STOP_COPY |
VFIO_MIGRATION_PRE_COPY` (line 1590), which is `0x1 | 0x4 = 0x5`, not
`0x1`.

So the condition `migration_flags != VFIO_MIGRATION_STOP_COPY` evaluates
to `0x5 != 0x1` = **TRUE**, causing the function to **always return
early** and **never perform the reset**.

This means:
- After a RAS error, the device resets
- The migration state becomes inconsistent
- The `hisi_acc_vf_reset()` call that should restore state is **never
  reached**
- The device is left in a broken/inconsistent migration state

The new condition `!mig_ops` correctly checks whether migration is
supported (the pointer is non-NULL when migration ops are registered),
which aligns with how the VFIO core itself checks for migration
capability.

### 4. Scope and Risk Assessment

- **Change size**: 2 lines modified (one condition check)
- **Files touched**: 1 file
- **Risk**: Very low - the change is a simple condition check
  improvement
- **Scope**: Well-contained to the AER reset handler for HiSilicon
  accelerator VFIO devices

### 5. User Impact

- **Who is affected**: Users of HiSilicon accelerators (SEC, HPRE, ZIP
  engines) with live migration enabled, especially in
  cloud/virtualization environments
- **Severity**: After a RAS error during live migration, the device
  state would not be properly restored, potentially causing:
  - Failed live migrations
  - Corrupted device state
  - Guest VM malfunction after host-side RAS recovery

### 6. Stability Indicators

- Merged by Alex Williamson (VFIO subsystem maintainer)
- The fix is obviously correct - the old check was demonstrably wrong
  due to the exact equality comparison against a bitmask field that has
  multiple bits set

### 7. Dependency Check

This change is self-contained. It doesn't depend on other commits. The
`mig_ops` field has existed in `struct vfio_device` since the VFIO
migration rework (which is present in recent stable kernels).

### Conclusion

This is a clear bug fix. The old condition had a logic error that caused
the migration reset handler to be completely non-functional — it would
**always** return early because `migration_flags` was set to `STOP_COPY
| PRE_COPY` but was compared with exact equality to just `STOP_COPY`.
The fix is minimal (2 lines), obviously correct, and addresses a real
data integrity/reliability issue during RAS error recovery in live
migration scenarios. The change was accepted by the VFIO maintainer.

The only consideration is whether `mig_ops` exists in stable tree
versions, but since it's part of the VFIO migration rework that preceded
the addition of `PRE_COPY` support, it should be present in any kernel
that has this driver with `PRE_COPY` capability.

**YES**

 drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
index 8ed00f6183622..1c0b960de93c6 100644
--- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
+++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
@@ -1192,8 +1192,7 @@ static void hisi_acc_vf_pci_aer_reset_done(struct pci_dev *pdev)
 {
 	struct hisi_acc_vf_core_device *hisi_acc_vdev = hisi_acc_drvdata(pdev);
 
-	if (hisi_acc_vdev->core_device.vdev.migration_flags !=
-				VFIO_MIGRATION_STOP_COPY)
+	if (!hisi_acc_vdev->core_device.vdev.mig_ops)
 		return;
 
 	mutex_lock(&hisi_acc_vdev->state_mutex);
-- 
2.51.0


