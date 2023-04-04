Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70D046D6054
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 14:27:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234152AbjDDM1Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 08:27:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234812AbjDDM1K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 08:27:10 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 506303ABE
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 05:26:46 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 334CGYpo011097;
        Tue, 4 Apr 2023 12:26:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=w8FOvm+83Igx7pHPqGdzocDjhEgkYk3tl+QLztFt0g4=;
 b=hyk3Pa6Uj1uwHq3ctAkkAK0tjcfG7S9lSXFQyYDyczCElfOAdGBWFep9MAXWhI/B3OS7
 S83viTqwBqPZ7pvh9YKGuTjUzY2M+zMdipXQsgofRQ/l2pDLredRnV6aw7Wyxo3scQgM
 xAe8QIzmZHYkvX5trp9YjphKnGsCOiY0nnxHvImsp4TAYrUA6rQQXfnwAd6lBhYBdsID
 o4JNH6k+t5wCXjsYXvFsWinBlNLht91oZvRhSliPbdroPS8sipKF37SlBiPedpmBwzjL
 tfRP2HPOdpshtHXAUYlPj8wtzE5EQBHEjJrWJDuXt+QZZbxwCteph1aXA4T5rPHBf/VM sw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pr3gs6yrg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 12:26:28 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 334CNHoX003762;
        Tue, 4 Apr 2023 12:26:28 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pr3gs6yqj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 12:26:27 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 333Mejkq004036;
        Tue, 4 Apr 2023 12:26:26 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3ppbvg2gp0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 12:26:25 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 334CQMq546924240
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 4 Apr 2023 12:26:22 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3E61020043;
        Tue,  4 Apr 2023 12:26:22 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CB98B20040;
        Tue,  4 Apr 2023 12:26:20 +0000 (GMT)
Received: from [9.152.222.242] (unknown [9.152.222.242])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Tue,  4 Apr 2023 12:26:20 +0000 (GMT)
Message-ID: <39da5f48-07ed-1097-8686-238e2899993a@linux.ibm.com>
Date:   Tue, 4 Apr 2023 14:26:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v19 15/21] tests/avocado: s390x cpu topology polarisation
Content-Language: en-US
To:     =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>,
        qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com,
        frankja@linux.ibm.com, berrange@redhat.com
References: <20230403162905.17703-1-pmorel@linux.ibm.com>
 <20230403162905.17703-16-pmorel@linux.ibm.com>
 <0a5daba1-16df-cd01-f0fb-c6b9cccb04d3@kaod.org>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <0a5daba1-16df-cd01-f0fb-c6b9cccb04d3@kaod.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: z8F-ABKVk1mbGWmps9WKzcrus4fMVPO5
X-Proofpoint-ORIG-GUID: a1yBU80b-_A6lfuXRrYdznGpZKQNkplw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-04_04,2023-04-04_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 clxscore=1015
 spamscore=0 bulkscore=0 phishscore=0 priorityscore=1501 malwarescore=0
 impostorscore=0 mlxlogscore=999 lowpriorityscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304040112
X-Spam-Status: No, score=-2.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/4/23 11:22, Cédric Le Goater wrote:
> On 4/3/23 18:28, Pierre Morel wrote:
>> Polarization is changed on a request from the guest.
>> Let's verify the polarization is accordingly set by QEMU.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   tests/avocado/s390_topology.py | 38 +++++++++++++++++++++++++++++++++-
>>   1 file changed, 37 insertions(+), 1 deletion(-)
>>
>> diff --git a/tests/avocado/s390_topology.py 
>> b/tests/avocado/s390_topology.py
>> index 38e9cc4f16..a4bbbc2cb6 100644
>> --- a/tests/avocado/s390_topology.py
>> +++ b/tests/avocado/s390_topology.py
>> @@ -107,6 +107,15 @@ def kernel_init(self):
>>                            '-initrd', initrd_path,
>>                            '-append', kernel_command_line)
>>   +    def system_init(self):
>> +        self.log.info("System init")
>> +        exec_command(self, 'mount proc -t proc /proc')
>> +        time.sleep(0.2)
>> +        exec_command(self, 'mount sys -t sysfs /sys')
>> +        time.sleep(0.2)
>> +        exec_command_and_wait_for_pattern(self,
>> +                '/bin/cat /sys/devices/system/cpu/dispatching', '0')
>> +
>>       def test_single(self):
>>           self.kernel_init()
>>           self.vm.launch()
>> @@ -116,7 +125,6 @@ def test_single(self):
>>       def test_default(self):
>>           """
>>           This test checks the implicite topology.
>> -
>
> unwanted change I guess ?


oh right

thanks

Pierre



