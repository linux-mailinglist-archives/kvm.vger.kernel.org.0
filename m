Return-Path: <kvm+bounces-25488-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E7698965D28
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 11:40:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 91F351F2404F
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 09:40:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1554175D27;
	Fri, 30 Aug 2024 09:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Mngs+Txj"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 137991B813;
	Fri, 30 Aug 2024 09:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725010844; cv=none; b=tNHoYYc4tWdjivHJVfeGSUOnnabgxPYyd85OyN5AtVclINesfuIOTBrKiADggKllO5/kaImbkvTCksARcfuxHbfenCMYQ8dvqmwEXbDO5Tltf8ypeLoipv92Z/P2YOvX2k671SAQEWuuluWq2X12oCQRdzUhq33rogqL5RAcaqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725010844; c=relaxed/simple;
	bh=VeRHZcyQioypojD697TKsqrUCI2DJnsnCk+RuNMdkqM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pQSLfGmxMeRZ1ffov9ehTqSVDlWxa1Iuewj/TM1jBmfzVnqcAy/4s9aYMZ2XP0e1pTN4DSwnjbpQhylS1lWYQbWlq01/a5G0tuThsIFMZZClJnuJRn3CSaQ3X3rmTcUbLUZ3/Oec0tgNMiCmQ1uerzT+zP8uNbg+68rfgu3RZCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Mngs+Txj; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725010842; x=1756546842;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=VeRHZcyQioypojD697TKsqrUCI2DJnsnCk+RuNMdkqM=;
  b=Mngs+TxjlF9nm6rkDes1mY5rVFDtzydq7DNeOL37yCX0yK8lznHiN0Pr
   VktffZqYirewu2n+0SOMNlHX6C6enWb0tXYtTxQ/+SPJdJbmd0tCttd9c
   Hjc8vIBhypfcQCwBn9KOTK90MHqLw6Un+WJ4CLm5y+FRD2kpN1f4XvxP2
   zHdvfP5a1kq/wABx557j2EIzKoaF11tzL7PepP8uOf+a0rT42D3cx9YAw
   WCogVUZFZfvaXqdGEf6p8TNkOAOT9Yqwia/e7aHy2wM7idMa6mjFxHJkT
   CAE1L3Yu7cucXKZWjZEs32shR1lygMvDxKnYP4anVB21jThp73FIqg+3+
   Q==;
X-CSE-ConnectionGUID: zVv4eHprSNCh1Cn1ikGj/Q==
X-CSE-MsgGUID: 6ZhCjGWdRaasu9aOev8fNw==
X-IronPort-AV: E=McAfee;i="6700,10204,11179"; a="26540850"
X-IronPort-AV: E=Sophos;i="6.10,188,1719903600"; 
   d="scan'208";a="26540850"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2024 02:40:41 -0700
X-CSE-ConnectionGUID: fHGeEDbHS1qoGB2b9ouMvQ==
X-CSE-MsgGUID: lVfD84pxRcSqI86ah845aQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,188,1719903600"; 
   d="scan'208";a="94581473"
Received: from sschumil-mobl2.ger.corp.intel.com (HELO tlindgre-MOBL1) ([10.245.246.63])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2024 02:40:36 -0700
Date: Fri, 30 Aug 2024 12:40:31 +0300
From: Tony Lindgren <tony.lindgren@linux.intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "seanjc@google.com" <seanjc@google.com>,
	"Huang, Kai" <kai.huang@intel.com>,
	"Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"nik.borisov@suse.com" <nik.borisov@suse.com>,
	"sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
	"Wang, Wei W" <wei.w.wang@intel.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH 13/25] KVM: TDX: create/destroy VM structure
Message-ID: <ZtGTj40bKDVss_Mv@tlindgre-MOBL1>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-14-rick.p.edgecombe@intel.com>
 <e7c16241-100a-4830-9628-65edb44ca78d@suse.com>
 <850ef710eac95a5c36863c94e1b31a8090eb8a2a.camel@intel.com>
 <ZsV9qouTem-ynGJA@tlindgre-MOBL1>
 <0e283ec8bfee66c01f49529f924a0a8c43d22657.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0e283ec8bfee66c01f49529f924a0a8c43d22657.camel@intel.com>

On Wed, Aug 21, 2024 at 04:52:14PM +0000, Edgecombe, Rick P wrote:
> On Wed, 2024-08-21 at 08:39 +0300, Tony Lindgren wrote:
> > > Hmm, we would have to make SEAMCALLs to spin on that lock, where as mutexes
> > > can
> > > sleep. I suspect that is where it came from. But we are trying to make the
> > > code
> > > simple and obviously correct and add optimizations later. This might fit
> > > that
> > > pattern, especially since it is just used during VM creation and teardown.
> > 
> > For handling the busy retries for SEAMCALL callers, we could just use
> > iopoll.h read_poll_timeout(). I think it can handle toggling the resume
> > bit while looping, need to test that though. See for example the
> > smp_func_do_phymem_cache_wb() for toggling the resume variable.
> 
> Nice. It seems worth trying to me.

To recap on this, using iopoll for smp_func_do_phymem_cache_wb() would look like:

static void smp_func_do_phymem_cache_wb(void *unused)
{
	u64 status = 0;
	int err;

	err = read_poll_timeout_atomic(tdh_phymem_cache_wb, status,
				       status != TDX_INTERRUPTED_RESUMABLE,
				       1, 1000, 0, !!status);
	if (WARN_ON_ONCE(err)) {
		pr_err("TDH_PHYMEM_CACHE_WB timed out: 0x%llx\n", status);
		return;
	}
	...
}

For the retry flag toggling with the !!status, I think it's best to add a TDX
specific tdx_read_poll_timeout_atomic() macro.

Regards,

Tony

