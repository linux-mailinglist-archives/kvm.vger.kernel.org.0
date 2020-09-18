Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85B2426FEC7
	for <lists+kvm@lfdr.de>; Fri, 18 Sep 2020 15:38:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726619AbgIRNiA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Sep 2020 09:38:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:42462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726406AbgIRNiA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Sep 2020 09:38:00 -0400
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F6F320795;
        Fri, 18 Sep 2020 13:37:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600436280;
        bh=XngjAAUnERWNiIssoK32pkqFZKZzcZgEAB7yYNwM4jk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eg5/i5BlgYsAk25OvAKp3QMoPQhjz+4/oACfeovvBXJmr7hm/jjLHjhQ/jtVYGnUj
         iT6XA+jIhbgJFwsFRXwZM7xE2nLb3TFqfVKwqPpvpzzfIaufFCpua0ayj/L+KH40h/
         60p5RvmwTysQlLSVpEaQJfxfjWM7ZO8GE+C5Ua5s=
Date:   Fri, 18 Sep 2020 14:37:55 +0100
From:   Will Deacon <will@kernel.org>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org, kernel-team@android.com
Subject: Re: [PATCH v2 0/2] KVM: arm64: Fix handling of S1PTW
Message-ID: <20200918133755.GD31232@willie-the-truck>
References: <20200915104218.1284701-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200915104218.1284701-1-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 15, 2020 at 11:42:16AM +0100, Marc Zyngier wrote:
> I recently managed to trigger an interesting failure mode, where a
> guest would be stuck on an instruction abort due to a permission
> fault. Interestingly enough, this IABT had S1PTW set in the ESR,
> indicating that it was trying to *write* to the PT. We fix it by
> adding the execute permission (it's an IABT, after all...), and going
> nowhere fast.
> 
> Note that it can only happen on a system that can perform automatic
> updates of the page table flags.
> 
> This small series fixes the issue by revamping the S1PTW handling in
> the context of execution faults. The first patch fixes the bug, and is
> definitely a stable candidate. The second patch is merely a cleanup,
> which can wait.
> 
> Tested on an A55-based board.
> 
> * From v1:
>   - Rename kvm_vcpu_dabt_iss1tw() to kvm_vcpu_abt_iss1tw()
>   - Don't overload kvm_vcpu_trap_is_iabt()
>   - Introduce kvm_vcpu_trap_is_exec_fault()

For both patches:

Reviewed-by: Will Deacon <will@kernel.org>

Cheers,

Will
