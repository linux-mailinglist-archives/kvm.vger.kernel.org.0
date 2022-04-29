Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16EEA5148E6
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 14:10:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358930AbiD2MOG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Apr 2022 08:14:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358963AbiD2MOD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Apr 2022 08:14:03 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B06A657984
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 05:10:45 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23TBOU3A015530;
        Fri, 29 Apr 2022 12:10:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=kKa9/DfKV+CwOsy/FG8zTSUjKTBvrL/CTVtGue5IPBw=;
 b=HYdnmIax4J4FIQJeo5Zf8WC5I8/KmZugxQ8b2X8OCmOdZO7XBa7m5XUNZUplP92Tg0Kn
 KcIE1Y1cYknXykDGafU+nzXnGTI6L9LCL/8sFrV2gpSuhASxssu4TBESX7WsuVD0pktY
 kXNzSLQh48oTxo00diVAJhjxXS3xs8uyq+PphwP2jWRosyP4htg9xw2qKVbwvYEs8dVX
 cwnc/XBgKE5N/R1U+Ok5TLHXEQAzGYdIF6XBjIjCFPyadjfyvCp4ljlUl3b5KQg8B+rr
 Za4RazIY3/mhyMjrdIi8tsQzPBnyfhf/L+T4CvqKRE3hGCsbGzDkPldCMBIzP0M+VJQ+ 0A== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fmb9axh7b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Apr 2022 12:10:18 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23TC1Erm040575;
        Fri, 29 Apr 2022 12:10:17 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2175.outbound.protection.outlook.com [104.47.56.175])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fm7w80625-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Apr 2022 12:10:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Aj+QYKdn8mR23iqLJQhFclfH/ttR0wDqvFxLDcz0v5Cjv9/J/1c19DNsdYXG9zLw/UOBQzRUfd0kGbvEziGJglZe0/VVL+Ki9tU+mSr5oybLABluFeK2XrOj2pHZj29baa3YtLHbN/CD4t6NSjJIiy+XDKOfUqIxCYhr2RdlBDMnFiZqwzTib8MIkuJKOmz2lzt1C1zDQpJIT6UVskfNlHKlsokfD87VGWrTM9pLH9sQmO2J2YADFqaw7mfT+QU3fuRtFkYx8+LYbZo/P08kJqrETFesIYEQBsrsdf/GFRdqJESD5SHi5BinCNhZ4bgjjpA9rP45Cr47lG/ozPOcvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kKa9/DfKV+CwOsy/FG8zTSUjKTBvrL/CTVtGue5IPBw=;
 b=kkzdIHn6Cqto86PogAPbkhcwBgDWObei5QlW5t9Em/JeTIjjtr5gDgaid4ocyNnxq/GWUytQG6Ww4F8lsfgdi8NNuAA7te0W3J0EopoND8eSSWhdbGNn4Hj21pBNcprN1Pi7mrddBYWRJOSXwPCWexVOdaip2X7nGTb7T8TypO0YiNGGWK5r1xiOFrg1tTO3GgXdSzHv54STEq3Vz/yZRC+oKPDBA8aa05CIiykc/RD6rDFjc4zXOh6unLCC9kchFc+3bENoXOixjR1URkeHDRySX89tkEJM2oknSndHe6BPh2nNhJN00VuXxpPJO0SI5LVAU9S0skdkkqw6+CL8Rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kKa9/DfKV+CwOsy/FG8zTSUjKTBvrL/CTVtGue5IPBw=;
 b=ZgffxHCB1Vgoy3LgiEjs20pBVd4A+Q1F4zS+k9TMSgvq6RnbGBoiyjAV4a5drLseutWdOougyNIAulYdUzhoWVgjHj5SaYwFUoiM/Tvw9EfqkSTjV2YOfeuEJuXU96BPXv+7GTeSodBNWfvqZ/O3MJA7JdPH/3F3vMzSlD4w4WA=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by DM6PR10MB4298.namprd10.prod.outlook.com (2603:10b6:5:21f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Fri, 29 Apr
 2022 12:10:14 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d%5]) with mapi id 15.20.5206.013; Fri, 29 Apr 2022
 12:10:14 +0000
Message-ID: <17aa6d5d-e386-c115-8dfb-5e7bf12b106f@oracle.com>
Date:   Fri, 29 Apr 2022 13:10:07 +0100
Subject: Re: [PATCH RFC 16/19] iommu/arm-smmu-v3: Enable HTTU for stage1 with
 io-pgtable mapping
Content-Language: en-US
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
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
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Kunkun Jiang <jiangkunkun@huawei.com>,
        iommu@lists.linux-foundation.org
References: <20220428210933.3583-1-joao.m.martins@oracle.com>
 <20220428210933.3583-17-joao.m.martins@oracle.com>
 <599f3156-17f3-96fb-2736-ac6d63c91951@arm.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <599f3156-17f3-96fb-2736-ac6d63c91951@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0243.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a7::14) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 52165ba6-a8e3-4caf-f888-08da29d9378d
X-MS-TrafficTypeDiagnostic: DM6PR10MB4298:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB4298014F1F5C8619DC8D14CEBBFC9@DM6PR10MB4298.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /fP9vYEXbNlglpic3RdZkm5PkhnJcGKYyptBCbLS97rX+Zd+7IaBEMRyEIstCTvWX9rhc7jYMMAQzqr9M7rTReVsy/FXXhNkCCYyyn0gmx5yNG+2UjeSN2Hyd6PRmW8wtV09DTfbbINwBi3gHNrnm+wjMOnFIkh81kJZY+Qf0Lf+sKzp8pv0TAPvG+k3bBJcf8BzJz6DkzdFz4Ct4HYVm2XM1mceoSfES21cUDyqeiyzjzEVe0mFiUvZiTTEWW2FFvqrLiM9mfz2BzBRbwGSawK0o1LLUq6aHurset7042rgPWXkBxQyGjSThRHRqGurIvM6beAYBT4OJXoBqKWgcX6zKZ9bRh5s7NEDcs+5RfawPwq4tAi05ZGIX71G1vrGrYXSEeXIaP/ltj9P5X1SJ9G0YI2CuwRsoVoBiC5i7xRXrKLhcjCLUZYTlEHhbMI/yZbYXHXMHL147+H1XUDqoThp6caKj18kN/BRIG/OhP1fVRmeLgp+dkeH23q+70rwNcwJdDRBD55N8SyukU9039z9Vt3c8CIdCwfZKl1/Ad6Yt2u2rQtZmO1TnN/mPbmBM1vcAdh7zxko2B66zWjYUaxCfZM1KuDYquP36S8LInZiz+cJ5B7W5LmMYhEWfr6Nj6iZn+FjziTRY+E0ooXXy7FqxTtS6Ec90KliXiJVtnAljn5c/PuqxjGsS0pwezubEtKUDgyQvpmrXFNO2tsUrg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(186003)(66556008)(36756003)(5660300002)(66946007)(2906002)(66476007)(316002)(7416002)(6916009)(4326008)(83380400001)(8676002)(8936002)(54906003)(31686004)(2616005)(31696002)(86362001)(6486002)(508600001)(38100700002)(6666004)(26005)(53546011)(6512007)(6506007)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UGZ1QmI5ZllhamRGeWJGS2tGcEJzN1V3bktESENRMEhRZEpMV21WYnNiZ0N3?=
 =?utf-8?B?M3ZvSnMzS0s5dGhpSk5JSkhhV2dkNWhBKzVJc1p4RXNhQVZkWnZXVnkweUZS?=
 =?utf-8?B?RzhVSkJSRVc1aDFCeTgrMVdlVks0NFNHVG9lWHllR0JEemM2OWFyWmU5ZFQ1?=
 =?utf-8?B?V2NMRk56bGNJR1E1RWJ2MWwzWGVZcjB3UGQ1VHdEblAwVG5STGJlSENZKzE1?=
 =?utf-8?B?SjdQT05BZndTYytYV0VHRElLVElDd3BJdVFFbTRkMjVGYzlWcHFnY2lINk9k?=
 =?utf-8?B?bVBpTGRxU0ZEbGd4Z3BGWVVpcm1aczRwMjd4a3JmQVVMeS9wcnFlOUhsanBu?=
 =?utf-8?B?MElMRy9pTHo4L2p4aUI5VStwd0JqeGYvczRQV3BoUEF1Yno4c2pFMVRWMVZV?=
 =?utf-8?B?UmR5TVAvbFk5aXFJWW9tWjZBY2lzWllWNFYwT3VHQVVlUWQvOEY2bXNPeDQ3?=
 =?utf-8?B?ZU1mM09DNmxvL1FDSnQvdlo0bW1IckFSQ2JNUFc0eFBycWtVd2NGenBocU0v?=
 =?utf-8?B?czAxcVI0MktRS2J0TXd0VEdYSEZkeDllWjJkbGlRVkl6UFBjbG1CL1ZhUi9V?=
 =?utf-8?B?Y1kwcWQ0VkFxTVZrRXNTYnM1ci9sL0U2eTJhRDg3SUwxdGVVZnoxQm5xUmp5?=
 =?utf-8?B?Q0FrcW5qQUFNN2ZybjgzR0V3VnArQVBzV0R1RnV3NGtRczN6ckpRQW1rZW90?=
 =?utf-8?B?UmRCTG8xbnVvSDJBbE1sQkJXeXZBZUNJN2l5MWdLUm0wcGlOb3ZhRWtveHhK?=
 =?utf-8?B?RFYwS0hmVTdOR2FDc1pQb251QTZ1bTZOb1R6S3RLNFp6dU1UWHlvVWU0U2w0?=
 =?utf-8?B?dmM3VGs3U1pxa1A3RFY3eDBIbVBRdU52aytoV2NBVmR6aHFsTXViQWZ6ZW1u?=
 =?utf-8?B?V21IbWI1RnNrQUdyMUkrNEFhUTRLVHdmN3NyZDZyeHIxWjU4UFZ4dTE3NndK?=
 =?utf-8?B?SmRSTGUrRGV0RWRCclRlWHJWakxUalFXbTBuNityOVhzTGo1VnNySWV1V29i?=
 =?utf-8?B?QnZrTjY5QkdZV0JpV1JPYkM4eTBadkZXSFBRRVI0YS9tTGxYd1RCY1NiYzFY?=
 =?utf-8?B?YkpDTEVkanoxWWFVcnJEcW1tL1N3N292SHU3cTRoZmlxM1FCS3p4WFRWWHkv?=
 =?utf-8?B?VU40WjdjcUhCc1gxNkRJeXJ4WkdMMlcvLzJPb2tHMDF6UUZnNjcrQTdFdEJl?=
 =?utf-8?B?R0MwYnZ0a1BuRG4wbTQ2TG9qblEyL29HNVRXSHAvRmEvM1JLOG4zS2R6MHZO?=
 =?utf-8?B?ejZhd3FrUWN6VDcwMUtCS25QKzJFTG9zdGl1SEhub2RaZkpZMWwvbmJ5emM5?=
 =?utf-8?B?dGFuVlFGV1ZFaFlPMnI5TldhdUVMTndzbTBIWXJuME1LSnU0ZTdZSjJ1dUQz?=
 =?utf-8?B?Q1o0b3l6T1U0ODVWc1N2WFJtYlNleUphWjlveFgwUmczK2dveDJpS1cydStL?=
 =?utf-8?B?UGJ0YUdheUhhRFVpa2QwTGo4VjNIMHRxT21rcVU0Rkl4akNZOTFsTWZyQnJj?=
 =?utf-8?B?aE9YaFRYZmFyaEx4cUxkUXc5cHpOckQ5TlJvRDhzeDE4U0tPdTEvOGNHaEc2?=
 =?utf-8?B?aGp6eU1wRHdSWnZzWjJ3VHROOGg2cWJmZjJFTUVvb2c1UzArR01CbTAzRzg0?=
 =?utf-8?B?ODV2bThXSnJpVHJlb0pNdXhQSFVwMGE5cWxLMVFDd3JSaUVpdnJhd2g5NE9J?=
 =?utf-8?B?VmUvMjBZUzJ0Rm0vRGdDSnAwVnEyQmhKK0RESERZUmhTdzVEZUI0Qkc4bEJ5?=
 =?utf-8?B?RGI2UVVITlFXcng4TElpS3JYSm5SYndjanZZbm42M3UzRmh6aWRLNld3UTF0?=
 =?utf-8?B?OVJISWI3YVV4MGZEemR2MDVsWVRtTTh3Y0Zoa05FSFAzYXNLeE5wUTZGWWox?=
 =?utf-8?B?TXlpeUVaZjhRRmZTUUVkNTQ2anlyNmt4c0FHZ0RUVlhVSFl1WHNQUVE1VG1s?=
 =?utf-8?B?a3FxLzlZSU9XVGFEeFVvc1U3VGhEQmRMT2lITDMvRXFFQlAzODFiRitEakJQ?=
 =?utf-8?B?NldET1R6ajZvOGdxUUx4NkVPTVF5K3ZzNEljQXNFR1o0cVpiYmIrb0lKcDNF?=
 =?utf-8?B?L2piamhLOXEzd0p3cUpQT3ppN1FhNnVGNXZRcGdzRXg0eDE4YWtFcUZoUk5K?=
 =?utf-8?B?djNtTEhQMXdCRXd2cE1ORFV3TXM4NDRDVWZXSGtsOGFma3JlVTlDdno4bnBK?=
 =?utf-8?B?MkRNdjlRNWg4QUVndnoySUxVYmd2d0prMXVVSFJ1RW5KRktNMHpMdThiV0lq?=
 =?utf-8?B?OVZGckdDL0k2UmVzZFVPcTNUNnZxc1BEUlRVb3k2eTVZOWxsNzFZRTJWYlFU?=
 =?utf-8?B?S1hidjdvdGFFVlNhQ2FuY2J4RFdjZnVNQUJ1UnFZbnNMYk9waGRDeE5SVkNE?=
 =?utf-8?Q?kt+UtrnR1/v/DXrM=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52165ba6-a8e3-4caf-f888-08da29d9378d
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2022 12:10:14.3967
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BwfWxAOYfsd45XpH2c04TsCIn4t+OZkDwyUDPBnI67jSwp0WooU+x9QheVaQ5/laknBHcSZQF72EMJIycjKYDOtTxMYXJ5Gl5y4gl+U70Ok=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4298
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-29_04:2022-04-28,2022-04-29 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 mlxscore=0 bulkscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204290070
X-Proofpoint-ORIG-GUID: EsUQegs7TvMmEfTDiugy4eWk39iJTryy
X-Proofpoint-GUID: EsUQegs7TvMmEfTDiugy4eWk39iJTryy
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/29/22 12:35, Robin Murphy wrote:
> On 2022-04-28 22:09, Joao Martins wrote:
>> From: Kunkun Jiang <jiangkunkun@huawei.com>
>>
>> As nested mode is not upstreamed now, we just aim to support dirty
>> log tracking for stage1 with io-pgtable mapping (means not support
>> SVA mapping). If HTTU is supported, we enable HA/HD bits in the SMMU
>> CD and transfer ARM_HD quirk to io-pgtable.
>>
>> We additionally filter out HD|HA if not supportted. The CD.HD bit
>> is not particularly useful unless we toggle the DBM bit in the PTE
>> entries.
>>
>> Co-developed-by: Keqian Zhu <zhukeqian1@huawei.com>
>> Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
>> Signed-off-by: Kunkun Jiang <jiangkunkun@huawei.com>
>> [joaomart:Convey HD|HA bits over to the context descriptor
>>   and update commit message]
>> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
>> ---
>>   drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 11 +++++++++++
>>   drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  3 +++
>>   include/linux/io-pgtable.h                  |  1 +
>>   3 files changed, 15 insertions(+)
>>
>> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
>> index 1ca72fcca930..5f728f8f20a2 100644
>> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
>> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
>> @@ -1077,10 +1077,18 @@ int arm_smmu_write_ctx_desc(struct arm_smmu_domain *smmu_domain, int ssid,
>>   		 * this substream's traffic
>>   		 */
>>   	} else { /* (1) and (2) */
>> +		struct arm_smmu_device *smmu = smmu_domain->smmu;
>> +		u64 tcr = cd->tcr;
>> +
>>   		cdptr[1] = cpu_to_le64(cd->ttbr & CTXDESC_CD_1_TTB0_MASK);
>>   		cdptr[2] = 0;
>>   		cdptr[3] = cpu_to_le64(cd->mair);
>>   
>> +		if (!(smmu->features & ARM_SMMU_FEAT_HD))
>> +			tcr &= ~CTXDESC_CD_0_TCR_HD;
>> +		if (!(smmu->features & ARM_SMMU_FEAT_HA))
>> +			tcr &= ~CTXDESC_CD_0_TCR_HA;
> 
> This is very backwards...
> 
Yes.

>> +
>>   		/*
>>   		 * STE is live, and the SMMU might read dwords of this CD in any
>>   		 * order. Ensure that it observes valid values before reading
>> @@ -2100,6 +2108,7 @@ static int arm_smmu_domain_finalise_s1(struct arm_smmu_domain *smmu_domain,
>>   			  FIELD_PREP(CTXDESC_CD_0_TCR_ORGN0, tcr->orgn) |
>>   			  FIELD_PREP(CTXDESC_CD_0_TCR_SH0, tcr->sh) |
>>   			  FIELD_PREP(CTXDESC_CD_0_TCR_IPS, tcr->ips) |
>> +			  CTXDESC_CD_0_TCR_HA | CTXDESC_CD_0_TCR_HD |
> 
> ...these should be set in io-pgtable's TCR value *if* io-pgatble is 
> using DBM, then propagated through from there like everything else.
> 

So the DBM bit superseedes the TCR bit -- that's strage? say if you mark a PTE as
writeable-clean with DBM set but TCR.HD unset .. then  won't trigger a perm-fault?
I need to re-read that section of the manual, as I didn't get the impression above.

>>   			  CTXDESC_CD_0_TCR_EPD1 | CTXDESC_CD_0_AA64;
>>   	cfg->cd.mair	= pgtbl_cfg->arm_lpae_s1_cfg.mair;
>>   
>> @@ -2203,6 +2212,8 @@ static int arm_smmu_domain_finalise(struct iommu_domain *domain,
>>   		.iommu_dev	= smmu->dev,
>>   	};
>>   
>> +	if (smmu->features & ARM_SMMU_FEAT_HD)
>> +		pgtbl_cfg.quirks |= IO_PGTABLE_QUIRK_ARM_HD;
> 
> You need to depend on ARM_SMMU_FEAT_COHERENCY for this as well, not 
> least because you don't have any of the relevant business for 
> synchronising non-coherent PTEs in your walk functions, but it's also 
> implementation-defined whether HTTU even operates on non-cacheable 
> pagetables, and frankly you just don't want to go there ;)
> 
/me nods OK.

> Robin.
> 
>>   	if (smmu->features & ARM_SMMU_FEAT_BBML1)
>>   		pgtbl_cfg.quirks |= IO_PGTABLE_QUIRK_ARM_BBML1;
>>   	else if (smmu->features & ARM_SMMU_FEAT_BBML2)
>> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
>> index e15750be1d95..ff32242f2fdb 100644
>> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
>> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
>> @@ -292,6 +292,9 @@
>>   #define CTXDESC_CD_0_TCR_IPS		GENMASK_ULL(34, 32)
>>   #define CTXDESC_CD_0_TCR_TBI0		(1ULL << 38)
>>   
>> +#define CTXDESC_CD_0_TCR_HA            (1UL << 43)
>> +#define CTXDESC_CD_0_TCR_HD            (1UL << 42)
>> +
>>   #define CTXDESC_CD_0_AA64		(1UL << 41)
>>   #define CTXDESC_CD_0_S			(1UL << 44)
>>   #define CTXDESC_CD_0_R			(1UL << 45)
>> diff --git a/include/linux/io-pgtable.h b/include/linux/io-pgtable.h
>> index d7626ca67dbf..a11902ae9cf1 100644
>> --- a/include/linux/io-pgtable.h
>> +++ b/include/linux/io-pgtable.h
>> @@ -87,6 +87,7 @@ struct io_pgtable_cfg {
>>   	#define IO_PGTABLE_QUIRK_ARM_OUTER_WBWA	BIT(6)
>>   	#define IO_PGTABLE_QUIRK_ARM_BBML1      BIT(7)
>>   	#define IO_PGTABLE_QUIRK_ARM_BBML2      BIT(8)
>> +	#define IO_PGTABLE_QUIRK_ARM_HD         BIT(9)
>>   
>>   	unsigned long			quirks;
>>   	unsigned long			pgsize_bitmap;
