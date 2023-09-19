Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2093D7A6A0B
	for <lists+kvm@lfdr.de>; Tue, 19 Sep 2023 19:50:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232972AbjISRug (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Sep 2023 13:50:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232834AbjISRud (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Sep 2023 13:50:33 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7F1712C
        for <kvm@vger.kernel.org>; Tue, 19 Sep 2023 10:50:24 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id d2e1a72fcca58-690bb524a97so1512115b3a.2
        for <kvm@vger.kernel.org>; Tue, 19 Sep 2023 10:50:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695145824; x=1695750624; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=kWnTlx7Gdnm5Vz0/SIGYkkfnd0U6Pz1ne+euXaONdhM=;
        b=dm4KCx/jeF6Eauk+h0M7zvUMT0LGtviCzIWZY/DMhvLbUcu3JE+LAvckkl103xiUdr
         RUxLTm9rUdWGxO7YqXDHevM77M1mSFup2da2mbaxBu40kSbNuGnZ3a58uYbl+0YQAY6c
         dlYaxlaWf2NYZxstU+jZLDWEjrKGQHwhKQhhSufhdjUAbstGl/HLa4/6XozDX5l6sDhj
         7J/YdSwKWYFUK17pEo2wVhvwmhPjvPNJFFb7u9JczK4/DwE7bRwJpD2oNIKcHZxXv+o8
         0lGW7aOOX7NJNntrXIJnRH8DJJqJzycrVMiNGKXOfhBo7vI2M6xYILvvVNTMrCkiMoVb
         /ckQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695145824; x=1695750624;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kWnTlx7Gdnm5Vz0/SIGYkkfnd0U6Pz1ne+euXaONdhM=;
        b=aqg5BCoHbCBXEwkrp+DfSAs41T1nrBgeScCjnpbOTohI5aAgvYTwVhJhLOlUhqfyk7
         SUCB8UU3F+IXMYxPJ0alxAZmNY2A9+Rp7LtPtoxrc+/wbUdIzsyBJiYCq0+wkYbk4aXF
         ssS25Z5th9J5CRdhcGmVidanxU+sWIvOe6DebeMn3C2tGjn5G6Tq6ULCNg91ofzH2HWu
         MCA92Beu5JsFIuyS2rI1ZiflsYgeBvDXWJPmLQoFUqbxcxiNH3lpmRMswgHmfbBok9x+
         lRvIOcSoG9JqZ7rHdsXopaC+eWKGu2oyyjIwI+fVFc/jUZAOwI3BZyqTIK6TKu1wVJHr
         rVOw==
X-Gm-Message-State: AOJu0YxeMjeHBusXHFV4gzz0eXuJ0AOP4EtpydXSsaevCayDRJ+116yz
        JECbkqpyEDWVo+lAKnK5naCEs7IgXxmPKDObvhCPSs4t+8n3V0BqWXBXxu/Gsi8fPVxdSfn8LYL
        9rHH7MHObfQCzjIlqXXUg0ZyvVk/J13Gt/MAV853OLUvNfwfk7eov0VRKJqnonPXNGr4apsM=
X-Google-Smtp-Source: AGHT+IEeHiio7e1vKdIgqVCmVLTA7YryY2gvJQIIbbaxBDphMBRHHqcu+bML2gSb43lnX/ewy3LJgGjLyxr0jFKanA==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a05:6a00:2d84:b0:68f:f868:a4fe with
 SMTP id fb4-20020a056a002d8400b0068ff868a4femr10033pfb.2.1695145823586; Tue,
 19 Sep 2023 10:50:23 -0700 (PDT)
Date:   Tue, 19 Sep 2023 10:50:12 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.42.0.459.ge4e396fd5e-goog
Message-ID: <20230919175017.538312-1-jingzhangos@google.com>
Subject: [PATCH v1 0/4] Get writable masks for feature ID from userspace
From:   Jing Zhang <jingzhangos@google.com>
To:     KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>,
        ARMLinux <linux-arm-kernel@lists.infradead.org>,
        Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>
Cc:     Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Suraj Jitindar Singh <surajjs@amazon.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Shaoqin Huang <shahuang@redhat.com>,
        Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch series were part of [1], but actually are independent from that.
In this patch series, a VM ioctl is added to allow userspace to get writable
masks for feature ID registers.
Another two fixes for ID registers are also included in this series.
This is based on v6.6-rc2.

[1] https://lore.kernel.org/all/20230821212243.491660-1-jingzhangos@google.com

---

Jing Zhang (3):
  KVM: arm64: Allow userspace to get the writable masks for feature ID
    registers
  KVM: arm64: Document KVM_ARM_GET_REG_WRITABLE_MASKS
  KVM: arm64: Use guest ID register values for the sake of emulation

Oliver Upton (1):
  KVM: arm64: Reject attempts to set invalid debug arch version

 Documentation/virt/kvm/api.rst    |  42 ++++++++++++
 arch/arm64/include/asm/kvm_host.h |   2 +
 arch/arm64/include/uapi/asm/kvm.h |  32 +++++++++
 arch/arm64/kvm/arm.c              |  10 +++
 arch/arm64/kvm/sys_regs.c         | 104 ++++++++++++++++++++++++++++--
 include/uapi/linux/kvm.h          |   2 +
 6 files changed, 186 insertions(+), 6 deletions(-)


base-commit: ce9ecca0238b140b88f43859b211c9fdfd8e5b70
-- 
2.42.0.459.ge4e396fd5e-goog

