Return-Path: <kvm+bounces-2614-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A0BD7FBC51
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 15:10:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3F8A0282A63
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 14:10:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A92AF5AB9C;
	Tue, 28 Nov 2023 14:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hFlEw2Ow";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="onyWO8MT"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09AEE2733;
	Tue, 28 Nov 2023 06:10:32 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3ASDT6Ts026816;
	Tue, 28 Nov 2023 14:09:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=SJvXPD1cF/mUw2ngDAK6eBNKHLJpm3YqkCbv7zkGJU8=;
 b=hFlEw2Oww/woYY8EmB3zXLYfKqahjIwnBt0S7BGU4NlVvJUKPvJZLE1TTSYRzZMH8TSX
 An5xIWXL5gn8G4WoR8jNqShlxlmWFM2IW+fTKnYtH6VKaYK89luRS2r5Ejnp+8usqOi5
 OCxvq8ZYlEB2wc8NcMb9kGVU1kDig7sLQ5mjaeOU9kqqzAgBrb+K/u1vwnDYyxHhGBPi
 2iTw9AiYDlFbAgh3n8cb6itsCwmuhqnP5Mt08e91bP9K0PVVpkf4cwEZa0nPbu17kO/M
 EWqr9NUexd0IelnrznVsCmtxiNQ+NY8UxEkFMjE5b9dXelyHEj6T61XtAvrn2yN0TB/k ig== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3uk7bewv75-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Nov 2023 14:09:15 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3ASDj4tU026446;
	Tue, 28 Nov 2023 14:09:14 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3uk7c6nmfe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Nov 2023 14:09:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BTrZJkyJ3ozZPksJ/4Fiab06ldhdeXCEXFHyFsuhsR/ApV0DFaWiMoF6c6EDuwnahrU38EvGjae/txkwANItaTiEnVQxXkmm7T426c+6GGYLazF667stDz8oakWWPtBCSQ66At9PZlKuIvn6bknu3JIoXYWC+9XroaiDSxT9+TCmwSKBR3AVcZmf0TEhwbzygtLFVIcxjwZHfp5aLqEGTBgrX+NbkfghFXt8LeUiiWV+DET16lEHcEYKP9zouxiND+xkmgq0qddNLAoUNrlauvBcS5qVF22pxcRUODjfpQ9KGBgGBs9u74/1azFn15A+bLncX75T7KLl3PlhviwbxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SJvXPD1cF/mUw2ngDAK6eBNKHLJpm3YqkCbv7zkGJU8=;
 b=lycbSISfVP4nKvFNDOYqxT88PkuIX/dboJtURmI/BugccQrf1iFNl0IUN/mWlGaV2vmbL5h9XgIT0ytr4yDOkRqwFDcf+I9VXPDulRtKbZRosM10WRm+BuGSVTPdX6sNJf/V7BIZI4WcWqehZ6RatqokPvWMx6JAhy/aiIY+ElwC8Y+sjJ+aauefsnb20FXYn81nzxdsB/j1aVF7lsb/5RMLCeQJm/B3nem8FRHnYBYtlWoc7FcON97fPUIJ0ZFIsGYeRw7Zine+HLBPCopxsgMI/NZG9r9wsT0dH/l65CTjB7hmv6N20/RfcJXlJtrD/a6lUixfN2aWTXqMO5nOcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SJvXPD1cF/mUw2ngDAK6eBNKHLJpm3YqkCbv7zkGJU8=;
 b=onyWO8MTIc0yQ0k+qxQCnVHWFOf98e7EmEICMBHArw+dY5yKjm+MVIBfRmRXaV+Or16+IQYo7fZxcWb5hVUfq9ASqXaHTe3ig4+HEEGyAjnraiSGsgYPNsAJiOPs6QktoY3OZ2NoxjEfQ4+XYDmFHGkCfBjX1aIdrkRS+GKHJjU=
Received: from PH0PR10MB5894.namprd10.prod.outlook.com (2603:10b6:510:14b::22)
 by SJ0PR10MB5672.namprd10.prod.outlook.com (2603:10b6:a03:3ef::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.27; Tue, 28 Nov
 2023 14:09:12 +0000
Received: from PH0PR10MB5894.namprd10.prod.outlook.com
 ([fe80::77c7:78b0:ea43:e331]) by PH0PR10MB5894.namprd10.prod.outlook.com
 ([fe80::77c7:78b0:ea43:e331%3]) with mapi id 15.20.7025.022; Tue, 28 Nov 2023
 14:09:11 +0000
Message-ID: <c46b6bbf-d308-4ad3-9e70-dda6894a40f0@oracle.com>
Date: Tue, 28 Nov 2023 16:09:03 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/7] x86: Move ARCH_HAS_CPU_RELAX to arch
Content-Language: ro
To: Petr Mladek <pmladek@suse.com>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        catalin.marinas@arm.com, will@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        pbonzini@redhat.com, wanpengli@tencent.com, vkuznets@redhat.com,
        rafael@kernel.org, daniel.lezcano@linaro.org,
        akpm@linux-foundation.org, peterz@infradead.org, dianders@chromium.org,
        npiggin@gmail.com, rick.p.edgecombe@intel.com,
        joao.m.martins@oracle.com, juerg.haefliger@canonical.com,
        mic@digikod.net, arnd@arndb.de, ankur.a.arora@oracle.com
References: <1700488898-12431-1-git-send-email-mihai.carabas@oracle.com>
 <1700488898-12431-2-git-send-email-mihai.carabas@oracle.com>
 <ZWSrMzHEbdynTA8A@alley>
From: Mihai Carabas <mihai.carabas@oracle.com>
In-Reply-To: <ZWSrMzHEbdynTA8A@alley>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO6P265CA0012.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:339::16) To PH0PR10MB5894.namprd10.prod.outlook.com
 (2603:10b6:510:14b::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5894:EE_|SJ0PR10MB5672:EE_
X-MS-Office365-Filtering-Correlation-Id: 142680db-99e1-4c50-eeb2-08dbf01b9881
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	LPve+6Ik9Wpb4qKtXZZVcsBwCq23ZqLY+8UcFMkM9nXVspa1+QDXzP5K9dDlpO8BTHpyxeCv9e9JM9RuAz2QWiCnOlXl92ZoEOleOY3x9ogmYdG14HZlQxBN0Jr4r9oWTiTxsXKGY6/+3nWgVhpZyYTQC2UfF/O124DfLovgnsbS2ENQGqusq+spgqFk61hOLRNWztJLCopVx36s5mVGMUZ5MR6RQR4o9DY9Pv/r5N+IX0qZcEmQ9iy21Y+SCJvvDdIhf1vnWa1eVg0kYUYQAkh9m61NurfCEPOuar2wXeY9XHDeCwHzUvkK01kf8r6OVNNWfs0PJlCq2uir6ylR5GA72YYYuavYVTEgT54loxGlvbFwJOwyY6GPeWhOQUp4qe3FQV6rxqiLuCc2+I9LOrfT8dy92nXJLtgRS2FQGoj9cIGQrUGAIDOqteWc6LBPkZREGzagQT5bLBIiNsNLQgoA0Z2ovjD66snA6h6NdbvRvfBfbTgUqrJpJSUgj76yEefylZW7IB2LG0DkxfD3TIlBjY3XUHpH7rSJGpzBXMNYGkmGLIh48r+6asOiOpumefd673FKKyt3mJN63Vraie1L1dVenYZLaZ0S3ziaM2RdQd6VOGSc84rIwAA6E1LcSMI1mJXwq/hgrm6RS8ZK1w==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5894.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(136003)(366004)(396003)(39860400002)(376002)(230922051799003)(64100799003)(186009)(1800799012)(451199024)(316002)(6506007)(2616005)(6512007)(6666004)(31696002)(86362001)(36756003)(26005)(107886003)(6486002)(38100700002)(83380400001)(478600001)(6916009)(66476007)(66946007)(66556008)(44832011)(7416002)(5660300002)(2906002)(41300700001)(31686004)(4326008)(8936002)(8676002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?dlVyVENyOGZyUlp3Nzhva2pORWNNaTVrOWJJeStxZ2Q3S3RyNWFQaWlCaDB4?=
 =?utf-8?B?RkVVRmJGZm5yYlVBMXhZdy9QNWFMWjQ2eWxOazRZTG0rWGtuOWdrYytLKzln?=
 =?utf-8?B?U3Nnc1VHdnEyeTFvekNrTDhwUmZjOVBnc0t2NmhiSWI3WFlhdkJWaTgxRHBj?=
 =?utf-8?B?SlV1OGhKT2x5SnRtZXNPbUdJQXVobkYyT050QVhXcVpyR1RpRmhXbXV4M1dW?=
 =?utf-8?B?T1VwcloxWGlFQ0RRVlI2K0VqNjhKTitJT1lwNnVpV2ZMbm0yemlLUnBYRGFF?=
 =?utf-8?B?SVZ0MGpqYXNjODA2K2Q0bjZ6NU44dnN4WXdJcE9WQXBEaFBTc002eEhHUEVs?=
 =?utf-8?B?dzlMZE5IYWk5WGY2NEhEMnBzU0hUWDdFaXZlZXBqd3BSREx2TnlxMFg0aG1z?=
 =?utf-8?B?dGJBZVhsUjFpbkdabk1xdXVtOEhMc2R2VGFKUkhtNXdKR0ZDQWFzd05GQTJY?=
 =?utf-8?B?RWJndzl5d2xKSmZWVkpKY3pnRm5aS0JoK3JmN1FtRVA0YzhMcEUxTHNVNjc1?=
 =?utf-8?B?cHdpVFBLcUZ2aHlJSnh2T2prTlAydEM3SEIrT2tFV2xUZEZGcU8zdzJ3dGpP?=
 =?utf-8?B?c1lVcU5ubElmZVJhSjZxdTNTVjlLMlhEWmNZNytqaWk4MHlQZG84UTdaaTha?=
 =?utf-8?B?Ni8zTVRUanBEd2JxL3dmUytLOSsxNHpiM1FJakZja1ZxbHNPdE1SQ2Nlb01q?=
 =?utf-8?B?QVRjUnVESmdiUG5OV0QxRDdiM3p6QTFRcXhsQkZRakJReERXUHdwMEdRMVBL?=
 =?utf-8?B?ZVlmTUJ1YUNZRStGdnpNWFNtUzM2ckUwVmlLc09yNjBHUHZqdFVvckcxUTRn?=
 =?utf-8?B?eHFxYzhpNGlWdEM3MW5YczNCQW9PTTU3dUIrVXBDenh6NWRsREttMyt3clF0?=
 =?utf-8?B?dlMxR2hUR3NZMkp1YVk4RHg3Q3JWS1l2QVByc2puTjF1VmJhaU5VTS9JVUg1?=
 =?utf-8?B?UkY4SWpBc2RzUmxEOHVXQXFiaFhGTWxZczU3eVpubHBCL2VmMEhGczhodmpI?=
 =?utf-8?B?K3ppN25rbWRNVGFPNU5YNk1yVkdkUGNqTCtYc2FNY1p2M1paMmcrT3JqNk83?=
 =?utf-8?B?bHRHWVZqNVMzZ29pRG1UNGlxNmsvangrWDFqUHNRZkFtM0pZYzZTYUdkbFNo?=
 =?utf-8?B?WHZPazBLSDhTby9HOXVabnMrUmQwMm50emZIV25Yb0Y3L3BRb0FYOWxSSlVK?=
 =?utf-8?B?SENaK1lJam85ZEZEZ1djK2hMWGhneTUzSllqdDBJeUo3OTVVNHhpS1lhK0k4?=
 =?utf-8?B?VWxJZUxXakR4WEk4dEEwOE43WEsxL1VKWncvRnVlVXFxNlNuMUtxTk8vWnpO?=
 =?utf-8?B?cElINUJ2YnEwazYwR0NLTWJDM3ZPbnNTTFZoWjhKOHhaejZ5VGptSWVmNTAy?=
 =?utf-8?B?VzR3amxxdWhkNW5oaFQ1LzBBQTdIQ3hLT2xIeld1aHJFYmx3Qmdad3R5WWVy?=
 =?utf-8?B?dTlsdytWeVNkYVZOdmZxMC8raGVXaWdqMi9pcEN3bndna1MzeEZ5NUt3Ly9p?=
 =?utf-8?B?SnRUZURkcWF3cVRDNUoyWHFJYUxYVGFXOWx1YTkrcUlTUFNjbUNsem5VVXg4?=
 =?utf-8?B?M29pOTBtYXRiOGRKalE5K0VEa1pIejd3dEpIVXd5QXNpZlRJVHNVM2FNbzgy?=
 =?utf-8?B?MVAxM3plN3hSMTU0djYwQkxVV08rRnRiU0ZlNkx3SlJSd095aDlLTVBzQmpu?=
 =?utf-8?B?UjlXL1ZEWG9JaWd0bDBNMGNXWmcrTlJlM1hhcmdhUnY3RlVnNnNPVnlUY3Rn?=
 =?utf-8?B?eHhyWk1qNzQwMGMxQ0RRNDF0aWVZRnVOVFpJc045MDgzSk9PaWttUzNnS1lt?=
 =?utf-8?B?bjhoY0hVdjZlWGJKZnhibmtkbjVmR3oxMU12V0xQTkUzaUMrQ1NMMTdoVk0z?=
 =?utf-8?B?eTA3SldxVTNQbEh6MXVWUXlIYlp5Q2lTOUgyWnlpRmhFOHVUSlUzaUVqM2FK?=
 =?utf-8?B?eWJ4V3d0dXhpOTFMaU9BbU10L2RZY0lSS2Zod3FLZDlZaTNuSnE0Z3dWQTlp?=
 =?utf-8?B?NlhoUHpQd2wvaDlnR1UzZEdZN1dRa1kwY3JlZTkwSFFxc091emk5VXJXZkg4?=
 =?utf-8?B?bWRBNjFIM0ZGNkpkYmdjTEx2bFVWVUpjVThzZ25aOWpOU3IrS0I5dDNhcWV2?=
 =?utf-8?B?TmhZSnRsS3BaNHFQdzdQejVmWkVUcFBMdFJzRGJKZ2hQSWlXR2dRaDJ3M1pv?=
 =?utf-8?B?RGc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	=?utf-8?B?aGpSVUpmcHVLWjYvMi9HQjJrZTVjN2ZrcjVjazhmamYxd3ZVS2F4eDhXaHlr?=
 =?utf-8?B?MmNGcThnam5ZTXZFTUpvN2pJRWhsa2hndGoyNzdCV2ZoSFdDc3dHWGdoaEUx?=
 =?utf-8?B?a0xKQ2xFU2ZLTmFPbFhzV1YzN2JyaTVPRE4xelFrelgxU0dBU1lWT2hWMzRB?=
 =?utf-8?B?TE1QckUvUGRuWmpESEszRFl6YTluTCtpblFKSU5CODdaK09ITUdyajN4L3JB?=
 =?utf-8?B?L0t1eU1PYTQ2VUVrTGRDejFxU2VGamNDK2xPTzZhZFo1Mko0TEtmR0lEU1lq?=
 =?utf-8?B?ejBnUXFiQlJURWlSK3dXS2t2WXFWQVVqYVUxL0YrcExBZzFaQlU0SnFGNktP?=
 =?utf-8?B?MWNCS0JMekRpaWFlY1pVeW5rWjdBc3dmTGdRQmJpaDlpUkxQZUdCYUw5Y0ht?=
 =?utf-8?B?eTNjMlZPNTBLZlZ5dWtFb09kRm9IeVlYWXRVR01Nc0o2YzcrU3p5UVpDUnpR?=
 =?utf-8?B?NzQyUjU3VTVuejdVckw0UXB6R3FWWjNJV3Q1cy96OTRxYnN6VmNnLzg1UWJz?=
 =?utf-8?B?bEF5Umc3NmtWWWhJYjJuVFZSY0RLOXpuQVNqVzN5R0dDQUZJcEFoWFcyM0Ix?=
 =?utf-8?B?NE5nblVMMExPUEg1VkllV0tBQUlhRlo4MEdlU1FWMVBVZjFkWEc1akFiZ29v?=
 =?utf-8?B?UjZUMlQ2b0dnM1kwTG5wSEdNQlJHdFoydVFob2cxTGtKQUZPRStscmNFbS9V?=
 =?utf-8?B?bENYZWNFa0RSUUNqYklVZEpEYmNTYW42SEFkbWdxMW5mbUlicjQwZkttTTRr?=
 =?utf-8?B?UUhralFpN1pNenEvQUdCRUZyOHpRWFdmS25OYkt0UXdwaFRDMGRON0ZnOG5u?=
 =?utf-8?B?TkNMd0daQjlqa1VVT05Kdm9CL3ZvcE4wOUVNb215MnRNUnFtaVBLZm1qR1cr?=
 =?utf-8?B?bSt3RC9yZXFqZmVIcjJsZ21nS1RIaE5rbDRMb1lDaVozekFHNE9JYjlGbFls?=
 =?utf-8?B?bU5ZSWl6emlmUDdTZDlUM0hMMGplNzQ5UmplMzZhMkJzWHF3QXpHMjVKcWF4?=
 =?utf-8?B?dnhxQ1hpUHNaa25LYjBmT3U4Ykh5YWp2OWdNbDZJdDVrb1J2ZDlyS2liKzVK?=
 =?utf-8?B?K1p3NktYWW9XRWx4L3dGNkJRR2FGeS9uaW1FbW45Rjh5WFRQTXkxT0NRMzNB?=
 =?utf-8?B?YWF1NmZEKzZVcHFNR0RrblcxWXJjOWQzbmsrL0sxWDh2Q05lTWx6WGFJdmFi?=
 =?utf-8?B?eDEvRlJxL2xreEdORXJPV1kvanhzL2FjcHgxQzg4bVl6Q0tOaU5Jenp4OEJX?=
 =?utf-8?B?RkFJb2g4MFNwcHJucW1mL2NVTFYvSHpwRzh0UXdxWkd4dHpqQmY3bXdWaUFJ?=
 =?utf-8?B?OFhGTEVCMVRvVklxc2VQbG9sQXFJWWt5M0txc1BGVVF2Z0ovY1pVSnlXTGFt?=
 =?utf-8?B?dFZ5YkNVRnBSUFFUODRIRDJhWkptOWM3aVFBSHF6RHc3TnloZ2N4UTJ0Rkwr?=
 =?utf-8?B?YUdXVEw2VDdyVllXUnkzR3J1Y1dmMlg3UERDL0NyS0h1b1VEK2x1TkxxNktG?=
 =?utf-8?B?ck5pWXhBNXNLOURtNEM5MGFwTE9mYTY2dDljUGU4bS9rM1cxT1owNHlZR1Bw?=
 =?utf-8?B?bUs0UVA2Q0hBelVXYy9wNmYrT1FZQk9FcUFaVisvYWRYQ1ppVDRmUytJMENQ?=
 =?utf-8?B?TklhMHRXdzdlQ1FGVFRGMnBmYWsvUjRrL2ZTclUrYTVsZjdiaUxYdk9kSU1i?=
 =?utf-8?B?Qkx2aEdZNHpwN0VKOEZWdzhhc1VZM0hoYk0yWkNTZi9OeTRDc1BDSUpsRWVZ?=
 =?utf-8?B?QnJuZXNGNWFrOUt0T2NkQm5CVHlVcW5KaWxleHoybEZYUDc5UVBoNVN5d3BZ?=
 =?utf-8?B?MDZVUmpncjZCR3lWSHptQT09?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 142680db-99e1-4c50-eeb2-08dbf01b9881
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5894.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2023 14:09:11.8833
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DAHK9JATh48zpqgAqr8YzQVLBROo4xbnwHAaMjJn82+frHlCcR8LquOOU4OAu4R3+lgT5hpb2bfveGPBqCDQuP2t6odvRzsFTZAMEolJekU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5672
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-28_14,2023-11-27_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 mlxlogscore=999
 bulkscore=0 adultscore=0 phishscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311060000
 definitions=main-2311280113
X-Proofpoint-ORIG-GUID: u947oXHHrF4nPgtav02XhhPMZOqr-dIY
X-Proofpoint-GUID: u947oXHHrF4nPgtav02XhhPMZOqr-dIY

>> From: Joao Martins <joao.m.martins@oracle.com>
>>
>> ARM64 is going to use it for haltpoll support (for poll-state)
>> so move the definition to be arch-agnostic and allow architectures
>> to override it.
> This says that the definition is moved.
>
>> diff --git a/arch/Kconfig b/arch/Kconfig
>> index 4a85a10b12fd..92af0e9bc35e 100644
>> --- a/arch/Kconfig
>> +++ b/arch/Kconfig
>> @@ -1371,6 +1371,9 @@ config RELR
>>   config ARCH_HAS_MEM_ENCRYPT
>>   	bool
>>   
>> +config ARCH_HAS_CPU_RELAX
>> +	bool
>> +
>>   config ARCH_HAS_CC_PLATFORM
>>   	bool
>>   
>> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
>> index d1c362f479d9..0c77670d020e 100644
>> --- a/arch/x86/Kconfig
>> +++ b/arch/x86/Kconfig
>> @@ -73,6 +73,7 @@ config X86
>>   	select ARCH_HAS_CACHE_LINE_SIZE
>>   	select ARCH_HAS_CPU_CACHE_INVALIDATE_MEMREGION
>>   	select ARCH_HAS_CPU_FINALIZE_INIT
>> +	select ARCH_HAS_CPU_RELAX
>>   	select ARCH_HAS_CURRENT_STACK_POINTER
>>   	select ARCH_HAS_DEBUG_VIRTUAL
>>   	select ARCH_HAS_DEBUG_VM_PGTABLE	if !X86_PAE
> But the definion is only added here.
>
> I would expect that the patch also removes the original definion.

Thanks for catching this. I updated the patch:

diff --git a/arch/Kconfig b/arch/Kconfig
index 12d51495caec..626ddd9ba7e0 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -1371,6 +1371,9 @@ config RELR
  config ARCH_HAS_MEM_ENCRYPT
         bool

+config ARCH_HAS_CPU_RELAX
+       bool
+
  config ARCH_HAS_CC_PLATFORM
         bool

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 66bfabae8814..aaca90ba791a 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -72,6 +72,7 @@ config X86
         select ARCH_HAS_CACHE_LINE_SIZE
         select ARCH_HAS_CPU_CACHE_INVALIDATE_MEMREGION
         select ARCH_HAS_CPU_FINALIZE_INIT
+       select ARCH_HAS_CPU_RELAX
         select ARCH_HAS_CURRENT_STACK_POINTER
         select ARCH_HAS_DEBUG_VIRTUAL
         select ARCH_HAS_DEBUG_VM_PGTABLE        if !X86_PAE
@@ -363,9 +364,6 @@ config ARCH_MAY_HAVE_PC_FDC
  config GENERIC_CALIBRATE_DELAY
         def_bool y

-config ARCH_HAS_CPU_RELAX
-       def_bool y
-
  config ARCH_HIBERNATION_POSSIBLE
         def_bool y


