Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 886B13EB122
	for <lists+kvm@lfdr.de>; Fri, 13 Aug 2021 09:12:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239275AbhHMHMs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Aug 2021 03:12:48 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:59575 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239230AbhHMHMq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 13 Aug 2021 03:12:46 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailforward.nyi.internal (Postfix) with ESMTP id 25FA0194076A;
        Fri, 13 Aug 2021 03:12:18 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Fri, 13 Aug 2021 03:12:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=IJ84Zz7cXD2dARXk2
        E4si9LSMTMEPXvMGAWxocLB7k8=; b=KLPKleY+V+TZn7ffDpWBbAMHhDbU5PLd4
        CGEukJFWJMJ7zseXMfvCsGkDWVB+JlDZkCvkQXLeWg4dh3neJ1756YodHhm6klEP
        sEVgh3+3vTpDt8hcQhyB4/vRnrn84CHG1g3FfGtK9lAjlAv4cSR6aGOYqFioCo9B
        PcjhPSw+vhMMDSl8b0jKttvFway/muwGtKvByqBZuWNShdmX5LP5CeNv1hMwC028
        3ZkTBN4i/+hODlDecP30cGFoJyl2ydSItwmqaknnqo+IwdktqMpZEDp1xqN/wHhd
        c/poT2PtVokLUiSwvZvG1fMWEtgG1RSptilx/u0bPt1PJoODfp6pA==
X-ME-Sender: <xms:TxsWYc4F_mQvQqAEI6dKg-QUCj-wNM-lCqfNGfnyD2WiHYampzItEg>
    <xme:TxsWYd6oPX_dxxN7xCymbvl2cn_W3rvKyrqQQPtJ9UjpN9dcT60bikWeRHEgR07vh
    z9cohHqkKo-TTAgeJU>
X-ME-Received: <xmr:TxsWYbeyALtUZhaN4E1HFtJG-opvzR1BgNhzEfx3iSXXwpl_E_3yoqyB4D9q_lBVL6px8GYj-X9BiYOWxmWjtAzkWo1pDoZBTyYYWpm1ie0>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrkeeggdduudejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkffoggfgsedtkeertdertddtnecuhfhrohhmpeffrghvihguucfg
    ughmohhnughsohhnuceouggrvhhiugdrvggumhhonhgushhonhesohhrrggtlhgvrdgtoh
    hmqeenucggtffrrghtthgvrhhnpeduhfetvdfhgfeltddtgeelheetveeufeegteevtddu
    iedvgeejhfdukeegteehheenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpegurghvihgurdgvughmohhnughsohhnsehorhgrtghlvgdrtghomh
X-ME-Proxy: <xmx:TxsWYRLuc_fs7O6HqTS3E7Xb_sP6mONlxk1GtGeIDkl61UqwCFUXwg>
    <xmx:TxsWYQJOHNVJtMx5hiOgAxILBRcTaaLGEURarB0xAIdXid2khuwZhw>
    <xmx:TxsWYSyf4VEatx40J9CeUX9cDQf25jxvV3IL0fXvRu5Db6JqPwP3yQ>
    <xmx:UhsWYVgvTlRhDmolQXmesWRyAzGqbNPuaa_CSzOBDQ_nOFjrmcjCDE4gnZs>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 13 Aug 2021 03:12:14 -0400 (EDT)
Received: from localhost (disaster-area.hh.sledj.net [local])
        by disaster-area.hh.sledj.net (OpenSMTPD) with ESMTPA id 94f31bc7;
        Fri, 13 Aug 2021 07:12:12 +0000 (UTC)
From:   David Edmondson <david.edmondson@oracle.com>
To:     linux-kernel@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>, Borislav Petkov <bp@alien8.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Wanpeng Li <wanpengli@tencent.com>,
        Ingo Molnar <mingo@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Matlack <dmatlack@google.com>, x86@kernel.org,
        kvm@vger.kernel.org, David Edmondson <david.edmondson@oracle.com>
Subject: [PATCH v4 0/4] KVM: x86: Convey the exit reason, etc. to user-space on emulation failure
Date:   Fri, 13 Aug 2021 08:12:07 +0100
Message-Id: <20210813071211.1635310-1-david.edmondson@oracle.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To help when debugging failures in the field, if instruction emulation
fails, report the VM exit reason, etc. to userspace in order that it
can be recorded.

The SGX changes here are compiled but untested.

Sean: if you want me to add your name to patch 3, given that I adopted
your sample code almost unaltered, please say.

v4:
- Update the API for preparing emulation failure report (Sean)
- sgx uses the provided API in all relevant cases (Sean)
- Clarify the intended layout of kvm_run.emulation_failure.

v3:
- Convey any debug data un-flagged after the ABI specified data in
  struct emulation_failure (Sean)
- Obey the ABI protocol in sgx_handle_emulation_failure() (Sean)

v2:
- Improve patch comments (dmatlock)
- Intel should provide the full exit reason (dmatlock)
- Pass a boolean rather than flags (dmatlock)
- Use the helper in kvm_task_switch() and kvm_handle_memory_failure()
  (dmatlock)
- Describe the exit_reason field of the emulation_failure structure
  (dmatlock)

David Edmondson (4):
  KVM: x86: Clarify the kvm_run.emulation_failure structure layout
  KVM: x86: Get exit_reason as part of kvm_x86_ops.get_exit_info
  KVM: x86: On emulation failure, convey the exit reason, etc. to
    userspace
  KVM: x86: SGX must obey the KVM_INTERNAL_ERROR_EMULATION protocol

 arch/x86/include/asm/kvm_host.h | 10 +++--
 arch/x86/kvm/svm/svm.c          |  8 ++--
 arch/x86/kvm/trace.h            |  9 ++--
 arch/x86/kvm/vmx/nested.c       |  2 +-
 arch/x86/kvm/vmx/sgx.c          | 16 +++-----
 arch/x86/kvm/vmx/vmx.c          | 11 +++--
 arch/x86/kvm/x86.c              | 73 ++++++++++++++++++++++++++-------
 include/uapi/linux/kvm.h        | 15 ++++++-
 8 files changed, 100 insertions(+), 44 deletions(-)

-- 
2.30.2

