Return-Path: <kvm+bounces-1280-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D7D47E5F58
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 21:44:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7A5E61C20B35
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 20:44:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64EF932C6E;
	Wed,  8 Nov 2023 20:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zFoxt1kr"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0CD819449
	for <kvm@vger.kernel.org>; Wed,  8 Nov 2023 20:44:08 +0000 (UTC)
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 123FF2132
	for <kvm@vger.kernel.org>; Wed,  8 Nov 2023 12:44:08 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id ffacd0b85a97d-32dc9ff4a8fso51107f8f.1
        for <kvm@vger.kernel.org>; Wed, 08 Nov 2023 12:44:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699476246; x=1700081046; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8vuP9HOMjXMxjaS7M9R2sYRI5+0+vbzRez3d8/TTIcQ=;
        b=zFoxt1krTBnhg5Q5eOXAlDp/fzKlk6dbM4Rm3J/dJkSsXXhb+Yyez7P+vlU5CBVFvU
         x8wHeR7NvYQ5jlkaHkPzPNB12Gg/oxJYsVVpFjKsRRZ4E4q6DwHqsYDq6bMkaaA4q8E9
         mJVn1hyL1K6Eo71IVq01Pl+KGXtlo6VptB2cjj335wQ4JklPzMO/4bSMtgrYYMMSOhlg
         42c31IsDFaMKcu8NKdesuVDVn/nE+yU8r7XTfFVf4FFmoMJBJw1gx4YLEl19sHHj/H4H
         0/3LDZGakNXo5gNTVvX7Ng99f2N7yAIENQGxsPke6dKp7NRBA6dSeNhkU8hOKkGj9YUB
         e6QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699476246; x=1700081046;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8vuP9HOMjXMxjaS7M9R2sYRI5+0+vbzRez3d8/TTIcQ=;
        b=ay/L9srf7uLGyaxopV/atYyzyCfXZTmNeg2zvNNmc5qIW/l3g9VaYBLqPeuso3tPj0
         47t0yWqpPrg6pGGHhPlOX9uHsTnkoYKirCGFRe48cDShHBH4uGP2qR/vehMshTFFqOQ3
         4h/29W10U48+D1Vs12GxnHGBu31I7vvXDNffEZHoKPtBO/FKyDXLSfUpNjfX5YbSQdLz
         fmEpYGXaXXa3NeGVHqUHNhAPR8O329eRnEQwGeb+EzgBYFFhDzBcfjdph9NUScr/1/ep
         eJ7YiGVPGUHhBIw0zVpv5lqfMZMh0BSm/HUFqisqEUzIOugy8Mj6mWVvbdhDqAyRehU4
         HGSw==
X-Gm-Message-State: AOJu0Ywpw7ydo6leT7orwJWE91f+dFH0Cc6ASKT9ilx61LI04KGXFsbn
	k09fef0KGDRc8he6KvRsCE5I4J6FxpQUhf07j/drN3Os+K83VAPJvsc=
X-Google-Smtp-Source: AGHT+IH/9NvWOIHoWH3NCfRrfOI7weUBpFGDNiyxAFPpmxEFCTV2yn9AHEcoXgy8yrgH6U3NGPjSItDV2i3ZmI8M+w4=
X-Received: by 2002:a05:6000:2aa:b0:32d:a2a3:9533 with SMTP id
 l10-20020a05600002aa00b0032da2a39533mr3171831wry.59.1699476246336; Wed, 08
 Nov 2023 12:44:06 -0800 (PST)
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
 <ZUrj8IK__59kHixL@linux.dev> <CALzav=dXDh4xAzDEbKOxLZkgjEyNs8VLoCOuJg4YYrD0=QzvGw@mail.gmail.com>
 <8109b040-1268-4096-ad31-34a89e0ddf46@redhat.com>
In-Reply-To: <8109b040-1268-4096-ad31-34a89e0ddf46@redhat.com>
From: David Matlack <dmatlack@google.com>
Date: Wed, 8 Nov 2023 12:43:38 -0800
Message-ID: <CALzav=dHBGamxxwYOmJZxEFZc3m8AN05r+Kxtk9Tgr68LJuTvA@mail.gmail.com>
Subject: Re: RFC: A KVM-specific alternative to UserfaultFD
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Oliver Upton <oliver.upton@linux.dev>, Peter Xu <peterx@redhat.com>, 
	kvm list <kvm@vger.kernel.org>, Sean Christopherson <seanjc@google.com>, 
	James Houghton <jthoughton@google.com>, Oliver Upton <oupton@google.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Mike Kravetz <mike.kravetz@oracle.com>, 
	Andrea Arcangeli <aarcange@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 8, 2023 at 12:33=E2=80=AFPM Paolo Bonzini <pbonzini@redhat.com>=
 wrote:
>
> On 11/8/23 17:56, David Matlack wrote:
> > Thanks for the longer explanation. Yes kvm_read_guest() eventually call=
s
> > __copy_from_user() which will trigger a page fault and UserfaultFD will
> > notify userspace and wait for the page to become present. In the
> > KVM-specific proposal I outlined, calling kvm_read_guest() will
> > ultimately result in a check of the VM's present bitmap and KVM will
> > nnotify userspace and wait for the page to become present if it's not,
> > before calling __copy_from_user(). So I don't expect a KVM-specific
> > solution to have any increased maintenance burden for VGIC (or any othe=
r
> > widgets).
>
> It does mean however that we need a cross-thread notification mechanism,
> instead of just relying on KVM_EXIT_MEMORY_FAULT (or another KVM_EXIT_*).

Yes. Any time KVM directly accesses guest memory (e.g.
kvm_read/write_guest()), it would use a blocking notification
mechanism (part (d) in the proposal). Google uses a netlink socket for
this, but a custom file descriptor would be more reliable.

