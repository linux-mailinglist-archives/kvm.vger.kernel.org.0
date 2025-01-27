Return-Path: <kvm+bounces-36691-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DD65DA1FF83
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 22:16:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 36CC73A49A1
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 21:16:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 766D01A8407;
	Mon, 27 Jan 2025 21:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Yh36Q3Cn";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="tpDfPvs/"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA995748D
	for <kvm@vger.kernel.org>; Mon, 27 Jan 2025 21:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738012587; cv=fail; b=HRSIjg+2gsJ8mEM8yMhSP9WL0HdqUiKsVf/kOsF7XnLokE37S0fH9DoliyEG76lknhmxcMai/rUfvqC8mIFqsWk063gTaJxAe5ApNFxWbUoIXeGdvIPicSbYumF1rG5QBwKMjDAzfhY0o/XljDsmDQB4pZSwccYZPM1+HtboJ7w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738012587; c=relaxed/simple;
	bh=z0fa229HO6FJ+6LFxFh916GgQUPY9tgpIl+2IqYzl14=;
	h=Message-ID:Date:From:Subject:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=MZQgVdxVB9q439fEL8APXYsAzk9mmzHOLqpzu5c8xy1MD4q0TdpGEZsw4CA+uXqn/C5SHlf3ph62c81fLeBvv0r1ZF4tufTcVD1yz+84duIeMbdz40Guw15FWuE1QjirxnuTXUITG+OICHFHpMTtQz/Z0aXvQLuOxtJ6ncj1ES8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Yh36Q3Cn; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=tpDfPvs/; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50RKBmMW018605;
	Mon, 27 Jan 2025 21:16:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=nBP+NWJxHocn83ipmwGiIjtaQixBjkfMQaEHhuoLHdc=; b=
	Yh36Q3CnK6iGKfx5G64mtjddabz8TnEZYDrdx1H3bwxNZPyPi+1Cb7qCet/iNL7c
	RQyTHHmcVcXENXSDY/Q5e+mLEITVh4e73GCVE7JMCGY9wkgJeRuYTYL/n6yBrbyo
	D8zCQ+5ua3SiHQGPNcKoNwpcE83/kNjOl1XHz9DCLpJ06/sCqEf7oSkKhEBmlCXy
	VGtkdSECPHWWTyayrFzPeHIZkBuZodh0R2NzObWg4IeIegLvGA95IFDPyaF0qpsr
	WLkOya/ZZ4u9bV2PB4B2Hud6JAVSqva64axPEQJZcDzHxPotZddtynlk/1qrfSoy
	EMYESCom5JGSOx0HfwQxwQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44egknr5su-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Jan 2025 21:16:11 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 50RKvlNf013788;
	Mon, 27 Jan 2025 21:16:10 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2175.outbound.protection.outlook.com [104.47.57.175])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44cpd7923x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Jan 2025 21:16:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QETJ2O+NVVW9SQXxPqtbcSTcZeAbOWTmQNlxQ+6851gSWQvID2/NQEhEmsYzAML8OzYoblude6WwpJpBzrp+hCMrIhWLAqUXeUqmWG8La3IN1tGaWjPpZqeN3uW/Sc6juf5qRU8v0ANuHniCEnz2G5a0Xo6Ic+R2smHjJvbrsZg27SSvI9C8gIuYEfeAYX7fqiZxAFv9ywI0MuV0RIf7+wsBBI7RLzS4+jnN/M9JiJ5isrkGxBWEjrmqIPR0hVdwtT2zd/fG/AzQMKHneRtLljE3CbKs8KUS6e39WaAZRI4paqY6xmHvAMQUuqL/BbM9gBXfGr+BbL0Jz1XLRpfMJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nBP+NWJxHocn83ipmwGiIjtaQixBjkfMQaEHhuoLHdc=;
 b=exgeAoIL6C0jfFz+VcqUwyq7PKruNtz0eNS4O6NQvsskToh/3TrJRW2Uo5an/vH0/en7LMB5fNWOrd+MPLz0Hte+gasCKbxoRLjcBTbDkTlmw3lHjx1Ma7MldbO9tE9vhKcTOYX+Xp5ojrMaD6A+a1Eb87tPPfECgqlGx4kXDZ5dDMuFw6EKly0qTiPl6CTc+DbK9cMNjI756PNMGedJmiN6v67o2lPywoD50lcwLpW+mOXS0cWkgNMgkz+nWS0YyC3qIhhaUoiqVlWHUQs5oemXIlhh2aH0oP80NaT30b+1Wy77sQRp9ypx8XY9CqE9pYEYjrarc6FaLOgqrEXPEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nBP+NWJxHocn83ipmwGiIjtaQixBjkfMQaEHhuoLHdc=;
 b=tpDfPvs/C+IgftJSD5bwGjqK+oxIgRTsU52xjHVAm8IB9hD3WgP3/R/r3S+Hee0E/QQ3iW2TCBrGQemj9wP2H1AvSrMI/uuAtXLnepX0m5c9UjUUx7KTEWQKPGM803uY+dchgizQuSh3eAY+I2FgiCpIScmWVcWt1RugeGPI0Ww=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by LV3PR10MB7938.namprd10.prod.outlook.com (2603:10b6:408:217::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8377.22; Mon, 27 Jan
 2025 21:16:07 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%6]) with mapi id 15.20.8377.021; Mon, 27 Jan 2025
 21:16:06 +0000
Message-ID: <26617c43-1f6c-4870-b99f-50525acd9134@oracle.com>
Date: Mon, 27 Jan 2025 22:16:02 +0100
User-Agent: Mozilla Thunderbird
From: William Roche <william.roche@oracle.com>
Subject: Re: [PATCH v5 1/6] system/physmem: handle hugetlb correctly in
 qemu_ram_remap()
To: David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc: peterx@redhat.com, pbonzini@redhat.com, richard.henderson@linaro.org,
        philmd@linaro.org, peter.maydell@linaro.org, mtosatti@redhat.com,
        imammedo@redhat.com, eduardo@habkost.net, marcel.apfelbaum@gmail.com,
        wangyanan55@huawei.com, zhao1.liu@intel.com, joao.m.martins@oracle.com
References: <cf587c8b-3894-4589-bfea-be5db70e81f3@redhat.com>
 <20250110211405.2284121-1-william.roche@oracle.com>
 <20250110211405.2284121-2-william.roche@oracle.com>
 <2a79643f-1d9e-4122-8932-954743a18c21@redhat.com>
Content-Language: en-US, fr
In-Reply-To: <2a79643f-1d9e-4122-8932-954743a18c21@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LNXP265CA0034.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:5c::22) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|LV3PR10MB7938:EE_
X-MS-Office365-Filtering-Correlation-Id: 03e1ef74-f230-479f-1799-08dd3f17cfcd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WWZvdXF6cjEvVlZLNmpJVVdPUVdVMU1GWjlpNXdCdElCN1BqdnNBS3c3RXVn?=
 =?utf-8?B?OHNvUUlJWDRFYTV3NTN4MTBZNENuYWhuQkFlZGZQSHhNa056SlYyMkJsLytx?=
 =?utf-8?B?U0ZBci9RY05OU2daVGdjSUdSRWJBRXFOdUNDWjE0eGVSTmt0NVY2c045ZERD?=
 =?utf-8?B?bjhKN21HWFFNOG5RWmdTRkpWUUFXOUhxRU1oWEMyd3k1WDlvZExjQjAzVlIv?=
 =?utf-8?B?N1NGL1Bqb3ZkbjVpYUtjd05Vay9TY3Zid3dkRmRIdlRpaVVXUCt1blBnQXYw?=
 =?utf-8?B?Tm9uTXFlay9tQXlBc1FibWRQbjBCaUI1TkNvZkZDQy9qaGQ5Uzh5TWo5dnlH?=
 =?utf-8?B?REl6aHpjWFlxUEtnelRZUkFWT0NWMU1PT1gwV0llTTYvZGF4MUlGbldxU1ph?=
 =?utf-8?B?VmlSQmZtK1BUNEpRNnlQWkJrRE5sVko2RnBLVDB4cUdBWExBUTV3Y0RpZ0gr?=
 =?utf-8?B?Y1R3M01LTzdiRzJzWVFmVXA0cVkzQ2dUamEzTDZidEd6Z3ZTVFhjdEp2S2lR?=
 =?utf-8?B?Z05wUmUyYkpoenZKWTcxNS84V3FnelY1YTg3MjhsZWpsZFJXQ011YW16dkNG?=
 =?utf-8?B?dk9ETkdrek1zRUVVNzdKTWtuVk9rYytMQXVFT3NCblJPY3RSZ3R5MWJOYWtp?=
 =?utf-8?B?bnpadEg1YnRVSnc3TVJRSkdSSno2QUtMekJpWURjdFFjRWhtM21ub1gzelpZ?=
 =?utf-8?B?RCttcDZPSHRqUGdPeC9YT3cyanMydjNEN01HQ0RyUU5wNEM5cGlCbnRBYTU0?=
 =?utf-8?B?U2pKNmw1ZEdITE1SWWo1Tzd4bzdpaDBpakZYN3RBVWg4TmFDbXV5UTVUeExp?=
 =?utf-8?B?NVF6VmpiMXpiVDJURXM2YzNaK2xvN2IzdWtmbENXOTVzZVBIazRLVEczQ1Ni?=
 =?utf-8?B?Rjl4MUt3Zm5iZ1dEQmVrYStrZnlXZkp2V0Yvb3dzT3drS2hoY0kyL09xNXZM?=
 =?utf-8?B?MnpmUTlUMW4yTXBOTlZ4YlZUL1VzeWtnWHR2MXI2VG5KKy9XMzA3Vzh3QjhR?=
 =?utf-8?B?VCt0TDYvckxmMnAxS1dPcUszMDd1Tkt0WnVpdktLdUJYUTZVTDJKNGFvMHBJ?=
 =?utf-8?B?VnRsazViNTZSaVZ3cXh2dkkrSU9vSUZZV1hlcmxJSDZNclRpbW43S0lUREhY?=
 =?utf-8?B?dEY1RHBDQkNPT2RrNjkydmxiY1YvL29jOFAxN1o3RGYvSmdtOThDTVZoN2Uy?=
 =?utf-8?B?dEJ4bDBMUXhSbVlPOXhEaUNMTzJPT3hWeWtmWnZOa0pEVFJjWmM4UERjWnB6?=
 =?utf-8?B?VG01SWEwZThSdjRhVWU5bG95aVJidjZQcDJwNkJkNVJGRzNrTFVnSWYzdzJX?=
 =?utf-8?B?WUpWbEQ0aGJVMkN6akxpU29KdVJRWXl6R0IwUDYzZWVBOXB0bVdnZktaUHVW?=
 =?utf-8?B?amtvMlJWVlJPMmsyVlI4b2IyYm1vSStKUVhlWGd6TVEwa1dqbU1MNmZBNW04?=
 =?utf-8?B?cXllRTlXS3RhZW02N254Nko4VlBVVjNVZmJmakdZZzdzU3hkeWc0QmJ1RjdX?=
 =?utf-8?B?UDQyQkZsa0cyN2Jrd0tGWFJXeVU4WCtpUlQ3VmMzaUtoOHN0OG0vTEErU1NV?=
 =?utf-8?B?LzBROHZ4VDhvRDVvdUZ0aVJ2MldIYmxEV1M2a3FaVGU5dklyQld4a052c0g4?=
 =?utf-8?B?bkY2QVNJcURocldOZVFzbFFVL3R5RTIzcXByRkZUeC8zU0FmZVhFbVpVQmtu?=
 =?utf-8?B?U1BIOStCNHlZKzZOTHppVW5ZWGkyemQrdklpc1pEZytqNlBPYy92K3lCa3g1?=
 =?utf-8?B?M1BhN09SenQrSG1xUlRNWnpObzJNdFIyWlJLd3hRWVh1UzFEVmNvNW8zZjVn?=
 =?utf-8?B?T2VwYXEwUTFNZHJpd3oxcWFLdmRPZVAycXd2ZXlQUmh4TGxENGxUS2JzOHpk?=
 =?utf-8?Q?B9+w9pC4h2oIq?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?KzZVM0RNdlF3MlZra0FHRzJMN3ZzN0hlOWl4RG9FR1NJWnYvOHZqSlJ5bWpj?=
 =?utf-8?B?NmdZQmUyVzhvcTlUeG9yaDZpbksybU9CSmxHcGdpWWxrRTdUZ1dpTVZiNVlF?=
 =?utf-8?B?SDlNTHpBVUtIa0ZBU0V0SDhWRzZmWE04VDhaak1RV1prSWZzWkI3ellIVHNY?=
 =?utf-8?B?b0tqVi9zZUdYaXZOeGhqRGNRUHl6VHdPblZYaGdxR1VNak1HbjF2MkRMVnRj?=
 =?utf-8?B?WEZYcVJ2WE4wbm5nZzNmUlJyMXhLdFJiZTVkbTVrS1orNUhLWFBmZCszeDNp?=
 =?utf-8?B?SWtKbjZ3ZlBFRDJWZDBhYUNUT1B2aWtmRHVBTE1jUnBaajh2ajZLNERtdWIx?=
 =?utf-8?B?MVJQamp3N0FsTGxrbDdQOGhSNU5FWmhzM3BwWG1DcFg2bjhtdjhyRUl2RS9k?=
 =?utf-8?B?bEYvZTJ4QW1RQlBaNERZT0ViZ3hvNWZuMXg1ZlFUNE9tZlFZQW5BbmQyZXpv?=
 =?utf-8?B?c3ZBelpEcXQ5QVRPc0g2M0M3VWs4ajQ2MnlnOXVYdWFJV0pUZDIwc3hnbnht?=
 =?utf-8?B?THRyZWdFV0h0bkNJenFTd2Y2OGV6SWNVRndHVmZoREdsVjN5M2lWa1VhYmwz?=
 =?utf-8?B?RmpxNS8wMitKUkFwQ2pQUkNhZktKYm9NSStXVWdDSHowN2d1L3h1VkIza3hF?=
 =?utf-8?B?ZWpYUGlYV2RwNCt0MDFFQ1ZNWk1SOWRKSk5Ld1hqTW0reHRrOWN5QlhCb1VH?=
 =?utf-8?B?YXM4UkJXTDZYc1RCaGRVTDFGREZHMkJlQWVDcURUUS9UV0FSS1kxbWdiRDh1?=
 =?utf-8?B?cHdwVWJJUTNSSjhGdFRyQS9ycXUyNzdmSXNtV1VRa2R0N0gzeGZ0WDJaMnJj?=
 =?utf-8?B?VzZMYnJ6WmEveVFEYUJPd05nZmVueUtldmNhNVRtV0J0eklzZjdPYkMzR3BK?=
 =?utf-8?B?UDdyOXhLNDBNUEJVQXJaTmVSNjRiOFFVbmFac3UxVVgwampVSUNORnI1N3ZC?=
 =?utf-8?B?d2wwblFGejVkbHF1Q2VwV0E5b0kvWktNdC9lamt3NUk4SG9pMTRWWDZ6c2E5?=
 =?utf-8?B?UEtzcFIvc28vdlk5K1hTbXhjNUlDaWZpaW8xUkMrMUF4TUczb1pNT1hiR0Zk?=
 =?utf-8?B?ck9ReTBUdDJWcTNsMDErK3hmb1ErTFByd09sNUx2MXVsbmhJV2UvNDQxTjNa?=
 =?utf-8?B?aHFpYk10QzVvTEZ0R2NOcXdDNXhoUUhHK0w3NHJsR1czWEdhREtkdk50UHp1?=
 =?utf-8?B?QmZjdkFnd0NnYllzT0V5RzNqdUsxaGxpVWc1VTdGUG9SZEpCR0xCYmZUaDZH?=
 =?utf-8?B?Mld5UEIvMVorQmd1Z3JSMy9pbjgrYkpqUDNtV0VtWGNUNEhHR3NXMXh5cDZU?=
 =?utf-8?B?N2tYTnNFdE5zcVMvRG5mb1VNRTZ0TWwrbE5RZFJrTU1pVFN1ZEtIUm5HQmxo?=
 =?utf-8?B?cVczSDhwNzN6ZDJUNSs1YUNXVjFLNng2aUNJZjB3VWV1N0pYL05RT0VDVDlQ?=
 =?utf-8?B?dG5oQ2VwMzI5Zk1kVWRXcWljYUFMUWVHeXNqM3hSMmI5ZnZBeHpUS3BQS0lo?=
 =?utf-8?B?cXR1YnlHL25Md1lySDZoMFUzV2tYTjAzSUpIbUtlRkZVRTkvT09ORTJLZGIz?=
 =?utf-8?B?OUlnYStzRW9qQmZzeXYvYTEzMlN6b2dKUmpmYzkwR3RUbldyS3dXVVVYNDQy?=
 =?utf-8?B?ck9kN0RNK09lKzRNY05QdWxjQU1tdFJqUGFtZlZkd3NaVUtIWXgrRm9xUWds?=
 =?utf-8?B?QjhRdGN0cGhrbi9icWc3V01ESXhlZ0x4a0dwQkg4ZmNRb3RTT0dUQWZSSDlw?=
 =?utf-8?B?c0RsaTZoNHVoVW1jRG82eGlkejgzRW1QeFh4dWR5MUtKeTFLcmdydlRaeTFk?=
 =?utf-8?B?SnlTTUs2WXNFL0pCUmRNNWtmMkU2Ly95M08yVjg0bzNUZnBRZmhSWmRoVVpl?=
 =?utf-8?B?Y3VQM0pXeGpibkRVQldpMzRlU0RvaXRhZDBOenBieFFkWFpFbEVxQ0p2ZVRv?=
 =?utf-8?B?YU0rV3ZkS0V4MUYxV3NCTmFMcDBTbDc2NWp3MnpHUk55OGZJbUgxY2FnWHRq?=
 =?utf-8?B?SnZ6V21ySERlbFRSTDR5SnppSTdqTzNMRlZUQUo4VUJwNTRnNGpvN1BuME5E?=
 =?utf-8?B?bjhxdW9vVldqRGVlTElaajh3cDBKUU9ocWRjOU5wVDhaNitVZTJHTjF1S0Zw?=
 =?utf-8?B?cVYvdWZxS3RIbG9saVF4NWoxUlRnWnN4MEhSR2lLdXZMakNDSmFIYXJ1L1Vy?=
 =?utf-8?B?d3c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	CZ7svUDuaa4PDuNn9S9mTMqIdIRaxcXwI24VhhwDpGSsf4QXgfxYUpSyjHl8mBEJchUP9ZpkMxMm1uiLYHo4sLoH12mCYdxTw+WpnaugC1QgTqnjTq7esWkEvD3Q45HzJp3RV0q6XycXuynhUMDR50Tmx/m0Dp4xSn3dFgbDJt2iiY+SC1CwcM/R3ydlEUt2TH5jK2QsisYavmb1PW9XEWLc8TiBcMK+IqihXHJQyacG0dbk5AuDNgvyv/6iH4qDZgOAVWZpvKCT7zVoJIZh4LQbZHcuXq+5C50IEBPDFioc8fKn5a4PdaBEAckVq44IInMLMUaqyW3YlviM/IESd0m72guXwcwE8kS58MMQ2SXKIcSDqt5dG73lFlERlLdBmkugY4d83egfaXKFJMI11d/TNSef72chFJF6T1pEcqlH1Z0ycCzG3YLwSA+XrAPmxq2BBNLN9M5YY/Hf+i2aTyiNHiec8oT1Xy32itBEpRDlJlQ1FArvkraHep3ay4v9tOnZb838iAw61hHZMkab9NpA/wgL9+SQwd5gOHazAkuDIOH+p4IRR3HGyMdjnKB2xx50ypv1x/vo+LXpdJ9TydHiq94UfbUZSk+QLYSU0GU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03e1ef74-f230-479f-1799-08dd3f17cfcd
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2025 21:16:06.2103
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i+OdwZYzwRTxf7cWVYreAXdlkHPsMiFFqD9DdZZI2iMKiVPspzZN9ZoFmUZOdCbBp0qV70jXD9hsgmkl1vipYh+gzWcpMr6wNWDX6KLgxLM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB7938
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-27_10,2025-01-27_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 spamscore=0
 malwarescore=0 mlxlogscore=999 bulkscore=0 phishscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501270167
X-Proofpoint-GUID: Sg6aXRtcYvveKSNNVFHnXpGAJAtFhraA
X-Proofpoint-ORIG-GUID: Sg6aXRtcYvveKSNNVFHnXpGAJAtFhraA

On 1/14/25 15:02, David Hildenbrand wrote:
> On 10.01.25 22:14, “William Roche wrote:
>> From: William Roche <william.roche@oracle.com>
>>
>> The list of hwpoison pages used to remap the memory on reset
>> is based on the backend real page size. When dealing with
>> hugepages, we create a single entry for the entire page.
>>
>> To correctly handle hugetlb, we must mmap(MAP_FIXED) a complete
>> hugetlb page; hugetlb pages cannot be partially mapped.
>>
>> Co-developed-by: David Hildenbrand <david@redhat.com>
>> Signed-off-by: William Roche <william.roche@oracle.com>
>> ---
> 
> See my comments to v4 version and my patch proposal.

I'm copying and answering your comments here:


On 1/14/25 14:56, David Hildenbrand wrote:
> On 10.01.25 21:56, William Roche wrote:
>> On 1/8/25 22:34, David Hildenbrand wrote:
>>> On 14.12.24 14:45, “William Roche wrote:
>>>> From: William Roche <william.roche@oracle.com>
>>>> [...]
>>>> @@ -1286,6 +1286,10 @@ static void kvm_unpoison_all(void *param)
>>>>    void kvm_hwpoison_page_add(ram_addr_t ram_addr)
>>>>    {
>>>>        HWPoisonPage *page;
>>>> +    size_t page_size = qemu_ram_pagesize_from_addr(ram_addr);
>>>> +
>>>> +    if (page_size > TARGET_PAGE_SIZE)
>>>> +        ram_addr = QEMU_ALIGN_DOWN(ram_addr, page_size);
>>>
>>> Is that part still required? I thought it would be sufficient (at least
>>> in the context of this patch) to handle it all in qemu_ram_remap().
>>>
>>> qemu_ram_remap() will calculate the range to process based on the
>>> RAMBlock page size. IOW, the QEMU_ALIGN_DOWN() we do now in
>>> qemu_ram_remap().
>>>
>>> Or am I missing something?
>>>
>>> (sorry if we discussed that already; if there is a good reason it might
>>> make sense to state it in the patch description)
>>
>> You are right, but at this patch level we still need to round up the
> 
> s/round up/align_down/
> 
>> address and doing it here is small enough.
> 
> Let me explain.
> 
> qemu_ram_remap() in this patch here doesn't need an aligned addr. It
> will compute the offset into the block and align that down.
> 
> The only case where we need the addr besides from that is the
> error_report(), where I am not 100% sure if that is actually what we
> want to print. We want to print something like ram_block_discard_range().
> 
> 
> Note that ram_addr_t is a weird, separate address space. The alignment
> does not have any guarantees / semantics there.
> 
> 
> See ram_block_add() where we set
>      new_block->offset = find_ram_offset(new_block->max_length);
> 
> independent of any other RAMBlock properties.
> 
> The only alignment we do is
>      candidate = ROUND_UP(candidate, BITS_PER_LONG << TARGET_PAGE_BITS);
> 
> There is no guarantee that new_block->offset will be aligned to 1 GiB with
> a 1 GiB hugetlb mapping.
> 
> 
> Note that there is another conceptual issue in this function: offset
> should be of type uint64_t, it's not really ram_addr_t, but an
> offset into the RAMBlock.

Ok.

> 
>> Of course, the code changes on patch 3/7 where we change both x86 and
>> ARM versions of the code to align the memory pointer correctly in both
>> cases.
> 
> Thinking about it more, we should never try aligning ram_addr_t, only
> the offset into the memory block or the virtual address.
> 
> So please remove this from this ram_addr_t alignment from this patch, 
> and look into
> aligning the virtual address / offset for the other user. Again, aligning
> ram_addr_t is not guaranteed to work correctly.
> 

Thanks for the technical details.

The ram_addr_t value alignment on the beginning of the page was useful 
to create a single entry in the hwpoison_page_list for a large page, but 
I understand that this use of ram_addr alignment may not be always accurate.
Removing this alignment (without replacing it with something else) will 
end up creating several page entries in this list for the same hugetlb 
page. Because when we loose a large page, we can receive several MCEs 
for the sub-page locations touched on this large page before the VM crashes.
So the recovery phase on reset will go through the list to discard/remap 
all the entries, and the same hugetlb page can be treated several times. 
But when we had a single entry for a large page, this multiple 
discard/remap does not occur.

Now, it could be technically acceptable to discard/remap a hugetlb page 
several times. Other than not being optimal and taking time, the same 
page being mapped or discarded multiple times doesn't seem to be a problem.
So we can leave the code like that  without complicating it with a block 
and offset attributes to the hwpoison_page_list entries for example.

> 
> So the patch itself should probably be (- patch description):
> 
> 
> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> index 801cff16a5..8a47aa7258 100644
> --- a/accel/kvm/kvm-all.c
> +++ b/accel/kvm/kvm-all.c
> @@ -1278,7 +1278,7 @@ static void kvm_unpoison_all(void *param)
> 
>       QLIST_FOREACH_SAFE(page, &hwpoison_page_list, list, next_page) {
>           QLIST_REMOVE(page, list);
> -        qemu_ram_remap(page->ram_addr, TARGET_PAGE_SIZE);
> +        qemu_ram_remap(page->ram_addr);
>           g_free(page);
>       }
>   }
> diff --git a/include/exec/cpu-common.h b/include/exec/cpu-common.h
> index 638dc806a5..50a829d31f 100644
> --- a/include/exec/cpu-common.h
> +++ b/include/exec/cpu-common.h
> @@ -67,7 +67,7 @@ typedef uintptr_t ram_addr_t;
> 
>   /* memory API */
> 
> -void qemu_ram_remap(ram_addr_t addr, ram_addr_t length);
> +void qemu_ram_remap(ram_addr_t addr);
>   /* This should not be used by devices.  */
>   ram_addr_t qemu_ram_addr_from_host(void *ptr);
>   ram_addr_t qemu_ram_addr_from_host_nofail(void *ptr);
> diff --git a/system/physmem.c b/system/physmem.c
> index 03d3618039..355588f5d5 100644
> --- a/system/physmem.c
> +++ b/system/physmem.c
> @@ -2167,17 +2167,35 @@ void qemu_ram_free(RAMBlock *block)
>   }
> 
>   #ifndef _WIN32
> -void qemu_ram_remap(ram_addr_t addr, ram_addr_t length)
> +/*
> + * qemu_ram_remap - remap a single RAM page
> + *
> + * @addr: address in ram_addr_t address space.
> + *
> + * This function will try remapping a single page of guest RAM identified by
> + * @addr, essentially discarding memory to recover from previously poisoned
> + * memory (MCE). The page size depends on the RAMBlock (i.e., hugetlb). @addr
> + * does not have to point at the start of the page.
> + *
> + * This function is only to be used during system resets; it will kill the
> + * VM if remapping failed.
> + */
> +void qemu_ram_remap(ram_addr_t addr)
>   {
>       RAMBlock *block;
> -    ram_addr_t offset;
> +    uint64_t offset;
>       int flags;
>       void *area, *vaddr;
>       int prot;
> +    size_t page_size;
> 
>       RAMBLOCK_FOREACH(block) {
>           offset = addr - block->offset;
>           if (offset < block->max_length) {
> +            /* Respect the pagesize of our RAMBlock */
> +            page_size = qemu_ram_pagesize(block);
> +            offset = QEMU_ALIGN_DOWN(offset, page_size);
> +
>               vaddr = ramblock_ptr(block, offset);
>               if (block->flags & RAM_PREALLOC) {
>                   ;
> @@ -2191,21 +2209,22 @@ void qemu_ram_remap(ram_addr_t addr, ram_addr_t length)
>                   prot = PROT_READ;
>                   prot |= block->flags & RAM_READONLY ? 0 : PROT_WRITE;
>                   if (block->fd >= 0) {
> -                    area = mmap(vaddr, length, prot, flags, block->fd,
> +                    area = mmap(vaddr, page_size, prot, flags, block->fd,
>                                   offset + block->fd_offset);
>                   } else {
>                       flags |= MAP_ANONYMOUS;
> -                    area = mmap(vaddr, length, prot, flags, -1, 0);
> +                    area = mmap(vaddr, page_size, prot, flags, -1, 0);
>                   }
>                   if (area != vaddr) {
> -                    error_report("Could not remap addr: "
> -                                 RAM_ADDR_FMT "@" RAM_ADDR_FMT "",
> -                                 length, addr);
> +                    error_report("Could not remap RAM %s:%" PRIx64 " +%zx",
> +                                 block->idstr, offset, page_size);
>                       exit(1);
>                   }
> -                memory_try_enable_merging(vaddr, length);
> -                qemu_ram_setup_dump(vaddr, length);
> +                memory_try_enable_merging(vaddr, page_size);
> +                qemu_ram_setup_dump(vaddr, page_size);
>               }
> +
> +            break;
>           }
>       }
>   }

I'll use your suggested changes, Thanks.


