Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0243314BC27
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2020 15:51:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727210AbgA1OvU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jan 2020 09:51:20 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:58552 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726595AbgA1N6p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jan 2020 08:58:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=DXSED2YLe82h5LjexvdXkjf3Ix9TaTo2l6rYLelz1VU=; b=I6JXhiBvTPnxAO4xl5bXPdJT/
        IMcr66RCWxFIXF4QbZ6roOONRSRzDdeIVF3taD8tJjLdxXFjT3eNYaSfh2T9xwBLnWcfDXOMYl9Lp
        YgJWWa/fBNXoLe78ImqUSk5OW4KxV6GBNsX7KblWK4bKPJYjDboVXCiwSgJxPF9MuMi2SqgwWqlaf
        0TcsMxG0BBI6la7Scf0kK75mCQpDtQQj9VIRND31YSkwN5hmiDMnrw0PHykzjcRvd/oAzu2xcYXAc
        XAiJ980vlNy2hY0tJN9QXCIUul4j1b+EX10mb+9fJs43+DV/OSA4dIraTt2+yl1jduOffBF4QwWh8
        HzwXAws2Q==;
Received: from [177.41.103.99] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iwRO8-0006LY-FB; Tue, 28 Jan 2020 13:58:44 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92.3)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1iwRNq-001BJB-1s; Tue, 28 Jan 2020 14:58:26 +0100
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-um@lists.infradead.org, linux-doc@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Jeff Dike <jdike@addtoit.com>,
        Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 00/27] docs: virt: convert text documents to ReST format
Date:   Tue, 28 Jan 2020 14:57:56 +0100
Message-Id: <cover.1580219586.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Manually convert the documentation under Documentation/virt to ReST,
minimizing the usage of uneeded markups and preserving the documentation
writer's style.

PS.: Patches are against docs-next tree.

Mauro Carvalho Chehab (27):
  docs: kvm: add arm/pvtime.rst to index.rst
  docs: virt: convert UML documentation to ReST
  docs: virt: user_mode_linux.rst: update compiling instructions
  docs: virt: user_mode_linux.rst: fix URL references
  docs: virt: convert halt-polling.txt to ReST format
  docs: virt: Convert msr.txt to ReST format
  docs: kvm: devices/arm-vgic-its.txt to ReST format
  docs: kvm: devices/arm-vgit-v3.txt to ReST
  docs: kvm: convert devices/arm-vgit.txt to ReST
  docs: kvm: convert devices/mpic.txt to ReST
  docs: kvm: convert devices/s390_flic.txt to ReST
  docs: kvm: convert devices/vcpu.txt to ReST
  docs: kvm: convert devices/vcpu.txt to ReST
  docs: kvm: convert devices/vm.txt to ReST
  docs: kvm: convert devices/xics.txt to ReST
  docs: kvm: convert devices/xive.txt to ReST
  docs: kvm: Convert api.txt to ReST format
  docs: kvm: convert arm/hyp-abi.txt to ReST
  docs: kvm: arm/psci.txt: convert to ReST
  docs: kvm: Convert hypercalls.txt to ReST format
  docs: kvm: Convert locking.txt to ReST format
  docs: kvm: Convert mmu.txt to ReST format
  docs: kvm: Convert nested-vmx.txt to ReST format
  docs: kvm: Convert ppc-pv.txt to ReST format
  docs: kvm: Convert s390-diag.txt to ReST format
  docs: kvm: Convert timekeeping.txt to ReST format
  docs: kvm: review-checklist.txt: rename to ReST

 Documentation/virt/index.rst                  |    1 +
 Documentation/virt/kvm/{api.txt => api.rst}   | 3343 ++++++++++-------
 .../virt/kvm/arm/{hyp-abi.txt => hyp-abi.rst} |   26 +-
 Documentation/virt/kvm/arm/index.rst          |   12 +
 .../virt/kvm/arm/{psci.txt => psci.rst}       |   44 +-
 .../{arm-vgic-its.txt => arm-vgic-its.rst}    |  104 +-
 .../{arm-vgic-v3.txt => arm-vgic-v3.rst}      |  130 +-
 .../devices/{arm-vgic.txt => arm-vgic.rst}    |   87 +-
 Documentation/virt/kvm/devices/index.rst      |   19 +
 .../virt/kvm/devices/{mpic.txt => mpic.rst}   |    9 +-
 .../devices/{s390_flic.txt => s390_flic.rst}  |   68 +-
 Documentation/virt/kvm/devices/vcpu.rst       |  112 +
 Documentation/virt/kvm/devices/vcpu.txt       |   76 -
 .../virt/kvm/devices/{vfio.txt => vfio.rst}   |   23 +-
 .../virt/kvm/devices/{vm.txt => vm.rst}       |  204 +-
 .../virt/kvm/devices/{xics.txt => xics.rst}   |   26 +-
 .../virt/kvm/devices/{xive.txt => xive.rst}   |  146 +-
 .../{halt-polling.txt => halt-polling.rst}    |   84 +-
 .../kvm/{hypercalls.txt => hypercalls.rst}    |  127 +-
 Documentation/virt/kvm/index.rst              |   16 +
 .../virt/kvm/{locking.txt => locking.rst}     |  109 +-
 Documentation/virt/kvm/{mmu.txt => mmu.rst}   |   60 +-
 Documentation/virt/kvm/{msr.txt => msr.rst}   |  145 +-
 .../kvm/{nested-vmx.txt => nested-vmx.rst}    |   35 +-
 .../virt/kvm/{ppc-pv.txt => ppc-pv.rst}       |   24 +-
 ...iew-checklist.txt => review-checklist.rst} |    1 +
 .../virt/kvm/{s390-diag.txt => s390-diag.rst} |   11 +-
 .../kvm/{timekeeping.txt => timekeeping.rst}  |  221 +-
 ...odeLinux-HOWTO.txt => user_mode_linux.rst} | 1812 ++++-----
 29 files changed, 3954 insertions(+), 3121 deletions(-)
 rename Documentation/virt/kvm/{api.txt => api.rst} (71%)
 rename Documentation/virt/kvm/arm/{hyp-abi.txt => hyp-abi.rst} (80%)
 create mode 100644 Documentation/virt/kvm/arm/index.rst
 rename Documentation/virt/kvm/arm/{psci.txt => psci.rst} (61%)
 rename Documentation/virt/kvm/devices/{arm-vgic-its.txt => arm-vgic-its.rst} (71%)
 rename Documentation/virt/kvm/devices/{arm-vgic-v3.txt => arm-vgic-v3.rst} (77%)
 rename Documentation/virt/kvm/devices/{arm-vgic.txt => arm-vgic.rst} (66%)
 create mode 100644 Documentation/virt/kvm/devices/index.rst
 rename Documentation/virt/kvm/devices/{mpic.txt => mpic.rst} (92%)
 rename Documentation/virt/kvm/devices/{s390_flic.txt => s390_flic.rst} (88%)
 create mode 100644 Documentation/virt/kvm/devices/vcpu.rst
 delete mode 100644 Documentation/virt/kvm/devices/vcpu.txt
 rename Documentation/virt/kvm/devices/{vfio.txt => vfio.rst} (74%)
 rename Documentation/virt/kvm/devices/{vm.txt => vm.rst} (61%)
 rename Documentation/virt/kvm/devices/{xics.txt => xics.rst} (85%)
 rename Documentation/virt/kvm/devices/{xive.txt => xive.rst} (63%)
 rename Documentation/virt/kvm/{halt-polling.txt => halt-polling.rst} (64%)
 rename Documentation/virt/kvm/{hypercalls.txt => hypercalls.rst} (55%)
 rename Documentation/virt/kvm/{locking.txt => locking.rst} (79%)
 rename Documentation/virt/kvm/{mmu.txt => mmu.rst} (94%)
 rename Documentation/virt/kvm/{msr.txt => msr.rst} (75%)
 rename Documentation/virt/kvm/{nested-vmx.txt => nested-vmx.rst} (90%)
 rename Documentation/virt/kvm/{ppc-pv.txt => ppc-pv.rst} (91%)
 rename Documentation/virt/kvm/{review-checklist.txt => review-checklist.rst} (97%)
 rename Documentation/virt/kvm/{s390-diag.txt => s390-diag.rst} (91%)
 rename Documentation/virt/kvm/{timekeeping.txt => timekeeping.rst} (85%)
 rename Documentation/virt/uml/{UserModeLinux-HOWTO.txt => user_mode_linux.rst} (74%)

-- 
2.24.1


