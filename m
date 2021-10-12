Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8DBD42A58E
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 15:23:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236878AbhJLNZt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Oct 2021 09:25:49 -0400
Received: from foss.arm.com ([217.140.110.172]:42134 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236727AbhJLNZr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Oct 2021 09:25:47 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3BC88ED1;
        Tue, 12 Oct 2021 06:23:46 -0700 (PDT)
Received: from monolith.cable.virginm.net (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CC6C23F66F;
        Tue, 12 Oct 2021 06:23:44 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     will@kernel.org, julien.thierry.kdev@gmail.com, kvm@vger.kernel.org
Cc:     andre.przywara@arm.com, jean-philippe@linaro.org
Subject: [PATCH v2 kvmtool 2/7] vfio/pci.c: Remove double include for assert.h
Date:   Tue, 12 Oct 2021 14:25:05 +0100
Message-Id: <20211012132510.42134-3-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211012132510.42134-1-alexandru.elisei@arm.com>
References: <20211012132510.42134-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

assert.h is included twice, keep only one instance.

Reviewed-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 vfio/pci.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/vfio/pci.c b/vfio/pci.c
index ea33fd6..10ff99e 100644
--- a/vfio/pci.c
+++ b/vfio/pci.c
@@ -10,8 +10,6 @@
 #include <sys/resource.h>
 #include <sys/time.h>
 
-#include <assert.h>
-
 /* Some distros don't have the define. */
 #ifndef PCI_CAP_EXP_RC_ENDPOINT_SIZEOF_V1
 #define PCI_CAP_EXP_RC_ENDPOINT_SIZEOF_V1	12
-- 
2.20.1

