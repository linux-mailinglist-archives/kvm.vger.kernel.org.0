Return-Path: <kvm+bounces-11609-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9268A878C25
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 02:11:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B506F1C21837
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 01:11:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEE561842;
	Tue, 12 Mar 2024 01:11:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EJGlBelu";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="xBtjnGQz"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 508137E2;
	Tue, 12 Mar 2024 01:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710205873; cv=fail; b=Lh+6iAACP9aLtShngv7VlTzAOvVDquxxnhe7b2ZzO9esq0FOMMZksMtDpKZ7EWo2QGLA8PsYh4MJqSHPsgr0db3GthUH92ta/xcSwLATXuZiiDNzwm/EXFF+/K0R1GFEALEvJ+qorFBdlN+Ze+LtdaHb5FRbfr2chIpZRQLQb+I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710205873; c=relaxed/simple;
	bh=du2tQ6r7Lr/uyyuJpp7WwQ4QPHT6pD5Tz3MB9uFKk68=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Ij3y8K28bIB83mBBZWtsQR57rZgvWX14lL74dG1mjeOFCeeRH9yE43lnxyWVFcc5K9XLkMsM/3E8gq5lLKgVtNxcntTczqOctOJ6UOtM/wrOhhihfGRY/5qvAYolpcXxcnBFSwUh1S3Ru7+lzF29eacC0BrltNmrGWBn1aTkbMg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=EJGlBelu; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=xBtjnGQz; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42C0wvdF032476;
	Tue, 12 Mar 2024 01:10:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=aofMxH8bMJVI+FDaivJC14o9Z0hU5PVidU8Wdm4WUQE=;
 b=EJGlBeluJ+0K5tOTKYjB+1PK2vus/WWuKLahXEQKILy6EwUl8215R0btFcpAR9xMIepG
 vl58W9msARZMCCh0Hx/DkNPy7SCJUFxgqBtSVlzBI9TMdTYlbSu4V2uOpuvcs29dVDOk
 TTyC+O30BsGOw52zn3zTlQIzBT2UuwnoE5VUze/nEf/8Y5iSTOZWKjEcLGvdDNwCiq/V
 Ih8tI0vr2o/lJyl/Ro58ZJawDPTB5rwKJtbJo/7Mvk/xciVUmKmzTjMnPwSxyF+YcXtG
 DfvhH0TnEoOR/I1vrVTRC/nQOj4yf8eAx/FOqO2TpUQDsXGmRLdIpDzh5a+8ZhdSCZVp 3w== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wrej3vsdh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 12 Mar 2024 01:10:57 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42BNWrNO009088;
	Tue, 12 Mar 2024 01:10:57 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3wre7crfwj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 12 Mar 2024 01:10:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IRPpfYAOK2ikbfmqmbwegpg0wxMGlDIEkwr1Zad3AmJLNpvSh0q3+GdWl0tueIOgPIii+4ZEzLEBGgWg/ubI51U3IzG+adHYiXItxK/QCBEH+dHFx6liut5VIYu/olkVb0B3gUJ6tGRoQCapWHfx1l0Y5S/cKRpw9sbCtLTWIdOhWx003O9LB+7AEujluutRSfA7ZpM4bR/3KSzdxfVrQyN/su8V3S44zS5GrItqjCfB7pBCI4gONw83TOVa4yiAJdMM0mbD6EaqNe4oXh2LM9BxENSboSBGmN30/Xx04+9BzDqIXdfaGN+D7VHKGmzrkkL5bz9sPReVoedPZkO7mQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aofMxH8bMJVI+FDaivJC14o9Z0hU5PVidU8Wdm4WUQE=;
 b=GqbDXtZiLO2YQj8xgcCAMCviTslKrTHd4RqoQb29Ysp9j8SJGV/biXe6/ibZKNHFqqebLecHW9kRxcZedA4gF4rFTqkoy+ct3/u+L5En07AURy7Cc90y+adIk9pMMPnqNGTg70DQhrTDSQfHPO6+DSJIdHX3oEeWS1jPGbvbSzW9TfbrZoLcHvgoer1HOix+M7EsN1v92+45Mt+s8G0xm+CxWFtzSnglOKFCQVsty0zPPK5fS6URKzabfitD2uKmunGFOp5PPtz7VzHMq9c3Q5gMRWIlaJLWg4qt/19P7fdViCCIHsYMCM0PvJFxGzLLSX7S2UlDDMwLr4rK4D5f4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aofMxH8bMJVI+FDaivJC14o9Z0hU5PVidU8Wdm4WUQE=;
 b=xBtjnGQzwi3GCRMoy4p2gyrB4gXjRDE7eHUNGtE3Vf7gvIut5+A0KC/gphguE/S7KPdbcvBbEiAHvwSO0q7hr5osS5CLo2pYYOuH6pZ3J/T1dCEXhy8AJ+Uai0g6yA+P7zr/uN2r2m2nOC/jnlJHHG+g9Dtr5STqRvFQ4US5SpM=
Received: from BN7PR10MB2659.namprd10.prod.outlook.com (2603:10b6:406:c5::18)
 by IA1PR10MB6073.namprd10.prod.outlook.com (2603:10b6:208:3af::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.35; Tue, 12 Mar
 2024 01:10:54 +0000
Received: from BN7PR10MB2659.namprd10.prod.outlook.com
 ([fe80::ea68:fce5:50e7:ba4c]) by BN7PR10MB2659.namprd10.prod.outlook.com
 ([fe80::ea68:fce5:50e7:ba4c%4]) with mapi id 15.20.7362.035; Tue, 12 Mar 2024
 01:10:54 +0000
Message-ID: <5ee34382-b45b-2069-ea33-ef58acacaa79@oracle.com>
Date: Mon, 11 Mar 2024 18:10:50 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 1/5] KVM: x86: Remove VMX support for virtualizing guest
 MTRR memtypes
To: Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Josh Triplett <josh@joshtriplett.org>
Cc: kvm@vger.kernel.org, rcu@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kevin Tian <kevin.tian@intel.com>, Yan Zhao <yan.y.zhao@intel.com>,
        Yiwei Zhang <zzyiwei@google.com>
References: <20240309010929.1403984-1-seanjc@google.com>
 <20240309010929.1403984-2-seanjc@google.com>
Content-Language: en-US
From: Dongli Zhang <dongli.zhang@oracle.com>
In-Reply-To: <20240309010929.1403984-2-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0108.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::23) To BN7PR10MB2659.namprd10.prod.outlook.com
 (2603:10b6:406:c5::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN7PR10MB2659:EE_|IA1PR10MB6073:EE_
X-MS-Office365-Filtering-Correlation-Id: 4cdf3606-1ba5-4f57-89f4-08dc42314425
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	/+VgYOOEn84glRQJxwKZ8I+JRSZTWyVPt3zzESo5LukPlaDODLiovbtV40Doj/TiL2+fxQuYIQcxbrvzNKSqU3wbmd+2SlQ/GwNnNoUPnmBq6IHH5qD2QEwMMmvvGhF3H2KAwuQ0nUlk7RGgGpRywjgy2xC84FhQy1gM4cA4/1G9PPk9DGRoGh3DwRBNGnTt1kGspnHWmPHz7pRs6xwWBJXERGMWdSUtAjwP0/U/NoQmuY0YEjl/Y7s+x8urE2DhufiFHbmnb5NORDD/tI1nkYCM/c3vPAjiiXKmgkfuJjWzeX7NjuxGVCHqbQO6zuKTP8zDkUof/lxme1ckOuPqQjITkv5HRDb24pHDM0UecIBduuDArEKq/01djIjxmGHt53j1AXqaBbe+ucpdFUhjvyP+e3rKVluSeL2lPNkgzs3NHA1t734ZEybJKK/vLsCza8nXyJsjVsFAE17dERzzMT8Ub7ruF29Xj2kJehfO6phil7TK13VKLMg8G+6bne0Ve7txsPIeIC9NspV8840j/narD/3VuJGo2V6ZkGv2aBfngLb+GZZnDHL18Fn4MZChj5G/rSYU7c95HNomDH0yzCHaIvnrT6ENyKDDHJkEMPWn8Nf0ZXVOps7UFrboUUzrd+k7rgmNVgKfGpJ7WfI/An1f8p6lURHy+2p5VYGT1MY=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN7PR10MB2659.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?NTRnalZUQzhmTG00OGVpWmo1Y29JbmwzaStjSy9LTXh3SDI3ZzRta1RsSWJS?=
 =?utf-8?B?akZKUi9wMzl0dzQxKy9HOStIZ29PbnZYbVRvZEJkakpaRThhYnhndlhTNDFp?=
 =?utf-8?B?dW8rd1d4R0YwaloreXNXRFBNTHNKcTFRc2Y0QVk2b0U3UU55L042TVFjK1Vh?=
 =?utf-8?B?cWpoYW1aR3FCdDErZUdiVUZ0ZmdSSnpBdjJhNXRDWVJCVWkzaENyUFZmVmZl?=
 =?utf-8?B?eEFrQWdzQ3cvMi8zOFFjV016RlB4ci8zTWI2U1NsdEw0VFBZU0xrQVpyM0o2?=
 =?utf-8?B?TCtNbWFlNlRhKzdtZWxnUEhvbHBzb3JNMG5HM0JhVFRoRVpZdGF0aE85WTNn?=
 =?utf-8?B?ZTJuZ1VmM0FFWmxITWkzelFuamxrbEJ1OEVYWXUva2NjNGNUOU53VnZQSlhH?=
 =?utf-8?B?bEFISDAycmtDaTlWMjJ0MXcxVGFHRjNQUmRrV0V4UVYwQUNjanMxL2xPS3Ro?=
 =?utf-8?B?MEJ1bXZZTEUvKzBqN0J3ejg2dHpCaWcrRkhBYlBxdnVLMGZxU0gwRnluSFIx?=
 =?utf-8?B?SDFqVTN3SkN4eHZzWnJxQTFCaEQwR3ZoeFdqNFhTd2NCK3ZNTVBkeGlxUFZJ?=
 =?utf-8?B?d2FsdGdWZU5qSVZaMGI1RGk4QTRRaXBTZktUb01XMnFvSUwzblkwRzMyVDZX?=
 =?utf-8?B?VzFUQnNFSEoyd3ZVbjhoV2dDZVRzWnF0ek10bjFGemoyTEhreGJISk1MN2Rh?=
 =?utf-8?B?U2lSWmovZUxZMFRVYjEraXlxSFhyZ1VaWlpWa1BEQ1QvREM5WnAvZGhwZy8y?=
 =?utf-8?B?Q21BVXpxRXdJd25KQWg1Q2ZkNEcvMVFCQnpDZFFKNUNjK0M5K3VBUmw4ZWlp?=
 =?utf-8?B?WFFaeU5BeDVoOFFCRFFvU2NqaXZ5dEx5YmppbzRseTg5ZjZPbDZURW9PQ1hx?=
 =?utf-8?B?K3F2NTB6VVViOHo5QU5mSDltTCtZUlRJMlBpb3d0VEswWWg0ZlZ3dUxYN1pI?=
 =?utf-8?B?Y3lFajRoZmsvaERTdXpmMzBSWEYxVWRzTXVLSXhRd25WNzd3NDlqR3pzbitT?=
 =?utf-8?B?eW9hQ2Zrd0cxRFFKYjZKWnZuMVd2a2NTcCtrYmJQTzhDQjUzY0M4NUNhTjl1?=
 =?utf-8?B?VE0wQlhLOStuUjVUYVFZdWNxWFNkSWRHa1JRejNsakZIUEI4TjhWRXBYbG5v?=
 =?utf-8?B?MTdlYXJ6ZWF5WGliSGVCWDVDbHducHpPM0huSE5iaENEVnZKaHNUR05rQUNh?=
 =?utf-8?B?VTZDY3kxeWVESldJRmZLSG1tNXg5cW45Z0E1ZjJyYW4xeHdoRTBPZ3FkLzlD?=
 =?utf-8?B?b3daV1ZnYjVCc3VOZ0lwV0UxZnkvMlJaUlQraVoxQ0JpUHhxUXNuckhic040?=
 =?utf-8?B?azRvdUlNN1dkUGJiSG83eHNweGYxUitLNnZ4NXVTVkNEZytRa3lxbk1zclVC?=
 =?utf-8?B?NnBoWFRha1gvdkVTUlVUdGIvTnJ2V3hmT09oVW5FcGYyRFl2RjMxTFVOUmp3?=
 =?utf-8?B?VTRKYkR3WUk4ZUFXNkFibGpTL0FnZ3U3QWRHK0xBVTI4MUZDNDAzWWJ3elAw?=
 =?utf-8?B?YWREdnFsWVArSWhKNDZRK0lvZEl3U0N1aVB2QWpwdkFOVVdKRjZSanFacFdv?=
 =?utf-8?B?S2JKTURTNWZSN3pXV1IxSTc2RXNEbThseEFyVUtSRDhiY1p2TzE0QjlHb09l?=
 =?utf-8?B?VWx3WUwyUXdDVXNJVUppbkVnMG85RmxyTGt3emwwL29ic3pXUHhLWUtrK2dD?=
 =?utf-8?B?Q2Zyd0VjSERXNUQzNXEyMTc3eHp4eVc2WW5waFNERzMxQlYxUDR4MGpFK2xZ?=
 =?utf-8?B?L3pSTm0wbWhzWmZ0azI4ejlHeEh2ejk3dEMyYUxKelBSL2huQktKQStsME5Y?=
 =?utf-8?B?ZHNDZEg4eW9sWDRxMlY2a0ZpelFScjVVekt0QThZaHloS3Jvemd0Q0F5bndW?=
 =?utf-8?B?YVZod01acGNHREQrSTdSOE1ZY0dMMXlpZGtwbTEyTzBnWjE1OWJTUGcyUUN3?=
 =?utf-8?B?cFJ3NUVyTllVL3hNSEd4Yyttb2xRdnNtaDBTVlpURjdCUVJtZFkrai9QZkkx?=
 =?utf-8?B?d3d6M25adHhOaHU2bWVZTCtoSVh5RlhpS05Xa2xiWkpaQnBnTWlDRlIwYUJa?=
 =?utf-8?B?OEdHMnZxQ0pLTVUzMmJmbVJzVEdzK0x4TlA3UUxDTEJ6ckdCMVVXSUVjeVFP?=
 =?utf-8?Q?zWYgWL7jCmpUjhEQc9PwclqZg?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	4H01ORUno2I02Zqpd8BiZ/IcO6yY7uhlJthfZNi1XclcVnIbJERGfgy3RKiVuM3Y647Djc5/+xVHuoQzU3imG3AQfK2SrwAZN4L42ymr2TXcnlUz2FwEd/hKOUB5V/TyjqF19UeYtbB5Ri6WhXwC55va1+Y17j3cHTprNnt1rcPkNYwwio//zEqdcaZnpB3n6og71Wanvq+mp0m1gIxpLNuA2QSlD5tV3H5g05SzgMKL6v8zhEjEemgvKThNlTnLGJTfzNw2Q3sV2uCcZL51weYI+njR/gyDki8Wbo2HDqCJ93hPzjCG/W/oJBHeuYtbMYcGIEY4eeMdB/eHbWDy4FQcQkYiFRFgqIP8a0luFLoODusePld5T4tKZmnn6Ky6p2DWewKBlvMOYTa733ShECPVbMXjlDQOYEDLISSOFtkZeviv3wMXNqDPnf5BHdF72g7QGVyYkPWlZ/f6qg0vOuaxC943hauAVdbCJ3qA1Iw94/5G3Xxj2svBi3hB06ha5zSfw0ncUaz5iRVZIZediX3EEr4s8Wnts5mEj8oHlzOCKGW+xHnFEhEjMKn0AI+WQJS061+45NUgP3i3L1/xt9Nn8gLcONqwqJaWozDnhwM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4cdf3606-1ba5-4f57-89f4-08dc42314425
X-MS-Exchange-CrossTenant-AuthSource: BN7PR10MB2659.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2024 01:10:54.4797
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ot4exYAeXGH1rOFI02rzfPI7lh0491HjNnRuyxW46UPktSmu4LhuwKtnW2ICj+eEn+aMmQE4Wrk3KMWDMmbuzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6073
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-11_13,2024-03-11_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 phishscore=0 malwarescore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2403120007
X-Proofpoint-GUID: sr7AqKKxtLsARFzJgSNaVCrnvPZswawv
X-Proofpoint-ORIG-GUID: sr7AqKKxtLsARFzJgSNaVCrnvPZswawv



On 3/8/24 17:09, Sean Christopherson wrote:
> Remove KVM's support for virtualizing guest MTRR memtypes, as full MTRR
> adds no value, negatively impacts guest performance, and is a maintenance
> burden due to it's complexity and oddities.
> 
> KVM's approach to virtualizating MTRRs make no sense, at all.  KVM *only*
> honors guest MTRR memtypes if EPT is enabled *and* the guest has a device
> that may perform non-coherent DMA access.  From a hardware virtualization
> perspective of guest MTRRs, there is _nothing_ special about EPT.  Legacy
> shadowing paging doesn't magically account for guest MTRRs, nor does NPT.

[snip]

>  
> -bool __kvm_mmu_honors_guest_mtrrs(bool vm_has_noncoherent_dma)
> +bool kvm_mmu_may_ignore_guest_pat(void)
>  {
>  	/*
> -	 * If host MTRRs are ignored (shadow_memtype_mask is non-zero), and the
> -	 * VM has non-coherent DMA (DMA doesn't snoop CPU caches), KVM's ABI is
> -	 * to honor the memtype from the guest's MTRRs so that guest accesses
> -	 * to memory that is DMA'd aren't cached against the guest's wishes.
> -	 *
> -	 * Note, KVM may still ultimately ignore guest MTRRs for certain PFNs,
> -	 * e.g. KVM will force UC memtype for host MMIO.
> +	 * When EPT is enabled (shadow_memtype_mask is non-zero), and the VM
> +	 * has non-coherent DMA (DMA doesn't snoop CPU caches), KVM's ABI is to
> +	 * honor the memtype from the guest's PAT so that guest accesses to
> +	 * memory that is DMA'd aren't cached against the guest's wishes.  As a
> +	 * result, KVM _may_ ignore guest PAT, whereas without non-coherent DMA,
> +	 * KVM _always_ ignores guest PAT (when EPT is enabled).
>  	 */
> -	return vm_has_noncoherent_dma && shadow_memtype_mask;
> +	return shadow_memtype_mask;
>  }
>  

Any special reason to use the naming 'may_ignore_guest_pat', but not
'may_honor_guest_pat'?

Since it is also controlled by other cases, e.g., kvm_arch_has_noncoherent_dma()
at vmx_get_mt_mask(), it can be 'may_honor_guest_pat' too?

Therefore, why not directly use 'shadow_memtype_mask' (without the API), or some
naming like "ept_enabled_for_hardware".


Even with the code from PATCH 5/5, we still have high chance that VM has
non-coherent DMA?

 bool kvm_mmu_may_ignore_guest_pat(void)
 {
 	/*
-	 * When EPT is enabled (shadow_memtype_mask is non-zero), and the VM
+	 * When EPT is enabled (shadow_memtype_mask is non-zero), the CPU does
+	 * not support self-snoop (or is affected by an erratum), and the VM
 	 * has non-coherent DMA (DMA doesn't snoop CPU caches), KVM's ABI is to
 	 * honor the memtype from the guest's PAT so that guest accesses to
 	 * memory that is DMA'd aren't cached against the guest's wishes.  As a
 	 * result, KVM _may_ ignore guest PAT, whereas without non-coherent DMA,
-	 * KVM _always_ ignores guest PAT (when EPT is enabled).
+	 * KVM _always_ ignores or honors guest PAT, i.e. doesn't toggle SPTE
+	 * bits in response to non-coherent device (un)registration.
 	 */
-	return shadow_memtype_mask;
+	return !static_cpu_has(X86_FEATURE_SELFSNOOP) && shadow_memtype_mask;
 }


Thank you very much!

Dongli Zhang

