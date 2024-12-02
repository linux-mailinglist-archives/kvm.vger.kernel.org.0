Return-Path: <kvm+bounces-32860-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CF7F99E0F59
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 00:35:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 65D891650B4
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2024 23:35:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 891D01DFDA5;
	Mon,  2 Dec 2024 23:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ETTJ08la"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB63C2C18C;
	Mon,  2 Dec 2024 23:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733182530; cv=none; b=eePv8OaC8fNGtNM13Jqmu0vADXITO2c0BRaVkw1odxtJe5RKlKL4NfvEIEttabdCNqQL2YC6E16AJ/tn7RAgoca7Y7Oet44zrdGzFgDTFgu1Qt7OxbKV+q6+u3bOpPtGfPx+qXxOEZn9LerSvfwcPoxvphdBHe2Fjap6CKnxDaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733182530; c=relaxed/simple;
	bh=GTllTgmBG4SmhlrT+/ywvHTuP/WmsCAwgMp34pJJwSA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lJZIrzwF7hjk3ZccjmyPxmLcHUGa2ObOXEsqxVNfpT7sjhtWuFa8scJsbKpZpzrIGfoq/KQCvCnk9QTw+sp4W+FT4qTW9nLT7ySvCJXBv3ypoA0nRGiledzPj42e8wuF4Zbv8penH88rU7qFWBKXti8EkCyL1qKlYXM6VXlz3k8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ETTJ08la; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733182529; x=1764718529;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=GTllTgmBG4SmhlrT+/ywvHTuP/WmsCAwgMp34pJJwSA=;
  b=ETTJ08laDUd+a3IUyZoNOHjGF5Wj9jBWrIRy8gxEHCMtalTFBofZqQ+o
   uHx22ZmOGLcedJtMCe955Gy3KuVpvZ/BFunY4eJdPyUi94tYfxkp6bW0m
   LC8/Dx/IdsyqePWNEQyTrsL+FPnnAA0deCjCIKKC+4ibmd+g7wBM/yEAa
   1PHy9mjVVV22ubvPNcNnfuVUTu4SpfCV3ruu0NW+A959E/4j51VEae42O
   Bgt4S/1XoZompwPi0OitaDyJOvZyRWtHdHmeaXebkBEPabF1ALYVt3Jgg
   EPdTt4XSqNIqOCm7hpOJecEPUbuFVnTlSMQ2T6/VqJCUdf36HZDlVRd9i
   w==;
X-CSE-ConnectionGUID: n0Nj4pb2T9mb2vd2nQVhyA==
X-CSE-MsgGUID: faVZBMU+QliYxQYKX2TrAw==
X-IronPort-AV: E=McAfee;i="6700,10204,11274"; a="33121408"
X-IronPort-AV: E=Sophos;i="6.12,203,1728975600"; 
   d="scan'208";a="33121408"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2024 15:35:28 -0800
X-CSE-ConnectionGUID: OqgjxLgjSKyBqd0ALVugqw==
X-CSE-MsgGUID: ktkqe+cgQdCMx1SgAI6j4w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="98273206"
Received: from ddbrudv-mobl.amr.corp.intel.com (HELO desk) ([10.125.145.202])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2024 15:35:28 -0800
Date: Mon, 2 Dec 2024 15:35:21 -0800
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>, x86@kernel.org,
	linux-kernel@vger.kernel.org, amit@kernel.org, kvm@vger.kernel.org,
	amit.shah@amd.com, thomas.lendacky@amd.com, tglx@linutronix.de,
	peterz@infradead.org, corbet@lwn.net, mingo@redhat.com,
	dave.hansen@linux.intel.com, hpa@zytor.com, seanjc@google.com,
	pbonzini@redhat.com, daniel.sneddon@linux.intel.com,
	kai.huang@intel.com, sandipan.das@amd.com,
	boris.ostrovsky@oracle.com, Babu.Moger@amd.com,
	david.kaplan@amd.com, dwmw@amazon.co.uk, andrew.cooper3@citrix.com
Subject: Re: [PATCH v2 1/2] x86/bugs: Don't fill RSB on VMEXIT with
 eIBRS+retpoline
Message-ID: <20241202233521.u2bygrjg5toyziba@desk>
References: <cover.1732219175.git.jpoimboe@kernel.org>
 <9bd7809697fc6e53c7c52c6c324697b99a894013.1732219175.git.jpoimboe@kernel.org>
 <20241130153125.GBZ0svzaVIMOHBOBS2@fat_crate.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241130153125.GBZ0svzaVIMOHBOBS2@fat_crate.local>

On Sat, Nov 30, 2024 at 04:31:25PM +0100, Borislav Petkov wrote:
> On Thu, Nov 21, 2024 at 12:07:18PM -0800, Josh Poimboeuf wrote:
> > eIBRS protects against RSB underflow/poisoning attacks.  Adding
> > retpoline to the mix doesn't change that.  Retpoline has a balanced
> > CALL/RET anyway.
> 
> This is exactly why I've been wanting for us to document our mitigations for
> a long time now.
> 
> A bunch of statements above for which I can only rhyme up they're correct if
> I search for the vendor docs. On the AMD side I've found:
> 
> "When Automatic IBRS is enabled, the internal return address stack used for
> return address predictions is cleared on VMEXIT."
> 
> APM v2, p. 58/119
> 
> For the Intel side I'm not that lucky. There's something here:
> 
> https://www.intel.com/content/www/us/en/developer/articles/technical/software-security-guidance/technical-documentation/branch-history-injection.html
> 
> Or is it this one:
> 
> https://www.intel.com/content/www/us/en/developer/articles/technical/software-security-guidance/technical-documentation/speculative-execution-side-channel-mitigations.html#inpage-nav-1-3-undefined
> 
> Or is this written down explicitly in some other doc?

It is in this doc:

  https://www.intel.com/content/www/us/en/developer/articles/technical/software-security-guidance/technical-documentation/indirect-branch-restricted-speculation.html

  "Processors with enhanced IBRS still support the usage model where IBRS is
  set only in the OS/VMM for OSes that enable SMEP. To do this, such
  processors will ensure that guest behavior cannot control the RSB after a
  VM exit once IBRS is set, even if IBRS was not set at the time of the VM
  exit."

