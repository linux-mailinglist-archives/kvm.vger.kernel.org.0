Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11CA8533840
	for <lists+kvm@lfdr.de>; Wed, 25 May 2022 10:19:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231907AbiEYITm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 May 2022 04:19:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232083AbiEYIT3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 May 2022 04:19:29 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 915AF81998
        for <kvm@vger.kernel.org>; Wed, 25 May 2022 01:19:28 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24P7wRiH018923;
        Wed, 25 May 2022 08:19:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=NF766i3z15BznnjM0FGB0nFCopBSkoTnLXK7IWsNlXc=;
 b=C2AOOfWlejMAt+njGbn7lBozA7Y5ZFs3h7M8ObT01jojxWeWmTV8SeVoEDZT/+baiz82
 XKJlu/PL4Ut7K6ms0gnpJVXIYdjdWlo4/UqKhoumbjjNQT+Aa2yT2EIl1/mgZISDSrU6
 f6ktnBEe27WZBUYlNkN+wp7/J4a4TUKAwT8jr0BFWG6+/WEcxj8ojriNHfyFTEeMIJjq
 IYRRBHVPNSWHOJbBUkkQwVaQPUg7Dk2QJWzRslfn4RKognno5GDY3bczzzmROVZWX8cX
 JvU4EX9Rb4IF6nuuwj0OcyuDuLSp+dVSu9wEoOowBG0++XC8gspM6Q2F1iP83d5Dbrvl XQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g9ghc8dx3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 May 2022 08:19:20 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24P80VtE029810;
        Wed, 25 May 2022 08:19:20 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g9ghc8dwh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 May 2022 08:19:19 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24P8Ie1o016920;
        Wed, 25 May 2022 08:19:17 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 3g93v00su3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 May 2022 08:19:17 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24P856nT41091454
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 May 2022 08:05:06 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 68935A4051;
        Wed, 25 May 2022 08:19:14 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6ADE6A4040;
        Wed, 25 May 2022 08:19:13 +0000 (GMT)
Received: from [9.171.31.97] (unknown [9.171.31.97])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 25 May 2022 08:19:13 +0000 (GMT)
Message-ID: <098642a0-5518-49b7-69c1-2d6bea9885a5@linux.ibm.com>
Date:   Wed, 25 May 2022 10:23:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v7 12/13] s390x: CPU topology: CPU topology migration
Content-Language: en-US
To:     Thomas Huth <thuth@redhat.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        frankja@linux.ibm.com
References: <20220420115745.13696-1-pmorel@linux.ibm.com>
 <20220420115745.13696-13-pmorel@linux.ibm.com>
 <3d9badda-6939-9ea0-5554-ba15c0c0cb02@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <3d9badda-6939-9ea0-5554-ba15c0c0cb02@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 0D21uRFN4bgoTsofKhWEWqyO_G6v7L5U
X-Proofpoint-GUID: UjmHR5toyY5HKq37pPWaVw8GV80XvOlX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-25_02,2022-05-23_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 priorityscore=1501 bulkscore=0 phishscore=0 mlxlogscore=999 clxscore=1015
 malwarescore=0 suspectscore=0 adultscore=0 lowpriorityscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2205250037
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/24/22 13:32, Thomas Huth wrote:
> On 20/04/2022 13.57, Pierre Morel wrote:
>> To migrate the Multiple Topology Change report, MTCR, we
>> get it from KVM and save its state in the topology VM State
>> Description during the presave and restore it to KVM on the
>> destination during the postload.
>>
>> The migration state is needed whenever the CPU topology
>> feature is activated.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
> ...
>> @@ -2592,22 +2594,57 @@ static void kvm_s390_set_mtr(uint64_t attr)
>>           .group = KVM_S390_VM_CPU_TOPOLOGY,
>>           .attr  = attr,
>>       };
>> +    int ret;
>> -    int ret = kvm_vm_ioctl(kvm_state, KVM_SET_DEVICE_ATTR, &attribute);
>> -
>> +    ret = kvm_vm_ioctl(kvm_state, KVM_SET_DEVICE_ATTR, &attribute);
> 
> Nit: Unnecessary code churn.

yes thanks,
Pierre

> 
>   Thomas
> 

-- 
Pierre Morel
IBM Lab Boeblingen
