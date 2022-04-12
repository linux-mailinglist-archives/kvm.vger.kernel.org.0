Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA3964FE73D
	for <lists+kvm@lfdr.de>; Tue, 12 Apr 2022 19:36:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352317AbiDLRip (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Apr 2022 13:38:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358789AbiDLRik (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Apr 2022 13:38:40 -0400
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.109.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B5095BD13
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 10:36:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1649784979;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=n6t4UzONIJJaYOmkLzvNQVou3aXVutI6p9Zfo83bafc=;
        b=IZZohLLQAuERYDho1o9CXW+FR0ug1cKrk8ne2aYfCMzQGwsdCGwuZL7Ks5whd4s5d4KvHp
        t7CBNtZX5laitnfFlXR/Vl/JCkCGNdDPoqd6onUaTk9PZ634ru6mU281hVEytaOez/MW8V
        exiqvUuUWG8TyuU0mlxxYyKDcMDSdk0=
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur04lp2054.outbound.protection.outlook.com [104.47.13.54]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-11-pBqwz1iwPmyiPj52aIknAQ-1; Tue, 12 Apr 2022 19:36:17 +0200
X-MC-Unique: pBqwz1iwPmyiPj52aIknAQ-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XljBVhpGAdv5GWlddl4Y7cpw3xBkgTIlxEaRc4H2py93ec/81SCzXjKuhrAFQ9jppoPu5rE5j66ppX/Wgu2M4LuQGZsd3MatGNAzuGj7TQm7CDxsGCKKk0dkgA8IO0fPGUupswkL6vFedAWoeFWtx2JI+dXiQ/uP4IZ4lnOP2m5ulZs7vaUQdz95Mx4JX6CyiClvIFofIZAuFOWvajbCFrIe6kCerSYMTo2qdKyV+NclQV34J/ws9sZv/lyUHbx/loPCjcSm5OiPe+oIZZezhMBK83COrobutIAY2JaXOWxOuVSTAsj96hqA4d7Mp7Fw0YXGXYPf0BOgbKsdKjyBOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n6t4UzONIJJaYOmkLzvNQVou3aXVutI6p9Zfo83bafc=;
 b=XdIAWpc4Z7YPE514Dvujq/cUTM2xoA3bSd3N0l/eojNQMJHNPS5hLruG5+3pRi1myQw4FWA7OhdVmnpParlji+7S066hgEKcULThiZN1Xvb+3aPOhfWilCbK2JBQ88dcmb5qgXx9/rqpB2s/MLDos6smOEKe5tErE2WGuCbuq1aosyuIAfjQdqGa6c0waD2NmGtbrKMror9NZMPK0IKQmX7+jkCCROh67DOhxo6XHphwm3Szb113e8vciWDb9QwvOjWASIYt1jw55WCnUVcIQa+seijndmMC36ohiAN02K+GTu7y0jnYCCqHVgrsmT6gV0sS4ZB7ZHV3dWFv6nR2Cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from AS1PR04MB9653.eurprd04.prod.outlook.com (2603:10a6:20b:475::14)
 by HE1PR0402MB3564.eurprd04.prod.outlook.com (2603:10a6:7:84::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.18; Tue, 12 Apr
 2022 17:36:14 +0000
Received: from AS1PR04MB9653.eurprd04.prod.outlook.com
 ([fe80::ec9c:195c:337d:7af7]) by AS1PR04MB9653.eurprd04.prod.outlook.com
 ([fe80::ec9c:195c:337d:7af7%7]) with mapi id 15.20.5144.029; Tue, 12 Apr 2022
 17:36:14 +0000
Subject: Re: [PATCH 01/10] x86: Move ap_init() to smp.c
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, drjones@redhat.com, marcorr@google.com,
        zxwang42@gmail.com, erdemaktas@google.com, rientjes@google.com,
        seanjc@google.com, brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        jroedel@suse.de, bp@suse.de
References: <20220412173221.13315-1-varad.gautam@suse.com>
From:   Varad Gautam <varad.gautam@suse.com>
Message-ID: <24212c8c-8e15-771c-663c-280e1c4655e2@suse.com>
Date:   Tue, 12 Apr 2022 19:36:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <20220412173221.13315-1-varad.gautam@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS9PR06CA0342.eurprd06.prod.outlook.com
 (2603:10a6:20b:466::18) To AS1PR04MB9653.eurprd04.prod.outlook.com
 (2603:10a6:20b:475::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d07cc393-1007-427b-c7aa-08da1caaf0f6
X-MS-TrafficTypeDiagnostic: HE1PR0402MB3564:EE_
X-Microsoft-Antispam-PRVS: <HE1PR0402MB3564F8C1FABBCD6F174938A4E0ED9@HE1PR0402MB3564.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uzFJ5wITIWDgMRsDUlP8gHTq3NMrTP3AJ10P3txeBzUJ74HJaP2apUXOE0buPLxnFMYgt/OvvqHKvNu2gcHdC5o97wkrZx66KCMVRIR4NVZSWzY1gnwb8UcV/LIXj/ispUxZfOrQxqYJy2o4eMtqRz+0jd/QNjRntuIGS3549jwSUFGCURZphhgmnl7tnk075zAkATW2oVdJrmVB9UfTAJxW8FGj513cCH5uBqzviG947tbMk1Afpo6gLf/VB0ij+fjpxaZwJaljwft6nLHowo+mFQ8FqZ0/pgRkx4mdkyaoPuINonWspK9NrXQM4/lM0tyNN+foapukfdMS6WrTOFd2h5V2AK4fbVBEa9tUPAmB3mlkC44rMY8yUmimqAyCOCfNkYopSZG5bCc36b9X64oVB/7hBrsoCnE4No7Cw+Z5s17I49EZezdPihRiyYLxV192VMCepLUR62Q9nnYOUfx+gmXj7E6XGwLYLgpDFs1bjWxLf8/TRoO88duYcIdIN+ZMqmLEuRH16esvfof7qwfAb6HWYr4o/4kICLag7/4wYmBgbBOpruyXyly1ReXr8+Fe2w93WYo0DgBp6tYo9cZ7qwyNNVmOQL51zWbfrfkiniXyMb8C7Lc5Z9NP/CbdqwwrGeRBcWoLc6Z7u50OTRF7sxMTfHtFQ7avT8CJRufgzn7ARX5gKrtrUFucTRDQ7KA9XdWcyePln6MWfpEQIatG3+UwSPbItTD2OmvZ3CgavZaZvYHQ75aHpdu8MtgbE2UkHX9WU3DcL+ch7Q7XnM9uRenbY9O6/Yt0Dl5eE6TUCZ/9P9eKKa7lC3umUJWK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS1PR04MB9653.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(5660300002)(66476007)(26005)(66946007)(8676002)(8936002)(186003)(4326008)(66556008)(508600001)(7416002)(6486002)(966005)(6506007)(38100700002)(53546011)(2616005)(6512007)(31686004)(2906002)(36756003)(31696002)(6666004)(316002)(6916009)(86362001)(83380400001)(44832011)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S1M1V2YxdVZJS2VxdmNEYklBaHRQUENwSEU0bzkydnU5aUQrVUZDZHhhNzBi?=
 =?utf-8?B?d1FIYlBPOEtvTWFBNldGYkFzRlFiWUFKVkZPSTEzcGlNSEdVU0dLQUFMSkZn?=
 =?utf-8?B?Z1I5YmxBSW1ZOXRqbnQrcEVwVnhmM3RTdWNnQ1cxMHVrZ29NVUNpQXVwKzFa?=
 =?utf-8?B?c3BsYzZ0UXR1bVJWTmFxQVkybWhReW5pYVBQV2hMeVFOTnBJRTZZMSswczM2?=
 =?utf-8?B?VWUxSS9BTGFnWHJSSkNLRTNQNEc2amRPcW44OEVXQ0FrMVZxUmZEVGdBRENF?=
 =?utf-8?B?YkNrSytSNkF1SjM3anlMenYrbjZyeVc3RmduT0E4NjBFL0ZURFFHVVpjb0xX?=
 =?utf-8?B?dmdZbVlyV3F6cGVyRnpIR0ZpVjFBRDdTcGR1Y2VXMUJJWGlhZjRzMGdjSGpS?=
 =?utf-8?B?d3RMM1hNakV2UG4rVHdBRytwTlNIbnlUWk9DMHdtSEZpR3hQM0hMSmk1RWdJ?=
 =?utf-8?B?NUk5dTBlWUNQSDJLb0NBUGNwMjlTcXozcHlpUFYrVkVSTVEwbkVacjE3YjNC?=
 =?utf-8?B?cFVWc0I0Rm84a3I3L1hObnphZ3locWFIaTNkd2I1bXVrRXA1NkNQaUVUTUZl?=
 =?utf-8?B?OUhDRUxYVHE1K3cwOVVmSjBZMVYwcE5wdElxVVpRWUh6SkVqRnFFNWxaSkc3?=
 =?utf-8?B?NHQvUHBTZFRVbUc1YWY3ZEdqZG5YMDRrMmg1VVF0eVBHLzVJZnZ0cXBRWEN5?=
 =?utf-8?B?eUJOcnBJd0ZybkNIeDdlQjdMQmZFNGEvK2Y3M0E1NzNld0xSUXBER3lNZ2dQ?=
 =?utf-8?B?WXpNdjkrL0NlYTdQMjJNZ1B1R0l1eFFHK0FCbUJyTzhxandsQndybXJKWllJ?=
 =?utf-8?B?Zmk5U3RrVmRvM1M0UitFdXgyMU9XU3hTOUl5TVBtVjVZblFOczBFZGF0bW9W?=
 =?utf-8?B?UHlHN2FRdnZtYkErZWpjVnVLOFY5WVZaYjVCbjIvSXdsaFZTWkYxMERtaWEz?=
 =?utf-8?B?aTZsbDFLSTFiMkVGK3NBeUR0RmNWMEFGSDFhR2tqb25VZVgwcXlCSWhncWZO?=
 =?utf-8?B?ZVd3OXRNYTdUbjBtUzI5dVI3d1BUN2tWME5TdkhCQzF0aldpU2VCWmo0N1Fi?=
 =?utf-8?B?YjJVYW9pNE9QN2Z2TnRvcTM5K2lndTJaYjZaRTFVTDJOdTcyMEdyblRScUQy?=
 =?utf-8?B?Uk5nZ0xic3lraG5uazhIaGdzN1ZEV3U3N1FjcmZJSERJaDJoMnpTVkFyVm9n?=
 =?utf-8?B?VkxKejUyQjR6N2hCSHlrUFAwaXBodk9kTGQxYjFXUHJIS0NneVlWNnBBZUVt?=
 =?utf-8?B?eGcxVGViQmhPckhRRTBFVUg2NkY1SVVDNzFpMTZMbjZOaUFrRzBBZ1BvT1l1?=
 =?utf-8?B?Q0hObkdua3Y1eVRXY25xZjh2UDJxQVkvQU52ODhuaTZkdm9id2J1VnhtaEZh?=
 =?utf-8?B?Yjc4aThDM0tsYzRTN2ZYYnhTZEVwOGpwVTZDQllicG9obnpxT0xoU2p5SmFv?=
 =?utf-8?B?aEJpRE5qYXNDbHA0cExUSGpyUi8wWkNLZHpEN3JMTTVQcVZkVUxUNzU5aVFt?=
 =?utf-8?B?Vit0OVR6UWNEbUFjYXRVYXpLeUd4Uk1WMjRUbnlKNDJXK05nemNaRHhlK2R4?=
 =?utf-8?B?ak0wb0g1VVJRTTNPZzJQTFJpZERNbE12RWxWWTRBNWVnMENOU3BkczdVZisy?=
 =?utf-8?B?OVA1Sk1iTEUrcWE0NGhna1NjTlc4VmlCQUNQclkwaHpJcG5aUmozVGVYVjZZ?=
 =?utf-8?B?Q0RIU2hDUVE0RWFIVXUyUDFHRE43YUVUdFZPLzVmUmxVSFZkaGlzUUhrcGgw?=
 =?utf-8?B?bDRMSkkzZWYxTmlzb2tvRVVlS1VwUTM1SnlIdkhXUDhWTnZ6SXVVMmlJejZC?=
 =?utf-8?B?cFh0WmhwT05FRE4yT05lOTI4SnFvcUhoTlFuM1pWTnR3WGQvU3p2ZzY0L2Mv?=
 =?utf-8?B?Z05IYnVSczk1L3NvQ0lzM2ozSGpCWVJPNWlWTnRpalUrdTN3Zm91RWErdVJj?=
 =?utf-8?B?dE8reTY2aklLaDV6T0dOd1ZpREcvaHhVWFBqS09IVHUrNHEvRXI3NDV5bldK?=
 =?utf-8?B?YXc5YWN4TWJVN1lMQk5TZ2cvZk5CMnJrc24zeFZzbnVOOE9mQjQwMWdzbHR6?=
 =?utf-8?B?L3VLbUswejBhU1g2ajdxT2JucUVscW5ZcGl0cFFyQjZQTWZtTmdRdlU2dWxj?=
 =?utf-8?B?ajJRTzBJQWI0REM2UXJtczF1YlJLOFJNZ0VVSUtJdWJnbytsMFpmTDBzb2Vv?=
 =?utf-8?B?Rko4c1JVcTJ6RHZCRFIwSXlvRlBMSDZEdFNvTDdCT0pEc0thSXhBbzJ1S2FB?=
 =?utf-8?B?QzFrUmQ3R2RsSzhNSURjWnUwaDcya0pVNlVqZjhNeHY3blJXTXBYR3RkTlFu?=
 =?utf-8?B?Z1Vhc2lZaUdUTXZ2TmkrTnV4bk5hZ1RGMlZSZ05VVEp6UFZmVE4wdz09?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d07cc393-1007-427b-c7aa-08da1caaf0f6
X-MS-Exchange-CrossTenant-AuthSource: AS1PR04MB9653.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2022 17:36:14.1099
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5ANJnkpCulOy1Am/3UrqKEEv6Zr1FJaCG1mk2hdkjdMr60TBSKmf04DxdHmVH+TQ6ahkgxMIdbn5oeOfTvO9qA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0402MB3564
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Please discard this series, I've resent it with a cover letter here [1].

Sorry for the noise.

[1] https://lore.kernel.org/kvm/20220412173407.13637-1-varad.gautam@suse.com/

On 4/12/22 7:32 PM, Varad Gautam wrote:
> ap_init() copies the SIPI vector to lowmem, sends INIT/SIPI to APs
> and waits on the APs to come up.
> 
> Port this routine to C from asm and move it to smp.c to allow sharing
> this functionality between the EFI (-fPIC) and non-EFI builds.
> 
> Call ap_init() from the EFI setup path to reset the APs to a known
> location.
> 
> Signed-off-by: Varad Gautam <varad.gautam@suse.com>
> ---
>  lib/x86/setup.c      |  1 +
>  lib/x86/smp.c        | 28 ++++++++++++++++++++++++++--
>  lib/x86/smp.h        |  1 +
>  x86/cstart64.S       | 20 ++------------------
>  x86/efi/efistart64.S |  9 +++++++++
>  5 files changed, 39 insertions(+), 20 deletions(-)
> 
> diff --git a/lib/x86/setup.c b/lib/x86/setup.c
> index 2d63a44..86ba6de 100644
> --- a/lib/x86/setup.c
> +++ b/lib/x86/setup.c
> @@ -323,6 +323,7 @@ efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo)
>  	load_idt();
>  	mask_pic_interrupts();
>  	enable_apic();
> +	ap_init();
>  	enable_x2apic();
>  	smp_init();
>  	setup_page_table();
> diff --git a/lib/x86/smp.c b/lib/x86/smp.c
> index 683b25d..d7f5aba 100644
> --- a/lib/x86/smp.c
> +++ b/lib/x86/smp.c
> @@ -18,6 +18,9 @@ static volatile int ipi_done;
>  static volatile bool ipi_wait;
>  static int _cpu_count;
>  static atomic_t active_cpus;
> +extern u8 sipi_entry;
> +extern u8 sipi_end;
> +volatile unsigned cpu_online_count = 1;
>  
>  static __attribute__((used)) void ipi(void)
>  {
> @@ -114,8 +117,6 @@ void smp_init(void)
>  	int i;
>  	void ipi_entry(void);
>  
> -	_cpu_count = fwcfg_get_nb_cpus();
> -
>  	setup_idt();
>  	init_apic_map();
>  	set_idt_entry(IPI_VECTOR, ipi_entry, 0);
> @@ -142,3 +143,26 @@ void smp_reset_apic(void)
>  
>  	atomic_inc(&active_cpus);
>  }
> +
> +void ap_init(void)
> +{
> +	u8 *dst_addr = 0;
> +	size_t sipi_sz = (&sipi_end - &sipi_entry) + 1;
> +
> +	asm volatile("cld");
> +
> +	/* Relocate SIPI vector to dst_addr so it can run in 16-bit mode. */
> +	memcpy(dst_addr, &sipi_entry, sipi_sz);
> +
> +	/* INIT */
> +	apic_icr_write(APIC_DEST_ALLBUT | APIC_DEST_PHYSICAL | APIC_DM_INIT | APIC_INT_ASSERT, 0);
> +
> +	/* SIPI */
> +	apic_icr_write(APIC_DEST_ALLBUT | APIC_DEST_PHYSICAL | APIC_DM_STARTUP, 0);
> +
> +	_cpu_count = fwcfg_get_nb_cpus();
> +
> +	while (_cpu_count != cpu_online_count) {
> +		;
> +	}
> +}
> diff --git a/lib/x86/smp.h b/lib/x86/smp.h
> index bd303c2..9c92853 100644
> --- a/lib/x86/smp.h
> +++ b/lib/x86/smp.h
> @@ -78,5 +78,6 @@ void on_cpu(int cpu, void (*function)(void *data), void *data);
>  void on_cpu_async(int cpu, void (*function)(void *data), void *data);
>  void on_cpus(void (*function)(void *data), void *data);
>  void smp_reset_apic(void);
> +void ap_init(void);
>  
>  #endif
> diff --git a/x86/cstart64.S b/x86/cstart64.S
> index 7272452..f371d06 100644
> --- a/x86/cstart64.S
> +++ b/x86/cstart64.S
> @@ -157,6 +157,7 @@ gdt32:
>  gdt32_end:
>  
>  .code16
> +.globl sipi_entry
>  sipi_entry:
>  	mov %cr0, %eax
>  	or $1, %eax
> @@ -168,6 +169,7 @@ gdt32_descr:
>  	.word gdt32_end - gdt32 - 1
>  	.long gdt32
>  
> +.globl sipi_end
>  sipi_end:
>  
>  .code32
> @@ -240,21 +242,3 @@ lvl5:
>  
>  online_cpus:
>  	.fill (max_cpus + 7) / 8, 1, 0
> -
> -ap_init:
> -	cld
> -	lea sipi_entry, %rsi
> -	xor %rdi, %rdi
> -	mov $(sipi_end - sipi_entry), %rcx
> -	rep movsb
> -	mov $APIC_DEFAULT_PHYS_BASE, %eax
> -	movl $(APIC_DEST_ALLBUT | APIC_DEST_PHYSICAL | APIC_DM_INIT | APIC_INT_ASSERT), APIC_ICR(%rax)
> -	movl $(APIC_DEST_ALLBUT | APIC_DEST_PHYSICAL | APIC_DM_STARTUP), APIC_ICR(%rax)
> -	call fwcfg_get_nb_cpus
> -1:	pause
> -	cmpw %ax, cpu_online_count
> -	jne 1b
> -	ret
> -
> -.align 2
> -cpu_online_count:	.word 1
> diff --git a/x86/efi/efistart64.S b/x86/efi/efistart64.S
> index 017abba..0425153 100644
> --- a/x86/efi/efistart64.S
> +++ b/x86/efi/efistart64.S
> @@ -57,3 +57,12 @@ load_gdt_tss:
>  	pushq $0x08 /* 2nd entry in gdt64: 64-bit code segment */
>  	pushq %rdi
>  	lretq
> +
> +.code16
> +
> +.globl sipi_entry
> +sipi_entry:
> +	jmp sipi_entry
> +
> +.globl sipi_end
> +sipi_end:
> 

