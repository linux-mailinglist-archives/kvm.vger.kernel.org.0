Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 211A271F032
	for <lists+kvm@lfdr.de>; Thu,  1 Jun 2023 19:05:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233122AbjFARFR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jun 2023 13:05:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231366AbjFAREp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jun 2023 13:04:45 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A038E4D;
        Thu,  1 Jun 2023 10:04:30 -0700 (PDT)
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 351H1n4B006914;
        Thu, 1 Jun 2023 17:04:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : from : to : cc : references : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=KRUz4yKIjA5yeBdIlHhEJwQtE7y0oilBMkxJZeNFrEc=;
 b=qb4CM5nWJ4LXg23LR88ugB62wETbSAosdXptDGkP55bFPjW8YKqXYmWmNeInUg+aKmSG
 pRy5L0SAyaxTC5FD6LPuwWJfaPyrldCpmcoZEco4xusCD8FOfxwQJ+LGDACSgJrZaStj
 6VNelXmHNZL0YXmSVi3nwo0TkFsMgpI/7CH79lL5lOXvH0CP1taNRL4dolhu3WCdz8DR
 GCtmbJxYiR0Cyyc0/Nasr5ANl++g2AURh8AiEHyUbqQm/+tNSmKs986BpuZposI2oJuW
 EthfUsGriMXFqMqPG2LBDMr0PiPXqx2WNNZlDrATlMkonQKClTo7GiDzIm5+wapnPoNo 5A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qxy6vgd8s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Jun 2023 17:04:29 +0000
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 351H1s7j007556;
        Thu, 1 Jun 2023 17:04:28 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qxy6vgd5v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Jun 2023 17:04:28 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3513PKCG017606;
        Thu, 1 Jun 2023 16:58:05 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3qu9g5amy1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Jun 2023 16:58:05 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 351Gw1N539518586
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 1 Jun 2023 16:58:01 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CAFE520049;
        Thu,  1 Jun 2023 16:58:01 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 43C1620040;
        Thu,  1 Jun 2023 16:58:01 +0000 (GMT)
Received: from [9.171.12.131] (unknown [9.171.12.131])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Thu,  1 Jun 2023 16:58:01 +0000 (GMT)
Message-ID: <269afffb-2d56-3b2f-9d83-485d0d29fab5@linux.ibm.com>
Date:   Thu, 1 Jun 2023 18:58:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [kvm-unit-tests PATCH v5 2/2] s390x: sclp: Implement
 extended-length-SCCB facility
Content-Language: en-US
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, thuth@redhat.com, kvm@vger.kernel.org,
        imbrenda@linux.ibm.com, david@redhat.com, nrb@linux.ibm.com,
        nsg@linux.ibm.com, cohuck@redhat.com
References: <20230601164537.31769-1-pmorel@linux.ibm.com>
 <20230601164537.31769-3-pmorel@linux.ibm.com>
In-Reply-To: <20230601164537.31769-3-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 78iKyWeCbniavBDj0uxpKwTSYUGQ2CSm
X-Proofpoint-GUID: qpr5pGBmg1y7ZLMhYx1U1Z3cQ63CcxXu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-01_08,2023-05-31_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 bulkscore=0 adultscore=0 suspectscore=0 phishscore=0
 spamscore=0 mlxscore=0 mlxlogscore=999 clxscore=1015 impostorscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2306010148
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 6/1/23 18:45, Pierre Morel wrote:
> When the extended-length-SCCB facility is present use a big
> buffer already at first try when calling sclp_read_scp_info()
> to avoid the SCLP_RC_INSUFFICIENT_SCCB_LENGTH error.
>
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>   lib/s390x/sclp.c | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/lib/s390x/sclp.c b/lib/s390x/sclp.c
> index adf357b..e44d299 100644
> --- a/lib/s390x/sclp.c
> +++ b/lib/s390x/sclp.c
> @@ -17,13 +17,14 @@
>   #include "sclp.h"
>   #include <alloc_phys.h>
>   #include <alloc_page.h>
> +#include <asm/facility.h>
>   
>   extern unsigned long stacktop;
>   
>   static uint64_t storage_increment_size;
>   static uint64_t max_ram_size;
>   static uint64_t ram_size;
> -char _read_info[PAGE_SIZE] __attribute__((__aligned__(PAGE_SIZE)));
> +char _read_info[2 * PAGE_SIZE] __attribute__((__aligned__(PAGE_SIZE)));
>   static ReadInfo *read_info;
>   struct sclp_facilities sclp_facilities;
>   
> @@ -114,6 +115,8 @@ static void sclp_read_scp_info(ReadInfo *ri, int length)
>   void sclp_read_info(void)
>   {
This line must go away.....v
>   	sclp_read_scp_info((void *)_read_info, SCCB_SIZE);

Sorry for the noise.


> +	sclp_read_scp_info((void *)_read_info,
> +		test_facility(140) ? sizeof(_read_info) : SCCB_SIZE);
>   	read_info = (ReadInfo *)_read_info;
>   }
>   
