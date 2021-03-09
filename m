Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 550403323A9
	for <lists+kvm@lfdr.de>; Tue,  9 Mar 2021 12:10:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229553AbhCILKJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Mar 2021 06:10:09 -0500
Received: from foss.arm.com ([217.140.110.172]:51428 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229527AbhCILJw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Mar 2021 06:09:52 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9E29D1042;
        Tue,  9 Mar 2021 03:09:51 -0800 (PST)
Received: from [10.57.50.28] (unknown [10.57.50.28])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5ED443F70D;
        Tue,  9 Mar 2021 03:09:50 -0800 (PST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.60.0.2.21\))
Subject: Re: [PATCH] KVM: arm64: Cap default IPA size to the host's own size
From:   Suzuki Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20210308174643.761100-1-maz@kernel.org>
Date:   Tue, 9 Mar 2021 11:09:48 +0000
Cc:     kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
Content-Transfer-Encoding: 7bit
Message-Id: <AB37EA2F-BAF2-4E0C-AD63-201CE480DFB2@arm.com>
References: <20210308174643.761100-1-maz@kernel.org>
To:     Marc Zyngier <maz@kernel.org>
X-Mailer: Apple Mail (2.3654.60.0.2.21)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 8 Mar 2021, at 17:46, Marc Zyngier <maz@kernel.org> wrote:
> 
> KVM/arm64 has forever used a 40bit default IPA space, partially
> due to its 32bit heritage (where the only choice is 40bit).
> 
> However, there are implementations in the wild that have a *cough*
> much smaller *cough* IPA space, which leads to a misprogramming of
> VTCR_EL2, and a guest that is stuck on its first memory access
> if userspace dares to ask for the default IPA setting (which most
> VMMs do).
> 
> Instead, cap the default IPA size to what the host can actually
> do, and spit out a one-off message on the console. The boot warning
> is turned into a more meaningfull message, and the new behaviour
> is also documented.
> 
> Although this is a userspace ABI change, it doesn't really change
> much for userspace:
> 
> - the guest couldn't run before this change, while it now has
>  a chance to if the memory range fits the reduced IPA space
> 
> - a memory slot that was accepted because it did fit the default
>  IPA space but didn't fit the HW constraints is now properly
>  rejected
> 
> The other thing that's left doing is to convince userspace to
> actually use the IPA space setting instead of relying on the
> antiquated default.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>


