Return-Path: <kvm+bounces-50383-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 59ABAAE4ACD
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 18:27:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B15811B64BF9
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 16:20:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D1352DECDF;
	Mon, 23 Jun 2025 16:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="SZ1GzJXM"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 317F72DCC03;
	Mon, 23 Jun 2025 16:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750695049; cv=none; b=ZxZrmRGBTNKRlMrcD3yooNoVP7v3KY9d2WXx04jRH+nKQjxlN2CrkOFCuUKzwBsA7wKpeefIrmvjDlLvuZOPB+DtJ2oTFKbVDCXz62DfB0CQ4sI61+UVRKJ9BUnReT3LHjwWGvMblJ+vYAe8gbb2VD95C7+J7T8L+Q93R9/NSNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750695049; c=relaxed/simple;
	bh=dS7QgYeAznkgEhzk7h32qFFNi0yjzq3+ztoyxkZ//XI=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=KkmOfsxEnX+zFY7ozqQrENFPOunPNJqiRc8LWmzk/ciN22YZcPLKSoqwKX1L6c8aROL8bnf8lcSC6FO/OKgWtTnIyqdqEyRpk/k6pLcFukzIMdywTm4sTIE55X0nqlxUFlGmWXIv5nF2Xra5rIig7KV0xBQgkUGZX868LZDEMe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=SZ1GzJXM; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from [127.0.0.1] (c-76-133-66-138.hsd1.ca.comcast.net [76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 55NGA7TK995696
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Mon, 23 Jun 2025 09:10:08 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 55NGA7TK995696
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025062101; t=1750695009;
	bh=5OyKvEljcKH+TeDJlGA4fkMB6CCrF6QEZCXe4uNmwAs=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=SZ1GzJXMbd0V6nYkSdQZSdPQcNAKb5MOvCof6U/mOuVB+0QaDBj59VWf5L9cRdgqT
	 itNQlfH2W269PbEwmkNbvulkUpxD/UUYAf21tFgjmxP08jvyuS59WLfrXO0m+c+x4l
	 WGgqQOEmbV8yWjnJbwQmrkLJWBOUzH7/BPGJMQ4Y68rNvdHRoftSH09vAnFWX9ThT1
	 b2fq5G5sXTvRlAM00Jmft2M0hQci085Nr0JAd9nUZ6EHm2uxF9g9YYRyZy+Y40PHfc
	 dnNB/soxXQbG5F09Aq5J3cTLdmikLWRCSI3dwlJg8OoNQMHVTDWjdoHBDNBYN8PW30
	 mT6yD9MhrJm5w==
Date: Mon, 23 Jun 2025 09:10:07 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
To: Sean Christopherson <seanjc@google.com>
CC: Sohil Mehta <sohil.mehta@intel.com>, Xin Li <xin@zytor.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>, Tony Luck <tony.luck@intel.com>,
        Zhang Rui <rui.zhang@intel.com>, Steven Rostedt <rostedt@goodmis.org>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Jacob Pan <jacob.pan@linux.microsoft.com>,
        Andi Kleen <ak@linux.intel.com>, Kai Huang <kai.huang@intel.com>,
        Sandipan Das <sandipan.das@amd.com>, linux-perf-users@vger.kernel.org,
        linux-edac@vger.kernel.org, kvm@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-trace-kernel@vger.kernel.org
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v7_02/10=5D_x86/fred=3A_Pass_eve?=
 =?US-ASCII?Q?nt_data_to_the_NMI_entry_point_from_KVM?=
User-Agent: K-9 Mail for Android
In-Reply-To: <aFl1PcnVuYuELvRQ@google.com>
References: <20250612214849.3950094-1-sohil.mehta@intel.com> <20250612214849.3950094-3-sohil.mehta@intel.com> <7525af7f-a817-47d5-91f7-d7702380c85f@zytor.com> <3281866f-2593-464d-a77e-5893b5e7014f@intel.com> <36374100-0587-47f1-9319-6333f6dfe4db@zytor.com> <39987c98-1f63-4a47-b15e-8c78f632da4e@intel.com> <7acedeba-9c90-403c-8985-0247981bf2b5@zytor.com> <aFXsPVIKi6wFUB6x@google.com> <1713a225-44e0-4018-bf5f-64ffd7746167@zytor.com> <aFl1PcnVuYuELvRQ@google.com>
Message-ID: <D00BE3D4-C710-4304-85D3-B2A091E08035@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

On June 23, 2025 8:39:41 AM PDT, Sean Christopherson <seanjc@google=2Ecom> =
wrote:
>On Fri, Jun 20, 2025, H=2E Peter Anvin wrote:
>> On 2025-06-20 16:18, Sean Christopherson wrote:
>> > >=20
>> > > So I was thinking about this, and wonder: how expensive is it to ge=
t the
>> > > event data exit information out of VMX? If it is not very expensive=
, it
>> > > would arguably be a good thing to future-proof by fetching that inf=
ormation,
>> > > even if it is currently always zero=2E
>> >=20
>> > It's trivially easy to do in KVM, and the cost of the VMREAD should b=
e less than
>> > 20 cycles=2E  So quite cheap in the grand scheme=2E  If VMREAD is mor=
e costly than
>> > that, then we have bigger problems :-)
>> >=20
>>=20
>> LOL=2E Since it is up to you, Paulo, etc=2E to decide how to do the tra=
deoffs
>> formaintainability, debuggability and performance in KVM I am guessing =
this
>> is a vote in favor? (You can always take it out if it is a performance
>> problem, until such time that the kernel itself starts consuming this
>> information for reasons currently unknown=2E)
>
>Unless you can pinky swear that vmcs=2EEXIT_QUALIFICATION will provide ev=
ent data
>for IRQ exits, then I'd prefer to pass '0' unconditionally=2E  '0' will a=
lways be
>safe, if potentially suboptimal=2E  But passing what could in theory be s=
omething
>other than FRED-formatted event data could lead to buggy behavior=2E  Per=
 the FRED
>spec, Revision 7=2E0, exit-qualification doesn't hold event data for IRQ =
exits=2E
>
>  For some events for which event data is defined (see Section 5=2E2=2E1)=
, the event
>  data is saved in the exit-qualification field=2E (This is done for #DB,=
 #PF, and NMI=2E)

I agree, let's stick to that for now, since this is a kernel internal inte=
rface and nothing consumes it=2E After all, it will save a handful of cycle=
s=2E

I will still check into the "pinky swear", though=2E

