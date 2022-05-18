Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8FE152B855
	for <lists+kvm@lfdr.de>; Wed, 18 May 2022 13:13:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235351AbiERLHS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 May 2022 07:07:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235307AbiERLHN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 May 2022 07:07:13 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DEC9326CF;
        Wed, 18 May 2022 04:07:12 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24IAiChI015722;
        Wed, 18 May 2022 11:07:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=4G/P7E5ruyfS1Ux0LFi9e/dn4hKkLtvsYmSWrlPYPu4=;
 b=SdmW9m/0j7Er8lB9yZ2YXo1YClRw1M/UswVjNItE/ZYvaWkJpjkkSgLDxuJRwsKTHHKk
 Exthw+LGlolAKKlJLvsyru9DwC0M5ThvqeeoAyRwLhtxFxuiJK81pP2FmaJNp7AcVNBU
 ioYYbtrET21kEXZAQury7BnK+WlkfIUlZrVIn3UAT7kpd9WKBji5x0Ay3/+ASO44z+GB
 fPDCpYvZvXDO6diohb74+xH36yk2Puv3oK8KxaDfu7zSRLeEQcPpEguVnEi0k2o+bYJC
 90HHbFgtrFkRdOmwVaYvnQWPGUzCoxK7+ZkBZPx2tYzGzlVPlLdXH85/1Nl4imtgxFMJ oQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g4yae8ftj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 May 2022 11:07:12 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24IAongg005338;
        Wed, 18 May 2022 11:07:11 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g4yae8fs2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 May 2022 11:07:11 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24IB48oe017813;
        Wed, 18 May 2022 11:07:09 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04fra.de.ibm.com with ESMTP id 3g2428vgrm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 May 2022 11:07:08 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24IB75aQ38076780
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 May 2022 11:07:05 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C00384C050;
        Wed, 18 May 2022 11:07:05 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6E56A4C040;
        Wed, 18 May 2022 11:07:05 +0000 (GMT)
Received: from [9.171.23.83] (unknown [9.171.23.83])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 18 May 2022 11:07:05 +0000 (GMT)
Message-ID: <79585ac9-61cc-52a6-6df4-ca1530dbbc9f@linux.ibm.com>
Date:   Wed, 18 May 2022 13:07:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [kvm-unit-tests PATCH] s390x: Ignore gcc 12 warnings for low
 addresses
Content-Language: en-US
To:     Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Sven Schnelle <svens@linux.ibm.com>
References: <20220516144332.3785876-1-scgl@linux.ibm.com>
 <20220517140206.6a58760f@p-imbrenda>
 <15aee36c-de22-5f2a-d32b-b74cddebfc1c@redhat.com>
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
In-Reply-To: <15aee36c-de22-5f2a-d32b-b74cddebfc1c@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: nh_IoJSZ0wqZgRPWruBYYcRUiHPIWWe2
X-Proofpoint-GUID: -U5jXWq3JrvfK31MQj5pKy7TV9bKM182
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-18_03,2022-05-17_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 bulkscore=0
 lowpriorityscore=0 malwarescore=0 mlxlogscore=999 priorityscore=1501
 spamscore=0 impostorscore=0 mlxscore=0 clxscore=1015 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205180059
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/17/22 18:09, Thomas Huth wrote:
> On 17/05/2022 14.02, Claudio Imbrenda wrote:
>> On Mon, 16 May 2022 16:43:32 +0200
>> Janis Schoetterl-Glausch <scgl@linux.ibm.com> wrote:
>>
>>> gcc 12 warns if a memory operand to inline asm points to memory in the
>>> first 4k bytes. However, in our case, these operands are fine, either
>>> because we actually want to use that memory, or expect and handle the
>>> resulting exception.
>>> Therefore, silence the warning.
>>
>> I really dislike this
> 
> I agree the pragmas are ugly. But maybe we should mimic what the kernel
> is doing here?
> 
> $ git show 8b202ee218395
> commit 8b202ee218395319aec1ef44f72043e1fbaccdd6
> Author: Sven Schnelle <svens@linux.ibm.com>
> Date:   Mon Apr 25 14:17:42 2022 +0200
> 
>     s390: disable -Warray-bounds
>         gcc-12 shows a lot of array bound warnings on s390. This is caused
>     by the S390_lowcore macro which uses a hardcoded address of 0.
>         Wrapping that with absolute_pointer() works, but gcc no longer knows
>     that a 12 bit displacement is sufficient to access lowcore. So it
>     emits instructions like 'lghi %r1,0; l %rx,xxx(%r1)' instead of a
>     single load/store instruction. As s390 stores variables often
>     read/written in lowcore, this is considered problematic. Therefore
>     disable -Warray-bounds on s390 for gcc-12 for the time being, until
>     there is a better solution.
> 
> ... so we should maybe disable it in the Makefile, too, until the
> kernel folks found a nicer solution?
> 
>  Thomas
> 

Neat, wasn't aware of that commit.

I don't think we need to concern ourselves with performance in this case and can define

+#define HIDE_PTR(ptr)                          \
+({                                             \
+       uint64_t __ptr;                         \
+       asm ("" : "=d" (__ptr) : "0" (ptr));    \
+       (typeof(ptr))__ptr;                     \
+})
+

in some header (which?).

Another alternative would be to define some extern symbols for the addresses we want to use.
It might be nice to have a symbol for the lowcore anyway, then we can get rid of

static struct lowcore *lc;
struct lowcore *lc = (struct lowcore *)0x0;
...

in a bunch of tests.

And use that symbol to derive the addresses we want to use.
emulator.c uses -1 to generate an addressing exception, we either need another symbol for
that or use another invalid address. (Can't get to -1 from lowcore/0 because the max array
size is signed int64 max)
