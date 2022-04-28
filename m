Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8B86513290
	for <lists+kvm@lfdr.de>; Thu, 28 Apr 2022 13:36:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235213AbiD1Ljn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Apr 2022 07:39:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231983AbiD1Ljl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Apr 2022 07:39:41 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 612522A248
        for <kvm@vger.kernel.org>; Thu, 28 Apr 2022 04:36:27 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id d6so5167942ede.8
        for <kvm@vger.kernel.org>; Thu, 28 Apr 2022 04:36:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2Z2lAV8XUq26RWLstBeOLrZrv/JHK2RrtngbM1gCM3M=;
        b=dYb4pEuZrRC/Ed1L39Hvsw1iftYwPnw5l+O7zJ4/iRwh+BTb6/i2sI/w9relh2iMB3
         urMdIBOJHZBqs5PAjP/U6iqKAcQvbupE724E+IkuzInazpf1KWB3W5c95RNX9YeZUzr6
         CRaewG0G8ZrpKf04NOLRir5NzleTKJN5fbiyA2SUlWNHQ6MYH9jznaE9/8lKCIywudNB
         +lLcrdwQqb9sf/rhQvzzdzDQcXsE2MwsUEktqOVTDIULnLPwlRNG9lu2NT6GTZF8W73U
         x/2CmtonO1KF4exW0/CK9xGGf5v274lbkF2bu68vWVQ6KuKWvbXPgNfWGqITOUDOVVr8
         Y9Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2Z2lAV8XUq26RWLstBeOLrZrv/JHK2RrtngbM1gCM3M=;
        b=43VVv27MtsTdiZBBvk9YXsrU+h/IxHhj0CFSqtszxH2QhD9YiCCby3LtBbyyZjhK5p
         A9605J99oJvDJCQQef5C43cedOr8DgSQv9bMFoxbv8bQzEwET2cc5GI5GZmf1ib5tzTn
         4Kp+SsQ4RiPsXRthzd3KGOfHs+FTD3FavAEykIMoQCUqEZ+4okBYmAg93xZPcSzBoJCb
         6pf59bwbFaCNEDua5S3GQQoc5ft9XcIbtNtTU1ItrqCMxRg30tcYANh9nFX/Y+oVy2Yd
         IENHZm2i+iNBDot2xDscovnRLZt4jNIu7CMy3P8v3hOl1leNF7ZsmkOtLoVZgxMqKhXN
         9lQA==
X-Gm-Message-State: AOAM530M00wSlyX3rUxKumEtJu/ddv41+/hWK9Ek8iCU4+lrcxMTJNCO
        pzg6PZ1vgk8MdvAO5LvAR/lWiw==
X-Google-Smtp-Source: ABdhPJxls/WINbPM3kXOI7DMfgIIW/mi4kSmtLJfE5y0ObxWASchSGE9VresL/q0MbCln42Hqg0+rw==
X-Received: by 2002:a05:6402:26c6:b0:425:f86e:77e1 with SMTP id x6-20020a05640226c600b00425f86e77e1mr15419225edd.400.1651145785980;
        Thu, 28 Apr 2022 04:36:25 -0700 (PDT)
Received: from jwang-Latitude-5491.fritz.box (200116b8450f1a00a07040ca0a463b97.dip.versatel-1u1.de. [2001:16b8:450f:1a00:a070:40ca:a46:3b97])
        by smtp.gmail.com with ESMTPSA id j37-20020a05640223a500b0042617ba637asm1445036eda.4.2022.04.28.04.36.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Apr 2022 04:36:25 -0700 (PDT)
From:   Jack Wang <jinpu.wang@ionos.com>
To:     pbonzini@redhat.com, mtosatti@redhat.com, kvm@vger.kernel.org,
        qemu-devel@nongnu.org
Cc:     Yu Zhang <yu.zhang@ionos.com>
Subject: [PATCH] doc: Adapt example to for numa setting.
Date:   Thu, 28 Apr 2022 13:36:24 +0200
Message-Id: <20220428113624.68414-1-jinpu.wang@ionos.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add numa sgx setting in one leftover example, without
numa setting qemu will error out with message below:
qemu-7.0: Parameter 'sgx-epc.0.node' is missing

Fixes: d1889b36098c ("doc: Add the SGX numa description")
Cc: Yu Zhang <yu.zhang@ionos.com>
Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
---
 docs/system/i386/sgx.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/docs/system/i386/sgx.rst b/docs/system/i386/sgx.rst
index 0f0a73f7587c..86fa70ec2a30 100644
--- a/docs/system/i386/sgx.rst
+++ b/docs/system/i386/sgx.rst
@@ -45,7 +45,7 @@ to the VM and an additional 28M mapped but not allocated::
 
  -object memory-backend-epc,id=mem1,size=64M,prealloc=on \
  -object memory-backend-epc,id=mem2,size=28M \
- -M sgx-epc.0.memdev=mem1,sgx-epc.1.memdev=mem2
+ -M sgx-epc.0.memdev=mem1,sgx-epc.0.node=0,sgx-epc.1.memdev=mem2,sgx-epc.1.node=0
 
 Note:
 
-- 
2.25.1

