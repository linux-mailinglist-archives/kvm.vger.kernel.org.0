Return-Path: <kvm+bounces-13473-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B27A3897446
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 17:44:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D1792B28F9D
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 15:37:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49E8E14A4EE;
	Wed,  3 Apr 2024 15:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ie2IcwL4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E112B149E14;
	Wed,  3 Apr 2024 15:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712158662; cv=none; b=XlUdXbaAAmmu+8lOjMCPNH5r2bRtkFZGaH3rbs76MKq3YY2r7TZGQ/qLWmnDBVO7Qku+QgGLvFHhduEuxTMuqPKSjfWTlRGmYkn6JDJg9OYiUauIZaxWUJR1ZzyZDkCFbNZEHfxVFR2U9m+XQWN7en/RLTXxWJ4PkIz/VAg1wvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712158662; c=relaxed/simple;
	bh=QJChaVAp28BDDX83PqbBHFkbmbYUNuu15HZqdJSXkew=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Yq+ouACWrd9a+RGUo2tgQN4iuxguQskAXobLtP1F5hoTV4bCjOD245qUwUyCgc96CRB8uuoRl7uuYEmW4VKSMuXptFKddGzsPFWQQZawGYnO15LXGyGU1ROYOGzwJb/fQ4fNske1nSsZYkM317KtPqRw+A2kz+g6NNp4GTFo76M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ie2IcwL4; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712158661; x=1743694661;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=QJChaVAp28BDDX83PqbBHFkbmbYUNuu15HZqdJSXkew=;
  b=Ie2IcwL4Q7B8mbHEdOUHjfU5XEkJY4D9o82CDnKqJXJlHNX85xbZuZIP
   HYPbaGjZ0SL/U0juSHptSQN+aC3gbFnojAZ2KQvCYK+5ag9iFbjOrseaK
   cNDe25mf0o/Jn7po8OEslU0kdKbUA0AygEnLmQW7+KTLvpphDVRbBKOJa
   nYlK/43Ye28L1BOsl2vXBuivCVN/0vexCfSPyo0uEksXaFBENaRZwvBhI
   9Tpm1RQxZo+UVMVUimVYHAIfslJmy1Vvbal+VGVaomTcvuKx3ASBuIlaz
   /anQR21aEr9eFH2/QLO6aOHR9Q9ZqFJo3FZbePgoiGODkE48aq/08b2mQ
   Q==;
X-CSE-ConnectionGUID: zCWnttiTQKuBUbaTiDKWKg==
X-CSE-MsgGUID: Dwvx7rT+R2WHlCOQbFq50w==
X-IronPort-AV: E=McAfee;i="6600,9927,11033"; a="7978851"
X-IronPort-AV: E=Sophos;i="6.07,177,1708416000"; 
   d="scan'208";a="7978851"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2024 08:37:40 -0700
X-CSE-ConnectionGUID: C9r8JNIGTH6X/XyVwhZi2g==
X-CSE-MsgGUID: 1aG80udaTneHuT7+mWUbTQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,177,1708416000"; 
   d="scan'208";a="23177428"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2024 08:37:39 -0700
Date: Wed, 3 Apr 2024 08:37:38 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Isaku Yamahata <isaku.yamahata@intel.com>,
	Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org,
	linux-coco@lists.linux.dev, linux-mm@kvack.org,
	linux-crypto@vger.kernel.org, x86@kernel.org,
	linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
	jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
	ardb@kernel.org, seanjc@google.com, vkuznets@redhat.com,
	jmattson@google.com, luto@kernel.org, dave.hansen@linux.intel.com,
	slp@redhat.com, pgonda@google.com, peterz@infradead.org,
	srinivas.pandruvada@linux.intel.com, rientjes@google.com,
	dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de, vbabka@suse.cz,
	kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com,
	sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
	jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com,
	pankaj.gupta@amd.com, liam.merwick@oracle.com,
	Brijesh Singh <brijesh.singh@amd.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Binbin Wu <binbin.wu@linux.intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>, isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v12 11/29] KVM: SEV: Add KVM_SEV_SNP_LAUNCH_UPDATE command
Message-ID: <20240403153738.GC2444378@ls.amr.corp.intel.com>
References: <20240329225835.400662-1-michael.roth@amd.com>
 <20240329225835.400662-12-michael.roth@amd.com>
 <8c3685a6-833c-4b3c-83f4-c0bd78bba36e@redhat.com>
 <20240401222229.qpnpozdsr6b2sntk@amd.com>
 <20240402225840.GB2444378@ls.amr.corp.intel.com>
 <CABgObfb4fQpUTzhpX9Bkcu0_+bOcCSCtuy+5-rttTLm-bY8i2w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABgObfb4fQpUTzhpX9Bkcu0_+bOcCSCtuy+5-rttTLm-bY8i2w@mail.gmail.com>

On Wed, Apr 03, 2024 at 02:51:59PM +0200,
Paolo Bonzini <pbonzini@redhat.com> wrote:

> On Wed, Apr 3, 2024 at 12:58 AM Isaku Yamahata <isaku.yamahata@intel.com> wrote:
> > I think TDX can use it with slight change. Pass vcpu instead of KVM, page pin
> > down and mmu_lock.  TDX requires non-leaf Secure page tables to be populated
> > before adding a leaf.  Maybe with the assumption that vcpu doesn't run, GFN->PFN
> > relation is stable so that mmu_lock isn't needed? What about punch hole?
> >
> > The flow would be something like as follows.
> >
> > - lock slots_lock
> >
> > - kvm_gmem_populate(vcpu)
> >   - pin down source page instead of do_memcopy.
> 
> Both pinning the source page and the memcpy can be done in the
> callback.  I think the right thing to do is:
> 
> 1) eliminate do_memcpy, letting AMD code taking care of
>    copy_from_user.
> 
> 2) pass to the callback only gfn/pfn/src, where src is computed as
> 
>     args->src ? args->src + i * PAGE_SIZE : NULL
> 
> If another architecture/vendor needs do_memcpy, they can add
> something like kvm_gmem_populate_copy.
> 
> >   - get pfn with __kvm_gmem_get_pfn()
> >   - read lock mmu_lock
> >   - in the post_populate callback
> >     - lookup tdp mmu page table to check if the table is populated.
> >       lookup only version of kvm_tdp_mmu_map().
> >       We need vcpu instead of kvm.
> 
> Passing vcpu can be done using the opaque callback argument to
> kvm_gmem_populate.
> 
> Likewise, the mmu_lock can be taken by the TDX post_populate
> callback.

Yes, it should work.  Let me give it a try.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

