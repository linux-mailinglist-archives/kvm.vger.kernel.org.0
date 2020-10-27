Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C21EB29C10C
	for <lists+kvm@lfdr.de>; Tue, 27 Oct 2020 18:22:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1818653AbgJ0RVd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Oct 2020 13:21:33 -0400
Received: from foss.arm.com ([217.140.110.172]:47498 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2899694AbgJ0RQz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Oct 2020 13:16:55 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 41381150C;
        Tue, 27 Oct 2020 10:16:54 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BE8073F719;
        Tue, 27 Oct 2020 10:16:51 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com
Subject: [RFC PATCH kvmtool v3 2/3] init: Add last_{init, exit} list macros
Date:   Tue, 27 Oct 2020 17:17:34 +0000
Message-Id: <20201027171735.13638-3-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027171735.13638-1-alexandru.elisei@arm.com>
References: <20201027171735.13638-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a last_init macro for constructor functions that will be executed last
in the initialization process. Add a symmetrical macro, last_exit, for
destructor functions that will be the last to be executed when kvmtool
exits.

The list priority for the late_{init, exit} macros has been bumped down a
spot, but their relative priority remains unchanged, to keep the same size
for the init_lists and exit_lists.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 include/kvm/util-init.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/kvm/util-init.h b/include/kvm/util-init.h
index 13d4f04df678..e6a0e1696689 100644
--- a/include/kvm/util-init.h
+++ b/include/kvm/util-init.h
@@ -39,7 +39,8 @@ static void __attribute__ ((constructor)) __init__##cb(void)		\
 #define dev_init(cb) __init_list_add(cb, 5)
 #define virtio_dev_init(cb) __init_list_add(cb, 6)
 #define firmware_init(cb) __init_list_add(cb, 7)
-#define late_init(cb) __init_list_add(cb, 9)
+#define late_init(cb) __init_list_add(cb, 8)
+#define last_init(cb) __init_list_add(cb, 9)
 
 #define core_exit(cb) __exit_list_add(cb, 0)
 #define base_exit(cb) __exit_list_add(cb, 2)
@@ -47,5 +48,6 @@ static void __attribute__ ((constructor)) __init__##cb(void)		\
 #define dev_exit(cb) __exit_list_add(cb, 5)
 #define virtio_dev_exit(cb) __exit_list_add(cb, 6)
 #define firmware_exit(cb) __exit_list_add(cb, 7)
-#define late_exit(cb) __exit_list_add(cb, 9)
+#define late_exit(cb) __exit_list_add(cb, 8)
+#define last_exit(cb) __exit_list_add(cb, 9)
 #endif
-- 
2.29.1

