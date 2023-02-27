Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A655D6A43F4
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 15:14:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230271AbjB0OOP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 09:14:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbjB0OOO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 09:14:14 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86E936A71
        for <kvm@vger.kernel.org>; Mon, 27 Feb 2023 06:14:13 -0800 (PST)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31RDBn0t027845;
        Mon, 27 Feb 2023 14:14:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=A0eoKE6J3qEYP7UYfilg0FoI800/L+uAJOG7QUUhClk=;
 b=GVTTm6rom/kDv9eXL09y73qLcVluyg3nmINprun0Fhhg8ueezpBuQNBkdy4bC9ZVmv1m
 yjhjp/SAXkdjztYIqE5nVsRDFivxAiud3k+LaZxOjp0Dg9riit7QfvV7UJkcIn/e2u6p
 chwuou5De87ILFgJL9Qb5PyMmGdT8az4JCIG77GKygGzyI0gyzRaNr0Jh4ThRVXUpUsP
 rkjL7/xzEINLyea1puuTll9YozHg3dkbulevpmycMA3GPODMNOu8kOkc/MfMrqnKax5B
 cVZH4x3NluYcRU3FKfiB2ybu6j8WMVERVgZy8VRTtBXGPpvL/71L3kqnF50PUhzqfhRk /A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3p0sg47ux5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Feb 2023 14:14:02 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 31REAhUB004888;
        Mon, 27 Feb 2023 14:14:02 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3p0sg47uvw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Feb 2023 14:14:02 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31R0Rdfx022793;
        Mon, 27 Feb 2023 14:13:59 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma04fra.de.ibm.com (PPS) with ESMTPS id 3nybab1g0y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Feb 2023 14:13:59 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 31REDtPS30081444
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Feb 2023 14:13:55 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 97E6B2004B;
        Mon, 27 Feb 2023 14:13:55 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3C7E120043;
        Mon, 27 Feb 2023 14:13:54 +0000 (GMT)
Received: from [9.171.14.212] (unknown [9.171.14.212])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Mon, 27 Feb 2023 14:13:54 +0000 (GMT)
Message-ID: <9907f93a-c22e-164d-2024-068f24c22944@linux.ibm.com>
Date:   Mon, 27 Feb 2023 15:13:53 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v16 09/11] machine: adding s390 topology to query-cpu-fast
Content-Language: en-US
To:     Thomas Huth <thuth@redhat.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        nsg@linux.ibm.com, frankja@linux.ibm.com, berrange@redhat.com,
        clg@kaod.org
References: <20230222142105.84700-1-pmorel@linux.ibm.com>
 <20230222142105.84700-10-pmorel@linux.ibm.com>
 <6db3c0bd-ce65-1d23-ca6c-ee4a6fb60dbf@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <6db3c0bd-ce65-1d23-ca6c-ee4a6fb60dbf@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: k-Uq-8FYx6ISuGzKvHsM7R7k78zg_PdJ
X-Proofpoint-GUID: FgdJejd2A7vo2yb0ytJSyx8yLw08_D0i
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-27_10,2023-02-27_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 lowpriorityscore=0 suspectscore=0 impostorscore=0 adultscore=0 spamscore=0
 mlxscore=0 mlxlogscore=999 malwarescore=0 clxscore=1015 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302270109
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2/27/23 14:27, Thomas Huth wrote:
> On 22/02/2023 15.21, Pierre Morel wrote:
>> S390x provides two more topology attributes, entitlement and dedication.
>>
>> Let's add these CPU attributes to the QAPI command query-cpu-fast.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> Reviewed-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
>> ---
>>   qapi/machine.json          | 9 ++++++++-
>>   hw/core/machine-qmp-cmds.c | 2 ++
>>   2 files changed, 10 insertions(+), 1 deletion(-)
>
> Reviewed-by: Thomas Huth <thuth@redhat.com>
>
>
Thanks.

Regards,

Pierre

