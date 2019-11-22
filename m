Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22F7910725B
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2019 13:45:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727207AbfKVMpp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Nov 2019 07:45:45 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:40409 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726045AbfKVMpp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 22 Nov 2019 07:45:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574426743;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
        in-reply-to:in-reply-to:references:references:openpgp:openpgp:autocrypt:autocrypt;
        bh=YF9Zvvf7afB5jvqJz9at4BRes/f8Yjb4vqZajQ8UqbM=;
        b=CpopRb6JLS+2T6iqDNexj0R54hJU+RS3KH+7oIUthSg3ayzpwysf52UQJ4i+c1hPImPRoh
        PFliLvvrDtPbsXIw4dj/maAMP/0nxUVkdunQmsGD/8yIy0I8trmNroNy5A0znRy1NTme/Z
        BvdWCXIssDZUk6+wkQUOOqJwB2kWn+E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-180-z3-40yDKPVmQpWq5EEi0Ow-1; Fri, 22 Nov 2019 07:45:40 -0500
X-MC-Unique: z3-40yDKPVmQpWq5EEi0Ow-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C55A418B5FA2;
        Fri, 22 Nov 2019 12:45:37 +0000 (UTC)
Received: from [10.10.121.119] (ovpn-121-119.rdu2.redhat.com [10.10.121.119])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8601767E61;
        Fri, 22 Nov 2019 12:45:28 +0000 (UTC)
Subject: Re: [PATCH -next] KVM: x86: remove set but not used variable 'called'
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Mao Wenan <maowenan@huawei.com>, pbonzini@redhat.com,
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
 <b24e2efc-2228-95ea-09b0-806a9b066eee@redhat.com>
 <20191122120413.GI617@kadam>
From:   Nitesh Narayan Lal <nitesh@redhat.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nitesh@redhat.com; prefer-encrypt=mutual; keydata=
 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
 VujM7c/b4pps
Organization: Red Hat Inc,
Message-ID: <ed1d438b-9f0f-0e33-51cc-12ad316aa18c@redhat.com>
Date:   Fri, 22 Nov 2019 07:45:25 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191122120413.GI617@kadam>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Mimecast-Spam-Score: 0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="7eebgi68NEWUnr0qnwcAQKeBn2ZnM0aEi"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--7eebgi68NEWUnr0qnwcAQKeBn2ZnM0aEi
Content-Type: multipart/mixed; boundary="8cMCPFfHHLuxBfx8pFoGN3HdS0JmIADqe";
 protected-headers="v1"
From: Nitesh Narayan Lal <nitesh@redhat.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>, Mao Wenan <maowenan@huawei.com>,
 pbonzini@redhat.com, rkrcmar@redhat.com, sean.j.christopherson@intel.com,
 wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
 tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 kernel-janitors@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>
Message-ID: <ed1d438b-9f0f-0e33-51cc-12ad316aa18c@redhat.com>
Subject: Re: [PATCH -next] KVM: x86: remove set but not used variable 'called'
References: <20191119030640.25097-1-maowenan@huawei.com>
 <87o8x8gjr5.fsf@vitty.brq.redhat.com> <20191119121423.GB5604@kadam>
 <87imnggidr.fsf@vitty.brq.redhat.com> <20191119123956.GC5604@kadam>
 <87a78sgfqj.fsf@vitty.brq.redhat.com>
 <b24e2efc-2228-95ea-09b0-806a9b066eee@redhat.com>
 <20191122120413.GI617@kadam>
In-Reply-To: <20191122120413.GI617@kadam>

--8cMCPFfHHLuxBfx8pFoGN3HdS0JmIADqe
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US


On 11/22/19 7:25 AM, Dan Carpenter wrote:
> On Fri, Nov 22, 2019 at 06:58:51AM -0500, Nitesh Narayan Lal wrote:
>> For the build error, I didn't trigger it because I didn't compile with
>> appropriate flags.
> It's going to be a serveral years before we can enable that flag by
> default.

I see I have made a note of it so that I can do it before sending the patch=
es.

> regards,
> dan carpenter
>
--=20
Thanks
Nitesh


--8cMCPFfHHLuxBfx8pFoGN3HdS0JmIADqe--

--7eebgi68NEWUnr0qnwcAQKeBn2ZnM0aEi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkXcoRVGaqvbHPuAGo4ZA3AYyozkFAl3X2GUACgkQo4ZA3AYy
ozncxA/+NydE9O11tyCKGrzbLSzgDycPi8wO51qYta8Uykb6NyYefSAPZluM2WwR
Png3Oi5vUKibO90UF1F20baW7MWv/RJ4KH6COOKxVJX/CSSjBlm6OtQ+KfKTwkYS
hzfXtQwXKW5zYO+AEgHyjLM4u2sDJ7W88prpA0CLraVQq3ZjRhCSru0QG3NmB2Oj
baYlDmeuxe32hLYk7gSkLzZrs9i228bNS1jg61NOLER215HOBI/XMKBZ/0fUm2Nl
R5BZ3JlbsAgooForjpJDu4L6l7mZ+CiWLTVdDNrNN4X4vsZM/rva6vUDboRNDOjs
sj4kuV0RVPkNk2HTxSKHMhYa7mCC5MUOv8cEcsP+USRMRZlBMBp8ulPg89dOv9Dr
NpM+mflmWGIVwPGmLdk3N6Z9O090vkqN1ZUlqCXrXzClYp+vxpzf7O4aRGD/q3GK
9PSD8yxjQ3MU0eCalnCupMcxku10fi+R6nODaNf8A53fTI/CltENm7svS0X2euJ1
y0HaadrHqCwANGZtooMM4I40x3FNpRX3dXMFn2nfV5EXZQFJOVQKEXYGNgFGkV4/
z70xFMni/i+lxlaIvtxWi9qV8KrChJigYwuK/0/jbb7M6VxgvVOe+wAO5+CxZ1xc
dxXmEs253S8MzOc8Arsq/IQFX2s4DNqatixDJacZY6m27W4K424=
=MiRZ
-----END PGP SIGNATURE-----

--7eebgi68NEWUnr0qnwcAQKeBn2ZnM0aEi--

