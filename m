Return-Path: <kvm+bounces-49434-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 676EBAD904C
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 16:56:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2AE6717AB3E
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 14:56:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F84E1E520E;
	Fri, 13 Jun 2025 14:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="mc1Kidky";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="rV1/nDbr";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="mc1Kidky";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="rV1/nDbr"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87C781E1A05
	for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 14:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749826517; cv=none; b=J5bzBj3ztvgYygUj/rj0PLEBB38koIeeoDwiCSZfGZP6dAVjO6TlMOLHRVv3wapuknyfFiYd8cRm9GrMKJV8SriTQMjp0ux+C2SoLLRY1QHn4pW4CQS+uUGzrQ/OagemYhZVwi0W8U7f6E6vSzVO8WgbYN/wAAmf8Bb92AqJEfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749826517; c=relaxed/simple;
	bh=K0j0E8X+BOXpIkz8/efXSUghnYgg2ZTydyaS55DiavU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L0RwTSf3qHzZtuN1Wca3IUCRKNI2ik9x/mN7J9XXgPu8J/IP5O3mtbVSoWweeRhzyVu0S1FfRAei+o31TJV8fU9e1HkwJ4qm0W7ww3PpRcS9ayBfOrt04MH+vyjlHygOH7NUmEQr8OhVpdKoR5RmXoRSKmpWsBMM3lJblNMvA4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=mc1Kidky; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=rV1/nDbr; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=mc1Kidky; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=rV1/nDbr; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9761921277;
	Fri, 13 Jun 2025 14:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1749826512; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FOnvCgK+PK9koup8uKcxrwLNBHe5Jf9Dmp3a7AAYPcw=;
	b=mc1Kidky6r1X2w5CReXCrzhMoDhAltOUwPKm/sIJGmJAclwtCyisx2YZsflcirij6AxxVr
	EXIoAs9H0rtXJ/m8JXfMTNcyYtpyoW4EHL9P2pEh7WjtfSutjgJOofND+2UlFPkF9CQBZk
	uslqm7q31v3ZM5eTzi4QNdqlz+6ce2w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1749826512;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FOnvCgK+PK9koup8uKcxrwLNBHe5Jf9Dmp3a7AAYPcw=;
	b=rV1/nDbrK8dkR7K4eWNT/xpR2kjtruA5HFyKiApL0gMffawry4StOB+Cyl1bYGfqrFXkHE
	RT4150X4uZJEr0Ag==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=mc1Kidky;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="rV1/nDbr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1749826512; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FOnvCgK+PK9koup8uKcxrwLNBHe5Jf9Dmp3a7AAYPcw=;
	b=mc1Kidky6r1X2w5CReXCrzhMoDhAltOUwPKm/sIJGmJAclwtCyisx2YZsflcirij6AxxVr
	EXIoAs9H0rtXJ/m8JXfMTNcyYtpyoW4EHL9P2pEh7WjtfSutjgJOofND+2UlFPkF9CQBZk
	uslqm7q31v3ZM5eTzi4QNdqlz+6ce2w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1749826512;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FOnvCgK+PK9koup8uKcxrwLNBHe5Jf9Dmp3a7AAYPcw=;
	b=rV1/nDbrK8dkR7K4eWNT/xpR2kjtruA5HFyKiApL0gMffawry4StOB+Cyl1bYGfqrFXkHE
	RT4150X4uZJEr0Ag==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 032DF13782;
	Fri, 13 Jun 2025 14:55:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 7tC/Oc87TGhXHwAAD6G6ig
	(envelope-from <osalvador@suse.de>); Fri, 13 Jun 2025 14:55:11 +0000
Date: Fri, 13 Jun 2025 16:55:10 +0200
From: Oscar Salvador <osalvador@suse.de>
To: Peter Xu <peterx@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Zi Yan <ziy@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>,
	Alex Mastro <amastro@fb.com>, David Hildenbrand <david@redhat.com>,
	Nico Pache <npache@redhat.com>
Subject: Re: [PATCH 1/5] mm: Deduplicate mm_get_unmapped_area()
Message-ID: <aEw7zkwNAc4aGnqe@localhost.localdomain>
References: <20250613134111.469884-1-peterx@redhat.com>
 <20250613134111.469884-2-peterx@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250613134111.469884-2-peterx@redhat.com>
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 9761921277
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCPT_COUNT_SEVEN(0.00)[11];
	MIME_TRACE(0.00)[0:+];
	MISSING_XM_UA(0.00)[];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:email];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Score: -4.51
X-Spam-Level: 

On Fri, Jun 13, 2025 at 09:41:07AM -0400, Peter Xu wrote:
> Essentially it sets vm_flags==0 for mm_get_unmapped_area_vmflags().  Use
> the helper instead to dedup the lines.
> 
> Signed-off-by: Peter Xu <peterx@redhat.com>

Reviewed-by: Oscar Salvador <osalvador@suse.de>


-- 
Oscar Salvador
SUSE Labs

