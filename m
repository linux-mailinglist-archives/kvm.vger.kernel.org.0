Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E29D50CA3B
	for <lists+kvm@lfdr.de>; Sat, 23 Apr 2022 14:53:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235512AbiDWM4i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 23 Apr 2022 08:56:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234914AbiDWM4g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 23 Apr 2022 08:56:36 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E273E261
        for <kvm@vger.kernel.org>; Sat, 23 Apr 2022 05:53:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650718419; x=1682254419;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=xDqUismSfLn1swx08zBpHBFOSRjxd9nIJxHUH/RrKFg=;
  b=HR5sP2WJHhItinRg22LVOY0pkEGCyuhuR080DYFGuNKhuyz8COrrZFbW
   f6CA1G1BbDn2TiUIs61Of7ufKcCnXflUX2Yzw7MTZ20ez4XpHRcEnBAMU
   EX4CP/t6IkqBbPOq4wT/x1TnOt3HHiyxe4JfekUrvGj1iGkfXNvWvbjtd
   e+goOqG+bIC9w5XFAWOW1oQo4zmOtxKWsrSemZXOqePwIQJsGr5YTlHHL
   fKD/7bgP8tM2fO+RGh07CjgCt1txMKPORQKxARXRqiLWq7UFLD97sg1Fs
   RAaEKa8YQDlwGb9Y60/+C5+tE78pJF8eZpQu3PekTVsG/HD4JSbmSbAaz
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10324"; a="265060235"
X-IronPort-AV: E=Sophos;i="5.90,284,1643702400"; 
   d="scan'208";a="265060235"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2022 05:53:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,284,1643702400"; 
   d="scan'208";a="563422002"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga007.fm.intel.com with ESMTP; 23 Apr 2022 05:53:39 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Sat, 23 Apr 2022 05:53:38 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Sat, 23 Apr 2022 05:53:38 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.177)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Sat, 23 Apr 2022 05:53:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YTkc+M2g4uDidAnBOETJWPRiiEETrQ5EEjVj9xd/RKISC+H/M1HcqP8eK2Df2bUIFnF93/gp1NEMIPCxWfCxqOfUYg87YbgVvnDaECcAcjJR3LhJcwJKrewXNKx0u5D5XHJBDIjgNgvG+TsQ4P9I1+Zx/cp5O2G/rqokRQLEv5mNL+HM2v4zG3Ae4r/xDqaOfMkOuVHsWDNl9EMLiMwLt7sxd99bTujE6zs2OpO8Bo7/htBJrrtirQid0+p+x3jGiswOEFkewKT8aWpBKs/V3LP54OJlGv7MlIXENtM9IE82czwD05kkDy8IG1IyVdY/OwcrYmL3g63YmLMb6NeDsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MEbLcX1Vf2B3H1IvQFDCQuOaRBvOED9SWJEP4Y6xWZs=;
 b=DFf82uV8mNf7xsYune5rzNDchkQfeRESuksEzRS0uhwxrz4guk+E4DBxL8fQIDp2MVr+84hjJCUyuKoNXRNgF+LO16dyUsTHrXXbl55FqEmRY3QKDU9qq4OdQZvaGfrS9HZUl+Iodu5JFH4+6+h7Yz+JHYpt/y0BUXBjHnuIbxuqRFg/F3eZeZOVtHDTID89Z4gI0Lu9v1FiMO5amLvuOyqUggNwaCWiRyCvvBHiQ32l2VhdRAwex8TkC8zWSyl7MiojGMu4+v/kN/gM7g932XhLMOt2jzJKFy5VuwHecLCPPVYEL7Wz8c1sG2tYTSeNmU1EEiK2Xp+jd5UzIQN5JA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB5658.namprd11.prod.outlook.com (2603:10b6:510:e2::23)
 by DM6PR11MB4692.namprd11.prod.outlook.com (2603:10b6:5:2aa::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Sat, 23 Apr
 2022 12:53:37 +0000
Received: from PH0PR11MB5658.namprd11.prod.outlook.com
 ([fe80::71d2:84f6:64e1:4024]) by PH0PR11MB5658.namprd11.prod.outlook.com
 ([fe80::71d2:84f6:64e1:4024%7]) with mapi id 15.20.5186.019; Sat, 23 Apr 2022
 12:53:36 +0000
Message-ID: <31a03c63-aa5d-a9ab-aa78-78c25988bad3@intel.com>
Date:   Sat, 23 Apr 2022 20:53:17 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.7.0
Subject: Re: [PATCH v2 3/8] vfio: Change vfio_external_user_iommu_id() to
 vfio_file_iommu_group()
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Kevin Tian <kevin.tian@intel.com>
References: <3-v2-6a528653a750+1578a-vfio_kvm_no_group_jgg@nvidia.com>
 <d9729afd-61fd-1911-ba15-ae3ed5e73f30@intel.com>
 <20220422170523.GB1951132@nvidia.com>
From:   Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <20220422170523.GB1951132@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: HK2PR04CA0046.apcprd04.prod.outlook.com
 (2603:1096:202:14::14) To PH0PR11MB5658.namprd11.prod.outlook.com
 (2603:10b6:510:e2::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 792505ac-b669-4681-4ff7-08da2528481d
X-MS-TrafficTypeDiagnostic: DM6PR11MB4692:EE_
X-Microsoft-Antispam-PRVS: <DM6PR11MB4692BE8968AA5BAC3451DA17C3F69@DM6PR11MB4692.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GbFqkk+aojpu7eLrqPz53xkuCtMezWZT4+d5A8957876k81ivF6KHj09ogAkkOBHxiD9OUwI5hNj9QhMzfm7+CsipOK6RfJ02o9JMP/e4rGhv/cRYDravo2SccWhcnvKg6NVM2jZFy+ylu9JQl21Q/K4rfg8wJLhE39jDk7ig4COvBgqlqhN6+yUbnKhGD1YD9YPOc+If4PROfSRB2qm/P3QXHbP5OhWIL7EkhUOVdtUemj3h1nyTtBh6b5cYfRFdP97I+ZKwjZRkAC+4TnXdEZWhMuoPwDaMehevZ4ZMRCj5rT0mYfc1ZicEdqJXg3fjQAcZOWPYLj9ejbc/GlhHoXsTFqm8T7EkB7ZlzCQGz1xYxPxxWYhDzOy656byZlghkFHU1lksHrmvdtOpQPzU02PcrXpgtRuGsyRyBQc8SSOHqyyRLqqbqv1zx22zEZ8AHT/vFwjRCYEb0yLuYrsZdf7nfYUHqoSFTGjwtXBlQM2pqeSQwg174hohNFIPZ/FSKAfxl/IJwOpCsQBImiLKzgeryL78JEBVAnJJkDtyl4Y//8r7xMFZi9VsmrsHT16XRvqU3CCAnPc6VeGAxiR7JguVj6mIz5LJQN8rW4/t392r/0PTtIcJcxWAQ3r6atn3GoEKSf+nYKIi7aG7E0UqPIGL4ATyQ8UenI8s6WIVYMwhBz3wZvfxd/jyqrK6DnYKLzQQmpM03P8hSvkZaCxj+MNfZaJup8kCPSIY8IgdpN3N30SxqyN7rX7k/2r64oG
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5658.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6916009)(54906003)(86362001)(31696002)(4744005)(2906002)(6486002)(508600001)(53546011)(6506007)(186003)(31686004)(38100700002)(82960400001)(107886003)(6512007)(26005)(36756003)(2616005)(8676002)(66556008)(66476007)(4326008)(8936002)(5660300002)(66946007)(316002)(6666004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RzVZeGk5QmNId0xDdHZSbzJhRU91aEh1Z0hLZVJYeHViRGtuaG5FZTVGNlpp?=
 =?utf-8?B?WmtyMnE4REQvcDgyTGRuQ0RtVXRhbVoyWm5HMTg5bWpqSWc2bzdSemdZdWZx?=
 =?utf-8?B?YkZpeWppVDJmTWNzVlRBNFZGdXZubFJ5MUgvYVpGaXZzQ2dxV3l1VmNUdzBP?=
 =?utf-8?B?a0o3SlpDbW9VV0t1akVLV1VRUG96NnRtMzFxQ004eXJlMnNickdRci9La05y?=
 =?utf-8?B?c0MxY0Y0Q0dURjBSdkk5TnNkOStpdkNxNEFVcTM3SE83MEdrcVZVVjM5MHhI?=
 =?utf-8?B?bWVNd0NleTNTaHJkR1RNdUVzRWcxeU9JeTNCeElsK0d6WE5LK0NCZ1k0bzBV?=
 =?utf-8?B?OVRQZU94RGZIMFI4dXdpSmNVOFZwOVlIREVZbXJveWJWaFFORGV0U1N4YS9L?=
 =?utf-8?B?Qzl6eTRNZ0pncVB5WXRiOUNOSXhiSXY1TFFmT0lyOXdtOGNrQUVUSnc0TTNL?=
 =?utf-8?B?bWloMWRnOXFRYzVKZjhEbTZPekliYUt4akdxMng5T1lneXBLaEdhT01zS2Uy?=
 =?utf-8?B?eHdJNVByRWs2U1dFY3F5MnZJZ3Jwa0p2UDVoZmQ2RTd4WDlacjFwMVp5R0E0?=
 =?utf-8?B?b0p0NEhXc3A2S2pyZVIvOHArWmJZcVFVZU51SlE0WlNyZGprQVNQYXJ3d3ZW?=
 =?utf-8?B?ZGF3TTdPejdLUUdVSklHSWd5V1FGRjROUDhPdGJXZVZtNjY3V0k0Q2kwOUQr?=
 =?utf-8?B?Smd5dnRDZU5jS0FhM0EzZHlWaGE5R1FrTEhJZXFXTTE0dUplcHdFUHE5dGRU?=
 =?utf-8?B?dGpmcGpWVGxzK281OU9reHBpZS9xelplZ29LWmlybmt1eW9KdkxvOHhKQmFZ?=
 =?utf-8?B?VHF3ZEtjbkpKTFVGZHhlaVVGWmJOTllKeHdQSnBVYTNRQmRVeEpQbW43K1Ir?=
 =?utf-8?B?MW5Rb3RoT0lIVWUzVzVaWGFyb2pXYVdyYkcvY0tYVjdvQ2xiT1Jja01DZVQ3?=
 =?utf-8?B?VjMwc3B3NGV5YmJTc084VE9ESXc0SmZ5ekM0NUNLQ3dvMFRkM05kNUhiamRr?=
 =?utf-8?B?K2hReTBReTB4cDZJeCtnQ0FIZEtpSjZsTXVKYXFYR0FEdVdsTUdlZUJmMG91?=
 =?utf-8?B?VkdpZWkyTWNuM1RqaGNxS083d3gyc2ZMaCtZMHhnV053TW9sWEREK2lGa0tk?=
 =?utf-8?B?ZDZFS2NjVC9IdG5zS2twbUJyTXdRT2RNaU5nb3Z1WEFQNlBlMmNYdVp4NWRk?=
 =?utf-8?B?M09LMlg3UUdGK0E2Z2pkT0lqUW16djVkMFE3U1MxaVVmdGdWUk1DaEEvdXVL?=
 =?utf-8?B?bGMxdGtCUFZwWW1nTyt4Tk1vTVlTMi9zNVc2bEFCTWZtWHE3eHM5SENNZ3Rr?=
 =?utf-8?B?NHdSN2VzZlU5UDRoeG5ZcXJ2UFd6Nm5YZVhjVnBTVEVJLzU3b3pwL2lrMXNU?=
 =?utf-8?B?SXRudS82Y0VwVVcrMEtWa25uYjdaVjM2bU1sRXpmT3ZYL2hjdGtqWmNCZFFu?=
 =?utf-8?B?dHRLVGRJVXIvSDM3eC9CQThYMGNGY1NXUUhSS013TU0wWGNEVHhvdmdUUXNs?=
 =?utf-8?B?QUVnUDRXYW0wSFpDWThFT0JuNTNaNWhyQ1pvd3RxMzNXck9NK3ZtTHlCaDEz?=
 =?utf-8?B?ejFGeTFhazJRVS9hd1ExTG9rTExVSjZRbkZKcnJEQjRKbFgrSkxwRUM4N3hZ?=
 =?utf-8?B?RldPd2MvWDVCbFJONHE1em1UWmJ4bDl2V05hRGpyQmpKVSt3N2lkd1pJQ2xC?=
 =?utf-8?B?MVJjSVlpVzdNbmJZaGlxYnBUbGhGRVlXdFAzcldvdy9zOWFsSVlPKy92czUw?=
 =?utf-8?B?M3pwMFlTVVphQk1BYjBVWXJkbGM3TUc2cnlOMVVuMW1UY0NaZitnRGdIbDBV?=
 =?utf-8?B?WGR0dWVVSVZ5YjZ5YUxYZk5vNlE3WFY1MGcwMXlOWVorTVZmMHA0VUlER1ln?=
 =?utf-8?B?Vjh0WnNUM3FMWE5SbzgrYWpCeE03QWEweDJyaWt0TXloOHJMTnZwN21MaTlu?=
 =?utf-8?B?VXdza1JxRXFoZDFudU5Mc0RHVHVJb05IQ3ZTUHQza0ZqTnpKUk0zdSt2bElS?=
 =?utf-8?B?c1YrYzRCS2JQeVZVUGR1emxSZEoyRDhRQlphRmRZRXMxaS9pRWxYZG56d0Ni?=
 =?utf-8?B?K3JrMmYyaU5oSk56SkdzbVQ2eEg3SHlSZHRud3d5Y0cxK292MW43TjJGM1oy?=
 =?utf-8?B?c0xOU0RMUzk3WHlUOHdKZDI5alVQK2JMa2RaL1h2cUNWd3VTZGNGSzZweWZY?=
 =?utf-8?B?a0xoNGY0OEUzQWJSOTR6L2U0a3MrV0F0V2xGMkorMGdDbXdyTklVTSt4K0Uw?=
 =?utf-8?B?V2VjajdpVEdnVmRmbVRjVkxPbDM1Y1NYazNkSGhEc09DQ29OQzN2VEpjb3pM?=
 =?utf-8?B?eTlhc0VBQXRHYzRFcXd6emZRWGNubnc5UHd6L0hhKzZNM3JTQnNyQT09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 792505ac-b669-4681-4ff7-08da2528481d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5658.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2022 12:53:36.8271
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vqFuPxfKiuJnYIUgzr1/iXHl8yrxvCNzJyPwbSAy0vrKxNJAXg0P9T9JndHkCx2vDW7S+2ojiRWBEPw2FH+TDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4692
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-9.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022/4/23 01:05, Jason Gunthorpe wrote:
> On Thu, Apr 21, 2022 at 10:57:06PM +0800, Yi Liu wrote:
>> On 2022/4/21 03:23, Jason Gunthorpe wrote:
>>> The only user wants to get a pointer to the struct iommu_group associated
>>> with the VFIO group file being used.
>>
>> Not native speaker, but above line is a little bit difficlut to interpret.
>>
>> "What user wants is to get a pointer to the struct iommu_group associated
>> with the VFIO group file being used."
> 
> How about this:
> 
> The only caller wants to get a pointer to the struct iommu_group
> associated with the VFIO group file. Instead of returning the group ID
> then searching sysfs for that string to get the struct iommu_group just
> directly return the iommu_group pointer already held by the vfio_group
> struct.

clear now. :-)

-- 
Regards,
Yi Liu
