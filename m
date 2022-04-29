Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D826A514D2D
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 16:34:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377473AbiD2OhB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Apr 2022 10:37:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377478AbiD2Og7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Apr 2022 10:36:59 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D97DAAB5E
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 07:33:39 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23TEMnga015535;
        Fri, 29 Apr 2022 14:33:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=DxFcE6I5X9UHpGZWyJS9ThbKMNXpM03PZ5WJlADtCHg=;
 b=lt0yKApZ+g3Z3UW1w3kZb1ZasTTxk6m/YnnCoslvX6v3hRVRVgWDd/DVgfOHI0HJDx0h
 SRidrRF0Z09CYSKovjyl0DVzd6VhFWdQUoDQn+Gt0yDQm517NAkP8On4Tw17lVBc4/5O
 Cphb0HIc4hdU6cA6gAHLuv1V07YSAs+h9/tb83PZa244DWAZNdLrVylgBX7tlXJBrqIP
 xvGASAZXeaPoWVGSKXg2BQLDCuFbrXwQInn6Zfb836ZrcqgHu8QNrOGTb6UwkYfVdf7S
 JNGvUYYHh2tQufUevI+R8eoe2GCoEYNl0W2uS4V+trUYs9qmSVumevavYHw+400rBV+k FA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fmb9axvhg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Apr 2022 14:33:14 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23TEGHpT008713;
        Fri, 29 Apr 2022 14:33:12 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fm7w8304v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Apr 2022 14:33:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iRmEI6uq9uZPxduEcxpDearcpxtvPJOY1tBd4uU3gnz37NKYInVslmzRFrUGd+k567wX+r+1dpRu7+/VXz9vo402Y2R+alBTz8HnKAcAYUDvoxD4DAJzuuK3Tqj/BHsYyRQypJT/U0Ko2Iuko3ZvyPpUlkOXZh8b6XGNKIrSyROK0/9uUxD/19+25cx4PDHopeQExg/j3baqYi8ViomrHT44rCtZnfWkZoOJE8y5UQx6IhggVRpxCi7IJ2fo4HqbxmRh6bTZ0rNRNDmlJeZMHjozMFOj5IigyBSMneFQijpOQEcA0Whlw19I06w7vIPrtknMIFJo6vuU9JiamZurTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DxFcE6I5X9UHpGZWyJS9ThbKMNXpM03PZ5WJlADtCHg=;
 b=kd/dn79XJK3TRDRlg1MOnFYMxZGCicp8uXEsLZ8Cyab5FEe6A7ddzh18FV6ilkfPTknHiTXBD9F5CjVhiyAUrWp8Y075jpNC+mQFzCV55xaVeYkpSe5x50w4gKiXOD/Pvf7WNxY5M51sbJ5KqGmg4Jae6aUhqJ6akF2TUqtmLoTFpYLCcfw60HRADxcQN3yxngX86HrowexO4mQUAHJqFlgKSGh9U5rh1b6DKZDR7Kcor1VQnmM86fWRED6B2aoCkrgSxPRo9OHxvJjuRVJ7k0UZF+ftXv8Mix+Ioa53liPTrFZW8Iy82Zkqie/HxIISdRiR4X4Mi+y3v1jy1tgdDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DxFcE6I5X9UHpGZWyJS9ThbKMNXpM03PZ5WJlADtCHg=;
 b=eX1Gi4KPI1wA9xdsom+jNy6UPWNr2ITuoT0OHBnwfIxZQgJL3Ulnqv7U9a6QgmKCDbaPiFI5tiGrAuJw3DIr4WmzVAwtSNklumvXBCQBkmPTElXWBLLay4vwsm0lCL+H3Bg37Vu2Sfq/VvPKlIzjXpiocaLHsR2FiWPAejzQO/0=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by CO1PR10MB4546.namprd10.prod.outlook.com (2603:10b6:303:6e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Fri, 29 Apr
 2022 14:33:10 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d%5]) with mapi id 15.20.5206.013; Fri, 29 Apr 2022
 14:33:10 +0000
Message-ID: <c1994155-3fef-19e3-1309-8efaf01d943a@oracle.com>
Date:   Fri, 29 Apr 2022 15:33:02 +0100
Subject: Re: [PATCH RFC 03/19] iommufd: Dirty tracking data support
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
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
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>
References: <20220428210933.3583-1-joao.m.martins@oracle.com>
 <20220428210933.3583-4-joao.m.martins@oracle.com>
 <BN9PR11MB5276C829C3F744BD4F4932B78CFC9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ef762630-c466-af13-c8a3-da3f360b334b@oracle.com>
 <20220429120933.GR8364@nvidia.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <20220429120933.GR8364@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0157.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:188::18) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bd68534a-bda3-4fb4-b490-08da29ed2eb9
X-MS-TrafficTypeDiagnostic: CO1PR10MB4546:EE_
X-Microsoft-Antispam-PRVS: <CO1PR10MB4546F2160E84224B9DDD847ABBFC9@CO1PR10MB4546.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uNJns1Re68dyPDiBangqh4LdpWW/O9g/UqjpsqVA8pBMH8+Fmm4dEBrMzxSMmU8q5+rsiIbwM3uFnDVmBTVu4GTFmcAllFvT2XKaWxrAErsYFOff8kETfetANRe+hf9zyoSXLYbZWzpCDVXiS4HoERZEGqs6BSdDeSLUv6AQuQpf4AtsHEoP5kv4y8stgWJFLlx5qSTlQXcOQLBQlgCgADVuF+5Wfa++CNnp1xMSgEjv4MICJD00XHDSAEijEtwCmppuAavg/h1px3+HH6llGfhLEbSMCw6O5jQZJW1ME9Cv46wrDQtEAHTeA0BRUXyazFOJofzL19y5D/icDMnuYo8Z5gInSQF9fjBkIRxlnBaXuaniKoumYAPKqbq7361ofAIt9O/GyGtbZOtArJGs4uQfACqDvHznJTFF2eZclWX9yrtCvsMYz1ld4mOhRO2RrxZwWwyOiAJYywAAdCpPVDQzFi89EVMBR4cZMcx7o9nvS7mHhryk6AuecipV8zx3gtf/fCy93YPJN3DXFmPgzCnyDcb6p4QPNorzr+DrIlR60h34dEtnoNV2YrBr3fChdcWEqTPZ4EU3tx29JqrtrXQ9aEmyTpyt3UzTBQVK6nzDt0u0YcVuFj6MDj/aunKQ5vZYIhXIqTea6cWDrzEsWT1zMrGvub1GfsjwK61c+83CoPVYU+QEJNU/zVWvxe+tSvZuc873QYJh/cLbw4CjRWXo0m3ezaz77LInbDJPYVfS3tON6y4f+tjF/5g0FUtF
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(4326008)(8936002)(8676002)(66476007)(66556008)(6506007)(53546011)(66946007)(54906003)(26005)(6512007)(2616005)(508600001)(6666004)(6486002)(6916009)(186003)(38100700002)(36756003)(86362001)(31696002)(316002)(2906002)(7416002)(31686004)(5660300002)(21314003)(14143004)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SVdUVTBFdW9hQ0Y3WWNqUVA2VzRaYnpQV09UZ09TSGplUHVjZENLNnd1U2FP?=
 =?utf-8?B?a2R4THhtMXpTSjJVOHhGV2NRY0xFYmMwMzJxRDRqcTh0RVl1cTNrVHNPUUt6?=
 =?utf-8?B?eWxUUDMvc2xOb1IzNUVHdWZWbmoyNk9qbTdhOHV5bWJCaEhlM2hoanNWYUNV?=
 =?utf-8?B?d01HYWhyTUhYL1JKZ2pnc0FlaUk1ZEtXcVpPQ0dyMHpUL3hiRVBBdGFFeDI5?=
 =?utf-8?B?WjlsUTRUUFRSUXF0Y0lsMElPbVpjNDdXWUJDcEpUVTdzeWV6NUZDM0R2UDBV?=
 =?utf-8?B?am9LNW5vSjZOYWNLWTJESzBxNEdxVkhRVlUzcEdxaUgwSmNXSFNISTNEZCtU?=
 =?utf-8?B?aXBTR1o2bVMycXpjbXZCbXVBUnV1c0JTVlNjbnZYTnB6dXl5ZXlzVlJaeVNJ?=
 =?utf-8?B?RWVOalBUaXI2OG5xMEFIRGcyOVRtTTRMSlZoYWJQUkZqTzhuSTRuUTdEWGFr?=
 =?utf-8?B?Q0ZGV2JvZTZobWEyUUVBVnhFd1Q5MVBQRE00a2cwWENqcE9IODFMRFpnUDl0?=
 =?utf-8?B?cnoveW5NVEpaWVQ5Q3ExczFSMUdGR0lHN0oybTBuV1Z1MjRRaldIcWpkOGxR?=
 =?utf-8?B?SmZzZU1NazZPVVQ5QldRc0pPUEJMcmQ1cy81Wm40a1ZWQUlwS1czNXlGdHow?=
 =?utf-8?B?d3BTSXdTVGE5S2tXYThMRVlyaDNJblltZjM3elZBcnZsOGcxWEJOWXZQQWJY?=
 =?utf-8?B?c09kZTNjbWlwSk9jZ2Nnbzl0d2hwNXl1T3ZLV3JCUERpQjkzYTV0Y0s2eUxB?=
 =?utf-8?B?a01pVEFhZGVzd3UwcXkzdXkwVzdwZVczWmVQQm1PSnFwZ251QndzaTYrTmY0?=
 =?utf-8?B?c1dYNVdLQjFEWWtuTWRScHVOV1JmdUMrUTQ4bjRxQTZGQVhIeGVUdGpaNnQr?=
 =?utf-8?B?TWZiTG8yRERlNnNybVV6Sy94dWpidGhuUW40Mit6OUVZWmJEeUZMdTVJdklu?=
 =?utf-8?B?TmN4bW1KWTdkcC9IVEpPcUJaZ09SK0lSU09FeUtnM1dNaWdzWndIckthL1Nk?=
 =?utf-8?B?TnVqekxVcDQxdGlyVURadmo1Y0NJSEppeDR3MTZxT3ZLU0JzNkljR0NZZ3Fl?=
 =?utf-8?B?YS9NOHI0QjZUYjV6Z3laL2xjY0NoL2JEZTh0eWlNTk1yR3dQMXpUSUJjY1dQ?=
 =?utf-8?B?WUY4ajhWNzNDNFN1Mkp5eXhpbEUvMDZvWm1qRFZ1cnlpZXM4VnVFeFU5a01j?=
 =?utf-8?B?SHFocXZHZGgvWS9Gdm9aRi9xeG1xMmVTZWRud0oxOWJFblBFVEJYQWxUUEpO?=
 =?utf-8?B?dUt0WXhNLzNKdDJETVUxQ0xvbjNhSWc4aU5SQmtGRi9QMUFUWmg2VW5qZXR6?=
 =?utf-8?B?WjRqanlRZERDbDZuOWRnclY3dEdxV0s2YjFMQnB2Q2JnWDhnUzBMK3Vzc2Y5?=
 =?utf-8?B?NnJBMEtvZFZhNEl6SmdwOGJ4blVjRUhoTUVFQTdnSDFxdng0RFZ5cjJkVzh2?=
 =?utf-8?B?enVVdTJmQ3B0QUFiL2R0Sm8wV0FEOC9kNlhMU3dIeGcyaXFtR25jdGZiVDdv?=
 =?utf-8?B?dzZZSm1CVWlIbzIreS90MUlYZm02ZnhVbm93M0tnRnpQOVlqQ1UrMk1oTkNJ?=
 =?utf-8?B?S3pHVXg1MExSemkrMm1xTmsvSENsZi91TE8wbFFCRjBJc2dpNlo1ZU5MdkF6?=
 =?utf-8?B?YkdvUWpuQ0JFUEp0bDN2TWZvNjFMaFZBZVZiWHVlc3JlRHhYclRoL0trWDgv?=
 =?utf-8?B?Q3p4alNaZndMa2I0bEtDbHpzYXNaaitPdEphcFBHZlQ1elZhdkNRWjBKdWtu?=
 =?utf-8?B?Uy8wVEdLWXVtc1VFTjlyT1BlbDBVbWphNDJBc01EKzV3eVY4TkdkWHVZL3NL?=
 =?utf-8?B?dXc4d1B2d2dmY0tXWkJKV2hpQzVIRjF6TEhNbTlIMGY1dTB0bGQrNlRKbXFo?=
 =?utf-8?B?Y3JObEptNmNEaE9adjNuRVJ3M2xsS0NQVkh6cWo1ZGN2eXZuanNwb0J0c2V3?=
 =?utf-8?B?eUUwb3VpK2xqb210b2M1S2hBSHVLTTZTL1NzaDFvTXN4R0srZmEwN1dxL0li?=
 =?utf-8?B?MmZGRHh2RU9QazdOQ2hIaXoyeis5dVh4L0NFdWpCUHlJcXVzaldQeStTNG9N?=
 =?utf-8?B?aVhUcGFwYkljY1F0SUp4TWxxeTJBTWNJd2J6ckFFQVdvUUtLNzdObmVHR2Mx?=
 =?utf-8?B?RHBuVTVrTjJrd1RaS1ZzNGIwTGx5U2x6M2NRV1JCY3NwYnhLNzNXS1VZbTQ5?=
 =?utf-8?B?K0JzMDRLaE9vY25lalAvU3lZRk9tTkN1SlZrQjZMWWI0UVZSKzhjUnlYUWZj?=
 =?utf-8?B?S005MWlsdVNuVUNUNkRiRUVraHlqcjZuM2JkNUxHb1NLWEFzckRkTythdTBh?=
 =?utf-8?B?emdnVEZKanU1UHlQYnhPRmxOV25sS09La0phRzlUZEhROGl3V3lvbnZJODcz?=
 =?utf-8?Q?U+XNYDdpRwk9W57U=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd68534a-bda3-4fb4-b490-08da29ed2eb9
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2022 14:33:10.0796
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uug7BPn4y1B2f2Krg+4mt4X2E/3eAR7oze5YT1OtTsG8sjNXJyeBWnNzSAgCaoPgEmuqFlOUHiGdhKmzMTWCBUZT6fy6iyzxKtdB5CXSIMg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4546
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-29_05:2022-04-28,2022-04-29 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=882
 malwarescore=0 mlxscore=0 phishscore=0 bulkscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204290080
X-Proofpoint-ORIG-GUID: Hfd3FdFjTr67m77esA0aTiL7JvEvftAM
X-Proofpoint-GUID: Hfd3FdFjTr67m77esA0aTiL7JvEvftAM
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/29/22 13:09, Jason Gunthorpe wrote:
> On Fri, Apr 29, 2022 at 11:54:16AM +0100, Joao Martins wrote:
>> On 4/29/22 09:12, Tian, Kevin wrote:
>>>> From: Joao Martins <joao.m.martins@oracle.com>
>>>> Sent: Friday, April 29, 2022 5:09 AM
>>> [...]
>>>> +
>>>> +static int iommu_read_and_clear_dirty(struct iommu_domain *domain,
>>>> +				      struct iommufd_dirty_data *bitmap)
>>>
>>> In a glance this function and all previous helpers doesn't rely on any
>>> iommufd objects except that the new structures are named as
>>> iommufd_xxx. 
>>>
>>> I wonder whether moving all of them to the iommu layer would make
>>> more sense here.
>>>
>> I suppose, instinctively, I was trying to make this tie to iommufd only,
>> to avoid getting it called in cases we don't except when made as a generic
>> exported kernel facility.
>>
>> (note: iommufd can be built as a module).
> 
> Yeah, I think that is a reasonable reason to put iommufd only stuff in
> iommufd.ko rather than bloat the static kernel.
> 
> You could put it in a new .c file though so there is some logical
> modularity?

I can do that (iommu.c / dirty.c if no better idea comes to mind,
suggestions welcome :)).

Although I should said that there's some dependency on iopt structures and
what not so I have to see if this is a change for the better. I'll respond
here should it be dubious.
