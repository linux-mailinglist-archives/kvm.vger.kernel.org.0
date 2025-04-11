Return-Path: <kvm+bounces-43148-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D6D6A8583C
	for <lists+kvm@lfdr.de>; Fri, 11 Apr 2025 11:42:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 15F2A4C7883
	for <lists+kvm@lfdr.de>; Fri, 11 Apr 2025 09:42:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3B74298CB0;
	Fri, 11 Apr 2025 09:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="DjnMMkqb"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B6A728FFD4;
	Fri, 11 Apr 2025 09:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744364553; cv=none; b=lX1l5cbY63kOar5yK+i196W2j/70hvQVlMcncASvmaIsiJ/BpUTuY80nGBfbPVIq/0Px14OLnor1I/2Olo81r7ul9A+Zk851bKTS6wEpGeTGK0FcNwKs+jW5r8vVqAfslYUKft5rIr4waASOIXmvEb6GDX6dPCp3CnA1l287q/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744364553; c=relaxed/simple;
	bh=/eMeBUA0jnpKudVbp+LXHAi21nRNibkCr3eOn8NKcBI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Zci+fIndPCPn7C0jGpbASL5OSAqxnGxQ4ajP7Dyy5ddsT2J/OcszKKHYqQutwpMY0olgIGsrnYWDVk0actX5M0MRffYme5Vy7dqfGv6Cug16OYXDfbBlG6AWhP4FpjL3XRiD25snBeQXTeS2jDf1PjFrHKSAu83kq3+BfWO2zFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=DjnMMkqb; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 740FB40E0246;
	Fri, 11 Apr 2025 09:42:28 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id E9S9x1SFQ1cU; Fri, 11 Apr 2025 09:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1744364544; bh=zGMgXhVwXSY8+N0XO1YrCWv+vj9bHAlN4HLUlAW+/0k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DjnMMkqbNmM8HOezCPtL2sJtKYbvgKuRTUllr+lQi9IbYJhhMOXAJR/msaPXyBL68
	 +IjDJVWG/YnPJ43CHTC65VZ57FuP0qE2FfsUwH2+NyzTtF+xMIYy3V2xs6vfMdvOnS
	 XRbJEZ2Vi4PArZgZFemE5QBdZTkcKHE5TRQeZPpWXp2BegTIu8NdFaNWpy3HEwuUrk
	 3mVfCQJzUMsVG9XtQ1xFkzd03een9UhqlWrpv9ctZ42wAOUQMvJZ5a+BmU82K2+Lq/
	 VDTdol8YQ8DSg4aSbFg/JFdHBAxr8zPYYEEnGIzLLi8+GiRzMP1hHuL48v4BWscwks
	 b5aMmxhacCWRIQ9V8o+a/ux7582cYt0zvVDzp5P1bCQnKQDeBue0nPdkNbjoDYNG1c
	 MqAG4mRnjhSv7AqwG3NkTsTOhAPJAYrtjfzpEytyyol52RuOZMTzvQOl0AZ7D+C13k
	 BEgOtJLc2DF+StuAczGzKOHsml9HBSj3k5MuauYXeT5hO3U38yuWvx+fUY6Gwx3q1c
	 hEgUpUfWdTrXjqKlIJIErtZ0dQIltTAUUoL7OV7XmpVDWGPskklU5JP84kBFfCQ3GR
	 XZmdEXlcP+8XtH6N5ayrUJ/1iFX/JNUbUxsqYXMIk6RUXLwYvZu5OKBlE6a0Z5oZ6Q
	 xcKwtUBd8UXINrfMQIos8MRk=
Received: from zn.tnic (p579690ee.dip0.t-ipconnect.de [87.150.144.238])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 9907D40E0243;
	Fri, 11 Apr 2025 09:42:12 +0000 (UTC)
Date: Fri, 11 Apr 2025 11:42:10 +0200
From: Borislav Petkov <bp@alien8.de>
To: Maksim Davydov <davydov-max@yandex-team.ru>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
	babu.moger@amd.com, seanjc@google.com, mingo@redhat.com,
	tglx@linutronix.de, dave.hansen@linux.intel.com, hpa@zytor.com,
	jmattson@google.com, pbonzini@redhat.com
Subject: Re: [PATCH v3 1/2] x86: KVM: Advertise FSRS and FSRC on AMD to
 userspace
Message-ID: <20250411094210.GJZ_jj8sSbUydxrv2o@fat_crate.local>
References: <20241204134345.189041-1-davydov-max@yandex-team.ru>
 <20241204134345.189041-2-davydov-max@yandex-team.ru>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241204134345.189041-2-davydov-max@yandex-team.ru>

On Wed, Dec 04, 2024 at 04:43:44PM +0300, Maksim Davydov wrote:
> Fast short REP STOSB and fast short CMPSB support on AMD processors are
> provided in other CPUID function in comparison with Intel processors:
> * FSRS: 10 bit in 0x80000021_EAX
> * FSRC: 11 bit in 0x80000021_EAX
> 
> AMD bit numbers differ from existing definition of FSRC and
> FSRS. So, the new appropriate values have to be added with new names.
> 
> It's safe to advertise these features to userspace because they are a part
> of CPU model definition and they can't be disabled (as existing Intel
> features).
> 
> Fixes: 2a4209d6a9cb ("KVM: x86: Advertise fast REP string features inherent to the CPU")

Why is there a Fixes tag here?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

