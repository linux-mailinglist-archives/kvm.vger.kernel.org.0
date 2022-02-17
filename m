Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2E7F4BA16B
	for <lists+kvm@lfdr.de>; Thu, 17 Feb 2022 14:40:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241052AbiBQNkE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Feb 2022 08:40:04 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232764AbiBQNkE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Feb 2022 08:40:04 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89EA72AF916
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 05:39:49 -0800 (PST)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21HD7A5n017341;
        Thu, 17 Feb 2022 13:39:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=uEorX0lnubEv9/2pQJn+S0XeXc+WB6C5fhr9TQ8DLBk=;
 b=VNhWISiFPpGDrhL/M2pYoWaCW+zYn9+Lby2f+kBASF4tURNjvjzeI9gy1axjzI/ggw+9
 TkoKaE9Mb5uv9O0/bVhC+lS/PjOTyXPoX+HCwi4HRzkWWPYYGZtNj55GgS8zQeXqZL6j
 yAO8Kxv9DZnr/4xEgnZKOmHDqCJmdeFDHDkluwArhCfeBcnj/hD8h6+NB6FX0K5qOhsb
 7d8IOfXOYSLGpJGJ1s8AkkLM/xsXqc1ydxovG6fdjVj273Hd5kQsN/Rke9tZ3XPj8XUD
 UFWofldvM/MskiiFp88ekIOcbAny+/1pw0xqQBhP2FB2PwP2Uy/EVDyIBXncLFMJsheI MQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e9pnn924p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Feb 2022 13:39:27 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21HDYZaJ029304;
        Thu, 17 Feb 2022 13:39:27 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e9pnn9240-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Feb 2022 13:39:26 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21HDaAnw013267;
        Thu, 17 Feb 2022 13:39:24 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma01fra.de.ibm.com with ESMTP id 3e64ha0f2n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Feb 2022 13:39:24 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21HDdKbl44958184
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Feb 2022 13:39:20 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DEB294C06A;
        Thu, 17 Feb 2022 13:39:19 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 199054C050;
        Thu, 17 Feb 2022 13:39:19 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.171.42.121])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 17 Feb 2022 13:39:19 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, philmd@redhat.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com
Subject: [PATCH v6 09/11] s390x: topology: Adding drawers to STSI
Date:   Thu, 17 Feb 2022 14:41:23 +0100
Message-Id: <20220217134125.132150-10-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220217134125.132150-1-pmorel@linux.ibm.com>
References: <20220217134125.132150-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: jhTdTQGL59ceB5fbX4IujDyQlkHJ_q4P
X-Proofpoint-ORIG-GUID: lUBJMxHhW7HaQIIBkYUEWIXTrjg2Vevo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-17_05,2022-02-17_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 impostorscore=0 bulkscore=0 clxscore=1015 mlxlogscore=999 mlxscore=0
 phishscore=0 spamscore=0 priorityscore=1501 lowpriorityscore=0
 adultscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2202170061
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's add STSI support for the container level 4, drawers,
and provide the information back to the guest.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 hw/s390x/cpu-topology.c         | 137 +++++++++++++++++++++++++++++---
 include/hw/s390x/cpu-topology.h |  19 ++++-
 include/hw/s390x/sclp.h         |   2 +-
 target/s390x/cpu_topology.c     |  40 ++++++++--
 4 files changed, 176 insertions(+), 22 deletions(-)

diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
index 4705a2af96..3ae86f80f1 100644
--- a/hw/s390x/cpu-topology.c
+++ b/hw/s390x/cpu-topology.c
@@ -81,6 +81,26 @@ static S390TopologyBook *s390_create_book(S390TopologyDrawer *drawer, int id)
     return book;
 }
 
+static S390TopologyDrawer *s390_create_drawer(S390TopologyNode *node, int id)
+{
+    DeviceState *dev;
+    S390TopologyDrawer *drawer;
+    const MachineState *ms = MACHINE(qdev_get_machine());
+
+    if (node->bus->num_children >= ms->smp.drawers) {
+        return NULL;
+    }
+
+    dev = qdev_new(TYPE_S390_TOPOLOGY_DRAWER);
+    qdev_realize_and_unref(dev, node->bus, &error_fatal);
+
+    drawer = S390_TOPOLOGY_DRAWER(dev);
+    drawer->drawer_id = id;
+    node->cnt++;
+
+    return drawer;
+}
+
 /*
  * s390_get_cores:
  * @socket: the socket to search into
@@ -130,6 +150,31 @@ static S390TopologySocket *s390_get_socket(S390TopologyBook *book,
     return s390_create_socket(book, socket_id);
 }
 
+/*
+ * s390_get_drawer:
+ * @node: The node to search into
+ * @drawer_id: the identifier of the drawer to search for
+ *
+ * returns a pointer to a S390TopologyDrawer structure within a book having
+ * the specified drawer_id.
+ * First search if the book is already containing the S390TopologyDrawer
+ * structure and if not create one with this drawer_id.
+ */
+static S390TopologyDrawer *s390_get_drawer(S390TopologyNode *node,
+                                           int drawer_id)
+{
+    S390TopologyDrawer *drawer;
+    BusChild *kid;
+
+    QTAILQ_FOREACH(kid, &node->bus->children, sibling) {
+        drawer = S390_TOPOLOGY_DRAWER(kid->child);
+        if (drawer->drawer_id == drawer_id) {
+            return drawer;
+        }
+    }
+    return s390_create_drawer(node, drawer_id);
+}
+
 /*
  * s390_get_book:
  * @drawer: The drawer to search into
@@ -169,6 +214,7 @@ static S390TopologyBook *s390_get_book(S390TopologyDrawer *drawer,
 void s390_topology_new_cpu(int core_id)
 {
     const MachineState *ms = MACHINE(qdev_get_machine());
+    S390TopologyNode *node;
     S390TopologyDrawer *drawer;
     S390TopologyBook *book;
     S390TopologySocket *socket;
@@ -176,13 +222,16 @@ void s390_topology_new_cpu(int core_id)
     int origin, bit;
     int nb_cores_per_socket;
     int nb_cores_per_book;
+    int nb_cores_per_drawer;
 
-    drawer = s390_get_topology();
+    node = s390_get_topology();
 
     /* Cores for the S390 topology are cores and threads of the QEMU topology */
     nb_cores_per_socket = ms->smp.cores * ms->smp.threads;
     nb_cores_per_book = ms->smp.sockets * nb_cores_per_socket;
+    nb_cores_per_drawer = ms->smp.books * nb_cores_per_book;
 
+    drawer = s390_get_drawer(node, core_id / nb_cores_per_drawer);
     book = s390_get_book(drawer, core_id / nb_cores_per_book);
     socket = s390_get_socket(book, core_id / nb_cores_per_socket);
 
@@ -216,23 +265,23 @@ void s390_topology_setup(MachineState *ms)
     DeviceState *dev;
 
     /* Create BOOK bridge device */
-    dev = qdev_new(TYPE_S390_TOPOLOGY_DRAWER);
+    dev = qdev_new(TYPE_S390_TOPOLOGY_NODE);
     object_property_add_child(qdev_get_machine(),
-                              TYPE_S390_TOPOLOGY_DRAWER, OBJECT(dev));
+                              TYPE_S390_TOPOLOGY_NODE, OBJECT(dev));
     sysbus_realize_and_unref(SYS_BUS_DEVICE(dev), &error_fatal);
 }
 
-S390TopologyDrawer *s390_get_topology(void)
+S390TopologyNode *s390_get_topology(void)
 {
-    static S390TopologyDrawer *drawer;
+    static S390TopologyNode *node;
 
-    if (!drawer) {
-        drawer = S390_TOPOLOGY_DRAWER(object_resolve_path(
-                                      TYPE_S390_TOPOLOGY_DRAWER, NULL));
-        assert(drawer != NULL);
+    if (!node) {
+        node = S390_TOPOLOGY_NODE(object_resolve_path(
+                                  TYPE_S390_TOPOLOGY_NODE, NULL));
+        assert(node != NULL);
     }
 
-    return drawer;
+    return node;
 }
 
 /* --- CORES Definitions --- */
@@ -455,6 +504,7 @@ static void drawer_class_init(ObjectClass *oc, void *data)
 
     hc->unplug = qdev_simple_device_unplug_cb;
     set_bit(DEVICE_CATEGORY_BRIDGE, dc->categories);
+    dc->bus_type = TYPE_S390_TOPOLOGY_NODE_BUS;
     dc->realize = s390_drawer_device_realize;
     device_class_set_props(dc, s390_topology_drawer_properties);
     dc->desc = "topology drawer";
@@ -462,7 +512,7 @@ static void drawer_class_init(ObjectClass *oc, void *data)
 
 static const TypeInfo drawer_info = {
     .name          = TYPE_S390_TOPOLOGY_DRAWER,
-    .parent        = TYPE_SYS_BUS_DEVICE,
+    .parent        = TYPE_DEVICE,
     .instance_size = sizeof(S390TopologyDrawer),
     .class_init    = drawer_class_init,
     .interfaces = (InterfaceInfo[]) {
@@ -470,6 +520,69 @@ static const TypeInfo drawer_info = {
         { }
     }
 };
+
+/* --- NODE Definitions --- */
+
+/*
+ * Nodes are the first level of CPU topology we support
+ * only one NODE for the moment.
+ */
+static char *node_bus_get_dev_path(DeviceState *dev)
+{
+    return g_strdup_printf("00");
+}
+
+static void node_bus_class_init(ObjectClass *oc, void *data)
+{
+    BusClass *k = BUS_CLASS(oc);
+
+    k->get_dev_path = node_bus_get_dev_path;
+    k->max_dev = S390_MAX_NODES;
+}
+
+static const TypeInfo node_bus_info = {
+    .name = TYPE_S390_TOPOLOGY_NODE_BUS,
+    .parent = TYPE_BUS,
+    .instance_size = 0,
+    .class_init = node_bus_class_init,
+};
+
+static void s390_node_device_realize(DeviceState *dev, Error **errp)
+{
+    S390TopologyNode *node = S390_TOPOLOGY_NODE(dev);
+    BusState *bus;
+
+    /* Create NODE bus on NODE bridge device */
+    bus = qbus_new(TYPE_S390_TOPOLOGY_NODE_BUS, dev,
+                   TYPE_S390_TOPOLOGY_NODE_BUS);
+    node->bus = bus;
+
+    /* Enable hotplugging */
+    qbus_set_hotplug_handler(bus, OBJECT(dev));
+}
+
+static void node_class_init(ObjectClass *oc, void *data)
+{
+    DeviceClass *dc = DEVICE_CLASS(oc);
+    HotplugHandlerClass *hc = HOTPLUG_HANDLER_CLASS(oc);
+
+    hc->unplug = qdev_simple_device_unplug_cb;
+    set_bit(DEVICE_CATEGORY_BRIDGE, dc->categories);
+    dc->realize = s390_node_device_realize;
+    dc->desc = "topology node";
+}
+
+static const TypeInfo node_info = {
+    .name          = TYPE_S390_TOPOLOGY_NODE,
+    .parent        = TYPE_SYS_BUS_DEVICE,
+    .instance_size = sizeof(S390TopologyNode),
+    .class_init    = node_class_init,
+    .interfaces = (InterfaceInfo[]) {
+        { TYPE_HOTPLUG_HANDLER },
+        { }
+    }
+};
+
 static void topology_register(void)
 {
     type_register_static(&cpu_cores_info);
@@ -479,6 +592,8 @@ static void topology_register(void)
     type_register_static(&book_info);
     type_register_static(&drawer_bus_info);
     type_register_static(&drawer_info);
+    type_register_static(&node_bus_info);
+    type_register_static(&node_info);
 }
 
 type_init(topology_register);
diff --git a/include/hw/s390x/cpu-topology.h b/include/hw/s390x/cpu-topology.h
index 78017c3d78..10e4bd754f 100644
--- a/include/hw/s390x/cpu-topology.h
+++ b/include/hw/s390x/cpu-topology.h
@@ -68,18 +68,29 @@ OBJECT_DECLARE_SIMPLE_TYPE(S390TopologyBook, S390_TOPOLOGY_BOOK)
 #define TYPE_S390_TOPOLOGY_DRAWER "topology drawer"
 #define TYPE_S390_TOPOLOGY_DRAWER_BUS "drawer-bus"
 struct S390TopologyDrawer {
-    SysBusDevice parent_obj;
+    DeviceState parent_obj;
     BusState *bus;
     uint8_t drawer_id;
     int cnt;
 };
 typedef struct S390TopologyDrawer S390TopologyDrawer;
 OBJECT_DECLARE_SIMPLE_TYPE(S390TopologyDrawer, S390_TOPOLOGY_DRAWER)
-#define S390_MAX_DRAWERS 1
+#define S390_MAX_DRAWERS 4
 
-S390TopologyDrawer *s390_init_topology(void);
+#define TYPE_S390_TOPOLOGY_NODE "topology node"
+#define TYPE_S390_TOPOLOGY_NODE_BUS "node-bus"
+struct S390TopologyNode {
+    SysBusDevice parent_obj;
+    BusState *bus;
+    uint8_t node_id;
+    int cnt;
+};
+typedef struct S390TopologyNode S390TopologyNode;
+OBJECT_DECLARE_SIMPLE_TYPE(S390TopologyNode, S390_TOPOLOGY_NODE)
+#define S390_MAX_NODES 1
 
-S390TopologyDrawer *s390_get_topology(void);
+S390TopologyNode *s390_init_topology(void);
+S390TopologyNode *s390_get_topology(void);
 void s390_topology_setup(MachineState *ms);
 void s390_topology_new_cpu(int core_id);
 
diff --git a/include/hw/s390x/sclp.h b/include/hw/s390x/sclp.h
index e8c55486f7..660ef49ec5 100644
--- a/include/hw/s390x/sclp.h
+++ b/include/hw/s390x/sclp.h
@@ -111,7 +111,7 @@ typedef struct CPUEntry {
     uint8_t reserved1;
 } QEMU_PACKED CPUEntry;
 
-#define SCLP_READ_SCP_INFO_MNEST                  3
+#define SCLP_READ_SCP_INFO_MNEST                  4
 #define SCLP_READ_SCP_INFO_FIXED_CPU_OFFSET     128
 typedef struct ReadInfo {
     SCCBHeader h;
diff --git a/target/s390x/cpu_topology.c b/target/s390x/cpu_topology.c
index 08e1fbd13e..fd25c56213 100644
--- a/target/s390x/cpu_topology.c
+++ b/target/s390x/cpu_topology.c
@@ -77,36 +77,64 @@ static int set_book(const MachineState *ms, void *p,
     return len;
 }
 
+static int set_drawer(const MachineState *ms, void *p,
+                      S390TopologyDrawer *drawer, int level)
+{
+    BusChild *kid;
+    int l, len = 0;
+
+    if (level >= 4) {
+        len += stsi_15_container(p, 3, drawer->drawer_id);
+        p += len;
+    }
+
+    QTAILQ_FOREACH_REVERSE(kid, &drawer->bus->children, sibling) {
+        l = set_book(ms, p, S390_TOPOLOGY_BOOK(kid->child), level);
+        p += l;
+        len += l;
+    }
+
+    return len;
+}
+
 static void setup_stsi(const MachineState *ms, void *p, int level)
 {
-    S390TopologyDrawer *drawer;
+    S390TopologyNode *node;
     SysIB_151x *sysib;
     BusChild *kid;
-    int nb_sockets, nb_books;
+    int nb_sockets, nb_books, nb_drawers;
     int len, l;
 
     sysib = (SysIB_151x *)p;
     sysib->mnest = level;
     switch (level) {
     case 2:
+        nb_drawers = 0;
         nb_books = 0;
-        nb_sockets = ms->smp.sockets * ms->smp.books;
+        nb_sockets = ms->smp.sockets * ms->smp.books * ms->smp.drawers;
         break;
     case 3:
+        nb_drawers = 0;
+        nb_books = ms->smp.books * ms->smp.drawers;
+        nb_sockets = ms->smp.sockets;
+        break;
+    case 4:
+        nb_drawers = ms->smp.drawers;
         nb_books = ms->smp.books;
         nb_sockets = ms->smp.sockets;
         break;
     }
+    sysib->mag[TOPOLOGY_NR_MAG4] = nb_drawers;
     sysib->mag[TOPOLOGY_NR_MAG3] = nb_books;
     sysib->mag[TOPOLOGY_NR_MAG2] = nb_sockets;
     sysib->mag[TOPOLOGY_NR_MAG1] = ms->smp.cores * ms->smp.threads;
 
-    drawer = s390_get_topology();
+    node = s390_get_topology();
     len = sizeof(SysIB_151x);
     p += len;
 
-    QTAILQ_FOREACH_REVERSE(kid, &drawer->bus->children, sibling) {
-        l = set_book(ms, p, S390_TOPOLOGY_BOOK(kid->child), level);
+    QTAILQ_FOREACH_REVERSE(kid, &node->bus->children, sibling) {
+        l = set_drawer(ms, p, S390_TOPOLOGY_DRAWER(kid->child), level);
         p += l;
         len += l;
     }
-- 
2.27.0

