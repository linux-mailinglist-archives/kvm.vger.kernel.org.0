Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7B1977CF6C
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 17:45:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238148AbjHOPpS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 11:45:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbjHOPop (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 11:44:45 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2057.outbound.protection.outlook.com [40.107.237.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F316CE61;
        Tue, 15 Aug 2023 08:44:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ROYlnltZ0CYm7RE4ZupfeXZknxo3iQoyLP0wV9pLls99yVP0VbqeJ7go45kp0q+FYRSo2vfqwxSZV4tYP4JSCgMDJF4AQOK1oDnRYTWb84e6VkbCb7LhtWKQREMZvMsb1tZqdeNlf4Z1xHaVZ+x87+fK93bbzosDFKOZrtsUyHSzG3eTYDwZqVnz99iCamG+zOuNEU+3s/30HEeekk2IltWngb+uiRTEAib0/e26K+YNmDokg842K5uQj2mPhyqcyK0hSfJG2LXFbDOFTlKjyaZ/Lgz0OZx4gUL1Uj73PtEJheFROZA4iqcwB11fXEyfCIX+dtC5pVSmgKAFIFEh6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9JWA4O9VVhJ6nUHagzx6aAb/WcFD+i87ixntjT83M1o=;
 b=Fw8uXQhJ+P7R9BD+kBZar83aXLxh83rhIk3lBQ1Y9HJbXo3kH94DnbY1UiScmNioeSCLIV5ofy6/GqeFQeaovf76DAia3asvQLSbFe5aFLU8eBoM9jXZTyD3A5Y4BANQms9XHi8bd14sh/zPVeKHp6m6Ab+vYNSMj0klgtC3Z/HELpmfYO1DMI0iq2rFg3dLSeEcQYBxoS72bR73qGkUjkj6RyRx2MoZK4ttJXPTiALzelxI+hZeAIzZhMEE8rvYRa70zl+46HnwWPsHDZ2K5QXL4kF8QykOT3Zsl8+ZlwxeAoemRvpXu3wZcy1yoZXnK2F4uAqh+MdvGvFa41GaHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9JWA4O9VVhJ6nUHagzx6aAb/WcFD+i87ixntjT83M1o=;
 b=jNQYueFvYmVw22Rx751Yw9UT3KjXMmVD5QtyJR3GaTKyxItNN+VApNOE64xDKHHU4XhcJ3LOYvBOiokaKRjz9UPG0IJQyndlnMwoi4mMlfUct5+8u5Ilj6CiGre1bkpEV11qhgJnk77y0c8D0ENQMomlDrnz6t/5iCmpCkcABAE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by PH7PR12MB8827.namprd12.prod.outlook.com (2603:10b6:510:26b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6678.26; Tue, 15 Aug
 2023 15:44:41 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::d267:7b8b:844f:8bcd]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::d267:7b8b:844f:8bcd%7]) with mapi id 15.20.6678.025; Tue, 15 Aug 2023
 15:44:41 +0000
Message-ID: <7e396697-afc8-51cc-07de-882499532b68@amd.com>
Date:   Tue, 15 Aug 2023 10:44:39 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 1/3] KVM: SEV: snapshot the GHCB before accessing it
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     pgonda@google.com, seanjc@google.com, theflow@google.com,
        vkuznets@redhat.com, stable@vger.kernel.org
References: <20230804173355.51753-1-pbonzini@redhat.com>
 <20230804173355.51753-2-pbonzini@redhat.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20230804173355.51753-2-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR13CA0045.namprd13.prod.outlook.com
 (2603:10b6:806:22::20) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|PH7PR12MB8827:EE_
X-MS-Office365-Filtering-Correlation-Id: 9cf3cf0a-f4f2-43a9-ac1e-08db9da68a5f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UoLEGxCwRuBWCWZzqW/XjSgqLqYrujIoyTW+3mF5YP65W0EnwIi+CPD/EkjCKtR5VhXoIDy682cxAJ4ykY9aC2NHjK0EDIULW0xFn/9BJc+VPm4TIBVnfniulMC7qwXEjjvyAP5D0yUR79aGKgUj9SBRKQbiaUYBIed8SYcSD7d/AMWY6uZ3+u8cRWAFUBaxgxfSW8u9bPKUy3/MZD2er0WXgdBGUpEHMDn0T5qO8prJFtWHm5z8GIA+8Nx4dIsENiSUu25ApbkhgsHDiSM01HYILQR3YTNhl975hR8qXraFZASU39LKCnMdxDBRuyl1XyJSr83UMepIEMV1fFxQhAdXpjRiLNRfFe1mGJylvXWnG91dNuLXUy3j6tciuFdOENVrxSG12Egs/M7sYG1X2k1YfPgi3QApdQLXiHwuuwE7PrhJRiICeyPh4iKBScj6TVgN24J4C6eoZRyRV73xPvZ+/iNW5pRTOHTDiRptgl+fQdM1iCjpxZ31K26WHope0gnoxzcs7/gsmdcquXwLxfqj+FD2GSJSq3nIzKrepiZ1OTBOgx4SRMFsdsr+sSUWpueyQIomEd4AGAd2S0PO0LluFaYY7FVDYYNgCy3cu17641F6aQEeP1fnZ93qP3dBZ/FacqCA3NCtUznsGWVf4g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(376002)(396003)(366004)(346002)(39860400002)(451199024)(1800799009)(186009)(36756003)(31686004)(6506007)(2906002)(26005)(53546011)(4326008)(316002)(2616005)(83380400001)(8936002)(8676002)(41300700001)(31696002)(478600001)(6486002)(6512007)(66556008)(5660300002)(66476007)(66946007)(86362001)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VXhRQ2JHTjZCVFV1WHZ4cWhvL3lkZjZ0VzYzTkx1MENWUVp2Z05MKys4Y3dr?=
 =?utf-8?B?MU1abVJDenh3VXJrTVJPM0tndDVkQjdTQ1ovT2lVbXRFaUR3U1JoSHhnQUhE?=
 =?utf-8?B?Skk4NVg3WDJOWmhUSCtqVzd6QjZ4cy9iOGEyeDBhQWFHZ2dlemFUQ1hJOUxu?=
 =?utf-8?B?b1VlR2RRRFJ4VkROTnpjajVQNXo1dWd1ZW8rVXl5Ui9Yak5qNmlkSFd4MFVl?=
 =?utf-8?B?YkFWK1JxVjRzellJZnoxYnJYZmF2czdVclI1eEtmeTRmRnczcGZ2TE1tTWhS?=
 =?utf-8?B?WUZLVUlWMWliMVB1M2hHRjg2Wk9QUDEvVzlVb2VXc29GVDR4VXdWemhEd25k?=
 =?utf-8?B?M3RGd2kweHhXUHhWNVF0c2NvSzVXelZrSDNFbVljdllCdWZoVjdFOU5ab0Jj?=
 =?utf-8?B?UUx0WG5NM1BKOTRFNmwzc2t6ZUxmb1kzaU0zM3VOdkdGTnJWYXpicEFpNkZq?=
 =?utf-8?B?UVBpMWZ2VDE1RjFPajZiMlhTeVZNdEE5TUdqTTNubmw2bnZCWThZNTNDSWNP?=
 =?utf-8?B?NG81Yjl0eFl1VXM0SXJYNTNKVE1wZTN4ZUV0Z1YrWTFrL2Jxa3RkVHA1NHl0?=
 =?utf-8?B?UmFDYlYzUWIxOTVjYUxFMEFKbTNTY25FSGRFdkNDaVNTVkVBeUlpRkhkTFRl?=
 =?utf-8?B?RVN4YXd0alZlU0FlVU5XMkptWHFVcVBaV0kram5xaFUxcE5TS1o0dm40YXYr?=
 =?utf-8?B?WjFRTUdCT1pWR0VubUVFOWtnQUJiRkJwTkRpQWJEQ1c1WmZLTENsb1JLUWtt?=
 =?utf-8?B?M0YxZE84bWhOT2NiMXh6NVBDbGF0engydU05a2lIbUl5bG1tU2dYU3pKVGgz?=
 =?utf-8?B?OC9HaFpPZzd2SkkvUERUOEpPYVlMdGFKREZ4clVnVzJvWStYNklPVVFmNmR0?=
 =?utf-8?B?SUZ4dGZOWm1ZcUcvNDRlcnAzZ3RDWFVhMjhjSGRzUDl2cS9uY2Q1cG9JUHJn?=
 =?utf-8?B?SE1GWVh2ZmphVmQrYTlDaVJHRmwrcjArQmphREVONHRCb1JreXNKUWk1SW5p?=
 =?utf-8?B?MFg2ZGo0QUFnZHVaNExLV3ZLYkQ4YmdpS1kwMGIyZTJaRFZSTTdXNVRJdC8w?=
 =?utf-8?B?L1VnOGZLd0ViakpveTRNYkU0enhJcy9LOFNOYnV4NVN0ejRETDBLRCtCcFlx?=
 =?utf-8?B?bCt6YzFwYUxoNzgvN0h0Y1QyUUQvR3dpOW51V05uTlpkVGk1ZGdzKzJzajNW?=
 =?utf-8?B?QTU5S05BVWF2WlBYOUpyT01wck1WKy9EZ3RqSWtaT1NqczJQdE5aRHVVdCsx?=
 =?utf-8?B?WjRTSzROWDZManpnSUN5SFgzdDV5R2liUm5YUUxFcEhsYitrWW5tZkhmcHdx?=
 =?utf-8?B?TWUySzZUZkNNRkNGL2ZNb1VycDg3aWVpUVZuMkx4N2R0eXBHN0RUcjh1OTNL?=
 =?utf-8?B?S0hGZ25rK2lpYkhpVWFoVmFqc3IrMDB2cU4xU0Zxb1ZpVnFkdUppdS9GZHIv?=
 =?utf-8?B?ZEhPNzRWNTRDelFOVzFNQ2dBRVFibkp0WVN2cEtab3dWUkY3aDgzVGpGYzMx?=
 =?utf-8?B?RWxxMEtkSG5PTjRRYm1TL2dndHhFN2M4UVN4UXNXaWFDUVR0NmJvWThXUmYv?=
 =?utf-8?B?bXVielNPZnFKOFkrVC9ORkJKQWZGNXg4dlpQY2UyRjhvNUV5OEZGSjJQOCtx?=
 =?utf-8?B?ZFQxSFp0N2lmbGJxWFVjQUhnTUlhMWI3R1NQZmNOdTNGM0NjRW1ubVJvbFpy?=
 =?utf-8?B?WUpDOVcxOFl3bng5dVFUMm1LbW1oSW43N1BNTW9zclBmTkJLVGFTWVBrSDE1?=
 =?utf-8?B?allCQzR1SlppM3NjYVh2dExvQWVGRDZiWXVTRDRmOXlGRWlqK1R0dEZDNVRa?=
 =?utf-8?B?eWF6YzY1SlRoTzI0cGlIUzNnTFdiS1NUMks5UytIYVBKdndHSG9TVTZ3WTIz?=
 =?utf-8?B?Q0VHV3RCSnlHMlRJUUVrYXVwZmNHZFVUYW1reTNCeERTT0dhWHppWnBZV3R1?=
 =?utf-8?B?VjlCR29OVnhrSzJ5TU1ZdThZWVFKdlkxQVAxMTg3UzdOWXhiLzYzajZiL0No?=
 =?utf-8?B?NlN2MXI5cDR1dVB6WG1VVmJMcjBFeG8rSkxRWDlqUllCQzNjMHdOdWRZQlc1?=
 =?utf-8?B?MVpxVzdLMGUxN2ZGSXlxeU1lY09aYTU1ME1lMVRuUkxHK1dUV1duc2djZFNi?=
 =?utf-8?Q?7dASjShCCPFkgz0dm+ZyqF2fd?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9cf3cf0a-f4f2-43a9-ac1e-08db9da68a5f
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2023 15:44:41.6458
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UqbqFAVF9SQ9mQOJiNheOzNXePPVrFheQGy/8R6GGitzOUcqonPMT87vE2B75yCjDCjdGJCw4c/Nd3wxsA1Qyg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8827
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/4/23 12:33, Paolo Bonzini wrote:
> Validation of the GHCB is susceptible to time-of-check/time-of-use vulnerabilities.
> To avoid them, we would like to always snapshot the fields that are read in
> sev_es_validate_vmgexit(), and not use the GHCB anymore after it returns.
> 
> This means:
> 
> - invoking sev_es_sync_from_ghcb() before any GHCB access, including before
>    sev_es_validate_vmgexit()
> 
> - snapshotting all fields including the valid bitmap and the sw_scratch field,
>    which are currently not caching anywhere.
> 
> The valid bitmap is the first thing to be copied out of the GHCB; then,
> further accesses will use the copy in svm->sev_es.
> 
> Fixes: 291bd20d5d88 ("KVM: SVM: Add initial support for a VMGEXIT VMEXIT")
> Cc: stable@vger.kernel.org
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>   arch/x86/kvm/svm/sev.c | 69 +++++++++++++++++++++---------------------
>   arch/x86/kvm/svm/svm.h | 26 ++++++++++++++++
>   2 files changed, 61 insertions(+), 34 deletions(-)
> 
