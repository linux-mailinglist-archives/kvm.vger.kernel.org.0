Return-Path: <kvm+bounces-62667-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F7ECC4A168
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 01:59:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CB17E188E67B
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 00:59:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A51C257842;
	Tue, 11 Nov 2025 00:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="KLA9yCoO"
X-Original-To: kvm@vger.kernel.org
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 072B94C97
	for <kvm@vger.kernel.org>; Tue, 11 Nov 2025 00:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822724; cv=none; b=NGfWwzxQoA2jtydot/gpF9qF+mMYq3B158+Eoepg5JLhBK0OA+XPmJqi82UCMdh8Sr99IVWqzuLB0Nq3T6in9yZX5TzCYpYeSMjyir3ag0gWoxbMm9P99xFf3KbS3VuW7qCLCjtiIf2MTPe0nr7PWhO7y1d9omYthJ3rbAmkqxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822724; c=relaxed/simple;
	bh=SdFhQ6OZB0yMMMQZRGiMyXL9GCPyz7OFon/zG6zgvuQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o5fgcftV5/9e+QW0207pxjQo5y2DoakJhh9TJ3aPZ4S/WIIVGNGH/dC9Jd9eGsPzIuAzZKCrNqburom4mT1O7c2wzsT3rEO7M9GK9RDwK8SCZ0C+oSAjqo5mKwcMru8whpdcHidutYjR9/bhYheJUhkKiFUbhuF9DTVAgzsOTMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=KLA9yCoO; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 11 Nov 2025 00:58:24 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762822710;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SdFhQ6OZB0yMMMQZRGiMyXL9GCPyz7OFon/zG6zgvuQ=;
	b=KLA9yCoOqkUwo6Oub4tIa8sCyoPxaq0Br1aquYBAY1k2fqZuDsnvE7ZYxhdt5nx1TSWYhj
	sufgZD3O4SjhQrtgoEJm+WZ11qse9WOH0Mp49JOhUBqSiHTx4YxUroBgmbrYLcZck/2j5L
	opVFtR0bmmiBHup/EWGa3kzfxcpNCqQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Kevin Cheng <chengkev@google.com>, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 00/14] Improvements for (nested) SVM testing
Message-ID: <ooihav6sc5d6bace3kxug3ze2oicumwyocdhh5kletjclmnk27@cxzqcmn6eo2v>
References: <20251110232642.633672-1-yosry.ahmed@linux.dev>
 <aRKI1bzrNRiWaQBK@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aRKI1bzrNRiWaQBK@google.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Nov 10, 2025 at 04:52:37PM -0800, Sean Christopherson wrote:
> Nit, in the future, please label the patches with "kvm-unit-tests" so that it's
> super obvious what they're for, e.g. [kvm-unit-tests PATCH ...].

Ugh not a nit, it's actually annoying, even for me, because I use these
labels to search for my patches. Sorry about that, I had the correct
prefix in previous versions but forgot to add it this time around.

Let me know if you want me to resend to make things easier for you
(assuming you'll be the one to apply this if/when the time comes :) ).

