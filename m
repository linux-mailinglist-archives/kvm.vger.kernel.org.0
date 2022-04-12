Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8A064FE4D5
	for <lists+kvm@lfdr.de>; Tue, 12 Apr 2022 17:35:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357106AbiDLPiC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Apr 2022 11:38:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357082AbiDLPiA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Apr 2022 11:38:00 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C56894838D;
        Tue, 12 Apr 2022 08:35:42 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23CF04iu028519;
        Tue, 12 Apr 2022 15:35:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=N0RE52rtZxkGOjsZ/xs+nwTBX6iavermiDFZaJB3oLg=;
 b=h0lxyFPUCMQ/3aVJl8BFcduwura789RXxktOEEpybDmwV5gcLr/ZArPOjJQZgBIRxCOU
 azk2Yck0WhplRUSbfZN+DHQrcZKmRHtrpr1QiY05rUPz+tjP9RmX2LEB4v7pfO2YX9iy
 g1eXSgYtva/b1itErY7s0FX+WLrMS0HwK4v+3Nqb8pklNbHFzO/mDNklFsl+SWtERrH6
 gJNOdIzYDRZgiV6Bvr8yNqLCKtOJZ+SynwixRzAi8QKVNnWUAgeyLzGCp9zQP8/Zh6aK
 64AVs4+LQ7bZGwNJlELRRpC26Fl2GhP4KaqIoU0MPEpXZXp+gKXCzlQ92+9tm5zWvt96 0g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3fdbp30u6n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Apr 2022 15:35:41 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23CF0D9h028828;
        Tue, 12 Apr 2022 15:35:41 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3fdbp30u69-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Apr 2022 15:35:41 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23CFHgif004024;
        Tue, 12 Apr 2022 15:35:39 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma02fra.de.ibm.com with ESMTP id 3fb1s8m5y7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Apr 2022 15:35:39 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23CFZjaC46989784
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Apr 2022 15:35:45 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2A65711C04C;
        Tue, 12 Apr 2022 15:35:36 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D905B11C04A;
        Tue, 12 Apr 2022 15:35:35 +0000 (GMT)
Received: from [9.145.83.15] (unknown [9.145.83.15])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 12 Apr 2022 15:35:35 +0000 (GMT)
Message-ID: <03ea9aac-97d3-08cc-ffb1-f1be2a491d25@linux.ibm.com>
Date:   Tue, 12 Apr 2022 17:35:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [kvm-unit-tests PATCH v2 2/3] s390x: tprot: use lib include for
 mmu.h
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Cc:     imbrenda@linux.ibm.com, thuth@redhat.com, farman@linux.ibm.com
References: <cb6d8f0b-3fb4-670c-f05e-5755d8352cdf@redhat.com>
 <20220412114039.122351-1-nrb@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20220412114039.122351-1-nrb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: qQlITnc8hdbzAv859bJvRY2wf9jBSlqP
X-Proofpoint-ORIG-GUID: 5h1gfSdnhauTMsuH0nj_PyFVBT11ZgFT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-12_05,2022-04-12_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 spamscore=0 malwarescore=0 bulkscore=0 clxscore=1015
 mlxlogscore=999 phishscore=0 impostorscore=0 priorityscore=1501
 suspectscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204120073
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/12/22 13:40, Nico Boehr wrote:
> mmu.h should come from the library includes
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> Reviewed-by: Thomas Huth <thuth@redhat.com>

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

> ---
>   s390x/tprot.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/s390x/tprot.c b/s390x/tprot.c
> index 460a0db7ffcf..760e7ecdf914 100644
> --- a/s390x/tprot.c
> +++ b/s390x/tprot.c
> @@ -12,7 +12,7 @@
>   #include <bitops.h>
>   #include <asm/pgtable.h>
>   #include <asm/interrupt.h>
> -#include "mmu.h"
> +#include <mmu.h>
>   #include <vmalloc.h>
>   #include <sclp.h>
>   

