Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B15B19C47B
	for <lists+kvm@lfdr.de>; Thu,  2 Apr 2020 16:41:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732754AbgDBOla (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Apr 2020 10:41:30 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:37672 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726927AbgDBOla (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 2 Apr 2020 10:41:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585838489;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LQlIPwSA6eO8FaNGqaPVKwSvrWhWEma0a4EepOgZn9Y=;
        b=atPJIU3pA8KzMLInKyK4TWyS5oY3Cfo0p9CrCD7uGZWBNc7eaHGeV7G/Wc1C26P4Ntq2k5
        vk1l0sUaNiwcd0OjtqkytcUzUmBOU/3NWfe79esUHZAHEezVweM5wqXq6fIKrc8b3GilRs
        CEzcPVfcGW4Ot3un34WyHD6tsUFfjjY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-497-jcwdGm7hNY6oM0oaAdC1ag-1; Thu, 02 Apr 2020 10:41:25 -0400
X-MC-Unique: jcwdGm7hNY6oM0oaAdC1ag-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 94C7419067E7;
        Thu,  2 Apr 2020 14:41:23 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.77])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 78A36D768E;
        Thu,  2 Apr 2020 14:41:15 +0000 (UTC)
Date:   Thu, 2 Apr 2020 16:41:12 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Zenghui Yu <yuzenghui@huawei.com>
Cc:     Auger Eric <eric.auger@redhat.com>, peter.maydell@linaro.org,
        kvm@vger.kernel.org, maz@kernel.org, qemu-devel@nongnu.org,
        qemu-arm@nongnu.org, andre.przywara@arm.com, thuth@redhat.com,
        alexandru.elisei@arm.com, kvmarm@lists.cs.columbia.edu,
        eric.auger.pro@gmail.com
Subject: Re: [kvm-unit-tests PATCH v7 10/13] arm/arm64: ITS: INT functional
 tests
Message-ID: <20200402144112.u6nwzkqe7mt3rr6c@kamzik.brq.redhat.com>
References: <20200320092428.20880-1-eric.auger@redhat.com>
 <20200320092428.20880-11-eric.auger@redhat.com>
 <f7f1d7c4-2321-9123-2394-528af737bfa7@huawei.com>
 <fa4e14f6-20ee-982f-0eda-74b101cddf7a@redhat.com>
 <114f8bba-a1e0-0367-a1b4-e875718d8dba@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <114f8bba-a1e0-0367-a1b4-e875718d8dba@huawei.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 02, 2020 at 08:40:42PM +0800, Zenghui Yu wrote:
> Hi Eric,
>=20
> On 2020/4/2 16:50, Auger Eric wrote:
> > Hi Zenghui,
> >=20
> > On 3/30/20 12:43 PM, Zenghui Yu wrote:
> > > Hi Eric,
> > >=20
> > > On 2020/3/20 17:24, Eric Auger wrote:
> > > > Triggers LPIs through the INT command.
> > > >=20
> > > > the test checks the LPI hits the right CPU and triggers
> > > > the right LPI intid, ie. the translation is correct.
> > > >=20
> > > > Updates to the config table also are tested, along with inv
> > > > and invall commands.
> > > >=20
> > > > Signed-off-by: Eric Auger <eric.auger@redhat.com>
> > >=20
> > > [...]
> > >=20
> > > So I've tested this series and found that the "INT" test will somet=
imes
> > > fail.
> > >=20
> > > "not ok 12 - gicv3: its-migration: dev2/eventid=3D20 triggers LPI 8=
195 en
> > > PE #3 after migration
> > > not ok 13 - gicv3: its-migration: dev7/eventid=3D255 triggers LPI 8=
196 on
> > > PE #2 after migration"
> > >=20
> > >  From logs:
> > > "INFO: gicv3: its-migration: Migration complete
> > > INT dev_id=3D2 event_id=3D20
> > > INFO: gicv3: its-migration: No LPI received whereas (cpuid=3D3,
> > > intid=3D8195) was expected
> > > FAIL: gicv3: its-migration: dev2/eventid=3D20 triggers LPI 8195 en =
PE #3
> > > after migration
> > > INT dev_id=3D7 event_id=3D255
> > > INFO: gicv3: its-migration: No LPI received whereas (cpuid=3D2,
> > > intid=3D8196) was expected
> > > FAIL: gicv3: its-migration: dev7/eventid=3D255 triggers LPI 8196 on=
 PE #2
> > > after migration"
> > >=20
> > > > +static void check_lpi_stats(const char *msg)
> > > > +{
> > > > +=A0=A0=A0 bool pass =3D false;
> > > > +
> > > > +=A0=A0=A0 mdelay(100);
> > >=20
> > > After changing this to 'mdelay(1000)', the above error doesn't show=
 up
> > > anymore. But it sounds strange that 100ms is not enough to deliver =
a
> > > single LPI. I haven't dig it further but will get back here later.
> >=20
> > Did you find some time to investigate this issue. Changing 100 to 100=
0
> > has a huge impact on the overall test duration and I don't think it i=
s
> > sensible. Could you see what is your minimal value that pass the test=
s?
>=20
> I can reproduce this issue with a very *low* probability so I failed
> to investigate it :-(.  (It might because the LPI was delivered to a
> busy vcpu...)
>=20
> You can leave it as it is until someone else complain about it again.
> Or take the similar approach as check_acked() - wait up to 5s for the
> interrupt to be delivered, and bail out as soon as we see it.

I think the check_acked approach would be the best approach.

Thanks,
drew

>=20
>=20
> Thanks,
> Zenghui
>=20
>=20

