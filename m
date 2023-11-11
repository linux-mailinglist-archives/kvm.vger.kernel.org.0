Return-Path: <kvm+bounces-1518-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 76FF67E8BE2
	for <lists+kvm@lfdr.de>; Sat, 11 Nov 2023 18:31:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1F7D81F20F38
	for <lists+kvm@lfdr.de>; Sat, 11 Nov 2023 17:31:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D81521BDEB;
	Sat, 11 Nov 2023 17:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ceFnn4yv"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA3E41BDC6
	for <kvm@vger.kernel.org>; Sat, 11 Nov 2023 17:30:53 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E9B0387F
	for <kvm@vger.kernel.org>; Sat, 11 Nov 2023 09:30:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699723851;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SlloNaZmXVnj1HpScqTIiGT52J7jFfZ9eVP+i1k2+Ug=;
	b=ceFnn4yvKptQ/f8sjy6BqAg413GE/Y+OtvLUTGKfKhZnwvAmKZ2A4hZqgnAy/+Wai5Xi5V
	Ne2R3kfEDgX8u2fNrJWySFf5lnueEpTaxoTmZ5FBOlfqjyHrz6VsXOBfOe2vlKi+jGD4Wj
	PpPPNx/qDwgQGxebZD/vPU6p0auRiAg=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-294-4XbT1NZbPi6Mn19UyVFILA-1; Sat, 11 Nov 2023 12:30:49 -0500
X-MC-Unique: 4XbT1NZbPi6Mn19UyVFILA-1
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-41cbafdb4b6so4927411cf.0
        for <kvm@vger.kernel.org>; Sat, 11 Nov 2023 09:30:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699723849; x=1700328649;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SlloNaZmXVnj1HpScqTIiGT52J7jFfZ9eVP+i1k2+Ug=;
        b=uihY7AiQhUEHYTJxr5TBX8NBTFWWl6kRq3BM3Qq4yvXxfGlMqVBpJXa4FHXQXVuaZu
         evPGPqi1jNnWB+PuU1L0EowBDnvwNBNR6lg7vIe8b3tLAkQxDghzxRpfb7SDtzyZXH59
         FUNzBVjvCITqcbtSu9DwLvv8xoW73/+zqq4HbuJRaayjfRSA0syLfCWy0mTgaZJB8Ui1
         73hxoTsLG2iZzeBUE5+2XltgUfOW4xMQ1A5VQ2AXSF2Jx5n9/oIlM/ShwGhxtkfDUlIl
         ttguH2hy1tSkixfSdqAew6Q118Y1mYYxcG7LO0o+eFJW53dvu/J10utyYAB2N9191xsK
         +saw==
X-Gm-Message-State: AOJu0YwtxsvGhP/Du+4gUtcIPvgxRpp/F6OFRJJ7LJFvECBc2tIp2hAm
	9XsYDOBr/ppY5zhlZCG6Kh5grLYrNxnWby1sIMJGmBhLitPTAKuqMdyC99ochxx8BEKEP5d5fH6
	fgni1muDlVqXO
X-Received: by 2002:a05:622a:648:b0:412:d46:a8c3 with SMTP id a8-20020a05622a064800b004120d46a8c3mr3187451qtb.2.1699723848781;
        Sat, 11 Nov 2023 09:30:48 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHDVkvRJMqVlNnPYzwOfGo0Ztq5G4f0R61tnhBH6qijjCtIt5O9jB1tgCZ+X9QpEZB21gXmHg==
X-Received: by 2002:a05:622a:648:b0:412:d46:a8c3 with SMTP id a8-20020a05622a064800b004120d46a8c3mr3187431qtb.2.1699723848414;
        Sat, 11 Nov 2023 09:30:48 -0800 (PST)
Received: from xz-m1.local (cpe5c7695f3aee0-cm5c7695f3aede.cpe.net.cable.rogers.com. [99.254.144.39])
        by smtp.gmail.com with ESMTPSA id b26-20020ac8755a000000b004166905aa2asm629586qtr.28.2023.11.11.09.30.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Nov 2023 09:30:47 -0800 (PST)
Date: Sat, 11 Nov 2023 12:30:46 -0500
From: Peter Xu <peterx@redhat.com>
To: David Matlack <dmatlack@google.com>
Cc: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, kvm list <kvm@vger.kernel.org>,
	James Houghton <jthoughton@google.com>,
	Oliver Upton <oupton@google.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: RFC: A KVM-specific alternative to UserfaultFD
Message-ID: <ZU+6RhTTWgSx7Juo@xz-m1.local>
References: <CALzav=d23P5uE=oYqMpjFohvn0CASMJxXB_XEOEi-jtqWcFTDA@mail.gmail.com>
 <ZUlLLGLi1IyMyhm4@x1n>
 <fcef7c96-a1bb-4c1d-962b-1bdc2a3b4f19@redhat.com>
 <ZUq6LJ+YppFlf43f@x1n>
 <CALzav=d_ZyNGmh0086c8D+arjb6NPABEuOGL=aj3DzhKJ12Vmw@mail.gmail.com>
 <ZU0d2fq5zah5jxf1@google.com>
 <ZU0xCwvkKcpzBwc-@x1n>
 <CALzav=dyURZ=BOWzsYA8ruSWd3vgPQqxztHURWEUYPvOK=w4Yw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALzav=dyURZ=BOWzsYA8ruSWd3vgPQqxztHURWEUYPvOK=w4Yw@mail.gmail.com>

On Sat, Nov 11, 2023 at 08:23:57AM -0800, David Matlack wrote:
> On Thu, Nov 9, 2023 at 11:20 AM Peter Xu <peterx@redhat.com> wrote:
> > On Thu, Nov 09, 2023 at 09:58:49AM -0800, Sean Christopherson wrote:
> > >
> > > For both cases, KVM will need choke points on all accesses to guest memory.  Once
> > > the choke points exist and we have signed up to maintain them, the extra burden of
> > > gracefully handling "missing" memory versus frozen memory should be relatively
> > > small, e.g. it'll mainly be the notify-and-wait uAPI.
> > >
> > > Don't get me wrong, I think Google's demand paging implementation should die a slow,
> > > horrible death.   But I don't think userfaultfd is the answer for guest_memfd.
> >
> > As I replied in the other thread, I see possibility implementing
> > userfaultfd on gmemfd, especially after I know your plan now treating
> > user/kernel the same way.
> >
> > But I don't know whether I could have missed something here and there, and
> > I'd like to read the problem first on above to understand the relationship
> > between that "freeze guest mem" idea and the demand paging scheme.
> >
> > One thing I'd agree is we don't necessarily need to squash userfaultfd into
> > gmemfd support of demand paging.  If gmemfd will only be used in KVM
> > context then indeed it at least won't make a major difference; but still
> > good if the messaging framework can be leveraged, meanwhile userspace that
> > already support userfaultfd can cooperate with gmemfd much easier.
> >
> > In general, a major part of userfaultfd is really a messaging interface for
> > faults to me.  A fault trap mechanism will be needed anyway for gmemfd,
> > AFAIU. When that comes maybe we can have a clearer mind of what's next.
> 
> The idea to re-use userfaultfd as a notification mechanism is really
> interesting.
> 
> I'm almost certain that guest page faults on missing pages can re-use
> the KVM_CAP_EXIT_ON_MISSING UAPI that Anish is adding for UFFD [1]. So
> that will be the same between VMA-based UserfaultFD and
> KVM/guest_memfd-based demand paging.

Right.  I think we may need to decide whether to use the same interface to
handle no-vcpu contexts, though, and whether possible (e.g. is reusing
vcpu0 even possible?  if not consider ugliness).  For example, Anish's
proposal still need to rely on userfaults for some minority faults, IIUC.

> 
> And for the blocking notification in KVM, re-using the userfaultfd
> file descriptor seems like a neat idea. We could have a KVM ioctl to
> register the fd with KVM, and then KVM can notify when it needs to
> block on a missing page. The uffd_msg struct can be extended to
> support a new "gfn" type or "guest_memfd" type fault info. I'm not
> quite sure how the wait-queuing will work, but I'm sure it's solvable.

If so, IMHO it'll be great the interface is userfault-based.  Gmemfd can be
only a special form of memfd in general, and there's also potential of
supporting memfd, then that may not require a kvm context.

It hopefully shouldn't affect how kvm consumes it, though, so from that
part it should be as straightforward as a KVM interface, just cleaner and
fully separated.

I can extend a bit on a possible userfault design, maybe it can make the
discussion clearer.

Currently userfaults registers with VA ranges, cutting them into new VMAs,
setting the flags upon the VMAs.  Files don't have those.

To vision an fd based uffd (which never existed) from my pure gut feelings,
we need to only move the VA address space to the file (or to be explicit,
inode), meaning whatever address will become offsets of a file.  It can
apply to gmemfd or generic memfd (shmem, hugetlb, etc.).  Generic memfd can
be for later, but the interface could hopefully be unchanged even if
someone would like to add support for those.

I need to think more on where to put the uffd context, probably onto the
inode, but maybe also possible to put it into gmemfd-only fields before we
want to make it more generic.  That should be a problem for later.

It could be something like ioctl(UFFDIO_REGISTER_FD) to register a normal
memory fd (gmemfd) against an userfault desc.  AFAIU it may not even
require a range of file offset to register, we can start with always
registering the file on full range, whatever large it is (0->fsize, fsize
under control of normal file/inode semantics).

It means gmemfd code will still need to check the fsize limit on over
file-size access, as long as it passes and if it's registered with UFFD-fd
mode, it reports the fault just like VMA based, but in file offset this
time.  The file-size will need to be rechecked when injecting the page
cache, failing on both sides.

We'll need correspondent new ioctl for file, say, ioctl(UFFDIO_INSERT),
which fills in the mapping entry / page cache only for the inode without
touching any pgtables.  The kicking stuff is the same as VMA-based.

> With these 2 together, the UAPI for notifying userspace would be the
> same for UserfaultFD and KVM.
> 
> As for whether to integrate the "missing" page support in guest_memfd
> or KVM... I'm obviously partial to the latter because then Google can
> also use it for HugeTLB.

Right, hugetlb 1G is still the major pain, and we can indeed resolve that
with a kvm proposal to bypass whatever issues lies in mm community, even if
not something I prefer..  I sincerely hope we can see some progress on that
side, if possible.

> 
> But now that I think about it, isn't the KVM-based approach useful to
> the broader community as well? For example, QEMU could use the
> KVM-based demand paging for all KVM-generated accesses to guest
> memory. This would provide 4K-granular demand paging for _most_ memory
> accesses. Then for vhost and userspace accesses, QEMU can set up a
> separate VMA mapping of guest memory and use UserfaultFD. The
> userspace/vhost accesses would have to be done at the huge page size
> granularity (if using HugeTLB). But most accesses should still come
> from KVM, so this would be a real improvement over a pure UserfaultFD
> approach.

I fully understand why you propose that, but not the one I prefer.  That
means KVM is leaving other modules behind. :( And that's not even the same
as the case where KVM wants to resolve hugetlb over 1G, because at least we
tried :) it's just that the proposal got rejected, unfortunately, so far.

IMHO we should still consider virt the whole community, not KVM separately,
even if KVM is indeed a separate module.

If we still have any form of 1G problem (including dma, in the case of
vhost), IMHO the VM still cannot be declared usable over 1G.  This
"optimization" is not solving the problem if not considering the rest.

So if we're going to propose the new solution to replace userfault, I'd
rather we add support separately for everything at least still public, even
if it'll take more work, comparing to make it kvm-only.

> 
> And on the more practical side... If we integrate missing page support
> directly into guest_memfd, I'm not sure how one part would even work.
> Userspace would need a way to write to missing pages before marking
> them present. So we'd need some sort of special flag to mmap() to
> bypass the missing page interception? I'm sure it's solvable, but the
> KVM-based does not have this problem.

Userfaults rely on the temp buffer.  Take UFFDIO_COPY as an example,
uffdio_copy.src|len describes that. Then the kernel does the atomicity
work.

I'm not sure why KVM-based doesn't have that problem.  IIUC it'll be the
same?  We can't make the folio present in the gmemfd mapping if it doesn't
yet contain full data copied over.  Having a special flag for the mapping
is fine for each folio to allow different access permissions looks also
fine, but that sounds like over complicated to me.

Thanks,

-- 
Peter Xu


