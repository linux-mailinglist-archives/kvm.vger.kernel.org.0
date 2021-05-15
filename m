Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98B9F381B80
	for <lists+kvm@lfdr.de>; Sun, 16 May 2021 00:46:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230469AbhEOWrH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 15 May 2021 18:47:07 -0400
Received: from ozlabs.org ([203.11.71.1]:57599 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230050AbhEOWrB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 15 May 2021 18:47:01 -0400
Received: by ozlabs.org (Postfix, from userid 1034)
        id 4FjL8V5C2tz9sjB; Sun, 16 May 2021 08:45:46 +1000 (AEST)
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
To:     Michael Ellerman <mpe@ellerman.id.au>,
        linuxppc-dev@lists.ozlabs.org
Cc:     kvm@vger.kernel.org, npiggin@gmail.com, kvm-ppc@vger.kernel.org,
        pbonzini@redhat.com, seanjc@google.com
In-Reply-To: <20210511105459.800788-1-mpe@ellerman.id.au>
References: <20210511105459.800788-1-mpe@ellerman.id.au>
Subject: Re: [PATCH] KVM: PPC: Book3S HV: Fix kvm_unmap_gfn_range_hv() for Hash MMU
Message-Id: <162111863429.1890426.10684298398002879085.b4-ty@ellerman.id.au>
Date:   Sun, 16 May 2021 08:43:54 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 11 May 2021 20:54:59 +1000, Michael Ellerman wrote:
> Commit 32b48bf8514c ("KVM: PPC: Book3S HV: Fix conversion to gfn-based
> MMU notifier callbacks") fixed kvm_unmap_gfn_range_hv() by adding a for
> loop over each gfn in the range.
> 
> But for the Hash MMU it repeatedly calls kvm_unmap_rmapp() with the
> first gfn of the range, rather than iterating through the range.
> 
> [...]

Applied to powerpc/fixes.

[1/1] KVM: PPC: Book3S HV: Fix kvm_unmap_gfn_range_hv() for Hash MMU
      https://git.kernel.org/powerpc/c/da3bb206c9ceb0736d9e2897ea697acabad35833

cheers
