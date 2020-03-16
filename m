Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41923186FB9
	for <lists+kvm@lfdr.de>; Mon, 16 Mar 2020 17:13:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731986AbgCPQNF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Mar 2020 12:13:05 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:20157 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731545AbgCPQNF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Mar 2020 12:13:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584375184;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=va3NBmW9VPeLqbh+njzNv2dIJgLWDq461h5IT9vGT6A=;
        b=Tm+GtEFsN0uDaaONWaJVNG536jb1dHCyzbkcYOAPnqpx4qkbNtRowO+55SadvEvdOS/W5f
        nB0y0U8bbiJSLtHc9kr22+oBkbyN/BBj1CXejpQ0fIlfKCwrgWNvcfR0cu440aDxjan1Xu
        yrCa5WE0uO2YfXsom+tsjowd2NsdoQA=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-342-qc5qexchOQy6aQfeL2ltQQ-1; Mon, 16 Mar 2020 12:06:55 -0400
X-MC-Unique: qc5qexchOQy6aQfeL2ltQQ-1
Received: by mail-wr1-f70.google.com with SMTP id 94so4576357wrr.3
        for <kvm@vger.kernel.org>; Mon, 16 Mar 2020 09:06:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=va3NBmW9VPeLqbh+njzNv2dIJgLWDq461h5IT9vGT6A=;
        b=kQ5NZigN1XD6+2vabvViEuK1vc2pBp0D1q63ff44rNMIgPNXJRPZP9Ey1oSK46uSYX
         SmIuHqARQKpp81V1HByg2GrNHDFFPzom0xWoXVeL7gt4Bm2Q5Ftg4eL/B2kM1xt3qgSX
         SwUJK2/v0V1P+0nSXBpKkNnfIUivkBgmrhOF0N9rf/ZNitQw4luyFCQ3cW6c0s95WfSK
         KF5u3rFnoZH8RX6SxGQPh0p+WaRvmgb4UMhsz3gg54hLEMgzNxyKa0+4JSKWhQo5IzU4
         psxsoo3XYagrXZt4s8/eaoH8HZcPyAwGevGFHT2w6VtsBr+Whr6yFK7JDURoDNgLaKjB
         5sog==
X-Gm-Message-State: ANhLgQ37J1qZWSmcEmtgg/M2IQGxGr2cW9Qut/s7VNhq9v3wbjUxdEtB
        VfbXogHkcOj6zesE5P93veE51W4YH0U4ZxMnQzVAd+Q5jRrBsAWc6kwYl26JdOx7Ha96MUEqSb6
        3RiW/xXXdjZCC
X-Received: by 2002:adf:e28b:: with SMTP id v11mr59303wri.229.1584374813953;
        Mon, 16 Mar 2020 09:06:53 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vsw+1a9QL9jAQlQpFFxDwzh9qiZwTfMeMpXHBQWjLbwXCSV+9K1X0BxvHZoZJuaTV1SZQZCVA==
X-Received: by 2002:adf:e28b:: with SMTP id v11mr59285wri.229.1584374813809;
        Mon, 16 Mar 2020 09:06:53 -0700 (PDT)
Received: from localhost.localdomain (96.red-83-59-163.dynamicip.rima-tde.net. [83.59.163.96])
        by smtp.gmail.com with ESMTPSA id b12sm483914wro.66.2020.03.16.09.06.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2020 09:06:53 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        kvm@vger.kernel.org, Thomas Huth <thuth@redhat.com>,
        qemu-arm@nongnu.org, Fam Zheng <fam@euphon.net>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Richard Henderson <richard.henderson@linaro.org>
Subject: [PATCH v3 03/19] target/arm: Restrict DC-CVAP instruction to TCG accel
Date:   Mon, 16 Mar 2020 17:06:18 +0100
Message-Id: <20200316160634.3386-4-philmd@redhat.com>
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

Under KVM the 'Data or unified Cache line Clean by VA to PoP'
instruction will trap.

Fixes: 0d57b4999 ("Add support for DC CVAP & DC CVADP ins")
Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 target/arm/helper.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/target/arm/helper.c b/target/arm/helper.c
index b61ee73d18..924deffd65 100644
--- a/target/arm/helper.c
+++ b/target/arm/helper.c
@@ -6777,7 +6777,7 @@ static const ARMCPRegInfo rndr_reginfo[] = {
     REGINFO_SENTINEL
 };
 
-#ifndef CONFIG_USER_ONLY
+#if !defined(CONFIG_USER_ONLY) && defined(CONFIG_TCG)
 static void dccvap_writefn(CPUARMState *env, const ARMCPRegInfo *opaque,
                           uint64_t value)
 {
@@ -6820,9 +6820,9 @@ static const ARMCPRegInfo dcpodp_reg[] = {
       .accessfn = aa64_cacheop_poc_access, .writefn = dccvap_writefn },
     REGINFO_SENTINEL
 };
-#endif /*CONFIG_USER_ONLY*/
+#endif /* !CONFIG_USER_ONLY && CONFIG_TCG */
 
-#endif
+#endif /* TARGET_AARCH64 */
 
 static CPAccessResult access_predinv(CPUARMState *env, const ARMCPRegInfo *ri,
                                      bool isread)
@@ -7929,7 +7929,7 @@ void register_cp_regs_for_features(ARMCPU *cpu)
     if (cpu_isar_feature(aa64_rndr, cpu)) {
         define_arm_cp_regs(cpu, rndr_reginfo);
     }
-#ifndef CONFIG_USER_ONLY
+#if !defined(CONFIG_USER_ONLY) && defined(CONFIG_TCG)
     /* Data Cache clean instructions up to PoP */
     if (cpu_isar_feature(aa64_dcpop, cpu)) {
         define_one_arm_cp_reg(cpu, dcpop_reg);
@@ -7938,8 +7938,8 @@ void register_cp_regs_for_features(ARMCPU *cpu)
             define_one_arm_cp_reg(cpu, dcpodp_reg);
         }
     }
-#endif /*CONFIG_USER_ONLY*/
-#endif
+#endif /* !CONFIG_USER_ONLY && CONFIG_TCG */
+#endif /* TARGET_AARCH64 */
 
     if (cpu_isar_feature(any_predinv, cpu)) {
         define_arm_cp_regs(cpu, predinv_reginfo);
-- 
2.21.1

