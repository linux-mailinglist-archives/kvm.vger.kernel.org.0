Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E47C23BAAC
	for <lists+kvm@lfdr.de>; Tue,  4 Aug 2020 14:47:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728349AbgHDMql (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Aug 2020 08:46:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728258AbgHDMoX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Aug 2020 08:44:23 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA839C06179E
        for <kvm@vger.kernel.org>; Tue,  4 Aug 2020 05:44:22 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id k8so2787831wma.2
        for <kvm@vger.kernel.org>; Tue, 04 Aug 2020 05:44:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pXFf5i+ccqczXVXTg/nZ29LHnMvff9vMvvoJKipTK/k=;
        b=xmDdxPVBebllwYSXr8MTF5/0WVgZGKSZUMcEmtg1Yb6lXQo90+6kVdw3cQCf4XLw2a
         M7kb5BeEfu2MZRYypdtYVL7FuPiQ9THnz2WAl4CNEiw92SXD1Gp2UD3XZwg82u3Ec4mv
         t3ZWzvYQJ2a0G4okutZQe+5ypiJzpjGTq3/5YMxxkhi1n/QDZTKpGr0WFAPJg4NFSYxF
         rzXEuRDF0jzSKq3FW5Wgttxs2iCjBLDtl0PSrYbT2lfK2UrFozrTRxtfl4VFYOEwim7v
         WZZ0lo3eI2JwOsiFmXAMwp3UwPLdLcwIVZCe4upmuSA1YTH3p9bYdrrABYOA4zvUNdI1
         7UHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pXFf5i+ccqczXVXTg/nZ29LHnMvff9vMvvoJKipTK/k=;
        b=VmFAMbaM1A59FACfRN1fTzea9TTkRlK48QJEDmxcZ6fq6LXF9Pql2Cn1txMckF4O6X
         ipbd+pz5JTXdF/Smk8emSGfGjUAsouxIokW+WgSN/oejIVFoULLDCv5X14M3aUDmQWk6
         lW/V4K/nuuiHYouFGyCmuyTeqK6rtJn0ck0GinTxWogEF2iAHYfxczkJ2lRjK+8ufNIf
         YHmgdHnYavKbjeeRgPnFWdN4LBao/zli2H66BeGlDymKp+GoCnJNhDHgh0lGc8qHmVV/
         neff5JGUszxfwUrRE6SwiNcck4EHusFRh+511RlsPXPyfsle/74JRIfg0fiOlCYIdjOV
         ySZw==
X-Gm-Message-State: AOAM532bUhzkdpPjnNKUO/9hRhncutQVkLyCEoOeeFffPTzNrxmkhyhK
        /BNL2IM0GlESTDqIKTq4Zu731g==
X-Google-Smtp-Source: ABdhPJxSYL3nLFynYC8/0kcrhha40SMBrbJj4GceYNd50xdCxUrISm9qcztn279uGdoJsV28A5ASGg==
X-Received: by 2002:a1c:1bc4:: with SMTP id b187mr3879098wmb.175.1596545061671;
        Tue, 04 Aug 2020 05:44:21 -0700 (PDT)
Received: from zen.linaroharston ([51.148.130.216])
        by smtp.gmail.com with ESMTPSA id 15sm4107897wmo.33.2020.08.04.05.44.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2020 05:44:18 -0700 (PDT)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 77F6D1FF7E;
        Tue,  4 Aug 2020 13:44:17 +0100 (BST)
From:   =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc:     linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        christoffer.dall@arm.com, maz@kernel.org,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [RFC PATCH v1 0/3] put arm64 kvm_config on a diet
Date:   Tue,  4 Aug 2020 13:44:14 +0100
Message-Id: <20200804124417.27102-1-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

When building guest kernels for virtualisation we were bringing in a
bunch of stuff from physical hardware which we don't need for our
idealised fixable virtual PCI devices. This series makes some Kconfig
changes to allow the ThunderX and XGene PCI drivers to be compiled
out. It also drops PCI_QUIRKS from the KVM guest build as a virtual
PCI device should be quirk free.

This is my first time hacking around Kconfig so I hope I've got the
balance between depends and selects right but please let be know if it
could be specified in a cleaner way.

Alex Bennée (3):
  arm64: allow de-selection of ThunderX PCI controllers
  arm64: gate the whole of pci-xgene on CONFIG_PCI_XGENE
  kernel/configs: don't include PCI_QUIRKS in KVM guest configs

 arch/arm64/Kconfig.platforms    | 2 ++
 arch/arm64/configs/defconfig    | 1 +
 drivers/pci/controller/Kconfig  | 7 +++++++
 drivers/pci/controller/Makefile | 8 +++-----
 kernel/configs/kvm_guest.config | 1 +
 5 files changed, 14 insertions(+), 5 deletions(-)

-- 
2.20.1

