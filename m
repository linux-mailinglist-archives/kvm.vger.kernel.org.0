Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43CCE6C1ABC
	for <lists+kvm@lfdr.de>; Mon, 20 Mar 2023 17:00:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232206AbjCTQAc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Mar 2023 12:00:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232244AbjCTP7k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Mar 2023 11:59:40 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05214136D5;
        Mon, 20 Mar 2023 08:50:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679327402; x=1710863402;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ABUff1hlzXanqtbyNEII8GxMAqrZM+Nuz4Bpnsl7918=;
  b=k3FebQsFRPMoJ3x72NWMlmgEjvcM5Y0Rema1428RfWtvQxU2T0vI5qao
   aGBZVS4sCwyGUoofyzXotfelANSwNTfOyqGfso1BPYHtDkBaLGMG1acg8
   DCteQI1c8DYk155n/RYebCm7s/AeLDWHRewSWI1d2/I+vN4oVleKlmuuZ
   oH9dECai5wJbjm6O5j4mE8oV5udiNaxLwpkXKNTpR2HQ3d9haUg/iK6KK
   A5yOljehxQ2vmwJIR/yRkj6HrsF1YlS5/YJDRkJ0Jqk7o5vW7mC1HpVjN
   453f/uHlfF/qBw8J5KXKMEC9MQ2FyFc9oPMqchXTm6QcY4K6j1Y5x+O1F
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10655"; a="319095259"
X-IronPort-AV: E=Sophos;i="5.98,276,1673942400"; 
   d="scan'208";a="319095259"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2023 08:49:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10655"; a="674430096"
X-IronPort-AV: E=Sophos;i="5.98,276,1673942400"; 
   d="scan'208";a="674430096"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga007.jf.intel.com with ESMTP; 20 Mar 2023 08:49:11 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 20 Mar 2023 08:49:10 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Mon, 20 Mar 2023 08:49:10 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.177)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Mon, 20 Mar 2023 08:49:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PDki9WWJPFEkoOTZjLrvfhWee/YWW+z7CXXw0wYuTmOwxJTwX971HJrr6VNLErhcjdYyCMGFlbkM7zS4lXnwDrfc0is8jfcUqP1hwEFqzjoFBAYUQMh8ruh2Jatwstfw3TTrAWNKQ0EuIzrwyLLqHgARKpi2GubSB3HjG53tmkt8tpP37L5dxwf0QlWqNPBACTN0M3zV9Qg8dpkX2LiJz6v7NQAE1IQ/qr6z/AMaUomlG0a0XxJxSXvBrFDNZb4ewBRAkq5BbTFpoMx0imFz8O/3NlrTloMNI9bc3WNeWJGaoJldSotnWKFFK8DIJdvUdhV7w91X/fEp/UtuvoyFDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=73QcSB/5bV2s0FtyCVCfDUWe1W79AR/68xVCh0I7XfU=;
 b=n4WIDCPkkSv/wdHuIhgxR1/97zPJ3jj0eqyo0A31oTbpmrQVkM/2DysM61pUuJV9t3gEINFjLu21zzVN60D20N55pzGN4H28kTas9cHoByMbe+yx5EcAW3fFsTuxufmvxeELSPvBIJ8G2u+SEWgTRyFBdoiYMciy79DeMsN2LtZmoWAnHx8QNn9lW+bG7CTUYo2mYVlutOI8onYyFLbmUBwKb7fgCbVW/gR2TT08iL0vqwS8YTdNYKw4ZfUlveaZR5ugsWJJpQkdyEiLjBLQfJakOj5BhyvUYADaUP+PK7+7ICHroCZLURQ3Vho0OeKkL0CbcI/lchlJRAxz4bDKNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY4PR11MB1862.namprd11.prod.outlook.com (2603:10b6:903:124::18)
 by SA0PR11MB4574.namprd11.prod.outlook.com (2603:10b6:806:71::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Mon, 20 Mar
 2023 15:49:09 +0000
Received: from CY4PR11MB1862.namprd11.prod.outlook.com
 ([fe80::d651:ac39:526d:604f]) by CY4PR11MB1862.namprd11.prod.outlook.com
 ([fe80::d651:ac39:526d:604f%12]) with mapi id 15.20.6178.037; Mon, 20 Mar
 2023 15:49:09 +0000
Message-ID: <15acd66e-2395-8c4b-d2a0-2eeeeadc3bb5@intel.com>
Date:   Mon, 20 Mar 2023 08:49:05 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.9.0
Subject: Re: [RFC PATCH 8/8] vfio/pci: Clear VFIO_IRQ_INFO_NORESIZE for MSI-X
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     <jgg@nvidia.com>, <yishaih@nvidia.com>,
        <shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
        <tglx@linutronix.de>, <darwi@linutronix.de>, <kvm@vger.kernel.org>,
        <dave.jiang@intel.com>, <jing2.liu@intel.com>,
        <ashok.raj@intel.com>, <fenghua.yu@intel.com>,
        <tom.zanussi@linux.intel.com>, <linux-kernel@vger.kernel.org>
References: <cover.1678911529.git.reinette.chatre@intel.com>
 <549e6300c0ea011cdce9a2712d49de4efd3a06b7.1678911529.git.reinette.chatre@intel.com>
 <20230317150554.6bf92337.alex.williamson@redhat.com>
 <61296e93-6268-05cd-e876-680e07645a16@intel.com>
 <20230317170149.2be79d5a.alex.williamson@redhat.com>
Content-Language: en-US
From:   Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20230317170149.2be79d5a.alex.williamson@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0379.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1::24) To CY4PR11MB1862.namprd11.prod.outlook.com
 (2603:10b6:903:124::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PR11MB1862:EE_|SA0PR11MB4574:EE_
X-MS-Office365-Filtering-Correlation-Id: c3804d5b-993e-45d7-f509-08db295aa456
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mKVyT6oFi8ePw85jeI0hkZirFdMNUap0JW0K/+s74RWkPVyXQotPjx98XXNU5VjgeWhw/pybzkvpiLA5eFlfxXF3C/VwWJbZsKDoP3RZHyH2p51/G3/1RRugtavg6xOJzaXp6GWh3OzqDoqXtwnFVcoFcocbqZ1yhC+6jrKZn5Iw06bRUQszi9KSqfLMMqNr24CFPA02lsFnLv6LOxbAmJHqCUdMWYgZmrp89vqx17BLxplODU9PHYVndxuA3FIxmW8cNYygmSC5GGzL8v78G1A9p/uyzid5bvOfOugr0EapfOuiT45g1Wn+BB/72RXMYzimEOdwAV1tTsG3G0lfXKkMwM5mCsOTo7K2swNwZljbBDWOeGU26AjONAOOLGBh9PA+IPu8iGwXg5nCc9Mc1cwGEuko3wkw4wk6cnQ1jRUoVaoq/QvsTvnyOCRV1NixJ441ts/kLSzhfdMLTFPXmWjY0e9+7yxe0yHte9ExomEWzEv8+eYOJ4JvVtnP5uCE88a28yGSqx9knVVcW60/J1aFmz1Dm45nZVFx71VtX6urXxQTU+h6VUrxx3LjRT9O5OE/sU3ZGya4X9n6mFfepNl/6Q1jKF98dEXnsbAIgVpfZNpGmQC0iKq7HPKYG9cIjrFDX3zm9SvN9+nswMMQLBfLlNbNnaASTxKRwPzGGAY8/1qWna2eKBSlgSOU+nHZzF4RU22knOWF4gFUj9p+W9DylZ7Z7+Qtm1JtSZBvmx8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR11MB1862.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(396003)(376002)(136003)(346002)(39850400004)(451199018)(44832011)(8936002)(5660300002)(41300700001)(36756003)(31696002)(86362001)(38100700002)(82960400001)(2906002)(4326008)(966005)(6486002)(83380400001)(6666004)(478600001)(2616005)(6506007)(26005)(186003)(6512007)(53546011)(31686004)(316002)(8676002)(6916009)(66946007)(66556008)(66476007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?STFad3BqREZnRnpNN1lsNFp3cWhaemQyWm4vdllJNlErNDFHMjRTTnN6S0R2?=
 =?utf-8?B?dm1yYnNmN2hXMXp0bVNsYmkzSVJXa2dmUWQ1dDRobmhHNmZ2N0tPMU4vWlhh?=
 =?utf-8?B?ZEY1YzhHaktwc0I3V1pKMFdIenRaSGRqUkVsSVFDMmYreU51aC9hVmhrWnZK?=
 =?utf-8?B?OGtyaDBkbUdLUUdvdTJpd1h6OU9oUExXQzNRNmkreHIwTXliWkJBMllyRXl0?=
 =?utf-8?B?MGp6L3VrME5ORWlScTJwa2tvUHRtTUNRcS9UeE0wSmJhMXgzcEFOeDBva0JZ?=
 =?utf-8?B?Mkw2TU5UaGZuQ2hxNmxDQnc1UVlYR2l5UVdvYUNYUk54ZndhQ21zaUl4N0wv?=
 =?utf-8?B?a2lXTGw5c204WStleUNlUTdqVnN0MjdwSy9HVUpRcTloY2Z5WlU0dW5xR2Vv?=
 =?utf-8?B?N1h0SmYzdmx6bkt6Nzg0WkxpdE40TUJqQzFWVFNkSi93N3pObFZESEo5VmNM?=
 =?utf-8?B?ME96WXRQakIzSHdwcVJsV2VHclYrWm5LdkxteVFIZDBrZENMQ1BPMFc0bi9K?=
 =?utf-8?B?bVhaUENtUmV1dGxlY1B1VE5taU1VSXR0a0lENU9EbW1lOGxoNG9vRzlPOE9i?=
 =?utf-8?B?cHoyWWJ0QkljdCtDZmVYZ2hXK1dISm5GOGp3OVZETUIwTkNzWERJSEtPdStD?=
 =?utf-8?B?VkxqOFpKVm1zRWxjcmZmOUNObnk3eEpJQ2s5Zi9nYjBxaVhCR2xvc2ltcVJq?=
 =?utf-8?B?bzVjUU1ZMkROcTU2T1hlbzlQNVJxWHV4L2w5ZEdXeStXZnBIdHp1alJwOHls?=
 =?utf-8?B?MFdaR25kV1NEaXNMd1RZWXkxQkZFZSt5TUVsNWVuYktNSlVUSDlXYVN0bnNm?=
 =?utf-8?B?VGVxS1FpUEpuZHZ4N3hMa2RIakx2ckpua2pqU1ZqUUMycExyOE5zdkFVbVg3?=
 =?utf-8?B?d1B3dHF4K0ZMbFNGOFBQdzVzMWkxQnBzaHlHNTVOUTN5Zk55ZldkMzhwNlZt?=
 =?utf-8?B?TmJ0cm5wVnNpZGZhREFKMmg4aWloa0pXZEhTcENNMHVmOUp4cFpKQ0NsL1FL?=
 =?utf-8?B?SlhnVjduMHBIL003Qm9oSTFtUUJVQUhSMjYvZ2xuVDJkQVRMbk9EUkhvK0pE?=
 =?utf-8?B?OXlQNS9VZWpCZHlCcDlmZ0hDb2wrMzFHcGlFN1ZlZWY2Q0FPdUJwZThqQXQr?=
 =?utf-8?B?L0pDcHlqQmlPY1VibmtXNzhZSlA5cGxjQlNIaDNNb2E3QUVBeXMwZXJRSjcz?=
 =?utf-8?B?KzkwOXkvREM2VjhKdCtrTEVHemtXc043Szc3SEtNdXFCZmxsRkRBT3ZiMjBN?=
 =?utf-8?B?ZjNFMHR0WDNacFBYWS9Cazg4ckRGNVZMbko0N1ZPZE1RT0NydDRyZzREazM2?=
 =?utf-8?B?aVJPWUIwVnlGeXVFR3lHOVYwQVBvWE1XU1EwMkRXWVdMOVd6YUtNY3J4K0c0?=
 =?utf-8?B?bUc3c3oxelh0eHkrTjM0RVJ0QlVIOWdoQ1l1UTNkalJBNXN0Y1RidmJDNEpn?=
 =?utf-8?B?YmhURGNGVWFxaVJtTGx6SzlYa0pSdGZQVXBZZnhIQ0ZJL0JqcWVCSng2ejh5?=
 =?utf-8?B?dlRBT0VrdTNRYXg0aE9EMlYrR1cyR1RMMVdGY0NueWk0bm04QjBvbzVxYVY3?=
 =?utf-8?B?eEJHbkpGbkc1RXBkaGgzUE5wbDYraEVHS1lkZFpNN0tvUW1nSnc1S1V2M1ky?=
 =?utf-8?B?V1lvVmRGbnFiOHljQm1EaStIemRCVHBiMmxqRzl2a2U1YWU4ejlZNVFuOWRr?=
 =?utf-8?B?SVR0T0VjQytCaGdwRG5JK1dvNHR1aXpVcDYwNTdyYVRwVERCbXV0eERBM3BP?=
 =?utf-8?B?WWhQWURaY0QvKzRibWc1RTcrbnRrR3FVNkNjQjl1eHN1ZlV0bXd2K2FJeWs0?=
 =?utf-8?B?RHk4bWNxNEUyK1pWdTd5cy8rMHk3NXF1RG5TU1Joa0h1MVU4K05uWitXWGw2?=
 =?utf-8?B?WDNPTEs5dmFxS1pncVVHWmJ0aG1wWllIYjdwWWF4MFZsc201UW5HcjNMczUz?=
 =?utf-8?B?UmEyWkxBV1ZJYXo0VE1OL3ZpdUkwOTcwUHNCbk9YT2Yyd0NWMmgreGZtKzhO?=
 =?utf-8?B?M2ZPaUhIRjBPMlVkaHZ1Z3lOUkM3cHYvd0RiU25mRTlkL25KSDJuMGtyZWhx?=
 =?utf-8?B?Tms1cGpKZ0lqV212MmNieGREQzNYY3d6VlVvcGw4OG83WE8xNkxNQ043QjVs?=
 =?utf-8?B?WlEwcSttcFZrWEhVN1RYMml1UDV1MVNmUWtFNEZDaE94SmtOSm9WeUUxamlX?=
 =?utf-8?B?bVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c3804d5b-993e-45d7-f509-08db295aa456
X-MS-Exchange-CrossTenant-AuthSource: CY4PR11MB1862.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2023 15:49:08.6514
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wJESTCzSRqjVFbJajiiZjb/J5r+Dho2a928IDO8/fi4GSfgMyu/E7iO60nYzO4nd95aDTAuR1UmRbYonQ6mPRaTFG/udVXwB7CIO2FY4pwc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4574
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

Hi Alex,

On 3/17/2023 4:01 PM, Alex Williamson wrote:
> On Fri, 17 Mar 2023 15:21:09 -0700
> Reinette Chatre <reinette.chatre@intel.com> wrote:
> 
>> Hi Alex,
>>
>> On 3/17/2023 2:05 PM, Alex Williamson wrote:
>>> On Wed, 15 Mar 2023 13:59:28 -0700
>>> Reinette Chatre <reinette.chatre@intel.com> wrote:
>>>   
>>>> Dynamic MSI-X is supported. Clear VFIO_IRQ_INFO_NORESIZE
>>>> to provide guidance to user space.
>>>>
>>>> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
>>>> ---
>>>>  drivers/vfio/pci/vfio_pci_core.c | 2 +-
>>>>  include/uapi/linux/vfio.h        | 3 +++
>>>>  2 files changed, 4 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
>>>> index ae0e161c7fc9..1d071ee212a7 100644
>>>> --- a/drivers/vfio/pci/vfio_pci_core.c
>>>> +++ b/drivers/vfio/pci/vfio_pci_core.c
>>>> @@ -1111,7 +1111,7 @@ static int vfio_pci_ioctl_get_irq_info(struct vfio_pci_core_device *vdev,
>>>>  	if (info.index == VFIO_PCI_INTX_IRQ_INDEX)
>>>>  		info.flags |=
>>>>  			(VFIO_IRQ_INFO_MASKABLE | VFIO_IRQ_INFO_AUTOMASKED);
>>>> -	else
>>>> +	else if (info.index != VFIO_PCI_MSIX_IRQ_INDEX)
>>>>  		info.flags |= VFIO_IRQ_INFO_NORESIZE;
>>>>    
>>>
>>> I think we need to check pci_msix_can_alloc_dyn(), right?  Thanks,  
>>
>> Can pci_msix_can_alloc_dyn() ever return false?
>>
>> I cannot see how pci_msix_can_alloc_dyn() can return false when
>> considering the VFIO PCI MSI-X flow:
>>
>> vfio_msi_enable(..., ..., msix == true) 
>>   pci_alloc_irq_vectors(..., ..., ..., flag == PCI_IRQ_MSIX) 
>>     pci_alloc_irq_vectors_affinity() 
>>       __pci_enable_msix_range() 
>>         pci_setup_msix_device_domain() 
>>           pci_create_device_domain(..., &pci_msix_template, ...)
>>
>> The template used above, pci_msix_template, has MSI_FLAG_PCI_MSIX_ALLOC_DYN
>> hardcoded. This is the flag that pci_msix_can_alloc_dyn() tests for.
>>
>> If indeed pci_msix_can_alloc_dyn() can return false in the VFIO PCI MSI-X
>> usage then this series needs to be reworked to continue supporting
>> existing allocation mechanism as well as dynamic MSI-X allocation. Which
>> allocation mechanism to use would be depend on pci_msix_can_alloc_dyn().
>>
>> Alternatively, if you agree that VFIO PCI MSI-X can expect
>> pci_msix_can_alloc_dyn() to always return true then I should perhaps
>> add a test in vfio_msi_enable() that confirms this is the case. This would
>> cause vfio_msi_enable() to fail if dynamic MSI-X is not possible, perhaps even
>> complain loudly with a WARN.
> 
> pci_setup_msix_device_domain() says it returns true if:
> 
>  *  True when:
>  *      - The device does not have a MSI parent irq domain associated,
>  *        which keeps the legacy architecture specific and the global
>  *        PCI/MSI domain models working
>  *      - The MSI-X domain exists already
>  *      - The MSI-X domain was successfully allocated
> 
> That first one seems concerning, dynamic allocation only works on irq
> domain configurations.  What does that exclude and do we care about any
> of them for vfio-pci?  Minimally this suggests a dependency on
> IRQ_DOMAIN, which we don't currently have, but I'm not sure if
> supporting irq domains is the same as having irq domains.  Thanks,

Just to confirm, as I mentioned in [1] I do plan to rework this solution
to support both allocation mechanisms, using pci_msix_can_alloc_dyn()
to pick which one to use. Thank you very much for pointing out this
gap to me.

Reinette

[1] https://lore.kernel.org/lkml/e2d3f5a6-0a36-f19d-8f19-748197c3308d@intel.com/


