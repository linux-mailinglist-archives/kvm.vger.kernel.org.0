Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75FB1154677
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2020 15:50:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727550AbgBFOug (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Feb 2020 09:50:36 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:55364 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727505AbgBFOuf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Feb 2020 09:50:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=hzfYtrRz0RCncYKmXXsN9R9Poi2SrtZfQbchv+Ctqtk=; b=OPp1Td4GjL8xgbzoQkQUMp6XRs
        LwU1itmGd64LVQWo1xWcoyjORbZoSjfRtl7MumcFjC2Gp2e4U195fZ4ptfqVr1KYkajL8K2DNTrSS
        ueIMq0QPjbr+qLupuSbiBdmJGT2Z+7GPUirglKKE+qerSg+AxaqyV7hFlNCdranuC0ksgKvbsCiLF
        dwi+76uBwemt+05RmcOr0Mo1xxVLA5wpkF4agvhLaf1x+wMHmY4TdvSmi35WkKp0Xrg8+Lbzqehx8
        2qvdl0o8kGy2xo/xV+Kyo+TP/Bu1CFN3F2abO9oMnl4tM2y+opWUGDRAqRanJQVow2QdTxwdLvUDZ
        uv9bN4eg==;
Received: from [179.95.15.160] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iziUE-0004IN-8P; Thu, 06 Feb 2020 14:50:34 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92.3)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1iziU6-002nKb-CC; Thu, 06 Feb 2020 15:50:26 +0100
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: [PATCH v2 05/27] docs: virt: convert halt-polling.txt to ReST format
Date:   Thu,  6 Feb 2020 15:50:02 +0100
Message-Id: <6af4ab0b9c9977b6de9abe0a120ef0904a631a52.1581000481.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <cover.1581000481.git.mchehab+huawei@kernel.org>
References: <cover.1581000481.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

- Fix document title to match ReST format
- Convert the table to be properly recognized
- Some indentation fixes to match ReST syntax.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 .../{halt-polling.txt => halt-polling.rst}    | 86 ++++++++++---------
 Documentation/virt/kvm/index.rst              |  1 +
 2 files changed, 46 insertions(+), 41 deletions(-)
 rename Documentation/virt/kvm/{halt-polling.txt => halt-polling.rst} (64%)

diff --git a/Documentation/virt/kvm/halt-polling.txt b/Documentation/virt/kvm/halt-polling.rst
similarity index 64%
rename from Documentation/virt/kvm/halt-polling.txt
rename to Documentation/virt/kvm/halt-polling.rst
index 4f791b128dd2..4922e4a15f18 100644
--- a/Documentation/virt/kvm/halt-polling.txt
+++ b/Documentation/virt/kvm/halt-polling.rst
@@ -1,3 +1,6 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+===========================
 The KVM halt polling system
 ===========================
 
@@ -68,7 +71,8 @@ steady state polling interval but will only really do a good job for wakeups
 which come at an approximately constant rate, otherwise there will be constant
 adjustment of the polling interval.
 
-[0] total block time: the time between when the halt polling function is
+[0] total block time:
+		      the time between when the halt polling function is
 		      invoked and a wakeup source received (irrespective of
 		      whether the scheduler is invoked within that function).
 
@@ -81,31 +85,32 @@ shrunk. These variables are defined in include/linux/kvm_host.h and as module
 parameters in virt/kvm/kvm_main.c, or arch/powerpc/kvm/book3s_hv.c in the
 powerpc kvm-hv case.
 
-Module Parameter	|   Description		    |	     Default Value
---------------------------------------------------------------------------------
-halt_poll_ns		| The global max polling    | KVM_HALT_POLL_NS_DEFAULT
-			| interval which defines    |
-			| the ceiling value of the  |
-			| polling interval for      | (per arch value)
-			| each vcpu.		    |
---------------------------------------------------------------------------------
-halt_poll_ns_grow	| The value by which the    | 2
-			| halt polling interval is  |
-			| multiplied in the	    |
-			| grow_halt_poll_ns()	    |
-			| function.		    |
---------------------------------------------------------------------------------
-halt_poll_ns_grow_start | The initial value to grow | 10000
-			| to from zero in the	    |
-			| grow_halt_poll_ns()	    |
-			| function.		    |
---------------------------------------------------------------------------------
-halt_poll_ns_shrink	| The value by which the    | 0
-			| halt polling interval is  |
-			| divided in the	    |
-			| shrink_halt_poll_ns()	    |
-			| function.		    |
---------------------------------------------------------------------------------
++-----------------------+---------------------------+-------------------------+
+|Module Parameter	|   Description		    |	     Default Value    |
++-----------------------+---------------------------+-------------------------+
+|halt_poll_ns		| The global max polling    | KVM_HALT_POLL_NS_DEFAULT|
+|			| interval which defines    |			      |
+|			| the ceiling value of the  |			      |
+|			| polling interval for      | (per arch value)	      |
+|			| each vcpu.		    |			      |
++-----------------------+---------------------------+-------------------------+
+|halt_poll_ns_grow	| The value by which the    | 2			      |
+|			| halt polling interval is  |			      |
+|			| multiplied in the	    |			      |
+|			| grow_halt_poll_ns()	    |			      |
+|			| function.		    |			      |
++-----------------------+---------------------------+-------------------------+
+|halt_poll_ns_grow_start| The initial value to grow | 10000		      |
+|			| to from zero in the	    |			      |
+|			| grow_halt_poll_ns()	    |			      |
+|			| function.		    |			      |
++-----------------------+---------------------------+-------------------------+
+|halt_poll_ns_shrink	| The value by which the    | 0			      |
+|			| halt polling interval is  |			      |
+|			| divided in the	    |			      |
+|			| shrink_halt_poll_ns()	    |			      |
+|			| function.		    |			      |
++-----------------------+---------------------------+-------------------------+
 
 These module parameters can be set from the debugfs files in:
 
@@ -117,20 +122,19 @@ Note: that these module parameters are system wide values and are not able to
 Further Notes
 =============
 
-- Care should be taken when setting the halt_poll_ns module parameter as a
-large value has the potential to drive the cpu usage to 100% on a machine which
-would be almost entirely idle otherwise. This is because even if a guest has
-wakeups during which very little work is done and which are quite far apart, if
-the period is shorter than the global max polling interval (halt_poll_ns) then
-the host will always poll for the entire block time and thus cpu utilisation
-will go to 100%.
+- Care should be taken when setting the halt_poll_ns module parameter as a large value
+  has the potential to drive the cpu usage to 100% on a machine which would be almost
+  entirely idle otherwise. This is because even if a guest has wakeups during which very
+  little work is done and which are quite far apart, if the period is shorter than the
+  global max polling interval (halt_poll_ns) then the host will always poll for the
+  entire block time and thus cpu utilisation will go to 100%.
 
-- Halt polling essentially presents a trade off between power usage and latency
-and the module parameters should be used to tune the affinity for this. Idle
-cpu time is essentially converted to host kernel time with the aim of decreasing
-latency when entering the guest.
+- Halt polling essentially presents a trade off between power usage and latency and
+  the module parameters should be used to tune the affinity for this. Idle cpu time is
+  essentially converted to host kernel time with the aim of decreasing latency when
+  entering the guest.
 
-- Halt polling will only be conducted by the host when no other tasks are
-runnable on that cpu, otherwise the polling will cease immediately and
-schedule will be invoked to allow that other task to run. Thus this doesn't
-allow a guest to denial of service the cpu.
+- Halt polling will only be conducted by the host when no other tasks are runnable on
+  that cpu, otherwise the polling will cease immediately and schedule will be invoked to
+  allow that other task to run. Thus this doesn't allow a guest to denial of service the
+  cpu.
diff --git a/Documentation/virt/kvm/index.rst b/Documentation/virt/kvm/index.rst
index 488c6370a447..b39f4894b61d 100644
--- a/Documentation/virt/kvm/index.rst
+++ b/Documentation/virt/kvm/index.rst
@@ -9,6 +9,7 @@ KVM
 
    amd-memory-encryption
    cpuid
+   halt-polling
    vcpu-requests
 
    arm/index
-- 
2.24.1

