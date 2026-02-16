Return-Path: <kvm+bounces-71135-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id RfsSFu50k2kl5gEAu9opvQ
	(envelope-from <kvm+bounces-71135-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 16 Feb 2026 20:50:06 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A8FB6147577
	for <lists+kvm@lfdr.de>; Mon, 16 Feb 2026 20:50:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 01788302BBA2
	for <lists+kvm@lfdr.de>; Mon, 16 Feb 2026 19:50:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7562E2E8B67;
	Mon, 16 Feb 2026 19:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="B5ccpVsM"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A41A2D0C84
	for <kvm@vger.kernel.org>; Mon, 16 Feb 2026 19:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771271398; cv=none; b=mf+xFWyVN/BFgq/T6ZkPsJfvYeIjMyx49TOmcnoLr+QxR83+j2fILDtk7w8AY+LagBkO/+vp5AxHTxN3qw/U/MxfuLixfrqZ180MKqkTwCm3/NOkNm34gKdcQ9cu0k7dsBRyLw7dacAtzplB9yUFQ0wgB3EuMd7lnjWHPzML2Ak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771271398; c=relaxed/simple;
	bh=B3KGhEXxyjZUHppdZUfv/a3t3Q9jfcTi7fxRVxQb2FI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tm6GCsUWLZNn+nEgLsG3ysOi9xthWY3dOiYu1OARKvGo0xw8yciK9WjXGjd2pPhnZzi3zgmpbqMTFsX+DJJdDg775lB+6LFXMJxOeNnLXRdmdvgyT+VZCg0VQkFGZu2mMZgBMyQn9gA3BKcfaukr1PXQ0bmVC6E4F+AUU3x7wok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=B5ccpVsM; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61GEqhMP3526026;
	Mon, 16 Feb 2026 19:44:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=zd6B2N
	Iec2MKTrQknnfEfVqb1JuAWmjCZoGLgdlRh24=; b=B5ccpVsMgggGsxxhmUrmqb
	+bRvuNPhzey56ScxwFxu2DMlhaAa/d4IYgGuL/M5S9yjb62TkkS5i1RBZVrAQUiC
	tIZ++Uf9+3EW+L4vsFp9UuOPbRslU+S4PHioy4biT75PVE3v5v5yFWBkBEY+KAgA
	T90pKB7Szp4Yv8qCU+ifO8jQ61W8f3sH3bqx7TU4x8eg5RGL+Ca79sZepr/Dxt1c
	IHWb8JzcxYz2ztt25lbMfwYQmjwd9yj73aA57v1wZESSM+ftM3+1aF0vSlG6JRWV
	E3AOD6dkPNTE/f9Zq8yaNZh+bplJwrnYPVUjaBjVZ2dNB0eHwjzuBawe3Pb/VE8Q
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4cajcj8hpg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 16 Feb 2026 19:44:52 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61GGjOHl004035;
	Mon, 16 Feb 2026 19:44:51 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4cb4cmxmcr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 16 Feb 2026 19:44:51 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61GJilp551314946
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Feb 2026 19:44:47 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9B5D620043;
	Mon, 16 Feb 2026 19:44:47 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9B61A20040;
	Mon, 16 Feb 2026 19:44:46 +0000 (GMT)
Received: from [9.87.132.244] (unknown [9.87.132.244])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 16 Feb 2026 19:44:46 +0000 (GMT)
Message-ID: <8f5f2131-b5cc-4a9a-84f7-57586c3df928@linux.ibm.com>
Date: Mon, 16 Feb 2026 20:44:45 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] s390x/kvm: Add ASTFLE facility 2 for nested
 virtualization
To: Christoph Schlameuss <schlameuss@linux.ibm.com>, qemu-devel@nongnu.org
Cc: Halil Pasic <pasic@linux.ibm.com>, Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        David Hildenbrand <david@kernel.org>, Thomas Huth <thuth@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Hendrik Brueckner <brueckner@linux.ibm.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>, qemu-s390x@nongnu.org,
        kvm@vger.kernel.org
References: <20260211-astfleie2-v1-1-cfa11f422fd8@linux.ibm.com>
Content-Language: en-US
From: Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20260211-astfleie2-v1-1-cfa11f422fd8@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 9sM1BSp6PJco8Z1Nslvk5YLzI2EHDmPU
X-Authority-Analysis: v=2.4 cv=Md9hep/f c=1 sm=1 tr=0 ts=699373b4 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VnNF1IyMAAAA:8
 a=69wJf7TsAAAA:8 a=KKAkSRfTAAAA:8 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
 a=PTbICRZ3nymfZhTA7ioA:9 a=NqO74GWdXPXpGKcKHaDJD/ajO6k=:19 a=QEXdDO2ut3YA:10
 a=Fg1AiH1G6rFz08G2ETeA:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjE2MDE2NCBTYWx0ZWRfX8FMS/CMi/THg
 2VfOUEJrAQaiL9iEBy8YFT1YZRfjUxU7Bqj4o2cfn0afzTpfbG/Au3OXVl42mZkFGQ99KOj5O3i
 JTZ4WmnXYiXVHV6GJeIVZf+ZJbsGWB06Zp4p3ccpWWV1Yq5q06Qpg3XCYvCnwR/gXz9744ZgWei
 ywgXXWg7LWX8ITI62KHGvUgCQ2PxO+QeyyqbhBHj6xppsiiLtl29w07ydfkgDor3wd0znluwari
 41bFx9N/m5KxhQrsQNiXWNr7O8/felT4K/rYdHpUcjLqGAim+MxNf9/Z5wxjuGN4uYI78KvYXkA
 QBvmvDLqIWr0zN3clBrWfUxBnYJsQNh6+Zyq95UZmfzQukB8bnj6i2/rUPGhZI+4H0pWEEiH8X3
 Ap6+bqtxeTxN9NrAwQXx916/3kV9fG0GmWv5H2RXgfqT9lP1eI/9OKweVO8L+82jBC/SqzIkMrd
 ZyxHB/sl39WpDnEQdjg==
X-Proofpoint-GUID: 9sM1BSp6PJco8Z1Nslvk5YLzI2EHDmPU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-16_06,2026-02-16_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 impostorscore=0 lowpriorityscore=0 spamscore=0 adultscore=0
 priorityscore=1501 suspectscore=0 malwarescore=0 phishscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602160164
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[16];
	TAGGED_RCPT(0.00)[kvm];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DKIM_TRACE(0.00)[ibm.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[borntraeger@linux.ibm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linaro.org:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,nongnu.org:email,linux.ibm.com:mid];
	PRECEDENCE_BULK(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71135-lists,kvm=lfdr.de];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Queue-Id: A8FB6147577
X-Rspamd-Action: no action



Am 11.02.26 um 15:56 schrieb Christoph Schlameuss:
> Allow propagation of the ASTFLEIE2 feature bit.
> 
> If the host does have the ASTFLE Interpretive Execution Facility 2 the
> guest can enable the ASTFLE format 2 for its guests.
> 
> Signed-off-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
> ---
> Cc: qemu-devel@nongnu.org
> Cc: Halil Pasic <pasic@linux.ibm.com>
> Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
> Cc: Eric Farman <farman@linux.ibm.com>
> Cc: Matthew Rosato <mjrosato@linux.ibm.com>
> Cc: Richard Henderson <richard.henderson@linaro.org>
> Cc: Ilya Leoshkevich <iii@linux.ibm.com>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Thomas Huth <thuth@redhat.com>
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Cc: Cornelia Huck <cohuck@redhat.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Hendrik Brueckner <brueckner@linux.ibm.com>
> Cc: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
> To: qemu-s390x@nongnu.org
> Cc: kvm@vger.kernel.org
> ---
> 
> @Christian, @Hendrik: Please confirm that we want to add ASTFLEIE2 to
> the Z16 default facilities.

This depends on the sie facility (sie format2) so I guess it should not be default
but rather FULL model.

