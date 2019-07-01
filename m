Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 281F243BD3
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2019 17:32:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726884AbfFMPb6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jun 2019 11:31:58 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:40301 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728569AbfFMKzt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jun 2019 06:55:49 -0400
Received: by mail-wr1-f67.google.com with SMTP id p11so20267643wre.7
        for <kvm@vger.kernel.org>; Thu, 13 Jun 2019 03:55:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:subject:date:message-id;
        bh=qTznlx20u/x+YEfpslxzucsylvTn657oG7Lp1E2kiiU=;
        b=UQuWyzSieXPyVGbwmJagwQ2wB4CRC38UTGu3B68ChEks1qG668dy67BOoXs/mejYlh
         M9zoDQD2lqHqQmE04FZQFOcPql9pY2LdVN+XxBx94rneT6rLY2PMPkhzyCfQrukz/3vC
         AVQhgQmMQlZMd/U7hloH5w47YDQlYltoF0Axqc3GfXOWxqArud7Q4QKSnjOdPWbUfB0s
         KWCl+SX7demg7k07Dm/BqGMHf5iCBUHiqYWeWp1rdxMEyimJyR6WqX6g6pQ65YZ609k3
         4Ww43a2ARMEJ4p/gx8I2+yLmCU7hsv8nu6gBNIpfxD6xd+9ZvNDDAKYTzzco2Zm67HNO
         blHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:subject:date:message-id;
        bh=qTznlx20u/x+YEfpslxzucsylvTn657oG7Lp1E2kiiU=;
        b=oH+PUrwTB7b60BL0WmCk14WO62trLvJ+wQy2atd64TDFa2HVBZrhg9mq/3QdMxdFW5
         ZTukg1+hcBo7H2EPDjdsIzkfVLUU89lXwdqCHej3GHS43lgZ7RJw0MCty0rdvIIsYIRe
         h42rATihuMG/roiLOFijbhwE0XwEl0x2CeFH6FfmMICcLCoIrlr/B3tvrO8bsEDeYVg/
         6/RZfb+ffbd39kw+5aWd/+IJzPe2k9z1QTGL5rByPpIu2W9EWkeIORyFjiP/x6YCeu6P
         Vckg8aYmpgZI5JTEBtvVTW7NSZynCzQw+M3aSCjjbgp9N19DBqssfRcRpmjyBFCM+NVD
         qAyw==
X-Gm-Message-State: APjAAAW7fD/2Tps6gMOcfrcoGpbkJ3BtjqcLcq0UcvRWDu/AEqTV+2Ix
        W2VXd8Ts/svgBq/X4hxZYYNSOEA0
X-Google-Smtp-Source: APXvYqyTW9FJSDDPlvmaNL8N6ZQ5z47FCce5VllQ8xC/n79wKL12cuOdYCEcyOFGzmQsVUE+Mz6mrw==
X-Received: by 2002:adf:eb89:: with SMTP id t9mr3102410wrn.120.1560423347133;
        Thu, 13 Jun 2019 03:55:47 -0700 (PDT)
Received: from 640k.localdomain ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id z5sm3032358wrv.60.2019.06.13.03.55.45
        for <kvm@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 03:55:45 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     kvm@vger.kernel.org
Subject: [PATCH kvm-unit-tests] x86: re-enable asyncpf test
Date:   Thu, 13 Jun 2019 12:55:44 +0200
Message-Id: <1560423344-44670-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The asyncpf test failed but that was just because it needs more memory than the
default.  Fix that and enable it.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 x86/unittests.cfg | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index ed47d3f..694ee3d 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -122,8 +122,9 @@ file = pku.flat
 arch = x86_64
 extra_params = -cpu host
 
-#[asyncpf]
-#file = asyncpf.flat
+[asyncpf]
+file = asyncpf.flat
+extra_params = -m 2048
 
 [emulator]
 file = emulator.flat
-- 
1.8.3.1

