Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14464485DF8
	for <lists+kvm@lfdr.de>; Thu,  6 Jan 2022 02:18:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344242AbiAFBSB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jan 2022 20:18:01 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:42762 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344233AbiAFBRz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 Jan 2022 20:17:55 -0500
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 205N4O1h011234;
        Thu, 6 Jan 2022 01:17:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=4ZEVphl01D0qe+AXk3tZ8CCDCCB4EKQy0Treli4KYu0=;
 b=d+1s/w6RvVLbNzxM8uZlRIQW4Igf4O1TF2ZKKhLw/20G5Fz68tOzRNVSo9hAMZvacrpY
 G8+Mej2IPfWZ081uheMuwGSj94xShrPD0Fv1KVkGPr3YqdvgCiGatO+lzEQQfDR/aumG
 SizYwN/imzl3tCjjiFcwSZspwVJR6oJSTz2W4HplcjBWlsWoBlkqLaJAd5w9NAQ+ksGs
 nF7bqyDoHCkKCZSdynDFSZV5C39jMmBUZHhrXbKmqMFyrxjtuW9r09v2n48do94zZHua
 f8nr3hksY27NaaxSHD/leyIZ/sPA8FJ+Ds4TLyaVCW5utS/BqgP6i8fTh9cMUOoaST3Y lA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ddmpdg52c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Jan 2022 01:17:17 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2061Fm9U005152;
        Thu, 6 Jan 2022 01:17:16 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
        by userp3030.oracle.com with ESMTP id 3ddmqbwvr6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Jan 2022 01:17:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K6N/qHTJszVh8NNSI5VpqFQ4gAp2EAJiCeGOTN9dp4+jWKcrehmV2fVsYuceRG9c5iPXd8uSqK/vEyEE2iuZucHJM2E+CmvxaBbrPjckYmqG5HzHHFLRqsMN+7LHn+7PbjN+iOGE4KY4z/U9wsz78weCSs++jCN1k48BGcL9K+TDDlxojSwppcTMDzF/C04g/RZSUwtjvrd0m8oymDQAVZ2kbkSTLH5/lozk0zYyitiT0PHoOduwx3ngWNu/TsSXH8c5dD7u7SpGaYTPV/EPMwmTP7cOM8zn844Zx9xVy1cN/+HJozy+YBCN6MznYC6aqXBV9dcQSIm/1lAv8Z/mMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4ZEVphl01D0qe+AXk3tZ8CCDCCB4EKQy0Treli4KYu0=;
 b=fxKF2SXy/UuCsrEcfgH8ljhqPjBZ5L2Oz2HI0e/5E/T2MdCysI1BfqeaGSGMf0zfCuDPynkAWcEfO6rdsZiPmZiMpTx4lehVtRCi0clrDVBdTN8Gz1n/LiDYl+iPZG0u7hEshw4xIafqPwIAHm/fmWvXp7o7i+qrRYonKHrszvKjpGsA1ftmvYBXXThRtuVFBvDAw7ZaJvi365+0WfJp8Xx94tjhgJPMbQhYcoG4IokT/SY9ujBMt9TH6Im8zX1z5SoNgwGkTbC4YBB3BjhWyTBda7wI6ylq5gAcGF30db7JV7WMUKWX50Sh63DZiWupt1VmpZzK8lnClLMgScbLzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4ZEVphl01D0qe+AXk3tZ8CCDCCB4EKQy0Treli4KYu0=;
 b=JbVR9iu1f1Zjid3R3scG016JH70kXiWxwXEaWWosPMFH5HOMwxzYHsetNJrNixZCeU5KwSCnVTduS2CkJL89HmsJ6M4T+p7kKCZbca1nqkDr2Z0z3czEYSwYwODm7I7lfrHmQ7niw9MrKkWgy1KYv8GKCIybKY40BpSbsKpxPjU=
Received: from PH7PR10MB5698.namprd10.prod.outlook.com (2603:10b6:510:126::18)
 by PH0PR10MB4597.namprd10.prod.outlook.com (2603:10b6:510:43::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Thu, 6 Jan
 2022 01:17:14 +0000
Received: from PH7PR10MB5698.namprd10.prod.outlook.com
 ([fe80::85a3:23bc:dc92:52d3]) by PH7PR10MB5698.namprd10.prod.outlook.com
 ([fe80::85a3:23bc:dc92:52d3%9]) with mapi id 15.20.4867.009; Thu, 6 Jan 2022
 01:17:14 +0000
Date:   Wed, 5 Jan 2022 20:17:08 -0500
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alexander Duyck <alexanderduyck@fb.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ben Segall <bsegall@google.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ingo Molnar <mingo@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Michal Hocko <mhocko@suse.com>, Nico Pache <npache@redhat.com>,
        Pasha Tatashin <pasha.tatashin@soleen.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Steve Sistare <steven.sistare@oracle.com>,
        Tejun Heo <tj@kernel.org>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        linux-mm@kvack.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [RFC 08/16] vfio/type1: Cache locked_vm to ease mmap_lock
 contention
Message-ID: <20220106011708.6ajbhzgreevu62gl@oracle.com>
References: <20220106004656.126790-1-daniel.m.jordan@oracle.com>
 <20220106004656.126790-9-daniel.m.jordan@oracle.com>
 <20220106005339.GX2328285@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220106005339.GX2328285@nvidia.com>
X-ClientProxiedBy: BL1PR13CA0421.namprd13.prod.outlook.com
 (2603:10b6:208:2c3::6) To PH7PR10MB5698.namprd10.prod.outlook.com
 (2603:10b6:510:126::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4bfaae82-aae5-4361-bf2d-08d9d0b24579
X-MS-TrafficTypeDiagnostic: PH0PR10MB4597:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB459717CF6FD4584EE2701D10D94C9@PH0PR10MB4597.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tr37Xkc4l54xV/U+xUXgE0dP5YeTyWQYFbCpz4rov91n2Y5GMy34+mjndo/sAvZ7i9R222KEZA97Wp/Lp4LvKAzQOHGxlitFERnt1av6rxM208YaV3hKjqg6lFVw5/dugX7CN4P1t+NQWTLj60VgJWdSAUE3LnRir9PKdZJA9hCoaPwiFvSdLjymAMyt6B/mpItBeSygj3j3qaXG+LkxlpsaSAkU2zXVkw7OtWfKpM3uav1A2r64tH3selYdhiycy6tEgWCmEmIjJSkKYk5citlVvUGLBy6VppvSQzFnOxALbQHwr179Q7Jt7eisgCVG6/MrosZag+B4VDY4TWJvoEFH0rld62Of7BcOi1U3O2BU3Pe4xWAxB22AyiiqR0GUFypQ86dckwyllxurqft921hP7v896iQUvsZDbL1uX3SJJzpnet4s6PX6Yf/kiTHd6Rg35vjgpRUtFA8LzdXLDkmc6OIN2+MCpd8VSM4O61ErCo5xr2FBHAKVoEHOAgFKFeLn7N86HCZgcd+vY2KIQ9DVUiyOVWTmu1LMqiRAbm6XcO7ZjTvxQV9YN7Foz9G9rvR1ViZyEv82toqCdo0A+ESjGGbjgx2NXBo723Ad7wGcNnHCLzQwARnclrbPRQehkyqRhcgxXDMy+x6s+SLLoLL4tvvrWH51aiQzr5R131zG6YQE1De6oTMCORIq8NYwaA0hUAreDkRm10fto47WTg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR10MB5698.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(4326008)(2616005)(26005)(38350700002)(316002)(508600001)(38100700002)(186003)(6666004)(54906003)(86362001)(66476007)(6506007)(66556008)(7416002)(36756003)(66946007)(6486002)(6512007)(2906002)(52116002)(1076003)(8676002)(8936002)(6916009)(83380400001)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?f3nz0N/Q8WBuoFNEA1/Z+byvMepmKiF+ztGSEYTfmUlWDoNbSC6oPRcfiJSB?=
 =?us-ascii?Q?H7+4rms9JyyZrV2nm6G87Svin8DJI/zC8b5Bz5BFgLlNvfwuqEqPblZekHur?=
 =?us-ascii?Q?/J62HGzw3+JQPMeBIiytwkxzwNQZ5cCEmosbu7mvQlAirXb+ja3l9EdIqLZ3?=
 =?us-ascii?Q?bI3946bxf82gpagfpnS4nAF5FsdQcN3uqONO383V2LUxdIoaVVHdJBBKfod/?=
 =?us-ascii?Q?E43UcJ3bp6hBJofeLc4R7mfENxMok9OfFOKOLFHTaMVmj+Y/ZwAbUjW5LPVQ?=
 =?us-ascii?Q?LjucGesuohO7xGyzPyoepEcyh1Zn/SKJI8e3G+1GT3sNlLu8AC+vsE2/gmpO?=
 =?us-ascii?Q?xcrF2I1LqazojWNOTtprQi7wGzYGSq3gbtrvT8wXLlGS48RiXeR7I19kzJAg?=
 =?us-ascii?Q?yj8B7Stf/dy8fpUhHjIq6ae1Im7feAqwWYyz2vz2gEUtLI/mxKRAEWIQem0P?=
 =?us-ascii?Q?KluurfkLmgyWy3PxkDgIZq/nrno/UEQMjUzMuPWD+8WdHyjk296jnmBAha8q?=
 =?us-ascii?Q?e1B+gri/lm49EWdRLE7DOAwlm+Pf83ba+hDgm7Uz0Hp5kzKixGxMhf6kDkbB?=
 =?us-ascii?Q?ar50lDLs1wqPKCqyKKDwuyzo2+cw2DBIix0Gjobf7Oc7hhaxkLAmh1w3VOkI?=
 =?us-ascii?Q?BIJlhc8RLQq0lXHLAFaCEWX3A+Al4aDkeQfFYG5cvCKqPPEABu0bmUWxGVhT?=
 =?us-ascii?Q?R34vdn2mfPw3jS1357X/nJOHi1es+RPSSdaSMSILrEUK1R9cbfKorSmEdJku?=
 =?us-ascii?Q?Y3i/khAEIQdAQjFrzaLVXIrkLYPghmmIDe5jtwgi0MyxHjs9eT1sX3abCRbJ?=
 =?us-ascii?Q?eeSI4Wk9ItItVoZ4fdu9zn1+5KMmhYmJcpT0ImHC71yVddUES6UVS7HBWl7m?=
 =?us-ascii?Q?eKXOqgaBhqHoxBo7pdIczTGcxUNlbnfVX/NElndrOQwg/hmOh245HwseRIni?=
 =?us-ascii?Q?rh8qfOZtaDeyPjoSHEmqYpppuVq0cBipKfyaNYmnIigX3tZgDRYOza1e9Ipv?=
 =?us-ascii?Q?zgYoAupjh1xtXVyh80wKEs5soUWfmVj6lKcLJ/l4n2aSx5+aou3IqoybbLSp?=
 =?us-ascii?Q?Lhh/9UAqXJUBhRvmjpr8nv/+diE0D2pPy8+vIsacO1Kh1Vxt4zho06kAy9yg?=
 =?us-ascii?Q?CQibqK+uzyPGLdtCVCjhJ858MR+Kuhy0lzSTPh103P5ltg8Z4x6TxLd706+3?=
 =?us-ascii?Q?NLrK6b/p9fzJKtSnnBB238OyYqm9nUbaR0XrhWyEsmCk8xwiuvEChTEqCXtB?=
 =?us-ascii?Q?IXOy9Me/iNJmivSrnN2uaLXxQj+kjrs35nwR73hOkxgmsETauSkX6Gx5ATU4?=
 =?us-ascii?Q?Qjy0mXDRQbBFGCODBCZ2jwuKDJoKJwcECRuxiSTwRbzS2fgTFDoA3sLaH3cw?=
 =?us-ascii?Q?+s9zM70HhH7PlqCRGrGr1U4nW38+1QkFjH6O0ngIk74hr795R2+traXK1tRc?=
 =?us-ascii?Q?TC5DkXClt0JUlUdV821LQF0o9aURT9XQbJmfFF0foMixEd+J/nHJQDAVg2oZ?=
 =?us-ascii?Q?ei5fBTK+TCtxdqUg1qe5H9+W8nJ/xh8yL6Mky5OhbX2CuS1pA4ONoz7kTqz8?=
 =?us-ascii?Q?/p7xyuncrDX/nDMtKJ6MgJ8VLF9hz52eYJSeFv2Z4UEZnTSftlmLWcIF3lGH?=
 =?us-ascii?Q?OjVgPhpfcq7LIr8sIAUDJcZi+raqi2/x2ayM5rJjp/dBAd84eU5HRwWVpeRP?=
 =?us-ascii?Q?HKyGChYFJfOVNG6C6vrhvSKpCNA=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4bfaae82-aae5-4361-bf2d-08d9d0b24579
X-MS-Exchange-CrossTenant-AuthSource: PH7PR10MB5698.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2022 01:17:13.9352
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LYgcFNIK6ujN7etBeMj5JBetfbDYYDhTO+EMvgXpb5dybwOYDKSqvhJnXkmIfNwpf13rG49OiLMOfa5W/XgybFUvM7co+F0+cLdbIRMLXNI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4597
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10218 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 suspectscore=0 mlxlogscore=789 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2112160000
 definitions=main-2201060004
X-Proofpoint-ORIG-GUID: rekKIasEjWlNS_n95MWIVh5wrBpk0Zig
X-Proofpoint-GUID: rekKIasEjWlNS_n95MWIVh5wrBpk0Zig
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 05, 2022 at 08:53:39PM -0400, Jason Gunthorpe wrote:
> On Wed, Jan 05, 2022 at 07:46:48PM -0500, Daniel Jordan wrote:
> > padata threads hold mmap_lock as reader for the majority of their
> > runtime in order to call pin_user_pages_remote(), but they also
> > periodically take mmap_lock as writer for short periods to adjust
> > mm->locked_vm, hurting parallelism.
> > 
> > Alleviate the write-side contention with a per-thread cache of locked_vm
> > which allows taking mmap_lock as writer far less frequently.
> > 
> > Failure to refill the cache due to insufficient locked_vm will not cause
> > the entire pinning operation to error out.  This avoids spurious failure
> > in case some pinned pages aren't accounted to locked_vm.
> > 
> > Cache size is limited to provide some protection in the unlikely event
> > of a concurrent locked_vm accounting operation in the same address space
> > needlessly failing in case the cache takes more locked_vm than it needs.
> 
> Why not just do the pinned page accounting once at the start? Why does
> it have to be done incrementally?

Yeah, good question.  I tried doing it that way recently and it did
improve performance a bit, but I thought it wasn't enough of a gain to
justify how it overaccounted by the size of the entire pin.

If the concurrent accounting I worried about above isn't really a
concern, though, I can reconsider this.
