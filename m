Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 379283EF0B1
	for <lists+kvm@lfdr.de>; Tue, 17 Aug 2021 19:16:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231479AbhHQRRH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Aug 2021 13:17:07 -0400
Received: from mga03.intel.com ([134.134.136.65]:27875 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229699AbhHQRRG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Aug 2021 13:17:06 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10079"; a="216183206"
X-IronPort-AV: E=Sophos;i="5.84,329,1620716400"; 
   d="scan'208";a="216183206"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2021 10:16:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,329,1620716400"; 
   d="scan'208";a="462479844"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by orsmga007.jf.intel.com with ESMTP; 17 Aug 2021 10:16:32 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Tue, 17 Aug 2021 10:16:32 -0700
Received: from fmsmsx605.amr.corp.intel.com (10.18.126.85) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Tue, 17 Aug 2021 10:16:31 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Tue, 17 Aug 2021 10:16:31 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.177)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Tue, 17 Aug 2021 10:16:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TzP64F6QM4Tta7m3PsyCCx/Sz3yDAnFvdj9e2U2phYTftFZjFhN+iNsWLMfMvDNjMEtOPsiPp5hi0976dsyOGAWbNeERFcfg65bBFxWlN2ThGTREvIwI1eWbZ8lQOpDs4L7eKNRLUhu/TjoHCiyKav3xqx1RKPdcEEmzQX7UNaoanWJ1WylfZbl2AfyQu6EuuiKMoCT3EVo9EcVEcgiej5EH8RrQqw9dInHhR84gqJy/gzvC4cztzzIbWjh5YvZkuL0/DXpbplxuMQkssfBWuZWLKdrhcloUG6ePCiSkam1ePa8Ktw5t3Xg+ZDmRWAeIKoUbG23k+r0jTbJZknmMkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rUp4dhN74z7LboTvjK29F3goDr6+pP6hri1cNDh8W5o=;
 b=SpEJXpdbVcppmjoWWAtt6K+fbk+eviHnQ8/cVzyRJNLJlkEHCj94nqBk61KD2WlWasaJyf+eoS7P7j7tbzRJKB0QfBkXXYyHiauya2Sa9ylYA1GIjvI4WxKcy6NC8Bx2WxZJMMvuJMj/iy+aHNkoEuTaaAG4a2SdWrvSYp+8j+4b8Hl4i3pFtnW0WQ677lSKKiTfg8zgUPOROWmurKEU0Ox9MDdnhr4tBDusJxeC0FuAs09mopr60djoY9x5JPbmS+WMPAP9GVRHjwKD4JyyqwkgONLG4+Zds1uQo96jkVz8raW49Xn7AnpvSKhhL8SBassi5rNwbjS+9DiHF2Zyfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rUp4dhN74z7LboTvjK29F3goDr6+pP6hri1cNDh8W5o=;
 b=JY0GjN5EoUVZLOnian4j3arfAN8/qdeCUGPQTqc2YHVpQqg5/LRlllXx6NIk5yGyPYByIMfluuQchHd58MPu2ssoTh2k3IyvcbfRSVYWt2y+dNVAz0rzgEMePwsbIG+yWI5YEgMKI3yBdxV2Aoo4UALPp/fH4prdOTW8Es2HbHs=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5156.namprd11.prod.outlook.com (2603:10b6:303:95::9)
 by MW3PR11MB4585.namprd11.prod.outlook.com (2603:10b6:303:52::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14; Tue, 17 Aug
 2021 17:16:31 +0000
Received: from CO1PR11MB5156.namprd11.prod.outlook.com
 ([fe80::c15b:1386:9d0f:1aa7]) by CO1PR11MB5156.namprd11.prod.outlook.com
 ([fe80::c15b:1386:9d0f:1aa7%6]) with mapi id 15.20.4415.024; Tue, 17 Aug 2021
 17:16:31 +0000
Subject: Re: BUG REPORT: vfio_pci driver
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     Cornelia Huck <cohuck@redhat.com>,
        "Adler, Michael" <michael.adler@intel.com>,
        "Whisonant, Tim" <tim.whisonant@intel.com>, <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tom Rix <trix@redhat.com>
References: <ca6977da-5657-51aa-0ef2-fb4a7e8c15dd@intel.com>
 <20210813160907.7b143b51.alex.williamson@redhat.com>
From:   Russ Weight <russell.h.weight@intel.com>
Message-ID: <0d16c181-ab34-8d7e-d9c7-5324a8c24900@intel.com>
Date:   Tue, 17 Aug 2021 10:16:28 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.11.0
In-Reply-To: <20210813160907.7b143b51.alex.williamson@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: MW4PR03CA0179.namprd03.prod.outlook.com
 (2603:10b6:303:8d::34) To CO1PR11MB5156.namprd11.prod.outlook.com
 (2603:10b6:303:95::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.0.2.4] (50.43.42.212) by MW4PR03CA0179.namprd03.prod.outlook.com (2603:10b6:303:8d::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Tue, 17 Aug 2021 17:16:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 929ec83e-9823-4f3b-036f-08d961a2c183
X-MS-TrafficTypeDiagnostic: MW3PR11MB4585:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MW3PR11MB4585E222498AAE964C59E65FC5FE9@MW3PR11MB4585.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OyhSboZNFipHd2Yxf1fZ4v6oXlqUo2DotBGDrwo3WieNXSGeKlMMxI4nak+zhlsYjQxeFUarrK5YknHbkfYFwNkOaHTDheynAFrH9kh5W71vmIVqf/JZjwG4/VgwRtkM08Xdp8DgFgienqU/djshjp5ZU5yauYXV3r8Dj4V3MSF52SkBruX6RNhepUeyP4rrO1HfOiSTg1FQhmymW9xlD4PQUVZuJOxLE8zA4sphGea6MVsirv/1bYKvetfGvUklsD1vQ/UyLiHMq5rYam+CFbSDy+7YomnJLXjJNttaYeTvi12OXCo98zUVS7B4P1X3Av8c+bP5HKx5M0c7kEucGeKONCnVS/emUH/aMPSA46vvqy8DsfMIAszCg3NjhbIA9cT7Sc1LadwJsKihXXauhvu29BIXYrwpprkk1NBxk57IkXEWBkdtWwt041AkNDg7AxhFxZBmcImOe294PelDDX/JvGzaUlnSyezgU0ppZqbxYTP7JR7EPGeh/eOIJtvuApMayDyDh0LGHkSqRIT4FBAHrmNE6U7XmrVClfiwZDn53r+TmZDY6+9RDmRxagJt714BBBXLAdhMc/ePJOnf9+gavtdkUoKz8ZdoXaiEMnub4orFnEWQ+RD3lFA9QA6+nTOAu6+Jn/IEYTe4Sw/wFxmjsBqGNGUD2MXPbjHz2WL6apNfcFkl77Ij+tarJfWB+ePdSwFpiBokpC5zenQ1FvBBRqxFKsCga9oGxC0Lz7YzYXKHggLpBoq9dlF5pAoXatMb1V4KGhZngYfUkVf0pYp022k5DYYk1Qqm0qAEpFbGAb0i0oyzz4T2R2laJbP3em/jGI+koD7wITfMuybFt7NEbrRTnDEsSXGm+oUJlBo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5156.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(31686004)(5660300002)(508600001)(316002)(36756003)(6916009)(2616005)(4326008)(956004)(8936002)(16576012)(966005)(8676002)(83380400001)(66946007)(26005)(66476007)(54906003)(86362001)(31696002)(38100700002)(53546011)(6486002)(2906002)(186003)(66556008)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UTFrU01seXNoTjA1eEtDd2NxeUVqcnI0WXdFaTBqdjBZcGwwV2licE13RUto?=
 =?utf-8?B?VDhrdWtEVGFoeHNSZmRhUDVmVXdHYk5iTEk3WklTUC82UnJLbGN6YWpSakFM?=
 =?utf-8?B?SzZiN0Q2bklQWXdSWU1zcTljeVFZWHZpdGZIY1oxRHRBbVVjZkN5WWpib1RG?=
 =?utf-8?B?MERIdFd5L1hxald1UjhjYTJtdk5YbC9nZU51WWZOSFBUb0hYVFEwcmQ2RkJG?=
 =?utf-8?B?K04rc1NNN3RsM1ZkUzhud1hLcWhkNk04THhubmVzYzEwaXBEeW1MZjlaZ0hS?=
 =?utf-8?B?aGUvdHhwSUhvaWhVOHBZR3REL0RxdXY4UFRnSU5PQzdLUDhoSjdQVEkvSzdN?=
 =?utf-8?B?UktzKzdxVkM4ajYwMkN6SmF1TC9JUDZNMkxHczBNa2dQbVFPZXp0dEpmOVRs?=
 =?utf-8?B?ZTJjSHFyd1dhWWtNVHBNRXJEM3BQaHBMY0pZYkJvenRzWWhubFp2R3ZMV3I4?=
 =?utf-8?B?VFBmVHJxTERMMlE4MEtQN3JHNnpYTEpJYUhzbUVkcElrR2Roa05ObXlubXdP?=
 =?utf-8?B?OHB1NSszRkR4N1o0L293UGVDUHJ3QnNYZHZwbkVuVmJRbVkzcWxVRWwweGd0?=
 =?utf-8?B?amlMNXdIYmR2b0xkcy9KY3lQbS8wMnVSRkxyNW9uZjVqSDVRSzBYTWNmam04?=
 =?utf-8?B?MjFtMm5yRVhvNXc3MkRmOWJwRFJwK3RhLzlkaE1LSFhzTW9YS0tMcGdWWXAy?=
 =?utf-8?B?RW5hUUJKMjE3eThvQzcySFd4NDR6NkFINlpYdEJQQXdxWDRPYnNIVHlvMWw3?=
 =?utf-8?B?L2UzSllZTGFlZWk4ODMyNyswLzRsOC9UZEJvK1preXhCMmt6QS9aeGFtRHBX?=
 =?utf-8?B?S29pSjQ2allzSzVqb2ZGWnd1QkluN2RrSXVWSWpQVWltd2J4L3dVYlNyRXVS?=
 =?utf-8?B?VExGTjVNMnYzaDF2WDFHUVVnRUpuQ0ZCWXdackRDVzNidlJjSG5aVDZFdEtL?=
 =?utf-8?B?Ym92SWNxakNGdHVuT2ZYUFVCbjZYbWVoYzY0Rjh3dUpjSVloUWxhdFZaV3N5?=
 =?utf-8?B?VTBjazZqNjF2TjRxNEZta2M4R2d4aXlINE9PbkZLbG9IQmZHRzRFTWYzTEZj?=
 =?utf-8?B?bWphTVNZdjUxZmVsM0tZdzh0bE0zWERHY3AzQ2lQL3FxT2Eya3lpMjNsYm9h?=
 =?utf-8?B?bU5tSGcyeFBydnR3ZHZld1N6ak45c3k1TGFpcWpYazFIOWVKWTdITmNJZm52?=
 =?utf-8?B?UFFLZDBSbkREWDFKVHQxTS9rdXFmbXBxTVc3b0ZjUkdHdEFYRWYxZGIrb29h?=
 =?utf-8?B?RmorR3Rha29lVDRjZ0p6dUUyejgxb2VUMTVrMDM1K0dvZVluZTJsbkpnWTFl?=
 =?utf-8?B?ZDM0TytPbnJOS2VBc0F2Y1R1YTJEOXdPRkg0QzJ0b3FsRnJYdmdkMC9Md2FO?=
 =?utf-8?B?NWJoNGtZd3pRaVBkWm9FanNQaXc2WFpGaFAxcS8rWXZiT3A5Mnp6c3Bzd0RB?=
 =?utf-8?B?Y1VLTGlMSWwzMEw5WDFtSTdSNjVoRnpYVjEvWDVOS1BsbG8xczJTY1BjYVE2?=
 =?utf-8?B?bXk4SVc3aEtya2o1SkNrcU9UaDhHbVF3b2Q0Tk9lejlvbEdmK3cvM0tROWdu?=
 =?utf-8?B?RU5yMVJ1MUlhT2N2dlRQc3JrU3JiYm0vMGF4MFRYbnYvVnBKSnZ6b2NXbEhi?=
 =?utf-8?B?M0dNVU8xb0xKc3Jub2svdnZhamRsUEM0ekV2WHkyNytNUmhHTmNDVnRtc0lW?=
 =?utf-8?B?NjlDYW1mVHEvdWV0Y2F2TFJ3QVRTZGJyTXNVQTZzOFMyYjhlZGFuTTBKN0gx?=
 =?utf-8?Q?I6C9z4qi3DGkVUX5jrd7rvHxyNeoOyfoq5ykJK+?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 929ec83e-9823-4f3b-036f-08d961a2c183
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5156.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2021 17:16:31.0304
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ixcGNrlMBTf2cq1NK9rH0Pkv14Vp/vLiJXCgM4fh2aPoUzhZj+wOrtsvePYTjaMm5I1bkYD2NVPDc9+LWJ/Wc1Y9HwJoOButFws1PwX8s0Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4585
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/13/21 3:09 PM, Alex Williamson wrote:
> On Fri, 13 Aug 2021 11:34:51 -0700
> Russ Weight <russell.h.weight@intel.com> wrote:
>
>> Bug Description:
>>
>> A bug in the vfio_pci driver was reported in junction with work on FPGA
> This looks like the documented behavior of an IRQ index reporting the
> VFIO_IRQ_INFO_NORESIZE flag.  We can certainly work towards trying to
> remove the flag from this index, but it seems the userspace driver is
> currently ignoring the flag and expecting exactly the behavior the flag
> indicates is not available.  Thanks,

Thanks for the quick reply, Alex. Yes, we misunderstood the expected
behavior. We have adapted our library code and everything is
working now.

- Russ


>
> Alex
>
>> cards. We were able to reproduce and root-cause the bug using system-tap.
>> The original bug description is below. An understanding of the referenced
>> dfl and opae tools is not required - it is the sequence of IOCTL calls and
>> IRQ vectors that matters:
>>
>>> I’m trying to get an example AFU working that uses 2 IRQs, active at the same 
>>> time. I’m hitting what looks to be a dfl_pci driver bug.
>>>
>>> The code tries to allocate two IRQ vectors: 0 and 1. I see opaevfio.c doing the 
>>> right thing, picking the MSIX index. Allocating either IRQ 0 or IRQ 1 works fine 
>>> and I confirm that the VFIO_DEVICE_SET_IRQS looks reasonable, choosing MSIX and 
>>> either start of 0 or 1 and count 1.
>>>
>>> Note that opaevfio.c always passes count 1, so it will make separate calls for 
>>> each IRQ vector.
>>>
>>> When I try to allocate both, I see the following:
>>>
>>>   * If the VFIO_DEVICE_SET_IRQS ioctl is called first with start 0 and then
>>>     start 1 (always count 1), the start 1 (second) ioctl trap returns EINVAL.
>>>   * If I set up the vectors in decreasing order, so start 1 followed by start 0,
>>>     the program works!
>>>   * I ruled out OPAE SDK user space problems by setting up my program to
>>>     allocate in increasing order, which would normally fail. I changed only the
>>>     ioctl call in user space opaevfio.c, inverting bit 0 of start so that the
>>>     driver is called in decreasing index order. Of course this binds the wrong
>>>     vectors to the fds, but I don’t care about that for now. This works! From
>>>     this, I conclude that it can’t be a user space problem since the difference
>>>     between working and failing is solely the order in which IRQ vectors are
>>>     bound in ioctl calls.  
>> The EINVAL is coming from vfio_msi_set_block() here:
>> https://github.com/torvalds/linux/blob/master/drivers/vfio/pci/vfio_pci_intrs.c#L373
>>
>> vfio_msi_set_block() is being called from vfio_pci_set_msi_trigger() here on
>> the second IRQ request:
>> https://github.com/torvalds/linux/blob/master/drivers/vfio/pci/vfio_pci_intrs.c#L530
>>
>> We believe the bug is in vfio_pci_set_msi_trigger(), in the 2nd parameter to the call
>> to vfio_msi_enable() here:
>> https://github.com/torvalds/linux/blob/master/drivers/vfio/pci/vfio_pci_intrs.c#L533
>>
>> In both the passing and failing cases, the first IRQ request results in a call
>> to vfio_msi_enable() at line 533 and the second IRQ request results in the
>> call to vfio_msi_set_block() at line 530. It is during the first IRQ request
>> that vfio_msi_enable() sets vdev->num_ctx based on the 2nd parameter (nvec).
>> vdev->num_ctx is part of the conditional that results in the EINVAL for the
>> failing case.
>>
>> In the passing case, vdev->num_ctx is 2. In the failing case, it is 1.
>>
>> I am attaching two text files containing trace information from systemtap: one for
>> the failing case and one for the passing case. They contain a lot more information
>> than is needed, but if you search for vfio_pci_set_msi_trigger and vfio_msi_set_block,
>> you will see values for some of the call parameters.
>>
>> - Russ
>>

