Return-Path: <kvm+bounces-69785-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ls9pEk2hf2lkuwIAu9opvQ
	(envelope-from <kvm+bounces-69785-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sun, 01 Feb 2026 19:54:05 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 90E6FC6FE7
	for <lists+kvm@lfdr.de>; Sun, 01 Feb 2026 19:54:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D122D3006148
	for <lists+kvm@lfdr.de>; Sun,  1 Feb 2026 18:53:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0092B299AB4;
	Sun,  1 Feb 2026 18:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="qo9ZmCh6"
X-Original-To: kvm@vger.kernel.org
Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 117F6291864
	for <kvm@vger.kernel.org>; Sun,  1 Feb 2026 18:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769972035; cv=none; b=kwCAEqNLIXgnB7AQf/ONkV7vqWmfVHrXrI0LTNE7xTbOVoftWvHLpH7JyrfVvv4LVi7XzuA1G/IefUTkZzRulLbzSvi3xZfI0ofaJwhWHV0RV9n6b39VL4Fx94e+J0J9m4WUxefI0YAHsrzuOdY6Nz6Is21qJsuF0j0dInyfLMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769972035; c=relaxed/simple;
	bh=+oDdqL0fZiO49y4mBB6nz7Lzzq/F6Iys/EL2l/1+/S0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h/eYSfGhnECB2/Q9Y4qTksgwm/Ktlau4W6MxBrwfEGbY/9YVDkxTOteL/I+lthRB2IjdghBtWwgc1QqVws7DAYVO/Mpb1fQdmEbEjOSdgqCJZ0DbrKQbH4Sq3KzHh13ux9KJ6MatWAYQJx3TYCV9wdcJv8f86vTqoyyC96vdbDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=qo9ZmCh6; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=Content-Type:MIME-Version:Message-ID:Subject:From:Date:From
	:Subject; bh=pgPtNcSzNF/zPIvJDvRpWF3W2Scxdp/0c7R2KRW9haE=; b=qo9ZmCh6zbjFTpbq
	Xc2hfzSdLKdPrUPMzSI3oknE3z1Fe4N0GHRK/XCtGR/K8EvoTVRrxo8juUtz4rW3xBjCWeg9bYJ4i
	jOjpIfzM3hBDCj9hqByEd9RbpGbMNfaGJgBauwgytpOyuQ21fSrmu9suzdF/7vQYg6AW7NZkUZ1zU
	+XBQafZqK2rnRTvC5EWZITAXfvFGf7xJgjY5qC1eE05LPcadkylZ7oOgJeY46J1G2b8s6+DpTN2It
	JICWyOHxsGTUPNwgtknzrgDqanjEZuljskFDCARinkoNPvpKl+9YKw9oHMchbEqE0lqyPvjfgwyKw
	h4TpoKkI5kzUbyvmlg==;
Received: from dg by mx.treblig.org with local (Exim 4.98.2)
	(envelope-from <dg@treblig.org>)
	id 1vmcCn-0000000137z-2Bd0;
	Sun, 01 Feb 2026 18:29:53 +0000
Date: Sun, 1 Feb 2026 18:29:53 +0000
From: "Dr. David Alan Gilbert" <dave@treblig.org>
To: Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>
Cc: Fabiano Rosas <farosas@suse.de>, Markus Armbruster <armbru@redhat.com>,
	=?iso-8859-1?Q?Marc-Andr=E9?= Lureau <marcandre.lureau@redhat.com>,
	Stefan Hajnoczi <stefanha@gmail.com>,
	qemu-devel <qemu-devel@nongnu.org>, kvm <kvm@vger.kernel.org>,
	Helge Deller <deller@gmx.de>, Oliver Steffen <osteffen@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Matias Ezequiel Vara Larsen <mvaralar@redhat.com>,
	Kevin Wolf <kwolf@redhat.com>,
	German Maglione <gmaglione@redhat.com>,
	Hanna Reitz <hreitz@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>,
	Thomas Huth <thuth@redhat.com>,
	Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
	Alex Bennee <alex.bennee@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: Re: Modern HMP
Message-ID: <aX-boauFX2Ju7x8Z@gallifrey>
References: <CAJSP0QVXXX7GV5W4nj7kP35x_4gbF2nG1G1jdh9Q=XgSx=nX3A@mail.gmail.com>
 <CAMxuvaz8hm1dc6XdsbK99Ng5sOBNxwWg_-UJdBhyptwgUYjcrw@mail.gmail.com>
 <871pjigf6z.fsf_-_@pond.sub.org>
 <aXH1ECZ1Nchui9ED@redhat.com>
 <87ikctg8a8.fsf@pond.sub.org>
 <aXIWLi656H8VbrPE@redhat.com>
 <87ikctk5ss.fsf@suse.de>
 <aXJJkd8g0AGZ3EVv@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aXJJkd8g0AGZ3EVv@redhat.com>
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/6.12.48+deb13-amd64 (x86_64)
X-Uptime: 18:25:58 up 97 days, 18:02,  4 users,  load average: 0.00, 0.01,
 0.00
User-Agent: Mutt/2.2.13 (2024-03-09)
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	FROM_NAME_HAS_TITLE(1.00)[dr];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[treblig.org,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64];
	R_DKIM_ALLOW(-0.20)[treblig.org:s=bytemarkmx];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-69785-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[treblig.org:+];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dave@treblig.org,kvm@vger.kernel.org];
	FREEMAIL_CC(0.00)[suse.de,redhat.com,gmail.com,nongnu.org,vger.kernel.org,gmx.de,linaro.org,ilande.co.uk];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_TWELVE(0.00)[20];
	DBL_BLOCKED_OPENRESOLVER(0.00)[treblig.org:url,treblig.org:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 90E6FC6FE7
X-Rspamd-Action: no action

* Daniel P. Berrangé (berrange@redhat.com) wrote:
> On Thu, Jan 22, 2026 at 12:47:47PM -0300, Fabiano Rosas wrote:
> > One question I have is what exactly gets (eventually) removed from QEMU
> > and what benefits we expect from it. Is it the entire "manual"
> > interaction that's undesirable? Or just that to maintain HMP there is a
> > certain amount of duplication? Or even the less-than-perfect
> > readline/completion aspects?
> 
> Over time we've been gradually separating our human targetted code from
> our machine targetted code, whether that's command line argument parsing,
> or monitor parsing. Maintaining two ways todo the same thing is always
> going to be a maint burden, and in QEMU it has been especially burdensome
> as they were parallel impls in many cases, rather than one being exclusively
> built on top of the other.
> 
> Even today we still get contributors sending patches which only impl
> HMP code and not QMP code. Separating HMP fully from QMP so that it
> was mandatory to create QMP first gets contributors going down the
> right path, and should reduce the burden on maint.

Having a separate HMP isn't a bad idea - but it does need some idea of
how to make it easy for contributors to add stuff that's just for debug
or for the dev.   For HMP the bar is very low; if it's useful to the
dev, why not (unless it's copying something that's already in the QMP interface
in a different way);  but although the x- stuff in theory lets
you add something via QMP, in practice it's quite hard to get it through
review without a lot of QMP design bikeshedding.

Dave

-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    |       Running GNU/Linux       | Happy  \ 
\        dave @ treblig.org |                               | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/

