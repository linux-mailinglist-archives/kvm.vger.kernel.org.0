Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 956516488DF
	for <lists+kvm@lfdr.de>; Fri,  9 Dec 2022 20:15:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbiLITPl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Dec 2022 14:15:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbiLITPj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Dec 2022 14:15:39 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 847C426AB1
        for <kvm@vger.kernel.org>; Fri,  9 Dec 2022 11:15:38 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id o8-20020a6548c8000000b0047927da1501so673069pgs.18
        for <kvm@vger.kernel.org>; Fri, 09 Dec 2022 11:15:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=zhH0oDn03Su15RrfmiRJ6OPST52/3p/eRjSa0ENEnMA=;
        b=jfqtSHeX0FVHW8t6gJgWpd21IAtYvgxTU3eW5MA/Co883kzdJClQoXfmdHDHc6gqi8
         6XKbOQOKRU8YMQ0ZZSXdhirEJpP8Gh7H3anCV41rHYCPoc44GOjXIQWQSklb4JtIlBvK
         B4hvCW6/MMcYacbylCE3wqvtbD4YYkODe0GmVDlaXRBna98bGa2xEFj+OhkvNX0WHS9K
         OEHznBG0nBoZSZspKGQIDO9eusiDZyX5X6OYHPe48hE3DNfnQYuyIFTnWWfEFeVT7o4q
         m6HMfpPVgmLUIvE41kbdh+N5GNZ7/TTw+lbpsHvd1yFuCC8+2kw26uGk78TR6DT+6OAM
         TFqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zhH0oDn03Su15RrfmiRJ6OPST52/3p/eRjSa0ENEnMA=;
        b=xWiE6Eyww+tNDMSDhHwIgytSLZDJK+/fceik6T8o0dM2K8QgJNtrAss+CPschchc82
         iua2HaphtUU+Ndlb5aZR7cnnFmuxUnG4jcmVIZPoVcLOVQ40cpfwtdKsZEwEI8OEJskd
         9QOlD2nln7SrcXn9Ry/oSm2BrNyBCWP5P9Vs4Yc6qClYpIyJGcX/UUTJbju/0Ox8/irV
         nboX8OCWZzFYn4HEKv2Vu0RPOtz8WZ0IA9LUhyRJwtEAAKd/Qkvv9eyRh0Mn6SQyKLzz
         el0G9Sj77CxGvf08Jl8Z14shKMcnuIpNOIimTN2PxjjOw1dcsaClT7WZ5uOWJ/hgq8Xc
         ECXA==
X-Gm-Message-State: ANoB5pkGuegp012M+EjYJPqItUNJP1hp6Ax+K9rQtI8Rp3qpgR52a5+I
        FczacvrfxDJEYtpUKSA/M86ijCKgRqHKBDlCDQ==
X-Google-Smtp-Source: AA0mqf4b8sAMBJ9sciFgRUXmabqkUDyuiODuiCmUhbeC9sM3eChNaYkUckgG4FAVaPsvb2ZHBIqHnoIS3NKZBMQ28w==
X-Received: from ackerleytng-cloudtop.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1f5f])
 (user=ackerleytng job=sendgmr) by 2002:a17:90a:7064:b0:220:1f03:129b with
 SMTP id f91-20020a17090a706400b002201f03129bmr15686pjk.0.1670613337554; Fri,
 09 Dec 2022 11:15:37 -0800 (PST)
Date:   Fri, 09 Dec 2022 11:15:35 -0800
In-Reply-To: <fb337a67e17715977e46523d1344cb2a7f46a37a.1667110240.git.isaku.yamahata@intel.com>
Mime-Version: 1.0
Message-ID: <diqz4ju4wfqg.fsf@google.com>
Subject: Re: [PATCH v10 016/108] KVM: TDX: create/destroy VM structure
From:   Ackerley Tng <ackerleytng@google.com>
To:     isaku.yamahata@intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        pbonzini@redhat.com, erdemaktas@google.com, seanjc@google.com,
        sagis@google.com, dmatlack@google.com,
        sean.j.christopherson@intel.com, kai.huang@intel.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


In tdx_vm_init, it is possible to have a double-reclaim, which
eventually causes a host crash. I have a selftest that reliably
reproduces this, and I believe the problem is that withiin
tdx_vm_free(), we don't reset kvm->tdcs = NULL and kvm->tdr.added to
false.

> +int tdx_vm_init(struct kvm *kvm)
> +{
> +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> +	cpumask_var_t packages;
> +	int ret, i;
> +	u64 err;
> +
> +	ret = tdx_keyid_alloc();
> +	if (ret < 0)
> +		return ret;
> +	kvm_tdx->hkid = ret;
> +
> +	ret = tdx_alloc_td_page(&kvm_tdx->tdr);
> +	if (ret)
> +		goto free_hkid;
> +
> +	kvm_tdx->tdcs = kcalloc(tdx_caps.tdcs_nr_pages, sizeof(*kvm_tdx->tdcs),
> +				GFP_KERNEL_ACCOUNT | __GFP_ZERO);
> +	if (!kvm_tdx->tdcs)
> +		goto free_tdr;
> +	for (i = 0; i < tdx_caps.tdcs_nr_pages; i++) {
> +		ret = tdx_alloc_td_page(&kvm_tdx->tdcs[i]);
> +		if (ret)
> +			goto free_tdcs;
> +	}
> +
> +	if (!zalloc_cpumask_var(&packages, GFP_KERNEL)) {
> +		ret = -ENOMEM;
> +		goto free_tdcs;
> +	}
> +	cpus_read_lock();
> +	/*
> +	 * Need at least one CPU of the package to be online in order to
> +	 * program all packages for host key id.  Check it.
> +	 */
> +	for_each_present_cpu(i)
> +		cpumask_set_cpu(topology_physical_package_id(i), packages);
> +	for_each_online_cpu(i)
> +		cpumask_clear_cpu(topology_physical_package_id(i), packages);
> +	if (!cpumask_empty(packages)) {
> +		ret = -EIO;
> +		/*
> +		 * Because it's hard for human operator to figure out the
> +		 * reason, warn it.
> +		 */
> +		pr_warn("All packages need to have online CPU to create TD. Online CPU  
> and retry.\n");
> +		goto free_packages;
> +	}
> +
> +	/*
> +	 * Acquire global lock to avoid TDX_OPERAND_BUSY:
> +	 * TDH.MNG.CREATE and other APIs try to lock the global Key Owner
> +	 * Table (KOT) to track the assigned TDX private HKID.  It doesn't spin
> +	 * to acquire the lock, returns TDX_OPERAND_BUSY instead, and let the
> +	 * caller to handle the contention.  This is because of time limitation
> +	 * usable inside the TDX module and OS/VMM knows better about process
> +	 * scheduling.
> +	 *
> +	 * APIs to acquire the lock of KOT:
> +	 * TDH.MNG.CREATE, TDH.MNG.KEY.FREEID, TDH.MNG.VPFLUSHDONE, and
> +	 * TDH.PHYMEM.CACHE.WB.
> +	 */
> +	mutex_lock(&tdx_lock);
> +	err = tdh_mng_create(kvm_tdx->tdr.pa, kvm_tdx->hkid);
> +	mutex_unlock(&tdx_lock);
> +	if (WARN_ON_ONCE(err)) {
> +		pr_tdx_error(TDH_MNG_CREATE, err, NULL);
> +		ret = -EIO;
> +		goto free_packages;
> +	}
> +	tdx_mark_td_page_added(&kvm_tdx->tdr);
> +
> +	for_each_online_cpu(i) {
> +		int pkg = topology_physical_package_id(i);
> +
> +		if (cpumask_test_and_set_cpu(pkg, packages))
> +			continue;
> +
> +		/*
> +		 * Program the memory controller in the package with an
> +		 * encryption key associated to a TDX private host key id
> +		 * assigned to this TDR.  Concurrent operations on same memory
> +		 * controller results in TDX_OPERAND_BUSY.  Avoid this race by
> +		 * mutex.
> +		 */
> +		mutex_lock(&tdx_mng_key_config_lock[pkg]);
> +		ret = smp_call_on_cpu(i, tdx_do_tdh_mng_key_config,
> +				      &kvm_tdx->tdr.pa, true);
> +		mutex_unlock(&tdx_mng_key_config_lock[pkg]);
> +		if (ret)
> +			break;
> +	}
> +	cpus_read_unlock();
> +	free_cpumask_var(packages);
> +	if (ret)
> +		goto teardown;
> +
> +	for (i = 0; i < tdx_caps.tdcs_nr_pages; i++) {
> +		err = tdh_mng_addcx(kvm_tdx->tdr.pa, kvm_tdx->tdcs[i].pa);
> +		if (WARN_ON_ONCE(err)) {
> +			pr_tdx_error(TDH_MNG_ADDCX, err, NULL);
> +			ret = -EIO;
> +			goto teardown;
> +		}
> +		tdx_mark_td_page_added(&kvm_tdx->tdcs[i]);
> +	}
> +
> +	/*
> +	 * Note, TDH_MNG_INIT cannot be invoked here.  TDH_MNG_INIT requires a  
> dedicated
> +	 * ioctl() to define the configure CPUID values for the TD.
> +	 */
> +	return 0;
> +
> +	/*
> +	 * The sequence for freeing resources from a partially initialized TD
> +	 * varies based on where in the initialization flow failure occurred.
> +	 * Simply use the full teardown and destroy, which naturally play nice
> +	 * with partial initialization.
> +	 */
> +teardown:
> +	tdx_mmu_release_hkid(kvm);
> +	tdx_vm_free(kvm);
> +	return ret;

If there is some error that causes an exit through teardown,
tdx_vm_free() will be called, which causes the resources to be
freed. However, tdx_vm_free() is called a second time when the selftest
(or qemu) exits, which causes a second reclaim to be performed.

> +
> +free_packages:
> +	cpus_read_unlock();
> +	free_cpumask_var(packages);
> +free_tdcs:
> +	for (i = 0; i < tdx_caps.tdcs_nr_pages; i++) {
> +		if (!kvm_tdx->tdcs[i].va)
> +			continue;
> +		free_page(kvm_tdx->tdcs[i].va);
> +	}
> +	kfree(kvm_tdx->tdcs);
> +	kvm_tdx->tdcs = NULL;
> +free_tdr:
> +	if (kvm_tdx->tdr.va) {
> +		free_page(kvm_tdx->tdr.va);
> +		kvm_tdx->tdr.added = false;
> +		kvm_tdx->tdr.va = 0;
> +		kvm_tdx->tdr.pa = 0;
> +	}
> +free_hkid:
> +	if (kvm_tdx->hkid != -1)
> +		tdx_hkid_free(kvm_tdx);
> +	return ret;
> +}

The second reclaim is performed because kvm_tdx->tdcs is still set, and
kvm_tdx->tdr.added is still set, so the second two if blocks in
tdx_vm_free() are executed.

> +void tdx_vm_free(struct kvm *kvm)
> +{
> +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> +	int i;
> +
> +	/* Can't reclaim or free TD pages if teardown failed. */
> +	if (is_hkid_assigned(kvm_tdx))
> +		return;
> +
> +	if (kvm_tdx->tdcs) {
> +		for (i = 0; i < tdx_caps.tdcs_nr_pages; i++)
> +			tdx_reclaim_td_page(&kvm_tdx->tdcs[i]);
> +		kfree(kvm_tdx->tdcs);
> +	}
> +
> +	/*
> +	 * TDX module maps TDR with TDX global HKID.  TDX module may access TDR
> +	 * while operating on TD (Especially reclaiming TDCS).  Cache flush with
> +	 * TDX global HKID is needed.
> +	 */
> +	if (kvm_tdx->tdr.added &&
> +		tdx_reclaim_page(kvm_tdx->tdr.va, kvm_tdx->tdr.pa, true,
> +				tdx_global_keyid))
> +		return;
> +
> +	free_page(kvm_tdx->tdr.va);
> +}

Here's the fix that stopped the crash I was observing

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 2e7916fb72a7..41d1ff1510c3 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -405,6 +405,7 @@ void tdx_vm_free(struct kvm *kvm)
                 for (i = 0; i < tdx_caps.tdcs_nr_pages; i++)
                         tdx_reclaim_td_page(&kvm_tdx->tdcs[i]);
                 kfree(kvm_tdx->tdcs);
+               kvm_tdx->tdcs = NULL;
         }

         /*
@@ -418,6 +419,9 @@ void tdx_vm_free(struct kvm *kvm)
                 return;

         free_page(kvm_tdx->tdr.va);
+       kvm_tdx->tdr.added = false;
+       kvm_tdx->tdr.va = 0;
+       kvm_tdx->tdr.pa = 0;
  }

  static int tdx_do_tdh_mng_key_config(void *param)
