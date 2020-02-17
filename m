Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D9CF1614CD
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2020 15:37:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728841AbgBQOhM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Feb 2020 09:37:12 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:15440 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726781AbgBQOhM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 17 Feb 2020 09:37:12 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01HEYAMP103819
        for <kvm@vger.kernel.org>; Mon, 17 Feb 2020 09:37:11 -0500
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2y6e2e7xwf-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 17 Feb 2020 09:37:11 -0500
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Mon, 17 Feb 2020 14:37:09 -0000
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 17 Feb 2020 14:37:06 -0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01HEb2Tq54919396
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Feb 2020 14:37:02 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 84330AE057;
        Mon, 17 Feb 2020 14:37:02 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 28761AE045;
        Mon, 17 Feb 2020 14:37:02 +0000 (GMT)
Received: from dyn-9-152-224-44.boeblingen.de.ibm.com (unknown [9.152.224.44])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 17 Feb 2020 14:37:02 +0000 (GMT)
Subject: Re: [PATCH v2 19/42] KVM: s390: protvirt: Add new gprs location
 handling
To:     David Hildenbrand <david@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Michael Mueller <mimu@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
References: <20200214222658.12946-1-borntraeger@de.ibm.com>
 <20200214222658.12946-20-borntraeger@de.ibm.com>
 <38b60f61-db18-ee7a-6b8e-192a7bb9d259@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Date:   Mon, 17 Feb 2020 15:37:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <38b60f61-db18-ee7a-6b8e-192a7bb9d259@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="15epwzkLUo7Bcf3A4CIC1Q3fDF0gFmu1D"
X-TM-AS-GCONF: 00
x-cbid: 20021714-0020-0000-0000-000003AAF59E
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20021714-0021-0000-0000-00002202ED08
Message-Id: <760a6ec5-d511-a2a8-815f-1cfc02049f40@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-17_08:2020-02-17,2020-02-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 mlxlogscore=999 mlxscore=0 suspectscore=3 clxscore=1015 lowpriorityscore=0
 impostorscore=0 phishscore=0 bulkscore=0 adultscore=0 priorityscore=1501
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002170121
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--15epwzkLUo7Bcf3A4CIC1Q3fDF0gFmu1D
Content-Type: multipart/mixed; boundary="4m7YKRRG5SpGtrVj472zUnFa1T4cWa8iX"

--4m7YKRRG5SpGtrVj472zUnFa1T4cWa8iX
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 2/17/20 12:01 PM, David Hildenbrand wrote:
> On 14.02.20 23:26, Christian Borntraeger wrote:
>> From: Janosch Frank <frankja@linux.ibm.com>
>>
>> Guest registers for protected guests are stored at offset 0x380.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> Reviewed-by: Thomas Huth <thuth@redhat.com>
>> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
>> [borntraeger@de.ibm.com: patch merging, splitting, fixing]
>> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
>> ---
>>  arch/s390/include/asm/kvm_host.h |  4 +++-
>>  arch/s390/kvm/kvm-s390.c         | 11 +++++++++++
>>  2 files changed, 14 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/=
kvm_host.h
>> index ba3364b37159..4fcbb055a565 100644
>> --- a/arch/s390/include/asm/kvm_host.h
>> +++ b/arch/s390/include/asm/kvm_host.h
>> @@ -343,7 +343,9 @@ struct kvm_s390_itdb {
>>  struct sie_page {
>>  	struct kvm_s390_sie_block sie_block;
>>  	struct mcck_volatile_info mcck_info;	/* 0x0200 */
>> -	__u8 reserved218[1000];		/* 0x0218 */
>> +	__u8 reserved218[360];		/* 0x0218 */
>> +	__u64 pv_grregs[16];		/* 0x0380 */
>> +	__u8 reserved400[512];		/* 0x0400 */
>>  	struct kvm_s390_itdb itdb;	/* 0x0600 */
>>  	__u8 reserved700[2304];		/* 0x0700 */
>>  };
>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>> index a85e50075d99..6ebb0dae5a2e 100644
>> --- a/arch/s390/kvm/kvm-s390.c
>> +++ b/arch/s390/kvm/kvm-s390.c
>> @@ -3999,6 +3999,7 @@ static int vcpu_post_run(struct kvm_vcpu *vcpu, =
int exit_reason)
>>  static int __vcpu_run(struct kvm_vcpu *vcpu)
>>  {
>>  	int rc, exit_reason;
>> +	struct sie_page *sie_page =3D (struct sie_page *)vcpu->arch.sie_bloc=
k;
>> =20
>>  	/*
>>  	 * We try to hold kvm->srcu during most of vcpu_run (except when run=
-
>> @@ -4020,8 +4021,18 @@ static int __vcpu_run(struct kvm_vcpu *vcpu)
>>  		guest_enter_irqoff();
>>  		__disable_cpu_timer_accounting(vcpu);
>>  		local_irq_enable();
>> +		if (kvm_s390_pv_is_protected(vcpu->kvm)) {
>> +			memcpy(sie_page->pv_grregs,
>> +			       vcpu->run->s.regs.gprs,
>> +			       sizeof(sie_page->pv_grregs));
>> +		}
>>  		exit_reason =3D sie64a(vcpu->arch.sie_block,
>>  				     vcpu->run->s.regs.gprs);
>> +		if (kvm_s390_pv_is_protected(vcpu->kvm)) {
>> +			memcpy(vcpu->run->s.regs.gprs,
>> +			       sie_page->pv_grregs,
>> +			       sizeof(sie_page->pv_grregs));
>> +		}
>>  		local_irq_disable();
>>  		__enable_cpu_timer_accounting(vcpu);
>>  		guest_exit_irqoff();
>>
>=20
> As discussed, I think there is room for improvement in the future (whic=
h
> we could have documented in the patch description), because this is
> obviously sub-optimal.

I added it to my KVM TODO list.

>=20
> Reviewed-by: David Hildenbrand <david@redhat.com>

Thanks for reviewing this patch and all the others :-)



--4m7YKRRG5SpGtrVj472zUnFa1T4cWa8iX--

--15epwzkLUo7Bcf3A4CIC1Q3fDF0gFmu1D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl5KpQ0ACgkQ41TmuOI4
ufhujw/9FAZckI4DRKLJlKaQ/lIvvHWsDvqR64Uq0H+XiMovsFaK/TQlrg9sNjt+
gTJvmtk9eqKUnCepyyF09PWBOfdcHku9aOvzY2Fe/y9JJ83lBWMlB0VFvYlxhYT1
OaN/7baX2vF7G6VRm041Lmo9+kbTqN7gpnQGtBDhmyOcYhCwqlWj9E9MHIOge8Cm
SwDevAOS4HkrFi2U0G2HvkqKxztC6myvfQu31CCb9jpw1aq2Ue3ZgyFHqVUfXL96
YkH0W8zDeybv0JnrQPsJLCcEUayRsJQAdZOEykYdKQxmEAhjWS1Y93xTGGKxwonU
w+wfa5+KxU6Md71z3IcDexRIV6COV+bcuH+JvrRJ0nvAxh4q2mzExBO5ZGQuncud
pihVZgHPA77lpu5+T9u42F219frQ6/BBVgD3qFAQZYNl2zICJHeeIIZZZAqyPQYR
2aZWELQqH1fh0igEBO/yHVS/f3ah8XiouaLAJAH9HMyVQqanER8KA4IjiXwcGg4+
eRopeZp2cfFsYcCoMdHVSLp7IxLg75o1PmQ8qTeYwRR7njffgUCpM6xivQXzhMhY
nUCvW3st8L5ulUGRR9SN/gFAlFGPg7Tn96sE1MzQXkHKo69NVsLVnYyDHhB+muC5
ItYVpIhSm96q+uTtUHrcfyxsM7EvhEHyNQ0kfkk3p/xOnguFSZY=
=dP/w
-----END PGP SIGNATURE-----

--15epwzkLUo7Bcf3A4CIC1Q3fDF0gFmu1D--

