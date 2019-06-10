Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 602653B51F
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2019 14:37:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389949AbfFJMgV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jun 2019 08:36:21 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:37542 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389905AbfFJMgV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jun 2019 08:36:21 -0400
Received: by mail-wm1-f66.google.com with SMTP id 22so7999891wmg.2;
        Mon, 10 Jun 2019 05:36:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=7PM6uoWZ78ckqebs+NRho2n2G33fUn82Yyi1MIgn2mw=;
        b=QIxAT7fpDsh3nectz0zZqalSAhl36Rky2FXeXgy2/bzfrvwVuGLKcCR9fZ4F1e8Hu/
         6k0l9qUoRdX3AXMeuUdOCJbyorA5YULhbXDTfx7kholMZj/h9HCGK0QwlCqObOntPEST
         s7UfLTwUJL+c4C7mvuB3yV3qKVidYgwO3tiXCknk/3ds3moCHqIaFfyTS70yOrgV5g3W
         9mthIoFEkJ1Jgo3Q1G+EQdlTn6gaIo5g9pqSkwaBsUvFZWxq1/73MVXNtxF12chy6/2e
         cLhAZhapZWy7EDOKQxfaoB99R6Frlr4RniMSwcEPn8GNRNgIBD0asEqm1weduHhIsuyM
         jFBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=7PM6uoWZ78ckqebs+NRho2n2G33fUn82Yyi1MIgn2mw=;
        b=JZluYXjt9ZuGJrna0waQBwdeOnJ16sJZonmpaX+kgZwQgWkoUmbWAXSuV498mXFFJv
         /V3j9LvqlYPmmE8Et6xzReEewv3s0Lrctk0w7lTGP4hdWZstetabm7nZydZhs0kmXZww
         +oCSnLR9V/XdTYSZoCEpvgjAMfkL7KDyqFTQ/1RMz06sCbp6ye+Faqzrtj5efU9piclY
         RfkIKozZTuWYbWEaiCxA0SCJNGxB+mKQbddxS5nmpN7ASLtVWCl5/99+kPlh70afejvf
         Vdf8eaVFwyQTt9FtolRNDLQMqbg246YZGxHWJDv3EcCnwi42U5PmHIOGobj8YLt3GOLs
         5jCg==
X-Gm-Message-State: APjAAAXtuu1r4Muv9PcxFW4iI9wKGem+SeSpEGkzo4eME+cu7YO4ZiLX
        uiMG5i7NI6L8NySKhQg5BIdCZVnUQfJgrQ==
X-Google-Smtp-Source: APXvYqyvfc7vIEw7b/PkaFTeK+1lqhxcoZe4J8TJ4kFnOvqR0bwXoivUKMz4jKA8bJXRqf+TioJLCg==
X-Received: by 2002:a1c:f314:: with SMTP id q20mr12291063wmq.74.1560170179320;
        Mon, 10 Jun 2019 05:36:19 -0700 (PDT)
Received: from localhost ([51.15.41.238])
        by smtp.gmail.com with ESMTPSA id f204sm13850147wme.18.2019.06.10.05.36.18
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 10 Jun 2019 05:36:18 -0700 (PDT)
Date:   Mon, 10 Jun 2019 13:36:17 +0100
From:   Stefan Hajnoczi <stefanha@gmail.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, stefanha@redhat.com
Subject: Re: [PATCH 0/2] scsi: add support for request batching
Message-ID: <20190610123617.GK14257@stefanha-x1.localdomain>
References: <20190530112811.3066-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="GvuyDaC2GNSBQusT"
Content-Disposition: inline
In-Reply-To: <20190530112811.3066-1-pbonzini@redhat.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--GvuyDaC2GNSBQusT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 30, 2019 at 01:28:09PM +0200, Paolo Bonzini wrote:
> This allows a list of requests to be issued, with the LLD only writing
> the hardware doorbell when necessary, after the last request was prepared.
> This is more efficient if we have lists of requests to issue, particularly
> on virtualized hardware, where writing the doorbell is more expensive than
> on real hardware.
>=20
> This applies to any HBA, either singlequeue or multiqueue; the second
> patch implements it for virtio-scsi.
>=20
> Paolo
>=20
> Paolo Bonzini (2):
>   scsi_host: add support for request batching
>   virtio_scsi: implement request batching
>=20
>  drivers/scsi/scsi_lib.c    | 37 ++++++++++++++++++++++---
>  drivers/scsi/virtio_scsi.c | 55 +++++++++++++++++++++++++++-----------
>  include/scsi/scsi_cmnd.h   |  1 +
>  include/scsi/scsi_host.h   | 16 +++++++++--
>  4 files changed, 89 insertions(+), 20 deletions(-)
>=20
> --=20
> 2.21.0
>=20

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--GvuyDaC2GNSBQusT
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAlz+TsEACgkQnKSrs4Gr
c8gE+QgAwWdqWzwfL6+Ow3hy/qynLLmeQ94GdokspoNxkJ+GvFFTuq51OaFQyMeH
dE+3n2QBm0p57kO1c6doG6CWuOGeMN9pd5PGgLyl+QOaSc1u2LO/kWUJ8Re3Ggyz
QICTZseq3Z4NVerKLZY5Mx53YZfRMbePKVSrfWUR4okHtwSojMIh6bDaIf1HvHU/
vcsEDFOUEle1nu2ypocOoVP6E15tYRlIlYlvnhoeM2Dv1A9+VazFnOkavn2wnEi9
H0ELaaWbRibQFXfIuWf7s8VyLufh1EoGtVAUF4Dza3y/tRg5rVbTEgO3/1S+m1PV
qqPghgKwdjpLkaF2vXeKWBoC2SqiKw==
=IMS9
-----END PGP SIGNATURE-----

--GvuyDaC2GNSBQusT--
