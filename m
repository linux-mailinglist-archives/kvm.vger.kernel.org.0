Return-Path: <kvm+bounces-526-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 18D5F7E0885
	for <lists+kvm@lfdr.de>; Fri,  3 Nov 2023 19:54:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 484061C210CD
	for <lists+kvm@lfdr.de>; Fri,  3 Nov 2023 18:54:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFF671BDD9;
	Fri,  3 Nov 2023 18:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="o/C5hcPg"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EC451548F
	for <kvm@vger.kernel.org>; Fri,  3 Nov 2023 18:53:56 +0000 (UTC)
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D048BD;
	Fri,  3 Nov 2023 11:53:55 -0700 (PDT)
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A3IJrGl025758;
	Fri, 3 Nov 2023 18:53:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=aX1ZdNjYKDkIA6z+Y41dUOjCE75DizEEdXwX5jTL2Bk=;
 b=o/C5hcPg4iwuIhp/1s99xQ4HHjKlN/IWr39hpdkzISL5ZfhVoLu8EfD/cEEWGJIkCogn
 0Uhe9LuyZ8zOxzBZvJCDzQfyBuFY1EJyd7/5QGYgEQ/FELvqr8kgd33fM1k8g0qskVPe
 KO3NAbCjdtjI4UC2UvYZGTZ+3Eq5gg2/CA0lWUXav8FXz8oxK/iBP57gVDtNwcyGviMV
 luYEqvQ54tVpeRIl5PBLjyf9OkLfFe0cDjko/VDmmpZSXBwTjDBFVTniATsI/VmcXhfl
 Z2keffnBowVsjh92EF02U1gAmuhS+vaG6sLFFNDFiL4OMf+ToP5hqTT/001K/CoWaUHy RA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u561x8wks-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 03 Nov 2023 18:53:53 +0000
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3A3ILmH4031319;
	Fri, 3 Nov 2023 18:53:52 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u561x8wdr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 03 Nov 2023 18:53:52 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3A3GZYex000597;
	Fri, 3 Nov 2023 18:53:27 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3u1cmtr95t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 03 Nov 2023 18:53:27 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3A3IrLEI10748464
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 3 Nov 2023 18:53:21 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5289420040;
	Fri,  3 Nov 2023 18:53:21 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 025D620043;
	Fri,  3 Nov 2023 18:53:21 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri,  3 Nov 2023 18:53:20 +0000 (GMT)
Date: Fri, 3 Nov 2023 19:12:04 +0100
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger
 <borntraeger@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        David
 Hildenbrand <dahi@linux.vnet.ibm.com>,
        Janosch Frank
 <frankja@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>, kvm@vger.kernel.org,
        Michael Mueller <mimu@linux.vnet.ibm.com>, linux-s390@vger.kernel.org,
        Cornelia Huck <cornelia.huck@de.ibm.com>,
        Sven
 Schnelle <svens@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] KVM: s390: vsie: Fix STFLE interpretive execution
 identification
Message-ID: <20231103191204.47a90d49@p-imbrenda>
In-Reply-To: <20231103173008.630217-2-nsg@linux.ibm.com>
References: <20231103173008.630217-1-nsg@linux.ibm.com>
	<20231103173008.630217-2-nsg@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: rva-logwUAu3Pp6wSgdEVHrGjSsS7XMY
X-Proofpoint-GUID: AlekBG3XKEz1fthEpn1Cn0aK3OZVElX0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-03_18,2023-11-02_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 priorityscore=1501 bulkscore=0 impostorscore=0 malwarescore=0
 clxscore=1015 mlxscore=0 suspectscore=0 phishscore=0 spamscore=0
 adultscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2310240000 definitions=main-2311030159

On Fri,  3 Nov 2023 18:30:05 +0100
Nina Schoetterl-Glausch <nsg@linux.ibm.com> wrote:

> STFLE can be interpretively executed.
> This occurs when the facility list designation is unequal to zero.
> Perform the check before applying the address mask instead of after.
> 
> Fixes: 66b630d5b7f2 ("KVM: s390: vsie: support STFLE interpretation")
> Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  arch/s390/kvm/vsie.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
> index 61499293c2ac..d989772fe211 100644
> --- a/arch/s390/kvm/vsie.c
> +++ b/arch/s390/kvm/vsie.c
> @@ -988,9 +988,10 @@ static void retry_vsie_icpt(struct vsie_page *vsie_page)
>  static int handle_stfle(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
>  {
>  	struct kvm_s390_sie_block *scb_s = &vsie_page->scb_s;
> -	__u32 fac = READ_ONCE(vsie_page->scb_o->fac) & 0x7ffffff8U;
> +	__u32 fac = READ_ONCE(vsie_page->scb_o->fac);
>  
>  	if (fac && test_kvm_facility(vcpu->kvm, 7)) {
> +		fac = fac & 0x7ffffff8U;
>  		retry_vsie_icpt(vsie_page);
>  		if (read_guest_real(vcpu, fac, &vsie_page->fac,
>  				    sizeof(vsie_page->fac)))


