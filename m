Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42FE775916F
	for <lists+kvm@lfdr.de>; Wed, 19 Jul 2023 11:24:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbjGSJYo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jul 2023 05:24:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbjGSJYm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jul 2023 05:24:42 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ACFD188
        for <kvm@vger.kernel.org>; Wed, 19 Jul 2023 02:24:40 -0700 (PDT)
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36J991q2012509;
        Wed, 19 Jul 2023 09:24:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=j5EQgkiJNNE+OuadIU2oS5Y86zKvzpxJyDMHhiyOyXw=;
 b=JDsVqZcev0uie3dDYjoAQxuhp0UC5OlPDgOFkxTCE0J69Hz0JX45dZIxDOAXqSRD1Glf
 P334u8pmfZlIdd/yLVaXT+fAFlvo9Tj+eIDWP+rToUoC7D7lHOCzpB9S1XQJ3yPAO0vX
 9rSGSF5RJbS43OksBXKX4Jcwo8Mch5uH1aaAs9E7n0p3jpn1ylAJuZ0aq4TE+Q2eeEzS
 NpiXwH/cpUv1VXI7l1wd7H0rZo5biYQO1YoSTSEwpTANRkN/HJ0AxZXwd4B8RNrlVWMo
 XSfatER4dvXYIFZENocUgPIHhl1tCaOezpIYNFZ1kl1kCJ4SpqX/MtpucrCRsGyMbrGu 1A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rxc8e18td-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Jul 2023 09:24:25 +0000
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36J996NP013115;
        Wed, 19 Jul 2023 09:24:24 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rxc8e18sy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Jul 2023 09:24:24 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
        by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36J8A5FN016870;
        Wed, 19 Jul 2023 09:24:23 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3rv5srsw39-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Jul 2023 09:24:23 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36J9OJ7d44958304
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Jul 2023 09:24:19 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B77CE2004B;
        Wed, 19 Jul 2023 09:24:19 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4AFEC20043;
        Wed, 19 Jul 2023 09:24:19 +0000 (GMT)
Received: from [9.155.200.205] (unknown [9.155.200.205])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Wed, 19 Jul 2023 09:24:19 +0000 (GMT)
Message-ID: <276a3723-9fb0-3b3a-24e0-05668e97aa8d@linux.ibm.com>
Date:   Wed, 19 Jul 2023 11:24:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v21 14/20] tests/avocado: s390x cpu topology core
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
 <20230630091752.67190-15-pmorel@linux.ibm.com>
 <3ea3a276-a06a-b1b3-bc88-662c94d240e0@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <3ea3a276-a06a-b1b3-bc88-662c94d240e0@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: msbojhcbm2bWXAmiPPjsvKXw1IbMkNlQ
X-Proofpoint-ORIG-GUID: KGlJRsjBRLEk1pFXjIbzudUlYXg_qJsZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-19_05,2023-07-18_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 malwarescore=0 phishscore=0 priorityscore=1501 clxscore=1011
 suspectscore=0 adultscore=0 impostorscore=0 mlxscore=0 lowpriorityscore=0
 bulkscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2307190082
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 7/4/23 15:14, Thomas Huth wrote:
> On 30/06/2023 11.17, Pierre Morel wrote:
>> Introduction of the s390x cpu topology core functions and
>> basic tests.
>>
>> We test the corelation between the command line and
>> the QMP results in query-cpus-fast for various CPU topology.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   MAINTAINERS                    |   1 +
>>   tests/avocado/s390_topology.py | 196 +++++++++++++++++++++++++++++++++
>>   2 files changed, 197 insertions(+)
>>   create mode 100644 tests/avocado/s390_topology.py
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index 76f236564c..12d0d7bd91 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -1705,6 +1705,7 @@ F: hw/s390x/cpu-topology.c
>>   F: target/s390x/kvm/stsi-topology.c
>>   F: docs/devel/s390-cpu-topology.rst
>>   F: docs/system/s390x/cpu-topology.rst
>> +F: tests/avocado/s390_topology.py
>>     X86 Machines
>>   ------------
>> diff --git a/tests/avocado/s390_topology.py 
>> b/tests/avocado/s390_topology.py
>> new file mode 100644
>> index 0000000000..1758ec1f13
>> --- /dev/null
>> +++ b/tests/avocado/s390_topology.py
>> @@ -0,0 +1,196 @@
>> +# Functional test that boots a Linux kernel and checks the console
>> +#
>> +# Copyright IBM Corp. 2023
>> +#
>> +# Author:
>> +#  Pierre Morel <pmorel@linux.ibm.com>
>> +#
>> +# This work is licensed under the terms of the GNU GPL, version 2 or
>> +# later.  See the COPYING file in the top-level directory.
>> +
>> +import os
>> +import shutil
>> +import time
>> +
>> +from avocado_qemu import QemuSystemTest
>> +from avocado_qemu import exec_command
>> +from avocado_qemu import exec_command_and_wait_for_pattern
>> +from avocado_qemu import interrupt_interactive_console_until_pattern
>> +from avocado_qemu import wait_for_console_pattern
>> +from avocado.utils import process
>> +from avocado.utils import archive
>> +
>> +
>> +class S390CPUTopology(QemuSystemTest):
>> +    """
>> +    S390x CPU topology consist of 4 topology layers, from bottom to 
>> top,
>> +    the cores, sockets, books and drawers and 2 modifiers attributes,
>> +    the entitlement and the dedication.
>> +    See: docs/system/s390x/cpu-topology.rst.
>> +
>> +    S390x CPU topology is setup in different ways:
>> +    - implicitely from the '-smp' argument by completing each topology
>
> implicitly
>
>> +      level one after the other begining with drawer 0, book 0 and 
>> socket 0.
>
> beginning
>
>> +    - explicitely from the '-device' argument on the QEMU command line
>
> explicitly
>
>> +    - explicitely by hotplug of a new CPU using QMP or HMP
>
> explicitly
>
>  Thomas
>

Thanks, I make the corrections.

Pierre

