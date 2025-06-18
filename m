Return-Path: <kvm+bounces-49872-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DF1A6ADECB9
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 14:39:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4898F176009
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 12:35:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 661322E7181;
	Wed, 18 Jun 2025 12:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DijN8Sil"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AF85285C8B;
	Wed, 18 Jun 2025 12:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750249895; cv=none; b=QXg3Ummf9kpN+YzTAPu/SEGRU73V/R0FhqkfLhpGU3pN13H2kjJXx1TMDy/1BLf8ITsMlcKBQPtb2Is+XsJ6b8kY9o3APIYJ3qSE3nlkYgihv1AMyDVKEIqW8Q2gu1vPOQA8Z81v12lL8/gD4U8NgR4H5Z5PhEkubL+xuu1oJmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750249895; c=relaxed/simple;
	bh=3ZrI052V23T+mNrFLFPPcK3CIF/YjYSdxgqZH0iO2d0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Xsq9zPZq23KjhwKK+THSw8yX8UyUpxA8jJRYuIWUCxJ+WU40ZS44qVpzSs1EPQ/2KqB9AgSpa96v5YhiUrhyYoyFYQfqqCd1Mw6vrNFtIg40zP33vmoXe3MM8AoItIOA3E3DUDEkoICGfovaauFkrT3fDDDn3Nd279d33Gc2hkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DijN8Sil; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 464B3C4CEE7;
	Wed, 18 Jun 2025 12:31:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750249893;
	bh=3ZrI052V23T+mNrFLFPPcK3CIF/YjYSdxgqZH0iO2d0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DijN8Sil7SIDh7aMjK7gKz3beUUdlrtDXsfV9XqMLHI2sWXIPtLhM9yZKqEhdLv0S
	 16UPsbzgcQ/2ZsrzKi70rJ+Cfjy3JGmJ+KmSxJCt9z5wRq09rmY0McIDUQqnz10aW9
	 eBy84xrynrdhhZ3XQyI7hYerF6M+z25EkcOZmpay0EwFLprTzfNBvrxFVazlqo5XTW
	 zzt468nWONM2EYqrbOVk859JQXXPzqN9yAADNYQ5bSAUtlT1o7E5gzrTXNwc/VQcjJ
	 KUPXZZ/qElxiFMuYaksyZwOVodEgisAenxD7DGhN6W5Q/Uq3bHXp3XJnKOXOl/AKfb
	 +PJD2RifMK7qw==
Date: Wed, 18 Jun 2025 13:31:30 +0100
From: Simon Horman <horms@kernel.org>
To: ALOK TIWARI <alok.a.tiwari@oracle.com>
Cc: mst@redhat.com, jasowang@redhat.com, eperezma@redhat.com,
	kvm@vger.kernel.org, virtualization@lists.linux.dev,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Re: [PATCH] vhost: Fix typos in comments and clarity on alignof
 usage
Message-ID: <20250618123130.GM1699@horms.kernel.org>
References: <20250615173933.1610324-1-alok.a.tiwari@oracle.com>
 <20250617183741.GD2545@horms.kernel.org>
 <eb95149b-89eb-437f-813d-0045635aee8b@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eb95149b-89eb-437f-813d-0045635aee8b@oracle.com>

On Wed, Jun 18, 2025 at 01:31:09AM +0530, ALOK TIWARI wrote:
> 
> 
> Thanks Simon,
> 
> On 6/18/2025 12:07 AM, Simon Horman wrote:
> > On Sun, Jun 15, 2025 at 10:39:11AM -0700, Alok Tiwari wrote:
> > > This patch fixes multiple typos and improves comment clarity across
> > > vhost.c.
> > > - Correct spelling errors: "thead" -> "thread", "RUNNUNG" -> "RUNNING"
> > >    and "available".
> > > - Improve comment by replacing informal comment ("Supersize me!")
> > >    with a clear description.
> > > - Use __alignof__ correctly on dereferenced pointer types for better
> > >    readability and alignment with kernel documentation.
> > Could you expand on the last point?
> > I see that the patch uses __alignof__ with rather than without parentheses.
> > But I don't follow how that corresponds with the comment above.
> 
> only I can say "__alignof__ *vq->avail" is valid C,
> but it can hard to read and easy to misinterpret.
> Without proper parentheses sometime, __alignof__ *vq->avail can be
> misleading to reader. it may not be immediately clear whether it refers to
> alignment of the pointer vq->avail or
> alignment of the object it points to.
> __alignof__(*vq->avail) adds parentheses that clarify the intention
> explicitly.
> I can not see very clear guide line to using parentheses or not for
> __alignof__ in kernel document apart
> from(https://www.kernel.org/doc/html/latest/process/coding-style.html).
> Additionally, I have not been able to locate examples in the kernel code
> where __alignof__ is used without parentheses.

Thanks, I understand now.

Perhaps it's not important, but FWIIW I was confused by "correctly".
And something like this seems a bit clearer to me.

  - Use __alignof__ with parentheses which is in keeping with kernel coding
    style for an __attribute__ and arguably improves readability of what is
    being aligned.

In any case, thanks for your explanation.
This patch now looks good to me.

Reviewed-by: Simon Horman <horms@kernel.org>


