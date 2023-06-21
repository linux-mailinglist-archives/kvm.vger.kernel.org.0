Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CE56738416
	for <lists+kvm@lfdr.de>; Wed, 21 Jun 2023 14:51:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231857AbjFUMvW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jun 2023 08:51:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbjFUMvV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Jun 2023 08:51:21 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86DAF1717
        for <kvm@vger.kernel.org>; Wed, 21 Jun 2023 05:51:20 -0700 (PDT)
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35LClHLA001975;
        Wed, 21 Jun 2023 12:50:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=YB4kzhv/xpKSXoMnzqgu79e1KIJL1KKrkd2UB7OvKiU=;
 b=iZpCWJkzkYh6LqLxjOMMll9imU3lEvPSoqU1bfdq8D0xXOZDUC0ahCiasfq0sn4FM5YW
 PkPVo8xK2s6TkGz/ljvhMrlEvcmKU7jBsl+DKh36GSdyn8POkbLSaz7rst2qWQb8eFbT
 7GdofbswvC8ZZUwiZrqYZ5xT51bUtK44vL46MvWG4Wfn6wdKtAy3Z8r+4V3mMrkFQDxQ
 pK5y55AOopaPHO/KEoVSqz8F0vLuKj0Lu0DRx+ne35Z9lZPZQj9M3lhUvCZ1KUda6aPh
 HM7djmxCDYB3BpvXV7GAosaZwiN75DVBUo8GZknQYHtoSHRfAbruc5VzFidbvOqQnpE4 7A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rc1gw02pa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Jun 2023 12:50:34 +0000
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 35LCliLO002709;
        Wed, 21 Jun 2023 12:50:33 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rc1gw02my-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Jun 2023 12:50:33 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 35LChIH5018300;
        Wed, 21 Jun 2023 12:50:31 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3r94f5arvy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Jun 2023 12:50:31 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 35LCoP6a13501038
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Jun 2023 12:50:25 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4A7F62004B;
        Wed, 21 Jun 2023 12:50:25 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EA1CF2004E;
        Wed, 21 Jun 2023 12:50:24 +0000 (GMT)
Received: from [9.152.222.242] (unknown [9.152.222.242])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Wed, 21 Jun 2023 12:50:24 +0000 (GMT)
Message-ID: <ee80dd30-08cf-476e-028b-b93e489a502c@linux.ibm.com>
Date:   Wed, 21 Jun 2023 14:50:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v20 09/21] machine: adding s390 topology to query-cpu-fast
Content-Language: en-US
To:     =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>,
        qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com,
        frankja@linux.ibm.com, berrange@redhat.com
References: <20230425161456.21031-1-pmorel@linux.ibm.com>
 <20230425161456.21031-10-pmorel@linux.ibm.com>
 <14168a66-38ba-82e6-08d2-830f6216b4e1@kaod.org>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <14168a66-38ba-82e6-08d2-830f6216b4e1@kaod.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: eUbnt1RKx-csockpGbOgCT98DYauoT2V
X-Proofpoint-GUID: EtcnIg1RvE6kX58-wZ7AKCGRDeR220MS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-06-21_08,2023-06-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 adultscore=0
 malwarescore=0 lowpriorityscore=0 bulkscore=0 impostorscore=0
 suspectscore=0 spamscore=0 priorityscore=1501 phishscore=0 mlxlogscore=999
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306210105
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 6/12/23 09:55, Cédric Le Goater wrote:
> Hello Pierre,
>
> On 4/25/23 18:14, Pierre Morel wrote:
>> S390x provides two more topology attributes, entitlement and dedication.
>>
>> Let's add these CPU attributes to the QAPI command query-cpu-fast.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> Reviewed-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
>> Reviewed-by: Thomas Huth <thuth@redhat.com>
>> ---
>>   qapi/machine.json          | 9 ++++++++-
>>   hw/core/machine-qmp-cmds.c | 2 ++
>>   2 files changed, 10 insertions(+), 1 deletion(-)
>>
>> diff --git a/qapi/machine.json b/qapi/machine.json
>> index 1cdd83f3fd..c6a12044e0 100644
>> --- a/qapi/machine.json
>> +++ b/qapi/machine.json
>> @@ -55,10 +55,17 @@
>>   # Additional information about a virtual S390 CPU
>>   #
>>   # @cpu-state: the virtual CPU's state
>> +# @dedicated: the virtual CPU's dedication (since 8.1)
>> +# @entitlement: the virtual CPU's entitlement (since 8.1)
>>   #
>>   # Since: 2.12
>>   ##
>> -{ 'struct': 'CpuInfoS390', 'data': { 'cpu-state': 'CpuS390State' } }
>> +{ 'struct': 'CpuInfoS390',
>> +  'data': { 'cpu-state': 'CpuS390State',
>> +            'dedicated': 'bool',
>> +            'entitlement': 'CpuS390Entitlement'
>> +  }
>> +}
>>     ##
>>   # @CpuInfoFast:
>> diff --git a/hw/core/machine-qmp-cmds.c b/hw/core/machine-qmp-cmds.c
>> index b98ff15089..3f35ed83a6 100644
>> --- a/hw/core/machine-qmp-cmds.c
>> +++ b/hw/core/machine-qmp-cmds.c
>> @@ -35,6 +35,8 @@ static void cpustate_to_cpuinfo_s390(CpuInfoS390 
>> *info, const CPUState *cpu)
>>       CPUS390XState *env = &s390_cpu->env;
>>         info->cpu_state = env->cpu_state;
>> +    info->dedicated = env->dedicated;
>> +    info->entitlement = env->entitlement;
>
> When you resend, please protect these assignments with :
>
>  #if !defined(CONFIG_USER_ONLY)
>
> Thanks,
>
> C.


Hello Cedric,

Yes, thanks.

(I though I already answered but can not find a trace of it)

Regards,

Pierre


