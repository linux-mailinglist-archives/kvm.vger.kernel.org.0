Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE5C759EFBF
	for <lists+kvm@lfdr.de>; Wed, 24 Aug 2022 01:35:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231879AbiHWXef (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Aug 2022 19:34:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiHWXee (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Aug 2022 19:34:34 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1C4586FCC;
        Tue, 23 Aug 2022 16:34:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661297672; x=1692833672;
  h=message-id:date:subject:from:to:cc:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=A6RlBWI3QL2bgqY7iPnzIOvcSVoeFzGJQMiBb6OYDlY=;
  b=jcYH8auHV6lH9/hhU+Dm7mbkKdkQVxIGl5eMrGWSg/HM/5CnCKcfSVIw
   /XKLBQDoJWk9V0uRzR/6utaOFF31zwR6N3F4VV6U901YRe3R2oiwPZzXP
   bqqYWsyIqtj4wPEU1hOL/AIbXR7ySwSKHbGD1RSTh246T389CyBWggnkQ
   9YORrDnK+owHcwWxhthH/OjqtFny2wT1ibhlxdvfeFKNGe4QCXPrDlsYi
   rZh+i3VoIGMCP2RtsWbK3W69Yrxr4Rgqvz0rgSqXd9zzYeznb+m/0hqBE
   eb9t+gqmN/hBH13Kd3YBrckjfODwaqDpVWTn5S1l0dzmS0k4TN1fJGcIj
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10448"; a="355549018"
X-IronPort-AV: E=Sophos;i="5.93,259,1654585200"; 
   d="scan'208";a="355549018"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2022 16:34:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,259,1654585200"; 
   d="scan'208";a="638865400"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga008.jf.intel.com with ESMTP; 23 Aug 2022 16:34:32 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 23 Aug 2022 16:34:31 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 23 Aug 2022 16:34:31 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.172)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 23 Aug 2022 16:34:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KXIRUKJEyd0fiKKFdif6O2AzKVujScH49YtcjGApEyc6BLueeGQF1PVdmg1B1nMQxSxZuFzvSJrTxtnG+Ll3w2Ms5mDxgsgr2RdkAUqNLEZO3FWAM6X2oIlGV0SNAchuSNpQ87GkpMkqbxQiXm4T1Pbexknp+RjzssXR3UaqwmcA81ISEmuCbuZpbzKI9tHwymZYJqgqwLHeb/kNGFT/cwsHqUVs6bBonQpBBS/pPET2+YZdTFW4xa2lxFwzrnjf59KYPKhJgF6VhDmVx9U9ugGvZrQo9apj7fyr6sT55rapo9CjbrTQm3UzIZtfuDcdp9WVYfkdaB+1/x03IgZ/NA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tBjuwSrviNVshOpOUn7YsQmauvdAegQt3yGpuRd7vmQ=;
 b=OW2OqSFs+RB0J3lE2VmEiHKS2YUrdKA0YaqXeUMiCQj9F8ZRcsVSb127OJTCPvAhBoFOi9j43VLiap6lXRsx+D4q41TqnlI1gT2ybCr3sbDYkWZz3w5YYPWKTEIBcAjer00+ol/aUaCDMJmNToIhrdlRZiT2gKWidpwPn2IdJhCTrGfy10HlHOU+uUoPzo7Pt6j6b3mK6BMieIvhJw5d6c3J5aGmv+cRMRnbfw271Dy3DQqAbyb/ojIYoclMYlYFMlQ5BH8t+gHKwrKMR+hMIeJrjir0e2nG6nXljrfl1jnPVl3s5s/ftgRdk+JgvOUdcd0AhCws9VdtSUtdvjugjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4855.namprd11.prod.outlook.com (2603:10b6:510:41::12)
 by SJ0PR11MB5038.namprd11.prod.outlook.com (2603:10b6:a03:2d8::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.19; Tue, 23 Aug
 2022 23:34:29 +0000
Received: from PH0PR11MB4855.namprd11.prod.outlook.com
 ([fe80::5d13:99ae:8dfe:1f01]) by PH0PR11MB4855.namprd11.prod.outlook.com
 ([fe80::5d13:99ae:8dfe:1f01%3]) with mapi id 15.20.5566.014; Tue, 23 Aug 2022
 23:34:29 +0000
Message-ID: <86cbe556-3084-95ef-381f-1490da7590cd@intel.com>
Date:   Tue, 23 Aug 2022 16:34:26 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH 2/2] Documentation/x86: Explain guest XSTATE permission
 control
Content-Language: en-CA
From:   "Chang S. Bae" <chang.seok.bae@intel.com>
To:     Dave Hansen <dave.hansen@intel.com>, <len.brown@intel.com>,
        <tony.luck@intel.com>, <rafael.j.wysocki@intel.com>,
        <reinette.chatre@intel.com>, <dan.j.williams@intel.com>
CC:     <corbet@lwn.net>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20220616212210.3182-1-chang.seok.bae@intel.com>
 <20220616212210.3182-3-chang.seok.bae@intel.com>
 <a32831e7-5e01-db1a-ef89-cc5e1479299f@intel.com>
 <ec95b28f-51a1-a9cf-7d72-a3a865797c7d@intel.com>
In-Reply-To: <ec95b28f-51a1-a9cf-7d72-a3a865797c7d@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR03CA0168.namprd03.prod.outlook.com
 (2603:10b6:a03:338::23) To PH0PR11MB4855.namprd11.prod.outlook.com
 (2603:10b6:510:41::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b6a84b14-062a-48c2-9ce9-08da856005e7
X-MS-TrafficTypeDiagnostic: SJ0PR11MB5038:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ivzLv9Bo+GpL1mQhcjOzwM7HDUEZsKFvzKgpFFzQh4DusiryeRLlkC0cQUfpG++hiOV29mhD3AEEW3tF8R+XcKcaJ3lGDQtC7pchmg/U3vIDt7o4BCKTz+PR7AKOzpQWlbXzrOLQ2MGX20YjxblIoblAZBpD5xRL7yYQ7f3X/Iu3tfY+JWTEd1Kshd3C3HauP/Zmw3TfIjOfUqYGyxXg06l4OV3PPI+WDN7QO9RkP2WsIj/ip0EVBJp9bZDzs0Z4tMeNqFegCWZkdoBswLrTr55qxMWJNq24Nc/pIJweNhArOKDyH6kRLabFXByQGUQu9rq55Nqfp6jTik7qqWcHho+RBL6x/o5wNRdWn6xl7yOphO72ZuV5F+3mitl04w0UuCIq+Z98mrr4r6tszYfydV32ei/intJFCVqY56Oon2ildOllH1GGVFzUoqRXIIspi+33JRXx/P2ovMfX7p698txT4Sc0cEkRpkjTC239r1bwIU9fwQDQSlmkDPX45Exe/9ibyAcO7xrGepfFPh4aISaOFAzrvd0q/aEIvXqF2lR/KrX1zFy5GSszQCh85N8fIQfj7AdAifaTsUgSPxUYwWqSowbxE+zhn8gm9BNQYS5/gaihAd14Qh4uZYpOspGw4c4ur6rUC6NnetutDTUe38wv3Q+gAnU2nyDW6pq+VXEW6JW/pWAqTQEm3waKs2sovNMgKjKfr1NkX+lHhBbNj+5jXNAP9W/I2+t2ijLpxo58ZieL203JVG4pG9TFQsNLvdC45H1AQu6oRhi8aOgCishySBkDr+DEd6QczXvPvKXhLnAxWoE9NmtzkeSZGAAiXbBy+waIZpKTnYyUN0GcBA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4855.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(39860400002)(376002)(346002)(396003)(366004)(66476007)(4326008)(66556008)(8676002)(6636002)(66946007)(316002)(8936002)(5660300002)(38100700002)(36756003)(31696002)(86362001)(6512007)(478600001)(2906002)(82960400001)(53546011)(6506007)(6666004)(6486002)(966005)(2616005)(186003)(83380400001)(41300700001)(26005)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bUNTQ0EvSzNWZ1pCZURGcDc4TEhYTHlvdEhwbDZNUnJXRHlzWmNHWlhFRUpD?=
 =?utf-8?B?SG9ncHJWSTlVSEZ1M2RKQnlIS3R5U0huSFlDZTFONDFVT2I4ak5xVXV2ZEpv?=
 =?utf-8?B?MkVEVjFEVC8raDRvRWk2VWV4Tys5UkpXTGhFWXlKb1Z0NWpFS25rYTRIcFJy?=
 =?utf-8?B?cDZQOGRSSTBrVExZWEpDY0R3dlFVbjRSWVV4SHltaCt6d25JNE5qVEJsY215?=
 =?utf-8?B?dmFRQ0toUlR4Y29GQzBGTUhiOWN2MjhId1dmN1IvRFlJNGRDR3R3dzFSYXYw?=
 =?utf-8?B?YVY1VXhDdU9tYnJuRStyT2Z1V3NUVUlLZm1SUDJBcFNQNjFodHVOMGQ1TzZz?=
 =?utf-8?B?NDNWY3JWZHV4SFNGK3dBQmFPbnF4dnQyblhtK3FBODFxY21oUTA3eTZ1cHZo?=
 =?utf-8?B?eEJkeWR4NHhZTTlqRzBxY2VqbXhYd0gyUDR6NlN4ek9CYmlIc3REdUM0L1dx?=
 =?utf-8?B?MGNETWw4WCtHRjVCRUE2Umc5Y0g0VDgydCtaRHdVcGNhaS8zM0hLV0hYZ29Y?=
 =?utf-8?B?cDFrRjNmbktkRDFlYXdXbmdKRUQ3YWlWdGIrZlk5WnZoMFRJNmRzMk5Ba0lw?=
 =?utf-8?B?aXBWbVBLM2oxbFBMb0NPTHMxN1RtS3FmdDhxYW5rMXY1T1l2dlJtenFpTmlt?=
 =?utf-8?B?c3JUdHAvZ0duR0V2NjBRc0Qxcm8yU0xLNEtYYW9pRDhOU1hOcVJYZDUwUjhL?=
 =?utf-8?B?RmdLV0hZeGk2OHVwb2ZyNUhYd0IrUmg3QXFzQ0p0Nks3YVVSUFRsTStIakwz?=
 =?utf-8?B?Ulg2bVlCM3kxejhwYWFHT1BtU2pLTWtNYk5HSTRIeTBQRkxyaHAyUm8rU013?=
 =?utf-8?B?UDY3TkwwbGxBWnFVTG9wU3R5YkJZVlZORW0yUGtMcVlFTWRFTXE5T3V2ZFRD?=
 =?utf-8?B?TUhuTHN1WDdRRUdEbEJVY0VaMDAzM3ZMeXBOdC9CQmtKSXc0ODcwd1NHZVgw?=
 =?utf-8?B?ZjFYL2hyS3dQUnN2U1FhYktRR3NaRGx3U0tXcE5hTnhwOXNyaEdwSEhTeXYx?=
 =?utf-8?B?dHc5VWc5UkJtcEFNZC9aMTVzUE81c01kVzRNWlFlazl1SmRaN1FOVlcvL0FT?=
 =?utf-8?B?bnUvcjdEU1RUUW1CY0l5Z0x5cUtYZnN5M1J0SEpQWjQzdEwzdFpMa3VoWXIy?=
 =?utf-8?B?amhKcmdTdHRmTTlIdzdMNUhaQ0l6WjIxbEhJcnVBdUpCdElJbk1Nc3gyNzZ6?=
 =?utf-8?B?VG95c2dKRktiSldEc3NMSUg5Q2QwWWs5QVYwTEtEWWhIVlRDUWQyVEJ0ZWRa?=
 =?utf-8?B?aFo3L3ZqdGFPSm1Ma0lZbXlyVCtSN2hEV0dSbk45VXd3RklGZTBLNXVaZmhU?=
 =?utf-8?B?ZjJmYlZEQTZYdlFQbmg2T0Z5cEt4T3pJNDMvQ2cxa0tpVGdISkFpaDBybDRY?=
 =?utf-8?B?WjlnSW00L0R3ek1nYWxLU2thVmFkOCthUEhhamdIOUl4dy9nUlVzY3gyR093?=
 =?utf-8?B?WUF6T0VFbGRoZWJzUDNRelEzTTVBVjY3TDVUZ3pWSDBrenRpZ3IyRzZ2bnBp?=
 =?utf-8?B?ajgza3llMDd3ZWFBb3JIMDhIS3NJZlN5WEpBbll3QlFyeFdKS0l2U3BQTlBa?=
 =?utf-8?B?MGVFZ1pvK3NjZ3pkUElSNlNLYUdQSVd3dHBCaUJxM0NmM1hiOE8wODhoa0p3?=
 =?utf-8?B?SGRVT2NCc3VSbmoyNk1WM1V2QjNRSCtpUFVBeURtUE1zOFdqV3VwMXpkakhZ?=
 =?utf-8?B?dnhmVFhJSTd5aDdWNk5Eci90M3liNGsrUnhYSzdEUDlGb3VROFU5T3J6MXR6?=
 =?utf-8?B?WnNGTmtTWVpkZVh4M2NjZ0M5T043bDdMallmQzRlRmhXdTAvOEVzeGhqUHFa?=
 =?utf-8?B?SUNGU2FqcWNDbFAveXZDdGh4SG5ablQ3dWlYSkRaS3NEY2VPVFpEMWVkYk56?=
 =?utf-8?B?c01qM2cxK1dlYTA1R2dkcWswTDA0aGFzQllKeHhZWjNsNHh1djNHUlFvMm9j?=
 =?utf-8?B?RzVPdXZ6eENKNStDVS9namU2dE1RbXJnV3RNWlp2eGJ1eks2Z1ZrSDhjZW1u?=
 =?utf-8?B?RCtCN2VVVzBnUytGamtZRm96UWxuT3E2OHZkZ2wxKzJnMUxWNm41dnhoUXMy?=
 =?utf-8?B?b0taWCtkOWhXU2lkZFVydUh2ZjZuY2EySU1aRjM2Y0hLOHZkK2NQaTN3V3hi?=
 =?utf-8?B?d1MzYlpoTUFrcjFPQUl1NzR3YTAvb1h3ekNGQWh5RHBFL0pZcWhvbGhJaWVT?=
 =?utf-8?B?N1E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b6a84b14-062a-48c2-9ce9-08da856005e7
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4855.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2022 23:34:29.0328
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d9TEJ1VqKxhuvVvytXF8NrbM/uhWACqrcpD2+ZtBgXskjBxvsoIgHZ84ZlPORGQw1YiiDSJIMKhhUh2NcK7rfbd0b4YMLnhG2CDyGrzoPbM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5038
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/23/2022 4:55 PM, Chang S. Bae wrote:
> On 6/16/2022 3:49 PM, Dave Hansen wrote:
>>
>> This touches on the "what", but not the "why".  Could you explain in
>> here both why this is needed and why an app might want to use it?
> 
> [ while studying on this a bit further, found a few things here ]
> 
> They (ARCH_{REQ|GET}_XCOMP_GUEST_PERM) provide a userspace VMM to 
> request & check guest permission.
> 
> In general, KVM looks to have an API as a set of ioctls [1]. A guest VMM 
> uses KVM_GET_DEVICE_ATTR::KVM_X86_XCOMP_GUEST_SUPP to query the 
> available features [2][3]. ARCH_GET_XCOMP_SUPP is not usable here 
> because KVM wants to control those exposed features [4] (via 
> KVM_SUPPORTED_XCR0).
> 
> But oddly this mask does not appear to be actively referenced by those 
> two arch_prctl options. I can see this ioctl attribute is currently 
> disconnected from these arch_prctl options.
> 
> Also I failed to find the documentation about this 
> KVM_X86_XCOMP_GUEST_SUPP interface:
> 
>      $ git grep KVM_X86_XCOMP_GUEST_SUPP ./Documentation/
>      $
> 
> I guess people will be confused with having these two options only. I 
> think documenting this has to come along with these missing pieces (and 
> potential fix). So I'm inclined to drop this one at the moment.

Posted this series as following up this:

https://lore.kernel.org/lkml/20220823231402.7839-1-chang.seok.bae@intel.com/

Thanks,
Chang
