Return-Path: <kvm+bounces-69797-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0LhiCh1CgGmK5QIAu9opvQ
	(envelope-from <kvm+bounces-69797-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 07:20:13 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id BC71BC8988
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 07:20:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 8ED243003D07
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 06:20:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAA232F6560;
	Mon,  2 Feb 2026 06:20:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bT8t47ig"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 916491E0DD8;
	Mon,  2 Feb 2026 06:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770013206; cv=none; b=CM4aM8JNbbuSViF3BLzkooCWWtGvtfu6nemd6z7JY006BiIVZlYfvm1oeYl4DC/rx7bHFVLieATt/M1TOeYX7y+JSDO1PCDGJx6jC/vSeNEYVd5MO+TJKarYa9qhVd6ewwVMw+8wAx8/LE/M3pj6RktIJtRO5vIKdsW0kdCGMOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770013206; c=relaxed/simple;
	bh=e+vygG1opwSSk2lhM00V8KAPs5cPYOhL9wMXsNVwVp4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QLd34mY2aJsvtxu/f5i2siHWfaigfncVBQuE4Cubi8EKUlCAzFnp4mCEhOJs1fXJEMXU3+0xxyFZLVxiBJi1tarpeVIWQNszbBatnzZLvWDnqIAvdjGR9V6906Jt0CnHqc+383/3uzGnVNrGPnllaCsTuIu+IazkoB25Bm6fMTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bT8t47ig; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770013203; x=1801549203;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=e+vygG1opwSSk2lhM00V8KAPs5cPYOhL9wMXsNVwVp4=;
  b=bT8t47ig4Y1FDDX0dzoM3pY67gxXvgUMmG1PDaBpaIOUNA/9ihID/Dlf
   9r0vxqKB/QHy+NLa5HHkkX/uJp2jbLz8oX+emWpfLhIG33zrO60ElSnqo
   GQx4sGnKbECjxbcPcHUtFNJB+V/v2d4uyhPucVyOJ77rzz9sYj6Pxbf/V
   DRoI95nvVV5Up51OYgu1EejW/xHcYjTZymKf2cIEXuOWuw/2avqf0SGu4
   yJvBiBQwF86D4BCcQQRUTOrmC0qPdDSOk8u9VZ36DQfL899SlcFY2cPfy
   JOLDlfHMY987/NoXBD6S2sINFWtB3DdAoR9CuHUAHCpV8JiEibAkPZtVi
   Q==;
X-CSE-ConnectionGUID: iMLZ7RegSj+a7zh3wPt1Zw==
X-CSE-MsgGUID: yKeISCkOTcibeac8xori9g==
X-IronPort-AV: E=McAfee;i="6800,10657,11689"; a="71066667"
X-IronPort-AV: E=Sophos;i="6.21,268,1763452800"; 
   d="scan'208";a="71066667"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2026 22:20:02 -0800
X-CSE-ConnectionGUID: BRyCJipZTeiMIi6xHeu0uQ==
X-CSE-MsgGUID: m/9M5LJOQWGHWoZmNVCqtw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,268,1763452800"; 
   d="scan'208";a="247042456"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by orviesa001.jf.intel.com with ESMTP; 01 Feb 2026 22:19:57 -0800
Date: Mon, 2 Feb 2026 14:01:32 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Chao Gao <chao.gao@intel.com>
Cc: linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, x86@kernel.org, reinette.chatre@intel.com,
	ira.weiny@intel.com, kai.huang@intel.com, dan.j.williams@intel.com,
	sagis@google.com, vannapurve@google.com, paulmck@kernel.org,
	nik.borisov@suse.com, zhenzhong.duan@intel.com, seanjc@google.com,
	rick.p.edgecombe@intel.com, kas@kernel.org,
	dave.hansen@linux.intel.com, vishal.l.verma@intel.com,
	Farrah Chen <farrah.chen@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v3 14/26] x86/virt/seamldr: Introduce skeleton for TDX
 Module updates
Message-ID: <aYA9vOSRDNCU1A/2@yilunxu-OptiPlex-7050>
References: <20260123145645.90444-1-chao.gao@intel.com>
 <20260123145645.90444-15-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260123145645.90444-15-chao.gao@intel.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69797-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[24];
	DKIM_TRACE(0.00)[intel.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yilun.xu@linux.intel.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,intel.com:email,intel.com:dkim]
X-Rspamd-Queue-Id: BC71BC8988
X-Rspamd-Action: no action

On Fri, Jan 23, 2026 at 06:55:22AM -0800, Chao Gao wrote:
> The P-SEAMLDR requires that no TDX Module SEAMCALLs are invoked during a
> runtime TDX Module update.
> 
> But currently, TDX Module SEAMCALLs are invoked in various contexts and in
> parallel across CPUs. Additionally, considering the need to force all vCPUs
> out of guest mode, no single lock primitive, except for stop_machine(), can
> meet this requirement.
> 
> Perform TDX Module updates within stop_machine() as it achieves the
> P-SEAMLDR requirements and is an existing well understood mechanism.
> 
> TDX Module updates consist of several steps: shutting down the old
> module, installing the new module, and initializing the new one and etc.
> Some steps must be executed on a single CPU, others serially across all
> CPUs, and some can be performed concurrently on all CPUs and there are
> ordering requirements between steps. So, all CPUs need to perform the work
> in a step-locked manner.
> 
> In preparation for adding concrete steps for TDX Module updates,
> establish the framework by mimicking multi_cpu_stop(). Specifically, use a
> global state machine to control the work done on each CPU and require all
> CPUs to acknowledge completion before proceeding to the next stage.
> 
> Potential alternative to stop_machine()
> =======================================
> An alternative approach is to lock all KVM entry points and kick all
> vCPUs.  Here, KVM entry points refer to KVM VM/vCPU ioctl entry points,
> implemented in KVM common code (virt/kvm). Adding a locking mechanism
> there would affect all architectures. And to lock only TDX vCPUs, new
> logic would be needed to identify TDX vCPUs, which the common code
> currently lacks. This would add significant complexity and maintenance
> overhead for a TDX-specific use case.
> 
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> Tested-by: Farrah Chen <farrah.chen@intel.com>

Reviewed-by: Xu Yilun <yilun.xu@linux.intel.com>

