Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C4AF34E813
	for <lists+kvm@lfdr.de>; Tue, 30 Mar 2021 14:58:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231971AbhC3M5p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Mar 2021 08:57:45 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:4966 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232034AbhC3M51 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 30 Mar 2021 08:57:27 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12UCqFm3015810
        for <kvm@vger.kernel.org>; Tue, 30 Mar 2021 08:57:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=exznGYE8woNGDA6eNy5pVwUm+Ejqfq+jOd/340333CM=;
 b=aSkB5bOv3imgN3erP0mEHGkQlh4JJr/ss0AU5R+F3OGRvqyXpC4IE8ga9axrYgPUZEM3
 TdAr9YTVX8v8ZoPbl3Uu40SAc74qg1BrUl0ogfMz0nqj2hk0+VdK+bnpEau7HuKBSkSp
 VS6PQRFicLgPL2mFC0RAcK40kHuXJmi3ejcJGVEQhPmmID9oAtyW0TEmhDU0y5prFg/V
 2gNQzGU2D4MgR87Q+zpbRNphihCehNOUzAqdc3/1szGYOwGG/EsTS+YXElYdu0qpID4m
 ROcXvAF1XO0hu7iHV1SNWM1IDp/S9lbFGuzYYLVQZ9KqTwUX+HGloqcofKsx8a4x5Jfc KA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37m4cdr49f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 30 Mar 2021 08:57:27 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12UCqQKF016844
        for <kvm@vger.kernel.org>; Tue, 30 Mar 2021 08:57:26 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37m4cdr486-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 Mar 2021 08:57:26 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12UCr27j025893;
        Tue, 30 Mar 2021 12:57:24 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 37hvb8jq8k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 Mar 2021 12:57:24 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12UCvL3a34341186
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Mar 2021 12:57:21 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 63FDDAE051;
        Tue, 30 Mar 2021 12:57:21 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2D5E0AE059;
        Tue, 30 Mar 2021 12:57:21 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.144.252])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 30 Mar 2021 12:57:21 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v2 4/8] s390x: lib: css: separate wait for
 IRQ and check I/O completion
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        thuth@redhat.com, imbrenda@linux.ibm.com
References: <1616665147-32084-1-git-send-email-pmorel@linux.ibm.com>
 <1616665147-32084-5-git-send-email-pmorel@linux.ibm.com>
 <20210330135732.0b367536.cohuck@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <30e07d3d-c938-34f1-f3ae-4031cbfd0a3c@linux.ibm.com>
Date:   Tue, 30 Mar 2021 14:57:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210330135732.0b367536.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: qcZ3-Pp9k_PuWtpQJ6HsyOQmFkzD9FNd
X-Proofpoint-ORIG-GUID: GZoEJgn-v01hEEXjxyGXsbjbBPmkSulz
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-30_04:2021-03-30,2021-03-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 adultscore=0
 impostorscore=0 mlxlogscore=946 phishscore=0 mlxscore=0 malwarescore=0
 suspectscore=0 lowpriorityscore=0 bulkscore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103250000 definitions=main-2103300090
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/30/21 1:57 PM, Cornelia Huck wrote:
> On Thu, 25 Mar 2021 10:39:03 +0100
> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
>> We will may want to check the result of an I/O without waiting
>> for an interrupt.
>> For example because we do not handle interrupt.
> 
> It's more because we may poll the subchannel state without enabling I/O
> interrupts, no?

absolutely.
may be I just replace with your rewording :)

"
We will may want to check the result of an I/O without waiting
for an interrupt because we may poll the subchannel state without 
enabling I/O interrupts.
"

> 
>> Let's separate waiting for interrupt and the I/O complretion check.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   lib/s390x/css.h     |  1 +
>>   lib/s390x/css_lib.c | 13 ++++++++++---
>>   2 files changed, 11 insertions(+), 3 deletions(-)
> 
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> 

Thanks,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
