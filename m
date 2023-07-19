Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A17E475946C
	for <lists+kvm@lfdr.de>; Wed, 19 Jul 2023 13:39:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230147AbjGSLj5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jul 2023 07:39:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229776AbjGSLjx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jul 2023 07:39:53 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08A9F1A6
        for <kvm@vger.kernel.org>; Wed, 19 Jul 2023 04:39:25 -0700 (PDT)
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36JBc7LC022109;
        Wed, 19 Jul 2023 11:38:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=vA8xvwX/UYILXisCC0P2rH+jNGD4JXabH+q3bQTHmGA=;
 b=OKWommihtHfPSSZwjR939gn7jbPvTQJjxufk3sxSOF0C1QGL1f5PgTw29GN9nx5jL5sr
 Yd+hfd3N4xghnYvvS3MditkLTOUzFH7sUKq/91B3Mo5uDe/zpWWIsK9guAGEY62eVAF9
 UvSNk2EcCzHq4WyXyjuckzKNV4paQLk+9uVn05XdT8FXo8ypxPI0swNK4SVuXp3xE6pu
 XwLhz7aJsJ6yPu2ULs9i4/UdkgWnNhHgvuLAtZ2G9FPFZbtBbZTCHFHhuprfQBV0nY7V
 H2EV3s6Tnd/Y9EVc/NalGw8c93kY3Bg/lY+E6aYXvK7pHqYThxdJHqmNbmZnldPLm6aj Dg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rxcen4cwe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Jul 2023 11:38:15 +0000
Received: from m0353723.ppops.net (m0353723.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36JBV2Y4002782;
        Wed, 19 Jul 2023 11:38:14 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rxcen4cav-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Jul 2023 11:38:14 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36JBK9RJ031282;
        Wed, 19 Jul 2023 11:35:55 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3rv79jq2rh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Jul 2023 11:35:55 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36JBZosV44106138
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Jul 2023 11:35:50 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CF39B20043;
        Wed, 19 Jul 2023 11:35:50 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 58A5E20040;
        Wed, 19 Jul 2023 11:35:50 +0000 (GMT)
Received: from [9.155.200.205] (unknown [9.155.200.205])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Wed, 19 Jul 2023 11:35:50 +0000 (GMT)
Message-ID: <378b9e60-906d-9c02-c165-7cccfa688c28@linux.ibm.com>
Date:   Wed, 19 Jul 2023 13:35:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v21 15/20] tests/avocado: s390x cpu topology polarisation
Content-Language: en-US
To:     Thomas Huth <thuth@redhat.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        nsg@linux.ibm.com, frankja@linux.ibm.com, berrange@redhat.com,
        clg@kaod.org
References: <20230630091752.67190-1-pmorel@linux.ibm.com>
 <20230630091752.67190-16-pmorel@linux.ibm.com>
 <eb088f47-6b16-d8fc-cddc-b3a8f0e53ffe@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <eb088f47-6b16-d8fc-cddc-b3a8f0e53ffe@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: EAdDmiuXszZbA6VQFWfMgURDBJAB2d1E
X-Proofpoint-ORIG-GUID: 30Jv-Nzx_NCIcFaSDVSxHdPk_nZDCdug
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-19_07,2023-07-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=999
 adultscore=0 lowpriorityscore=0 bulkscore=0 spamscore=0 malwarescore=0
 priorityscore=1501 suspectscore=0 clxscore=1015 mlxscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307190104
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 7/5/23 10:53, Thomas Huth wrote:
> On 30/06/2023 11.17, Pierre Morel wrote:
>> Polarization is changed on a request from the guest.
>> Let's verify the polarization is accordingly set by QEMU.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   tests/avocado/s390_topology.py | 46 ++++++++++++++++++++++++++++++++++
>>   1 file changed, 46 insertions(+)
>>
>> diff --git a/tests/avocado/s390_topology.py 
>> b/tests/avocado/s390_topology.py
>> index 1758ec1f13..2cf731cb1d 100644
>> --- a/tests/avocado/s390_topology.py
>> +++ b/tests/avocado/s390_topology.py
>> @@ -40,6 +40,7 @@ class S390CPUTopology(QemuSystemTest):
>>       The polarization is changed on a request from the guest.
>>       """
>>       timeout = 90
>> +    event_timeout = 1
>
> When running tests in CI and the machines are very loaded, the tests 
> can be stalled easily by multiple seconds. So using a timeout of 1 
> seconds sounds way too low for me. Please use at least 5 seconds, or 
> maybe even 10.


OK


>
>>       KERNEL_COMMON_COMMAND_LINE = ('printk.time=0 '
>>                                     'root=/dev/ram '
>> @@ -99,6 +100,15 @@ def kernel_init(self):
>>                            '-initrd', initrd_path,
>>                            '-append', kernel_command_line)
>>   +    def system_init(self):
>> +        self.log.info("System init")
>> +        exec_command(self, 'mount proc -t proc /proc')
>> +        time.sleep(0.2)
>> +        exec_command(self, 'mount sys -t sysfs /sys')
>> +        time.sleep(0.2)
>
> Hard coded sleeps are ugly... they are prone to race conditions (e.g. 
> on loaded test systems), and they artificially slow down the test 
> duration.
>
> What about doing all three commands in one statement instead:
>
>     exec_command_and_wait_for_pattern(self,
>            """mount proc -t proc /proc ;
>               mount sys -t sysfs /sys ;
>               /bin/cat /sys/devices/system/cpu/dispatching""",
>            '0')
>
> ?
>
OK , I use this. thx.

Regards,

Pierre


