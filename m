Return-Path: <kvm+bounces-2267-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 075FC7F439B
	for <lists+kvm@lfdr.de>; Wed, 22 Nov 2023 11:21:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 67156B20A51
	for <lists+kvm@lfdr.de>; Wed, 22 Nov 2023 10:21:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14BA354BD0;
	Wed, 22 Nov 2023 10:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F/ezXvIa"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D34774B5A7;
	Wed, 22 Nov 2023 10:21:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 581E7C433C7;
	Wed, 22 Nov 2023 10:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700648460;
	bh=9e1LIluOfXARPyC/bVSfAb9OwVt3KSz5gYLI4Y5ZeHk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=F/ezXvIakcPxV8p+CN65gSJqDgElaFm2obrgPpefLT1zITfJQfTLgauIu52moOqOW
	 dBHaU2dOSPrV0MoDcPwUmb3CudqVroOjy/XUVbCqimLPHn0haod/SdAUjQ3OkQte9r
	 tBR/CKLmL7pVexUrP6v4G37r2DELeLNy8oMtYaOv6yzGgM+qlDbOb7lnp8PkCSyTxI
	 qYS2jMN2QLNOwGCfxZdCKAqNOlIboALQazeq+haskvO0UijLzl9EkNohsUueKZKDml
	 AKiVsRIFz1HZpVG84V0D4AeD6P3wjzs09CHE0XhtnAecLxiwaMooeL8JMXeWliozRY
	 CKGDW3U4GPnmA==
Date: Wed, 22 Nov 2023 11:20:56 +0100
From: Christian Brauner <brauner@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
	Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Next Mailing List <linux-next@vger.kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Vlastimil Babka <vbabka@suse.cz>
Subject: Re: linux-next: manual merge of the kvm tree with the vfs-brauner
 tree
Message-ID: <20231122-kartierung-bewilligen-0706aed5fd12@brauner>
References: <20231122125539.5a7df3a3@canb.auug.org.au>
 <20231122071040.GA4104@lst.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231122071040.GA4104@lst.de>

On Wed, Nov 22, 2023 at 08:10:40AM +0100, Christoph Hellwig wrote:
> On Wed, Nov 22, 2023 at 12:55:39PM +1100, Stephen Rothwell wrote:
> > index 06142ff7f9ce,bf2965b01b35..000000000000
> > --- a/include/linux/pagemap.h
> > +++ b/include/linux/pagemap.h
> > @@@ -203,9 -203,8 +203,10 @@@ enum mapping_flags 
> >   	/* writeback related tags are not used */
> >   	AS_NO_WRITEBACK_TAGS = 5,
> >   	AS_LARGE_FOLIO_SUPPORT = 6,
> > - 	AS_RELEASE_ALWAYS,	/* Call ->release_folio(), even if no private data */
> > + 	AS_RELEASE_ALWAYS = 7,	/* Call ->release_folio(), even if no private data */
> > + 	AS_UNMOVABLE	= 8,	/* The mapping cannot be moved, ever */
> >  +	AS_STABLE_WRITES,	/* must wait for writeback before modifying
> >  +				   folio contents */
> >   };
> 
> Note that AS_STABLE_WRITES, is a fix for 6.7, so this will probably

Yes, I plan on sending a fixes pr on Friday. I've wanted this in -next
for a few days.

