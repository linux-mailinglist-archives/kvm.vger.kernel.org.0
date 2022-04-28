Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66664513D51
	for <lists+kvm@lfdr.de>; Thu, 28 Apr 2022 23:16:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352190AbiD1VSe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Apr 2022 17:18:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352192AbiD1VS1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Apr 2022 17:18:27 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8819F275C0
        for <kvm@vger.kernel.org>; Thu, 28 Apr 2022 14:15:08 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23SJYOGQ015530;
        Thu, 28 Apr 2022 21:14:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=txCHzuOEOW2KsobJEQMBWnCO0cAvkwT+E9R/ZoKOBZI=;
 b=VwwrzdyttHK3uf8LqpyMs2ahpIrFiEzYfFdfm/gmQg+9yC5oIDYhnE1G1mPzbW+z44Un
 IpRSTbdvbb8wrF4NTcfuETAVoGcMH5ZwEzOr2xyOc3p4bQTkUHTLxMPJzKFJsfX5gllP
 HGIrI+yDmbFLNhdr278rjo5WIjdNwT+uLdkI+fsN1zpFye0XmQn5nJpE6ZNP52v9kYx3
 R1JctZHMEB9F2lbr4uTLOWsXwc0PdnysVnrNeSWCQtoiq/kDNQ6mw42Aok1omwZXmMFH
 iMr6t0U4tFn3SdMNJSrg6t1T52q4IyWcn/zhCYswIervzxPqvl64hOH2GFWNi5BAuOdf LA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fmb9aw63m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Apr 2022 21:14:41 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23SL6cY7028682;
        Thu, 28 Apr 2022 21:14:40 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2176.outbound.protection.outlook.com [104.47.58.176])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fp5ypebtx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Apr 2022 21:14:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AAoux9//BsVA4miVmcjDOCgcVJLv4OI7sUTXp5yhF+wD9XClLdQQlBVCPeW5SWx9Es1NX/W39hdWNcj2loBlPQ/AXSw8w6e7IRxeJPX2GvPJdWG7t+nL83wHM1XG5I5rs+2cNdfUhVxB7RhB6d+YcMVVV0RjnFjSgqbXpWnBCLle6d1MvBcwA3vGhoVSNJli+2/FEPpBjh9L9tK04Jkxh4w1+XGpBtT6giFOxnNyCVthoGDxvxJgIzYbqg4vYCL+zHRDvBbsdX5Y9QLNZEBkgVu17mU7pNnellMvxnJC1eoRfX0l4fSszUlXx1unZtY5mCQdS/TeT8EPBBpA/KRmhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=txCHzuOEOW2KsobJEQMBWnCO0cAvkwT+E9R/ZoKOBZI=;
 b=lWTkWSjNllsHaNICfaHfBnFjn5AR9nIXYtP10nFnLrMzQFF1CJE9954wmbpiKjxvSxc3t7G9fE0A1XE8eNXj8Y2UDSmE5bVScooFayQDsXQDC7kIUc2NjVP4Wo+RYPmsd4KXef3vX3OQClkBuHlEP4VaeKokFXBcoDbKvdYxHfxipYIVWqWEqb2iUtIuYCmyWW69mhDR6tl8A3vLjtRXLchi+Tn2KmHu95TiBIgyOMIFttmiDCodSx8CbTNkN+ElHh/Dc9phR79gdT8wS5toChFCnU7aiLd04TnIdr42zW45wwnRlI0XC1QvFzVvyoH793lVW0uJHKFnEYICvCFSYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=txCHzuOEOW2KsobJEQMBWnCO0cAvkwT+E9R/ZoKOBZI=;
 b=mQK5YmQ6q0blNLUJE0SAJ8iHDat62qaQBQ6CMse4gP3XvtIjouvEaX+LKeYv/7US4Q8vb2Vjc5Q+RTkcZ/ZGCMLqd5QBIWvv8CrMYzw0GaAQGMDKFPt0eHd40BKAgEWB6UpiaXOJ/IyP1dCePnUy4EJgqPSFOtLFPIsFC7glTwc=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by DM6PR10MB3260.namprd10.prod.outlook.com (2603:10b6:5:1ab::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Thu, 28 Apr
 2022 21:14:35 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d%5]) with mapi id 15.20.5206.013; Thu, 28 Apr 2022
 21:14:35 +0000
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
Subject: [PATCH RFC 06/10] vfio/iommufd: Add HWPT_SET_DIRTY support
Date:   Thu, 28 Apr 2022 22:13:47 +0100
Message-Id: <20220428211351.3897-7-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20220428211351.3897-1-joao.m.martins@oracle.com>
References: <20220428211351.3897-1-joao.m.martins@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0297.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a5::21) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ed741271-f689-461f-8ca8-08da295c189f
X-MS-TrafficTypeDiagnostic: DM6PR10MB3260:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB3260BE906BD6E68A9A544532BBFD9@DM6PR10MB3260.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sGTNojx8FBtppPqKUagGRp/6tjfRgE1cvwxO29J6wlRPbJ31DGCr+JUKI905/rCCcolDSqPtvEHZyiPGIQBBx5g/REIXXXr3M+SePQt9g1RfVy0tasICvgQzksX4qwGXWS47IL1EXnQ+DlORfiRjCOszFFtyq/n9/Rp2+VUgL395xc9/HmUFeek745qX7e8nT8GvGPsRWo0hdlNP2cgDIb72naj1q3QD/OoZce/KF7T6AUH/oow3/gpN3lSMh/QgRpLGub5SSygbbUpNa8jwCyLJIfV8iGfK2rek6dA8DYjedOT+pDroJ0BJmCs+gO77dvVWpNr+f8aef7fX48tmcmn4dBnz8ICPfCc/3NcuCduklF26B8+luO2i7r3qlUEIyL+wcpl9XzErlDNJClv8e70vM+vStZakd0KrP5Ke+YIyFd2JdSynk2qT8Flim6to+pKDLPzo5qE7wAgaqki6WpqHpHXLjqN2Gw1v5d2aGI0SoVseEOIqQ7jlqlIalftCay0QRgYD5GeiR2AGMZAmCDJrO1bOTje+McTWbqAgZpDN4plungHP9L9z3SUcDOQlIylbhgZGJuN/kHdbOheYGKN8HiBvQZhXSVsqfHakGPwSjL/rMyKEQ7WPjW8Sbu7wJme5ABDpt5GOCmSLmIjIgHT1V5sCnmZlXgh/xM8avTn+69Qv44yoOJKi6w4uxQGH18t20D41VgaZvn0KVqO24efmwjXOYk96C+l1OUtHzXM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(5660300002)(66476007)(66556008)(2616005)(1076003)(186003)(54906003)(103116003)(6506007)(36756003)(6512007)(6666004)(26005)(52116002)(316002)(8676002)(66946007)(83380400001)(6916009)(8936002)(7416002)(4326008)(508600001)(2906002)(38350700002)(38100700002)(86362001)(6486002)(14143004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tq2c3Yi0YiPJEgcRO1KgJexBITh6Dvs6mKWoZMVqWZUjpJrdMHgtFThRQ1u8?=
 =?us-ascii?Q?XbgBic1TcXAbRqxxiuwJ4Bj9pxmvsAWKSD+jwE/hQLgsfhq9CEZSfFsBoEvw?=
 =?us-ascii?Q?InrsfgbxYvNXAhPtcC1xek9EHB+wcsrp6Oe/0WMZvk4/ang4p+UoxV5can8H?=
 =?us-ascii?Q?IndbS0yiafI6ZmEbZOK3pdHVd4qY6+xNrlgw+dk2sskFfIj0mWpaffg+Nm4p?=
 =?us-ascii?Q?4zJ4JY7odsaWHElj6OzMhMXBAg/diZ6j6C6lXjBAdrw8ccHoeRuU13lqo136?=
 =?us-ascii?Q?A1pmoQLVJ8ReDGvhM4yKgu8wyw3lctWFt+KnqlSezqoR6pYAey28Qmebfb0Y?=
 =?us-ascii?Q?nJkTjytivqO7PHQy4fTbMOX3RA6SWHOPiOrfaIziGxpLcWGrOZu/zsbLURUO?=
 =?us-ascii?Q?hlfixGF6BtnSq5bbyAMXTPdxTgCKTBBfQImC2YTMPlN1W3QunedKLYbIbSVg?=
 =?us-ascii?Q?KNsTjWebFvw1kfd7vT5/u3Ddz++19M2Z3w46Z1Mq2j6yMja2HBfKTvW7rnCQ?=
 =?us-ascii?Q?OstchE1Kng+L9qDFIi9zy+HYTme++wvspyQLh7pqkyaL8wF0tDsqYYc4UgVq?=
 =?us-ascii?Q?+CwYHkWtiM1gzqZSsTt2zfdu4o1EwAuMYE7VoEekdOEPI12f1vhmW1pLNo4O?=
 =?us-ascii?Q?ld78JzI8oehdBHcMkNjEJwxq7HLGJz7jXnQspyaIjCccidpDyCswI0fu/vxI?=
 =?us-ascii?Q?3+K9uo9CRx555UaQKK8MfD4Z33l0ytNYFh8rqEypoyVbVeeMN5w1ntG2BlbA?=
 =?us-ascii?Q?cj25yTMQn77gRkLqwiIHsviUHmwuiPmiV4Vtg80nNT6dIDmI90TdRg1BWlZt?=
 =?us-ascii?Q?qM6pWYNREthFCsE7JxDrXYk8JiF5N16kXRnCfpjgLIrdw31VrdTSBuG1bPjt?=
 =?us-ascii?Q?fIAJCWylg8Rp6wPkP4io2pLbrV+QmeT1jQ1OU9/aAEm442vZunALgTOOkrRK?=
 =?us-ascii?Q?f0xt6y05dzYQSvexKr4EmzwqRn1S9WbxIaXH6d7ZAwxSbZlrDqFpVtGpKVvZ?=
 =?us-ascii?Q?2QW37BvwMoBwsq/KRXs8IUXplE2pq1scwUgFnnWOLJJ92ycBwQxHt5hWla9J?=
 =?us-ascii?Q?v5p2peJ8NsjS0UWXT6Psf/1YS+qVmxgxxgz6yiY0R165dvsp1f8uUjy9R95V?=
 =?us-ascii?Q?wtkP1MAN8r1QOLO7HsKc7CfSGFfqDrR6MgusI60HjoTguMeL1gDXV6zEXn2r?=
 =?us-ascii?Q?mdZs9xXE4Knst+LmWjeh0XF5JvpjUwoay4i8U6xaS5HiJFjmYj/V24QLl+yJ?=
 =?us-ascii?Q?Ph0pQWaM1ijqJ1NX6HPh6SkpZzKsDB9pFBjI+GNMo+tb9FPCWNMDQcnaInnT?=
 =?us-ascii?Q?7dAxBR+TKPnnv7qIfpgEXgyHjiMtQMx4rp9j1ZhB0olsn1wKl05ksrojY4Tw?=
 =?us-ascii?Q?YGetTRkMSqUGFlxRJKeKgx6eDLTWLxVTXMB+PvppzyL0q4GeJGiEEY1q+/7H?=
 =?us-ascii?Q?7Fiq116CAaTxuV5CRltPi64aOj9dUQ6qz0J28WrWUnv92Oxp0vqJA6sAiEhv?=
 =?us-ascii?Q?J6rqvusNfzy03IfslB0jtp5+YAKaH96uz4il/vif+dgyoyRwSlYO7WG4gbvz?=
 =?us-ascii?Q?ME7Z48pfSyTDA4oRv/Fm8G/+vnA3ipDgrVmxZS0htpALcHVS1oy7SQddF2qJ?=
 =?us-ascii?Q?BraTKUlDpaaq6hqnRrQI3SwD+5crQr5wEagLglhaqU8tIDb3Tit3t+1BsLRP?=
 =?us-ascii?Q?eITGMAFZj6R3zLTUiyvKxYwywGoPnrarmDWcVTRUxOXXr3Xe2M9nWO63KCkC?=
 =?us-ascii?Q?b6wQ6jp5GsDv7eeCSPx7QPSSzt8f0d8=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed741271-f689-461f-8ca8-08da295c189f
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2022 21:14:35.7563
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MEszHvyVMOtwefZ+dvTcj4WEQ6eY6I/61Wb9BUCTYBWFwIfqwXG5q0J3FAz8Z0PBe+r+ypglg4k9RGxjZrVyEjkfvHQve1JaSkdefp8aj54=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3260
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-28_04:2022-04-28,2022-04-28 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 malwarescore=0 spamscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204280125
X-Proofpoint-ORIG-GUID: HVg2nRxLb3d0JbcytKE367y1SYo3Dm-T
X-Proofpoint-GUID: HVg2nRxLb3d0JbcytKE367y1SYo3Dm-T
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

ioctl(iommufd, IOMMU_HWPT_SET_DIRTY, arg) is the UAPI
that enables or disables dirty page tracking. We set it
on the whole list of iommu domains we are tracking, and
set ::dirty_pages_supported accordingly, used when we
attempt at reading out the dirty bits from the hw pagetables.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
 hw/iommufd/iommufd.c         | 18 ++++++++++++
 hw/iommufd/trace-events      |  1 +
 hw/vfio/iommufd.c            | 57 ++++++++++++++++++++++++++++++++++++
 include/hw/iommufd/iommufd.h |  1 +
 4 files changed, 77 insertions(+)

diff --git a/hw/iommufd/iommufd.c b/hw/iommufd/iommufd.c
index 4e8179d612a5..e5aff5deaf14 100644
--- a/hw/iommufd/iommufd.c
+++ b/hw/iommufd/iommufd.c
@@ -201,6 +201,24 @@ int iommufd_copy_dma(int iommufd, uint32_t src_ioas, uint32_t dst_ioas,
     return !ret ? 0 : -errno;
 }
 
+int iommufd_set_dirty_tracking(int iommufd, uint32_t hwpt_id, bool start)
+{
+    int ret;
+    struct iommu_hwpt_set_dirty set_dirty = {
+            .size = sizeof(set_dirty),
+            .hwpt_id = hwpt_id,
+            .flags = !start ? IOMMU_DIRTY_TRACKING_DISABLED :
+                        IOMMU_DIRTY_TRACKING_ENABLED,
+    };
+
+    ret = ioctl(iommufd, IOMMU_HWPT_SET_DIRTY, &set_dirty);
+    trace_iommufd_set_dirty(iommufd, hwpt_id, start, ret);
+    if (ret) {
+        error_report("IOMMU_HWPT_SET_DIRTY failed: %s", strerror(errno));
+    }
+    return !ret ? 0 : -errno;
+}
+
 static void iommufd_register_types(void)
 {
     qemu_mutex_init(&iommufd_lock);
diff --git a/hw/iommufd/trace-events b/hw/iommufd/trace-events
index 615d80cdf42c..d3c2b5a0ab95 100644
--- a/hw/iommufd/trace-events
+++ b/hw/iommufd/trace-events
@@ -9,3 +9,4 @@ iommufd_put_ioas(int iommufd, uint32_t ioas) " iommufd=%d ioas=%d"
 iommufd_unmap_dma(int iommufd, uint32_t ioas, uint64_t iova, uint64_t size, int ret) " iommufd=%d ioas=%d iova=0x%"PRIx64" size=0x%"PRIx64" (%d)"
 iommufd_map_dma(int iommufd, uint32_t ioas, uint64_t iova, uint64_t size, void *vaddr, bool readonly, int ret) " iommufd=%d ioas=%d iova=0x%"PRIx64" size=0x%"PRIx64" addr=%p readonly=%d (%d)"
 iommufd_copy_dma(int iommufd, uint32_t src_ioas, uint32_t dst_ioas, uint64_t iova, uint64_t size, bool readonly, int ret) " iommufd=%d src_ioas=%d dst_ioas=%d iova=0x%"PRIx64" size=0x%"PRIx64" readonly=%d (%d)"
+iommufd_set_dirty(int iommufd, uint32_t hwpt_id, bool start, int ret) " iommufd=%d hwpt=%d enable=%d (%d)"
diff --git a/hw/vfio/iommufd.c b/hw/vfio/iommufd.c
index 8ff5988b0773..8146407feedd 100644
--- a/hw/vfio/iommufd.c
+++ b/hw/vfio/iommufd.c
@@ -33,6 +33,7 @@
 #include "hw/qdev-core.h"
 #include "sysemu/reset.h"
 #include "qemu/cutils.h"
+#include "migration/migration.h"
 
 static bool iommufd_check_extension(VFIOContainer *bcontainer,
                                     VFIOContainerFeature feat)
@@ -82,6 +83,25 @@ static int iommufd_unmap(VFIOContainer *bcontainer,
                              container->ioas_id, iova, size);
 }
 
+static void iommufd_set_dirty_page_tracking(VFIOContainer *bcontainer,
+                                            bool start)
+{
+    VFIOIOMMUFDContainer *container = container_of(bcontainer,
+                                                   VFIOIOMMUFDContainer, obj);
+    int ret;
+    VFIOIOASHwpt *hwpt;
+
+    QLIST_FOREACH(hwpt, &container->hwpt_list, next) {
+        ret = iommufd_set_dirty_tracking(container->iommufd,
+                                         hwpt->hwpt_id, start);
+        if (ret) {
+            return;
+        }
+    }
+
+    bcontainer->dirty_pages_supported = start;
+}
+
 static int vfio_get_devicefd(const char *sysfs_path, Error **errp)
 {
     long int vfio_id = -1, ret = -ENOTTY;
@@ -304,6 +324,40 @@ static int vfio_device_reset(VFIODevice *vbasedev)
     return 0;
 }
 
+static bool vfio_iommufd_devices_all_dirty_tracking(VFIOContainer *bcontainer)
+{
+    MigrationState *ms = migrate_get_current();
+    VFIOIOMMUFDContainer *container;
+    VFIODevice *vbasedev;
+    VFIOIOASHwpt *hwpt;
+
+    if (bcontainer->dirty_pages_supported) {
+        return true;
+    }
+
+    if (!migration_is_setup_or_active(ms->state)) {
+        return false;
+    }
+
+    container = container_of(bcontainer, VFIOIOMMUFDContainer, obj);
+
+    QLIST_FOREACH(hwpt, &container->hwpt_list, next) {
+        QLIST_FOREACH(vbasedev, &hwpt->device_list, hwpt_next) {
+            VFIOMigration *migration = vbasedev->migration;
+
+            if (!migration) {
+                return false;
+            }
+
+            if ((vbasedev->pre_copy_dirty_page_tracking == ON_OFF_AUTO_OFF)
+                && (migration->device_state & VFIO_DEVICE_STATE_RUNNING)) {
+                return false;
+            }
+        }
+    }
+    return true;
+}
+
 static int vfio_iommufd_container_reset(VFIOContainer *bcontainer)
 {
     VFIOIOMMUFDContainer *container;
@@ -446,6 +500,7 @@ static int iommufd_attach_device(VFIODevice *vbasedev, AddressSpace *as,
      */
 
     vfio_as_add_container(space, bcontainer);
+    bcontainer->dirty_pages_supported = true;
     bcontainer->initialized = true;
 
 out:
@@ -554,6 +609,8 @@ static void vfio_iommufd_class_init(ObjectClass *klass,
     vccs->attach_device = iommufd_attach_device;
     vccs->detach_device = iommufd_detach_device;
     vccs->reset = vfio_iommufd_container_reset;
+    vccs->devices_all_dirty_tracking = vfio_iommufd_devices_all_dirty_tracking;
+    vccs->set_dirty_page_tracking = iommufd_set_dirty_page_tracking;
 }
 
 static const TypeInfo vfio_iommufd_info = {
diff --git a/include/hw/iommufd/iommufd.h b/include/hw/iommufd/iommufd.h
index 59835cddcacf..61fd83771099 100644
--- a/include/hw/iommufd/iommufd.h
+++ b/include/hw/iommufd/iommufd.h
@@ -33,5 +33,6 @@ int iommufd_map_dma(int iommufd, uint32_t ioas, hwaddr iova,
                     ram_addr_t size, void *vaddr, bool readonly);
 int iommufd_copy_dma(int iommufd, uint32_t src_ioas, uint32_t dst_ioas,
                      hwaddr iova, ram_addr_t size, bool readonly);
+int iommufd_set_dirty_tracking(int iommufd, uint32_t hwpt_id, bool start);
 bool iommufd_supported(void);
 #endif /* HW_IOMMUFD_IOMMUFD_H */
-- 
2.17.2

