Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 663B35F7A55
	for <lists+kvm@lfdr.de>; Fri,  7 Oct 2022 17:12:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbiJGPMd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Oct 2022 11:12:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230034AbiJGPMa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Oct 2022 11:12:30 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CD1E102DD8
        for <kvm@vger.kernel.org>; Fri,  7 Oct 2022 08:12:26 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 297F9UPV039531;
        Fri, 7 Oct 2022 15:12:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=w7pn3Qi9mLXy7VdZ8iUIXtHFT0cSoKeq5vxyg4lrJmk=;
 b=iaSgbFXfcErd1pANyf/EQfaduAVLdPl6Gy7BoHj5Sl6QxclQCKrOk7kVtWgQyW2R/gPF
 xWTcd053fN4nK7Hp7vfiwLWT+npUh1+B5/ON+ySXPk5bOk3LN4emWtySEl/5GFLUq6Cb
 8VDK4oB2baPdZfVdYV4ROmNVFI3Q18RtBm0/YiPJ4ID//3WOHAqDg2g1pPRa4w1T3pH+
 UHj+hk959FqQ+xopstdvilPGXTDe+24MdvbfevPdC77cUmfEweoxIukcsLTDDd0eQYjr
 VQPUzzgOtj0O+C7cVdpghKh8ASINNihm8zXeSD/M+DLXqw0CU4fSvxRpnujhbbpp3mIu eA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k2mugktw7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 07 Oct 2022 15:12:20 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 297F9k41000438;
        Fri, 7 Oct 2022 15:12:19 GMT
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k2mugktvf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 07 Oct 2022 15:12:19 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 297F5m14032757;
        Fri, 7 Oct 2022 15:12:18 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma02dal.us.ibm.com with ESMTP id 3k28d2d4rd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 07 Oct 2022 15:12:18 +0000
Received: from smtpav04.wdc07v.mail.ibm.com ([9.208.128.116])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 297FCG9D8979076
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 7 Oct 2022 15:12:17 GMT
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6AA8658050;
        Fri,  7 Oct 2022 15:12:16 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F350258058;
        Fri,  7 Oct 2022 15:12:14 +0000 (GMT)
Received: from [9.160.126.121] (unknown [9.160.126.121])
        by smtpav04.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Fri,  7 Oct 2022 15:12:14 +0000 (GMT)
Message-ID: <26ca1bd8-c100-3c20-d425-6f7bee0ee53a@linux.ibm.com>
Date:   Fri, 7 Oct 2022 11:12:14 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH v2 0/3] Allow the group FD to remain open when unplugging
 a device
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Qian Cai <cai@lca.pw>, Eric Farman <farman@linux.ibm.com>,
        Joerg Roedel <jroedel@suse.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Yi Liu <yi.l.liu@intel.com>
References: <0-v2-15417f29324e+1c-vfio_group_disassociate_jgg@nvidia.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <0-v2-15417f29324e+1c-vfio_group_disassociate_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: seqN8yIf5dxpOnRVqpam9Vycf_WeaNn4
X-Proofpoint-ORIG-GUID: yKBYJmtxc7WwyL4RBH48VRQuqjNTAUmZ
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-06_05,2022-10-07_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 spamscore=0 clxscore=1015 mlxscore=0 malwarescore=0 priorityscore=1501
 adultscore=0 lowpriorityscore=0 mlxlogscore=999 impostorscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210070090
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/7/22 10:04 AM, Jason Gunthorpe wrote:
> Testing has shown that virtnodedevd will leave the group FD open for long
> periods, even after all the cdevs have been destroyed. This blocks
> destruction of the VFIO device and is undesirable.
> 
> That approach was selected to accomodate SPAPR which has an broken
> lifecyle model for the iommu_group. However, we can accomodate SPAPR by
> realizing that it doesn't use the iommu core at all, so rules about
> iommu_group lifetime do not apply to it.
> 
> Giving the KVM code its own kref on the iommu_group allows the VFIO core
> code to release its iommu_group reference earlier and we can remove the
> sleep that only existed for SPAPR.
> 
> v2:
>  - Use vfio_file_is_group() istead of open coding
>  - Do not delete vfio_group_detach_container() from
>    vfio_group_fops_release()
> v1: https://lore.kernel.org/r/0-v1-90bf0950c42c+39-vfio_group_disassociate_jgg@nvidia.com

OK, just wanted to close the loop here.  Besides my testing v1+fixup yesterday which looked good, I also just now tested vfio-pci on s390 intentionally leaving the device bound to the vfio-pci driver over multiple VM starts/shutdowns (which was broken in v1).  This is working for me now too.  Thanks Jason!

> 
> Jason Gunthorpe (3):
>   vfio: Add vfio_file_is_group()
>   vfio: Hold a reference to the iommu_group in kvm for SPAPR
>   vfio: Make the group FD disassociate from the iommu_group
> 
>  drivers/vfio/pci/vfio_pci_core.c |  2 +-
>  drivers/vfio/vfio.h              |  1 -
>  drivers/vfio/vfio_main.c         | 85 +++++++++++++++++++++++---------
>  include/linux/vfio.h             |  1 +
>  virt/kvm/vfio.c                  | 45 ++++++++++++-----
>  5 files changed, 95 insertions(+), 39 deletions(-)
> 
> 
> base-commit: c82e81ab2569559ad873b3061217c2f37560682b

