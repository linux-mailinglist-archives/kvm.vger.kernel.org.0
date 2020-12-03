Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 368D02CDE6B
	for <lists+kvm@lfdr.de>; Thu,  3 Dec 2020 20:06:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729481AbgLCTEP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Dec 2020 14:04:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:35684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728118AbgLCTEP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Dec 2020 14:04:15 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 90D5E208A9;
        Thu,  3 Dec 2020 19:03:34 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=wait-a-minute.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1kktt5-00FlRA-Bp; Thu, 03 Dec 2020 19:03:31 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, Keqian Zhu <zhukeqian1@huawei.com>,
        kvmarm@lists.cs.columbia.edu
Cc:     Will Deacon <will@kernel.org>, Andrew Jones <drjones@redhat.com>,
        James Morse <james.morse@arm.com>,
        Steven Price <steven.price@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        wanghaibin.wang@huawei.com,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v2 0/2] KVM: arm64: Some fixes and code adjustments for pvtime ST
Date:   Thu,  3 Dec 2020 19:03:28 +0000
Message-Id: <160702219014.403179.5103308104909161941.b4-ty@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20200817110728.12196-1-zhukeqian1@huawei.com>
References: <20200817110728.12196-1-zhukeqian1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, zhukeqian1@huawei.com, kvmarm@lists.cs.columbia.edu, will@kernel.org, drjones@redhat.com, james.morse@arm.com, steven.price@arm.com, suzuki.poulose@arm.com, wanghaibin.wang@huawei.com, catalin.marinas@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 17 Aug 2020 19:07:26 +0800, Keqian Zhu wrote:
> During picking up pvtime LPT support for arm64, I do some trivial fixes for
> pvtime ST.
> 
> change log:
> 
> v2:
>  - Add Andrew's and Steven's R-b.
>  - Correct commit message of the first patch.
>  - Drop the second patch.
> 
> [...]

Applied to kvm-arm64/misc-5.11, thanks!

[1/2] KVM: arm64: Some fixes of PV-time interface document
      commit: 94558543213ae8c83be5d01b83c1fe7530e8a1a0
[2/2] KVM: arm64: Use kvm_write_guest_lock when init stolen time
      commit: 652d0b701d136ede6bc8a977b3abbe2d420226b9

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


