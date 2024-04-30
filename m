Return-Path: <kvm+bounces-16242-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A84E8B7CC0
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2024 18:23:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9733EB2304B
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2024 16:23:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DBDF17994F;
	Tue, 30 Apr 2024 16:23:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mgQVG5VZ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="wD7w3Gnp"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E570176FB2;
	Tue, 30 Apr 2024 16:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714494201; cv=fail; b=DzwqYp6z/bynxP1aKCK0dblmreV0663PwdOSz8sPGlmmr70Uz/+Z6slQyv2ndk+/VZSjmwJ004fhApdSi4HaeFnpJzidGQDPtSfuH7sUPQX+D1XXyEt7Dk9hOFz/565i+qda+PB71F2ZhM83NtDbPPsGmHYA/ALniETO87t0NtI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714494201; c=relaxed/simple;
	bh=HMBU9g8ngWZJlgBAVMj8Z7dmUBQD39DNQ95PSqusIEA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=kHMZNWQlqSVWd0tXOadGBKxBV+kjavgy8qq+OB0zbHVr0Kd8FgSjppXQAbe0Xh8lr3GsKVAT5mEgenXUgftpXV8ASVdXlQPDcOmaOG7HK1npyN+mpksJTdRmSo3XRmm7eESOAdovl7rAWfPommseanJZO8ss13mQ2hEvhbJXjKU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=mgQVG5VZ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=wD7w3Gnp; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43UCRNH7018326;
	Tue, 30 Apr 2024 16:23:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=W+ueri5/LEGbnpbK7fDORcNPVHnTBEDSqKLTo8t34HY=;
 b=mgQVG5VZRfM2RfZUVufHfzTpus/i8u3Bo3jfbHU1lOO+3pg+/FOVyeZuLJUvuFWGyZ8S
 UJI8FiHuvmMRFJPwNa98Ni/xESlPNBqqe2yGJBkOUPtKttcYtuBkB/fU3udRhHtHl8ur
 L2Mnx/oCcyE5lomkqwx1PTpr9iYBN7RQ/4AN0bKM5b3pJE4iY+MxC995o9xzdMimf0WU
 6ff6RnxeOgh78bFuxB2dqIcw04kFKfs9QNeRRu7fHg2oax6pBH9uN8010RuvpIOsgmvx
 vizxNp1wVM/OX+hH2qj7Ybs/oYtOkLIjnLyz1gp1yRgygIfav7IR9I+np87pxcto6QOZ eQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xrr9cnmj2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 Apr 2024 16:23:10 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 43UG1KmP008453;
	Tue, 30 Apr 2024 16:23:09 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3xrqt86et6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 Apr 2024 16:23:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D9IoezH/wqJYd2+Zy8ViSiQ6CkJh2uwLIuUKFGNDZVXJcsGaxjsEKF6raKuAriO2Fki5R3v7QlIUM0GgB8z1PhV1VOsxqFN2bP76+01wB0E+Sc+9Ogs24XYyviauU34CnhpPde6cYkBQ7IJfhMxAXKkBKnF6a3tw011C77O5OxHyFAmnSpvamc0VoysBdeCFKWfRNnIhikcZ4bu34A4tgbTxkzbh8p4jzGcGx0l9or4lLqmkVPzUqiopeZIyNhsnofI7tg6ERP1KMxzz7eWexg0TzJZZGxKtMRMuBi0empS0euQJYbG6XpKUwvsr46VaPX5ANC5ItGYra3HW1Kh4Wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W+ueri5/LEGbnpbK7fDORcNPVHnTBEDSqKLTo8t34HY=;
 b=IeYpjlQW4qWTZvv4r6u9Ot+GZ3+G/X5nVFEjZ4Z5h7xLb/R5so+PKkpQhglzNeww9Z5JPFz4anspB+nUaCl46ZRAYJ77b05pr7AVTDx3Vj4esiVJh5F54B4XZyyhLj/3/51LzNZDCawCF0W1/gqoOeWI7yB2Tabwh6yL1uilbFRN8J26lOPjuzCXiHngvW7C8VfAMh4SdyNxmL1zfx8Od6foZ1QruBcTVxls6xmmc51t9ZehAmMUJtvXLCZDuB2ZDEzwYgtyCfRhfTndqpV4yJLW+nKC7aR/RW7+wSFfr7ZvB0UTsXgR+AMxKEodSX22owgXBa6O3ZClQOfrq836uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W+ueri5/LEGbnpbK7fDORcNPVHnTBEDSqKLTo8t34HY=;
 b=wD7w3GnpkXGaTJMBL5EpjzZDh8rW5FKl+Hh4+3ApN3yj32ecYUL3C8LRFhXl6fi2l0GSaK3W6Y9bj/DXhZAoPIzAn4i+E3hrRsxKquv+8kwvas5EslotzqhH/HuD1/CUzBAG910VzEwH6AgGtbjQH73bTfOuyeDmJ+tGdWI9BTY=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by PH7PR10MB6602.namprd10.prod.outlook.com (2603:10b6:510:206::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.25; Tue, 30 Apr
 2024 16:23:07 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0%7]) with mapi id 15.20.7519.031; Tue, 30 Apr 2024
 16:23:07 +0000
Message-ID: <b959b82a-510f-45c0-9e06-acf526c2f4a1@oracle.com>
Date: Tue, 30 Apr 2024 11:23:04 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH next] vhost_task: after freeing vhost_task it should not
 be accessed in vhost_task_fn
To: Edward Adam Davis <eadavis@qq.com>,
        syzbot+98edc2df894917b3431f@syzkaller.appspotmail.com
Cc: jasowang@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mst@redhat.com, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, virtualization@lists.linux.dev
References: <000000000000a9613006174c1c4c@google.com>
 <tencent_4271296B83A6E4413776576946DAB374E305@qq.com>
Content-Language: en-US
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <tencent_4271296B83A6E4413776576946DAB374E305@qq.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR19CA0029.namprd19.prod.outlook.com
 (2603:10b6:610:4d::39) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|PH7PR10MB6602:EE_
X-MS-Office365-Filtering-Correlation-Id: 6933d01c-03f3-42fc-ff0a-08dc6931d195
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|366007|1800799015;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?dlFualRKRVpQajJNbDg2VTE2SG5uTlRuVzVrbldVRHdNUWVzbkMzZlQvRE5D?=
 =?utf-8?B?NDdoNnVGNFZMN25MSStZdlNZMEN4TGgvbUJjUWc2dnAvUVdPWDdCa3VYWngz?=
 =?utf-8?B?SXdTOWlVYktETTJyWGZFLzNWQm0zb25sRmNGcUFJNGxzcnJtL3FyOCtMOTBE?=
 =?utf-8?B?NElUalVzZURtaHF3TDN5Ny9GejhwTGUxRGJYVWxwMllZYk85Y3Q4UktTU01w?=
 =?utf-8?B?L1RkS2J2cDBqTjhPVC92ajZQZFRzdi80QlpnOWtDeFlaK3RoZzNIUnVFYUJ2?=
 =?utf-8?B?cU5KZ1ZJUm9YY3pWNVpXOXZrSVdORkJmcmJweUU2TUJtMWNlaDRZKzV4VG9R?=
 =?utf-8?B?NE55VlhRdGJEYTVWaWF1Wi9DdHFWaWlPRXVNTlk1VWp3WEZkWTFVQ0lRVzhq?=
 =?utf-8?B?d2wySnJnd21oWlVHZVg3aTlrT1RvZGd6NkVvMGdWeUVQOStTOUtOMlNBZVpT?=
 =?utf-8?B?S3UzWE93Z29hUFZ5bzdHNURTS3ZkdXI1TEZUL1JTRWNxdWlRdFJDWHNDTUE0?=
 =?utf-8?B?dVY4SXo4V2ZWMldpc01LUUFoY0JnQi9tK041LzV2QS9KOGdmSXBoNXdEN1Zj?=
 =?utf-8?B?K0podGZwSGFqeTdRSEEwSGp5dFE1b0xlWE1HQ2VDZGt1bVgzem1PYm5Ma0RN?=
 =?utf-8?B?enRqc0s1Z3ljc2tmYXpaQ1o3V0dhTnBpcUJBSjFSSy9aMDNCUVgrNjB4bmRM?=
 =?utf-8?B?SXZsN0pRYVJTUzJndm5tY2VodGE3VE5tSGdPbzlFbTdTZGZPVlpETUlJT2xs?=
 =?utf-8?B?WHd0cTBuRHRJeXZ0UzF1V0NNZTFYbHlYSzB6Z1RqR1g5RUdTdVBjc3pYMjlF?=
 =?utf-8?B?SkR5OHNjdUVEZFJYMmNHeXNyazEwaWlhVDREREVIbGs2eEd6TXFVTmFqSmls?=
 =?utf-8?B?SytVR09TT3pIQ1o3N2RXSUVCc0RpVzJFTjFBUDdoWTRRU0FGZjU4Z1Vnc1JL?=
 =?utf-8?B?Zmx6eUwyU3hwNUgzR1FjZ2cwVVlwdlZJM3dJM2lkU3RKK3JkZHVqNVVrc1ZT?=
 =?utf-8?B?aG5RbHFCaXF4OGxYU0g0TFkxVGlQQ1k1T1hRTWkvSmppMXE5UVp6YU1hNzNs?=
 =?utf-8?B?L1RJWFF2SDk4TEorWGxMWDJwQXliL2E5YnptWkdUVzFhSzU0VXUvMDZHenNl?=
 =?utf-8?B?Z2xQbGY0cEg4ZEYwTGlqZXRsM3d3RGwrdE9sS2ZoQzdoZ0N1WmJZZEVPZkR1?=
 =?utf-8?B?TVNxMFIxdldjQ3JBU0x3ZUFpSG5ZaTBPMlRzbjkrbElia0NEbW1sTzVkbWRV?=
 =?utf-8?B?S1RxS0xMVXYrRGVTSTRVYmM3aFhLZk95UWRWVEhaSmVaWlJBU2dVejlpK0F5?=
 =?utf-8?B?ZTEwNmRIK3FNallOSXlIKy9NdmpDN0hLdmh0NzRJVUtmSzZWTHA3c3VVNTFC?=
 =?utf-8?B?bTZTbTJ0YnNWL2xQWDhudlJhZzBvVVFWUlpDeWU0MUhmRTJTN2Q4R2F3T1dn?=
 =?utf-8?B?bzBVdDhQOE5QT2FjNG5WTkNQb2FZUGdmeE8xcTRlYXV2L1c2RktoYzdNZmxN?=
 =?utf-8?B?MEpoOSsyV0xIbWY0TUJ4UEwxVmtBTjk1MTVuZDBlc0pwUTRIZ3BJNzNNRjVB?=
 =?utf-8?B?OXZVcFhvYzg5aTJpV0hHTjRhbURSY3lWRGw1OUVnblc1NU42SHN0UkJXTHNZ?=
 =?utf-8?B?RTFWTUhpdzZ2cVFodlZaNklkVWdIZmFzQTZyOUw5Ynh3L3BKTW8xaXBUWFZm?=
 =?utf-8?B?YkhJN1ZPT0Q3ZFZ1dFlRNk01TXdGRVIwd1lLZW9BYzFIYTZpMHlDQ2hRPT0=?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?ZXB3dUxxUS9lcDNndzlnNjI2akN1Y081V2lKQ1BBYWJvQVRzWG9WYmxGU3FS?=
 =?utf-8?B?SGp0WXVvcm9UZUR5N1ViZlZxMkRQUzNENk9QVm9ZdW5WSnNVbTRwNFA5cm9Y?=
 =?utf-8?B?RlU2ZzdlZ1M2QUxBSnNHMEowcks5NmUwQ0gxWWF3dkZNaUtGNTgrWlgzdmlx?=
 =?utf-8?B?NkpiSzBidm5KM2ZjQzBBMVZuR3lzWjV2RTFwL2FoZHM4YURmQjZxR0ZMd3lq?=
 =?utf-8?B?aXp6d05jV0tLUEh2cmoxQkJBUzhXMEVNTFJ2QkFMZDkyZm5xSUhtd2FtTk0w?=
 =?utf-8?B?emZ6UndwR21nY3ZrUXpvWkZHSVgrSHFDNVJBSDZLemxnZ2JWSnBISmdkWFg3?=
 =?utf-8?B?Z1p4VFBHOUFQRHd6d1hSSjc1cjhNUjN5NkE4OTQrcjRQRlZTRDZSVFYvUWF4?=
 =?utf-8?B?MEVHQnlqZE9nVExoSm9teUF2eUlaQmJFelZvTlVGWjRSdWtuRmtwQ0VUbWtl?=
 =?utf-8?B?YnAzclRwR1UwRHE5S3BOY2ZMUVorb2tUeHlQQ3pkSTZNZDNVNkZlbXk1ZEI3?=
 =?utf-8?B?QUdlaFRoSk4xU0Z0cEhGd0JsbTdHWGlUeXd6ZERTaGJ5NHptMVowTDR0emk0?=
 =?utf-8?B?amJUSmR1T2E4ZUxZSkV6b3lwRGpxYlRTalA2OWhUQjJVcWlnL0JhNnRub29B?=
 =?utf-8?B?THRJYWF5VHlRaUxHa3JEMnJCR3N6L2ZkN0Zsci9TdTJGNS9YOVNuSjQwY3BV?=
 =?utf-8?B?bjl3QStlT2ZTTWMxUU5mcFhhYTZrVGorNjRPWUhpVkRCT0hXS2wrQ1VnZjJl?=
 =?utf-8?B?azRyZWhjRmUwRHF4WDY4Rll3ZTJ6eXJYbnFGdzFVbUxFR21vQk1LMWNBanEw?=
 =?utf-8?B?WkRrL08zRDlZOXFxaU5HK1JFNUxab1FRcTZPMThvMS9vMCtpTE5rcnlzZlZm?=
 =?utf-8?B?dVJ1NGJ3L2ZiZzNsMUttc2l3cnBpOHhqK1hwK0F4cC9lNDdpRHZWRFpzS2lz?=
 =?utf-8?B?ZEtyY3NReVNZVVpya1NRT00rQUVOYUF4d2tKeEZMVlNrV3JVUkUzb0JyQ1JF?=
 =?utf-8?B?andHK1hDcGlnZUZjKzBQc3NEcVpvN2J1NkNUR3BxZE5aNUNzMWw2RVUyR1NY?=
 =?utf-8?B?eldTUVJXYXdSeVpGeGJ0Z2ZjbXBvZElVYTN6U2VhYVVhVlI0QS9NdVhHOWpj?=
 =?utf-8?B?ZXB0NlYwNGEwUEV6WGZUNHRScGl4TzRIdVpPZldzNGdSYjh4VmNaOWM0OFVa?=
 =?utf-8?B?YUNua0lVazZkNzBSZERHZThBcm1rQ2RIbU5EaDVrMUtVSitTTzJ6NkJJV3E3?=
 =?utf-8?B?TEdkblFCSmVtRDBDOWxVVHNOWXhPV0ZOR2ErZXZ2RTVOdU1MY0ZjUkFtRWxX?=
 =?utf-8?B?cU1lUUtXQ0ptZWhtQTdHQzBGYjdWUzJ3akx6cm9FRUNqNjBMU3VPSm00bnpy?=
 =?utf-8?B?Z0R6NG9MdktHckFvQjI0aHo4WlJ2K3ZDb1ltRmtxVkIzd2dLdjFTUzM2K3o1?=
 =?utf-8?B?RkNHalhxY21HajVvNThiS2dLN2thRzgvQ3lUbXRKS1F1UGdOOFhEbnRhNkJi?=
 =?utf-8?B?clB5UzZ5SGRRNXdscTJuUDlPT1JCOEJlZDBhUnIxY3hPYkUzVWR1ZFA4RWR0?=
 =?utf-8?B?d3dMY3Fwc0pUUmt1T0tRdXFmeVZnOWZwNWUxcWQ0cnkxeWFUVXJDTkNRSDRK?=
 =?utf-8?B?bG9aWGwwdklaWDNKdndHSG1IZm1FZlNXWjJZMWo3MGNKVXZpbyt4Zkk3by9V?=
 =?utf-8?B?U055MVJFQVZKTUlKODh1Q01yOG5tQm9jeUlCdll0Rk85clRTQXZjK3FnaHhs?=
 =?utf-8?B?Sm1sZkd1RlhrOWJuK2xROThlQllVRlZWRjdIWlJyTUJzVWl1KzBtUEI1eksr?=
 =?utf-8?B?bDFyYnp0VDNOZDZxeXIzT2gvUHRuMjdvMWF4U1dIcGVOTnU4cjY3TkY5eW5i?=
 =?utf-8?B?Zy9Sbnk0ZzJTMTB3dFFFL3pXZ1VwdGhPT0dGY0Z5NHpnZXA0UVNKQzcrQ3d4?=
 =?utf-8?B?SlMyOERJWm9XT3pmK2pmd0ZvYi9JV1o0LytRWk5mVHp3ekc3YllUL1AxWWY1?=
 =?utf-8?B?Y2hVRko0MkFWU0krVW5HbWgyZEtGaXVtTVk3WGRPcmFvclpqUWt4cnB1Z01Z?=
 =?utf-8?B?RTM1R20yWThBaGZwYkh6ajBmQWlOL2paVmJEb25lMlZtS3laM3VjZFdsWm5S?=
 =?utf-8?B?cTRZYnZlenkrUGRtQ2o5QVdkYmV0eVBERTZCcHlvaVBib3MwUHVyblZHNjhQ?=
 =?utf-8?B?b1E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	Eb0hKEEYMUsr+0Sbg+WKmS2RrdNjPWbp4oMmgMhRRSA46Sa/iIesooN6pY8K2J9EGcKbh/ZRasmhCJVBk0vXaX1X3/PxfZ4jZq8XP+PElc+YZ9/2UR2dHbsCFVt4wDXm+ofFp8fYyEMys213k1E/r1USMe05o8J1fb2fa3tMeqlqERIF+vXOLSe1V/CGZZyhUxL9zbaYmAuHWoyqB37qHwhT65v3HK5uCk7aJiK7xfKJtzY2GahJwnIaflnR7DHySnDNggqJlBWak0LWBjI6u5fHVUTbhmAqHjuwdMTfXoO04HJxBW5nU02RLjkIPNy1SNE2iMwleBAM4VL1KhekaRaQyGnZDan4tMDYjEx9vuiemVyQF0AWybKyNlP+jS7W5f5zug0v+FeF8FcYJl74rCxf/m6LuFL2zWe3nvy7K59AJKn6I6b+GDwQZ81hhGcOdPjZoxnLKZAIwAt8T6VHSlrkKE0MbekEXhymAeBjeTIfvHWlAXksrhKmtkM/qZ66pysSxRv/TlaU5iXfw7UMe6pDheJw7vKCcS3F09/dW66mWkM4x231niA6/89NLiFM020Ty0EpaxxivBka59I6XOiZsnzHzKeMAWmGxlXLD2U=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6933d01c-03f3-42fc-ff0a-08dc6931d195
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2024 16:23:07.1998
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fnXwGy7c+9qp0AbgTq+RKRaod4UDF1c19q78AKdr2Ww0Y5brDzI7btC5NbRJBBrQ3IgyEry5DxUsg9Iu6pUXspcaaOO2c/vZ/b9tCO3MR3Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6602
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-04-30_09,2024-04-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 mlxlogscore=966 bulkscore=0 suspectscore=0 adultscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404300116
X-Proofpoint-GUID: 2gaTvJm7JAc2feNsQVmz12u2RfIkURaH
X-Proofpoint-ORIG-GUID: 2gaTvJm7JAc2feNsQVmz12u2RfIkURaH

On 4/30/24 8:05 AM, Edward Adam Davis wrote:
>  static int vhost_task_fn(void *data)
>  {
>  	struct vhost_task *vtsk = data;
> @@ -51,7 +51,7 @@ static int vhost_task_fn(void *data)
>  			schedule();
>  	}
>  
> -	mutex_lock(&vtsk->exit_mutex);
> +	mutex_lock(&exit_mutex);
>  	/*
>  	 * If a vhost_task_stop and SIGKILL race, we can ignore the SIGKILL.
>  	 * When the vhost layer has called vhost_task_stop it's already stopped
> @@ -62,7 +62,7 @@ static int vhost_task_fn(void *data)
>  		vtsk->handle_sigkill(vtsk->data);
>  	}
>  	complete(&vtsk->exited);
> -	mutex_unlock(&vtsk->exit_mutex);
> +	mutex_unlock(&exit_mutex);
>  

Edward, thanks for the patch. I think though I just needed to swap the
order of the calls above.

Instead of:

complete(&vtsk->exited);
mutex_unlock(&vtsk->exit_mutex);

it should have been:

mutex_unlock(&vtsk->exit_mutex);
complete(&vtsk->exited);

If my analysis is correct, then Michael do you want me to resubmit a
patch on top of your vhost branch or resubmit the entire patchset?


