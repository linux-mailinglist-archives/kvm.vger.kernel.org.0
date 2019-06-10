Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E2A83B510
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2019 14:31:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389969AbfFJMba (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jun 2019 08:31:30 -0400
Received: from mail-wm1-f46.google.com ([209.85.128.46]:33760 "EHLO
        mail-wm1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389471AbfFJMba (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jun 2019 08:31:30 -0400
Received: by mail-wm1-f46.google.com with SMTP id h19so8929615wme.0
        for <kvm@vger.kernel.org>; Mon, 10 Jun 2019 05:31:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=IjpimLjNefix7x3flOvXNEk6zefatMK0PGpeIrgIb3k=;
        b=Ejgri7j44FuY6xZ6KeVRiQxwmyqRBGL482TNAsxgZtJPVwdRfZ0oXJaadcJo+7wsp5
         mTJ6dX03m8sma/AvSozIC6UIxHgtgjFIiG8s62Abp2wkg9CT1i++ScTC0UMkij1/BLnp
         6Xnqeq0k2IT0ADbQym2Z4aMFITv4IWqxfGiL6f1FCLrpExbImQcULqAChKGmGtBec37F
         AzbuFvCJTm02MJ8pCrc10gDTGW29OjRYR+V2Un4JcJ/gdxse/K/HzKikD6dFj5p/Asn/
         1mrlqI3qttR7Q3SRg9Oq+2V8U9N9qzJYnzB8Jz2rRn4Vwafk0/x/FXXDvce6/uAlSSQx
         ogJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=IjpimLjNefix7x3flOvXNEk6zefatMK0PGpeIrgIb3k=;
        b=HoNDJzYZSKFFopgIqFr1ul/OtwWFvDT9hqt1We7SUQ0M7iL4wFrOnbLn/wi7lXwart
         yzeYV915PzLj+8SlUPmnmIgkN95jABMSpDywGuu+FMBIpr1lJ+v5rVB949Cst2a0iS34
         +Vh9F9oP7CtzSA5r31DMFqGYbvfYIlWMPHgYjSrhqRDfh2wdTPVreG2jcle1lImm+Cla
         gxuIZpqlRQ0B76iQRjkHchyekIhDT2HTQh8olYkJvwhSLBFU6RT8vcFvzuoEZXPx9dG9
         mjmWU+84fufoqtxAoWuRL+xiMEcOi685Gm92Vcj3qOHRwMxo2uvrSeCIALi2wWWbawrc
         DISg==
X-Gm-Message-State: APjAAAU2rq0/mVJSHJ8voEpwY9XnrMCTTKCC6JHGqjoLY21oBzntONu3
        dhhLTQ7YoreyuVrPwuj5QCtxcZ1/baiKCg==
X-Google-Smtp-Source: APXvYqwZdM2XZWrWGgi9MJzqc+Xb5twIIZ/QRNYuKvIjyshJSkiBFIrlUrQGC9bvkYEWqCco6j8gRA==
X-Received: by 2002:a1c:678a:: with SMTP id b132mr12919400wmc.17.1560169888614;
        Mon, 10 Jun 2019 05:31:28 -0700 (PDT)
Received: from localhost ([51.15.41.238])
        by smtp.gmail.com with ESMTPSA id a2sm6508308wmj.9.2019.06.10.05.31.27
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 10 Jun 2019 05:31:27 -0700 (PDT)
Date:   Mon, 10 Jun 2019 13:31:26 +0100
From:   Stefan Hajnoczi <stefanha@gmail.com>
To:     ivo welch <ivo.welch@ucla.edu>
Cc:     kvm@vger.kernel.org
Subject: Re: need developer for small project
Message-ID: <20190610123126.GJ14257@stefanha-x1.localdomain>
References: <CAJrNScSLdAu=3Hh32mcG2nYvhby0U=Jy4UQ3h3pGbuJ0p0PCaA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="W13SgbpmD6bhZUTM"
Content-Disposition: inline
In-Reply-To: <CAJrNScSLdAu=3Hh32mcG2nYvhby0U=Jy4UQ3h3pGbuJ0p0PCaA@mail.gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--W13SgbpmD6bhZUTM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jun 09, 2019 at 11:24:19AM -0700, ivo welch wrote:
> I would like to hire someone to do some open source surgery.
> specifically, I would like someone to modify the disk driver to allow
> me to add some basic standalone hooks.  every time a guest wants to
> read or write a sector to the drive, I want my own C routines on the
> host to be called.  my C routines, in a separate standalone file,
> should have the ability to do such things as log the request, rewrite
> the request (e.g., write to a different sector and/or use my own
> hashing encryption/decryption etc), and/or tell the disk driver not to
> execute the request but return an error.  ideally, I don't need to
> learn kvm internals, but get a standalone template with example use.
> comp negotiable.

Take a look at nbdkit (https://github.com/libguestfs/nbdkit).  You don't
need to learn QEMU or KVM internals.  Run an NBD server and use it as
the disk for the guest.  You are in full control of the NBD server (for
example, by writing an nbdkit plugin) and can therefore implement the
things you've described.

I'm just pointing you at this because it may already do what you need.
I'm not available for contracting.

Good luck,
Stefan

--W13SgbpmD6bhZUTM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAlz+TZ4ACgkQnKSrs4Gr
c8h6VggAt0sCNUbsQRnoJXsfDQTPpTnkw3x7MeyESaOEj3ixzNKGy1iEd+11xg3v
JYfTOPrLyClzMrTlv5ztJ5lcUoycusOJM/saimg4OSHJ9lmF9AJkZvGFL6asYqBn
i2TtZjjRjnp2VCdbmUfznQDYCATVJxPO0ROvBqXrwzDhcqThQ+m8zeqjobSRCkpy
NEjEs8QXlUyn4ZwU65/2Ls5H7ULPmwcFBrIUZUNVzZqq2iXM+X5BTLvRQ8061ByR
IUF4TdsQjGjaSMdw/8lOcMVaK1BfI9EPYPnfNyZY+Ya/qFwmmGwXf9ck6WiRboVB
tXDNqCwgGI92sgib0j97Ms11jnhxnA==
=7Oj5
-----END PGP SIGNATURE-----

--W13SgbpmD6bhZUTM--
