Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C2E43480B8
	for <lists+kvm@lfdr.de>; Wed, 24 Mar 2021 19:39:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237640AbhCXSjA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Mar 2021 14:39:00 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:37662 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237684AbhCXSir (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Mar 2021 14:38:47 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12OIOjol126595;
        Wed, 24 Mar 2021 18:38:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2020-01-29;
 bh=IMo7Fgw3qtmXAke320CyNWFw1aEuO2sYuhH1FVznZIc=;
 b=F0c2uKnj6ahefp3HrLPvDyrFMUbkpFlx21EEgZES5H63+cJDsIaPaEtr+MkPR6eF6wpL
 kQS9LHiGxVsp3Xohtms8QdNmsI91wiFv1Y+EB6ERb4neVQoTjqAeHDx9cp8q1U1+IR4O
 hJ5CWMF/zJNWeM7jedlER6uZkndrk8f4vgL8L1woSXREhqTa/PIocwfMZH46Pr9V85Ep
 FxMfjuOo+K4czDl2nHn6ijYEwHR515PaT6fjOH21sanRKsLDO7h9Qah3Ft3L3rJk10CG
 L0Ly0EV0HVpNzWlyDvaC4H7jIoE8gxI2MXVskQm+lK2wzp+h/Uf1mil0UsNwVrpOGoXt cg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 37d8frbukq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Mar 2021 18:38:43 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12OIQFYI167607;
        Wed, 24 Mar 2021 18:38:43 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
        by userp3020.oracle.com with ESMTP id 37dtttpj5x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Mar 2021 18:38:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IAvFRg7y3HPo9KORdWONSSPsTg12xf9XNGN8detSNNz5eE1VSmexDsVhyt6o4aa1uFiLRCeYz3XhvugqWjziwbyV/aMbQjjuyvpMD8Z4/+pCaLbnUVte+lX3/8sQtP5OBiZUvecAjI41BO61vCIRkYr5hstYORYKa2uY3a81cYN3YRgFvMKCdqzD5z5ClQee8PzZw0Z6YjzQjI3/30EQ/pso9W+LHhcP5bfZLcgkyqsZ6e/o7FjAGPsMPm3zCAoBIE/kqTev0Zdn+yfBDWj9wcDXN5VYYMakyskhG6ZI9KXTOTQ3T7MV959xMLkhEo+alnXUri0eswnEzAY7KXD2ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IMo7Fgw3qtmXAke320CyNWFw1aEuO2sYuhH1FVznZIc=;
 b=VAGfA1CRtFVflibQQIRvrOuFNIxl2je5vXxfclLEHBHk98vhBu6m8FV13HxTOiZFDB7VTG2s/4zX33HNIWl51GxUzmAaTJzvYfzOVQ8GPRsx7L0b4h+ICxc2CP+d9UGyFEEnt3g0GKCku8lge3pnYhCvz+YkO+giyIF+88M2qyHNdwWojbvLCXbRnmblZE/lFL2w33Fg/HWg/yXC8cddRRYUOAq2cfRosqZ+BsbYd9256CU51TGUmk0fU8HohA+AeiwdRZTu1EGlpOHzlZetB7BTTfB1+FvP7xPDWRJoJ/3TvMixrzS49c7vWLuDmw6GbZFuJkudqfF0LPuKw3PfaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IMo7Fgw3qtmXAke320CyNWFw1aEuO2sYuhH1FVznZIc=;
 b=p/rZHEpPBl2aRcSFvsx6ywQusFqYVkqVSFmKOwSiGKaW0P5KY6Pxjyx0t5hoi9WGCbp0GeQGpYMZP4Czirv09nbdLoeVaSdQBstHV2xMGA4wcl2tleD1Kov8W0ywhn1Zak7h2nZPL3uH8148osyw9EfE7SVZIvH7N6HS3IKCxHA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SA2PR10MB4665.namprd10.prod.outlook.com (2603:10b6:806:fb::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Wed, 24 Mar
 2021 18:38:41 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::1871:3741:cc17:bcf7]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::1871:3741:cc17:bcf7%7]) with mapi id 15.20.3955.025; Wed, 24 Mar 2021
 18:38:40 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com
Subject: [PATCH 0/5 v4] KVM: nSVM: Check addresses of MSR bitmap and IO bitmap tables on vmrun of nested guests
Date:   Wed, 24 Mar 2021 13:50:01 -0400
Message-Id: <20210324175006.75054-1-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.25.4
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [138.3.201.29]
X-ClientProxiedBy: BYAPR05CA0009.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::22) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ban25x6uut29.us.oracle.com (138.3.201.29) by BYAPR05CA0009.namprd05.prod.outlook.com (2603:10b6:a03:c0::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.10 via Frontend Transport; Wed, 24 Mar 2021 18:38:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ddb6df48-9078-4676-a4dc-08d8eef40ba1
X-MS-TrafficTypeDiagnostic: SA2PR10MB4665:
X-Microsoft-Antispam-PRVS: <SA2PR10MB46657F659BA43E42C6C0141981639@SA2PR10MB4665.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2s5Xd20oAqiQuq4Dgtaq2HgfzEQTjcReKVoI+LGyZb5UmuZlXxFssmOVR5OgH/yRx8i1GM0lIuSxZt8oB9A0OlwDdN8/SsHSj3qZb3F2BdfC8sVPJxrqRL3ujX7MFFcqdop9MUciIsxXB92KysLao/l7I+8DH+ArYF6PsUK3ToAxvCV/C+8H7/TX+9O++aLaaefpKPNe3l4XixLtV9XZx1I2PRO6l6GEk/ky7ZDBlBNoYUcZp8/7RmDAV3gE7kDeYrpdhj9anRr1h0wdenGc4qmAbBAIkuaM+pb3/1AIeq7xI9UtGQM+rFBa4fOQxk7cl71UC1Dc56lWJ1k2gWqHwi+bkN1yN5/OPMknJxfnhHTnIhbOgZ/cVBnN6sdxWIXoH4JYDafUKHmV0wJZVvroxlinnlha5jSO0dbH5Y9FCzUo5QSj5tmvdd7Nd3wRnEU5AVom498VDIuyqr7gimwlSdZBY5Rekq+VOF29nU25ZDcXBltfv6ztT/kOcumyHSiAr5FPMfPeQCbJXYoCrYCv8bybvmVdNvrbPTdy7ARYS0YAiuz1ebU5F3+us76jKnjGzwdc2E6o/WjVJOJ3+HzggAGcYIfEiAS//pgVScUC759Ye+LW9Op4dzcf42u9sJ+dL+Ejjb20fFTC0EL1ynJa7w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(396003)(366004)(39860400002)(136003)(66946007)(6486002)(36756003)(16526019)(186003)(478600001)(6666004)(956004)(1076003)(6916009)(2616005)(8676002)(38100700001)(4326008)(83380400001)(44832011)(316002)(66476007)(66556008)(5660300002)(2906002)(7696005)(52116002)(8936002)(86362001)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?70xdWpc+OqbvGevGQKpzD9y7hkeuulhU98iGiTDzjSbdn250/dDTs0fbqnjM?=
 =?us-ascii?Q?y1QHe6niZMyQZQPYyFfDg7phUGEhdf93i4Mx+OBPcLmSYvlHM7qfSYaiiVvh?=
 =?us-ascii?Q?6yZZQprggPDVarthFs4Vq7q3/8oDuWJJ+Ur3FWOC4PWaMxC3czTvfwT8mrdh?=
 =?us-ascii?Q?3X+6VCK873cfH+yOHznEHWorY+eKVrSUW5B9owlVUIDtV9EK7ZbdEcVmS60h?=
 =?us-ascii?Q?AQnCH2eQlI1jz1VssmirUNJUTJPyG5bPLxkOIXxhxNaNAhfnV8PgkIc3o9ey?=
 =?us-ascii?Q?9GEYB811YTgpcQv3TeTYm5k1x5xkD65X3Lkt7NoawbZztqUyP2IZCzh1ZLAS?=
 =?us-ascii?Q?NIFXDemNGzycc+okhafvpui86ZdCtOIxrIPb/6zi8UJzSGXSEfRa6UqiBiEp?=
 =?us-ascii?Q?QO+Ow+/41U4TrpFT9oHzxf2ibGW+CxMh9c1fIZhFeQNryuRMErXXsg4Jfoqx?=
 =?us-ascii?Q?6am52fM6w9S0HKCmPY2jpeWLeQigZaafcwhpNgBpT5CUcwN5gba4w5KzUZ7Z?=
 =?us-ascii?Q?3M1CE9RB7INhqud0i3lPu1QBwLZJFlSL2qjPQiqgwXo/GbD/qgVMstFH28dP?=
 =?us-ascii?Q?3fhSt30zt89wlkj0LoBD78YXR2q2vq8BRHvSovLUYsf+/LaO3U2+vsPVhfNo?=
 =?us-ascii?Q?08oD3BG6Zsysa24BE77chfnOqdGNqYxx2ouxuRpkzHMOgg+Entsyb6vTIQ4F?=
 =?us-ascii?Q?UYwdYjAkv0Mhkm3mQlTObF3IuAZ2LfSpPma81IkGDOYYo1czMz1vBzBbXg3n?=
 =?us-ascii?Q?Db5wJnvRJ3uy/FqkXWb/AF+/lVeaxF536H06zhWaLwR25wlSaZk+E43+TAR7?=
 =?us-ascii?Q?T6k9tknWalybwgp+buKlT4OoIl5GhyrpwUZT4+B2DG4DiTWT6d1akSQnLcu5?=
 =?us-ascii?Q?gf0XU/1vTirRFBNO7F9ApvLCCTsVCIOszhBSOZEoeEe97mvPsmzm/BtDvIL3?=
 =?us-ascii?Q?q9B3OhjrQE32V8/3nFCilXz5oXq3HGszi4HLN/G1qkn/oxEmZVZJfrr4Qduv?=
 =?us-ascii?Q?wADN/btpLqE/z2thMyM+s9F1FBSVpC6YVeB4jzpTzq/0Ytb3CSj6NyizAmu7?=
 =?us-ascii?Q?ImDa0t/8jFzviflN2Bk2Sk1yQguM7iP/hHLlBTbXPJEt/X7663mZzmouA6qn?=
 =?us-ascii?Q?Sfqgr+kPNI+LVA1CuUfpRnAqLpb+Vk6yPK/exJK1t/SMCEC/pCYqDZkq7GX3?=
 =?us-ascii?Q?N0w8O1rn1Gn19HA9VWptx2RH7p8HMRB8BT7Y3MMl3dt3ES5ZedFpSz+3LO4Y?=
 =?us-ascii?Q?98Abv0+T1cIL+nBJzVbZMPVEgcGAsBS2GBrChHVFi7Jy5unTBWPM2elTsCzs?=
 =?us-ascii?Q?zaKPF+HRc7x1g7vWsfeIEEAA?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ddb6df48-9078-4676-a4dc-08d8eef40ba1
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2021 18:38:40.9297
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eLWTkzl05mgPPuim6L3NvNRvYVBqk5PEJaoLmC4LprX8yjaCHK/SDhQRmU+ZJnqicGFPWc8UKz49vBwLsIe0cVgj+B57wFEpKScS15bXU2Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4665
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9933 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 spamscore=0
 mlxscore=0 phishscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103240133
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9933 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 priorityscore=1501
 impostorscore=0 spamscore=0 mlxscore=0 suspectscore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 adultscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103240133
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v3 -> v4:
	1. There were some issues with the checks added in
	   nested_vmcb_check_controls() in patch# 2. Those are fixed. Also,
	   instead of using page_address_valid() for the checks, a new
	   function is now used. The new function doesn't check for alignment
	   of the addresses of intercept tables.
	2. In patch# 4, the tests for alignment of the addresses of intercept
	   tables, have been removed.


[PATCH 1/5 v4] KVM: SVM: Move IOPM_ALLOC_ORDER and MSRPM_ALLOC_ORDER
[PATCH 2/5 v4] KVM: nSVM: Check addresses of MSR and IO permission maps
[PATCH 3/5 v4] KVM: nSVM: Cleanup in nested_svm_vmrun()
[PATCH 4/5 v4] nSVM: Test addresses of MSR and IO permissions maps
[PATCH 5/5 v4] SVM: Use ALIGN macro when aligning 'io_bitmap_area'

 arch/x86/kvm/svm/nested.c | 59 +++++++++++++++++++++++++++++------------------
 arch/x86/kvm/svm/svm.c    |  3 ---
 arch/x86/kvm/svm/svm.h    |  3 +++
 3 files changed, 40 insertions(+), 25 deletions(-)

Krish Sadhukhan (3):
      KVM: SVM: Move IOPM_ALLOC_ORDER and MSRPM_ALLOC_ORDER #defines to svm.h
      nSVM: Check addresses of MSR and IO permission maps
      KVM: nSVM: Cleanup in nested_svm_vmrun()

 x86/svm.c       |  2 +-
 x86/svm_tests.c | 28 ++++++++++++++++++++++++++++
 2 files changed, 29 insertions(+), 1 deletion(-)

Krish Sadhukhan (2):
      nSVM: Test addresses of MSR and IO permissions maps
      SVM: Use ALIGN macro when aligning 'io_bitmap_area'

