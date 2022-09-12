Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEE1C5B5300
	for <lists+kvm@lfdr.de>; Mon, 12 Sep 2022 06:12:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229463AbiILEMP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Sep 2022 00:12:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiILEMM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Sep 2022 00:12:12 -0400
X-Greylist: delayed 83 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 11 Sep 2022 21:12:10 PDT
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC74E1707F
        for <kvm@vger.kernel.org>; Sun, 11 Sep 2022 21:12:10 -0700 (PDT)
Received: from pps.filterd (m0127840.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28BFtwCR010580;
        Sun, 11 Sep 2022 21:11:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=proofpoint20171006; bh=YyfVSbyTRijCayA0e318Az45XK6QFnxj79/isEOk73k=;
 b=drxxjrjaQE8pQgCoogfxu6V+06npzP5we4hB3f6pMy5pJlA+CdJ0QpI6T4wVd4ijqNRF
 2t641KtmrKuWaLVmw+dZrxK/a9W4ToAOidSLI10Vkb2vClgXO+dltHlQ/AmtlGjgllxh
 A7+lDXriqQFMCQlaPainNq+pAweGE63zVvRrXKiiBbPn1Jn9YnPoejFDhILYEQWYnpAQ
 bzWiya3hsj87NDScMKs4rHKZgwisZs+dLFq1gO0uWHu2neopHRxyDS5JKOlCptgl9OmN
 FUNSYQ/VPrX4JsNFeg4pI8x+u573h8B/IdVG/BX21o6Yq/Y7H/E0e1xvkWB+90E75/75 jw== 
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
        by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 3jgpwtjwjk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 11 Sep 2022 21:11:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ASqIOp1Hnpn4NcaRrWeSddptHaLoZGxtuI+FRAUaYo2zr9BoSv6Aw8CIiXCEB9T3DWBr1TbSogndbZGSmC/mbNN2of7j75QzkUzDy1diO0ohiMeUZgDRztQ5AgJp75Rvb2JoV6gca16Lj+wmOnI42PiMfBHDTDRUaBzRy2ppVJf5M84Mnu8XWfalhTjjXwYcFKQRdCGERMKHaSj9INOwQGShhkWoNUeBd/fNPHnLyEJdvvXJ3U2BZdrbZo1b2CmPXUCEChHxWuaJdxf/F7ekhhNkN7eR+zWY2NxTv6k+/EzDKX9uzzKRVf5qmdJt/nwxDqX7AMSNjSfMQxE0uFJQvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YyfVSbyTRijCayA0e318Az45XK6QFnxj79/isEOk73k=;
 b=eE8su5pk1mHorKu0BwkagwwF5bs8jwdt2+MRYoMt/XF3Pdz0CSYgN/0ywvgY+90NX+JKw7LOkkeKrkRwmlxVHqvnQcZm1KEFJfNKpp9hTC76z/8ggU5PNtXU8Mlm20kqF9lkOaMFnzIGlcO45H2bo4YJQBgchC8L4CV5I2NxhpU9no1fYoE7cIvsKFmjluNhTVK4Z96tXhXceZUo08YqNPwcXs+qaq66bwmc5Enbk0o7YCnoxopfhG7w6Nq2tMsEl3+srq0RRgdY8G926d8tnTzbWOpi80J5q/Kc94Rjv5QzEZRGZ8xrFKsKHw1SXc4oroVhPf0PvWOKZDYKCfARjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
 by CH3PR02MB9116.namprd02.prod.outlook.com (2603:10b6:610:144::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.12; Mon, 12 Sep
 2022 04:11:54 +0000
Received: from CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::bcdf:6d6f:e6e:b9cf]) by CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::bcdf:6d6f:e6e:b9cf%7]) with mapi id 15.20.5612.022; Mon, 12 Sep 2022
 04:11:53 +0000
From:   Shivam Kumar <shivam.kumar1@nutanix.com>
To:     pbonzini@redhat.com, seanjc@google.com, maz@kernel.org,
        james.morse@arm.com, borntraeger@linux.ibm.com, david@redhat.com
Cc:     kvm@vger.kernel.org, Shivam Kumar <shivam.kumar1@nutanix.com>,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
Subject: [PATCH v5 4/5] KVM: s390x: Dirty quota-based throttling of vcpus
Date:   Mon, 12 Sep 2022 04:09:30 +0000
Message-Id: <20220912040926.185481-5-shivam.kumar1@nutanix.com>
X-Mailer: git-send-email 2.22.3
In-Reply-To: <20220912040926.185481-1-shivam.kumar1@nutanix.com>
References: <20220912040926.185481-1-shivam.kumar1@nutanix.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR03CA0025.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::35) To CO6PR02MB7555.namprd02.prod.outlook.com
 (2603:10b6:303:b3::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR02MB7555:EE_|CH3PR02MB9116:EE_
X-MS-Office365-Filtering-Correlation-Id: ddf8d74c-9585-4ae4-8b41-08da9474ecd3
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yv206G8/exW4SGjcspFdOU3DDLbtNTnfV4ksfsNkzI1yAqRN0zBkhKXOgrZisUB5n2pJ4CeRFwvpgTClfJmSp1q51THh9/gnJdxnEG1ujg21CtCV9Am4y8d6hkboPz9S3mtXUro6kNhaGnQSeEkoKJPizjbg8BwZHr+S2s8IgMMbHLYnqqu5nqnVpavuW3EU/9zViqBegWNhOkRzQ8vczwZnKh/L/mWeJOiCwTrDDwMUPXWjjBIxNZJpCmiR6kN1ABmdP+theHzixEyfRhfNGFOojTUThF3ELESqJLUpQhKuY6D/3WPUlerLnFUr2HgVSRR5Xqq3FG1Ke1vkzMj2zixYsj8VBULsZefq3PBdJ/sc2o6jZuVnu3VWB+dBT7NyF6CJ706t9bItl+TU/vRGJndetgKQj5UgpuCPeHDNIrWrmg9luoxjPIZDukTkYNW2sfG0lbnatT/yAzcw4hWgGLNJYBC9vzptVaFMEqMyoL291+k1CdndvaLXdnWWbjwzBMs6BvTZm4z6astx16W8fCtIEHU2NbpqLDcuUqRsOegjXOShOKgZuNld1z2/hfd+injq3P1eGU1Rza7G+zZNOnCPiRyN1YqZPF42O7D+nx+6JssG58MqHyGEzCzeOM+yOZub5nHn7H1gwQdLhz+0ZnqIvBB8uKB4Z8WG/Bki+GOlk6dJHxrYntQOfmrXetLE5qQIBZFb0y973zsZ7XnWsB7qtYmu2NojSk/kn4KOCDplqRqgdUf+YZ8r3sp+MpkTSZBQZkYuO9p6c5GkUAtlb0NW7fFzqhSOPSWloefo1SM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR02MB7555.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(366004)(376002)(136003)(346002)(39850400004)(26005)(107886003)(6512007)(52116002)(41300700001)(54906003)(86362001)(6506007)(6666004)(478600001)(6486002)(2616005)(1076003)(186003)(38100700002)(83380400001)(2906002)(15650500001)(38350700002)(36756003)(5660300002)(8676002)(66946007)(4326008)(8936002)(66476007)(66556008)(316002)(14143004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?K58VUO6qY4BzWa4fybRh8PZFW1R5ZNMq9nQwlk56Ps6zwQ79rgGWT1Vys5KI?=
 =?us-ascii?Q?Vc+FNDbEvU3J+3TiyKZQWj0bQ/OaQ66SXMDstC293a6SxEalwjaXnylR7Q1Y?=
 =?us-ascii?Q?mCdw7WS302bbqn4hpWY0G3zgYmu3KoEtWpYuOnHMjesWOslz6avqUPaSe2KS?=
 =?us-ascii?Q?oq4SHvckSDBR8Zr032eRRiL716lyqHE9cdl81TlYPKPpdAh/vDQu4Yj/4wzv?=
 =?us-ascii?Q?43eLXFTvOqHsjS3O7xSpJpowW34T7jHZACGck7dakVKKmtvVby9t8H/yItTE?=
 =?us-ascii?Q?KtQID0lXofe0S8tibye/lY3/ORw3VfSuGfa7xlR5lQXQIM9APADpNTXWcAII?=
 =?us-ascii?Q?XY2A6O61dGF3VEFYq/3qaZpUnOK1H3carf7THvIHl5DptBz80CQ1BxF7WJUl?=
 =?us-ascii?Q?6k6A3F1y9tSVPF4G195ZQYA4qGIuTMibBRWSENo32gpkfoAYn+ygSqzHWMaq?=
 =?us-ascii?Q?ZB93aEQixYSiRPD7/7chIBwxWBV69d5RD1h7WGi7zvFXzmaDf+/QH9XiKcx1?=
 =?us-ascii?Q?pxNia1K/1Xny4dRXSaO339wmrG0tAyDQY6j/lN/D6ZZ4Z2a61z50lgaWhz3c?=
 =?us-ascii?Q?8BiqfXGsj5sWK36wMkz2/Iu7HKhJzWNFH5T7LP6pnxnJMQV4I0/L22+Y+FB6?=
 =?us-ascii?Q?spnKXSafWUPCQu/5WlIyodNeq7rvo0Ex78CNpVDHOini2qr8OhyxhZzJ+GFX?=
 =?us-ascii?Q?75gXLxM4qqPon9nA9goWd94AhcUtqBHAHb0DRiW+3q+quIhjO/U67sqx4jXh?=
 =?us-ascii?Q?InxvxAdkw8RLXTEOQr089vJzfshC6/ugVSTowQvrO/ZGyHUw6q0FXZGgMcfv?=
 =?us-ascii?Q?7CI0Lo12viNm+gYBkhNASGqE5JAWgz9glj7H0Lfi7Hq0wFUh/ZYei/WsHqxK?=
 =?us-ascii?Q?1imM1o5hEw28pkdD9Cyv9aTiEAo/nKKU6CxZQ2q4zVRwl/Z5v2ABR5RbkEPL?=
 =?us-ascii?Q?7iOJXNYRn1kVTWJQRn2eUV3QudN4At+Cwagtj8TX0hw3COSxdkJpTh96ASKe?=
 =?us-ascii?Q?WWeezNHxsur1pMzXnqlPNaVSmghEI69zvKFx6KE4OJnXbAOlLT9kAlQvAy6k?=
 =?us-ascii?Q?cRXzmneKh0a/pv0FJ05dXajup9RXt+S4R7ydZ7nC7Aq/Se2JBE5npYn9e56q?=
 =?us-ascii?Q?Wj3Vj9HYiCQZN8wJfmqsRVPeOwf7FZbzZ2kNRsHrr7sGNWkuBTueWHxB0SKf?=
 =?us-ascii?Q?Z7qho4XsrYSoyiSzGuSeloNgZ0Vw92b6/t02ASYRoeFsKIcScehEHocEjnGG?=
 =?us-ascii?Q?YwPFBmgClgtC0FukZEhMKwLBGhIP3j1Y/KZhqbG3CYe7SxQm4z9Mt1dkENmS?=
 =?us-ascii?Q?0E6zmKCWLBFDh0SmMjHmR043aght3yf596I7g3W32MefswCXs5x2CDWkeSVw?=
 =?us-ascii?Q?ZrqjSQvsDJ4B9IR9U1Z+gMxDrWnQQ0/cTQExvamV59Tq33psPwatTUekaKK9?=
 =?us-ascii?Q?BESn1SF0y4TxIlgyxtXtG5PNmEMC0W3d5xVoQlKxXe709kwpzThDPVK4BaQ3?=
 =?us-ascii?Q?dSMiB2yi3tBXnyqYjzfPcFtezFAvmjYE8yNSxa/EZgtc1Kd4NnePZ69bVfoz?=
 =?us-ascii?Q?iCs07HAzCwkcBaD3kfespsT780sVXF3Ue4y0Ww10DOlBLugfCgZP8oTNiSwW?=
 =?us-ascii?Q?xw=3D=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ddf8d74c-9585-4ae4-8b41-08da9474ecd3
X-MS-Exchange-CrossTenant-AuthSource: CO6PR02MB7555.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2022 04:11:53.8625
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2XzvBzRUNPgqa/Tl/4op3iBtrU44SaqSBbHpX5qoh1YD9MHi92xGQw5pXPzcoHvNWS1z6Ps0iKOmKPB992fFRWMTU5LDzjQrySOuS5YZcbs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR02MB9116
X-Proofpoint-ORIG-GUID: ZYMZ54Qj4rMpxcdAv9nkIgVEhLFvamtC
X-Proofpoint-GUID: ZYMZ54Qj4rMpxcdAv9nkIgVEhLFvamtC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-12_02,2022-09-09_01,2022-06-22_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Exit to userspace whenever the dirty quota is exhausted (i.e. dirty count
equals/exceeds dirty quota) to request more dirty quota.

Suggested-by: Shaju Abraham <shaju.abraham@nutanix.com>
Suggested-by: Manish Mishra <manish.mishra@nutanix.com>
Co-developed-by: Anurag Madnawat <anurag.madnawat@nutanix.com>
Signed-off-by: Anurag Madnawat <anurag.madnawat@nutanix.com>
Signed-off-by: Shivam Kumar <shivam.kumar1@nutanix.com>
---
 arch/s390/kvm/kvm-s390.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index edfd4bbd0cba..2fe2933a7064 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -4343,6 +4343,15 @@ static int kvm_s390_handle_requests(struct kvm_vcpu *vcpu)
 		goto retry;
 	}
 
+	if (kvm_check_request(KVM_REQ_DIRTY_QUOTA_EXIT, vcpu)) {
+		struct kvm_run *run = vcpu->run;
+
+		run->exit_reason = KVM_EXIT_DIRTY_QUOTA_EXHAUSTED;
+		run->dirty_quota_exit.count = vcpu->stat.generic.pages_dirtied;
+		run->dirty_quota_exit.quota = vcpu->dirty_quota;
+		return 1;
+	}
+
 	/* nothing to do, just clear the request */
 	kvm_clear_request(KVM_REQ_UNHALT, vcpu);
 	/* we left the vsie handler, nothing to do, just clear the request */
-- 
2.22.3

