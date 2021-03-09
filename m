Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CB79331CE1
	for <lists+kvm@lfdr.de>; Tue,  9 Mar 2021 03:20:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230397AbhCICTr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Mar 2021 21:19:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230512AbhCICTW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Mar 2021 21:19:22 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2101C06174A
        for <kvm@vger.kernel.org>; Mon,  8 Mar 2021 18:19:21 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id 194so15239276ybl.5
        for <kvm@vger.kernel.org>; Mon, 08 Mar 2021 18:19:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=LHP3MFoVQ43/Gdu+SGGU2Is+rQZvEboJW+kRfZtIQZg=;
        b=v7urjtWEjHOqyhANz7nFw0kaPm9raBppEFnZDYvx7qFQqJzsK8pdL4gt4ZnZw/bHT9
         Cp9xkaguoC80WQZYY9gWD0/uB8xuBN8vwlY60QiSyE8LI20slrRP/qbxo3PuwcVWciAY
         ng31rfT81AbR94iBpRSLzXwObL/sfr6cIMDSLrlukpe+3PG7Oko6cb3o5+OgccuAdctd
         Fm0iWBv2F/fAsngBn+anutmUzokyADBbBbo2vU9nYH6MpnMOPRnx1QNJy4VUVmWwHmHe
         q8qsUi1C5D/6pAqx+yZIa1pNcyo4oHyqbNeySKRCDdab+bM8r+ZLhAsTrOPmH6DBSM3B
         hx1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:message-id:mime-version
         :subject:from:to:cc;
        bh=LHP3MFoVQ43/Gdu+SGGU2Is+rQZvEboJW+kRfZtIQZg=;
        b=DUBk1eKD/pPNneVqRab7WuerE2F6Tpnb2XJsTeddQfKyLLI3xi/zyAEPJ5OmIkL/Uz
         lEzWUHcoJoYdJgQdeT79/C5e8iZ20/oqVovjo1hO1/NieBaZHBN51r6dA6wJim1OaWHj
         6fJisopJeAj30r655s25a/p1t4zc31CRcLv1PCTwGqHWiLC94tDGI1FYn6/Rs8mOnu9r
         kUSgBnVQkOL8SZZ1R7Fk+7KF92MjKxCAXF79yrftOiZoNMJUDLL0TgPMKrK0iLMeP9dy
         DUEMs6qPnEcQimfWgGtxNCT9JN+R/9lJSsq6x94No0xAQ+AV9ZSksomr2ltY0SOO74d+
         tI8Q==
X-Gm-Message-State: AOAM532aQ0vDpNW2rYfItdnhcqPt+EJVKaiD9Ud2Qr27BRGHEZna7sCY
        1MCkzJiW8INDGyzhkMqeFd/JzUZOTlk=
X-Google-Smtp-Source: ABdhPJyq27oip7hDkYlMjMkztlsUexbcEDv3n7XSxHWiJPIx5Qg3sDA6iE+hYLdwyQZ/M+0JF+uyBqQmSSY=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:8:847a:d8b5:e2cc])
 (user=seanjc job=sendgmr) by 2002:a25:3bc6:: with SMTP id i189mr19775166yba.31.1615256361119;
 Mon, 08 Mar 2021 18:19:21 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon,  8 Mar 2021 18:18:58 -0800
Message-Id: <20210309021900.1001843-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH 0/2] Fixups to hide our goofs
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Please squash away our mistakes and hide them from the world. :-)

Stuffed the MMIO generation to start at 0x3ffffffffffffff0 (bits 61:4 set)
and role over into bit 62.  Bit 63 is used for the "update in-progress" so
I'm fairly confident there are no more collisions with other SPTE bits.

For the PCID thing, note that there are two patches with the same changelog.
Not sure what's intended there...

Also, I forgot about adding the PAE root helpers until I tried testing and
PAE didn't work with SME.  I'll get those to you tomorrow.

Sean Christopherson (2):
  KVM: x86: Fixup "Get active PCID only when writing a CR3 value"
  KVM: x86/mmu: Exclude the MMU_PRESENT bit from MMIO SPTE's generation

 arch/x86/kvm/mmu/spte.h | 12 +++++++-----
 arch/x86/kvm/svm/svm.c  |  9 +++++++--
 2 files changed, 14 insertions(+), 7 deletions(-)

-- 
2.30.1.766.gb4fecdf3b7-goog

