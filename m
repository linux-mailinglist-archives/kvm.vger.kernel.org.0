Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A556B4C618C
	for <lists+kvm@lfdr.de>; Mon, 28 Feb 2022 04:10:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232753AbiB1DLJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 27 Feb 2022 22:11:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230315AbiB1DLI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 27 Feb 2022 22:11:08 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71D523D1EB;
        Sun, 27 Feb 2022 19:10:30 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id z4so10222471pgh.12;
        Sun, 27 Feb 2022 19:10:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sm20oMXRibOS00UOyyNvE7kZppKsqwvAcc4h8hw/Md0=;
        b=Q5Q3ThaWNuW10Cn3Yd0EQi/goM7WRNdhzvLGSCmliG1oU/bNeXVbd31So0em+oag3u
         zprTyxmXaZ3rKqbWf0dTRpTYCdpfSBViYaAlXVX81urV2Jza3q7GeLZOh28VTEgotS2x
         PV3HueiTD1luLPNhazQ3zSaG9W3zQpt2FT8VCRYKgxXSgwrOJtPE80uJoQKNTD3cpJIi
         8EIaC4qmVoW2UVPSs6+1MOrZnIsAupUjbLtPDNHiD/6ERi4byOXqJ8kRe45nc+sJCTUn
         5Yntb57s2chx3htihTdoJDaVmUhBJpy7uEfAq9x53Kl7xB8mygoG9RKx4Kx+BUugmttz
         IuIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sm20oMXRibOS00UOyyNvE7kZppKsqwvAcc4h8hw/Md0=;
        b=18DdNdCVsGRlf+tAsjSCn/cFCldZMYhhYW8n8eDe/z2NVH+IpctwwTU4cyfpqLZBUt
         jGfVXHOuEn8wSpw9JeG06TvvS+UmZHGiO+1UfbIU59t/GtTmxRVE565fIOo6oNfcFZne
         tUGjCGqRj4idJs02ZGE+bB4Zxm03dbZDeZkscQK1RMCtXTFxw5ZLDvE8dltQ9MiEGxjk
         882XAtTdg1Vh5BP4hC+ZMPXZGJFntxRxFYDCuLVIbTc4gwRXbwsnq/sfqfVfaWbuCTVz
         cNKGnusfRRkoUJ5bIRX9Acu4QHzNZKG/z+uOtmXVClhf0s7sSFa21QF4uHlkbzlqwD2q
         6F8g==
X-Gm-Message-State: AOAM533eyjtN94bqVKczkZPw6bOYkr9s9tREBhEvbB2dqKSGgDdKqyIH
        9wDBklM0rIoqa18WNSpcTwvXYZDZqVLWCir9
X-Google-Smtp-Source: ABdhPJyo/umizZTQTXGF4U+xVfOU0FdqwrunL2dXUK4sy5E+AXpGVc08ezm2mr97eLlEBtASbYjZew==
X-Received: by 2002:a05:6a00:2345:b0:4bc:1d4d:dfe with SMTP id j5-20020a056a00234500b004bc1d4d0dfemr19152989pfj.15.1646017829978;
        Sun, 27 Feb 2022 19:10:29 -0800 (PST)
Received: from FLYINGPENG-MB0.tencent.com ([103.7.29.30])
        by smtp.gmail.com with ESMTPSA id k7-20020a6555c7000000b0034e101ca75csm8706764pgs.6.2022.02.27.19.10.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Feb 2022 19:10:29 -0800 (PST)
From:   Peng Hao <flyingpenghao@gmail.com>
X-Google-Original-From: Peng Hao <flyingpeng@tencent.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH]  kvm: vmx: remove redundant parentheses
Date:   Mon, 28 Feb 2022 11:09:02 +0800
Message-Id: <20220228030902.88465-1-flyingpeng@tencent.com>
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

From: Peng Hao <flyingpeng@tencent.com>

Remove redundant parentheses.

Signed-off-by: Peng Hao <flyingpeng@tencent.com>
---
 arch/x86/kvm/vmx/vmx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 6101c2980a9c..7dce746c175f 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2417,7 +2417,7 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 				&_cpu_based_exec_control) < 0)
 		return -EIO;
 #ifdef CONFIG_X86_64
-	if ((_cpu_based_exec_control & CPU_BASED_TPR_SHADOW))
+	if (_cpu_based_exec_control & CPU_BASED_TPR_SHADOW)
 		_cpu_based_exec_control &= ~CPU_BASED_CR8_LOAD_EXITING &
 					   ~CPU_BASED_CR8_STORE_EXITING;
 #endif
-- 
2.27.0

