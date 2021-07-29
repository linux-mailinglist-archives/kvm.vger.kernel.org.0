Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03C783DA496
	for <lists+kvm@lfdr.de>; Thu, 29 Jul 2021 15:46:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237738AbhG2NqO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jul 2021 09:46:14 -0400
Received: from wforward5-smtp.messagingengine.com ([64.147.123.35]:47365 "EHLO
        wforward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237665AbhG2NqK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 29 Jul 2021 09:46:10 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailforward.west.internal (Postfix) with ESMTP id A42641AC0859;
        Thu, 29 Jul 2021 09:39:42 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Thu, 29 Jul 2021 09:39:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=JjfAbX1pq79BhH/GJ
        ozIKahQKClhEXVcaFzB6MBJv38=; b=NNSX6bKm3/DuXkmc+nN6bQYRz3OBLW0ld
        PknxVOFEev5n/ToLoUjxnZoa3VX7vbrlVFNb9/0u1HCnnK6tJdhDoIq+oa/C5VzG
        N4dkyxFC/BAIlVrzHarBtkraDzE4z5D8c+Dq1lYOljpO6ilB1zmIJAuZjIFnnlPA
        iB4u4g6toaOeTQPmu75ZTlNCK3/XopvNkma/kBF0utRT54GF/iuFLvidnG4Pw+30
        /seeOCFITbE4iHBTMqyVMX5xe5gfiRRUqm7EMwUkoxAsEW7hFPV7V66dqdZyvhBD
        i+nJg097f/HhqaPE3+Ah4euBlJnN+jc8k1so5gh3MGIfXFxIjlILg==
X-ME-Sender: <xms:lq8CYWm4d2AFu6eQHqqCQRmi4Qom0z9Bsl_3Hi2UyztjKOeiyCi6PQ>
    <xme:lq8CYd32afmelA8Qgv9gBH3_zhLmhLOeZlb210sJGWhtHL6ZGnGNRlDJiAfcIy2ZV
    IuJNlrjgK_SitRXfkg>
X-ME-Received: <xmr:lq8CYUoCBZdL5X6-4ceeApjXYt1ofprZ7qYHzxm-JqWWfRSB2IzZTeaIddb90ibYsL9uFdl51Z995ZlBIaIzijVzzPUheUENqTqJs8fWkBc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrheefgddviecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefhvffufffkofgggfestdekredtredttdenucfhrhhomhepffgrvhhiugcugfgu
    mhhonhgushhonhcuoegurghvihgurdgvughmohhnughsohhnsehorhgrtghlvgdrtghomh
    eqnecuggftrfgrthhtvghrnhepudfhtedvhffgledttdegleehteevueefgeetvedtudei
    vdegjefhudekgeetheehnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepuggrvhhiugdrvggumhhonhgushhonhesohhrrggtlhgvrdgtohhm
X-ME-Proxy: <xmx:lq8CYanhS1rK7UYHGvCLCpf0BAwp6as0iWFk0EQFlXACOY3B5qD3fA>
    <xmx:lq8CYU2vHHHiJ66ezGoGFuggcpE2oymJ6o-Z36eu7TmKLpgiB0QLMQ>
    <xmx:lq8CYRtumNCr7G6bvpaPV5RmDO5-3F-W4kJpLibhZrPW9hH6-F5T_Q>
    <xmx:nq8CYf9G9v1Gl54NZKGPmKPa7mszxk4PG66PSXQdu2ZL0y44g_l5GMhxhjhalmQU>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 29 Jul 2021 09:39:33 -0400 (EDT)
Received: from localhost (disaster-area.hh.sledj.net [local])
        by disaster-area.hh.sledj.net (OpenSMTPD) with ESMTPA id c4c7ebe7;
        Thu, 29 Jul 2021 13:39:32 +0000 (UTC)
From:   David Edmondson <david.edmondson@oracle.com>
To:     linux-kernel@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@redhat.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        Borislav Petkov <bp@alien8.de>,
        David Matlack <dmatlack@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Edmondson <david.edmondson@oracle.com>
Subject: [PATCH v3 0/3] kvm: x86: Convey the exit reason, etc. to user-space on emulation failure
Date:   Thu, 29 Jul 2021 14:39:28 +0100
Message-Id: <20210729133931.1129696-1-david.edmondson@oracle.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To help when debugging failures in the field, if instruction emulation
fails, report the VM exit reason to userspace in order that it can be
recorded.

Sean: hopefully this is something like what you intended. If not,
please clarify and I will have another go. The lack of an ABI for the
debug data does feel messy.

The SGX changes here are compiled but untested.

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

David Edmondson (3):
  KVM: x86: kvm_x86_ops.get_exit_info should include the exit reason
  KVM: x86: On emulation failure, convey the exit reason, etc. to
    userspace
  KVM: x86: SGX must obey the KVM_INTERNAL_ERROR_EMULATION protocol

 arch/x86/include/asm/kvm_host.h | 12 ++++++--
 arch/x86/kvm/svm/svm.c          |  8 +++--
 arch/x86/kvm/trace.h            | 11 +++----
 arch/x86/kvm/vmx/nested.c       |  2 +-
 arch/x86/kvm/vmx/sgx.c          |  8 ++---
 arch/x86/kvm/vmx/vmx.c          | 11 ++++---
 arch/x86/kvm/x86.c              | 53 ++++++++++++++++++++++++++-------
 include/uapi/linux/kvm.h        |  7 +++++
 8 files changed, 79 insertions(+), 33 deletions(-)

-- 
2.30.2

