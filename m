Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E04E24E8E85
	for <lists+kvm@lfdr.de>; Mon, 28 Mar 2022 08:58:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238640AbiC1HAF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Mar 2022 03:00:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234808AbiC1HAD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Mar 2022 03:00:03 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A164115D;
        Sun, 27 Mar 2022 23:58:23 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id bx24-20020a17090af49800b001c6872a9e4eso14532024pjb.5;
        Sun, 27 Mar 2022 23:58:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Z84sT/Zq3PkHwN8z9QLwYtyn/IyTsWTTqFs/kr4HUcU=;
        b=TGjEEHzziiLQd2h1xv21w53k0zIqBndy47GB6meb5mPLiRRf3hjWWLrxsfmJusHoBv
         hLWanaf2Uy0W3rjd1kQTd+ARRtt4tlsg72YaQCWjtV2/B5gFU1XsLbCkezIWfl1F8Ejw
         lm2P3ER/C5PH+jku0gbn8JYO01aYEm8p5/nBDo25CJb4XWOU1HbGXRBdgOZpNkWs0iu2
         OYJQFfJ2Tv84EEPZ49rK9DNnE1gcugTH2137Nha33dCbAsGVl/oK2Ov3A0Irqilu2FtL
         wvT2czm+GEMTVzEQ/8BsYQ5d1gyK40HuyeSt1dKWAXlh/rMimAl/AlptSBBKus2TO6W1
         UsXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Z84sT/Zq3PkHwN8z9QLwYtyn/IyTsWTTqFs/kr4HUcU=;
        b=bsU/qUuYcHgzC/7d9tgWDHN+m8o57MCZdmpfvl6hGD11Pw7xYLnDohxbPPm4gl7Nbi
         34A9KGZ5K1Tbd+gLcjH/qQN0+dRw4Wuqy1yVvDeASz6KxXBGqyMwI9Oo0IaI126Ih+uU
         IhEVKmcxCrbyvkiO33QjcpmAoWTy/5yJtdueBztgR9XK8v+KncIYg+8fKUyXFRhaKTG+
         16Jmdg0F0TYiagwpIRghCykDAbTqxeoLu1IWPYwECHXf1tO2jY27d5t2Jn3MiPVcDrsm
         zSIDCgcNo8+JiTP/hSLYPVqztGAa5ayBty73dOXznL4g9d9mgogA9klz/vST5rXpQr9f
         Np9w==
X-Gm-Message-State: AOAM531GADpCAjM9WL1lxnKUBCVpBmv1ehPPbwhqI4PJGpVWy3Knm+F/
        Vc5c+Dn2M1BkYu0F2jYGS2iWoo4vcfw9Eg==
X-Google-Smtp-Source: ABdhPJwCp/RwA2s55DDz3nKQ000RIxSAY2PAmr0M/t0xRHr77xHB0qqt0ub03qdNylCL40LqQ2OkOw==
X-Received: by 2002:a17:902:c944:b0:154:38b8:aa46 with SMTP id i4-20020a170902c94400b0015438b8aa46mr24879937pla.144.1648450702537;
        Sun, 27 Mar 2022 23:58:22 -0700 (PDT)
Received: from ubuntu.mate (subs09a-223-255-225-67.three.co.id. [223.255.225.67])
        by smtp.gmail.com with ESMTPSA id s35-20020a056a001c6300b004fb20b5d6c1sm8575149pfw.40.2022.03.27.23.58.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Mar 2022 23:58:21 -0700 (PDT)
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     linux-doc@vger.kernel.org
Cc:     Bagas Sanjaya <bagasdotme@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org
Subject: [PATCH] Documentation: kvm: Add missing line break in api.rst
Date:   Mon, 28 Mar 2022 13:58:09 +0700
Message-Id: <20220328065809.26187-1-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add missing line break separator between literal block and description
of KVM_EXIT_RISCV_SBI.

This fixes:
</path/to/linux>/Documentation/virt/kvm/api.rst:6118: WARNING: Literal block ends without a blank line; unexpected unindent.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-riscv@lists.infradead.org
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 Documentation/virt/kvm/api.rst | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 9f3172376ec3a6..a529f94b61edcd 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6115,6 +6115,7 @@ Valid values for 'type' are:
 			unsigned long args[6];
 			unsigned long ret[2];
 		} riscv_sbi;
+
 If exit reason is KVM_EXIT_RISCV_SBI then it indicates that the VCPU has
 done a SBI call which is not handled by KVM RISC-V kernel module. The details
 of the SBI call are available in 'riscv_sbi' member of kvm_run structure. The

base-commit: f443e374ae131c168a065ea1748feac6b2e76613
-- 
An old man doll... just what I always wanted! - Clara

