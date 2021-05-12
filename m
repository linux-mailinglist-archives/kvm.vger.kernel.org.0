Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 746AB37BD41
	for <lists+kvm@lfdr.de>; Wed, 12 May 2021 14:52:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231419AbhELMxk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 May 2021 08:53:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:53084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230430AbhELMxH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 May 2021 08:53:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C788F6143A;
        Wed, 12 May 2021 12:51:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620823907;
        bh=Rep4488btcGkKQJG3baQdJ6X/088U7ci2M0IySOvCVY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lZYXQeY0yNNPJboL2kgoqrNjfjMdnZkfgCFBi8X/c4xbPFeCb5SLp/VQ5ORLH1zUu
         MolJyllNaINbgtFp6ABZYNl5noK6VwqP8kfnCz4cIyraZqncso/rdYhw10c+dpTw2m
         OZ277cM8h0g2RpeiJ0anr7hwBSjNgx6abKraoCTHdYl5g3e37bJlbKAdafe1v9/wMc
         +rCUYGJGbw9AvKZHQZuhpuw4ff8gNFSEkg0iONw9D2pSBtZ7RTr+4fRPds2dfJz+tv
         NevzAYmGCrlwQ/ocDe8dp7GIsc/5rS8LRf5BIv/GoTlvAmLSttP5RJxbxLBceg7SN+
         isuP0dfdNj3GA==
Received: by mail.kernel.org with local (Exim 4.94.2)
        (envelope-from <mchehab@kernel.org>)
        id 1lgoL3-0018nv-TQ; Wed, 12 May 2021 14:51:45 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        "Jonathan Corbet" <corbet@lwn.net>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 39/40] docs: virt: kvm: api.rst: Use ASCII subset instead of UTF-8 alternate symbols
Date:   Wed, 12 May 2021 14:50:43 +0200
Message-Id: <504e06926ded9368f1e754b20d380d483d84a221.1620823573.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <cover.1620823573.git.mchehab+huawei@kernel.org>
References: <cover.1620823573.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: Mauro Carvalho Chehab <mchehab@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The conversion tools used during DocBook/LaTeX/Markdown->ReST conversion
and some automatic rules which exists on certain text editors like
LibreOffice turned ASCII characters into some UTF-8 alternatives that
are better displayed on html and PDF.

While it is OK to use UTF-8 characters in Linux, it is better to
use the ASCII subset instead of using an UTF-8 equivalent character
as it makes life easier for tools like grep, and are easier to edit
with the some commonly used text/source code editors.

Also, Sphinx already do such conversion automatically outside literal blocks:
   https://docutils.sourceforge.io/docs/user/smartquotes.html

So, replace the occurences of the following UTF-8 characters:

	- U+00a0 (' '): NO-BREAK SPACE

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/virt/kvm/api.rst | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 22d077562149..295daf6178f8 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -850,7 +850,7 @@ in-kernel irqchip (GIC), and for in-kernel irqchip can tell the GIC to
 use PPIs designated for specific cpus.  The irq field is interpreted
 like this::
 
-  bits:  |  31 ... 28  | 27 ... 24 | 23  ... 16 | 15 ... 0 |
+  bits:  |  31 ... 28  | 27 ... 24 | 23  ... 16 | 15 ... 0 |
   field: | vcpu2_index | irq_type  | vcpu_index |  irq_id  |
 
 The irq_type field has the following values:
@@ -2144,10 +2144,10 @@ prior to calling the KVM_RUN ioctl.
 Errors:
 
   ======   ============================================================
-  ENOENT   no such register
-  EINVAL   invalid register ID, or no such register or used with VMs in
+  ENOENT   no such register
+  EINVAL   invalid register ID, or no such register or used with VMs in
            protected virtualization mode on s390
-  EPERM    (arm64) register access not allowed before vcpu finalization
+  EPERM    (arm64) register access not allowed before vcpu finalization
   ======   ============================================================
 
 (These error codes are indicative only: do not rely on a specific error
@@ -2585,10 +2585,10 @@ following id bit patterns::
 Errors include:
 
   ======== ============================================================
-  ENOENT   no such register
-  EINVAL   invalid register ID, or no such register or used with VMs in
+  ENOENT   no such register
+  EINVAL   invalid register ID, or no such register or used with VMs in
            protected virtualization mode on s390
-  EPERM    (arm64) register access not allowed before vcpu finalization
+  EPERM    (arm64) register access not allowed before vcpu finalization
   ======== ============================================================
 
 (These error codes are indicative only: do not rely on a specific error
@@ -3107,13 +3107,13 @@ current state.  "addr" is ignored.
 Errors:
 
   ======     =================================================================
-  EINVAL     the target is unknown, or the combination of features is invalid.
-  ENOENT     a features bit specified is unknown.
+  EINVAL     the target is unknown, or the combination of features is invalid.
+  ENOENT     a features bit specified is unknown.
   ======     =================================================================
 
 This tells KVM what type of CPU to present to the guest, and what
-optional features it should have.  This will cause a reset of the cpu
-registers to their initial values.  If this is not called, KVM_RUN will
+optional features it should have.  This will cause a reset of the cpu
+registers to their initial values.  If this is not called, KVM_RUN will
 return ENOEXEC for that vcpu.
 
 The initial values are defined as:
@@ -3234,8 +3234,8 @@ VCPU matching underlying host.
 Errors:
 
   =====      ==============================================================
-  E2BIG      the reg index list is too big to fit in the array specified by
-             the user (the number required will be written into n).
+  E2BIG      the reg index list is too big to fit in the array specified by
+             the user (the number required will be written into n).
   =====      ==============================================================
 
 ::
@@ -3283,7 +3283,7 @@ specific device.
 ARM/arm64 divides the id field into two parts, a device id and an
 address type id specific to the individual device::
 
-  bits:  | 63        ...       32 | 31    ...    16 | 15    ...    0 |
+  bits:  | 63        ...       32 | 31    ...    16 | 15    ...    0 |
   field: |        0x00000000      |     device id   |  addr type id  |
 
 ARM/arm64 currently only require this when using the in-kernel GIC
-- 
2.30.2

