Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC3E3513D4B
	for <lists+kvm@lfdr.de>; Thu, 28 Apr 2022 23:15:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352158AbiD1VRx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Apr 2022 17:17:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235788AbiD1VRu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Apr 2022 17:17:50 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE2F17EA24
        for <kvm@vger.kernel.org>; Thu, 28 Apr 2022 14:14:34 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23SJ5ftP018590;
        Thu, 28 Apr 2022 21:14:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=wPcSrKOZyOb+0SjyhY9fX48XHcnuS+7u94ze+5wrk2Y=;
 b=bdmyCsBwwzzzVejlNiXlucdaAabHEbZb4S59JrwOg/00W3Whk0VYdRTnJPaVQOPe4QAG
 9CBcUCK3O8wCCondDy5HuCx2jnuc1xn5AoBvIFDYmic4wz5J/a+87R8Y7bh3yGZFOJEJ
 7NWTfltflJZQbo4/uLflsyqhzt+PtYQwk2DTXOnRMyW7puBXOyKH/MiHK1h8c3ews1Pz
 VOk9ZA038O1VdAn60nBOJIv3YikgLgbFmJKfNFRD4W/srnDQ7LjsM1/3//3eUdOqMMj7
 Sl5dHRuVy1GdKppOXxOnAZ2yNIX27A+RmkSU/nePVyhAwaIxoEJGZgzRxiddjNuJQxdE Yg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fmb5k59mp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Apr 2022 21:14:14 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23SL6cvM028663;
        Thu, 28 Apr 2022 21:14:13 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2172.outbound.protection.outlook.com [104.47.58.172])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fp5ypebjm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Apr 2022 21:14:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kYZwpbs/5xGGU8QJmYR8PAVCn/DLzPZKl2A+DbQ1IuC4HWg0/IpDm+guXTHIcPYKY2Vke+V4mYEgZKJUaQkMMqCPS7XefOGrT5hCgIqoCW9vaqtROjuKqvmx0ZBsvY44miIDBqIhpi713b0tueifkhK/2nk/rHP2FUK5FTaQtDre6aZv3xlfN2Kb7qIndtcCL/UbCaOcQal0NB9oG0HoGnv1t2YKcRRxK3L+MKwkzPOjZyDNJsKgKiHhWwMkBFE4HqvrjoycweFDZHV7peIm3cZr5EFdnnYFBveAoLIMn1p7TiV/iSfLXgnImrspsjw1F3xPT/OU0dkBPf6HcmEbpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wPcSrKOZyOb+0SjyhY9fX48XHcnuS+7u94ze+5wrk2Y=;
 b=QU3vpDbsoVEUqpCRha4FIFbMJBaW30qUu/KPNMYmwRFLOl+KTBhk7Akgwx4zjb1WB9A02ntiHly94alMS4nBCiVxRpwMK9NZh3HGccU28OCMqnGbANVf3E30iIpBwBNp/JSOsuXrIttD3NElVZgPFY5gs37AvOmge9CwtIXd2a4gByee5FQg2IBbmndgI6w5amJUgpoXksXF+KzFtTomCFHo5G0kediPxPic6e+WijtRmGvMO4FumExjh/PjRd3NcyjD/BsrFKSUbTTyOaJVRdDk870EAhWe5RBn8HBaHMu1C+evSp3WnnFqrVWL6UlP+E8jqano7e4xdYImSk/qgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wPcSrKOZyOb+0SjyhY9fX48XHcnuS+7u94ze+5wrk2Y=;
 b=S4scRTwXa0S5ROKiWCy9B88b6jeGNGTMahO1dw6xP1o1Pdo7h6X+WuJwqW8NcT/oolFZrEdsMOc8qp6G2dC+2/2aIN+Zf8qSamYbK0Zsr5YYnDjTah92iQeL+fCg6TVQY+nKJf4cqFwu5p/NU0n1SbNdxtBT9/hTDAe+q1YQxFo=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by CH0PR10MB5289.namprd10.prod.outlook.com (2603:10b6:610:d8::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Thu, 28 Apr
 2022 21:14:12 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d%5]) with mapi id 15.20.5206.013; Thu, 28 Apr 2022
 21:14:12 +0000
From:   Joao Martins <joao.m.martins@oracle.com>
To:     qemu-devel@nongnu.org
Cc:     Joao Martins <joao.m.martins@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Peter Xu <peterx@redhat.com>, Jason Wang <jasowang@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>, Yi Liu <yi.l.liu@intel.com>,
        Eric Auger <eric.auger@redhat.com>,
        Thanos Makatos <thanos.makatos@nutanix.com>,
        "John G . Johnson" <john.g.johnson@oracle.com>, kvm@vger.kernel.org
Subject: [PATCH RFC 01/10] amd-iommu: Cache PTE/DTE info in IOTLB
Date:   Thu, 28 Apr 2022 22:13:42 +0100
Message-Id: <20220428211351.3897-2-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20220428211351.3897-1-joao.m.martins@oracle.com>
References: <20220428211351.3897-1-joao.m.martins@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0297.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a5::21) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f2307eae-302b-4966-ea4f-08da295c0a75
X-MS-TrafficTypeDiagnostic: CH0PR10MB5289:EE_
X-Microsoft-Antispam-PRVS: <CH0PR10MB528902AA4CBC7CF6ED0D041BBBFD9@CH0PR10MB5289.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rfACB4DfsLkTAjqG7zY8Dr1l9Vk5B6H6vsEG+A0nbcC6zN6P5njito7ambmeW4BRxUgmQXj5tbYD5dz5HznOpHtQpvqGbUSw9iJelegMzuaoz55rogpLNfnWg6dQvutyVroMYSxWh82v0YyBLRU9sh+RREX+zpbg/iJ854oPXb1N6nkxA44Jhnx3AiFgl8qBS63iGNscolOD17tqcBHBS9Xt5O9DoW+ClXV4CYmXd59LlGShGKwjLrZr77aYLJsdto7DXOxhXK1Nq+7XYB0xqcYQGc4wDIOP158yP+XkBXuNFkOrFvioSx9KEPUgx57HO+SnS/PQyUqgtxQXdaGkJ429HtT4QFbrtHQEPdkcXbZxoOZKlCMUOAAGtL5Twf5YjO+Guon46aoOnDAnSg6b3TJYch8TJSQGmD2BKXa9c33shdo1x7w3rB1cNwv87PgwioINDActoGn31x51zuoYeHuDLkYdlax8kYIa+fPJJU17MRcUx2TR+9OQIoFGjidqnJZn0sFxDujB17qV7z49O/s66BNHhOEDcOuQFf5nflr0TeQYZyPFVb6yB4oxey6XTBtt+V3i5VQoPitjek48SRD9lhncqSLCZW/Rxj7vlChl1lX3yhZZUnZK2SiXb8xflaJWknKfdDTG+rpgVbDOnVc9qvEI7M/CJfXzXmtorHjuVJfn5dzoHwhtvwfJguDbgSDCNFxPugmRrxf0dhOB+A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6666004)(54906003)(186003)(1076003)(38350700002)(38100700002)(5660300002)(2616005)(7416002)(103116003)(26005)(316002)(6916009)(36756003)(66946007)(8676002)(66476007)(4326008)(66556008)(8936002)(52116002)(86362001)(6512007)(2906002)(6486002)(508600001)(83380400001)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EwE8T9eIJPoA6VWfTYB6cNZCgQ5S0oPJ55Coobo0oUfNvIKJvAFeU2g96SEH?=
 =?us-ascii?Q?BLtL0aniQbqxtcENkoct8yZ+YgnegHaChKFv79kui8r0ORaZD+k3BHeBpAeL?=
 =?us-ascii?Q?KYPT0IS8WC7LJ9FvvSMs7CH7SVtyO1Oo8wWrz7oXfExzjjEvdsu5Fm1MLUhY?=
 =?us-ascii?Q?ZLbehH50cP5J1h0/I/i/F0PFtaiBh7bequAWgxqDR+5a88I5J5PR3hAXd2wW?=
 =?us-ascii?Q?vma1zxLrTVu/w3ysvt2MLLp58ntf8wP3EMzPK0NdfSBmjBcB06ppu6aGvfsu?=
 =?us-ascii?Q?1phg/VA3pV/0/0vnSrYRNzZOad4MpowtV0AWxdq2f6LYTV1rJaDUzMg3gnCa?=
 =?us-ascii?Q?hChQu3ohWEtja43duoDYkFKrbbwpLbMS3zYAzdvYpDrm+kcVa1V9I57HCLol?=
 =?us-ascii?Q?zcEo4/WDM6DylOZIXNenOSRsti1sqbBLyhqrs5YvmRBOkMyhQIfSTQw/c98c?=
 =?us-ascii?Q?4B/SuKMA+AfSObkX19YKgXfOAYEJMDChkmF5KKoORdNKgr/Mwu48+VpR6eqC?=
 =?us-ascii?Q?VS7b0AZvMdAm5DRhKKFitlTcwcCfqXrD05unKT10o4ofCK7oHVxv8JmJcnH/?=
 =?us-ascii?Q?dlpmqiP3z2VfzSw3fcLjFX7Y5ob9Igny/DnuQjgCcLc2ofSJ18Zs4IdXeGi1?=
 =?us-ascii?Q?Rn8KnC9xoz83keI0O5QRkTPVFkABVqzFBAWX3e6zdWL+az2CeapkULuGl6te?=
 =?us-ascii?Q?ABOXvv0fY/aOmsQCbXXOWK5EXoc43KpCxiOqh/tl5rNV6oMLF2Hl7ksas2cP?=
 =?us-ascii?Q?dvHt6NiMa6PgNmgNiTGsfbSunRmC2Rr2kikCH5ZjTeJTVAiAOPfmM2IJ6C3R?=
 =?us-ascii?Q?qc2dAI1da3oDp1cCTpnCxepemjIarNx2l+I/Q54xnVI037GXc3WOtGp6b8n6?=
 =?us-ascii?Q?zx1KX9fqG09grQu1BP5LK1vGNINBkYLXZ+R6E8ykI1sf0/EjI9o1NuQImVUJ?=
 =?us-ascii?Q?7GEVJqQBRTE57WrDBGl4N9jcuGQ0yy0jr08G+B7eHJTehcOxK3ZCve4ia2W5?=
 =?us-ascii?Q?8qNK0z+cCzIa+xM1pFH/BGIJZwUyHSyJqecr8sgp4X732Tade5n+NbDPrYw3?=
 =?us-ascii?Q?6uq7cmp//XUTXODgAMnokw0acKLLJAf78wU1swi5J6xs8ysMC5NrlyrEAJmC?=
 =?us-ascii?Q?OKu5DtJ9bopJBDPhbobA3SZ8mu7RkbqzttKju+sODpADOMVN85VAbbl526yR?=
 =?us-ascii?Q?nrQT/XOhcPKIGlbTcwHolHni+QYrmSUqto47Fzro69Rp1DrRbmO7x1KdumjY?=
 =?us-ascii?Q?o4eEI6csCImnrRTVs7nAQnvD+UtyouOHsBwchUH7C2G9fczdV/YfJYX3oWei?=
 =?us-ascii?Q?URCrCHOKXJSs4hn2FAII1IurL4EgTbcG4QekLI5qVXHiR0gf0+S+eYi89tdz?=
 =?us-ascii?Q?eHQJ3K4eFM7BaiZUKlzRvW8eVJhWWNDMdTQ5SJ2wxqADzNPqpuQTtOSpaSvr?=
 =?us-ascii?Q?9rPkl34k8iKfyieBSVazL1dQW4z5OYJNrAl6FKf1shiI85yokuPGkHGURZ7F?=
 =?us-ascii?Q?QYZC20P1vjsVFharveeAvG2y65y02LFypT7TuJLCJvYMX2BXigRRZCPHW1ba?=
 =?us-ascii?Q?Quzg+DWVf0/gUIl3DRbNcAwDAIGVOVLsa/u1sdeqYO/Vl3W7t0ylcqKxjEfr?=
 =?us-ascii?Q?7goSKJPz0cDKPjRZeNSeLPxE5JOdcgB9uolnPX8s5eZC+5pohYjjXgObqx92?=
 =?us-ascii?Q?MJGQ2bllDlWO/qHTjuhKXaZ6ZuRaGwGBo1ynZjY1en6F+Zi3KppBDM6VyVeI?=
 =?us-ascii?Q?T0Uq2ZFFg3GHoHoWeO0nT9h79z+GVYM=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2307eae-302b-4966-ea4f-08da295c0a75
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2022 21:14:11.9950
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eATHI9/ZUnY70G8LwAyR9cPiAUKZR1LQGZDgcriCiQXlF6F9G+Kpg2WzVebY+6mVgJjIwMoYFPOnf8nbWwu3cethX1CpWfPyiE7OXdJjAaI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5289
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-28_04:2022-04-28,2022-04-28 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 malwarescore=0 spamscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204280125
X-Proofpoint-GUID: 3_w8L3ZWkDdmRuw8B3QQPj4TK2UIG-Co
X-Proofpoint-ORIG-GUID: 3_w8L3ZWkDdmRuw8B3QQPj4TK2UIG-Co
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On a successful translation, cache the PTE and DTE
flags set at the time of the translation i.e. the first 12bits
as well as the PTE storage. These bits contain read, write,
dirty and access for example. In theory the DTE lookup takes
precendence in the translation path, but in the interest of
performance extend the AMDVIIOTLBEntry to include that information.

This is a preparatory for AMD HDSup/HASup which requires updating
A/D bits off the PTE (even after its insertion in the IOTLB) based
on the fact that HAD bits (0x3 or 0x1) were set on the Device
Table Entry.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
 hw/i386/amd_iommu.c | 24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

diff --git a/hw/i386/amd_iommu.c b/hw/i386/amd_iommu.c
index ea8eaeb330b6..25b5c3be70ea 100644
--- a/hw/i386/amd_iommu.c
+++ b/hw/i386/amd_iommu.c
@@ -72,6 +72,9 @@ typedef struct AMDVIIOTLBEntry {
     uint64_t perms;             /* access permissions  */
     uint64_t translated_addr;   /* translated address  */
     uint64_t page_mask;         /* physical page size  */
+    uint16_t dte_flags;         /* device table entry flags */
+    uint64_t pte;               /* pte entry */
+    uint64_t pte_addr;          /* pte entry iova */
 } AMDVIIOTLBEntry;
 
 /* configure MMIO registers at startup/reset */
@@ -340,7 +343,8 @@ static void amdvi_iotlb_remove_page(AMDVIState *s, hwaddr addr,
 
 static void amdvi_update_iotlb(AMDVIState *s, uint16_t devid,
                                uint64_t gpa, IOMMUTLBEntry to_cache,
-                               uint16_t domid)
+                               uint16_t domid, uint16_t dte_flags,
+                               uint64_t pte, uint64_t pte_addr)
 {
     AMDVIIOTLBEntry *entry = g_new(AMDVIIOTLBEntry, 1);
     uint64_t *key = g_new(uint64_t, 1);
@@ -359,6 +363,9 @@ static void amdvi_update_iotlb(AMDVIState *s, uint16_t devid,
         entry->perms = to_cache.perm;
         entry->translated_addr = to_cache.translated_addr;
         entry->page_mask = to_cache.addr_mask;
+        entry->dte_flags = dte_flags;
+        entry->pte = pte;
+        entry->pte_addr = pte_addr;
         *key = gfn | ((uint64_t)(devid) << AMDVI_DEVID_SHIFT);
         g_hash_table_replace(s->iotlb, key, entry);
     }
@@ -896,7 +903,8 @@ static inline uint64_t amdvi_get_pte_entry(AMDVIState *s, uint64_t pte_addr,
 
 static void amdvi_page_walk(AMDVIAddressSpace *as, uint64_t *dte,
                             IOMMUTLBEntry *ret, unsigned perms,
-                            hwaddr addr)
+                            hwaddr addr, uint64_t *iotlb_pte,
+                            uint64_t *iotlb_pte_addr)
 {
     unsigned level, present, pte_perms, oldlevel;
     uint64_t pte = dte[0], pte_addr, page_mask;
@@ -945,6 +953,8 @@ static void amdvi_page_walk(AMDVIAddressSpace *as, uint64_t *dte,
         ret->translated_addr = (pte & AMDVI_DEV_PT_ROOT_MASK) & page_mask;
         ret->addr_mask = ~page_mask;
         ret->perm = amdvi_get_perms(pte);
+        *iotlb_pte = pte;
+        *iotlb_pte_addr = addr;
         return;
     }
 no_remap:
@@ -952,6 +962,8 @@ no_remap:
     ret->translated_addr = addr & AMDVI_PAGE_MASK_4K;
     ret->addr_mask = ~AMDVI_PAGE_MASK_4K;
     ret->perm = amdvi_get_perms(pte);
+    *iotlb_pte = pte;
+    *iotlb_pte_addr = addr;
 }
 
 static void amdvi_do_translate(AMDVIAddressSpace *as, hwaddr addr,
@@ -960,7 +972,7 @@ static void amdvi_do_translate(AMDVIAddressSpace *as, hwaddr addr,
     AMDVIState *s = as->iommu_state;
     uint16_t devid = PCI_BUILD_BDF(as->bus_num, as->devfn);
     AMDVIIOTLBEntry *iotlb_entry = amdvi_iotlb_lookup(s, addr, devid);
-    uint64_t entry[4];
+    uint64_t entry[4], pte, pte_addr;
 
     if (iotlb_entry) {
         trace_amdvi_iotlb_hit(PCI_BUS_NUM(devid), PCI_SLOT(devid),
@@ -982,10 +994,12 @@ static void amdvi_do_translate(AMDVIAddressSpace *as, hwaddr addr,
     }
 
     amdvi_page_walk(as, entry, ret,
-                    is_write ? AMDVI_PERM_WRITE : AMDVI_PERM_READ, addr);
+                    is_write ? AMDVI_PERM_WRITE : AMDVI_PERM_READ, addr,
+                    &pte, &pte_addr);
 
     amdvi_update_iotlb(s, devid, addr, *ret,
-                       entry[1] & AMDVI_DEV_DOMID_ID_MASK);
+                       entry[1] & AMDVI_DEV_DOMID_ID_MASK,
+                       entry[0] & ~AMDVI_DEV_PT_ROOT_MASK, pte, pte_addr);
     return;
 
 out:
-- 
2.17.2

