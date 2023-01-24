Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 528D9679B9E
	for <lists+kvm@lfdr.de>; Tue, 24 Jan 2023 15:21:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234712AbjAXOVj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Jan 2023 09:21:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234638AbjAXOV2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Jan 2023 09:21:28 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C4F92706
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 06:20:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674570029;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6cWDHk/y/VJUEE1RUKKpd8SaACWWZAhY2cE6ExWS4qU=;
        b=Og5fAFxLWDArdSR3+dkZvEWperzeXjKyLZEbklH4+elA5S2QnLi9nvl3OBGYZT7xrtOh7z
        Nvusbc6EU9E+1lKmA6k5HHn2wk2fui8UTtnhUEjY6h8KdsmWV2pwlHtaikE7pfNAb00vZS
        4Aqquu+lZ9wh7+OyYXFnhpqmtPEmpCY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-649-jsj2nUkaN_-dm3XyiBX0zA-1; Tue, 24 Jan 2023 09:20:27 -0500
X-MC-Unique: jsj2nUkaN_-dm3XyiBX0zA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4EDD8104F0A5;
        Tue, 24 Jan 2023 14:20:22 +0000 (UTC)
Received: from localhost (unknown [10.39.193.253])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D1F2F2166B37;
        Tue, 24 Jan 2023 14:20:20 +0000 (UTC)
Date:   Tue, 24 Jan 2023 09:20:18 -0500
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Markus Armbruster <armbru@redhat.com>
Cc:     qemu-devel@nongnu.org, pbonzini@redhat.com, kraxel@redhat.com,
        kwolf@redhat.com, hreitz@redhat.com, marcandre.lureau@redhat.com,
        dgilbert@redhat.com, mst@redhat.com, imammedo@redhat.com,
        ani@anisinha.ca, eduardo@habkost.net, marcel.apfelbaum@gmail.com,
        philmd@linaro.org, wangyanan55@huawei.com, jasowang@redhat.com,
        jiri@resnulli.us, berrange@redhat.com, thuth@redhat.com,
        quintela@redhat.com, stefanb@linux.vnet.ibm.com,
        kvm@vger.kernel.org, qemu-block@nongnu.org
Subject: Re: [PATCH 12/32] block: Factor out hmp_change_medium(), and move to
 block/monitor/
Message-ID: <Y8/pItzIfhSWnJW6@fedora>
References: <20230124121946.1139465-1-armbru@redhat.com>
 <20230124121946.1139465-13-armbru@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="l92TCpcURoee1JvY"
Content-Disposition: inline
In-Reply-To: <20230124121946.1139465-13-armbru@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--l92TCpcURoee1JvY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 24, 2023 at 01:19:26PM +0100, Markus Armbruster wrote:
> Signed-off-by: Markus Armbruster <armbru@redhat.com>
> ---
>  include/monitor/hmp.h          |  3 +++
>  block/monitor/block-hmp-cmds.c | 21 +++++++++++++++++++++
>  monitor/hmp-cmds.c             | 17 +----------------
>  3 files changed, 25 insertions(+), 16 deletions(-)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--l92TCpcURoee1JvY
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmPP6SIACgkQnKSrs4Gr
c8g3YwgArdB3/ODHjD1ToOqSKAz3da9RVdUPPuG5ejF0EZmO7knbNQ4LOwFommEE
SO5VfVKxxsYKg+mBgVO774n4URlf05CLQRZFgKEt533iqGa4kZMZNuB0gGvCfGxQ
PdFAP/Yeu/h0S/jq9Z0Ky8Onwhn8xmhNuZWxGtnzV49xow82mLLko5SzPzrq5l7X
r2n2XJf0VccqIK6HnYH4Lz2cNxfq0sa9GQO+xNVSwfKOmCa/xURJxpYhqiIN6vMz
7hpetoJ5Fm2SF8MHlxhhvy8I03qc9pBvBkrKZ9eNhTT2ZmtnwFAMhsXwtD2qGPYX
NSD6h/xu+RoyzdcU2vf5hc0+0Sh5QA==
=SAHS
-----END PGP SIGNATURE-----

--l92TCpcURoee1JvY--

