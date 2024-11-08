Return-Path: <kvm+bounces-31204-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 946929C138A
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 02:20:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 871291C22498
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 01:20:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29E45BA49;
	Fri,  8 Nov 2024 01:20:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Uyuywwk/";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="xFWk3q/N"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E7518F7D
	for <kvm@vger.kernel.org>; Fri,  8 Nov 2024 01:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731028817; cv=fail; b=jfkC0S7kmzCC04CrGOLoRdsWUCZlr/zZ3yiLuME3UOxmXmf+c4EziaaajymErz9sy/JgCRWN4HUiDAUpFQdtT6rQW1roWc/sl0EHBbEhZYKFfutl4QTUQ9Hxlu3LoTn7/Mx5kyz8YUadA5IeOXRf5eqOpa/DwqRdL4OC/90wrZo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731028817; c=relaxed/simple;
	bh=cw5oGW4Zw3uQ0BawcnSDFESMCAeY0Jm6H//lVpRQnFE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=a9eLyefhUYLm6g+3x0Xlx02hnPzeqFQNvBY9mslSTiyoB2slWwIVZ3sde8I6V2dwDLPrgXl5n6OhPhLsA8ptCI8bZeKHcJr8ChfbnhMqbHbOiYHGkb/NN9rms2Pa8cYspwq6tDZM1qYh7jTvAHJnaLgxdvNfvQMuQoRmapTnYYA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Uyuywwk/; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=xFWk3q/N; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4A7MtkWD017556;
	Fri, 8 Nov 2024 01:19:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=ZTn2XrXjGJ1j8LLSbPzSjPljdpkKoG+52KjJyJiFhyA=; b=
	Uyuywwk/h10m19jYp50iqOhQdECGFQ/H/rSuuabwezgyDh6Kf9JoHWVhatD74Fss
	ODNtqUqWQWZdSkfLJLUpxMXFyuSeIuPwlTJDtabQaE4a/jwNbKJH1ziaj2E6PpxE
	txHsxLZw+OTXHEtDDmwi/kn1DjeCgkFEQ86TCWsUP92/VrdljiytKWcb0Q+HqYSF
	oNF0ObN4LArb8z8TX6juCLug9AWYn0yS8RJ0hSTLr40oeP+FGYW3rMIc0Ut0oT1P
	6QLP6FB0ua5bFhk1jeis0tKmcD87pX3Sz3G7YFFYgxiCfFsMPK2O0WBIvMhvbLtf
	ReC3QEsqTm8BWLqFq+6RfQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42s6gjg5wk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 08 Nov 2024 01:19:48 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4A7Mj6DR036304;
	Fri, 8 Nov 2024 01:19:48 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2046.outbound.protection.outlook.com [104.47.56.46])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 42nahh5jw1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 08 Nov 2024 01:19:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=E+pWcMg2Ph6f8lhNPHP3HOl95yWnkoJ2ACN0hWSmHvAvzykU1fxcvCR1tJl8ZW1y1ys5yFrUSr49I/5BoDDgbiycPm8G7aGYrnflepnncedYiq5xwZt0nThMX7E6Ls4ZWNZXk1K5qdU/U/B1MN/Ak15780IeCX+Ty//G9/b7fcjYCFF0dTMe+v2Ivk3BLgtow1yEHGusW1kgScWDUK3llle1C3JXfCz/gUB8y070aj/72Y6dzUmG0aCGw4WKyk6sCV5VajHE989V1Z3mkCauVmJCd7X5zKIjzKypmOm7ZwhMlDmD1tS0lBHbScMN69uX/+06HGZ/fk0as1mHbc6X4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZTn2XrXjGJ1j8LLSbPzSjPljdpkKoG+52KjJyJiFhyA=;
 b=O3iNOMqJZlBTR1vxcCb6nBizZAQC5o2ju1eEKXC4/REREU5cLbMQ4XjTF8B7ppZSpNlVZnZtH8+Ef0eknnM6LvNeckvbU2vN+fPUOkI1L5Ncvgr1rfnsvpER58NUkpXLBm4Hjcpt5dgdKF6Zott8zK8YwSE4CarubheIqTV3kX3/pjxJGPCf5Tugp3KHaUb/sgKdaM3oUfYxpfkx3IU7a4UFC7sDcm3a2A8W687LagKz+NDmEhu8NAK1nqPvoP+4o7u24u9QAbujwuGZ9mVUqaWU9ijplHr6GoBEwMVaJLJnNM6Ex9N+h4MFTpcN+kyX5FY3m3PQh9x3cFD+Q/YKcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZTn2XrXjGJ1j8LLSbPzSjPljdpkKoG+52KjJyJiFhyA=;
 b=xFWk3q/NlFv6SxOrFgL5xWEvAAykJe1M+m9SWU60B3vJyGpM4Jf7rx/6jZ+nF0tkGrzexzHJKFny3xLqD6BTkqJTb6GwVcugnVKUv9zh/TQK8T15o1DmpPhzLTd8Yryl8sVB4pcndEWZMKtQVtPGWRb3VTYOl2ienksgUK7D9pc=
Received: from SJ0PR10MB6430.namprd10.prod.outlook.com (2603:10b6:a03:486::20)
 by SA1PR10MB6544.namprd10.prod.outlook.com (2603:10b6:806:2bb::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.19; Fri, 8 Nov
 2024 01:19:42 +0000
Received: from SJ0PR10MB6430.namprd10.prod.outlook.com
 ([fe80::e879:90c:8ea8:63a9]) by SJ0PR10MB6430.namprd10.prod.outlook.com
 ([fe80::e879:90c:8ea8:63a9%5]) with mapi id 15.20.8137.019; Fri, 8 Nov 2024
 01:19:42 +0000
Message-ID: <4b73133b-1ce5-4eba-a77b-f595e02a942e@oracle.com>
Date: Thu, 7 Nov 2024 17:19:37 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/7] target/i386/kvm: reset AMD PMU registers during VM
 reset
To: Maksim Davydov <davydov-max@yandex-team.ru>
Cc: pbonzini@redhat.com, mtosatti@redhat.com, sandipan.das@amd.com,
        babu.moger@amd.com, zhao1.liu@intel.com, likexu@tencent.com,
        like.xu.linux@gmail.com, zhenyuw@linux.intel.com, groug@kaod.org,
        lyan@digitalocean.com, khorenko@virtuozzo.com,
        alexander.ivanov@virtuozzo.com, den@virtuozzo.com, joe.jin@oracle.com,
        qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20241104094119.4131-1-dongli.zhang@oracle.com>
 <20241104094119.4131-6-dongli.zhang@oracle.com>
 <a7f9c3c9-09af-4941-b137-2cb83ef8ceb3@yandex-team.ru>
Content-Language: en-US
From: dongli.zhang@oracle.com
In-Reply-To: <a7f9c3c9-09af-4941-b137-2cb83ef8ceb3@yandex-team.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BN8PR07CA0033.namprd07.prod.outlook.com
 (2603:10b6:408:ac::46) To SJ0PR10MB6430.namprd10.prod.outlook.com
 (2603:10b6:a03:486::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB6430:EE_|SA1PR10MB6544:EE_
X-MS-Office365-Filtering-Correlation-Id: 4ae61f05-80d5-4eb3-4a1a-08dcff936c51
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QUZJTTZ5a2pDaVV4RFRXVEJmaWZGemIxaHVFY2hOUHdKcDlFKzJrSm9mTU1O?=
 =?utf-8?B?RmhDdnVxelBvcEtlVFpjMUZpdnYrZmYxUHJxVW5GS3F5eTJBUVdnTWhyT3JV?=
 =?utf-8?B?d3p2SnNlSnNJMjJMdC92a20vNi9ldDN5cHZGTTZvemEzMU5aZ1FmMTZGSngw?=
 =?utf-8?B?elBzNXE2L3hRa25tTzFaV0dDczdMdHdNcXJsZGI1RFlncTR1WEN5ZXduQUFN?=
 =?utf-8?B?eFU4V3h2TWJEZjJrT1lPcm5CQUQrRkc5QzlWaXN3MVFUSXBVdzR2azNSZVVu?=
 =?utf-8?B?RTdRaHNvRE5Nc2VZbkZtRU9ZNzd6VVlDSXVxaW91ckMvWVZCVVM3dU1mdkhx?=
 =?utf-8?B?TVRzeXo1SUxnOVNtWDBzenJ4UFYzYUsyZ3FQZGRQeVZ6dlQvN0F3NmN2L3Ew?=
 =?utf-8?B?MXZVSHB1dzVSZjZmSG56Z0RCc0Y0T2JZcUxLM0hVTTBZNmdzMTIvQjhNWEM3?=
 =?utf-8?B?MWhTcTliMnNoV3lQbU01SExzWE1hbGxwWVFpVlR2MWExdjdsNXhVTmo1Yjky?=
 =?utf-8?B?azdFbXMvTUM5U25zd2wyWHhzT3I2ODE2WXFhelpOOGlENVd1RjZnMlFacG4y?=
 =?utf-8?B?cFRuc0FJbDhabVJ2bjArbmxQWkR2endibHRhbHlRRXFqWkZvWGVGU1AySkJN?=
 =?utf-8?B?VmVLb00wWStXdEdlcGExejJSK0ZYbzJNaHg4TmV2V1cxWUxjTXZsK0ZYUWhC?=
 =?utf-8?B?bkpYWldKR3p3Mm91aFVxdis4d2orWXgxdWpnSFVUZnR3Z0I3SFhRSU40Ymdo?=
 =?utf-8?B?V1p4UW1MNEUvajJaQ3NjWXNWbFJOQVZYUTlSUE1UL0hNYnRtZXFycnVrc3Y5?=
 =?utf-8?B?YTJsVnNiL0JjSXk1dFB5MEw0aFcrVHBzTjlqajd1OUZsYVRaRlhVQWVMS0JU?=
 =?utf-8?B?b09uV0xLNFBlTFhWVFlYU1MwdTMwcmZkNVVBYlJ2cXVrMUl0aEVQQkZrNHJl?=
 =?utf-8?B?ZVJZd01jc0J4SlN0UE1pekNXeFZQMmc0YVNiUkhsV3QwVFQ4UmtiUkJNcEFy?=
 =?utf-8?B?VzRzTU1oek1qTGtCTzhZendCd21qRmtOMGcxM0JDQ0ZuWU12bUo3eFFYemwr?=
 =?utf-8?B?MWlxcHZRU1RGaUUzSndvcm5wQ3JCRnArZXd6b21PZ1YvcVRBRysrbTlDam41?=
 =?utf-8?B?b1JxS1lBc29mUHpEd2JKTlUzUDBsU3RzWUl1TUJ0dXdiOTFEK2xoaU0zcjRL?=
 =?utf-8?B?Y3Y4dGF4Y2lSNDZjLzVvVU1sQ0J2WFVXQzF4azQzb3V4ZVlFQ2Ura09xenZX?=
 =?utf-8?B?azUvdVl5ZEgyNjVjSjRyWEJkK3c2ak5lNTVZTnA1SUUrOGNSeFY5WHBaMnQ3?=
 =?utf-8?B?cjArUGR2Z2M0ekN2UGhYdDJEOE5LTm1QaHJYUWdNOStRTVJZSjhpaE9LYzZW?=
 =?utf-8?B?ajdQL0tDdnBOaU5EQmtGWnVlNFVUUERHQm5pdnVtSGN5NVNoYWZBckpsYlJq?=
 =?utf-8?B?Zjd2cUM1bFJiVldIaTIrckZwTW1kUDYwK1M4UmhtQ3c3eWZhM2VTOXVwWDk3?=
 =?utf-8?B?ZVBxalp3NW0rRDhFZ0R2OUdlcmdwbHo5aWN4L1dTSk02UUh0MWFBekg1RzJX?=
 =?utf-8?B?ak1lVEQ3eDZxUG1oWlhBY2luZjBZNkZ2Z2hYQm9SUVNObFZvTDJNOXZiOFh4?=
 =?utf-8?B?RTlSOTN0djcvRmJGWDRJU2orYm03eENxejBhTjdqUW83ZDZlSzVmQzJFeU9k?=
 =?utf-8?B?cnhHaldEZFFJZVAzbXVvUkpSVTVTWkpHd0lzS09WS2JUUEdtNkxaWmFxUmZa?=
 =?utf-8?Q?7nO+C9E6F9vVqcMxnGiH6myHXaQdXeqhE+y2/O1?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB6430.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VERCTEJ1cy9HOS9Zb0ZYQUMvU1RzaW9KL3pKa3V6K0dqT3dhU3o4dGFaUnJP?=
 =?utf-8?B?YjFBR0JzNUhMVytsZEl0UUFVK1dCL1I2NDlSY3FNVStDcWJxWkJ1eHA1N2lt?=
 =?utf-8?B?OEtHanpHcCtrMUxrZ1VHbE5uSjR0VG5QUlZjZFVMaXpSQzIvU1gvQTVWWjF1?=
 =?utf-8?B?Tjk1cWF5N0dRSG5xdWVHdll0L0pqaFJ0N2hjTTdTWFlIQWprU3hJeExlaDkr?=
 =?utf-8?B?azZPbzZPMkNLeUVDRFFySERwTHFKRlRCZnFINjArZjNTTVgwNGtSRFVjbFk4?=
 =?utf-8?B?NStOdmFlTC9ONVpiOU1GR1V4dnhPNlNzMHZ4RUFIamhiYzRLVlptbkdPTGky?=
 =?utf-8?B?Y1V5ODdkK3JMRDAxVGYwU2ptU1pHNzJCTWNua1lKUFAya0t0SVNOaTFGSTRO?=
 =?utf-8?B?aEptaUhlNXNHRzJjREdla0JjV3hNaTJ3VjFQYVV0TjJWUGtSaFNXQWNYL3py?=
 =?utf-8?B?d0RCaXBKN1J5am40Z3d6NWVxb2ZPQlQrVDJjcmxrKzB6V2syZThNT2RJUUZy?=
 =?utf-8?B?RjRRVUxwRUxDb0dMRnRON2xWN2ZvajBNSWRIR2t6bFBMaHgxQm1oSVdVVkZX?=
 =?utf-8?B?L3BpMlorYVk0bmI3RFhJTC9QOGZzK0J0ZWNheW4ySDJkcEV3RE5OMGRqYk56?=
 =?utf-8?B?NU44Wk93VG5VUkNPTEhhcm9IY0trNDA2dEp1R25INmVGNGFwV004d1FYeWNs?=
 =?utf-8?B?eDNuWGhKT2w0SHExWTNIdHVNOUgxS2FQLzZPMjJpcTNPWXlHajl3SjZKMCtN?=
 =?utf-8?B?QWlRNVcvQURCbG01L3JXQytWalJqYWJUdEpRQUdEcy9EV05peUdvWjlXK083?=
 =?utf-8?B?TlZ1NisrQzRaTHVRT3YrWm02RUE5UGpYRThkbU5pTkVUcU1rQjJJdHR2R0V2?=
 =?utf-8?B?S0gyQU5aNC8zQ2JxclFCZ0JoRmczZnJ4Syt1YWxqMnRCVU9lT1NaeUdxMi9j?=
 =?utf-8?B?YS80d2FsR1FWV3ZHSkxWQ3ZkdlJJTE1qUy82aHZuRFdwWHhScUlRdlJEMEMz?=
 =?utf-8?B?SGdReGNSMHk5QTRTU0xINS81ZmdTSkV1SFVpRmFoQjZjOXRTRWl6Ky9YN1RU?=
 =?utf-8?B?ZjZBb045bUxpbER6aFJWbVd4RlZqUXFRVFdnTWlWZTFmVS95bDV3YjRJWDFJ?=
 =?utf-8?B?TlIreGRwblZCZmZlRHdOSkVRclhLTWhJT3pVMzVWcDV6bE9WT254c20vdGxu?=
 =?utf-8?B?Q3hyMmJMTE0zSldpcFMxQWhEUGV0b2hJSUY4SGc0cngrZk12Tmk2dE1mRHV6?=
 =?utf-8?B?b3BWREtBS1N2UndZK3MxZWNJdGc5OUpvR0RCQWk3VGZyUlVwNkRtVWxKQWt1?=
 =?utf-8?B?ZTVHdlg1dDIxditBNVNlblg3cGgzL1ZRQTd0czVlODdoVEcwOGdrNFRNQTdk?=
 =?utf-8?B?ams5bVFnMmNuTUsyZmlYWlpxNW1ydlJnSloxU1ZDYmhrK05rMjJqVHZlZnNL?=
 =?utf-8?B?N1lkRXRsQjBvVURjelZNTElSd1hoa2dSK05HRGg3Q2psMmF2bWNIRFhJbGps?=
 =?utf-8?B?dWlHNjFJa09hdHFJbnFsbzRvemhxcTloWmgzZ3U5emc3N1g3QzRkV2lDMnFS?=
 =?utf-8?B?OWttanhzbG9HTU5kcCtBeDkyYmZvM3k2NUQvVE82WW9CR0l3MCtyYVZpLzF6?=
 =?utf-8?B?c1N3K2hpS3gvV3VYeHV2blhlbUJERDJISTlVaU1EWG9ocXdpaVBnNXFIY29H?=
 =?utf-8?B?bWVpL0o4RGRabzZBMFBieWdKWnNZbTFPM29yR1pDR3NSTlFWb25yVGZZSFhG?=
 =?utf-8?B?MjI3RUNFaTlsQk5YRDJPOW5LNHZVNEMzMVpyQW01cEUvWDltTDU1cVR1TUZY?=
 =?utf-8?B?YjJSQ0hOSDloeTNaQy9lUDIyL2RNenV5ZVJEQTJYRy9aY2dVOHZVNkY5OXZt?=
 =?utf-8?B?ZkJWOTlPc0hNbmFvN3dFOWsvMk9tSjg5V1BlWlBITUVzUkRXSk1pWE1QdCtG?=
 =?utf-8?B?YVNqZmtVNjVkaHdieldkS1dnY0c1bkQ0ZVBzM3FyRFBEM1FFdnNFQWVwemMr?=
 =?utf-8?B?TjdCY1ZwcG4yTkNYbHlmRjZtNG85THNBVWZqOWlOVnpWdTNVSVZlMU5yOGdE?=
 =?utf-8?B?NGFqUlBjMklkYUpJUVFzZmptWjlIY2VGdW5FTzQ5RlNITm1aazdDK3NEakZN?=
 =?utf-8?Q?DIDwyjerKGntFiEdRCmJaMaXI?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	hJdBdhmrGeDrqSx67F1D17dYJOdL2TzUOf/mCu3anIC3zR792gE7YJpkKlX75d2kCK60mw9Pel1IK4ItuPd6xp+O2EOfTaI2hZwRgBrqh61vQKTf9l1eGJZWEupE8DHWKOB73y4q9QE67MgDxDyZI4dsaLktFfx6KCkmbArCDgllcGz9Tk5jrdUUs4PWuNstcjXuh2FuTBJizOJezw9qpfPcb2s7asI+8KLXG+JgjKy6yW7iffwR7trqljybVQAM0c9RoNSEjO6D4p3d6y4UsrMLsKpFOloiCW2VffszhxIAVNkm/edvBpZ/wIQ2ZIZSNdZDLKHyZwXem8WewIZ5FkxS1HuCs8qVgwgt4RfbY7eZu17UxLL9wBTzaE2fzT8OP152fX2eXHKbtZMTiDFw9GeQ54BG/n9sMtl4NYUikoF8ATArTLvTRZQN8duoPU9lOgi0rvhoyZiXVDjuGxbnZNEhMrOLxnbJyfPVs+RDWfsYEPIo5l3TlazBnKz78dN+LgZGVntB/e6LqNFn0k3PWqIvf0ZSH+VW8sAc08bqmp2+a3c49j0Ol2oa3rUsEwr31qBX5q4qdod5w7H/0r0k6TUJsXByZzWdEVBQpbEhBKE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ae61f05-80d5-4eb3-4a1a-08dcff936c51
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB6430.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2024 01:19:42.4632
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vBTDxqQp3n2xJoINBb6W1ITLFls5hUj/0fm0bi6Bnzjku84yUyDB5OgR7Ibycp8GaghmLQ1nNRNCbwqNTQbpuw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6544
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-07_10,2024-11-07_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 spamscore=0 mlxlogscore=999 mlxscore=0 phishscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2409260000 definitions=main-2411080010
X-Proofpoint-GUID: sY6yD7TZVcbSXEpfTJgul93FSNy1tDFn
X-Proofpoint-ORIG-GUID: sY6yD7TZVcbSXEpfTJgul93FSNy1tDFn

Hi Maksim,

On 11/7/24 1:00 PM, Maksim Davydov wrote:
> 
> 
> On 11/4/24 12:40, Dongli Zhang wrote:
>> QEMU uses the kvm_get_msrs() function to save Intel PMU registers from KVM
>> and kvm_put_msrs() to restore them to KVM. However, there is no support for
>> AMD PMU registers. Currently, has_pmu_version and num_pmu_gp_counters are
>> initialized based on cpuid(0xa), which does not apply to AMD processors.
>> For AMD CPUs, prior to PerfMonV2, the number of general-purpose registers
>> is determined based on the CPU version.
>>
>> To address this issue, we need to add support for AMD PMU registers.
>> Without this support, the following problems can arise:
>>
>> 1. If the VM is reset (e.g., via QEMU system_reset or VM kdump/kexec) while
>> running "perf top", the PMU registers are not disabled properly.
>>
>> 2. Despite x86_cpu_reset() resetting many registers to zero, kvm_put_msrs()
>> does not handle AMD PMU registers, causing some PMU events to remain
>> enabled in KVM.
>>
>> 3. The KVM kvm_pmc_speculative_in_use() function consistently returns true,
>> preventing the reclamation of these events. Consequently, the
>> kvm_pmc->perf_event remains active.
>>
>> 4. After a reboot, the VM kernel may report the following error:
>>
>> [    0.092011] Performance Events: Fam17h+ core perfctr, Broken BIOS detected,
>> complain to your hardware vendor.
>> [    0.092023] [Firmware Bug]: the BIOS has corrupted hw-PMU resources (MSR
>> c0010200 is 530076)
>>
>> 5. In the worst case, the active kvm_pmc->perf_event may inject unknown
>> NMIs randomly into the VM kernel:
>>
>> [...] Uhhuh. NMI received for unknown reason 30 on CPU 0.
>>
>> To resolve these issues, we propose resetting AMD PMU registers during the
>> VM reset process.
>>
>> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
>> ---
>>   target/i386/cpu.h     |   8 +++
>>   target/i386/kvm/kvm.c | 156 +++++++++++++++++++++++++++++++++++++++++-
>>   2 files changed, 161 insertions(+), 3 deletions(-)
>>
>> diff --git a/target/i386/cpu.h b/target/i386/cpu.h
>> index 59959b8b7a..0505eb3b08 100644
>> --- a/target/i386/cpu.h
>> +++ b/target/i386/cpu.h
>> @@ -488,6 +488,14 @@ typedef enum X86Seg {
>>   #define MSR_CORE_PERF_GLOBAL_CTRL       0x38f
>>   #define MSR_CORE_PERF_GLOBAL_OVF_CTRL   0x390
>>   +#define MSR_K7_EVNTSEL0                 0xc0010000
>> +#define MSR_K7_PERFCTR0                 0xc0010004
>> +#define MSR_F15H_PERF_CTL0              0xc0010200
>> +#define MSR_F15H_PERF_CTR0              0xc0010201
>> +
>> +#define AMD64_NUM_COUNTERS              4
>> +#define AMD64_NUM_COUNTERS_CORE         6
>> +
>>   #define MSR_MC0_CTL                     0x400
>>   #define MSR_MC0_STATUS                  0x401
>>   #define MSR_MC0_ADDR                    0x402
>> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
>> index ca2b644e2c..83ec85a9b9 100644
>> --- a/target/i386/kvm/kvm.c
>> +++ b/target/i386/kvm/kvm.c
>> @@ -2035,7 +2035,7 @@ full:
>>       abort();
>>   }
>>   -static void kvm_init_pmu_info(CPUX86State *env)
>> +static void kvm_init_pmu_info_intel(CPUX86State *env)
>>   {
>>       uint32_t eax, edx;
>>       uint32_t unused;
>> @@ -2072,6 +2072,80 @@ static void kvm_init_pmu_info(CPUX86State *env)
>>       }
>>   }
>>   +static void kvm_init_pmu_info_amd(CPUX86State *env)
>> +{
>> +    int64_t family;
>> +
>> +    has_pmu_version = 0;
>> +
>> +    /*
>> +     * To determine the CPU family, the following code is derived from
>> +     * x86_cpuid_version_get_family().
>> +     */
>> +    family = (env->cpuid_version >> 8) & 0xf;
>> +    if (family == 0xf) {
>> +        family += (env->cpuid_version >> 20) & 0xff;
>> +    }
>> +
>> +    /*
>> +     * Performance-monitoring supported from K7 and later.
>> +     */
>> +    if (family < 6) {
>> +        return;
>> +    }
>> +
>> +    has_pmu_version = 1;
>> +
>> +    if (!(env->features[FEAT_8000_0001_ECX] & CPUID_EXT3_PERFCORE)) {
>> +        num_pmu_gp_counters = AMD64_NUM_COUNTERS;
>> +        return;
>> +    }
>> +
>> +    num_pmu_gp_counters = AMD64_NUM_COUNTERS_CORE;
>> +}
> 
> It seems that AMD implementation has one issue.
> KVM has parameter `enable_pmu`. So vPMU can be disabled in another way, not only
> via KVM_PMU_CAP_DISABLE. For Intel it's not a problem, because the vPMU
> initialization uses info from KVM_GET_SUPPORTED_CPUID. The enable_pmu state is
> reflected in KVM_GET_SUPPORTED_CPUID.  Thus no PMU MSRs in kvm_put_msrs/
> kvm_get_msrs will be used.
> 
> But on AMD we don't use information from KVM_GET_SUPPORTED_CPUID to set an
> appropriate number of PMU registers. So, if vPMU is disabled by KVM parameter
> `enable_pmu` and pmu-cap-disable=false, then has_pmu_version will be 1 after
> kvm_init_pmu_info_amd execution. It means that in kvm_put_msrs/kvm_get_msrs 4
> PMU counters will be processed, but the correct behavior in that situation is to
> skip all PMU registers.
> I think we should get info from KVM to fix that.
> 
> I tested this series on Zen2 and found that PMU MSRs were still processed during
> initialization even with enable_pmu=N. But it doesn't lead to any errors in QEMU

Thank you very much for the feedback and helping catch the bug!

When enable_pmu=N, the QEMU (with this patchset) cannot tell if vPMU is
supported via KVM_CAP_PMU_CAPABILITY.

As it cannot disable the PMU, it falls to the legacy 4 counters.

It falls to 4 counters because KVM disableds PERFCORE on enable_pmu=Y, i.e.,

5220         if (enable_pmu) {
5221                 /*
5222                  * Enumerate support for PERFCTR_CORE if and only if KVM has
5223                  * access to enough counters to virtualize "core" support,
5224                  * otherwise limit vPMU support to the legacy number of
counters.
5225                  */
5226                 if (kvm_pmu_cap.num_counters_gp < AMD64_NUM_COUNTERS_CORE)
5227                         kvm_pmu_cap.num_counters_gp = min(AMD64_NUM_COUNTERS,
5228
kvm_pmu_cap.num_counters_gp);
5229                 else
5230                         kvm_cpu_cap_check_and_set(X86_FEATURE_PERFCTR_CORE);
5231
5232                 if (kvm_pmu_cap.version != 2 ||
5233                     !kvm_cpu_cap_has(X86_FEATURE_PERFCTR_CORE))
5234                         kvm_cpu_cap_clear(X86_FEATURE_PERFMON_V2);
5235         }


During the bootup and reset, the QEMU (with this patchset) erroneously resets
MSRs for the 4 PMCs, via line 3827.

3825 static int kvm_buf_set_msrs(X86CPU *cpu)
3826 {
3827     int ret = kvm_vcpu_ioctl(CPU(cpu), KVM_SET_MSRS, cpu->kvm_msr_buf);
3828     if (ret < 0) {
3829         return ret;
3830     }
3831
3832     if (ret < cpu->kvm_msr_buf->nmsrs) {
3833         struct kvm_msr_entry *e = &cpu->kvm_msr_buf->entries[ret];
3834         error_report("error: failed to set MSR 0x%" PRIx32 " to 0x%" PRIx64,
3835                      (uint32_t)e->index, (uint64_t)e->data);
3836     }
3837
3838     assert(ret == cpu->kvm_msr_buf->nmsrs);
3839     return 0;
3840 }

Because enable_pmu=N, the KVM doesn't support those registers. However, it
returns 0 (not 1), because the KVM does nothing in the implicit else (i.e., line
4144).

3847 int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
3848 {
... ...
4138         case MSR_K7_PERFCTR0 ... MSR_K7_PERFCTR3:
4139         case MSR_P6_PERFCTR0 ... MSR_P6_PERFCTR1:
4140         case MSR_K7_EVNTSEL0 ... MSR_K7_EVNTSEL3:
4141         case MSR_P6_EVNTSEL0 ... MSR_P6_EVNTSEL1:
4142                 if (kvm_pmu_is_valid_msr(vcpu, msr))
4143                         return kvm_pmu_set_msr(vcpu, msr_info);
4144
4145                 if (data)
4146                         kvm_pr_unimpl_wrmsr(vcpu, msr, data);
4147                 break;
... ...
4224         default:
4225                 if (kvm_pmu_is_valid_msr(vcpu, msr))
4226                         return kvm_pmu_set_msr(vcpu, msr_info);
4227
4228                 /*
4229                  * Userspace is allowed to write '0' to MSRs that KVM reports
4230                  * as to-be-saved, even if an MSRs isn't fully supported.
4231                  */
4232                 if (msr_info->host_initiated && !data &&
4233                     kvm_is_msr_to_save(msr))
4234                         break;
4235
4236                 return KVM_MSR_RET_INVALID;
4237         }
4238         return 0;
4239 }
4240 EXPORT_SYMBOL_GPL(kvm_set_msr_common);

Fortunately, it returns 0 at line 4238. No error is detected by QEMU.

Perhaps I may need to send message with a small patch to return 1 in the
implicit 'else' to kvm mailing list to confirm if that is expected.

However, the answer is very likely 'expected', because line 4229 to line 4230
already explain it.


Regarding the change in QEMU:

Since kvm_check_extension(s, KVM_CAP_PMU_CAPABILITY) returns 0 for both (1)
enable_pmu=Y, and (2) KVM_CAP_PMU_CAPABILITY not supported, I may need to use
g_file_get_contents() to read from the KVM sysfs parameters (similar to KVM
selftest kvm_is_pmu_enabled()).

> 
>> +
>> +static bool is_same_vendor(CPUX86State *env)
>> +{
>> +    static uint32_t host_cpuid_vendor1;
>> +    static uint32_t host_cpuid_vendor2;
>> +    static uint32_t host_cpuid_vendor3;
>> +
>> +    host_cpuid(0x0, 0, NULL, &host_cpuid_vendor1, &host_cpuid_vendor3,
>> +               &host_cpuid_vendor2);
>> +
>> +    return env->cpuid_vendor1 == host_cpuid_vendor1 &&
>> +           env->cpuid_vendor2 == host_cpuid_vendor2 &&
>> +           env->cpuid_vendor3 == host_cpuid_vendor3;
>> +}
>> +
>> +static void kvm_init_pmu_info(CPUX86State *env)
>> +{
>> +    /*
>> +     * It is not supported to virtualize AMD PMU registers on Intel
>> +     * processors, nor to virtualize Intel PMU registers on AMD processors.
>> +     */
>> +    if (!is_same_vendor(env)) {
>> +        return;
>> +    }
>> +
>> +    /*
>> +     * If KVM_CAP_PMU_CAPABILITY is not supported, there is no way to
>> +     * disable the AMD pmu virtualization.
>> +     *
>> +     * If KVM_CAP_PMU_CAPABILITY is supported, kvm_state->pmu_cap_disabled
>> +     * indicates the KVM has already disabled the pmu virtualization.
>> +     */
>> +    if (kvm_state->pmu_cap_disabled) {
>> +        return;
>> +    }
>> +
> 
> It seems that after these changes the issue concerning using
> pmu-cap-disable=true with +pmu on Intel platform (that Zhao Liu has mentioned
> before) is fixed

Can I assume you were going to paste some code below?

Regardless, I am going to following Zhao's suggestion to revert back to my
previous solution.

Thank you very much for the feedback!

Dongli Zhang

> 
>> +    if (IS_INTEL_CPU(env)) {
>> +        kvm_init_pmu_info_intel(env);
>> +    } else if (IS_AMD_CPU(env)) {
>> +        kvm_init_pmu_info_amd(env);
>> +    }
>> +}
>> +
>>   int kvm_arch_init_vcpu(CPUState *cs)
>>   {
>>       struct {
>> @@ -4027,7 +4101,7 @@ static int kvm_put_msrs(X86CPU *cpu, int level)
>>               kvm_msr_entry_add(cpu, MSR_KVM_POLL_CONTROL, env-
>> >poll_control_msr);
>>           }
>>   -        if (has_pmu_version > 0) {
>> +        if (IS_INTEL_CPU(env) && has_pmu_version > 0) {
>>               if (has_pmu_version > 1) {
>>                   /* Stop the counter.  */
>>                   kvm_msr_entry_add(cpu, MSR_CORE_PERF_FIXED_CTR_CTRL, 0);
>> @@ -4058,6 +4132,38 @@ static int kvm_put_msrs(X86CPU *cpu, int level)
>>                                     env->msr_global_ctrl);
>>               }
>>           }
>> +
>> +        if (IS_AMD_CPU(env) && has_pmu_version > 0) {
>> +            uint32_t sel_base = MSR_K7_EVNTSEL0;
>> +            uint32_t ctr_base = MSR_K7_PERFCTR0;
>> +            /*
>> +             * The address of the next selector or counter register is
>> +             * obtained by incrementing the address of the current selector
>> +             * or counter register by one.
>> +             */
>> +            uint32_t step = 1;
>> +
>> +            /*
>> +             * When PERFCORE is enabled, AMD PMU uses a separate set of
>> +             * addresses for the selector and counter registers.
>> +             * Additionally, the address of the next selector or counter
>> +             * register is determined by incrementing the address of the
>> +             * current register by two.
>> +             */
>> +            if (num_pmu_gp_counters == AMD64_NUM_COUNTERS_CORE) {
>> +                sel_base = MSR_F15H_PERF_CTL0;
>> +                ctr_base = MSR_F15H_PERF_CTR0;
>> +                step = 2;
>> +            }
>> +
>> +            for (i = 0; i < num_pmu_gp_counters; i++) {
>> +                kvm_msr_entry_add(cpu, ctr_base + i * step,
>> +                                  env->msr_gp_counters[i]);
>> +                kvm_msr_entry_add(cpu, sel_base + i * step,
>> +                                  env->msr_gp_evtsel[i]);
>> +            }
>> +        }
>> +
>>           /*
>>            * Hyper-V partition-wide MSRs: to avoid clearing them on cpu hot-add,
>>            * only sync them to KVM on the first cpu
>> @@ -4503,7 +4609,8 @@ static int kvm_get_msrs(X86CPU *cpu)
>>       if (env->features[FEAT_KVM] & (1 << KVM_FEATURE_POLL_CONTROL)) {
>>           kvm_msr_entry_add(cpu, MSR_KVM_POLL_CONTROL, 1);
>>       }
>> -    if (has_pmu_version > 0) {
>> +
>> +    if (IS_INTEL_CPU(env) && has_pmu_version > 0) {
>>           if (has_pmu_version > 1) {
>>               kvm_msr_entry_add(cpu, MSR_CORE_PERF_FIXED_CTR_CTRL, 0);
>>               kvm_msr_entry_add(cpu, MSR_CORE_PERF_GLOBAL_CTRL, 0);
>> @@ -4519,6 +4626,35 @@ static int kvm_get_msrs(X86CPU *cpu)
>>           }
>>       }
>>   +    if (IS_AMD_CPU(env) && has_pmu_version > 0) {
>> +        uint32_t sel_base = MSR_K7_EVNTSEL0;
>> +        uint32_t ctr_base = MSR_K7_PERFCTR0;
>> +        /*
>> +         * The address of the next selector or counter register is
>> +         * obtained by incrementing the address of the current selector
>> +         * or counter register by one.
>> +         */
>> +        uint32_t step = 1;
>> +
>> +        /*
>> +         * When PERFCORE is enabled, AMD PMU uses a separate set of
>> +         * addresses for the selector and counter registers.
>> +         * Additionally, the address of the next selector or counter
>> +         * register is determined by incrementing the address of the
>> +         * current register by two.
>> +         */
>> +        if (num_pmu_gp_counters == AMD64_NUM_COUNTERS_CORE) {
>> +            sel_base = MSR_F15H_PERF_CTL0;
>> +            ctr_base = MSR_F15H_PERF_CTR0;
>> +            step = 2;
>> +        }
>> +
>> +        for (i = 0; i < num_pmu_gp_counters; i++) {
>> +            kvm_msr_entry_add(cpu, ctr_base + i * step, 0);
>> +            kvm_msr_entry_add(cpu, sel_base + i * step, 0);
>> +        }
>> +    }
>> +
>>       if (env->mcg_cap) {
>>           kvm_msr_entry_add(cpu, MSR_MCG_STATUS, 0);
>>           kvm_msr_entry_add(cpu, MSR_MCG_CTL, 0);
>> @@ -4830,6 +4966,20 @@ static int kvm_get_msrs(X86CPU *cpu)
>>           case MSR_P6_EVNTSEL0 ... MSR_P6_EVNTSEL0 + MAX_GP_COUNTERS - 1:
>>               env->msr_gp_evtsel[index - MSR_P6_EVNTSEL0] = msrs[i].data;
>>               break;
>> +        case MSR_K7_EVNTSEL0 ... MSR_K7_EVNTSEL0 + 3:
>> +            env->msr_gp_evtsel[index - MSR_K7_EVNTSEL0] = msrs[i].data;
>> +            break;
>> +        case MSR_K7_PERFCTR0 ... MSR_K7_PERFCTR0 + 3:
>> +            env->msr_gp_counters[index - MSR_K7_PERFCTR0] = msrs[i].data;
>> +            break;
>> +        case MSR_F15H_PERF_CTL0 ... MSR_F15H_PERF_CTL0 + 0xb:
>> +            index = index - MSR_F15H_PERF_CTL0;
>> +            if (index & 0x1) {
>> +                env->msr_gp_counters[index] = msrs[i].data;
>> +            } else {
>> +                env->msr_gp_evtsel[index] = msrs[i].data;
>> +            }
>> +            break;
>>           case HV_X64_MSR_HYPERCALL:
>>               env->msr_hv_hypercall = msrs[i].data;
>>               break;
> 


