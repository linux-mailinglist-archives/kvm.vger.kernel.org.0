Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E791B1871E
	for <lists+kvm@lfdr.de>; Thu,  9 May 2019 10:55:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725992AbfEIIzs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 May 2019 04:55:48 -0400
Received: from mail-wr1-f51.google.com ([209.85.221.51]:36864 "EHLO
        mail-wr1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725821AbfEIIzs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 May 2019 04:55:48 -0400
Received: by mail-wr1-f51.google.com with SMTP id a12so1863947wrn.4
        for <kvm@vger.kernel.org>; Thu, 09 May 2019 01:55:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=wQu5Z2gL0wK+NXfAxHh2EB1/dvUjUq3b6ED7tJb6JLw=;
        b=Wlvv4JgOyd18z441uvcLZXT9T5pRuM/+ucM4L1IguXAICCy76Ug7W6CMESuamEk7+x
         AYkXNv9OxZLJ0IyZWd+MgTzGv2DNkdMQ+MfoPjtCAV6bxzDVcAo0POF4gjNdD8GL8zs7
         W1H8OWhOzy7Bg6wldR5bZiUW0Y5d9UfAPdD8VBbh96UIL5H35IdsCdABB27p5cNw2VDw
         BfkvWouNT4C0Uv03CYKGSdZOjTqvK7flgaRPIGQELClkGnNVrb998nsgJCCgCmFxeox5
         Qigi4SRdHceXAch/y/ZQOo30aX+CznhsTGYQPMEpvb756ktfxo2n0v28OR9DPBv2xIlZ
         SaCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=wQu5Z2gL0wK+NXfAxHh2EB1/dvUjUq3b6ED7tJb6JLw=;
        b=JgytLJQecpA0ydUyV8kj2ZcMePI4F/AfFAQhjADZ42Cb2+44dyiLycZ/PuxfCgSeQc
         /eDzD5noTZM6mARvCwkqnTYfTFaIRsPLd9CnFCTIlSRGv9RrRS5SrWh55UaNknbzEblU
         kgXRhE2ZJydojC5vKzok/T/lYfrTWKFxgdOjPbktVYMg0fsVI+rv37SE55iQWM4Es+Iv
         TtYEErb8pgVpBNJDcNJBp1MROBsf0oLE42JAib/giEbC9xe1TrYAudgMMR9IUTnurQA9
         5txc+kxYfSdU9BZq1ksOQjUdHvXJqHGvLIwbghP5BJh12HFHoG8WhuTaF58X1EJwhauA
         6f0g==
X-Gm-Message-State: APjAAAVkhEPtZVYUpZrkL+s40HuKz6Im+8gRpR+8gUpvL3nZtzgyoeEo
        CxRELXKmELYyNNvtIUtU316Oic1VvFA=
X-Google-Smtp-Source: APXvYqy95q8ZmqWtQ+vAS/k9IdTt5uWkPaXYwEM3RKRebmZHEBaToqkzhMTbOgrF7Q7qNP9fE654vA==
X-Received: by 2002:adf:f90c:: with SMTP id b12mr1995289wrr.63.1557392146242;
        Thu, 09 May 2019 01:55:46 -0700 (PDT)
Received: from localhost ([51.15.41.238])
        by smtp.gmail.com with ESMTPSA id e8sm4704062wrc.34.2019.05.09.01.55.45
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 09 May 2019 01:55:45 -0700 (PDT)
Date:   Thu, 9 May 2019 09:55:44 +0100
From:   Stefan Hajnoczi <stefanha@gmail.com>
To:     ivo welch <ivo.welch@ucla.edu>
Cc:     kvm@vger.kernel.org
Subject: Re: developer intro
Message-ID: <20190509085544.GA15331@stefanha-x1.localdomain>
References: <CAJrNScT9i3jGY9DDGUHjtHZKJQ_RLsHM3j90Tzjpxfx0+XXV8Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="0F1p//8PRICkK4MW"
Content-Disposition: inline
In-Reply-To: <CAJrNScT9i3jGY9DDGUHjtHZKJQ_RLsHM3j90Tzjpxfx0+XXV8Q@mail.gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--0F1p//8PRICkK4MW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 01, 2019 at 03:45:58PM -0700, ivo welch wrote:
> Ladies and Gents--- I want to learn how to write a pseudo-storage
> device, where the host can observe and potentially intercept read and
> write requests to LBAs by the guest(s).  I am looking for a starter
> docs, tutorials, examples, general docs, etc.  (Or perhaps is someone
> interested in helping me set this up for pay, especially if such docs
> are hard to find?)

Writing a new emulated device is not necessary.

You can configure an NBD server or iSCSI target.  QEMU sends I/O
requests your custom server so you can do anything you want.  Writing an
NBD server is fairly simple or you can use existing code like nbdkit
(https://github.com/libguestfs/nbdkit).

Stefan

--0F1p//8PRICkK4MW
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAlzT6u4ACgkQnKSrs4Gr
c8gNTQf/WiOnX127U0SujoaPzpGgvi4AXT5XaGraygW/pCpNBUTBR5SpMORBxoGP
N85d0p6YLRb7/S29cn7hH6T4icZHMcte54Q9nUeZTzWMR7vHDXihzhNvsWK6bxQ7
5yDTOjQMRd1dQBKRNDAQqdsz9kTjaQINbu+CcOFN8ta2oaPHDT0lIBtYe0PMnG/o
GDdzG3JdTjWlDWfSsb27kCcvn3xPwMRYWmzSkwd7D17I9oYgMn9WmaqY+9cCdSoQ
n/RUsaBd/K2Au70iuSuG6O4kSXKOQ6hxlPLNv+R/6SNCp/hFOnosY3FxxR+Bq+TP
mYU6Z1FXkmKIzbqs8+llrcf7kgcR7g==
=4RoY
-----END PGP SIGNATURE-----

--0F1p//8PRICkK4MW--
