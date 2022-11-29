Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A50D063BE92
	for <lists+kvm@lfdr.de>; Tue, 29 Nov 2022 12:06:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233072AbiK2LGH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Nov 2022 06:06:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229759AbiK2LFe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Nov 2022 06:05:34 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C41216457A;
        Tue, 29 Nov 2022 03:02:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669719748; x=1701255748;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=P1rsohAXUDdXQXoysDqKPyeJaoekRF8TU1DIoU1mSOw=;
  b=DhVZCStMK8MYpjBw6I5dniIcMhZjQwxJ44l4GzLxeXWcB2hZwQBWlOPf
   BLTHk0/QmWGHSWwk/YatAI388sGAQJ/Lt9phf+Tx0CCdDMiwgE3rwHTYA
   Em2goqmKO7lKIiWCTD3QArLh/yFwdq61oV5ziAs+C4hXveyRkLEZubB5U
   28Lp7BAJR4vcELT3UB5Cg0mJ0soEgI+S35cBBjGRuCoaCE7U7I4MDbml4
   0tKUB0CcEXSB+cYzqkcQXgNt1g185hNjHbi1IFbcGJjRmShPpGfgwtBbo
   NWbts+LQWIeT6spiOoIjzqnHMXr0xxvuZe2X6xqLKFeuUvvPBIX6fNtSg
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="295458011"
X-IronPort-AV: E=Sophos;i="5.96,202,1665471600"; 
   d="scan'208";a="295458011"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Nov 2022 03:01:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="785998399"
X-IronPort-AV: E=Sophos;i="5.96,202,1665471600"; 
   d="scan'208";a="785998399"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga001.fm.intel.com with ESMTP; 29 Nov 2022 03:01:19 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 29 Nov 2022 03:01:19 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 29 Nov 2022 03:01:19 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.171)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 29 Nov 2022 03:01:17 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cfb2fEizRivypNIdY9EhR7asHNrXeG1kPq0Cd0/KCImEHuXBE11FFuXJa87z/2S/Cc/62mCc2b4kZ9Z2+GCoNtIyA7pcdKmyaLmXzcqt4UKV0DJKFv/wTygrmNGIh96DrIEm193aX7lsftjufRpAH0ZzLUPK78Ub1Gt0AZz/Sr+gYjRfbto+y3ywFOWp6YJj1qFMeL7/lkvKe4Tf65p9zzlTeMf0gqvzd5wwx1tBR+cTDa7cKIXzee2wPIBNVg7CEraNCvEyv+BRFR1yxaYFDqBeZDvlrGnQSZ3vjF6OhA7FDpgZWrQAdqeIsshnM4PHj3HS/dnOGHa5S4LLRu7wAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I8catvdf7N0yILFzA+1YZTURWsIn5D/VgnOyFhS4azc=;
 b=emSTptd4D4MUpgoKzxfKmEzWdJ2dt9apVwaD2mhbPqb1105AzoCg4mOG/WVGDRxLBhgB1A97241DoVfuN8rNUiuNUZeSEjgSqgJchjqrOQDqw10IjboolO3MCYlCz50tkJTvc1tlzQxAZfRq+ijI9vzUSClC8lEPP8iDS4Wp5XIafB4y92F4ZURT21vOPHrfCZO6ZzQcPXcX3krpoyghlbFP+il8r/TGCBVr/XHzLdUZEGkr8aTE7bfMc7DGU7wykfFSvA48thfClKCUZEt13co35hBATeA60YYJ0HCA7CHf0bLYDlDD10qVff5ZfSxPHQTnvgBifNed4CJVSooTpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by BN9PR11MB5557.namprd11.prod.outlook.com (2603:10b6:408:102::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Tue, 29 Nov
 2022 11:01:10 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::61c3:c221:e785:ce13]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::61c3:c221:e785:ce13%7]) with mapi id 15.20.5857.020; Tue, 29 Nov 2022
 11:01:10 +0000
Message-ID: <debb397f-916c-b5b5-2905-dc7159843c75@intel.com>
Date:   Tue, 29 Nov 2022 19:01:47 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [iommufd PATCH v2 0/2] Make mdev driver dma_unmap callback
 tolerant to unmaps come before device open
Content-Language: en-US
To:     <jgg@nvidia.com>
CC:     <alex.williamson@redhat.com>, <kevin.tian@intel.com>,
        <kvm@vger.kernel.org>, <mjrosato@linux.ibm.com>,
        <chao.p.peng@linux.intel.com>, <yi.y.sun@linux.intel.com>,
        <intel-gvt-dev@lists.freedesktop.org>,
        <linux-s390@vger.kernel.org>,
        "Tony Krowiak" <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        "Jason Herne" <jjherne@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        "Zhi Wang" <zhi.a.wang@intel.com>
References: <20221129093535.359357-1-yi.l.liu@intel.com>
From:   Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <20221129093535.359357-1-yi.l.liu@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0003.apcprd02.prod.outlook.com
 (2603:1096:4:1f7::20) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|BN9PR11MB5557:EE_
X-MS-Office365-Filtering-Correlation-Id: 8f1867bd-d2aa-4d95-59b8-08dad1f905a8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7Pw1Pn8ccKsKZA8NDdM97Ij/DDY9N0Uq+yvEhNUFOe6p0R4/UwYbtsuqCKOf3WSiCKyTSpdZ+0jwEPg4MFlDEMK9W1nojSzfNDl1S/2oGCqsr3WdzlRY1rdt6XpgFSm48DETquGJ7yRJsOee0jZk/hj7XA4QxblAMcVj4g8CcUl2dHeGH/D5Avx/DhFVGztYRCFIDleb4HmvQDMUjLi1/HzlBn9HsM7hTVdC6+xdAVzAwavX5Ttujiz6e6FNaOFb+OpPdV15YGiGmIB3V06QsqElnRZ8V1ksXvX930xi2bD4Sm/EusFXPTo+nhaldRbaQXaifovQpE4mHv+OcY4lfifyphQBe/8T9Hf3yExSLUmfx1Ca1wuftfISPV6IGQ7T0syGadv4IHO2E4pperdS68Tkz8sfWQ/6/KdZ9Zk8/pWvpyLAAWRBpktDRX1ypONRdVVVIAtUwzWXE5McjxTKFl+ZYub6ztHnmhNr+ZkZFv9URDIrUnIo353dDyo6HTmPzZd4EIqKvyr2/KvHKR6LXAzHbrpMNjgJrJQZTeqkcZqxWAcfeBrVypiqFBSzaT72+Iskla0/lrrcop8xDCHd/KW8HpoGbvi9oPVizgAkbT9aGVvhQKT3fDc2zoX79l2YiDLsujeMbloc5407QGGN3zb+b+G2HUo9/Gr4y7LnGvnVQbO/ogPBMJHSXZhAmpMpDvuqtjSkFMGoKSisTmPMI+v2q20yhsn3UQWG+bYU+zk2O4uu8AobK3y31efYAspKKIEpu4OUJVAE5QGThEv++sKXOcTwMiQJ30sQSV9OY4A=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(366004)(396003)(376002)(346002)(136003)(451199015)(31686004)(186003)(6506007)(31696002)(4326008)(26005)(53546011)(66476007)(8676002)(8936002)(41300700001)(86362001)(6916009)(6512007)(66556008)(6486002)(966005)(66946007)(2616005)(6666004)(478600001)(54906003)(316002)(82960400001)(38100700002)(7416002)(2906002)(83380400001)(5660300002)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L2hCMVdrSDFkMWUvTnFmdTgvQ3lFMnkvNkkyTmdjRW1oR0plS1ZTcjNOZnlX?=
 =?utf-8?B?Y0g2Y2ZUeXoxaEtiUDkvaGVaNDY0V1NTMTdVTk1uS0hBblFxM1h2a2M3UCtB?=
 =?utf-8?B?YlRXclVlU2cxTGwxY09DNlZ6TkNXYmpVS1hObXd2ZXVnUFhCdThtRjhxZFFE?=
 =?utf-8?B?NjllaVEvTGFEai9NOEZESFIxbG9MeEJVbEdWZm5OVFZyei81ZVo2WDZtTWpn?=
 =?utf-8?B?ZG9rQmR0bU5BbjVXZTlSYTJhZmpxRjNaL0lNdzNkdXRVaTJRckxZREs1bGtO?=
 =?utf-8?B?dU5qZi9vRUh0NDFBWGE2cytyMExVZWFtQ1I2ZDNkOHVuNlVjMUd3c2ZPbzJ5?=
 =?utf-8?B?SThMUDRFeE10QW14ZUZGSXFndFJlZFhjbDZ0Yi9teEx6Y29JYkVOQzZYYkNJ?=
 =?utf-8?B?R1F2OVRINlZiMVdkUG54T0U0SGZBTXM1Z3RZTjJqN2gyRDd3TDA1aFRnSXdL?=
 =?utf-8?B?UXdnRTRNeEp2c1BhelkxTHZaWlIrTWp5cUtWOC95TjlBd3FnMFdXbENhb0FK?=
 =?utf-8?B?RjcvNExPUzNEN2NvOWlCRGdFYWZ2RnJoMjJzR1ZHelJWajlObUtCNkdsM1U4?=
 =?utf-8?B?cktjRlc4SC90UkVxTFFBZmRQbFVVNzJDRm5mc0x4TTlXYWU1ZFhJdGhBblYx?=
 =?utf-8?B?RllCWFB2QUpzQlZtODBGUER0NXRDQ2JXa3JWTnc3RjNCSW00dUxqSzFLVG5w?=
 =?utf-8?B?eGs2M0dyMncwTjY1YkNPYkJDY0o5WGFiZk9aZ3VnRW53L0Z1K2U0Y1Z3OFBL?=
 =?utf-8?B?bGFucGZhc2M3ZEFmUFB3UnZ6OWdSRVFLUktCcW9vaVdaS2pYVzhVM2l3TTdM?=
 =?utf-8?B?Y2RpMTkxVzV5YTRnbTNBSzRZWEwvZkpiM2JHRmJxQ0E3RmdEaFhrdEY3Umtu?=
 =?utf-8?B?cUJzU2dOVFVBUkFTYzN2WmY3TTY5ekF4Slk0ajNuaFRyT0NuWCtpOTVBY2ta?=
 =?utf-8?B?cnAvc3Y2dVRpU3pJTzBOYTc1WVJCbVFwTTBGajlzajVobkdvQUF0Qk1WbnVr?=
 =?utf-8?B?NmVsR3dTTk9KamcxMTZkQTloNlVqNHdzZDJBWVp1U0VZNDN6R3REWmc1U3VN?=
 =?utf-8?B?YzJ4ZDFQaGg5cDhuaE1aWVVBVlgzNUdDbUxDYXJVTHh2K2w1RUlhd2dPbXNL?=
 =?utf-8?B?dGhQRDNuL3BVYUtaRGJNK3UxUU4rd1p3NDJhYlUyRDEybkxDTHdRMUlDUm5Y?=
 =?utf-8?B?MWUzblB1YkRUMTlFS0VyZWVIL2hBYmI4VTFtRGJjcEN1em0yVmdqWmx6dEJS?=
 =?utf-8?B?UUsxWmRMTFJUOTVLVU8xWE9vM0lWRWJtMFRqOVpubm1HZXBHOTMyTytqWmp5?=
 =?utf-8?B?aGVBZFZCSWs4anlwVnFhOTBnODJJNEVISTBBSGhNOTRLclhKSUc1Mjh2dWR0?=
 =?utf-8?B?RzBvOG93bUVGVVVxNXgrYVZwQUF0MFFvZ3AzSTkveHo0NVpGclRJdDlpSEpO?=
 =?utf-8?B?d3dSL2VTZDk1dGVoTmR4ZEQ5TUM0d01QcE94RXRnRTFlSjM1RVE1MW9wUnl0?=
 =?utf-8?B?MzJIYkx4Tlp4dUF3T2hsRWtyeGxvUlprM21RTHN2TmtsamtnTVBZdEQ4ZW9i?=
 =?utf-8?B?Znd5ZmFBb21IRWJtMHlURkZ6ajNoc09MWk5IR0tPbC9uTUpPVzFjUW12RVpa?=
 =?utf-8?B?WVFka0VyTEY1YnRaTjM2dDR1Y2J5alBBcm9CcDFmQmZqYXFIdVJBU1E3Wjdt?=
 =?utf-8?B?TWJEM1BVNmpFaTd6RVN5VTZCa1dWVUN5c1RjU2I1VDFqeFllcWZadFRUNm1w?=
 =?utf-8?B?bmM2Q2E2WHRBYTl4MXdzb0szaHdDOHNKamRJMUR5TmZ2ZjlQWGNrQm94anVM?=
 =?utf-8?B?VWdtTEtyQXdXSjZiU1FIV0t1YTVNQTV6NnRZbjBJU0RhM0VadlJkdG9YZXlu?=
 =?utf-8?B?cklJOWFBZjhxc2RXZnNSeWMrRkszZlJYZVRpRUJuTlFaZU1WWlRSdzlYbWp1?=
 =?utf-8?B?clBaeWIxc0hOaFJwTjdUOVduOTRkbm9WZWxKaXNJZjhuK05jSG5ZdlM1RGNE?=
 =?utf-8?B?bzY2N09KKzJSY3JiKzhjUmk1bmNkdUNkaWc0WUhBS0I1emdxay9BbDFBOUVO?=
 =?utf-8?B?dTJTZW91RlJYdFdFZWRuMCtkdzhDM1crM0MxUmtaeFhHeC92N3hVY1pheit4?=
 =?utf-8?Q?5BDfTftTUALynT+ncMqchi5p3?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f1867bd-d2aa-4d95-59b8-08dad1f905a8
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 11:01:10.1451
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m/vogz7v5To/U5I1c4ONcn51RPxgCduixlr1rVTu4SN2RA1EiANs1m1vV/HBh3sdt5cqpcdWNTtCelnIth8RIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5557
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022/11/29 17:35, Yi Liu wrote:
> Jason's "Connect VFIO to IOMMUFD" introduces vfio iommufd compat mode. Under
> this mode, vfio_iommufd_bind() creates an access which has an unmap callback,
> which can be called immediately. This means mdev drivers may receive unmap
> requests before the mdev is opened. For now, there are only three drivers
> (gvt, vfio-ap and vfio-ccw) providing dma_unmap(). vfio-ccw is fine with
> such requests. While gvt-g and vfio-ap may have potential problem with such
> requests due to internal implementation. This series tries to enhance the two
> drivers.
> 
> This series is based on Jason's below branch.
> 
> https://github.com/jgunthorpe/linux/tree/iommufd
> 
> (commit: 41973418f6c8c241ed5647d1408d5b917f24dfd8)

it's resent as below link. Please ignore this series.

https://lore.kernel.org/kvm/20221129105831.466954-1-yi.l.liu@intel.com/

> Change:
> v2:
>   - Refine the cover letter and commit message of patch 0001 (Kevin)
>   - Rename patch 0001 to better fit the commit message
>   - Add r-b from Zhi for patch 0001
>   - tweak iova range test to assume page-aligned for patch 0002 (Jason)
>   - Remove break so all queues within range are removed for patch 0002 (Kevin)
> 
> v1: https://lore.kernel.org/kvm/20221123134832.429589-1-yi.l.liu@intel.com/
> 
> Cc: Tony Krowiak <akrowiak@linux.ibm.com>
> Cc: Halil Pasic <pasic@linux.ibm.com>
> Cc: Jason Herne <jjherne@linux.ibm.com>
> Cc: linux-s390@vger.kernel.org
> Cc: Zhenyu Wang <zhenyuw@linux.intel.com>
> Cc: Zhi Wang <zhi.a.wang@intel.com>
> Cc: Kevin Tian <kevin.tian@intel.com>
> Cc: intel-gvt-dev@lists.freedesktop.org
> 
> Regards,
> 	Yi Liu
> 
> Matthew Rosato (1):
>    vfio/ap: validate iova during dma_unmap and trigger irq disable
> 
> Yi Liu (1):
>    i915/gvt: Move gvt mapping cache initialization to vGPU creation
> 
>   drivers/gpu/drm/i915/gvt/gvt.h    |  2 ++
>   drivers/gpu/drm/i915/gvt/kvmgt.c  |  7 ++-----
>   drivers/gpu/drm/i915/gvt/vgpu.c   |  2 ++
>   drivers/s390/crypto/vfio_ap_ops.c | 18 +++++++++++++++++-
>   4 files changed, 23 insertions(+), 6 deletions(-)
> 

-- 
Regards,
Yi Liu
