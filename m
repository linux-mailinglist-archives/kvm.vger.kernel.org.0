Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A649528B77
	for <lists+kvm@lfdr.de>; Mon, 16 May 2022 19:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243906AbiEPRAV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 13:00:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344022AbiEPQ76 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 12:59:58 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on20610.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe59::610])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41DFD195;
        Mon, 16 May 2022 09:59:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XgsfVUhWBdNM+b5vsHJA4gJozRhYW+CC5q2mF2oZd3OJd/8gzgurSKU/wtIpBGUnsfSt5rZQ0JCVV4Pp1TMa3t7kE/NckLATs3HL4icdqc24fCkLzQmU3b5qEUokNhK0tOHs7wXnb3tBxE0TSvoz28PE2+eLeb+dwJ2bt8g/wOj34wzjas1+oNNM/deRrJFLjTX97QV3tmUH0X7yUgTl2vDoAquGZpQ17M/EbO0zffkTygr+NDHEGRBx8KGdKCuqwRq+YMgXsSruY1gngxYCu20z482otNGuXPib6K8DnjZbkA/9OVIjRhqhQen1fLJYtSgesaXDtxHJKTikU3sT4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2mAOYcMq8OCkJgkd6R3Q8j7itX5XE6KWxYNsDJi8A3U=;
 b=D4B9+lNslT/7qyTL5hcqFNJP+H+LUVG+1PcH9smQJ5Wrno+5TMrMGrDh9+IPG+jaF1Kg2oJ+HzsfqJ8Qc1MKth+Om4bpAjwKw4JHYi11t9Eb4PARyEJXefAakkukroxaik2cmvzFs17wYf2C04C9dLcX7p3qf6qCqz76vHY7Ju6qh0tMkDlbgJ09LDdvzVYxHop1G/O3qZw2JDAL0gz2n0Hlyxl3i/lnHUzuKAI9i4U3Bd4B/Wo4gm0mkTuaOo2o5i4O5v9UgH8Ldbe7zsuI+P09RctBpf1D2bdYE+MhppE5D03whaalD5ZdwoeoDHIpZfS4mac2meyDdceFVey0Jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2mAOYcMq8OCkJgkd6R3Q8j7itX5XE6KWxYNsDJi8A3U=;
 b=evkOy4jS45nIuifpi+LH1eoEXF9EuYyK7zWPSz43bU0xhSvoqL34iNtHt0Dp34/5LGXLL26WhUWwEMtHRl2qvBTAr7xHx4UHacrMHhTv+t+U34sK8ThAnk3PVpV44SdS6XICQrRu0pExvHBIHSZ3Fd/zUifLc6XbKj2/x1+2oloNkVYXaqyNpig7kVEXsaFD6AYEfF+GpVCMGGW9q96+g163eicfFRVtX9Jjzg9AXLv3uUIsqU1N29xUcokJSfOvZetfRGWZ1F9qahlbnMRH5ApmXgj7drcLMg2UvIzPebf3j1V7vYo7Eh0hzCT2OjHHYRTGGuNa78uXin85MSyVwA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by MN2PR12MB4048.namprd12.prod.outlook.com (2603:10b6:208:1d5::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.14; Mon, 16 May
 2022 16:59:55 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%5]) with mapi id 15.20.5250.018; Mon, 16 May 2022
 16:59:55 +0000
Date:   Mon, 16 May 2022 13:59:53 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, alex.williamson@redhat.com,
        cohuck@redhat.com, schnelle@linux.ibm.com, farman@linux.ibm.com,
        pmorel@linux.ibm.com, borntraeger@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        agordeev@linux.ibm.com, svens@linux.ibm.com, frankja@linux.ibm.com,
        david@redhat.com, imbrenda@linux.ibm.com, vneethv@linux.ibm.com,
        oberpar@linux.ibm.com, freude@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, pbonzini@redhat.com, corbet@lwn.net,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH v7 10/22] vfio/pci: introduce CONFIG_VFIO_PCI_ZDEV_KVM
Message-ID: <20220516165953.GD1343366@nvidia.com>
References: <20220513191509.272897-1-mjrosato@linux.ibm.com>
 <20220513191509.272897-11-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220513191509.272897-11-mjrosato@linux.ibm.com>
X-ClientProxiedBy: BLAPR03CA0021.namprd03.prod.outlook.com
 (2603:10b6:208:32b::26) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8b8b77f6-9825-4ce8-69f1-08da375d8039
X-MS-TrafficTypeDiagnostic: MN2PR12MB4048:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB4048813731FB90F24141E61DC2CF9@MN2PR12MB4048.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k0k0fj8D15z+WxHT3yRyaR3Nhn/B2Jfn8PdvbHrXOSOs0gG/hyrNHuvXyUyVAdiWnhViecOcFtpPb0ArR48C5T7Yc9ieHp5osCG89UVBV+qLQAj73sCyDxu6wOoJTx80OAgYoMHzEeFxLDqtilv2kbeEFgMMGe2cI1Yc9sjZvy6PEldoUzk+vbuOIqqh1IZTN/LbwU7svzEpQt9pnelbSkuCr2fUmv+lWeWtZo8PA4fFtA/emcyDM5BZOzvcwP54HpbIM9KS1N37vXyO/KW4hGLQC6bENjhGv69GXU/etK9KnyompH0STwMePdyVWbaQz2P8dFSG6pYJPvlp2HDusH2hQKhvcD7hhqh8SX82kPyWP89/bISV7/i5s0XdpiSTUfFInom2eJTcG14OleJmOI9wM4cmYJB5GFIXcVBQkievt/gfwikqnYmf11sGSRuvlwM62WvqtPACoP01XAi2qoLgf6DjEe8TmYlPtBIMtabXySPjFDr0VzEe30WMGkISfRuve1vbe5+1s2XZq12+GV9xIViEfOEJNTa6pwp1PU6B64s8PodoFT81bwzb3ZZH5ZJwwgJKayu6zJQPEBrxBCgxUo35h1wiA3QGMJTLHI2T59S55EdksJV4/gnPCZ0G8Rbt9LycCtHxApBbvb6iRA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(36756003)(4326008)(26005)(86362001)(38100700002)(8676002)(6916009)(2616005)(186003)(1076003)(316002)(6512007)(33656002)(2906002)(5660300002)(6506007)(4744005)(8936002)(6486002)(66476007)(66946007)(66556008)(508600001)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1DpdXgoaar3TJ4I0Bb0PivE32YDWg71B3vVH5Ii+aIfp+GophRDUkxEkH6ZL?=
 =?us-ascii?Q?uy/OgGzIMsgGDp42kmbiwS/9RN/P7qIqVOi+Ph35Ckqwsy0vyfMYMOC5sGuT?=
 =?us-ascii?Q?aA7+jcI3fkVF0tLB/R8m7CrgKIN7P6hibjCuFQn2qhYX76TOOvZvH3HSCpvM?=
 =?us-ascii?Q?l3I5tdCaIxTuomOinLEXKIkDQwHUD+zjafM5BdHG9WaiVQcdca/bNBhQfbqu?=
 =?us-ascii?Q?gsubhjAiY/ksmXd8Pmfzd6E7uGm/WYLnRiaDWiJreNpYj6CVKLFdJqm9zNaX?=
 =?us-ascii?Q?spdZTwGwvBQagP2UaCfgcGSb5zSh1+t62LoILbtvVyzP4t05Nnd2Ln3BuDPN?=
 =?us-ascii?Q?5yqr3iiUkXp+31U34+S5rdjSJsRXUTNI4+JHzWI0Nzk7z0fsK7HR6ELXKpqK?=
 =?us-ascii?Q?wkqRT4KBCqImz1jseu3g6+5REI41JTvSRp6PQcBTGYI4Y3wD3WSX1PIR+QTj?=
 =?us-ascii?Q?hl436D/DVXLFwydaOvxrzJWWbGb30JPcCUO98bSosmpDlNK/N5b9/hRVGwew?=
 =?us-ascii?Q?Q29o67jF+5WFLq6cHKSCAifLaEb2/A2EzZDdWsmu/A8s03y0Q5TvT5T1nBFm?=
 =?us-ascii?Q?y7JZUunpd6APObfQYo6CyKLy1Qvdko2gKEaQeQ+ouPjZCGCED5EHq84NjSjG?=
 =?us-ascii?Q?v/35cXQzwx86TkWZqCfwP04C0FRZJ9WgCsYM86U5ViKgf2kT93Rf0QDabwlk?=
 =?us-ascii?Q?ue1b9OPWBJe8uk9i9It9fSAdli3rfPE8GNqisc/J7jx4DX85b1QWd7w7Tb/9?=
 =?us-ascii?Q?mla0G7ZQ3IimHBSGHquXtWOqGXQh/0SVUE0dSDM00sjgN3wcbJIEaqglWysB?=
 =?us-ascii?Q?o/NIcrUOYuPR7wqeZIY23NztLxtOn4rRMj4Ya0ciRS0EyTKvQ9/2poGuBd2L?=
 =?us-ascii?Q?sRpj6+E1dt/T/qnxiE1Wk9zdxAS4aQvm0VYl2UsBYKBOlSeaXXHpE4wIu8wq?=
 =?us-ascii?Q?flIH+YRQo2aNA70xPW6oa/Upkx1g4e12nSDDjpgdoND4wTt7MfJZ64JSCIni?=
 =?us-ascii?Q?fKeFIFNosQw14U2GzZZ9SchcCotyoq/T1ZJ3k78LPYLawHSSjFN1TkzOX8+W?=
 =?us-ascii?Q?3XLpzcUq4hpcQERM4/RVxSNSnsiMfGGjCbPprFVIsfXkIvDNFeb8OROhxnYC?=
 =?us-ascii?Q?6PfOshByARTs0sX7Ma7v0XqWSpoJkvbLaJhR3cv9VRhNzW4R3DN0Wn3BUhE9?=
 =?us-ascii?Q?1Kflnjbcok9UDSWe+kI/68b9+Qfe3bY4rRbHo9O/Yx3RrFCzrgyi6YRJmI2B?=
 =?us-ascii?Q?YnL0jyrce2oBm8RiZ/H3PGeZSvUUnf1bHV9JYSlvW5+oFYKmBT647W9CAQuR?=
 =?us-ascii?Q?v03/1+3WqzenoP46h5NJKC7HhEyd7UFBoW1tRsHO5xAwtXOSBsN4G3uyCqWm?=
 =?us-ascii?Q?3OHy2i+RjNRSTZmYcVOXRzPGwvOpKd2JCyjLSG2xRhYZq34+fub3YSMxexX2?=
 =?us-ascii?Q?kJib9YAl65wzIAQLMGH+DaJLD4pKHOr+dFQliDDAuwaxEVWLXZR5dqQXO4rO?=
 =?us-ascii?Q?6GfI6BYf59twdCRpiSt/eoFz3YM4TkgFPcR+9u/RQkf7N8hhVKA3pCzIxu7r?=
 =?us-ascii?Q?Iu4uxExYlyuydZOZfbXF2FnT+DtmhYmIZmQLsHvQaAHRPflv4y2RsH1559gn?=
 =?us-ascii?Q?PkOoK8Rf9b73y//vblSTR1+3Tei74AxOEyrWAJ7Xi4nDmflE3e7wrNN0GaC0?=
 =?us-ascii?Q?JKLHDMQO3ZfmFWgS4hsJ2JH9bkWdOT2g/Z5e/lEaM89LUIofxOHw62wGDNrX?=
 =?us-ascii?Q?w8Zo8cuQ9g=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b8b77f6-9825-4ce8-69f1-08da375d8039
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2022 16:59:55.0485
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t6K2i9C2ngFJuacYchhH9LeOOqs3l1psLUgQkuLZ3KZyUTbJS3yG8y81h4Cs8Tv2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4048
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 13, 2022 at 03:14:57PM -0400, Matthew Rosato wrote:
> diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
> index 4da1914425e1..ac1290d484e1 100644
> +++ b/drivers/vfio/pci/Kconfig
> @@ -44,6 +44,17 @@ config VFIO_PCI_IGD
>  	  To enable Intel IGD assignment through vfio-pci, say Y.
>  endif
>  
> +config VFIO_PCI_ZDEV_KVM
> +	bool "VFIO PCI extensions for s390x KVM passthrough"
> +	depends on S390 && KVM
> +	default y
> +	help
> +	  Support s390x-specific extensions to enable support for enhancements
> +	  to KVM passthrough capabilities, such as interpretive execution of
> +	  zPCI instructions.
> +
> +	  To enable s390x KVM vfio-pci extensions, say

"say Y"
