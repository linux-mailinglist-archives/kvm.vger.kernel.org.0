Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 838613DD75D
	for <lists+kvm@lfdr.de>; Mon,  2 Aug 2021 15:40:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234040AbhHBNkI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Aug 2021 09:40:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:52322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233973AbhHBNkG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Aug 2021 09:40:06 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CE75C60FC1;
        Mon,  2 Aug 2021 13:39:56 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1mAYAc-002Sjn-RR; Mon, 02 Aug 2021 14:39:54 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        linux-mm@kvack.org, kvmarm@lists.cs.columbia.edu,
        Marc Zyngier <maz@kernel.org>
Cc:     Suzuki K Poulose <suzuki.poulose@arm.com>, kernel-team@android.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Quentin Perret <qperret@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        James Morse <james.morse@arm.com>,
        Will Deacon <will@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v2 0/6] KVM: Remove kvm_is_transparent_hugepage() and friends
Date:   Mon,  2 Aug 2021 14:39:51 +0100
Message-Id: <162791157466.3441503.3535158079584793741.b4-ty@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210726153552.1535838-1-maz@kernel.org>
References: <20210726153552.1535838-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, linux-mm@kvack.org, kvmarm@lists.cs.columbia.edu, maz@kernel.org, suzuki.poulose@arm.com, kernel-team@android.com, pbonzini@redhat.com, qperret@google.com, alexandru.elisei@arm.com, james.morse@arm.com, will@kernel.org, seanjc@google.com, willy@infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 26 Jul 2021 16:35:46 +0100, Marc Zyngier wrote:
> A while ago, Willy and Sean pointed out[0] that arm64 is the last user
> of kvm_is_transparent_hugepage(), and that there would actually be
> some benefit in looking at the userspace mapping directly instead.
> 
> This small series does exactly that, although it doesn't try to
> support more than a PMD-sized mapping yet for THPs. We could probably
> look into unifying this with the huge PUD code, and there is still
> some potential use of the contiguous hint.
> 
> [...]

Applied to next, thanks!

[1/6] KVM: arm64: Introduce helper to retrieve a PTE and its level
      commit: 63db506e07622c344a3c748a1c06293d48780f83
[2/6] KVM: arm64: Walk userspace page tables to compute the THP mapping size
      commit: 6011cf68c88545e16cb32039c2cecfdae6a32315
[3/6] KVM: arm64: Avoid mapping size adjustment on permission fault
      commit: f2cc327303b13a70311e823bd52aa0bca8c7ddbc
[4/6] KVM: Remove kvm_is_transparent_hugepage() and PageTransCompoundMap()
      commit: 205d76ff0684a0b4fe3ff3a283d143a47439d191
[5/6] KVM: arm64: Use get_page() instead of kvm_get_pfn()
      commit: 0fe49630101b3ce23bd21a2788440ac719ec868a
[6/6] KVM: Get rid of kvm_get_pfn()
      commit: 36c3ce6c0d03a6c9992c3359f879cdc70fde836a

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


