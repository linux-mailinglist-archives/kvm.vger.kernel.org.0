Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C561F5147BC
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 13:05:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239171AbiD2LJC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Apr 2022 07:09:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358116AbiD2LI7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Apr 2022 07:08:59 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ABEF2BB3E
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 04:05:40 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23TACU3Z025790;
        Fri, 29 Apr 2022 11:05:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=bE+e+3F6DLvJOc257l9fIR4+mDqKCudYHmeB35MWPWM=;
 b=Js8DjPskpok8erMAOprT9A1SWvft7REYQ66CMNe86/uolck27l0eTy5+TBzUbZRRDn7a
 VXtXVUuXA2e3lnPRFd52jp/iBLoK3D/Qsj4pFNPdx7Al9j5I3XlpT5O4umQ1qDBidtFZ
 SdcBAkvq+XqX9iuq59TsZTZvImY3nFD6euBLsp4LVAC3eu30sJ5b+Ya27B4z9xjbM3Hu
 GLvbDDj1vkQYvG3nIHpYwB400R14YB5fe+fjUIFkGzggH/ilGb70XtU56lC7lz2khQnl
 73XRBrTpksnw0OjGpPoMKfyHNM/6kd7/XDXCPe3akI8NDg0a0F2ZvP1F0kWfmbwqbVNM bQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fmb1mxk0r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Apr 2022 11:05:16 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23TB0F9F025464;
        Fri, 29 Apr 2022 11:05:14 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fm7w7w55t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Apr 2022 11:05:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VBI7xKrRc3VC2Tap7Pb8WNLGs00Oo0KSvCtvfeM0PaOJfBoNZGwx2e/2CQ0OmEfB1BcRQDxPQGGKY1fd0xc/vZwue2H/tEeRKVOMbJMvbfKkOOvW79QwRbQX9BkYLe5ixUJB3YBOTtFQ5/WZ5n/Iw9edCT6+IoO3UibSabF6MEi0u/Ki4jX2LECICJ9n4GoSCXecfmMIpyDF5e9tsQDuhV5AZ/s8TisvHEX7//8ZA9QMJY9H4AMZzoGVu2rz+1GMzTnuAlR3aqY+geR03Saod8+Z9G3D3av3mTXloMKISgh9xJIRt+y0cRVlneSjyGKWpFtjzNomTTVuNA+ZrOkiLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bE+e+3F6DLvJOc257l9fIR4+mDqKCudYHmeB35MWPWM=;
 b=dV9WQ9R9DaPvOUzUquoi2SH7HjXN3ubK1NWmLm3/zFZqlpKI61EvgRUUQggZj6fYhgp/2v+op5rvBsMm5fXoVdsmfwa4ZWTynkDV2JVQoLQlVb88OgXSjikMz5rdnE6wiFtCeHW8QUAiMgksib1So9Bc6gmuPv7G27ZFnbXHxEjIWDXAexpPGoY08vhHeRflnp7FnLIWPJUr6TpqJJIbdi8iYwR9cqbbpPatdqNFSp4cpy+pHQnBLq3/AHwW8/2yJG98/GZzXr7m7N+jlSAgcldSv31CyPTxozcTChrA7/R3BLyCpxGd73hZemZ+lXeJ3D7aaszsMctQOeQfzWrJRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bE+e+3F6DLvJOc257l9fIR4+mDqKCudYHmeB35MWPWM=;
 b=Ja6TbmJ/GyGpK3SVH6ngPiiy43YLs67RLNM/Dy2n05g5cMZIW47FcsySsd2DeW3f3J7ag3f6TftE2Bs5nzLOvK/TcUhGAeQQMRXYGVFJ/jF+spYOTmMBp1hXq5UOXxMu7yeLlkBDKaiOjrFriBwTvOYC7W+gUSdSEMvojK2u1PY=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by DM5PR10MB1804.namprd10.prod.outlook.com (2603:10b6:3:10b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Fri, 29 Apr
 2022 11:05:12 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d%5]) with mapi id 15.20.5206.013; Fri, 29 Apr 2022
 11:05:12 +0000
Message-ID: <f37924f3-ee44-4579-e4e2-251bb0557bfc@oracle.com>
Date:   Fri, 29 Apr 2022 12:05:05 +0100
Subject: Re: [PATCH RFC 15/19] iommu/arm-smmu-v3: Add
 set_dirty_tracking_range() support
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
 <20220428210933.3583-16-joao.m.martins@oracle.com>
 <BN9PR11MB5276AEDA199F2BC7F13035B98CFC9@BN9PR11MB5276.namprd11.prod.outlook.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <BN9PR11MB5276AEDA199F2BC7F13035B98CFC9@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR03CA0101.eurprd03.prod.outlook.com
 (2603:10a6:208:69::42) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3ad6d565-cdaf-4376-ef2f-08da29d021c3
X-MS-TrafficTypeDiagnostic: DM5PR10MB1804:EE_
X-Microsoft-Antispam-PRVS: <DM5PR10MB1804543A39C5B35732FE7E26BBFC9@DM5PR10MB1804.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CXJU0Dt/RyuoFrXFA5UB7I2XL3+9Y00/4V5/t2XyyBMNV9Vj2MsA5VH++j26dGtD+29K/S/CFOZbiM3BqJ7xyj1kpYhqTGYCYT9E1I7qVkjq/6zXozr/djniNNv45RvYziBSTGTTe7h1K95A6VrCaOLolVAtiaBv67X8g5YYp0V+U8r4VLmUi9a9nLcfYh2NZKzZcpyK+4vufOraGK9UbUx7Srd2FQ3XDwIq6drdk7pnopBDgkMm3+VDJ+8jdROP1PQeUEaSd/EghUnAxFgW9vwDS76mdlmKuDdWDtxjlJ1VFazuJUpk1ENHxZkBnrU0/dDo3idFGnL2zT9QmlyWAMjPqCnOm7r8rlRkH80Khkn1Ktf18+q0PqNk2oM5WN+3apkQAO7+h2H+WEN/aZkAYf+sYhvDQHUbjS3q6U9UTdGVL/aGd5R25HG88CvT3nWqSInfnZGUdF/3gpuG6tGxMlJYrB0UNaYwkFyLcABxzhn65nVQPyh5byQ1U3PTFZpPjN4lzSI+l91KDcEm8YzOCqS+Zq9Ijhrl9vSi//irQHEkdoMurpcSsJjWmaUOFdY/jdk21F9kz95phx8WyZ5LYOE1/08Dsx0JMiPWjlqd23yZcAntEfoeNO/RpBqCanlqtPqgzFKKRPF36m2/NHMvImuKSYSrRTQiD99ZkXsHuKRx084mVB20bYuLjhtZYsJN9fA7JcblV5RQCawIdUTVTRamcvpAKXxrFWo8M6Pnffc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6506007)(2906002)(53546011)(26005)(66556008)(6666004)(2616005)(6512007)(31696002)(83380400001)(5660300002)(86362001)(6486002)(186003)(508600001)(8936002)(7416002)(36756003)(38100700002)(31686004)(54906003)(316002)(8676002)(66946007)(4326008)(66476007)(6916009)(14143004)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WEZMbmVVVUdBcWpKdVF1V09LSUpUdzF4Ympydzd1dVVublRNU2JXMzMwVnBs?=
 =?utf-8?B?d1A1Z3oxVGgzY1VpRkd0RVJpekkxT0JVT2hyMlVIdXlxMm0yV2ZmSlc4QWhE?=
 =?utf-8?B?WnlpTWpoV2JsenFYOW5HM0dlSnVLbmtHTHhsMUFZNmJnYnJkQWNBaE1HUm5B?=
 =?utf-8?B?VVdhenBEU1dkUTlzOWs5RHF0dmtya3gwS1ZZUGhIV0VuZ2xjZGdQYlFaUkhT?=
 =?utf-8?B?MjZXUnordk94SytyVXdna2gwNUNWMU9BS0xTR1E3UXhxMnNOSUFJalU1eUw2?=
 =?utf-8?B?RGlmenVtRENVaVFHOExYR0h3Vk4rNUQvMlVINXRJckc0elY2T0Y5UUozRm16?=
 =?utf-8?B?UVBUL3RzVEZvV1ZLYVgxR2lJanJpKy9FQ2FwL3JuSXoxM3J1QW5zTWRUdGVp?=
 =?utf-8?B?clBsK3Arb2czUnEzMWc2aVp0ZmVqbHVjck84NjF4bTlHeHN2MWxUejhnSlFw?=
 =?utf-8?B?VVFLYk5sODhraUk3UGRGM0pDT1hLRC84Nms0S2RsY3JjYU5qRDdYa3VUNkFj?=
 =?utf-8?B?UWQ5VzJwYm5CUjh3WmNYRnRZbHlTT2hVbTUwazlxUEhuYXJBLzZ6cXNEaVZU?=
 =?utf-8?B?dXVhd0JnOW54VEZTSVI4UUdDaVpJR3p0alJoSFFqZEZGTWxLZHQzTzZmOGdB?=
 =?utf-8?B?b3hycTExdm8yVktBN1lGd2U4dDdDYjdxOUxFUFh2V0hMeXdYVE9PTTFreXJO?=
 =?utf-8?B?b0srUWFUWDNVOENjVzFrQU91ODRCdHB4c1pCUCtzVVQ1UnRBWU92K09ncXVG?=
 =?utf-8?B?R3BJbWMwbnRBSksvRWs5TXNMMi9YWmQ0T01TUkM0RHEyYjM1bnZ5NWVkSnhq?=
 =?utf-8?B?RkY4WG1YNHpvdWFlczNNREJGZTBGdGo0ZnBlT3A1QmxyOTdMWEtFanFaVjVH?=
 =?utf-8?B?OFgxbWZYS3Q3ZlM5ZWlKQ2NveWJKc1dieDVFTnFlZ0ZibUJxQzNBYVF6V0tC?=
 =?utf-8?B?ZjUrZGtyWGZRa1diaytYdGFlVGdtc0wyUEFLUEtRN2x2WlUrMjgxaEp6dGZT?=
 =?utf-8?B?ZnpxZnFCSGx2VlBoem9PVlRoQW94YzdvQ3o0UG5KaWNURHBObUVsTzRxaHFi?=
 =?utf-8?B?NTQ1SmEzNUUrR25TWGY1bFV2MCtCZlpkZlEwcnpYYWZBVDVveFlUUitnNmls?=
 =?utf-8?B?R2tINEYxM09sK3djdFZreWNhWnlkck0rRzlLUDFCQ0s3QVFzR2xWUzBYMFg2?=
 =?utf-8?B?S1F3b3d4NmJwZi9zN29NMVhFZXUrZnJXN0M3Um9ESDdTNlFKT3dsUTRPMDcx?=
 =?utf-8?B?b1RpMmk0U1ZkWGxhV1Q3VWRERVVUYnpIL1k1SjIwbEtreldFTEw1UUVXajRz?=
 =?utf-8?B?bDFSWk8yZ28rcnNhdmRubTBoalorYnJ6UzhTOUMvRGt6eWxpRE1OaWJycFd4?=
 =?utf-8?B?SG5pRzVranBZNWV4ZXA5bnZmSU9tVk8vaU8wZ0xMNFc0czQvcnVwWEdDTno3?=
 =?utf-8?B?TmJXWHp2WXJjNlExOGF2U3ZwQW9qck5Yajk5d2RJK2hYMjJJUWxwMU9FZ290?=
 =?utf-8?B?MEwwSkd0UDZzUTZGeWdZajdoU2lNT0JWNzJSQnFieVZpeUZLK3V5QkgvNWJs?=
 =?utf-8?B?bzliWnNtUGxQcmM5WUtzWGthYmpjQ1ZZMEtKYjZuS1V2bGdPNGFXOE0ycE82?=
 =?utf-8?B?UU1vb1prb3luR2s5SHlldmFXMzYzdzI5WGh4SG1Rd09tTWY1SUttZlc0Ym93?=
 =?utf-8?B?cGZwM0UrcWdwSTBuZUQwV3V2NEFhbUt0bDhvYmwrSXRMbllyd0F0WXQzWG9Y?=
 =?utf-8?B?TmgzZjRIQjdLM240V28vRVBnVnJiMFM4OEJoYXZDUkY4Y2pRUHpaTDV6Zldt?=
 =?utf-8?B?Z1FCeWxHQ0Q5MXRIYXZSRUZiM3FjTlR2MTdZU2t3dGRKOFZHMDFnOFNRQ1NS?=
 =?utf-8?B?OGxGd3Yza3BFOFJkTjJvVnNIajNlQnpiTjlTY2tSZzBWLzZjd2xRaVF1aSt5?=
 =?utf-8?B?eUFUMDJGSEY1RVM4amxNZjBseFpOeGVJREVWN21RL1dQeXU1WkpVdHVIWGFP?=
 =?utf-8?B?c1VsSzg2TUtneEFmQ2dmSjl0RS9aMEoxalgxK3ZVR2pCTE1xN09OKy9JWDdC?=
 =?utf-8?B?Qkl6RlZWQ0xNbGZiN2dQY1hIM1FNWGV1aTJZejZUZmlCaVdDcS9WaU5kS3Ax?=
 =?utf-8?B?c0k2Qm9XL0xsUG9vRllvZDczQ0FtUE51djZZcWlQZElueGU5ZjIxSVN1b1hS?=
 =?utf-8?B?R2tiby9xMDBmMXJjTHI5WWxWNXFCSFRrOWlSYTY5K1I5S0Q4R2phQXRZbEt3?=
 =?utf-8?B?d25TOFdUNVhJZUFzV2dOc2Z1MGxPcDMwUWNOY0hJb2IwRFNtcnFlRFBkWkFn?=
 =?utf-8?B?M2VCckxEbmZieGtFcWlPMGJUZzB2OWRmWXlNVE1FTzFzVVVLNkl2cXJwTElR?=
 =?utf-8?Q?0yTaF1HVzu66nBiU=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ad6d565-cdaf-4376-ef2f-08da29d021c3
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2022 11:05:12.4489
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TC+/0V/Cx9Z/aQyRbU3ahnuUYJ6DXgkVdtPFVr+BkFvHcyetDHeuGVOhx289U9rj7lxqEb7KESjZKlhutaflBkcmyzOHV+U5bw7AmlFrnXs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB1804
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-29_04:2022-04-28,2022-04-29 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 malwarescore=0 mlxscore=0 phishscore=0 bulkscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204290064
X-Proofpoint-GUID: clUB-cUvELkwR8CmLs3Y5-6pOxdEANwz
X-Proofpoint-ORIG-GUID: clUB-cUvELkwR8CmLs3Y5-6pOxdEANwz
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/29/22 09:28, Tian, Kevin wrote:
>> From: Joao Martins <joao.m.martins@oracle.com>
>> Sent: Friday, April 29, 2022 5:09 AM
>>
>> Similar to .read_and_clear_dirty() use the page table
>> walker helper functions and set DBM|RDONLY bit, thus
>> switching the IOPTE to writeable-clean.
> 
> this should not be one-off if the operation needs to be
> applied to IOPTE. Say a map request comes right after
> set_dirty_tracking() is called. If it's agreed to remove
> the range op then smmu driver should record the tracking
> status internally and then apply the modifier to all the new
> mappings automatically before dirty tracking is disabled.
> Otherwise the same logic needs to be kept in iommufd to
> call set_dirty_tracking_range() explicitly for every new
> iopt_area created within the tracking window.

Gah, I totally missed that by mistake. New mappings aren't
carrying over the "DBM is set". This needs a new io-pgtable
quirk added post dirty-tracking toggling.

I can adjust, but I am at odds on including this in a future
iteration given that I can't really test any of this stuff.
Might drop the driver until I have hardware/emulation I can
use (or maybe others can take over this). It was included
for revising the iommu core ops and whether iommufd was
affected by it.

I'll delete the range op, and let smmu v3 driver walk its
own IO pgtables.
