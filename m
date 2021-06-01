Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB231397076
	for <lists+kvm@lfdr.de>; Tue,  1 Jun 2021 11:35:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233299AbhFAJgq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Jun 2021 05:36:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:49546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233218AbhFAJgp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Jun 2021 05:36:45 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A78A60FE5;
        Tue,  1 Jun 2021 09:35:04 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=hot-poop.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1lo0ne-004mgj-HR; Tue, 01 Jun 2021 10:35:02 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Ricardo Koller <ricarkol@google.com>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, drjones@redhat.com, alexandru.elisei@arm.com,
        eric.auger@redhat.com
Subject: Re: [PATCH v3 0/5] KVM: selftests: arm64 exception handling and debug test
Date:   Tue,  1 Jun 2021 10:34:57 +0100
Message-Id: <162254008305.3715765.2263457388442707736.b4-ty@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210513002802.3671838-1-ricarkol@google.com>
References: <20210513002802.3671838-1-ricarkol@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: ricarkol@google.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com, alexandru.elisei@arm.com, eric.auger@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 12 May 2021 17:27:57 -0700, Ricardo Koller wrote:
> These patches add a debug exception test in aarch64 KVM selftests while
> also adding basic exception handling support.
> 
> The structure of the exception handling is based on its x86 counterpart.
> Tests use the same calls to initialize exception handling and both
> architectures allow tests to override the handler for a particular
> vector, or (vector, ec) for synchronous exceptions in the arm64 case.
> 
> [...]

Applied to next, thanks!

[1/5] KVM: selftests: Rename vm_handle_exception
      commit: a2bad6a990a4a7493cf5cae2f91e6b8643d2ed84
[2/5] KVM: selftests: Introduce UCALL_UNHANDLED for unhandled vector reporting
      commit: 8c4680c968180739e3facd9a65e8f7939a3bdc6d
[3/5] KVM: selftests: Move GUEST_ASSERT_EQ to utils header
      commit: 124d7bb43462d1b4eaee2463fcbc7e9e41cac20f
[4/5] KVM: selftests: Add exception handling support for aarch64
      commit: cc968fa1dd8212557c588f348d37d907008117e8
[5/5] KVM: selftests: Add aarch64/debug-exceptions test
      commit: 9c066f39c5fb96bad7533de7e96a85040c7a00a0

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


