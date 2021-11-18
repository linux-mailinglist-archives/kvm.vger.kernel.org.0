Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72D2845548B
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 07:06:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242754AbhKRGI7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Nov 2021 01:08:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241204AbhKRGI6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Nov 2021 01:08:58 -0500
Received: from mail-oo1-xc2b.google.com (mail-oo1-xc2b.google.com [IPv6:2607:f8b0:4864:20::c2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32752C061570
        for <kvm@vger.kernel.org>; Wed, 17 Nov 2021 22:05:59 -0800 (PST)
Received: by mail-oo1-xc2b.google.com with SMTP id v30-20020a4a315e000000b002c52d555875so2013033oog.12
        for <kvm@vger.kernel.org>; Wed, 17 Nov 2021 22:05:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=atishpatra.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GH5DsMQ3QaWgiH0MtT4VPh8uW1FF7ANWq123A9PIt3o=;
        b=qmL3blZ9nlnWuevH3rA18HtJtKXlurKxYR/1Rp5rBHLDOU5JFq4dprX0iD2YNXF4al
         m0NyR+CqsknraoB6x92KS4a+OsNDUzqfqCxsArkrxNMsXNMYpaxg+pC3UGYh3Z43C+Tw
         wgikDxMfbXo9d9U4E256aDQjLLrv8WrVxdGBw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GH5DsMQ3QaWgiH0MtT4VPh8uW1FF7ANWq123A9PIt3o=;
        b=vbgSi9uxpQxNdU/3IAthwDbSjlCVGfBzSLGys42Co6Yti3lu2gc7WWr4/l1ugP2Zx1
         P8WbIqzEx5LHF/APuECC80DerHIZociOMyszXyYTFgcMr4whgLDY9Y0/RWpp1JKzB6IB
         miunbqfJ6IK3iunS+n/Z6zTTkVMi7wiEuzGwwrbXrnUmvoXsewwsW/KXowcr8lPYmWdd
         V6+xWh/qiSpUiYnZulB2YanIoIgUaxek3Kq9Y/EPTMpvpl2L3mioy/0+OR1vRWPjwVTe
         XDxrJLdJdFask/2yTh8bzzFo9n3gLsc41H7KX3oxX/Tevq6JfCwmMXhjGjUKYBtY76oV
         9Tuw==
X-Gm-Message-State: AOAM531lDXyozRWTL/F6ph/8dtyBCYYDA9gDet1C/nSvkfqs84YpPsYV
        T4pOWTBL6fhpJm4tAsvNwM0y
X-Google-Smtp-Source: ABdhPJztZycF+YPOFZurRn2NUYVGfHgy2vIKmAmLQyQSIRA6iSyF9c1bLqOzpWJpW8w+rIrswzT1+w==
X-Received: by 2002:a4a:5842:: with SMTP id f63mr11953351oob.97.1637215558524;
        Wed, 17 Nov 2021 22:05:58 -0800 (PST)
Received: from fedora.. (99-13-229-45.lightspeed.snjsca.sbcglobal.net. [99.13.229.45])
        by smtp.gmail.com with ESMTPSA id j20sm395379ota.76.2021.11.17.22.05.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Nov 2021 22:05:58 -0800 (PST)
From:   Atish Patra <atishp@atishpatra.org>
To:     linux-kernel@vger.kernel.org
Cc:     Atish Patra <atishp@atishpatra.org>, anup.patel@wdc.com,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org
Subject: [PATCH] MAINTAINERS: Update Atish's email address
Date:   Wed, 17 Nov 2021 22:05:01 -0800
Message-Id: <20211118060501.932993-1-atishp@atishpatra.org>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I no longer employed by western digital. Update my email address to
personal one.

Signed-off-by: Atish Patra <atishp@atishpatra.org>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 7a2345ce8521..b22af4edcd08 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10434,7 +10434,7 @@ F:	arch/powerpc/kvm/
 
 KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)
 M:	Anup Patel <anup.patel@wdc.com>
-R:	Atish Patra <atish.patra@wdc.com>
+R:	Atish Patra <atishp@atishpatra.org>
 L:	kvm@vger.kernel.org
 L:	kvm-riscv@lists.infradead.org
 L:	linux-riscv@lists.infradead.org
-- 
2.33.1

