Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04BB5508773
	for <lists+kvm@lfdr.de>; Wed, 20 Apr 2022 13:55:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378341AbiDTL5k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Apr 2022 07:57:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378302AbiDTL5b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Apr 2022 07:57:31 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2028D3F301
        for <kvm@vger.kernel.org>; Wed, 20 Apr 2022 04:54:45 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23K9OT43005868;
        Wed, 20 Apr 2022 11:54:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=4Da+pz/YKEZ4/GZNLdwar1ZzM65oU3Pr4zDNbWGXWyQ=;
 b=XxQmf+SZb/YQRCFEkUsWJICTMu/tvoqfVLOaTC4eLOHk3vKxx61FbCUYrTl5P16AifAq
 qd8GPVO8JaOyImdfMSO1+8v1BCDOBdtJZ1+lQxVfNSOVgwueyJLL1sp98MT7Xsglf41g
 ZYeyFRsWD/5yaHzoHFbuLffD50VjQE8fwHmZVq3Qmx2CGHU2JQQPwo2k/V/M0jCONGHL
 wsXO0UoY4tjPtg+J89rTZX2ZR2eeDZ3W7EaqQbCqh/LpsQXASEdpx5aOl2Z0kY6x6Zew
 WZEq2BN8w2csM2yWrWQT694hTvOdUbW0hNwxroJfOew4W6uqzwrqN5WkQHjUVceYHdp8 Ww== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fg7rg18xn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Apr 2022 11:54:41 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23KB1drK034044;
        Wed, 20 Apr 2022 11:54:40 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fg7rg18x9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Apr 2022 11:54:40 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23KBs1YU021711;
        Wed, 20 Apr 2022 11:54:38 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma02fra.de.ibm.com with ESMTP id 3fgu6u3ckg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Apr 2022 11:54:38 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23KBsZjv47579464
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Apr 2022 11:54:35 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 401F4AE057;
        Wed, 20 Apr 2022 11:54:35 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5A261AE045;
        Wed, 20 Apr 2022 11:54:34 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.171.58.217])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 20 Apr 2022 11:54:34 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, philmd@redhat.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        frankja@linux.ibm.com
Subject: [PATCH v7 06/13] s390x: topology: Adding books to STSI
Date:   Wed, 20 Apr 2022 13:57:38 +0200
Message-Id: <20220420115745.13696-7-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220420115745.13696-1-pmorel@linux.ibm.com>
References: <20220420115745.13696-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: PEKh-X3Go87aZg0eeZGRRhCa3IbthtYp
X-Proofpoint-ORIG-GUID: rqNfBzhNbOncBj65qNHMBjk8NFRQZedE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-20_02,2022-04-20_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 malwarescore=0 phishscore=0 clxscore=1015 bulkscore=0
 spamscore=0 adultscore=0 mlxlogscore=999 mlxscore=0 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204200071
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's add STSI support for the container level 3, books,
and provide the information back to the guest.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 hw/s390x/cpu-topology.c         | 147 +++++++++++++++++++++++++++++---
 include/hw/s390x/cpu-topology.h |  20 ++++-
 include/hw/s390x/sclp.h         |   1 +
 target/s390x/cpu_topology.c     |  53 +++++++++---
 4 files changed, 194 insertions(+), 27 deletions(-)

diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
index 74e04fd68e..4705a2af96 100644
--- a/hw/s390x/cpu-topology.c
+++ b/hw/s390x/cpu-topology.c
@@ -61,6 +61,26 @@ static S390TopologySocket *s390_create_socket(S390TopologyBook *book, int id)
     return socket;
 }
 
+static S390TopologyBook *s390_create_book(S390TopologyDrawer *drawer, int id)
+{
+    DeviceState *dev;
+    S390TopologyBook *book;
+    const MachineState *ms = MACHINE(qdev_get_machine());
+
+    if (drawer->bus->num_children >= ms->smp.books) {
+        return NULL;
+    }
+
+    dev = qdev_new(TYPE_S390_TOPOLOGY_BOOK);
+    qdev_realize_and_unref(dev, drawer->bus, &error_fatal);
+
+    book = S390_TOPOLOGY_BOOK(dev);
+    book->book_id = id;
+    drawer->cnt++;
+
+    return book;
+}
+
 /*
  * s390_get_cores:
  * @socket: the socket to search into
@@ -110,6 +130,31 @@ static S390TopologySocket *s390_get_socket(S390TopologyBook *book,
     return s390_create_socket(book, socket_id);
 }
 
+/*
+ * s390_get_book:
+ * @drawer: The drawer to search into
+ * @book_id: the identifier of the book to search for
+ *
+ * returns a pointer to a S390TopologySocket structure within a drawer having
+ * the specified book_id.
+ * First search if the drawer is already containing the S390TopologySocket
+ * structure and if not create one with this book_id.
+ */
+static S390TopologyBook *s390_get_book(S390TopologyDrawer *drawer,
+                                       int book_id)
+{
+    S390TopologyBook *book;
+    BusChild *kid;
+
+    QTAILQ_FOREACH(kid, &drawer->bus->children, sibling) {
+        book = S390_TOPOLOGY_BOOK(kid->child);
+        if (book->book_id == book_id) {
+            return book;
+        }
+    }
+    return s390_create_book(drawer, book_id);
+}
+
 /*
  * s390_topology_new_cpu:
  * @core_id: the core ID is machine wide
@@ -124,16 +169,21 @@ static S390TopologySocket *s390_get_socket(S390TopologyBook *book,
 void s390_topology_new_cpu(int core_id)
 {
     const MachineState *ms = MACHINE(qdev_get_machine());
+    S390TopologyDrawer *drawer;
     S390TopologyBook *book;
     S390TopologySocket *socket;
     S390TopologyCores *cores;
     int origin, bit;
     int nb_cores_per_socket;
+    int nb_cores_per_book;
 
-    book = s390_get_topology();
+    drawer = s390_get_topology();
 
     /* Cores for the S390 topology are cores and threads of the QEMU topology */
     nb_cores_per_socket = ms->smp.cores * ms->smp.threads;
+    nb_cores_per_book = ms->smp.sockets * nb_cores_per_socket;
+
+    book = s390_get_book(drawer, core_id / nb_cores_per_book);
     socket = s390_get_socket(book, core_id / nb_cores_per_socket);
 
     /*
@@ -166,23 +216,23 @@ void s390_topology_setup(MachineState *ms)
     DeviceState *dev;
 
     /* Create BOOK bridge device */
-    dev = qdev_new(TYPE_S390_TOPOLOGY_BOOK);
+    dev = qdev_new(TYPE_S390_TOPOLOGY_DRAWER);
     object_property_add_child(qdev_get_machine(),
-                              TYPE_S390_TOPOLOGY_BOOK, OBJECT(dev));
+                              TYPE_S390_TOPOLOGY_DRAWER, OBJECT(dev));
     sysbus_realize_and_unref(SYS_BUS_DEVICE(dev), &error_fatal);
 }
 
-S390TopologyBook *s390_get_topology(void)
+S390TopologyDrawer *s390_get_topology(void)
 {
-    static S390TopologyBook *book;
+    static S390TopologyDrawer *drawer;
 
-    if (!book) {
-        book = S390_TOPOLOGY_BOOK(
-            object_resolve_path(TYPE_S390_TOPOLOGY_BOOK, NULL));
-        assert(book != NULL);
+    if (!drawer) {
+        drawer = S390_TOPOLOGY_DRAWER(object_resolve_path(
+                                      TYPE_S390_TOPOLOGY_DRAWER, NULL));
+        assert(drawer != NULL);
     }
 
-    return book;
+    return drawer;
 }
 
 /* --- CORES Definitions --- */
@@ -333,12 +383,13 @@ static void book_class_init(ObjectClass *oc, void *data)
     hc->unplug = qdev_simple_device_unplug_cb;
     set_bit(DEVICE_CATEGORY_BRIDGE, dc->categories);
     dc->realize = s390_book_device_realize;
+    dc->bus_type = TYPE_S390_TOPOLOGY_DRAWER_BUS;
     dc->desc = "topology book";
 }
 
 static const TypeInfo book_info = {
     .name          = TYPE_S390_TOPOLOGY_BOOK,
-    .parent        = TYPE_SYS_BUS_DEVICE,
+    .parent        = TYPE_DEVICE,
     .instance_size = sizeof(S390TopologyBook),
     .class_init    = book_class_init,
     .interfaces = (InterfaceInfo[]) {
@@ -347,6 +398,78 @@ static const TypeInfo book_info = {
     }
 };
 
+/* --- DRAWER Definitions --- */
+static Property s390_topology_drawer_properties[] = {
+    DEFINE_PROP_UINT8("drawer_id", S390TopologyDrawer, drawer_id, 0),
+    DEFINE_PROP_END_OF_LIST(),
+};
+
+static char *drawer_bus_get_dev_path(DeviceState *dev)
+{
+    S390TopologyDrawer *drawer = S390_TOPOLOGY_DRAWER(dev);
+    DeviceState *node = dev->parent_bus->parent;
+    char *id = qdev_get_dev_path(node);
+    char *ret;
+
+    if (id) {
+        ret = g_strdup_printf("%s:%02d", id, drawer->drawer_id);
+        g_free(id);
+    } else {
+        ret = g_malloc(6);
+        snprintf(ret, 6, "_:%02d", drawer->drawer_id);
+    }
+
+    return ret;
+}
+
+static void drawer_bus_class_init(ObjectClass *oc, void *data)
+{
+    BusClass *k = BUS_CLASS(oc);
+
+    k->get_dev_path = drawer_bus_get_dev_path;
+    k->max_dev = S390_MAX_DRAWERS;
+}
+
+static const TypeInfo drawer_bus_info = {
+    .name = TYPE_S390_TOPOLOGY_DRAWER_BUS,
+    .parent = TYPE_BUS,
+    .instance_size = 0,
+    .class_init = drawer_bus_class_init,
+};
+
+static void s390_drawer_device_realize(DeviceState *dev, Error **errp)
+{
+    S390TopologyDrawer *drawer = S390_TOPOLOGY_DRAWER(dev);
+    BusState *bus;
+
+    bus = qbus_new(TYPE_S390_TOPOLOGY_DRAWER_BUS, dev,
+                   TYPE_S390_TOPOLOGY_DRAWER_BUS);
+    qbus_set_hotplug_handler(bus, OBJECT(dev));
+    drawer->bus = bus;
+}
+
+static void drawer_class_init(ObjectClass *oc, void *data)
+{
+    DeviceClass *dc = DEVICE_CLASS(oc);
+    HotplugHandlerClass *hc = HOTPLUG_HANDLER_CLASS(oc);
+
+    hc->unplug = qdev_simple_device_unplug_cb;
+    set_bit(DEVICE_CATEGORY_BRIDGE, dc->categories);
+    dc->realize = s390_drawer_device_realize;
+    device_class_set_props(dc, s390_topology_drawer_properties);
+    dc->desc = "topology drawer";
+}
+
+static const TypeInfo drawer_info = {
+    .name          = TYPE_S390_TOPOLOGY_DRAWER,
+    .parent        = TYPE_SYS_BUS_DEVICE,
+    .instance_size = sizeof(S390TopologyDrawer),
+    .class_init    = drawer_class_init,
+    .interfaces = (InterfaceInfo[]) {
+        { TYPE_HOTPLUG_HANDLER },
+        { }
+    }
+};
 static void topology_register(void)
 {
     type_register_static(&cpu_cores_info);
@@ -354,6 +477,8 @@ static void topology_register(void)
     type_register_static(&socket_info);
     type_register_static(&book_bus_info);
     type_register_static(&book_info);
+    type_register_static(&drawer_bus_info);
+    type_register_static(&drawer_info);
 }
 
 type_init(topology_register);
diff --git a/include/hw/s390x/cpu-topology.h b/include/hw/s390x/cpu-topology.h
index e6e013a8b8..78017c3d78 100644
--- a/include/hw/s390x/cpu-topology.h
+++ b/include/hw/s390x/cpu-topology.h
@@ -56,18 +56,30 @@ OBJECT_DECLARE_SIMPLE_TYPE(S390TopologySocket, S390_TOPOLOGY_SOCKET)
 #define TYPE_S390_TOPOLOGY_BOOK "topology book"
 #define TYPE_S390_TOPOLOGY_BOOK_BUS "book-bus"
 struct S390TopologyBook {
-    SysBusDevice parent_obj;
+    DeviceState parent_obj;
     BusState *bus;
     uint8_t book_id;
     int cnt;
 };
 typedef struct S390TopologyBook S390TopologyBook;
 OBJECT_DECLARE_SIMPLE_TYPE(S390TopologyBook, S390_TOPOLOGY_BOOK)
-#define S390_MAX_BOOKS 1
+#define S390_MAX_BOOKS 4
+
+#define TYPE_S390_TOPOLOGY_DRAWER "topology drawer"
+#define TYPE_S390_TOPOLOGY_DRAWER_BUS "drawer-bus"
+struct S390TopologyDrawer {
+    SysBusDevice parent_obj;
+    BusState *bus;
+    uint8_t drawer_id;
+    int cnt;
+};
+typedef struct S390TopologyDrawer S390TopologyDrawer;
+OBJECT_DECLARE_SIMPLE_TYPE(S390TopologyDrawer, S390_TOPOLOGY_DRAWER)
+#define S390_MAX_DRAWERS 1
 
-S390TopologyBook *s390_init_topology(void);
+S390TopologyDrawer *s390_init_topology(void);
 
-S390TopologyBook *s390_get_topology(void);
+S390TopologyDrawer *s390_get_topology(void);
 void s390_topology_setup(MachineState *ms);
 void s390_topology_new_cpu(int core_id);
 
diff --git a/include/hw/s390x/sclp.h b/include/hw/s390x/sclp.h
index d3ade40a5a..139d46efa4 100644
--- a/include/hw/s390x/sclp.h
+++ b/include/hw/s390x/sclp.h
@@ -111,6 +111,7 @@ typedef struct CPUEntry {
     uint8_t reserved1;
 } QEMU_PACKED CPUEntry;
 
+#define SCLP_READ_SCP_INFO_MNEST                  3
 #define SCLP_READ_SCP_INFO_FIXED_CPU_OFFSET     128
 typedef struct ReadInfo {
     SCCBHeader h;
diff --git a/target/s390x/cpu_topology.c b/target/s390x/cpu_topology.c
index 7f6db18829..08e1fbd13e 100644
--- a/target/s390x/cpu_topology.c
+++ b/target/s390x/cpu_topology.c
@@ -14,6 +14,7 @@
 #include "hw/s390x/pv.h"
 #include "hw/sysbus.h"
 #include "hw/s390x/cpu-topology.h"
+#include "hw/s390x/sclp.h"
 
 static int stsi_15_container(void *p, int nl, int id)
 {
@@ -40,7 +41,7 @@ static int stsi_15_cpus(void *p, S390TopologyCores *cd)
 }
 
 static int set_socket(const MachineState *ms, void *p,
-                      S390TopologySocket *socket)
+                      S390TopologySocket *socket, int level)
 {
     BusChild *kid;
     int l, len = 0;
@@ -56,24 +57,56 @@ static int set_socket(const MachineState *ms, void *p,
     return len;
 }
 
+static int set_book(const MachineState *ms, void *p,
+                    S390TopologyBook *book, int level)
+{
+    BusChild *kid;
+    int l, len = 0;
+
+    if (level >= 3) {
+        len += stsi_15_container(p, 2, book->book_id);
+        p += len;
+    }
+
+    QTAILQ_FOREACH_REVERSE(kid, &book->bus->children, sibling) {
+        l = set_socket(ms, p, S390_TOPOLOGY_SOCKET(kid->child), level);
+        p += l;
+        len += l;
+    }
+
+    return len;
+}
+
 static void setup_stsi(const MachineState *ms, void *p, int level)
 {
-    S390TopologyBook *book;
+    S390TopologyDrawer *drawer;
     SysIB_151x *sysib;
     BusChild *kid;
+    int nb_sockets, nb_books;
     int len, l;
 
     sysib = (SysIB_151x *)p;
     sysib->mnest = level;
-    sysib->mag[TOPOLOGY_NR_MAG2] = ms->smp.sockets;
+    switch (level) {
+    case 2:
+        nb_books = 0;
+        nb_sockets = ms->smp.sockets * ms->smp.books;
+        break;
+    case 3:
+        nb_books = ms->smp.books;
+        nb_sockets = ms->smp.sockets;
+        break;
+    }
+    sysib->mag[TOPOLOGY_NR_MAG3] = nb_books;
+    sysib->mag[TOPOLOGY_NR_MAG2] = nb_sockets;
     sysib->mag[TOPOLOGY_NR_MAG1] = ms->smp.cores * ms->smp.threads;
 
-    book = s390_get_topology();
+    drawer = s390_get_topology();
     len = sizeof(SysIB_151x);
     p += len;
 
-    QTAILQ_FOREACH_REVERSE(kid, &book->bus->children, sibling) {
-        l = set_socket(ms, p, S390_TOPOLOGY_SOCKET(kid->child));
+    QTAILQ_FOREACH_REVERSE(kid, &drawer->bus->children, sibling) {
+        l = set_book(ms, p, S390_TOPOLOGY_BOOK(kid->child), level);
         p += l;
         len += l;
     }
@@ -87,18 +120,14 @@ void insert_stsi_15_1_x(S390CPU *cpu, int sel2, __u64 addr, uint8_t ar)
     void *p;
     int ret, cc;
 
-    /*
-     * Until the SCLP STSI Facility reporting the MNEST value is used,
-     * a sel2 value of 2 is the only value allowed in STSI 15.1.x.
-     */
-    if (sel2 != 2) {
+    if (sel2 < 2 || sel2 > SCLP_READ_SCP_INFO_MNEST) {
         setcc(cpu, 3);
         return;
     }
 
     p = g_malloc0(TARGET_PAGE_SIZE);
 
-    setup_stsi(machine, p, 2);
+    setup_stsi(machine, p, sel2);
 
     if (s390_is_pv()) {
         ret = s390_cpu_pv_mem_write(cpu, 0, p, TARGET_PAGE_SIZE);
-- 
2.27.0

