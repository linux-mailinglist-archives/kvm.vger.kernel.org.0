Return-Path: <kvm+bounces-7292-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4663883FA0B
	for <lists+kvm@lfdr.de>; Sun, 28 Jan 2024 22:24:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 827E22830B6
	for <lists+kvm@lfdr.de>; Sun, 28 Jan 2024 21:24:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A12B51E873;
	Sun, 28 Jan 2024 21:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aZuoExMx";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="gaHaosrr"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AE1933CFB;
	Sun, 28 Jan 2024 21:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706477050; cv=fail; b=lc8pgf6Bjf0Xre0GO/hPRWQ0mWA01us2Gs8MItFP9zBsNmXUX8kvr6CkNDUyzbaiTa5DFFGbt1bg0GCmF1e7GIw3AQ6d8GWEGWfYy8O6lNR+p54e0BbG9y5CZdYeau2q+ou3eLCa8KtkC+silLA8CuQ2q8uHpeABHDdqLG39nWE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706477050; c=relaxed/simple;
	bh=FjybJD1dcpGmKjPIMZsWOk4LOAdbE/dSXH6XVCSqBWk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=A/YB5bYwEEQ9FwpCnb5AnHTZFHpbsspfGWnNwqlgsOGPIqAl1idyfCpq3IDb/UxCdeO4atpDggLF6tfpRKfINHoaMNHKbsXkEterBNbceFFhG68euxQ4O8gmhF4c4ZhdgDoDDTLv2YJd4TQzvQLGqtFm4nu0ls6bnpXo9w5bMcM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=aZuoExMx; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=gaHaosrr; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40SKgvBs023682;
	Sun, 28 Jan 2024 21:23:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=6Ucx6oqvJrsZZBb8dE2/OxPOB1nuTBCRgsbJwQOyV7k=;
 b=aZuoExMx3ZB5sKotQJwo3e49xN+f+ICgX1fbGbj/4BQLaNTIzOvKGaaRgx5pgSJy9/vn
 HSMLtidwtsl28tpMGLYXlp5TgIN7qaZk6UrDG1LxUxYQZM6dwjqD0rVrC6k5jA3lyKiN
 ca3XyLRwdsC2uF8jzB2vK4co/GUL/aSvQKVWE+sc14i/QYTlTxFjMUFG4EVxIMxzNCjL
 CmDg7qydgVkIgPPecBFS+qy0UA6N5+TISAVikFzjQH1CQVc+T6q2UcGQSh7uALljeS0+
 jLRPFLA925Dgm5FjxFukyh1tXohPW43KoXCkhRh+XojWDvsbuox0tGJEK4gwHYRJIwuw CA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3vvrrcag3v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 28 Jan 2024 21:23:02 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 40SJaVsq014588;
	Sun, 28 Jan 2024 21:23:01 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3vvr94uvvu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 28 Jan 2024 21:23:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dVcwtpK8PTi5wlfa4cuRVKN74R6X6me/594WspeReJBCqd++MxkiQ3ijhEUOsyNOIRVuWTtVZ0Wa0IVXt57GHZWBsDsrVyLewnnu0rXEOX+9ULPCX92AWnrAk8VLkIIwts7yzW+eYBqypC+D9nL2q88WkmuCn+YB1jSW1ScSHHfLRARLuBFZOzZnSayer3FhHmKw4razE/YEMEAqbzBykx4rNCv2/07P0Zn6ESPf+niKhrMcHmpX7CKrTDXbm12eHVWnWlF8M4KhOoxXlKX1E0MahfQoxroUF7fJRSJ8s43d1Z4UcPLSjvl6kgoFwicltZIEOu5K6IHVi3hoqJOw4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6Ucx6oqvJrsZZBb8dE2/OxPOB1nuTBCRgsbJwQOyV7k=;
 b=MXvWVkDu7oUfsHvExRHzSzB/Ja0fnKGhQu4UvCIvn9/J1ArWgodv58G6FQJzm3afRFwZBC3wy6rVGtuICV5kD0JJYHWw1tbzvWYSXxAFOJOepM1qEiKq+Y64rTKTWm9riNVtcG0q1bvWPDf8onu1cFAG4FI9vw9NiUuSBgdFzm17shoI2VemH7n+61vsG6KBO6OiGnRKs/cY8txrKVNvDOOvI9074pBkN2wvQvF1kKapCM1V2gvXgj+L391lVGuIerpA8dAXLlRZOMss5blJWW0jOoGAMo30ERQtOOLA9i2GwVJ7qDY3FB2obEl28u8ltx3rdK85e7AmMp1nOuSkYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6Ucx6oqvJrsZZBb8dE2/OxPOB1nuTBCRgsbJwQOyV7k=;
 b=gaHaosrr+IEgXFUclADpP71aaibAZmLX+u00QKU7GfnaFoR/W/XQnZQgPLyByHlMjxFY/lmdBl2I4MpFe8PI+iAuTCikhGUTMuBOlSQu7PzFAOmirM644o36eMQjbMYJfu+zXzFCzuew7pcrLZDaVTJI+t71wrQzINVhKJkzJTM=
Received: from PH0PR10MB5894.namprd10.prod.outlook.com (2603:10b6:510:14b::22)
 by SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.26; Sun, 28 Jan
 2024 21:22:57 +0000
Received: from PH0PR10MB5894.namprd10.prod.outlook.com
 ([fe80::6fec:c8c5:bd31:11db]) by PH0PR10MB5894.namprd10.prod.outlook.com
 ([fe80::6fec:c8c5:bd31:11db%5]) with mapi id 15.20.7228.029; Sun, 28 Jan 2024
 21:22:57 +0000
Message-ID: <1b3650c5-822e-4789-81d2-0304573cabd9@oracle.com>
Date: Sun, 28 Jan 2024 23:22:50 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7/7] cpuidle/poll_state: replace cpu_relax with
 smp_cond_load_relaxed
Content-Language: ro
To: Will Deacon <will@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        catalin.marinas@arm.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com, pbonzini@redhat.com,
        wanpengli@tencent.com, vkuznets@redhat.com, rafael@kernel.org,
        daniel.lezcano@linaro.org, akpm@linux-foundation.org, pmladek@suse.com,
        peterz@infradead.org, dianders@chromium.org, npiggin@gmail.com,
        rick.p.edgecombe@intel.com, joao.m.martins@oracle.com,
        juerg.haefliger@canonical.com, mic@digikod.net, arnd@arndb.de,
        ankur.a.arora@oracle.com
References: <1700488898-12431-1-git-send-email-mihai.carabas@oracle.com>
 <1700488898-12431-8-git-send-email-mihai.carabas@oracle.com>
 <20231211114642.GB24899@willie-the-truck>
From: Mihai Carabas <mihai.carabas@oracle.com>
In-Reply-To: <20231211114642.GB24899@willie-the-truck>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0195.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9e::15) To PH0PR10MB5894.namprd10.prod.outlook.com
 (2603:10b6:510:14b::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5894:EE_|SA1PR10MB5867:EE_
X-MS-Office365-Filtering-Correlation-Id: fc12db02-be32-4116-b3ec-08dc20474c5e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	jW0mZriM9Q0Lj8dRP9xBCbMd53eagVs90IZ0Za0LJxzLaRWy4fHjRNaICfTV9vpnZLG4wopHtYcR0AohwxIfzKUCJuMEY+AYO/RB2LZbp+VUIf3rpfKkaboj8Y0XxTJRTmYdqf5TaOQTMPieupnId7PFQ4Pfv/jMDPoMJoGxWIA8FymkWX2wG3hp93S2nzc2il2IEUgunqlIzjDAKNKTO0b+/Yia73BkRgji4O2tzARg0UT3NTTkXooEQNjjq1GsAE4FzPRTAux+3AM7FmXsFQu0bDdmk+8oglcnadkIRKXOg8e9zKcS4YQDGNQfgOOa4H1TkaotSpyNeqQbU9gNm7L18NzZx9PmsjxFv6Nw+B+MrN+XsHTJRbu+dYluUrj4AL3mFJcwoTelNQ7zgc/oaw1aOgdH9u8G7ndbgjCk0ed8UmK3mjxmPy8nzFNbJVLUBfrWTo0LtLw2CLDIy6xY9iRCTHIQV1lBoNTFjMrrYJ9ZXssEZ2uULzVvOVxNul+WzbxY4LaYrpr/3mao5mntLtCHWfdrgsMnNGCsOtbU87Q4xe4EyVhB2WAASGn9o2DNIXSnho13OfBpmJmt/XdYvYD4H+VKFT88mBGj0/YirmdQTzv2d/vGTs4It3hS3P+XiVYE7NZJUrWJVRkzdv9aQA==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5894.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(376002)(136003)(346002)(39860400002)(396003)(230922051799003)(451199024)(186009)(64100799003)(1800799012)(66946007)(8676002)(5660300002)(66556008)(66476007)(2906002)(4326008)(8936002)(7416002)(316002)(31696002)(44832011)(86362001)(6486002)(6916009)(6512007)(83380400001)(36756003)(38100700002)(478600001)(6666004)(6506007)(2616005)(41300700001)(31686004)(26005)(107886003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?WGhVajBWa3lmaytVOCtSTGdsVXVzWCtIVW5Nemd0MkhDUDR0RnhMb1lMSXRL?=
 =?utf-8?B?c0twS0twQy9WUXlpRDd4TzJNNFF0aGUrOUs2aTJYdncxLzJQdVN4OHBkdlU3?=
 =?utf-8?B?bWFlTEQzdUdrRXllMWR1anc2WDJOc1E1cU51SUtGejNDbk02dkJpN3RyVFJw?=
 =?utf-8?B?elhEUFZNeHBwaGJCOUhqVlVKd04vZEduZEpCOGtjbHk0UHBkcXF6YmMrd2V2?=
 =?utf-8?B?WWUxdUxsWGJOVTIwNmpxUE8rL2ZKNjExVlBpYXBobnRJSWNrYngwM2pYeW44?=
 =?utf-8?B?c0ttdGJGQUY3V0Zwd1dCYnNyYnE1ZGdKdGMvazVYWnIwcEVPQm9IcDR2NGhT?=
 =?utf-8?B?dlBoTUpSeFd2dis3UjhBYXdNLzdmTlVTa1I3QzBJdEt0eHdQUkR3RFNmdFAz?=
 =?utf-8?B?UkJFRDN0QytsbXNKY0Rvc293YVpQOGlHbEtyWllYMkdveDR1MTdidmJNcDRZ?=
 =?utf-8?B?SDhaSmF0QlhLZEJ4ZFZWdkZWZzVHZW10L3ROWTNkNnJ4UHcvblpOQ3JzaHBB?=
 =?utf-8?B?RU9pUFROTUlPZUJqZytPWHBPOHBlRWgvaDFYNzhrbkhjcEo0ZldPWmRUcUxL?=
 =?utf-8?B?RTVsKzJ1clVDb05EeWlWa1hJVy9nN2FzdFVPL1lCSGdnN3I4aHB5S1JGb1pJ?=
 =?utf-8?B?MVRLZGVwUnRKcjIwZUh4U01lYjVrY0w1dnVpZkd5VzR1Mlpza0xHY3VzR2ht?=
 =?utf-8?B?cFZzbVdOQ21lZXl3cmlxbFRPYlVuWC9xSjV4RzRVUTVHU0xZdEIrc1pCdGZj?=
 =?utf-8?B?RXN2b2VxbFBodlQ4QWhlUlk3QkNVR09kWmNvN1lkbmZSd3RMTWlkSk5iYUpz?=
 =?utf-8?B?WGdyc2huN0hVRm1OYW1EcE9MZkJoZlJzYlgrSlJPZjd0R2ZUMVpLZUt0cmdF?=
 =?utf-8?B?dG9NdWsvZCtlYUQ3Mm0zU2lNV2dNQTQ3T2JmMU9kekFmVXltejdVVlQ1bTRt?=
 =?utf-8?B?MlRuSnNaWFphUDJqeUNNRDUva3RqU2tBbnJMTGtCazhLa3NERTVTdjEzcXVP?=
 =?utf-8?B?blpHRkVGL1RFVjhhSzRUU1JuKzdhTVJiakFjSm9hQWFadk8xeEU3MU16NTdM?=
 =?utf-8?B?WDIydHhYMWp2d1RCY3R5VTZJN1lHbyt2WThYMmdXWnBDV2FuMENNMDdRODlN?=
 =?utf-8?B?ekpGY0dsMlU5K200QWI3SGZLMkxKQmtuUy9qbjloc1FrYlBuczVMWjhRVGpJ?=
 =?utf-8?B?VEcxRTI1dEM5dXJ4dURrRVZtQjRiL0tha21aVElxUEhzajgwRE5MTDNSYkF3?=
 =?utf-8?B?cFl5encvQzloRlViWVdpdWcxMDNZRW0wdnVUVzAwcmRKaHYxRFlsNXdYOWN0?=
 =?utf-8?B?V2cwNFQ5VmU4S3pucVNLbHQwaXFYOEx0MUpYV1E1cmlYalJmODQrSjBKTCty?=
 =?utf-8?B?WjRSS01CR3B3REllamJaekozYStPWFp4UVI0MnV6c1FFMWlsWEtWUStHdmt4?=
 =?utf-8?B?WHl1SCt3QWVkTW9jV1prY3RmZERKaVpyZzNWK0FoUzNLbkpRTGhHYWkwQ05v?=
 =?utf-8?B?K2YwOVZ5RzdPYVY3cGpTU0gzUHhOeVhoTmtjYS9WTURlMU1MVU5uYnZnaDhr?=
 =?utf-8?B?SmNzZUxOTE1pU2NLRG1pYVhpUkxLTVNMMW83a21WTWVUN2NFUlVtYXZMMWda?=
 =?utf-8?B?Q0xwY3FZcjl6OTd3VWNZZ2Nkd2VXQ2pkVnVuTWhLd3pVdlVHMFNzZ3M5Vkxa?=
 =?utf-8?B?QWl6dTUvWWFCRTlVZzZuSkZuK1pRNmQ4djlvdENWUG91MXRna1dkdXVmbDBm?=
 =?utf-8?B?eEFHZjRWTEtCeVNSM2V0U0hUc1lNTkppS3p3NVREeHJPdmtYUUxiOHA5VGp0?=
 =?utf-8?B?TDFMUVVKOVl0ZVdNaVJ3UzUxcVZrc0JUam1ySGZacHhqN1MvK3ZyenI3ellK?=
 =?utf-8?B?RFFYUDlkd2VROGd4SjRRZmI0VllpVDJkSmVPTGt6TSttMmVmUklXeVpQdHg2?=
 =?utf-8?B?VkdwdzVra29Zdmd3dEF1bm1XNlp2N3RLNEFUeDV1Z3BUQnRZWkJ4ZjEzZDk3?=
 =?utf-8?B?aTUxMkxjOUZJQUg2ZERSMzd6SEE0akpmdU94aUJjQUprWTVTL1lVeDNLWUZM?=
 =?utf-8?B?ZDZJcjBQUktzUERaQXdzY3BtR3RRaHRpMlpGanRsZ2U4SHRpbVJmMDkzekJh?=
 =?utf-8?B?MzRoSWhUS2hXbTJ4NjAyVE5XeWdHVFVJZVlrU2gxVWc3QUNVSjN2RGgvWjFO?=
 =?utf-8?B?Rmc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	pkQA0Ysjn6awwHTgDWvUT3x7ZjQPQSDccXAj67YpMZEfrLQqfAb7uWaLTZwuvOr+rE0dvmIgTUicEpWfhZ1+NxcWI/k06hnKg16Sj3apAR0sv6EYFYbaBlR10FZZIYXU25aDSIw/ukyKMkKJxnZvzbQE1grjr3zLoM9XQfxCi9OOZP24NY3Jhp6lrqezuzwHQERwyseHWG6JLFX/ye5tHevhnh8q9tLFTl/BmSarLxdki9twV1p/JPTk7gWs2WlelLGsWjx9X8f5NqwgFIjRvmqWldkgVR7ooDH9+CX6KSu2gBwg1C1pkyxn323bz2tUBtVAanuZm0g8Xz6AGO32k7/ruKZb3ZcERoKeqFerLEcXlxaayBSOyuXWg4ZN7wZscZCUPPHnLYHc9ctnXk5h7ytOo73vIe5D1Sz8RBV3YxFZH72fex/jdzBbDPg5PZzdNLyH3hmpMBp3jYc9DQQsfKOjMyFraW5BV0TzNPUUInEhlAKdiR+/JMLitGKDmfChKxhE+SaVVRpZZFK1BJBWFwA5OPy0R5TwWzVG9yin/HuNH7OyFr5MZtF1KFadq6MTa58Qf+6GCW+zMkRd1e0P7GGEGom/ToVQBsECZu7jgLY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc12db02-be32-4116-b3ec-08dc20474c5e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5894.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2024 21:22:57.8168
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1dgQLupogO0VUJiM8H3xTvIVgvslOkc7KsHIW2u+5SKsj7lNOza5kpfruoVN5+J2SBe3c/bLaJKQ+2wRUvXSbmDqY6c7rj3T/6AdXlT8Rzc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5867
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-25_14,2024-01-25_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 malwarescore=0
 suspectscore=0 phishscore=0 mlxscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2401280161
X-Proofpoint-ORIG-GUID: NISH4m-UVNfqzhovLBzMUFj71bEsjCbR
X-Proofpoint-GUID: NISH4m-UVNfqzhovLBzMUFj71bEsjCbR

La 11.12.2023 13:46, Will Deacon a scris:
> On Mon, Nov 20, 2023 at 04:01:38PM +0200, Mihai Carabas wrote:
>> cpu_relax on ARM64 does a simple "yield". Thus we replace it with
>> smp_cond_load_relaxed which basically does a "wfe".
>>
>> Suggested-by: Peter Zijlstra <peterz@infradead.org>
>> Signed-off-by: Mihai Carabas <mihai.carabas@oracle.com>
>> ---
>>   drivers/cpuidle/poll_state.c | 14 +++++++++-----
>>   1 file changed, 9 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/cpuidle/poll_state.c b/drivers/cpuidle/poll_state.c
>> index 9b6d90a72601..440cd713e39a 100644
>> --- a/drivers/cpuidle/poll_state.c
>> +++ b/drivers/cpuidle/poll_state.c
>> @@ -26,12 +26,16 @@ static int __cpuidle poll_idle(struct cpuidle_device *dev,
>>   
>>   		limit = cpuidle_poll_time(drv, dev);
>>   
>> -		while (!need_resched()) {
>> -			cpu_relax();
>> -			if (loop_count++ < POLL_IDLE_RELAX_COUNT)
>> -				continue;
>> -
>> +		for (;;) {
>>   			loop_count = 0;
>> +
>> +			smp_cond_load_relaxed(&current_thread_info()->flags,
>> +					      (VAL & _TIF_NEED_RESCHED) ||
>> +					      (loop_count++ >= POLL_IDLE_RELAX_COUNT));
>> +
>> +			if (loop_count < POLL_IDLE_RELAX_COUNT)
>> +				break;
>> +
>>   			if (local_clock_noinstr() - time_start > limit) {
>>   				dev->poll_time_limit = true;
>>   				break;
> Doesn't this make ARCH_HAS_CPU_RELAX a complete misnomer?

This controls the build of poll_state.c and the generic definition of 
smp_cond_load_relaxed (used by x86) is using cpu_relax(). Do you propose 
other approach here?


>
> Will



