Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 908DE490B3B
	for <lists+kvm@lfdr.de>; Mon, 17 Jan 2022 16:13:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240378AbiAQPNP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jan 2022 10:13:15 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:2974 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230202AbiAQPNO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 17 Jan 2022 10:13:14 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20HDviSI018352;
        Mon, 17 Jan 2022 15:13:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=16UotllAKznZT4KieQy+6b3nwme+qZWB4csvLOcC9NE=;
 b=UZUvAQSCDwJGxVu4THgGUMvSdQK+o0g0ArxzU7cTJ68o7TuSp9gDuT4XQpTI6loLsrLW
 gNLr67doDB5RwecFzKVukPniisK7hyn8rdABXsmiJaclwDIwytrNdVH27xRReyXIhirR
 tbaBlxi94Og6LP/ZVGPlDUFh8bu8ASypG0tg0DJpd3iYCUM6xoutCiSl1q7Bh/D1zFZI
 QiWqQb3JFYsM3YcIp7mgdwg0jcTfeccQlt9Re1vNVx3JJRtYSejCikQwWhxHgZgCvRdi
 c1iDOgn+cf5uAm1Q8CBvYl5PRcmb0FfUs028UKmO4FU7Pw0ay5t/0+uMttLBtm1HHs3O 1Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dn9t3hex2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 Jan 2022 15:13:13 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20HECiCN018878;
        Mon, 17 Jan 2022 15:13:12 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dn9t3hewj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 Jan 2022 15:13:12 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20HF972G015147;
        Mon, 17 Jan 2022 15:13:11 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3dknhj5byc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 Jan 2022 15:13:10 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20HFD7uV35127798
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Jan 2022 15:13:07 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B58894C05A;
        Mon, 17 Jan 2022 15:13:07 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 511764C05C;
        Mon, 17 Jan 2022 15:13:07 +0000 (GMT)
Received: from [9.171.80.201] (unknown [9.171.80.201])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 17 Jan 2022 15:13:07 +0000 (GMT)
Message-ID: <9aa09fba-27ef-ddd5-462a-165b38f6d58a@linux.ibm.com>
Date:   Mon, 17 Jan 2022 16:14:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [kvm-unit-tests PATCH v3 4/4] s390x: topology: Checking
 Configuration Topology Information
Content-Language: en-US
To:     Janosch Frank <frankja@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     thuth@redhat.com, kvm@vger.kernel.org, cohuck@redhat.com,
        imbrenda@linux.ibm.com, david@redhat.com
References: <20220110133755.22238-1-pmorel@linux.ibm.com>
 <20220110133755.22238-5-pmorel@linux.ibm.com>
 <45dea0fb-5605-5f98-74c7-d68f7841f1b6@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <45dea0fb-5605-5f98-74c7-d68f7841f1b6@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Iupiuaj9BqB0Kbv7uk_egi32mX57YD52
X-Proofpoint-GUID: u5hFrp191SF59Zb57pJ28-ysR8qa4QIM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-17_07,2022-01-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 impostorscore=0 mlxscore=0 clxscore=1015 malwarescore=0 adultscore=0
 mlxlogscore=999 suspectscore=0 phishscore=0 bulkscore=0 priorityscore=1501
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201170093
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/11/22 14:30, Janosch Frank wrote:
> On 1/10/22 14:37, Pierre Morel wrote:
>> STSI with function code 15 is used to store the CPU configuration
>> topology.
>>
>> We check :
>> - if the topology stored is coherent between the QEMU -smp
>>    parameters and kernel parameters.
>> - the number of CPUs
>> - the maximum number of CPUs
>> - the number of containers of each levels for every STSI(15.1.x)
>>    instruction allowed by the machine.
> 
> The full review of this will take some time.
> 
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   lib/s390x/stsi.h    |  44 +++++++++
>>   s390x/topology.c    | 231 ++++++++++++++++++++++++++++++++++++++++++++
>>   s390x/unittests.cfg |   1 +
>>   3 files changed, 276 insertions(+)
>>
>> diff --git a/lib/s390x/stsi.h b/lib/s390x/stsi.h
>> index 02cc94a6..e3fc7ac0 100644
>> --- a/lib/s390x/stsi.h
>> +++ b/lib/s390x/stsi.h
>> @@ -29,4 +29,48 @@ struct sysinfo_3_2_2 {
>>       uint8_t ext_names[8][256];
>>   };
>> +struct topology_core {
>> +    uint8_t nl;
>> +    uint8_t reserved1[3];
>> +    uint8_t reserved4:5;
>> +    uint8_t d:1;
>> +    uint8_t pp:2;
>> +    uint8_t type;
>> +    uint16_t origin;
>> +    uint64_t mask;
>> +};
>> +
>> +struct topology_container {
>> +    uint8_t nl;
>> +    uint8_t reserved[6];
>> +    uint8_t id;
>> +};
>> +
>> +union topology_entry {
>> +    uint8_t nl;
>> +    struct topology_core cpu;
>> +    struct topology_container container;
>> +};
>> +
>> +#define CPU_TOPOLOGY_MAX_LEVEL 6
>> +struct sysinfo_15_1_x {
>> +    uint8_t reserved0[2];
>> +    uint16_t length;
>> +    uint8_t mag[CPU_TOPOLOGY_MAX_LEVEL];
>> +    uint8_t reserved10;
> 
> reserved0a?

OK

> 
>> +    uint8_t mnest;
>> +    uint8_t reserved12[4];
> 
> reserved0c?

OK

> 
>> +    union topology_entry tle[0];

...snip...

>> +static void stsi_check_tle_coherency(struct sysinfo_15_1_x *info, int 
>> sel2)
>> +{
>> +    struct topology_container *tc, *end;
>> +    struct topology_core *cpus;
>> +    int n = 0;
>> +    int i;
>> +
>> +    report_prefix_push("TLE coherency");
>> +
>> +    tc = (void *)&info->tle[0];
> 
> tc = &info->tle[0].container ?

Yes, clearly better than a cast.

> 
>> +    end = (struct topology_container *)((unsigned long)info + 
...snip...
>> +    /* For each level found in STSI */
>> +    for (i = 1; i < CPU_TOPOLOGY_MAX_LEVEL; i++) {
>> +        /*
>> +         * For non QEMU/KVM hypervizor the concatanation of the levels
> 
> hypervisor
> 
> concatenation

Yes, thanks.

> 
>> +         * above level 1 are architecture dependent.

...snip...

Thanks,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
