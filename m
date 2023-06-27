Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F85E73FCC2
	for <lists+kvm@lfdr.de>; Tue, 27 Jun 2023 15:23:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230003AbjF0NXf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jun 2023 09:23:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230226AbjF0NXP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jun 2023 09:23:15 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37D49199C
        for <kvm@vger.kernel.org>; Tue, 27 Jun 2023 06:23:14 -0700 (PDT)
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35RDH1Fc018220;
        Tue, 27 Jun 2023 13:23:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=n56pSaHnS3rxAWzGj3JlgeuPAA4H4eEhNnnq8faHt8s=;
 b=J9fygOgF3m4M6iFmpeyUW02lS6h60Rnz3FlACUMYUaOaJDl6A9fMkUqrXyaT4E/NRYOD
 CDcwr+Hplfd+N/00l6xFTZt7N0+0GzSzHyMLlGxCVtg1CvmwmWD8fSbjojFjhPrtgBPo
 Yg4q4sBc3OFgWyfkROfuCRqgLLMZK8B9ygbx60PvgyQBI5fOiOK+ysjX7T25Xdk/qIQ8
 MmSmy7EpW5oboFDVobwFSA8Sr0loLEOpvToi3Ggkbrl0xxozluRm3dADNvTtUN7pfovS
 MOYdoHi4e2MplTO6LhOZjD8Xqc8C+RDT3B+2XrhZRdfi5zoHCokC1OxfWRCrx67oTz+z Sw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rg0h205u0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 27 Jun 2023 13:23:02 +0000
Received: from m0353723.ppops.net (m0353723.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 35RDKcJH028710;
        Tue, 27 Jun 2023 13:23:02 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rg0h205sj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 27 Jun 2023 13:23:02 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 35R4QTBC029933;
        Tue, 27 Jun 2023 13:23:00 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma04fra.de.ibm.com (PPS) with ESMTPS id 3rdr451e96-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 27 Jun 2023 13:22:57 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 35RDMqLm14549716
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Jun 2023 13:22:52 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0F52A20043;
        Tue, 27 Jun 2023 13:22:52 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5D7D320040;
        Tue, 27 Jun 2023 13:22:51 +0000 (GMT)
Received: from [9.152.222.242] (unknown [9.152.222.242])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Tue, 27 Jun 2023 13:22:51 +0000 (GMT)
Message-ID: <9d4e8f39-ba07-dc19-58a0-076ac9b186e0@linux.ibm.com>
Date:   Tue, 27 Jun 2023 15:22:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v20 16/21] tests/avocado: s390x cpu topology entitlement
 tests
Content-Language: en-US
To:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com,
        berrange@redhat.com, clg@kaod.org
References: <20230425161456.21031-1-pmorel@linux.ibm.com>
 <20230425161456.21031-17-pmorel@linux.ibm.com>
 <c268bd5b3246bdd0b7736eeeaba200a10546c470.camel@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <c268bd5b3246bdd0b7736eeeaba200a10546c470.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: YHfSa4bOUAhv07ktXgWS5AJmmnoCtpt-
X-Proofpoint-GUID: biZTVjvZGuFJ-8PZnExDkhSuiYzS2x5U
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-06-27_08,2023-06-27_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 spamscore=0
 clxscore=1015 priorityscore=1501 suspectscore=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 adultscore=0 lowpriorityscore=0 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306270121
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 5/22/23 21:47, Nina Schoetterl-Glausch wrote:
> On Tue, 2023-04-25 at 18:14 +0200, Pierre Morel wrote:
>> This test takes care to check the changes on different entitlements
>> when the guest requests a polarization change.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   tests/avocado/s390_topology.py | 56 ++++++++++++++++++++++++++++++++++
>>   1 file changed, 56 insertions(+)
>>
>> diff --git a/tests/avocado/s390_topology.py b/tests/avocado/s390_topology.py
>> index 30d3c0d0cb..64e1cc9209 100644
>> --- a/tests/avocado/s390_topology.py
>> +++ b/tests/avocado/s390_topology.py
>> @@ -244,3 +244,59 @@ def test_polarisation(self):
>>                   '/bin/cat /sys/devices/system/cpu/dispatching', '0')
>>   
>>           self.check_topology(0, 0, 0, 0, 'medium', False)
>> +
>> +    def test_entitlement(self):
>> +        """
>> +        This test verifies that QEMU modifies the polarization
>> +        after a guest request.
>> +
>> +        :avocado: tags=arch:s390x
>> +        :avocado: tags=machine:s390-ccw-virtio
>> +        """
>> +        self.kernel_init()
>> +        self.vm.add_args('-smp',
>> +                         '1,drawers=2,books=2,sockets=3,cores=2,maxcpus=24')
>> +        self.vm.add_args('-device', 'z14-s390x-cpu,core-id=1')
>> +        self.vm.add_args('-device', 'z14-s390x-cpu,core-id=2')
>> +        self.vm.add_args('-device', 'z14-s390x-cpu,core-id=3')
> Why the -device statements? Won't they result in the same as specifying -smp 4,...?
> Same for patch 17.


A left over.

You are right it is the same.

thanks,

Pierre



