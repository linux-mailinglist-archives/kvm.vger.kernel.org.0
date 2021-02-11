Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A496431951E
	for <lists+kvm@lfdr.de>; Thu, 11 Feb 2021 22:26:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229933AbhBKVZO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Feb 2021 16:25:14 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26456 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229886AbhBKVZK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 11 Feb 2021 16:25:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613078624;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=el7j+rmZA3EiDQrnbTpaheKflbW47Lq347I0dXbFzvo=;
        b=DC/ncbTOqr3IwAzch22v9kE3+h6vnXqFJxMnbVF07N7DDADuWNrCCdLBNZr127o1kas4hZ
        quEmr/IZfUWiM6Lb+lPMh5bvLFWrocPnMNrdcQoZ/MSaKPs54Pd71fWGq2gA0a28fZhlz9
        djbOQF/JQt6ou9qOs5VvLyvfOL1L3sk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-361-9Hx285pvPc6GFFye5jsYoA-1; Thu, 11 Feb 2021 16:23:41 -0500
X-MC-Unique: 9Hx285pvPc6GFFye5jsYoA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E77DB192D786;
        Thu, 11 Feb 2021 21:23:39 +0000 (UTC)
Received: from gigantic.usersys.redhat.com (helium.bos.redhat.com [10.18.17.132])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7231D60C0F;
        Thu, 11 Feb 2021 21:23:39 +0000 (UTC)
From:   Bandan Das <bsd@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, wei.huang2@amd.com,
        babu.moger@amd.com
Subject: [PATCH 1/3] KVM: Add a stub for invpcid in the emulator table
Date:   Thu, 11 Feb 2021 16:22:37 -0500
Message-Id: <20210211212241.3958897-2-bsd@redhat.com>
In-Reply-To: <20210211212241.3958897-1-bsd@redhat.com>
References: <20210211212241.3958897-1-bsd@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Upon an exception, this can be used to successfully
decode the instruction and will be used by the next patch
to inject the correct exception.

Signed-off-by: Bandan Das <bsd@redhat.com>
---
 arch/x86/kvm/emulate.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 72a1bd04dfe1..78b47fe60239 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -4956,7 +4956,8 @@ static const struct opcode opcode_map_0f_38[256] = {
 	/* 0x00 - 0x7f */
 	X16(N), X16(N), X16(N), X16(N), X16(N), X16(N), X16(N), X16(N),
 	/* 0x80 - 0xef */
-	X16(N), X16(N), X16(N), X16(N), X16(N), X16(N), X16(N),
+	N, N, D(SrcNone | Prot), N, X4(N), X8(N),
+	X16(N), X16(N), X16(N), X16(N), X16(N), X16(N),
 	/* 0xf0 - 0xf1 */
 	GP(EmulateOnUD | ModRM, &three_byte_0f_38_f0),
 	GP(EmulateOnUD | ModRM, &three_byte_0f_38_f1),
-- 
2.24.1

