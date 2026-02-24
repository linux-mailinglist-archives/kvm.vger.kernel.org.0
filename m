Return-Path: <kvm+bounces-71604-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0Ed9Gp92nWmAQAQAu9opvQ
	(envelope-from <kvm+bounces-71604-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 10:59:59 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FEF41850E9
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 10:59:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id B859D300693C
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 09:59:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5843374169;
	Tue, 24 Feb 2026 09:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="nhbSBJ0t"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6261372B5B;
	Tue, 24 Feb 2026 09:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771927175; cv=none; b=pyDTcmftWOqUIoLtdnkgxSPt43VjDs3rYNjHhgxMMwvU2chZMnGACj1UK5oRmkStd2tQ1fUhSmgO5EmdO8NUkrSp2dgoaFhI4wIiLvkMeddrvhpg7xf/HVpfzceHRH+PPBOIbYn5hM7P/gjphOaEQn7C1c9ZDVN0wpa6ohifJWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771927175; c=relaxed/simple;
	bh=O+Zfk8pGYhZ441ezTmlQeAxENiyrxw4mHnh8Grp9ijA=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:To:Subject:From:
	 References:In-Reply-To; b=Ac1reyFCOrtsGpFy+ZuAbtbJ4fTiFHlaGhskzwTzxdOijTMiTI5H+2OXZe5xgyghSe5wVwOSa6scTiCrGJTT3n3hqPnoOFaU1aXkW9Bza4Lcx1vB93RXF183orIZnlhR+AQSugFvUokPvzOFkvfEQL8dtHBEVIUXPcRASvrpA98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=nhbSBJ0t; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61NJ0XIs3294422;
	Tue, 24 Feb 2026 09:59:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=YCCV5l
	xRdf4T7FqyIrwuoRCkVr0xbrZ7pAvhQ4fOuDs=; b=nhbSBJ0tTevdXKZc4KITBv
	5aFtX90AB59l8LvuFdjWLJNEaOHjbiySP76u76cf3O6wfVajpX9GADwKs1Wsive+
	gfxdjnHlGg0xjZ6ZiperdGOrzb0IX9SImwRP6OC1t5KVikFEerFl7+Cut1fMAkMN
	ISdf1nXVdxsXs0ML00Gluews4f/Yt9Ll+PTKJKjF+48S+ZipIkZQcCBIcmc7twP0
	bGsDEYeO2bJfvkR6CNS43N2vzKahS2OCYTyRF346iYkJ2vsG/DGZzl7yWe6yJhDT
	EE8669fjqd6jFWPgkDpVoIIhYhIFquVR9RHQUq9E9mKrkW5RcLC3rtwQZtYJvZjg
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4cf4brtcg8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 24 Feb 2026 09:59:32 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61O8XJVq003382;
	Tue, 24 Feb 2026 09:59:31 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4cfs8jr6nb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 24 Feb 2026 09:59:31 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61O9xRwD39911714
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Feb 2026 09:59:27 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BD2D320043;
	Tue, 24 Feb 2026 09:59:27 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 92D4E20040;
	Tue, 24 Feb 2026 09:59:27 +0000 (GMT)
Received: from darkmoore (unknown [9.87.150.101])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 24 Feb 2026 09:59:27 +0000 (GMT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 24 Feb 2026 10:59:22 +0100
Message-Id: <DGN3R8SWDO7Q.1HPQ9C03X4YUJ@linux.ibm.com>
Cc: "Christian Borntraeger" <borntraeger@linux.ibm.com>,
        "Claudio Imbrenda"
 <imbrenda@linux.ibm.com>,
        "Heiko Carstens" <hca@linux.ibm.com>,
        "Vasily
 Gorbik" <gor@linux.ibm.com>,
        "Alexander Gordeev" <agordeev@linux.ibm.com>,
        "Sven Schnelle" <svens@linux.ibm.com>,
        "Hendrik Brueckner"
 <brueckner@linux.ibm.com>,
        "Nina Schoetterl-Glausch" <nsg@linux.ibm.com>, <kvm@vger.kernel.org>
To: "Janosch Frank" <frankja@linux.ibm.com>,
        "Christoph Schlameuss"
 <schlameuss@linux.ibm.com>,
        <linux-s390@vger.kernel.org>
Subject: Re: [PATCH 4/4] KVM: s390: vsie: Implement ASTFLEIE facility 2
From: "Christoph Schlameuss" <schlameuss@linux.ibm.com>
X-Mailer: aerc 0.21.0
References: <20260212-vsie-alter-stfle-fac-v1-0-d772be74a4da@linux.ibm.com>
 <20260212-vsie-alter-stfle-fac-v1-4-d772be74a4da@linux.ibm.com>
 <ee72e730-87f2-439e-b6a6-2f153ec055af@linux.ibm.com>
In-Reply-To: <ee72e730-87f2-439e-b6a6-2f153ec055af@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: C_rxH_J27SunkGsgJ_5s0tssjLs4zv93
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI0MDA4MSBTYWx0ZWRfX42d0Wq6SvxMr
 UJ0itOLDzTDlhwgKHPYDbUFe4b3ap4QTeIxvwQV9b/7NG+QejWA0NvVv+frCSWMP6tYmYyXt8aq
 H+zPQHeDnWsD6kt9LqWajNsU4j19Y0o0JtkUxXen2usvrbtD1fxuHju+kf/ysXp/6+hQvKCNCCp
 yUylGTUe52YQ5Yb2uDozx/p7Kiqq6/x7AK6SPbxrU+eNF2ff7paG94kiqgsEA6OyqNJh9OmsW0R
 E7rc/Ikk8CikVh0O/S8wVbYfsI1FOJBfxbBsZW43aM7UYkRbs5tW0kkIJYtXJisOXaNvznYQsDE
 pC0QglXJ9sONd9qmEhGymyfV6IrGU7OmR05xmFN4E52BSh77oJVZQQIevR/cxI5gWx9Y/qmQutI
 3lhutFnHXp2b1uWTb8XO5AV3S2k/x+q3GERuS4Hk+uxABRWJqHLYneKTT7NEo0mqhpMhPkKDOHb
 ECgXr+of90QC8eBqZlA==
X-Authority-Analysis: v=2.4 cv=eNceTXp1 c=1 sm=1 tr=0 ts=699d7684 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VnNF1IyMAAAA:8
 a=AQfm25OE03uikATvrrkA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: C_rxH_J27SunkGsgJ_5s0tssjLs4zv93
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-24_01,2026-02-23_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 priorityscore=1501 phishscore=0 suspectscore=0 adultscore=0
 bulkscore=0 lowpriorityscore=0 malwarescore=0 impostorscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602240081
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	MV_CASE(0.50)[];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	TAGGED_FROM(0.00)[bounces-71604-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[ibm.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[schlameuss@linux.ibm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Queue-Id: 8FEF41850E9
X-Rspamd-Action: no action

On Fri Feb 20, 2026 at 11:07 AM CET, Janosch Frank wrote:
> On 2/12/26 10:24, Christoph Schlameuss wrote:
>> From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
>>=20
>> Implement shadowing of format-2 facility list when running in VSIE.
>>=20
>> ASTFLEIE2 is available since IBM z16.
>> To function G1 has to run this KVM code and G1 and G2 have to run QEMU
>> with ASTFLEIE2 support.
>>=20
>> Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
>> Co-developed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
>> Signed-off-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
>> ---
>
> [...]
>
>> +static int handle_stfle_2(struct kvm_vcpu *vcpu, struct vsie_page *vsie=
_page,
>> +			  u32 fac_list_origin)
>> +{
>> +	struct kvm_s390_sie_block *scb_s =3D &vsie_page->scb_s;
>> +	u8 *shadow_fac =3D &vsie_page->fac[0];
>> +	u64 len;
>> +
>> +	if (read_guest_real(vcpu, fac_list_origin, &len, sizeof(len)))
>> +		return set_validity_icpt(scb_s, 0x1090U);
>> +	fac_list_origin +=3D sizeof(len);
>> +	len =3D (len & 0xff);
>> +	memcpy(shadow_fac, &len, sizeof(len)); /* discard reserved bits */
>> +	shadow_fac +=3D sizeof(len);
>
> You can choose between adding a struct for the new format and what you=20
> did here. Is this really the better option?
>
>
> Add the struct and add a constant for the format 2 format control used=20
> in the second to last line of this function while you're at it.
>

Will do.

>> +	len +=3D 1;
>> +	/* assert no overflow with maximum len */
>> +	BUILD_BUG_ON(sizeof(vsie_page->fac) < 257 * sizeof(u64));> +	if (read_=
guest_real(vcpu, fac_list_origin, shadow_fac, len *=20
> sizeof(u64)))
>> +		return set_validity_icpt(scb_s, 0x1090U);
>
> Sprinkle in some \n between the build bugs and code or just move them to=
=20
> the top as one block.
> I'd much rather have build bugs at the top of the function than inside=20
> the code.
>
>> +	BUILD_BUG_ON(!IS_ALIGNED(offsetof(struct vsie_page, fac), 8));
>
> That was already added last patch, no?
>

Yes, it was. Keeping the one in handle_stfle(). We actually can put both ne=
wly
introduced build bug macros there.

>> +	scb_s->fac =3D (u32)virt_to_phys(&vsie_page->fac) | 2;
>> +	return 0;
>> +}
>> +
>>   /*
>>    * Try to shadow + enable the guest 2 provided facility list.
>>    * Retry instruction execution if enabled for and provided by guest 2.
>> @@ -1057,9 +1080,11 @@ static int handle_stfle(struct kvm_vcpu *vcpu, st=
ruct vsie_page *vsie_page)
>>   		case 0:
>>   			return handle_stfle_0(vcpu, vsie_page, fac_list_origin);
>>   		case 1:
>> +			return set_validity_icpt(&vsie_page->scb_s, 0x1330U);
>>   		case 2:
>> +			return handle_stfle_2(vcpu, vsie_page, fac_list_origin);
>>   		case 3:
>> -			unreachable();
>> +			return set_validity_icpt(&vsie_page->scb_s, 0x1330U);
>>   		}
>>   	}
>>   	return 0;
>>=20


