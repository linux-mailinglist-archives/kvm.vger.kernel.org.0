Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEA85750B2F
	for <lists+kvm@lfdr.de>; Wed, 12 Jul 2023 16:40:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231956AbjGLOkt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jul 2023 10:40:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229829AbjGLOkr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jul 2023 10:40:47 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2F271991
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 07:40:46 -0700 (PDT)
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36CEeEBS019021;
        Wed, 12 Jul 2023 14:40:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=CroH0d9eY8sfAInGxE2rMRCWuXQPKYDN+Bq3iU/yqpM=;
 b=gUyvKmvTsRYqWB0oPPNMDXVykbnYY488Q0uAaNgstzvEcOpCSq8AodblnjugXzfJyzFJ
 BXjRRbSbsHzh92O/9/Z1jfioLDvB0rrKxhabQggXnI6jOFIlClrht7idkG6bOO0d/RJK
 DG6IJHU+Xaw1ocZhSBOlUPyLiBV2qP5BAA1KG77MXuHtSICNx79OEQhFbkQgdsoXuoJl
 hS1oG6QFXvlAGCwkKaSH9TklC24CWL77k75Ksu6+qQBI+JyrmR2sU3NcwkP4R11/u3Ln
 MH6inSoBD+regtfxEalZ2iKi1/XhDcjbgKIDTYAbWfFo/lNmj7LqGceiw7dXxQvUC34N EQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rswv28h8q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Jul 2023 14:40:34 +0000
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36CEeXVn021816;
        Wed, 12 Jul 2023 14:40:33 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rswv28h5b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Jul 2023 14:40:33 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36CBrhds029558;
        Wed, 12 Jul 2023 14:40:31 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma02fra.de.ibm.com (PPS) with ESMTPS id 3rpye5hydx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Jul 2023 14:40:30 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36CEeQWc44696026
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Jul 2023 14:40:26 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7653B20049;
        Wed, 12 Jul 2023 14:40:26 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E6B7420040;
        Wed, 12 Jul 2023 14:40:25 +0000 (GMT)
Received: from [9.152.222.242] (unknown [9.152.222.242])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Wed, 12 Jul 2023 14:40:25 +0000 (GMT)
Message-ID: <cbf9bcf3-223d-39ac-7006-4f8d37e71056@linux.ibm.com>
Date:   Wed, 12 Jul 2023 16:40:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v21 06/20] s390x/cpu topology: interception of PTF
 instruction
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
 <20230630091752.67190-7-pmorel@linux.ibm.com>
 <ab53c709-964b-452e-9cb2-c4c8d67d318f@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <ab53c709-964b-452e-9cb2-c4c8d67d318f@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: MrRWiK20HzOf-XT4bUBUGGCHn3QUfXZ4
X-Proofpoint-GUID: UQDG8zKQWIg1UaP9oebl8INPoQ_y6hYn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-12_09,2023-07-11_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 mlxscore=0
 clxscore=1015 adultscore=0 impostorscore=0 lowpriorityscore=0
 suspectscore=0 bulkscore=0 mlxlogscore=999 spamscore=0 priorityscore=1501
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2307120131
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 7/4/23 14:16, Thomas Huth wrote:
> On 30/06/2023 11.17, Pierre Morel wrote:
>> When the host supports the CPU topology facility, the PTF
>> instruction with function code 2 is interpreted by the SIE,
>> provided that the userland hypervisor activates the interpretation
>> by using the KVM_CAP_S390_CPU_TOPOLOGY KVM extension.
>>
>> The PTF instructions with function code 0 and 1 are intercepted
>> and must be emulated by the userland hypervisor.
>>
>> During RESET all CPU of the configuration are placed in
>> horizontal polarity.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> Reviewed-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
>> ---
>>   include/hw/s390x/s390-virtio-ccw.h |  6 ++++
>>   hw/s390x/cpu-topology.c            | 54 ++++++++++++++++++++++++++++++
>>   target/s390x/kvm/kvm.c             | 11 ++++++
>>   3 files changed, 71 insertions(+)
>
>
> Reviewed-by: Thomas Huth <thuth@redhat.com>
>

Thanks,

Pierre

