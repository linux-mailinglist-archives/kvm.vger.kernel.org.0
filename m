Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F9525F5BDF
	for <lists+kvm@lfdr.de>; Wed,  5 Oct 2022 23:43:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbiJEVmy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Oct 2022 17:42:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229735AbiJEVmw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Oct 2022 17:42:52 -0400
X-Greylist: delayed 1587 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 05 Oct 2022 14:42:50 PDT
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB2BD82742
        for <kvm@vger.kernel.org>; Wed,  5 Oct 2022 14:42:50 -0700 (PDT)
Received: from pps.filterd (m0127839.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 295Hl8gk026023;
        Wed, 5 Oct 2022 14:16:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=proofpoint20171006;
 bh=2RKzOP3WuXDperEYKo6zuM0TAiVCtzKEkiKDoBuOfww=;
 b=BaLJ5C06GG/+1sCZ+EiRAX1rAqkT3ScxzGH0SAQDqNwnoQwYEtyZWaz/z6HLS4C3WoWd
 UUtdHDj0CVD0OoxowHVmkqMa60ZJJ6g0uJqi6fesq2RQ8UfVmYkc84/QjajhjwLDoQXT
 aOTD4b8q1JDsGwICqlzsbuZgyrgVeLQmwPcGIy1fJmlJ5//+OQTXbsrqkTL9wfhizQP8
 WOU3wNfRlrFI9pz8qITHUUWmvPGBvvU/Xb+oyA2+cveZdRZerz5kmxKfl0516j72OQfN
 XL38VWww/2iIAmFMmd2tcsy7XtTw6+TghClR/1tiFpFMwdNAblL6JttYnjD21k1yiI/M VQ== 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2105.outbound.protection.outlook.com [104.47.55.105])
        by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 3jxmmj24ge-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 Oct 2022 14:16:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BVOTSEgryKrI/TXjoYWeU7UH0HBaYBiuJgdAo9pZHP/m/FkTRcTgMCM990sy5D9G1K5fspUQ0icL7mq6SRXfxvUbzNuafVjyPek45lSIKZ/KreDbyH7KcLCOtqWkw+FI8R3gk8KClgFfaoxB4MdM8hSD2WKBw342wbDmOMoPZhf2mRiVA/C77HHjTnemDZTTKiwDxVnKB8yfy6iLj89kXGpNRvvL7BSgsZ6ZQ2zsStoie1W0BqqmnyFSbEyVD5XckzLq5mdi1mGniFX212BEgWacUJf0tABslje8TgLfOPzjGhtxJQQ0FcBPyFayi4NxvFZN6DqzZ0NIBTdiH1N3rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2RKzOP3WuXDperEYKo6zuM0TAiVCtzKEkiKDoBuOfww=;
 b=iMYrTyU+/ix+yijakCNg4w/W0ULD7V1/kwBcI13pL5kxO3h4n6FAcNNe10DA4S5NRpCQyQt3empS4KeSHEhxAwwN/ccXaeg8BtUusDZ+YCr/txy838IvQQ32PrD+Oa9wxUmqTRV6/0N83cB3dlxjaWfkqIevhaXaWRjC3WgkmDJn6vxYTaB9+cnVmZB2Y9fZrdpZD+qad2rRbQzKbGNOjJyGg6ga2R3kuE62T+kXxKVI8RpI5tFONkU17+klIho/O2Apgs10dDjot7nolATh5a4SdkLZ0qangNomOySc84H0p3K2DVT17s1VlUyjwl2owleVmLrJ0uWRuclkk65KBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from DM8PR02MB8005.namprd02.prod.outlook.com (2603:10b6:8:16::16) by
 SA2PR02MB7626.namprd02.prod.outlook.com (2603:10b6:806:134::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.23; Wed, 5 Oct
 2022 21:16:15 +0000
Received: from DM8PR02MB8005.namprd02.prod.outlook.com
 ([fe80::c041:5d29:5eef:b9fa]) by DM8PR02MB8005.namprd02.prod.outlook.com
 ([fe80::c041:5d29:5eef:b9fa%9]) with mapi id 15.20.5676.032; Wed, 5 Oct 2022
 21:16:15 +0000
From:   Thanos Makatos <thanos.makatos@nutanix.com>
To:     kvm@vger.kernel.org
Cc:     john.levon@nutanix.com, mst@redhat.com, john.g.johnson@oracle.com,
        dinechin@redhat.com, cohuck@redhat.com, jasowang@redhat.com,
        stefanha@redhat.com, jag.raman@oracle.com, eafanasova@gmail.com,
        elena.ufimtseva@oracle.com, changpeng.liu@intel.com,
        james.r.harris@intel.com, benjamin.walker@intel.com,
        Thanos Makatos <thanos.makatos@nutanix.com>
Subject: [RFC PATCH] KVM: optionally commit write on ioeventfd write
Date:   Wed,  5 Oct 2022 21:15:51 +0000
Message-Id: <20221005211551.152216-1-thanos.makatos@nutanix.com>
X-Mailer: git-send-email 2.22.3
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR01CA0072.prod.exchangelabs.com (2603:10b6:a03:94::49)
 To DM8PR02MB8005.namprd02.prod.outlook.com (2603:10b6:8:16::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM8PR02MB8005:EE_|SA2PR02MB7626:EE_
X-MS-Office365-Filtering-Correlation-Id: 835694e7-2366-480b-4ede-08daa716d60b
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ch2YYFXEpKHgBRS1/nTaU78PgAeskMaLhTS9iVnmIXPFUiBt65p++tPMwAzI3DbOtpcc0FUp8eo4+uoUiTUtQvoNsn435OS3TOhCH+Q8lAdahgXPBOU+uoJLyWdWacUjru7J6xQyqRuZ1e8RL1ITDKAuOZVEA1snYLYgi0ExyR7ZnspErhiw+WcKNpZyIO0Uv8iiMRaf4TufETcs13Hzi9xmp2vOAOYAkMnQcZqTNcOKklo1k2GNiMXq+YRXOyawmm8j87I+pOQKxcqppidgsAs5gQlktSZ7YQ3xGxbI0YoUWUDsg0gi8dbzRMTH43GQauLkSYoO4mlK3KnTEXMTsfRiJo54NIoaHUZHa4QOBLhrgI5Xv65zfjT1Kc5FC9bGCBofFSvsaItloBVH/FqUHkvUG8e/5WPwx3Dp2eyM76Y5ROhn0Ts2zPVS3A4zQ3xAxCIt4AwVTPUJDIOGmYEIUzevxE9u9Y8DgBtv8gLCQjxVE8fRVYadTYqbjmCY8/63NR2HLr0mx9wxiIbZAZ4YG55nAZuzlo0n9vaQfHv1PMrCdhpp85jCu4q9ls5vIUYGBMbhfmgd5/mDzemf9BM2MnyzDrWaCY9SOXlmMP6Jn9o0gwgr1Ds0EY6R2VuFf8UT2GKvlsUGD8URS+yp6gEebxGAZyYcrgK/UvpVO2tT1iC/OCvMgwiK7F0LKGWboFJU8X2fFNjhQWcERYDnCiXAobsTqYFSde2/bdhfDabbD4bcJ0kQjk+QyprfjCARUAbJ895XXZ/Vwukp+ofDeXHUfwZI0qnX+ddcn74y/93J/BkBEtbCzeewBlymJVVqj+gUpDY1pGSKllbFBrzx11xR6A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR02MB8005.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(39860400002)(136003)(346002)(396003)(376002)(451199015)(41300700001)(26005)(38350700002)(6512007)(66476007)(4326008)(8676002)(66946007)(83380400001)(478600001)(1076003)(186003)(86362001)(966005)(38100700002)(66556008)(316002)(6916009)(36756003)(6666004)(107886003)(2616005)(6486002)(7416002)(2906002)(44832011)(5660300002)(8936002)(6506007)(52116002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AWvMqTw+FAMM+4a9bIIl7FbGcmynm7jv2hnFBoMh2gILHMyfKdHAmNvA4w/A?=
 =?us-ascii?Q?ZjXHCQ/bcKvo09yDBZRMhVy6zy7S/YOKSSXqZiWIZdcpT9pCbjKnkeTYovXU?=
 =?us-ascii?Q?aVsciWt1ZPNj12dw+j9aV6X9Iscq2lY/GsMxCqvqO0h87/P+/L4aZDM/G0Sy?=
 =?us-ascii?Q?IDNaUV5kw1/7/Dz+WmHX3CLDXG52RAk8rsqHSemgdRjrFGQe1xdv2xx7Awm7?=
 =?us-ascii?Q?FjVPcLoVz4F5AZCcPNxiGJB7Z+16LzTLOxStm47IeGd8yr0Xt8I9xQ/d2bLv?=
 =?us-ascii?Q?fNDWpnlZeJCy9LE1JG/Jun7Yh720mj7a8VLF4EWwvjljCiRg1t+Leg0RBoWi?=
 =?us-ascii?Q?tOI48Z9WkqdCPq4zIkXY1bgnox8PszjtqCISjDyJ7AfMLe5cOmANAicSIkh0?=
 =?us-ascii?Q?M+AJ7BmLEQIscJt5LWVS+3E/v6mtW9mWirshO0JcHdWW5Y/Lv6UDyZgYxS5j?=
 =?us-ascii?Q?ZCZW6/1bk/x71aaX4NvFrt1JWX5Dp+BB13ntieFDGx7m2RaOX0cTHP0GCZ6e?=
 =?us-ascii?Q?xsfLhB8Byq74nTsaMcxj51Xg5/oNDdBpoEAN0AJnEz1t2fvqNNWqWoHAJQns?=
 =?us-ascii?Q?5et0h2ggHYYewuYVCxYIPJbmXb/plWVr6ZAzBq5RqPYKMpLMA6diRxGwRErF?=
 =?us-ascii?Q?zrlR7t/etoydno3jn6+ZB4HPvxZBTLJQTHNnUh8BJxBdeQQ5Yvg96Xk7mWbi?=
 =?us-ascii?Q?Aie8/Ph3CQP4ocFA2bDuZ50Ju4ju+6NI7KhYh+ketS1uurIrLmvvpzWhgq/M?=
 =?us-ascii?Q?jwNVmZzL1YYXFTuw0QgRM7CgpZrgj2OY6Svah9/zuluwgd9qgikBBuO+ummP?=
 =?us-ascii?Q?0Lu63cpRiAucmBgzpnyGl5Lp0yk+PtbNA254gjR6rMVxa3C6ran9lAh3713P?=
 =?us-ascii?Q?k3t+GyxDuOAnGKIeJuGq2HtPmjZPPtWNZry/rNbvd8kpGXPgfDUYmLMZ+knk?=
 =?us-ascii?Q?ZL3MJxlCtSZFe0mpWSXn3qosvuquUXlTY2JaOyYrGkp656wK0WlqoNzPnM3S?=
 =?us-ascii?Q?pENkrYHcOfvtHQshsCfeo+SsdaCzOGtLN/31kCDoAeIwmsdRFrt3pOe8KWan?=
 =?us-ascii?Q?zTMsoqSa5sQzOx56fGCOJqaxA6ikilcavaPF6UD9ZaVQ4z2Em65vjlKGR23t?=
 =?us-ascii?Q?T7/MVYK+dVc61IS8bu5SnDLn3nozTw3NT7IG7zv19lRPvhU5lO5+fsc+BFOR?=
 =?us-ascii?Q?Ld4j1pRsCqiPKFHrk4sT6kXCwrqlPpGfX7Rws9THdUv0idkw+W9/91ry/P6U?=
 =?us-ascii?Q?yJzlbE0ANhfhdje1Ansy4zA1rNrhRjvaC53Kh3mgZ6tK6DbSxvH5GJb/ZfKD?=
 =?us-ascii?Q?CbD9rgZcy2LNBl4nlp/fR7q0OfFF3Mkl/tgXBr1twpPC7+qjF8fLKj2Tjl8k?=
 =?us-ascii?Q?xXH8iSpzj5M+8eqzhmJ0d+WWRi7XiTFkqKUzLBp2UB90/NTRNxj4WuaKaKuJ?=
 =?us-ascii?Q?GmxnuhZaORVyCYl31Tnaikz9qR0Z1Nx9QkdPkIyJ1/99aQfAv2fvijXIvO/f?=
 =?us-ascii?Q?8ywUHp3RHOebad+T7PCkngu2aQMp9zhWw/Z0czg21BwTnY1pxe3VWcQ2Dm6L?=
 =?us-ascii?Q?4Fd26KO8fKCR5d1piOpWsvxt74YhdaZweJWuQZLf4CAmmZj/cFbDn7s9zQdW?=
 =?us-ascii?Q?QQ=3D=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 835694e7-2366-480b-4ede-08daa716d60b
X-MS-Exchange-CrossTenant-AuthSource: DM8PR02MB8005.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2022 21:16:14.9468
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ITDAjxAbQ0eAdimCiydhPSm7laadYVRWpa3ppR8F741tcI+x+X7zle89J/FriO/nLWctMTpb919SyvlFfJ7/6vC0wXlbteTouLiPdh91jjk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR02MB7626
X-Proofpoint-ORIG-GUID: LIwirRtOtdkRtrVkt8aaIXKiVwuVcGmj
X-Proofpoint-GUID: LIwirRtOtdkRtrVkt8aaIXKiVwuVcGmj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-05_05,2022-10-05_01,2022-06-22_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch is a slightly different take on the ioregionfd mechanism
previously described here:
https://lore.kernel.org/all/88ca79d2e378dcbfb3988b562ad2c16c4f929ac7.camel@gmail.com/

The goal of this new mechanism, which we tentatively call shadow
ioeventfd in lack of a better name, is to speed up doorbell writes on
NVMe controllers emulated outside of the VMM. Currently, a doorbell
write to an NVMe SQ tail doorbell requires returning from ioctl(KVM_RUN)
and the VMM communicating the event, along with the doorbell value, to
the NVMe controller emulation task.  With the shadow ioeventfd, the NVMe
emulation task is directly notified of the doorbell write and can find
the doorbell value in a known location, without the interference of the
VMM.

To demonstrate the performance benefit of the shadow ioeventfd
mechanism, I've implemented a test using the vfio-user protocol for
enabling out-of-process device emulation, which can be found here:
https://github.com/tmakatos/muser/commit/7adfe45 I've patched QEMU to
enable shadow ioeventfd here:
https://github.com/tmakatos/qemu-oracle/commit/55f2781 This is based on
John Johnson's not-yet-merged vfio-user server patches.  In this test,
the guest repeatedly writes to two pieces of memory: one accelarated by
a shadow ioeventfd and the other not. Writing to the piece of memory
accelarated by the shadow ioeventfd is 4 times faster.

Signed-off-by: Thanos Makatos <thanos.makatos@nutanix.com>
---
 include/uapi/linux/kvm.h       | 5 ++++-
 tools/include/uapi/linux/kvm.h | 2 ++
 virt/kvm/eventfd.c             | 9 +++++++++
 3 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index eed0315a77a6..0a884ac1cc76 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -804,6 +804,7 @@ enum {
 	kvm_ioeventfd_flag_nr_deassign,
 	kvm_ioeventfd_flag_nr_virtio_ccw_notify,
 	kvm_ioeventfd_flag_nr_fast_mmio,
+	kvm_ioevetnfd_flag_nr_commit_write,
 	kvm_ioeventfd_flag_nr_max,
 };
 
@@ -812,16 +813,18 @@ enum {
 #define KVM_IOEVENTFD_FLAG_DEASSIGN  (1 << kvm_ioeventfd_flag_nr_deassign)
 #define KVM_IOEVENTFD_FLAG_VIRTIO_CCW_NOTIFY \
 	(1 << kvm_ioeventfd_flag_nr_virtio_ccw_notify)
+#define KVM_IOEVENTFD_FLAG_COMMIT_WRITE (1 << kvm_ioevetnfd_flag_nr_commit_write)
 
 #define KVM_IOEVENTFD_VALID_FLAG_MASK  ((1 << kvm_ioeventfd_flag_nr_max) - 1)
 
 struct kvm_ioeventfd {
 	__u64 datamatch;
 	__u64 addr;        /* legal pio/mmio address */
+	__u64 vaddr;       /* user address to write to if COMMIT_WRITE is set */
 	__u32 len;         /* 1, 2, 4, or 8 bytes; or 0 to ignore length */
 	__s32 fd;
 	__u32 flags;
-	__u8  pad[36];
+	__u8  pad[28];
 };
 
 #define KVM_X86_DISABLE_EXITS_MWAIT          (1 << 0)
diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.h
index eed0315a77a6..ee64ff1abccc 100644
--- a/tools/include/uapi/linux/kvm.h
+++ b/tools/include/uapi/linux/kvm.h
@@ -804,6 +804,7 @@ enum {
 	kvm_ioeventfd_flag_nr_deassign,
 	kvm_ioeventfd_flag_nr_virtio_ccw_notify,
 	kvm_ioeventfd_flag_nr_fast_mmio,
+	kvm_ioevetnfd_flag_nr_commit_write,
 	kvm_ioeventfd_flag_nr_max,
 };
 
@@ -812,6 +813,7 @@ enum {
 #define KVM_IOEVENTFD_FLAG_DEASSIGN  (1 << kvm_ioeventfd_flag_nr_deassign)
 #define KVM_IOEVENTFD_FLAG_VIRTIO_CCW_NOTIFY \
 	(1 << kvm_ioeventfd_flag_nr_virtio_ccw_notify)
+#define KVM_IOEVENTFD_FLAG_COMMIT_WRITE (1 << kvm_ioevetnfd_flag_nr_commit_write)
 
 #define KVM_IOEVENTFD_VALID_FLAG_MASK  ((1 << kvm_ioeventfd_flag_nr_max) - 1)
 
diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index 2a3ed401ce46..c98e7b54fafa 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -682,6 +682,8 @@ struct _ioeventfd {
 	struct kvm_io_device dev;
 	u8                   bus_idx;
 	bool                 wildcard;
+	bool                 commit_write;
+	void                 *vaddr;
 };
 
 static inline struct _ioeventfd *
@@ -753,6 +755,10 @@ ioeventfd_write(struct kvm_vcpu *vcpu, struct kvm_io_device *this, gpa_t addr,
 	if (!ioeventfd_in_range(p, addr, len, val))
 		return -EOPNOTSUPP;
 
+	if (p->commit_write) {
+		if (unlikely(copy_to_user(p->vaddr, val, len)))
+			return -EFAULT;
+	}
 	eventfd_signal(p->eventfd, 1);
 	return 0;
 }
@@ -832,6 +838,9 @@ static int kvm_assign_ioeventfd_idx(struct kvm *kvm,
 	else
 		p->wildcard = true;
 
+	p->commit_write = args->flags & KVM_IOEVENTFD_FLAG_COMMIT_WRITE;
+	p->vaddr = (void *)args->vaddr;
+
 	mutex_lock(&kvm->slots_lock);
 
 	/* Verify that there isn't a match already */
-- 
2.22.3

