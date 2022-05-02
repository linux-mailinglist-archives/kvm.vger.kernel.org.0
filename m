Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DCAF516F86
	for <lists+kvm@lfdr.de>; Mon,  2 May 2022 14:23:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233404AbiEBM0k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 May 2022 08:26:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233877AbiEBM0j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 May 2022 08:26:39 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03CECB872
        for <kvm@vger.kernel.org>; Mon,  2 May 2022 05:23:11 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2428cmoL030616;
        Mon, 2 May 2022 12:22:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=lgJwMKNSOzMKmzKZ+nZOEe91eUialJDSecx3CkjSpSM=;
 b=hZ4j/ev+WUL1DghMPw9bs4p69QVS4/5jTZkfKeXjolBP7hFoaeLxFyPpSLivBUNk8F8m
 N991hJMt5CHMk7I2tmcXB4zaDVPvWWfueh28WkUxbu5+HbWedb7rQ5Wmh+6Lk7fcbxl5
 b3+tNE8T7yvi+6Bbezk71nkpen0JqytT68cJ4UtQ4fnJ8qRCimcFVlSUxAko25KVI9CV
 cwCdcuph6GtWN946fFu6VNSLe/6BOBTeDBiTrTj24kI5ts1cFI6U7WZFVwMbAI6l1WZe
 sSG8HrDKChwYWj9nWwBXws2tvijpXVm1jPcDtfRvkcLfFnN/S88llYSmpLg+PjPgfPMb oA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fruq0b2v5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 02 May 2022 12:22:48 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 242CKNim026211;
        Mon, 2 May 2022 12:22:46 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2102.outbound.protection.outlook.com [104.47.58.102])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fruj7ybbr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 02 May 2022 12:22:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dfejitcv8NHphgixZIjxv/Pi89keb7SoWGgUsWdkWcsINDpe7Bg3hBuGYQr3P1gNzteIS1WI6J8MMMzYqCzVwMUQdi29YXcD7/KgobMw1iz5XNFzqns6QxodQovnd4tCXWLFeWGcw0RYSnB/hXL87uYZtLASgrAZjbQwNsh0W14OG3f9F8qhtfK0DMEo+sU0/IRNMY2tQqLuAWewawXCgzjvlKEZZ2Zzb9LDDeW737RhjR1KNDV0yEyuYRNEec2sn+Rb8K+mdoUOzKvdtKGDpkP/aVYU1xAhZfNnh1hlDalGJkRPw0++8jzhyBZ0cZyVH1QiUEANlo6LPkBW5aeQag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lgJwMKNSOzMKmzKZ+nZOEe91eUialJDSecx3CkjSpSM=;
 b=GXiGHD8FrnKwt58sQ8jdZdsWF8NKbn5cbrTSOuravcfMaWbZ7Td+GTyQHq4eJdWA8k56xyW2bV5vNdGDqnC/xzB+zEoO+CBbmkty6ovGMtKk+4/u7BQGG9ATg1Pa4j6nqQH7fW/GhWkINgRujc1VctWGJXI2AzN2U6bKr8YLw+qoXqJQtlKeRUQsmnygR3we7DbB3s8S4hoi7BmNXoKQ5AEEpB+hYjkujSW/gYuA0srNQSlL6D+ETk9B4XHxVoXovlj3trQ09zKzitJd0cMG7zJ5xTfc+JlGdi+RmOggnCFXDvM6mrC3WX3EI4KWiVwb+mENwbRrRR2HoGjtaT4fVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lgJwMKNSOzMKmzKZ+nZOEe91eUialJDSecx3CkjSpSM=;
 b=yTUHDdxYmA38/Zp4SmR6Y5JzJX6fKKhNHgZobV/XRGnQu4VpQQPOAbtGr5L4sf6SNcDoyyrxnPOiYtMtmLeej/SW9ZtkepEe5H6NnVWRl10odWxKybXv9mF+piuiqbdoh0ZLELdz0d6TpzeaFqhJu903B6AEzTEKgh76+pfC7sc=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by MN2PR10MB3168.namprd10.prod.outlook.com (2603:10b6:208:129::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.23; Mon, 2 May
 2022 12:22:45 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d%5]) with mapi id 15.20.5206.013; Mon, 2 May 2022
 12:22:45 +0000
Message-ID: <a02047a9-42e0-91bf-4a9f-2f1d4e9ec35e@oracle.com>
Date:   Mon, 2 May 2022 13:22:36 +0100
Subject: Re: [PATCH RFC 04/19] iommu: Add an unmap API that returns dirtied
 IOPTEs
Content-Language: en-US
To:     Baolu Lu <baolu.lu@linux.intel.com>,
        iommu@lists.linux-foundation.org
Cc:     Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Eric Auger <eric.auger@redhat.com>,
        Yi Liu <yi.l.liu@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
References: <20220428210933.3583-1-joao.m.martins@oracle.com>
 <20220428210933.3583-5-joao.m.martins@oracle.com>
 <42b4cd96-dda3-9d00-a684-121129aa1af6@linux.intel.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <42b4cd96-dda3-9d00-a684-121129aa1af6@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0089.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2bc::6) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6bc207e8-0a2b-44b3-162c-08da2c367612
X-MS-TrafficTypeDiagnostic: MN2PR10MB3168:EE_
X-Microsoft-Antispam-PRVS: <MN2PR10MB3168E8C7176774425090B71FBBC19@MN2PR10MB3168.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gfchxasgU6rEVWvdB3uJ4trnufvfpZTlWNsj9vkGpV0d+vaSZDDyDicbWCp0U5pMJJC0Dg3lkccfH96K4+ury9KtskImOvREeHBUAeZhB3N1QHN+leXsFVkluyVeUJCErlOrBbjTTufEiwQNYT+lORQOqgwhBaPePNIMYj+4KmMvTunZlJmubg6qZnjfXYm6igFTiow7gIHyJtVx8Pj3sctyFLQt4FJAtQI9LY1J6j4JsH4EkFw3ZTyH/cDKwkI+GJnLlLkQgol63QK9SFvqXA7DevEdyFAWEOz6AtIQqz92Cg25B+16Nh1rFSwb1KzwyrqtRfiIuQsQ/O/HmtA8wxSVRxMxJdP3oxVxT6XpAQaMZjIjDEZxKHz23YwxTOf6xhwqiv4MVpuwMNO8aKzgaPyUPFsMVgUsHIlwYSMFRr4XGFzq/Rpi1VEUSTgB3RDJrAbe6sEJnhQFYsy1ThHxjt3Du4Nq38qK0eHrmHt6/3tSKu0U9boM7invOfkDrAV19v/ZAJxSohuU5fRNmXU99CdFkp5O1vgIB6M0SkUj4CJHwixFlJ6EHJRyzDnJGprlIqzIi0xZGzVxCGYsUMai7+7CCG2BwG7+Xtgnj73NB6hZ0c+sHDCqmLf+C0tuXXoxjuZAwfON8198hgxip/CiMX4awVp5dJY5JTCWVT5Q86V5je7nVJB9UEtwT5PtmuUlQnnoismWFrdftNxpfdZ15w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6486002)(5660300002)(7416002)(316002)(83380400001)(54906003)(4326008)(8676002)(66946007)(31696002)(66476007)(86362001)(8936002)(66556008)(38100700002)(2616005)(26005)(186003)(36756003)(2906002)(508600001)(31686004)(6666004)(53546011)(6506007)(6512007)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q25YT2hrTHJLV281bjlrRG9GYytwcE5qMndzdmhwWkQ4QzR3Q1FPSk1MMDlY?=
 =?utf-8?B?K1Riam5tRVgzM2NEWHNraFFmbnZJdlNtR1d6RFVQZXBBUU8zcXRCNUhFOWdr?=
 =?utf-8?B?WkZ4MEF6OTZQZ010cHg5SWJRa2lOaWV3QWJpb2diR1lnOFVlQ3Jldkc2eTRz?=
 =?utf-8?B?eG5yUTR2UmVsTHFMVUdUdmxwY3JNZk41aVg1VHJmQXJqcmFtQUVuWTJiS3Iw?=
 =?utf-8?B?Zm1mSkZNYXZYR0o5Z2tnOGFySGRjZmQxMjJMbWZTcFgxQ2VBYUdyVkE4cDlD?=
 =?utf-8?B?NXIxTE5ReHBvWDFMdTVhTStNUjRsaWtzSG0rcnpSUDJybENGMk1mN0FUT2Zi?=
 =?utf-8?B?VDZjS0V2Q1NIWnlOQ2lnSWdHN2J0QkxXenNiZUdsdmlvNzlPMW9FZ2J2T1Fr?=
 =?utf-8?B?OHpNQ1V1cXJGc3Z4UU5VK2owck1CL25jWmd5REtqVUlRSEpwRVQyVFlJc3Vx?=
 =?utf-8?B?a3dqNmI3c24vNHE0SGdjSVc1TjJhOUNybGlkZkN5aGR5TGNLVkx5ZGo1MXFv?=
 =?utf-8?B?Rk5YS0Q1RFJiQkQwbyttaUhFY0xpWjBaTnJlK3BOQTVtUnRwVnFaVWl1dlg1?=
 =?utf-8?B?NGJGc2hadTJXQjZrSk9LT1VnQ1h6K0dCUzMwZU8zQk1zQ0dlOE1IU2dCOFpL?=
 =?utf-8?B?V0JPZWhnb0ZoRUM1a2prOG85RU5YZFR0c08yajdxWFJYV25Ybmhnd0VRZ3JS?=
 =?utf-8?B?TGxnUlJVNFNaOVBLUCs5V2M3Z21ZTlZyYnFISVhFV1VhUVdrRHNVYysvSWt4?=
 =?utf-8?B?QVV6SWNHT1FoL1JuaWh0dzlOU0RXRWR3M29jeEUzcHZCMXNScjAvTG9zMytx?=
 =?utf-8?B?R0NUQkpINS9pb0ZYMllZNjkvWjFHRGl6eWJXbFlUbHNpeGVsWWtRNERFbCsr?=
 =?utf-8?B?amxIVi9xeWhlcVdRMlZzZlg3OEdvRHdySWs0Unk5NGdZZ2RiYmhDRDZHQUEy?=
 =?utf-8?B?Q3hJUzJISnNKaFZkOFM3U01ZOTdqSDBFKzJ6Z1hoQklhWnkyeHJzZWdCTkJV?=
 =?utf-8?B?SlptTUpqNk04R3AyaWdwSGJzVUdiUGtYNXVGWWRHeHBkekhmVlFWV0pyeDdI?=
 =?utf-8?B?MC96QmZwbkErbjlUMXZJbldKSzY1K3JNYXFhQTFuMXp4NUJMZVJrNXR0UVY5?=
 =?utf-8?B?U0dCOGpLU3VNTnhBNWt4cTdRMCtmbURYVWhiWE81N3VKd3BFOEorcWxHUm8x?=
 =?utf-8?B?YmthdnRib1FUejZoUnc1VWpwTmwzb2Nyb3hYdUxGNmlXODhzQ09oc2cxcjg0?=
 =?utf-8?B?MGJuSm5uOFJYR2ZjcTBVcHZwUnA4S1hNVHVDVldOUUNrbmo5MkVrNTRxNHhu?=
 =?utf-8?B?OVdITzk4SmQvbW43R3kweDFHaDliTzRSLzFVSXhNZzg0NVZyb043cVJrU3FQ?=
 =?utf-8?B?aGlBMW43eEVDL21UTmFzaDgyMzJpZHY3ckNJK0liOWRqOVNZcDZ6UHAzRkZS?=
 =?utf-8?B?aTI2bjJmaGdGcU9Yak9NQTFva1oyejV4MFkzejNrZ3NHN3QzRmViQWg5ZlFr?=
 =?utf-8?B?NzRpbUt4bTB2ZVNRNUVWdG12d0RMTlpLMVg4c3JqaGNyOU5hNmtFY015a2w5?=
 =?utf-8?B?akFSRzVoQXFTZTRRR1krMzFWdWQ5UjQ1bnJQMk5mOCt1dlJlaTJqUFlMNG8v?=
 =?utf-8?B?OHpPOElFZW11a3A3TWljcjE4VWFSK1IvdHB5aTFFeXVUUUJYV3EzdndoRE1t?=
 =?utf-8?B?OEZ4c2tLNjZDQm5SOHNjamF3MFM3eVM5eEZaN0lqK3duS1J6NlJ6RGc0R0w5?=
 =?utf-8?B?Mk1TYUk5Z2NGbUdJOHdXenpTZmE0VWt0TWxtd2tQRmN1MWNhclVJbmVaRzdl?=
 =?utf-8?B?WlQ4UVNtKzJaZVBnYXNEMXBkOFdtSWlGNlE5a0pRTzM5bTk1bE9SWjlaUjYv?=
 =?utf-8?B?WFE0dXFpVlZvaEpEN1ZEZ3FBbXVuMVdTRmdIL3N6TGpVSm5rc1RDTWU0cWN4?=
 =?utf-8?B?VE01TE1xNDY0RGpnREtETXArWjhrMzNCbHozZGF1VFZxMTloZ2o3K29uc3FT?=
 =?utf-8?B?dlZTcG9VU1lrZ3Q1ZG1JOHFtRkxiWHl1YTI2cGoycFAzTDBueWNkSmp3bUxk?=
 =?utf-8?B?b05tSGwvd1dvYktCZ0t5Slg1MWI2RnJiNjQ2ZDFMdGxJSUZ3aHpNRlhtR1pk?=
 =?utf-8?B?eE1nNXhZeWdEZkIrMzJtUUt1aHlKS3VuTUFWMzVZVmFaWFVqQzlvZFNKSW9j?=
 =?utf-8?B?cEppc2FKSmtTdzkyajRwS1BlcjZkdGNkckFiNzRLNWdyRjIwL3dFZm11cGNo?=
 =?utf-8?B?RjAyUVRRZXpIcGFZWDFubDlXQUZNeEpvQk5mUVZwTXNESzV4a2Z2bzQ4dG1m?=
 =?utf-8?B?c1ZzTlExN3F6U1lyL01zZWFaM3ZDby9Yb0lsbWl0T1ZTamFKWjBzTU10QWlu?=
 =?utf-8?Q?DEXRXkh7eNxUrmiA=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6bc207e8-0a2b-44b3-162c-08da2c367612
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2022 12:22:44.9442
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ucYRr9pvk3QIVeq4byEtW4l5MkxyLTTbeHx4bSGp0DtJV6GWAYy1d4p0p91YBv9aguny/pRL5CBvOth0/q4TTktx/BjGgaR5uqY/HYlvMEc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3168
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-02_04:2022-05-02,2022-05-02 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 mlxlogscore=999 mlxscore=0 spamscore=0 suspectscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205020097
X-Proofpoint-ORIG-GUID: QQGo0cUDKLsS349b9izZ0PaQa8_RrjXA
X-Proofpoint-GUID: QQGo0cUDKLsS349b9izZ0PaQa8_RrjXA
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/30/22 06:12, Baolu Lu wrote:
> On 2022/4/29 05:09, Joao Martins wrote:
>> Today, the dirty state is lost and the page wouldn't be migrated to
>> destination potentially leading the guest into error.
>>
>> Add an unmap API that reads the dirty bit and sets it in the
>> user passed bitmap. This unmap iommu API tackles a potentially
>> racy update to the dirty bit *when* doing DMA on a iova that is
>> being unmapped at the same time.
>>
>> The new unmap_read_dirty/unmap_pages_read_dirty does not replace
>> the unmap pages, but rather only when explicit called with an dirty
>> bitmap data passed in.
>>
>> It could be said that the guest is buggy and rather than a special unmap
>> path tackling the theoretical race ... it would suffice fetching the
>> dirty bits (with GET_DIRTY_IOVA), and then unmap the IOVA.
> 
> I am not sure whether this API could solve the race.
> 

Yeah, it doesn't fully solve the race as DMA can still potentially
occuring until the IOMMU needs to rewalk page tables (i.e. after IOTLB flush).


> size_t iommu_unmap(struct iommu_domain *domain,
>                     unsigned long iova, size_t size)
> {
>          struct iommu_iotlb_gather iotlb_gather;
>          size_t ret;
> 
>          iommu_iotlb_gather_init(&iotlb_gather);
>          ret = __iommu_unmap(domain, iova, size, &iotlb_gather);
>          iommu_iotlb_sync(domain, &iotlb_gather);
> 
>          return ret;
> }
> 
> The PTEs are cleared before iotlb invalidation. What if a DMA write
> happens after PTE clearing and before the iotlb invalidation with the
> PTE happening to be cached?


Yeap. Jason/Robin also reiterated similarly.

To fully handle this we need to force the PTEs readonly, and check the dirty bit
after. So perhaps if we wanna go to the extent of fully stopping DMA -- which none
of unmap APIs ever guarantee -- we need more of an write-protects API that optionally
fetches the dirties. And then the unmap remains as is (prior to this series).

Now whether this race is worth solving isn't clear (bearing that solving the race will add
a lot of overhead), and git/mailing list archeology doesn't respond to that either if this
was ever useful in pratice :(

	Joao
