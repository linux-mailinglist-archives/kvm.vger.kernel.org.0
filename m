Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC55B7381B7
	for <lists+kvm@lfdr.de>; Wed, 21 Jun 2023 13:11:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231948AbjFUJnf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jun 2023 05:43:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231750AbjFUJna (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Jun 2023 05:43:30 -0400
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35D9A129;
        Wed, 21 Jun 2023 02:43:28 -0700 (PDT)
Received: from mail.alien8.de (mail.alien8.de [IPv6:2a01:4f9:3051:3f93::2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id D62E51EC0645;
        Wed, 21 Jun 2023 11:43:25 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1687340605;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=yXKcV3auqZiH5ablDN0OpddtOVM62a/D928JjKMNXI0=;
        b=fGGGFOcm/j1jBRRvN7zXyPW4PWbANeEwKO58akYk3HFwWVhSbZepdoK1UDfltiq3BVsgxV
        afZo1xjFVpNXrOgPFEwzSrf+otLk2UgZpxcxQ/SMfzX2uiICQenOugsvfjtw+5jxoMDWDm
        xejbSVf4LXHZHL2lKqvLKvAqigR5Qp0=
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
        header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
        by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id e4WsilyJ1x43; Wed, 21 Jun 2023 09:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
        t=1687340602; bh=yXKcV3auqZiH5ablDN0OpddtOVM62a/D928JjKMNXI0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fyQVwBnAueySdbG0xMg34yXlW/XbZoa2fdHIxCPpbUpUvZTzceVEGqhpKf26M8jvh
         cQZrHrd4NDWJ1hZ9bhyVgh1pjqJKNLWEMiP5gA2Xv7wshI3Zdr7Ezl3oUQ1uk4hncH
         ktCnJjrTimE6r2iOMN1pBLtXrLeF2ISV/Nw1dqvQxfSDmKyO1yF4mNSg9urBDIt19l
         MOyDgIo8MpE4vooEPqEEgYB5Z2olkoquqbzGNxggefTMMtCyztPuHGCPg3nmVx4ozu
         EPUIsYbiqJxia1qErD6CYuMaJsODWsvZ+ZOAudy/BD72pBpc6AID/bTPdb3fSif4he
         YJqerDK6aM/oRya8NBWdn0pUP0ZzfKFVhaEGbiIc4fDLSmxsPt/LcKMFID505QCQeF
         bjPZumWkHDakTZMlxA5hv+gLVXfkr8mXNg4pxO6pnDXgITMEpqFW+4/KcWboFFnXik
         eYdNfzumlPl4OwXJ2X2A32oLbFraGQgho7WNG4HzPbuRoBvfnE4AFk+MN58iiXan/d
         7YOKobJsShP6uAB/bu/hmdcuAF7hFSyLfx/3ll177T7PJLSzJNTbdqHS6oTgMKbf+/
         /6fWRvqQT2vKqfHn6HtALNs+cMMAqD4RPO04QOQCVFEvh56EOxuwc3EewsfN5vk7wX
         dCgtDPf8uUZqB0n1/xsXwixA=
Received: from zn.tnic (p200300ea971Dc592329c23FffEA6a903.dip0.t-ipconnect.de [IPv6:2003:ea:971d:c592:329c:23ff:fea6:a903])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
        (No client certificate requested)
        by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 3EDD640E019B;
        Wed, 21 Jun 2023 09:42:42 +0000 (UTC)
Date:   Wed, 21 Jun 2023 11:42:36 +0200
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
        zhi.a.wang@intel.com, Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH RFC v9 07/51] x86/sev: Add the host SEV-SNP
 initialization support
Message-ID: <20230621094236.GZZJLGDAicp1guNPvD@fat_crate.local>
References: <20230612042559.375660-1-michael.roth@amd.com>
 <20230612042559.375660-8-michael.roth@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230612042559.375660-8-michael.roth@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Jun 11, 2023 at 11:25:15PM -0500, Michael Roth wrote:
> From: Brijesh Singh <brijesh.singh@amd.com>
> 
> The memory integrity guarantees of SEV-SNP are enforced through a new
> structure called the Reverse Map Table (RMP). The RMP is a single data
> structure shared across the system that contains one entry for every 4K
> page of DRAM that may be used by SEV-SNP VMs. APM2 section 15.36 details

Rather say 'APM v2, section "Secure Nested Paging (SEV-SNP)"' because
the numbering is more likely to change than the name in the future. With
the name, people can find it faster.

> a number of steps needed to detect/enable SEV-SNP and RMP table support
> on the host:
> 
>  - Detect SEV-SNP support based on CPUID bit
>  - Initialize the RMP table memory reported by the RMP base/end MSR
>    registers and configure IOMMU to be compatible with RMP access
>    restrictions
>  - Set the MtrrFixDramModEn bit in SYSCFG MSR
>  - Set the SecureNestedPagingEn and VMPLEn bits in the SYSCFG MSR
>  - Configure IOMMU
> 
> RMP table entry format is non-architectural and it can vary by
> processor. It is defined by the PPR. Restrict SNP support to CPU
> models/families which are compatible with the current RMP table entry
> format to guard against any undefined behavior when running on other
> system types. Future models/support will handle this through an
> architectural mechanism to allow for broader compatibility.

I'm guessing this is all for live migration between SNP hosts. If so,
then there will have to be a guest API to handle the differences.

> SNP host code depends on CONFIG_KVM_AMD_SEV config flag, which may be
> enabled even when CONFIG_AMD_MEM_ENCRYPT isn't set, so update the
> SNP-specific IOMMU helpers used here to rely on CONFIG_KVM_AMD_SEV
> instead of CONFIG_AMD_MEM_ENCRYPT.

Does that mean that even on CONFIG_AMD_MEM_ENCRYPT=n kernels, host SNP
can function?

Do we even want that?

I'd expect that a host SNP kernel should have SME enabled too even
though it is not absolutely necessary.

> Co-developed-by: Ashish Kalra <ashish.kalra@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> Co-developed-by: Tom Lendacky <thomas.lendacky@amd.com>
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> [mdr: rework commit message to be clearer about what patch does, squash
>       in early_rmptable_check() handling from Tom]
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>  arch/x86/coco/Makefile                   |   1 +
>  arch/x86/coco/sev/Makefile               |   3 +
>  arch/x86/coco/sev/host.c                 | 212 +++++++++++++++++++++++
>  arch/x86/include/asm/disabled-features.h |   8 +-
>  arch/x86/include/asm/msr-index.h         |  11 +-
>  arch/x86/include/asm/sev.h               |   2 +
>  arch/x86/kernel/cpu/amd.c                |  19 ++
>  drivers/iommu/amd/init.c                 |   2 +-
>  include/linux/amd-iommu.h                |   2 +-
>  9 files changed, 256 insertions(+), 4 deletions(-)
>  create mode 100644 arch/x86/coco/sev/Makefile
>  create mode 100644 arch/x86/coco/sev/host.c

Ignored review comments here:

https://lore.kernel.org/r/Y9ubi0i4Z750gdMm@zn.tnic

Ignoring this one for now too.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
