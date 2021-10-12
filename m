Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B628F42A46E
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 14:31:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236281AbhJLMde (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Oct 2021 08:33:34 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:32350 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S236346AbhJLMd0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 12 Oct 2021 08:33:26 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19CAnGwf013182;
        Tue, 12 Oct 2021 08:31:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=NGL6uHWcC/qeuSR1nITAcLMws/D4n1oX/88GgyPHGmA=;
 b=Q5i6fvQHi4LemB7VEPAWBcXTlbNAaSpJ+smMK6Te2ea2aER/2MYsIsxVJ3SQ5WQQ5IWh
 WoQyx7+6COCyZIhjyt7Ts/4kDs+MJxe+PAKfE1UIgU3dOLk3YYc8f7cvN404XhQx6/8G
 T3r5lUrpVfLEaghCkAOoh/75JLMKgc8dMeYHQixQ5PX+MCG4zQx7jNUFzFOck9aZYijO
 bDXk+hllQW5rvqnRNwE4bGoE478aLG8eRlZjQb01SiRxDs6bpLX/w4ACDbYX/8Ae07xX
 3cKUsO1G268nO6CKrko7lqiQJUgfCFgJooZI9qFSC7YybQOwt2p8VGSFLwYPWHBLF9v6 7A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bn66qnxe8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Oct 2021 08:31:24 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19CCHV9C024781;
        Tue, 12 Oct 2021 08:31:23 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bn66qnxd3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Oct 2021 08:31:23 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19CCDNrH015897;
        Tue, 12 Oct 2021 12:31:21 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3bk2qa0cm1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Oct 2021 12:31:21 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19CCPQcc45744540
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Oct 2021 12:25:26 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DD253AE06C;
        Tue, 12 Oct 2021 12:31:01 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5C96DAE068;
        Tue, 12 Oct 2021 12:31:01 +0000 (GMT)
Received: from [9.145.51.19] (unknown [9.145.51.19])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 12 Oct 2021 12:31:01 +0000 (GMT)
Message-ID: <e18fb171-726e-dc28-7a09-3c110bb97ff8@linux.ibm.com>
Date:   Tue, 12 Oct 2021 14:31:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v5 08/14] KVM: s390: pv: handle secure storage exceptions
 for normal guests
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, cohuck@redhat.com, borntraeger@de.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, david@redhat.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ulrich.Weigand@de.ibm.com
References: <20210920132502.36111-1-imbrenda@linux.ibm.com>
 <20210920132502.36111-9-imbrenda@linux.ibm.com>
 <f442a49f-dbc4-5c38-ffa1-6b17742592c3@linux.ibm.com>
 <20211012103550.501857f5@p-imbrenda>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20211012103550.501857f5@p-imbrenda>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: MKPzYILyVDBdDYwg7M7oY0AHhr8jawDl
X-Proofpoint-GUID: QFIgnLzIa6ncCera3gjj78_TO1pb7O-h
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-12_03,2021-10-12_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 impostorscore=0 suspectscore=0 bulkscore=0 phishscore=0
 clxscore=1015 mlxlogscore=912 priorityscore=1501 mlxscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110120073
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/12/21 10:35, Claudio Imbrenda wrote:
> On Tue, 12 Oct 2021 10:16:26 +0200
> Janosch Frank <frankja@linux.ibm.com> wrote:
> 
>> On 9/20/21 15:24, Claudio Imbrenda wrote:
>>> With upcoming patches, normal guests might touch secure pages.
>>>
>>> This patch extends the existing exception handler to convert the pages
>>> to non secure also when the exception is triggered by a normal guest.
>>>
>>> This can happen for example when a secure guest reboots; the first
>>> stage of a secure guest is non secure, and in general a secure guest
>>> can reboot into non-secure mode.
>>>
>>> If the secure memory of the previous boot has not been cleared up
>>> completely yet, a non-secure guest might touch secure memory, which
>>> will need to be handled properly.
>>>
>>> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
>>> ---
>>>    arch/s390/mm/fault.c | 10 +++++++++-
>>>    1 file changed, 9 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
>>> index eb68b4f36927..74784581f42d 100644
>>> --- a/arch/s390/mm/fault.c
>>> +++ b/arch/s390/mm/fault.c
>>> @@ -767,6 +767,7 @@ void do_secure_storage_access(struct pt_regs *regs)
>>>    	struct vm_area_struct *vma;
>>>    	struct mm_struct *mm;
>>>    	struct page *page;
>>> +	struct gmap *gmap;
>>>    	int rc;
>>>    
>>>    	/*
>>> @@ -796,6 +797,14 @@ void do_secure_storage_access(struct pt_regs *regs)
>>>    	}
>>>    
>>>    	switch (get_fault_type(regs)) {
>>> +	case GMAP_FAULT:
>>> +		gmap = (struct gmap *)S390_lowcore.gmap;
>>> +		addr = __gmap_translate(gmap, addr);
>>> +		if (IS_ERR_VALUE(addr)) {
>>> +			do_fault_error(regs, VM_ACCESS_FLAGS, VM_FAULT_BADMAP);
>>> +			break;
>>> +		}
>>> +		fallthrough;
>>
>> This would trigger an export and not a destroy, right?
> 
> correct. but this would only happen for leftover secure pages touched
> by non-secure guests, before the background thread could clean them up.

I.e. we don't expect to need the destroy speed boost?

> 
>>
>>>    	case USER_FAULT:
>>>    		mm = current->mm;
>>>    		mmap_read_lock(mm);
>>> @@ -824,7 +833,6 @@ void do_secure_storage_access(struct pt_regs *regs)
>>>    		if (rc)
>>>    			BUG();
>>>    		break;
>>> -	case GMAP_FAULT:
>>>    	default:
>>>    		do_fault_error(regs, VM_READ | VM_WRITE, VM_FAULT_BADMAP);
>>>    		WARN_ON_ONCE(1);
>>>    
>>
> 

