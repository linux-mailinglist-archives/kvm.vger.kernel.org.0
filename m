Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C73D454A88A
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 07:04:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234312AbiFNFEN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 01:04:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230137AbiFNFEL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 01:04:11 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46D523A5C2;
        Mon, 13 Jun 2022 22:04:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655183050; x=1686719050;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=l6UJb321vK/MH2Pbts6S90k7tVtn5Ne7NVgvpvvWesM=;
  b=NXNTLImLhzktSg6GY+fyPUkaY0AWRbwiE/A9LjYDts1Vf6KC8nT7I0My
   6JQLL3ijyfagg73XHRQqatqEKceiHri7CTEjF46TsgJuBxL5EqvL+8M3t
   cnSWwfOegSBjqSn0agAVioj8iLbSohcKUTugy/fVlGTx9Q5atDP1KMhxs
   6qMfxNmXLLBpXAN3r3kJI74UiZ6OWU+CstU83W8xCtqkIZmurOcEGVPHP
   X9Zjy7fkeLFpP6BaY4/fGA0vrnM72AQEMMOAuRiE49zUyL48V+GbuDUgt
   49FzoReOnEtPGYMe2Sl1RH+uIw4cJfrLXX/9hHUAy7T1zt1scp/S9iXOC
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10377"; a="279546634"
X-IronPort-AV: E=Sophos;i="5.91,299,1647327600"; 
   d="scan'208";a="279546634"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2022 22:04:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,299,1647327600"; 
   d="scan'208";a="726625142"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga001.fm.intel.com with ESMTP; 13 Jun 2022 22:04:09 -0700
Received: from fmsmsx604.amr.corp.intel.com (10.18.126.84) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 13 Jun 2022 22:04:09 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Mon, 13 Jun 2022 22:04:09 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.102)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Mon, 13 Jun 2022 22:04:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RdstyDSwdnuZojrQKBcB22K4w+YTw/ufN/OkZh9b4zYnQJDcagpHG+eywavmYLzjCIzXivSN+mKTta2cdOr1UXYtHFQSfkza+6F+aQD+OlM9yzDXqJ9R93bwT8kwGNrIkn730cPoToxBxKqyza2I++oG0KGfuI8adD5SL53Z84G6Sq3V6ZmxfMHhemM+8ybLAXipw2Kg3RvBL4DC6edid2mpsGOONWAZPz8ZvCOg6rlocNEIfqY1mCQz+02VxOWvptOoMxr414MUB2Yxl6bynXW56J3gHCpLP8lRTJfjh45moKPsFY+NUBE/TiQm0sYRDXDs0c33zPT8WeeF6n44cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uufCvEahZvls6bPpcbJ0dFOZjhbq6l+W2JsL7PR8HYs=;
 b=Yz2D/Qjk9r1ZxrZA1cbNOeQJGXnZP6KGUF9nYZGGqS29cFLrWsh/lB2P/oKi6yNPkk0Np1KrL/QgZ+3DDuQ0f1mGaQe6n3WudZYpNPen6t7XaOBhJEDrODt6hBQM9EVLqI392x+vWnlLBCtbMgxOFnS9nEAWelBdWbKnRtgcLf9IRw+YAsfFcmrRqhO2KB4XQ0xibGfhJhm6+/kjieifR7AgRIAWTQ6JbSfeIW9aAC463UYkFeEh+8gu2SsspToC4/as8jsayRq9tj+A0mvp4995w4VDDkf56PtWbG5bRkWKrC9wSmOBlnS9dHKkYNDmV+Bwz9dJAFkFSbuTCoQiJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB5658.namprd11.prod.outlook.com (2603:10b6:510:e2::23)
 by CY5PR11MB6185.namprd11.prod.outlook.com (2603:10b6:930:27::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.20; Tue, 14 Jun
 2022 05:04:07 +0000
Received: from PH0PR11MB5658.namprd11.prod.outlook.com
 ([fe80::d518:17a2:11e6:bd6]) by PH0PR11MB5658.namprd11.prod.outlook.com
 ([fe80::d518:17a2:11e6:bd6%7]) with mapi id 15.20.5314.019; Tue, 14 Jun 2022
 05:04:07 +0000
Message-ID: <0e517684-8b10-5410-8ad0-df7caed860b7@intel.com>
Date:   Tue, 14 Jun 2022 13:03:55 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.7.0
Subject: Re: simplify the mdev interface v2
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     <kvm@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        <intel-gvt-dev@lists.freedesktop.org>
References: <20220614045428.278494-1-hch@lst.de>
From:   Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <20220614045428.278494-1-hch@lst.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2P153CA0037.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c6::6)
 To PH0PR11MB5658.namprd11.prod.outlook.com (2603:10b6:510:e2::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5e2ca14e-f4d5-4832-6ec9-08da4dc34f5e
X-MS-TrafficTypeDiagnostic: CY5PR11MB6185:EE_
X-Microsoft-Antispam-PRVS: <CY5PR11MB61858058E037C639F9D1CFC9C3AA9@CY5PR11MB6185.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cjxytUu/yjQ+8a+GVzULQYm4VaQii+TVw48QHZbaSamjCRh3O1RyPlkEAJauQunAJ+aI43lsO0GS4ZvbPgbv65vfFh3ZZgEp6UJ8TZ3jPOoIAcvA0NCwH4C6gHcF4OmQYbHsf1G267FIkY/iLwJcAY6SBKqaykSWhzqyatF/P3vb8PJGp7iZBbJIXMAYORGyl2vSKWTqHBG26kPTXcdR0VnXH0zCNjv+QVrymkD60pMRQzhZE7aLhBUMah6PRwS92Xnd+0subWiWxRqGKP1JheWnvR7a8dsgPZHJgbFFtICCtY5tmFScoanAau2ghnjSOHIyNet7VdVkXkLCQQc/w/9J9mh/4F39VbT69eNRKtJVSNy08+mDNaAjcOqo3oItNv5pHQJHC6tQNlLTP4YBPbOnnc2qQpa1Fai8OQ/+mx0utrV9voA5m4PT1S5NvYBhBQg4tD+ish9FZGZCVBuOJK9+3W7J0fK63BC+V9DC3E4LExovLCm7j9YpSP2IEqH2KFWznRUT97ifZhCpirnNP901XvYstM3KxVeZr+TI9Q1vG2q8vOCNkB/xJWgqLSU2qWSsszNh/FAif76rvD0yM4mDnhZC42YCtowu2HQe+IMxrpH27fXslyg6CI8xUjN+DZZLoLnyrZnnErfDM57Zw+lYNBU10jcBr5d1neEgz4OB6lGMSDoAcqjVEqdjp6mAwXNQTewUmBSajoelSMZbL3GAv+Xu7xNfTW4A7AE57QTRbbQyOlBiNbzlbjROAPr7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5658.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(82960400001)(921005)(36756003)(110136005)(186003)(38100700002)(316002)(4326008)(8676002)(66946007)(66556008)(66476007)(31686004)(83380400001)(2906002)(31696002)(6666004)(53546011)(6506007)(7416002)(2616005)(6486002)(86362001)(508600001)(6512007)(5660300002)(26005)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NVl2RXE1ampUU0s1cDRQRTQxd3ZGYUZuMHBOWnhJczBQS1liK0d3Z2lKRURw?=
 =?utf-8?B?QUpXMzFVRXJoWnJGL0Noc1ZOTHQ5b3RxMGJ4TXpld3hPL0MwZEl4NWJicWRJ?=
 =?utf-8?B?cmdLaXRNK0VwN290ZG44dzNQTWl3anFOQXFIM3RuNzh2VzcyODJWZjdDdlZU?=
 =?utf-8?B?OGNqbG5tVW5RZ3BBK2NIUXRRaXZ2QTgzek5rMWgwZ0Y3TEpzOG1nbTVqQStX?=
 =?utf-8?B?NnlmRDN6QS9DTUhBWUp4Zlg3cW1UVjI4OEFsazFLeFFKQ2E4OFU2ZGhtbk0w?=
 =?utf-8?B?QUhWZFFiQnlDSnJCOVBGQ1BYZUVuYUJHczBkcmFZVDI1L1BNY3dKdVJyaXpk?=
 =?utf-8?B?dVFRamhZSzhNNisyRGZBclM5U25na0lTN2F5dk9jRzZ2T09RK3FaSnNRYm1V?=
 =?utf-8?B?WDA4Y2Z5cTN2Y1VMNkQvbEJaVEpPSjhzMjA3MnU4YWgxeGt0T0hEUVZCK0Nq?=
 =?utf-8?B?VkJOOS9uSFE2K2pndHRGQ0R1cjlTaDJwTlZxZGx3YnF3TDhmbjdtM3ZQVk9H?=
 =?utf-8?B?NVVJTjR5eEFWc2s2alY2MDl0L1hWTHR1OE0vRDhGdXhIY1Q0eVVrdzJuWVZs?=
 =?utf-8?B?WXFSbEpXVjBpcFk4T2xvdUxDelBDdWplMzZBZ2xiQWs0dThKZ0VWbjRQU0xJ?=
 =?utf-8?B?OTJYamdpVzNpeUlKWWZBWldaTjRkNDVTQjM0L2I1QkF6SVdrbzJQREdEbTNX?=
 =?utf-8?B?ZDExY0lZYXJaSkk3NTZ1V1hjU1lsVFMvSEovUHoxdVZYamFBRnJJa25CU1g3?=
 =?utf-8?B?NzVYZ3Z5UXZQZlhBckxSbHprZmZMQm8wdDNNcWswRGRxNStSMW1JOVMwUllv?=
 =?utf-8?B?VUVwMU5EbGZ1c3Bhc29uWG05dVg1MDlzaHNUQmZEL1FPd3d1V2Z6aGVSNlFp?=
 =?utf-8?B?MXg2U1ROVURWSUpiOERhbjRXaCsreFUwblQ0RVZob0prQjdKcWthQlB0Tk9W?=
 =?utf-8?B?Ty9OMXNpRW5BeGZvNEwxb3AvbTZmcEEyMFRzMVd4aFgwb1lENHFTK2k3ME9G?=
 =?utf-8?B?OVQ4ZFpBMXQ3dXE5bVFLVHVkdU9UV2piMkFiTHQ1Ti9mWG05c1dHU2xncm54?=
 =?utf-8?B?Wk45SnVjUHQ1YW5OLzY4WjhjMC84bGFRWnlWUlZ2RVR5aGZPVmJoc25MK0N5?=
 =?utf-8?B?RTN1TjdKMFNScnJqRXBMYSs4R0t3cVQvZjBDaXE1MjdSbXZ0VTF5ZncyS1o4?=
 =?utf-8?B?OTNLQUF0MWIyY2o4Qk9vWmhMcXMxMktuUmFRNmZtZC9RWTdvdGRwekNJc2Y1?=
 =?utf-8?B?VmpleGdESjhaZTVCQ0Rsa0lSaGRjYmNwaVZuUkZ3TzI0ZzYvSUp0Mzl3aGRN?=
 =?utf-8?B?NlliMkY2dm4zSG1MRDUrd01JU0J5VmdJbXhka2dDZXpTVkZ4clJhSmhNRmZJ?=
 =?utf-8?B?RFJST2VMRmJJcUlWT2dpMnVielZRSHRPazJOTFNWcUJXR3F6UXhVWTB2eUE0?=
 =?utf-8?B?bC96Yy9ITDRYNUZQRFRyNG5DaVlhN3hZajVPbi80QlMvNGhnZUIrUXpnWlQ1?=
 =?utf-8?B?MWRIcTBqMGpKMUJNdWh3dHV3N0I3L2lJby9ocGJ5TEVWeEJrdDJmYXIrVWtW?=
 =?utf-8?B?eG5iOFpkNWsvN2NSUjF3SkFxVmN3akswTWxTRENyT0ZJUkUrSk41bWg3V1FE?=
 =?utf-8?B?K2VNODFLMWtETHd3YXpuczZaL2xrS0VtMVFqRUhUbHJZZURiMXd6MG1QRmUy?=
 =?utf-8?B?YkNiT3c0ZU0yemxBUkZXeGp6WlZHMkxzTk1qTVBGejNQU2t2OWdqdmNRUnYz?=
 =?utf-8?B?K3pPd3JxUkkzb1NhV1NiZ2k4cnVCamxwOUVlS2gwUSsrVEVTdVZKQ1c1dXll?=
 =?utf-8?B?N0ZnRUxMdmduRmlSUnBRVFpZbld4MVlCQzZrWFVnU3lHeFNOb0pzaG9wd2xp?=
 =?utf-8?B?S09nWjRMNXdUeGVBcWNDNVUyYzNnSVR0VHlmckdOTS9heHk2RzZFZGV1Q2ZK?=
 =?utf-8?B?NVZuS0k0Uk92MDRyRHQxUk16c2JUTFFDVGhpSVl5YmtzZjVCQzJFQWJJSjA3?=
 =?utf-8?B?Y3F1TmlQVVdpNk9MUWEwRXBubXhFM1BESktOZk1jSHl3UXJPOHBPUmczWG4w?=
 =?utf-8?B?dnV0U0xEeFpwVGVXdlJwU3JEQjNZbElEMWFGcFVJS3ovU1g2NW9VeWZWSVgr?=
 =?utf-8?B?aXpBejhoQ3RWcURSTVlnVVRPa1FXL0hlTTdEL0I4VVRkVm41a3Rva21jbHlH?=
 =?utf-8?B?Z1NPeFpqV0w4Z0RLSDdIVnUvaHRpQllyMjgzWTRaT1dRc2JycDV0M0RzQlVJ?=
 =?utf-8?B?d2hlM3VONXZTd0wwbzBLOGlhV1NqczVXT2s1RnhnRGl4OVAydnBwSjBpRE5X?=
 =?utf-8?B?SUt6NU8wcjhDNG9YRTNPRFlXbGY4WC93NlBKeSs1bWR0K25rcDh6UT09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e2ca14e-f4d5-4832-6ec9-08da4dc34f5e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5658.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2022 05:04:07.5021
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KUrR2H0tqmCgJeUmic27tUOhih2FdkkdbVTkryvHipcW/CIjYW6tjRhR0sgS7Zcor4s1IWM/iFEdn8oDNaIaGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6185
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Chris,

On 2022/6/14 12:54, Christoph Hellwig wrote:
> Hi all,
> 
> this series signigicantly simplies the mdev driver interface by following
> the patterns for device model interaction used elsewhere in the kernel.
> 
> Changes since v1:
>   - embedd the mdev_parent into a different sub-structure in i916
>   - remove headers now inclued by mdev.h from individual source files
>   - pass an array of mdev_types to mdev_register_parent
>   - add additional patches to implement all attributes on the
>     mdev_type in the core code
> 
> Diffstat:
>   Documentation/driver-api/vfio-mediated-device.rst |   26 +-
>   Documentation/s390/vfio-ap.rst                    |    2
>   Documentation/s390/vfio-ccw.rst                   |    2
>   drivers/gpu/drm/i915/gvt/gvt.h                    |    6
>   drivers/gpu/drm/i915/gvt/kvmgt.c                  |  158 +++------------
>   drivers/gpu/drm/i915/gvt/vgpu.c                   |   60 +----
>   drivers/s390/cio/cio.h                            |    4
>   drivers/s390/cio/vfio_ccw_drv.c                   |    3
>   drivers/s390/cio/vfio_ccw_ops.c                   |   60 -----
>   drivers/s390/cio/vfio_ccw_private.h               |    2
>   drivers/s390/crypto/vfio_ap_ops.c                 |   68 ------
>   drivers/s390/crypto/vfio_ap_private.h             |    6
>   drivers/vfio/mdev/mdev_core.c                     |  214 ++++++--------------
>   drivers/vfio/mdev/mdev_driver.c                   |    7
>   drivers/vfio/mdev/mdev_private.h                  |   39 ---
>   drivers/vfio/mdev/mdev_sysfs.c                    |  230 ++++++++--------------
>   include/linux/mdev.h                              |   77 +++----
>   samples/vfio-mdev/mbochs.c                        |  103 ++-------
>   samples/vfio-mdev/mdpy.c                          |  115 ++---------
>   samples/vfio-mdev/mtty.c                          |   94 +++-----
>   20 files changed, 389 insertions(+), 887 deletions(-)

Is this series available on any github repo? I'd like to apply your series 
and apply my vfio_device cdev series on top of it.

-- 
Regards,
Yi Liu
