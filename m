Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 750D34BB7AC
	for <lists+kvm@lfdr.de>; Fri, 18 Feb 2022 12:07:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234305AbiBRLHS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Feb 2022 06:07:18 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231533AbiBRLHS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Feb 2022 06:07:18 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F138829E978;
        Fri, 18 Feb 2022 03:07:01 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id y9so8275277pjf.1;
        Fri, 18 Feb 2022 03:07:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Kk580xNqQGxTpD22MSWsv7W+CGpIrgay4WJjxAu0jaw=;
        b=ItKC/dRUNY28KYQ0/Hq1hnFRx31Xe3t75nNlCjTs2wsgcdTMKJX72rrt+4KbQ0tBvk
         MrXXT1tLNfbyTcEDKi+VkWmt5JKPwjApBkEgEswUAAMejyqF5p3C5wuawexsVZ3glBzU
         AQ4roKvRoWVY6nLD+7lr/BW+qWX6TOAptylk1kBRdtlAQAqsnxmpDaPCefFrx+DDMXl+
         NkF3852s72mMf3CZZjZS5g2nSHI7CSZIXh1r4gSTxB1uLDL03M8ncT82seIP48LZJSav
         G9qHI2EqVWEmYxptWjOGS9yzdnaCtWVnwgQ1IlK1mr7QVqpVzWfJrOAioeJyZlUfD00j
         qPXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Kk580xNqQGxTpD22MSWsv7W+CGpIrgay4WJjxAu0jaw=;
        b=x6hAJ2YGuiSe6uZk+UUl46hxEcWa3X8VDI0K8DsLiUduxICsx1wamY3oxidZ5zT2Pa
         JYYQH6sjONN6XhkrHdGOVYXKWirXiNaYYdC2DkYdB2YyD0NAw5v23dTTsOC5sEL4/nV2
         7wmhhIDzixziQxTb63HjDS1oOBdguc5JSIVKChy0HUhsaAyGWxcxVmBVHqWVn5Wya6mN
         werJVpsIEaxASnYTVI59iwS4qpWFBPqasv6HzbjWuIwCOmzS4E6tnLRTbgtPgxFa2/ov
         HR/jLQVnFnB4l6WlM/kPxHIxmy7ftegMpE+9nyU6edoi467dUtKNj+ZKlafQhAWZ1YLq
         26Yg==
X-Gm-Message-State: AOAM53320Tuw8Qfh56yffL1CVMl9B5LDUFd5ZMuCMco2CNzLCQbMbfXM
        Cpob3bIs2dEvHyoR+gUM6hnFQkTixN1eNoiK
X-Google-Smtp-Source: ABdhPJyrxinJdlL2+whdKDdaHMSbXHCQ0tMVYHHD3/7YlF4AlmCgtOXDwyB1n34b/8Km9n9HvO0FYA==
X-Received: by 2002:a17:90b:4c8e:b0:1b9:f99f:1218 with SMTP id my14-20020a17090b4c8e00b001b9f99f1218mr12210904pjb.75.1645182421398;
        Fri, 18 Feb 2022 03:07:01 -0800 (PST)
Received: from FLYINGPENG-MB0.tencent.com ([103.7.29.30])
        by smtp.gmail.com with ESMTPSA id u4sm2881984pfk.220.2022.02.18.03.07.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 03:07:01 -0800 (PST)
From:   Peng Hao <flyingpenghao@gmail.com>
X-Google-Original-From: Peng Hao <flyingpeng@tencent.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH]  kvm: correct comment description issue
Date:   Fri, 18 Feb 2022 19:05:47 +0800
Message-Id: <20220218110547.11249-1-flyingpeng@tencent.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
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

loaded_vmcs does not have this field 'vcpu', modify this comment.

Signed-off-by: Peng Hao <flyingpeng@tencent.com>
---
 arch/x86/kvm/vmx/vmx.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 7dce746c175f..0ffcfe54eea5 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -644,10 +644,10 @@ static void __loaded_vmcs_clear(void *arg)
 
 	/*
 	 * Ensure all writes to loaded_vmcs, including deleting it from its
-	 * current percpu list, complete before setting loaded_vmcs->vcpu to
-	 * -1, otherwise a different cpu can see vcpu == -1 first and add
-	 * loaded_vmcs to its percpu list before it's deleted from this cpu's
-	 * list. Pairs with the smp_rmb() in vmx_vcpu_load_vmcs().
+	 * current percpu list, complete before setting loaded_vmcs->cpu to
+	 * -1, otherwise a different cpu can see loaded_vmcs->cpu == -1 first
+	 * and add loaded_vmcs to its percpu list before it's deleted from this
+	 * cpu's list. Pairs with the smp_rmb() in vmx_vcpu_load_vmcs().
 	 */
 	smp_wmb();
 
-- 
2.27.0

