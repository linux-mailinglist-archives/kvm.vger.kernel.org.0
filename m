Return-Path: <kvm+bounces-48238-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D9811ACBE1C
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 03:22:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8A5A3167B57
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 01:22:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 358EF13C9C4;
	Tue,  3 Jun 2025 01:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BY1u7x7x"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EDD076025;
	Tue,  3 Jun 2025 01:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748913739; cv=none; b=JWY+uCUAkAn0+5pjcukp2JnF7dDUtO/cn4FKPl+Io305mzzdLAFPICYe60EUQWzO9uDgmN0x6NKCAQkrluQ/NMCXOR18+iJfW8U4JB7MRIxTz5CD+MFLqjVNj9RManxL7PZFUAap3Y5ndqLyK5VY9H/9PFnLwwqlG+nkQQj5eio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748913739; c=relaxed/simple;
	bh=aJeHLQ4x2NkQdvmr5Q0cLN6M4USQUR/emgQH3bbe0iw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VjV0Z9zj8nyCj5Q9vhhl6W/zQRsWiFKefmrvY6TfGMiOpMRJNx8GSJpKez/YeG8gTN4iyinkc/qa5a7O9hpJnCMrqHZA04ROB7bbJgYo3Zjc/eRMm/T2Cbjxb3Drh9/+iltaqOCmcqjTC6BK2zzMjrXUTQbRJKJcL2svyD5zBHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BY1u7x7x; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748913737; x=1780449737;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=aJeHLQ4x2NkQdvmr5Q0cLN6M4USQUR/emgQH3bbe0iw=;
  b=BY1u7x7xNd3IGJHNR1RLgETVc9Wx6eRrR6tdSoouhq6rqGWOU/c7FP66
   ak5GkggTCp4l5hWir/wT8AzjlcILBV69hrjBRfuGrwWlJR9BmBBXJ5UDU
   T1jZBwyMCfYL0ybfcGj/dKxB3MDsxonlicAPO6PsCa5n+mBvZ5QFAQlk5
   TFWwrBecUFBIA6ZwFcO7QtoukJILAyS7XJOWLxayV7hvF2ylI41ruBocl
   UNxxst54wQ6Ycug/XmWJtuh7L3wF2g23icus0/MWVZv8ubl4gTbPcxTA/
   0LRnkwPhhstFp7X7nGdDPxdFEfRVy6j1eZyRS4DDKmLxuUfMfh5L2upIr
   Q==;
X-CSE-ConnectionGUID: RR+snPrZSlOxmhmYXrtk8A==
X-CSE-MsgGUID: /XLSOBUbRDO1nwuA3kU3UQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11451"; a="54730088"
X-IronPort-AV: E=Sophos;i="6.16,205,1744095600"; 
   d="scan'208";a="54730088"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2025 18:22:15 -0700
X-CSE-ConnectionGUID: xuTjK8F8STmt9LDkkl6lAQ==
X-CSE-MsgGUID: QpmGNIcQTJqV1o27tGP8rQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,205,1744095600"; 
   d="scan'208";a="181863497"
Received: from enasrall-mobl1.amr.corp.intel.com (HELO desk) ([10.125.146.36])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2025 18:22:16 -0700
Date: Mon, 2 Jun 2025 18:22:08 -0700
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Borislav Petkov <bp@alien8.de>,
	Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH 0/5] KVM: VMX: Fix MMIO Stale Data Mitigation
Message-ID: <20250603012208.cadagk7rgwy24gkh@desk>
References: <20250523011756.3243624-1-seanjc@google.com>
 <20250529033546.dhf3ittxsc3qcysc@desk>
 <aD42rwMoJ0gh5VBy@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aD42rwMoJ0gh5VBy@google.com>

On Mon, Jun 02, 2025 at 04:41:35PM -0700, Sean Christopherson wrote:
> > Regarding validating this, if VERW is executed at VMenter, mitigation was
> > found to be effective. This is similar to other bugs like MDS. I am not a
> > virtualization expert, but I will try to validate whatever I can.
> 
> If you can re-verify the mitigation works for VFIO devices, that's more than
> good enough for me.  The bar at this point is to not regress the existing mitigation,
> anything beyond that is gravy.

Ok sure. I'll verify that VERW is getting executed for VFIO devices.

> I've verified the KVM mechanics of tracing MMIO mappings fairly well (famous last
> words), the only thing I haven't sanity checked is that the existing coverage for
> VFIO devices is maintained.

