Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BB013CA8C1
	for <lists+kvm@lfdr.de>; Thu, 15 Jul 2021 21:01:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240462AbhGOTCq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jul 2021 15:02:46 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:20318 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239806AbhGOTBh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 15 Jul 2021 15:01:37 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16FIvdYV023995;
        Thu, 15 Jul 2021 18:58:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=Ub0xtJ367nvESEY3+rkbqU1cZxGopMYbISOx0+Rmm7E=;
 b=Lt8Z9Rn0a5mPdPvxyk+Zg6cPnndtPtTt7xiWSTfuDciI521xBXWTT4rc6x5tN+QXABbQ
 pqjZJGj5VegZjyhteNgLn6AOWM+5J2wk4nVN+nVnw6e339Q3pXG7qezqIVGS0G0qQOqK
 z5FGhsfIKdWGdqY9tGz94oJHJFrDd9mOzQAeUCgl3PITqjxNAjlvHL8W9BTr7BmCMTN4
 MuzEcEqm/sEpIKjb2XWs3FDKDQ5IzwcV4g7Yh1kWZXHHvk6b47R2RveNzHv2iPKRSyvp
 bl9mgo1RVAFXaSIYPfF2ifxggPMio9WhGUoh8O6rC37xBXraNO8I+CkJyqJaphrPx+86 vQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2020-01-29;
 bh=Ub0xtJ367nvESEY3+rkbqU1cZxGopMYbISOx0+Rmm7E=;
 b=Bqufh7YS7R2KyTu05hyPUonGNzR685zujpVZKKg5oDX+X2zP1yKPJCLkBzXFMb38OxhK
 Os1zm1v5RTOqx+hj1/oFbKOU7vl2+faqeOzgUq+EqbV9Ml7fSGpdvlN0lpa9eayl1MmV
 anIvddpUgFMvCywlptoSEJSpUoloSsBLbydhSDC5wSCDQjJpVyRtdeyJMgcBR+bC++tM
 1nZYJiwtW1FWadBU+cmRX1NiD24Ot0IhYipSdnwAdIs6+v1DMkVuQY6YX8TFgoBiSAe9
 Y5fC10svofbesZRxSw0JfUo8uh1Z7nbi8ylKhXCRKEkkOfZpxVm8tZiRajBcxRHTgttJ fQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 39suk8upeb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Jul 2021 18:58:19 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16FIsoui050707;
        Thu, 15 Jul 2021 18:58:18 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by aserp3020.oracle.com with ESMTP id 39q3cjc79b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Jul 2021 18:58:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DuMghwAWa+w00cHoAhHtFfNlmzPjPKTSQnd8akq4NmCLny2zO8dCvLzoVefKc5h2XpN3tlJ9EIGrrTli3c6FRfSvptibhs9821HH3ehZWIxHmOinYTOooLRRaS5tM/3wFFX6wO9jPMXPX7VVN5LrjpnIHxV5O/ypwnnyxdD0iaYSkA1rflBv0vKNig8a+UxWb0gsClARb26uKdDe56GE43Ujoik+rku3wxBKy7HZKl3fcIkl9wtBqtM8sxjpJXYXKaUPbTvywpWqqaEN+V1HS8G7j+bLQnhu5Ibi1cMXygwGBhZmRw8S2PJqaz2f3KgdpfwzUW3ET8npwNJpVp+yGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ub0xtJ367nvESEY3+rkbqU1cZxGopMYbISOx0+Rmm7E=;
 b=aMyFZ3fITLz225NSgELzl2Vf60UyDEyQ0l4xPTonYpnAisGaqGL//hD+vS3A+85z/2oo6a5YncPEH6fkcBBGv+QelNT8m5Pueah1lPnhVvjzI2YGzHDh/a9VdneB1NpkZS4jMcJhnZaHB+TlVPB3VNlYrWpdDUsxSyy6r+g+UIHCG078aS2SRYaKwfgev71z5uW3tSGtmhjSd4mNEeFWiP2yj5YhH/Q3065LrjYw7u3Sl9GM3a5FqniCt+VML46ViTDwu+aOwR/7XHkj/uTIGeSK1/UEZZZtDKrOjXYft2z7pilFMY+ReMAgugMFZO9GNkKoQZJ4x3tAvQQpWvUq3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ub0xtJ367nvESEY3+rkbqU1cZxGopMYbISOx0+Rmm7E=;
 b=VBigvyHa9gqa98ze9wPjyspb0z7GmjfoIvhD8ibKQTPXAnnIWuN2xvsWm2JmjW9g3yWkQhNthCrCUDf4DjqmAM7AbJ8HyFiFIuHrZ8iMdDtZ5Hcbhbg6OkmdqqgpgbSyzOhdfYzlE8zblafaIGji5OC2EcFkN9PcLe5YHpVJ2Ag=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SN6PR10MB2558.namprd10.prod.outlook.com (2603:10b6:805:48::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21; Thu, 15 Jul
 2021 18:58:16 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::f17c:44eb:d1be:2107]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::f17c:44eb:d1be:2107%7]) with mapi id 15.20.4308.027; Thu, 15 Jul 2021
 18:58:16 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, joro@8bytes.org
Subject: [PATCH 0/2] Test: nSVM: Test the effect of guest EFLAGS.TF on VMRUN
Date:   Thu, 15 Jul 2021 14:08:22 -0400
Message-Id: <20210715180824.234781-1-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.25.4
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SN7PR04CA0114.namprd04.prod.outlook.com
 (2603:10b6:806:122::29) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ban25x6uut29.us.oracle.com (138.3.201.29) by SN7PR04CA0114.namprd04.prod.outlook.com (2603:10b6:806:122::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.22 via Frontend Transport; Thu, 15 Jul 2021 18:58:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e968fcf5-334a-4ab7-c617-08d947c28113
X-MS-TrafficTypeDiagnostic: SN6PR10MB2558:
X-Microsoft-Antispam-PRVS: <SN6PR10MB2558871B7FEECB48EF64697C81129@SN6PR10MB2558.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EIcBPEddWIOqUhSuYzKMgCM/Y+Tb7fx5QvZJyL7gsfoN2zaHwsguB16XdN6w1BXDhkfaaULs+2ydu5Nv1Rxx6DpSky0oYUpQ2BYPTQdom87qf+XhNM+iSivIJ6MZRjxULhVGZB+dirK2HBhqkeowBUF2s9p6L46RVHMsTfXJ9LQtJIk7hp5FYxpcSw5sT59x7aNKEOU6g9oe78hKDw2F8sSZfeYnTAUEn7E0nsP+GetGK8VnNuN49l65tCLOnbS3W1ex7V1Fil8woS1ONfrp8N2BI455MJR/Ghv8fvD0833ZUE/UhX2y2+cJEMTL34F5cYnpi8cs9zgDI9KkQUa+ooBN8RuuOPtrVL4F2zKabfMqRzq1bfQRCBD+/DQkN33iJpPm20LmY/mxegJhzYU/qSPvXs0llkxYErwh6SKSoTOxFO31dU/lhxiiu0UOpZ5jkyRO0GiSu2FH/u7QzxkC510ioJ9eNwf285DXiUACgJeOM1SaZQKGZhA+1TpSlWUsafCYLVyDqgZU17sAS8bM6VLm2t3TWFCqSVUh8ZZkBykEI4U4RCGCMFNH+i+Bin7QGcbv51FxqvWutuL0OPZEJJ5cLTsIko4930y+WL3Ple9Ur66P3Wycig13U24eDS6P1ziJCQT8QHUlGZtivZXOG++YsuU30H0s2zIaeRuEBCTmdlUGfkgtxWLddUhaZTbF4gdenG6xMVgEOVnXzk7FBQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(39850400004)(396003)(376002)(136003)(38350700002)(2906002)(6666004)(86362001)(36756003)(38100700002)(1076003)(4326008)(83380400001)(8676002)(6486002)(4744005)(6916009)(186003)(478600001)(26005)(44832011)(8936002)(5660300002)(52116002)(7696005)(66946007)(66556008)(66476007)(956004)(2616005)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8SNbRdGbnLwUTa798WdPk+Oi1w1CAR/gb9L5o426C7ZPJGsCLh6olFIGHzCd?=
 =?us-ascii?Q?TxcZFdJqHd4FC77MpQSTwtNsdqCLH8uI7HkiqhH5XMabPQlzjoXlBuJXs+mX?=
 =?us-ascii?Q?u0bWLBfHg5u2aAFswJIkQjWQmCKuJokq+/8+7OLCkCK07pytJ2U3nPGxRIHV?=
 =?us-ascii?Q?4KQOMxx3i7U4PAODlVz3F9WfiiIX2gGFjtTSQqulcUggq38pe/YTFAYMyday?=
 =?us-ascii?Q?IuOm9Nge/4BS9CT+dMPbY1bXj7bz8t6cP59iY8vEXh5GsQCgTxM8zx8VTuDI?=
 =?us-ascii?Q?HoXuyGyonaOIiIsOUfzB7M4yEjmRctK7U0dNEmgPam2afUau8QMxRb34/TUT?=
 =?us-ascii?Q?LVZKmWorHjcZE7jULlnxoBIj3hPOqLlW38oGCRxkLJaTcofSaH7T5X45/yX7?=
 =?us-ascii?Q?IJRVYT0/a6l3IJMYcSk87hzJTWMyolV/FlfwllBvqfoAXIZ3WQ8g4M6wog0W?=
 =?us-ascii?Q?qvTVbxMguzU8t3/qBQov/G38qhCPNVorB9mdQXaEsHs8EuZs7c4ZFjIJu0Ay?=
 =?us-ascii?Q?TEH4MDR92kmMFox0khLweOyjSo6G1MjsDkNC8yCpuha6mDBfZoiCPlAmwCNe?=
 =?us-ascii?Q?tZ0514Tdag4n0as42gBBS13GkO3p/Y0WgYWFBgfc/pXiKdSkhylRsOFENZeu?=
 =?us-ascii?Q?m4uRxc9djniUK09wbMlijnJejA3QrlYN0RTA4iJDzhufHlhs9y9wnBvQbLpI?=
 =?us-ascii?Q?BL/tRnYyfK9HhLRQxjgzGgsnLYbGOtoFErZD4wLXwcgoIcjfKJANh72SifSg?=
 =?us-ascii?Q?iOSR5nfFFNEiStcyAXwvRLka22zgOTX2OrHeDk8l4SQ0+TW0VfPtxsxOZ4hO?=
 =?us-ascii?Q?5C8jgHoqDQS/xQ07EdVCuaEZnNZZlsyKzBiq0j54w7mF7JOjYYUM5kRInH1n?=
 =?us-ascii?Q?4QQTIgcZQVH2w12dS7s2p5TG9OdB1cL/yOPwvSrg2RgrGmsouU3O5y9LxLCt?=
 =?us-ascii?Q?tsuFTk7uob5note/WtRn7wHcH29yi7y+BCySMLiP87QyWYtRjIgJMdh4lYk+?=
 =?us-ascii?Q?ZSy/Mn+yO2He0ewTo2gIyagQ6m/OcW/uSQhdijDkmRpPm8+WYl7DCXKCpxym?=
 =?us-ascii?Q?ArB/mkRBRaexSx36K5vcY7wGi/HmmPMzRWquId/vN9edEeGjVoSSq35OcrzL?=
 =?us-ascii?Q?4e+TOekf4aZe8kTz9GePNGIBtN3sr0vqyE9teCnWaVHB29ybhSzMRwXguyzI?=
 =?us-ascii?Q?zP6kqhl7+yNit6LG6K9SIXbKpIKc8UNnRQ6keQYtJh9DStQzUO5Pqs/4f7nW?=
 =?us-ascii?Q?sVC0825Lqp/SrKXvPg3tL7JJYMJVpRibLrSdnENH68wecC9q37vNgWcCT+Ly?=
 =?us-ascii?Q?LTUCxP5HuLCW3uiXsdblfu54?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e968fcf5-334a-4ab7-c617-08d947c28113
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2021 18:58:16.6388
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Pxui1WA220A0KchITUCSbftyYWXKGOXbthgVPLUi7njRbSjD3wc8pG4vq7WevbZfvowaY9eFIQqcigLP12mebO3+unDLvVI4p5ty8VQfADA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2558
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10046 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 suspectscore=0 phishscore=0 adultscore=0 mlxlogscore=739 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107150129
X-Proofpoint-ORIG-GUID: Q_Mf7I9lC2nTe7RMtVZ6Uog1IYUkp66V
X-Proofpoint-GUID: Q_Mf7I9lC2nTe7RMtVZ6Uog1IYUkp66V
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Patch# 1: Adds a variant of svm_vmrun() so that custom guest code can be used.
Patch# 2: Tests the effects of guest EFLAGS.TF on VMRUN.

[PATCH 1/2] nSVM: Add a variant of svm_vmrun() for executing custom
[PATCH 2/2] Test: nSVM: Test the effect of guest EFLAGS.TF on VMRUN

 x86/svm.c       | 14 ++++++++++++--
 x86/svm.h       |  1 +
 x86/svm_tests.c | 61 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 74 insertions(+), 2 deletions(-)

Krish Sadhukhan (2):
      nSVM: Add a variant of svm_vmrun() for executing custom guest code
      Test: nSVM: Test the effect of guest EFLAGS.TF on VMRUN

