Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25B6A4C281B
	for <lists+kvm@lfdr.de>; Thu, 24 Feb 2022 10:33:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232746AbiBXJdK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Feb 2022 04:33:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232185AbiBXJdI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Feb 2022 04:33:08 -0500
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.111.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFA5520A952
        for <kvm@vger.kernel.org>; Thu, 24 Feb 2022 01:32:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1645695157;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Y4O/HdGpGjOiTVfdh24aOScfl1geCjzMNOvwE4Y+kKw=;
        b=KZ9YMPKzpJzQJITRMrBIhy84r1fI2PuOwd9tBe+s9f96bBVwNTGrp6fMJ8oFpXd3FkAWhn
        19frdOyBlBF22RjWfZ1MBgyMEBjZKIhyuZAMnB1kEhutuVwhMSylTYx9nDnLvZLq00bEsp
        gwmpMMLbNV0XdXa7cLNZP3B28FQqepE=
Received: from EUR03-AM5-obe.outbound.protection.outlook.com
 (mail-am5eur03lp2053.outbound.protection.outlook.com [104.47.8.53]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-36-ySfGYEkaM5y9OUJ62JJzjw-1; Thu, 24 Feb 2022 10:32:35 +0100
X-MC-Unique: ySfGYEkaM5y9OUJ62JJzjw-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KLPTvASo6sqN5dgZ4mS2wwXtyoP7cy8VLX9yxLUVaf5WgKw6YDPPFwZOsGQ6aW7Piso0T5a/6Xvfohxmo5rJ0YGAIWXQY9MgEJnZTnMTcJHeKRPG8P1yLWXFCVrk9wA2f2xKzixOWRng9whz+vvcH4zb4+U4n9yImMQ0kPfy31dnddN6hVUwt2nkGlnCoX/SWg28DRtjbu/TzuY73DdXSng79nL7fHhrh8RqgPWsFsLYRuZ/kto4A9CsbaMX6Cp7mWa18zin5NYgU7E2hQxw+ejfdXotgbGbv/ZZ0z4/a8slqtYu5qLPqmMU7uGb+OuUbPdflf3fuQZYF4Cpie60gA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y4O/HdGpGjOiTVfdh24aOScfl1geCjzMNOvwE4Y+kKw=;
 b=CnHymAUiTQBQv/gZ2DIts6e8aEScQ1LV4KjGPOj1wq6xcJuL2w4flnXTMRgZgYFXkftMOInsFUY6dOAP9gEerjd4INsn0MQlwqjUfMIIXoVYR/4kjaz4fu5INHYDM7M3bbBLq3lCxXhWIula/fUxs5bZiXwee8HLwkTX+fot7c/eYUtyO7fqU7mbpjRwgelSbsq7n8s6YePmZQ7UHwfui/q8b4zwFYvvmrQRW2PLtBVTqpxbRwkyV90N1acDtb5fKSRn8yHu2B1RwPWhmSXi4PCssdzXDSUHNwIjNfVV91+h8vY/xUhT0ZZlqMYYK0EuO4AwxLOxs6VORgXkHfbMAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from AM0PR04MB5650.eurprd04.prod.outlook.com (2603:10a6:208:128::18)
 by AM6PR04MB4566.eurprd04.prod.outlook.com (2603:10a6:20b:1b::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.19; Thu, 24 Feb
 2022 09:32:34 +0000
Received: from AM0PR04MB5650.eurprd04.prod.outlook.com
 ([fe80::59d3:d855:d7ba:16b6]) by AM0PR04MB5650.eurprd04.prod.outlook.com
 ([fe80::59d3:d855:d7ba:16b6%5]) with mapi id 15.20.5017.024; Thu, 24 Feb 2022
 09:32:34 +0000
Subject: Re: [kvm-unit-tests PATCH v2 05/10] x86: AMD SEV-ES: Prepare for #VC
 processing
To:     Marc Orr <marcorr@google.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Zixuan Wang <zxwang42@gmail.com>,
        Erdem Aktas <erdemaktas@google.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        Joerg Roedel <jroedel@suse.de>, bp@suse.de
References: <20220209164420.8894-1-varad.gautam@suse.com>
 <20220209164420.8894-6-varad.gautam@suse.com>
 <CAA03e5G9Ler28JsLWU914Hg5w8cNEaQxoF_=K185vvTKo0MLcg@mail.gmail.com>
From:   Varad Gautam <varad.gautam@suse.com>
Message-ID: <e6ae2f8e-f2d8-670e-6a22-337ba4d67f48@suse.com>
Date:   Thu, 24 Feb 2022 10:32:37 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <CAA03e5G9Ler28JsLWU914Hg5w8cNEaQxoF_=K185vvTKo0MLcg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM6P192CA0064.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:209:82::41) To AM0PR04MB5650.eurprd04.prod.outlook.com
 (2603:10a6:208:128::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6548c954-44c7-4d43-a7a0-08d9f77896aa
X-MS-TrafficTypeDiagnostic: AM6PR04MB4566:EE_
X-Microsoft-Antispam-PRVS: <AM6PR04MB45667E8D227700DA37120407E03D9@AM6PR04MB4566.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DdDtCOyg9gEpqpswWrtosOUYoU9ZNFV5RSjDKLsFusuAFxYzu3oHxPMW3JYuzqFOTX2bKBQwB3iEWt72+dlaha2WDs9Mz181z7APR3cwR3nEtmaTJQMCe1RqANOz52PpsiQXKYq/WqS/dOkmsnrc7/pI4Cm7zjboNgnIquRGw1YJaP2EE6QwZnRwj5iFdJlBLN2jdN5sfPrm+TEz9yPDsG+8k9vsKz+gF5H0YApO/DoYxn9V7f0SKluIeMoynmTDafspfOrTBWHWijHXFVejvo575EsQeq6SCPXwz17R4EeEfB70xIeiYmnN87LgMC/9rRcRvAfUpjCDRVm1Fxn26lZRj0PmiJD0u8K+SRg3gEKxA4KVZseyE2a3e28z82vY2/Ivcgod2Kd5mDUxeSgjpP3nm5xAZ+r73cmP6maJ/yDW+U36lic0rN5gZf12o39aBzaFeoGtMsDKV05C9z/BZNhANzlqt+y+OBHU4GQK550jIHAz8jdcYSP6j+VDtFAuy02p1knCzVi27YS/trIJOrOAk97B3SVhjOf6xDawXtup7RXBcFugiLjhW5YV82utMGfpSyBnhjoXNJrcl3SPX4X+gljns91AEkDpFzhkspqgi/VxvYppOBwcIfM2PgWNEGDbqkFo7zM5yLz+gspx1332HfCrPCjHW16EXidCY2gLvwtnMydoNkVkNCT5yN3BRJG0SkP3bhHMPEisx5nGTSX5Qykm5uVsdmtCI65K3jo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5650.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(31686004)(66556008)(38100700002)(66476007)(316002)(66946007)(4326008)(6486002)(8676002)(6916009)(54906003)(36756003)(6512007)(2906002)(8936002)(5660300002)(86362001)(31696002)(508600001)(6506007)(2616005)(7416002)(186003)(26005)(44832011)(53546011)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Nk94MGRaTSt1bHlkVHRDQi9iczlPYzVVY085UHlsTngwZzdiQUdhbHF3Unhq?=
 =?utf-8?B?aGFRN0RxTWVRZEdNWWVEOHV6YzhMRW9JZmxWQkZ2cEhKZ3FRZVo2S0F1NTZJ?=
 =?utf-8?B?ZnhOVDVuRmhEMnBiR2VBVCs5U1prbUYxRVRDQSs1OWdZVXZhZVhGZnhNQ0tG?=
 =?utf-8?B?U1didk1tVEo2b2d0VWN3VWNUS1IyV2xUUXAwMmpyVHVYdXgyelFkckRkd0NH?=
 =?utf-8?B?R0JDcHJrb1FtbUlWcGVGS1VUSTBwUC9LaTVIeFZzMHJ0U1pldVVvMGlRWkIx?=
 =?utf-8?B?TWtRZlptb0RyZEVWS25GV3JkcXB2NmJXYjNMdFpHUWNaeC9MM0t3bFJ4aC9J?=
 =?utf-8?B?MEFoVjh1YmhabFRmS3dIS2tTa28xS1krdS9WQ3pBbElrRTBtdUZPOUtySExp?=
 =?utf-8?B?ZUhoOWFVWUN4SlFhNFhtQVMzVWx3c04zRGxZMkNkcDNFdGxsZkhMYzFtVVZT?=
 =?utf-8?B?cVhoWUVmclhUd1IvMmoxdGQ2NUlSbmlGelZwOVpBemRkUmgvd2pIaGRzQ20z?=
 =?utf-8?B?MkpaN1NPNDBRQXVzZ2JTNTNZOTJ1WlJOYjM0YnJjMWFHYUpqNHFSL015dThw?=
 =?utf-8?B?THgxQUsvM1d1U1NIVEprQXJxblI5MGwrMjRNU05VZ2tqQi82QjVlZHg5RTNN?=
 =?utf-8?B?cmFqMDFXMEhzRnQ4QUlwWXpmcy9ibFBaS1VWNUVnU3AyTWxCcDBBRHpldVc5?=
 =?utf-8?B?Yk1HdWtlOW9xSy9NUkh4UzdCb1IwUFFweW9CVlQvL05KcFN0dnlreVhLRTRw?=
 =?utf-8?B?M2czamR0VGQ2UXd4ZUY2bkgyUGJrdnl2cjZJcGhIZGlsc2tPODZsOGZMWDVB?=
 =?utf-8?B?WkZIblIzQnBESmp0Y1cxVUxtOTlvOXNQdTJGelNBeXBVdk9Sd3dUWXN5QjY2?=
 =?utf-8?B?dUFXMTBrZzI5YWQzRXVLKzBFOXlwUEs4Z3ZYb3ZDVFFYZVZKc1JHZXN1VzA1?=
 =?utf-8?B?YkRMRmVSUCtPcnRZd0J1USsyOElWWGVHNTlqdlAwSHREb1hMSVM2dS9OYk9u?=
 =?utf-8?B?cXMzNitzcEJWYU5zdjFtZE1HSy80K0JZd0J4WDZKWlkwSXJBaGR6ay8zRHJP?=
 =?utf-8?B?aFByejVQUCs2UzN6OXVNcWNVS082eXQ1V2NDOFl3c09LQnhjOGJJdGJFY0hH?=
 =?utf-8?B?dkRLbm9rZC9PbDd4VGR5a2FWTytBQ2J2RkczZ0JtUUxSc3c2a1pic3VlREtz?=
 =?utf-8?B?SFRiWnNnWFhWZWRkTi9BZHArNzZMMHJtdW9XR0Foa2dYQW1mWlVOT2Exekxi?=
 =?utf-8?B?alhhd2VhV1ZoM1pYMVJFY1VQeUU1WXJpeFlmL0d1cS96NFBHTHAwM09hY2V6?=
 =?utf-8?B?RlM5SUt6MkhCMmtwZ1NHb3R2TlB1NStrQjNPaXRoSENpTERCOEcvb25KMmhz?=
 =?utf-8?B?amNBYTNtR1F0UUdsSU8zRzNSaUVQcGRHdGVNTWdHL1R0SlZ3Z1pZR29oZmVi?=
 =?utf-8?B?SzZuUUVsbnJGMlNDUzBqVUhiRmJzeGtLakEzS1l3Vy9NbkQ4TGpiaGkwL2ow?=
 =?utf-8?B?VzJzU1ZuK2sxYVpCL2diVGMvak8yVCtKWmRNR0hEUTg2ZklwV2JsTDMwQU1q?=
 =?utf-8?B?TkpmQ1FpMm1TNUJKMnlmWWEwNG52RXlnS0RpRXlCVE5kbFErMCt1UzQzNXN2?=
 =?utf-8?B?a0F5ZjVyQi9hREw0d0RicmtjY3BOdmRaRmVicjVSWDZEOWpTSHA2TWR6Rzgv?=
 =?utf-8?B?TW5MNVN2eDlPak9ueWFLV2tIVmNjNktVTWh3T2FwNW5DN2JIelhBRnBiY0Yr?=
 =?utf-8?B?dWR4Q0tmRnNMUGI3amx2dkNvdTlBd3BoZWpFb01pNldGSno1alRsaGpkcFhu?=
 =?utf-8?B?SFNYMlJBQ29OMzJBZVByeVhrdXFaQWxPY1d3Ujl3UWg4Q0JkM1l3YXR2RTc0?=
 =?utf-8?B?UGFINnM1bmQ5TnEvN3QrQ1IrQnV3bmFOYWVnSzFtdHhxVHFvTEFwTG54Uzg3?=
 =?utf-8?B?OW5sdGxDeHdVei83anNkTzZ1WmRYVUJZV2UwKy9yQTFWcmNvUmF1clBJeTRn?=
 =?utf-8?B?TCtDVS9MRG9JOVJIRzFhM0VWRWRPMjZMSzEvMGtUcnpHYTZaVkFCWHoxbU9L?=
 =?utf-8?B?NjVDaW5va0VaN2ZuSEZoRTJZQ29jWUxFajVVckxnSUFqL3hQMnFGd3JxTUF5?=
 =?utf-8?B?Q3dvL2xwT3FnekoweksxelgwQ2tWOWY0QjFmV0NDNGwrUWhxUWJKUUloYjhE?=
 =?utf-8?Q?UMqKA0s5vz0NoCn0ap2awb4=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6548c954-44c7-4d43-a7a0-08d9f77896aa
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5650.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 09:32:34.6475
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bP8paWOzHBNVpgCygMD9zn3suNoXefTxBtKILQXOYImG9HSCK7u5Ah918wKctf7cz5827AuRCgUb+InFik1h3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB4566
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/12/22 9:54 PM, Marc Orr wrote:
> On Wed, Feb 9, 2022 at 8:44 AM Varad Gautam <varad.gautam@suse.com> wrote:
>>
>> Lay the groundwork for processing #VC exceptions in the handler.
>> This includes clearing the GHCB, decoding the insn that triggered
>> this #VC, and continuing execution after the exception has been
>> processed.
> 
> This description does not mention that this code is copied from Linux.
> Should we have a comment in this patch description, similar to the
> other patches?
> 
> Also, in general, I wonder if we need to mention where this code came
> from in a comment header at the top of the file.
> 
>>
>> Signed-off-by: Varad Gautam <varad.gautam@suse.com>
>> ---
>>  lib/x86/amd_sev_vc.c | 78 ++++++++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 78 insertions(+)
>>
>> diff --git a/lib/x86/amd_sev_vc.c b/lib/x86/amd_sev_vc.c
>> index 8226121..142f2cd 100644
>> --- a/lib/x86/amd_sev_vc.c
>> +++ b/lib/x86/amd_sev_vc.c
>> @@ -1,14 +1,92 @@
>>  /* SPDX-License-Identifier: GPL-2.0 */
>>
>>  #include "amd_sev.h"
>> +#include "svm.h"
>>
>>  extern phys_addr_t ghcb_addr;
>>
>> +static void vc_ghcb_invalidate(struct ghcb *ghcb)
>> +{
>> +       ghcb->save.sw_exit_code = 0;
>> +       memset(ghcb->save.valid_bitmap, 0, sizeof(ghcb->save.valid_bitmap));
>> +}
>> +
>> +static bool vc_decoding_needed(unsigned long exit_code)
>> +{
>> +       /* Exceptions don't require to decode the instruction */
>> +       return !(exit_code >= SVM_EXIT_EXCP_BASE &&
>> +                exit_code <= SVM_EXIT_LAST_EXCP);
>> +}
>> +
>> +static enum es_result vc_decode_insn(struct es_em_ctxt *ctxt)
>> +{
>> +       unsigned char buffer[MAX_INSN_SIZE];
>> +       int ret;
>> +
>> +       memcpy(buffer, (unsigned char *)ctxt->regs->rip, MAX_INSN_SIZE);
>> +
>> +       ret = insn_decode(&ctxt->insn, buffer, MAX_INSN_SIZE, INSN_MODE_64);
>> +       if (ret < 0)
>> +               return ES_DECODE_FAILED;
>> +       else
>> +               return ES_OK;
>> +}
>> +
>> +static enum es_result vc_init_em_ctxt(struct es_em_ctxt *ctxt,
>> +                                     struct ex_regs *regs,
>> +                                     unsigned long exit_code)
>> +{
>> +       enum es_result ret = ES_OK;
>> +
>> +       memset(ctxt, 0, sizeof(*ctxt));
>> +       ctxt->regs = regs;
>> +
>> +       if (vc_decoding_needed(exit_code))
>> +               ret = vc_decode_insn(ctxt);
>> +
>> +       return ret;
>> +}
>> +
>> +static void vc_finish_insn(struct es_em_ctxt *ctxt)
>> +{
>> +       ctxt->regs->rip += ctxt->insn.length;
>> +}
>> +
>> +static enum es_result vc_handle_exitcode(struct es_em_ctxt *ctxt,
>> +                                        struct ghcb *ghcb,
>> +                                        unsigned long exit_code)
>> +{
>> +       enum es_result result;
>> +
>> +       switch (exit_code) {
>> +       default:
>> +               /*
>> +                * Unexpected #VC exception
>> +                */
>> +               result = ES_UNSUPPORTED;
>> +       }
>> +
>> +       return result;
>> +}
>> +
>>  void handle_sev_es_vc(struct ex_regs *regs)
>>  {
>>         struct ghcb *ghcb = (struct ghcb *) ghcb_addr;
>> +       unsigned long exit_code = regs->error_code;
>> +       struct es_em_ctxt ctxt;
>> +       enum es_result result;
>> +
>>         if (!ghcb) {
>>                 /* TODO: kill guest */
>>                 return;
>>         }
>> +
>> +       vc_ghcb_invalidate(ghcb);
>> +       result = vc_init_em_ctxt(&ctxt, regs, exit_code);
>> +       if (result == ES_OK)
>> +               result = vc_handle_exitcode(&ctxt, ghcb, exit_code);
>> +       if (result == ES_OK)
>> +               vc_finish_insn(&ctxt);
> 
> Should we print an error if the result is not `ES_OK`, like the
> function `vc_raw_handle_exception()` does in Linux? Otherwise, this
> silent failure is going to be very confusing to whoever runs into it.
> 

Changed in v3.

>> +
>> +       return;
>>  }
>> --
>> 2.32.0
>>
> 

