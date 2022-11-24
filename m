Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 753856370BD
	for <lists+kvm@lfdr.de>; Thu, 24 Nov 2022 04:06:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229475AbiKXDF7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 22:05:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiKXDF5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 22:05:57 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0BE3C8C9F
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 19:05:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669259156; x=1700795156;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=RXs5ERipeLa0jsEckxEwceQRKcXAPlaDsy/6ED3gqfs=;
  b=JbQ04AiLFQbHKTZyhvrv5MNRPPsDili03n8U3/+6TtUhNUvm4RFl7Ki+
   WTiz3w6lUot8jbK0/LaO3zkeGa4qepOeaVMweC2XrbRe4IRLNrkonm7VK
   GwcklQF+hRiDFF+gQfB3IzOuF4cspHDARmb8TBCOqsf1IkQGmpxY4f/ef
   oXcUriZoQZ1OxLY4u3Ifqk84mCYk+hp6hE3J1B8Xqy/J5cn10Q5qupXZq
   Vzl6QOgg1nMYW3N7iLytlnPjn1XZxGauAjk0rE1W3NT5l+sXln/cND9cy
   MI4wu65KtmT6Spc55UawcbWy0h5XH4/kNNapWfDyJrJGZRgXvr8q9wbuH
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="376348951"
X-IronPort-AV: E=Sophos;i="5.96,189,1665471600"; 
   d="scan'208";a="376348951"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 19:05:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="816696915"
X-IronPort-AV: E=Sophos;i="5.96,189,1665471600"; 
   d="scan'208";a="816696915"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga005.jf.intel.com with ESMTP; 23 Nov 2022 19:05:56 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 23 Nov 2022 19:05:56 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 23 Nov 2022 19:05:55 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.104)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 23 Nov 2022 19:05:55 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GxhqlAqkavhdfbB58Y7dqjtCumhCi6E+sC13xv7Ylz2bR34Qv8bvRhcQ1mguJc/FlQhuI2+tO2bCbqaoIdFq2WIYZHRoPv2rYbKboZvW3VeYcMlL5d19Q729y69ldkNExW0ASNVVzRFXawALSrFyLf2isPr7SUTk8iSwdMUSmDisXOD+c89g5yhEOA4XiFu6+Tyg5cpyN/8v2cJ9/dSVENoU54NoAmusrJvGTce6duTbgqeYgMsKL82RGKrVbAFGgS4rAkJci8IfiZaDmuo6oQZxv8sRFtmN6RgG2f/MXv0MUboHoT03RbtbPPoWP2IF4Da9kJHPOKO4nDhjJecYDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s5Y/sgSUxqhouE3vuwI5CH2B4Mjv9XpCeppr6CYaGiI=;
 b=GATozyIJuVTamePJYACPM4n3Kw7ApSRHKnSb/NUadzvOrpy2KlFZX6IE2h4y+PfIHmtBlegpD+gane+eoeWXtQG1xJhDVhWx+c670Ngc6MyMjG7gdEszw4j4qvhYLBPYbjCJcbT3YzZB/mYiIAIozXW5H1xmtIe3qr4o+tT7GXtn5fkWi0YRl1bA4mA8izufjqlhwczGWd9Coy6PIv6NmiMx7jdYhVyVeo06Y94RNlybhYgLRHZ5vFviVNyNqLEnGdZkp/cqHiFP/pNoCYiUKDxTyfX+Y30mEvYuvMcz8qlKjl0WDZLkSGpax+vOaFLVVw5ikBcvrQQsMZSHq/BYoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by CH0PR11MB5299.namprd11.prod.outlook.com (2603:10b6:610:be::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.19; Thu, 24 Nov
 2022 03:05:54 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::61c3:c221:e785:ce13]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::61c3:c221:e785:ce13%6]) with mapi id 15.20.5834.015; Thu, 24 Nov 2022
 03:05:54 +0000
Message-ID: <bcb3d13b-e3fe-b3a0-bcc4-6de55c40fedb@intel.com>
Date:   Thu, 24 Nov 2022 11:06:32 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [RFC 10/10] vfio: Move vfio group specific code into group.c
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     <alex.williamson@redhat.com>, <kevin.tian@intel.com>,
        <eric.auger@redhat.com>, <cohuck@redhat.com>,
        <nicolinc@nvidia.com>, <yi.y.sun@linux.intel.com>,
        <chao.p.peng@linux.intel.com>, <mjrosato@linux.ibm.com>,
        <kvm@vger.kernel.org>
References: <20221123150113.670399-1-yi.l.liu@intel.com>
 <20221123150113.670399-11-yi.l.liu@intel.com> <Y35oda74I+SXK0rg@nvidia.com>
From:   Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <Y35oda74I+SXK0rg@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2P153CA0025.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c7::12)
 To DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|CH0PR11MB5299:EE_
X-MS-Office365-Filtering-Correlation-Id: 903a132d-b61a-4bad-8e1f-08dacdc8ccc2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bv1ke6msJj+R0BvdD12jmcdbLb3+mHn4uV/7JT6XjUXOXmEyAuxUecOY3p0l/m8wpHZzgUVoEkIAKrkhqpyk9r0wNdehqB/6KtH6pnPJj1l4iJZsYpS9lyTHiqT8FKeRCkKgKUxdLIb6v5ofkdnKx5URuiwp1o0nLTeDmxKCb9npAlTI0bBZK9Me46E2thwBhD+u96S06E2Ollg/rmAyMgPqHYdG5kernMt6rZ8HD4qfF2Kk/yd0UPfE83iww4GZQW6YnylO5Vnw0oQ0GASxFJj0zRQwtYqzlDxc78+ev+Arick6zXViLv3sVhUfO7YuAcWHHKzylXewPnNr0ascuQyFkk+fFHJyo7uRbxwoxh35f36e7NWUD3+teCMhZYu0Oyp2MhACbZeV3BHSL9zq9u1RfdvprnEpq2qEmmAHE7fOTxvmpAJxC2d6oydCVRa2qmZ3OarZqWSt/cHaufLUDhCBxWqycu/wS609PMOTwV0M4YAg+O5wUWJgCE+Imnt+17abo3nviMuVs3M69hsPkjneU0/fWr6p18HbGsC+SuTNWOn2ChSYKuoM6aZvmd4sA9iA03sQV0MV9hMttAbr997T6EL6AwDH6WlllP98mzYJWq4OY/XAgCpWmIC2OW0nTPCTlGC7nPhhHcukDkVraeWjBJ+QOWne2pohVa20qWJWAYBcORZ/7LlrDYxGQLx00zbGWQ7Z8hLMgzoeSllfT6hQqg7zuH3Faok+cr1pa8w=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(346002)(376002)(396003)(39860400002)(451199015)(36756003)(86362001)(31696002)(6486002)(6916009)(6506007)(6666004)(6512007)(26005)(53546011)(478600001)(4744005)(5660300002)(8936002)(41300700001)(4326008)(316002)(66946007)(66556008)(66476007)(8676002)(2906002)(38100700002)(82960400001)(186003)(2616005)(83380400001)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SlFpaXYrVERkVnR1NW55R3M2TitBWFlGd0FJUWp2RUdPVmZMcW5ySnllL1Ra?=
 =?utf-8?B?dURWdSszZFdHcUhVbHgrMEhFenEvYXgwWlUvSFllSXpjY2xmZDNjcjcvQ0h4?=
 =?utf-8?B?TmIyMEZJR0tPM0FQYUpwamlRRWtyVkFPMnZRd2xZSFVvcTBveWR6T2xhMW1h?=
 =?utf-8?B?VCs4RmgvY0tCTElSVWhhb1ZQc1pnWTlqeUh5TFJ6U3BLUEZTd1Zsc2h5V0NV?=
 =?utf-8?B?WVBHVVkxN2tyOXZyOWpvcjdISUVMc1Rhb21nQ2VZN3ZFVWtzWkNEdmZJU2Y1?=
 =?utf-8?B?ckl4Q3o1ZVo0Q244U2l2Q09yUUdMNjlUT2FYTDd3cTdIR0ErRXBleEdLN2Ni?=
 =?utf-8?B?MTZOQlRwSFJJYWQrN1pqWXhNdVFrYU9zTzRtRytnMmVnbld1QVhBd0hyWVRu?=
 =?utf-8?B?YW15czZ3VXpOek9iTFdQUEFMWjRiejZ5L0FTSU05LzBEQVFwWWE0TTFtTUJs?=
 =?utf-8?B?ZjFxcnJTd2tqME1pdVVlWFhXL2xDeEgrRDQxV0tzcE9qMTRtN2plVm9aMmlK?=
 =?utf-8?B?bXhxeFYvbnRMc2xNL0NKay9SbTdST3JSaVlZaU41YzBqVmJ3cDVEQ2tUMDd0?=
 =?utf-8?B?S29lZVptOTF3Q3VDTk9udUlnWFRUeHNwekRhdkNnZG8rSnNVUjluOXJ1SGl4?=
 =?utf-8?B?ZDBuc1MrYnNNQWk4dTlCV1FyWHlyaGVvUlRHSlF0QktCc24xMDBBQnFJMGhl?=
 =?utf-8?B?Ri9ZclpjTnZEVG1JYlZON1VSbTllTFZBTk9hYkhaYlRVa255emw5ZXgxVW5I?=
 =?utf-8?B?SmNJdDl6OXAybnJTbkxEeVA1eklqRUdJVDhTVHBNVHFiUDJLendmbzVNM2xl?=
 =?utf-8?B?V09yYS9pYk1KYjdVY3EwdHZUQjh4V3hIb2Zwb2dLSzNWbnl3L0xGNU55WUpz?=
 =?utf-8?B?NEt3eExLTnRZRE9obmFuTUw1RVN0OTVvU0NqRnFtUTNueFk0WEFsVGFvNG5a?=
 =?utf-8?B?R3JKbjErWUg4emhxQTNZNmJZVmVkUndrK3htbldQWmk1b2d5bGNUWFpiTmo3?=
 =?utf-8?B?V3VqT3RmRVBFR0RQZkVpWXBYVUVKVXgyTzF5RW5hdTJMSlgwZ1VoS0Ria2Ur?=
 =?utf-8?B?MHFaVmtDL3VmTGp4NWZkR3lmVDV2S3dzdnFiRnNoUzYxcXQ0Rm9LcFplVjFq?=
 =?utf-8?B?WW9kdzBRdHJXZmpOd2doKzN2eUYrSXA4U0FoSFRZdzkyMGxzYStSUVlEVnZm?=
 =?utf-8?B?YnVwMlYyVTZrNWY5K3BpMEpRMXhZNUtOVGp1K21qR1pqNU9aYVlOYmhoUGlp?=
 =?utf-8?B?VG1SdW43TVg2MDRlcklEQTFQUjFUV05EamlDc3MybTQ4eUN5Y3FXT2NtcUpp?=
 =?utf-8?B?UWdDVDhYa2YwVUtKWHBFWi9Wbi91aUVmNHdVTTAwM2R1R1pXV3lHRk9OLzIz?=
 =?utf-8?B?S1g0OHllUFYvWWpnZlhHRXZ4bGFOYVlGc3pReXdPOElROXlJOXp4M041S2F1?=
 =?utf-8?B?SUVweXBSWG1MZ082UWhiVC9LVVdweUx3b2oxUUcyWXFiSHR6T21nbi9GV0Rx?=
 =?utf-8?B?Y0xTTFN3VXVMM3h5c0tXVWJORUtseDkyMFNnU1llUWxZaFdtZXNSb1BKNlg2?=
 =?utf-8?B?Q0NwcU5uNlJIU05pZDNJQ0RLb2lLZXNVZnVFc3RVUGVybHBxN2IvY0trS0JG?=
 =?utf-8?B?V0hXTlM1Yjh5VUtXaVpzMEZuT1Zoa0Q4dUxRbkRINDJkL1NZa2ZyUVVJTWpI?=
 =?utf-8?B?dnNNYUNMTFV2bFIyRGJpZTVmOS9GdG9EdWN4Q3VvRFRMWnBuUUtpNGMrWmNL?=
 =?utf-8?B?UlNvZnl4MXpFSjI1bS92Nzd6YStkcy9aWU0wTWhQb2prQXZoaFhxcVVjQzhn?=
 =?utf-8?B?N29XTFlabUt1TjZPNDJuVG1KcmhyN1V5ZmNOQUhqaEJzUEJjMHRqNncyT0c5?=
 =?utf-8?B?cGFrT0FiWVJxbmpDeUMyUkpHcjRqTVJuOWdlL28wTHV4bjBlejEvZzM1Ym9q?=
 =?utf-8?B?OW1saUxRMTZtZXZ5MXBqSWFEdlRDS05FS1BRVEZ3Um0zNDF6NnViN2Zjd2pq?=
 =?utf-8?B?R2ZEd2VTSk5xL2JxS2hqOHJIUUZUYVRHQWltKzNXOWpTdU5mZkhndTRJVGlT?=
 =?utf-8?B?ZUVGVERJVTh3VFZrY29GOFZ3MVJCWGtiOHpMSWZJR21YaG5UbFJkelNlc0xP?=
 =?utf-8?Q?/S5b0toTUOZuQlbeoJdgRoMhk?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 903a132d-b61a-4bad-8e1f-08dacdc8ccc2
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2022 03:05:54.1771
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SQ7Y3UIUC74sL9KNrcH4nnUDn3Dq60xlmvxk7UgJ3iaLEY4aBmb404om01XvIWMt5UBK8ey20V4eYjcjrOgykw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5299
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

On 2022/11/24 02:37, Jason Gunthorpe wrote:
> On Wed, Nov 23, 2022 at 07:01:13AM -0800, Yi Liu wrote:
> 
>> +void vfio_device_group_abort_open(struct vfio_device *device)
>> +{
>> +	mutex_lock(&device->group->group_lock);
>> +	if (device->group->container)
>> +		vfio_device_container_unregister(device);
>> +	mutex_unlock(&device->group->group_lock);
>> +}
> 
> I'm looking at your git branch and I don't see this called?
> 
> drivers/vfio/group.c:void vfio_device_group_abort_open(struct vfio_device *device)
> drivers/vfio/vfio.h:void vfio_device_group_abort_open(struct vfio_device *device);
> 

sorry, a rebase mistake, they should be removed. thanks for spotting it.

-- 
Regards,
Yi Liu
