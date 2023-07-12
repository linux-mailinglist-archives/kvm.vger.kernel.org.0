Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B77F750EA5
	for <lists+kvm@lfdr.de>; Wed, 12 Jul 2023 18:35:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232108AbjGLQfP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jul 2023 12:35:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231721AbjGLQfN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jul 2023 12:35:13 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CAF31BF3
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 09:35:10 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id d9443c01a7336-1b8ad907ba4so37796755ad.0
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 09:35:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1689179710; x=1691771710;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=C0Z1RxN/iyVvtGFYDyZC8zK8ivEuKHuGZzGFKsTTtfk=;
        b=EVI9O0THafxtUhHT90eDDgjL/IXyOZ6x7N5gdXTu4SV+Q10PXy3wIOnQS9HM9A46uD
         cTeGVilBraLOu/5FrHmfyjt+uDOWOpbaq9ifhpbXWlJMRvijJPb8eb2/7igSDUail2vq
         CNDeL5Y8r91hrTGoAs0ZfxIibEpO75Hl1QaSdF7n9wIHRpFCHxa7E6+Wy++FdirM3h8A
         0iARWUbOSBIjitQW5ntQ7mBVIF1TJ1ILg28JGWQBIsCs1yB2iic6i4qpuAF2FXC/3obM
         FTE3v1PvieBDyCKZW32AoYnd8YLMnrkOZ04jmY6pg8ZWkBF8nSN3kS/QhDJ5ySa1t5CK
         1X3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689179710; x=1691771710;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=C0Z1RxN/iyVvtGFYDyZC8zK8ivEuKHuGZzGFKsTTtfk=;
        b=cVJc1WkNo7EKhPEdUliwmo091g11eqJaNP0e/U8Rnoyn8CYbp9OK5j4pksj/skAAMT
         kCdGclk1jkWQyOA5crlWt/ZgXZeM72v4xAd4FCMBwdIq5sEh8R9IfJodtOpWftTD/tt1
         9LzbVHHSVnZHLyZaoVGFz3dkbz9PiFrS+FB9LsPg7Z5awenI7PrBhHcVrSR2weH71BUT
         ZCKnzTmVyvY1HfN7vsYc2NTmvED68V3aHQIos4iHfSONvIQsqaoTcwv105eudHgCZaNM
         Mq4pjrj7Q32sKMG9pfOFQJzYkW3n9mPl0vnjxuICaRzcERbkIebCZ1IolKXa3tbqs/Wr
         t5qw==
X-Gm-Message-State: ABy/qLYaizJauajAPXcyPuOMRIcTX6lT7fVCpduTJ+QH8PgcR9zxAKVl
        bzLkHl8HARteRrk1+yJsHnUXGA==
X-Google-Smtp-Source: APBJJlFL0l4VXL/o+0WGoWwxDc/9yw4269PHkKEcJ7KSHaGcBKazdTu/77C3aLGqa9E8XlVOaZ7WRw==
X-Received: by 2002:a17:902:d487:b0:1b6:7f96:42ca with SMTP id c7-20020a170902d48700b001b67f9642camr17214071plg.66.1689179709724;
        Wed, 12 Jul 2023 09:35:09 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([171.76.82.173])
        by smtp.gmail.com with ESMTPSA id w15-20020a1709027b8f00b001b9df74ba5asm4172164pll.210.2023.07.12.09.35.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jul 2023 09:35:09 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com,
        maz@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Andrew Jones <ajones@ventanamicro.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Anup Patel <apatel@ventanamicro.com>
Subject: [kvmtool PATCH v4 0/9] RISC-V SBI enable/disable, Zbb, Zicboz, and Ssaia support
Date:   Wed, 12 Jul 2023 22:04:52 +0530
Message-Id: <20230712163501.1769737-1-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The latest KVM in Linux-6.4 has support for:
1) Enabling/disabling SBI extensions from KVM user-space
2) Zbb ISA extension support
3) Zicboz ISA extension support
4) Ssaia ISA extension support

This series adds corresponding changes in KVMTOOL to use the above
mentioned features for Guest/VM.

These patches can also be found in the riscv_sbi_zbb_zicboz_ssaia_v4
branch at: https://github.com/avpatel/kvmtool.git

Changes since v3:
 - Add the __DECLARE_FLEX_ARRAY() compiler error fix as a separate
   patch.

Changes since v2:
 - Rebased on commit 0b5e55fc032d1c6394b8ec7fe02d842813c903df
 - Updated PATCH1 to sync-up header with released Linux-6.4

Changes since v1:
 - Rebased on commit b17552ee6c9728c20c9d0bd037ef134277daaa40
 - Fixed compile error for KVMTOOL x86 by adding __DECLARE_FLEX_ARRAY()
   in include/linux/stddef.h

Andrew Jones (1):
  riscv: Add Zicboz extension support

Anup Patel (8):
  kvm tools: Add __DECLARE_FLEX_ARRAY() in include/linux/stddef.h
  Sync-up headers with Linux-6.4
  riscv: Allow setting custom mvendorid, marchid, and mimpid
  riscv: Allow disabling SBI extensions for Guest
  riscv: Sort the ISA extension array alphabetically
  riscv: Add zbb extension support
  riscv: Add Ssaia extension support
  riscv: Fix guest RAM alloc size computation for RV32

 arm/aarch64/include/asm/kvm.h       |  38 ++++++++++
 include/linux/kvm.h                 |  57 +++++++++------
 include/linux/stddef.h              |  16 +++++
 include/linux/virtio_blk.h          | 105 ++++++++++++++++++++++++++++
 include/linux/virtio_config.h       |   6 ++
 include/linux/virtio_net.h          |   5 ++
 riscv/fdt.c                         |  19 ++++-
 riscv/include/asm/kvm.h             |  56 ++++++++++++++-
 riscv/include/kvm/kvm-config-arch.h |  51 +++++++++++++-
 riscv/include/kvm/kvm-cpu-arch.h    |  19 +++--
 riscv/kvm-cpu.c                     |  45 +++++++++++-
 riscv/kvm.c                         |  15 +++-
 x86/include/asm/kvm.h               |  50 ++++++++++---
 13 files changed, 435 insertions(+), 47 deletions(-)

-- 
2.34.1

