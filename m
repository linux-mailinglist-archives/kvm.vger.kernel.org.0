Return-Path: <kvm+bounces-71112-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gA72Av3gkWkxngEAu9opvQ
	(envelope-from <kvm+bounces-71112-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sun, 15 Feb 2026 16:06:37 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5301C13EF37
	for <lists+kvm@lfdr.de>; Sun, 15 Feb 2026 16:06:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9BD0E304E83B
	for <lists+kvm@lfdr.de>; Sun, 15 Feb 2026 15:03:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F92F2F1FE7;
	Sun, 15 Feb 2026 15:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HYbqfWQp"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C36701C3BEB;
	Sun, 15 Feb 2026 15:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771167825; cv=none; b=CHaJOUlFQxDXhkmqDQOO9JSj2njioIRmxPFB0WKVeAmE9jmYrr2kUs1iyHw2Tk3BBau48HMhx+Rrm+DTH2gDqsoQVegc625QZI6IAL+hXH/GXNLdZiRcClP28w66Mp8nfwcyuyTApv0mJmakg+WGFgILLsifiXrUzKV1ed11iok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771167825; c=relaxed/simple;
	bh=otmfS5b/+P0gP2CWKmclfBPuwb7aLesR3kVXYTcytYk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SNgTi+85c8XktBmEm3vqtuqwilf5/7Jv3xoaaU+PXBGNfU8qnlUZGPJ92DC8uSvXseNoa2pZHaBBzbK4xN+4sSiuu0THYZyC2cKPi6fK+DBplm5ot30GyLLmKUiZ6q4eKNO2ei6RphhCJk8uHodaRpDdlhf4kbNJTtBi6LySanQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HYbqfWQp; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACF8BC4CEF7;
	Sun, 15 Feb 2026 15:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771167825;
	bh=otmfS5b/+P0gP2CWKmclfBPuwb7aLesR3kVXYTcytYk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HYbqfWQp6sVNudfQiHK5jqaf/31e3ZTuygtRulzO8r1wwo2rbd4+ygSB1H1X7VR1N
	 taD4vQ5kpUkGqNZFMqyXa151jewd0Fj/C+FYEXz+r4hU15NoPYhJZLLcVpQ9PKjfyX
	 f//RW3IkWOACYvFrEfNJq32auwdjb6aN6VwVXUwKZRXk8YY3m9q4Q08IsD+X1Yj3WM
	 4f4YKcYeIQvHA8xMhW7s3pfXDlqXNVbL5/q4UwJcZlu3r9ixXl13mi7m8KFfJftqwJ
	 cnCK1PO0gUJNbAXhTIpY5HUmSE9EvInflguILbsAWzmxlwbkYVsqJ/3yMZn6WnSjX4
	 sn7jOUyT9HhKw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Longfang Liu <liulongfang@huawei.com>,
	Alex Williamson <alex@shazbot.org>,
	Sasha Levin <sashal@kernel.org>,
	kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.18] hisi_acc_vfio_pci: resolve duplicate migration states
Date: Sun, 15 Feb 2026 10:03:25 -0500
Message-ID: <20260215150333.2150455-8-sashal@kernel.org>
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
	TAGGED_FROM(0.00)[bounces-71112-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: 5301C13EF37
X-Rspamd-Action: no action

From: Longfang Liu <liulongfang@huawei.com>

[ Upstream commit 8c6ac1730a977234dff74cc1753b4a953f59be7b ]

In special scenarios involving duplicate migrations, after the
first migration is completed, if the original VF device is used
again and then migrated to another destination, the state indicating
data migration completion for the VF device is not reset.
This results in the second migration to the destination being skipped
without performing data migration.
After the modification, it ensures that a complete data migration
is performed after the subsequent migration.

Signed-off-by: Longfang Liu <liulongfang@huawei.com>
Link: https://lore.kernel.org/r/20260122020205.2884497-4-liulongfang@huawei.com
Signed-off-by: Alex Williamson <alex@shazbot.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

### 3. Understanding the Bug Mechanism

Now the bug is crystal clear:

1. **`vf_qm_check_match()`** (line 401-453) performs VF device
   matching/validation during migration. Once matching succeeds, it sets
   `match_done = true` (line 451).

2. On subsequent calls, if `match_done` is already `true`, it **skips
   all validation** (line 411: early return 0).

3. **The bug**: When the device is opened for a second migration,
   `match_done` is never reset to 0. So `vf_qm_check_match()` returns
   immediately without performing the actual data migration matching,
   effectively **skipping the migration data transfer**.

4. **The fix**: Reset `match_done = 0` in
   `hisi_acc_vfio_pci_open_device()`, ensuring that each time the device
   is opened for a new migration, matching starts fresh.

### 4. Classification

This is a **clear functional bug fix**. It fixes incorrect behavior
where sequential VFIO device migrations fail silently after the first
one. The second migration appears to succeed but doesn't actually
transfer data.

### 5. Scope and Risk Assessment

- **One line change**: `hisi_acc_vdev->match_done = 0;`
- **Single file**: `drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c`
- **Minimal risk**: The change simply resets a state flag when a device
  is opened, which is the expected correct behavior
- **Located in the right place**: Inside the `open_device` function
  where other state is already being initialized (`mig_state`,
  `dev_opened`)
- **Under proper locking**: Inside the `open_mutex` critical section
- **Driver-specific**: Only affects HiSilicon accelerator VFIO devices,
  no risk to other subsystems

### 6. User Impact

- **Who is affected**: Users of HiSilicon accelerator hardware (common
  in Huawei/HiSilicon server platforms) performing VFIO-based VM live
  migration
- **Severity**: HIGH — silent data migration failure means VM state is
  silently corrupted or lost during the second migration. The VM may
  crash or behave incorrectly on the new host
- **Frequency**: Any time a VM is migrated more than once (a standard
  operation in cloud/datacenter environments for load balancing,
  maintenance, etc.)

### 7. Stable Kernel Criteria Check

- **Obviously correct**: Yes — resetting state on device open is clearly
  the right thing to do
- **Fixes a real bug**: Yes — second migrations silently fail
- **Small and contained**: Yes — single line addition in a single file
- **No new features**: Correct — this is purely a state reset bug fix
- **Tested**: Accepted by the VFIO maintainer (Alex Williamson)

### 8. Dependency Check

No dependencies on other commits. The `match_done` field and the
`open_device` function structure already exist in stable trees that have
the HiSilicon VFIO migration support.

### Conclusion

This is a textbook stable backport candidate: a one-line fix for a clear
functional bug (state not being reset between migrations) that causes
silent data migration failures in production environments. The fix is
minimal, obviously correct, properly placed under existing locking, and
carries essentially zero regression risk.

**YES**

 drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
index cf45f6370c369..39bff70f1e14b 100644
--- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
+++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
@@ -1547,6 +1547,7 @@ static int hisi_acc_vfio_pci_open_device(struct vfio_device *core_vdev)
 		}
 		hisi_acc_vdev->mig_state = VFIO_DEVICE_STATE_RUNNING;
 		hisi_acc_vdev->dev_opened = true;
+		hisi_acc_vdev->match_done = 0;
 		mutex_unlock(&hisi_acc_vdev->open_mutex);
 	}
 
-- 
2.51.0


