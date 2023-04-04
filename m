Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1152A6D6081
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 14:34:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234883AbjDDMeP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 08:34:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234730AbjDDMeN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 08:34:13 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C852B26B7
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 05:34:06 -0700 (PDT)
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com [209.85.208.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id EB58F3F235
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 12:27:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1680611220;
        bh=9ENFOZdcJofTg+G3Q0sdPkBng9VIxMpyo7ko+MfAWgE=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type;
        b=h2CSB8EdYYsI9YqsT0N/UEsrDDHCKNuHKauT/GVMGz46FkHtM9M/v7fbtn5AQnGvR
         2nuSVJeWhcg/iZUoxRI5totbFeHR9Jy5ASBQbzSlReXAxZ/2QwiFER4TSSQS2kF6Xt
         h6rT0lVaTMoOA27dkluXs0ZC97f4TkJ4iJ2XO3tDOvlLzIzWvJaTkl46qeXeG6eZMd
         Se/1LR6aqvkpKCrrbKrei3eBdZSwWpLEt62oOQbjHQX2/Is8zCRcqAVYOTudETBKLa
         UDsAlYPXjhzV1WR3WVtWQQpH5sv6KbHlDIagvrNab6hb5ctBOyDa1iy2lgLB04hjmj
         hW3SwfEpD12fw==
Received: by mail-ed1-f71.google.com with SMTP id n6-20020a5099c6000000b00502c2f26133so735279edb.12
        for <kvm@vger.kernel.org>; Tue, 04 Apr 2023 05:27:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680611216;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9ENFOZdcJofTg+G3Q0sdPkBng9VIxMpyo7ko+MfAWgE=;
        b=01OpXFmjJoLiyguctaTFtt/cwnkvRv4aJvs7PiikUOYpHnlnPiK654gSDUANrMBitn
         d7vRDz1wISgv8Pw8/WmXAZPtaC0WncjwLiCfkU8MD+fl2Mf4pf5CRwt2/XaR/Zdkandm
         +EgUoUAkUYEFZCOX/Xf24zgGI8DSd5UwJ/Vfo6DeTx3Ky5l45bwPNmxbIryFUvrNLlkv
         VkGFPxrnSX4jLxj2DHkcSvF8bUaFL7KP97Q2Aq0+1eQ+T8WkXqA0NcK2j4ixpbD82gKm
         3dcJ6HzZh9iY99Z72Lk7s/NYUWOVLeVupEg6xRWjKeVJb/PlMzj9cr9fjmT4jkX7uMxo
         d9YA==
X-Gm-Message-State: AAQBX9d93wx+D56xP5r43/yUa5Ge2Hdn1vcFnGShrVCFsZ9TkNZ6HK7l
        fwd/POWK42iVSLc1djZu2RmrewWUhMormAM+4H2m5WMVxluIS8n+q67xf96Og/ZGf9Pw891j8wj
        YQ2tUgXJV4ammGj+Rxaqw7NmFV5cOdXxFbFl2pQ==
X-Received: by 2002:a17:906:b2d8:b0:8aa:be5c:b7c5 with SMTP id cf24-20020a170906b2d800b008aabe5cb7c5mr2615140ejb.41.1680611216498;
        Tue, 04 Apr 2023 05:26:56 -0700 (PDT)
X-Google-Smtp-Source: AKy350YK7dIFMKHdzLUn+TbexEGPUR09oWybc7hS6C7wknQ/k9JkXRXOv7AJU6xO/r0HPdlO1yOQew==
X-Received: by 2002:a17:906:b2d8:b0:8aa:be5c:b7c5 with SMTP id cf24-20020a170906b2d800b008aabe5cb7c5mr2615117ejb.41.1680611216273;
        Tue, 04 Apr 2023 05:26:56 -0700 (PDT)
Received: from amikhalitsyn.. ([95.91.208.118])
        by smtp.gmail.com with ESMTPSA id p18-20020a170906229200b00930ba362216sm6033056eja.176.2023.04.04.05.26.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 05:26:55 -0700 (PDT)
From:   Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
To:     pbonzini@redhat.com
Cc:     Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
        Sean Christopherson <seanjc@google.com>,
        =?UTF-8?q?St=C3=A9phane=20Graber?= <stgraber@ubuntu.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] KVM: SVM: small tweaks for sev_hardware_setup
Date:   Tue,  4 Apr 2023 14:26:50 +0200
Message-Id: <20230404122652.275005-1-aleksandr.mikhalitsyn@canonical.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM: SVM: add some info prints to SEV init
    
Let's add a few pr_info's to sev_hardware_setup to make SEV/SEV-ES
enabling a little bit handier for users. Right now it's too hard
to guess why SEV/SEV-ES are failing to enable.

There are a few reasons.
SEV:
- npt is disabled (module parameter)
- CPU lacks some features (sev, decodeassists)
- Maximum SEV ASID is 0

SEV-ES:
- mmio_caching is disabled (module parameter)
- CPU lacks sev_es feature
- Minimum SEV ASID value is 1 (can be adjusted in BIOS/UEFI)

==
   
KVM: SVM: free sev_*asid_bitmap init if SEV init fails

If misc_cg_set_capacity() fails for some reason then we have
a memleak for sev_reclaim_asid_bitmap/sev_asid_bitmap. It's
not a case right now, because misc_cg_set_capacity() just can't
fail and check inside it is always successful.

But let's fix that for code consistency.

Cc: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Stéphane Graber <stgraber@ubuntu.com>
Cc: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>

Alexander Mikhalitsyn (2):
  KVM: SVM: free sev_*asid_bitmap init if SEV init fails
  KVM: SVM: add some info prints to SEV init

 arch/x86/kvm/svm/sev.c | 34 +++++++++++++++++++++++++++-------
 1 file changed, 27 insertions(+), 7 deletions(-)

-- 
2.34.1

