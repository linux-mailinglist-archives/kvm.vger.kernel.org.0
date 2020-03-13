Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28507184265
	for <lists+kvm@lfdr.de>; Fri, 13 Mar 2020 09:18:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726822AbgCMISN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Mar 2020 04:18:13 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:52339 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726697AbgCMIRz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Mar 2020 04:17:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584087474;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BkfTBkxp5txNCOlskJxS6kz6+SU8BlpUA68Svo5CBgs=;
        b=BtfqPVjgg0pvAbwU8xqeORIZz0A3PUz8VN3Gqk4gE4sxU0CJOn77J93scr/GCRNrfmot5D
        yy7BztRczBqlRnRecBB3JUkrVKkhQCqiun4C590KNKVg5hPhMxqXSTXGSA/t7XstdRivlz
        g9IOHPulzsa6oukx+ugUF3hNixD/Olc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-44-5CGfopJANheQnmlY3EVVng-1; Fri, 13 Mar 2020 04:17:51 -0400
X-MC-Unique: 5CGfopJANheQnmlY3EVVng-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 092BA800D5B;
        Fri, 13 Mar 2020 08:17:50 +0000 (UTC)
Received: from [10.36.118.12] (unknown [10.36.118.12])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 709175C1B5;
        Fri, 13 Mar 2020 08:17:43 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v6 10/13] arm/arm64: ITS: INT functional
 tests
To:     Zenghui Yu <yuzenghui@huawei.com>, eric.auger.pro@gmail.com,
        maz@kernel.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc:     drjones@redhat.com, andre.przywara@arm.com,
        peter.maydell@linaro.org, alexandru.elisei@arm.com,
        thuth@redhat.com
References: <20200311135117.9366-1-eric.auger@redhat.com>
 <20200311135117.9366-11-eric.auger@redhat.com>
 <7d79cc12-acdb-ff56-594d-3fa830f7d053@huawei.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <881583f3-ea9c-64ba-437f-4401f3aaf1ac@redhat.com>
Date:   Fri, 13 Mar 2020 09:17:40 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <7d79cc12-acdb-ff56-594d-3fa830f7d053@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Zenghui,
On 3/13/20 3:06 AM, Zenghui Yu wrote:
> On 2020/3/11 21:51, Eric Auger wrote:
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
>> +=C2=A0=C2=A0=C2=A0 its_send_invall(col2);
>> +=C2=A0=C2=A0=C2=A0 its_send_invall(col3);
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
>=20
> Here. You issued an INT command while the dev2 has just been unmapped,
> this will be detected by ITS as a command error. We may end-up failed
> to see the completion of this command (under the ITS stall mode).
I agree this is a case where it is expected to fail. However at the
moment we don't have stall kernel support and the way I test it fails is
by issuing the below
lpi_stats_expect(-1, -1);
check_lpi_stats("no LPI after device unmap");

Otherwise I cannot test this scenario.

I suggest once we get the stall support in kernel, we revisit the tests.

Thanks

Eric

>=20
>=20
> Thanks,
> Zenghui
>=20
>> +=C2=A0=C2=A0=C2=A0 check_lpi_stats("no LPI after device unmap");
>> +=C2=A0=C2=A0=C2=A0 report_prefix_pop();
>> +}
>=20

