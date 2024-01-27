Return-Path: <kvm+bounces-7264-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FB5183E919
	for <lists+kvm@lfdr.de>; Sat, 27 Jan 2024 02:45:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A7F711C20FD2
	for <lists+kvm@lfdr.de>; Sat, 27 Jan 2024 01:45:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5DCF947B;
	Sat, 27 Jan 2024 01:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HJkAkvag";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="UhZv2u3L"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98DB08F59;
	Sat, 27 Jan 2024 01:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706319898; cv=fail; b=d+s1zVWX1c9rq8RqY5Ihk7MIbsb1weyT+5DbwNEn9KOti3AhyEyK4zC6AD5JiTmX/xPZdtne4q9tvFONJDyPlCLOo/kMYWGAB/AFelIx0jnxSdZmgoLOSfDxbXFN1EEaXzfDgjjGJupX0yjf34rW1JKrYZrwFlvSeIB/yJs8uSE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706319898; c=relaxed/simple;
	bh=X8wxpn+8/UimbDGVqh7w/Wmz2x7QR8YOsuWdR5H6Ia0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=cbvSNyFSwmldvVTyKMhp0c1lMMdLxdEbDoTP8HRqhNMEdEKDDmhZLiXHz02xEF05mA23z+aksttBkBXCjac7FMVxnClmqNIrbwsYf2/aIkXw4FRTrDifOkfQqztLSTXIpMS9Wx9kqx9xZDi7ecRE2Mj0sNNoJDkgk3od1bKhE2s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=HJkAkvag; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=UhZv2u3L; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40R1KS2k004162;
	Sat, 27 Jan 2024 01:44:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=R6gWDP0XRK59DHyZuaf3qPApfmHVetD0cDmmsf8wb/4=;
 b=HJkAkvagza8UwHu6DgaxU15aNSjjYXuFzmgP1++XkUhsEyzPnRgrCw7UCJITE/iev/SX
 MZrF1eF39NAWBQURyCcYJTI1ruq0dthHuhaONzew/zT+aDMtKDuqm1aEn0jnZKrMEz3K
 F5p6CSrj0Xb0yOwYv1/fbPYy31uVwbPhN2VLWGmVPq7LSzzyrkv36fOEXfIuwoToiMbr
 QUEoNi//RGIpvamG6QsGiEQb52scZ2S+wTramLDeO4KyXT2/zrolezqCRRhl8iW2NfYa
 LmuvwNSCYs2AhXVpVj669NNWsknOioevzLjXl4QMt/+YZvtjXEgeyReAmzK5mDMD5h5s ig== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3vr7cwu9xk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 27 Jan 2024 01:44:53 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 40R1XCmd031555;
	Sat, 27 Jan 2024 01:44:52 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2041.outbound.protection.outlook.com [104.47.57.41])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3vvr93r777-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 27 Jan 2024 01:44:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dZskojRomqCJVRp7S0jrM7SGZJ6jcpEdpNuzD4GTwbktn4xz6svfSIETxHIn8gV8+Tjjh7LVC7kBhIvCuDNP4qBBFCA9pJjvK6VAWIXNl1y3P9Ed1I/G3a2XGia03dVqWJDAS6SsT7z713104Do4qY2mdDL3e6nqkF1CIYsPk6dU7YYeu+/yxuqPV4btYQnRi/YWGEJWNZ1gyfocieZrjC4N+jD1jSdRSoo+0Y+6oS99mu27jWGqHxGyq39ih7N4pN8Azszj8/Um277xYkFbCzYNvCKDVfwsjtIq+GqMP3n34kfs7LoocQ+05g1VvULnWeJog96bJEYh/CLdj71PlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R6gWDP0XRK59DHyZuaf3qPApfmHVetD0cDmmsf8wb/4=;
 b=biZ7xE+xmpDvaUDT+ZOlI2ZaT0hWV58ShNUx/fXF/Hynf6ZebP1Ll0qd/0qEbLrB6kY2rcK8mWW6XsW5zLbWD+ODiw6GBQXCJiiYp7LjH1k4nMz9+zwIAIXXwQFTbWd40v/L4x9nxa42QRyfKrso1uZfTRfPDkFanJRCXwIAnvEJtxm4S35TCcR3hPgGl/S1/kLVygJp/ESLHdh1ALa2/pqjOfOxYH/m4SE0ia3l0M7UdGAkPn2Y+1AQVJjnfedc9gM0y3SuNPrQBBL3RmX9Hw7HXsmIgcnJ/Xh73pZUHFUmauOszQzvVrLjJjuibuiMHHYhA80O6+2kC/CbqMmgZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R6gWDP0XRK59DHyZuaf3qPApfmHVetD0cDmmsf8wb/4=;
 b=UhZv2u3LlddpdMT8HTE7f+MnRgPMwkN41zcmGU4LBD7ZxGLu9gs0xI2gTP2zJV+TwaPUHfVlP4V68BD/5r29Ckxa6PHhdP2AuypXGRRNtElsxxF1dTGPEXx3+IZMLcbysYP+EPPULN00KVXz+Ap2cFcVUTM/fQZ1Kp+/uDGKq3Y=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by SA1PR10MB6342.namprd10.prod.outlook.com (2603:10b6:806:255::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.27; Sat, 27 Jan
 2024 01:44:49 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a1c5:b1ad:2955:e7a6]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a1c5:b1ad:2955:e7a6%5]) with mapi id 15.20.7228.027; Sat, 27 Jan 2024
 01:44:49 +0000
Message-ID: <53d7ad5f-db9b-31f0-32dc-99031e09f22e@oracle.com>
Date: Fri, 26 Jan 2024 17:44:44 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: Stable bugfix backport request of "KVM: x86: smm: preserve
 interrupt shadow in SMRAM"?
Content-Language: en-US
To: Greg KH <gregkh@linuxfoundation.org>
Cc: mlevitsk@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        stable@vger.kernel.org, joe.jin@oracle.com
References: <20240127002016.95369-1-dongli.zhang@oracle.com>
 <2024012639-parsnip-quill-2352@gregkh>
 <79cace24-b2b6-8744-c175-bfb0a1bfc6eb@oracle.com>
 <2024012614-wreath-wreckage-f291@gregkh>
From: Dongli Zhang <dongli.zhang@oracle.com>
In-Reply-To: <2024012614-wreath-wreckage-f291@gregkh>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR02CA0079.namprd02.prod.outlook.com
 (2603:10b6:208:51::20) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB2663:EE_|SA1PR10MB6342:EE_
X-MS-Office365-Filtering-Correlation-Id: 87865c60-561d-4dbc-20b5-08dc1ed98ca7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	KN+2wkqQnH6UESNqj0hxmsswzVIkugpjWpvMhjl1Na0yKucSPqGomouV6r7pcjKshIY38Gw1vm2I8RrnY7+v8LyRN+CeEZF8THBq+WAum00JKw1h87rEMbvAzuuoRXR2WmXxfFkRo1RiCslyroCgeVhFdmwPOAN9wgLKTN9YS3L4M+n4LzS47OIbIxURLXGuAxfL1sY8BNrOVWxcS19cb87rJoZPnZOxf5SejbYP4goImmqFbbh/p7pVu4DY+6yEnLSWS2hE3htrL1G2hNx1xekMDPO9i6aplLG3GWwKvMyKZlufeTzPQZ707mNheh9LnFQTGBxjKZEj7A6Bx+WxeZKfhg4kc65ebNJHqGBwUxh/SvpwB/QgMVgwlfWt1nUqBGg0tKQnuuARGr+BNSPhQdluzYaqoRdhrX4l9IrCTNdv4sEhFF98vFpDMl2yZcsIVOwd+P+xtO0Hotl4oeEeXRaHUscp5qB7vRS3utg/wj0cWHyTLrzCGCJhZfHp3Ll+pc31AhDq9vU1LMRBCq+VtWnQA76WCS7dlWpyoAoRr6/C68HKVe3V/bYM/oYD0QtdRNYduAVxwSouPcquA66gQH/AZSq4fRhyviGNiaxMOYj8KV6BeqeRb2JFvGE6sxQhJnhje0qR/3GEoEJdQX8qCQ==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(396003)(366004)(136003)(346002)(39860400002)(230922051799003)(64100799003)(186009)(1800799012)(451199024)(41300700001)(4744005)(38100700002)(2906002)(44832011)(5660300002)(36756003)(6486002)(26005)(31696002)(478600001)(6666004)(6512007)(107886003)(6506007)(2616005)(83380400001)(8676002)(4326008)(8936002)(6916009)(66476007)(66946007)(86362001)(53546011)(316002)(66556008)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?V1h1TzQycENLNkNwUENEQXBab2VpemhkejA4TWNCbXpDS3N5RzRHUW5KZ20z?=
 =?utf-8?B?YU9rcDFpcFYvY0NUSzlWbFVLWThLMk9nNENnNkRWSldOY2tkRXdIR1Nkd2k1?=
 =?utf-8?B?RG5ycGZkaU5TV2J6TDRQMXBPeWlqdTB6YjBCMzNBTzVTY1FuQUlQemdqTFhw?=
 =?utf-8?B?RUg0OUE1V1NBcjl3cmtMemdRMTQxaVRBSzYyNGdXcVVaSEpCNGJCL2lFbU9p?=
 =?utf-8?B?YzVUa2RJOUVpcERab09teUJUQ2VhNTQvVkdyNEV0TnZ0QStXVENkaWY1WWpw?=
 =?utf-8?B?VjVzMm5LRkpyYTRyR09ROWhZd21GZ3Z3SWxQS1I1aGhhVjNDMk12TmY4Q3dX?=
 =?utf-8?B?aFlXRzNEY3I3UDNnNW5LMm9uOWhCNy9DbGpLT09xZGlJOEtxVE0vZ2dVSFB2?=
 =?utf-8?B?bUNQNmdKWkQ5ZUpGelR0d2w0UWliYSt5dU8va3h3c2lGVHdSeW1qNmFldlhn?=
 =?utf-8?B?NFIrdW5aS3d5bi8zcDRYMUdlQnR6b0twdEsvRWFsY3U2NXN2cVpnQjc2Q2w2?=
 =?utf-8?B?KzltVEVObjBqdmwxUjkrdmwxaGNDWWtVQk5hemFGQnhpSDBHVm1UWXVjOHA2?=
 =?utf-8?B?b0VOdWVabGpzQzRlNU9lY0RFWkVhRHk1Mmw3WUI0VVR3dUEvSjJyYUJKWVg0?=
 =?utf-8?B?dzN5OXFKUHlhdVg0QWVMdTVDQklyRWxISytWYk9GTFNPUmZsSDAzRytzTzlX?=
 =?utf-8?B?Mk9mU1cvL3lBK2phamJPYU9NUGpLSnhuTDZ3RkIwczNnT1BOWlhkZGZKcU1H?=
 =?utf-8?B?SmQwY0VlSWtlYUlISi9Rdlg5enJlSkhxbVpITmpQNkg0OWtrekFNUEZpMHZR?=
 =?utf-8?B?Qjgrc1NtbUViUFZUWUc0bzNXdHYrWFNxV1d5SGhqQUF5LzJmN1c5SWloamdq?=
 =?utf-8?B?eEpLYUpTTW5mMGgzMjFqWGNpZ0NKOENBaHZuOUlKQzIzV0QrRmU4dmVidHNL?=
 =?utf-8?B?aitBeUIvV1RNWWo5TE1oVTc1SDc2eFFETFgrTTRPdHFWbEQ1MVZ0d2QzRnlM?=
 =?utf-8?B?V0ZJcStjZXZMOVh1Q3VSd1ZId3JzdzZZcjhhdjlCSUt5eFdMNkhZL3gzUVFw?=
 =?utf-8?B?Y01qVWV3a3Y0QWhzM0FhK3gzd0hYQnl4SVFUNElNdFVoYjJJV0NVaE1MenlJ?=
 =?utf-8?B?aW54azd2OHd6NXp4WW9td3pra29FcXIzNjNYYncrcXpHYml1OCtFVS9LQ2Y5?=
 =?utf-8?B?dFdFcUZob2dGNVZpcUJaNEkxMExVWEZRc2FYWXFZenFnV0FIQXpab2pTOXhR?=
 =?utf-8?B?SGFkRU1aSjk4R3VGaURlZTRSbUF5SGU1YjJCcG0rNTM2N0lxaWlaRHhFbUZJ?=
 =?utf-8?B?UEZYeS83TlU1OUtCS0ZmNjZPbzZOSWtMMlZUbWFnZGE0Q2Vuemo0SXNyTDNC?=
 =?utf-8?B?WnJXekIwUEhCQUZaMDJlYzdTeDB5QkJzd1didTc1U1g2Ry82VkpQQmRUeHEz?=
 =?utf-8?B?bVAzZGtKVFJBbnQwbkVUdnFiQ1ZGUEJCKzNLdXN3bGJZR1l2SDdnbTFyRjNz?=
 =?utf-8?B?VmM5cE90dFFtTGxhUTZod0c1ekx1ZmE3YnI1d1NGb0dKR0czUzNPeWVaQkNW?=
 =?utf-8?B?ZUtHaWxSZy9qSFRHNGlTTXJ1V0pqNzZJY0xyNXFWZ0JwTlJFTko5N3ZoVFps?=
 =?utf-8?B?ZVNlVVUraU1mYXI0OUJPZ1k0SEN4NTRMVDJRbS8xRll5elMzU0F2QnpHeXVo?=
 =?utf-8?B?ZHBncFdiWDJLT0g5cU54UFgyOUM1aVI3R0FXei9wSlpQOFhiclREZ0VpMzE1?=
 =?utf-8?B?bGYzcVkvVlJFSnZMTHhqUmNOZDNmSnVITFF4QVAwRGw4QUoxOGhUMDlyRmpR?=
 =?utf-8?B?c0VUaUN5bWZQMDdQMGRiNUdjU2NVdSthYTFzVlU1K01CMXFDdEtvUDRYZGEw?=
 =?utf-8?B?bFliM0xLWlVLTHVtSTd4aUd3UnZjVXVZVER2bmZvSUxJcHYycnBKMFJHdlov?=
 =?utf-8?B?cUNpQkx4WDN6RzU5WWNGUDBkZWphMUJwN01qNGtGdnA5RGJmMGI3SnVTMmVj?=
 =?utf-8?B?K0duZUxuSW5NNGZ6TnFIa0N1aWU3OHUzRnNMNVA5TTYzTjhIdHFuSkhQL3Vo?=
 =?utf-8?B?d0c1R1VpUk41NERzNHFycUZtMlB4QjQxYnJ5bkp2bDIybXI1THArS0J3ZHp4?=
 =?utf-8?B?WmEwNnU5eStZcWpoU0I4REJhTE5aRzB3NjhNWVRzVDdUd0JTNzVuUTA5aFpN?=
 =?utf-8?B?eXc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	tqqiuMtCOyptwtxnIJ5JO0oOb1xyDSZwjtXOaFhVPwoWE9nJVFNROkRO0N0QYUPaJb9R0Uyx1TkscwKtHpAlpVTmxBLdqCN3chsEIeaOGAvD0eLOgFd94HHPX4Hrq6nIn43GJKilAaFqvT/S5plfOtVvbzYr2haIidc8yOfI4Gc/wMe6y6II3RenUIUpwaT+z4slQcMD2CUgw9/TM+r8sm6oPyLRP9HR5l2zMY/tcOPk+NQa1fOfGXDCTW5wYDY1kAXRNMUH4HtIiVVxgo/XP5524jIZc0kXh4MzB1rH6dggSmgh9NKwyOS/kllp5TNfDXjFj6oMVJp6ajh4CHjBv2pDgrqMi3eWt9+PfiYSZQD+sar7reTHv03jzd3A28Q6vC55qiU1T+pXGfv49MVUFTlHvNW4ySi9Q0Z3aPCCcZ/ZoXJiXGyyFK36W/Pr27ZEMA9BZ39CX5Ths4hOC0CfGQbNgcU6mjw5ymtF6oynqOG7ADAOsDM/YaOo71GaBNdoWblPhIVTtmLX0eZhmhfc7B9rflMf8nsEB9b0E4GBzzI1+uVSNmdrIUXodTi+UxMpZ/T0aRCWBAEerIelmuoxKY4QHqkRzbmrld4vXiFBnJc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87865c60-561d-4dbc-20b5-08dc1ed98ca7
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2024 01:44:49.7821
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Pe4SndN3whihgvGgh1VRoXJwTBMO79t8cjt0wl9b6OK5SEGb2Ns2/VGIYgRHMWbjbHQb/bw31K8d04Ls3rE1pQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6342
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-25_14,2024-01-25_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 mlxlogscore=838 spamscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2401270011
X-Proofpoint-ORIG-GUID: ncl9pA-_i8c3v7eEXUmq9BJXAXSR7PTn
X-Proofpoint-GUID: ncl9pA-_i8c3v7eEXUmq9BJXAXSR7PTn

Hi Greg,

On 1/26/24 17:38, Greg KH wrote:
> On Fri, Jan 26, 2024 at 05:33:28PM -0800, Dongli Zhang wrote:
>> Hi Greg,
>>
>> On 1/26/24 17:08, Greg KH wrote:
>>> On Fri, Jan 26, 2024 at 04:20:16PM -0800, Dongli Zhang wrote:
>>>> Hi Maxim and Paolo, 
>>>>
>>>> This is the linux-stable backport request regarding the below patch.
>>>
>>> For what tree(s)?
>>
>> It is linux-5.15.y as in the Subject of the patch.
> 
> Am I blind, but I don't see that in the subject line anywhere :(
> 

I did not send the patch directly but had copied the patch in the text.

That's why it is not in the Subject of this email, but the Subject of the
patch text.

From 90f492c865a4b7ca6187a4fc9eebe451f3d6c17e Mon Sep 17 00:00:00 2001
From: Maxim Levitsky <mlevitsk@redhat.com>
Date: Fri, 26 Jan 2024 14:03:59 -0800
Subject: [PATCH linux-5.15.y 1/1] KVM: x86: smm: preserve interrupt shadow in SMRAM

[ Upstream commit fb28875fd7da184079150295da7ee8d80a70917e ]
... ...

Thank you very much!

Dongli Zhang

