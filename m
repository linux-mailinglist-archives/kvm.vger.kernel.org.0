Return-Path: <kvm+bounces-137-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 61EC27DC256
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 23:12:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 02523B20EBD
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 22:12:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1718E1DA2D;
	Mon, 30 Oct 2023 22:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WmJRwsVA"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B76C1D539
	for <kvm@vger.kernel.org>; Mon, 30 Oct 2023 22:12:17 +0000 (UTC)
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B41DEFE
	for <kvm@vger.kernel.org>; Mon, 30 Oct 2023 15:12:12 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id d2e1a72fcca58-6be1065cc81so5043802b3a.3
        for <kvm@vger.kernel.org>; Mon, 30 Oct 2023 15:12:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698703932; x=1699308732; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=g8DEvtikhnQyn+T5K55cZjm1cs6/IKtx/WCyiBBil5U=;
        b=WmJRwsVAjOdugnxCaIdp3UcES2KqSgFbohBM76jKC7YPTZJdwtQ2PJU+QhiSZRiH2N
         5grrkTcJsGZVpzmuJiqBvCAH1jTwlEWNQ6KcmVPhvVQu+YoCWBCWzm6bIO9PqhzlbpZp
         bS6cnQ2aFt/5tjb0yB7qKOY3M/1aFkZWpPMzd1YNkwGkI5BJrTgc2Xx9Eat3tgF88QvR
         0KnkZG31xaUlQfT7A+8SN8KfNPxTV7vbtZmhGawVrF4NEf/86WzkrpHQrHqu808T/NsV
         Hmzh/NgXh85ruWCCmnVbRbrEROpg/OPDFFG1M6s5VPyp+ehahaeFeXgpKRtJp/Y/So0q
         db0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698703932; x=1699308732;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=g8DEvtikhnQyn+T5K55cZjm1cs6/IKtx/WCyiBBil5U=;
        b=FHFqvUAgJO1hxiQSE9wAOkWOnAZVwSiw7UX8QhBMH/rP7rslr3EPESlSMy8yQsVyWy
         zDT7e7GSnuv+9I9QtAonEGwdbxb66WqDyLftDc5GofOq0pt9qsVv3ecmMb0k6SO/3QNv
         LSRqZUfUUPhW0TQEG33M6XIgFKplVInjyNv5ymtX4TQk4o3RTb31oLm9GEJGO48LjS8i
         vtLNI5f3a57LCLSskIaYCnHUFay5nTSX6HGIaFXWlXFiEcjXhs3umq+pQiFLwKz7pcYk
         tjx6JkFu0K5oYK5tPbT6V2uN7ZNntQK3DVDWr8anTSIpMKJgs/PjghXqrXw4mwc6u3BR
         eK3g==
X-Gm-Message-State: AOJu0YwByTNntAfZhUt6eN0UE0UToK2pX6t1pKt8gg3FW/0yp2MH6zju
	YE1TpuUKcJkpkPmLeCognopqYIGKYoQ=
X-Google-Smtp-Source: AGHT+IGGcxVYGAYGv3uCrE8wHX1TR4p8IURd9gUNgfJNwa+fo9vdIR8HGGPD/6eLST5HVrX+Zf4WM1nECms=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1755:b0:68e:24fe:d9a with SMTP id
 j21-20020a056a00175500b0068e24fe0d9amr205380pfc.2.1698703932137; Mon, 30 Oct
 2023 15:12:12 -0700 (PDT)
Date: Mon, 30 Oct 2023 15:12:10 -0700
In-Reply-To: <ZUARTvhpChFSGF9s@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231027182217.3615211-1-seanjc@google.com> <20231027182217.3615211-9-seanjc@google.com>
 <211d093f-4023-4a39-a23f-6d8543512675@redhat.com> <ZUARTvhpChFSGF9s@google.com>
Message-ID: <ZUAqOn_zjvM4hukK@google.com>
Subject: Re: [PATCH v13 08/35] KVM: Introduce KVM_SET_USER_MEMORY_REGION2
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Huacai Chen <chenhuacai@kernel.org>, Michael Ellerman <mpe@ellerman.id.au>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, kvm@vger.kernel.org, 
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

On Mon, Oct 30, 2023, Sean Christopherson wrote:
> On Mon, Oct 30, 2023, Paolo Bonzini wrote:
> > On 10/27/23 20:21, Sean Christopherson wrote:
> > > 
> > > +		if (ioctl == KVM_SET_USER_MEMORY_REGION)
> > > +			size = sizeof(struct kvm_userspace_memory_region);
> > 
> > This also needs a memset(&mem, 0, sizeof(mem)), otherwise the out-of-bounds
> > access of the commit message becomes a kernel stack read.
> 
> Ouch.  There's some irony.  Might be worth doing memset(&mem, -1, sizeof(mem))
> though as '0' is a valid file descriptor and a valid file offset.
> 
> > Probably worth adding a check on valid flags here.
> 
> Definitely needed.  There's a very real bug here.  But rather than duplicate flags
> checking or plumb @ioctl all the way to __kvm_set_memory_region(), now that we
> have the fancy guard(mutex) and there are no internal calls to kvm_set_memory_region(),
> what if we:
> 
>   1. Acquire/release slots_lock in __kvm_set_memory_region()

Gah, this won't work with x86's usage, which acquire slots_lock quite far away
from __kvm_set_memory_region() in several places.  The rest of the idea still
works, kvm_vm_ioctl_set_memory_region() will just need to take slots_lock manually.

>   2. Call kvm_set_memory_region() from x86 code for the internal memslots
>   3. Disallow *any* flags for internal memslots
>   4. Open code check_memory_region_flags in kvm_vm_ioctl_set_memory_region()
>   5. Pass @ioctl to kvm_vm_ioctl_set_memory_region() and allow KVM_MEM_PRIVATE
>      only for KVM_SET_USER_MEMORY_REGION2

