Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A2EF551F33
	for <lists+kvm@lfdr.de>; Mon, 20 Jun 2022 16:42:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345710AbiFTOka (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jun 2022 10:40:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245042AbiFTOj6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jun 2022 10:39:58 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AF64616F
        for <kvm@vger.kernel.org>; Mon, 20 Jun 2022 06:59:46 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25KCevkY023836;
        Mon, 20 Jun 2022 13:59:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=CZPWJPTcxFWpRspZVjIsT9QqXdcAmTeeMxF1ghqApZ4=;
 b=dGM62NQUKl/+G5RysWymbLBYWNFCR5jKmYwk568f/CIMBpdgzwmYiTD7HiIXmkA7NvM4
 /fgTJsnTV8PEa627+m8dP2uF6S2TEN5bOeLnPTOeMp325IcXsgxzHbGuNiewEyCVp62B
 Sq4YiOPpwkDZznGjnV9cjmML3vJNA9NbC1EyVYUiMRtf16knUZ06qtfXLiDC9yA99qbg
 eL24QId1EGMW6xdh93/neGui/NG/f9m3eY3fO7+qEVKbwXOASBKoMPZJZ5cmNZs71+yv
 qAmYLpXwLlg7FBsDhIPR6p8xVuX6PtCSB//AL/102wBQnl4ps5/Fv7vTR9XLd2PJAE3x sw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gsrcjtsma-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Jun 2022 13:59:40 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25KCxkS1024516;
        Mon, 20 Jun 2022 13:59:40 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gsrcjtskq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Jun 2022 13:59:40 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25KDpN16023576;
        Mon, 20 Jun 2022 13:59:38 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 3gs6b8tknf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Jun 2022 13:59:38 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25KDwrXb21823894
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Jun 2022 13:58:53 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 536CF11C04A;
        Mon, 20 Jun 2022 13:59:35 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 82F0411C04C;
        Mon, 20 Jun 2022 13:59:34 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.171.62.140])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 20 Jun 2022 13:59:34 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com
Subject: [PATCH v8 05/12] s390x/cpu_topology: Adding books to STSI
Date:   Mon, 20 Jun 2022 16:03:45 +0200
Message-Id: <20220620140352.39398-6-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220620140352.39398-1-pmorel@linux.ibm.com>
References: <20220620140352.39398-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: JzNK1SM0p7NjkcklXvVeHbWKaxicCx-3
X-Proofpoint-GUID: g8LezQPYDgM5uKZiImQtrx3im_GRX0bP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-20_05,2022-06-17_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 mlxlogscore=999 spamscore=0 mlxscore=0 bulkscore=0 lowpriorityscore=0
 malwarescore=0 phishscore=0 adultscore=0 impostorscore=0 clxscore=1015
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206200063
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's add STSI support for the container level 3, books,
and provide the information back to the guest.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 hw/s390x/cpu-topology.c         | 163 +++++++++++++++++++++++++++++---
 include/hw/s390x/cpu-topology.h |  20 +++-
 include/hw/s390x/sclp.h         |   1 +
 target/s390x/cpu_topology.c     |  53 ++++++++---
 4 files changed, 210 insertions(+), 27 deletions(-)

diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
index 0fd6f08084..eba003d498 100644
--- a/hw/s390x/cpu-topology.c
+++ b/hw/s390x/cpu-topology.c
@@ -86,6 +86,38 @@ static S390TopologySocket *s390_create_socket(MachineState *ms,
     return socket;
 }
 
+/*
+ * s390_create_book:
+ * @ms: Machine state
+ * @drawer: the drawer on which to create the book
+ * @id: the book id
+ *
+ * returns a pointer to the created S390TopologyBook structure
+ *
+ * On error: return NULL
+ */
+static S390TopologyBook *s390_create_book(MachineState *ms,
+                                          S390TopologyDrawer *drawer,
+                                          int id, Error **errp)
+{
+    DeviceState *dev;
+    S390TopologyBook *book;
+
+    if (drawer->bus->num_children >= ms->smp.books) {
+        error_setg(errp, "Unable to create more books.");
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
  * @ms: Machine state
@@ -142,6 +174,34 @@ static S390TopologySocket *s390_get_socket(MachineState *ms,
     return s390_create_socket(ms, book, socket_id, errp);
 }
 
+/*
+ * s390_get_book:
+ * @ms: Machine state
+ * @drawer: The drawer to search into
+ * @book_id: the identifier of the book to search for
+ * @errp: Error pointer
+ *
+ * returns a pointer to a S390TopologySocket structure within a drawer having
+ * the specified book_id.
+ * First search if the drawer is already containing the S390TopologySocket
+ * structure and if not create one with this book_id.
+ */
+static S390TopologyBook *s390_get_book(MachineState *ms,
+                                       S390TopologyDrawer *drawer,
+                                       int book_id, Error **errp)
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
+    return s390_create_book(ms, drawer, book_id, errp);
+}
+
 /*
  * s390_topology_new_cpu:
  * @core_id: the core ID is machine wide
@@ -155,16 +215,23 @@ static S390TopologySocket *s390_get_socket(MachineState *ms,
  */
 bool s390_topology_new_cpu(MachineState *ms, int core_id, Error **errp)
 {
+    S390TopologyDrawer *drawer;
     S390TopologyBook *book;
     S390TopologySocket *socket;
     S390TopologyCores *cores;
     int nb_cores_per_socket;
+    int nb_cores_per_book;
     int origin, bit;
 
-    book = s390_get_topology();
+    drawer = s390_get_topology();
 
     nb_cores_per_socket = ms->smp.cores * ms->smp.threads;
+    nb_cores_per_book = ms->smp.sockets * nb_cores_per_socket;
 
+    book = s390_get_book(ms, drawer, core_id / nb_cores_per_book, errp);
+    if (!book) {
+        return false;
+    }
     socket = s390_get_socket(ms, book, core_id / nb_cores_per_socket, errp);
     if (!socket) {
         return false;
@@ -206,23 +273,23 @@ void s390_topology_setup(MachineState *ms)
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
@@ -365,12 +432,13 @@ static void book_class_init(ObjectClass *oc, void *data)
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
@@ -379,6 +447,77 @@ static const TypeInfo book_info = {
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
+        ret = g_strdup_printf("_:%02d", drawer->drawer_id);
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
@@ -386,6 +525,8 @@ static void topology_register(void)
     type_register_static(&socket_info);
     type_register_static(&book_bus_info);
     type_register_static(&book_info);
+    type_register_static(&drawer_bus_info);
+    type_register_static(&drawer_info);
 }
 
 type_init(topology_register);
diff --git a/include/hw/s390x/cpu-topology.h b/include/hw/s390x/cpu-topology.h
index beec61706c..5ffb8cba77 100644
--- a/include/hw/s390x/cpu-topology.h
+++ b/include/hw/s390x/cpu-topology.h
@@ -56,18 +56,30 @@ OBJECT_DECLARE_SIMPLE_TYPE(S390TopologySocket, S390_TOPOLOGY_SOCKET)
 #define TYPE_S390_TOPOLOGY_BOOK "topology book"
 #define TYPE_S390_TOPOLOGY_BOOK_BUS "book-bus"
 struct S390TopologyBook {
-    SysBusDevice parent_obj;
+    DeviceState parent_obj;
     BusState *bus;
     int book_id;
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
 bool s390_topology_new_cpu(MachineState *ms, int core_id, Error **errp);
 
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
index 9f656d7e51..d14b2fb25c 100644
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
     int ret;
 
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
2.31.1

