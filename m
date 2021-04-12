Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72EAD35D360
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 00:47:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343831AbhDLWp1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Apr 2021 18:45:27 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:51626 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238085AbhDLWp0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Apr 2021 18:45:26 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13CMe6Qi178913;
        Mon, 12 Apr 2021 22:45:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=ewWFL80mcKx7aXij0/rdj6JYFuSJ8G9GgQlNh9FiUe0=;
 b=ivRGa1gTrZo5ra/69t0NI1miRZcvJKofFHbVhmtD95XvBjlRbvJfzj5LLwSqtp5X2Sbh
 Rs4I5hWulEwf2INGYGfKOPmMBKUtfBDvOGDApA1xSQU2IOIX0BsIZ43x3C4gpOe2s9pz
 1NjnAB3BXEheQRnfO7JzyO4yRHlqp3FkH0RR88qm+wnXOGFqOMPtpgRriATvnUzgVHAh
 BtPkcmgmV+Aht6ZKLI0kMzy1IDjJDsD+KQrwIxX8MnLTUVOploHdaZH/20SMSVkdnc22
 mELc6q5oEy+FAPZXwLz/Ao1NxZ+VC+hET05DBe+MsSFpujeC/APBwV8OoJegxY7yGCiM 5w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 37u4nnd9nh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Apr 2021 22:45:04 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13CMdc4H167396;
        Mon, 12 Apr 2021 22:45:03 GMT
Received: from nam04-co1-obe.outbound.protection.outlook.com (mail-co1nam04lp2057.outbound.protection.outlook.com [104.47.45.57])
        by aserp3020.oracle.com with ESMTP id 37unwxy5sq-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Apr 2021 22:45:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HMnMf8BHZ6S6Gvo8fvS0k19iexsAUwwfWX7W3gtOh8WgcVXsTj3Kzm07P02wAapkndQs0vnl06/1jJml/TqA4TtrWn0OVoqTVJGd09bKujZY+uhbdaHX06QQiSLCPQIdn0WhBGbfAzZvpbc/1BmUakztrXRWUgPg7BD2WSOv03TIsZYOXFm3gg2TWDT7x0dq3cJGUL8pRTAhXeTpbGeRm5Pld/yMlKho0yydgKivSAfeR2AIpPrwOIHgbrCQggpojarK3qvolDj5r96vX9c26uMKMfU788iuo4DoF6AOpWqH6xQ19/tfPrf/2I2Ya3NFcU+9aVz3yb9PNTr71dZRBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ewWFL80mcKx7aXij0/rdj6JYFuSJ8G9GgQlNh9FiUe0=;
 b=AjO+uNcRXY/ezn+/w+ILHhTYpDHCRrpS6zg2yUQpzCCB6ACo2cZ8e2sDUtEOauHVSYfiUMITSHBcnS++fPiYk2JmaT40Ig2yeOO6c8wyklN2saTybOs1qwmiTF03Mn0O+DtTHzgSMQLlQFZSCSyj1spOznUhwOUWKAUBEBLO6GeoPv3TL6ZazTs/8iZiuU1I1Ee3v8lCLSOn4jz/T1GDRHeUPPJuS5Wch7gnvFN3lBjug7U1GVYZPeGz2Bo5EwBO/Y9GwSX6li2PdI64/j1PSruhofian+idzFkN5M90Shsu5ZGGWIRfrlUdp2Tzj+xTBcEc14nfo2VLOp1Z8AJudg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ewWFL80mcKx7aXij0/rdj6JYFuSJ8G9GgQlNh9FiUe0=;
 b=lUPokUWWBbon854m/Q8hDGPUqCQQDVf0CIrhdjTBjWMLgHklTa0sjIzhaDUPmzxdjeQabfEI/akioWhIr2ZrKVs62zrC8lRMJ2bmGEaL477Xn4UeXtRwpHes+oBvg27ULUlhorzwezVZUyUPn7aPZ1vV8e3DRSZ7xfucQZEl8dE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SN6PR10MB3088.namprd10.prod.outlook.com (2603:10b6:805:d3::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.22; Mon, 12 Apr
 2021 22:45:02 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::5911:9489:e05c:2d44]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::5911:9489:e05c:2d44%5]) with mapi id 15.20.4020.022; Mon, 12 Apr 2021
 22:45:02 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com
Subject: [PATCH 3/7 v7] KVM: nSVM: No need to set bits 11:0 in MSRPM and IOPM bitmaps
Date:   Mon, 12 Apr 2021 17:56:07 -0400
Message-Id: <20210412215611.110095-4-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20210412215611.110095-1-krish.sadhukhan@oracle.com>
References: <20210412215611.110095-1-krish.sadhukhan@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [138.3.201.29]
X-ClientProxiedBy: BYAPR06CA0058.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::35) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ban25x6uut29.us.oracle.com (138.3.201.29) by BYAPR06CA0058.namprd06.prod.outlook.com (2603:10b6:a03:14b::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend Transport; Mon, 12 Apr 2021 22:45:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8e3fa259-4767-47ed-7bf9-08d8fe049ba8
X-MS-TrafficTypeDiagnostic: SN6PR10MB3088:
X-Microsoft-Antispam-PRVS: <SN6PR10MB308817E4BE7C4478231FB3EF81709@SN6PR10MB3088.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jsTiwABmYcS82zxLI/YdGbUm18cUX+us/gXQkr9dPrVad9Tvj1fsnORRbDmVSKsffwmRTtcxu1ppv8Zva/FrtPe1jWbKMQxHrLvEAnGV/qmqtJ/VwRgYQmr3fNOgBg4yNYHjnaGY8NjU1KIVfQGphUZ4BlyUT4gOeURLxWtVSG5aNyj1RVelmZiUefQVUWHOC5Tn3eo7N75iqLtUsVCvKbnVBNQBb9tvCTvpkXwTC1zvBJhpqqPBoPg0u9VdCGPOq+UUl+zmfJ+C70FHr4C9wEUIJSB6k756+ZVWa/yFRuVNM/XgPdu8pOpBrUylWhglH82lxiE0ZpHPM/tDWy245ejHfZWM+eCfAJPA+2AYuO0eTZ1mXgwyoaFsBdru7n27/FE4AHlYmnXz01DJI14pFQzepktnJSO9kMJLuHrZ6A1GdPnk80YKUyEWxf3RRVUshjXOVL9iwWf1YbDru5RPMazwRUncZPBiKkipUrEhXeR6Xto4TdiJYY6gaT6tkOpGrsCdcRtoEOhLdm09w9p5J9CBpPWxsLQbHAs4yFW94JZwRhZU27wIDOjZNMZcxePGLGAy9LprKaqM/PQYQXg/FT/dGXzpui+L6HveKEIL/Ok9EpX92fTVtArCfNK7pObjK41gHAis5pWYcOX1NOKZ5Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(366004)(376002)(39860400002)(396003)(4744005)(83380400001)(86362001)(2906002)(956004)(316002)(1076003)(2616005)(478600001)(4326008)(8676002)(7696005)(36756003)(6486002)(52116002)(26005)(5660300002)(186003)(16526019)(44832011)(66946007)(66556008)(38100700002)(6916009)(38350700002)(8936002)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?zzqhdPkCR9P9CogZlmM7iekU8uCBz2tJUJQNgsWi4UclpN3ZaKD2VhW/bS1O?=
 =?us-ascii?Q?+EYsVhrhVLmWP2Bh6uOgXwwTZY/pgL16Kh0ML8AHyWNGZa7EZPEMFFknQh2a?=
 =?us-ascii?Q?VENZVISrMN0CNKriPJKQfD26szGTAIErEmKtIzsrcVWH/KXVn4XUQMq3pS4O?=
 =?us-ascii?Q?NQQGHIDf4+FbIW3ggO7k6XJGBKdgqTBs37H1CSqZBWQnQaZDADSLS2nx915n?=
 =?us-ascii?Q?ptO3vS/TxYHeASuaCAfHH+9ELpqf+hh2fKkssfGBROPplpx/nDur4DY79xAK?=
 =?us-ascii?Q?ntaGM6RtqIUpHZ27E5Y/07yhhfxWE/1vAugqoAveLDvBUC8lA9Z1X/FDL4KO?=
 =?us-ascii?Q?ZR11GeW7KoRE4wHHEtEJrMyv6r8D7D+VH5nz9CuKk6EsN/27TXSqSNx3aWXn?=
 =?us-ascii?Q?A/dFO1LtO7mW8X6uXuiW/1Yr/hMtRqJ56mm7hP8f+jKfz5WDee7PPs23WxDM?=
 =?us-ascii?Q?FSHvxpdm/flO2wveqbkT5EaqG10wa9oWWavb9zAqj0ny0tXrUmYszFhpnHxz?=
 =?us-ascii?Q?6XPUWBB5ix8HdQJs0y7azgD1qRcFq/R4sEid0/mx2LQ7lMpv1kyRmCv0B7Cg?=
 =?us-ascii?Q?M//pXZbME+PUdja8E1sD+hSDHutnJBa2CqY55YX+x5LdNsH2R5tvdBnTAg7m?=
 =?us-ascii?Q?KM66BuDof9gLzadsoxI1hM0IpFheR4ssMbZ7NYXjsBCkAS5RS0a063oWygrr?=
 =?us-ascii?Q?9G9pgazxskSA7FkV0OZQbFADKaK1rniw84se9zcITwHOCbVLw77I2+/tFyox?=
 =?us-ascii?Q?EGvS/9azElhJxC7hHnHHf9BCDCB3Hu9pjDlkT2frSSZ9GaPYSF/dBnWbABqr?=
 =?us-ascii?Q?RasMEwiQBsZj+DBf1ik3ibTMPRbCzPcE6EgYLtBDMBBNdvK/zzXwnslKbgwr?=
 =?us-ascii?Q?j5U8h1CrWEM1FgPnTw4Sh/lgvYUCWl2TYAD7IUXMq0m/q6HM4xc1/CO9RNhx?=
 =?us-ascii?Q?MOliqOxxv9Wyn915DG8uhmx9ZY1hC1nd056B9z9Am89RpuIwpPktDyp4Bv59?=
 =?us-ascii?Q?/sje1ULXL3sxbtPp5pA65tRAU4TPine3Fzd247qANTWysD1ByvwlYkUaQYBt?=
 =?us-ascii?Q?vkNsbUcrWKtCaovj/0R+XC9lnGTRvO48mH6lP6XkPtgbDIEXqYdiWiUVnv6n?=
 =?us-ascii?Q?OydV70mPmIJD8kCqnNuh9bDANr7Bd62dnHPK7J+hebMCAwwdqFDJ9r5OnDEt?=
 =?us-ascii?Q?82LTPbxMmP1+Mh1aRuyEtD/bIY318jQSCt4pxzBt6o0bSyKpyfQqANWNMqxh?=
 =?us-ascii?Q?TCpWkdVWgavdhQwTyjrxar1sgHHB+3TQc6zh/uNbc/YZ0NV3Ks+93wE7/s7z?=
 =?us-ascii?Q?l2x89brsE2qHauI9MNF0jrpG?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e3fa259-4767-47ed-7bf9-08d8fe049ba8
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2021 22:45:01.9748
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r9pjQAXAA5CSQp6s/IOVOSkBw55FgZRwWU/yP+XTPiL41iWaRmARe14uEgA2M2uZwapHyoH2cFNKcQlx1Z/hbDAIIzk0otevNGk4rhlEnsA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB3088
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9952 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 malwarescore=0 adultscore=0 bulkscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104120146
X-Proofpoint-ORIG-GUID: N3Z4gKpwgZvhL5FXxemnPXmo0tyQL7kg
X-Proofpoint-GUID: N3Z4gKpwgZvhL5FXxemnPXmo0tyQL7kg
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9952 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 priorityscore=1501
 clxscore=1015 lowpriorityscore=0 spamscore=0 impostorscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104120146
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to APM vol 2, hardware ignores the low 12 bits in MSRPM and IOPM
bitmaps. Therefore setting/unssetting these bits has no effect as far as
VMRUN is concerned. Also, setting/unsetting these bits prevents tests from
verifying hardware behavior.

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 arch/x86/kvm/svm/nested.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index ae53ae46ebca..fd42c8b7f99a 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -287,8 +287,6 @@ static void nested_load_control_from_vmcb12(struct vcpu_svm *svm,
 
 	/* Copy it here because nested_svm_check_controls will check it.  */
 	svm->nested.ctl.asid           = control->asid;
-	svm->nested.ctl.msrpm_base_pa &= ~0x0fffULL;
-	svm->nested.ctl.iopm_base_pa  &= ~0x0fffULL;
 }
 
 /*
-- 
2.27.0

