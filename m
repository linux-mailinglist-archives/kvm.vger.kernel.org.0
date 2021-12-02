Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17BC94662D3
	for <lists+kvm@lfdr.de>; Thu,  2 Dec 2021 12:54:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346488AbhLBL52 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Dec 2021 06:57:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357457AbhLBL5Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Dec 2021 06:57:25 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8A4EC06174A
        for <kvm@vger.kernel.org>; Thu,  2 Dec 2021 03:54:02 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id d24so59191640wra.0
        for <kvm@vger.kernel.org>; Thu, 02 Dec 2021 03:54:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wneIr30hD8kwc2U2ZHDOLOB1FKf9OkenNldv6kSi2AM=;
        b=Kl8tpBn3Y4zU/zs7x1c8P4KdomOcl3MaAS8EWFeE7oHSV04KCwa9TLqHYrAAzy5J7I
         wa4tSSqN+ShT+QikZhcxIzZIu2KcYxPUlopTvfp5sRAlI2R8DHCduDkoe9dTVCMJEYWa
         hDfxQJJPvcyZjW3aVHzX3Axe43hNFpw1LuOXAiDCb60aUwOey6KHz0/93hxGFsr0AM5B
         UGWWHV9kPmNCOz8JpoM3/y3jo2L2lP3AVjgPbn8OgeqP97UlkJr7dxcygdC0Ehq7LQAT
         HBSXQvt5NE4nMH+06kUQOqEi1zDJP2Ip97ZswEZgVSjtcVUFof3tagewKS+XzHzby3dZ
         dG+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wneIr30hD8kwc2U2ZHDOLOB1FKf9OkenNldv6kSi2AM=;
        b=FkUA3XAhJ3dGY30F35Pz4hZUAN9XRuW1MYE0xoYFcz391O61Doz1GO7vxLI6xRu7g+
         gwyIwrF9KxDZ9+5LF/h9hlT8D4l/eoKEv27ODtw7J0uPit8x2eTw8bO1bD8iUvmpQF1d
         x4ksvAaYZre/KbK9M1KnkV/qAWH8S3q/04/iX3jj1ItpCR5bG1xpR/zPcL3y3uvkeb2X
         HHt7G8fHY/FggabPh8zVfDZj5qvii06qYE3cjeY2/X1JulgK2DN7SxthvHC3LR7aOy7d
         M1hzRbmyZJuiDunl54YFDLglmYHaLAFHQ9P/gEMDKNZN/x41FP4pUlEb9Y6XB1/WN+LN
         GFEA==
X-Gm-Message-State: AOAM532e5FdRbfXV5OkMFr0gFa4bNIUIR7sHB2xA+AKZ0LFZE49hOoUI
        +7gg5QR5ManEmu+n5otZlPN7jQ==
X-Google-Smtp-Source: ABdhPJwUUxRIHM8yJU+oqo6jm79Z11Fsxaw5Hbqb20NEb7IxqlmIAH8vSpJU5mnNeUF7SN/OO+EYFw==
X-Received: by 2002:adf:f001:: with SMTP id j1mr13874475wro.351.1638446041299;
        Thu, 02 Dec 2021 03:54:01 -0800 (PST)
Received: from zen.linaroharston ([51.148.130.216])
        by smtp.gmail.com with ESMTPSA id 9sm3136858wry.0.2021.12.02.03.53.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 03:53:59 -0800 (PST)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 12A061FF9F;
        Thu,  2 Dec 2021 11:53:53 +0000 (GMT)
From:   =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     pbonzini@redhat.com, drjones@redhat.com, thuth@redhat.com
Cc:     kvm@vger.kernel.org, qemu-arm@nongnu.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        christoffer.dall@arm.com, maz@kernel.org,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [kvm-unit-tests PATCH v9 8/9] arm/run: use separate --accel form
Date:   Thu,  2 Dec 2021 11:53:51 +0000
Message-Id: <20211202115352.951548-9-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211202115352.951548-1-alex.bennee@linaro.org>
References: <20211202115352.951548-1-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This will allow TCG tests to alter things such as tb-size.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
Message-Id: <20211118184650.661575-10-alex.bennee@linaro.org>
---
 arm/run | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arm/run b/arm/run
index a390ca5a..73c6c83a 100755
--- a/arm/run
+++ b/arm/run
@@ -58,8 +58,8 @@ if $qemu $M -device '?' 2>&1 | grep pci-testdev > /dev/null; then
 	pci_testdev="-device pci-testdev"
 fi
 
-M+=",accel=$ACCEL"
-command="$qemu -nodefaults $M -cpu $processor $chr_testdev $pci_testdev"
+A="-accel $ACCEL"
+command="$qemu -nodefaults $M $A -cpu $processor $chr_testdev $pci_testdev"
 command+=" -display none -serial stdio -kernel"
 command="$(migration_cmd) $(timeout_cmd) $command"
 
-- 
2.30.2

