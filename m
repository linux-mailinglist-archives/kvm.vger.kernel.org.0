Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D58BD634DFE
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 03:43:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235593AbiKWCnm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Nov 2022 21:43:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233239AbiKWCnk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Nov 2022 21:43:40 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF55778D78
        for <kvm@vger.kernel.org>; Tue, 22 Nov 2022 18:43:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669171418; x=1700707418;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ueZdbb9YmUMpme4ZPOPDxOI6sTMdLxdkcOi+pzNTlWk=;
  b=SRR/zOsiSXXDY3kPdRVBvNLL738ZzC/hQ+lb+Jk0Vc4iBzSxjHEOPRLe
   /dsDq06L/eUdpBp57SY97XV59DD6bxSh64Ru3geglDTTBgeWHq0w2JUDO
   LGr4T6T7S9IU+6mnW4Sd3FJruUK6rKZj2LHSPru8Q5KhKg9tGJ5gHnzNQ
   t50VBYtOYozKOj1Wg/WYAUwy3mT7blaSgOhfRYEGHnAbpJeC7+UAavvZQ
   fA9+WftiXSfKvdAlHFYbzl8IY+9urJAf/5hybZ6SCS7FqCfC4Nn8/rf7O
   e8qe/6b+oI9fB09bk1jG6aZ/LYwLTiyOtfYi4yDuDC2L8Q/6QcV7Opa8f
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="293673159"
X-IronPort-AV: E=Sophos;i="5.96,186,1665471600"; 
   d="scan'208";a="293673159"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2022 18:43:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="970697512"
X-IronPort-AV: E=Sophos;i="5.96,186,1665471600"; 
   d="scan'208";a="970697512"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga005.fm.intel.com with ESMTP; 22 Nov 2022 18:43:38 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.13; Tue, 22 Nov 2022 18:43:37 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 22 Nov 2022 18:43:37 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.108)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 22 Nov 2022 18:43:37 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iBPehlm2BBx8XRJIT0Bl73wCZg7QLlzFl+Wm2Hz4hWD+K76QmAP9HEoyjCMYC3QEIjQeZKYgnB3BHp6BwwbYD3eLyDEkNXsOL1nG4RsY18ZziOFFEUXw0FEviDli4srPf2mivITzQXQ59P4JzbIYjr58GUokftjioyD5FKduNr5fJqat6mHJhAGq13emTiEMqkNj9IlEVpMuCbnfeDjt/QJGjR6CYEEmkaFdUzMF1OHOh+LemjrfAWYweroapoDwKFBgKnAFbW14CYwm/VkCO28dctRWSJES2pssP5Py4J8ct16nTurn8Dsmqf6vA8qnz6tv8Fz2xRolbbyu4PFg3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/YUofw3RiTxIxYcwDD1d/61UPbp2aCitWJCZMMpU58g=;
 b=eq6VmU32nP5/Gcz+/XJXat88Qc30gfNAuuG6ZZUv/N4aS0Xj3QR/+vKhI+Pfp9P8Ddlv3yJaofOzrE6Ov58Q8N7zDgvNQysQ1wBBXQ+rbk+nr6ixIx4SScIyZWd85VXOoqYwwnohfKk/g1cKA1HgAOUCzSUrG1yuR7yA2tC/DhpGbJEg2JdAZDFwsIk9YgG+O7T03M3eSmcJn7my/EACICdGbF2fGo9Va/aHpHt6yx9Stq6rcnHGNAf0KjQ+jQ5uMO2wP32dYgX1HKApZb6iEGAwNu+7qlajRK1UIla7pTetWJx+KuGP6vwDR/hDOYMpE3LWZpoU1mujABh/AbX5xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by CO1PR11MB4881.namprd11.prod.outlook.com (2603:10b6:303:91::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Wed, 23 Nov
 2022 02:43:35 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::61c3:c221:e785:ce13]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::61c3:c221:e785:ce13%6]) with mapi id 15.20.5834.015; Wed, 23 Nov 2022
 02:43:34 +0000
Message-ID: <b35d92c9-c10e-11c0-6cb2-df66f117c13f@intel.com>
Date:   Wed, 23 Nov 2022 10:44:12 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [PATCH v3 00/11] Connect VFIO to IOMMUFD
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>, <kvm@vger.kernel.org>,
        Lixiao Yang <lixiao.yang@intel.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Nicolin Chen <nicolinc@nvidia.com>, Yu He <yu.he@intel.com>
References: <0-v3-50561e12d92b+313-vfio_iommufd_jgg@nvidia.com>
From:   Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <0-v3-50561e12d92b+313-vfio_iommufd_jgg@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SGBP274CA0009.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::21)
 To DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|CO1PR11MB4881:EE_
X-MS-Office365-Filtering-Correlation-Id: d4daa25b-c0dc-4b4b-e86c-08daccfc83f9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JWFJPx4sK3E1kt1bC5i9zeZge1tduAET+7Ext2L379CvOm/d8J9Qp5PmOsL+sTE2hRYRNjElpX4237O+Pnpar3JJy3s+0vtVxLLTKn0MzrFzJqBNyF7Rad3P+7GW+gVZZUB6vLSI/zj2JhWwgUlN8ytrl4uBqnc9r9RkmIhqH2mvRsrAQv8gFUoVNIGMJQS4xlDf9Cb+/lv20jFQFT7prG/Gn9eRFEN8J6QAGQU27VPAQMVdP1jsuH1r6R2gdaeV5pWD167J1wQZAggPmMNsGMibLA2XQlHn53zCWt4bg3ZDgY19aP6bsAlpNnEepvoEO2Yy7itftvXZ4UubM3csi7qsQJsc5FlBCyj6g+nZ+s3eIkKN8XnenOhukZbby25KD2fOcyxNasRmTr9XUfsTGeJvcNGCIhXGGftEKwwF4XcCnr7WkplIUEwsZ4YI4+Nmo+gE1PRLqFt+RgV344atut5+oS3AvnY6EMqKWm1S6i5H8Qj3CQfFecWV5obWkmf7rM41YVuv3qWysOrAJuiGcV9mCi8JMyQ/twazZu6J+pkcraTO4OIZPtzKtD17LZmfFMr0rKRiHKkNU9omFcqAedGJtcfeYNCb+tCRMr6UtoUzTLsvaS07+MEmYtM0I1ft2rT6IWo7jRSBB3tw7Gin7kg0nQG2BNXDlCI4WeBBzq3MAOBaMKvkA6u7LJnQ1IaH6z8YCUYHQdFL7QwlnJi+0157Omp4mi7gkuPBUI4JBi6Aqkyex1mTD4DWwFYKHWCfOpxTlNA/v4yvWHyxjFLvN650frDRyaEoVZGoTgrtGBg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(366004)(39860400002)(396003)(346002)(451199015)(36756003)(31686004)(31696002)(86362001)(5660300002)(186003)(38100700002)(2906002)(2616005)(6512007)(82960400001)(83380400001)(53546011)(26005)(54906003)(6486002)(66556008)(6916009)(966005)(66476007)(6506007)(4326008)(41300700001)(478600001)(8936002)(6666004)(8676002)(66946007)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?czg2ZUdRUFNFRUZoTDRsTm5LRCtWM2ExL00xVTFQUW9HN1R6RC96VFVmT2wv?=
 =?utf-8?B?RUxvVGZqNTNZTlV1UzUyTUVPRHFMb0hJUC9JT0l0TGFwMjNWdk03S2FiRWlS?=
 =?utf-8?B?UzhXa20rbHpXZlhYOFgwRnlaWm5hTlJsS2lFYlR0TVE4dUJtRlQ3Y2w3NjNR?=
 =?utf-8?B?M1dqL3ZmSXVyTjVLWHlkcmY1U1p5TFNhRTdwZElLZDZFVWRrM3Q0bXdYZm9Y?=
 =?utf-8?B?SmxuNnVMSWVYQUdhc0ZqT3k2QjQ3S3FwNUZDZWNBRFNVdGJYeXF5TGU5TnB0?=
 =?utf-8?B?WDd1azQ1MCtkakduMFpIdnZUTnlEWEFFS2hFVW14bUJwYnkybzJ3T1BISS9B?=
 =?utf-8?B?dkQ1eDB0U2dlSSs1VUczMURGQ3BIYnA2cFV0dzc2WUE5eUJHOFUyV1VKeUxr?=
 =?utf-8?B?MGJOTk5KaWswT3A5TlN6aHNOdUsxeHV3aHI5aWgvcjM3bCt5UldscUhXRmpE?=
 =?utf-8?B?ZDZ4SXQ4Nk5jYXJUVndwSkl3T0pJV3pEaWhqL2cxeENIVlMyai9xWTdIaEhs?=
 =?utf-8?B?NXEzbzBBajlzeVBRLy9BUWUxWUhCekpFT3FXcmlieUZZczZEdG1pTlQrMVVi?=
 =?utf-8?B?OU1pVmZnLysvRndQbWF6cHRIL2xsSERlUlpRY21oUmIxeWFtcEluYk1wUzli?=
 =?utf-8?B?SW50eXo2QjlUOU1ITG80enZGS0wvM2lVbzYxR1RwTGEySkxOZzFzVnNPanFs?=
 =?utf-8?B?QkNyNTlhNjRab2VTV3lPNTBoWEVHUWIrcTlVNGhvalU5N2hWWW9pN0pBdmwx?=
 =?utf-8?B?K0t0YXFxOXhTeEkwNjNaMUJrWWZYOUJuYXRZM0R2c3hIMzJlVmhiZlBjcnRi?=
 =?utf-8?B?OW9KODQ5emVleHgyTGhEdmliSFduS3czR2hmbCtIdTZwdzBORFJheDEvbHlS?=
 =?utf-8?B?SlI1dnlzSUtyRWRtS3RqaXh5b2UybjJmOGNJbGNMYmFVMlRZSG5EYncxQ2pi?=
 =?utf-8?B?Znp6TndJTzZqVXVMenJPbVA2RU12b2JjUWlkUUFueGF3eU9wZEJYR25CNytD?=
 =?utf-8?B?TTgxVWZiZk5ORVdHRkw1QnZCbEdZcnZmdkZMNUZVd3Q4ZUFzWHBaUXlMdXVD?=
 =?utf-8?B?UXBwN05LWWx5YjUyMUZsL3ZQWmNpWWovTFd5aHdiS25YSmZxOGNBSFhTUU1D?=
 =?utf-8?B?R3E4RHZEc0VpRTZsWWVrZHNYekwwNU1iUEFHOURaRkVXcWx1bjZqR01UN2JS?=
 =?utf-8?B?RUlVQUxISWNYSDFJUm4yV0hJaDZNNncvSk4zalpzK0UvdC9VeHd2QVdLZnRq?=
 =?utf-8?B?YjY0YWNTdnFtTGlPbkNWUmtoRERVT2R5KzVFTW03cElnVHN1SlJRc2xkUlV6?=
 =?utf-8?B?UWhMOHRyODcydFR6czJOdmxJK1czb1lNamtDWFp3enNzcCtNeVI4eUJEZERD?=
 =?utf-8?B?dzM4ODlNZ0FkRXlXdjl2ZzhseFh2NUV6N0w0SVI0c2wvUlgvR1RRUVhrSk9W?=
 =?utf-8?B?QWRJZG90SXczNlE3TEFQRkRsOWEwaG5NUDhLY3lTUW1tNEdydi9WSWl0cWpi?=
 =?utf-8?B?em1KNExIeENUWTJUemkraWJRRTNkUkhBNGl5VzdQVnlRckszWGR3bkt6d2RY?=
 =?utf-8?B?UGg0Y1Q0bUlJL2Y2cFRlYndocTlwcXF6Rzd0elo2UjR5aStrOHFFSnhoR3NH?=
 =?utf-8?B?bnc0YkczV1FIeGJVV3hQYVZPZmdlV3lab1FjTmxIakdwcTFwaDM5c1YvZlAr?=
 =?utf-8?B?QlFVcnFGaU9QUUdlWFVDQ0NWMG5zUGJtY3VZcDJBRGlpeDNGOWJvQ2dUcENr?=
 =?utf-8?B?UVViWmQ5ZU5BUnV2bFZxbXdTZkJtSjkrdlU4aXJjakd4cmFDQ3FJNXZPZERZ?=
 =?utf-8?B?aU45bDNvOVFDU3BMbW51RUY2SlVvdGJVSG13K3ZOSmlMZ1NLdGs1a1BHaVdW?=
 =?utf-8?B?VnJ3c1E3cEk1ZUhkUCt4S1JnaFpYenE2ZmlxOVI1U0R3ZUhPUTFlTHRpSkdW?=
 =?utf-8?B?dmt5bklTRXQxaWNHTjVDNXlXWTJWVzB2aEJnSjFBazM5ZVRaazJaUG93aHNI?=
 =?utf-8?B?VUdvTmhpUjY0MTRxZ3d1MWd5MHVzYzBWdHFtdFhTSWdKN01NR1RuRVh1L0E5?=
 =?utf-8?B?MFp3amsxdnQ0anRlNFdQQkVZdGdKRndwV2hFenhQTk9RallzWHFveHBLR2JG?=
 =?utf-8?Q?BuqB2jjeTp0oEXriOnjUr2MwV?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d4daa25b-c0dc-4b4b-e86c-08daccfc83f9
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2022 02:43:34.7500
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vKUgtrks3MyZh6YMTx13qKBtOMdsZiBlx+bKqtetO2gFK2Pg5O+dH7pjQvSnA7MtFgSm4WA5fECd9Xjs0MyfVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4881
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jason,

On 2022/11/17 05:05, Jason Gunthorpe wrote:
> This series provides an alternative container layer for VFIO implemented
> using iommufd. This is optional, if CONFIG_IOMMUFD is not set then it will
> not be compiled in.
> 
> At this point iommufd can be injected by passing in a iommfd FD to
> VFIO_GROUP_SET_CONTAINER which will use the VFIO compat layer in iommufd
> to obtain the compat IOAS and then connect up all the VFIO drivers as
> appropriate.
> 
> This is temporary stopping point, a following series will provide a way to
> directly open a VFIO device FD and directly connect it to IOMMUFD using
> native ioctls that can expose the IOMMUFD features like hwpt, future
> vPASID and dynamic attachment.
> 
> This series, in compat mode, has passed all the qemu tests we have
> available, including the test suites for the Intel GVT mdev. Aside from
> the temporary limitation with P2P memory this is belived to be fully
> compatible with VFIO.
> 
> This is on github: https://github.com/jgunthorpe/linux/commits/vfio_iommufd
> 
> It requires the iommufd series:
> 
> https://lore.kernel.org/r/0-v5-4001c2997bd0+30c-iommufd_jgg@nvidia.com

gvtg test encountered broken display with below commit in your for-next
branch.

https://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git/commit/?h=for-next&id=57f62422b6f0477afaddd2fc77a4bb9b94275f42

I noticed there are diffs in drivers/vfio/ and drivers/iommu/iommufd/
between this commit and the last tested commit (37c9e6e44d77a). Seems
to have regression due to the diffs.

> v3:
>   - Fix iommufd_attached to be only used in the vfio_iommufd_physical_*
>     funcs
>   - Always check for iommufd before invoking a iommufd function
>   - Fix mismatch between vfio_pin_pages and iommufd_access when the IOVA
>     is not aligned. Resolves problems on S390
> v2: https://lore.kernel.org/r/0-v2-65016290f146+33e-vfio_iommufd_jgg@nvidia.com
>   - Rebase to v6.1-rc3, v4 iommufd series
>   - Fixup comments and commit messages from list remarks
>   - Fix leaking of the iommufd for mdevs
>   - New patch to fix vfio modaliases when vfio container is disabled
>   - Add a dmesg once when the iommufd provided /dev/vfio/vfio is opened
>     to signal that iommufd is providing this
> v1: https://lore.kernel.org/r/0-v1-4991695894d8+211-vfio_iommufd_jgg@nvidia.com
> 
> Jason Gunthorpe (11):
>    vfio: Move vfio_device driver open/close code to a function
>    vfio: Move vfio_device_assign_container() into
>      vfio_device_first_open()
>    vfio: Rename vfio_device_assign/unassign_container()
>    vfio: Move storage of allow_unsafe_interrupts to vfio_main.c
>    vfio: Use IOMMU_CAP_ENFORCE_CACHE_COHERENCY for
>      vfio_file_enforced_coherent()
>    vfio-iommufd: Allow iommufd to be used in place of a container fd
>    vfio-iommufd: Support iommufd for physical VFIO devices
>    vfio-iommufd: Support iommufd for emulated VFIO devices
>    vfio: Move container related MODULE_ALIAS statements into container.c
>    vfio: Make vfio_container optionally compiled
>    iommufd: Allow iommufd to supply /dev/vfio/vfio
> 
>   drivers/gpu/drm/i915/gvt/kvmgt.c              |   3 +
>   drivers/iommu/iommufd/Kconfig                 |  12 +
>   drivers/iommu/iommufd/main.c                  |  36 ++
>   drivers/s390/cio/vfio_ccw_ops.c               |   3 +
>   drivers/s390/crypto/vfio_ap_ops.c             |   3 +
>   drivers/vfio/Kconfig                          |  36 +-
>   drivers/vfio/Makefile                         |   5 +-
>   drivers/vfio/container.c                      | 141 ++-----
>   drivers/vfio/fsl-mc/vfio_fsl_mc.c             |   3 +
>   drivers/vfio/iommufd.c                        | 161 ++++++++
>   .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    |   6 +
>   drivers/vfio/pci/mlx5/main.c                  |   3 +
>   drivers/vfio/pci/vfio_pci.c                   |   3 +
>   drivers/vfio/platform/vfio_amba.c             |   3 +
>   drivers/vfio/platform/vfio_platform.c         |   3 +
>   drivers/vfio/vfio.h                           | 100 ++++-
>   drivers/vfio/vfio_iommu_type1.c               |   5 +-
>   drivers/vfio/vfio_main.c                      | 348 ++++++++++++++----
>   include/linux/vfio.h                          |  39 ++
>   19 files changed, 714 insertions(+), 199 deletions(-)
>   create mode 100644 drivers/vfio/iommufd.c
> 
> 
> base-commit: 9d367dc905dd278614aaf601afb28e511b82fb3b

-- 
Regards,
Yi Liu
