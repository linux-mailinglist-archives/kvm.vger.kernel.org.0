Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1BB236D98B
	for <lists+kvm@lfdr.de>; Wed, 28 Apr 2021 16:27:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231585AbhD1OZW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Apr 2021 10:25:22 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:32831 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229520AbhD1OZV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 28 Apr 2021 10:25:21 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailforward.west.internal (Postfix) with ESMTP id C9809B64;
        Wed, 28 Apr 2021 10:24:35 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Wed, 28 Apr 2021 10:24:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=HQQ7SpOqqpIwy1otx
        y1mWGf90mk55isIJKpzIEWUu1w=; b=O+5/nHzHlRhTl3zn3jPZx5Ni81cln3oao
        vlOjqg6LWgvXJrqOv8obs4fRaPxz2cPnvQXpHhSsJht3lZcjlUf1MSaK0iclkiUF
        PrAhdUPFdQczW7hfLE2ifucktETeVqwE23oVIkfz7W6teKVNkMwWExUxj9oFiizs
        d3+tuqhNAptxyeK+MXLL+5XAJsPSYGcoBYGaK4TmsT1P2Png2jja/qV+W2X3dNdM
        ENpqomCe0HBJrOeyYZ5IwPlTzKlKKFfPCqaU16ZBlu59t1ScQZK0rFUEv/vVrDCx
        lXMhsv6CEQjEk6n2ku+J/28OujVljr2mMVXFEQi3QXe5rtl4Wrv8g==
X-ME-Sender: <xms:InCJYDrxundC7WYciFjOmv2ygrpJ74plT-1tgE3QNiT86yqRcU3wgw>
    <xme:InCJYNrtwORwdx_yk2wjh8CKyGszyCTLjkQ12WUX8kL-biEnYSlvX9qngaQbTxwA2
    yOC0iKheOpqdbgNaME>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvddvvddgheduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkffoggfgsedtkeertdertddtnecuhfhrohhmpeffrghvihguucfg
    ughmohhnughsohhnuceouggrvhhiugdrvggumhhonhgushhonhesohhrrggtlhgvrdgtoh
    hmqeenucggtffrrghtthgvrhhnpeduhfetvdfhgfeltddtgeelheetveeufeegteevtddu
    iedvgeejhfdukeegteehheenucfkphepkedurddukeejrddviedrvdefkeenucevlhhush
    htvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegurghvihgurdgvughm
    ohhnughsohhnsehorhgrtghlvgdrtghomh
X-ME-Proxy: <xmx:InCJYAN6LwT4F_kI-ZrSJDsYSOal9EHWCwOLABuSbw5efip584eLXA>
    <xmx:InCJYG4Rfck2DvMzNI4VuZbwFJTvMLIMgIkQOv9owGXXOV6tFyRLNw>
    <xmx:InCJYC4EldmNbbTlIWMexAUYRyxGTgAazj-35dUTwHF2DNTm86TwQQ>
    <xmx:I3CJYPz9HB7OH-lak-hCi56L6NnX36Ww0D5UBexpmEW3ItPFvTAyRZq_yO0>
Received: from disaster-area.hh.sledj.net (disaster-area.hh.sledj.net [81.187.26.238])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 28 Apr 2021 10:24:33 -0400 (EDT)
Received: from localhost (disaster-area.hh.sledj.net [local])
        by disaster-area.hh.sledj.net (OpenSMTPD) with ESMTPA id b1bbd0bf;
        Wed, 28 Apr 2021 14:24:31 +0000 (UTC)
From:   David Edmondson <david.edmondson@oracle.com>
To:     qemu-devel@nongnu.org
Cc:     qemu-trivial@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        kvm@vger.kernel.org, David Edmondson <david.edmondson@oracle.com>
Subject: [PATCH] accel: kvm: clarify that extra exit data is hexadecimal
Date:   Wed, 28 Apr 2021 15:24:31 +0100
Message-Id: <20210428142431.266879-1-david.edmondson@oracle.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When dumping the extra exit data provided by KVM, make it clear that
the data is hexadecimal.

At the same time, zero-pad the output.

Signed-off-by: David Edmondson <david.edmondson@oracle.com>
---
 accel/kvm/kvm-all.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index b6d9f92f15..93d7cbfeaf 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -2269,7 +2269,7 @@ static int kvm_handle_internal_error(CPUState *cpu, struct kvm_run *run)
         int i;
 
         for (i = 0; i < run->internal.ndata; ++i) {
-            fprintf(stderr, "extra data[%d]: %"PRIx64"\n",
+            fprintf(stderr, "extra data[%d]: 0x%016"PRIx64"\n",
                     i, (uint64_t)run->internal.data[i]);
         }
     }
-- 
2.30.2

