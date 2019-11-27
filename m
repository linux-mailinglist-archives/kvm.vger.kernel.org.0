Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4156510B5A6
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2019 19:24:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727213AbfK0SYt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Nov 2019 13:24:49 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:55194 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727071AbfK0SYt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 27 Nov 2019 13:24:49 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xARIMWwj119128;
        Wed, 27 Nov 2019 13:24:44 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2whcxqw2k4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Nov 2019 13:24:44 -0500
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id xARINNYl004667;
        Wed, 27 Nov 2019 13:24:43 -0500
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2whcxqw2jr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Nov 2019 13:24:43 -0500
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id xARIKpKO006396;
        Wed, 27 Nov 2019 18:24:42 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma03wdc.us.ibm.com with ESMTP id 2wevd6q4bu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Nov 2019 18:24:42 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xARIOfG655378400
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Nov 2019 18:24:41 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7E36FBE053;
        Wed, 27 Nov 2019 18:24:41 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1F599BE04F;
        Wed, 27 Nov 2019 18:24:40 +0000 (GMT)
Received: from leobras.br.ibm.com (unknown [9.18.235.137])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed, 27 Nov 2019 18:24:39 +0000 (GMT)
Message-ID: <bfa563e6a584bd85d3abe953ca088281dc0e167b.camel@linux.ibm.com>
Subject: Re: [PATCH] KVM: Add separate helper for putting borrowed reference
 to kvm
From:   Leonardo Bras <leonardo@linux.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paul Mackerras <paulus@ozlabs.org>,
        Radim =?UTF-8?Q?Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        kvm-ppc@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Wed, 27 Nov 2019 15:24:35 -0300
In-Reply-To: <e1a4218f-2a70-3de3-1403-dbebf8a8abdf@redhat.com>
References: <20191021225842.23941-1-sean.j.christopherson@intel.com>
         <de313d549a5ae773aad6bbf04c20b395bea7811f.camel@linux.ibm.com>
         <20191126171416.GA22233@linux.intel.com>
         <0009c6c1bb635098fa68cb6db6414634555039fe.camel@linux.ibm.com>
         <e1a4218f-2a70-3de3-1403-dbebf8a8abdf@redhat.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-othlKLjwGq4RsDZV0+9/"
User-Agent: Evolution 3.34.1 (3.34.1-1.fc31) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-27_04:2019-11-27,2019-11-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 suspectscore=0 spamscore=0 phishscore=0 mlxlogscore=999 bulkscore=0
 priorityscore=1501 impostorscore=0 malwarescore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911270150
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--=-othlKLjwGq4RsDZV0+9/
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2019-11-27 at 17:38 +0100, Paolo Bonzini wrote:
> On 26/11/19 18:53, Leonardo Bras wrote:
> > I agree an use-after-free more problem than a memory leak, but I
> > think
> > that there is a way to solve this without leaking the memory also.
> >=20
> > One option would be reordering the kvm_put_kvm(), like in this
> > patch:
> > https://lkml.org/lkml/2019/11/26/517
>=20
> It's a tradeoff between "fix one bug" and "mitigate all bugs of that
> class", both are good things to do.  Reordering the kvm_put_kvm()
> fixes
> the bug.  kvm_put_kvm_no_destroy() makes all bugs of that kind less
> severe, but it doesn't try to fix them.
>=20
> Paolo
>=20

I think I understand it better now, thanks Paolo and Sean.

By what I could undestand up to now, these functions that use borrowed
references can only be called while the reference (file descriptor)
exists.=20
So, suppose these threads, where:
- T1 uses a borrowed reference, and=20
- T2 is releasing the reference (close, release):

T1				| T2
kvm_get_kvm()			|
...				| kvm_put_kvm()
kvm_put_kvm_no_destroy()	|

The above would not trigger a use-after-free bug, but will cause a
memory leak.
Is my above understanding right?

Best regards,

Leonardo


--=-othlKLjwGq4RsDZV0+9/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEMdeUgIzgjf6YmUyOlQYWtz9SttQFAl3ev2QACgkQlQYWtz9S
ttTMfg//TLejnZkRJWcvpxfD9LlYvQaISoSSxkfYCFdvp6vdKss6nm+iThpmNzg/
Jf9eA2A8dnRLdV65V4ZRS7i1CYNEB3CWvqn26HLxD9SOzKgtEBz0q40CTWcGOoHc
GwX9pR7vbN1ZsckdbiX1mu45255eg1xh9yAxegYWOPUU1vccvMAgspXq5pkeHEQP
HE+8N4Cjf/dGt8WUuTe2BcpV5tBNy2cPZ0/clel/VYlfOUsH9RHQ6JSxmCNiF8tT
zs8AnzPIYUWqwo0FX9+KeQIbd9YKxNy6DaUawwNYuDV299kkS65smMc1h9jHHPh7
P4EgqLzDVQ0exNkM/SVOVWInxSpJBm1Q50oJoZO70XvbuBzWPpX6MLhxwwxZWSCR
00XCXs2qsBkBAT0BrD8ZForwNnvHrEhRnk2Zp1jp/0w0Mze/UMZH7UU9le461GZT
N3bDUwuoTlqkiDWB2jdMWu752n4GbCN2fx1CZBNFSWOKrMrgSVbLnnYadwinJY4O
FJG8O40/ZfPkdAy8iqVF9QCwX/3Ft5uXwDO8I6C+wBeWGBOxhejE2MsKlVrUGKyH
m21C9LfeQC7zmowL7E0tSbmyYfR0U1hXTLQ+moG6YFayLq5G9NQ8WQTkTPfn8E8g
w+5mkCrVDX1/s81LqLxH9MoB9fi+CYWdtJV1HuB9hNSiPlznQzg=
=1KbN
-----END PGP SIGNATURE-----

--=-othlKLjwGq4RsDZV0+9/--

