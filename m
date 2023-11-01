Return-Path: <kvm+bounces-306-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7ED047DE116
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 13:46:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AF49B1C20C19
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 12:46:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15993125A4;
	Wed,  1 Nov 2023 12:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KDcfelv5"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6938A613C
	for <kvm@vger.kernel.org>; Wed,  1 Nov 2023 12:46:43 +0000 (UTC)
Received: from mail-qv1-xf2e.google.com (mail-qv1-xf2e.google.com [IPv6:2607:f8b0:4864:20::f2e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6261E4
	for <kvm@vger.kernel.org>; Wed,  1 Nov 2023 05:46:40 -0700 (PDT)
Received: by mail-qv1-xf2e.google.com with SMTP id 6a1803df08f44-66d76904928so43073626d6.2
        for <kvm@vger.kernel.org>; Wed, 01 Nov 2023 05:46:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698842800; x=1699447600; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mygXGcRJ5YlWP61Tr7KN5KWyfhmOoXTRmQYYFZqOKKI=;
        b=KDcfelv5DOHAm+W83U3D2+TJfUcylSuZ5QNl5MGBSIxGMmaqRq9grA/fOI8iIX6yni
         jBOvRGcqd5a1e+zOG5TNZLAUwT/5CQ11eCiOdEZ+BbnpA3QP/XYjCwbXmoV6URdfjIb9
         CeGPhCDK8FtUkEMAvNEITSNWjdLu9LfYZRR2NeyPY7pVPZXCCmNN1v1AQZKpUzGQI4VB
         mFmBQ7927BloxVIN5C4SYzt7pXl8EtwQgABAceY+dfJ7fVRqeGlWsIO4oY2kArO4SXcR
         yWR0HrpYOyY+UEKAC4XrMl4KAnH/jKWBv3BDAe6+4dL5Mf5obJXbirtxRg+gII9nlGT9
         X8bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698842800; x=1699447600;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mygXGcRJ5YlWP61Tr7KN5KWyfhmOoXTRmQYYFZqOKKI=;
        b=DcFlU5/Fcq/cBUO9lU5HfraEbf7ZACRA8FRcspB3Ul6NxAdppG2XImU3YpK7nF7zNL
         F7EftvflQjUWn13NBERL5j2n/Ka6Y4pgACvnWu6biJJNbqJje6Qy0ob9ayh8viG3xGjD
         zephhDV9DSD7BOB4Uz3PLrfvzCSqGfYy36xkOugYYJwLT+UJMOuzMJ7HMh6CcHNMfCaJ
         Thhve1uA5Qf75CwrTMOFacaQK0YgZ94AcwPEsAQdXN8fbTNE98jmnC/ugAZpcUt0StyG
         pYJZti3CUu26C2TYP4pIKyriUY5TAuE83uXL97aSkMSLUVLWRLK3QaysVFSz668br4kT
         7Qmw==
X-Gm-Message-State: AOJu0YzasCX+LVmAHPdv0U/gHmJmzFAhQQzfcgbrLzLuDMb7tf5GfZ+D
	gCSZEyEipIsKajbgx/dlRfDD1NcYGUEPUyEV7X0/CA==
X-Google-Smtp-Source: AGHT+IHd9N8dL6zdz3IA97hhnoDYG1Yv2Mx5veJZKoCg3Vt6EBcnFz3FSACXzGNwepp4FUZ865yy59BtQyGtgdViYUM=
X-Received: by 2002:a05:6214:f6c:b0:671:739e:e2fa with SMTP id
 iy12-20020a0562140f6c00b00671739ee2famr13258176qvb.59.1698842799599; Wed, 01
 Nov 2023 05:46:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231027182217.3615211-1-seanjc@google.com> <20231027182217.3615211-2-seanjc@google.com>
In-Reply-To: <20231027182217.3615211-2-seanjc@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 1 Nov 2023 12:46:02 +0000
Message-ID: <CA+EHjTy5tmgGmVNGTX4a2Engb+r1AQizsMxwb8xqOi1f9+VQLA@mail.gmail.com>
Subject: Re: [PATCH v13 01/35] KVM: Tweak kvm_hva_range and hva_handler_t to
 allow reusing for gfn ranges
To: Sean Christopherson <seanjc@google.com>
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
	Jarkko Sakkinen <jarkko@kernel.org>, Anish Moorthy <amoorthy@google.com>, 
	David Matlack <dmatlack@google.com>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>, 
	Vlastimil Babka <vbabka@suse.cz>, Vishal Annapurve <vannapurve@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Maciej Szmigiero <mail@maciej.szmigiero.name>, 
	David Hildenbrand <david@redhat.com>, Quentin Perret <qperret@google.com>, 
	Michael Roth <michael.roth@amd.com>, Wang <wei.w.wang@intel.com>, 
	Liam Merwick <liam.merwick@oracle.com>, Isaku Yamahata <isaku.yamahata@gmail.com>, 
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 27, 2023 at 7:22=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> Rework and rename "struct kvm_hva_range" into "kvm_mmu_notifier_range" so
> that the structure can be used to handle notifications that operate on gf=
n
> context, i.e. that aren't tied to a host virtual address.  Rename the
> handler typedef too (arguably it should always have been gfn_handler_t).
>
> Practically speaking, this is a nop for 64-bit kernels as the only
> meaningful change is to store start+end as u64s instead of unsigned longs=
.
>
> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---

Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad


>  virt/kvm/kvm_main.c | 34 +++++++++++++++++++---------------
>  1 file changed, 19 insertions(+), 15 deletions(-)
>
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 486800a7024b..0524933856d4 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -541,18 +541,22 @@ static inline struct kvm *mmu_notifier_to_kvm(struc=
t mmu_notifier *mn)
>         return container_of(mn, struct kvm, mmu_notifier);
>  }
>
> -typedef bool (*hva_handler_t)(struct kvm *kvm, struct kvm_gfn_range *ran=
ge);
> +typedef bool (*gfn_handler_t)(struct kvm *kvm, struct kvm_gfn_range *ran=
ge);
>
>  typedef void (*on_lock_fn_t)(struct kvm *kvm, unsigned long start,
>                              unsigned long end);
>
>  typedef void (*on_unlock_fn_t)(struct kvm *kvm);
>
> -struct kvm_hva_range {
> -       unsigned long start;
> -       unsigned long end;
> +struct kvm_mmu_notifier_range {
> +       /*
> +        * 64-bit addresses, as KVM notifiers can operate on host virtual
> +        * addresses (unsigned long) and guest physical addresses (64-bit=
).
> +        */
> +       u64 start;
> +       u64 end;
>         union kvm_mmu_notifier_arg arg;
> -       hva_handler_t handler;
> +       gfn_handler_t handler;
>         on_lock_fn_t on_lock;
>         on_unlock_fn_t on_unlock;
>         bool flush_on_ret;
> @@ -581,7 +585,7 @@ static const union kvm_mmu_notifier_arg KVM_MMU_NOTIF=
IER_NO_ARG;
>              node =3D interval_tree_iter_next(node, start, last))      \
>
>  static __always_inline int __kvm_handle_hva_range(struct kvm *kvm,
> -                                                 const struct kvm_hva_ra=
nge *range)
> +                                                 const struct kvm_mmu_no=
tifier_range *range)
>  {
>         bool ret =3D false, locked =3D false;
>         struct kvm_gfn_range gfn_range;
> @@ -608,9 +612,9 @@ static __always_inline int __kvm_handle_hva_range(str=
uct kvm *kvm,
>                         unsigned long hva_start, hva_end;
>
>                         slot =3D container_of(node, struct kvm_memory_slo=
t, hva_node[slots->node_idx]);
> -                       hva_start =3D max(range->start, slot->userspace_a=
ddr);
> -                       hva_end =3D min(range->end, slot->userspace_addr =
+
> -                                                 (slot->npages << PAGE_S=
HIFT));
> +                       hva_start =3D max_t(unsigned long, range->start, =
slot->userspace_addr);
> +                       hva_end =3D min_t(unsigned long, range->end,
> +                                       slot->userspace_addr + (slot->npa=
ges << PAGE_SHIFT));
>
>                         /*
>                          * To optimize for the likely case where the addr=
ess
> @@ -660,10 +664,10 @@ static __always_inline int kvm_handle_hva_range(str=
uct mmu_notifier *mn,
>                                                 unsigned long start,
>                                                 unsigned long end,
>                                                 union kvm_mmu_notifier_ar=
g arg,
> -                                               hva_handler_t handler)
> +                                               gfn_handler_t handler)
>  {
>         struct kvm *kvm =3D mmu_notifier_to_kvm(mn);
> -       const struct kvm_hva_range range =3D {
> +       const struct kvm_mmu_notifier_range range =3D {
>                 .start          =3D start,
>                 .end            =3D end,
>                 .arg            =3D arg,
> @@ -680,10 +684,10 @@ static __always_inline int kvm_handle_hva_range(str=
uct mmu_notifier *mn,
>  static __always_inline int kvm_handle_hva_range_no_flush(struct mmu_noti=
fier *mn,
>                                                          unsigned long st=
art,
>                                                          unsigned long en=
d,
> -                                                        hva_handler_t ha=
ndler)
> +                                                        gfn_handler_t ha=
ndler)
>  {
>         struct kvm *kvm =3D mmu_notifier_to_kvm(mn);
> -       const struct kvm_hva_range range =3D {
> +       const struct kvm_mmu_notifier_range range =3D {
>                 .start          =3D start,
>                 .end            =3D end,
>                 .handler        =3D handler,
> @@ -771,7 +775,7 @@ static int kvm_mmu_notifier_invalidate_range_start(st=
ruct mmu_notifier *mn,
>                                         const struct mmu_notifier_range *=
range)
>  {
>         struct kvm *kvm =3D mmu_notifier_to_kvm(mn);
> -       const struct kvm_hva_range hva_range =3D {
> +       const struct kvm_mmu_notifier_range hva_range =3D {
>                 .start          =3D range->start,
>                 .end            =3D range->end,
>                 .handler        =3D kvm_unmap_gfn_range,
> @@ -835,7 +839,7 @@ static void kvm_mmu_notifier_invalidate_range_end(str=
uct mmu_notifier *mn,
>                                         const struct mmu_notifier_range *=
range)
>  {
>         struct kvm *kvm =3D mmu_notifier_to_kvm(mn);
> -       const struct kvm_hva_range hva_range =3D {
> +       const struct kvm_mmu_notifier_range hva_range =3D {
>                 .start          =3D range->start,
>                 .end            =3D range->end,
>                 .handler        =3D (void *)kvm_null_fn,
> --
> 2.42.0.820.g83a721a137-goog
>

