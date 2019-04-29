Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDA2ADDAF
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2019 10:27:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727608AbfD2I1O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Apr 2019 04:27:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37686 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727564AbfD2I1N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Apr 2019 04:27:13 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 66C67DC8FF
        for <kvm@vger.kernel.org>; Mon, 29 Apr 2019 08:27:13 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9C66860C62;
        Mon, 29 Apr 2019 08:27:11 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com
Subject: [PATCH] Documentation: kvm: fix dirty log ioctl arch lists
Date:   Mon, 29 Apr 2019 10:27:10 +0200
Message-Id: <20190429082710.15570-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Mon, 29 Apr 2019 08:27:13 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM_GET_DIRTY_LOG is implemented by all architectures, not just x86,
and KVM_CAP_MANUAL_DIRTY_LOG_PROTECT is additionally implemented by
arm, arm64, and mips.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
I skimmed all ioctls in the document to see if others needed to be
fixed, but from my quick skim the only dirty ones seem to be the
dirty log ones.

 Documentation/virtual/kvm/api.txt | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index 67068c47c591..7f3ebc9e7cee 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -321,7 +321,7 @@ cpu's hardware control block.
 4.8 KVM_GET_DIRTY_LOG (vm ioctl)
 
 Capability: basic
-Architectures: x86
+Architectures: all
 Type: vm ioctl
 Parameters: struct kvm_dirty_log (in/out)
 Returns: 0 on success, -1 on error
@@ -3810,7 +3810,7 @@ to I/O ports.
 4.117 KVM_CLEAR_DIRTY_LOG (vm ioctl)
 
 Capability: KVM_CAP_MANUAL_DIRTY_LOG_PROTECT
-Architectures: x86
+Architectures: x86, arm, arm64, mips
 Type: vm ioctl
 Parameters: struct kvm_dirty_log (in)
 Returns: 0 on success, -1 on error
@@ -4799,7 +4799,7 @@ and injected exceptions.
 
 7.18 KVM_CAP_MANUAL_DIRTY_LOG_PROTECT
 
-Architectures: all
+Architectures: x86, arm, arm64, mips
 Parameters: args[0] whether feature should be enabled or not
 
 With this capability enabled, KVM_GET_DIRTY_LOG will not automatically
-- 
2.20.1

