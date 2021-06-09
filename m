Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D55203A1CCD
	for <lists+kvm@lfdr.de>; Wed,  9 Jun 2021 20:31:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230080AbhFISdD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 14:33:03 -0400
Received: from mail-pf1-f172.google.com ([209.85.210.172]:37479 "EHLO
        mail-pf1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229993AbhFISdA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Jun 2021 14:33:00 -0400
Received: by mail-pf1-f172.google.com with SMTP id y15so19094152pfl.4
        for <kvm@vger.kernel.org>; Wed, 09 Jun 2021 11:31:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=e605rO9eXbp6+XPpwf5ABUO3O8rlYpURPQTC+TX/w0s=;
        b=IGVixWajBtsbcN/8qB3HlkxHqyBV7pl8aEpuQbUKdjSbp995hsDWp7IMixLdpxGCkN
         zi3iSg8BU19gRArqnsbmRreHJKfw82ek3PSg9jmy0kI40pUfzzhFbnRFngy8ZE/Y5KB8
         0rFRNJKyBDJ9Xt7I2yP8aG+shhCaUrB7rjEOyylDkcX7/RNRK62UCZdAtTclx9FvPwKV
         yh61R6CMJhqIsGHL5D5Vg/HRJe/OENhr1kuziBMlzYJ5raqV3ft3P5fA8n58MxqaXQa6
         xMJmu5BUfOXce2525/+yj/qrafFVf/dwfuhVDUchcnvoo9DEDB1Z1MycvOykPBK9kgC2
         f3EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=e605rO9eXbp6+XPpwf5ABUO3O8rlYpURPQTC+TX/w0s=;
        b=V5vY5OSIXrCmqaAWaADRTdUpWo5Uxt/pgwWMIXeSud81h/2sMdR0KKLKDoxHKgz6hA
         7A2I72DsBj8HBty73sRmti+/PDo8OchxTX/y7Gk8DEG+1wGkp7sFn/f0Vqolbcj15lPH
         /DrcMVW71AQMIYu8j339WXXU2U/lKag8AZNFsImFTBXcSDhqrC3KPSeZ5AO0YPF8cP5P
         Nr3/fLYS/n6AMtgSouglSmifdxE5WYLCB6ccV5QWt38Me5Dta0176vjvWdUDl6USwHyC
         jzbPWdfYePnpS7Uyf34g7LvY4FtgGDA7iDfMTtloNEKP/4Luw6qLYt6cgFsvikLuRQS4
         3Ydw==
X-Gm-Message-State: AOAM5300nW55SLx+RVXyK0DKhk3IhzKRPUzCrsij4o5zpm+HnNV8y21R
        GLzeWCUOeDme0hWpGVePhbc/+86NGDBZeQ==
X-Google-Smtp-Source: ABdhPJypWjYXZG3X3DMZGHgqF2v0RIp8grzR5r9baR7GjIZy1nom3HMJDfqxIVBhttAdbkuw3EL/Eg==
X-Received: by 2002:a05:6a00:18a7:b029:2f2:b099:7b1a with SMTP id x39-20020a056a0018a7b02902f2b0997b1amr1083551pfh.59.1623263405468;
        Wed, 09 Jun 2021 11:30:05 -0700 (PDT)
Received: from ubuntu-server-2004.vmware.com (c-24-6-216-183.hsd1.ca.comcast.net. [24.6.216.183])
        by smtp.gmail.com with ESMTPSA id y34sm249092pfa.181.2021.06.09.11.30.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Jun 2021 11:30:05 -0700 (PDT)
From:   Nadav Amit <nadav.amit@gmail.com>
X-Google-Original-From: Nadav Amit
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Nadav Amit <nadav.amit@gmail.com>
Subject: [kvm-unit-tests PATCH 7/8] x86/pmu: Skip the tests on PMU version 1
Date:   Wed,  9 Jun 2021 18:29:44 +0000
Message-Id: <20210609182945.36849-8-nadav.amit@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210609182945.36849-1-nadav.amit@gmail.com>
References: <20210609182945.36849-1-nadav.amit@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nadav Amit <nadav.amit@gmail.com>

x86's PMU tests are not compatible with version 1. Instead of finding
how to adapt them, just skip them if the PMU version is too old.

Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
---
 x86/pmu.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/x86/pmu.c b/x86/pmu.c
index 5a3d55b..ec61ac9 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -544,6 +544,12 @@ int main(int ac, char **av)
 		printf("No pmu is detected!\n");
 		return report_summary();
 	}
+
+	if (eax.split.version_id == 1) {
+		printf("PMU version 1 is not supported\n");
+		return report_summary();
+	}
+
 	printf("PMU version:         %d\n", eax.split.version_id);
 	printf("GP counters:         %d\n", eax.split.num_counters);
 	printf("GP counter width:    %d\n", eax.split.bit_width);
-- 
2.25.1

