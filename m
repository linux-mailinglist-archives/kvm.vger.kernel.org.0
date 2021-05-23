Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2710838DE27
	for <lists+kvm@lfdr.de>; Mon, 24 May 2021 01:47:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232130AbhEWXtE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 23 May 2021 19:49:04 -0400
Received: from mail-bn1nam07on2061.outbound.protection.outlook.com ([40.107.212.61]:22443
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232041AbhEWXtD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 23 May 2021 19:49:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ClCCzkR0lslEdXBZxmDDozfKjEn8rp7REWo7EK5moZHHoqvmFv/tWAUAhCzw/vX8FwRVCb6UXj+YdpycSYfvmvuLTsppn+/rVZTRrbt0l6UsDdQSIuLjLZOchDE97EhgB0mBEXP2AFhAImfvaBEO8GINorPifjLS8eANSzRl22nKoBo15Yu/g2X9Zl/9DocPWu8xfQiFxrKPpzirG8GOBlwPuroDXgln1WuaeT/Y72YGA2zyT5EoRcGtBJ43zCQ3jZomzLQvUkU4X4Bv7gPkR5ROnWWsEvG9fVTScK7F2Q8gi82ZxzMFsdKshdmwsQ1JWPiem+1sT26doSPC8THI+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8U5OCyrnryxLkXz43GPL1Y0/ktO95Dgzq4JA56l06KI=;
 b=RIVCOUpmYyfff9AOKLvjy31YPtHJKz4xEZ2kAbi/5BD3EZJSB50imfnimZgxqjotSmS5zZuLdiEFeSjPRZWdERLxwgANVb296ZeWaz01tmGfNhCc5/G54wYFfw8luy87ya1Ie/VhICCYg+kjXWRLSGHgYRFcXkUmlH0aI/IoIr3j/SRxTKXK64E2Clm3WPZxx6nACJTcbvg8A8dC62ZJl2910QMjF7w6w/NCOwFzUU6Z47nK3UG9Y9MCleordO1kZJ8UKYsPtUhbJx8zmDPDZJX+c+vHlwoF4QM4SkJTPkhKrT7eSYQ1fdHHstMmaWMuir1+xkjQbBLn7trmDbd3XA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8U5OCyrnryxLkXz43GPL1Y0/ktO95Dgzq4JA56l06KI=;
 b=rE0DY6zynnWC7TDviJEZTvIXH0KitJK9B6miggiQmdLTLVwBaAjQhZ1WIfOM0pqbUMGRMGbX3C/c03lwUr34/0EWvDi3/CRtgaLPYrrqWXPdJhHtoIGl0hQMco6jeDcD7th4jwLSJIrIKDYGr4Y9VfyFQanBeGrXou8Nb2R2EsRaivFki3kJ/rdcm7Q/jw/p+BuXBMXLWy5QPzKcGAWk9HnAFRKXPoSFU7mnzAtyV08ndbM8TXbD6Dz8b1GpO/HEVcNi0MQLhWpsVtBseJDpo//xHIvIjNhvh7qpxQFWqDxFRj2T+gi+Z4UWT2i3uqTx+5tDJDq21Uitzt/KJOuvdQ==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5287.namprd12.prod.outlook.com (2603:10b6:208:317::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.26; Sun, 23 May
 2021 23:47:35 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%7]) with mapi id 15.20.4150.027; Sun, 23 May 2021
 23:47:34 +0000
Date:   Sun, 23 May 2021 20:47:33 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Dave Jiang <dave.jiang@intel.com>
Cc:     alex.williamson@redhat.com, kwankhede@nvidia.com,
        tglx@linutronix.de, vkoul@kernel.org, megha.dey@intel.com,
        jacob.jun.pan@intel.com, ashok.raj@intel.com, yi.l.liu@intel.com,
        baolu.lu@intel.com, kevin.tian@intel.com, sanjay.k.kumar@intel.com,
        tony.luck@intel.com, dan.j.williams@intel.com,
        eric.auger@redhat.com, pbonzini@redhat.com,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v6 14/20] vfio/mdev: idxd: add 1dwq-v1 mdev type
Message-ID: <20210523234733.GK1002214@nvidia.com>
References: <162164243591.261970.3439987543338120797.stgit@djiang5-desk3.ch.intel.com>
 <162164283194.261970.12689960276759011457.stgit@djiang5-desk3.ch.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162164283194.261970.12689960276759011457.stgit@djiang5-desk3.ch.intel.com>
X-Originating-IP: [206.223.160.26]
X-ClientProxiedBy: YT1PR01CA0062.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2e::31) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by YT1PR01CA0062.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:2e::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.27 via Frontend Transport; Sun, 23 May 2021 23:47:34 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lkxoj-00DUyr-7S; Sun, 23 May 2021 20:47:33 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ebd090d1-5501-418d-038b-08d91e452378
X-MS-TrafficTypeDiagnostic: BL1PR12MB5287:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB52871A503147474013EF3CA5C2279@BL1PR12MB5287.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:923;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wiUcHBqU89Wk+iEsAHjnK1zOVGNK3ZvHTc2VJQDho4jsNV66MTBjk70c1u8xiYr0hb2i5wJyTFysNx29QBr2Xdkv6Kx0bKjQkvKc7EYD3VGQl3aADzuCBeJwk9ocbF+qkmvmBJvyvQHk+KMeXoScykW82tHFcFkmd3AuYtVtSGT+X84am89MDZXNyFKnhD3J+X36upky9CmgHaBP10yzIr7UuQg34eFUmRX7UZEOVgUAidUweMPum4Zn5OXXOWPEC3LNrblLhvCqMWjZYGpJ9Ext5J7G2rO9s69glvoszz0B4t4+foI3QnZB2hY0QriNSZMGGKoyNG45FGBK9Rr8keP4lq3UwysEVz8zyAoPo+3m352qBuoQkGfgS3PCAWQ+PJgGETQTqKaUM9R4zL+AOkLNUjrN1ku9Xy4rYCStW2VhU1DemAeiWNc4dZTpmd9WMhnN/FytVjmTWLxQSqoR+MluGcUhQWrOCDxcxIXigu6CCGbTy75qXvUtXwbheXRjd/ayu/cJt3WPyg0X6hVqf84CgJSHfIdrbELQkPGpAPsuz8ymgna/xJ/zUJGXSDXjSrEDNJ2ScmP24NsnUUChXrYJvODAbtIP2eg9988k7Ik=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(39860400002)(376002)(396003)(346002)(36756003)(83380400001)(316002)(478600001)(8676002)(8936002)(4326008)(33656002)(186003)(66946007)(2616005)(38100700002)(1076003)(26005)(86362001)(6916009)(9746002)(5660300002)(426003)(2906002)(66476007)(66556008)(7416002)(4744005)(9786002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?vIwHr7AY+eN+QWZp15pxlId1VqKtls0Qm27WLCtxwW4nXnO2kgnsRMZI8K3F?=
 =?us-ascii?Q?8Mh3E/PJp41fjIRjzO8Hv7cytFhd/OX3ULcyRWOsy8B6FWOEsSYQ4D4RWD+x?=
 =?us-ascii?Q?QyRanb3X2VpfCh1DC8EsFl20m0h0ynwi4t/7/v5bK7G3oMh6QtZHONP8eGsN?=
 =?us-ascii?Q?aLYMX8QflsAfLcFmw8EAuXZK4cHVh4lx6x0bZv42vxsX7CBW1C6vwZExYV9h?=
 =?us-ascii?Q?5ug6m0mEFh3VCRw/dXQ9t5e4YoJRY4INO4GgOXattYy6/Jg2oDiWaVWvjqpP?=
 =?us-ascii?Q?+wrusMNnEEgVGoElmJSamchFC+/DygQdIHebfvfW7b1sqltCJiqh16ReqbO0?=
 =?us-ascii?Q?OBTUW+Gb0OcjTS/Ctv+/ptuUgxAYoBhYdwA7UObeFfc2agP68lWVDLuwG4pe?=
 =?us-ascii?Q?8rD07IUQVfLZRSC7I8M+s3EdJAhm3LcqwOhteBPtUB5rhH4+Xtm0QzR2WRRf?=
 =?us-ascii?Q?NbSZjiejcCVIRIU3BxCVEK0be/qNOYf4+Rj9XG74uaYF9OlBmc/KmOC3xSgk?=
 =?us-ascii?Q?EaGjucDx0xRvAwU0Juq3K5ce/YBQsQU9UPeotM9MwIODxQfx82RYwwehpSeD?=
 =?us-ascii?Q?5LglFG7Zl6vH9DNIfAsiwXtRr3RHoDWQmwSSqUi6AkptmblWpLxVnSJiuodk?=
 =?us-ascii?Q?62Wyj+0ll5VCp8b4Hpm5wkqthJfzNMG73lYXfEeOlInJDOGl6VK/VKjI/ybw?=
 =?us-ascii?Q?p8XW7A30fwOJalS/WpJTGQkVwKNm7EUs5LIX5VDzTDbEhVfpRCA7bj95oQE1?=
 =?us-ascii?Q?4DVId61V6UgLMGK1VfwImS2Ts32ycmmOGfEWvugLfckZyzU8XuUaIabpi83C?=
 =?us-ascii?Q?hDfmH3YELr4c9SzwXBAfVnrd9eC4XC8X27/jhusp2Ydk+LuplMEihTFS7FyY?=
 =?us-ascii?Q?sdoWVl8jjx2ylHByZTwHC3yh31Ru0F5Tvf3Ium/qUHHXeTgeG2Te0BxVz4hI?=
 =?us-ascii?Q?UhbYHm5yXk7o5B3KmgREPWIbtrM/0vhXIwSW9KOUIJRWV8M3ITG044pQO3Ja?=
 =?us-ascii?Q?KjTddRZ2sDn/uVfiKqe4jlUJPGAAkDMDsikEB/gO6QCVIwHZ4WT+1kSLhS9u?=
 =?us-ascii?Q?EFPnks4AZ4OXiCSR4vOd/iBv9TDr+ux5oVX1qU1lBhQsD70VchGMSF6alo8f?=
 =?us-ascii?Q?pW4yrCS6diACEz9lZCsbrskq9P1K3P1oAkh7uJbdVnCE85spZa2pqJxBBBNm?=
 =?us-ascii?Q?bNl3vt0Tqkyh/5OO8dhct/61UMCT/N0bVzg63uHBr59WIYtcYAiize6B11rE?=
 =?us-ascii?Q?klkb5hqqIefpbT/jo+7vJEg1Zz+EFajF84WL0Y5Vpm+dQPvCWz756T0nTFfW?=
 =?us-ascii?Q?P12ja06YGY9ECHHD+L0A0MiA?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ebd090d1-5501-418d-038b-08d91e452378
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2021 23:47:34.7913
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BVt5NnuFT1SAQs84GH2YkQr83bNpoVBFoKOWl6raBfwU8LvDypAGGLTmIcLDxwvX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5287
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 21, 2021 at 05:20:31PM -0700, Dave Jiang wrote:
> Add mdev device type "1dwq-v1" support code. 1dwq-v1 is defined as a
> single DSA gen1 dedicated WQ. This WQ cannot be shared between guests. The
> guest also cannot change any WQ configuration.
> 
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
>  drivers/vfio/mdev/idxd/mdev.c |  173 +++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 166 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/vfio/mdev/idxd/mdev.c b/drivers/vfio/mdev/idxd/mdev.c
> index e484095baeea..9f6c4997ec24 100644
> +++ b/drivers/vfio/mdev/idxd/mdev.c
> @@ -22,6 +22,13 @@
>  #include "idxd.h"
>  #include "mdev.h"
>  
> +static const char idxd_dsa_1dwq_name[] = "dsa-1dwq-v1";
> +static const char idxd_iax_1dwq_name[] = "iax-1dwq-v1";

Dare I ask why this is "v1"? If you need to significantly change
something you should make a whole new mdev.

Jason
