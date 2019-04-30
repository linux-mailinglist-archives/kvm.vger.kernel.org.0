Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD918F3D4
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2019 12:12:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727259AbfD3KMD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Apr 2019 06:12:03 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:54583 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727228AbfD3KL6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Apr 2019 06:11:58 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 44tcky4fxTz9sDQ; Tue, 30 Apr 2019 20:11:54 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1556619114; bh=fpjkj0j6hbscdjTxGvumSIu33/ScdAAUHI5gHaZF4cs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WgxKKzz0bhhbJs8LA5aoXMHdjLtE3tpifPdGjpbXAwLhQbfkXPH4buR9ptDSHeHUd
         5pCo/4u9uf7IUyjOvJpFh2lPnqRNh5ZxWNHENGj1TEMbly7Ifjiz1E2iE8PczGh4yN
         esJPlHg9avPbpCRStl6zMrNQrJIZjjzrBTEArOWj3gaqz+oZA51DePeXYKt+jLS9OO
         LC8o4yiV14p80IPWl8kRW49OF37JY7CTpFBEYj3lMXvXTyXf6KAIb0EbMu2Y+wYk5l
         awUZJjsz52pyhYX5q6apJYSkhA0MvJAR+GI519xRlQop6ECnL3PArFBiW4QV/l4+1B
         rZo4ueAqHcdaw==
Date:   Tue, 30 Apr 2019 20:08:22 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     kvm@vger.kernel.org
Cc:     kvm-ppc@vger.kernel.org
Subject: Re: [PATCH 1/2] KVM: PPC: Book3S HV: Move HPT guest TLB flushing to
 C code
Message-ID: <20190430100822.GH32205@blackberry>
References: <20190429090040.GA18822@blackberry>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190429090040.GA18822@blackberry>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 29, 2019 at 07:00:40PM +1000, Paul Mackerras wrote:
> This replaces assembler code in book3s_hv_rmhandlers.S that checks
> the kvm->arch.need_tlb_flush cpumask and optionally does a TLB flush
> with C code in book3s_hv_builtin.c.  Note that unlike the radix
> version, the hash version doesn't do an explicit ERAT invalidation
> because we will invalidate and load up the SLB before entering the
> guest, and that will invalidate the ERAT.
> 
> Signed-off-by: Paul Mackerras <paulus@ozlabs.org>

Both patches applied to my kvm-ppc-next tree.

Paul.
