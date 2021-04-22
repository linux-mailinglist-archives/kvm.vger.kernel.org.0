Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20B763677B3
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 05:05:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234698AbhDVDGF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Apr 2021 23:06:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234556AbhDVDGA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Apr 2021 23:06:00 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EC61C06174A
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 20:05:25 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id z8-20020a2566480000b02904e0f6f67f42so18554642ybm.15
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 20:05:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=/M6FFjjhuZ3llkTqz2UHvAWLQR24B3cMlmmbS3VEa/4=;
        b=rkkVZCQY4QYTt1e1rnoJEff7LS5fbdq4IgiUpj1EjunbdoD8q8Iv3UFKxPYKPDYdWX
         SWbknIBDjaeoA99xNtkvjdWNw+ULQPOUnGDcuTEH3q0YvW+jc2bZZ4MzkZ4ZuWPsw9bm
         gzYhlXMAZSKcobIp7jdSi1AYZVgftBAaekEdgVTDYaML1QR+slAbMouJQpj2Zs568TD4
         VRKYTJGNDcALPQCtxOosB341PSkMFmZvUm8Cbh/lkFXl+WH4Z8yKdRk/jEA8fhT7vvuW
         7l2LvhwL5PP3Ve2dVOBXkfye78AZjFCa1GPfnFDS78bSldD+y5fxZBC4P91CTl/IOKMZ
         bbXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=/M6FFjjhuZ3llkTqz2UHvAWLQR24B3cMlmmbS3VEa/4=;
        b=SRdcqDWskvClaM0UayT0nlqG0V/2K84EpF1FcQLZvvpSLXvaCO3+u3JTSppDY/Zpvu
         KuaSFNAuwEiPcCL/sP+gSr4kqKGOapNpwNJJTHO5GrVgW+uwEsnByUkrOz/ZtVOZ9SaF
         vKTENepH2QEmPQQMr5PjsxPo1VekbhZ1641tvB+gBxJCyqW3fMcYUI1qCJ4PEVo1JBXp
         Bw9yAPM9Fcww3pIpupvvQQ4jjEtL89+3HSGPIuR/fQCkFy+kWGjEb3drE2/G0lePNPQI
         mvkCrRCbP+0L7mt6T7aec+cATm8c3ZpnQ9CjP7Xp5ALvx8EsROWBR1Ocyk+0pGUri562
         +8bg==
X-Gm-Message-State: AOAM533z8mqYwsAaJZaOMxKopjbiFQrukgnog2WhxB1d3U0Nkh7593bD
        g7qRjJQs2iRiWy/IZ6qmHUryzVEgF9o=
X-Google-Smtp-Source: ABdhPJw+bzFZcRxs0kvuDOqu/JMzzR55mayKR2rHvW/K2WK8aMXDvrnqhB6UDQUiDhN7SYRpnGtUPf/gbvc=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:e012:374c:592:6194])
 (user=seanjc job=sendgmr) by 2002:a25:71c3:: with SMTP id m186mr1573331ybc.325.1619060724495;
 Wed, 21 Apr 2021 20:05:24 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 21 Apr 2021 20:04:57 -0700
In-Reply-To: <20210422030504.3488253-1-seanjc@google.com>
Message-Id: <20210422030504.3488253-8-seanjc@google.com>
Mime-Version: 1.0
References: <20210422030504.3488253-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
Subject: [kvm-unit-tests PATCH 07/14] x86: msr: Use ARRAY_SIZE() instead of
 open coded equivalent
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use ARRAY_SIZE() to iterate over the MSR values to read/write.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/msr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/x86/msr.c b/x86/msr.c
index 1589b3b..b60ca94 100644
--- a/x86/msr.c
+++ b/x86/msr.c
@@ -102,8 +102,8 @@ static void test_msr_rw(int msr_index, unsigned long long input, unsigned long l
 int main(int ac, char **av)
 {
 	int i, j;
-	for (i = 0 ; i < sizeof(msr_info) / sizeof(msr_info[0]); i++) {
-		for (j = 0; j < sizeof(msr_info[i].val_pairs) / sizeof(msr_info[i].val_pairs[0]); j++) {
+	for (i = 0 ; i < ARRAY_SIZE(msr_info); i++) {
+		for (j = 0; j < ARRAY_SIZE(msr_info[i].val_pairs); j++) {
 			if (msr_info[i].val_pairs[j].valid) {
 				test_msr_rw(msr_info[i].index, msr_info[i].val_pairs[j].value, msr_info[i].val_pairs[j].expected);
 			} else {
-- 
2.31.1.498.g6c1eba8ee3d-goog

