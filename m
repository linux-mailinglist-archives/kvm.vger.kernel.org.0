Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9370D4097B6
	for <lists+kvm@lfdr.de>; Mon, 13 Sep 2021 17:45:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242067AbhIMPqI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Sep 2021 11:46:08 -0400
Received: from foss.arm.com ([217.140.110.172]:33188 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245681AbhIMPoM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Sep 2021 11:44:12 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 846911042;
        Mon, 13 Sep 2021 08:42:54 -0700 (PDT)
Received: from monolith.cable.virginm.net (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 48B823F719;
        Mon, 13 Sep 2021 08:42:53 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     will@kernel.org, julien.thierry.kdev@gmail.com, kvm@vger.kernel.org
Cc:     andre.przywara@arm.com, jean-philippe@linaro.org
Subject: [PATCH v1 kvmtool 2/7] vfio/pci.c: Remove double include for assert.h
Date:   Mon, 13 Sep 2021 16:44:08 +0100
Message-Id: <20210913154413.14322-3-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913154413.14322-1-alexandru.elisei@arm.com>
References: <20210913154413.14322-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

assert.h is included twice, keep only one instance.

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

