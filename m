Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B89BC3FC88D
	for <lists+kvm@lfdr.de>; Tue, 31 Aug 2021 15:44:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239305AbhHaNpC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Aug 2021 09:45:02 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:21438 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233928AbhHaNpB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 31 Aug 2021 09:45:01 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17VDd4Bm119233;
        Tue, 31 Aug 2021 09:44:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=1Fi0yUgtz9RHoLjSAVwdI/Llm2RRAhJp9ZZ/2bN7jYk=;
 b=Tzp8Ban95yOdGklYf8RiyCNVQLw9ymy6cVpKOkipLNQhIH9aKruMZ4nCYu0qzrYZeBZu
 I9hekjPBaSY17LoVcmoWHozBHnyC+7AHQij3dHmaB+PUiPEHM2SFAE2pQczTN/z4UDkE
 NxbkMuU0ybcj2CYZiHo6YCubN4Niv6MfJ9RnZ09eWx5+Rrs/sP2mqfXpb/HWIuzlSGWu
 sb/eLRLMT5CqkykmikjnJajtzIUkvGoajsYNgBWdn9clkJmKDX170xiFmOwaJH9mzY77
 ZZka/UyaO96OXPra5XAPxHay5BXQXQK7c908xy4ILcJwuatyw0UtJAGQ18ieHB79cs1w 9A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3asjbw6277-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 31 Aug 2021 09:44:05 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17VDfbkv133237;
        Tue, 31 Aug 2021 09:44:05 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3asjbw6260-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 31 Aug 2021 09:44:04 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17VDXcF6004026;
        Tue, 31 Aug 2021 13:44:02 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03fra.de.ibm.com with ESMTP id 3aqcs9adrg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 31 Aug 2021 13:44:02 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17VDhwOc33947922
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 31 Aug 2021 13:43:58 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 06C61AE06C;
        Tue, 31 Aug 2021 13:43:58 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8BA8BAE05D;
        Tue, 31 Aug 2021 13:43:57 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.145.164.122])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 31 Aug 2021 13:43:57 +0000 (GMT)
Subject: Re: [PATCH v4 01/14] KVM: s390: pv: add macros for UVC CC values
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     cohuck@redhat.com, frankja@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ulrich.Weigand@de.ibm.com
References: <20210818132620.46770-1-imbrenda@linux.ibm.com>
 <20210818132620.46770-2-imbrenda@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <6fe29ca4-61b2-6c43-f2c7-ae83c3d7a846@de.ibm.com>
Date:   Tue, 31 Aug 2021 15:43:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210818132620.46770-2-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: GYX15mX5flKO9mJ5PTYE1U64Pyr0cv6i
X-Proofpoint-GUID: bdciEbMFyNiZUjFcSn5d-tD1vXGPu2oL
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-31_05:2021-08-31,2021-08-31 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 mlxlogscore=999
 priorityscore=1501 phishscore=0 spamscore=0 impostorscore=0 malwarescore=0
 clxscore=1015 adultscore=0 bulkscore=0 lowpriorityscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108310077
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18.08.21 15:26, Claudio Imbrenda wrote:
> Add macros to describe the 4 possible CC values returned by the UVC
> instruction.

Matches the architecture. I kind of like the numerical value of the condition code, but I am already too long in this area. So I guess it will improve readability for others.

Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>   arch/s390/include/asm/uv.h | 5 +++++
>   1 file changed, 5 insertions(+)
> 
> diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
> index 12c5f006c136..b35add51b967 100644
> --- a/arch/s390/include/asm/uv.h
> +++ b/arch/s390/include/asm/uv.h
> @@ -18,6 +18,11 @@
>   #include <asm/page.h>
>   #include <asm/gmap.h>
>   
> +#define UVC_CC_OK	0
> +#define UVC_CC_ERROR	1
> +#define UVC_CC_BUSY	2
> +#define UVC_CC_PARTIAL	3
> +
>   #define UVC_RC_EXECUTED		0x0001
>   #define UVC_RC_INV_CMD		0x0002
>   #define UVC_RC_INV_STATE	0x0003
> 
