Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC0BC23BAA6
	for <lists+kvm@lfdr.de>; Tue,  4 Aug 2020 14:46:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727987AbgHDMoZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Aug 2020 08:44:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726210AbgHDMoV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Aug 2020 08:44:21 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6782C06174A
        for <kvm@vger.kernel.org>; Tue,  4 Aug 2020 05:44:20 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id z18so33702416wrm.12
        for <kvm@vger.kernel.org>; Tue, 04 Aug 2020 05:44:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CYDox3KQ1JETO7R6nCajEi5q9XM0wuEKwlQrdfldtzE=;
        b=Riv8iutgfQUgNDMN92DtQvb/ueHJ6AIreMGAIsPCtm4ILvbZOn+PBNFru/JxFRQn+a
         9TfiKx4DTAO1/mtV9wsMqag4ynofuu+qJ8KcnT0H01tQepbNaqDTZvqQvMuZtPQBOduf
         CxLDVXhPdqFLT0zbGguTGrJKZfH+S/lGnAzhvNTBi0FcUKC5HJp/+r/qZDgMqCN1u61M
         ZIBRfcVMUR48Uz0nrWv/JeBjsaFxjG5I/w8jfhHReJuMa+Pm25oX2mloao7+N1Yr/e42
         uovU2IyFUipCeXc7bYv0WjUNANHbOH3ka4foDQ5we7li93TpmE8H4yyBhs21Q8mbmEQA
         00PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CYDox3KQ1JETO7R6nCajEi5q9XM0wuEKwlQrdfldtzE=;
        b=sZFEiDBrVbZJXjMpuuuw7OkGxU4lrmGi+gxJQ1/dFnX6/MoLgBtw/NBoaNj4DUAm4D
         7rvaSIuv9yOzwqzRMeOTxaF8vnNR0JL7BZYGN+Xa+skSkYhIgzaVelPHJ8v/ZVGw2XRd
         jUx/284n6UID6VFvbh3AzsVhyGRRhgkriYYAuhHFNyO7ZmwXcAMn/V3Vqd+hRJnallgb
         EChx6ReTx+f6bsLTTb1IuWKqUE6/6pnkkcUsCV1SrHng+ahfT20gy+xk06MOqMrDP86+
         YeSvvLpZnE3L2ogR+KsMTIrUyoWWWici2bAHxWiJm8dU39twMqicoNkEw09A2s+BijQr
         0TjA==
X-Gm-Message-State: AOAM533ylevJV7pRCvyph7K7Yu1UEuoT/5lLtlcwJQAY2eznOCxfR9Pl
        yAGUZHQzI43dnAQ0xJgIi4H8AA==
X-Google-Smtp-Source: ABdhPJy369HvI22rb0UHPSZq9AsVjFavkg1pT+b1lsUC4Du192zTR5pC4Bv0+KzFRIkrLbZspUmmgg==
X-Received: by 2002:a5d:6a4a:: with SMTP id t10mr20525689wrw.360.1596545059657;
        Tue, 04 Aug 2020 05:44:19 -0700 (PDT)
Received: from zen.linaroharston ([51.148.130.216])
        by smtp.gmail.com with ESMTPSA id z207sm4576048wmc.2.2020.08.04.05.44.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2020 05:44:18 -0700 (PDT)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 9DC9E1FF8F;
        Tue,  4 Aug 2020 13:44:17 +0100 (BST)
From:   =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc:     linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        christoffer.dall@arm.com, maz@kernel.org,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [PATCH  v1 3/3] kernel/configs: don't include PCI_QUIRKS in KVM guest configs
Date:   Tue,  4 Aug 2020 13:44:17 +0100
Message-Id: <20200804124417.27102-4-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200804124417.27102-1-alex.bennee@linaro.org>
References: <20200804124417.27102-1-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The VIRTIO_PCI support is an idealised PCI bus, we don't need a bunch
of bloat for real world hardware for a VirtIO guest.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 kernel/configs/kvm_guest.config | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/configs/kvm_guest.config b/kernel/configs/kvm_guest.config
index 208481d91090..672863a2fdf1 100644
--- a/kernel/configs/kvm_guest.config
+++ b/kernel/configs/kvm_guest.config
@@ -13,6 +13,7 @@ CONFIG_IP_PNP_DHCP=y
 CONFIG_BINFMT_ELF=y
 CONFIG_PCI=y
 CONFIG_PCI_MSI=y
+CONFIG_PCI_QUIRKS=n
 CONFIG_DEBUG_KERNEL=y
 CONFIG_VIRTUALIZATION=y
 CONFIG_HYPERVISOR_GUEST=y
-- 
2.20.1

