Return-Path: <kvm+bounces-40533-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 86F4EA58991
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 01:11:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6A7063AB176
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 00:11:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F9CEDDBC;
	Mon, 10 Mar 2025 00:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="KDwNqFoQ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="CKCBvC+q";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="KDwNqFoQ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="CKCBvC+q"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B4C2BA3D
	for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 00:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741565480; cv=none; b=oWgmMXV8W/AVo6EtWwl3JmVfaM/3O8Ig6jG9diHL5d1Mw5sdhJH7nhugRqeZrAnTqB2IICdXt2ct/bjPdF7+SznITtFnODOJuJX27xrs122vpg76lq8sqTHG7hiXWPv+djMwqZYNdjykQh30vhOHUNgkOUDrTQk22pbA1aE7acY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741565480; c=relaxed/simple;
	bh=DG5VusSpng1Zw3Y9FQqDzYGxaM6OXVuK7yrTuyG2hko=;
	h=Content-Type:MIME-Version:From:To:Cc:Subject:In-reply-to:
	 References:Date:Message-id; b=hZ1y+KFlpJG/eNay7sn3Yv6grqklGSug6gAC0NliKoGm3txoLWj1Fl+kwWa8SKVnOWL4M0uhd0mMSmIRkEViKw0BBKrDHOoIVEfzkF2dF4TjpFvn61ykALrDJTokB4ZPbDPxwYofJ8+bq1UsIxTgqiJzegP/ZdnunrpgfjZMqjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=KDwNqFoQ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=CKCBvC+q; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=KDwNqFoQ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=CKCBvC+q; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 37A3D21165;
	Mon, 10 Mar 2025 00:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1741565470; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VKyzFF9sqmXYhDyE0Ctknq3rDxkaHE2kfW5qcx4F3Vw=;
	b=KDwNqFoQ1OfaFxm4+cFRAPQG/9lynj1ynPLvXyUtW/eDH0KUuIYqPg5O72cpxP/Zk1C/Y+
	mehlBAkI9r02PjZFfCVLIG6S//j5OTq2c8ulSv29hm21UuGi+iN+usKAhsqGTGV0XBYiJa
	mmhD6HUTTzVjz6QdBRenk6UuDxAESdM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1741565470;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VKyzFF9sqmXYhDyE0Ctknq3rDxkaHE2kfW5qcx4F3Vw=;
	b=CKCBvC+qBGhb131WpP1iP4N9DXwY1T6wcW+5i8EpcqALKXBl5exCvK3fTYcuJC9NtT9axO
	1sE6tGKLUorcLgAw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=KDwNqFoQ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=CKCBvC+q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1741565470; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VKyzFF9sqmXYhDyE0Ctknq3rDxkaHE2kfW5qcx4F3Vw=;
	b=KDwNqFoQ1OfaFxm4+cFRAPQG/9lynj1ynPLvXyUtW/eDH0KUuIYqPg5O72cpxP/Zk1C/Y+
	mehlBAkI9r02PjZFfCVLIG6S//j5OTq2c8ulSv29hm21UuGi+iN+usKAhsqGTGV0XBYiJa
	mmhD6HUTTzVjz6QdBRenk6UuDxAESdM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1741565470;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VKyzFF9sqmXYhDyE0Ctknq3rDxkaHE2kfW5qcx4F3Vw=;
	b=CKCBvC+qBGhb131WpP1iP4N9DXwY1T6wcW+5i8EpcqALKXBl5exCvK3fTYcuJC9NtT9axO
	1sE6tGKLUorcLgAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 22EDB139E7;
	Mon, 10 Mar 2025 00:10:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id vGLtMQ8uzmfhQQAAD6G6ig
	(envelope-from <neilb@suse.de>); Mon, 10 Mar 2025 00:10:55 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: "NeilBrown" <neilb@suse.de>
To: "Yunsheng Lin" <yunshenglin0825@gmail.com>
Cc: "Yunsheng Lin" <linyunsheng@huawei.com>, "Qu Wenruo" <wqu@suse.com>,
 "Yishai Hadas" <yishaih@nvidia.com>, "Jason Gunthorpe" <jgg@ziepe.ca>,
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
In-reply-to: <7abb0e8c-f565-48f0-a393-8dabbabc3fe2@gmail.com>
References: <>, <7abb0e8c-f565-48f0-a393-8dabbabc3fe2@gmail.com>
Date: Mon, 10 Mar 2025 11:10:48 +1100
Message-id: <174156544867.33508.5386967459254083056@noble.neil.brown.name>
X-Rspamd-Queue-Id: 37A3D21165
X-Spam-Score: -4.51
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FREEMAIL_TO(0.00)[gmail.com];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[45];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[huawei.com,suse.com,nvidia.com,ziepe.ca,intel.com,redhat.com,fb.com,toxicpanda.com,kernel.org,gmail.com,linux.alibaba.com,google.com,linux-foundation.org,linaro.org,davemloft.net,oracle.com,talpey.com,techsingularity.net,fromorbit.com,vger.kernel.org,lists.linux.dev,lists.ozlabs.org,kvack.org];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:25478, ipnet:::/0, country:RU];
	DKIM_TRACE(0.00)[suse.de:+];
	R_RATELIMIT(0.00)[from(RLewrxuus8mos16izbn),to_ip_from(RLodizb9et8yqpuyyezexhwnjp)];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Level: 

On Mon, 10 Mar 2025, Yunsheng Lin wrote:
> On 3/8/2025 5:02 AM, NeilBrown wrote:
>=20
> ...
>=20
> >>
> >>>    allocated pages in the array - just like the current
> >>>    alloc_pages_bulk().
> >>
> >> I guess 'the total number of allocated pages in the array ' include
> >> the pages which are already in the array before calling the above
> >> API?
> >=20
> > Yes - just what the current function does.
> > Though I don't know that we really need that detail.
> > I think there are three interesting return values:
> >=20
> > - hard failure - don't bother trying again soon:   maybe -ENOMEM
> > - success - all pages are allocated:  maybe 0 (or 1?)
> > - partial success - at least one page allocated, ok to try again
> >    immediately - maybe -EAGAIN (or 0).
>=20
> Yes, the above makes sense. And I guess returning '-ENOMEM' & '0' &
> '-EAGAIN' seems like a more explicit value.
>=20
> >=20
> >>
>=20
> ...
>=20
> >>
> >=20
> > If I were do work on this (and I'm not, so you don't have to follow my
> > ideas) I would separate the bulk_alloc into several inline functions and
> > combine them into the different interfaces that you want.  This will
> > result in duplicated object code without duplicated source code.  The
> > object code should be optimal.
>=20
> Thanks for the detailed suggestion, it seems feasible.
> If the 'add to a linked list' dispose was not removed in the [1],
> I guess it is worth trying.
> But I am not sure if it is still worth it at the cost of the above
> mentioned 'duplicated object code' considering the array defragmenting
> seem to be able to unify the dispose of 'add to end of array' and
> 'add to next hole in array'.
>=20
> I guess I can try with the easier one using array defragmenting first,
> and try below if there is more complicated use case.

Your post observes a performance improvement - slight though it is.
I might be worth measuring the performance change for a case that
requires defragmenting to see how that compares.

Thanks,
NeilBrown


>=20
> 1.=20
> https://lore.kernel.org/all/f1c75db91d08cafd211eca6a3b199b629d4ffe16.173499=
1165.git.luizcap@redhat.com/
>=20
> >=20
> > The parts of the function are:
> >   - validity checks - fallback to single page allocation
> >   - select zone - fallback to single page allocation
> >   - allocate multiple pages in the zone and dispose of them
> >   - allocate a single page
> >=20
> > The "dispose of them" is one of
> >    - add to a linked list
> >    - add to end of array
> >    - add to next hole in array
> >=20
> > These three could be inline functions that the "allocate multiple pages"
> > and "allocate single page" functions call.  We can pass these as
> > function arguments and the compile will inline them.
> > I imagine these little function would take one page and return
> > a bool indicating if any more are wanted.
> >=20
> > The three functions: alloc_bulk_array alloc_bulk_list
> > alloc_bulk_refill_array would each look like:
> >=20
> >    validity checks: do we need to allocate anything?
> >=20
> >    if want more than one page &&
> >       am allowed to do mulipage (e.g. not __GFP_ACCOUNT) &&
> >       zone =3D choose_zone() {
> >          alloc_multi_from_zone(zone, dispose_function)
> >    }
> >    if nothing allocated
> >       alloc_single_page(dispose_function)
> >=20
> > Each would have a different dispose_function and the initial checks
> > would be quite different, as would the return value.
> >=20
> > Thanks for working on this.
> >=20
> > NeilBrown
> >=20
>=20
>=20


