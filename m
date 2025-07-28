Return-Path: <kvm+bounces-53559-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CC89B13F38
	for <lists+kvm@lfdr.de>; Mon, 28 Jul 2025 17:51:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D59C83A1AE4
	for <lists+kvm@lfdr.de>; Mon, 28 Jul 2025 15:50:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8700273811;
	Mon, 28 Jul 2025 15:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RPtz71t5"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE33A26FA5A;
	Mon, 28 Jul 2025 15:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753717821; cv=none; b=e42UywJE3l1HOu8K0jV2l9Iex/S/84TncMAdHyCF5TQId1EZY3ETiDTSv0+Z0toWvPtgakHrxYwuW6DIDZqUEZwkAeAAU5ew4qt5q/KYRZ3HB2gKm1hiDk75Sk9Yxudw0JrtMC3DH2ZPpEX4uANEisLhbb9hs34OLE0FIH564OM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753717821; c=relaxed/simple;
	bh=NpmjvvwAGghE+Galaz/VMYkCBIf4ORxsafb1hYhmUQI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TjTACASNdjaonJ3IHxq4CDYeyE5y5A02GKyjrXTufBurzrOQR2RpEA/48g227pW5HS81vc6BwdPDopE1Fl/DQAY9HewPCCnOQt88zFTf6KPYbVoa6jGdIwV1wySNdLSvzsRzSLtin+kp5eTrwX1z8wLDy873R1H9N2B1lxARTqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RPtz71t5; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06C26C4CEEF;
	Mon, 28 Jul 2025 15:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753717820;
	bh=NpmjvvwAGghE+Galaz/VMYkCBIf4ORxsafb1hYhmUQI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RPtz71t56FHe7QEtuG3DOUi3FHVitmIG1bpqrGUKLNKlTyNH8ZsufdJslD0yVijMX
	 gvaw+b+RHbDRX2rfHzAVsyBU8K/jkqZvNbXItinZVXSxF45HSadrhafGB+6+kL19SP
	 FD+g2+UqGoNF1IYhq0dqiIlj+QTXE180o3AGlSxY=
Date: Mon, 28 Jul 2025 17:50:17 +0200
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
Message-ID: <2025072818-revoke-eggnog-459a@gregkh>
References: <20250728152843.310260-1-thuth@redhat.com>
 <2025072819-bobcat-ragged-81a7@gregkh>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2025072819-bobcat-ragged-81a7@gregkh>

On Mon, Jul 28, 2025 at 05:36:47PM +0200, Greg Kroah-Hartman wrote:
> On Mon, Jul 28, 2025 at 05:28:43PM +0200, Thomas Huth wrote:
> > From: Thomas Huth <thuth@redhat.com>
> > 
> > The Free Software Foundation does not reside in "59 Temple Place"
> > anymore, so we should not mention that address in the source code here.
> > But instead of updating the address to their current location, let's
> > rather drop the license boilerplate text here and use a proper SPDX
> > license identifier instead. The text talks about the "GNU *Lesser*
> > General Public License" and "any later version", so LGPL-2.1+ is the
> > right choice here.
> > 
> > Signed-off-by: Thomas Huth <thuth@redhat.com>
> > ---
> >  v2: Don't use the deprecated LGPL-2.1+ identifier
> 
> If you look at the LICENSES/preferred/LGPL-2.1 file, it says to use:
> 	SPDX-License-Identifier: LGPL-2.1+
> 
> as the kernel's SPDX level is older than you might think.
> 
> Also, doesn't the scripts/spdxcheck.pl tool object to the "or-later"
> when you run it on the tree with this change in it?

Ugh, sorry, no, it lists both, the tool should have been fine.  I was
reading the text of the file, not the headers at the top of it.  My
fault.

Anyway, I'll let this go through the subsystem tree for it, after the
merge window is closed, as that's the best way for it to flow forward.

thanks,

greg k-h

