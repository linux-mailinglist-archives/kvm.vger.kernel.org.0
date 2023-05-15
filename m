Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B251703D50
	for <lists+kvm@lfdr.de>; Mon, 15 May 2023 21:07:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243974AbjEOTHh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 May 2023 15:07:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230423AbjEOTHg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 May 2023 15:07:36 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 114FD14E4B
        for <kvm@vger.kernel.org>; Mon, 15 May 2023 12:07:35 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-5340957a1f1so958254a12.1
        for <kvm@vger.kernel.org>; Mon, 15 May 2023 12:07:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684177654; x=1686769654;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xFQ6BaKkjgdTBjpn34wxJVuNtEcQXtwUwEd7418PjqE=;
        b=JuYLR5X0h/SijvimdD4P6z8hE52bUlPctx7U3AXULuAYdPapAYdXj4OHLU+jesv1e9
         MHD8Lj1brV1Npy46pM9iEXGc7wGUTxWx5S45qz+oF49+y23jmGnaSXuWfuvxKy9KlI32
         Hj3tzhYZW0L7IEI7hrXAP0QK8j1h/iBkzVacQ4G+iCXVlem0u2jrysU5Jy1+pmmQkIiS
         37u1TKNLXuqkmFNxlKyPYyrXLxlhP+oe0s01snkpX8vow2muHJ/gJ/9E3/Z8g6E6znWq
         LjYx6A8GjdqjoJArA5vnUgfV49yAKbwmFV4Q/QmYgCdQHL8+QmSU6eGY5cEBbL26CcKy
         ee8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684177654; x=1686769654;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=xFQ6BaKkjgdTBjpn34wxJVuNtEcQXtwUwEd7418PjqE=;
        b=EewPrA47nLq4VU79Li8Njf703s+wFTcT3Hr8uJ5wj5kXNmwENMpqjQj7elIiLGSt7Y
         qbBnEsaFu8cGkwtvW1c04OFALWf+wUGFWWuA941YQuDkpav0f12oRRmW2LAKcfETD+Ve
         0T8H1GFkCjzHSpZYLcL5CtlsNqXIYPFWjnvqBSJL4Bj2tRvoX9iDjKwY5a+AkwDFoac8
         o9pzKqUhY9ogcB04FeANUXfpNcOcxBJhQ+uuPa0K9bVWBzD3aL+Da5YBo15dUFr4ohBv
         /O4ILJH/nJYvW3wx0mN9s/mzwzAxNqvczA3vPRvPOVvzp5fveIGgdwNAzYUQ60NnsBWa
         VPRA==
X-Gm-Message-State: AC+VfDwKTLciBHVOX5wmp0tcLdKONqkDuACXGlaVp6Ux3zrSjN4La0aD
        v5npwqDkoI1H4cugHPIHquy2Vj/pMhw=
X-Google-Smtp-Source: ACHHUZ4P6L9nc0hf9pk7PqVX9406UpgOTZdsuzGyBat9IwfSmmaZ8nUqj18ulapGHZTegPpSzUo6g677OqY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:6b4a:0:b0:4fc:2058:fa29 with SMTP id
 g71-20020a636b4a000000b004fc2058fa29mr9542105pgc.1.1684177654484; Mon, 15 May
 2023 12:07:34 -0700 (PDT)
Date:   Mon, 15 May 2023 12:07:33 -0700
In-Reply-To: <b61d5999a4fc6d50b7e073cc3c3efa8fe79bbd94.1684097002.git.lstoakes@gmail.com>
Mime-Version: 1.0
References: <cover.1684097001.git.lstoakes@gmail.com> <b61d5999a4fc6d50b7e073cc3c3efa8fe79bbd94.1684097002.git.lstoakes@gmail.com>
Message-ID: <ZGKC9fHoE+kDs0ar@google.com>
Subject: Re: [PATCH v5 1/6] mm/gup: remove unused vmas parameter from get_user_pages()
From:   Sean Christopherson <seanjc@google.com>
To:     Lorenzo Stoakes <lstoakes@gmail.com>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>,
        David Hildenbrand <david@redhat.com>, x86@kernel.org,
        linux-sgx@vger.kernel.org, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, kvm@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        "H . Peter Anvin" <hpa@zytor.com>, Xinhui Pan <Xinhui.Pan@amd.com>,
        David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Dimitri Sivanich <dimitri.sivanich@hpe.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        John Hubbard <jhubbard@nvidia.com>,
        Christian Konig <christian.koenig@amd.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, May 14, 2023, Lorenzo Stoakes wrote:
> No invocation of get_user_pages() use the vmas parameter, so remove it.
>=20
> The GUP API is confusing and caveated. Recent changes have done much to
> improve that, however there is more we can do. Exporting vmas is a prime
> target as the caller has to be extremely careful to preclude their use
> after the mmap_lock has expired or otherwise be left with dangling
> pointers.
>=20
> Removing the vmas parameter focuses the GUP functions upon their primary
> purpose - pinning (and outputting) pages as well as performing the action=
s
> implied by the input flags.
>=20
> This is part of a patch series aiming to remove the vmas parameter
> altogether.
>=20
> Suggested-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Acked-by: David Hildenbrand <david@redhat.com>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Acked-by: Christian K=EF=BF=BDnig <christian.koenig@amd.com> (for radeon =
parts)
> Acked-by: Jarkko Sakkinen <jarkko@kernel.org>
> Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
> ---
>  arch/x86/kernel/cpu/sgx/ioctl.c     | 2 +-
>  drivers/gpu/drm/radeon/radeon_ttm.c | 2 +-
>  drivers/misc/sgi-gru/grufault.c     | 2 +-
>  include/linux/mm.h                  | 3 +--
>  mm/gup.c                            | 9 +++------
>  mm/gup_test.c                       | 5 ++---
>  virt/kvm/kvm_main.c                 | 2 +-
>  7 files changed, 10 insertions(+), 15 deletions(-)

Acked-by: Sean Christopherson <seanjc@google.com> (KVM)

> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index cb5c13eee193..eaa5bb8dbadc 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2477,7 +2477,7 @@ static inline int check_user_page_hwpoison(unsigned=
 long addr)
>  {
>  	int rc, flags =3D FOLL_HWPOISON | FOLL_WRITE;
> =20
> -	rc =3D get_user_pages(addr, 1, flags, NULL, NULL);
> +	rc =3D get_user_pages(addr, 1, flags, NULL);
>  	return rc =3D=3D -EHWPOISON;

Unrelated to this patch, I think there's a pre-existing bug here.  If gup()=
 returns
a valid page, KVM will leak the refcount and unintentionally pin the page. =
 That's
highly unlikely as check_user_page_hwpoison() is called iff get_user_pages_=
unlocked()
fails (called by hva_to_pfn_slow()), but it's theoretically possible that u=
serspace
could change the VMAs between hva_to_pfn_slow() and check_user_page_hwpoiso=
n() since
KVM doesn't hold any relevant locks at this point.

E.g. if there's no VMA during hva_to_pfn_{fast,slow}(), npages=3D=3D-EFAULT=
 and KVM
will invoke check_user_page_hwpoison().  If userspace installs a valid mapp=
ing
after hva_to_pfn_slow() but before KVM acquires mmap_lock, then gup() will =
find
a valid page.

I _think_ the fix is to simply delete this code. The bug was introduced by =
commit
fafc3dbaac64 ("KVM: Replace is_hwpoison_address with __get_user_pages").  A=
t that
time, KVM didn't check for "npages =3D=3D -EHWPOISON" from the first call t=
o
get_user_pages_unlocked().  Later on, commit 0857b9e95c1a ("KVM: Enable asy=
nc page
fault processing") reworked the caller to be:

	mmap_read_lock(current->mm);
	if (npages =3D=3D -EHWPOISON ||
	      (!async && check_user_page_hwpoison(addr))) {
		pfn =3D KVM_PFN_ERR_HWPOISON;
		goto exit;
	}

where async really means NOWAIT, so that the hwpoison use of gup() didn't s=
leep.

    KVM: Enable async page fault processing
   =20
    If asynchronous hva_to_pfn() is requested call GUP with FOLL_NOWAIT to
    avoid sleeping on IO. Check for hwpoison is done at the same time,
    otherwise check_user_page_hwpoison() will call GUP again and will put
    vcpu to sleep.

There are other potential problems too, e.g. the hwpoison call doesn't hono=
r
the recently introduced @interruptible flag.

I don't see any reason to keep check_user_page_hwpoison(), KVM can simply r=
ely on
the "npages =3D=3D -EHWPOISON" check.   get_user_pages_unlocked() is guaran=
teed to be
called with roughly equivalent flags, and the flags that aren't equivalent =
are
arguably bugs in check_user_page_hwpoison(), e.g. assuming FOLL_WRITE is wr=
ong.

TL;DR: Go ahead with this change, I'll submit a separate patch to delete th=
e
buggy KVM code.
