Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67B4E571CD4
	for <lists+kvm@lfdr.de>; Tue, 12 Jul 2022 16:35:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233317AbiGLOfZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jul 2022 10:35:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233309AbiGLOe4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jul 2022 10:34:56 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE60126567;
        Tue, 12 Jul 2022 07:34:35 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26CCtVAS022340;
        Tue, 12 Jul 2022 14:34:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=QSZigwN1kKitg+isvFZfGizCi9W47sLx6XXTZKgEmvg=;
 b=Br3zh6wpCj9pSoxSczcxLQgrh55EoZbOwlACBgI5Nnbm7FRg5bwhb9/ND60FEOEZlPq7
 YQnugMgbSjXWhYFJCV+xP91FhTgjIo4mTfhCHK36pfYtWhzrTfhso0+xcl2DtSuElhfU
 eYa1RHC0mecwzHev8k4qBWIy8qTCRo12y5Dta8A8TaMCUV0ZQQULEw7jLqRjstlTuQYI
 Rqv+Rtzp7Zklp68oFBXYjrcxJiUXr+IiFOv4nZQt4Mi/hKHI18Qci7c2RO68ux2sAf24
 D0lbO2pyoMkEt7fMQrkzk0FN/6vUea1q56+G7h/B0QM7MJOyGUvA4q0oxazqDWS+7pdT jg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3h727sf50c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Jul 2022 14:34:12 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 26CEGcVB002346;
        Tue, 12 Jul 2022 14:33:34 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2174.outbound.protection.outlook.com [104.47.56.174])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3h70432sbc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Jul 2022 14:33:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HmNuUQuyG72AR8YbJa/nNbF/5rwoHM3h4Iz7h6fn3UU240CWKYQSZntmrUa6bZNyAm/T38Iwt359RQ5ylYTNNRRIq9cA4iA8BZz5wdDG0QRjJwqwd87SmXFJOslaP1Vi/364+g4lfG7U1xdo2nRFWAM68qGOfD2gpK53TlR9wdZcIaZHvYpU5jAgU/91/qiouaQ6edr7BlDNtDpaQxiQvoJmS3a93gPSXIQkHyKSc3MkJzTF/twsJDuz2ZgRIoN/UzpJwZTGsIHkFoARRvd9KFdv2A/ejLhQy78KG58q0e+64uHI3E+xvKV3CWHt29d6bgoQRRa01bvS8/4Ix4Wgiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QSZigwN1kKitg+isvFZfGizCi9W47sLx6XXTZKgEmvg=;
 b=Vbaz64l4oFqUVkwc8bAyAl3P2yqAXf5WHEkLHaxkhS9hNOq+9low69AA7OO6Sb7yKPEPgy5qMLo7GpBVsIOi4FrtREpKN1QuAvjQrOCRVtqTeEnR3aYvNBoFT7eyLCDhf0s/JBt7JVJqDTBTRfKUEBvYXBk+A0/2HnWOwCdbWHozL6P5pVnc6ksiZoT4Rp8LzEQvsLHJpLR2cYWRX7/CG2kwRzrkr/TuxpHKhXNF3YV/hht0Pwq4ENpDoAnCzx9EG+QHFzssKRIs5i2V3VJacf8jzV+DMlc6xunVEbLFQx/+zElV6xT2uje1h5SyPhCrDuoS4gUGYdP3JcTtBJhp3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QSZigwN1kKitg+isvFZfGizCi9W47sLx6XXTZKgEmvg=;
 b=XgwEXdSW0jQ2KpXke6d+F/nFcxJtJ6aCaIQde4xFXso33WXL67LVQNp2UdIvTebUILfSNAFKLzYZL4So1oI7ViOePNqXpmL5N8iRvOPAL6VP+xYjzvrx33DXnTNFhkx9FL94iTSWur5jDlZ9I+4kZNjF/Ztoiu6cn/6oo4WBFsg=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by DM6PR10MB4059.namprd10.prod.outlook.com
 (2603:10b6:5:1d5::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.20; Tue, 12 Jul
 2022 14:33:31 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5020:9b82:5917:40b]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5020:9b82:5917:40b%6]) with mapi id 15.20.5417.026; Tue, 12 Jul 2022
 14:33:31 +0000
Date:   Tue, 12 Jul 2022 17:33:19 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     kernel test robot <lkp@intel.com>
Cc:     Dan Carpenter <error27@gmail.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        kbuild-all@lists.01.org, Yishai Hadas <yishaih@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Leon Romanovsky <leon@kernel.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] vfio/mlx5: clean up overflow check
Message-ID: <20220712143318.GQ2338@kadam>
References: <YsbzgQQ4bg6v+iTS@kili>
 <202207080331.FTVSHxW8-lkp@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202207080331.FTVSHxW8-lkp@intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: MRXP264CA0041.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:500:14::29) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d9df0652-0b60-42c0-acd6-08da64137e4c
X-MS-TrafficTypeDiagnostic: DM6PR10MB4059:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qDHa+OO9wHhBQ9RCulbKff0Mc2vPj1IBKnCbnXetplrYhmqqKDy2Gxp8dF2QPwfSx16YjzjWVZ+/V5GLd0b6V8oLDjMgtHTG0PovCON10yEdaR101r0GPgR0eRBxipYFsB1ttB/HVJyyv+FaX/hnTokWjURVhQkQmra7ocuQs5Iw9KethaYKw8o9coLcPej+mqwQ9crMpj5p3jd35qgV5CLr69oALZH5aiexTLci1p8J+RdVmr2/e5p46daqgh32BucRZg01m+EzwYFYCio3+LbFQgmbgJg+wQdM+Uk2S+mpv5P4b0vuR0B2dtEFI0vDPPNlQkfnJ/aokWi6XyGtAo8Sy1+ovFaFGhTr7qSgGugsuF1COynJkUyyebkaVS6bhAGr33OgKt/ByNSfeoASf3/Zv6Jw8etey2OguzMCt+MDImFE+L4P7U5iOaLs+PMDo0l6g5CKc2rDeMHhCegdA+LrmVcUIwstp64GDSryg3gphTs62jH2tHJSE8x01NmqILeNw1TGOkmiJcczV24Jsu4OhMZGO917+cuiC7yfKMpDWqRgaGXbvFAcwOrdTM2EpQlFCuVq/Bwz6CeL/8jDZQrfdlmR/qtv1he/OSTRfpVD6/E2DkgSEa7TU2PzqCWMoVu/lC2oFNV7xDwfj+l1st0NEdTGEl4v03VpNzbC6n52ji3UV+6qs5xrYL2HEo2qit58eOisldV0rxXwXjD39Qoi4euCfljiG35G38CjRuG7jupWGVaAJqrLDZTeqStfW29CsHlQj/JjCat9jwsR9U2qsv9X1B0k2KedHScOzU9orR3RSyqlBN5Ex5Tv2yui3vpTvWGKawKbVazR1WigqUmXjvquNIb9LaYiSepEc6Cnl851YN+7+qEng/4phZQH
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(366004)(136003)(396003)(39860400002)(346002)(376002)(6486002)(38100700002)(41300700001)(478600001)(33656002)(966005)(38350700002)(8936002)(6666004)(52116002)(44832011)(7416002)(1076003)(2906002)(6506007)(186003)(8676002)(26005)(66556008)(54906003)(6916009)(4326008)(66946007)(316002)(83380400001)(33716001)(66476007)(5660300002)(9686003)(6512007)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PFp4261S14GEPNR1I0DHtT7LmR7EvA8L7N/ic4AZARLhA859UBzg9K9emDAy?=
 =?us-ascii?Q?KUJyEbenJoXrmmBRYG2Eh4kST3IYDxyuu6C5IXGCXhV++hF0GH6vzwQ93yDa?=
 =?us-ascii?Q?vJz8G6XthydzHh2qd+Dyd3RjAEuds+0paOPsDmdVLReEyIE6Rrc4qgRlb0Gs?=
 =?us-ascii?Q?9gEolU3ktV+WqiBMYWVaxNeJGpT2qfgn8bWbV5EA7ggEohYGB5F29H32J7wu?=
 =?us-ascii?Q?H8R6hkCm2B8q5JifyfNw2poldjaZDKsVuTDJ18orMvPt71JCGNGcl/iQU1yU?=
 =?us-ascii?Q?HJjTDttPQcrxoGfCgz2TcDJ6mQJf4Au0+waEAJ4j06wuCNqWTbHORyBJiRAc?=
 =?us-ascii?Q?Xo+QvkwWYtqObqPOQihsENcWtOjSAoC3hOH8OCAMaVxxQ8kriGP3rUvKX8bM?=
 =?us-ascii?Q?4wwJ0dXoPhwfHNTAYxamwlbNXfRlAVJY+m9V5Lm20MCcHXn9X39/xgriF5T+?=
 =?us-ascii?Q?2mIXY9mIhmbmbqLxXvLF6SHKhy4UXwWq5inbENEs7wZvqRycqsdDKwssgAHu?=
 =?us-ascii?Q?0Vb87FC53Va/jDGG516pURlpycuvsslU30vby7NS5G0fWDX9JUakmT6JvUxE?=
 =?us-ascii?Q?7CgFDCdmkAoDId7ZrWIHhn1LP1UpHTCUGZrU2jCU3eQgNqnVE1gOnCWqlpkO?=
 =?us-ascii?Q?HrkF7vAC0K1w5s3iuPVp/V9kp+NTdxt2Zl0+IuqX1qDi4BqM4GCCdCnotfwR?=
 =?us-ascii?Q?L1xxqnV8aRccMjexlus3BJkys6cfIVUTPKX2tBGwqFFuGgOFrQH2r6Dexhi+?=
 =?us-ascii?Q?yTId0JAf1/+6vhVRyBgXibql2uRil6zN2khBPHwHLr4QeLwx7Zxbl4p1X/P9?=
 =?us-ascii?Q?csVljsrU36V2H141RyKPT0nTrs2v0eURSNcUC3B94nzkXWbrwKENgtg+QbnW?=
 =?us-ascii?Q?9OToNBt/N6HqKDfvy9HMgjRf1DHwGaxMyHoKkbvER9hieXlkFsv741/pK3Hq?=
 =?us-ascii?Q?1wNDMAkJZTgOwgrVRydjIVtOSi1Q5YKX6p9F96nPURuFjVChwbp4IVg2ouW0?=
 =?us-ascii?Q?3zbiXiQ++Qe6DBXchDEJIDVIB8g062R9NLBN0WcRS/ZWu8mBEgKlmPFy1u8/?=
 =?us-ascii?Q?DJsRZf5KocQWGbCh0kMlu4T4DeF95N/4TDhzp1K8QR5M6Jg7vfflwZ8MIYiu?=
 =?us-ascii?Q?HQa4VxJqTXlzi7oCyRtyw5G8PvPMdTw3lakdW96XjZh7nwQvhE3Uc2fQ8l+b?=
 =?us-ascii?Q?eGL6RheKruBOgJZwzX83JYd3N27glxznLI35YNWyvJwUCS/NLKKlSY5/dc9t?=
 =?us-ascii?Q?YW3Pu0XTiAJO18pHfESHjDphohBSsqXpsvEY3Hq/qpHNzPPbWbJkAujFBsgQ?=
 =?us-ascii?Q?r0v/Le4ybIxTdR3PakRQqhUO+hT6RQvHO06pvq9TICPENFNBiOVfJ/WHLfAq?=
 =?us-ascii?Q?hxZVdDxC5Gd8Cbs5AJ8dMBo8WpSQwaCR28kc7wP6VF72oST0k3Ku/EwOMa57?=
 =?us-ascii?Q?SPQZiolvu1ZMRBtdHl60bPMgovOQU1uinyYMUlvFZdl8fIEdywfMpf08zaN6?=
 =?us-ascii?Q?DFgU6qy47NTgj0pOmcv39dvT4wsA1ZpXEXKKvDoLTqmPsxXG+MUmlda83gZF?=
 =?us-ascii?Q?daX3kUZXHQNvGMCIsuG59ZHGlIvVmuQ9UWTdoVtwLGivaPSsHQAroCwDVdei?=
 =?us-ascii?Q?Gg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9df0652-0b60-42c0-acd6-08da64137e4c
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2022 14:33:31.4488
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Bnma7jdngo7Hzym7/3CpP2idjyu0zhjPtLz8PhaaF2V+E+vNQQUDaV5IwJQ7RJ49cHYsV1Gx3Bi6kCriz3yZA8rXW8PoK+loiCzCHC+FJmU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4059
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-07-12_08:2022-07-12,2022-07-12 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 mlxlogscore=999 suspectscore=0 adultscore=0 mlxscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207120056
X-Proofpoint-ORIG-GUID: ZoWtc1li90CmvryBCoJWCJ1F2RZE7KaO
X-Proofpoint-GUID: ZoWtc1li90CmvryBCoJWCJ1F2RZE7KaO
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sorry for these!  I need to resend, of course.  I'm sligtly delayed
because it was a three day weekend.  I will try do that tomorrow.

regards,
dan carpenter

On Fri, Jul 08, 2022 at 03:37:32AM +0800, kernel test robot wrote:
> Hi Dan,
> 
> Thank you for the patch! Perhaps something to improve:
> 
> [auto build test WARNING on awilliam-vfio/next]
> [also build test WARNING on rdma/for-next linus/master v5.19-rc5 next-20220707]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch#_base_tree_information]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/Dan-Carpenter/vfio-mlx5-clean-up-overflow-check/20220707-225657
> base:   https://github.com/awilliam/linux-vfio.git next
> config: i386-allyesconfig (https://download.01.org/0day-ci/archive/20220708/202207080331.FTVSHxW8-lkp@intel.com/config)
> compiler: gcc-11 (Debian 11.3.0-3) 11.3.0
> reproduce (this is a W=1 build):
>         # https://github.com/intel-lab-lkp/linux/commit/44607f8f3817e1af6622db7d70ad5bc457b8f203
>         git remote add linux-review https://github.com/intel-lab-lkp/linux
>         git fetch --no-tags linux-review Dan-Carpenter/vfio-mlx5-clean-up-overflow-check/20220707-225657
>         git checkout 44607f8f3817e1af6622db7d70ad5bc457b8f203
>         # save the config file
>         mkdir build_dir && cp config build_dir/.config
>         make W=1 O=build_dir ARCH=i386 SHELL=/bin/bash drivers/vfio/pci/mlx5/
> 
> If you fix the issue, kindly add following tag where applicable
> Reported-by: kernel test robot <lkp@intel.com>
> 
> All warnings (new ones prefixed by >>):
> 
>    In file included from include/linux/device.h:29,
>                     from drivers/vfio/pci/mlx5/main.c:6:
>    drivers/vfio/pci/mlx5/main.c: In function 'mlx5vf_resume_write':
> >> include/linux/overflow.h:67:22: warning: comparison of distinct pointer types lacks a cast
>       67 |         (void) (&__a == &__b);                  \
>          |                      ^~
>    drivers/vfio/pci/mlx5/main.c:282:13: note: in expansion of macro 'check_add_overflow'
>      282 |             check_add_overflow(len, (unsigned long)*pos, &requested_length))
>          |             ^~~~~~~~~~~~~~~~~~
>    include/linux/overflow.h:68:22: warning: comparison of distinct pointer types lacks a cast
>       68 |         (void) (&__a == __d);                   \
>          |                      ^~
>    drivers/vfio/pci/mlx5/main.c:282:13: note: in expansion of macro 'check_add_overflow'
>      282 |             check_add_overflow(len, (unsigned long)*pos, &requested_length))
>          |             ^~~~~~~~~~~~~~~~~~
> 
> 
> vim +67 include/linux/overflow.h
> 
> 9b80e4c4ddaca35 Kees Cook        2020-08-12  54  
> f0907827a8a9152 Rasmus Villemoes 2018-05-08  55  /*
> f0907827a8a9152 Rasmus Villemoes 2018-05-08  56   * For simplicity and code hygiene, the fallback code below insists on
> f0907827a8a9152 Rasmus Villemoes 2018-05-08  57   * a, b and *d having the same type (similar to the min() and max()
> f0907827a8a9152 Rasmus Villemoes 2018-05-08  58   * macros), whereas gcc's type-generic overflow checkers accept
> f0907827a8a9152 Rasmus Villemoes 2018-05-08  59   * different types. Hence we don't just make check_add_overflow an
> f0907827a8a9152 Rasmus Villemoes 2018-05-08  60   * alias for __builtin_add_overflow, but add type checks similar to
> f0907827a8a9152 Rasmus Villemoes 2018-05-08  61   * below.
> f0907827a8a9152 Rasmus Villemoes 2018-05-08  62   */
> 9b80e4c4ddaca35 Kees Cook        2020-08-12  63  #define check_add_overflow(a, b, d) __must_check_overflow(({	\
> f0907827a8a9152 Rasmus Villemoes 2018-05-08  64  	typeof(a) __a = (a);			\
> f0907827a8a9152 Rasmus Villemoes 2018-05-08  65  	typeof(b) __b = (b);			\
> f0907827a8a9152 Rasmus Villemoes 2018-05-08  66  	typeof(d) __d = (d);			\
> f0907827a8a9152 Rasmus Villemoes 2018-05-08 @67  	(void) (&__a == &__b);			\
> f0907827a8a9152 Rasmus Villemoes 2018-05-08  68  	(void) (&__a == __d);			\
> f0907827a8a9152 Rasmus Villemoes 2018-05-08  69  	__builtin_add_overflow(__a, __b, __d);	\
> 9b80e4c4ddaca35 Kees Cook        2020-08-12  70  }))
> f0907827a8a9152 Rasmus Villemoes 2018-05-08  71  
> 
> -- 
> 0-DAY CI Kernel Test Service
> https://01.org/lkp
