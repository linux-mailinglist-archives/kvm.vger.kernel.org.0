Return-Path: <kvm+bounces-60876-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9AA93C000A5
	for <lists+kvm@lfdr.de>; Thu, 23 Oct 2025 10:57:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 47CF619C0B27
	for <lists+kvm@lfdr.de>; Thu, 23 Oct 2025 08:57:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 583293043D6;
	Thu, 23 Oct 2025 08:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="JmJGuWUp"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41EC03016FD;
	Thu, 23 Oct 2025 08:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761209803; cv=none; b=qoIgAA9NkhYQlSAzbVIxLeLyy2pUQ4Tt5c/SNBDOl/LK7GHPsjTuGFp9cHFdquhplUzo2rRgdpj39Jln2AoaPbbQVFc59IaAXdX+9XK0uAVfMKlV/yEoNNW6ddQVgawyHuoafr81b9oLK5Nr0k98tvJMoh9w6ol3oPtI30LwtgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761209803; c=relaxed/simple;
	bh=o5TYKn6ZQH/S68mLBVpwQgYkziwY+xEZaTQuco5M3fk=;
	h=Content-Type:From:Mime-Version:Subject:Date:Message-Id:References:
	 Cc:In-Reply-To:To; b=doM48xM9aiZYP8pkoEzaaqvXepUM2HO25Ek4keEguFdDyktb0sJyKUgFCp4EYkiW3tVOOePrIshZk+W1EyAd/P3EViTysF6U54R8BrKCoU+4V3Z7dmraMswg2W2NSY86GSRGyNawC1p/pRs7sdPWi95uah1+D9rPSYyV+JTTkXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=JmJGuWUp; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from smtpclient.apple ([71.202.166.45])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 59N8u2r02714832
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Thu, 23 Oct 2025 01:56:02 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 59N8u2r02714832
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025092201; t=1761209763;
	bh=JkYq4hrpelkGO9/OGZ4oRjizRD+TRVSJxcppXgRv3ag=;
	h=From:Subject:Date:References:Cc:In-Reply-To:To:From;
	b=JmJGuWUp5yLfz5o2+s+JvcH57zosOu5EHH9HlVz9A8wS2NEqE7sTV1GCwnuP1EQ6t
	 6rl6OU7snYnMOjBLIgFt+9mYBY46y4pIaEz9M8vaK7eIiE0Hqfp3NPs9fTuhbhLj4U
	 HwXJzsp2eGB0h/lmwECvCUmKcLLkFiGB++xdsl9sREE8j+Xtzh0SPOuTklHma8r/aq
	 n7qdw3DhSIowQHs69igtnTPpuROs2UibRYF0HWbVWURD9hdnT4RcbAHOQpmjHNsX52
	 nrkY2DWob/FbqpKPRc7R8+shzr2CxXdXd+A5h+bYwdSAXL8mKeyQkwgEKUiuCcAUU2
	 2SuE6X/8qXpKQ==
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From: Xin Li <xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH v8 05/21] x86/cea: Export API for per-CPU exception stacks for KVM
Date: Thu, 23 Oct 2025 01:55:51 -0700
Message-Id: <C28589B9-F758-4851-A6FD-41001C99137D@zytor.com>
References: <20251023080627.GV3245006@noisy.programming.kicks-ass.net>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, pbonzini@redhat.com, seanjc@google.com,
        corbet@lwn.net, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        luto@kernel.org, andrew.cooper3@citrix.com, chao.gao@intel.com,
        hch@infradead.org
In-Reply-To: <20251023080627.GV3245006@noisy.programming.kicks-ass.net>
To: Zijlstra Peter <peterz@infradead.org>
X-Mailer: iPhone Mail (23A355)


>> FRED introduced new fields in the host-state area of the VMCS for stack
>> levels 1->3 (HOST_IA32_FRED_RSP[123]), each respectively corresponding to=

>> per-CPU exception stacks for #DB, NMI and #DF.  KVM must populate these
>> fields each time a vCPU is loaded onto a CPU.
>=20
>> +noinstr unsigned long __this_cpu_ist_top_va(enum exception_stack_orderin=
g stack)
>> +{
>> +    return __this_cpu_ist_bottom_va(stack) + EXCEPTION_STKSZ;
>> +}
>> +EXPORT_SYMBOL(__this_cpu_ist_top_va);
>=20
> This has no business being a !GPL export. But please use:
>=20
> EXPORT_SYMBOL_FOR_MODULES(__this_cpu_ist_top_val, "kvm");
>=20
> (or "kvm-intel", depending on which actual module ends up needing this
> symbol).

Will do =E2=80=9Ckvm-intel=E2=80=9D because that is the only module uses the=
 APIs.=


