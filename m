Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCC6869E953
	for <lists+kvm@lfdr.de>; Tue, 21 Feb 2023 22:16:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbjBUVQE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Feb 2023 16:16:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbjBUVPz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Feb 2023 16:15:55 -0500
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED90330E96;
        Tue, 21 Feb 2023 13:15:19 -0800 (PST)
Received: by mail-lf1-x12d.google.com with SMTP id i9so7280746lfc.6;
        Tue, 21 Feb 2023 13:15:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gHZsoxAUB1qOQOkvHNT7weaGeMzKDk1Ga8sccYf8xcg=;
        b=OrCTf5cZvZYUFHI/0GymXf51VnjzTEY6BgE6OrAmYOmm3bTTSSA/UOLWlCMCPQgC55
         aq/YEqGEdbQYHMH3n0OOtLUx4JdtIzXhNaW/00LFoLB5SuhiiGu50b+Z01CJUMHv5p/4
         NYLXgGXknyT5MCEWl49qH7N0/jJyC7vfTes8ZPD0yelwnYzHg1uB20y5h9njG0maWaBv
         /g66EkEgzHXRbMhMWWYfDGeCcIN5xCebQHh1hIY7T+cZOXQ3CrYc+/9NCPUq2UhZvxYv
         m43zjB2VgOxSsjzRswksXL8PVuUPSf74n7sRrPJFEMiAbtLH1ZcEF2jFhHBc/ZUjU8VN
         ky8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gHZsoxAUB1qOQOkvHNT7weaGeMzKDk1Ga8sccYf8xcg=;
        b=0oNBsFMoBEOmCH8ieJnGH6FT334nMAvq2hfrZ3IiRIH0DbPFuX2lerVdaMKzsEqkJ9
         tzgs17UM6LbpP03MNN8eXNsTlr7IwgFKnMb+mYVU16zq2dyxaZRb+Pyxr7gZAG7me6dR
         UX0KanHcTQt0Klj9W8LpfKFV/zFSnjiTEuDbDlyGZe+jZ4UfnbRS6NeCBENq9ZCW9flc
         VPUmQ1rZh1H64glYv8YhWD4kzwbcmlMRD41mvE8EsZ4rrrIwofD85IW4TybulozR9qTQ
         yPRaj0HqYIi9GHJZfeSXRM+8SHOSk1cO68f7J6JnYWeOpf9OFlPc/ewpwRaE7t/ImtT7
         Ht5Q==
X-Gm-Message-State: AO0yUKUpComk6+rfVBgncr8MZyxd6vSPj+MKeteiZWrtWH0JExT5zTEd
        r8+MXYx0Yy05LL77A0YBn5E=
X-Google-Smtp-Source: AK7set8NjTzhXspfN0nv7/0jUg0gxiYbQwoM+JmD4tCTFmj26oQh0HeivTpT3TU1zBHWBaGTqt8wqQ==
X-Received: by 2002:a19:7014:0:b0:4d0:e044:f865 with SMTP id h20-20020a197014000000b004d0e044f865mr1873623lfc.6.1677014117822;
        Tue, 21 Feb 2023 13:15:17 -0800 (PST)
Received: from localhost (88-115-161-74.elisa-laajakaista.fi. [88.115.161.74])
        by smtp.gmail.com with ESMTPSA id v23-20020a197417000000b004d23763fe96sm1941493lfe.72.2023.02.21.13.15.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Feb 2023 13:15:17 -0800 (PST)
Date:   Tue, 21 Feb 2023 23:15:14 +0200
From:   Zhi Wang <zhi.wang.linux@gmail.com>
To:     "Kalra, Ashish" <ashish.kalra@amd.com>
Cc:     Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
        dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
        peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
        rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com,
        bp@alien8.de, vbabka@suse.cz, kirill@shutemov.name,
        ak@linux.intel.com, tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org, nikunj.dadhania@amd.com,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH RFC v8 24/56] crypto: ccp: Handle the legacy TMR
 allocation when SNP is enabled
Message-ID: <20230221231514.00004b27@gmail.com>
In-Reply-To: <f70a2398-bd78-24aa-b0ae-9171465d50ff@amd.com>
References: <20230220183847.59159-1-michael.roth@amd.com>
        <20230220183847.59159-25-michael.roth@amd.com>
        <20230221112823.000063e4@gmail.com>
        <f70a2398-bd78-24aa-b0ae-9171465d50ff@amd.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 21 Feb 2023 09:31:01 -0600
"Kalra, Ashish" <ashish.kalra@amd.com> wrote:

> >> +static int snp_reclaim_pages(unsigned long paddr, unsigned int npages, bool locked)
> >> +{
> >> +	/* Cbit maybe set in the paddr */
> > 
> > This is confusing.
> > 
> > I suppose C-bit is treated as a attribute of PTE in the kernel not part of the
> > PA. It means only a PTE might carry a C-bit.
> > 
> 
> snp_reclaim_pages() is also called for reclaiming guest memory, in which 
> case the (guest) paddr will have the C-bit set. Hence this C-bit 
> handling is done within snp_reclaim_pages() so that the callers don't 
> need to handle it explicitly.

Thanks for the explanation.

Do you mean it will be used like that in the later patch? Sorry if it is in the
later patch as I was making progress slowly. It is quite a big patch set.

At least, I don't see that kind of usage in the current patch. Feel free to
correct me if I am wrong.

The call chains:

__snp_free_firmware_page()
    snp_reclaim_pages();

As __snp_free_firmware_page() takes struct page*, all the follwing coversion
from it would not carry C-bit.

__snp_alloc_firmware_pages()
  rmp_mark_pages_firmware()
    snp_reclaim_pages()

As __snp_alloc_firmware_page() allocates page with struct page*, the same
conclusion as above.

> 
> 
> > The paddr is from __pa(page_address()). It is not extracted from a PTE. Thus, the
> > return from them should never have a C-bit.
> > 
> > BTW: Wouldn't it be better to have pfn as input param instead of paddr?
> > 
> > The caller has struct page, calling snp_reclaim_pages(page_to_pfn(page), xxxxx)
> > would be much clearer than the current conversion:
> > page_address() (struct page is converted to VA), __pa() (VA is converted to PA)
> > in the caller and then PA is converted to pfn here.
> > 
> >> +	unsigned long pfn = __sme_clr(paddr) >> PAGE_SHIFT;
> >> +	int ret, err, i, n = 0;
> >> +
> > 
> > should be unsigned int i, n; as the input param npage is unsigned int.
> > 
> >> +	if (!pfn_valid(pfn)) {
> >> +		pr_err("%s: Invalid PFN %lx\n", __func__, pfn);
> >> +		return 0;
> >> +	}
> >> +
> >> +	for (i = 0; i < npages; i++, pfn++, n++) {
> >> +		paddr = pfn << PAGE_SHIFT;
> >> +
> >> +		if (locked)
> >> +			ret = __sev_do_cmd_locked(SEV_CMD_SNP_PAGE_RECLAIM, &paddr, &err);
> >> +		else
> >> +			ret = sev_do_cmd(SEV_CMD_SNP_PAGE_RECLAIM, &paddr, &err);
> >> +
> >> +		if (ret)
> >> +			goto cleanup;
> >> +
> >> +		ret = rmp_make_shared(pfn, PG_LEVEL_4K);
> >> +		if (ret)
> >> +			goto cleanup;
> >> +	}
> >> +
> >> +	return 0;
> >> +
> >> +cleanup:
> >> +	/*
> >> +	 * If failed to reclaim the page then page is no longer safe to
> >> +	 * be release back to the system, leak it.
> >> +	 */
> >> +	snp_mark_pages_offline(pfn, npages - n);
> >> +	return ret;
> >> +}
> >> +
> >> +static int rmp_mark_pages_firmware(unsigned long paddr, unsigned int npages, bool locked)
> > 
> > The same comment as above. Better take pfn or page instead of paddr with
> > redundant conversions.
> > 
> 
> Again, the paddr can point to guest memory so it can have C-bit set.
> 
> Thanks,
> Ashish
> 
> >> +{
> >> +	/* Cbit maybe set in the paddr */
> >> +	unsigned long pfn = __sme_clr(paddr) >> PAGE_SHIFT;
> >> +	int rc, n = 0, i;
> >> +
> >> +	for (i = 0; i < npages; i++, n++, pfn++) {
> >> +		rc = rmp_make_private(pfn, 0, PG_LEVEL_4K, 0, true);
> >> +		if (rc)
> >> +			goto cleanup;
> >> +	}
> >> +
> >> +	return 0;
> >> +
> >> +cleanup:
> >> +	/*
> >> +	 * Try unrolling the firmware state changes by
> >> +	 * reclaiming the pages which were already changed to the
> >> +	 * firmware state.
> >> +	 */
> >> +	snp_reclaim_pages(paddr, n, locked);
> >> +
> >> +	return rc;
> >> +}
> >> +

