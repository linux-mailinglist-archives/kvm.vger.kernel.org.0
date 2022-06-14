Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35E0A54A943
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 08:15:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238746AbiFNGPG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 02:15:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232508AbiFNGPD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 02:15:03 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD720377C1;
        Mon, 13 Jun 2022 23:15:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655187300; x=1686723300;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=VHRzxdHsLOfFkFjqi9Uu3ZB7ln//w+YbBAylX9tpP2A=;
  b=UhSCb2x9G6brcCzJukCRksebURFqwv7AaNbe1/t5Q3+4vFRSnQ/eSYUx
   SMEA9aefQ2aBQMNu6TttHhdDgsnaZI0UP/Clf91WvDtIiTlSkWBvj+LUa
   z16xEUnSK0xPivlW80DczWD8SLtvsVJKlzh6Y48jjPuN3+U67W2eGgPEX
   I5hj6uXCLozm6L2MRIC+Jqkiwmvlo7ILg1BzIOhGplegesOg0AYJ5j+4i
   pJ3LFpj3ojANLE0IsWMWwjwyJj089ogNdLt7nG1Azk6r637SAS8P1WKM5
   9yIxtijhWhsdeLSZLaBmib9GbHP6BkcElOmC47SVNSlFFYB2aeqJkjd6G
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10377"; a="342485791"
X-IronPort-AV: E=Sophos;i="5.91,299,1647327600"; 
   d="scan'208";a="342485791"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2022 23:15:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,299,1647327600"; 
   d="scan'208";a="673695531"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by FMSMGA003.fm.intel.com with ESMTP; 13 Jun 2022 23:14:59 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 13 Jun 2022 23:14:59 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Mon, 13 Jun 2022 23:14:59 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.102)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Mon, 13 Jun 2022 23:14:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c9p2Md9nOqrcVdhgsWybqVoB/Rqvo9irjEI8LD8gIMpglD+Z+t8sXS+i1hVKc/PlCArQ4Z7GCtRazsZ4TFY6ljqyzOU5bAhKouOaT37zzhGs0XppBlLkttsU0sNO8W9PIa21XQiCM9cG1J3VR3vC6LAxtqkZ6WbxD2q+kl//8qaq7EH1WlmVOJIMYGvw/P6DIRHYn0wsY9GiZR7gDKfE6mvJ5j7rpFl7J6cYbPSDsdcsesWL236FWJHm2HuHMTKJGA5tsyj4qY9lPPV48KnI4nHECiHgz0e5tucCok44qde1FpVwSv7/7w9TN6W5R2EpiCrtJG1cTbxwJkISExCROA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qiuixY4QgSpzYrBnSOHtSGFtPrO3eJdRoPT9vk7QopA=;
 b=QrQiEGknArRMJhFFGEhMS8tgAKq5u1EZQfPAOQS2gVmlmyq8DtHlD+lllbVLoHdUhghSv93Q1zeAODyx60aJQ9KAlL+7yodVYlY1+/SnuoxSmpUu1fBotc/jdZVhctG35qVSqntAwFFXomsQiVkxcDEZqFes/+KWXIp3Qesx061w2vmJmgc+BMnLZiCvnJxgD668bva6/YbHLxbKxw+uEVnWqLC4JIjlieZaHogASuqmE0gGUtr46NSwLjvAtAvQX5QNfwEGOwZma07PmG0ODedTXQkiZim5CFsY5XPN/9yWjyDPrR0m5vsqWvmCEstnYQJ30Ew9FlfJVL0xdAUR1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB5658.namprd11.prod.outlook.com (2603:10b6:510:e2::23)
 by CO1PR11MB4833.namprd11.prod.outlook.com (2603:10b6:303:99::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.12; Tue, 14 Jun
 2022 06:14:57 +0000
Received: from PH0PR11MB5658.namprd11.prod.outlook.com
 ([fe80::d518:17a2:11e6:bd6]) by PH0PR11MB5658.namprd11.prod.outlook.com
 ([fe80::d518:17a2:11e6:bd6%7]) with mapi id 15.20.5314.019; Tue, 14 Jun 2022
 06:14:57 +0000
Message-ID: <a0bab1d6-7937-fc3a-0108-a997eedfda99@intel.com>
Date:   Tue, 14 Jun 2022 14:14:47 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.7.0
Subject: Re: [PATCH 03/13] vfio/mdev: simplify mdev_type handling
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
 <20220614045428.278494-4-hch@lst.de>
From:   Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <20220614045428.278494-4-hch@lst.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR01CA0176.apcprd01.prod.exchangelabs.com
 (2603:1096:4:28::32) To PH0PR11MB5658.namprd11.prod.outlook.com
 (2603:10b6:510:e2::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8fef2ffd-1478-4804-0a86-08da4dcd3474
X-MS-TrafficTypeDiagnostic: CO1PR11MB4833:EE_
X-Microsoft-Antispam-PRVS: <CO1PR11MB4833E78FB5FCCDBD98C14497C3AA9@CO1PR11MB4833.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wdEIf4AgNhQd47Z72zt4WbEDYzEVauZhww4YFRrokqw0nLUGk0RJbLXb5zryhhLvqkzG3u6du11A8ADtuQvcJnM83u0SrtSEj4JIisHQpTQRJvu9wZY5XmdTzEFiuse7JNh7pr8XtYU1BNh1zU8gL77ZdLbYl/0iNvFAHDfymEblf5lxT+OWYuUneoZFGO7SuL+Rtey4ywM1XG83kB4jLB347KXgetEqDN+uoIiSwabsriEfTEeeHxREt87JrEt56LE4mK1BeUi38SQum87LXaQfoxfbd8RsKh6PnreuIyMWvJcvEa1L3rcNgE/lV7pBM7y3W6sGoGUNupw15X32q/WOxS1+QQHsw0JGfyL7CXK3qdWMmyqrL9DhnO5CZXnRxyIRKgsDr6NZ6dw9nlToAb8QWDBJ81tbe6HDrnn4ol83PnoyMz3xF1rJOE96skgKWR3/UENI+P4pZ3Z0h80fuJNvwje97AyTp4hH0bTjvvt5yrJAfjRHzWIGKFDgZVmXbi13VOz9LJYcLtN06YBykyaYUYzlQv/9DRqQm1DVjG9x+Qx1qQziTSI9so3fifw9I+x9ksPJugH2QOlr6JiX7SQ+gE3uaw462djCPzyMxrFp6pewNqEGgGgnluWr6CzsF3J5nnKgqPGYFb4DpwZ46rUnFpeVFkFtlJU9bl5sf4KKoKc/qM5UU3KFKdvZ7bZEMKutwobjF3kWG2IRmeCujoQw2gs6TAWeCgneQxmvMbiZkwXOSrrjMmgGmL5+2fHII7AFnPiNuDl9wTGuDvgtXw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5658.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(6512007)(36756003)(26005)(38100700002)(5660300002)(31686004)(2906002)(316002)(921005)(110136005)(53546011)(186003)(83380400001)(6506007)(66556008)(31696002)(8676002)(4326008)(7416002)(66946007)(8936002)(82960400001)(86362001)(66476007)(2616005)(508600001)(6666004)(6486002)(30864003)(43740500002)(45980500001)(579004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WjZRSUk4YjJCK045VWxKN1BEd1oxYyt4VFFTcCtBZ3JQVi9DLy9ta244Si9L?=
 =?utf-8?B?UUpPR3F1UG0rMXhOdlUrYXR4SWp0Q0w4SDYyYXQxV2VwYWlVMmNRcWx6Zito?=
 =?utf-8?B?dm5INWt1T0VpR3Q2OGJUaDdtZ3lyRm00V2pqVGZQL1p0MUM5b3V2eFVHYU16?=
 =?utf-8?B?SS9EUjhnMlpNTVFUdUo2bUxVVXJNNzNmWFQvOG5HSVdDbjFNMVVRTlMvR0hX?=
 =?utf-8?B?STVSTG9PUFRlZzYyWmZheWlmSnc1NVpETWw5RUgyV0NQcUp5ait2QlJCV05C?=
 =?utf-8?B?WmxGRnFaNUUrQkg1aGZDVlAvYit1OHpxbkFLcUVaeG1TS3UyeU95dzAzZnVm?=
 =?utf-8?B?RjJBMEFIRE1tUmN2OWdBTlhZOS8rN2FnVWwvcHU4ODM2VXA0eUFJQlpDTzRm?=
 =?utf-8?B?WEx4bGlFUVI5ZHQ5ajNyY2l2c3JuNFk2SzhySGdQbE1CMW82YVFuL0RVZ2pK?=
 =?utf-8?B?ak5SY1QrRmlOOFZFWGxHc3Q0eHkzQm5aVzRyTUdtdytoWWgraUNCSnZtbjZv?=
 =?utf-8?B?Y0tLV1IvcHkveDBuRUdHUUxCdkZJZlhVYVNXbENGS3dSclBxcVp4NXZmcVhJ?=
 =?utf-8?B?SmRQRUJMbU1MQTBFTjloVGwzRkgzYnVubGp1Z1JUWXZWLy9tRmY2WjZtWVQz?=
 =?utf-8?B?S1Z5OEswK3hRMGZQU0YrQjVHZXRrT2txaFdndzZwZzNNUUN0ZmdCRG9tb1ZB?=
 =?utf-8?B?b1ZpMG5VbHZzaHpQd2M5cWpTSkVHRHZmNXBlQll0aHA1YjExbW4xNzlQcUYv?=
 =?utf-8?B?ZVNDK1hzS3k1MGY0dEI1SFRJMVlSUXZ1ajMybDVPQ1dJSHNCQ25XSGxIU3lV?=
 =?utf-8?B?K0o0NlRJVnppYkpXMjVtZTQ3bGt3V01Gd1VYTTR2TkY5V05EVjhHM0FwMEF2?=
 =?utf-8?B?Q3paTW1ndGlaNUZVY2FoODVEQ1UxU25RMGNsYnNKVG90c0ppSkJKamhlRUZz?=
 =?utf-8?B?N1BORkZpZy9VKzd0RXpyS3RDSDhTM2tLaWVMampXSEY5MWNXcW5iZE1KRlg3?=
 =?utf-8?B?RHI1NkI4R0t0THp2REVUTUwvcjdReFZWanh0UHFTVXB4VHVLcGtmN2RhY0VE?=
 =?utf-8?B?WHlQRG5reVN0blRPQ0xGeFNuaVpMSkhaWlBGckxGRGp4cTNyeUtHUm9IdDJO?=
 =?utf-8?B?b09pOVUyRDl0OUdDRkdJTG1ic2l4RVMySmVHK3QyZHJYVEs5Snc0N0JZcDhJ?=
 =?utf-8?B?dHRiSHVOMmxiM2VCbXVuSHpuQ05SdC9rcEVKWVM2Vy9JKzZqN2J0RFkvV0FH?=
 =?utf-8?B?ZUwwMGxQWm9jNjlaSnFwaU5LSks5a09JZC9LM3NxTmNCZytiTmx2Tm9FUS9h?=
 =?utf-8?B?Y3ZIajBnY1dHTkd6eVdyNmU5aFRTNWs1QTZhdnhtL3hoUHlVRk0yNFM1Zm9m?=
 =?utf-8?B?Z283MGV5UlhwWGdsaG9weS9WUmRmeDRaQmk4MElnZ0RkeEczb1BpME1uTXdV?=
 =?utf-8?B?S1MxdlB5UDVseisyYkR6bkFBS1RYbkM1VXVVWUMycVljT0RUMW91MVd6RGNJ?=
 =?utf-8?B?SmlpbzhVWWdwUG9UYlp6dGhHWkdrUjFCdVVoVVR5enlQMGtuNFdtRXp0a2Z5?=
 =?utf-8?B?V2Rzc2I0N2E1d1JoZjF3aFpEVHlwUm5Dak5TZ2dTU0RzVS96TW1qMlNIdk52?=
 =?utf-8?B?N29Eckh4VXFQL05CL0s1OVkxYzlIVEQ1QVp5V3VGWUZrckJXc0NSdG5GRHJj?=
 =?utf-8?B?ZGt2SUp6YmM2cHArNnVYM016WWZmdmtNaSswei9zWmhsdElKaDhxc3JYSm01?=
 =?utf-8?B?MkwrbGpsbnBFUGFIL0Z3MHBmOEMwUGlZSzdGMlBDb1BTaVlVSDhCeGxKd2Y5?=
 =?utf-8?B?cGpkT0lya0d3MzNYaEJiWTNaNUZKWHlXYkFsNHhiUFJkMi9NRmFaR0FYZjM0?=
 =?utf-8?B?c2k4NkNjU3Y3eXhGQVF2bjIwMERISnQrOTIva3Fhdm5nMWppK0d0Q2xmTE9r?=
 =?utf-8?B?QW1hblY5clFReVNxZWxuN1dkVW5XNEpwWXJ5eld2Z0lGK3llUHNLT2NMbWha?=
 =?utf-8?B?TE5XZkhHNGNrbUNjTTdxMWI5VG1VOHNUU1ZuL3d2MERWMldmc2NzU2Z4dlB5?=
 =?utf-8?B?REY3cDQxT1Q0YVBSVXhZQUR5VE9pQllud2N6TXpNM0NhRWRMSU9OT1ZUb1VO?=
 =?utf-8?B?UHl0dk5Fa1pmcnRybXpBK0tOZlRLNTU3M0tpZk1iZ2tBQndOVzVpWkxZUFBn?=
 =?utf-8?B?QTlETzJObFZTZjhpdi9ndEhiTHpsQUhSZVgrSTBIQnJYZ1MxVFoyOGJTR1Fq?=
 =?utf-8?B?Ynk2aTRpdFpaVWtyVExZcnRSNTMvbFV6UzJRamJ0N2Q5a1Bsa0tRRFZDRHU0?=
 =?utf-8?B?VTQvQ1BZUFJPS1BLTTlwSmdFOGphejUwSmFCV212c1Q2RG9Zd000dz09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fef2ffd-1478-4804-0a86-08da4dcd3474
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5658.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2022 06:14:57.3281
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PRubcSr9JYmWY0dpgYqMbE18sTEsLAXukv/PG1d3R0779Nh8D0MSqNJ3kxkvP2ZI+c+eQavpovMkB8lgPty/ug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4833
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

On 2022/6/14 12:54, Christoph Hellwig wrote:
> Instead of abusing struct attribute_group to control initialization of
> struct mdev_type, just define the actual attributes in the mdev_driver,
> allocate the mdev_type structures in the caller and pass them to
> mdev_register_parent.
> 
> This allows the caller to use container_of to get at the containing
> struture and thus significantly simplify the code.

s/struture/structure

> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   .../driver-api/vfio-mediated-device.rst       |   2 +-
>   drivers/gpu/drm/i915/gvt/gvt.h                |   3 +-
>   drivers/gpu/drm/i915/gvt/kvmgt.c              |  98 ++--------------
>   drivers/gpu/drm/i915/gvt/vgpu.c               |  18 ++-
>   drivers/s390/cio/cio.h                        |   2 +
>   drivers/s390/cio/vfio_ccw_ops.c               |  19 +--
>   drivers/s390/crypto/vfio_ap_ops.c             |  19 +--
>   drivers/s390/crypto/vfio_ap_private.h         |   2 +
>   drivers/vfio/mdev/mdev_core.c                 |  54 ++++-----
>   drivers/vfio/mdev/mdev_driver.c               |   5 +-
>   drivers/vfio/mdev/mdev_private.h              |  14 +--
>   drivers/vfio/mdev/mdev_sysfs.c                | 111 ++----------------
>   include/linux/mdev.h                          |  26 ++--
>   samples/vfio-mdev/mbochs.c                    |  57 ++++-----
>   samples/vfio-mdev/mdpy.c                      |  50 +++-----
>   samples/vfio-mdev/mtty.c                      |  62 +++++-----
>   16 files changed, 181 insertions(+), 361 deletions(-)
> 
> diff --git a/Documentation/driver-api/vfio-mediated-device.rst b/Documentation/driver-api/vfio-mediated-device.rst
> index 3749f59c855fa..599008bdc1dcb 100644
> --- a/Documentation/driver-api/vfio-mediated-device.rst
> +++ b/Documentation/driver-api/vfio-mediated-device.rst
> @@ -105,7 +105,7 @@ structure to represent a mediated device's driver::
>        struct mdev_driver {
>   	     int  (*probe)  (struct mdev_device *dev);
>   	     void (*remove) (struct mdev_device *dev);
> -	     struct attribute_group **supported_type_groups;
> +	     const struct attribute * const *types_attrs;
>   	     struct device_driver    driver;
>        };
>   
> diff --git a/drivers/gpu/drm/i915/gvt/gvt.h b/drivers/gpu/drm/i915/gvt/gvt.h
> index ddffd337f1c60..0ccb9bb7180cd 100644
> --- a/drivers/gpu/drm/i915/gvt/gvt.h
> +++ b/drivers/gpu/drm/i915/gvt/gvt.h
> @@ -298,7 +298,7 @@ struct intel_gvt_firmware {
>   
>   #define NR_MAX_INTEL_VGPU_TYPES 20
>   struct intel_vgpu_type {
> -	char name[16];
> +	struct mdev_type type;
>   	unsigned int avail_instance;
>   	unsigned int low_gm_size;
>   	unsigned int high_gm_size;
> @@ -329,6 +329,7 @@ struct intel_gvt {
>   	struct notifier_block shadow_ctx_notifier_block[I915_NUM_ENGINES];
>   	DECLARE_HASHTABLE(cmd_table, GVT_CMD_HASH_BITS);
>   	struct mdev_parent parent;
> +	struct mdev_type **mdev_types;
>   	struct intel_vgpu_type *types;
>   	unsigned int num_types;
>   	struct intel_vgpu *idle_vgpu;
> diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
> index 70401374c72bc..1c6b7e8bec4fb 100644
> --- a/drivers/gpu/drm/i915/gvt/kvmgt.c
> +++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
> @@ -117,17 +117,10 @@ static ssize_t available_instances_show(struct mdev_type *mtype,
>   					struct mdev_type_attribute *attr,
>   					char *buf)
>   {
> -	struct intel_vgpu_type *type;
> -	unsigned int num = 0;
> -	struct intel_gvt *gvt = kdev_to_i915(mtype_get_parent_dev(mtype))->gvt;
> +	struct intel_vgpu_type *type =
> +		container_of(mtype, struct intel_vgpu_type, type);
>   
> -	type = &gvt->types[mtype_get_type_group_id(mtype)];
> -	if (!type)
> -		num = 0;
> -	else
> -		num = type->avail_instance;
> -
> -	return sprintf(buf, "%u\n", num);
> +	return sprintf(buf, "%u\n", type->avail_instance);
>   }
>   
>   static ssize_t device_api_show(struct mdev_type *mtype,
> @@ -139,12 +132,8 @@ static ssize_t device_api_show(struct mdev_type *mtype,
>   static ssize_t description_show(struct mdev_type *mtype,
>   				struct mdev_type_attribute *attr, char *buf)
>   {
> -	struct intel_vgpu_type *type;
> -	struct intel_gvt *gvt = kdev_to_i915(mtype_get_parent_dev(mtype))->gvt;
> -
> -	type = &gvt->types[mtype_get_type_group_id(mtype)];
> -	if (!type)
> -		return 0;
> +	struct intel_vgpu_type *type =
> +		container_of(mtype, struct intel_vgpu_type, type);
>   
>   	return sprintf(buf, "low_gm_size: %dMB\nhigh_gm_size: %dMB\n"
>   		       "fence: %d\nresolution: %s\n"
> @@ -158,14 +147,7 @@ static ssize_t description_show(struct mdev_type *mtype,
>   static ssize_t name_show(struct mdev_type *mtype,
>   			 struct mdev_type_attribute *attr, char *buf)
>   {
> -	struct intel_vgpu_type *type;
> -	struct intel_gvt *gvt = kdev_to_i915(mtype_get_parent_dev(mtype))->gvt;
> -
> -	type = &gvt->types[mtype_get_type_group_id(mtype)];
> -	if (!type)
> -		return 0;
> -
> -	return sprintf(buf, "%s\n", type->name);
> +	return sprintf(buf, "%s\n", mtype->sysfs_name);
>   }
>   
>   static MDEV_TYPE_ATTR_RO(available_instances);
> @@ -173,7 +155,7 @@ static MDEV_TYPE_ATTR_RO(device_api);
>   static MDEV_TYPE_ATTR_RO(description);
>   static MDEV_TYPE_ATTR_RO(name);
>   
> -static struct attribute *gvt_type_attrs[] = {
> +static const struct attribute *gvt_type_attrs[] = {
>   	&mdev_type_attr_available_instances.attr,
>   	&mdev_type_attr_device_api.attr,
>   	&mdev_type_attr_description.attr,
> @@ -181,51 +163,6 @@ static struct attribute *gvt_type_attrs[] = {
>   	NULL,
>   };
>   
> -static struct attribute_group *gvt_vgpu_type_groups[] = {
> -	[0 ... NR_MAX_INTEL_VGPU_TYPES - 1] = NULL,
> -};
> -
> -static int intel_gvt_init_vgpu_type_groups(struct intel_gvt *gvt)
> -{
> -	int i, j;
> -	struct intel_vgpu_type *type;
> -	struct attribute_group *group;
> -
> -	for (i = 0; i < gvt->num_types; i++) {
> -		type = &gvt->types[i];
> -
> -		group = kzalloc(sizeof(struct attribute_group), GFP_KERNEL);
> -		if (!group)
> -			goto unwind;
> -
> -		group->name = type->name;
> -		group->attrs = gvt_type_attrs;
> -		gvt_vgpu_type_groups[i] = group;
> -	}
> -
> -	return 0;
> -
> -unwind:
> -	for (j = 0; j < i; j++) {
> -		group = gvt_vgpu_type_groups[j];
> -		kfree(group);
> -	}
> -
> -	return -ENOMEM;
> -}
> -
> -static void intel_gvt_cleanup_vgpu_type_groups(struct intel_gvt *gvt)
> -{
> -	int i;
> -	struct attribute_group *group;
> -
> -	for (i = 0; i < gvt->num_types; i++) {
> -		group = gvt_vgpu_type_groups[i];
> -		gvt_vgpu_type_groups[i] = NULL;
> -		kfree(group);
> -	}
> -}
> -
>   static void gvt_unpin_guest_page(struct intel_vgpu *vgpu, unsigned long gfn,
>   		unsigned long size)
>   {
> @@ -1614,14 +1551,11 @@ static int intel_vgpu_probe(struct mdev_device *mdev)
>   {
>   	struct device *pdev = mdev_parent_dev(mdev);
>   	struct intel_gvt *gvt = kdev_to_i915(pdev)->gvt;
> -	struct intel_vgpu_type *type;
> +	struct intel_vgpu_type *type =
> +		container_of(mdev->type, struct intel_vgpu_type, type);
>   	struct intel_vgpu *vgpu;
>   	int ret;
>   
> -	type = &gvt->types[mdev_get_type_group_id(mdev)];
> -	if (!type)
> -		return -EINVAL;
> -
>   	vgpu = intel_gvt_create_vgpu(gvt, type);
>   	if (IS_ERR(vgpu)) {
>   		gvt_err("failed to create intel vgpu: %ld\n", PTR_ERR(vgpu));
> @@ -1660,7 +1594,7 @@ static struct mdev_driver intel_vgpu_mdev_driver = {
>   	},
>   	.probe		= intel_vgpu_probe,
>   	.remove		= intel_vgpu_remove,
> -	.supported_type_groups	= gvt_vgpu_type_groups,
> +	.types_attrs	= gvt_type_attrs,
>   };
>   
>   int intel_gvt_page_track_add(struct intel_vgpu *info, u64 gfn)
> @@ -1959,7 +1893,6 @@ static void intel_gvt_clean_device(struct drm_i915_private *i915)
>   		return;
>   
>   	mdev_unregister_parent(&gvt->parent);
> -	intel_gvt_cleanup_vgpu_type_groups(gvt);
>   	intel_gvt_destroy_idle_vgpu(gvt->idle_vgpu);
>   	intel_gvt_clean_vgpu_types(gvt);
>   
> @@ -2059,20 +1992,15 @@ static int intel_gvt_init_device(struct drm_i915_private *i915)
>   
>   	intel_gvt_debugfs_init(gvt);
>   
> -	ret = intel_gvt_init_vgpu_type_groups(gvt);
> -	if (ret)
> -		goto out_destroy_idle_vgpu;
> -
>   	ret = mdev_register_parent(&gvt->parent, i915->drm.dev,
> -				   &intel_vgpu_mdev_driver);
> +				   &intel_vgpu_mdev_driver,
> +				   gvt->mdev_types, gvt->num_types);
>   	if (ret)
> -		goto out_cleanup_vgpu_type_groups;
> +		goto out_destroy_idle_vgpu;
>   
>   	gvt_dbg_core("gvt device initialization is done\n");
>   	return 0;
>   
> -out_cleanup_vgpu_type_groups:
> -	intel_gvt_cleanup_vgpu_type_groups(gvt);
>   out_destroy_idle_vgpu:
>   	intel_gvt_destroy_idle_vgpu(gvt->idle_vgpu);
>   	intel_gvt_debugfs_clean(gvt);
> diff --git a/drivers/gpu/drm/i915/gvt/vgpu.c b/drivers/gpu/drm/i915/gvt/vgpu.c
> index 46da19b3225d2..2f38b90ecb8ac 100644
> --- a/drivers/gpu/drm/i915/gvt/vgpu.c
> +++ b/drivers/gpu/drm/i915/gvt/vgpu.c
> @@ -131,6 +131,13 @@ int intel_gvt_init_vgpu_types(struct intel_gvt *gvt)
>   	if (!gvt->types)
>   		return -ENOMEM;
>   
> +	gvt->mdev_types = kcalloc(num_types, sizeof(*gvt->mdev_types),
> +			     GFP_KERNEL);
> +	if (!gvt->mdev_types) {
> +		kfree(gvt->types);
> +		return -ENOMEM;
> +	}
> +
>   	min_low = MB_TO_BYTES(32);
>   	for (i = 0; i < num_types; ++i) {
>   		if (low_avail / vgpu_types[i].low_mm == 0)
> @@ -150,19 +157,21 @@ int intel_gvt_init_vgpu_types(struct intel_gvt *gvt)
>   						   high_avail / vgpu_types[i].high_mm);
>   
>   		if (GRAPHICS_VER(gvt->gt->i915) == 8)
> -			sprintf(gvt->types[i].name, "GVTg_V4_%s",
> +			sprintf(gvt->types[i].type.sysfs_name, "GVTg_V4_%s",
>   				vgpu_types[i].name);
>   		else if (GRAPHICS_VER(gvt->gt->i915) == 9)
> -			sprintf(gvt->types[i].name, "GVTg_V5_%s",
> +			sprintf(gvt->types[i].type.sysfs_name, "GVTg_V5_%s",
>   				vgpu_types[i].name);
>   
>   		gvt_dbg_core("type[%d]: %s avail %u low %u high %u fence %u weight %u res %s\n",
> -			     i, gvt->types[i].name,
> +			     i, gvt->types[i].type.sysfs_name,
>   			     gvt->types[i].avail_instance,
>   			     gvt->types[i].low_gm_size,
>   			     gvt->types[i].high_gm_size, gvt->types[i].fence,
>   			     gvt->types[i].weight,
>   			     vgpu_edid_str(gvt->types[i].resolution));
> +
> +		gvt->mdev_types[i] = &gvt->types[i].type;
>   	}
>   
>   	gvt->num_types = i;
> @@ -171,6 +180,7 @@ int intel_gvt_init_vgpu_types(struct intel_gvt *gvt)
>   
>   void intel_gvt_clean_vgpu_types(struct intel_gvt *gvt)
>   {
> +	kfree(gvt->mdev_types);
>   	kfree(gvt->types);
>   }
>   
> @@ -198,7 +208,7 @@ static void intel_gvt_update_vgpu_types(struct intel_gvt *gvt)
>   						   fence_min);
>   
>   		gvt_dbg_core("update type[%d]: %s avail %u low %u high %u fence %u\n",
> -		       i, gvt->types[i].name,
> +		       i, gvt->types[i].type.sysfs_name,
>   		       gvt->types[i].avail_instance, gvt->types[i].low_gm_size,
>   		       gvt->types[i].high_gm_size, gvt->types[i].fence);
>   	}
> diff --git a/drivers/s390/cio/cio.h b/drivers/s390/cio/cio.h
> index 22be5ac7d23c1..1da45307a1862 100644
> --- a/drivers/s390/cio/cio.h
> +++ b/drivers/s390/cio/cio.h
> @@ -110,6 +110,8 @@ struct subchannel {
>   	 */
>   	const char *driver_override;
>   	struct mdev_parent parent;
> +	struct mdev_type mdev_type;
> +	struct mdev_type *mdev_types[1];
>   } __attribute__ ((aligned(8)));
>   
>   DECLARE_PER_CPU_ALIGNED(struct irb, cio_irb);
> diff --git a/drivers/s390/cio/vfio_ccw_ops.c b/drivers/s390/cio/vfio_ccw_ops.c
> index 9192a21085ce4..25b8d42a522ac 100644
> --- a/drivers/s390/cio/vfio_ccw_ops.c
> +++ b/drivers/s390/cio/vfio_ccw_ops.c
> @@ -95,23 +95,13 @@ static ssize_t available_instances_show(struct mdev_type *mtype,
>   }
>   static MDEV_TYPE_ATTR_RO(available_instances);
>   
> -static struct attribute *mdev_types_attrs[] = {
> +static const struct attribute *mdev_types_attrs[] = {
>   	&mdev_type_attr_name.attr,
>   	&mdev_type_attr_device_api.attr,
>   	&mdev_type_attr_available_instances.attr,
>   	NULL,
>   };
>   
> -static struct attribute_group mdev_type_group = {
> -	.name  = "io",
> -	.attrs = mdev_types_attrs,
> -};
> -
> -static struct attribute_group *mdev_type_groups[] = {
> -	&mdev_type_group,
> -	NULL,
> -};
> -
>   static int vfio_ccw_mdev_probe(struct mdev_device *mdev)
>   {
>   	struct vfio_ccw_private *private = dev_get_drvdata(mdev->dev.parent);
> @@ -654,13 +644,16 @@ struct mdev_driver vfio_ccw_mdev_driver = {
>   	},
>   	.probe = vfio_ccw_mdev_probe,
>   	.remove = vfio_ccw_mdev_remove,
> -	.supported_type_groups  = mdev_type_groups,
> +	.types_attrs = mdev_types_attrs,
>   };
>   
>   int vfio_ccw_mdev_reg(struct subchannel *sch)
>   {
> +	sprintf(sch->mdev_type.sysfs_name, "io");
> +	sch->mdev_types[0] = &sch->mdev_type;
>   	return mdev_register_parent(&sch->parent, &sch->dev,
> -				    &vfio_ccw_mdev_driver);
> +				    &vfio_ccw_mdev_driver, sch->mdev_types,
> +				    1);
>   }
>   
>   void vfio_ccw_mdev_unreg(struct subchannel *sch)
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> index 834945150dc9f..ff25858b2ebbe 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -537,23 +537,13 @@ static ssize_t device_api_show(struct mdev_type *mtype,
>   
>   static MDEV_TYPE_ATTR_RO(device_api);
>   
> -static struct attribute *vfio_ap_mdev_type_attrs[] = {
> +static const struct attribute *vfio_ap_mdev_type_attrs[] = {
>   	&mdev_type_attr_name.attr,
>   	&mdev_type_attr_device_api.attr,
>   	&mdev_type_attr_available_instances.attr,
>   	NULL,
>   };
>   
> -static struct attribute_group vfio_ap_mdev_hwvirt_type_group = {
> -	.name = VFIO_AP_MDEV_TYPE_HWVIRT,
> -	.attrs = vfio_ap_mdev_type_attrs,
> -};
> -
> -static struct attribute_group *vfio_ap_mdev_type_groups[] = {
> -	&vfio_ap_mdev_hwvirt_type_group,
> -	NULL,
> -};
> -
>   struct vfio_ap_queue_reserved {
>   	unsigned long *apid;
>   	unsigned long *apqi;
> @@ -1472,7 +1462,7 @@ static struct mdev_driver vfio_ap_matrix_driver = {
>   	},
>   	.probe = vfio_ap_mdev_probe,
>   	.remove = vfio_ap_mdev_remove,
> -	.supported_type_groups = vfio_ap_mdev_type_groups,
> +	.types_attrs = vfio_ap_mdev_type_attrs,
>   };
>   
>   int vfio_ap_mdev_register(void)
> @@ -1485,8 +1475,11 @@ int vfio_ap_mdev_register(void)
>   	if (ret)
>   		return ret;
>   
> +	strcpy(matrix_dev->mdev_type.sysfs_name, VFIO_AP_MDEV_TYPE_HWVIRT);
> +	matrix_dev->mdev_types[0] = &matrix_dev->mdev_type;
>   	ret = mdev_register_parent(&matrix_dev->parent, &matrix_dev->device,
> -				   &vfio_ap_matrix_driver);
> +				   &vfio_ap_matrix_driver,
> +				   matrix_dev->mdev_types, 1);
>   	if (ret)
>   		goto err_driver;
>   	return 0;
> diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
> index 0191f6bc973a4..5dc5050d03791 100644
> --- a/drivers/s390/crypto/vfio_ap_private.h
> +++ b/drivers/s390/crypto/vfio_ap_private.h
> @@ -46,6 +46,8 @@ struct ap_matrix_dev {
>   	struct mutex lock;
>   	struct ap_driver  *vfio_ap_drv;
>   	struct mdev_parent parent;
> +	struct mdev_type mdev_type;
> +	struct mdev_type *mdev_types[];
>   };
>   
>   extern struct ap_matrix_dev *matrix_dev;
> diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
> index d38faed14c689..71c7f4e521a74 100644
> --- a/drivers/vfio/mdev/mdev_core.c
> +++ b/drivers/vfio/mdev/mdev_core.c
> @@ -29,26 +29,6 @@ struct device *mdev_parent_dev(struct mdev_device *mdev)
>   }
>   EXPORT_SYMBOL(mdev_parent_dev);
>   
> -/*
> - * Return the index in supported_type_groups that this mdev_device was created
> - * from.
> - */
> -unsigned int mdev_get_type_group_id(struct mdev_device *mdev)
> -{
> -	return mdev->type->type_group_id;
> -}
> -EXPORT_SYMBOL(mdev_get_type_group_id);
> -
> -/*
> - * Used in mdev_type_attribute sysfs functions to return the index in the
> - * supported_type_groups that the sysfs is called from.
> - */
> -unsigned int mtype_get_type_group_id(struct mdev_type *mtype)
> -{
> -	return mtype->type_group_id;
> -}
> -EXPORT_SYMBOL(mtype_get_type_group_id);
> -
>   /*
>    * Used in mdev_type_attribute sysfs functions to return the parent struct
>    * device
> @@ -85,19 +65,19 @@ static int mdev_device_remove_cb(struct device *dev, void *data)
>    * @parent: parent structure registered
>    * @dev: device structure representing parent device.
>    * @mdev_driver: Device driver to bind to the newly created mdev
> + * @types: Array of supported mdev types
> + * @nr_types: Number of entries in @types
>    *
>    * Returns a negative value on error, otherwise 0.
>    */
>   int mdev_register_parent(struct mdev_parent *parent, struct device *dev,
> -		struct mdev_driver *mdev_driver)
> +		struct mdev_driver *mdev_driver, struct mdev_type **types,
> +		unsigned int nr_types)
>   {
>   	char *env_string = "MDEV_STATE=registered";
>   	char *envp[] = { env_string, NULL };
>   	int ret;
> -
> -	/* check for mandatory ops */
> -	if (!mdev_driver->supported_type_groups)
> -		return -EINVAL;
> +	int i;
>   
>   	memset(parent, 0, sizeof(*parent));
>   	init_rwsem(&parent->unreg_sem);
> @@ -110,9 +90,23 @@ int mdev_register_parent(struct mdev_parent *parent, struct device *dev,
>   			return -ENOMEM;
>   	}
>   
> -	ret = parent_create_sysfs_files(parent);
> -	if (ret)
> +	parent->mdev_types_kset = kset_create_and_add("mdev_supported_types",
> +					       NULL, &parent->dev->kobj);
> +	if (!parent->mdev_types_kset)
> +		return -ENOMEM;
> +
> +	for (i = 0; i < nr_types; i++) {
> +		ret = mdev_type_add(parent, types[i]);
> +		if (ret)
> +			break;
> +	}
> +	parent->types = types;
> +	parent->nr_types = i;
> +
> +	if (ret) {
> +		mdev_unregister_parent(parent);
>   		return ret;
> +	}
>   
>   	ret = class_compat_create_link(mdev_bus_compat_class, dev, NULL);
>   	if (ret)
> @@ -132,13 +126,17 @@ void mdev_unregister_parent(struct mdev_parent *parent)
>   {
>   	char *env_string = "MDEV_STATE=unregistered";
>   	char *envp[] = { env_string, NULL };
> +	int i;
>   
>   	dev_info(parent->dev, "MDEV: Unregistering\n");
>   
> +	for (i = 0; i < parent->nr_types; i++)
> +		mdev_type_remove(parent->types[i]);
> +									

trailing spaces.

>   	down_write(&parent->unreg_sem);
>   	class_compat_remove_link(mdev_bus_compat_class, parent->dev, NULL);
>   	device_for_each_child(parent->dev, NULL, mdev_device_remove_cb);
> -	parent_remove_sysfs_files(parent);
> +	kset_unregister(parent->mdev_types_kset);
>   	up_write(&parent->unreg_sem);
>   
>   	kobject_uevent_env(&parent->dev->kobj, KOBJ_CHANGE, envp);
> diff --git a/drivers/vfio/mdev/mdev_driver.c b/drivers/vfio/mdev/mdev_driver.c
> index 7bd4bb9850e81..1da1ecf76a0d5 100644
> --- a/drivers/vfio/mdev/mdev_driver.c
> +++ b/drivers/vfio/mdev/mdev_driver.c
> @@ -56,10 +56,9 @@ EXPORT_SYMBOL_GPL(mdev_bus_type);
>    **/
>   int mdev_register_driver(struct mdev_driver *drv)
>   {
> -	/* initialize common driver fields */
> +	if (!drv->types_attrs)
> +		return -EINVAL;
>   	drv->driver.bus = &mdev_bus_type;
> -
> -	/* register with core */
>   	return driver_register(&drv->driver);
>   }
>   EXPORT_SYMBOL(mdev_register_driver);
> diff --git a/drivers/vfio/mdev/mdev_private.h b/drivers/vfio/mdev/mdev_private.h
> index 297f911fdc890..6980f504018f3 100644
> --- a/drivers/vfio/mdev/mdev_private.h
> +++ b/drivers/vfio/mdev/mdev_private.h
> @@ -13,14 +13,6 @@
>   int  mdev_bus_register(void);
>   void mdev_bus_unregister(void);
>   
> -struct mdev_type {
> -	struct kobject kobj;
> -	struct kobject *devices_kobj;
> -	struct mdev_parent *parent;
> -	struct list_head next;
> -	unsigned int type_group_id;
> -};
> -
>   extern const struct attribute_group *mdev_device_groups[];
>   
>   #define to_mdev_type_attr(_attr)	\
> @@ -28,12 +20,12 @@ extern const struct attribute_group *mdev_device_groups[];
>   #define to_mdev_type(_kobj)		\
>   	container_of(_kobj, struct mdev_type, kobj)
>   
> -int  parent_create_sysfs_files(struct mdev_parent *parent);
> -void parent_remove_sysfs_files(struct mdev_parent *parent);
> -
>   int  mdev_create_sysfs_files(struct mdev_device *mdev);
>   void mdev_remove_sysfs_files(struct mdev_device *mdev);
>   
> +int mdev_type_add(struct mdev_parent *parent, struct mdev_type *type);
> +void mdev_type_remove(struct mdev_type *type);
> +
>   int mdev_device_create(struct mdev_type *kobj, const guid_t *uuid);
>   int  mdev_device_remove(struct mdev_device *dev);
>   
> diff --git a/drivers/vfio/mdev/mdev_sysfs.c b/drivers/vfio/mdev/mdev_sysfs.c
> index b71ffc5594870..09745e8e120f9 100644
> --- a/drivers/vfio/mdev/mdev_sysfs.c
> +++ b/drivers/vfio/mdev/mdev_sysfs.c
> @@ -80,8 +80,6 @@ static void mdev_type_release(struct kobject *kobj)
>   	struct mdev_type *type = to_mdev_type(kobj);
>   
>   	pr_debug("Releasing group %s\n", kobj->name);
> -	/* Pairs with the get in add_mdev_supported_type() */
> -	put_device(type->parent->dev);
>   	kfree(type);
>   }
>   
> @@ -90,36 +88,17 @@ static struct kobj_type mdev_type_ktype = {
>   	.release = mdev_type_release,
>   };
>   
> -static struct mdev_type *add_mdev_supported_type(struct mdev_parent *parent,
> -						 unsigned int type_group_id)
> +int mdev_type_add(struct mdev_parent *parent, struct mdev_type *type)
>   {
> -	struct mdev_type *type;
> -	struct attribute_group *group =
> -		parent->mdev_driver->supported_type_groups[type_group_id];
>   	int ret;
>   
> -	if (!group->name) {
> -		pr_err("%s: Type name empty!\n", __func__);
> -		return ERR_PTR(-EINVAL);
> -	}
> -
> -	type = kzalloc(sizeof(*type), GFP_KERNEL);
> -	if (!type)
> -		return ERR_PTR(-ENOMEM);
> -
> -	type->kobj.kset = parent->mdev_types_kset;
>   	type->parent = parent;
> -	/* Pairs with the put in mdev_type_release() */
> -	get_device(parent->dev);
> -	type->type_group_id = type_group_id;
> -
> -	ret = kobject_init_and_add(&type->kobj, &mdev_type_ktype, NULL,
> -				   "%s-%s", dev_driver_string(parent->dev),
> -				   group->name);
> -	if (ret) {
> -		kobject_put(&type->kobj);
> -		return ERR_PTR(ret);
> -	}
> +	type->kobj.kset = parent->mdev_types_kset;
> +	ret = kobject_init_and_add(&type->kobj, &mdev_type_ktype, NULL, "%s-%s",
> +				   dev_driver_string(parent->dev),
> +				   type->sysfs_name);
> +	if (ret)
> +		return ret;
>   
>   	ret = sysfs_create_file(&type->kobj, &mdev_type_attr_create.attr);
>   	if (ret)
> @@ -131,13 +110,10 @@ static struct mdev_type *add_mdev_supported_type(struct mdev_parent *parent,
>   		goto attr_devices_failed;
>   	}
>   
> -	ret = sysfs_create_files(&type->kobj,
> -				 (const struct attribute **)group->attrs);
> -	if (ret) {
> -		ret = -ENOMEM;
> +	ret = sysfs_create_files(&type->kobj, parent->mdev_driver->types_attrs);
> +	if (ret)
>   		goto attrs_failed;
> -	}
> -	return type;
> +	return 0;
>   
>   attrs_failed:
>   	kobject_put(type->devices_kobj);
> @@ -146,80 +122,19 @@ static struct mdev_type *add_mdev_supported_type(struct mdev_parent *parent,
>   attr_create_failed:
>   	kobject_del(&type->kobj);
>   	kobject_put(&type->kobj);
> -	return ERR_PTR(ret);
> +	return ret;
>   }
>   
> -static void remove_mdev_supported_type(struct mdev_type *type)
> +void mdev_type_remove(struct mdev_type *type)
>   {
> -	struct attribute_group *group =
> -		type->parent->mdev_driver->supported_type_groups[type->type_group_id];
> +	sysfs_remove_files(&type->kobj, type->parent->mdev_driver->types_attrs);
>   
> -	sysfs_remove_files(&type->kobj,
> -			   (const struct attribute **)group->attrs);
>   	kobject_put(type->devices_kobj);
>   	sysfs_remove_file(&type->kobj, &mdev_type_attr_create.attr);
>   	kobject_del(&type->kobj);
>   	kobject_put(&type->kobj);
>   }
>   
> -static int add_mdev_supported_type_groups(struct mdev_parent *parent)
> -{
> -	int i;
> -
> -	for (i = 0; parent->mdev_driver->supported_type_groups[i]; i++) {
> -		struct mdev_type *type;
> -
> -		type = add_mdev_supported_type(parent, i);
> -		if (IS_ERR(type)) {
> -			struct mdev_type *ltype, *tmp;
> -
> -			list_for_each_entry_safe(ltype, tmp, &parent->type_list,
> -						  next) {
> -				list_del(&ltype->next);
> -				remove_mdev_supported_type(ltype);
> -			}
> -			return PTR_ERR(type);
> -		}
> -		list_add(&type->next, &parent->type_list);
> -	}
> -	return 0;
> -}
> -
> -/* mdev sysfs functions */
> -void parent_remove_sysfs_files(struct mdev_parent *parent)
> -{
> -	struct mdev_type *type, *tmp;
> -
> -	list_for_each_entry_safe(type, tmp, &parent->type_list, next) {
> -		list_del(&type->next);
> -		remove_mdev_supported_type(type);
> -	}
> -
> -	kset_unregister(parent->mdev_types_kset);
> -}
> -
> -int parent_create_sysfs_files(struct mdev_parent *parent)
> -{
> -	int ret;
> -
> -	parent->mdev_types_kset = kset_create_and_add("mdev_supported_types",
> -					       NULL, &parent->dev->kobj);
> -
> -	if (!parent->mdev_types_kset)
> -		return -ENOMEM;
> -
> -	INIT_LIST_HEAD(&parent->type_list);
> -
> -	ret = add_mdev_supported_type_groups(parent);
> -	if (ret)
> -		goto create_err;
> -	return 0;
> -
> -create_err:
> -	kset_unregister(parent->mdev_types_kset);
> -	return ret;
> -}
> -
>   static ssize_t remove_store(struct device *dev, struct device_attribute *attr,
>   			    const char *buf, size_t count)
>   {
> diff --git a/include/linux/mdev.h b/include/linux/mdev.h
> index 327ce3e5c6b5f..d28ddf0f561a0 100644
> --- a/include/linux/mdev.h
> +++ b/include/linux/mdev.h
> @@ -23,14 +23,27 @@ struct mdev_device {
>   	bool active;
>   };
>   
> +struct mdev_type {
> +	/* set by the driver before calling mdev_register parent: */
> +	char sysfs_name[32];
> +
> +	/* set by the core, can be used drivers */
> +	struct mdev_parent *parent;
> +
> +	/* internal only */
> +	struct kobject kobj;
> +	struct kobject *devices_kobj;
> +};
> +
>   /* embedded into the struct device that the mdev devices hang off */
>   struct mdev_parent {
>   	struct device *dev;
>   	struct mdev_driver *mdev_driver;
>   	struct kset *mdev_types_kset;
> -	struct list_head type_list;
>   	/* Synchronize device creation/removal with parent unregistration */
>   	struct rw_semaphore unreg_sem;
> +	struct mdev_type **types;
> +	unsigned int nr_types;
>   };
>   
>   static inline struct mdev_device *to_mdev_device(struct device *dev)
> @@ -38,8 +51,6 @@ static inline struct mdev_device *to_mdev_device(struct device *dev)
>   	return container_of(dev, struct mdev_device, dev);
>   }
>   
> -unsigned int mdev_get_type_group_id(struct mdev_device *mdev);
> -unsigned int mtype_get_type_group_id(struct mdev_type *mtype);
>   struct device *mtype_get_parent_dev(struct mdev_type *mtype);
>   
>   /* interface for exporting mdev supported type attributes */
> @@ -66,15 +77,13 @@ struct mdev_type_attribute mdev_type_attr_##_name =		\
>    * struct mdev_driver - Mediated device driver
>    * @probe: called when new device created
>    * @remove: called when device removed
> - * @supported_type_groups: Attributes to define supported types. It is mandatory
> - *			to provide supported types.
> + * @types_attrs: attributes to the type kobjects.
>    * @driver: device driver structure
> - *
>    **/
>   struct mdev_driver {
>   	int (*probe)(struct mdev_device *dev);
>   	void (*remove)(struct mdev_device *dev);
> -	struct attribute_group **supported_type_groups;
> +	const struct attribute * const *types_attrs;
>   	struct device_driver driver;
>   };
>   
> @@ -86,7 +95,8 @@ static inline const guid_t *mdev_uuid(struct mdev_device *mdev)
>   extern struct bus_type mdev_bus_type;
>   
>   int mdev_register_parent(struct mdev_parent *parent, struct device *dev,
> -		struct mdev_driver *mdev_driver);
> +		struct mdev_driver *mdev_driver, struct mdev_type **types,
> +		unsigned int nr_types);
>   void mdev_unregister_parent(struct mdev_parent *parent);
>   
>   int mdev_register_driver(struct mdev_driver *drv);
> diff --git a/samples/vfio-mdev/mbochs.c b/samples/vfio-mdev/mbochs.c
> index 30b3643b3b389..1069f561cb012 100644
> --- a/samples/vfio-mdev/mbochs.c
> +++ b/samples/vfio-mdev/mbochs.c
> @@ -99,23 +99,27 @@ MODULE_PARM_DESC(mem, "megabytes available to " MBOCHS_NAME " devices");
>   #define MBOCHS_TYPE_2 "medium"
>   #define MBOCHS_TYPE_3 "large"
>   
> -static const struct mbochs_type {
> +static struct mbochs_type {
> +	struct mdev_type type;
>   	const char *name;
>   	u32 mbytes;
>   	u32 max_x;
>   	u32 max_y;
>   } mbochs_types[] = {
>   	{
> +		.type.sysfs_name	= MBOCHS_TYPE_1,
>   		.name	= MBOCHS_CLASS_NAME "-" MBOCHS_TYPE_1,
>   		.mbytes = 4,
>   		.max_x  = 800,
>   		.max_y  = 600,
>   	}, {
> +		.type.sysfs_name	= MBOCHS_TYPE_2,
>   		.name	= MBOCHS_CLASS_NAME "-" MBOCHS_TYPE_2,
>   		.mbytes = 16,
>   		.max_x  = 1920,
>   		.max_y  = 1440,
>   	}, {
> +		.type.sysfs_name	= MBOCHS_TYPE_3,
>   		.name	= MBOCHS_CLASS_NAME "-" MBOCHS_TYPE_3,
>   		.mbytes = 64,
>   		.max_x  = 0,
> @@ -123,6 +127,11 @@ static const struct mbochs_type {
>   	},
>   };
>   
> +static struct mdev_type *mbochs_mdev_types[] = {
> +	&mbochs_types[0].type,
> +	&mbochs_types[1].type,
> +	&mbochs_types[2].type,
> +};
>   
>   static dev_t		mbochs_devt;
>   static struct class	*mbochs_class;
> @@ -508,8 +517,8 @@ static int mbochs_reset(struct mdev_state *mdev_state)
>   static int mbochs_probe(struct mdev_device *mdev)
>   {
>   	int avail_mbytes = atomic_read(&mbochs_avail_mbytes);
> -	const struct mbochs_type *type =
> -		&mbochs_types[mdev_get_type_group_id(mdev)];
> +	struct mbochs_type *type =
> +		container_of(mdev->type, struct mbochs_type, type);
>   	struct device *dev = mdev_dev(mdev);
>   	struct mdev_state *mdev_state;
>   	int ret = -ENOMEM;
> @@ -1328,8 +1337,8 @@ static const struct attribute_group *mdev_dev_groups[] = {
>   static ssize_t name_show(struct mdev_type *mtype,
>   			 struct mdev_type_attribute *attr, char *buf)
>   {
> -	const struct mbochs_type *type =
> -		&mbochs_types[mtype_get_type_group_id(mtype)];
> +	struct mbochs_type *type =
> +		container_of(mtype, struct mbochs_type, type);
>   
>   	return sprintf(buf, "%s\n", type->name);
>   }
> @@ -1338,8 +1347,8 @@ static MDEV_TYPE_ATTR_RO(name);
>   static ssize_t description_show(struct mdev_type *mtype,
>   				struct mdev_type_attribute *attr, char *buf)
>   {
> -	const struct mbochs_type *type =
> -		&mbochs_types[mtype_get_type_group_id(mtype)];
> +	struct mbochs_type *type =
> +		container_of(mtype, struct mbochs_type, type);
>   
>   	return sprintf(buf, "virtual display, %d MB video memory\n",
>   		       type ? type->mbytes  : 0);
> @@ -1350,8 +1359,8 @@ static ssize_t available_instances_show(struct mdev_type *mtype,
>   					struct mdev_type_attribute *attr,
>   					char *buf)
>   {
> -	const struct mbochs_type *type =
> -		&mbochs_types[mtype_get_type_group_id(mtype)];
> +	struct mbochs_type *type =
> +		container_of(mtype, struct mbochs_type, type);
>   	int count = atomic_read(&mbochs_avail_mbytes) / type->mbytes;
>   
>   	return sprintf(buf, "%d\n", count);
> @@ -1365,7 +1374,7 @@ static ssize_t device_api_show(struct mdev_type *mtype,
>   }
>   static MDEV_TYPE_ATTR_RO(device_api);
>   
> -static struct attribute *mdev_types_attrs[] = {
> +static const struct attribute *mdev_types_attrs[] = {
>   	&mdev_type_attr_name.attr,
>   	&mdev_type_attr_description.attr,
>   	&mdev_type_attr_device_api.attr,
> @@ -1373,28 +1382,6 @@ static struct attribute *mdev_types_attrs[] = {
>   	NULL,
>   };
>   
> -static struct attribute_group mdev_type_group1 = {
> -	.name  = MBOCHS_TYPE_1,
> -	.attrs = mdev_types_attrs,
> -};
> -
> -static struct attribute_group mdev_type_group2 = {
> -	.name  = MBOCHS_TYPE_2,
> -	.attrs = mdev_types_attrs,
> -};
> -
> -static struct attribute_group mdev_type_group3 = {
> -	.name  = MBOCHS_TYPE_3,
> -	.attrs = mdev_types_attrs,
> -};
> -
> -static struct attribute_group *mdev_type_groups[] = {
> -	&mdev_type_group1,
> -	&mdev_type_group2,
> -	&mdev_type_group3,
> -	NULL,
> -};
> -
>   static const struct vfio_device_ops mbochs_dev_ops = {
>   	.close_device = mbochs_close_device,
>   	.read = mbochs_read,
> @@ -1412,7 +1399,7 @@ static struct mdev_driver mbochs_driver = {
>   	},
>   	.probe = mbochs_probe,
>   	.remove	= mbochs_remove,
> -	.supported_type_groups = mdev_type_groups,
> +	.types_attrs = mdev_types_attrs,
>   };
>   
>   static const struct file_operations vd_fops = {
> @@ -1457,7 +1444,9 @@ static int __init mbochs_dev_init(void)
>   	if (ret)
>   		goto err_class;
>   
> -	ret = mdev_register_parent(&mbochs_parent, &mbochs_dev, &mbochs_driver);
> +	ret = mdev_register_parent(&mbochs_parent, &mbochs_dev, &mbochs_driver,
> +				   mbochs_mdev_types,
> +				   ARRAY_SIZE(mbochs_mdev_types));
>   	if (ret)
>   		goto err_device;
>   
> diff --git a/samples/vfio-mdev/mdpy.c b/samples/vfio-mdev/mdpy.c
> index 132bb055628a6..40b1c8a58157c 100644
> --- a/samples/vfio-mdev/mdpy.c
> +++ b/samples/vfio-mdev/mdpy.c
> @@ -51,7 +51,8 @@ MODULE_PARM_DESC(count, "number of " MDPY_NAME " devices");
>   #define MDPY_TYPE_2 "xga"
>   #define MDPY_TYPE_3 "hd"
>   
> -static const struct mdpy_type {
> +static struct mdpy_type {
> +	struct mdev_type type;
>   	const char *name;
>   	u32 format;
>   	u32 bytepp;
> @@ -59,18 +60,21 @@ static const struct mdpy_type {
>   	u32 height;
>   } mdpy_types[] = {
>   	{
> +		.type.sysfs_name 	= MDPY_TYPE_1,
>   		.name	= MDPY_CLASS_NAME "-" MDPY_TYPE_1,
>   		.format = DRM_FORMAT_XRGB8888,
>   		.bytepp = 4,
>   		.width	= 640,
>   		.height = 480,
>   	}, {
> +		.type.sysfs_name 	= MDPY_TYPE_2,
>   		.name	= MDPY_CLASS_NAME "-" MDPY_TYPE_2,
>   		.format = DRM_FORMAT_XRGB8888,
>   		.bytepp = 4,
>   		.width	= 1024,
>   		.height = 768,
>   	}, {
> +		.type.sysfs_name 	= MDPY_TYPE_3,
>   		.name	= MDPY_CLASS_NAME "-" MDPY_TYPE_3,
>   		.format = DRM_FORMAT_XRGB8888,
>   		.bytepp = 4,
> @@ -78,6 +82,12 @@ static const struct mdpy_type {
>   		.height = 1080,
>   	},
>   };
> +	

trailing spaces.

> +static struct mdev_type *mdpy_mdev_types[] = {
> +	&mdpy_types[0].type,
> +	&mdpy_types[1].type,
> +	&mdpy_types[2].type,
> +};
>   
>   static dev_t		mdpy_devt;
>   static struct class	*mdpy_class;
> @@ -219,7 +229,7 @@ static int mdpy_reset(struct mdev_state *mdev_state)
>   static int mdpy_probe(struct mdev_device *mdev)
>   {
>   	const struct mdpy_type *type =
> -		&mdpy_types[mdev_get_type_group_id(mdev)];
> +		container_of(mdev->type, struct mdpy_type, type);
>   	struct device *dev = mdev_dev(mdev);
>   	struct mdev_state *mdev_state;
>   	u32 fbsize;
> @@ -644,8 +654,7 @@ static const struct attribute_group *mdev_dev_groups[] = {
>   static ssize_t name_show(struct mdev_type *mtype,
>   			 struct mdev_type_attribute *attr, char *buf)
>   {
> -	const struct mdpy_type *type =
> -		&mdpy_types[mtype_get_type_group_id(mtype)];
> +	struct mdpy_type *type = container_of(mtype, struct mdpy_type, type);
>   
>   	return sprintf(buf, "%s\n", type->name);
>   }
> @@ -654,8 +663,7 @@ static MDEV_TYPE_ATTR_RO(name);
>   static ssize_t description_show(struct mdev_type *mtype,
>   				struct mdev_type_attribute *attr, char *buf)
>   {
> -	const struct mdpy_type *type =
> -		&mdpy_types[mtype_get_type_group_id(mtype)];
> +	struct mdpy_type *type = container_of(mtype, struct mdpy_type, type);
>   
>   	return sprintf(buf, "virtual display, %dx%d framebuffer\n",
>   		       type->width, type->height);
> @@ -677,7 +685,7 @@ static ssize_t device_api_show(struct mdev_type *mtype,
>   }
>   static MDEV_TYPE_ATTR_RO(device_api);
>   
> -static struct attribute *mdev_types_attrs[] = {
> +static const struct attribute *mdev_types_attrs[] = {
>   	&mdev_type_attr_name.attr,
>   	&mdev_type_attr_description.attr,
>   	&mdev_type_attr_device_api.attr,
> @@ -685,28 +693,6 @@ static struct attribute *mdev_types_attrs[] = {
>   	NULL,
>   };
>   
> -static struct attribute_group mdev_type_group1 = {
> -	.name  = MDPY_TYPE_1,
> -	.attrs = mdev_types_attrs,
> -};
> -
> -static struct attribute_group mdev_type_group2 = {
> -	.name  = MDPY_TYPE_2,
> -	.attrs = mdev_types_attrs,
> -};
> -
> -static struct attribute_group mdev_type_group3 = {
> -	.name  = MDPY_TYPE_3,
> -	.attrs = mdev_types_attrs,
> -};
> -
> -static struct attribute_group *mdev_type_groups[] = {
> -	&mdev_type_group1,
> -	&mdev_type_group2,
> -	&mdev_type_group3,
> -	NULL,
> -};
> -
>   static const struct vfio_device_ops mdpy_dev_ops = {
>   	.read = mdpy_read,
>   	.write = mdpy_write,
> @@ -723,7 +709,7 @@ static struct mdev_driver mdpy_driver = {
>   	},
>   	.probe = mdpy_probe,
>   	.remove	= mdpy_remove,
> -	.supported_type_groups = mdev_type_groups,
> +	.types_attrs = mdev_types_attrs,
>   };
>   
>   static const struct file_operations vd_fops = {
> @@ -766,7 +752,9 @@ static int __init mdpy_dev_init(void)
>   	if (ret)
>   		goto err_class;
>   
> -	ret = mdev_register_parent(&mdpy_parent, &mdpy_dev, &mdpy_driver);
> +	ret = mdev_register_parent(&mdpy_parent, &mdpy_dev, &mdpy_driver,
> +				   mdpy_mdev_types,
> +				   ARRAY_SIZE(mdpy_mdev_types));
>   	if (ret)
>   		goto err_device;
>   
> diff --git a/samples/vfio-mdev/mtty.c b/samples/vfio-mdev/mtty.c
> index 8ba5f6084a093..029a19ef8ce7b 100644
> --- a/samples/vfio-mdev/mtty.c
> +++ b/samples/vfio-mdev/mtty.c
> @@ -143,6 +143,20 @@ struct mdev_state {
>   	int nr_ports;
>   };
>   
> +static struct mtty_type {
> +	struct mdev_type type;
> +	int nr_ports;
> +	const char *name;
> +} mtty_types[2] = {
> +	{ .nr_ports = 1, .type.sysfs_name = "1", .name = "Single port serial" },
> +	{ .nr_ports = 2, .type.sysfs_name = "2", .name = "Dual port serial" },
> +};
> +
> +static struct mdev_type *mtty_mdev_types[] = {
> +	&mtty_types[0].type,
> +	&mtty_types[1].type,
> +};
> +
>   static atomic_t mdev_avail_ports = ATOMIC_INIT(MAX_MTTYS);
>   
>   static const struct file_operations vd_fops = {
> @@ -704,16 +718,18 @@ static ssize_t mdev_access(struct mdev_state *mdev_state, u8 *buf, size_t count,
>   
>   static int mtty_probe(struct mdev_device *mdev)
>   {
> +	struct mtty_type *type =
> +		container_of(mdev->type, struct mtty_type, type);
>   	struct mdev_state *mdev_state;
> -	int nr_ports = mdev_get_type_group_id(mdev) + 1;
>   	int avail_ports = atomic_read(&mdev_avail_ports);
>   	int ret;
>   
>   	do {
> -		if (avail_ports < nr_ports)
> +		if (avail_ports < type->nr_ports)
>   			return -ENOSPC;
>   	} while (!atomic_try_cmpxchg(&mdev_avail_ports,
> -				     &avail_ports, avail_ports - nr_ports));
> +				     &avail_ports,
> +				     avail_ports - type->nr_ports));
>   
>   	mdev_state = kzalloc(sizeof(struct mdev_state), GFP_KERNEL);
>   	if (mdev_state == NULL) {
> @@ -723,13 +739,13 @@ static int mtty_probe(struct mdev_device *mdev)
>   
>   	vfio_init_group_dev(&mdev_state->vdev, &mdev->dev, &mtty_dev_ops);
>   
> -	mdev_state->nr_ports = nr_ports;
> +	mdev_state->nr_ports = type->nr_ports;
>   	mdev_state->irq_index = -1;
>   	mdev_state->s[0].max_fifo_size = MAX_FIFO_SIZE;
>   	mdev_state->s[1].max_fifo_size = MAX_FIFO_SIZE;
>   	mutex_init(&mdev_state->rxtx_lock);
> -	mdev_state->vconfig = kzalloc(MTTY_CONFIG_SPACE_SIZE, GFP_KERNEL);
>   
> +	mdev_state->vconfig = kzalloc(MTTY_CONFIG_SPACE_SIZE, GFP_KERNEL);
>   	if (mdev_state->vconfig == NULL) {
>   		ret = -ENOMEM;
>   		goto err_state;
> @@ -752,7 +768,7 @@ static int mtty_probe(struct mdev_device *mdev)
>   	vfio_uninit_group_dev(&mdev_state->vdev);
>   	kfree(mdev_state);
>   err_nr_ports:
> -	atomic_add(nr_ports, &mdev_avail_ports);
> +	atomic_add(type->nr_ports, &mdev_avail_ports);
>   	return ret;
>   }
>   
> @@ -1233,11 +1249,9 @@ static const struct attribute_group *mdev_dev_groups[] = {
>   static ssize_t name_show(struct mdev_type *mtype,
>   			 struct mdev_type_attribute *attr, char *buf)
>   {
> -	static const char *name_str[2] = { "Single port serial",
> -					   "Dual port serial" };
> +	struct mtty_type *type = container_of(mtype, struct mtty_type, type);
>   
> -	return sysfs_emit(buf, "%s\n",
> -			  name_str[mtype_get_type_group_id(mtype)]);
> +	return sysfs_emit(buf, "%s\n", type->name);
>   }
>   
>   static MDEV_TYPE_ATTR_RO(name);
> @@ -1246,9 +1260,10 @@ static ssize_t available_instances_show(struct mdev_type *mtype,
>   					struct mdev_type_attribute *attr,
>   					char *buf)
>   {
> -	unsigned int ports = mtype_get_type_group_id(mtype) + 1;
> +	struct mtty_type *type = container_of(mtype, struct mtty_type, type);
>   
> -	return sprintf(buf, "%d\n", atomic_read(&mdev_avail_ports) / ports);
> +	return sprintf(buf, "%d\n", atomic_read(&mdev_avail_ports) /
> +			type->nr_ports);
>   }
>   
>   static MDEV_TYPE_ATTR_RO(available_instances);
> @@ -1261,29 +1276,13 @@ static ssize_t device_api_show(struct mdev_type *mtype,
>   
>   static MDEV_TYPE_ATTR_RO(device_api);
>   
> -static struct attribute *mdev_types_attrs[] = {
> +static const struct attribute *mdev_types_attrs[] = {
>   	&mdev_type_attr_name.attr,
>   	&mdev_type_attr_device_api.attr,
>   	&mdev_type_attr_available_instances.attr,
>   	NULL,
>   };
>   
> -static struct attribute_group mdev_type_group1 = {
> -	.name  = "1",
> -	.attrs = mdev_types_attrs,
> -};
> -
> -static struct attribute_group mdev_type_group2 = {
> -	.name  = "2",
> -	.attrs = mdev_types_attrs,
> -};
> -
> -static struct attribute_group *mdev_type_groups[] = {
> -	&mdev_type_group1,
> -	&mdev_type_group2,
> -	NULL,
> -};
> -
>   static const struct vfio_device_ops mtty_dev_ops = {
>   	.name = "vfio-mtty",
>   	.read = mtty_read,
> @@ -1300,7 +1299,7 @@ static struct mdev_driver mtty_driver = {
>   	},
>   	.probe = mtty_probe,
>   	.remove	= mtty_remove,
> -	.supported_type_groups = mdev_type_groups,
> +	.types_attrs = mdev_types_attrs,
>   };
>   
>   static void mtty_device_release(struct device *dev)
> @@ -1352,7 +1351,8 @@ static int __init mtty_dev_init(void)
>   		goto err_class;
>   
>   	ret = mdev_register_parent(&mtty_dev.parent, &mtty_dev.dev,
> -				   &mtty_driver);
> +				   &mtty_driver, mtty_mdev_types,
> +				   ARRAY_SIZE(mtty_mdev_types));
>   	if (ret)
>   		goto err_device;
>   	return 0;

-- 
Regards,
Yi Liu
