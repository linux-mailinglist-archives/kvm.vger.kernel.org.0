Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84BEE368720
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 21:23:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238811AbhDVTXr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Apr 2021 15:23:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236810AbhDVTXq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Apr 2021 15:23:46 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7920CC06174A;
        Thu, 22 Apr 2021 12:23:11 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id r128so46915693lff.4;
        Thu, 22 Apr 2021 12:23:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=e0qtyejBNKzVyasn4Fe/BMcM/76qCIWOHv2Y82nNLWI=;
        b=Tdmy9zQyWhw7hnnO0VhduA8oxlvWOkcJRDSIyRRniTAiJHGe0XVOenYhm2AyhfRIqm
         mrLNvK22x7sadJEj3AdfnKdzhmDu3GxgQw0wpTGPHJQ/VnmOy4GpScjDH+magYtO3T9q
         aK9Ds1nqMCUaEvynlDK0UTtMkOCQSBVXpmtZqngVNEAJL/tBtbGP1Cttg+zmk6uYXvQt
         pi2z9ZNo4/ljXgXK0xIP7U7G5FhrfKV5AX+7+y+6EnS50V9ma1ikrbyNigjP0xyERqdM
         Gp2SmaUn3bB/+220sXV3XlNG7S+1oVGTYKRB6lufkqw0ilJSfEGwWtJjr58zeW9O4rRe
         g77g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=e0qtyejBNKzVyasn4Fe/BMcM/76qCIWOHv2Y82nNLWI=;
        b=i3qJCb6AZA7PgpxYu1btfawWOigIfrRTxNxG3GHn4Ok7h3x86o0enT1u6EP+8ANx8O
         c4Leu3zj4RUKd/GhqjSUvUg8wxuuH5Wr9qXvuqtwgiBHIqyndJaqa030lXl5qwLQXPYs
         a/ZsvMZEQnAhMEV+jck2Ba88qKlonRf/juOZ12B4bi5M+yUlji8yf+OovTzZsmXap1hb
         lZjWKNRPA5vM0EFeXwfN0yBm4uTEFQOA2fK+h4B7R9MctRlbu7qdmBatJxIRcLZSKASv
         X5SJ/bN2OVgkRSt13W3E29hS0YgZKoMxevRWOUkS4PQUY0P/oIcIzG7n5dy9SOfwq+nj
         ElRA==
X-Gm-Message-State: AOAM5312F4eXbyol2JCP3XZYKKfmdN0LJdApPEtcWgy1aTlxHCrwo9IJ
        YtlS4/5mWAcr4kv8W3sHGylA02fu0cw=
X-Google-Smtp-Source: ABdhPJzAqO9/q1cmEHfiCyXt8qiAuhD3vSrlqaW/Ezyg2zFVlBkgxMJU5FJuec/Ge7mWFLyRc6ieWQ==
X-Received: by 2002:a05:6512:3763:: with SMTP id z3mr3421761lft.487.1619119389723;
        Thu, 22 Apr 2021 12:23:09 -0700 (PDT)
Received: from localhost.localdomain (31-211-229-121.customers.ownit.se. [31.211.229.121])
        by smtp.gmail.com with ESMTPSA id e9sm347493lft.150.2021.04.22.12.23.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 12:23:09 -0700 (PDT)
From:   =?UTF-8?q?Martin=20=C3=85gren?= <martin.agren@gmail.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH] uio/uio_pci_generic: fix return value changed in refactoring
Date:   Thu, 22 Apr 2021 21:22:40 +0200
Message-Id: <20210422192240.1136373-1-martin.agren@gmail.com>
X-Mailer: git-send-email 2.31.1.527.g47e6f16901
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commit ef84928cff58 ("uio/uio_pci_generic: use device-managed function
equivalents") was able to simplify various error paths thanks to no
longer having to clean up on the way out. Some error paths were dropped,
others were simplified. In one of those simplifications, the return
value was accidentally changed from -ENODEV to -ENOMEM. Restore the old
return value.

Fixes: ef84928cff58 ("uio/uio_pci_generic: use device-managed function equivalents")
Signed-off-by: Martin Ågren <martin.agren@gmail.com>
---
 This is my first contribution to the Linux kernel. Hints, suggestions,
 corrections and any other feedback welcome.

 drivers/uio/uio_pci_generic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/uio/uio_pci_generic.c b/drivers/uio/uio_pci_generic.c
index c7d681fef198..3bb0b0075467 100644
--- a/drivers/uio/uio_pci_generic.c
+++ b/drivers/uio/uio_pci_generic.c
@@ -81,9 +81,9 @@ static int probe(struct pci_dev *pdev,
 		return err;
 	}
 
 	if (pdev->irq && !pci_intx_mask_supported(pdev))
-		return -ENOMEM;
+		return -ENODEV;
 
 	gdev = devm_kzalloc(&pdev->dev, sizeof(struct uio_pci_generic_dev), GFP_KERNEL);
 	if (!gdev)
 		return -ENOMEM;
-- 
2.31.1.527.g47e6f16901

