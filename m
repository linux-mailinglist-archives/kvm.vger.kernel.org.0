Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B81163BD1E
	for <lists+kvm@lfdr.de>; Tue, 29 Nov 2022 10:41:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbiK2Jlg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Nov 2022 04:41:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbiK2Jld (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Nov 2022 04:41:33 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AA1D2A26A
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 01:41:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669714892; x=1701250892;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=BhVdHndjmIqdyEtwYoh/QAN33cvHOW6gxynAhg+ZuWI=;
  b=P6soj/QEeW7/HM3IKAedQfwrlptne4HB1bXF5aD7HgMGJxDtX+clFuNh
   1dvAhvslat1I3Ko8rA7CgEehBJBdSxEdly9h7JYdJFqh9NLv+fNSMDOzG
   cVGLdklbjI8NE5go/05j9XftaoPv9D3tzZIO0W1Cpy1pntKbQWu1RzaKJ
   e9l993YHqa4xei6I9uUrVcjqlXmXT61Gk6nDnB3WDZX+K36+RH8d2TGV6
   sY0Ygj959qPMPQ2Ow6Nhz+CDiPwldyroQBZLzl7NJYpZBbKjD27YiMKrC
   XTvFVNfAGd4RgvAtDWC4UljXXR3zRZA6oa/dwnBIACKn/K85qMzCT4YjF
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="316202420"
X-IronPort-AV: E=Sophos;i="5.96,202,1665471600"; 
   d="scan'208";a="316202420"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Nov 2022 01:41:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="707149047"
X-IronPort-AV: E=Sophos;i="5.96,202,1665471600"; 
   d="scan'208";a="707149047"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga008.fm.intel.com with ESMTP; 29 Nov 2022 01:41:31 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 29 Nov 2022 01:41:31 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 29 Nov 2022 01:41:30 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 29 Nov 2022 01:41:30 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.108)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 29 Nov 2022 01:41:30 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D9DWHgGfXG0kaL8mBQ9PSCzlfK3vVu0Iht0QoMZSZYlnk+bp2HLL+dOJOVOWtt1aghKQ7HxLXISlFmsp0UhkZRvD40Ju878oAzKwE4V//+NqjpUupDeeyGWTms2bMKJmfFhmYKpRbLAnBziAAITLoymqo2GmRI8iJgPcQSnUVF2J/VzaA53n5tX44zZMNnoZ3SIEIr12hdXcDBrcXyrlg5UE3vY/gjBuTCJ9CtPxOJlJ/pPZmPkoqCkOoBAYFEGG7z+U0YV1D7fmgpe7x8kLBntiTQtI0q2N5vETOeWG72AnSf1EIjxeYLvv8lT+rXsmSQRkFfADF+QIAF2KYHl1wQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MFD7NFvbNr3I2IqBgMBRn/tXxXRvUS73XOcumrMg/BY=;
 b=VeRGiVmYYRCWPKGJLBOfaZ6dZVPawYZ3SQMp8qJk607FmFKBsDOiE6KPLMO6Kqr93YeiH+s2FLR3dW67jrw+eULtgX3cabueBu4CtSimNFKaoOPA4vtOAfZ48lTOSGVFJI11HHtVEXQkC/BE0ypQFQX1bzdWKEXp/NRC3zvy3lKqvQOW7Y3Tz/dCxiK7QyOCsZIvfpPVaWPn5AfwD4y1XNHV3wKYQMZopoSLvD0AsETq4YYNYQD9YdFjKGKqvrj+faN0qideruGcMo5mDr3SbQ/x94toeXtIWsOLFTjUEeKLpPMWJcBT75eenVJR39zdixbiUjraqEYI3KUbELZgOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by CH0PR11MB5362.namprd11.prod.outlook.com (2603:10b6:610:b9::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Tue, 29 Nov
 2022 09:41:29 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::61c3:c221:e785:ce13]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::61c3:c221:e785:ce13%7]) with mapi id 15.20.5857.020; Tue, 29 Nov 2022
 09:41:29 +0000
Message-ID: <88a76a1f-6998-26a0-29dc-26d9b06b9a07@intel.com>
Date:   Tue, 29 Nov 2022 17:42:07 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [iommufd 2/2] vfio/ap: validate iova during dma_unmap and trigger
 irq disable
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>
CC:     "Tian, Kevin" <kevin.tian@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>
References: <20221123134832.429589-1-yi.l.liu@intel.com>
 <20221123134832.429589-3-yi.l.liu@intel.com>
 <BN9PR11MB5276E07F9CB1A006FAC9E4098C0F9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <Y39qrCtw0d0dfbLt@nvidia.com>
 <eb75c2bc-8142-116d-6b03-7a79bf7aef77@linux.ibm.com>
 <Y4UZ6rlEIHGzP6pB@nvidia.com>
From:   Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <Y4UZ6rlEIHGzP6pB@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR02CA0011.apcprd02.prod.outlook.com
 (2603:1096:4:194::20) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|CH0PR11MB5362:EE_
X-MS-Office365-Filtering-Correlation-Id: 70853bf3-bdaf-4050-2ead-08dad1ede3d8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bXPKS7woGOYjcZJTc/S7e+IzE58SkClOOXcRxWTObz+Zt3issQWVHqL/uqdF/YnsGhL2c4ZXuGBnbnxRx1145HQvwrw/E2Cu7xQEEWNLWcIrsyH/CMK9k/xkQRvud0i9QC798n1Kae+Oj+HOkx4q8Pq7msgHWY3NQ3zlcVrmgiw49TgTpUZk1mEJ7rQ0wR+QwJTzSfUYwzA1DByvU4ypNICatyXyk6L88sMlRKrtbDt0FEeBPk1iRZ3DOV+Pi6RyR5lGJ+FnOKnTbAUv2vG9zQWUm8V43uyrvkzmF+YQli/sa8DsAbr4WooW2tV1QZCtpwW815QhabUCp0SwjjU6ER/sjxGoFwOcqrZMyrCd1q3FJuLHeTTrlvv5Epk8snZ/Tiykl+3qofNbg1nTni+zbWDmiu+LhQGRA3YoXe70wzor2x2pftYeBI+SMDdUKUcsdajXlI28lDs5r/e+p6dbsL6TqQB75MHuQHOQW5Xq4z2xTXBOLcRoL99/4Wd1t8IWdXcuDTVrTW1T5YM+TRQU5gNgE0KptIDL5FhSr6K37Ju94yGugMLVXIzNAeC4KaOL3yfQlTKxsicnqrf1cZTWsxshXrovgN4TUw9L2a3I2+YL4oE3Y7SEd4G4g7v9H80YtpUn+VRrfBKsmVcCdUbNxZYKgXwouDcCLR+I4TWkG3k5Fhahyt36EhvzKEBSrdgjSHU+sq9KQBNVPbYEMOGVBQUoWH5UoOfe18VPDzwLmHloaxK03H5BhuRHtNvS3Whx
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(346002)(396003)(376002)(39860400002)(451199015)(316002)(83380400001)(6666004)(478600001)(6506007)(15650500001)(31696002)(966005)(53546011)(31686004)(6486002)(86362001)(2616005)(41300700001)(54906003)(110136005)(82960400001)(8936002)(5660300002)(4744005)(26005)(2906002)(6512007)(38100700002)(66476007)(4326008)(66556008)(66946007)(8676002)(186003)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Qml0K1pva29qVnllNzA2NHkrT1BvcWhBRk5rMTdEWHNDSWtOeTc0bHJtcDd5?=
 =?utf-8?B?Snk5WGNXTjl5QkViVFpWNElaTnlmWnJ2ZzVyejZENDRuL1p3NGR6b2lGQzlE?=
 =?utf-8?B?WTNRYWNGclltMXIvcytRQWFsa3RKMDJnUENteFQvcWhJaDZTUEl1OVFHQ0Z3?=
 =?utf-8?B?cytleE01VTVUMzFhKzk4SGNWZkpwWm9YMHZzTGJjKzlYOFgybkxhUTY4aHAz?=
 =?utf-8?B?dVlVVEl5S3pHc1FTT1IvbHVnT1YyaEpSeDd0bEpWN3A1a2REbG05cjZxR1Fh?=
 =?utf-8?B?Syt5Z2ZJMHdXSi95SFVCckluSFRDSUtxWGNmZ28zbmprbTJhUFZpVUI5Z3hE?=
 =?utf-8?B?cEJKaUg1cThQNHhDM1F6ejdXcUpVYXpkSzVjT3NROHhuU1AxczZyZ3ZueGpN?=
 =?utf-8?B?VzBZb2QxeHpOOFIwL01JZlk3Q0VlM0dnRlFhVDBiY3dpdk5wNmRtQUZWck5r?=
 =?utf-8?B?NTgzdkd3cFBhYzk1SFBUbnphZy9YcEhBcE9qUVZNZjJmdDk1TzVKSHk2VDJX?=
 =?utf-8?B?R2RsWndLNEpvdGxPRlZUeC9WRmxuVExQMW5CZGF5Y1B0ZkY5ck5yOEgwK0cz?=
 =?utf-8?B?VS95VWZNaEZmWXJ1TFRDcTVhd2dTS0NTaXFIRDZ0YmkvOWZwTWY4bFF1NUpB?=
 =?utf-8?B?Q0RsLzFuZkI1YUF4R2graE1KM3BXdU5yMGtDaHZlM3NZRVhuZ2dGUUJ3a2c1?=
 =?utf-8?B?YmFiUys1T2Q3VW1IdG8xUUNSOVY5ZHdITEZHVm5zZEdVWXVBSXZZeVBCc2JS?=
 =?utf-8?B?ZlE0eEtJdkxxeHVaeUxVMTQ5aVExZ3I5UElqT0dLUUZOSGM3WG1BZ21kUElz?=
 =?utf-8?B?WmhmRzhzR0lqRzZlMTBOOWRoSlhsTTZNaHFVNXlNc2RvUnA4Y243UlkwUWZD?=
 =?utf-8?B?blVua0s5c0VUNnQrd0ZRSXhDdUVFeFordTFZM1VCQmpldm1pbW1kZW1lMzRk?=
 =?utf-8?B?Q3N5S3VPREdXYkVGTWpkVkdsNDhIMnVMdEJ6TGVyc0Y5UDYrQ0ljVzhoand0?=
 =?utf-8?B?cUtvZ21BYlFWTkhKNVBtb2MrWnB1dFNOYnMyRmdpYmZTeVR5elBMWlhObzVu?=
 =?utf-8?B?Z2FyQzM4Mm9abUgweXN1OUdNSXczcnBHeEp0MWhFdzdDNnk4M2JKRGlBZWhj?=
 =?utf-8?B?OGYwd2xxdFBnYkdGdFhjeHZrQ2FIZmpLMmE2Y0E2K0RvK1g2a2RHOERNelU4?=
 =?utf-8?B?N1VxaDhCN3JHdENHUGU1eFJHY2pCUXZYajF4anlWVWd6Y0FQeEJTVHVyVVUw?=
 =?utf-8?B?OWpNeDl0dmh3Y0QrYlc4V25EYXFyTzBXS1ZYZUlTL0FYejM0SVZ2KzRWYWdK?=
 =?utf-8?B?anRzcVAyWXNkL3V2Vll4WWluNmxOcFVNVzJxWElSREErM2d3TVAzMUFIZjMz?=
 =?utf-8?B?c2MyL3lDL0R5bjRVTW5RS2UwUmdDMmZDQ3ROUnc4Q1Jnd1pzeW1qS1ZpbDMw?=
 =?utf-8?B?UERITERXM2lpUFRVVDY0U2RyS1gxZUxsRld6Y3BsUjhEd3I4d2FKUDRsS0c5?=
 =?utf-8?B?d0NMM3VLZlp4V0d4Mm9MblZCcjlJdm50TDhVWSszMGZoUk85eksrVXYwM2dt?=
 =?utf-8?B?SGxTUHgvTW9seHF5bE81RnNMOG9kZnNRdDd1TzhsNGcwZDZCb29jRERRUHN1?=
 =?utf-8?B?ZXljcDY3MXhaamNvRDU0RlgzTGhaTWFYVjk2am5yOVhqVk90SVhSVVhQdkpW?=
 =?utf-8?B?cmVObTRkSWw0anZOWDlJTWRmY242WVB5L0kxcGJDS3JKQktrZDU0QXFVbHo0?=
 =?utf-8?B?bE5LRXozTXhuSkRnd1hjcjJ4WWtrQWFYNk8rK04vbUhpVzV5TGM3cWRTQ2xz?=
 =?utf-8?B?ZVdzNlVCT3JEc0NvajF5R3hWZWdQeDd6VmN6TWwydE1RVEZ6NUtOR3IxREdO?=
 =?utf-8?B?R3o0QTNZS2dDYVBGanBCdk5ZOXJtcEhtSDZORDhIWWovcm9LUHdXMVd0WkNL?=
 =?utf-8?B?RzA4QlhqSEh4Nm5lSTRLM0swaGZ3UkhwY0pyYitHZ1hBdFhaejJBekVxSjBM?=
 =?utf-8?B?a0ZqZ3QvRjMyYjJMYm43VFovUkErN3dOZS9jbllRN1hFQzZJTTJOc1UxTjFX?=
 =?utf-8?B?ckhTSG9Wc0JpQlNFM3FFT0F0ZnBSU2oyOEhjc0JVaWtLYXB6TTJpYmZleWpo?=
 =?utf-8?Q?QlZatTqupaqdKm4bAXV0ssWI3?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 70853bf3-bdaf-4050-2ead-08dad1ede3d8
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 09:41:28.9520
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fBo5nlWtGTVBvx7i1Y/r2WRCNX+HiWGsjAP27oRPQcbHB9FMlGqYI5gbqymq2RaW0kx8Z4FmDdfTSpoXQ61t8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5362
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022/11/29 04:28, Jason Gunthorpe wrote:
> On Mon, Nov 28, 2022 at 10:40:48AM -0500, Matthew Rosato wrote:
>> On 11/24/22 7:59 AM, Jason Gunthorpe wrote:
>>> The iova and length are the range being invalidated, the driver has no
>>> control over them and length is probably multiple pages.
>>>
>>> But this test doesn't look right?
>>>
>>>     if (iova > q->saved_iova && q->saved_iova < iova + length)>
>>> Since the page was pinned we can assume iova and length are already
>>> PAGE_SIZE aligned.
>>
>> Yeah, I think that would be fine with a minor tweak to pick up q->saved_iova at the very start of the iova range:
>>
>>     if (iova >= q->saved_iova && q->saved_iova < iova + length)
>>
> 
> Yi can you update and repost this please?
> 
> I don't know if we will get a rc8, but we must be prepared with a
> final branch by Friday in case not.

done.

https://lore.kernel.org/kvm/20221129093535.359357-1-yi.l.liu@intel.com/T/#m261c22a7d9c9b2fe4258c5156f53ea6da97a27c9

-- 
Regards,
Yi Liu
