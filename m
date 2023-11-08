Return-Path: <kvm+bounces-1277-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2AA997E5F42
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 21:37:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5AF0E1C20B94
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 20:37:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40306374C8;
	Wed,  8 Nov 2023 20:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="O9jayy/a"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D2D2199B0
	for <kvm@vger.kernel.org>; Wed,  8 Nov 2023 20:37:01 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D11F91FEF
	for <kvm@vger.kernel.org>; Wed,  8 Nov 2023 12:37:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699475819;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Qz4lSn+48Cxibj97BhEH5wF48ABH4aeNEffhmHaR8bU=;
	b=O9jayy/aSG2iBeP7tR5Tc965GEcx69FyAed3NV0xc1HK8Bv8DEpqPRgHVMuwqEvyl62iHw
	+ua2kCs7oKhBM1EJ1ti+ODGAAKTVxLXbslw+W3Y3Du8iddNTFmwrcKrs6r/7AYwX9ucR1a
	7RKotloEJYxZoyRwF0Rn+fuVVF6jEOU=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-44-AZjg4fHMPWipAp3XKuLPEA-1; Wed, 08 Nov 2023 15:36:58 -0500
X-MC-Unique: AZjg4fHMPWipAp3XKuLPEA-1
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-6716c2696c7so301916d6.1
        for <kvm@vger.kernel.org>; Wed, 08 Nov 2023 12:36:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699475818; x=1700080618;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Qz4lSn+48Cxibj97BhEH5wF48ABH4aeNEffhmHaR8bU=;
        b=vn+8eMrDkrdMnWVCDJN0OqG5kAr7VNXa1amyKjZaqW45FWMldWJ3Uh0vUJa4DZwY1h
         YFv1wvaXgjNG7c/cQj1LVZ1bo5f36Qbio1RT0sfzr7ZUkv3rF4cP3qldVp4xhM+tYsRM
         PSBGWNmy8NEfwXZjPwOcvR6CVIl/M7VdRGVyDRNb7hRre0F3rSH2WSV06WWMQNjsjWDn
         5U/kXZJq7LVD3aVnHkiChEGQ3yEmJX4QOW4wPg59ABWnQPG8xA41FX1WcQ/7UoDR7mW9
         3Q70tUvBZBjGOELnziiBhyzbR8mGNBpRqfi+DknhjaK5NWoIphyM0bzyUtbqDrWqL37L
         +JIA==
X-Gm-Message-State: AOJu0YytpAkEWvXY9YoFff3cULSWb/A0UBQkEfKKhLInjufDiwyNGnyA
	490aQzI7IPubzmwQEurVijqBGB9YBFmcS8aya9/3g9DEtBEYgC5szljHpj7W1bdQrw9RUVaeSsy
	CUO+4R8kbqqwm4/si3Qjd
X-Received: by 2002:a05:620a:270d:b0:773:ad1f:3d5b with SMTP id b13-20020a05620a270d00b00773ad1f3d5bmr3242439qkp.0.1699475817747;
        Wed, 08 Nov 2023 12:36:57 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGRNIRmWsS5GtLFWsZ7d94rOfBSMPzxEHri5TpYnCIeL5d63oR62b8MHS3N/KGK9iphC7qyNQ==
X-Received: by 2002:a05:620a:270d:b0:773:ad1f:3d5b with SMTP id b13-20020a05620a270d00b00773ad1f3d5bmr3242418qkp.0.1699475817424;
        Wed, 08 Nov 2023 12:36:57 -0800 (PST)
Received: from x1n (cpe5c7695f3aee0-cm5c7695f3aede.cpe.net.cable.rogers.com. [99.254.144.39])
        by smtp.gmail.com with ESMTPSA id m12-20020a05620a24cc00b007770673e757sm1403815qkn.94.2023.11.08.12.36.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Nov 2023 12:36:56 -0800 (PST)
Date: Wed, 8 Nov 2023 15:36:54 -0500
From: Peter Xu <peterx@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: David Matlack <dmatlack@google.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>, kvm list <kvm@vger.kernel.org>,
	James Houghton <jthoughton@google.com>,
	Oliver Upton <oupton@google.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: RFC: A KVM-specific alternative to UserfaultFD
Message-ID: <ZUvxZmcs0cAwOxYq@x1n>
References: <CALzav=d23P5uE=oYqMpjFohvn0CASMJxXB_XEOEi-jtqWcFTDA@mail.gmail.com>
 <ZUlLLGLi1IyMyhm4@x1n>
 <fcef7c96-a1bb-4c1d-962b-1bdc2a3b4f19@redhat.com>
 <CALzav=ejfDDRdjtx-ipFYrhNWPZnj3P0RSNHOQCP+OQf5YGX5w@mail.gmail.com>
 <ZUqn0OwtNR19PDve@linux.dev>
 <CALzav=evOG04=mtnc9Tf=bevWq0PbW_2Q=2e=ErruXtE+3gDVQ@mail.gmail.com>
 <ZUrj8IK__59kHixL@linux.dev>
 <CALzav=dXDh4xAzDEbKOxLZkgjEyNs8VLoCOuJg4YYrD0=QzvGw@mail.gmail.com>
 <ZUvGpmk680nBKwOE@x1n>
 <ZUvrJz42KXPsffJH@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZUvrJz42KXPsffJH@google.com>

On Wed, Nov 08, 2023 at 12:10:15PM -0800, Sean Christopherson wrote:
> On Wed, Nov 08, 2023, Peter Xu wrote:
> > On Wed, Nov 08, 2023 at 08:56:22AM -0800, David Matlack wrote:
> > > Thanks for the longer explanation. Yes kvm_read_guest() eventually
> > > calls __copy_from_user() which will trigger a page fault and
> > > UserfaultFD will notify userspace and wait for the page to become
> > > present. In the KVM-specific proposal I outlined, calling
> > > kvm_read_guest() will ultimately result in a check of the VM's present
> > > bitmap and KVM will nnotify userspace and wait for the page to become
> > > present if it's not, before calling __copy_from_user(). So I don't
> > > expect a KVM-specific solution to have any increased maintenance
> > > burden for VGIC (or any other widgets).
> > 
> > The question is how to support modules that do not use kvm apis at all,
> > like vhost.  I raised the question in my initial reply, too.
> > 
> > I think if vhost is going to support gmemfd, it'll need new apis so maybe
> > there'll be a chance to take that into account, but I'm not 100% sure it'll
> > be the same complexity, also not sure if that's the plan even for CoCo.
> >
> > Or is anything like vhost not considered to be supported for gmemfd at all?
> 
> vhost shouldn't require new APIs.  To support vhost, guest_memfd would first need
> to support virtio for host userspace, i.e. would need to support .mmap().  At that
> point, all of the uaccess and gup() stuff in vhost should work without modification.

Then I suppose it means we will treat QEMU, vhost and probably the whole
host hypervisor stack the same trust level from gmemfd's regard.

But then it'll be a harder question for a new demand paging scheme, as the
new interface should need to be separately proposed.  Another option is to
only support kvm-api based virt modules, but it may then become slightly
less attractive.

Thanks,

-- 
Peter Xu


