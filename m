Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5646507E37
	for <lists+kvm@lfdr.de>; Wed, 20 Apr 2022 03:34:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358733AbiDTBfv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Apr 2022 21:35:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352841AbiDTBfv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Apr 2022 21:35:51 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6FFC2C138
        for <kvm@vger.kernel.org>; Tue, 19 Apr 2022 18:33:06 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id l127so489241pfl.6
        for <kvm@vger.kernel.org>; Tue, 19 Apr 2022 18:33:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hGbEx1dzzctQaZO6zjtNFZl0KqYSt48iblytT444Gms=;
        b=SjCVVtY0aKCrFTPVmvuyyFfg8de9NyeYizpAZtyjK5jdPNqfzdywWT9CQmGplWOxUm
         0qdgei8vKZR+0kZkD4zLbEJQ7u0/Moqtt3Kk8ItD5V8Zmezp91kaqIhfzJdj0IdRhf6f
         M6QBKd6z5E9ltQeXCTtfIozmJ5xZpkl5ox83M3pHqCJ7SuSQ/2rHRlt5yYvwBPpvhq3p
         M3D8dK///smktVIuQth5Cnl0fBM7VAZGg/HocmuA0+u1LF1M9UeNdvqCgSYaomwubHxX
         hv1lIHU1fb/E59ykz3LqKs6JlOGKXw2WCQNwCnSebkVx0y/lQXxg9zTt3ULmLfRw8K/H
         lKzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hGbEx1dzzctQaZO6zjtNFZl0KqYSt48iblytT444Gms=;
        b=5QrvZAk1vbsEVcWdIIrk+jJX81DVqbjlItlw0XmDQhG/KMil1DaKxNAJExYrQGgf97
         g+Zw1dbMCbfeHYf11p1BUWZ0c70EvbfQPeJGG70Qd51MugDqqeNkYLQXZ6lVZbXyg2SR
         wYuC4rnpp+b92JHwN+Cv7wfVHTzq7rckXAPegxyheH/XHDPe2EtB76BKISrFW0Uc+xw1
         qlevOeQSC9blgaRKOpQ6h+0yIB7W2g5qistTYRVgBD5Rrr/Bbc1dTeV1oyMSd+lWlr7f
         vYIMq5aSqdD+DIvychDefEjOecRPN1fS0Aegrx7TrtV0V7evszlK0zuyess8Bj1pdHzW
         2Row==
X-Gm-Message-State: AOAM53331IQGadt+zCBWy7E8OdQnFjFm2bTuMgFuSV4H7maWKdghghf+
        qmitL+XGkxG43SDXHFJHOBbVsuP5ZYhuvg==
X-Google-Smtp-Source: ABdhPJxBDNTKQrAD4xKiy6UUsQwEmiOFM9cxlkWFjMfR7qBNOIxAdUiGsdhQlvhD2GVnYSM1rWZrMQ==
X-Received: by 2002:a63:e70f:0:b0:380:d919:beb with SMTP id b15-20020a63e70f000000b00380d9190bebmr17057166pgi.58.1650418385970;
        Tue, 19 Apr 2022 18:33:05 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([66.220.2.162])
        by smtp.gmail.com with ESMTPSA id r13-20020a635d0d000000b003aa482388dbsm2484863pgb.9.2022.04.19.18.33.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Apr 2022 18:33:05 -0700 (PDT)
From:   Atish Patra <atishp@rivosinc.com>
To:     kvm@vger.kernel.org
Cc:     Atish Patra <atishp@rivosinc.com>,
        Atish Patra <atishp@atishpatra.org>,
        Anup Patel <anup@brainfault.org>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        devicetree@vger.kernel.org, Jisheng Zhang <jszhang@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Rob Herring <robh+dt@kernel.org>, kvm-riscv@lists.infradead.org
Subject: [PATCH 0/2] Miscellenous ISA string fixup
Date:   Tue, 19 Apr 2022 18:32:56 -0700
Message-Id: <20220420013258.3639264-1-atishp@rivosinc.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series fixes few issues around ISA string generations for guests.
Earlier these patches were part of the sstc series[1] but I created
a separate series for these fixes as they can be applied separately
as a part of rc fixes.

[1] https://lore.kernel.org/lkml/20220304201020.810380-1-atishp@rivosinc.com/

Atish Patra (2):
RISC-V: KVM: Remove 's' & 'u' as valid ISA extension
RISC-V: KVM: Restrict the extensions that can be disabled

arch/riscv/kvm/vcpu.c | 23 +++++++++++++----------
1 file changed, 13 insertions(+), 10 deletions(-)

--
2.25.1

