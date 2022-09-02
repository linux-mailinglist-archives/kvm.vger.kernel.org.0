Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B0795AA937
	for <lists+kvm@lfdr.de>; Fri,  2 Sep 2022 09:56:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235548AbiIBH40 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Sep 2022 03:56:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235566AbiIBH4H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Sep 2022 03:56:07 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DC1D33E1C
        for <kvm@vger.kernel.org>; Fri,  2 Sep 2022 00:55:54 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2827XXsm009694;
        Fri, 2 Sep 2022 07:55:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=lR6zCmGc/rEdBmmBf8NeNWiiu3v5Qo4h4h5zTxKWRhI=;
 b=Sj5JW2/9l47R+DId5vUwuiaVpXSnKHORCnlXFzDjRJTwAPzmnv3y5zroc82jxl5YT1Zl
 0VwgK1XVFmPGpIDPE19mtMgNEvk9Lxd4Jkcc84iWSZameNIDAnRqmimJkXNnXiECNLEB
 RBcSgdbV7ZDaZdAe7XYNGNXyacw3615VxJN1iX1b7cPFaVWnTrWj7jFkHu5ricaqzef4
 eBuNQ8TBfO/0auA/GHjkoqwB3Gn99tWuZ4yXD8HSaebBAhLOkE6Zzj8LBSaPMzNmqCst
 AUtUBu5bhiB2iCTgVz6crZq1hGkCGTRMUPgLOsGdZpln/SLeJ76z6wwJcWBTw+awMOSm vQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jbbkmcvgf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Sep 2022 07:55:45 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2827ls0v030002;
        Fri, 2 Sep 2022 07:55:45 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jbbkmcvfn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Sep 2022 07:55:45 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2827oH77024527;
        Fri, 2 Sep 2022 07:55:43 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06fra.de.ibm.com with ESMTP id 3j7ahhwqxy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Sep 2022 07:55:42 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2827tddw28311844
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 2 Sep 2022 07:55:39 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B8E3C11C04A;
        Fri,  2 Sep 2022 07:55:39 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EB65F11C04C;
        Fri,  2 Sep 2022 07:55:38 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.171.69.137])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  2 Sep 2022 07:55:38 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com
Subject: [PATCH v9 07/10] s390x/cpu_topology: CPU topology migration
Date:   Fri,  2 Sep 2022 09:55:28 +0200
Message-Id: <20220902075531.188916-8-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220902075531.188916-1-pmorel@linux.ibm.com>
References: <20220902075531.188916-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: hCdZCqjwb6aKo4yNynOBAlJ2IXpcCpKw
X-Proofpoint-GUID: 4NM2CsKrGgXBAI81l0i0bK6KMC8jesG5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-09-01_12,2022-08-31_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 phishscore=0 priorityscore=1501 mlxlogscore=999 impostorscore=0
 bulkscore=0 malwarescore=0 clxscore=1015 adultscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209020034
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The migration can only take place if both source and destination
of the migration both use or both do not use the CPU topology
facility.

We indicate a change in topology during migration postload for the
case the topology changed between source and destination.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 hw/s390x/cpu-topology.c         | 79 +++++++++++++++++++++++++++++++++
 include/hw/s390x/cpu-topology.h |  1 +
 target/s390x/cpu-sysemu.c       |  8 ++++
 target/s390x/cpu.h              |  1 +
 4 files changed, 89 insertions(+)

diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
index 6098d6ea1f..b6bf839e40 100644
--- a/hw/s390x/cpu-topology.c
+++ b/hw/s390x/cpu-topology.c
@@ -19,6 +19,7 @@
 #include "target/s390x/cpu.h"
 #include "hw/s390x/s390-virtio-ccw.h"
 #include "hw/s390x/cpu-topology.h"
+#include "migration/vmstate.h"
 
 S390Topology *s390_get_topology(void)
 {
@@ -132,6 +133,83 @@ static void s390_topology_reset(DeviceState *dev)
     s390_cpu_topology_reset();
 }
 
+/**
+ * cpu_topology_postload
+ * @opaque: a pointer to the S390Topology
+ * @version_id: version identifier
+ *
+ * We check that the topology is used or is not used
+ * on both side identically.
+ *
+ * If the topology is in use we set the Modified Topology Change Report
+ * on the destination host.
+ */
+static int cpu_topology_postload(void *opaque, int version_id)
+{
+    S390Topology *topo = opaque;
+    int ret;
+
+    if (topo->topology_needed != s390_has_feat(S390_FEAT_CONFIGURATION_TOPOLOGY)) {
+        if (topo->topology_needed) {
+            error_report("Topology facility is needed in destination");
+        } else {
+            error_report("Topology facility can not be used in destination");
+        }
+        return -EINVAL;
+    }
+
+    /* We do not support CPU Topology, all is good */
+    if (!s390_has_feat(S390_FEAT_CONFIGURATION_TOPOLOGY)) {
+        return 0;
+    }
+
+    /* We support CPU Topology, set the MTCR */
+    ret = s390_cpu_topology_mtcr_set();
+    if (ret) {
+        error_report("Failed to set MTCR: %s", strerror(-ret));
+    }
+    return ret;
+}
+
+/**
+ * cpu_topology_presave:
+ * @opaque: The pointer to the S390Topology
+ *
+ * Save the usage of the CPU Topology in the VM State.
+ */
+static int cpu_topology_presave(void *opaque)
+{
+    S390Topology *topo = opaque;
+
+    topo->topology_needed = s390_has_feat(S390_FEAT_CONFIGURATION_TOPOLOGY);
+    return 0;
+}
+
+/**
+ * cpu_topology_needed:
+ * @opaque: The pointer to the S390Topology
+ *
+ * If we use the CPU Topology on the source it will be needed on the destination.
+ */
+static bool cpu_topology_needed(void *opaque)
+{
+    return s390_has_feat(S390_FEAT_CONFIGURATION_TOPOLOGY);
+}
+
+
+const VMStateDescription vmstate_cpu_topology = {
+    .name = "cpu_topology",
+    .version_id = 1,
+    .post_load = cpu_topology_postload,
+    .pre_save = cpu_topology_presave,
+    .minimum_version_id = 1,
+    .needed = cpu_topology_needed,
+    .fields = (VMStateField[]) {
+        VMSTATE_BOOL(topology_needed, S390Topology),
+        VMSTATE_END_OF_LIST()
+    }
+};
+
 /**
  * topology_class_init:
  * @oc: Object class
@@ -146,6 +224,7 @@ static void topology_class_init(ObjectClass *oc, void *data)
     dc->realize = s390_topology_realize;
     set_bit(DEVICE_CATEGORY_MISC, dc->categories);
     dc->reset = s390_topology_reset;
+    dc->vmsd = &vmstate_cpu_topology;
 }
 
 static const TypeInfo cpu_topology_info = {
diff --git a/include/hw/s390x/cpu-topology.h b/include/hw/s390x/cpu-topology.h
index 4f8ac39ca0..a15567baca 100644
--- a/include/hw/s390x/cpu-topology.h
+++ b/include/hw/s390x/cpu-topology.h
@@ -29,6 +29,7 @@ typedef struct S390TopoTLE {
 
 struct S390Topology {
     SysBusDevice parent_obj;
+    bool topology_needed;
     int total_books;
     int total_sockets;
     int drawers;
diff --git a/target/s390x/cpu-sysemu.c b/target/s390x/cpu-sysemu.c
index 707c0b658c..78cb11c0f8 100644
--- a/target/s390x/cpu-sysemu.c
+++ b/target/s390x/cpu-sysemu.c
@@ -313,3 +313,11 @@ void s390_cpu_topology_reset(void)
         kvm_s390_topology_set_mtcr(0);
     }
 }
+
+int s390_cpu_topology_mtcr_set(void)
+{
+    if (kvm_enabled()) {
+        return kvm_s390_topology_set_mtcr(1);
+    }
+    return -ENOENT;
+}
diff --git a/target/s390x/cpu.h b/target/s390x/cpu.h
index cff5cc0415..0eb2d219d3 100644
--- a/target/s390x/cpu.h
+++ b/target/s390x/cpu.h
@@ -827,6 +827,7 @@ void s390_do_cpu_set_diag318(CPUState *cs, run_on_cpu_data arg);
 int s390_assign_subch_ioeventfd(EventNotifier *notifier, uint32_t sch_id,
                                 int vq, bool assign);
 void s390_cpu_topology_reset(void);
+int s390_cpu_topology_mtcr_set(void);
 #ifndef CONFIG_USER_ONLY
 unsigned int s390_cpu_set_state(uint8_t cpu_state, S390CPU *cpu);
 #else
-- 
2.31.1

