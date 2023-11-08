Return-Path: <kvm+bounces-1221-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 079BF7E5BCC
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 17:57:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B6BB2281351
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 16:56:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8ADE73035C;
	Wed,  8 Nov 2023 16:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gOeE82aC"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 139E930326
	for <kvm@vger.kernel.org>; Wed,  8 Nov 2023 16:56:52 +0000 (UTC)
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A0F51FE6
	for <kvm@vger.kernel.org>; Wed,  8 Nov 2023 08:56:52 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id 5b1f17b1804b1-40859c466efso51694085e9.3
        for <kvm@vger.kernel.org>; Wed, 08 Nov 2023 08:56:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699462611; x=1700067411; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qruIr/ETrGJxH10qVl1iY9b34CtJjDDOG9qfLztL5mM=;
        b=gOeE82aCXFYamQyYiCSFj5oEApae6ixkZnvVZF/e1eXM+gAXUIKtUNnvlELN2JZNrr
         4EBiXBY/wi3VM+jr8HBiJGeppP/WLCHJMwoPggK6v4kyTMLxpRoGqKu7nqDjR+rl8LQt
         NwB7Kt1zTrz/aPhA52dk/sfEK0eobmWBY/yGgxp56SjIaNC6A5udKxe+w7qH3QHaxhrb
         MVBrsHMg1a3Bc8zbyIOVibRenOngTVLwJt51T+ZCLFCCEy2KpdaexAZcqzpaeslyoOeh
         nEwm+iUjHL9IK9c4qFpmhloMTwpD/DC6Beuru/JTeWSljeTz0t/H0iTFYpZOwzCvIHoP
         /00Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699462611; x=1700067411;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qruIr/ETrGJxH10qVl1iY9b34CtJjDDOG9qfLztL5mM=;
        b=Bn4SxpuZOz1RG1BXKiCLen1vKbnh3E0jimwbFZEsdQI6D59FubbyWOeEV4QLeB2bCp
         oAp+fiJW+/8ZbLGmVxQEiPraGaR1VRvrfxSq7iLCJg49wrCGC+/L0il3a/YcM3BOggCs
         47+tEWD5dmhghwe6HsJvByKUp+2XZg4yFVmeR8a/U5fkPtT9iUSSyGJF/qWJRT+zAOCc
         4KCCzDDrNTd7dQ9HNVNCUBGaoygFzUzEx4Ub1SQl0g1+JdighKJxC3c4Y1npCIyGKynZ
         onHnvwRSYNlPt7KMOIsnePx/bJ/UykCjJ64RJcWuVd0RMtjCNbagA7E/+oAW2e3FxwMO
         SjGA==
X-Gm-Message-State: AOJu0YwToyHVDsss1VK5f/sNQ3ou+OU8adibekQ+x6RIZuZkAMwNzEu6
	J1LI9Vo6P1ZtiWAzJJTPZn+M/1mawt0+JHC7EzdPdA==
X-Google-Smtp-Source: AGHT+IGTR1gGEHKXjaJVoStFJ9UIN2oDksqvgCWq6h1aE0SmeGtUBbOU+mDXX0uUNn1qexKVXQeALwVBooU+VIFkiYk=
X-Received: by 2002:a05:600c:4ece:b0:408:3d91:8251 with SMTP id
 g14-20020a05600c4ece00b004083d918251mr2257656wmq.5.1699462610600; Wed, 08 Nov
 2023 08:56:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CALzav=d23P5uE=oYqMpjFohvn0CASMJxXB_XEOEi-jtqWcFTDA@mail.gmail.com>
 <ZUlLLGLi1IyMyhm4@x1n> <fcef7c96-a1bb-4c1d-962b-1bdc2a3b4f19@redhat.com>
 <CALzav=ejfDDRdjtx-ipFYrhNWPZnj3P0RSNHOQCP+OQf5YGX5w@mail.gmail.com>
 <ZUqn0OwtNR19PDve@linux.dev> <CALzav=evOG04=mtnc9Tf=bevWq0PbW_2Q=2e=ErruXtE+3gDVQ@mail.gmail.com>
 <ZUrj8IK__59kHixL@linux.dev>
In-Reply-To: <ZUrj8IK__59kHixL@linux.dev>
From: David Matlack <dmatlack@google.com>
Date: Wed, 8 Nov 2023 08:56:22 -0800
Message-ID: <CALzav=dXDh4xAzDEbKOxLZkgjEyNs8VLoCOuJg4YYrD0=QzvGw@mail.gmail.com>
Subject: Re: RFC: A KVM-specific alternative to UserfaultFD
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>, 
	kvm list <kvm@vger.kernel.org>, Sean Christopherson <seanjc@google.com>, 
	James Houghton <jthoughton@google.com>, Oliver Upton <oupton@google.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Mike Kravetz <mike.kravetz@oracle.com>, 
	Andrea Arcangeli <aarcange@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 7, 2023 at 5:27=E2=80=AFPM Oliver Upton <oliver.upton@linux.dev=
> wrote:
>
> On Tue, Nov 07, 2023 at 01:34:34PM -0800, David Matlack wrote:
> > On Tue, Nov 7, 2023 at 1:10=E2=80=AFPM Oliver Upton <oliver.upton@linux=
.dev> wrote:
> > Thanks Oliver. Maybe I'm being dense but I'm still not understanding
> > how VGIC and UFFD interact :). I understand that VGIC is unaware of
> > UFFD, but fundamentally they must interact in some way during
> > post-copy. Can you spell out the sequence of events?
>
> Well it doesn't help that my abbreviated explanation glosses over some
> details. So here's the verbose explanation, and I'm sure Marc will have
> a set of corrections too :) I meant there's no _explicit_ interaction
> between UFFD and the various bits of GIC that need to touch guest
> memory.
>
> The GIC redistributors contain a set of MMIO registers that are
> accessible through the KVM_GET_DEVICE_ATTR and KVM_SET_DEVICE_ATTR
> ioctls. Writes to these are reflected directly into the KVM
> representation, no biggie there.
>
> One of the registers (GICR_PENDBASER) is a pointer to guest memory,
> containing a bitmap of pending LPIs managed by the redistributor. The
> ITS takes this to the extreme, as it is effectively a bunch of page
> tables for interrupts. All of this state actually lives in a KVM
> representation, and is only flushed out to guest memory when explicitly
> told to do so by userspace.
>
> On the target, we reread all the info when rebuilding interrupt
> translations when userspace calls KVM_DEV_ARM_ITS_RESTORE_TABLES. All of
> these guest memory accesses go through kvm_read_guest() and I expect the
> usual UFFD handling for non-present pages kicks in from there.

Thanks for the longer explanation. Yes kvm_read_guest() eventually
calls __copy_from_user() which will trigger a page fault and
UserfaultFD will notify userspace and wait for the page to become
present. In the KVM-specific proposal I outlined, calling
kvm_read_guest() will ultimately result in a check of the VM's present
bitmap and KVM will nnotify userspace and wait for the page to become
present if it's not, before calling __copy_from_user(). So I don't
expect a KVM-specific solution to have any increased maintenance
burden for VGIC (or any other widgets).

