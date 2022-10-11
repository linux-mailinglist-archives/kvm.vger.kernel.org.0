Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4872A5FB815
	for <lists+kvm@lfdr.de>; Tue, 11 Oct 2022 18:15:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229739AbiJKQP3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Oct 2022 12:15:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbiJKQPZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Oct 2022 12:15:25 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1487A71BC3
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 09:15:23 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29BG9BXA029075
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 16:15:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=8yXPogZngpuWHN6b3FoaGaANXS8D3bfpNdhz/BGvLIA=;
 b=ZOEi4/7INPwnvWj/ueY3UrMiD0DQiQq531vwrylSxw/I1Dx0P+BrlV1vxJk85oRaMwEV
 m8T8q2x/2pvUbQ9jouTAZKu+bYDHFH0knbWCpiCvIcGG0BeDFGSDyAOOBb3zXXVwigRd
 /R4ffrrmbGSCt+k1UYf4H6gZTB/YYOkeySCSEwhR6FCwMl1qWeE/3Gv4wJHPvWMJQPWR
 nLsQstaVoOKst2BydfHNiijXs3KbhheDOJzI8X6yVN8l3dSspYXkqDIHVRXnPjMqU9sO
 wi6cpkqlvrXsXdDex0s+cnpuyGA8ZOHrYxqty1b9bW0dwnktT5B6I8vlv99f0Pra7KSq CA== 
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k59xumm9j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 16:15:23 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29BG5Ltt013699
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 16:15:21 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06fra.de.ibm.com with ESMTP id 3k30fj3htp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 16:15:21 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29BGFILg5178016
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Oct 2022 16:15:18 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F105A52051;
        Tue, 11 Oct 2022 16:15:17 +0000 (GMT)
Received: from [9.171.36.147] (unknown [9.171.36.147])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id B93D152050;
        Tue, 11 Oct 2022 16:15:17 +0000 (GMT)
Message-ID: <cf3fbf75-076f-b5c3-39c8-b490dfe660e1@linux.ibm.com>
Date:   Tue, 11 Oct 2022 18:15:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [kvm-unit-tests PATCH v2 0/2] s390x: Add migration test for guest
 TOD clock
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Nico Boehr <nrb@linux.ibm.com>, kvm@vger.kernel.org,
        frankja@linux.ibm.com
References: <20221011151433.886294-1-nrb@linux.ibm.com>
 <70217003-867c-ce7a-7503-2e058e51995c@linux.ibm.com>
 <20221011181037.73ae8aa9@p-imbrenda>
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20221011181037.73ae8aa9@p-imbrenda>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: cZn3IYTA7umSSlcJEbLi7D-8RF1niRo4
X-Proofpoint-ORIG-GUID: cZn3IYTA7umSSlcJEbLi7D-8RF1niRo4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-11_08,2022-10-11_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 adultscore=0
 impostorscore=0 bulkscore=0 lowpriorityscore=0 phishscore=0 suspectscore=0
 mlxscore=0 malwarescore=0 priorityscore=1501 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210110092
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 11.10.22 um 18:10 schrieb Claudio Imbrenda:
> On Tue, 11 Oct 2022 17:58:29 +0200
> Christian Borntraeger <borntraeger@linux.ibm.com> wrote:
> 
>> Am 11.10.22 um 17:14 schrieb Nico Boehr:
>>> v1->v2:
>>> ---
>>> - remove unneeded include
>>> - advance clock by 10 minutes instead of 1 minute (thanks Claudio)
>>> - express get_clock_us() using stck() (thanks Claudio)
>>>
>>> The guest TOD clock should be preserved on migration. Add a test to
>>> verify that.
>>
>> I do not fully agree with this assumption. Its the way it curently is, but we might want to have a configurable or different behaviour in the future.
>>
>> For example if the difference is smaller than time x it could be allowed to move the time forward to get the guest synced to the new host (never go backward though).
> 
> the test is actually testing that the clock does not go backwards,
> rather than staying the same

I think this is an must and a perfectly valid test.
