Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5601364B6AE
	for <lists+kvm@lfdr.de>; Tue, 13 Dec 2022 15:01:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235776AbiLMOBK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Dec 2022 09:01:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235771AbiLMOBH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Dec 2022 09:01:07 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E7421B78C
        for <kvm@vger.kernel.org>; Tue, 13 Dec 2022 06:01:03 -0800 (PST)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BDD7wrn030621;
        Tue, 13 Dec 2022 14:00:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Be2613vPcDXFCaoEzg3yxkoca/+V5bKMGnQFiiDDsbU=;
 b=LZpOjC2snaMJLullDsOCwhH5e4qqjAVskDWt3BP2TuTyqdIq2wAbG/qhjAkIcSLD/sBS
 DM6TtCz9RQ1ygc3xJpv2jRgWJ+/3pZLwrOuVEN2uLhuxqUa92VDdeSq54tIXDEX6fJsy
 /JNF7PELBjOVT9WC2Mw/6gcuX9cWrS+A+PV+/KjKK8ZNCHNL3OXCol8JF3+/XLvsKrzX
 ZfpyFsci0sEXfdBQbWTtvX9H8HmCHN+NpiLK7hpVqqIx0jYGufxeCRYwaYULNvEKwIkU
 CDUIxbL4Az+HhwyQx91SdM+friJ1FQzVetYuqOdytuobLApcNOGmeg8Ac6E/13o0QQZS 7g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3merxu384x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Dec 2022 14:00:50 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2BDD8RPU032310;
        Tue, 13 Dec 2022 14:00:49 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3merxu3837-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Dec 2022 14:00:49 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BD5ZcJo030834;
        Tue, 13 Dec 2022 14:00:47 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3mchr5v8uj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Dec 2022 14:00:46 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BDE0hDn19857830
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Dec 2022 14:00:43 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4F6C320067;
        Tue, 13 Dec 2022 14:00:43 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 11BED2005A;
        Tue, 13 Dec 2022 14:00:42 +0000 (GMT)
Received: from [9.171.21.177] (unknown [9.171.21.177])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 13 Dec 2022 14:00:41 +0000 (GMT)
Message-ID: <2c78ec97-647b-d02f-f26e-caf4ef6a7357@de.ibm.com>
Date:   Tue, 13 Dec 2022 15:00:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v13 0/7] s390x: CPU Topology
Content-Language: en-US
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>,
        Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        frankja@linux.ibm.com, berrange@redhat.com, clg@kaod.org
References: <20221208094432.9732-1-pmorel@linux.ibm.com>
 <8c0777d2-7b70-51ce-e64a-6aff5bdea8ae@redhat.com>
 <60f006f4-d29e-320a-d656-600b2fd4a11a@linux.ibm.com>
 <864cc127-2dbd-3792-8851-937ef4689503@redhat.com>
 <90514038-f10c-33e7-3600-e3131138a44d@linux.ibm.com>
 <73238c6c-a9dc-9d18-8ffb-92c8a41922d3@redhat.com>
 <b36eef2e-92ed-a0ea-0728-4a5ea5bf25d9@de.ibm.com>
 <00a4750ac9874d5bb41221468f4bd01136f446c9.camel@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
In-Reply-To: <00a4750ac9874d5bb41221468f4bd01136f446c9.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 1Ey3i4CPJOXX6q32y8XsxJt9zaYKVDVW
X-Proofpoint-ORIG-GUID: eQBGNudQEB7QncYIqBt8qKvLdm6Qnm9u
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-13_03,2022-12-13_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 adultscore=0 clxscore=1015 phishscore=0 malwarescore=0 spamscore=0
 bulkscore=0 mlxlogscore=999 impostorscore=0 priorityscore=1501
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212130120
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 13.12.22 um 14:57 schrieb Janis Schoetterl-Glausch:
> On Tue, 2022-12-13 at 14:41 +0100, Christian Borntraeger wrote:
>>
>> Am 12.12.22 um 11:17 schrieb Thomas Huth:
>>> On 12/12/2022 11.10, Pierre Morel wrote:
>>>>
>>>>
>>>> On 12/12/22 10:07, Thomas Huth wrote:
>>>>> On 12/12/2022 09.51, Pierre Morel wrote:
>>>>>>
>>>>>>
>>>>>> On 12/9/22 14:32, Thomas Huth wrote:
>>>>>>> On 08/12/2022 10.44, Pierre Morel wrote:
>>>>>>>> Hi,
>>>>>>>>
>>>>>>>> Implementation discussions
>>>>>>>> ==========================
>>>>>>>>
>>>>>>>> CPU models
>>>>>>>> ----------
>>>>>>>>
>>>>>>>> Since the S390_FEAT_CONFIGURATION_TOPOLOGY is already in the CPU model
>>>>>>>> for old QEMU we could not activate it as usual from KVM but needed
>>>>>>>> a KVM capability: KVM_CAP_S390_CPU_TOPOLOGY.
>>>>>>>> Checking and enabling this capability enables
>>>>>>>> S390_FEAT_CONFIGURATION_TOPOLOGY.
>>>>>>>>
>>>>>>>> Migration
>>>>>>>> ---------
>>>>>>>>
>>>>>>>> Once the S390_FEAT_CONFIGURATION_TOPOLOGY is enabled in the source
>>>>>>>> host the STFL(11) is provided to the guest.
>>>>>>>> Since the feature is already in the CPU model of older QEMU,
>>>>>>>> a migration from a new QEMU enabling the topology to an old QEMU
>>>>>>>> will keep STFL(11) enabled making the guest get an exception for
>>>>>>>> illegal operation as soon as it uses the PTF instruction.
>>>>>>>
>>>>>>> I now thought that it is not possible to enable "ctop" on older QEMUs since the don't enable the KVM capability? ... or is it still somehow possible? What did I miss?
>>>>>>>
>>>>>>>    Thomas
>>>>>>
>>>>>> Enabling ctop with ctop=on on old QEMU is not possible, this is right.
>>>>>> But, if STFL(11) is enable in the source KVM by a new QEMU, I can see that even with -ctop=off the STFL(11) is migrated to the destination.
>>
>> This does not make sense. the cpu model and stfle values are not migrated. This is re-created during startup depending on the command line parameters of -cpu.
>> Thats why source and host have the same command lines for -cpu. And STFLE.11 must not be set on the SOURCE of ctop is off.
>>
> What about linux? I didn't look to thoroughly at it, but it caches the stfle bits, doesn't it?
> So if the migration succeeds, even tho it should not, it will look to the guest like the facility is enabled.

That is true, but the migration should not succeed in that case unless you use an unsafe way of migrating. And the cpu model was exactly added to block those unsafe way.
One thing:
-cpu host is unsafe (host-passthrough in libvirt speak). Either use host-model or a fully specified model like z14.2,ctop=on....

