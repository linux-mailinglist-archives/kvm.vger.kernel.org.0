Return-Path: <kvm+bounces-1271-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 37FAB7E5EFB
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 21:10:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E58BB28126D
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 20:10:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 182BB3716E;
	Wed,  8 Nov 2023 20:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1p9LbTUv"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 408083715B
	for <kvm@vger.kernel.org>; Wed,  8 Nov 2023 20:10:18 +0000 (UTC)
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CAE91BD5
	for <kvm@vger.kernel.org>; Wed,  8 Nov 2023 12:10:17 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5a7aa161b2fso1194127b3.2
        for <kvm@vger.kernel.org>; Wed, 08 Nov 2023 12:10:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699474216; x=1700079016; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FnrlfAtJZQDfTvypTyFl7HOXVAXk2U70r2VqPIR2LKE=;
        b=1p9LbTUvgXIBN4UlW3b6/XaxgP0tt1Y4rut1Lgd4Mbu7F+wt4z8lv6jKtx8gw7tled
         UyB4QOyDfc38+GW57sTcoPCLca0iosomlq8DFhYxAo5A34L8jr8ctLn9hzF9RE8vq5IK
         fgwcliNAtyOPyI2dO+71y29aHnS6XOW+9c4aRWfc+zB/wqg23f9JqASykz4uoZGGnYM4
         DO8nmpZ7JyIRle/LIMxm9ldmu9uhWjCsKnL6k/yQWtDEv2nXTJ9I3Y5xvOrtszp4cXHS
         R4B6NsXnIImnheJQlKafQfs0O9zjBgcZnedf3GyyKVNQ2Wb7eedIKSKKlQpTD5iv5Xse
         xpTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699474216; x=1700079016;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FnrlfAtJZQDfTvypTyFl7HOXVAXk2U70r2VqPIR2LKE=;
        b=A9qgT6VwQpT55vT2GU5coqOMSCfNts5F66jlpGVMxm9qAXhUNMzjm3Z+Itu+VemSVn
         dinAwFSc2umEic16BqGxadyudaat3Ojy7y+j/WCaUp+0YPI1kChE1cMZiS53YdyGDMwR
         I2h3Gf7o9GEJ4m52lRORjJpqNSG/WN/0xboKvHemnzUbovivNT1H1tdeeIlHXXzpv9KB
         VU0tLIsHdH198oD+5H7+8Wl9gL6/I2cSC/P1pDGst/tRWuihQ/+b0wO50+HHpPmau/Jg
         5AJ/wlVw0wyAGrX4Vl1D9bpayk1vNGd1f5oxG4xNgCuRhwimtcnBgnqhsRxa8KEAWi6+
         bFbw==
X-Gm-Message-State: AOJu0Yy8rcR1Yan4nnNom6WmMXYUEuGVWP3RKBRsAx7SZ1rfWd/6jqHs
	fAgeNuI/TOng4m0LO0h3j70lKchqDsI=
X-Google-Smtp-Source: AGHT+IHas8+PgHF0M/uItChFmksW8JucW4LnsY13Rw0R7OwMEEYdHdHtzrE8TaWsQWoGJ6J6bWy30q9n6cA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:ae22:0:b0:d9a:f3dc:7d19 with SMTP id
 a34-20020a25ae22000000b00d9af3dc7d19mr54506ybj.11.1699474216728; Wed, 08 Nov
 2023 12:10:16 -0800 (PST)
Date: Wed, 8 Nov 2023 12:10:15 -0800
In-Reply-To: <ZUvGpmk680nBKwOE@x1n>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <CALzav=d23P5uE=oYqMpjFohvn0CASMJxXB_XEOEi-jtqWcFTDA@mail.gmail.com>
 <ZUlLLGLi1IyMyhm4@x1n> <fcef7c96-a1bb-4c1d-962b-1bdc2a3b4f19@redhat.com>
 <CALzav=ejfDDRdjtx-ipFYrhNWPZnj3P0RSNHOQCP+OQf5YGX5w@mail.gmail.com>
 <ZUqn0OwtNR19PDve@linux.dev> <CALzav=evOG04=mtnc9Tf=bevWq0PbW_2Q=2e=ErruXtE+3gDVQ@mail.gmail.com>
 <ZUrj8IK__59kHixL@linux.dev> <CALzav=dXDh4xAzDEbKOxLZkgjEyNs8VLoCOuJg4YYrD0=QzvGw@mail.gmail.com>
 <ZUvGpmk680nBKwOE@x1n>
Message-ID: <ZUvrJz42KXPsffJH@google.com>
Subject: Re: RFC: A KVM-specific alternative to UserfaultFD
From: Sean Christopherson <seanjc@google.com>
To: Peter Xu <peterx@redhat.com>
Cc: David Matlack <dmatlack@google.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Paolo Bonzini <pbonzini@redhat.com>, kvm list <kvm@vger.kernel.org>, 
	James Houghton <jthoughton@google.com>, Oliver Upton <oupton@google.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Mike Kravetz <mike.kravetz@oracle.com>, 
	Andrea Arcangeli <aarcange@redhat.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Nov 08, 2023, Peter Xu wrote:
> On Wed, Nov 08, 2023 at 08:56:22AM -0800, David Matlack wrote:
> > Thanks for the longer explanation. Yes kvm_read_guest() eventually
> > calls __copy_from_user() which will trigger a page fault and
> > UserfaultFD will notify userspace and wait for the page to become
> > present. In the KVM-specific proposal I outlined, calling
> > kvm_read_guest() will ultimately result in a check of the VM's present
> > bitmap and KVM will nnotify userspace and wait for the page to become
> > present if it's not, before calling __copy_from_user(). So I don't
> > expect a KVM-specific solution to have any increased maintenance
> > burden for VGIC (or any other widgets).
> 
> The question is how to support modules that do not use kvm apis at all,
> like vhost.  I raised the question in my initial reply, too.
> 
> I think if vhost is going to support gmemfd, it'll need new apis so maybe
> there'll be a chance to take that into account, but I'm not 100% sure it'll
> be the same complexity, also not sure if that's the plan even for CoCo.
>
> Or is anything like vhost not considered to be supported for gmemfd at all?

vhost shouldn't require new APIs.  To support vhost, guest_memfd would first need
to support virtio for host userspace, i.e. would need to support .mmap().  At that
point, all of the uaccess and gup() stuff in vhost should work without modification.

