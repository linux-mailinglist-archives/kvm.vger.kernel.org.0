Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7249E513D4A
	for <lists+kvm@lfdr.de>; Thu, 28 Apr 2022 23:15:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352182AbiD1VSK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Apr 2022 17:18:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352178AbiD1VSI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Apr 2022 17:18:08 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ADA681FED
        for <kvm@vger.kernel.org>; Thu, 28 Apr 2022 14:14:52 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23SIfu4r032176;
        Thu, 28 Apr 2022 21:14:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=7sErSIk5MNW6OTKIpyOe/Zu4jBCiLDcLFKrwJAmQq5M=;
 b=gUqBaUEw4bA16UlZIBKXzNqy5ZUd5ZWWhdu5Z0wY1KDKWrCdfSvY0YdlhBH88OcI5Oab
 Bjx/bY4g7kgy+LQiXoNaOmBtiA0eOFnQ5AAPmnVS5wQv7+POkVBMRzIjD6HGDzxbQzaw
 EYTaTtOYo1JJnzWMV+rTWKlWRr0SlGOn2ZWYMbKgb/BbJNpBOFL/bWXlcWrBOOmqTW/t
 pSqoCywfUhKUt1tuQe+vFwzVpsLxZPXwAiGPJLt6ag1pCqWgIGVsVwI167Pj52lzYCr5
 4A7/K0qxALfdQW9xToWDIb2z+4FC3zTQ9RLmzdnCZ0iCdV86qSX1ohFp0OD5kPN7azTr Ag== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fmb104nkd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Apr 2022 21:14:36 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23SL6cf3028671;
        Thu, 28 Apr 2022 21:14:34 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2174.outbound.protection.outlook.com [104.47.58.174])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fp5ypebsb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Apr 2022 21:14:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G/HHCkqrH1Rafi5SGVndcqDkdiIkj5lNebXdOO3iZikSdzEEJ/ABEcUwRlhuMhZ7gJrv0YtfwZK/occ7X/BaRzo4yWSgah91c6K4K9oNK+2+nCFxFXLqZ/uH59WnuE1XCRTIfpJDdy+sh/Ti80ZAVX6eA5c5OuePah8GppCPKebg10bq+Dn5Svmmrd/7yFD8v/yXUTT2BG34A9Je4ZkKFZOx+KjhUU8fZQmpM3mL5htX46C//smnToArFJrE5hZeAhHLj3IrqS6mUHyZYvA7bKVpNBw3cOn6lTth7Nia9fR2lVhysnL1OF2+LjppdIMZ8oG6/XQHXy91/JdXU8aNbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7sErSIk5MNW6OTKIpyOe/Zu4jBCiLDcLFKrwJAmQq5M=;
 b=jU+oZvFi4sHwdhJ1DdDLX95wh8auNCuc6LgTaQnExhyBahVtopAbdqXIMMh0qycS4SDE1UNOWIl8+jwWhPlnjzdSVAPgsbZhCyKATjvJKlnrYbgV+pmRpwiz+OU4T0UNRlRbSBxNgFxRH+H1Cb8anB1MFujmicH4cSpWvO8KV0pAUPu3pcnOxTrdU2xVscJsh6uHeC38hRwDIMqPh2XNN2Hn1YS33wA4Rp9hVjkKk3x3mXA07kQ9YhTP9GQslGhLciaVHsBJls13XDlxhd9AzwHzQzrnQZaV9xewzUP0Zb0wibKGBQjzNmZRBVVpLM3gc655ZEkhtK/oORQVUG1cRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7sErSIk5MNW6OTKIpyOe/Zu4jBCiLDcLFKrwJAmQq5M=;
 b=KnOH+9I9ycs44datw4u6FAy3wFMWv8tr8staNvOrfK9vyU8gqdknqE0PBxAPtugprZLavYDq38KjfeqRL+3u/a9x7up34ymdwFkJIhkdaoS8t2gHxNoSwcTe5MlmQVQXDP9Inm4Rk9Roedn0md/jxjRKUnXUci33GvIblRkcC78=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by DM6PR10MB3260.namprd10.prod.outlook.com (2603:10b6:5:1ab::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Thu, 28 Apr
 2022 21:14:31 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d%5]) with mapi id 15.20.5206.013; Thu, 28 Apr 2022
 21:14:31 +0000
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
Subject: [PATCH RFC 05/10] linux-headers: import iommufd.h hwpt extensions
Date:   Thu, 28 Apr 2022 22:13:46 +0100
Message-Id: <20220428211351.3897-6-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20220428211351.3897-1-joao.m.martins@oracle.com>
References: <20220428211351.3897-1-joao.m.martins@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0297.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a5::21) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 31a4f237-358d-4c6d-8002-08da295c15eb
X-MS-TrafficTypeDiagnostic: DM6PR10MB3260:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB3260941730B10AADC6500210BBFD9@DM6PR10MB3260.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OdRa1z9WmyYwisjT59DCM0B1SQ8fB1qJk1UwfgSmqO5G+ObdZ7QtCdAgh9iza/+IHhxiSvctCU3p7RgoiRVAld3DtopqMnFDx/WLDkPYOHspPCZRJsBsZjhOsyFN/zhqRksb5YQWIz944WFpHp9A8Zq6ySoh4qNMXtZ30Hv0qF2J7Pw26n6IgxqYlKcYN7SG1oWYoCyMu0VwKgrZpOozS93JF99/F4EwdYgyYEUQncwB5rA5Xbzk1gg8Xozz6bTH9lAm3k5lKzV+xDB/JYGFHicNzLzj0VcoAO3kPSrmKefZnekTrPLJ3ap2Hnv8++BbrNcTxXt+7jR/PRqgU3Dgpl8axGKG70wFsAcF/M/K3W/zTwMODwK9GM94AoSPN1i4UkLIe47UpCY/G8wGQUKHO/BPkHsf/Hd56LVQlRNiZnMxm4EwZwKXsF7y37zcweJAMcFwMcK5PUIagUCgovYEjyMcaLFAavxYuSv5kAEvTyNRU3UooBDReMFLZ0jQNkSV3EyJWr8W0tr1OUzHimC6opqKXgumcLiit2P5MUNvAOx1mZkqfSitZ4nfv1Ti1AfDVd1/DEN3xZ9VzEJLRF3zGv2E3Isg7thevoaC2hyRfYOsGrieHp78L8rEhKMIaajS2F+IeGpYCItpZizAbivF/V6G7evbiqiJ1lndyRpAoDydfSTOJDjGjqzdvSaQdgYq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(5660300002)(66476007)(66556008)(2616005)(1076003)(186003)(54906003)(103116003)(6506007)(36756003)(6512007)(6666004)(26005)(52116002)(316002)(8676002)(66946007)(83380400001)(6916009)(8936002)(7416002)(4326008)(508600001)(2906002)(38350700002)(38100700002)(86362001)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SsfeVQGAM2B5YO2swzPRW8dUvwQ3VT6Mcwgk+cKJXIay4GJRj9C7IC1j3M1t?=
 =?us-ascii?Q?HyMY4QhXHww0qCBVa/dfCexIU+rXEacgPqUVmO2nnqU9Vd0LJ7lCUS32MSvF?=
 =?us-ascii?Q?XWsDpAeDUbzT7TCJwYnoOa/aQQdA6KgttnW9/sSgQUaN+g2ioQuLkAEN984O?=
 =?us-ascii?Q?rdIjBPiTSmGCO9X6uJyCWrGWnszXt1XATMt0KnOz7GP5DXnYCmq0bmUpzbnv?=
 =?us-ascii?Q?jXpzG8mz3tO6CsIBYdy48m2PuvlDOUNKpVMXMgLPxtS9C2A8BpWdbI461+vj?=
 =?us-ascii?Q?Sbzdv/MdjgZzlalhgQpigNRFA8t4qKCjQEyfVLIj3mN35wWKiUrk2ZvAAJaj?=
 =?us-ascii?Q?IUvJCbo8MrZB6ZENjg4F10PtsD7qYXSG3WJutzE86OS/hK+G7dSAUWqFDLNI?=
 =?us-ascii?Q?XeBqeYuVU6lDy3XN2RVJF6bL+/FFPg41fO9ZcI6qPMh5bbm/7oHrM3gBrhuQ?=
 =?us-ascii?Q?htZW5v68hiu/Wx+kuRFeBaKsYi4MX++a+HeyEKhz4Qh8ROejgYoLffRKIObv?=
 =?us-ascii?Q?NI4n2bh/95XqcllrqCVdV3FKku9XFpgbyBjwg8dRO7DoqOwXNtwkqYrip8tR?=
 =?us-ascii?Q?kzhMQpf6YadQAH1xOhBFc4OLoZ58B4MFurp9Ih67IA+9xeZEb4/QeBvVQQCf?=
 =?us-ascii?Q?hU4+0FQPKXV+sGiVITpqNEv+sm36ygGX+zpbvt806se1JJdvA6WPoPR6kfvl?=
 =?us-ascii?Q?sABv6gMOYoB3PsZkf3F93VfO32p+GNECYo04COa2VT91gtHIN92jk7WEvA+R?=
 =?us-ascii?Q?b4pXGxJ5soBcNQmeDL6dcisbq73JF41WYBBSmwSWYMbaLLk13Q5EZ5Q0lj/B?=
 =?us-ascii?Q?9CnXH2nCHgJbULBrpVieuikGdD1O/tsoy0qj7Ld6dlmQa9Fo44dJKPmlK6f8?=
 =?us-ascii?Q?9IKosMSgeZHA70wnnsUUVBdzLHXDGoryafkTJKcDMnzazmhXCHMHthoko+/3?=
 =?us-ascii?Q?oq8zwFmwCzKRExsi+nH+QUG3j4Cyffrj2wT0qQHj1vWP4Xeo+vaFZrvhEgFD?=
 =?us-ascii?Q?NXc3u4IT7iKlQR67FmlpboVwq0/qUpZrRRQCx1jpc4g5oFXEZDe2D5d1eWIj?=
 =?us-ascii?Q?HaahxYRrfWC95jYWHj/vpGoAz8r4s7HcyiovsajNYmqV/Iqcrs+U8aunRiNx?=
 =?us-ascii?Q?Zh7B0A84b9Q5F7hoHPr50Ob5JWUPmJqqrw/mVWJz0R6WcbM4hf72I9hN7CN2?=
 =?us-ascii?Q?uRVGiQ2gz+KkLiRdwxn2HZ+t8wzQdT4c+qTBDSVCfjGb706wyRlZcUCNaAKn?=
 =?us-ascii?Q?s+gB+3pxpHPgXmZopQmlE3ZNx0wi5i2G9INIZROu3NXkEWL5ZzHLXY8EMcbV?=
 =?us-ascii?Q?SGw4GeARAkSc1Ym4JO2JyCL9TnN90/KYvANf/E9IpaHcwhcf1gbKe1cwIs/t?=
 =?us-ascii?Q?ofbcm79zqE82uG8up/fd0Czg8fFF4lbctIc9MQHHXa9Vurar03SpGyGm21rz?=
 =?us-ascii?Q?/JDSiROTtVlw32UEum85cnCU8KAsPLr3YnU10eJBgD66q4B17ErH9jn9ke//?=
 =?us-ascii?Q?9/YyUM7uH7R9jC0G6M2yikEXbpZvDPIp7oBJOwiewSnFsLpmJt3YE4ruwSy5?=
 =?us-ascii?Q?AFHjOv9C7DEYdvaqtbwyohEOX5U9pvUx2YsrTOtY1AXG6TFLozZtxz6utRyO?=
 =?us-ascii?Q?Qu9f6Q1ifM1SU+H7A8XgCca8Y5ENoD7FiMv6YU5IrHBFs3/aMS8a67iMjrqE?=
 =?us-ascii?Q?jup3vGOzM/5B95QwgUeNMWwdWL2eLMifK5tDXVX0lRD9BdVB/DfOQlBYSHLu?=
 =?us-ascii?Q?Vnb2/3giPwm8LdmQ+HpBv2npqSmuPWc=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31a4f237-358d-4c6d-8002-08da295c15eb
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2022 21:14:31.6112
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dE/OngGZBhBQlhTEpN225+DO6GmoCTvn8+v0hfpe/nupcPlImPmW19ct+JPYC5yyy7UTZ6hlxF/sesje1z12js7ftqblsjFNECq7p+8A22o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3260
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-28_04:2022-04-28,2022-04-28 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=956 mlxscore=0
 suspectscore=0 malwarescore=0 spamscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204280125
X-Proofpoint-ORIG-GUID: 5gGGtLXPbu4L_FdUBN9HA9wVVA6egXeE
X-Proofpoint-GUID: 5gGGtLXPbu4L_FdUBN9HA9wVVA6egXeE
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Generated from `scripts/update-linux-headers`
from github.com:jpemartins/linux:iommufd

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
 linux-headers/linux/iommufd.h | 78 +++++++++++++++++++++++++++++++++++
 1 file changed, 78 insertions(+)

diff --git a/linux-headers/linux/iommufd.h b/linux-headers/linux/iommufd.h
index 6c3cd9e259e2..e3c981f81e43 100644
--- a/linux-headers/linux/iommufd.h
+++ b/linux-headers/linux/iommufd.h
@@ -43,6 +43,9 @@ enum {
 	IOMMUFD_CMD_IOAS_COPY,
 	IOMMUFD_CMD_IOAS_UNMAP,
 	IOMMUFD_CMD_VFIO_IOAS,
+	IOMMUFD_CMD_HWPT_SET_DIRTY,
+	IOMMUFD_CMD_HWPT_GET_DIRTY_IOVA,
+	IOMMUFD_CMD_IOAS_UNMAP_DIRTY,
 };
 
 /**
@@ -220,4 +223,79 @@ struct iommu_vfio_ioas {
 	__u16 __reserved;
 };
 #define IOMMU_VFIO_IOAS _IO(IOMMUFD_TYPE, IOMMUFD_CMD_VFIO_IOAS)
+
+/**
+ * enum iommufd_set_dirty_flags - Flags for steering dirty tracking
+ * @IOMMU_DIRTY_TRACKING_DISABLED: Disables dirty tracking
+ * @IOMMU_DIRTY_TRACKING_ENABLED: Enables dirty tracking
+ */
+enum iommufd_set_dirty_flags {
+	IOMMU_DIRTY_TRACKING_DISABLED = 0,
+	IOMMU_DIRTY_TRACKING_ENABLED = 1 << 0,
+};
+
+/**
+ * struct iommu_hwpt_set_dirty - ioctl(IOMMU_HWPT_SET_DIRTY)
+ * @size: sizeof(struct iommu_hwpt_set_dirty)
+ * @flags: Flags to control dirty tracking status.
+ * @hwpt_id: HW pagetable ID that represents the IOMMU domain.
+ *
+ * Toggle dirty tracking on an HW pagetable.
+ */
+struct iommu_hwpt_set_dirty {
+	__u32 size;
+	__u32 flags;
+	__u32 hwpt_id;
+	__u32 __reserved;
+};
+#define IOMMU_HWPT_SET_DIRTY _IO(IOMMUFD_TYPE, IOMMUFD_CMD_HWPT_SET_DIRTY)
+
+/**
+ * struct iommufd_dirty_bitmap - Dirty IOVA tracking bitmap
+ * @iova: base IOVA of the bitmap
+ * @length: IOVA size
+ * @page_size: page size granularity of each bit in the bitmap
+ * @data: bitmap where to set the dirty bits. The bitmap bits each
+ * represent a page_size which you deviate from an arbitrary iova.
+ * Checking a given IOVA is dirty:
+ *
+ *  data[(iova / page_size) / 64] & (1ULL << (iova % 64))
+ */
+struct iommufd_dirty_data {
+	__aligned_u64 iova;
+	__aligned_u64 length;
+	__aligned_u64 page_size;
+	__aligned_u64 *data;
+};
+
+/**
+ * struct iommu_hwpt_get_dirty_iova - ioctl(IOMMU_HWPT_GET_DIRTY_IOVA)
+ * @size: sizeof(struct iommu_hwpt_get_dirty_iova)
+ * @bitmap: Bitmap of the range of IOVA to read out
+ */
+struct iommu_hwpt_get_dirty_iova {
+	__u32 size;
+	__u32 hwpt_id;
+	struct iommufd_dirty_data bitmap;
+};
+#define IOMMU_HWPT_GET_DIRTY_IOVA _IO(IOMMUFD_TYPE, IOMMUFD_CMD_HWPT_GET_DIRTY_IOVA)
+
+/**
+ * struct iommu_hwpt_unmap - ioctl(IOMMU_HWPT_UNMAP_DIRTY)
+ * @size: sizeof(struct iommu_hwpt_unmap_dirty)
+ * @ioas_id: IOAS ID to unmap the mapping of
+ * @data: Dirty data of the range of IOVA to unmap
+ *
+ * Unmap an IOVA range and return a bitmap of the dirty bits.
+ * The iova/length must exactly match a range
+ * used with IOMMU_IOAS_PAGETABLE_MAP, or be the values 0 & U64_MAX.
+ * In the latter case all IOVAs will be unmaped.
+ */
+struct iommu_ioas_unmap_dirty {
+	__u32 size;
+	__u32 ioas_id;
+	struct iommufd_dirty_data bitmap;
+};
+#define IOMMU_IOAS_UNMAP_DIRTY _IO(IOMMUFD_TYPE, IOMMUFD_CMD_IOAS_UNMAP_DIRTY)
+
 #endif
-- 
2.17.2

