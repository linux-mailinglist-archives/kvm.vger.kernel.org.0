Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 498B33A5E19
	for <lists+kvm@lfdr.de>; Mon, 14 Jun 2021 10:09:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232611AbhFNILM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Jun 2021 04:11:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:38056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232528AbhFNILK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Jun 2021 04:11:10 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 825F26138C;
        Mon, 14 Jun 2021 08:09:08 +0000 (UTC)
Received: from [185.219.108.64] (helo=hot-poop.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1lsheX-007NgD-Go; Mon, 14 Jun 2021 09:09:01 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Ricardo Koller <ricarkol@google.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Cc:     vkuznets@redhat.com, pbonzini@redhat.com, alexandru.elisei@arm.com,
        eric.auger@redhat.com, drjones@redhat.com, yuzenghui@huawei.com
Subject: Re: [PATCH v4 0/6] KVM: selftests: arm64 exception handling and debug test
Date:   Mon, 14 Jun 2021 09:08:57 +0100
Message-Id: <162365813003.2322930.1320580916892571900.b4-ty@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210611011020.3420067-1-ricarkol@google.com>
References: <20210611011020.3420067-1-ricarkol@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: ricarkol@google.com, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, vkuznets@redhat.com, pbonzini@redhat.com, alexandru.elisei@arm.com, eric.auger@redhat.com, drjones@redhat.com, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 10 Jun 2021 18:10:14 -0700, Ricardo Koller wrote:
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

[1/6] KVM: selftests: Rename vm_handle_exception
      commit: b78f4a596692f6805e796a4c13f2d921b8a95166
[2/6] KVM: selftests: Complete x86_64/sync_regs_test ucall
      commit: b7326c01122683b88e273a0cc826cd4c01234470
[3/6] KVM: selftests: Introduce UCALL_UNHANDLED for unhandled vector reporting
      commit: 75275d7fbef47805b77e8af81a4d51e2d92db70f
[4/6] KVM: selftests: Move GUEST_ASSERT_EQ to utils header
      commit: 67f709f52bf0b5c19f24d1234163123cbb6af545
[5/6] KVM: selftests: Add exception handling support for aarch64
      commit: e3db7579ef355a0b2bfef4448b84d9ac882c8f2c
[6/6] KVM: selftests: Add aarch64/debug-exceptions test
      commit: 4f05223acaeaabe0a1a188e25fab334735d85c5e

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


