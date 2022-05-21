Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C255F52FF63
	for <lists+kvm@lfdr.de>; Sat, 21 May 2022 22:31:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345473AbiEUUbN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 21 May 2022 16:31:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345230AbiEUUbK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 21 May 2022 16:31:10 -0400
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AA3C1033
        for <kvm@vger.kernel.org>; Sat, 21 May 2022 13:31:08 -0700 (PDT)
Received: from pps.filterd (m0127838.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24LIpc7e020493;
        Sat, 21 May 2022 13:30:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=proofpoint20171006; bh=FXkTc2ZVZXKC0E5sIcch8sHuG+fu4OGb9mag3uHKaKQ=;
 b=f9et2/Q16WRw40BElCMet3baFIrwA2rDKcfecUelzs5TvWoGvDVta9FuLtXoWC1tJmv8
 Yz0LkvZSqEbD6GbVRTWnbEWET9TxWmxs1XMKqNI3Z8r1r2SOM8a4dH4refPUxgH+05Uv
 XHmwVd3xat3Sxfkz4tfmg9GMkEQCVkgWdrTQPLrgzozJMUZLpMkSCp8FPAbdIA8aHmSK
 YNK1eno7TGcXbYfImiR/ziY0lyq7ulnS+FGyy5TGpp4OZz9sO1IOg/n+MeqSGOyps4ms
 A/YmdC2Ahd9axv6rQyZtZolQSzgeQSuMrTyWa75TqpGCmYFSwric8OE1ntok+59wEXII fg== 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 3g6ymx0fxh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 21 May 2022 13:30:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ls++s6D+2hvuQy7OlOisGv5VKbbyyFZ73xAePw2crwudJg1pCXzbNs7GRxxovkGeuC20xaEVzHdAVFGHjJZBRQcNbzRQ+tahfEmJ99Vkr3ZVzN0iAM7+V0KxHuhY/uDlWZkyo3JRFx+DPrGvLSkvrPcovl96D2N0zWin6NCHb+kXUyOxbwMjdoNkGKrx9AoP5hxUxe1HTS4fbiYNEGGc6tpObmhvYDrlDtRSFkfrkjyWa+XJzHZdq/xKO13osLV/x0s4vgJXzE/XPrV+IL+Ii/iAY36FyX0NHNfT2dobx2p2oADJIys69AhA6L83m+c3uVHqHvcYR28pCfKGow8LkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FXkTc2ZVZXKC0E5sIcch8sHuG+fu4OGb9mag3uHKaKQ=;
 b=PHELYl7YcPjOQ1eG41ZXCymbtqX4Kki8DU+1bUqwynhl25j5ZQUCf+mhxVk+KZPrvB8yeVR5+Qfkn4lv8gOYIjkMiZ4JmcD0fE705rZ2cPu6BNk3Gq163hx2CkNt2BSTJM6xdX3tSnBBs6WXGdEtFYXLqgBkonlLW5sVu9zO9XDFObTX/R8VAy9olzsVcXdamC2UR0fglhWVFKWs6SnONCBAtOYhE8sWtwOkfY0doNUJtxxKyq4dkHYPHp/nkScLWJZzpdbSVqQIF2sW8VAeuHlPkR286NC+ud1A763XHdRBA/BJXp9scIugih6GBYxwPpPfXgAbD9INqu4DFSIoTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
 by SN6PR02MB4319.namprd02.prod.outlook.com (2603:10b6:805:ac::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.19; Sat, 21 May
 2022 20:30:55 +0000
Received: from CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::6819:797c:706f:9a01]) by CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::6819:797c:706f:9a01%6]) with mapi id 15.20.5273.021; Sat, 21 May 2022
 20:30:55 +0000
From:   Shivam Kumar <shivam.kumar1@nutanix.com>
To:     pbonzini@redhat.com, seanjc@google.com, maz@kernel.org,
        james.morse@arm.com, borntraeger@linux.ibm.com, david@redhat.com
Cc:     kvm@vger.kernel.org, Shivam Kumar <shivam.kumar1@nutanix.com>,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
Subject: [PATCH v4 2/4] KVM: arm64: Dirty quota-based throttling of vcpus
Date:   Sat, 21 May 2022 20:29:38 +0000
Message-Id: <20220521202937.184189-3-shivam.kumar1@nutanix.com>
X-Mailer: git-send-email 2.22.3
In-Reply-To: <20220521202937.184189-1-shivam.kumar1@nutanix.com>
References: <20220521202937.184189-1-shivam.kumar1@nutanix.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0064.namprd05.prod.outlook.com
 (2603:10b6:a03:332::9) To CO6PR02MB7555.namprd02.prod.outlook.com
 (2603:10b6:303:b3::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f738b79e-ee81-46e2-3007-08da3b68ce61
X-MS-TrafficTypeDiagnostic: SN6PR02MB4319:EE_
X-Microsoft-Antispam-PRVS: <SN6PR02MB431904FC343E50C54B7DD2CAB3D29@SN6PR02MB4319.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DOY8Cx7D7UawYZkqVD2lpAvBet6Pu6IYDyXRujA56dZSwwCuDmKJSMWdI2tWjmxrVmB43URBYioAp8KyqtwoN4Ukk5mAGQxgOJXvuRAXCclviGBhBnNJHpH0++wvW2S8/3BdoD0xgGKIso2AADY4OCyzNFbzTwgC5sFMNjyVuag/M3VN9DuCow5ExXAt+m3IB0W+IZ0EBZnZraiCINdZQVNId0inVolj55o0ymkA9sTtR6mBh6jzVTkBJ2ORu5mU1/ZeZCPNg+xGEWOsppVYUsch14h4RKPm09yICwY3VXVjHAmO22xS3xHaBZoqJApi4wh6pQQX0L7Eb6Wkk4Xzf97XG0NxvI+iSsHVCQSHAIDPs6qiTrxcS8nnTGlWgNOziu2juNv2uzsGC4+5JTV00jn+CSgn6Mvs+e1YxCc+Y6kwcq9pZhLBxAPpL9T1QQc4vug+Mt8g9bc+lXV33SoDKj6b4SJR3QIwMiNGlb8gfpq3SKMyscMSTQXpsTAjFzh5a8XtJv4JZ34ZBNn5dUMhkrE9nQpMsRj0fSBHDU9Y0wS5FjRe5EXiOj7SfarZUsCnBQLrh1hL+mzovu/J59/rB5Ut8Y3bqMfANHMF3g6J5an1O0qfbSeSe03YwZ5AQqt8/cF4BmUfcsroLN6XRIDFvzqo3NLf9LHc1/aYZfEsWT0sgu2DQBxHJH7qGKGueCqAL60Thrn/OO6vhmkIXi6z23LTPQeaqt+GpKL0OdsbqcI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR02MB7555.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(15650500001)(52116002)(6666004)(66476007)(66946007)(66556008)(2906002)(8936002)(5660300002)(4744005)(508600001)(4326008)(6486002)(36756003)(86362001)(8676002)(6506007)(6512007)(316002)(54906003)(1076003)(83380400001)(107886003)(186003)(38100700002)(38350700002)(26005)(2616005)(14143004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tmAT03sp5RMbfkqBDJTGFc+HIlBMF2Mg8xsbE9WJVi7YyJXaNPtXMVxCgNCG?=
 =?us-ascii?Q?1iR6dQ0/4hSNS0KUEBHi3KaSixGlY264iSrH4uQthtU5Orz6auuvP3LkUgir?=
 =?us-ascii?Q?6ad45iVoELCTbqRAvyVchxqNMdfJIhgyh0YgLxTo670f7+yFIvqqD5vvO5hJ?=
 =?us-ascii?Q?7sn8xYbl5kkJinMrVJCJUt7BtXHEfD9QJO28pp/UeDSqEYGpLj7FftMZdMnu?=
 =?us-ascii?Q?jEKTqz/Vkd6C3I3U4Me7haWXQIM69gpeb37o/o07dS2Za3whQBuootZDrSF1?=
 =?us-ascii?Q?uZSygBTkO2EtmwNCB5CTOS/VgPe75cqoEk1ciZMBGE4nUlJ7SDdK3uMlm5wl?=
 =?us-ascii?Q?tCJFfwocj2NLSY6N7gTSeYEJmYf6ewQu+LVPi71ENKXWar8l1Pm0ti2vEHUW?=
 =?us-ascii?Q?Ag0qR2mQ/X6gu6PuJBnZYU+Ra/gEFdMlDuJYx3a+NQWzWLToPvrFCDTcVTs9?=
 =?us-ascii?Q?Hd+8MJ6XbFCevKVhyCVkVDH2Z39LuAaRUyq8mmVcdpuTQwVQdgFZH31mT12D?=
 =?us-ascii?Q?2P9Oh2+1RHyW3mTO5ljcwG8Xypz2bHbLARG92xf22/4HXvvjVUhIJRkBk3Xn?=
 =?us-ascii?Q?luk9fA0LyndBhvQC5o44Z7jPAExl2IGSWj3hToJcwqaLplRKPhPsesYVMGiP?=
 =?us-ascii?Q?Sf3MLgeB37E5V02tQnVnhB+rWjRAOvAlFxWdqn+YDBbAUKfNyYqD2V69Zwq0?=
 =?us-ascii?Q?Zf0r0Bp8zmbe483KCr8Pqp2eC1OL115Z8+XSrAl8ojV+1wwYyd6P5GbKfIrr?=
 =?us-ascii?Q?NH3Al40I6WCmWzGBWpDdiX3XKmZByADjbMNrpN9y4logsgd9NXHDFRpSro5K?=
 =?us-ascii?Q?eq4SijcdjNCNbDx2wB7DBD+u+r0pyFMkReuRYr2JyFvaooU+KJ5BB42jrCsZ?=
 =?us-ascii?Q?1b0zAHbMB8TcyAS8Eaz+hBp+mbH4gy0dh0q0ucFProXH61PB/RQ6nOl+t93z?=
 =?us-ascii?Q?5YcAwizWMekzRcrVJXkAkTEuVwQtXYHW7y/Q1GXNF7M5IrfkRKnnzNwhpV4z?=
 =?us-ascii?Q?WhfUfzqdVcv+HF7MT/Apmfg/URvuHpMWJS47wzc10yS++quxXnTUPiKLpSKU?=
 =?us-ascii?Q?1n1SxARsTviUIhhtJDd02FT/VUFO9NNEg1gvnXOVhVUz5YNHNngMDQmPHsJR?=
 =?us-ascii?Q?gEK1V7Cf5XifnpI1l2+HrQGbWa4kKZZD7sx8s48JREhvc4j9WdQ5ve9bzX3/?=
 =?us-ascii?Q?OWMjtObm1N8o/4eoRDaWkwmxd4uUOH0V1uLIKC9SHewsQJRvKnwa9Hlat4uy?=
 =?us-ascii?Q?VpICbM5rytyKQ2LijkFgfIivvcIeNOKe6TBGVHv1u+yBMOG/Q4Pns04dZSsX?=
 =?us-ascii?Q?qyI2UiD7v8yENtj2eC9y3dkJSRrRPlK6eDOoROj+xvWv1BslQxm3lduBJgbM?=
 =?us-ascii?Q?om3EVR05XXPqHQ5FP+a0Ff5wMuO9JTzWNv77aqtsseGTDuTgdea4IM8DxJ1J?=
 =?us-ascii?Q?mffLdumK3dH8GnkPXZj2+E/RZaif/+9q3OZbKUhrZG0NGPgBsqgoYPwyaMGj?=
 =?us-ascii?Q?QzgzyiYAi4z007oo9bUWtEc70OJpZ934bB/04yqfC6hi/Yi3cgx4kA7X+ZP/?=
 =?us-ascii?Q?uBv/OmUVMKlsq4q3LEH4dYxbp2r0/GM7/mC+wTX8xZHsWtPo4yZQwqVIo4fr?=
 =?us-ascii?Q?TRX6mKZx97DQPxrqmi6lTxHUK9Z1WUoLcybHqTlLFF/xO8c1S/ipiVmFUH8e?=
 =?us-ascii?Q?Uj4YTMnelNFsJGhQRu5MvUq5c0DbZWrmJce9PU+57BBuaK2dfl3o5awzKLl3?=
 =?us-ascii?Q?O8YawV7L5T2qvw9mO1L6dogB/ZwoxKI=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f738b79e-ee81-46e2-3007-08da3b68ce61
X-MS-Exchange-CrossTenant-AuthSource: CO6PR02MB7555.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2022 20:30:55.3490
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NB2VZNyi4z2+VOkegt3ubV7qKkvh23aPQ5d9czsvBqDIBjksQRktiK33rtC1G3zLY+VCJZOlD75CrDTgrYM0lCwO99LlEGx4b45BeEsn2i8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR02MB4319
X-Proofpoint-ORIG-GUID: A-p2WJUHMNZoiPwyVXUq-PRPjdqeATFG
X-Proofpoint-GUID: A-p2WJUHMNZoiPwyVXUq-PRPjdqeATFG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-21_06,2022-05-20_02,2022-02-23_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
 arch/arm64/kvm/arm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index ecc5958e27fe..5b6a239b83a5 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -848,6 +848,9 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 	ret = 1;
 	run->exit_reason = KVM_EXIT_UNKNOWN;
 	while (ret > 0) {
+		ret = kvm_vcpu_check_dirty_quota(vcpu);
+		if (!ret)
+			break;
 		/*
 		 * Check conditions before entering the guest
 		 */
-- 
2.22.3

