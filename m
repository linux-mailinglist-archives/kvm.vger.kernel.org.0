Return-Path: <kvm+bounces-891-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 71D057E41BD
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 15:22:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0243DB20E23
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 14:22:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 137EE30FBA;
	Tue,  7 Nov 2023 14:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Dj28b8Hi"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA3A98F5B
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 14:22:21 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB150C1
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 06:22:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699366939;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kLVHjLQFNZM1R0nYZqPiujbYlWwyXgBaHuNRoop7EPA=;
	b=Dj28b8HiLNh80D90HqLJmx7WIpe/w7VUB3zqkI8SJ+gRBJIlQ/oRc4o4kBIATtdFD7OcAt
	YNl/WpkYRMFDyZnojvq6FwhIupv8LLpU2V8I/71TXagf8YAbwLJHd307w5DLqFkzrAIovK
	Re7yMnJJG/7q2ujlybJCHC1zKsll/6w=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-340-375zLsf0MAWZSrXKdkPLfA-1; Tue, 07 Nov 2023 09:22:03 -0500
X-MC-Unique: 375zLsf0MAWZSrXKdkPLfA-1
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-41e1899175eso14311621cf.1
        for <kvm@vger.kernel.org>; Tue, 07 Nov 2023 06:22:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699366922; x=1699971722;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kLVHjLQFNZM1R0nYZqPiujbYlWwyXgBaHuNRoop7EPA=;
        b=qYIyisXnwwaRX3UU7e4BofxQxkjrN4Nt9NeCYJ3N+lq7+vUM8t1yLDolSww+Ivsgyi
         GnK3HAXuF/uzg+R7ggljSA/++peYMlqzl3NcPrwL6KgP3rSWpU1ViIKLSx43uWK02Ebe
         hpf7XiJ/NoFczjRYVUt/9KwqeJyP25mCTy4f9N/hUHPNGN2v1n9hdKm/6A+zzUOwkLIF
         Q63NdOO41EtSF1d2TmEGgu2SA9mEyCD3m2j8eeNDXa0IXIYZFqMHrAhQ92eRvjID97ot
         PGrfAvYw175qleSyCdtwBG/jMMdDucB+RK94pvXWmaosQi+JdJJoEpVzFIuuD5bpHCDy
         JL8A==
X-Gm-Message-State: AOJu0YxUZIZrLD/uO9w7De7AhYdR9yycCaGUCXHSuwSJLaoZd/2AEV3E
	XHfUK07vFqaiAB1ufx0kK1s9tbRXRAzTpwis/3s1GXzhwDbpD/zcL6OHSV+/pXtvbymF+e9w5XG
	zRuC+/MDr+Qvj
X-Received: by 2002:a05:622a:170f:b0:410:840c:dee4 with SMTP id h15-20020a05622a170f00b00410840cdee4mr36943982qtk.0.1699366922541;
        Tue, 07 Nov 2023 06:22:02 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHJFXpDr9X9RFihk+VPwdyMnsatw1TqkV4bKtaRR5BQ3bRDMKcrWsKyjydjHhyk0m8Mrxk5GQ==
X-Received: by 2002:a05:622a:170f:b0:410:840c:dee4 with SMTP id h15-20020a05622a170f00b00410840cdee4mr36943964qtk.0.1699366922182;
        Tue, 07 Nov 2023 06:22:02 -0800 (PST)
Received: from x1n (cpe5c7695f3aee0-cm5c7695f3aede.cpe.net.cable.rogers.com. [99.254.144.39])
        by smtp.gmail.com with ESMTPSA id x5-20020ac87305000000b0041cbb7139a9sm4286337qto.65.2023.11.07.06.22.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Nov 2023 06:22:01 -0800 (PST)
Date: Tue, 7 Nov 2023 09:21:59 -0500
From: Peter Xu <peterx@redhat.com>
To: David Matlack <dmatlack@google.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, kvm list <kvm@vger.kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	James Houghton <jthoughton@google.com>,
	Oliver Upton <oupton@google.com>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Frank van der Linden <fvdl@google.com>
Subject: Re: RFC: A KVM-specific alternative to UserfaultFD
Message-ID: <ZUpIB1/5eZ/2X+0M@x1n>
References: <CALzav=d23P5uE=oYqMpjFohvn0CASMJxXB_XEOEi-jtqWcFTDA@mail.gmail.com>
 <ZUlLLGLi1IyMyhm4@x1n>
 <CAJHvVciC3URbJJMwhU0ahhzq6bomr7juuWqPdpczV6Qgb8OUuQ@mail.gmail.com>
 <ZUlw163pvpJ+Uue8@x1n>
 <CALzav=d=sAJBK7fBeJwi3BVJ+4ai5MjU7-u0RD4BQMGNRYi_Tw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALzav=d=sAJBK7fBeJwi3BVJ+4ai5MjU7-u0RD4BQMGNRYi_Tw@mail.gmail.com>

On Mon, Nov 06, 2023 at 03:22:05PM -0800, David Matlack wrote:
> On Mon, Nov 6, 2023 at 3:03 PM Peter Xu <peterx@redhat.com> wrote:
> > On Mon, Nov 06, 2023 at 02:24:13PM -0800, Axel Rasmussen wrote:
> > > On Mon, Nov 6, 2023 at 12:23 PM Peter Xu <peterx@redhat.com> wrote:
> > > > On Mon, Nov 06, 2023 at 10:25:13AM -0800, David Matlack wrote:
> > > > >
> > > > >   * Memory Overhead: UserfaultFD requires an extra 8 bytes per page of
> > > > >     guest memory for the userspace page table entries.
> > > >
> > > > What is this one?
> > >
> > > In the way we use userfaultfd, there are two shared userspace mappings
> > > - one non-UFFD registered one which is used to resolve demand paging
> > > faults, and another UFFD-registered one which is handed to KVM et al
> > > for the guest to use. I think David is talking about the "second"
> > > mapping as overhead here, since with the KVM-based approach he's
> > > describing we don't need that mapping.
> >
> > I see, but then is it userspace relevant?  IMHO we should discuss the
> > proposal based only on the design itself, rather than relying on any
> > details on possible userspace implementations if two mappings are not
> > required but optional.
> 
> What I mean here is that for UserfaultFD to track accesses at
> PAGE_SIZE granularity, that requires 1 PTE per page, i.e. 8 bytes per
> page. Versus the KVM-based approach which only requires 1 bit per page
> for the present bitmap. This is inherent in the design of UserfaultFD
> because it uses PTEs to track what is present, not specific to how we
> use UserfaultFD.

Shouldn't the userspace normally still maintain one virtual mapping anyway
for the guest address range?  As IIUC kvm still relies a lot on HVA to work
(at least before guest memfd)? E.g., KVM_SET_USER_MEMORY_REGION, or mmu
notifiers.  If so, that 8 bytes should be there with/without userfaultfd,
IIUC.

Also, I think that's not strictly needed for any kind of file memories, as
in those case userfaultfd works with page cache.

Thanks,

-- 
Peter Xu


