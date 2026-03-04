Return-Path: <kvm+bounces-72703-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iPAXOENkqGl3uQAAu9opvQ
	(envelope-from <kvm+bounces-72703-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 17:56:35 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4926D204B47
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 17:56:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 85E5C301E3FC
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2026 16:53:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6ACCF377EA2;
	Wed,  4 Mar 2026 16:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p8cv67e9"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2862B376BC4;
	Wed,  4 Mar 2026 16:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772643211; cv=none; b=iP+jCYiJ6rvn0OfCF7Z02cSQCz9DrMu9Thos6iCHQ3zKXDVdJNl/vR6LAeDcV5RAzqGS3Rex3l2IaNI2dyLSYxATfJ5vXjEb1z36p3Yl9Wx7OZ37+DY22vWzLn1AKrF1Oyn0mCTZ3M1/Osr3HdFEeF0p/7LnId665mE01Io0Yk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772643211; c=relaxed/simple;
	bh=sDB+az1bAXOGbWMmUUUu0SDGfeabr+ekuNO1hj8thSQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W84VKA6I1dR+vTSiB1OniP6BNr5xQJ+diu4tdZBxED1wcFDdBfFSpaPSfPkggXCXVsdsin20/BMfw/mLW0mLCPJJS0+in71u0J7MxIQ6yQET+qJ3th43kj6kgkcvaPIdB8LIWZ50qn4DEFCqaocEpTv1xnVnreaHGBbSNXv1OZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p8cv67e9; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E293FC4CEF7;
	Wed,  4 Mar 2026 16:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772643210;
	bh=sDB+az1bAXOGbWMmUUUu0SDGfeabr+ekuNO1hj8thSQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=p8cv67e9ssUeWrFJGzAnKEG//LYmeqoUbvIrlKriZR7tjoP6HIKPNDX8pAccTwBH3
	 kXINSbiaDo1xDJrz/JeaCLaBaVqAnxS7nhEA2lvzOiuDnxxjG11JLenaxDm+s3Lxj2
	 gBLGMkVgja0Q4hASgoNQuIwIlGSxpW6FrxNNdPNh4/g6M+m2IOlHz4cIUNw50qQg28
	 S1E1hSZaFUqKAdRvL5ekKo6FKeATDlnWWE64vY5pnnLHk4JSh7QwNEnHPKQCu7T+j6
	 PIJ1RxF0irx8ZP6DGic6mucNZ5qkVhr+BkuZBSZI1pTlvap4lmikyHjbTLgwLSHuAZ
	 l9ami0VnilBOQ==
Date: Wed, 4 Mar 2026 16:53:27 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, akpm@linux-foundation.org, david@kernel.org, ziy@nvidia.com, 
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com, 
	gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com, 
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, vbabka@suse.cz, 
	jannh@google.com, rppt@kernel.org, mhocko@suse.com, pfalcato@suse.de, 
	kees@kernel.org, maddy@linux.ibm.com, npiggin@gmail.com, mpe@ellerman.id.au, 
	chleroy@kernel.org, borntraeger@linux.ibm.com, frankja@linux.ibm.com, 
	imbrenda@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com, 
	svens@linux.ibm.com, gerald.schaefer@linux.ibm.com, linux-mm@kvack.org, 
	linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-s390@vger.kernel.org, "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Subject: Re: [PATCH v3 2/3] mm: replace vma_start_write() with
 vma_start_write_killable()
Message-ID: <76aff8f9-1c08-449a-a034-f3b93440d1a8@lucifer.local>
References: <20260226070609.3072570-1-surenb@google.com>
 <20260226070609.3072570-3-surenb@google.com>
 <74bffc7a-2b8c-40ae-ab02-cd0ced082e18@lucifer.local>
 <CAJuCfpHBfhKFeWAtQo4r-ofVtO=5MvG+OToEgc2DEY+cuZDSGw@mail.gmail.com>
 <aadeHiMqhHF0EQkt@casper.infradead.org>
 <CAJuCfpFB1ON8=rkqu3MkrbD2mVBeHLK4122nm9RH31fH3hT2Hw@mail.gmail.com>
 <aael1XWaOJN134la@casper.infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aael1XWaOJN134la@casper.infradead.org>
X-Rspamd-Queue-Id: 4926D204B47
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72703-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[google.com,oracle.com,linux-foundation.org,kernel.org,nvidia.com,intel.com,gmail.com,sk.com,gourry.net,linux.alibaba.com,redhat.com,arm.com,linux.dev,suse.cz,suse.com,suse.de,linux.ibm.com,ellerman.id.au,kvack.org,lists.ozlabs.org,vger.kernel.org];
	RCPT_COUNT_TWELVE(0.00)[44];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ljs@kernel.org,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,lucifer.local:mid,infradead.org:email,oracle.com:email]
X-Rspamd-Action: no action

On Wed, Mar 04, 2026 at 03:24:05AM +0000, Matthew Wilcox wrote:
> On Tue, Mar 03, 2026 at 04:02:50PM -0800, Suren Baghdasaryan wrote:
> > On Tue, Mar 3, 2026 at 2:18 PM Matthew Wilcox <willy@infradead.org> wrote:
> > >
> > > On Tue, Mar 03, 2026 at 02:11:31PM -0800, Suren Baghdasaryan wrote:
> > > > On Mon, Mar 2, 2026 at 6:53 AM Lorenzo Stoakes
> > > > <lorenzo.stoakes@oracle.com> wrote:
> > > > > Overall I'm a little concerned about whether callers can handle -EINTR in all
> > > > > cases, have you checked? Might we cause some weirdness in userspace if a syscall
> > > > > suddenly returns -EINTR when before it didn't?
> > > >
> > > > I did check the kernel users and put the patchset through AI reviews.
> > > > I haven't checked if any of the affected syscalls do not advertise
> > > > -EINTR as a possible error. Adding that to my todo list for the next
> > > > respin.
> > >
> > > This only allows interruption by *fatal* signals.  ie there's no way
> > > that userspace will see -EINTR because it's dead before the syscall
> > > returns to userspace.  That was the whole point of killable instead of
> > > interruptible.
> >
> > Ah, I see. So, IIUC, that means any syscall can potentially fail with
> > -EINTR and this failure code doesn't need to be documented. Is that
> > right?
>
> We could literally return any error code -- it never makes it to
> userspace.  I forget where it is, but if you follow the syscall
> return to user path, a dying task never makes it to running a single
> instruction.

Thanks for that Matthew, that makes life easier then.

We can probably replace some of the more horrid if (err == -EINTR) stuff with
fatal_signal_pending(current) to be clearer as a result.

Cheers, Lorenzo

