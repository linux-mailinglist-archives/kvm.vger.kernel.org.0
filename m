Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C3783731C1
	for <lists+kvm@lfdr.de>; Tue,  4 May 2021 23:07:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232785AbhEDVIP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 May 2021 17:08:15 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:60431 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231445AbhEDVIO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 4 May 2021 17:08:14 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id 5A0635C004F;
        Tue,  4 May 2021 17:07:18 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Tue, 04 May 2021 17:07:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alyssa.is; h=
        from:to:cc:subject:date:message-id:mime-version
        :content-transfer-encoding; s=fm3; bh=iFFbmOLf/h3Zw+C5EIJiz80rZk
        Y5zLat2o7ZrmaK1cc=; b=Q7ej9+PvuQ3oXGi4D+XbGDejqO44VkHTuGljHe2rcw
        bTC6WYqRQFGco289+KoqT0w9hgth/kRImKRV0sAjFaeQXEUlklk7owidPZ/PEmlv
        BkjJXMaFOMY6guEOKslP8wq38cLmfM9nIFT+O395AMC0f+rpv8ApfQBB9VEO6zz+
        ryG66Wme+Q2OmKmtIxO7wQtx21b6fLnISG+RnmXheL2nFJ0glVcDp1ImlpVDIYAK
        aVq0zUL6BTMt/NRIklOVcqJ9ImfSiUfVRR0DrxfHyXQ/M0Mwkr5Dbsf7VBVh+/iH
        mCSLtYb7b/oO6H7qtoXglHjkJyxCGMnxW8bFfa4M2DuQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=iFFbmOLf/h3Zw+C5E
        IJiz80rZkY5zLat2o7ZrmaK1cc=; b=UkDJwjvkBtiX39fUA295U7alLlZsSepnB
        P8f2YjDyPob6vN84nc+EEP+Wf86LiVlly/S//EATIm9VVeVW+uYgtA/2UuqGIqq9
        5BQogUDMjiZ51uiCdthWVzVygjQxMsECCquaypYP7c7f8YANozLZ5lKkrvaXOeki
        02Vq6U4+6AkhIt3w/H8UeWQJQiUe1pUBQhZxeZF/Gu8udQTm0Ybz5YcQbpjRCFbv
        KUi1P9Jq1pSSe8taqEfGLMRKfcSyAbLZpNOp/6g9nO9rFADFYO03fXu9QpBAAhmu
        FcOiW4RgP0EKWftfp7rzHsomuDgdCNGKB6jQSDYAQp/zoFHY+Vv9g==
X-ME-Sender: <xms:hbeRYJGOI0qrHwYbZyKdmkPSWbNMCwIhxiL8fnCR3-ThPAxCUQzT2w>
    <xme:hbeRYOUV3PaoiANeUGR1CpPDCe0msHlmIeGAAr_vXL81rrQm5hvgUhgcqWcZl6Ebz
    23yKKKYX2z1HnHSfg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdefiedgudehkecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefhvffufffkofgggfestdekredtredttdenucfhrhhomheptehlhihsshgr
    ucftohhsshcuoehhihesrghlhihsshgrrdhisheqnecuggftrfgrthhtvghrnhephedvff
    fghfetieejgfetfedtgffhvdehueehvdejudfggefgleejgfelfeevgfefnecukfhppeek
    gedrudekgedrvddviedrkedunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepqhihlhhishhssegvvhgvrdhqhihlihhsshdrnhgvth
X-ME-Proxy: <xmx:hbeRYLJo3ZON7V_Tcgx-5GONWLSVw2t5r5MYqOghosaMrKLK9z7lnw>
    <xmx:hbeRYPHrUAYY9gLWaytsrOFewkDKyp7MQetXuz6Zcs7IyhG1NXmoZQ>
    <xmx:hbeRYPW_3iAQOlrcUMSXtzZs_MrnpWChoFkgGDz6NNJUMZFrb0xmXQ>
    <xmx:hreRYGckJfd9BxlqkY68kPb9ZcKiEWGVmC4KatYDRlIDKkGthInCMw>
Received: from eve.qyliss.net (p54b8e251.dip0.t-ipconnect.de [84.184.226.81])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Tue,  4 May 2021 17:07:17 -0400 (EDT)
Received: by eve.qyliss.net (Postfix, from userid 1000)
        id B6ADB1122; Tue,  4 May 2021 21:07:15 +0000 (UTC)
From:   Alyssa Ross <hi@alyssa.is>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: [PATCH] docs: vfio: fix typo
Date:   Tue,  4 May 2021 21:06:51 +0000
Message-Id: <20210504210651.1316078-1-hi@alyssa.is>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Alyssa Ross <hi@alyssa.is>
---
 Documentation/driver-api/vfio.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/driver-api/vfio.rst b/Documentation/driver-api/vfio.rst
index decc68cb8114a..606eed8823cea 100644
--- a/Documentation/driver-api/vfio.rst
+++ b/Documentation/driver-api/vfio.rst
@@ -2,7 +2,7 @@
 VFIO - "Virtual Function I/O" [1]_
 ==================================
 
-Many modern system now provide DMA and interrupt remapping facilities
+Many modern systems now provide DMA and interrupt remapping facilities
 to help ensure I/O devices behave within the boundaries they've been
 allotted.  This includes x86 hardware with AMD-Vi and Intel VT-d,
 POWER systems with Partitionable Endpoints (PEs) and embedded PowerPC
-- 
2.31.0

