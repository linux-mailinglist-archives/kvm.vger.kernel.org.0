Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D48D453227
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 13:27:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236224AbhKPMae (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 07:30:34 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:29364 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236113AbhKPMa0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Nov 2021 07:30:26 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AGCJ22I021306
        for <kvm@vger.kernel.org>; Tue, 16 Nov 2021 12:27:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : from : to : cc : references : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=qgSfBWODZKyWBue9l3CQ8vpduCzgsXLA2RreNsg7gPY=;
 b=mteadg+aoAGIZQRvhkZzG2Bf2gN5EkutkLmDcVNPL5waAvL1sl/D01+AVYeHMlKYdcJw
 Tkz4n6NVm1dN6Kq2ih3qxqF5Ph35dkIPfbLdWndNfP3rrKvVd1jgwKS8XIGACG0TLbW1
 t1nWroIKoqq1UtMi1IXWLzzcxk2dhWyb/h3MYTnVfE4Evq/gcDyFZq5SAghPnxNH4BVS
 Roh958e/mMNEjZdmtlCAQWVwDg8+FiNqnpeGkAyZxjCb0B1QFevIYvLSJobt2uewDeXd
 ZZDzN/tdkpBDnka+wtA1fpx6OjjfmwL7DSK0DENq68IH/VoVViNGjaHq+eLtRcj15KVO Bw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ccchk049v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 16 Nov 2021 12:27:28 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1AGCLWxb003387
        for <kvm@vger.kernel.org>; Tue, 16 Nov 2021 12:27:28 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ccchk049c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Nov 2021 12:27:28 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1AGCCkjL004306;
        Tue, 16 Nov 2021 12:27:25 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04fra.de.ibm.com with ESMTP id 3ca50c66x8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Nov 2021 12:27:25 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1AGCRLHH54723036
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Nov 2021 12:27:21 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9D4CAA4055;
        Tue, 16 Nov 2021 12:27:21 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 44FADA404D;
        Tue, 16 Nov 2021 12:27:21 +0000 (GMT)
Received: from [9.171.63.115] (unknown [9.171.63.115])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 16 Nov 2021 12:27:21 +0000 (GMT)
Message-ID: <83c50f7c-549c-48e7-ae28-2cd8ce4f7c74@linux.ibm.com>
Date:   Tue, 16 Nov 2021 13:27:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [kvm-unit-tests PATCH v2] s390x: fixing I/O memory allocation
Content-Language: en-US
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com
References: <20211116122629.257689-1-pmorel@linux.ibm.com>
In-Reply-To: <20211116122629.257689-1-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: IEDLGHYURpcKtC2ad_pZV5thOEh8np-l
X-Proofpoint-ORIG-GUID: SacOSaaqw8rptroYEjUx35OPGa2x8ccd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-16_01,2021-11-16_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 suspectscore=0 mlxscore=0 mlxlogscore=999
 impostorscore=0 adultscore=0 spamscore=0 clxscore=1015 malwarescore=0
 lowpriorityscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2111160062
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sorry ... manipulation error

On 11/16/21 13:26, Pierre Morel wrote:
> The allocator allocate pages it follows the size must be rounded
> to pages before the allocation.
> 
> Fixes: b0fe3988 "s390x: define UV compatible I/O allocation"
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>   lib/s390x/malloc_io.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/s390x/malloc_io.c b/lib/s390x/malloc_io.c
> index 78582eac..080fc694 100644
> --- a/lib/s390x/malloc_io.c
> +++ b/lib/s390x/malloc_io.c
> @@ -41,7 +41,7 @@ static void unshare_pages(void *p, int count)
>   
>   void *alloc_io_mem(int size, int flags)
>   {
> -	int order = get_order(size >> PAGE_SHIFT);
> +	int order = get_order(PAGE_ALIGN(size) >> PAGE_SHIFT);
>   	void *p;
>   	int n;
>   
> @@ -62,7 +62,7 @@ void *alloc_io_mem(int size, int flags)
>   
>   void free_io_mem(void *p, int size)
>   {
> -	int order = get_order(size >> PAGE_SHIFT);
> +	int order = get_order(PAGE_ALIGN(size) >> PAGE_SHIFT);
>   
>   	assert(IS_ALIGNED((uintptr_t)p, PAGE_SIZE));
>   
> 

-- 
Pierre Morel
IBM Lab Boeblingen
