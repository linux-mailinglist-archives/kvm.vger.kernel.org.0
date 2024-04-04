Return-Path: <kvm+bounces-13618-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CFAA4899154
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 00:31:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 84D031F23B17
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 22:31:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BBC46F066;
	Thu,  4 Apr 2024 22:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="J9NYB2uP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C90512E71;
	Thu,  4 Apr 2024 22:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712269868; cv=none; b=gYQrCbYh18YnGMSQ5qUf4el1S8ZOuz2MrrEu88h7+ZYHYLOIxX1k+D/qQnzM0FD8pUhDRUn4mHDHt32mNyYQ1fvamBWjOO+j8jW2Z2g7IuHoYu9PsrJQ/MMJ9D3ewKJt9sxNh6n8UL4pfmTaOpAeO736wQly3yz62++HH2+X2sU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712269868; c=relaxed/simple;
	bh=AQpAgM1DagYMJg1fnpZvTj9AAHHiJDRQZ2gyDukS6s8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mdo/Sh3FZIvyWPJUN9veXObVc+DdSj6BIImlx1CruXpmPRNdTE3jij719XcpSHJUPF7mxCqGrCXFnzDyFxQNw6LhI/c+9eGvXVonR7L3U/vCGa70hVYoP0ITc7lZh8tWpiwO8/3q9Isqgf+CY50W0MCjJGF3DDvwgpmg2PJjpmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=J9NYB2uP; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712269864; x=1743805864;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=AQpAgM1DagYMJg1fnpZvTj9AAHHiJDRQZ2gyDukS6s8=;
  b=J9NYB2uP3A97eCxsqSXohcaEv6NPhCx1XC1od6v/wf3w8j6rqLPc2cY9
   PhyPYxDNmHvOYNNF/Jk4fpx5kur4nXXFjaCbTtxaeb+Cr46HHXDilARw1
   9m0ZQN551QpenhVa0V/thc3rH9ow7sZsWKoBlNGGmiiXpWgcsvVg6Aixk
   roOfiXUgpafA6UEcvj9d2ZjFY1TGjZ6PgXdMm/oT9B8R8LTY48aNHrykT
   vubKryP+lolzLaVmjRmoQstqhaxFjw+cHYzcEY6BtjRz9Q6HcfQWBa8cD
   zZabTgSiLb3Ml8qrnlpA4EQ6vzVpWzGDDaOGxP+5fUxNUg3WTlwtqZue8
   w==;
X-CSE-ConnectionGUID: k6rI8D9eRt6iFqVZ+YJlCg==
X-CSE-MsgGUID: P8T5J3kpSSWd4Weq8gZYdw==
X-IronPort-AV: E=McAfee;i="6600,9927,11034"; a="7822622"
X-IronPort-AV: E=Sophos;i="6.07,180,1708416000"; 
   d="scan'208";a="7822622"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2024 15:31:04 -0700
X-CSE-ConnectionGUID: cs1P56iWS/6Z5etnMLbN5Q==
X-CSE-MsgGUID: TdvMaUo4TDm7zpWVR0ubpQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,180,1708416000"; 
   d="scan'208";a="19395148"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2024 15:31:03 -0700
Date: Thu, 4 Apr 2024 15:31:02 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"Gao, Chao" <chao.gao@intel.com>,
	"Zhang, Tina" <tina.zhang@intel.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"Huang, Kai" <kai.huang@intel.com>, "Chen, Bo2" <chen.bo@intel.com>,
	"sagis@google.com" <sagis@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"Yuan, Hang" <hang.yuan@intel.com>,
	"Aktas, Erdem" <erdemaktas@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"isaku.yamahata@linux.intel.com" <isaku.yamahata@linux.intel.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>
Subject: Re: [PATCH v19 018/130] KVM: x86/mmu: Assume guest MMIOs are shared
Message-ID: <20240404223102.GT2444378@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <b2e5c92fd66a0113b472dd602220346d3d435732.1708933498.git.isaku.yamahata@intel.com>
 <3c51ec38e523db291ecc914805e0a51208e9ca9f.camel@intel.com>
 <20240327172227.GE2444378@ls.amr.corp.intel.com>
 <f7d0a8475c9d2e18a12f9da286163c75b11282a8.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f7d0a8475c9d2e18a12f9da286163c75b11282a8.camel@intel.com>

On Wed, Mar 27, 2024 at 05:27:52PM +0000,
"Edgecombe, Rick P" <rick.p.edgecombe@intel.com> wrote:

> On Wed, 2024-03-27 at 10:22 -0700, Isaku Yamahata wrote:
> > On Mon, Mar 25, 2024 at 11:41:56PM +0000,
> > "Edgecombe, Rick P" <rick.p.edgecombe@intel.com> wrote:
> > 
> > > On Mon, 2024-02-26 at 00:25 -0800, isaku.yamahata@intel.com wrote:
> > > > From: Chao Gao <chao.gao@intel.com>
> > > > 
> > > > TODO: Drop this patch once the common patch is merged.
> > > 
> > > What is this TODO talking about?
> > 
> > https://lore.kernel.org/all/ZcUO5sFEAIH68JIA@google.com/
> > 
> > This patch was shot down and need to fix it in guest side. TDVF.
> 
> It needs a firmware fix? Is there any firmware that works (boot any TD) with this patch missing?

Yes.  Config-B (OvmfPkg/IntelTdx/IntelTdxX64.dsc) works for me without this patch.
I'm looking into config-A(OvmfPkg/OvmfPkgX64.dsc) now.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

