Return-Path: <kvm+bounces-64221-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2FEDDC7B4E2
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 19:22:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2894B3A5F08
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 18:18:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD1432F2603;
	Fri, 21 Nov 2025 18:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MDaYRkiP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 082AE2D6624;
	Fri, 21 Nov 2025 18:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763748999; cv=none; b=B2K84UmUXzkQui1H4XhBMkCok+JG0Fq2WOG/Pk0STlCenb1+vrdu7DAHLNqvigpfbOvA/lHuJ4qId5m299O4X3H5/gYBbejaoo/9MzXFCgkJlI9TUm2LjESd0VDcGtXnRh+RydryEKKEtcG7qtaS3DAisM9IKgW3q7PdlwG/nK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763748999; c=relaxed/simple;
	bh=c+metjHr+BiopeundKY+M3b3qOa4qzJE5hbACeh4X0E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QwQmTMv3qHyekJ3JVYQtGhmKkITOAhsfTFnTZFknc2KpxwdSKnfTIQz/DUwfv0p9tYKM0fmXQp9MRUlhFjmchH+4FVZYQubBtfPr79qvQifi/clDcgyN7x36itV5J+QMZoiiNzoWSYD0q9OhtJkVPVyDmlFofnjKKWnq5FbMilE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MDaYRkiP; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763748998; x=1795284998;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=c+metjHr+BiopeundKY+M3b3qOa4qzJE5hbACeh4X0E=;
  b=MDaYRkiPR0hJhmoqDyvkQRHiTeA2M4L3QwQE3c9s3FF7lmJKvGf78ShJ
   UkTE9JIK8LiwzUR4hBKqt3NyyC2Siw0aeWulZFdAeYMB+hp2fNNH9U/u9
   vQMBQkgUN/QnOcU9e8P7Sk4a4DfOAmFbb/9Io562TfCe0CpdKK4TDu9K1
   ZnMxZXFDVEyZV+LvLdTAsidXLh4sxFcv1vhZaOZ0kquiSHsAkfYhK/6AW
   8r0edi8nRmtL4/DxccqSFDbUzcqJgMQC2j7VHjycRdBaOTrqmyFXuOvkz
   PbTHcPmhIw8CEAtcU6j+T259bRE8rBsdlNHZDs5noH63J+I+OI5Cmt9fb
   A==;
X-CSE-ConnectionGUID: jIVwZ3UmQ+KCfe/R2x+kNg==
X-CSE-MsgGUID: 7DTBzePVSuWIURbZ4YTyTA==
X-IronPort-AV: E=McAfee;i="6800,10657,11620"; a="65796948"
X-IronPort-AV: E=Sophos;i="6.20,216,1758610800"; 
   d="scan'208";a="65796948"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2025 10:16:38 -0800
X-CSE-ConnectionGUID: V0cUPZmbTmGwYYwOcSsYzw==
X-CSE-MsgGUID: 6KnVofuxRJKzc5Ji5jGItg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,216,1758610800"; 
   d="scan'208";a="196219578"
Received: from guptapa-desk.jf.intel.com (HELO desk) ([10.165.239.46])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2025 10:16:37 -0800
Date: Fri, 21 Nov 2025 10:16:32 -0800
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Nikolay Borisov <nik.borisov@suse.com>, x86@kernel.org,
	David Kaplan <david.kaplan@amd.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	Asit Mallick <asit.k.mallick@intel.com>,
	Tao Zhang <tao1.zhang@intel.com>,
	Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v4 04/11] x86/bhi: Make clear_bhb_loop() effective on
 newer CPUs
Message-ID: <20251121181632.czfwnfzkkebvgbye@desk>
References: <20251119-vmscape-bhb-v4-0-1adad4e69ddc@linux.intel.com>
 <20251119-vmscape-bhb-v4-4-1adad4e69ddc@linux.intel.com>
 <4ed6763b-1a88-4254-b063-be652176d1af@intel.com>
 <e9678dd1-7989-4201-8549-f06f6636274b@suse.com>
 <f7442dc7-be8d-43f8-b307-2004bd149910@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f7442dc7-be8d-43f8-b307-2004bd149910@intel.com>

On Fri, Nov 21, 2025 at 08:50:17AM -0800, Dave Hansen wrote:
> On 11/21/25 08:45, Nikolay Borisov wrote:
> > OTOH: the global variable approach seems saner as in the macro you'd
> > have direct reference to them and so it will be more obvious how things
> > are setup.
> 
> Oh, yeah, duh. You don't need to pass the variables in registers. They
> could just be read directly.

IIUC, global variables would introduce extra memory loads that may slow
things down. I will try to measure their impact. I think those global
variables should be in the .entry.text section to play well with PTI.

Also I was preferring constants because load values from global variables
may also be subject to speculation. Although any speculation should be
corrected before an indirect branch is executed because of the LFENCE after
the sequence.


