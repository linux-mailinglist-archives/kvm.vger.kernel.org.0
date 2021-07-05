Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26A963BBB79
	for <lists+kvm@lfdr.de>; Mon,  5 Jul 2021 12:46:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231196AbhGEKtU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jul 2021 06:49:20 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:40035 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231190AbhGEKtT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 5 Jul 2021 06:49:19 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailforward.nyi.internal (Postfix) with ESMTP id 618C119409BD;
        Mon,  5 Jul 2021 06:46:42 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 05 Jul 2021 06:46:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=WSyFBvKjNTyRy9dxJZwN/t3hhKqHdrXbYEIv5+h4b8M=; b=hrIsB282
        XiARxhjwun9tx2bBkj9b1k5YYlQSaQhe7TaRRBxHxlB6677AIItSaD14No6XJTTf
        Z+tYJHxuLB9jq43owkmMLrjC6POjdI4NGRohej9gxfxQ9TXX678cbNzb855TieLg
        U0AZOjwCZwQlFbZ3CNF4OmEyy1JM2ebjiKnILFIffRLR58cCYZ3uwPSCoueesWWG
        T8Syqh5BDjDwitVZQYsYIAkOcQs4BQ31vHmhxqGsPkQhItKLnjNx+t+NfKDr2D0s
        B9p6Exn+kkVHOVuPpxY1oeUEvp6rbDm/B24CkNTb+gyAvvEZH6HXlFnDWuUkze2x
        gA1ojdCSIiGlKg==
X-ME-Sender: <xms:EuPiYGGOKWb1djUmBbwlBuasaR3qutW_olFDmutu8FV-MZHkdMLARw>
    <xme:EuPiYHXh_nx4ez561zGwP27UmUJRb4yuvO9PQsiPw5XksJpKR5-O2Dy8mSCxnEXCA
    zvrt9bFZ36csXbJexA>
X-ME-Received: <xmr:EuPiYAJ1UXyXHYGf3eYq5zY5pviNHMM6XyM17qhec7YH-WaUkt7WmQCQ8e5GQvHDAoprXgt1aJBVtU-BHuEb9v4has2ZGk1y3bdDAxudDbo>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeejgedgfeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeffrghvihgu
    ucfgughmohhnughsohhnuceouggrvhhiugdrvggumhhonhgushhonhesohhrrggtlhgvrd
    gtohhmqeenucggtffrrghtthgvrhhnpedufeetjefgfefhtdejhfehtdfftefhteekhefg
    leehfffhiefhgeelgfejtdehkeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmh
    epmhgrihhlfhhrohhmpegurghvihgurdgvughmohhnughsohhnsehorhgrtghlvgdrtgho
    mh
X-ME-Proxy: <xmx:EuPiYAEKivy34pn2KXWiG3H379lEzVfHrCOBKNGJCcTWS66BmCwiGQ>
    <xmx:EuPiYMXs8t6EUMdiJd0f8o8BEiBLbVlwruI5HVf-M01Rt1cKpIV9hg>
    <xmx:EuPiYDNqqsrlerJHrHACOCogHSC7WggaMQmoeveVrrcLnq7gMBU7Xg>
    <xmx:EuPiYCYl-0m2QtHyJatav1Nn3og4mK95-Ny7AHefoH2ehY3gZjCCww>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 5 Jul 2021 06:46:41 -0400 (EDT)
Received: from localhost (disaster-area.hh.sledj.net [local])
        by disaster-area.hh.sledj.net (OpenSMTPD) with ESMTPA id 9b149bf5;
        Mon, 5 Jul 2021 10:46:32 +0000 (UTC)
From:   David Edmondson <david.edmondson@oracle.com>
To:     qemu-devel@nongnu.org
Cc:     Richard Henderson <richard.henderson@linaro.org>,
        Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, babu.moger@amd.com,
        Cameron Esfahani <dirty@apple.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        David Edmondson <david.edmondson@oracle.com>
Subject: [RFC PATCH 3/8] target/i386: Clarify the padding requirements of X86XSaveArea
Date:   Mon,  5 Jul 2021 11:46:27 +0100
Message-Id: <20210705104632.2902400-4-david.edmondson@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210705104632.2902400-1-david.edmondson@oracle.com>
References: <20210705104632.2902400-1-david.edmondson@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Replace the hard-coded size of offsets or structure elements with
defined constants or sizeof().

Signed-off-by: David Edmondson <david.edmondson@oracle.com>
---
 target/i386/cpu.h | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 6590ad6391..92f9ca264c 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -1329,7 +1329,13 @@ typedef struct X86XSaveArea {
 
     /* AVX State: */
     XSaveAVX avx_state;
-    uint8_t padding[960 - 576 - sizeof(XSaveAVX)];
+
+    /* Ensure that XSaveBNDREG is properly aligned. */
+    uint8_t padding[XSAVE_BNDREG_OFFSET
+                    - sizeof(X86LegacyXSaveArea)
+                    - sizeof(X86XSaveHeader)
+                    - sizeof(XSaveAVX)];
+
     /* MPX State: */
     XSaveBNDREG bndreg_state;
     XSaveBNDCSR bndcsr_state;
-- 
2.30.2

