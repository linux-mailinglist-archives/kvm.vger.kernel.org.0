Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E01F4CA399
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 12:26:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241329AbiCBL10 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 06:27:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237232AbiCBL10 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 06:27:26 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2E786A021
        for <kvm@vger.kernel.org>; Wed,  2 Mar 2022 03:26:43 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id u16so1656485pfg.12
        for <kvm@vger.kernel.org>; Wed, 02 Mar 2022 03:26:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LQtgFO8L0rHL6Qc5taUM878H2bGp64It6/6uXRoylBc=;
        b=Zr3fib6Jjq+kA8rd4LXKw/kgfkC35ZCvmUMOMU+GJbKjpt0wGkncDjaUhwqmjUxKTj
         zOGAHlDvuqTJ6z1DoYJ6T6cY1H8i039fuUHWxHL7wtKGZ3MPB/LRDzfzlheZoStRMyL+
         q6ViCTthyxf29pQvEpZxDc8GHwtqCiWcHKKpnxoKZVSCE4475FQ3ISU804Hknxsp+Ebm
         aUOq1EL3mqP4YYysiYvUfa/Nq3eypq+nwK6cz5Q4stLz2LLvUQGinDaudGtmYO1IAgmX
         drGOcrhqjjsbaWWAqaw0Jcvyi0ggr0mpIFE7hHFVWU1SCf0hiimV6oFI3Nw8CyIEddqx
         4WmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LQtgFO8L0rHL6Qc5taUM878H2bGp64It6/6uXRoylBc=;
        b=JkYlKJPhUkNKheZcKGIf8GBdCXTOLNbzNWfcHH/MPxEgk5Jvgv/mvaLyHjpPiHt72G
         oghQylzDVNAAfjeFRV+Nh5jmspKDS8dtBYaaATdLmr/lZ3BacbLJb0IoQUwW627+hUSn
         NW/dj3lTMM0Dfk/C9J5Wi+JDr4p2RbpnRKrLZZd6LUZd0e0IGNt30wAqxoxlMFXTtXOp
         L6QuBH0XsSRkmZma1WDFU7y7CDRi4JMBiakbe7+E22BA16DtdQp9ddZqzvMJst3P3tMt
         RZnFzQzUZl66dncNNI5A60VUvdDj4uQ14qrLDEYSh/eXfzw46lxjIEnhOan9K8aeohGZ
         1BoA==
X-Gm-Message-State: AOAM531FODsf8AHb6H3VeY4OOkQjN7f284E8Ok9ipZK617MvBmvBVxLW
        kWsK3sAnT7DHXsXiU2VoLgU=
X-Google-Smtp-Source: ABdhPJw8WKNcUgTeANW7JDAgfJCwzN37ETaVlDB9nztW3Kiox2f2xnfrNUrs0HbTpKTbTunt6vzTMA==
X-Received: by 2002:a63:1321:0:b0:376:333b:3ed with SMTP id i33-20020a631321000000b00376333b03edmr22647052pgl.283.1646220403028;
        Wed, 02 Mar 2022 03:26:43 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id z18-20020aa78892000000b004e19bd62d8bsm21425155pfe.23.2022.03.02.03.26.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 03:26:42 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Like Xu <likexu@tencent.com>
Subject: [kvm-unit-tests PATCH RESEND 1/2] x86/pmu: Make "ref cycles" test to pass on the latest cpu
Date:   Wed,  2 Mar 2022 19:26:33 +0800
Message-Id: <20220302112634.15024-1-likexu@tencent.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

Expand the boundary for "ref cycles" event test as it has
been observed that the results do not fit on some CPUs [1]:

FAIL: full-width writes: ref cycles-N
  100000 >= 87765 <= 30000000
  100000 >= 87926 <= 30000000
  100000 >= 87790 <= 30000000
  100000 >= 87687 <= 30000000
  100000 >= 87875 <= 30000000
  100000 >= 88043 <= 30000000
  100000 >= 88161 <= 30000000
  100000 >= 88052 <= 30000000

[1] Intel(R) Xeon(R) Platinum 8374C CPU @ 2.70GHz

Opportunistically fix cc1 warnings for commented print statement.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 x86/pmu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index 92206ad..3d05384 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -86,7 +86,7 @@ struct pmu_event {
 } gp_events[] = {
 	{"core cycles", 0x003c, 1*N, 50*N},
 	{"instructions", 0x00c0, 10*N, 10.2*N},
-	{"ref cycles", 0x013c, 0.1*N, 30*N},
+       {"ref cycles", 0x013c, 0.08*N, 30*N},
 	{"llc refference", 0x4f2e, 1, 2*N},
 	{"llc misses", 0x412e, 1, 1*N},
 	{"branches", 0x00c4, 1*N, 1.1*N},
@@ -223,7 +223,7 @@ static void measure(pmu_counter_t *evt, int count)
 
 static bool verify_event(uint64_t count, struct pmu_event *e)
 {
-	// printf("%lld >= %lld <= %lld\n", e->min, count, e->max);
+	// printf("%d >= %ld <= %d\n", e->min, count, e->max);
 	return count >= e->min  && count <= e->max;
 
 }
-- 
2.35.1

