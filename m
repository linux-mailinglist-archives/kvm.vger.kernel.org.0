Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70BF2493AA2
	for <lists+kvm@lfdr.de>; Wed, 19 Jan 2022 13:47:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350966AbiASMq5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jan 2022 07:46:57 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:35136 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S245463AbiASMqv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 19 Jan 2022 07:46:51 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20JAWUAn023804;
        Wed, 19 Jan 2022 12:46:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=+8DautfAf7BgVWzYAboFyiMn420308+cvph1666VKY4=;
 b=StEn+GryRyiQv8/0PP4AdNBdWIzQSDgvfphtJVTZwDZF46mJ4BY4evgtneKKmv9k1wyX
 zPI4ucFvMC9zVFlwopEQ1K6cxOJ15MBOQf9Dg++gSJ3MUMHWVXVlAXCmMHDX3OLd3iGK
 DhoDTJ+Zi0WpHMXRTzU5nsfJW07MejpDKIfF/l/uPn1fqrhPLO1IhhiCXH7Qry37m39k
 rVuOezMwzgNm+VVK2NRIMtuxE/bzcrnq2aEPytYuoHKrTCY05QbDksvAIMcmvRKPwU7K
 6nE5E/Imd+d9CwmykqiJr+Qb0qPNUYnuFd+NErNfAzyd636azGP/DDOMm8AvKDmwAmTd rA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dpe8wwwsv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Jan 2022 12:46:50 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20JCiJJ6026073;
        Wed, 19 Jan 2022 12:46:49 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dpe8wwws1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Jan 2022 12:46:49 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20JChinQ026495;
        Wed, 19 Jan 2022 12:46:47 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3dknw9de2s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Jan 2022 12:46:47 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20JCkiVj46072306
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Jan 2022 12:46:44 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5DC5142045;
        Wed, 19 Jan 2022 12:46:44 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8133742059;
        Wed, 19 Jan 2022 12:46:43 +0000 (GMT)
Received: from [9.171.34.112] (unknown [9.171.34.112])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 19 Jan 2022 12:46:43 +0000 (GMT)
Message-ID: <8d09dc2e-2d2d-e5f6-8cc7-eecfc94a17b2@linux.ibm.com>
Date:   Wed, 19 Jan 2022 13:46:43 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [RFC PATCH v1 06/10] KVM: s390: Add vm IOCTL for key checked
 guest absolute memory access
Content-Language: en-US
To:     Thomas Huth <thuth@redhat.com>,
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
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
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <a3a143f8-8fd5-49bf-9b2b-2f7cb04732de@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: bJpodnGc9-EjSFp9-feKh7OQTPh98REC
X-Proofpoint-GUID: J0iRc98eGf8GZ7Wrc_Yr8FV1QDO5siR-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-19_07,2022-01-19_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 phishscore=0
 clxscore=1015 impostorscore=0 malwarescore=0 priorityscore=1501
 adultscore=0 mlxscore=0 bulkscore=0 spamscore=0 lowpriorityscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201190072
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 19.01.22 um 12:52 schrieb Thomas Huth:
> On 18/01/2022 10.52, Janis Schoetterl-Glausch wrote:
>> Channel I/O honors storage keys and is performed on absolute memory.
>> For I/O emulation user space therefore needs to be able to do key
>> checked accesses.
> 
> Can't we do the checking in userspace? We already have functions for handling the storage keys there (see hw/s390x/s390-skeys-kvm.c), so why can't we do the checking in QEMU?

That would separate the key check from the memory operation. Potentially for a long time.
Wenn we piggy back on access_guest_abs_with_key we use mvcos in the host and thus do the key check in lockstep with the keycheck which is the preferrable solution.

I would also like to avoid reading guest storage keys via the ioctl that was done for migration in the I/O path just to do a single key check. This has peformance concerns.
