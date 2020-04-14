Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C4CA1A81CA
	for <lists+kvm@lfdr.de>; Tue, 14 Apr 2020 17:15:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437696AbgDNPOu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Apr 2020 11:14:50 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:43842 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2437681AbgDNPOm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Apr 2020 11:14:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586877279;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=ZKlkclfXRZAeObBHEvSM9yom3LW16VfIP/N9NjHmJdY=;
        b=LvdHmtaXp3aR5GBM02GODV0AW2U6U1t/QWO6Y0V6ZOj+ttimYzaNHaqsCE1J5FJ3tm96fQ
        j4nAo1SOpL1QgreJ/CBdaV0J6NOARRrazVRqKQDh/BSA8pKmoZdLjbzeVo+vcKAKTjkElj
        ulcbyd2RXrUQf36P6WWoyMZV9mT5jZg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-319-iDrwLLNpOLy1BM9ba3CkOQ-1; Tue, 14 Apr 2020 11:14:38 -0400
X-MC-Unique: iDrwLLNpOLy1BM9ba3CkOQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4B43E8018A5
        for <kvm@vger.kernel.org>; Tue, 14 Apr 2020 15:14:37 +0000 (UTC)
Received: from [10.10.113.228] (ovpn-113-228.rdu2.redhat.com [10.10.113.228])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0416B60BE1;
        Tue, 14 Apr 2020 15:14:35 +0000 (UTC)
Subject: Re: [Patch v1] x86: Fix the logical destination mode test
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com
Cc:     Marcelo Tosatti <mtosatti@redhat.com>, thuth@redhat.com,
        nilal@redhat.com
References: <1583795750-33197-1-git-send-email-nitesh@redhat.com>
 <20200310140323.GA7132@fuller.cnet>
 <4993e419-5eef-46ba-5dd0-e35c7103190b@redhat.com>
 <878siyyxng.fsf@vitty.brq.redhat.com>
From:   Nitesh Narayan Lal <nitesh@redhat.com>
Autocrypt: addr=nitesh@redhat.com; prefer-encrypt=mutual; keydata=
 mQINBFl4pQoBEADT/nXR2JOfsCjDgYmE2qonSGjkM1g8S6p9UWD+bf7YEAYYYzZsLtbilFTe
 z4nL4AV6VJmC7dBIlTi3Mj2eymD/2dkKP6UXlliWkq67feVg1KG+4UIp89lFW7v5Y8Muw3Fm
 uQbFvxyhN8n3tmhRe+ScWsndSBDxYOZgkbCSIfNPdZrHcnOLfA7xMJZeRCjqUpwhIjxQdFA7
 n0s0KZ2cHIsemtBM8b2WXSQG9CjqAJHVkDhrBWKThDRF7k80oiJdEQlTEiVhaEDURXq+2XmG
 jpCnvRQDb28EJSsQlNEAzwzHMeplddfB0vCg9fRk/kOBMDBtGsTvNT9OYUZD+7jaf0gvBvBB
 lbKmmMMX7uJB+ejY7bnw6ePNrVPErWyfHzR5WYrIFUtgoR3LigKnw5apzc7UIV9G8uiIcZEn
 C+QJCK43jgnkPcSmwVPztcrkbC84g1K5v2Dxh9amXKLBA1/i+CAY8JWMTepsFohIFMXNLj+B
 RJoOcR4HGYXZ6CAJa3Glu3mCmYqHTOKwezJTAvmsCLd3W7WxOGF8BbBjVaPjcZfavOvkin0u
 DaFvhAmrzN6lL0msY17JCZo046z8oAqkyvEflFbC0S1R/POzehKrzQ1RFRD3/YzzlhmIowkM
 BpTqNBeHEzQAlIhQuyu1ugmQtfsYYq6FPmWMRfFPes/4JUU/PQARAQABtCVOaXRlc2ggTmFy
 YXlhbiBMYWwgPG5pbGFsQHJlZGhhdC5jb20+iQI9BBMBCAAnBQJZeKUKAhsjBQkJZgGABQsJ
 CAcCBhUICQoLAgQWAgMBAh4BAheAAAoJEKOGQNwGMqM56lEP/A2KMs/pu0URcVk/kqVwcBhU
 SnvB8DP3lDWDnmVrAkFEOnPX7GTbactQ41wF/xwjwmEmTzLrMRZpkqz2y9mV0hWHjqoXbOCS
 6RwK3ri5e2ThIPoGxFLt6TrMHgCRwm8YuOSJ97o+uohCTN8pmQ86KMUrDNwMqRkeTRW9wWIQ
 EdDqW44VwelnyPwcmWHBNNb1Kd8j3xKlHtnS45vc6WuoKxYRBTQOwI/5uFpDZtZ1a5kq9Ak/
 MOPDDZpd84rqd+IvgMw5z4a5QlkvOTpScD21G3gjmtTEtyfahltyDK/5i8IaQC3YiXJCrqxE
 r7/4JMZeOYiKpE9iZMtS90t4wBgbVTqAGH1nE/ifZVAUcCtycD0f3egX9CHe45Ad4fsF3edQ
 ESa5tZAogiA4Hc/yQpnnf43a3aQ67XPOJXxS0Qptzu4vfF9h7kTKYWSrVesOU3QKYbjEAf95
 NewF9FhAlYqYrwIwnuAZ8TdXVDYt7Z3z506//sf6zoRwYIDA8RDqFGRuPMXUsoUnf/KKPrtR
 ceLcSUP/JCNiYbf1/QtW8S6Ca/4qJFXQHp0knqJPGmwuFHsarSdpvZQ9qpxD3FnuPyo64S2N
 Dfq8TAeifNp2pAmPY2PAHQ3nOmKgMG8Gn5QiORvMUGzSz8Lo31LW58NdBKbh6bci5+t/HE0H
 pnyVf5xhNC/FuQINBFl4pQoBEACr+MgxWHUP76oNNYjRiNDhaIVtnPRqxiZ9v4H5FPxJy9UD
 Bqr54rifr1E+K+yYNPt/Po43vVL2cAyfyI/LVLlhiY4yH6T1n+Di/hSkkviCaf13gczuvgz4
 KVYLwojU8+naJUsiCJw01MjO3pg9GQ+47HgsnRjCdNmmHiUQqksMIfd8k3reO9SUNlEmDDNB
 XuSzkHjE5y/R/6p8uXaVpiKPfHoULjNRWaFc3d2JGmxJpBdpYnajoz61m7XJlgwl/B5Ql/6B
 dHGaX3VHxOZsfRfugwYF9CkrPbyO5PK7yJ5vaiWre7aQ9bmCtXAomvF1q3/qRwZp77k6i9R3
 tWfXjZDOQokw0u6d6DYJ0Vkfcwheg2i/Mf/epQl7Pf846G3PgSnyVK6cRwerBl5a68w7xqVU
 4KgAh0DePjtDcbcXsKRT9D63cfyfrNE+ea4i0SVik6+N4nAj1HbzWHTk2KIxTsJXypibOKFX
 2VykltxutR1sUfZBYMkfU4PogE7NjVEU7KtuCOSAkYzIWrZNEQrxYkxHLJsWruhSYNRsqVBy
 KvY6JAsq/i5yhVd5JKKU8wIOgSwC9P6mXYRgwPyfg15GZpnw+Fpey4bCDkT5fMOaCcS+vSU1
 UaFmC4Ogzpe2BW2DOaPU5Ik99zUFNn6cRmOOXArrryjFlLT5oSOe4IposgWzdwARAQABiQIl
 BBgBCAAPBQJZeKUKAhsMBQkJZgGAAAoJEKOGQNwGMqM5ELoP/jj9d9gF1Al4+9bngUlYohYu
 0sxyZo9IZ7Yb7cHuJzOMqfgoP4tydP4QCuyd9Q2OHHL5AL4VFNb8SvqAxxYSPuDJTI3JZwI7
 d8JTPKwpulMSUaJE8ZH9n8A/+sdC3CAD4QafVBcCcbFe1jifHmQRdDrvHV9Es14QVAOTZhnJ
 vweENyHEIxkpLsyUUDuVypIo6y/Cws+EBCWt27BJi9GH/EOTB0wb+2ghCs/i3h8a+bi+bS7L
 FCCm/AxIqxRurh2UySn0P/2+2eZvneJ1/uTgfxnjeSlwQJ1BWzMAdAHQO1/lnbyZgEZEtUZJ
 x9d9ASekTtJjBMKJXAw7GbB2dAA/QmbA+Q+Xuamzm/1imigz6L6sOt2n/X/SSc33w8RJUyor
 SvAIoG/zU2Y76pKTgbpQqMDmkmNYFMLcAukpvC4ki3Sf086TdMgkjqtnpTkEElMSFJC8npXv
 3QnGGOIfFug/qs8z03DLPBz9VYS26jiiN7QIJVpeeEdN/LKnaz5LO+h5kNAyj44qdF2T2AiF
 HxnZnxO5JNP5uISQH3FjxxGxJkdJ8jKzZV7aT37sC+Rp0o3KNc+GXTR+GSVq87Xfuhx0LRST
 NK9ZhT0+qkiN7npFLtNtbzwqaqceq3XhafmCiw8xrtzCnlB/C4SiBr/93Ip4kihXJ0EuHSLn
 VujM7c/b4pps
Organization: Red Hat Inc,
Message-ID: <b0482ffb-a1e0-7d00-8883-53936487b955@redhat.com>
Date:   Tue, 14 Apr 2020 11:14:34 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <878siyyxng.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/14/20 10:01 AM, Vitaly Kuznetsov wrote:
> Nitesh Narayan Lal <nitesh@redhat.com> writes:
>
>> On 3/10/20 10:03 AM, Marcelo Tosatti wrote:
>>> On Mon, Mar 09, 2020 at 07:15:50PM -0400, Nitesh Narayan Lal wrote:
>>>> There are following issues with the ioapic logical destination mode =
test:
>>>>
>>>> - A race condition that is triggered when the interrupt handler
>>>> =C2=A0 ioapic_isr_86() is called at the same time by multiple vCPUs.=
 Due to this
>>>>   the g_isr_86 is not correctly incremented. To prevent this a spinl=
ock is
>>>>   added around =E2=80=98g_isr_86++=E2=80=99.
>>>>
>>>> - On older QEMU versions initial x2APIC ID is not set, that is why
>>>> =C2=A0 the local APIC IDs of each vCPUs are not configured. Hence th=
e logical
>>>> =C2=A0 destination mode test fails/hangs. Adding =E2=80=98+x2apic=E2=
=80=99 to the qemu -cpu params
>>>> =C2=A0 ensures that the local APICs are configured every time, irres=
pective of the
>>>> =C2=A0 QEMU version.
>>>>
>>>> - With =E2=80=98-machine kernel_irqchip=3Dsplit=E2=80=99 included in=
 the ioapic test
>>>> =C2=A0 test_ioapic_self_reconfigure() always fails and somehow leads=
 to a state where
>>>> =C2=A0 after submitting IOAPIC fixed delivery - logical destination =
mode request we
>>>> =C2=A0 never receive an interrupt back. For now, the physical and lo=
gical destination
>>>> =C2=A0 mode tests are moved above test_ioapic_self_reconfigure().
>>>>
>>>> Fixes: b2a1ee7e ("kvm-unit-test: x86: ioapic: Test physical and logi=
cal destination mode")
>>>> Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
>>> Looks good to me.
>> Hi,
>>
>> I just wanted to follow up and see if there are any more suggestions f=
or me to
>> improve this patch before it can be merged.
>>
>>
>>>> ---
>>>>  x86/ioapic.c      | 11 +++++++----
>>>>  x86/unittests.cfg |  2 +-
>>>>  2 files changed, 8 insertions(+), 5 deletions(-)
>>>>
>>>> diff --git a/x86/ioapic.c b/x86/ioapic.c
>>>> index 742c711..3106531 100644
>>>> --- a/x86/ioapic.c
>>>> +++ b/x86/ioapic.c
>>>> @@ -432,10 +432,13 @@ static void test_ioapic_physical_destination_m=
ode(void)
>>>>  }
>>>> =20
>>>>  static volatile int g_isr_86;
>>>> +struct spinlock ioapic_lock;
>>>> =20
>>>>  static void ioapic_isr_86(isr_regs_t *regs)
>>>>  {
>>>> +	spin_lock(&ioapic_lock);
>>>>  	++g_isr_86;
>>>> +	spin_unlock(&ioapic_lock);
>>>>  	set_irq_line(0x0e, 0);
>>>>  	eoi();
>>>>  }
>>>> @@ -501,6 +504,10 @@ int main(void)
>>>>  	test_ioapic_level_tmr(true);
>>>>  	test_ioapic_edge_tmr(true);
>>>> =20
>>>> +	test_ioapic_physical_destination_mode();
> I just found out that this particular change causes 'ioapic-split' test=

> to hang reliably:=20
>
> # ./run_tests.sh ioapic-split
> FAIL ioapic-split (timeout; duration=3D90s)
> PASS ioapic (26 tests)
>
> unlike 'ioapic' test we run it with '-smp 1' and
> 'test_ioapic_physical_destination_mode' requires > 1 CPU to work AFAICT=
=2E

Yes, that is correct.
It's my bad as I didn't realize that I introduced this bug while submitti=
ng this
patch.

>
> Why do we move it from under 'if (cpu_count() > 1)' ?

I should have just moved it above test_ioapic_self_reconfigure().

>
> Also, this patch could've been split.

I can divide it 2 parts:
1. support for logical destination mode.
2. support for physical destination mode. I can also fix=C2=A0 the above =
issue in
this patch itself.
Does that make sense?

>
>>>> +	if (cpu_count() > 3)
>>>> +		test_ioapic_logical_destination_mode();
>>>> +
>>>>  	if (cpu_count() > 1) {
>>>>  		test_ioapic_edge_tmr_smp(false);
>>>>  		test_ioapic_level_tmr_smp(false);
>>>> @@ -508,11 +515,7 @@ int main(void)
>>>>  		test_ioapic_edge_tmr_smp(true);
>>>> =20
>>>>  		test_ioapic_self_reconfigure();
>>>> -		test_ioapic_physical_destination_mode();
>>>>  	}
>>>> =20
>>>> -	if (cpu_count() > 3)
>>>> -		test_ioapic_logical_destination_mode();
>>>> -
>>>>  	return report_summary();
>>>>  }
>>>> diff --git a/x86/unittests.cfg b/x86/unittests.cfg
>>>> index f2401eb..d658bc8 100644
>>>> --- a/x86/unittests.cfg
>>>> +++ b/x86/unittests.cfg
>>>> @@ -46,7 +46,7 @@ timeout =3D 30
>>>>  [ioapic]
>>>>  file =3D ioapic.flat
>>>>  smp =3D 4
>>>> -extra_params =3D -cpu qemu64
>>>> +extra_params =3D -cpu qemu64,+x2apic
>>>>  arch =3D x86_64
>>>> =20
>>>>  [cmpxchg8b]
>>>> --=20
>>>> 1.8.3.1
--=20
Nitesh

