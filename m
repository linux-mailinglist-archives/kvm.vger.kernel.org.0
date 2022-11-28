Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E72963A4A2
	for <lists+kvm@lfdr.de>; Mon, 28 Nov 2022 10:17:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230183AbiK1JRl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Nov 2022 04:17:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229773AbiK1JRi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Nov 2022 04:17:38 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12D245F4D
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 01:17:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669627056; x=1701163056;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=lNrFfA7LTI1TpnF2gRr+k8p05MzFcaLGKIm4fY0BKDE=;
  b=DnC+qP4Bv8Yg04WS2aRccjLWdGuD2Sv/wROPgoRF7vcPgVyzEEe+HYnj
   kF2nxdgLT5M5nAW72nBSb+qqH3Fvfuvouj2ckxl6Z3+1AURwiU1MYRTdP
   SNKyFqB9zp6qrZO3OzHwsrrr8brrOKWyBZYYZg9Gu4f5JyAK9JC3/3cMj
   A0rQA+MiOjM/4OTtnSLJ9Zspw2tjh51TrdD7NPs37bUf1OWUIwIcC0RMZ
   LB9Lruo71fdMavOZnd2OW4ydJWw0cVGCQ21/fg2Mtl4R1IXPcYyE/7+Bh
   HTB/ctR6c16RIY+CbwBihCbs364Arn0Qx4t6qHo2mLeVeyiuORpfEFuNZ
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10544"; a="312421967"
X-IronPort-AV: E=Sophos;i="5.96,200,1665471600"; 
   d="scan'208";a="312421967"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 01:17:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10544"; a="749300704"
X-IronPort-AV: E=Sophos;i="5.96,200,1665471600"; 
   d="scan'208";a="749300704"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga002.fm.intel.com with ESMTP; 28 Nov 2022 01:17:20 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 28 Nov 2022 01:17:19 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 28 Nov 2022 01:17:19 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.44) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 28 Nov 2022 01:17:19 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e67nYGuIJu2GuhoWOC805Ot6N7h3u0rztjQItgb5O4/G+RcFeWaZbMbPc1dEfolXjTt3D2xLuY+IIgRH3yw72/yEJcv9uA0sBh8SY4YWap4jbbyCq8T4d/mmtIRkGkwuYO+EnFdCjIFhSV+qSuD0JY7S0PxNITXLXbiR2bZCoCG0xL4ylXf3cDHgBtQB9L1uXBLa/e1f+I7TeFQTEgoxEE4Gvwmsi4KziTeGPXWcTecRud7R8nEBzSPwW50XPtZnbc+BD841J93vvFAiK8jbfw57wth6PgAp/OnuHSJoJR6eMfw5pCbTM4JyMWaxQkDDIHDerQeyKmJvw6443FrNJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J4xwOpYrDwFLOsqCap2uFOr22VulWtoM/MKjB1hC2UU=;
 b=m2z1krLiMUjANhRZ08Tyvk6ZNk+xuUASrnu4GJX03d+LtBxSlOGFliAtRSX9BO17y2vMUPCcdfENHruEJwlGr1nKnbhCu+f7KZgN0Lt8Z5Lf5JrnFofCTe8WZxm1ZF0YmB5FFlbb/xFNUzvMtUmEo9MPEeNgCsVmWVlyba5TEdghbVIH6QgnvSfyDaBP6s5BpW/PM527CHKD2v3xIc0q7ESForgWaRpTrSMOlFaCsuHkouinXS9Nftpx/ORBvxBU4YGNPq48u2st4bKOluMVKNSQB1xKwN2FTfUslk4VVqoxcndN+u9TZ/HjBiRouI6yjDu69TKjminXnN+2rduVZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by DS7PR11MB6013.namprd11.prod.outlook.com (2603:10b6:8:70::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Mon, 28 Nov
 2022 09:17:18 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::61c3:c221:e785:ce13]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::61c3:c221:e785:ce13%7]) with mapi id 15.20.5857.020; Mon, 28 Nov 2022
 09:17:18 +0000
Message-ID: <440f039c-96ae-3bbd-df13-f8d839a1ccef@intel.com>
Date:   Mon, 28 Nov 2022 17:17:57 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [RFC v2 04/11] vfio: Wrap group codes to be helpers for
 __vfio_register_dev() and unregister
Content-Language: en-US
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <20221124122702.26507-1-yi.l.liu@intel.com>
 <20221124122702.26507-5-yi.l.liu@intel.com>
 <BN9PR11MB5276F0D7F1CE2C5AAB629F218C139@BN9PR11MB5276.namprd11.prod.outlook.com>
From:   Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <BN9PR11MB5276F0D7F1CE2C5AAB629F218C139@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0033.apcprd02.prod.outlook.com
 (2603:1096:4:1f6::14) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|DS7PR11MB6013:EE_
X-MS-Office365-Filtering-Correlation-Id: 8bade0ff-6c11-47dc-6854-08dad12158b6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fxwzmmhNdub2h2HdwR0n0c+TSSvkePHyUR+H+RI0MOVSXRihlsyH9je481gS3lBMLSSBlEkVE5n/2QxctyQHKazloQe11dLb0jo/rHVp4atJcSCmu+nobY7O/aZgJ7hmHmq34zjuewEuAadCZV+rVClciScOcpkHymDzF2ateEWTQ+nuMbeAUASqcehBvWMAvaDSQ1PO+qt2LSN9UkkEq7QX/0OiL8JTWBTA2bzqDzkH3azRPfeHmERIsL7CsTjZebaTKc7j7ZBQLxK4WTHu0+FwyZ823soLbbVE9jIBJvGS8qc/lk2hBQXdVQiG5J1zfQzIXmhgFL0wvwNAst2RH07PRK6OXTwIyMnYvaJljivuq8mJF1TgTWcYNmNMYCdKk2JRyGl2nKnZKMgoEetrXkLaQ+8cS0tQ1fxDp1i3/4xljBSgGMaK5strqlVqXadUjaqadrZRJniVd6f0QdPjtJlL81MJCWiMclihmKyPmQQpB31VGGKFntfmN7esi5ftFE2aB1kEY7skDuf5H14YLh7I2DdI9CManAyOjfFaiBz3Gyxmm8h9X4WaW1Ffzncz0f8aod3VIntDW3PRqo32ZpXSOPXIO+zqPtF64GEUkQt7HRufGM2YOj8cn32CEMg40rX9UonOktT2eh2rinGJ0N5tx7hae15gR8dSTve3xkncerF5pIewbeKynFi7x4GtynmAK42h/awA6K1WFOWZFQySzw7EAa3kKXP5Kp9ptQU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(346002)(396003)(366004)(136003)(376002)(451199015)(2906002)(53546011)(186003)(6486002)(478600001)(6666004)(6512007)(26005)(6506007)(36756003)(38100700002)(31696002)(82960400001)(86362001)(2616005)(41300700001)(31686004)(66476007)(8676002)(66556008)(66946007)(5660300002)(4326008)(8936002)(4744005)(54906003)(316002)(110136005)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K240Qm1MQXJZc2ZnWG1QNlgwMWtpSXBWUXB2aWpmMVVMODU2dmNjbHRaeUNx?=
 =?utf-8?B?UE5lcWpieTkrR3ZsYkhRMDlyVDdkd1dMdXhSVEp1Y2NEKzNXeUNZalpKRjRS?=
 =?utf-8?B?RnIvVEZ5OWppSWtOOEx6akwyZ0IvUHlUVmp5RitYWTJqVnFtSjhQd1d6ZGtj?=
 =?utf-8?B?Z0I4UkdzMmJUcTRIWDgzYUxPTkpyZGVGbnl0VC9uV0x2SjRpdTBqeGVTSkRG?=
 =?utf-8?B?dXpNc1lVMmJRbXZZVDhsQzZrejQxWEt5SThGdmUzQVdLcVovVFNKZktjcXpF?=
 =?utf-8?B?RkNHWnVVRThvaVVmcDdYRlhIWVlBR1F1Z0xVS01NS1Y3R0JtNFlmYXpuRFJZ?=
 =?utf-8?B?MGFRQU5TcjBwZDUyOUtrb2Q3VVpSQVJ6YWpqYlZVbUdQUkZDRUJoRVRMditC?=
 =?utf-8?B?angyS0l1V2x6ck1aY1dtd2hQOU5mUVJKZzNMQTR1aFNiUU1lUGxhc0hMQngw?=
 =?utf-8?B?SHpYWFVLa2xuYUd6U1V1TE9TZmF2MFY4cFdiV2V1RnlUVWZ2Y3dYUVlvZXdD?=
 =?utf-8?B?VVZvZ01xZktzUy9wYlZYNzY3VkdMODg3OHI2RHFETGI5aVdJWU9CMnpoNE1n?=
 =?utf-8?B?S25aSU5iVkk3QUZnOG9TUEovanhSU1MvMFNkMjFQVXNtNytBL01ZOVd2c2Ev?=
 =?utf-8?B?OVdvM291dW9XNzJSTDU4UjlMVkN2WEJiOXIwbGl2dDNxcFM3SU1jR1AySURT?=
 =?utf-8?B?cTNDSVBzaHk5OW5EM3RFK1ZBbXJCSnZ5Zjh4N1VpbFltUldMcEZpVVdFT1R0?=
 =?utf-8?B?QmQwdVlwVVFRcnozS1JIY1JVNDB4dHAxRG44b3hLYkZUcktPVTVBQTBJNEUr?=
 =?utf-8?B?Z29ZbFU4SjF5c1BTTmZOdUJldkVyOEdKcXZDRVR2c0FUblZKV3MrK3pKVzZM?=
 =?utf-8?B?MHN4Mm1XQm92elNFOGQxM29ETXNLMUtEckh1dzJ6aE9HRHdTb0VZNjRZWGVj?=
 =?utf-8?B?V1dnQWkvK3NOVEhxb25aMlNHa0JVK1lRSk43bTFDbTYyQ2FKT0FZR3BKZVhx?=
 =?utf-8?B?Mk9wMGNhY1h2UDF1N3YzOG4xOVRYc3FDMHE3L2JoN1RPZk1UeTdFNmVjdHVM?=
 =?utf-8?B?dGduN21PQkR2bTJUVUV1MDFyUUprSXZrVFVmVm9vQXZEN0pJTHRRbTlFUElC?=
 =?utf-8?B?WEc4TFhNU1ZydTc4TFQ2ZkY2cDZpcmxRcUk1SDc5c21MV2tjMHJ6UVZET3hX?=
 =?utf-8?B?VWFsK1k0cXhoalljMTdOeXZKck1KTmU1V1JZTDNOc0U2SzR2TkVscGVSQ1hZ?=
 =?utf-8?B?aEJUb3hHb3hXSC9yK3FSTG1Xc0NoV0xUZ25URTBEL1FLcXpsWXJhMEhpcGpn?=
 =?utf-8?B?WjNSRXBHOXBYdTdkd2VVWUErT3RyV0VWcGwxczhJZ0EyU2p4UFZzSVNndENi?=
 =?utf-8?B?MldqeGJJa21RV1dOaXljUnY5U3l6elJDUW9qaWhEOGlzeE5uR0sxMXdEUnpa?=
 =?utf-8?B?TW9odElmNE9PdUtNN1VjdTU1ZHFTZzFBVTlLR0dFUG8zQTBncDdyUiswTVlo?=
 =?utf-8?B?Wk9pcEJHbE9qVnVCNlZjUWJxYzlkWGZXNkNXMHZ5RXdKOE53UDlVa0RDWUFJ?=
 =?utf-8?B?M0R4SGpxSkJYaGpRajNIUnpWckNmMkhveEV6RWI4RUlkb2RDU1c2ZjFWYlRq?=
 =?utf-8?B?NFUvNnZmOFpoWUJ3NDNEazRwUGU4SjBXQkU3dnBXVXhvTUJNSzk1OHNwcytH?=
 =?utf-8?B?Y1BsMjA5eXZJZWZlbXhuZW5QYjVqZjhHbFNCSFFUVmJQZVMvK2pzbFNXd3Bz?=
 =?utf-8?B?b0FGUVp3WStBSzZ1ZmNUOXpKL3EwellqcG9FS3NCMzJPTEFsUzFQbG9Sc3RT?=
 =?utf-8?B?T0tYcTVvMVYzRitMU0dYMFUvK3h3aXpJVDlzNmhYcUl0ZTdFaHFWR3dqdmFi?=
 =?utf-8?B?R1NrTjNJT2RweHRDTzJRSStvMEVnMzJvQXFpQWkyb0NXckVMS0M3elgzN1ZH?=
 =?utf-8?B?Q0MrczlMTUV6NmxMR0hucFJKdFEvZGJqczNaOFBxVDFSQWQwOWwyY3ViVkhk?=
 =?utf-8?B?NmxsbXNoTjFlYTZIZjhTYWY4akg3aVAxT1RIS3NTd1VxNktTRkFkQ0UzUWxi?=
 =?utf-8?B?alNSOGo2WlRKVEwybVB4dGFEaS94c2FOM1VMWGRFWEdCUVc1Z2dNc2NBbm9F?=
 =?utf-8?Q?7QsbqxjB6PkdTQXC0c83wSBAc?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8bade0ff-6c11-47dc-6854-08dad12158b6
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2022 09:17:18.1946
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t/uAhywCJP6HnbHcPhIcdTHSxKfv4kvy6HP3IjljnzCVHSb3vxhA5G72eA1lyugy1uNnJXPU1epIbu9pWiiW1A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6013
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022/11/28 16:11, Tian, Kevin wrote:
>> From: Liu, Yi L <yi.l.liu@intel.com>
>> Sent: Thursday, November 24, 2022 8:27 PM
> 
> Subject:
> 
> "vfio: Create wrappers for group register/unregister"
> 
>>
>> This avoids to decode group fields in the common functions used by
> 
> "avoids decoding"

got above.

>> vfio_device registration, and prepares for further moving vfio group
>> specific code into separate file.
>>
>> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> 
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>

thanks.

-- 
Regards,
Yi Liu
