Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C19020F1F1
	for <lists+kvm@lfdr.de>; Tue, 30 Jun 2020 11:48:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732126AbgF3Js1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Jun 2020 05:48:27 -0400
Received: from ex13-edg-ou-002.vmware.com ([208.91.0.190]:21770 "EHLO
        EX13-EDG-OU-002.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732110AbgF3JsV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 30 Jun 2020 05:48:21 -0400
Received: from sc9-mailhost2.vmware.com (10.113.161.72) by
 EX13-EDG-OU-002.vmware.com (10.113.208.156) with Microsoft SMTP Server id
 15.0.1156.6; Tue, 30 Jun 2020 02:48:19 -0700
Received: from sc2-haas01-esx0118.eng.vmware.com (sc2-haas01-esx0118.eng.vmware.com [10.172.44.118])
        by sc9-mailhost2.vmware.com (Postfix) with ESMTP id 0A3C1B27D6;
        Tue, 30 Jun 2020 05:48:20 -0400 (EDT)
From:   Nadav Amit <namit@vmware.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     <kvm@vger.kernel.org>, Nadav Amit <namit@vmware.com>
Subject: [kvm-unit-tests PATCH 1/5] x86: Remove boot_idt assembly assignment
Date:   Tue, 30 Jun 2020 02:45:12 -0700
Message-ID: <20200630094516.22983-2-namit@vmware.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200630094516.22983-1-namit@vmware.com>
References: <20200630094516.22983-1-namit@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain
Received-SPF: None (EX13-EDG-OU-002.vmware.com: namit@vmware.com does not
 designate permitted sender hosts)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

boot_idt is now a symbol.

Signed-off-by: Nadav Amit <namit@vmware.com>
---
 x86/cstart64.S | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/x86/cstart64.S b/x86/cstart64.S
index b44d0ae..fabcdbf 100644
--- a/x86/cstart64.S
+++ b/x86/cstart64.S
@@ -2,15 +2,12 @@
 #include "apic-defs.h"
 
 .globl boot_idt
-boot_idt = 0
 
 .globl idt_descr
 .globl tss_descr
 .globl gdt64_desc
 .globl online_cpus
 
-boot_idt = 0
-
 ipi_vector = 0x20
 
 max_cpus = MAX_TEST_CPUS
-- 
2.25.1

