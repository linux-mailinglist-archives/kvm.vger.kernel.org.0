Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C8336385B4
	for <lists+kvm@lfdr.de>; Fri, 25 Nov 2022 09:57:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbiKYI5m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Nov 2022 03:57:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229766AbiKYI5j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Nov 2022 03:57:39 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B42BD2BEE
        for <kvm@vger.kernel.org>; Fri, 25 Nov 2022 00:57:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669366657; x=1700902657;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=qIyrT2wV5tGRyE/HoRNtZPGmyz+Q9sqv21Y8xSm0B5o=;
  b=S2OO67gSWF6+NElwrmF44u9qXwJWAdCXsMGGyktfblxSqx0pDOa8r16j
   Qm0UZUclbqGTHvIZpHNw4sEn3u6WzFecFgwSUkhHQ1FRpJjcjof4a1D24
   fzVSRQRJLGTlZfSyszqHl3VFdiIjl6njVzbwKALu9ehZrC+p8QPajtiwA
   6lspRXYfhfBNDyd5gr5lwzmxg1UvpGdMK5WtAKv0dG2kmDaUHPhLBwhTb
   +gK0Xz5QfPvXMKbY4OVM/pH1ZkvESJpkwitSYn2Mn8MDwTGReh4vvnVwn
   S2RKT2zOBzygTshheaEO1BLDci+fsnBdTe92f1dxLjXx9oFEiqVLP1W0R
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="313141267"
X-IronPort-AV: E=Sophos;i="5.96,193,1665471600"; 
   d="scan'208";a="313141267"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2022 00:57:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="971509050"
X-IronPort-AV: E=Sophos;i="5.96,193,1665471600"; 
   d="scan'208";a="971509050"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga005.fm.intel.com with ESMTP; 25 Nov 2022 00:57:37 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 25 Nov 2022 00:57:37 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 25 Nov 2022 00:57:36 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Fri, 25 Nov 2022 00:57:36 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Fri, 25 Nov 2022 00:57:36 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M0AdiNye+0O+CrK55DCZvQsP5j0lVRZxsF7nibiq31H+3nUii+Xfmxsi7JxeZAribMnlm9roYzVCnW4J3yhKRDKdLFgVdwkuhde3zuyVYf3zxqg4SlxnS3U44Uj+iXINy3O8OZpV8VcDF1Pa8NKZEv7SkTdhk0j7AiQ6FpM87Vm6yjSf9B0JOp7pQp38ffjo7h4ETsvh50RRwDhwOdjVWFuQvfWGXl+7/VvuATl5a8PtKb6WQ3PHc87WIrx3sSylt6zAkF7dtdkJxxqdR8HlpLM/3Eift+oY8bbCehqDNmex+fWiWAKLgJppwJzGfr6tr4kZOVQXYTa5wPubzVdW0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1oFaEU1okAMYc8om02PsiDPEkwdkpgVzqaYxgoFw56g=;
 b=nRm4B2RwHFpUxL1eG3j/RnbgOiGy4w0A51+21WkEfimh7XyxDJTuWbnfVbxYfNrrXN3z6zjUFRVNNbUFgUSzVn2jTdkcBFg0bIvycdOuuxNSmhFIBfH1KEz5JIx9D2HsNYhkPPymSk0tCA1x1F8pFwdsSCxEzakwIDVcjTspNk3dxvTxkjQxIGUGD4pneW9GiHi68ZVCYBrB8t99vRWUYrL3HFJXg20+czOHJzncKI6aDeGcvbJAblRi1+TQQP6UoUfAh/siHLwyxPFMjxdwGb+gNqIUIT6kif8g9X78197h4bRjQDagDZ52kPP8XQHrGlLu7GAP5qRMrXEAZhe1gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by CY8PR11MB7686.namprd11.prod.outlook.com (2603:10b6:930:70::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.18; Fri, 25 Nov
 2022 08:57:34 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::61c3:c221:e785:ce13]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::61c3:c221:e785:ce13%7]) with mapi id 15.20.5857.020; Fri, 25 Nov 2022
 08:57:33 +0000
Message-ID: <39b78f2f-7c1d-39d6-daa7-3a6b3c9620a5@intel.com>
Date:   Fri, 25 Nov 2022 16:58:12 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [iommufd 0/2] Make mdev driver dma_unmap callback tolerant to
 unmaps come before device open
Content-Language: en-US
To:     Zhenyu Wang <zhenyuw@linux.intel.com>
CC:     <jgg@nvidia.com>, <alex.williamson@redhat.com>,
        <kevin.tian@intel.com>, <chao.p.peng@linux.intel.com>,
        <kvm@vger.kernel.org>, <yi.y.sun@linux.intel.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        "Halil Pasic" <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Zhi Wang <zhi.a.wang@intel.com>
References: <20221123134832.429589-1-yi.l.liu@intel.com>
 <20221125060637.GW30028@zhen-hp.sh.intel.com>
From:   Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <20221125060637.GW30028@zhen-hp.sh.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR06CA0007.apcprd06.prod.outlook.com
 (2603:1096:4:186::9) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|CY8PR11MB7686:EE_
X-MS-Office365-Filtering-Correlation-Id: ebaea334-3f8d-4ec7-f6a4-08dacec3174f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cZqdDusuhqqwRo7F7dlumB2kWGxjBQf+AKo1+cVG91DK7FNQAS7roJdJJL9nLfphV2nvCUOEH4RYB3U9stDHJA9LYXjquwAMSu3wXE35eQ+KusSByu/u3LmhwaFaVq/1bgTzpYqC5Dkg9g7YnOjjqGFH+tJrJSV+jNnsjwQ0rVXp/Ci6lk4F0cLqvB/d5CH3uNS7fKj8EGnRLEI/4e0ne2D9TWxMavuIh+PygE3YV3R2NsBhy+jbb72GXRn45EYoXx8iEX7h2g9LTq0K/2Sl4tNcRwGrUDwUhRQKkASunMKSt8WNT2u4RMW8LPhAkmdODAr9iaZxRgKgtoFxLmZImkv0isFYvKfBsIVQepfcyvrxiVkXhYij2uHNBY34KL+kp951BTM6gtPAVAdr8Km4bPo4f407mHjWJZJ7aw1ZiIT8E/ix/8STJOfM2lwCEuSZWvbULqc2AeIXZQWiRyeG94PhxzLUyM5NBB50qCDhTAE66iqZ2I0uwkQPkGHcj2cZ9QHoQGtlKkuMXbb07XcJ9RMcB/nLKbkZO8nQf417mPZ1j8rGAQWHgMZdi9cEKVS2KLRRjSfcyClJ7jHc595/OL4Jm6RK1M00ZaBkoHhu1gCK7dqO3z2KnaS6s2dEPoGC4DgYLke1/IsZuZpkBakM4NjdOdZXucp76V16XeJjU5UINK+6H6EB58FSU683GQ6HaLB+vXk1YkzILyyeAq6jOzC0D6fk/US2cr2eQ+QN2FslakTJZuBXlzEIeT2BaP6yxZXYoQQBsEFYd434Vp9ixg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(366004)(39860400002)(346002)(376002)(451199015)(83380400001)(66946007)(2616005)(4326008)(66556008)(186003)(66476007)(478600001)(8676002)(6666004)(86362001)(31696002)(6916009)(53546011)(316002)(36756003)(6512007)(54906003)(6506007)(6486002)(26005)(966005)(8936002)(31686004)(41300700001)(38100700002)(82960400001)(5660300002)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M2lvU3dveVhXdFlIem1NSlhJRFlWd0lkdlhmWWc1Rit4TDBwcENYYTN3ellq?=
 =?utf-8?B?SE5UTWVZdTBDL1U4cEg3L0piYWlEZlEzNmxxVnRuVWk0V2l0NjV2YXdhZStR?=
 =?utf-8?B?SmRNdjR6eFJaaXpreFN2c2lObWNxRmVkUW5OOWtHNjVIN3hLRkU3NmFNditX?=
 =?utf-8?B?UEUyaEpPZGxHUmdpT3VZSXFGaU45TUdoUnEyeFUrcVc0RDRWbmwyYzQzZUo4?=
 =?utf-8?B?c3Z1d3h5MDBPLzlOaFcxMHA0U01pTzBzeDQ3TzBtaUk4K0hRSVF4WldjRit1?=
 =?utf-8?B?dGVjV0JPdjh3b3JYQm1GenVvT2k5cmVjR09HTzYzZjB4VW1XdW9wR0VxdGU0?=
 =?utf-8?B?Vkc0WnQ4NjVTTW5UUVUweVVSNVpUWmcwcTByWWwrSHltc0dlNHI3cU9ZSHN4?=
 =?utf-8?B?TUszdys4VmFLeTdtZFlQUTB5UkRlWWdvOE0xTTdoQjN0OG92MnRMeFZYSlFk?=
 =?utf-8?B?WXJ4U3FjU2txN081YmQ0VTV2YkVBdmJLa003SWk5RlkwRlUwM3pVa2dkd2hw?=
 =?utf-8?B?U3N3TFV2SDJwQTQ4a3ZLamg1bE9HdXE4T3BqaEZrRmh2YnEvYjVsY2dJa1hm?=
 =?utf-8?B?dnBTM0VXcWY1UDEvbjE3Y0N5enRjVThLblYxQlBoL2ptckNsVXAvakdGbUNE?=
 =?utf-8?B?blNCYkFReWtmUXpGeXZZWEFYVmxRYXhUOHhjcm1xM0JWd1ZUWmxFOE9XWWgy?=
 =?utf-8?B?NFYwVVRYS2xKd2R6bG5FV3I2d213UXk0dmRqSHkzMm84MkFDNnN3WEZtR1NW?=
 =?utf-8?B?MEwya1VYTFlPTFJMbDMxRWNVZWlDZTJGRUQ4cmEyZGxDVklqdFBtZHE1bWZK?=
 =?utf-8?B?eVA0b0V0L3NDZUVqT0xZWFp0NWYxKzlLb2NLRWZxbXppVVNrNXVnT2tZM05R?=
 =?utf-8?B?eFlVczd2bVMyQ2FhaTBLQ21HbmZ1S0dCSmpWbmhidFpaV1ZlMm9TTVdlc0tN?=
 =?utf-8?B?MVZycFpsMkUvY3N4VU8zdEpvWkpQcEFBdGJqcjBTZXFpT3N4UGdUcEpGdkp4?=
 =?utf-8?B?Uis1SWlIV3hOZGRzbUxURk5MWXM1elFZSHNFUG9WOWtOUlpoTUkxUDNiNk5z?=
 =?utf-8?B?aUJxVk01d1ZUVFVCeVE5Y2IwczdxOWl5VVF2UHVsT2lxK0dBSWtYMTB4TWRT?=
 =?utf-8?B?ci9uNEdqVU9KeVV1VnNlak1USWZXNWtEYmxGcW5iR3ZSRy9HSlFNeDBOQytX?=
 =?utf-8?B?eW5IZHB3SDl4SytGcjltODNxTWE5Ukc3RUUzNlZjY1l0am1jaGMrT1RoZkYv?=
 =?utf-8?B?Z3FlYkFjaG90M21DVHIvbDd2Qis5a3U2SnlUWGl4VUF0VmtiWHZwbFRlWFJx?=
 =?utf-8?B?V1IzSnlvb0NtL3VOQzZrMjFqV1pnQUJQTWlaRW5pYWtGTG14QmV4ZHIzWlh6?=
 =?utf-8?B?QnFnOFdhVll6ejlpUWxNd3JTU1ZSYVhMeGc2TEszMUdKcmxQSGFIM1dDSHIx?=
 =?utf-8?B?aDFyMVFSRGRWT0dJR2ZBOVdCQ2lxdlM4MGhneDUxRVlFZ0p2WWNQckl2N2Vm?=
 =?utf-8?B?QjhWZ2N0NVB1VkxZODZKVmlNQTczTkRhbXhhb2N0ZFAzRFh3bXhMWWtUQThh?=
 =?utf-8?B?cXFsY1FEemRmWjIrOEc4blRLUzgzUWdmNjV4OHBRZ05IMjh3b2I2ZnBvaTNn?=
 =?utf-8?B?Y2RXTUlFdW1RSC9xRDMrT0lqeTdUMEdPSHg4NWhEQ081RlZWcHJuajZDTlov?=
 =?utf-8?B?aENURGZUZEYxT3VuUVM2cHpJbkkvYlNCSmVIRDZJMFFTYkNTOHUxaWROdGEr?=
 =?utf-8?B?aFdhNThwN3QwenY2Y2UxNVpSdXJSVXVPRWo3RlVldzFNSVluemx6NU01bjI3?=
 =?utf-8?B?RXRac3JBQ01QSVd3emFxQm9jcmdZWWhlLzlIOTRnSkJ1NlRCSVFjMDBOdU80?=
 =?utf-8?B?R3l0NjhFRTdCRFZsTDZ2cUVwMUVaV3Iyd01JUUs5alkyMEJKQW55QS9LQjFp?=
 =?utf-8?B?VGpkcjllQ1g5UzNYcjZNd2t6dEZwWlk5MzdyOStCRG1TMElpWlpkdjlDb29T?=
 =?utf-8?B?R0kxTGhIbDVXU3hMNVVwdkRwRXhSWVZaT0pISk5WRXVUT2MxSENEWUh6bGhW?=
 =?utf-8?B?VmpJR1NVRzdtZTBpMnZCamVlWm5BdEJuTzhRS2tTL2lwRkptL2xTdGZyY1dJ?=
 =?utf-8?Q?c7k5RSNQ9HfbG6u+sCFfTVRh7?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ebaea334-3f8d-4ec7-f6a4-08dacec3174f
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2022 08:57:33.4531
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DTxk2Fl5c3sxmX87xcBT4kMuPJU6bg05DL/oqqWMapG68+mjQ2GnmjZLDqhHk6OpDvS8hwe/gkOyhzWu+xQcBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7686
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022/11/25 14:06, Zhenyu Wang wrote:
> On 2022.11.23 05:48:30 -0800, Yi Liu wrote:
>> Jason's "Connect VFIO to IOMMUFD" introduces vfio iommufd compat mode. Under
>> this mode, vfio_iommufd_bind() creates an access which has an unmap callback,
>> which can be called immediately. This means mdev drivers may receive unmap
>> requests before the mdev is opened. For now, most dma_unmap() callbacks are
>> tolerant with such unmap requests, except for gvt-g and vfio-ap. This series
>> tries to enhance the two drivers.
>>
>> This series is based on Jason's below branch.
>>
>> https://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git/log/?h=for-next
>> (commit: 57f62422b6f0477afaddd2fc77a4bb9b94275f42)
>>
>> Cc: Tony Krowiak <akrowiak@linux.ibm.com>
>> Cc: Halil Pasic <pasic@linux.ibm.com>
>> Cc: Jason Herne <jjherne@linux.ibm.com>
>> Cc: Zhenyu Wang <zhenyuw@linux.intel.com>
>> Cc: Zhi Wang <zhi.a.wang@intel.com>
>> Cc: Kevin Tian <kevin.tian@intel.com>
>>
>> Regards,
>> 	Yi Liu
>>
>> Matthew Rosato (1):
>>    vfio/ap: validate iova during dma_unmap and trigger irq disable
>>
>> Yi Liu (1):
>>    i915/gvt: Move kvmgt_protect_table_init() and gvt_cache_init() into
>>      init
> 
> btw, for gvt change, pls at least add intel-gvt-dev@lists.freedesktop.org in cc.

sure. :-)

-- 
Regards,
Yi Liu
