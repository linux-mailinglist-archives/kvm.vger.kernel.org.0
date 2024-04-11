Return-Path: <kvm+bounces-14265-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DCC748A1860
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 17:16:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9AB0B284D72
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 15:16:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E769D24A04;
	Thu, 11 Apr 2024 15:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="a9++/QjO";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ZtT7N1uQ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67926224CF;
	Thu, 11 Apr 2024 15:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712848424; cv=fail; b=GfpG5L9SJ1i55NPpyQJX4HuTciHO5AxF2RiaRwTX5BD9U2NKBMZO64d5xokTqnc8AUHsi1YJSHAFkdyLBdz1EMs6DfjJAya5Z++69+85Rfq1Tt0tSkB5iDAHx8rM+CuQsXMscy+0Mgk4KZOsIOEn7TbsWsd2AFNfz1nZGCuLcLI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712848424; c=relaxed/simple;
	bh=qfcOX1v6KG/m+qt1tNZfEZ2hADsPz8rqrg2nupbHz3g=;
	h=Message-ID:Date:Cc:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=TxqxuIINlR5RM1xc11nmMPIK3Wc7W3hHj8xDtThwOyycN3pfeda/MFyseD0PMbZKn2g3Vgi5B+TiEsgxaLi7M4WRfdRDYxymGlcGDevvklckJ0QTZk4UGL5FNtaUceqnpr8QWyQT978vCIAOx1LBycohgqh6NjwPY1L9I4YxWpM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=a9++/QjO; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ZtT7N1uQ; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43BEx8UK007688;
	Thu, 11 Apr 2024 15:13:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 cc : subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=kA9qRL08sN3IvboS/yDnqhS2ftJyh58Ce+JTSRamkAE=;
 b=a9++/QjOruDDCn7jgVTLDQutjKcTNLkhA/gDyEf4yEpGaaLzjojqDqz11W0o5WYJAVy4
 mUv9e0b1x1aCSN9f7WLfSbsKW9oxM3xfTrwn12+OeMwQ6gSg51Acb3+0VxWlzCmItzjf
 g2LUu/0Evu3gumAo37nJmdiaWBvJVxicBwVncro6W872aZA0owzCjwjoKUbUqUz9rMZB
 MGOLNB70KhAwQ4KM74J9YxmKWb0Gwa+jz6/s0vvdAY8DaCNh11Sx79NpVn3iuqISqYkz
 xAKg0fP31QfSnkuXJd90/Pm5hYIEYCYKl6RtgVqbgKaQv17FauFBJbt8m+xqTeQ7xeqn yg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xavtf9nfd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Apr 2024 15:13:13 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 43BFBvwx010622;
	Thu, 11 Apr 2024 15:13:12 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3xavu9ngvf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Apr 2024 15:13:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KJGfDvzL1enJBC8FKrHhqoUX5hZA45haxAUoIQcN5nIBJE8vSBKFYmzq3J3Z/oLEO4CRNM2+7IBD8D3rrHKKA+DqpAGE0QT4AJTbuct2HuYZZeP6tp96zr1ilFhYWoAfmJ5nnmWVsOM4ZFk6UHf9nOrQQIbcjd26y/PcbK7QmgV7YX3CvlrUjqKGZzxbNDdAF4MHRvaD4Fm6sbdMrdPd9ZGDd8p8JZD6UvuQ8yEza1xRndVK3GotqinWtTPWWUVyZyTb1wkyLCiKaQgwYAAYM9zYMsJaLb7P8a4VI0J9aDU2JnwVlwicYXde560hBFHD88bCMrhmP+igj9i080+a7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kA9qRL08sN3IvboS/yDnqhS2ftJyh58Ce+JTSRamkAE=;
 b=k5QQoThzPWP/wi/eUf2IxIf0SxTHYzkDoyCHvG6EASNG/yVDfKp+30StiQzZzXnXd3PA0vBYOXWVib29UQKVLEgYEIdG7yV2l/5PSMNTfg4Avk6NS+Ngurnft3HGbeSeef5iqdNHD/AZx/PSqzkhxSaOAQZz6iyMpXXe1tU6ZFATiMA6rYaUXMrEf3MwcK0q2binsK2+K6oDqzSjnKIUsJsNbs1MPWa02K2gxLjPD5jqte/f4AYvO6r8FSmeVmgc+o1tpLQoknJSG6iVoZExyOWgiEH3ymNlRloyIsK1RVmRv/fORiIWqHlX8LqcGRP0yZfsxn98Vp73SHwgryWgVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kA9qRL08sN3IvboS/yDnqhS2ftJyh58Ce+JTSRamkAE=;
 b=ZtT7N1uQKH5rE6heZRBtcGYq7QEm+YVISNMijzsPowFDwbROU1COdGQ7kDhCl6N7DrsT/n27tmGbIvWAJ+BpTVpriTZXo9flXkSjUV0e7A4cmm7XTjMZd+43Ls+YuCxbmrs9dF0/mCxT/mhzZBX803vgCYKxUnBjwszT20ndOmg=
Received: from SN4PR10MB5622.namprd10.prod.outlook.com (2603:10b6:806:209::18)
 by DS0PR10MB7429.namprd10.prod.outlook.com (2603:10b6:8:15d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.46; Thu, 11 Apr
 2024 15:13:02 +0000
Received: from SN4PR10MB5622.namprd10.prod.outlook.com
 ([fe80::1481:809a:af18:ac44]) by SN4PR10MB5622.namprd10.prod.outlook.com
 ([fe80::1481:809a:af18:ac44%5]) with mapi id 15.20.7409.053; Thu, 11 Apr 2024
 15:13:02 +0000
Message-ID: <99ad2011-58b7-42c8-9ee5-af598c76a732@oracle.com>
Date: Thu, 11 Apr 2024 17:12:56 +0200
User-Agent: Mozilla Thunderbird
Cc: alexandre.chartre@oracle.com, Andrew Cooper <andrew.cooper3@citrix.com>,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        daniel.sneddon@linux.intel.com, pawan.kumar.gupta@linux.intel.com,
        tglx@linutronix.de, konrad.wilk@oracle.com, peterz@infradead.org,
        gregkh@linuxfoundation.org, seanjc@google.com,
        dave.hansen@linux.intel.com, nik.borisov@suse.com, kpsingh@kernel.org,
        longman@redhat.com, bp@alien8.de
Subject: Re: [PATCH] KVM: x86: Set BHI_NO in guest when host is not affected
 by BHI
Content-Language: en-US
To: Paolo Bonzini <pbonzini@redhat.com>
References: <20240411072445.522731-1-alexandre.chartre@oracle.com>
 <7f1faa48-6252-4409-aefc-2ed2f38fb1c3@citrix.com>
 <caa51938-c587-4403-a9cd-16e8b585bc13@oracle.com>
 <CABgObfai1TCs6pNAP4i0x99qAjXTczJ4uLHiivNV7QGoah1pVg@mail.gmail.com>
 <abbaeb7c-a0d3-4b2d-8632-d32025b165d7@oracle.com>
 <2afb20af-d42e-4535-a660-0194de1d0099@citrix.com>
 <ff3cf105-ef2a-426c-ba9b-00fb5c2559c7@oracle.com>
 <CABgObfZU_uLAPzDV--n67H3Hq6OKxUO=FQa2MH3CjdgTQR8pJg@mail.gmail.com>
From: Alexandre Chartre <alexandre.chartre@oracle.com>
Autocrypt: addr=alexandre.chartre@oracle.com; keydata=
 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
 swLliy6PdpST
In-Reply-To: <CABgObfZU_uLAPzDV--n67H3Hq6OKxUO=FQa2MH3CjdgTQR8pJg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PR0P264CA0103.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:19::19) To SN4PR10MB5622.namprd10.prod.outlook.com
 (2603:10b6:806:209::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN4PR10MB5622:EE_|DS0PR10MB7429:EE_
X-MS-Office365-Filtering-Correlation-Id: e1e25b7d-bd6a-4cf4-cfb2-08dc5a39e179
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	4cz11twSkxbqdqTbI0M3QawnWzKnP39bK6af9ks92IEJEmMC2YyhMzl3ZJpzudhfUdS1oIh/b5TpBBGIVwgg3vb7H4c6y65vROo8s4ENoZFrNZohyeCIicehS8Dm/W1rtmeaLKXk9fnytilvh+3oWXZ6UTslXMHf6uABgl0b/i2Wjrrugbs4qV7igWpaRJ2U+Fa0jgH9C/r8tYdz+OJxfaeGIe29qXIizwzO8pBjQyRiWF6hDUA3dkDdbGE+uNl6APUfE/cw4Dh4j6vFV2+m3YcfOE9tNgEOTgYVYmze8CUkmP/UFWFCsmptgIYqSPBBOJXV+SsHsMELwTle/c6jLmgNO7XyGx+8j9o5nQDXY2b0k+DWwzsf08jeF30XOgXY0twu0wqGrcIsIefatoxDq4DRDFJU9HnvMoeodp0dFdbBF/knz21dZgtFHtsi6cNGizhlYunWjr2Nk+QGi+SjOLnLzdd8wfokOntKdrt9kmtGWpeRWm9qER7G2Xr1zRmrdiQjhFRNtdtd6EFGCuslviWu7selOkf5WqQXnFUgtu8194Xa04WCj82f5GbG3rcbRQbGrVAvR88mwCQ2PR0zM8it8gKv6+7MsPaxIWRZrjZ8UrBWruC48ZLasmUtPZIOw1+67w3GdSZ2W4Pu+9w6UzNGPtEApgMZ+hGCvdmh6wY=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN4PR10MB5622.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007)(7416005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?M2hGdWE0QmdOaXJSRnpGMUN6K1VZczlyWnYrS2xqTm03OGtUTlFQaHVxb1JM?=
 =?utf-8?B?T09LaDVTYTdZczRCTkQycUpSWk9sb2l5RzF3Q1YvWjBVeGFWV1Boc1pDemhX?=
 =?utf-8?B?ek9VMUdLeWNwek9yRVlSWHhucC9qSkdmck90RWQyY1VPUlV1ZnI2endGSmFW?=
 =?utf-8?B?cHpJajRZb1M2em8xZG5ZZ3RvVnAyY3VQUmtSanQzZWQxWXY2Q2MxUzlBWmhu?=
 =?utf-8?B?QXIrRThtSHl4RTJUbFYyb1JpRWMrMWZiY09UdC9iQm1zbys1aWFuRWtwSkow?=
 =?utf-8?B?UFg2SlU2WWxTNXVUUHlEN3ExZlhmR1V5YnY3SFh2UkdFakU0dk1JYkRjVkxL?=
 =?utf-8?B?V2NNSXd0aEFOSlRvZWtaaUx4dFhtUElkYnBxcmYwekZ5a3VIdmxpMHNMVDll?=
 =?utf-8?B?OTBidlJOL25uSFNkVXM0eExIQUJtWk9MRVFQKzJUTTNXN3g3eHBxc1FzMUVH?=
 =?utf-8?B?S2ZaTTRUaThySi9vTGRPYmFyOW92aDExUlBOai9nZXQ1ck1PT3dxMFhtbUV6?=
 =?utf-8?B?QTl1d0pPQmRaOVFTTHltbmdjSHRoNkY2QnFOMFJ1ZXZSUHE5d1Q0ODNkaVRS?=
 =?utf-8?B?dm1jTDh6bXQ4U2d2LzN4Nm1ZaUkrUDFnMHB5dkRldHBhVVcyRVVZT0l5dDMr?=
 =?utf-8?B?UGp0TWF2ek5US3cva25wUVdCMjZTUXc0T3VvOUhjYUZHK3NNbk5zSTg0bEc1?=
 =?utf-8?B?RkFhbElHRlJtWlFCTjBBYUpTUmJhYUdFU2xMeHBBa20rQXFpQUdZdG1MN1VK?=
 =?utf-8?B?OUg1MkkvWlJ6NDlSdFdKeHBhVmFLVmNkY2tscE90WHZLRWhnQkpOZS9ha2xs?=
 =?utf-8?B?QzhoVjE4WjQwczJ6LzVnNitnZUZVTStEQTR0TVRFZkdsNmRJYTNGaHJZN3Iz?=
 =?utf-8?B?aGVVczJCUDhTK2c4VDdseUlic1JVdUlsVmkwUXNYSHdrWFh1OWZINk55MXlr?=
 =?utf-8?B?eVNQNzZvdk42dHc4VnI5NVo1YTEyeG9TcTEwZVFzSnZnQ2pGd01vTWVPNjhN?=
 =?utf-8?B?TmZRVUZueFdWRjlNYjEyZlRTYXRpcnExV0Z0L0R3QktUV1FyYkplT0JHYWN6?=
 =?utf-8?B?T1FEVzd5WVlJd3MxM0NyS1g4aFlGZjNqMm9kNGUySjh2djE5SlBsajFiK1hQ?=
 =?utf-8?B?bkRDMUxzSHNnRHRNMlRzQlIyRVZCSWtoU2RQL0FpT0h5bXM1QkU2dk5IWDQz?=
 =?utf-8?B?RURlU0wzOVJWZzR5Si9rVjRVSE1PSDA2VjZkZEFWdFd4TFhhRHhjd2w3bWUy?=
 =?utf-8?B?TEVrL2NhbkNlaFdCenY3SEJWZW1PMHphUVNLSVVEY0dWWHhJQy9nb0xKcTFz?=
 =?utf-8?B?RzBGa3VRUGlxNllZRmpZTysyK01YZ0t5THNaNC9rWnZwMTQvSGV6dGh1c3ZO?=
 =?utf-8?B?Q1hIcWtTS28xc3NPUHdMWEdBYVRDVXNxK2hqMy9oQUNIcHhXb1lKVVd3NGN2?=
 =?utf-8?B?dFhEa0NaVVhab3BGdkFta2U5MDZzYmZGUVU5NDdibWdDbURYU2dtWGpGdk1E?=
 =?utf-8?B?ZUJmdm5PbTg4VUUzL05ORHJJY0kyMDdxaHpPbXRzdWdDMG92NU1HOEU3QnVs?=
 =?utf-8?B?NmUzeU5VS2lsWTVlOW5ZVGZzMHlERFlKb05NV1hNZHJzV214NmlIOFdZcnE4?=
 =?utf-8?B?aEpkYU5oK25tOFlzMUNMSk5Ob1NVU1dON1U4V3ErUUJpbnovWmNGaDd1aVE0?=
 =?utf-8?B?Y3UrcVZaQlYxTGE4bU4wOCtaYXQ2M1dMNEpxREZNOUZEUWN6MmVydkVtNjlv?=
 =?utf-8?B?R2dlT0djVUU3dHFnZ3h1OUYzQ0VzWWxCcUprck9IOXNEUE1NL2ZSK0tIcG9v?=
 =?utf-8?B?NXJzNzlHbzEvUGZ6djUzcHR5WGkyeWUycm0xcndPN3Uzckl6WmV1OEcrYWFi?=
 =?utf-8?B?cUtPSExFWW9XbkhyelAyVEZ4RldndURKdXhPaytGaW8zZnl0RCtnakpJRnYr?=
 =?utf-8?B?MWNsNHZPMEZsTmkxME1yYW1ackJXVk1zeE83eDh6ZzVkQ0ZGZ0xkbmdWWTFN?=
 =?utf-8?B?ejJpOEpsVVZRRUZLbGVZNlZSdzJUalNnWUZHS0E2bEtRS0hTTDRVd2xEYmNF?=
 =?utf-8?B?V01EN3h2WnQrZVgwN0dNbktFckxtTUdvdlppKzl0MklsWERLNTAvSTVyMWVO?=
 =?utf-8?B?SDZUYnIyZGxWTXVIQWpUbkpEYitzTk4vb1QzejRFcjJHUXdDaVB2RlJRWUVW?=
 =?utf-8?B?M2c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	NjRQ6NAZmnrRhuTJfTHe6KadGiuXxheEy1wPYCDDK18kaWLoWTtB98dCuOcqPKuEL65wUraifG009/IZ+zqDgy5NByRh9M9o9JremtY89RAC2Ja5YOT9/eUtnThX+kreJeeLNXFbCpK1lLIfGdtvH5jwYrqDXAF7Bkq5iSRtB+9XwnRkiBqOsp7VrdVRPIQ/d98SBau+sIdRonDJr1B4BH4UXLbLu1zZcHPI3b2Ren+P2umCjT/y1KQJfkyLppyEZ90+Kr3yH+URPLjX7/xTQpSItkZyg870lTX/v5OkFcx/rFKA02SVlDiQTheEyg/Jz/wkKCRGoU2yK3I9PSnTOwX+u7h7i0LTzjPUHdXq272mnt3cU7B+gQNfzJ8wIqZsxtfeRKgXwtzISVKYf2FPxrTpf6Ojg1JG8Y0jK6Xm+BwhmAbyeO2DQoJ4z3o5qlVL8I8mqGk4bj8SuFCCHA5FtfW1oa3yqGnXQhKD+R5UmpHd2YAdHcX95ZmiX7G2GLIpENdYuLE2DvD2JanBQ9pYZqCaeHUd6ovTC69BB4VaLNOVod6fTBZnbxd5+vw1nd2KBkJRN2tAfInL68gN1VjcycJFK0iRVjznYfAzDzuGbr0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1e25b7d-bd6a-4cf4-cfb2-08dc5a39e179
X-MS-Exchange-CrossTenant-AuthSource: SN4PR10MB5622.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2024 15:13:02.4961
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KL/SurlmJbL4jYFrXm8WnZbZZOfhkJPCS+Gu9h9qevLii82Fbo8sAENz1BDcY8WwErC3bU+xcg+uxYypqHM8j68mPfQuXp3L4U3UTaVMStQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7429
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-11_08,2024-04-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 suspectscore=0 spamscore=0 mlxscore=0 bulkscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404110111
X-Proofpoint-GUID: dtW1Vq5PXkj_VVgcbjiAVfkPJoIE4Uio
X-Proofpoint-ORIG-GUID: dtW1Vq5PXkj_VVgcbjiAVfkPJoIE4Uio



On 4/11/24 16:46, Paolo Bonzini wrote:
> On Thu, Apr 11, 2024 at 4:34 PM Alexandre Chartre
> <alexandre.chartre@oracle.com> wrote:
>> Still, we could enumerate CPUs which don't have eIBRS independently of NO_BHI
>> (if we have a list of such CPUs) and set X86_BUG_BHI for cpus with eIBRS.
>>
>> So in arch/x86/kernel/cpu/common.c, replace:
>>
>>          /* When virtualized, eIBRS could be hidden, assume vulnerable */
>>          if (!(ia32_cap & ARCH_CAP_BHI_NO) &&
>>              !cpu_matches(cpu_vuln_whitelist, NO_BHI) &&
>>              (boot_cpu_has(X86_FEATURE_IBRS_ENHANCED) ||
>>               boot_cpu_has(X86_FEATURE_HYPERVISOR)))
>>                  setup_force_cpu_bug(X86_BUG_BHI);
>>
>> with something like:
>>
>>          if (!(ia32_cap & ARCH_CAP_BHI_NO) &&
>>              !cpu_matches(cpu_vuln_whitelist, NO_BHI) &&
>>              (boot_cpu_has(X86_FEATURE_IBRS_ENHANCED) ||
>>              !cpu_matches(cpu_vuln_whitelist, NO_EIBRS)))
>>                  setup_force_cpu_bug(X86_BUG_BHI);
> 
> No, that you cannot do because the hypervisor can and will fake the
> family/model/stepping.
> 
> However, looking again at the original patch you submitted, I think
> the review was confusing host and guest sides. If the host is "not
> affected", i.e. the host *genuinely* does not have eIBRS, it can set
> BHI_NO and that will bypass the "always mitigate in a guest" bit.
> 
> I think that's robust and boot_cpu_has_bug(X86_BUG_BHI) is the right
> way to do it.
> 
> If a VM migration pool has both !eIBRS and eIBRS machines, it will
> combine the two; on one hand it will not set the eIBRS bit (bit 1), on
> the other hand it will not set BHI_NO either, and it will set the
> hypervisor bit. The result is that the guest *will* use mitigations.
> 
> To double check, from the point of view of a nested hypervisor, you
> could set BHI_NO in a nested guest:
> * if the nested hypervisor has BHI_NO passed from the outer level
> * or if its CPUID passes cpu_matches(cpu_vuln_whitelist, NO_BHI)
> * but it won't matter whether the nested hypervisor lacks eIBRS,
> because that bit is not reliable in a VM
> 
> The logic you'd use in KVM therefore is:
> 
>     (ia32_cap & ARCH_CAP_BHI_NO) ||
>     cpu_matches(cpu_vuln_whitelist, NO_BHI) ||
>     (!boot_cpu_has(X86_FEATURE_IBRS_ENHANCED) &&
>      !boot_cpu_has(X86_FEATURE_HYPERVISOR)))
> 
> but that is exactly !boot_cpu_has_bug(X86_BUG_BHI) and is therefore
> what Alexandre's patch does.
> 
> So I'll wait for further comments but I think the patch is correct.
> 

I think that Andrew's concern is that if there is no eIBRS on the host then
we do not set X86_BUG_BHI on the host because we know the kernel which is
running and this kernel has some mitigations (other than the explicit BHI
mitigations) and these mitigations are enough to prevent BHI. But still
the cpu is affected by BHI.

If you set ARCH_CAP_BHI_NO for the guest then you tell the guest that the
cpu is not affected by BHI although it is. The guest can be running a
different kernel or OS which doesn't necessarily have the (basic) mitigations
used in the host kernel that mitigate BHI.

alex.

