Return-Path: <kvm+bounces-48240-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EAF28ACBE2A
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 03:30:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9DA233A5737
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 01:29:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A365433E1;
	Tue,  3 Jun 2025 01:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jpuEGL+6"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D21F72631;
	Tue,  3 Jun 2025 01:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748914207; cv=none; b=MYivlLcldXIifr7bkiRB9SmGJtms6IxF90FMRQ5hLqpj568gSSr8OuHc8m2EBZH07OMSQlbBnZX77ZQtKs1BJlq/+DPAogY5o6kuLFdUEcdB/jlX2zODIEEk5+VWHTfSvZdjVpA/AEXrWJA2jl5SpUo5T8Q7IMkYEiXJLbTXYyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748914207; c=relaxed/simple;
	bh=MqyKI93LRJddY/DM3V1MJJpx3swen4DNqllDpBbnZKc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=svi3pZwDgZgvBVNqKbtyoLPjre6e78AjkFosZsBypBbuCXwoaVo21AA/dmMmknXv17cYqBcGpJyXxMnW19klrKjwbKbP09QsFLboidtUAllIffmSSyQmBGG5NlWxBYo4HaCxJD0ZZPqX6cFLadNlO0jPi5BiQEESvILg//HxLws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jpuEGL+6; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748914206; x=1780450206;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=MqyKI93LRJddY/DM3V1MJJpx3swen4DNqllDpBbnZKc=;
  b=jpuEGL+6wxNUYqk+2QmeYwCATER+z/92fdL62PEaVxvi/jyq/YgwMtF1
   WnFYZtENckOAkUBl0Iqxzv6b025k8f5WRXqKCwQFcIMFH4fUrebAFdu1K
   PnHrQ8kRByCJtqRoVfzK5RgThQVt8f03XFE8yX1lA3EI3SIHAnDl1fLCR
   fZPnMpBtlhta3Hl4dkBvMf+b0J2Y+aYTPvHtUZn1cle73VBRxN8JpE2cA
   v9YkcujmjYozCKVVcEGDYYqfjHyFk1pXHJ63sZWzg8IOs+550LgQ4Hqgj
   N/yA/suKR1+2v3E+CrAfJ1KhI2HW98mA4s+sAVVNFBnaRsW2AL+gykyZC
   w==;
X-CSE-ConnectionGUID: gvFhvuQKTDCS4wlZ0Cozvw==
X-CSE-MsgGUID: /Ii5emUTRLaBmrrGw+t2sA==
X-IronPort-AV: E=McAfee;i="6700,10204,11451"; a="61197184"
X-IronPort-AV: E=Sophos;i="6.16,205,1744095600"; 
   d="scan'208";a="61197184"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2025 18:30:05 -0700
X-CSE-ConnectionGUID: NKavtTTOR4e48is9QsdmPg==
X-CSE-MsgGUID: dJLdDMD0TL6OccNh9TW7Cw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,205,1744095600"; 
   d="scan'208";a="149534367"
Received: from enasrall-mobl1.amr.corp.intel.com (HELO desk) ([10.125.146.36])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2025 18:30:05 -0700
Date: Mon, 2 Jun 2025 18:29:57 -0700
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Borislav Petkov <bp@alien8.de>,
	Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH 3/5] KVM: VMX: Apply MMIO Stale Data mitigation if KVM
 maps MMIO into the guest
Message-ID: <20250603012957.kgwfnihs4zkv5y4x@desk>
References: <20250523011756.3243624-1-seanjc@google.com>
 <20250523011756.3243624-4-seanjc@google.com>
 <20250529042710.crjcc76dqpiak4pn@desk>
 <aDjdagbqcesTcnhc@google.com>
 <20250529234013.fbxruxq44wpfh5w4@desk>
 <aD43icQolCvESIpc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aD43icQolCvESIpc@google.com>

On Mon, Jun 02, 2025 at 04:45:13PM -0700, Sean Christopherson wrote:
> Ah, and the s/mmio_stale_data_clear/cpu_buf_vm_clear rename already landed for
> 6.16-rc1, so we don't have to overthink about the ordering with respect to that
> change. :-)

Yeah, I noticed that. It went through the x86 tree as bulk of changes were
outside of KVM.

