Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58E173A9268
	for <lists+kvm@lfdr.de>; Wed, 16 Jun 2021 08:28:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231927AbhFPGaJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Jun 2021 02:30:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:60490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231698AbhFPG34 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Jun 2021 02:29:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F0ED461430;
        Wed, 16 Jun 2021 06:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623824869;
        bh=HY4ADwiftCI1A8ob2cFjNLvghYbjM2GrKGmwzrBsOJc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CA09wlxSMTi9bHzUyfI+4jsfl4upMu37L17/fur19+Wg4po9Lm/r5QiTelyS+FRh0
         t/92dFIKswgf4AgMqTH2uHyqDkqAYitBD/W4FBEExJqq6yRFr0QvRUVv1p1FBKgUpy
         DB5O7MRu/TLqWuTe3vUhUdR4xmsPKUwTRO6xn24BCbGo7UCKbS/+GXJu6qIjmtdA3G
         VAegt22w04b9MW+YyuOBjkrR3APHBXIMKgbg6JRJvT2E8p5wcZatKihR9zVWHqm0lx
         vEK/1mfw6MHPM5nzHgb3aGJx6NY8NLc8zJn+lhOk2te2ufOwWm11A0/oGr0FkgUITQ
         rHPvSzvspRXww==
Received: by mail.kernel.org with local (Exim 4.94.2)
        (envelope-from <mchehab@kernel.org>)
        id 1ltP1f-004kK6-8Y; Wed, 16 Jun 2021 08:27:47 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Jonathan Corbet <corbet@lwn.net>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 28/29] docs: virt: kvm: s390-pv-boot.rst: avoid using ReST :doc:`foo` markup
Date:   Wed, 16 Jun 2021 08:27:43 +0200
Message-Id: <8c0fc6578ff6384580fd0d622f363bbbd4fe91da.1623824363.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1623824363.git.mchehab+huawei@kernel.org>
References: <cover.1623824363.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Mauro Carvalho Chehab <mchehab@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The :doc:`foo` tag is auto-generated via automarkup.py.
So, use the filename at the sources, instead of :doc:`foo`.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/virt/kvm/s390-pv-boot.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/s390-pv-boot.rst b/Documentation/virt/kvm/s390-pv-boot.rst
index ad1f7866c001..73a6083cb5e7 100644
--- a/Documentation/virt/kvm/s390-pv-boot.rst
+++ b/Documentation/virt/kvm/s390-pv-boot.rst
@@ -10,7 +10,7 @@ The memory of Protected Virtual Machines (PVMs) is not accessible to
 I/O or the hypervisor. In those cases where the hypervisor needs to
 access the memory of a PVM, that memory must be made accessible.
 Memory made accessible to the hypervisor will be encrypted. See
-:doc:`s390-pv` for details."
+Documentation/virt/kvm/s390-pv.rst for details."
 
 On IPL (boot) a small plaintext bootloader is started, which provides
 information about the encrypted components and necessary metadata to
-- 
2.31.1

