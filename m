Return-Path: <kvm+bounces-1234-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C7D27E5C77
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 18:34:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B0412B20F30
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 17:34:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BCEB32C68;
	Wed,  8 Nov 2023 17:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XbR7vWv2"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2567630338
	for <kvm@vger.kernel.org>; Wed,  8 Nov 2023 17:34:38 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 960751BE3
	for <kvm@vger.kernel.org>; Wed,  8 Nov 2023 09:34:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699464876;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xZGn049Z75ixJvG6iAZ1DUS2viDNPnb4B/IxK+b5sq4=;
	b=XbR7vWv2aaUqsG4qHy7gDG05uhU+OljCylv5W1W5/reP+f2BicGxvszbxy3o2Vye+rYYwK
	hopW+EcPJWD9EYxsoPWbdcFBtnEhdjEl4+SQrqsw8UaVa6OvBszuUmkq8+kN/lkTBaBFPN
	KfUzkInx26Uan8aJQGZdu9qOVrwvM0s=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-362-dGQlAmceMXSNTCEFNI1jIw-1; Wed, 08 Nov 2023 12:34:33 -0500
X-MC-Unique: dGQlAmceMXSNTCEFNI1jIw-1
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-77a02ceef95so107486585a.0
        for <kvm@vger.kernel.org>; Wed, 08 Nov 2023 09:34:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699464873; x=1700069673;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xZGn049Z75ixJvG6iAZ1DUS2viDNPnb4B/IxK+b5sq4=;
        b=qlihANx3mFOgqD1bP7HnBQw/vuGiQ5MrJTLcnPeUtlHrBcsMEQKSmSTKxmQ/AsyJws
         i7WUa4tmDzRJRR9oZQpAXYgWB/DHi5MnJB2jb9rxX74mXMrqNT8Jnf8kPfXZRSQVn4Ds
         KXDBEuC+NiWnvRDBQ4JDupGZ2tgeVJFPKN7QS/SU7gIENXFHP3qYA1k5QdzG8vcv/wHO
         I+2mpzIIJFdAalX7OQjNoSJ6/eREQGxZVtQvyeT0qcyZq5GKybLvGUEpuF/LnEaBl0Fr
         zFMjsFLr6lcWfzHjdNTIhNHZJA7ZqWp1eo2gC8+E+4+69sXp81yiRhmWEr4015n3M9kp
         +OjA==
X-Gm-Message-State: AOJu0YzC4vCn0I7TcIbiORqmeNbcFoyK2HL0P1VlOdXSND5tkcWNr+2x
	fe7eMKyRhxAV+wKYHz4gMFeNuwKjqMQ/3gzmPC+0SbRRE4KsPvk754wC5hBB5N6Y4hTaEmUpu8H
	/FU72irnS2R3v
X-Received: by 2002:a05:620a:1d0e:b0:76f:167a:cc4d with SMTP id dl14-20020a05620a1d0e00b0076f167acc4dmr2713670qkb.2.1699464873066;
        Wed, 08 Nov 2023 09:34:33 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG+wgzYuOU7bGQ6kEPnsqPx24+XBg4Ic2pjZhtAvPpX5YetDe00Z9GXOVTugJ+xCTgfEyi4gw==
X-Received: by 2002:a05:620a:1d0e:b0:76f:167a:cc4d with SMTP id dl14-20020a05620a1d0e00b0076f167acc4dmr2713648qkb.2.1699464872829;
        Wed, 08 Nov 2023 09:34:32 -0800 (PST)
Received: from x1n (cpe5c7695f3aee0-cm5c7695f3aede.cpe.net.cable.rogers.com. [99.254.144.39])
        by smtp.gmail.com with ESMTPSA id bp7-20020a05620a458700b00767e2668536sm1273080qkb.17.2023.11.08.09.34.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Nov 2023 09:34:32 -0800 (PST)
Date: Wed, 8 Nov 2023 12:34:30 -0500
From: Peter Xu <peterx@redhat.com>
To: David Matlack <dmatlack@google.com>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>, kvm list <kvm@vger.kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	James Houghton <jthoughton@google.com>,
	Oliver Upton <oupton@google.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: RFC: A KVM-specific alternative to UserfaultFD
Message-ID: <ZUvGpmk680nBKwOE@x1n>
References: <CALzav=d23P5uE=oYqMpjFohvn0CASMJxXB_XEOEi-jtqWcFTDA@mail.gmail.com>
 <ZUlLLGLi1IyMyhm4@x1n>
 <fcef7c96-a1bb-4c1d-962b-1bdc2a3b4f19@redhat.com>
 <CALzav=ejfDDRdjtx-ipFYrhNWPZnj3P0RSNHOQCP+OQf5YGX5w@mail.gmail.com>
 <ZUqn0OwtNR19PDve@linux.dev>
 <CALzav=evOG04=mtnc9Tf=bevWq0PbW_2Q=2e=ErruXtE+3gDVQ@mail.gmail.com>
 <ZUrj8IK__59kHixL@linux.dev>
 <CALzav=dXDh4xAzDEbKOxLZkgjEyNs8VLoCOuJg4YYrD0=QzvGw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CALzav=dXDh4xAzDEbKOxLZkgjEyNs8VLoCOuJg4YYrD0=QzvGw@mail.gmail.com>

On Wed, Nov 08, 2023 at 08:56:22AM -0800, David Matlack wrote:
> Thanks for the longer explanation. Yes kvm_read_guest() eventually
> calls __copy_from_user() which will trigger a page fault and
> UserfaultFD will notify userspace and wait for the page to become
> present. In the KVM-specific proposal I outlined, calling
> kvm_read_guest() will ultimately result in a check of the VM's present
> bitmap and KVM will nnotify userspace and wait for the page to become
> present if it's not, before calling __copy_from_user(). So I don't
> expect a KVM-specific solution to have any increased maintenance
> burden for VGIC (or any other widgets).

The question is how to support modules that do not use kvm apis at all,
like vhost.  I raised the question in my initial reply, too.

I think if vhost is going to support gmemfd, it'll need new apis so maybe
there'll be a chance to take that into account, but I'm not 100% sure it'll
be the same complexity, also not sure if that's the plan even for CoCo.

Or is anything like vhost not considered to be supported for gmemfd at all?
Is there any plan for the new postcopy proposal then for generic mem (!CoCo)?

Thanks,

-- 
Peter Xu


