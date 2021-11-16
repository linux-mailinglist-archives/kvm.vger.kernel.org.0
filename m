Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D253453190
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 12:57:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235701AbhKPMAl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 07:00:41 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:16072 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235706AbhKPMA1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Nov 2021 07:00:27 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AGAtM3Q000623;
        Tue, 16 Nov 2021 11:57:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=kgenKM1z3Re+ayfQBXdGzVLkvYkWFHY1JFSryHJKH3I=;
 b=hbCUOs4+g0Li8mzIYs6qwNNxL73xpRicdVZQf1pIX0Mb2F+EDH0BmNa2ldjYYe5CMaZu
 6SbEt16PJsv+I5s438VvoSmpBoGJ+35FhGJgjI5O7NWHOzRDTlnqjgBl9uP1OQHEQcTc
 bTlwk7gMtHlld1OaKF8MlE9rsm3+EHxPK0ix8YpV9a0L6Pz849CaLnNiozNd/hGfVyzb
 3DhXKOOEa6OKnh/+kPRjLnS8IzMen4/QUaY+ZnqCOwsEG0j/O5nnE8rz9DZSc9Q6q5gQ
 39OPJ+Xgc/O8xoZa5SXzPzWacVr223iwvLaN/gEPrdFBc67rDbok0WS2YA78f2qiwpUJ 5A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ccbanhcc1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Nov 2021 11:57:30 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1AGBRZh9014829;
        Tue, 16 Nov 2021 11:57:29 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ccbanhcbk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Nov 2021 11:57:29 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1AGBmtFS017486;
        Tue, 16 Nov 2021 11:57:27 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3ca50axx96-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Nov 2021 11:57:27 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1AGBoR0V57016694
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Nov 2021 11:50:27 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5F13C11C04A;
        Tue, 16 Nov 2021 11:57:22 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 10EE611C05E;
        Tue, 16 Nov 2021 11:57:22 +0000 (GMT)
Received: from [9.171.66.108] (unknown [9.171.66.108])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 16 Nov 2021 11:57:21 +0000 (GMT)
Message-ID: <ce3407fd-3745-c569-6ba8-d599e0d7c905@linux.vnet.ibm.com>
Date:   Tue, 16 Nov 2021 12:57:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [kvm-unit-tests PATCH v3 1/1] s390x: Add specification exception
 interception test
Content-Language: en-US
To:     Thomas Huth <thuth@redhat.com>,
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Janosch Frank <frankja@de.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20211022131057.1308851-1-scgl@linux.ibm.com>
 <20211022131057.1308851-2-scgl@linux.ibm.com>
 <82750b44-6246-3f3c-4562-3d64d7378448@redhat.com>
From:   Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>
In-Reply-To: <82750b44-6246-3f3c-4562-3d64d7378448@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: AY9QDdTSyg-RMKTBeBF6oHWSNP2yPyR2
X-Proofpoint-GUID: 89Qt1hCWWYmGeDbaMLGb1yp5EbyrXlw1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-16_01,2021-11-16_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 mlxlogscore=999 bulkscore=0 phishscore=0 adultscore=0 priorityscore=1501
 suspectscore=0 impostorscore=0 malwarescore=0 lowpriorityscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111160059
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/11/21 08:47, Thomas Huth wrote:
> On 22/10/2021 15.10, Janis Schoetterl-Glausch wrote:
>> Check that specification exceptions cause intercepts when
>> specification exception interpretation is off.
>> Check that specification exceptions caused by program new PSWs
>> cause interceptions.
>> We cannot assert that non program new PSW specification exceptions
>> are interpreted because whether interpretation occurs or not is
>> configuration dependent.
>>
>> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
>> Reviewed-by: Janosch Frank <frankja@de.ibm.com>
>> Reviewed-by: Thomas Huth <thuth@redhat.com>
>> ---
> ...
>> +    report_prefix_push("on");
>> +    vm.sblk->ecb |= ECB_SPECI;
>> +    reset_guest();
>> +    sie(&vm);
>> +    /* interpretation on -> configuration dependent if initial exception causes
>> +     * interception, but invalid new program PSW must
>> +     */
>> +    report(vm.sblk->icptcode == ICPT_PROGI
>> +           && vm.sblk->iprcc == PGM_INT_CODE_SPECIFICATION,
>> +           "Received specification exception intercept");
>> +    if (vm.sblk->gpsw.addr == 0xdeadbeee)
>> +        report_info("Interpreted initial exception, intercepted invalid program new PSW exception");
>> +    else
>> +        report_info("Did not interpret initial exception");
> 
>  Hi Janis!
> 
> While using this test in our downstream verification of the backport of the related kernel patch, it occurred that the way of only reporting the interpreted exception via report_info() is rather unfortunate for using this test in automatic regression runs. For such regression runs, it would be good if the test would be marked with FAIL if the exception was not interpreted. I know, the interpretation facility is not always there, but still would it be somehow possible to add such a mode? E.g. by checking the machine generation (is this always available with z15 and newer?) and maybe adding a CLI option to force the hard check (so that e.g. "-f" triggers the failure if the exception has not been interpreted, while running the test without "-f" would still do the old behavior instead)?
> 
>  Thomas
> 
Sounds good, I'll look into it.
