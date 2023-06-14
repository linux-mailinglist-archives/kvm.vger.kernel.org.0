Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6ACA72FEB3
	for <lists+kvm@lfdr.de>; Wed, 14 Jun 2023 14:32:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244578AbjFNMcg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Jun 2023 08:32:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234268AbjFNMcd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Jun 2023 08:32:33 -0400
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-ve1eur01on2057.outbound.protection.outlook.com [40.107.14.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83CB0211D;
        Wed, 14 Jun 2023 05:32:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mEoumP3pY1Z3tBI48F42NqDOroeclto7ctNV5I5Yw129RzXMHgfdCcqxX/KczPBqslbKTPhNZF423GkKtR6QOXkL9/4mbGVBvvo3pEXfqttlLBya+6vhyA2yV+hIvFOBAiOmDe0IZOVWOQ+mkt/bP/LLjflmfOvgZ7IB/0WCcGBUTXAXMRsv1mQ32VHONAWGhwkfwpQWW9mABY2iyr7hc27hZnJUPR1ODgjrZhI/0cSs8bTNQsCg7f9WrHllFbotP504EkzPBZXnWMAxNzQpy/A/7w8bub+Lrh3cSgLJrjhGvJbSzIZ9QMOOD97wZgUDbglZkANPMPKc5YOAdZoMkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VW7ZiPBIo7fsIs0wqlLuapg3hM8369LWebT4OhJUTr4=;
 b=YBFJK4jaX4hsjVFiLQlINnvno5lR351AAZHjcuRRLZC3QFF5QBKWcBWuxsBSxC0aFSFLrW4lapNFgKLySEWqt5Y1h3V8D1a22va4Gg1v9snibPVOvGa7igkG/adhsMLAEEpjrf7hWF6mlKFjfRL2XVhF/FtMVjvoFBkT7B3m0fGXrQRzSXirNR2GH/RmYO+H7nHb4Vy3GGcxkNTSlorFgP26yuSJv0QBwv4Wz02PbUnnU/OCV50RjbHMot40UMNNBXqLes0YCneBIbopL5fyvATTseAs8lnSp0JitDhrqIXhHtsmgmbGb93xNUqF2VArKYD3u6EcfCFMkFegfg4JXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VW7ZiPBIo7fsIs0wqlLuapg3hM8369LWebT4OhJUTr4=;
 b=FrDYAgulI7FLC7gJCqVJO7PLpsTKwO97x5mhXrbP4n2u7zkqcjUrkFNRL5FmiEHD757DFETWiTEdFH2cQHHjpn6tduS0FR1BE/Nab5+ED4JBwjcpMgr9pMW1q9n6yo8/KY9+vqxtZ6C8moxtrV/tWUZme9NXHXiWLdqoOPKktf19TKQT0ZvOlUOdvKY+7TBbOBK16ahU1ofunoMKDQvWAhKlxGDkBXaWWaKwidFsykwSMkSgEGBJhqwxuENUr5xtq2XQliIQgwumfCzFu3dg1C/O37z5j26F1Aov0AzUnlTmO7ckXKIoveJ7dstMmCaIouasmx7Se/UMNiPLE2TKgQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from PA4PR04MB7790.eurprd04.prod.outlook.com (2603:10a6:102:cc::8)
 by AM9PR04MB8939.eurprd04.prod.outlook.com (2603:10a6:20b:40a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Wed, 14 Jun
 2023 12:31:41 +0000
Received: from PA4PR04MB7790.eurprd04.prod.outlook.com
 ([fe80::66a2:8913:a22a:be8d]) by PA4PR04MB7790.eurprd04.prod.outlook.com
 ([fe80::66a2:8913:a22a:be8d%4]) with mapi id 15.20.6477.028; Wed, 14 Jun 2023
 12:31:40 +0000
Message-ID: <cff2c398-6d2b-8202-6d8f-88b6518bb49b@suse.com>
Date:   Wed, 14 Jun 2023 15:31:36 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v11 11/20] x86/virt/tdx: Fill out TDMRs to cover all TDX
 memory regions
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, dave.hansen@intel.com,
        kirill.shutemov@linux.intel.com, tony.luck@intel.com,
        peterz@infradead.org, tglx@linutronix.de, seanjc@google.com,
        pbonzini@redhat.com, david@redhat.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, ying.huang@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, bagasdotme@gmail.com,
        sagis@google.com, imammedo@redhat.com
References: <cover.1685887183.git.kai.huang@intel.com>
 <927ec9871721d2a50f1aba7d1cf7c3be50e4f49b.1685887183.git.kai.huang@intel.com>
From:   Nikolay Borisov <nik.borisov@suse.com>
In-Reply-To: <927ec9871721d2a50f1aba7d1cf7c3be50e4f49b.1685887183.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: ZR2P278CA0079.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:65::18) To PA4PR04MB7790.eurprd04.prod.outlook.com
 (2603:10a6:102:cc::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PA4PR04MB7790:EE_|AM9PR04MB8939:EE_
X-MS-Office365-Filtering-Correlation-Id: 36bc7ea7-695f-41c3-203e-08db6cd34db4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LgKbSG5jytKecxF+OvemP5IIMw7Fo2FlRdP33dohfkYuvdISe9YoWpnAGvD+AIZOZSJo2sqEDOZ/eGjWXOtKtXYTs0FbBtfddSniJy5oujUWNe2O3y8xCHadvzp6FdsItQIEk8WfxfeI9pOIDOKRTwrvt+2x6Ci87Ht39fyn8xHjmxpF8pZyup3rBJdHgVtoX6W7BfAcO5ipeFLcZrOt86AWl2QGpATGNV+/QWQeeA/KRYF2f3ydSbVLAD14HUFzm+du5LbzLBu5y+UjzyFd4l44W8AA25opnM4NZJhDyfcFdFdW62aJEGejeA2135EmrPqpj/sZYO8kpoiz7LkehhD01UpbSZkYzAXhirS0uadDbCYh3s7niehYJ8wOyzNN7WLW6tVT4yhEWCFLgJUB9dUOrlv4bp8T5ZXVoxekDfPm8h2mjElYlQ1kzrquQ7hufDBFN7RDFLrTz8d+Li+d6iZl15DrA/01moMP/7SbDSvZ9b1jdACgmfkOUj+gmIqYHZrXdkTAsSKgavUvbTNSRkR0xFr9HCpmLSDcOLup8VC0TL1hb+BBXHw8e+20vgqcubpO1Wr7Q/2GKqmLTwhUfwkkZyLPkBK08DOXYV4dzD04hApBMZQ768mizgeCs1aqhPSF8GEZTJskyAv8VbGHVLGLJl2WogYpMFPlYBYRALQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA4PR04MB7790.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(136003)(376002)(39860400002)(396003)(366004)(451199021)(86362001)(6486002)(31696002)(7416002)(6666004)(316002)(966005)(8676002)(41300700001)(5660300002)(83380400001)(6512007)(38100700002)(6506007)(8936002)(66556008)(36756003)(66946007)(4326008)(478600001)(186003)(31686004)(2906002)(66476007)(2616005)(16330500008)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QldsWlRCaGl2UnZTc1JXbVNrMThLcUROS0xVOGRKMmxHaWpIUGlyYis3Mkg2?=
 =?utf-8?B?Q05LRGx6dktNRW1Pb0hKbnZ0MXRLTUdXZFJXdVBDRElPYU9OOGxIaUxsZ0Fz?=
 =?utf-8?B?bmxPWG5KOXBHTTY2c0kydzh6TlY4YmxkblNBQXBXaE5FRnpFME5CalU0SUlV?=
 =?utf-8?B?MTkyZ0V4TjhITzBGVlNRdmxYYmc4bVpmK1N2ODFuM20yV1RucEFsY3NzSk1W?=
 =?utf-8?B?TmVPb0hHeVQ1OHh6cmpCNWMybksrNUNieFB3eWFCMVRwWWhtdmRUamhKNFZ0?=
 =?utf-8?B?NzIva2tTb2NmNzZPSXl3NnNQU2JOU1ZqRXZzVFhWbVBLODl6RDFpWDV4L2tB?=
 =?utf-8?B?aDN0VWJiNFAxcEJiRVJtdFYyRjJTWDNFZ2pNVjhDb1NNNWgzY2gwcFhsRFlN?=
 =?utf-8?B?aW4xU1l3elZvcTBnL1M5NUtMc2cweGFwRXBpSm5hbmI2T2lDaWVnby9XR2RP?=
 =?utf-8?B?cGpjcTBSWGpSZ2VKVXZvc3pVMGhqYzhBZXUrQzRiYzNpZ2thV1o5R1hmMmtr?=
 =?utf-8?B?YXBLSjJrR1ZwenFLaDB6TkEzeWFBMTlxanhIdFpTdXc1dUx0Q255bzdFQkdx?=
 =?utf-8?B?VDdnbVRrbXlZRW44SnFtZzJhNk9LZ3ZCcW1IVUVOOHM3YjBKaWoxOFo3cDdX?=
 =?utf-8?B?Q0V1R01hcDRzc202cVNkSG5XR3ozRk03UmFrZXM4THVnazdrUG1NeXp6SGh3?=
 =?utf-8?B?OENOdVh6NW5NSTF5S3FJMlQrVjBzRkk1YkpidUpJYkVQcUd1dHExclRnN2Y2?=
 =?utf-8?B?REZNOHRIU3FRdUJWMC93RFYxTDdvU2h0REo0amFjV2dYdWhGdlkrNGQyb2ZT?=
 =?utf-8?B?NWpyZ01sOVBRS2NlSWttU1c2QlA1MndkNmZYbVd4UTNidFdhR1Z1NHQyamhY?=
 =?utf-8?B?N3p4MDJiQ1dTRmUyaDR4V1hoNkQxWkY0NkRTclpCMlNaeS9SMjdscC9QQUM0?=
 =?utf-8?B?OHpkbUI2dG9tQlA5RHpJSG9IVG5yWnVLeHpJcjhlVUVCdVlsR0ptNWU0NG1W?=
 =?utf-8?B?QVozWHVrVVAxL2svd1dhMHZieGN2Zm41YktRNEpkQ28xNHR6S200aVVXb0lh?=
 =?utf-8?B?NEJOeXd4TWs3WjF5RTZQYldCeVBTQVJmNUI2T1BRY3R2UFFLZ0xlSFR2QmF0?=
 =?utf-8?B?TVc1SFRmZVBBSFNqTlJTNnkvNHRhcmZib2h1SVdONi9aS3pBcTJxaTZ3ZzZN?=
 =?utf-8?B?Tk9vbUhSMEhxM002R1B6RTZJWGVnQzZmMy9PQ2k5TzcxaCt5eWgrTUNaY0p4?=
 =?utf-8?B?Ni9RSTFkTy9MVzVmK2kvd2FHMUxNR2FrU1l1eExlOXl0YVRhcktOQVB4a0xa?=
 =?utf-8?B?UWZ4dXhxcFdWakNtNURRMzE0OXZLMi9jZUdreGd2TWttaWNmVUpzandGVzNZ?=
 =?utf-8?B?OFYxZWIrc1paVzhLd1JWNE85aW5waHNJVzhFVlpuOUVGUSszWk5heWFiTzlH?=
 =?utf-8?B?OXBkQkFuYlM4UnNDNXVjbDV4RUg0Kys1L0VGU3EwZXE2NjBvakxkTUZOS2Rj?=
 =?utf-8?B?dWIzOWY0ekRiUXJTN3RWbjFpbS9OTnNhRUo5bGxCSkkwSmNzRVIzYkduV1M2?=
 =?utf-8?B?SjJxMktKTHVSNGRCVk5kd3Bia213SXdCenBtaDJEc3FVS1Z3RXpZVnpmM3JP?=
 =?utf-8?B?NjBDN0xrQXJ3Mm5la25wMHNJSkR3Q2xweU5GWFFPaG1rUjZnUnZ2ZlNyZTBo?=
 =?utf-8?B?cFpnTXh4bWlpWm5ER0dncE9yNjllZi9KZGJac2JOdDRRQlVrZXB5UzdvVUpU?=
 =?utf-8?B?OTJaZS9SWmxubmpQcFYyNHJFR1Z4amdKQlA1VmtNbWxhU2lNenhCYWFaUlhO?=
 =?utf-8?B?OFNhMXdBVTNrd1VuQ0JvZ2I3RHZWRmwrVkZxSEVGajBXMEtWN2VzakRtb1Bj?=
 =?utf-8?B?MGw2VjJFeE05WERYYmM1RjFGckJWaVhKZEMyRW1ROHdUUjE3T21LTCt6cTJV?=
 =?utf-8?B?TkVKczFITlgvWnRFbWQvcEVkWlBrTGhSWVZPSGxGTkk3SmJZbUJTcGExOGxz?=
 =?utf-8?B?c3RCSHNmRzhvNTJ5bWtXYk5aZk4vdktYRnVNME91ZHkvVXFhWTAwdk1BWk8r?=
 =?utf-8?B?UVFidnZTZTZ6SXpuamNSQ2pMKzhBbWVqNTIvTUV5a1dtL21keVFWcStTbWlH?=
 =?utf-8?B?UU5kTmw0VktVNUVlUjA3T3V6OTV2QmE4MXFnVVJkbnl6a0tXTDFvZEprejN5?=
 =?utf-8?Q?iETXb6TGsYBO47B3gnfW2aWJQg++pjdPnA6k7BfhrMOO?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36bc7ea7-695f-41c3-203e-08db6cd34db4
X-MS-Exchange-CrossTenant-AuthSource: PA4PR04MB7790.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2023 12:31:40.2200
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tXYA2StS5IQgo/vNO2sHM27VdX/0zsa0o18esJIeAgHEeq7U3DqJYOaYgtj3v5e+6Ir9wS6aJXM0Hq6nouVPTg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8939
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4.06.23 г. 17:27 ч., Kai Huang wrote:
<snip>

> ---
>   arch/x86/virt/vmx/tdx/tdx.c | 94 ++++++++++++++++++++++++++++++++++++-
>   1 file changed, 93 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index 7a20c72361e7..fa9fa8bc581a 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -385,6 +385,93 @@ static void free_tdmr_list(struct tdmr_info_list *tdmr_list)
>   			tdmr_list->max_tdmrs * tdmr_list->tdmr_sz);
>   }
>   
> +/* Get the TDMR from the list at the given index. */
> +static struct tdmr_info *tdmr_entry(struct tdmr_info_list *tdmr_list,
> +				    int idx)
> +{
> +	int tdmr_info_offset = tdmr_list->tdmr_sz * idx;
> +
> +	return (void *)tdmr_list->tdmrs + tdmr_info_offset;

nit: I would just like to point that sizeof(void *) being treated as 1 
is a gcc-specific compiler extension: 
https://gcc.gnu.org/onlinedocs/gcc-4.4.2/gcc/Pointer-Arith.html#Pointer-Arith

I don't know if clang treats it the same way, just for the sake of 
simplicity you might wanna change this (void *) to (char *).

<snip>
