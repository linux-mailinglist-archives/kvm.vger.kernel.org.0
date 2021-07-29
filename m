Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A365A3DA493
	for <lists+kvm@lfdr.de>; Thu, 29 Jul 2021 15:46:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237688AbhG2NqL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jul 2021 09:46:11 -0400
Received: from wforward5-smtp.messagingengine.com ([64.147.123.35]:39811 "EHLO
        wforward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237662AbhG2NqK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 29 Jul 2021 09:46:10 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailforward.west.internal (Postfix) with ESMTP id 17F371AC096B;
        Thu, 29 Jul 2021 09:39:49 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Thu, 29 Jul 2021 09:39:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=0CIbZBRnONYiA447uRDm/13rQXtYkWjFaiYlPSH6c7E=; b=XFImyIq4
        14q9WoyJUNEeP4LiwlypRBHwU9YLh+be/SZ6pKtAnSWpfNpqE3eDNgqkwcR/YJ1O
        dL3fZGmfNxhS83JVu2Cksr3sJNRzKO2yr/BAycAhxQNE4eBUqQ45v4AcsAMOY47L
        drDhr4zgEdKQs3y/xGV/d5SvFk3SsqbjlGfGOxcj4iUmWDb3vLdcMD8xDOYtv3Rr
        EKItpgl2vcRgSIMRg7NQouVb/Q8DOq15A4upAFFdShHdpZTtHOw21O+38SPD0rIq
        YypTrBgbRsPJo7WzU1vTSZ9+O7audLzNFYKcGUu2jeb7y9Ksp/0eWwa/kJreDqWz
        kIgYC1IcV4y7DA==
X-ME-Sender: <xms:pK8CYYrE1GdyeaTTtzCbxZ9zoD7dZ68Z7ElmWoVJQ-jwKIue6A75JA>
    <xme:pK8CYerGWYEgicbZwXXDpKjZoRYxZmq226zEsJGjgOIRRC4OVjA9K7sJcl86f61zh
    n4DYFCyDm-CUDqsbaM>
X-ME-Received: <xmr:pK8CYdNFCP-Yp6453CZf-NzHOEkocYQG37C2Fj6JaD5eHIPFDO-Avc1fLkzrbFUuxlUjBslJNkFI2ptqQqgrOPhvMc-lC9gARqQ2WUiXHRc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrheefgddviecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefhvffufffkofgjfhgggfestdekredtredttdenucfhrhhomhepffgrvhhiugcu
    gfgumhhonhgushhonhcuoegurghvihgurdgvughmohhnughsohhnsehorhgrtghlvgdrtg
    homheqnecuggftrfgrthhtvghrnhepudefteejgfefhfdtjefhhedtffethfetkeehgfel
    heffhfeihfeglefgjedtheeknecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpe
    hmrghilhhfrhhomhepuggrvhhiugdrvggumhhonhgushhonhesohhrrggtlhgvrdgtohhm
X-ME-Proxy: <xmx:pK8CYf64qKLpzQhTSKxBXZX6YTvDXfBl7vX50k9OKaKxmypJcpEiZQ>
    <xmx:pK8CYX68duLmLqswnk1reeS2ekUrk6pDrqA2k7nrReBu5408UK7kWA>
    <xmx:pK8CYfgR9qInI9CGiHsjAOedq9VuV_SRn7sQluBQr4JPRTvXfnKqjg>
    <xmx:pK8CYYTprJ2wb182MMill3hbVBQvo1Kx3Jq9iUHspLw8O_USAJTZLys73RuGKuM2>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 29 Jul 2021 09:39:47 -0400 (EDT)
Received: from localhost (disaster-area.hh.sledj.net [local])
        by disaster-area.hh.sledj.net (OpenSMTPD) with ESMTPA id 8362cc54;
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
Subject: [PATCH v3 3/3] KVM: x86: SGX must obey the KVM_INTERNAL_ERROR_EMULATION protocol
Date:   Thu, 29 Jul 2021 14:39:31 +0100
Message-Id: <20210729133931.1129696-4-david.edmondson@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210729133931.1129696-1-david.edmondson@oracle.com>
References: <20210729133931.1129696-1-david.edmondson@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When passing the failing address and size out to user space, SGX must
ensure not to trample on the earlier fields of the emulation_failure
sub-union of struct kvm_run.

Signed-off-by: David Edmondson <david.edmondson@oracle.com>
---
 arch/x86/kvm/vmx/sgx.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/sgx.c b/arch/x86/kvm/vmx/sgx.c
index 6693ebdc0770..63fb93163383 100644
--- a/arch/x86/kvm/vmx/sgx.c
+++ b/arch/x86/kvm/vmx/sgx.c
@@ -53,11 +53,9 @@ static int sgx_get_encls_gva(struct kvm_vcpu *vcpu, unsigned long offset,
 static void sgx_handle_emulation_failure(struct kvm_vcpu *vcpu, u64 addr,
 					 unsigned int size)
 {
-	vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
-	vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_EMULATION;
-	vcpu->run->internal.ndata = 2;
-	vcpu->run->internal.data[0] = addr;
-	vcpu->run->internal.data[1] = size;
+	uint64_t data[2] = { addr, size };
+
+	kvm_prepare_emulation_failure_exit(vcpu, false, data, sizeof(data));
 }
 
 static int sgx_read_hva(struct kvm_vcpu *vcpu, unsigned long hva, void *data,
-- 
2.30.2

