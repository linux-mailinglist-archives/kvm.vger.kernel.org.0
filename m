Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E62262D274F
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 10:18:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728608AbgLHJRs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Dec 2020 04:17:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726435AbgLHJRs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Dec 2020 04:17:48 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B68CC061749
        for <kvm@vger.kernel.org>; Tue,  8 Dec 2020 01:17:02 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id t8so13336646pfg.8
        for <kvm@vger.kernel.org>; Tue, 08 Dec 2020 01:17:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=11OcWmjbB5oRY7Z51HuX+/yds3UrJ+vJRw8gahuJnY0=;
        b=Rj6p3NAs9GXRmDWwmkg8Ze/1Tjhx4FZVyCZQTrB4YxgiEBV8JgNg52vWlxd+UTXIPy
         ZbIrp3TtMIS14E/39nDs2fjYjMFABrxXtBwWwM9H1/WEokWsIuZq2m9EEsGsl/aMmKVb
         cvPTPSqlKfzGR2LLtQmSgBiUmc9vBSHPRFDbDVNhFiIhOt0giUYvNq29aBdgN7Nd1Dl9
         RTxBd/y/IhIJatPJcE1ROsunnafZZKYSLGHcDarvE5ZUlGgrCgMl4IaQp7zkPDAOpwr7
         oBQjF6Cl7eeOEi6vT6Rf1ozTlFhYzd/mMUQGYTcxLjQbTzQZrZWC/M8kDegJVh+wu9Po
         TaFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=11OcWmjbB5oRY7Z51HuX+/yds3UrJ+vJRw8gahuJnY0=;
        b=c5fqrTt9uJ3GUCc5lQuhYwzVSpyp18w8thCfemH2nvgElAyGggn8+n0Fw7hS1o69T0
         p0XcOwTAOFpsoHhn43zffsMRRUIVO25lOZDykbED/itQmOb0K1jxKe4gj7LOhYFTaERu
         qq7UbJkFDBXDbGpvVyXXVjCcCRCbcqbvOegGTwvFvLbWhcy4SWg6Ld5KEw99HddUtV0Z
         FFDROLMB9q0O4ncxjZKDU5pyhbeVlOEaAc5ESjoj5GB3QmWgq1vAe5g5XGc7UGcIqZpr
         1UeoDRjTvlFdSkhcEESwbImkyjMXsRkN3hbiXJGxzjy9gY7jVHDf4ojO9SRpc1Nw/Hz3
         ASpQ==
X-Gm-Message-State: AOAM531txEjH1H9jVjT8YtXFN+Z5pHKNSZp2bNKn76+OuHZLmXL79Jqr
        TtnzsszIvOghKGq3t7DTOIQ=
X-Google-Smtp-Source: ABdhPJw6JUcmoRhPu/wrws4Pbgfsir/h0JSX2+9qiTh6vum1b+eyFx82dYtKY3ozBa8/J60JY1kD/Q==
X-Received: by 2002:a63:2907:: with SMTP id p7mr21788342pgp.320.1607419021393;
        Tue, 08 Dec 2020 01:17:01 -0800 (PST)
Received: from ?IPv6:2601:647:4700:9b2:5c98:e5b3:1ddc:54ce? ([2601:647:4700:9b2:5c98:e5b3:1ddc:54ce])
        by smtp.gmail.com with ESMTPSA id j11sm16403449pfe.26.2020.12.08.01.17.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Dec 2020 01:17:00 -0800 (PST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [kvm-unit-tests PATCH v2 4/7] lib/alloc_page: complete rewrite of
 the page allocator
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <20201208101155.0e2de3c9@ibm-vm>
Date:   Tue, 8 Dec 2020 01:16:59 -0800
Cc:     KVM <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>, cohuck@redhat.com,
        Laurent Vivier <lvivier@redhat.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <17D911C4-2A11-4F37-810F-48F8E3226305@gmail.com>
References: <20201002154420.292134-1-imbrenda@linux.ibm.com>
 <20201002154420.292134-5-imbrenda@linux.ibm.com>
 <C812A718-DCD6-4485-BB5A-B24DE73A0FD3@gmail.com>
 <20201208101155.0e2de3c9@ibm-vm>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Dec 8, 2020, at 1:11 AM, Claudio Imbrenda <imbrenda@linux.ibm.com> =
wrote:
>=20
> On Mon, 7 Dec 2020 16:41:18 -0800
> Nadav Amit <nadav.amit@gmail.com> wrote:
>=20
>>> On Oct 2, 2020, at 8:44 AM, Claudio Imbrenda
>>> <imbrenda@linux.ibm.com> wrote:
>>>=20
>>> This is a complete rewrite of the page allocator. =20
>>=20
>> This patch causes me crashes:
>>=20
>>  lib/alloc_page.c:433: assert failed: !(areas_mask & BIT(n))
>>=20
>> It appears that two areas are registered on AREA_LOW_NUMBER, as
>> setup_vm() can call (and calls on my system) page_alloc_init_area()
>> twice.
>=20
> which system is that? page_alloc_init_area should not be called twice
> on the same area!

It is not the =E2=80=9Csame area=E2=80=9D, it just uses the same id, see =
setup_vm():

        if (!page_alloc_initialized()) {
                base =3D PAGE_ALIGN(base) >> PAGE_SHIFT;
                top =3D top >> PAGE_SHIFT;

		// FIRST
                page_alloc_init_area(AREA_ANY_NUMBER, base, top);
                page_alloc_ops_enable();
        }

        find_highmem();
        phys_alloc_get_unused(&base, &top);
        page_root =3D setup_mmu(top);
        if (base !=3D top) {
                base =3D PAGE_ALIGN(base) >> PAGE_SHIFT;
                top =3D top >> PAGE_SHIFT;

		// SECOND
                page_alloc_init_area(AREA_ANY_NUMBER, base, top);
        }

The problem occurs when I run KVM-unit-tests on VMware, but would =
presumably
also happen on bare-metal.

>=20
>> setup_vm() uses AREA_ANY_NUMBER as the area number argument but
>> eventually this means, according to the code, that
>> __page_alloc_init_area() would use AREA_LOW_NUMBER.
>>=20
>> I do not understand the rationale behind these areas well enough to
>> fix it.
>=20
> I'll see what I can fix

Thanks,
Nadav

