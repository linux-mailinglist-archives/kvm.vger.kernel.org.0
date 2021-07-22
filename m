Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1EA03D2B0D
	for <lists+kvm@lfdr.de>; Thu, 22 Jul 2021 19:24:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbhGVQn0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jul 2021 12:43:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37407 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229453AbhGVQnZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 22 Jul 2021 12:43:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626974639;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=nlMd3TxvI4XScoL2o1W2xjlPZsuQAV0o1jqWNWp6S6g=;
        b=AVs3OPVG6doi1vtGu48/zKdkL2znaDzubc7KEqfc/3NNvVAADBrkSpPmpYqsXAa/SgA30h
        OiV7piUzR985D+ubYelHrVWEDnebg9B8Kexzb2zmIPs1Cg0GkF24xssOO2r1e47xA720aE
        KSVbEcqNou+d5aPYTQJP4fjoDOAg91k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-341-sDMEROjeMFetERF4WE0eIQ-1; Thu, 22 Jul 2021 13:23:58 -0400
X-MC-Unique: sDMEROjeMFetERF4WE0eIQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 37008801FCE
        for <kvm@vger.kernel.org>; Thu, 22 Jul 2021 17:23:57 +0000 (UTC)
Received: from thuth.com (ovpn-112-117.ams2.redhat.com [10.36.112.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 50D3F60936;
        Thu, 22 Jul 2021 17:23:56 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <drjones@redhat.com>
Subject: [kvm-unit-tests PATCH] travis.yml: Disable the failing gicv2-mmio test
Date:   Thu, 22 Jul 2021 19:23:54 +0200
Message-Id: <20210722172354.3759847-1-thuth@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The test is constantly failing now. After trying the old commit
that re-introduced the .travis.yml file again in Travis-CI, it is
now also failing there, so this is likely not a regression in the
kvm-unit-tests, but a regression in the Travis-CI / Ubuntu build
environment. Thus let's simply disable the test for now, since
there is not much else we can do from the kvm-unit-test side here.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 .travis.yml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/.travis.yml b/.travis.yml
index 4fcb687..9b98764 100644
--- a/.travis.yml
+++ b/.travis.yml
@@ -13,7 +13,7 @@ jobs:
         apt_packages: qemu-system-aarch64
       env:
       - CONFIG="--arch=arm64 --cc=clang"
-      - TESTS="cache gicv2-active gicv2-ipi gicv2-mmio gicv3-active gicv3-ipi
+      - TESTS="cache gicv2-active gicv2-ipi gicv3-active gicv3-ipi
           pci-test pmu-cycle-counter pmu-event-counter-config pmu-sw-incr
           selftest-setup selftest-smp selftest-vectors-kernel
           selftest-vectors-user timer"
-- 
2.27.0

