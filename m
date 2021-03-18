Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73C3E34054B
	for <lists+kvm@lfdr.de>; Thu, 18 Mar 2021 13:17:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230506AbhCRMQd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Mar 2021 08:16:33 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:52177 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230414AbhCRMQA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Mar 2021 08:16:00 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id D42B11030;
        Thu, 18 Mar 2021 08:08:46 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 18 Mar 2021 08:08:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=ysZiObwgOVy+D+Sr9
        R4Hl9GG6VbFETnjrwlJvPxCrR8=; b=k7nyjL3SuNolyS4sQzvJu3DvGNZ4HRi7n
        wgusgb5cqGKY+6IN/gtOhP3JCGX8TQbS/5nSDILWVkHGZlDQyP0xFAQXO9N2V8eN
        4UwOyKcjrgf7IHf2nxt3qxTAGKxyaaM3kn3rGvE2Wk11jwWTgq5it86PtBs7ZNYn
        +67ndThEkQoZq25b9hOAAjhu5MQa+csivxV7aFVKywM8OncZMDsBSVcvR4vLPI3B
        +TzB7BDzHLMhg033yIsq0gjhVgf5NwtLLR63o/L+gMkp46T72ibl3rM7WSmCXtjX
        t0TIaEP8BGrJFVTjlFdREoILffLDo9oMonVn/F4pE5Ra7sQkMdhew==
X-ME-Sender: <xms:y0JTYALloevO1Q9ScAR1YlJdLOl9wvZBj3ni89UrQlJhJVderFradQ>
    <xme:y0JTYFRC5bvq391G8u3Xc0WWCr2oyG4l81kE-XsRSCxbvka0r5yb_WonzNYufiQkc
    kJqV9GoDf0G6Yd1EzM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudefiedgfeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkffoggfgsedtkeertdertddtnecuhfhrohhmpeffrghvihguucfg
    ughmohhnughsohhnuceouggrvhhiugdrvggumhhonhgushhonhesohhrrggtlhgvrdgtoh
    hmqeenucggtffrrghtthgvrhhnpeduhfetvdfhgfeltddtgeelheetveeufeegteevtddu
    iedvgeejhfdukeegteehheenucfkphepkedurddukeejrddviedrvdefkeenucevlhhush
    htvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegurghvihgurdgvughm
    ohhnughsohhnsehorhgrtghlvgdrtghomh
X-ME-Proxy: <xmx:y0JTYDqNdnQbWOCniV2QeHfj6moOJ0hExN-ruCN-dCc6UbJPCchweQ>
    <xmx:y0JTYDaGIMpEE6AsX8zesSyhbTgFT85prT6QADhi9Yxifi_iYdbkrg>
    <xmx:y0JTYOT3OLJjLcsBWoqQWlCwtFhBh6Ckrq7UNokRUAXezrQMk9N5Yg>
    <xmx:zkJTYJsLJTd05MSfEKZf-O_az24rTWm16-rkDrsmKWLLptDdIXcecNNeGMxRQoGc>
Received: from disaster-area.hh.sledj.net (disaster-area.hh.sledj.net [81.187.26.238])
        by mail.messagingengine.com (Postfix) with ESMTPA id B1D3D108006D;
        Thu, 18 Mar 2021 08:08:42 -0400 (EDT)
Received: from localhost (disaster-area.hh.sledj.net [local])
        by disaster-area.hh.sledj.net (OpenSMTPD) with ESMTPA id 4cd56965;
        Thu, 18 Mar 2021 12:08:41 +0000 (UTC)
From:   David Edmondson <david.edmondson@oracle.com>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@redhat.com>, Joerg Roedel <joro@8bytes.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Wanpeng Li <wanpengli@tencent.com>, x86@kernel.org,
        Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        David Edmondson <david.edmondson@oracle.com>
Subject: [PATCH v5 0/5] KVM: x86: dump_vmcs: don't assume GUEST_IA32_EFER, show MSR autoloads/autosaves
Date:   Thu, 18 Mar 2021 12:08:36 +0000
Message-Id: <20210318120841.133123-1-david.edmondson@oracle.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v2:
- Don't use vcpu->arch.efer when GUEST_IA32_EFER is not available (Paolo).
- Dump the MSR autoload/autosave lists (Paolo).

v3:
- Rebase to master.
- Check only the load controls (Sean).
- Always show the PTPRs from the VMCS if they exist (Jim/Sean).
- Dig EFER out of the MSR autoload list if it's there (Paulo).
- Calculate and show the effective EFER if it is not coming from
  either the VMCS or the MSR autoload list (Sean).

v4:
- Ensure that each changeset builds with just the previous set.

v5:
- Rebase.
- Remove some cruft from changeset comments.
- Add S-by as appropriate.

David Edmondson (5):
  KVM: x86: dump_vmcs should not assume GUEST_IA32_EFER is valid
  KVM: x86: dump_vmcs should not conflate EFER and PAT presence in VMCS
  KVM: x86: dump_vmcs should consider only the load controls of EFER/PAT
  KVM: x86: dump_vmcs should show the effective EFER
  KVM: x86: dump_vmcs should include the autoload/autostore MSR lists

 arch/x86/kvm/vmx/vmx.c | 58 +++++++++++++++++++++++++++++-------------
 arch/x86/kvm/vmx/vmx.h |  2 +-
 2 files changed, 42 insertions(+), 18 deletions(-)

-- 
2.30.2

