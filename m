Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BD2A2319DB
	for <lists+kvm@lfdr.de>; Wed, 29 Jul 2020 08:57:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727788AbgG2G5F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jul 2020 02:57:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726290AbgG2G5E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jul 2020 02:57:04 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B7B5C061794;
        Tue, 28 Jul 2020 23:57:04 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id e22so1585379pjt.3;
        Tue, 28 Jul 2020 23:57:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ACNXurvC12tCAs/Bt5Fnn3Crz90uP5UmMvvNrOMzVkU=;
        b=J1NPtdQx25ZPGTfJ4WbUPhXRBEFa1uOBj2CL/xqRGgd9DZpZl01aoTdoGweAeAwsVF
         8Fk9UKPOKUgapwBYFwAVVneQwVTdBbGJNbB5Yvb5CFvc/rYMtJqlxPwcbj3n8LNmT3d8
         4totw4Mac6xLYNNYgPMrWVIUrZjQ0aiwHDkG+S5QKr56BUwiCGY9TbihZpM0AkreOSm2
         GMdVmQtsqSTPXkwYFeb/7tug5uYimY44W3CdAKmXvaWSmFNDz21e9SKnMZIca2fKA9GE
         deCZcRUMQbpyOu0IfCQWCRDuHzm6B14cVxnjFkV2fI+/idaUpjyt+aMprKUCDuuMPWtF
         wCkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=ACNXurvC12tCAs/Bt5Fnn3Crz90uP5UmMvvNrOMzVkU=;
        b=rhTPAcgfO/wf6qP93oy2plCt9tfDNEYVCKvWaxQz/ELHsjbi1DoYGtlnmhOI5f6/0T
         sTpRqmkoEZfUbdNPVxI6XKxflybZ7M+VewFSzaHctmtVS4T7iUhfFQKdS19Kd7kovnXL
         a4TNK5qeMvnmMqQFLYfvwpL90L4pQ3vV9XHjirLtkUgDWCwIyPStkTeQgBWfM5w1A68Y
         gGsE2+OvrSGhiHCA0kXSwN6GlIlyfTGFInk2sGNonk41Y1NklpoLL14wDcNCUdhhh4g3
         n32D1IVrbqLzusGcvk2s9pGDgcGwQLUwi1NZHIp2H+Ft1Y5yD6Ig6tLHODRTKSXdZEbT
         G4Og==
X-Gm-Message-State: AOAM530OcGM6P8KT1jEJDv6DVV+aRsqlgwESWQnUH6HcuWI0uhYBdXGE
        qp/imC8IS084rU6XxgFMdKU=
X-Google-Smtp-Source: ABdhPJwrmwgnXlJ2EPdoeHzooiCP39nSzU5Z6K8yaeHkd0itz2LVioZMGqqbX0vhazEXHtzeVrD+BA==
X-Received: by 2002:a17:90a:e292:: with SMTP id d18mr8396515pjz.181.1596005824175;
        Tue, 28 Jul 2020 23:57:04 -0700 (PDT)
Received: from software.domain.org (28.144.92.34.bc.googleusercontent.com. [34.92.144.28])
        by smtp.gmail.com with ESMTPSA id 127sm1207202pgf.5.2020.07.28.23.57.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 Jul 2020 23:57:03 -0700 (PDT)
From:   Huacai Chen <chenhc@lemote.com>
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Rob Herring <robh+dt@kernel.org>
Cc:     linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhc@lemote.com>
Subject: [PATCH 2/5] dt-bindings: mips: Document Loongson kvm guest board
Date:   Wed, 29 Jul 2020 14:58:36 +0800
Message-Id: <1596005919-29365-2-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1596005919-29365-1-git-send-email-chenhc@lemote.com>
References: <1596005919-29365-1-git-send-email-chenhc@lemote.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Document loongson64v-4core-virtio, a virtio based kvm guest board for
Loongson-3.

Signed-off-by: Huacai Chen <chenhc@lemote.com>
Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
---
 Documentation/devicetree/bindings/mips/loongson/devices.yaml | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/mips/loongson/devices.yaml b/Documentation/devicetree/bindings/mips/loongson/devices.yaml
index 88c5a29..d25e80a 100644
--- a/Documentation/devicetree/bindings/mips/loongson/devices.yaml
+++ b/Documentation/devicetree/bindings/mips/loongson/devices.yaml
@@ -32,4 +32,8 @@ properties:
       - description: Generic Loongson64 Quad Core + LS7A
         items:
           - const: loongson,loongson64g-4core-ls7a
+
+      - description: Virtual Loongson64 Quad Core + VirtIO
+        items:
+          - const: loongson,loongson64v-4core-virtio
 ...
-- 
2.7.0

