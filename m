Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1B8D5FB7D7
	for <lists+kvm@lfdr.de>; Tue, 11 Oct 2022 17:58:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbiJKP6i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Oct 2022 11:58:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230382AbiJKP6g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Oct 2022 11:58:36 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71C9C33362
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 08:58:35 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29BEibuL008407
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 15:58:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=YrdD2NLxOCp55qemjFEX8jsoa9WMgDOi4D6+F3LiT2w=;
 b=Sq6xuOtZUunGJmoYMX+zK+5Rk8r7umqzAac6xwYa04+hfOPcoHXBx5YHMREFCe+l2EM7
 F43scVPcKK+izNn+KKYduerAK83LY5/xtfDdyly59tD472hksPzL1ek5Q4qC2tjOctfD
 D7vHKM/+VqWjbctt0AZ+Vqce6Jp44yt1M+Difg/AyYT+l/uX0ylgUpfQwS67+Sztr5gY
 21f2cJlU0uVdRA5ACCMs/QMbeU+p9bnGx5+HujSSzUaZVM/XLP9rqprvMvGmbrMsySbi
 6WNngzzgpgkazPctVPVCgVm4qU46n0wDdFPq9yMFY8mi/p8Gxtot3cjogiRrmz1wXggp cg== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k5a6fbak4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 15:58:34 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29BFoglG016356
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 15:58:32 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 3k30u9cppm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 15:58:32 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29BFrk2N47710634
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Oct 2022 15:53:46 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 931C15204F;
        Tue, 11 Oct 2022 15:58:29 +0000 (GMT)
Received: from [9.171.36.147] (unknown [9.171.36.147])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 5B72652050;
        Tue, 11 Oct 2022 15:58:29 +0000 (GMT)
Message-ID: <70217003-867c-ce7a-7503-2e058e51995c@linux.ibm.com>
Date:   Tue, 11 Oct 2022 17:58:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [kvm-unit-tests PATCH v2 0/2] s390x: Add migration test for guest
 TOD clock
To:     Nico Boehr <nrb@linux.ibm.com>, kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com
References: <20221011151433.886294-1-nrb@linux.ibm.com>
Content-Language: en-US
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20221011151433.886294-1-nrb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: j7l-coK_fHZlR0ACng17OBysFlD3D51o
X-Proofpoint-ORIG-GUID: j7l-coK_fHZlR0ACng17OBysFlD3D51o
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-11_08,2022-10-11_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 suspectscore=0 impostorscore=0 bulkscore=0
 lowpriorityscore=0 mlxlogscore=999 clxscore=1015 mlxscore=0 adultscore=0
 spamscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210110089
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Am 11.10.22 um 17:14 schrieb Nico Boehr:
> v1->v2:
> ---
> - remove unneeded include
> - advance clock by 10 minutes instead of 1 minute (thanks Claudio)
> - express get_clock_us() using stck() (thanks Claudio)
> 
> The guest TOD clock should be preserved on migration. Add a test to
> verify that.

I do not fully agree with this assumption. Its the way it curently is, but we might want to have a configurable or different behaviour in the future.

For example if the difference is smaller than time x it could be allowed to move the time forward to get the guest synced to the new host (never go backward though).
Or to preserve the time but then slowly step towards the target system clock etc (or for this testcase step the epoch difference towards the original difference).

So we maybe want to have a comment in here somehow that this is the as-is behaviour.

> To reduce code duplication, move some of the time-related defined
> from the sck test to the library.
> 
> Nico Boehr (2):
>    lib/s390x: move TOD clock related functions to library
>    s390x: add migration TOD clock test
> 
>   lib/s390x/asm/time.h  | 50 ++++++++++++++++++++++++++++++++++++++++++-
>   s390x/Makefile        |  1 +
>   s390x/migration-sck.c | 44 +++++++++++++++++++++++++++++++++++++
>   s390x/sck.c           | 32 ---------------------------
>   s390x/unittests.cfg   |  4 ++++
>   5 files changed, 98 insertions(+), 33 deletions(-)
>   create mode 100644 s390x/migration-sck.c
> 
