Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26539399F03
	for <lists+kvm@lfdr.de>; Thu,  3 Jun 2021 12:33:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229966AbhFCKfP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Jun 2021 06:35:15 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:33994 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229661AbhFCKfO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Jun 2021 06:35:14 -0400
Received: from mail-pj1-f69.google.com ([209.85.216.69])
        by youngberry.canonical.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <po-hsu.lin@canonical.com>)
        id 1lokfJ-0007bW-OB
        for kvm@vger.kernel.org; Thu, 03 Jun 2021 10:33:29 +0000
Received: by mail-pj1-f69.google.com with SMTP id j1-20020a17090a7381b02901605417540bso3016919pjg.3
        for <kvm@vger.kernel.org>; Thu, 03 Jun 2021 03:33:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sDuovB5h2/0bhrciUlFCKVLzXrSi8D1QKzTm/TXh4tk=;
        b=CQYkHCvWnzEbHoTgxOLl/aXQuYtFRpD91jePOrVCyxy/Mna7qVK7lihgpJirZNfw7r
         OaaQ9D3L3rciQN/0d7CBXgwyhMuk877mrwtYGb+XuuJck4R5LXNIsXCut2a1FoUmMUiZ
         n/a/GppeXAFBGUXOqNr0v064pGFdiczIvQBAi2EgtCV8Sio/+29eAjX04VvpEwCstvoq
         JQtUCGrX58Ql/8ipo+Z5JCGxXTVJW2FdRUKgLBpTVG7Dq0v3Wb7ek9J//FOn8buDo0oR
         qPr1pz9dAYq0y1TKy8O6xCpwapMk9nARD/9G07uef4r5t05J8vsu26IoqboAbGmoYcUx
         J9Tw==
X-Gm-Message-State: AOAM532kt0j6dwNvPn53dzMBrs9TCwfZd8quQyY10rZaLoD5s2XUudyT
        yCaLBuH2tiT8cC6PM1yyXLsmU5cItkLxi4A2SxjxAeXlij/8BYPL5cu7WBuyrbgHtGDomJHC5ux
        eJvnhRWBJHHNw/Ncg5PSoD9YCYHeo
X-Received: by 2002:aa7:9581:0:b029:2ea:39e:2224 with SMTP id z1-20020aa795810000b02902ea039e2224mr12309945pfj.32.1622716408428;
        Thu, 03 Jun 2021 03:33:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxu902J6s6JMawcPd29T+kGhOuadLLStFy7ExoHrg0jhjp4BjBy86E0mcr8qMOu3nJs5mncxw==
X-Received: by 2002:aa7:9581:0:b029:2ea:39e:2224 with SMTP id z1-20020aa795810000b02902ea039e2224mr12309925pfj.32.1622716408176;
        Thu, 03 Jun 2021 03:33:28 -0700 (PDT)
Received: from localhost.localdomain (111-71-50-125.emome-ip.hinet.net. [111.71.50.125])
        by smtp.gmail.com with ESMTPSA id 195sm1987651pfz.24.2021.06.03.03.33.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jun 2021 03:33:27 -0700 (PDT)
From:   Po-Hsu Lin <po-hsu.lin@canonical.com>
To:     kvm@vger.kernel.org
Cc:     po-hsu.lin@canonical.com, cascardo@canonical.com,
        pbonzini@redhat.com
Subject: [kvm-unit-tests PATCH 1/1] x86/hyperv_clock: use report_summary
Date:   Thu,  3 Jun 2021 18:33:05 +0800
Message-Id: <20210603103305.27967-2-po-hsu.lin@canonical.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210603103305.27967-1-po-hsu.lin@canonical.com>
References: <20210603103305.27967-1-po-hsu.lin@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>

Removed unused nerr variable and use report_summary when exiting.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Po-Hsu Lin <po-hsu.lin@canonical.com>
---
 x86/hyperv_clock.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/x86/hyperv_clock.c b/x86/hyperv_clock.c
index b4cfc9f..1e6f368 100644
--- a/x86/hyperv_clock.c
+++ b/x86/hyperv_clock.c
@@ -144,7 +144,6 @@ static void perf_test(int ncpus)
 
 int main(int ac, char **av)
 {
-	int nerr = 0;
 	int ncpus;
 	struct hv_reference_tsc_page shadow;
 	uint64_t tsc1, t1, tsc2, t2;
@@ -191,5 +190,5 @@ int main(int ac, char **av)
 	report(rdmsr(HV_X64_MSR_REFERENCE_TSC) == 0,
 	       "MSR value after disabling");
 
-	return nerr > 0 ? 1 : 0;
+	return report_summary();
 }
-- 
2.25.1

