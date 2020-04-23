Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 832671B64DF
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 21:56:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726102AbgDWT4k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Apr 2020 15:56:40 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:33769 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725934AbgDWT4j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Apr 2020 15:56:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587671797;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=qu+VceG+8OJiC2Owgcavhb94c9+mFXpnM7+Vwmimb/k=;
        b=J1UUbH+2Zi5Mt5IDzo7tc/FvPQ1zSaUtfj9z2eZP1sUvElqifRdLxuYu2Ryz8PGMI+L6dP
        arq86utFiL0gwzL2K16k4YhNtxOcwvTkwljRE3uxmNjrNYkVcATn9JeHLKqBRv8WjSU3es
        SFUjV1bp/PTWpxzEeVRKl2hMxpVczzI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-358-NLKgeJJCNFuOr6ZrY8MJ2g-1; Thu, 23 Apr 2020 15:56:35 -0400
X-MC-Unique: NLKgeJJCNFuOr6ZrY8MJ2g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7F44A835B50;
        Thu, 23 Apr 2020 19:56:34 +0000 (UTC)
Received: from [10.10.114.69] (ovpn-114-69.rdu2.redhat.com [10.10.114.69])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E4A031059114;
        Thu, 23 Apr 2020 19:56:33 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH] x86: ioapic: Run physical destination mode
 test iff cpu_count() > 1
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
References: <20200423195050.26310-1-sean.j.christopherson@intel.com>
From:   Nitesh Narayan Lal <nitesh@redhat.com>
Autocrypt: addr=nitesh@redhat.com; prefer-encrypt=mutual; keydata=
 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
 VujM7c/b4pps
Organization: Red Hat Inc,
Message-ID: <ae400308-6bd7-cbea-06d6-6cfcf0ea9946@redhat.com>
Date:   Thu, 23 Apr 2020 15:56:32 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200423195050.26310-1-sean.j.christopherson@intel.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="4ZkXAsuuOANi9yXk5u17kIlZkNe9exdvk"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--4ZkXAsuuOANi9yXk5u17kIlZkNe9exdvk
Content-Type: multipart/mixed; boundary="Nd5hJIHcityxf50i0lTh13vByIJTnh1vt"

--Nd5hJIHcityxf50i0lTh13vByIJTnh1vt
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US


On 4/23/20 3:50 PM, Sean Christopherson wrote:
> Make test_ioapic_physical_destination_mode() depending on having at
> least two CPUs as it sets ->dest_id to '1', i.e. expects CPU0 and CPU1
> to exist.  This analysis is backed up by the fact that the test was
> originally gated by cpu_count() > 1.
>
> Fixes: dcf27dc5b5499 ("x86: Fix the logical destination mode test")
> Cc: Nitesh Narayan Lal <nitesh@redhat.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  x86/ioapic.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/x86/ioapic.c b/x86/ioapic.c
> index 3106531..f315e4b 100644
> --- a/x86/ioapic.c
> +++ b/x86/ioapic.c
> @@ -504,7 +504,8 @@ int main(void)
>  =09test_ioapic_level_tmr(true);
>  =09test_ioapic_edge_tmr(true);
> =20
> -=09test_ioapic_physical_destination_mode();
> +=09if (cpu_count() > 1)
> +=09=09test_ioapic_physical_destination_mode();
>  =09if (cpu_count() > 3)
>  =09=09test_ioapic_logical_destination_mode();
> =20

Thank you Sean for fixing this.

--=20
Nitesh


--Nd5hJIHcityxf50i0lTh13vByIJTnh1vt--

--4ZkXAsuuOANi9yXk5u17kIlZkNe9exdvk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkXcoRVGaqvbHPuAGo4ZA3AYyozkFAl6h8vAACgkQo4ZA3AYy
ozmziQ//XVenLowXZRQc0djDdD4YXS79Mh5+vTvVV3OZ8IiE2a6LaPCtGE34rOn5
LKxZl7WXDibYgNko/z6swseiGh8Zh0fNfhyDj/7qn8GbkxTrEiZUCaNmx3XglE9e
l+Ma7F910T+WsyrBZugPRLEdx+Xaxxju9HQOS65Qu+ecWc0bDHUQKrHN+YuFb7qt
D64QEpRBgidC+AdOD9NyebZMj7lwJaTzoMSh42cO6lqv7sP9+ZF6VtMDvgTOmjoh
jaLl1dOBBRjUwWE1RwqH06qrlX2E4qD4SeD33QU10Lqbvp96nDbRutcZiyiLdQyy
k76osD9xjAZl+3ZUkNSgL1uh0BP7aA4hEE5zOORpQxdXb+HrJRzXteOd44aIEIxM
5Cv4sQjGuGkEWHDuUqLArHq66rZxvDBzSwa+oghTE4CF8976U/Y1hStQCmVPq552
whmFco6rGPzwnYzhLIgJs1j0w4+L1yuEHseY+4vtvfFJtXWbj3Ces7D0Yx2UUR4D
uVA5SqsftPElXhH60Cj1ZQCAzYV3zP5QdGln75ADUf2DJIX9Md181asIR62JB2eU
ipdfguqcI2xEzhHhk1ZLjj+yrItVSxPn0pmyh0Hc/J6hw+0ebniQeZpLPhPFxj+p
rwNpHFjxloss2AlONeaDAW8dIHCjYOKGCfrnQihXFMX4/U//Udo=
=Twi+
-----END PGP SIGNATURE-----

--4ZkXAsuuOANi9yXk5u17kIlZkNe9exdvk--

