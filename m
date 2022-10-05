Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F6855F55CC
	for <lists+kvm@lfdr.de>; Wed,  5 Oct 2022 15:47:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230150AbiJENrC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Oct 2022 09:47:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230048AbiJENrA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Oct 2022 09:47:00 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 226C67AC37;
        Wed,  5 Oct 2022 06:46:59 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 295DfRDT004144;
        Wed, 5 Oct 2022 13:46:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : from : to : cc : references : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=g4wKXjb3R6Wbyo5roIJKdWLIYa+vWFE8cdeQdpMEy74=;
 b=UE3VvP6CenpgJOaAiI0qH5Q5CqsqN8KZh+cna5j7nCyGbTL6aQtUhhpVd8SNzDDnAgWD
 TI+aJ4s3BZ+f5bZqdCJu7K97RBJJVM1oVUeAB5DKT6jEXD/vfnjx3e4h1LaF2DI1Jpgp
 2DNHPXuvkbTG5w5P8KBmRn0ZOFfl4B380LAkomQU1tBKEBJVvh24WKCtie1hOKDdpwiD
 yl2dKJkMp76WyXOWHcZ8AnSXLBvJI3vOg4kvp9/0soI7Z+1VO/1m9BBo84d9eWWVBvmu
 RYx3JOTkbPCuKNUn2xtEPqOngOMByMEcFXOumS90d5bSaq0AtJaZPHV/xkmQqNiAQLwj /g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k0hc0tuc5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 Oct 2022 13:46:51 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 295DjP73024031;
        Wed, 5 Oct 2022 13:46:51 GMT
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k0hc0tuba-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 Oct 2022 13:46:50 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 295DakO1027354;
        Wed, 5 Oct 2022 13:46:50 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma04dal.us.ibm.com with ESMTP id 3jxd6aapr4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 Oct 2022 13:46:50 +0000
Received: from smtpav02.wdc07v.mail.ibm.com ([9.208.128.114])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 295DkmG553346752
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 5 Oct 2022 13:46:48 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2B5F658059;
        Wed,  5 Oct 2022 13:46:48 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 821FE58061;
        Wed,  5 Oct 2022 13:46:46 +0000 (GMT)
Received: from [9.160.167.172] (unknown [9.160.167.172])
        by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Wed,  5 Oct 2022 13:46:46 +0000 (GMT)
Message-ID: <8982bc22-9afa-dde4-9f4e-38948db58789@linux.ibm.com>
Date:   Wed, 5 Oct 2022 09:46:45 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH v2] vfio: Follow a strict lifetime for struct iommu_group
Content-Language: en-US
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        "Jason J . Herne" <jjherne@linux.ibm.com>,
        Marc Hartmayer <mhartmay@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Qian Cai <cai@lca.pw>, Joerg Roedel <jroedel@suse.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-s390 <linux-s390@vger.kernel.org>
References: <0-v2-a3c5f4429e2a+55-iommu_group_lifetime_jgg@nvidia.com>
 <4cb6e49e-554e-57b3-e2d3-bc911d99083f@linux.ibm.com>
 <20220927140541.6f727b01.alex.williamson@redhat.com>
 <52545d8b-956b-8934-8a7e-212729ea2855@linux.ibm.com>
 <YzxT6Suu+272gDvP@nvidia.com>
 <1aebfa84-8310-5dff-1862-3d143878d9dd@linux.ibm.com>
 <YzxfK/e14Bx9yNyo@nvidia.com>
 <0a0d7937-316a-a0e2-9d7d-df8f3f8a38e3@linux.ibm.com>
 <33bc5258-5c95-99ee-a952-5b0b2826da3a@linux.ibm.com>
In-Reply-To: <33bc5258-5c95-99ee-a952-5b0b2826da3a@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 3HQQo8NmTQQvK_SCaGtLw498GaJ3xSF1
X-Proofpoint-ORIG-GUID: dh6cgWgBcgQ2PMRV1zkIPkh0BHGtltZY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-05_03,2022-10-05_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 bulkscore=0 spamscore=0 mlxlogscore=684 priorityscore=1501 suspectscore=0
 malwarescore=0 impostorscore=0 adultscore=0 phishscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210050085
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/4/22 2:22 PM, Matthew Rosato wrote:
> On 10/4/22 1:36 PM, Christian Borntraeger wrote:
>>
>>
>> Am 04.10.22 um 18:28 schrieb Jason Gunthorpe:
>>> On Tue, Oct 04, 2022 at 05:44:53PM +0200, Christian Borntraeger wrote:
>>>
>>>>> Does some userspace have the group FD open when it stucks like this,
>>>>> eg what does fuser say?
>>>>
>>>> /proc/<virtnodedevd>/fd
>>>> 51480 0 dr-x------. 2 root root  0  4. Okt 17:16 .
>>>> 43593 0 dr-xr-xr-x. 9 root root  0  4. Okt 17:16 ..
>>>> 65252 0 lr-x------. 1 root root 64  4. Okt 17:42 0 -> /dev/null
>>>> 65253 0 lrwx------. 1 root root 64  4. Okt 17:42 1 -> 'socket:[51479]'
>>>> 65261 0 lrwx------. 1 root root 64  4. Okt 17:42 10 -> 'anon_inode:[eventfd]'
>>>> 65262 0 lrwx------. 1 root root 64  4. Okt 17:42 11 -> 'socket:[51485]'
>>>> 65263 0 lrwx------. 1 root root 64  4. Okt 17:42 12 -> 'socket:[51487]'
>>>> 65264 0 lrwx------. 1 root root 64  4. Okt 17:42 13 -> 'socket:[51486]'
>>>> 65265 0 lrwx------. 1 root root 64  4. Okt 17:42 14 -> 'anon_inode:[eventfd]'
>>>> 65266 0 lrwx------. 1 root root 64  4. Okt 17:42 15 -> 'socket:[60421]'
>>>> 65267 0 lrwx------. 1 root root 64  4. Okt 17:42 16 -> 'anon_inode:[eventfd]'
>>>> 65268 0 lrwx------. 1 root root 64  4. Okt 17:42 17 -> 'socket:[28008]'
>>>> 65269 0 l-wx------. 1 root root 64  4. Okt 17:42 18 -> /run/libvirt/nodedev/driver.pid
>>>> 65270 0 lrwx------. 1 root root 64  4. Okt 17:42 19 -> 'socket:[28818]'
>>>> 65254 0 lrwx------. 1 root root 64  4. Okt 17:42 2 -> 'socket:[51479]'
>>>> 65271 0 lr-x------. 1 root root 64  4. Okt 17:42 20 -> '/dev/vfio/3 (deleted)'
>>>
>>> Seems like a userspace bug to keep the group FD open after the /dev/
>>> file has been deleted :|
>>>
>>> What do you think about this?
>>>
>>> commit a54a852b1484b1605917a8f4d80691db333b25ed
>>> Author: Jason Gunthorpe <jgg@ziepe.ca>
>>> Date:   Tue Oct 4 13:14:37 2022 -0300
>>>
>>>      vfio: Make the group FD disassociate from the iommu_group
>>>           Allow the vfio_group struct to exist with a NULL iommu_group pointer. When
>>>      the pointer is NULL the vfio_group users promise not to touch the
>>>      iommu_group. This allows a driver to be hot unplugged while userspace is
>>>      keeping the group FD open.
>>>           SPAPR mode is excluded from this behavior because of how it wrongly hacks
>>>      part of its iommu interface through KVM. Due to this we loose control over
>>>      what it is doing and cannot revoke the iommu_group usage in the IOMMU
>>>      layer via vfio_group_detach_container().
>>>           Thus, for SPAPR the group FDs must still be closed before a device can be
>>>      hot unplugged.
>>>           This fixes a userspace regression where we learned that virtnodedevd
>>>      leaves a group FD open even though the /dev/ node for it has been deleted
>>>      and all the drivers for it unplugged.
>>>           Fixes: ca5f21b25749 ("vfio: Follow a strict lifetime for struct iommu_group")
>>>      Reported-by: Christian Borntraeger <borntraeger@linux.ibm.com>
>>>      Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
>>
>> Almost :-)
>>
>> drivers/vfio/vfio_main.c: In function 'vfio_file_is_group':
>> drivers/vfio/vfio_main.c:1606:47: error: expected ')' before ';' token
>>  1606 |         return (file->f_op == &vfio_group_fops;
>>       |                ~                              ^
>>       |                                               )
>> drivers/vfio/vfio_main.c:1606:48: error: expected ';' before '}' token
>>  1606 |         return (file->f_op == &vfio_group_fops;
>>       |                                                ^
>>       |                                                ;
>>  1607 | }
>>       | ~
>>
>>
>> With that fixed I get:
>>
>> ERROR: modpost: "vfio_file_is_group" [drivers/vfio/pci/vfio-pci-core.ko] undefined!
>>
>> With that worked around (m -> y)
> 
> 
> Looks like this can be solved with EXPORT_SYMBOL_GPL(vfio_file_is_group);
> 
> Also:
> 
> arch/s390/kvm/../../../virt/kvm/vfio.c:64:28: warning: ‘kvm_vfio_file_iommu_group’ defined but not used [-Wunused-function]
>    64 | static struct iommu_group *kvm_vfio_file_iommu_group(struct file *file)
>       |                            ^~~~~~~~~~~~~~~~~~~~~~~~~
> 
> kvm_vfio_file_iommu_group looks like it is now SPAPR-only
> 
>>
>>
>> Tested-by: Christian Borntraeger <borntraeger@linux.ibm.com>
>>
>> At least the vfio-ap part
> 
> Nope, with this s390 vfio-pci at least breaks:
> 
> [  132.943389] kernel BUG at lib/list_debug.c:53!
> [  132.943406] monitor event: 0040 ilc:2 [#1] SMP 
> [  132.943410] Modules linked in: vfio_pci kvm vfio_pci_core irqbypass vfio_virqfd vhost_vsock vmw_vsock_virtio_transport_common vsock vhost vhost_iotlb nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defr
> ag_ipv4 ip_set nf_tables nfnetlink sunrpc mlx5_ib ism smc ib_uverbs ib_core uvdevice s390_trng tape_3590 tape tape_class eadm_sch vfio_ccw mdev vfio_iommu_type1 vfio zcrypt_cex4 sch_fq_codel configfs ghash_s390 prng chacha_s390 libchacha mlx5_core aes_s390 des_s390 libdes sha3_512_s390 nvme sha3_256_s390 sha512_s390 sh
> a256_s390 nvme_core sha1_s390 sha_common zfcp scsi_transport_fc pkey zcrypt rng_core autofs4 [last unloaded: vfio_pci]
> [  132.943457] CPU: 12 PID: 4991 Comm: nose2 Tainted: G        W          6.0.0-rc4 #40
> [  132.943460] Hardware name: IBM 3931 A01 782 (LPAR)
> [  132.943462] Krnl PSW : 0704c00180000000 00000000cbc90568 (__list_del_entry_valid+0xd8/0xf0)
> [  132.943469]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:0 PM:0 RI:0 EA:3
> [  132.943474] Krnl GPRS: 8000000000000001 0000000900000027 000000000000004e 00000000ccc1ffe0
> [  132.943477]            00000000fffeffff 00000009fc290000 0000000000000000 0000000000000080
> [  132.943480]            00000000acc86438 0000000000000000 00000000acc86420 00000000a1492800
> [  132.943483]            00000000922a0000 000003ffb9dce260 00000000cbc90564 0000038004a6b9f8
> [  132.943489] Krnl Code: 00000000cbc90558: c0200045eff3        larl    %r2,00000000cc54e53e
> [  132.943489]            00000000cbc9055e: c0e50022c7d9        brasl   %r14,00000000cc0e9510
> [  132.943489]           #00000000cbc90564: af000000            mc      0,0
> [  132.943489]           >00000000cbc90568: b9040032            lgr     %r3,%r2
> [  132.943489]            00000000cbc9056c: c0200045efd4        larl    %r2,00000000cc54e514
> [  132.943489]            00000000cbc90572: c0e50022c7cf        brasl   %r14,00000000cc0e9510
> [  132.943489]            00000000cbc90578: af000000            mc      0,0
> [  132.943489]            00000000cbc9057c: 0707                bcr     0,%r7
> [  132.943510] Call Trace:
> [  132.943512]  [<00000000cbc90568>] __list_del_entry_valid+0xd8/0xf0 
> [  132.943515] ([<00000000cbc90564>] __list_del_entry_valid+0xd4/0xf0)
> [  132.943518]  [<000003ff8011a1b8>] vfio_group_detach_container+0x88/0x170 [vfio] 
> [  132.943524]  [<000003ff801176c0>] vfio_device_remove_group.isra.0+0xb0/0x1e0 [vfio] 
> [  132.943529]  [<000003ff804f9e54>] vfio_pci_core_unregister_device+0x34/0x80 [vfio_pci_core] 
> [  132.943535]  [<000003ff804ae1c4>] vfio_pci_remove+0x2c/0x40 [vfio_pci] 
> [  132.943539]  [<00000000cbd58c3c>] pci_device_remove+0x3c/0x98 
> [  132.943542]  [<00000000cbdbdbce>] device_release_driver_internal+0x1c6/0x288 
> [  132.943545]  [<00000000cbd4e284>] pci_stop_bus_device+0x94/0xc0 
> [  132.943549]  [<00000000cbd4e570>] pci_stop_and_remove_bus_device_locked+0x30/0x48 
> [  132.943552]  [<00000000cb55d980>] zpci_bus_remove_device+0x68/0xa8 
> [  132.943555]  [<00000000cb556e82>] zpci_deconfigure_device+0x3a/0xe0 
> [  132.943558]  [<00000000cbd65d04>] power_write_file+0x7c/0x130 
> [  132.943561]  [<00000000cb8fbc90>] kernfs_fop_write_iter+0x138/0x210 
> [  132.943565]  [<00000000cb837344>] vfs_write+0x194/0x2e0 "
> [  132.943568]  [<00000000cb8376fa>] ksys_write+0x6a/0xf8 
> [  132.943571]  [<00000000cc0f918c>] __do_syscall+0x1d4/0x200 
> [  132.943575]  [<00000000cc107e42>] system_call+0x82/0xb0 
> [  132.943577] Last Breaking-Event-Address:
> [  132.943579]  [<00000000cc0e955c>] _printk+0x4c/0x58
> [  132.943585] Kernel panic - not syncing: Fatal exception: panic_on_oops

(again, with the follow-up applied) Besides the panic above I just noticed there is also this warning that immediately precedes and is perhaps more useful.  Re: what triggers the WARN, both group->owner and group->owner_cnt are already 0:

[  375.262923] WARNING: CPU: 8 PID: 5182 at drivers/iommu/iommu.c:3211 iommu_group_release_dma_owner+0x38/0x90
[  375.262932] Modules linked in: vhost_vsock vmw_vsock_virtio_transport_common vsock vhost vhost_iotlb macvtap macvlan tap vfio_pci vfio_pci_core irqbypass vfio_virqfd kvm nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct nft_chain_nat nf_nat nf_conntrack nf
_defrag_ipv6 nf_defrag_ipv4 ip_set nf_tables nfnetlink sunrpc mlx5_ib ib_uverbs ism smc ib_core uvdevice s390_trng eadm_sch tape_3590 tape tape_class vfio_ccw mdev vfio_iommu_type1 vfio zcrypt_cex4 sch_fq_codel configfs ghash_s390 prng chacha_s390 libchacha aes_s390 des_s390 mlx5_core libdes sha3_512_s390 sha3_256_s390
 nvme sha512_s390 sha256_s390 sha1_s390 sha_common nvme_core zfcp scsi_transport_fc pkey zcrypt rng_core autofs4
[  375.262969] CPU: 8 PID: 5182 Comm: nose2 Not tainted 6.0.0-rc4 #50
[  375.262971] Hardware name: IBM 3931 A01 782 (LPAR)
[  375.262972] Krnl PSW : 0704c00180000000 00000001d1cd8b34 (iommu_group_release_dma_owner+0x3c/0x90)
[  375.262976]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:0 PM:0 RI:0 EA:3
[  375.262979] Krnl GPRS: 8000000000000001 0000000000000000 00000000844dd058 00000000ba60c200
[  375.262981]            00000000fffeffff 00000009fc290000 0000000000000000 0000000000000080
[  375.262984]            00000000b1a6d840 00000000b1a6d858 00000000844dd058 00000000844dd000
[  375.262986]            00000000ba60c200 000003ff962ce260 00000001d1cd8b26 0000038003d0f9d8
[  375.262994] Krnl Code: 00000001d1cd8b26: e310b0c00012        lt      %r1,192(%r11)
[  375.262994]            00000001d1cd8b2c: a774000c            brc     7,00000001d1cd8b44
[  375.262994]           #00000001d1cd8b30: af000000            mc      0,0
[  375.262994]           >00000001d1cd8b34: b904002a            lgr     %r2,%r10
[  375.262994]            00000001d1cd8b38: ebaff0a00004        lmg     %r10,%r15,160(%r15)
[  375.262994]            00000001d1cd8b3e: c0f4001aa84d        brcl    15,00000001d202dbd8
[  375.262994]            00000001d1cd8b44: e310b0c80002        ltg     %r1,200(%r11)
[  375.262994]            00000001d1cd8b4a: a784fff3            brc     8,00000001d1cd8b30
[  375.263048] Call Trace:
[  375.263051]  [<00000001d1cd8b34>] iommu_group_release_dma_owner+0x3c/0x90 
[  375.263058]  [<000003ff801431c8>] vfio_group_detach_container+0x98/0x1a0 [vfio] 
[  375.263067]  [<000003ff801406c0>] vfio_device_remove_group.isra.0+0xb0/0x1e0 [vfio] 
[  375.263071]  [<000003ff80540e54>] vfio_pci_core_unregister_device+0x34/0x80 [vfio_pci_core] 
[  375.263079]  [<000003ff804f31c4>] vfio_pci_remove+0x2c/0x40 [vfio_pci] 
[  375.263082]  [<00000001d1c84c3c>] pci_device_remove+0x3c/0x98 
[  375.263085]  [<00000001d1ce9bce>] device_release_driver_internal+0x1c6/0x288 
[  375.263090]  [<00000001d1c7a284>] pci_stop_bus_device+0x94/0xc0 
[  375.263093]  [<00000001d1c7a570>] pci_stop_and_remove_bus_device_locked+0x30/0x48 
[  375.263096]  [<00000001d1489980>] zpci_bus_remove_device+0x68/0xa8 
[  375.263100]  [<00000001d1482e82>] zpci_deconfigure_device+0x3a/0xe0 
[  375.263104]  [<00000001d1c91d04>] power_write_file+0x7c/0x130 
[  375.263108]  [<00000001d1827c90>] kernfs_fop_write_iter+0x138/0x210 
[  375.263114]  [<00000001d1763344>] vfs_write+0x194/0x2e0 
[  375.263119]  [<00000001d17636fa>] ksys_write+0x6a/0xf8 
[  375.263121]  [<00000001d202518c>] __do_syscall+0x1d4/0x200 
[  375.263127]  [<00000001d2033e42>] system_call+0x82/0xb0 
[  375.263132] Last Breaking-Event-Address:
[  375.263132]  [<00000001d202f394>] mutex_lock+0x1c/0x28
