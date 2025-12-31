Return-Path: <kvm+bounces-66908-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B71B4CEC30C
	for <lists+kvm@lfdr.de>; Wed, 31 Dec 2025 16:45:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A57243043794
	for <lists+kvm@lfdr.de>; Wed, 31 Dec 2025 15:43:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66740292B2E;
	Wed, 31 Dec 2025 15:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="ZmNR7hwz"
X-Original-To: kvm@vger.kernel.org
Received: from terminus.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E23C41DFD8B;
	Wed, 31 Dec 2025 15:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767195818; cv=none; b=c4LD14+f+ie9lqc0exGR6z0wBiKS7XA3LUcWnDlWPhcBOrNIjc3O/ny9tRT25q02SiWiTCmukZXvWSK/J45utnPU9cySVhwvv3pb6YMYvRM2Muasx0Us8rwlHvi64mQbUamkyRik/sKk20zDGg3eyfL5yTly9rZCccIUVGjeJ4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767195818; c=relaxed/simple;
	bh=Bd3Vac3whQ6zL7QRJ99H8nJmDJaJ8LFvyi6Hn5vhvmk=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=kD0NGHiBd8RUG3QsSRoRtPBftjl4mDFhLw2xnkw2IipkFxr55GlYafopllZlKYNUEO0GKFfBEQ6qxofV/9pxVu2zDXe++lvrJy7UAUHSPiXFl3xXNXtadgxsiQCYP/LdHWpzk5lXanxah0I/AmB/T4Ao/MPKtNaDt4mfgNcnjfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=ZmNR7hwz; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from smtpclient.apple (c-24-130-165-117.hsd1.ca.comcast.net [24.130.165.117])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 5BVFcS4X3547598
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Wed, 31 Dec 2025 07:38:29 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 5BVFcS4X3547598
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025122301; t=1767195509;
	bh=btFoKdmhQuWliDpI09xQO1DTWFXIUJTI/TJ8ccNcofE=;
	h=Subject:From:In-Reply-To:Date:Cc:References:To:From;
	b=ZmNR7hwzcvJlEg3ad4KTtRAM03DrrnjHzouQiQ/yWrdk+YOeWnRLfBd0FxEbKg9bL
	 xmMcgkv+s1HMSpPB0osWrTegn7VR4V11GHmzLaHwy0W+/8e6sipOl9pmjoADk9SYdg
	 zCP9gmNrohgG/pKKvXC7zaMTG0sPZscYpz2/LNhVaP6A6BcUCyO1wwuyjUh1xQnfJc
	 wJjVBhmYfO8ZJUINo3opVGGCjO9jusG9MPSODJ+1nfFijqkV0G8V146Ch7m0yQbwxr
	 AbEcm8Ebt+4HqeSKsI1yLPNMsDGOYSoUjtbPgvkpr0KUkSk+Y/4ySx2k7YHuMLvHov
	 6IMogU+Re8c8g==
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.300.41.1.7\))
Subject: Re: [PATCH v2 1/2] KVM: nVMX: Disallow access to vmcs12 fields that
 aren't supported by "hardware"
From: Xin Li <xin@zytor.com>
In-Reply-To: <20251230220220.4122282-2-seanjc@google.com>
Date: Wed, 31 Dec 2025 07:38:18 -0800
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chao Gao <chao.gao@intel.com>,
        Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Transfer-Encoding: quoted-printable
Message-Id: <1D1B6FEC-1D50-4A0D-92D1-33B522576670@zytor.com>
References: <20251230220220.4122282-1-seanjc@google.com>
 <20251230220220.4122282-2-seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>
X-Mailer: Apple Mail (2.3864.300.41.1.7)


> On Dec 30, 2025, at 2:02=E2=80=AFPM, Sean Christopherson =
<seanjc@google.com> wrote:
>=20
> Disallow access (VMREAD/VMWRITE) to fields that the loaded incarnation =
of
> KVM doesn't support, e.g. due to lack of hardware support, as a middle
> ground between allowing access to any vmcs12 field defined by KVM =
(current
> behavior) and gating access based on the userspace-defined vCPU model =
(the
> most correct, but costly, implementation).
>=20
> Disallowing access to unsupported fields helps a tiny bit in terms of
> closing the virtualization hole (see below), but the main motivation =
is to
> avoid having to weed out unsupported fields when synchronizing between
> vmcs12 and a shadow VMCS.  Because shadow VMCS accesses are done via
> VMREAD and VMWRITE, KVM _must_ filter out unsupported fields (or eat
> VMREAD/VMWRITE failures), and filtering out just shadow VMCS fields is
> about the same amount of effort, and arguably much more confusing.
>=20
> As a bonus, this also fixes a KVM-Unit-Test failure bug when running =
on
> _hardware_ without support for TSC Scaling, which fails with the same
> signature as the bug fixed by commit ba1f82456ba8 ("KVM: nVMX: =
Dynamically
> compute max VMCS index for vmcs12"):
>=20
>  FAIL: VMX_VMCS_ENUM.MAX_INDEX expected: 19, actual: 17
>=20
> Dynamically computing the max VMCS index only resolved the issue where =
KVM
> was hardcoding max index, but for CPUs with TSC Scaling, that was =
"good
> enough".
>=20
> Cc: Xin Li <xin@zytor.com>
> Cc: Chao Gao <chao.gao@intel.com>
> Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
> Link: =
https://lore.kernel.org/all/20251026201911.505204-22-xin@zytor.com
> Link: https://lore.kernel.org/all/YR2Tf9WPNEzrE7Xg@google.com
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Xin Li <xin@zytor.com <mailto:xin@zytor.com>>


