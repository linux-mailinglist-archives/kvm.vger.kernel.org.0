Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C26B94610FA
	for <lists+kvm@lfdr.de>; Mon, 29 Nov 2021 10:19:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243873AbhK2JXH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Nov 2021 04:23:07 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:54376 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242850AbhK2JVH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 29 Nov 2021 04:21:07 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AT8lIB5013427;
        Mon, 29 Nov 2021 09:17:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=jaTaaCN7Rtus0I+DZbL6uB1J53A0coTNWLrcR+M658s=;
 b=ZPGQB/IyksQriErTVPmVNuBXTd4iNopEb98Lr+aEd5IOtGGRh0rJ74pfHjG1KgoW2/dE
 s3zIyqEpNhLtczJj+GfKlPYeb05xFnhkpr7nis1zTH1cmDsDl1JoUyD/wx0SzSVe93TY
 ek+s7Ond4hLVjJHbx4A4J5vKRzeDIP3ESM2L3cnFQP0nLTMB6XslomHpTNb7PS9BGpPx
 FgZF7ANHvSNPgpm7HMKNe2zDEQpFC2k2+oVA02AqtyJwCeVM3YgAw6OlBJGvOVKeOc62
 OPP67dzHeUEy8IlhLE9nt7EUxCbc4asYUH6cXAhgzLDJIYe17JAjmXoMUL2/unvvbbZV 3w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cmunm8kxu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 29 Nov 2021 09:17:49 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1AT9HnIX004602;
        Mon, 29 Nov 2021 09:17:49 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cmunm8kx0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 29 Nov 2021 09:17:49 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1AT9E9GN013971;
        Mon, 29 Nov 2021 09:17:46 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 3ckbxjjujd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 29 Nov 2021 09:17:46 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1AT9HhTT29360518
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 29 Nov 2021 09:17:43 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 539B4AE059;
        Mon, 29 Nov 2021 09:17:43 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CEC26AE056;
        Mon, 29 Nov 2021 09:17:42 +0000 (GMT)
Received: from [9.171.16.66] (unknown [9.171.16.66])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 29 Nov 2021 09:17:42 +0000 (GMT)
Message-ID: <20f63bce-31b0-091d-111a-eee16bc9304d@linux.vnet.ibm.com>
Date:   Mon, 29 Nov 2021 10:17:42 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v3 3/3] KVM: s390: gaccess: Cleanup access to guest pages
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211126164549.7046-1-scgl@linux.ibm.com>
 <20211126164549.7046-4-scgl@linux.ibm.com>
 <20211129095914.34975067@p-imbrenda>
From:   Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>
In-Reply-To: <20211129095914.34975067@p-imbrenda>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: QzpW5KLm1idKCy6CUrOuMLNLi1U9Sw4s
X-Proofpoint-GUID: Zsx7DzeXeSL1LkXsgTeq1_Lq87tNDSrV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-29_06,2021-11-28_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 bulkscore=0 mlxscore=0 adultscore=0 spamscore=0 phishscore=0
 mlxlogscore=999 malwarescore=0 impostorscore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111290042
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/29/21 09:59, Claudio Imbrenda wrote:
> On Fri, 26 Nov 2021 17:45:49 +0100
> Janis Schoetterl-Glausch <scgl@linux.ibm.com> wrote:
> 
>> Introduce a helper function for guest frame access.
>>
>> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
>> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
> 
> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

Thanks.
> 
> see a small nit below
> 
>> ---
>>  arch/s390/kvm/gaccess.c | 24 ++++++++++++++++--------
>>  1 file changed, 16 insertions(+), 8 deletions(-)
>>
>> diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
>> index c09659609d68..9193f0de40b1 100644
>> --- a/arch/s390/kvm/gaccess.c
>> +++ b/arch/s390/kvm/gaccess.c
>> @@ -866,6 +866,20 @@ static int guest_range_to_gpas(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar,
>>  	return 0;
>>  }
>>  
>> +static int access_guest_page(struct kvm *kvm, enum gacc_mode mode, gpa_t gpa,
>> +			     void *data, unsigned int len)
>> +{
>> +	const unsigned int offset = offset_in_page(gpa);
>> +	const gfn_t gfn = gpa_to_gfn(gpa);
>> +	int rc;
>> +
>> +	if (mode == GACC_STORE)
>> +		rc = kvm_write_guest_page(kvm, gfn, data, offset, len);
> 
> why not just return ?

No clue, maybe I wanted to look at the rc while debugging something?
> 
> (but don't bother with a v4, it's ok anyway)
> 
>> +	else
>> +		rc = kvm_read_guest_page(kvm, gfn, data, offset, len);
>> +	return rc;
>> +}
>> +
>>  int access_guest(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar, void *data,
>>  		 unsigned long len, enum gacc_mode mode)
>>  {
>> @@ -896,10 +910,7 @@ int access_guest(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar, void *data,
>>  	rc = guest_range_to_gpas(vcpu, ga, ar, gpas, len, asce, mode);
>>  	for (idx = 0; idx < nr_pages && !rc; idx++) {
>>  		fragment_len = min(PAGE_SIZE - offset_in_page(gpas[idx]), len);
>> -		if (mode == GACC_STORE)
>> -			rc = kvm_write_guest(vcpu->kvm, gpas[idx], data, fragment_len);
>> -		else
>> -			rc = kvm_read_guest(vcpu->kvm, gpas[idx], data, fragment_len);
>> +		rc = access_guest_page(vcpu->kvm, mode, gpas[idx], data, fragment_len);
>>  		len -= fragment_len;
>>  		data += fragment_len;
>>  	}
>> @@ -920,10 +931,7 @@ int access_guest_real(struct kvm_vcpu *vcpu, unsigned long gra,
>>  	while (len && !rc) {
>>  		gpa = kvm_s390_real_to_abs(vcpu, gra);
>>  		fragment_len = min(PAGE_SIZE - offset_in_page(gpa), len);
>> -		if (mode)
>> -			rc = write_guest_abs(vcpu, gpa, data, fragment_len);
>> -		else
>> -			rc = read_guest_abs(vcpu, gpa, data, fragment_len);
>> +		rc = access_guest_page(vcpu->kvm, mode, gpa, data, fragment_len);
>>  		len -= fragment_len;
>>  		gra += fragment_len;
>>  		data += fragment_len;
> 

