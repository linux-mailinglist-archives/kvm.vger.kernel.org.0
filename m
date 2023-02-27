Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43B1F6A43FF
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 15:15:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230274AbjB0OP2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 09:15:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbjB0OP0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 09:15:26 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEDD76A71
        for <kvm@vger.kernel.org>; Mon, 27 Feb 2023 06:15:22 -0800 (PST)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31RD1vqM012369;
        Mon, 27 Feb 2023 14:15:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=qWrnt/eYZxxX2vRKSlvA/RNdZj9V9Jz1GE9nHXx0vOY=;
 b=HKunSsfkuHYMDPth68T3pke19PoF5oSk1LBFbUmgKEKULLkHSm0SvIVPngRqKpvlBBuD
 92bMiSJosFvI6pZotzudnFACvEJQ0298/MhqnZ5eT0/07rTnAgNDcFbl2nv3C62pxy9E
 BvmHOBvxb0Uq23SLt+tUczTAPcGZwlebyhy6AQVUDLcMJnzHbLYCK2/KZ1O4KnMtA46M
 Vrh7t6Mg3pnDuELxMMJVcqgut3zTNa7fACBcZ7xdBsjQ/LneNNtANAm4ke2yR8YEnlhh
 ZhaY9QqfQNXMm6HDS5z1wUxy9bI0uZs7Kjq5+o+8fy8U8du0IzknEMxw/JL9ROHhCqv7 tg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3p0w20hvem-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Feb 2023 14:15:08 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 31RDAT82020531;
        Mon, 27 Feb 2023 14:15:07 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3p0w20hvd9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Feb 2023 14:15:07 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31QENACK008115;
        Mon, 27 Feb 2023 14:15:05 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma06fra.de.ibm.com (PPS) with ESMTPS id 3nybdbhgbc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Feb 2023 14:15:05 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 31REF2Td37486918
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Feb 2023 14:15:02 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ED92320043;
        Mon, 27 Feb 2023 14:15:01 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8CCAD2004B;
        Mon, 27 Feb 2023 14:15:00 +0000 (GMT)
Received: from [9.171.14.212] (unknown [9.171.14.212])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Mon, 27 Feb 2023 14:15:00 +0000 (GMT)
Message-ID: <c2919c6d-1227-4ede-0e28-128d4823ec81@linux.ibm.com>
Date:   Mon, 27 Feb 2023 15:14:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v16 10/11] qapi/s390x/cpu topology:
 CPU_POLARIZATION_CHANGE qapi event
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
 <20230222142105.84700-11-pmorel@linux.ibm.com>
 <9a029d4e-4794-9a6a-7516-bed8feb39d97@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <9a029d4e-4794-9a6a-7516-bed8feb39d97@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 9GPecPlCFZS-b4qsuMFw2iKp81yqSRM5
X-Proofpoint-GUID: WuprtxRtVS0Lr9gU6yP82RbR-EjqPFPF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-27_10,2023-02-27_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 spamscore=0
 lowpriorityscore=0 mlxscore=0 malwarescore=0 adultscore=0 mlxlogscore=999
 bulkscore=0 suspectscore=0 phishscore=0 priorityscore=1501 impostorscore=0
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


On 2/27/23 14:32, Thomas Huth wrote:
> On 22/02/2023 15.21, Pierre Morel wrote:
>> When the guest asks to change the polarization this change
>> is forwarded to the admin using QAPI.
>> The admin is supposed to take according decisions concerning
>> CPU provisioning.
>
> I still find it weird talking about "the admin" here. I don't think 
> any human will monitor this event to take action on it. Maybe rather 
> talk about the "upper layer" (libvirt) or whatever you have in mind to 
> monitor this event?


hum, I already read this somewhere :)

Yes I change this.


>
>> diff --git a/qapi/machine-target.json b/qapi/machine-target.json
>> index baa9d273cf..e7a9049c1f 100644
>> --- a/qapi/machine-target.json
>> +++ b/qapi/machine-target.json
>> @@ -389,3 +389,37 @@
>>     'features': [ 'unstable' ],
>>     'if': { 'all': [ 'TARGET_S390X' ] }
>>   }
>> +
>> +##
>> +# @CPU_POLARIZATION_CHANGE:
>> +#
>> +# Emitted when the guest asks to change the polarization.
>> +#
>> +# @polarization: polarization specified by the guest
>> +#
>> +# Features:
>> +# @unstable: This command may still be modified.
>> +#
>> +# The guest can tell the host (via the PTF instruction) whether the
>> +# CPUs should be provisioned using horizontal or vertical polarization.
>> +#
>> +# On horizontal polarization the host is expected to provision all 
>> vCPUs
>> +# equally.
>> +# On vertical polarization the host can provision each vCPU 
>> differently.
>> +# The guest will get information on the details of the provisioning
>> +# the next time it uses the STSI(15) instruction.
>> +#
>> +# Since: 8.0
>> +#
>> +# Example:
>> +#
>> +# <- { "event": "CPU_POLARIZATION_CHANGE",
>> +#      "data": { "polarization": 0 },
>> +#      "timestamp": { "seconds": 1401385907, "microseconds": 422329 } }
>> +#
>
> I'd remove the final empty line.


OK


>
>> +##
>> +{ 'event': 'CPU_POLARIZATION_CHANGE',
>> +  'data': { 'polarization': 'CpuS390Polarization' },
>> +  'features': [ 'unstable' ],
>> +  'if': { 'all': [ 'TARGET_S390X', 'CONFIG_KVM' ] }
>> +}
>
>  Thomas
>
Thanks,

Regards,

Pierre

