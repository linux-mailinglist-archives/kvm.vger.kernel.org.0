Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A898D759823
	for <lists+kvm@lfdr.de>; Wed, 19 Jul 2023 16:24:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231592AbjGSOYU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jul 2023 10:24:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231575AbjGSOYQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jul 2023 10:24:16 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 373DE1722
        for <kvm@vger.kernel.org>; Wed, 19 Jul 2023 07:24:01 -0700 (PDT)
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36JDmfq3020042;
        Wed, 19 Jul 2023 14:23:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Wyq8U/3KNkZa1vo9K47mbdGK8W0+Y3sYkb1Drsjo8YM=;
 b=Ygg4f/7s7drY5n5rx9CIRnXOfQA3l4j0bVVGCfTq2iWB8sGs1SXy0JpOAztacbuyKkU2
 Vfic6oSp3m6KGtnFaAXRcBFeX1JsXHt99n56rlZfWK58Nssl6Zz2Aba/XhQ/Gf4KDJr6
 CaiC1T/MXrprUfpiqDjoQ+5NP/MEspKQpnB7BwD0F24GBm9hqNpmFMJNhJebLTFHRtbb
 tO/3G6vKhmASe3Lf6gZeeADUYBSR54txREnhmCw35l9XuXfS30rOW0SvywjEnhDRAdUV
 dct6ztMpNtsxk7RnSn4iQoQdx+F0siTjXxa2UHjHSZB9Fv2qRDWN+QZJ6wA70iIAXEp/ yw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rxf7rv43x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Jul 2023 14:23:27 +0000
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36JEFxAp017386;
        Wed, 19 Jul 2023 14:23:26 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rxf7rv43g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Jul 2023 14:23:26 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
        by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36JCO8gu017218;
        Wed, 19 Jul 2023 14:23:25 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3rv5srtywm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Jul 2023 14:23:25 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36JENLdE18940452
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Jul 2023 14:23:21 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3C86E20043;
        Wed, 19 Jul 2023 14:23:21 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C453220040;
        Wed, 19 Jul 2023 14:23:20 +0000 (GMT)
Received: from [9.155.200.205] (unknown [9.155.200.205])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Wed, 19 Jul 2023 14:23:20 +0000 (GMT)
Message-ID: <35fbe705-34ae-b008-0ebf-b62f9d4cdd0d@linux.ibm.com>
Date:   Wed, 19 Jul 2023 16:23:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v21 20/20] tests/avocado: s390x cpu topology bad move
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
 <20230630091752.67190-21-pmorel@linux.ibm.com>
 <2b7a0291-dd7d-a6b6-d269-d23d115a76a4@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <2b7a0291-dd7d-a6b6-d269-d23d115a76a4@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: elJ6hokDd0WFFtbhkfsBDCYXvRCsWsme
X-Proofpoint-GUID: 1wDsTjnwhK1xtvq7nA28Fw16nQB0Nw37
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-19_09,2023-07-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 priorityscore=1501 impostorscore=0 adultscore=0 mlxscore=0 phishscore=0
 bulkscore=0 mlxlogscore=999 malwarescore=0 suspectscore=0 clxscore=1015
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2307190126
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 7/5/23 12:32, Thomas Huth wrote:
> On 30/06/2023 11.17, Pierre Morel wrote:
>> This test verifies that QEMU refuses to move a CPU to an
>> unexistant location.
>
> s/unexistant/nonexistent/ ?
>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   tests/avocado/s390_topology.py | 25 +++++++++++++++++++++++++
>>   1 file changed, 25 insertions(+)
>>
>> diff --git a/tests/avocado/s390_topology.py 
>> b/tests/avocado/s390_topology.py
>> index 99d9508cef..ea39168b53 100644
>> --- a/tests/avocado/s390_topology.py
>> +++ b/tests/avocado/s390_topology.py
>> @@ -388,3 +388,28 @@ def test_dedicated_error(self):
>>           res = self.vm.qmp('set-cpu-topology',
>>                             {'core-id': 0, 'entitlement': 'medium', 
>> 'dedicated': False})
>>           self.assertEqual(res['return'], {})
>> +
>> +    def test_move_error(self):
>> +        """
>> +        This test verifies that QEMU refuses to move a CPU to an
>> +        unexistant location
>
> s/unexistant/nonexistent/ ?
>
> With the words fixed:
> Reviewed-by: Thomas Huth <thuth@redhat.com>
>
I fix it, thanks,

Regards,

Pierre

