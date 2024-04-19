Return-Path: <kvm+bounces-15299-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A94DC8AB05B
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 16:10:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 64CAC281806
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 14:10:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACE5C131BD9;
	Fri, 19 Apr 2024 14:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gh5Ysj92"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05D0B12FB34;
	Fri, 19 Apr 2024 14:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713535618; cv=none; b=b48lvArSZcs6koMufJQDFev5xAHNmMzphgjiPdaODnZiH7HIQLDlnrFAxgxib2B3U70hqzIaXvSIl+r3gBuzeam+O99SI7UX8AnM1pbnOd5fxxGsk+2E9Q+eQvs2T+axzAgpTQ4JHJCM4HCrs/uhW8ot4HVQ1QUzaTNb1MyDHLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713535618; c=relaxed/simple;
	bh=8Dg2SETr6N4feoFsxjjd3WBN8QKCU3lGTMaIZTPgErk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CN2KVRpF2+V+HGAehNy/7ubKrdfLtogHAXtRba7B2sq1oaNi6t6GPrNhTRpTck4Nqs/eZN27rqvyZ9PuWMZvZ6Mxf9+tA8WPvEPD9ol/AbCXCH1R1wG8Xayun4FMjdfzboT0bhQUHfxnYo+N26d1c/IxWerGlYnAkT4Q5sfIw/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gh5Ysj92; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713535617; x=1745071617;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=8Dg2SETr6N4feoFsxjjd3WBN8QKCU3lGTMaIZTPgErk=;
  b=gh5Ysj92TvMVKrNyWzwVyY9adJlURzidKC0xJYsfWzLA9dxg3aogAcWo
   CGRGUN15zVH9nfCg3Cqm5PLRnatvObajxAnQu6HOP/4WGpZdf5V2RGFhb
   /+1Y+GMWfE0kxUNw+XuGNQsh8PGcwFvm1Bt5HMx719NqpTx/oSgLOWcxm
   /9cjAgztiGcst0q7btYZK8ve7M3MD8P79er33vTTg9unmTbmQzq4eO28A
   knjQHxhxeiwYGBoTN7naSTWCWxZiQz87dFXI22Mc8q0WbCYgCVpHot58c
   lO9l0myScQz0a0z5aeQuFH7TJOWRR3ujmU5H4gOzT/wvbEUUYuZJjcdEh
   A==;
X-CSE-ConnectionGUID: uCIuEdztQVKYI3X/804Cuw==
X-CSE-MsgGUID: qicirMKZTiGc7sGVpL4QTA==
X-IronPort-AV: E=McAfee;i="6600,9927,11049"; a="8997109"
X-IronPort-AV: E=Sophos;i="6.07,213,1708416000"; 
   d="scan'208";a="8997109"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2024 07:06:56 -0700
X-CSE-ConnectionGUID: rIiZ5WraTSC/mutCZT/PVA==
X-CSE-MsgGUID: 1i84BjcMQbybm+Askr/Drw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,213,1708416000"; 
   d="scan'208";a="28121420"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by orviesa005.jf.intel.com with ESMTP; 19 Apr 2024 07:06:54 -0700
Date: Fri, 19 Apr 2024 22:01:39 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	isaku.yamahata@intel.com, xiaoyao.li@intel.com,
	binbin.wu@linux.intel.com, seanjc@google.com,
	rick.p.edgecombe@intel.com
Subject: Re: [PATCH 2/7] KVM: Add KVM_MAP_MEMORY vcpu ioctl to pre-populate
 guest memory
Message-ID: <ZiJ5Q3/ThsomR/Wa@yilunxu-OptiPlex-7050>
References: <20240417153450.3608097-1-pbonzini@redhat.com>
 <20240417153450.3608097-3-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240417153450.3608097-3-pbonzini@redhat.com>

On Wed, Apr 17, 2024 at 11:34:45AM -0400, Paolo Bonzini wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> Add a new ioctl KVM_MAP_MEMORY in the KVM common code. It iterates on the
> memory range and calls the arch-specific function.  Add stub arch function
> as a weak symbol.

The weak symbol is gone.

Thanks,
Yilun

