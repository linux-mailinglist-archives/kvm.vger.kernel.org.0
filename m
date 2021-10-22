Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA38B4379BD
	for <lists+kvm@lfdr.de>; Fri, 22 Oct 2021 17:18:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233304AbhJVPUe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Oct 2021 11:20:34 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:53455 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232384AbhJVPUd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 22 Oct 2021 11:20:33 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 66D0C580F92;
        Fri, 22 Oct 2021 11:18:14 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Fri, 22 Oct 2021 11:18:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stwcx.xyz; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=46YpM5jZKwd3mcnLxsPVqOmlYwf
        lxCO4p2fiY1KoOPc=; b=qm/JHEjUR81ScgvglY9ndyrWS6meTUz02OeqaWeuwnV
        OkvwFVjW753vqgVHwr+I7OhJFw1cJfhfxlXXHEZA1I3RqDQ4tWjSZ/KlP3IYrvL0
        DhrpBbN43xHgOaLUMJZJ0KuzMu+1fEEfTEsxbTqF7FaeyDyhTZQykIWjrUNSNGsi
        uT4eqrJqDCpp6eFFpZLfBgwDAjZP5dfZhc0bJjgFC6dd8iUWmiYnKoe7178zU2qu
        AG+l8dA1GcdlOAML1P8inXgr9ERXBCkHQGZ/6xCBd0shOkTY/7UQgld470E2Sthm
        ui0lZ6XpYyrGFwS10FcCiQc9TKhxRpuKtn146Sp7MUA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=46YpM5
        jZKwd3mcnLxsPVqOmlYwflxCO4p2fiY1KoOPc=; b=ODoNLg6b9DxvKZ9suUSYH6
        ibbkhO6J/bGRvsG2yv16q0+2KVopWvljS4+tT9yMqnb9aC2M7FVOqVuzMwi6DV4w
        TYC4Gp/ORsQGrXg/Bx35p7J+SvPOBT/84L/GRvNabaIRP+cr3IDLB7HOV+R5SdTA
        mSgcSov7Yc5r/dPNI3VIWe/I7caf2GraW1ukuxXF0alogK1ev4t4rZbDVbWNJEOA
        frUsW+rLtY4rrheFi195Oav+vi68tM+LU2KSKKkjAbAZfd/PUKEdxNGtruwzZPRn
        /HnDPeB/bWdUU1AS31twbQCi1oqH1TQwhdUVCuPuJt3zeuqZRSWsc1MslNArO6bQ
        ==
X-ME-Sender: <xms:NdZyYRpgEAo76-yfnDAaM3pmvgYYvRy5uQZRPPwY7hxaAdC1BfhxFw>
    <xme:NdZyYTpjPmsAr-sXeGewqzvH3VcwRoQ-JkWIOUfyqVqW1OhExH8m6UUhyWwt93IXY
    zZFW4t_5T5tY6_joMs>
X-ME-Received: <xmr:NdZyYeOzjnNtXiGBb9iTlhifuZm69WxhizsDdtS7DK7kB1X74WcFtrRTV2kgVgXa6tNAJ1C9qLzSAYfy9X6ZGBv--bzWSHZ5w6OAAumuAgBo7g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvddvkedgjedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    gfrhhlucfvnfffucdljedtmdenucfjughrpeffhffvuffkfhggtggujgesghdtroertddt
    vdenucfhrhhomheprfgrthhrihgtkhcuhghilhhlihgrmhhsuceophgrthhrihgtkhessh
    htfigtgidrgiihiieqnecuggftrfgrthhtvghrnhepfeeikedvjeejheetgeeggeefgeff
    teeugfegtddvudeggfeugfefjedvuedvveevnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepphgrthhrihgtkhesshhtfigtgidrgiihii
X-ME-Proxy: <xmx:NdZyYc71h11aRVJBMGfw2EO0jp91Y2LEb_hdTyTUPjoScQgPUwAZHA>
    <xmx:NdZyYQ6B5nPy8TxGZY_MeQw4V0VyxFBsCDKZHYicXG6WSJGUG2ZCoQ>
    <xmx:NdZyYUgj5g6TZgOd_k22lZJCcLgfLGG_GyhOP924D2D0nfpbD18H_g>
    <xmx:NtZyYTJ4p4_qR52E2TPgLiaZIzg_pp3dv1yxYjVH1RdCC9E6t3S5IQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 22 Oct 2021 11:18:12 -0400 (EDT)
Date:   Fri, 22 Oct 2021 10:18:11 -0500
From:   Patrick Williams <patrick@stwcx.xyz>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Zev Weiss <zev@bewilderbeest.net>, kvm@vger.kernel.org,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Jeremy Kerr <jk@codeconstruct.com.au>,
        Rajat Jain <rajatja@google.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Jianxiong Gao <jxgao@google.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Saravana Kannan <saravanak@google.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        openbmc@lists.ozlabs.org, devicetree@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Bhaskar Chowdhury <unixbhaskar@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Andrew Jeffery <andrew@aj.id.au>,
        Cornelia Huck <cohuck@redhat.com>,
        linux-kernel@vger.kernel.org, Vinod Koul <vkoul@kernel.org>,
        dmaengine@vger.kernel.org
Subject: Re: [PATCH 4/5] driver core: inhibit automatic driver binding on
 reserved devices
Message-ID: <YXLWMyleiTFDDZgm@heinlein>
References: <20211022020032.26980-1-zev@bewilderbeest.net>
 <20211022020032.26980-5-zev@bewilderbeest.net>
 <YXJeYCFJ5DnBB63R@kroah.com>
 <YXJ3IPPkoLxqXiD3@hatter.bewilderbeest.net>
 <YXJ88eARBE3vU1aA@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="70daKchr0JYsGAyF"
Content-Disposition: inline
In-Reply-To: <YXJ88eARBE3vU1aA@kroah.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--70daKchr0JYsGAyF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Fri, Oct 22, 2021 at 10:57:21AM +0200, Greg Kroah-Hartman wrote:
> On Fri, Oct 22, 2021 at 01:32:32AM -0700, Zev Weiss wrote:
> > On Thu, Oct 21, 2021 at 11:46:56PM PDT, Greg Kroah-Hartman wrote:
> > > On Thu, Oct 21, 2021 at 07:00:31PM -0700, Zev Weiss wrote:

> > So we want the kernel to be aware of the device's existence (so that we
> > *can* bind a driver to it when needed), but we don't want it touching t=
he
> > device unless we really ask for it.
> >=20
> > Does that help clarify the motivation for wanting this functionality?
>=20
> Sure, then just do this type of thing in the driver itself.  Do not have
> any matching "ids" for this hardware it so that the bus will never call
> the probe function for this hardware _until_ a manual write happens to
> the driver's "bind" sysfs file.

It sounds like you're suggesting a change to one particular driver to satis=
fy
this one particular case (and maybe I'm just not understanding your suggest=
ion).
For a BMC, this is a pretty regular situation and not just as one-off as Ze=
v's
example.

Another good example is where a system can have optional riser cards with a
whole tree of devices that might be on that riser card (and there might be
different variants of a riser card that could go in the same slot).  Usually
there is an EEPROM of some sort at a well-known address that can be parsed =
to
identify which kind of riser card it is and then the appropriate sub-device=
s can
be enumerated.  That EEPROM parsing is something that is currently done in
userspace due to the complexity and often vendor-specific nature of it.

Many of these devices require quite a bit more configuration information th=
an
can be passed along a `bind` call.  I believe it has been suggested previou=
sly
that this riser-card scenario could also be solved with dynamic loading of =
DT
snippets, but that support seems simple pretty far from being merged.

--=20
Patrick Williams

--70daKchr0JYsGAyF
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEBGD9ii4LE9cNbqJBqwNHzC0AwRkFAmFy1jEACgkQqwNHzC0A
wRkFhg/9HGu2uiFP02YyeOYntJIcOruf1o1SzGDkH/cH9bsS/NmFUA76UFa42pJp
O1Dkn1yXtjNdENw9UL7RU3kmCWHaEP2nBxP3F+3Gt/9uYZIxArNWBQUGMjELC+dn
6wfQXoRPwPX+/Tzug7WAgwqsWP9KvdIzvIYf1GfKSlZGXxa2uuwJb4QFTLirrmiK
zFn78+EB+4qSZEl3KucpA4UahfCobnPcz7a51DP2XSn70Qq2kTZfxn3Pjd4tYtAg
N0YqDe32NnYHX1jAh/g/QXLv4BCOHh4x8IDWBaekoZ9dSg9CctAjct8L7+HxbdV6
HWFwlDFm2GvLtv71WyKGqxRaeFfp2+BSZaedQXLM/1t3xY8lD3HOG0yFUxCweXZ9
yFXrlql9NQ+KkoML3LbO+NUrzk3Iz3cJxSQ7s0G6/N57fI/dUsHVihJfABroBPhF
xNFYGEsADyvcLFygWXCG3Z/hNa5RgJOhSxrijXTTimUmJg0/TZePrLGJQ6Iikehp
D+5v6DOh/Itq/CaXhjpwitloV1yxQGnEM+72cIb7pjkjTqsuKXQwy8Gq4XQzXHLX
YV9NM7xESn7QUuuED4KprEEKYMVu5vIFDNhgifBXd48GTEr1Ga8BbFDVfoUcPuya
oQ707lRUwbiNx344LTJqBm/cotib5i5rIaMQAIAZtUecxdzQ9tk=
=/Hnz
-----END PGP SIGNATURE-----

--70daKchr0JYsGAyF--
