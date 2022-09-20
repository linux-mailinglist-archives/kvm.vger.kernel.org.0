Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD0945BEDD2
	for <lists+kvm@lfdr.de>; Tue, 20 Sep 2022 21:32:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231440AbiITTca (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 15:32:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230285AbiITTc3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 15:32:29 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3703352FDA
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 12:32:28 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28KIj6N1001043;
        Tue, 20 Sep 2022 19:32:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=nmT82v55Wya1AWjxX7w9AGfHtXArTlV2NXjiT22NBmE=;
 b=aZwKHKAkXqUg88kO5C9B1T5AKT5/YtpUMiKBgmi2bIVVsEYkxI3gej0gp1f8xf6Y9MrI
 MiLd9H/buK0MpCkqeECU9SmEarJKz8aeNK1cL1u/VguujIw4A0tdsHGfqmRVtV+AdnPE
 krreeMzTnAEfuuW3CcbTmHcjRA+K3h9iWCckfsyEj8rsVq35GE1Ut/S1PdzyuHHx1DEv
 iQALopM3rl8vRf530LVyOEafSZZvYxDVOGcRWTAXJ2ychQVWgM03uRINIS7EmbRTGO5y
 aPYYkZZg2FbD/WMM8vfv/UBMp7Ak8MpKIte/nPJ9IvGJO12qcuopJrm5QZ3uWB9h4dy4 eg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jqk2j1gc1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Sep 2022 19:32:11 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 28KJGkYn032025;
        Tue, 20 Sep 2022 19:32:10 GMT
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jqk2j1gbh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Sep 2022 19:32:10 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 28KJL36U001283;
        Tue, 20 Sep 2022 19:32:09 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma02dal.us.ibm.com with ESMTP id 3jn5v9u2rj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Sep 2022 19:32:09 +0000
Received: from smtpav05.dal12v.mail.ibm.com ([9.208.128.132])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 28KJW7qP29229696
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Sep 2022 19:32:07 GMT
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0FD8B5804C;
        Tue, 20 Sep 2022 19:32:08 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 049B258056;
        Tue, 20 Sep 2022 19:32:07 +0000 (GMT)
Received: from [9.65.230.56] (unknown [9.65.230.56])
        by smtpav05.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 20 Sep 2022 19:32:06 +0000 (GMT)
Message-ID: <d15a08f6-fd0d-d28d-2b35-34c445d9b11e@linux.ibm.com>
Date:   Tue, 20 Sep 2022 15:32:06 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH 3/4] vfio: Follow a strict lifetime for struct iommu_group
 *
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, iommu@lists.linux.dev,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        Will Deacon <will@kernel.org>
Cc:     Qian Cai <cai@lca.pw>, Joerg Roedel <jroedel@suse.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Robin Murphy <robin.murphy@arm.com>
References: <3-v1-ef00ffecea52+2cb-iommu_group_lifetime_jgg@nvidia.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <3-v1-ef00ffecea52+2cb-iommu_group_lifetime_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: PcL0ftuCo28RlK_1qNzvsrp4gFBXz8p9
X-Proofpoint-ORIG-GUID: vi5FdI6mB5_7JYBpGLR49MnaRvPFDWAo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-20_09,2022-09-20_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 adultscore=0
 impostorscore=0 bulkscore=0 priorityscore=1501 clxscore=1015
 mlxlogscore=999 lowpriorityscore=0 malwarescore=0 mlxscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209200117
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/8/22 2:45 PM, Jason Gunthorpe wrote:
> The iommu_group comes from the struct device that a driver has been bound
> to and then created a struct vfio_device against. To keep the iommu layer
> sane we want to have a simple rule that only an attached driver should be
> using the iommu API. Particularly only an attached driver should hold
> ownership.
> 
> In VFIO's case since it uses the group APIs and it shares between
> different drivers it is a bit more complicated, but the principle still
> holds.
> 
> Solve this by waiting for all users of the vfio_group to stop before
> allowing vfio_unregister_group_dev() to complete. This is done with a new
> completion to know when the users go away and an additional refcount to
> keep track of how many device drivers are sharing the vfio group. The last
> driver to be unregistered will clean up the group.
> 
> This solves crashes in the S390 iommu driver that come because VFIO ends
> up racing releasing ownership (which attaches the default iommu_domain to
> the device) with the removal of that same device from the iommu
> driver. This is a side case that iommu drivers should not have to cope
> with.
> 
>    iommu driver failed to attach the default/blocking domain
>    WARNING: CPU: 0 PID: 5082 at drivers/iommu/iommu.c:1961 iommu_detach_group+0x6c/0x80
>    Modules linked in: macvtap macvlan tap vfio_pci vfio_pci_core irqbypass vfio_virqfd kvm nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 ip_set nf_tables nfnetlink mlx5_ib sunrpc ib_uverbs ism smc uvdevice ib_core s390_trng eadm_sch tape_3590 tape tape_class vfio_ccw mdev vfio_iommu_type1 vfio zcrypt_cex4 sch_fq_codel configfs ghash_s390 prng chacha_s390 libchacha aes_s390 mlx5_core des_s390 libdes sha3_512_s390 nvme sha3_256_s390 sha512_s390 sha256_s390 sha1_s390 sha_common nvme_core zfcp scsi_transport_fc pkey zcrypt rng_core autofs4
>    CPU: 0 PID: 5082 Comm: qemu-system-s39 Tainted: G        W          6.0.0-rc3 #5
>    Hardware name: IBM 3931 A01 782 (LPAR)
>    Krnl PSW : 0704c00180000000 000000095bb10d28 (iommu_detach_group+0x70/0x80)
>               R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:0 PM:0 RI:0 EA:3
>    Krnl GPRS: 0000000000000001 0000000900000027 0000000000000039 000000095c97ffe0
>               00000000fffeffff 00000009fc290000 00000000af1fda50 00000000af590b58
>               00000000af1fdaf0 0000000135c7a320 0000000135e52258 0000000135e52200
>               00000000a29e8000 00000000af590b40 000000095bb10d24 0000038004b13c98
>    Krnl Code: 000000095bb10d18: c020003d56fc        larl    %r2,000000095c2bbb10
>                           000000095bb10d1e: c0e50019d901        brasl   %r14,000000095be4bf20
>                          #000000095bb10d24: af000000            mc      0,0
>                          >000000095bb10d28: b904002a            lgr     %r2,%r10
>                           000000095bb10d2c: ebaff0a00004        lmg     %r10,%r15,160(%r15)
>                           000000095bb10d32: c0f4001aa867        brcl    15,000000095be65e00
>                           000000095bb10d38: c004002168e0        brcl    0,000000095bf3def8
>                           000000095bb10d3e: eb6ff0480024        stmg    %r6,%r15,72(%r15)
>    Call Trace:
>     [<000000095bb10d28>] iommu_detach_group+0x70/0x80
>    ([<000000095bb10d24>] iommu_detach_group+0x6c/0x80)
>     [<000003ff80243b0e>] vfio_iommu_type1_detach_group+0x136/0x6c8 [vfio_iommu_type1]
>     [<000003ff80137780>] __vfio_group_unset_container+0x58/0x158 [vfio]
>     [<000003ff80138a16>] vfio_group_fops_unl_ioctl+0x1b6/0x210 [vfio]
>    pci 0004:00:00.0: Removing from iommu group 4
>     [<000000095b5b62e8>] __s390x_sys_ioctl+0xc0/0x100
>     [<000000095be5d3b4>] __do_syscall+0x1d4/0x200
>     [<000000095be6c072>] system_call+0x82/0xb0
>    Last Breaking-Event-Address:
>     [<000000095be4bf80>] __warn_printk+0x60/0x68
> 
> It reflects that domain->ops->attach_dev() failed because the driver has
> already passed the point of destructing the device.
> 
> Fixes: 9ac8545199a1 ("iommu: Fix use-after-free in iommu_release_device")
> Reported-by: Matthew Rosato <mjrosato@linux.ibm.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

I've been running with only the first 3 patches in this series (the vfio changes) and can confirm that they resolve the reported issue for me.

Tested-by: Matthew Rosato <mjrosato@linux.ibm.com> # s390

...

> +static void vfio_group_remove(struct vfio_group *group)
> +{
> +	/* Pairs with vfio_create_group() */

Nit: vfio_create_group() no longer exists as of patch 1


