Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB0F4539448
	for <lists+kvm@lfdr.de>; Tue, 31 May 2022 17:51:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345894AbiEaPvy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 May 2022 11:51:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242684AbiEaPvv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 May 2022 11:51:51 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68F5B10561
        for <kvm@vger.kernel.org>; Tue, 31 May 2022 08:51:49 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24VEYkGL021161;
        Tue, 31 May 2022 15:51:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=NVjEqG3UsPgfhKhZhB8Ttj/HmxhmILQib1xOuQqTjAI=;
 b=EE+Ywuh5SGgLi9BcqAXgxAJHrDBRMSBk6OWhoP708J5kXWRxLDJbxlam361U4yxn6vif
 QVWA9z2e6FcpciowlbI40klciv6Shqi2ZQWUIBVYLl4zKhI46Xu/qS8GxXGS5X9nbg9l
 oU8gY8BCrucAyC3Edv/wahbI9w/MY/aqaPWEcjMhDXn9M/0WctIyWLPATHe9s6m9xJBU
 8voQhTPyA+wUF1uKhwkpbqNkw8qWtjd2a/rAGzCwWvgYNcCoge21f6unG0gHVgIL5rm1
 nzHT7/nUCQaD6CSPVawsUjrdjliCL989XLJqcEvt6N7CbpLcz6QaaCT6/fN0aeG4wnFL 5Q== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gbc7knc4u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 31 May 2022 15:51:18 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24VFVSMG021935;
        Tue, 31 May 2022 15:51:17 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2043.outbound.protection.outlook.com [104.47.73.43])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gc8jxa0sm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 31 May 2022 15:51:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hnrt52Px3Dg4H1ii8QQNkW3TnDBXvTYVf4iM93NefNzH2RwC6FCUxIh30FXj2uuwO+HRHaXu4wiuVkXCimI5iEGbBBkpeeghqpDzVVDNxf686IsmAZrgQofMRcC2qo2khpLc6JA3q2ZWykxVR+F6RWmEQfxKE0EGGvObnY+uyOJPkgY5+jpIgNlDsxnpU+9GRJXPdXay9cKJ448mK9DTGVupvzxhTVFYYj+wKkniR2YNCdGwkGDGZwSVbKYWyGbSJlgJRpVpvIYDpC65E2NiRqHGryGtarz12gLE1w8Vkg/6C+6+XEYDRIGsUGw5e98twNN/fC7zWUkx7DfTkD6gXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NVjEqG3UsPgfhKhZhB8Ttj/HmxhmILQib1xOuQqTjAI=;
 b=SUE97GdM9lZzBMSyR8cvLIxt/wNlda4E5XoiKlhDoEQkeRbclBINbSboqNPViHYSISmfgoYaiY8GzK0sD/cQlsRrXpjXNXGuDnst+KRo1VllJJvR/ax8BlL12/E4p4THwAJSWyJ1z3jmaa+MezVJMj0R0go+XYbHKXnvCQ+sNbWyYNo4O53TtnPuVVrgsUGXt2mHr9ZfUatcHAvlIl3OAY1jjNSR2x7FmdTpQs9OQY0RNjr0M0GSB2/9y4hPvqMIAfkuBEFLaxPHq/9sK7NxE66Lw9jWrlNaRN3gGCXu7lM96qri7jomtURZ0nX/VfBHv9pDHrnyNNb4V3tqta2P2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NVjEqG3UsPgfhKhZhB8Ttj/HmxhmILQib1xOuQqTjAI=;
 b=KZ2CMG87DKw8sWHEBH1c2QIaUVG7nA/cgcLYB0KGyctoCOwDlJt2ByF6u7QyoVn6WP7hLHWnWADjv1HiouPQ57udCH+iXtKoL5Cmnesy7xL5txX731h1MOaEHBSZwgtRNr3uDnDDIEYj4cX2JLhcQC5pvSMwOdab9EtlE7q5T+w=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by DM5PR10MB1674.namprd10.prod.outlook.com (2603:10b6:4:4::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5293.13; Tue, 31 May 2022 15:51:15 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::cd04:db71:3df4:581]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::cd04:db71:3df4:581%5]) with mapi id 15.20.5314.012; Tue, 31 May 2022
 15:51:15 +0000
Message-ID: <9f002dae-dd47-5a2a-0d3c-a4bf47a2695c@oracle.com>
Date:   Tue, 31 May 2022 16:51:12 +0100
Subject: Re: [PATCH RFC 10/19] iommu/amd: Add unmap_read_dirty() support
Content-Language: en-US
To:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        iommu@lists.linux-foundation.org
Cc:     Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
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
References: <20220428210933.3583-1-joao.m.martins@oracle.com>
 <20220428210933.3583-11-joao.m.martins@oracle.com>
 <3c1186fe-0fa8-7329-c7a1-64ec0bd644c4@amd.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <3c1186fe-0fa8-7329-c7a1-64ec0bd644c4@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR03CA0043.eurprd03.prod.outlook.com (2603:10a6:208::20)
 To BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3f20cc83-1657-45d9-fb0b-08da431d6511
X-MS-TrafficTypeDiagnostic: DM5PR10MB1674:EE_
X-Microsoft-Antispam-PRVS: <DM5PR10MB1674321C4E1FB788EDBD3FB7BBDC9@DM5PR10MB1674.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OB2rlY5M5KIUF9xtDt0AiULLcS2jiCPC1DfgC3bE0zAfrJrFznUby5SBbo6YzoHha52bEVc+oTNl2vkYcW0bNWcEMSJdZHPOA1E90IjUtQ0NCDAhOiHVa7MQ9X0F1znuZKcJFn4C1JCiFsgt2ZTjlo1+qjFnIQY9Z08KVNLhvtzp71ne2RQ01wDKQq9es+ImaJqX9vldBZnXAaGLQwUaZxTQB+RfXjtlK5bdHGVpdlpFPpm8B3yRciJuyr+zWeP5G6y6MumAYy//+DCeubtmX+H3hZGP/MJ33fVUsy8M3Yitxi4MaHCgJURwf6XBPXbnc6V39ZUoP7j5wZHyj/ahum7ucXvz5bDciYXsyxAF6Q9vVroapKoFoKQOl6AyM5iDKriKnVTOQ9kzAgJrxZQEywSMO+bfBlHrHDFS077ZAZsmDnBOvKj+EDQsbDq+E93Jv/twsomLnPDg/BL3uqCFq7v0co9G9rM78oOP/CmBpetQCbKOTluLC4YA465beEssoauFW+4rCHv/o03Guf7u7ee29D581iGM0FR4xwqEsPlXiS+V7SLqBUwhTQMWXE/Al+HpOWY//RnwFD+Kn/Qp1AO6grQRB4pnzXREV4V0RQUXdcxRystL7ougEy7ZEOxdrp8iOqTaL2EOeLCN81lGIuu2vn5VugEd4W8cMoHt7jCealDUSXbj29/nvQb820gaGBO8lJYVXFXkeD2j8GLZsmSO+WYejTW1auGbzBNgcHqZ7Fvm3KjS0xECba6TLnNGfa2/w0UIjnCyBT0BSG+swtDPgPgBxXhiW5k6vylitHB+dYuk3vAl2eGw6NWYrU/y
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(31686004)(66946007)(66476007)(66556008)(4326008)(8676002)(54906003)(6666004)(38100700002)(83380400001)(316002)(36756003)(8936002)(966005)(31696002)(6506007)(26005)(186003)(5660300002)(508600001)(6512007)(7416002)(6486002)(2906002)(53546011)(2616005)(86362001)(14143004)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WmU1T2NkTjNvQmpTMnBRMEpIc29TdXFiQUc2VHoxVEdoTEJpaUxRQlpOTjBB?=
 =?utf-8?B?Q09xaDMrR3hTSWhNMEsyYTZSa09TK1NBQ2JHUWh3RDhhS3p4UlV3bHZsNldi?=
 =?utf-8?B?TVFrVlVOeUJ5WmJJZEVpcnJJUVFiWGsrTjJTS3kyWEoyeTNudW9Ea01sQU1w?=
 =?utf-8?B?Rk96YlEvb1JaSXF6WllqRWJYWFBEbmtNQU85YVY5RHVlT2xkUXZNMFJ5NGND?=
 =?utf-8?B?K09ZRmxmNFNVbFY0THhwUXE0YmtHK3J3N1RIZDJLNFlCUGJycXF2OGo0WUI1?=
 =?utf-8?B?MW9ucDl2NnppSEhNaEZWYTR6bzVTWllRdU45Vzk2TXNtOGxJUEJIQ1hqTS83?=
 =?utf-8?B?a1ZpU1ZsOFN1d2hzVEppaU9lWDRuM0F2ZHB6c1hMYTF0NGtoV0Y3c3pMZUNa?=
 =?utf-8?B?cmVZaHdTV2RPVm9QNnBOLyt6dEJtMEhlVjdyOFNYVXptemJaU0lBTGxWQ1Bn?=
 =?utf-8?B?QStGZ2NmMXltM2JCMHJERzZIT3RqMXg2WEFKN1VPSUFYaUdXSVNVSjIrbjZ3?=
 =?utf-8?B?eDRZNHEwQjZ1YkxwUHVxTnQ3eU1mK0pQdUQ1Q1FrekY2eGxvNzlkRFA2NWUr?=
 =?utf-8?B?T3hYc1lnQkZmanhDOVgzbjhzRzByRGxsWTFzZGZnMHZERkFQVUxnQll6Wktq?=
 =?utf-8?B?MW5vTmEyY0FHYXJtT2xQbmpCRFUwNnJzNFBPZkZrN0huTGhlLy9FcjRMMUtH?=
 =?utf-8?B?TmozRHdzbDRaZ2k1NjRFZlhBMlNVYmRxcE1wMFpCSGdneW1Qblo1S2UvWHJ3?=
 =?utf-8?B?SythRlVEVlNiM0lLZ0FkQ2NIdlFKVVpWYjBWMWp3MlArZS9pSkNiaHhHY2NM?=
 =?utf-8?B?Y2xCQTlGWW9HTHZqelVEUEdURVk2aEd6djdCTzZTWW5vNEpyaVlldW1Qb0RS?=
 =?utf-8?B?NVdEYloyOEQyUkV0eStidXN6T0ZWdGoxSDU5TlM5Z3ZXZ3pYREp5MEU3NlJK?=
 =?utf-8?B?d2o1VjZEZFZ2T09KTGc2Y3ViNzVrelM0L2Jnd09GNVN2RmkrRmVjelRKWWt0?=
 =?utf-8?B?VUh0SVJBeFpIcDhSNlVIZ1lEVUtNdGJFaXk2dTBiN1FEWkdSMENXL0FiK2Iv?=
 =?utf-8?B?MzhXTUdQYTJEanVCbHFydXJZSEs2VnlRN3ZlbmoxcWh6dS9UMklLYTBuRTQr?=
 =?utf-8?B?a3FydnR1cmM2TEZBRlQrVU0vUmhwV21Wa2pSTG5ZcXpTWXljTlA2S2Y2VFZH?=
 =?utf-8?B?cHFvL3ovVWU3TVh3SWZIVTBZbnRqcDZaNWRLNnZ2Z3dPUktkWTZVc2I5QWNL?=
 =?utf-8?B?cVZwdkNGODZEVFRzZjhMbEdxRmY2N3dUOWt4UDcvalFjYUk4SWNFWGdQbUw1?=
 =?utf-8?B?UWhLdEdnM0syNXpVY1F1UE9NalgrcjUwMUVNMGhUMWd4NW1WTklEcy8zeG1i?=
 =?utf-8?B?V1ZtRVFqVGRXMGlyVE5iL01iZDY1bmJyOEhTc1YrMWZUYUJVRnhidUJqQnNu?=
 =?utf-8?B?RXJnNm9jZmR1UUpIZGZjYmFXb1lKeU90WUJsZjFVdFVoeXNEeVV2SnVIcUNl?=
 =?utf-8?B?TjJyWXJCMWh6U0xMZHBzZ3JqblFQK0FHNFEvUDczN1ZZeUtRRW01c0dGR1cw?=
 =?utf-8?B?Y2dyb00wMGxmemxPQnhUSmpYTjVNb0hUYXdrMWZWZ0dVd1VsUnNpcHhhb2Fv?=
 =?utf-8?B?cENiL0xlQ3ZQdzRHaGRoZUUvY2RHdVFoSlZjS0FpT2F0S1FOT3kzSWk0VnRn?=
 =?utf-8?B?SUdIcTNjdXFjTnZtQjFvTHhqbHE2SVZ4c3g3cHhjUkhaaDI2VTNkWGFXTTND?=
 =?utf-8?B?SEtONUkzRHlRUGZRT3BoZzhJNjJsKzNKZVpkNkRjUnZRQ0ZzRDZNYllqUVk4?=
 =?utf-8?B?cytlV2taVXdac1g4VU9KR1hEYkIzK0FqZUlqUnBsbVQ4M3pOSXE2Wm5rRjRS?=
 =?utf-8?B?U0d5NCtsWG1hTm0xTDFTb1ptMGRkejViNG5EMGlOaVhxSGJDcXdzd0NoeEE5?=
 =?utf-8?B?RnB5VFhnTUpsZ2cwa3FnMjZKaUM3WlJKNGpSRnlOSktVb2tHdi9LSUdDN3dV?=
 =?utf-8?B?dEFLNGg4OHdzTk5iWWdRMC9WejNIeG81cllQbm1QTHFBOEkzTFZRdSt3Ykhu?=
 =?utf-8?B?YW5QNmcrOEdrK1l0WVBIdDJBN2tWWVBUSXgvNWpRTENHcmovNjZMTWVjWDha?=
 =?utf-8?B?VkRkdWVJN2gyZE9lZXZsK1dTM1FPNDUzVVV0YW9xdDdlRXl4QmxZVEJZaXFB?=
 =?utf-8?B?c0x5NEN5NW91QjlMMlExbks4QTJFQWZKREhvdUhUcU5JaXgzbURjN1lzT0g2?=
 =?utf-8?B?dE9RSm1QeVl5UXFPcWZYZVhRSjdCVmYyd0IzQ1BzSTdub1JGSGFvdmg4d0NW?=
 =?utf-8?B?eW9jMnV6cVVpLzQ5d0ZhVC9yd21XYjZUY2NPRXl6WDBDb3FwdjVsUnQrZms5?=
 =?utf-8?Q?MraAUtdQ2IT4jjsQ=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f20cc83-1657-45d9-fb0b-08da431d6511
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2022 15:51:15.7961
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fKyo6v1ZuR0kqfu3HBT0HgRDszKlPhbggrews4vWaAWfw4If4IiAch9Zz4hlQAfhbUacNQq68rTsMEA2ZtMc0tdujjuIXxRjWqOgWJkX1qI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB1674
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.874
 definitions=2022-05-31_07:2022-05-30,2022-05-31 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 spamscore=0 phishscore=0 malwarescore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2205310077
X-Proofpoint-GUID: 49P-5SVeqebdXl0YuxwTN3N_BMhxErmx
X-Proofpoint-ORIG-GUID: 49P-5SVeqebdXl0YuxwTN3N_BMhxErmx
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/31/22 13:39, Suravee Suthikulpanit wrote:
> On 4/29/22 4:09 AM, Joao Martins wrote:
>> AMD implementation of unmap_read_dirty() is pretty simple as
>> mostly reuses unmap code with the extra addition of marshalling
>> the dirty bit into the bitmap as it walks the to-be-unmapped
>> IOPTE.
>>
>> Extra care is taken though, to switch over to cmpxchg as opposed
>> to a non-serialized store to the PTE and testing the dirty bit
>> only set until cmpxchg succeeds to set to 0.
>>
>> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
>> ---
>>   drivers/iommu/amd/io_pgtable.c | 44 +++++++++++++++++++++++++++++-----
>>   drivers/iommu/amd/iommu.c      | 22 +++++++++++++++++
>>   2 files changed, 60 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/iommu/amd/io_pgtable.c b/drivers/iommu/amd/io_pgtable.c
>> index 8325ef193093..1868c3b58e6d 100644
>> --- a/drivers/iommu/amd/io_pgtable.c
>> +++ b/drivers/iommu/amd/io_pgtable.c
>> @@ -355,6 +355,16 @@ static void free_clear_pte(u64 *pte, u64 pteval, struct list_head *freelist)
>>   	free_sub_pt(pt, mode, freelist);
>>   }
>>   
>> +static bool free_pte_dirty(u64 *pte, u64 pteval)
> 
> Nitpick: Since we free and clearing the dirty bit, should we change
> the function name to free_clear_pte_dirty()?
> 

We free and *read* the dirty bit. It just so happens that we clear dirty
bit and every other one in the process. Just to make sure that I am not
clear the dirty bit explicitly (like the read_and_clear_dirty())

>> +{
>> +	bool dirty = false;
>> +
>> +	while (IOMMU_PTE_DIRTY(cmpxchg64(pte, pteval, 0)))
> 
> We should use 0ULL instead of 0.
>

ack.

>> +		dirty = true;
>> +
>> +	return dirty;
>> +}
>> +
> 
> Actually, what do you think if we enhance the current free_clear_pte()
> to also handle the check dirty as well?
> 
See further below, about dropping this patch.

>>   /*
>>    * Generic mapping functions. It maps a physical address into a DMA
>>    * address space. It allocates the page table pages if necessary.
>> @@ -428,10 +438,11 @@ static int iommu_v1_map_page(struct io_pgtable_ops *ops, unsigned long iova,
>>   	return ret;
>>   }
>>   
>> -static unsigned long iommu_v1_unmap_page(struct io_pgtable_ops *ops,
>> -				      unsigned long iova,
>> -				      size_t size,
>> -				      struct iommu_iotlb_gather *gather)
>> +static unsigned long __iommu_v1_unmap_page(struct io_pgtable_ops *ops,
>> +					   unsigned long iova,
>> +					   size_t size,
>> +					   struct iommu_iotlb_gather *gather,
>> +					   struct iommu_dirty_bitmap *dirty)
>>   {
>>   	struct amd_io_pgtable *pgtable = io_pgtable_ops_to_data(ops);
>>   	unsigned long long unmapped;
>> @@ -445,11 +456,15 @@ static unsigned long iommu_v1_unmap_page(struct io_pgtable_ops *ops,
>>   	while (unmapped < size) {
>>   		pte = fetch_pte(pgtable, iova, &unmap_size);
>>   		if (pte) {
>> -			int i, count;
>> +			unsigned long i, count;
>> +			bool pte_dirty = false;
>>   
>>   			count = PAGE_SIZE_PTE_COUNT(unmap_size);
>>   			for (i = 0; i < count; i++)
>> -				pte[i] = 0ULL;
>> +				pte_dirty |= free_pte_dirty(&pte[i], pte[i]);
>> +
> 
> Actually, what if we change the existing free_clear_pte() to free_and_clear_dirty_pte(),
> and incorporate the logic for
> 
Likewise, but otherwise it would be a good idea.

>> ...
>> diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
>> index 0a86392b2367..a8fcb6e9a684 100644
>> --- a/drivers/iommu/amd/iommu.c
>> +++ b/drivers/iommu/amd/iommu.c
>> @@ -2144,6 +2144,27 @@ static size_t amd_iommu_unmap(struct iommu_domain *dom, unsigned long iova,
>>   	return r;
>>   }
>>   
>> +static size_t amd_iommu_unmap_read_dirty(struct iommu_domain *dom,
>> +					 unsigned long iova, size_t page_size,
>> +					 struct iommu_iotlb_gather *gather,
>> +					 struct iommu_dirty_bitmap *dirty)
>> +{
>> +	struct protection_domain *domain = to_pdomain(dom);
>> +	struct io_pgtable_ops *ops = &domain->iop.iop.ops;
>> +	size_t r;
>> +
>> +	if ((amd_iommu_pgtable == AMD_IOMMU_V1) &&
>> +	    (domain->iop.mode == PAGE_MODE_NONE))
>> +		return 0;
>> +
>> +	r = (ops->unmap_read_dirty) ?
>> +		ops->unmap_read_dirty(ops, iova, page_size, gather, dirty) : 0;
>> +
>> +	amd_iommu_iotlb_gather_add_page(dom, gather, iova, page_size);
>> +
>> +	return r;
>> +}
>> +
> 
> Instead of creating a new function, what if we enhance the current amd_iommu_unmap()
> to also handle read dirty part as well (e.g. __amd_iommu_unmap_read_dirty()), and
> then both amd_iommu_unmap() and amd_iommu_unmap_read_dirty() can call
> the __amd_iommu_unmap_read_dirty()?

Yes, if we were to keep this one.

I am actually dropping this patch (and the whole unmap_read_dirty additions).
The unmap_read_dirty() will be replaced but having userspace do get_dirty_iova() before
the unmap() or still keep the uAPI in iommufd while being a read_dirty() followed by unmap
without the special IOMMU unmap path. See this thread that starts here:

	https://lore.kernel.org/linux-iommu/20220502185239.GR8364@nvidia.com/

But essentially, the proposed unmap_read_dirty primitive isn't fully race free as it only
tackle races against IOMMU updating the IOPTE. DMA could be happening between the time I
clear the PTE and when I do the IOMMU TLB flush. Think vIOMMU usecases. Eliminating the
race fully is expensive requiring an extra TLB flush + IOPT walk in addition to the unmap
one (we would essentially double the cost). The thinking is that an alternative new
primitive would instead wrprotect the IOVA (i.e. thus blocking DMA), flush the IOTLB and
then we would read out a dirty bit and the unmap would be a regular unmap. For now I won't
be adding this as it is not clear if any use case really needs this.

	Joao
