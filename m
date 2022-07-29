Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 019C0585046
	for <lists+kvm@lfdr.de>; Fri, 29 Jul 2022 15:02:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236180AbiG2NCn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Jul 2022 09:02:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236156AbiG2NCm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Jul 2022 09:02:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7871B43E50
        for <kvm@vger.kernel.org>; Fri, 29 Jul 2022 06:02:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659099759;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sI4aCnSMA+BvrmdoDJRWnmGxfHh7axdbldq8+XuTM40=;
        b=VNu8k0dFqUTTy1pHDxKEiPsop2c90hC0LVOgo6pegd+HcS0lLr/nhUjfaXmenuGdfUzLjO
        ZkBDCG30A7x6MuaypLtM+tekjma6iD+dHTw+9muvW4WvaaT+8B180G0gQ1vfjsEgL2vffD
        8hmH51SNrOI0mBgYwoIRrTORSnphpxQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-561-vCtggVAWPeiREpwbgsS3mg-1; Fri, 29 Jul 2022 09:02:36 -0400
X-MC-Unique: vCtggVAWPeiREpwbgsS3mg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1AF921C0513A;
        Fri, 29 Jul 2022 13:02:34 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.53])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 91BA32026D64;
        Fri, 29 Jul 2022 13:02:24 +0000 (UTC)
From:   Alberto Faria <afaria@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Hannes Reinecke <hare@suse.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>,
        "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
        Peter Lieven <pl@kamp.de>, kvm@vger.kernel.org,
        Xie Yongji <xieyongji@bytedance.com>,
        Eric Auger <eric.auger@redhat.com>,
        Hanna Reitz <hreitz@redhat.com>,
        Jeff Cody <codyprime@gmail.com>,
        Eric Blake <eblake@redhat.com>,
        "Denis V. Lunev" <den@openvz.org>,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Christian Schoenebeck <qemu_oss@crudebyte.com>,
        Stefan Weil <sw@weilnetz.de>, Klaus Jensen <its@irrelevant.dk>,
        Laurent Vivier <lvivier@redhat.com>,
        Alberto Garcia <berto@igalia.com>,
        Michael Roth <michael.roth@amd.com>,
        Juan Quintela <quintela@redhat.com>,
        David Hildenbrand <david@redhat.com>, qemu-block@nongnu.org,
        Konstantin Kostiuk <kkostiuk@redhat.com>,
        Kevin Wolf <kwolf@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Greg Kurz <groug@kaod.org>,
        "Michael S. Tsirkin" <mst@redhat.com>, Amit Shah <amit@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Raphael Norwitz <raphael.norwitz@nutanix.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Jason Wang <jasowang@redhat.com>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Dmitry Fleytman <dmitry.fleytman@gmail.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        Fam Zheng <fam@euphon.net>, Thomas Huth <thuth@redhat.com>,
        Keith Busch <kbusch@kernel.org>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        "Richard W.M. Jones" <rjones@redhat.com>,
        John Snow <jsnow@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Alberto Faria <afaria@redhat.com>
Subject: [RFC v2 09/10] block: Add no_coroutine_fn marker
Date:   Fri, 29 Jul 2022 14:00:38 +0100
Message-Id: <20220729130040.1428779-10-afaria@redhat.com>
In-Reply-To: <20220729130040.1428779-1-afaria@redhat.com>
References: <20220729130040.1428779-1-afaria@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When applied to a function, it advertises that it should not be called
from coroutine_fn functions.

Make generated_co_wrapper evaluate to no_coroutine_fn, as coroutine_fn
functions should instead directly call the coroutine_fn that backs the
generated_co_wrapper.

Add a "no_coroutine_fn" check to static-analyzer.py that enforces
no_coroutine_fn rules.

Signed-off-by: Alberto Faria <afaria@redhat.com>
---
 include/block/block-common.h       |   2 +-
 include/qemu/coroutine.h           |  12 ++++
 static_analyzer/no_coroutine_fn.py | 111 +++++++++++++++++++++++++++++
 3 files changed, 124 insertions(+), 1 deletion(-)
 create mode 100644 static_analyzer/no_coroutine_fn.py

diff --git a/include/block/block-common.h b/include/block/block-common.h
index fdb7306e78..4b60c8c6f2 100644
--- a/include/block/block-common.h
+++ b/include/block/block-common.h
@@ -42,7 +42,7 @@
  *
  * Read more in docs/devel/block-coroutine-wrapper.rst
  */
-#define generated_co_wrapper
+#define generated_co_wrapper no_coroutine_fn
 
 /* block.c */
 typedef struct BlockDriver BlockDriver;
diff --git a/include/qemu/coroutine.h b/include/qemu/coroutine.h
index 26445b3176..c61dd2d3f7 100644
--- a/include/qemu/coroutine.h
+++ b/include/qemu/coroutine.h
@@ -48,6 +48,18 @@
 #define coroutine_fn
 #endif
 
+/**
+ * Mark a function that should never be called from a coroutine context
+ *
+ * This typically means that there is an analogous, coroutine_fn function that
+ * should be used instead.
+ */
+#ifdef __clang__
+#define no_coroutine_fn __attribute__((__annotate__("no_coroutine_fn")))
+#else
+#define no_coroutine_fn
+#endif
+
 /**
  * This can wrap a call to a coroutine_fn from a non-coroutine_fn function and
  * suppress the static analyzer's complaints.
diff --git a/static_analyzer/no_coroutine_fn.py b/static_analyzer/no_coroutine_fn.py
new file mode 100644
index 0000000000..1d0b93bb62
--- /dev/null
+++ b/static_analyzer/no_coroutine_fn.py
@@ -0,0 +1,111 @@
+# ---------------------------------------------------------------------------- #
+
+from clang.cindex import Cursor, CursorKind  # type: ignore
+
+from static_analyzer import (
+    CheckContext,
+    VisitorResult,
+    check,
+    is_annotation,
+    is_annotated_with,
+    visit,
+)
+from static_analyzer.coroutine_fn import is_coroutine_fn
+
+# ---------------------------------------------------------------------------- #
+
+
+@check("no_coroutine_fn")
+def check_no_coroutine_fn(context: CheckContext) -> None:
+    """Reports violations of no_coroutine_fn rules."""
+
+    def visitor(node: Cursor) -> VisitorResult:
+
+        validate_annotations(context, node)
+
+        if node.kind == CursorKind.FUNCTION_DECL and node.is_definition():
+            check_calls(context, node)
+            return VisitorResult.CONTINUE
+
+        return VisitorResult.RECURSE
+
+    visit(context.translation_unit.cursor, visitor)
+
+
+def validate_annotations(context: CheckContext, node: Cursor) -> None:
+
+    # validate annotation usage
+
+    if is_annotation(node, "no_coroutine_fn") and (
+        node.parent is None or not is_valid_no_coroutine_fn_usage(node.parent)
+    ):
+        context.report(node, "invalid no_coroutine_fn usage")
+
+    # reject re-declarations with inconsistent annotations
+
+    if node.kind == CursorKind.FUNCTION_DECL and is_no_coroutine_fn(
+        node
+    ) != is_no_coroutine_fn(node.canonical):
+
+        context.report(
+            node,
+            f"no_coroutine_fn annotation disagreement with"
+            f" {context.format_location(node.canonical)}",
+        )
+
+
+def check_calls(context: CheckContext, caller: Cursor) -> None:
+    """
+    Reject calls from coroutine_fn to no_coroutine_fn.
+
+    Assumes that `caller` is a function definition.
+    """
+
+    if is_coroutine_fn(caller):
+
+        def visitor(node: Cursor) -> VisitorResult:
+
+            # We can get some "calls" that are actually things like top-level
+            # macro invocations for which `node.referenced` is None.
+
+            if (
+                node.kind == CursorKind.CALL_EXPR
+                and node.referenced is not None
+                and is_no_coroutine_fn(node.referenced.canonical)
+            ):
+                context.report(
+                    node,
+                    f"coroutine_fn calls no_coroutine_fn function"
+                    f" {node.referenced.spelling}()",
+                )
+
+            return VisitorResult.RECURSE
+
+        visit(caller, visitor)
+
+
+# ---------------------------------------------------------------------------- #
+
+
+def is_valid_no_coroutine_fn_usage(parent: Cursor) -> bool:
+    """
+    Checks if an occurrence of `no_coroutine_fn` represented by a node with
+    parent `parent` appears at a valid point in the AST. This is the case if the
+    parent is a function declaration/definition.
+    """
+
+    return parent.kind == CursorKind.FUNCTION_DECL
+
+
+def is_no_coroutine_fn(node: Cursor) -> bool:
+    """
+    Checks whether the given `node` should be considered to be
+    `no_coroutine_fn`.
+
+    This assumes valid usage of `no_coroutine_fn`.
+    """
+
+    return is_annotated_with(node, "no_coroutine_fn")
+
+
+# ---------------------------------------------------------------------------- #
-- 
2.37.1

