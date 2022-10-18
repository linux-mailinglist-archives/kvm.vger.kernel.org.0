Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CF1B602DF4
	for <lists+kvm@lfdr.de>; Tue, 18 Oct 2022 16:09:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230227AbiJROJc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Oct 2022 10:09:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229980AbiJROJa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Oct 2022 10:09:30 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9052BA191
        for <kvm@vger.kernel.org>; Tue, 18 Oct 2022 07:09:27 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id z20so13912322plb.10
        for <kvm@vger.kernel.org>; Tue, 18 Oct 2022 07:09:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=zLYGLW92+QDS2tatdBIF+eWiA8z6wO0DOJUQRMlllsk=;
        b=Q7+TU83unTlXTjf03Higcr8RYNMHQwYutK39/HXdJJ3M3tEzqKNYpQHeyphXnWvZCg
         +wYK/zYRMo17Rom6KkHdmLO6Cd2sQWfFkKmgl7iTAV+O1l6C1JREKaM4JIGCeI2iq/0E
         ovVb7OgZ8wg/gGLH4T5NunxFgxnPGJfZN312sLd2uwM01l5HxrFt8so975gSNpIMU/FL
         bsqRQFVXIpGDN4ID79q0EVuCkhjijLfm+aO1fI7ckbvx+XPYKMIkc/EL3qcWX/7GSNKF
         zmfoRIFVqoMKhpt6EP1SC2CpkmW7V3AkNabqO/MYPyMbGCOGQ2rZyfeR5qGqe/dQrhMM
         t7dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zLYGLW92+QDS2tatdBIF+eWiA8z6wO0DOJUQRMlllsk=;
        b=JFLKXdYxYMop5q+A4phKALm3SUPjahDt7WvWo6vRAj27+KqVaWxO6gKRicxassZ83b
         fQY9PyeevUbWYHs4C95v4AdB9XMBbtcU6L5xX28+U8hZ62mnbKbe5OJUGQ8pdXijhwh8
         sUooth+UoHZPelAJMLPDNIff+lpDe6naCv4DlGERjDy4Kxxm1tt7zpTVBZtHLhLEZ0VG
         JwqwpZDDYxYmeU7fXTAOWnDg5Bqtxky0NVMKTASVBI4n5OyyN41v5KMSxKHlLdxxlCr+
         DdODKicLFgiQ8jOvexb/0TIMPFMIMkVkZPrD0FEPjQ4kaVILeTkOs9uIwlx26wQ7aUQn
         RElA==
X-Gm-Message-State: ACrzQf2tg1m/FRvnkr3Fdqs70uIUWLZqXH1EEMTnaa039En6Gjth6FiJ
        1en8noILdZFLaZSP2sqG8Ryt8A==
X-Google-Smtp-Source: AMsMyM4o/6xqzAWsSKkYgdCp/Y7tfw/YBHjC9JeQ1WWYcZxH/jccK1/4F9AUcFGKe3CONCThzzG2/A==
X-Received: by 2002:a17:90b:17c7:b0:20b:7cb:9397 with SMTP id me7-20020a17090b17c700b0020b07cb9397mr34334269pjb.191.1666102166811;
        Tue, 18 Oct 2022 07:09:26 -0700 (PDT)
Received: from anup-ubuntu64-vm.. ([171.76.86.161])
        by smtp.gmail.com with ESMTPSA id z15-20020a17090a170f00b002009db534d1sm8119913pjd.24.2022.10.18.07.09.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Oct 2022 07:09:26 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com,
        maz@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH kvmtool 0/6] RISC-V Svinval, Zihintpause, anad Zicbom support
Date:   Tue, 18 Oct 2022 19:38:48 +0530
Message-Id: <20221018140854.69846-1-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
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

The latest Linux-6.1-rc1 has support for Svinval, Zihintpause and Zicbom
extensions in KVM RISC-V. This series adds corresponding changes in KVMTOOL
to allow Guest/VM use these new RISC-V extensions.

These patches can also be found in the riscv_svinval_zihintpause_zicbom_v1
branch at: https://github.com/avpatel/kvmtool.git

Andrew Jones (2):
  riscv: Move reg encoding helpers to kvm-cpu-arch.h
  riscv: Add Zicbom extension support

Anup Patel (3):
  Update UAPI headers based on Linux-6.1-rc1
  riscv: Add Svinval extension support
  riscv: Add --disable-<xyz> options to allow user disable extensions

Mayuresh Chitale (1):
  riscv: Add zihintpause extension support

 arm/aarch64/include/asm/kvm.h       |  6 ++++--
 include/linux/kvm.h                 |  1 +
 include/linux/virtio_blk.h          | 19 +++++++++++++++++++
 include/linux/virtio_net.h          | 14 +++++++-------
 include/linux/virtio_ring.h         | 16 +++++++++++-----
 riscv/fdt.c                         | 23 +++++++++++++++++++++--
 riscv/include/asm/kvm.h             |  4 ++++
 riscv/include/kvm/kvm-config-arch.h | 18 +++++++++++++++++-
 riscv/include/kvm/kvm-cpu-arch.h    | 19 +++++++++++++++++++
 riscv/kvm-cpu.c                     | 16 ----------------
 10 files changed, 103 insertions(+), 33 deletions(-)

-- 
2.34.1

