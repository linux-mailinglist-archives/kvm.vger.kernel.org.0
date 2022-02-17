Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81A844BA177
	for <lists+kvm@lfdr.de>; Thu, 17 Feb 2022 14:40:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241018AbiBQNjo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Feb 2022 08:39:44 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240296AbiBQNjm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Feb 2022 08:39:42 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18CA629ADC1
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 05:39:27 -0800 (PST)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21HDP96L020443;
        Thu, 17 Feb 2022 13:39:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=6nkQiOUN4YTZB7wEMjBq8vIPNlsfirLdQarNNbO9mmQ=;
 b=nY5eaaqMROto3lSSybHK6ElVpcbVAQr4cd3+H1VKFYNfkG3M6a20Opcj9U3h5gTKsPh3
 K+fF5PNWB5M+agxS8ZN/Ykp20Tn/GfmajCeW8fmEfAp0I/n9FzG1iduX+2Fl/KnsmfT+
 GBw8SF5UUWD0Z8MBpg4ev3ujWgAMXekFjRBZY9XtLYof7CHZxpmijYRva7mjHATINbkj
 hgqWyAOrawBjBpYTX7p/rvIDta5smzKbtsSk2LB2/NcXIoQbng68eqfDQtC/bsi259s9
 eJVjLS1YSGdAnsx9J7AlpelAyx4MI81xeKAPZ5tD8GlcFsASIzMg6omnMDIGasp5Bb56 Xg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e9ncbu8fw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Feb 2022 13:39:22 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21HDBv76001535;
        Thu, 17 Feb 2022 13:39:21 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e9ncbu8ek-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Feb 2022 13:39:21 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21HDbQLV007613;
        Thu, 17 Feb 2022 13:39:19 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3e645kasus-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Feb 2022 13:39:19 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21HDdDBG32571830
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Feb 2022 13:39:13 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BABC94C04A;
        Thu, 17 Feb 2022 13:39:13 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E1A384C05E;
        Thu, 17 Feb 2022 13:39:12 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.171.42.121])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 17 Feb 2022 13:39:12 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, philmd@redhat.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com
Subject: [PATCH v6 02/11] s390x: topology: CPU topology objects and structures
Date:   Thu, 17 Feb 2022 14:41:16 +0100
Message-Id: <20220217134125.132150-3-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220217134125.132150-1-pmorel@linux.ibm.com>
References: <20220217134125.132150-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: _sBw8tozYa-OXbHHHggjS3vGcSXflDFf
X-Proofpoint-GUID: tmcO4iQdQu2KsgU4U7LyRfj2EGwbHqCB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-17_04,2022-02-17_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 priorityscore=1501 adultscore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 impostorscore=0
 mlxscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202170059
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We use new objects to have a dynamic administration of the CPU topology.
The highest level object in this implementation is the s390 book and
in this first implementation of CPU topology for S390 we have a single
book.
The book is built as a SYSBUS bridge during the CPU initialization.
Other objects, sockets and core will be built after the parsing
of the QEMU -smp argument.

Every object under this single book will be build dynamically
immediately after a CPU has be realized if it is needed.
The CPU will fill the sockets once after the other, according to the
number of core per socket defined during the smp parsing.

Each CPU inside a socket will be represented by a bit in a 64bit
unsigned long. Set on plug and clear on unplug of a CPU.

For the S390 CPU topology, thread and cores are merged into
topology cores and the number of topology cores is the multiplication
of cores by the numbers of threads.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 hw/s390x/cpu-topology.c         | 361 ++++++++++++++++++++++++++++++++
 hw/s390x/meson.build            |   1 +
 hw/s390x/s390-virtio-ccw.c      |   4 +
 include/hw/s390x/cpu-topology.h |  74 +++++++
 target/s390x/cpu.h              |  47 +++++
 5 files changed, 487 insertions(+)
 create mode 100644 hw/s390x/cpu-topology.c
 create mode 100644 include/hw/s390x/cpu-topology.h

diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
new file mode 100644
index 0000000000..b7131b4ac3
--- /dev/null
+++ b/hw/s390x/cpu-topology.c
@@ -0,0 +1,361 @@
+/*
+ * CPU Topology
+ *
+ * Copyright 2021 IBM Corp.
+ * Author(s): Pierre Morel <pmorel@linux.ibm.com>
+
+ * This work is licensed under the terms of the GNU GPL, version 2 or (at
+ * your option) any later version. See the COPYING file in the top-level
+ * directory.
+ */
+
+#include "qemu/osdep.h"
+#include "qapi/error.h"
+#include "qemu/error-report.h"
+#include "hw/sysbus.h"
+#include "hw/s390x/cpu-topology.h"
+#include "hw/qdev-properties.h"
+#include "hw/boards.h"
+#include "qemu/typedefs.h"
+#include "target/s390x/cpu.h"
+#include "hw/s390x/s390-virtio-ccw.h"
+
+static S390TopologyCores *s390_create_cores(S390TopologySocket *socket,
+                                            int origin)
+{
+    DeviceState *dev;
+    S390TopologyCores *cores;
+    const MachineState *ms = MACHINE(qdev_get_machine());
+
+    if (socket->bus->num_children >= (ms->smp.cores * ms->smp.threads)) {
+        return NULL;
+    }
+
+    dev = qdev_new(TYPE_S390_TOPOLOGY_CORES);
+    qdev_realize_and_unref(dev, socket->bus, &error_fatal);
+
+    cores = S390_TOPOLOGY_CORES(dev);
+    cores->origin = origin;
+    socket->cnt += 1;
+
+    return cores;
+}
+
+static S390TopologySocket *s390_create_socket(S390TopologyBook *book, int id)
+{
+    DeviceState *dev;
+    S390TopologySocket *socket;
+    const MachineState *ms = MACHINE(qdev_get_machine());
+
+    if (book->bus->num_children >= ms->smp.sockets) {
+        return NULL;
+    }
+
+    dev = qdev_new(TYPE_S390_TOPOLOGY_SOCKET);
+    qdev_realize_and_unref(dev, book->bus, &error_fatal);
+
+    socket = S390_TOPOLOGY_SOCKET(dev);
+    socket->socket_id = id;
+    book->cnt++;
+
+    return socket;
+}
+
+/*
+ * s390_get_cores:
+ * @socket: the socket to search into
+ * @origin: the origin specified for the S390TopologyCores
+ *
+ * returns a pointer to a S390TopologyCores structure within a socket having
+ * the specified origin.
+ * First search if the socket is already containing the S390TopologyCores
+ * structure and if not create one with this origin.
+ */
+static S390TopologyCores *s390_get_cores(S390TopologySocket *socket, int origin)
+{
+    S390TopologyCores *cores;
+    BusChild *kid;
+
+    QTAILQ_FOREACH(kid, &socket->bus->children, sibling) {
+        cores = S390_TOPOLOGY_CORES(kid->child);
+        if (cores->origin == origin) {
+            return cores;
+        }
+    }
+    return s390_create_cores(socket, origin);
+}
+
+/*
+ * s390_get_socket:
+ * @book: The book to search into
+ * @socket_id: the identifier of the socket to search for
+ *
+ * returns a pointer to a S390TopologySocket structure within a book having
+ * the specified socket_id.
+ * First search if the book is already containing the S390TopologySocket
+ * structure and if not create one with this socket_id.
+ */
+static S390TopologySocket *s390_get_socket(S390TopologyBook *book,
+                                           int socket_id)
+{
+    S390TopologySocket *socket;
+    BusChild *kid;
+
+    QTAILQ_FOREACH(kid, &book->bus->children, sibling) {
+        socket = S390_TOPOLOGY_SOCKET(kid->child);
+        if (socket->socket_id == socket_id) {
+            return socket;
+        }
+    }
+    return s390_create_socket(book, socket_id);
+}
+
+/*
+ * s390_topology_new_cpu:
+ * @core_id: the core ID is machine wide
+ *
+ * We have a single book returned by s390_get_topology(),
+ * then we build the hierarchy on demand.
+ * Note that we do not destroy the hierarchy on error creating
+ * an entry in the topology, we just keep it empty.
+ * We do not need to worry about not finding a topology level
+ * entry this would have been caught during smp parsing.
+ */
+void s390_topology_new_cpu(int core_id)
+{
+    const MachineState *ms = MACHINE(qdev_get_machine());
+    S390TopologyBook *book;
+    S390TopologySocket *socket;
+    S390TopologyCores *cores;
+    int cores_per_socket, sock_idx;
+    int origin, bit;
+
+    book = s390_get_topology();
+
+    cores_per_socket = ms->smp.max_cpus / ms->smp.sockets;
+
+    sock_idx = (core_id / cores_per_socket);
+    socket = s390_get_socket(book, sock_idx);
+
+    /*
+     * At the core level, each CPU is represented by a bit in a 64bit
+     * unsigned long. Set on plug and clear on unplug of a CPU.
+     * The firmware assume that all CPU in the core description have the same
+     * type, polarization and are all dedicated or shared.
+     * In the case a socket contains CPU with different type, polarization
+     * or dedication then they will be defined in different CPU containers.
+     * Currently we assume all CPU are identical and the only reason to have
+     * several S390TopologyCores inside a socket is to have more than 64 CPUs
+     * in that case the origin field, representing the offset of the first CPU
+     * in the CPU container allows to represent up to the maximal number of
+     * CPU inside several CPU containers inside the socket container.
+     */
+    origin = 64 * (core_id / 64);
+
+    cores = s390_get_cores(socket, origin);
+
+    bit = 63 - (core_id - origin);
+    set_bit(bit, &cores->mask);
+    cores->origin = origin;
+}
+
+/*
+ * Setting the first topology: 1 book, 1 socket
+ * This is enough for 64 cores if the topology is flat (single socket)
+ */
+void s390_topology_setup(MachineState *ms)
+{
+    DeviceState *dev;
+
+    /* Create BOOK bridge device */
+    dev = qdev_new(TYPE_S390_TOPOLOGY_BOOK);
+    object_property_add_child(qdev_get_machine(),
+                              TYPE_S390_TOPOLOGY_BOOK, OBJECT(dev));
+    sysbus_realize_and_unref(SYS_BUS_DEVICE(dev), &error_fatal);
+}
+
+S390TopologyBook *s390_get_topology(void)
+{
+    static S390TopologyBook *book;
+
+    if (!book) {
+        book = S390_TOPOLOGY_BOOK(
+            object_resolve_path(TYPE_S390_TOPOLOGY_BOOK, NULL));
+        assert(book != NULL);
+    }
+
+    return book;
+}
+
+/* --- CORES Definitions --- */
+
+static Property s390_topology_cores_properties[] = {
+    DEFINE_PROP_BOOL("dedicated", S390TopologyCores, dedicated, false),
+    DEFINE_PROP_UINT8("polarity", S390TopologyCores, polarity,
+                      S390_TOPOLOGY_POLARITY_H),
+    DEFINE_PROP_UINT8("cputype", S390TopologyCores, cputype,
+                      S390_TOPOLOGY_CPU_TYPE),
+    DEFINE_PROP_UINT16("origin", S390TopologyCores, origin, 0),
+    DEFINE_PROP_UINT64("mask", S390TopologyCores, mask, 0),
+    DEFINE_PROP_UINT8("id", S390TopologyCores, id, 0),
+    DEFINE_PROP_END_OF_LIST(),
+};
+
+static void cpu_cores_class_init(ObjectClass *oc, void *data)
+{
+    DeviceClass *dc = DEVICE_CLASS(oc);
+    HotplugHandlerClass *hc = HOTPLUG_HANDLER_CLASS(oc);
+
+    device_class_set_props(dc, s390_topology_cores_properties);
+    hc->unplug = qdev_simple_device_unplug_cb;
+    dc->bus_type = TYPE_S390_TOPOLOGY_SOCKET_BUS;
+    dc->desc = "topology cpu entry";
+}
+
+static const TypeInfo cpu_cores_info = {
+    .name          = TYPE_S390_TOPOLOGY_CORES,
+    .parent        = TYPE_DEVICE,
+    .instance_size = sizeof(S390TopologyCores),
+    .class_init    = cpu_cores_class_init,
+    .interfaces = (InterfaceInfo[]) {
+        { TYPE_HOTPLUG_HANDLER },
+        { }
+    }
+};
+
+/* --- SOCKETS Definitions --- */
+static Property s390_topology_socket_properties[] = {
+    DEFINE_PROP_UINT8("socket_id", S390TopologySocket, socket_id, 0),
+    DEFINE_PROP_END_OF_LIST(),
+};
+
+static char *socket_bus_get_dev_path(DeviceState *dev)
+{
+    S390TopologySocket *socket = S390_TOPOLOGY_SOCKET(dev);
+    DeviceState *book = dev->parent_bus->parent;
+    char *id = qdev_get_dev_path(book);
+    char *ret;
+
+    if (id) {
+        ret = g_strdup_printf("%s:%02d", id, socket->socket_id);
+        g_free(id);
+    } else {
+        ret = g_strdup_printf("_:%02d", socket->socket_id);
+    }
+
+    return ret;
+}
+
+static void socket_bus_class_init(ObjectClass *oc, void *data)
+{
+    BusClass *k = BUS_CLASS(oc);
+
+    k->get_dev_path = socket_bus_get_dev_path;
+    k->max_dev = S390_MAX_SOCKETS;
+}
+
+static const TypeInfo socket_bus_info = {
+    .name = TYPE_S390_TOPOLOGY_SOCKET_BUS,
+    .parent = TYPE_BUS,
+    .instance_size = 0,
+    .class_init = socket_bus_class_init,
+};
+
+static void s390_socket_device_realize(DeviceState *dev, Error **errp)
+{
+    S390TopologySocket *socket = S390_TOPOLOGY_SOCKET(dev);
+    BusState *bus;
+
+    bus = qbus_new(TYPE_S390_TOPOLOGY_SOCKET_BUS, dev,
+                   TYPE_S390_TOPOLOGY_SOCKET_BUS);
+    qbus_set_hotplug_handler(bus, OBJECT(dev));
+    socket->bus = bus;
+}
+
+static void socket_class_init(ObjectClass *oc, void *data)
+{
+    DeviceClass *dc = DEVICE_CLASS(oc);
+    HotplugHandlerClass *hc = HOTPLUG_HANDLER_CLASS(oc);
+
+    hc->unplug = qdev_simple_device_unplug_cb;
+    set_bit(DEVICE_CATEGORY_BRIDGE, dc->categories);
+    dc->bus_type = TYPE_S390_TOPOLOGY_BOOK_BUS;
+    dc->realize = s390_socket_device_realize;
+    device_class_set_props(dc, s390_topology_socket_properties);
+    dc->desc = "topology socket";
+}
+
+static const TypeInfo socket_info = {
+    .name          = TYPE_S390_TOPOLOGY_SOCKET,
+    .parent        = TYPE_DEVICE,
+    .instance_size = sizeof(S390TopologySocket),
+    .class_init    = socket_class_init,
+    .interfaces = (InterfaceInfo[]) {
+        { TYPE_HOTPLUG_HANDLER },
+        { }
+    }
+};
+
+static char *book_bus_get_dev_path(DeviceState *dev)
+{
+    return g_strdup_printf("00");
+}
+
+static void book_bus_class_init(ObjectClass *oc, void *data)
+{
+    BusClass *k = BUS_CLASS(oc);
+
+    k->get_dev_path = book_bus_get_dev_path;
+    k->max_dev = S390_MAX_BOOKS;
+}
+
+static const TypeInfo book_bus_info = {
+    .name = TYPE_S390_TOPOLOGY_BOOK_BUS,
+    .parent = TYPE_BUS,
+    .instance_size = 0,
+    .class_init = book_bus_class_init,
+};
+
+static void s390_book_device_realize(DeviceState *dev, Error **errp)
+{
+    S390TopologyBook *book = S390_TOPOLOGY_BOOK(dev);
+    BusState *bus;
+
+    bus = qbus_new(TYPE_S390_TOPOLOGY_BOOK_BUS, dev,
+                   TYPE_S390_TOPOLOGY_BOOK_BUS);
+    qbus_set_hotplug_handler(bus, OBJECT(dev));
+    book->bus = bus;
+}
+
+static void book_class_init(ObjectClass *oc, void *data)
+{
+    DeviceClass *dc = DEVICE_CLASS(oc);
+    HotplugHandlerClass *hc = HOTPLUG_HANDLER_CLASS(oc);
+
+    hc->unplug = qdev_simple_device_unplug_cb;
+    set_bit(DEVICE_CATEGORY_BRIDGE, dc->categories);
+    dc->realize = s390_book_device_realize;
+    dc->desc = "topology book";
+}
+
+static const TypeInfo book_info = {
+    .name          = TYPE_S390_TOPOLOGY_BOOK,
+    .parent        = TYPE_SYS_BUS_DEVICE,
+    .instance_size = sizeof(S390TopologyBook),
+    .class_init    = book_class_init,
+    .interfaces = (InterfaceInfo[]) {
+        { TYPE_HOTPLUG_HANDLER },
+        { }
+    }
+};
+
+static void topology_register(void)
+{
+    type_register_static(&cpu_cores_info);
+    type_register_static(&socket_bus_info);
+    type_register_static(&socket_info);
+    type_register_static(&book_bus_info);
+    type_register_static(&book_info);
+}
+
+type_init(topology_register);
diff --git a/hw/s390x/meson.build b/hw/s390x/meson.build
index 28484256ec..74678861cf 100644
--- a/hw/s390x/meson.build
+++ b/hw/s390x/meson.build
@@ -2,6 +2,7 @@ s390x_ss = ss.source_set()
 s390x_ss.add(files(
   'ap-bridge.c',
   'ap-device.c',
+  'cpu-topology.c',
   'ccw-device.c',
   'css-bridge.c',
   'css.c',
diff --git a/hw/s390x/s390-virtio-ccw.c b/hw/s390x/s390-virtio-ccw.c
index 84e3e63c43..ae8e99d0b0 100644
--- a/hw/s390x/s390-virtio-ccw.c
+++ b/hw/s390x/s390-virtio-ccw.c
@@ -42,6 +42,7 @@
 #include "sysemu/sysemu.h"
 #include "hw/s390x/pv.h"
 #include "migration/blocker.h"
+#include "hw/s390x/cpu-topology.h"
 
 static Error *pv_mig_blocker;
 
@@ -88,6 +89,7 @@ static void s390_init_cpus(MachineState *machine)
     /* initialize possible_cpus */
     mc->possible_cpu_arch_ids(machine);
 
+    s390_topology_setup(machine);
     for (i = 0; i < machine->smp.cpus; i++) {
         s390x_new_cpu(machine->cpu_type, i, &error_fatal);
     }
@@ -305,6 +307,8 @@ static void s390_cpu_plug(HotplugHandler *hotplug_dev,
     g_assert(!ms->possible_cpus->cpus[cpu->env.core_id].cpu);
     ms->possible_cpus->cpus[cpu->env.core_id].cpu = OBJECT(dev);
 
+    s390_topology_new_cpu(cpu->env.core_id);
+
     if (dev->hotplugged) {
         raise_irq_cpu_hotplug();
     }
diff --git a/include/hw/s390x/cpu-topology.h b/include/hw/s390x/cpu-topology.h
new file mode 100644
index 0000000000..e6e013a8b8
--- /dev/null
+++ b/include/hw/s390x/cpu-topology.h
@@ -0,0 +1,74 @@
+/*
+ * CPU Topology
+ *
+ * Copyright 2021 IBM Corp.
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2 or (at
+ * your option) any later version. See the COPYING file in the top-level
+ * directory.
+ */
+#ifndef HW_S390X_CPU_TOPOLOGY_H
+#define HW_S390X_CPU_TOPOLOGY_H
+
+#include "hw/qdev-core.h"
+#include "qom/object.h"
+
+#define S390_TOPOLOGY_CPU_TYPE    0x03
+
+#define S390_TOPOLOGY_POLARITY_H  0x00
+#define S390_TOPOLOGY_POLARITY_VL 0x01
+#define S390_TOPOLOGY_POLARITY_VM 0x02
+#define S390_TOPOLOGY_POLARITY_VH 0x03
+
+#define TYPE_S390_TOPOLOGY_CORES "topology cores"
+    /*
+     * Each CPU inside a socket will be represented by a bit in a 64bit
+     * unsigned long. Set on plug and clear on unplug of a CPU.
+     * All CPU inside a mask share the same dedicated, polarity and
+     * cputype values.
+     * The origin is the offset of the first CPU in a mask.
+     */
+struct S390TopologyCores {
+    DeviceState parent_obj;
+    uint8_t id;
+    bool dedicated;
+    uint8_t polarity;
+    uint8_t cputype;
+    uint16_t origin;
+    uint64_t mask;
+    int cnt;
+};
+typedef struct S390TopologyCores S390TopologyCores;
+OBJECT_DECLARE_SIMPLE_TYPE(S390TopologyCores, S390_TOPOLOGY_CORES)
+
+#define TYPE_S390_TOPOLOGY_SOCKET "topology socket"
+#define TYPE_S390_TOPOLOGY_SOCKET_BUS "socket-bus"
+struct S390TopologySocket {
+    DeviceState parent_obj;
+    BusState *bus;
+    uint8_t socket_id;
+    int cnt;
+};
+typedef struct S390TopologySocket S390TopologySocket;
+OBJECT_DECLARE_SIMPLE_TYPE(S390TopologySocket, S390_TOPOLOGY_SOCKET)
+#define S390_MAX_SOCKETS 4
+
+#define TYPE_S390_TOPOLOGY_BOOK "topology book"
+#define TYPE_S390_TOPOLOGY_BOOK_BUS "book-bus"
+struct S390TopologyBook {
+    SysBusDevice parent_obj;
+    BusState *bus;
+    uint8_t book_id;
+    int cnt;
+};
+typedef struct S390TopologyBook S390TopologyBook;
+OBJECT_DECLARE_SIMPLE_TYPE(S390TopologyBook, S390_TOPOLOGY_BOOK)
+#define S390_MAX_BOOKS 1
+
+S390TopologyBook *s390_init_topology(void);
+
+S390TopologyBook *s390_get_topology(void);
+void s390_topology_setup(MachineState *ms);
+void s390_topology_new_cpu(int core_id);
+
+#endif
diff --git a/target/s390x/cpu.h b/target/s390x/cpu.h
index a75e559134..e1672158f1 100644
--- a/target/s390x/cpu.h
+++ b/target/s390x/cpu.h
@@ -564,6 +564,53 @@ typedef union SysIB {
 } SysIB;
 QEMU_BUILD_BUG_ON(sizeof(SysIB) != 4096);
 
+/* CPU type Topology List Entry */
+typedef struct SysIBTl_cpu {
+        uint8_t nl;
+        uint8_t reserved0[3];
+        uint8_t reserved1:5;
+        uint8_t dedicated:1;
+        uint8_t polarity:2;
+        uint8_t type;
+        uint16_t origin;
+        uint64_t mask;
+} SysIBTl_cpu;
+QEMU_BUILD_BUG_ON(sizeof(SysIBTl_cpu) != 16);
+
+/* Container type Topology List Entry */
+typedef struct SysIBTl_container {
+        uint8_t nl;
+        uint8_t reserved[6];
+        uint8_t id;
+} QEMU_PACKED SysIBTl_container;
+QEMU_BUILD_BUG_ON(sizeof(SysIBTl_container) != 8);
+
+/* Generic Topology List Entry */
+typedef union SysIBTl_entry {
+        uint8_t nl;
+        SysIBTl_container container;
+        SysIBTl_cpu cpu;
+} SysIBTl_entry;
+
+#define TOPOLOGY_NR_MAG  6
+#define TOPOLOGY_NR_MAG6 0
+#define TOPOLOGY_NR_MAG5 1
+#define TOPOLOGY_NR_MAG4 2
+#define TOPOLOGY_NR_MAG3 3
+#define TOPOLOGY_NR_MAG2 4
+#define TOPOLOGY_NR_MAG1 5
+/* Configuration topology */
+typedef struct SysIB_151x {
+    uint8_t  res0[2];
+    uint16_t length;
+    uint8_t  mag[TOPOLOGY_NR_MAG];
+    uint8_t  res1;
+    uint8_t  mnest;
+    uint32_t res2;
+    SysIBTl_entry tle[0];
+} SysIB_151x;
+QEMU_BUILD_BUG_ON(sizeof(SysIB_151x) != 16);
+
 /* MMU defines */
 #define ASCE_ORIGIN           (~0xfffULL) /* segment table origin             */
 #define ASCE_SUBSPACE         0x200       /* subspace group control           */
-- 
2.27.0

