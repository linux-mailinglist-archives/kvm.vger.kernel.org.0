Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED6AF155959
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 15:28:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727567AbgBGO1i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 09:27:38 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:53012 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726954AbgBGO1h (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Feb 2020 09:27:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581085656;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qiK/lmlfrN/JxSjXimHgPseTW/zKqi0hu/Do0uqZTP8=;
        b=SFiXBUKrZekbGsLFvkAlWFe/ArsYyfvZP5D27lIchSCDQRX7PBTemglJ+5T8sEfm7A3k4Z
        gWG2DQFtta0lIdzamaj/yrY6FTLce5F42IG4sElZAMLAzCLU1FRmAuUumc4N4oG229iXVo
        uF4mJwwMbx1Ud2jXXW9F9a7QTXj4pto=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-288-nLENlNXfNEGQaa9wEjiSUA-1; Fri, 07 Feb 2020 09:27:35 -0500
X-MC-Unique: nLENlNXfNEGQaa9wEjiSUA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D214C184AED2;
        Fri,  7 Feb 2020 14:27:33 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-116-37.ams2.redhat.com [10.36.116.37])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4968160BEC;
        Fri,  7 Feb 2020 14:27:28 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com, vkuznets@redhat.com
Cc:     thuth@redhat.com, drjones@redhat.com, wei.huang2@amd.com,
        krish.sadhukhan@oracle.com
Subject: [PATCH v5 2/4] selftests: KVM: Remove unused x86_register enum
Date:   Fri,  7 Feb 2020 15:27:13 +0100
Message-Id: <20200207142715.6166-3-eric.auger@redhat.com>
In-Reply-To: <20200207142715.6166-1-eric.auger@redhat.com>
References: <20200207142715.6166-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

x86_register enum is not used. Its presence incites us
to enumerate GPRs in the same order in other looming
structs. So let's remove it.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Suggested-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 .../selftests/kvm/include/x86_64/processor.h  | 20 -------------------
 1 file changed, 20 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/too=
ls/testing/selftests/kvm/include/x86_64/processor.h
index 6f7fffaea2e8..e48dac5c29e8 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -36,26 +36,6 @@
 #define X86_CR4_SMAP		(1ul << 21)
 #define X86_CR4_PKE		(1ul << 22)
=20
-/* The enum values match the intruction encoding of each register */
-enum x86_register {
-	RAX =3D 0,
-	RCX,
-	RDX,
-	RBX,
-	RSP,
-	RBP,
-	RSI,
-	RDI,
-	R8,
-	R9,
-	R10,
-	R11,
-	R12,
-	R13,
-	R14,
-	R15,
-};
-
 struct desc64 {
 	uint16_t limit0;
 	uint16_t base0;
--=20
2.20.1

