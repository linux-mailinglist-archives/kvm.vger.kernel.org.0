Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3311B138FB2
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2020 12:00:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726567AbgAMLAJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jan 2020 06:00:09 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:52555 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726236AbgAMLAJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 13 Jan 2020 06:00:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578913208;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=jwzSRzrmLqi4CT4evTyCdeb/fuH0FHhGXQj0JXvJexs=;
        b=bKDt4/goSgPBX55AMtkMGAhE60UzZLbOdLz6DdMbtem5824J3yUvh9AQ5LMtfaGpg2my1p
        Z+7b3+aJwk9edLAt2svEXysuRRyNSAyxg+yARljl9EPfJucSCr2VKLgpGirtWdtLBODKXS
        yo3GITb8EN1DZN+kSSO78/LqkQzwBGA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-236-NO1DRVKPMuauqRuYuybqvg-1; Mon, 13 Jan 2020 06:00:04 -0500
X-MC-Unique: NO1DRVKPMuauqRuYuybqvg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B94D7100550E;
        Mon, 13 Jan 2020 11:00:02 +0000 (UTC)
Received: from [10.36.117.201] (ovpn-117-201.ams2.redhat.com [10.36.117.201])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 11B1F60C05;
        Mon, 13 Jan 2020 11:00:00 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v7 4/4] s390x: SCLP unit test
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, thuth@redhat.com,
        borntraeger@de.ibm.com, frankja@linux.ibm.com
References: <20200110184050.191506-1-imbrenda@linux.ibm.com>
 <20200110184050.191506-5-imbrenda@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; prefer-encrypt=mutual; keydata=
 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
Organization: Red Hat GmbH
Message-ID: <8d7fb5c4-9e2c-e28a-16c0-658afcc8178d@redhat.com>
Date:   Mon, 13 Jan 2020 12:00:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20200110184050.191506-5-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> +/**
> + * Test some bits in the instruction format that are specified to be i=
gnored.
> + */
> +static void test_instbits(void)
> +{
> +	SCCBHeader *h =3D (SCCBHeader *)pagebuf;
> +	int cc;
> +
> +	expect_pgm_int();
> +	sclp_mark_busy();
> +	h->length =3D 8;
> +	sclp_setup_int();
> +
> +	asm volatile(
> +		"       .insn   rre,0xb2204200,%1,%2\n"  /* servc %1,%2 */
> +		"       ipm     %0\n"
> +		"       srl     %0,28"
> +		: "=3D&d" (cc) : "d" (valid_code), "a" (__pa(pagebuf))
> +		: "cc", "memory");
> +	if (lc->pgm_int_code) {
> +		sclp_handle_ext();
> +		cc =3D 1;
> +	} else if (!cc)
> +	=09

I wonder if something like the following would be possible:

expect_pgm_int();
...
asm volatiole();
...
sclp_wait_busy();
check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);

We would have to clear "sclp_busy" when we get a progam interrupt on a
servc instruction - shouldn't be too hard to add to the program
exception handler.

> +	report(cc =3D=3D 0, "Instruction format ignored bits");
> +}
> +
> +/**
> + * Find a valid READ INFO command code; not all codes are always allow=
ed, and
> + * probing should be performed in the right order.
> + */
> +static void find_valid_sclp_code(void)
> +{
> +	const unsigned int commands[] =3D { SCLP_CMDW_READ_SCP_INFO_FORCED,
> +					  SCLP_CMDW_READ_SCP_INFO };
> +	SCCBHeader *h =3D (SCCBHeader *)pagebuf;
> +	int i, cc;
> +
> +	for (i =3D 0; i < ARRAY_SIZE(commands); i++) {
> +		sclp_mark_busy();
> +		memset(h, 0, sizeof(*h));
> +		h->length =3D 4096;
> +
> +		valid_code =3D commands[i];
> +		cc =3D sclp_service_call(commands[i], h);
> +		if (cc)
> +			break;
> +		if (h->response_code =3D=3D SCLP_RC_NORMAL_READ_COMPLETION)
> +			return;
> +		if (h->response_code !=3D SCLP_RC_INVALID_SCLP_COMMAND)
> +			break;
> +	}
> +	valid_code =3D 0;

This can be dropped because ...

> +	report_abort("READ_SCP_INFO failed");

... you abort here.


--=20
Thanks,

David / dhildenb

