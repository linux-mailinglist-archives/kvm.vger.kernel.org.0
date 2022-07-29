Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E02DD585042
	for <lists+kvm@lfdr.de>; Fri, 29 Jul 2022 15:02:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236153AbiG2NCB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Jul 2022 09:02:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233298AbiG2NB7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Jul 2022 09:01:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C036141989
        for <kvm@vger.kernel.org>; Fri, 29 Jul 2022 06:01:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659099717;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zfBj2dukqQ4kZ7VLpFBfHwX7ASII+ml/rI5VzDxjf8I=;
        b=BxfCoWMKkmDu6s1G0ghOJ9K0ST8EPXUjyf1Hh0sty1/VN3zDSsBEcArDcfoGKfzj1cXLFE
        meaX+XlJZIsOdD70A8OjZcxIIkEUCoq8BLar/OLCHljpOnozx8yqS4VaLFFhwebHkhru67
        pV43zPpHA3kyc6uDjS++6hN2EEoApdI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-658-2GM31qhGMgqqUdocz3QFHw-1; Fri, 29 Jul 2022 09:01:54 -0400
X-MC-Unique: 2GM31qhGMgqqUdocz3QFHw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8D92B3C025C1;
        Fri, 29 Jul 2022 13:01:53 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.53])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2FFAC2026D64;
        Fri, 29 Jul 2022 13:01:44 +0000 (UTC)
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
Subject: [RFC v2 05/10] static-analyzer: Enforce coroutine_fn restrictions for direct calls
Date:   Fri, 29 Jul 2022 14:00:34 +0100
Message-Id: <20220729130040.1428779-6-afaria@redhat.com>
In-Reply-To: <20220729130040.1428779-1-afaria@redhat.com>
References: <20220729130040.1428779-1-afaria@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a "coroutine_fn" check to static-analyzer.py that ensures that
non-coroutine_fn functions don't perform direct calls to coroutine_fn
functions.

For the few cases where this must happen, introduce an
__allow_coroutine_fn_call() macro that wraps offending calls and
overrides the static analyzer.

Signed-off-by: Alberto Faria <afaria@redhat.com>
---
 include/qemu/coroutine.h        |  13 +++
 static_analyzer/__init__.py     |  46 ++++++++-
 static_analyzer/coroutine_fn.py | 173 ++++++++++++++++++++++++++++++++
 3 files changed, 231 insertions(+), 1 deletion(-)
 create mode 100644 static_analyzer/coroutine_fn.py

diff --git a/include/qemu/coroutine.h b/include/qemu/coroutine.h
index 08c5bb3c76..40a4037525 100644
--- a/include/qemu/coroutine.h
+++ b/include/qemu/coroutine.h
@@ -42,7 +42,20 @@
  *       ....
  *   }
  */
+#ifdef __clang__
+#define coroutine_fn __attribute__((__annotate__("coroutine_fn")))
+#else
 #define coroutine_fn
+#endif
+
+/**
+ * This can wrap a call to a coroutine_fn from a non-coroutine_fn function and
+ * suppress the static analyzer's complaints.
+ *
+ * You don't want to use this.
+ */
+#define __allow_coroutine_fn_call(call) \
+    ((void)"__allow_coroutine_fn_call", call)
 
 typedef struct Coroutine Coroutine;
 
diff --git a/static_analyzer/__init__.py b/static_analyzer/__init__.py
index 36028724b1..5abdbd21a3 100644
--- a/static_analyzer/__init__.py
+++ b/static_analyzer/__init__.py
@@ -23,8 +23,9 @@
 from clang.cindex import (  # type: ignore
     Cursor,
     CursorKind,
-    TranslationUnit,
     SourceLocation,
+    TranslationUnit,
+    TypeKind,
     conf,
 )
 
@@ -146,6 +147,49 @@ def matcher(n: Cursor) -> bool:
     return any(map(matcher, node.get_children()))
 
 
+def is_annotated_with(node: Cursor, annotation: str) -> bool:
+    return any(is_annotation(c, annotation) for c in node.get_children())
+
+
+def is_annotation(node: Cursor, annotation: str) -> bool:
+    return node.kind == CursorKind.ANNOTATE_ATTR and node.spelling == annotation
+
+
+def is_comma_wrapper(node: Cursor, literal: str) -> bool:
+    """
+    Check if `node` is a "comma-wrapper" with the given string literal.
+
+    A "comma-wrapper" is the pattern `((void)string_literal, expr)`. The `expr`
+    is said to be "comma-wrapped".
+    """
+
+    # TODO: Do we need to check that the operator is `,`? Is there another
+    # operator that can combine void and an expr?
+
+    if node.kind != CursorKind.BINARY_OPERATOR:
+        return False
+
+    [left, _right] = node.get_children()
+
+    if (
+        left.kind != CursorKind.CSTYLE_CAST_EXPR
+        or left.type.kind != TypeKind.VOID
+    ):
+        return False
+
+    [unexposed_expr] = left.get_children()
+
+    if unexposed_expr.kind != CursorKind.UNEXPOSED_EXPR:
+        return False
+
+    [string_literal] = unexposed_expr.get_children()
+
+    return (
+        string_literal.kind == CursorKind.STRING_LITERAL
+        and string_literal.spelling == f'"{literal}"'
+    )
+
+
 # ---------------------------------------------------------------------------- #
 # Checks
 
diff --git a/static_analyzer/coroutine_fn.py b/static_analyzer/coroutine_fn.py
new file mode 100644
index 0000000000..f70a3167eb
--- /dev/null
+++ b/static_analyzer/coroutine_fn.py
@@ -0,0 +1,173 @@
+# ---------------------------------------------------------------------------- #
+
+from clang.cindex import Cursor, CursorKind, TypeKind  # type: ignore
+
+from static_analyzer import (
+    CheckContext,
+    VisitorResult,
+    check,
+    is_annotated_with,
+    is_annotation,
+    is_comma_wrapper,
+    visit,
+)
+
+# ---------------------------------------------------------------------------- #
+
+
+@check("coroutine_fn")
+def check_coroutine_fn(context: CheckContext) -> None:
+    """Reports violations of coroutine_fn rules."""
+
+    def visitor(node: Cursor) -> VisitorResult:
+
+        validate_annotations(context, node)
+
+        if node.kind == CursorKind.FUNCTION_DECL and node.is_definition():
+            check_direct_calls(context, node)
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
+    if is_annotation(node, "coroutine_fn") and (
+        node.parent is None or not is_valid_coroutine_fn_usage(node.parent)
+    ):
+        context.report(node, "invalid coroutine_fn usage")
+
+    if is_comma_wrapper(
+        node, "__allow_coroutine_fn_call"
+    ) and not is_valid_allow_coroutine_fn_call_usage(node):
+        context.report(node, "invalid __allow_coroutine_fn_call usage")
+
+    # reject re-declarations with inconsistent annotations
+
+    if node.kind == CursorKind.FUNCTION_DECL and is_coroutine_fn(
+        node
+    ) != is_coroutine_fn(node.canonical):
+        context.report(
+            node,
+            f"coroutine_fn annotation disagreement with"
+            f" {context.format_location(node.canonical)}",
+        )
+
+
+def check_direct_calls(context: CheckContext, caller: Cursor) -> None:
+    """
+    Reject calls from non-coroutine_fn to coroutine_fn.
+
+    Assumes that `caller` is a function definition.
+    """
+
+    if not is_coroutine_fn(caller):
+
+        def visitor(node: Cursor) -> VisitorResult:
+
+            # We can get "calls" that are actually things like top-level macro
+            # invocations for which `node.referenced` is None.
+
+            if (
+                node.kind == CursorKind.CALL_EXPR
+                and node.referenced is not None
+                and is_coroutine_fn(node.referenced.canonical)
+                and not is_comma_wrapper(
+                    node.parent, "__allow_coroutine_fn_call"
+                )
+            ):
+                context.report(
+                    node,
+                    f"non-coroutine_fn function calls coroutine_fn"
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
+def is_valid_coroutine_fn_usage(parent: Cursor) -> bool:
+    """
+    Check if an occurrence of `coroutine_fn` represented by a node with parent
+    `parent` appears at a valid point in the AST. This is the case if `parent`
+    is:
+
+      - A function declaration/definition, OR
+      - A field/variable/parameter declaration with a function pointer type, OR
+      - A typedef of a function type or function pointer type.
+    """
+
+    if parent.kind == CursorKind.FUNCTION_DECL:
+        return True
+
+    canonical_type = parent.type.get_canonical()
+
+    def parent_type_is_function() -> bool:
+        return canonical_type.kind == TypeKind.FUNCTIONPROTO
+
+    def parent_type_is_function_pointer() -> bool:
+        return (
+            canonical_type.kind == TypeKind.POINTER
+            and canonical_type.get_pointee().kind == TypeKind.FUNCTIONPROTO
+        )
+
+    if parent.kind in [
+        CursorKind.FIELD_DECL,
+        CursorKind.VAR_DECL,
+        CursorKind.PARM_DECL,
+    ]:
+        return parent_type_is_function_pointer()
+
+    if parent.kind == CursorKind.TYPEDEF_DECL:
+        return parent_type_is_function() or parent_type_is_function_pointer()
+
+    return False
+
+
+def is_valid_allow_coroutine_fn_call_usage(node: Cursor) -> bool:
+    """
+    Check if an occurrence of `__allow_coroutine_fn_call()` represented by node
+    `node` appears at a valid point in the AST. This is the case if its right
+    operand is a call to:
+
+      - A function declared with the `coroutine_fn` annotation.
+
+    TODO: Ensure that `__allow_coroutine_fn_call()` is in the body of a
+    non-`coroutine_fn` function.
+    """
+
+    [_, call] = node.get_children()
+
+    return call.kind == CursorKind.CALL_EXPR and is_coroutine_fn(
+        call.referenced
+    )
+
+
+def is_coroutine_fn(node: Cursor) -> bool:
+    """
+    Check whether the given `node` should be considered to be `coroutine_fn`.
+
+    This assumes valid usage of `coroutine_fn`.
+    """
+
+    while node.kind in [CursorKind.PAREN_EXPR, CursorKind.UNEXPOSED_EXPR]:
+        children = list(node.get_children())
+        if len(children) == 1:
+            node = children[0]
+        else:
+            break
+
+    return node.kind == CursorKind.FUNCTION_DECL and is_annotated_with(
+        node, "coroutine_fn"
+    )
+
+
+# ---------------------------------------------------------------------------- #
-- 
2.37.1

