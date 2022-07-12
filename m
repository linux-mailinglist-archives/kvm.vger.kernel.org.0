Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B76F2571D5F
	for <lists+kvm@lfdr.de>; Tue, 12 Jul 2022 16:54:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233542AbiGLOyR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jul 2022 10:54:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233812AbiGLOyL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jul 2022 10:54:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56ED620BDD;
        Tue, 12 Jul 2022 07:54:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E881460C1A;
        Tue, 12 Jul 2022 14:54:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C65F4C341C0;
        Tue, 12 Jul 2022 14:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657637649;
        bh=VkRGH3NNN+HIyw30NEGUMWuNTYMnRNznF6Yoz8xWvHE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=h60oAnU1aXZaRC7VpVhzHcRhXIV0KfZ9Zm2lzo6YT5TOw0wuZD1nO+KNGFKijNu34
         lZMJhtnZZrJ70MJD808JKzGh4pRAxRdcL3a0ILc5SyRdisTaoaN366Hej78Ejbb9hU
         qQhKS8myxFGhQucR5emZKGxqwZouBqiCzh1hvojeRta93T3o+ZLOqYTTNwDbuWGHvN
         S3zKyxs52kUBo0yn5c18FEEkQbZthkLG59WuRvdr7PYWgFvCS36XTvHf6rkyjxirCj
         k0YNOyFS/olS3uOxmKphzfuDqxHtU9n41plGVYyb8bHq3C+1p8JS2e/sLZOKzUb4Ym
         xn26XlW9iX5Lw==
Date:   Tue, 12 Jul 2022 17:54:05 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
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
        "tobin@ibm.com" <tobin@ibm.com>, "bp@alien8.de" <bp@alien8.de>,
        "Roth, Michael" <Michael.Roth@amd.com>,
        "vbabka@suse.cz" <vbabka@suse.cz>,
        "kirill@shutemov.name" <kirill@shutemov.name>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "marcorr@google.com" <marcorr@google.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "alpergun@google.com" <alpergun@google.com>,
        "dgilbert@redhat.com" <dgilbert@redhat.com>
Subject: Re: [PATCH Part2 v6 09/49] x86/fault: Add support to handle the RMP
 fault for user address
Message-ID: <Ys2LDaKFE9+aoZKr@kernel.org>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <0ecb0a4781be933fcadeb56a85070818ef3566e7.1655761627.git.ashish.kalra@amd.com>
 <Ys1hrq+vFbxRJbra@kernel.org>
 <SN6PR12MB27676FD80E6B20D6B8459EC28E869@SN6PR12MB2767.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SN6PR12MB27676FD80E6B20D6B8459EC28E869@SN6PR12MB2767.namprd12.prod.outlook.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 12, 2022 at 02:29:18PM +0000, Kalra, Ashish wrote:
> [AMD Official Use Only - General]
> 
> >> +static int handle_user_rmp_page_fault(struct pt_regs *regs, unsigned long error_code,
> >> +				      unsigned long address)
> >> +{
> >> +	int rmp_level, level;
> >> +	pte_t *pte;
> >> +	u64 pfn;
> >> +
> >> +	pte = lookup_address_in_mm(current->mm, address, &level);
> 
> >As discussed in [1], the lookup should be done in kvm->mm, along the lines of host_pfn_mapping_level().
> 
> With lookup_address_in_mm() now removed in 5.19, this is now using
> lookup_address_in_pgd() though still using non init-mm, and as mentioned
> here in [1], it makes sense to not use lookup_address_in_pgd() as it does
> not play nice with userspace mappings, e.g. doesn't disable IRQs to block
> TLB shootdowns and doesn't use READ_ONCE() to ensure an upper level entry
> isn't converted to a huge page between checking the PAGE_SIZE bit and
> grabbing the address of the next level down.
> 
> But is KVM going to provide its own variant of lookup_address_in_pgd()
> that is safe for use with user addresses, i.e., a generic version of
> lookup_address() on kvm->mm or we need to duplicate page table walking
> code of host_pfn_mapping_level() ?

It's probably cpen coded for the sole reason that there is only one
call site, i.e. there has not been rational reason to have a helper
function.

Helpers are usually created only in-need basis, and since the need
comes from this patch set, it should include a patch, which simply
encapsulates it into a helper.

> 
> Thanks,
> Ashish

BR, Jarkko
