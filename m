Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FF6D5AD6BF
	for <lists+kvm@lfdr.de>; Mon,  5 Sep 2022 17:43:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238021AbiIEPnN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Sep 2022 11:43:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229971AbiIEPnL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Sep 2022 11:43:11 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6AB243337
        for <kvm@vger.kernel.org>; Mon,  5 Sep 2022 08:43:10 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 285EntfM009612;
        Mon, 5 Sep 2022 15:43:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=z7NdskQLXfqN3Sh/ccSTcSVSC5wwLtUT1rBKo15VAoo=;
 b=e9QALkkx733eLnD2XlSQWRUwfePLXNhY6Z99MlA+9kOZmDrQLIt8WActZvEXlIjom/FS
 jfrNQTB5LbflKgXU372flsFXJtLvIkVZSWmruYUu8iSejZRyIPUDbLK1eYGklA06mRwz
 wcdC/5/SNCUUFktl6vI98+WYJK0bC0yghxzjtsiR7oYmyqEqOpuJyP/txcew523F++VZ
 GGyGpnhwMzXlTs5FpaCEP35p7+/LmWbX8hMPv4sD/M/bYZ77XDaOEaVlIhXb7aUe0dbp
 VXuEO6WawBFC3Ah9XoEM39uBM4eCNq17w8a8zWGZDTQifeLvg2/3u7jVoyX58LJDxhgU ig== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jdk7ksm35-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Sep 2022 15:43:04 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 285FPhGV029509;
        Mon, 5 Sep 2022 15:43:03 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jdk7ksm1q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Sep 2022 15:43:03 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 285FdNJK013321;
        Mon, 5 Sep 2022 15:43:01 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3jbxj8tn25-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Sep 2022 15:43:00 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 285Fgvvq38338916
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 5 Sep 2022 15:42:57 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AF70952050;
        Mon,  5 Sep 2022 15:42:57 +0000 (GMT)
Received: from [9.171.61.194] (unknown [9.171.61.194])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 5DC225204F;
        Mon,  5 Sep 2022 15:42:55 +0000 (GMT)
Message-ID: <e15aaa1d-9123-61dd-6531-4cdbe84053ec@linux.ibm.com>
Date:   Mon, 5 Sep 2022 17:42:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v9 01/10] s390x/cpus: Make absence of multithreading clear
Content-Language: en-US
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, frankja@linux.ibm.com
References: <20220902075531.188916-1-pmorel@linux.ibm.com>
 <20220902075531.188916-2-pmorel@linux.ibm.com>
 <166237756810.5995.16085197397341513582@t14-nrb>
 <c394823e-edd5-a722-486f-438e5fba2c9d@linux.ibm.com>
 <6d779ae286bd24a76e6cc4b2cc4dcaafdf9acf75.camel@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <6d779ae286bd24a76e6cc4b2cc4dcaafdf9acf75.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: LzhIQBJiguEPuFDl9XgcJg7G_fRL-Baq
X-Proofpoint-ORIG-GUID: _C-lRDwT1ygLhXIoDdWLrE-i3ZafzoMj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-05_12,2022-09-05_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 impostorscore=0 lowpriorityscore=0 mlxscore=0
 priorityscore=1501 clxscore=1015 bulkscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2209050075
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 9/5/22 17:23, Janis Schoetterl-Glausch wrote:
> On Mon, 2022-09-05 at 17:10 +0200, Pierre Morel wrote:
>>
>> On 9/5/22 13:32, Nico Boehr wrote:
>>> Quoting Pierre Morel (2022-09-02 09:55:22)
>>>> S390x do not support multithreading in the guest.
>>>> Do not let admin falsely specify multithreading on QEMU
>>>> smp commandline.
>>>>
>>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>>>> ---
>>>>    hw/s390x/s390-virtio-ccw.c | 3 +++
>>>>    1 file changed, 3 insertions(+)
>>>>
>>>> diff --git a/hw/s390x/s390-virtio-ccw.c b/hw/s390x/s390-virtio-ccw.c
>>>> index 70229b102b..b5ca154e2f 100644
>>>> --- a/hw/s390x/s390-virtio-ccw.c
>>>> +++ b/hw/s390x/s390-virtio-ccw.c
>>>> @@ -86,6 +86,9 @@ static void s390_init_cpus(MachineState *machine)
>>>>        MachineClass *mc = MACHINE_GET_CLASS(machine);
>>>>        int i;
>>>>    
>>>> +    /* Explicitely do not support threads */
>>>             ^
>>>             Explicitly
>>>
>>>> +    assert(machine->smp.threads == 1);
>>>
>>> It might be nicer to give a better error message to the user.
>>> What do you think about something like (broken whitespace ahead):
>>>
>>>       if (machine->smp.threads != 1) {if (machine->smp.threads != 1) {
>>>           error_setg(&error_fatal, "More than one thread specified, but multithreading unsupported");
>>>           return;
>>>       }
>>>
>>
>>
>> OK, I think I wanted to do this and I changed my mind, obviously, I do
>> not recall why.
>> I will do almost the same but after a look at error.h I will use
>> error_report()/exit() instead of error_setg()/return as in:
>>
>>
>> +    /* Explicitly do not support threads */
>> +    if (machine->smp.threads != 1) {
>> +        error_report("More than one thread specified, but
>> multithreading unsupported");
>> +        exit(1);
>> +    }
> 
> I agree that an assert is not a good solution, and I'm not sure
> aborting is a good idea either.
> I'm assuming that currently if you specify threads > 0 qemu will run
> with the number of CPUs multiplied by threads (compared to threads=1).
> If that is true, then a new qemu version will break existing
> invocations.
> 
> An alternative would be to print a warning and do:
> cores *= threads
> threads = 1
> 
> The questions would be what the best place to do that is.
> I guess we'd need a new compat variable if that's done in machine-smp.c

Right, I think we can use the new "topology_disable" machine property.


>>
>>
>> Thanks,
>>
>> Regards,
>> Pierre
>>
> 

-- 
Pierre Morel
IBM Lab Boeblingen
