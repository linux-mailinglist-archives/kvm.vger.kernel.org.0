Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA4532F4B24
	for <lists+kvm@lfdr.de>; Wed, 13 Jan 2021 13:20:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727569AbhAMMQT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jan 2021 07:16:19 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:9906 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726899AbhAMMQT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Jan 2021 07:16:19 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10DC2g9H018918;
        Wed, 13 Jan 2021 07:15:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=c3hFSr7kNjDg/t8thbd+cscadmqcCQbJgECqTEKzvMg=;
 b=fs7+DvJ3DZCpkvWTsoBadpBPCxPBSBAgJU6LUHoML7WjrgW3+WAwcpnloCnLxgThznT/
 WkML1bT0VOefkYeFkIBqqbHAnxX0Q23ssIaIHixiJyYjJ9cxqJf6dkmgzNNyBGIGaafc
 l00yOZSxZylWj1Nv6AimyhvReNVVtE0De13mAWYt4zzix6pu7HIoK4J+4w/+/L4oMADa
 ID0iczfl1zs5xIjNy5MftUcAZ3AgfhMwOjj0uBXLm7fpg0cERnCEfNvjU+OKXlifOoVO
 1orQqMXA2TijxqNXORPDg5U71XNlzVz77fUKZblR4shPxHTmwepYJmSMJ2zJWFLM86Ak 7A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3620d28n5m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jan 2021 07:15:38 -0500
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10DC38tl021541;
        Wed, 13 Jan 2021 07:15:38 -0500
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3620d28n4j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jan 2021 07:15:38 -0500
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10DCDMda002510;
        Wed, 13 Jan 2021 12:15:35 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04fra.de.ibm.com with ESMTP id 3604h99va5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jan 2021 12:15:35 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10DCFSY633095998
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Jan 2021 12:15:28 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E73B842042;
        Wed, 13 Jan 2021 12:15:32 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 79ECA42041;
        Wed, 13 Jan 2021 12:15:32 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.171.171])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 13 Jan 2021 12:15:32 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v4 4/9] s390x: Split assembly into multiple
 files
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     david@redhat.com, borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        cohuck@redhat.com, linux-s390@vger.kernel.org
References: <20210112132054.49756-1-frankja@linux.ibm.com>
 <20210112132054.49756-5-frankja@linux.ibm.com>
 <c07280f6-f56c-ea6c-1255-28a36a2385c0@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Message-ID: <fce05f26-8cdb-009d-a88d-c799c3784506@linux.ibm.com>
Date:   Wed, 13 Jan 2021 13:15:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <c07280f6-f56c-ea6c-1255-28a36a2385c0@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-13_07:2021-01-13,2021-01-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 phishscore=0
 malwarescore=0 impostorscore=0 bulkscore=0 spamscore=0 lowpriorityscore=0
 priorityscore=1501 mlxscore=0 clxscore=1015 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101130074
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/13/21 1:04 PM, Thomas Huth wrote:
> On 12/01/2021 14.20, Janosch Frank wrote:
>> I've added too much to cstart64.S which is not start related
>> already. Now that I want to add even more code it's time to split
>> cstart64.S. lib.S has functions that are used in tests. macros.S
>> contains macros which are used in cstart64.S and lib.S
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> Acked-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
>> ---
>>   s390x/Makefile   |   6 +--
>>   s390x/cstart64.S | 119 ++---------------------------------------------
>>   s390x/lib.S      |  65 ++++++++++++++++++++++++++
> 
> lib.S is a very generic name ... maybe rather use cpuasm.S or something similar?

instr.S ?
Or maybe entry.S to make it similar to the kernel?


> 
> Anway,
> Acked-by: Thomas Huth <thuth@redhat.com>
> 

Thanks
