Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E965848B3E2
	for <lists+kvm@lfdr.de>; Tue, 11 Jan 2022 18:30:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244766AbiAKRaE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jan 2022 12:30:04 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:58980 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241516AbiAKRaE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 11 Jan 2022 12:30:04 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20BGA0Fh023333;
        Tue, 11 Jan 2022 17:30:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=0pKoie7nQKiQsCsIxK/RQOJuHvRNFcldpzSGOsxu6vI=;
 b=rXq5+wartYvUB5j0+v/fc3+M8PWD9gUg1VdgRbukO9gk9GsUG1rsu5moOtUe7f4Pi+gU
 KUF/uQBySk6M3Oll3i9Znyc6V0CAqfFvUW+4DHPbvXeWZJ3KUKtbieBq9Oo3qlV720td
 9ly/k23h3snfLxrgKblQjL7BC3fdTI6IP1Lx529fGjc8UQCmnGWmKs29XaTSr4mK6l1F
 W47i5NChLGRg34oNSS/C1/iHZxvA8cRyunYj/fE1cAmiq7kkjFXNsbdd+vP2GINO6dg7
 J2mDvj3AUkG5Ix8UzgKSawD3khKPYgMVAmLTxgQzwj3fAkleijbxEasje5PkJYIBZcMJ 4w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dh6u1byg7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jan 2022 17:30:02 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20BHU1w2014891;
        Tue, 11 Jan 2022 17:30:01 GMT
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dh6u1byfe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jan 2022 17:30:01 +0000
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20BHHivi024637;
        Tue, 11 Jan 2022 17:30:00 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma02wdc.us.ibm.com with ESMTP id 3df28ahmxn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jan 2022 17:30:00 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20BHTwku19464702
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jan 2022 17:29:58 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ADB7228074;
        Tue, 11 Jan 2022 17:29:57 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 23E802808A;
        Tue, 11 Jan 2022 17:29:56 +0000 (GMT)
Received: from [9.65.85.237] (unknown [9.65.85.237])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 11 Jan 2022 17:29:55 +0000 (GMT)
Message-ID: <2e26406f-0af8-af23-de7d-138ef81d3018@linux.ibm.com>
Date:   Tue, 11 Jan 2022 12:29:55 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v17 01/15] s390/vfio-ap: Set pqap hook when vfio_ap module
 is loaded
Content-Language: en-US
To:     jjherne@linux.ibm.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com
References: <20211021152332.70455-1-akrowiak@linux.ibm.com>
 <20211021152332.70455-2-akrowiak@linux.ibm.com>
 <47dc7326-b802-6023-6144-7bf4309756b4@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
In-Reply-To: <47dc7326-b802-6023-6144-7bf4309756b4@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: tDApdIYhEyItG-HboJw-vdJt_P9tQqJX
X-Proofpoint-ORIG-GUID: IXJrwwB3stb-d5AbezbaLPOQn9PMudTc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-11_04,2022-01-11_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 suspectscore=0 mlxscore=0 mlxlogscore=999 clxscore=1011 spamscore=0
 bulkscore=0 impostorscore=0 adultscore=0 phishscore=0 lowpriorityscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201110094
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/4/22 11:22, Jason J. Herne wrote:
> On 10/21/21 11:23, Tony Krowiak wrote:
>
>> diff --git a/arch/s390/include/asm/kvm_host.h 
>> b/arch/s390/include/asm/kvm_host.h
>> index a604d51acfc8..05569d077d7f 100644
>> --- a/arch/s390/include/asm/kvm_host.h
>> +++ b/arch/s390/include/asm/kvm_host.h
>> @@ -799,16 +799,17 @@ struct kvm_s390_cpu_model {
>>       unsigned short ibc;
>>   };
>>   -typedef int (*crypto_hook)(struct kvm_vcpu *vcpu);
>> +struct kvm_s390_crypto_hook {
>> +    int (*fcn)(struct kvm_vcpu *vcpu);
>> +};
>
> Why are we storing a single function pointer inside a struct? Seems 
> simpler to just use a function pointer. What was the problem with the 
> typedef that you are replacing?

In case you didn't see my response to Halil, the point is now moot 
because I'm eliminating this patch.


