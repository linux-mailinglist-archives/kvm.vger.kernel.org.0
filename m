Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 083F6436211
	for <lists+kvm@lfdr.de>; Thu, 21 Oct 2021 14:47:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230323AbhJUMtv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Oct 2021 08:49:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:43698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230190AbhJUMtu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Oct 2021 08:49:50 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B66760F56;
        Thu, 21 Oct 2021 12:47:34 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1mdXTo-000hRj-AN; Thu, 21 Oct 2021 13:47:32 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Ricardo Koller <ricarkol@google.com>
Cc:     jingzhangos@google.com, maciej.szmigiero@oracle.com,
        reijiw@google.com, oupton@google.com, drjones@redhat.com,
        Paolo Bonzini <pbonzini@redhat.com>, pshier@google.com,
        rananta@google.com
Subject: Re: [PATCH v2 0/2] KVM: selftests: enable the memslot tests in ARM64
Date:   Thu, 21 Oct 2021 13:47:28 +0100
Message-Id: <163482044194.2203130.6587124513364503568.b4-ty@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210907180957.609966-1-ricarkol@google.com>
References: <20210907180957.609966-1-ricarkol@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, ricarkol@google.com, jingzhangos@google.com, maciej.szmigiero@oracle.com, reijiw@google.com, oupton@google.com, drjones@redhat.com, pbonzini@redhat.com, pshier@google.com, rananta@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 7 Sep 2021 11:09:55 -0700, Ricardo Koller wrote:
> Enable memslot_modification_stress_test and memslot_perf_test in ARM64
> (second patch). memslot_modification_stress_test builds and runs in
> aarch64 without any modification. memslot_perf_test needs some nits
> regarding ucalls (first patch).
> 
> Can anybody try these two tests in s390, please?
> 
> [...]

Applied to next, thanks!

[1/2] KVM: selftests: make memslot_perf_test arch independent
      commit: ffb4ce3c49366f02f1c064fbe2e66a96ab5f98b8
[2/2] KVM: selftests: build the memslot tests for arm64
      commit: 358928fd5264f069b9758f8b29297c7bff2a06de

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


