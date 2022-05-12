Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6ACFF525283
	for <lists+kvm@lfdr.de>; Thu, 12 May 2022 18:27:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356473AbiELQ1H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 12:27:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356474AbiELQ1D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 12:27:03 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B578F39685;
        Thu, 12 May 2022 09:26:52 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24CGAbaU014057;
        Thu, 12 May 2022 16:26:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=gzLhFn1d7O2mtJvF5hDXUrpGu0kE6GQoNg6tjaVkOBg=;
 b=nMpjRGZ4a3o0Lf/oOgHMnqql9eMrfKGMHwo/6MEmiL2d1zKt4OJS9s5vyUaG+B5Xtfmb
 NFc3rfCxVlgzeUezON1RP22u4YIIFTCmXyfLZjD/AKGJ2FAx3/klp3hUOREGcRku2HN4
 VAEux1UbQkoz1OlcaAwlOMmG+08lQZlzlXLCCIaNVWBFoKJpBwqp40gryN0PTixZ51ul
 lpLvi6+tUc1zktThLJZJF+rJsf4Q/WCXz9/4cMymvUuS+6YKyGZXzdOqWUJ7kmRTmbdC
 HaVXDEiJBckrATtsPHgbCLVJms+1TNBW0mY0vatz8cM4e2T6Gy34wQSHwJdXy4wNW1QB Cg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g155bgtrw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 16:26:51 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24CGEWRW032539;
        Thu, 12 May 2022 16:26:50 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g155bgtr4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 16:26:50 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24CGHTBg019265;
        Thu, 12 May 2022 16:26:48 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 3fwgd8yaes-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 16:26:48 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24CGD67751052984
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 May 2022 16:13:06 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 51FE642049;
        Thu, 12 May 2022 16:26:45 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BCB1642041;
        Thu, 12 May 2022 16:26:44 +0000 (GMT)
Received: from [9.171.35.160] (unknown [9.171.35.160])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 12 May 2022 16:26:44 +0000 (GMT)
Message-ID: <9ad7acb4-2729-15bb-7b25-eb95c4a12f09@linux.ibm.com>
Date:   Thu, 12 May 2022 18:26:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v3 1/2] KVM: s390: Don't indicate suppression on dirtying,
 failing memop
Content-Language: en-US
To:     David Hildenbrand <david@redhat.com>,
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>
Cc:     Sven Schnelle <svens@linux.ibm.com>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20220512131019.2594948-1-scgl@linux.ibm.com>
 <20220512131019.2594948-2-scgl@linux.ibm.com>
 <77f6f5e7-5945-c478-0e41-affed62252eb@redhat.com>
 <4a06e3e8-4453-9204-eb66-d435860c5714@linux.ibm.com>
 <701033df-49c5-987e-b316-40835ad83d16@redhat.com>
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <701033df-49c5-987e-b316-40835ad83d16@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 4Hl7VkubwiwNUy3jI3wDZ5nauu-IAP56
X-Proofpoint-ORIG-GUID: 6A1JC_-JxCN6SwbqPoqNCX1GGAoWAidA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-12_13,2022-05-12_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 impostorscore=0
 mlxscore=0 clxscore=1015 bulkscore=0 mlxlogscore=999 phishscore=0
 spamscore=0 malwarescore=0 suspectscore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205120076
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 12.05.22 um 17:50 schrieb David Hildenbrand:
> On 12.05.22 15:51, Christian Borntraeger wrote:
>>
>>
>> Am 12.05.22 um 15:22 schrieb David Hildenbrand:
>>> On 12.05.22 15:10, Janis Schoetterl-Glausch wrote:
>>>> If user space uses a memop to emulate an instruction and that
>>>> memop fails, the execution of the instruction ends.
>>>> Instruction execution can end in different ways, one of which is
>>>> suppression, which requires that the instruction execute like a no-op.
>>>> A writing memop that spans multiple pages and fails due to key
>>>> protection may have modified guest memory, as a result, the likely
>>>> correct ending is termination. Therefore, do not indicate a
>>>> suppressing instruction ending in this case.
>>>
>>> I think that is possibly problematic handling.
>>>
>>> In TCG we stumbled in similar issues in the past for MVC when crossing
>>> page boundaries. Failing after modifying the first page already
>>> seriously broke some user space, because the guest would retry the
>>> instruction after fixing up the fault reason on the second page: if
>>> source and destination operands overlap, you'll be in trouble because
>>> the input parameters already changed.
>>>
>>> For this reason, in TCG we make sure that all accesses are valid before
>>> starting modifications.
>>>
>>> See target/s390x/tcg/mem_helper.c:do_helper_mvc with access_prepare()
>>> and friends as an example.
>>>
>>> Now, I don't know how to tackle that for KVM, I just wanted to raise
>>> awareness that injecting an interrupt after modifying page content is
>>> possible dodgy and dangerous.
>>
>> this is really special and only for key protection crossing pages.
>> Its been done since the 70ies in that way on z/VM. The architecture
>> is and was always written in a way to allow termination for this
>> case for hypervisors.
> 
> Just so I understand correctly: all instructions that a hypervisor with
> hardware virtualization is supposed to emulate are "written in a way to
> allow termination", correct? That makes things a lot easier.

Only for key protection. Key protection can always be terminating no matter
what the instruction says. This is historical baggage - key protection was
resulting in abends - killing the process. So it does not matter if we
provide the extra info as in enhanced suppression on protection as nobody
is making use of that (apart from debuggers maybe).
  
