Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D218679BA1
	for <lists+kvm@lfdr.de>; Tue, 24 Jan 2023 15:22:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234638AbjAXOWB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Jan 2023 09:22:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234069AbjAXOWA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Jan 2023 09:22:00 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D7988E
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 06:21:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674570073;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8oENsT6FKSbjG8qOkOCXUpHU8LhCuaYbvtqSD6QuPP0=;
        b=Hkm1CIyzzP4VOHDSoshFeUD5fgi0f301BROg4pCXV7yS2YSB/jWokZ9owsBMpp17EEuJBM
        gHuis1qQXE4o+8fkbgZ5Cgmt2ZBR09YGOLJkKak+90KRUGLkGJGD2etVB3wt1EDkUhxjU+
        2FQGhjekKl8C28/EpgJv8l5Wo/Ybgtc=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-458-o0aymdeSMqKbydqx_e6y9Q-1; Tue, 24 Jan 2023 09:21:11 -0500
X-MC-Unique: o0aymdeSMqKbydqx_e6y9Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 28A483C18350;
        Tue, 24 Jan 2023 14:21:11 +0000 (UTC)
Received: from localhost (unknown [10.39.193.253])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6B3172026D2A;
        Tue, 24 Jan 2023 14:21:10 +0000 (UTC)
Date:   Tue, 24 Jan 2023 09:21:08 -0500
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
Subject: Re: [PATCH 08/32] trace: Move HMP commands from monitor/ to trace/
Message-ID: <Y8/pVAXxDAoMRXUC@fedora>
References: <20230124121946.1139465-1-armbru@redhat.com>
 <20230124121946.1139465-9-armbru@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="5diW0wbs6DbIwjht"
Content-Disposition: inline
In-Reply-To: <20230124121946.1139465-9-armbru@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--5diW0wbs6DbIwjht
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 24, 2023 at 01:19:22PM +0100, Markus Armbruster wrote:
> This moves these commands from MAINTAINERS sections "Human
> Monitor (HMP)" and "QMP" to "Tracing".
>=20
> Signed-off-by: Markus Armbruster <armbru@redhat.com>
> ---
>  include/monitor/hmp.h  |   3 +
>  monitor/misc.c         | 119 ---------------------------------
>  trace/trace-hmp-cmds.c | 148 +++++++++++++++++++++++++++++++++++++++++
>  trace/meson.build      |   1 +
>  4 files changed, 152 insertions(+), 119 deletions(-)
>  create mode 100644 trace/trace-hmp-cmds.c

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--5diW0wbs6DbIwjht
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEyBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmPP6VQACgkQnKSrs4Gr
c8g9Twf4kU29jC0VJYy6y15wW//3dlo/OrfQS1kSi8WeAHKMYymeOxFDneZq455U
8QMsHQAOWf0QVHJqZgRih+mdWIeCEYDhdIivcsr8BYf67Kn0PQlXqFeiGo993vrQ
kijMU1bhLiSTOBXB+A4LxshiNDpRBa6XDOqwieD9lcEhn80PLi5xCgeM5uvRzZxO
n+DeDXAKSVoW2CeIEeg2xrqgJQ762MtIOkveknSHOQ4i5w8tUPNK2DgGyx5FGTWg
LF19ndFC+Cp7bGIpWvzhBpjPzt6dcuFFCh/pEz6rcNXbz6wiQcBBndGNTi9+ZLQM
KhMVDacOPTIEyX9dyle2ups0q0W8
=x8M5
-----END PGP SIGNATURE-----

--5diW0wbs6DbIwjht--

