Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A61E610E14
	for <lists+kvm@lfdr.de>; Fri, 28 Oct 2022 12:06:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbiJ1KGe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Oct 2022 06:06:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbiJ1KGc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Oct 2022 06:06:32 -0400
X-Greylist: delayed 1558 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 28 Oct 2022 03:06:30 PDT
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CC924C006;
        Fri, 28 Oct 2022 03:06:28 -0700 (PDT)
Received: from pps.filterd (m0127841.ppops.net [127.0.0.1])
        by mx0b-002c1b01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 29S9KdNt003806;
        Fri, 28 Oct 2022 02:27:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=proofpoint20171006;
 bh=GYpljTN2pCcPINpcqlGfmUpaEIoxvX6i3qQatjj2Ab0=;
 b=I9flCXljRBIS0MaVsoiVgYW6HLK9mPvgXhLrtxMJLt2tjdZ7cW2+IvWMuTnwjutLWt46
 WTCvfzhV1d0I/TVt9k26hOgRfpnUIEFHoyAnwIwiYWWIRTY2723yKPo/6ocwg6v2/PzZ
 idWp+8thAOJM9JsoLb0BIHtuVPHeT5dcHFWgMlLl+v3g0El3YuFQzRqFj3m0TIXNqaGj
 B5Nf+FBOgxx4hroKGpgLGsKh0W8XIi79NCEziUyuyqa59xGRlCo4JdBnre/qJqcP6t6k
 /LM1VMgt2Ci42yZNFFWBI51bkcleNqbmNmXFpRtF2VU9P5DTjOY1XNX1bh7E/z7nW7gY vA== 
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2043.outbound.protection.outlook.com [104.47.51.43])
        by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 3kg4kurv9p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 Oct 2022 02:27:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OMJ1FloVr6bVGiFH+1dAuu7lZm757mHbZlgrGo2A/HzwObIdVreIoWK/b1mpbk4l5wWKkmbwLKGcmCrCT1Qkzw2htPzcd6cOtBpLr1eBADMSL1NGVXSef0q8wxoQvSliGEWdVV4F+H1lHDWbPyq4/b0QObGqn7Mo+y27L2JSbM6cTEnx2cnLQQq8+Mm9SaNMGJmrDmI5PgFInmcGjtXYfWRLoThpuexUsRbOPXEPyJ2z+eWQU/ENNntiUSXRfvDpgLswLwFwuxnfTdr26WSYo4GIdzRBBCfoWXTT79A40uS3VWzw4HoDROwpbhg44vWm0PtAa7eyyRJ33foRS/BZiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GYpljTN2pCcPINpcqlGfmUpaEIoxvX6i3qQatjj2Ab0=;
 b=Kfn3ynJYsM5CJUfXqDvr0PtcLsFx5SNn7CCzTMK+IbJC9TCY8dvZwzy9sm1O6tO6GM99bwDYjNjOuo5x6Cxg6j7EAfAxKPRMt9S39vNEC2UDkJ6xWGyFUpFCBQxGJUzyUXdMYrm5bSAQ/660xaEX3rLrb0LlpLDCwm/zOly7puj3JBhtbIiIcOqKOG/Ahl18UVHphmZ6791JEZE3F0Ut28LRTb5/vDjLSOkAUMotQUXUETs2rRZnTqyajzTdI2kyjYZTzOuThzWR5p7LLQ7BPNqpIGIFsQ0uCZUyK18f0KCIwHchNq/WW3syjF7NmEm8OQ6nj0YKdPOKXdJ6zqa3+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GYpljTN2pCcPINpcqlGfmUpaEIoxvX6i3qQatjj2Ab0=;
 b=UcNL47By9N1D/fNphHyqTlO5n12ElAmcwuOfa3mMm6naKzLoFBejfmIIEog7YsdcanZuH9r+kpBWwUWXGoJ/WwH+hK+Xl8f6EqAPRIiTb016r+LFsY9liACNbpMp7UERstoJCQwIu4Sscl3ZMN3cCuaCmvPbjMtZEnYl2UqrXB0=
Received: from CH0PR02MB8041.namprd02.prod.outlook.com (2603:10b6:610:106::10)
 by MW4PR02MB7267.namprd02.prod.outlook.com (2603:10b6:303:7b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.14; Fri, 28 Oct
 2022 09:27:11 +0000
Received: from CH0PR02MB8041.namprd02.prod.outlook.com
 ([fe80::b395:8309:2b05:cf2d]) by CH0PR02MB8041.namprd02.prod.outlook.com
 ([fe80::b395:8309:2b05:cf2d%4]) with mapi id 15.20.5769.014; Fri, 28 Oct 2022
 09:27:11 +0000
From:   Eiichi Tsukata <eiichi.tsukata@nutanix.com>
To:     seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, ankur.a.arora@oracle.com,
        dwmw@amazon.co.uk, joao.m.martins@oracle.com
Cc:     Eiichi Tsukata <eiichi.tsukata@nutanix.com>,
        syzbot+6f0c896c5a9449a10ded@syzkaller.appspotmail.com
Subject: [PATCH] KVM: x86/xen: Fix eventfd error handling in kvm_xen_eventfd_assign()
Date:   Fri, 28 Oct 2022 09:26:31 +0000
Message-Id: <20221028092631.117438-1-eiichi.tsukata@nutanix.com>
X-Mailer: git-send-email 2.27.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0065.namprd05.prod.outlook.com
 (2603:10b6:a03:74::42) To CH0PR02MB8041.namprd02.prod.outlook.com
 (2603:10b6:610:106::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR02MB8041:EE_|MW4PR02MB7267:EE_
X-MS-Office365-Filtering-Correlation-Id: 15347d81-0b29-41b5-328b-08dab8c69798
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Bl33eLYHwuW0SucduqrnILceZLLhS4qPu0XT4w9crUTt+XoaUhYwKdW9mC7SALcHDW1wGCZFVQ+lYV85CUAnXnaypYfuSOm1NqavYEgfkVpbS/vdfHuxIcpmI8LX5NZ3Y2expGJuk8haZmjd1cHK5J8oNgl3RyXHc/osFTWwlNZszs7QLNs/tBwErTMUcVxRXYJmJZ/M5aOa7SrT6F5fbPt2S/hhMSizS3rjVbZLbkb/Uw27e8k2TOkhR5f/+WPtTnNisFJ7OPO9+fI17JdidHGkhPzJy4JHnzXh88Uqb9fBE/EixiHeHb1ZDdKJ7vvYBBQ/pajal/duw52QxljuSEFV13oLvnRFnpXEjEUeYAA7Iok1+nC1hUcmc9Qb2M6OfQL5XmSwv1yIBI3F/kxtqqeuzYbCdR5+SA2EydVleZzcxbhPTHnnaJytkMB1aG64zUT1uwvf+i97AkFzCdbXqV/N1bgC8333jCwtyfjxIoxGBtLtCmPvz/QUbz98L3A2PT9ytW3XdwxweAbYSCTc68W40tk8e4EgDSBnULu7E4SFmXRk2woyt17WnWilFghvZYJhGSDmpVjeq/IfSg89docU0tWzf1w/v8YCcx1V1MuIo0zOmo3OXBe6yvuoq2EY+3JJkHhQxsYHZhqkldTSJ4M7er/ChG/z9wD3LpFDtHn7dgYUOmajJzkqtNf03yF0sgdQVSYaz81ZEjbtv961D9t4WLDYYbPzCFQz22qu2TcYHelIqFWNS5CETCnKyWONs785ECzWH2/gQtQ7HhUe2g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR02MB8041.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(376002)(346002)(136003)(366004)(451199015)(6666004)(316002)(66946007)(2616005)(5660300002)(66476007)(8936002)(4744005)(7416002)(1076003)(66556008)(44832011)(6506007)(52116002)(2906002)(36756003)(8676002)(4326008)(6512007)(26005)(86362001)(186003)(83380400001)(41300700001)(921005)(478600001)(38350700002)(38100700002)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3oeg52l09Cjy11enXI2LhMCL6ihJ428ImWDA5Muhl8iRxxxilcrTQew3sGUv?=
 =?us-ascii?Q?5QrcKljne1go5yVRK8H5IoBg/W5FwddjyxhtrcRh9CO44dBiakPgLZF4NzzO?=
 =?us-ascii?Q?knaXTZDAgVZv6ZYQp8oyydkB2yOaxXlecHdiGWxPxmdz17I01FHuSEDalt8I?=
 =?us-ascii?Q?82oivql3jxw8R1MB8sfYE0nGsODbbp7o1MVudWV6BayRcceky0OB5omVyT2B?=
 =?us-ascii?Q?bTAk2afd0X7cq4GdHVLExxuQCkq/j0cv/9CoH7dMoQBhVmKtXG6dStDnW2Cq?=
 =?us-ascii?Q?mjp2VmeU+o76OK06IIX7NbxE95hsI93h1EBogxBZOlwa2ud/N4MJioDGPK41?=
 =?us-ascii?Q?sG5jJF7Hu70KIZ82DdcBO+xkpKo/htUZF0NMZRWU/zFKmYt7rXD+wNKeHhA1?=
 =?us-ascii?Q?rEoRLQ1hvRHp33xqQXRPrwAFh4kE0fYFR+Y+5PZHY+2b5Qkj0WJEut8t1BwD?=
 =?us-ascii?Q?wWR4vke3QYrRu0apDPDB5M5v+g2EXExRWHa2miPnySacmaru8PuKeor5M0FW?=
 =?us-ascii?Q?Y/22LnVAVBI1a9QoWwK0dDXPoV30m8hGzXLEWRAV1Kh1HhEjY3uc0dQmefIG?=
 =?us-ascii?Q?QmAsOHQ370jvtBolMNMDne3Scypb+V5YaxDOMaPJ8PEfTfbhxlUatm4ELegv?=
 =?us-ascii?Q?8GSgBXoUQuFU6H2pC1YAPqeYjZqZGENCsgIcgvdBvDeTy+5MkzR1F8odH2Hv?=
 =?us-ascii?Q?oBiXdHGNA+zAjL9UXurtO2adh/nJ6eC5amdWxjj0y13hGFx6roeNimdX52Ka?=
 =?us-ascii?Q?mmkVKqOY2ZtQ9jAzEhJlMMB5ZtQNTBvc4206B912A1oSHseQocwnJENusxGo?=
 =?us-ascii?Q?NP2PycsguP1dI58oPgSO7EOdWP4QQIKsdUez4iJ/VSqzobpYJpKYREhlGFDo?=
 =?us-ascii?Q?10j1USQwO83dd8AOtWFdCTa6etTXxsThvAeDZSQEK6nnlEwMnzzaWsbq3iY+?=
 =?us-ascii?Q?q6VsTWCdA66lWHHnYeW0SQArcYeKknXFn137G8d/YnPIFDpYV2Io6zHyIlLI?=
 =?us-ascii?Q?3JoPuWsics9MonLPbbZKk0+OapSP4vDLrbQCHaM5Ae/N+lwRwzfPRgI95M60?=
 =?us-ascii?Q?kF4uFv/CimCYdAXT3xBdfMfI281TzNX11zF1o1XDbqof6/aHCzsD3un7/XB+?=
 =?us-ascii?Q?d9RIz7KxUMROR1S3BRjQnElHzIyT5ZX2gEftBuwB45u8SbJxTCgD44Z36MGe?=
 =?us-ascii?Q?vAcbGSxcoGRYpjxd/7prt7+O5f2oT3jdDWK8VHDPdMMhaPByAelrblQKC0HK?=
 =?us-ascii?Q?lhEgvfFap7ab88imgDhKCl1ZE4f6MPgowN/Zw7ehkSOPF2TVmsNwPtEvy/aI?=
 =?us-ascii?Q?wgOUaOyzIvrCE883VXAmCtQlJa55T6V8wYQBAJWZP4J9yJ5DXpHMunoRcAA0?=
 =?us-ascii?Q?1W53M7F5/m4zJ+99kjXiw1gMsTy6i/OKjN53CEGGAMvJxmyDejEu3CIPNl5o?=
 =?us-ascii?Q?CneSGzYBTvcAsyMuSVzrHT68ZwefVYx3NuKVzm/YPKhSsJXKlHVV/ei7q+mO?=
 =?us-ascii?Q?ixXhb/QfuzbLK5G0gRif2yhScGWpQd0XpcfrETKZ4RmWUWqrQeRjYvWV7sAL?=
 =?us-ascii?Q?Z6pAfOHHXnhlkdu67npq3lJczUwbYcvk8gGh6ZtcUTjWy8NJtT39Vkdd0oUe?=
 =?us-ascii?Q?hw=3D=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15347d81-0b29-41b5-328b-08dab8c69798
X-MS-Exchange-CrossTenant-AuthSource: CH0PR02MB8041.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2022 09:27:11.5526
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QwOjHUR78zBHfKraZ6fpOkWMI8/C3ntoqRIfMCaLgf0wS5uEEOcRddVUGoyRobYH5mQQBykF2AdXXkpJWO74EKir2sSg88V01EUVMM/Gr68=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR02MB7267
X-Proofpoint-GUID: GTGKS5jXsOrTzB5toHD_lPXjDZOCAPy2
X-Proofpoint-ORIG-GUID: GTGKS5jXsOrTzB5toHD_lPXjDZOCAPy2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-28_04,2022-10-27_01,2022-06-22_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Should not call eventfd_ctx_put() in case of error.

Fixes: 2fd6df2f2b47 ("KVM: x86/xen: intercept EVTCHNOP_send from guests")
Reported-by: syzbot+6f0c896c5a9449a10ded@syzkaller.appspotmail.com
Signed-off-by: Eiichi Tsukata <eiichi.tsukata@nutanix.com>
---
 arch/x86/kvm/xen.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 93c628d3e3a9..a357994982c6 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -1716,7 +1716,7 @@ static int kvm_xen_eventfd_assign(struct kvm *kvm,
 	if (ret == -ENOSPC)
 		ret = -EEXIST;
 out:
-	if (eventfd)
+	if (eventfd && !IS_ERR(eventfd))
 		eventfd_ctx_put(eventfd);
 	kfree(evtchnfd);
 	return ret;
-- 
2.37.3

