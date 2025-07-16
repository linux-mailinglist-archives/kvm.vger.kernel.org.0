Return-Path: <kvm+bounces-52626-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A791B074E0
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 13:36:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AF6B61897FFA
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 11:37:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28CE32F3C37;
	Wed, 16 Jul 2025 11:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qPJxqQZ3"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EE26EC2;
	Wed, 16 Jul 2025 11:36:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752665800; cv=none; b=ATQ09mvvrL0Ke9Vc5Ec0RJqhJJAhCb37RwHjUoULK33NlNBGPafgHTV211U8LNm0zlEGOqBvcLWPKE/VyC/6ifqjT8UMqjg0IXDH+VSCVpnkQNiWKO/Q/BcSOutmkz4fTgyugAlaKiotHEtsHZB40B9eUBSQEPXrENJtgAskxPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752665800; c=relaxed/simple;
	bh=EEdNTQ9edhqImKKR7yL1jTK7X6XNu/ZXDr2nrumJtGo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DFyxN6kgP2khnnEYmYjXWw7W5BgBovBVCKd1RFIOISwLKOyz2IrqA87BVieR8LxMt6WfSqKyzOg3I1oLMDAkH8YZROSM2y7M2foJFu3EXdcn7S8cnCVQZC0K+Lzl+iPY8yMYTNJ9peKJQV+8P0LPxurTpWb13d97Pu/nx2bSTFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qPJxqQZ3; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 658ABC4CEF6;
	Wed, 16 Jul 2025 11:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752665799;
	bh=EEdNTQ9edhqImKKR7yL1jTK7X6XNu/ZXDr2nrumJtGo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qPJxqQZ3oPlFVetdtZGJOHwLUZ+W4aik7mRKj6oMtlTE4gAI2DzexbmQdFgmwTrWr
	 g9MQg64VxCQs9hS1GtIFuF8z17NllNzMN6Ti4lWVxFdfKQLdrOi/ZB7fB+N8QOl/WJ
	 2rbKYmZMOi2IrSgk/dHKbzkXYFL5WS2wfZ9ch6k8=
Date: Wed, 16 Jul 2025 13:36:37 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Thomas Huth <thuth@redhat.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Thomas Gleixner <tglx@linutronix.de>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, linux-spdx@vger.kernel.org
Subject: Re: [PATCH v3] powerpc: Drop GPL boilerplate text with obsolete FSF
 address
Message-ID: <2025071628-retrace-collected-52b2@gregkh>
References: <20250711072553.198777-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250711072553.198777-1-thuth@redhat.com>

On Fri, Jul 11, 2025 at 09:25:53AM +0200, Thomas Huth wrote:
> From: Thomas Huth <thuth@redhat.com>
> 
> The FSF does not reside in the Franklin street anymore, so we should not
> request the people to write to this address. Fortunately, these header
> files already contain a proper SPDX license identifier, so it should be
> fine to simply drop all of this license boilerplate code here.
> 
> Suggested-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Thomas Huth <thuth@redhat.com>

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

