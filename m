Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE55852BBFF
	for <lists+kvm@lfdr.de>; Wed, 18 May 2022 16:16:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238388AbiEROBZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 May 2022 10:01:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238395AbiEROBB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 May 2022 10:01:01 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 605D6BF6
        for <kvm@vger.kernel.org>; Wed, 18 May 2022 07:00:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652882459; x=1684418459;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=e++ukzm0MO5zffEiO+hdjbJxImdfhIu4Xvljfj0Wu5I=;
  b=hMYCLFaN/ufex+4gb5tdbqqMpOJmhRBQCgJQ8JSpJGijmWdT8JJGCaAx
   bZ305AEU0a0mhyZ4+uNCEE3rT4HYBOthqMNV6co9skKRCXeCXjW/wo/xn
   IK2PcMLxtoETLLva8OEJrswP3PG/BBqDmmfoycJz0XBmaYTmcsKBrTEwu
   uiuna6kffdwHuzZIUKzs8BHRqMtZw758696CQ7mFY92xBJkHBvmuBr0zZ
   UC9OQMbdp+Yw77K6X2Y88+8ShCJemfodAFF7NiBl+y0n2KpC5M5M3V8Ak
   TBy/sT5r0BydRv8Y3lFyOPlBG+P1CCm7LuOG8Sg0+VVhb/l9LqduRoi8l
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10350"; a="334730467"
X-IronPort-AV: E=Sophos;i="5.91,235,1647327600"; 
   d="scan'208";a="334730467"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2022 07:00:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,235,1647327600"; 
   d="scan'208";a="639277040"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga004.fm.intel.com with ESMTP; 18 May 2022 07:00:57 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 18 May 2022 07:00:56 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Wed, 18 May 2022 07:00:56 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Wed, 18 May 2022 07:00:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LH5ndT/39V2uSCOjBuiBR7JCYXD5MNTdsCv7Ep7yxr6Iv/BvwDRwefwaEcj78nBLuvqgJ1MniYcjBkIPg7kTQiQhqNdk13lFepFkikrLw0YQjP9w8/T9GQaOEXJo9AjDSlxyk8NniiUpfnGWs15egX8WOk0XFyPF83F/EuJSRRtd6DO5ED7XiW0yydwU+8yAGI9hsbkz5znuHkE2DK5aqpM1xCsJyrGd+Ei5GXIDQaLhYYX24tQJGx3WIoZ4DNIlpI5J1KD3XC6J9o7cBSlGnLAF9/9x5nWROekBoWzp7QRnXSaBf8iLtktgJZ3bQFXwlUDBAISoFb5sB1dFwuoxFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+lu7mCKQpQtQ+FCuY44ud/VkmmNr870A2DweNzcrjRA=;
 b=fx4xlqZq/l/pCFZAmaQTBsjR7Hj8aqHXl5ByHq02fFgWs1wnQTg3QJCnedbr7Ly9N0BlsCzFF88MdeJu1ONkjr3hyIUPOvtwB8XO0T6/XCHQCs3F3mUaheurvVIzAYx9Dzh5ubMPQk5n7Jclb+qx3sBG5kjIm4d2ven7B23uhx7k/w/SQYblR7bbiuQzFGHrdHVhunXjHig31eLBk+wNyr2YTpiw0eIO1wCc91vomOJn4l3Da9TsHh098p/iAUpmj7p/4V0/V9rWyZHSVEjWzD6EJ+k/jRv/FKChCsoHv10OoU1O4sLSU6G/rt6Rb6Zja+e97NJmzbkOCzBebMCKtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB5658.namprd11.prod.outlook.com (2603:10b6:510:e2::23)
 by BN6PR11MB1443.namprd11.prod.outlook.com (2603:10b6:405:8::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.15; Wed, 18 May
 2022 14:00:55 +0000
Received: from PH0PR11MB5658.namprd11.prod.outlook.com
 ([fe80::21cf:c26f:8d40:6b5f]) by PH0PR11MB5658.namprd11.prod.outlook.com
 ([fe80::21cf:c26f:8d40:6b5f%4]) with mapi id 15.20.5273.014; Wed, 18 May 2022
 14:00:55 +0000
Message-ID: <24cb7ff5-dec8-3c84-b23e-4170d331a4d2@intel.com>
Date:   Wed, 18 May 2022 22:00:39 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.7.0
Subject: Re: [RFC 00/18] vfio: Adopt iommufd
Content-Language: en-US
To:     "zhangfei.gao@foxmail.com" <zhangfei.gao@foxmail.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Zhangfei Gao <zhangfei.gao@linaro.org>
CC:     <eric.auger@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "thuth@redhat.com" <thuth@redhat.com>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "akrowiak@linux.ibm.com" <akrowiak@linux.ibm.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "jjherne@linux.ibm.com" <jjherne@linux.ibm.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
        "kevin.tian@intel.com" <kevin.tian@intel.com>,
        "chao.p.peng@intel.com" <chao.p.peng@intel.com>,
        "yi.y.sun@intel.com" <yi.y.sun@intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>
References: <20220414104710.28534-1-yi.l.liu@intel.com>
 <4f920d463ebf414caa96419b625632d5@huawei.com>
 <be8aa86a-25d1-d034-5e3b-6406aa7ff897@redhat.com>
 <4ac4956cfe344326a805966535c1dc43@huawei.com>
 <20220426103507.5693a0ca.alex.williamson@redhat.com>
 <66f4af24-b76e-9f9a-a86d-565c0453053d@linaro.org>
 <0d9bd05e-d82b-e390-5763-52995bfb0b16@intel.com>
 <720d56c8-da84-5e4d-f1f8-0e1878473b93@redhat.com>
 <29475423-33ad-bdd2-2d6a-dcd484d257a7@linaro.org>
 <20220510124554.GY49344@nvidia.com>
 <637b3992-45d9-f472-b160-208849d3d27a@intel.com>
 <tencent_5823CCB7CFD4C49A90D3CC1A183AB406EB09@qq.com>
 <tencent_B5689033C2703B476DA909302DA141A0A305@qq.com>
 <faff3515-896c-a445-ebbe-f7077cb52dd4@intel.com>
 <tencent_C3C342C7F0605284FB368A1A63534B5A4806@qq.com>
From:   Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <tencent_C3C342C7F0605284FB368A1A63534B5A4806@qq.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: HK2P15301CA0016.APCP153.PROD.OUTLOOK.COM
 (2603:1096:202:1::26) To PH0PR11MB5658.namprd11.prod.outlook.com
 (2603:10b6:510:e2::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7f65a020-63fb-4a1a-c60d-08da38d6d362
X-MS-TrafficTypeDiagnostic: BN6PR11MB1443:EE_
X-Microsoft-Antispam-PRVS: <BN6PR11MB1443B8C6C0ED142B410D4B02C3D19@BN6PR11MB1443.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Z16Mm+7NeNG/HZ/ZpG/o9HqQElHbCbizqTNW1pspM36j7AaCFsanx0UhoVhwwjzz40KvF9/eipP0CypHwz9ghv62aTYSddj76dBBS4ZkHVRq8m9jpoqUIA/rNVFoqWUf8yRBHvjX8T0UHHUc5bsb9U9KD1emWjG+H0cIK7idC2Hl1NPc4Tn/Yt2c5X1N6odT4FulPAvcPrx2vaWAqoKIwOb9rYtui9KRAqPyCLDnq//zxTtubHBmbyGMqp6oQVOXcS8ahqYOvMHCNXrDsFuwrV3dQEKBKOQfnZvmsPELSIwVWNKW8KaIiqNvo2urN8Sj56YLWVkxxuQ7510MFPE5fvm1EGJWnW5oKatbknFOgsz6QnhijEzTtL5lxxGFlJ7jsXlcKmxRZoxM9/H2Xml9ldFKb0thr3fQ6l3mbdvQTPdvSbAwZIOWbOC814A0df7grtRz48ZY6g5Fuqfqn/BOcZEIJIhC3ad0AlC9VgII92FymyFsHHYPekF+rI45K8bJN8t3oRiF8NRmKRugOLR0i5BhsaKHLWwOk3No4T2h0aPrj2VtdDHRBaQYDHTnDQ8FOO0zBXx10H0fbdLKBGmxSfVaM94DigjkMCAcRZNyNqyWVcgE5q3uNG7YeKv5XrhTfzUhuD5Z+Nd4UARd4TIB/WB4+LSRyAa3hROUVaZtEbYHGA7NR0gxlapBKxCCFdLx64UXcavK7xYmCKLW52iV1qMWKZl2YXsluc/+I86c4uynODClIXkpwlSrBS9Gkd2CZTTQ8VWUjKCRiqh1CosDPNJ7pM4wKla65/DznsoJQQ+QSuS3U6m1sdBWLdnaFXBT67xwdL2PHJ7umvnb8Svnr67uYeSSHQIdMamXZ9kuu6RNAXqSkvjz4udKJ9MLJ2dEUPAYGwG7Ge1R9sRnhT0kEA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5658.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2906002)(6486002)(966005)(508600001)(6666004)(66556008)(66476007)(4326008)(8676002)(54906003)(110136005)(86362001)(31686004)(36756003)(31696002)(53546011)(6512007)(6506007)(26005)(66946007)(316002)(82960400001)(83380400001)(2616005)(186003)(5660300002)(8936002)(7416002)(38100700002)(48020200002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RzBOSy80eStPNXp5RjRiTzRDcVkwVmNaeEpzKzRXZUpFNTdDYUFHUzlnUHhT?=
 =?utf-8?B?NnprdDRrK1UyaVhxZWFwL2s1WDhWR2YybjgyWjRwb3ZCMGx3QTNDYmpuM3BL?=
 =?utf-8?B?T2FkeE9yM0N4UnNDRmxISkZFZ0tJVHJIa2xqWTdJRmh5K2xRRnMvQzhoVnZh?=
 =?utf-8?B?U2haM1NYV253MG95RDdackVGODdSNDRKNGhhWDNXVnViU2R6b2NrTmN6czFF?=
 =?utf-8?B?bmNVbTFENVpmTG5Gd3c0NzJmQkxjcTVaUkthWVd4ZjdSLzRHY3FuZDhoNGph?=
 =?utf-8?B?N2ZkQjR4Yk56N1dSV0FFZm8wOHpWeHpKVmpEZWRPU0MwZzdXakFVMUhXQVBP?=
 =?utf-8?B?S3lNMnpUaG01UEgzT1RnQzZDVURKcWRnZVp0NXBrVWFYZERlNFllazlQTXc1?=
 =?utf-8?B?Z21kRUJPTFVWaGxuT0cwSmFTcnZtYUwyTk10NEJOQmVlMnJNckJONEduVzNy?=
 =?utf-8?B?NXROeU1hRExTK3l2RTVDY2xKVCsxNndmQXp6dzlMWHN4YjArbTk3TEZLa1Zh?=
 =?utf-8?B?YlJYc3R1TmtUd0hGSTFDU3QxL2NwOHdPQ2VodlN5dXVUM2I0RnNMNDM0R0ZY?=
 =?utf-8?B?UG43WnVFWHNnYVF1Mzh6azVMU0RJWkZRYTB1YmNTSk9hbTJUN09uYmJXZWF3?=
 =?utf-8?B?bGJTQktJOXUrdTloQ05idFgzMDhBTjNqS2pEb081M2gvRzY5YUdEZXRhZnpO?=
 =?utf-8?B?alBjeDQzTi92elQ1YnVUMzBtcS9CeWp1Q1Z0VXhiN3VEK0gra0NHNS9uUEZS?=
 =?utf-8?B?VkxjelJ4MFJwc1Jpb2p6SW1iRnVtaXlLV0dqeVVzSUdzZ0pFcmsyYjVyWHBL?=
 =?utf-8?B?aXJiSGttL2Fja2N0ZXQ3eGhxYzRJQWJJaVoxUFBMMk5SL210TFpnOFRyR3Ev?=
 =?utf-8?B?U3Q0QVdhTngySjlnV3dTRHdaaWVBK0cxZ2MwTzJRQTBvSFRDOHlYbUNyVnhw?=
 =?utf-8?B?V1ZXMmNYbzJmditXRy92ZTVKandBV0pyV3dEUWhMVnNzNmZaSGJ5UGF0T1FE?=
 =?utf-8?B?TjVNNHlsQkEySURweVhhWGVSMjQwYlhyWTd3M1lQaGNrdGM1YmgzaWd4aDNR?=
 =?utf-8?B?ajZyMFpTYkY3QzhTTHFXcStQem9aK2JFTDRWM1g4WURFT0oyVnVTTG5pTXR1?=
 =?utf-8?B?VVFBR2ExeDVnQnpXRjhkWUFmMURsYTU2eHlVSC8wUDlyL2Zuek4zU0hPeXpv?=
 =?utf-8?B?MDdjejR5YlUrREJYOWY5cjQ5Z1h6QUxiaVZaTkVwemlDYkt5TXAxOUE2RGRH?=
 =?utf-8?B?emtOTndBOGllRHF6VXA3TzAxMFZnOC9YNWNPL2pjYnh4NjVLNTFhWGFRUWNy?=
 =?utf-8?B?Q2hCbWFGYXAyL1JjQ2N2OS9jcGZOb1BINloyM3NtMXBUWE1oam5VSEhtWGJX?=
 =?utf-8?B?V2VWT29ld3pkeFhZMGdTTTVBUFk4cmNVT3lyZk9VclNmZmszUWxkT1I1VkZk?=
 =?utf-8?B?Q0xCbVZERmh0STYvZ3M5N3RuTHN2ODhiYXovNHJ4aW5CamJ1NUlBOHJyOTUw?=
 =?utf-8?B?aGZQa1lUSW9xV2N3SWtTUnIwbmNqd2dzOTRqZzdjdXJYS1JueDBsK1NqdVgy?=
 =?utf-8?B?UWJpeXdWbFdJZFQrQzFrYUNKNy85Q0FOQUlzRWNzbFhVaW4wZ2xRV0lPekk2?=
 =?utf-8?B?RUxtR3ZZU2FGSnk3YjBUbGVyWHhHSUIzZzdJRkV2ajhkTzlYUmlwOHpPRUpP?=
 =?utf-8?B?TER4QjRQQlQ1c2hpcWtmRmdRQzdTSVhJWGFkbzZNcHFaRVVsU01CRzNQQ1Rw?=
 =?utf-8?B?b0RRdExkZDhheGdzLzVCUWVEMFh2TVBxWGlaNTdpcHVFaEppcDZEM3hwVFRp?=
 =?utf-8?B?K1d2dVlpaEVVamI2WENWYzJEcE9mc3JZcHlqNCt5TGtibkZzbWErRExHMFpS?=
 =?utf-8?B?M1lHOTc5T2NtOGVLb2t2L1ZYTEpZRUV3SENiMC9GcHNjSm5rSEhxb3hpaS9O?=
 =?utf-8?B?R3ZYaC9aV25mdUxHSis4NFRVS21pZkNidkluVGNIY3BJbVFneE5nbFlXWGp3?=
 =?utf-8?B?Y1UrbEVma2h4Qk1uOWdaUldoTXhnMEo0ZmdCN0ZqVnFnZjFYUkl6OEtaVHBJ?=
 =?utf-8?B?SFVyU0RpR3pxTGtkU0RMWS9FR3ZhRFAzd001c0hJSWY5NTdQcFo4U3NqWE8z?=
 =?utf-8?B?dnc1Tk5Yanl2c1p0bHNIVGZOYWc2dmxLeStzZnNVbnVCQmo2aEVBVEFLY1R3?=
 =?utf-8?B?RFEweWpRcFNraTlLM25zN0tnOWRqNW96VFlDeVVVZkpaVWV2QWdOczNnaTRo?=
 =?utf-8?B?MHNlZkZjdFdOQ3IyNkhFZUg4OGdLd1l5VFhJdWRDaURJY1lMYWpxSjdMTlhS?=
 =?utf-8?B?cXRxeEhRWWNVTGx3YzVjdEVLc1hQMHY4Z1hOelMvdE05d0ZUQjh3UDNMcmg4?=
 =?utf-8?Q?gYyL5HRIflROv37o=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f65a020-63fb-4a1a-c60d-08da38d6d362
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5658.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2022 14:00:55.1030
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E6e7w9F7LFwf1nFZW/2l9+y7Vs/VdZsNquFupMxoeuRvWwbeSLoArhaMHADJbXuI0IaKOlzrhvFFJicdexIJtw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1443
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

On 2022/5/18 15:22, zhangfei.gao@foxmail.com wrote:
> 
> 
> On 2022/5/17 下午4:55, Yi Liu wrote:
>> Hi Zhangfei,
>>
>> On 2022/5/12 17:01, zhangfei.gao@foxmail.com wrote:
>>>
>>> Hi, Yi
>>>
>>> On 2022/5/11 下午10:17, zhangfei.gao@foxmail.com wrote:
>>>>
>>>>
>>>> On 2022/5/10 下午10:08, Yi Liu wrote:
>>>>> On 2022/5/10 20:45, Jason Gunthorpe wrote:
>>>>>> On Tue, May 10, 2022 at 08:35:00PM +0800, Zhangfei Gao wrote:
>>>>>>> Thanks Yi and Eric,
>>>>>>> Then will wait for the updated iommufd kernel for the PCI MMIO region.
>>>>>>>
>>>>>>> Another question,
>>>>>>> How to get the iommu_domain in the ioctl.
>>>>>>
>>>>>> The ID of the iommu_domain (called the hwpt) it should be returned by
>>>>>> the vfio attach ioctl.
>>>>>
>>>>> yes, hwpt_id is returned by the vfio attach ioctl and recorded in
>>>>> qemu. You can query page table related capabilities with this id.
>>>>>
>>>>> https://lore.kernel.org/kvm/20220414104710.28534-16-yi.l.liu@intel.com/
>>>>>
>>>> Thanks Yi,
>>>>
>>>> Do we use iommufd_hw_pagetable_from_id in kernel?
>>>>
>>>> The qemu send hwpt_id via ioctl.
>>>> Currently VFIOIOMMUFDContainer has hwpt_list,
>>>> Which member is good to save hwpt_id, IOMMUTLBEntry?
>>>
>>> Can VFIOIOMMUFDContainer  have multi hwpt?
>>
>> yes, it is possible
> Then how to get hwpt_id in map/unmap_notify(IOMMUNotifier *n, IOMMUTLBEntry 
> *iotlb)

in map/unmap, should use ioas_id instead of hwpt_id

> 
>>
>>> Since VFIOIOMMUFDContainer has hwpt_list now.
>>> If so, how to get specific hwpt from map/unmap_notify in hw/vfio/as.c, 
>>> where no vbasedev can be used for compare.
>>>
>>> I am testing with a workaround, adding VFIOIOASHwpt *hwpt in 
>>> VFIOIOMMUFDContainer.
>>> And save hwpt when vfio_device_attach_container.
>>>
>>>>
>>>> In kernel ioctl: iommufd_vfio_ioctl
>>>> @dev: Device to get an iommu_domain for
>>>> iommufd_hw_pagetable_from_id(struct iommufd_ctx *ictx, u32 pt_id, 
>>>> struct device *dev)
>>>> But iommufd_vfio_ioctl seems no para dev?
>>>
>>> We can set dev=Null since IOMMUFD_OBJ_HW_PAGETABLE does not need dev.
>>> iommufd_hw_pagetable_from_id(ictx, hwpt_id, NULL)
>>
>> this is not good. dev is passed in to this function to allocate domain
>> and also check sw_msi things. If you pass in a NULL, it may even unable
>> to get a domain for the hwpt. It won't work I guess.
> 
> The iommufd_hw_pagetable_from_id can be used for
> 1, allocate domain, which need para dev
> case IOMMUFD_OBJ_IOAS
> hwpt = iommufd_hw_pagetable_auto_get(ictx, ioas, dev);

this is used when attaching ioas.

> 2. Just return allocated domain via hwpt_id, which does not need dev.
> case IOMMUFD_OBJ_HW_PAGETABLE:
> return container_of(obj, struct iommufd_hw_pagetable, obj);

yes, this would be the usage in nesting. you may check my below
branch. It's for nesting integration.

https://github.com/luxis1999/iommufd/tree/iommufd-v5.18-rc4-nesting

> By the way, any plan of the nested mode?
I'm working with Eric, Nic on it. Currently, I've got the above kernel
branch, QEMU side is also WIP.

> Thanks

-- 
Regards,
Yi Liu
