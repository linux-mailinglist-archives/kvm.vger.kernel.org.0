Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD14638B26C
	for <lists+kvm@lfdr.de>; Thu, 20 May 2021 17:03:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231751AbhETPER (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 May 2021 11:04:17 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:52717 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238934AbhETPEF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 20 May 2021 11:04:05 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailforward.nyi.internal (Postfix) with ESMTP id 0DC6319409D4;
        Thu, 20 May 2021 10:56:53 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Thu, 20 May 2021 10:56:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=poNg7U/mGTsC6AfH6IgGW4okeP0nr6H5S/5XCFk7138=; b=FzP7BDdQ
        8JwfAwM+bjjR216tK6QSk5usAjR0hQf6VmtqMMV2iu5S6U6fntKcF/yxPXCjnICb
        7Q/wacFePcP614s7NFHDaIMj7S+d0V7DEBiM+JpcrDTgW1ri94jaUdPnitWS6rOP
        Z99xJLf7Ck3Y9L1HEzPXtQaVhOj5imFk3D9mi2Ob6kQLMG7VyJqLKONAaRBLd8zo
        V/N6dzbfsOD+1ouN/Plu5xtSJ1g/KInF6VHn9HwlVP+iGPc/OgqR0ZZQSSC22JC1
        ycLShUyd67F4AnKStYKnNngrD9SrNbFCG9wmzmgCkvyff/tKsa5SnSs3PVXIWzAQ
        29fa2Oo5KI98QQ==
X-ME-Sender: <xms:tHimYLtFZbNvJNXt40q547HIws7WidfnyS8k6NQDwt1VKYKDYZV6ig>
    <xme:tHimYMfOHhnN1dVcqL2kKTEYiysrPnwKmxel1DnfYY6MOFymuoDezDnZzOwXnjmFA
    23EQ9lJyuYv0jpFzdA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdejuddgkedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeffrghvihgu
    ucfgughmohhnughsohhnuceouggrvhhiugdrvggumhhonhgushhonhesohhrrggtlhgvrd
    gtohhmqeenucggtffrrghtthgvrhhnpedufeetjefgfefhtdejhfehtdfftefhteekhefg
    leehfffhiefhgeelgfejtdehkeenucfkphepkedurddukeejrddviedrvdefkeenucevlh
    hushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegurghvihgurdgv
    ughmohhnughsohhnsehorhgrtghlvgdrtghomh
X-ME-Proxy: <xmx:tHimYOwsuYjBHvYo-VBU_STUczAec-WedbLs-Nng3RPlgoYitUDk1w>
    <xmx:tHimYKOUp-s1lAMSK8PgXe3zGjL8fnFOW4NGTyN-9gI2NoCgrOGwbg>
    <xmx:tHimYL9_bIK1pRh5Ik28Gj6Zvig7dfo9_fo8QLZQnWYpy3wmG1V2Yg>
    <xmx:tXimYBc24TujmhAj4dznKpNAYJMSBvppCYral-R8RbE13Yh0DY169A>
Received: from disaster-area.hh.sledj.net (disaster-area.hh.sledj.net [81.187.26.238])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Thu, 20 May 2021 10:56:51 -0400 (EDT)
Received: from localhost (disaster-area.hh.sledj.net [local])
        by disaster-area.hh.sledj.net (OpenSMTPD) with ESMTPA id d0ac2af4;
        Thu, 20 May 2021 14:56:47 +0000 (UTC)
From:   David Edmondson <david.edmondson@oracle.com>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, Eduardo Habkost <ehabkost@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Babu Moger <babu.moger@amd.com>,
        David Edmondson <david.edmondson@oracle.com>
Subject: [RFC PATCH 3/7] target/i386: Clarify the padding requirements of X86XSaveArea
Date:   Thu, 20 May 2021 15:56:43 +0100
Message-Id: <20210520145647.3483809-4-david.edmondson@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210520145647.3483809-1-david.edmondson@oracle.com>
References: <20210520145647.3483809-1-david.edmondson@oracle.com>
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
index 1fb732f366..0bb365bddf 100644
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

