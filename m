Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB89B7D35A8
	for <lists+kvm@lfdr.de>; Mon, 23 Oct 2023 13:50:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233316AbjJWLug (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 07:50:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234605AbjJWLud (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 07:50:33 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3701E4
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 04:50:31 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39N6kCmc005604;
        Mon, 23 Oct 2023 11:50:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : from : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=AtLzag6ZUS9yAhukCp88IJYyyhlq3nJhXckCwMuGPLk=;
 b=3+8mLPVeIuzzvYRkPpvrJ3LvteXHTbWtOa/ENQD0+V/fR9EUXNZFvrRbod0s3yZjsv5g
 XMpxWV173r7b6QB4hFiD6pWMwcQIvZQ4G0SMFTkga7FJtP5hX0xsTWCRAj73CSvD6+pf
 6lJN/2tIqLbrOqiATPakqYyaaqYR8EXUTRdQZcDLpcOwLnawJ58oWci+HEWrjDvpwa2G
 B9i6nVbUnuS9lsNta8/8ScmJqA3sZycrmL/+RA2IY+Fb+dX7VmT7/nN7N6xsRlmQf7D7
 MBzr9MU8qb5u/F2tHRsZlGrWCCf0AchMZu8vYlZPTmRsQDAOXadOP34xTUypwCFGxNko xQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tv6pctvgh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Oct 2023 11:50:03 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39NA8nVH001463;
        Mon, 23 Oct 2023 11:50:03 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3tv53ab8aj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Oct 2023 11:50:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lvYzmbPXhial6fDe55WsISZmQ19DKvw1Ow4LSAsSVBz12LwSTdnKDbM3lbOlzbrdd+ks++4nvHG/E/eAQU8Gx1CSB/viJd78wkx8h8CbCR/9Ak4zHIVUg14tVJ+5I/WZko+vRiUTm9Kf5Lb6c2mw5TYBYqxj1hmdcl7V2IdwT8yQsHYZN3R8NfhXPNfL4+s0FWi6YOspisVJknZOv6q8OHKlWHyEu8JwMCs1EtO5EkgBcdaLwnDYhbpqXFM+9kDYUO/GeLfvSqukWqr0h5ZveSAMZd2da5psFRZfBUm2gcr8CInXxNHlm1GShE5kcX/k0m7FirulLtevxLeZQY0BPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AtLzag6ZUS9yAhukCp88IJYyyhlq3nJhXckCwMuGPLk=;
 b=jcWObyVN16J+sWR8S2e8Vw9yQcUQCpM1wr+ukp+BbCVO/8vNfs8K+2u1Ti2THRByOW2LQ95nHQl/zVbBwxLsto2bb9xL1W4zVrIeRu8e/Y5k5E388kPluIeZSh9IZk9hQQQYy2Mu9q2uEHZjN38uM/QWMbUa4Mm5AsQCY9k2WZ575Q3iCTO/G7KkqC2MU+99ClWNGxdhPtKQ9p+VPPH4FMOkm9wwsHgCZn/6V3xBTrB89nIB+l/myipLbfAoiHCEqPQKp3OedykTiqByl+089Uus13SQ6/8BGcdritMvetkvsgSL4vlPWdVWIjV1YMvJE9SNKtV+g2KGYdXWmOdHHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AtLzag6ZUS9yAhukCp88IJYyyhlq3nJhXckCwMuGPLk=;
 b=t9kn3v5wPWfJ1WNQQN1rJLyZRJ4/N7tIzlXfeKrCAkoyAm2yLcVjXW1LpD3mCJ4XUw3Hr239lJ9cgoXV02E7utOt4w6oZ3N30SvmUmklBl3W9WoCkoYABw7Si1UaAtMfNTqsNJfIEmkEICVoiKrTu93XlVzh8W4vdIMYtU09H08=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by DS0PR10MB6149.namprd10.prod.outlook.com (2603:10b6:8:c7::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.36; Mon, 23 Oct
 2023 11:50:00 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::c8c3:56ba:38d5:21ac]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::c8c3:56ba:38d5:21ac%3]) with mapi id 15.20.6907.032; Mon, 23 Oct 2023
 11:50:00 +0000
Message-ID: <f6f13ff9-ec92-4759-bd0a-9d17a87509cc@oracle.com>
Date:   Mon, 23 Oct 2023 12:49:55 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 00/18] IOMMUFD Dirty Tracking
Content-Language: en-US
From:   Joao Martins <joao.m.martins@oracle.com>
To:     Nicolin Chen <nicolinc@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     iommu@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Zhenzhong Duan <zhenzhong.duan@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
References: <20231020222804.21850-1-joao.m.martins@oracle.com>
 <20231021162321.GK3952@nvidia.com> <ZTXOJGKefAwH70M4@Asurada-Nvidia>
 <4e7c8e8d-f22d-40e8-ad41-1e334bb78496@oracle.com>
In-Reply-To: <4e7c8e8d-f22d-40e8-ad41-1e334bb78496@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS4P251CA0006.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d2::15) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|DS0PR10MB6149:EE_
X-MS-Office365-Filtering-Correlation-Id: 779cd433-0bf6-4cae-590e-08dbd3be300b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: h9q4qFJmOUYpqUkeBWNSqSu9pLsr4uY/aHHLeI80I1cRc0EerKRad6ya5gbFCIeOBEuxFdIkecD19xSLr03jQF2susKzCy2qeC98HpNyR2bmXR7pgMm4XPGatFXhPiTJTAXKCxPmDygW5E9L4r4a4uvn0klG8mOV5xveGfzkzzcwqw1oEVrxGOsTdvWZO7Qp5TinJtVbzh5O771QdERcegwkVB1qmbarur1pjyl4twTgTcUYGKjYRX1K19pGyCrqZn3yrJ5YZpJDngZyOY/jNOtTs/zj4OjhZI1/Acv/QNtvJI74uy21o2PPFr492m424N+ZJjxtYrDu9ky68M7X8pXf5AT6qwPsA9rEKJ+uipfXKhxqDLeZK66el0RR1UjNZRHZsZgAmcogYo5cee2IUIaCiQem9F1irBJTxDKmx1g9BJET57b+UZfH+r3qoWGXMFgmsWUfNJw0lC1/5JILPhGQAbSI3tNJubZ5WLqHTFslR0uVL+sqnSw7sqdtRQZqduvVkUXTPHhY4JgLtxK25PsEHDR6vOjvR0QEyvSy/wYPLg9SNk9pacuZg7tDJHOVXnQIpHdwXucrjAT2ifjdoePhwJYTsDt9zD/AzTdSmprjBiicd4WX7Moqekt/8piyiAo/h76xEiQUfM8o4JnqM6DewTEA8wSSuf5KAT4K9HY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(396003)(366004)(376002)(136003)(346002)(230922051799003)(64100799003)(186009)(451199024)(1800799009)(66476007)(54906003)(66946007)(478600001)(6486002)(110136005)(6666004)(66556008)(6512007)(41300700001)(2616005)(4326008)(7416002)(8676002)(36756003)(2906002)(5660300002)(316002)(8936002)(83380400001)(26005)(38100700002)(31696002)(86362001)(6506007)(53546011)(31686004)(14143004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S0pPRkxHRlpHV1JRMlNIRnh3ZFUxcGpTT1krZ043K2ZSSTN5UGJ2N1lmeHNY?=
 =?utf-8?B?UzNSNEo2NW42dWcrZVd4dE4wRitYODVXazFxYVlGdDU2cE9Yd2owV2pLVmdT?=
 =?utf-8?B?RWNLdlYyeUlSRllURHhaM2NTUUhJTXpiQ2ltVWp1bVA3ZVd1WnVhTEFUYkpS?=
 =?utf-8?B?K1hGQlBlaXQ1ZTArWW9jUzFYWXhvNndSRWJPc0hFVzNLRStCZGlMWnN6dnE3?=
 =?utf-8?B?RElodWgwNUdJZHQvdVRaYmt1aGdYQU90SGJNN2JkMmkyQXBaSTVDODF6QTlU?=
 =?utf-8?B?cHo0bW1LTVdjZkpCMVJVZzhMOFdJL0M4VlZQTlNRbWFBME5PQm1DYjBrQk5Y?=
 =?utf-8?B?UjkrZjVBekFiWDZRYzhoQ0V4WEtSMkdocTBJazRMZlNYRHlEM0ZWMGMra0FK?=
 =?utf-8?B?VkNLaEY3S25XcHJkL3FqNENZKzEyWXpUQkdwTjFoVlY0NEp3Vm1qc2pRRXlC?=
 =?utf-8?B?ZkFBMmg4M2pqYklOMXJhdHdkUjBIRk1NK0tZallaMm9UUGdGZDI1R3laS1VX?=
 =?utf-8?B?ZVZtNkpjS3A4cTRMVUFjdDBnQzZnNUpBc2pHeElGYisya090SWhHM0dJZkNi?=
 =?utf-8?B?d0V6MUVTWUlhcHFMbzJrVTBNMGlxMWk2ZWF2NkxJaE5UeHc4NjBaZTBMeThx?=
 =?utf-8?B?TnVKaEdiMFVlNk9VcmtIbi9Sd1FFTnJRVFFKZFJSbCtHS0liTVh3RjF6bWNW?=
 =?utf-8?B?YXpWVm44R3ZIb0xoenBRTzdLelJlUVFTNE9wQUIyZnFhUGlZVnY2QlZVZCtV?=
 =?utf-8?B?V3lra2F1UHpKOStueVZtSDdwQ012SHFkVnVtc084OENYc3VsRGp3bytVb3J1?=
 =?utf-8?B?bEZucVMwS3lyQk9NUDI5Sm5TK09KZys1Tys4cm0wdDVhVWM2V2FoeDU5ZEdF?=
 =?utf-8?B?UUdDbnVpQnhHVkVYcEZyam5nRURKdlNUZStLVVA4bklBNEtVWmkrSmViZ2I1?=
 =?utf-8?B?OXhyL08vNDBwcUgzTTRzQUxBTTlGQkJDKytReHNHVjIxY2Q4TU9YTkU4WHpR?=
 =?utf-8?B?OWowZzUwaFZTOENYS2M5MFRPYUxDczJpWHlOdGJFYUFHQkFmdnFta0VGRTE2?=
 =?utf-8?B?WXpOdVhSblhHbmVzN1p3OXg0TGdzWitIRUlhdkw0dmtjSy9IZVZiTWN0UmdO?=
 =?utf-8?B?SFRBWXMzZHZIbHVzT0NYaGxkUUdqVDJZd2tkZEd4ZnhtbDZBTVlTTXlkenJ0?=
 =?utf-8?B?N3FpL3lnU3NDWmJUTE9JWXQya0QwUkVLNGQwYVpNR0cyRUdrMmpJc1dnN0RP?=
 =?utf-8?B?aDBlZTNlYkQrLzlqZVRvWXVZVy9TOVpnOVplbmQ5YzVhenZjSXMwWGp5cWxQ?=
 =?utf-8?B?N29ya3lnQ0ludTRlVEFWV3dFUWdTdkNURzYrbGw4U0pNM0MzVmU1YWhCc21x?=
 =?utf-8?B?Q2Y0MndpNU9GQkZ5ZDBtc1FjenYwTW45endTdWtGUEd4ZEVKN1ZvTy93bnZM?=
 =?utf-8?B?d0p4MFJoYXpwclAyQ24yc2NicVM0OVAxNjdYWkpQMW94RWZmdnFRV3hJT1JB?=
 =?utf-8?B?NFB0YytFK0d2SW5GbTI1Um1WaGZwTlZUTUl2MmZjUytXckdtMXh5NmxKcWd5?=
 =?utf-8?B?MHprMkRPQnd6YU1RUkViaXRuNGhQd251bU0wblRWREE0T0dKY3pGMk1sUWZR?=
 =?utf-8?B?ZzJIelo1Ulo4d3VDZ0QrSlR1aDBLOEE2cERIcm5WMkJSRmY3N2tUaFNlM0Rm?=
 =?utf-8?B?eGhQanBjczI5T2dxcktLU045ZGRHMWF0Sk9LcG9ldFpCRXV4NVBqUi9zemNR?=
 =?utf-8?B?SVZ1czQ0czhZYk1FYXpJWFdJME1WZHJEWGs1dGJ5K3Vta2p5UmRxbTZkd0FN?=
 =?utf-8?B?TGZ3WDVHZzMzOTdlcnNrcXRmOFZBN3BnZkdFTzhEWHYzcWpqY3BncVpIL3A5?=
 =?utf-8?B?eFNWRTZYK29EYUgyNGJxMDhwZjlDcEFnN2wzS1B3cWMxNGpVSCt3RzhTUUdW?=
 =?utf-8?B?VVZuT0JHcmV1VlE0NVM5eEpKdURNdldONHF4dnRYcjYyWEtRb3NucTdFTFJn?=
 =?utf-8?B?YmFrb1NMV0RRZTFnT1A1SjB4anBsTE9tamRyVjZCTCsvNWtoMkppd0M1UWJv?=
 =?utf-8?B?OVQyaGtLOFFqMzNXcEwraVRSTHRzUm1FdWtndHdEOU0vdDl3eDExNGwwZVh2?=
 =?utf-8?B?QzJvT1VDTE4zeUltb3RiOXdrbitiVDJXK1BzWmpvdzdiK2FxVXZqdXR5SFFG?=
 =?utf-8?B?RVE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?YlFTam5qby9jYlB5UnpaY2Q4QzMzQnFKT01qdUk1N0M3VUkzTlpYYkhuek5O?=
 =?utf-8?B?clp1NzUxbmxSRkg5V0pPdDhuNi83THZadmg4OW4wRjN4K2ZsRHNyYUhZWEZu?=
 =?utf-8?B?YTJYUzk3V2JEcC9OYTBJNnNqTG91blNHRVZVbnF1S3BmQUV3dWZvZnpMSUov?=
 =?utf-8?B?UldrK1ZWL0dMTHhPK3B5Wm5TajF2cVlEYmN1RDBRajhON01mNWxoNVE0R1h6?=
 =?utf-8?B?Smg4MDZiQ2ZpTDNobHhkRnpwRkFIMWw3dWR3TER4VVlYYUZkWXJrY2Rxc2hm?=
 =?utf-8?B?a3pSTmQwWmNWdzcxaTBqOU9jQ0ZadVovTWFLcWtheWduUEpHcERaTVpDWkZy?=
 =?utf-8?B?MUVOankrQ0pPb1h4SUZRV3RNekhueVBTT2pnclduOUFrY0Z3NFJtV1BZSUU0?=
 =?utf-8?B?cEpsazZ6Q3N6c3poWkh5RmNnNWlIem9iZ3lQS2FWL2Jrb3ZHYTNTS3RsT3Rr?=
 =?utf-8?B?TzhoZERVMm5acmhmc3BkcHRSNC9tOGtJV2VOR0paMXQwUFphdUVjUlJzMEg3?=
 =?utf-8?B?UkRsMlNncXVIL0d5UElEMnlzMk11eDZBcmErdzg1UElXQkQ4RjdpRGNENndZ?=
 =?utf-8?B?SldtYVlNeHNhYWhxRDFYRzFvTU5ZV1dPOU1ybVdtd0QzK1Y5SlVncnV1Z1NI?=
 =?utf-8?B?cENjZjFXdGlpV1JFei9pckxVODBXbTBxZk5QZmt0WHdiN2tjYWxvd3crbDk0?=
 =?utf-8?B?dVBMbXNMd243N0ZFMkorTU5SOFhSQnE4bURPZTBnZXhSZEpCL2FFSzltanQ5?=
 =?utf-8?B?ZWlhU0tiVWp6K2Nxem1aaGNXZzY1by9KY0JBbStIN3RUSWNjbkdwWWdiSE82?=
 =?utf-8?B?eUlHOFU3NHZhL2pYM2VwdXRJdGNzVUdibDRVWDhXSXpsUFhjRzF2V2k5dFhD?=
 =?utf-8?B?SStnSFhFcnhxZkJxcVIrTjlQSjJZOVd0dkFLTjkxdjVxVnFKdjNPRmFFRXNY?=
 =?utf-8?B?b3pnWFM5cnNtVG5IN1NIdDVRbFZHV3NkZDNkSFp3UUxURlg0U3kxV0dMcGRj?=
 =?utf-8?B?eThNUHlaeDJ5UktkL1ZQQXc4ZzdmQi9MMlNjOHBTWWpvT3liaVIxTFp0Q3kw?=
 =?utf-8?B?OG1ocGR1amdvNU5MTmpvVnNSRnd1Wkw1Wk9wL1EyQUFaYjdPUFRiYXVOTXdT?=
 =?utf-8?B?Vk8xVkR5RDRtNEhsaDJybDNldDZDUUQ3dkErOEFpZnR5UW1NU1IvTzJJeVJW?=
 =?utf-8?B?YjZaUUxzUCtIR04vakowSXErMHZCWXZMUUhzTWRaQTlvZ1FEY2s4em1hcXNS?=
 =?utf-8?B?MG9sL05VdmUzZERSU1NhYXhaVVJBd1Q0Z0VZRU5KaFBpTzRkS2dVZTJvTG8v?=
 =?utf-8?B?YVdlNVV0dHNMZ3JHcFp5RkdtWDRTOUdVRFFaRHZsd0FqUjk3b0VzeDFQMFNT?=
 =?utf-8?B?YTU0aVlaYU1PNlBMWVRXQ3c1Nm9mYTBFZTNWU1VGNmwvZE1GdFJXQ0NhQzhW?=
 =?utf-8?Q?WsyU15nq?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 779cd433-0bf6-4cae-590e-08dbd3be300b
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2023 11:50:00.8108
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VlMK3gfEuzyocvyyW0s7zlNluwts4h8crsFRUzYc6vqNYjR89wzyKxaD8rg86jl5k4qC/ZMpTvojyCfXKUX85+8wEGl0zXcPkciXbEAEqgI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6149
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-23_10,2023-10-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 adultscore=0 bulkscore=0 suspectscore=0 mlxscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310170001 definitions=main-2310230103
X-Proofpoint-GUID: YKp3IR0jhLEOo1PFKq7tLBGCkt91usrf
X-Proofpoint-ORIG-GUID: YKp3IR0jhLEOo1PFKq7tLBGCkt91usrf
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 23/10/2023 10:15, Joao Martins wrote:
> On 23/10/2023 02:36, Nicolin Chen wrote:
>> On Sat, Oct 21, 2023 at 01:23:21PM -0300, Jason Gunthorpe wrote:
>>> On Fri, Oct 20, 2023 at 11:27:46PM +0100, Joao Martins wrote:
>>>> Changes since v4[8]:
>>>> * Rename HWPT_SET_DIRTY to HWPT_SET_DIRTY_TRACKING 
>>>> * Rename IOMMU_CAP_DIRTY to IOMMU_CAP_DIRTY_TRACKING
>>>> * Rename HWPT_GET_DIRTY_IOVA to HWPT_GET_DIRTY_BITMAP
>>>> * Rename IOMMU_HWPT_ALLOC_ENFORCE_DIRTY to IOMMU_HWPT_ALLOC_DIRTY_TRACKING
>>>>   including commit messages, code comments. Additionally change the
>>>>   variable in drivers from enforce_dirty to dirty_tracking.
>>>> * Reflect all the mass renaming in commit messages/structs/docs.
>>>> * Fix the enums prefix to be IOMMU_HWPT like everyone else
>>>> * UAPI docs fixes/spelling and minor consistency issues/adjustments
>>>> * Change function exit style in __iommu_read_and_clear_dirty to return
>>>>   right away instead of storing ret and returning at the end.
>>>> * Check 0 page_size and replace find-first-bit + left-shift with a
>>>>   simple divide in iommufd_check_iova_range()
>>>> * Handle empty iommu domains when setting dirty tracking in intel-iommu;
>>>>   Verified and amd-iommu was already the case.
>>>> * Remove unnecessary extra check for PGTT type
>>>> * Fix comment on function clearing the SLADE bit
>>>> * Fix wrong check that validates domain_alloc_user()
>>>>   accepted flags in amd-iommu driver
>>>> * Skip IOTLB domain flush if no devices exist on the iommu domain,
>>>> while setting dirty tracking in amd-iommu driver.
>>>> * Collect Reviewed-by tags by Jason, Lu Baolu, Brett, Kevin, Alex
>>>
>>> I put this toward linux-next, let's see if we need a v6 next week with
>>> any remaining items.
>>
>> The selftest seems to be broken with this series:
>>
>> In file included from iommufd.c:10:0:
>> iommufd_utils.h:12:10: fatal error: linux/bitmap.h: No such file or directory
>>  #include <linux/bitmap.h>
>>           ^~~~~~~~~~~~~~~~
>> In file included from iommufd.c:10:0:
>> iommufd_utils.h:12:10: fatal error: linux/bitops.h: No such file or directory
>>  #include <linux/bitops.h>
>>           ^~~~~~~~~~~~~~~~
>> compilation terminated.
>>
>> Some of the tests are using kernel functions from these two headers
>> so I am not sure how to do any quick fix...
> 
> Sorry for the oversight.
> 
> It comes from the GET_DIRTY_BITMAP selftest ("iommufd/selftest: Test
> IOMMU_HWPT_GET_DIRTY_BITMAP") because I use test_bit/set_bit/BITS_PER_BYTE in
> bitmap validation to make sure all the bits are set/unset as expected. I think
> some time ago I had an issue on my environment that the selftests didn't build
> in-tree with the kernel unless it has the kernel headers installed in the
> system/path (between before/after commit 0d7a91678aaa ("selftests: iommu: Use
> installed kernel headers search path")) so I was mistakenly using:
> 
> CFLAGS="-I../../../../tools/include/ -I../../../../include/uapi/
> -I../../../../include/"
> 
> Just for the iommufd selftests, to replace what was prior to the commit plus
> `tools/include`:
> 
> diff --git a/tools/testing/selftests/iommu/Makefile
> b/tools/testing/selftests/iommu/Makefile
> index 7cb74d26f141..32c5fdfd0eef 100644
> --- a/tools/testing/selftests/iommu/Makefile
> +++ b/tools/testing/selftests/iommu/Makefile
> @@ -1,7 +1,6 @@
>  # SPDX-License-Identifier: GPL-2.0-only
>  CFLAGS += -Wall -O2 -Wno-unused-function
> -CFLAGS += -I../../../../include/uapi/
> -CFLAGS += -I../../../../include/
> +CFLAGS += $(KHDR_INCLUDES)
> 
> ... Which is what is masking your reported build problem for me.
> [The tests will build and run fine though once having the above]
> 
> The usage of non UAPI kernel headers in selftests isn't unprecedented as I
> understand (if you grep for 'linux/bitmap.h') you will see a whole bunch. But
> maybe it isn't supposed to be used. Nonetheless the brokeness assumption was on
> my environment, and I have fixed up the environment now. Except for the above
> that you are reporting
> 
> Perhaps the simpler change is to just import those two functions into the
> iommufd_util.h, since the selftest doesn't require any other non-UAPI headers. I
> have also had a couple more warnings/issues (in other patches), so I will need a
> v6 address to address everything.

Here's an example down that avoids the kernel header dependency; imported from
the arch-independent non-atomic bitops
(include/asm-generic/bitops/generic-non-atomic.h)

diff --git a/tools/testing/selftests/iommu/iommufd.c
b/tools/testing/selftests/iommu/iommufd.c
index 96837369a0aa..026ff9f5c1f3 100644
--- a/tools/testing/selftests/iommu/iommufd.c
+++ b/tools/testing/selftests/iommu/iommufd.c
@@ -12,7 +12,6 @@
 static unsigned long HUGEPAGE_SIZE;

 #define MOCK_PAGE_SIZE (PAGE_SIZE / 2)
-#define BITS_PER_BYTE 8

 static unsigned long get_huge_page_size(void)
 {
diff --git a/tools/testing/selftests/iommu/iommufd_utils.h
b/tools/testing/selftests/iommu/iommufd_utils.h
index 390563ff7935..6bbcab7fd6ab 100644
--- a/tools/testing/selftests/iommu/iommufd_utils.h
+++ b/tools/testing/selftests/iommu/iommufd_utils.h
@@ -9,8 +9,6 @@
 #include <sys/ioctl.h>
 #include <stdint.h>
 #include <assert.h>
-#include <linux/bitmap.h>
-#include <linux/bitops.h>

 #include "../kselftest_harness.h"
 #include "../../../../drivers/iommu/iommufd/iommufd_test.h"
@@ -18,6 +16,24 @@
 /* Hack to make assertions more readable */
 #define _IOMMU_TEST_CMD(x) IOMMU_TEST_CMD

+/* Imported from include/asm-generic/bitops/generic-non-atomic.h */
+#define BITS_PER_BYTE 8
+#define BITS_PER_LONG __BITS_PER_LONG
+#define BIT_MASK(nr) (1UL << ((nr) % __BITS_PER_LONG))
+#define BIT_WORD(nr) ((nr) / __BITS_PER_LONG)
+
+static inline void set_bit(unsigned int nr, unsigned long *addr)
+{
+       unsigned long mask = BIT_MASK(nr);
+       unsigned long *p = ((unsigned long *)addr) + BIT_WORD(nr);
+
+       *p  |= mask;
+}
+
+static inline bool test_bit(unsigned int nr, unsigned long *addr)
+{
+       return 1UL & (addr[BIT_WORD(nr)] >> (nr & (BITS_PER_LONG-1)));
+}
+
 static void *buffer;
 static unsigned long BUFFER_SIZE;

