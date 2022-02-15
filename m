Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 711404B7198
	for <lists+kvm@lfdr.de>; Tue, 15 Feb 2022 17:40:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239635AbiBOPLU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Feb 2022 10:11:20 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239353AbiBOPLS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Feb 2022 10:11:18 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 904536D4F0
        for <kvm@vger.kernel.org>; Tue, 15 Feb 2022 07:11:08 -0800 (PST)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21FF3pnF004959
        for <kvm@vger.kernel.org>; Tue, 15 Feb 2022 15:11:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : to : cc : references : from : subject : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=SrLhWYZOEM7gJcs9qYX0vEqqOVfBEz7LVzbMAJdhuXg=;
 b=UP4y3r5Up+6vrTOJfnG2xD9T9l8dzs6JQrY4hzxbenxlfaK5AWTXqokwILSGbSM58oJg
 NQQMnsyf4Ye4u9TeoSNuw/erE3MoriOJrj/Do00WfRStyrMWwWd4GGy+sbrJGzG+EV9R
 ToRjJlLxGlZeSAQ7aiqTnhkx0u9Kjf+r0z583K3fGWN6QxE3UKtZlNqQv+IbUPoaq85E
 gLxHpkCwPE75C6qZU/cIMBcCGyY0TO88CdvdVdtNDTOWqgOjOM2T4Ln3dHBpWDwaUqqX
 bodaezU2YKkx3e51ShzOyB0tk2xF6Wxaijod/qb8EfgxCI4UFt48jsYuo/37Pg+0+gCT cQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e8e5n8vcp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 15 Feb 2022 15:11:08 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21FF4kTk012475
        for <kvm@vger.kernel.org>; Tue, 15 Feb 2022 15:11:07 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e8e5n8vbm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Feb 2022 15:11:07 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21FF8SqM001680;
        Tue, 15 Feb 2022 15:11:05 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3e64ha0fka-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Feb 2022 15:11:05 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21FFB3ow33292798
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Feb 2022 15:11:03 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E7FC8A4067;
        Tue, 15 Feb 2022 15:11:02 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 81DBCA4066;
        Tue, 15 Feb 2022 15:11:02 +0000 (GMT)
Received: from [9.145.49.62] (unknown [9.145.49.62])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 15 Feb 2022 15:11:02 +0000 (GMT)
Message-ID: <ed8214b0-b22c-8bc7-1d19-3e49bbf83e19@linux.ibm.com>
Date:   Tue, 15 Feb 2022 16:11:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Steffen Eiden <seiden@linux.ibm.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, david@redhat.com,
        nrb@linux.ibm.com, scgl@linux.ibm.com
References: <20220204130855.39520-1-imbrenda@linux.ibm.com>
 <20220204130855.39520-3-imbrenda@linux.ibm.com>
 <698c33f2-7549-3420-ce97-d15c86b4dc02@linux.ibm.com>
 <20220215122342.62efd8b8@p-imbrenda>
 <eab9527a-a64d-dade-116c-ab725c4667d8@linux.ibm.com>
 <20220215125445.25003724@p-imbrenda>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v2 2/6] lib: s390x: smp: refactor smp
 functions to accept indexes
In-Reply-To: <20220215125445.25003724@p-imbrenda>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ad2rIogEMwW8R0y7FXT2oaaTPz3U4I8S
X-Proofpoint-ORIG-GUID: Le1NYwIimtWgbW1G-B_IvMOHm2kfbS8y
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-15_04,2022-02-14_04,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 phishscore=0
 bulkscore=0 suspectscore=0 adultscore=0 spamscore=0 malwarescore=0
 lowpriorityscore=0 mlxscore=0 priorityscore=1501 impostorscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202150088
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/15/22 12:54, Claudio Imbrenda wrote:
> On Tue, 15 Feb 2022 12:43:15 +0100
> Steffen Eiden <seiden@linux.ibm.com> wrote:
> 
>> On 2/15/22 12:23, Claudio Imbrenda wrote:
>>> On Tue, 15 Feb 2022 12:09:53 +0100
>>> Steffen Eiden <seiden@linux.ibm.com> wrote:
>>>
>>> [...]
>>>    
>>>> What about using the smp wrapper 'smp_sigp(idx, SIGP_RESTART, 0, NULL)'
>>>> here as well?
>>>
>>> [...]
>>>    
>>>> With my nits fixed:
>>>
>>> maybe I should add a comment explaining why I did not use the smp_
>>> variants.
>>>
>>> the reason is that the smp_ variants check the validity of the CPU
>>> index. but in those places, we have already checked (directly or
>>> indirectly) that the index is valid, so I save one useless check.
>>>> on the other hand, I don't know if it makes sense to optimize for that,
>>> since it's not a hot path, and one extra check will not kill the
>>> performance.
>>>   
>> I would prefer the use of the smp_ variant. The extra assert won't
>> clutter the output and the code is more consistent.
>> However, a short comment is also fine for me if you prefer that.
> 
> I guess I'll use the smp_ variant and add a few lines in the patch
> description to explain that we're doing some extra checks, but the code
> is more readable
> 
>>
>>>>
>>>> Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>
>>>    
> 

Doesn't make a difference to me as you use cpu.addr in the sigp_ which 
tells me it's a cpu address and not an idx.
