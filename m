Return-Path: <kvm+bounces-8010-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BEE64849A2E
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 13:29:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E1BDF1C22AAB
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 12:29:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 857371BC4D;
	Mon,  5 Feb 2024 12:29:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZSk3/L/q";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="qS+57Jtl"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FC821BC2F;
	Mon,  5 Feb 2024 12:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707136173; cv=fail; b=gNUdc/UTbLF19gIl3lijMwUbjkmXFD/myx7o8wFXB/Us0/GVLKJf0eq1LA8XpUOjUqhykMXfM9H4ygtg0pXXZQUxcfUk9CBqQ169WUJGUkao9P4cdd90h8vDBi4l2RqcNCONzSt8W3utkj+QsAzVVDvLEtIWECdBU4oDIzKDgpg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707136173; c=relaxed/simple;
	bh=TaWw3FO9ZvU2D8CzAVyegqWKJBlQv2jKZGLeboIqg4Q=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=AcAKQ7qoI5pvSyiEs8jR9wXx3VOeK5qFspiBotR87fo0qLndh2NkruyP9uEHF8XX/3lSNb31sOsaqFr6TWeygoUPzdA2kIZwSc1KJ6+POe/Jt7gTMg2Xu+azx/O/A0jDyZr/LKtkj7nw5G1O0ufSsNhUlogyCMU2N0M8eHXBB1Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ZSk3/L/q; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=qS+57Jtl; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 4159O8BD016051;
	Mon, 5 Feb 2024 12:28:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=Ju99NLjOOvuYItzLw5Zjq8Je+VBoamHOht6DHul90O8=;
 b=ZSk3/L/qcZ9JSiHg/nL4syKzjwsK8rnhdGRZYxyZyG9jmPpZAFmy/PdnxPzybVgFAVoI
 3pRuFn0SdCv2Yli2AmPUZdn6KxBCLClEY/GvYdgzNIavnmi2jcqC/G6xmJrmZz+hDuY0
 0vcyI2+5MeUL7UbOQj3vlgOdnTAXSe5SNJpwya8uIpzbxDGRN1SjtuA4ZOqgznd/JXVH
 iz3oMgyXoHfMROpRrUCoYbF6cU2vuWp+mQjcicknzQSibqLLHBgv5AmhdPshm9P3/wMs
 Yq1CntXLi5dgWrnzE9S20V1Z8RM6+FB9sNpRnIPgaAxwh48WH1Ab/Wbzrfq2HG9isv1F /A== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3w1c93uvg5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 05 Feb 2024 12:28:24 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 415ArixI019693;
	Mon, 5 Feb 2024 12:28:24 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3w1bxbvtkc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 05 Feb 2024 12:28:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fnU5qLtALQHzTd5QDHJylZvH0xBxrHU0BINj2sA67ykBSnBNQs8fQiCRgDGvlyJpcIGy0/eqqO0nj9XjwIHH0QzCpgpXuMl3fgKNICQNXhe5TbaxWn81+O5xe84sob5wLDqzCu+Hd/5DXPaHgjvLUi2dfgtkpnk5p2fPh4HgazVME45dV4PqlFXX4QPOQbnxNyYBcR+dN5cCe/XCZ7sJGGDomYgKyszLNntoI8MKhEDaZP6y+8TnA3/OmPxpJ7OL1Mgqb6dThfVjnSsSeUgui0bTKS7X2D6T53UR0IO6x5vuVLHPCxqv/3zKzGT3LiALpqpEGpBL4So6SIeSeMRAqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ju99NLjOOvuYItzLw5Zjq8Je+VBoamHOht6DHul90O8=;
 b=SczPc9xvZEqD45gkSijWbumdK4tiyELHWEzfz5Sz7jVKXnHwOE8V2v/VXvhXs5TPpk+VwNt2/ArVnESHNauBly4hTsurTINvRjXDgkmAHQCvFg43/C1UTKjRPEYHaMcFg12nvjq2wvmri7/gvfm9VO+SyrF9wLCIFgvEvR2Gfqgz19v+K6K3xLbfucCOxqISFkY98+FvYWeDoIBKcboL7sXIjBDrQSw+d4TyRtWKc5RvcJWeAzB4AnEvbbnFnOc7GFYg6DaOA3pcQ0F+i6gSgPO+A4w9/k0CAmI7j6uJBsQEqduTTVr6M46XdecRWutfhNgBxb/6pq6/UGD8BxN7Vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ju99NLjOOvuYItzLw5Zjq8Je+VBoamHOht6DHul90O8=;
 b=qS+57JtlRBwRs/QYXBvfIwsJwies49PHVocVz2M3WMN75wSsWQfwuHI4v6AKMRVC6dhBCzva1vgyG/QDp8PmpIe26uPPr3PaaBP60IvajTdab0I5KAl+GsTiBD0/zzTtrotC4/keaLf4z0RQn2jeF5P2PATTQYYTFkhDsmhtPqo=
Received: from PH0PR10MB5894.namprd10.prod.outlook.com (2603:10b6:510:14b::22)
 by BY5PR10MB4260.namprd10.prod.outlook.com (2603:10b6:a03:202::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.36; Mon, 5 Feb
 2024 12:28:21 +0000
Received: from PH0PR10MB5894.namprd10.prod.outlook.com
 ([fe80::6fec:c8c5:bd31:11db]) by PH0PR10MB5894.namprd10.prod.outlook.com
 ([fe80::6fec:c8c5:bd31:11db%5]) with mapi id 15.20.7249.035; Mon, 5 Feb 2024
 12:28:21 +0000
Message-ID: <1b25b492-b9e7-4411-90d1-463d44084043@oracle.com>
Date: Mon, 5 Feb 2024 14:28:13 +0200
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
 <1b3650c5-822e-4789-81d2-0304573cabd9@oracle.com>
 <20240129181547.GA12305@willie-the-truck>
From: Mihai Carabas <mihai.carabas@oracle.com>
In-Reply-To: <20240129181547.GA12305@willie-the-truck>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0581.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:276::11) To PH0PR10MB5894.namprd10.prod.outlook.com
 (2603:10b6:510:14b::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5894:EE_|BY5PR10MB4260:EE_
X-MS-Office365-Filtering-Correlation-Id: 31f3b7e1-12ae-40a6-50cf-08dc2645f0a6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	WTCMN44OIe7qcZlsag3Bfvs3QPBqNETEICIkCsa/4O4T4lqMOpQUAOcI8vIRvzYOhp27/gmKftrmyB8MzQFhgFj4Qf3/MyBB3wcO2HLZFlhstVgHc0PVFvCJpXmpxuPBHTkFVdVFCsQANPHE6+RS7FUlqB4Cej/dj6aiShMkrwfdZNYrbvgA7U2so0ZkokrlI0FJUk44kZXOB+PifvqAJ1BLHi1QtSMBNrUOP4d/uA9IDv+Pks+cXSBTrm8Jsa2LGA4qPQGKYYQObouyKV+oQlRkD9eosksZ738yPBhGN2sNxHAM0jfVzk2S0O2Bgs1mfKpDrJFYl5A4uHhXxhhLBTusTTSGSPCZyJLaUGx7ih7pTxEYQScI/y67J8RioWrilQeLAApRnCeJenrLuilNt98BRgO99M5W1GNoRejf0xYj5C54vR8dWnZh+w4jykj0l7DerHQYyzebYbQc5QBgcXyKRX1iUTCMtmpRzrn9t9kaXqduR+3gD9tWG1STEEFurWVI3dHEMwSaZv+Trqxs5F1jE5PVywEHtqZzqS43av1MFgJKGQr+UulCupzKzxD5cpcrVGaNo2wTMhjvpstxf1yh8BLfD8nAJoy0zB4NHsrOSsUKTbL0LbgYYJI1Oa64YLCB9Jj4hvUK1I+jnUPomA==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5894.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(396003)(376002)(136003)(366004)(346002)(230922051799003)(1800799012)(64100799003)(451199024)(186009)(31686004)(38100700002)(2906002)(83380400001)(86362001)(107886003)(31696002)(2616005)(26005)(6666004)(6506007)(6486002)(478600001)(6512007)(36756003)(66946007)(66556008)(66476007)(6916009)(316002)(41300700001)(4326008)(8676002)(8936002)(7416002)(44832011)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?bGdpdzNzd3VWV1FxL1phN0ZwYzhFaU9yVEtFNlg5Z2RFcmRHRi96bVkxV2tU?=
 =?utf-8?B?aG9Ca2RnZjEzQVIyclNPK3ZYbmpjL2duekgxUXNhWEhCczBrNkVyTE1xakU3?=
 =?utf-8?B?ZTl2bGtFdDBhOGxjQTZsKzlmNHBNQUN2b01ESXlXTlZqL21GVmgrY1NpRFM2?=
 =?utf-8?B?dUJXWmJCVnppclFPYXZacUZUeGVVbk8vZGxNUzVsWFYrZThVcGpTVHJNcDZa?=
 =?utf-8?B?MHh0OGx2MUgyM3NPN0owNGowTGNsaHQ1MEJFUXBTTW1wN2R4TEIxdXFmNGhl?=
 =?utf-8?B?NXJaRlpOUEVBTCttOTFhUDM0UE94UHMrbE9QbG5QS1NvMHZXL281YThaWEZw?=
 =?utf-8?B?MXJ2SENsbVZUb1g1S2YxYnE5WC9pOWNQZm1NY0d0NWZmc1NjUnpFaVUrVWpF?=
 =?utf-8?B?N0ZUTjdraFNiTGc0QlBza0JCU2xUR2I1MUxwQk41SXhObmxqZGkyYXRUaGUr?=
 =?utf-8?B?Vk1WMGNvWUJ6eUJFVDlKemc4MW5SbVdyQ0wyc1VUallGLzdVUDlkOU93dkM1?=
 =?utf-8?B?UnlBa2g0UnhpNm55Skx3dDg3ZjJXOEJHVndsRGNyMERKakRPV09aQ3ZLaThz?=
 =?utf-8?B?K1EwOFp2Y0E3ODBwODQvYml5Smc1OGZHdlJrU0RQN3huUktYRDJlZ2RiNFQy?=
 =?utf-8?B?SHJRMFN4WnRnaHVsOEtvbjRZd21jUThnK1ZYZE9pTmVtL1liM04rai9WdXdx?=
 =?utf-8?B?eHB3bmJMeUhQcCtGYTU4WVFUT2FCaWpLRWpUVm1xNXZVWSsrY1grUnVtNWJX?=
 =?utf-8?B?Y1lWM1JKOEFWUUsrQWNFc1RWN3E4WG1wM1ZvWlhmbXVvN1ZlTkd1UkFUV1Qw?=
 =?utf-8?B?SHdoNzNiSmtPWmNleHdpREpZaUZzV3ExNmZuZGU3N3I1MW9SUmNFeERIblZu?=
 =?utf-8?B?ZkVSOGZzWkg1cVFsSjExN05NMDN3U1E1Yzc2QkhVQlFBQ0pZZVNEV0lZNjVP?=
 =?utf-8?B?SThSY3c5QzVCYlYzQWhlYkxyUzFoZkh2Y2ZERllHcVFRdWRCd20rQVN0WGd0?=
 =?utf-8?B?SW54dEEwR0dSeHNUWU8wby9RbGhvYTc3NEJWd01VOCt2REZsaksxb1BtQXlU?=
 =?utf-8?B?dFBLaDVrKytNTzhTNEU5czlxNWEyODVRRnl4TW9lV3NtL0dGMitmZW5yMnR2?=
 =?utf-8?B?TStBTkdiZnExblRpM0xRNllOY1hGWHZiOFZkako1MmpPOFNUN2daclJDOEl0?=
 =?utf-8?B?YzNGcm80Tzc0OVliTi9KRGxsa3EyNXNWY1psYU9kUGtrdDVvbDB6TmlRVHZY?=
 =?utf-8?B?UDlidjNSazMxS0MwTEtmOEF1eFFUMnZLUXhwYkphTnRUK0xhSW5QdHNYNTY4?=
 =?utf-8?B?eVdMRDd5UHhoU2lMYVo3em40TzlLbWlqNExPUWZRcVlQWVBIQmE3ckpVVTB4?=
 =?utf-8?B?R0lLODdvcVo4ZTJqaXl0eEJyU1c2c0NsYVNtN3l2YWRqb0NNellvMjJDUVJ0?=
 =?utf-8?B?bkhEb2YyRzY2SXp6VlBVbEJlOHE3NzVYbnNramtKSHpLc1FIN05Oamp1ZGJI?=
 =?utf-8?B?dGpzSVlyQkkxeDFLSTh3a2xKOFBPVG9tMGx1V2dzRWZoeFBZUVBEUEQ1M0hT?=
 =?utf-8?B?VmVzV1dTbTVjS1VYNEFMRVlVdVlpci80TmpnUHoxU1BvdGZkcytSdk9HMjNh?=
 =?utf-8?B?RWFxY2lLR1NqdUFqM3J2Y0pRV2NpejFWSnJibmxzdEg3NWc4VFZSQ1ROaGw5?=
 =?utf-8?B?MGpKbk45b3lYc28vRml1YmNHalk5WDRYWEVmMkNydmZ5YXpXUUR3QzI3U2F4?=
 =?utf-8?B?VHNoR0ltOTJRQmkxMkVEYUFIeGhydXhVYTZQanlFbzQvTDhvbXhaMFhPaFd5?=
 =?utf-8?B?alV5SEE4NHZxQjJPK2paWk40V2RRb0FTQk1vU0JLNXcyZkkwM0ZMMHd0MHVD?=
 =?utf-8?B?YTVTN0Nqbld6ZDVTUlBlL2FOUUc0ZnEveHRCbXBFYkp6ekZFVHRLNEZSYnl1?=
 =?utf-8?B?SU51K3Axc090bzJlZGkvRjBOMkFITXl3TWJwM1dnVFFQVXpWVWoyejB1dVpB?=
 =?utf-8?B?a1U0U0UzOXo3VGZPUm9yMXh3aHBHK1UvWlBrL3RINUp2R3VhOU1wL3FaTGN5?=
 =?utf-8?B?WUc5NUlNRE04QkY3aGsyM0RiNUxBdGQ2Zm56azNIcXREdTVab24rcWU4TFFQ?=
 =?utf-8?B?aDBnQ2ZreEJWNm5YNmZ6TGhxb2phaUltRnRhS1R6cnB6b1E4OWhmbStIdlZL?=
 =?utf-8?B?Snc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	knlu53Dqu8HD4xeSgny0dWcmE8+FH/SEyMYBoeWYoBnXQ04MGnb10eXmzcMLkdzdSqqXbKBzmY2iZmqk5zZHUsJNy/9xbmq+r/QgF28t27UC0NTYXh4t9iofTaJ2ACKktjVOrpxZqY3M5hbMQt1I9z+X+Bq8nP9EZ4dSEmUfLnCkTxvECcagxSZyTYN7kcSqVH07V77SlP8WP4qx+RgSZfoqWkzTU23edTZcmRFRG+yBVb+9aINMwOLQsRNynfjPUM03W0XpGuPvjiriZut/4S5Vy3DU6XwDPYARxTCvoDho7a+RTJ5EOkFQhUcWDSvN2o4m6SH+Ha+ePIwTyOP0y52bpTNEfh2RprWKMB59TyziSERpbiv7ISy7GFLAXEOeAvblEIpHRT6L/ys/KDbsvd5XrSvcgnkNWOHaD6d4pYYvT5jhNZHh3j5/gmy4v/i2zAx42BoPEuEO3rjDwXER6KginBE0NHAUuGKRnmsSypYXvN1ppHws4TQuez0H9+sqaDwSQvD8OGS5KM5tmiu4LirApZcf0FnoYBWCkxDvIAwvSm+o9tSOtEx2ZJ+CIF+gfCVBT+YjNmfrht9BnybbAWxVQoPnKhUqICDgSw+C/J0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31f3b7e1-12ae-40a6-50cf-08dc2645f0a6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5894.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2024 12:28:21.4522
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2J0GYQq5Pq0OkAwohd2ysxhV5XKHoHDySKtbm9j8K4Zol3z71SfdmoPqJhb/ECW3JQuV0XmVzTKI6h7y6Plo/yM9DycJJRr99W+tDXbN07c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4260
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-05_06,2024-01-31_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 mlxscore=0
 adultscore=0 spamscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2402050094
X-Proofpoint-ORIG-GUID: tVf-ydn39PEZJNy2uFYdfuwdFyFvmM2M
X-Proofpoint-GUID: tVf-ydn39PEZJNy2uFYdfuwdFyFvmM2M

>>>> cpu_relax on ARM64 does a simple "yield". Thus we replace it with
>>>> smp_cond_load_relaxed which basically does a "wfe".
>>>>
>>>> Suggested-by: Peter Zijlstra <peterz@infradead.org>
>>>> Signed-off-by: Mihai Carabas <mihai.carabas@oracle.com>
>>>> ---
>>>>    drivers/cpuidle/poll_state.c | 14 +++++++++-----
>>>>    1 file changed, 9 insertions(+), 5 deletions(-)
>>>>
>>>> diff --git a/drivers/cpuidle/poll_state.c b/drivers/cpuidle/poll_state.c
>>>> index 9b6d90a72601..440cd713e39a 100644
>>>> --- a/drivers/cpuidle/poll_state.c
>>>> +++ b/drivers/cpuidle/poll_state.c
>>>> @@ -26,12 +26,16 @@ static int __cpuidle poll_idle(struct cpuidle_device *dev,
>>>>    		limit = cpuidle_poll_time(drv, dev);
>>>> -		while (!need_resched()) {
>>>> -			cpu_relax();
>>>> -			if (loop_count++ < POLL_IDLE_RELAX_COUNT)
>>>> -				continue;
>>>> -
>>>> +		for (;;) {
>>>>    			loop_count = 0;
>>>> +
>>>> +			smp_cond_load_relaxed(&current_thread_info()->flags,
>>>> +					      (VAL & _TIF_NEED_RESCHED) ||
>>>> +					      (loop_count++ >= POLL_IDLE_RELAX_COUNT));
>>>> +
>>>> +			if (loop_count < POLL_IDLE_RELAX_COUNT)
>>>> +				break;
>>>> +
>>>>    			if (local_clock_noinstr() - time_start > limit) {
>>>>    				dev->poll_time_limit = true;
>>>>    				break;
>>> Doesn't this make ARCH_HAS_CPU_RELAX a complete misnomer?
>> This controls the build of poll_state.c and the generic definition of
>> smp_cond_load_relaxed (used by x86) is using cpu_relax(). Do you propose
>> other approach here?
> Give it a better name? Having ARCH_HAS_CPU_RELAX control a piece of code
> that doesn't use cpu_relax() doesn't make sense to me.

The generic code for smp_cond_load_relaxed is using cpu_relax and this 
one is used on x86 - so ARCH_HAS_CPU_RELAX is a prerequisite on x86 when 
using haltpoll. Only on ARM64 this is overwritten. Moreover 
ARCH_HAS_CPU_RELAX is controlling the function definition for 
cpuidle_poll_state_init (this is how it was originally designed).

Thanks,
Mihai

