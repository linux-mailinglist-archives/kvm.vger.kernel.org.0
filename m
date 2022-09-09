Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 901555B382D
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 14:52:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229502AbiIIMuM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Sep 2022 08:50:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbiIIMuH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Sep 2022 08:50:07 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C44645757D
        for <kvm@vger.kernel.org>; Fri,  9 Sep 2022 05:50:05 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 289Cg6wb027443;
        Fri, 9 Sep 2022 12:49:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=zjj65OqKhotopLjAkLfbs1w4hoRX5Zb4/pyBQbnUohw=;
 b=MreDbMX7AB4ND1EBuzMJH5LHgQefur7xB/aLA0iZ1Sw+kCTrNizD9vbMLMdB40wcEKCS
 rK7PfuoByQuR3YRMB8zVrBpxaLKBm0XTiYHL3wXcQ4wQJBfaM3ZFk9Hl49B9hGt3my83
 VmI1VhKvSMdLEoerMdnTXWYuTY7A/z5JsC3+R7Ziv6M9aOGraU8s5qVbMWwkstnSIsbC
 ij+bf8eqosAph3ideZ57j6mRjq08QgpT8+KwfraUGNhVdOqFrFfO0mQO0UIpDgKma4sw
 h2wgC9IW7j54aG74U06uB8kY696YD5c0TwjP3J/XLex26mz0ZPm0r8Poybrb5MMHE8Wh Cg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jg5qcg839-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 09 Sep 2022 12:49:44 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 289Ch3ja001197;
        Fri, 9 Sep 2022 12:49:44 GMT
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jg5qcg82f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 09 Sep 2022 12:49:44 +0000
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 289CKRot029638;
        Fri, 9 Sep 2022 12:49:42 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma05wdc.us.ibm.com with ESMTP id 3jbxjaevev-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 09 Sep 2022 12:49:42 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 289Cnfvh42467596
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 9 Sep 2022 12:49:41 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A873C6E056;
        Fri,  9 Sep 2022 12:49:41 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 90CB56E04E;
        Fri,  9 Sep 2022 12:49:40 +0000 (GMT)
Received: from [9.160.125.58] (unknown [9.160.125.58])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri,  9 Sep 2022 12:49:40 +0000 (GMT)
Message-ID: <28f45073-0047-3f8a-c79f-6dd6cc1d4117@linux.ibm.com>
Date:   Fri, 9 Sep 2022 08:49:40 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH 0/4] Fix splats releated to using the iommu_group after
 destroying devices
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, iommu@lists.linux.dev,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        Will Deacon <will@kernel.org>
Cc:     Qian Cai <cai@lca.pw>, Joerg Roedel <jroedel@suse.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Robin Murphy <robin.murphy@arm.com>
References: <0-v1-ef00ffecea52+2cb-iommu_group_lifetime_jgg@nvidia.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <0-v1-ef00ffecea52+2cb-iommu_group_lifetime_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: bsxPznhpLKbKUh_qqVtx_sOqa5xr7DpS
X-Proofpoint-GUID: RKYwAk6a2-p0o09e7kIVDamCgg1sh1mV
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-09_06,2022-09-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 suspectscore=0 phishscore=0 spamscore=0 clxscore=1011 lowpriorityscore=0
 adultscore=0 malwarescore=0 mlxlogscore=999 priorityscore=1501 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2209090043
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/8/22 2:44 PM, Jason Gunthorpe wrote:
> The basic issue is that the iommu_group is being used by VFIO after all
> the device drivers have been removed.
> 
> In part this is caused by bad logic inside the iommu core that doesn't
> sequence removing the device from the group properly, and in another part
> this is bad logic in VFIO continuing to use device->iommu_group after all
> VFIO device drivers have been removed.
> 
> Fix both situations. Either fix alone should fix the bug reported, but
> both together bring a nice robust design to this area.
> 
> This is a followup from this thread:
> 
> https://lore.kernel.org/kvm/20220831201236.77595-1-mjrosato@linux.ibm.com/
> 
> Matthew confirmed an earlier version of the series solved the issue, it
> would be best if he would test this as well to confirm the various changes
> are still OK.

FYI I've been running this series (+ the incremental to patch 4 you mentioned) against my original repro scenario in a loop overnight, looks good.

> 
> The iommu patch is independent of the other patches, it can go through the
> iommu rc tree.
> 
> Jason Gunthorpe (4):
>   vfio: Simplify vfio_create_group()
>   vfio: Move the sanity check of the group to vfio_create_group()
>   vfio: Follow a strict lifetime for struct iommu_group *
>   iommu: Fix ordering of iommu_release_device()
> 
>  drivers/iommu/iommu.c    |  36 ++++++--
>  drivers/vfio/vfio_main.c | 172 +++++++++++++++++++++------------------
>  2 files changed, 120 insertions(+), 88 deletions(-)
> 
> 
> base-commit: 245898eb9275ce31942cff95d0bdc7412ad3d589

