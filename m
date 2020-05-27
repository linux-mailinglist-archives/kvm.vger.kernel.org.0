Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A04E01E3C9B
	for <lists+kvm@lfdr.de>; Wed, 27 May 2020 10:51:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388247AbgE0IuE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 May 2020 04:50:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388075AbgE0IuD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 May 2020 04:50:03 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35252C061A0F;
        Wed, 27 May 2020 01:50:03 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id t18so9112810wru.6;
        Wed, 27 May 2020 01:50:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+9kBhKIDtW+ZxWUmIeYFLRWCnO57gv4RzLSn5WOvXRM=;
        b=OFo4I+TaLb0OZtCkqTOcgtGy07oPtsd/ZuB00Kur6c1xaBXXekdDOB4Vnz+0G/OSq1
         qYn6EShJr/P3GMU90WKQ5RH9aJh0UC5/BAr+htwHluFvCsFlWZE675Zp6mo1ClOcJG5s
         bY4I1iUM74QpevBqDYtHozEp/wvFN4AFKwJULn5ETJDP+nmx1+o3Xbef46BY5jIgwvL8
         C/TIc+VPXpldt9+jGieqiLCFLXr5lIYTEvJyJw7AjZmugxgBqfl91k8sbIVNVL4vp24I
         jDQ7vp6WeXg/MePpvrtkeEsCJ8MAeozuEfbbbbF84dXI+OL+ASuHdwlbFFz6tDQc/OSh
         qmuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+9kBhKIDtW+ZxWUmIeYFLRWCnO57gv4RzLSn5WOvXRM=;
        b=TgCu9kl0p+3ZO/5/bucMPd6bdzZh9xU+1GbfzeyusfCPn+tG36taJtgo2tDxq/vXox
         f1FRDteWwvuC7mkqcBtTEYsARpK4kTilYm5f8gIefNh1lJiNf+H5Q8P4OmXAWG+xS8Fv
         /4SV67MJttzN/lu2tePneoI6KjpitDeEMUo8wz42Np1F9OgBTwmx+eZjmfFvTB97zWJ2
         TNVy5SoIKTTUqF80eD9u9bdnodUwH4STGEGouOAtMnbTCjIOH4Phlci2jHnvllyk0/TT
         /seLq96sarqCrRaFPbBPHmV+8CKOg4WL1V/DawEeNSA6tyTqbJqm90ArT4StWDxM/23T
         gFpw==
X-Gm-Message-State: AOAM533YFjw/o+qBD02n3CIEjGbeBCdQMxgI9VGcsVl7sUAKm1kAd1XM
        U1KexwTl1F+POc7qI3bW/Bk=
X-Google-Smtp-Source: ABdhPJzNHB5+4AYdG1qbbHaXmHj9IE2XCiwvXkwA52VYJLKAFDe+Is5zLxb/qF26m34eLUMf98PQsA==
X-Received: by 2002:a5d:4090:: with SMTP id o16mr12360488wrp.354.1590569401809;
        Wed, 27 May 2020 01:50:01 -0700 (PDT)
Received: from localhost ([51.15.41.238])
        by smtp.gmail.com with ESMTPSA id b9sm2190368wrt.39.2020.05.27.01.50.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2020 01:50:00 -0700 (PDT)
Date:   Wed, 27 May 2020 09:49:59 +0100
From:   Stefan Hajnoczi <stefanha@gmail.com>
To:     Andra Paraschiv <andraprs@amazon.com>
Cc:     linux-kernel@vger.kernel.org,
        Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        Bjoern Doebel <doebel@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Frank van der Linden <fllinden@amazon.com>,
        Alexander Graf <graf@amazon.de>,
        Martin Pohlack <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Balbir Singh <sblbir@amazon.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stewart Smith <trawets@amazon.com>,
        Uwe Dannowski <uwed@amazon.de>, kvm@vger.kernel.org,
        ne-devel-upstream@amazon.com
Subject: Re: [PATCH v3 01/18] nitro_enclaves: Add ioctl interface definition
Message-ID: <20200527084959.GA29137@stefanha-x1.localdomain>
References: <20200525221334.62966-1-andraprs@amazon.com>
 <20200525221334.62966-2-andraprs@amazon.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="vkogqOf2sHV7VnPd"
Content-Disposition: inline
In-Reply-To: <20200525221334.62966-2-andraprs@amazon.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--vkogqOf2sHV7VnPd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 26, 2020 at 01:13:17AM +0300, Andra Paraschiv wrote:
> The Nitro Enclaves driver handles the enclave lifetime management. This
> includes enclave creation, termination and setting up its resources such
> as memory and CPU.
>=20
> An enclave runs alongside the VM that spawned it. It is abstracted as a
> process running in the VM that launched it. The process interacts with
> the NE driver, that exposes an ioctl interface for creating an enclave
> and setting up its resources.
>=20
> Include part of the KVM ioctls in the provided ioctl interface, with
> additional NE ioctl commands that e.g. triggers the enclave run.
>=20
> Signed-off-by: Alexandru Vasile <lexnv@amazon.com>
> Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
> ---
> Changelog
>=20
> v2 -> v3
>=20
> * Remove the GPL additional wording as SPDX-License-Identifier is already=
 in
> place.
>=20
> v1 -> v2
>=20
> * Add ioctl for getting enclave image load metadata.
> * Update NE_ENCLAVE_START ioctl name to NE_START_ENCLAVE.=20
> * Add entry in Documentation/userspace-api/ioctl/ioctl-number.rst for NE =
ioctls.
> * Update NE ioctls definition based on the updated ioctl range for major =
and
> minor.
> ---
>  .../userspace-api/ioctl/ioctl-number.rst      |  5 +-
>  include/linux/nitro_enclaves.h                | 11 ++++
>  include/uapi/linux/nitro_enclaves.h           | 65 +++++++++++++++++++
>  3 files changed, 80 insertions(+), 1 deletion(-)
>  create mode 100644 include/linux/nitro_enclaves.h
>  create mode 100644 include/uapi/linux/nitro_enclaves.h
>=20
> diff --git a/Documentation/userspace-api/ioctl/ioctl-number.rst b/Documen=
tation/userspace-api/ioctl/ioctl-number.rst
> index f759edafd938..8a19b5e871d3 100644
> --- a/Documentation/userspace-api/ioctl/ioctl-number.rst
> +++ b/Documentation/userspace-api/ioctl/ioctl-number.rst
> @@ -325,8 +325,11 @@ Code  Seq#    Include File                          =
                 Comments
>  0xAC  00-1F  linux/raw.h
>  0xAD  00                                                             Net=
filter device in development:
>                                                                       <ma=
ilto:rusty@rustcorp.com.au>
> -0xAE  all    linux/kvm.h                                             Ker=
nel-based Virtual Machine
> +0xAE  00-1F  linux/kvm.h                                             Ker=
nel-based Virtual Machine
>                                                                       <ma=
ilto:kvm@vger.kernel.org>
> +0xAE  40-FF  linux/kvm.h                                             Ker=
nel-based Virtual Machine
> +                                                                     <ma=
ilto:kvm@vger.kernel.org>
> +0xAE  20-3F  linux/nitro_enclaves.h                                  Nit=
ro Enclaves
>  0xAF  00-1F  linux/fsl_hypervisor.h                                  Fre=
escale hypervisor
>  0xB0  all                                                            RAT=
IO devices in development:
>                                                                       <ma=
ilto:vgo@ratio.de>

Reusing KVM ioctls seems a little hacky. Even the ioctls that are used
by this driver don't use all the fields or behave in the same way as
kvm.ko.

For example, the memory regions slot number is not used by Nitro
Enclaves.

It would be cleaner to define NE-specific ioctls instead.

> diff --git a/include/linux/nitro_enclaves.h b/include/linux/nitro_enclave=
s.h
> new file mode 100644
> index 000000000000..d91ef2bfdf47
> --- /dev/null
> +++ b/include/linux/nitro_enclaves.h
> @@ -0,0 +1,11 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserve=
d.
> + */
> +
> +#ifndef _LINUX_NITRO_ENCLAVES_H_
> +#define _LINUX_NITRO_ENCLAVES_H_
> +
> +#include <uapi/linux/nitro_enclaves.h>
> +
> +#endif /* _LINUX_NITRO_ENCLAVES_H_ */
> diff --git a/include/uapi/linux/nitro_enclaves.h b/include/uapi/linux/nit=
ro_enclaves.h
> new file mode 100644
> index 000000000000..3413352baf32
> --- /dev/null
> +++ b/include/uapi/linux/nitro_enclaves.h
> @@ -0,0 +1,65 @@
> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> +/*
> + * Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserve=
d.
> + */
> +
> +#ifndef _UAPI_LINUX_NITRO_ENCLAVES_H_
> +#define _UAPI_LINUX_NITRO_ENCLAVES_H_
> +
> +#include <linux/kvm.h>
> +#include <linux/types.h>
> +
> +/* Nitro Enclaves (NE) Kernel Driver Interface */
> +
> +/**
> + * The command is used to get information needed for in-memory enclave i=
mage
> + * loading e.g. offset in enclave memory to start placing the enclave im=
age.
> + *
> + * The image load metadata is an in / out data structure. It includes in=
fo
> + * provided by the caller - flags - and returns the offset in enclave me=
mory
> + * where to start placing the enclave image.
> + */
> +#define NE_GET_IMAGE_LOAD_METADATA _IOWR(0xAE, 0x20, struct image_load_m=
etadata)
> +
> +/**
> + * The command is used to trigger enclave start after the enclave resour=
ces,
> + * such as memory and CPU, have been set.
> + *
> + * The enclave start metadata is an in / out data structure. It includes=
 info
> + * provided by the caller - enclave cid and flags - and returns the slot=
 uid
> + * and the cid (if input cid is 0).
> + */
> +#define NE_START_ENCLAVE _IOWR(0xAE, 0x21, struct enclave_start_metadata)
> +

image_load_metadata->flags and enclave_start_metadata->flags constants
are missing.

> +/* Metadata necessary for in-memory enclave image loading. */
> +struct image_load_metadata {
> +	/**
> +	 * Flags to determine the enclave image type e.g. Enclave Image Format
> +	 * (EIF) (in).
> +	 */
> +	__u64 flags;
> +
> +	/**
> +	 * Offset in enclave memory where to start placing the enclave image
> +	 * (out).
> +	 */
> +	__u64 memory_offset;
> +};

What about feature bits or a API version number field? If you add
features to the NE driver, how will userspace detect them?

Even if you intend to always compile userspace against the exact kernel
headers that the program will run on, it can still be useful to have an
API version for informational purposes and to easily prevent user
errors (running a new userspace binary on an old kernel where the API is
different).

Finally, reserved struct fields may come in handy in the future. That
way userspace and the kernel don't need to explicitly handle multiple
struct sizes.

--vkogqOf2sHV7VnPd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl7OKbcACgkQnKSrs4Gr
c8jJVAgAo7KasfyNLaEi6MJPaDQp8v3M/aDIOEGPQsQ7f9cGH63De1A98S9ZOa/s
derpLcBDuMKFpTbU8QOUI4ihiiFRQR6KYRRsmvNkxWDi7bdF9NpNILhvN991gLQT
ui6GfLtCSuYkhdYS5gxg6AQ2kEHT6eGqA/lmXDnfe5pmPg0rOZV+QhhSxq7i6THO
UpnqPRAch2uA2TMRZfx6HX7tK+yUlPqlzS3lrxmzVVA3ixZY5uHgsAX0IvKLkUna
T056VDXxl+B1O3GmxpfXEyw+TQee5nJG8D3xYs7+QTeIa9YDyfua3C0UsufxGZiT
jv0DHwuj5R3uGbJTNwJ/hYeu5+9exg==
=nwyo
-----END PGP SIGNATURE-----

--vkogqOf2sHV7VnPd--
