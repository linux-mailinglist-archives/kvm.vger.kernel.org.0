Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE94C509FC4
	for <lists+kvm@lfdr.de>; Thu, 21 Apr 2022 14:39:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384950AbiDUMmI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Apr 2022 08:42:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238809AbiDUMmH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Apr 2022 08:42:07 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 387B921839;
        Thu, 21 Apr 2022 05:39:18 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23LBw3qM004864;
        Thu, 21 Apr 2022 12:39:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=+kgvRLmDHARgRwULOwUQD+32iZe0gP8THrq10wEwyys=;
 b=hWTpwOty+m6y+HCOPymgsC5RJMzaANX+oiJkXWBSpz51Cr1yJlMU7Y67dRQNe4vGjUbg
 t9Ftyyf4qHdsvCi+h7wn5I4l3LznUbL+QY5K/26KE8mbhjVQPix+hmT0KMDZIIaTVZGh
 m/yXDOFOiRY/oSbQFadQ+tiAmdQdnnnGNSv2k9p32lwz69aKILih2FDHIF5Al+OtrNsY
 xD37ezRuakSLKLt5p2uF/WOKEw7n/Xb5xA4RZf/BDG/aPy5p11K6r+SLiyjyvP3qMexA
 MTa5QVm6DTRaODgdiywVqHFiaC+/ZwAl/UiSYLt48GX3QEyf/4NwBvQl7prgWvSPgHZA yQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3fjer8pmhq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Apr 2022 12:39:17 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23LCBCFH024800;
        Thu, 21 Apr 2022 12:39:16 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3fjer8pmh0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Apr 2022 12:39:16 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23LCX6KU028726;
        Thu, 21 Apr 2022 12:39:14 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3ffne8quuh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Apr 2022 12:39:14 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23LCdN1l2949632
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Apr 2022 12:39:23 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C014542042;
        Thu, 21 Apr 2022 12:39:11 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5CB844203F;
        Thu, 21 Apr 2022 12:39:11 +0000 (GMT)
Received: from [9.145.69.75] (unknown [9.145.69.75])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 21 Apr 2022 12:39:11 +0000 (GMT)
Message-ID: <c3f528fc-16ff-ce88-d2ed-e8bb71cd42d2@linux.ibm.com>
Date:   Thu, 21 Apr 2022 14:39:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [kvm-unit-tests PATCH v3 00/11] s390x: Cleanup and maintenance 4
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        thuth@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com
References: <20220421101130.23107-1-frankja@linux.ibm.com>
 <20220421135920.426687fc@p-imbrenda>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20220421135920.426687fc@p-imbrenda>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 2jQA2CaF8JxTxjDo7gYwhcwfot9QgDKh
X-Proofpoint-ORIG-GUID: o2r-rMWdqPj8KyQ_FLibJJILjJfxV-9U
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-21_01,2022-04-21_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 mlxscore=0 priorityscore=1501 phishscore=0 malwarescore=0 mlxlogscore=999
 lowpriorityscore=0 spamscore=0 adultscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204210069
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/21/22 13:59, Claudio Imbrenda wrote:
> On Thu, 21 Apr 2022 10:11:19 +0000
> Janosch Frank <frankja@linux.ibm.com> wrote:
> 
>> A few small cleanups and two patches that I forgot to upstream which
>> have now been rebased onto the machine.h library functions.
> 
> thanks, queued
> 

Please drop the register restore patch #11 from your queue.

Nico rightly complained that r0/r1 are volatile and I shouldn't have to 
restore them. It's been too long for me to fully remember why I had to 
fix that. It might have been a diag308 wrongfully resetting all 
registers but not loading the reset PSW. Whatever issue I had, the 
commit message is wrong anyway. If I'm able to remember the issue I'll 
fix and post the patch again.

>>
>> v3:
>> 	* Added review tags
>> 	* Added uv-host and diag308 fix
>> 	* Diag308 subcode 2 patch, moved the prefix push and pop outside of the if
>>
>> v2:
>> 	* Added host_is_qemu() function
>> 	* Fixed qemu checks
>>
>> Janosch Frank (11):
>>    lib: s390x: hardware: Add host_is_qemu() function
>>    s390x: css: Skip if we're not run by qemu
>>    s390x: diag308: Only test subcode 2 under QEMU
>>    s390x: pfmf: Initialize pfmf_r1 union on declaration
>>    s390x: snippets: asm: Add license and copyright headers
>>    s390x: pv-diags: Cleanup includes
>>    s390x: css: Cleanup includes
>>    s390x: iep: Cleanup includes
>>    s390x: mvpg: Cleanup includes
>>    s390x: uv-host: Fix pgm tests
>>    s390x: Restore registers in diag308_load_reset() error path
>>
>>   lib/s390x/hardware.h                       |  5 +++
>>   s390x/cpu.S                                |  1 +
>>   s390x/css.c                                | 18 ++++++----
>>   s390x/diag308.c                            | 18 +++++++++-
>>   s390x/iep.c                                |  3 +-
>>   s390x/mvpg.c                               |  3 --
>>   s390x/pfmf.c                               | 39 +++++++++++-----------
>>   s390x/pv-diags.c                           | 17 ++--------
>>   s390x/snippets/asm/snippet-pv-diag-288.S   |  9 +++++
>>   s390x/snippets/asm/snippet-pv-diag-500.S   |  9 +++++
>>   s390x/snippets/asm/snippet-pv-diag-yield.S |  9 +++++
>>   s390x/uv-host.c                            |  2 +-
>>   12 files changed, 85 insertions(+), 48 deletions(-)
>>
> 

