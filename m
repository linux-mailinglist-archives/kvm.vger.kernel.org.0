Return-Path: <kvm+bounces-65278-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D2D2FCA3C74
	for <lists+kvm@lfdr.de>; Thu, 04 Dec 2025 14:22:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id D445E3042512
	for <lists+kvm@lfdr.de>; Thu,  4 Dec 2025 13:21:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4784344020;
	Thu,  4 Dec 2025 13:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mandrillapp.com header.i=@mandrillapp.com header.b="Ee1T/aH+";
	dkim=pass (2048-bit key) header.d=vates.tech header.i=thomas.courrege@vates.tech header.b="kvdKcFKJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail132-20.atl131.mandrillapp.com (mail132-20.atl131.mandrillapp.com [198.2.132.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FD932D3EEE
	for <kvm@vger.kernel.org>; Thu,  4 Dec 2025 13:21:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.2.132.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764854514; cv=none; b=EHknENb+1SVGiRcjd7Yt/2IP6g1XgOluC7f+rrH/qQ+fmmxORI0cx+ta9W2zr1KqvIJYvb5wCUxNXuizdgpPnkHobukKblLFCiwEjiTDnt6xLYBq9IaB7X7LJCY6mVLWz8tD9uzqM5mZcPQ08Y9wZx6yHIWVTqadTlcggaDw6rE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764854514; c=relaxed/simple;
	bh=l1zpHWlZIk8v4kklrfJoj2bNMah8TNBHN/gHU2C/bR4=;
	h=From:Subject:Message-Id:To:Cc:References:In-Reply-To:Date:
	 MIME-Version:Content-Type; b=NFzHHNDKIfcD7LKIkEtDGQdl7RiuBphbTFonz3koxwouhLUBxpwf/wrVCh9uCf8DYgwnK82rWoFPPEI27u3FXULEbIsezACFxyrB2GBFkYUQ3AKvghtkl9AJ6vrPlvrHVatTFyEEJm8A8kJoQVDecFDqvyOh9F4K723/5DiiFT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vates.tech; spf=pass smtp.mailfrom=bounce.vates.tech; dkim=pass (2048-bit key) header.d=mandrillapp.com header.i=@mandrillapp.com header.b=Ee1T/aH+; dkim=pass (2048-bit key) header.d=vates.tech header.i=thomas.courrege@vates.tech header.b=kvdKcFKJ; arc=none smtp.client-ip=198.2.132.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vates.tech
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bounce.vates.tech
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mandrillapp.com;
	s=mte1; t=1764854511; x=1765124511;
	bh=zPGLgI2YEBNoVTVWQEvF7b9V1uJmU+fj5TGVDfV1Cis=;
	h=From:Subject:Message-Id:To:Cc:References:In-Reply-To:Feedback-ID:
	 Date:MIME-Version:Content-Type:Content-Transfer-Encoding:CC:Date:
	 Subject:From;
	b=Ee1T/aH+wxVhvlfM1Tnghs5LZNF9vZlrqaKBA26BLlKybPcjeruy3xY7egUjMURRd
	 eMW0KgSA80RNzNPpoz0c5vRjbYC6Dw9yKwvdNMXqh6FQ4CDCMixL0k4+1M+M8F+3Q0
	 PCJc8ROOktJkk5xHapP6NhWuRIoiaO7evCg0u/plBc25p9xbqEJMa4fKJg9bXNEZUp
	 m3EwNodxsq5ksz44eBQziNWC8197ahx0LfPx+956tFhTPyjTGFqVHGvPki/h1aX52y
	 h2BQYc8FzbJyIIR7i51nUkaanA5dbCtrxh+aO2VE4b8xnlcwdU5Fm3/uQGtAtOcf7D
	 UmSl9faR9JQxQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vates.tech; s=mte1;
	t=1764854511; x=1765115011; i=thomas.courrege@vates.tech;
	bh=zPGLgI2YEBNoVTVWQEvF7b9V1uJmU+fj5TGVDfV1Cis=;
	h=From:Subject:Message-Id:To:Cc:References:In-Reply-To:Feedback-ID:
	 Date:MIME-Version:Content-Type:Content-Transfer-Encoding:CC:Date:
	 Subject:From;
	b=kvdKcFKJMZceSrb09fP1Lo75HQiv6q5fVwgHEuVizWVhRLLBsL2OV8Wr3xFQAHO2d
	 qe7VGc/MYPXnM3Axsu9SubT0zm2lRXjXpWgaUHDyw+PwWQxsBexVdGSy/QNqMfePbs
	 ZSLABdllY9hoGqJQWkrEGaZ7K2cxTp7lC1zmRt9fXknqTPKVI48bGUyJj7IbZZHdCz
	 UZ25Y+viVuX9pgxytJ8leOjQKnkPTxhBnNSIMiu5bzdAFZBV9JTdG3U1afdWsr+m6I
	 4hizZJZ8lAkVb6F4N3f8lqJIdSXoMevDbhkBWLKjMokYZr9V2EnKEIoM0sjjzBUTIF
	 6ecee583A/ETA==
Received: from pmta09.mandrill.prod.atl01.rsglab.com (localhost [127.0.0.1])
	by mail132-20.atl131.mandrillapp.com (Mailchimp) with ESMTP id 4dMZsq2qhGzFCWlKv
	for <kvm@vger.kernel.org>; Thu,  4 Dec 2025 13:21:51 +0000 (GMT)
From: "Thomas Courrege" <thomas.courrege@vates.tech>
Subject: =?utf-8?Q?Re:=20[PATCH=20v2]=20KVM:=20SEV:=20Add=20KVM=5FSEV=5FSNP=5FHV=5FREPORT=5FREQ=20command?=
Received: from [37.26.189.201] by mandrillapp.com id 05fd0cceacfe4ab990a23d6214c91a76; Thu, 04 Dec 2025 13:21:51 +0000
X-Bm-Milter-Handled: 4ffbd6c1-ee69-4e1b-aabd-f977039bd3e2
X-Bm-Transport-Timestamp: 1764854509149
Message-Id: <85baa45b-0fb9-43fb-9f87-9b0036e08f56@vates.tech>
To: "Tom Lendacky" <thomas.lendacky@amd.com>, pbonzini@redhat.com, seanjc@google.com, corbet@lwn.net, ashish.kalra@amd.com, john.allen@amd.com, herbert@gondor.apana.org.au, nikunj@amd.com
Cc: x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
References: <20251201151940.172521-1-thomas.courrege@vates.tech> <30242a68-25f5-4e92-b776-f3eb6f137c31@amd.com>
In-Reply-To: <30242a68-25f5-4e92-b776-f3eb6f137c31@amd.com>
X-Native-Encoded: 1
X-Report-Abuse: =?UTF-8?Q?Please=20forward=20a=20copy=20of=20this=20message,=20including=20all=20headers,=20to=20abuse@mandrill.com.=20You=20can=20also=20report=20abuse=20here:=20https://mandrillapp.com/contact/abuse=3Fid=3D30504962.05fd0cceacfe4ab990a23d6214c91a76?=
X-Mandrill-User: md_30504962
Feedback-ID: 30504962:30504962.20251204:md
Date: Thu, 04 Dec 2025 13:21:51 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

On 12/2/25 8:29 PM, Tom Lendacky wrote:

>> +
>> +e_free_rsp:
>> +	/* contains sensitive data */
>> +	memzero_explicit(report_rsp, PAGE_SIZE);
> Does it? What is sensitive that needs to be cleared?

Combine with others reports, it could allow to do an inventory of the guests,
which ones share the same author, measurement, policy...
It is not needed, but generating a report is not a common operation so
performance is not an issue here. What do you think is the best to do ?

Regards,
Thomas

