Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2B4DFE09C
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2019 15:55:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727786AbfKOOzu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Nov 2019 09:55:50 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:32072 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727799AbfKOOzs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 Nov 2019 09:55:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573829748;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0rorQVHKK9jfAoq/OSb/+Jl9+t1z4hwT4nWpoleuD6s=;
        b=Hw8KZv6qo/ROgH2xZt1qFuS7bb1/a136O2wjh3mPFPUJFvtQBVuwvRoTcsPxTDPgR+WrIo
        7mNy5Rs+gqJNxgV79czheqR8Wy279raoESmllzBCMibmaZAgF6nHdVLmMW7xLozm6v9laS
        1mDiz87Ek0uXgMwwGIC+/SdWFTNWzFw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-51-U1O2p4rXNzuo3glGwPq_PQ-1; Fri, 15 Nov 2019 09:55:45 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6F2ED104FB65;
        Fri, 15 Nov 2019 14:55:42 +0000 (UTC)
Received: from localhost (unknown [10.43.2.114])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B67DD4645F;
        Fri, 15 Nov 2019 14:55:29 +0000 (UTC)
Date:   Fri, 15 Nov 2019 15:55:27 +0100
From:   Igor Mammedov <imammedo@redhat.com>
To:     gengdongjiu <gengdongjiu@huawei.com>
Cc:     "zhengxiang (A)" <zhengxiang9@huawei.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "mst@redhat.com" <mst@redhat.com>,
        "shannon.zhaosl@gmail.com" <shannon.zhaosl@gmail.com>,
        "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
        "lersek@redhat.com" <lersek@redhat.com>,
        "james.morse@arm.com" <james.morse@arm.com>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "rth@twiddle.net" <rth@twiddle.net>,
        "ehabkost@redhat.com" <ehabkost@redhat.com>,
        "Jonathan Cameron" <jonathan.cameron@huawei.com>,
        "xuwei (O)" <xuwei5@huawei.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "qemu-arm@nongnu.org" <qemu-arm@nongnu.org>,
        Linuxarm <linuxarm@huawei.com>,
        "Wanghaibin (D)" <wanghaibin.wang@huawei.com>
Subject: Re: [RESEND PATCH v21 3/6] ACPI: Add APEI GHES table generation
 support
Message-ID: <20191115155527.287ee95b@redhat.com>
In-Reply-To: <19b1b4b9ceb24aad9f34ab4e58bccab3@huawei.com>
References: <19b1b4b9ceb24aad9f34ab4e58bccab3@huawei.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: U1O2p4rXNzuo3glGwPq_PQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 15 Nov 2019 14:32:47 +0000
gengdongjiu <gengdongjiu@huawei.com> wrote:

> > > + */
> > > +static void acpi_ghes_build_notify(GArray *table, const uint8_t type=
) =20
> >=20
> > typically format should be build_WHAT(), so
> >  build_ghes_hw_error_notification()
> >=20
> > And I'd move this out into its own patch.
> > this applies to other trivial in-depended sub-tables, that take all dat=
a needed to construct them from supplied arguments. =20
>=20
> I very used your suggested method in previous series[1], but other mainta=
iner suggested to move this function to this file, because he think only GH=
ES used it

Using this file is ok, what I've meant for you to split function from
this patch into a separate smaller patch.

With the way code split now I have to review 2 big complex patches at
the same which makes reviewing hard and I have a hard time convincing
myself that code it correct.

Moving small self-contained chunks of code in to separate smaller patches
makes review easier.

>=20
> [1]:
> https://patchwork.ozlabs.org/cover/1099428/
>=20
> >  =20
> > > +{
> > > +        /* Type */
> > > +        build_append_int_noprefix(table, type, 1);
> > > +        /*
> > > +         * Length:
> > > +         * Total length of the structure in bytes
> > > +         */
> > > +        build_append_int_noprefix(table, 28, 1);
> > > +        /* Configuration Write Enable */
> > > +        build_append_int_noprefix(table, 0, 2);
> > > +        /* Poll Interval */
> > > +        build_append_int_noprefix(table, 0, 4);
> > > +        /* Vector */
> > > +        build_append_int_noprefix(table, 0, 4);
> > > +        /* Switch To Polling Threshold Value */
> > > +        build_append_int_noprefix(table, 0, 4);
> > > +        /* Switch To Polling Threshold Window */
> > > +        build_append_int_noprefix(table, 0, 4);
> > > +        /* Error Threshold Value */
> > > +        build_append_int_noprefix(table, 0, 4);
> > > +        /* Error Threshold Window */
> > > +        build_append_int_noprefix(table, 0, 4); }
> > > + =20
> >=20
> > /*
> >   Initialize "etc/hardware_errors" and "etc/hardware_errors_addr" fwcfg=
 blobs.
> >   See docs/specs/acpi_hest_ghes.rst for blobs format */ =20
> > > +void acpi_ghes_build_error_table(GArray *hardware_errors, BIOSLinker
> > > +*linker) =20
> > build_ghes_error_table()
> >=20
> > also I'd move this function into its own patch along with other related=
 code that initializes and wires it into virt board. =20
>=20
> I ever use your suggested method[1], but other maintainer, it seems Micha=
el, suggested to move these functions to this file that used it, because he=
 think only GHES used it.
>=20
> [1]:
> https://patchwork.ozlabs.org/patch/1099424/
> https://patchwork.ozlabs.org/patch/1099425/
> https://patchwork.ozlabs.org/patch/1099430/
>=20
>=20

