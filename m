Return-Path: <kvm+bounces-8706-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FAC48552D9
	for <lists+kvm@lfdr.de>; Wed, 14 Feb 2024 20:00:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 24260284CCD
	for <lists+kvm@lfdr.de>; Wed, 14 Feb 2024 19:00:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3DA213A86A;
	Wed, 14 Feb 2024 19:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="X/1nET5W"
X-Original-To: kvm@vger.kernel.org
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C0B213A26B
	for <kvm@vger.kernel.org>; Wed, 14 Feb 2024 19:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707937209; cv=none; b=er1y/x3BE4Pp2rPJgX+D2tyYoz2ZlJKPVTWmC/fCysMxQ2ejzlKrQdaiJPDb17FQCMoVC1HovYm5JisJQSgQ9d4mj7vLjvFygVpPKtKhYvRle1ldHhJQHmhHJVsVUmFH3gJRGp6hhCAwUINCskhVgfT0uY3xfishD1BAnesW9nw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707937209; c=relaxed/simple;
	bh=UjVHdWRKxR1wWlwd6TPzyXgOHZ46hNGBZS4G23VAcsg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Uk+WSiPAwfkoTo0qzVrzAUCSSCWggVdRtwot0Cmlkw3Fj1A8reckTX1l+xURLEFJoE0nW2JWDlsM5vEOBU2FqWgBoEDVkeIgxbVCV6ey0eikjgqjoQbbrtyZ9MO2MxT8hSLKc96XQ2/vfk5KaYlJyCY9VWjoCDto7RK2vkW6E6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=X/1nET5W; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 14 Feb 2024 11:00:00 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1707937206;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4P041HuvLQ7qtWSEmdckANvsaD0Z2miUICFdYufhm48=;
	b=X/1nET5WtPtVfcZtVet1QEGDzDL7K064t5P+ZUnZ8xbF7EWyqkGtFsTHy1iBUXEx21LNXr
	SqhzO+L68HlVXmUP4J6fLej7uI3fLYtv63jfC9iKchwWjhLfOJbDkVRt2A67PT8ZGO5MDB
	2B37z9Zrxg8evl211A+GeQGjgfQUc2g=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 19/23] KVM: selftests: Add a minimal library for
 interacting with an ITS
Message-ID: <Zc0NsFm40nIqTmRf@linux.dev>
References: <20240213093250.3960069-1-oliver.upton@linux.dev>
 <20240213094114.3961683-1-oliver.upton@linux.dev>
 <86zfw33qae.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86zfw33qae.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Wed, Feb 14, 2024 at 05:32:25PM +0000, Marc Zyngier wrote:
> On Tue, 13 Feb 2024 09:41:14 +0000,
> Oliver Upton <oliver.upton@linux.dev> wrote:
> > 
> > A prerequisite of testing LPI injection performance is of course
> > instantiating an ITS for the guest. Add a small library for creating an
> > ITS and interacting with it *from userspace*.
> > 
> > Yep, you read that right. KVM unintentionally allows userspace to send
> > commands to the virtual ITS via the command queue. Besides adding test
> > coverage for an elusive UAPI, interacting with the ITS in userspace
> > simplifies the handling of commands that need to allocate memory, like a
> > MAPD command with an ITT.
> 
> I don't mean to derail the party, but I really think we should plug
> this hole. Either that, or we make it an official interface for state
> restore. And don't we all love to have multiple interfaces to do the
> same thing?

Ok, I've thought about it a bit more and I'm fully convinced we need to
shut the door on this stupidity.

We expect CREADR == CWRITER at the time userspace saves the ITS
registers, but we have a *hideous* ordering issue on the restore path.

If the order of restore from userspace is CBASER, CWRITER, CREADR then
we **wind up replaying the entire command queue**. While insane, I'm
pretty sure it is legal for the guest to write garbage after the read
pointer has moved past a particular command index.

Fsck!!!

So, how about we do this:

 - Provide a uaccess hook for CWRITER that changes the write-pointer
   without processing any commands

 - Assert an invariant that at any time CWRITER or CREADR are read from
   userspace that CREADR == CWRITER. Fail the ioctl and scream if that
   isn't the case, so that way we never need to worry about processing
   'in-flight' commands at the destination.

-- 
Thanks,
Oliver

