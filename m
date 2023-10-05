Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 381927BA011
	for <lists+kvm@lfdr.de>; Thu,  5 Oct 2023 16:33:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234613AbjJEOcy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Oct 2023 10:32:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235115AbjJEOba (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Oct 2023 10:31:30 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on20626.outbound.protection.outlook.com [IPv6:2a01:111:f400:7d00::626])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E72C65AA;
        Wed,  4 Oct 2023 23:19:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yv/kNufZmXcZxTGxRgZqNtctQV8VUPcVdEoY68FGu38JUA6BunUPcFTaaFFzBDhTctDpoS0J6byl/ymRN3TtrjyA71mCnROEP0LGvrCScz937jsq/g3+AIUTwcP4LpPo9UymGyTXdv837j4qP05fMC4kb8+uxB0TwDydb+cvpS4thDZtH1IrXCXV54vjDvhr8+runXsZw1HeACEcfT9l3G6XeB2CBqGKpDxSSV0YFftI/5BBOhRpYqv+FZW1FcgFhG73OdtkVvCSlGe+kKSd0NmGuJL3Lm290iBwND24aBDonL/tEva9UN8eMBMdZFnqWvJxN29WiyM5mwcCH+LZQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HLEQAnAtybvz4qYKw9pECyyfbHtkWTR7swM9+unnb8w=;
 b=VGFWtWbgE4Ei8POy1/17zNWjfnHrMypEktUnT0587W77c6/T6PrjiyiEG/h1iXHddIxFlW85zSLzIjqyKyQkZgTHlDrmRIaaDdypVdc03n5uZHjiDzdxtvuraUPcR+GcfYSbwOJALlh6EapNW4hITO9EC2RfO7245Nf7xhh7tyHlqvJ1uRa2OhnZKpMG7dnku1o3fVpJjcWDdviflUFN751pTZ/+ClSaDA6S6sg3yaGIhiDfiR8CAWgfJMfIoTuMBWXW964hF8TxoVR0P0BbLunbguQ59+qSxWjz2ZUnKAgT6TN2eqWCiN1qg2/+G6b5cUrBMhL4Pi7L1G7ForO14w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HLEQAnAtybvz4qYKw9pECyyfbHtkWTR7swM9+unnb8w=;
 b=W4MevTZ6YtluTwu+3auGo2SsmSLEaIEaTYJQtfgJTIfixytiH6jAuVZsaZ0fFqDqNxPBIisINJu12Dj7d5aZoYj6IxCCjRwjmJHk7BzVx8V6mQtEJ4BPKYEpE3NApWAAJA8u+HMCSjtVxQ/U6xE7SJ5h55BLoA5s38Nuh60Bk/C6vz6weAYiumimpZ+7qVdJ7oym4wNuNyPf0c1+FRivk/8qfnoEf2NqR8qyasUdI4qhUNBygZX3m5yfmLIJwfEj21OLTdpTuvKxDXVz8Tixcr1GmX/DHeLzWE9oYIJFWnvVYM21zn0cThHYzUROxTd+IT6rSwj37JNKe4Ygqy5tBA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from PA4PR04MB7790.eurprd04.prod.outlook.com (2603:10a6:102:cc::8)
 by DUZPR04MB9728.eurprd04.prod.outlook.com (2603:10a6:10:4e3::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.26; Thu, 5 Oct
 2023 06:19:03 +0000
Received: from PA4PR04MB7790.eurprd04.prod.outlook.com
 ([fe80::edd3:f00:3088:6e61]) by PA4PR04MB7790.eurprd04.prod.outlook.com
 ([fe80::edd3:f00:3088:6e61%4]) with mapi id 15.20.6838.033; Thu, 5 Oct 2023
 06:19:03 +0000
Message-ID: <9b5ddb4e-12f1-4058-bcce-119d6ac4817c@suse.com>
Date:   Thu, 5 Oct 2023 09:18:56 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 00/37] x86: enable FRED for x86-64
To:     Xin Li <xin3.li@intel.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-edac@vger.kernel.org,
        linux-hyperv@vger.kernel.org, kvm@vger.kernel.org,
        xen-devel@lists.xenproject.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        luto@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        peterz@infradead.org, jgross@suse.com, ravi.v.shankar@intel.com,
        mhiramat@kernel.org, andrew.cooper3@citrix.com,
        jiangshanlai@gmail.com
References: <20231003062458.23552-1-xin3.li@intel.com>
Content-Language: en-US
From:   Nikolay Borisov <nik.borisov@suse.com>
In-Reply-To: <20231003062458.23552-1-xin3.li@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: VI1PR0102CA0028.eurprd01.prod.exchangelabs.com
 (2603:10a6:802::41) To PA4PR04MB7790.eurprd04.prod.outlook.com
 (2603:10a6:102:cc::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PA4PR04MB7790:EE_|DUZPR04MB9728:EE_
X-MS-Office365-Filtering-Correlation-Id: 0fb8d531-04d1-43b5-d333-08dbc56af851
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TvB56ZyTvgf3qztSKR5fDlSPBaloYgo5RI0rfaw+srmCP8hiAlkGG82acncIGIA2Bw77GHMulFpENlNqV5QhkQ+k1Jb2e1WOXJm0X3KiF2dIgpqvX22/GnISdp0/HWvj6dBU0rKcAuAggiPwMtEw5ENwfR/i0vFuZYv4EkYyy/Bnqo5X37wC1Dvaa/J2amlwlLLpC9zZGpTXteyW/1l/rTyFgu+HRxrxjNWWtHZ0pfDgAEIlg44hdFw3PN0U+KwXHJuuAL9r2hClfBFwHe9+F6n5K4kCH4FwcKTzkGyJkjjOIBZmzPkwq5reiydc1rnPPlReS1Cs9D/zYnaOkqvrWJfLgtMO/DXS6T3Nu87JjZG0hOTyw9qG5tN1PaY/wdPixBMX2zFFb9IwmUVPtMqCQ9IPerWVBKpK3L9t/vPbnc20aVo6nZlHOn1AoHWPY8lQgD12oid3gkb4juX6WsnIblJP/fVnF/5tr4pdu0SyJNGnq51ZkpUJIwBRIJOQ9QGnTRUPVLiC4z6np4G5JwZGN48/XJ7gDll7R7bUyZJIEwrDHwPgbkNBALLIRKIQ2a1AF2FZk0ie36LX1KSgXGr1L+jmqTb4MJWSPftayfBR2rlSDF/qZ5VXyNOBWC6p9g9BZJfWJPnna/ALb14dN/bD3Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA4PR04MB7790.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(346002)(396003)(39860400002)(366004)(376002)(230922051799003)(451199024)(64100799003)(186009)(1800799009)(4744005)(7416002)(2906002)(4326008)(5660300002)(8936002)(8676002)(31686004)(41300700001)(316002)(66946007)(31696002)(66476007)(38100700002)(66556008)(6512007)(478600001)(86362001)(6486002)(6666004)(2616005)(36756003)(6506007)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eDJrWFNINWVqY2xhSVhPSGpRZlczSjdUdTZFclI0ZlYwZ3VUcWdGcmQ3RTIw?=
 =?utf-8?B?azM4OSsxVXlyZnZkTDZBMktkWjVaQUwxZFY3dlI5dmFOSHU3RzFQbURYZCt1?=
 =?utf-8?B?WTBJNno4QmtpQ3BDbmdmandHbmdSZFpvNVN4eWxTVEdud0k4dnpHcVJER1dv?=
 =?utf-8?B?aW5jZU1PNWNjSmFtdktweW50dktkT1Zna2dyem1pYUV6c291aGVBYmJQVUNX?=
 =?utf-8?B?bm9FeE92THF1WTF1aWFENWJTb0lSYStpOG5JVmcramNKZHFJUkc3VzVnT0Ni?=
 =?utf-8?B?K3Bpd3ovelptOXZUTmM3RDFXanZSbDIvREtpRXVFRnRkcU9HZitZK0JJQ2hz?=
 =?utf-8?B?VjQ4cFgvbUVROWhZZWVZNEFqNnpMWjYxUTdWMUdnbDJFU3p4VVVweTg2b3pE?=
 =?utf-8?B?NWdmemNwWkhtMGlBQkxYeDlXeWdLK1pCVmJhaHg1ZlVDNmx2eEpkMHZlWjRu?=
 =?utf-8?B?cC9kZjBTcHRvT2VWSFRBTm9xcE5POW9HMEJLTnRncEkrWnBaTGkwWGE2R3VY?=
 =?utf-8?B?clc2N2ZibEpmL0dXcWoyR1hWb3k3aEkxOU92eDhjY3pIbnpkUWgwTVlGa2Vl?=
 =?utf-8?B?QlBreEhIVDFKa0l3UFBUZkVnK2tmVitaRXN6eGprVHlOeDYvWVhqYjVvaXZ4?=
 =?utf-8?B?a2NqRFJxUzZiaTU0ZUdtZjk0RnJJR1hEZEtmMGl5Z3NuYjBRNXdQeUhkMUdw?=
 =?utf-8?B?aCt2eHNYam51RmZqRTBDTlZnSDhRYU1MVVVrT3BFVWJvNFRWelduREVWRE0z?=
 =?utf-8?B?ckNGZGVMTEpLUWFxaU5qeE1aekQ4aWlXQ25IR3hrRjZzVHVPNkVxV1o5bzVM?=
 =?utf-8?B?a2tkb2EycDhXQ0FnYUsxOHBOYWxXUlRoS0F1NWRhSi9LS1VnNE1wa1NkYllo?=
 =?utf-8?B?VHcvdHltVCtYY0NiL3l5a2pHNjI2d3BsYW5GSlhnQWJ2c0dFNzR1clJtUXh5?=
 =?utf-8?B?RUlhVDJOMW9JbGtnOUg3YitqRFkzZ1BiRFhxZVRmbmZwSXRqYTErdzQxcEdR?=
 =?utf-8?B?UUN3amU1ZzMxY3Z0VmMzWEN1M3lzWURiY0FCNjd2cWNTZENTNHRMeXFscjJ6?=
 =?utf-8?B?eTNybW00eE5pY0duOTJJaEtUUTBzZGlXZUJyUUVaQXl1dTErNXg5RlhZOEFH?=
 =?utf-8?B?R1o1U3U4R0U4WTN0TlhIckp3dk9VVkh5bTRNa2J6NlZvVXYyN2x0djRUVVlo?=
 =?utf-8?B?VFBjQm9QRDBhZlVFU0krUThtSXVobndJUDlIWnJDcGFFRm1jT2NtTmloa3VK?=
 =?utf-8?B?YXpkRUZvNEI5aE1RNkJESzc0WEEwbjJzQXJKTU11cUdOdFROaGt4VmRwazBr?=
 =?utf-8?B?OEtGZ0J6dmtSYUVSdVFuZnJPNDRaL3ArckkvRFhCVkFmMnQ2eGtaQlNNLzVI?=
 =?utf-8?B?aVNHN2poR2tBeGZGZnpWQWZ0Vm01UnV5YXc2ZC9mYWkvS1Nad3NJRmlEMUpI?=
 =?utf-8?B?RmdqSGwweDdyTC94UGM5MEVxUUw4elRDTjIvaGMrUnMyT2VtTzNVdTJkdW82?=
 =?utf-8?B?MWZQL09vR0FRSE5HRHZXdTVNWG9lWFZUblk1ZkthN2dsNzJ3N0ZWRndqUmZt?=
 =?utf-8?B?WjA3Rkl2MFRuSEdVNlFEU0U0RUZodlJwM2R1VGVnL25PZUFDcTNPek1heXY1?=
 =?utf-8?B?a09UclVHTjl6SFY4ZHJTTnBMVlo5aVEvWHVNOU1SUFcwdkNoUUJWQTB6U3Fl?=
 =?utf-8?B?WmF3cXYvQVBqQWptQ0hqWksrdU1zS1ZMemxNUmo5U1YraFNXZUxVMmFVUElI?=
 =?utf-8?B?TVNKdzJ2QnduWm9hUE9CNU1UMHc2ZFhaTDdSeWJvRVZwQ2tEVnlDYnVTaHRp?=
 =?utf-8?B?VzVLaXpoenlaUXN2V0hwSUoxOWl1aitaVlQwN2w4WUVpY3Zwc0JsNXdMZEZY?=
 =?utf-8?B?dUkrbVFsSktKem9oNTRkQk9xU0pxdVZpdTJ6SHgvSkNLRTVqR3hmUUoxYWgw?=
 =?utf-8?B?MW8wNk1FNkgxMkFHdkNTb3pVRHRkcXRzR013VWErTitRSU81VHZaZmZrN1pp?=
 =?utf-8?B?L0hBZmg5amhYei9DUTZidWxhOEVZeDRDRVFQUzkzcUw5LzV4cy9QWkVaUFB3?=
 =?utf-8?B?bXlSSzYyRVROa1NxVTZuMGlZZUdIcTRjbXNuTFNVV1dOVHdsL3NKTjNHZ0NH?=
 =?utf-8?B?YURKaVVpYlJlOFM2TlZaaHdXMzRuQXFGekRhbGh4QW42aW85UXpRMVIxK095?=
 =?utf-8?Q?0NgYcp/tjTFnH8wgk1jSYgXnGMKfIocAe2efW+ncX81R?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0fb8d531-04d1-43b5-d333-08dbc56af851
X-MS-Exchange-CrossTenant-AuthSource: PA4PR04MB7790.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2023 06:19:03.4302
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NXcrgj4Wqi52/Gbs4JfTUBil1/wtGIPsCTvlqrdhrAqMjBDjJW1xND9HCJ9NS/CFpUzXhU633QGmKjtzzxs3rg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DUZPR04MB9728
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3.10.23 г. 9:24 ч., Xin Li wrote:
> This patch set enables the Intel flexible return and event delivery
> (FRED) architecture for x86-64.
> 


Which tree is this based on now? I tried running 'b4 diff' but it 
complains it can't find some context around arch/x86/kernel/cpu/common.c 
. I have the tip tree updated.


> 
