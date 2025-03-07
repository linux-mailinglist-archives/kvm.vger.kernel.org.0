Return-Path: <kvm+bounces-40321-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 92663A56318
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 09:59:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CC21A16F7B0
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 08:59:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42C221E1DF0;
	Fri,  7 Mar 2025 08:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gLMQoBDT"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1918199E94
	for <kvm@vger.kernel.org>; Fri,  7 Mar 2025 08:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741337949; cv=none; b=PHiltqxGD2WRaT2oZU7Wt/f0B1256Db4dLkx479VAd3uT0LL7LID6VgfwRdxP6QRdLzmJ/pWeU2S3Afe6O2m9QJ5uLHuE+9MjTPcIw5qPDnCHbbU4PgGnPo9pystoEOe1XlEkxFZiorJrzFsiTk0Oz6cl/xdNCSGF/6H9dd848Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741337949; c=relaxed/simple;
	bh=lcLY1x1iW003ARIIYfypc8gSXCdCsMc0qubiz9RJXy8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uY+8D4vkoc5mQZSQ3dBU6YqmRmeCvd7clXtFc3lAJVDHl/WttW1Xq4gEIxaBqUuzC0QPEHo1kXJBz0QxxBRpM3is+81ZgGWSWDHP70vYIvpxK2Kwl2JZaH+9ONG7QjSLXNWsRzJYvDM9qYnn9qUvQXY0O7rsRxr2xIK0xfvtvGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gLMQoBDT; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741337948; x=1772873948;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=lcLY1x1iW003ARIIYfypc8gSXCdCsMc0qubiz9RJXy8=;
  b=gLMQoBDTMBPeScAN4Yl1ZmEpJVQkC17mVlsvakl8Dwh0/NM6hFvSUSBN
   MvmotTJr/1+Try0c2mq2EKGv+GvzmJLwkeC+uqA6bjpDN2/8olrwB3l1w
   2Ko3jKxB8/NrQO7yzfyFJYqXHo9ltVkUvxVonQxezF87LBwKaCGb4oMdW
   6arH7HWWyFxzDYi8rzfr+cDhnozuK8ZhK6voUC19GfKYcPmw6bjSGGeFI
   heD4gNQpv+2zLdOWryIrJpZQ6DXhaiWapTMJAOrBWjqUmqKVkCY/12AVp
   +/8EQXzwYLliHMi2epSVjjNKQucpbvvYC/tnHF4F7ZHlBYbCXsaZQ2zAA
   Q==;
X-CSE-ConnectionGUID: 18UfZxnxTUqt3VTjlxRELg==
X-CSE-MsgGUID: O2GpVk/pQwKrHiv7EvN1Zw==
X-IronPort-AV: E=McAfee;i="6700,10204,11365"; a="42521572"
X-IronPort-AV: E=Sophos;i="6.14,228,1736841600"; 
   d="scan'208";a="42521572"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2025 00:59:07 -0800
X-CSE-ConnectionGUID: lflAClxPRXafbSNVjWQY3Q==
X-CSE-MsgGUID: nQXLNZKkRem5CEU/Z4hs7w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="123459836"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by fmviesa003.fm.intel.com with ESMTP; 07 Mar 2025 00:59:03 -0800
Date: Fri, 7 Mar 2025 17:19:11 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Dongli Zhang <dongli.zhang@oracle.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, pbonzini@redhat.com,
	mtosatti@redhat.com, sandipan.das@amd.com, babu.moger@amd.com,
	likexu@tencent.com, like.xu.linux@gmail.com,
	zhenyuw@linux.intel.com, groug@kaod.org, khorenko@virtuozzo.com,
	alexander.ivanov@virtuozzo.com, den@virtuozzo.com,
	davydov-max@yandex-team.ru, xiaoyao.li@intel.com,
	dapeng1.mi@linux.intel.com, joe.jin@oracle.com
Subject: Re: [PATCH v2 06/10] target/i386/kvm: rename architectural PMU
 variables
Message-ID: <Z8q6D8fqFmegi4uW@intel.com>
References: <20250302220112.17653-1-dongli.zhang@oracle.com>
 <20250302220112.17653-7-dongli.zhang@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250302220112.17653-7-dongli.zhang@oracle.com>

> +/*
> + * For Intel processors, the meaning is the architectural PMU version
> + * number.
> + *
> + * For AMD processors: 1 corresponds to the prior versions, and 2
> + * corresponds to AMD PerfMonV2.
> + */
> +static uint32_t has_pmu_version;

The "has_" prefix sounds like a boolean type. So what about "pmu_version"?

Others look good to me,

Reviewed-by: Zhao Liu <zhao1.liu@intel.com>


