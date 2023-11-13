Return-Path: <kvm+bounces-1585-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D55B7E97F3
	for <lists+kvm@lfdr.de>; Mon, 13 Nov 2023 09:40:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 275741F20E0A
	for <lists+kvm@lfdr.de>; Mon, 13 Nov 2023 08:40:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E490815AF9;
	Mon, 13 Nov 2023 08:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="YqNVZFeM"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51A401FAE
	for <kvm@vger.kernel.org>; Mon, 13 Nov 2023 08:40:44 +0000 (UTC)
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2052.outbound.protection.outlook.com [40.107.7.52])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 218EAC7;
	Mon, 13 Nov 2023 00:40:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OSVXpAOXQTgiujg/Ql0QQXy2xYJSpjnvzvx+lSrShybEn9X2SGz9dliGpoKy13L9PQ1qPOGV3JVN5J/EyEcpKJ0Thx6Qq5e54XMtUL8ILnvdzOG5vzwKvUoKSFM1XPB8JM0IJ2Bn6pZGm/XFnPE0J/VT6okB7bMXT/CIZfnjuHJ+h9HBrU7zrwJKhEP9EA1wVMmGDo/rMvBUwlVGjHyIkSUG7sPZuqqq/668vbpsyVelMJKRe6Dvp53WqlrE3XCIoD/ljlF9Je7T4+5Zb/ITH6VodPU0xzClrZ88WawX6lL5CRm3p9nTY8SRjjP+wYyaH4sn14VYoQ9ZsU7VkUi6hA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8B+desNZlpSBKOeBSxSIhk9XDVHa6d0b99hlBb8/hcs=;
 b=ji/13fq7tngn8SqI0GGbOvSzBkluMH9iqn5BIMQcTMdCwMEaheeYHsx+GIFZc1YdoxTw27VaYSXU/FnW2kCD9+eUAwk57ZljAZupCkAllYL0uMnZkI2diLDuigwh7nt6bRLZ0EQQwxLCGDsY5bvOTAVVSa+dKWnGG6eSAwLu85Njm1HmwcmyMiLk09sDwuOyCQEmGT3SGBhrLEp1TxhBPHJYn5BaSyH2jBdu21GrWa450D/Y9F8A1xRFMWKZRXLGSwlA18ta2Jmzs3E93bwKStIOqEzHqcI4CWPHxJD3+LSUaIFAH9DrCuU2WtVivvihmQVI1YWr/m2AK2bn/Rk13g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8B+desNZlpSBKOeBSxSIhk9XDVHa6d0b99hlBb8/hcs=;
 b=YqNVZFeMKxFthYO8AlIRSYAF6vXqBFqNaiSdicnQlsWDNxrUKO+jWLKIIBTO1O+sA8q5sX5XVDAI8SunVSJgMOoCycFJghXm+fPTfhizUtpjGn+PWDvyMdtQpu9rwTX7Wkr5+hFAqum6PgOl5x45t3/6p6lqfBl1iPKNVD4zHu1eQ1LEqqmmL0ezlHVGUQ4R9YpwFB9PKHXDo4WLIXIHmfzWqSiIkpte4IuT1CH1RiPT8vLiMM0U2SpQxcHmb6mgeXfaCOi7DB+r4JCPTlYzKmFG1EdiHIeyRQkVqPgCK0hk5Y1X909HxVR7OlonjtNiDsWjo8o4BZl579l1Z9Icig==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from PA4PR04MB7790.eurprd04.prod.outlook.com (2603:10a6:102:cc::8)
 by AM7PR04MB6950.eurprd04.prod.outlook.com (2603:10a6:20b:105::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7002.15; Mon, 13 Nov
 2023 08:40:40 +0000
Received: from PA4PR04MB7790.eurprd04.prod.outlook.com
 ([fe80::e665:a062:c68b:dd17]) by PA4PR04MB7790.eurprd04.prod.outlook.com
 ([fe80::e665:a062:c68b:dd17%3]) with mapi id 15.20.7002.014; Mon, 13 Nov 2023
 08:40:40 +0000
Message-ID: <b3f02f00-3422-4c4b-b142-2981441bed96@suse.com>
Date: Mon, 13 Nov 2023 10:40:35 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 00/23] TDX host kernel support
Content-Language: en-US
To: Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
Cc: x86@kernel.org, dave.hansen@intel.com, kirill.shutemov@linux.intel.com,
 peterz@infradead.org, tony.luck@intel.com, tglx@linutronix.de, bp@alien8.de,
 mingo@redhat.com, hpa@zytor.com, seanjc@google.com, pbonzini@redhat.com,
 rafael@kernel.org, david@redhat.com, dan.j.williams@intel.com,
 len.brown@intel.com, ak@linux.intel.com, isaku.yamahata@intel.com,
 ying.huang@intel.com, chao.gao@intel.com,
 sathyanarayanan.kuppuswamy@linux.intel.com, bagasdotme@gmail.com,
 sagis@google.com, imammedo@redhat.com
References: <cover.1699527082.git.kai.huang@intel.com>
From: Nikolay Borisov <nik.borisov@suse.com>
In-Reply-To: <cover.1699527082.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: VI1PR04CA0046.eurprd04.prod.outlook.com
 (2603:10a6:802:2::17) To PA4PR04MB7790.eurprd04.prod.outlook.com
 (2603:10a6:102:cc::8)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PA4PR04MB7790:EE_|AM7PR04MB6950:EE_
X-MS-Office365-Filtering-Correlation-Id: 4935da12-9ae5-4c44-8267-08dbe424375a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	5S/C4mDYzvn8Z6h7H8frVADHv5LZNFzocqp85K7jACwWZ2KXry7KTF/UnHHdQnPvTUHVip2I1yWzP0+QNmx3edyFCuEw8gMX0ylHLBG5tIYYaRmwcM6TA5nizIFAXrAjl8zRj1zZWp1HreubjMkjElE4tvN3eI0LK1QyewYKCRStrVCXxrhsoNZ9CZnTV1cvopg3ylg/thEzruKWvFovITLOe/uSfrBZKRkMvf7hOo2ouzo+BmNBInqXOkM14KhHK07QEb+uL04b+jQQ7CnCxKGz5v93nLbEnTdAycDDlofOyq6VPEayeZf/8O6d7n73w9qcc484deFL/7ot10pcOKAcFGhlbUuLCJfwsNVab64HyzZiJYDCtr1hYn9sM/ZL6eohMuISJNBsYu7kzoeaZ16qOHuyZ+axgDYaXaBeru3w4PZTGeolMD/lO/5uougbbrORrB3XcIV/9AJK7LNEos4WvLz+yRjO0rj58hikjgq9Ct6nvtU4CFsEf8BwFeIFM6sLoruVhCoUFVAZ+2blgJKTDTN6MWoY/XbsOZsPf0cKTLerPR74hPdG5UQueTlIFB95tn5B2xwNxBa5le/KS2KOGaCwSZVU1F3pMDVHek4nt/DLIK2lQV2uzWKLxOh75HLUlqaFYqGdszM9aXwDLg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA4PR04MB7790.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(39850400004)(396003)(346002)(376002)(366004)(230922051799003)(1800799009)(186009)(64100799003)(451199024)(66476007)(66556008)(66946007)(316002)(478600001)(6486002)(6666004)(7416002)(86362001)(5660300002)(31696002)(41300700001)(36756003)(4744005)(2906002)(4326008)(8676002)(8936002)(31686004)(2616005)(38100700002)(6512007)(6506007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SWRTcSsyckVXSi8xZFlydEcvQ3lIL1MyQVZLWFV2Q1JuN2hkNjI0RTBjUWFZ?=
 =?utf-8?B?cXdISnIxVnMvUjVjUVRmQlllR0xLOHBXTXZHNUJQOE1KQncxemFiMkkyTkZU?=
 =?utf-8?B?WXFobDA4amo3eTF3MThXN2dhL2IwdHZidFBSL3RMMWhTSXJiZk54OFJXWnlX?=
 =?utf-8?B?SWVQVkRSVDIvN3hpWjFKd1M4aUdDdDZNYmlBSGlVT1ZUbW5hUkRzdmpUWVg1?=
 =?utf-8?B?YWJjZlRqSWpseHNoNlhxbXRraXpoUytjYU5YVE5EMUVTK2FuMG1FSWl3amt5?=
 =?utf-8?B?ZTFxa3p6RFJPVmErZmE0ajFOV1VTTERUR1JjSDJKQjd5bCtDM2d1Q2NmZVpE?=
 =?utf-8?B?ZFFhZ0NPeWZtYmVQb3ZDNWZIUnloVm91b2pmazFqcTA0U0VoSnZxb2R1cDZz?=
 =?utf-8?B?WlB2Q3dURnJhUXRpM2F3aDJJS0VLbjQrRndPRlB1UmVUYXJUMFh3aWcyWmJ0?=
 =?utf-8?B?ZVcxTmZlL2NDaGp1dllmdzlCWFM0ay8rTXlhU1R1SmRkYnRtZ2pORmRlcjVK?=
 =?utf-8?B?ZThqWENldkxLSVAveFFJRnYwejczR3R1eEdCbSsrVVNRZExKMi9jSWZUcSsy?=
 =?utf-8?B?WWJpL3RjQng2UE9SUXhBbkJueHUwWmw0Tk1VRmc3LzRDR2xucXM2aVpKZUdI?=
 =?utf-8?B?M3plRnBBdUUxcVMrbEhQajVpa1h1RDNZUHJYRkZlN1pxcXZrcmE2SzVpNk51?=
 =?utf-8?B?dzk2ajhkbVg4c09FL1phOEVXSnNPWmY0eVJBdEtnbnpQUFRJMzBjYUN4SnU3?=
 =?utf-8?B?WUVZWWk3M1ZONXFkaysxckxidVpkNm0xYmhYNHRUM1pNd0pOVFVEVnlpeHVQ?=
 =?utf-8?B?VGVqNWhmN2JkL1pBQUpPUGhuRDh2dW5wUi92TGRuamErVVBaWHNKOU9uN3dl?=
 =?utf-8?B?ekY2MTl4M3g3VVpvZ3JPT0Y4VHlTSXdKV0ZEb09PNUFjd1doOFVSSXhzWmxE?=
 =?utf-8?B?OUNFYVNzeWtobEhhQmlxYy9ZT0FwOUEyVnRRUzFsTVZvSzVxMkpXUWg3REQ5?=
 =?utf-8?B?YkRET2RUUnRZSVhlSjBKZlViL1ZoaTFCMmtycnlML0d3b01TOXlpOHlZRlFM?=
 =?utf-8?B?RFVxNUNaLy9HalVzV2RFZUxVU1FzTDQ4UWkvWk1hZFhJS3BLQXMyWVZXNHdQ?=
 =?utf-8?B?OU9qTi92VjdNMUk0Zk5OSVZMbG9hYWhQRDhRdlNyQ1cwMy9FeFNlS2V6cmFs?=
 =?utf-8?B?K1pGbVdrNWZMMkNLVFZxQnF2M3pQSVR6YnJuN3hpZXVlY1lXRHMyZXA4QXVB?=
 =?utf-8?B?eFhWU1RBYm4yeXN2ZlVTWGhya1BuTWZIaWlwN2I3cklMUHA2WURLUEdVYTZQ?=
 =?utf-8?B?NmhrelVXbFA3SjNFVDMzNm5pRVJEaUtLaVpGMHkrVHczQVJvWE0vTTBrQklN?=
 =?utf-8?B?a04veWNNalNsOUhxU0oxWDJXdnVCQXJFQ283ek12b3FKUFZ6NEpyMFo4c1BC?=
 =?utf-8?B?RXljem9zQnZQMFVXYTYvNVdadFJzKy9HWFVtZjh3SEpFdG52amJwN24ramps?=
 =?utf-8?B?c3dpMnoxVXZ0L2Zyd0k5Rm1nUWlZak8rZE5HZTdIK0s0RjNjSHlXSGVVRGVL?=
 =?utf-8?B?YVZPak5KVk5Sb1FTMGNOclJuWEVBblR4RDJobzZ2aHdueXlkeGZWL3FPU0lv?=
 =?utf-8?B?ZVNmZ1ZSdTBXR1dpaFp5TnA4RURPVXJzSndvWHVYbkFTNi94cTVyZytiWTRM?=
 =?utf-8?B?cno0YzlCL3BnNXNhZUFZeFFVN3ZEbnRFQXVsUThxc01hZW5IbldaYmZEbFBC?=
 =?utf-8?B?NEJBM2xGQSt2U2xrcXQ3TEJ2c0FPamVxcGk5TG5aMVlaQW9KQ3htRmRsVGxj?=
 =?utf-8?B?b0VaZ01jemQ1K0h1V2V3a1NubnNQWk8yVnhGTDlFNnRJN0twSVUxOHlvaWlI?=
 =?utf-8?B?U1NEQkV5ajFGWWR1cm9JdVJUT2pJa2lmcjFJa2lwdVluZ1hmL3RsU3pIQ1RB?=
 =?utf-8?B?eVZGb2szdjJOV3IwYUxHYm9KcW13TllHUG1uY1RwZHdWQ3RwRGs0YVZRdWdw?=
 =?utf-8?B?aUJmMjg2VzRoTG9FTU96cjc1a3pKNlFmc1VOOHZXNGRObWJxcHdVbFg4enJE?=
 =?utf-8?B?cnFmWk9lTlVjTmZ5TUNFc09DV01iRkpBNWlIN0tJeXEzcEtEalpsdWNJc0pI?=
 =?utf-8?B?RnlhSmxkUjlrelRtUkQxcEUycHUxWkpSWFpNU1g4WmNFMnFzbnZmenV4b1Vk?=
 =?utf-8?Q?gQ5fPEynxwBVhhLLLSbjC163uqxdSpyrnDAyoL2LCuW4?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4935da12-9ae5-4c44-8267-08dbe424375a
X-MS-Exchange-CrossTenant-AuthSource: PA4PR04MB7790.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2023 08:40:40.3786
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xMOHDqQ6cjJ83HUdBd3NuOZsGbGvz2dTmCFNSvWpQGF/K1pVOCN/0ycFtg61cd5FzGU3gnP2Yy7B0KdR0YHdBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB6950



On 9.11.23 г. 13:55 ч., Kai Huang wrote:
> Hi all,
> 
> (Again I didn't include the full cover letter here to save people's time.
>   The full coverletter can be found in the v13 [1]).
> 
> This version mainly addressed one issue that we (Intel people) discussed
> internally: to only initialize TDX module 1.5 and later versions.  The
> reason is TDX 1.0 has some incompatibility issues to the TDX 1.5 and
> later version (for detailed information please see [2]).  There's no
> value to support TDX 1.0 when the TDX 1.5 are already out.
> 
> Hi Kirill, Dave (and all),
> 
> Could you help to review the new patch mentioned in the detailed
> changes below (and other minor changes due to rebase to it)?
> 
> Appreciate a lot!
> 

It looks good as a foundation to build on apart from Dave's comment 
about the read out of metadata fields are there any outstanding issues 
impending the merge of this series - Dave?


FWIW:

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

