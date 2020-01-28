Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE5C814BC18
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2020 15:51:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727474AbgA1OvG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jan 2020 09:51:06 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:58436 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726524AbgA1N6p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jan 2020 08:58:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=H1nRRjrZGeu/PASJbR2ix7tpTPDW4y35R3IZ+NkvAB8=; b=mowTCdEj5jn6n0WdWu24FS5gWR
        tk6/R/aWJakV/jNP9qJvHApl230fONfFeYnOwNoDQdEuyocJFXCPK5BytQh1FFh7kZO8034fMeIci
        f4WpVR9kgHWbvJYJ1qb56kWcOxDVtWXwaxxd+cclM1YHPKYPfP8bx48z1ycGbUyHXPowa8ljKjaBx
        zhS+kq06tV6JO3Z2jpvpKT/N8WKcG3V+m4na9at8Ccmd0HVeVXvXFAZDQ4dgw6jNwcapUzXp1NC/C
        pntY4Pd/pdx97gdEWjhBUYIP8pzmzA694N1mt+cgiA77I0Xt7SEkwvhqHWc7V3GsiZSa1BoY7zb1U
        e2OP5I6Q==;
Received: from [177.41.103.99] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iwRO6-0006Ht-Nw; Tue, 28 Jan 2020 13:58:42 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92.3)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1iwRNq-001BJp-Dc; Tue, 28 Jan 2020 14:58:26 +0100
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: [PATCH 10/27] docs: kvm: convert devices/mpic.txt to ReST
Date:   Tue, 28 Jan 2020 14:58:06 +0100
Message-Id: <11aa35fac07b299da862706325b194164548549b.1580219586.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <cover.1580219586.git.mchehab+huawei@kernel.org>
References: <cover.1580219586.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This document is almost in ReST format. The only thing
needed is to mark a list as such and to add an extra
whitespace.

Yet, let's also use the standard document title markup,
as it makes easier if anyone wants later to add sessions
to it.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/virt/kvm/devices/index.rst              | 1 +
 Documentation/virt/kvm/devices/{mpic.txt => mpic.rst} | 9 ++++++---
 2 files changed, 7 insertions(+), 3 deletions(-)
 rename Documentation/virt/kvm/devices/{mpic.txt => mpic.rst} (92%)

diff --git a/Documentation/virt/kvm/devices/index.rst b/Documentation/virt/kvm/devices/index.rst
index 7eabce80c61e..9e5586e371de 100644
--- a/Documentation/virt/kvm/devices/index.rst
+++ b/Documentation/virt/kvm/devices/index.rst
@@ -10,3 +10,4 @@ Devices
    arm-vgic-its
    arm-vgic
    arm-vgic-v3
+   mpic
diff --git a/Documentation/virt/kvm/devices/mpic.txt b/Documentation/virt/kvm/devices/mpic.rst
similarity index 92%
rename from Documentation/virt/kvm/devices/mpic.txt
rename to Documentation/virt/kvm/devices/mpic.rst
index 8257397adc3c..571b2bc72b5e 100644
--- a/Documentation/virt/kvm/devices/mpic.txt
+++ b/Documentation/virt/kvm/devices/mpic.rst
@@ -1,9 +1,11 @@
+=========================
 MPIC interrupt controller
 =========================
 
 Device types supported:
-  KVM_DEV_TYPE_FSL_MPIC_20     Freescale MPIC v2.0
-  KVM_DEV_TYPE_FSL_MPIC_42     Freescale MPIC v4.2
+
+  - KVM_DEV_TYPE_FSL_MPIC_20     Freescale MPIC v2.0
+  - KVM_DEV_TYPE_FSL_MPIC_42     Freescale MPIC v4.2
 
 Only one MPIC instance, of any type, may be instantiated.  The created
 MPIC will act as the system interrupt controller, connecting to each
@@ -11,7 +13,8 @@ vcpu's interrupt inputs.
 
 Groups:
   KVM_DEV_MPIC_GRP_MISC
-  Attributes:
+   Attributes:
+
     KVM_DEV_MPIC_BASE_ADDR (rw, 64-bit)
       Base address of the 256 KiB MPIC register space.  Must be
       naturally aligned.  A value of zero disables the mapping.
-- 
2.24.1

