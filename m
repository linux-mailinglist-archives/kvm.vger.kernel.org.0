Return-Path: <kvm+bounces-39547-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 35938A4777F
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 09:17:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 531B17A4189
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 08:16:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4702322A811;
	Thu, 27 Feb 2025 08:15:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ILxBmEGl"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66C5B228CB5;
	Thu, 27 Feb 2025 08:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740644106; cv=none; b=pRGR+USIMPk21wSOBXRDylX0sMM9AnztdX2O19mvPtHhrNDSO/SVl6qeXYnmn+R6X+nJ2SS6uIjmDyVWkdhOqQeoZcJXQJN1l76asCyTeP3WGThAAFNG07d5SeH1nVnyNAYFoYFra0YpGgohJTmM2rY5valRpv6KqWWyI8Kcuy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740644106; c=relaxed/simple;
	bh=mkZPOtG0SE8QEywaKMiO1vrqsRdGcRWOFYs77JJYcg4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AFe/UijrV8pjTlT82kLm7qafKParDTgyVjEp5Of0c1yibT2xbjKpwMDCkbnf6pZu5wn2WUxcx5+VNkh1Jt636YEHUftws0niXh5YrWtxtPa4IJfWc1MamTWcb8HSPut4DQ5JpMEYzrJlr7wfOAmmTsfJ8GufLrLy/eUZQ169sdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ILxBmEGl; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 397A9C4CEE4;
	Thu, 27 Feb 2025 08:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740644105;
	bh=mkZPOtG0SE8QEywaKMiO1vrqsRdGcRWOFYs77JJYcg4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ILxBmEGlIn4jzE06wP+gi+o6yz5J+S/zP3Za3Ns+UXLGaML6u8RPvar7j4LeFHKGk
	 8T7183CQSz2AtUl3CexXE0vl746INeDB48ii2lSnxYK8tgsCyBf8AQJmYVuQwr/xs4
	 9ddgLw6gVOHIy5T5GzAiFaJMJUopNgL6j6NCSuR0LqkRqIH73QqflZjw5Ftr6pBQ3x
	 8weip5xcB54R99BuVUo/4rgJNllanZhbveNPil47mhJ88FXdniJUY59y/MciQa25X1
	 pLapgEQ0PTlRC9YZnlvTHmCVEbpxpdcQ15Jx9gXBTOoTAirRrU5whMN923sCHrF+gx
	 ZyV2Dblsm4vwQ==
Date: Thu, 27 Feb 2025 09:15:01 +0100
From: Christian Brauner <brauner@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, 
	Linus Torvalds <torvalds@linux-foundation.org>, "Michael S. Tsirkin" <mst@redhat.com>, 
	"Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [GIT PULL] KVM changes for Linux 6.14
Message-ID: <20250227-teigtaschen-junitag-4dfb547792b4@brauner>
References: <CAHk-=wiOSyfW3sgccrfVtanZGUSnjFidSbaP3tg9wapydb-u6g@mail.gmail.com>
 <20250126185354.GB28135@redhat.com>
 <CAHk-=wiA7wzJ9TLMbC6vfer+0F6S91XghxrdKGawO6uMQCfjtQ@mail.gmail.com>
 <20250127140947.GA22160@redhat.com>
 <CABgObfaar9uOx7t6vR0pqk6gU-yNOHX3=R1UHY4mbVwRX_wPkA@mail.gmail.com>
 <20250204-liehen-einmal-af13a3c66a61@brauner>
 <CABgObfaBizrwP6mh82U20Y0h9OwYa6OFn7QBspcGKak2r+5kUw@mail.gmail.com>
 <20250205-bauhof-fraktionslos-b1bedfe50db2@brauner>
 <20250226-portieren-staudamm-10823e224307@brauner>
 <20250226190322.GL8995@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250226190322.GL8995@redhat.com>

On Wed, Feb 26, 2025 at 08:03:23PM +0100, Oleg Nesterov wrote:
> Sorry, didn't have time to actually read this patch, but after a quick
> glance...
> 
> On 02/26, Christian Brauner wrote:
> >
> > @@ -3949,7 +3955,7 @@ static int proc_task_readdir(struct file *file, struct dir_context *ctx)
> >  	tid = (int)(intptr_t)file->private_data;
> >  	file->private_data = NULL;
> >  	for (task = first_tid(proc_pid(inode), tid, ctx->pos - 2, ns);
> > -	     task;
> > +	     task && !(task->flags & PF_USER_WORKER);
> 
> unless I am totally confused this looks "obviously wrong".
> 
> proc_task_readdir() should not stop if it sees a PF_USER_WORKER task, this
> check should go into first_tid/next_tid.

It's really a draft as I said. I'm more interested in whether this is a
viable idea to separate kernel spawned workers into /proc/<pid>/worker
and not show them in /proc/<pid>/task or if this is a non-starter. If so
then I'll send an actual patch that also doesn't include
code-duplication to no end. ;)

