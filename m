Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EA465EAE51
	for <lists+kvm@lfdr.de>; Mon, 26 Sep 2022 19:39:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231160AbiIZRjo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Sep 2022 13:39:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230454AbiIZRjZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Sep 2022 13:39:25 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B305021255
        for <kvm@vger.kernel.org>; Mon, 26 Sep 2022 10:04:07 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28QGgM0e000489;
        Mon, 26 Sep 2022 17:04:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=/iixOefTkeUiU1qiGZMqxq1tjQ57uL/EWXWhS64RhS0=;
 b=e7RrfF95xU+yM/il4SI+1Iu1aelYVhC+VxIFIXGNapmbVglN9csJ3KDjtm28xg+ncMaI
 EbFIjya2Q7TMiTr0IRXe2wa+AFoO90FQBfMf++IPzOwj2XzJ0K6ccf8m2j6kI9PFnbOd
 hTGC0M7SyPRpF0rmtOwZ8s30pm13pE/rE4uh2OLWOLpedQ2ttSk2klvCgymsAqHr3JSX
 kFJ+WNpl6+3465Tj3hHryyo8xJtUsHOkM7SssABIgRvGMTInRKSFNFlFE0raAqh0kF+/
 Si2jgRHKHoeEOW/75NLELLPix4IlBb0MqCTyXCBdTTXKAvbEmWy+DycCOzCnPPYZAGzG vQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jufu60nw6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 26 Sep 2022 17:04:00 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 28QGgbrK002181;
        Mon, 26 Sep 2022 17:04:00 GMT
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jufu60nur-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 26 Sep 2022 17:04:00 +0000
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 28QGoC6J030902;
        Mon, 26 Sep 2022 17:03:58 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma01wdc.us.ibm.com with ESMTP id 3jt40rmbfe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 26 Sep 2022 17:03:58 +0000
Received: from smtpav03.wdc07v.mail.ibm.com ([9.208.128.112])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 28QH3vH310682922
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Sep 2022 17:03:58 GMT
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 932145805F;
        Mon, 26 Sep 2022 17:03:57 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8027858062;
        Mon, 26 Sep 2022 17:03:56 +0000 (GMT)
Received: from [9.65.200.181] (unknown [9.65.200.181])
        by smtpav03.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 26 Sep 2022 17:03:56 +0000 (GMT)
Message-ID: <4cb6e49e-554e-57b3-e2d3-bc911d99083f@linux.ibm.com>
Date:   Mon, 26 Sep 2022 13:03:56 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH v2] vfio: Follow a strict lifetime for struct iommu_group
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Cc:     Qian Cai <cai@lca.pw>, Joerg Roedel <jroedel@suse.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>
References: <0-v2-a3c5f4429e2a+55-iommu_group_lifetime_jgg@nvidia.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <0-v2-a3c5f4429e2a+55-iommu_group_lifetime_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: kOrXpMYVbd3wnEMzC_YoSzuiq2-53Gqp
X-Proofpoint-GUID: 5hYPR5BSKjl4yNi_YlD4kd6qEtrmd8gk
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-26_09,2022-09-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 lowpriorityscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0 phishscore=0
 priorityscore=1501 impostorscore=0 spamscore=0 malwarescore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209260109
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/22/22 8:06 PM, Jason Gunthorpe wrote:
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
> It indicates that domain->ops->attach_dev() failed because the driver has
> already passed the point of destructing the device.
> 
> Fixes: 9ac8545199a1 ("iommu: Fix use-after-free in iommu_release_device")
> Reported-by: Matthew Rosato <mjrosato@linux.ibm.com>
> Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/vfio.h      |  8 +++++
>  drivers/vfio/vfio_main.c | 68 ++++++++++++++++++++++++++--------------
>  2 files changed, 53 insertions(+), 23 deletions(-)
> 
> v2
>  - Rebase on the vfio struct device series and the container.c series
>  - Drop patches 1 & 2, we need to have working error unwind, so another
>    test is not a problem
>  - Fold iommu_group_remove_device() into vfio_device_remove_group() so
>    that it forms a strict pairing with the two allocation functions.
>  - Drop the iommu patch from the series, it needs more work and discussion
> v1 https://lore.kernel.org/r/0-v1-ef00ffecea52+2cb-iommu_group_lifetime_jgg@nvidia.com
> 
> This could probably use another quick sanity test due to all the rebasing,
> Alex if you are happy let's wait for Matthew.
> 

I have been re-running the same series of tests on this version (on top of vfio-next) and this still resolves the reported issue.  Thanks Jason!

Matt

