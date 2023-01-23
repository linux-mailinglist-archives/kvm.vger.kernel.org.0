Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13B8E678720
	for <lists+kvm@lfdr.de>; Mon, 23 Jan 2023 21:04:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233001AbjAWUEa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Jan 2023 15:04:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231782AbjAWUE1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Jan 2023 15:04:27 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2107.outbound.protection.outlook.com [40.107.8.107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3D898A4F
        for <kvm@vger.kernel.org>; Mon, 23 Jan 2023 12:04:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b96NuCwZdgjqVFXQt4aCHibuvdnr9heQqjbAdoNcaLkEC7qb08vFw8qUbZvbZVidPaysJmG0sQkTSZ8lXxFvZTs8m68h7lCCpl+y2O4rpL4SjlhlKH4YGgSHGncOJ2vNnwQE6TUENX7Oxx14QcYLRkT+9iKy6yt9FVvpTNxxRlMe1KY+pufWwLtIFc6Bs9NGOUjcXsHRI8xNVi7iGFP7TbYZ17D0S2QO9djXnt0S01os3rs1rjpsBcMNspueZoGgdDGa4P9a7FVFuSQo5rjGDyB6jRAHvEqBjJaa1gDnIfIGhEVjsz0mKLl8ZpI4Ety4fwRCxwQ2z9ywBlB1JolohA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WH6MpTtEotkXbmWvM4SW0G01Gp/bXc/PwxxizeHrIkU=;
 b=eQgFGtqMy0rQCU1LbAsXs1sTQFEmDlOX+RzwjJnfjJN/tGZcv+Tph+dRnrD984Vh2bk3+L4LRFE/w1zOe0dwZM/6ul4HEHMC4yLkC8THlwK1xFsfXNruoA7nQraAa7swk8nRVwfclai9l7KsgHPincD8f7qGVw4BkFvoa3oqDppfI40G8vioFY3FTUL/2fd2fpZ8In9FGEFti4b+eY2CQ1/uimsi+Dkcb4LikJP2SZl6sKBkoWZkv+DxucoT80FwDlJsIMrz9QZvORRo7ZencrDf/Kv1JqcM0DPnkqzTAFgDfiNUd77ycyiozfHtloK3enq8FYpKCCbMAF819Gu8cQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=uipath.com; dmarc=pass action=none header.from=uipath.com;
 dkim=pass header.d=uipath.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uipath.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WH6MpTtEotkXbmWvM4SW0G01Gp/bXc/PwxxizeHrIkU=;
 b=G+82vdA3IzkOmE00bRg1CYq1W6S/dP0FQkZqA4anXtBVIwYKfRKXS9Sj8g/cgep2wEL88EIUCNZQrz4BR5fKwxZFxYBnTPQXm+y3CtBGoNVf4210ByVB9pmEmi2BHVsbU9dHJ3T9oq7nv9I/nu405OJit552JA+vuWj1xrRVopG2/kV6slBP6jPrRZIt1+xkyTDBv/K0wWwatHcWARDBjXBgUovNMxRCw2Ns7EBpWRJHLfY2bYS84gBzervuZVo0bVhKchMO9plzeoXjF5NM2re3qOMTMYp0vDFJNaSJlO/qrEW0eCwqszZBND/6+jcur4QPnqby0vfAIP8e1/3p6A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=uipath.com;
Received: from VI1PR02MB4527.eurprd02.prod.outlook.com (2603:10a6:803:b1::28)
 by GV2PR02MB8436.eurprd02.prod.outlook.com (2603:10a6:150:7f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Mon, 23 Jan
 2023 20:03:49 +0000
Received: from VI1PR02MB4527.eurprd02.prod.outlook.com
 ([fe80::e4e:96d4:38b1:6d]) by VI1PR02MB4527.eurprd02.prod.outlook.com
 ([fe80::e4e:96d4:38b1:6d%4]) with mapi id 15.20.6002.033; Mon, 23 Jan 2023
 20:03:49 +0000
Message-ID: <a87b2e08-9b27-02a1-4f73-0776a3cf1540@uipath.com>
Date:   Mon, 23 Jan 2023 22:03:33 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.0
Subject: Re: [PATCH v3] KVM: VMX: Fix crash due to uninitialized current_vmcs
To:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Mihai Petrisor <mihai.petrisor@uipath.com>,
        Viorel Canja <viorel.canja@uipath.com>,
        Alexandru Matei <alexandru.matei@uipath.com>
References: <20230123162929.9773-1-alexandru.matei@uipath.com>
 <878rhtchjo.fsf@ovpn-194-126.brq.redhat.com> <Y87ZXRBfY9RThKHT@google.com>
Content-Language: en-US
From:   Alexandru Matei <alexandru.matei@uipath.com>
In-Reply-To: <Y87ZXRBfY9RThKHT@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: VI1PR0102CA0022.eurprd01.prod.exchangelabs.com
 (2603:10a6:802::35) To VI1PR02MB4527.eurprd02.prod.outlook.com
 (2603:10a6:803:b1::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR02MB4527:EE_|GV2PR02MB8436:EE_
X-MS-Office365-Filtering-Correlation-Id: 08e12599-5cc5-4cab-36eb-08dafd7cf136
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ffsQ+4kpkOmk3srNsddXZe//RZZUu04rGv9oQCf40hzwvRFUntj6z81EjxO01hd3bXNZ1TbQLc7Q/HyfUNQYNNvP2I2dsWGihUILJ/+lS57q4I43TesKNtp48Lf+yQZdfKBk2elVFBORcUN2M9olpQgAtktiipWVh0sqEx/Vs7Gq/WmSGGz44p+vUs9g+LAeJI2RUclGyNlRmHbHGH0ympR+Z2yRl0bm0cjquA9SPsjb+HT1KK6q0WCPzADV9H7eycQYzvnU5RLCymnVEaNuS+qO0X/yoDbcqt41pEyvGhHjqcpFFpsZ5WeNRLd93BZ4g8mVNSDwJ7AlcENh/64hOGCRIBJEFTXeF+5eFDS6wPO6+/dyssEp0DpQZahzQ+9tCbVGvE092n0xrGgIhaKC+2u1cOp02tkHJobNF/u1Gk3o8wbkVKgxIVcim4DoCAzmyoCVyriRejNqixh3+kvV+de4gAwj+BXMpG+qsdYf0Hl4iv6LzurLJQCUmaCBjtJML2Tzd5Q5g/PI6vYGa1sidySUxlhhJ7t/mdQr/ZB+ftvINgd/yH4mLq/J3jljagnpxwA5SILc5AUZEriyB5h5cgymAojpd5N809sxalP2mv19T/B0kWjCIdKycDR+jpN+8zS5N9Y/2JjKvnTfM4gVOFRuYdmt7d85YSEpoyLBPTjdJuq5W2th9T3irCY6ADJS50mYhK/jadSdETipD1hjDrQsfw2RUk8ek+eNDTfDbMg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR02MB4527.eurprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(366004)(136003)(39860400002)(396003)(451199015)(31686004)(6486002)(66556008)(4326008)(66476007)(66946007)(8676002)(2616005)(26005)(41300700001)(186003)(8936002)(107886003)(6512007)(44832011)(5660300002)(83380400001)(6666004)(6506007)(53546011)(2906002)(38100700002)(31696002)(110136005)(54906003)(478600001)(316002)(86362001)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RmpJdGV4MzUyLzVFU0o4T1N1WmVlbmt4b2d4ZlNyMXdQVnR3dGoxUFlnbFFW?=
 =?utf-8?B?T0Z0cGlYd2g3VmlkQzR0MzlYUGx0R2lwMWZjSlcyWk82c1Nmd0dUaUJ6K09N?=
 =?utf-8?B?Tm9kdms3dmxaWm1QWE44ZG5yZlJhUnFpZjFpeHFwMlRGUzczcWwvRlJPNVVq?=
 =?utf-8?B?QnpUOFE2OGJTYXNxbEpZaldScmdkMndCNHA3RUI3RmQvaFNQZk9Bckhnb1Z4?=
 =?utf-8?B?OVFkY3V1WTY5cUNwdlkwTlV6RThoQkl5bmVmSGxTMUF6Z2wyWTFEblBGOW0x?=
 =?utf-8?B?ejhucXNiMnF5Y2s4dEJDQndYSXJ1eWVKUFZiR20xUk1ORlJKQUkyTCtFQUo0?=
 =?utf-8?B?eUxSekh2SGR1THhYaHFHd1B6RmxJbGFOUkxYUFVBL29qdkRXeWp6aDQ1ZmZq?=
 =?utf-8?B?S1BvUVl2Y3k1UWhLbm1zQWtqZXJRTTQ0cEdpUTVBYjI4WEVCL0hOSXY1akJV?=
 =?utf-8?B?Wk9MT0EzcEhwVVpUQXg4dzZaTTdrNmJCaFBzOXo0Q3VJTFBiNXNLem95RVUx?=
 =?utf-8?B?WFZSYVBlNTdtZVVzLzc0b3N0ZkMyOHpuVXQ5clNXNmt2SDR6ZXdPNjJ4cXVS?=
 =?utf-8?B?OVYwbHAvcGszcllPNm1hVEdSai9vQkg1R1gyUm5OZkNONEFDNFJlM0ZDRnNS?=
 =?utf-8?B?Mk1DaFZxVTRVMjhIZFl5UEllTDFZTUJhUldqQlRqNStQNnBodHlzdmIrK1Bu?=
 =?utf-8?B?SCtQcjJZa29MZkQ4N2l5RndUZUdKWXczdUhScWg5Tjl5SVNaLzhNMVZZQW1H?=
 =?utf-8?B?TFVWSHkwNWpRZ0lpQlpWUUJyRGJZaVJVV2phbnhWY1ROUHp6TU9zK2ZHSHRW?=
 =?utf-8?B?aVN6TFRWMWRYbS9RTUNuUEh5eE5JK1lXa1dBQ1pMbDh1ZFM0MTh4UVpRUEw4?=
 =?utf-8?B?WnBOMmN2QytPbHN5UDFaVksyd0ZXUlVCZ0dQdEFGSDJPZHpVcGlOM0xqcGRH?=
 =?utf-8?B?Z3JQcjBmSXdkaTEveG1EdUJ3cng1Ni9PNFA0ZjdodjBUQWVNbDhyWlFUdm9u?=
 =?utf-8?B?Zm1IVzhZTjU4KzRFRzdya3ZNWmk2VEd6SU43MURTTmw1OTNMTm53M3dTQWxX?=
 =?utf-8?B?NVBzUndSZ0k2Yzd0RTY4ZGFZblc3Nit5T2JQUFJYcGJ1ZkxoMW10RlNJYUF6?=
 =?utf-8?B?SWxOYkcwaE9nT3cxZlJKT0Q3L2JBTW5NSWdsMlAwQ05aTlFFZElaUUoxVno3?=
 =?utf-8?B?REZ5dFlxeUwxNU1jQjBrZDU1WDNhMmxmZER1TkhIekNJM3hSQjJVVnBHY0h2?=
 =?utf-8?B?ZmlPTFNTbkhnS2NSdzVSUVIrbjczTG1RQ3FaQ1h0WVVmZFdYOVh3bUpxS25C?=
 =?utf-8?B?TWhUOEU4bHcvOGhhblRqakhTbnhUYklPaVN6OGFvWnNYZ2srdUpUc1lMZ2lR?=
 =?utf-8?B?MWJOZmZjRGVENkNUVmVTOHArOFViaERMMjdvVFd3VEhJQVR6QzdVenFpem9C?=
 =?utf-8?B?NXlCVU54em11cmZsemRFMUZpdTVNaUhKa2lNdGNaQk9WUDhTY2ZBNE9xUTYx?=
 =?utf-8?B?WXRKbDM5L24wUEVLWkluSytmTENoWk4wZEMzWmxpbEdwTFZGY2dRdmFsdFps?=
 =?utf-8?B?Qms1YXNaNzBxRWdVMkVuSHJWQmdVK2tuYWRPenc5b1JvM3BGQ0NpamJ6SVRL?=
 =?utf-8?B?RVNXRXl6aGo3aml2a01DY21kRWJFT1V1QUp4WWVGTkNpanVJL2tpLzlGTzg4?=
 =?utf-8?B?STRUbTJxR1M5YVY5Q1F4dHMrbVlSQW9DbkZYVEJiVjJ0Wm9JTnozNzFQV3lh?=
 =?utf-8?B?dXlKeDM3V29zWnNlWmhoYmxHRUYwWHNXdzVxRkVuMUJ1Tm9xVnU4OFMwY1kz?=
 =?utf-8?B?cVdacmNaalp6Qi9TaTIwM2dtSzd4NTFSd1NkVU9ZRUN3dUZTNG5WRThoRjJC?=
 =?utf-8?B?eWVuMUZEU2V0M2M1M0k4cTVnZXRuZHJhdHVKYVJ2Y1k4SGhIUU05L2NldXpR?=
 =?utf-8?B?d05TdExTQTJIeGRkcGUxY3p1eDRpNlovMEVMYkFmNE80eGZ2V1NnYWpaVGpk?=
 =?utf-8?B?NithZGc0RGpmSElxMGpoNE9MTzVld2lreFJmcVJJdld4Rnc3WUFNdnduQjF4?=
 =?utf-8?B?dExjcFJJcW44cXFTOGZmWEhMb1J3WlByY01EeUNqUTlheDVDSWhia2YvRU9r?=
 =?utf-8?B?ak1ucmdjbXhQUXZZRGkrZU5kQWJsdjN6K1M2NjQ0cUp5OTZ5SEtvQ1E0TEFy?=
 =?utf-8?B?c1E9PQ==?=
X-OriginatorOrg: uipath.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08e12599-5cc5-4cab-36eb-08dafd7cf136
X-MS-Exchange-CrossTenant-AuthSource: VI1PR02MB4527.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2023 20:03:49.3792
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d8353d2a-b153-4d17-8827-902c51f72357
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q366EW5CHBNgWk74341zUS6DanF2Lu6R6xF/i2wpAVnWGKftfNmooH9mdVFzTOiljTTnARsO37eO9nBvCBymNkyYcYKi9AlGKUIRqE+lLAA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR02MB8436
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/23/2023 9:00 PM, Sean Christopherson wrote:
> On Mon, Jan 23, 2023, Vitaly Kuznetsov wrote:
>> Alexandru Matei <alexandru.matei@uipath.com> writes:
>>
>>> KVM enables 'Enlightened VMCS' and 'Enlightened MSR Bitmap' when running as
>>> a nested hypervisor on top of Hyper-V. When MSR bitmap is updated,
>>> evmcs_touch_msr_bitmap function uses current_vmcs per-cpu variable to mark
>>> that the msr bitmap was changed.
> 
> ...
> 
>>> @@ -219,7 +223,7 @@ static inline u64 evmcs_read64(unsigned long field) { return 0; }
>>>  static inline u32 evmcs_read32(unsigned long field) { return 0; }
>>>  static inline u16 evmcs_read16(unsigned long field) { return 0; }
>>>  static inline void evmcs_load(u64 phys_addr) {}
>>> -static inline void evmcs_touch_msr_bitmap(void) {}
>>> +static inline void evmcs_touch_msr_bitmap(struct hv_enlightened_vmcs *evmcs) {}
>>>  #endif /* IS_ENABLED(CONFIG_HYPERV) */
>>>  
>>>  #define EVMPTR_INVALID (-1ULL)
>>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>>> index fe5615fd8295..1d482a80bca8 100644
>>> --- a/arch/x86/kvm/vmx/vmx.c
>>> +++ b/arch/x86/kvm/vmx/vmx.c
>>> @@ -3869,7 +3869,7 @@ static void vmx_msr_bitmap_l01_changed(struct vcpu_vmx *vmx)
>>>  	 * bitmap has changed.
>>>  	 */
>>>  	if (static_branch_unlikely(&enable_evmcs))
>>> -		evmcs_touch_msr_bitmap();
>>> +		evmcs_touch_msr_bitmap((struct hv_enlightened_vmcs *)vmx->vmcs01.vmcs);
>>>  
>>>  	vmx->nested.force_msr_bitmap_recalc = true;
>>>  }
>>
>> Just in case we decide to follow this path and not merge
>> evmcs_touch_msr_bitmap() into vmx_msr_bitmap_l01_changed():
> 
> This is the only approach that I'm outright opposed to.  The evmcs_touch_msr_bitmap()
> stub is a lie in that it should never be reached with CONFIG_HYPERV=n, i.e. should
> really WARN.  Ditto for the WARN_ON_ONCE() in the actual helper; if vmx->vmcs01.vmcs
> is NULL then KVM is completely hosed.
> 
> KVM already consumes hv_enlightenments_control.msr_bitmap in vmx.c and in nested.c,
> shoving this case into hyperv.h but leaving those in VMX proper is odd/kludgy.

Got it, I'll send a v4 with your patch.
