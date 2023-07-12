Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E1297502A5
	for <lists+kvm@lfdr.de>; Wed, 12 Jul 2023 11:16:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232052AbjGLJQW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jul 2023 05:16:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230236AbjGLJQU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jul 2023 05:16:20 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C471EF9;
        Wed, 12 Jul 2023 02:16:19 -0700 (PDT)
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36C9C845014620;
        Wed, 12 Jul 2023 09:16:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=QxcNhyLOKrADLmSpCTZB/0QN0y+AJYy6OP73uPNx4R0=;
 b=PthHjIniExw2JjP42q+xl7wY1qUhBZVPTjXBaJKBxnmt0BrWCRJv9aaHOw9hGc42mQHm
 PnuyS/LvQj1NRZPPXcDUHBfGav4wdgk2zF/RqXSXx2aNrnJjpNIA3EEXQtpd4+r0vPkH
 PuN82Y77KXRAZdVcJGDvB08UeNXWdrmvhX/w+TgLo75t8gSZVT3DClokTyEUCP5ZHxKx
 Nol02LjLZiMriNtvAoQ/X6f1ATkeRzu1QmG14GEsfQwMWjm262NBCaW2CxTVna5oEfuR
 v5bM9QhFyDA4KMxmmZ24lXuLJ+lJAZY/n/b9FYO0IJ2thbNKXxx3oWl3U3ZcoYrTPsN8 hw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rssb7ga98-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Jul 2023 09:16:18 +0000
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36C9C5sn014437;
        Wed, 12 Jul 2023 09:14:42 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rssb7g4e7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Jul 2023 09:14:42 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36C8XKtE027441;
        Wed, 12 Jul 2023 09:08:13 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma03fra.de.ibm.com (PPS) with ESMTPS id 3rpye51uev-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Jul 2023 09:08:12 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36C989BP42664460
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Jul 2023 09:08:09 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 65ADC2004F;
        Wed, 12 Jul 2023 09:08:09 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C875C2004B;
        Wed, 12 Jul 2023 09:08:08 +0000 (GMT)
Received: from [9.171.2.53] (unknown [9.171.2.53])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Wed, 12 Jul 2023 09:08:08 +0000 (GMT)
Message-ID: <b58ccb2f-7e49-3806-498d-a8cafb1c7548@linux.ibm.com>
Date:   Wed, 12 Jul 2023 11:08:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [kvm-unit-tests PATCH v10 2/2] s390x: topology: Checking
 Configuration Topology Information
Content-Language: en-US
To:     Thomas Huth <thuth@redhat.com>, Nico Boehr <nrb@linux.ibm.com>,
        linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, kvm@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, nsg@linux.ibm.com
References: <20230627082155.6375-1-pmorel@linux.ibm.com>
 <20230627082155.6375-3-pmorel@linux.ibm.com>
 <ffc48a06-52b2-fc65-e12d-58603d13b3e6@redhat.com>
 <168897816265.42553.541677592228445286@t14-nrb>
 <d52e4c34-55f0-56a5-1543-52fefb39e2a6@redhat.com>
 <168906286416.9488.17612605115280167157@t14-nrb>
 <6c690eb9-06b1-a5e8-4875-e0d83f8d1ce7@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <6c690eb9-06b1-a5e8-4875-e0d83f8d1ce7@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: KN6ENInQlxRbSES3eQ58N_lpX3Dnr-oh
X-Proofpoint-ORIG-GUID: St_z-W27nBfQtFNWuSFrOregfjWbrQMY
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-12_06,2023-07-11_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 mlxscore=0 malwarescore=0 adultscore=0 impostorscore=0
 spamscore=0 mlxlogscore=977 bulkscore=0 suspectscore=0 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2307120079
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 7/11/23 10:43, Thomas Huth wrote:
> On 11/07/2023 10.07, Nico Boehr wrote:
>> Quoting Thomas Huth (2023-07-10 16:38:22)
>>> On 10/07/2023 10.36, Nico Boehr wrote:
>>>> Quoting Thomas Huth (2023-07-06 12:48:50)
>>>> [...]
>>>>> Does this patch series depend on some other patches that are not 
>>>>> upstream
>>>>> yet? I just tried to run the test, but I'm only getting:
>>>>>
>>>>>     lib/s390x/sclp.c:122: assert failed: read_info
>>>>>
>>>>> Any ideas what could be wrong?
>>>>
>>>> Yep, as you guessed this depends on:
>>>> Fixing infinite loop on SCLP READ SCP INFO error
>>>> https://lore.kernel.org/all/20230601164537.31769-1-pmorel@linux.ibm.com/ 
>>>>
>>>
>>> Ok, that fixes the assertion, but now I get a test failure:
>>>
>>> ABORT: READ_SCP_INFO failed
>>>
>>> What else could I be missing?
>>
>> Argh, I forgot that you need this fixup to the patch:
>> https://lore.kernel.org/all/269afffb-2d56-3b2f-9d83-485d0d29fab5@linux.ibm.com/ 
>>
>>
>> If that doesn't work, let me know, so I can try and reproduce it here.
>
> Thank you very much, removing that line fixed the problem, indeed. 
> Both topology tests are passing now on my z15 LPAR.
>
> Tested-by: Thomas Huth <thuth@redhat.com>
>
>
Thanks,

Pierre

