Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 297593B67D5
	for <lists+kvm@lfdr.de>; Mon, 28 Jun 2021 19:41:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234674AbhF1Rn1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Jun 2021 13:43:27 -0400
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:50183 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233675AbhF1RnZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 28 Jun 2021 13:43:25 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailforward.nyi.internal (Postfix) with ESMTP id 0A78719403B9;
        Mon, 28 Jun 2021 13:31:59 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Mon, 28 Jun 2021 13:31:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=qX6seYzechjeHaUvw
        CiEvbqf3DDRF8gmaZeeYhm+qKk=; b=k51kt4wyFTPRHWZeJYFNJdVnHAb2Nvhke
        5eQUqxJzUj+GrrFMaVZtYS+c7+TOH1qhzhjOJEouD18wZYfP725wQuvHxETXGKxH
        uHzpPD2+cgXQuDzltLW2G39aFNUKZ9fskh9pPmviS6Jvyh1wG8wRfku/8ElQVRdJ
        MLAA+RSu/p6AnCpTRKihoF6rl88yYRV++VfwbiKftufK6YoeZnqRTZsHuGjyEriI
        TLrBaUf3Xlnp62c2kSLGAja5lOlKGP3do4lIDvfhCrQme+smGADegNp/UqDvFMzx
        ODS5UtLocpnTtrFuT+cNAy1LbNIJrCqdmdOosrx0ASjRu5CH/rYpw==
X-ME-Sender: <xms:iwfaYDi_X61ry9MSpTZBavz0rrCpWKyH9vmEyrmQ5_LnsGRCvejIdQ>
    <xme:iwfaYADXJvdyl8Ag5uX9YIOgPglV6rlqGUPVAcSbLMTg3ryJ3M0mV0ga90bFYOfqZ
    72bnuJThWXOk7l4cEw>
X-ME-Received: <xmr:iwfaYDHjE0xPITKWMOODdjlr7I2VAF6iK6r7960doZ3L7QGC7mLOAFHhaSv_sloISfqF8MwDx75wfNiXz79JihfPxTgf9kWHOaBthg0U35s>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeehgedgudduvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefhvffufffkofgggfestdekredtredttdenucfhrhhomhepffgrvhhiugcu
    gfgumhhonhgushhonhcuoegurghvihgurdgvughmohhnughsohhnsehorhgrtghlvgdrtg
    homheqnecuggftrfgrthhtvghrnhephfeftdeiveelteeuueekffdvffefiefgtddvffeg
    iedtgeefffeliefhvedtkeefnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlh
    hushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegurghvihgurdgv
    ughmohhnughsohhnsehorhgrtghlvgdrtghomh
X-ME-Proxy: <xmx:iwfaYAQupXbPh-MXQ75jiWn_jt5NwMePDzxVeMxcxytuZBM8Au9Qcg>
    <xmx:iwfaYAz0nwuIUH6efUcNoa1KCuvoEBrgRc_EYcyP5pApDrx4J11ukg>
    <xmx:iwfaYG5NVIz1aYRb1Ap051mORBKdolbjFaCb_LP0fJXGgolRuop_cQ>
    <xmx:jwfaYFqhW9kI7lUWHS-NfGaVIOEtJ5f2c0BelM16QmxOaMvarX59ujx2s9o>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 28 Jun 2021 13:31:53 -0400 (EDT)
Received: from localhost (disaster-area.hh.sledj.net [local])
        by disaster-area.hh.sledj.net (OpenSMTPD) with ESMTPA id 11d09b7f;
        Mon, 28 Jun 2021 17:31:52 +0000 (UTC)
From:   David Edmondson <david.edmondson@oracle.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>, x86@kernel.org,
        David Edmondson <david.edmondson@oracle.com>
Subject: [PATCH 0/2] KVM: x86: Convey the exit reason to user-space on emulation failure
Date:   Mon, 28 Jun 2021 18:31:50 +0100
Message-Id: <20210628173152.2062988-1-david.edmondson@oracle.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To aid in debugging failures in the field, when instruction emulation
fails, report the VM exit reason to userspace in order that it can be
recorded.

The changes are on top of Aaron's patches from
https://lore.kernel.org/r/20210510144834.658457-1-aaronlewis@google.com
which are in the KVM queue, but not yet upstream.

David Edmondson (2):
  KVM: x86: Add kvm_x86_ops.get_exit_reason
  KVM: x86: On emulation failure, convey the exit reason to userspace

 arch/x86/include/asm/kvm-x86-ops.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  1 +
 arch/x86/kvm/svm/svm.c             |  6 ++++++
 arch/x86/kvm/vmx/vmx.c             |  6 ++++++
 arch/x86/kvm/x86.c                 | 23 +++++++++++++++++------
 include/uapi/linux/kvm.h           |  2 ++
 6 files changed, 33 insertions(+), 6 deletions(-)

-- 
2.30.2

