Return-Path: <kvm+bounces-53550-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 23108B13DDC
	for <lists+kvm@lfdr.de>; Mon, 28 Jul 2025 17:07:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 67A86189DB61
	for <lists+kvm@lfdr.de>; Mon, 28 Jul 2025 15:07:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89AC22701C8;
	Mon, 28 Jul 2025 15:07:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kuFfL7aD"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95605264623;
	Mon, 28 Jul 2025 15:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753715243; cv=none; b=lJ4sAbhG79SrKajDCLBBFAZ2gGJFFZEmo7SD7+5g4JlI4DuB046C2qTUHZtesuM+cPEfswzWsgmxFkdOpvjih629TDbs7NwqmL6AevhAK04KQSDQCZPnylRr6af3qY54/PrT19rBaxQUnmM1y0D3ZTlI6h/VXK0KX+w+OIwjV7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753715243; c=relaxed/simple;
	bh=6sh5fL/6H+RTNu7ilK9pLypQK0pDUnrA/A6mqFLr4jk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=StWKJilNBmeLQTOXn5EPyVEDbAKRw9Fm1qX3e3sdL7QrFigY3wpChhnG3Rrn6eLa7SJFhOhosLX7o256h1FLUy0/qFk9Sj8YlnTxVKx42N252hxMJBHi6lMQd8rtN1vCC1l+3xnqyqIGh29gcgFIgwFe9AM3jrk1XNlX4mML+bE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kuFfL7aD; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D889C4CEE7;
	Mon, 28 Jul 2025 15:07:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753715243;
	bh=6sh5fL/6H+RTNu7ilK9pLypQK0pDUnrA/A6mqFLr4jk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kuFfL7aDkmfSdapYu0Y/RGXFD4eAFvv9tlzdqknq7QjMmeynoLrfPXKgN/hft9HHm
	 4oqXMI+ceBNorHmnn0+RcKDpZeWT+SoCy2uMnyf16JSFWy2bE7GrDuV+tQRmbP7nnN
	 fh/ZErfxA4wtM+e6zxfz+U7iZMmMj191ITUTdD6A=
Date: Mon, 28 Jul 2025 17:07:20 +0200
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
Message-ID: <2025072843-browbeat-rocket-c549@gregkh>
References: <20250728141540.296816-1-thuth@redhat.com>
 <PR3PR07MB81837F4778329A2270CC9318AC5AA@PR3PR07MB8183.eurprd07.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <PR3PR07MB81837F4778329A2270CC9318AC5AA@PR3PR07MB8183.eurprd07.prod.outlook.com>

On Mon, Jul 28, 2025 at 02:59:26PM +0000, Marc-Etienne Vargenau (Nokia) wrote:
> Hello,
> 
> That should be:
> // SPDX-License-Identifier: LGPL-2.1-or-later
> not
> // SPDX-License-Identifier: LGPL-2.1+
> 
> « LGPL-2.1+ » is deprecated
> https://spdx.org/licenses/LGPL-2.1+.html

The kernel does not differenciate between the two at this point in time,
sorry.  Either is fine for now.

Only AFTER we actually tag all files in the tree will we worry about
silly things like this.

thanks,

greg k-h

