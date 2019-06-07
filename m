Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 915323890C
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2019 13:29:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727102AbfFGL3y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jun 2019 07:29:54 -0400
Received: from albert.telenet-ops.be ([195.130.137.90]:50500 "EHLO
        albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727317AbfFGL3y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jun 2019 07:29:54 -0400
Received: from ramsan ([84.194.111.163])
        by albert.telenet-ops.be with bizsmtp
        id MnVs200033XaVaC06nVsHX; Fri, 07 Jun 2019 13:29:52 +0200
Received: from rox.of.borg ([192.168.97.57])
        by ramsan with esmtp (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1hZD4C-0004FN-4d; Fri, 07 Jun 2019 13:29:52 +0200
Received: from geert by rox.of.borg with local (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1hZD4C-0003lH-38; Fri, 07 Jun 2019 13:29:52 +0200
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Jiri Kosina <trivial@kernel.org>
Cc:     kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH trivial] KVM: arm/arm64: Always capitalize ITS
Date:   Fri,  7 Jun 2019 13:29:51 +0200
Message-Id: <20190607112951.14418-1-geert+renesas@glider.be>
X-Mailer: git-send-email 2.17.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

All but one reference is capitalized.  Fix the remaining one.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 Documentation/virtual/kvm/devices/arm-vgic-its.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/virtual/kvm/devices/arm-vgic-its.txt b/Documentation/virtual/kvm/devices/arm-vgic-its.txt
index 4f0c9fc403656d29..eeaa95b893a89b7a 100644
--- a/Documentation/virtual/kvm/devices/arm-vgic-its.txt
+++ b/Documentation/virtual/kvm/devices/arm-vgic-its.txt
@@ -103,7 +103,7 @@ Groups:
 The following ordering must be followed when restoring the GIC and the ITS:
 a) restore all guest memory and create vcpus
 b) restore all redistributors
-c) provide the its base address
+c) provide the ITS base address
    (KVM_DEV_ARM_VGIC_GRP_ADDR)
 d) restore the ITS in the following order:
    1. Restore GITS_CBASER
-- 
2.17.1

