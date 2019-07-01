Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EAE5557C1
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2019 21:28:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727043AbfFYT2l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jun 2019 15:28:41 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:33586 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726420AbfFYT2l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jun 2019 15:28:41 -0400
Received: by mail-pf1-f195.google.com with SMTP id x15so10014308pfq.0
        for <kvm@vger.kernel.org>; Tue, 25 Jun 2019 12:28:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=4X9HSjEQ1Q/dPniTopK+6IF6HQwTYdtqqoEUFZtcMaY=;
        b=kj2hDHc5xRwkbGgQoj/eZluQW1gpv6jd1+44CyfgqFER+C2f88PowYwj/Tz6yJ2TLB
         0q77UiOI4CbACy1rxbOLMXHwgHCM182qSXM2IU/g9LoYZAUkfAAa/deQvgomqRi0wk1W
         m5lqsgDkTisvEU6VbOrWTTOPKASmPZBmy41WnHsIofjMd5p31YL8yoDNtgZRX0z7FwuI
         5XBaRmTyWV+FINNeH0ZdiwAbSGt+xsLFs/RHakt0DCNVttmw1YYT7O5j6GuxaCGxmrpX
         arxh6rSF7AlJgE15OIMJbMMiFTbw/kcwWPrBvnZ4bmfx/c8hOp0nG6Y7CmfODZdAVTcY
         mOrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=4X9HSjEQ1Q/dPniTopK+6IF6HQwTYdtqqoEUFZtcMaY=;
        b=WXSwKj92+6kw/Y2wU42MKhUtMDqnGAe9Ahi34DYfjzTs8EFzlNzUzM2CvCNmAoCSol
         LNSQATnYp2v4Oe8wn3XHKzVV/OfTzJWeMPIj5VYFsKuInYHQjVeP1kQfoLPg8sAdsnM2
         8u45GBdsPINRw6VrpXUzHu6SpGr+IvgxWdVLCVibMByOCU/rkqI0borLi+Ccaxh/4Qys
         IDId6ymcT7wcz6aCnIO7VDCvBrqXqy8LGavr8rts87EDaOQucIwrLTIdDssE6brkd2+S
         S7vbgPkEiU/1WXH+WQX3Gm/SyRy99yUkJWZAOe0rSkiinJdQ8lsiiYRUufUBVnr5jjUw
         56Yw==
X-Gm-Message-State: APjAAAVH5l/2MygYte+ncz06RSbaYnn49Vxk8h4dHX0hRGnFONw6d3RW
        sSK1jL21SUsp3Wpcl60T5V0=
X-Google-Smtp-Source: APXvYqytj4Q580HV9zvA1ZK9hu9ogD3VVVhzs2UHinpJnWyvc0UFtsswpcp9/TgQm3fjvRCFIiGzJg==
X-Received: by 2002:a17:90a:3aed:: with SMTP id b100mr507687pjc.63.1561490920235;
        Tue, 25 Jun 2019 12:28:40 -0700 (PDT)
Received: from sc2-haas01-esx0118.eng.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id a12sm15943399pgq.0.2019.06.25.12.28.39
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 25 Jun 2019 12:28:39 -0700 (PDT)
From:   Nadav Amit <nadav.amit@gmail.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Nadav Amit <nadav.amit@gmail.com>,
        Marc Orr <marcorr@google.com>
Subject: [kvm-unit-tests PATCH] x86: Mark APR as reserved in x2APIC
Date:   Tue, 25 Jun 2019 05:06:27 -0700
Message-Id: <20190625120627.8705-1-nadav.amit@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Cc: Marc Orr <marcorr@google.com>
Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
---
 lib/x86/apic.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/x86/apic.h b/lib/x86/apic.h
index 537fdfb..b5bf208 100644
--- a/lib/x86/apic.h
+++ b/lib/x86/apic.h
@@ -75,6 +75,7 @@ static inline bool x2apic_reg_reserved(u32 reg)
 	switch (reg) {
 	case 0x000 ... 0x010:
 	case 0x040 ... 0x070:
+	case 0x090:
 	case 0x0c0:
 	case 0x0e0:
 	case 0x290 ... 0x2e0:
-- 
2.17.1

