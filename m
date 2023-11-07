Return-Path: <kvm+bounces-1036-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5EEED7E46CD
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 18:24:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E2792B20EA5
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 17:24:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A03C3347B9;
	Tue,  7 Nov 2023 17:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iCE9kWoX"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA1CB335C0
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 17:24:40 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 576A7101
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 09:24:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699377879;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=n6iRqFYmz5H1LDnW4p44izaVbI8kvsmsngAn7NQqBlQ=;
	b=iCE9kWoXtvWiY6bpIZmaDTPl8zoifQtunAFS/u6hh9her818gZYJ7tDx++YishT7OiB79d
	yFlX7qWc7w6TrDY5slBKWC4/JPgNeIiZ1LZ7p4pN5fxGqnc9fndGgdu2PwgMfilp+yE/oq
	a935w+ZO7TGSDRN+ChHlUzwg8fWtnig=
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com
 [209.85.210.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-251-BchFnXtpOVeEhsvPsycUWg-1; Tue, 07 Nov 2023 12:24:33 -0500
X-MC-Unique: BchFnXtpOVeEhsvPsycUWg-1
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-6cd01bd39a3so1037836a34.1
        for <kvm@vger.kernel.org>; Tue, 07 Nov 2023 09:24:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699377873; x=1699982673;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n6iRqFYmz5H1LDnW4p44izaVbI8kvsmsngAn7NQqBlQ=;
        b=cBPk4ZdoXbvIsqOYT4QppqunoDHyYoRPwXzraguMf8JFaMUHkI654XY5OwXUfsLF/s
         Dqepw3puJN59PZF+mVGFBnjzTvyqJHgrWLWWYz41eaGmJGiCtMHvlF3UEnXbne/g5daQ
         X+r4WmP0ca5NCke7I5ekeOH8UmgMwitBdnpZkGxKRsxCL2uyejWC9ZNvm7olvcoPMLiP
         PgUKjrM313vtjUqBjA4e1NQgx1J+k5Wgp5NQ4i9ihhN1GVAWFc7mLrs1jLRY+EQf8PUq
         2Xau6QUrBqbzE51ef+ShAwdrHwfW6B5sQDNEk/zo4W0bHD7ZshDAfZQA3Cad5FGtTARl
         WYRw==
X-Gm-Message-State: AOJu0YxwGz0gv9bXjOQO298ijLeWgC0fEH2K9I3rgPmCk6Cx2Bh6E2ME
	XLm+hYgo9c+hsI0ct7SRRq7b79trFdHOGIIPLwVuwoIGv6HARNiKtqESxrPQj9ZlkKDZfAFTuE5
	8UjsQLORHI7W5
X-Received: by 2002:a4a:c991:0:b0:586:7095:126d with SMTP id u17-20020a4ac991000000b005867095126dmr31247062ooq.0.1699377872873;
        Tue, 07 Nov 2023 09:24:32 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE8w6NSbcnoCKrFSZ3eVgNyXybxogde+kXTelNxtMRNBvmZFASv4LSQb8UyoPhsLshGuiJtXA==
X-Received: by 2002:a4a:c991:0:b0:586:7095:126d with SMTP id u17-20020a4ac991000000b005867095126dmr31247040ooq.0.1699377872564;
        Tue, 07 Nov 2023 09:24:32 -0800 (PST)
Received: from x1n (cpe5c7695f3aee0-cm5c7695f3aede.cpe.net.cable.rogers.com. [99.254.144.39])
        by smtp.gmail.com with ESMTPSA id hj8-20020a05622a620800b00403cce833eesm92803qtb.27.2023.11.07.09.24.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Nov 2023 09:24:32 -0800 (PST)
Date: Tue, 7 Nov 2023 12:24:29 -0500
From: Peter Xu <peterx@redhat.com>
To: James Houghton <jthoughton@google.com>
Cc: David Matlack <dmatlack@google.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, kvm list <kvm@vger.kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Oliver Upton <oupton@google.com>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Frank van der Linden <fvdl@google.com>
Subject: Re: RFC: A KVM-specific alternative to UserfaultFD
Message-ID: <ZUpyzWOuhFDTXiAW@x1n>
References: <CALzav=d23P5uE=oYqMpjFohvn0CASMJxXB_XEOEi-jtqWcFTDA@mail.gmail.com>
 <ZUlLLGLi1IyMyhm4@x1n>
 <CAJHvVciC3URbJJMwhU0ahhzq6bomr7juuWqPdpczV6Qgb8OUuQ@mail.gmail.com>
 <ZUlw163pvpJ+Uue8@x1n>
 <CALzav=d=sAJBK7fBeJwi3BVJ+4ai5MjU7-u0RD4BQMGNRYi_Tw@mail.gmail.com>
 <ZUpIB1/5eZ/2X+0M@x1n>
 <CADrL8HUHO12Bxrx94_VoS8AsN5uEO1qYM2SCF7Tgw-=vsRUwBA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CADrL8HUHO12Bxrx94_VoS8AsN5uEO1qYM2SCF7Tgw-=vsRUwBA@mail.gmail.com>

On Tue, Nov 07, 2023 at 08:11:09AM -0800, James Houghton wrote:
> This extra ~8 bytes per page overhead is real, and it is the
> theoretical maximum additional overhead that userfaultfd would require
> over a KVM-based demand paging alternative when we are using
> hugepages. Consider the case where we are using THPs and have just
> finished post-copy, and we haven't done any collapsing yet:
> 
> For userfaultfd: because we have UFFDIO_COPY'd or UFFDIO_CONTINUE'd at
> 4K (because we demand-fetched at 4K), the userspace page tables are
> entirely shattered. KVM has no choice but to have an entirely
> shattered second-stage page table as well.
> 
> For KVM demand paging: the userspace page tables can remain entirely
> populated, so we get PMD mappings here. KVM, though, uses 4K SPTEs
> because we have only just finished post-copy and haven't started
> collapsing yet.
> 
> So both systems end up with a shattered second stage page table, but
> userfaultfd has a shattered userspace page table as well (+8 bytes/4K
> if using THP, +another 8 bytes/2M if using HugeTLB-1G, etc.) and that
> is where the extra overhead comes from.
> 
> The second mapping of guest memory that we use today (through which we
> install memory), given that we are using hugepages, will use PMDs and
> PUDs, so the overhead is minimal.
> 
> Hope that clears things up!

Ah I see, thanks James.  Though, is this a real concern in production use,
considering worst case 0.2% overhead (all THP backed) and only exist during
postcopy, only on destination host?

In all cases, I agree that's still a valid point then, comparing to a
constant 1/32k consumption with a bitmap.

Thanks,

-- 
Peter Xu


