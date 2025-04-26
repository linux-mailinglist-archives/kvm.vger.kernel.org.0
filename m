Return-Path: <kvm+bounces-44395-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 30DD1A9D905
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 09:28:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BB5EF9A68A6
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 07:28:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 363B424EA85;
	Sat, 26 Apr 2025 07:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="RjCSEzfE"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FCCD192D97;
	Sat, 26 Apr 2025 07:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745652496; cv=none; b=FsM5Jp3qVceYJEXqiwhGuR+18GDtWCZQFpMdAvM8RABNLDbpm/GAXkkHDqty+OyBkuWxX8SS11qjkUsswjSOCKz1Z3T9TR23p2gwGBbUhAz9+P/a/aQxYAtyngrjKd3gVmm4zxml6UZRsmksTcE2Z0oNb4WVUU3WZiofF6MriOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745652496; c=relaxed/simple;
	bh=XjMjO7HflcfiRrSXpoSWT54pSI6eenhpN6xe1KG2F+g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lcGye+Fzy4pavwNqtPvdn59Msv2TM2y7fFhc1wTRX75ClwZ+unhkArnSlEUMcLHqvgLuZSrENgFvmrYg3bq5DFTXLi251uy4LrvK0LWyEMZG21EFCSR1k6PmMeGhxbZxMtX4olELmw4AQI3PxTDjYjMpRwgWz5hfr3Y73Z0Cr20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=RjCSEzfE; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from [192.168.7.202] ([71.202.166.45])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 53Q7RDlh4064371
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Sat, 26 Apr 2025 00:27:14 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 53Q7RDlh4064371
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025042001; t=1745652440;
	bh=9M1Htgas0CGK26R6ri7TrX3Gr2qZnASXeVTeX3rMiIs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=RjCSEzfElpajKkgYYkV/+MBKINyow1AsiXOQ9t25nN80YY48sfqpaQzNKvS9wovLg
	 89fcrOmFuSALWEVhtziqyKoX4p5+bDKC5sOXnITQu0I9pzln1i6o6Kx+Zinny/P5J/
	 NtEGeb3UHVlgAvvXUqporCfcK2cJ/ScxE0e/jUuyshXzNKua/GrB89ci8uE7KvUwGr
	 Y+kiGMd8OPAUFViUOU2URxLWLLEYaoVuPqTFFCaZP8kPE0qL1U3xNnaxmiw3VuRSm3
	 mSAabdcMTMuBrPZX+0RkvM1HHS/HvGIAZaennDGAFdhkrlTWeAl7NP0whBGetXW0Sb
	 G0dkIqzJjgfFg==
Message-ID: <e62b81f3-1952-43e6-85fd-18c6f37d531d@zytor.com>
Date: Sat, 26 Apr 2025 00:27:12 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 01/14] x86/msr: Move rdtsc{,_ordered}() to <asm/tsc.h>
To: =?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        linux-perf-users@vger.kernel.org, linux-hyperv@vger.kernel.org,
        virtualization@lists.linux.dev, linux-pm@vger.kernel.org,
        linux-edac@vger.kernel.org, xen-devel@lists.xenproject.org,
        linux-acpi@vger.kernel.org, linux-hwmon@vger.kernel.org,
        Netdev <netdev@vger.kernel.org>, platform-driver-x86@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        acme@kernel.org, jgross@suse.com, andrew.cooper3@citrix.com,
        peterz@infradead.org, namhyung@kernel.org, mark.rutland@arm.com,
        alexander.shishkin@linux.intel.com, jolsa@kernel.org,
        irogers@google.com, adrian.hunter@intel.com, kan.liang@linux.intel.com,
        wei.liu@kernel.org, ajay.kaher@broadcom.com,
        bcm-kernel-feedback-list@broadcom.com, tony.luck@intel.com,
        pbonzini@redhat.com, vkuznets@redhat.com, seanjc@google.com,
        luto@kernel.org, boris.ostrovsky@oracle.com, kys@microsoft.com,
        haiyangz@microsoft.com, decui@microsoft.com,
        dapeng1.mi@linux.intel.com
References: <20250425083442.2390017-1-xin@zytor.com>
 <20250425083442.2390017-2-xin@zytor.com>
 <42dc90e1-df2a-2324-d28c-d75fb525e4a2@linux.intel.com>
Content-Language: en-US
From: Xin Li <xin@zytor.com>
Autocrypt: addr=xin@zytor.com; keydata=
 xsDNBGUPz1cBDACS/9yOJGojBFPxFt0OfTWuMl0uSgpwk37uRrFPTTLw4BaxhlFL0bjs6q+0
 2OfG34R+a0ZCuj5c9vggUMoOLdDyA7yPVAJU0OX6lqpg6z/kyQg3t4jvajG6aCgwSDx5Kzg5
 Rj3AXl8k2wb0jdqRB4RvaOPFiHNGgXCs5Pkux/qr0laeFIpzMKMootGa4kfURgPhRzUaM1vy
 bsMsL8vpJtGUmitrSqe5dVNBH00whLtPFM7IbzKURPUOkRRiusFAsw0a1ztCgoFczq6VfAVu
 raTye0L/VXwZd+aGi401V2tLsAHxxckRi9p3mc0jExPc60joK+aZPy6amwSCy5kAJ/AboYtY
 VmKIGKx1yx8POy6m+1lZ8C0q9b8eJ8kWPAR78PgT37FQWKYS1uAroG2wLdK7FiIEpPhCD+zH
 wlslo2ETbdKjrLIPNehQCOWrT32k8vFNEMLP5G/mmjfNj5sEf3IOKgMTMVl9AFjsINLHcxEQ
 6T8nGbX/n3msP6A36FDfdSEAEQEAAc0WWGluIExpIDx4aW5Aenl0b3IuY29tPsLBDQQTAQgA
 NxYhBIUq/WFSDTiOvUIqv2u9DlcdrjdRBQJlD89XBQkFo5qAAhsDBAsJCAcFFQgJCgsFFgID
 AQAACgkQa70OVx2uN1HUpgv/cM2fsFCQodLArMTX5nt9yqAWgA5t1srri6EgS8W3F+3Kitge
 tYTBKu6j5BXuXaX3vyfCm+zajDJN77JHuYnpcKKr13VcZi1Swv6Jx1u0II8DOmoDYLb1Q2ZW
 v83W55fOWJ2g72x/UjVJBQ0sVjAngazU3ckc0TeNQlkcpSVGa/qBIHLfZraWtdrNAQT4A1fa
 sWGuJrChBFhtKbYXbUCu9AoYmmbQnsx2EWoJy3h7OjtfFapJbPZql+no5AJ3Mk9eE5oWyLH+
 QWqtOeJM7kKvn/dBudokFSNhDUw06e7EoVPSJyUIMbYtUO7g2+Atu44G/EPP0yV0J4lRO6EA
 wYRXff7+I1jIWEHpj5EFVYO6SmBg7zF2illHEW31JAPtdDLDHYcZDfS41caEKOQIPsdzQkaQ
 oW2hchcjcMPAfyhhRzUpVHLPxLCetP8vrVhTvnaZUo0xaVYb3+wjP+D5j/3+hwblu2agPsaE
 vgVbZ8Fx3TUxUPCAdr/p73DGg57oHjgezsDNBGUPz1gBDAD4Mg7hMFRQqlzotcNSxatlAQNL
 MadLfUTFz8wUUa21LPLrHBkUwm8RujehJrzcVbPYwPXIO0uyL/F///CogMNx7Iwo6by43KOy
 g89wVFhyy237EY76j1lVfLzcMYmjBoTH95fJC/lVb5Whxil6KjSN/R/y3jfG1dPXfwAuZ/4N
 cMoOslWkfZKJeEut5aZTRepKKF54T5r49H9F7OFLyxrC/uI9UDttWqMxcWyCkHh0v1Di8176
 jjYRNTrGEfYfGxSp+3jYL3PoNceIMkqM9haXjjGl0W1B4BidK1LVYBNov0rTEzyr0a1riUrp
 Qk+6z/LHxCM9lFFXnqH7KWeToTOPQebD2B/Ah5CZlft41i8L6LOF/LCuDBuYlu/fI2nuCc8d
 m4wwtkou1Y/kIwbEsE/6RQwRXUZhzO6llfoN96Fczr/RwvPIK5SVMixqWq4QGFAyK0m/1ap4
 bhIRrdCLVQcgU4glo17vqfEaRcTW5SgX+pGs4KIPPBE5J/ABD6pBnUUAEQEAAcLA/AQYAQgA
 JhYhBIUq/WFSDTiOvUIqv2u9DlcdrjdRBQJlD89ZBQkFo5qAAhsMAAoJEGu9DlcdrjdR4C0L
 /RcjolEjoZW8VsyxWtXazQPnaRvzZ4vhmGOsCPr2BPtMlSwDzTlri8BBG1/3t/DNK4JLuwEj
 OAIE3fkkm+UG4Kjud6aNeraDI52DRVCSx6xff3bjmJsJJMb12mWglN6LjdF6K+PE+OTJUh2F
 dOhslN5C2kgl0dvUuevwMgQF3IljLmi/6APKYJHjkJpu1E6luZec/lRbetHuNFtbh3xgFIJx
 2RpgVDP4xB3f8r0I+y6ua+p7fgOjDLyoFjubRGed0Be45JJQEn7A3CSb6Xu7NYobnxfkwAGZ
 Q81a2XtvNS7Aj6NWVoOQB5KbM4yosO5+Me1V1SkX2jlnn26JPEvbV3KRFcwV5RnDxm4OQTSk
 PYbAkjBbm+tuJ/Sm+5Yp5T/BnKz21FoCS8uvTiziHj2H7Cuekn6F8EYhegONm+RVg3vikOpn
 gao85i4HwQTK9/D1wgJIQkdwWXVMZ6q/OALaBp82vQ2U9sjTyFXgDjglgh00VRAHP7u1Rcu4
 l75w1xInsg==
In-Reply-To: <42dc90e1-df2a-2324-d28c-d75fb525e4a2@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 4/25/2025 8:45 AM, Ilpo Järvinen wrote:
> To me this looks really a random set of source files, maybe it helped some
> build success but it's hard for me to review this because there are still
> cases that depend on indirect include chains.
> 
> Could you just look into solving all missing msr.h includes instead
> as clearly some are still missing after 3 pre-existing ones and you adding
> it into 3 files:
> 
> $ git grep -e rdmsr -e wrmsr -l drivers/platform/x86/
> drivers/platform/x86/intel/ifs/core.c
> drivers/platform/x86/intel/ifs/load.c
> drivers/platform/x86/intel/ifs/runtest.c
> drivers/platform/x86/intel/pmc/cnp.c
> drivers/platform/x86/intel/pmc/core.c
> drivers/platform/x86/intel/speed_select_if/isst_if_common.c
> drivers/platform/x86/intel/speed_select_if/isst_if_mbox_msr.c
> drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c
> drivers/platform/x86/intel/tpmi_power_domains.c
> drivers/platform/x86/intel/turbo_max_3.c
> drivers/platform/x86/intel/uncore-frequency/uncore-frequency.c
> drivers/platform/x86/intel_ips.c
> 
> $ git grep -e 'msr.h' -l drivers/platform/x86/
> drivers/platform/x86/intel/pmc/core.c
> drivers/platform/x86/intel/tpmi_power_domains.c
> drivers/platform/x86/intel_ips.c

I think you want me to add all necessary direct inclusions, right?

This is the right thing to do, and I did try it but gave up later.

I will do it in the next iteration as you asked.  But I want to make my
points:

1) It's not just two patterns {rd,wr}msr, there are a lot of definitions
    in <asm/msr.h> and we need to cover all of them:

       struct msr_info
       struct msr_regs_info
       struct saved_msr
       struct saved_msrs
       {read,write}_msr
       rdpmc
       .*msr.*_on_cpu

2) Once all necessary direct inclusions are in place, it's easy to
    overlook adding a header inclusion in practice, especially if the
    build passes.  Besides we often forget to remove a header when a
    definition is removed.  In other words, direct inclusion is hard to
    maintain.

3) Some random kernel configuration combinations can cause the current
    kernel build to fail.  I hit one in x86 UML.


We all know Ingo is the best person to discuss this with :).  While my
understanding of the header inclusion issue may be inaccurate or
outdated.

So for me, using "make allyesconfig" is a practical method for a quick
local build check, plus I always send my patches to Intel LKP.


There probably wants a script that identifies all files that reference a
definition in a header thus need to include it explicitly.  And indirect
includes should be zapped.


> 
> I'd also prefer the patch(es) adding missing includes be in a different
> patch.

Great suggestion!  It clearly highlights the most significant changes.

Thanks!
     Xin

