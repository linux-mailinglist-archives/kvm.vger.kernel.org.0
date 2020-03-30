Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B48E21978D7
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 12:20:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729894AbgC3KUN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Mar 2020 06:20:13 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:53028 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729738AbgC3KUK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Mar 2020 06:20:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585563609;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=k6E/dAk2RnlJp9AQMbHdDVYq/j7w3RXnkQoUbm2tREo=;
        b=NY2uipgqmXJI5g174lTUvz1EaAsrNpp4E38e4xboYriYGfM6UrmbvdaCHGH3eM92Jcl7n/
        Xw7NPy63rN4XwpVPDVGHZNCvOZNPkp9Lo2JQeXMJohGZGvoaKC9zGNebBJyOjIrQHhz5Nf
        0x509QS9hK0FTw2OjlMRP8J0x4JQTAE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-149-YRVcN6SzOI-iXKPBNOz4nw-1; Mon, 30 Mar 2020 06:20:05 -0400
X-MC-Unique: YRVcN6SzOI-iXKPBNOz4nw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 88E5F1005509;
        Mon, 30 Mar 2020 10:20:03 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.193.172])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8CDF61001925;
        Mon, 30 Mar 2020 10:19:57 +0000 (UTC)
Date:   Mon, 30 Mar 2020 12:19:55 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Auger Eric <eric.auger@redhat.com>
Cc:     peter.maydell@linaro.org, thuth@redhat.com, kvm@vger.kernel.org,
        maz@kernel.org, qemu-devel@nongnu.org, qemu-arm@nongnu.org,
        andre.przywara@arm.com, Zenghui Yu <yuzenghui@huawei.com>,
        alexandru.elisei@arm.com, kvmarm@lists.cs.columbia.edu,
        eric.auger.pro@gmail.com
Subject: Re: [kvm-unit-tests PATCH v7 06/13] arm/arm64: ITS: Introspection
 tests
Message-ID: <20200330101955.2rlksuzkkvopk52t@kamzik.brq.redhat.com>
References: <20200320092428.20880-1-eric.auger@redhat.com>
 <20200320092428.20880-7-eric.auger@redhat.com>
 <947a79f5-1f79-532b-9ec7-6fd539ccd183@huawei.com>
 <8878be7f-7653-b427-cd0d-722f82fb6b65@redhat.com>
 <20200330091139.i2d6vv64f5diamlz@kamzik.brq.redhat.com>
 <7d6dc4e7-82b4-3c54-574f-2149d4a85c48@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <7d6dc4e7-82b4-3c54-574f-2149d4a85c48@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 30, 2020 at 11:56:00AM +0200, Auger Eric wrote:
> Hi,
>=20
> On 3/30/20 11:11 AM, Andrew Jones wrote:
> > On Mon, Mar 30, 2020 at 10:46:57AM +0200, Auger Eric wrote:
> >> Hi Zenghui,
> >>
> >> On 3/30/20 10:30 AM, Zenghui Yu wrote:
> >>> Hi Eric,
> >>>
> >>> On 2020/3/20 17:24, Eric Auger wrote:
> >>>> +static void its_cmd_queue_init(void)
> >>>> +{
> >>>> +=A0=A0=A0 unsigned long order =3D get_order(SZ_64K >> PAGE_SHIFT)=
;
> >>>> +=A0=A0=A0 u64 cbaser;
> >>>> +
> >>>> +=A0=A0=A0 its_data.cmd_base =3D (void *)virt_to_phys(alloc_pages(=
order));
> >>>
> >>> Shouldn't the cmd_base (and the cmd_write) be set as a GVA?
> >> yes it should
> >=20
> > If it's supposed to be a virtual address, when why do the virt_to_phy=
s?
> What is programmed in CBASER register is a physical address. So the
> virt_to_phys() is relevant. The inconsistency is in its_allocate_entry(=
)
> introduced later on where I return the physical address instead of the
> virtual address. I will fix that.
>=20
>=20
> >=20
> >>>
> >>> Otherwise I think we will end-up with memory corruption when writin=
g
> >>> the command queue.=A0 But it seems that everything just works fine =
...
> >>> So I'm really confused here :-/
> >> I was told by Paolo that the VA/PA memory map is flat in kvmunit tes=
t.
> >=20
> > What does flat mean?
>=20
> Yes I meant an identity map.
>=20
>  kvm-unit-tests, at least arm/arm64, does prepare
> > an identity map of all physical memory, which explains why the above
> > is working.
>=20
> should be the same on x86

Maybe, but I didn't write or review how x86 does their default map, so I
don't know.

>=20
>  It's doing virt_to_phys(some-virt-addr), which gets a
> > phys addr, but when the ITS uses it as a virt addr it works because
> > we *also* have a virt addr =3D=3D phys addr mapping in the default pa=
ge
> > table, which is named "idmap" for good reason.
> >=20
> > I think it would be better to test with the non-identity mapped addre=
sses
> > though.
>=20
> is there any way to exercise a non idmap?

You could create your own map and then switch to it. See lib/arm/asm/mmu-=
api.h

But, you don't have to switch the whole map to use non-identity mapped
addresses. Just create new virt mappings to the phys addresses you're
interested in, and then use those new virt addresses instead. If you're
worried that somewhere an identity mapped virt address is getting used
because of a phys/virt address mix up, then you could probably sprinkle
some assert(virt_to_phys(addr) !=3D addr)'s around to ensure it.

Thanks,
drew

>=20
> Thanks
>=20
> Eric
> >=20
> > Thanks,
> > drew
> >=20
> >>
> >>>
> >>>> +
> >>>> +=A0=A0=A0 cbaser =3D ((u64)its_data.cmd_base | (SZ_64K / SZ_4K - =
1)=A0=A0=A0 |
> >>>> GITS_CBASER_VALID);
> >>>> +
> >>>> +=A0=A0=A0 writeq(cbaser, its_data.base + GITS_CBASER);
> >>>> +
> >>>> +=A0=A0=A0 its_data.cmd_write =3D its_data.cmd_base;
> >>>> +=A0=A0=A0 writeq(0, its_data.base + GITS_CWRITER);
> >>>> +}
> >>>
> >>> Otherwise this looks good,
> >>> Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
> >> Thanks!
> >>
> >> Eric
> >>>
> >>>
> >>> Thanks
> >>>
> >>
> >>
>=20
>=20

