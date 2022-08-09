Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FDBA58D9F9
	for <lists+kvm@lfdr.de>; Tue,  9 Aug 2022 15:56:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242671AbiHIN4t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Aug 2022 09:56:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244780AbiHIN4W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Aug 2022 09:56:22 -0400
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEAC518368;
        Tue,  9 Aug 2022 06:56:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1660053382; x=1691589382;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=odYNCkcIAQcBKQptQexLin/WRKzdil3fPD/Uqu4HkkI=;
  b=aEFzcalQ97hAG4bs2JdRqWh1VYvGCJfnHi664tJe/d/FqlvKXVw2DGNF
   0sl4Mb77jMqaH3pw2ip5ztIa2t/6kYAuQ4kVNeWE0WSFPGYG3tWmustKj
   S1MyZYCrFhh3nnAJx34sgJL686GkGPuP7OCHq+najECXbN6sNphKBVeTe
   U=;
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-iad-1a-b09d0114.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2022 13:56:08 +0000
Received: from EX13D24EUC003.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1a-b09d0114.us-east-1.amazon.com (Postfix) with ESMTPS id 35EAD80383;
        Tue,  9 Aug 2022 13:55:58 +0000 (UTC)
Received: from dev-dsk-sabrapan-1c-164a86ac.eu-west-1.amazon.com
 (10.43.162.227) by EX13D24EUC003.ant.amazon.com (10.43.164.217) with
 Microsoft SMTP Server (TLS) id 15.0.1497.36; Tue, 9 Aug 2022 13:55:48 +0000
From:   Sabin Rapan <sabrapan@amazon.com>
To:     <ashish.kalra@amd.com>
CC:     <ak@linux.intel.com>, <alpergun@google.com>, <ardb@kernel.org>,
        <bp@alien8.de>, <dave.hansen@linux.intel.com>,
        <dgilbert@redhat.com>, <dovmurik@linux.ibm.com>, <hpa@zytor.com>,
        <jarkko@kernel.org>, <jmattson@google.com>, <jroedel@suse.de>,
        <kirill@shutemov.name>, <kvm@vger.kernel.org>,
        <linux-coco@lists.linux.dev>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <luto@kernel.org>, <marcorr@google.com>, <michael.roth@amd.com>,
        <mingo@redhat.com>, <pbonzini@redhat.com>, <peterz@infradead.org>,
        <pgonda@google.com>, <rientjes@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>, <seanjc@google.com>,
        <slp@redhat.com>, <srinivas.pandruvada@linux.intel.com>,
        <tglx@linutronix.de>, <thomas.lendacky@amd.com>, <tobin@ibm.com>,
        <tony.luck@intel.com>, <vbabka@suse.cz>, <vkuznets@redhat.com>,
        <x86@kernel.org>
Subject: Re: [PATCH Part2 v6 26/49] KVM: SVM: Add KVM_SEV_SNP_LAUNCH_UPDATE command 
Date:   Tue, 9 Aug 2022 13:55:35 +0000
Message-ID: <20220809135535.88234-1-sabrapan@amazon.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <fdf036c1e2fdf770da8238b31056206be08a7c1b.1655761627.git.ashish.kalra@amd.com>
References: <fdf036c1e2fdf770da8238b31056206be08a7c1b.1655761627.git.ashish.kalra@amd.com>
MIME-Version: 1.0
X-Originating-IP: [10.43.162.227]
X-ClientProxiedBy: EX13D40UWC003.ant.amazon.com (10.43.162.246) To
 EX13D24EUC003.ant.amazon.com (10.43.164.217)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-12.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> +static bool is_hva_registered(struct kvm *kvm, hva_t hva, size_t len)
> +{
> +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +	struct list_head *head = &sev->regions_list;
> +	struct enc_region *i;
> +
> +	lockdep_assert_held(&kvm->lock);
> +
> +	list_for_each_entry(i, head, list) {
> +		u64 start = i->uaddr;
> +		u64 end = start + i->size;
> +
> +		if (start <= hva && end >= (hva + len))
> +			return true;
> +	}
> +
> +	return false;
> +}

Since KVM_MEMORY_ENCRYPT_REG_REGION should be called for every memory region the user gives to kvm,
is the regions_list any different from kvm's memslots?

> +
> +static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
> +{
> +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +	struct sev_data_snp_launch_update data = {0};
> +	struct kvm_sev_snp_launch_update params;
> +	unsigned long npages, pfn, n = 0;
> +	int *error = &argp->error;
> +	struct page **inpages;
> +	int ret, i, level;
> +	u64 gfn;
> +
> +	if (!sev_snp_guest(kvm))
> +		return -ENOTTY;
> +
> +	if (!sev->snp_context)
> +		return -EINVAL;
> +
> +	if (copy_from_user(&params, (void __user *)(uintptr_t)argp->data, sizeof(params)))
> +		return -EFAULT;
> +
> +	/* Verify that the specified address range is registered. */
> +	if (!is_hva_registered(kvm, params.uaddr, params.len))
> +		return -EINVAL;
> +
> +	/*
> +	 * The userspace memory is already locked so technically we don't
> +	 * need to lock it again. Later part of the function needs to know
> +	 * pfn so call the sev_pin_memory() so that we can get the list of
> +	 * pages to iterate through.
> +	 */
> +	inpages = sev_pin_memory(kvm, params.uaddr, params.len, &npages, 1);
> +	if (!inpages)
> +		return -ENOMEM;

sev_pin_memory will call pin_user_pages() which fails for PFNMAP vmas that you
would get if you use memory allocated from an IO driver.
Using gfn_to_pfn instead will make this work with vmas backed by pages or raw
pfn mappings.




Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in Romania. Registration number J22/2621/2005.

