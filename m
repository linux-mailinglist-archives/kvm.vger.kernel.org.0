Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E7A91A84D1
	for <lists+kvm@lfdr.de>; Tue, 14 Apr 2020 18:27:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391581AbgDNQ1i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Apr 2020 12:27:38 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:20812 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2391568AbgDNQ12 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Apr 2020 12:27:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586881646;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=pVA8qopL5b6vNGPhQ5Z5/UT+WYvEetAs8g32JsQXu48=;
        b=W4qSf1OwrR63B/bITSe346ngQpUVxA2iWQXFom0pwGOBuJSi/mVm8DSrnOXD0y95i7eG2S
        /XIEAoSczH6IzdQx+ZNaLAMLFgOsaa9NcAhlfrD0Gzv6XZhlfMSh1/UB+48S1zzMmV/Xpx
        93duKNsim9yp9DtbkQdUP+c0aXNOkDM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-107-MADDdcATOBuW7GWeDohFug-1; Tue, 14 Apr 2020 12:27:24 -0400
X-MC-Unique: MADDdcATOBuW7GWeDohFug-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2E9CBDB23
        for <kvm@vger.kernel.org>; Tue, 14 Apr 2020 16:27:23 +0000 (UTC)
Received: from [10.10.113.228] (ovpn-113-228.rdu2.redhat.com [10.10.113.228])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B9B8360BEC;
        Tue, 14 Apr 2020 16:27:21 +0000 (UTC)
Subject: Re: [Patch v1] x86: Fix the logical destination mode test
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Marcelo Tosatti <mtosatti@redhat.com>, thuth@redhat.com,
        nilal@redhat.com, kvm@vger.kernel.org, pbonzini@redhat.com
References: <1583795750-33197-1-git-send-email-nitesh@redhat.com>
 <20200310140323.GA7132@fuller.cnet>
 <4993e419-5eef-46ba-5dd0-e35c7103190b@redhat.com>
 <878siyyxng.fsf@vitty.brq.redhat.com>
 <b0482ffb-a1e0-7d00-8883-53936487b955@redhat.com>
 <87wo6ixeyq.fsf@vitty.brq.redhat.com>
 <3c9c379c-c027-2793-6148-3b677054740e@redhat.com>
 <87r1wqxd1f.fsf@vitty.brq.redhat.com>
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
Message-ID: <6d283139-4dad-03eb-40e2-bf1d65c9064b@redhat.com>
Date:   Tue, 14 Apr 2020 12:27:19 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <87r1wqxd1f.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/14/20 12:11 PM, Vitaly Kuznetsov wrote:
> Nitesh Narayan Lal <nitesh@redhat.com> writes:
>
>> On 4/14/20 11:30 AM, Vitaly Kuznetsov wrote:
>>> Nitesh Narayan Lal <nitesh@redhat.com> writes:
>>>
>>>> On 4/14/20 10:01 AM, Vitaly Kuznetsov wrote:
>>>>> Also, this patch could've been split.
>>>> I can divide it 2 parts:
>>>> 1. support for logical destination mode.
>>>> 2. support for physical destination mode. I can also fix=C2=A0 the a=
bove issue in
>>>> this patch itself.
>>>> Does that make sense?
>>> Too late, it's already commited :-) I just meant to say that
>>> e.g. spinlock part could've been split into its own patch, unittests.=
cfg
>>> - another one,...
>> Ah, I see. I will be more careful.
>> For now,=C2=A0 I will just move the physical destination mode test bac=
k under
>> the check. Will that be acceptable as a standalone patch?
> This is already in Paolo's patch:
> https://lore.kernel.org/kvm/87zhbexh3v.fsf@vitty.brq.redhat.com/T/#m979=
1cd50a9d82fabdaddcb9259d14df3b89ed250

Yeap, this patch is already in the tree.
I was referring to a new patch in which I would move the physical destina=
tion
mode test
under 'if (cpu_count() > 1)', that should fixed the ioapic-split hang.
Sorry about the confusion.

>
>> In between I have a question is it normal for test_ioapic_self_reconfi=
gure()
>> to fail when executed with irqchip split?
>> If so do we expect that it will leave the VM in some sort of dirty sta=
te
>> that causes the following test to fail?
> Not sure I got your question but IMO when someone does
> ./run_tests.sh
> all tests are supposed to pass -- unless there is a bug in KVM (e.g. th=
e
> person is running an old kernel). In case we're seeing failures (or,
> even worse, hangs) with the latest upstream kernel -- something is
> broken, either KVM or kvm-unit-tests.

Yeap, I am not sure what is the exact issue that causes
test_ioapic_self_reconfigure() to
fail when used with kernel_irqchip=3Dsplit.
I can again take a look to find out the root cause later.

--=20
Nitesh

