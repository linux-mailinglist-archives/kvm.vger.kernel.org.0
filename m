Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65BA9221D0C
	for <lists+kvm@lfdr.de>; Thu, 16 Jul 2020 09:11:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728212AbgGPHLg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jul 2020 03:11:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725921AbgGPHLg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jul 2020 03:11:36 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 467BFC061755
        for <kvm@vger.kernel.org>; Thu, 16 Jul 2020 00:11:36 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id a14so3255655pfi.2
        for <kvm@vger.kernel.org>; Thu, 16 Jul 2020 00:11:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=vcHZiOtRWbNFoSHPYD2doddbtKLBAtgI/PXZZ2P7grY=;
        b=ecqbXeJl95gSBxnQ4wKXDH8VW5JRC6TxnLqHWTjeWrxXZWXFSg3W9qoky4rIaLTx8Q
         0NlDnUJTFg+ghyis44OFH8PE6IiCiuv9MCdCCSWhTD24q7V0UVFwPk7c120VaKXUb54J
         k0RxEm3FYWNMxvcjSFQDnbrB3xotqSegpguE+osh6gNCTH6eVA4acU+d+Iojkn+jInot
         5gHvqP0qy8QSEOhUgjUZEQeYht4WSb9iVl39bydjvZoKIwZ68qKp/uvhm7ZX8fHtBH+B
         3kcaMfazD4h801spPauHYm3e7regdtyyhk+t8we4dTsiKW1czfUYq8CD0Ujz7fvKAZs6
         inQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=vcHZiOtRWbNFoSHPYD2doddbtKLBAtgI/PXZZ2P7grY=;
        b=n8L64IHIwXurXUsIU3GV5UxGyLlvHbZ5l2qvh44QdRZR7pZO7lSE9Lz0BQ3DvnLd8v
         wXsl91Oq3hTzO0cRRftaGEJ0qVK1wy8xclbQxHYJf+MJltP6ClYkJEFLeFmFf4HfY0ey
         wP6lpugfPUdwS7DInV+EaIbpn59N4odRYB843JjSbpIkkU26KOOcAm/O42fF1EXs3Cjv
         8L00YbaqP9EByOXe4cuNMvYicVPYXoCWrjkf0mmMxjnQXlTlWZ60RD/+cqjqo9lVnD9H
         m89bC1DSQgSKaPZ012RPIDaMj6Eed66CYoiQOHf2MGaTxjfRE5p5ckqi9H1KS2fvzYEg
         SdSQ==
X-Gm-Message-State: AOAM533aUfzrxCuwg7MigCUNWBNMGlPFSOdBJrRrN24nBceoifVyD65k
        1g+o/C+vDrEyZQ3+jTH7UP0=
X-Google-Smtp-Source: ABdhPJy1VfJn7LQ7zcD/YxYnyJNgBqWzPWGpkWYds3J0RhndcyCQ5vDcHLLbqIyzBKv/dO7/XwmThw==
X-Received: by 2002:a63:af50:: with SMTP id s16mr3203787pgo.365.1594883495755;
        Thu, 16 Jul 2020 00:11:35 -0700 (PDT)
Received: from ?IPv6:2601:647:4700:9b2:3dfe:7232:64d9:57dc? ([2601:647:4700:9b2:3dfe:7232:64d9:57dc])
        by smtp.gmail.com with ESMTPSA id n22sm3892279pjq.25.2020.07.16.00.11.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 16 Jul 2020 00:11:34 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [kvm-unit-tests PATCH v2 2/2] lib/alloc_page: Fix compilation
 issue on 32bit archs
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <20200714130030.56037-3-imbrenda@linux.ibm.com>
Date:   Thu, 16 Jul 2020 00:11:31 -0700
Cc:     kvm <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        frankja@linux.ibm.com, Thomas Huth <thuth@redhat.com>,
        David Hildenbrand <david@redhat.com>, drjones@redhat.com,
        Jim Mattson <jmattson@google.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <7F765FA6-FC63-4D82-BB13-00EF133CB031@gmail.com>
References: <20200714130030.56037-1-imbrenda@linux.ibm.com>
 <20200714130030.56037-3-imbrenda@linux.ibm.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Jul 14, 2020, at 6:00 AM, Claudio Imbrenda <imbrenda@linux.ibm.com> =
wrote:
>=20
> The assert in lib/alloc_page is hardcoded to long.
>=20
> Use the z modifier instead, which is meant to be used for size_t.
>=20
> Fixes: 73f4b202beb39 ("lib/alloc_page: change some parameter types")
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
> lib/alloc_page.c | 4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/lib/alloc_page.c b/lib/alloc_page.c
> index fa3c527..74fe726 100644
> --- a/lib/alloc_page.c
> +++ b/lib/alloc_page.c
> @@ -29,11 +29,11 @@ void free_pages(void *mem, size_t size)
> 	assert_msg((unsigned long) mem % PAGE_SIZE =3D=3D 0,
> 		   "mem not page aligned: %p", mem);
>=20
> -	assert_msg(size % PAGE_SIZE =3D=3D 0, "size not page aligned: =
%#lx", size);
> +	assert_msg(size % PAGE_SIZE =3D=3D 0, "size not page aligned: =
%#zx", size);
>=20
> 	assert_msg(size =3D=3D 0 || (uintptr_t)mem =3D=3D -size ||
> 		   (uintptr_t)mem + size > (uintptr_t)mem,
> -		   "mem + size overflow: %p + %#lx", mem, size);
> +		   "mem + size overflow: %p + %#zx", mem, size);
>=20
> 	if (size =3D=3D 0) {
> 		freelist =3D NULL;
> =E2=80=94=20
> 2.26.2

Sean sent a different patch ("lib/alloc_page: Revert to 'unsigned =
long=E2=80=99 for
@size params=E2=80=9D) that changes size to unsigned long, so you really =
should
synchronize.

