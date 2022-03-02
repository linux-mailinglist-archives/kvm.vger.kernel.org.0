Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDA244CAC2D
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 18:34:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239169AbiCBRek (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 12:34:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244081AbiCBReX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 12:34:23 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7ED99BD7
        for <kvm@vger.kernel.org>; Wed,  2 Mar 2022 09:33:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646242361;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1USmVjxTTYdc7rMUiqrUNWQcVO4SlzVz/zIrE4siUEI=;
        b=DVngakkPpEwOM5xKsKhbC0Lcw4+tcZqcwOCFslNbCFykWpC7hGZz80tLfLp8B/kyNVBiqt
        TETNXJv+JOhs8NmLGhvDmpivZb0H2Sq5I9TJ8yNV8J0dJvPFBpE6ZESB552Ivu91JRHQ/w
        OSG+vRX5xx18leICeAQ4oGDDK2CuSQk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-380-n-ihYirbN3STB5InILhdVg-1; Wed, 02 Mar 2022 12:32:36 -0500
X-MC-Unique: n-ihYirbN3STB5InILhdVg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BCF1C1006AA6;
        Wed,  2 Mar 2022 17:32:33 +0000 (UTC)
Received: from localhost (unknown [10.33.36.14])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E0D43838DD;
        Wed,  2 Mar 2022 17:31:26 +0000 (UTC)
Date:   Wed, 2 Mar 2022 18:31:46 +0100
From:   Sergio Lopez <slp@redhat.com>
To:     Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, qemu-devel@nongnu.org,
        vgoyal@redhat.com, Fam Zheng <fam@euphon.net>, kvm@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Jagannathan Raman <jag.raman@oracle.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>, qemu-block@nongnu.org,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        Hanna Reitz <hreitz@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Elena Ufimtseva <elena.ufimtseva@oracle.com>,
        Kevin Wolf <kwolf@redhat.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        qemu-s390x@nongnu.org, Matthew Rosato <mjrosato@linux.ibm.com>,
        John G Johnson <john.g.johnson@oracle.com>,
        Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH 2/2] Allow building vhost-user in BSD
Message-ID: <20220302173009.26auqvy4t4rx74td@mhamilton>
References: <20220302113644.43717-1-slp@redhat.com>
 <20220302113644.43717-3-slp@redhat.com>
 <66b68bcc-8d7e-a5f7-5e6c-b2d20c26ab01@redhat.com>
 <8dfc9854-4d59-0759-88d0-d502ae7c552f@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="j2z2ayxxgw7ingtg"
Content-Disposition: inline
In-Reply-To: <8dfc9854-4d59-0759-88d0-d502ae7c552f@gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--j2z2ayxxgw7ingtg
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 02, 2022 at 06:18:59PM +0100, Philippe Mathieu-Daud=E9 wrote:
> On 2/3/22 18:10, Paolo Bonzini wrote:
> > On 3/2/22 12:36, Sergio Lopez wrote:
> > > With the possibility of using pipefd as a replacement on operating
> > > systems that doesn't support eventfd, vhost-user can also work on BSD
> > > systems.
> > >=20
> > > This change allows enabling vhost-user on BSD platforms too and
> > > makes libvhost_user (which still depends on eventfd) a linux-only
> > > feature.
> > >=20
> > > Signed-off-by: Sergio Lopez <slp@redhat.com>
> >=20
> > I would just check for !windows.
>=20
> What about Darwin / Haiku / Illumnos?

It should work on every system providing pipe() or pipe2(), so I guess
Paolo's right, every platform except Windows. FWIW, I already tested
it with Darwin.

Thanks,
Sergio.

--j2z2ayxxgw7ingtg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEvtX891EthoCRQuii9GknjS8MAjUFAmIfqgEACgkQ9GknjS8M
AjVb0Q/9Ht01R3I6wyyF8s7Xj1AMRR47qpVaBaP4gAuLPEHt/tesSX6bq5vtiN4K
Yg/0QPlVRz/l/MBcqdqAVcH39OBnx7WfIF4Op/RGkLtI2v2vVFVUZbU+rpOvRLD3
bq1ZNunvYibzTf0aWquIdzULJsCzQUNeNfgziievgeh/oCNlSSOkEbk8szCFVy4/
LDvbd2qoSzcVxt9qRCeXyaugdlBsv6dp3qZBfTstU11uFg9OV6nBukMGnf4eTH/S
8w/M+iNAsr2vzDaOlKtXG8KS1mvUo0bm1pExzSIVEbweK/cpLlJP12txswCoibwJ
YOyY3vGsiQs5QM0eV8ShQkuv8TQrjaUjyOFR10kKwytdWnvL8N69yetSnwgaoQVB
cTyhMqON5/wkHwnGOJVZrGyRvRDGbmkLnfbQlX583XyV1A+wYxlsPnhoJN2Nifwg
0tJbj5EptgrZXfwz+qziwkrWLreDAN4R99QYL0Dp6XIeVwxQ1UXTY/cIDdFYehyb
ZrItawbHFgkJ3lhCFJtIYX/QGv9lpZE5O8ylJ0BkSVUalImfTPNIoH8hzTXbKXIP
BhUvnXI/Gu8+oj3WQaTxmaEsZyzh1TNnqGs6nVIhKhypqQLQ1Bb4hZCJ/0XhDTaP
E49Qr/BL1BKZIOfyB5p3kud5vkF9gplF1L+Zmb71dK9ZUvp5iAc=
=A4cA
-----END PGP SIGNATURE-----

--j2z2ayxxgw7ingtg--

