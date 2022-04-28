Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66BB1513483
	for <lists+kvm@lfdr.de>; Thu, 28 Apr 2022 15:05:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346837AbiD1NJF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Apr 2022 09:09:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346803AbiD1NIz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Apr 2022 09:08:55 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADE798564D;
        Thu, 28 Apr 2022 06:05:40 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23SCTijj011198;
        Thu, 28 Apr 2022 13:05:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=WJW7LkDj7H45liKkCkRnyij+AegkzTHBoOyCkAu5ZOk=;
 b=DEH96GUKlaDta+gnzCdeEHF/2npfbYlFsYjG5mADcG9PKy1vQFjnbITQRxCxoXmYjXXl
 QwQNCprqlQJ3zcZXjQK1a1l4klvRVJXmI+OKifYQF7SgeJRD0h4Gjj8eVa7An2qTLW2M
 97ncV5fchHhGBom+2gjYlSaOCOtWdmFhPUOb1NecBzYJzHVhLOGF4IZeOb38EO7Ft/lg
 vEd0EnP0B86mOtN4VIagzz8DQ3w34cH0tAole1cmOHmvEOgr//EZpI+QH0je/ONgC6NJ
 lSBXXn4PWbJdqcFhbFugqlDcb6FKSVdOMx/bX8cJK2lSup5NpOBAHdW/u9xhVpIjqBfW XQ== 
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fqtyw0rjw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Apr 2022 13:05:40 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23SCwfLT002506;
        Thu, 28 Apr 2022 13:05:38 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma01fra.de.ibm.com with ESMTP id 3fm938wxxk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Apr 2022 13:05:37 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23SD5jEb15663428
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Apr 2022 13:05:45 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8087242041;
        Thu, 28 Apr 2022 13:05:34 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 03ACF4203F;
        Thu, 28 Apr 2022 13:05:34 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 28 Apr 2022 13:05:33 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, borntraeger@linux.ibm.com,
        imbrenda@linux.ibm.com
Subject: [PATCH 9/9] Documentation/virt/kvm/api.rst: Add protvirt dump/info api descriptions
Date:   Thu, 28 Apr 2022 13:01:02 +0000
Message-Id: <20220428130102.230790-10-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220428130102.230790-1-frankja@linux.ibm.com>
References: <20220428130102.230790-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 4Ybwl2EshRQkwllcL0wyPYRiXvQU11hl
X-Proofpoint-ORIG-GUID: 4Ybwl2EshRQkwllcL0wyPYRiXvQU11hl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-28_01,2022-04-28_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 phishscore=0 priorityscore=1501 malwarescore=0 impostorscore=0
 adultscore=0 mlxscore=0 mlxlogscore=999 clxscore=1015 suspectscore=0
 bulkscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204280081
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Time to add the dump API changes to the api documentation file.
Also some minor cleanup.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 Documentation/virt/kvm/api.rst | 152 ++++++++++++++++++++++++++++++++-
 1 file changed, 150 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 85c7abc51af5..70222f46ad22 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -5061,7 +5061,7 @@ into ESA mode. This reset is a superset of the initial reset.
 	__u32 reserved[3];
   };
 
-cmd values:
+**cmd values:**
 
 KVM_PV_ENABLE
   Allocate memory and register the VM with the Ultravisor, thereby
@@ -5077,7 +5077,6 @@ KVM_PV_ENABLE
   =====      =============================
 
 KVM_PV_DISABLE
-
   Deregister the VM from the Ultravisor and reclaim the memory that
   had been donated to the Ultravisor, making it usable by the kernel
   again.  All registered VCPUs are converted back to non-protected
@@ -5094,6 +5093,114 @@ KVM_PV_VM_VERIFY
   Verify the integrity of the unpacked image. Only if this succeeds,
   KVM is allowed to start protected VCPUs.
 
+KVM_PV_INFO
+  :Capability: KVM_CAP_S390_PROTECTED_DUMP
+
+  Presents an API that provides Ultravisor related data to userspace
+  via subcommands. len_max is the size of the user space buffer,
+  len_written is KVM's indication of how much bytes of that buffer
+  were actually written to. len_written can be used to determine the
+  valid fields if more response fields are added in the future.
+
+  ::
+     enum pv_cmd_info_id {
+        KVM_PV_INFO_VM,
+        KVM_PV_INFO_DUMP,
+     };
+
+     struct kvm_s390_pv_info_header {
+        __u32 id;
+        __u32 len_max;
+        __u32 len_written;
+        __u32 reserved;
+     };
+
+     struct kvm_s390_pv_info {
+        struct kvm_s390_pv_info_header header;
+        struct kvm_s390_pv_info_dump dump;
+	struct kvm_s390_pv_info_vm vm;
+     };
+
+**subcommands:**
+
+  KVM_PV_INFO_VM
+    This subcommand provides basic Ultravisor information for PV
+    hosts. These values are likely also exported as files in the sysfs
+    firmware UV query interface but they are more easily available to
+    programs in this API.
+
+    The installed calls and feature_indication members provide the
+    installed UV calls and the UV's other feature indications.
+
+    The max_* members provide information about the maximum number of PV
+    vcpus, PV guests and PV guest memory size.
+
+    ::
+
+      struct kvm_s390_pv_info_vm {
+        __u64 inst_calls_list[4];
+        __u64 max_cpus;
+        __u64 max_guests;
+        __u64 max_guest_addr;
+        __u64 feature_indication;
+      };
+
+
+  KVM_PV_INFO_DUMP
+    This subcommand provides information related to dumping PV guests.
+
+    ::
+
+      struct kvm_s390_pv_info_dump {
+        __u64 dump_cpu_buffer_len;
+        __u64 dump_config_mem_buffer_per_1m;
+        __u64 dump_config_finalize_len;
+      };
+
+KVM_PV_DUMP
+  :Capability: KVM_CAP_S390_PROTECTED_DUMP
+
+  Presents an API that provides calls which facilitate dumping a
+  protected VM.
+
+  ::
+
+    struct kvm_s390_pv_dmp {
+      __u64 subcmd;
+      __u64 buff_addr;
+      __u64 buff_len;
+      __u64 gaddr;		/* For dump storage state */
+    };
+
+  **subcommands:**
+
+  KVM_PV_DUMP_INIT
+    Initializes the dump process of a protected VM. If this call does
+    not succeed all other subcommands will fail with -EINVAL. This
+    subcommand will return -EINVAL if a dump process has not yet been
+    completed.
+
+    Not all PV vms can be dumped, the owner needs to set `dump
+    allowed` PCF bit 34 in the SE header to allow dumping.
+
+  KVM_PV_DUMP_CONFIG_STOR_STATE
+    Stores `buff_len` bytes of tweak component values starting with
+    the 1MB block specified by the absolute guest address
+    (`gaddr`). `buff_len` needs to be `conf_dump_storage_state_len`
+    aligned and at least >= the `conf_dump_storage_state_len` value
+    provided by the dump uv_info data.
+
+  KVM_PV_DUMP_COMPLETE
+    If the subcommand succeeds it completes the dump process and lets
+    KVM_PV_DUMP_INIT be called again.
+
+    On success `conf_dump_finalize_len` bytes of completion data will be
+    stored to the `buff_addr`. The completion data contains a key
+    derivation seed, IV, tweak nonce and encryption keys as well as an
+    authentication tag all of which are needed to decrypt the dump at a
+    later time.
+
+
 4.126 KVM_X86_SET_MSR_FILTER
 ----------------------------
 
@@ -5646,6 +5753,32 @@ The offsets of the state save areas in struct kvm_xsave follow the contents
 of CPUID leaf 0xD on the host.
 
 
+4.135 KVM_S390_PV_CPU_COMMAND
+-----------------------------
+
+:Capability: KVM_CAP_S390_PROTECTED_DUMP
+:Architectures: s390
+:Type: vcpu ioctl
+:Parameters: none
+:Returns: 0 on success, < 0 on error
+
+This ioctl closely mirrors `KVM_S390_PV_COMMAND` but handles requests
+for vcpus. It re-uses the kvm_s390_pv_dmp struct and hence also shares
+the command ids.
+
+**command:**
+
+KVM_PV_DUMP
+  Presents an API that provides calls which facilitate dumping a vcpu
+  of a protected VM.
+
+**subcommand:**
+
+KVM_PV_DUMP_CPU
+  Provides encrypted dump data like register values.
+  The length of the returned data is provided by uv_info.guest_cpu_stor_len.
+
+
 5. The kvm_run structure
 ========================
 
@@ -7724,6 +7857,21 @@ At this time, KVM_PMU_CAP_DISABLE is the only capability.  Setting
 this capability will disable PMU virtualization for that VM.  Usermode
 should adjust CPUID leaf 0xA to reflect that the PMU is disabled.
 
+
+8.36 KVM_CAP_S390_PROTECTED_DUMP
+--------------------------------
+
+:Capability: KVM_CAP_S390_PROTECTED_DUMP
+:Architectures: s390
+:Type: vm
+
+This capability indicates that KVM and the Ultravisor support dumping
+PV guests. The `KVM_PV_DUMP` command is available for the
+`KVM_S390_PV_COMMAND` ioctl and the `KVM_PV_INFO` command provides
+dump related UV data. Also the vcpu ioctl `KVM_S390_PV_CPU_COMMAND` is
+available and supports the `KVM_PV_DUMP_CPU` subcommand.
+
+
 9. Known KVM API problems
 =========================
 
-- 
2.32.0

