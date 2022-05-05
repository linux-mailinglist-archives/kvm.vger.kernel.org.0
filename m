Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D42B51BE6F
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 13:52:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358573AbiEELzh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 07:55:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356566AbiEELzb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 07:55:31 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31208541BE
        for <kvm@vger.kernel.org>; Thu,  5 May 2022 04:51:51 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24590Oip003197;
        Thu, 5 May 2022 11:51:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=eoAf6xSHD2xgVJtkNW/EeXZyXZvCc5FiP1WWBMNksVw=;
 b=cW6+SGphGqL8w6qd7HDhtNw2hehMUUQAyQZN7S7HCJwiOlQVk5Qx9ez5XE3Op1hBEpZh
 3hGPiuRiNnFnoCi7hXIziyA6rdjPrd4O+INfk9PZm9tNsxG6JJvaLXYuaYEcUY1ZUZHr
 nfKmErBFnmKlIohM8vcsiP0TMrLtmgSs5LO5GOeWl5W6SUOGZ0luimpbKFbHB5gYGHVr
 JSYHHwM5e2Jp1y0941IMQ8gBmjniIvtihMTLuJD0cNxnlGS6ElH6nj3Bb2x91y5oTzMC
 /oeF7m1IETnFyc00a9j11aHfUID8ZxTBTvDIfqK9VrNsOHVL1Mk/PnRtHeY6oKuVum2D Vg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3frw0attt1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 May 2022 11:51:17 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 245BpAPS002518;
        Thu, 5 May 2022 11:51:14 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2042.outbound.protection.outlook.com [104.47.51.42])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3frujakvet-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 May 2022 11:51:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kg2f4j8yVJPufuZUBQP6dJjQOQmMfrCczOP4HNGYadQfevYOu46IrXhOWtFP/hQGLrrUAAl0V9gEg71swEXfFzE00lKt7d/NtfJU9Kzetl+tV7i4B3dRipSBBUOEwzeFUZrdaa5TgvKlSHmWwWyBhHxPfw1XMcqoXISQE2wLDKJccvn/g7dGbPAan/3MuTul54KtwnVOX1FuWf0PQqJtByN90t3Guxm3iVonJg2VezWUgil7Z7ORzGj48CwMWN5E3a9pUzMEVi2uN5PSdSYbOUreTS6U8atKa9LelFVKpXWfx2g2mocJ3eeeN3muz23eIkRC+v3aVLC93RKuCyQ0PQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eoAf6xSHD2xgVJtkNW/EeXZyXZvCc5FiP1WWBMNksVw=;
 b=couvmjTZTqjYiOvCXVLATgyuWEug9Cgt5QkIdP5Wv6clPXWggebkoB/j7CKsPtuV4xK5TGthoUTUUBw/qO+mIZsG7iHOMLWRQx9Owshb4aA8avh5VCLDCzJZegHRME6bXkRMeCc+b8b5JFO/2RyLBX75H8o3ZIWouegU4VhGB+9c9vGWuu+bTN6PHlOHfzrcec8dvZCcqBY750AG97KzQQWZ2Xz2VZPlOFvICkrx5tKuKSPvBiY4MOVMeeo0men9nVcktrhN0eYXNnvI/cz0WtXHvW6zDZyie1mjdWr3JT5uepRQnQrPcOhL+zC4TaLdVKBYUjWWvfdiFuhmgqiJOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eoAf6xSHD2xgVJtkNW/EeXZyXZvCc5FiP1WWBMNksVw=;
 b=bgCqHp+7x/vrxjb+wU/p+DkBTYiaxmOzrx5me+QU4wau2AJLyA0W/jWj5gKCm8OXqvHm3rkq8OF3sM1RX64KqLysKKTpLb6dW/+oMr5+8EU3RXipOvO/Lp2Wp8TFuxbrpnPsaEgvsUC0kB3LF7ghPrq/Vx14PxReM+Q2DA/IjBM=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by DM5PR10MB2028.namprd10.prod.outlook.com (2603:10b6:3:111::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Thu, 5 May
 2022 11:51:03 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d%5]) with mapi id 15.20.5206.027; Thu, 5 May 2022
 11:51:03 +0000
Message-ID: <82366a45-937c-eea9-259d-ac718249bab1@oracle.com>
Date:   Thu, 5 May 2022 12:50:55 +0100
Subject: Re: [PATCH RFC 00/19] IOMMUFD Dirty Tracking
Content-Language: en-US
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
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
        Nicolin Chen <nicolinc@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <20220428210933.3583-1-joao.m.martins@oracle.com>
 <BN9PR11MB5276F104A27ACD5F20BABC7F8CFC9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220502121107.653ac0c5.alex.williamson@redhat.com>
 <20220502185239.GR8364@nvidia.com>
 <BN9PR11MB527609043E7323A032F024AC8CC29@BN9PR11MB5276.namprd11.prod.outlook.com>
 <7b480b96-780b-92f3-1c8c-f2a7e6c6dc53@oracle.com>
 <BN9PR11MB527662B72E8BD1EDE204C5538CC29@BN9PR11MB5276.namprd11.prod.outlook.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <BN9PR11MB527662B72E8BD1EDE204C5538CC29@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LNXP265CA0038.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:5c::26) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: be18212b-432e-4408-0e73-08da2e8d87ea
X-MS-TrafficTypeDiagnostic: DM5PR10MB2028:EE_
X-Microsoft-Antispam-PRVS: <DM5PR10MB2028CF74D8BF6046A9C73D52BBC29@DM5PR10MB2028.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fB8aKVez6TJ/KBXFByH3CpYUZZ6v55CZ5LCEbUS/WYXDyW7FT1N5NIdRbGtlaAZZAw2G/TSN8av3zfvcexlR+3x7oQ0NxBOUvjVLoAyZKWWPkk7XRelKgVHK8MCaiX6xUqyVKU2X1wQ+mD2AMjqRgmNgtj0nZDcajXvBvN8/5acuv8pxVb4ViA/cyC8kpLacEpvdcP5/kLNI7vrd06++kzy03QmfGVl3/Md4FcK5G/nE39sS0gF4pMXzP9kOLa0/ayq+a5qAL8go8pAH8Th295bwjEOWbe3ZG7NAR3RrXoOKUhIVIA0dHpJF9NWtIvofzcUlnETasDgV97K5jHPRtyFKuWzjIYv3o3AK5ZJ+38bBm/xhZ7hLeyd3bdJtDPfbCvnEEpLok0Tmyg9kI3w8nsmWWHIccCr5pKWUJQmNFKJ2Egx9dkqIoD0Vy71kRGq9Ufa3xxxpRPBmzcnj3YLymmiQomcEtbCjrijiE6BgHeX/XOjJJvo3r277Ro/JktH7F0Ct/uAlOJKZ2NAPQr/X3gP7gCDu5sfT8c6BQ1HjlDlF3d5c7lfiaSvB/VLyuyqwuknXIJL5kcaSsjJ2+ZKgTVO0sYlF3Y+teGl8LDt8czq2/v15cU1ESzDXH739cyIVGeTJqdivpqSu3KkganbcLAS/AlMgDrCMAAXgjKW6ZZxoJrOtzh/2WTyZzhBe4bMRNVOEAWNZChZx921RWR44VuRQhP4oUt90cQRnMEfSECQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(110136005)(31696002)(8676002)(86362001)(66556008)(4326008)(66476007)(508600001)(66946007)(6486002)(54906003)(316002)(38100700002)(36756003)(2906002)(83380400001)(186003)(2616005)(31686004)(7416002)(8936002)(6512007)(6666004)(5660300002)(6506007)(26005)(53546011)(14143004)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SDEwTDNYWEJtNUgxZTh2U2RYY2xVSXNZdnVkYnMreW1OUlk3QnZ3eWcrT0RX?=
 =?utf-8?B?OVM3c2d3ZEdIVmRDV1JvQ0ZkczRuVmJGb0Zjc3VyMlpwQXpaLzlheEpXWGNr?=
 =?utf-8?B?ZVdlQmVkN2FTd1pjVzlsaVlSZXIzbUs5N2dJdFhHcXZWWkU3SXdtQlBqZkt3?=
 =?utf-8?B?MUFIeURhbHdTcnFMYS9mc3RlMkUxQjI4QmZoNGpnUjBlcnJTT3VTdHZxeE5Y?=
 =?utf-8?B?TXhoSHhpSGw5S3huZSs4SnRFeUVXTStndkpmLzBwTjZJL2hXMi8vcjF3bUF6?=
 =?utf-8?B?L0FlSUxBUjNRTFZxWXBTRDlKQ2VuYXYrakhNMHNlVnBuT25IU1ZNdkx1RHZU?=
 =?utf-8?B?c0pIOXRrNnZlVkRMSTdaaUlMeHdXWVl1OUVKRWhBR3ZBWkE5L2dhTFYzZTJu?=
 =?utf-8?B?Q3c4TEowMDRaWTRUeDJDbFVyUVNYMEtoWXFUZkdzOFFlR2ZxYjRrR05PYTBV?=
 =?utf-8?B?MmRqWGdUQW1PUXJ3SG9XN2w1b0prdnJTMStqWng3VGNadjdjV2JMVkFLdU5h?=
 =?utf-8?B?eUhWSzQ1LzFteEJoRTNJVmRuWG1mYkdPZ1BPRllFYmFzZzRsMkxRN1RGRXIx?=
 =?utf-8?B?UDNGK3VlMGtTZ0E3ZXRRdzNYUGRBUzVvVFRvanNROXNBUVREMkxCcm1ISGNi?=
 =?utf-8?B?Z1l2OW94bVppRmdtY3hQRVlXVDcxblVGMHpORVIxWmdQbHZRTndJR1l1a21m?=
 =?utf-8?B?UXk1UUJ3akROemJkSnVKdnc1Tms0dG9OanZTV01sUjh5ZFhma0xkcmNKTUtX?=
 =?utf-8?B?WnV3QklLb3ppY2IzVGJkVlhKSWpZNnN1UWZCandxVGwvbFNpa2ZKZ1oxc2tZ?=
 =?utf-8?B?N3JESWVITUNteXhUNjFTek9NRFNaV3pZRzhVL2FwdUlKTlhJczVuT1BablpY?=
 =?utf-8?B?OWVUOW5jWGlCYnc1MGxDUTEwTXNBbU84YjZDNnhlYUJZNW03dzBqb1Z4M3p6?=
 =?utf-8?B?SHFGTE54UmpHZ0NYaUcwczFmZWxDMkw2cjY2dDI4Q1Npc1FkYTRLbDI4bm9W?=
 =?utf-8?B?UVJaQnBBaEp1bEY5NjNWVDBiMXZYOFovTm9KSTk4eUtUY2xkZkpBYzFtMk03?=
 =?utf-8?B?RkY5VTEybDhwOWFocXhTT0JvdVdxL3lZTWdPR2FFMXh0RjhzRW81WGZTNTZl?=
 =?utf-8?B?dTBaL2lLWnN6Yk13YjhrNnIxTmNPRjE4d0dhWHd6d3VialZ1d0xkaDEzRkx5?=
 =?utf-8?B?ejJsYllrdDkvR0ZhSUpGMnovTjdlT1JXVXYvODFTcVNGaHo0blhvdmVheERl?=
 =?utf-8?B?OW9KMUtVd0xDOXplT1lMemtpcG9VUGpGTGhjTzAzY3VpMEdoejBUZDVSSnVV?=
 =?utf-8?B?dW5MY1pRbllLaGlOek1MeWxvV3pPeXZXY3Qvd0lheHdkdmk3dXA4bU40LzlO?=
 =?utf-8?B?V0hoZ3N6dTVCTzFyOW84WDd0YXJXNUIzQWlmZkRVRk9XNTlmT3FFd0N0VG9p?=
 =?utf-8?B?S0V1V0NUbWkrYUViWnZVbUpBWDFabEtEcU1NWUZTR1ZZanVmcmluWTh4Mjdm?=
 =?utf-8?B?c2tnWXZwbTY4RjN4YWJSeG5CYmliUElGS2d4L1gvWXNXdGdQZEVTb1dtNHky?=
 =?utf-8?B?Tm54aEFRbG1CZ1JHR0IwV21qK3pzY1FtaWdncDcwbUd2RVFSclpEdisya2o5?=
 =?utf-8?B?SmtSMUtGTUpBRHZnK0l0UjBEM3RobmY5N1EyeXdNbDhaNGhvSjVhYVF3TGNz?=
 =?utf-8?B?VW9wRnlwNGlWd0VQVFM2MkN4Y004dUlUU1ZOWS9yWlZNOVBHN1pMM1VHQmdU?=
 =?utf-8?B?OGNnVzJpOGxiSnlNVkd1Q1ExSG44c1JLRUJTazNyZHRHR3FjL0VsZUdJeHBC?=
 =?utf-8?B?Sm5BWTJtcGJpWGRVRDFuYXhPY1J0V0lYT1d4VFhKK1MxNDk1UkFrVW4wR1RS?=
 =?utf-8?B?alZ6S2lIdHFLd2dyQk9RSHMxdGVkUmlqLzd6bHEwR04zdGt3aWpMdzVZTG9L?=
 =?utf-8?B?ek9zdSt4WThJMkp3aytYWHU5OWJBK1hvVyswd3R5M29MaEFUdUJCcVJkZUlz?=
 =?utf-8?B?WWhCdGNxRTV3c3gxdUFNUEhKSWxTSEhXb0FHbUhoTGtIMzhBUjZuKzJRejF5?=
 =?utf-8?B?blFUSnhpSHZKNjBpQUFGZXNWTjNsUTBZcGpsQkVpL25EVjU4VVVaRTdISDgw?=
 =?utf-8?B?Sm8yQnlUendLbDBacjRCenBQeDN1VDVVUTBBVk4yVHVrOFltenUrOEk1dnlL?=
 =?utf-8?B?N3dKZjdwUEx0NWdrNEg5dmg2SlBBeWFxRGhPRU5ENXROUzZSbG5EMnB3L09q?=
 =?utf-8?B?TkNodzRBbUtUMWZoa1Nra2luLzlyeGphZjVRVFpXeHpVNSt3MC9abEhsMnBE?=
 =?utf-8?B?VXFPOWNtS3dFZFFFVGRzNGx3Z1plYUlNbG05Wm03TVdMbmFsaUlOaW5HYkJv?=
 =?utf-8?Q?Xdm9utPGRZ6+ehxM=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be18212b-432e-4408-0e73-08da2e8d87ea
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2022 11:51:03.4844
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IhEHMHgZ/qyPJNwVuXWrVoZDHprjtkrsqXHcyZqBO4tr8OW7SPhCR30za7ha0ozz/41wEneiigh0BoIl2dyf7TdehA9NwJa4rxtABlss4Og=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB2028
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-05_05:2022-05-05,2022-05-05 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 adultscore=0
 bulkscore=0 suspectscore=0 mlxlogscore=999 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205050085
X-Proofpoint-GUID: hP6iqNw_XP7o-Bn0bYq-Ya8GT8AsMGxI
X-Proofpoint-ORIG-GUID: hP6iqNw_XP7o-Bn0bYq-Ya8GT8AsMGxI
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/5/22 12:03, Tian, Kevin wrote:
>> From: Joao Martins <joao.m.martins@oracle.com>
>> Sent: Thursday, May 5, 2022 6:07 PM
>>
>> On 5/5/22 08:42, Tian, Kevin wrote:
>>>> From: Jason Gunthorpe <jgg@nvidia.com>
>>>> Sent: Tuesday, May 3, 2022 2:53 AM
>>>>
>>>> On Mon, May 02, 2022 at 12:11:07PM -0600, Alex Williamson wrote:
>>>>> On Fri, 29 Apr 2022 05:45:20 +0000
>>>>> "Tian, Kevin" <kevin.tian@intel.com> wrote:
>>>>>>> From: Joao Martins <joao.m.martins@oracle.com>
>>>>>>>  3) Unmapping an IOVA range while returning its dirty bit prior to
>>>>>>> unmap. This case is specific for non-nested vIOMMU case where an
>>>>>>> erronous guest (or device) DMAing to an address being unmapped at
>>>> the
>>>>>>> same time.
>>>>>>
>>>>>> an erroneous attempt like above cannot anticipate which DMAs can
>>>>>> succeed in that window thus the end behavior is undefined. For an
>>>>>> undefined behavior nothing will be broken by losing some bits dirtied
>>>>>> in the window between reading back dirty bits of the range and
>>>>>> actually calling unmap. From guest p.o.v. all those are black-box
>>>>>> hardware logic to serve a virtual iotlb invalidation request which just
>>>>>> cannot be completed in one cycle.
>>>>>>
>>>>>> Hence in reality probably this is not required except to meet vfio
>>>>>> compat requirement. Just in concept returning dirty bits at unmap
>>>>>> is more accurate.
>>>>>>
>>>>>> I'm slightly inclined to abandon it in iommufd uAPI.
>>>>>
>>>>> Sorry, I'm not following why an unmap with returned dirty bitmap
>>>>> operation is specific to a vIOMMU case, or in fact indicative of some
>>>>> sort of erroneous, racy behavior of guest or device.
>>>>
>>>> It is being compared against the alternative which is to explicitly
>>>> query dirty then do a normal unmap as two system calls and permit a
>>>> race.
>>>>
>>>> The only case with any difference is if the guest is racing DMA with
>>>> the unmap - in which case it is already indeterminate for the guest if
>>>> the DMA will be completed or not.
>>>>
>>>> eg on the vIOMMU case if the guest races DMA with unmap then we are
>>>> already fine with throwing away that DMA because that is how the race
>>>> resolves during non-migration situations, so resovling it as throwing
>>>> away the DMA during migration is OK too.
>>>>
>>>>> We need the flexibility to support memory hot-unplug operations
>>>>> during migration,
>>>>
>>>> I would have thought that hotplug during migration would simply
>>>> discard all the data - how does it use the dirty bitmap?
>>>>
>>>>> This was implemented as a single operation specifically to avoid
>>>>> races where ongoing access may be available after retrieving a
>>>>> snapshot of the bitmap.  Thanks,
>>>>
>>>> The issue is the cost.
>>>>
>>>> On a real iommu elminating the race is expensive as we have to write
>>>> protect the pages before query dirty, which seems to be an extra IOTLB
>>>> flush.
>>>>
>>>> It is not clear if paying this cost to become atomic is actually
>>>> something any use case needs.
>>>>
>>>> So, I suggest we think about a 3rd op 'write protect and clear
>>>> dirties' that will be followed by a normal unmap - the extra op will
>>>> have the extra oveheard and userspace can decide if it wants to pay or
>>>> not vs the non-atomic read dirties operation. And lets have a use case
>>>> where this must be atomic before we implement it..
>>>
>>> and write-protection also relies on the support of I/O page fault...
>>>
>> /I think/ all IOMMUs in this series already support permission/unrecoverable
>> I/O page faults for a long time IIUC.
>>
>> The earlier suggestion was just to discard the I/O page fault after
>> write-protection happens. fwiw, some IOMMUs also support suppressing
>> the event notification (like AMD).
> 
> iiuc the purpose of 'write-protection' here is to capture in-fly dirty pages
> in the said race window until unmap and iotlb is invalidated is completed.
> 
But then we depend on PRS being there on the device, because without it, DMA is
aborted on the target on a read-only IOVA prior to the page fault, thus the page
is not going to be dirty anyways.

> *unrecoverable* faults are not expected to be used in a feature path
> as occurrence of such faults may lead to severe reaction in iommu
> drivers e.g. completely block DMA from the device causing such faults.

Unless I totally misunderstood ... the later is actually what we were suggesting
here /in the context of unmaping an GIOVA/(*).

The wrprotect() was there to ensure we get an atomic dirty state of the IOVA range
afterwards, by blocking DMA (as opposed to sort of mediating DMA). The I/O page fault is
not supposed to happen unless there's rogue DMA AIUI.

TBH, the same could be said for normal DMA unmap as that does not make any sort of
guarantees of stopping DMA until the IOTLB flush happens.

(*) Although I am not saying the use-case of wrprotect() and mediating dirty pages you say
isn't useful. I guess it is in a world where we want support post-copy migration with VFs,
which would require some form of PRI (via the PF?) of the migratable VF. I was just trying
to differentiate that this in the context of unmapping an IOVA.
