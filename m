Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA7A37246C8
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 16:50:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237579AbjFFOux (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 10:50:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238409AbjFFOtn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 10:49:43 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F35E21BEC
        for <kvm@vger.kernel.org>; Tue,  6 Jun 2023 07:48:48 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id 5b1f17b1804b1-3f6d38a140bso45132495e9.1
        for <kvm@vger.kernel.org>; Tue, 06 Jun 2023 07:48:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1686062927; x=1688654927;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=DPx6RoiDg2178/44lvCJMLJejOkunBomhyeXmtgxOuk=;
        b=qR+QAAcTY9gi3HA98YU6dyamAX88ilr4x4rMA69lALtIQwTQJkW67nBTwoKfT8WLAF
         8xbZgRSDfXqpByD/OnKROecvvBLJzI5v4Zty+OE9TWnCKhCNhoPmj6Hsir5QzdcL68/A
         eHTraG0bSE4/u+sAg5OAYaeieBsRXPd7igPE1SdjT+FRGpXpdwEoAJTatSbUavAX7Hl6
         uvYIg0CoYk1ZrEbvpToErz2DltgJlCvH79kCt8FcqeKlL6TrL2yyxGF3H7l/LK9ZX8P4
         lj/ruWDn4S9tTdzW3LPE9fVMOyD8w8nV70YBDnFT8wfo3RyOPB+YA2oIglYwESqmoyum
         MUpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686062927; x=1688654927;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DPx6RoiDg2178/44lvCJMLJejOkunBomhyeXmtgxOuk=;
        b=aKtrlBkj5y5mcQpk8bJyoa3I50dryvtnlm3eVMwgpxTsslEMmu1xlrjjEiPY9otMr5
         QPa16rAZs8/Nhf1S2jE7vBamlsjecLXbmIViGtj8RXa/9BudE0E4Y/xiUMrRIyFdN11S
         b4aXYnWYt28mEnwzffPWqaoUJKzAMoEZv6SEDd5L59RCULr7wEUMFNafyOAxDmRdT2hF
         2a3I8PrxYnWvhDHFFryHkj5N4q2qI2/TxQhDKoUkBnzafIX6M7xO99MPVnavagFrlXdy
         FQGvzqSNmPcH8imd0jrIn5vJfC6Dt+WcNESDsyUpzh2FC9c/ZWuiJcpj4gcqByZIYFkn
         XJ+A==
X-Gm-Message-State: AC+VfDytXLRb519RoX0Syr1mq/EFPYJzyVas86reu4jIqkthwOWXA/+N
        Oqs4p8kxDLPWJH60l7R/1Pab9s1LgS0FFaLbLh2QAQ==
X-Google-Smtp-Source: ACHHUZ6afG1HWPWCD/9PjsHut5NjcmAtPE7mZnpDXc4sVyX9UAnddd5u2iAfUCJpP/eiNDAD4jiBWA==
X-Received: by 2002:a05:600c:3ca6:b0:3f6:b44:3163 with SMTP id bg38-20020a05600c3ca600b003f60b443163mr11017157wmb.12.1686062927385;
        Tue, 06 Jun 2023 07:48:47 -0700 (PDT)
Received: from localhost.localdomain (5750a5b3.skybroadband.com. [87.80.165.179])
        by smtp.gmail.com with ESMTPSA id o9-20020a05600c378900b003f7e4d143cfsm5722692wmr.15.2023.06.06.07.48.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jun 2023 07:48:46 -0700 (PDT)
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     kvm@vger.kernel.org, will@kernel.org
Cc:     Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [PATCH kvmtool 0/3] Build fixes
Date:   Tue,  6 Jun 2023 15:37:33 +0100
Message-Id: <20230606143733.994679-1-jean-philippe@linaro.org>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A few build fixes for kvmtool. They apply independently from the vhost
fixes series I sent today.

Jean-Philippe Brucker (3):
  Makefile: Refine -s handling in the make parameters
  arm/kvm-cpu: Fix new build warning
  virtio/rng: Fix build warning from min()

 Makefile      | 2 +-
 arm/kvm-cpu.c | 3 +--
 virtio/rng.c  | 2 +-
 3 files changed, 3 insertions(+), 4 deletions(-)

-- 
2.40.1

