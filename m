Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC70A62E35B
	for <lists+kvm@lfdr.de>; Thu, 17 Nov 2022 18:45:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234664AbiKQRpM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Nov 2022 12:45:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233270AbiKQRpL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Nov 2022 12:45:11 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 559A165E42;
        Thu, 17 Nov 2022 09:45:10 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id v3-20020a17090ac90300b00218441ac0f6so6411831pjt.0;
        Thu, 17 Nov 2022 09:45:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=J+IZ0bBrm6HTtpbBq7zbnIfZW4FoGEPOw3MaAT9g05E=;
        b=EC2t2eI8DFfZ6VaQH411TgrtLbx9lcDegBRFY2IlMGo7JWLFQdNGS1J281pVFg/Gv8
         XABvjlGjdjIMSB1NlqUk7ls9cvK9xtcSJ4uUyHGpqVsqq26VK1XCbUNrmn47v6Z0fXOo
         cfLoGN0ns6Z8F3y8JeFLqbd1GvHtPVzqBz3L6Rl9sN3h9iO2Wm1RtTuA8YQEvhaOW15U
         +zj1wY2OsHZcV7ua4oDeShGOdd+JuhtHWi8+mKYfZDKO25ZBTIKTPtQI2Pdbv1pGH7jf
         EKOFsDxpdnrdHv/gv57XHOgC0R/2Rws/My/gGQvnxn+ECwkv3wgorex05Zi5V2HONzvf
         o+kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J+IZ0bBrm6HTtpbBq7zbnIfZW4FoGEPOw3MaAT9g05E=;
        b=8FQNFfgZIEtUpKUpC2YPSiuggmkx3lLGe+J0fmexLum8AClGI/AGatQNLy5Hz2QvE0
         5QIwK31OPqnt0/5KHess6OX1uGYxTtcBd1fSy4B06ZThAz264YEnZT8oCm1z94HWBxzD
         xNkCIzJVWG0Vm9M8Btvp89sNPEdfajkfukOYnZQm0cQl3KIOq1wgeinhRNyFa3F74czS
         7teRzjzpvjZtG2ZRWfT7VczS+51fMRoiZHsFbffOKZ8ZfRvA9gIs78aFQpXm0LW7Co3j
         99l7oJhgGj7uFnLetbxw8CGNkoVb5fth92TKNRyB2DdzPKWw0LFbl1SQsd2txYu/Snnw
         JkJg==
X-Gm-Message-State: ANoB5pnWU+RkgQ14GW8nQUUWYQfkWPuYulSZnNFyNilZhGchXSirkDuB
        3zDEMdqoOVEWQjGqylUrZjo=
X-Google-Smtp-Source: AA0mqf5USSlpnDiOXdKQfwBtC0PTWEZtFUUZaE+LZFz9YESdmd5yWZp5wADh81tjjdNYLFr0rrKdlw==
X-Received: by 2002:a17:90a:d38c:b0:214:ba3:4eb1 with SMTP id q12-20020a17090ad38c00b002140ba34eb1mr10042726pju.161.1668707109697;
        Thu, 17 Nov 2022 09:45:09 -0800 (PST)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id a64-20020a621a43000000b0056b9a740ec2sm1391714pfa.156.2022.11.17.09.45.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Nov 2022 09:45:09 -0800 (PST)
Date:   Thu, 17 Nov 2022 09:45:08 -0800
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "Christopherson,, Sean" <seanjc@google.com>
Subject: Re: [PATCH v10 016/108] KVM: TDX: create/destroy VM structure
Message-ID: <20221117174508.GD2350331@ls.amr.corp.intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
 <fb337a67e17715977e46523d1344cb2a7f46a37a.1667110240.git.isaku.yamahata@intel.com>
 <c3deef412933070932f565af8639d15aef00ea1c.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <c3deef412933070932f565af8639d15aef00ea1c.camel@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 10, 2022 at 11:04:25AM +0000,
"Huang, Kai" <kai.huang@intel.com> wrote:

> > > flush_shadow_all_private callback before tearing down private page tables
> > > for it.
> > > 
> > > Add a second kvm_x86_ops hook in kvm_arch_destroy_vm() to support TDX's
> > > destruction path, which needs to first put the VM into a teardown state,
> > > then free per-vCPU resources, and finally free per-VM resources.
> 
> Perhaps explicitly call out the hook is vm_free() and why the existing
> vm_destroy() hook cannot meet TDX's purpose, so that people can understand
> easily why you need vm_free().

Sure, will update the commit message.


> > > +static inline void tdx_hkid_free(struct kvm_tdx *kvm_tdx)
> > > +{
> > > +	tdx_keyid_free(kvm_tdx->hkid);
> > > +	kvm_tdx->hkid = -1;
> 
> Why -1? Can it be set to 0, which is the initial value when kvm_tdx is allocated
> anyway?

0 works. I'll replace it with 0.


> > > +}
> > > +
> > > +static inline bool is_hkid_assigned(struct kvm_tdx *kvm_tdx)
> > > +{
> > > +	return kvm_tdx->hkid > 0;
> > > +}
> > > +
> > > +static void tdx_clear_page(unsigned long page)
> > > +{
> > > +	const void *zero_page = (const void *) __va(page_to_phys(ZERO_PAGE(0)));
> > > +	unsigned long i;
> > > +
> > > +	/*
> > > +	 * Zeroing the page is only necessary for systems with MKTME-i:
> > > +	 * when re-assign one page from old keyid to a new keyid, MOVDIR64B is
> > > +	 * required to clear/write the page with new keyid to prevent integrity
> > > +	 * error when read on the page with new keyid.
> > > +	 *
> > > +	 * The cache line could be poisoned (even without MKTME-i), clear the
> > > +	 * poison bit.
> 
> Does this happen only when there's potential kernel bug?

That's right.


> > > +static int tdx_alloc_td_page(struct tdx_td_page *page)
> > > +{
> > > +	page->va = __get_free_page(GFP_KERNEL_ACCOUNT);
> > > +	if (!page->va)
> > > +		return -ENOMEM;
> > > +
> > > +	page->pa = __pa(page->va);
> > > +	return 0;
> > > +}
> > > +
> > > +static inline void tdx_mark_td_page_added(struct tdx_td_page *page)
> > > +{
> > > +	WARN_ON_ONCE(page->added);
> > > +	page->added = true;
> > > +}
> > > +
> > > +static void tdx_reclaim_td_page(struct tdx_td_page *page)
> > > +{
> > > +	if (page->added) {
> > > +		/*
> > > +		 * TDCX are being reclaimed.  TDX module maps TDCX with HKID
> > > +		 * assigned to the TD.  Here the cache associated to the TD
> > > +		 * was already flushed by TDH.PHYMEM.CACHE.WB before here, So
> > > +		 * cache doesn't need to be flushed again.
> > > +		 */
> > > +		if (tdx_reclaim_page(page->va, page->pa, false, 0))
> > > +			return;
> > > +
> > > +		page->added = false;
> > > +	}
> > > +	if (page->va) {
> > > +		free_page(page->va);
> > > +		page->va = 0;
> > > +	}
> > > +}
> > > +
> 
> 
> I am wondering why this 'struct tdx_td_page' is needed?
> 
> It appears the page->pa is used by SEAMCALLs and page->va is used by
> tdx_clear_page() as MOVDIR64B needs a virtual address.
> 
> But since GFP_KERNEL_ACCOUNT is used in memory allocation, so you can actually
> just get the pa and va from the page easily (using page_to_phys() and __va()).
> Also it's 64-bit kernel so you don't even need to consider HIGHMEM.

Yes, page->va member can be dropped. Will drop it.


> Also, it seems page->added can be replaced with simply checking whether page is
> NULL, correct?

No. It's subtle. Anyway let me check it.


> Btw, I think the introduce of 'struct tdx_td_page' and the new 'struct
> tdx_td_page tdr' to 'struct kvm_tdx' should come together with this patch, but
> not in the previous patch "KVM: TDX: Stub in tdx.h with structs, accessors, and
> VMCS helpers". This makes the code review easier.
> 
> The "accessors" can be introduced in later patch when they are needed -- it
> doesn't seem any of them is used in this patch?

Ok, will move it to that patch.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
