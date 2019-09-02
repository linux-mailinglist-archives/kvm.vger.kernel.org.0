Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6AEB9A51CD
	for <lists+kvm@lfdr.de>; Mon,  2 Sep 2019 10:35:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730067AbfIBIeI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Sep 2019 04:34:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37396 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729722AbfIBIeH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Sep 2019 04:34:07 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5E2C237E79;
        Mon,  2 Sep 2019 08:34:07 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CC9681000337;
        Mon,  2 Sep 2019 08:34:05 +0000 (UTC)
Date:   Mon, 2 Sep 2019 10:34:03 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH 0/3] arm64: KVM: Kiss hyp_alternate_select() goodbye
Message-ID: <20190902083403.ujiilcurhzrbc4ph@kamzik.brq.redhat.com>
References: <20190901211237.11673-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190901211237.11673-1-maz@kernel.org>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Mon, 02 Sep 2019 08:34:07 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Sep 01, 2019 at 10:12:34PM +0100, Marc Zyngier wrote:
> hyp_alternate_select() is a leftover from the my second attempt at
> supporting VHE (the first one was never merged, thankfully), and is
> now an irrelevant relic. It was a way to patch function pointers
> without having to dereference memory, a bit like static keys for
> function calls.
> 
> Lovely idea, but since Christoffer mostly separated the VHE and !VHE
> hypervisor paths, most of the uses of hyp_alternate_select() are
> gone. What is left is two instances that are better replaced by
> already existing static keys. One of the instances becomes
> cpus_have_const_cap(), and the rest is a light sprinkling of
> has_vhe().
> 
> So off it goes.
> 
> Marc Zyngier (3):
>   arm64: KVM: Drop hyp_alternate_select for checking for
>     ARM64_WORKAROUND_834220
>   arm64: KVM: Replace hyp_alternate_select with has_vhe()
>   arm64: KVM: Kill hyp_alternate_select()
> 
>  arch/arm64/include/asm/kvm_hyp.h | 24 ---------------------
>  arch/arm64/kvm/hyp/switch.c      | 17 ++-------------
>  arch/arm64/kvm/hyp/tlb.c         | 36 +++++++++++++++++++-------------
>  3 files changed, 24 insertions(+), 53 deletions(-)
> 
> -- 
> 2.20.1
>

Yay! The 'func()(...)' stuff always gave me cross-eyes.

Reviewed-by: Andrew Jones <drjones@redhat.com>
