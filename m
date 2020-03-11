Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F561181A18
	for <lists+kvm@lfdr.de>; Wed, 11 Mar 2020 14:48:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729541AbgCKNsZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Mar 2020 09:48:25 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:30123 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729428AbgCKNsZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Mar 2020 09:48:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583934504;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ojxoxR+MHQtWUQ/abjg7bLaa0SyuDx1Bi9ausr3HrUw=;
        b=P7JAe8/6IEVJ+I+0ew1AVvuGMow+dFyBmWJyAXtlP/4CNdBcTZ5tEXxxu43fD2cczMYH3g
        5UQQKtRvDd4kXV2R3BEDxHjqDOjL8MU/0iKi1NkI838Gxlr8KmdJqriM2iz8rzJlR1bwLn
        PLgVrRvBojQX6dR2oauLoUqPg21I8BI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-189-TwTOY6s4MGWF3JJ6-DH5-w-1; Wed, 11 Mar 2020 09:48:20 -0400
X-MC-Unique: TwTOY6s4MGWF3JJ6-DH5-w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 687EE1005509;
        Wed, 11 Mar 2020 13:48:18 +0000 (UTC)
Received: from [10.36.118.12] (unknown [10.36.118.12])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 114CA60CC0;
        Wed, 11 Mar 2020 13:48:13 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v5 10/13] arm/arm64: ITS: INT functional
 tests
To:     Zenghui Yu <yuzenghui@huawei.com>, eric.auger.pro@gmail.com,
        maz@kernel.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc:     drjones@redhat.com, andre.przywara@arm.com,
        peter.maydell@linaro.org, alexandru.elisei@arm.com,
        thuth@redhat.com
References: <20200310145410.26308-1-eric.auger@redhat.com>
 <20200310145410.26308-11-eric.auger@redhat.com>
 <d3f651a0-2344-4d6e-111b-be133db7e068@huawei.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <46f0ed1d-3bda-f91b-e2b0-addf1c61c373@redhat.com>
Date:   Wed, 11 Mar 2020 14:48:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <d3f651a0-2344-4d6e-111b-be133db7e068@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Zenghui,

On 3/11/20 12:59 PM, Zenghui Yu wrote:
> Hi Eric,
>=20
> On 2020/3/10 22:54, Eric Auger wrote:
>> Triggers LPIs through the INT command.
>>
>> the test checks the LPI hits the right CPU and triggers
>> the right LPI intid, ie. the translation is correct.
>>
>> Updates to the config table also are tested, along with inv
>> and invall commands.
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>
>> ---
>=20
> [...]
>=20
>> +static void test_its_trigger(void)
>> +{
>> +=C2=A0=C2=A0=C2=A0 struct its_collection *col3, *col2;
>> +=C2=A0=C2=A0=C2=A0 struct its_device *dev2, *dev7;
>> +
>> +=C2=A0=C2=A0=C2=A0 if (its_prerequisites(4))
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return;
>> +
>> +=C2=A0=C2=A0=C2=A0 dev2 =3D its_create_device(2 /* dev id */, 8 /* nb=
_ites */);
>> +=C2=A0=C2=A0=C2=A0 dev7 =3D its_create_device(7 /* dev id */, 8 /* nb=
_ites */);
>> +
>> +=C2=A0=C2=A0=C2=A0 col3 =3D its_create_collection(3 /* col id */, 3/*=
 target PE */);
>> +=C2=A0=C2=A0=C2=A0 col2 =3D its_create_collection(2 /* col id */, 2/*=
 target PE */);
>> +
>> +=C2=A0=C2=A0=C2=A0 gicv3_lpi_set_config(8195, LPI_PROP_DEFAULT);
>> +=C2=A0=C2=A0=C2=A0 gicv3_lpi_set_config(8196, LPI_PROP_DEFAULT);
>> +
>> +=C2=A0=C2=A0=C2=A0 its_send_invall(col2);
>> +=C2=A0=C2=A0=C2=A0 its_send_invall(col3);
>=20
> These two INVALLs should be issued after col2 and col3 are mapped,
> otherwise this will cause the INVALL command error as per the spec
> (though KVM doesn't complain it at all).
Yes you're right. reading the spec again:

A command error occurs if any of the following apply:
../..
The collection specified by ICID has not been mapped to an RDbase using
MAPC.

But as mentionned in the cover letter, no real means to retrieve the
error at the moment.

>=20
>> +
>> +=C2=A0=C2=A0=C2=A0 report_prefix_push("int");
>> +=C2=A0=C2=A0=C2=A0 /*
>> +=C2=A0=C2=A0=C2=A0=C2=A0 * dev=3D2, eventid=3D20=C2=A0 -> lpi=3D 8195=
, col=3D3
>> +=C2=A0=C2=A0=C2=A0=C2=A0 * dev=3D7, eventid=3D255 -> lpi=3D 8196, col=
=3D2
>> +=C2=A0=C2=A0=C2=A0=C2=A0 * Trigger dev2, eventid=3D20 and dev7, event=
id=3D255
>> +=C2=A0=C2=A0=C2=A0=C2=A0 * Check both LPIs hit
>> +=C2=A0=C2=A0=C2=A0=C2=A0 */
>> +
>> +=C2=A0=C2=A0=C2=A0 its_send_mapd(dev2, true);
>> +=C2=A0=C2=A0=C2=A0 its_send_mapd(dev7, true);
>> +
>> +=C2=A0=C2=A0=C2=A0 its_send_mapc(col3, true);
>> +=C2=A0=C2=A0=C2=A0 its_send_mapc(col2, true);
>> +
>> +=C2=A0=C2=A0=C2=A0 its_send_mapti(dev2, 8195 /* lpi id */, 20 /* even=
t id */, col3);
>> +=C2=A0=C2=A0=C2=A0 its_send_mapti(dev7, 8196 /* lpi id */, 255 /* eve=
nt id */, col2);
>> +
>> +=C2=A0=C2=A0=C2=A0 lpi_stats_expect(3, 8195);
>> +=C2=A0=C2=A0=C2=A0 its_send_int(dev2, 20);
>> +=C2=A0=C2=A0=C2=A0 check_lpi_stats("dev=3D2, eventid=3D20=C2=A0 -> lp=
i=3D 8195, col=3D3");
>> +
>> +=C2=A0=C2=A0=C2=A0 lpi_stats_expect(2, 8196);
>> +=C2=A0=C2=A0=C2=A0 its_send_int(dev7, 255);
>> +=C2=A0=C2=A0=C2=A0 check_lpi_stats("dev=3D7, eventid=3D255 -> lpi=3D =
8196, col=3D2");
>> +
>> +=C2=A0=C2=A0=C2=A0 report_prefix_pop();
>> +
>> +=C2=A0=C2=A0=C2=A0 report_prefix_push("inv/invall");
>> +
>> +=C2=A0=C2=A0=C2=A0 /*
>> +=C2=A0=C2=A0=C2=A0=C2=A0 * disable 8195, check dev2/eventid=3D20 does=
 not trigger the
>> +=C2=A0=C2=A0=C2=A0=C2=A0 * corresponding LPI
>> +=C2=A0=C2=A0=C2=A0=C2=A0 */
>> +=C2=A0=C2=A0=C2=A0 gicv3_lpi_set_config(8195, LPI_PROP_DEFAULT & ~LPI=
_PROP_ENABLED);
>> +=C2=A0=C2=A0=C2=A0 its_send_inv(dev2, 20);
>> +
>> +=C2=A0=C2=A0=C2=A0 lpi_stats_expect(-1, -1);
>> +=C2=A0=C2=A0=C2=A0 its_send_int(dev2, 20);
>> +=C2=A0=C2=A0=C2=A0 check_lpi_stats("dev2/eventid=3D20 does not trigge=
r any LPI");
>> +
>> +=C2=A0=C2=A0=C2=A0 /*
>> +=C2=A0=C2=A0=C2=A0=C2=A0 * re-enable the LPI but willingly do not cal=
l invall
>> +=C2=A0=C2=A0=C2=A0=C2=A0 * so the change in config is not taken into =
account.
>> +=C2=A0=C2=A0=C2=A0=C2=A0 * The LPI should not hit
>> +=C2=A0=C2=A0=C2=A0=C2=A0 */
>> +=C2=A0=C2=A0=C2=A0 gicv3_lpi_set_config(8195, LPI_PROP_DEFAULT);
>> +=C2=A0=C2=A0=C2=A0 lpi_stats_expect(-1, -1);
>> +=C2=A0=C2=A0=C2=A0 its_send_int(dev2, 20);
>> +=C2=A0=C2=A0=C2=A0 check_lpi_stats("dev2/eventid=3D20 still does not =
trigger any LPI");
>> +
>> +=C2=A0=C2=A0=C2=A0 /* Now call the invall and check the LPI hits */
>> +=C2=A0=C2=A0=C2=A0 its_send_invall(col3);
>> +=C2=A0=C2=A0=C2=A0 lpi_stats_expect(3, 8195);
>> +=C2=A0=C2=A0=C2=A0 its_send_int(dev2, 20);
>> +=C2=A0=C2=A0=C2=A0 check_lpi_stats("dev2/eventid=3D20 now triggers an=
 LPI");
>> +
>> +=C2=A0=C2=A0=C2=A0 report_prefix_pop();
>> +
>> +=C2=A0=C2=A0=C2=A0 report_prefix_push("mapd valid=3Dfalse");
>> +=C2=A0=C2=A0=C2=A0 /*
>> +=C2=A0=C2=A0=C2=A0=C2=A0 * Unmap device 2 and check the eventid 20 fo=
rmerly
>> +=C2=A0=C2=A0=C2=A0=C2=A0 * attached to it does not hit anymore
>> +=C2=A0=C2=A0=C2=A0=C2=A0 */
>> +
>> +=C2=A0=C2=A0=C2=A0 its_send_mapd(dev2, false);
>> +=C2=A0=C2=A0=C2=A0 lpi_stats_expect(-1, -1);
>> +=C2=A0=C2=A0=C2=A0 its_send_int(dev2, 20);
>> +=C2=A0=C2=A0=C2=A0 check_lpi_stats("no LPI after device unmap");
>> +=C2=A0=C2=A0=C2=A0 report_prefix_pop();
>> +
>> +=C2=A0=C2=A0=C2=A0 /* Unmap the collection this time and check no LPI=
 does hit */
>> +=C2=A0=C2=A0=C2=A0 report_prefix_push("mapc valid=3Dfalse");
>> +=C2=A0=C2=A0=C2=A0 its_send_mapc(col2, false);
>=20
> And as for the MAPC, the spec says:
>=20
> " When V is 0:
> Behavior is unpredictable if there are interrupts that are mapped to th=
e
> specified collection, with the restriction that further translation
> requests from that device are ignored. "
>=20
> So this collection-unmap test may not make sense?
makes sense. Removing it.
>=20
>> +=C2=A0=C2=A0=C2=A0 lpi_stats_expect(-1, -1);
>> +=C2=A0=C2=A0=C2=A0 its_send_int(dev7, 255);
>> +=C2=A0=C2=A0=C2=A0 check_lpi_stats("no LPI after collection unmap");
>> +=C2=A0=C2=A0=C2=A0 report_prefix_pop();
>> +}
>=20
> [...]
>=20
> Otherwise looks good.
Thanks!

Eric
>=20
>=20
> Thanks,
> Zenghui
>=20

