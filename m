Return-Path: <kvm+bounces-64988-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id E540AC95C96
	for <lists+kvm@lfdr.de>; Mon, 01 Dec 2025 07:21:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id E7448343219
	for <lists+kvm@lfdr.de>; Mon,  1 Dec 2025 06:21:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB920277023;
	Mon,  1 Dec 2025 06:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="UNa0D6Lo"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D671271A9D;
	Mon,  1 Dec 2025 06:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764570087; cv=none; b=KuN4LPe0PQHj6Rubj/jkLZKRj9ilhBtecQa6xLSlLrMceAngjAS1a9+N4Avyo3BiESDUQ7sO7Xs7jjRVymEsQCVmiOnhXv9EFQB5EEw2TarrIc7JlRx5phXq2Eca+8FWjh/9ckZKddze3lsCvjn6igduQkyl4foDzjGqpPah9es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764570087; c=relaxed/simple;
	bh=439a4L7hN/pT2x2+bLgPfrdREWIGD/W1cQ4ZpSMsBtI=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=lw7UC/S5FpmLL0/PT+ldRtszhGJXh4zFtouH8b+9BBMWvi6j24mjSI8F/KXiXGKDExI/4M/2E8HjTIBBQiluH+QSpTLXdhnpmmOnF7JqCNXYvlVLj/xiai5Gxvrr361kWPz35kLHrfZGUW9iUeBA3nDehqaR3C56jUlyNFjSfXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=UNa0D6Lo; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from smtpclient.apple ([71.202.166.45])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 5B16KcDs834657
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Sun, 30 Nov 2025 22:20:39 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 5B16KcDs834657
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025112201; t=1764570040;
	bh=439a4L7hN/pT2x2+bLgPfrdREWIGD/W1cQ4ZpSMsBtI=;
	h=Subject:From:In-Reply-To:Date:Cc:References:To:From;
	b=UNa0D6LozZDY4E0vM4xXldUKwibNnV0aFvfbdWGa0HI5CJlIxnuPD13XPckxn9X3L
	 fJv/clRr/dMCmc7Ap4aMhbXboHVp7uqhkQ9gHmezLahMEEnkUcZW9cVbQYjpA4KBEv
	 u3leH42CORVT1KKKph/BzrlE95dAzL2DSPnvowsPGurk/yHYaIC8BnnGDVdoY4LhxR
	 nLEUYhYa5vE1NiuIaknksJTa8ZHLofKT9msNN7YZoOVZ5eeVjCwOgo95rvIoPz7IK9
	 i6Gmf5/Tw5k5AVD44B91+tdcodJDl72s1hZfJ0L4xrOx8nhdCCU+YI0Ma+yPPELbMr
	 sFSg2tbPTAW4g==
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.200.81.1.6\))
Subject: Re: [PATCH v9 10/22] KVM: VMX: Add support for saving and restoring
 FRED MSRs
From: Xin Li <xin@zytor.com>
In-Reply-To: <aRQmRZYQr579kT4N@intel.com>
Date: Sun, 30 Nov 2025 22:20:28 -0800
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, pbonzini@redhat.com, seanjc@google.com,
        corbet@lwn.net, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        luto@kernel.org, peterz@infradead.org, andrew.cooper3@citrix.com,
        hch@infradead.org, sohil.mehta@intel.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <1D26E0E9-5826-4443-AB99-8620AC901BE2@zytor.com>
References: <20251026201911.505204-1-xin@zytor.com>
 <20251026201911.505204-11-xin@zytor.com> <aRQmRZYQr579kT4N@intel.com>
To: Chao Gao <chao.gao@intel.com>
X-Mailer: Apple Mail (2.3864.200.81.1.6)

>=20
>> @@ -4316,6 +4374,12 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, =
struct msr_data *msr_info)
>> #endif
>> case MSR_IA32_U_CET:
>> case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
>> + if (!guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK)) {
>> + WARN_ON_ONCE(msr !=3D MSR_IA32_FRED_SSP0);
>=20
> This will be triggered if the guest only supports IBT and tries to =
write U_CET here.

You=E2=80=99re right, my stupid.=

