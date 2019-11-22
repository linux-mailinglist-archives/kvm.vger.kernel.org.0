Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A02F1071D6
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2019 12:59:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727493AbfKVL7I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Nov 2019 06:59:08 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:26191 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726792AbfKVL7I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Nov 2019 06:59:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574423946;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
        in-reply-to:in-reply-to:references:references:openpgp:openpgp:autocrypt:autocrypt;
        bh=4sSzCuZV5gnoQVUsMLu8zWXNKpS+Pn4eyvhSt6izHx8=;
        b=Ikj3/RUXnBaiPZZ5438Ke3eVaPzLND1m+uPi8xTj1UdwWmBD10Wa1OR8p7kWUnVnMU12Z6
        oV7XWzQ+HmUpNlR4M85obuMis/1V8BvqPiCWF5O8L9sbGOqDGvechJQ9lxtJLKBX02sp4D
        YfFANWhpya+0xuPZHuUHEgZ07qFN3iQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-328-NJge3SxRM5G47xabPplWPA-1; Fri, 22 Nov 2019 06:59:05 -0500
X-MC-Unique: NJge3SxRM5G47xabPplWPA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 665DC184CAA0;
        Fri, 22 Nov 2019 11:59:03 +0000 (UTC)
Received: from [10.10.121.119] (ovpn-121-119.rdu2.redhat.com [10.10.121.119])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 976D860BCC;
        Fri, 22 Nov 2019 11:58:55 +0000 (UTC)
Subject: Re: [PATCH -next] KVM: x86: remove set but not used variable 'called'
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Mao Wenan <maowenan@huawei.com>, pbonzini@redhat.com,
        rkrcmar@redhat.com, sean.j.christopherson@intel.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>
References: <20191119030640.25097-1-maowenan@huawei.com>
 <87o8x8gjr5.fsf@vitty.brq.redhat.com> <20191119121423.GB5604@kadam>
 <87imnggidr.fsf@vitty.brq.redhat.com> <20191119123956.GC5604@kadam>
 <87a78sgfqj.fsf@vitty.brq.redhat.com>
From:   Nitesh Narayan Lal <nitesh@redhat.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nitesh@redhat.com; prefer-encrypt=mutual; keydata=
 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
 VujM7c/b4pps
Organization: Red Hat Inc,
Message-ID: <b24e2efc-2228-95ea-09b0-806a9b066eee@redhat.com>
Date:   Fri, 22 Nov 2019 06:58:51 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <87a78sgfqj.fsf@vitty.brq.redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Mimecast-Spam-Score: 0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="EqvGeaEVLHBRAwBF8Qf28rvqlOMa5LsGj"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--EqvGeaEVLHBRAwBF8Qf28rvqlOMa5LsGj
Content-Type: multipart/mixed; boundary="4kUcYUHF2NIDUEJAQFa8Nid8qDSi46TpB";
 protected-headers="v1"
From: Nitesh Narayan Lal <nitesh@redhat.com>
To: Vitaly Kuznetsov <vkuznets@redhat.com>,
 Dan Carpenter <dan.carpenter@oracle.com>
Cc: Mao Wenan <maowenan@huawei.com>, pbonzini@redhat.com, rkrcmar@redhat.com,
 sean.j.christopherson@intel.com, wanpengli@tencent.com, jmattson@google.com,
 joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 hpa@zytor.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 kernel-janitors@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>
Message-ID: <b24e2efc-2228-95ea-09b0-806a9b066eee@redhat.com>
Subject: Re: [PATCH -next] KVM: x86: remove set but not used variable 'called'
References: <20191119030640.25097-1-maowenan@huawei.com>
 <87o8x8gjr5.fsf@vitty.brq.redhat.com> <20191119121423.GB5604@kadam>
 <87imnggidr.fsf@vitty.brq.redhat.com> <20191119123956.GC5604@kadam>
 <87a78sgfqj.fsf@vitty.brq.redhat.com>
In-Reply-To: <87a78sgfqj.fsf@vitty.brq.redhat.com>

--4kUcYUHF2NIDUEJAQFa8Nid8qDSi46TpB
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US


On 11/19/19 8:25 AM, Vitaly Kuznetsov wrote:
> Dan Carpenter <dan.carpenter@oracle.com> writes:
>
>> On Tue, Nov 19, 2019 at 01:28:32PM +0100, Vitaly Kuznetsov wrote:
>>> Dan Carpenter <dan.carpenter@oracle.com> writes:
>>>
>>>> On Tue, Nov 19, 2019 at 12:58:54PM +0100, Vitaly Kuznetsov wrote:
>>>>> Mao Wenan <maowenan@huawei.com> writes:
>>>>>
>>>>>> Fixes gcc '-Wunused-but-set-variable' warning:
>>>>>>
>>>>>> arch/x86/kvm/x86.c: In function kvm_make_scan_ioapic_request_mask:
>>>>>> arch/x86/kvm/x86.c:7911:7: warning: variable called set but not
>>>>>> used [-Wunused-but-set-variable]
>>>>>>
>>>>>> It is not used since commit 7ee30bc132c6 ("KVM: x86: deliver KVM
>>>>>> IOAPIC scan request to target vCPUs")
>>>>> Better expressed as=20
>>>>>
>>>>> Fixes: 7ee30bc132c6 ("KVM: x86: deliver KVM IOAPIC scan request to ta=
rget vCPUs")
>>>>>
>>>> There is sort of a debate about this whether the Fixes tag should be
>>>> used if it's only a cleanup.
>>>>
>>> I have to admit I'm involved in doing backporting sometimes and I reall=
y
>>> appreciate Fixes: tags. Just so you know on which side of the debate I
>>> am :-)
>> But we're not going to backport this hopefully?
>>
> In case we're speaking about stable@ kernels, 7ee30bc132c6 doesn't look
> like a good candidate (to me) but who knows, it may get pulled in
> because of some code dependency or some other 'autosel magic'. And
> that's when 'Fixes:' tags become handy.

Anything I can improve upon? If required I can send fixes on top of it.
For the build error, I didn't trigger it because I didn't compile with
appropriate flags.
I will make a note for myself for next time.

Thanks, Mao for sending the fix.

>
--=20
Nitesh


--4kUcYUHF2NIDUEJAQFa8Nid8qDSi46TpB--

--EqvGeaEVLHBRAwBF8Qf28rvqlOMa5LsGj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkXcoRVGaqvbHPuAGo4ZA3AYyozkFAl3XzXsACgkQo4ZA3AYy
ozmPXhAAzY8NtCTe7lRLjXFQ+Tjb5zUYNExVBBC8gNOjDyPNf8CQ57SEFdJm4oUb
nxTlflLIz380o8Wj/n5+nsQZRYf8HtPP8qb07JuNBgtLnsJVtZGV7TrYSVp6gtCz
w/R2QnO9h3zpqrCiKFTJQ0vGSftg/RzDwGCZQz5jiR+0U0RDjrrAmaGerQb4RM/w
nxBzubz3kUhNkvHb4keyc/Fmlezwd7oQ96Wugn2lxksoKvacGrHn9oRdvIOP10N4
L/9TIlmrrwtsNfsMt/N9O+2aorjRv75w/RFxzKf6UlETmBOSwDjS0n6GgrLSWqg+
GRXgzjeAHaaGKXsXKj/L+5BRMPdab9YDD8/CdDD3rqBs75Xp6MPm7U5+aA1ata+2
VOL2hIuAqmd8XmKJa9K+7Xyu0SUz/49j9lQrUbV19bI2iHsAcF41t4RL5xOunmOn
zR3hNa0IPpHLZYrJ0hjAJffSQsbllIfUhc0st3gnDBn45alq93AeKOExBw5qNj2l
JbkEP2Al1i1tGEgTKwxvB/gNN8hZel5mK7PlH50rxjrSlCMuuqBK8t5XkyjIe8SL
Dj3fuvM29VOo3ti7Jr0ZCA6Qr3tGWiz/h5gvnnt9DzftLJLNA5cnO9qFXZq0uzFQ
DCsDqhQ6fYj38MqKttF+qu1T7cfjZ4MYKC3dUpnwBBXTehpXMlU=
=euBu
-----END PGP SIGNATURE-----

--EqvGeaEVLHBRAwBF8Qf28rvqlOMa5LsGj--

