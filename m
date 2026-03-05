Return-Path: <kvm+bounces-72788-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AO8aN/YJqWlc0gAAu9opvQ
	(envelope-from <kvm+bounces-72788-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 05:43:34 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B4D320AE1A
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 05:43:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 847233074118
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 04:42:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE7322749ED;
	Thu,  5 Mar 2026 04:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="N9uLVvgf"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06C0227A916;
	Thu,  5 Mar 2026 04:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772685748; cv=none; b=IpfSknXRBX87xjrc8ECR7GW84tsb34nlg8SvMM1ivOPR6klt2hMRbhtx8QlVpN2I8dkDzSCvpNuZGvrOyPB7YpbCNrsBbt68xd6s/RLE92j3Yj/j4BLPqt6GcGNXRD9s7w3c7pfMRUFqsAGmAsu5ds7mmNuNErFHmEagSVBrAIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772685748; c=relaxed/simple;
	bh=NLWgvlVt8wEdRkMYr465gb4yvlov99EASllX8462tlc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HpgAumVixqkZnTlb+ofxVpceAf69T4eFNy3h3b8nVorTd3NwHjdtv0UY99KkpEvJnsyjIjfHWjXc/ak0JROfZW1ZfV97NMUMM7mkPCx5bYYpwpgXuovvu2zqj7FOkFCb1tXSO9Qd5/JQnj+oS4VIA7O1JSHl/Wd6I3fQ7Uaun8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=N9uLVvgf; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772685747; x=1804221747;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=NLWgvlVt8wEdRkMYr465gb4yvlov99EASllX8462tlc=;
  b=N9uLVvgfAGz9Axh4+wVGqsWhgXpu0KGlhhaMrfifEqzdJTP+geylneFC
   7AayY7tfHfdVjd3zP9L4deOo136caXm2oH6aLPtMrgrEOVjns92zTrUNR
   rJnpRai/wgYSDyiDqz7UCxaHZTMeShBGjePOX4eozqzj35k+MwCB0w1ig
   n8UltvbYJByHYiTMAYy7MTZvdOkpVWOyhLsj8stlBujELKrCu13JLeNx6
   V5uFTJVKSxfVjUMnQLkVHx9fS4Fke3MoMjSCkbxglAQuGiG9iz933iQvx
   x4M1SSPFS65Ue6NRWLVEJDvHnCKzLmGco3knZHh5shbm45hePBWVqAwmn
   w==;
X-CSE-ConnectionGUID: panqRKz5R5mVkGVdk/N2lA==
X-CSE-MsgGUID: RhqEXcBhR92Gsw9pwfCsqg==
X-IronPort-AV: E=McAfee;i="6800,10657,11719"; a="84096919"
X-IronPort-AV: E=Sophos;i="6.21,325,1763452800"; 
   d="scan'208";a="84096919"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2026 20:42:27 -0800
X-CSE-ConnectionGUID: YcoNZ1GoRfiW8I1vhUQwkQ==
X-CSE-MsgGUID: F2espSgKR8i2QJRW1tYOeg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,325,1763452800"; 
   d="scan'208";a="218552335"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by orviesa008.jf.intel.com with ESMTP; 04 Mar 2026 20:42:20 -0800
Date: Thu, 5 Mar 2026 12:22:27 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"Gao, Chao" <chao.gao@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"kas@kernel.org" <kas@kernel.org>,
	"Chatre, Reinette" <reinette.chatre@intel.com>,
	"Verma, Vishal L" <vishal.l.verma@intel.com>,
	"nik.borisov@suse.com" <nik.borisov@suse.com>,
	"mingo@redhat.com" <mingo@redhat.com>,
	"Weiny, Ira" <ira.weiny@intel.com>, "hpa@zytor.com" <hpa@zytor.com>,
	"Annapurve, Vishal" <vannapurve@google.com>,
	"sagis@google.com" <sagis@google.com>,
	"Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"paulmck@kernel.org" <paulmck@kernel.org>,
	"tglx@kernel.org" <tglx@kernel.org>,
	"Williams, Dan J" <dan.j.williams@intel.com>,
	"bp@alien8.de" <bp@alien8.de>
Subject: Re: [PATCH v4 16/24] x86/virt/seamldr: Install a new TDX Module
Message-ID: <aakFA6X74x+8tYGR@yilunxu-OptiPlex-7050>
References: <20260212143606.534586-1-chao.gao@intel.com>
 <20260212143606.534586-17-chao.gao@intel.com>
 <6f1f835e27bef3462ae419906e25bd887eb8577b.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6f1f835e27bef3462ae419906e25bd887eb8577b.camel@intel.com>
X-Rspamd-Queue-Id: 4B4D320AE1A
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72788-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[25];
	DKIM_TRACE(0.00)[intel.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yilun.xu@linux.intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:dkim,intel.com:email,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

> > -static int do_seamldr_install_module(void *params)
> > +static int do_seamldr_install_module(void *seamldr_params)
> 
> Nit:
> 
> IMHO such renaming is just a noise to this patch, since in patch 10/11 it's

Agree. Otherwise

Reviewed-by: Xu Yilun <yilun.xu@linux.intel.com>

> clear that the 'params' you passed in is seamldr_params.  No?
> 
> Perhaps just name it 'seamldr_params' at patch 11?

