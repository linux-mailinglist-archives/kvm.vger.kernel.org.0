Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DF71560461
	for <lists+kvm@lfdr.de>; Wed, 29 Jun 2022 17:21:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232813AbiF2PVL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jun 2022 11:21:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230213AbiF2PVJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jun 2022 11:21:09 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FFEE2C660
        for <kvm@vger.kernel.org>; Wed, 29 Jun 2022 08:21:08 -0700 (PDT)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25TF75Rf022167;
        Wed, 29 Jun 2022 15:20:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=siSid0w+D2HhHGFKVu7TmM1pnBnE7dewK4Af9O9NPwU=;
 b=F3KTvwyKPhmf1hqtigftxuES5p81gYMfgYnNtn9lzl1yhxvTGXIeVuYNkKCyny+JvXPu
 ZBeKx7A0Y4Fz/QpnZzZNDhBjtKYWlOH9iSbUufxFFSlafsmPGbDH2rncoVa131YAJFsO
 r4HFurdYJT2CCYkytG5K6adHDNs8xqq9Y5LwHZenXCsSovGC0JxPxOIE/PiFvpmblYIZ
 zMCakSeEqW74mBFcdJtqAPj8P9lx/o/XX0lhoPnj0fOUuWKnocLa4PZRkTHpFHim3/zx
 O0yXqbFK2s6S9OsEIcwHBntTfNh3hGSzgGxxB9MZ4BmcscUvDff7EuClgNHT4rxXg0/Y xA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h0r25agn4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Jun 2022 15:20:58 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25TFA8eg012350;
        Wed, 29 Jun 2022 15:20:58 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h0r25agkr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Jun 2022 15:20:58 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25TF5EfT013000;
        Wed, 29 Jun 2022 15:20:55 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 3gwsmj6s2k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Jun 2022 15:20:55 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25TFKqkM19399144
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Jun 2022 15:20:52 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EC4134C044;
        Wed, 29 Jun 2022 15:20:51 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5E1514C040;
        Wed, 29 Jun 2022 15:20:51 +0000 (GMT)
Received: from [9.152.222.245] (unknown [9.152.222.245])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 29 Jun 2022 15:20:51 +0000 (GMT)
Message-ID: <72aba814-2901-7d06-131d-8c1f660e3830@linux.ibm.com>
Date:   Wed, 29 Jun 2022 17:25:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v8 02/12] s390x/cpu_topology: CPU topology objects and
 structures
Content-Language: en-US
To:     Janosch Frank <frankja@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com
References: <20220620140352.39398-1-pmorel@linux.ibm.com>
 <20220620140352.39398-3-pmorel@linux.ibm.com>
 <35c562e1-cdcd-41ce-1957-bd35c72a78ca@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <35c562e1-cdcd-41ce-1957-bd35c72a78ca@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: U0693rXTSa57Mu3TYCuvbBekoYNBeEk3
X-Proofpoint-ORIG-GUID: JxqLcdWWCBpbVvJ6zll-7_zY8LWJaWG3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-29_17,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 priorityscore=1501 mlxlogscore=999 spamscore=0 clxscore=1015 bulkscore=0
 lowpriorityscore=0 phishscore=0 impostorscore=0 mlxscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206290055
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 6/27/22 15:31, Janosch Frank wrote:
> On 6/20/22 16:03, Pierre Morel wrote:
>> We use new objects to have a dynamic administration of the CPU topology.
>> The highest level object in this implementation is the s390 book and
>> in this first implementation of CPU topology for S390 we have a single
>> book.
>> The book is built as a SYSBUS bridge during the CPU initialization.
>> Other objects, sockets and core will be built after the parsing
>> of the QEMU -smp argument.
>>
>> Every object under this single book will be build dynamically
>> immediately after a CPU has be realized if it is needed.
>> The CPU will fill the sockets once after the other, according to the
>> number of core per socket defined during the smp parsing.
>>
>> Each CPU inside a socket will be represented by a bit in a 64bit
>> unsigned long. Set on plug and clear on unplug of a CPU.
>>
>> For the S390 CPU topology, thread and cores are merged into
>> topology cores and the number of topology cores is the multiplication
>> of cores by the numbers of threads.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> 
> [...]
> 
>> diff --git a/target/s390x/cpu.h b/target/s390x/cpu.h
>> index 7d6d01325b..216adfde26 100644
>> --- a/target/s390x/cpu.h
>> +++ b/target/s390x/cpu.h
>> @@ -565,6 +565,53 @@ typedef union SysIB {
>>   } SysIB;
>>   QEMU_BUILD_BUG_ON(sizeof(SysIB) != 4096);
>> +/* CPU type Topology List Entry */
>> +typedef struct SysIBTl_cpu {
>> +        uint8_t nl;
>> +        uint8_t reserved0[3];
>> +        uint8_t reserved1:5;
>> +        uint8_t dedicated:1;
>> +        uint8_t polarity:2;
>> +        uint8_t type;
>> +        uint16_t origin;
>> +        uint64_t mask;
>> +} SysIBTl_cpu;
>> +QEMU_BUILD_BUG_ON(sizeof(SysIBTl_cpu) != 16);
>> +
>> +/* Container type Topology List Entry */
>> +typedef struct SysIBTl_container {
>> +        uint8_t nl;
>> +        uint8_t reserved[6];
>> +        uint8_t id;
>> +} QEMU_PACKED SysIBTl_container;
>> +QEMU_BUILD_BUG_ON(sizeof(SysIBTl_container) != 8);
>> +
>> +/* Generic Topology List Entry */
>> +typedef union SysIBTl_entry {
>> +        uint8_t nl;
> 
> This union member is unused, isn't it?
> 
>> +        SysIBTl_container container;
>> +        SysIBTl_cpu cpu;
>> +} SysIBTl_entry;
>> +
>> +#define TOPOLOGY_NR_MAG  6
> 
> TOPOLOGY_TOTAL_NR_MAGS ?
> 
>> +#define TOPOLOGY_NR_MAG6 0
> 
> TOPOLOGY_NR_TLES_MAG6 ?
> 
> I'm open to other suggestions but we need to differentiate between the 
> number of mag array entries and the number of TLEs in the MAGs.


typedef enum {
         TOPOLOGY_MAG6 = 0,
         TOPOLOGY_MAG5 = 1,
         TOPOLOGY_MAG4 = 2,
         TOPOLOGY_MAG3 = 3,
         TOPOLOGY_MAG2 = 4,
         TOPOLOGY_MAG1 = 5,
         TOPOLOGY_TOTAL_MAGS = 6,
};


oder enum with TOPOLOGY_NR_TLES_MAGx ?

> 
>> +#define TOPOLOGY_NR_MAG5 1
>> +#define TOPOLOGY_NR_MAG4 2
>> +#define TOPOLOGY_NR_MAG3 3
>> +#define TOPOLOGY_NR_MAG2 4
>> +#define TOPOLOGY_NR_MAG1 5
> 
> I'd appreciate a \n here.

OK

> 
>> +/* Configuration topology */
>> +typedef struct SysIB_151x {
>> +    uint8_t  res0[2];
> 
> You're using "reserved" everywhere but now it's "rev"?

OK I will keep reserved

> 
>> +    uint16_t length;
>> +    uint8_t  mag[TOPOLOGY_NR_MAG];
>> +    uint8_t  res1;
>> +    uint8_t  mnest;
>> +    uint32_t res2;
>> +    SysIBTl_entry tle[0];
>> +} SysIB_151x;
>> +QEMU_BUILD_BUG_ON(sizeof(SysIB_151x) != 16);
>> +
>>   /* MMU defines */
>>   #define ASCE_ORIGIN           (~0xfffULL) /* segment table 
>> origin             */
>>   #define ASCE_SUBSPACE         0x200       /* subspace group 
>> control           */
> 
> 

-- 
Pierre Morel
IBM Lab Boeblingen
