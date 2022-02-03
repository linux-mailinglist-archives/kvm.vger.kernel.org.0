Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A48C74A8090
	for <lists+kvm@lfdr.de>; Thu,  3 Feb 2022 09:46:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349561AbiBCIqF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Feb 2022 03:46:05 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:56754 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229696AbiBCIqD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 3 Feb 2022 03:46:03 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21388Cq6012988
        for <kvm@vger.kernel.org>; Thu, 3 Feb 2022 08:46:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=NtyTzp0GHMShnM6jdY7BYz7TdRfHqxLfpUbCEy3VRUc=;
 b=S1hKdFRua1FfVc8iSj+bEEfiRaEkq12456EEjtmSJgl6qw/XO4w+7SGtjq8LUBI4Esry
 DhyT03PzoN+DtcMLS6ABCovPW/bk9jxHAVTmfgWUHLftHODUxLIy9hz+99stwtamppUf
 lSBGdYPCoHvirJSFSbOkQNs1Hqf3DJ9QIV3BmfeNRuYdTB6zY3BSiniGT4bsvgEjlq6I
 hYE/XbEz5fe1VVt+vQspi9TmNLTvbNse2wyjBEokKz8HNokeezawKDRpcZFum4HYGua5
 DyGwbKvaTxruzRiA+vrRwIaGTI4LvXow5AztfANNZuC3QEGTj5YjXV5P83wPW6K9VjBj Jg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dyvexj1t3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 03 Feb 2022 08:46:03 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 2138Cnom028610
        for <kvm@vger.kernel.org>; Thu, 3 Feb 2022 08:46:03 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dyvexj1se-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Feb 2022 08:46:03 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2138bIJ4028873;
        Thu, 3 Feb 2022 08:46:01 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma01fra.de.ibm.com with ESMTP id 3dvw79svk3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Feb 2022 08:46:00 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2138jv9d37552406
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 3 Feb 2022 08:45:57 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8BF344204C;
        Thu,  3 Feb 2022 08:45:57 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3E0B142041;
        Thu,  3 Feb 2022 08:45:57 +0000 (GMT)
Received: from [9.145.7.4] (unknown [9.145.7.4])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  3 Feb 2022 08:45:57 +0000 (GMT)
Message-ID: <f8f09670-688b-2b12-f09a-860a9edffd54@linux.ibm.com>
Date:   Thu, 3 Feb 2022 09:45:56 +0100
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
X-Proofpoint-ORIG-GUID: hWD6YC1FPpiBb1cjYyofOXUHjnv-QtaO
X-Proofpoint-GUID: UOiEp4-apnnRefB0nByymqlS_SIGwMbA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-03_02,2022-02-01_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 clxscore=1015 impostorscore=0 phishscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 priorityscore=1501 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202030052
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/28/22 19:54, Claudio Imbrenda wrote:
> On s390x there are no guarantees about the CPU addresses, except that
> they shall be unique. This means that in some environments, it's
> possible that there is no match between the CPU address and its
> position (index) in the list of available CPUs returned by the system.

While I support this patch set I've yet to find an environment where 
this gave me headaches.

> 
> This series fixes a small bug in the SMP initialization code, adds a
> guarantee that the boot CPU will always have index 0, and introduces
> some functions to allow tests to use CPU indexes instead of using
> hardcoded CPU addresses. This will allow the tests to run successfully
> in more environments (e.g. z/VM, LPAR).

I'm wondering if we should do it the other way round and make the smp_* 
functions take a idx instead of a cpu addr. The only instance where this 
gets a bit ugly is the sigp calls which we would also need to convert.

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
>   5 files changed, 79 insertions(+), 59 deletions(-)
> 

