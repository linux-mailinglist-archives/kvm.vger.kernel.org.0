Return-Path: <kvm+bounces-57157-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 117B4B508A9
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 00:02:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6CC5856762B
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 22:02:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35A8C1531C8;
	Tue,  9 Sep 2025 22:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="URq2Fxdk"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 112672773D8;
	Tue,  9 Sep 2025 22:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757455218; cv=none; b=fcAfqmzywMD4X9q8cpogsVU5vWbIkOr2GlJiaFxjNtAzOuRe5biZ5h5fCynBVhqCUcKWgMD3qf8UeI9LOIKryoGP2N1e0Q82G2HRxQe0Z5BKaT5KRyJriV7o0YUJEWdUmsque98J7LubMlPZn2a4Him/abbUnoH0C0R6psHqNBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757455218; c=relaxed/simple;
	bh=J0wPZupB+Xsv5pSL6FaS6vYM6IU4qCEKiECUNs+CFV8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=UmGmIVoWEepLO5+ufkP+4gr3G9SyNlExbh8Lr1dSWqziuxGCnfxJ62o018ty+P2yUvEFxbmsPzji4I55zzeKLskbnNw2vpVmXuECK287i+rGi8XGD2P3YjA2kRuumE96rlaBAYKIjpTI2eSJ3r7IzVcX7fkKeV6wXpwvKsPVYoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=URq2Fxdk; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757455216; x=1788991216;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=J0wPZupB+Xsv5pSL6FaS6vYM6IU4qCEKiECUNs+CFV8=;
  b=URq2FxdkmtCq+yCguz2LNwoGaIeDzNW4KutB+2/bpYgJlJhTIDv91C5i
   Okdw/HnY7c1AA6QtOlQFBuQoJ50s2DZs0CeZ8PNouIlYz/RqKOIshgUw5
   bFYdMU5Ek0zVms0iPVMbn/YTzVPuedFJl35rNh3QjuT5GMIsqfPgcWEwA
   ZydXe0bfrNxzlwWkMuNNBtPF7mwdFYdmXLaKkiYcP75wtuNbimtRLs+34
   QSIz/2RFjtVRNaFwYXNX08UVM+Y5YrYixGUFkoyFI2Rcauo+cNub1o3IO
   IztcViUG2xvvrXfBjtqaAJjdnbuGJ0xGeW0oesopQ76zBtOfgsTtaVwQD
   g==;
X-CSE-ConnectionGUID: rbSETMh3RkyskaPdPpAaCg==
X-CSE-MsgGUID: je0gPVssQ+Ku9Ey8uAy3Tw==
X-IronPort-AV: E=McAfee;i="6800,10657,11548"; a="63584676"
X-IronPort-AV: E=Sophos;i="6.18,252,1751266800"; 
   d="scan'208";a="63584676"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 15:00:09 -0700
X-CSE-ConnectionGUID: HNmsrvI3SqKaxlf3KYSRpQ==
X-CSE-MsgGUID: 79gh8YjbTLSpo0j/yzml+w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,252,1751266800"; 
   d="scan'208";a="172780974"
Received: from orcnseosdtjek.jf.intel.com (HELO [10.166.28.70]) ([10.166.28.70])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 15:00:08 -0700
From: Jacob Keller <jacob.e.keller@intel.com>
Date: Tue, 09 Sep 2025 14:57:56 -0700
Subject: [PATCH RFC net-next 7/7] ice-vfio-pci: implement PCI .reset_done
 handling
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250909-e810-live-migration-jk-migration-tlv-v1-7-4d1dc641e31f@intel.com>
References: <20250909-e810-live-migration-jk-migration-tlv-v1-0-4d1dc641e31f@intel.com>
In-Reply-To: <20250909-e810-live-migration-jk-migration-tlv-v1-0-4d1dc641e31f@intel.com>
To: Tony Nguyen <anthony.l.nguyen@intel.com>, 
 Przemek Kitszel <przemyslaw.kitszel@intel.com>, 
 Andrew Lunn <andrew+netdev@lunn.ch>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Kees Cook <kees@kernel.org>, "Gustavo A. R. Silva" <gustavoars@kernel.org>, 
 Alex Williamson <alex.williamson@redhat.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Yishai Hadas <yishaih@nvidia.com>, 
 Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>, 
 Kevin Tian <kevin.tian@intel.com>, Jakub Kicinski <kuba@kernel.org>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, 
 kvm@vger.kernel.org, linux-hardening@vger.kernel.org, 
 Jacob Keller <jacob.e.keller@intel.com>, 
 Aleksandr Loktionov <aleksandr.loktionov@intel.com>
X-Mailer: b4 0.15-dev-c61db
X-Developer-Signature: v=1; a=openpgp-sha256; l=6535;
 i=jacob.e.keller@intel.com; h=from:subject:message-id;
 bh=J0wPZupB+Xsv5pSL6FaS6vYM6IU4qCEKiECUNs+CFV8=;
 b=owGbwMvMwCWWNS3WLp9f4wXjabUkhowDi9Oc9l7cG7r7jd8j8xgrg+3CfcsaPnhv3DqJc7r7z
 oL80LXXOkpZGMS4GGTFFFkUHEJWXjeeEKb1xlkOZg4rE8gQBi5OAZjIvYeMDJcYun+8sgx+58h2
 21lMLuaosZZXb36F35mIWWcXb4/iu8nIsMPz/pObfbdq4/WrO6/su6UT6hkY1P9YTX7O44a0/zd
 S2AA=
X-Developer-Key: i=jacob.e.keller@intel.com; a=openpgp;
 fpr=204054A9D73390562AEC431E6A965D3E6F0F28E8

Add an implementation callback for the PCI .reset_done handler to enable
cleanup after a PCI reset. This function has one rather nasty locking
complexity due to the way the various locks interact.

The VFIO layer holds the mm_lock across a reset, and a naive implementation
which just takes the state mutex would trigger a simple ABBA deadlock
between the state_mutex and the mm_lock.

To avoid this, allow deferring handling cleanup after a PCI reset until the
current thread holding the state_mutex exits.

This is done through adding a reset_lock spinlock and a needs_reset
boolean. All flows which previously simply released the state_mutex now
call a specialized ice_vfio_pci_state_mutex_unlock() handler.

This handler acquires the reset_lock, and checks if a reset was deferred.
If so, the reset_lock is released, cleanup is handled, then the reset_lock
is reacquired  and the thread loops to check for another deferred reset.
Eventually the needs_reset is false, and the function exits by releasing
the state_mutex and then the deferred reset_lock.

The actual reset_done implementation acquires the reset lock, sets
needs_reset to true, then uses try_lock to acquire the state mutex. If
it fails to acquire the state mutex, this means another thread is handling
business and will perform the deferred reset cleanup as part of unlocking
the state mutex. Finally, if the reset_done does acquire the state mutex,
it simply unlocks using the ice_vfio_pci_state_mutex_unlock helper which
will immediately handle the "deferred" reset.

This is complicated, but is similar to code in other VFIO migration drivers
including the mlx5 driver and logic in the virtiovf migration code.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
 drivers/vfio/pci/ice/main.c | 69 +++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 67 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/pci/ice/main.c b/drivers/vfio/pci/ice/main.c
index 161053ba383c..17865fab02ce 100644
--- a/drivers/vfio/pci/ice/main.c
+++ b/drivers/vfio/pci/ice/main.c
@@ -36,17 +36,21 @@ struct ice_vfio_pci_migration_file {
  * @core_device: The core device being operated on
  * @mig_info: Migration information
  * @state_mutex: mutex protecting the migration state
+ * @reset_lock: spinlock protecting the reset_done flow
  * @resuming_migf: Migration file containing data for the resuming VF
  * @saving_migf: Migration file used to store data from saving VF
  * @mig_state: the current migration state of the device
+ * @needs_reset: if true, reset is required at next unlock of state_mutex
  */
 struct ice_vfio_pci_device {
 	struct vfio_pci_core_device core_device;
 	struct vfio_device_migration_info mig_info;
 	struct mutex state_mutex;
+	spinlock_t reset_lock;
 	struct ice_vfio_pci_migration_file *resuming_migf;
 	struct ice_vfio_pci_migration_file *saving_migf;
 	enum vfio_device_mig_state mig_state;
+	bool needs_reset:1;
 };
 
 #define to_ice_vdev(dev) \
@@ -154,6 +158,65 @@ static void ice_vfio_pci_disable_fds(struct ice_vfio_pci_device *ice_vdev)
 	}
 }
 
+/**
+ * ice_vfio_pci_state_mutex_unlock - Unlock state_mutex
+ * @mutex: pointer to the ice-vfio-pci state_mutex
+ *
+ * ice_vfio_pci_reset_done may defer a reset in the event it fails to acquire
+ * the state_mutex. This is necessary in order to avoid an unconditional
+ * acquire of the state_mutex that could lead to ABBA lock inversion issues
+ * with the mm lock.
+ *
+ * This function is called to unlock the state_mutex, but ensures that any
+ * deferred reset is handled prior to unlocking. It uses the reset_lock to
+ * check if any reset has been deferred.
+ */
+static void ice_vfio_pci_state_mutex_unlock(struct mutex *mutex)
+{
+	struct ice_vfio_pci_device *ice_vdev =
+		container_of(mutex, struct ice_vfio_pci_device,
+			     state_mutex);
+
+again:
+	spin_lock(&ice_vdev->reset_lock);
+	if (ice_vdev->needs_reset) {
+		ice_vdev->needs_reset = false;
+		spin_unlock(&ice_vdev->reset_lock);
+		ice_vdev->mig_state = VFIO_DEVICE_STATE_RUNNING;
+		ice_vfio_pci_disable_fds(ice_vdev);
+		goto again;
+	}
+	/* The state_mutex must be unlocked before the reset_lock, otherwise
+	 * a new deferred reset could occur inbetween. Such a reset then be
+	 * deferred until the next state_mutex critical section.
+	 */
+	mutex_unlock(&ice_vdev->state_mutex);
+	spin_unlock(&ice_vdev->reset_lock);
+}
+
+/**
+ * ice_vfio_pci_reset_done - Handle or defer PCI reset
+ * @pdev: The PCI device structure
+ *
+ * As the higher VFIO layers are holding locks across reset and using those
+ * same locks with the mm_lock we need to prevent ABBA deadlock with the
+ * state_mutex and mm_lock. In case the state_mutex was taken already we defer
+ * the cleanup work to the unlock flow of the other running context.
+ */
+static void ice_vfio_pci_reset_done(struct pci_dev *pdev)
+{
+	struct ice_vfio_pci_device *ice_vdev = dev_get_drvdata(&pdev->dev);
+
+	spin_lock(&ice_vdev->reset_lock);
+	ice_vdev->needs_reset = true;
+	if (!mutex_trylock(&ice_vdev->state_mutex)) {
+		spin_unlock(&ice_vdev->reset_lock);
+		return;
+	}
+	spin_unlock(&ice_vdev->reset_lock);
+	ice_vfio_pci_state_mutex_unlock(&ice_vdev->state_mutex);
+}
+
 /**
  * ice_vfio_pci_open_device - VFIO .open_device callback
  * @vdev: the VFIO device to open
@@ -526,7 +589,7 @@ ice_vfio_pci_set_device_state(struct vfio_device *vdev,
 		}
 	}
 
-	mutex_unlock(&ice_vdev->state_mutex);
+	ice_vfio_pci_state_mutex_unlock(&ice_vdev->state_mutex);
 
 	return res;
 }
@@ -547,7 +610,7 @@ static int ice_vfio_pci_get_device_state(struct vfio_device *vdev,
 
 	*curr_state = ice_vdev->mig_state;
 
-	mutex_unlock(&ice_vdev->state_mutex);
+	ice_vfio_pci_state_mutex_unlock(&ice_vdev->state_mutex);
 
 	return 0;
 }
@@ -583,6 +646,7 @@ static int ice_vfio_pci_core_init_dev(struct vfio_device *vdev)
 	struct ice_vfio_pci_device *ice_vdev = to_ice_vdev(vdev);
 
 	mutex_init(&ice_vdev->state_mutex);
+	spin_lock_init(&ice_vdev->reset_lock);
 
 	vdev->migration_flags =
 		VFIO_MIGRATION_STOP_COPY | VFIO_MIGRATION_P2P;
@@ -681,6 +745,7 @@ static const struct pci_device_id ice_vfio_pci_table[] = {
 MODULE_DEVICE_TABLE(pci, ice_vfio_pci_table);
 
 static const struct pci_error_handlers ice_vfio_pci_core_err_handlers = {
+	.reset_done = ice_vfio_pci_reset_done,
 	.error_detected = vfio_pci_core_aer_err_detected,
 };
 

-- 
2.51.0.rc1.197.g6d975e95c9d7


