Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F0E143E436
	for <lists+kvm@lfdr.de>; Thu, 28 Oct 2021 16:49:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231409AbhJ1OvE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Oct 2021 10:51:04 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:57076 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231235AbhJ1OvC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 28 Oct 2021 10:51:02 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19SDmh6a030596;
        Thu, 28 Oct 2021 14:48:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=AkOfNJYInjF/oBHpisU8Hp0IrDgq53HnCVySzYnXpnk=;
 b=a6j3jvcUMwCj+8UPYFaO16PQBYwujIS/cuMVmT30qhQrEhebPhN6SQVYgV8rTmqHetTI
 uVDps4mdttjHN1UxHZDPwDXuJa44sK6YpAuwU71CcBH1aEZQKC9FbyW4rE+ATDONA9j0
 LOBdJLPN9fem0Nb49WrWxh6uz4c1lTG6lBMj3MQZ2B7JZhY3zYj+NIut9GcuyJJMvWWW
 DXSmfrqi5+aqJtOGZUEd/F0EXVMaNYUlxvKL1zhXPz/wfAyuj2lxcIiR3zi8I/6dQ3Nh
 emxN4QOV/mkqE78blI+RLHVR7l2s9KH+Zpa7jv/GWVgE6yA77GD3FS2fQvvpW2NFBLNn hA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3byw2n9dg0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Oct 2021 14:48:35 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19SEOmdF008877;
        Thu, 28 Oct 2021 14:48:35 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3byw2n9df6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Oct 2021 14:48:35 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19SEmNTT025217;
        Thu, 28 Oct 2021 14:48:32 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma05fra.de.ibm.com with ESMTP id 3bx4es0snn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Oct 2021 14:48:32 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19SEmTxB524856
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Oct 2021 14:48:29 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 17B9B4C059;
        Thu, 28 Oct 2021 14:48:29 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 952F34C04A;
        Thu, 28 Oct 2021 14:48:28 +0000 (GMT)
Received: from [9.171.30.68] (unknown [9.171.30.68])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 28 Oct 2021 14:48:28 +0000 (GMT)
Message-ID: <457896b2-b462-639e-bb40-dee3716fcb9a@linux.vnet.ibm.com>
Date:   Thu, 28 Oct 2021 16:48:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v2 3/3] KVM: s390: gaccess: Cleanup access to guest frames
Content-Language: en-US
To:     David Hildenbrand <david@redhat.com>,
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Cc:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211028135556.1793063-1-scgl@linux.ibm.com>
 <20211028135556.1793063-4-scgl@linux.ibm.com>
 <4ac7c459-8e13-087a-f98d-9f3e0e6d8ee6@redhat.com>
From:   Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>
In-Reply-To: <4ac7c459-8e13-087a-f98d-9f3e0e6d8ee6@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: k53KMm4IAAkzNdsYvhd724PKKsITVDp-
X-Proofpoint-ORIG-GUID: pm5fHHQCBtMRbV_KgNakyK2z3EijAQtP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-28_01,2021-10-26_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 mlxscore=0 spamscore=0 bulkscore=0 adultscore=0 clxscore=1011
 mlxlogscore=999 lowpriorityscore=0 impostorscore=0 priorityscore=1501
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2110280081
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/28/21 16:25, David Hildenbrand wrote:
> On 28.10.21 15:55, Janis Schoetterl-Glausch wrote:
>> Introduce a helper function for guest frame access.
> 
> "guest page access"

Ok.
> 
> But I do wonder if you actually want to call it
> 
> "access_guest_abs"
> 
> and say "guest absolute access" instead here.
> 
> Because we're dealing with absolute addresses and the fact that we are
> accessing it page-wise is just because we have to perform a page-wise
> translation in the callers (either virtual->absolute or real->absolute).
> 
> Theoretically, if you know you're across X pages but they are contiguous
> in absolute address space, nothing speaks against using that function
> directly across X pages with a single call.

There currently is no point to this, is there?
kvm_read/write_guest break the region up into pages anyway,
so no reason to try to identify larger continuous chunks.
> 
>>
>> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
>> ---
>>  arch/s390/kvm/gaccess.c | 24 ++++++++++++++++--------
>>  1 file changed, 16 insertions(+), 8 deletions(-)
>>
>> diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
>> index f0848c37b003..9a633310b6fe 100644
>> --- a/arch/s390/kvm/gaccess.c
>> +++ b/arch/s390/kvm/gaccess.c
>> @@ -866,6 +866,20 @@ static int guest_range_to_gpas(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar,
>>  	return 0;
>>  }
>>  
>> +static int access_guest_page(struct kvm *kvm, enum gacc_mode mode, gpa_t gpa,
>> +			      void *data, unsigned int len)
>> +{
>> +	const unsigned int offset = offset_in_page(gpa);
>> +	const gfn_t gfn = gpa_to_gfn(gpa);
>> +	int rc;
>> +
>> +	if (mode == GACC_STORE)
>> +		rc = kvm_write_guest_page(kvm, gfn, data, offset, len);
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
>>
> 
> 

