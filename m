Return-Path: <kvm+bounces-57152-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DDD5CB5089C
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 00:01:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9D79E444D65
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 22:00:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EF59271462;
	Tue,  9 Sep 2025 22:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TauRSjvm"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BE5CDF6C;
	Tue,  9 Sep 2025 22:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757455213; cv=none; b=M0vd6dSEy4BZKix9829TaMOqG1ZxghX9qXgBAAiDvDC6oe370qTkjzVRqOfzaBGU1WB5Uo7HTyNtSFcN69+0NvmbtHETM7ufDxvyZPojWsSoyxaekTJ9UGCgkdBz51+iHNVFVPD5/SCgf/nI1zZrAOcnn0gbc/VMvhCYrYJVmUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757455213; c=relaxed/simple;
	bh=+cYC7KKFbfc+PsZdj7Hu4e4V8Q72FyxbrdzCuw3DHgM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=SM50U/be1WfJq/hap/1tWZiqg3+UT+GZr6Of96K5Vd/6L0sQ3FgHZ8UhiWmC49ktMB3+7f/bzJ6z0kU+ehVrt1VYQmmuKQiNds76mK4pvfgiOF0QywsL3rkX56TkL2E5tMfk0ZAgV5DF5NyDmonhdcrer1B/epYp2lMH/YJsDTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TauRSjvm; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757455211; x=1788991211;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=+cYC7KKFbfc+PsZdj7Hu4e4V8Q72FyxbrdzCuw3DHgM=;
  b=TauRSjvmZcnXcTDBphAUWvAlW+x56BOnxULB59bYa8LpMMC303dVFEqJ
   La7mWxZzFvMO3tHkGdvF+iUTMQCBY1tOtqNuzzjcsc71JMPHCfvX+k88U
   WtoaSJ4Sd/ZPsJQO/LlcbuOtuTy7D1/f8dkq4XqZLfBfbCt941cMSOwKv
   3bp3IrzEvH4bL1RaXz2dwhQc4Qih12baRWOKYrtwCZT8a5KD667mnz17E
   inLZVOzhodR158hPKR5VPIGbKokNbxMwMlAy+uVJoOOJ9SqCtrlq4hAd8
   pu/riEAxr5n03UBQXgc/wCw81sNpbFhKVfnn/2FJ0tz0cNB0Q9SruQync
   Q==;
X-CSE-ConnectionGUID: c6mNF5eyQxuQAP45cTZE9w==
X-CSE-MsgGUID: cjaxYB8nRISwUdbR+4m9AA==
X-IronPort-AV: E=McAfee;i="6800,10657,11548"; a="63584620"
X-IronPort-AV: E=Sophos;i="6.18,252,1751266800"; 
   d="scan'208";a="63584620"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 15:00:07 -0700
X-CSE-ConnectionGUID: xzLJntAGSSqXvhKR6ZBw/w==
X-CSE-MsgGUID: vOu/IhS/RM+HPCdVOrJRhA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,252,1751266800"; 
   d="scan'208";a="172780951"
Received: from orcnseosdtjek.jf.intel.com (HELO [10.166.28.70]) ([10.166.28.70])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 15:00:07 -0700
From: Jacob Keller <jacob.e.keller@intel.com>
Date: Tue, 09 Sep 2025 14:57:50 -0700
Subject: [PATCH RFC net-next 1/7] ice: add basic skeleton and TLV framework
 for live migration support
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250909-e810-live-migration-jk-migration-tlv-v1-1-4d1dc641e31f@intel.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=33763;
 i=jacob.e.keller@intel.com; h=from:subject:message-id;
 bh=+cYC7KKFbfc+PsZdj7Hu4e4V8Q72FyxbrdzCuw3DHgM=;
 b=owGbwMvMwCWWNS3WLp9f4wXjabUkhowDi1PUbNXYWcqeG7eYT3t6Zc2hl2bOIrcmli/+Nsnwh
 9X1VgO+jlIWBjEuBlkxRRYFh5CV140nhGm9cZaDmcPKBDKEgYtTACbyW4vhv3f/ntqtvYfCxM2O
 1fzLCpubcPmz9utjdRUis6erHPt/6xvDP+viA1UbpjbKWIW+lilJ6znH+yZCLCpw5V3pSM1Puk/
 /8gMA
X-Developer-Key: i=jacob.e.keller@intel.com; a=openpgp;
 fpr=204054A9D73390562AEC431E6A965D3E6F0F28E8

In preparation for supporting VF live migration, introduce a new functional
block to the ice driver to expose hooks for migrating a VF.

The ice-vfio-pci driver will call ice_migration_init_dev() to indicate that
the migration driver is loaded.

When the host wants to migrate the device, first it suspends the device by
calling ice_migration_suspend_dev(). Then it saves any device state by
calling ice_migration_save_devstate() which serializes the VF device state
into a buffer payload which is sent to the resuming host. This target
system calls ice_migration_suspend_dev() to stop the target VF device, and
finally calls ice_migration_load_devstate() to deserialize the migration
state and program the target VF.

Add the virt/migration.c file and implement the skeleton for these
functions. A basic framework is implemented, but the following patches will
fully flesh out the serialization and deserialization for the various kinds
of VF data.

Previous implementations of live migration were implemented by serializing
device state as a series of virtchnl messages. It was thought that this
would be simple since virtchnl is the ABI for communication between the PF
and VF.

Unfortunately, use of virtchnl presented numerous problems. To avoid these
issues, the migration buffer will be implemented using a custom
Type-Length-Value format which avoids a few key issues with the virtchnl
solution:

1. Migration data is only captured when a live migration event is
   requested. The driver no longer caches a copy of every virtchnl message
   sent by the VF.
2. Migration data size is bounded, and the VF cannot indirectly increase it
   to arbitrary sizes by sending unexpected sequences of virtchnl messages.
3. Replay of VF state is controlled precisely, and no longer requires
   modification of the standard virtchnl communication flow.
4. Additional data about the VF state is sent over the migration buffer,
   which is not captured by virtchnl messages. This includes host state
   such as the VF trust flag, MSI-X configuration, RSS configuration, etc.

Introduce the initial support for this TLV format along with the first TLV
for storing basic VF info.

The TLV definitions are placed in virt/migration_tlv.h which defines the
payload data and describes the ABI for this communication format. The first
TLV must be the ICE_MIG_TLV_HEADER which consists of a magic number and a
version used to identify the payload format. This allows for the
possibility of future extension should the entire format need to be
changed.

TLVs are specified as a series of ice_migration_tlv_structures, which are
variable length structures using a flexible array of bytes. These
structures are __packed. However, access to unaligned memory requires the
compiler to insert additional instructions to avoid unaligned access on
some platforms. To minimize -- but not completely remove -- this, the
length for all TLVs is required to be aligned to 4-bytes. The header itself
is 4 bytes, and this ensures that the header and all values with a size 4
bytes or smaller will have aligned access. 8 byte values may potentially be
unaligned, but use if the __packed attribute ensures that the compiler will
insert appropriate access instructions for all platforms.

Note that this migration implementation generally assumes the host and
target system are of the same endianness, integer size, etc. The chosen
magic number of 0xE8000001 will catch byte order difference, and all types
in the TLVs are fixed size.

The type of the  TLVs is specified by the ice_migration_tlvs enumeration.
This *is* ABI, and any extension must add new TLVs at the end of this list
just prior to the NUM_ICE_MIG_TLV which specifies the number of recognized
TLVs by this version of the ABI.

The exact "version" of the ABI is specified by a combination of the magic
number, the version in the header, and the number of TLVs as specified by
NUM_ICE_MIG_TLV, which is sent in the header. This allows for new TLVs to
be added in the future without needing to increment the version number.
Such an increment should only be done if any existing TLV format must
change, or if the entire format must change for some reason.

The payload *must* begin with the ICE_MIG_TLV_HEADER, as this specifies the
format. All other TLVs do not have an order, and receiving code must be
capable of handling TLVs in an arbitrary order. Some TLVs will be sent
multiple times, such as for Tx and Rx queue information.

The special ICE_MIG_TLV_END type must come last and is a marker to indicate
the end of the payload buffer. It has a size of 0.

Implement a few macros to help reduce boiler plate. The ice_mig_tlv_type()
macro converts a structure pointer to its TLV type using _Generic(). The
ice_mig_alloc_tlv() macro allocates a new TLV, returning the pointer to the
value structure. This macro ensures the 4-byte alignment required for all
TLV lengths. The ice_mig_alloc_flex_tlv() is similar, but allows allocating
a TLV whose element structure ends in a flexible array. Finally, the
ice_mig_tlv_add_tail() macro takes a pointer to an element structure and
inserts the container ice_mig_tlv_entry and inserts it into the TLV list
used for temporary storage.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h               |   2 +
 drivers/net/ethernet/intel/ice/ice_vf_lib.h        |   2 +
 .../net/ethernet/intel/ice/virt/migration_tlv.h    | 221 +++++++++
 include/linux/net/intel/ice_migration.h            |  49 ++
 drivers/net/ethernet/intel/ice/ice_main.c          |  16 +
 drivers/net/ethernet/intel/ice/ice_vf_lib.c        |   3 +
 drivers/net/ethernet/intel/ice/virt/migration.c    | 506 +++++++++++++++++++++
 drivers/net/ethernet/intel/ice/Makefile            |   1 +
 8 files changed, 800 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index e952d67388bf..daa395f5691f 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -55,6 +55,7 @@
 #include <net/vxlan.h>
 #include <net/gtp.h>
 #include <linux/ppp_defs.h>
+#include <linux/net/intel/ice_migration.h>
 #include "ice_devids.h"
 #include "ice_type.h"
 #include "ice_txrx.h"
@@ -1015,6 +1016,7 @@ int ice_vlan_rx_add_vid(struct net_device *netdev, __be16 proto, u16 vid);
 int ice_vlan_rx_kill_vid(struct net_device *netdev, __be16 proto, u16 vid);
 void ice_get_stats64(struct net_device *netdev,
 		     struct rtnl_link_stats64 *stats);
+struct ice_pf *ice_vf_dev_to_pf(struct pci_dev *vf_dev);
 
 /**
  * ice_set_rdma_cap - enable RDMA support
diff --git a/drivers/net/ethernet/intel/ice/ice_vf_lib.h b/drivers/net/ethernet/intel/ice/ice_vf_lib.h
index b00708907176..1a0c66182a9a 100644
--- a/drivers/net/ethernet/intel/ice/ice_vf_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_vf_lib.h
@@ -124,6 +124,7 @@ struct ice_vf {
 	u8 link_forced:1;
 	u8 link_up:1;			/* only valid if VF link is forced */
 	u8 lldp_tx_ena:1;
+	u8 migration_enabled:1;
 
 	u16 num_msix;			/* num of MSI-X configured on this VF */
 
@@ -158,6 +159,7 @@ struct ice_vf {
 	u16 lldp_rule_id;
 
 	struct ice_vf_qs_bw qs_bw[ICE_MAX_RSS_QS_PER_VF];
+	struct list_head mig_tlvs;
 };
 
 /* Flags for controlling behavior of ice_reset_vf */
diff --git a/drivers/net/ethernet/intel/ice/virt/migration_tlv.h b/drivers/net/ethernet/intel/ice/virt/migration_tlv.h
new file mode 100644
index 000000000000..2c5b4578060b
--- /dev/null
+++ b/drivers/net/ethernet/intel/ice/virt/migration_tlv.h
@@ -0,0 +1,221 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (c) 2025, Intel Corporation. */
+
+#ifndef _VIRT_MIGRATION_TLV_H_
+#define _VIRT_MIGRATION_TLV_H_
+
+#include <linux/list.h>
+
+/* The ice driver uses a series of TLVs to define the live migration data that
+ * is passed between PFs during a migration event. This data includes all of
+ * the information required to migrate the VM onto a new VF without loss of
+ * data.
+ *
+ * On a migration event, the initial PF will scan its VF structures for
+ * relevant information and serialize it into TLVs which are passed as part of
+ * the binary migration data.
+ *
+ * The target PF will read the binary migration data and deserialize it using
+ * the TLV definitions.
+ *
+ * The first TLV in the binary data *MUST* be ICE_MIG_TLV_HEADER, and defines
+ * the overall migration version and format.
+ *
+ * A receiving PF should scan the set of provided TLVs, and ensure that it
+ * recognizes all of the provided data. Once validated, the PF can apply the
+ * configuration to the target VF, ensuring it is configured appropriately to
+ * match the VM.
+ */
+
+#define ICE_MIG_MAGIC	0xE8000001
+#define ICE_MIG_VERSION	1
+
+#define ICE_MIG_VF_ITR_NUM	4
+
+/**
+ * struct ice_migration_tlv - TLV header structure
+ * @type: type identifier for the data
+ * @len: length of the data block
+ * @data: migration data payload
+ *
+ * Migration data is serialized using this structure as a series of
+ * type-length-value chunks. Each TLV is defined by its type. The length can
+ * be used to move to the next TLV in the full data payload.
+ *
+ * The data payload structure is defined by the structure associated with the
+ * type as defined by the following enumerations and structures.
+ *
+ * TLVs are placed within the binary migration payload sequentially, and are
+ * __packed in order to avoid padding.
+ *
+ * Some of the TLVs are variable length, which could result in excessive
+ * unaligned accesses. While the compiler should insert appropriate
+ * instructions to handle this access due to the __packed attribute, we
+ * enforce that all TLV headers begin at a 4-byte aligned boundary by padding
+ * all TLV sizes to multiple of 4-bytes. This minimizes the amount of
+ * unaligned access without sacrificing significant additional space.
+ */
+struct ice_migration_tlv {
+	u16 type;
+	u16 len;
+	u8 data[] __counted_by(len);
+} __packed;
+
+/**
+ * enum ice_migration_tlvs - Valid TLV types
+ *
+ * @ICE_MIG_TLV_END: Used to mark the end of the TLV list. The TLV header will
+ * have a len of 0 and no data.
+ *
+ * @ICE_MIG_TLV_HEADER: Header identifying the migration format. Must be the
+ * first TLV in the list.
+ *
+ * @NUM_ICE_MIG_TLV: Number of known TLV types. Any type equal to or larger
+ * than this value is unrecognized by this version.
+ *
+ * Enumeration of valid types for the virtualization migration data. The TLV
+ * data is transferred between PFs, so this must be treated as ABI that can't
+ * change.
+ */
+enum ice_migration_tlvs {
+	/* Do not change the order or add anything between, this is ABI! */
+	ICE_MIG_TLV_END = 0,
+	ICE_MIG_TLV_HEADER,
+
+	/* Add new types above here */
+	NUM_ICE_MIG_TLV
+};
+
+/**
+ * struct ice_mig_tlv_entry - Wrapper to store TLV entries in linked list
+ * @list_entry: list node used for temporary storage prior to STOP_COPY
+ * @tlv: The migration TLV data.
+ *
+ * Because ice_migration_tlv is a variable length structure, this is also
+ * a variable length structure.
+ */
+struct ice_mig_tlv_entry {
+	struct list_head list_entry;
+	struct ice_migration_tlv tlv;
+};
+
+/**
+ * struct ice_mig_tlv_header - Migration version header
+ * @magic: Magic number identifying this migration format. Always 0xE8000001.
+ * @version: Version of the migration format.
+ * @num_supported_tlvs: The value of NUM_ICE_MIG_TLV for the sender.
+ *
+ * Structure defining the version of the migration data payload. A magic
+ * number and version are used to identify this format. This is to potentially
+ * allow changing or extending the format in the future in a way that the
+ * receiving system can recognize.
+ *
+ * The num_supported_tlvs field is used to inform the receiver of the
+ * supported set of TLVs being sent with this payload. This allows the
+ * receiver to quickly identify if the payload may contain data it does not
+ * recognize.
+ */
+struct ice_mig_tlv_header {
+	u32 magic;
+	u16 version;
+	u16 num_supported_tlvs;
+} __packed;
+
+/**
+ * ice_mig_tlv_type - Convert a TLV type to its number
+ * @p: the TLV structure type
+ *
+ * Generic which converts the specified TLV structure type to its TLV numeric
+ * value. Used to reduce potential error when initializing a TLV header for
+ * the migration payload.
+ */
+#define ice_mig_tlv_type(p)						\
+	_Generic(*(p),							\
+		 struct ice_mig_tlv_header : ICE_MIG_TLV_HEADER,	\
+		 default : ICE_MIG_TLV_END)
+
+/**
+ * ice_mig_alloc_tlv - Allocate a non-variable length TLV entry
+ * @p: pointer to the TLV element type
+ *
+ * Shorthand macro which allocates space for both a TLV header and the TLV
+ * element structure. For variable-length TLVs with a flexible array member,
+ * use ice_mig_alloc_flex_tlv instead.
+ *
+ * Because the allocations are ultimately triggered from userspace, and must
+ * be held until userspace actually initiates the migration, allocate with
+ * GFP_KERLEL_ACCOUNT, causing the allocations to be accounted by kmemcg.
+ *
+ * Returns: pointer to the allocated TLV element, or NULL on failure to
+ * allocate.
+ */
+#define ice_mig_alloc_tlv(p)						\
+	({								\
+		struct ice_mig_tlv_entry *entry;			\
+		typeof(p) __elem;					\
+		size_t tlv_size;					\
+									\
+		tlv_size = ALIGN(sizeof(*__elem), 4);			\
+		entry = kzalloc(struct_size(entry, tlv.data, tlv_size), \
+				GFP_KERNEL_ACCOUNT);			\
+		if (!entry) {						\
+			__elem = NULL;					\
+		} else {						\
+			entry->tlv.type = ice_mig_tlv_type(__elem);	\
+			entry->tlv.len = tlv_size;			\
+			__elem = (typeof(__elem))entry->tlv.data;	\
+		}							\
+		__elem;							\
+	})
+
+/**
+ * ice_mig_alloc_flex_tlv - Allocate a variable length TLV with flexible array
+ * @p: pointer to the TLV element type
+ * @member: flexible array member element
+ * @count: number of elements in the flexible array.
+ *
+ * Shorthand macro which allocates space for both a TLV header and the TLV
+ * element structure, and its variable length flexible array member.
+ *
+ * Because the allocations are ultimately triggered from userspace, and must
+ * be held until userspace actually initiates the migration, allocate with
+ * GFP_KERLEL_ACCOUNT, causing the allocations to be accounted by kmemcg.
+ *
+ * Returns: pointer to the allocated TLV element, or NULL on failure to
+ * allocate.
+ */
+#define ice_mig_alloc_flex_tlv(p, member, count)			\
+	({								\
+		struct ice_mig_tlv_entry *entry;			\
+		typeof(p) __elem;					\
+		size_t tlv_size;					\
+									\
+		tlv_size = ALIGN(struct_size(__elem, member, count), 4);\
+		entry = kzalloc(struct_size(entry, tlv.data, tlv_size),	\
+				GFP_KERNEL_ACCOUNT);			\
+		if (!entry) {						\
+			__elem = NULL;					\
+		} else {						\
+			entry->tlv.type = ice_mig_tlv_type(__elem);	\
+			entry->tlv.len = tlv_size;			\
+			__elem = (typeof(__elem))entry->tlv.data;	\
+		}							\
+		__elem;							\
+	})
+
+/**
+ * ice_mig_tlv_add_tail - Add TLV element to tail of a TLV list
+ * @p: pointer to the TLV element
+ * @head: pointer to the head of the linked list to insert into
+ *
+ * Shorthand macro to find the struct ice_mig_tlv_entry header pointer of the
+ * given TLV element and insert it into the list.
+ */
+#define ice_mig_tlv_add_tail(p, head)					   \
+	({								   \
+		struct ice_mig_tlv_entry *entry;			   \
+		entry = container_of((void *)p, typeof(*entry), tlv.data); \
+		list_add_tail(&entry->list_entry, head);		   \
+	})
+
+#endif /* _VIRT_MIGRATION_TLV_H_ */
diff --git a/include/linux/net/intel/ice_migration.h b/include/linux/net/intel/ice_migration.h
new file mode 100644
index 000000000000..85095f4c02c4
--- /dev/null
+++ b/include/linux/net/intel/ice_migration.h
@@ -0,0 +1,49 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Copyright (C) 2018-2025 Intel Corporation */
+
+#ifndef _ICE_MIGRATION_H_
+#define _ICE_MIGRATION_H_
+
+#if IS_ENABLED(CONFIG_ICE_VFIO_PCI)
+int ice_migration_init_dev(struct pci_dev *vf_dev);
+void ice_migration_uninit_dev(struct pci_dev *vf_dev);
+size_t ice_migration_get_required_size(struct pci_dev *vf_dev);
+int ice_migration_save_devstate(struct pci_dev *vf_dev, void *buf,
+				size_t buf_sz);
+int ice_migration_load_devstate(struct pci_dev *vf_dev,
+				const void *buf, size_t buf_sz);
+int ice_migration_suspend_dev(struct pci_dev *vf_dev, bool save_state);
+#else
+static inline int ice_migration_init_dev(struct pci_dev *vf_dev)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline void ice_migration_uninit_dev(struct pci_dev *vf_dev) { }
+
+static inline size_t ice_migration_get_required_size(struct pci_dev *vf_dev)
+{
+	return 0;
+}
+
+static inline int
+ice_migration_save_devstate(struct pci_dev *vf_dev, void *buf,
+			    size_t buf_sz)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int ice_migration_load_devstate(struct pci_dev *vf_dev,
+					      const void *buf, size_t buf_sz)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int ice_migration_suspend_dev(struct pci_dev *vf_dev,
+					    bool save_state)
+{
+	return -EOPNOTSUPP;
+}
+#endif /* CONFIG_ICE_VFIO_PCI */
+
+#endif /* _ICE_MIGRATION_H_ */
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 92b95d92d599..2a204bb1ad31 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -9738,3 +9738,19 @@ static const struct net_device_ops ice_netdev_ops = {
 	.ndo_hwtstamp_get = ice_ptp_hwtstamp_get,
 	.ndo_hwtstamp_set = ice_ptp_hwtstamp_set,
 };
+
+/**
+ * ice_vf_dev_to_pf - Get PF private structure from VF PCI device pointer
+ * @vf_dev: pointer to a VF PCI device structure
+ *
+ * Obtain the PF private data structure of the ice PF associated with the
+ * provided VF PCI device.
+ *
+ * Return: pointer to the ice PF private data, or a ERR_PTR on failure.
+ */
+struct ice_pf *ice_vf_dev_to_pf(struct pci_dev *vf_dev)
+{
+	struct ice_pf *pf = pci_iov_get_pf_drvdata(vf_dev, &ice_driver);
+
+	return pf;
+}
diff --git a/drivers/net/ethernet/intel/ice/ice_vf_lib.c b/drivers/net/ethernet/intel/ice/ice_vf_lib.c
index de9e81ccee66..6b91aa9394af 100644
--- a/drivers/net/ethernet/intel/ice/ice_vf_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_vf_lib.c
@@ -1024,6 +1024,9 @@ void ice_initialize_vf_entry(struct ice_vf *vf)
 	else
 		ice_mbx_init_vf_info(&pf->hw, &vf->mbx_info);
 
+	/* List to store migration TLVs temporarily */
+	INIT_LIST_HEAD(&vf->mig_tlvs);
+
 	mutex_init(&vf->cfg_lock);
 }
 
diff --git a/drivers/net/ethernet/intel/ice/virt/migration.c b/drivers/net/ethernet/intel/ice/virt/migration.c
new file mode 100644
index 000000000000..f13b7674dabd
--- /dev/null
+++ b/drivers/net/ethernet/intel/ice/virt/migration.c
@@ -0,0 +1,506 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2018-2025 Intel Corporation */
+
+#include "ice.h"
+#include "ice_lib.h"
+#include "ice_fltr.h"
+#include "ice_base.h"
+#include "ice_txrx_lib.h"
+#include "virt/migration_tlv.h"
+
+/**
+ * ice_migration_init_dev - Enable migration support for the requested VF
+ * @vf_dev: pointer to the VF PCI device
+ *
+ * TODO: currently the vf->migration_enabled field is unused. It is likely
+ * that we will need to use it to check that features which cannot migrate are
+ * disabled.
+ *
+ * Return: 0 on success, negative error code on failure.
+ */
+int ice_migration_init_dev(struct pci_dev *vf_dev)
+{
+	struct ice_pf *pf = ice_vf_dev_to_pf(vf_dev);
+	struct ice_vf *vf;
+
+	if (IS_ERR(pf))
+		return PTR_ERR(pf);
+
+	vf = ice_get_vf_by_dev(pf, vf_dev);
+	if (!vf) {
+		dev_err(&vf_dev->dev, "Unable to locate VF from VF device\n");
+		return -EINVAL;
+	}
+
+	mutex_lock(&vf->cfg_lock);
+	vf->migration_enabled = true;
+	mutex_unlock(&vf->cfg_lock);
+
+	ice_put_vf(vf);
+	return 0;
+}
+EXPORT_SYMBOL(ice_migration_init_dev);
+
+/**
+ * ice_migration_uninit_dev - Disable migration support for the requested VF
+ * @vf_dev: pointer to the VF PCI device
+ */
+void ice_migration_uninit_dev(struct pci_dev *vf_dev)
+{
+	struct ice_pf *pf = ice_vf_dev_to_pf(vf_dev);
+	struct device *dev;
+	struct ice_vf *vf;
+
+	if (IS_ERR(pf))
+		return;
+
+	vf = ice_get_vf_by_dev(pf, vf_dev);
+	if (!vf) {
+		dev_err(&vf_dev->dev, "Unable to locate VF from VF device\n");
+		return;
+	}
+
+	dev = ice_pf_to_dev(pf);
+
+	mutex_lock(&vf->cfg_lock);
+
+	vf->migration_enabled = false;
+
+	if (!list_empty(&vf->mig_tlvs)) {
+		struct ice_mig_tlv_entry *entry, *tmp;
+
+		dev_dbg(dev, "Freeing unused migration TLVs for VF %d\n",
+			vf->vf_id);
+
+		list_for_each_entry_safe(entry, tmp, &vf->mig_tlvs,
+					 list_entry) {
+			list_del(&entry->list_entry);
+			kfree(entry);
+		}
+	}
+
+	mutex_unlock(&vf->cfg_lock);
+
+	ice_put_vf(vf);
+}
+EXPORT_SYMBOL(ice_migration_uninit_dev);
+
+int ice_migration_suspend_dev(struct pci_dev *vf_dev, bool save_state)
+{
+	return -EOPNOTSUPP;
+}
+EXPORT_SYMBOL(ice_migration_suspend_dev);
+
+/**
+ * ice_migration_calculate_size - Calculate the size of the migration buffer
+ * @vf: pointer to the VF being migrated
+ *
+ * Calculate the total size required for all the TLVs used to form the
+ * migration data buffer. The TLVs containing migration data are already
+ * recorded and saved in the vf->mig_tlvs linked list. In addition to this, we
+ * need to account for the header data and the data-end marker TLV.
+ *
+ * Return: the size in bytes required to store the full migration payload.
+ */
+static size_t ice_migration_calculate_size(struct ice_vf *vf)
+{
+	struct ice_mig_tlv_entry *entry;
+	size_t tlv_sz, total_sz;
+
+	lockdep_assert_held(&vf->cfg_lock);
+
+	/* The migration data begins with a header TLV describing the format */
+	total_sz = struct_size_t(struct ice_migration_tlv, data,
+				 sizeof(struct ice_mig_tlv_header));
+
+	list_for_each_entry(entry, &vf->mig_tlvs, list_entry) {
+		tlv_sz = struct_size(&entry->tlv, data, entry->tlv.len);
+		total_sz = size_add(total_sz, tlv_sz);
+	}
+
+	/* The end of the data is signified by an empty TLV */
+	tlv_sz = struct_size_t(struct ice_migration_tlv, data, 0);
+	total_sz = size_add(total_sz, tlv_sz);
+
+	return total_sz;
+}
+
+/**
+ * ice_migration_get_required_size - Request migration payload buffer size
+ * @vf_dev: pointer to the VF PCI device
+ *
+ * Request the size required to serialize the VF migration payload. Used to
+ * calculate allocation size of the migration file.
+ *
+ * Return: the size in bytes required to store the full migration payload, or
+ * 0 if this VF is not ready to migrate.
+ */
+size_t ice_migration_get_required_size(struct pci_dev *vf_dev)
+{
+	struct ice_pf *pf = ice_vf_dev_to_pf(vf_dev);
+	size_t payload_size;
+	struct ice_vf *vf;
+
+	if (IS_ERR(pf)) {
+		dev_err(&vf_dev->dev, "Unable to locate PF from VF device, err=%pe\n",
+			pf);
+		return 0;
+	}
+
+	vf = ice_get_vf_by_dev(pf, vf_dev);
+	if (!vf) {
+		dev_err(&vf_dev->dev, "Unable to locate VF from VF device\n");
+		return 0;
+	}
+
+	mutex_lock(&vf->cfg_lock);
+
+	if (list_empty(&vf->mig_tlvs)) {
+		dev_warn(&vf_dev->dev, "VF %d is not ready to migrate\n",
+			 vf->vf_id);
+		payload_size = 0;
+	} else {
+		payload_size = ice_migration_calculate_size(vf);
+	}
+
+	mutex_unlock(&vf->cfg_lock);
+
+	return payload_size;
+}
+EXPORT_SYMBOL(ice_migration_get_required_size);
+
+/**
+ * ice_migration_insert_tlv_header - Insert TLV header into migration buffer
+ * @tlv: pointer to TLV in the migration buffer
+ *
+ * Fill in the TLV header describing the migration format.
+ *
+ * Return: the full struct_size of the TLV, used to move the migration buffer
+ *         pointer to the next entry.
+ */
+static size_t ice_migration_insert_tlv_header(struct ice_migration_tlv *tlv)
+{
+	struct ice_mig_tlv_header *tlv_header;
+
+	tlv->type = ice_mig_tlv_type(tlv_header);
+	tlv->len = sizeof(*tlv_header);
+	tlv_header = (typeof(tlv_header))tlv->data;
+
+	tlv_header->magic = ICE_MIG_MAGIC;
+	tlv_header->version = ICE_MIG_VERSION;
+	tlv_header->num_supported_tlvs = NUM_ICE_MIG_TLV;
+
+	return struct_size(tlv, data, tlv->len);
+}
+
+/**
+ * ice_migration_insert_tlv_end - Insert TLV marking end of migration data
+ * @tlv: pointer to TLV in the migration buffer
+ *
+ * Fill in the TLV marking end of the migration buffer data.
+ */
+static void ice_migration_insert_tlv_end(struct ice_migration_tlv *tlv)
+{
+	tlv->type = ICE_MIG_TLV_END;
+	tlv->len = 0;
+}
+
+/**
+ * ice_migration_save_devstate - Save device state to migration buffer
+ * @vf_dev: pointer to the VF PCI device
+ * @buf: pointer to VF msg in migration buffer
+ * @buf_sz: The size of the migration buffer.
+ *
+ * Serialize the saved device state to the migration buffer. It is expected
+ * that buf_sz is determined by calling ice_migration_get_required_size()
+ * ahead of time.
+ *
+ * Return: 0 for success, or a negative error code on failure.
+ */
+int ice_migration_save_devstate(struct pci_dev *vf_dev, void *buf,
+				size_t buf_sz)
+{
+	struct ice_pf *pf = ice_vf_dev_to_pf(vf_dev);
+	struct ice_mig_tlv_entry *entry, *tmp;
+	struct ice_vsi *vsi;
+	struct device *dev;
+	struct ice_vf *vf;
+	size_t total_sz;
+	int err = 0;
+
+	if (IS_ERR(pf))
+		return PTR_ERR(pf);
+
+	vf = ice_get_vf_by_dev(pf, vf_dev);
+	if (!vf) {
+		dev_err(&vf_dev->dev, "Unable to locate VF from VF device\n");
+		return -EINVAL;
+	}
+
+	dev = ice_pf_to_dev(pf);
+
+	dev_dbg(dev, "Serializing migration device state for VF %u\n",
+		vf->vf_id);
+
+	mutex_lock(&vf->cfg_lock);
+
+	vsi = ice_get_vf_vsi(vf);
+	if (!vsi) {
+		dev_err(dev, "VF %d VSI is NULL\n", vf->vf_id);
+		err = -EINVAL;
+		goto out_release_cfg_lock;
+	}
+
+	/* Make sure we have enough space */
+	total_sz = ice_migration_calculate_size(vf);
+	if (total_sz > buf_sz) {
+		dev_err(dev, "Insufficient buffer to store device state for VF %d. Need %zu bytes, but have only %zu bytes.\n",
+			vf->vf_id, total_sz, buf_sz);
+		err = -ENOBUFS;
+		goto out_release_cfg_lock;
+	}
+
+	dev_dbg(dev, "Saving migration data for VF %d. Total migration payload size is %zu bytes\n",
+		vf->vf_id, total_sz);
+
+	/* 1. Insert the TLV header describing the migration format */
+	buf += ice_migration_insert_tlv_header(buf);
+
+	/* 2. Insert the TLVs prepared by suspend */
+	list_for_each_entry_safe(entry, tmp, &vf->mig_tlvs, list_entry) {
+		size_t tlv_sz = struct_size(&entry->tlv, data, entry->tlv.len);
+
+		memcpy(buf, &entry->tlv, tlv_sz);
+		buf += tlv_sz;
+
+		list_del(&entry->list_entry);
+		kfree(entry);
+	}
+
+	/* 3. Insert TLV marking the end of the data */
+	ice_migration_insert_tlv_end(buf);
+
+out_release_cfg_lock:
+	mutex_unlock(&vf->cfg_lock);
+	ice_put_vf(vf);
+
+	return err;
+}
+EXPORT_SYMBOL(ice_migration_save_devstate);
+
+/**
+ * ice_migration_check_tlv_size - Validate size of next TLV in buffer
+ * @dev: device structure
+ * @tlv: pointer to the next TLV in migration buffer
+ * @sz_remaining: number of bytes left in migration buffer
+ *
+ * Check that the migration buffer has sufficient space to completely hold the
+ * TLV, and that its length is properly aligned.
+ *
+ * Note that the tlv variable points into the migration buffer. To avoid
+ * a read-overflow, special care is taken to validate the size of the buffer
+ * before accessing the contents of the tlv variable.
+ *
+ * Return: 0 if there is sufficient space for the entire TLV in the migration
+ *         buffer. -ENOSPC otherwise.
+ */
+static int ice_migration_check_tlv_size(struct device *dev,
+					const struct ice_migration_tlv *tlv,
+					size_t sz_remaining)
+{
+	/* Make sure we have enough space for the TLV */
+	if (sz_remaining < sizeof(*tlv)) {
+		dev_dbg(dev, "Not enough space in buffer for TLV header. Need %zu bytes, but only %zu bytes remain.\n",
+			sizeof(*tlv), sz_remaining);
+		return -ENOSPC;
+	}
+
+	sz_remaining -= sizeof(*tlv);
+
+	/* Data lengths must be 4-byte aligned to ensure TLV header positions
+	 * are always 4-byte aligned.
+	 */
+	if (tlv->len != ALIGN(tlv->len, 4)) {
+		dev_dbg(dev, "TLV of type %u has unaligned length of %u bytes\n",
+			tlv->type, tlv->len);
+		return -ENOSPC;
+	}
+
+	if (sz_remaining < tlv->len) {
+		dev_dbg(dev, "Not enough space in buffer for TLV of type %u, with length %u. Only %zu bytes remain.\n",
+			tlv->type, tlv->len, sz_remaining);
+		return -ENOSPC;
+	}
+
+	return 0;
+}
+
+/**
+ * ice_migration_validate_tlvs - Validate TLV data integrity and compatibility
+ * @dev: pointer to device
+ * @buf: pointer to device state buffer
+ * @buf_sz: size of buffer
+ *
+ * Ensure that the TLV data provided is valid, and matches the expected
+ * version and format.
+ *
+ * Return: 0 for success, negative for error
+ */
+static int
+ice_migration_validate_tlvs(struct device *dev, const void *buf, size_t buf_sz)
+{
+	const struct ice_mig_tlv_header *header;
+	const struct ice_migration_tlv *tlv;
+	size_t tlv_size;
+	int err;
+
+	tlv = buf;
+
+	dev_dbg(dev, "Validating TLVs in migration payload of size %zu\n",
+		buf_sz);
+
+	err = ice_migration_check_tlv_size(dev, tlv, buf_sz);
+	if (err)
+		return err;
+
+	if (tlv->type != ICE_MIG_TLV_HEADER) {
+		dev_dbg(dev, "First TLV in migration payload must be the header\n");
+		return -EBADMSG;
+	}
+
+	header = (typeof(header))tlv->data;
+
+	if (header->magic != ICE_MIG_MAGIC) {
+		dev_dbg(dev, "Got magic value 0x%08x, expected 0x%08x\n",
+			header->magic, ICE_MIG_MAGIC);
+		return -EPROTONOSUPPORT;
+	}
+
+	if (header->version != ICE_MIG_VERSION) {
+		dev_dbg(dev, "Got migration version %d, expected version %d\n",
+			header->version, ICE_MIG_VERSION);
+		return -EPROTONOSUPPORT;
+	}
+
+	/* Validate remaining TLVs */
+	do {
+		/* Move to next TLV */
+		tlv_size = struct_size(tlv, data, tlv->len);
+		buf_sz -= tlv_size;
+		tlv = (const void *)tlv + tlv_size;
+
+		/* Check buffer for space before dereferencing */
+		err = ice_migration_check_tlv_size(dev, tlv, buf_sz);
+		if (err)
+			return err;
+
+		/* Stop if we reach the end */
+		if (tlv->type == ICE_MIG_TLV_END)
+			break;
+
+		if (tlv->type >= NUM_ICE_MIG_TLV ||
+		    tlv->type >= header->num_supported_tlvs) {
+			dev_dbg(dev, "Unsupported TLV of type %d in migration payload\n",
+				tlv->type);
+			return -EPROTONOSUPPORT;
+		}
+
+		/* TODO: implement other validation? Check for compatibility
+		 * with queue sizes, vector counts, VLAN capabilities, etc?
+		 */
+	} while (buf_sz > 0);
+
+	return 0;
+}
+
+/**
+ * ice_migration_load_devstate - Load device state into the target VF
+ * @vf_dev: pointer to the VF PCI device
+ * @buf: pointer to device state buf in migration buffer
+ * @buf_sz: size of migration buffer
+ *
+ * Deserialize the migration buffer TLVs and program the target VF in the
+ * destination VM to match.
+ *
+ * Return: 0 on success, or e negative error code on failure.
+ */
+int ice_migration_load_devstate(struct pci_dev *vf_dev, const void *buf,
+				size_t buf_sz)
+{
+	struct ice_pf *pf = ice_vf_dev_to_pf(vf_dev);
+	const struct ice_migration_tlv *tlv;
+	struct ice_vsi *vsi;
+	struct device *dev;
+	struct ice_vf *vf;
+	int err;
+
+	if (!buf)
+		return -EINVAL;
+
+	if (IS_ERR(pf))
+		return PTR_ERR(pf);
+
+	dev = ice_pf_to_dev(pf);
+
+	dev_dbg(&vf_dev->dev, "Loading live migration state. Migration buffer is %zu bytes\n",
+		buf_sz);
+
+	err = ice_migration_validate_tlvs(dev, buf, buf_sz);
+	if (err)
+		return err;
+
+	vf = ice_get_vf_by_dev(pf, vf_dev);
+	if (!vf) {
+		dev_err(dev, "Unable to locate VF from VF device\n");
+		return -EINVAL;
+	}
+
+	mutex_lock(&vf->cfg_lock);
+
+	vsi = ice_get_vf_vsi(vf);
+	if (!vsi) {
+		dev_err(dev, "VF %d VSI is NULL\n", vf->vf_id);
+		err = -EINVAL;
+		goto err_release_cfg_lock;
+	}
+
+	/* Iterate over TLVs and process migration data */
+	tlv = buf;
+
+	do {
+		size_t tlv_size;
+
+		switch (tlv->type) {
+		case ICE_MIG_TLV_END:
+		case ICE_MIG_TLV_HEADER:
+			/* These are already handled above */
+			break;
+		default:
+			dev_dbg(dev, "Unexpected TLV %d in payload?\n",
+				tlv->type);
+			err = -EINVAL;
+		}
+
+		if (err) {
+			dev_dbg(dev, "Failed to load TLV data for TLV of type %d, err %d\n",
+				tlv->type, err);
+			goto err_release_cfg_lock;
+		}
+
+		tlv_size = struct_size(tlv, data, tlv->len);
+		tlv = (const void *)tlv + tlv_size;
+	} while (tlv->type != ICE_MIG_TLV_END);
+
+	mutex_unlock(&vf->cfg_lock);
+
+	ice_put_vf(vf);
+
+	return 0;
+
+err_release_cfg_lock:
+	mutex_unlock(&vf->cfg_lock);
+	ice_put_vf(vf);
+
+	return err;
+}
+EXPORT_SYMBOL(ice_migration_load_devstate);
diff --git a/drivers/net/ethernet/intel/ice/Makefile b/drivers/net/ethernet/intel/ice/Makefile
index eac45d7c0cf1..e52585af299e 100644
--- a/drivers/net/ethernet/intel/ice/Makefile
+++ b/drivers/net/ethernet/intel/ice/Makefile
@@ -62,3 +62,4 @@ ice-$(CONFIG_XDP_SOCKETS) += ice_xsk.o
 ice-$(CONFIG_ICE_SWITCHDEV) += ice_eswitch.o ice_eswitch_br.o
 ice-$(CONFIG_GNSS) += ice_gnss.o
 ice-$(CONFIG_ICE_HWMON) += ice_hwmon.o
+ice-$(CONFIG_ICE_VFIO_PCI) += virt/migration.o

-- 
2.51.0.rc1.197.g6d975e95c9d7


