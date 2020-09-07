Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D741225F6E1
	for <lists+kvm@lfdr.de>; Mon,  7 Sep 2020 11:51:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728411AbgIGJvB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Sep 2020 05:51:01 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:40646 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728243AbgIGJvA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 7 Sep 2020 05:51:00 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0879XCPS116151;
        Mon, 7 Sep 2020 05:50:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=X26bLwsUr/LMDuqAZRWk5qvnmjFfYowIItV3vTC0m0I=;
 b=BWZtQyW+UOSFRrfJRymmAEihvRS1LAtXodKbC4R6yEFRt3Da4SXM8HISYlj7foYk1oSG
 F4LhAzcXCFM2Tip3dYRBRrhbAuKbgLpqJLBuq60ta4gIIihDhO4IrV2cHAFZZ3edyBh7
 JK8sAPfzupk2CxIdKhqe0/Kdxjd6L+viui7hT8y37VZcDQJrqmbkRFrOVywXNoBEmwnq
 mbEFIPGpOAyl9E0VhsTJ0EOuTFIYvCbiDi9OaBA0f6letSqaHrapcdOv7H/c/Jv6w704
 AIcgk5RlQzWW0qCu8TqikOKo0FmbdMVcl/i/6F2PxxXmy5tM8bigtIuDqcOmA82EEiY6 Mg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33dj1tryx4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Sep 2020 05:50:59 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0879XIZ7116853;
        Mon, 7 Sep 2020 05:50:59 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33dj1tryvw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Sep 2020 05:50:58 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0879nOq4021488;
        Mon, 7 Sep 2020 09:50:56 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06fra.de.ibm.com with ESMTP id 33c1xh9c0c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Sep 2020 09:50:56 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0879ornU18088228
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 7 Sep 2020 09:50:53 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 596F54204C;
        Mon,  7 Sep 2020 09:50:53 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F34A34203F;
        Mon,  7 Sep 2020 09:50:52 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.67.24])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  7 Sep 2020 09:50:52 +0000 (GMT)
Subject: Re: [PATCH 1/2] s390x: uv: Add destroy page call
To:     Heiko Carstens <hca@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, borntraeger@de.ibm.com,
        gor@linux.ibm.com, imbrenda@linux.ibm.com, kvm@vger.kernel.org,
        david@redhat.com
References: <20200903131435.2535-1-frankja@linux.ibm.com>
 <20200903131435.2535-2-frankja@linux.ibm.com> <20200904103939.GE6075@osiris>
 <98237148-bbb4-c6d7-aba2-6fa11fb788b1@linux.ibm.com>
 <20200904121055.GF6075@osiris>
From:   Janosch Frank <frankja@linux.ibm.com>
Message-ID: <c0be7eae-68c8-cbd2-6cbf-56708cb42770@linux.ibm.com>
Date:   Mon, 7 Sep 2020 11:50:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200904121055.GF6075@osiris>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-07_04:2020-09-07,2020-09-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 mlxlogscore=999 clxscore=1015 priorityscore=1501 bulkscore=0
 suspectscore=0 lowpriorityscore=0 impostorscore=0 adultscore=0
 phishscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009070093
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/4/20 2:10 PM, Heiko Carstens wrote:
> On Fri, Sep 04, 2020 at 01:38:53PM +0200, Janosch Frank wrote:
>>>>   * Requests the Ultravisor to encrypt a guest page and make it
>>>>   * accessible to the host for paging (export).
>>>> diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
>>>> index 373542ca1113..cfb0017f33a7 100644
>>>> --- a/arch/s390/mm/gmap.c
>>>> +++ b/arch/s390/mm/gmap.c
>>>> @@ -2679,7 +2679,7 @@ static int __s390_reset_acc(pte_t *ptep, unsigned long addr,
>>>>  	pte_t pte = READ_ONCE(*ptep);
>>>>  
>>>>  	if (pte_present(pte))
>>>> -		WARN_ON_ONCE(uv_convert_from_secure(pte_val(pte) & PAGE_MASK));
>>>> +		WARN_ON_ONCE(uv_destroy_page(pte_val(pte) & PAGE_MASK));
>>>
>>> Why not put the WARN_ON_ONCE() into uv_destroy_page() and make that
>>> function return void?
>>>
>> If you prefer that, I'll change the patch.
> 
> Seems to be better to me. Otherwise you start to sprinkle WARN_ONs all
> over the code, _if_ there would be more callers.

The other call sites currently don't care about the return codes which
is not optimal.

I'd prefer to leave it as is and put a debug item on the todo list which
takes care of providing more debug data on error.

> 
>> I think we'd need a proper print of the return codes of the UVC anyway,
>> the warn isn't very helpful if you want to debug after the fact.
> 
> Maybe a new debug feature? Well, but that's something that hasn't do
> anything with this code.


