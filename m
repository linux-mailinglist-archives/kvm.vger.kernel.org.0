Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52AEA672262
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 17:04:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231252AbjARQD6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Jan 2023 11:03:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231140AbjARQDh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Jan 2023 11:03:37 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C959D56EF7
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 07:59:32 -0800 (PST)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30IFVRap026657;
        Wed, 18 Jan 2023 15:59:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Mgq/e1oJj8BQ1YPwC+oAOG+izgrUrBtQvmYoPRWcsfQ=;
 b=nheZmhYPS04ZGvb0p7oQSK+vsId2fP8sQRJeRKemYI+0IwfAjgthcL36n5UPDckD4W0h
 XWiHyQez7d7KzkFyOHwwfC2oMc+3fw2qEsAWytG0iJIaSBtyB9wKhdJ+2uu4xHxJbPap
 OpedeWB40B7Uo4D3y8ixyoBBOImAz09Kw4FhG/zzcq8mAaikksL5O3kY88PmDVG+cko+
 JMVuLWqoUKr28zCEmfNZQyrMeukb2/YQKFgOXkxRUXzkmfIPM0T8NQS+t2J+V5CML5xI
 15qDQ0lvQ5i8dR3YjBRbrfEGmJZJHyZi7gIuhbUEF5puhYsHAJDGB+hw07Fu1Rmnw3Cm DQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3n6f91ygs9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Jan 2023 15:59:27 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30IFbhNj004033;
        Wed, 18 Jan 2023 15:59:27 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3n6f91ygra-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Jan 2023 15:59:27 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30ICC7nl006282;
        Wed, 18 Jan 2023 15:59:25 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3n3knfngtr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Jan 2023 15:59:25 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30IFxLON44958152
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Jan 2023 15:59:21 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6259120043;
        Wed, 18 Jan 2023 15:59:21 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 138EB2004B;
        Wed, 18 Jan 2023 15:59:20 +0000 (GMT)
Received: from [9.179.13.15] (unknown [9.179.13.15])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 18 Jan 2023 15:59:19 +0000 (GMT)
Message-ID: <2c1681b2-05ef-6245-38ea-d2c363eb432e@linux.ibm.com>
Date:   Wed, 18 Jan 2023 16:59:19 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v14 09/11] qapi/s390/cpu topology: monitor query topology
 information
Content-Language: en-US
To:     Thomas Huth <thuth@redhat.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        scgl@linux.ibm.com, frankja@linux.ibm.com, berrange@redhat.com,
        clg@kaod.org
References: <20230105145313.168489-1-pmorel@linux.ibm.com>
 <20230105145313.168489-10-pmorel@linux.ibm.com>
 <114b34b1-303b-154b-6ac1-91e1718de49b@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <114b34b1-303b-154b-6ac1-91e1718de49b@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: w2rwQ_x6G8Rb0f2y6_zdNIdcli0SYTDG
X-Proofpoint-ORIG-GUID: 6-UShI331C0jbb3f9k1oLrDRMO5k0FTw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-18_05,2023-01-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 phishscore=0
 adultscore=0 clxscore=1015 impostorscore=0 malwarescore=0 mlxlogscore=999
 bulkscore=0 spamscore=0 priorityscore=1501 lowpriorityscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301180130
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/12/23 12:48, Thomas Huth wrote:
> On 05/01/2023 15.53, Pierre Morel wrote:
>> Reporting the current topology informations to the admin through
>> the QEMU monitor.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
> ...
>> diff --git a/hmp-commands-info.hx b/hmp-commands-info.hx
>> index 754b1e8408..5730a47f71 100644
>> --- a/hmp-commands-info.hx
>> +++ b/hmp-commands-info.hx
>> @@ -993,3 +993,19 @@ SRST
>>     ``info virtio-queue-element`` *path* *queue* [*index*]
>>       Display element of a given virtio queue
>>   ERST
>> +
>> +#if defined(TARGET_S390X) && defined(CONFIG_KVM)
>> +    {
>> +        .name       = "query-topology",
>> +        .args_type  = "",
>> +        .params     = "",
>> +        .help       = "Show information about CPU topology",
>> +        .cmd        = hmp_query_topology,
>> +        .flags      = "p",
>> +    },
>> +
>> +SRST
>> +  ``info query-topology``
> 
> "info query-topology" sounds weird ... I'd maybe rather call it only 
> "info topology" or "info cpu-topology" here.

info cpu-topology looks good for me.

thanks.

Regards,
Pierre

> 
>   Thomas
> 
> 
>> +    Show information about CPU topology
>> +ERST
>> +#endif
> 

-- 
Pierre Morel
IBM Lab Boeblingen
