Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48FDD649B03
	for <lists+kvm@lfdr.de>; Mon, 12 Dec 2022 10:23:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230434AbiLLJXL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Dec 2022 04:23:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231993AbiLLJWL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Dec 2022 04:22:11 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53C4C1098
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 01:21:57 -0800 (PST)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BC8WMCh004159;
        Mon, 12 Dec 2022 09:21:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=KF+C8nMnuOW1TMXIjYmXBmjAGH0JPVpSx5Y8SF/XesQ=;
 b=Dt8dSUhkZOl9fmbKxmfnePU9L1vUM46Eg6cMCBc3txOfroRv4E4ooE+cwcyRIU34EJfg
 KhLI4cX3cPoBRflVo4l9bUAhMhDbIoHEpwu5MQwfm4i/6JRYhozcsUZYJo/3tvc6istK
 w9qkVcBtwj3/6yZWPhbu3bfa9W1Lo9/uNJ3b1IYcywJkz8PU8KOiWUfPlZw6oIlTO9+s
 ik0C7GU1PwZ887lIn5xqaUUcVD7Zqmv7wZvP74svJcunWODqDrTTPjCddvjPqN9HXwvB
 yfkGSAtQu16Nq1CCz6Y3L8ePi3avBuQjGOyWKWGJ+pWZSkCXBsAAo80DNY6AnWJWvONF yg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3md40kktpj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Dec 2022 09:21:45 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2BC99Hak006474;
        Mon, 12 Dec 2022 09:21:44 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3md40kktne-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Dec 2022 09:21:44 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BC6Licg026302;
        Mon, 12 Dec 2022 09:21:42 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma01fra.de.ibm.com (PPS) with ESMTPS id 3mchr61qfg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Dec 2022 09:21:41 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BC9LceW24576508
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Dec 2022 09:21:38 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 193E520040;
        Mon, 12 Dec 2022 09:21:38 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DF66620043;
        Mon, 12 Dec 2022 09:21:36 +0000 (GMT)
Received: from [9.171.10.222] (unknown [9.171.10.222])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 12 Dec 2022 09:21:36 +0000 (GMT)
Message-ID: <ba68a18a-8a72-3c37-8a7b-59c8a1b82f6a@linux.ibm.com>
Date:   Mon, 12 Dec 2022 10:21:36 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v13 2/7] s390x/cpu topology: reporting the CPU topology to
 the guest
Content-Language: en-US
To:     =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>,
        qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, scgl@linux.ibm.com,
        frankja@linux.ibm.com, berrange@redhat.com
References: <20221208094432.9732-1-pmorel@linux.ibm.com>
 <20221208094432.9732-3-pmorel@linux.ibm.com>
 <d952f626-52bf-324b-c925-f118cd75c55e@kaod.org>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <d952f626-52bf-324b-c925-f118cd75c55e@kaod.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: j7tkayZkv3uOmFzYn43iK9AHTeajO6ik
X-Proofpoint-ORIG-GUID: _4byn6QCCvW8UGCklL-J8Ko4DkPrUUqZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-12_02,2022-12-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 phishscore=0 mlxlogscore=999 impostorscore=0 suspectscore=0 spamscore=0
 mlxscore=0 clxscore=1015 adultscore=0 priorityscore=1501
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212120084
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 12/9/22 16:43, Cédric Le Goater wrote:
> On 12/8/22 10:44, Pierre Morel wrote:
>> The guest uses the STSI instruction to get information on the
>> CPU topology.
>>
>> Let us implement the STSI instruction for the basis CPU topology
>> level, level 2.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---

...

>> +#define S390_TOPOLOGY_MAX_MNEST 2
>> +
>> +void insert_stsi_15_1_x(S390CPU *cpu, int sel2, __u64 addr, uint8_t ar)
>> +{
>> +    union {
>> +        char place_holder[S390_TOPOLOGY_SYSIB_SIZE];
>> +        SysIB_151x sysib;
>> +    } buffer QEMU_ALIGNED(8);
>> +    int len;
>> +
>> +    if (s390_is_pv() || !s390_has_topology() ||
> 
> Isn't the test s390_is_pv() redundant since patch 6 deactivates
> S390_FEAT_CONFIGURATION_TOPOLOGY for PV guests ?

Yes you are right it is.
I remove it.

Regards,
Pierre



-- 
Pierre Morel
IBM Lab Boeblingen
