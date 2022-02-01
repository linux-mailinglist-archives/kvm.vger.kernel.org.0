Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FC164A5833
	for <lists+kvm@lfdr.de>; Tue,  1 Feb 2022 09:02:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235290AbiBAICT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Feb 2022 03:02:19 -0500
Received: from elvis.franken.de ([193.175.24.41]:50685 "EHLO elvis.franken.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235217AbiBAICS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Feb 2022 03:02:18 -0500
Received: from uucp (helo=alpha)
        by elvis.franken.de with local-bsmtp (Exim 3.36 #1)
        id 1nEo7E-0001iW-00; Tue, 01 Feb 2022 09:02:16 +0100
Received: by alpha.franken.de (Postfix, from userid 1000)
        id 9115BC1F78; Tue,  1 Feb 2022 09:01:41 +0100 (CET)
Date:   Tue, 1 Feb 2022 09:01:41 +0100
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     linux-kernel@vger.kernel.org, kernel test robot <lkp@intel.com>,
        linux-mips@vger.kernel.org, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        James Hogan <jhogan@kernel.org>, kvm@vger.kernel.org
Subject: Re: [PATCH] MIPS: KVM: fix vz.c kernel-doc notation
Message-ID: <20220201080141.GA5886@alpha.franken.de>
References: <20220129205819.23781-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220129205819.23781-1-rdunlap@infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Jan 29, 2022 at 12:58:19PM -0800, Randy Dunlap wrote:
> Fix all kernel-doc warnings in mips/kvm/vz.c as reported by the
> kernel test robot:
> 
>   arch/mips/kvm/vz.c:471: warning: Function parameter or member 'out_compare' not described in '_kvm_vz_save_htimer'
>   arch/mips/kvm/vz.c:471: warning: Function parameter or member 'out_cause' not described in '_kvm_vz_save_htimer'
>   arch/mips/kvm/vz.c:471: warning: Excess function parameter 'compare' description in '_kvm_vz_save_htimer'
>   arch/mips/kvm/vz.c:471: warning: Excess function parameter 'cause' description in '_kvm_vz_save_htimer'
>   arch/mips/kvm/vz.c:1551: warning: No description found for return value of 'kvm_trap_vz_handle_cop_unusable'
>   arch/mips/kvm/vz.c:1552: warning: expecting prototype for kvm_trap_vz_handle_cop_unusuable(). Prototype was for kvm_trap_vz_handle_cop_unusable() instead
>   arch/mips/kvm/vz.c:1597: warning: No description found for return value of 'kvm_trap_vz_handle_msa_disabled'
> 
> Fixes: c992a4f6a9b0 ("KVM: MIPS: Implement VZ support")
> Fixes: f4474d50c7d4 ("KVM: MIPS/VZ: Support hardware guest timer")
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Reported-by: kernel test robot <lkp@intel.com>
> Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
> Cc: linux-mips@vger.kernel.org
> Cc: Huacai Chen <chenhuacai@kernel.org>
> Cc: Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
> Cc: James Hogan <jhogan@kernel.org>
> Cc: kvm@vger.kernel.org
> ---
>  arch/mips/kvm/vz.c |   12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)

applied to mips-fixes.

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
good idea.                                                [ RFC1925, 2.3 ]
