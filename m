Return-Path: <kvm+bounces-68462-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id AA582D39D9F
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 06:11:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id AE2AF30081B9
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 05:11:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41D2C32F766;
	Mon, 19 Jan 2026 05:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dBPNxGo3"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A09EC2EA
	for <kvm@vger.kernel.org>; Mon, 19 Jan 2026 05:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768799496; cv=none; b=InzSMXC0yeg5RrlsMv5ZDQOE74tdc6Up8myWgHPj5mGu+bf7PTry2a3GHssMuTkdR+Hpj25pdTVk21rujfGULVY2ZSN/tRlsZOkHcPuJfc6IXx50sAyQGOE7FNeCnaRhfnXbAYXwKDL0Yrlg+ebVYxyZVPqnhISnwoBQ3STvsno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768799496; c=relaxed/simple;
	bh=F3ZmE+K8iQIwTrl0flL1UXcjJ1vcmWXrTI1rsoIx2JY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RzAj2X4q+QzBf7f7ljOyIJebT2JZRWLGXJMH6vrZIhM3d4xVDivL/MNDQqAyEhXVmsQBcdxAlngrxjx7sE1FZeSP+uqPEksw3RqVMcLOLuvyseTOTiZbiVmkOwmqRrW1J5+18IoTmj/MdGUdAJDMfuL8KibdCztwz/diOT+ATzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dBPNxGo3; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768799493; x=1800335493;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=F3ZmE+K8iQIwTrl0flL1UXcjJ1vcmWXrTI1rsoIx2JY=;
  b=dBPNxGo3ypMXrBtnFEnrr0Dgp1+curfWdmHS8qIWedUSLGYQQ2L8sAZS
   zG56SWw7LpN0tQijCLnqQCSCLXxgub91Sje5d03QL7KSXEilCsNGlHZpC
   6DdGXg5get4JfPIC7t2Dz38BUPOuCrXT4NFH9YzBVjLgw9aii1/kkTbri
   kp59fqu5605IqTA+VsBBp/S/KEbn3ur0oQ+KLiSQmdS+SVwG+5LyA04kI
   m+xXJHtf2UbbFdoKELm0UjyuhXZnr39WA0nVm97IAES69zBa+SGYsKNaf
   JjnXL1571hENyST2JhRIEx3bNKPfk41vWwxhetJEYqHC7NRr1ew2LZS0G
   A==;
X-CSE-ConnectionGUID: EsfMTJCZTMKyqCvupqIXjw==
X-CSE-MsgGUID: q+tJJyarRi6xfneHMCAdDg==
X-IronPort-AV: E=McAfee;i="6800,10657,11675"; a="69918422"
X-IronPort-AV: E=Sophos;i="6.21,237,1763452800"; 
   d="scan'208";a="69918422"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2026 21:11:32 -0800
X-CSE-ConnectionGUID: fy0Ge2oNQBOdXuJXDNq82w==
X-CSE-MsgGUID: zUBkyUFTSBSIUa5xhSSrDQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,237,1763452800"; 
   d="scan'208";a="243340665"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by orviesa001.jf.intel.com with ESMTP; 18 Jan 2026 21:11:31 -0800
Date: Mon, 19 Jan 2026 13:37:01 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>
Cc: qemu-devel@nongnu.org, Richard Henderson <richard.henderson@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	"Dr. David Alan Gilbert" <dave@treblig.org>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v2 1/8] target/i386: Include missing 'svm.h' header in
 'sev.h'
Message-ID: <aW3C/eLwSoqsvOtt@intel.com>
References: <20260117162926.74225-1-philmd@linaro.org>
 <20260117162926.74225-2-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260117162926.74225-2-philmd@linaro.org>

On Sat, Jan 17, 2026 at 05:29:19PM +0100, Philippe Mathieu-Daudé wrote:
> Date: Sat, 17 Jan 2026 17:29:19 +0100
> From: Philippe Mathieu-Daudé <philmd@linaro.org>
> Subject: [PATCH v2 1/8] target/i386: Include missing 'svm.h' header in
>  'sev.h'
> X-Mailer: git-send-email 2.52.0
> 
> otarget/i386/cpu.h:2820:#include "svm.h"
> target/i386/sev.h:17:#include "target/i386/svm.h"
> 
> "target/i386/sev.h" uses the vmcb_seg structure type, which
> is defined in "target/i386/svm.h". Current builds succeed
> because the files including "target/i386/sev.h" also include
> "monitor/hmp-target.h", itself including "cpu.h" and finally
> "target/i386/svm.h".
> 
> Include the latter, otherwise removing "cpu.h" from
> "monitor/hmp-target.h" triggers:
> 
>   ../target/i386/sev.h:62:21: error: field has incomplete type 'struct vmcb_seg'
>      62 |     struct vmcb_seg es;
>         |                     ^
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>  target/i386/sev.h | 2 ++
>  1 file changed, 2 insertions(+)

Reviewed-by: Zhao Liu <zhao1.liu@intel.com>


