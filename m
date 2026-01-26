Return-Path: <kvm+bounces-69110-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QO19HRFId2ledwEAu9opvQ
	(envelope-from <kvm+bounces-69110-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 11:55:13 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D04158757F
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 11:55:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 5F13A30529A4
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 10:48:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B12A6331A43;
	Mon, 26 Jan 2026 10:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hzoF6evC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E8BE30DD27;
	Mon, 26 Jan 2026 10:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769424349; cv=none; b=X/BdDmItTe2A/cE+C6iXw6IiTCOWSqFr5FJwm1lN1f3gLuSl9ODAzWhLqiyWf3ztjktz8U9QhibS/TnVyAznWoiUqZKiPl/rwOEiZ0nJTcO0Libfs8zjW9QeZPHcyePTYO7DsOv4vsvTH3/x6DDrEB/uqVGdQsqJuhUqs7jx6WM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769424349; c=relaxed/simple;
	bh=NLluv3uZAtFy7uD8JF6lFboLzjVZu7CJHIjlKE0Oe7w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tX4SVVo8RIPyVg1nQhOnL4umQelGtrucCCdYuLe+ew06rWnyVf/5Cbh6OklIZy7erFaSOaRSTO4yhXtbtRWA7gDqe/0vF7l2aAxsawA16OHImdUjmBrcVIqRt2qPC+IQqhito/wMop7zDIZ+dkerbfdzosVqprdJPn0UotFOe50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hzoF6evC; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769424348; x=1800960348;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=NLluv3uZAtFy7uD8JF6lFboLzjVZu7CJHIjlKE0Oe7w=;
  b=hzoF6evCpNYmU+4rez+enJM+AB7UdmmQ5ysWv5Zxcxl691qkJYfhtFUn
   siYA86yuHYywo9jZjABCD3Qoyms7L9JNXBygCO14fxyULfWhOFvK/nPFX
   1uGV3D+iF71Z7O7njvvis+/Y5a9E/O8r/ZBuEd4REgv2D8U5jxQZ0z1w7
   i6YVTQAbDPfraeyPwap3cuTMgBWHIL0VoFuTdMNqmUBKLQGR3Habikyx7
   lfTXH4Yz17/e/ii0LQ5nsQ4iUs2arUI1os3rp4Nj87pty/EGPIEM/jeUe
   xeTTVSQrq6iAq/AHomTrd1pKCeMXdBWdJaVOFarRRhSl6cYNNsBE9qGwJ
   g==;
X-CSE-ConnectionGUID: 2jS9ZfULQLyrVmV9KC4PkQ==
X-CSE-MsgGUID: xs3l3iN8Rw+FDTUtazUKEg==
X-IronPort-AV: E=McAfee;i="6800,10657,11682"; a="80899301"
X-IronPort-AV: E=Sophos;i="6.21,255,1763452800"; 
   d="scan'208";a="80899301"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2026 02:45:48 -0800
X-CSE-ConnectionGUID: hd05m5CTQR213xiU5Ky7hQ==
X-CSE-MsgGUID: 0s2t4TLPTWSRlrIJ+gKa+g==
X-ExtLoop1: 1
Received: from krybak-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.246.55])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2026 02:45:40 -0800
Date: Mon, 26 Jan 2026 12:45:37 +0200
From: Tony Lindgren <tony.lindgren@linux.intel.com>
To: Chao Gao <chao.gao@intel.com>
Cc: linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, x86@kernel.org, reinette.chatre@intel.com,
	ira.weiny@intel.com, kai.huang@intel.com, dan.j.williams@intel.com,
	yilun.xu@linux.intel.com, sagis@google.com, vannapurve@google.com,
	paulmck@kernel.org, nik.borisov@suse.com, zhenzhong.duan@intel.com,
	seanjc@google.com, rick.p.edgecombe@intel.com, kas@kernel.org,
	dave.hansen@linux.intel.com, vishal.l.verma@intel.com,
	Farrah Chen <farrah.chen@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v3 18/26] x86/virt/seamldr: Log TDX Module update failures
Message-ID: <aXdF0eD7QfH4HauU@tlindgre-MOBL1>
References: <20260123145645.90444-1-chao.gao@intel.com>
 <20260123145645.90444-19-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260123145645.90444-19-chao.gao@intel.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69110-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[25];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tony.lindgren@linux.intel.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[intel.com:+];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: D04158757F
X-Rspamd-Action: no action

On Fri, Jan 23, 2026 at 06:55:26AM -0800, Chao Gao wrote:
> If failures occur after the TDX Module has been successfully shut down,
> they are unrecoverable. The kernel cannot restore the previous TDX
> Module to a running state. All subsequent SEAMCALLs to the TDX Module
> will fail, so TDs cannot continue to run.
> 
> Log a message to clarify that SEAMCALL errors are expected in this case.

Reviewed-by: Tony Lindgren <tony.lindgren@linux.intel.com>

