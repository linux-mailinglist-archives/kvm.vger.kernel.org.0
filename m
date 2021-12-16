Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 537B1477582
	for <lists+kvm@lfdr.de>; Thu, 16 Dec 2021 16:15:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238357AbhLPPPG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Dec 2021 10:15:06 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:31942 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229920AbhLPPPF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 16 Dec 2021 10:15:05 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BGChRSr001375;
        Thu, 16 Dec 2021 15:15:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=8mNG9FDkFq836lYUnvOaLLWV/RE+5Ig7r6Nanpdxugs=;
 b=ruiRQ9CAM/RkeQTr0jGv9TtqC04uBP3fQIEZQFuBH/ATIHJZ2d+O2+Q9b2D+bckWREfv
 Jb8P8m8lXUIglFhVK+IEW24g7uDGT9BiqPbLXIrGpYt8BqmHisGtVsQ7l50sKfcs4K5Y
 ipJQYLuoavcmn2zHv5iLvSHqFo6CN30LZ7jxn0bPq7C5saLqWsEvcXIHLYSGouGB5GCr
 wZa2bjwUtvzzI5SM4ifyYrNe6mXVxf2uVvaGXmeWd8MNrb95innNq4DDG2Tq069CpYzf
 /XBLrvibwXItslQBtAB5xZpgBc3UkbpYzs2oggJKlSgX87xS0lkwEWLkS8q6NsrVNDGf tg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cy2tqu5qy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Dec 2021 15:15:04 +0000
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1BGEkSpc006520;
        Thu, 16 Dec 2021 15:15:04 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cy2tqu5pu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Dec 2021 15:15:04 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1BGFDAHL001592;
        Thu, 16 Dec 2021 15:15:02 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 3cy7jr8adc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Dec 2021 15:15:01 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1BGFEwCW22151536
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Dec 2021 15:14:58 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B1F41AE045;
        Thu, 16 Dec 2021 15:14:58 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1E3CEAE051;
        Thu, 16 Dec 2021 15:14:58 +0000 (GMT)
Received: from [9.171.32.185] (unknown [9.171.32.185])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 16 Dec 2021 15:14:58 +0000 (GMT)
Message-ID: <80d924b1-d512-bf64-17c9-746a80776d28@linux.ibm.com>
Date:   Thu, 16 Dec 2021 16:16:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v5 0/1] s390x: KVM: CPU Topology
Content-Language: en-US
To:     Alexandra Winter <wintera@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, cohuck@redhat.com,
        david@redhat.com, thuth@redhat.com, imbrenda@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com
References: <20211122131443.66632-1-pmorel@linux.ibm.com>
 <01e383ae-9885-e384-f553-c3fbeb040192@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <01e383ae-9885-e384-f553-c3fbeb040192@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: eK_QHQJkfZjbbBxTkSOVeylPZKcihpD6
X-Proofpoint-ORIG-GUID: ICzbj21SKKpxBeeBU_XPeGtshQJ3ANeu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-16_05,2021-12-16_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 spamscore=0
 adultscore=0 bulkscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 phishscore=0 clxscore=1015 mlxlogscore=999 priorityscore=1501
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112160085
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 12/14/21 10:01, Alexandra Winter wrote:
> 
> 
> On 22.11.21 14:14, Pierre Morel wrote:
>> Hi all,
>>
>> This new series add the implementation of interpretation for
>> the PTF instruction.
>>
>> The series provides:
>> 1- interception of the STSI instruction forwarding the CPU topology
>> 2- interpretation of the PTF instruction
>> 3- a KVM capability for the userland hypervisor to ask KVM to
>>     setup PTF interpretation.
>>
>>
>> 0- Foreword
>>
> [...]
>> We will ignore the following changes inside a STSI(15.1.2):
>> - polarization: only horizontal polarization is currently used in Linux.
>> - CPU Type: only IFL Type are supported in Linux
> I thought Linux can also run on General Purpose CPUs ??
> 

You are right, I will change these comments.
Thanks

-- 
Pierre Morel
IBM Lab Boeblingen
