Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E633651473F
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 12:49:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358032AbiD2KvD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Apr 2022 06:51:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358260AbiD2Kuy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Apr 2022 06:50:54 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BE1226ADF
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 03:45:21 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23TAiQPp011396;
        Fri, 29 Apr 2022 10:44:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=YvIlKqX1jdO8j2SMl1Pp2XjqT+m3KXUKu/FiHDFcLMo=;
 b=WbVys2K5NLgyMapejYUk8t8hVsPfsej8zb+o997JTdA1XWQnbEeAj7FFgs8mJ/S7VwmZ
 3dtnMnWV0S4oeXpDG65vXMe7/0ZM8Q9o18jJpygC4kjO2yppMQLBkrIIXI9K7MiTZtEh
 co98XVKyc1nsqo9Uvnn4N+EQPPhAm/7ds0SGGv0eP26eVsLBcL33aJz2rYLfMRpconDD
 rK8H2TrQuaiGty9rpqubwRzK+vqGmlUYyTYQMU+3CDP74ZOZ7ZuOdap8wx1Xi9JsisZi
 /CBxP+ggZFcZoUQRPMC+CdvoREjqxbDA68PdnVe3Pb6o4ibPF8y73Sd4+LtOZuWx6dit 5g== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fmaw4phem-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Apr 2022 10:44:50 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23TAeFw9020722;
        Fri, 29 Apr 2022 10:44:50 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fm7w7vqmy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Apr 2022 10:44:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VFLDERcNUAk2Xfi/sWF5rvyXuCjX2IvBLreb4SSJQogO4Os6b3oRIp3KCo7tyhTx5L5e6Xt8D6LNFEbhp0llAoIwa6UqxJqaZ1swe8TESc3mRhRYbAtNitUsmX6W5KWRPiUyjBgQRZmbFo4GGE4u2E3hgFJ0kmSEbesV/o8p8Ws9po0yw3RF1X6cLjKmAeUOtHDuupk8u+AX59Q7c3YbRtJXgQQHujir2vBNinJJbY+K19RBsX8dqpxnPhnaDpDetLrvrMG39c5TOX2tO9HVVFvnwOnCIz8XNTpzRh9R0isxsyiUnEFTVib9WNQI4zIabEYcXPk0NDzpAM7DrEgAyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YvIlKqX1jdO8j2SMl1Pp2XjqT+m3KXUKu/FiHDFcLMo=;
 b=HMsof7IcW1nvFA/TMzREZzLbt0i51kEJKFw5p6O6OQHCY0jCwE55RIKFb54OKzCZO9qj0Z62BXilJcIB7eP5rHy5GFeQXJfQNDO9MsvoZnvDHN6fTww8toTu5Or4+SnjY5IqeWdwICmPoXAKw3wSfWjhWno7SgjhklnfAV9srXH/n3wxei2TTbFnAy+9VNckVUp4wwjsf1O/5USpXwScIVaZs39dk21gap+UQERd8oQjxE7CqFcHi9P8OnDmpeOLSg1ccO3d0KnrvmbAtAselFtWBj3hhvgTM7bHsjGZVsGCOYXsF0LwX3Gsm94H5XzLHmTjLHtzy7AcUEQoTsqjUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YvIlKqX1jdO8j2SMl1Pp2XjqT+m3KXUKu/FiHDFcLMo=;
 b=EhRRJp4oRTUvzjErlEsVPNtBGZdo15D0PN2fpuxxnKlrBf3un03e/jSeDBqpLQaBkrO2MEhsYCnzeqOiKpe7ZhZb8zqfTcS/OP+GxnmVkXeMtOWTfEuUkXnlPtmAmUyssRxXTVkFAK6lJo3NDw5zsZdadWzekrTSW2BKzea0e1I=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BN8PR10MB3220.namprd10.prod.outlook.com (2603:10b6:408:c8::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Fri, 29 Apr
 2022 10:44:48 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d%5]) with mapi id 15.20.5206.013; Fri, 29 Apr 2022
 10:44:48 +0000
Message-ID: <f07188e8-501f-770a-b9a3-c7ea2907c969@oracle.com>
Date:   Fri, 29 Apr 2022 11:44:40 +0100
Subject: Re: [PATCH RFC 01/19] iommu: Add iommu_domain ops for dirty tracking
Content-Language: en-US
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Joerg Roedel <joro@8bytes.org>,
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
        Eric Auger <eric.auger@redhat.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>
References: <20220428210933.3583-1-joao.m.martins@oracle.com>
 <20220428210933.3583-2-joao.m.martins@oracle.com>
 <BN9PR11MB527684203C6344FF46B4163A8CFC9@BN9PR11MB5276.namprd11.prod.outlook.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <BN9PR11MB527684203C6344FF46B4163A8CFC9@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM9P250CA0019.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:21c::24) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a801eb29-7891-41e9-6a3d-08da29cd483c
X-MS-TrafficTypeDiagnostic: BN8PR10MB3220:EE_
X-Microsoft-Antispam-PRVS: <BN8PR10MB32206E6B8DAFDE9199791295BBFC9@BN8PR10MB3220.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YqtuuzKLYT+d8Cy/XlYNYUlbEHUc10Ot2Hs40r9mToM+eg6GedV4XkBkhP8jZ5Kkai4MZNGKlVF7XU2gdOu6154Mq1RQ+stddawHKJDZuFRHZo5JQExbIxBB4FPvwSLlq8K2pExQxo0/h1Nrlx5/PJBKA6g89NZ9MfhC0gR3uBDQOSUQvI1gi+MbMDoWFipw30pVTedclioaIVQ56O7z3dy1jQcc9hZCPQXknNgZX7/XWJ4tBD18Prdv/JredWCLVDBBTrIbMEj3t1KWvFWzZw2qulsedkce6EyynipRP+h+eCMjbg9Q10HkhYW35pXpv+9wy7NCBkJQlLrCbF0IOy3D+1Q7hXfe4OKDcw8FyGQJbmQbMxcghvcJc1/s56CEWP9LOeF2dSiX+yZd80iQI0o6GwqbPOr4Uto1AG6OvcCSX6678Lck+CHWxs1RfgUS0p2ws+KRb3V1pN8tLDxoQFvjw8ozDhR2OF28VkkL3VfnsAZ3foLqeA4q5T76uR8JVpvnwjkRonPjcK2IfbgCqU1kinoVa68Vi5SC6CMhuljPcEZmmGZF0447MPMy22ZBD4sRYIy8in31GluFaG/LM7hdSCmEzi+N9rijcPUOYzzhhg5yFl6VgHQ+5DxEjpFOu6i9vc6VwyfEuZrMwygz3nf89EDKHQvJOsSABqUixoZ5wiBPxSNV/TpMRgELP0xl3Aq2+wxSc6xT/KT/l/fZQyIJEfJSdzVeOdNRcojkw4g=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38100700002)(7416002)(31696002)(2906002)(6666004)(8936002)(5660300002)(508600001)(186003)(6486002)(316002)(6512007)(4326008)(26005)(6916009)(54906003)(2616005)(66476007)(66946007)(66556008)(53546011)(31686004)(36756003)(6506007)(86362001)(8676002)(83380400001)(14143004)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NVk4T1N5RmNhSkNLZDhXOSs0N1IzUlFsNGRRMm56dENLZGFTbjJ5NnBkM0RQ?=
 =?utf-8?B?YlluQjZPRU9YRlE4b1B2U0Z3U3VTRlpKWHdhV3lmcUN1blR4dzNXUUsyc2NB?=
 =?utf-8?B?U05FQjhPUmw0U0dWblMzOHhaWGh6NHBlV3REWkJLQzBBSXIyT0NpaHVHUncw?=
 =?utf-8?B?M2ZYU2F4UDBNamtBQzA4ZXluWEVhaEhsTnlPVHdyNmVRbnBzeHlqUC9FbXhO?=
 =?utf-8?B?NkdDNU1lcFE0MVFnMGh5Umo5THFzd1ZGNHpRUnFGUEpsc0o4bG1HbTVHZndx?=
 =?utf-8?B?aXBDOWMrdEZldncybXRIM3BTWlpxVWI4UURkR1o3eEhFajk3WFFoWHpoa1Jk?=
 =?utf-8?B?bnhoUVVIRk5WRURZRnBSQWVYQTl4Z29zdWxTMS9Fc0x4dS9ZS2E0a3ZjcVdK?=
 =?utf-8?B?QjF2eWdMR3A3cmNad3NCY1crU0cwRy9UNjV5c2ErS0xrVmtjRlhtSFpqVFEy?=
 =?utf-8?B?Rk4rZHdCZFZOUHFFSmsyci95elZvRmNmT2lzM3Z4UnNiem1RRWs2STc1dlRZ?=
 =?utf-8?B?N2ZrWW5FcGVPYVppTzVnaVppMTlobXNGT21XN0QzVlZCajFsSFJORFV2dTg4?=
 =?utf-8?B?ejllV3BkeHhFaDNPQWQzZVI3OWRSMkRmSnEzajZBWW9uVEZDMmFoOVJiNW1O?=
 =?utf-8?B?ZEtPWmh2VHpmYzVYSWEydXBhUVVTOFNsbGZiWjNNTmFqMmRnaXdYdzhHWmRD?=
 =?utf-8?B?Z05vK2ZoaWd1RjJZYjlORUF6a1I3bWpHc0JaemM5YzdTT3RrT0ZxK0xLTjJQ?=
 =?utf-8?B?NFRvdElPTHdWRno2VjNocEJZZDJuQytOVjVCT3graHBBWHZMeG9XWTFwSnBt?=
 =?utf-8?B?ZkNqOFduSzIyNDE1N2FOdzFiU0VsTm5aNGwxNDlsTldkdHpISGxGaEJ5UzFm?=
 =?utf-8?B?OUVKQmR6cU12ZDlZcHRQUnh6NjlMYm0rZFlRbFZHZW4xM0NzeTlQOXFGS0li?=
 =?utf-8?B?YnNhU3VVcmN4a3JhUDF1Z215OXBxWHd2ZE1sWmdXOUxlWTBuUy82Vk5qTU45?=
 =?utf-8?B?eUkwZ05lU2RQWTY2K2dRMlVCdlhrQUt6SnFoTFJyQXQ3cjFYRFdZQUlIWCtp?=
 =?utf-8?B?TmQ3eTMwVmxSVElydXJHanhXdng1VTBjZmZVMUMrNHRzN3MyRWZCS1VjNmlM?=
 =?utf-8?B?dmRsMUxXUEdjRnJwdWYvdFBzbDVYalBNdVNOd1UxME9BZXNUTGRCVnZPNFdF?=
 =?utf-8?B?S2pTREErcTZDbEs5NnI3R2V1bDY2QWliUnpDOGxhMVdLcXo0YXorSjBjaEZh?=
 =?utf-8?B?NnNGZDF5bEc1ZDdkd1laNWUwMUxjMVB4QytRdjVjNWpCeXkvUEFQS2FlbEN5?=
 =?utf-8?B?U2YvYXd4QytWZXlkSHRNa0ZuckhlczRueTJlbFhyL1lzd1Vzd2FYb2h4Zmhz?=
 =?utf-8?B?bkxMaXpsWG44MTdlRUM5L2hGa0QvU2hjQTZERVdVaEE1THpEd0NQRDN6YU9r?=
 =?utf-8?B?VmQrWjJoS0F4S3pDeUVlVWE0UmFnT3liSExUUXo1Ui8vQW9kOTlGV2pWdDNk?=
 =?utf-8?B?R3VZbGxaK1pKWlhjdlhreHNrVTdxNDRPbGVxc1lXUlI5SzZubTRFVFdWWnNo?=
 =?utf-8?B?cHRkNFhzUktRMW1WRmt4RVRpWDRHWjJvdTFnT2xrU3hvb0RrZThJV2s3cVJy?=
 =?utf-8?B?Rmx0ZlkxT3YzOTEwWlJ5UzZ4R3pYYVY0ZS9mdmVUZk9DQlpFV2cvTUVuNXJD?=
 =?utf-8?B?Q3YzcXRQRkJqTjNBK3g2bkFQTzFkdjJSNnhRZGprS05qeFVER0V5d1FHMVlF?=
 =?utf-8?B?L0hFSW4rZHk1QmpTV0NPdllGa21kSUdPMm9BNGcxbmVEdWRpNnBHZU1iSkpH?=
 =?utf-8?B?cGNMdnVzUDlBN2RXTjRSQWo3ZXBmNlE0WVpOSHhvS1oyZk9MRmJiTlZBbzZv?=
 =?utf-8?B?UUZBaVArM3h3N08zcytQQ2xVazhnOXZUM3dtdmMyb3N3NVozTGxsUmpvWDd5?=
 =?utf-8?B?aDVtMmljZndxaWppMXFjNThxT24yczNCMHlHaUVPQUt2Ylc3WWJvcHdUUVpD?=
 =?utf-8?B?ckRjNDAzTDlmamFPZTgxR2orbmFqc0QwWlBrSXc1UHhWZjhFOVVlaVJzV0gw?=
 =?utf-8?B?a0RhMnBFTUZlUVdDSVJYNFEydFJSeTFGUzB6Nk15T2VXek83d1Ird1BOam9r?=
 =?utf-8?B?dVovditnZlZTUldLUlg5aDVLZmZsRjdxR2NlYTFvdG55eEgrWHh6M01mYnJh?=
 =?utf-8?B?d3NUTFNMUmhPZjd0ODk4TUY5ank0MXlqR24xK2N2VUlLRmVlelY0MTU2Vmx5?=
 =?utf-8?B?eDlDNkdjSjA4dFpKS2VBVEJhYWdoTWZibndjQUROMmVTZFpKUDY3TXp2NTd0?=
 =?utf-8?B?V0hOSEVPSm9zSW0yNy9KdEJuL0UyYjlPNXMwMjA5dlNHR2x2SjZiZGhvRXZY?=
 =?utf-8?Q?t50oaLW/a4m1Wc7Y=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a801eb29-7891-41e9-6a3d-08da29cd483c
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2022 10:44:48.5487
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h25lGAC96PyHv4f8d7qAAczSfpkUUdV7aLx/mItjosZJnKIfoQ/F33O6PoYTGSZxSa7+/4O0y72cXUUGU6AeZvfVZkiGzqrYXuxVRpM59yU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR10MB3220
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-29_03:2022-04-28,2022-04-29 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 malwarescore=0 mlxscore=0 phishscore=0 bulkscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204290061
X-Proofpoint-GUID: v-oXG_K9WKdieEEnb13lJsKBPQlbIuMd
X-Proofpoint-ORIG-GUID: v-oXG_K9WKdieEEnb13lJsKBPQlbIuMd
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/29/22 08:54, Tian, Kevin wrote:
>> From: Joao Martins <joao.m.martins@oracle.com>
>> Sent: Friday, April 29, 2022 5:09 AM
>>
>> Add to iommu domain operations a set of callbacks to
>> perform dirty tracking, particulary to start and stop
>> tracking and finally to test and clear the dirty data.
> 
> to be consistent with other context, s/test/read/
> 
/me nods

>>
>> Drivers are expected to dynamically change its hw protection
>> domain bits to toggle the tracking and flush some form of
> 
> 'hw protection domain bits' sounds a bit weird. what about
> just using 'translation structures'?
> 
I replace with that instead.

>> control state structure that stands in the IOVA translation
>> path.
>>
>> For reading and clearing dirty data, in all IOMMUs a transition
>> from any of the PTE access bits (Access, Dirty) implies flushing
>> the IOTLB to invalidate any stale data in the IOTLB as to whether
>> or not the IOMMU should update the said PTEs. The iommu core APIs
>> introduce a new structure for storing the dirties, albeit vendor
>> IOMMUs implementing .read_and_clear_dirty() just use
> 
> s/vendor IOMMUs/iommu drivers/
> 
> btw according to past history in iommu mailing list sounds like
> 'vendor' is not a term welcomed in the kernel, while there are
> many occurrences in this series.
> 
Hmm, I wasn't aware actually.

Will move away from using 'vendor'.

> [...]
>> Although, The ARM SMMUv3 case is a tad different that its x86
>> counterparts. Rather than changing *only* the IOMMU domain device entry
>> to
>> enable dirty tracking (and having a dedicated bit for dirtyness in IOPTE)
>> ARM instead uses a dirty-bit modifier which is separately enabled, and
>> changes the *existing* meaning of access bits (for ro/rw), to the point
>> that marking access bit read-only but with dirty-bit-modifier enabled
>> doesn't trigger an perm io page fault.
>>
>> In pratice this means that changing iommu context isn't enough
>> and in fact mostly useless IIUC (and can be always enabled). Dirtying
>> is only really enabled when the DBM pte bit is enabled (with the
>> CD.HD bit as a prereq).
>>
>> To capture this h/w construct an iommu core API is added which enables
>> dirty tracking on an IOVA range rather than a device/context entry.
>> iommufd picks one or the other, and IOMMUFD core will favour
>> device-context op followed by IOVA-range alternative.
> 
> Above doesn't convince me on the necessity of introducing two ops
> here. Even for ARM it can accept a per-domain op and then walk the
> page table to manipulate any modifier for existing mappings. It
> doesn't matter whether it sets one bit in the context entry or multiple
> bits in the page table.
> 
OK

> [...]
>> +
> 
> Miss comment for this function.
> 
ack

>> +unsigned int iommu_dirty_bitmap_record(struct iommu_dirty_bitmap
>> *dirty,
>> +				       unsigned long iova, unsigned long length)
>> +{
>> +	unsigned long nbits, offset, start_offset, idx, size, *kaddr;
>> +
>> +	nbits = max(1UL, length >> dirty->pgshift);
>> +	offset = (iova - dirty->iova) >> dirty->pgshift;
>> +	idx = offset / (PAGE_SIZE * BITS_PER_BYTE);
>> +	offset = offset % (PAGE_SIZE * BITS_PER_BYTE);
>> +	start_offset = dirty->start_offset;
> 
> could you elaborate the purpose of dirty->start_offset? Why dirty->iova
> doesn't start at offset 0 of the bitmap?
> 

It is to deal with page-unaligned addresses.

Like if the start of the bitmap -- and hence bitmap base IOVA for the first bit of the
bitmap -- isn't page-aligned and starts in the offset of a given page. Thus start-offset
is to know bit in the pinned page does dirty::iova correspond to.

>> +
>> +	while (nbits > 0) {
>> +		kaddr = kmap(dirty->pages[idx]) + start_offset;
>> +		size = min(PAGE_SIZE * BITS_PER_BYTE - offset, nbits);
>> +		bitmap_set(kaddr, offset, size);
>> +		kunmap(dirty->pages[idx]);
> 
> what about the overhead of kmap/kunmap when it's done for every
> dirtied page (as done in patch 18)?

Isn't it an overhead mainly with highmem? Otherwise it ends up being page_to_virt(...)

But anyways the kmap's should be cached, and teardown when pinning the next user data.

Performance analysis is also something I want to fully hash out (as mentioned in the cover
letter).
