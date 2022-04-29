Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC793514CD2
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 16:27:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377284AbiD2ObB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Apr 2022 10:31:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377272AbiD2Oay (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Apr 2022 10:30:54 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFED2A1471
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 07:27:36 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23TBCEtn032179;
        Fri, 29 Apr 2022 14:27:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=+FfDX5MEZe/AZ9j1LXgcW30t96/iVRYBui2TG4IUMHM=;
 b=U3WNDyw7bOCWDdwUveIy90zwhgqKNjnegPPAK4lNKEWvpUyxuwN8o0qoWQX5yCWBoimr
 q6tjv/VZA8RtfyV99Wi0RFVYyCh+V/Vp4mVHTAOK8QkiQ7kTaWqqJHH8v51PvwLkhUIe
 EQShn5zK8FXU1rSPyEJJiqjxV1HxTIHgS3l+v9IGLgyvN/g6zEJ0v6ruu86kE1g04K2y
 mOBT2itmKeyXmZiKHXSXUH6Qr6trjTb/QC42md7YcrV5cpNcvioIsG1gBKsb27s5y4hK
 xPXLMb0WZMy+yhy5ennyWqHQJcH1uKskKtCFAxhYKAItQK0YozCGgj7BYXZZ+216o7C6 MA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fmb106982-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Apr 2022 14:27:14 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23TEFF6R032900;
        Fri, 29 Apr 2022 14:27:09 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fm7w84d9y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Apr 2022 14:27:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EWc39YKeFOOfsSTMkbb5loHvTM45fE/N3d1xMtnxrXHxvKWCcKdP16yXjGdZpsfU7LndLYN87Zk7I+rf+55GhDBWiktGMMuYkDNczozrE+YUgQXv25+f6w3K1ymn/V59bTay83p2GNGQDKRVRCwEGBjrMYkoZhsrQ0YiF+iAtAk0jsXHt26j3PLvfsD3SoVueU3Q2FKIGXWMeK5Rsz3mVrjmHhjM0mlGDSrX9ppLWlOR5ANS7WIs8asE377uMLlIC6dz3eFa3ynuzMwuIt71xc3ZhCbdB3veKZ8zWFPoTL1JE8eLsiy0SnkGiYYVgMXSt8Z9mRs/HutpKjI3gEFzXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+FfDX5MEZe/AZ9j1LXgcW30t96/iVRYBui2TG4IUMHM=;
 b=STQBLIRIM4dhN9PvI4O85ZRgRciA+XvBXLALeAnebq5GZKeBFvwEsD3A5QF5AWaBZVhg0y9fGQSTdCIttT9DalUJJyip8t6HYrVXvb9YeD4GfUKbsXlTmtkJhB04pFOy/yuZbUFj3L6zRzZNQMxWdVfEsh/VQ+vZi76XWwjzByVv0x9/NzYyFI8R6WJno3RrfRw0rF0mtinySIhN1pvL4QpxAQJVGvKRrzrJ5U36BeTQVhLy8t73HPqjC6LKXME8m+rLmFo4iI54jtoFVITnVYYaCyPGMQzYwlK3AN8WGu+oYx1av8R7Z5t1e6juf5YBiOiRpo2AeVF9yfW5Fw8OYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+FfDX5MEZe/AZ9j1LXgcW30t96/iVRYBui2TG4IUMHM=;
 b=rI5wQRb5JDZXiCMkRXs8L2O13cT4oTcG+UHDpiHu2WtZ53NZ8YdhpPJbNDBmqfFUAs02dxs21Qy7S5yP/nGKtyKwmBI4oiTbPJ+PZRuRcqtwRf0o8+YLZMewKhZXyGS+D/ZQLVa4l4npvCxoTf1pckndFwIgdBb5c9dLRZVoKMI=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by PH0PR10MB4645.namprd10.prod.outlook.com (2603:10b6:510:31::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Fri, 29 Apr
 2022 14:27:07 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d%5]) with mapi id 15.20.5206.013; Fri, 29 Apr 2022
 14:27:07 +0000
Message-ID: <862dbdc4-b619-d97e-f358-1fd9e3778c5d@oracle.com>
Date:   Fri, 29 Apr 2022 15:27:00 +0100
Subject: Re: [PATCH RFC 07/19] iommufd/vfio-compat: Dirty tracking IOCTLs
 compatibility
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     iommu@lists.linux-foundation.org, Joerg Roedel <joro@8bytes.org>,
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
        Kevin Tian <kevin.tian@intel.com>,
        Eric Auger <eric.auger@redhat.com>,
        Yi Liu <yi.l.liu@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
References: <20220428210933.3583-1-joao.m.martins@oracle.com>
 <20220428210933.3583-8-joao.m.martins@oracle.com>
 <20220429121910.GT8364@nvidia.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <20220429121910.GT8364@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0111.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:c::27) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3c78c608-31a3-4d11-9eba-08da29ec56a1
X-MS-TrafficTypeDiagnostic: PH0PR10MB4645:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB4645CE69F3F7E91CF3C17503BBFC9@PH0PR10MB4645.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: p+rKOraueM0PgcIEMV0KmUztxvupkssbeDuJk5mplI8hg7sNWcIiK9L89Oha1DlX7ywXEHpbTuH96I3fnLKHAGG9e5GWUcSi6T36jQG7OGTgqSXAtD8CZfQ62MGZ0TArit0KkAq0RjHR+gTNDoltKU9rAJJLzfC7wVRs3qet8pWwcxQWkjtUO9nBOx4/24oUbrJGWmJheOfAcGrbwHC+6Nwai5TwoDkRvnFZtKfb9eLP2LuTxKNUjCKy2xOmEfHhjyNVopUWs+DtK1imzA1lE1Q2MR+Opzqd3KH58O1GFRASa77HYbVZ39B00UhlMmPSr/WGNU5DvviVH7W7sv/d8T0+7HAmt7WnIbFdnj84cFPmSRIFux5npFqXyGyKOzs8DGZg2Wgr39EzLjfaw5UCv1EVnqMmLcYZTQkw7QibhvSB+pCOMQ2RbFUDEyPEVlVG+VlQQrAk1+SgA+gqoWiKF3blx0a2xtGn0PRp48fKIZ7hdE8EV1t+EKqBwGHjstlqBba6ECSEU23aUP7r5jccjHGdkbM5xtkhky5raDiUTthoT/GDMxIvSg99rSRFc9iLvKrNn62xWB93vbnsVj4Z0ZXqNlwwkCGsHGPC/Fh61MUbQIP59ZGwmA+PYUu9imIFLquhmmIv1Vwt7soOpdg+kJpilfD5fIi6FjD7uh3juPTIn6+aed8AMV62yt/miFzdv9UJ2uWm4U26jE7tJgSawdwlw2d9C7cscpG2Q2p9yUk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6512007)(508600001)(6486002)(6506007)(6666004)(31696002)(8936002)(5660300002)(53546011)(7416002)(26005)(38100700002)(186003)(2616005)(36756003)(6916009)(54906003)(316002)(4326008)(2906002)(83380400001)(66556008)(66946007)(8676002)(86362001)(66476007)(31686004)(14143004)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZUJoNFVwdWpBWTg0NXVkVkhEdmpBZE8zd3Vad3dTL1V4VjJMUkJnTjFIeXpU?=
 =?utf-8?B?MEhDSHd3VXhYdXdmNjNMU21vNzhGVEp3VjhOcXVjQWhzWVNpVU8vdkYrcDhF?=
 =?utf-8?B?UWo2ckR6Zjk0UzN5SEpmK0ExMG9xNnV5MFR4ZUhJandzbVlRNGwyOFpHak9I?=
 =?utf-8?B?c1lqeFdETjJob1dwTlFzRVdpSm9lYVo2TUd4K0pPRExzWnFyZ1lHODdta21V?=
 =?utf-8?B?bERKWVVmU2VNN1NpUURodm5mK1ZneUdXaW50QlRTMG43SmlCQXdVdCt4Uytt?=
 =?utf-8?B?OUI3TmpRaUQ3bkYwRkZPS081bnhtRDlSRWtvd1N1UVBVRU1CU054WlRycThv?=
 =?utf-8?B?ZllZLy8rdGoxNi9NOGlUTmVSbGtoR2JkbFFyY3hTRU5xUDJZUGNFdVM4cHpu?=
 =?utf-8?B?OXh2M3dtdDFBUkF5V21pRGZhNXV0S3RHemtGaEN4YmE4a2EzZTVZaktSaGt2?=
 =?utf-8?B?dUdSM2lhTENNLzIwYlFJY0VEM0kxQ2VmQ0xnTktrTGFOMWVBSWVnakQ2TWFK?=
 =?utf-8?B?OERKMXByZUo0K1FPTW5GSzh3K2RpOFFvOWQxSklHUkQ5TlRRNVVVelNlNCsr?=
 =?utf-8?B?RDBYRGVocWVpM2tKSHY5dHgraGtvazNlK3RlZDNxWDdRRG92dDZrdDdSSlFv?=
 =?utf-8?B?OVk3TGJ5OTlqZFEwRGZNQ01Od2hQdytWM2pkSVhmYzhoTVQyUHRvVTVQcmtU?=
 =?utf-8?B?QjBGVmVDOVA1ek55TWFqcDJleUg5SVl6VGdGNXVVM0JwWWlYQlNkVW84YmtD?=
 =?utf-8?B?bXRLN2VwY3ZjS0wxRjJNOU44dkpaeVdnc29BWlU4YnF5WUY5SCtoa2JnTDRS?=
 =?utf-8?B?V3hOOGJsdHBQL1pXczhLekd5UE0vVXZ4SGlGRFl2WmRuRnJ5c3FXemdzZkR1?=
 =?utf-8?B?Q3hjUlQxMXVLVFNOQXBTR2drUnpqekJYaDk3MXowbUxaL1psZFZZTDhuZkMy?=
 =?utf-8?B?LzdKaURmOHBLNzUyR29ZdTF1bzJZTzVuWGVOMFdxWjVtNlBmSlhBNE1FcUhY?=
 =?utf-8?B?cURKWDZWV1JTL2pCNksxNVJ4eFYrTm42cW10ZWJiSjFlWTFEQ0xsT0hUVU9J?=
 =?utf-8?B?SzFpZG9zc0Q1dGpRSWN3WTkvQUZlYnR2bGh1ekg5bTNPRUxKelVxSEhZeENP?=
 =?utf-8?B?SlQyM1JiK0IvbllaMUlRR1FEUmQ4SUd6czdpb25NQWEvVXVzRENuVGZZM0Ro?=
 =?utf-8?B?U1VRVVBWdE1LU2FneFBaVmo2R0xIMEdmcWFMMG5CMWFHcmp2NzltSUtuVTcx?=
 =?utf-8?B?MzY3R1gwbXIyZUFGbS92b29VMXh3WGJGM0Y1Zy9mMTVQbGRIQzNlN256dUlC?=
 =?utf-8?B?Q2NxSmRxaDBpVXZVSjV3OEFYSCtqalFOYmxnMjdpMVBsZHJSNHRyRUZZUXdy?=
 =?utf-8?B?M1Qwd1RtNlFZcVg3NUFoeUcxSGdYcFdGdURuR2M2ZURhcGdHWDVCNzdoYlJZ?=
 =?utf-8?B?QzN5K1hJcHhLeTUxRWRrMXFvK3E1c1Z4c1g1TGdGTWF3cEhWTTdVTHEvQ3RH?=
 =?utf-8?B?clV4bERiS0dmUHlLWExWVDZKeUNVWGpqMUxKdDAzOXE5Sy81VzRCZ3p4Sitq?=
 =?utf-8?B?QmNKTVVFemhadzY1cWJ4L2l0VVRsRm85VXZHdTdYVkdUT2JjbDhMNnd0K3p6?=
 =?utf-8?B?OGNxU0RDVTg1RlZsdy9QU1RMUGhXWGJRYzkxRUtrRkJCOHVzZFlaNDZPSVpV?=
 =?utf-8?B?OXd6TE02WG43bTI5c2UxVEpmMjlobXZJTFdUeW9Tbk1xMXRHOXNYaUdGTUNp?=
 =?utf-8?B?QkFhVWpINVFCbU40Z3BTOUhlTEkvTTloNTNpRm1vVkozZkd0aGdPc21CRnNx?=
 =?utf-8?B?V1FkMTQxU0p2QS9ISDdLWlNtZ1MvNUtUM1dnbDFOdHlUVmtvQU1hRjdNZWFZ?=
 =?utf-8?B?emptcHQ5MUdXbEswdHk0bk00bzQ0bFJtNlJIZDlLcmNIYko3Z0dYSWlJbUFD?=
 =?utf-8?B?WUZUbnZtSVR2N0VLMG9kTmNvTzdsTUJFYmQvUHcvRFRnOE03NE1EdU40ZURH?=
 =?utf-8?B?U0JsUWxwc2U4ZlZRbXNQOE42c3RoYkFUSVdvNzh6MnV1aFBjSWRSbnVIdlRD?=
 =?utf-8?B?WUdCWWEwZ2ZPMjRkbEVVdjIxZWxZUW9RZm5YNDRibTBqQUx0Nk85eWFaempS?=
 =?utf-8?B?MHZJSmlKMmQvL1YvdjRQeDVFSUYzZ2tLaURMKzFSc3JoQ1A4UmNwVGY3Y2xZ?=
 =?utf-8?B?QjFSU2pSRElPeDB6aVUrNXRwWU9zcVpRbUNCVThDTE1udmpQMlZlSGhaYzZ1?=
 =?utf-8?B?b1BXMnI2Yy9EMkdkYXVxM05uSUtEWHZoQ1k5cjkyK01mcmdiUDAzR3lqVGVj?=
 =?utf-8?B?RVlkdUdGeDJsMGN6UUVHME5DbmpCY05lUG92QkNLaHp4c3FxQTljdzJOdzNE?=
 =?utf-8?Q?dInONTH1JNWSmIRA=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c78c608-31a3-4d11-9eba-08da29ec56a1
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2022 14:27:07.0674
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Qn6/JRgxRTmI8ssescnDIgXmyN351JnSmff2BIoKgR/0OpgqxBzAA4G1+KaGk6J2QUe3dHlcZNoSycfRpw94Bo3kzbAkSEGQ08SI3grJlvQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4645
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-29_05:2022-04-28,2022-04-29 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 mlxscore=0 bulkscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204290080
X-Proofpoint-ORIG-GUID: 0XBuyIkjlny0v_Qqd07h9oeudJMXVC46
X-Proofpoint-GUID: 0XBuyIkjlny0v_Qqd07h9oeudJMXVC46
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/29/22 13:19, Jason Gunthorpe wrote:
> On Thu, Apr 28, 2022 at 10:09:21PM +0100, Joao Martins wrote:
>> Add the correspondent APIs for performing VFIO dirty tracking,
>> particularly VFIO_IOMMU_DIRTY_PAGES ioctl subcmds:
>> * VFIO_IOMMU_DIRTY_PAGES_FLAG_START: Start dirty tracking and allocates
>> 				     the area @dirty_bitmap
>> * VFIO_IOMMU_DIRTY_PAGES_FLAG_STOP: Stop dirty tracking and frees
>> 				    the area @dirty_bitmap
>> * VFIO_IOMMU_DIRTY_PAGES_FLAG_GET_BITMAP: Fetch dirty bitmap while dirty
>> tracking is active.
>>
>> Advertise the VFIO_IOMMU_TYPE1_INFO_CAP_MIGRATION
>> whereas it gets set the domain configured page size the same as
>> iopt::iova_alignment and maximum dirty bitmap size same
>> as VFIO. Compared to VFIO type1 iommu, the perpectual dirtying is
>> not implemented and userspace gets -EOPNOTSUPP which is handled by
>> today's userspace.
>>
>> Move iommufd_get_pagesizes() definition prior to unmap for
>> iommufd_vfio_unmap_dma() dirty support to validate the user bitmap page
>> size against IOPT pagesize.
>>
>> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
>> ---
>>  drivers/iommu/iommufd/vfio_compat.c | 221 ++++++++++++++++++++++++++--
>>  1 file changed, 209 insertions(+), 12 deletions(-)
> 
> I think I would probably not do this patch, it has behavior that is
> quite different from the current vfio - ie the interaction with the
> mdevs, and I don't intend to fix that. 

I'll drop this, until I hear otherwise.

I wasn't sure what people leaning towards to and keeping perpectual-dirty
stuff didn't feel right for a new UAPI either.

> So, with this patch and a mdev
> then vfio_compat will return all-not-dirty but current vfio will
> return all-dirty - and that is significant enough to break qemu.
> 
Ack

> We've made a qemu patch to allow qemu to be happy if dirty tracking is
> not supported in the vfio container for migration, which is part of
> the v2 enablement series. That seems like the better direction.
> 
So in my auditing/testing, the listener callbacks are called but the dirty ioctls
return an error at start, and bails out early on sync. I suppose migration
won't really work, as no pages aren't set and what not but it could
cope with no-dirty-tracking support. So by 'making qemu happy' is this mainly
cleaning out the constant error messages you get and not even attempt
migration by introducing a migration blocker early on ... should it fetch
no migration capability?

> I can see why this is useful to test with the current qemu however.

Yes, it is indeed useful for testing.

I am wondering if we can still emulate that in userspace, given that the expectation
from each GET_BITMAP call is to get all dirties, likewise for type1 unmap dirty. Unless
I am missed something obvious.
