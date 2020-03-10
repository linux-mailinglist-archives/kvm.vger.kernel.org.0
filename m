Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B1801800D6
	for <lists+kvm@lfdr.de>; Tue, 10 Mar 2020 15:56:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727598AbgCJO4Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Mar 2020 10:56:24 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:39369 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727532AbgCJO4Y (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 10 Mar 2020 10:56:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583852183;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=F6Y9O3L6ux6zcyjxR98H17Ex0dxMm2pHA4GBIrRUtcw=;
        b=Fx9SAMIsXOanlte0TY5PpiAEXhzuF3byF7Iq6JwbYeXjGEgjJ8MOa+8EGgAOMcHanwrQs6
        C+L5F1dDbyYDipDwHhcvN1OSDm6+e5uHzTpJTZ91mx3rfaG53ZrxdtZJbDoqsXFs9jjymt
        lljEyQ7/m9/zYL4LSKeEQ8s5c99Vjaw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-240-sfzD9SM5NJ6iyJlr4oKb0Q-1; Tue, 10 Mar 2020 10:56:19 -0400
X-MC-Unique: sfzD9SM5NJ6iyJlr4oKb0Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 47CA919067E1;
        Tue, 10 Mar 2020 14:56:17 +0000 (UTC)
Received: from [10.36.117.85] (ovpn-117-85.ams2.redhat.com [10.36.117.85])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A6F5E5C28D;
        Tue, 10 Mar 2020 14:56:14 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v4 00/13] arm/arm64: Add ITS tests
To:     Zenghui Yu <yuzenghui@huawei.com>,
        Andrew Jones <drjones@redhat.com>
Cc:     eric.auger.pro@gmail.com, maz@kernel.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org,
        peter.maydell@linaro.org, andre.przywara@arm.com, thuth@redhat.com,
        alexandru.elisei@arm.com
References: <20200309102420.24498-1-eric.auger@redhat.com>
 <20200309115741.6stx5tpkb6s6ejzh@kamzik.brq.redhat.com>
 <20200309120012.xkgmlbvd5trm6ewk@kamzik.brq.redhat.com>
 <5cfe64d3-e609-cd1e-4f92-e24cf5f62c77@huawei.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <4a80c1d0-e33f-b1d9-c8d5-3a2fb01104db@redhat.com>
Date:   Tue, 10 Mar 2020 15:56:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <5cfe64d3-e609-cd1e-4f92-e24cf5f62c77@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Zenghui,

On 3/10/20 11:18 AM, Zenghui Yu wrote:
> On 2020/3/9 20:00, Andrew Jones wrote:
>> On Mon, Mar 09, 2020 at 12:57:51PM +0100, Andrew Jones wrote:
>>> This looks pretty good to me. It just needs some resquashing cleanups=
.
>>> Does Andre plan to review? I've only been reviewing with respect to
>>> the framework, not ITS. If no other reviews are expected, then I'll
>>> queue the next version.
>>
>> Oops, sorry Zenghui, I forgot to ask if you'll be reviewing again as
>> well.
>=20
> I'd like to have a look again this week if time permits :-).=C2=A0 Than=
ks
> for reminding me.
I have just sent:

[kvm-unit-tests PATCH v5 00/13] arm/arm64: Add ITS tests

where I took last Drew's comments

Thanks

Eric
>=20
>=20
> Zenghui
>=20

