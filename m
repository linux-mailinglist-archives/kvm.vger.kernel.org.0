Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D323056711B
	for <lists+kvm@lfdr.de>; Tue,  5 Jul 2022 16:33:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231181AbiGEOd5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Jul 2022 10:33:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229844AbiGEOd4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Jul 2022 10:33:56 -0400
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 326E738A6;
        Tue,  5 Jul 2022 07:33:55 -0700 (PDT)
Received: from zn.tnic (p200300ea970ff682329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:970f:f682:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id C09931EC0445;
        Tue,  5 Jul 2022 16:33:49 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1657031629;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=Bcm1kwuF5rplXwfBxNBb+WfZHo2BiShJJUDVm2VGqVY=;
        b=rlB3osgY1N5VaH4VJs1WQc2d6N5Hs1DIMhBFixnhxT7se+LuHYH5lyxdcvpA+TL/Gl8zYz
        Abv4QCAs1HDcGLdS09m6Zbnhc7J77LsPyY/XkcbJujK/nzgLvtdYN/N8JKAsnAvVBCC6tE
        WjOrzWubFVRgAEPZynFs8+XFT8qCcnA=
Date:   Tue, 5 Jul 2022 16:33:46 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     "Kalra, Ashish" <Ashish.Kalra@amd.com>
Cc:     "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "jroedel@suse.de" <jroedel@suse.de>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "ardb@kernel.org" <ardb@kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "slp@redhat.com" <slp@redhat.com>,
        "pgonda@google.com" <pgonda@google.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "srinivas.pandruvada@linux.intel.com" 
        <srinivas.pandruvada@linux.intel.com>,
        "rientjes@google.com" <rientjes@google.com>,
        "dovmurik@linux.ibm.com" <dovmurik@linux.ibm.com>,
        "tobin@ibm.com" <tobin@ibm.com>,
        "Roth, Michael" <Michael.Roth@amd.com>,
        "vbabka@suse.cz" <vbabka@suse.cz>,
        "kirill@shutemov.name" <kirill@shutemov.name>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "marcorr@google.com" <marcorr@google.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "alpergun@google.com" <alpergun@google.com>,
        "dgilbert@redhat.com" <dgilbert@redhat.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>
Subject: Re: [PATCH Part2 v6 02/49] iommu/amd: Introduce function to check
 SEV-SNP support
Message-ID: <YsRLyoylnTHkgfa1@zn.tnic>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <12df64394b1788156c8a3c2ee8dfd62b51ab3a81.1655761627.git.ashish.kalra@amd.com>
 <Yr7Pm/E9WsAjirV0@zn.tnic>
 <SN6PR12MB27673AC95A577D5468A949598E819@SN6PR12MB2767.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <SN6PR12MB27673AC95A577D5468A949598E819@SN6PR12MB2767.namprd12.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 05, 2022 at 01:56:00PM +0000, Kalra, Ashish wrote:
> This function is required to ensure that IOMMU supports the SEV-SNP
> feature before enabling the SNP feature and calling SNP_INIT.
> This IOMMU support check is done in the AMD IOMMU driver with the
> iommu_sev_snp_supported() function so it is exported by the IOMMU
> driver and called by sev module

What sev module?

The call to iommu_sev_snp_supported() is done by snp_rmptable_init()
which is in arch/x86/kernel/sev.c. AFAICT.

And that is not a module. But function exports are done for modules.

So that export looks superfluous.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
