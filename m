Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F8F0412A11
	for <lists+kvm@lfdr.de>; Tue, 21 Sep 2021 02:48:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239650AbhIUAtu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Sep 2021 20:49:50 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:2474 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233689AbhIUArt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 20 Sep 2021 20:47:49 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18KME734001708;
        Tue, 21 Sep 2021 00:45:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=1baAfN84zgwpe8VzVqFeFf2vjSF0ddPXPAHS/rNbG+Y=;
 b=oMBYRN0vNPoPtGQNGkJPR2jbA412QVAXYFgPu1YEraRKfAJ/b8M6dxP+l8qLIc2ataeo
 ixcWNtGeo6Sd5wP/HbaQiX2t+gxUneMrbWN06zQAGdZ/72TxJqTYyRkvFpy+I1KuKRxh
 O8ygXxPNVcMlkGLvj7bWqHiEs1m2OPqQ6kOlNsih62fieCKoAeJ2YiXZYP6xHi40BBnb
 Ez68VCzutzGGUCP0D2f2Z2HOF87CyhmsgTJW8T6voJnPws3UMM6jvIigL4+W66a4JNOQ
 I4uTEjiXtvp4xXLRkjr6uB/AB9uTpoBwbRFoo06JZmBNZ5mHcjUAPMOsE6z1jsYrII/J KQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b66gn50b9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Sep 2021 00:45:48 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18L0fVPo058024;
        Tue, 21 Sep 2021 00:45:47 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2042.outbound.protection.outlook.com [104.47.56.42])
        by userp3030.oracle.com with ESMTP id 3b557w9vej-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Sep 2021 00:45:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kpYcz5SJNitL9q6qJQOipyywVOmqV9uqhdbbu1ZHh3jxT6ljHMyR+K8OwDxqQ8z10GfObS8ZWtA9zZYfUNnQzS181U9OlVgdczM8j17GcQB1bwZHog8I7C3JehVrt+YNZRFB1FJo1gdPWpYwqgD99Wq7W8jeqxHWtEIiYojZL8lh+7kfo3Pk40u4WA8D6CNDL4v4jBRH0RGpXDlPqD8Jf3xGEtJwUKqt8ZBoc50wuKTCLWeyOM2rGKfAJG9NfX0YpYTfL2RuwgW5Z6fnh200ZWmd7YnaV6ynrcHfI4U49sO/z+Zy15eb6bYR8dSer7WtfBINj5lL6vmjezyT0amwVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=1baAfN84zgwpe8VzVqFeFf2vjSF0ddPXPAHS/rNbG+Y=;
 b=gRK99qDBCq5v3VHMkLxODiEkR/NTHRsjFRXlYTgan66TfwVIb7aIPfJsS9hYcp/EQ3pXixNsTs4Qc96+lg9bDAtMvreJnqrnd3OTNQtoDNchUnZpP3e2or7JTQMRVoR33jcf6o5pGT56vA2mkNld5meduJV7iy2HiSVBhKR9N8Y6PXU1wU9a5zM0kyRkuoOIH1+GsOcB20uaM8ooJyTHFssqYF5vjMbxazvJE8izZdRGnjAZ3yUFBmlMgeCPGhIbR6MNuW4cw35poRLjhDqqtmwEkmyk0tm7HAj7S3BJs/x/snXkbOezx/J2+vTbBCY7T7WjgoRsRSNvMVuFlBNs9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1baAfN84zgwpe8VzVqFeFf2vjSF0ddPXPAHS/rNbG+Y=;
 b=e20x5GSJTD1pslGn5h7PNi9ygsOi4ynzQ1lyk232z+wf2zXYM3H8xdEn+N6XBi/1hdCV5BrsSaWuGohD0CzZo3GZi2uIAnMOL4BbieCOZylpdw3v3RHa0cQNTuwXM3+PLgOCZ+l4149EtYl3s+wuOK2tvpDgGXFNIRCIThrOujo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SA2PR10MB4426.namprd10.prod.outlook.com (2603:10b6:806:117::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.17; Tue, 21 Sep
 2021 00:45:46 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::f12a:c57a:88a7:2491]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::f12a:c57a:88a7:2491%7]) with mapi id 15.20.4523.018; Tue, 21 Sep 2021
 00:45:46 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, joro@8bytes.org
Subject: [TEST PATCH 3/5] SVM: Add #defines for valid encodings of TLB_CONTROL VMCB field
Date:   Mon, 20 Sep 2021 19:51:32 -0400
Message-Id: <20210920235134.101970-4-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20210920235134.101970-1-krish.sadhukhan@oracle.com>
References: <20210920235134.101970-1-krish.sadhukhan@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR02CA0002.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::15) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
Received: from ban25x6uut29.us.oracle.com (138.3.201.29) by BYAPR02CA0002.namprd02.prod.outlook.com (2603:10b6:a02:ee::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Tue, 21 Sep 2021 00:45:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f8a6564e-ea07-4919-2c07-08d97c99264e
X-MS-TrafficTypeDiagnostic: SA2PR10MB4426:
X-Microsoft-Antispam-PRVS: <SA2PR10MB4426438EDD112BD28EF7EDAE81A19@SA2PR10MB4426.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:296;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YLEwPdN4JdDvLYnfVkYTqeFMnKN+iPP+GxLc21pZs0GkcZcfVqg+R0Q+AOV74WCR7WJd9niqqEi8fk+/ausJNr7MwcS2YRXKa5afJIn7pG/qVk/uoVZ86JcFo+eDGi0nlVR2ZqJB6Fhqpev5ly7slhpYLZuOIN4RQ+cJW4dxYkDXRv+MneghR24MIa3Ax8Efy3KqrrxrsjQ0/ZibFuJ8fQM0Q5MxZIjpn14lansC2kwHfQYUivnJCpGYbXzMpPVTP3TnENUBhEMGsOD8Lp3rh1A1oRLvVHpuUPaVHaXgOZPIbTc0MbQ91Tn9Sh8eMesdgYsa6FHP+fyAZ44NiaX/GF1le8bnNPCSLCXVKZhRwoMp8lg7Q/LeiXahaUFV2uCv0OOd1cPIemnvQfc96FluRu8ZdJCunGNqTN9AcQMvUPxEaH4QNJBsgh7jkRlcNP1ytT5Il+LilbCNUW0+iXADp4cmxECbmZLrKiHrb2qm5Qy1hmvWZKYgwZn/upJl4KTezhNRK7ZTQ/CiMVNqweANkuqQaMWzwfVUOv+gIffUbHi9kcO2uaz7Jo5U8pLWCHe2FE2d178SUzASLmpjYHmLD16m3NQ7MMJfegBgQEbdnsRDspBRxJfLUyy0YHogyVWWWyzHOWA+uvseb5xbzMcSZ12JfXOyrXLjV379AVdniT5rp9fPgDb/0vsmp9jQWu/fCmM/qfDJfv1EsaXGag67kw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(346002)(376002)(366004)(136003)(2616005)(5660300002)(2906002)(66946007)(956004)(66476007)(66556008)(6666004)(186003)(26005)(8676002)(7696005)(52116002)(38100700002)(38350700002)(6486002)(478600001)(44832011)(6916009)(86362001)(8936002)(4744005)(4326008)(316002)(36756003)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rg8eDfsRNf2uQMkRjAlc+ngsvndF/FmqeYetyDwPQKn3pxKX6VV8T9/oZALw?=
 =?us-ascii?Q?dnkpZIUnBpenVnjiA8O0zR76H1xs6QlthLpAIwbly/Yp2wunmXY2H/zkJnq3?=
 =?us-ascii?Q?iSPcMwqMTYzVtrtOl/rDXOYjrD6k5nH/rLXSsCb7bOKALHeaiLTPyn5gPuxM?=
 =?us-ascii?Q?Lm6gwpCfSE0Hj2YQVl0ELANDlLT//PNV6zoMZCTqGGfXRtS3FyoRzcnhR/96?=
 =?us-ascii?Q?HGZUR8lryWHx7KAC76GB4y57Wdf5+GP2flM7Q4vFNed11u/c6R5G4ZlBltpO?=
 =?us-ascii?Q?u2U6x3fD6yXq1sEpD31vJrY6p24S8S3wLfbCTT/PRQNcuGbuDUWaIY5uZUo5?=
 =?us-ascii?Q?Gsg9TQhY7J48xpVA5nqbLGvitiC82wmSwnatNnLrcr6hXP2y0/hrJqCusH30?=
 =?us-ascii?Q?Y5fixxk5ec9HPeCe3/7IDWnKY22wTuCSF9HxyGImPtxUU5dP7F3oyVvl+L0v?=
 =?us-ascii?Q?IH5ec4mCgjaSpZsUVaPwsG6R26SzXXFnkaqI58BgKVJ82BlNGplUOhEmt4/R?=
 =?us-ascii?Q?X+PGO+/Yg2b+xJ9BwbRcXSRnwg1ZFZNiqMPP93DQaGDMRRss21pFMHcZAcSu?=
 =?us-ascii?Q?QX0T+FSCFo15lGa53j0AmmaX3Y0xA+9nc5Cj/BsJ38JWmbftmTbMj/QjjK2+?=
 =?us-ascii?Q?ct7Qs45cWUDh23/ZTQ4NWSUVfoOonnq2IkR2TPeVONAln1svRgWMzeTxzXUy?=
 =?us-ascii?Q?D4mduK0vfb4jfkalyFRfZ33cfyD8NiZrLb82dFQZf9QlCqwtzSsbLP86KKjk?=
 =?us-ascii?Q?fPWwrRZ4bilpFOm4Pzec2biQYpyPyxphCQDuOP3GW1NMD+dYTsHPnuK0A0Kd?=
 =?us-ascii?Q?pD/CJLwRQ8a2Bv1d3GLQ/duUiAuo673bOFm/K8GJI2zIi8VNlNh48OSFKk90?=
 =?us-ascii?Q?z2KvxayMTyJGIPXF3UkvBQJcuQIaq574LCWWEQOFuXWRHv9CxsjGl64GP8fv?=
 =?us-ascii?Q?6KTQqrWCFJOgi9NP+CGqkSfbCB0QEtVGRY+O0sD1siVNddKxN7pmnLw7aMt6?=
 =?us-ascii?Q?SmTlvqTfq4aedtZsp/ILgsD8qD+sUuFATPXzQr/UbKJlgUKoybTB4mN2MetB?=
 =?us-ascii?Q?/IzLK9z3M47a7gBA5XosEsc4VYgrw1JhMi2td7f0LMFsrFOMvP4Hj0r1mpQT?=
 =?us-ascii?Q?Sz6eaMHBgLOMDy+/DQ4Vu7IhrSklW2oEeRdcgWCfEr3ravLi0ZBFVUfmEGPd?=
 =?us-ascii?Q?U8ZieghkvKOA5moHpz6FzalYwvbnABdHdXI1Kb546fU/0PgUgJTXHkbWNduC?=
 =?us-ascii?Q?Qh5MrNJoMGoZkDGYx3AmH6Bl/AgzWwbNBepQXDViujnL6wO9n4oO77+bBWBK?=
 =?us-ascii?Q?x5cjBQkNM0dYv54kxpSceSZP?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8a6564e-ea07-4919-2c07-08d97c99264e
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2021 00:45:46.7101
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JZUsmIcGHZLg+1Zh1r7NBy8YQWj339uF/mSG2mmiMgxfxKQRNZyBGAB3flGC5/eAg5occ4KfWxGLLiNGGf8KdzecLAVqJ3VnmL4s6z28n08=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4426
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10113 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0 spamscore=0
 bulkscore=0 adultscore=0 mlxlogscore=999 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109210001
X-Proofpoint-GUID: avEgbz88GcDN7PGGXjsgtPly_oJBk-H_
X-Proofpoint-ORIG-GUID: avEgbz88GcDN7PGGXjsgtPly_oJBk-H_
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 x86/svm.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/x86/svm.h b/x86/svm.h
index ae35d08..660956d 100644
--- a/x86/svm.h
+++ b/x86/svm.h
@@ -360,6 +360,11 @@ struct __attribute__ ((__packed__)) vmcb {
 
 #define MSR_BITMAP_SIZE 8192
 
+#define TLB_CONTROL_DO_NOTHING			0
+#define TLB_CONTROL_FLUSH_ALL_ASID		1
+#define TLB_CONTROL_FLUSH_ASID			3
+#define TLB_CONTROL_FLUSH_ASID_LOCAL		7
+
 struct svm_test {
 	const char *name;
 	bool (*supported)(void);
-- 
2.27.0

