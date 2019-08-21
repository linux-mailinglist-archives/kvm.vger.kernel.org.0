Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEB8E9816D
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2019 19:37:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729977AbfHURg5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Aug 2019 13:36:57 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:40612 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728535AbfHURg5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Aug 2019 13:36:57 -0400
Received: by mail-wm1-f65.google.com with SMTP id c5so2777632wmb.5;
        Wed, 21 Aug 2019 10:36:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=smhXu1L5t6GuvxXpM02oEkcG3qy/NF91cs0u42tWNQM=;
        b=Z7SZLu+1OWPt/QYrEf3gyDmxq2SiRh/WlDoNoD9cXWQW8PfO6Bg2S6A72046Wbb69b
         fuqPMdlWe2O0FipE/J1iPyhMAOp7BTcYSDB51HiqDqy9fDCeQ/seS7z0aTYhrcPhDsEd
         iK52/paX6q2MJNbM35hzjgnq3X6nebfa9TLxD+KLpSlw+bWeXUQnGfF8nI6xKw+ELGbs
         wWr5BIRKIPEdW/826poZAbTrS7mUqW9Oh5ixr04Z8t8TXEy3WsIAnUYcBh0THUSdoWWw
         jwyempdtrYCOpPNfUUkuw4gNXiuA5KV11Ej5F9qL4lZ6DMhAsM7pEZM2igDG2A4aGTO7
         NdpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=smhXu1L5t6GuvxXpM02oEkcG3qy/NF91cs0u42tWNQM=;
        b=DKy0LCB2LVqwtAyd4Op0oZW0/X/7GJQ3MPANVt50XikgDRX86eQF8gW5U4i5WZPRoP
         CXx/kQE7Ae2HkCuputTDqs/y0DKW0tbTa37e22c1nZ70Ly8S7NooJBuCJatfW1fr3SR7
         aqtXXidLqgBiCVEvo7cpo3Iloxtn9LNwQGocJin1QgB3kTma1VnXi2vssTfDeP+RNUyb
         YRxVdpb2DT139v/omDBjlB3HE6i7R8vE7lThB+kLw6IvpX2NgnU4sMqgg1An/kgCMEb0
         DMXniCZM0cBJ9JlAbSUIpIjXAioi1208zHGRMuz5pS3l7oiQwIDW7WA4g8vsGp4vueAh
         rUWQ==
X-Gm-Message-State: APjAAAXym44ZtrQwMsbSRPR1pIYK0eOWlpbFv0tIJaKdf+/ZNMHCxrIM
        19zBqjvHYD4HUwEzkumYua0=
X-Google-Smtp-Source: APXvYqyXNaXwSC85caOVq0J3S9SmTrgdefplsopEPHCiE6o/zPmn3cLlBkTYVCg6pWayt8sHC4PbyA==
X-Received: by 2002:a1c:9ad8:: with SMTP id c207mr1246531wme.145.1566409014779;
        Wed, 21 Aug 2019 10:36:54 -0700 (PDT)
Received: from 640k.localdomain.com ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id 2sm1109217wmz.16.2019.08.21.10.36.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 21 Aug 2019 10:36:53 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, rkrcmar@redhat.com,
        kvm@vger.kernel.org
Subject: [GIT PULL] KVM fixes for Linux 5.3-rc6
Date:   Wed, 21 Aug 2019 19:36:50 +0200
Message-Id: <1566409010-50104-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit a738b5e75b4c13be3485c82eb62c30047aa9f164:

  Merge tag 'kvmarm-fixes-for-5.3-2' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD (2019-08-09 16:53:50 +0200)

are available in the git repository at:


  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to e4427372398c31f57450565de277f861a4db5b3b:

  selftests/kvm: make platform_info_test pass on AMD (2019-08-21 19:08:18 +0200)

----------------------------------------------------------------
* A couple bugfixes, and mostly selftests changes.

----------------------------------------------------------------
Miaohe Lin (1):
      KVM: x86: svm: remove redundant assignment of var new_entry

Paolo Bonzini (7):
      MAINTAINERS: change list for KVM/s390
      MAINTAINERS: add KVM x86 reviewers
      selftests: kvm: do not try running the VM in vmx_set_nested_state_test
      selftests: kvm: provide common function to enable eVMCS
      selftests: kvm: fix vmx_set_nested_state_test
      selftests: kvm: fix state save/load on processors without XSAVE
      Revert "KVM: x86/mmu: Zap only the relevant pages when removing a memslot"

Radim Krcmar (1):
      kvm: x86: skip populating logical dest map if apic is not sw enabled

Vitaly Kuznetsov (1):
      selftests/kvm: make platform_info_test pass on AMD

 MAINTAINERS                                        | 19 +++++++------
 arch/x86/kvm/lapic.c                               |  5 ++++
 arch/x86/kvm/mmu.c                                 | 33 +---------------------
 arch/x86/kvm/svm.c                                 |  1 -
 tools/testing/selftests/kvm/include/evmcs.h        |  2 ++
 tools/testing/selftests/kvm/lib/x86_64/processor.c | 16 +++++++----
 tools/testing/selftests/kvm/lib/x86_64/vmx.c       | 20 +++++++++++++
 tools/testing/selftests/kvm/x86_64/evmcs_test.c    | 15 ++--------
 tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c  | 12 +++-----
 .../selftests/kvm/x86_64/platform_info_test.c      |  2 +-
 .../kvm/x86_64/vmx_set_nested_state_test.c         | 32 +++++++++------------
 11 files changed, 69 insertions(+), 88 deletions(-)
