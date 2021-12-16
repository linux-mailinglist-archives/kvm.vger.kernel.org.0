Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 731704767CC
	for <lists+kvm@lfdr.de>; Thu, 16 Dec 2021 03:19:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232821AbhLPCTY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Dec 2021 21:19:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229955AbhLPCTX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Dec 2021 21:19:23 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09372C061574;
        Wed, 15 Dec 2021 18:19:23 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id f125so21748649pgc.0;
        Wed, 15 Dec 2021 18:19:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jQV7FfPG/i8kPxltYpwfNsq8SB4s3/l4Q6kb1p2cVFA=;
        b=iQgjLSKvkj+yHSVeQJYFXpzEAQWq+NPItDT4Wa4q3FxXVdzZd8OeKVjESiF66O9c+I
         1dtSLL4On4zLRLYxrPbVlTEBqVPCYFjjdvzW+UCqLBoH2k2pQJmZRAH/8T4b9Kbw8pEX
         m2JhUnz2I2FuKTp57+2VNzjs3cCTwBKpmKrfcWrYC075O0BkKBE62kEomHdvEk3qf75B
         lww/R3Ac8YDvV8tKHdfANXdF6miPn6T0hprvgdFVmL2F1oMb3DpaSGFcsfuflYmhtuGV
         jOx8+S+P6hkiARNSlWh7AaJjuXJuFBPMfRLh8D+ntNkhHKqRjCb8r1eTng7lFzFlXCRP
         aMQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jQV7FfPG/i8kPxltYpwfNsq8SB4s3/l4Q6kb1p2cVFA=;
        b=tPCC9Ooc2nWuGzAabpCHRVo69+ireA6c5xRL2tED3kRCZPv0FQu50757kX4Lo8tIGa
         2HDd7GtipRPzPf2UjnuPm5VGrbi2HJ2lIC4WhoxC+NWajQwRfsfNmFXSLoo2Uwakph1W
         DM6VR+UASgnx73Fg78T6WKFEdAqhHEP+MDVUFoD7dIAqklLwhLSwxT11jfKdJFCEZac3
         3iQ6giCLcjZYlzP+0fuYpMNPdUWO/rrFiQsRYXNpRocAaAt4ilcEIKLXuZ6fIZyH3+zl
         2gy5x6nPSSXk+9IJQ8q+27oAXcOsGSzZfa1pw/KD33FFalnMZWE1DjmtV3GAuHByJH8p
         swEw==
X-Gm-Message-State: AOAM531xgAnRDRbNrAp08+2CI2gmPqNCJfIkBVA8Gj2usodOyZqlShRm
        bgy/7/2B5OFOfqqZNca/7szSJP9LX3ICCg==
X-Google-Smtp-Source: ABdhPJz/ovzEFvbLSkyH78y2230v4/B2RolhcPGN89OcTDMllxm3WHSMK0CFDx2x3Tesff+0UGyxBA==
X-Received: by 2002:a65:6895:: with SMTP id e21mr9995968pgt.546.1639621162188;
        Wed, 15 Dec 2021 18:19:22 -0800 (PST)
Received: from localhost ([198.11.176.14])
        by smtp.gmail.com with ESMTPSA id i67sm3853845pfg.189.2021.12.15.18.19.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 15 Dec 2021 18:19:21 -0800 (PST)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Lai Jiangshan <laijs@linux.alibaba.com>
Subject: [PATCH 0/3] KVM: x86: Fixes for kvm/queue
Date:   Thu, 16 Dec 2021 10:19:35 +0800
Message-Id: <20211216021938.11752-1-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

Patch 1 and patch 2 are updated version of the original patches with
the same title.  The original patches need to be dequeued.  (Paolo has
sent the reverting patches to the mail list and done the work, but I
haven't seen the original patches dequeued or reverted in the public
kvm tree.  I need to learn a bit more how patches are managed in kvm
tree.)

Patch 3 fixes for commit c62c7bd4f95b ("KVM: VMX: Update vmcs.GUEST_CR3
only when the guest CR3 is dirty").  Patch 3 is better to be reordered
to before the commit since the commit has not yet into Linus' tree.


Lai Jiangshan (3):
  KVM: VMX: Save HOST_CR3 in vmx_prepare_switch_to_guest()
  KVM: X86: Ensure pae_root to be reconstructed for shadow paging if the
    guest PDPTEs is changed
  KVM: VMX: Mark VCPU_EXREG_CR3 dirty when !CR0_PG -> CR0_PG if EPT +
    !URG

 arch/x86/kvm/vmx/nested.c | 11 +++--------
 arch/x86/kvm/vmx/vmx.c    | 28 ++++++++++++++++++----------
 arch/x86/kvm/vmx/vmx.h    |  5 +++--
 arch/x86/kvm/x86.c        |  7 +++++++
 4 files changed, 31 insertions(+), 20 deletions(-)

-- 
2.19.1.6.gb485710b

