Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03E24BB573
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2019 15:35:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439750AbfIWNfo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Sep 2019 09:35:44 -0400
Received: from foss.arm.com ([217.140.110.172]:42324 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439741AbfIWNfn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Sep 2019 09:35:43 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1EE801000;
        Mon, 23 Sep 2019 06:35:43 -0700 (PDT)
Received: from e121566-lin.cambridge.arm.com (e121566-lin.cambridge.arm.com [10.1.196.217])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 1B74B3F694;
        Mon, 23 Sep 2019 06:35:42 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org, will@kernel.org, julien.thierry.kdev@gmail.com
Cc:     maz@kernel.org, suzuki.poulose@arm.com, julien.grall@arm.com,
        andre.przywara@arm.com
Subject: [PATCH kvmtool 05/16] kvmtool: Use MB consistently
Date:   Mon, 23 Sep 2019 14:35:11 +0100
Message-Id: <1569245722-23375-6-git-send-email-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1569245722-23375-1-git-send-email-alexandru.elisei@arm.com>
References: <1569245722-23375-1-git-send-email-alexandru.elisei@arm.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The help text for the -m/--mem argument states that the guest memory size
is in MiB (mebibyte). We all know that MB (megabyte) is the same thing as
MiB, and indeed this is how MB is used throughout kvmtool.

So replace MiB with MB, so people don't get the wrong idea and start
believing that for kvmtool a MB is 10^6 bytes, because it isn't.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 Documentation/kvmtool.1 | 4 ++--
 builtin-run.c           | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/kvmtool.1 b/Documentation/kvmtool.1
index 2b8c274dc3ff..25d46f8f51f9 100644
--- a/Documentation/kvmtool.1
+++ b/Documentation/kvmtool.1
@@ -10,7 +10,7 @@ kvmtool is a userland tool for creating and controlling KVM guests.
 .SH "KVMTOOL COMMANDS"
 .sp
 .PP
-.B run -k <kernel\-image> [\-c <cores>] [\-m <MiB>] [\-p <command line>]
+.B run -k <kernel\-image> [\-c <cores>] [\-m <MB>] [\-p <command line>]
 .br
 .B [\-i <initrd>] [\-d <image file>] [\-\-console serial|virtio|hv]
 .br
@@ -30,7 +30,7 @@ The number of virtual CPUs to run.
 .sp
 .B \-m, \-\-mem <n>
 .RS 4
-Virtual machine memory size in MiB.
+Virtual machine memory size in MB.
 .RE
 .sp
 .B \-p, \-\-params <parameters>
diff --git a/builtin-run.c b/builtin-run.c
index 532c06f90ba0..cff44047bb1c 100644
--- a/builtin-run.c
+++ b/builtin-run.c
@@ -98,7 +98,7 @@ void kvm_run_set_wrapper_sandbox(void)
 			"A name for the guest"),			\
 	OPT_INTEGER('c', "cpus", &(cfg)->nrcpus, "Number of CPUs"),	\
 	OPT_U64('m', "mem", &(cfg)->ram_size, "Virtual machine memory"	\
-		" size in MiB."),					\
+		" size in MB."),					\
 	OPT_CALLBACK('\0', "shmem", NULL,				\
 		     "[pci:]<addr>:<size>[:handle=<handle>][:create]",	\
 		     "Share host shmem with guest via pci device",	\
-- 
2.7.4

