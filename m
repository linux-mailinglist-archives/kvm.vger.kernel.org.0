Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7839E6F54DD
	for <lists+kvm@lfdr.de>; Wed,  3 May 2023 11:36:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbjECJgj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 May 2023 05:36:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbjECJgi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 May 2023 05:36:38 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B8AF46B3
        for <kvm@vger.kernel.org>; Wed,  3 May 2023 02:36:37 -0700 (PDT)
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3439X686008171;
        Wed, 3 May 2023 09:36:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=TrOOtjhmh4uul4jQ9Ttlommm9nzSTgkTVXHAfVFAHYo=;
 b=fvbshatYRHAJ3JMSoB+JJxy+BUeQZGTW4Guw/kYwud8p1Z33GaiASbiHalvD6IdG5Qar
 RpEB5OvlrCFs8QJntjxzkopYwZW/6EmVxN14CLKKCJ0vFRaNGWndJvD/b5GC/D71L0Hi
 eI+5f2+l44rXqxEs2ghqWThrhsnTfEWFRqjUl7kxWjqVOz5UXVJiZ8gk48cAh8mHBDda
 ZyRbBv6I+/+fb9SYEMScG350ANOpEF8OGV9EwJW3rOC5MUJN+YPJyJkk0xldu36H819u
 AgjyMSLrWFFokmRomXgIsNtbpaZZqTwNbL/n2uI+8jKs5iY86R55qjr1h1Bdh2YDguiI cA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qbkx3a6v9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 May 2023 09:36:25 +0000
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3439XCgx008812;
        Wed, 3 May 2023 09:36:25 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qbkx3a6sw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 May 2023 09:36:24 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 34317qTN014603;
        Wed, 3 May 2023 09:36:22 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3q8tv6t3vu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 May 2023 09:36:22 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3439aG3d49283538
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 3 May 2023 09:36:16 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 109102004D;
        Wed,  3 May 2023 09:36:16 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 451A620043;
        Wed,  3 May 2023 09:36:15 +0000 (GMT)
Received: from [9.152.222.242] (unknown [9.152.222.242])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Wed,  3 May 2023 09:36:15 +0000 (GMT)
Message-ID: <47e3a077-0819-e88b-bc49-a580c8939350@linux.ibm.com>
Date:   Wed, 3 May 2023 11:36:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v20 01/21] s390x/cpu topology: add s390 specifics to CPU
 topology
Content-Language: en-US
To:     Thomas Huth <thuth@redhat.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        nsg@linux.ibm.com, frankja@linux.ibm.com, berrange@redhat.com,
        clg@kaod.org
References: <20230425161456.21031-1-pmorel@linux.ibm.com>
 <20230425161456.21031-2-pmorel@linux.ibm.com>
 <45e09800-6a47-0372-5244-16e2dc72370d@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <45e09800-6a47-0372-5244-16e2dc72370d@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: kxNuhWfpfc55-suvSf89tRh955ZfGVPu
X-Proofpoint-ORIG-GUID: _jywnGNfORLEtzagmeCO0F8mF-xOn_-5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-03_05,2023-04-27_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 bulkscore=0 clxscore=1015 impostorscore=0 lowpriorityscore=0
 mlxlogscore=999 mlxscore=0 spamscore=0 phishscore=0 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2305030075
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/27/23 10:04, Thomas Huth wrote:
> On 25/04/2023 18.14, Pierre Morel wrote:
>> S390 adds two new SMP levels, drawers and books to the CPU
>> topology.
>> The S390 CPU have specific topology features like dedication
>> and entitlement to give to the guest indications on the host
>> vCPUs scheduling and help the guest take the best decisions
>> on the scheduling of threads on the vCPUs.
>>
>> Let us provide the SMP properties with books and drawers levels
>> and S390 CPU with dedication and entitlement,
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>


[...]


>>   {
>>       MachineClass *mc = MACHINE_GET_CLASS(ms);
>>       unsigned cpus    = config->has_cpus ? config->cpus : 0;
>> +    unsigned drawers = config->has_drawers ? config->drawers : 0;
>> +    unsigned books   = config->has_books ? config->books : 0;
>>       unsigned sockets = config->has_sockets ? config->sockets : 0;
>>       unsigned dies    = config->has_dies ? config->dies : 0;
>>       unsigned clusters = config->has_clusters ? config->clusters : 0;
>> @@ -85,6 +98,8 @@ void machine_parse_smp_config(MachineState *ms,
>>        * explicit configuration like "cpus=0" is not allowed.
>>        */
>>       if ((config->has_cpus && config->cpus == 0) ||
>> +        (config->has_drawers && config->drawers == 0) ||
>> +        (config->has_books && config->books == 0) ||
>>           (config->has_sockets && config->sockets == 0) ||
>>           (config->has_dies && config->dies == 0) ||
>>           (config->has_clusters && config->clusters == 0) ||
>> @@ -111,6 +126,19 @@ void machine_parse_smp_config(MachineState *ms,
>>       dies = dies > 0 ? dies : 1;
>>       clusters = clusters > 0 ? clusters : 1;
>>   +    if (!mc->smp_props.books_supported && books > 1) {
>> +        error_setg(errp, "books not supported by this machine's CPU 
>> topology");
>> +        return;
>> +    }
>> +    books = books > 0 ? books : 1;
>
> Could be shortened to:  book = books ?: 1;
>
More thinking about this, all other existing assignments are done so, 
clusters, dies, sockets, cores and threads.

to keep the core consistent shouldn't we keep it the same way?

Regards,

Pierre


