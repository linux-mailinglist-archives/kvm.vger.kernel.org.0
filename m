Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07C454BB7B9
	for <lists+kvm@lfdr.de>; Fri, 18 Feb 2022 12:09:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234382AbiBRLJU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Feb 2022 06:09:20 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234375AbiBRLJU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Feb 2022 06:09:20 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7E9B2AED99;
        Fri, 18 Feb 2022 03:09:03 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id 132so7537612pga.5;
        Fri, 18 Feb 2022 03:09:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5cUpkgeIWgMyX7lEdZ9ov9qEZKu5b0q2iwn1hoBnkYk=;
        b=ZjLbVUWFDp3v7jFG9r9UcvAAcfQMq48ePsd8aM1URnwFTA7TS9VwGo1h8OsLYsJ4k6
         tcBbe8UC62MegNlmQaoI1IMpC9gaIzd6Wm3TuJ9vAIinzGZGInLuqAGNqrwK12ny4DzQ
         LgEBmmfE9hKFgBnXMJwmyegye8YXC06OcyS7dcwPrwrgwVpHU4RWGRrdTxA8iIBXhccU
         i/OwNNRc8r3e+t5NGJVVKPEtSYvjsx5SlFaBl3+nQG8rR+pOwXKDiURzNpBqrK7kd6Pi
         pDwD4N+cZCMDNACgQ4lcYIv4I8SdPq/wZBzZwsf6qB6PUbdbD75JtczCYzEfh9zYPaB5
         L5zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5cUpkgeIWgMyX7lEdZ9ov9qEZKu5b0q2iwn1hoBnkYk=;
        b=k7qUKptpfC23vLOgqaD3ydxKYYhMpU63WnBmZ/r5V2xNe2GN/ZjHjknbHns4GrkROW
         SPTFfZmGcL5zMLQCJA5os4NfOdY0qzn6J2yrrBK5F6Qzpa3oN7A+Y15uP+LNmBCS+7rG
         eEaNRtHc2pSgW9tWq7ZcEHykhly0eVGFnMgIjn9rtGBsU9tSUP4BvSu3VUfqIxvX7kv/
         sKHOOFSovTlz2luaAqcE/9TJYD9rhX351rKjA5NBSq4Esiz7Q+XKg5u+xORuo98hFIr0
         MUdXytYPUj+EYgYyhsL5P9BtNVxqGPqJtO/z7nF3uqrnDU4oJeZFs627/CnodbCNRj8B
         3BXw==
X-Gm-Message-State: AOAM532oKE9i9KWFzurcgnbMCm+ZiaCVwtOnMrVL2sn/b/MWWmVguEnr
        Vr0u4RABw5pvAi/xn0w5NSfqNBml0kI99EJZ
X-Google-Smtp-Source: ABdhPJw3BXjbBb7Jw7rt53Undq2ruRqiNCrSMluhqFPxwyy7dOLHtMEKktHsZMXTgO9Wm838OoV7lQ==
X-Received: by 2002:a63:ec13:0:b0:373:aa37:193b with SMTP id j19-20020a63ec13000000b00373aa37193bmr5335167pgh.535.1645182543268;
        Fri, 18 Feb 2022 03:09:03 -0800 (PST)
Received: from FLYINGPENG-MB0.tencent.com ([103.7.29.30])
        by smtp.gmail.com with ESMTPSA id w198sm2846959pff.96.2022.02.18.03.09.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 03:09:02 -0800 (PST)
From:   Peng Hao <flyingpenghao@gmail.com>
X-Google-Original-From: Peng Hao <flyingpeng@tencent.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4]  x86/kvm: remove a redundant variable
Date:   Fri, 18 Feb 2022 19:07:47 +0800
Message-Id: <20220218110747.11455-1-flyingpeng@tencent.com>
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

variable 'cpu' is defined repeatedly.

Signed-off-by: Peng Hao <flyingpeng@tencent.com>
---
 arch/x86/kvm/vmx/vmx.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index ba66c171d951..6101c2980a9c 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7931,7 +7931,6 @@ static int __init vmx_init(void)
 	    ms_hyperv.hints & HV_X64_ENLIGHTENED_VMCS_RECOMMENDED &&
 	    (ms_hyperv.nested_features & HV_X64_ENLIGHTENED_VMCS_VERSION) >=
 	    KVM_EVMCS_VERSION) {
-		int cpu;
 
 		/* Check that we have assist pages on all online CPUs */
 		for_each_online_cpu(cpu) {
-- 
2.27.0

