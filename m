Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E24DD646C20
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 10:45:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230296AbiLHJpE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 04:45:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230243AbiLHJo5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 04:44:57 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72C5E6F0FE
        for <kvm@vger.kernel.org>; Thu,  8 Dec 2022 01:44:54 -0800 (PST)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B89Sut3030561;
        Thu, 8 Dec 2022 09:44:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=S2aNrKrNNfRw7fXFnytQVWWPiOQA7nMgqNrhmxBah2I=;
 b=P0Rbv/z5dBcVjY2/KFLfbsMo4ij7VjEYXL9hUyW5baUn0+i3vEXzj+EhCds/EInREcQh
 MS1kptQ7H3vNyYo2H2k+/tRBoAjt32ajh9xgUbVV/fUk2L0u5Fwwpbqs8tmot8iKCCbN
 ru4fBh+ahYtyWntAV63b65Rkxc3nQ42vAeqVbiK5EjIBDH8Y62ncaS+9HLrB9S+b11cv
 EC3dbI+2/5zLD5foQ6hQExBtM35T04bZEGc/8cIb3ZElQPeU6c6ZoCf2QbXVDZ+VBfA7
 8gwytKmLHcN4wHPEHLPzea5xQFVplV7taf+u9BHNqX+kN0PYQvNU7RJXFFhKHVvEQ6x2 YA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mbdb40cng-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 08 Dec 2022 09:44:42 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2B89bIwT002509;
        Thu, 8 Dec 2022 09:44:41 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mbdb40cme-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 08 Dec 2022 09:44:41 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2B88tiMC016423;
        Thu, 8 Dec 2022 09:44:39 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3m9m5y46ak-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 08 Dec 2022 09:44:39 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2B89iZWF42992018
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 8 Dec 2022 09:44:35 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 585C120049;
        Thu,  8 Dec 2022 09:44:35 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E4D632004B;
        Thu,  8 Dec 2022 09:44:34 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com (unknown [9.152.222.245])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu,  8 Dec 2022 09:44:34 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, scgl@linux.ibm.com,
        frankja@linux.ibm.com, berrange@redhat.com, clg@kaod.org
Subject: [PATCH v13 4/7] s390x/cpu_topology: CPU topology migration
Date:   Thu,  8 Dec 2022 10:44:29 +0100
Message-Id: <20221208094432.9732-5-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221208094432.9732-1-pmorel@linux.ibm.com>
References: <20221208094432.9732-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Mqa_5pckH4tNmhdSxrw0csx-yS0JTb2S
X-Proofpoint-ORIG-GUID: QRh0O0-U2s4W-179ysnIkGaA443Lec0y
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-08_04,2022-12-07_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=999
 clxscore=1015 malwarescore=0 priorityscore=1501 mlxscore=0 bulkscore=0
 phishscore=0 spamscore=0 impostorscore=0 suspectscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2212080077
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
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
 target/s390x/cpu.h        |  1 +
 hw/s390x/cpu-topology.c   | 49 +++++++++++++++++++++++++++++++++++++++
 target/s390x/cpu-sysemu.c |  8 +++++++
 3 files changed, 58 insertions(+)

diff --git a/target/s390x/cpu.h b/target/s390x/cpu.h
index bc1a7de932..284c708a6c 100644
--- a/target/s390x/cpu.h
+++ b/target/s390x/cpu.h
@@ -854,6 +854,7 @@ void s390_do_cpu_set_diag318(CPUState *cs, run_on_cpu_data arg);
 int s390_assign_subch_ioeventfd(EventNotifier *notifier, uint32_t sch_id,
                                 int vq, bool assign);
 void s390_cpu_topology_reset(void);
+int s390_cpu_topology_mtcr_set(void);
 #ifndef CONFIG_USER_ONLY
 unsigned int s390_cpu_set_state(uint8_t cpu_state, S390CPU *cpu);
 #else
diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
index f54afcf550..8a2fe041d4 100644
--- a/hw/s390x/cpu-topology.c
+++ b/hw/s390x/cpu-topology.c
@@ -18,6 +18,7 @@
 #include "target/s390x/cpu.h"
 #include "hw/s390x/s390-virtio-ccw.h"
 #include "hw/s390x/cpu-topology.h"
+#include "migration/vmstate.h"
 
 /**
  * s390_has_topology
@@ -129,6 +130,53 @@ static void s390_topology_reset(DeviceState *dev)
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
+    int ret;
+
+    /* We do not support CPU Topology, all is good */
+    if (!s390_has_topology()) {
+        return 0;
+    }
+
+    /* We support CPU Topology, set the MTCR unconditionally */
+    ret = s390_cpu_topology_mtcr_set();
+    if (ret) {
+        error_report("Failed to set MTCR: %s", strerror(-ret));
+    }
+    return ret;
+}
+
+/**
+ * cpu_topology_needed:
+ * @opaque: The pointer to the S390Topology
+ *
+ * We always need to know if source and destination use the topology.
+ */
+static bool cpu_topology_needed(void *opaque)
+{
+    return s390_has_topology();
+}
+
+const VMStateDescription vmstate_cpu_topology = {
+    .name = "cpu_topology",
+    .version_id = 1,
+    .post_load = cpu_topology_postload,
+    .minimum_version_id = 1,
+    .needed = cpu_topology_needed,
+};
+
 /**
  * topology_class_init:
  * @oc: Object class
@@ -145,6 +193,7 @@ static void topology_class_init(ObjectClass *oc, void *data)
     device_class_set_props(dc, s390_topology_properties);
     set_bit(DEVICE_CATEGORY_MISC, dc->categories);
     dc->reset = s390_topology_reset;
+    dc->vmsd = &vmstate_cpu_topology;
 }
 
 static const TypeInfo cpu_topology_info = {
diff --git a/target/s390x/cpu-sysemu.c b/target/s390x/cpu-sysemu.c
index e27864c5f5..a8e3e6219d 100644
--- a/target/s390x/cpu-sysemu.c
+++ b/target/s390x/cpu-sysemu.c
@@ -319,3 +319,11 @@ void s390_cpu_topology_reset(void)
         }
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
-- 
2.31.1

