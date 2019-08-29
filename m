Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2BD8A196B
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2019 13:56:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727139AbfH2L4d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Aug 2019 07:56:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53654 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727017AbfH2L4d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Aug 2019 07:56:33 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6B2F43086202;
        Thu, 29 Aug 2019 11:56:32 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-116-53.ams2.redhat.com [10.36.116.53])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CBA10608C1;
        Thu, 29 Aug 2019 11:56:25 +0000 (UTC)
Subject: Re: [PATCH] KVM: s390: Test for bad access register at the start of
 S390_MEM_OP
To:     Janosch Frank <frankja@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        kvm@vger.kernel.org
Cc:     David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20190829105356.27805-1-thuth@redhat.com>
 <870234c7-47ed-6a96-0edf-66d9c2cd7ac0@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Autocrypt: addr=thuth@redhat.com; prefer-encrypt=mutual; keydata=
 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
Organization: Red Hat
Message-ID: <4b0ebaab-e287-9a2a-1696-5759f17cafef@redhat.com>
Date:   Thu, 29 Aug 2019 13:56:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <870234c7-47ed-6a96-0edf-66d9c2cd7ac0@linux.ibm.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Trx6kqpy5WJ0k5aw1kWN52k1y2o1CINuq"
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Thu, 29 Aug 2019 11:56:32 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Trx6kqpy5WJ0k5aw1kWN52k1y2o1CINuq
Content-Type: multipart/mixed; boundary="QKFIlaPPmFxfhOjxUnC9rG6sazMpabRY6";
 protected-headers="v1"
From: Thomas Huth <thuth@redhat.com>
To: Janosch Frank <frankja@linux.ibm.com>,
 Christian Borntraeger <borntraeger@de.ibm.com>, kvm@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>, Cornelia Huck <cohuck@redhat.com>,
 Heiko Carstens <heiko.carstens@de.ibm.com>, Vasily Gorbik
 <gor@linux.ibm.com>, linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <4b0ebaab-e287-9a2a-1696-5759f17cafef@redhat.com>
Subject: Re: [PATCH] KVM: s390: Test for bad access register at the start of
 S390_MEM_OP
References: <20190829105356.27805-1-thuth@redhat.com>
 <870234c7-47ed-6a96-0edf-66d9c2cd7ac0@linux.ibm.com>
In-Reply-To: <870234c7-47ed-6a96-0edf-66d9c2cd7ac0@linux.ibm.com>

--QKFIlaPPmFxfhOjxUnC9rG6sazMpabRY6
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 29/08/2019 13.15, Janosch Frank wrote:
[...]
> By the way, I think we want to check mop->size for 0 before giving it t=
o
> vmalloc and working with it.

You're right! This currently triggers a kernel warning message with a
Call Trace! I'll add a check to my new memop selftest and send a patch...=


 Thomas


--QKFIlaPPmFxfhOjxUnC9rG6sazMpabRY6--

--Trx6kqpy5WJ0k5aw1kWN52k1y2o1CINuq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEJ7iIR+7gJQEY8+q5LtnXdP5wLbUFAl1nvV8ACgkQLtnXdP5w
LbUOSg/9HVqCYFJXy4Qnu370GW8nAlLmLQeoYNC/MNrIVyG98zDa5IercTJLsmzC
qoLqi7rzgjIqaAdyfd/xKKeCfOceURDZw8Xcbz4Zjw62zsMRPzO4DQYhpR7Mh1o9
XqXMQxjBIJrVPdAKmFOg48r5HfcjNsVkHzoVh4u3nbi64l/UrseF3iQXEBECnBTN
XjUZxW9fd0kAttNtGy7I6Bkur88UQuHls+dmDsg4ugLlxLaNgsKMAX8XheQ3Yk2I
F6ktUuvJtCHYgGGAS/iu8Umlx2t+/huWRiEKIlp/Ft96Nnh+IqEl2Ny8El4nqNCZ
S4qGl6kNrUN1jhQMOVjOTLQSn4TZyJR5uMaJ4kknrPDeaRdNtrpz3e0YAgc0FufW
LlJzUx6RWQiyfXJYAWqQG+Kdj3JJ7v6nJePzZAHfFdDwY8nd369W32zXJGvmoL2J
3ieAUvxTTVjVKZzles17W8W/4jpvHj0QiaIx5RMRuLJXAmx4seGdB42vIHpviPbv
QJLz9DDI9Aof1zUlXF01fSOIInXXj+KTeIMhjYKrfwVyDXvByG22kpgrrlEAWRQD
cq0j7v2wAHJZ2vGHyTxpJLHruIjE5yGthAm8Nnfutey3Re70YKQ+VcdF0aYo3nMB
kj5BsuXk0lm9A9C+craKbmnnhog3j4lHhnsVac3fsSdupm1TQlg=
=GNZu
-----END PGP SIGNATURE-----

--Trx6kqpy5WJ0k5aw1kWN52k1y2o1CINuq--
