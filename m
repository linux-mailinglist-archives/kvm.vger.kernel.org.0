Return-Path: <kvm+bounces-48327-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5185DACCBF5
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 19:24:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1BF7316BA62
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 17:24:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6706F1F461D;
	Tue,  3 Jun 2025 17:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GNCTI63l"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EAF61DDC1B;
	Tue,  3 Jun 2025 17:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748971427; cv=none; b=MM6qG87FFRvIDW9TzAnlhM/A5pzBIhoGXXdeQAK9N77/ZXwaR8QcwiyaADmZgUfy5k2OGTXvkcJkAAwST6cXx+LgNfBccHl3Mcf5Zw6FsOWc3GrGZMOtUS7CrOJvhvWF5Zvgc4suZjove0c7kzjoN7iZZ1IoDsM4r8fRDaCTyvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748971427; c=relaxed/simple;
	bh=ykRV1XB+sX7MH5kcVruHvL5nbqKZ9uJBNgkXjg3a0Uc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=R7mgXuUJ2W/0IupA5DIbHX0FPwnkWKX0iY6t2qVo09YedCrFlaJldCfdKuhPiNeO24cN9rUP2JYmszSjOfS1mZ+EvsyMIf5cvowjUx52P2iOsAMWMhyvrx8ReqXhqJru2DmGzMLYxrtETH4BZicPOULSJy9c466hfXxSmZVBeqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GNCTI63l; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748971426; x=1780507426;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ykRV1XB+sX7MH5kcVruHvL5nbqKZ9uJBNgkXjg3a0Uc=;
  b=GNCTI63lGRAZuFKToOAejqGwTaMhsOIhCd3/Fe5MAj7XFJ39uEiTKPl4
   6sEAXxO6CupEV3dRI21XWWsFv+P46SpbVa1VgQRHaqOE2vM4mtmP408Fi
   QDii969VCjlwOI6ipdZGqYiLbUfyQlYCguu4qcAavjpJpI63qxdX/1h9v
   7uwX+IMunNoAr3HmXcPVWQXv05jqC+Ew1itMlVL8xqQnzGIsVY3qmlLvB
   MqwnmmAUGh/Vv6pw7So4z6rObZ4DVa/WijadZ2fH/1r/ratQg4pEpMP/W
   x9yInz4faHm5sK7DvZF2uuMGCeOgJU6aGwbT4Z4YKDimy8khmGwBI4ttw
   Q==;
X-CSE-ConnectionGUID: x87llKXERJSh+ZvxA0H2gA==
X-CSE-MsgGUID: pv6N2tdpR0OIyhx66sJTkg==
X-IronPort-AV: E=McAfee;i="6700,10204,11453"; a="51026312"
X-IronPort-AV: E=Sophos;i="6.16,206,1744095600"; 
   d="scan'208";a="51026312"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2025 10:23:45 -0700
X-CSE-ConnectionGUID: +jupPwAMSmi3S1ZMzj0aFQ==
X-CSE-MsgGUID: HjEGz8wES9amMdwHKlvgLg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,206,1744095600"; 
   d="scan'208";a="175789786"
Received: from tjmaciei-mobl5.ger.corp.intel.com (HELO [10.125.110.192]) ([10.125.110.192])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2025 10:23:43 -0700
Message-ID: <e978e1fb-d88e-4789-bd33-367281dfa0ad@intel.com>
Date: Tue, 3 Jun 2025 10:23:42 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 4/9] x86/nmi: Assign and register NMI-source vectors
To: Sohil Mehta <sohil.mehta@intel.com>, x86@kernel.org,
 linux-kernel@vger.kernel.org
Cc: Xin Li <xin@zytor.com>, "H . Peter Anvin" <hpa@zytor.com>,
 Andy Lutomirski <luto@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Peter Zijlstra <peterz@infradead.org>,
 Sean Christopherson <seanjc@google.com>,
 Adrian Hunter <adrian.hunter@intel.com>,
 Kan Liang <kan.liang@linux.intel.com>, Tony Luck <tony.luck@intel.com>,
 Zhang Rui <rui.zhang@intel.com>, Steven Rostedt <rostedt@goodmis.org>,
 Andrew Cooper <andrew.cooper3@citrix.com>,
 "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
 Jacob Pan <jacob.pan@linux.microsoft.com>, Andi Kleen <ak@linux.intel.com>,
 Kai Huang <kai.huang@intel.com>, Sandipan Das <sandipan.das@amd.com>,
 linux-perf-users@vger.kernel.org, linux-edac@vger.kernel.org,
 kvm@vger.kernel.org, linux-pm@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org
References: <20250513203803.2636561-1-sohil.mehta@intel.com>
 <20250513203803.2636561-5-sohil.mehta@intel.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <20250513203803.2636561-5-sohil.mehta@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/13/25 13:37, Sohil Mehta wrote:
...
> + * Vector 2 is reserved for external NMIs related to the Local APIC -
> + * LINT1. Some third-party chipsets may send NMI messages with a
> + * hardcoded vector of 2, which would result in bit 2 being set in the
> + * NMI-source bitmap.

This doesn't actually say what problem this causes. Is this better?

	Third-party chipsets send NMI messages with a fixed vector of 2.
	Using vector 2 for some other purpose would cause confusion
	between those Local APIC messages and the other purpose. Avoid
	using it.

> + * The vectors are in no particular priority order. Add new vector
> + * assignments sequentially in the list below.
> + */
> +#define NMIS_VECTOR_NONE	0	/* Reserved - Set for all unidentified sources */
> +#define NMIS_VECTOR_TEST	1	/* NMI selftest */
> +#define NMIS_VECTOR_EXTERNAL	2	/* Reserved - Match External NMI vector 2 */
> +#define NMIS_VECTOR_SMP_STOP	3	/* Panic stop CPU */
> +#define NMIS_VECTOR_BT		4	/* CPU backtrace */
> +#define NMIS_VECTOR_KGDB	5	/* Kernel debugger */
> +#define NMIS_VECTOR_MCE		6	/* MCE injection */
> +#define NMIS_VECTOR_PMI		7	/* PerfMon counters */
> +
> +#define NMIS_VECTORS_MAX	16	/* Maximum number of NMI-source vectors */

Would an enum fit here?

You could also add a:

	NMIS_VECTOR_COUNT

as the last entry and then just:

	BUILD_BUG_ON(NMIS_VECTOR_COUNT >= 16);

somewhere.

I guess it's a little annoying that you need NMIS_VECTOR_EXTERNAL to
have a fixed value of 2, but I do like way the enum makes the type explicit.


>  static int __init register_nmi_cpu_backtrace_handler(void)
>  {
> -	register_nmi_handler(NMI_LOCAL, nmi_cpu_backtrace_handler, 0, "arch_bt", 0);
> +	register_nmi_handler(NMI_LOCAL, nmi_cpu_backtrace_handler, 0, "arch_bt", NMIS_VECTOR_BT);
>  	return 0;
>  }

... Oh you replaced _most_ of the random 0's in this patch. That helps
for sure.

