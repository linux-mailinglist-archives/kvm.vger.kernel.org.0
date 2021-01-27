Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A70C305BCB
	for <lists+kvm@lfdr.de>; Wed, 27 Jan 2021 13:43:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237513AbhA0MnN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jan 2021 07:43:13 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:45844 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343702AbhA0MlI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 27 Jan 2021 07:41:08 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10RC2kOF088629;
        Wed, 27 Jan 2021 07:40:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=9ARTGW1tmlS9qOOfkP8TU1L6SgD8qOkG+tif+0DjixE=;
 b=aWaIxsyFBis6vBwbDofOSXFQ2nkLoqTcJxrtONztu0sGOXQnGg08VY3nK9bwWpbg0MpP
 ccFRkxg3ITSIwSHLGdSFJi/yzdEyuRNatp3gLTQfdlpjPAU20hDbNHDiJKfHcIgoyF42
 9cYj476fEbLqYFh/Ni+rmgIRJwXwrvPS+Duj6JvzJjq5Q3V5fZP52/0x1G24nVwy+wDp
 iqIlrkr1J1ZuhOjuStFoZs2dsnFocpVXiOFzjiCm3cMpazB+qi3MDypyX6RM22/gq6ue
 SR/PdgOCycubL4w0TuoksNDyZAwESPrSalSQ/X4EtziYsY2Pm9gm5vQvEl19FnsLsTby Mw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36b5bqwdks-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Jan 2021 07:40:27 -0500
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10RCJDE5161648;
        Wed, 27 Jan 2021 07:40:26 -0500
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36b5bqwdk0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Jan 2021 07:40:26 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10RCXEZ6027146;
        Wed, 27 Jan 2021 12:40:24 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 368b2h3thu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Jan 2021 12:40:24 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10RCeLK730408962
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Jan 2021 12:40:21 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5EDD0A405F;
        Wed, 27 Jan 2021 12:40:21 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B21D1A4065;
        Wed, 27 Jan 2021 12:40:20 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.51.19])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 27 Jan 2021 12:40:20 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v5 2/3] s390x: define UV compatible I/O
 allocation
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        imbrenda@linux.ibm.com, drjones@redhat.com, pbonzini@redhat.com
References: <1611322060-1972-1-git-send-email-pmorel@linux.ibm.com>
 <1611322060-1972-3-git-send-email-pmorel@linux.ibm.com>
 <20210127114727.1be31923.cohuck@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <feb132f9-3459-4db5-c79f-ed311ba167c7@linux.ibm.com>
Date:   Wed, 27 Jan 2021 13:40:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210127114727.1be31923.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-27_05:2021-01-27,2021-01-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 suspectscore=0 lowpriorityscore=0 phishscore=0 bulkscore=0 spamscore=0
 adultscore=0 impostorscore=0 priorityscore=1501 mlxlogscore=999
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101270067
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/27/21 11:47 AM, Cornelia Huck wrote:
> On Fri, 22 Jan 2021 14:27:39 +0100
> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
>> To centralize the memory allocation for I/O we define
>> the alloc_io_mem/free_io_mem functions which share the I/O
>> memory with the host in case the guest runs with
>> protected virtualization.
>>
>> These functions allocate on a page integral granularity to
>> ensure a dedicated sharing of the allocated objects.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   lib/s390x/malloc_io.c | 71 +++++++++++++++++++++++++++++++++++++++++++
>>   lib/s390x/malloc_io.h | 45 +++++++++++++++++++++++++++
>>   s390x/Makefile        |  1 +
>>   3 files changed, 117 insertions(+)
>>   create mode 100644 lib/s390x/malloc_io.c
>>   create mode 100644 lib/s390x/malloc_io.h
> 
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> 

Thanks,

Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
