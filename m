Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65A71513D2F
	for <lists+kvm@lfdr.de>; Thu, 28 Apr 2022 23:11:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352099AbiD1VOw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Apr 2022 17:14:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352071AbiD1VOu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Apr 2022 17:14:50 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33296762B7
        for <kvm@vger.kernel.org>; Thu, 28 Apr 2022 14:11:30 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23SJjjJX015405;
        Thu, 28 Apr 2022 21:11:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=kVqfD5XfKXR4Ni3378Ku4OfK92vLu8R0ghDPVk/lH+c=;
 b=XwZOvEmAaKPOKKGQLn8ZYLkprUZRgyPn0xU7lpcZxnq+7GAmLMUcqmCZmWCX7ocGeSME
 05g8uPMPWGKfmSna5zHqijfyTJVNpZz8kkRi+uiYoGNYHhrjHUgOd1I/MsWnzamUjMjF
 60Z00eA+Cyaj7XJHmtKlaoV2KTFbIq/aeqc+fwKDMUOarjSFmoY/iu0qtTDKWDzvXoZG
 lZrOPuLZiWlcI6CKfGql28Jr0uprB0xlGiaCUDl6N9cghuAHDxHo3lqk1IpJWygXVtDX
 mSTf4g0/m/XCoL2wzuKAF4Co5Pxg5ANVVIoYcIplmQBwz0PH6MgasaarrmAL8ExnajYz Dg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fmb9aw5w8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Apr 2022 21:11:08 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23SL6cIl028689;
        Thu, 28 Apr 2022 21:11:06 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2103.outbound.protection.outlook.com [104.47.55.103])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fp5ype92m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Apr 2022 21:11:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HxKsX8CfhDJ962/r1b8mhnVO8jeWaE1/EFK+ivNGBbokYPKzUbcLdUfBklOmq3BH8IL5jpJnMlGu9pyjGzSszP6Oah2KskyohbC3ad/8rqwmt7767SyCFYoS4mJRmuMH4h/fpJynmFeNEtWd4y4S0FW9aDk+KqhnmFWdOwgM35pxtZ5TgAuKJlqN1gnWBnBuszcm0OKFRHov4B+DVEWKROwDpjFa8ocpENaNwsPsbDGFeokCjvohIqFPgXs1oV22KOWOPGbmVZJH2zs8iHX4QCcgdiMdYZWGDN7MdN4HhiRZHjFzZRjl6jCE8eAmN3oSs+yomqThGsf+djqiYK9c7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kVqfD5XfKXR4Ni3378Ku4OfK92vLu8R0ghDPVk/lH+c=;
 b=bCxrd/OdRuwXsjwZyAlAFzrXkeJeyNOFSutfMZD1ensl920BCxj9IGakFuaDU//Z3zS8N+zYVlRQ20oaT6a+9Z/u+eVOUPOGj7Q2w6tgtJ0M0IpHQeH036sJMW4YUjKygVaVPQAxrPPaxin7S7MBeA6tVTG/VAQWSSYzIRppX0zO3NAp9ucpbmwycMIL350b/E6r0A1WI5wrd2TAQ8HUJwPoGe0l5Ftgit4VwGCkRnvV/MXz3hic9ca/36EHWbTqT6ySi5/QUfEqaWGRajuaK7SBn6hKvMVKujowWcJMfYXHnNUIZr8kjgR+J3aUdlQkyRHk3LoOewWxSvVMek2bdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kVqfD5XfKXR4Ni3378Ku4OfK92vLu8R0ghDPVk/lH+c=;
 b=x53ZbfH8IGPdqfET5vuc+5Hz0DSCmKkdvtWjzJcH8WttsUuDfpF3dWsxtksEQZDv80sOU+xDhEBTTXiYWIflYMVbmiYBu8Y6DrgwSSVLseUbw1lDfeauLHlUJGQBx41Q28+WusT1B60YxJYBtIOs6RQD57A5BXegeAN6plHXKGQ=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by DM5PR10MB1564.namprd10.prod.outlook.com (2603:10b6:3:9::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5186.15; Thu, 28 Apr 2022 21:11:03 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d%5]) with mapi id 15.20.5206.013; Thu, 28 Apr 2022
 21:11:03 +0000
From:   Joao Martins <joao.m.martins@oracle.com>
To:     iommu@lists.linux-foundation.org
Cc:     Joao Martins <joao.m.martins@oracle.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Eric Auger <eric.auger@redhat.com>,
        Yi Liu <yi.l.liu@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH RFC 09/19] iommu/amd: Access/Dirty bit support in IOPTEs
Date:   Thu, 28 Apr 2022 22:09:23 +0100
Message-Id: <20220428210933.3583-10-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20220428210933.3583-1-joao.m.martins@oracle.com>
References: <20220428210933.3583-1-joao.m.martins@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0111.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:c::27) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 423e5b2a-296d-45b9-1991-08da295b9a29
X-MS-TrafficTypeDiagnostic: DM5PR10MB1564:EE_
X-Microsoft-Antispam-PRVS: <DM5PR10MB156463D6558F9F1AC34BB182BBFD9@DM5PR10MB1564.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9VKEuT3q5Jmiw/ANt00JxEJmAqsnibhK2gXXM/pzZ59uc0FGZkJrY/KPvl87Z97q1CHvx2RygRplomxTOpyEpU2YMQd1xGUF0JLvkmg6qO63jHUnjvCzWFHWbm7KPE/3gl5F1sS283p9nC749KXYqrppZHvBOE2G37MiW6GTDhn38cCJVAkFjX8Qyj6oKPz9EBQzq1/L6gG1XK6P/DPGR+BWLEz+L8bcGClNZJxjzumc5Pbha+CcOSLUzZ43DJghjjY0A5yGgoZ01IV0T1PrPMy15o51tUEKIXWMv4ZvtpbuXse4O2p6n6mOnwtiqCgKiEYQB845ofCAVbM8Ghi+rSXuQvBDUrEen13me+sdje/O4UWNmXbkR9dlxikjm5ZPhvHzcKNQFlW+QQLWIatYa4G3iOBFxz9sws/mHAJfj23j3iy8mP2a1fRhMShm+ZP6V8OOw64Y+aUQkZtBn8n5jKLnN/mQJ9PZG/La5tT3wygjb6m3eqsstr6XG5y+UotRS7py9zh0IW0OtotFZ0AqyAsHdCPNllJs2bY8ltt9uo6xX9aM/xrFq2AZBPOIqGJzI0Xh6dGqjxZ1yCafv09GCtQ7qN1rYzHsUzBul44Sf0bqavgEamE0bnp7iXeznKhBD5G4uU/vhclmXD2zhRxZfENVnpIYWI7thFW/uzoel66+PYmZe/IH8Vh5Oun+NN6XdDu644ie7Glo9+ZW7R6Zx0ZRDjXJgsxQzX6DQvWTq54=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(316002)(186003)(86362001)(66946007)(66556008)(4326008)(66476007)(8676002)(2616005)(36756003)(1076003)(103116003)(8936002)(5660300002)(7416002)(30864003)(26005)(6512007)(6486002)(6916009)(83380400001)(54906003)(508600001)(6506007)(38350700002)(38100700002)(6666004)(2906002)(52116002)(14143004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jFthM69qx/k4QUOH8JnJPNp5UYUwJhy1mliTmCGRvyOuLJP9O9hv+7hiNU5k?=
 =?us-ascii?Q?FSatBEzknC38BbiTyypEEx0aauvN6gfw2R04pebKTBDK48ay70TtWxkBwjYo?=
 =?us-ascii?Q?2Q29lKTcMBLnkloAdvX5ZKN2PLujjlfiUJelBZIkaBugMwVFiZcCTKZxw6Gl?=
 =?us-ascii?Q?SJdg11yzDsOSq3PSfFKwyn3ZUMnkBCUsW13S9TfBJ6d95TtBYVFTvz2bDSL5?=
 =?us-ascii?Q?+pSJemBY+DIrlqwHzxCz+uTiCJIzvYaMEOPbdPEXDf03/H2uzZ1AGiyQZODs?=
 =?us-ascii?Q?eevkRPXbkuowFuy8XulHH8u+HP3HbTF/jYTfGG+O2v27i2hz4dZDJcjDm08/?=
 =?us-ascii?Q?rxw6WoT5GpRbeHtz18+MMWR52f7Ypki6lIoaPwtQb7EHgAiGmo/Xj/7YMU9Z?=
 =?us-ascii?Q?qU+/hCG+Jb92Lbc1vU8gTl9cMx3uLJGCu1xg1ePfgnr9a9sQrc+fwg3BoDnr?=
 =?us-ascii?Q?WMOndwCS4mdv0tiGC94l3a8FEXgbu5DET7kG+lonDij5tE8maUAUbQvqu2NM?=
 =?us-ascii?Q?aVJVyCpUTCYyYZH+IBrsf/rwZvJ/mrf1jyzVo5pVkybGc4AbNlIZgpUmzos4?=
 =?us-ascii?Q?+woBLUCHPZ0H//A30T6Dxwg8qvhhm09ghjRUycM3uULd2QSrcjTmiKmz4EXt?=
 =?us-ascii?Q?W3n9uQJmWcwA0IXot4y5uLFzkwTDknjn4F/1MzaTfXuFJKZmsM5Pn5rSWqJ8?=
 =?us-ascii?Q?AB7yCwXhxfeWmDQkWleO2gabQQODv3ibi20MTRdDH7MeyQcnCErAJO3HN+nT?=
 =?us-ascii?Q?gOhpOFu4JoAlzVPY2hEymyaxdpwpts4MwLIEtebn2tT8WzuCoh3eOX6vxsoN?=
 =?us-ascii?Q?A3LT/aFYttOUtBIWkmUlKCRXH3cS00D5CGvgFa+HUb0R1Gt5+4/3d6bmGkZb?=
 =?us-ascii?Q?bhsXR0ckSJcf/CxzQAVIFfe6KkGcf+q6hlUKFTt8DnMxGqMZKjT2DFSqZHe6?=
 =?us-ascii?Q?bIJi4ThQxA8WNBnf4TCPl0JqNirZ8vxTPIVSK5Y4uB4c2Wm9Ds3cWOwbIoaa?=
 =?us-ascii?Q?32pp6cLBVUOB2XeQCniCHfm8zXRim8OxxRc08oRCDf4FKc/ElRr6ozw1KW0j?=
 =?us-ascii?Q?f+gY+BcAi+6GqbwcKIjY0yEc1Slmjpff3H8NTY3O9uDluM2CXCz/POX7stxM?=
 =?us-ascii?Q?hDRlr3bGh/mLfwlSsJNncHRjhEdqEFFWwNXO8C4Qz+9m6DLRACLMxDQWsOXP?=
 =?us-ascii?Q?RDxe3pNlYHFgka2kd3KBFU4eeNfMcZHBVMNXEvltZaL8SgtmHWY6xuIs/F4b?=
 =?us-ascii?Q?F/jvh4fbYczcf6a2Rjv8vkqZmcpAC1oQqu1z8+kZYz8DSNyLyp/vlhHS69AW?=
 =?us-ascii?Q?RXRtO+/9QeazPzVK7s1hSKP9fpQXYGVnwaXg9OB7hkv+XJ7dbxP9MFjCB8zA?=
 =?us-ascii?Q?3/ybA8sFxfi+3hlrUBAadZL/1K3G4397Xr7xhtSsxbENMUiR65xHx7LLc/pq?=
 =?us-ascii?Q?mD/+lVTP6MwgVU814DrI5qM4wJ58tNWvzHyXfaTBnMDY7lS9rcL6hv1m+w0h?=
 =?us-ascii?Q?IpPt42TSgYCnMEp29SNxEKdG6URFzMyRi4mne2i+4AtClYuh+500xJzOW3gi?=
 =?us-ascii?Q?J5Sey+4Ahr5WVaalJMZx66tAtyG0zl8S7e9wLcM2Ch8PhlxM8L7veupT7z63?=
 =?us-ascii?Q?btoLnw99SzwcfBIIjXxWcsL3DQcXbRdqsIOY6zqFgXB6s+AXf8zMNBlHQEzE?=
 =?us-ascii?Q?++F0dzTy2S4MfAt62QHnwPTSCqWi3dlfPATT4mLxNsZSaC5Kt+ZkY45FRC8/?=
 =?us-ascii?Q?pfi1pt/5aAQHE7v+OBcuIwj33mm2QSc=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 423e5b2a-296d-45b9-1991-08da295b9a29
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2022 21:11:03.3524
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +4Avq9wNX2IfauVOTRPvPFsrLy2OvnJcpLW3Ai1vtY9HYa67AfUbFSoKPoJZMlz7kS3OU2ZCx6/bDdUwXmFGUool+/AWZMKRuk19eC4g1kk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB1564
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-28_04:2022-04-28,2022-04-28 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 malwarescore=0 spamscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204280125
X-Proofpoint-ORIG-GUID: 84C8cqd0B2FxFBnAkWn7dMEsjbzbFMGp
X-Proofpoint-GUID: 84C8cqd0B2FxFBnAkWn7dMEsjbzbFMGp
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

IOMMU advertises Access/Dirty bits if the extended feature register
reports it. Relevant AMD IOMMU SDM ref[0]
"1.3.8 Enhanced Support for Access and Dirty Bits"

To enable it set the DTE flag in bits 7 and 8 to enable access, or
access+dirty. With that, the IOMMU starts marking the D and A flags on
every Memory Request or ATS translation request. It is on the VMM side
to steer whether to enable dirty tracking or not, rather than wrongly
doing in IOMMU. Relevant AMD IOMMU SDM ref [0], "Table 7. Device Table
Entry (DTE) Field Definitions" particularly the entry "HAD".

To actually toggle on and off it's relatively simple as it's setting
2 bits on DTE and flush the device DTE cache.

To get what's dirtied use existing AMD io-pgtable support, by walking
the pagetables over each IOVA, with fetch_pte().  The IOTLB flushing is
left to the caller (much like unmap), and iommu_dirty_bitmap_record() is
the one adding page-ranges to invalidate. This allows caller to batch
the flush over a big span of IOVA space, without the iommu wondering
about when to flush.

Worthwhile sections from AMD IOMMU SDM:

"2.2.3.1 Host Access Support"
"2.2.3.2 Host Dirty Support"

For details on how IOMMU hardware updates the dirty bit see,
and expects from its consequent clearing by CPU:

"2.2.7.4 Updating Accessed and Dirty Bits in the Guest Address Tables"
"2.2.7.5 Clearing Accessed and Dirty Bits"

Quoting the SDM:

"The setting of accessed and dirty status bits in the page tables is
visible to both the CPU and the peripheral when sharing guest page
tables. The IOMMU interlocked operations to update A and D bits must be
64-bit operations and naturally aligned on a 64-bit boundary"

.. and for the IOMMU update sequence to Dirty bit, essentially is states:

1. Decodes the read and write intent from the memory access.
2. If P=0 in the page descriptor, fail the access.
3. Compare the A & D bits in the descriptor with the read and write
intent in the request.
4. If the A or D bits need to be updated in the descriptor:
* Start atomic operation.
* Read the descriptor as a 64-bit access.
* If the descriptor no longer appears to require an update, release the
atomic lock with
no further action and continue to step 5.
* Calculate the new A & D bits.
* Write the descriptor as a 64-bit access.
* End atomic operation.
5. Continue to the next stage of translation or to the memory access.

Access/Dirty bits readout also need to consider the default
non-page-size (aka replicated PTEs as mentined by manual), as AMD
supports all powers of two page sizes (except 512G) even though the
underlying IOTLB mappings are restricted to the same ones as supported
by the CPU (4K, 2M, 1G). It makes one wonder whether AMD_IOMMU_PGSIZES
ought to avoid advertising non-default page sizes at all, when creating
an UNMANAGED DOMAIN, or when dirty tracking is toggling in.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
 drivers/iommu/amd/amd_iommu.h       |  1 +
 drivers/iommu/amd/amd_iommu_types.h | 11 +++++
 drivers/iommu/amd/init.c            |  8 ++-
 drivers/iommu/amd/io_pgtable.c      | 56 +++++++++++++++++++++
 drivers/iommu/amd/iommu.c           | 77 +++++++++++++++++++++++++++++
 5 files changed, 152 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/amd/amd_iommu.h b/drivers/iommu/amd/amd_iommu.h
index 1ab31074f5b3..2f16ad8f7514 100644
--- a/drivers/iommu/amd/amd_iommu.h
+++ b/drivers/iommu/amd/amd_iommu.h
@@ -34,6 +34,7 @@ extern int amd_iommu_reenable(int);
 extern int amd_iommu_enable_faulting(void);
 extern int amd_iommu_guest_ir;
 extern enum io_pgtable_fmt amd_iommu_pgtable;
+extern bool amd_iommu_had_support;
 
 /* IOMMUv2 specific functions */
 struct iommu_domain;
diff --git a/drivers/iommu/amd/amd_iommu_types.h b/drivers/iommu/amd/amd_iommu_types.h
index 47108ed44fbb..c1eba8fce4bb 100644
--- a/drivers/iommu/amd/amd_iommu_types.h
+++ b/drivers/iommu/amd/amd_iommu_types.h
@@ -93,7 +93,9 @@
 #define FEATURE_HE		(1ULL<<8)
 #define FEATURE_PC		(1ULL<<9)
 #define FEATURE_GAM_VAPIC	(1ULL<<21)
+#define FEATURE_HASUP		(1ULL<<49)
 #define FEATURE_EPHSUP		(1ULL<<50)
+#define FEATURE_HDSUP		(1ULL<<52)
 #define FEATURE_SNP		(1ULL<<63)
 
 #define FEATURE_PASID_SHIFT	32
@@ -197,6 +199,7 @@
 /* macros and definitions for device table entries */
 #define DEV_ENTRY_VALID         0x00
 #define DEV_ENTRY_TRANSLATION   0x01
+#define DEV_ENTRY_HAD           0x07
 #define DEV_ENTRY_PPR           0x34
 #define DEV_ENTRY_IR            0x3d
 #define DEV_ENTRY_IW            0x3e
@@ -350,10 +353,16 @@
 #define PTE_LEVEL_PAGE_SIZE(level)			\
 	(1ULL << (12 + (9 * (level))))
 
+/*
+ * The IOPTE dirty bit
+ */
+#define IOMMU_PTE_HD_BIT (6)
+
 /*
  * Bit value definition for I/O PTE fields
  */
 #define IOMMU_PTE_PR (1ULL << 0)
+#define IOMMU_PTE_HD (1ULL << IOMMU_PTE_HD_BIT)
 #define IOMMU_PTE_U  (1ULL << 59)
 #define IOMMU_PTE_FC (1ULL << 60)
 #define IOMMU_PTE_IR (1ULL << 61)
@@ -364,6 +373,7 @@
  */
 #define DTE_FLAG_V  (1ULL << 0)
 #define DTE_FLAG_TV (1ULL << 1)
+#define DTE_FLAG_HAD (3ULL << 7)
 #define DTE_FLAG_IR (1ULL << 61)
 #define DTE_FLAG_IW (1ULL << 62)
 
@@ -390,6 +400,7 @@
 
 #define IOMMU_PAGE_MASK (((1ULL << 52) - 1) & ~0xfffULL)
 #define IOMMU_PTE_PRESENT(pte) ((pte) & IOMMU_PTE_PR)
+#define IOMMU_PTE_DIRTY(pte) ((pte) & IOMMU_PTE_HD)
 #define IOMMU_PTE_PAGE(pte) (iommu_phys_to_virt((pte) & IOMMU_PAGE_MASK))
 #define IOMMU_PTE_MODE(pte) (((pte) >> 9) & 0x07)
 
diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index b4a798c7b347..27f2cf61d0c6 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -149,6 +149,7 @@ struct ivmd_header {
 
 bool amd_iommu_dump;
 bool amd_iommu_irq_remap __read_mostly;
+bool amd_iommu_had_support __read_mostly;
 
 enum io_pgtable_fmt amd_iommu_pgtable = AMD_IOMMU_V1;
 
@@ -1986,8 +1987,13 @@ static int __init amd_iommu_init_pci(void)
 	for_each_iommu(iommu)
 		iommu_flush_all_caches(iommu);
 
-	if (!ret)
+	if (!ret) {
+		if (check_feature_on_all_iommus(FEATURE_HASUP) &&
+		    check_feature_on_all_iommus(FEATURE_HDSUP))
+			amd_iommu_had_support = true;
+
 		print_iommu_info();
+	}
 
 out:
 	return ret;
diff --git a/drivers/iommu/amd/io_pgtable.c b/drivers/iommu/amd/io_pgtable.c
index 6608d1717574..8325ef193093 100644
--- a/drivers/iommu/amd/io_pgtable.c
+++ b/drivers/iommu/amd/io_pgtable.c
@@ -478,6 +478,61 @@ static phys_addr_t iommu_v1_iova_to_phys(struct io_pgtable_ops *ops, unsigned lo
 	return (__pte & ~offset_mask) | (iova & offset_mask);
 }
 
+static bool pte_test_and_clear_dirty(u64 *ptep, unsigned long size)
+{
+	bool dirty = false;
+	int i, count;
+
+	/*
+	 * 2.2.3.2 Host Dirty Support
+	 * When a non-default page size is used , software must OR the
+	 * Dirty bits in all of the replicated host PTEs used to map
+	 * the page. The IOMMU does not guarantee the Dirty bits are
+	 * set in all of the replicated PTEs. Any portion of the page
+	 * may have been written even if the Dirty bit is set in only
+	 * one of the replicated PTEs.
+	 */
+	count = PAGE_SIZE_PTE_COUNT(size);
+	for (i = 0; i < count; i++)
+		if (test_and_clear_bit(IOMMU_PTE_HD_BIT,
+					(unsigned long *) &ptep[i]))
+			dirty = true;
+
+	return dirty;
+}
+
+static int iommu_v1_read_and_clear_dirty(struct io_pgtable_ops *ops,
+					 unsigned long iova, size_t size,
+					 struct iommu_dirty_bitmap *dirty)
+{
+	struct amd_io_pgtable *pgtable = io_pgtable_ops_to_data(ops);
+	unsigned long end = iova + size - 1;
+
+	do {
+		unsigned long pgsize = 0;
+		u64 *ptep, pte;
+
+		ptep = fetch_pte(pgtable, iova, &pgsize);
+		if (ptep)
+			pte = READ_ONCE(*ptep);
+		if (!ptep || !IOMMU_PTE_PRESENT(pte)) {
+			pgsize = pgsize ?: PTE_LEVEL_PAGE_SIZE(0);
+			iova += pgsize;
+			continue;
+		}
+
+		/*
+		 * Mark the whole IOVA range as dirty even if only one of
+		 * the replicated PTEs were marked dirty.
+		 */
+		if (pte_test_and_clear_dirty(ptep, pgsize))
+			iommu_dirty_bitmap_record(dirty, iova, pgsize);
+		iova += pgsize;
+	} while (iova < end);
+
+	return 0;
+}
+
 /*
  * ----------------------------------------------------
  */
@@ -519,6 +574,7 @@ static struct io_pgtable *v1_alloc_pgtable(struct io_pgtable_cfg *cfg, void *coo
 	pgtable->iop.ops.map          = iommu_v1_map_page;
 	pgtable->iop.ops.unmap        = iommu_v1_unmap_page;
 	pgtable->iop.ops.iova_to_phys = iommu_v1_iova_to_phys;
+	pgtable->iop.ops.read_and_clear_dirty = iommu_v1_read_and_clear_dirty;
 
 	return &pgtable->iop;
 }
diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index a1ada7bff44e..0a86392b2367 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -2169,6 +2169,81 @@ static bool amd_iommu_capable(enum iommu_cap cap)
 	return false;
 }
 
+static int amd_iommu_set_dirty_tracking(struct iommu_domain *domain,
+					bool enable)
+{
+	struct protection_domain *pdomain = to_pdomain(domain);
+	struct iommu_dev_data *dev_data;
+	bool dom_flush = false;
+
+	if (!amd_iommu_had_support)
+		return -EOPNOTSUPP;
+
+	list_for_each_entry(dev_data, &pdomain->dev_list, list) {
+		struct amd_iommu *iommu;
+		u64 pte_root;
+
+		iommu = amd_iommu_rlookup_table[dev_data->devid];
+		pte_root = amd_iommu_dev_table[dev_data->devid].data[0];
+
+		/* No change? */
+		if (!(enable ^ !!(pte_root & DTE_FLAG_HAD)))
+			continue;
+
+		pte_root = (enable ?
+			pte_root | DTE_FLAG_HAD : pte_root & ~DTE_FLAG_HAD);
+
+		/* Flush device DTE */
+		amd_iommu_dev_table[dev_data->devid].data[0] = pte_root;
+		device_flush_dte(dev_data);
+		dom_flush = true;
+	}
+
+	/* Flush IOTLB to mark IOPTE dirty on the next translation(s) */
+	if (dom_flush) {
+		unsigned long flags;
+
+		spin_lock_irqsave(&pdomain->lock, flags);
+		amd_iommu_domain_flush_tlb_pde(pdomain);
+		amd_iommu_domain_flush_complete(pdomain);
+		spin_unlock_irqrestore(&pdomain->lock, flags);
+	}
+
+	return 0;
+}
+
+static bool amd_iommu_get_dirty_tracking(struct iommu_domain *domain)
+{
+	struct protection_domain *pdomain = to_pdomain(domain);
+	struct iommu_dev_data *dev_data;
+	u64 dte;
+
+	list_for_each_entry(dev_data, &pdomain->dev_list, list) {
+		dte = amd_iommu_dev_table[dev_data->devid].data[0];
+		if (!(dte & DTE_FLAG_HAD))
+			return false;
+	}
+
+	return true;
+}
+
+static int amd_iommu_read_and_clear_dirty(struct iommu_domain *domain,
+					  unsigned long iova, size_t size,
+					  struct iommu_dirty_bitmap *dirty)
+{
+	struct protection_domain *pdomain = to_pdomain(domain);
+	struct io_pgtable_ops *ops = &pdomain->iop.iop.ops;
+
+	if (!amd_iommu_get_dirty_tracking(domain))
+		return -EOPNOTSUPP;
+
+	if (!ops || !ops->read_and_clear_dirty)
+		return -ENODEV;
+
+	return ops->read_and_clear_dirty(ops, iova, size, dirty);
+}
+
+
 static void amd_iommu_get_resv_regions(struct device *dev,
 				       struct list_head *head)
 {
@@ -2293,6 +2368,8 @@ const struct iommu_ops amd_iommu_ops = {
 		.flush_iotlb_all = amd_iommu_flush_iotlb_all,
 		.iotlb_sync	= amd_iommu_iotlb_sync,
 		.free		= amd_iommu_domain_free,
+		.set_dirty_tracking = amd_iommu_set_dirty_tracking,
+		.read_and_clear_dirty = amd_iommu_read_and_clear_dirty,
 	}
 };
 
-- 
2.17.2

