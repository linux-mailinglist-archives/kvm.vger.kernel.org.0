Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 242BC66C8FC
	for <lists+kvm@lfdr.de>; Mon, 16 Jan 2023 17:45:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233754AbjAPQpf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Jan 2023 11:45:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233757AbjAPQo5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Jan 2023 11:44:57 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7438D3FF31
        for <kvm@vger.kernel.org>; Mon, 16 Jan 2023 08:32:16 -0800 (PST)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30GFDiGs026129;
        Mon, 16 Jan 2023 16:32:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=tVI9EAsN9kaytG1g3mmpmWp4KiinemPMHgTulbCO3AM=;
 b=SGGeayAidXksdFboCzlm9ppCrwM99bGxaerWgIOM6b4LAX5divNdAf3POFX+jSLycgHX
 iVhMxU/gV7KiBl1H0VBLtADvnNqJP0pmopx10wSZClPJMHAOz9bS1TE6TtSSOPLdyC6B
 GXvTVPwhPD0d0r+tEfNAuiCVRPv5dcNUr17g71VMFVVKmksmfapMMZ0t5fna+HvEvFm/
 mJFy1czauQcvc4Fd7MLLJ7ON/TQ2b19FnZy8157jo/C+fKvlLJv0fBgvceMndodYdSH6
 IqqJeS7FMatdccdundgGNowdSHyQy23c1gpYq3/k71qL4J9ke/2B4/jXpWKz+mPDbBY9 iA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3n58x1sxj2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Jan 2023 16:32:10 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30GGE3ue010940;
        Mon, 16 Jan 2023 16:32:09 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3n58x1sxha-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Jan 2023 16:32:09 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30GC63g6010590;
        Mon, 16 Jan 2023 16:32:07 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma06fra.de.ibm.com (PPS) with ESMTPS id 3n3knf9y7u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Jan 2023 16:32:07 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30GGW4Ai23855600
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Jan 2023 16:32:04 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E357720043;
        Mon, 16 Jan 2023 16:32:03 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 86E7820040;
        Mon, 16 Jan 2023 16:32:02 +0000 (GMT)
Received: from [9.179.28.129] (unknown [9.179.28.129])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 16 Jan 2023 16:32:02 +0000 (GMT)
Message-ID: <619b3ebd-094a-cd8b-697c-de08ba788978@linux.ibm.com>
Date:   Mon, 16 Jan 2023 17:32:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v14 01/11] s390x/cpu topology: adding s390 specificities
 to CPU topology
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
 <20230105145313.168489-2-pmorel@linux.ibm.com>
 <49d343fb-f41d-455a-8630-3db2650cfcd5@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <49d343fb-f41d-455a-8630-3db2650cfcd5@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Hjp5CQi-cs_boEVNCUrg63UawaPnD7Co
X-Proofpoint-ORIG-GUID: xgM21hBMv1IACzSagf57wMhzczTyVyJz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-16_13,2023-01-13_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 lowpriorityscore=0 malwarescore=0 adultscore=0 phishscore=0
 priorityscore=1501 bulkscore=0 mlxlogscore=999 spamscore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301160120
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/10/23 12:37, Thomas Huth wrote:
> On 05/01/2023 15.53, Pierre Morel wrote:
>> S390 adds two new SMP levels, drawers and books to the CPU
>> topology.
>> The S390 CPU have specific toplogy features like dedication
>> and polarity to give to the guest indications on the host
>> vCPUs scheduling and help the guest take the best decisions
>> on the scheduling of threads on the vCPUs.
>>
>> Let us provide the SMP properties with books and drawers levels
>> and S390 CPU with dedication and polarity,
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
> ...
>> diff --git a/qapi/machine.json b/qapi/machine.json
>> index b9228a5e46..ff8f2b0e84 100644
>> --- a/qapi/machine.json
>> +++ b/qapi/machine.json
>> @@ -900,13 +900,15 @@
>>   # a CPU is being hotplugged.
>>   #
>>   # @node-id: NUMA node ID the CPU belongs to
>> -# @socket-id: socket number within node/board the CPU belongs to
>> +# @drawer-id: drawer number within node/board the CPU belongs to
>> +# @book-id: book number within drawer/node/board the CPU belongs to
>> +# @socket-id: socket number within book/node/board the CPU belongs to
> 
> I think the new entries need a "(since 8.0)" comment (similar to die-id 
> and cluster-id below).

right

> 
> Other question: Do we have "node-id"s on s390x? If not, is that similar 
> to books or drawers, i.e. just another word? If so, we should maybe 
> rather re-use "nodes" instead of introducing a new name for the same thing?

We have theoretically nodes-id on s390x, it is the level 5 of the 
topology, above drawers.
Currently it is not used in s390x topology, the maximum level returned 
to a LPAR host is 4.
I suppose that it adds a possibility to link several s390x with a fast 
network.

> 
>>   # @die-id: die number within socket the CPU belongs to (since 4.1)
>>   # @cluster-id: cluster number within die the CPU belongs to (since 7.1)
>>   # @core-id: core number within cluster the CPU belongs to
>>   # @thread-id: thread number within core the CPU belongs to
>>   #
>> -# Note: currently there are 6 properties that could be present
>> +# Note: currently there are 8 properties that could be present
>>   #       but management should be prepared to pass through other
>>   #       properties with device_add command to allow for future
>>   #       interface extension. This also requires the filed names to 
>> be kept in
>> @@ -916,6 +918,8 @@
>>   ##
>>   { 'struct': 'CpuInstanceProperties',
>>     'data': { '*node-id': 'int',
>> +            '*drawer-id': 'int',
>> +            '*book-id': 'int',
>>               '*socket-id': 'int',
>>               '*die-id': 'int',
>>               '*cluster-id': 'int',
>> @@ -1465,6 +1469,10 @@
>>   #
>>   # @cpus: number of virtual CPUs in the virtual machine
>>   #
>> +# @drawers: number of drawers in the CPU topology
>> +#
>> +# @books: number of books in the CPU topology
>> +#
> 
> These also need a "(since 8.0)" comment at the end.

right again, I will add this.

> 
>>   # @sockets: number of sockets in the CPU topology
>>   #
>>   # @dies: number of dies per socket in the CPU topology
>> @@ -1481,6 +1489,8 @@
>>   ##
>>   { 'struct': 'SMPConfiguration', 'data': {
>>        '*cpus': 'int',
>> +     '*drawers': 'int',
>> +     '*books': 'int',
>>        '*sockets': 'int',
>>        '*dies': 'int',
>>        '*clusters': 'int',
> ...
>> diff --git a/qemu-options.hx b/qemu-options.hx
>> index 7f99d15b23..8dc9a4c052 100644
>> --- a/qemu-options.hx
>> +++ b/qemu-options.hx
>> @@ -250,11 +250,13 @@ SRST
>>   ERST
>>   DEF("smp", HAS_ARG, QEMU_OPTION_smp,
>> -    "-smp 
>> [[cpus=]n][,maxcpus=maxcpus][,sockets=sockets][,dies=dies][,clusters=clusters][,cores=cores][,threads=threads]\n"
>> +    "-smp 
>> [[cpus=]n][,maxcpus=maxcpus][,drawers=drawers][,books=books][,sockets=sockets][,dies=dies][,clusters=clusters][,cores=cores][,threads=threads]\n"
> 
> This line now got too long. Please add a newline inbetween.

OK

Thanks.

Regards,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
