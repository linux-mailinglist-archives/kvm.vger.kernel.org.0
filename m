Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22F6A38F7D5
	for <lists+kvm@lfdr.de>; Tue, 25 May 2021 04:03:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230010AbhEYCEh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 22:04:37 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:49722 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbhEYCEf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 May 2021 22:04:35 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14P1x5OZ075542;
        Tue, 25 May 2021 02:02:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2020-01-29;
 bh=wVCGWWQI3tFBcopScLzNO/jcH8LJz4DppMqM8cM9sHk=;
 b=SAcF3alheFd5F6f2Y2vdAo1oWwM2JIB50MnYgvd4O6MxfrkGykxSVyerNrHjlB/yqJ9g
 OLaVLU0eU+eUX5bFvMKWgJVUAE4QFDcQILzGTb7gL7RthsCqvqqMWGE91/ztHdWh+w10
 io66d1K9o/BpJeaUz8XFOBRMYvjl3itiHhyqZHuiBjUgzfzzy7psTDzIaB+gUrg8rETJ
 dxG1PQYRWFI3K49fodrx5xL3KmgzLZh3SoB8kZaIN7oPi+uGVM6CLCzdxwjsr+m8rKGe
 A3iOrXjnYZTHyXcrx4IseNIr6p+rr/NaYBgZZAXhv1mXJefYJTcNh0LtknGwYOVQG5CD bA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 38rne4060n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 May 2021 02:02:02 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14P1u9MV023231;
        Tue, 25 May 2021 02:02:02 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2103.outbound.protection.outlook.com [104.47.70.103])
        by userp3020.oracle.com with ESMTP id 38qbqrryu5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 May 2021 02:02:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GLjzK/kiG1/mWGpfKf8KQWELqAblrLeMLS8r8Fj0D34ja4/mMagamlFS5fEWfMOwo4bnT6reMKCJqyYd8Sel+MJrpJYX7bfmzLcJJg/quTaao+dwUZHzLJaruRZd1GgEs6ntsZnjJTkw8koBSAHSZ8tBQ0Btd7ppfs8xOoScnPWnj/fJ+9Zzkn6mUyBr5po9OXXoTIZXE8NfeeraePFtrlc+fSL8n/sEwDhMMw62RvAlpfKe7V8l/i+9wK6r7kN9FG1VX5OGAAeAUI5Wxw/TxYW36c1Ap5h2z3srYTqV62PXMbDnbg0YdgMs3kwcZ4GZKxtyrtJXbNF+prSRkNOdeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wVCGWWQI3tFBcopScLzNO/jcH8LJz4DppMqM8cM9sHk=;
 b=KNsOgEh5ogwWeo6CROFBr2REZnUD3j3WyIfmRZh1jkuUJ4gyUwtpnF9klif5x/kkLcwikcYAei2bw69DtOou4KPhcUwg/P+57JnlvQGC70kaFT2grdDiqERTnqy3Wczmu/ykyKEAols6jS7OaZP7syaDaxFeoyXrn5B8uoRugXR/90D7/ciQEc0hgL4DK4igGTmDtq8azxkRG7eNVAYeXnM/H6VS6EToteTNyHUJ/2P5RGaRUb0w6OV7PHFyv9Rc6Dx1E5uErYSy4JLvZMLlxJu0UGLm68ncMRXvDfcUWX85eiJyGi7RrzC3vTVn9Oj1LSc9dJJPIpI2Zy6QuNb27Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wVCGWWQI3tFBcopScLzNO/jcH8LJz4DppMqM8cM9sHk=;
 b=iyLheeUzKQVGBPKZNb4B4IvzLSSX49utwuLus8xT5VrDb54aVOH39b0xmIrUea83qLZ4KuTkEzr8vwqrXIkmaTvb87GPn5RCtKVqP5NPXP3MLxmXK+q0bbK4/0N7jYAfv40J3ovgLkAw8FL3l1AaSJ+OQLrpjPzMDcW/UUeWebU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SA2PR10MB4506.namprd10.prod.outlook.com (2603:10b6:806:111::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23; Tue, 25 May
 2021 02:02:00 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::5911:9489:e05c:2d44]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::5911:9489:e05c:2d44%5]) with mapi id 15.20.4129.033; Tue, 25 May 2021
 02:02:00 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, joro@8bytes.org
Subject: [PATCH v2] nSVM: Test: Test VMRUN/VMEXIT's canonicalization of segement base addresses 
Date:   Mon, 24 May 2021 21:12:40 -0400
Message-Id: <20210525011241.77168-1-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.25.4
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [138.3.201.29]
X-ClientProxiedBy: SA9PR11CA0003.namprd11.prod.outlook.com
 (2603:10b6:806:6e::8) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ban25x6uut29.us.oracle.com (138.3.201.29) by SA9PR11CA0003.namprd11.prod.outlook.com (2603:10b6:806:6e::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.26 via Frontend Transport; Tue, 25 May 2021 02:01:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8421e777-4b1d-4650-7b6d-08d91f21150c
X-MS-TrafficTypeDiagnostic: SA2PR10MB4506:
X-Microsoft-Antispam-PRVS: <SA2PR10MB45061168E81897458D3D540481259@SA2PR10MB4506.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kHiEViKOYgSijfaPS9b6E++m1Krlga2QeaamnVFk4+MnzvxkuynAbUD2WbYonRvT9vCvKDIFJUo6qNphBbYTIg73IThXsSMT560NXZ5wesK9XI31DJx2Rw34oVXwiO69yyn6dZkCX/SACN4wx9Mov7cQGMuNGt2QLIW/BZyRN762Pw9JPzxTWMulX7u3Lf3Gu8Fet7pxWBF+okbAHTNhkLRS9f0fyYJW+6gj11tdMfhl16QVPdBqOPAjyU48OLUKMLzQfHVJAUWLGvHBvAgi8kWxW3BTMHntqqFFaG3eE4NO3CB2ovuYTRYJxzy3e05Huv79FX81M7mKHmd18tNPfM4onnq9b/dSyqWIvE8hL4WDceyF6XTDrirp17RgBkiWqgN15HwQbVUtsbP/Q7ZVmy4u+MoffB2pzIY3rC7auR7ODqiDyTxTQ0wWUhsX8vSuIoYY/eLsH74WqgEFl5mfdRnqodWAK1qPoPQjPS1vqEoLXzck+Av2bxnTKLFx4CNyDXDzsCskzW+1nAvJL10UZ3o/xwfkxhv2IvdpHY0/tkCsShQpy6CJy86c/kwi+GAwtlI9nwmdTPk5V/QCKvsgMwZ6n4Oqdc4tIJijGktFHRR/8dTIBu7giafxoOr0ocHcDIc0noix/ytD9X6D8VokXQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(136003)(376002)(346002)(366004)(66476007)(66556008)(2906002)(6916009)(38350700002)(38100700002)(6666004)(4744005)(5660300002)(16526019)(4326008)(86362001)(7696005)(66946007)(52116002)(44832011)(8676002)(1076003)(4743002)(316002)(186003)(956004)(6486002)(478600001)(8936002)(26005)(36756003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?JV13lUkOEFHTxuieW7erCTzSFmbI56SO528qJ58vLt7gyuymab6F39zGM2fl?=
 =?us-ascii?Q?XPjJGWd22AFzLvpovQIiBaj8eueBqPUj2wuRyqhEqUZkMxZSHZG22VXsYH+e?=
 =?us-ascii?Q?JMn6a9XB0Htv76lxNZdvPWh2irTXAdYfm7TgoOZFCk9icOS3Bm9s4/JBQ+sB?=
 =?us-ascii?Q?YZ76pAXktIQENfWGVcWC0aZ3uZ3PottM4YKktmbil1VEssOoyjoGbyIwSKGf?=
 =?us-ascii?Q?HSWUj0gvxslX1QV1Zo4oSGVySbr9++5j2KPl5a/ToXn2YHA3A3BAS5l5+LGE?=
 =?us-ascii?Q?pKO1Kuwbq46Tz1vb9LD6jv06rL1ta1TsqEWlgzI3V41fEEyeDwAO2XswbChQ?=
 =?us-ascii?Q?cd37+66Ki3+OKrqC1RLEfJjZ+KKm0+nu1ttXnptCx7taj2CjLzE3kK52glbD?=
 =?us-ascii?Q?2ksGfwnnbFKg5PtTvtLEGZAi7MeOLJvqskn+kumZrgHf8HMurM/hXqAweEqZ?=
 =?us-ascii?Q?tJ3IASwCqa4BZncB3ie5ZMUdYmVf4HpuugM4ozRxqNIrnuMrX4t7s+Rif8kl?=
 =?us-ascii?Q?/uIRpNwghstALub3u4E6vgXQtTSmIb5yvTm2mdezrS7pds++ur+uW29qNUKx?=
 =?us-ascii?Q?lEmePtOIGUQn5TVIfEDiy6ELk8jnHTPxrQ4JesCZW5eSXRB2aijQ8TLx+F6w?=
 =?us-ascii?Q?j5+r7bO45dRWsV3xgsM4BagtwhSdGmuJ6uGZfE9cCeTPOSPeHkaoCLd/muiy?=
 =?us-ascii?Q?iBPr7mS+W5JPywp+0WulcAzAFHza9NtRpeMlXj68jXc3V5D4t1uetlj26S4x?=
 =?us-ascii?Q?RIDwvSxyRz0fDkQE7nxJpRUHC+ssQ5iu4itJYOapWSPOWDtKh2PmZyKaAzW4?=
 =?us-ascii?Q?wblmQfFeoB+c1PyrAaIIVjsDwP1+sO6YGXqkI2ZMeqKl/MJR7ziDPwwHeNfX?=
 =?us-ascii?Q?1ImCbBRfkg5iO9bEzeaGZ+Qrxg5EJ+YXs/ljCvgDfSjSb24xik+7uoJfVgeJ?=
 =?us-ascii?Q?aTlodTKMw+eyWFQP7dqQZtw/RsMZccCZ0cEqa4MXpQngfD3dLGM5h241X4YV?=
 =?us-ascii?Q?DwZoXm92yMNrQwY9mmcgi5B9vbdCyA4NWJV9Krzd/cLlfeYyCMnaiBTSSkRh?=
 =?us-ascii?Q?caPf7z4RGpQNjS6Y0uhkeWL/+ikREkZp3Uz5hhOSlHcB0LhZM44UkoEomXW7?=
 =?us-ascii?Q?Er1nnclFwz+QXl1Xu4YKxdb/o42AFLgYI0F+nnPDHynRMxx3LvGL6aMa2+NV?=
 =?us-ascii?Q?IU6m85AChdrdWOT+6JiZji1vWAuucnPDeeW6nH+INSOuowcB4g9+HUk4VnyF?=
 =?us-ascii?Q?SEX87A8K8b/h3TMYZft66RcQTFtMmODBCxH9YReEi1oBfBKZ8oUSl0mliOSf?=
 =?us-ascii?Q?tkyoUYLKQNxftC88YDd3ma8T?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8421e777-4b1d-4650-7b6d-08d91f21150c
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2021 02:02:00.0505
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GuAmChppt3Os/GWiGdIgLAG60XQkPAwsDXAhFagpcbbOp33/X4GhgiOw2ubKF6Ue8hTqSSjebA4fm5/T0oNE3pVO0TUpAuzrpfvNoUNHSUY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4506
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9994 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 mlxlogscore=910 malwarescore=0 spamscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105250011
X-Proofpoint-ORIG-GUID: uqUUvvHKCiC4s2jpXiDQ8UnPwXBGcUOr
X-Proofpoint-GUID: uqUUvvHKCiC4s2jpXiDQ8UnPwXBGcUOr
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9994 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 mlxscore=0 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 adultscore=0 clxscore=1015
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105250011
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v1 -> v2:
	* Instead of rendering bits 63:48 non-canonical, the entire base
	  address of the segment registers is now rendered non-canonical
	  for the purpose of the test.
	* Experiment shows that only FS, GS, LDTR and TR registers are
	  canonicalized by VMRUN/VMEXIT. Tests have been adjusted
	  accordingly.

[PATCH v2] nSVM: Test: Test VMRUN/VMEXIT's canonicalization of segement base addresses

 x86/svm_tests.c | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

Krish Sadhukhan (1):
      nSVM: Test VMRUN's canonicalization of segement base addresses

