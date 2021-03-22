Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5592C343D59
	for <lists+kvm@lfdr.de>; Mon, 22 Mar 2021 10:58:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230107AbhCVJ6R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Mar 2021 05:58:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbhCVJ56 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Mar 2021 05:57:58 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5679FC061574
        for <kvm@vger.kernel.org>; Mon, 22 Mar 2021 02:57:58 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id u9so20170860ejj.7
        for <kvm@vger.kernel.org>; Mon, 22 Mar 2021 02:57:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=P0QAXuCmts5nE3ESdV8lYHLckh0ybLMuYvMaZIn2D7U=;
        b=OqN+B7P6eW08diIVq0r0952GPj31BMbFIrvyAkocB4mKiKbGRJIZWDWEsWnLPNwqzi
         Hg0eLb8lfSv419GEVxkR4x3//0lKR2nZdrusKfTAI6z1C8Yd9XKTh/YrXvL13uYS/tbb
         vPwhX1QkwLJV8Oqu50VmArBSDNzRCozuDHwmgVKmh7rPtG+WewEdPB0uy8czug9XqfEf
         /vuSKxDrvVrk53v1RKQ50UoSSHpKVvkLQLLYNsNT6BJ82GCT6cJExunXK/Nx1UqlFOEM
         GbR21YS9x167FmCMJzCmSsetFN2A35d8zjHGvdYybPx4pWaMvd+Div8NmR7dlZuCHNZB
         WpkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=P0QAXuCmts5nE3ESdV8lYHLckh0ybLMuYvMaZIn2D7U=;
        b=Xlh/La9dlRFJUE0hXrrL4lZteIm/sV47wVTc5n9pvaxNJFPe1+QJrDaVBXEh+ul73O
         YMMQjxFb3fQFJM48DrG/F6Hxghb4jxazjXzsi0JUqOj7dMNhIdOanQ4MflnbE1h+2HRK
         qaF6XHd/+Sf1JagVTzF4llYTIcLrbsdOcr69DxOO5iaPqWo7BbJgLjRsG92FycnLYy6c
         7GE4p8FFeJr/HfE3Bl5w0CTbPkcupW8wE0PCR+6GHaNwNvz4I7kw+JIkzrvhcPbrc619
         hLQFRaNZV7cwGHWiLd2eCWjXD5VWonXYoRGJQCXlFH5e59Y3JuvLOrrMFEW3WBvkrXdG
         tzAg==
X-Gm-Message-State: AOAM532Vwb9fqm0HIw0/gmdOs9W/7/fV6+L7WSzhCyk1Zb1F2yWoc5uf
        yHcziyaFmmPPWHilzNq6S5I=
X-Google-Smtp-Source: ABdhPJyfUQtMq3kRJ4oeLnqpl0IsDUF6h3ev/DbS6SDHxqknAL2MG/K49OltshTijuFVHI0zYhEhtA==
X-Received: by 2002:a17:906:3643:: with SMTP id r3mr18050096ejb.527.1616407077154;
        Mon, 22 Mar 2021 02:57:57 -0700 (PDT)
Received: from localhost ([51.15.41.238])
        by smtp.gmail.com with ESMTPSA id mp12sm1169595ejc.1.2021.03.22.02.57.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 02:57:56 -0700 (PDT)
Date:   Mon, 22 Mar 2021 09:57:55 +0000
From:   Stefan Hajnoczi <stefanha@gmail.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Elena Afanasova <eafanasova@gmail.com>, kvm@vger.kernel.org,
        stefanha@redhat.com, jag.raman@oracle.com,
        elena.ufimtseva@oracle.com, pbonzini@redhat.com, mst@redhat.com,
        cohuck@redhat.com, john.levon@nutanix.com
Subject: Re: [RFC v3 1/5] KVM: add initial support for KVM_SET_IOREGION
Message-ID: <YFhqI8TalF+hrITi@stefanha-x1.localdomain>
References: <cover.1613828726.git.eafanasova@gmail.com>
 <f77bbc58289508b5b0633521cf8c03eb0303707a.1613828727.git.eafanasova@gmail.com>
 <41e24c31-8742-099d-5011-9b762faa8670@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="OXW/M84r6wQED4nL"
Content-Disposition: inline
In-Reply-To: <41e24c31-8742-099d-5011-9b762faa8670@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--OXW/M84r6wQED4nL
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 09, 2021 at 01:26:48PM +0800, Jason Wang wrote:
> On 2021/2/21 8:04 =E4=B8=8B=E5=8D=88, Elena Afanasova wrote:
> > @@ -1308,6 +1332,7 @@ struct kvm_vfio_spapr_tce {
> >   					struct kvm_userspace_memory_region)
> >   #define KVM_SET_TSS_ADDR          _IO(KVMIO,   0x47)
> >   #define KVM_SET_IDENTITY_MAP_ADDR _IOW(KVMIO,  0x48, __u64)
> > +#define KVM_SET_IOREGION          _IOW(KVMIO,  0x49, struct kvm_ioregi=
on)
>=20
>=20
> I wonder how could we extend ioregion fd in the future? Do we need someth=
ing
> like handshake or version here?

The struct kvm_ioregion->flags field can be used to enable optional
features. KVM capabilities can be used to test the presence of optional
features. This might be enough.

A different approach to extensibility is a sizeof(struct kvm_ioregion)
field for arbitrary extensions to the struct.

> > +static int
> > +kvm_set_ioregion(struct kvm *kvm, struct kvm_ioregion *args)
> > +{
> > +	int ret;
> > +
> > +	enum kvm_bus bus_idx =3D get_bus_from_flags(args->flags);
> > +
> > +	/* check for range overflow */
> > +	if (args->guest_paddr + args->memory_size < args->guest_paddr)
> > +		return -EINVAL;
> > +	/* If size is ignored only posted writes are allowed */
> > +	if (!args->memory_size && !(args->flags & KVM_IOREGION_POSTED_WRITES))
>=20
>=20
> We don't have flags like KVM_IOREGION_POSTED_WRITES for ioeventfd. Is thi=
s a
> must?

There is no way to trigger a FAST_MMIO read. Guest accesses, including
memory loads, appear as writes.

Stefan

--OXW/M84r6wQED4nL
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmBYaiMACgkQnKSrs4Gr
c8h2KQf/WNWoE+TrSimHeHjbnZesd0ucb9UYtrQtVpWQDObJ4l3Bx+FOpKGgHkx8
yeZzimbmz96CBkyVNheJjfKN/zyaJePBvaZZnD/WGD5WOd8wYHN7XLi1q7+xkpph
FElVo3opHnfsG/4T/gdc8BtalRE7H+vEj2QFe1kHp/h9n/hhVmxBeXUQ5efPeQmJ
7d9vuJGaK8fKgIUm/LtfpL3xKlOwFZRg4u2X1Prd9fe2LCVRPE65yV8qGl014GtM
fjxiqbfr+LLkgV+huG2J1D0TT4jwbE3VRGnR5Jtk7S32vNCgnyrpGi655yO8TM2L
eZCLTroOQr0T9qI+z14Kc1HdPb4D6g==
=FnRp
-----END PGP SIGNATURE-----

--OXW/M84r6wQED4nL--
