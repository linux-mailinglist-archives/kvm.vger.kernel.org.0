Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 526163E0181
	for <lists+kvm@lfdr.de>; Wed,  4 Aug 2021 14:59:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236668AbhHDM7Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Aug 2021 08:59:25 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:62382 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237494AbhHDM7J (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 4 Aug 2021 08:59:09 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 174CqeUU025161;
        Wed, 4 Aug 2021 12:58:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=ObKzdFrEpBpT3EOP6MIiXJOpYEyfg58oH6kKupYc2J8=;
 b=EBX7/mt2H9RrqCdi0SDSf4/XZN/qzBiS3YXSqKHiREvfyO/o/AKl0EZ6eKj4Kv3gkyv0
 SS3mqNT3b6GsZsewUXwfsZvsjUrT7y8yMOyv6aRdenUs27oedi+ruoklOhZSCL1N50N5
 WGQ9xU6KvcrbGC5qPD8GQwqjvCOPXUOIB8MUugPjr7s7XV5mNalErKcwvyA1FSDv7rBR
 y21Wa624n7Cb4ov8cRa7OGBmF3TDbMSfPdPCLKJ7MzxKbk9KuSgb2+6h1wMVhvDD+dT8
 se5Dbvs8/oy8UK3obBRLahwjNZdzbVevOfznz9PZldWLwkUc4f3ixBY7vy2OegBmtTZw IA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2020-01-29;
 bh=ObKzdFrEpBpT3EOP6MIiXJOpYEyfg58oH6kKupYc2J8=;
 b=iMelQUuz0GDcFnQ83/SfdIvI3wfdQqmRIZ8mC7VbykwXm4jIirxYnUfOJ04FFdbvBuEX
 lG41+u+Zq9rK+9NW91i2mFLfsG38Bib8ZfULAjihWYyTwa05np/LwqMzsKyw1GZwrvp2
 qOQ+KH0C8OdsvQgJYpDhrlM5LL5uEm41O74lV/x57OeLos9MLPD8/94rOt89vM7n8EXz
 cexZRmCbKZuh/QP4UUZaIcpSN9Xfwr7Aes2hXwx+A6ec6BtQHcT9NgzZ4jTXKSZECL7T
 iMDgVfskDXZ/liPhJ0vSD03drWIsX1/b7GqJplWN8kssQGAouatap7hjx4ElyGWtVH3b ow== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a7hxph612-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Aug 2021 12:58:54 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 174CnwR9089217;
        Wed, 4 Aug 2021 12:58:53 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by aserp3020.oracle.com with ESMTP id 3a7r47sbqn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Aug 2021 12:58:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XuzUtIWeOnxohCt1LIt5UOgttGe5eYFu8M++n9RGGUFFr6EfOmOHFDAXThNhHrsAZ6YncpB3jXAEFYt/AiGTjx1rwCrOmlvXYvjrhJ21apEz2mipQOcCU3hvwq/qW2vtl5qMTRwe0wTqZW1aM7kJNDLdxlVQb16QI3c8l2FdJ5ai0yLlwPEugEalML/ylqlUrT7h/TBgRMM7LQk/zBztQvXRo9GzrWVpX5QRkxJGZ4nn6s6yyR+WwpHh6s7/vbPOvYtbuyTSjkeUbDGVb/113PJpa74+Ug6dol77DRNRlwSAptE2qp9XAIRW/Lz+p1cxzLZ3enB8ETCJjid03oRKsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ObKzdFrEpBpT3EOP6MIiXJOpYEyfg58oH6kKupYc2J8=;
 b=Au3P+rCy4//SZsfuJSHCfFOTxKyo2YgM4fbHGzPEqh8/sVqsDSqYvpHotGKLLLHfR136kOj25qMNZs+wB5JlmCrL/HQfE4jEgQme+0Ytvt1WpgHBjpn6/3QQ/Z4C9F0P0DSa281yqbYQZ7cKQbEZbp1SYro/c6CWioVgPzj/OBWCsaFe9mRNu2Ela2CszYLdR3MAD2DwRsQAK4H5yTnNdBGSMyNsXCQsBHWGyvopW6AX7TC+H1tNV9kpl6k5x4+6Xxy8uUsWAs2ncVXv6XgV9U54WuDjWM9DMhQxm4XqPtdGI0BjaT7TNHbRFPrNFQuxe6AyjN15Nj39wDEE5sfOYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ObKzdFrEpBpT3EOP6MIiXJOpYEyfg58oH6kKupYc2J8=;
 b=s4lehpdIHgaMy+xx37E4Sj2b+d1t5DSn9yfbnLN0puuLGGR+hZfd30sKuebuPvkWnqfT2gbGPILeWLb4ifl7BMzHIdAZDSkvxoyzyjVlZFtzuXAwFCpL/1Xh0Z7pHE4WcnvEPk28Yst65UhG8cjvB/oayZACYSbF+SMALC4y/XU=
Authentication-Results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR10MB1376.namprd10.prod.outlook.com
 (2603:10b6:300:21::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.16; Wed, 4 Aug
 2021 12:58:51 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268%7]) with mapi id 15.20.4373.026; Wed, 4 Aug 2021
 12:58:51 +0000
Date:   Wed, 4 Aug 2021 15:58:34 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Joerg Roedel <jroedel@suse.de>
Cc:     kvm@vger.kernel.org
Subject: Re: [bug report] x86/sev: Split up runtime #VC handler for correct
 state tracking
Message-ID: <20210804125834.GF22532@kadam>
References: <20210804095725.GA8011@kili>
 <YQqKS7ayK1qkmNzv@suse.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YQqKS7ayK1qkmNzv@suse.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNAP275CA0022.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4d::8)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kadam (102.222.70.252) by JNAP275CA0022.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4d::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.21 via Frontend Transport; Wed, 4 Aug 2021 12:58:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2b806f3f-bfc9-48ad-5daf-08d957479b78
X-MS-TrafficTypeDiagnostic: MWHPR10MB1376:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB1376CA7193CA76D0AC25E4588EF19@MWHPR10MB1376.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vxrC5UZ0efbARrymHZIrWwc58qaO0oPnlFhEftzeed5ao23+wTY1DcaCszZWUC9j+MyQXeYjj6gCtcm7xr/FDUPdkwFl7IDpPePquNoHvmLh5A5jAoPx/3Z6xjzlxKI/3Ld4I/2r7xN3MoEklaUKP89gn8/bq+8uQpmfrSjzGe4DXfRZAYflyKQEmmlC0miVZxUacnn4BfFv5KM5WAHuVc+17veSwFUWaoUPMy0bcGNOYk8JC3mrl/4F+HIQRz3jWLUrIY6g718G8/KVluFhy3Z7NAdfUHT6tg6TtOrWdSCfaXyj0HPgSSF7GL+Iyv41tX3FBJIaCxOLiT5tB39M4dMQpnNyFpCRU5PrOY9xTg1G4mYPO1YpJG24hCo0mp64oMfLQXmTLR7i2SmNIkULlEHZwGyUUQqQN7JtjAidmWAdNQ6L/VRGXcz/4/N4g9+aXyF4ykAVhEDwfCZKNVfDBONFkdqtSygInEc99YA8KUAjXc3blp3CzVEnkRqs1rxpt9vtEMLaxejoV+oCqeVIrWuL49LP6qLCoqVo5tdvbFVefP7cYp633ugLXaqC3CCNNhW4jk1deHEo+L6/W8QWLccxqrJVzkTqEO1Wzdo4iy83suKkQNnTpZQ/WIDyjRSn8MgyEAh4m/GtgK2DHNYVADjRzeaKxfn2FRlSRKO6kKle2umDM4uv4/8x0bLKiEyWsWJKQtbwDvUprNSOwHM1UQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39860400002)(396003)(376002)(136003)(346002)(26005)(52116002)(8676002)(4326008)(8936002)(44832011)(33656002)(33716001)(9576002)(316002)(186003)(2906002)(83380400001)(38100700002)(38350700002)(86362001)(6666004)(66946007)(66556008)(66476007)(1076003)(956004)(6496006)(6916009)(9686003)(55016002)(5660300002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZxB4vjHa9MiMRAkYOJ2Mkhok4/GNkvelUv+4HmyKRi82i9a4jEirKh7/VtlX?=
 =?us-ascii?Q?xX2+ngjO/vqDUI9gxd3e54b6IaY8kRsjvPHvTNeRVE6dGPp2D6iddDkmkpW4?=
 =?us-ascii?Q?l8ob2Krq7q9/5c6t91OTSwkySgEkcJQ7Qb4A+7r80x4sl/pyV92NxUNhdaIK?=
 =?us-ascii?Q?IkYs5qRF+o01+BIz0PcIQgO3dPzzWgfxbmyiO7vU+sZVTTkNB2IaaaklY06a?=
 =?us-ascii?Q?J6JYu5i55yOWC626/2Qy4YLwmKnsjVnm85zftosCCEJO0DP3PDl8wxlKi+Lz?=
 =?us-ascii?Q?bDRgMV1ixyf4fB9TgLzUh/ZK7YufeC9u/uGV/vmY/hHp8WYg4UHFRD3k3U3A?=
 =?us-ascii?Q?qYhrvQvTeRpXr8dinVNpAioWd2VWYbsbyQHVWhCcIXzt8s6UFNSHmNfLFjh8?=
 =?us-ascii?Q?iWlgovFHlb7kp2WL/bUJWsmxldqbUMolB+aY3c7zgcv7HCAi8ehuv+st0SEn?=
 =?us-ascii?Q?dVuRfaQ8h5PusEC8SIVWCOiiJ57gf9KBFzOVjJ3rIORLbXykAqfH9qeqMNr3?=
 =?us-ascii?Q?itFQUa3rkcopM/WGICORQ4/X16iilO+n/QZ2fKjsGf02n+KDpNADt2sL0gxt?=
 =?us-ascii?Q?jQR6l2AOd0sSjwD0BqFKOcPIvOGlCA7ha+k2W7UvVbpFI5eK5tqeUrQeESX9?=
 =?us-ascii?Q?jSmK7CI+LLBR+sAcwrqpwIT0/xdVvKPahOZvxMJmYNdxGsQzEXMFVmm6RUOm?=
 =?us-ascii?Q?x5+JLcFJ7PzcBDQYaU+mZjsxQMnUVFQAelKfzWyL4IfEC3D2KLgqOBQ+KMil?=
 =?us-ascii?Q?PyRy4Sac9qartrcMO+qWC5RhH1ifhrZIpzCqyOnMhUVMeneQUUDbIG3hzCj9?=
 =?us-ascii?Q?F6Ld3lzpI4ql9iJEt4BNcbU2T75PEBsbrVCu3Ku0JlqQjxxqwYcNU3YD1gAK?=
 =?us-ascii?Q?7uXJFiQp2ZtYlgrLCj3DdZEQLoF3rQSpaYmgMe5Peie/phGwmK9xNyOstO5g?=
 =?us-ascii?Q?cet8fKyK7Q1L+5gVOhJ2tczu5WZ7VSevdDNagdwJzc8mbnb3FQQbi/F5C5gv?=
 =?us-ascii?Q?eAUjG/7XuUyzXe046oNiZcCfYyw/Bb3vOqo//7U95k9nkjqET2LPsQCIxFQA?=
 =?us-ascii?Q?D4LMxqqbj/rw2NdrQsQV2Ol7XEZJBJP1xa6lpO6GJDMS1gjiaJEZCwpvXceC?=
 =?us-ascii?Q?BqlHzFL6vTPgehWiENytv1MZQvaTAjH+rUzJjLrLHXlxbpvNwKnmOkY6jJje?=
 =?us-ascii?Q?ZT8odMAro/jWVXxixjdsofKjFvblKLGcetFuqkqCDv46mL7f++fGN3fLmE2e?=
 =?us-ascii?Q?8RjJtxkX150sritXnWbaPluK5RyULUtbgeEJkeDbWWJJ/a8KoaNbGj89dCjf?=
 =?us-ascii?Q?Nsi2hiAGJt7XgZbS+X201pAU?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b806f3f-bfc9-48ad-5daf-08d957479b78
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2021 12:58:51.6724
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zQu8CztZcnBlSqs4xJsCt+8TZC2QRY2jlAzZHzx7zni8a1PeKttHK4Y2r2J8uiHZh8vwJg93X8aNqt0Et/S3pEWYnMStnUoUno88khYYBJE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1376
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10065 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 adultscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 spamscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108040068
X-Proofpoint-GUID: X12jKzFNpJarZTDRn9gQtYeZaTM5bQmI
X-Proofpoint-ORIG-GUID: X12jKzFNpJarZTDRn9gQtYeZaTM5bQmI
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 04, 2021 at 02:38:35PM +0200, Joerg Roedel wrote:
> Hi Dan,
> 
> On Wed, Aug 04, 2021 at 12:57:25PM +0300, Dan Carpenter wrote:
> > These sleeping in atomic static checker warnings come with a lot of
> > caveats because the call tree is very long and it's easy to have false
> > positives.
> > 
> > --> vc_raw_handle_exception()
> >     --> vc_forward_exception()
> >         --> exc_page_fault()
> > 
> > Page faults always sleep right?
> 
> No, page faults do no always sleep, only when IO needs to be done to
> fulfill the page fault request. In this case, the page-fault handler
> will never sleep, because it is called with preemption disabled. The
> page-fault handler can detect this and just do nothing. The #VC handler
> will return for re-fault in this case.

Hm...  Ok.  Let give you the rest of the call tree then because I'm not
seeing where it checks preempt count.

exc_page_fault() <-- called with preempt disabled
--> kvm_handle_async_pf()
    --> __kvm_handle_async_pf()
        --> kvm_async_pf_task_wait_schedule() calls schedule().

regards,
dan carpenter

