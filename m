Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E7C46CA2C9
	for <lists+kvm@lfdr.de>; Mon, 27 Mar 2023 13:48:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231196AbjC0Lsv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Mar 2023 07:48:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232544AbjC0Lso (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Mar 2023 07:48:44 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74CA830C3;
        Mon, 27 Mar 2023 04:48:40 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32RAV16b012520;
        Mon, 27 Mar 2023 11:48:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=3P8ltzJTVPLhtGyAAXdg+oFZg+4+64FbL6rSvo2EmJE=;
 b=UaJ+Dh4/wBOnoz44393wCfAZv+h+jp7+KdDEbobnOodJvrspGxxJrdjTUPHYv2s2RfiB
 Sc+A9Hw1UGLDwYfE9eDc6tcMwhg54MUdkUUfYiJctov5yrYR1GEvFsW7b+LOYzisDDul
 atOvKw+PK5vOLWXKDrgOvOJvj9EVWD/CU7YwzS1XPdB99G6gyleMRDDPnSvBFyvtDO2a
 gwZ1tZpakz+uoftyJyyhLwDc708JB03lpclhGyOaZ/8QS1sCRS3uAFP53QpLnJl+dq6h
 GymXUxJkJWTtlpqwrxr0Oy8U5Vx+zymGPYIzX43hwuMU3i7XfXUaBRN0I+QJQObAD9Eq Ew== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pjammeeq6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Mar 2023 11:48:39 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32RAXSYn032144;
        Mon, 27 Mar 2023 11:48:39 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pjammeepq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Mar 2023 11:48:39 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32QGgbwZ025845;
        Mon, 27 Mar 2023 11:48:37 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma03fra.de.ibm.com (PPS) with ESMTPS id 3phrk6jc66-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Mar 2023 11:48:37 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32RBmX6V39190800
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Mar 2023 11:48:33 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 660D120049;
        Mon, 27 Mar 2023 11:48:33 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EA25820040;
        Mon, 27 Mar 2023 11:48:32 +0000 (GMT)
Received: from [9.171.92.86] (unknown [9.171.92.86])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Mon, 27 Mar 2023 11:48:32 +0000 (GMT)
Message-ID: <ab4c1d30-772c-1c9b-d63c-f855c0ffdf77@linux.ibm.com>
Date:   Mon, 27 Mar 2023 13:48:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [kvm-unit-tests PATCH v7 1/2] s390x: topology: Check the Perform
 Topology Function
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, thuth@redhat.com, kvm@vger.kernel.org,
        imbrenda@linux.ibm.com, david@redhat.com, nsg@linux.ibm.com
References: <20230320085642.12251-1-pmorel@linux.ibm.com>
 <20230320085642.12251-2-pmorel@linux.ibm.com>
 <167965267156.41638.18125355247583778957@t14-nrb>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <167965267156.41638.18125355247583778957@t14-nrb>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: dk1tiQZA4HlYiKJ6ySVaj2tHmpLi0JrY
X-Proofpoint-GUID: yAT3DX7-9M0KM28TcvW50PqpBQZsgyOx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-24_11,2023-03-27_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 mlxlogscore=999 impostorscore=0 bulkscore=0 malwarescore=0
 lowpriorityscore=0 clxscore=1015 adultscore=0 priorityscore=1501
 phishscore=0 spamscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2303200000 definitions=main-2303270090
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 3/24/23 11:11, Nico Boehr wrote:
> Quoting Pierre Morel (2023-03-20 09:56:41)
> [...]
>> diff --git a/s390x/topology.c b/s390x/topology.c
>> new file mode 100644
>> index 0000000..ce248f1
>> --- /dev/null
>> +++ b/s390x/topology.c
>> @@ -0,0 +1,180 @@
>> +/* SPDX-License-Identifier: GPL-2.0-only */
>> +/*
>> + * CPU Topology
>> + *
>> + * Copyright IBM Corp. 2022
>> + *
>> + * Authors:
>> + *  Pierre Morel <pmorel@linux.ibm.com>
>> + */
>> +
>> +#include <libcflat.h>
>> +#include <asm/page.h>
>> +#include <asm/asm-offsets.h>
>> +#include <asm/interrupt.h>
>> +#include <asm/facility.h>
>> +#include <smp.h>
>> +#include <sclp.h>
>> +#include <s390x/hardware.h>
>> +
>> +#define PTF_REQ_HORIZONTAL     0
>> +#define PTF_REQ_VERTICAL       1
>> +#define PTF_REQ_CHECK          2
> These are all function codes, so how about we name these defines PTF_FC_...
>
> and since PTF_REQ_CHECK doesn't request anything we should rename to PTF_FC_CHECK

OK


>
> [...]
>> +static struct {
>> +       const char *name;
>> +       void (*func)(void);
>> +} tests[] = {
>> +       { "PTF", test_ptf},
> missing space              ^


Yes, thanks.

Regards,

Pierre

