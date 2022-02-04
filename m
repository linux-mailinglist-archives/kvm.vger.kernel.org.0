Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E59C04A9B90
	for <lists+kvm@lfdr.de>; Fri,  4 Feb 2022 16:02:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359488AbiBDPCD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Feb 2022 10:02:03 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:28680 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231511AbiBDPCC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Feb 2022 10:02:02 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 214EMP73005733
        for <kvm@vger.kernel.org>; Fri, 4 Feb 2022 15:02:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Tixgy0GKxO4QomwKJUortUyGeCtcm+bDSfeiTl5lm64=;
 b=GtQu1DnUW64BjihhZPuVvfGfjWvnuVFWNtAiOe7apYQdzyL11RB8+hLttrzw2OhQO9ep
 mwCPmQ8shjsomvDVh14JQroB59C1pZAT2MZ7R1X7T/sRDCcQjh14sD2azAemr/fBh08q
 wPohD05i+p6ktsjUFTqZFmfb1e35jUASRFqIZVaFjNLWfRB4Gy3lzgxtbdgwESgThzZ5
 jJwgP4pYJZ/1ep9xiYrelsIMuSLkG5f0wIpi36fCxu+lijd6tMabFYREi72s8QxxBSXe
 rTs/HHbRPXWcWqyZP1u41h3cW6IS7+EIk2uRxii/Z7GHpnYzm2mHNskG88lPgxY+KpP3 lA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e0r12f61t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 04 Feb 2022 15:02:02 +0000
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 214F0Ir8014415
        for <kvm@vger.kernel.org>; Fri, 4 Feb 2022 15:02:02 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e0r12f60w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 15:02:02 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 214F1TeL008743;
        Fri, 4 Feb 2022 15:02:00 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04fra.de.ibm.com with ESMTP id 3e0r0u5n0w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 15:01:59 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 214F1t9935258746
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 4 Feb 2022 15:01:55 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7BDC9A405D;
        Fri,  4 Feb 2022 15:01:55 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 37FA0A404D;
        Fri,  4 Feb 2022 15:01:55 +0000 (GMT)
Received: from [9.145.158.84] (unknown [9.145.158.84])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  4 Feb 2022 15:01:55 +0000 (GMT)
Message-ID: <96a1a92b-d97a-32e9-7cdc-305994904181@linux.ibm.com>
Date:   Fri, 4 Feb 2022 16:01:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [kvm-unit-tests PATCH v1 0/5] s390x: smp: avoid hardcoded CPU
 addresses
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     thuth@redhat.com, david@redhat.com, nrb@linux.ibm.com,
        scgl@linux.ibm.com, seiden@linux.ibm.com
References: <20220128185449.64936-1-imbrenda@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20220128185449.64936-1-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: IKvcmuOh9mfFvwzcl3xO_OKsky3RZ0St
X-Proofpoint-ORIG-GUID: FS39kWt-Lu_fzvhXCWD5l3eQ5C0DaOyp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-04_05,2022-02-03_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 impostorscore=0
 malwarescore=0 mlxlogscore=999 lowpriorityscore=0 clxscore=1015
 bulkscore=0 priorityscore=1501 suspectscore=0 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202040086
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/28/22 19:54, Claudio Imbrenda wrote:
> On s390x there are no guarantees about the CPU addresses, except that
> they shall be unique. This means that in some environments, it's
> possible that there is no match between the CPU address and its
> position (index) in the list of available CPUs returned by the system.
> 
> This series fixes a small bug in the SMP initialization code, adds a
> guarantee that the boot CPU will always have index 0, and introduces
> some functions to allow tests to use CPU indexes instead of using
> hardcoded CPU addresses. This will allow the tests to run successfully
> in more environments (e.g. z/VM, LPAR).
> 
> Some existing tests are adapted to take advantage of the new
> functionalities.
> 
> Claudio Imbrenda (5):
>    lib: s390x: smp: add functions to work with CPU indexes
>    lib: s390x: smp: guarantee that boot CPU has index 0
>    s390x: smp: avoid hardcoded CPU addresses
>    s390x: firq: avoid hardcoded CPU addresses
>    s390x: skrf: avoid hardcoded CPU addresses
> 
>   lib/s390x/smp.h |  2 ++
>   lib/s390x/smp.c | 28 ++++++++++++-----
>   s390x/firq.c    | 17 +++++-----
>   s390x/skrf.c    |  8 +++--
>   s390x/smp.c     | 83 ++++++++++++++++++++++++++-----------------------

We use smp/sigp in uv-host.c and one of those uses looks a bit strange 
to me anyway.

I think we also need to fix the sigp in cstart.S to only stop itself and 
not the cpu with the addr 0.

Up to now we very much assumed that cpu 0 is always our boot cpu so if 
you start running the test with cpu addr 1 and 2 and leave out 0 you 
might find more problematic code.


>   5 files changed, 79 insertions(+), 59 deletions(-)
> 

