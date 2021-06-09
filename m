Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F5583A1CC3
	for <lists+kvm@lfdr.de>; Wed,  9 Jun 2021 20:30:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230000AbhFIScF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 14:32:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229989AbhFIScC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Jun 2021 14:32:02 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 470E1C061574
        for <kvm@vger.kernel.org>; Wed,  9 Jun 2021 11:30:07 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id k7so1929773pjf.5
        for <kvm@vger.kernel.org>; Wed, 09 Jun 2021 11:30:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FW0T0ND5ZzgzZJ+335NwDRgPl16vtHkayOF5PS62cMM=;
        b=gJ4hLWnIy9FVJ5FqNIYoVVqxRUOpjTKtSB71S/da2wKcACCWx0YlU2J4JRHkfDzbjj
         f6aoMVcr4Bh/eh7PebCje5MajUMQXlHyTNoFFw3RM5jA7l508HmvhdCEaubCLG0nhum0
         m+rAMVdjr1C3r4lQ2SjParTM5g7w8ndAkbD4JeCyBJXKDUXO9JsYZJ5CkWCGj7XKNssg
         a0PaWfXTlXIXT5aGujxjx7BT/1n221u6s+LVwWBFU7uC+ukj59g5aPb96BY9bXDL0Ze/
         olX9vzGyvMOkIiitK45dU3HCvE8dkQNqBzVYvDIxlsODmExypvuP9c2es112lKhR2nxo
         pg1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FW0T0ND5ZzgzZJ+335NwDRgPl16vtHkayOF5PS62cMM=;
        b=BdPcoJ5ScMz1o2MCXMevjNJ8Uoq8phZCTpwC27348SzxrVmN8J3l70X4WjMQigbF1C
         ESQUHDzDTMOa17HpRhsAouMPtQUd1lYyUkIFdmtbgiFNhjF5EbiYke2RBTjx8WfldKSP
         MptzO/56SxxSybKahjuVVwTY0Ro0jD2GwGdQWiqVFFCb49pvdybxrLj5xGSBlgaNm4Qq
         zjQfDRqex1K14A/j+1itzRcJ88lahfN9TRRZdAN6NHpRKRaaKtXDlDhiAhgohTrCAmc1
         qMPN2Fh9dhzuaGCkzF7Ct0sL/xuWDdNr/+SiQ9rzOG/JbeEwwtltkZn+WscqN7td5r2A
         5Qzw==
X-Gm-Message-State: AOAM532tWpfHpeuO1lwxoz50fTnUuhauAxdq0dA+/2qRaPrWRxTQajpC
        dghsEPupcWh09Zz/mIFyiAM=
X-Google-Smtp-Source: ABdhPJxlvYu1zgPo3DjwSzBDk66UxwwBW/ASW170aSKSCt6Obv+phiSCxPoLh1l7aDv83Y5OhYHEsg==
X-Received: by 2002:a17:902:c613:b029:107:ce4:f7b9 with SMTP id r19-20020a170902c613b02901070ce4f7b9mr893132plr.11.1623263406649;
        Wed, 09 Jun 2021 11:30:06 -0700 (PDT)
Received: from ubuntu-server-2004.vmware.com (c-24-6-216-183.hsd1.ca.comcast.net. [24.6.216.183])
        by smtp.gmail.com with ESMTPSA id y34sm249092pfa.181.2021.06.09.11.30.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Jun 2021 11:30:06 -0700 (PDT)
From:   Nadav Amit <nadav.amit@gmail.com>
X-Google-Original-From: Nadav Amit
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Nadav Amit <nadav.amit@gmail.com>
Subject: [kvm-unit-tests PATCH 8/8] x86/vmx: skip error-code delivery tests for #CP
Date:   Wed,  9 Jun 2021 18:29:45 +0000
Message-Id: <20210609182945.36849-9-nadav.amit@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210609182945.36849-1-nadav.amit@gmail.com>
References: <20210609182945.36849-1-nadav.amit@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nadav Amit <nadav.amit@gmail.com>

Old Intel CPUs, which do not support control protection exception, do
not expect an error code for #CP, while new ones expect an error-code.

Intel SDM does not say that the delivery of an error-code for #CP is
conditional on anything, not even CPU support of CET. So it appears that
the correct testing is just to skip the error-code delivery test for
the #CP exception.

Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
---
 lib/x86/processor.h | 1 +
 x86/vmx_tests.c     | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index 517ee70..53e71fc 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -28,6 +28,7 @@
 #define GP_VECTOR 13
 #define PF_VECTOR 14
 #define AC_VECTOR 17
+#define CP_VECTOR 21
 
 #define X86_CR0_PE	0x00000001
 #define X86_CR0_MP	0x00000002
diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 179a55b..5b9faa2 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -4413,6 +4413,9 @@ skip_unrestricted_guest:
 		case PF_VECTOR:
 		case AC_VECTOR:
 			has_error_code = true;
+		case CP_VECTOR:
+			/* Some CPUs have error code and some do not, skip */
+			continue;
 		}
 
 		/* Negative case */
-- 
2.25.1

