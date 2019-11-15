Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6A29FD9A6
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2019 10:45:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727180AbfKOJo5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Nov 2019 04:44:57 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:54287 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726920AbfKOJo4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Nov 2019 04:44:56 -0500
Received: by mail-wm1-f66.google.com with SMTP id z26so8957775wmi.4;
        Fri, 15 Nov 2019 01:44:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=s61crLo7rMvO8Wf80iBrPDgDwSffbeyNgj2v4Ncj5Ag=;
        b=DyoReDyyhRBmrZaTauJCDmNm+/tlTd3FWW/ZoNYN05xqz6RvoflkhN+J91NI8ye6E4
         5/VSJXf/6UpCZPNIno3j6M4oUR2TN3R+xG9uV6Fc3RwJcqyasO/Lqw71+d4uNVMle4Vz
         61PGIXq+qSJkhUU3SK7GYZbuYMT0KFN7lrqURh4wg1vR0F7fedMlJ0l/3wDbguRCJI1u
         xRYQd3W09q1P5EH2j6QOz/rYwK6YBNOTwC83douYCfnHnJNypcE64rDt8sZuHrCS+hXp
         f8YZ1WVWZfn1vc1IoCQCk+9DvU+dANWjX92j41uXBeJfn4HWvfOSeikJG/402s4DNYv9
         Q03w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=s61crLo7rMvO8Wf80iBrPDgDwSffbeyNgj2v4Ncj5Ag=;
        b=M2B36gHIJUp18WQ/tOtESlB8QMI9pP7JmCDxGOQ5e0+dzIJVI+GsA1/GiI+czh0Ufs
         NfREdOSBIQqT4FpzweWn/Y802YoP+RuSqGTKPLkDqKwWSN1uLZCep7tP8rMX7EB4t/+H
         XcCnGw9bjtp8ZkdQleMEO5CiaWd8itbFxDgFoSmpSjKK2263lJC4IbrWQOeCkyn4p4WU
         dPWMAEG9PFeqLiBXTr1feRCn8qIiIK/irRzOj1BOflYKEoMvWlrhr9UNFJZihD48VBbj
         APJbYB7SMvI4O5vTRE3djQuDupyaM7q8wUirrYDBd5ndzd2XmD9Rf2NuKVIRODeMrNp7
         uwqA==
X-Gm-Message-State: APjAAAXs6q29fyDURtwK1hWK0ysQXLP29iC/TOn09fWAKWGP6lv+WNJi
        NE8Ea7tblI2+VkkgRqyfJdbJuLTx
X-Google-Smtp-Source: APXvYqyU+TVj8L3P31QRcrvtWrtvI3pOCkxyInBkWrRnjj5g3p+UdchNp9kkKhraOwu7Mnb6ySx4KQ==
X-Received: by 2002:a7b:cc8b:: with SMTP id p11mr13682877wma.38.1573811094469;
        Fri, 15 Nov 2019 01:44:54 -0800 (PST)
Received: from 640k.lan ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id d13sm10097783wrq.51.2019.11.15.01.44.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 15 Nov 2019 01:44:53 -0800 (PST)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, rkrcmar@redhat.com,
        kvm@vger.kernel.org
Subject: [GIT PULL] More KVM fixes for 5.4-rc8
Date:   Fri, 15 Nov 2019 10:44:52 +0100
Message-Id: <1573811092-12834-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit 8c5bd25bf42effd194d4b0b43895c42b374e620b:

  Merge tag 'for-linus' of git://git.kernel.org/pub/scm/virt/kvm/kvm (2019-11-12 13:19:15 -0800)

are available in the git repository at:


  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 9cb09e7c1c9af2968d5186ef9085f05641ab65d9:

  KVM: Add a comment describing the /dev/kvm no_compat handling (2019-11-15 10:14:04 +0100)

----------------------------------------------------------------
* Fixes for CONFIG_KVM_COMPAT=n
* Two updates to the IFU erratum
* selftests build fix
* Brown paper bag fix

----------------------------------------------------------------
Marc Zyngier (2):
      KVM: Forbid /dev/kvm being opened by a compat task when CONFIG_KVM_COMPAT=n
      KVM: Add a comment describing the /dev/kvm no_compat handling

Paolo Bonzini (1):
      kvm: x86: disable shattered huge page recovery for PREEMPT_RT.

Sean Christopherson (1):
      KVM: x86/mmu: Take slots_lock when using kvm_mmu_zap_all_fast()

Vitaly Kuznetsov (1):
      selftests: kvm: fix build with glibc >= 2.30

Xiaoyao Li (1):
      KVM: X86: Reset the three MSR list number variables to 0 in kvm_init_msr_list()

 arch/x86/kvm/mmu.c                       | 10 +++++++---
 arch/x86/kvm/x86.c                       |  4 ++++
 tools/testing/selftests/kvm/lib/assert.c |  4 ++--
 virt/kvm/kvm_main.c                      | 15 ++++++++++++++-
 4 files changed, 27 insertions(+), 6 deletions(-)
