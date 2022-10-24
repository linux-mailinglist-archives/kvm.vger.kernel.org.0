Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34B35609D9B
	for <lists+kvm@lfdr.de>; Mon, 24 Oct 2022 11:13:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbiJXJNi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Oct 2022 05:13:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231171AbiJXJNZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Oct 2022 05:13:25 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30FDF6A48E
        for <kvm@vger.kernel.org>; Mon, 24 Oct 2022 02:13:18 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id s196so8201610pgs.3
        for <kvm@vger.kernel.org>; Mon, 24 Oct 2022 02:13:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eOfqx+essPUE8lmXeQjnIuCL9UwXhImUnnXh9pI3KvM=;
        b=ewfPXUBMDWRXLWxBUjPrA8gE6/K6t7jM5xffg3JCm7j8AKu9TpyNkvnV7VnveRGlnx
         a2An1L0ikWriq4Q1tZWo/KJNfpCJuNzhI6t1XB4soPqw2zoZS5jntOqmnerseqhmFHUh
         GL/OEhh3YGDdzw0aZ1TXH/fCaYZfnZOPC5001H4RmVuQ1NPCktBvNz2nb8o2EEVgaGPa
         YAW94VlkyZYBdaP59s06anEIEniVCEHmu/1JQfbSgyyfZN5/F5MO7hhQdRcPHEI95zOC
         b4GDH9pxa/idov7P4MYSKk1gAUHB67pdq9LDMvuZeFZRh3AVRSZXI3c0pAFDh5Zqhy1j
         6t+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eOfqx+essPUE8lmXeQjnIuCL9UwXhImUnnXh9pI3KvM=;
        b=YVz5Mpc++Sjml9vQkGonPONP5Uan3oIGpCWelxjqlgChVVz+HUVSOz0GHsVQQ146hZ
         nOIsElwF38SsZFeWv1yqR/1Zd/Hu7PoqCMexAXfphmKpo/AHY9YXHIZumK9EA2KNaF1a
         d6QJnCQ9Ynjf4AEBw154jNWZVJFL0b7wP+TT+S3BHo6hJ96VYifU+Gr66vlTr5+KB0Wi
         sX+FrIS3/6ry+4Vw3vXwWp6M30g1jh/D/1k4O93MDIQIR+fKS0z4Q7fhaLA2RkwqraDk
         u8CL7LAUglB2y+9XYvlAQqbx3gfKuc+PsJSqrxr/a0yTB4wFqRH73TZ+tyYfDeD2l9x3
         6mRg==
X-Gm-Message-State: ACrzQf1E3Jer+lOVsVsrihl06PvVFWeVHEWqKOGRz1CcnAJ/YlP6AfZg
        1LG0y23l6MaGk0o7WfOYH6pnm8GxFMD0SIv0
X-Google-Smtp-Source: AMsMyM5drsRBhb4L2L9qCVOzPOPv4VD3hlQk+hC820KGsG6+RyNiI/nem3I2Yw3I+PRI9l5aR3XaFQ==
X-Received: by 2002:a63:1f5c:0:b0:469:d0e6:dac0 with SMTP id q28-20020a631f5c000000b00469d0e6dac0mr26683091pgm.427.1666602798004;
        Mon, 24 Oct 2022 02:13:18 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id r15-20020aa79ecf000000b00535da15a252sm19642213pfq.165.2022.10.24.02.13.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Oct 2022 02:13:17 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v4 10/24] x86/pmu: Refine info to clarify the current support
Date:   Mon, 24 Oct 2022 17:12:09 +0800
Message-Id: <20221024091223.42631-11-likexu@tencent.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024091223.42631-1-likexu@tencent.com>
References: <20221024091223.42631-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

Existing unit tests do not cover AMD pmu, nor Intel pmu that is not
architecture (on some obsolete cpu's). AMD's PMU support will be
coming in subsequent commits.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 x86/pmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index bb6e97e..15572e3 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -658,7 +658,7 @@ int main(int ac, char **av)
 	buf = malloc(N*64);
 
 	if (!pmu_version()) {
-		report_skip("No pmu is detected!");
+		report_skip("No Intel Arch PMU is detected!");
 		return report_summary();
 	}
 
-- 
2.38.1

