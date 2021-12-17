Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04889478F3C
	for <lists+kvm@lfdr.de>; Fri, 17 Dec 2021 16:11:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238059AbhLQPLT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Dec 2021 10:11:19 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:27560 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S235100AbhLQPLT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 17 Dec 2021 10:11:19 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BHEkPN6003015;
        Fri, 17 Dec 2021 15:11:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=M6lPngrp2vwuMZmG5e8QBRbUHbHRxujWyEry0WFgX/Q=;
 b=Uxa8DWcfhM+WSfq1zMv7PY6zmt4CrMH6obYYONAdgLbOM1MSUvoupzFDHtLgLwe8y03p
 stgu/snazNn1UnR6N7xikShyYGYbdEWHZg8bOHnHQ/JdqNWZhdTL7/Wo1wtZ7FRJiN5q
 lWghZpvXn1VXYaS72qSBhJ37cVEwewzIKgOVcdR0eLAeCshZtGg212Th3UYVJ2BWcthI
 At68b/W69EdWaGlZ1CtXs2/fjmhw1Dud4K7N99nTJ2C4nD/85RHBthFI+x6km9LaoI/u
 lcTGwdxmizRMEqOnQ26eYxbSpPfIDQR6tzo6NqZAeJjy+lVumV5vepLzQdmGPzDNk170 lw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cyr22y3x6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Dec 2021 15:11:18 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1BHF7Pxe028874;
        Fri, 17 Dec 2021 15:11:17 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cyr22y3wg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Dec 2021 15:11:17 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1BHEF4GP018276;
        Fri, 17 Dec 2021 15:06:09 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04fra.de.ibm.com with ESMTP id 3cy7vw1915-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Dec 2021 15:06:09 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1BHF66Xn45023616
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Dec 2021 15:06:06 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E326352059;
        Fri, 17 Dec 2021 15:06:05 +0000 (GMT)
Received: from [9.171.60.51] (unknown [9.171.60.51])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 0548D5205A;
        Fri, 17 Dec 2021 15:06:04 +0000 (GMT)
Message-ID: <4cd2dff3-7612-8b17-baa6-386cfc6501d6@linux.ibm.com>
Date:   Fri, 17 Dec 2021 16:06:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH 17/32] KVM: s390: expose the guest Adapter Interruption
 Source ID facility
Content-Language: en-US
To:     Matthew Rosato <mjrosato@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        frankja@linux.ibm.com, david@redhat.com, imbrenda@linux.ibm.com,
        vneethv@linux.ibm.com, oberpar@linux.ibm.com, freude@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211207205743.150299-1-mjrosato@linux.ibm.com>
 <20211207205743.150299-18-mjrosato@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20211207205743.150299-18-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: dO2rGzo0WZvLNqfUh4BT2H5SSHQdh3DW
X-Proofpoint-ORIG-GUID: ZxU0A4mq4zhEKI3KkFvt0jXXYjA9xZ4z
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-17_05,2021-12-16_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 suspectscore=0
 mlxscore=0 impostorscore=0 spamscore=0 clxscore=1015 adultscore=0
 bulkscore=0 malwarescore=0 mlxlogscore=999 priorityscore=1501
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112170088
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 07.12.21 um 21:57 schrieb Matthew Rosato:
> This facility will be used to enable forwarding of PCI interrupts from
> firmware directly to guests.
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>   arch/s390/kvm/kvm-s390.c | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 09991d05c871..d44ca313a1b7 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -2755,6 +2755,10 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>   		set_kvm_facility(kvm->arch.model.fac_mask, 69);
>   		set_kvm_facility(kvm->arch.model.fac_list, 69);
>   	}
> +	if (sclp.has_aisii && test_facility(70)) {
> +		set_kvm_facility(kvm->arch.model.fac_mask, 70);
> +		set_kvm_facility(kvm->arch.model.fac_list, 70);
> +	}
>   
same as patch 16 (as well as 18)

>   	if (css_general_characteristics.aiv && test_facility(65))
>   		set_kvm_facility(kvm->arch.model.fac_mask, 65);
> 
