Return-Path: <kvm+bounces-196-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5BD8E7DCECC
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 15:10:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8D1621C20C42
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 14:10:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21C0B1DFCA;
	Tue, 31 Oct 2023 14:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="z0MqeRGv"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D40E1DDE3
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 14:10:21 +0000 (UTC)
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A6AB103
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 07:10:11 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5afacc566f3so49349297b3.3
        for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 07:10:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698761410; x=1699366210; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qnQOjymnTrZBwkJL50GP/1+n+ilT5bo3LZ+viwIL69A=;
        b=z0MqeRGvW14GWNa8pBelMmpO5+NOF/ApuojoVC/wg81KjdUsKW6wOPu//fOextVE0Z
         Qt6UX9h2DGe3YLEoN3v6XDAtiLFYP7oGE/y8JZuBhkBwhQRiPEUtwoQ87l5ttGRT6jmv
         qI7Xpi1BD3/JUOgEf/QDlBlZmbDWKmYL6uX2WvhboDMh1GE/x3IB2wNflFafzbNEdKbI
         niKUgr+KIj25mNFMmbtDlI550afgDLnfAVYF08BBDzODC7Sx8lnhlNYkosEQ4/FiifKv
         V1nzmKlbqP+6hEueCBMfqWOm/cJ68GySDPMzlcA6iBeM0WUymUuVtz3q/hO9uHELfIRR
         JhGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698761410; x=1699366210;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qnQOjymnTrZBwkJL50GP/1+n+ilT5bo3LZ+viwIL69A=;
        b=Gv+OqRa5SYVz+Nj5xwzbSD9lGoLdNhvHMYheo3wOaOzoF/WKy7J3QkK7s+PgF2opoK
         MGAoXuadBpTAkMAhgkWv3N6FByriHXm9QL2ULwtIJZSNiJwejcDsNB+ulF9iM/MNIQPS
         Bbp8fbV4/MU/GS35T3zAVpIimQRrKSvTvVEjC1HPu3uSXPL742E66ZXZg1Jg09cjfa8z
         XphTUdzx1u2Izg/P1aAeh+R+QljK9oqGsT4Le28LocpSC6G3lOG5awgHNLJi7ZxAhh+2
         DCw3H608ZTEkCSAmCQjBKKPIuEPKmUy6APiRI50PDJuwuILP7HLLo57BFdw9H2l4PA3N
         iJYg==
X-Gm-Message-State: AOJu0YyVGbBfNOhylQyLQ5ssMOKnvvSI8Rc2Ipb43brcGA6zvdMgcatP
	MWAzKcFhioY6BpqDA6yQjaRa6t6GEDs=
X-Google-Smtp-Source: AGHT+IHZDXQi7UJsz3IrNX3ZHQxUCVwQKR+0lKBMLeJ46WZVaPkGJ08yzTLT3JODvkoGCJ0IGZA0c9r9iJw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:a14c:0:b0:59b:eea4:a5a6 with SMTP id
 y73-20020a81a14c000000b0059beea4a5a6mr274540ywg.0.1698761410163; Tue, 31 Oct
 2023 07:10:10 -0700 (PDT)
Date: Tue, 31 Oct 2023 07:10:08 -0700
In-Reply-To: <ZUCe/PGL2Q4OzDOX@chao-email>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231027182217.3615211-1-seanjc@google.com> <20231027182217.3615211-17-seanjc@google.com>
 <ZUCe/PGL2Q4OzDOX@chao-email>
Message-ID: <ZUEKwOQoibAEWAzU@google.com>
Subject: Re: [PATCH v13 16/35] KVM: Add KVM_CREATE_GUEST_MEMFD ioctl() for
 guest-specific backing memory
From: Sean Christopherson <seanjc@google.com>
To: Chao Gao <chao.gao@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Xu Yilun <yilun.xu@intel.com>, Chao Peng <chao.p.peng@linux.intel.com>, 
	Fuad Tabba <tabba@google.com>, Jarkko Sakkinen <jarkko@kernel.org>, 
	Anish Moorthy <amoorthy@google.com>, David Matlack <dmatlack@google.com>, 
	Yu Zhang <yu.c.zhang@linux.intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	"=?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?=" <mic@digikod.net>, Vlastimil Babka <vbabka@suse.cz>, 
	Vishal Annapurve <vannapurve@google.com>, Ackerley Tng <ackerleytng@google.com>, 
	Maciej Szmigiero <mail@maciej.szmigiero.name>, David Hildenbrand <david@redhat.com>, 
	Quentin Perret <qperret@google.com>, Michael Roth <michael.roth@amd.com>, Wang <wei.w.wang@intel.com>, 
	Liam Merwick <liam.merwick@oracle.com>, Isaku Yamahata <isaku.yamahata@gmail.com>, 
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Oct 31, 2023, Chao Gao wrote:
> >+int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args)
> >+{
> >+	loff_t size = args->size;
> >+	u64 flags = args->flags;
> >+	u64 valid_flags = 0;
> >+
> >+	if (flags & ~valid_flags)
> >+		return -EINVAL;
> >+
> >+	if (size < 0 || !PAGE_ALIGNED(size))
> >+		return -EINVAL;
> 
> is size == 0 a valid case?

Nope, this is a bug.

> >+	if (!xa_empty(&gmem->bindings) &&
> >+	    xa_find(&gmem->bindings, &start, end - 1, XA_PRESENT)) {
> >+		filemap_invalidate_unlock(inode->i_mapping);
> >+		goto err;
> >+	}
> >+
> >+	/*
> >+	 * No synchronize_rcu() needed, any in-flight readers are guaranteed to
> >+	 * be see either a NULL file or this new file, no need for them to go
> >+	 * away.
> >+	 */
> >+	rcu_assign_pointer(slot->gmem.file, file);
> >+	slot->gmem.pgoff = start;
> >+
> >+	xa_store_range(&gmem->bindings, start, end - 1, slot, GFP_KERNEL);
> >+	filemap_invalidate_unlock(inode->i_mapping);
> >+
> >+	/*
> >+	 * Drop the reference to the file, even on success.  The file pins KVM,
> >+	 * not the other way 'round.  Active bindings are invalidated if the
> >+	 * file is closed before memslots are destroyed.
> >+	 */
> >+	fput(file);
> >+	return 0;
> >+
> >+err:
> >+	fput(file);
> >+	return -EINVAL;
> 
> The cleanup, i.e., filemap_invalidate_unlock() and fput(), is common. So, I think it
> may be slightly better to consolidate the common part e.g.,

I would prefer to keep this as-is.  Only goto needs the unlock, and I find it easier
to understand the success vs. error paths with explicit returns.  But it's not a
super strong preference.

