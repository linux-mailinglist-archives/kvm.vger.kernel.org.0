Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B0D176B314
	for <lists+kvm@lfdr.de>; Tue,  1 Aug 2023 13:23:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232201AbjHALX1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Aug 2023 07:23:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234488AbjHALXH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Aug 2023 07:23:07 -0400
Received: from mgamail.intel.com (unknown [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09F173AA7;
        Tue,  1 Aug 2023 04:22:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690888921; x=1722424921;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/aOA19j6ADhXiAn/d2pC5BdxKtY++u5yYxjZ4NcHB6I=;
  b=PGrboojE6ieppdFV3jSpcs9b7knH7cLeTJ5+Djfp6qWJZKvlpe+m5eoJ
   RaS42OMZGUgC6jSIy/iZ/NZivA7x7vPoSgL34/umYWgDqalBRTA7MJUlH
   yG41DkcbwFKTE4fTl634/Wkgmri6q7xjJX+plZBekyKsfg3aRJCG+/NV7
   6cNCKk61wzD8IkorncRmb25y2vJ32JVj7d5SAueokBRMEcp9Du7RgPTkB
   jOI94gsCVb7cI1fSsKu0mNbJFyU4lVfiWnlKRNIJNN8VPgGd//9DzVZg3
   Me2QlpIP8MU9ugcCIiMUTUG7GIwOWoV6XVZpKywNPERYEax3Cbqj4gkwF
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10788"; a="400222029"
X-IronPort-AV: E=Sophos;i="6.01,246,1684825200"; 
   d="scan'208";a="400222029"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2023 04:21:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10788"; a="722452473"
X-IronPort-AV: E=Sophos;i="6.01,246,1684825200"; 
   d="scan'208";a="722452473"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga007.jf.intel.com with ESMTP; 01 Aug 2023 04:21:59 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 1 Aug 2023 04:21:59 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Tue, 1 Aug 2023 04:21:59 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.173)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Tue, 1 Aug 2023 04:21:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rbwlu+RBCrTU1qczX29cLymtqaZ1t0NYN5/3X6+e8keAVDH0sTDJb5jMPOu/h/A6WL4r3odvKmAmtDMQvhz+7lV3ocRdU9tiSL523/wBzvkMGUO7BmWkvL+OAiDN7y2TeHEFrYgV00/ADiWBKXrT8VlJlEf29xDR/kb0iE26edgPSbrI4vFjJjyZ64yOOjxnUccccIW9K/zVU+U49MoXWPoekF27Jhnff+xm5l+/jhFpOidG15L0FAfaJhFV+ghMdMW8TrEeoREtcaW47lGremRSxT6vnVBg0Q+xytZrGDOCxzBBYe9mXSOuhcn+uA9wLE2FCFLvQfqQ5bpWPJr2lA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pAa+kO9kVC1J2xXTb5ZjQmrydqwFZyg5Ma9HXYiVI2Y=;
 b=Bi3iDTVTazrMqe5l/p7hf9Sp/Jz/GbFLxlepEQ077iqjzedKJ+qgCzcNLIm4fMg9ooneAYMoI9HBSQJaYuh787g7FtzCoCUmr/3RXnd39tJbKE3dUxUJYzbClC2PlYNvQiKMYuCmWNoXxmEmyYKzJGPx32f8+wE/ubLM/5fmAhQC3rGXbPw/koDvOVhxeB82kYOcoXEuDsqsVDBUn3Y8Pf9QzzwtVbHXybw5TbAmOu9g/Zuj1MwOv9t4kd9lDuTvc1ZSAJFqaY4OuGURNP3ilX42ALSfizIz31ukUjmHK8FE21TUk/wY2rQw3rY6F2GRBuB/cNRcKfzuOnKB3T703w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB5549.namprd11.prod.outlook.com (2603:10b6:5:388::7) by
 CH0PR11MB5521.namprd11.prod.outlook.com (2603:10b6:610:d4::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6631.44; Tue, 1 Aug 2023 11:21:51 +0000
Received: from DM4PR11MB5549.namprd11.prod.outlook.com
 ([fe80::fa3f:a88:b8dd:5c8e]) by DM4PR11MB5549.namprd11.prod.outlook.com
 ([fe80::fa3f:a88:b8dd:5c8e%2]) with mapi id 15.20.6631.043; Tue, 1 Aug 2023
 11:21:51 +0000
Message-ID: <bb531888-5902-2d27-f535-0248d4db71fe@intel.com>
Date:   Tue, 1 Aug 2023 14:21:45 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v4 01/29] drm/i915/gvt: Verify pfn is "valid" before
 dereferencing "struct page"
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>
CC:     <kvm@vger.kernel.org>, <intel-gvt-dev@lists.freedesktop.org>,
        <intel-gfx@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
        Yan Zhao <yan.y.zhao@intel.com>,
        Yongwei Ma <yongwei.ma@intel.com>,
        Ben Gardon <bgardon@google.com>
References: <20230729013535.1070024-1-seanjc@google.com>
 <20230729013535.1070024-2-seanjc@google.com>
From:   "Wang, Zhi A" <zhi.a.wang@intel.com>
In-Reply-To: <20230729013535.1070024-2-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0160.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:99::9) To DM4PR11MB5549.namprd11.prod.outlook.com
 (2603:10b6:5:388::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5549:EE_|CH0PR11MB5521:EE_
X-MS-Office365-Filtering-Correlation-Id: 1027a527-2d22-4be0-35fb-08db928180a8
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dlRRPmp2cH+Lv0IXlUomHbU6EvwNiKJaj43+S8N01/aKmPk4qKhIXBbTa/7a/2/q76jkzgeddWPFVL2Fdr1ELesybor2bFb+5jC4EQYOP7A9PUBkab02LwtDHF8c3jTh16WujtzJtDAymn3p/nxPgRPgciHwE/nGRX8lZuvfmXvlLruN6RFp8DL54tXwvpFqPhyLA+TQlxBnkDInKg6Drjq84puar7xOBFu1V7SI/SX97RhUGHH1MWE9C4gMf2rVgY255FvMDkNsKVlrx39luvZ9RFfqdPbX8RxfOjVJYftVBdwrxpgF0RM9bvT7hKlpJm52YCHY3VOX0pVBL0g80CvqOShOQsNLlqWiPRCZh8Q6r8VxYNrelHiiDNh7CTK040b0OgQa5htPcCqxrQ25irrGj7wrXDv+Ng4Ekv+pH0p/S2Ne840BTsHv71IVtiq0HwH8ACLCQRpAbJPhqZBw+64OrBZSAOGZ0+yjdynQpF3Ral9+APufS+Fu4F9fN/70feAG3UnWEwa9noKkNpGejDe7DRGuP0auQxgoEynlscINBdkz3HJh83mx8sTPeGV4CIbVEDafsET9ktkvpjz98+IqkY2mK22S4JaE1sTqrAvftnvk+oGVHE8wc4xA5ItoLNsqseiXqDyfZosu3CYR1Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5549.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(366004)(136003)(346002)(39860400002)(396003)(451199021)(38100700002)(6506007)(5660300002)(53546011)(4326008)(66946007)(66556008)(66476007)(110136005)(82960400001)(54906003)(6512007)(478600001)(2906002)(2616005)(8936002)(8676002)(6486002)(41300700001)(31686004)(36756003)(31696002)(186003)(316002)(86362001)(6666004)(26005)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SzE1ZjJ1SDM4QVU0VldqcGdpRGFZK3FySGYwVjZxTXFSdDhmbmNpSWdNbzcv?=
 =?utf-8?B?RzhVbmdCMXNiSGlwTnl6Z09xZjlkMmMwY2Y0V1FXOVN5TTl2WXYreVMvZXkx?=
 =?utf-8?B?Y2N3NURvZ053SUxydzFTZHlidWFJVlNtbzgzcHFXdkZKSXdKTnhRL1IyR1NG?=
 =?utf-8?B?ZHFnWUlUcUlYaFRDZm5DSGZaUWxWcStTK3p3RWErc3hIM2VNaURISWFsaE15?=
 =?utf-8?B?TkRyUnlOMy9VRE5qRCtsTHRkazBrbjRVV1h6RG5heGRGRHBpRWFhYlE3TjdJ?=
 =?utf-8?B?SlQwOFhjS0w5UjNnUlhkczlnZ3FxUXlGbzhuQkwwVTdwUklXR3pweUZiR1VC?=
 =?utf-8?B?eVpSOWF6VjNkRWhQVWh2YU8vR1VWSlp0QVVYK01MZ1N6bml3WUlLZFdmRm40?=
 =?utf-8?B?ZVgvc2kyMnpYVTZ6TWFHdDEzM0ZaRHlNbzNtbnN4b3E4RTl3SVROUWphajU0?=
 =?utf-8?B?Y01CdmtKZEVrN2VQLzNZODNuZzVOWERxSHVNUGJUcHdpazE5SGF4K2RNdE1o?=
 =?utf-8?B?NEQzN05pSlFFbkZqeWo0SFRDSFNKMFlkOURKUHdBV0Npb0dCVm9DQTc1ODhM?=
 =?utf-8?B?b1luTDNCMnFRTWN2amhobVJwSFZxaGczM3ZaMHYyZ2M4Z1RlWUNIQlBIN3F2?=
 =?utf-8?B?NktvbjZ6T05VWlE4WCtta3hHVkN5Y25zV1FzdUhjMmcra2haMUVIS2owY3Iw?=
 =?utf-8?B?amNacEE1akZCbG5ZNEd2TVRsbzU0NTRmYXlwWi9VcndnallobmJsK3h4a3gx?=
 =?utf-8?B?QU5lQWJSK2xibnpxZzJDTitJVWQxUUtiNVJKems3dDlUY0paNnc3Sk5ZT1FW?=
 =?utf-8?B?OCthMG1pSmo1RUlvUVh4NUpNOStuUEUzU0dSdE1ZaVN1NkkzZ2psblo4bjlE?=
 =?utf-8?B?YmJJaWRDYmRXWVNqZHZ4elJoZ3EyNjZJTm9oQ0dEL3BkQU43a2tiZDRHZjUz?=
 =?utf-8?B?b2lrQmxnQ2ZrVnlwTWF1YnFBQ1VzT2l0NVhQaGQxUEVrVWo1NHdha0NidExi?=
 =?utf-8?B?VCtGR3B4eWx6L3JyRzNoUHZzczg1dWpVRk54VXpRRThVdTNGZS9rOXFHNkN0?=
 =?utf-8?B?cm8xbnFqWUNvL3VVb2MyMVlyRzRRcmlpNWwvS0pKNFVtWmNIM0U0OHNsbGlL?=
 =?utf-8?B?UFkzVTdYaEZUczY3dVhyS3p4d0IxTFBqVXdVZnFUTFd0RWZ6M1dzWis2NDU2?=
 =?utf-8?B?UVlvbVcrbzRITlhTdER4Y2x3NStjYklRUnhyK21BT1hmdzFWak9RcEZGYjNk?=
 =?utf-8?B?aHcwTytWTHhDM1dEUVAwdEpyR1BJMWVLdjdHTHZ5THk3c2ErUnpjdmtTcnZU?=
 =?utf-8?B?TWNnd2p6QnBBeWJhS3BocmZ1cVVJTGRGUU5XWnpESlVHWXdkV05ZTDZYZ2to?=
 =?utf-8?B?Q2VDZ3g2SGE1ZDFSa1FNYWh1enpFQlEvMzBERDI3Wmo3aVdjSVBMZUpHdUZs?=
 =?utf-8?B?cFExbE8yZm9IRk5IWVYwUFVEQjhQdjdWRUlaeU5DNWpWeDVKUklYVWR3THZJ?=
 =?utf-8?B?UUFudzdSQzdmVVlhMVBtNFFOcit2TzBZSi8rK05pNDZJRkNTaW9icmVlTkI4?=
 =?utf-8?B?OFJGYjhpL3BkU0QwTHduZ1l0UUlydlFwS2Q5UjBYSVh4SFExb3ovcUkxMTZW?=
 =?utf-8?B?aTdHcmUzbTg4dGdybTYreUZRckcxRDFJaEpMTG5KQURHN2NyWEdDek1ucjQw?=
 =?utf-8?B?K2VrMVZ5aE1jb1l0WGZyR3VyM0lDbHpkZ2FuSUc4emFPWXhiVmYyUEtuQ24v?=
 =?utf-8?B?OWk5YmR3aG1FR01wZHplRGhUOGMzQ1E3bjBGeXlWelc3N2tybmF5ZStTMlYz?=
 =?utf-8?B?STBGVDMzYzA3Zk5WSUVlakJLdzVoODNsc1lvdWVSbFQveVlWa0JvWEt1WHZk?=
 =?utf-8?B?a1JXL2hsN01hSjlYSDBuNVRuakp0SnZMME9yWGxRVExCNStuY3hYdThZQXFU?=
 =?utf-8?B?S29ISXJtOVZ5cFg1Q0VpTGpBS0E4OGNZdDVSOFQxLzdjeGZyWStLSXpIZVBk?=
 =?utf-8?B?U3hFZUVMUFJGK1ZTTUo1SjNhcGZBdkpiaXY4R1lxbGk2eWpuN2lzN04vN1lF?=
 =?utf-8?B?V05BN2E5alNxQktKd2FDL1BaUEM0T0h1QkNRWTl6cEtpZDMrWjkvTGMxdVVG?=
 =?utf-8?Q?CE3Ytr5BSpSQ4BBrmj377QS0q?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1027a527-2d22-4be0-35fb-08db928180a8
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5549.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Aug 2023 11:21:51.2263
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EIIaCj8UbjFOKHsQtWmgj1GYkBNLwm4cV4JmBvaZmr0Mv4r2/zMtuBDjv25WEVn6EWOmneUxZD/6YJG94Wv85w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5521
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/29/2023 4:35 AM, Sean Christopherson wrote:
> Check that the pfn found by gfn_to_pfn() is actually backed by "struct
> page" memory prior to retrieving and dereferencing the page.  KVM
> supports backing guest memory with VM_PFNMAP, VM_IO, etc., and so
> there is no guarantee the pfn returned by gfn_to_pfn() has an associated
> "struct page".
>
> Fixes: b901b252b6cf ("drm/i915/gvt: Add 2M huge gtt support")
> Reviewed-by: Yan Zhao <yan.y.zhao@intel.com>
> Tested-by: Yongwei Ma <yongwei.ma@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   drivers/gpu/drm/i915/gvt/gtt.c | 4 ++++
>   1 file changed, 4 insertions(+)
>
> diff --git a/drivers/gpu/drm/i915/gvt/gtt.c b/drivers/gpu/drm/i915/gvt/gtt.c
> index 4ec85308379a..58b9b316ae46 100644
> --- a/drivers/gpu/drm/i915/gvt/gtt.c
> +++ b/drivers/gpu/drm/i915/gvt/gtt.c
> @@ -1183,6 +1183,10 @@ static int is_2MB_gtt_possible(struct intel_vgpu *vgpu,
>   	pfn = gfn_to_pfn(vgpu->vfio_device.kvm, ops->get_pfn(entry));
>   	if (is_error_noslot_pfn(pfn))
>   		return -EINVAL;
> +
> +	if (!pfn_valid(pfn))
> +		return -EINVAL;
> +
>   	return PageTransHuge(pfn_to_page(pfn));
>   }
>   

Reviewed-by: Zhi Wang <zhi.a.wang@intel.com>

