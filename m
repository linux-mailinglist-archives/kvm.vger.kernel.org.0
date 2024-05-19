Return-Path: <kvm+bounces-17739-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 034B88C9385
	for <lists+kvm@lfdr.de>; Sun, 19 May 2024 07:50:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3C6E0B20E73
	for <lists+kvm@lfdr.de>; Sun, 19 May 2024 05:50:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75E1012E5D;
	Sun, 19 May 2024 05:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="MBvHwGn5"
X-Original-To: kvm@vger.kernel.org
Received: from mout.web.de (mout.web.de [212.227.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF6661C2E;
	Sun, 19 May 2024 05:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716097831; cv=none; b=rD8J8CwMF74rALt+iYZot6oGO9WMHXchrpQKWS+T8s1/4csYn9XJ7kU05T8ERUr/gKnHsYVEZJkzwNzGXVQTfTEijOv8Lctz6rqhwnlOzxmP7wf+FU46poPQs0hdyybJg6mHaFEIoPTFK7h0ig0TCzAn7RVsT26IKFadMRAHK+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716097831; c=relaxed/simple;
	bh=0yvbC3YWgtKvkehK3zxwUez8A5+kamVe/0eOYjtGMTE=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
	 In-Reply-To:Content-Type; b=H+fKHUZwfEPWLwtdzmefkcJYnXgXCpFc0a7Ir/jd7gelWANkG/IZcRmVCIhKxgf1m4hCmj0Ge2GMgLZEIAfTpJXStwVp4Sfqc9KdGSOMAvtaSD1vLYwYKuuyuJiIymWFYK285xbX6jAxKUAdqvTTEUPhE8FfOjeU4L1zmzaK6tw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=MBvHwGn5; arc=none smtp.client-ip=212.227.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1716097818; x=1716702618; i=markus.elfring@web.de;
	bh=0yvbC3YWgtKvkehK3zxwUez8A5+kamVe/0eOYjtGMTE=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=MBvHwGn5D8wKrTfcIuMVWEPKNyz5OGw8+xk6J8t5zAX0lxUX4IhLAQ3OR4OIzOsh
	 gww8LHPLafO2HtjL62UG+vuNpd+a12PVSsjgYgou2453FMBw/TpW1usdkFuE31zMy
	 +aih5j7EPMSxuM459acLa8LauxwitxrleQlu+jKnOjJkDXYlFCqFqwQg3pAyay5vM
	 AXv+faCJJKk3CEho8601znrbi3e0DOLcBOliwyauzhH60cf2N600/LuJI3STqC6n4
	 Qpv5tEiM1Lg2HI+GxVn5r39CkWthmbQcONv5wTXiFvpcEFod0jnXpLsYacegdCUTy
	 3Gk8z7QQJujvjFk4NA==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.21] ([94.31.82.95]) by smtp.web.de (mrweb105
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1MGxQX-1sM3hZ1kpf-001zNa; Sun, 19
 May 2024 07:50:18 +0200
Message-ID: <76413d53-4572-4a38-baff-8b01f6179c8e@web.de>
Date: Sun, 19 May 2024 07:50:14 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org,
 kernel-janitors@vger.kernel.org, linux-coco@lists.linux.dev
Cc: LKML <linux-kernel@vger.kernel.org>,
 Carlos Bilbao <carlos.bilbao.osdev@gmail.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
References: <20240513181928.720979-1-michael.roth@amd.com>
Subject: Re: [PATCH] KVM: SEV: Fix unused variable in guest request handling
Content-Language: en-GB
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <20240513181928.720979-1-michael.roth@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:86xkhBNlc093D6q3cjQlgFMXciyeSHTew5huDwPDpF/M1QEcniy
 OoNcSNgh8nUXAwTF+r4oqO6RME/I3KJ1ET7oiMUWh2Hycqsd4C9LIym7n9Y8U54aUv6evK/
 LLFEm+nRuJqGGeCorG4SCSKPKBQ1+XmTaK/cOpSloGbCIQYC1UpQWSQBThymHXd5Rt95vkI
 GbZ9C5mA7mzozKI+V5Z+g==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:lcVEq/oY1Bg=;kyVlebdxuhJMfY0uiZgFoH+b0rv
 QCfP9AOimSDxeM/p8p95KyMqLiTHTDa9tkZFsExgYnrxg65G5hNaBKI5ulbaNmawy5qHAQbOv
 78IuREnkD0tDqo7etBb8zhSC2lty5SpkRflP8iiPe3gwVPwvO+2QZy+R7TSZjSitDrh2t/OZY
 dWrItoYRshEIq7OenouiAMDCWMVcmCdx97p4FI7MQ/Ev4cAYqgqseAX/uimQe77TJ9lKkGYEW
 dG1EMAva0LjNPZQ1g4Zf3stRdQ6/Ap0DS0+VROBupSIJSTsX/NVuSW+1l3mXuYt+K8jhXiGiN
 wqhF9xDEyfxDwmqayab5GqchHSYeYES4hWxmfWr3Mf4eiubuMEfo59DWs8T161zjBEuDyfEeG
 lyt1OMLA7jt3tLGV5OAw6fZ9JzE3T7NvX7MG/LtY0ek7yX6stDbfhGHioKPO5ZPkMqZZDli4i
 N111LrJu5WJfvmczOvDVCZLAtqXe4jJ3/ae4Q33f6GeRDFFyHGVIlAdDCH2dk2ZDQBKWRRRin
 BPxJV2qcAVhtryGoc4jBgEAD3+oYI846ol8J9NjgFwX85a/yE1epAponyWvMT4//rDDkWyBe/
 Gln1KmBxG9VdKGrha2wESWE5s4Ae0kaB5sZNaEILB96yiMIOdR5cRaULndKww/sJbhn8H6/5P
 yUQlNCROzbYrPPTZ2p85wdq0d1O5MiPjV4Zf+rH0kSMRO/wI/3kEgWUr4DE7tcRJO3Mjprkr9
 xRTzyJDdqKQKapMazVyvPVgKPvqXiL7GG5QOSt80uvJXQaumDmOjkzHoaYXZr8UzUxTnUd+6C
 lekuPcNLkXK00WxnCmdM04R7zrc0siPY2OJuXisq5U5C0=

> The variable 'sev' is assigned, but never used. Remove it.

Would it be a bit nicer to use the word =E2=80=9COmit=E2=80=9D instead of =
=E2=80=9CFix=E2=80=9D
in the summary phrase?

Regards,
Markus

