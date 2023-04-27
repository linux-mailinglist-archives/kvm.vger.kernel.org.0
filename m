Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 912AC6F07B6
	for <lists+kvm@lfdr.de>; Thu, 27 Apr 2023 16:50:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243412AbjD0Ou2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Apr 2023 10:50:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbjD0Ou0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Apr 2023 10:50:26 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 408B7C5;
        Thu, 27 Apr 2023 07:50:24 -0700 (PDT)
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33RElCju004404;
        Thu, 27 Apr 2023 14:50:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=vW26iwn8FDwyVgJilqhuRWw6m9lBk6eeCwKPKmTeuIw=;
 b=VdqGBS8exlMXjpvYy4LhVzjMEfvVeIZK1noplHeA4TtlBMNAA3SVRH3dwzmWXeumpiAg
 UxfOPsLDwlmWUcG2K5JUXSs4VCo0Bjch8xMK4k644kFUJ2EiQ44L/pAtU3Waa8i5EL+x
 48x7IsJginEQf47bz/0ROuThwpnU66h31+revOMCRelYMuoXRcFwAO88ViCgxVgMtLac
 CWJtFgwp+DcsGWR6aeso/1iwecjC8oF7fblGtPbv9CRe/MrPzfzBIr7vEc5vzZQRoJk9
 +ylAkUfNTzhY6lwZV9WMPw5IpovLntmrnaowznXzRSqZ7m/dHQol/PgWwvkKfOvWGxOj gQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q7ttw8qsg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Apr 2023 14:50:23 +0000
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 33REirgk029023;
        Thu, 27 Apr 2023 14:50:22 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q7ttw8qrg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Apr 2023 14:50:22 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 33QLPeh3020733;
        Thu, 27 Apr 2023 14:50:20 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3q46ug31dy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Apr 2023 14:50:20 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 33REoHGo28508490
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Apr 2023 14:50:17 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4810820040;
        Thu, 27 Apr 2023 14:50:17 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C00432004E;
        Thu, 27 Apr 2023 14:50:16 +0000 (GMT)
Received: from [9.171.19.188] (unknown [9.171.19.188])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Thu, 27 Apr 2023 14:50:16 +0000 (GMT)
Message-ID: <25a9c3d6-43be-6a08-a32e-5abc520e8c62@linux.ibm.com>
Date:   Thu, 27 Apr 2023 16:50:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [kvm-unit-tests PATCH v8 2/2] s390x: topology: Checking
 Configuration Topology Information
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, thuth@redhat.com, kvm@vger.kernel.org,
        imbrenda@linux.ibm.com, david@redhat.com, nsg@linux.ibm.com
References: <20230426083426.6806-1-pmorel@linux.ibm.com>
 <20230426083426.6806-3-pmorel@linux.ibm.com>
 <168258524358.99032.14388431972069131423@t14-nrb>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <168258524358.99032.14388431972069131423@t14-nrb>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 4HVWvsntojBdl39KU-t1Yl_PT343aIxh
X-Proofpoint-ORIG-GUID: gSIPHMgQP0aFz3USsUP78R4LjHz2e7Ew
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-27_07,2023-04-27_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 adultscore=0 bulkscore=0 impostorscore=0 suspectscore=0 clxscore=1015
 lowpriorityscore=0 mlxlogscore=999 spamscore=0 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304270126
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/27/23 10:47, Nico Boehr wrote:
> Quoting Pierre Morel (2023-04-26 10:34:26)
>> diff --git a/s390x/topology.c b/s390x/topology.c
>> index 07f1650..42a9cc9 100644
>> --- a/s390x/topology.c
>> +++ b/s390x/topology.c
>> @@ -17,6 +17,20 @@
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
>> +
>> +       report(!cpus->d || (cpus->pp == 3 || cpus->pp == 0),
>> +              "Dedication versus entitlement");
> Again, I would prefer something like this:
>
> if (!cpus->d)
>      report_skip("Not dedicated")
> else
>      report(cpus->pp == 3 || cpus->pp == 0, "Dedicated CPUs are either vertically polarized or have high entitlement")
>
> No?
>
> [...]

Yes looks better, thanks


>
>> +/**
>> + * check_sysinfo_15_1_x:
>> + * @info: pointer to the STSI info structure
>> + * @sel2: the selector giving the topology level to check
>> + *
>> + * Check if the validity of the STSI instruction and then
>> + * calls specific checks on the information buffer.
>> + */
>> +static void check_sysinfo_15_1_x(struct sysinfo_15_1_x *info, int sel2)
>> +{
>> +       int ret;
>> +       int cc;
>> +       unsigned long rc;
>> +
>> +       report_prefix_pushf("15_1_%d", sel2);
>> +
>> +       ret = stsi_get_sysib(info, sel2);
>> +       if (ret) {
>> +               report_skip("Selector 2 not supported by architecture");
>> +               goto end;
>> +       }
>> +
>> +       report_prefix_pushf("H");
>> +       cc = ptf(PTF_REQ_HORIZONTAL, &rc);
>> +       if (cc != 0 && rc != PTF_ERR_ALRDY_POLARIZED) {
>> +               report(0, "Unable to set horizontal polarization");
> report_fail() please

OK


>
>> +               goto vertical;
>> +       }
>> +
>> +       stsi_check_mag(info);
>> +       stsi_check_tle_coherency(info);
>> +
>> +vertical:
>> +       report_prefix_pop();
>> +       report_prefix_pushf("V");
>> +
>> +       cc = ptf(PTF_REQ_VERTICAL, &rc);
>> +       if (cc != 0 && rc != PTF_ERR_ALRDY_POLARIZED) {
>> +               report(0, "Unable to set vertical polarization");
> report_fail() please

OK


>
> [...]
>> +static int arch_max_cpus(void)
> Does the name arch_max_cpus() make sense? Maybe expected_num_cpus()?


Yes OK.


>
>> diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
>> index fc3666b..375e6ce 100644
>> --- a/s390x/unittests.cfg
>> +++ b/s390x/unittests.cfg
>> @@ -221,3 +221,6 @@ file = ex.elf
>>   
>>   [topology]
>>   file = topology.elf
>> +# 3 CPUs on socket 0 with different CPU TLE (standard, dedicated, origin)
>> +# 1 CPU on socket 2
>> +extra_params = -smp 1,drawers=3,books=3,sockets=4,cores=4,maxcpus=144 -cpu z14,ctop=on -device z14-s390x-cpu,core-id=1,entitlement=low -device z14-s390x-cpu,core-id=2,dedicated=on -device z14-s390x-cpu,core-id=10 -device z14-s390x-cpu,core-id=20 -device z14-s390x-cpu,core-id=130,socket-id=0,book-id=0,drawer-id=0 -append '-drawers 3 -books 3 -sockets 4 -cores 4'
> If I got the command line right, all CPUs are on the same drawer with this command line, aren't they? If so, does it make sense to run with different combinations, i.e. CPUs on different drawers, books etc?

OK, I will add some CPU on different drawers and books.



