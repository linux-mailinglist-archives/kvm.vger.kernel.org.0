Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6563B197C44
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 14:51:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729995AbgC3MvE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Mar 2020 08:51:04 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:46910 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729881AbgC3MvD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Mar 2020 08:51:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585572661;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=7rxAAhl0nylgMmn2ALvBmu2VV5bKFEIVOfZu+2O+XnM=;
        b=Z1gJLau8gUuw0eFWYTZPcFvQfW3DRS1VXvvmLScOXyNzlPGffKlH1I4MjyLkS7aYsyCoDN
        SkkOsFVJAu5RS0rkKJM0Fv18vq2S0SDHdyagi8/uv82/6+zjJXVHh78HhZ9PV0TQij1oPy
        jcB65NnFxJrX2gv9zFmHLO8BmXy/twk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-485-SnMVOu_1PDKlvXAW7IAz6Q-1; Mon, 30 Mar 2020 08:50:57 -0400
X-MC-Unique: SnMVOu_1PDKlvXAW7IAz6Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AD9911083E88;
        Mon, 30 Mar 2020 12:50:56 +0000 (UTC)
Received: from [10.36.113.227] (ovpn-113-227.ams2.redhat.com [10.36.113.227])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7DC4BD7680;
        Mon, 30 Mar 2020 12:50:55 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH] s390x: Add stsi 3.2.2 tests
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, cohuck@redhat.com,
        borntraeger@de.ibm.com
References: <20200330122035.19607-1-frankja@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; prefer-encrypt=mutual; keydata=
 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
Organization: Red Hat GmbH
Message-ID: <df745d0c-5d24-ee03-8600-ec495f1a5af6@redhat.com>
Date:   Mon, 30 Mar 2020 14:50:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200330122035.19607-1-frankja@linux.ibm.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30.03.20 14:20, Janosch Frank wrote:
> Subcode 3.2.2 is handled by KVM/QEMU and should therefore be tested
> a bit more thorough.
>=20
> In this test we set a custom name and uuid through the QEMU command
> line. Both parameters will be passed to the guest on a stsi subcode
> 3.2.2 call and will then be checked.
>=20
> We also compare the total and configured cpu numbers against the smp
> reported numbers.
>=20
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  s390x/stsi.c        | 62 +++++++++++++++++++++++++++++++++++++++++++++
>  s390x/unittests.cfg |  1 +
>  2 files changed, 63 insertions(+)
>=20
> diff --git a/s390x/stsi.c b/s390x/stsi.c
> index e9206bca137d2edb..10e588a78cc05186 100644
> --- a/s390x/stsi.c
> +++ b/s390x/stsi.c
> @@ -14,7 +14,28 @@
>  #include <asm/page.h>
>  #include <asm/asm-offsets.h>
>  #include <asm/interrupt.h>
> +#include <smp.h>
> =20
> +struct stsi_322 {
> +    uint8_t  reserved[31];
> +    uint8_t  count;
> +    struct {
> +        uint8_t  reserved2[4];

I dislike aligning the members using double-spaces ...

> +        uint16_t total_cpus;
> +        uint16_t conf_cpus;
> +        uint16_t standby_cpus;
> +        uint16_t reserved_cpus;
> +        uint8_t  name[8];
> +        uint32_t caf;
> +        uint8_t  cpi[16];
> +        uint8_t reserved5[3];

... e.g., here it's not aligned anymore. Just use single spaces.

> +        uint8_t ext_name_encoding;
> +        uint32_t reserved3;
> +        uint8_t uuid[16];
> +    } vm[8];
> +    uint8_t reserved4[1504];
> +    uint8_t ext_names[8][256];
> +};
>  static uint8_t pagebuf[PAGE_SIZE * 2] __attribute__((aligned(PAGE_SIZE=
 * 2)));
> =20
>  static void test_specs(void)
> @@ -76,11 +97,52 @@ static void test_fc(void)
>  	report(stsi_get_fc(pagebuf) >=3D 2, "query fc >=3D 2");
>  }
> =20
> +static void test_3_2_2(void)
> +{
> +	int rc;
> +	/* EBCDIC for "kvm-unit" */
> +	uint8_t vm_name[] =3D { 0x92, 0xa5, 0x94, 0x60, 0xa4, 0x95, 0x89, 0xa=
3 };
> +	uint8_t uuid[] =3D { 0x0f, 0xb8, 0x4a, 0x86, 0x72, 0x7c,
> +			   0x11, 0xea, 0xbc, 0x55, 0x02, 0x42, 0xac, 0x13,
> +			   0x00, 0x03 };
> +	/* EBCDIC for "KVM/" */
> +	uint8_t cpi_kvm[] =3D { 0xd2, 0xe5, 0xd4, 0x61 };

All of these can be const.

> +	const char *vm_name_ext =3D "kvm-unit-test";
> +	struct stsi_322 *data =3D (void *)pagebuf;
> +
> +	/* Is the function code available at all? */
> +	if (stsi_get_fc(pagebuf) < 3)

Maybe report_skip() ?

> +		return;
> +
> +	report_prefix_push("3.2.2");
> +	rc =3D stsi(pagebuf, 3, 2, 2);
> +	report(!rc, "call");
> +
> +	/* For now we concentrate on KVM/QEMU */
> +	if (memcmp(&data->vm[0].cpi, cpi_kvm, sizeof(cpi_kvm)))

Maybe report_skip() ?

> +		goto out;
> +
> +	report(data->vm[0].total_cpus =3D=3D smp_query_num_cpus(), "cpu # tot=
al");
> +	report(data->vm[0].conf_cpus =3D=3D smp_query_num_cpus(), "cpu # conf=
igured");
> +	report(data->vm[0].standby_cpus =3D=3D 0, "cpu # standby");
> +	report(data->vm[0].reserved_cpus =3D=3D 0, "cpu # reserved");

IIRC, using -smp 1,maxcpus=3DX, you could also test the reported reserved
CPUs.


Also passes under TCG, nice :)

--=20
Thanks,

David / dhildenb

