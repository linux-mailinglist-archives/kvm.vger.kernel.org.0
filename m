Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75390209A56
	for <lists+kvm@lfdr.de>; Thu, 25 Jun 2020 09:10:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390239AbgFYHKS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Jun 2020 03:10:18 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:32419 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2390013AbgFYHKQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Jun 2020 03:10:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593069015;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=byq3Gt6LzD3JkYl4VnNLVPHJt+zGaUVs+vzFPctEg7A=;
        b=hpEG1FP+HEsQOHTI+dKyhXEv4jrJO7WQaVCtW1nb2PfX9Y6qXwULUgx4RK8qpB9XoRZaWG
        k5h9/6aCNLLuyBVGOAhmo66O4Cpsk/jFzBIWLvR/luIF23x1O9hPHVjxpZZpWW3LsjK5Nw
        KQCQREo9vtDc0fkhOydro1nUq9JlkD0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-110-k_nk0ybDMamQHs8AZClKWw-1; Thu, 25 Jun 2020 03:10:11 -0400
X-MC-Unique: k_nk0ybDMamQHs8AZClKWw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E26BC18A8221;
        Thu, 25 Jun 2020 07:10:09 +0000 (UTC)
Received: from gondolin (ovpn-112-36.ams2.redhat.com [10.36.112.36])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DDD162B4AC;
        Thu, 25 Jun 2020 07:10:04 +0000 (UTC)
Date:   Thu, 25 Jun 2020 09:09:42 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     Collin Walling <walling@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, pbonzini@redhat.com,
        borntraeger@de.ibm.com, david@redhat.com, imbrenda@linux.ibm.com,
        heiko.carstens@de.ibm.com, gor@linux.ibm.com, thuth@redhat.com
Subject: Re: [PATCH 2/2] docs: kvm: fix rst formatting
Message-ID: <20200625090942.21dbc0cf.cohuck@redhat.com>
In-Reply-To: <22b7d435-480e-ac7f-de4f-b992df6c9ebb@linux.ibm.com>
References: <20200624202200.28209-1-walling@linux.ibm.com>
        <20200624202200.28209-3-walling@linux.ibm.com>
        <20200625083423.2ee75bb1.cohuck@redhat.com>
        <22b7d435-480e-ac7f-de4f-b992df6c9ebb@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=cohuck@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; boundary="Sig_/Ld9iV.4s/wmw0ZpsEKDJZAx";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/Ld9iV.4s/wmw0ZpsEKDJZAx
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 25 Jun 2020 09:07:43 +0200
Janosch Frank <frankja@linux.ibm.com> wrote:

> On 6/25/20 8:34 AM, Cornelia Huck wrote:
> > On Wed, 24 Jun 2020 16:22:00 -0400
> > Collin Walling <walling@linux.ibm.com> wrote:
> >  =20
> >> KVM_CAP_S390_VCPU_RESETS and KVM_CAP_S390_PROTECTED needed
> >> just a little bit of rst touch-up
> >> =20
> >=20
> > Fixes: 7de3f1423ff9 ("KVM: s390: Add new reset vcpu API")
> > Fixes: 04ed89dc4aeb ("KVM: s390: protvirt: Add KVM api documentation") =
=20
>=20
> Do we really do that for documentation changes?

Feel free to keep it or leave it :)

--Sig_/Ld9iV.4s/wmw0ZpsEKDJZAx
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEw9DWbcNiT/aowBjO3s9rk8bwL68FAl70TbYACgkQ3s9rk8bw
L68P0hAAkwdGWyLFiR44i6hMte0U54WSkKflyDCBDtR8/jyjfY7k8t+D88D9RLoC
Of+FCpqVo2WeMGdoU88twIUOuT3Zvj3DegHGIisDUNOdpSHLWoqI3CTddx/tqgpE
Jg7DSuC4LBfAWnyDGbrHJFFuxuUDcZrgxCHckeJoWRJw9WoyYEJkddSQ6xygJJUO
QnkyRIdEm0zZu9ryLWAMK4QFWitb9lzZ9RtsaY0x8Wk7Lnf/nOPrgDth3+RLW/xo
/ookWunL9/5amxnjUDvvJsqfvl5ndXieBtNYEl6peDSmZMgyItW0rqNBPuaalYgU
okl1ItZ4boP8UwBUlxubmnFMKnDVrOZPDAPWFtkvJ8EQVV20DRjMjK+XjE97wmww
Rb2qmEZk/OyPbDaggkNVeyBSMS122jbnDT0XcEKUMmV2yd7nn+FaqIoFog9TgTdi
1t3X7JdOlwrPr7xfFwik2wiJq0IltoAgeLusdm3xOES31CIo9p2SzOYMtiJaDBZX
i6jYIIHl4uzTmAqaOsNgCRtnRiakKuZ9Pd2EAydLxtZeI7GUbawyk3xYMsDlOF4G
4LTNwi1YVpGgd5Tth3oIb4LN7JjdRRHF7P0Dp7y3gJynFqEmGyQ66Fs1kScBcKx3
tWWOXQots26tu3h+eKEGtF5NbmHU6dE5/8nJ/AWpOsFekiNSMF0=
=KNVK
-----END PGP SIGNATURE-----

--Sig_/Ld9iV.4s/wmw0ZpsEKDJZAx--

