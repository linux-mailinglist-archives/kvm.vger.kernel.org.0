Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4BEE35538B
	for <lists+kvm@lfdr.de>; Tue,  6 Apr 2021 14:21:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343927AbhDFMVn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Apr 2021 08:21:43 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:39072 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343943AbhDFMVl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Apr 2021 08:21:41 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 136C5HUg187220
        for <kvm@vger.kernel.org>; Tue, 6 Apr 2021 08:21:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : from : to : cc
 : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=sYkqYKtSo1P7J5ctPv3LYCwIr8xZ+c7IqqYipSfy6vM=;
 b=M4c8mgeFbDozQSmV3JqgQtV4VoFYEnti0rDI5ciHtJd0ynPY0dXwj5N3qonf5b6o33Dz
 l6z2pmJSNNtBFAQlAl1FoqEKxyCsdG64Ws1czbOVM5pkzYgbniNthkk+1irp7WAWkKlu
 sdSUYHWcL3Y2t91j3jltQWhpHAHMNBv+vIsW/v32qsZF6dXy2YtQkcehOLS57w1W9PtQ
 a2MliLNxidfaOAa+WrOCGoCKYdr+u5aYarOWhKOm7D2sEyf0vHdgZV7PziJunwzWLUW8
 3hVsGFaWbhqqr8a5mdwtzMgUYUtAFv6E2tpFXTwOq7JrK81bMyPxo4Ebaakua6W58xaV xw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37q5am2hbn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 06 Apr 2021 08:21:33 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 136C5ewT189415
        for <kvm@vger.kernel.org>; Tue, 6 Apr 2021 08:21:32 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37q5am2ha7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Apr 2021 08:21:32 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 136C6mD0016175;
        Tue, 6 Apr 2021 12:21:30 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 37q2n2t511-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Apr 2021 12:21:30 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 136CLRPj40960288
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 6 Apr 2021 12:21:27 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EBEC842052;
        Tue,  6 Apr 2021 12:21:26 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B588C4204B;
        Tue,  6 Apr 2021 12:21:26 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.42.152])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  6 Apr 2021 12:21:26 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v3 00/16] s390x: Testing SSCH, CSCH and
 HSCH for errors
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com
References: <1617694853-6881-1-git-send-email-pmorel@linux.ibm.com>
Message-ID: <0cee034e-5345-e308-4efb-8c01d94fb74e@linux.ibm.com>
Date:   Tue, 6 Apr 2021 14:21:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <1617694853-6881-1-git-send-email-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 9CyZUiloH13x5jNUDTbRY9IUoCgswufV
X-Proofpoint-ORIG-GUID: EC-wkTTwBcHJBhuv8Yb8AaB2dePeDrBg
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-04-06_03:2021-04-01,2021-04-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 clxscore=1015 adultscore=0 lowpriorityscore=0 mlxlogscore=999
 priorityscore=1501 spamscore=0 phishscore=0 malwarescore=0 impostorscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104030000 definitions=main-2104060080
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Hi all,

I forgot to write that some tests about addressing will fail if the 
following QEMU patch is not installed:

Subject: [PATCH v1 0/1] s390x: css: report errors from 
ccw_dstream_read/write
Date: Tue,  6 Apr 2021 09:44:12 +0200
Message-Id: <1617695053-7328-1-git-send-email-pmorel@linux.ibm.com>


Regards,
Pierre


On 4/6/21 9:40 AM, Pierre Morel wrote:
> The goal of this series is to test some of the I/O instructions,
> SSCH, CSCH and HSCH for errors like invalid parameters, addressing,
> timing etc.
> We can not test the sending of an instruction before the last instruction
> has been proceeded by QEMU due to the QEMU serialization but we can
> check the behavior of an instruction if it is started before the status
> of the last instruction is read.
> 
> To do this we first separate the waiting for the interruption and the
> checking of the IRB and enable the subchannel without an I/O ISC to
> avoid interruptions at this subchannel and second, we add an argument
> to the routine in charge to check the IRB representing the expected
> SCSW control field of the IRB.
> 
> We also need several other enhancements to the testing environment:
> 
> - definitions for the SCSW control bits
> - a new function to disable a subchannel
> - a macro to simplify skiping tests when no device is present
>    (I know the warning about return in macro, can we accept it?)
> 
> In the new tests we assume that all the test preparation is working and
> use asserts for all function for which we do not expect a failure.
> 
> regards,
> Pierre
> 
> PS: Sorry, I needed to modify patches 4 and 5 for which I already had RB or AB.
>      I removed them even I hope you will agree with my modifications.
> 
> 
> Pierre Morel (16):
>    s390x: lib: css: disabling a subchannel
>    s390x: lib: css: SCSW bit definitions
>    s390x: css: simplify skipping tests on no device
>    s390x: lib: css: separate wait for IRQ and check I/O completion
>    s390x: lib: css: add SCSW ctrl expectations to check I/O completion
>    s390x: lib: css: checking I/O errors
>    s390x: css: testing ssch errors
>    s390x: css: ssch check for cpa zero
>    s390x: css: ssch with mis aligned ORB
>    s390x: css: ssch checking addressing errors
>    s390x: css: No support for MIDAW
>    s390x: css: Check ORB reserved bits
>    s390x: css: checking for CSS extensions
>    s390x: css: issuing SSCH when the channel is status pending
>    s390x: css: testing halt subchannel
>    s390x: css: testing clear subchannel
> 
>   lib/s390x/css.h     |  42 ++++-
>   lib/s390x/css_lib.c | 138 ++++++++++++--
>   s390x/css.c         | 425 +++++++++++++++++++++++++++++++++++++++++---
>   s390x/unittests.cfg |   8 +-
>   4 files changed, 565 insertions(+), 48 deletions(-)
> 

-- 
Pierre Morel
IBM Lab Boeblingen
