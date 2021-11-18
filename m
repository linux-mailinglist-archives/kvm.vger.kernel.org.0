Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0673A4562CE
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 19:46:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231720AbhKRSt5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Nov 2021 13:49:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231526AbhKRSt4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Nov 2021 13:49:56 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29733C061574
        for <kvm@vger.kernel.org>; Thu, 18 Nov 2021 10:46:56 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id 67-20020a1c1946000000b0030d4c90fa87so5591565wmz.2
        for <kvm@vger.kernel.org>; Thu, 18 Nov 2021 10:46:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tOmySd5ZdC4WjR5pqWQluHQkWraboy7ZlqKYZZCFjto=;
        b=odLpz8EZ1vyqBAm0rFDZYV49GrwMKDvbxKQ+SyB2aLw0WE8TCSj/Bcy2Xe+Hmz9Yt3
         LhghE7I8TGtpPFT7Sx+h6c0SFZZZqdRuXFVetqaah8ct5fZeP9NLx1w16f9tf5UHFOap
         Q6LFGeNlkOa9WLERkzmi4vtzJNU8HSygywuPF3ynjMS1c3lsHDwQQGA/QbdCC43OICgM
         MUBL/rYK2YWxE1utNrG4cJLqyQmNClwBwhzWgzZXcZTHVmqV9D0zmd5Qfqirl2QVqrks
         bJgSkgaPxF7pqt4M3r/afE2djzrsEJS4xQkH+3X9L76mX6e3eOJvbogjrENFed54AwbF
         /wEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tOmySd5ZdC4WjR5pqWQluHQkWraboy7ZlqKYZZCFjto=;
        b=rXN4hi/Qw/PdrbUa7LhLXKK1Vj0dz18T0SVphOIZSgabPI3SHMk0CItbmlO2X7nXI2
         B83Q5pXAvH3QBoYUUjMtpcGsSctu/zv2VQo2pln2rZE8MjdcVarE1KWhX7Df9oX9qzVi
         RO6FSpUN5QxlmcYgdkZ36b+d2LiRte0qgytpF8L9IteDiDz86VstK9qxg5uriF0XmyQf
         RufoIalVlfybMmEoT3MK4VjzcJaL0njF0ZRPX7t2KU1KCZaYwQpy+JFm3RL5qWxE4iWo
         K9KuWE/KaQF4+u2P9kzN3+VG+YgyUtCnekwPCgxy5S8SHaIAMGjBWPF4rLcIheNq1iWb
         IPhA==
X-Gm-Message-State: AOAM532o4iiQcMtpXZLFimRiFV8vnutTjX+c5X7MZvyDpwK3ewDPRYza
        EyarVg3ZZUMJfHoynqdClT9XKg==
X-Google-Smtp-Source: ABdhPJyHr89MEcvcKNNgqQkU7LLmSsVqr9xPkXN6m1nHufZRRPmyHO/j2xfEPRMZ4+sIHj9mgtlOow==
X-Received: by 2002:a05:600c:4e01:: with SMTP id b1mr12398367wmq.109.1637261214762;
        Thu, 18 Nov 2021 10:46:54 -0800 (PST)
Received: from zen.linaroharston ([51.148.130.216])
        by smtp.gmail.com with ESMTPSA id n129sm464676wmn.36.2021.11.18.10.46.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 10:46:50 -0800 (PST)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 4A7EF1FF99;
        Thu, 18 Nov 2021 18:46:50 +0000 (GMT)
From:   =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     kvm@vger.kernel.org
Cc:     idan.horowitz@gmail.com, qemu-arm@nongnu.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        christoffer.dall@arm.com, maz@kernel.org,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [kvm-unit-tests PATCH v8 02/10] arm/flat.lds: don't drop debug during link
Date:   Thu, 18 Nov 2021 18:46:42 +0000
Message-Id: <20211118184650.661575-3-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211118184650.661575-1-alex.bennee@linaro.org>
References: <20211118184650.661575-1-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It is useful to keep the debug in the .elf file so we can debug and it
doesn't get copied across to the final .flat file. Of course we still
need to ensure we apply the offset when we load the symbols based on
where QEMU decided to load the kernel.

  (gdb) symbol-file ./builds/arm64/arm/tlbflush-data.elf -o 0x40080000

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 arm/flat.lds | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arm/flat.lds b/arm/flat.lds
index 6fb459e..47fcb64 100644
--- a/arm/flat.lds
+++ b/arm/flat.lds
@@ -62,7 +62,6 @@ SECTIONS
     /DISCARD/ : {
         *(.note*)
         *(.interp)
-        *(.debug*)
         *(.comment)
         *(.dynamic)
     }
-- 
2.30.2

