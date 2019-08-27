Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 017FD9DAA4
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2019 02:32:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727926AbfH0Ac2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Aug 2019 20:32:28 -0400
Received: from ozlabs.org ([203.11.71.1]:51715 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726944AbfH0Ac2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Aug 2019 20:32:28 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 46HVFP6JL1z9sDB; Tue, 27 Aug 2019 10:32:25 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1566865945; bh=n0WxmvwSK65oIhBS+QjYk4vyDjy+iy/5wXOF3pY69BE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tySe8v7xb2A12sBylV8i+NhlV0mc10CpEDBz0n7H/JCr3kE9j08T0vStfZB5ufA7l
         TH/4ypJDcenroG30bKoL/y8GWQa8dt1j6LtPQB+my1R880OLAdipZCryf7aF3Ms4qE
         T3jVD07yBHleSv2v8cQk31filyT+jRNKK81E8o1427a71xtyoJHzO/WVNX5JJ0Ix66
         nrKpJi4mX/IvmFI/Ix48hY43BIQ6aHzAhQwkxfemOKLCG9l3OeuQtHwomOZCJxTf7v
         TqyoFpRYKQWORL21E2Cz5r8He3OvZ7sy0dS7qk0X2zchu8UyBOFwj2T9nlHaqouE0C
         0ynQ2eD0KPNvQ==
Date:   Tue, 27 Aug 2019 10:32:20 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Alexey Kardashevskiy <aik@ozlabs.ru>
Cc:     linuxppc-dev@lists.ozlabs.org,
        David Gibson <david@gibson.dropbear.id.au>,
        kvm-ppc@vger.kernel.org, kvm@vger.kernel.org,
        Alistair Popple <alistair@popple.id.au>,
        Alex Williamson <alex.williamson@redhat.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH kernel v2 2/4] KVM: PPC: Invalidate multiple TCEs at once
Message-ID: <20190827003220.GA16075@blackberry>
References: <20190826061705.92048-1-aik@ozlabs.ru>
 <20190826061705.92048-3-aik@ozlabs.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190826061705.92048-3-aik@ozlabs.ru>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 26, 2019 at 04:17:03PM +1000, Alexey Kardashevskiy wrote:
> Invalidating a TCE cache entry for each updated TCE is quite expensive.
> This makes use of the new iommu_table_ops::xchg_no_kill()/tce_kill()
> callbacks to bring down the time spent in mapping a huge guest DMA window;
> roughly 20s to 10s for each guest's 100GB of DMA space.
> 
> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>

With the addition of "Book3S" to the patch title,

Acked-by: Paul Mackerras <paulus@ozlabs.org>
