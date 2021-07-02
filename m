Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ACDF3BA33B
	for <lists+kvm@lfdr.de>; Fri,  2 Jul 2021 18:30:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230044AbhGBQdK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jul 2021 12:33:10 -0400
Received: from foss.arm.com ([217.140.110.172]:50576 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230019AbhGBQdJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jul 2021 12:33:09 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0F76011B3;
        Fri,  2 Jul 2021 09:30:37 -0700 (PDT)
Received: from monolith.cable.virginm.net (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B29973F5A1;
        Fri,  2 Jul 2021 09:30:34 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     drjones@redhat.com, thuth@redhat.com, pbonzini@redhat.com,
        lvivier@redhat.com, kvm-ppc@vger.kernel.org, david@redhat.com,
        frankja@linux.ibm.com, cohuck@redhat.com, imbrenda@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Cc:     andre.przywara@arm.com, maz@kernel.org, vivek.gautam@arm.com
Subject: [kvm-unit-tests RFC PATCH 2/5] scripts: Rename run_qemu_status -> run_test_status
Date:   Fri,  2 Jul 2021 17:31:19 +0100
Message-Id: <20210702163122.96110-3-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210702163122.96110-1-alexandru.elisei@arm.com>
References: <20210702163122.96110-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvm-unit-tests will get support for running tests automatically under
kvmtool, rename the function to make it more generic.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 scripts/arch-run.bash | 2 +-
 powerpc/run           | 2 +-
 s390x/run             | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index 5997e384019b..8ceed53ed7f8 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -69,7 +69,7 @@ run_qemu ()
 	return $ret
 }
 
-run_qemu_status ()
+run_test_status ()
 {
 	local stdout ret
 
diff --git a/powerpc/run b/powerpc/run
index 597ab96ed8a8..312576006504 100755
--- a/powerpc/run
+++ b/powerpc/run
@@ -31,4 +31,4 @@ command="$(migration_cmd) $(timeout_cmd) $command"
 # to fixup the fixup below by parsing the true exit code from the output.
 # The second fixup is also a FIXME, because once we add chr-testdev
 # support for powerpc, we won't need the second fixup.
-run_qemu_status $command "$@"
+run_test_status $command "$@"
diff --git a/s390x/run b/s390x/run
index c615caa1b772..5a4bb3bda805 100755
--- a/s390x/run
+++ b/s390x/run
@@ -28,4 +28,4 @@ command+=" -kernel"
 command="$(timeout_cmd) $command"
 
 # We return the exit code via stdout, not via the QEMU return code
-run_qemu_status $command "$@"
+run_test_status $command "$@"
-- 
2.32.0

