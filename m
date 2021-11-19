Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE89B456C05
	for <lists+kvm@lfdr.de>; Fri, 19 Nov 2021 10:01:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234511AbhKSJEG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Nov 2021 04:04:06 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:5282 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232274AbhKSJEG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Nov 2021 04:04:06 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AJ7kNA7014534;
        Fri, 19 Nov 2021 09:01:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=mUV8rFlrgy8XcdsROhPTtKdE+Jv7HhSCQqmC8ny2Wxg=;
 b=Z9kQLsmv007NPW2edBwoeldnlRDYlyMoTIV0PpxaJq0Qay6wMvU2SR8Z52EFxXTIfH7o
 BPwBBi0/XIiK59DV/MoGiSzYVeVd31+SetjMSP9sK7sF0z9MLOBzYAFm1S/vV2zLixLl
 t7AAMRI6dnejxe79eAYjKrl0Xd+ne7vMJ5nBGVJScfEQv4q7tixLzcl2vjZCp6okDLPT
 ZoPTKrbm5nxE+ZdoJ+6Q7xAZQ7CsJblgWv5Wl3BpELExqegvJekz7t3eGj7AFFwIALjP
 6zOjmFW+rTq13/hZAJWeeTUjAngfapnAMBwzNo+RSj3t00c6H89cb/Xf397TPkN72JyQ Og== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ce7u31d06-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Nov 2021 09:01:04 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1AJ8Wl55002154;
        Fri, 19 Nov 2021 09:01:03 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ce7u31cvn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Nov 2021 09:01:03 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1AJ8w1hg024791;
        Fri, 19 Nov 2021 09:00:52 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 3ca50bxku2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Nov 2021 09:00:52 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1AJ90fM73736288
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Nov 2021 09:00:41 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 28AA24C046;
        Fri, 19 Nov 2021 09:00:41 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9025A4C074;
        Fri, 19 Nov 2021 09:00:40 +0000 (GMT)
Received: from [9.145.43.13] (unknown [9.145.43.13])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 19 Nov 2021 09:00:40 +0000 (GMT)
Message-ID: <1a380055-536e-123d-499e-40314cf35f44@linux.ibm.com>
Date:   Fri, 19 Nov 2021 10:00:40 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v2 3/3] KVM: s390: gaccess: Cleanup access to guest frames
Content-Language: en-US
To:     Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Cc:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211028135556.1793063-1-scgl@linux.ibm.com>
 <20211028135556.1793063-4-scgl@linux.ibm.com>
 <4ac7c459-8e13-087a-f98d-9f3e0e6d8ee6@redhat.com>
 <457896b2-b462-639e-bb40-dee3716fcb9a@linux.vnet.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <457896b2-b462-639e-bb40-dee3716fcb9a@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: siZranAH2MCOjD4Qq1TTLJdJkp4YPjMD
X-Proofpoint-ORIG-GUID: K1OQkA2cKpY9h7pVL-Pph4zUPWrHVDNt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-19_08,2021-11-17_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 mlxscore=0 phishscore=0 priorityscore=1501 adultscore=0 mlxlogscore=999
 spamscore=0 malwarescore=0 lowpriorityscore=0 impostorscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111190049
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/28/21 16:48, Janis Schoetterl-Glausch wrote:
> On 10/28/21 16:25, David Hildenbrand wrote:
>> On 28.10.21 15:55, Janis Schoetterl-Glausch wrote:
>>> Introduce a helper function for guest frame access.
>>
>> "guest page access"
> 
> Ok.
>>
>> But I do wonder if you actually want to call it
>>
>> "access_guest_abs"
>>
>> and say "guest absolute access" instead here.
>>
>> Because we're dealing with absolute addresses and the fact that we are
>> accessing it page-wise is just because we have to perform a page-wise
>> translation in the callers (either virtual->absolute or real->absolute).
>>
>> Theoretically, if you know you're across X pages but they are contiguous
>> in absolute address space, nothing speaks against using that function
>> directly across X pages with a single call.
> 
> There currently is no point to this, is there?
> kvm_read/write_guest break the region up into pages anyway,
> so no reason to try to identify larger continuous chunks.

Considering that we call kvm functions that have page in the name and 
this is directly over the function where it's used I'd leave the naming 
as it is.

@David: How strongly do you feel about this?

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

>>
>>>
>>> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
>>> ---
>>>   arch/s390/kvm/gaccess.c | 24 ++++++++++++++++--------
>>>   1 file changed, 16 insertions(+), 8 deletions(-)
>>>
>>> diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
>>> index f0848c37b003..9a633310b6fe 100644
>>> --- a/arch/s390/kvm/gaccess.c
>>> +++ b/arch/s390/kvm/gaccess.c
>>> @@ -866,6 +866,20 @@ static int guest_range_to_gpas(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar,
>>>   	return 0;
>>>   }
>>>   
>>> +static int access_guest_page(struct kvm *kvm, enum gacc_mode mode, gpa_t gpa,
>>> +			      void *data, unsigned int len)
>>> +{
>>> +	const unsigned int offset = offset_in_page(gpa);
>>> +	const gfn_t gfn = gpa_to_gfn(gpa);
>>> +	int rc;
>>> +
>>> +	if (mode == GACC_STORE)
>>> +		rc = kvm_write_guest_page(kvm, gfn, data, offset, len);
>>> +	else
>>> +		rc = kvm_read_guest_page(kvm, gfn, data, offset, len);
>>> +	return rc;
>>> +}
>>> +
>>>   int access_guest(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar, void *data,
>>>   		 unsigned long len, enum gacc_mode mode)
>>>   {
>>> @@ -896,10 +910,7 @@ int access_guest(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar, void *data,
>>>   	rc = guest_range_to_gpas(vcpu, ga, ar, gpas, len, asce, mode);
>>>   	for (idx = 0; idx < nr_pages && !rc; idx++) {
>>>   		fragment_len = min(PAGE_SIZE - offset_in_page(gpas[idx]), len);
>>> -		if (mode == GACC_STORE)
>>> -			rc = kvm_write_guest(vcpu->kvm, gpas[idx], data, fragment_len);
>>> -		else
>>> -			rc = kvm_read_guest(vcpu->kvm, gpas[idx], data, fragment_len);
>>> +		rc = access_guest_page(vcpu->kvm, mode, gpas[idx], data, fragment_len);
>>>   		len -= fragment_len;
>>>   		data += fragment_len;
>>>   	}
>>> @@ -920,10 +931,7 @@ int access_guest_real(struct kvm_vcpu *vcpu, unsigned long gra,
>>>   	while (len && !rc) {
>>>   		gpa = kvm_s390_real_to_abs(vcpu, gra);
>>>   		fragment_len = min(PAGE_SIZE - offset_in_page(gpa), len);
>>> -		if (mode)
>>> -			rc = write_guest_abs(vcpu, gpa, data, fragment_len);
>>> -		else
>>> -			rc = read_guest_abs(vcpu, gpa, data, fragment_len);
>>> +		rc = access_guest_page(vcpu->kvm, mode, gpa, data, fragment_len);
>>>   		len -= fragment_len;
>>>   		gra += fragment_len;
>>>   		data += fragment_len;
>>>
>>
>>
> 

