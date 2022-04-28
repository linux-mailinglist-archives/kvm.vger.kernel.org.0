Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66709513D23
	for <lists+kvm@lfdr.de>; Thu, 28 Apr 2022 23:11:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352070AbiD1VOc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Apr 2022 17:14:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237080AbiD1VOa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Apr 2022 17:14:30 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32A8772E01
        for <kvm@vger.kernel.org>; Thu, 28 Apr 2022 14:11:13 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23SIa795032133;
        Thu, 28 Apr 2022 21:10:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=cFM7XtEkFLs8EgVppozaHsq3EO6f+xsO2BF7x6xS/jM=;
 b=fOikvEKgxf9BHzxt5G3MReIcHwIGixMXe9v6ZLMHcHptdxlY+vtrH34/N8kWByIYt/2j
 Tm85D2pca984ASY68plngAYLEfg2JEQP1fgbnsMnpoR001DZxb5n7mGxf0nYxJTYrbtS
 PuvWFInYyfemjRbe9JCcBXT9E9ddSajkeNekBxDsMrUeQXYhH4jumxQtdvr+3q4yXJtR
 2tE4uniWjPDX7kE7UPWabVJkMwVJ5SctTL6GlsSjwBHZQYu4XyGyIIXL/bsOM/KUq8q7
 +vB7cvybEdBh1PVFfNNEgXuwFAZ0sDgBemX/9WHAcGMcmTRn2G0rYOS2UzcVJFeCg8Mu GA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fmb104nc6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Apr 2022 21:10:40 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23SL6cxn028681;
        Thu, 28 Apr 2022 21:10:35 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fp5ype8q6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Apr 2022 21:10:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bt59uoaEQarxTCLjFCdsKuOldo5VR4q4BZGXn/LLd7DG50T+SuLtyeD5U12ia5/gNs46JJE8XkMnVaM8eR6JGMJpKU4bxxHRieyvLmJt1Fy0Mm7BMjTN0XNpxOO4x/1Cg1dB7qofv/2ftTgswjquP8ZkdrKtaD+Z3khaAtK4fK6yaoKg0afk5jPrkIcfDHdJ/91ZAJzcLIfeSKeAhg1VIU8GIrDbDF2zeonZHQSQ/uAmU1edMy5vZtnlK7ZKfaGxKBOsNolDkNGoTw2RXJmhzbLnB3RefRDXQBkEQ2kUeZhFl8J6zshIndoKd/cIuDOa064tYnfgUMlymSirRCgqEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cFM7XtEkFLs8EgVppozaHsq3EO6f+xsO2BF7x6xS/jM=;
 b=StRgOsjXbxkj4y0gLHMeXJmqiO9/R03z102/flz7VL/sg/VB1nwZCYPhMEgmkvIyl4JRD/SUR7ns1u/upTvd0GJqLswNHC0XKeCvDxkkssLSf2EtbtsadpVDgjDXIZ8OkiGIipQkvIiOLco5fJJXhnLBCfpIcahWf4DSAE0D/U1Jyw2ZXRJ9b0WH+oergnzBlw/6ifCM07Bt2Qatvbn0WGmXpvCuFO9JdtphTUlaSQuq3C0IHea4zJh4CUmLMhltCNCyZfjYFaiSY6hOZWWGaajxTkh7hPOk2FpmlPnTWPFn9VO2T6GfBeiBQiAr6ygiUqQExLHAPfC6ILnlEdeb1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cFM7XtEkFLs8EgVppozaHsq3EO6f+xsO2BF7x6xS/jM=;
 b=L4Ntj16RvTPWf4c1Tvy6De4S4ocg+YxzXEcafH9OxejlngQSUF7VUlDv9QXgXLoNUBkEt6G4hHTtDh6a7r261mcAVUI209EL7Ybhp8x9g/XpgSHETWReaTYelVs4I4UYh3/wsVC4D8GjXDaPkeHbQX/wYGSQHBimfBc2SDoU1eo=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by DM5PR10MB1564.namprd10.prod.outlook.com (2603:10b6:3:9::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5186.15; Thu, 28 Apr 2022 21:10:33 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d%5]) with mapi id 15.20.5206.013; Thu, 28 Apr 2022
 21:10:33 +0000
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
Subject: [PATCH RFC 01/19] iommu: Add iommu_domain ops for dirty tracking
Date:   Thu, 28 Apr 2022 22:09:15 +0100
Message-Id: <20220428210933.3583-2-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20220428210933.3583-1-joao.m.martins@oracle.com>
References: <20220428210933.3583-1-joao.m.martins@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0111.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:c::27) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 36719e01-f16a-45ce-fde7-08da295b880b
X-MS-TrafficTypeDiagnostic: DM5PR10MB1564:EE_
X-Microsoft-Antispam-PRVS: <DM5PR10MB1564F13903A409CAF0344121BBFD9@DM5PR10MB1564.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3QTpOb0DnslDAH3ChRPttQE+DnIHCyux29aCjTkC15KpMEBug6N1prnoR0WEb2BU4rFLUpBqin0SfK4LWncC7/1eojYo16pO83F18FUqCYtl89pP/kZ93084BCgxVIYgltozcbWbh4PX50jAp5eGHNUMGdOSSKUnbUCUPkv0sATDLG8eRIusdPQSt/rSzpwlUhITYy8ITrjRWV8jmXEHOLNgNlaHtyHJc6DHySwn+SYxUF5MyR5HQI4o4F6ce/OhzV35v9p8lnJsdoL+P5CHzJS5iLzi/rMkM7OnaY0N/x9m1XFbMAjYrQ59gIU+0zVT06+0hzvNJMB48vxHhyyw38aPG8tXkPCu8EjpmuF9nH/50rt8xAe0ijwY28stWj6NBpq/N2IbaI72AQK/aAYKDqiqK0UXR7cVXRiUrFESHbi07v+VhO/C4nqC4oPB2WaZ8e+00JNwxBLeeNu1H+Y4qPfb/3/JmGzmHHAIuZQIcbbJ/rSoCdtL7M7DxCQVXBA9HWzoT3r75EZ48qUISPOKleUqU2eDaMi1jYl+tTSn+x37JEKkr/Z0CRRKpPqcsoZO2i3YVuuPLJ8F/tHSgUvyXsplAPDL6CLhEFHH8y2q63SNfOc96PkuNv67vIKblE2MvXaaLQimJxMDyCC/5Ek6muzqsRgqlzHWGyQqNXDZ6kWEESiafT7j/wb84akPm7YDhIM+d5FqBuG0tn+GENHCrxDX93aNTanYAGpJyuINq3/ABBQIIIchdpqBg0fiZi1+X1IHmth2E6n4/8ctRGenhpI4ky0umtDWQ+PnbEKeo1KLQFM2v89txQ8zSjU52tljATKUad0axgB51tiZWOSUGWWrhLMqJoZmGhjD6W/OBR4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(316002)(186003)(86362001)(66946007)(66556008)(4326008)(66476007)(8676002)(2616005)(36756003)(1076003)(103116003)(8936002)(5660300002)(7416002)(26005)(6512007)(6486002)(6916009)(966005)(83380400001)(54906003)(508600001)(6506007)(38350700002)(38100700002)(6666004)(2906002)(52116002)(14143004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?skufP5NhbeiOIAdekpa2K4tuhWeeURw6A4FK7PWcSsG3iYIRhfY5JeUGTAz2?=
 =?us-ascii?Q?KDeSwubv32EC0PLmJN2WJp7GWr0jr638Wwmd5S5rmJrzFerGm5BfvVbuCtZH?=
 =?us-ascii?Q?sVYFDcVTQQHf5DvJeLIiUCzztKNoc6XaK9ILNALpkBctjyoHgBbt0kmFmybP?=
 =?us-ascii?Q?gz6WaDS/vCuaxLsq5J64jOSOIaeyxk4KUIwUMBZ2YkAhpOvL17zY4wUwsNIc?=
 =?us-ascii?Q?5JzUG56UV/8BVC2BlI3CJzMsgfzXmppDDKtNXOFc+eZU1bC291gKfA6ls8ZL?=
 =?us-ascii?Q?/9HD+UawzlfpskvRMr3D7bhR6eAFa7Raewg+6lXSoVzQeKcSHQUMW8KpTnoX?=
 =?us-ascii?Q?AY+UGp+Smb/nhXUs+SxFaeuvEEwTWbh38PPTYfwx1o1ATLqnFTu7Bs/djiWT?=
 =?us-ascii?Q?OHM48pZOfXMqZY3JxN7dLP1oys7K0S2IpL3k7Z81KolcxswO3JFAJB+q1rSw?=
 =?us-ascii?Q?NjsvdUJm9ibk8h2gsIa/sY30oEsvv3z8JoKM/E+80OMpDHlaFHZm2pGl0VKX?=
 =?us-ascii?Q?LqArm5HrzyYy8oaodMcqsxlkGSsFFWW8ftfatISdj5dqwZaHxkYgZdzqp33z?=
 =?us-ascii?Q?lEdIunROcsBVzXzyGmOotf5i5L95oQSpeQr6BcR7uxn1s0BHDDNEtoRwW7iI?=
 =?us-ascii?Q?ffaKPhBFgsVqrWntLktQv/wc1JjvpB7ZpKOQG8uuM3sSczqpX7GZC983az/J?=
 =?us-ascii?Q?+6owC1hSnVZSUO1lFchUfbs6ybt3GslHmJtQd+Anpn/gvHgUe8fbRH+fPwq9?=
 =?us-ascii?Q?A1HALTDzYBWEkgZ559+OBaJ44C0FZtzwLv4/P0fVkB2+fvHBNj1LHJH403rg?=
 =?us-ascii?Q?CdfbH0tXsrl1b5uU6YT+x26QQCJUwUp0cVP5g3R3QV5ZIcpXjsNxxHXcMux3?=
 =?us-ascii?Q?dShSxuzIRwb6Wk3H70x4qLFGfG+oa3KSZV5595H421r4YHJkO6TZiGS3Sztr?=
 =?us-ascii?Q?6ym69290dFGxlMOZ4rsUENdc4qycNP3yTVu6IIcine3Sb6HDy63QHZetEJT5?=
 =?us-ascii?Q?EBDk+5Q+8VuSH6B/ef0ZzjHPEKCebqA+kc/JsWSh3483bWIdB/MFZDXghL/+?=
 =?us-ascii?Q?vG/+6Z6ew2+kP0bnhX7SH60CzL5qJ1J/LqrRda7bt6aSil1t630vym5gvvE9?=
 =?us-ascii?Q?THggHiKEwDabT3JyCOo9YBu0z+PeP4aij1rTIHUbJnYOzM7f6fH7nLMstPRp?=
 =?us-ascii?Q?s4GHciwW0jLbpFONz9tNPqgOuOP98fOHz4iLhTuu/wlRkak0d1d9Q4vEZrxq?=
 =?us-ascii?Q?xUEzX5OHDFB4VvvQltQpd5VuRj5D92gkNzH+JkaRhRdR5vm/WVMyq3IVzgaQ?=
 =?us-ascii?Q?2KkMW4yyivzk1gCnUixqWfgJPwWfI4sLq6lrD5IhTjA4gUhyt1V7WBiWznTc?=
 =?us-ascii?Q?iVIrhgFH7Nj79EUZLNyqwE4N1jOTcVDO7A4qWLEwviwea12qtBw1SYQhORQx?=
 =?us-ascii?Q?3siZZA/pV1V0Kzrb+VUbzrg6itJFAzoPoReCmhJrDFZu0IcwxBKjBPUkpVz3?=
 =?us-ascii?Q?cHzQ73+98nGV0YvIYfRuP8ykBoZpdqGpwCfNo1VkDr6EHEoJm5u7HcJBt0kr?=
 =?us-ascii?Q?RjIAvQvWlDyCNrtR5LHd4C43RJ//bNI/oYJM/qwmsGBd/Gyxq0+PnBk3tnfp?=
 =?us-ascii?Q?TthuO6U9lOcWz/3tGHpRoYqXQKIM/T2IzNItBQyoaeo2e1SUWjdKUlQRIJQ0?=
 =?us-ascii?Q?HUksyDALL7UaM3Utqm07A5N3/tzoLjGvoSUy1XDPWAE8veU+EcfSP9ohOpto?=
 =?us-ascii?Q?BdvsVhJ5q9vsIa952YpulqkkdRXPGwI=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36719e01-f16a-45ce-fde7-08da295b880b
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2022 21:10:32.9953
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lMb7m1ycZSgAMcGMMkHewS84kAk5+dVkYqVx42Lp609p09cPUGH2MR/yvQKTXbwoC9pfrdbpjtxgxWjLqz3PFxrCEtWUXim8Ak7AvmlCDDE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB1564
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-28_04:2022-04-28,2022-04-28 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 malwarescore=0 spamscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204280125
X-Proofpoint-ORIG-GUID: sev5B-IqS0m9CF3RtlcEKGJ9OoKxo-YF
X-Proofpoint-GUID: sev5B-IqS0m9CF3RtlcEKGJ9OoKxo-YF
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add to iommu domain operations a set of callbacks to
perform dirty tracking, particulary to start and stop
tracking and finally to test and clear the dirty data.

Drivers are expected to dynamically change its hw protection
domain bits to toggle the tracking and flush some form of
control state structure that stands in the IOVA translation
path.

For reading and clearing dirty data, in all IOMMUs a transition
from any of the PTE access bits (Access, Dirty) implies flushing
the IOTLB to invalidate any stale data in the IOTLB as to whether
or not the IOMMU should update the said PTEs. The iommu core APIs
introduce a new structure for storing the dirties, albeit vendor
IOMMUs implementing .read_and_clear_dirty() just use
iommu_dirty_bitmap_record() to set the memory storing dirties.
The underlying tracking/iteration of user bitmap memory is instead
done by iommufd which takes care of initializing the dirty bitmap
*prior* to passing to the IOMMU domain op.

So far for currently/to-be-supported IOMMUs with dirty tracking
support this particularly because the tracking is part of
first stage tables and part of address translation. Below
it is mentioned how hardware deal with the hardware protection
domain control bits, to justify the added iommu core APIs.
vendor IOMMU implementation will also explain in more detail on
the dirty bit usage/clearing in the IOPTEs.

* x86 AMD:

The same thing for AMD particularly the Device Table
respectivally, followed by flushing the Device IOTLB. On AMD[1],
section "2.2.1 Updating Shared Tables", e.g.

> Each table can also have its contents cached by the IOMMU or
peripheral IOTLBs. Therefore, after
updating a table entry that can be cached, system software must
send the IOMMU an appropriate
invalidate command. Information in the peripheral IOTLBs must
also be invalidated.

There's no mention of particular bits that are cached or
not but fetching a dev entry is part of address translation
as also depicted, so invalidate the device table to make
sure the next translations fetch a DTE entry with the HD bits set.

* x86 Intel (rev3.0+):

Likewise[2] set the SSADE bit in the scalable-entry second stage table
to enable Access/Dirty bits in the second stage page table. See manual,
particularly on "6.2.3.1 Scalable-Mode PASID-Table Entry Programming
Considerations"

> When modifying root-entries, scalable-mode root-entries,
context-entries, or scalable-mode context
entries:
> Software must serially invalidate the context-cache,
PASID-cache (if applicable), and the IOTLB.  The serialization is
required since hardware may utilize information from the
context-caches (e.g., Domain-ID) to tag new entries inserted to
the PASID-cache and IOTLB for processing in-flight requests.
Section 6.5 describe the invalidation operations.

And also the whole chapter "" Table "Table 23.  Guidance to
Software for Invalidations" in "6.5.3.3 Guidance to Software for
Invalidations" explicitly mentions

> SSADE transition from 0 to 1 in a scalable-mode PASID-table
entry with PGTT value of Second-stage or Nested

* ARM SMMUV3.2:

SMMUv3.2 needs to toggle the dirty bit descriptor
over the CD (or S2CD) for toggling and flush/invalidate
the IOMMU dev IOTLB.

Reference[0]: SMMU spec, "5.4.1 CD notes",

> The following CD fields are permitted to be cached as part of a
translation or TLB entry, and alteration requires
invalidation of any TLB entry that might have cached these
fields, in addition to CD structure cache invalidation:

...
HA, HD
...

Although, The ARM SMMUv3 case is a tad different that its x86
counterparts. Rather than changing *only* the IOMMU domain device entry to
enable dirty tracking (and having a dedicated bit for dirtyness in IOPTE)
ARM instead uses a dirty-bit modifier which is separately enabled, and
changes the *existing* meaning of access bits (for ro/rw), to the point
that marking access bit read-only but with dirty-bit-modifier enabled
doesn't trigger an perm io page fault.

In pratice this means that changing iommu context isn't enough
and in fact mostly useless IIUC (and can be always enabled). Dirtying
is only really enabled when the DBM pte bit is enabled (with the
CD.HD bit as a prereq).

To capture this h/w construct an iommu core API is added which enables
dirty tracking on an IOVA range rather than a device/context entry.
iommufd picks one or the other, and IOMMUFD core will favour
device-context op followed by IOVA-range alternative.

[0] https://developer.arm.com/documentation/ihi0070/latest
[1] https://www.amd.com/system/files/TechDocs/48882_IOMMU.pdf
[2] https://cdrdv2.intel.com/v1/dl/getContent/671081

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
 drivers/iommu/iommu.c      | 28 ++++++++++++++++++++
 include/linux/io-pgtable.h |  6 +++++
 include/linux/iommu.h      | 52 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 86 insertions(+)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 0c42ece25854..d18b9ddbcce4 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -15,6 +15,7 @@
 #include <linux/init.h>
 #include <linux/export.h>
 #include <linux/slab.h>
+#include <linux/highmem.h>
 #include <linux/errno.h>
 #include <linux/iommu.h>
 #include <linux/idr.h>
@@ -3167,3 +3168,30 @@ bool iommu_group_dma_owner_claimed(struct iommu_group *group)
 	return user;
 }
 EXPORT_SYMBOL_GPL(iommu_group_dma_owner_claimed);
+
+unsigned int iommu_dirty_bitmap_record(struct iommu_dirty_bitmap *dirty,
+				       unsigned long iova, unsigned long length)
+{
+	unsigned long nbits, offset, start_offset, idx, size, *kaddr;
+
+	nbits = max(1UL, length >> dirty->pgshift);
+	offset = (iova - dirty->iova) >> dirty->pgshift;
+	idx = offset / (PAGE_SIZE * BITS_PER_BYTE);
+	offset = offset % (PAGE_SIZE * BITS_PER_BYTE);
+	start_offset = dirty->start_offset;
+
+	while (nbits > 0) {
+		kaddr = kmap(dirty->pages[idx]) + start_offset;
+		size = min(PAGE_SIZE * BITS_PER_BYTE - offset, nbits);
+		bitmap_set(kaddr, offset, size);
+		kunmap(dirty->pages[idx]);
+		start_offset = offset = 0;
+		nbits -= size;
+		idx++;
+	}
+
+	if (dirty->gather)
+		iommu_iotlb_gather_add_range(dirty->gather, iova, length);
+
+	return nbits;
+}
diff --git a/include/linux/io-pgtable.h b/include/linux/io-pgtable.h
index 86af6f0a00a2..82b39925c21f 100644
--- a/include/linux/io-pgtable.h
+++ b/include/linux/io-pgtable.h
@@ -165,6 +165,12 @@ struct io_pgtable_ops {
 			      struct iommu_iotlb_gather *gather);
 	phys_addr_t (*iova_to_phys)(struct io_pgtable_ops *ops,
 				    unsigned long iova);
+	int (*set_dirty_tracking)(struct io_pgtable_ops *ops,
+				  unsigned long iova, size_t size,
+				  bool enabled);
+	int (*read_and_clear_dirty)(struct io_pgtable_ops *ops,
+				    unsigned long iova, size_t size,
+				    struct iommu_dirty_bitmap *dirty);
 };
 
 /**
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 6ef2df258673..ca076365d77b 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -189,6 +189,25 @@ struct iommu_iotlb_gather {
 	bool			queued;
 };
 
+/**
+ * struct iommu_dirty_bitmap - Dirty IOVA bitmap state
+ *
+ * @iova: IOVA representing the start of the bitmap, the first bit of the bitmap
+ * @pgshift: Page granularity of the bitmap
+ * @gather: Range information for a pending IOTLB flush
+ * @start_offset: Offset of the first user page
+ * @pages: User pages representing the bitmap region
+ * @npages: Number of user pages pinned
+ */
+struct iommu_dirty_bitmap {
+	unsigned long iova;
+	unsigned long pgshift;
+	struct iommu_iotlb_gather *gather;
+	unsigned long start_offset;
+	unsigned long npages;
+	struct page **pages;
+};
+
 /**
  * struct iommu_ops - iommu ops and capabilities
  * @capable: check capability
@@ -275,6 +294,13 @@ struct iommu_ops {
  * @enable_nesting: Enable nesting
  * @set_pgtable_quirks: Set io page table quirks (IO_PGTABLE_QUIRK_*)
  * @free: Release the domain after use.
+ * @set_dirty_tracking: Enable or Disable dirty tracking on the iommu domain
+ * @set_dirty_tracking_range: Enable or Disable dirty tracking on a range of
+ *                            an iommu domain
+ * @read_and_clear_dirty: Walk IOMMU page tables for dirtied PTEs marshalled
+ *                        into a bitmap, with a bit represented as a page.
+ *                        Reads the dirty PTE bits and clears it from IO
+ *                        pagetables.
  */
 struct iommu_domain_ops {
 	int (*attach_dev)(struct iommu_domain *domain, struct device *dev);
@@ -305,6 +331,15 @@ struct iommu_domain_ops {
 				  unsigned long quirks);
 
 	void (*free)(struct iommu_domain *domain);
+
+	int (*set_dirty_tracking)(struct iommu_domain *domain, bool enabled);
+	int (*set_dirty_tracking_range)(struct iommu_domain *domain,
+					unsigned long iova, size_t size,
+					struct iommu_iotlb_gather *iotlb_gather,
+					bool enabled);
+	int (*read_and_clear_dirty)(struct iommu_domain *domain,
+				    unsigned long iova, size_t size,
+				    struct iommu_dirty_bitmap *dirty);
 };
 
 /**
@@ -494,6 +529,23 @@ void iommu_set_dma_strict(void);
 extern int report_iommu_fault(struct iommu_domain *domain, struct device *dev,
 			      unsigned long iova, int flags);
 
+unsigned int iommu_dirty_bitmap_record(struct iommu_dirty_bitmap *dirty,
+				       unsigned long iova, unsigned long length);
+
+static inline void iommu_dirty_bitmap_init(struct iommu_dirty_bitmap *dirty,
+					   unsigned long base,
+					   unsigned long pgshift,
+					   struct iommu_iotlb_gather *gather)
+{
+	memset(dirty, 0, sizeof(*dirty));
+	dirty->iova = base;
+	dirty->pgshift = pgshift;
+	dirty->gather = gather;
+
+	if (gather)
+		iommu_iotlb_gather_init(dirty->gather);
+}
+
 static inline void iommu_flush_iotlb_all(struct iommu_domain *domain)
 {
 	if (domain->ops->flush_iotlb_all)
-- 
2.17.2

