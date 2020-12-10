Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D94FE2D5C74
	for <lists+kvm@lfdr.de>; Thu, 10 Dec 2020 14:55:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389687AbgLJNyi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Dec 2020 08:54:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:50020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389681AbgLJNy1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Dec 2020 08:54:27 -0500
Date:   Thu, 10 Dec 2020 13:53:41 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607608427;
        bh=NjrQ4FJF5266Z90UJ72u1Wg6hCMf64J2BYn3ruDlCmM=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=OEPHAVOhWkIGpVAHib6eInZKs+4RcuFzg6tl2dG3haMd7QNgF9yOHoMF7ye0hqlQ9
         omcJKaLkBYMJASEvcgVM0BV6YOzfh7esaPQiE6sILqzQSK/g44y8XrjQHwpfCXYrmH
         EuEU34T3U6N4Ww+DQ4Se5XmyU+DcdKaLZT9ebxOdI+oc+YAX6h5NXLfeR12zrU+roq
         qdVBWzVj9hyBfCa4ChpHMVk/R6OnHepOX5D3r9iGoySk/z4RpRwRxAefIrJMMCT3fc
         /6EnxEqfvpMpArhXZg6MGSo/acLDk5cDdE6kMPyW9rhg5cN7lhMxV+XIQLS5ZjlqCo
         iOKArx0T+z5JQ==
From:   Will Deacon <will@kernel.org>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        David Brazdil <dbarzdil@google.com>, kernel-team@android.com
Subject: Re: [PATCH v2 0/2] KVM: arm64: Expose CSV3 to guests on running on
 Meltdown-safe HW
Message-ID: <20201210135341.GA10255@willie-the-truck>
References: <20201204183709.784533-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201204183709.784533-1-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 04, 2020 at 06:37:07PM +0000, Marc Zyngier wrote:
> Will recently pointed out that when running on big-little systems that
> are known not to be vulnerable to Metldown, guests are not presented
> with the CSV3 property if the physical HW include a core that doesn't
> have CSV3, despite being known to be safe (it is on the kpti_safe_list).
> 
> Since this is valuable information that can be cheaply given to the
> guest, let's just do that. The scheme is the same as what we do for
> CSV2, allowing userspace to change the default setting if this doesn't
> advertise a safer setting than what the kernel thinks it is.
> 
> * From v1:
>   - Fix the clearing of ID_AA64PFR0_EL1.CSV3 on update from userspace
>   - Actually store the userspace value
> 
> Marc Zyngier (2):
>   arm64: Make the Meltdown mitigation state available
>   KVM: arm64: Advertise ID_AA64PFR0_EL1.CSV3=1 if the CPUs are
>     Meltdown-safe

Acked-by: Will Deacon <will@kernel.org>

Will
