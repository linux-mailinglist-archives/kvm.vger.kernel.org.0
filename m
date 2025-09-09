Return-Path: <kvm+bounces-57153-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 38BFAB5089D
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 00:01:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2558A5E7B20
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 22:01:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FB6D274FD3;
	Tue,  9 Sep 2025 22:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ms1PZxwe"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E440263F44;
	Tue,  9 Sep 2025 22:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757455214; cv=none; b=emv8ofwR3dubuK3mvdSAXd0Jr+QfAtmG/I9hhu7EQw3CnaOv+NdGamBZm0qVnNdkAX7XKMrdVIze9bKWyCVqJD3oeyN26LoRaN+NSXTRpgzoL6hgfKlM0HajZccdbhhh6Iz1qiIvh/OZfI2/vUmWpDDYVZpZ5q9e9FOir9mXEt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757455214; c=relaxed/simple;
	bh=zBu7BSSYtF+/LaaPaw5MmMaobB0x6Gnri9E517yTZ/I=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=iKBklM0cONko0wz+LmFlNbk0THorhOwx5WvSaSNDYd0IOZ8xiOtq+mF1RHSEux0nHpS24LIvCtqJ6TJaTHa8fFf0miD1NFWwuYGHvcb3Qnp2imdPWhGhP1tDwXu3g92R4p3h3B7IvFiSFCJcYcXCNc/3zfAUalIdkwh6V8pPO5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ms1PZxwe; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757455212; x=1788991212;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=zBu7BSSYtF+/LaaPaw5MmMaobB0x6Gnri9E517yTZ/I=;
  b=Ms1PZxweTexfc+e1OxYd2wA6Q7/ZzWHn4uz0Mnmh/xhgq9WYFq75aLHa
   cjuuElKAxXvf4owDHETBuCnwSDcvC74eXRER+FD6zCkfvP2ke/RT0m3Mc
   g6+kH7oMKl1kTjJ5nPsks40nqB2HWTI6swSZLJxcoITnncPsj3Ytf7mX8
   Twmx5MdhLbqK6FN7GeWYfwbdMjhRavU4UtpEyX2bK7XwNV9tGZMDsQBtu
   cr8ikonTmeggx3eXs2LtHTf7pIuGCRNcyhM0vACW+PvImduoJOypcnTYr
   23bx/q0qkbuHQDUVShQoyI8DvAaAw+4iaxHKXClAzh1JTJVvStwqDLBRr
   Q==;
X-CSE-ConnectionGUID: MO9BBe4uSq273h2EVY9z6A==
X-CSE-MsgGUID: 7IrAjfzASJiK5llPyVSlPg==
X-IronPort-AV: E=McAfee;i="6800,10657,11548"; a="63584645"
X-IronPort-AV: E=Sophos;i="6.18,252,1751266800"; 
   d="scan'208";a="63584645"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 15:00:08 -0700
X-CSE-ConnectionGUID: a0qT42+XQaWDyK3VKq/wIA==
X-CSE-MsgGUID: AKzneJqxQriGs9Z++AywZw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,252,1751266800"; 
   d="scan'208";a="172780961"
Received: from orcnseosdtjek.jf.intel.com (HELO [10.166.28.70]) ([10.166.28.70])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 15:00:07 -0700
From: Jacob Keller <jacob.e.keller@intel.com>
Date: Tue, 09 Sep 2025 14:57:52 -0700
Subject: [PATCH RFC net-next 3/7] ice: add migration TLV for basic VF
 information
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250909-e810-live-migration-jk-migration-tlv-v1-3-4d1dc641e31f@intel.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=14888;
 i=jacob.e.keller@intel.com; h=from:subject:message-id;
 bh=zBu7BSSYtF+/LaaPaw5MmMaobB0x6Gnri9E517yTZ/I=;
 b=owGbwMvMwCWWNS3WLp9f4wXjabUkhowDi1MFPLfO1mIzW8Xc/DTH88IyxUP/NHeF7Ji9arVsi
 nls5v+lHaUsDGJcDLJiiiwKDiErrxtPCNN64ywHM4eVCWQIAxenAEykZz7D/4ydH+TE9milfKxo
 FNp9KURyTmG5Z09swzOeoF26/LbWdQx/+BsSJGd0Noma/77A3x7wdsLMU8cucZxi2NHiUZWh+8S
 GHwA=
X-Developer-Key: i=jacob.e.keller@intel.com; a=openpgp;
 fpr=204054A9D73390562AEC431E6A965D3E6F0F28E8

Add the ICE_MIG_TLV_VF_INFO TLV type to the migration payload. This TLV
contains the basic VF information. This data is special, as it must be
loaded first prior to other data from TLVs such as per-queue information.

The ice_mig_vf_info structure is the element structure for this TLV. It
contains the HW address, virtchnl information, and a variety of other
information stored by the host PF.

The trickiest detail is the handling for the set of allowed opcodes the VF
has negotiated. These are typically stored as a bitmap array, which depends
on the size of the VIRTCHNL_OP_MAX. To handle this, make the
opcodes_allowlist a flexible array of u32. This is done to avoid encoding
the VIRTCHNL_OP_MAX as part of the structure layout. Instead, it is passed
as a field in the ice_mig_vf_info structure.

The opcodes_allowlist is copied using bitmap_from_arr32 and
bitmap_to_arr32 to facilitate conversion from the normal host PF data
structures. Care is taken when restoring the VF information to only copy up
to the new host's VIRTCHNL_OP_MAX. Additionally, any bits beyond the
original host virtchnl_op_max are cleared to prevent the VF from sending
these ops.

Add logic to save the VF information during suspend. This is done before
the host device is stopped, to ensure we save the correct data without any
loss due to resets.

When restoring the VF information, a pointer to the VF information is
located as part of ice_migration_validate_tlvs(). This allows loading the
VF information first, regardless of what order the TLVs are serialized.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
---
 .../net/ethernet/intel/ice/virt/migration_tlv.h    |  56 ++++++
 drivers/net/ethernet/intel/ice/virt/migration.c    | 206 ++++++++++++++++++++-
 2 files changed, 260 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/virt/migration_tlv.h b/drivers/net/ethernet/intel/ice/virt/migration_tlv.h
index 2c5b4578060b..f941a6ccfe77 100644
--- a/drivers/net/ethernet/intel/ice/virt/migration_tlv.h
+++ b/drivers/net/ethernet/intel/ice/virt/migration_tlv.h
@@ -70,6 +70,9 @@ struct ice_migration_tlv {
  * @ICE_MIG_TLV_HEADER: Header identifying the migration format. Must be the
  * first TLV in the list.
  *
+ * @ICE_MIG_TLV_VF_INFO: General configuration of the VF, including data
+ * exchanged over virtchnl as well as PF host configuration.
+ *
  * @NUM_ICE_MIG_TLV: Number of known TLV types. Any type equal to or larger
  * than this value is unrecognized by this version.
  *
@@ -81,6 +84,7 @@ enum ice_migration_tlvs {
 	/* Do not change the order or add anything between, this is ABI! */
 	ICE_MIG_TLV_END = 0,
 	ICE_MIG_TLV_HEADER,
+	ICE_MIG_TLV_VF_INFO,
 
 	/* Add new types above here */
 	NUM_ICE_MIG_TLV
@@ -121,6 +125,57 @@ struct ice_mig_tlv_header {
 	u16 num_supported_tlvs;
 } __packed;
 
+/**
+ * struct ice_mig_vf_info - Basic VF information
+ * @dev_lan_addr: The current device LAN address
+ * @hw_lan_addr: The HW LAN address
+ * @driver_caps: Driver capabilities reported by the VF
+ * @vlan_v2_caps: The VLAN V2 capabilities of the VF
+ * @vf_ver: The reported virtchnl version of the VF
+ * @min_tx_rate: The programmed minimum Tx rate of the VF
+ * @max_tx_rate: The programmed maximum Tx rate of the VF
+ * @virtchnl_op_max: The largest known virtchnl opcode
+ * @allowlist_size: The size of the opcodes_allowlist
+ * @num_vf_qs: The number of queues assigned to the VF
+ * @num_msix: The number of MSI-X vectors used by the VF
+ * @port_vlan_tpid: port VLAN TPID
+ * @port_vlan_vid: port VLAN VID
+ * @port_vlan_prio: port VLAN priority
+ * @inner_vlan_strip_ena: True if the inner VLAN stripping is enabled
+ * @outer_vlan_strip_ena: True if the outer VLAN stripping is enabled
+ * @pf_set_mac: True if the PF administratively set the MAC address
+ * @trusted: True of the PF set the trusted VF flag for this VF
+ * @spoofchk: True if spoof checking is enabled on this VF
+ * @driver_active: True if the VF driver has initialized over virtchnl.
+ * @link_forced: True if the link status of this VF is forced
+ * @link_up: The forced link status, ignored if link_forced is false
+ * @opcodes_allowlist: The list of currently allowed opcodes as array of u32
+ */
+struct ice_mig_vf_info {
+	u8 dev_lan_addr[ETH_ALEN];
+	u8 hw_lan_addr[ETH_ALEN];
+	u32 driver_caps;
+	struct virtchnl_vlan_caps vlan_v2_caps;
+	struct virtchnl_version_info vf_ver;
+	u32 min_tx_rate;
+	u32 max_tx_rate;
+	u32 virtchnl_op_max;
+	u16 num_vf_qs;
+	u16 num_msix;
+	u16 port_vlan_tpid;
+	u16 port_vlan_vid;
+	u8 port_vlan_prio;
+	u8 inner_vlan_strip_ena:1;
+	u8 outer_vlan_strip_ena:1;
+	u8 pf_set_mac:1;
+	u8 trusted:1;
+	u8 spoofchk:1;
+	u8 driver_active:1;
+	u8 link_forced:1;
+	u8 link_up:1;			/* only valid if VF link is forced */
+	u32 opcodes_allowlist[]; /* __counted_by(virtchnl_op_max), in bits */
+} __packed;
+
 /**
  * ice_mig_tlv_type - Convert a TLV type to its number
  * @p: the TLV structure type
@@ -132,6 +187,7 @@ struct ice_mig_tlv_header {
 #define ice_mig_tlv_type(p)						\
 	_Generic(*(p),							\
 		 struct ice_mig_tlv_header : ICE_MIG_TLV_HEADER,	\
+		 struct ice_mig_vf_info : ICE_MIG_TLV_VF_INFO,		\
 		 default : ICE_MIG_TLV_END)
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/virt/migration.c b/drivers/net/ethernet/intel/ice/virt/migration.c
index aa2e17c5be60..67ce5b73a9ce 100644
--- a/drivers/net/ethernet/intel/ice/virt/migration.c
+++ b/drivers/net/ethernet/intel/ice/virt/migration.c
@@ -85,6 +85,59 @@ void ice_migration_uninit_dev(struct pci_dev *vf_dev)
 }
 EXPORT_SYMBOL(ice_migration_uninit_dev);
 
+/**
+ * ice_migration_save_vf_info - Save VF information during suspend
+ * @vf: pointer to the VF being migrated
+ * @vsi: pointer to the VSI for this VF
+ *
+ * Save the VF device information when suspending a VF for live migration.
+ *
+ * Return: 0 on success, negative error code on failure.
+ */
+static int ice_migration_save_vf_info(struct ice_vf *vf, struct ice_vsi *vsi)
+{
+	struct ice_mig_vf_info *vf_info;
+
+	lockdep_assert_held(&vf->cfg_lock);
+
+	vf_info = ice_mig_alloc_flex_tlv(vf_info, opcodes_allowlist,
+					 BITS_TO_U32(VIRTCHNL_OP_MAX));
+	if (!vf_info)
+		return -ENOMEM;
+
+	vf_info->driver_caps = vf->driver_caps;
+	vf_info->port_vlan_tpid = vf->port_vlan_info.tpid;
+	vf_info->port_vlan_vid = vf->port_vlan_info.vid;
+	vf_info->port_vlan_prio = vf->port_vlan_info.prio;
+	vf_info->vlan_v2_caps = vf->vlan_v2_caps;
+	vf_info->vf_ver = vf->vf_ver;
+	vf_info->min_tx_rate = vf->min_tx_rate;
+	vf_info->max_tx_rate = vf->max_tx_rate;
+	vf_info->num_vf_qs = vf->num_vf_qs;
+	vf_info->num_msix = vf->num_msix;
+	vf_info->inner_vlan_strip_ena =
+		vf->vlan_strip_ena & ICE_INNER_VLAN_STRIP_ENA ? 1 : 0;
+	vf_info->outer_vlan_strip_ena =
+		vf->vlan_strip_ena & ICE_OUTER_VLAN_STRIP_ENA ? 1 : 0;
+	vf_info->pf_set_mac = vf->pf_set_mac;
+	vf_info->trusted = vf->trusted;
+	vf_info->spoofchk = vf->spoofchk;
+	vf_info->link_forced = vf->link_forced;
+	vf_info->link_up = vf->link_up;
+	vf_info->driver_active = test_bit(ICE_VF_STATE_ACTIVE, vf->vf_states);
+
+	ether_addr_copy(vf_info->dev_lan_addr, vf->dev_lan_addr);
+	ether_addr_copy(vf_info->hw_lan_addr, vf->hw_lan_addr);
+
+	vf_info->virtchnl_op_max = VIRTCHNL_OP_MAX;
+	bitmap_to_arr32(vf_info->opcodes_allowlist, vf->opcodes_allowlist,
+			VIRTCHNL_OP_MAX);
+
+	ice_mig_tlv_add_tail(vf_info, &vf->mig_tlvs);
+
+	return 0;
+}
+
 /**
  * ice_migration_suspend_dev - suspend device
  * @vf_dev: pointer to the VF PCI device
@@ -138,6 +191,10 @@ int ice_migration_suspend_dev(struct pci_dev *vf_dev, bool save_state)
 				kfree(entry);
 			}
 		}
+
+		err = ice_migration_save_vf_info(vf, vsi);
+		if (err)
+			goto err_free_mig_tlvs;
 	}
 
 	/* Prevent VSI from queuing incoming packets by removing all filters */
@@ -434,6 +491,7 @@ static int ice_migration_check_tlv_size(struct device *dev,
  * @dev: pointer to device
  * @buf: pointer to device state buffer
  * @buf_sz: size of buffer
+ * @vf_info: on return, pointer to the VF info TLV
  *
  * Ensure that the TLV data provided is valid, and matches the expected
  * version and format.
@@ -441,7 +499,8 @@ static int ice_migration_check_tlv_size(struct device *dev,
  * Return: 0 for success, negative for error
  */
 static int
-ice_migration_validate_tlvs(struct device *dev, const void *buf, size_t buf_sz)
+ice_migration_validate_tlvs(struct device *dev, const void *buf, size_t buf_sz,
+			    const struct ice_mig_vf_info **vf_info)
 {
 	const struct ice_mig_tlv_header *header;
 	const struct ice_migration_tlv *tlv;
@@ -476,6 +535,8 @@ ice_migration_validate_tlvs(struct device *dev, const void *buf, size_t buf_sz)
 		return -EPROTONOSUPPORT;
 	}
 
+	*vf_info = NULL;
+
 	/* Validate remaining TLVs */
 	do {
 		/* Move to next TLV */
@@ -502,8 +563,140 @@ ice_migration_validate_tlvs(struct device *dev, const void *buf, size_t buf_sz)
 		/* TODO: implement other validation? Check for compatibility
 		 * with queue sizes, vector counts, VLAN capabilities, etc?
 		 */
+
+		/* Save the VF info pointer, as we must process it first */
+		if (tlv->type == ICE_MIG_TLV_VF_INFO)
+			*vf_info = (typeof(*vf_info))tlv->data;
+
 	} while (buf_sz > 0);
 
+	if (!*vf_info) {
+		dev_dbg(dev, "Missing VF information TLV in migration payload\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+/**
+ * ice_migration_load_vf_info - Load VF information from migration buffer
+ * @vf: pointer to the VF being migrated to
+ * @vsi: the VSI for this VF
+ * @vf_info: VF information from the migration buffer
+ *
+ * Load the VF information from the migration buffer, preparing the VF to
+ * complete migration.
+ *
+ * Return: 0 on success, or a negative error code on failure.
+ */
+static int ice_migration_load_vf_info(struct ice_vf *vf, struct ice_vsi *vsi,
+				      const struct ice_mig_vf_info *vf_info)
+{
+	struct device *dev = ice_pf_to_dev(vf->pf);
+	int err;
+
+	lockdep_assert_held(&vf->cfg_lock);
+
+	dev_dbg(dev, "Loading general VF configuration for VF %u\n",
+		vf->vf_id);
+
+	dev_dbg(dev, "VF %d had %u MSI-X vectors. Requesting %u vectors\n",
+		vf->vf_id, vf->num_msix, vf_info->num_msix);
+
+	/* Change the number of MSI-X vectors first */
+	// TODO: ice_sriov_set_msix_vec_count sets the MSI-X to 1 more than
+	// the value passed in. This should be fixed.
+	err = ice_sriov_set_msix_vec_count(vf->vfdev, vf_info->num_msix - ICE_NONQ_VECS_VF);
+	if (err) {
+		dev_dbg(dev, "Unable to reconfigure MSI-X vectors, err %d\n",
+			err);
+		return err;
+	}
+
+	/* Set values which are configured by VF reset */
+	vf->trusted = vf_info->trusted;
+	vf->num_req_qs = vf_info->num_vf_qs;
+	vf->port_vlan_info.tpid = vf_info->port_vlan_tpid;
+	vf->port_vlan_info.vid = vf_info->port_vlan_vid;
+	vf->port_vlan_info.prio = vf_info->port_vlan_prio;
+	vf->min_tx_rate = vf_info->min_tx_rate;
+	vf->max_tx_rate = vf_info->max_tx_rate;
+	vf->spoofchk = vf_info->spoofchk;
+
+	ether_addr_copy(vf->dev_lan_addr, vf_info->dev_lan_addr);
+	ether_addr_copy(vf->hw_lan_addr, vf_info->hw_lan_addr);
+
+	/* Reset the VF */
+	ice_reset_vf(vf, 0);
+
+	/* Configure the rest of the settings */
+	vf->vlan_v2_caps = vf_info->vlan_v2_caps;
+	vf->vf_ver = vf_info->vf_ver;
+	vf->driver_caps = vf_info->driver_caps;
+
+	if (vf_info->inner_vlan_strip_ena) {
+		err = vsi->inner_vlan_ops.ena_stripping(vsi, ETH_P_8021Q);
+		if (err) {
+			dev_dbg(dev, "Failed to enable inner VLAN stripping, err %d\n",
+				err);
+			return err;
+		}
+		vf->vlan_strip_ena |= ICE_INNER_VLAN_STRIP_ENA;
+	} else {
+		err = vsi->inner_vlan_ops.dis_stripping(vsi);
+		if (err) {
+			dev_dbg(dev, "Failed to enable inner VLAN stripping, err %d\n",
+				err);
+			return err;
+		}
+		vf->vlan_strip_ena &= ~ICE_INNER_VLAN_STRIP_ENA;
+	}
+
+	if (vf_info->outer_vlan_strip_ena) {
+		enum ice_l2tsel l2tsel =
+			ICE_L2TSEL_EXTRACT_FIRST_TAG_L2TAG2_2ND;
+
+		err = vsi->outer_vlan_ops.ena_stripping(vsi, ETH_P_8021Q);
+		if (err) {
+			dev_dbg(dev, "Failed to enable outer VLAN stripping, err %d\n",
+				err);
+			return err;
+		}
+		ice_vsi_update_l2tsel(vsi, l2tsel);
+		vf->vlan_strip_ena |= ICE_OUTER_VLAN_STRIP_ENA;
+	} else {
+		enum ice_l2tsel l2tsel =
+			ICE_L2TSEL_EXTRACT_FIRST_TAG_L2TAG1;
+
+		err = vsi->outer_vlan_ops.dis_stripping(vsi);
+		if (err) {
+			dev_dbg(dev, "Failed to enable outer VLAN stripping, err %d\n",
+				err);
+			return err;
+		}
+		ice_vsi_update_l2tsel(vsi, l2tsel);
+		vf->vlan_strip_ena &= ~ICE_OUTER_VLAN_STRIP_ENA;
+	}
+
+	vf->pf_set_mac = vf_info->pf_set_mac;
+	vf->link_forced = vf_info->link_forced;
+	vf->link_up = vf_info->link_up;
+
+	/* TODO: should we just enforce that virtchnl_op_max matches
+	 * VIRTCHNL_OP_MAX?
+	 */
+	bitmap_from_arr32(vf->opcodes_allowlist, vf_info->opcodes_allowlist,
+			  min(VIRTCHNL_OP_MAX, vf_info->virtchnl_op_max));
+
+	/* Disallow any ops the original VF didn't recognize */
+	if (vf_info->virtchnl_op_max < VIRTCHNL_OP_MAX)
+		bitmap_clear(vf->opcodes_allowlist,
+			     vf_info->virtchnl_op_max,
+			     VIRTCHNL_OP_MAX - vf_info->virtchnl_op_max);
+
+	if (vf_info->driver_active)
+		set_bit(ICE_VF_STATE_ACTIVE, vf->vf_states);
+
 	return 0;
 }
 
@@ -522,6 +715,7 @@ int ice_migration_load_devstate(struct pci_dev *vf_dev, const void *buf,
 				size_t buf_sz)
 {
 	struct ice_pf *pf = ice_vf_dev_to_pf(vf_dev);
+	const struct ice_mig_vf_info *vf_info;
 	const struct ice_migration_tlv *tlv;
 	struct ice_vsi *vsi;
 	struct device *dev;
@@ -539,7 +733,7 @@ int ice_migration_load_devstate(struct pci_dev *vf_dev, const void *buf,
 	dev_dbg(&vf_dev->dev, "Loading live migration state. Migration buffer is %zu bytes\n",
 		buf_sz);
 
-	err = ice_migration_validate_tlvs(dev, buf, buf_sz);
+	err = ice_migration_validate_tlvs(dev, buf, buf_sz, &vf_info);
 	if (err)
 		return err;
 
@@ -558,6 +752,13 @@ int ice_migration_load_devstate(struct pci_dev *vf_dev, const void *buf,
 		goto err_release_cfg_lock;
 	}
 
+	err = ice_migration_load_vf_info(vf, vsi, vf_info);
+	if (err) {
+		dev_dbg(dev, "Failed to load initial VF information, err %d\n",
+			err);
+		goto err_release_cfg_lock;
+	}
+
 	/* Iterate over TLVs and process migration data */
 	tlv = buf;
 
@@ -567,6 +768,7 @@ int ice_migration_load_devstate(struct pci_dev *vf_dev, const void *buf,
 		switch (tlv->type) {
 		case ICE_MIG_TLV_END:
 		case ICE_MIG_TLV_HEADER:
+		case ICE_MIG_TLV_VF_INFO:
 			/* These are already handled above */
 			break;
 		default:

-- 
2.51.0.rc1.197.g6d975e95c9d7


