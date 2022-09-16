Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E68AF5BA6F4
	for <lists+kvm@lfdr.de>; Fri, 16 Sep 2022 08:43:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbiIPGnl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Sep 2022 02:43:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbiIPGnk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Sep 2022 02:43:40 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D54B32C672
        for <kvm@vger.kernel.org>; Thu, 15 Sep 2022 23:43:38 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id a5-20020a17090aa50500b002008eeb040eso799679pjq.1
        for <kvm@vger.kernel.org>; Thu, 15 Sep 2022 23:43:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=hlyWBbK6F2SJsCbIKw+/UUXPgi7jOuXo2SIcLIfjASU=;
        b=Hy2rgyMIKTyLsV5F3vZte+9nPYNsiejjI5yZ0rDvbQv5GTzcvVZ6AfTX8Guni3zfYi
         2ZmVYC+P3kY7T+ANFKLTyUeRnjPHa9R3ZUyGl8Qwp29m9HosO1DgBry2tdqZWP9Z8X00
         Cq0yxZScJh1/DvYQFzW6US2oa3HTRaQnyMmaQMOWzeONS7q5SnRHf1cPBYfRGm+f4rcR
         V4c5mxaHuLKTFvv0XGiI7RxdKiglmWSlm1yqwzqWLL0XfJQWxik0KbM1bPBOykl1505c
         7NGVUMubiE/OKWd2wSNiQQMlIIxRvBGA0eV1EccQ2Gvz6OsMYV1DdCJ1Bvl1WZB8CvSO
         1UTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=hlyWBbK6F2SJsCbIKw+/UUXPgi7jOuXo2SIcLIfjASU=;
        b=Oe48Syo7d5fZhTWtfcAevcx4rUnpPgZ+laduha1EGFGynAAykVO04G3eFu+RbjeKUZ
         R0G1/gyq//AEVrrYm/Cr6Bw7mYg3rCYc27CQKvprFodiC8jtnrOCXCb57yU65CaHNBy+
         6S1wZShdOwJFRPyW2RhrfWrfxQqLNXywj37iM6+xy+z3kxyXf4ILeYJpO47GY6OpCmY0
         nqTTS+p6K0GRc28jh+da+OhlT3wR1FHiepPWJwFt7BBfQSCNduSM13Gfu1ThkzqmiTec
         mm20/RucjzgCduvxshMAtggEBo99lKDKYWI7iJHgMayRCbWlnnVTSrwAAJl5aa2VrUX9
         MJrA==
X-Gm-Message-State: ACrzQf24Trh2udpVvAJNqMUIz4mO3oPj3yaj0K5nF2CrH20lRf6xcwWe
        bqHyYFsq8x8zyp+RuNbXnuRSBF/BGDrCDA==
X-Google-Smtp-Source: AMsMyM5BPwsyEvBFyszq9CCntsCSR2ZOzsnqVV6WJSf3yCLdRsjLNQA9BRojYWzb1QePw7yw9C0xOA==
X-Received: by 2002:a17:90b:1d08:b0:200:823f:9745 with SMTP id on8-20020a17090b1d0800b00200823f9745mr3866806pjb.84.1663310618301;
        Thu, 15 Sep 2022 23:43:38 -0700 (PDT)
Received: from ThinkPad-T490.dc1.ventanamicro.com ([182.70.62.242])
        by smtp.googlemail.com with ESMTPSA id p4-20020aa79e84000000b0053ea0e55574sm13501724pfq.187.2022.09.15.23.43.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Sep 2022 23:43:37 -0700 (PDT)
From:   Mayuresh Chitale <mchitale@ventanamicro.com>
To:     Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>
Cc:     Mayuresh Chitale <mchitale@ventanamicro.com>, kvm@vger.kernel.org,
        Anup Patel <anup@brainfault.org>
Subject: [PATCH kvmtool 0/1] riscv: Add zihintpause extension support
Date:   Fri, 16 Sep 2022 12:13:23 +0530
Message-Id: <20220916064324.28229-1-mchitale@ventanamicro.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch exports the zihintpause extension to the guest if it is
available on the host. It depends on the following tree from Anup:

https://github.com/avpatel/kvmtool/tree/riscv_svpbmt_sstc_v1

Mayuresh Chitale (1):
  riscv: Add zihintpause extension support

 riscv/fdt.c             | 2 ++
 riscv/include/asm/kvm.h | 1 +
 2 files changed, 3 insertions(+)

-- 
2.34.1

