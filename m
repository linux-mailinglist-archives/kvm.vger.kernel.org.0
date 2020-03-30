Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4FD0197940
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 12:24:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728967AbgC3KYv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Mar 2020 06:24:51 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:21460 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728764AbgC3KYv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Mar 2020 06:24:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585563889;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hV3tcQVZBDcc35pPKZYbOzggPvGr6YLo9yi3ZRnZDd4=;
        b=fhxim3syvTUNrR+kmd+PKbjgpGt7nJIQXtjk9QnjnBeAn72fF5bc8ogSsO0hiyYcWWsWqn
        bNr7UMsw9jSXjz0uRW0Yk7NYECBrvn7NkJVQfmheJbykjPJjfNQMv7MLphRZKHiWgxprei
        mlDD5zWI8mJBBsftcuytZiCM2H9cIvA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-438-PQUSFHo_ObOqDO3zjTfwqA-1; Mon, 30 Mar 2020 06:24:47 -0400
X-MC-Unique: PQUSFHo_ObOqDO3zjTfwqA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DE8ED100551A;
        Mon, 30 Mar 2020 10:24:45 +0000 (UTC)
Received: from [10.36.112.58] (ovpn-112-58.ams2.redhat.com [10.36.112.58])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7AFDD96B82;
        Mon, 30 Mar 2020 10:24:39 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v7 06/13] arm/arm64: ITS: Introspection
 tests
To:     Andrew Jones <drjones@redhat.com>
Cc:     peter.maydell@linaro.org, thuth@redhat.com, kvm@vger.kernel.org,
        maz@kernel.org, qemu-devel@nongnu.org, qemu-arm@nongnu.org,
        andre.przywara@arm.com, Zenghui Yu <yuzenghui@huawei.com>,
        alexandru.elisei@arm.com, kvmarm@lists.cs.columbia.edu,
        eric.auger.pro@gmail.com
References: <20200320092428.20880-1-eric.auger@redhat.com>
 <20200320092428.20880-7-eric.auger@redhat.com>
 <947a79f5-1f79-532b-9ec7-6fd539ccd183@huawei.com>
 <8878be7f-7653-b427-cd0d-722f82fb6b65@redhat.com>
 <20200330091139.i2d6vv64f5diamlz@kamzik.brq.redhat.com>
 <7d6dc4e7-82b4-3c54-574f-2149d4a85c48@redhat.com>
 <20200330101955.2rlksuzkkvopk52t@kamzik.brq.redhat.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <6a939f4b-f1b4-ff59-b074-aebb1b4e046a@redhat.com>
Date:   Mon, 30 Mar 2020 12:24:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20200330101955.2rlksuzkkvopk52t@kamzik.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Drew,

On 3/30/20 12:19 PM, Andrew Jones wrote:
> On Mon, Mar 30, 2020 at 11:56:00AM +0200, Auger Eric wrote:
>> Hi,
>>
>> On 3/30/20 11:11 AM, Andrew Jones wrote:
>>> On Mon, Mar 30, 2020 at 10:46:57AM +0200, Auger Eric wrote:
>>>> Hi Zenghui,
>>>>
>>>> On 3/30/20 10:30 AM, Zenghui Yu wrote:
>>>>> Hi Eric,
>>>>>
>>>>> On 2020/3/20 17:24, Eric Auger wrote:
>>>>>> +static void its_cmd_queue_init(void)
>>>>>> +{
>>>>>> +=C2=A0=C2=A0=C2=A0 unsigned long order =3D get_order(SZ_64K >> PA=
GE_SHIFT);
>>>>>> +=C2=A0=C2=A0=C2=A0 u64 cbaser;
>>>>>> +
>>>>>> +=C2=A0=C2=A0=C2=A0 its_data.cmd_base =3D (void *)virt_to_phys(all=
oc_pages(order));
>>>>>
>>>>> Shouldn't the cmd_base (and the cmd_write) be set as a GVA?
>>>> yes it should
>>>
>>> If it's supposed to be a virtual address, when why do the virt_to_phy=
s?
>> What is programmed in CBASER register is a physical address. So the
>> virt_to_phys() is relevant. The inconsistency is in its_allocate_entry=
()
>> introduced later on where I return the physical address instead of the
>> virtual address. I will fix that.
>>
>>
>>>
>>>>>
>>>>> Otherwise I think we will end-up with memory corruption when writin=
g
>>>>> the command queue.=C2=A0 But it seems that everything just works fi=
ne ...
>>>>> So I'm really confused here :-/
>>>> I was told by Paolo that the VA/PA memory map is flat in kvmunit tes=
t.
>>>
>>> What does flat mean?
>>
>> Yes I meant an identity map.
>>
>>  kvm-unit-tests, at least arm/arm64, does prepare
>>> an identity map of all physical memory, which explains why the above
>>> is working.
>>
>> should be the same on x86
>=20
> Maybe, but I didn't write or review how x86 does their default map, so =
I
> don't know.
>=20
>>
>>  It's doing virt_to_phys(some-virt-addr), which gets a
>>> phys addr, but when the ITS uses it as a virt addr it works because
>>> we *also* have a virt addr =3D=3D phys addr mapping in the default pa=
ge
>>> table, which is named "idmap" for good reason.
>>>
>>> I think it would be better to test with the non-identity mapped addre=
sses
>>> though.
>>
>> is there any way to exercise a non idmap?
>=20
> You could create your own map and then switch to it. See lib/arm/asm/mm=
u-api.h
>=20
> But, you don't have to switch the whole map to use non-identity mapped
> addresses. Just create new virt mappings to the phys addresses you're
> interested in, and then use those new virt addresses instead. If you're
> worried that somewhere an identity mapped virt address is getting used
> because of a phys/virt address mix up, then you could probably sprinkle
> some assert(virt_to_phys(addr) !=3D addr)'s around to ensure it.

OK. Well I don't know if it is worth the candle. I will review the code
again and fix the remaining inconsistencies I can see.

Thanks

Eric
>=20
> Thanks,
> drew
>=20
>>
>> Thanks
>>
>> Eric
>>>
>>> Thanks,
>>> drew
>>>
>>>>
>>>>>
>>>>>> +
>>>>>> +=C2=A0=C2=A0=C2=A0 cbaser =3D ((u64)its_data.cmd_base | (SZ_64K /=
 SZ_4K - 1)=C2=A0=C2=A0=C2=A0 |
>>>>>> GITS_CBASER_VALID);
>>>>>> +
>>>>>> +=C2=A0=C2=A0=C2=A0 writeq(cbaser, its_data.base + GITS_CBASER);
>>>>>> +
>>>>>> +=C2=A0=C2=A0=C2=A0 its_data.cmd_write =3D its_data.cmd_base;
>>>>>> +=C2=A0=C2=A0=C2=A0 writeq(0, its_data.base + GITS_CWRITER);
>>>>>> +}
>>>>>
>>>>> Otherwise this looks good,
>>>>> Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
>>>> Thanks!
>>>>
>>>> Eric
>>>>>
>>>>>
>>>>> Thanks
>>>>>
>>>>
>>>>
>>
>>

