Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E48D19F7D
	for <lists+kvm@lfdr.de>; Fri, 10 May 2019 16:45:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727258AbfEJOpZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 May 2019 10:45:25 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:44942 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727144AbfEJOpZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 10 May 2019 10:45:25 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4AEhG1x011730
        for <kvm@vger.kernel.org>; Fri, 10 May 2019 10:45:24 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2sdb468sub-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 10 May 2019 10:45:23 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pmorel@linux.ibm.com>;
        Fri, 10 May 2019 15:45:21 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 10 May 2019 15:45:18 +0100
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x4AEjHIQ56688666
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 May 2019 14:45:17 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F0692A40F2;
        Fri, 10 May 2019 14:45:16 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 38372A40C1;
        Fri, 10 May 2019 14:45:16 +0000 (GMT)
Received: from [9.145.187.238] (unknown [9.145.187.238])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 10 May 2019 14:45:16 +0000 (GMT)
Reply-To: pmorel@linux.ibm.com
Subject: Re: [PATCH 1/4] s390: pci: Exporting access to CLP PCI function and
 PCI group
To:     Robin Murphy <robin.murphy@arm.com>, sebott@linux.vnet.ibm.com
Cc:     linux-s390@vger.kernel.org, pasic@linux.vnet.ibm.com,
        alex.williamson@redhat.com, kvm@vger.kernel.org,
        heiko.carstens@de.ibm.com, walling@linux.ibm.com,
        linux-kernel@vger.kernel.org, borntraeger@de.ibm.com,
        iommu@lists.linux-foundation.org, schwidefsky@de.ibm.com,
        gerald.schaefer@de.ibm.com
References: <1557476555-20256-1-git-send-email-pmorel@linux.ibm.com>
 <1557476555-20256-2-git-send-email-pmorel@linux.ibm.com>
 <a06ffd83-5fde-8c6e-b25b-bd4163d4cd5f@arm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Date:   Fri, 10 May 2019 16:45:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <a06ffd83-5fde-8c6e-b25b-bd4163d4cd5f@arm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19051014-0016-0000-0000-0000027A60B1
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19051014-0017-0000-0000-000032D71C91
Message-Id: <289bdf82-75ba-4ba4-9362-dd8fc721cfc8@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-09_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905100102
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/05/2019 12:21, Robin Murphy wrote:
> On 10/05/2019 09:22, Pierre Morel wrote:
>> For the generic implementation of VFIO PCI we need to retrieve
>> the hardware configuration for the PCI functions and the
>> PCI function groups.
>>
>> We modify the internal function using CLP Query PCI function and
>> CLP query PCI function group so that they can be called from
>> outside the S390 architecture PCI code and prefix the two
>> functions with "zdev" to make clear that they can be called
>> knowing only the associated zdevice.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> Reviewed-by: Sebastian Ott <sebott@linux.ibm.com>
>> ---
>>   arch/s390/include/asm/pci.h |  3 ++
>>   arch/s390/pci/pci_clp.c     | 72 
>> ++++++++++++++++++++++++---------------------
>>   2 files changed, 41 insertions(+), 34 deletions(-)
>>
>> diff --git a/arch/s390/include/asm/pci.h b/arch/s390/include/asm/pci.h
>> index 305befd..e66b246 100644
>> --- a/arch/s390/include/asm/pci.h
>> +++ b/arch/s390/include/asm/pci.h
>> @@ -261,4 +261,7 @@ cpumask_of_pcibus(const struct pci_bus *bus)
>>   #endif /* CONFIG_NUMA */
>> +int zdev_query_pci_fngrp(struct zpci_dev *zdev,
>> +             struct clp_req_rsp_query_pci_grp *rrb);
>> +int zdev_query_pci_fn(struct zpci_dev *zdev, struct 
>> clp_req_rsp_query_pci *rrb);
>>   #endif
>> diff --git a/arch/s390/pci/pci_clp.c b/arch/s390/pci/pci_clp.c
>> index 3a36b07..4ae5d77 100644
>> --- a/arch/s390/pci/pci_clp.c
>> +++ b/arch/s390/pci/pci_clp.c
>> @@ -113,32 +113,18 @@ static void clp_store_query_pci_fngrp(struct 
>> zpci_dev *zdev,
>>       }
>>   }
>> -static int clp_query_pci_fngrp(struct zpci_dev *zdev, u8 pfgid)
>> +int zdev_query_pci_fngrp(struct zpci_dev *zdev,
>> +             struct clp_req_rsp_query_pci_grp *rrb)
>>   {
>> -    struct clp_req_rsp_query_pci_grp *rrb;
>> -    int rc;
>> -
>> -    rrb = clp_alloc_block(GFP_KERNEL);
>> -    if (!rrb)
>> -        return -ENOMEM;
>> -
>>       memset(rrb, 0, sizeof(*rrb));
>>       rrb->request.hdr.len = sizeof(rrb->request);
>>       rrb->request.hdr.cmd = CLP_QUERY_PCI_FNGRP;
>>       rrb->response.hdr.len = sizeof(rrb->response);
>> -    rrb->request.pfgid = pfgid;
>> +    rrb->request.pfgid = zdev->pfgid;
>> -    rc = clp_req(rrb, CLP_LPS_PCI);
>> -    if (!rc && rrb->response.hdr.rsp == CLP_RC_OK)
>> -        clp_store_query_pci_fngrp(zdev, &rrb->response);
>> -    else {
>> -        zpci_err("Q PCI FGRP:\n");
>> -        zpci_err_clp(rrb->response.hdr.rsp, rc);
>> -        rc = -EIO;
>> -    }
>> -    clp_free_block(rrb);
>> -    return rc;
>> +    return clp_req(rrb, CLP_LPS_PCI);
>>   }
>> +EXPORT_SYMBOL(zdev_query_pci_fngrp);
> 
> AFAICS it's only the IOMMU driver itself which needs to call these. That 
> can't be built as a module, so you shouldn't need explicit exports - the 
> header declaration is enough.
> 
> Robin.

This is right and seeing the pointer type only zPCI and s390iommu can 
make use of it.
If nobody has another point of view I will remove the export on the
next iteration.

Thanks,
Pierre

> 
>>   static int clp_store_query_pci_fn(struct zpci_dev *zdev,
>>                     struct clp_rsp_query_pci *response)
>> @@ -174,32 +160,50 @@ static int clp_store_query_pci_fn(struct 
>> zpci_dev *zdev,
>>       return 0;
>>   }
>> -static int clp_query_pci_fn(struct zpci_dev *zdev, u32 fh)
>> +int zdev_query_pci_fn(struct zpci_dev *zdev, struct 
>> clp_req_rsp_query_pci *rrb)
>> +{
>> +
>> +    memset(rrb, 0, sizeof(*rrb));
>> +    rrb->request.hdr.len = sizeof(rrb->request);
>> +    rrb->request.hdr.cmd = CLP_QUERY_PCI_FN;
>> +    rrb->response.hdr.len = sizeof(rrb->response);
>> +    rrb->request.fh = zdev->fh;
>> +
>> +    return clp_req(rrb, CLP_LPS_PCI);
>> +}
>> +EXPORT_SYMBOL(zdev_query_pci_fn);
>> +
>> +static int clp_query_pci(struct zpci_dev *zdev)
>>   {
>>       struct clp_req_rsp_query_pci *rrb;
>> +    struct clp_req_rsp_query_pci_grp *grrb;
>>       int rc;
>>       rrb = clp_alloc_block(GFP_KERNEL);
>>       if (!rrb)
>>           return -ENOMEM;
>> -    memset(rrb, 0, sizeof(*rrb));
>> -    rrb->request.hdr.len = sizeof(rrb->request);
>> -    rrb->request.hdr.cmd = CLP_QUERY_PCI_FN;
>> -    rrb->response.hdr.len = sizeof(rrb->response);
>> -    rrb->request.fh = fh;
>> -
>> -    rc = clp_req(rrb, CLP_LPS_PCI);
>> -    if (!rc && rrb->response.hdr.rsp == CLP_RC_OK) {
>> -        rc = clp_store_query_pci_fn(zdev, &rrb->response);
>> -        if (rc)
>> -            goto out;
>> -        rc = clp_query_pci_fngrp(zdev, rrb->response.pfgid);
>> -    } else {
>> +    rc = zdev_query_pci_fn(zdev, rrb);
>> +    if (rc || rrb->response.hdr.rsp != CLP_RC_OK) {
>>           zpci_err("Q PCI FN:\n");
>>           zpci_err_clp(rrb->response.hdr.rsp, rc);
>>           rc = -EIO;
>> +        goto out;
>>       }
>> +    rc = clp_store_query_pci_fn(zdev, &rrb->response);
>> +    if (rc)
>> +        goto out;
>> +
>> +    grrb = (struct clp_req_rsp_query_pci_grp *)rrb;
>> +    rc = zdev_query_pci_fngrp(zdev, grrb);
>> +    if (rc || grrb->response.hdr.rsp != CLP_RC_OK) {
>> +        zpci_err("Q PCI FGRP:\n");
>> +        zpci_err_clp(grrb->response.hdr.rsp, rc);
>> +        rc = -EIO;
>> +        goto out;
>> +    }
>> +    clp_store_query_pci_fngrp(zdev, &grrb->response);
>> +
>>   out:
>>       clp_free_block(rrb);
>>       return rc;
>> @@ -219,7 +223,7 @@ int clp_add_pci_device(u32 fid, u32 fh, int 
>> configured)
>>       zdev->fid = fid;
>>       /* Query function properties and update zdev */
>> -    rc = clp_query_pci_fn(zdev, fh);
>> +    rc = clp_query_pci(zdev);
>>       if (rc)
>>           goto error;
>>
> 


-- 
Pierre Morel
Linux/KVM/QEMU in Böblingen - Germany

