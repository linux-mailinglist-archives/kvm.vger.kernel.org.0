Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A005E204D29
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 10:56:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731914AbgFWI42 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 04:56:28 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:22173 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731687AbgFWI41 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 23 Jun 2020 04:56:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592902586;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3uH2ase3wNwFDCFATNF+XbECQJVAVscMNWry+4f/1Ps=;
        b=i4bKXcKQ2XYmYzUXlNwnaRzZZ2bf5AnnGdvRX47r77JE2HFeMLVcpqHx734IfphaGdfGGp
        PeAjwyNXty+RLHTjAbJcdHwgT13T2NY2gy+iqkDOELqbAHQnWAnXgHhb+UMCsEXaBqVG3v
        r+hOFiaRqHku3HGTD9a1/arG1ICjbhw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-56-CCUZqEhzP9-5hGeoayuAiQ-1; Tue, 23 Jun 2020 04:56:23 -0400
X-MC-Unique: CCUZqEhzP9-5hGeoayuAiQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C4CE918A0765;
        Tue, 23 Jun 2020 08:56:20 +0000 (UTC)
Received: from localhost (ovpn-112-109.ams2.redhat.com [10.36.112.109])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A1E006E9F3;
        Tue, 23 Jun 2020 08:56:18 +0000 (UTC)
Date:   Tue, 23 Jun 2020 09:56:17 +0100
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Andra Paraschiv <andraprs@amazon.com>
Cc:     linux-kernel@vger.kernel.org,
        Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        Bjoern Doebel <doebel@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Frank van der Linden <fllinden@amazon.com>,
        Alexander Graf <graf@amazon.de>,
        Greg KH <gregkh@linuxfoundation.org>,
        Martin Pohlack <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Balbir Singh <sblbir@amazon.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Stewart Smith <trawets@amazon.com>,
        Uwe Dannowski <uwed@amazon.de>, kvm@vger.kernel.org,
        ne-devel-upstream@amazon.com
Subject: Re: [PATCH v4 01/18] nitro_enclaves: Add ioctl interface definition
Message-ID: <20200623085617.GE32718@stefanha-x1.localdomain>
References: <20200622200329.52996-1-andraprs@amazon.com>
 <20200622200329.52996-2-andraprs@amazon.com>
MIME-Version: 1.0
In-Reply-To: <20200622200329.52996-2-andraprs@amazon.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=stefanha@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ILuaRSyQpoVaJ1HG"
Content-Disposition: inline
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--ILuaRSyQpoVaJ1HG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 22, 2020 at 11:03:12PM +0300, Andra Paraschiv wrote:
> diff --git a/include/uapi/linux/nitro_enclaves.h b/include/uapi/linux/nitro_enclaves.h
> new file mode 100644
> index 000000000000..3270eb939a97
> --- /dev/null
> +++ b/include/uapi/linux/nitro_enclaves.h
> @@ -0,0 +1,137 @@
> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> +/*
> + * Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
> + */
> +
> +#ifndef _UAPI_LINUX_NITRO_ENCLAVES_H_
> +#define _UAPI_LINUX_NITRO_ENCLAVES_H_
> +
> +#include <linux/types.h>
> +
> +/* Nitro Enclaves (NE) Kernel Driver Interface */
> +
> +#define NE_API_VERSION (1)
> +
> +/**
> + * The command is used to get the version of the NE API. This way the user space
> + * processes can be aware of the feature sets provided by the NE kernel driver.
> + *
> + * The NE API version is returned as result of this ioctl call.
> + */
> +#define NE_GET_API_VERSION _IO(0xAE, 0x20)
> +
> +/**
> + * The command is used to create a slot that is associated with an enclave VM.
> + *
> + * The generated unique slot id is a read parameter of this command. An enclave
> + * file descriptor is returned as result of this ioctl call. The enclave fd can
> + * be further used with ioctl calls to set vCPUs and memory regions, then start
> + * the enclave.
> + */
> +#define NE_CREATE_VM _IOR(0xAE, 0x21, __u64)

Information that would be useful for the ioctls:

1. Which fd the ioctl must be invoked on (/dev/nitro-enclaves, enclave fd, vCPU fd)

2. Errnos and their meanings

3. Which state(s) the ioctls may be invoked in (e.g. enclave created/started/etc)

> +/* User memory region flags */
> +
> +/* Memory region for enclave general usage. */
> +#define NE_DEFAULT_MEMORY_REGION (0x00)
> +
> +/* Memory region to be set for an enclave (write). */
> +struct ne_user_memory_region {
> +	/**
> +	 * Flags to determine the usage for the memory region (write).
> +	 */
> +	__u64 flags;

Where is the write flag defined?

I guess it's supposed to be:

  #define NE_USER_MEMORY_REGION_FLAG_WRITE (0x01)

--ILuaRSyQpoVaJ1HG
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl7xw7EACgkQnKSrs4Gr
c8hwxQgAi3YUJ25wbsEdkGotyLSdG2c5mOoYfxYMfBJ6YXKB2gfDGUkJoWf2w3y+
K7kP5vtCrPxZ+D1dfkPmyftRkocDFbzIS71EqbD14bMDKjPdvDjNI25XCCWpJf7I
8rGr+HTzqq6w/W93LkGjUDNr0eNReyOXihvzWFmtiorGlqQt61XBoncwL4fr8tI2
PpFjfJQ1yg5og8uxefvtJ9g8dChliP+WoRDDrqxoUSC39YZ4rVRS/jGF2UkQzw7S
oE5S/T7ktI3Cu0x118OBHcVgNWwsWOPr/y52jbfUvTT0huZIlKKQfVSlj1saA6sa
kGgFRv5JEYZkA/HHds91GHeKtGnbIQ==
=059p
-----END PGP SIGNATURE-----

--ILuaRSyQpoVaJ1HG--

