Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25E993EB124
	for <lists+kvm@lfdr.de>; Fri, 13 Aug 2021 09:12:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239284AbhHMHMu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Aug 2021 03:12:50 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:44005 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239262AbhHMHMr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 13 Aug 2021 03:12:47 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailforward.nyi.internal (Postfix) with ESMTP id BCCC2194084B;
        Fri, 13 Aug 2021 03:12:19 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Fri, 13 Aug 2021 03:12:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=RbMnv4xLzFK3cGlV7gRVytCFaeSSy0i9w4B4VQKbuGo=; b=i2Nhshx1
        YyuBZUIqZTtqty0SzN8RhyotAFSA4vUoT0goeLq/D7gepI1BLKbGPeTCToZWOU7o
        rDnF9+N5P75fXlS8Sb2bo4/NEr0nDPSXTcwSE9mfj/iPcA+hUQkTJAcK0imJeVzJ
        arIXgU+czuMgvY/Gid/PXYQJaNnc7A67q4sdXXaaj1B62XoiMXHb5set4kYoFbVa
        e7Y+kptdYOSDducLXqcN2BMhsk2thDWY9lFa9e8Hka5K+GDT8Rxj+EZSEsVu5JJF
        NM143KDg0oTNLbbiT0/HeMOZUIDt+PBOfEx8na1VWNe/75ltYF0EvHgdfM9tzJr+
        GzEvqWpsP3t1wg==
X-ME-Sender: <xms:URsWYdins-tt2BcJvgbjZVe3N7vM8m3pSMr9NJSB6uVrj3s1kujamg>
    <xme:URsWYSCjYBdJUKCrAgJ_0lmRLvNx7Pe_4kpkWI_uccpKGDNGt5IRZ-9EVKHG0xIUm
    odOtw0CFdsfPss0W44>
X-ME-Received: <xmr:URsWYdGMlN-F_rftryFYVpk3iyCC9XSzCMoXzTGXPjr5W3mY0RlJhyudrcvGsYhW7PSECe9r0i6P33TgB3MNhzYVLCGgPeJYnEglF6GLP78>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrkeeggdduudejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeffrghvihgu
    ucfgughmohhnughsohhnuceouggrvhhiugdrvggumhhonhgushhonhesohhrrggtlhgvrd
    gtohhmqeenucggtffrrghtthgvrhhnpedufeetjefgfefhtdejhfehtdfftefhteekhefg
    leehfffhiefhgeelgfejtdehkeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpegurghvihgurdgvughmohhnughsohhnsehorhgrtghlvgdrtgho
    mh
X-ME-Proxy: <xmx:URsWYSQnU_xKgtQWoEiMl8FrKZM6R0yeM7n-yz_sb4BmKaV8kSP9SA>
    <xmx:URsWYazGBa7Ni1dgU0XNGwfSxQs0XM5l_hNVG2iItO1heGz57h7tDA>
    <xmx:URsWYY67ahik9nkjbaTWMt-kvZe6f6vB6VRQgkt5o1ovzuWU_uFjGQ>
    <xmx:UxsWYUq8OsT2j2wjHNKB7KJP6bu4FqTGCQa5osGLrkYb6_W1uQYFiUaz3jA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 13 Aug 2021 03:12:15 -0400 (EDT)
Received: from localhost (disaster-area.hh.sledj.net [local])
        by disaster-area.hh.sledj.net (OpenSMTPD) with ESMTPA id 418eb6c0;
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
Subject: [PATCH v4 1/4] KVM: x86: Clarify the kvm_run.emulation_failure structure layout
Date:   Fri, 13 Aug 2021 08:12:08 +0100
Message-Id: <20210813071211.1635310-2-david.edmondson@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210813071211.1635310-1-david.edmondson@oracle.com>
References: <20210813071211.1635310-1-david.edmondson@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Until more flags for kvm_run.emulation_failure flags are defined, it
is undetermined whether new payload elements corresponding to those
flags will be additive or alternative. As a hint to userspace that an
alternative is possible, wrap the current payload elements in a union.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: David Edmondson <david.edmondson@oracle.com>
---
 include/uapi/linux/kvm.h | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index d9e4aabcb31a..6c79c1ce3703 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -402,8 +402,12 @@ struct kvm_run {
 			__u32 suberror;
 			__u32 ndata;
 			__u64 flags;
-			__u8  insn_size;
-			__u8  insn_bytes[15];
+			union {
+				struct {
+					__u8  insn_size;
+					__u8  insn_bytes[15];
+				};
+			};
 		} emulation_failure;
 		/* KVM_EXIT_OSI */
 		struct {
-- 
2.30.2

