Return-Path: <kvm+bounces-69666-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yLE1BX8xfGlVLQIAu9opvQ
	(envelope-from <kvm+bounces-69666-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 05:20:15 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B085AB70F2
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 05:20:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id AA2B93018BD9
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 04:20:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 522C733C507;
	Fri, 30 Jan 2026 04:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OsrepXs3"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B7CD1607A4;
	Fri, 30 Jan 2026 04:19:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769746798; cv=none; b=tWDVSmkih5XFJWHsgNM+BybXC8QTUC0kXuzJSpiFet9lCbSONLdey/AYHURUgTw1J90TeVy3XPP+j/mZxy9r7nAzTfqLopjLRzvHdS4XtLMedUWTfFvomw4EDshnxVgc2UgMnS228avzSj3VwN2LA38DiiIFueuNMlUeDDOGfac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769746798; c=relaxed/simple;
	bh=ox/deh2PiJbxGr7yh4KNQDHHU3XJkCnzWZSOESwWuUE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GnnXNlXQsVHDItVndSwjltIWw2GX2rypJeu1nd8Z7tZxNpxZkITrj4LnHZyrljCL5NenLaDOE4YrA8yER97j/DZZOFHZHLlzhYe62axl41GjNmDW7uP1Pp0P1T9EhRtK0xzFzugnfiwwgZkVeyTaxY9td8X1vLkuZoJmHgKraYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OsrepXs3; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769746797; x=1801282797;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ox/deh2PiJbxGr7yh4KNQDHHU3XJkCnzWZSOESwWuUE=;
  b=OsrepXs3KwxzzRzyPIHX3/wSPMA7Zai6w7lXMtlo5Y97+9vlLq2WUB8C
   fBnDrFxqJfataTL+z/Fwbymu3uY2ep/gUegDvMqP2aSXhqktKwfxkDt7x
   hwlsUm+gNYFS9m2SfeypWwo/GBb5Tt2PqrSfSViVcgXZOc3nXISmRHCRs
   WlSGKp+0P19U5VStkRIlXmvwq7d0d8/OMKLTONtk6i/MsLoU8YO9CezUT
   rjNHASH3jPVwPYnVDsXzUTjI8OJP+QItuigl8eKmmbN7mOHMXFo7kpNPa
   sdKTA02DbqqV6scBVzkYkw9bvuN4Qi16wyJfZNa3O7IHqkjwrA/AZ7Jrg
   Q==;
X-CSE-ConnectionGUID: KC3aiOTTTIWPltnvCf+7GA==
X-CSE-MsgGUID: dUhbs332RDCtgUTCUtPK0Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11686"; a="70014360"
X-IronPort-AV: E=Sophos;i="6.21,262,1763452800"; 
   d="scan'208";a="70014360"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2026 20:19:56 -0800
X-CSE-ConnectionGUID: OSkzCLsHQIyvYwVTXpq2jg==
X-CSE-MsgGUID: bGKzNJ2JRbiQswS8AGjCIg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,262,1763452800"; 
   d="scan'208";a="208670775"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by fmviesa006.fm.intel.com with ESMTP; 29 Jan 2026 20:19:51 -0800
Date: Fri, 30 Jan 2026 12:01:36 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Chao Gao <chao.gao@intel.com>, linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
	reinette.chatre@intel.com, ira.weiny@intel.com, kai.huang@intel.com,
	dan.j.williams@intel.com, sagis@google.com, vannapurve@google.com,
	paulmck@kernel.org, nik.borisov@suse.com, zhenzhong.duan@intel.com,
	seanjc@google.com, rick.p.edgecombe@intel.com, kas@kernel.org,
	dave.hansen@linux.intel.com, vishal.l.verma@intel.com,
	Farrah Chen <farrah.chen@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v3 08/26] x86/virt/seamldr: Retrieve P-SEAMLDR information
Message-ID: <aXwtILdwb/KMX9uH@yilunxu-OptiPlex-7050>
References: <20260123145645.90444-1-chao.gao@intel.com>
 <20260123145645.90444-9-chao.gao@intel.com>
 <b2e2fd5e-8aff-4eda-a648-9ae9f8234d25@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b2e2fd5e-8aff-4eda-a648-9ae9f8234d25@intel.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69666-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[25];
	DKIM_TRACE(0.00)[intel.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yilun.xu@linux.intel.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,intel.com:dkim]
X-Rspamd-Queue-Id: B085AB70F2
X-Rspamd-Action: no action

> I'd also prefer a
> 
> 	BUILD_BUG_ON(sizeof(struct seamldr_info) != 2048);
                                                    ^
BUILD_BUG_ON(sizeof(struct seamldr_info) != 256);   is it?

> 
> just as a sanity check. It doesn't cost anything and it makes sure that
> as you muck around with reserved fields and padding that there's at
> least one check making sure it's OK.

And I recently received a comments that "never __packed for naturally
aligned structures cause it leads to bad generated code and hurts
performance", but I really want to highlight nearby it is for a
formatted binary blob, so:

  struct seamldr_info {
	u32     version;
	u32     attributes;
	u32     vendor_id;
	u32     build_date;
	u16     build_num;
	u16     minor_version;
	u16     major_version;
	u16     update_version;
	u8      reserved0[4];
	u32     num_remaining_updates;
	u8      reserved1[224];
  };   //delete __packed here

 static_assert(sizeof(struct seamldr_info) == 256);

Is it better?

