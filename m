Return-Path: <kvm+bounces-38389-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 11FC1A38D53
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2025 21:32:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 00CF0189028A
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2025 20:32:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3477D238D42;
	Mon, 17 Feb 2025 20:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="oXFl8d9z"
X-Original-To: kvm@vger.kernel.org
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B6A67404E
	for <kvm@vger.kernel.org>; Mon, 17 Feb 2025 20:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739824353; cv=none; b=EPtby8S73QkjPxSMVq8KEuukxwGmvgVQJ3icJvYuWa3BinzFVgOZrlMHX4tweLUvKwjMq2QqRx5HDA5OaypSerPnvGEw09ytka3YArNH2Xw8DwAxWQBaNTdOJVHAAocVkwfk8HHl0Udk3GahOFV4a7hUyjfgTCg3UjdGiq3xawA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739824353; c=relaxed/simple;
	bh=2htEmpCLitWuFojd6Br41Qj7YGgsq7kvZml7PH9wjKY=;
	h=MIME-Version:Date:Content-Type:From:Message-ID:Subject:To:Cc:
	 In-Reply-To:References; b=IIc+b2ZFAPYv+aPIeFh35+CSZmOpJaJWNy87VQ4qACBkA4kK2RqX6/V2tIC0qgtZS6l/4q9mFFmSFrvC2ifUR8PPhCBxGhg1UzRDtPlKsKPrznBR7DvQx8wA0AJ6DXF/ZE4L5o9ZIMrFIvBipWcHeOYh5shr9aXmfQdMx05txFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=oXFl8d9z; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1739824348;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JYtoD69KFLVbOsuGYYgyc74+hUVe2DJa6zqPj49fVaI=;
	b=oXFl8d9z5cAqbfIkMZhRuQ0L7zOM37IT2RF14JQ1piNIUcx4SYRlWeYVCrswoVlEvNszGg
	qfpQv+eEfKRfH63qeO6qzfgJ34LMCQAs+6Maqd3A/+F0MlM8uQ6qy9E4CY8a+WQ6EPWuXB
	43K1di0mG4TzLQy7/S3gsthicC1PpuU=
Date: Mon, 17 Feb 2025 20:32:26 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Yosry Ahmed" <yosry.ahmed@linux.dev>
Message-ID: <f16941c6a33969a373a0a92733631dc578585c93@linux.dev>
TLS-Required: No
Subject: Re: [PATCH] x86/bugs: KVM: Add support for SRSO_MSR_FIX
To: "Borislav Petkov" <bp@alien8.de>
Cc: "Sean Christopherson" <seanjc@google.com>, "Patrick Bellasi"
 <derkling@google.com>, "Paolo Bonzini" <pbonzini@redhat.com>, "Josh
 Poimboeuf" <jpoimboe@redhat.com>, "Pawan Gupta"
 <pawan.kumar.gupta@linux.intel.com>, x86@kernel.org, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, "Patrick Bellasi" <derkling@matbug.net>,
 "Brendan Jackman" <jackmanb@google.com>
In-Reply-To: <20250217202048.GIZ7OaIOWLH9Y05U-D@fat_crate.local>
References: <20250213142815.GBZ64Bf3zPIay9nGza@fat_crate.local>
 <20250213175057.3108031-1-derkling@google.com>
 <20250214201005.GBZ6-jHUff99tmkyBK@fat_crate.local>
 <20250215125307.GBZ7COM-AkyaF8bNiC@fat_crate.local>
 <Z7LQX3j5Gfi8aps8@Asmaa.>
 <20250217160728.GFZ7NewJHpMaWdiX2M@fat_crate.local>
 <Z7OUZhyPHNtZvwGJ@Asmaa.>
 <20250217202048.GIZ7OaIOWLH9Y05U-D@fat_crate.local>
X-Migadu-Flow: FLOW_OUT

February 17, 2025 at 12:20 PM, "Borislav Petkov" <bp@alien8.de> wrote:
>=20
>=20On Mon, Feb 17, 2025 at 11:56:22AM -0800, Yosry Ahmed wrote:
>=20
>=20>=20
>=20> I meant IBPB + MSR clear before going to userspace, or IBPB + MSR c=
lear
> >  before a context switch.
> >=20
>=20
> Basically what I said already:
>=20
>=20"Yes, let's keep it simple and do anything more involved *only* if it=
 is
> really necessary."

Right, I agree as I mentioned earlier (assuming the perf hit is 1-2%), ju=
st wanted to clarify what I meant.

