Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99E39E6FAC
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2019 11:32:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388264AbfJ1KcV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Oct 2019 06:32:21 -0400
Received: from foss.arm.com ([217.140.110.172]:38278 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388238AbfJ1KcV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Oct 2019 06:32:21 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C568F1F1;
        Mon, 28 Oct 2019 03:32:20 -0700 (PDT)
Received: from arrakis.emea.arm.com (arrakis.cambridge.arm.com [10.1.197.42])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8A0AC3F71E;
        Mon, 28 Oct 2019 03:32:19 -0700 (PDT)
Date:   Mon, 28 Oct 2019 10:32:17 +0000
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     James Morse <james.morse@arm.com>, Will Deacon <will@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>
Subject: Re: [PATCH v2 4/5] arm64: KVM: Prevent speculative S1 PTW when
 restoring vcpu context
Message-ID: <20191028103217.GB16739@arrakis.emea.arm.com>
References: <20191019095521.31722-1-maz@kernel.org>
 <20191019095521.31722-5-maz@kernel.org>
 <151fc868-6709-3017-e34d-649ec0e1812c@arm.com>
 <8636ffzu30.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8636ffzu30.wl-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Oct 26, 2019 at 11:20:35AM +0100, Marc Zyngier wrote:
> Catalin, Will: given that this series conflicts with the workaround for
> erratum 1542419, do you mind taking it via the arm64 tree?

I assume you target 5.5 with this workaround.

I don't mind merging it but if you want to queue it, we already have a
stable for-next/neoverse-n1-stale-instr branch with 1542419 (I'll push a
fixup on top soon for a clang warning). The other issue is that we get a
conflict with mainline due to the tx2 erratum. If it gets too
complicated, I'll also merge for-next/fixes into for-next/core.

-- 
Catalin
