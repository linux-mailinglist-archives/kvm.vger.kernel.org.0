Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C03495E7DD3
	for <lists+kvm@lfdr.de>; Fri, 23 Sep 2022 17:03:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230058AbiIWPDV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Sep 2022 11:03:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbiIWPDU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Sep 2022 11:03:20 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC87E12755A
        for <kvm@vger.kernel.org>; Fri, 23 Sep 2022 08:03:16 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id x18so418893wrm.7
        for <kvm@vger.kernel.org>; Fri, 23 Sep 2022 08:03:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date;
        bh=ln6lt2/0AsjhyrSMszcxH3SAXXnwFICQorae44PeZPQ=;
        b=U9ia683h3uFyV6wY5KaGKqpH1NJLJvcFP8d5ngCxkSzdWrQoG/TH1NSRZp8xg8fP7V
         Py0i/ctRwXeBwWv2/hfdd/EjrS4wPTrp+PjBgFTpxHjIhXhJ2qHtRDLVn/jVaqH2PYvN
         i3dF+Pd+lgBmLWI2lMQodCe9/Mqr44NzaFAOISZ/JsEkdZMoju00ndiQSsKFoS1yUwxR
         GF4bOrW6Nbmw8BGhV6A0tlfZVla59SxFQUEvmx4WPZyWFVEO3RTe58YN/72Y3J51tli5
         JhTd+UCZSw0ryH0YuZCb8DyV1Mi1wMSqgeY0uqZ+IuSOOvt2pIOR4c7AZRahKVZ/cXy6
         0Prg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date;
        bh=ln6lt2/0AsjhyrSMszcxH3SAXXnwFICQorae44PeZPQ=;
        b=msEPce5z2VAbPsUkXdv8rT5aj1zVG0nSmCde5EBOhwFPIahMnrxTZYACc73wPgbAnj
         s3kkjrD63/V5s8ESPQ/5yz2Eh5HXmKaoVnYIGOAqrCDeyms4wJuEmie7wB9X++jULbyg
         njlx9LMSj2Y1EfGmNivbtTOed6WUMKfGie/bl6ZzpRAdAcZUi7yGKIim/QjbxjVelnO8
         PSZ56lMvhriZ80QEghdat2aewiBefpJic6g6C2OxvQ0i996iJFzeqWaXTDYAVsj46cRg
         8haHztNm3HTaHwdKfXzxFZJ8/Akt3u7FjtygQl1LF7nPaUu79bmrTF5JF50looO+GNQ/
         PZNA==
X-Gm-Message-State: ACrzQf36O3lwF1W/cJEACza6crZxIGCAZkOzC+ckt6ZyobjLcEvEpGYH
        m/MPaM55BqtILi0ElOblLQEjwPHV2W/w3WeskKqwEVAvZPlsyA==
X-Google-Smtp-Source: AMsMyM5AeSV3mSR6kanYYYjOQd/H/+E3LMzaaiQB0W1oqzpwM2oRaqBgYptViKv6R+XMY2dhOz4yRGZVtmR3RZBAN6E=
X-Received: by 2002:a5d:44cf:0:b0:228:dc26:eb3c with SMTP id
 z15-20020a5d44cf000000b00228dc26eb3cmr5484742wrr.389.1663945395301; Fri, 23
 Sep 2022 08:03:15 -0700 (PDT)
MIME-Version: 1.0
From:   Hao Peng <flyingpenghao@gmail.com>
Date:   Fri, 23 Sep 2022 23:03:03 +0800
Message-ID: <CAPm50aKnctFL_7fZ-eqrz-QGnjW2+DTyDDrhxi7UZVO3HjD8UA@mail.gmail.com>
Subject: [PATCH] kvm: vmx: keep constant definition format consistent
To:     "pbonzini@redhat.com" <pbonzini@redhat.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Peng Hao <flyingpeng@tencent.com>
Keep all constants using lowercase "x".

Signed-off-by: Peng Hao <flyingpeng@tencent.com>
---
 arch/x86/include/asm/vmx.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index 0ffaa3156a4e..d1791b612170 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -296,7 +296,7 @@ enum vmcs_field {
        GUEST_LDTR_AR_BYTES             = 0x00004820,
        GUEST_TR_AR_BYTES               = 0x00004822,
        GUEST_INTERRUPTIBILITY_INFO     = 0x00004824,
-       GUEST_ACTIVITY_STATE            = 0X00004826,
+       GUEST_ACTIVITY_STATE            = 0x00004826,
        GUEST_SYSENTER_CS               = 0x0000482A,
        VMX_PREEMPTION_TIMER_VALUE      = 0x0000482E,
        HOST_IA32_SYSENTER_CS           = 0x00004c00,
--
2.27.0
