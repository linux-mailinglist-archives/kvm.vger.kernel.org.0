Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 221EE6FBB2F
	for <lists+kvm@lfdr.de>; Tue,  9 May 2023 00:53:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233997AbjEHWxF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 May 2023 18:53:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbjEHWxD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 May 2023 18:53:03 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 629BD8A7C;
        Mon,  8 May 2023 15:53:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683586382; x=1715122382;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=sSuNueVDpEF/QH1JlqPghNbLm316aWrqMRT4zqCKhxA=;
  b=MEmG7AyOjCw3D/ec8wqumm6n/i4qtIL85BYT4t644EVZ0hkWVyeRysj5
   FHLzV13FCMOb63Yk2Nj8pa6fip8UeSWGRyg24dJoCqpIOyLZWPH4m9Rr+
   F7IO1Xp82GPHzFhvcLJRIpJuUZCAJ5CdqKN9tTah4Q4Crhny4hdBFj1p1
   vfZDEULeCsBM8E7wmHYHDl0yfn4KkmeXybFq79sQ6K/qAz0y/QEDCcydC
   xXea8vwWxBr0Qa0xcbK/W/a2lmbXAgRFYYPGjmetP4De/aYT5aVoLu5Lj
   XyOphX21+86b82YtKbk3iDssvhRuIpjEzHEGfFJPUuW3kUZDdTi1EV03f
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10704"; a="415335087"
X-IronPort-AV: E=Sophos;i="5.99,259,1677571200"; 
   d="scan'208";a="415335087"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2023 15:53:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10704"; a="698676114"
X-IronPort-AV: E=Sophos;i="5.99,259,1677571200"; 
   d="scan'208";a="698676114"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga002.jf.intel.com with ESMTP; 08 May 2023 15:53:01 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 8 May 2023 15:53:01 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 8 May 2023 15:53:01 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.43) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 8 May 2023 15:53:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SVCUMKOEZyWFVHb2LG4MfRhtw8tGkwFdKibn+JNn5US8SzbzR6JChGV/iScQ5ybzllsnXnO5P1vPgsfu43ZZgoKbLfea+ibG/84Wic+rfwh0iDkSrmyLGYrX3mJKxrGIrjV5kWiDwOozARqJXI2xaLv1/qEhXfqju8Jyp5lv5TP99uORLupGbUoQJTh8f+Zv+JFr1K0CClOG638PIosKKSRK3VIQpuXgUwCJTBP/Ay6X1oD8Ytq+jWBh5a66RpF6sHcpZlwiQUKy5UhP1cv5H5Wv/3qg2QBf2sdusqmh+MGT0vcZrlc1FFmKNtCQvLlOYRIKu2uBvDm0YuHfWqvnow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u4u+ZQ25POwNUm910yi4eZ6zMtVknlBIZYKdNTVfQcs=;
 b=aUjOrtZhm7jPWmtXbgEL/YjYo4Mqvgbw5gPc5Ist+vbH9Xg8oXDfn72sFZTKT20LKG19JNy/t7b/qkN4cY/ojy7boaycn2a+kWpJDKWGxW7EvkkiCfdycJXd5cLvMn8bEOoCXfJi1bp3D6mBwc43+gDQn2Vajsek4oZhLZMMIKK+gNyFM2xyabPsTD1m7sctqd4SaETBJBSE492lKgK7p4KXHrGQtJnZjokNrNiu5wOs6QDZEZYwLc9JeRtVY8v4ITdJHxEOct2EXVqx7Y3FyW42PEWswm/8C+/ZeYXjpVeD0EFZsKz3AKTw2x7CXIQlRcy1b7PK/o9UlGKGsOTI8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by PH7PR11MB6556.namprd11.prod.outlook.com (2603:10b6:510:1aa::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.32; Mon, 8 May
 2023 22:52:59 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::591f:4873:fd80:9a6d]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::591f:4873:fd80:9a6d%6]) with mapi id 15.20.6363.032; Mon, 8 May 2023
 22:52:58 +0000
Message-ID: <1f84c37d-585b-8113-b045-7d6076405e34@intel.com>
Date:   Mon, 8 May 2023 15:52:56 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.10.1
Subject: Re: [PATCH V4 03/11] vfio/pci: Prepare for dynamic interrupt context
 storage
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>
CC:     "tglx@linutronix.de" <tglx@linutronix.de>,
        "darwi@linutronix.de" <darwi@linutronix.de>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        "tom.zanussi@linux.intel.com" <tom.zanussi@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <cover.1682615447.git.reinette.chatre@intel.com>
 <6fcd4019e22931a97d962b6e657e74d6fd1049ba.1682615447.git.reinette.chatre@intel.com>
 <BN9PR11MB5276242E8D9F4C082E6D2CB68C6B9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <07a693e9-b926-6c25-ea55-8465410e214c@intel.com>
 <BN9PR11MB52764DFBE5C3FFA8BEC9E2AA8C729@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Language: en-US
From:   Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <BN9PR11MB52764DFBE5C3FFA8BEC9E2AA8C729@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0073.namprd05.prod.outlook.com
 (2603:10b6:a03:332::18) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|PH7PR11MB6556:EE_
X-MS-Office365-Filtering-Correlation-Id: bbbfcc25-33c9-48f8-ae8a-08db5016f81a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 19qhqZ21BgVJdYSt97tWtb5bg6rAncxcd9LDqyy9REPH+gA1BSecx/zaf3FpJTL+eGxoBkluEKalzeCkf4G8TRXmhKsaitlqDkNFcs1I7CfRYBzgItz8cvfwKUIsu06Se0h+Lr/CQ7ucs8wnEX8dkHFNr2INXa1cmJP/vITnPJ5u0g3ct6mPvucifi/q7bE+vWr5VBKMdF868lhyUOTgsi0FTPNwD2wWzZ35GMvQv7AYl5BaacAE/61cFM4DXYn/OJl4ZOG+Is+wgpncinLMm07GAJwr4TlUK0FrqpjdjylZi+cpxGuQqLczUMv72Sy4x6p3Xy76/XsHQBtYl6TuP9ql56kUZaeOuW2uzvnwqwuLJxfVr7/hM8JvTwcHenp0OAnaO44XHuSobDnAPjyjDkDfP+iB/6sBstb1TVUZc6JHhtz92xDbP9hLh8P0rBTlGR1ZEBfRzqS2ANO8xuPUWHWptxl1Uwn2+8LJsava0WaND1TLCbydinXrRkj52t6W3FOr7tWa1lJRWmaGYwYQC8JVIM4VcZGm97W+YpYEkuF8OyntO2yBjNk7T1tfVYATTUPKmDjGpK8VGpPNvfNP4volkpRFFZ+c1L/gmdPX8R3C6VqV/ZNVbSOPj5YO8BjwNhBtX5bvxXVOcgfA8LyCQw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(366004)(376002)(346002)(39860400002)(136003)(451199021)(31686004)(36756003)(38100700002)(44832011)(4326008)(86362001)(8936002)(316002)(31696002)(5660300002)(8676002)(66476007)(82960400001)(66556008)(66946007)(41300700001)(83380400001)(53546011)(186003)(6512007)(26005)(6506007)(54906003)(478600001)(6486002)(2616005)(2906002)(110136005)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SXRQbloyaGViWFB4TnZkRDZnTjBzUTZqU3ViMnNhUS9jbU9tQm4zaHN4ZWZ0?=
 =?utf-8?B?L20xVkFvOTVTbzhwYy9lMElzZVViR0pQb1JNQVdPR0IvL2tMRVg2Q2NyVTBR?=
 =?utf-8?B?akVkb0xOR1JlS3k3TFZxam84STh4SDczL0pWSlY1STNzMDNkOTdzVU1ybm13?=
 =?utf-8?B?bVltc3RCVjRzbnZIYzFjNFZuZWNRY0hPb3dSdk1OeWhNVHlJQi9yQzgwTjdX?=
 =?utf-8?B?TytQeENNRlE1M2YxK1NoMTNyRXRYMHBOMGF2Y1F4WWI5ZldIWVNLZXVsVDlR?=
 =?utf-8?B?YTByekVPZmtDZlZ5QWdtU3Awc0NsaVhYYTFlTEFDT2xhUEo0VmZFOHFUNFVO?=
 =?utf-8?B?UFV3OGpUY3Y0SSsycEZjRjJ2QXZSVDBmSy9vMEk0WW45VDh2NHNyV0ZNMml4?=
 =?utf-8?B?YU04YnN1YlNzMm1pRDdsRWwvMk94ek90OFdjdjNrT2k3VWNKclJCcGw4SzhV?=
 =?utf-8?B?bEZoZmpPcC9lVkFzNlZDdDN3VERoUlBHWEtmUncyeThNcDR6bDh5OGNQK3Fn?=
 =?utf-8?B?ckJtQ3V0Mmw5Tzl5aDZiRVhpd0ladk8vZXpwaGRRZTdubEdOYUtKU3c1ZUow?=
 =?utf-8?B?ci94T01EVklQUXFnOVZaUk5WWEJBcEo1SkRpanpDZ01EVzBLQWdTemRTVlRw?=
 =?utf-8?B?TW0rQXY2RWFzZHEwTFBGNHJjUm5qZ1QwTUdZb2RMWjJCL05aU3drZURJOWNw?=
 =?utf-8?B?VTBuSG52bzBjTmpHV3EyU3JZSXpXUVVDNFhmeEExUlJXRW5kcDlvQTZQWElj?=
 =?utf-8?B?OVV6K1RnWVdkMWFlVWlxWW12cDFOVmFZQnpMVVdIenVldEdzcTI1UjZzL2Zm?=
 =?utf-8?B?dXdEYkwvMFhySWIydkUyTVg4QnVaaDljQnE3SWt0MUxpOXZrNWVpejJSVE4x?=
 =?utf-8?B?Mkg2MnFjV1pIK09ZMGozT1ZqT1FWaWt0NVFOM0laOXYrcnk0UFZOWXk3UXcv?=
 =?utf-8?B?M3FFNk94MEFOSmY3dVd6TU5uZ2xyZVdtc2M0aVBhUGFHZlM5WTBqWWQ4YUs4?=
 =?utf-8?B?dFNWZlBocDB2TktUbUgvMWNXOTNMSCtjY09VOWh0Ykg4RnRPbk05VlFpdkRB?=
 =?utf-8?B?alJiQkljQ0NzNDl1YWlPV1J2MHJtb01zdnZ1cEF3dGl3TWtGc2g1eUtZRDV6?=
 =?utf-8?B?ZWRBZHpOdXgyY1NRYmhwSWVlTTlMWWRLNW92bFdIOEZ6c0NFbXpDdzgzSmNS?=
 =?utf-8?B?Zi9UNVplVlhwTFdMTWg1NExjUHNUNWhXTDcyZ2tQNDhSZVlneGRzSVRtTEFN?=
 =?utf-8?B?enZaaWtmdWhGaUVlTlNyRWw0UlZlSXl0THR2Q3E2L1U3aTRqYjQyZXB3MkFj?=
 =?utf-8?B?MlM2S2lIQTJUUHg0eHlYeXZPdFBJbVRYbGxqUmxUQmV3K3RVSC9QaDMrVlRR?=
 =?utf-8?B?Z2NLai8yY1V5WmJhSTRRLzRVVXB1NHd0UjdSRm9BL3oxQWw0dDY0S1JFWWVM?=
 =?utf-8?B?VE9VRDRpanFHSU90MmxIYVBoVVIwYWJreUNzeUVRQ3dEN05Td2xGeCt0SVNq?=
 =?utf-8?B?aFVzeHcwQ3dLUnc0OU53KzVSeUUwZmxjenMyS0psYk94cFM0WG9NazB0NHM3?=
 =?utf-8?B?T0tIM3p5RmJFQi9uczVHeTFWVWJNSzRjTXFHWERxa0d3ZzBrK3NGU04rOE9u?=
 =?utf-8?B?TktQVUdtZFhBNEhLOHJxMkJHN04reGhGR2hFTEhjZUcrazVORytlMHNuNDlN?=
 =?utf-8?B?Ri9BRnJhSHRhdkJNZVlOWXVMVURyZnYrWTdaR2Evbmw0akxtazUxTHBpYTFM?=
 =?utf-8?B?MHMxZ21MQ2hOVkJlSDBQaG01d1ViOWVGUXp6V3N4a3JNamRiTURJdkYyTmZE?=
 =?utf-8?B?cnBJL1BxZDVkUjIyWXVRTHNwQStkWnd2M2I0cVpyREVRUUZwYWo5L2ZJSmc4?=
 =?utf-8?B?NWsySUtVZXhGVGwrL3VIcG9UeVJkVFBZTDIzOW40TVgvdU5ja2VWTjRJYVUz?=
 =?utf-8?B?UlU1VDRsV1FSM0JTOXdkSzg0bkZlelBDeXUyQkVvTVZqYk95TEFNbVhlQTEv?=
 =?utf-8?B?K3NWSlpIeTR0M3N6VkhjRzJCVTdtUnJ0TCtVM3JUSjRXbmxMaEF6ejk5R1NS?=
 =?utf-8?B?WHFQNlRGZTdadG85ZFp5MXRDRjhvejBGYmRRRHo5bnNuQXkvcEh4Mm5kUGhE?=
 =?utf-8?B?SjZBbFhOS2xyR0pMVmNJWHV4L1NQbWpJRWtVbEI0Ull6eENqU3lLaGJhUi83?=
 =?utf-8?B?YkE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bbbfcc25-33c9-48f8-ae8a-08db5016f81a
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2023 22:52:58.7567
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sjC92vdYZjM4NFAjLuwqidnw5tr72PRpAYPfKiPo70VPmt0+Tmm6XbZXt8h4NZCFjnlW97xwQ0r0diU1SmTDAlQnv8FpgqieEJD5eqMfiQA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6556
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-6.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Kevin,

On 5/5/2023 12:21 AM, Tian, Kevin wrote:
>> From: Chatre, Reinette <reinette.chatre@intel.com>
>> Sent: Saturday, April 29, 2023 2:24 AM
>>
>> Hi Kevin,
>>
>> On 4/27/2023 11:33 PM, Tian, Kevin wrote:
>>>> From: Chatre, Reinette <reinette.chatre@intel.com>
>>>> Sent: Friday, April 28, 2023 1:36 AM
>>>>
>>>> @@ -55,17 +80,28 @@ static void vfio_send_intx_eventfd(void *opaque,
>>>> void *unused)
>>>>  {
>>>>  	struct vfio_pci_core_device *vdev = opaque;
>>>>
>>>> -	if (likely(is_intx(vdev) && !vdev->virq_disabled))
>>>> -		eventfd_signal(vdev->ctx[0].trigger, 1);
>>>> +	if (likely(is_intx(vdev) && !vdev->virq_disabled)) {
>>>> +		struct vfio_pci_irq_ctx *ctx;
>>>> +
>>>> +		ctx = vfio_irq_ctx_get(vdev, 0);
>>>> +		if (!ctx)
>>>> +			return;
>>>
>>> if this error happens it implies a kernel bug since the same check
>>> has been done in vfio_intx_enable(). Then should be a WARN_ON().
>>
>> Sure. Considering that if these are triggered it may result
>> in many instances, so perhaps WARN_ON_ONCE()?
> 
> yes.
> 
>>
>>> ditto for other intx functions which can be called only after intx
>>> is enabled.
>>
>> It seems the instances in this category can be identified as the places
>> where the array contents is currently used without any checks.
>>
>> I am planning on the following changes:
>>
> 
> that looks good to me

Thank you so much for this guidance. After adding these WARNs two of them
were actually encountered and revealed that the interrupt context was retrieved
too early in vfio_pci_intx_mask() and vfio_pci_intx_unmask_handler() in
the scenario where these calls are triggered via config writes while INTx is
disabled. This will be fixed in the next version.

Reinette
