Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1172F22A8DD
	for <lists+kvm@lfdr.de>; Thu, 23 Jul 2020 08:21:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727052AbgGWGVX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jul 2020 02:21:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726390AbgGWGVW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jul 2020 02:21:22 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70FDDC0619DC;
        Wed, 22 Jul 2020 23:21:22 -0700 (PDT)
Received: by ozlabs.org (Postfix, from userid 1003)
        id 4BC2KB3wqzz9sRf; Thu, 23 Jul 2020 16:21:18 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1595485278; bh=odF+torp6O5+9CyXhkwTTM6NVHZyqHYWRUU9Y7X2ibs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mxcHUvB17Jv0PuLCtPPCCEstr+aT1ErnByOEHg9mCCOjpZ3XCqDZ2aqHskXu1U17s
         1J/JBy9nM5hKvwlMgGyJM5iD3WOAj3X32zauNKlXC7CPbSf7NsGYwfzeWnl8Ly7fRF
         YgQp4txyASY1BRh0JS4UZ6aaTQkaf7pmJ5LzT1EoD+8qq8CQ0z1oRWuvjVGRQxszpv
         VtexzBIrAFvcptPeV9KF+SlXvpbg8bnc/wrTVoshZn+QB7LyWHwixMRbjmzvvM/N3v
         +AnnvBgBSu2wf9uBliqvVWeLfS++sa/9iEQtGRMtKaD7/AYfmFY+DevDOE+a3++8EG
         3mXxDYfHW/TaQ==
Date:   Thu, 23 Jul 2020 16:20:16 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     =?iso-8859-1?Q?C=E9dric?= Le Goater <clg@kaod.org>
Cc:     Michael Ellerman <mpe@ellerman.id.au>, kvm@vger.kernel.org,
        Nicholas Piggin <npiggin@gmail.com>, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH] KVM: PPC: Book3S HV: increase KVMPPC_NR_LPIDS on POWER8
 and POWER9
Message-ID: <20200723062016.GE213782@thinks.paulus.ozlabs.org>
References: <20200608115714.1139735-1-clg@kaod.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200608115714.1139735-1-clg@kaod.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 08, 2020 at 01:57:14PM +0200, Cédric Le Goater wrote:
> POWER8 and POWER9 have 12-bit LPIDs. Change LPID_RSVD to support up to
> (4096 - 2) guests on these processors. POWER7 is kept the same with a
> limitation of (1024 - 2), but it might be time to drop KVM support for
> POWER7.
> 
> Tested with 2048 guests * 4 vCPUs on a witherspoon system with 512G
> RAM and a bit of swap.
> 
> Signed-off-by: Cédric Le Goater <clg@kaod.org>

Thanks, patch applied to my kvm-ppc-next branch.

Paul.
