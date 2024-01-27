Return-Path: <kvm+bounces-7265-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CB89083E992
	for <lists+kvm@lfdr.de>; Sat, 27 Jan 2024 03:14:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A6C711C22DCE
	for <lists+kvm@lfdr.de>; Sat, 27 Jan 2024 02:14:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4870411185;
	Sat, 27 Jan 2024 02:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kAYHIwqd";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Jd1toPm2"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0D00C148;
	Sat, 27 Jan 2024 02:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706321313; cv=fail; b=ut9iiWfujGVUcUiRXTYlkX3USHy0bVZCt6DkXljgnGzEsB3quhcgz4xH4kqNiFQoBYCbxq5PlL+stQDC58Fw9xy65E45YHNhpjQNNLC6fmI/O1aGSIS1hbCtOYz/GdipHef5TM9gXYatR2nu2OkaVYNdsG8ra1lMFVYC6U0bsL8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706321313; c=relaxed/simple;
	bh=yfVz7S2P7GTydfZ49Bh9a5fUEiP8avXZ89NmXvnYLdM=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=irx/mXYP4V3cmt4JeW7z4FDWyI3L5VZExV5l3fYT8C8/4oQ/anbRGm/5mwR0GrXWKLO0s4jHp+ju4LNw3RoyVSS+9r8sOemK1A85MitNRtO33g77/K+uGjb1uZv4eqB77EOvtGKslW0XW9eciw6XCQnkPunpSAvqq97zjadQSv8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=kAYHIwqd; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Jd1toPm2; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40R1YMb2022543;
	Sat, 27 Jan 2024 02:08:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : from : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=aLa7hq+5ErbbtYk8N5vJvFKgSS9B652EUGMU97axdsw=;
 b=kAYHIwqdMf56FCHkFd7R8ICU6Ur0L2yAR1Q+etVInsX5T6W0CQQ6QMnvxX2D2rgaDXUV
 lm0mB0/HOpjoHX75xPCiFmByVcDvdoZZ+p7vL8EbO2uCz6vhxs3kyzpzR/8cCvKeSjZN
 VAKiuPQL+CTmBGRVvZD5GCj4ifboiYJOo4lqeDBOxob2bX6vMAd0VUVgbKX+i5Pfhwl+
 KkqFjkdqTbwU7dPOY6gkksYic+f+tA+B3PN4j8gT8+YqJavMsmYcnIvAX/LDrHA0sGtD
 VbBTJJS8pUL2L9PK0p9GRX2jMw3+jbnKgrkTVvVFB6Fv56IHYu1y8T2Br05RbsLcBsBE IA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3vvr8e80tg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 27 Jan 2024 02:08:27 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 40R1XBYh040195;
	Sat, 27 Jan 2024 02:08:26 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2040.outbound.protection.outlook.com [104.47.57.40])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3vvr93gprq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 27 Jan 2024 02:08:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M2v5je9B+nbgpmUEQz61q3vCqg0/umi5xiBBbl4imn7qxbBIZqOA0H+u0fx2WGgUvN7fPK7jmILsBU5ac/IK3AwUlvRJ2J+tPkD3s+dDXM4xUmaztD+Er4AvIzqDkw8xpat3V0S/iYb7TCgpY3tE1ICGZkeZP+9uSYIgKLFezaFNl+fTiVmTPWLr0FMQGHXd9fSf44YeXNK2jut6XTJDsBJuGx4MfLxZK1jWup9uZq7mqaqlTn5Fe/FM3MvbGQBzj6iUNGHnYQba3Kt4m4Sc4lfDQCxHLiXNXe2Vep8JnUfc6UvzQUh/WJNQ4urSNFRWHp5rmF5jbgt4jjVJtmqV1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aLa7hq+5ErbbtYk8N5vJvFKgSS9B652EUGMU97axdsw=;
 b=lhzx4ND4jX5v8eSyICtvtXxccDOhtgfU46wGip3dcfhEV+Cc3QLDgsAws7bb6HEVDVBaeKRB2QvSLOGc0pwq2L05qN38w9l8faX7/yTtGNJJjZG7yyBGVvuF0fQCy5wPLkAtZiWjOpZRsjn18Xod6kIfPDHnWPkoyw5J6pBPYWC+6+WZTltIWdBOlSU2Pu6S9Prmwbc6KmD3vkDAF1UKEZlm5n/vmiqYchQfR9cWxwFjE51YQndmXezt+mCqMNpdHS6ip+hT5pDQ68NRYlXUSxOPi9xl2nhwN4A6wCkJKtNNy6or2oTCMpt2sAlmDsyfLDURFsq+r2xqsA+kw9+T+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aLa7hq+5ErbbtYk8N5vJvFKgSS9B652EUGMU97axdsw=;
 b=Jd1toPm2SQ9WE7pnB28BLFr04+SmAxz61f9K2vWMiZ8x4ja/nn+8h6NLoTm9Viix0eLgGDvECsCC0MLyJW7eg0Ix2YFGsHFBDY0jVTvXNaSdZCGYPUnB4nEdDXqEOWRxoU9MbCMcG4/ZkP8/NXp7Hcsk8FTNfb5OrgGg8WQiJmM=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by PH0PR10MB4631.namprd10.prod.outlook.com (2603:10b6:510:41::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.26; Sat, 27 Jan
 2024 02:08:24 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a1c5:b1ad:2955:e7a6]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a1c5:b1ad:2955:e7a6%5]) with mapi id 15.20.7228.027; Sat, 27 Jan 2024
 02:08:24 +0000
Message-ID: <709e485a-d394-8db4-cde6-52987b8e961f@oracle.com>
Date: Fri, 26 Jan 2024 18:08:21 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: Stable bugfix backport request of "KVM: x86: smm: preserve
 interrupt shadow in SMRAM"?
Content-Language: en-US
From: Dongli Zhang <dongli.zhang@oracle.com>
To: mlevitsk@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org
Cc: stable@vger.kernel.org, joe.jin@oracle.com
References: <20240127002016.95369-1-dongli.zhang@oracle.com>
In-Reply-To: <20240127002016.95369-1-dongli.zhang@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH0PR07CA0045.namprd07.prod.outlook.com
 (2603:10b6:510:e::20) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB2663:EE_|PH0PR10MB4631:EE_
X-MS-Office365-Filtering-Correlation-Id: 5cd8b379-b66b-4d59-9aa9-08dc1edcd7bb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	M8xExMcAuU3EMSVEndEZDDlhK6yIXwSIGNlTGR8lPTHFz3YNMXQ9u2pEANTnzBoHHA83nsaOzE7hw/Ie57ZUu7uHHJ/lvt9P1nWywLGOxwGhi1JH8RULzcfP+onsFwrlbhB2d3Fb6ms5NakSkoHsxc2llsF/269NZRBaQuxKKufWqq+nZ+gSJ0zEY3cEgNBMVWKMg7sHl2FHT3Sx6Xn3yGdf8nv7V507WDwjDOivYViItOQ3l5GXKhXxSavSRV2WQT736ors0x23RMrnaqeXO006VKaapMOzWNQLITkdkLYBgpxkv9sHI71bkBl5PgGUnJpoHGDC9EzVjB5YJ2/sd5P9xIWdGhTGJ2QzLjuHHAFyMszbKnwv3Th7w0iVr5FlsgDOFkEI+lfHgjI6s5+ddTxxG1bX8uQOK+2VbJApUsYt4pkNn9/1WGFotEl9QNQMdGynpoqz9KJSry76oc01oV/Z8ZG7HTXGCXJtROm8z2yrsbrwai4dmCiQoV4DU5poBZBLdigVvJqWjoWEM1EizaFd9AP50t0GBxRr8dDfq1PxXvIUPkDpcV0YEVAkSI5KWAc5ul+7vXrFGIExGkHDG2LoycrN7pXo9VcVD4ntu/8/4mu7+LLuO2YES9gdIvFG4FbxE3CZeFuxTDrJhjXN1w==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(396003)(136003)(39860400002)(376002)(346002)(230922051799003)(64100799003)(451199024)(1800799012)(186009)(31696002)(26005)(6506007)(2616005)(6666004)(966005)(66946007)(5660300002)(66556008)(86362001)(66476007)(44832011)(38100700002)(31686004)(83380400001)(6486002)(53546011)(6512007)(107886003)(8676002)(8936002)(4326008)(478600001)(36756003)(316002)(41300700001)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?em9kNEo4K1JHL09kVVRMNEUza1owajJ3MXFjVEJ1VTZsTDV2eXZKSi9SUDY4?=
 =?utf-8?B?dlBFRDdQOStFc0g2ek9YeUNRUkN4eW9aNVUzZEdKOUl2dWtWU2RhS0dkOCtP?=
 =?utf-8?B?VWlSODRZd1hqTE55TU5xRC81THd6aU00WW53L3BBTm9kcDhqQ1Z5Y2xsNGll?=
 =?utf-8?B?bUlZZ1pBVUNkM1IyNk8zcGEydHpvQzUzZVRubnJSWUppZnRKMGNQb0FpVng4?=
 =?utf-8?B?TUIvcHhFcG9uMkpqZDcyTTFqUjZJZnVySFlLMnBXNkYxanovd0lBMEVQTVV2?=
 =?utf-8?B?ZnJlR1ZGRFBDRW5Yd1dmT1VWTFptdEhMdTlCQlVYcVZNcEFRU1dYVTlwNXJO?=
 =?utf-8?B?YkVpTGZCZmtpd2pmaUJQcStMSmF4cnpKVEtOREJJaEZ0V2FZZGlwSkJSZ2lD?=
 =?utf-8?B?SUtKZFBwSzVHTEpNbS9ZTTBqancrOUh2dnMwSzkyTjZNMWIxclUwaG5DRFpJ?=
 =?utf-8?B?eEpUVG4vUGM2SytKWDFHWWZNOE45N2NqUXlOcU1yUlJwUDVwSTA2UXhDdHIv?=
 =?utf-8?B?S2xwWEJ2blFrL3pQVFczSkE4bkh6SjhjZEUxYWl4QS9TL2JBM1Rpb1d1S2Qz?=
 =?utf-8?B?ZGRTa3pwWHkwR3dDR1huMFhzZmc5TEd3TEZrRitoZktKQjZkNWRzV1hWaVpL?=
 =?utf-8?B?b2tNRHhydWdDZFF0czdtNXM5VG9LcVkzTGdPa201T296WTEwODdiTnBtZ2di?=
 =?utf-8?B?REprMmZjZHlmeTg0ekNaeTdUdVhtT2JvTGVJeU5ZYzl1WS95TTRaK0k1NDZE?=
 =?utf-8?B?K1lBaVZoNDQ3NjgvaER1RXBPNmRKUzdJSjlKQ3dXdUNLYWpUNDNJT090Y2VZ?=
 =?utf-8?B?QkxqOUNmVVN2TDZFZHJwYjR1Uzc0VC9vMTFaMkpzeldPcFBzblplWHlId0I1?=
 =?utf-8?B?MUVTcDVHTnpOLzR1ZWxzYU1aUDNwRjk0bmhNUFY5dm5veVdiZnpJTExsYVVr?=
 =?utf-8?B?T3ZVVXpKUkFidkJtTFBEL0JOMFV1TlJHT2hmRE5iRUhTQnFUWFlaWWQvMUEv?=
 =?utf-8?B?N2tHa1c2QllDcDEra3NERlFEbUlMbzlVRFNpMzdBM1R6RkJaaWhma01jek5G?=
 =?utf-8?B?VkZZUGY2KytGZW1kNFp2ODRSUXlWRVplNG9tTHlIN01MTUJqK1RvSVhZNDFm?=
 =?utf-8?B?UnZHaFFaQWgxbTB2a281TCtnUVUvSHhlUjVnYi9UdVA2eHdVNzhTbEN2NHlZ?=
 =?utf-8?B?WFI1TjdRM01taFpxN1ZpaEVhWUcwYWtuWmNBalpJNTJncU1MQ3g0NFBJQS9J?=
 =?utf-8?B?cnFmV3ZwWFo2Ky9rRVcwRjhodGlvL2NxNk9HbDlDeDZBMlZQMWhKZGNxUWcy?=
 =?utf-8?B?c1VUZnJwYkdiaUZFYW5xUVJIOW56aU9CRXp4NkxLUUVlTjE2NUdwMElobmFU?=
 =?utf-8?B?S1hjaUorMm1lUHA4NGxSNHR5QW1TSnBuYUlvM0k4SXRseGkya3g3WlR2N05t?=
 =?utf-8?B?dG1kcXllcVNQTzVMaVNWVktHSHFrMlV3NFM2VGg1Slp0MG5wbS9pRit5OHF4?=
 =?utf-8?B?N1lMTHY5a0FrT0NzWCtTdUF6TE9lT1JyNmwzdlI2MFpxT3VLU2RRSzIzNllk?=
 =?utf-8?B?UTZHeE9PK0cwUmh6RW4yN0l6Q2NYME5aQkVMQkplUStsZGlFQXdMS0JFZXBU?=
 =?utf-8?B?ODVrWWcvRU54YmhMb24yS2lSN0NlZHdTNEFjZ1JLRnhDMEpYNFBvelhCaVh2?=
 =?utf-8?B?ZTRjUldDbk1RbDdzSVo4NXc0QkVQa0dsY0VsUEt5UXlmK1Q1bThyRXhpSjJQ?=
 =?utf-8?B?Qk5GaXg1SVVvbmFUM3VabkFkeFRUU2d3U3VER0ovUVVYTklzOHA5YldxdUlW?=
 =?utf-8?B?d21tc2MzMU1XckdUZ1VTZDdXdXRPZGEzRDFJdk9PenJhUGQ5WURFbEZDa2ZR?=
 =?utf-8?B?UkZhMTdUdjl5czdoKzZCT1VkOU9PMmZ2SVgrdnAvenFueEVhamJKVGpOd05C?=
 =?utf-8?B?SklIbFBLM1JYNG5RejBvMHlRUzBCOFlmVWxVTUV1RlhnLzF3N0QvMDhrVnNP?=
 =?utf-8?B?VW5kUTcrL2RKclFPSXpwNFYyd0xsc2pVNVpDNmVSRjRmbjJnUGl6Zmh1Q2N1?=
 =?utf-8?B?N1gzSGNSZFpHazBQeFI0RzU5SHRrMkdleVFmcTNGeXc4bXo0MWkxQ0hHbkVT?=
 =?utf-8?B?cXlSNWVCaGJsVjNHdXl5bXZGcGJrVi9UeWlZVmpGU3U3S0RGd2NiMVc1QkhI?=
 =?utf-8?B?NFE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	E3CYXZcIwXYCAXu0ggF2doKGbHN/w+sSV5Kqu3kxee25md4R08/TYJNHKmy/o8ZeNFS7MDgE5dqwkDgDpIgY0lqn3wV0Vhq7JCt5bYie1HvjJRB8egnbVxfsSpYw8s6pR1kp0GtDas64L5qYXcD9IGOX83MLzRv+2WrO5+TkC9eSBHQQ33FDHASNm2BME1WtfbRp0MZ0K5+MIx32ajhgPQzOxjCWZ4mdvtnfTBq95idUJsVQzLlAPN3ProiSvkQ//SghxJlAyn2WzOZ4xdBlbc7W5AHEAvuJ+yczRDJdE6CPN1pEmoY6xCI3P/hRAPeotmWs20XdeBfwifjd+Wqcot3UkRQg/5Yoxb7ReM3HBRMOt0n2oTPVpFSd0rRj3y1W++Ft+G3osP/T5/BVgQt5uw2/Q/hiCE9lVctzUYgDtvH8D0o5rDWyLEy55VJhs7/LG8oAvyzYaLueCHeb76+WB7CIw7jEP9o+VrPNMSPorpBMT2NPAYFfSlMXtVWahorFMvCm3tDxtCZ5+fRx9YhrBa9LhQtQDcsUg7oOkzKAGbrwWu1dG9WdlDaaOxEawT9bMS5mnbt3TI7mEyihEmRtw1sLTi0vDCJp7boDwBYer5M=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5cd8b379-b66b-4d59-9aa9-08dc1edcd7bb
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2024 02:08:24.2162
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HnbFXtUfElR+6GfgBYSTtIZ1iYPuPntymqb1urngzMcMdzJUsGw1OwclhMfXNmqYT7mgBsSaJuUThzR0FYIUPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4631
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-25_14,2024-01-25_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 mlxscore=0
 spamscore=0 suspectscore=0 adultscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2401270015
X-Proofpoint-ORIG-GUID: j_MdA7RW3ETk8X4ErjUBDeUsxFSDJszF
X-Proofpoint-GUID: j_MdA7RW3ETk8X4ErjUBDeUsxFSDJszF



On 1/26/24 16:20, Dongli Zhang wrote:
> Hi Maxim and Paolo, 
> 
> This is the linux-stable backport request regarding the below patch.
> 
> KVM: x86: smm: preserve interrupt shadow in SMRAM
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=fb28875fd7da184079150295da7ee8d80a70917e
> 
> According to the below link, there may be a backport to stable kernels, while I
> do not see it in the stable kernels.
> 
> https://gitlab.com/qemu-project/qemu/-/issues/1198
> 
> Would you mind sharing if there is already any existing backport, or please let
> me know if I can send the backport to the linux-stable?
> 
> There are many conflicts unless we backport the entire patchset, e.g.,: I
> choose 0x7f1a/0x7ecb for 32-bit/64-bit int_shadow in the smram.
> 
> --------------------------------
> 
> From 90f492c865a4b7ca6187a4fc9eebe451f3d6c17e Mon Sep 17 00:00:00 2001
> From: Maxim Levitsky <mlevitsk@redhat.com>
> Date: Fri, 26 Jan 2024 14:03:59 -0800
> Subject: [PATCH linux-5.15.y 1/1] KVM: x86: smm: preserve interrupt shadow in SMRAM
> 
> [ Upstream commit fb28875fd7da184079150295da7ee8d80a70917e ]
> 
> When #SMI is asserted, the CPU can be in interrupt shadow due to sti or
> mov ss.
> 
> It is not mandatory in  Intel/AMD prm to have the #SMI blocked during the
> shadow, and on top of that, since neither SVM nor VMX has true support
> for SMI window, waiting for one instruction would mean single stepping
> the guest.
> 
> Instead, allow #SMI in this case, but both reset the interrupt window and
> stash its value in SMRAM to restore it on exit from SMM.
> 
> This fixes rare failures seen mostly on windows guests on VMX, when #SMI
> falls on the sti instruction which mainfest in VM entry failure due
> to EFLAGS.IF not being set, but STI interrupt window still being set
> in the VMCS.
> 
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> Message-Id: <20221025124741.228045-24-mlevitsk@redhat.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> 
> Backport fb28875fd7da184079150295da7ee8d80a70917e from a big patchset
> merge:
> 
> [PATCH RESEND v4 00/23] SMM emulation and interrupt shadow fixes
> https://lore.kernel.org/all/20221025124741.228045-1-mlevitsk@redhat.com/
> 
> Since only the last patch is backported, there are many conflicts.
> 
> The core idea of the patch:
> 
> - Save the interruptibility before entering SMM.
> - Load the interruptibility after leaving SMM.
> 
> Although the real offsets in smram buffer are the same, the bugfix and the
> UEK5 use different offsets in the function calls. Here are some examples.
> 
> 32-bit:
>               bugfix      UEK6

Apologies for my fault that I should use "bugfix" and "5.15.y" in the
table.

I may correct them if I need to send this backport to stable kernels.

So far just to confirm if there is already a backport from Maxim or Paolo
but just never get the chance to send out.

Thank you very much and apologies for the fault again!

Dongli Zhang

> smbase     -> 0xFEF8  -> 0x7ef8
> cr4        -> 0xFF14  -> 0x7f14
> int_shadow -> 0xFF1A  ->  n/a
> eip        -> 0xFFF0  -> 0x7ff0
> cr0        -> 0xFFFC  -> 0x7ffc
> 
> 64-bit:
>               bugfix      UEK6
> int_shadow -> 0xFECB  ->  n/a
> efer       -> 0xFEd0  -> 0x7ed0
> smbase     -> 0xFF00  -> 0x7f00
> cr4        -> 0xFF48  -> 0x7f48
> cr0        -> 0xFF58  -> 0x7f58
> rip        -> 0xFF78  -> 0x7f78
> 
> Therefore, we choose the below offsets for int_shadow:
> 
> 32-bit: int_shadow = 0x7f1a
> 64-bit: int_shadow = 0x7ecb
> 
> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
> ---
>  arch/x86/kvm/emulate.c | 15 +++++++++++++--
>  arch/x86/kvm/x86.c     |  6 ++++++
>  2 files changed, 19 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index 98b25a7..00df781b 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -2438,7 +2438,7 @@ static int rsm_load_state_32(struct x86_emulate_ctxt *ctxt,
>  	struct desc_ptr dt;
>  	u16 selector;
>  	u32 val, cr0, cr3, cr4;
> -	int i;
> +	int i, r;
> 
>  	cr0 =                      GET_SMSTATE(u32, smstate, 0x7ffc);
>  	cr3 =                      GET_SMSTATE(u32, smstate, 0x7ff8);
> @@ -2488,7 +2488,15 @@ static int rsm_load_state_32(struct x86_emulate_ctxt *ctxt,
> 
>  	ctxt->ops->set_smbase(ctxt, GET_SMSTATE(u32, smstate, 0x7ef8));
> 
> -	return rsm_enter_protected_mode(ctxt, cr0, cr3, cr4);
> +	r = rsm_enter_protected_mode(ctxt, cr0, cr3, cr4);
> +
> +	if (r != X86EMUL_CONTINUE)
> +		return r;
> +
> +	static_call(kvm_x86_set_interrupt_shadow)(ctxt->vcpu, 0);
> +	ctxt->interruptibility = GET_SMSTATE(u8, smstate, 0x7f1a);
> +
> +	return r;
>  }
> 
>  #ifdef CONFIG_X86_64
> @@ -2559,6 +2567,9 @@ static int rsm_load_state_64(struct x86_emulate_ctxt *ctxt,
>  			return r;
>  	}
> 
> +	static_call(kvm_x86_set_interrupt_shadow)(ctxt->vcpu, 0);
> +	ctxt->interruptibility = GET_SMSTATE(u8, smstate, 0x7ecb);
> +
>  	return X86EMUL_CONTINUE;
>  }
>  #endif
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index aa6f700..6b30d40 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9400,6 +9400,8 @@ static void enter_smm_save_state_32(struct kvm_vcpu *vcpu, char *buf)
>  	/* revision id */
>  	put_smstate(u32, buf, 0x7efc, 0x00020000);
>  	put_smstate(u32, buf, 0x7ef8, vcpu->arch.smbase);
> +
> +	put_smstate(u8, buf, 0x7f1a, static_call(kvm_x86_get_interrupt_shadow)(vcpu));
>  }
> 
>  #ifdef CONFIG_X86_64
> @@ -9454,6 +9456,8 @@ static void enter_smm_save_state_64(struct kvm_vcpu *vcpu, char *buf)
> 
>  	for (i = 0; i < 6; i++)
>  		enter_smm_save_seg_64(vcpu, buf, i);
> +
> +	put_smstate(u8, buf, 0x7ecb, static_call(kvm_x86_get_interrupt_shadow)(vcpu));
>  }
>  #endif
> 
> @@ -9490,6 +9494,8 @@ static void enter_smm(struct kvm_vcpu *vcpu)
>  	kvm_set_rflags(vcpu, X86_EFLAGS_FIXED);
>  	kvm_rip_write(vcpu, 0x8000);
> 
> +	static_call(kvm_x86_set_interrupt_shadow)(vcpu, 0);
> +
>  	cr0 = vcpu->arch.cr0 & ~(X86_CR0_PE | X86_CR0_EM | X86_CR0_TS | X86_CR0_PG);
>  	static_call(kvm_x86_set_cr0)(vcpu, cr0);
>  	vcpu->arch.cr0 = cr0;
> --
> 1.8.3.1
> 
> --------------------------------
> 
> Thank you very much!
> 
> Dongli Zhang

