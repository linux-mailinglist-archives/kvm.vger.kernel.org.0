Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D78C3309665
	for <lists+kvm@lfdr.de>; Sat, 30 Jan 2021 16:52:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232341AbhA3Pua (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 30 Jan 2021 10:50:30 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:47285 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232086AbhA3Pqa (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 30 Jan 2021 10:46:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612021502;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NlP4XHeLI458x+5DmcXR57xPRiiktJtHCHJOqduxv5g=;
        b=Ilw1lTIR54+hKGCpYM5Zf096K4OG6VvjMymg3/WyygWfwp6gRGU9WfuUmrAlYgUJ7N4b7l
        uVdhjoFq1/togktFhVmi8/gUxAOi17jkW8GVNyl678T0aN6EgxgsjqxDrlAL6CVh2vTnzF
        PmGdN4B33px567l84JdOlAlDy3O9YQc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-348-FQ91DVcmOwqXlu0WY9ZbFA-1; Sat, 30 Jan 2021 10:05:01 -0500
X-MC-Unique: FQ91DVcmOwqXlu0WY9ZbFA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8A2C857050;
        Sat, 30 Jan 2021 15:05:00 +0000 (UTC)
Received: from localhost (ovpn-112-96.ams2.redhat.com [10.36.112.96])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 17DC710023B8;
        Sat, 30 Jan 2021 15:04:59 +0000 (UTC)
Date:   Sat, 30 Jan 2021 15:04:59 +0000
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Elena Afanasova <eafanasova@gmail.com>
Cc:     kvm@vger.kernel.org, jag.raman@oracle.com,
        elena.ufimtseva@oracle.com
Subject: Re: [RESEND RFC v2 1/4] KVM: add initial support for KVM_SET_IOREGION
Message-ID: <20210130150459.GB98016@stefanha-x1.localdomain>
References: <cover.1611850290.git.eafanasova@gmail.com>
 <de84fca7e7ad62943eb15e4e9dd598d4d0f806ef.1611850291.git.eafanasova@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="gatW/ieO32f1wygP"
Content-Disposition: inline
In-Reply-To: <de84fca7e7ad62943eb15e4e9dd598d4d0f806ef.1611850291.git.eafanasova@gmail.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--gatW/ieO32f1wygP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 29, 2021 at 09:48:26PM +0300, Elena Afanasova wrote:
> This vm ioctl adds or removes an ioregionfd MMIO/PIO region. Guest
> read and write accesses are dispatched through the given ioregionfd
> instead of returning from ioctl(KVM_RUN). Regions can be deleted by
> setting fds to -1.
>=20
> Signed-off-by: Elena Afanasova <eafanasova@gmail.com>
> ---
> Changes in v2:
>   - changes after code review

Please try to be more specific in future revisions so reviewers know
exactly what to look out for.

--gatW/ieO32f1wygP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmAVdZsACgkQnKSrs4Gr
c8gvowf9HfCQL7cDouakMkip8KtazeNI40BtDstvpTB5o7g5WDs7F3KO4BiQ414X
5uQXld08DzxXk889e2tQXYVXpJPlNVnCK6aYnaQDCyufmUJJq6mPTbPadojREM9Q
iUngIckUKn/y63h1sk4xENBE9owkSgVwH7HqjrsOYlpi4mti29MI8q6hCSI18lEH
FNpSy6WUG+LTPYBOwcanFCuxaH/CSPw8nwkjWNV/4UVe69golIHb9jHzh0fDg3x5
SmiHKdkYFbWgM0c6M2u0YrPKNi3RyUarAn2GxA/3PON1OcVnZYWypZDwFxmuDZ1d
DbHC34FZDhk225dHeTXV8MuadeuoAw==
=SdAE
-----END PGP SIGNATURE-----

--gatW/ieO32f1wygP--

