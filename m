Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0AB551173B
	for <lists+kvm@lfdr.de>; Wed, 27 Apr 2022 14:46:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234510AbiD0MqT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Apr 2022 08:46:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234511AbiD0MqP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Apr 2022 08:46:15 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0995F85954;
        Wed, 27 Apr 2022 05:43:04 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23RCGGI7020538;
        Wed, 27 Apr 2022 12:43:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : to : cc : references : from : subject : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=O0YgvB+zJUQMRILQeCWcoeDSkhXFN9fzr0eKGWf92ks=;
 b=UZb6RfMOVCFqRSPZpSaVdPbHerjS80UI0SUn+IC8KU4VN0xwoxgVkdFKMDq663JE+mqZ
 64HL00hpMF9dnpTWMt4IGykPcOtkj0lFMFnH1Xu0V097LVRkcR0o65SjLi26AuxOW5kt
 57XuccWzqROD191Cz4rrIPyhjptZDfS+6U0JlGkIuvoxev5mfRWjkXxU9fFqCHr+O51v
 qyRpDgBvy0pZR8FqJ7LfhPTHyoUCytj/JGE9e3iMxw2lfmHo/TjMthua7Y2kfgW7RKb5
 Efq/ugazeDJp2hUpr+Ld+Krs8U+tW//NGKrHwiXBF2O31PRLLrO2sN8GkT+F6Lo7ShOp +w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fpustuanh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Apr 2022 12:43:03 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 23RBuMBd015264;
        Wed, 27 Apr 2022 12:43:03 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fpustuak8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Apr 2022 12:43:03 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23RCgXo8006409;
        Wed, 27 Apr 2022 12:43:01 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 3fm938wxsw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Apr 2022 12:43:00 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23RCgvxA43057456
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Apr 2022 12:42:57 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A3A954C046;
        Wed, 27 Apr 2022 12:42:57 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 589954C040;
        Wed, 27 Apr 2022 12:42:57 +0000 (GMT)
Received: from [9.145.9.25] (unknown [9.145.9.25])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 27 Apr 2022 12:42:57 +0000 (GMT)
Message-ID: <b20b87af-562b-c50e-8441-26ecc986b9ec@linux.ibm.com>
Date:   Wed, 27 Apr 2022 14:42:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Content-Language: en-US
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20220427100611.2119860-1-scgl@linux.ibm.com>
 <20220427100611.2119860-2-scgl@linux.ibm.com>
 <20220427131449.61cce697@p-imbrenda>
 <9869b838-0070-ae67-737f-2bd3d0e21d60@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v6 1/3] s390x: Give name to return value of
 tprot()
In-Reply-To: <9869b838-0070-ae67-737f-2bd3d0e21d60@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 9ah9yDkjBfw-w2ThLr0B5si2LwGw1Exf
X-Proofpoint-ORIG-GUID: eiUf7XymvbOaWkJ4vd9gVWN4Az5tpx6S
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-27_04,2022-04-27_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 bulkscore=0
 clxscore=1015 malwarescore=0 phishscore=0 suspectscore=0
 lowpriorityscore=0 priorityscore=1501 mlxlogscore=999 spamscore=0
 mlxscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204270082
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/27/22 14:04, Janis Schoetterl-Glausch wrote:
> On 4/27/22 13:14, Claudio Imbrenda wrote:
>> On Wed, 27 Apr 2022 12:06:09 +0200
>> Janis Schoetterl-Glausch <scgl@linux.ibm.com> wrote:
>>
>>> Improve readability by making the return value of tprot() an enum.
>>>
>>> No functional change intended.
>>
>> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
>>
>> but see nit below
>>
>>>
>>> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
>>> ---
>>>   lib/s390x/asm/arch_def.h | 11 +++++++++--
>>>   lib/s390x/sclp.c         |  6 +++---
>>>   s390x/tprot.c            | 24 ++++++++++++------------
>>>   3 files changed, 24 insertions(+), 17 deletions(-)
> 
> [...]
> 
>>> diff --git a/s390x/tprot.c b/s390x/tprot.c
>>> index 460a0db7..8eb91c18 100644
>>> --- a/s390x/tprot.c
>>> +++ b/s390x/tprot.c
>>> @@ -20,26 +20,26 @@ static uint8_t pagebuf[PAGE_SIZE] __attribute__((aligned(PAGE_SIZE)));
>>>   
>>>   static void test_tprot_rw(void)
>>>   {
>>> -	int cc;
>>> +	enum tprot_permission permission;
>>>   
>>>   	report_prefix_push("Page read/writeable");
>>>   
>>> -	cc = tprot((unsigned long)pagebuf, 0);
>>> -	report(cc == 0, "CC = 0");
>>> +	permission = tprot((unsigned long)pagebuf, 0);
>>> +	report(permission == TPROT_READ_WRITE, "CC = 0");
>>
>> here and in all similar cases below: does it still make sense to have
>> "CC = 0" as message at this point? Maybe a more descriptive one would
>> be better
> 
> I thought about it, but decided against it. Firstly, because I preferred
> not to do any functional changes and secondly, I could not think of anything
> better. The prefix already tells you the meaning of the cc, so I don't know
> what to print that would not be redundant.
> 
> [...]

I'm ok with that for now especially considering we're at v6 already and 
functionally this looks good.

Let's add the series to the devel branch so the CI can have a look at it 
before we pick it.

Reviewed-by: Janosch Frank <frankja@linux.ibm.com >
