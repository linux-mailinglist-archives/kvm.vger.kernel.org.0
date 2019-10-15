Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73707D6C5A
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2019 02:04:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726878AbfJOAEX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Oct 2019 20:04:23 -0400
Received: from mail-qk1-f202.google.com ([209.85.222.202]:36937 "EHLO
        mail-qk1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726740AbfJOAEW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Oct 2019 20:04:22 -0400
Received: by mail-qk1-f202.google.com with SMTP id o133so18579257qke.4
        for <kvm@vger.kernel.org>; Mon, 14 Oct 2019 17:04:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=hn+keZB9xpauOPEG/xtppgt0f+LdcfGzJGEyhk0ef1U=;
        b=HGtwPmxb8RdkpqlxrBrovY6k1ZNLZgNpNKmnXBN8a1pbuj6KiYguwmJrePYZhe43OU
         dSoWEqFR1yBHmhOtOeJQ1yyI52QKVIP3wEMsBqVHZWvuL7D5bZUvF4xvALK/saYTpMhU
         geENLrJ0PdgxZT9+GsTsI/LN9viqoci1PFWiMEE4/SzC5b3oQ1rBifTB30z1VRAZ/pIw
         wCwifvGcCutfnnZ0yAQVwAWD5ClADOSQ1ztsn9Qa05KwavNnh+AACqu4rj676ubn7dTi
         CyKBuPBlibbzhqKxY/ipGPRwFzvOz2O+Mf0WsSgxp75Wa3M6hP26TozB0AO00eXLrSa8
         80Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=hn+keZB9xpauOPEG/xtppgt0f+LdcfGzJGEyhk0ef1U=;
        b=bPgOrSE0xchuRR/+Cxu8Tem2aAEwE0tGsO5Y+eJbN5XZMj2i5/WkUM6UM4PtSYx8Sy
         b5gW+rPMOScrc3/LRB6/6dTLeuE3fpIdkDNnDhY3+w+WUr/tLR6dTexaACuMvSgn4SiO
         OC3KUPDHFXaXeWKIytE3y4laa92lLe2cTMLGP1SOHObmWAwvYC6fLMm3Kd1VbuX9G/fM
         51l2BSh0e54sy/FNJ34/Rp4MyI8zfZ1DYKr+ncCeh/jvM3beZBjxKSmETJ9U/uzTKppU
         JgAirDWdrJJooNkUkj94JqN81cbSO+x//xG7UAIa6A6UdE8GfByZ6gM5515G8Fczy2pT
         Yf0Q==
X-Gm-Message-State: APjAAAVk87xFFHsAUjPT1ObI6fiFmM3zf+B+Lv4Y51n8ePxEvI/tc3wf
        B6fXpcTrETNjjklEB2935gmvrQniZw0RVkxn4bdF2dEwDiE/KwGUzDnHFwGMjZ0A6MO7fu694Kx
        Ov4nhsm+2dB+A9KIzY+z5uLZiui1AzQ4zp2KGiaLE1mHqqvyqbNU4zQ==
X-Google-Smtp-Source: APXvYqzHPFyzZj8ZsK5+NpKH2lYvhf2zIhvFL/D5qcqlSsEGAFhN33Qnjow7vDe/LZ+v6636R+1LK3idgw==
X-Received: by 2002:ac8:30c3:: with SMTP id w3mr36407100qta.164.1571097861415;
 Mon, 14 Oct 2019 17:04:21 -0700 (PDT)
Date:   Mon, 14 Oct 2019 17:04:09 -0700
In-Reply-To: <20191015000411.59740-1-morbo@google.com>
Message-Id: <20191015000411.59740-3-morbo@google.com>
Mime-Version: 1.0
References: <20191010183506.129921-1-morbo@google.com> <20191015000411.59740-1-morbo@google.com>
X-Mailer: git-send-email 2.23.0.700.g56cf767bdb-goog
Subject: [kvm-unit-tests PATCH v2 2/4] pci: cast the masks to the appropriate size
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

