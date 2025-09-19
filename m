Return-Path: <kvm+bounces-58136-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7879CB88BC1
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 12:02:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A07807BCE8A
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 10:00:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 892103081BA;
	Fri, 19 Sep 2025 09:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q5h4GRrT"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8B8C306B34;
	Fri, 19 Sep 2025 09:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758275968; cv=none; b=RVVpDpLzIMcqSI/umE96OUY0Z+U049myRt/1f1+BKtOTnoyreoudpyjOX6U4pZGytWTATKQuwGNxx+5CUMT6M0VKc1xtJfYXPCXiSVo90h70Dv97KU/ndMndyFWt4m7f62FAvXfvKVdc31txyhmW6mcdeKqiNyUWikYNwMPw5+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758275968; c=relaxed/simple;
	bh=HGGGwvaCwEsmfudnqJ9QpGdepwiqxeWcroz7m6jVT70=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GiDFCHDc4y0rq9QCHk9wfQGnQRYnnK+TYPLxRf2WUCUIrGGeoWZUfVflueoXRX6sAjVhkIk76CuOwClBNsWma+D2h9Y42OYJUecRhcvUvc64JtsIKuwrqfVG5vyIcMPO6W70vNvxLv/vXGccrPnkwIqICAowzWEuUG9LbDDLnPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q5h4GRrT; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 318A7C4CEF1;
	Fri, 19 Sep 2025 09:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758275967;
	bh=HGGGwvaCwEsmfudnqJ9QpGdepwiqxeWcroz7m6jVT70=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Q5h4GRrTq9YIfHhMB6tvoanuDXd7L8kn0RhUaLX8zjckc2NAfBDL+bI9Sinm5VSTd
	 gck1GtOP6/ccTBZr5RSBeDM4NA9XyUAZGj84QIOqTpvJSCOzMqtY4GxA40Uj9kUzNQ
	 HrZJ+VbWbNItYm7DBhCCrcGBuAoeXGqlpJz6mAw8fTK+9dFb62MozuhuglLdsXv7YT
	 jDquKVGHMM9Xwpw+Am1vUOuiTKUd7pho+PyoRIQ7oZaYi/GAR85wjqVtudxC9qj5YW
	 2BV9knG44T1IxiOtUx0akxdZegik5CMfOp10U8mJxeBcRsx6iVR8YAdzBr8fBgXB8t
	 npC5oml8179sA==
Date: Fri, 19 Sep 2025 15:22:30 +0530
From: Naveen N Rao <naveen@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/6] KVM: SVM: Always print "AVIC enabled" separately,
 even when force enabled
Message-ID: <ychqmtz344ewhr5bkjqnfmo4masi4wf5uuawgwyjutebhmvfo6@oeiz5btv6xxw>
References: <20250919002136.1349663-1-seanjc@google.com>
 <20250919002136.1349663-4-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250919002136.1349663-4-seanjc@google.com>

On Thu, Sep 18, 2025 at 05:21:33PM -0700, Sean Christopherson wrote:
> Print the customary "AVIC enabled" informational message even when AVIC is
> force enabled on a system that doesn't advertise supported for AVIC in
						   ^^ support

> CPUID, as not printing the standard message can confuse users and tools.
> 
> Opportunistically clean up the scary message when AVIC is force enabled,
> but keep it as separate message so that it is printed at level "warn",
		 a separate message

> versus the standard message only being printed for level "info".
> 
> Suggested-by: Naveen N Rao <naveen@kernel.org>

Please use (with attribution):
Naveen N Rao (AMD) <naveen@kernel.org>

> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/svm/avic.c | 19 +++++++++----------
>  1 file changed, 9 insertions(+), 10 deletions(-)

Reviewed-by: Naveen N Rao (AMD) <naveen@kernel.org>


- Naveen


