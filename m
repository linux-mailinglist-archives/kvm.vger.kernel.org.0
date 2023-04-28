Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C58876F1DF1
	for <lists+kvm@lfdr.de>; Fri, 28 Apr 2023 20:24:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230085AbjD1SYf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Apr 2023 14:24:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346305AbjD1SYd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Apr 2023 14:24:33 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A331C5261;
        Fri, 28 Apr 2023 11:24:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682706270; x=1714242270;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=uDp+jR8FVrllkobtHuj2ComourDQUylbMt91deWtYP8=;
  b=W9i2zovKGyBCGrAKIHgS03JgJK3VM923gxIGuOiiYCf9UrdtLMMK8vhc
   JpTnaBSEi2i+DnsnsAGHU3x7dILuE60EqtQO8mA2//U0fQV91oNMduIa8
   ehDyhfRIl4htnPfOLUmsKMc+pENQwNsh3pAI3G0U+SmWEXWfrYu/IwfF4
   CHy0Zj8BV+LyC9y6/6kS63S6+Nw6JAgq7NwySYppd+1SMDoQNJXMcHLab
   dW/iW8mq4JnRoX2IoLUK8sIfa+MnjGq0rpsixsLo4fVEbKUxrPMvtr2hg
   CX3cz22j3uNXvFVaix+KJ3KaRiC/PFqHoBgMuWYIbQuzkBxczh4UZ93uu
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10694"; a="413219222"
X-IronPort-AV: E=Sophos;i="5.99,235,1677571200"; 
   d="scan'208";a="413219222"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2023 11:24:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10694"; a="784322814"
X-IronPort-AV: E=Sophos;i="5.99,235,1677571200"; 
   d="scan'208";a="784322814"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by FMSMGA003.fm.intel.com with ESMTP; 28 Apr 2023 11:24:29 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 28 Apr 2023 11:24:29 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 28 Apr 2023 11:24:29 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.46) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 28 Apr 2023 11:24:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZRJHAHgG7DQaUmD3YBkZjXxs/meTEV91YD1Zzoc72lnPOxNOE9LBJS+PSCfWpEpIXsmgVSOBs+fBWxnRoFpOLy8icEPeQdtbNSD9N2hojFDx7vMqRifINgQJU0/yPzjGzOlMVwd69oSrDnFZGA8I1Lmysc9ZHSFhKX4akO7J2VG4B93RprklsdoI9kLZXMk1UIVXXENXPG/V463YEld/0b7B5gqv2+h3sHn5JpTwof26EKKF6fWJ/6OjMamGH+oQSwsfvXfAvSa6dDy2tkBaQ5WHXCTB/KzZ6ozVRa0ossqWK10+USrl2wiV7la3eS8Mf+OaJmFSyr5xJXfq0knQhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iilq39XWMB8BMHLMyzOoDDhxvvRFFmCCOLDJpdlbkjs=;
 b=NpRG7eMBw47Ix/NSMDH+wjXCOkTdmJ9EXGNJ1sq7Uf0ClS6r287eFTnxUmm9aXYPmbCqDcfQmTlKAGkcOOBTuSv8wWVAtiEJsvmXd9tLFM1245YWfsTU8B2PLjeSdbQwCcQwbSv+Zc3HreCejemBnqD3jN4PSY0kfBJW9YDPG7O0ZUK1ow1M3tY/rf4YmS+GMSUL2pEeRBI5VtggYEN6AyytGn6rnVlfUVg7lU9l03hHZ48Zhyzd22oLQk6IhuDad1l66rTvDpRgK+Cd0a4mCpg5qnVC44/0xKtqeyYBF929GxoDLZrfcZLbQRmyTX4T1LEy4PAUkN1sGtIyz4bsqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by DM4PR11MB7400.namprd11.prod.outlook.com (2603:10b6:8:100::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.21; Fri, 28 Apr
 2023 18:24:27 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::591f:4873:fd80:9a6d]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::591f:4873:fd80:9a6d%6]) with mapi id 15.20.6340.022; Fri, 28 Apr 2023
 18:24:27 +0000
Message-ID: <e15594ad-5078-8127-c94d-80e789b1e2cb@intel.com>
Date:   Fri, 28 Apr 2023 11:24:25 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.10.0
Subject: Re: [PATCH V4 07/11] vfio/pci: Update stale comment
Content-Language: en-US
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
 <f16872889aed9a7b042a7e53722b9ae83430a126.1682615447.git.reinette.chatre@intel.com>
 <BN9PR11MB5276651EF3C7A11C2D60BB8D8C6B9@BN9PR11MB5276.namprd11.prod.outlook.com>
From:   Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <BN9PR11MB5276651EF3C7A11C2D60BB8D8C6B9@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0297.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::32) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|DM4PR11MB7400:EE_
X-MS-Office365-Filtering-Correlation-Id: 5072f04b-9d65-45b1-4e57-08db4815ccce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: K/vKFKEagmalkIXMPMjppsUpLbUM5CBONzUMRRdv7uBbIvnBLor816HilkVdAPXq5pmj7lH1f4ILfUCoYkYXEjOiT14BwGdIDNSWPI50AH1nWCuadKqb8ZfDM5N17Edd3p0mZG3qYWZVpuI84IENj/w4c9TItgbDbOTX7sjjuvBSVTj7avvYh2TGo4x1aN+fu3QkCCnv8YPZO7yRk1DDYYszSHgVbNvN4Fz3sFj++nJljZnSE+54YowKmwGdkzTah09DimJsPcAd6f6G0YeuniAF5ETKrMJZEtoFUX0VXnjvUMqDs3dtkADsIufh3J5lsUUC/Vq2VBLCTma0Oe0McMDy494y2YyARahNm/70JXYPWpH6JaADCH1WQNIt/y9fbRhHhBPNKJ2CqVwdoEN+laNWHRT+fzrDhouigv46HKNdhtfRy4D9DPbG8UlZzOmDC6SvBxMzv+jopY7UAKZNg7BHSLmFaG7COlzEQ/kOLnS/dxHg2RlV7ggfd+BQgGS2Q+ssz5+vAMbbOiHnQlRAJySHm3wFcg+EEiPMMdPHpTWGHUUFgtIlQ9tYrbX/V4LMNJLkLYV9mmRP7f9pLd/sF4shhHys5AqDWiCVycGuRA089Ipd9fUOZ6hV+29OOfTeNnJ+tThtJnIqYCkoGIb/7w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(366004)(39860400002)(396003)(376002)(136003)(451199021)(15650500001)(41300700001)(2616005)(26005)(6506007)(53546011)(6512007)(5660300002)(82960400001)(8936002)(31686004)(83380400001)(44832011)(38100700002)(2906002)(4326008)(316002)(66556008)(66476007)(66946007)(54906003)(478600001)(86362001)(8676002)(36756003)(31696002)(186003)(110136005)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OE1waGpGU2dQMk9iUW5SRU1oVVJsZmJMWWdFbFNvcnROZnJ3UjZMU3o2b28w?=
 =?utf-8?B?bnVwc1BqNWZxQmtWSkR2bXNNYjV6T0hIR3ZVdExSOE9iYmc5MWIyZUZXZ1R6?=
 =?utf-8?B?K3FNS3lrWTRyRVZEQzdJdTZ2bEVnRGZJUks1TkljRWREYnhUUEp1OWF2dHA1?=
 =?utf-8?B?ZDF1aVFQZHR0WGdKclltSmdwd0kyZzZIMkx3Vnl1RjZNVERtcFI3a2tDOEtw?=
 =?utf-8?B?d21INjNacFREN0NmbWx4VUROQ2J0MUx4Q0lZdS9LVGQvTlBLbVQzSWg1d3Rt?=
 =?utf-8?B?dk15Z0hDeUQ1VFZwdXVCVTZ2alMyako3VlRtOTRpMU5lWjdhQndTekwrRE1N?=
 =?utf-8?B?dFQ3cGNTOWRzNGRYTkt1TE92aDhORkN6eHVCaURMdHZ4VTRqN2dMODM1SkNo?=
 =?utf-8?B?VnJEV3dGMnVqQVd5NzdFUlpMMHJuYXVyRkNQZFRnblNoQXF6TTQ5L0syWStU?=
 =?utf-8?B?RUlPb1pCck4wTmc4eFE5ZEVRSWZJU0xsL2I0em1YNWxYTUl3eVN2c0VEWDBy?=
 =?utf-8?B?Y1l6Z000cnZwNXk3STlCZ3dEbDFxR09YZTIwOVdlWVZFRkN6eGYwR29Id0xE?=
 =?utf-8?B?S0NnS3U2bXFxRGxzcVNaNG0zem56MXVlaDB3bXN0RkgyV3dRd1hvcGxwWGFJ?=
 =?utf-8?B?MXA3Y0xMQ1E4SzRqak85MzVva3ZXa2ZSdTg3bW1sVFY5Ui9adVk4VUQ4ckZo?=
 =?utf-8?B?YVBSa04yL2hGd1lxQWZpcUtnSlJUOHMrUUl1KzV5am42a014WjRRd21POE0z?=
 =?utf-8?B?K3ZoUlVlMDJWT3crQ1I4bHhDejNlbW5SRThzQzgzZlBWaXZ0YnV1MnVZdVp3?=
 =?utf-8?B?elZaSUhsZFh0MksvR3dIRHRqS1NBQUQvV2t3NTRsU3BIWWY0YVN3ZmlneEg4?=
 =?utf-8?B?eEFlczQzeWIzT01JVVErZVB6eWloUUVQdWRUc3lOMW8wdkExODdVbk9RNlk1?=
 =?utf-8?B?b2hjZjFCU2pDSUM3dkNoZ0hjTnN5dmphNVo3dDZ2Z056UHYvR25PZkd3MFF3?=
 =?utf-8?B?UjdDdllYTDVoUWlkZDVnT0U4cUJOOWRQWDZHcW9GZnB4RlJ1TFhKVHFnNG9N?=
 =?utf-8?B?VFJvb01KWTluV1dIS0NJMnVaK3hRQS9zbUpiWjNhd3lZN1BqVWhpTDU0bVpn?=
 =?utf-8?B?T21Lclc4UnYzb2RzNHBvRXZHSFREVGtlcVBvZyt2cmk0eWE2MlJZMUVyb0Mr?=
 =?utf-8?B?amlwWVAwQmkzSk4rc2QrbFdXZGtUVXhlZzVmdXJJaEo0WnUvUmR4czlqTFJ1?=
 =?utf-8?B?NGJwRkZid2czYXRWb0MyK3EyU1UyTXExb1B1SHNBMmpzTTRZWHJ0V3B2UGM2?=
 =?utf-8?B?c0tSWC9CWVhWbVZWb3Q5MHJqdEZHaWI0WXNGcVhkL0xxWW8ybmZrekVONmVI?=
 =?utf-8?B?NGNUK01xa2Z1MnRpRU1DMFhFTjN3NnhwSmNDOTNmeXFab0w0VEhQeXYxbmgv?=
 =?utf-8?B?ZWJmVFNFUkRlTzR4T3NSYjJmT016RFR2UzBlYmlFUHMrYURRZWVEbmNiZlZq?=
 =?utf-8?B?emNQWGxyUlljckdBUFY1MFhaOTcxclB2amFpNHBCMUVQYUVZZ25hSk5ETGIz?=
 =?utf-8?B?eEJ4enJaS3lmbURPVFRMM0FjRzY5STM0NFpWYVZCYzhieUE1Nm5IVC80emQ3?=
 =?utf-8?B?UDAzYmJTdUc4Zmx1NW13aFBEQk1qYXQ2Umo4djl2ZFpaYjNUcU0rQjBKN1pr?=
 =?utf-8?B?cmhnZ1BjdnBuWUpEK1lXUTRxTGhvSVM3bncwSnBrZjZVa3FkaHZ3NnpzejZU?=
 =?utf-8?B?aWoxL05pbU0yWHdIZkJRNUY3ZWhUbXluekZCSXhHL0tqU1grTjcxbE1nUWQx?=
 =?utf-8?B?NXlLWUpXZ2tCakdaSDhmNjhwc1UxN2ZQMStYTEJNQml1WDdURm1Pd2ZWcDdZ?=
 =?utf-8?B?SWpsdU1xaTNRSUJ0QlBZdkpUMWZGNmF6c29GQmhyOTVaZytCbHBWM0Q4aTFJ?=
 =?utf-8?B?aXZZUnlEdVY1c1VMcW9IbTg3Y2xXOWlKMVRHQ3hHL1l0WEROTkpNY3VUcjN6?=
 =?utf-8?B?THdaU3lPcFZ6bEVjZTRZMVM5Z05VV0JCZ21wc1ZRbmZidTAxeU8wTjJ1emlJ?=
 =?utf-8?B?K2xYc0JrdGt1aVVqOHkyTzl2ZU5Cd2JrNjV5S1ViSnBBOVlwZW5IWE9sWDRZ?=
 =?utf-8?B?bVhHWmJmNFZzWkZnS2p2bUhFdHFDcHRNTmRjM0FtdEUrWjcxQmY4TmhBVjVs?=
 =?utf-8?B?dkE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5072f04b-9d65-45b1-4e57-08db4815ccce
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2023 18:24:27.1905
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bvC3wYuVUsGYFFV0rgM3ujnyJ+qj/FR9dJoyP0jUThSgVq9ZG0lwYwgHhu1JN6jdDwiu96vzeej1vRPKGx5YP4PNOIzN6vzLmadawU9zqbU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB7400
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Kevin,

On 4/27/2023 11:42 PM, Tian, Kevin wrote:
>> From: Chatre, Reinette <reinette.chatre@intel.com>
>> Sent: Friday, April 28, 2023 1:36 AM
>>
>> @@ -419,11 +419,9 @@ static int vfio_msi_set_vector_signal(struct
>> vfio_pci_core_device *vdev,
>>  	}
>>
>>  	/*
>> -	 * The MSIx vector table resides in device memory which may be
>> cleared
>> -	 * via backdoor resets. We don't allow direct access to the vector
>> -	 * table so even if a userspace driver attempts to save/restore
>> around
>> -	 * such a reset it would be unsuccessful. To avoid this, restore the
>> -	 * cached value of the message prior to enabling.
>> +	 * If the vector was previously allocated, refresh the on-device
>> +	 * message data before enabling in case it had been cleared or
>> +	 * corrupted since writing.
>>  	 */
>>  	cmd = vfio_pci_memory_lock_and_enable(vdev);
>>  	if (msix) {
> 
> What about keeping backdoor reset as an example, e.g.
> 
> "in case it had been cleared or corrupted (e.g. due to backdoor resets) ..."
> 
> otherwise one may doubt whether it is a more severe problem causing
> the corruption inadvertently w/o userspace driver's awareness and then
> whether just restoring the data is sufficient to move on.

Will do. Thank you very much.

Reinette

