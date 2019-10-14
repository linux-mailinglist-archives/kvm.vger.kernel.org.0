Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E6E3D6A0D
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2019 21:24:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388538AbfJNTYo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Oct 2019 15:24:44 -0400
Received: from mail-pg1-f202.google.com ([209.85.215.202]:39017 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388382AbfJNTYn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Oct 2019 15:24:43 -0400
Received: by mail-pg1-f202.google.com with SMTP id m20so13307205pgv.6
        for <kvm@vger.kernel.org>; Mon, 14 Oct 2019 12:24:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=hn+keZB9xpauOPEG/xtppgt0f+LdcfGzJGEyhk0ef1U=;
        b=lwj86rm0uccYhiSW4u10l6kRCUc2PCwgclMCQgKsnRGxhzCHI5Ku5lYH6ExaiYSnHZ
         kdvMgz2d7YHlXU6zjnDaMTCodjh68xBp4qPOWTghqpBuLLSLuIk17PmFTaLnpEz+XAmk
         +ZFxnN/sxpqDttc0ifsFW2p4N/+XfQm09WEucdomHZ2F0vTbmisO1fkN1ZvsFvQF5j3E
         mLWeFb8JdSg9WIRPreWbIwEZ7FbZwAqyb0y6Sa91JYSOeKBMMzMjkn5BFaU/ZX1NB78F
         QugSJ5NkMza87+vVO+OMME9LnhMl/fwrwf2TgXReFWcjFLSJkk2QO8Gf3A9JQs6dCrRq
         ndPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=hn+keZB9xpauOPEG/xtppgt0f+LdcfGzJGEyhk0ef1U=;
        b=hrZZ4MnC3s5GFaafR9lnsrEuB1wNTXKd7ZzUO0/IkY90SP/M1AcG+JBHNWWeEo+xLE
         vrAoUF1SkI+rtBtDFOiZ0RyVh7cYlHf3Ba2frDBcazyoOiwROs/XRSobvUdlv9W59RhN
         E+pnJJNFsf2cPmqxgaUZIBEj5ukxzuSmQPuyNhDwaMvEHFNHwH/Nyt7nwWI4YGS6QgRQ
         ctz+SqfCi69GxYyDbYDJB5cXo2Qp6HW4/pMMw017rmzuA/zqGonXCss0yyYaIp/KwIKG
         k5zp4expQceerIBavZHNJwv3EFIlERKWPXTNUMGgku1KM1r6QXV4qtWPn1do3oLt9p8L
         V7zA==
X-Gm-Message-State: APjAAAVGe4821iuDh2Pm17niOTdqlukP3PT4FQ7YXjoVQqh8YA8O6/33
        1NUi7Uoe4tlyTT77T7DdVlGwxRQ6CA5gcw3RyEsmXTq3mGdQLCrcAFx83WeON87WDUZEZTe38hd
        bDoz9FrGPAIIZ3t6KvROTJWhlk0C15nV5sbvSp5qlPQwDU1fIHEvnkw==
X-Google-Smtp-Source: APXvYqxrjaJ0JS+qAa243k3bncIbFYsGj4RS4WUEL6LzJT2tBjeSCGK5g0QUJpTlSGZ2PjmMnrQGOgbCWg==
X-Received: by 2002:a63:d415:: with SMTP id a21mr33243571pgh.299.1571081082890;
 Mon, 14 Oct 2019 12:24:42 -0700 (PDT)
Date:   Mon, 14 Oct 2019 12:24:29 -0700
In-Reply-To: <20191014192431.137719-1-morbo@google.com>
Message-Id: <20191014192431.137719-3-morbo@google.com>
Mime-Version: 1.0
References: <20191010183506.129921-1-morbo@google.com> <20191014192431.137719-1-morbo@google.com>
X-Mailer: git-send-email 2.23.0.700.g56cf767bdb-goog
Subject: [kvm-unit-tests PATCH 2/4] pci: cast the masks to the appropriate size
From:   Bill Wendling <morbo@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     jmattson@google.com, sean.j.christopherson@intel.com,
        Bill Wendling <morbo@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

At this point, we're dealing with 32-bit addresses, therefore downcast
the masks to 32-bits.

Signed-off-by: Bill Wendling <morbo@google.com>
---
 lib/pci.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/lib/pci.c b/lib/pci.c
index daa33e1..1b85411 100644
--- a/lib/pci.c
+++ b/lib/pci.c
@@ -107,7 +107,8 @@ pcidevaddr_t pci_find_dev(uint16_t vendor_id, uint16_t device_id)
 uint32_t pci_bar_mask(uint32_t bar)
 {
 	return (bar & PCI_BASE_ADDRESS_SPACE_IO) ?
-		PCI_BASE_ADDRESS_IO_MASK : PCI_BASE_ADDRESS_MEM_MASK;
+		(uint32_t)PCI_BASE_ADDRESS_IO_MASK :
+		(uint32_t)PCI_BASE_ADDRESS_MEM_MASK;
 }
 
 uint32_t pci_bar_get(struct pci_dev *dev, int bar_num)
-- 
2.23.0.700.g56cf767bdb-goog

