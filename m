Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E87576E4FAC
	for <lists+kvm@lfdr.de>; Mon, 17 Apr 2023 19:53:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231163AbjDQRxa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Apr 2023 13:53:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbjDQRx0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Apr 2023 13:53:26 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3C5E40FC;
        Mon, 17 Apr 2023 10:53:25 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id ffacd0b85a97d-2f86ee42669so1678053f8f.2;
        Mon, 17 Apr 2023 10:53:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681754004; x=1684346004;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Nq+GSUtY07nXKsb+LMvbAc04Nto3jy5+/BqE9bmMBQw=;
        b=mLyDT106lgI3JkUxXqjXu/14cLoANqEm7VF6qqd1J4CAX0FwyL5K1AKUKNcU81exNt
         By7q8Rly/BNhyhoIsCH2Wv1g5BfttWZ96eudEoefNGpjtsqFbJH8qj0SFzTc+lxlzncS
         PSVMG9Puqz/9m+ztFyX6E9N95rpfZ3KMMlpDEV6uDt/aReVscBXL8NaX0GnTeL3BVzzy
         xDnm68Zguj6VuDIN/UJndbgzxQ+W2y0qf0NU3N2KfYksX47NqDPiDncGF+ercpFPlfpg
         aofEHe/10YhE8PV4s1P7+LFguVg9m/KbljMveSkV7knjYQE9qtDpNb1e0eASnWUNqDuf
         iIjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681754004; x=1684346004;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Nq+GSUtY07nXKsb+LMvbAc04Nto3jy5+/BqE9bmMBQw=;
        b=lwUEmse2ykj7n+HEexfeeNCQcbdd8+9MnOxk3FJ2fzyJhw4Kz5G8DjNNLUL/qut1cR
         /ZhDsa+QbG38z8bDNZoplXUrzbFkeqlysFmwROMpJkHPsjc8I4IjIJpygpDD3KvS4gK9
         VetxyDLGs5TaOUCPPSPSeIr8Hwa87vIUG0miJWPz8ozF2UTdVGccYg1rD3vCSyWZHUy9
         cqDUxTqT2Mr/JQYAvFTDYDCVSXOn1H2xFnu75b/v0kyGqtjLvtBELoG7zhIxCxbweAwI
         XF6n7L+TaN5JZ5uERvQcJ56g8Bp+acsW3+5EV6FqMLKF2sPzJ0VmBoU1N7rWDC6ODDgv
         rZsA==
X-Gm-Message-State: AAQBX9d2BhvNf6JhohpJ1qVVyxw6VuCgra00I09Mgrallm8WrzgE9xga
        YXo0SrANMAOr6ETLBShFzZg=
X-Google-Smtp-Source: AKy350aXL5MEyc8XH2SRgcbhu00laZ9yC3vGnqTeUfzCrN0M+96kfkxOMmGkTnf64AeqE1qVhFrcfw==
X-Received: by 2002:a05:6000:1049:b0:2f5:ae53:f558 with SMTP id c9-20020a056000104900b002f5ae53f558mr6896797wrx.31.1681754003931;
        Mon, 17 Apr 2023 10:53:23 -0700 (PDT)
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.gmail.com with ESMTPSA id v11-20020a5d678b000000b002fa834e1c69sm3011658wru.52.2023.04.17.10.53.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Apr 2023 10:53:23 -0700 (PDT)
From:   Colin Ian King <colin.i.king@gmail.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] KVM: selftests: Fix spelling mistake "miliseconds" -> "milliseconds"
Date:   Mon, 17 Apr 2023 18:53:22 +0100
Message-Id: <20230417175322.53249-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
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

There is a spelling mistake in the help for the -p option. Fix it.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
index 251794f83719..7f36c32fa760 100644
--- a/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
+++ b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
@@ -226,7 +226,7 @@ static void help(char *name)
 	puts("");
 	printf("usage: %s [-h] [-p period_ms] [-t token]\n", name);
 	puts("");
-	printf(" -p: The NX reclaim period in miliseconds.\n");
+	printf(" -p: The NX reclaim period in milliseconds.\n");
 	printf(" -t: The magic token to indicate environment setup is done.\n");
 	printf(" -r: The test has reboot permissions and can disable NX huge pages.\n");
 	puts("");
-- 
2.30.2

