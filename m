Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71E5843269B
	for <lists+kvm@lfdr.de>; Mon, 18 Oct 2021 20:39:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233084AbhJRSlr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Oct 2021 14:41:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232025AbhJRSlq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Oct 2021 14:41:46 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83F68C061765
        for <kvm@vger.kernel.org>; Mon, 18 Oct 2021 11:39:35 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id q193-20020a252aca000000b005ba63482993so21354184ybq.0
        for <kvm@vger.kernel.org>; Mon, 18 Oct 2021 11:39:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=zbKObNCCx6Q849wRiTACIU3Nwa3Q1mgOx/AJ885YK1U=;
        b=ewnQxOzspq4HJZkbUCTWWYQdweGuzAhI5JHMsXpCoZj05ESDZ7iITh+cIkry7MjI9p
         EDD8TwKyiCnbI4soPO6u4m/OJG1OJH4lPI88t5uwWda2SQ5tBoQ8DFIN3PrrMeLXELQT
         nUSbvwDXy59AQmX3Jmfv3PgURppSN0gxG6iKqvnEHiVqKCo4wqY9bKkfJCoI4r+xjTX/
         1cr3/sCj24xKwRbBb+F+rEjXtzwgHykrpFfm+KyN31CcVZpCoM/vi8kbgihQsRclAJWW
         EmcS1EVhAF88XNLrLyNsYRhYYssctMQZx5YPbOg7PozThheX2RTY1ygZ3xuGBA7N83od
         uf+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=zbKObNCCx6Q849wRiTACIU3Nwa3Q1mgOx/AJ885YK1U=;
        b=s2EhBpiD9Hl629MVk3FQiVBxrorWggbBBPm9IT/tdfmR4mcUV3fAlvYzwozGc0r0k/
         IFSwwdAD5waGf6PZefPRULkcZusao6ofjhkYFrTZR4XSCe3O1WecCZrchJVtgMK9IibI
         fRFB+swt/RUIIOlToMOV73sq94cJJStuZweCLq0Y1TdnPxWz0Vhl7IX2jJkdGXMYpiKI
         x2Q4Vtg0QerFoPrQXy/wZLPDoFRUTOUyUUfQiIAoJaGG5oqsOCVjeXZi+rr+9rhXSo6p
         Yin/D7n+FGtSllLvwdBai6aZ+Whi5/Vix+72r9AlmqtVbW/5uBYAMG6/qdo3uK0NLghl
         na+Q==
X-Gm-Message-State: AOAM531WNejcgTGgHoU0C1cDEN/BlaCfh2A5tvF4PdmNxavBJG0E2shb
        NpRJcvijt7fhh+0kpnINMZBF4KOHy9o=
X-Google-Smtp-Source: ABdhPJyDgwDxy5D7Ckq87cNIAuO17yslQzxiYDHjImsqSs59s61FEnK23VRpyDxW4BDFfAz3MNr+uWNDB6k=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:ae71:c4e5:5609:3546])
 (user=seanjc job=sendgmr) by 2002:a25:d084:: with SMTP id h126mr30637770ybg.80.1634582374776;
 Mon, 18 Oct 2021 11:39:34 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon, 18 Oct 2021 11:39:27 -0700
Message-Id: <20211018183929.897461-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
Subject: [PATCH 0/2] KVM: x86: Enhance vendor module error messages
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paul Menzel <pmenzel@molgen.mpg.de>,
        "Maciej S . Szmigiero" <mail@maciej.szmigiero.name>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paul Menzel encountered the bad userspace behavior of spamming KVM module
loading on all CPUs, which was mitigated by commit ef935c25fd64 ("kvm: x86:
Limit the number of "kvm: disabled by bios" messages"), except this time
userspace is extra "clever" and spams both kvm_intel and kvm_amd.  Because
the "already loaded the other module" message isn't ratelimited, the bogus
module load managed to spam the kernel log.

Patch 1 addresses another suggestion from Paul by incorporating the vendor
module name into the error messages.

Patch 2 addresses the original report by prioritizing the hardware/bios
support messages over the "already loaded" error.  In additional to
reducing spam, doing so also ensures consistent messaging if a vendor
module isn't supported regardless of what other modules may be loaded.

[*] https://lkml.kernel.org/r/20210818114956.7171-1-pmenzel@molgen.mpg.de

Sean Christopherson (2):
  KVM: x86: Add vendor name to kvm_x86_ops, use it for error messages
  KVM: x86: Defer "already loaded" check until after basic support
    checks

 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/svm/svm.c          |  2 ++
 arch/x86/kvm/vmx/vmx.c          |  2 ++
 arch/x86/kvm/x86.c              | 17 +++++++++--------
 4 files changed, 15 insertions(+), 8 deletions(-)

-- 
2.33.0.1079.g6e70778dc9-goog

