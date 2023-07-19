Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4AC4759815
	for <lists+kvm@lfdr.de>; Wed, 19 Jul 2023 16:22:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231535AbjGSOWK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jul 2023 10:22:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230375AbjGSOWH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jul 2023 10:22:07 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34A142707
        for <kvm@vger.kernel.org>; Wed, 19 Jul 2023 07:21:46 -0700 (PDT)
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36JEGAw6017175;
        Wed, 19 Jul 2023 14:21:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Wt4hZwJVZOll8elvkSi1uRGPNk+fDViihAnZqospbrQ=;
 b=HxfozUILLQ+wPMF4xuNpe7lboLSbL6QdkNfPtT/vpE10LRmud00cB5+luBp5azBxz/2O
 pAJUWPDHT1VPrHk7wIdxu+DlJ6ja9F42FqvPCqFOGGDU13E95lELpvBksCjjtRE40LcP
 e7JrtAFDVBHWiyMFBAMxCN0855aGgtdJ3X5n1rvWGULu1yaISxvIqLWiPDLfraKvtEsg
 mKQsB770Xk2BtatMQHnj2LssrhSJk/KoAFFFttIbhcaEA4/4HgDq/l5n0u2JP0G7iaDl
 c997ub9sTD4RWulGnCwd5S9rv9K0TzM9c3OzWOlCTLKDMXqj/EoN0QOvZ37OJ54d92mH 6w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rxg9pah2w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Jul 2023 14:21:21 +0000
Received: from m0353727.ppops.net (m0353727.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36JE6IHg028302;
        Wed, 19 Jul 2023 14:21:20 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rxg9pah2d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Jul 2023 14:21:20 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
        by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36JCMTZc017202;
        Wed, 19 Jul 2023 14:21:19 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3rv5srtymn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Jul 2023 14:21:19 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36JELFvN18940662
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Jul 2023 14:21:15 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5753820043;
        Wed, 19 Jul 2023 14:21:15 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CA2752004B;
        Wed, 19 Jul 2023 14:21:14 +0000 (GMT)
Received: from [9.155.200.205] (unknown [9.155.200.205])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Wed, 19 Jul 2023 14:21:14 +0000 (GMT)
Message-ID: <ae24fc04-e358-f43d-3356-d38d7c0ebbc9@linux.ibm.com>
Date:   Wed, 19 Jul 2023 16:21:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v21 18/20] tests/avocado: s390x cpu topology test socket
 full
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
 <20230630091752.67190-19-pmorel@linux.ibm.com>
 <917541c2-65b6-18b5-cf83-e72bf570eacf@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <917541c2-65b6-18b5-cf83-e72bf570eacf@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: R6_Jy99shFeAG87aRqr4uZd0bAAYycSy
X-Proofpoint-GUID: nRq2WCLrxnhI_ftI8jngz4GbMBCXP-wx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-19_09,2023-07-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 mlxlogscore=999 bulkscore=0 spamscore=0 priorityscore=1501 phishscore=0
 malwarescore=0 impostorscore=0 clxscore=1015 suspectscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2307190126
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 7/5/23 12:26, Thomas Huth wrote:
> On 30/06/2023 11.17, Pierre Morel wrote:
>> This test verifies that QMP set-cpu-topology does not accept
>> to overload a socket.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   tests/avocado/s390_topology.py | 25 +++++++++++++++++++++++++
>>   1 file changed, 25 insertions(+)
>>
>> diff --git a/tests/avocado/s390_topology.py 
>> b/tests/avocado/s390_topology.py
>> index cba44bec91..0003b30702 100644
>> --- a/tests/avocado/s390_topology.py
>> +++ b/tests/avocado/s390_topology.py
>> @@ -315,3 +315,28 @@ def test_dedicated(self):
>>           self.guest_set_dispatching('0');
>>             self.check_topology(0, 0, 0, 0, 'high', True)
>> +
>> +    def test_socket_full(self):
>> +        """
>> +        This test verifies that QEMU does not accept to overload a 
>> socket.
>> +        The socket-id 0 on book-id 0 already contains CPUs 0 and 1 
>> and can
>> +        not accept any new CPU while socket-id 0 on book-id 1 is free.
>> +
>> +        :avocado: tags=arch:s390x
>> +        :avocado: tags=machine:s390-ccw-virtio
>> +        """
>> +        self.kernel_init()
>> +        self.vm.add_args('-smp',
>> + '3,drawers=2,books=2,sockets=3,cores=2,maxcpus=24')
>> +        self.vm.launch()
>> +        self.wait_until_booted()
>> +
>> +        self.system_init()
>> +
>> +        res = self.vm.qmp('set-cpu-topology',
>> +                          {'core-id': 2, 'socket-id': 0, 'book-id': 0})
>> +        self.assertEqual(res['error']['class'], 'GenericError')
>> +
>> +        res = self.vm.qmp('set-cpu-topology',
>> +                          {'core-id': 2, 'socket-id': 0, 'book-id': 1})
>> +        self.assertEqual(res['return'], {})
>
> Reviewed-by: Thomas Huth <thuth@redhat.com>
>
Thanks,

Pierre

