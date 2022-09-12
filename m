Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55C7A5B5D6B
	for <lists+kvm@lfdr.de>; Mon, 12 Sep 2022 17:40:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229821AbiILPkx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Sep 2022 11:40:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230365AbiILPko (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Sep 2022 11:40:44 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD23B1EAC0
        for <kvm@vger.kernel.org>; Mon, 12 Sep 2022 08:40:43 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28CFLUHc019473;
        Mon, 12 Sep 2022 15:40:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=RDZZzOOGSG0RboXRn0tM6UxvvyvPan/bCAqgFBcfdVM=;
 b=LzhxV+QfJ4wzU59EiK1AUWvEPoGr55vlQZX6EMSNCfambFVHQyRr/unx0SrdL8zTxW1D
 87ZtPjK97GmtBOwYqLxvs+bhnukDo/xaKs25uDgjki48jtu6842AOSEYko9R7RcDpatP
 tBi+mGy4rO0A82ahanM57e2/K1LhliTCFLY7rLPB4372SUNtZE5CSIJNaPDDMmzbdRRN
 Ma9BxV3YM46U7LUb6s0FwlYjcWZulQ7Dy+uxn7g3BfDQTHRtM87H5aI2HVbt+oby2HY3
 Py+rfKGihic4Z0F1jB9W2bLoEGkcx+rmZkSiBmbvAi8STa604kCWuUay0oPN98xfqWXb Aw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jj7bdrhtm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Sep 2022 15:40:35 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 28CFbZTL018172;
        Mon, 12 Sep 2022 15:40:34 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jj7bdrhs9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Sep 2022 15:40:34 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 28CFLU2J019616;
        Mon, 12 Sep 2022 15:40:32 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06fra.de.ibm.com with ESMTP id 3jghuhsxaq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Sep 2022 15:40:32 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 28CFerEG23134718
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Sep 2022 15:40:53 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 78FA452050;
        Mon, 12 Sep 2022 15:40:29 +0000 (GMT)
Received: from [9.171.67.163] (unknown [9.171.67.163])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 34F745204E;
        Mon, 12 Sep 2022 15:40:28 +0000 (GMT)
Message-ID: <124d3a03-def6-dd9a-1380-c5808e2e54ab@linux.ibm.com>
Date:   Mon, 12 Sep 2022 17:40:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v9 02/10] s390x/cpu topology: core_id sets s390x CPU
 topology
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, frankja@linux.ibm.com
References: <20220902075531.188916-1-pmorel@linux.ibm.com>
 <20220902075531.188916-3-pmorel@linux.ibm.com>
 <166244388074.53359.17766769465682688178@t14-nrb>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <166244388074.53359.17766769465682688178@t14-nrb>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Eu6UJIy4DqO4aC5hE0rjYGft-6R_wfae
X-Proofpoint-GUID: 5SyQ1I2xCVnjIAo19Xr7LBBbUfd7ZF0I
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-12_10,2022-09-12_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 bulkscore=0
 clxscore=1015 priorityscore=1501 impostorscore=0 mlxscore=0 adultscore=0
 suspectscore=0 mlxlogscore=999 malwarescore=0 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209120052
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 9/6/22 07:58, Nico Boehr wrote:
> Quoting Pierre Morel (2022-09-02 09:55:23)
> [...]
>> diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
>> new file mode 100644
>> index 0000000000..a6ca006ec5
>> --- /dev/null
>> +++ b/hw/s390x/cpu-topology.c
> [...]
>> +void s390_topology_new_cpu(int core_id)
>> +{
> [...]
>> +    socket_id = core_id / topo->cores;
> 
> The comment below is essential for understanding all of this. Move it before this line.
> 

OK

>> +
>> +    bit = core_id;
>> +    origin = bit / 64;
>> +    bit %= 64;
>> +    bit = 63 - bit;
>> +
>> +    /*
>> +     * At the core level, each CPU is represented by a bit in a 64bit
>> +     * unsigned long. Set on plug and clear on unplug of a CPU.
> 
> cleared                                  ^
> 
> [...]
>> +     * In that case the origin field, representing the offset of the first CPU
>> +     * in the CPU container allows to represent up to the maximal number of
>> +     * CPU inside several CPU containers inside the socket container.
> 
> How about:
> "In that case the origin variable represents the offset of the first CPU in the
> CPU container. More than 64 CPUs per socket are represented in several CPU
> containers inside the socket container."

Yes, better, thanks I take it


> 
>> diff --git a/hw/s390x/s390-virtio-ccw.c b/hw/s390x/s390-virtio-ccw.c
>> index b5ca154e2f..15cefd104b 100644
> [...]
>> @@ -247,6 +248,12 @@ static void ccw_init(MachineState *machine)
>>       /* init memory + setup max page size. Required for the CPU model */
>>       s390_memory_init(machine->ram);
>>   
>> +    /* Adding the topology must be done before CPU intialization*/
> 
> space                                                              ^
> 

Yes thanks

regards,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
