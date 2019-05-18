Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2CCC22589
	for <lists+kvm@lfdr.de>; Sun, 19 May 2019 01:23:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729347AbfERXWa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 18 May 2019 19:22:30 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:39752 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729041AbfERXWa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 18 May 2019 19:22:30 -0400
Received: by mail-pg1-f195.google.com with SMTP id w22so4979083pgi.6
        for <kvm@vger.kernel.org>; Sat, 18 May 2019 16:22:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=rBFblHD8r7DMGILbjk889zwyBhzX7FSsFRICHAEo2hY=;
        b=b96ydjCjjZ4vokvMQmd+x7SWHXdxCDLryKv/U0XJtXAr0inbg2pKTWVTwDkSnOdzzF
         opVsEAuzZ6P4k36IvvSa/0anHUZRk4tPtPwv0xhr5EyfqMI/vpZcxXtZK5E/szOJvyCG
         ugPHABeDisgFKCRgdJknwF8pxGPRhQzcGZCSxKTT8h0x8IScczHkZIvAVu1eUhdbVXmG
         vOMpSfIV105rmyqEArSlysHrNJl1MMrJjeCa29mx4gD/7jnlljHslmdA7rm8LRn5BTr1
         qIIpg441j4XcubaQhSkiIPkwciQz6hZNII1N/K8s6c4y5nvLLOg+2ELppqC114K0132z
         vGyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=rBFblHD8r7DMGILbjk889zwyBhzX7FSsFRICHAEo2hY=;
        b=sbCP6ruGLqR98Bnx4XsUzvffRWN207R9o63TuNvyc42jOwjoB6x5tG5bdT9M3/2KW2
         BMnfD5TLx6RoG07pl5Le7rrVLz4bpmY4S6k8jobmMCOp1IOIhfrXCEdlf9/UDN34NN3m
         XHDTUdrVTID+m0RcfOtEp+vjDCR3qF+53ErgtTCbWyQ6ZwSopUZhrJRfH4DAwwMxm5Bg
         coJSlQc1yIZ2FLFonVbZQ2DgZpDCoSWDm5zD078fj3YMD3aV0H60JFYzl/9erWa0YRnB
         5Xn+QKMOjtAAYqiEDmV9GHZ+j21DGtzsiXoyreLtLI7GBPc6r0o6Sb9Bpud302xUJqrE
         cC/Q==
X-Gm-Message-State: APjAAAW70QLSYtU28Hw6KmmJwQCc3IhpiRYxbv3VyQ2cs/zs96X7twkK
        aEMbwrsDPquRFF5ti10iTe5Rz78RBL0=
X-Google-Smtp-Source: APXvYqwPz4zmmQQ9Ge8hBC5WbRink02uxHd07TW3uKnzfkz768c/kIv15T5Uoi69QpXr051bPIYg4g==
X-Received: by 2002:a62:53:: with SMTP id 80mr43410758pfa.183.1558221749387;
        Sat, 18 May 2019 16:22:29 -0700 (PDT)
Received: from sc2-haas01-esx0118.eng.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id x17sm20496352pgh.47.2019.05.18.16.22.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 18 May 2019 16:22:28 -0700 (PDT)
From:   Nadav Amit <nadav.amit@gmail.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, rkrcmar@redhat.com,
        Nadav Amit <nadav.amit@gmail.com>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [kvm-unit-tests PATCH v2 0/2] x86: nVMX: Fix NMI/INTR-window tests
Date:   Sat, 18 May 2019 09:02:29 -0700
Message-Id: <20190518160231.4063-1-nadav.amit@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

NMI/INTR-window test in VMX have a couple of bugs. Each of the patches
fixes one. The first version of this patch-set claimed that one of the
bugs might be a silicon issue. However, according to Sean, it is a
just a test and KVM issue, once you read the SDM more carefully.

Cc: Jim Mattson <jmattson@google.com>
Cc: Sean Christopherson <sean.j.christopherson@intel.com>

Nadav Amit (2):
  x86: nVMX: Use #DB in nmi- and intr-window tests
  x86: nVMX: Set guest as active after NMI/INTR-window tests

 x86/vmx_tests.c | 80 +++++++++++++++++++++++--------------------------
 1 file changed, 38 insertions(+), 42 deletions(-)

-- 
2.17.1

