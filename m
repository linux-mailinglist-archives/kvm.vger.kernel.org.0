Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 616AD6CA438
	for <lists+kvm@lfdr.de>; Mon, 27 Mar 2023 14:38:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232549AbjC0Mip (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Mar 2023 08:38:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229733AbjC0Min (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Mar 2023 08:38:43 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14096C4;
        Mon, 27 Mar 2023 05:38:43 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32RBC5jJ008598;
        Mon, 27 Mar 2023 12:38:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=mm+ibx0pPE6I3asgWzAuDXJRhhNd6NgnjZzSsWPgAzg=;
 b=UbanWTYEExaoNSdTCFvQxbwzAgqQWYLrLv1HjeLTr9sdawyaKku0yttVAFlY+vAXUl0X
 tFI2pSEoHzIJlwFyd4czI7Trn0K7yFU+2CTTCIsxGwApC8LWmuPwFRpI1vxHStwwh+05
 4xgYI4C6A37ogr+xq4u11bEGdtaBB4eG2qPnxhvQzxAQyP4q9PfLL/Cd77vTXym2XcYN
 eUbQNEEvISQoz4ZqrMSeCCgN8+73104PaX3/Ug+oyg1JdrDBgrMbrTxheAH6mm4c2Kji
 Ggb+wGXavIM4RYlLbLG1BSrpnx2AzDDnHn6dB51ZXpihZqNKy+Bci9wIz0SsupianKwO 0A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pka2ajjk0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Mar 2023 12:38:42 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32RBfDrX014448;
        Mon, 27 Mar 2023 12:38:42 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pka2ajjja-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Mar 2023 12:38:41 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32RAL4PX028879;
        Mon, 27 Mar 2023 12:38:39 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3phr7fjsn3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Mar 2023 12:38:39 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32RCcagx48169562
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Mar 2023 12:38:36 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 30D0320043;
        Mon, 27 Mar 2023 12:38:36 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B86B520040;
        Mon, 27 Mar 2023 12:38:35 +0000 (GMT)
Received: from [9.171.92.86] (unknown [9.171.92.86])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Mon, 27 Mar 2023 12:38:35 +0000 (GMT)
Message-ID: <eed972f5-7d94-4db3-c496-60f7d37db0f3@linux.ibm.com>
Date:   Mon, 27 Mar 2023 14:38:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [kvm-unit-tests PATCH v7 2/2] s390x: topology: Checking
 Configuration Topology Information
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, thuth@redhat.com, kvm@vger.kernel.org,
        imbrenda@linux.ibm.com, david@redhat.com, nsg@linux.ibm.com
References: <20230320085642.12251-1-pmorel@linux.ibm.com>
 <20230320085642.12251-3-pmorel@linux.ibm.com>
 <167965555147.41638.10047922188597254104@t14-nrb>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <167965555147.41638.10047922188597254104@t14-nrb>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: yuLM2vAvjw_daODKHHKPprjYbrGCNuzG
X-Proofpoint-GUID: dMARyDKYrqj4rcRAGxrMFjPA-7N3Iu5v
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-24_11,2023-03-27_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 clxscore=1015 mlxscore=0 adultscore=0 priorityscore=1501
 spamscore=0 impostorscore=0 phishscore=0 suspectscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2303270098
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 3/24/23 11:59, Nico Boehr wrote:
> Quoting Pierre Morel (2023-03-20 09:56:42)
>> STSI with function code 15 is used to store the CPU configuration
>> topology.
>>
>> We retrieve the maximum nested level with SCLP and use the
>> topology tree provided by the drawers, books, sockets, cores
>> arguments.
>>
>> We check :
>> - if the topology stored is coherent between the QEMU -smp
>>    parameters and kernel parameters.
>> - the number of CPUs
>> - the maximum number of CPUs
>> - the number of containers of each levels for every STSI(15.1.x)
>>    instruction allowed by the machine.
> [...]
>> diff --git a/lib/s390x/sclp.c b/lib/s390x/sclp.c
>> index 390fde7..9679332 100644
>> --- a/lib/s390x/sclp.c
>> +++ b/lib/s390x/sclp.c
>> @@ -238,3 +238,8 @@ uint64_t get_max_ram_size(void)
>>   {
>>          return max_ram_size;
>>   }
>> +
>> +uint64_t sclp_get_stsi_mnest(void)
>> +{
> maybe add:
> assert(read_info);

right


>
> [...]
>> diff --git a/s390x/topology.c b/s390x/topology.c
>> index ce248f1..11ce931 100644
>> --- a/s390x/topology.c
>> +++ b/s390x/topology.c
> [...]
>> +/*
>> + * Topology level as defined by architecture, all levels exists with
>> + * a single container unless overwritten by the QEMU -smp parameter.
>> + */
>> +static int arch_topo_lvl[CPU_TOPOLOGY_MAX_LEVEL]; // = {1, 1, 1, 1, 1, 1};
> So that's what is being provided to the test on the command line, right?
>
> How about renaming this to expected_topo_lvl?
>
> What do you mean by 'defined by architecture'?

This is what is provided by the boot arguments and should correspond to 
the physical topology.

The test checks that this is corresponding to what LPAR or QEMU shows in 
the SYSIB.

If a topology level always exist physically and if it is not specified 
on the QEMU command line it is implicitly unique.

OK for expected_topo_lvl if you prefer.


>
> [...]
>> +/*
>> + * stsi_check_mag
>> + * @info: Pointer to the stsi information
>> + *
>> + * MAG field should match the architecture defined containers
>> + * when MNEST as returned by SCLP matches MNEST of the SYSIB.
>> + */
>> +static void stsi_check_mag(struct sysinfo_15_1_x *info)
>> +{
>> +       int i;
>> +
>> +       report_prefix_push("MAG");
>> +
>> +       stsi_check_maxcpus(info);
>> +
>> +       /* Explicitly skip the test if both mnest do not match */
>> +       if (max_nested_lvl != info->mnest)
>> +               goto done;
> What does it mean if the two don't match, i.e. is this an error? Or a skip? Or is it just expected?

I have no information on the representation of the MAG fields for a 
SYSIB with a nested level different than the maximum nested level.

There are examples in the documentation but I did not find, and did not 
get a clear answer, on how the MAG field are calculated.

The examples seems clear for info->mnest between MNEST -1 and 3 but the 
explication I had on info->mnest = 2 is not to be found in any 
documentation.

Until it is specified in a documentation I skip all these tests.


>
> [...]
>> +/**
>> + * check_tle:
>> + * @tc: pointer to first TLE
>> + *
>> + * Recursively check the containers TLEs until we
>> + * find a CPU TLE.
>> + */
>> +static uint8_t *check_tle(void *tc)
>> +{
> [...]
>> +       report(!cpus->d || (cpus->pp == 3 || cpus->pp == 0),
>> +              "Dedication versus entitlement");
> Maybe skip here if the CPU is not dedicated? With shared CPUs we really can't check much here.


OK


> [...]
>> +/*
>> + * The Maximum Nested level is given by SCLP READ_SCP_INFO if the MNEST facility
>> + * is available.
>> + * If the MNEST facility is not available, sclp_get_stsi_mnest  returns 0 and the
>> + * Maximum Nested level is 2
>> + */
>> +#define S390_DEFAULT_MNEST     2
>> +static int sclp_get_mnest(void)
>> +{
>> +       return sclp_get_stsi_mnest() ?: S390_DEFAULT_MNEST;
>> +}
>> +
>> +static int arch_max_cpus(void)
> If arch_topo_lvl is renamed, also rename this function accordingly.

OK


>
>>   static struct {
>>          const char *name;
>>          void (*func)(void);
>>   } tests[] = {
>>          { "PTF", test_ptf},
>> +       { "STSI", test_stsi},
> missing space                ^


Right, thanks,


regards,

Pierre

