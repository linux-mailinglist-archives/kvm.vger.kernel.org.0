Return-Path: <kvm+bounces-40275-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D8D97A55883
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 22:15:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 75FD33A6351
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 21:14:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 909AB276046;
	Thu,  6 Mar 2025 21:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="tKlJ2CN0";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="cuwYJRYL";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="tKlJ2CN0";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="cuwYJRYL"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3DD6207A03
	for <kvm@vger.kernel.org>; Thu,  6 Mar 2025 21:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741295679; cv=none; b=eBl4LOUxDAz/tjsJXCvV//6MeAya7di0ma9Azhz1RoFP0K1EritlVGHkr4QKt6hxRocjFs9irvaCVfZ00CRdurCcaqLxM3hFxdZr2ckXZxz6G+av4fCnSnBKgsJu9NgHdOujcgHiyT5oCFwXwTiEoCt8BaIlrhtricZAEMgZ6vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741295679; c=relaxed/simple;
	bh=13kDV5whj4L1YS0AqHhMEuwczR+U+UAB5GvMyPo/ScA=;
	h=Content-Type:MIME-Version:From:To:Cc:Subject:In-reply-to:
	 References:Date:Message-id; b=pS28GSlo2Otu96LeRaiHfKoL962ysg3S30ilfPwt2bkxaZ3lNXrqez4iC3QqRn8OjZeRa/yTpyr2pTU3+LLZLmyNs4D7FLC25TMFmwP+L/8w+vkbeyoMS35tT++8lWQ/3wy7CNsvr7uTnhSlkuJ4m9vVKUjHp89Vohaf7Ll2BY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=tKlJ2CN0; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=cuwYJRYL; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=tKlJ2CN0; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=cuwYJRYL; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D3BE321172;
	Thu,  6 Mar 2025 21:14:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1741295675; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=W8wPE8KKZYE0b2eeWO1d4HM7Dis42luxW+pjVxoJ1rs=;
	b=tKlJ2CN0wPg7rRWhJblyU+m6/5JlLhvjqJs9DUQdv95bf35qpGhbrKpwR4L1ubUl6HHzMC
	ojHovccIPbw0DHajEIngncj4h9SzsPp7jcDSVykyVxYvu+K6xi485lt2OJtDUqbxaO8V2q
	1Vt+eGq4eU93co2ldGDFw3X1pdN63uY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1741295675;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=W8wPE8KKZYE0b2eeWO1d4HM7Dis42luxW+pjVxoJ1rs=;
	b=cuwYJRYLTPadg9cLaIfWHdAJDR33+mWHNeymeUhWYbcZ+XGJ68tR+aeh5VXxvpzyhsQA8a
	TbH2enWt9B0YdnCg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1741295675; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=W8wPE8KKZYE0b2eeWO1d4HM7Dis42luxW+pjVxoJ1rs=;
	b=tKlJ2CN0wPg7rRWhJblyU+m6/5JlLhvjqJs9DUQdv95bf35qpGhbrKpwR4L1ubUl6HHzMC
	ojHovccIPbw0DHajEIngncj4h9SzsPp7jcDSVykyVxYvu+K6xi485lt2OJtDUqbxaO8V2q
	1Vt+eGq4eU93co2ldGDFw3X1pdN63uY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1741295675;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=W8wPE8KKZYE0b2eeWO1d4HM7Dis42luxW+pjVxoJ1rs=;
	b=cuwYJRYLTPadg9cLaIfWHdAJDR33+mWHNeymeUhWYbcZ+XGJ68tR+aeh5VXxvpzyhsQA8a
	TbH2enWt9B0YdnCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1D40E13A61;
	Thu,  6 Mar 2025 21:14:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id MBkAMC0QymdSewAAD6G6ig
	(envelope-from <neilb@suse.de>); Thu, 06 Mar 2025 21:14:21 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: "NeilBrown" <neilb@suse.de>
To: "Yunsheng Lin" <linyunsheng@huawei.com>
Cc: "Qu Wenruo" <wqu@suse.com>, "Yishai Hadas" <yishaih@nvidia.com>,
 "Jason Gunthorpe" <jgg@ziepe.ca>,
 "Shameer Kolothum" <shameerali.kolothum.thodi@huawei.com>,
 "Kevin Tian" <kevin.tian@intel.com>,
 "Alex Williamson" <alex.williamson@redhat.com>, "Chris Mason" <clm@fb.com>,
 "Josef Bacik" <josef@toxicpanda.com>, "David Sterba" <dsterba@suse.com>,
 "Gao Xiang" <xiang@kernel.org>, "Chao Yu" <chao@kernel.org>,
 "Yue Hu" <zbestahu@gmail.com>, "Jeffle Xu" <jefflexu@linux.alibaba.com>,
 "Sandeep Dhavale" <dhavale@google.com>, "Carlos Maiolino" <cem@kernel.org>,
 "Darrick J. Wong" <djwong@kernel.org>,
 "Andrew Morton" <akpm@linux-foundation.org>,
 "Jesper Dangaard Brouer" <hawk@kernel.org>,
 "Ilias Apalodimas" <ilias.apalodimas@linaro.org>,
 "David S. Miller" <davem@davemloft.net>, "Eric Dumazet" <edumazet@google.com>,
 "Jakub Kicinski" <kuba@kernel.org>, "Paolo Abeni" <pabeni@redhat.com>,
 "Simon Horman" <horms@kernel.org>, "Trond Myklebust" <trondmy@kernel.org>,
 "Anna Schumaker" <anna@kernel.org>, "Chuck Lever" <chuck.lever@oracle.com>,
 "Jeff Layton" <jlayton@kernel.org>, "Olga Kornievskaia" <okorniev@redhat.com>,
 "Dai Ngo" <Dai.Ngo@oracle.com>, "Tom Talpey" <tom@talpey.com>,
 "Luiz Capitulino" <luizcap@redhat.com>,
 "Mel Gorman" <mgorman@techsingularity.net>,
 "Dave Chinner" <david@fromorbit.com>, kvm@vger.kernel.org,
 virtualization@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-btrfs@vger.kernel.org, linux-erofs@lists.ozlabs.org,
 linux-xfs@vger.kernel.org, linux-mm@kvack.org, netdev@vger.kernel.org,
 linux-nfs@vger.kernel.org
Subject: Re: [PATCH v2] mm: alloc_pages_bulk: remove assumption of populating
 only NULL elements
In-reply-to: <f834a7cd-ca0a-4495-a787-134810aa0e4d@huawei.com>
References: <>, <f834a7cd-ca0a-4495-a787-134810aa0e4d@huawei.com>
Date: Fri, 07 Mar 2025 08:14:14 +1100
Message-id: <174129565467.33508.7106343513316364028@noble.neil.brown.name>
X-Spam-Score: -4.30
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.993];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_TWELVE(0.00)[44];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[suse.com,nvidia.com,ziepe.ca,huawei.com,intel.com,redhat.com,fb.com,toxicpanda.com,kernel.org,gmail.com,linux.alibaba.com,google.com,linux-foundation.org,linaro.org,davemloft.net,oracle.com,talpey.com,techsingularity.net,fromorbit.com,vger.kernel.org,lists.linux.dev,lists.ozlabs.org,kvack.org];
	R_RATELIMIT(0.00)[to_ip_from(RL4q5k5kyydt8nhc3xa4shdp4c),from(RLewrxuus8mos16izbn)];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Level: 

On Thu, 06 Mar 2025, Yunsheng Lin wrote:
> On 2025/3/6 7:41, NeilBrown wrote:
> > On Wed, 05 Mar 2025, Yunsheng Lin wrote:
> >>
> >> For the existing btrfs and sunrpc case, I am agreed that there
> >> might be valid use cases too, we just need to discuss how to
> >> meet the requirements of different use cases using simpler, more
> >> unified and effective APIs.
> > 
> > We don't need "more unified".
> 
> What I meant about 'more unified' is how to avoid duplicated code as
> much as possible for two different interfaces with similar‌ functionality.
> 
> The best way I tried to avoid duplicated code as much as possible is
> to defragment the page_array before calling the alloc_pages_bulk()
> for the use case of btrfs and sunrpc so that alloc_pages_bulk() can
> be removed of the assumption populating only NULL elements, so that
> the API is simpler and more efficient.
> 
> > 
> > If there are genuinely two different use cases with clearly different
> > needs - even if only slightly different - then it is acceptable to have
> > two different interfaces.  Be sure to choose names which emphasise the
> > differences.
> 
> The best name I can come up with for the use case of btrfs and sunrpc
> is something like alloc_pages_bulk_refill(), any better suggestion about
> the naming?

I think alloc_pages_bulk_refill() is a good name.

So:
- alloc_pages_bulk() would be given an uninitialised array of page
  pointers and a required count and would return the number of pages
  that were allocated
- alloc_pages_bulk_refill() would be given an initialised array of page
  pointers some of which might be NULL.  It would attempt to allocate
  pages for the non-NULL pointers and return the total number of
  allocated pages in the array - just like the current
  alloc_pages_bulk().

sunrpc could usefully use both of these interfaces.

alloc_pages_bulk() could be implemented by initialising the array and
then calling alloc_pages_bulk_refill().  Or alloc_pages_bulk_refill()
could be implemented by compacting the pages and then calling
alloc_pages_bulk().
If we could duplicate the code and have two similar but different
functions.

The documentation for _refill() should make it clear that the pages
might get re-ordered.

Having looked at some of the callers I agree that the current interface
is not ideal for many of them, and that providing a simpler interface
would help.

Thanks,
NeilBrown

