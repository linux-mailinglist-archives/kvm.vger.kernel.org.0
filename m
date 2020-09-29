Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C2FF27DC3F
	for <lists+kvm@lfdr.de>; Wed, 30 Sep 2020 00:44:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729126AbgI2Wo6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Sep 2020 18:44:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52944 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728926AbgI2Wo6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 29 Sep 2020 18:44:58 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601419496;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mwQAv7GT5EoZ2YwHLMCVUEVsXLr1pwlweOoW7BxG2J0=;
        b=Zmg0cbXGzj+/lxoyJHwsC1JpuHZo4vkEcnk52RF2mwi/3UFTWyh+w+DTtow1113csTWxD+
        BX7gfsZwH/Sv0fGY5lco4Qm3HzHLldemr7NrsIzuhZoI44Cgr/7533huAsBu3ow50uRc1m
        MqD/tV76JKxkFy7AcBacgsdOaSG8K9s=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-429-u6WlFHSHOA2tG9S9zujKfw-1; Tue, 29 Sep 2020 18:44:55 -0400
X-MC-Unique: u6WlFHSHOA2tG9S9zujKfw-1
Received: by mail-wr1-f71.google.com with SMTP id s8so2339001wrb.15
        for <kvm@vger.kernel.org>; Tue, 29 Sep 2020 15:44:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mwQAv7GT5EoZ2YwHLMCVUEVsXLr1pwlweOoW7BxG2J0=;
        b=Ma9PJdAY2o98Qwq28QyPUAfMOBaF3mNgqqGIIwKkXFfsgd7Pm25C6iYaYJWL+LfOpM
         REiEaw+mYURCXhcs2muvfd8civw18xXK925Zl4WtINyzSuO2ZaOP5+Q5DZG/E1Trm18U
         QFqmyDqo6jKW4anc4KOGW3cnuKZLBD/F2lbqF1Rvr+685aGza36UzfSu3ltEGStCHn0D
         aqXU1mqi9Aob65I2Q+qVygzhzEXFgO+TVTL3Dzw2Icohg54n3WhujgwW2+osznzq6m/Z
         CaZzFAqxh/69mE+M06vre7CmVvonnevV2jnYxL3jOC6DnmC/FQhGwKpiSI7IRYhJ3S8B
         aNyA==
X-Gm-Message-State: AOAM533rZAkSVjEDAsw5wnHje8pXt0jbsR0NPgkF5np/sdoZi2Rl8nxG
        Z58fqa2YK4P6x6j3NzFU5tXQNHrX7rOdkrXzJ3s6pbkr3LOYJEqYkrbzbd52Sh/MxGrFcV1Xh4b
        41lu2iq9oVw1I
X-Received: by 2002:a5d:680b:: with SMTP id w11mr7120264wru.73.1601419494004;
        Tue, 29 Sep 2020 15:44:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwaezhlYa4iLWEZHwZ0kS7XLDzMCgEOlneNy29+EtQChDtpMkw2+jc9ZW303waN+0a4Rlb8Xw==
X-Received: by 2002:a5d:680b:: with SMTP id w11mr7120247wru.73.1601419493850;
        Tue, 29 Sep 2020 15:44:53 -0700 (PDT)
Received: from x1w.redhat.com (74.red-83-53-161.dynamicip.rima-tde.net. [83.53.161.74])
        by smtp.gmail.com with ESMTPSA id u66sm15214592wme.1.2020.09.29.15.44.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2020 15:44:53 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Thomas Huth <thuth@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Fam Zheng <fam@euphon.net>,
        Peter Maydell <peter.maydell@linaro.org>, kvm@vger.kernel.org,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        qemu-arm@nongnu.org, Richard Henderson <rth@twiddle.net>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Subject: [PATCH v4 11/12] target/arm: Reorder meson.build rules
Date:   Wed, 30 Sep 2020 00:43:54 +0200
Message-Id: <20200929224355.1224017-12-philmd@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200929224355.1224017-1-philmd@redhat.com>
References: <20200929224355.1224017-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Reorder the rules to make this file easier to modify.

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
I prefer to not squash that with the previous patch,
as it makes it harder to review.
---
 target/arm/meson.build | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/target/arm/meson.build b/target/arm/meson.build
index 9b7727d4bb..341af8f2ca 100644
--- a/target/arm/meson.build
+++ b/target/arm/meson.build
@@ -14,6 +14,7 @@ gen = [
 
 arm_ss = ss.source_set()
 arm_ss.add(gen)
+arm_ss.add(zlib)
 arm_ss.add(files(
   'cpu.c',
   'gdbstub.c',
@@ -21,6 +22,13 @@ arm_ss.add(files(
   'vfp_helper.c',
 ))
 
+arm_ss.add(when: 'CONFIG_KVM', if_true: files('kvm.c', 'kvm64.c'), if_false: files('kvm-stub.c'))
+
+arm_ss.add(when: 'TARGET_AARCH64', if_true: files(
+  'cpu64.c',
+  'gdbstub64.c',
+))
+
 arm_tcg_ss = ss.source_set()
 arm_tcg_ss.add(files(
   'arm-semi.c',
@@ -35,26 +43,16 @@ arm_tcg_ss.add(files(
   'vec_helper.c',
 ))
 
-arm_tcg_ss.add(when: 'CONFIG_ARM_V7M', if_true: files('m_helper.c'), if_false: files('m_helper-stub.c'))
-
-arm_ss.add(zlib)
-
 arm_ss.add(when: 'CONFIG_TCG', if_false: files('m_helper-stub.c'))
-
-arm_ss.add(when: 'CONFIG_KVM', if_true: files('kvm.c', 'kvm64.c'), if_false: files('kvm-stub.c'))
-
-arm_ss.add(when: 'TARGET_AARCH64', if_true: files(
-  'cpu64.c',
-  'gdbstub64.c',
-))
+arm_tcg_ss.add(when: 'CONFIG_ARM_V7M', if_true: files('m_helper.c'), if_false: files('m_helper-stub.c'))
 
 arm_tcg_ss.add(when: 'TARGET_AARCH64', if_true: files(
   'helper-a64.c',
   'mte_helper.c',
   'pauth_helper.c',
-  'sve_helper.c',
   'translate-a64.c',
   'translate-sve.c',
+  'sve_helper.c',
 ))
 
 arm_ss.add_all(when: 'CONFIG_TCG', if_true: arm_tcg_ss)
-- 
2.26.2

