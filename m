Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAA8E4753DD
	for <lists+kvm@lfdr.de>; Wed, 15 Dec 2021 08:46:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233600AbhLOHqM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Dec 2021 02:46:12 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:10852 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230260AbhLOHqM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 15 Dec 2021 02:46:12 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BF65c7X004919;
        Wed, 15 Dec 2021 07:46:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=uhtcZdGTifyVIrja1We/7gBgwns5khTbgM0514Yt6lg=;
 b=TZkbjSYPLkY2x3zCM6WIdN92iFZCzifUkLzi+LTdysleG3FeKsvs4IFo48iU6AKfvmN9
 n925I+ipX0rqhBCptZwZD2+3mdH7tWIBNaPsJWCo6ldhJKzYy1VT8aWX0nbgvoMTyk25
 8LyeWLDBE4lXpRRdNvMtziYZ307d3HbdRRc3iBD6e1UmaCvjTsPjIjypG6eil+9HDb2e
 kALeVw2AwZuvsjKPYqm6KEiWJycGWXgbVhilCPkg/rseHhYZChQvobrFU9lLotmylSj5
 Y7RdGzCSYln42NdTgsPsolfTj53qqHDiD9XtE4Wle8K1mg7YMCSWl28Za6/dRoprsNOW HQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cx9r9tn1p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Dec 2021 07:46:07 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1BF70Fga014101;
        Wed, 15 Dec 2021 07:46:07 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cx9r9tn0r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Dec 2021 07:46:07 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1BF7hNhM026374;
        Wed, 15 Dec 2021 07:46:04 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma02fra.de.ibm.com with ESMTP id 3cy7sj9xw4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Dec 2021 07:46:04 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1BF7k0Vd30867848
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Dec 2021 07:46:00 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 966A2A4053;
        Wed, 15 Dec 2021 07:46:00 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B2639A405F;
        Wed, 15 Dec 2021 07:45:59 +0000 (GMT)
Received: from [9.171.24.181] (unknown [9.171.24.181])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 15 Dec 2021 07:45:59 +0000 (GMT)
Message-ID: <4ef28ffc-976d-2995-849a-bf8d0a228661@linux.ibm.com>
Date:   Wed, 15 Dec 2021 08:47:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 11/12] s390x/pci: use dtsm provided from vfio capabilities
 for interpreted devices
Content-Language: en-US
To:     Matthew Rosato <mjrosato@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     alex.williamson@redhat.com, schnelle@linux.ibm.com,
        cohuck@redhat.com, thuth@redhat.com, farman@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com,
        pasic@linux.ibm.com, borntraeger@linux.ibm.com, mst@redhat.com,
        pbonzini@redhat.com, qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20211207210425.150923-1-mjrosato@linux.ibm.com>
 <20211207210425.150923-12-mjrosato@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <20211207210425.150923-12-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: FxW-0pHLZkN97cat70pzCLLFb0KxROi-
X-Proofpoint-ORIG-GUID: QzfIJw0z3fKrrv7ZHXljrFrurTla1LM6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-15_06,2021-12-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 mlxlogscore=999 phishscore=0 adultscore=0 bulkscore=0
 spamscore=0 priorityscore=1501 mlxscore=0 clxscore=1015 lowpriorityscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112150042
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 12/7/21 22:04, Matthew Rosato wrote:
> When using the IOAT assist via interpretation, we should advertise what
> the host driver supports, not QEMU.
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>   hw/s390x/s390-pci-vfio.c | 6 +++++-
>   1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/hw/s390x/s390-pci-vfio.c b/hw/s390x/s390-pci-vfio.c
> index 6fc03a858a..c9269683f5 100644
> --- a/hw/s390x/s390-pci-vfio.c
> +++ b/hw/s390x/s390-pci-vfio.c
> @@ -336,7 +336,11 @@ static void s390_pci_read_group(S390PCIBusDevice *pbdev,
>           resgrp->i = cap->noi;
>           resgrp->maxstbl = cap->maxstbl;
>           resgrp->version = cap->version;
> -        resgrp->dtsm = ZPCI_DTSM;
> +        if (hdr->version >= 2 && pbdev->interp) {
> +            resgrp->dtsm = cap->dtsm;
> +        } else {
> +            resgrp->dtsm = ZPCI_DTSM;
> +        }
>       }
>   }
>   
> 
Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>

-- 
Pierre Morel
IBM Lab Boeblingen
