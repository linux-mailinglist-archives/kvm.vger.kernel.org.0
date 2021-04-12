Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8721C35C712
	for <lists+kvm@lfdr.de>; Mon, 12 Apr 2021 15:09:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241773AbhDLNKE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Apr 2021 09:10:04 -0400
Received: from wforward5-smtp.messagingengine.com ([64.147.123.35]:50317 "EHLO
        wforward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241762AbhDLNKD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 12 Apr 2021 09:10:03 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailforward.west.internal (Postfix) with ESMTP id DD56F166C;
        Mon, 12 Apr 2021 09:09:43 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Mon, 12 Apr 2021 09:09:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=HvfGYkD6c6q5bKKXX
        v71mYB4LVLkTvCXjY38JwER9zY=; b=IrmYYw3lKD9YPFcY2YObOjK5hmSskK1No
        0Pi4pNblwsWnnkPrVssJO2q/n2ekOtwhLKj0sBZG3J0pudk2S1rZva27+rU1uc7o
        nXofXjBsUzQ7a1sKJeqLAluYIeVfa20lWlOl5GvCRJi7FTQ300iVg4AGhDG1Szmi
        USX5p8jfP94K2I5o2iFnvgIXWMyjhCpZqO8hCHzvSSh5NMxyhpU973b2PffQbQKL
        nX10/wh3nbsbd9Mc5gPvxegPomaTckCUozd9ubX5BLWhrLFoKrDYLMa4Lb75g4mP
        MgRpkndHPnvdpQpuMbfGFb1BP40EuslaoBTCeQLT0Cp+gnADOeoZA==
X-ME-Sender: <xms:lEZ0YHe8qRFjKHSNjMJnOzRgSQpAXkIWDHipsTyK_nA7a1IKBaPKjg>
    <xme:lEZ0YNNEQjxdWdqQrSJExg7FmdtHd_gjauaN9DcO_ghePDO42TI2Zcr4lN7XUmbg5
    WcgkyRPhzD3DHoLfAg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudekjedgiedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkffoggfgsedtkeertdertddtnecuhfhrohhmpeffrghvihguucfg
    ughmohhnughsohhnuceouggrvhhiugdrvggumhhonhgushhonhesohhrrggtlhgvrdgtoh
    hmqeenucggtffrrghtthgvrhhnpefhfedtieevleetueeukeffvdfffeeigfdtvdffgeei
    tdegfeffleeihfevtdekfeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppe
    ekuddrudekjedrvdeirddvfeeknecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghm
    pehmrghilhhfrhhomhepuggrvhhiugdrvggumhhonhgushhonhesohhrrggtlhgvrdgtoh
    hm
X-ME-Proxy: <xmx:lEZ0YAg48ZU9ihscVRcu6m6i2D1stiUbgNLMMSRyEEQpXIl3tmztdA>
    <xmx:lEZ0YI93T2xtGgtKXKMUp9vfCXEMlTq9BJqGK1lQqB4qvKmYRpy4sQ>
    <xmx:lEZ0YDsmWPmrgibhE6RawTpfXHPRGnD5xwOIM7IE9b7jwbLmjsCgmw>
    <xmx:l0Z0YOmuyhVczSt0b4dC3noOkcatOAJfgkzg36sp1vsuNxj9n7iQQMXjfKcGycPi>
Received: from disaster-area.hh.sledj.net (disaster-area.hh.sledj.net [81.187.26.238])
        by mail.messagingengine.com (Postfix) with ESMTPA id A83D91080067;
        Mon, 12 Apr 2021 09:09:39 -0400 (EDT)
Received: from localhost (disaster-area.hh.sledj.net [local])
        by disaster-area.hh.sledj.net (OpenSMTPD) with ESMTPA id d55ec073;
        Mon, 12 Apr 2021 13:09:38 +0000 (UTC)
From:   David Edmondson <david.edmondson@oracle.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Joerg Roedel <joro@8bytes.org>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>,
        Jim Mattson <jmattson@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        David Edmondson <david.edmondson@oracle.com>
Subject: [PATCH 0/6] KVM: x86: Make the cause of instruction emulation available to user-space
Date:   Mon, 12 Apr 2021 14:09:31 +0100
Message-Id: <20210412130938.68178-1-david.edmondson@oracle.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Instruction emulation happens for a variety of reasons, yet on error
we have no idea exactly what triggered it. Add a cause of emulation to
the various originators and pass it upstream when emulation fails.

Joao originally produced the patches but is busy with other things and
I wanted to use it, so picked it up.

Tested by reverting commit 51b958e5aeb1e18c00332e0b37c5d4e95a3eff84
("KVM: x86: clflushopt should be treated as a no-op by emulation")
then running the test included in
https://lore.kernel.org/r/20201118121129.6276-1-david.edmondson@oracle.com.

Joao Martins (6):
  KVM: x86: add an emulation_reason to x86_emulate_instruction()
  KVM: x86: pass emulation_reason to handle_emulation_failure()
  KVM: x86: add emulation_reason to kvm_emulate_instruction()
  KVM: x86: pass a proper reason to kvm_emulate_instruction()
  KVM: SVM: pass a proper reason in kvm_emulate_instruction()
  KVM: VMX: pass a proper reason in kvm_emulate_instruction()

 arch/x86/include/asm/kvm_host.h | 27 +++++++++++++++++++++++--
 arch/x86/kvm/mmu/mmu.c          |  4 ++--
 arch/x86/kvm/svm/avic.c         |  3 ++-
 arch/x86/kvm/svm/svm.c          | 26 +++++++++++++-----------
 arch/x86/kvm/vmx/vmx.c          | 17 ++++++++--------
 arch/x86/kvm/x86.c              | 35 ++++++++++++++++++++++-----------
 arch/x86/kvm/x86.h              |  3 ++-
 7 files changed, 78 insertions(+), 37 deletions(-)

-- 
2.30.2

