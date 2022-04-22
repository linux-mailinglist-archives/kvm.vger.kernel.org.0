Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB1F250B441
	for <lists+kvm@lfdr.de>; Fri, 22 Apr 2022 11:41:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1446147AbiDVJnj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Apr 2022 05:43:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353303AbiDVJnc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Apr 2022 05:43:32 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9344844A12
        for <kvm@vger.kernel.org>; Fri, 22 Apr 2022 02:40:39 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23M8gBZE004925;
        Fri, 22 Apr 2022 09:40:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=3mPYrZiCFsGlzZPvWuAMQcQYvBhkD+0kMPJg2kAgOgo=;
 b=gom2dwWu6j0PtfaDQqer/fahY/j1p4OQfBnMtt8/wIle5mcZwsUKKE2vWD9UBAXOtlWx
 pVOFDM+5ryG3PZ6q867CJqphqdG0gbSdVkA1sbzVVIqww5xTNSLGEe5aUjVCVCccXqWL
 /kdy+bI8v4ByOtBREWHs2jLopE5l03S+WIfMjSlLjM1YLAh26ByzvlxAO/bFdun9Y1zS
 ds5iQAse7XZQEekfueKZxBfLUdHcqFIrpJJy++mHRb8+Cv57FUi7dNxKCFe/Qj4et9Cd
 /hol3iZZZel5SqWPIC1hWK6IpzZBm7XXdkIwOm3UVSrdY9YPYJARTVxGgdpMxxHYr+/a Jg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3fjer9c39j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Apr 2022 09:40:35 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23M9QiBx017770;
        Fri, 22 Apr 2022 09:40:35 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3fjer9c391-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Apr 2022 09:40:35 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23M9NLnU019359;
        Fri, 22 Apr 2022 09:40:33 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma02fra.de.ibm.com with ESMTP id 3fgu6u5q0y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Apr 2022 09:40:33 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23M9eTrr33030624
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Apr 2022 09:40:30 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D405BA404D;
        Fri, 22 Apr 2022 09:40:29 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EB4BFA4040;
        Fri, 22 Apr 2022 09:40:28 +0000 (GMT)
Received: from [9.171.20.253] (unknown [9.171.20.253])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 22 Apr 2022 09:40:28 +0000 (GMT)
Message-ID: <43e63ad6-7dba-642d-2039-a63e89f8bdf2@linux.ibm.com>
Date:   Fri, 22 Apr 2022 11:43:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v5 9/9] s390x/pci: reflect proper maxstbl for groups of
 interpreted devices
Content-Language: en-US
To:     Matthew Rosato <mjrosato@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     alex.williamson@redhat.com, schnelle@linux.ibm.com,
        cohuck@redhat.com, thuth@redhat.com, farman@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com,
        pasic@linux.ibm.com, borntraeger@linux.ibm.com, mst@redhat.com,
        pbonzini@redhat.com, qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20220404181726.60291-1-mjrosato@linux.ibm.com>
 <20220404181726.60291-10-mjrosato@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <20220404181726.60291-10-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: AC52ZQVCLQ949ioZ1tObjhnzynAgKSJh
X-Proofpoint-ORIG-GUID: lMrrDfxa8LNGnLcbvVo83bUHvEixn-0d
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-22_02,2022-04-21_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 mlxscore=0 priorityscore=1501 phishscore=0 malwarescore=0 mlxlogscore=999
 lowpriorityscore=0 spamscore=0 adultscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204220042
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4/4/22 20:17, Matthew Rosato wrote:
> The maximum supported store block length might be different depending
> on whether the instruction is interpretively executed (firmware-reported
> maximum) or handled via userspace intercept (host kernel API maximum).
> Choose the best available value during group creation.
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>

Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>

> ---
>   hw/s390x/s390-pci-vfio.c | 6 +++++-
>   1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/hw/s390x/s390-pci-vfio.c b/hw/s390x/s390-pci-vfio.c
> index 985980f021..212dd053f7 100644
> --- a/hw/s390x/s390-pci-vfio.c
> +++ b/hw/s390x/s390-pci-vfio.c
> @@ -213,7 +213,11 @@ static void s390_pci_read_group(S390PCIBusDevice *pbdev,
>           resgrp->msia = cap->msi_addr;
>           resgrp->mui = cap->mui;
>           resgrp->i = cap->noi;
> -        resgrp->maxstbl = cap->maxstbl;
> +        if (pbdev->interp && hdr->version >= 2) {
> +            resgrp->maxstbl = cap->imaxstbl;
> +        } else {
> +            resgrp->maxstbl = cap->maxstbl;
> +        }
>           resgrp->version = cap->version;
>           resgrp->dtsm = ZPCI_DTSM;
>       }
> 

-- 
Pierre Morel
IBM Lab Boeblingen
