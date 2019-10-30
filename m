Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDD7EEA519
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2019 22:04:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727074AbfJ3VEc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Oct 2019 17:04:32 -0400
Received: from mail-pf1-f202.google.com ([209.85.210.202]:48234 "EHLO
        mail-pf1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727031AbfJ3VEc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Oct 2019 17:04:32 -0400
Received: by mail-pf1-f202.google.com with SMTP id g186so2687265pfb.15
        for <kvm@vger.kernel.org>; Wed, 30 Oct 2019 14:04:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=oi3SVXxpNNUXh6Hxdlt6eW5Qo2+MN7VHWFvLbxNDRLg=;
        b=MN27Cybj0TFsMMAvzh/FIpsFd3kn7QvFkRdwmalSoTOQlX6Sxu792yu8p+aw0yGazi
         yLUtmAkDo6mGbGKLXNSZ1xjOgOvfEfRK3UwhLQjIYYPwqctLS6mFB8WX/3kej8S5pASm
         K/J0LvthOimNPAdOtiwaAzI+6+StYRJLAiP4I8hsAH94nn4mpqKRLRTQP1F3XfdC1Sen
         4nhN1kmukz+TmbSi4bpzN/RU4NddN3GMZuy+PJ/pOshV+EFmEXs/ZsjoF9wJlfoaTFkO
         D6MntIgq/0JVX/UUoVd1H8eWBpj0Xhs8LqY7ldS+gvuCUkOwB24llrCAnczQi24qN5f0
         UigA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=oi3SVXxpNNUXh6Hxdlt6eW5Qo2+MN7VHWFvLbxNDRLg=;
        b=sm/4brldHDGqu05PRWHTAoa/LhbCSaVnUEShjGghPiQvhc+wL7oajOdoJEv/fsGTqB
         ykPEevRTRUarRgsQbzaH0CDQmFMiqPLIrkWiSwbfjluaLRTZot1yZy5lXzCn2+8lESWd
         DLkpIQVdYLmeYDrvsW3hh1PqL1iRcYxHb+QkhN6fsGI8+Xz8t4Hw7x0E2C4tXyMB4Hry
         kH5w4dSzETVBe+9Jh896Cli6sHV2pWjMf2bVp6H0FqS1XXMsc0/JVN24Zq8ImfUlqHTo
         3o2qIk5GXOsiEtuSQWzDgaIbftp96TF247hoTG356r1TC6kh6B9df6IBHXH/eOClMh54
         99AQ==
X-Gm-Message-State: APjAAAWgUVyZbvXyvXYsNcPYX+SPf/GT2NXLg8jimpqe5NiQCI9Vatj8
        GeOWhaKNygP/27N8uhYUj146ZSHpIGMJ0Gc/U04JIGYI6YDVN9b//0LCsM1KFJOOIlEr9AM+Ic2
        6UtlvSote627g7nua8en/EztdZaOK9jxxSb8ziHQZoWAIZbUW1ibB/Q==
X-Google-Smtp-Source: APXvYqysvM9Sz8yl+1f4KEMKfJezgAPVxXrU+FNNNn8RgtKtPE/yunHgWrnzqzohEp2J6LqNVLd6AwrS6Q==
X-Received: by 2002:a63:234c:: with SMTP id u12mr1561512pgm.384.1572469471231;
 Wed, 30 Oct 2019 14:04:31 -0700 (PDT)
Date:   Wed, 30 Oct 2019 14:04:15 -0700
In-Reply-To: <20191030210419.213407-1-morbo@google.com>
Message-Id: <20191030210419.213407-3-morbo@google.com>
Mime-Version: 1.0
References: <20191015000411.59740-1-morbo@google.com> <20191030210419.213407-1-morbo@google.com>
X-Mailer: git-send-email 2.24.0.rc1.363.gb1bccd3e3d-goog
Subject: [kvm-unit-tests PATCH v3 2/6] pci: cast the masks to the appropriate size
From:   Bill Wendling <morbo@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, thuth@redhat.com
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
2.24.0.rc1.363.gb1bccd3e3d-goog

