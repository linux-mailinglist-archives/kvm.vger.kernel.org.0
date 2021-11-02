Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A4D04435F5
	for <lists+kvm@lfdr.de>; Tue,  2 Nov 2021 19:47:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235293AbhKBStf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Nov 2021 14:49:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:45865 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235663AbhKBSsW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Nov 2021 14:48:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635878746;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6odGhqXiSlknlWtZ0hGsFRZjP/jxWLoQjf/KmrWUdtw=;
        b=dXTJPeB4y57uYr9qyG/uHnACOaxvegUcPrZtrJ52Fgv7DKeNn7Kr4xZdHi39Hacqd/fSgD
        tjFjce8vWTG10wTLG3kxGBQQa19CcnZyEimhAO9gzIS/FZNaUi+QE8AUbMtPxLQ9dxRvkC
        c8Jzg72EOfdXnlCBY3jA75n9EOQIpx8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-179-8in5EMOrMIOQRThsqt66GA-1; Tue, 02 Nov 2021 14:45:43 -0400
X-MC-Unique: 8in5EMOrMIOQRThsqt66GA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3349A100C609;
        Tue,  2 Nov 2021 18:45:42 +0000 (UTC)
Received: from scv.redhat.com (unknown [10.22.11.175])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E008C19D9F;
        Tue,  2 Nov 2021 18:44:28 +0000 (UTC)
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
Subject: [PATCH v5 2/4] docs: (further) remove non-reference uses of single backticks
Date:   Tue,  2 Nov 2021 14:43:58 -0400
Message-Id: <20211102184400.1168508-3-jsnow@redhat.com>
In-Reply-To: <20211102184400.1168508-1-jsnow@redhat.com>
References: <20211102184400.1168508-1-jsnow@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The series rotted already. Here's the new changes.

Signed-off-by: John Snow <jsnow@redhat.com>
---
 docs/system/i386/sgx.rst | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/docs/system/i386/sgx.rst b/docs/system/i386/sgx.rst
index f103ae2a2f..9aa161af1a 100644
--- a/docs/system/i386/sgx.rst
+++ b/docs/system/i386/sgx.rst
@@ -77,9 +77,9 @@ CPUID
 
 Due to its myriad dependencies, SGX is currently not listed as supported
 in any of Qemu's built-in CPU configuration. To expose SGX (and SGX Launch
-Control) to a guest, you must either use `-cpu host` to pass-through the
+Control) to a guest, you must either use ``-cpu host`` to pass-through the
 host CPU model, or explicitly enable SGX when using a built-in CPU model,
-e.g. via `-cpu <model>,+sgx` or `-cpu <model>,+sgx,+sgxlc`.
+e.g. via ``-cpu <model>,+sgx`` or ``-cpu <model>,+sgx,+sgxlc``.
 
 All SGX sub-features enumerated through CPUID, e.g. SGX2, MISCSELECT,
 ATTRIBUTES, etc... can be restricted via CPUID flags. Be aware that enforcing
@@ -126,7 +126,7 @@ creating VM with SGX.
 Feature Control
 ~~~~~~~~~~~~~~~
 
-Qemu SGX updates the `etc/msr_feature_control` fw_cfg entry to set the SGX
+Qemu SGX updates the ``etc/msr_feature_control`` fw_cfg entry to set the SGX
 (bit 18) and SGX LC (bit 17) flags based on their respective CPUID support,
 i.e. existing guest firmware will automatically set SGX and SGX LC accordingly,
 assuming said firmware supports fw_cfg.msr_feature_control.
-- 
2.31.1

