Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37B5A687714
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 09:16:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231688AbjBBIQR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 03:16:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbjBBIQQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 03:16:16 -0500
Received: from mail-vs1-xe2b.google.com (mail-vs1-xe2b.google.com [IPv6:2607:f8b0:4864:20::e2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61C0582415;
        Thu,  2 Feb 2023 00:16:15 -0800 (PST)
Received: by mail-vs1-xe2b.google.com with SMTP id p10so1016184vsu.5;
        Thu, 02 Feb 2023 00:16:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=hoJKPix4BsanZ3tGIxtMwC5dH3CyBNlIZHiiLZJLivc=;
        b=q0Kqo2a2ud8QRypdClU9S0PcdpO8pTxToXhZqUfUy2UYdJ845ZUV312YyHc+6FIR7v
         Kzg+hSQBCYLiGE1Y+dfpLxmA7VvpEIktbrUhOPRfbOQr9Lp1icxIE4fIk5N4E8hu/ayh
         PBJrMOHUE/jr5fOMOHVquZq6NKr530ie+XBRvnVdjsXpFobxy2aZtLobg3NfDdDmFEn1
         B8pjdSw/sVRX+1YbDAGRSi0JuB3XH54Ficq02qJySivgHdFhiqCv2j4c+bLLn5jMTFyk
         4af54MuiTvRo7bol4ZyN1+B8GwvlhsU7qh6wWoNGamO8XGX7FbLlrE0x2Xzo3ONP4GHs
         xI+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hoJKPix4BsanZ3tGIxtMwC5dH3CyBNlIZHiiLZJLivc=;
        b=ciTKJFQyrxUf/FJJCodvfp8y+AFc2x2it1jdA7dTJ/a6JLScz1OxARsoG4hTauWjFJ
         PbAOWKrj1DCArbj6zcSIFwjtY1JoCiJbRl6/H12SoO7v+EqnTQtFKombczrmj9XlYS98
         HA73H/I7RZgjp3F+Oz1TjSnI1idUmb2iAQerHdyQQGB1wjyR19PET2+MygKt3F9R+4lt
         n6rz0aGkQZB4bKrcsgghXvaTMEgPW0m0ok58Y5jRIfFUz10jwVOCFW386ljktml4kDDa
         wP2FQ8NjH0NvYuz8Zg+6BQf8GtbAGC2ZhqBXzIZ5r6+64fJnLAOFY6yg7RRca9b/AeB6
         +j7A==
X-Gm-Message-State: AO0yUKXl1vGSXJJ6b7esdEh8cokzkSZbjVpUHsJbMuNx9ic03gyiLwX2
        kgRYxb2afi74XZuqIVK2pNw=
X-Google-Smtp-Source: AK7set85pVGGprzcAsxPK6eleoJUPWXt/0YTlFHHt64RfjpEqt5qIKyswdB4nvXXXHaHujry/ExBdA==
X-Received: by 2002:a67:ef0e:0:b0:3f1:f969:8aef with SMTP id j14-20020a67ef0e000000b003f1f9698aefmr3453401vsr.5.1675325774426;
        Thu, 02 Feb 2023 00:16:14 -0800 (PST)
Received: from localhost.localdomain ([185.216.119.110])
        by smtp.googlemail.com with ESMTPSA id r14-20020a056102018e00b003d3e7ac6f13sm1389712vsq.2.2023.02.02.00.16.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Feb 2023 00:16:13 -0800 (PST)
From:   Wang Yong <yongw.kernel@gmail.com>
To:     pbonzini@redhat.com, maz@kernel.org
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wang Yong <yongw.kernel@gmail.com>
Subject: [PATCH] KVM: update code comment in struct kvm_vcpu
Date:   Thu,  2 Feb 2023 08:13:42 +0000
Message-Id: <20230202081342.856687-1-yongw.kernel@gmail.com>
X-Mailer: git-send-email 2.25.1
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

Commit c5b077549136 ("KVM: Convert the kvm->vcpus array to a xarray")
changed kvm->vcpus array to a xarray, so update the code comment of
kvm_vcpu->vcpu_idx accordingly.

Signed-off-by: Wang Yong <yongw.kernel@gmail.com>
---
 include/linux/kvm_host.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 4f26b244f6d0..67edeb4e18f5 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -324,7 +324,7 @@ struct kvm_vcpu {
 #endif
 	int cpu;
 	int vcpu_id; /* id given by userspace at creation */
-	int vcpu_idx; /* index in kvm->vcpus array */
+	int vcpu_idx; /* index in kvm->vcpu_array */
 	int ____srcu_idx; /* Don't use this directly.  You've been warned. */
 #ifdef CONFIG_PROVE_RCU
 	int srcu_depth;
-- 
2.25.1

