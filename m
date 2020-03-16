Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 382B9186FBB
	for <lists+kvm@lfdr.de>; Mon, 16 Mar 2020 17:13:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731994AbgCPQNX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Mar 2020 12:13:23 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:59149 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731991AbgCPQNX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Mar 2020 12:13:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584375201;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yxNTHu0Y9BXexKmUFsNlCCh8LSzlOCW9yO82fm58I4s=;
        b=cnyidcUk9ksnMIUa+VWHBwfrkx32BSgWA/5DtgzW3JgfGOo50FwW6y1RlCeg/fxMTZKjTC
        hSRWLU3ksO749F/Tc6R1pt0rlvnBzYthEL1MnZuEgM2XIw8HgwvcJ/m8AeVkCuN/R0nD49
        LVkHDmiOHkHzCOmrdXecIHSehU8Y18E=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-403-6rI3XHHhMHKLi5nWOkpE2g-1; Mon, 16 Mar 2020 12:07:11 -0400
X-MC-Unique: 6rI3XHHhMHKLi5nWOkpE2g-1
Received: by mail-wr1-f69.google.com with SMTP id 94so4576704wrr.3
        for <kvm@vger.kernel.org>; Mon, 16 Mar 2020 09:07:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yxNTHu0Y9BXexKmUFsNlCCh8LSzlOCW9yO82fm58I4s=;
        b=mMjkJT/DPXw+hSOQgSHd27S7Bh3fPpJ+HRccfMozEUhndfP2DiTas4xFlFrBZqSTu1
         CkGy06OE1SYWuzIsUtOvcizU5iG/IIcvSB9EQTmOzraCdhXYRyE4oTDd3fgrmQu5UgpR
         Oy1COjyszQaNwP+13TpowTUzTkQhoG7VgvhbWZqdm8UPYarhlofX0PCpIaa0EHLuyyWC
         ZFjML5+5Z5n2+Fz8YyLcKe1crMdHE/PpWooY7zk4B0T0ToqYHurjUZZBui/pwL+qnAJt
         hFN3I4EIQ9J8W3Nh+IpYTLbFFQRnTo2qbgPpqwdx79uiTWN5k5v0AZbjQRQtCfcc9c42
         vs4w==
X-Gm-Message-State: ANhLgQ1AZsADC/+M25HN7hndO0yEK+JpeJMrwN8YhbVLA6/88+Y+9BeA
        9C/542MSY93YyzL1ipsBAPcblUNbh5xkL1PqMX28d3gHRznL/b/V65zGbIP1/PZ4yP95GSg9gRD
        G9/WOhocB1RvI
X-Received: by 2002:a7b:c5cd:: with SMTP id n13mr28456586wmk.172.1584374830944;
        Mon, 16 Mar 2020 09:07:10 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vs7IJfPb/lnQB6VsT1fXs4khiy3iYFUFjrhDCacWI//Wr03P/OMBnlYg0XoQf+8TAXToOGQKQ==
X-Received: by 2002:a7b:c5cd:: with SMTP id n13mr28456569wmk.172.1584374830787;
        Mon, 16 Mar 2020 09:07:10 -0700 (PDT)
Received: from localhost.localdomain (96.red-83-59-163.dynamicip.rima-tde.net. [83.59.163.96])
        by smtp.gmail.com with ESMTPSA id p8sm552349wrw.19.2020.03.16.09.07.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2020 09:07:10 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        kvm@vger.kernel.org, Thomas Huth <thuth@redhat.com>,
        qemu-arm@nongnu.org, Fam Zheng <fam@euphon.net>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Richard Henderson <richard.henderson@linaro.org>
Subject: [PATCH v3 06/19] target/arm: Move Makefile variable restricted to CONFIG_TCG
Date:   Mon, 16 Mar 2020 17:06:21 +0100
Message-Id: <20200316160634.3386-7-philmd@redhat.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200316160634.3386-1-philmd@redhat.com>
References: <20200316160634.3386-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Simple code movement which simplifies next commits.

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 target/arm/Makefile.objs | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/target/arm/Makefile.objs b/target/arm/Makefile.objs
index cf26c16f5f..0c6f8c248d 100644
--- a/target/arm/Makefile.objs
+++ b/target/arm/Makefile.objs
@@ -1,4 +1,3 @@
-obj-$(CONFIG_TCG) += arm-semi.o
 obj-y += helper.o vfp_helper.o
 obj-y += cpu.o gdbstub.o
 obj-$(TARGET_AARCH64) += cpu64.o gdbstub64.o
@@ -56,6 +55,12 @@ target/arm/translate.o: target/arm/decode-a32-uncond.inc.c
 target/arm/translate.o: target/arm/decode-t32.inc.c
 target/arm/translate.o: target/arm/decode-t16.inc.c
 
+ifeq ($(CONFIG_TCG),y)
+
+obj-y += arm-semi.o
+
+endif # CONFIG_TCG
+
 obj-y += tlb_helper.o debug_helper.o
 obj-y += translate.o op_helper.o
 obj-y += crypto_helper.o
-- 
2.21.1

