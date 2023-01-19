Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9287673A67
	for <lists+kvm@lfdr.de>; Thu, 19 Jan 2023 14:35:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231319AbjASNfP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 08:35:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231330AbjASNex (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 08:34:53 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F1BD7CCC6
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 05:34:45 -0800 (PST)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30JDNM1f015544;
        Thu, 19 Jan 2023 13:34:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=u7PwhI96zAPH6paupPgFqDaMVwUj55T7rCg/Wd2A7Yc=;
 b=bAQtNcFH5M16s2DHm6scYE9NRHBRV4urWk97NqkJaexB5HsfHL05tJyRRKJChKAEUB8c
 gbuyM5srfQh0mghlm/RqKvj16BXDG6lZAWLfuIauzpDpI13LWHk7lFyjRRqr40EdF0FJ
 trzd5hsvOnXmzfeKSZf7V53mOUGCSDGl3aUSCc9WeZDDpb6NIh8vJyo1j+7ZHG/2JYV+
 Xjoi6vV8y9/QJFBKTMkelorUvH7s1m11iSSayM6kuTLifeYanAFkyPQnH8WZzpzaBnFX
 cml2NbyvT/mDry/KA+Y3Sg+sjvV1R9V3z6/2ppOmzY1S118rXPoNudZfjNo528GoLx6A ZQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n76pug9a1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Jan 2023 13:34:37 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30JDPjwl022780;
        Thu, 19 Jan 2023 13:34:37 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n76pug98p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Jan 2023 13:34:37 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30J6fuAN006223;
        Thu, 19 Jan 2023 13:34:34 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3n3knfpr5w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Jan 2023 13:34:34 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30JDYUgL23397082
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Jan 2023 13:34:30 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8628120040;
        Thu, 19 Jan 2023 13:34:30 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0A22E20065;
        Thu, 19 Jan 2023 13:34:30 +0000 (GMT)
Received: from [9.152.224.248] (unknown [9.152.224.248])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 19 Jan 2023 13:34:29 +0000 (GMT)
Message-ID: <f78d2d52-33eb-2705-b570-a73f46d8b09f@linux.ibm.com>
Date:   Thu, 19 Jan 2023 14:34:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v14 02/11] s390x/cpu topology: add topology entries on CPU
 hotplug
Content-Language: en-US
To:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com,
        berrange@redhat.com, clg@kaod.org
References: <20230105145313.168489-1-pmorel@linux.ibm.com>
 <20230105145313.168489-3-pmorel@linux.ibm.com>
 <666b9711b23d807525be06992fffd4d782ee80c7.camel@linux.ibm.com>
 <8063592a-971a-d029-e8ac-0fb6286199d5@linux.ibm.com>
 <13ad4df8bc83f552ae1c9aad4f1a44d18963e7a8.camel@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <13ad4df8bc83f552ae1c9aad4f1a44d18963e7a8.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: vWP_vJJenJ0Gemc-_eTxtYn4Z1dN98Kl
X-Proofpoint-GUID: nkmEVxlxV74uVeYvj8k3kwEE1kAJpy3T
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-19_09,2023-01-19_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 mlxscore=0
 adultscore=0 lowpriorityscore=0 bulkscore=0 impostorscore=0
 priorityscore=1501 phishscore=0 clxscore=1015 spamscore=0 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301190108
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/17/23 17:48, Nina Schoetterl-Glausch wrote:
> On Tue, 2023-01-17 at 14:55 +0100, Pierre Morel wrote:
>>
>> On 1/13/23 19:15, Nina Schoetterl-Glausch wrote:
>>>
> [...]
> 
>>>> +/**
>>>> + * s390_topology_set_entry:
>>>> + * @entry: Topology entry to setup
>>>> + * @id: topology id to use for the setup
>>>> + *
>>>> + * Set the core bit inside the topology mask and
>>>> + * increments the number of cores for the socket.
>>>> + */
>>>> +static void s390_topology_set_entry(S390TopologyEntry *entry,
>>>
>>> Not sure if I like the name, what it does is to add a cpu to the entry.
>>
>> s390_topology_add_cpu_to_entry() ?
> 
> Yeah, that's better.
> 
> [...]
>>
>>>> +/**
>>>> + * s390_topology_set_cpu:
>>>> + * @ms: MachineState used to initialize the topology structure on
>>>> + *      first call.
>>>> + * @cpu: the new S390CPU to insert in the topology structure
>>>> + * @errp: the error pointer
>>>> + *
>>>> + * Called from CPU Hotplug to check and setup the CPU attributes
>>>> + * before to insert the CPU in the topology.
>>>> + */
>>>> +void s390_topology_set_cpu(MachineState *ms, S390CPU *cpu, Error **errp)
>>>> +{
>>>> +    Error *local_error = NULL;
>>>
>>> Can't you just use ERRP_GUARD ?
>>
>> I do not think it is necessary and I find it obfuscating.
>> So, should I?
> 
> /*
>   * Propagate error object (if any) from @local_err to @dst_errp.
> [...]
>   * Please use ERRP_GUARD() instead when possible.
>   * Please don't error_propagate(&error_fatal, ...), use
>   * error_report_err() and exit(), because that's more obvious.
>   */
> void error_propagate(Error **dst_errp, Error *local_err);
> 
> So I'd say yes.

OK, you are right it is better.

Regards,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
