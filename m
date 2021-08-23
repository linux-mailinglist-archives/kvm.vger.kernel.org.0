Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97F603F4DF1
	for <lists+kvm@lfdr.de>; Mon, 23 Aug 2021 18:02:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230043AbhHWQDS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Aug 2021 12:03:18 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:39448 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229465AbhHWQDS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 23 Aug 2021 12:03:18 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17NFZMl3042002;
        Mon, 23 Aug 2021 12:02:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=3hKfoY9tkVj90yiJGaBtBd9Ta9C3SApNM8CIeJ4UbXE=;
 b=XT2RHU7H3k9TqKUy+aElqegrwmVbHQlqJOrxYCmcLKRhZpJNJA9xYcbhcgq0LfAfhq+1
 gOC7tK1IS6MLdB1Xk70wb6jh4t8WYZBm4frpGEQ1R1KdHlGRcryE7Yj4CT58IVr2Rthl
 iDn3Bha6uF/vz4Lc4la4KXna/WfqjXPX5bCTcLHW/EsccPADE/86BRfUbWAAmfo0wdHl
 Nyeh+bJrsWSUgAYvrlovG7XRey23k0Bu5UGiRSJWJ8bCiRqWWPTbf7HVrdSxR2QATpv9
 9CT8Qs4THdPrsotmOPDjFNGU3xSKoFmo3wOk+ACKM5op/Gdd4YOzFLxXckDIKkPTNa+k gw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3am1evdat8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 Aug 2021 12:02:34 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17NFZTXE045050;
        Mon, 23 Aug 2021 12:02:33 -0400
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3am1evdasg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 Aug 2021 12:02:33 -0400
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17NFvHmN025945;
        Mon, 23 Aug 2021 16:02:32 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma01wdc.us.ibm.com with ESMTP id 3ajs4b2mq6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 Aug 2021 16:02:32 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17NG2VgZ24707460
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Aug 2021 16:02:31 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DD38DC6059;
        Mon, 23 Aug 2021 16:02:30 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 53083C606E;
        Mon, 23 Aug 2021 16:02:30 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.163.11.57])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 23 Aug 2021 16:02:30 +0000 (GMT)
Subject: Re: [PATCH] vfio-pci/zdev: Remove repeated verbose license text
To:     Cai Huoqing <caihuoqing@baidu.com>, farman@linux.ibm.com,
        alex.williamson@redhat.com, cohuck@redhat.com
Cc:     linux-s390@vger.kernel.org, kvm@vger.kernel.org
References: <20210822043500.561-1-caihuoqing@baidu.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
Message-ID: <45493e42-f3af-eb5a-e503-9ea1ea71a927@linux.ibm.com>
Date:   Mon, 23 Aug 2021 12:02:29 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210822043500.561-1-caihuoqing@baidu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: gPFUutsmq-7yClS9qwqc6BqCnJV-CKoj
X-Proofpoint-ORIG-GUID: XsOYlejOdyxWkkl5YnIEsWPBDgiCdxJ9
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-23_03:2021-08-23,2021-08-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 mlxlogscore=999 spamscore=0 adultscore=0 lowpriorityscore=0 clxscore=1011
 priorityscore=1501 phishscore=0 suspectscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108230107
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/22/21 12:35 AM, Cai Huoqing wrote:
> remove it because SPDX-License-Identifier is already used
> 
> Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>

Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>

> ---
>   drivers/vfio/pci/vfio_pci_zdev.c | 5 -----
>   1 file changed, 5 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_zdev.c b/drivers/vfio/pci/vfio_pci_zdev.c
> index 7b011b62c766..dfd8d826223d 100644
> --- a/drivers/vfio/pci/vfio_pci_zdev.c
> +++ b/drivers/vfio/pci/vfio_pci_zdev.c
> @@ -5,11 +5,6 @@
>    * Copyright (C) IBM Corp. 2020.  All rights reserved.
>    *	Author(s): Pierre Morel <pmorel@linux.ibm.com>
>    *                 Matthew Rosato <mjrosato@linux.ibm.com>
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License version 2 as
> - * published by the Free Software Foundation.
> - *
>    */
>   #include <linux/io.h>
>   #include <linux/pci.h>
> 

