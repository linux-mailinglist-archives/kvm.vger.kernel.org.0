Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B77D05B533E
	for <lists+kvm@lfdr.de>; Mon, 12 Sep 2022 06:27:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229531AbiILE0V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Sep 2022 00:26:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiILE0U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Sep 2022 00:26:20 -0400
X-Greylist: delayed 627 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 11 Sep 2022 21:26:19 PDT
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B007E1C908
        for <kvm@vger.kernel.org>; Sun, 11 Sep 2022 21:26:19 -0700 (PDT)
Received: from pps.filterd (m0127844.ppops.net [127.0.0.1])
        by mx0b-002c1b01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28BCIHA7020506;
        Sun, 11 Sep 2022 21:26:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=proofpoint20171006; bh=39Ppz8D5yUE2kLAAbJqLn+DP2snZCikuOwcRuOeO2W8=;
 b=DfSwCHtQNex549YcamMpg19EmsNwXAUpYGaQEvStLcIWsAr0rz7wvHkFWekbQZoQQIoL
 LmkcBxBsVpbU9BY5GWPw3z7EWc5mZc+BahFLfDeHA1UISNkwak3GWKtomyIELsLAyIba
 hK7k0/cB3HcPMPqeKvifej/AYeBFT2ZlzxkT4/M01I7V6r/lxkw2/LtmMJGiRRu9qiA7
 jQYOHjTm6t6QRD7CJMm12D4ryZcyT2ZtsrHaoIFkx6lNMsbNLUSUA+aVfJkRrcA4Mdm8
 4zoPPhr4GO4eeWQgGGuRYT9Hn6dKPeYirN4SNuWgjmMq0277ZIsjdjph3oCI6eSzSQqF KQ== 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 3jgt41ap0n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 11 Sep 2022 21:26:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LiJ03uS1ZNJxEP4AvOaeaV9AXE1a9/kPE4mIe/6Wbmg9m1q7nY4F2XjTxLdKidZRIL+nd7dc49QJgnL42FSiBFZgQ+z0YtP3cD7pv75IKZH2cCr7frfUnrh0bZKp8L5pyt+49WnFuiWZT2qFC44WUz63px2TFa3bB/LfNRyCSQ811xB3mrfiNNJWO2FKW6YaqHyE+uEuEuzO7DZ5Bp6tx5G6PGrYHoLXDvv2JIGF2m8RvoRozFTVnM8gyny8ocYiNph4cXNBNtB/WRlghyQu4m8WvQP4fCQHCwKyzprgMvVIt5aEDqdaRpiERtgs8TQgjmYO6f/3jeDA6oFCxCAwlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=39Ppz8D5yUE2kLAAbJqLn+DP2snZCikuOwcRuOeO2W8=;
 b=C45t8B8FEB5n1o+V21l7k1ROkm8OpLlOELIhFUKs2O9ZlqCyO0gcy0a9y7MqZX6eZwWeUst8dxd4IfRzFla5GtlC7/rXUxwCd+ODg1lUh2THW5QAsQ60vs2VESneWc5JZ1I4mOMtAKAzdPrrbfbHa/wY23bhwAgsAF2Pwbj+0rugjG0k4UZhveAox2hrn3HCQtA9AinysUIeAU3l5PdpB28S6oCQ2KMmJwKsw+j451BbVOV1GX/+2td1lTADdDZrHTOYDOlnLP6UlfDQ5fK3h4ZCloXAaRuJzceZsuvYlbDLbMvSWHLkMtakQKY+vyPbhL86D9BhFzFHCbsfRhbUpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
 by CH3PR02MB9116.namprd02.prod.outlook.com (2603:10b6:610:144::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.12; Mon, 12 Sep
 2022 04:11:35 +0000
Received: from CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::bcdf:6d6f:e6e:b9cf]) by CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::bcdf:6d6f:e6e:b9cf%7]) with mapi id 15.20.5612.022; Mon, 12 Sep 2022
 04:11:35 +0000
From:   Shivam Kumar <shivam.kumar1@nutanix.com>
To:     pbonzini@redhat.com, seanjc@google.com, maz@kernel.org,
        james.morse@arm.com, borntraeger@linux.ibm.com, david@redhat.com
Cc:     kvm@vger.kernel.org, Shivam Kumar <shivam.kumar1@nutanix.com>,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
Subject: [PATCH v5 3/5] KVM: arm64: Dirty quota-based throttling of vcpus
Date:   Mon, 12 Sep 2022 04:09:28 +0000
Message-Id: <20220912040926.185481-4-shivam.kumar1@nutanix.com>
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
X-MS-Office365-Filtering-Correlation-Id: af5a38bc-75f7-41d4-56bb-08da9474e1b6
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zZVj/KkEA3swy212UdyU03yOF2jjqY/L/1QymaYjSwgf2oMX2PE0RKtUkzmyuxAXA3rV1+A0HMXebYZ/d9XFpLWhx3YI99HvX0oiYfKuIvx7urgwtQFh3a/gGJW924hze8++YTH5j6gd4M7ZPCnxaz/ZmbKZFx9XvZj7KPCSgBmZ5McIG7zq0GfhbGNoz/F4vr41JhCNtJvDHy81lmEWLY0T4fKHaJ8mVMUzvD37OUfLHrmY2aiH+G9kJb+H4wnNgYUHYQ4MetmoTssG2mk9qiVmvN1JPJPmPBQaTKykzvlpBdgRdgypWI/kS1MrBKyFNc8U3E7OJhupBTD4EM9qrRB86LThDzv+cJDUCjKiewpBT3Aj1KUG76A5dX91ZgfspgADOmlMKKe3R3vXf/TyxvKc1eHK4s35S4gnBhlxfCy7yGI5TeWcjxyMMQ2kjo9cHK+LiLmCjBJ6U0obb5J4Wbp9T5medyX5O+urMka+loP7MUxNf9a4XBE5cYV6uduhhXEp2+rWdrUvOGwvMY13KnF/28IRYop5pXKUpJ5q1u8mvi4k1VshlNabjAVHut0ikjBgHfI1+gc4LLntER5EJKouxgthpjmxKyOR4s5Q1lmf788E//JSYWVUF4Qo0TUfE3anWxOuo75cCbHwvnI1PUT9w+7OFOSkcdXJiB/80Fo2oWUwqdVXuUyg9u80VZs1PCtH3CKSBqfDNvfyibRX9vfInhRBRJ4d12Ow1PWyFW33h4T3YOwhWJUGNkrUvm7xR5U6vqbKHEEVPmen41eguY6t7RfqVmC0SDHVSsEGfeM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR02MB7555.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(366004)(376002)(136003)(346002)(39850400004)(26005)(107886003)(6512007)(52116002)(41300700001)(54906003)(86362001)(6506007)(6666004)(478600001)(6486002)(2616005)(1076003)(186003)(38100700002)(83380400001)(2906002)(15650500001)(38350700002)(36756003)(5660300002)(8676002)(66946007)(4326008)(8936002)(66476007)(66556008)(316002)(14143004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9wZwdKP6iNhK20p3sY8IYLyCJ3t2XB6gbPpwfncL46Kcd9Q8pMd37zBNhu8T?=
 =?us-ascii?Q?+SOYIP4j7j/mEzTaQjmPjRV4gHl67rKMVIHaj5O+b/FcNgNirCDRi837ZGut?=
 =?us-ascii?Q?CmQX5hrJdYTnCdAZtkADVxx7ZQ+Dh8JJG3mmAIpTv3DHHdte7yqFFhU0In/e?=
 =?us-ascii?Q?+IbBeU70xR4cLXus4hVzNp0ot72WXMVcrWa5ZRgje7LNYnc07mkcNRDPA9S+?=
 =?us-ascii?Q?hJD2E8ziIJE/wNs+esZh7yCphp7VrBRkIrTTZDA3uSiIsb3axvUudQj4BhWc?=
 =?us-ascii?Q?6hUA6VcfZm1ipanzZd5XjgtNTGHVrSAtwxFGltQ31LYIMnSwXfVQpK+C6XtX?=
 =?us-ascii?Q?aDFhKbxIGx+QefJpBay85rG3tT/bJ+mO85zIkYTeHcjsBiBndUuiuSUOWoYq?=
 =?us-ascii?Q?hQdfCfh1IEbM8GFHVh1ZMvvSs1v7YteXOuJxNqKBN1T7edpwuz0sY/4Tp5hc?=
 =?us-ascii?Q?oDsPfcGn0H/SB+VBDjKOvQKmNpDlbIuT0Ac8sncHKSBCd/QI89nZFtrRHRUn?=
 =?us-ascii?Q?43h46er+tJnNcRqS/GVJdBmnXzJ02UBfeE61SFOyQhHRvjgTRiRZJHQ0nBau?=
 =?us-ascii?Q?IwHLuDwneC5+6N6gL5/xWr3JRb1cITMaYCX6WQz5tG9q+wYQw9tOujJ3ynAp?=
 =?us-ascii?Q?VpHbjnLpCV59Sy6ZUmCNeATMdvliCB1VuqT6QWf3/LaZNTiv0nMAs7gjDXgN?=
 =?us-ascii?Q?M1Ne75bEZz59XnaIS/iRKk557xtXgauYhAn+lFRanf4LIW2FSv9V4wetdZWr?=
 =?us-ascii?Q?65Ei67W6u5O4W70bT/8wlDAAQLad5m73aySEUbJJWUefUjMnQWaEOt47Nsnx?=
 =?us-ascii?Q?4f0rTbqN6YPOqTS94xU6joPYO37o2iprC3hRizR+T7fhg+0nERNSgWlDoC7Q?=
 =?us-ascii?Q?h/XmPNc7zt2jQJqiFbj7OhQYg4yKGIQvSQPXq9ZN1KqaOG7hRCAUMIUjiEy3?=
 =?us-ascii?Q?Nw6onmdehXAxlkr/uXVsO+btq6B0RINBL7pKpQzVQjHOSbHFM7J5s8vv+tZ6?=
 =?us-ascii?Q?Ijf5GtSxHSGXf4Zim2Swdm8+v4mhNOk55tvw3s2d/loVTCcim4wbyQpbBgtk?=
 =?us-ascii?Q?eswwTA8eM6RWnqxg36lrQWxHvPfSZjFISFadzh2iLbsm2UWlLNZ7tzxIm31Z?=
 =?us-ascii?Q?Bds1C5FRGMmSDdks4/uY7GNG1eBkgA3FBp97+MeXAmNzdi/vTV4hcCGrpkfv?=
 =?us-ascii?Q?iXwBwEK/DD/eID8v/SgXLDJfwfxl3vgAu6Cyfc9c6ic7zRzuDNhDy0ruG1Kf?=
 =?us-ascii?Q?/pofHl4oFpor7kidRgZORVmi2aIltsZX/tj6UZJWCy0QzGxF7vqi4U59TxP9?=
 =?us-ascii?Q?NIuCxWIxHm6bvmkkgPRSzjydXRGoRH+5KnF7MqpM4K1OnEsUd1mGWEs2k5hS?=
 =?us-ascii?Q?n6bQkYQ8INMEX0KUffa4GNt2GEKoNC2wYZgnvO7z16lyv4YIjvQmPbJgJ1Df?=
 =?us-ascii?Q?1I8aUa1D8sv3LJ1IgzzyXScZZku4gu1y7o7P730m5pe/nnNi9L4O1cOtZR13?=
 =?us-ascii?Q?G0hco0vpzHt3xKsd2VZvuizMczMkxU1mqpzScEp2MZda93TKfgr9Cyfo9BLP?=
 =?us-ascii?Q?LtVAEm9i1p0S5AxuTGjI6bo/gcKJrL0XvoyeaU9OpmkKmcACB+X+3y1PE8gy?=
 =?us-ascii?Q?3g=3D=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af5a38bc-75f7-41d4-56bb-08da9474e1b6
X-MS-Exchange-CrossTenant-AuthSource: CO6PR02MB7555.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2022 04:11:35.2161
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bh8l9T/vj+RgjsKhboTRbL0g7w5aI01EqWtlGfShw94FMH5FaPsGjkYFDMs1X06nNfgunDpbixAgml4F0KUDhhVd2AodE/GrCIsmXn4tyzw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR02MB9116
X-Proofpoint-GUID: DAdmWfm-yvtz_GTsG4Gc5G5BL6jISEVY
X-Proofpoint-ORIG-GUID: DAdmWfm-yvtz_GTsG4Gc5G5BL6jISEVY
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
 arch/arm64/kvm/arm.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 2ff0ef62abad..ff17d14aa5b0 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -747,6 +747,15 @@ static int check_vcpu_requests(struct kvm_vcpu *vcpu)
 
 		if (kvm_check_request(KVM_REQ_SUSPEND, vcpu))
 			return kvm_vcpu_suspend(vcpu);
+
+		if (kvm_check_request(KVM_REQ_DIRTY_QUOTA_EXIT, vcpu)) {
+			struct kvm_run *run = vcpu->run;
+
+			run->exit_reason = KVM_EXIT_DIRTY_QUOTA_EXHAUSTED;
+			run->dirty_quota_exit.count = vcpu->stat.generic.pages_dirtied;
+			run->dirty_quota_exit.quota = vcpu->dirty_quota;
+			return 0;
+		}
 	}
 
 	return 1;
-- 
2.22.3

