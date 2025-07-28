Return-Path: <kvm+bounces-53556-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 35074B13EED
	for <lists+kvm@lfdr.de>; Mon, 28 Jul 2025 17:41:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 28A671791A2
	for <lists+kvm@lfdr.de>; Mon, 28 Jul 2025 15:39:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2500527146D;
	Mon, 28 Jul 2025 15:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cOsD8Mwo"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39D5718A6AB;
	Mon, 28 Jul 2025 15:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753717011; cv=none; b=Fa+OSU/NYmUkb6TU2/ui03v9npKck2sUmRtYVshAahDeWJdMVHwqUDeh0stt68atWMYDCKqwXyQ2UDQCsh16OSk3ukaHCA8wSLfuUjRT2V9Nxv2PnXA+DFNkgo6L7rREQha+NW6jTSwQcPGfUIVFxwnYcafIfQeT7npZ07HHPaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753717011; c=relaxed/simple;
	bh=T9Rk8C7dgDxt331TwhGl1nlTO3RMnYHqoxe463mEWKc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eoLAKy5QdNgzUEI7fjXTMj8HBrE7F4uW8eiaKShHrHpfaThRVVYI6P/1Ot/Mq64mA2749jqo1kyvhXoyMdYZcrxGkwGDoniRreQYiw1B14BDRAMzAhi960AyqPEBqgr2RXAWOghG8ITqELXCfV6M/pX1sI+CESX4uNbAuI06rW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cOsD8Mwo; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 198E4C4CEE7;
	Mon, 28 Jul 2025 15:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753717010;
	bh=T9Rk8C7dgDxt331TwhGl1nlTO3RMnYHqoxe463mEWKc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cOsD8MwoycCgbAJAh8on/efwIiHwsxbkQXmwzfjCTAIQqhYKTqOGPKX6Xyhg72IRG
	 WL5cVel7fsMlApwDqCLfdyjCwTqkN66LwvZV/ehyz0fAQhcbRW2tkYatB+RhDbhIJa
	 4Z4FySIPQHBO87Qnk9Bb9V0dVGsLgj5JfgKIQrEw=
Date: Mon, 28 Jul 2025 17:36:47 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Thomas Huth <thuth@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-spdx@vger.kernel.org
Subject: Re: [PATCH v2] arch/x86/kvm/ioapic: Remove license boilerplate with
 bad FSF address
Message-ID: <2025072819-bobcat-ragged-81a7@gregkh>
References: <20250728152843.310260-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250728152843.310260-1-thuth@redhat.com>

On Mon, Jul 28, 2025 at 05:28:43PM +0200, Thomas Huth wrote:
> From: Thomas Huth <thuth@redhat.com>
> 
> The Free Software Foundation does not reside in "59 Temple Place"
> anymore, so we should not mention that address in the source code here.
> But instead of updating the address to their current location, let's
> rather drop the license boilerplate text here and use a proper SPDX
> license identifier instead. The text talks about the "GNU *Lesser*
> General Public License" and "any later version", so LGPL-2.1+ is the
> right choice here.
> 
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>  v2: Don't use the deprecated LGPL-2.1+ identifier

If you look at the LICENSES/preferred/LGPL-2.1 file, it says to use:
	SPDX-License-Identifier: LGPL-2.1+

as the kernel's SPDX level is older than you might think.

Also, doesn't the scripts/spdxcheck.pl tool object to the "or-later"
when you run it on the tree with this change in it?

thansk,

greg k-h

