Return-Path: <kvm+bounces-53555-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 56B08B13EB5
	for <lists+kvm@lfdr.de>; Mon, 28 Jul 2025 17:37:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 576A31894421
	for <lists+kvm@lfdr.de>; Mon, 28 Jul 2025 15:37:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC84F274678;
	Mon, 28 Jul 2025 15:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NkpEyrt7"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAA66274676;
	Mon, 28 Jul 2025 15:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753716887; cv=none; b=s+4+ENU0R022YxUN0YkqPqY6L1dnzEQAan8oyGogm6zgbuxQ30kiCFtkpgF7OUFNoOL2RX9Q5jQiqWppUzXVRhuy4+79ZA7bvcLQaSnCkOtewfti/e6TjN0tZEUfk1rgb7Ui8+7/NDgcb0cdLw6DvRvwAU89JjS6necnwxPh5vE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753716887; c=relaxed/simple;
	bh=2xPBmRHeSoQvOWnAnsiNXsyXNpYv0Ly4lmJEuLMt6S4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZKodBf5qahwR3nVUSMsmoucDe1R00Nyz3K1GlR+tsWw4oPOwNCaEuu7OzN8/itVgfRliM8pfnS5EzzrCZmBPtChR8hxfvuBhHCxkPm6TyXYxV6u08ivtLugHI+7X9aTMFIlrphaa1bIxSf8kxrTrUHxRUFOzhbZzbSqj614+UiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NkpEyrt7; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABDBDC4CEE7;
	Mon, 28 Jul 2025 15:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753716886;
	bh=2xPBmRHeSoQvOWnAnsiNXsyXNpYv0Ly4lmJEuLMt6S4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NkpEyrt7JFeapc4gmZKoQ7bGbUNXx+sgazOY1wldwNPeXhWK+HNszrZsMzvO8v0hb
	 gPPw3+8zI9us+gnpCgaz9fe9GHp8Ra1NYPtPGXwVaVYm2u2KCDq150IZpdbq3nPbRS
	 TWFNrUgtNPIeCvUtjq7ufKNzTpRHL7OFbbRWPQ/Y=
Date: Mon, 28 Jul 2025 17:34:43 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Marc-Etienne Vargenau (Nokia)" <marc-etienne.vargenau@nokia.com>
Cc: Thomas Huth <thuth@redhat.com>, Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"x86@kernel.org" <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-spdx@vger.kernel.org" <linux-spdx@vger.kernel.org>
Subject: Re: [PATCH] arch/x86/kvm/ioapic: Remove license boilerplate with bad
 FSF address
Message-ID: <2025072806-swept-retype-4f7c@gregkh>
References: <20250728141540.296816-1-thuth@redhat.com>
 <PR3PR07MB81837F4778329A2270CC9318AC5AA@PR3PR07MB8183.eurprd07.prod.outlook.com>
 <2025072843-browbeat-rocket-c549@gregkh>
 <PR3PR07MB81835DAC6ACE7162E81A3AC4AC5AA@PR3PR07MB8183.eurprd07.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <PR3PR07MB81835DAC6ACE7162E81A3AC4AC5AA@PR3PR07MB8183.eurprd07.prod.outlook.com>

Please don't top-post on kernel mailing lists.

On Mon, Jul 28, 2025 at 03:19:51PM +0000, Marc-Etienne Vargenau (Nokia) wrote:
> Hi Greg,
> 
> I agree this is not major, but it means that for example Yocto creates invalid SPDX SBOMs that must be fixed before it can be used.

Then Yocto already has that regex setup as the kernel has many such
instances of this.

> It’s better to use the correct syntax in the kernel.

Again, either is fine for now, as per our documentation, don't add
additional requirements for contributors that are not there at all.

thanks,

greg k-h

