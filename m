Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8BA54A9C11
	for <lists+kvm@lfdr.de>; Fri,  4 Feb 2022 16:37:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359664AbiBDPh5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Feb 2022 10:37:57 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:63180 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1353177AbiBDPh4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Feb 2022 10:37:56 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 214E30u1011703
        for <kvm@vger.kernel.org>; Fri, 4 Feb 2022 15:37:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=drKz5modGM+hudRnFZc403nphgPTXtcBfbd5XQh3Jyg=;
 b=h2KzhzCR4BNmF56nKU/PQGCm+cNmwbg4Pzl1y+gERs/6BW4/Jtp0WsdH7dK8gHZs8p7b
 lFMWYgk6ca17/9lJQFtnEX4iTPsgT/84ccr27s6at2d4zmTK9gFf2hZHfP7CTjOWXz6T
 gmqsQDL6cFz94O9myfKA8Y0WoBdOUn6w1+gxoskRvgQIbviZpBz/SadqjN7HWsh+Z48g
 H3DxoLZe1RUOW6/2RegeMK8anZe3YBRFXwKWmgs0fVejveOJsmYFfBBVh0aPnv2QTrQ8
 PSN3GkFM3wkHMWsykO82SX/JWKHJFZHbOO4apWzVVvEiEQ+T++nNwEW+WmpCAo96Pgz1 8A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e0qxg0m6s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 04 Feb 2022 15:37:56 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 214Fbtft023807
        for <kvm@vger.kernel.org>; Fri, 4 Feb 2022 15:37:55 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e0qxg0m6c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 15:37:55 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 214FXVDD004870;
        Fri, 4 Feb 2022 15:37:54 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 3e0r10e7aw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 15:37:53 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 214FborJ22020422
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 4 Feb 2022 15:37:50 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CFC4FA4053;
        Fri,  4 Feb 2022 15:37:50 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7BB3EA4059;
        Fri,  4 Feb 2022 15:37:50 +0000 (GMT)
Received: from [9.145.158.84] (unknown [9.145.158.84])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  4 Feb 2022 15:37:50 +0000 (GMT)
Message-ID: <7c734d96-a4ec-b158-526e-b0bd2290e8af@linux.ibm.com>
Date:   Fri, 4 Feb 2022 16:37:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [kvm-unit-tests PATCH v1 0/5] s390x: smp: avoid hardcoded CPU
 addresses
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, david@redhat.com,
        nrb@linux.ibm.com, scgl@linux.ibm.com, seiden@linux.ibm.com
References: <20220128185449.64936-1-imbrenda@linux.ibm.com>
 <96a1a92b-d97a-32e9-7cdc-305994904181@linux.ibm.com>
 <20220204161430.27d1da36@p-imbrenda>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20220204161430.27d1da36@p-imbrenda>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: DDBb0x8t13axwpA5yg9zabFLBkfla3yv
X-Proofpoint-ORIG-GUID: i_lBUQcujMN_msdJ_6-FDm1RWpLBMPyG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-04_07,2022-02-03_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 mlxlogscore=999 clxscore=1015 lowpriorityscore=0 adultscore=0 mlxscore=0
 spamscore=0 suspectscore=0 priorityscore=1501 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202040088
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/4/22 16:14, Claudio Imbrenda wrote:
> On Fri, 4 Feb 2022 16:01:54 +0100
> Janosch Frank <frankja@linux.ibm.com> wrote:
> 
>> On 1/28/22 19:54, Claudio Imbrenda wrote:
>>> On s390x there are no guarantees about the CPU addresses, except that
>>> they shall be unique. This means that in some environments, it's
>>> possible that there is no match between the CPU address and its
>>> position (index) in the list of available CPUs returned by the system.
>>>
>>> This series fixes a small bug in the SMP initialization code, adds a
>>> guarantee that the boot CPU will always have index 0, and introduces
>>> some functions to allow tests to use CPU indexes instead of using
>>> hardcoded CPU addresses. This will allow the tests to run successfully
>>> in more environments (e.g. z/VM, LPAR).
>>>
>>> Some existing tests are adapted to take advantage of the new
>>> functionalities.
>>>
>>> Claudio Imbrenda (5):
>>>     lib: s390x: smp: add functions to work with CPU indexes
>>>     lib: s390x: smp: guarantee that boot CPU has index 0
>>>     s390x: smp: avoid hardcoded CPU addresses
>>>     s390x: firq: avoid hardcoded CPU addresses
>>>     s390x: skrf: avoid hardcoded CPU addresses
>>>
>>>    lib/s390x/smp.h |  2 ++
>>>    lib/s390x/smp.c | 28 ++++++++++++-----
>>>    s390x/firq.c    | 17 +++++-----
>>>    s390x/skrf.c    |  8 +++--
>>>    s390x/smp.c     | 83 ++++++++++++++++++++++++++-----------------------
>>
>> We use smp/sigp in uv-host.c and one of those uses looks a bit strange
>> to me anyway.
> 
> I had noticed that, it's fixed in the v2 (and that test will almost
> surely be rewritten anyway)
> 
>>
>> I think we also need to fix the sigp in cstart.S to only stop itself and
>> not the cpu with the addr 0.
> 
> not sure if that is needed right now. that is only used for snippets,
> right?

Yes

> 
> or did you mean cstart64.S?
> but there, sigp is only used for SET_ARCHITECTURE, so it doesn't really
> matter I guess?

My bad, seems like it's Friday

> 
>>
>> Up to now we very much assumed that cpu 0 is always our boot cpu so if
>> you start running the test with cpu addr 1 and 2 and leave out 0 you
>> might find more problematic code.
>>
>>
>>>    5 files changed, 79 insertions(+), 59 deletions(-)
>>>    
>>
> 

