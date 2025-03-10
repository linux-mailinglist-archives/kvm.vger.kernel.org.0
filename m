Return-Path: <kvm+bounces-40683-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 01D93A59A3E
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 16:43:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 81A17161C13
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 15:43:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED65022DFE5;
	Mon, 10 Mar 2025 15:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="m8DQLIK+";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="xrUDwzOO"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1435122F15E
	for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 15:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741621371; cv=fail; b=AzQFGmF9RFGjJwACZrETnIZiuYQIuGpeVTSUe7bo4wf1e3vkAq56xEOVn3WHdWApv5ipTRJ3rRJFI/x9WWVKACWRsHk25PWgjNBMJhr0f/zpFfkpWqpPldkGwi8OsAjJQPVdObCY3RH6xqwC7m8zvXvy4X75AWK4QnOP8eWoD2Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741621371; c=relaxed/simple;
	bh=5ix0WNk8oGYYACPZn5VfAkE74ugkPnkBlhqHenKip7c=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=IrxsbdI8wBLl7iqTiVZ9rzK/yvPXXdwnkwGP//xBOX/6yT/ULK8DjKdO3706MB76xy32a0Bxvy0V0Yx+9JASKeoBb7U7FTSeuhI1P2v7IY0E036K2Fz5MuwAwv3rFF8/HzCeaDEEKsLHNmuV5i7QmknnCr8SboBy0Uat4U4UvfQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=m8DQLIK+; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=xrUDwzOO; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52AFfoBX027363;
	Mon, 10 Mar 2025 15:42:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=x9Y0ZaccuI17vDK1kEEhTt3Qm3OsWYbHToHXX77L6bU=; b=
	m8DQLIK+Hh/ucRQM4yryLDGU9iXquAWxqHzG4kYAl/0pRHuIT83vKVBVvqyXoRUR
	i0QVjfzACTfIR5NT4iSL50tU4tQ92nx3qCy/dWZb2GPydvAJOFa6JdjyBafqZFZW
	pRfoejclz8xgqA56YUNJ9lyzkUeRKYJ5xp7jat7PVATs6zv1M3cZjoQP/0W/UmHx
	scMn+2GwlKPEuZsQiegvPGgcMjjJDTLTHTNKHCxvC8VvNeT0yPkj/sf2b+UfZkJK
	p0mTB/9tq4mZl7wTKEhSXY10rZx3fzrK4c6V4Lq9odvwo4tOdNzggDP8zjeGEcgo
	zOtjX4E7jWN3+mAMbW89Jw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 458ctb2y4y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Mar 2025 15:42:07 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52AF7JrP019391;
	Mon, 10 Mar 2025 15:42:05 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2171.outbound.protection.outlook.com [104.47.59.171])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 458cbe9g3y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Mar 2025 15:42:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=h3EWh5GxrtN4fVMtwSmElpX7nz+H5HIu4ZeZksWedLk+HO50FzbA25LemBvt/fNjSx5Lx/HY/4lY++Y7YqwJ5DAmb0SMOsjpWOUgLrKBrMGI9SJa0RCyJn79vyIkGXr5DkE4srlzrdjY7BgVn6NnktPz3CzMwjnqhHsvKBE+WXD9bR6XcQDp198Sw0WnH2d59bIrV2MD8x/VLvQymyLPuZnOvqTOt4eOc8b0zDCwTRjUcJ1cbuHOb9AjLKDV1T8iufLdnYkQ7J/Jjf5DL4k1IzrHtA+N8wiH4A/CNDt3MOFr97L9D25chSVJ9ExCjdrHe8HvfNB25XDaDuTxm9oAYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x9Y0ZaccuI17vDK1kEEhTt3Qm3OsWYbHToHXX77L6bU=;
 b=x//eX335lqz2tDXEjcwzoHjrY0onJDIWd28PKTd4sbwC997xCLbIidLn2QShtn9BhxWwunR6hbfqOhBW/w1sNszAxs45omx4OI+QZFYQ2+QwXQ7eTt3fgEjFq0qGlWQoAwOZ7pzeF/pcnzIUZEHJfJgJehNB6ugW+2Q1coecwbU1vL2wop1K1CWslGL7mzFzFW1YzY9zx47g/4pmpUcBHgF5Jmkn0tNiruySOKD4jfh1UX7Mjpsi634135znOk/nTTBsxGQpqkc9hEbJb+abLcHHg8FpoOYPeBt6ndhld/yt9LR1P4RsQwKWKdR46t9zjpY1/rYBulVcWtVgfy2vQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x9Y0ZaccuI17vDK1kEEhTt3Qm3OsWYbHToHXX77L6bU=;
 b=xrUDwzOOrD3w/6GcZfFam0uYDJkQmgA32cg/Dj3Ye1nvJziPUtNYWH9eLRINdfLPJq6HOXCDxBlPyes8ZcSs8mxm4R2AS8vRb3J7WZYY3xMELPC6zpjsOtHDbfPl+NJwptiN/RKlJWu1o4u7Ywq6IvPySTnAA49LRh6otA/osMw=
Received: from BN6PR1001MB2068.namprd10.prod.outlook.com
 (2603:10b6:405:2b::35) by SJ0PR10MB4734.namprd10.prod.outlook.com
 (2603:10b6:a03:2d2::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.26; Mon, 10 Mar
 2025 15:42:03 +0000
Received: from BN6PR1001MB2068.namprd10.prod.outlook.com
 ([fe80::c9b4:7351:3a7d:942f]) by BN6PR1001MB2068.namprd10.prod.outlook.com
 ([fe80::c9b4:7351:3a7d:942f%4]) with mapi id 15.20.8511.026; Mon, 10 Mar 2025
 15:42:02 +0000
Message-ID: <df7acb81-bca4-472e-bece-cf5a36df6be3@oracle.com>
Date: Mon, 10 Mar 2025 08:41:59 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 07/10] target/i386/kvm: query kvm.enable_pmu parameter
To: Zhao Liu <zhao1.liu@intel.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, pbonzini@redhat.com,
        mtosatti@redhat.com, sandipan.das@amd.com, babu.moger@amd.com,
        likexu@tencent.com, like.xu.linux@gmail.com, zhenyuw@linux.intel.com,
        groug@kaod.org, khorenko@virtuozzo.com, alexander.ivanov@virtuozzo.com,
        den@virtuozzo.com, davydov-max@yandex-team.ru, xiaoyao.li@intel.com,
        dapeng1.mi@linux.intel.com, joe.jin@oracle.com
References: <20250302220112.17653-1-dongli.zhang@oracle.com>
 <20250302220112.17653-8-dongli.zhang@oracle.com> <Z86DXK0MAuC+mP/Y@intel.com>
Content-Language: en-US
From: Dongli Zhang <dongli.zhang@oracle.com>
In-Reply-To: <Z86DXK0MAuC+mP/Y@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BL1PR13CA0382.namprd13.prod.outlook.com
 (2603:10b6:208:2c0::27) To BN6PR1001MB2068.namprd10.prod.outlook.com
 (2603:10b6:405:2b::35)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN6PR1001MB2068:EE_|SJ0PR10MB4734:EE_
X-MS-Office365-Filtering-Correlation-Id: 42f226b9-4db6-43a1-8ac1-08dd5fea1a5d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?b3FCaktyRTI2VzRLbDJ5bTJIK1dLSGYwQ1phU0xyUHJaZWxXR0xTRWNZSWY0?=
 =?utf-8?B?bG0xaWlocWVlcjBOa043VWowUTJ1SjVNNFBPMjE3dzgzNnI3L1VsMElyQUtk?=
 =?utf-8?B?SFRadnp6bHJrZ2FNOGJJUnpYaEgzUWFPRDkvOExFa0lxOHZKU1F2eVlRODdU?=
 =?utf-8?B?RUZBNkFtS0tDeHEwZ1dNVWg3dnMwQWgzYzhCY3pRU1Ftd3FNcm9PZXRrWFM2?=
 =?utf-8?B?dzhlZ2lYRzJsdVRBODI0U0RiRkF2U3AzendYWXo1TnY2aWM4T2dNQ01iOGQ2?=
 =?utf-8?B?eWthMHVYL21IYkN0d09USjFTV29ObXh3WG15bDd2TU93MFYvcHBYNGxxSlN4?=
 =?utf-8?B?Q0hVSHJhSXZpZjFITlVHUFF4T1dJZkErMUhMVysxNzdvazVlOTQzbTY1UDNk?=
 =?utf-8?B?QlkySmNzUHkyUFlSZUNQeXlhUWY4RVlMVGJPL1Fzd0ZKb2lnVnpHVmZKZFI0?=
 =?utf-8?B?QXErUmw5SzRoNW1SNG9vSDJsU3hIRUZRQ3loenJDSXVUczdldzJoRWwzb0pF?=
 =?utf-8?B?U2ltVTJTNXZDTk1veWEvUlorQ0FUWWZ4QmlrYWtsSnNiK3ZGVUk0QkRlM0RG?=
 =?utf-8?B?Wi9mRmpvdVU3eTNTZ2tHTE9sa09VRUpTTkY2M3I0cGMvOXd3S082QlhBOHJD?=
 =?utf-8?B?cm0vdC9JUU8xTzFLdVhVM0VLZ3pXZEwvNFFHMGRSTi9ZYTlKNFBqSmpLSDVG?=
 =?utf-8?B?S1M1MVVJMnJJMis1MkdjUVU5WHZhMWpPRWV2Z1NxT09wT2tka2Q5My83bFBX?=
 =?utf-8?B?VnorTzQybDhHMTdVZ2Zma1Vrb1lMUDBWbmpTMWt0Z2dTSGJ0cGVYOXEzd2pt?=
 =?utf-8?B?SmpScWlNWnVZc2dlYWtKU2t2S0hmaXhwRzVUYWk2c3RzRDNZbUtsUFNEbVl3?=
 =?utf-8?B?NU4rMWxSVVBxQktnQWJ5K29JcDBiejVtL1hDSlE2cVhobjdBQ3JHOEhWdU42?=
 =?utf-8?B?YTZUazN3M1BhakNaZlEzTS9TV004NHZGRVVJZzUvK3luVU5BL2E0VUx2dGpH?=
 =?utf-8?B?ZGJVNUN0ZEwzdy9XZWNhRnVXdHppQm85aWNwY3VHRlpxU3dpRm81YUlrT1VF?=
 =?utf-8?B?cnlyK0h1UXhPWndrdWdtakhHVmxCVkJDZzIwcFNkVVpyQnJpWjluU21PNWFw?=
 =?utf-8?B?NzJ6bEhTTXloN0ZFdkFWKytwek1CUVVxbDk2NzJpWUU1bnZDM0dsR0pScGtn?=
 =?utf-8?B?NGJsaXVoVjlaR3pqVFY1ZjZOSDN0UFhyZWRtSENLQ3lNRThVYnRqbDZHVTlq?=
 =?utf-8?B?N3B1RURLaWpuQnNrUFdjYlpraElqcktMd29JdEVsY3Z2VDZVMll3N1cvaWR3?=
 =?utf-8?B?bGo1SFBNcVZQK1E2aDVRejE3R3RLQVFzdGxuaENTWXUwZ2x5eXNFV1kxazJz?=
 =?utf-8?B?T21HZjFtVEt0YkhNSHpNN2tXWFhUaU5qeUIzVlh5ZXpRdGVuNzdIUERoQWpH?=
 =?utf-8?B?TEp1dzJhMHo1WkpNOXpPQzJRSVJZM1dPcGwrTW9DZlpjUllnbXFVQ3J4QzVm?=
 =?utf-8?B?ZkcwV0hJcXpxek1TS09VSFZ2OVpWTThaMDkvQVJzdVUxT1FzSW43MjBoYU02?=
 =?utf-8?B?Ti8zT0FndXQ0R1QrSUxpeDluMmhoRkM5dUM4bUh2clFtVlJweHJSR0l5cEp3?=
 =?utf-8?B?QlB3VzlOTG5id3FzQzlnd1FqVWUxanZYWVpield2R2EvSXhBZ29qWDhud0Zw?=
 =?utf-8?B?aXJQSWNQTjNTcnQ2L3JEaHRpYkZUL3JiOEI3WEdJSitRL1dJcnpOZDRlM0hM?=
 =?utf-8?B?RWltNmUyZk1lMVdvU09XNlVXMUNxTVc5RHNFQklRYW55WVFheEhkRFBraUEv?=
 =?utf-8?B?T0hXTmMwVFU1a3FybWc5NGRqVXEycmNiRk51dWdkbnpVNjBkdnhNRkNQOU9a?=
 =?utf-8?Q?KjDAhpSuWwjCP?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR1001MB2068.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SnVVQXBIMEtRUWNESjRlTDVzd3dlVUxIMitGbGxRRGhNUFlDRWhoN01KSU9q?=
 =?utf-8?B?WUlTSlMzS3Frdlk1U3Z5eGt1YmRWTE1xQ0gzR050aWU2aTVLS0FRUDM1a2hw?=
 =?utf-8?B?QTl0OXNzWXBhZDdSaldsNU1GRFBKRC9tNUNyRnp0Y1pHRnNBNHUwZnV1S2R2?=
 =?utf-8?B?L1h3cjlTWjhvNFlBMVpoYTFmc3pUb21ENGF0eEplWTNDek9aY1dsT081R01X?=
 =?utf-8?B?Q3FVK05PZFltQitEMzVqNk8rZU9oSjZBY3hNZ0dSeEF3VmJTTStyS3B1S3BU?=
 =?utf-8?B?cnBIRlJoN1g0Rmh0Yzd2YU12ajdzWCtaaUpoKzduYjc0Y1dzWitIbUtjMmxU?=
 =?utf-8?B?dXhodE9FbWpHUTlFOVhITWc0NTFLZTJBVXUrWG96R1orL2k3MFFEUkZ0b1Na?=
 =?utf-8?B?UFVIQzNjRzI5T01yOGs5Zy9kTXo4Z1FnOXI0aDhpMitrdjhrYitQUXB0cGxP?=
 =?utf-8?B?T0FRR1lyalp1UTJQVVUvZE54WkxQWUp4dEFhSjJxQkFjc2IvQTdvcG1mSFFu?=
 =?utf-8?B?cWtwRTlqRW9uVHdrVFVva3ZjODJJQnJjRXZNaVp3ZFBrdDlnY21QenZHN2ZS?=
 =?utf-8?B?dWFjODJPWlk2RWZ6aFhjZmcyeTZyS3VITTFRNk02bklWbDJjYm11cTIzaEFZ?=
 =?utf-8?B?cmJNSWd5K0p6cWlMOG0ydjJKWWsxTngvYk9EMnlWSHlaNTRRNEVyVnQvckxB?=
 =?utf-8?B?VzMzVTJDTnFqTWI4OEE5NXFSY1lDVFFGWTIrN0cyTGNUbDF3NEtWQ0xZMDNO?=
 =?utf-8?B?bU1BU2N3NENZR0dURXJjQ01WVUtOZWxwMEhqeER4MGhLYStPNHBuSEZ5L0dN?=
 =?utf-8?B?d2xDaGpsSkEvM0lJdkRpeSs3YTZ1TWU4RUsrTGlkYTMvcUNJbjEvMVZxYXRl?=
 =?utf-8?B?NEUrQm9xSUpkZWkySWxndzM5SzBHRlY2dXBMSkRBeUpxVy9kRnUzMjZ2dURL?=
 =?utf-8?B?VEJDZ0xtN05IejhNUmx0M05PNmd2NFZFdzRVQkJOTmVCUTdsM1h0YjlETnVl?=
 =?utf-8?B?NGlGMEpHcW5Ea3lWREFOZVMzTFh6akVMNnJkdUFrZUNyQXlaaEN1WndMVDhP?=
 =?utf-8?B?M0VaRk15Q3RrMGFKclhvZFFSaWx3S0Vuc1pEWXFxb3gvdU01RWw0REZDVzRP?=
 =?utf-8?B?WEJ2aDhkWFBwUlY5Qks0U1V3Q2hISkZWM25UU1JjNzlWOFE5MmFseWtMZDdC?=
 =?utf-8?B?Wi9aU2RZYUpKSjkxV1FqZGJ3bWhDdzhhREZKYWpvN2syZzRXRkNDckZjS1Rn?=
 =?utf-8?B?bUlPdkprUjZjTGsyd3Rpd2FGZ2ZZa1h3elVDNTZvSnh1OGg2VERSYU1lU1Q4?=
 =?utf-8?B?TzdkdG92TVdJWjY2TUxxUjFsQnBDTkp1azlHc2xMcHR0V3BMTVg3UzFibjlx?=
 =?utf-8?B?TmF3dkR6R0ZmY292dWZ5TitQVE8rb0k0SExOVms1c0EzYnZLUDJxNE1jdUR6?=
 =?utf-8?B?dm5vdlFzOHBBV0FVeUNWNzZRN0pVME1HYjFEaGQ2cGQwSzRnV0RyT2R1TXNq?=
 =?utf-8?B?MUFhK05kTE5KSGNRRkV1ZG8zc0NvQ0ZKei9uRkVqQmRNd0tWTUxzdWhYYnB6?=
 =?utf-8?B?NW9MWHJHUmFnR3J2QjV4Vnhvb0FpZVFzTy9NSm5wYjVQMjE0M1BBMXhJc0hV?=
 =?utf-8?B?V0VGUVN0bW92bCtYZEpUNmp4d1hOejgreUFNK3lZWGpuSnNPSWorTVgyS3Fq?=
 =?utf-8?B?akJWd3BUdWhlbFIxMjk4ZFF0Uk56a3d5c1pmYmdLNmE3OHFnT3BVa0w0am9G?=
 =?utf-8?B?OGU0ZzM0K1pKZ2N4bnQvUXd0OTZKcjRiNjlkMGFtZGt0dVdtUGI1MW9Yd1k3?=
 =?utf-8?B?aTJ2ZG14Q3psYnBQaVVxS3E5VGlDRndrRFQ3MUcwRFVFMFdUbWh4VkgrZDJH?=
 =?utf-8?B?Z2ZKTDdKTE45TDd2OXZCdzRBUFFHWnp4bEJCNzkyWDBreStUenVrVWFYcThG?=
 =?utf-8?B?Um1ad1VpQ3hBcnplVlpaWitRVGt5bG9BUXBHRXNrQitlLzJBSnJkSExhNWtL?=
 =?utf-8?B?Y0M0bExSVnZ1VlIzUVMvL25ZREE5RUw4OXBqbGFUZS92TXlzQllGeU9WQ3kw?=
 =?utf-8?B?S3lDVEp4b2JPcWhjajZRVlNGY2l0N2RtV0U0WFV5eURwTlh2bWJmTWt5ZG1J?=
 =?utf-8?B?QkFuZjVjd2Q4MHgwSWFZRkJBbTREVlBVeEV4aEVHQmFvL21MNGw1OXQyQ1BX?=
 =?utf-8?B?UGc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	WB5EivDMrYS5p1gb/TddscfqIWeBrSeVYqZOp18LOSxVO6nmUUqWLy/6pPOhw2/JgsWeMADZM8bOyr0VNiIKHcbSJfCytXOgVy2aBC9hKyqzAv4U6A2QhPfHuuMij3IY3+u9wwWA0KqJnP7HDQv0eKJmAmj3RohWBi8zScJZrxOr6kmaHEiiKH3fnY+I2W1dM6YsIA+QZvBBYLQ5LcgWQ/GFkOFEpGov07whuM0/K6x8/M1EGPSLOSUZvTeyGdZJwBbKMUkcHEt8y4J9roDxJ4n9weRTxtcI0Jv7zVrTRFR5ixV7amNdzmxTG7dlxVZbZ2iXmP5EHY/LCM+LVTFZr7sm3NRMrBXfk+VA6S4EgGbZUQouygsiLSFB3hchbUqlYjNcgb87e0dM9+cbas9nOuCjpMQdvPNoT6HvmxCpHcSBD4b1rjSbCHlCTMKcQIQjk2lYILhPQzxL4t91taFsaMjfVQm5ntMlEb9Wjq/YhFSmj12WuZ+WWxfvJXfjZ8Z8RrEV6CpCIWhbWzGc4CXa5Qj52v/7qoHRDRbrZAGCTGNlTTVqqnDvWxtJwZlyLYQ1jAhLiepPwOQ8Jnng9Ws1nO1VLMdaafoZR//hzaqI3Hs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 42f226b9-4db6-43a1-8ac1-08dd5fea1a5d
X-MS-Exchange-CrossTenant-AuthSource: BN6PR1001MB2068.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2025 15:42:02.7845
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qUHh2uXAv44Kl+TMoIVj46R6iZWxI2C1gbcaznDyxCgEjf12gyoUcxqcx1GKK8IasrUWCpxnbdMkghtOpABSSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4734
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-10_06,2025-03-07_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 suspectscore=0
 mlxscore=0 mlxlogscore=999 malwarescore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502100000
 definitions=main-2503100122
X-Proofpoint-GUID: k7ACafmQgv5LfL2di1ofsv72PGhEobcn
X-Proofpoint-ORIG-GUID: k7ACafmQgv5LfL2di1ofsv72PGhEobcn

Hi Zhao,

On 3/9/25 11:14 PM, Zhao Liu wrote:
> On Sun, Mar 02, 2025 at 02:00:15PM -0800, Dongli Zhang wrote:
>> Date: Sun,  2 Mar 2025 14:00:15 -0800
>> From: Dongli Zhang <dongli.zhang@oracle.com>
>> Subject: [PATCH v2 07/10] target/i386/kvm: query kvm.enable_pmu parameter
>> X-Mailer: git-send-email 2.43.5
>>
>> There is no way to distinguish between the following scenarios:
>>
>> (1) KVM_CAP_PMU_CAPABILITY is not supported.
>> (2) KVM_CAP_PMU_CAPABILITY is supported but disabled via the module
>> parameter kvm.enable_pmu=N.
>>
>> In scenario (1), there is no way to fully disable AMD PMU virtualization.
>>
>> In scenario (2), PMU virtualization is completely disabled by the KVM
>> module.
> 
> KVM_CAP_PMU_CAPABILITY is introduced since ba7bb663f554 ("KVM: x86:
> Provide per VM capability for disabling PMU virtualization") in v5.18,
> so I understand you want to handle the old linux before v5.18.
> 
> Let's sort out all the cases:
> 
> 1) v5.18 and after, if the parameter "enable_pmu" is Y and then
>    KVM_CAP_PMU_CAPABILITY exists, so everything could work.
> 
> 2) v5.18 and after, "enable_pmu" is N and then KVM_CAP_PMU_CAPABILITY
>    doesn't exist, QEMU needs to helpe user disable vPMU.
> 
> 3) v5.17 (since "enable_pmu" is introduced in v5.17 since 4732f2444acd
>    ("KVM: x86: Making the module parameter of vPMU more common")),
>    there's no KVM_CAP_PMU_CAPABILITY and vPMU enablement depends on
>    "enable_pmu". QEMU's enable_pmu option should depend on kvm
>    parameter.
> 
> 4) before v5.17, there's no "enable_pmu" so that there's no way to
>    fully disable AMD PMU.
> 
> IIUC, you want to distinguish 2) and 3). And your current codes won't
> break old kernels on 4) because "kvm_pmu_disabled" defaults false.
> Therefore, overall the idea of this patch is good for me.
> 
> But IMO, the logics all above can be compatible by:
> 
>  * First check the KVM_CAP_PMU_CAPABILITY,
>  * Only if KVM_CAP_PMU_CAPABILITY doesn't exist, then check the kvm parameter
> 
> ...instead of always checking the parameter as you are currently doing.
> 
> What about this change? :-)
> 
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index 4902694129f9..9a6044e41a82 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -2055,13 +2055,34 @@ int kvm_arch_pre_create_vcpu(CPUState *cpu, Error **errp)
>           * behavior on Intel platform because current "pmu" property works
>           * as expected.
>           */
> -        if (has_pmu_cap && !X86_CPU(cpu)->enable_pmu) {
> -            ret = kvm_vm_enable_cap(kvm_state, KVM_CAP_PMU_CAPABILITY, 0,
> -                                    KVM_PMU_CAP_DISABLE);
> -            if (ret < 0) {
> -                error_setg_errno(errp, -ret,
> -                                 "Failed to set KVM_PMU_CAP_DISABLE");
> -                return ret;
> +        if (has_pmu_cap) {
> +            if (!X86_CPU(cpu)->enable_pmu) {
> +                ret = kvm_vm_enable_cap(kvm_state, KVM_CAP_PMU_CAPABILITY, 0,
> +                                        KVM_PMU_CAP_DISABLE);
> +                if (ret < 0) {
> +                    error_setg_errno(errp, -ret,
> +                                     "Failed to set KVM_PMU_CAP_DISABLE");
> +                    return ret;
> +                }
> +            }
> +        } else {
> +            /*
> +             * KVM_CAP_PMU_CAPABILITY is introduced in Linux v5.18. For old linux,
> +             * we have to check enable_pmu parameter for vPMU support.
> +             */
> +            g_autofree char *kvm_enable_pmu;
> +
> +            /*
> +             * The kvm.enable_pmu's permission is 0444. It does not change until a
> +             * reload of the KVM module.
> +             */
> +            if (g_file_get_contents("/sys/module/kvm/parameters/enable_pmu",
> +                &kvm_enable_pmu, NULL, NULL)) {
> +                if (*kvm_enable_pmu == 'N' && !X86_CPU(cpu)->enable_pmu) {
> +                    error_setg(errp, "Failed to enable PMU since "
> +                               "KVM's enable_pmu parameter is disabled");
> +                    return -1;
> +                }
>              }
>          }
>      }
> 
> ---
> 
> This example not only eliminates the static variable “kvm_pmu_disabled”,
> but also explicitly informs the user that vPMU is not available and
> QEMU's "pmu" option doesn't work.
> 
> As a comparison, your patch 8 actually "silently" disables PMU (in the
> kvm_init_pmu_info()) and user can only find it in Guest through PMU
> exceptions.
> 

Thank you very much!

I will change the code following your suggestion.

Dongli Zhang


