Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C66D64F0836
	for <lists+kvm@lfdr.de>; Sun,  3 Apr 2022 08:58:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354904AbiDCG7w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 3 Apr 2022 02:59:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229899AbiDCG7v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 3 Apr 2022 02:59:51 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1FA8381B4;
        Sat,  2 Apr 2022 23:57:58 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id x31so6165989pfh.9;
        Sat, 02 Apr 2022 23:57:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VB4BowOKcVjDMzaFI2q1TdcawJXQCYjd9zAqRkqdqfo=;
        b=G0niXPXzEWlRviSWcbVBuBoDbthSi30PCxNELYi6MmbdCJy43ME8ZsxfPVG2hP3NYN
         aoi4ZZvpx57Na3PaFPWmyfDIpqaaIMwGEb/NhYXKoUPvpFkWEvhsPnVhK4uaWKtSKBXJ
         jJ4K0TwkIO316hnyPjn5rbahKj5aIiGedBynlkaCRvXDNjLorKirU9tK0C5cXGUrAzn+
         kDVW4O2SQyCtTxBhXnX2m2zCrwCtZvJgvScXEEguAMNcG9zwE2MOCVxQqv4po5TGonXU
         JGqPLmN+r4DgjDvaIc/O5DetEwtFR03lu1nP7NAEksDa0T5OEpekcqB4yyJTBjo2WU6p
         L63Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VB4BowOKcVjDMzaFI2q1TdcawJXQCYjd9zAqRkqdqfo=;
        b=0MtHaIFGP8XM5oeCuhUhq8qXvPzWYZvFYwgG6rJQs60cEcEm7aRmORVEs5JhpHzFtX
         8wrP95tEu0FSI6f4Rl7xqI2ObmyOA5lQik/YBXtRR6GIfrO17NFei2SSKezmkqSAsCTJ
         dLNUXWvM8QroAFkYwd622kzrk+CRMbM5lSTtqAY06UzpQwJuXtpfE5kUtTGtfLVTVBM/
         wicHc37ubDzd79st3Uqo68SHUBFOIvKGGVKtsG9E62rcIhYvXyWxnkDL+xKxb/TtlFhQ
         uG5TB2dU0QOtkqYsSVXmXplsN9Xcml+70mB94rBYXSDwf9483ZWhdatwKI0QtRIpN5+5
         9EcQ==
X-Gm-Message-State: AOAM530UkX52IgwZmZQDgeCLUaOx/VffjRDB30QgIPV5XiKUz7eq192K
        rwwtHijuUHJXPQ7wdCemHXpU/QMZFz8jpg==
X-Google-Smtp-Source: ABdhPJwSBLxoxI5PkLY2KMc/MKylwInJtYBAp6BxcAs6CfGnjoINlGlRb4+5gL8MvusBS6kHu3iSaQ==
X-Received: by 2002:a65:694c:0:b0:398:fd64:7422 with SMTP id w12-20020a65694c000000b00398fd647422mr4191685pgq.503.1648969077955;
        Sat, 02 Apr 2022 23:57:57 -0700 (PDT)
Received: from ubuntu.mate (subs02-180-214-232-68.three.co.id. [180.214.232.68])
        by smtp.gmail.com with ESMTPSA id ds15-20020a17090b08cf00b001c6a4974b45sm17077143pjb.40.2022.04.02.23.57.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Apr 2022 23:57:57 -0700 (PDT)
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     linux-doc@vger.kernel.org
Cc:     Bagas Sanjaya <bagasdotme@gmail.com>,
        Anup Patel <anup.patel@wdc.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org
Subject: [PATCH RESEND] Documentation: kvm: Add missing line break in api.rst
Date:   Sun,  3 Apr 2022 13:57:36 +0700
Message-Id: <20220403065735.23859-1-bagasdotme@gmail.com>
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

Fixes: da40d85805937d (RISC-V: KVM: Document RISC-V specific parts of KVM API, 2021-09-27)
Cc: Anup Patel <anup.patel@wdc.com>
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

