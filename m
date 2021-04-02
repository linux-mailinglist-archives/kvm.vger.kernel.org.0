Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFA82352DA2
	for <lists+kvm@lfdr.de>; Fri,  2 Apr 2021 18:20:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234619AbhDBQUI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Apr 2021 12:20:08 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:7402 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229932AbhDBQUH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 2 Apr 2021 12:20:07 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 132G4Bxh131297;
        Fri, 2 Apr 2021 12:20:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=ZOC11xnqTHlfqQboT3+IBE1PhaEk96l2lIt5rcgaonY=;
 b=Fia0uHvDo6A9SkVYAmDHaJD/N4TUCJ0BiQMgKnuGW0snwEdGTcrZUK81wr0sc0sxq1W+
 PHdeHB+8X6fqAY0ELkmIiNNfBlp7M9tNls41vzQlA77Fxt64HKmc3tgb6ZpLhW0aESO9
 HVm+0jRYlyFWj/gasg4IlC2dwaBomM7NDOxhmjq93FEXarpi5KYVEAg0+RlfoLb2pNk/
 eXuy19EW3V8ZkRhg4TwDGApyzxH39yXs23lhaIkmy5PvUxoARZWuUkpLEvM+xLV/xkIl
 ZcvqNEhK+MWho1wlfAAi8S4P7i2hz4DagSBLh2vZq1z/v6ahQqURZdAILQ/syUQjfZ+n 1Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37n8r1a0yb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Apr 2021 12:20:04 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 132G4K67132012;
        Fri, 2 Apr 2021 12:20:03 -0400
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37n8r1a0xq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Apr 2021 12:20:03 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 132G7HDk005498;
        Fri, 2 Apr 2021 16:20:02 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma01dal.us.ibm.com with ESMTP id 37n28vy30t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Apr 2021 16:20:02 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 132GK0Zt25886980
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 2 Apr 2021 16:20:00 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 613CB112064;
        Fri,  2 Apr 2021 16:20:00 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0E985112062;
        Fri,  2 Apr 2021 16:19:59 +0000 (GMT)
Received: from cpe-66-24-58-13.stny.res.rr.com (unknown [9.85.146.149])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri,  2 Apr 2021 16:19:58 +0000 (GMT)
Subject: Re: [PATCH v14 00/13] s390/vfio-ap: dynamic configuration support
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        hca@linux.ibm.com, gor@linux.ibm.com
References: <20210331152256.28129-1-akrowiak@linux.ibm.com>
 <20210401211742.6afd6b14.pasic@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <4c479cb4-595d-5642-7bac-74a823de7206@linux.ibm.com>
Date:   Fri, 2 Apr 2021 12:19:58 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20210401211742.6afd6b14.pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: XflTibmLUzItTxK-SU7R0qQKAo7oCA-Z
X-Proofpoint-GUID: 9GET7fuX84C1iYCQMeTBLgwJWIawOSEn
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-04-02_09:2021-04-01,2021-04-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 bulkscore=0 priorityscore=1501 phishscore=0 suspectscore=0
 mlxlogscore=999 clxscore=1015 lowpriorityscore=0 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103310000 definitions=main-2104020113
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4/1/21 3:17 PM, Halil Pasic wrote:
> On Wed, 31 Mar 2021 11:22:43 -0400
> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>
>> Change log v13-v14:
>> ------------------
> When testing I've experienced this kernel panic.

I am able to recreate this, but only when the kernel is built with
the debug_defconfig configuration. I'll look into this to try to
figure out why.




>
>
> [ 4422.479706] vfio_ap matrix: MDEV: Registered
> [ 4422.516999] vfio_mdev b2013234-18b2-49bf-badd-a4be9c78b120: Adding to iommu group 1
> [ 4422.517037] vfio_mdev b2013234-18b2-49bf-badd-a4be9c78b120: MDEV: group_id = 1
> [ 4577.906708] vfio_mdev b2013234-18b2-49bf-badd-a4be9c78b120: Removing from iommu group 1
> [ 4577.906917] vfio_mdev b2013234-18b2-49bf-badd-a4be9c78b120: MDEV: detaching iommu
> [ 4577.908093] Unable to handle kernel pointer dereference in virtual kernel address space
> [ 4577.908097] Failing address: 00000006ec02f000 TEID: 00000006ec02f403
> [ 4577.908100] Fault in home space mode while using kernel ASCE.
> [ 4577.908106] AS:000000035eb4c007 R3:0000000000000024
> [ 4577.908126] Oops: 003b ilc:3 [#1] PREEMPT SMP
> [ 4577.908132] Modules linked in: vfio_ap vhost_vsock vmw_vsock_virtio_transport_common vsock vhost vhost_iotlb kvm xt_CHECKSUM xt_MASQUERADE xt_conntrack ipt_R
> EJECT xt_tcpudp nft_compat nf_nat_tftp nft_objref nf_conntrack_tftp nft_counter bridge stp llc nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib nft_reject_inet nf
> _reject_ipv4 nf_reject_ipv6 nft_reject nft_ct nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 ip_set nf_tables nfnetlink sunrpc s390_trng eadm_s
> ch vfio_ccw vfio_mdev mdev vfio_iommu_type1 vfio sch_fq_codel configfs ip_tables x_tables dm_service_time ghash_s390 prng aes_s390 des_s390 libdes sha3_512_s390
>   sha3_256_s390 sha512_s390 sha256_s390 sha1_s390 sha_common nvme nvme_core zfcp scsi_transport_fc dm_multipath scsi_dh_rdac scsi_dh_emc scsi_dh_alua dm_mirror d
> m_region_hash dm_log dm_mod rng_core autofs4
> [ 4577.908181] CPU: 0 PID: 14315 Comm: nose2 Not tainted 5.12.0-rc5-00030-g4cd110385fa2 #55
> [ 4577.908183] Hardware name: IBM 8561 T01 701 (LPAR)
> [ 4577.908185] Krnl PSW : 0404e00180000000 000000035d2a50f4 (__lock_acquire+0xdc/0x7c8)
> [ 4577.908194]            R:0 T:1 IO:0 EX:0 Key:0 M:1 W:0 P:0 AS:3 CC:2 PM:0 RI:0 EA:3
> [ 4577.908232] Krnl GPRS: 000000039d168d46 00000006ec02f538 000000035e7de940 0000000000000000
> [ 4577.908235]            0000000000000000 0000000000000000 0000000000000001 00000000f9e04150
> [ 4577.908237]            000000035fa8b100 006b6b6b680c417f 00000000f9e04150 000000035e61e8d0
> [ 4577.908239]            000000035fa8b100 0000000000000000 0000038010c4b7d8 0000038010c4b738
> [ 4577.908247] Krnl Code: 000000035d2a50e4: eb110003000d        sllg    %r1,%r1,3
> [ 4577.908247]            000000035d2a50ea: b9080012            agr     %r1,%r2
> [ 4577.908247]           #000000035d2a50ee: e31003b80008        ag      %r1,952
> [ 4577.908247]           >000000035d2a50f4: eb011000007a        agsi    0(%r1),1
> [ 4577.908247]            000000035d2a50fa: a718ffff            lhi     %r1,-1
> [ 4577.908247]            000000035d2a50fe: eb1103a800f8        laa     %r1,%r1,936
> [ 4577.908247]            000000035d2a5104: ec18026b017e        cij     %r1,1,8,000000035d2a55da
> [ 4577.908247]            000000035d2a510a: c4180086d01f        lgrl    %r1,000000035e37f148
> [ 4577.908262] Call Trace:
> [ 4577.908264]  [<000000035d2a50f4>] __lock_acquire+0xdc/0x7c8
> [ 4577.908267]  [<000000035d2a41ac>] lock_acquire.part.0+0xec/0x1e8
> [ 4577.908270]  [<000000035d2a4360>] lock_acquire+0xb8/0x208
> [ 4577.908272]  [<000000035de6fa2a>] _raw_spin_lock_irqsave+0x6a/0xd8
> [ 4577.908279]  [<000000035d2874fe>] prepare_to_wait_event+0x2e/0x1e0
> [ 4577.908281]  [<000003ff805d539a>] vfio_ap_mdev_remove_queue+0x122/0x148 [vfio_ap]
> [ 4577.908287]  [<000000035de20e94>] ap_device_remove+0x4c/0xf0
> [ 4577.908292]  [<000000035db268a2>] __device_release_driver+0x18a/0x230
> [ 4577.908298]  [<000000035db27cf0>] device_driver_detach+0x58/0xd0
> [ 4577.908301]  [<000000035db25000>] device_reprobe+0x30/0xc0
> [ 4577.908304]  [<000000035de22570>] __ap_revise_reserved+0x110/0x148
> [ 4577.908307]  [<000000035db2408c>] bus_for_each_dev+0x7c/0xb8
> [ 4577.908310]  [<000000035de2290c>] apmask_store+0xd4/0x118
> [ 4577.908313]  [<000000035d639316>] kernfs_fop_write_iter+0x13e/0x1e0
> [ 4577.908317]  [<000000035d542d22>] new_sync_write+0x10a/0x198
> [ 4577.908321]  [<000000035d5433ee>] vfs_write.part.0+0x196/0x290
> [ 4577.908323]  [<000000035d545f44>] ksys_write+0x6c/0xf8
> [ 4577.908326]  [<000000035d1ce7ae>] do_syscall+0x7e/0xd0
> [ 4577.908330]  [<000000035de5fc00>] __do_syscall+0xc0/0xd8
> [ 4577.908334]  [<000000035de70c22>] system_call+0x72/0x98
> [ 4577.908337] INFO: lockdep is turned off.
> [ 4577.908338] Last Breaking-Event-Address:
> [ 4577.908340]  [<0000038010c4b648>] 0x38010c4b648
> [ 4577.908345] Kernel panic - not syncing: Fatal exception: panic_on_oops

