Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DE9F493AF3
	for <lists+kvm@lfdr.de>; Wed, 19 Jan 2022 14:18:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354734AbiASNRw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jan 2022 08:17:52 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:54216 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236079AbiASNRv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 19 Jan 2022 08:17:51 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20JDBbVu023669;
        Wed, 19 Jan 2022 13:17:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=qrKjuUZp1jlWDRxrOD22C+smX0Ri2Dq1Vk62uFD9g/c=;
 b=OWzfYV3JMlVLcwLcFdOZbCD/+PUxjrZ5R2LUb5DShY+5PNK5sax06hLF4yZooJo3izcZ
 IzuqZFiVf1fDytUUwHsfnuIEsGA0LqNQujsBXTP1VJlRZ3csI8IN8SQ7mz44sTSiAV1r
 VSVWXh7i5PKfPlw2DfaeY+7V00SVoB14SD5iawI1wBm3x42X10Do0Zp4SAZ4zsXv7GJE
 wgFBDoQQ5vB7AedEBD7dDBHmuKnk7XGVfAgWL1YY3SmzP4sDWUTPyMtGGEZeYg6zVMOp
 jDAnI5tO0qwiISg0nahs2NI2PqSFVOwZz/UPj2dSl+idBsAa9hCF19Bpm08pCcTxPQ6e NA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dpgwf3ef8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Jan 2022 13:17:50 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20JDBJWU010009;
        Wed, 19 Jan 2022 13:17:50 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dpgwf3eeh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Jan 2022 13:17:50 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20JD8DK7000494;
        Wed, 19 Jan 2022 13:17:47 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04fra.de.ibm.com with ESMTP id 3dknw9m8kx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Jan 2022 13:17:47 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20JDHhIi43188486
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Jan 2022 13:17:43 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C2361A4051;
        Wed, 19 Jan 2022 13:17:43 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4AA0FA405B;
        Wed, 19 Jan 2022 13:17:43 +0000 (GMT)
Received: from [9.171.58.182] (unknown [9.171.58.182])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 19 Jan 2022 13:17:43 +0000 (GMT)
Message-ID: <39c529db-e7bd-c216-62b7-773a51d919b6@linux.ibm.com>
Date:   Wed, 19 Jan 2022 14:17:43 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [RFC PATCH v1 06/10] KVM: s390: Add vm IOCTL for key checked
 guest absolute memory access
Content-Language: en-US
To:     Thomas Huth <thuth@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220118095210.1651483-1-scgl@linux.ibm.com>
 <20220118095210.1651483-7-scgl@linux.ibm.com>
 <a3a143f8-8fd5-49bf-9b2b-2f7cb04732de@redhat.com>
 <8d09dc2e-2d2d-e5f6-8cc7-eecfc94a17b2@linux.ibm.com>
 <cd79f893-c711-1a60-47d6-7c392e02fc6a@redhat.com>
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
In-Reply-To: <cd79f893-c711-1a60-47d6-7c392e02fc6a@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: yvTMf-0c37rLRgbaF5TrBD3nRBdpeSOa
X-Proofpoint-ORIG-GUID: j7bUy5w7TLbzcRNRXGAQcZe-G6khPu18
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-19_07,2022-01-19_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 malwarescore=0
 spamscore=0 mlxlogscore=999 impostorscore=0 suspectscore=0 clxscore=1015
 priorityscore=1501 adultscore=0 phishscore=0 lowpriorityscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201190075
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/19/22 13:53, Thomas Huth wrote:
> On 19/01/2022 13.46, Christian Borntraeger wrote:
>>
>>
>> Am 19.01.22 um 12:52 schrieb Thomas Huth:
>>> On 18/01/2022 10.52, Janis Schoetterl-Glausch wrote:
>>>> Channel I/O honors storage keys and is performed on absolute memory.
>>>> For I/O emulation user space therefore needs to be able to do key
>>>> checked accesses.
>>>
>>> Can't we do the checking in userspace? We already have functions for handling the storage keys there (see hw/s390x/s390-skeys-kvm.c), so why can't we do the checking in QEMU?
>>
>> That would separate the key check from the memory operation. Potentially for a long time.
>> Wenn we piggy back on access_guest_abs_with_key we use mvcos in the host and thus do the key check in lockstep with the keycheck which is the preferrable solution.
> 
> Ok, makes sense - Janis, could you please add this rationale to the patch description?

Will do.
> 
>  Thomas
> 

