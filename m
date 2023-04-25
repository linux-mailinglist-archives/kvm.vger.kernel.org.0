Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A63EF6EDDE7
	for <lists+kvm@lfdr.de>; Tue, 25 Apr 2023 10:26:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233595AbjDYI0T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Apr 2023 04:26:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233238AbjDYI0S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Apr 2023 04:26:18 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54C174EC0;
        Tue, 25 Apr 2023 01:26:17 -0700 (PDT)
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33P7e7Fs021737;
        Tue, 25 Apr 2023 08:26:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=RJFXEGVmg0QaBKy3GTk7Nqs3lrEDArK2nAc10KMzMB4=;
 b=ebnAQyySW34BQYjBb9+e1RPRbUtodDq/n5U7BevTisq3yH6pMW5x3i9a0dWnT9rseMwV
 pFlUmJzNLCQCfS+YnDsN3s8P+DBmgFCQIujBPmJkxE6s4sVcYDHAATqVl2gbgVbJYilX
 mE5/RZIE+g5KwLbYYuev2cpZ8TBuPH9FyMtoxzdkKmrRtZxB2vb44v9/L3w+JneoOuZC
 knY+Pnlx1dMwPZVaBEIm4kM4kDaEjwIVXt22zt20YdrGqkdwi7xMSZgDjNLUrmFFtJby
 c3NwhXLjBTLvqsQviQfehSdln5ZAmH8RYz3PTeUSq8sXamQdPZupbBqBfepP/pwTM0L2 6A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q6ad81wws-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Apr 2023 08:26:15 +0000
Received: from m0353726.ppops.net (m0353726.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 33P7qhY7015688;
        Tue, 25 Apr 2023 08:26:15 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q6ad81wv4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Apr 2023 08:26:15 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 33P5MsqD010774;
        Tue, 25 Apr 2023 08:26:12 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma04fra.de.ibm.com (PPS) with ESMTPS id 3q47771av6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Apr 2023 08:26:12 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 33P8Q8pR8979092
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Apr 2023 08:26:09 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D71DA20043;
        Tue, 25 Apr 2023 08:26:08 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7BEBD20040;
        Tue, 25 Apr 2023 08:26:08 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.56])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 25 Apr 2023 08:26:08 +0000 (GMT)
Date:   Tue, 25 Apr 2023 10:26:06 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        thuth@redhat.com, kvm@vger.kernel.org, david@redhat.com,
        nrb@linux.ibm.com, nsg@linux.ibm.com, cohuck@redhat.com
Subject: Re: [kvm-unit-tests PATCH 1/1] s390x: sclp: consider monoprocessor
 on read_info error
Message-ID: <20230425102606.4e9bc606@p-imbrenda>
In-Reply-To: <20230424174218.64145-2-pmorel@linux.ibm.com>
References: <20230424174218.64145-1-pmorel@linux.ibm.com>
        <20230424174218.64145-2-pmorel@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: wokmxvjtEi9D1VcES3s22bOcxs_GnW1K
X-Proofpoint-GUID: O6F0X3EjBUDq2b3Z7CZIX0m2KO42ZaCz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-25_03,2023-04-21_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 phishscore=0 malwarescore=0 suspectscore=0 mlxlogscore=999
 priorityscore=1501 adultscore=0 mlxscore=0 bulkscore=0 spamscore=0
 impostorscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2303200000 definitions=main-2304250068
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 24 Apr 2023 19:42:18 +0200
Pierre Morel <pmorel@linux.ibm.com> wrote:

> When we can not read SCP information we can not abort during
> sclp_get_cpu_num() because this function is called during exit
> and calling it will lead to an infnite loop.
> 
> The loop is:
> abort() -> exit() -> smp_teardown() -> smp_query_num_cpus() ->
> sclp_get_cpu_num() -> assert() -> abort()
> 
> Since smp_setup() is done after sclp_read_info() inside setup() this
> loop happens when only the start processor is running.
> Let sclp_get_cpu_num() return 1 in this case.

looks good to me, but please add a comment to explain that this is only
supposed to happen in exceptional circumstances

> 
> Fixes: 52076a63d569 ("s390x: Consolidate sclp read info")
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  lib/s390x/sclp.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/s390x/sclp.c b/lib/s390x/sclp.c
> index acdc8a9..c09360d 100644
> --- a/lib/s390x/sclp.c
> +++ b/lib/s390x/sclp.c
> @@ -119,8 +119,9 @@ void sclp_read_info(void)
>  
>  int sclp_get_cpu_num(void)
>  {
> -	assert(read_info);
> -	return read_info->entries_cpu;
> +    if (read_info)
> +	    return read_info->entries_cpu;
> +    return 1;
>  }
>  
>  CPUEntry *sclp_get_cpu_entries(void)

