Return-Path: <kvm+bounces-43860-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 45692A97B9C
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 02:18:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A6C1B7A8015
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 00:17:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99D651EE02F;
	Wed, 23 Apr 2025 00:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ZXnPxwMI"
X-Original-To: kvm@vger.kernel.org
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB1981E98E0
	for <kvm@vger.kernel.org>; Wed, 23 Apr 2025 00:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745367488; cv=none; b=Dvx14mY2PNwiROvbJPy+OTNTdvIKicyQqVEZSM03kGxRjACte9zcBi25duJc83nSza5IG1H9K8PHiNBioBB/6ESF7aTr9Zbp/YPD+XYfGWrx9/+r2GL33fbmwW0Z/r3DkPu1CsI2rZXQWy43jNLqrBP1qgTmRJlFcdv4RlUXzjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745367488; c=relaxed/simple;
	bh=oCq3FEMp4oYWYDtLba7KpYl9dlOTixalU2uzeiDdgFQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TaVIyN1pnRS9yvlkn7KwPPl0vO+hpuxY49nJKa5TN3DidZyteQH85hlUV1mgT5zQtVGR/fZiw01SNYmhJeQaiinfjW0jA7yjLf/z4kMhzrWr+H1/qu6KL2r8cCZLXgdPznyAFJ/KmY7zmPDI2pp/9dvtYVfpQVrWfTM+GhLQ3uM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ZXnPxwMI; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Message-ID: <9d827020-ee6c-40c2-a83d-7eb9a00f8aa8@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1745367484;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QxWWJwIhRG++LmaYSHq+CfihXUQKS791vet7ACFep64=;
	b=ZXnPxwMIzj+wa71041mXF8qVCG8DMEdoDp5cKh6/OMUSbnHJsUOr8pPMBvEd3bQ/lHmxd/
	261GdghcLYCbTAGewnTK4Ot6fNFDvrhR49od4TTjQzTj23cS2qBBQ4F8ovitKxuEcZ+fxm
	Zux3jbOBlbr4jgIwtMYVJCM6Qj1SoZM=
Date: Tue, 22 Apr 2025 17:17:56 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v5 20/21] tools/perf: Pass the Counter constraint values
 in the pmu events
To: Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Ian Rogers <irogers@google.com>
Cc: linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
 Conor Dooley <conor@kernel.org>, devicetree@vger.kernel.org,
 kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
 linux-arm-kernel@lists.infradead.org, linux-perf-users@vger.kernel.org,
 Jiri Olsa <jolsa@kernel.org>, Paul Walmsley <paul.walmsley@sifive.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Rob Herring <robh@kernel.org>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley
 <conor+dt@kernel.org>, Anup Patel <anup@brainfault.org>,
 Atish Patra <atishp@atishpatra.org>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, Peter Zijlstra <peterz@infradead.org>,
 Ingo Molnar <mingo@redhat.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Adrian Hunter <adrian.hunter@intel.com>
References: <20250327-counter_delegation-v5-0-1ee538468d1b@rivosinc.com>
 <20250327-counter_delegation-v5-20-1ee538468d1b@rivosinc.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Atish Patra <atish.patra@linux.dev>
In-Reply-To: <20250327-counter_delegation-v5-20-1ee538468d1b@rivosinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

On 3/27/25 12:36 PM, Atish Patra wrote:
> RISC-V doesn't have any standard event to counter mapping discovery
> mechanism in the ISA. The ISA defines 29 programmable counters and
> platforms can choose to implement any number of them and map any
> events to any counters. Thus, the perf tool need to inform the driver
> about the counter mapping of each events.
> 
> The current perf infrastructure only parses the 'Counter' constraints
> in metrics. This patch extends that to pass in the pmu events so that
> any driver can retrieve those values via perf attributes if defined
> accordingly.
> 

Hi Ian/Arnaldo/Namhyung,
Any thoughts on this patch ? Please let me know if there are any other 
better approaches to pass the counter constraints to the driver ?

The RISC-V pmu driver maps the attr.config2 with counterid_mask value
so that driver can parse the counter restrictions.


> Signed-off-by: Atish Patra <atishp@rivosinc.com>
> ---
>   tools/perf/pmu-events/jevents.py | 9 +++++++++
>   1 file changed, 9 insertions(+)
> 
> diff --git a/tools/perf/pmu-events/jevents.py b/tools/perf/pmu-events/jevents.py
> index fdb7ddf093d2..f9f274678a32 100755
> --- a/tools/perf/pmu-events/jevents.py
> +++ b/tools/perf/pmu-events/jevents.py
> @@ -274,6 +274,11 @@ class JsonEvent:
>           return fixed[name.lower()]
>         return event
>   
> +    def counter_list_to_bitmask(counterlist):
> +      counter_ids = list(map(int, counterlist.split(',')))
> +      bitmask = sum(1 << pos for pos in counter_ids)
> +      return bitmask
> +
>       def unit_to_pmu(unit: str) -> Optional[str]:
>         """Convert a JSON Unit to Linux PMU name."""
>         if not unit or unit == "core":
> @@ -427,6 +432,10 @@ class JsonEvent:
>         else:
>           raise argparse.ArgumentTypeError('Cannot find arch std event:', arch_std)
>   
> +    if self.counters['list']:
> +      bitmask = counter_list_to_bitmask(self.counters['list'])
> +      event += f',counterid_mask={bitmask:#x}'
> +
>       self.event = real_event(self.name, event)
>   
>     def __repr__(self) -> str:
> 


