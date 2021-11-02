Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CB074435F6
	for <lists+kvm@lfdr.de>; Tue,  2 Nov 2021 19:47:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235525AbhKBStf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Nov 2021 14:49:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:52946 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235820AbhKBSsr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Nov 2021 14:48:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635878771;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=i2KW2wCuNVxgmC1cz78ZXb1YV27huKZjMrxsF06sZME=;
        b=KQ5YbZte31JuzCXWLVQM7vMcsoBWJREoF3iW+8e650+meCBlhkp2+OaS2Ty2wcBXjQABbr
        raPGawXoFdT9KzmcOh8T+KFur8r8Ubwb++pQ6wtdQJYNaj41RBDAE0Ifzk8Ym+oERW1K1/
        waWZRpb3DPSZUAnPemoEvOxO47ncD4k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-502-LlDw0qBWPHmxS8pi1BI-Hw-1; Tue, 02 Nov 2021 14:46:08 -0400
X-MC-Unique: LlDw0qBWPHmxS8pi1BI-Hw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 24D5D872FF7;
        Tue,  2 Nov 2021 18:46:07 +0000 (UTC)
Received: from scv.redhat.com (unknown [10.22.11.175])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 76A1F19C79;
        Tue,  2 Nov 2021 18:45:42 +0000 (UTC)
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
Subject: [PATCH v5 3/4] docs: (further further) remove non-reference uses of single backticks
Date:   Tue,  2 Nov 2021 14:43:59 -0400
Message-Id: <20211102184400.1168508-4-jsnow@redhat.com>
In-Reply-To: <20211102184400.1168508-1-jsnow@redhat.com>
References: <20211102184400.1168508-1-jsnow@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: John Snow <jsnow@redhat.com>
---
 docs/devel/build-system.rst | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/docs/devel/build-system.rst b/docs/devel/build-system.rst
index 7f106d2f1c..48e56d7ea9 100644
--- a/docs/devel/build-system.rst
+++ b/docs/devel/build-system.rst
@@ -47,16 +47,17 @@ command line options for which a same-named Meson option exists;
 dashes in the command line are replaced with underscores.
 
 Many checks on the compilation environment are still found in configure
-rather than `meson.build`, but new checks should be added directly to
-`meson.build`.
+rather than ``meson.build``, but new checks should be added directly to
+``meson.build``.
 
 Patches are also welcome to move existing checks from the configure
-phase to `meson.build`.  When doing so, ensure that `meson.build` does
-not use anymore the keys that you have removed from `config-host.mak`.
-Typically these will be replaced in `meson.build` by boolean variables,
-``get_option('optname')`` invocations, or `dep.found()` expressions.
-In general, the remaining checks have little or no interdependencies,
-so they can be moved one by one.
+phase to ``meson.build``.  When doing so, ensure that ``meson.build``
+does not use anymore the keys that you have removed from
+``config-host.mak``.  Typically these will be replaced in
+``meson.build`` by boolean variables, ``get_option('optname')``
+invocations, or ``dep.found()`` expressions.  In general, the remaining
+checks have little or no interdependencies, so they can be moved one by
+one.
 
 Helper functions
 ----------------
@@ -298,7 +299,7 @@ comprises the following tasks:
 
  - Add code to perform the actual feature check.
 
- - Add code to include the feature status in `config-host.h`
+ - Add code to include the feature status in ``config-host.h``
 
  - Add code to print out the feature status in the configure summary
    upon completion.
@@ -334,7 +335,7 @@ The other supporting code is generally simple::
 
 For the configure script to parse the new option, the
 ``scripts/meson-buildoptions.sh`` file must be up-to-date; ``make
-update-buildoptions`` (or just `make`) will take care of updating it.
+update-buildoptions`` (or just ``make``) will take care of updating it.
 
 
 Support scripts
-- 
2.31.1

