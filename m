Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41D01627120
	for <lists+kvm@lfdr.de>; Sun, 13 Nov 2022 18:07:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235400AbiKMRHA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Nov 2022 12:07:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235321AbiKMRG6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Nov 2022 12:06:58 -0500
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9E6BDEE6
        for <kvm@vger.kernel.org>; Sun, 13 Nov 2022 09:06:57 -0800 (PST)
Received: from pps.filterd (m0127840.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AD405tF022082;
        Sun, 13 Nov 2022 09:06:46 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=proofpoint20171006; bh=5/+kEw+DHFL7XWMa6YRMq7RkZZbMdOAJ3VSvuUzTyjQ=;
 b=pVUs50OaVr25Lclz4r/RxNcZx+D4H9tCQTMe3ryLBA0xTSnaaFOFfsy82Z+nwAobXoqA
 zG8H5Ir/u7h1oHGgG1tChMYWOogvjtipKDTnBRZHz+kKAIA+k/Zzx4JThFFM2p3KGxIh
 c6/G9YSSMTjvwObcC/cL7qKiX1LKXBLPMDY9pI7kqONzEvE1cDr/B3ggukFRnKAXZdwV
 tYAmY6MN3oD8e7br7akKfWqtugWI9ppGC7SDqBpEVbOfVfWMjKCjZDAR0DZ7eMoKiNbU
 v8d3GxpQX0+q6yxQM3YyzQY6vGAiWZfK0nHSZczzWnIgT2SjjuuWJ47W9YPjZn9fBc48 gg== 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
        by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 3ktpm995th-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 13 Nov 2022 09:06:46 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qwdvuf7Rs5PdKXSGjswA2ebSbIjRqz7qL+nQ+IotNeL3qjnJeuDyrkiGsd56PiD8P5G/BBqNGvteAsov33W/Y4XNxkwQD07tTXxT2kVtBaXAdpMx3fm6j+dJ1dtJ1h/6czvuGAZl/gvW4LmxUyL2eHwAkP6pBMU1T8VyDrI3ZFSyvkgpQbilEj6FUL/8geYKnI1ktzDbY9wUKPExTs2DFPPtPgZwIjGzeyySp144zaFY75dJoMsIvmI+0pyHNC2sf8/Hseyn/wUZ++zuYyYPuvgFYHiRu/aE8POQ4d8vOOQswvzH0Xh+OI5y+W7/xHzJJmewVTuDzpi2xUj5X4n3vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5/+kEw+DHFL7XWMa6YRMq7RkZZbMdOAJ3VSvuUzTyjQ=;
 b=JUMq8cCqV8TKnXevpY77V8lCmHdegtsjUwNHgFbhB5XbQ8RRIQDtLS0ucvNGTAuxj6gIB0a8WW9Gwvle7H/Vl72QnTyZxG2xvV1FCKdzh6onurBdy8wIuBpGdwhDLRjENjJHJMfNzu1dbBL2tvODFJ/nQLPtx4jUocBv4VLPRyo8VErF5e9keIabMZzvPXDLkJSVZiYzF+WZkbc3jU2sfc54vZmf8ofOs5Izr/ER279ujGeaDOeHo8YH8x7zcA/qyXk5BfGTHpNLBD6N0U4EcHDJbampGgtXX6XecfNF2Hp350cxq5k+mYxLydMM8RPv4DmAacaPu3BIgxjhLvb34w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5/+kEw+DHFL7XWMa6YRMq7RkZZbMdOAJ3VSvuUzTyjQ=;
 b=Cix/21Mo0F5tXUeqRq1fgUELWjdxOAkB3HsEPH2jKYDiL5SwoS/cf+4MHjYakIaH/LTBzXxFz7UrzUIAsUf7Zyidtc/Jp6NFVbgsamx7IFdX5uFObCcVOUHuuoGcM5u9LA3Zr/6ctGpzGFyVVO9GZD8jD4ZhneImDKKMeAQ4J0sLAdEWIxsu2dAxEX30p8JCRQr6ODxf/yyJDZFycAB/ZL8BJVOHZSYHcUKZA/4wFEhSxblcTvHiuf+E19zoE49z99pQQ3PJUUcUYyvNShnoSlxBVLkhYArhmB1Ts80bLlWquVRLJl0dmZ+bkmBW8piDBUXE+E5S998/uI6P/TRbHw==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by BY5PR02MB6723.namprd02.prod.outlook.com (2603:10b6:a03:213::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.16; Sun, 13 Nov
 2022 17:06:44 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::74fe:5557:d2d:1f5c]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::74fe:5557:d2d:1f5c%9]) with mapi id 15.20.5813.017; Sun, 13 Nov 2022
 17:06:44 +0000
From:   Shivam Kumar <shivam.kumar1@nutanix.com>
To:     pbonzini@redhat.com, seanjc@google.com, maz@kernel.org,
        james.morse@arm.com, borntraeger@linux.ibm.com, david@redhat.com
Cc:     kvm@vger.kernel.org, Shivam Kumar <shivam.kumar1@nutanix.com>,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
Subject: [PATCH v7 3/4] KVM: arm64: Dirty quota-based throttling of vcpus
Date:   Sun, 13 Nov 2022 17:05:10 +0000
Message-Id: <20221113170507.208810-4-shivam.kumar1@nutanix.com>
X-Mailer: git-send-email 2.22.3
In-Reply-To: <20221113170507.208810-1-shivam.kumar1@nutanix.com>
References: <20221113170507.208810-1-shivam.kumar1@nutanix.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR05CA0045.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::20) To SA2PR02MB7564.namprd02.prod.outlook.com
 (2603:10b6:806:146::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PR02MB7564:EE_|BY5PR02MB6723:EE_
X-MS-Office365-Filtering-Correlation-Id: 3ebb8c07-ba81-4bdd-64f0-08dac59970f2
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xQzxC6QHUVQDc2urN9KjM8qFx57JFUPmOU1Kr/d5+O2P8Dt/VbY9RI4IzQ8n1xl3TXSnS1bnOKA6aKL3yLjvkKMGw+Abdc6sOEEvgyJNOXRkoVpsfiUR9e6n7XSi2maaraxUQOTWrFZgvz2IfnzNxsn1ctXPMHOWcCgcr7r7hyK2pgiMp/JvOhcQ1c7o3T2x47dpaPcGvAzlkwcu39pTjbet1dbshp9NyFm4oTQhEveTEE17lTJsXsHpQlYVHVm0VcZfQuXD8bAPbfjrAViAm/9XvFd+yeZjTT7PmkS+uicLIJ3BeGsPnJkF8oEL63d/0mM5QeTVHIs3vVcyrE/t0GJNA4TCFJFnhxpaS085IljS4R1tjGnAE04T+vzL2AZBIDlNFUyJixtAwmdbT9jhD/2HnQd9rULffOkDn3GPUS3QKngEUgw1wtpVLLlnaS1RULy1CVJPpjhtSMSxr5DTSjH9HTkEFaTKQLj3/fUcTpD9p00njA0JcoHlXjfeGYJIAoOIJv1w59GpYGgLsXjlgSUDDuyBfmzCze8fWfxkHNUo5osqI0dGfLe0o/UP6TXTR75frmCTJjpdWh2EoElgxS8agAnN+wENI3vLPm872G+9KhlbfdtBhP5/4qvuFnbuhj8QER2xmDiKO0UTXwjoL1x1RlN8unit1FcWexCibxfs/uF73Vcq8zwMgYSbeP7nzqiwWe2soK/tMdcKaJz0D8/21J4SMdtOxPV0+g6CflPVuVSP6hwksLO8F7dXoq83o4PKVp+tXhhmtVlazQCUOv/MlX7LC3FJ2pfNV2bLIUw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(376002)(39840400004)(136003)(346002)(366004)(451199015)(186003)(2906002)(15650500001)(38100700002)(38350700002)(86362001)(83380400001)(6486002)(26005)(2616005)(6666004)(6512007)(107886003)(478600001)(6506007)(52116002)(41300700001)(4326008)(5660300002)(8676002)(66476007)(66556008)(66946007)(1076003)(8936002)(54906003)(316002)(36756003)(14143004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dl39fvn9Ywb26Lv7D1cGUqIuRzCPx7WvzW1pfHZBfbGMh0Doq+s/OlcTG9P/?=
 =?us-ascii?Q?N2Iz0TvGAMjKbhjyTjxVNxms7qEozrifMZpWrUsACK+uQS8Bj6XuFbyhVlAQ?=
 =?us-ascii?Q?FEvdBS/OlSKbCuSK+v6MVlZUUiS0aN0lFtlKg+CeD5hcRHiVqaDjdtlcyhfF?=
 =?us-ascii?Q?Kffjf9szuxizWxsx3jlu+NkTpSvUUc/yMEY7bPQQt0+SPZghxDS6AyQUZcuf?=
 =?us-ascii?Q?URmviE5gfIsmgFMe7gIauXMRRJrTjZEKfschUNqyk2s/FOMPW0QkJWGBrM5u?=
 =?us-ascii?Q?2ONOwlFCX4B2S4yft1bv2Qu4rdDkORShJKpbdPuWD7xvSlc8WThAzs3VdfZv?=
 =?us-ascii?Q?0UVd0xtx3ORlI0y+UUH6KSiCLN0QZahgP3XPjdO5E69KGukxwyxSpUg6Nx+P?=
 =?us-ascii?Q?14uf1KyLBF9r8IzqvcPNLlKCxLB4h3lLzbOZc4YuV0WhfW3Og7vnNxRHD1mH?=
 =?us-ascii?Q?pX34t67dmfgaQZRkw9RCNECnDy1YRUKN7yC4hw+IlI7q2rhMDs9xQvC7XI+Z?=
 =?us-ascii?Q?ii4imgJIBPUfGqurtD85VpGrGxx4oAju7IHF/ZtwPoIlfkg5cIsmNN/M+fzw?=
 =?us-ascii?Q?5KVfNHLoKJtvs2aUc3XzGrv1RhCcjzRP77dK3/jDWnwzyuvnGl3mz4W8RfnE?=
 =?us-ascii?Q?pighAclU1oqM7I0Ff43kGHR9hn8Vt4UK5lGHP6EHyRkLGA54Fhflcet8r/QA?=
 =?us-ascii?Q?PiKbBEXmnovvIZ7Va8v9p3kkR95dzuVedkggbBWz6Ey9y42hHJAgTOBBczA6?=
 =?us-ascii?Q?maeVeY5gu1KdEdUAPI+lYCaiC1l4wcM1Y3IzWk7MzJn0u718wdMHZybfC/aT?=
 =?us-ascii?Q?J5LbNUCxmGT7mtBR1Iq7L2OxUoAw8sNWv5Q0qomThsHDLbFmI8TyMAjTNNVt?=
 =?us-ascii?Q?WcBs3EVYl1+w2yDqDBpamDyHMhKlwzlTl4kjYf2di95Nott3ZkOPQMZmPdnD?=
 =?us-ascii?Q?LPsQ1o4PeYmT/uDYaPmcsFI6QlAa5szNP8XnE7KQnj7PR6cCPaNGj+PZcBrW?=
 =?us-ascii?Q?zBjLUK5P37zySJ5DkhM7yrqJ2Kudk5CIsyshpVK5VgcgCUG9Eem/vnJUtV3/?=
 =?us-ascii?Q?ZQ5HfKwNrl/8eiuADTQlo/qZFSbatrnroB8/hQw+zSOBS25YdVL6U0L5HG5V?=
 =?us-ascii?Q?WyeHCfxbhvWqD6QaeKfAfGcQucGd3sKmrnvqX2TaKn23LliGJ7Hiz/1DZyCr?=
 =?us-ascii?Q?CZYXulY7QDnajz/lFsmCo2mtNQsL4EMxFVTGuHHcR46leekPrLlyfJVB/K8X?=
 =?us-ascii?Q?kM8U5OaTJijRi5EZ9MVAhhcXAazsOaYTDq5oZFbXfKwfw3/leiZNa9zizeeN?=
 =?us-ascii?Q?WGMPA7qW4jXe2fC036hVkFcwZTWINsNDSinXxpp3WRHiDWtBwzrp/L8nNi71?=
 =?us-ascii?Q?IbK+y67IUYdy+h9w/kry6CxWc2NfgXg+gRMaLEt/xcICsHFgCJjtZiFkTBNE?=
 =?us-ascii?Q?czif8dFajV/iwsGu3ra7gjPVYBezoL9UDas9D/jc7JFv7fUPpgowKBAm3JCB?=
 =?us-ascii?Q?79PopMqLgC9Q28e9iAOeoUFd9pP2NPpdckgCdzGB7Jj81vNV9uYe9+LcyCYo?=
 =?us-ascii?Q?jpGFE/Fnpv9dtnlvzwb+MxDTtjj8fjmCxH8VupLddK9gIxzZSw3MySpfEhW6?=
 =?us-ascii?Q?pw=3D=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ebb8c07-ba81-4bdd-64f0-08dac59970f2
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2022 17:06:44.3666
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4Y8wZKo79lseNVSqoOiTOTWrZfWs0Q79HgyMoqFYiUfEJWiLDrseM8qX4CvGgifimvWyxpQBbPk9VC5EoKeHivEb7r7w4+IkH3fywo+QVYk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR02MB6723
X-Proofpoint-GUID: RFSQwBq24r-TBrptwcpQB9VY8GfAEp2f
X-Proofpoint-ORIG-GUID: RFSQwBq24r-TBrptwcpQB9VY8GfAEp2f
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-13_11,2022-11-11_01,2022-06-22_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
index 94d33e296e10..850024982dd9 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -746,6 +746,15 @@ static int check_vcpu_requests(struct kvm_vcpu *vcpu)
 
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

