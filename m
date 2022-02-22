Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D123A4BF18C
	for <lists+kvm@lfdr.de>; Tue, 22 Feb 2022 06:42:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229773AbiBVFkP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Feb 2022 00:40:15 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:57960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbiBVFkF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Feb 2022 00:40:05 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2079.outbound.protection.outlook.com [40.107.94.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C68289A9A0;
        Mon, 21 Feb 2022 21:39:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iuPdwNzBgTUUWy23WfGm+cXty4+2W/3+M0TJoKNAZ53meCPzlTHvaPkPlYCA8UQkf9c1eyu9RJQ9p3O0mr3RmfLUqf3VP1FVj04FzrckzCF0EzQINjij/2IEpWOMe+2UKNvDvwquMZoSFHAVdd911E1DLoOQn2ahVHQ1NwYtO/r9pGnFkI0UIxYXxSgn8gUNI3hKQ3P/PPlIPiF6rCALZZ+kUUBezZStmuwFLhxaDICL/EXn7HjO+XpWxwSMMPBPy5qOeXjUiSWJSR+0EzVop/d82o40rfO3IcdSg5OcHv/YtlgUm6rPR3q1ZbHQuIVh0Gi/oFJD75VeYN0O2mGyDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EBpLSjXW7loYV1fLzJl4tVen7+ojMpOTVijWr5Xuglo=;
 b=Uyxmr+kw7w9gpI1JewFZbH/KgOyz0H+3/n5+QsxIsEW18H8wCdZ5uYW6YM93PrgaESGdl+5nNd15L9Ua1BLV/w+5iW46Njc2/oGNysBI8P4zJH75FgbAehtxnVAJQM9a/q9lMdmwp0Lv6LOOcDsmGyR4g3QfDPb8u5xeBCtX/e9id3YoqLCaO3RxdlYZ1ywUgE1HQ0p1a8UESNgjgqN+0QOgk977UFPcVGO74uDc/ZTRsQA7sPEga14moDSwNQGyU3H65TPbUWpSDUXhqO9iSo10SmpdFti8QSxMCuynRjbzWAN7f0acobVKBKNd9yvUAEPEJzcqwS5scwinbTE+fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EBpLSjXW7loYV1fLzJl4tVen7+ojMpOTVijWr5Xuglo=;
 b=NjycH4jqkavdqaltW01mPSajd8fY6FrvVVJvljTjsasKeJPKX2/E8+U9C9qlCMcgjMjdILi2ZQcppW2LbErrohHtsIudyGxRi3ixmXAGzoj1t6T/bG7kzw1dr+AydJEd9+wxYKDQ3gMBMK37KFlX7IMeHaE8bxzXlwb9fiTBmPs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM8PR12MB5445.namprd12.prod.outlook.com (2603:10b6:8:24::7) by
 DM4PR12MB5263.namprd12.prod.outlook.com (2603:10b6:5:39b::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4995.16; Tue, 22 Feb 2022 05:39:39 +0000
Received: from DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::6807:3c6c:a619:3527]) by DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::6807:3c6c:a619:3527%4]) with mapi id 15.20.4995.027; Tue, 22 Feb 2022
 05:39:39 +0000
Message-ID: <fd1bf218-c1b1-7a8f-7481-211d6f675177@amd.com>
Date:   Tue, 22 Feb 2022 12:39:29 +0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [RFC PATCH 11/13] KVM: SVM: Add logic to switch between APIC and
 x2APIC virtualization mode
Content-Language: en-US
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, joro@8bytes.org,
        jon.grimm@amd.com, wei.huang2@amd.com, terry.bowman@amd.com
References: <20220221021922.733373-1-suravee.suthikulpanit@amd.com>
 <20220221021922.733373-12-suravee.suthikulpanit@amd.com>
From:   "Suthikulpanit, Suravee" <suravee.suthikulpanit@amd.com>
In-Reply-To: <20220221021922.733373-12-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: HK2PR0302CA0023.apcprd03.prod.outlook.com
 (2603:1096:202::33) To DM8PR12MB5445.namprd12.prod.outlook.com
 (2603:10b6:8:24::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 89b19efa-e8a4-4f55-fc8c-08d9f5c5b79b
X-MS-TrafficTypeDiagnostic: DM4PR12MB5263:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB526338D1C84F4927E2CDAA27F33B9@DM4PR12MB5263.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GPzReNiLvQN56JbKi8xV7qJlQTJyBCI6SHY3Ucqx1JWUojJOwgdhnBCpbTcT4hCGdIIgH5UtmP7cctpUmQ/8P8moBhq/bqMf5rsocm821Or/Q5F6AQ/rGQZOBWjgRSiYzWxv1F+k/5EN1hsbC0rUVQM/8GbnkkV87InPFaCICCYeaaSb+aXelcP5x+oCUStUT5WHt864tX1G0YDNX8bbPxssW7CgKJRYupNOfRpE8KrlQYJ6rWAT2PA7MsaElkSfKp+BP31sd54Dtz5Urhfibtx/0DtWwaOfdMZrzHjrGgrtWs95sU8wFhXg7PcZY8qiRX9yzbqjKrjsiRwdyObARIM+ybMvskN1id9nbrry144/DfhlSzH5fDxWNKIrllT24wvGHw4BvJLcGfuWgjjKIhNxZyjd7zUwpx7lFa/za1uIKyNlpcSX+eXf/DyNGKNLraxavaAzFUh92DWX1lfas7Cnt+vaTK0eZmkS+SJwCEieegWjj7/og8xdQf/f/1082yxbiziJyY28FBgkHh6yoDDwsRMLDjAsOFGQGhQrzZ8xgDpCxk76biBjilFzgzLPtDBD49IGccq/aBWxMKMx0D/kpGVLCRML+/n7rWse8S1dG/IFN6utehrNXmQv0LmyWNbmh1EdGM9/YMPLvX/ft5sCn9IP/RO2t5dJyEkYprQ/RjqdRZlYMxri2pjRZdQvIfr8sX5cP5ROhVV9YvnlbcOq+pKLRCVq877Tgww/cr3hwfHHRZeKMly85Yg43oP0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5445.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(186003)(26005)(66946007)(2616005)(6512007)(66556008)(53546011)(6506007)(6486002)(66476007)(31696002)(6666004)(86362001)(316002)(508600001)(8676002)(83380400001)(4326008)(38100700002)(5660300002)(8936002)(31686004)(2906002)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V2x6MDZaY0IwL2dVWlFZcnhNbzNOemdHUzdicjRPKzYyYWtTMTVDeHlRdkhs?=
 =?utf-8?B?OUwxUm5YVGVhMGJSMjJDSDF0YmtsNkJPQ3ZHSXhnMS9uc0ptc0xsTlJXVk0x?=
 =?utf-8?B?YW5nd3JSdXhwbXpaYjkweklLRjhJNENyTndQWG1CV3hKMUhWZGh6MkEzbENz?=
 =?utf-8?B?cTBRdzBYNUpRMVI0eVJqK0J3UTRXdTd3T01FWTJZYUF1SG1KcHRqelYxRTRK?=
 =?utf-8?B?dnIzZHk0SERsZVdHQm45SGEwTmhPZzB5azNmdWVqNDBpdGtnbVAweXd3QWxB?=
 =?utf-8?B?WVUxMVEwN3BDOU9taXJnNXE0U0hCY0VnYkFkdHdjeVk3TlJWcFh0RGliRVBt?=
 =?utf-8?B?Z3Ftd0didXhEWkthRTlSVk56RllWMTBJSmx4Wm01MGQ5OEtQeloyN2NvY3Y2?=
 =?utf-8?B?V25hZ0lkYzlMQjE5NEdUMm9RTmRMbitSZHNmK2Nzdmt2VlpZdlp6R3pSWGw0?=
 =?utf-8?B?Z2g4MWhmKzA5MWN4VTdGZlVhd0dZeW03N3k4R1ROTUJaQmpzQVBMbGVEL0x1?=
 =?utf-8?B?S0JiUStzcmtnOEdRV2xmTXRkZzVhUmFHbWdQS2YwbHVwZEhLZmpSVVJtcW5W?=
 =?utf-8?B?UmxVVnNMY01WcENGdy9nSnkyckYxTHUxWmJ6WUtOVy9WTWNJMnY5YktkYldW?=
 =?utf-8?B?Nk1qYVRlNk5nYkdUYXYrV0JFZVpuMGQ4YlpZWWg3MzF5RW95d0lwcHUyTGJ6?=
 =?utf-8?B?cjRWT3I0enpWVTF6eXg2c3lxN0ZvQ1BhMEZPUFFTdU94VS8ya1hGSVNXSnZu?=
 =?utf-8?B?dXdiNi9qNEpxNUFsU01uUlgzYUxIWEhRc0RTekNGOGZ1b0tzYUtUblBvNlkr?=
 =?utf-8?B?VnRYZFM4OVFKK21SSUo0bm1RazA1czJYNU9vaXBEQ1ZVbzc2K1NmaERCaVVs?=
 =?utf-8?B?WmY3Zk9hV05vSHd6L0MrT2VOdkFaR0FPVUpIQkhxOGUrMS9CdXBzdWEvUVRR?=
 =?utf-8?B?T2xzbmo2YkdNRy8wMEwxa1AvcWdHTlNtdjVTSzBOR2o3TXNFS2hWVENpaG1K?=
 =?utf-8?B?dEgrUWtTMXdGbzU4SU80TzdTYWxIZzFuSnNnZGExWEZ1blFlcXZaeTI5SE1M?=
 =?utf-8?B?TCtQL1h1RGIzMkdhNEhBazRYYlRTRnNsc0ZNakhwWjVEQmtJY2JlT0FxODdE?=
 =?utf-8?B?R1BzZDRmNzFjbGd3SzdxakMyQUxnRUo1T0haeVNHSnNmWm1uZFdja1dSSXJ5?=
 =?utf-8?B?UitjeldKek9GTXI1U2k1R2J0UktDMXZJTEYyY216VEROZDZYUkpzUFFZNzBR?=
 =?utf-8?B?Y2xBLzlVemQvQU5wVXVxbC9hNG4xRlFJVTlPRGtPdjVVd1B0RU9leFB2QTRt?=
 =?utf-8?B?bEY3dmV4REE1b053OFkzbEdKY3hSVklWODBjcmkxN2MwR2x0Z3pLejIreU5W?=
 =?utf-8?B?bnU5UCtRcktvdnhPTDVrWTZ1YTVLa2RhZGFCNFFJRnpXRzRLeGRpMjk4Uk5l?=
 =?utf-8?B?NGp2TUdFWGNORW1NWllQVmw4YUdEM0RnSmhGQkhtMG5xTnkrbEhjdnNYZ1FQ?=
 =?utf-8?B?NGhOQS8zbXQ0b2pHMnBBa25SRW1NbUozaEwxTy9MOGR4WkNWT01rN1JuMjZ0?=
 =?utf-8?B?eWFYNjVGemxYb0NwRU5CQ25iT0VwZ0t0L1phQ0JYcUZSWUg4dTJMM2dFQVEr?=
 =?utf-8?B?OG9yUEVndTJOVkhPZmJLV1djWS9LWkduM25hdU52NU16b0tadEZKZWl4NE0w?=
 =?utf-8?B?TFM5RHF2UkRRQURIV1ZNNENaT2dKWlVoekNXNHlXbXJUa1lmWnp4YWtyTm9a?=
 =?utf-8?B?SDBHc1pnTkcxMGtTbDRYSWRFb2d4M253dGlBSmJoZEIwcDZOeEdXRDRINVY0?=
 =?utf-8?B?N2pKL0VnUXZyM0pjZitjNEVDcUJMc1BsQUo2Z0x6alQxaExPai9DMk5zVEhr?=
 =?utf-8?B?TmJpRHJqUVlZRFFlSU96VVdLUTkrMGQxYXRWTGZmK0EzNktLLzdsaCtSZ3BZ?=
 =?utf-8?B?MkxtVHFIL0U0TFFFVUdXTFMvZnhHLzZUdVBmMlJBb0kzcDViblhqSGk5RkJu?=
 =?utf-8?B?cTA3Vis5TXpUNmR3U3dhVFdwdjFRVkxML3pDcm5MSXdkR1ZFYkpyYk5iV3Vo?=
 =?utf-8?B?Z3hXN3hPMW5wb1V5Qm1PYW5paVBZVlVJZmQ3dE53aExPeGpvMlVJUmtaNFlz?=
 =?utf-8?B?SGV1dExzcS9IUFZTOC9CaWIxeXFpYWJYUjR2cCtVWnZvaFRzdmpWMUU1cnpB?=
 =?utf-8?Q?boTRSvgAnrcoerPMOfi7T1o=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89b19efa-e8a4-4f55-fc8c-08d9f5c5b79b
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5445.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2022 05:39:39.0732
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aSpQsejINYdZCSQp2yT/k2F5Esp/EAkwQW+jjlwH4TuNH7OfzDETqzNR+8NPJRw7k/m5KvrEfnMh98zSAfKCgw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5263
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2/21/2022 9:19 AM, Suravee Suthikulpanit wrote:
> ....
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index 3543b7a4514a..3306b74f1d8b 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -79,6 +79,50 @@ static inline enum avic_modes avic_get_vcpu_apic_mode(struct vcpu_svm *svm)
> ..
> +void avic_activate_vmcb(struct vcpu_svm *svm)

This should be static void.

> +{
> +	struct vmcb *vmcb = svm->vmcb01.ptr;
> +
> +	vmcb->control.int_ctl |= AVIC_ENABLE_MASK;
> +
> +	if (svm->x2apic_enabled) {
> +		vmcb->control.int_ctl |= X2APIC_MODE_MASK;
> +		vmcb->control.avic_physical_id &= ~X2AVIC_MAX_PHYSICAL_ID;
> +		vmcb->control.avic_physical_id |= X2AVIC_MAX_PHYSICAL_ID;
> +		/* Disabling MSR intercept for x2APIC registers */
> +		avic_set_x2apic_msr_interception(svm, false);
> +	} else {
> +		vmcb->control.avic_physical_id &= ~AVIC_MAX_PHYSICAL_ID;
> +		vmcb->control.avic_physical_id |= AVIC_MAX_PHYSICAL_ID;
> +		/* Enabling MSR intercept for x2APIC registers */
> +		avic_set_x2apic_msr_interception(svm, true);
> +	}
> +}
> +
> +void avic_deactivate_vmcb(struct vcpu_svm *svm)

This should be static void.

Reported-by: kernel test robot <lkp@intel.com>

Regards,
Suravee
