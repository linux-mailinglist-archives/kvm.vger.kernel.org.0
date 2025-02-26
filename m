Return-Path: <kvm+bounces-39265-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DACCCA45A30
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 10:36:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DBBCE16DF89
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 09:36:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5333226D0F;
	Wed, 26 Feb 2025 09:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OvLi49DY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3913C20E302;
	Wed, 26 Feb 2025 09:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740562597; cv=none; b=YctwC09uzU0emWpyVBikpMa9emyR3VMQR3In65iMxTQNwUhTADP6Q08wNvg8UxszQcMACHfZ2BcUKz1EuXcsgjAj5l/T53xGe+eVT0bcPVllRDv6uZYI/GJ1fyts72tZIUv0xlccrVQNI5xofnyifE/e6NmoNFVkFnvm82Z/nyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740562597; c=relaxed/simple;
	bh=dRGPgXSlsmGm/cpvYopV/a54JFonx+29DpE/VBF/K3I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SeUaTzoLMk3XF/FQc4/6CIpGVVeWhVMfpyPYDwTeDOCM1MO/4DReAxRtE0YOBUqs8S7ti4Gbj4SdJxw8GQyuzynVHGj+Mq6lMOJKfZiO48kvGMOutYYjEhdMDWXJxRfHU42Bz0ig2c5wBJEGpEZM5T+lv6RMGdf8lGTNwM/2+f4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OvLi49DY; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740562596; x=1772098596;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=dRGPgXSlsmGm/cpvYopV/a54JFonx+29DpE/VBF/K3I=;
  b=OvLi49DYQfkAsd82YMeTb0KJ5Zr9OzohYx51eogxvfvv7puI8OnT+b+Z
   jibD8bk8B0YdHCCkW7cdOKyrYYMeVW6ln+xGHKn5RKsZt37AD+RAdsiaj
   eu6tbXiMzlgBHmpR3y14ECbgustYHsyAvjXBN0imvNsR4sImF7d0NHci/
   piIy3mhpLPV5xoWh3mqV42veWgqSJ53QnMi6JxqVAA0YFtMF1KkuFtAL8
   Url4uLgNcrUAvwqyhRIr9SS6PHulAhDsJqXDD9xavPe10gO48skK8KknR
   5YAijhHvw+pQVlxa02fek71maZaRsuRkZxFhbmTIdZ04b5W8qqJEp4Fvt
   Q==;
X-CSE-ConnectionGUID: Feo6Uuw7SdGrRKOAOJdP2w==
X-CSE-MsgGUID: 1OY+cWqjTHen4SvLkE3mhQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11356"; a="44224204"
X-IronPort-AV: E=Sophos;i="6.13,316,1732608000"; 
   d="scan'208";a="44224204"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2025 01:36:35 -0800
X-CSE-ConnectionGUID: jFeAnA6nSWa4BN/gDJ3S8w==
X-CSE-MsgGUID: iU31LXULTYqiQVUHxfsLaA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,316,1732608000"; 
   d="scan'208";a="121751577"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2025 01:36:32 -0800
Message-ID: <68f771b1-0a7e-44e7-8db6-956b8cfb4112@intel.com>
Date: Wed, 26 Feb 2025 17:36:28 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 7/9] KVM: TDX: Handle TDG.VP.VMCALL<ReportFatalError>
To: Binbin Wu <binbin.wu@linux.intel.com>, pbonzini@redhat.com,
 seanjc@google.com, kvm@vger.kernel.org
Cc: rick.p.edgecombe@intel.com, kai.huang@intel.com, adrian.hunter@intel.com,
 reinette.chatre@intel.com, tony.lindgren@intel.com,
 isaku.yamahata@intel.com, yan.y.zhao@intel.com, chao.gao@intel.com,
 linux-kernel@vger.kernel.org
References: <20250222014225.897298-1-binbin.wu@linux.intel.com>
 <20250222014225.897298-8-binbin.wu@linux.intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250222014225.897298-8-binbin.wu@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/22/2025 9:42 AM, Binbin Wu wrote:
> @@ -6849,9 +6850,11 @@ Valid values for 'type' are:
>      reset/shutdown of the VM.
>    - KVM_SYSTEM_EVENT_SEV_TERM -- an AMD SEV guest requested termination.
>      The guest physical address of the guest's GHCB is stored in `data[0]`.
> - - KVM_SYSTEM_EVENT_WAKEUP -- the exiting vCPU is in a suspended state and
> -   KVM has recognized a wakeup event. Userspace may honor this event by
> -   marking the exiting vCPU as runnable, or deny it and call KVM_RUN again.

It deletes the description of KVM_SYSTEM_EVENT_WAKEUP by mistake;

(Maybe we can fix the order of the descriptions by the way, 
KVM_SYSTEM_EVENT_SEV_TERM gets put in front of KVM_SYSTEM_EVENT_WAKEUP 
and KVM_SYSTEM_EVENT_SUSPEND)

> + - KVM_SYSTEM_EVENT_TDX_FATAL -- a TDX guest reported a fatal error state.
> +   KVM doesn't do any parsing or conversion, it just dumps 16 general-purpose
> +   registers to userspace, in ascending order of the 4-bit indices for x86-64
> +   general-purpose registers in instruction encoding, as defined in the Intel
> +   SDM.
>    - KVM_SYSTEM_EVENT_SUSPEND -- the guest has requested a suspension of
>      the VM.


