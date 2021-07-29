Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D8AB3DA09B
	for <lists+kvm@lfdr.de>; Thu, 29 Jul 2021 11:53:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235518AbhG2JxM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jul 2021 05:53:12 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:3108 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235058AbhG2JxI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 29 Jul 2021 05:53:08 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16T9YOfF159856;
        Thu, 29 Jul 2021 05:53:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=EErjgagjsOJ6351tBtBEsNPRFPR8zetcAG7oNhArlUg=;
 b=XxR4iBRm9xjhGhqBPYKpFH9sLBiTM7j1kUqklpLT+bNBTA07U2UIUdXjCpncAOQQsMPX
 rivHngBr7jTzTwomKVIdhTD1IHCITvGFS32svqA84djUtlbQ0c61BzdyTxfCFzdXHlkR
 yCx7hQ3n6JHKJp8BCbbe1IQBwOdy/ZZtR5omUttJZYp7MtQK8C7bybgHfI7VRXL6C6nf
 Flerjz5qMuvd6mjjkhmyyyDTGql48GaxlGBsg5EDbZ6cMVjhtv/GhAbizKMNau7YFiS7
 E1qJrpYj/uJ1fjcZsjd0hZsuGTL1XMVoPH1SjQBieOPgmd2ocjY/GKTHP9R2X8UDW14t UA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a3fajubck-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 29 Jul 2021 05:53:04 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 16T9p5SZ075549;
        Thu, 29 Jul 2021 05:53:04 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a3fajubbg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 29 Jul 2021 05:53:03 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16T9r2KO023078;
        Thu, 29 Jul 2021 09:53:02 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06ams.nl.ibm.com with ESMTP id 3a235khm4g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 29 Jul 2021 09:53:02 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16T9qws524576418
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Jul 2021 09:52:59 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E09BD11C04A;
        Thu, 29 Jul 2021 09:52:58 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6455911C05B;
        Thu, 29 Jul 2021 09:52:58 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.155.135])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 29 Jul 2021 09:52:58 +0000 (GMT)
Subject: Re: [PATCH v2 13/13] KVM: s390: pv: add support for UV feature bits
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     cohuck@redhat.com, borntraeger@de.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210728142631.41860-1-imbrenda@linux.ibm.com>
 <20210728142631.41860-14-imbrenda@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Message-ID: <4d26ba27-e235-8f2b-c59c-01d3e0691453@linux.ibm.com>
Date:   Thu, 29 Jul 2021 11:52:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210728142631.41860-14-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 6YtK1rKxqZZS73Q75O_o-FDQQSAYiX0I
X-Proofpoint-ORIG-GUID: zqcN2IzNl4fE_BQ9HO6WIS3_a1mglA3N
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-29_09:2021-07-27,2021-07-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 malwarescore=0 adultscore=0 impostorscore=0 mlxlogscore=999
 priorityscore=1501 mlxscore=0 clxscore=1011 bulkscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107290061
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/28/21 4:26 PM, Claudio Imbrenda wrote:
> Add support for Ultravisor feature bits, and take advantage of the
> functionality advertised to speed up the lazy destroy mechanism.

UV feature bit support is already merged please fix the description and
subject.

> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>  arch/s390/kernel/uv.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
> index f0af49b09a91..6ec3d7338ec8 100644
> --- a/arch/s390/kernel/uv.c
> +++ b/arch/s390/kernel/uv.c
> @@ -290,7 +290,8 @@ static int make_secure_pte(pte_t *ptep, unsigned long addr,
>  
>  static bool should_export_before_import(struct uv_cb_header *uvcb, struct mm_struct *mm)
>  {
> -	return uvcb->cmd != UVC_CMD_UNPIN_PAGE_SHARED &&
> +	return !test_bit_inv(BIT_UV_FEAT_MISC, &uv_info.uv_feature_indications) &&
> +		uvcb->cmd != UVC_CMD_UNPIN_PAGE_SHARED &&
>  		atomic_read(&mm->context.is_protected) > 1;
>  }
>  
> 

