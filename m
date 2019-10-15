Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0193D78BA
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2019 16:36:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732721AbfJOOgW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Oct 2019 10:36:22 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:41808 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732599AbfJOOgV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Oct 2019 10:36:21 -0400
Received: by mail-pl1-f195.google.com with SMTP id t10so9689421plr.8
        for <kvm@vger.kernel.org>; Tue, 15 Oct 2019 07:36:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=cLAwBrnafbrt9J1uJn5jsQACw4S4ae1p8THVsWr/E1g=;
        b=hMPbKjDkqDoi0WTHeuY3YNKQOZURFyiBP95maDFM8tmxUOUUb5LxRgI8zktGTVcF5S
         40qdEJLj4Tv6MITgm3lvDhtfRXIwhdExKHpln6zYABvcUPrBcibPxzn+oPCsyoa0cSGi
         SSWMF29uPKgpRPix6BL5YV/38X6io8hhwci8tCVzYAREAOmRIRXcgO/jTYphbQNB7c9Y
         srgLqZz/gsc+1qJPjJBD8txC+K/WVNghN9EL7l4T8rAKHEYxdvCOmp8PJIhzZbBEWim4
         1BLc/+su3BDOyDN5SxHJNtEPvXnPR+DwP3g1rYBhImPvz5OQPhLyVzpjiaHaKuFcMPzw
         hmXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=cLAwBrnafbrt9J1uJn5jsQACw4S4ae1p8THVsWr/E1g=;
        b=DMG6Xq9/XTg3GM9c9e7Hj9ukibDOQY2VukGz5NUkPBPatDFrtfqZ1hNHJNXk5He/m3
         e/4EwLVEBP2wL52wBLAvHGKVm+L+njvTOM92NV3ueSWLyj3kJUbtKby9nRJORfyvB8Dn
         2+gc8eC8dq7npSsGBPpQYJgHMMaysdW1c1FPAX1lqsgESH3hpEcYUn2Deb4GYzjfie8e
         /n9Mz/1t5/KXEiugDZuPfqhW0LKpnS1nJ+bONWp51miyCAceO+zOvi6mX9PscxsyrNYL
         VSHcnZlpvT3MoDw/KEmN+cz0+PCA7sTFo4Oob3zgtrbkkUOe2CPxV35IS4pCWD+F8KeD
         kxZQ==
X-Gm-Message-State: APjAAAX68D9paGk1PnOjWY2gAtYiJO3jZ9apZFrpWViZiKHpMbwP+mcY
        KgR9yG6UiuJuM7TTsrAjHGg=
X-Google-Smtp-Source: APXvYqzF5pVPQErQhvHW99GLzPBhE8631lYzEVomzsVgfCIHBcKlZ9qSzfVbW15Q253AW9Hl83LDHw==
X-Received: by 2002:a17:902:8ecc:: with SMTP id x12mr36755018plo.189.1571150179735;
        Tue, 15 Oct 2019 07:36:19 -0700 (PDT)
Received: from localhost.corp.microsoft.com ([167.220.255.39])
        by smtp.googlemail.com with ESMTPSA id v43sm4913165pjb.1.2019.10.15.07.36.16
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 15 Oct 2019 07:36:18 -0700 (PDT)
From:   lantianyu1986@gmail.com
X-Google-Original-From: Tianyu.Lan@microsoft.com
To:     mst@redhat.com, cohuck@redhat.com, pbonzini@redhat.com,
        rth@twiddle.net, ehabkost@redhat.com, mtosatti@redhat.com,
        rkagan@virtuozzo.com
Cc:     Tianyu Lan <Tianyu.Lan@microsoft.com>, kvm@vger.kernel.org,
        qemu-devel@nongnu.org
Subject: [PATCH V2 0/2] target/i386/kvm: Add Hyper-V direct tlb flush support
Date:   Tue, 15 Oct 2019 22:36:08 +0800
Message-Id: <20191015143610.31857-1-Tianyu.Lan@microsoft.com>
X-Mailer: git-send-email 2.14.5
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tianyu Lan <Tianyu.Lan@microsoft.com>

This patchset is to enable Hyper-V direct tlbflush
feature. The feature is to let L0 hypervisor to handle
tlb flush hypercall for L1 hypervisor.

Tianyu Lan (2):
  linux headers: update against Linux 5.4-rc2
  target/i386/kvm: Add Hyper-V direct tlb flush support

 docs/hyperv.txt                              | 12 +++++
 include/standard-headers/asm-x86/bootparam.h |  2 +
 include/standard-headers/asm-x86/kvm_para.h  |  1 +
 include/standard-headers/linux/ethtool.h     | 24 ++++++++++
 include/standard-headers/linux/pci_regs.h    | 19 +++++++-
 include/standard-headers/linux/virtio_ids.h  |  2 +
 include/standard-headers/linux/virtio_pmem.h |  6 +--
 linux-headers/asm-arm/kvm.h                  | 16 ++++++-
 linux-headers/asm-arm/unistd-common.h        |  2 +
 linux-headers/asm-arm64/kvm.h                | 21 +++++++-
 linux-headers/asm-generic/mman-common.h      | 18 ++++---
 linux-headers/asm-generic/mman.h             | 10 ++--
 linux-headers/asm-generic/unistd.h           | 10 +++-
 linux-headers/asm-mips/mman.h                |  3 ++
 linux-headers/asm-mips/unistd_n32.h          |  2 +
 linux-headers/asm-mips/unistd_n64.h          |  2 +
 linux-headers/asm-mips/unistd_o32.h          |  2 +
 linux-headers/asm-powerpc/mman.h             |  6 +--
 linux-headers/asm-powerpc/unistd_32.h        |  2 +
 linux-headers/asm-powerpc/unistd_64.h        |  2 +
 linux-headers/asm-s390/kvm.h                 |  6 +++
 linux-headers/asm-s390/unistd_32.h           |  2 +
 linux-headers/asm-s390/unistd_64.h           |  2 +
 linux-headers/asm-x86/kvm.h                  | 28 ++++++++---
 linux-headers/asm-x86/unistd.h               |  2 +-
 linux-headers/asm-x86/unistd_32.h            |  2 +
 linux-headers/asm-x86/unistd_64.h            |  2 +
 linux-headers/asm-x86/unistd_x32.h           |  2 +
 linux-headers/linux/kvm.h                    | 12 ++++-
 linux-headers/linux/psp-sev.h                |  5 +-
 linux-headers/linux/vfio.h                   | 71 ++++++++++++++++++++--------
 target/i386/cpu.c                            |  2 +
 target/i386/cpu.h                            |  1 +
 target/i386/kvm.c                            | 23 +++++++++
 34 files changed, 263 insertions(+), 59 deletions(-)

-- 
2.14.5

