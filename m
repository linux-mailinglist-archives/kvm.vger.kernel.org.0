Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD0705722BD
	for <lists+kvm@lfdr.de>; Tue, 12 Jul 2022 20:35:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233010AbiGLSfv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jul 2022 14:35:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230166AbiGLSfs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jul 2022 14:35:48 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E475CBDBBD
        for <kvm@vger.kernel.org>; Tue, 12 Jul 2022 11:35:46 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26CIEKK9013674;
        Tue, 12 Jul 2022 18:35:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=tg1jYavU1s+alxVeEXTMwVkF9x3u/R1wbhei2BpaoOA=;
 b=x+FeItB2yINkfupyFx61YZ2eMFmmxwMsqsqOxx/AmVWS2OWOfRM/HqzgZVBP7wVFjpFo
 QJu5Xrcxwrcet9f6hTg/PdNYCDJTsJ6NX7XigZxKh/uhHxBH/pl7jpm6U3EPquHfqQRX
 ZBQI66nBas7f3LX9EEU3/8gAo2DnPEPKydf3PI1zUCUgkEHRx55//ZCulfc7O2TOid2C
 2pazohYL+e1UYOzgeeNYP/TIY8OAdd6CNOVg89qXrWFFT4TIzKDQMsj3+gyFEZXmKdSg
 UCcsIqidVTbyxdLeWBM8Md5OH0ilO5WYxzwdfdm5oiuUThSBETPqb1gZBzoEeYFyH3+4 2w== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3h71r17rdu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Jul 2022 18:35:00 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 26CIFZJx034468;
        Tue, 12 Jul 2022 18:34:59 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2040.outbound.protection.outlook.com [104.47.74.40])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3h70444gkv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Jul 2022 18:34:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jMTSrRUJqsh3Irga+IxYIaIAR5qffJCpV2TzGBo84zd6ENsH4xPqBx598VgJSweDTQyJSxS5UwcFyUvRGBo2wnPioR6Zb8SCJuE4jIYv+Ij84SjyNmdrfava2Lk1hTN06HlVVeoZInIZXCmMk5BNJ2OD81TXmE5GAB748HSZ2Vf1MDQqXjMjTtS5l87+gbqhRowrUPT5YPLu/6hRqH0s81NylSuXCqPOjBuP/TYKS1iKoTrqSEKyvqIMGQNvMEl7mL4enZ8rftBH+NY0t0pDdCCFQfdDoJOYLkqwY/eeISsy/0lg1T5BkNdEUHYx/aRiOPA5fBnBTJlxA48yUz6xMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tg1jYavU1s+alxVeEXTMwVkF9x3u/R1wbhei2BpaoOA=;
 b=AY2mQwwcTQhxZJNRoxh0y0t6MqKI7rkEs8/SSAHofbRgX2q5cfDSWnwKT8EwkX0lZWArDSYnuMMXL6N+jZan6wO+h3HESnC8+2bVWmQM595Ak2KgyFa69PCcYLUdaBhIVhGMm256yS9/PnH1JBuRK3JfLWBPHxSRhwsRYD7PIVl70AH5ht/stQ7sQODob2H33X69imLkgpu5II9Uz5DlDOQjldCDcmCq/ZDMmeopN7K2oiS8lz+ncqGq42JV8InCUuV+s4/Ns/7naR/UwnLV6gAkRUHUHTFnDnNwnhgoohdA9TE4BjYHjjsQPuc9k6/IIcclL75+/E0zFq3PJRNyNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tg1jYavU1s+alxVeEXTMwVkF9x3u/R1wbhei2BpaoOA=;
 b=nxOD+pLco6F2MybmpRKC7jTBqK7aLlnyanUIZ01ilU0b8npO33/CjxCB0PlZbGnjbC/pnXJnnzlzYvVr+saCQxu4UP+Cybjann3EZzsM+jJK6vOSHhJQgTnOKSdaKW/RtOhMIP2Hwmg9k2DdK5wKEzCq58idKj80g9p0/m6J85k=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by PH0PR10MB5530.namprd10.prod.outlook.com (2603:10b6:510:10c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.16; Tue, 12 Jul
 2022 18:34:56 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b842:a301:806d:231e]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b842:a301:806d:231e%9]) with mapi id 15.20.5417.026; Tue, 12 Jul 2022
 18:34:56 +0000
Message-ID: <b97658a2-2eb4-11d4-d957-e7d9d9eeb85b@oracle.com>
Date:   Tue, 12 Jul 2022 19:34:48 +0100
Subject: Re: [PATCH RFC 00/19] IOMMUFD Dirty Tracking
Content-Language: en-US
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>
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
        Nicolin Chen <nicolinc@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>
References: <20220428210933.3583-1-joao.m.martins@oracle.com>
 <BN9PR11MB5276F104A27ACD5F20BABC7F8CFC9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <f5d1a20c-df6e-36b9-c336-dc0d06af67f3@oracle.com>
 <20220429123841.GV8364@nvidia.com>
 <BN9PR11MB5276DFBF612789265199200C8CC29@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220505140736.GQ49344@nvidia.com>
 <BN9PR11MB5276EACB65E108ECD4E206A38CC59@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220506114608.GZ49344@nvidia.com>
 <BN9PR11MB5276AE3C44453F889B100D448CC99@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220510134650.GB49344@nvidia.com>
 <BN9PR11MB527693A1F23B46FA9A26692A8CC89@BN9PR11MB5276.namprd11.prod.outlook.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <BN9PR11MB527693A1F23B46FA9A26692A8CC89@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0637.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:296::14) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 28be94ed-f985-49d4-bfff-08da64353827
X-MS-TrafficTypeDiagnostic: PH0PR10MB5530:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nbxi0MVi+PBu8DzM5nseSu39TXeM2PnVkzG3csdE5WBPPwb3QdGxGPrnAEInkfgpXd2VvBhnQR4RawyBHPhhN9juEecjvI/2aESlFvZvRueUmVpe3wQcaLJweZNiuXM9TP1TwGYHU8x65zsfZKTpkuF2R9Sj+ViAi09PdouJGZ23rTkCDuIyorA5DYf3YjSND4TOOy2ALdNyF9uUj1V3uN2b+8iXYi/PHVOc+4ZyAWPQ1f5WfzE56Ww8BKH1JnpCkdiZ1pMS2vJPmHJ12GwY5MzLfyrI19rUL+FlYjUPDL9ZTiG0uGpJu+3HM4KfQSTglljev8+vf5Nrlye0TqnpLgVYHSrPe/zYdg3dxXY2UepuhID3mKYJ4OWlRJg6+qCuIRwoYy41V11Xjy0yHvnPyuBufPtRyUp03KBrR6Zu/U4hKduaM6IpsPFdbXd0bwF++/OhRyic5xr6dj9BCfojbe2DBz0VQjtu60Co5/em843ElWxJtGyk6XDPqHoOIfIEyC5CXR96egGbEvbTYa//F6YFhSn7riLMBtqbtB1zsCLQvzh2+ieejdMzO9N9BXLq3fD50fFfyMOS37kKePTnhOQ62/WpiikuGj4GGLAZJGCAguHy4Z0lc3hhMzqyOE+HnVx8tRsw9Wb0i/W34mXN2u7jqVekxQ4YeV6H1lGjtbWbWIgif79SWLf3ITnhwtfoq1lRwsHanAFIbO8/VsyaGdtZ2j7qE3Opm2w/IVy7qoRfNAEsXKBjkMXpfzrK1sEV6ocgXVv+X7TOcWcQv09kxIPu+N/vN8tchGcXnKHawxdQpubOANyzg44knRpLf59sXjNPzIM6L3pLTVmE6M6I0g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(136003)(396003)(39860400002)(366004)(346002)(478600001)(6512007)(6666004)(36756003)(41300700001)(2906002)(26005)(6486002)(53546011)(110136005)(54906003)(316002)(31686004)(86362001)(6506007)(38100700002)(2616005)(66556008)(66946007)(31696002)(8676002)(186003)(8936002)(5660300002)(4326008)(83380400001)(66476007)(7416002)(14143004)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?REhQM2JIdVhSYTZ5UldMTzR0Sm5vakdHV2grcWRnNUduMVg2dExzOUJ1dXJQ?=
 =?utf-8?B?VklwdHFRYngrK2x0QUFDdWRkajd4YjZmN3BnSnN2cXNrMDU3MHhnZDVodklK?=
 =?utf-8?B?TXVqVFhjMDJvc0tPd2dsNGZYMUhnU2ZYQWJPUnpBNU1ET0dhZ3Fhck1SWmd1?=
 =?utf-8?B?NGVnWFF1bTZOaUVXZ0tjdXZhVkY2QVowNGp2T3BablErZ0pLL2RyR3NmZS9Y?=
 =?utf-8?B?NW55bFpqMHU3RWhkVEMvOUhMaWZRSHBOeGdUWHM1akZFMmNoT0dXQjVDYzJR?=
 =?utf-8?B?OHRQd05vdEY3RklmdHFpWTRuWkloTVdTZjJNUVhzNnhDSWo4L2FmU1JacGZ6?=
 =?utf-8?B?bUE0djA0WXlEWUlqQTlGbVVIcW1GUUhXdlY1M2p2dFBrVWFKYVFKT0RNbXJq?=
 =?utf-8?B?bHgxTjE0OXhMSklYOS96b0FhV044S3ovTTE2U3BtM2dwR3YwMDc5YTJ2dkln?=
 =?utf-8?B?Zzkwb0k1SGtEdU9jRWpCRDZJZ2dwci9jb0dRcjRrRHphWFNPRVJUNlFlS2Fl?=
 =?utf-8?B?OHMzYU1oNGozWFBTS2pCeGhxNERscHVUaWxtU0Jqb0IvR0hmUG5EZG9lWFBW?=
 =?utf-8?B?TG43RmlpVGx6SGZYdEN0dEVocFlpYWtzSzNRbmphNkpvNjB1UjdUMXZwVUNy?=
 =?utf-8?B?bWpYdytobm9KQ282eHNmYnN1L2cwSkhxM3pxNEF3S1o4OFplb1RJalJvZFov?=
 =?utf-8?B?OEU3VlRFSkJZWnpzQ0EyaURQUDRSczFhNjVobGxJRHMzWlFNbGJJeVhheVBz?=
 =?utf-8?B?STVsc212ZVVJUlM0Nkx0NUd1Z2VxNkx4cjB6ellZaTZCL2VlOFlNUUpkaXhz?=
 =?utf-8?B?OEtDemR1STJhQ1pUYitveU5UdGFTNk9ReWNNT2V0VHdkbWpOT0JXeW5HTUxD?=
 =?utf-8?B?MTRxb2RFU0ZWYUErWWprc1Q5NkE1SHVKeFdqdFhWYXFSUitsdWo4Wng0d2FE?=
 =?utf-8?B?RXplT2ZLR0hjQngwUWFDb09VUVJFSWxBa1VmSTZXQ215Tkh0dG53VFlhaVNn?=
 =?utf-8?B?cXhVa0M4SlRXNXNXMzhMU0d1QzZQTFlZcFBXbzQxVFFaVEY5RG9EQURUcFJi?=
 =?utf-8?B?NkRzQkhaT3pULzU3T0JpMzJSNHZwSHVHZ0c0eHp5RGVsMHhPSExBMXFvVWgv?=
 =?utf-8?B?dXNjNWJ3WTViaHdVdFlKMVlXSXJ4TDliVXpaSCszSk9Na3RKd29XWlZIaW1v?=
 =?utf-8?B?Q1RPVjZsL2V3VzlHUlowQWZuc2VYOEMwaUVVNGc0ZGpyQjFzR013NnlZT2Rv?=
 =?utf-8?B?N0pnTUY1V2xTZ1VmQ29Ha1YrdE1uOGt6UHFBRmZzb0RrV0NVdHBlQ0FETkE0?=
 =?utf-8?B?cTIzZG5vUy9EWnBhUjlFKzl2TUdvS1cxT2dnZEx0Mkx0UGFZQXZ3V25VZWRO?=
 =?utf-8?B?blN5bUVVZHMrRWVtQnFSR2RRd1dyZXREaVRXV0x0cXZCemV2RDZtaUkxZEk0?=
 =?utf-8?B?ZDUzZjRrVWtQZXhac3BMUHZjdkNvOFFOVmpEeStMZDN0d29vQWtodmFTZGRX?=
 =?utf-8?B?eTlwOEpmZjJjS01Jb1N6c2NxcWN1Z0hFcGh6VFJXZmRQRnRIeXV3eHJTNG1x?=
 =?utf-8?B?bHRyVlpHWmZpY1hGWHR0N2FicmdmRXlYbURqZnZ0M0c1ejZpbmJCWk5SVmNW?=
 =?utf-8?B?NkdYcnBnUGZYb3dielJ3MTlLZ1JjMlNrd085dzY1TENsNS9qODgreFBWTHZX?=
 =?utf-8?B?QWVQWjQ2bEIwQlgzUnMzRDcwTHdQa3R3QTdUZklyc24wUTZLV25SSGJZNWRI?=
 =?utf-8?B?L3JnNXlROC9CSkEyZkdtUFVaekZqYUJ4TlJMNmlKQzVlK3YwK3Z4aG1xTDI3?=
 =?utf-8?B?MlVOc2JWRDBLS1grYUd3Uit6MWFuU0F0VlUzcXdpMVNCaGYxcmlGMUVvMm54?=
 =?utf-8?B?ZFNHKzBmUFkvK3VjblZrMEQ4TFhXUnR5ZjZRUi9ESWc2Tk5vNi9TRnl2amJ1?=
 =?utf-8?B?dGdZTWQvTlVOeTZ6R2NjSzliUG0wN3JWRzNwSXk1UXM3MEh3Si9hbFpmUERT?=
 =?utf-8?B?SDYydXdKRlpzQ1RyL0ZBTjdMUWorNzZsWnJWbEdXdjdSWitlWHNKSTlIRktP?=
 =?utf-8?B?OXl1VFNvU2x4Y2V6NWRNSkNNQUU2d2pIejQxNGhJVXl6c2NkcjF3SW4vQ2lm?=
 =?utf-8?B?RzVHdzhGeStwbjBuZzRWRG9CTFFWRFFnSTdGbEFaZ3R5WHVLckJyeTVSR2Zo?=
 =?utf-8?B?bEE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28be94ed-f985-49d4-bfff-08da64353827
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2022 18:34:56.6550
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lDjQrdovQh4tgJECh4CTZwegQpraBwyQiy5hXVtUAiCc+adyxobdUHtV6w0Gd9CQDW1YGejDqWQSLkOkGbeNz70i0d/xS3KysFNHAiO4anY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5530
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-07-12_12:2022-07-12,2022-07-12 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 spamscore=0
 adultscore=0 suspectscore=0 bulkscore=0 mlxlogscore=939 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207120074
X-Proofpoint-ORIG-GUID: -BJJ9mB6mjyevMGJ4HxPS6BmOefl4JGb
X-Proofpoint-GUID: -BJJ9mB6mjyevMGJ4HxPS6BmOefl4JGb
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/11/22 02:10, Tian, Kevin wrote:
>> From: Jason Gunthorpe <jgg@nvidia.com>
>> Sent: Tuesday, May 10, 2022 9:47 PM
>>
>> On Tue, May 10, 2022 at 01:38:26AM +0000, Tian, Kevin wrote:
>>
>>>> However, tt costs nothing to have dirty tracking as long as all iommus
>>>> support it in the system - which seems to be the normal case today.
>>>>
>>>> We should just always turn it on at this point.
>>>
>>> Then still need a way to report " all iommus support it in the system"
>>> to userspace since many old systems don't support it at all.
>>
>> Userspace can query the iommu_domain directly, or 'try and fail' to
>> turn on tracking.
>>
>> A device capability flag is useless without a control knob to request
>> a domain is created with tracking, and we don't have that, or a reason
>> to add that.
>>
> 
> I'm getting confused on your last comment. A capability flag has to
> accompany with a control knob which iiuc is what you advocated
> in earlier discussion i.e. specifying the tracking property when creating
> the domain. In this case the flag assists the userspace in deciding
> whether to set the property.
> 
> Not sure whether we argued pass each other but here is another attempt.
> 
> In general I saw three options here:
> 
> a) 'try and fail' when creating the domain. It succeeds only when
> all iommus support tracking;
> 
> b) capability reported on iommu domain. The capability is reported true
> only when all iommus support tracking. This allows domain property
> to be set after domain is created. But there is no much gain of doing
> so when comparing to a).
> 
> c) capability reported on device. future compatible for heterogenous
> platform. domain property is specified at domain creation and domains
> can have different properties based on tracking capability of attached
> devices.
> 
> I'm inclined to c) as it is more aligned to Robin's cleanup effort on
> iommu_capable() and iommu_present() in the iommu layer which
> moves away from global manner to per-device style. Along with 
> that direction I guess we want to discourage adding more APIs
> assuming 'all iommus supporting certain capability' thing?
> 

Not sure where we are left off on this one, so hopefully just for my own
clarification on what we see is the path forward.

I have a tiny inclination towards option b) because VMMs with IOMMU
dirty tracking only care about what an IOMMU domain (its set of devices) can do.
Like migration shouldn't even be attempted if one of the devices in the IOMMU
domain don't support it. Albeit, it seems we will need something like c) for
other usecases that depend on the PCIe endpoint support (like PRS)

a) is what we have in the RFC and has the same context as b) with b) having
an explicit query support API rather than implicit failure if one of the
devices in the iommu_domain doesn't support it.

Here's an interface sketch for b) and c).

Kevin seems to be inclined into c); how about you Jason?

For b):

+
+/**
+ * enum iommufd_dirty_status_flags - Flags for dirty tracking status
+ */
+enum iommufd_dirty_status_flags {
+       IOMMU_DIRTY_TRACKING_DISABLED = 0,
+       IOMMU_DIRTY_TRACKING_ENABLED = 1 << 0,
+       IOMMU_DIRTY_TRACKING_SUPPORTED = 1 << 1,
+       IOMMU_DIRTY_TRACKING_UNSUPPORTED = 1 << 2,
+};
+
+/**
+ * struct iommu_hwpt_get_dirty - ioctl(IOMMU_HWPT_GET_DIRTY)
+ * @size: sizeof(struct iommu_hwptgset_dirty)
+ * @hwpt_id: HW pagetable ID that represents the IOMMU domain.
+ * @out_status: status of dirty tracking support (see iommu_dirty_status_flags)
+ *
+ * Get dirty tracking status on an HW pagetable.
+ */
+struct iommu_hwpt_get_dirty {
+       __u32 size;
+       __u32 hwpt_id;
+       __u16 out_status;
+       __u16 __reserved;
+};
+#define IOMMU_HWPT_GET_DIRTY _IO(IOMMUFD_TYPE, IOMMUFD_CMD_HWPT_GET_DIRTY)

The IOMMU implementation tells if it's enabled/disabled or supported/unsupported for the
set of devices in the iommu domain. After we set dirty we are supposed to fail device
attach for any potential IOMMU not supporting dirty tracking. This is anyways supposed to
happen regardless of any of the approaches.

For c):

+
+/**
+ * enum iommufd_device_caps
+ * @IOMMU_CAP_DIRTY_TRACKING: IOMMU device support for dirty tracking
+ */
+enum iommufd_device_caps {
+       IOMMUFD_CAP_DIRTY_TRACKING = 1 << 0,
+};
+
+/*
+ * struct iommu_device_caps - ioctl(IOMMU_DEVICE_GET_CAPS)
+ * @size: sizeof(struct iommu_device_caps)
+ * @dev_id: the device to query
+ * @caps: IOMMU capabilities of the device
+ */
+struct iommu_device_caps {
+       __u32 size;
+       __u32 dev_id;
+       __aligned_u64 caps;
+};
+#define IOMMU_DEVICE_GET_CAPS _IO(IOMMUFD_TYPE, IOMMUFD_CMD_DEVICE_GET_CAPS)

Returns a hardware-agnostic view of IOMMU 'capabilities' of the device. @dev_id
is supposed to be an iommufd_device object id. VMM is supposed to store and iterate
dev_id and check every one of them for dirty tracking support prior to set_dirty.
