Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0FD172C21C
	for <lists+kvm@lfdr.de>; Mon, 12 Jun 2023 13:02:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237500AbjFLLC4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jun 2023 07:02:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237573AbjFLLC2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jun 2023 07:02:28 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A24C45FCB;
        Mon, 12 Jun 2023 03:49:54 -0700 (PDT)
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id C2A291EC064A;
        Mon, 12 Jun 2023 12:49:52 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1686566992;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=HNvNkDQEJ4NeFu80fh8zSTZwGO0VQ8+2hvqiV1HA19E=;
        b=ECTZefKK401QeBWbC2TMZGv1HwZo6E/eF6Xf8qNHTCiodkyfOIAgHrznnvJfF4yDLLDbfR
        uXqar2YSbZ3mBBO6eY0bPQFgPpAx5RVLUAsgD5qb0TR/nZlft64jdSauyTfRGw/kkZjlkO
        qIT1tCwwAJ9hbkLilT4cwLex4Idpb1E=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
        t=1686566991; bh=HNvNkDQEJ4NeFu80fh8zSTZwGO0VQ8+2hvqiV1HA19E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fzHKlyoDn2jIjrFPn3fXdIOHGew1ihpJ24xw/CcJG3TkZy17Yg3oiu1bnMbVq84UW
         iNgouJVqXUIlprpLNT6jEYqwuCdIR4UyBqN0LLeppXZ6Zxnf/1zACTaax6OG6HN9O2
         SOE2iUm4kVIsIWVAczbvD2b+xCOwZVkRo6KUyMxDLpXHsntacFHeddLoi5YIQ/XDLs
         lej+epOiS2/P6jDOdqpPgXhgQXBnG+ufX6pIjXgBsksfc0NJNmcQHl9YYln/2cU41g
         BwAiPcgtmQmzsCKNNWrhLfI+dBIbWHN+bDNFEfTBC6xTLSbAI9b2Cdiggf9B1ORMWL
         WjTHJQvMY5uFZKSwRvPshA4OqL2czb3UjBcE9IaoQJUll3BgtWGF8D8Ix6+9qEVZQj
         xAR1Mr8SRBHTUk4+Jn8/VYxtmea7lne8vuliylnzJa2ix4PRv3555QkY4Hvs+LLTjy
         3DoXoLVlqLVpANXROF0gAKgiqwfA9ogDG+BlQKffdEePFS5jp6nvtK+Srd3JAllsfS
         EY8ZUaaDvnGrDN96o+2/qkjV80LcPe+uPdEknjnOeIF08vAiQJNKvstI9NTfFuAZwV
         oi00rtkB+AXh/hoxZHwCf+p5d0ljHivaOc1IxQkNzAaerWb25Vebzd0C9E+NzEMbGn
         n7bRmxX/yzDrVN55Z4Y0J6bU=
Received: from zn.tnic (p200300EA971DC508329c23FFfEa6A903.dip0.t-ipconnect.de [IPv6:2003:ea:971d:c508:329c:23ff:fea6:a903])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
        (No client certificate requested)
        by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id F1CD040E01E2;
        Mon, 12 Jun 2023 10:49:11 +0000 (UTC)
Date:   Mon, 12 Jun 2023 12:49:05 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Michael Roth <michael.roth@amd.com>
Cc:     kvm@vger.kernel.org, linux-coco@lists.linux.dev,
        linux-mm@kvack.org, linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
        dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
        peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
        rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com,
        vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com,
        tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org, ashish.kalra@amd.com,
        nikunj.dadhania@amd.com, liam.merwick@oracle.com,
        zhi.a.wang@intel.com
Subject: Re: [PATCH RFC v9 02/51] KVM: x86: Add gmem hook for invalidating
 private memory
Message-ID: <20230612104905.GOZIb4ISN9gj9lWYNv@fat_crate.local>
References: <20230612042559.375660-1-michael.roth@amd.com>
 <20230612042559.375660-3-michael.roth@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230612042559.375660-3-michael.roth@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Jun 11, 2023 at 11:25:10PM -0500, Michael Roth wrote:
> TODO: add a CONFIG option that can be to completely skip arch
> invalidation loop and avoid __weak references for arch/platforms that
> don't need an additional invalidation hook.
> 
> In some cases, like with SEV-SNP, guest memory needs to be updated in a
> platform-specific manner before it can be safely freed back to the host.
> Add hooks to wire up handling of this sort when freeing memory in
> response to FALLOC_FL_PUNCH_HOLE operations.
> 
> Also issue invalidations of all allocated pages when releasing the gmem
> file so that the pages are not left in an unusable state when they get
> freed back to the host.
> 
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>  arch/x86/include/asm/kvm-x86-ops.h |  1 +
>  arch/x86/include/asm/kvm_host.h    |  1 +
>  arch/x86/kvm/x86.c                 |  6 ++++
>  include/linux/kvm_host.h           |  3 ++
>  virt/kvm/guest_mem.c               | 48 ++++++++++++++++++++++++++++--
>  5 files changed, 57 insertions(+), 2 deletions(-)

ld: arch/x86/kvm/../../../virt/kvm/eventfd.o: in function `kvm_arch_gmem_invalidate':
/home/boris/kernel/2nd/linux/./include/linux/kvm_host.h:2356: multiple definition of `kvm_arch_gmem_invalidate'; arch/x86/kvm/../../../virt/kvm/kvm_main.o:/home/boris/kernel/2nd/linux/./include/linux/kvm_host.h:2356: first defined here
ld: arch/x86/kvm/../../../virt/kvm/binary_stats.o: in function `kvm_arch_gmem_invalidate':
/home/boris/kernel/2nd/linux/arch/x86/kvm/../../../virt/kvm/binary_stats.c:2356: multiple definition of `kvm_arch_gmem_invalidate'; arch/x86/kvm/../../../virt/kvm/kvm_main.o:/home/boris/kernel/2nd/linux/./include/linux/kvm_host.h:2356: first defined here
ld: arch/x86/kvm/../../../virt/kvm/vfio.o: in function `kvm_arch_gmem_invalidate':
/home/boris/kernel/2nd/linux/./include/linux/kvm_host.h:2356: multiple definition of `kvm_arch_gmem_invalidate'; arch/x86/kvm/../../../virt/kvm/kvm_main.o:/home/boris/kernel/2nd/linux/./include/linux/kvm_host.h:2356: first defined here
ld: arch/x86/kvm/../../../virt/kvm/coalesced_mmio.o: in function `kvm_arch_gmem_invalidate':
/home/boris/kernel/2nd/linux/./include/linux/kvm_host.h:2356: multiple definition of `kvm_arch_gmem_invalidate'; arch/x86/kvm/../../../virt/kvm/kvm_main.o:/home/boris/kernel/2nd/linux/./include/linux/kvm_host.h:2356: first defined here
ld: arch/x86/kvm/../../../virt/kvm/async_pf.o: in function `kvm_arch_gmem_invalidate':
/home/boris/kernel/2nd/linux/./include/linux/kvm_host.h:2356: multiple definition of `kvm_arch_gmem_invalidate'; arch/x86/kvm/../../../virt/kvm/kvm_main.o:/home/boris/kernel/2nd/linux/./include/linux/kvm_host.h:2356: first defined here
ld: arch/x86/kvm/../../../virt/kvm/irqchip.o: in function `kvm_arch_gmem_invalidate':
/home/boris/kernel/2nd/linux/./include/linux/kvm_host.h:2356: multiple definition of `kvm_arch_gmem_invalidate'; arch/x86/kvm/../../../virt/kvm/kvm_main.o:/home/boris/kernel/2nd/linux/./include/linux/kvm_host.h:2356: first defined here
ld: arch/x86/kvm/../../../virt/kvm/dirty_ring.o: in function `kvm_arch_gmem_invalidate':
/home/boris/kernel/2nd/linux/./include/linux/kvm_host.h:2356: multiple definition of `kvm_arch_gmem_invalidate'; arch/x86/kvm/../../../virt/kvm/kvm_main.o:/home/boris/kernel/2nd/linux/./include/linux/kvm_host.h:2356: first defined here
ld: arch/x86/kvm/../../../virt/kvm/pfncache.o: in function `kvm_arch_gmem_invalidate':
/home/boris/kernel/2nd/linux/./include/linux/kvm_host.h:2356: multiple definition of `kvm_arch_gmem_invalidate'; arch/x86/kvm/../../../virt/kvm/kvm_main.o:/home/boris/kernel/2nd/linux/./include/linux/kvm_host.h:2356: first defined here
ld: arch/x86/kvm/x86.o: in function `kvm_arch_gmem_invalidate':
/home/boris/kernel/2nd/linux/./include/linux/kvm_host.h:2356: multiple definition of `kvm_arch_gmem_invalidate'; arch/x86/kvm/../../../virt/kvm/kvm_main.o:/home/boris/kernel/2nd/linux/./include/linux/kvm_host.h:2356: first defined here
ld: arch/x86/kvm/emulate.o: in function `kvm_arch_gmem_invalidate':
/home/boris/kernel/2nd/linux/./include/linux/kvm_host.h:2356: multiple definition of `kvm_arch_gmem_invalidate'; arch/x86/kvm/../../../virt/kvm/kvm_main.o:/home/boris/kernel/2nd/linux/./include/linux/kvm_host.h:2356: first defined here
ld: arch/x86/kvm/i8259.o: in function `kvm_arch_gmem_invalidate':
/home/boris/kernel/2nd/linux/./include/linux/kvm_host.h:2356: multiple definition of `kvm_arch_gmem_invalidate'; arch/x86/kvm/../../../virt/kvm/kvm_main.o:/home/boris/kernel/2nd/linux/./include/linux/kvm_host.h:2356: first defined here
ld: arch/x86/kvm/irq.o: in function `kvm_arch_gmem_invalidate':
/home/boris/kernel/2nd/linux/./include/linux/kvm_host.h:2356: multiple definition of `kvm_arch_gmem_invalidate'; arch/x86/kvm/../../../virt/kvm/kvm_main.o:/home/boris/kernel/2nd/linux/./include/linux/kvm_host.h:2356: first defined here
ld: arch/x86/kvm/lapic.o: in function `kvm_arch_gmem_invalidate':
/home/boris/kernel/2nd/linux/./include/linux/kvm_host.h:2356: multiple definition of `kvm_arch_gmem_invalidate'; arch/x86/kvm/../../../virt/kvm/kvm_main.o:/home/boris/kernel/2nd/linux/./include/linux/kvm_host.h:2356: first defined here
ld: arch/x86/kvm/i8254.o: in function `kvm_arch_gmem_invalidate':
/home/boris/kernel/2nd/linux/./include/linux/kvm_host.h:2356: multiple definition of `kvm_arch_gmem_invalidate'; arch/x86/kvm/../../../virt/kvm/kvm_main.o:/home/boris/kernel/2nd/linux/./include/linux/kvm_host.h:2356: first defined here
ld: arch/x86/kvm/ioapic.o: in function `kvm_arch_gmem_invalidate':
/home/boris/kernel/2nd/linux/./include/linux/kvm_host.h:2356: multiple definition of `kvm_arch_gmem_invalidate'; arch/x86/kvm/../../../virt/kvm/kvm_main.o:/home/boris/kernel/2nd/linux/./include/linux/kvm_host.h:2356: first defined here
ld: arch/x86/kvm/irq_comm.o: in function `kvm_arch_gmem_invalidate':
/home/boris/kernel/2nd/linux/./include/linux/kvm_host.h:2356: multiple definition of `kvm_arch_gmem_invalidate'; arch/x86/kvm/../../../virt/kvm/kvm_main.o:/home/boris/kernel/2nd/linux/./include/linux/kvm_host.h:2356: first defined here
ld: arch/x86/kvm/cpuid.o: in function `kvm_arch_gmem_invalidate':
/home/boris/kernel/2nd/linux/./include/linux/kvm_host.h:2356: multiple definition of `kvm_arch_gmem_invalidate'; arch/x86/kvm/../../../virt/kvm/kvm_main.o:/home/boris/kernel/2nd/linux/./include/linux/kvm_host.h:2356: first defined here
ld: arch/x86/kvm/pmu.o: in function `kvm_arch_gmem_invalidate':
/home/boris/kernel/2nd/linux/./include/linux/kvm_host.h:2356: multiple definition of `kvm_arch_gmem_invalidate'; arch/x86/kvm/../../../virt/kvm/kvm_main.o:/home/boris/kernel/2nd/linux/./include/linux/kvm_host.h:2356: first defined here
ld: arch/x86/kvm/mtrr.o: in function `kvm_arch_gmem_invalidate':
/home/boris/kernel/2nd/linux/./include/linux/kvm_host.h:2356: multiple definition of `kvm_arch_gmem_invalidate'; arch/x86/kvm/../../../virt/kvm/kvm_main.o:/home/boris/kernel/2nd/linux/./include/linux/kvm_host.h:2356: first defined here
ld: arch/x86/kvm/hyperv.o: in function `kvm_arch_gmem_invalidate':
/home/boris/kernel/2nd/linux/./include/linux/kvm_host.h:2356: multiple definition of `kvm_arch_gmem_invalidate'; arch/x86/kvm/../../../virt/kvm/kvm_main.o:/home/boris/kernel/2nd/linux/./include/linux/kvm_host.h:2356: first defined here
ld: arch/x86/kvm/debugfs.o: in function `kvm_arch_gmem_invalidate':
/home/boris/kernel/2nd/linux/./include/linux/kvm_host.h:2356: multiple definition of `kvm_arch_gmem_invalidate'; arch/x86/kvm/../../../virt/kvm/kvm_main.o:/home/boris/kernel/2nd/linux/./include/linux/kvm_host.h:2356: first defined here
ld: arch/x86/kvm/mmu/mmu.o: in function `kvm_arch_gmem_invalidate':
/home/boris/kernel/2nd/linux/./include/linux/kvm_host.h:2356: multiple definition of `kvm_arch_gmem_invalidate'; arch/x86/kvm/../../../virt/kvm/kvm_main.o:/home/boris/kernel/2nd/linux/./include/linux/kvm_host.h:2356: first defined here
ld: arch/x86/kvm/mmu/page_track.o: in function `kvm_arch_gmem_invalidate':
/home/boris/kernel/2nd/linux/./include/linux/kvm_host.h:2356: multiple definition of `kvm_arch_gmem_invalidate'; arch/x86/kvm/../../../virt/kvm/kvm_main.o:/home/boris/kernel/2nd/linux/./include/linux/kvm_host.h:2356: first defined here
ld: arch/x86/kvm/mmu/spte.o: in function `kvm_arch_gmem_invalidate':
/home/boris/kernel/2nd/linux/./include/linux/kvm_host.h:2356: multiple definition of `kvm_arch_gmem_invalidate'; arch/x86/kvm/../../../virt/kvm/kvm_main.o:/home/boris/kernel/2nd/linux/./include/linux/kvm_host.h:2356: first defined here
ld: arch/x86/kvm/mmu/tdp_iter.o: in function `kvm_arch_gmem_invalidate':
/home/boris/kernel/2nd/linux/arch/x86/kvm/mmu/tdp_iter.c:2356: multiple definition of `kvm_arch_gmem_invalidate'; arch/x86/kvm/../../../virt/kvm/kvm_main.o:/home/boris/kernel/2nd/linux/./include/linux/kvm_host.h:2356: first defined here
ld: arch/x86/kvm/mmu/tdp_mmu.o: in function `kvm_arch_gmem_invalidate':
/home/boris/kernel/2nd/linux/./include/linux/kvm_host.h:2356: multiple definition of `kvm_arch_gmem_invalidate'; arch/x86/kvm/../../../virt/kvm/kvm_main.o:/home/boris/kernel/2nd/linux/./include/linux/kvm_host.h:2356: first defined here
ld: arch/x86/kvm/smm.o: in function `kvm_arch_gmem_invalidate':
/home/boris/kernel/2nd/linux/./include/linux/kvm_host.h:2356: multiple definition of `kvm_arch_gmem_invalidate'; arch/x86/kvm/../../../virt/kvm/kvm_main.o:/home/boris/kernel/2nd/linux/./include/linux/kvm_host.h:2356: first defined here
make[3]: *** [scripts/Makefile.build:452: arch/x86/kvm/kvm.o] Error 1
make[3]: *** Waiting for unfinished jobs....
make[2]: *** [scripts/Makefile.build:494: arch/x86/kvm] Error 2
make[2]: *** Waiting for unfinished jobs....
make[1]: *** [scripts/Makefile.build:494: arch/x86] Error 2
make[1]: *** Waiting for unfinished jobs....
make: *** [Makefile:2028: .] Error 2

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
