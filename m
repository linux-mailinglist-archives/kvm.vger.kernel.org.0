Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35B7E2FBAF1
	for <lists+kvm@lfdr.de>; Tue, 19 Jan 2021 16:20:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728699AbhASPT5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jan 2021 10:19:57 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:58658 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2391181AbhASPTV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 19 Jan 2021 10:19:21 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10JFEK05113214;
        Tue, 19 Jan 2021 10:18:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=7w6NADPRijopnAoi60maFCcOkIgyFaIJ/XQxNhYWGEU=;
 b=B8/1mL9IjctuCW663noAlmJA7xHUxPAMqv+69tpZQhm28PK4eSlcjXE6jSxnGSAZklkv
 rvI/fUZHe2WbKnRxH9kL6/XNR+jWkgUPC7BZdFm6vhGT6WTtT2+c0kqmbDOyXrBWyczc
 VdhdZgXTNSpJoAXAG1m/nkAypX9cqA7zJDb+TilyWblPE738v0eptFAsqq0CQ/vmM8C8
 e6W+fQ0il+spkO+XAdvQttf06tTPeQ7fZjGDuJa7H+k5FOgxhzzLcBf33QlnQoC+VzEJ
 soLE24Q01Oxc+3sD3wp4YnX7mCh1l2/dP/eQCr/txBQMOtDP/xxr7DFh9aSFyUOcqV5O Ug== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3661vqr4ec-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jan 2021 10:18:38 -0500
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10JFFZx9120134;
        Tue, 19 Jan 2021 10:18:37 -0500
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3661vqr4d9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jan 2021 10:18:37 -0500
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10JFHVwp023725;
        Tue, 19 Jan 2021 15:18:35 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06fra.de.ibm.com with ESMTP id 363qdh9nmk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jan 2021 15:18:35 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10JFIXiX34013618
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Jan 2021 15:18:33 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 057EA52052;
        Tue, 19 Jan 2021 15:18:33 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.160.34])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 6F3855204F;
        Tue, 19 Jan 2021 15:18:32 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v2 02/11] lib/list.h: add list_add_tail
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     david@redhat.com, thuth@redhat.com, pbonzini@redhat.com,
        cohuck@redhat.com, lvivier@redhat.com, nadav.amit@gmail.com,
        krish.sadhukhan@oracle.com
References: <20210115123730.381612-1-imbrenda@linux.ibm.com>
 <20210115123730.381612-3-imbrenda@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Message-ID: <1ad3668c-5719-4693-0489-de2d1876b987@linux.ibm.com>
Date:   Tue, 19 Jan 2021 16:18:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210115123730.381612-3-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-19_05:2021-01-18,2021-01-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 impostorscore=0
 lowpriorityscore=0 clxscore=1015 priorityscore=1501 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101190091
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/15/21 1:37 PM, Claudio Imbrenda wrote:
> Add a list_add_tail wrapper function to allow adding elements to the end
> of a list.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>

Reviewed-by: Janosch Frank <frankja@de.ibm.com>

> ---
>  lib/list.h | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/lib/list.h b/lib/list.h
> index 18d9516..7f9717e 100644
> --- a/lib/list.h
> +++ b/lib/list.h
> @@ -50,4 +50,13 @@ static inline void list_add(struct linked_list *head, struct linked_list *li)
>  	head->next = li;
>  }
>  
> +/*
> + * Add the given element before the given list head.
> + */
> +static inline void list_add_tail(struct linked_list *head, struct linked_list *li)
> +{
> +	assert(head);
> +	list_add(head->prev, li);
> +}
> +
>  #endif
> 

