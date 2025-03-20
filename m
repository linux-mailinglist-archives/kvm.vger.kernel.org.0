Return-Path: <kvm+bounces-41587-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 60BFAA6AC25
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 18:38:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 589D516D0B7
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 17:38:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 848262253E1;
	Thu, 20 Mar 2025 17:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="nnT3hIUB"
X-Original-To: kvm@vger.kernel.org
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D450224231
	for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 17:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742492298; cv=none; b=cKexZid2TNCWbLptXNzeRFiUhf6wnwuW3lOfuw6j0l9B+Ri1urSgOhYU37qeUEE+os7E1A+EA0zh36bkvlQvmBAb6VaKzUYgwBZXHZrWwldmd0LxOklVjcHLJn+8dVhNnQL0638U6MtborG8lFtbgj0uX2ICY1yI0t7FmthyAkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742492298; c=relaxed/simple;
	bh=Z9C15AkS/KNTsjiE9zrEWX9uPD+dMtK0liUErSu6KyI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nc4xj/5mLTztBnqDlzTc7MYJzBdKkzQp4Lk1jIRxJxEDIZ7UGdQ4svjbU2Hx0QxQAztPQWi+PXoYMq2wz1OpwmOIIqku1tCKe4WriyonPeDcmT9DpYT6prCHxCbcxZp7slTNMW8RozVG3lX6gyVg2KYtd/OGsSncrBVO5AJEuFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=nnT3hIUB; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 20 Mar 2025 17:38:04 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742492291;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JpIl7s4k0QjfaNt0StcfT9UarLcu7cj3e49SR4rX/no=;
	b=nnT3hIUBsgnGM6OGhjR30ZyWUhY7Io2zWkwyvjvo7ABUJev55/ULGdbaumRz4w6Ds8Pe4t
	Zf9+bf/Z+Jb3PUnjkyMcyrIvl1etIwHwsJzCvSSpS7mnYW1js8s7Cx0MfMOUnSriq08mCq
	HNSNOWZ7fT4gMdtaQUc03ot9htnuEQA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev, Akihiko Odaki <akihiko.odaki@daynix.com>,
	Will Deacon <will@kernel.org>,
	Vincent Donnefort <vdonnefort@google.com>,
	Sebastian Ott <sebott@redhat.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Fuad Tabba <tabba@google.com>
Subject: Re: [GIT PULL] KVM/arm64 updates for 6.15
Message-ID: <Z9xSfHskUajdZDLq@linux.dev>
References: <Z9uZpZKfqWP8ZwH8@linux.dev>
 <86ecyrn9hf.wl-maz@kernel.org>
 <Z9wZ8EuChPyJ6PiK@linux.dev>
 <CABgObfbHz1iyrH69JiF19RC4SSiYVbRN1P2+KRkFWSEg_2mjbQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABgObfbHz1iyrH69JiF19RC4SSiYVbRN1P2+KRkFWSEg_2mjbQ@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Mar 20, 2025 at 06:23:22PM +0100, Paolo Bonzini wrote:
> On Thu, Mar 20, 2025 at 2:37 PM Oliver Upton <oliver.upton@linux.dev> wrote:
> >
> > Hey,
> >
> > On Thu, Mar 20, 2025 at 12:59:40PM +0000, Marc Zyngier wrote:
> > > Paolo,
> > >
> > > On Thu, 20 Mar 2025 04:29:25 +0000,
> > > Oliver Upton <oliver.upton@linux.dev> wrote:
> > > >
> > > > Hi Paolo,
> > > >
> > > > Here's the latest pile o' patches for 6.15. The pull is based on a later
> > > > -rc than I usually aim for to handle some conflicts with fixes that went
> > > > in 6.14, but all of these patches have had exposure in -next for a good
> > > > while.
> > > >
> > > > There was a small conflict with the arm perf tree, which was addressed
> > > > by Will pulling a prefix of the M1 PMU branch:
> > > >
> > > >   https://lore.kernel.org/linux-next/20250312201853.0d75d9fe@canb.auug.org.au/
> > >
> > > When you merge this, please also apply the patch below to address a
> > > mismerge issue caught by Stephen, which causes a build breakage.
> >
> > The kvmarm-6.15 tag is fine, I caught this immediately when I was doing
> > testing for the pull request but forgot to push the fix to /next in
> > addition to the tag.
> 
> Great, pulled now. Thanks!

Awesome, thank you and sorry for the noise.

Thanks,
Oliver

