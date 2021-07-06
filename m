Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BF8C3BC92F
	for <lists+kvm@lfdr.de>; Tue,  6 Jul 2021 12:12:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231368AbhGFKPF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jul 2021 06:15:05 -0400
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:57703 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231354AbhGFKPE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Jul 2021 06:15:04 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 878581940671;
        Tue,  6 Jul 2021 06:12:25 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Tue, 06 Jul 2021 06:12:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=Iot6iTHoRwguuwO1T
        5bvar0xmQaQxY5IuWYCD5WGT0I=; b=J/KICNYqNtmx4ETG3cnWxJGfVrrw5O14/
        vY0/uydc9UY6r6RdPQRMddlAMZcm8n6vp0hZnO07zgJveYK+3PI2/vBnanbEyoJt
        bngYutCMPfpj628AzvW7DRwnYUGyBfC5dSpG5HkO6mYW9AJTJwCgYQn+Q81wn5Xk
        NlSP5r2iR02ZSLhGtf6ipKFA8rvRJxeq3OLQ2mfBtDiDy46M4RgXk9t5henwk4Vx
        m9MlGMNuLMx7dDDRHmALy6lkE6CYTxKzLu5X1S0cSo7TacFQuRwuUjyJL7dL3qXT
        G3ocqqC7JDD1McCTXyxkSEQJKMov+q/eCWRepo/0PL3B7UdNIclYA==
X-ME-Sender: <xms:eizkYOxaEuEF-ZdLyL6nvMgM840Q1PZ7EH0b4SDn23PazaNERoIkjw>
    <xme:eizkYKTaBhSVUnCEcyjf4M9vu6Cks6SrxA1WiUg-jJ-KltRgQ45mkGGaPvFkxuF-_
    qLjtNMvTnWwp6Hlflk>
X-ME-Received: <xmr:eizkYAXI6m2AQESn-vkjIblYH--OMWuEzNh_td03WBPq8cb2LxYgzUXUiugYaxrCoi9PtoR9gup6rb8RNGAzSjvAprxlk6_k2Me2u4e5xio>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeejiedgvddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkffoggfgsedtkeertdertddtnecuhfhrohhmpeffrghvihguucfg
    ughmohhnughsohhnuceouggrvhhiugdrvggumhhonhgushhonhesohhrrggtlhgvrdgtoh
    hmqeenucggtffrrghtthgvrhhnpeduhfetvdfhgfeltddtgeelheetveeufeegteevtddu
    iedvgeejhfdukeegteehheenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpegurghvihgurdgvughmohhnughsohhnsehorhgrtghlvgdrtghomh
X-ME-Proxy: <xmx:eizkYEgUK7yhr9gRB5D85AkkLES16bWTW1PmGrwg-NPfn2fp2i_Wlg>
    <xmx:eizkYAAXNDFRha_VpNm6IpsrudDtNn0hMlVTI9wiD60AKGrDebSIqQ>
    <xmx:eizkYFJnvnSK0J0zZh8sRyNQtGviyp3q1wX1U_exaUc-IJXpbN5fkw>
    <xmx:iSzkYC4hHWyzDUZRxkyGv4inUAcM16qdMjGE-jKk70HUpYb8oeLBhL1B6fc>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 6 Jul 2021 06:12:08 -0400 (EDT)
Received: from localhost (disaster-area.hh.sledj.net [local])
        by disaster-area.hh.sledj.net (OpenSMTPD) with ESMTPA id 8d70566b;
        Tue, 6 Jul 2021 10:12:07 +0000 (UTC)
From:   David Edmondson <david.edmondson@oracle.com>
To:     linux-kernel@vger.kernel.org
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Borislav Petkov <bp@alien8.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        David Edmondson <david.edmondson@oracle.com>
Subject: [PATCH v2 0/2] kvm: x86: Convey the exit reason to user-space on emulation failure
Date:   Tue,  6 Jul 2021 11:12:05 +0100
Message-Id: <20210706101207.2993686-1-david.edmondson@oracle.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To help when debugging failures in the field, if instruction emulation
fails, report the VM exit reason to userspace in order that it can be
recorded.

I'm unsure whether sgx_handle_emulation_failure() needs to be adapted
to use the emulation_failure part of the exit union in struct kvm_run
- advice welcomed.

v2:
- Improve patch comments (dmatlack)
- Intel should provide the full exit reason (dmatlack)
- Pass a boolean rather than flags (dmatlack)
- Use the helper in kvm_task_switch() and kvm_handle_memory_failure()
  (dmatlack)
- Describe the exit_reason field of the emulation_failure structure
  (dmatlack)

David Edmondson (2):
  KVM: x86: Add kvm_x86_ops.get_exit_reason
  KVM: x86: On emulation failure, convey the exit reason to userspace

 arch/x86/include/asm/kvm-x86-ops.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  3 +++
 arch/x86/kvm/svm/svm.c             |  6 ++++++
 arch/x86/kvm/vmx/vmx.c             | 11 +++++++----
 arch/x86/kvm/x86.c                 | 22 +++++++++++++---------
 include/uapi/linux/kvm.h           |  7 +++++++
 6 files changed, 37 insertions(+), 13 deletions(-)

-- 
2.30.2

