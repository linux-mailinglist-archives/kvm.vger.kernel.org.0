Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8B8D5A544F
	for <lists+kvm@lfdr.de>; Mon, 29 Aug 2022 21:09:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbiH2TJZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Aug 2022 15:09:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbiH2TJY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Aug 2022 15:09:24 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58E617AC09;
        Mon, 29 Aug 2022 12:09:23 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id l5so5056621pjy.5;
        Mon, 29 Aug 2022 12:09:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc;
        bh=cfmb1zJQb4P8nS9UVXY3vadt9QKpz35dWWab4VBTe5g=;
        b=eewllUcRDimvGxtSNXvVwVDhONHY1S9FHNq13C+rnoMxoTM2b6W53A8ynwQAm/Md1N
         zn1zcL3HEceSDD3r8zCzkpxI2pdPA2qbgDk4shHB+sc/6X7J80hf0eh6MWWDS9z0Ot4N
         J2X+eXEn9P3/Zfw3Asr/Ow4cFMjmVA1+O9TVscqUSxkTECT/G6s0HF8PSIWAhXg1qOMQ
         M3krIA/62JL5kprKwjrO8PYlO5T00yjvoF1T3PInIUe3k1jJ2E1V4d3A/ATaVDIms3jK
         28Ktogc/qUWxQxKfH7yRAbISlpEEsK4bJjS1qw5GmxufDwcUEx3oCF3Fw3aNmOpoBYzA
         UZYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc;
        bh=cfmb1zJQb4P8nS9UVXY3vadt9QKpz35dWWab4VBTe5g=;
        b=l0DgfWCYz0q8LG5/I7uk2ID6ehffoqJbI/B4Aj+TV+AePnVE0KN8tbvsBkRdfZnZpD
         fNz0d3sx1nFbqKA4Vc+FgXgIhq/0l6IJAdehCkv98b/YjEMjPeOYLb1tvTul6HNe03W4
         hrfzXbqJztdYSinI0fK/vX6B36as4EcOe0RnUbCAbBrcmeXoQDVbZ4hIWCIPG7lAda+8
         jDmsLg2HWLSPx92ebIP48ksVhtm75gJRzFHHXj4g7MUOb7uFQ8zS83kqXeNLVWHKcurn
         6/5hhTj/zTdqWUM489I4fxaKDlkhT72CDDjZkIqSu7Ups665cSy2lxRa7wmP9hCB9xAr
         9r6Q==
X-Gm-Message-State: ACgBeo1g3BKw53RM6y/yGxbQGZDevmFk7qXZ2jah9GCRUu1D1++JPcrg
        kW2OnuYQTdoChpt2Wfk93Yw=
X-Google-Smtp-Source: AA6agR52DU8oH4njUGFDcxocnITrzFA+6RLHoPIt8c0Ae1VN77jlYi9msIaNLWlDSaxFEGbzCQfIDw==
X-Received: by 2002:a17:90a:bb96:b0:1fd:8068:cfd4 with SMTP id v22-20020a17090abb9600b001fd8068cfd4mr15072569pjr.114.1661800162763;
        Mon, 29 Aug 2022 12:09:22 -0700 (PDT)
Received: from localhost ([192.55.55.51])
        by smtp.gmail.com with ESMTPSA id b84-20020a621b57000000b0052ddaffbcc1sm7532937pfb.30.2022.08.29.12.09.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Aug 2022 12:09:22 -0700 (PDT)
Date:   Mon, 29 Aug 2022 12:09:21 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Binbin Wu <binbin.wu@linux.intel.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: Re: [PATCH v8 020/103] KVM: TDX: create/destroy VM structure
Message-ID: <20220829190921.GA2700446@ls.amr.corp.intel.com>
References: <cover.1659854790.git.isaku.yamahata@intel.com>
 <810ce6dbd0330f06a80e05afa0a068b5f5b332f3.1659854790.git.isaku.yamahata@intel.com>
 <bd9ae0af-47de-c8ea-3880-a98fed2de48d@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <bd9ae0af-47de-c8ea-3880-a98fed2de48d@linux.intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Aug 27, 2022 at 11:52:39AM +0800,
Binbin Wu <binbin.wu@linux.intel.com> wrote:

> > +static void tdx_clear_page(unsigned long page)
> > +{
> > +	const void *zero_page = (const void *) __va(page_to_phys(ZERO_PAGE(0)));
> > +	unsigned long i;
> > +
> > +	/*
> > +	 * Zeroing the page is only necessary for systems with MKTME-i:
> > +	 * when re-assign one page from old keyid to a new keyid, MOVDIR64B is
> > +	 * required to clear/write the page with new keyid to prevent integrity
> > +	 * error when read on the page with new keyid.
> > +	 */
> > +	if (!static_cpu_has(X86_FEATURE_MOVDIR64B))
> > +		return;
> 
> TDX relies on MKTME, and MOVDIR64B is a must have feature. The check should
> not fail at this point?
> 
> It feels a bit strange to check the feature here and return siliently if the
> check failed.

Makes sense. This code is carried from the early devel phase.  I'll move this
check to tdx module initialization.


> > +
> > +	for (i = 0; i < 4096; i += 64)
> > +		/* MOVDIR64B [rdx], es:rdi */
> > +		asm (".byte 0x66, 0x0f, 0x38, 0xf8, 0x3a"
> > +		     : : "d" (zero_page), "D" (page + i) : "memory");
> 
> There is already have a inline function movdir64b defined in
> arch/x86/include/asm/special_insns.h, can we use it directly here?

Sure I'll use the function.


> > +}
> > +
> > +static int tdx_reclaim_page(unsigned long va, hpa_t pa, bool do_wb, u16 hkid)
> > +{
> > +	struct tdx_module_output out;
> > +	u64 err;
> > +
> > +	err = tdh_phymem_page_reclaim(pa, &out);
> > +	if (WARN_ON_ONCE(err)) {
> > +		pr_tdx_error(TDH_PHYMEM_PAGE_RECLAIM, err, &out);
> > +		return -EIO;
> > +	}
> > +
> > +	if (do_wb) {
> > +		err = tdh_phymem_page_wbinvd(set_hkid_to_hpa(pa, hkid));
> > +		if (WARN_ON_ONCE(err)) {
> > +			pr_tdx_error(TDH_PHYMEM_PAGE_WBINVD, err, NULL);
> > +			return -EIO;
> > +		}
> > +	}
> > +
> > +	tdx_clear_page(va);
> 
> Is it really necessary to clear the reclaimed page using MOVDIR64?
> 
> According to the TDX module spec,  when add a page to TD, both for control
> structures and TD private memory, during the process some function of the
> TDX module will initialize the page using binding hkid and direct write
> (MOVDIR64B).
> 
> So still need to clear the page using direct write to avoid integrity error
> when re-assign one page from old keyid to a new keyid as you mentioned in
> the comment?

Yes. As you described above, TDX module does when assining a page to a private
hkid. i.e. TDH.MEM.PAGE.{ADD, AUG}.  But when re-assigning a page from an old
private hkid to a new _shared_ hkid, i.e. TDH.MEM.PAGE.REMOVE or
TDH.PHYMEM.PAGE.RECLAIM, TDX module doesn't.


> > +void tdx_mmu_release_hkid(struct kvm *kvm)
> > +{
> > +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> > +	cpumask_var_t packages;
> > +	bool cpumask_allocated;
> > +	u64 err;
> > +	int ret;
> > +	int i;
> > +
> > +	if (!is_hkid_assigned(kvm_tdx))
> > +		return;
> > +
> > +	if (!is_td_created(kvm_tdx))
> > +		goto free_hkid;
> > +
> > +	cpumask_allocated = zalloc_cpumask_var(&packages, GFP_KERNEL);
> > +	cpus_read_lock();
> > +	for_each_online_cpu(i) {
> > +		if (cpumask_allocated &&
> > +			cpumask_test_and_set_cpu(topology_physical_package_id(i),
> > +						packages))
> > +			continue;
> > +
> > +		/*
> > +		 * We can destroy multiple the guest TDs simultaneously.
> > +		 * Prevent tdh_phymem_cache_wb from returning TDX_BUSY by
> > +		 * serialization.
> > +		 */
> > +		mutex_lock(&tdx_lock);
> > +		ret = smp_call_on_cpu(i, tdx_do_tdh_phymem_cache_wb, NULL, 1);
> > +		mutex_unlock(&tdx_lock);
> > +		if (ret)
> > +			break;
> > +	}
> > +	cpus_read_unlock();
> > +	free_cpumask_var(packages);
> > +
> > +	mutex_lock(&tdx_lock);
> > +	err = tdh_mng_key_freeid(kvm_tdx->tdr.pa);
> 
> According to the TDX module spec, there is a API called
> TDH.MNG.KEY.RECLAIMID, which is used to put the TD in blocked state.
> 
> I didn't see the API used in the patch. Is it not used or did I miss
> something?

In the public spec of TDX module of 344425-004US June 2022, table 2.4 says
"TDH.MNG.KEY.RECLAIMID 27 Does nothing; provided for backward compatibility"


> > +static int tdx_do_tdh_mng_key_config(void *param)
> > +{
> > +	hpa_t *tdr_p = param;
> > +	u64 err;
> > +
> > +	do {
> > +		err = tdh_mng_key_config(*tdr_p);
> > +
> > +		/*
> > +		 * If it failed to generate a random key, retry it because this
> > +		 * is typically caused by an entropy error of the CPU's random
> > +		 * number generator.
> > +		 */
> > +	} while (err == TDX_KEY_GENERATION_FAILED);
> 
> Is there any corner case that could lead to deadloop?

The error happens due to the lack of entropy of pconfig instruction.  If the
entropy on the platform could be drained constantly somehow, the dead loop could
be possible.  I think it's very unlikely.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
