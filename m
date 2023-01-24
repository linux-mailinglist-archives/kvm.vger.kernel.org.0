Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC1DA6797A6
	for <lists+kvm@lfdr.de>; Tue, 24 Jan 2023 13:20:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233090AbjAXMUo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Jan 2023 07:20:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231538AbjAXMUn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Jan 2023 07:20:43 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21A684588E
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 04:19:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674562790;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PQ3o1D0dBZEcUR25++K4SD9cPWuwwrtJ+CXmUGnF8rU=;
        b=WW57q8AxmpT+TLlqj92r1SuytuwXm9CaxRgOrO8pUxcWs7JjjZ2La8Ibafwxihfz4m4iic
        rzPaO+xlXxPMniSSVo+LZcu5hzIvN2o3CkIfCFbw/4JeLwOYzDxl91HaoFKXMjjYPleRcf
        tFiRKa4Wr0IsunMmfH8CR7sP1LnenSo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-370-MKRZetaJMLG35vMq4cYMOg-1; Tue, 24 Jan 2023 07:19:49 -0500
X-MC-Unique: MKRZetaJMLG35vMq4cYMOg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 514BC38123AB;
        Tue, 24 Jan 2023 12:19:48 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.192.70])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9D4FF400D795;
        Tue, 24 Jan 2023 12:19:47 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
        id 826D121E6A20; Tue, 24 Jan 2023 13:19:46 +0100 (CET)
From:   Markus Armbruster <armbru@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     pbonzini@redhat.com, kraxel@redhat.com, kwolf@redhat.com,
        hreitz@redhat.com, marcandre.lureau@redhat.com,
        dgilbert@redhat.com, mst@redhat.com, imammedo@redhat.com,
        ani@anisinha.ca, eduardo@habkost.net, marcel.apfelbaum@gmail.com,
        philmd@linaro.org, wangyanan55@huawei.com, jasowang@redhat.com,
        jiri@resnulli.us, berrange@redhat.com, thuth@redhat.com,
        quintela@redhat.com, stefanb@linux.vnet.ibm.com,
        stefanha@redhat.com, kvm@vger.kernel.org, qemu-block@nongnu.org
Subject: [PATCH 01/32] monitor: Drop unnecessary includes
Date:   Tue, 24 Jan 2023 13:19:15 +0100
Message-Id: <20230124121946.1139465-2-armbru@redhat.com>
In-Reply-To: <20230124121946.1139465-1-armbru@redhat.com>
References: <20230124121946.1139465-1-armbru@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Markus Armbruster <armbru@redhat.com>
---
 monitor/hmp-cmds.c         |  4 ----
 monitor/hmp.c              |  3 ---
 monitor/misc.c             | 14 ++------------
 monitor/monitor.c          |  1 -
 monitor/qmp-cmds-control.c |  1 -
 monitor/qmp-cmds.c         |  8 --------
 6 files changed, 2 insertions(+), 29 deletions(-)

diff --git a/monitor/hmp-cmds.c b/monitor/hmp-cmds.c
index 1dba973092..de1a96d48c 100644
--- a/monitor/hmp-cmds.c
+++ b/monitor/hmp-cmds.c
@@ -18,17 +18,14 @@
 #include "net/net.h"
 #include "net/eth.h"
 #include "chardev/char.h"
-#include "sysemu/block-backend.h"
 #include "sysemu/runstate.h"
 #include "qemu/config-file.h"
 #include "qemu/option.h"
-#include "qemu/timer.h"
 #include "qemu/sockets.h"
 #include "qemu/help_option.h"
 #include "monitor/monitor.h"
 #include "qapi/error.h"
 #include "qapi/clone-visitor.h"
-#include "qapi/opts-visitor.h"
 #include "qapi/qapi-builtin-visit.h"
 #include "qapi/qapi-commands-block.h"
 #include "qapi/qapi-commands-char.h"
@@ -42,7 +39,6 @@
 #include "qapi/qapi-commands-stats.h"
 #include "qapi/qapi-commands-tpm.h"
 #include "qapi/qapi-commands-virtio.h"
-#include "qapi/qapi-visit-virtio.h"
 #include "qapi/qapi-visit-net.h"
 #include "qapi/qapi-visit-migration.h"
 #include "qapi/qmp/qdict.h"
diff --git a/monitor/hmp.c b/monitor/hmp.c
index 43fd69f984..65641a6e56 100644
--- a/monitor/hmp.c
+++ b/monitor/hmp.c
@@ -23,11 +23,9 @@
  */
 
 #include "qemu/osdep.h"
-#include <dirent.h>
 #include "hw/qdev-core.h"
 #include "monitor-internal.h"
 #include "monitor/hmp.h"
-#include "qapi/error.h"
 #include "qapi/qmp/qdict.h"
 #include "qapi/qmp/qnum.h"
 #include "qemu/config-file.h"
@@ -37,7 +35,6 @@
 #include "qemu/option.h"
 #include "qemu/units.h"
 #include "sysemu/block-backend.h"
-#include "sysemu/runstate.h"
 #include "trace.h"
 
 static void monitor_command_cb(void *opaque, const char *cmdline,
diff --git a/monitor/misc.c b/monitor/misc.c
index 053af4045e..6fc8bfef13 100644
--- a/monitor/misc.c
+++ b/monitor/misc.c
@@ -25,27 +25,20 @@
 #include "qemu/osdep.h"
 #include "monitor-internal.h"
 #include "monitor/qdev.h"
-#include "hw/pci/pci.h"
-#include "sysemu/watchdog.h"
 #include "exec/gdbstub.h"
 #include "net/net.h"
 #include "net/slirp.h"
 #include "ui/qemu-spice.h"
-#include "qemu/config-file.h"
 #include "qemu/ctype.h"
 #include "audio/audio.h"
 #include "disas/disas.h"
-#include "qemu/timer.h"
 #include "qemu/log.h"
 #include "sysemu/hw_accel.h"
 #include "sysemu/runstate.h"
-#include "authz/list.h"
-#include "qapi/util.h"
 #include "sysemu/sysemu.h"
 #include "sysemu/device_tree.h"
 #include "qapi/qmp/qdict.h"
 #include "qapi/qmp/qerror.h"
-#include "qapi/qmp/qstring.h"
 #include "qom/object_interfaces.h"
 #include "trace/control.h"
 #include "monitor/hmp-target.h"
@@ -53,10 +46,8 @@
 #ifdef CONFIG_TRACE_SIMPLE
 #include "trace/simple.h"
 #endif
-#include "exec/memory.h"
-#include "exec/exec-all.h"
-#include "qemu/option.h"
-#include "qemu/thread.h"
+#include "exec/address-spaces.h"
+#include "exec/ioport.h"
 #include "block/qapi.h"
 #include "block/block-hmp-cmds.h"
 #include "qapi/qapi-commands-char.h"
@@ -69,7 +60,6 @@
 #include "qapi/qapi-commands-machine.h"
 #include "qapi/qapi-init-commands.h"
 #include "qapi/error.h"
-#include "qapi/qmp-event.h"
 #include "qemu/cutils.h"
 
 #if defined(TARGET_S390X)
diff --git a/monitor/monitor.c b/monitor/monitor.c
index 7ed7bd5342..605fe41748 100644
--- a/monitor/monitor.c
+++ b/monitor/monitor.c
@@ -29,7 +29,6 @@
 #include "qapi/qapi-emit-events.h"
 #include "qapi/qapi-visit-control.h"
 #include "qapi/qmp/qdict.h"
-#include "qemu/error-report.h"
 #include "qemu/option.h"
 #include "sysemu/qtest.h"
 #include "trace.h"
diff --git a/monitor/qmp-cmds-control.c b/monitor/qmp-cmds-control.c
index 6e581713a3..f21506efa5 100644
--- a/monitor/qmp-cmds-control.c
+++ b/monitor/qmp-cmds-control.c
@@ -30,7 +30,6 @@
 #include "qapi/error.h"
 #include "qapi/qapi-commands-control.h"
 #include "qapi/qapi-commands-introspect.h"
-#include "qapi/qapi-emit-events.h"
 #include "qapi/qapi-introspect.h"
 #include "qapi/qapi-visit-introspect.h"
 #include "qapi/qobject-input-visitor.h"
diff --git a/monitor/qmp-cmds.c b/monitor/qmp-cmds.c
index bf22a8c5a6..743849c0b5 100644
--- a/monitor/qmp-cmds.c
+++ b/monitor/qmp-cmds.c
@@ -14,29 +14,21 @@
  */
 
 #include "qemu/osdep.h"
-#include "block/blockjob.h"
-#include "qemu/cutils.h"
-#include "qemu/option.h"
 #include "monitor/monitor.h"
 #include "monitor/qmp-helpers.h"
 #include "sysemu/sysemu.h"
-#include "qemu/config-file.h"
-#include "qemu/uuid.h"
 #include "chardev/char.h"
 #include "sysemu/kvm.h"
 #include "sysemu/runstate.h"
 #include "sysemu/runstate-action.h"
-#include "sysemu/blockdev.h"
 #include "sysemu/block-backend.h"
 #include "qapi/error.h"
 #include "qapi/qapi-commands-acpi.h"
-#include "qapi/qapi-commands-block.h"
 #include "qapi/qapi-commands-control.h"
 #include "qapi/qapi-commands-machine.h"
 #include "qapi/qapi-commands-misc.h"
 #include "qapi/qapi-commands-stats.h"
 #include "qapi/type-helpers.h"
-#include "exec/ramlist.h"
 #include "hw/mem/memory-device.h"
 #include "hw/acpi/acpi_dev_interface.h"
 #include "hw/intc/intc.h"
-- 
2.39.0

