Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 536254435F9
	for <lists+kvm@lfdr.de>; Tue,  2 Nov 2021 19:47:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235542AbhKBSth (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Nov 2021 14:49:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:59484 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235918AbhKBStM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Nov 2021 14:49:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635878797;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Sb+JrgSSp9WAPQnhdMXztmNWnmaSMiyfNN+rpG9Ac2w=;
        b=P6IZ4jfm2sX26cpTGEsvbMz0iFkCecHqFNfyIMOcjV0krx7PMsM5238P4J5HzPTkIuQEui
        ZFx5Mzn8FAEiI12ajZeDI3waOGUyGrsXb239fzM5/qX/aPrprPBqyGlJeHdQDa6NFjWh4A
        slufl7/pRayRn9IRQSfysB4nq07zvnY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-125-IO3zarywPr6HtKTOBFc7oA-1; Tue, 02 Nov 2021 14:46:34 -0400
X-MC-Unique: IO3zarywPr6HtKTOBFc7oA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7E79F8799E0;
        Tue,  2 Nov 2021 18:46:32 +0000 (UTC)
Received: from scv.redhat.com (unknown [10.22.11.175])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AA28C19C79;
        Tue,  2 Nov 2021 18:46:07 +0000 (UTC)
From:   John Snow <jsnow@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Peter Maydell <peter.maydell@linaro.org>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Darren Kenny <darren.kenny@oracle.com>,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Qiuhao Li <Qiuhao.Li@outlook.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Alexandre Iooss <erdnaxe@crans.org>,
        Mahmoud Mandour <ma.mandourr@gmail.com>,
        Alexander Bulekov <alxndr@bu.edu>,
        Markus Armbruster <armbru@redhat.com>, kvm@vger.kernel.org,
        Thomas Huth <thuth@redhat.com>, Bandan Das <bsd@redhat.com>,
        John Snow <jsnow@redhat.com>
Subject: [PATCH v5 4/4] docs/sphinx: change default role to "any"
Date:   Tue,  2 Nov 2021 14:44:00 -0400
Message-Id: <20211102184400.1168508-5-jsnow@redhat.com>
In-Reply-To: <20211102184400.1168508-1-jsnow@redhat.com>
References: <20211102184400.1168508-1-jsnow@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This interprets single-backtick syntax in all of our Sphinx docs as a
cross-reference to *something*, including Python symbols.

From here on out, new uses of `backticks` will cause a build failure if
the target cannot be referenced.

Signed-off-by: John Snow <jsnow@redhat.com>
Reviewed-by: Eduardo Habkost <ehabkost@redhat.com>
Reviewed-by: Peter Maydell <peter.maydell@linaro.org>
---
 docs/conf.py | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/docs/conf.py b/docs/conf.py
index ff6e92c6e2..4d9f56601f 100644
--- a/docs/conf.py
+++ b/docs/conf.py
@@ -85,6 +85,11 @@
 # The master toctree document.
 master_doc = 'index'
 
+# Interpret `single-backticks` to be a cross-reference to any kind of
+# referenceable object. Unresolvable or ambiguous references will emit a
+# warning at build time.
+default_role = 'any'
+
 # General information about the project.
 project = u'QEMU'
 copyright = u'2021, The QEMU Project Developers'
-- 
2.31.1

