Return-Path: <kvm+bounces-57752-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 23442B59E0E
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 18:46:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 755FC32851E
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 16:46:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6916234973;
	Tue, 16 Sep 2025 16:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="a58ysM1s";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="c5UTgL+5"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 419DD30170E
	for <kvm@vger.kernel.org>; Tue, 16 Sep 2025 16:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758041104; cv=fail; b=u2ibAGXC6pRIEuMGWKiqITGouZ+zMoWmTefChEi+a7HWE3Hc/2VBLvTAOysOIkF1jk6zQavlNJVDxuOHwomqhecrBqLb4rR536468ob9RBTqsHk39PN5iOmPTKS35MnkkOkuGgyPL+rZOw9oOkKnr371cRKa9R5bKSuyJQBAxkc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758041104; c=relaxed/simple;
	bh=kJDj0Y7Ni6ivf4kg2pWcd5Gz7yD27zw1+3sqewGLSgk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=EsX3y9oUC0mV9WdqEj9KQZlR694zuHZX1xHrwbz2E0zvUtMmf2s1zbkBwTCDqYMwJqUpoooOG5zwQ3Fobh+Qww/cswJLoI+wxLA/3aBp85S44kIrv1QfjmmEHpGeAJVqYRo71j87QDiL0u81stahImtLsPTfO74nIjAYaJC438E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=a58ysM1s; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=c5UTgL+5; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127837.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 58G94aZ6534950;
	Tue, 16 Sep 2025 09:44:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=c3xUaTMKqUyh4DCnl4NeKiVSKgRcx648f+oIF24kJ
	Lo=; b=a58ysM1sFwoyq4hy5PV+AufJB5t0/sfhj6yHprABDvvKbcPHy6IRqEe7P
	ZLHSNPoHgZ9FBxeuItrP+72IiEoCZstA7RKlW1WOVPD2Xkt4A77wcx6and/8Wyi3
	sg58KnKTrXoLJjRVwKfFlh07MK2wvWsjXWLG5ZV7zJtuHF0D1Kpz0Knu1fx5Hcvd
	ZNqnF5sSEDdAXPGgRzGMafpnzw4gVV5bmzRmXgCC0O7AMQFLRjbQ1fF71tZHjGXW
	BFimPO8fBEMqUMUFF/SyYtymfOVJSqE0T2jbqZY7RVMN7sA0vUQwD5KvZzGECgZ5
	+VbpUIKjKLnsYX6n2wvtFmIxp92Rw==
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11021090.outbound.protection.outlook.com [40.93.194.90])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4974xr12d4-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 16 Sep 2025 09:44:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TMN7RVNJjc0p8tLkVnY/qeqN7ec7kC0tW4dGy6/EV7GfKObrOvk19yHOufhpDZerzWsM3Bw5yhhedb3OZ2bBxOCiNac/K/Whd9xGGexzHEb/Q8SfjBy/ww7LTrctKr7aHjHTJZEJZVfLmAEG6nE3LRITGKFxDRmQQTN5UeSuTnUOgI00EAS7pZ8IX4MRBnpVHj2PH6xF/sDZwnvQc7reAsSoU7Ou8aP/CDr/AHDigeTW2+jdvjNWR/nsNd00g4umUe74uVVgICavxx+vgabC17QM76wTTRJ1smlBus4+/wPaMY6SiFZf9MJ7iPfi5mvZLEWvXdVPvu5V63gznOR1gA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c3xUaTMKqUyh4DCnl4NeKiVSKgRcx648f+oIF24kJLo=;
 b=a9gx8GrAU5bsMOURaKSyqVK6ue4w+ds40xFC1caPC7xed3UflzPWLETf0l/+1qFGRkC1wmv22kp9OYhytN/xlsBGUn2B3E+SsqWzkRqLyEO4BNdLmvivVJyWmsqVjx/byXjd0VuC8se5Nsv8l+NSNy/j47UKXHfEShNrMkKs5EwOywe8A4vcz/HHB9pBOr7CF2slSwc2ddYkRGRhAAQEgpELBHMvkACBTtDsuYa+p1affBXNFLbGBlqNxSidWtg0zdqqtqLW/auph9BydPMIhR0Ite4Y+D1fdsmVFypRhgrFhUurCS/KFIqbV7KUkRULV4LF0jSyCOB/Zuu/TEBKZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c3xUaTMKqUyh4DCnl4NeKiVSKgRcx648f+oIF24kJLo=;
 b=c5UTgL+5gkZek4U5ZdXZRPIwIpyiPSeUZnKau77ifLNC8Zz+i71BY4gSUPOxVaGmnMI/QuIhxFuJjgwrFQPnKQhPLdCgMisJOSD+R2MmbHxeiBWO5mmV1ELG5Tr984f/TUY0DVu09A2ROvfapVqYrru8OES0QHyKwrP7pNylL7cN+HXq2dHMSVNypUA7X+uXMWKLlJQ9/ZvZXFXBIPeBm8aLqdQWq6rBYlfhvAQFmCEBxXW/nY/cK8XtwoTixufzhgLzb4XPLw0nY9qcx9t2qPj8LY8NQyg2VoKpebhEKMa52L+dJcRHVAKEosSHgEAFNZZVpFWvvlC1ocUhqRCpNA==
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10) by PH0PR02MB8501.namprd02.prod.outlook.com
 (2603:10b6:510:100::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.22; Tue, 16 Sep
 2025 16:44:55 +0000
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054]) by LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054%5]) with mapi id 15.20.9115.022; Tue, 16 Sep 2025
 16:44:55 +0000
From: Jon Kohler <jon@nutanix.com>
To: seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org
Cc: Jon Kohler <jon@nutanix.com>
Subject: [kvm-unit-tests PATCH 17/17] x86/vmx: align exit reasons with Linux uapi
Date: Tue, 16 Sep 2025 10:22:46 -0700
Message-ID: <20250916172247.610021-18-jon@nutanix.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250916172247.610021-1-jon@nutanix.com>
References: <20250916172247.610021-1-jon@nutanix.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH1PEPF00013309.namprd07.prod.outlook.com
 (2603:10b6:518:1::18) To LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR02MB10287:EE_|PH0PR02MB8501:EE_
X-MS-Office365-Filtering-Correlation-Id: 47c6b54e-cdfb-496d-26c2-08ddf5405d78
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|52116014|376014|1800799024|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?0VNtft7lVBITG2pBu7p4z6qcGd0BUTHLU5Z5SS9EZ4F1Rvb28uGs69RN36+E?=
 =?us-ascii?Q?aO/ZJVY+TiuJfg45PjCItzpgOKfLygrOGj6aXNEJZNuhuIjYY/iE8IflmRD+?=
 =?us-ascii?Q?FX3iv8NPBb3Jlu3lx7IL7wjIE12yso2zbhF5PkAv8uEROcnFEwR9eHYc8eno?=
 =?us-ascii?Q?ihKOX55GhYYVjCaG4gqmhJdlo1YOnwsHct/2+kB6al+KB7ej/zVjVBgfrlks?=
 =?us-ascii?Q?b4lmtJuFMdVS8OqMezNLQ2LhvQ0Y6cBTCDXw7DlKCi6RVPY3h85GLT1yP767?=
 =?us-ascii?Q?a29jI7/DKc15xcJ+HGOOlN0TM1E4k2zQG45paouYxCOuDRkrSXDWgqNVCysz?=
 =?us-ascii?Q?uXhDFiq1CB5I9rD9OSiPoS4aA+6i2dP/m0s+jHiClaoxngzM8HEqGzMqQHMx?=
 =?us-ascii?Q?30nsKA0b8g62veLy3FeOmh/iKnS30Fx47XUqB6I2ZsCXYmLYE4Jq+Qzr5TTC?=
 =?us-ascii?Q?yDj99kqPCBmKmLXXlXnhqmQ7e+TaJ2iuOx9JZcLXrxVRbjUcbinfsKpGu0Dl?=
 =?us-ascii?Q?2Sea8vYw3OvLnUI/srkAqqvloozjQ+0bPe7nlPAMCzeNofJosj5mGwBxudcm?=
 =?us-ascii?Q?xmkWRNySP57cQWzioeOnhsUIZgF+lJ5lltYQWJ4XERba4EqB3jcxnsduRAXe?=
 =?us-ascii?Q?/41A+heqZEPHcbLvehk5DhlHmFR3QlHZkKg88I+rEOT/F18TiOOxlzInDGEi?=
 =?us-ascii?Q?inBX1vx8rMUP6T+CAhwsXetU0oLnUxtSZYGqybXecM4w2QORTrNZBGgpeGOx?=
 =?us-ascii?Q?VrB6w/HIpASBdwIrnPq9/fgGGokDoJUJGJVdIqDm/6QBFBEbpCC8AkAdHwnQ?=
 =?us-ascii?Q?UB89Br24fxMqYo32E7S5he9uPNOZtPSFrKXpBuBLw6T2KYgQ+CyWJDflLU+G?=
 =?us-ascii?Q?FsiimlZM6YgYY0IscoEaOQnP4FLUwYaEsg8JRyoX/F8cWz7PXmnI98FSL7ZK?=
 =?us-ascii?Q?n4lhJ1IvG0cyelgTnZhVRqzUyLCiCr+ePPiO4AfpXPFuDxXPKUxg6PiS3ueN?=
 =?us-ascii?Q?WsUQASlehp6AREAwkZAGfC6gV7mglka1T3jLn1BNb7TxmsQmtr2/IfHqCfN9?=
 =?us-ascii?Q?XawcXFr8YIRRpqOJsr5av9j5VLB6scMssunTM/RDBeDI229lxOGH7FRlYDcL?=
 =?us-ascii?Q?GKlVe+OnbinGG3XhcrNTUZ7T62zt7E7OvCrdlH1RRQnsubrbT3k3+AsHu0If?=
 =?us-ascii?Q?4DCUXtjWhN0GMwpLvwFyhzthhWdaBAnMLKXk8xzyexEXHvZYmDRYpfoWQp9A?=
 =?us-ascii?Q?M2SUjgA6HKYq0HWoS5+F0zdKBAaBGyVtrkrftNZiQEOjC7JfczuZCT+U2ATP?=
 =?us-ascii?Q?l8Zo07/mYOM+LN+NH7cEmgasyRAkx+oEBq22nXoKAgeBGFi7vZOAqBdkcrt2?=
 =?us-ascii?Q?pJBOUvcn7V6JEM+7Yw1+jF7mRzNz7JhbLUE0U5O7cja6cafHl/Wvp0Q0XlSQ?=
 =?us-ascii?Q?wE2tvq5PV6oJLbHpEcQjAATrMOx3pKsAN1XHZ0chaK0c63hV9V4Tbw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR02MB10287.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(52116014)(376014)(1800799024)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?9SYd6k2ykfO+eWBsnq0YZ/ZUJOVKBeoTvsIbYqqBzA6zrctK63teAbL5jiFz?=
 =?us-ascii?Q?O+BX9XQ/J9M5Apf0E/YNdI5RiOnE2mAF0IWUjn/agYHFWg3uNKmUHqxJrmqh?=
 =?us-ascii?Q?ACT5C3z99MPgRQ5P+rX8wlBCz5kKStWWjDE5ExiQ6zexSQ0xDt+a8yA4FMhS?=
 =?us-ascii?Q?oppRKAm3CnmNppeTFpwSDA5KCANch7csTuZBKs32UInvRtJmkU4w609mXjBv?=
 =?us-ascii?Q?kTY7bXC1omi7vutoJVHBht2ytQ5bmzLFc4Gp2UhiTu65ppB2/+fYpB/JIPxI?=
 =?us-ascii?Q?2xUp7ovLi+j/9e6niHAX34VWMr3pY4i2fLr1yb2nwo5L9XVsUw+NL0kmMY3d?=
 =?us-ascii?Q?tRHKe5xxMXMJ6rpqOE0Bo0mVRVrhQJO3FCliUk11Zd1rkpofPLguHUx5PfGl?=
 =?us-ascii?Q?hrEPH32OwMKrliUyBYEylb9W4LGlzRVsPzS0qvJxJlbiacHzxgig4R3Ah4h9?=
 =?us-ascii?Q?ZPraCmoWldh3KgGPQxnHtIX+nP6auFFX3eVF5Wcor5nGE87Nc2yXQxdnkuF0?=
 =?us-ascii?Q?NoEbMV3sXDjOQwF/Pyb88xr21KXWirOXTMpg+jYvB4xI0AgCsEW8eljvblEu?=
 =?us-ascii?Q?EQHP11gV3K9FCtIkLUWSBNDaeOK6VfLUtoDPfPZ/nlV/W/bF56gShLHbk3TD?=
 =?us-ascii?Q?fFDgCxVCKN3/ZTG5qNjJRS5zJw6F7wur/4yLV8guF0XA7pVZNpIDKSh7PZA2?=
 =?us-ascii?Q?Y1JV4npCyE7RoFTSFkzlz/AYBB7Rq2JCn/RqDxZkpmiv4HNO3r8Pm3UkjQGd?=
 =?us-ascii?Q?XWgYD0C7Zr2qfLep29YWCVVOaw4u4GcRI/2uvY91BNKYGIMKo2yUFlhIRGvB?=
 =?us-ascii?Q?eNVvhTqLH7IP8y0E56bhchXXBK6tozYp8pmHAiVhjZjALQZMPubBabjkAuWh?=
 =?us-ascii?Q?7taZZLaG/Zhx8SEjw0uxrV/Z0N3ARkPBIOPyTwoFsfi1LuNu290nHCkIFGW6?=
 =?us-ascii?Q?3FmhAfpeMfJZgsI5uQkspi/dOSVs+2qHTZPFoD34QDcP0OU1Dwl4txNPyGWT?=
 =?us-ascii?Q?8vGjW6h4QjBfHxXwqLMPS0hJaYPE4SIKiqHSfZ4+BR7CCrvk339FOrNsVh9X?=
 =?us-ascii?Q?M38jcsz4A0PAdvj/jS7vX9L9pAM8uknqSBTMQTIMhUZHOfAMpWN0E8pgOIyL?=
 =?us-ascii?Q?8+Lwq7B81QUYxcdymWxxHg8nDec1QKuQQCmxvCB+QudTZXPaYGWtqsqle/Jp?=
 =?us-ascii?Q?4utVGHeJrOx5Pc7D0+9e5anAwpfnz6zvBmebCAjTBkAeqEnXXjrrZcYJQW5z?=
 =?us-ascii?Q?j0S5/3yO8Lo21ZPQMd41ApWfpuSm3yPQTUVXfwmjsrQrRuWdnM8ziQ+T+EvB?=
 =?us-ascii?Q?+kp9SzH0uwIhuWCLsSbAEeB2j2S+qazXUJyczRomGdIFQeG4bb8GJ2eBm201?=
 =?us-ascii?Q?yDpunH3x9Fwch2IEkioYQ89rYq2K/obSn3KdZiJFF06tGODiCvoI1QbycH5/?=
 =?us-ascii?Q?x9mK2t2gQmH2jJ2fuAmzfQ3IqpmrtDmvfCuQeca5bYFmVh7C5W/1Vv64NnyS?=
 =?us-ascii?Q?BJJu6JMtdIMp1Xb9CMrw11tVHnycs6Cxv/yEHfqkv/LJ/YhucPoxQAWvBQUN?=
 =?us-ascii?Q?/hvw76HGhI/pFA0ecQn7wx7ADijjqxoApG6i6Y0Rl6zrgw+YwDzEmaajVzxk?=
 =?us-ascii?Q?Cw=3D=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47c6b54e-cdfb-496d-26c2-08ddf5405d78
X-MS-Exchange-CrossTenant-AuthSource: LV8PR02MB10287.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2025 16:44:55.3368
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Hnnsg/rFqnnC8eljaCRjzcQJAUEb3MVDwRN/JUAIftvhDjH/XVNKRadAB0tqhzO7n+/cIm56+fKWgqEr7BSSuBlLDIEXRm75asn39EFlc7Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR02MB8501
X-Authority-Analysis: v=2.4 cv=DuNW+H/+ c=1 sm=1 tr=0 ts=68c99409 cx=c_pps
 a=1SMuVRNdJx3IktO2ty4UNg==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=yJojWOMRYYMA:10 a=0kUYKlekyDsA:10 a=64Cc0HZtAAAA:8
 a=JYyOo_nYTQga8eOItckA:9
X-Proofpoint-GUID: sEYtoiEg-MKv90jKIw8vK9rPHvbKi5B6
X-Proofpoint-ORIG-GUID: sEYtoiEg-MKv90jKIw8vK9rPHvbKi5B6
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDE1NSBTYWx0ZWRfX2bU46c2I/1qa
 gqwtiWoOzqi/4B1my/U9QTUs3xoYP8ly3VOdmjsi0PSNOP9C9s6/b3HFcnBmOXVY9e6AfQ+pGsr
 qfh22FXUEvqU/NbjRqTG2h7eoUP5uVz3sGHVXrDifT2PstB5NTrXKi89OK6hNq+3ULXUYe2LVvJ
 rNj+3PYarpJL+s7au0ANd9yFxE84LzXAidRUrk9ORE9UX+LidJdV5DpTiXHuuSuYbX395EPAcxr
 4ur99MsoJ4u5vT0Vej4JxbhBt2DDIrJWIDC2vi1VMitBlxDVGfXcNbID5vfO7DN6MZphc41PqgR
 T5NunOT0zcxJfVZdU9tkJEQ1kW7pk7DIgzKehekbCwT8BvseGuilJsNAE5n0Bc=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-16_02,2025-09-12_01,2025-03-28_01
X-Proofpoint-Spam-Reason: safe

Align x86/vmx.h' enum Reasons with Linux's arch/x86/include/uapi/asm/vmx.h
EXIT_REASON_* definitions. Given how exit codes are wired up already in
KUT, it doesn't make a whole lot of sense to switch to the uapi header
itself; however, aligning the definitions makes it easier to grok from
one code base to another.

Note: this change picks up several previously undefined exit reasons, such
as UMWAIT, TPAUSE, BUS_LOCK, NOTIFY, TDCALL but does not add test cases
for them.

Note: Fixed misc indentation issues picked up by checkpatch along the way.

No functional change intended.

Signed-off-by: Jon Kohler <jon@nutanix.com>

---
 x86/vmx.c       | 134 ++++++++++++-----------
 x86/vmx.h       | 125 +++++++++++----------
 x86/vmx_tests.c | 283 +++++++++++++++++++++++++-----------------------
 3 files changed, 280 insertions(+), 262 deletions(-)

diff --git a/x86/vmx.c b/x86/vmx.c
index 7be93a72..98b05754 100644
--- a/x86/vmx.c
+++ b/x86/vmx.c
@@ -582,67 +582,71 @@ static void __attribute__((__used__)) syscall_handler(u64 syscall_no)
 		current->syscall_handler(syscall_no);
 }
 
+/* Naming scheme aligns with Linux's arch/x86/include/uapi/asm/vmx.h */
 static const char * const exit_reason_descriptions[] = {
-	[VMX_EXC_NMI]		= "VMX_EXC_NMI",
-	[VMX_EXTINT]		= "VMX_EXTINT",
-	[VMX_TRIPLE_FAULT]	= "VMX_TRIPLE_FAULT",
-	[VMX_INIT]		= "VMX_INIT",
-	[VMX_SIPI]		= "VMX_SIPI",
-	[VMX_SMI_IO]		= "VMX_SMI_IO",
-	[VMX_SMI_OTHER]		= "VMX_SMI_OTHER",
-	[VMX_INTR_WINDOW]	= "VMX_INTR_WINDOW",
-	[VMX_NMI_WINDOW]	= "VMX_NMI_WINDOW",
-	[VMX_TASK_SWITCH]	= "VMX_TASK_SWITCH",
-	[VMX_CPUID]		= "VMX_CPUID",
-	[VMX_GETSEC]		= "VMX_GETSEC",
-	[VMX_HLT]		= "VMX_HLT",
-	[VMX_INVD]		= "VMX_INVD",
-	[VMX_INVLPG]		= "VMX_INVLPG",
-	[VMX_RDPMC]		= "VMX_RDPMC",
-	[VMX_RDTSC]		= "VMX_RDTSC",
-	[VMX_RSM]		= "VMX_RSM",
-	[VMX_VMCALL]		= "VMX_VMCALL",
-	[VMX_VMCLEAR]		= "VMX_VMCLEAR",
-	[VMX_VMLAUNCH]		= "VMX_VMLAUNCH",
-	[VMX_VMPTRLD]		= "VMX_VMPTRLD",
-	[VMX_VMPTRST]		= "VMX_VMPTRST",
-	[VMX_VMREAD]		= "VMX_VMREAD",
-	[VMX_VMRESUME]		= "VMX_VMRESUME",
-	[VMX_VMWRITE]		= "VMX_VMWRITE",
-	[VMX_VMXOFF]		= "VMX_VMXOFF",
-	[VMX_VMXON]		= "VMX_VMXON",
-	[VMX_CR]		= "VMX_CR",
-	[VMX_DR]		= "VMX_DR",
-	[VMX_IO]		= "VMX_IO",
-	[VMX_RDMSR]		= "VMX_RDMSR",
-	[VMX_WRMSR]		= "VMX_WRMSR",
-	[VMX_FAIL_STATE]	= "VMX_FAIL_STATE",
-	[VMX_FAIL_MSR]		= "VMX_FAIL_MSR",
-	[VMX_MWAIT]		= "VMX_MWAIT",
-	[VMX_MTF]		= "VMX_MTF",
-	[VMX_MONITOR]		= "VMX_MONITOR",
-	[VMX_PAUSE]		= "VMX_PAUSE",
-	[VMX_FAIL_MCHECK]	= "VMX_FAIL_MCHECK",
-	[VMX_TPR_THRESHOLD]	= "VMX_TPR_THRESHOLD",
-	[VMX_APIC_ACCESS]	= "VMX_APIC_ACCESS",
-	[VMX_EOI_INDUCED]	= "VMX_EOI_INDUCED",
-	[VMX_GDTR_IDTR]		= "VMX_GDTR_IDTR",
-	[VMX_LDTR_TR]		= "VMX_LDTR_TR",
-	[VMX_EPT_VIOLATION]	= "VMX_EPT_VIOLATION",
-	[VMX_EPT_MISCONFIG]	= "VMX_EPT_MISCONFIG",
-	[VMX_INVEPT]		= "VMX_INVEPT",
-	[VMX_PREEMPT]		= "VMX_PREEMPT",
-	[VMX_INVVPID]		= "VMX_INVVPID",
-	[VMX_WBINVD]		= "VMX_WBINVD",
-	[VMX_XSETBV]		= "VMX_XSETBV",
-	[VMX_APIC_WRITE]	= "VMX_APIC_WRITE",
-	[VMX_RDRAND]		= "VMX_RDRAND",
-	[VMX_INVPCID]		= "VMX_INVPCID",
-	[VMX_VMFUNC]		= "VMX_VMFUNC",
-	[VMX_RDSEED]		= "VMX_RDSEED",
-	[VMX_PML_FULL]		= "VMX_PML_FULL",
-	[VMX_XSAVES]		= "VMX_XSAVES",
-	[VMX_XRSTORS]		= "VMX_XRSTORS",
+	[EXIT_REASON_EXCEPTION_NMI]	  = "EXCEPTION_NMI",
+	[EXIT_REASON_EXTERNAL_INTERRUPT]  = "EXTERNAL_INTERRUPT",
+	[EXIT_REASON_TRIPLE_FAULT]	  = "TRIPLE_FAULT",
+	[EXIT_REASON_INIT_SIGNAL]	  = "INIT_SIGNAL",
+	[EXIT_REASON_SIPI_SIGNAL]	  = "SIPI_SIGNAL",
+	[EXIT_REASON_INTERRUPT_WINDOW]	  = "INTERRUPT_WINDOW",
+	[EXIT_REASON_NMI_WINDOW]	  = "NMI_WINDOW",
+	[EXIT_REASON_TASK_SWITCH]	  = "TASK_SWITCH",
+	[EXIT_REASON_CPUID]		  = "CPUID",
+	[EXIT_REASON_HLT]		  = "HLT",
+	[EXIT_REASON_INVD]		  = "INVD",
+	[EXIT_REASON_INVLPG]		  = "INVLPG",
+	[EXIT_REASON_RDPMC]		  = "RDPMC",
+	[EXIT_REASON_RDTSC]		  = "RDTSC",
+	[EXIT_REASON_VMCALL]		  = "VMCALL",
+	[EXIT_REASON_VMCLEAR]		  = "VMCLEAR",
+	[EXIT_REASON_VMLAUNCH]		  = "VMLAUNCH",
+	[EXIT_REASON_VMPTRLD]		  = "VMPTRLD",
+	[EXIT_REASON_VMPTRST]		  = "VMPTRST",
+	[EXIT_REASON_VMREAD]		  = "VMREAD",
+	[EXIT_REASON_VMRESUME]		  = "VMRESUME",
+	[EXIT_REASON_VMWRITE]		  = "VMWRITE",
+	[EXIT_REASON_VMOFF]		  = "VMOFF",
+	[EXIT_REASON_VMON]		  = "VMON",
+	[EXIT_REASON_CR_ACCESS]		  = "CR_ACCESS",
+	[EXIT_REASON_DR_ACCESS]		  = "DR_ACCESS",
+	[EXIT_REASON_IO_INSTRUCTION]	  = "IO_INSTRUCTION",
+	[EXIT_REASON_MSR_READ]		  = "MSR_READ",
+	[EXIT_REASON_MSR_WRITE]		  = "MSR_WRITE",
+	[EXIT_REASON_INVALID_STATE]	  = "INVALID_STATE",
+	[EXIT_REASON_MSR_LOAD_FAIL]	  = "MSR_LOAD_FAIL",
+	[EXIT_REASON_MWAIT_INSTRUCTION]	  = "MWAIT_INSTRUCTION",
+	[EXIT_REASON_MONITOR_TRAP_FLAG]	  = "MONITOR_TRAP_FLAG",
+	[EXIT_REASON_MONITOR_INSTRUCTION] = "MONITOR_INSTRUCTION",
+	[EXIT_REASON_PAUSE_INSTRUCTION]	  = "PAUSE_INSTRUCTION",
+	[EXIT_REASON_MCE_DURING_VMENTRY]  = "MCE_DURING_VMENTRY",
+	[EXIT_REASON_TPR_BELOW_THRESHOLD] = "TPR_BELOW_THRESHOLD",
+	[EXIT_REASON_APIC_ACCESS]	  = "APIC_ACCESS",
+	[EXIT_REASON_EOI_INDUCED]	  = "EOI_INDUCED",
+	[EXIT_REASON_GDTR_IDTR]		  = "GDTR_IDTR",
+	[EXIT_REASON_LDTR_TR]		  = "LDTR_TR",
+	[EXIT_REASON_EPT_VIOLATION]	  = "EPT_VIOLATION",
+	[EXIT_REASON_EPT_MISCONFIG]	  = "EPT_MISCONFIG",
+	[EXIT_REASON_INVEPT]		  = "INVEPT",
+	[EXIT_REASON_RDTSCP]		  = "RDTSCP",
+	[EXIT_REASON_PREEMPTION_TIMER]	  = "PREEMPTION_TIMER",
+	[EXIT_REASON_INVVPID]		  = "INVVPID",
+	[EXIT_REASON_WBINVD]		  = "WBINVD",
+	[EXIT_REASON_XSETBV]		  = "XSETBV",
+	[EXIT_REASON_APIC_WRITE]	  = "APIC_WRITE",
+	[EXIT_REASON_RDRAND]		  = "RDRAND",
+	[EXIT_REASON_INVPCID]		  = "INVPCID",
+	[EXIT_REASON_VMFUNC]		  = "VMFUNC",
+	[EXIT_REASON_ENCLS]		  = "ENCLS",
+	[EXIT_REASON_RDSEED]		  = "RDSEED",
+	[EXIT_REASON_PML_FULL]		  = "PML_FULL",
+	[EXIT_REASON_XSAVES]		  = "XSAVES",
+	[EXIT_REASON_XRSTORS]		  = "XRSTORS",
+	[EXIT_REASON_UMWAIT]		  = "UMWAIT",
+	[EXIT_REASON_TPAUSE]		  = "TPAUSE",
+	[EXIT_REASON_BUS_LOCK]		  = "BUS_LOCK",
+	[EXIT_REASON_NOTIFY]		  = "NOTIFY",
+	[EXIT_REASON_TDCALL]		  = "TDCALL",
 };
 
 const char *exit_reason_description(u64 reason)
@@ -698,13 +702,13 @@ void print_vmentry_failure_info(struct vmentry_result *result)
 			result->instr, result->exit_reason.full, qual);
 
 		switch (result->exit_reason.basic) {
-		case VMX_FAIL_STATE:
+		case EXIT_REASON_INVALID_STATE:
 			printf("invalid guest state\n");
 			break;
-		case VMX_FAIL_MSR:
+		case EXIT_REASON_MSR_LOAD_FAIL:
 			printf("MSR loading\n");
 			break;
-		case VMX_FAIL_MCHECK:
+		case EXIT_REASON_MCE_DURING_VMENTRY:
 			printf("machine-check event\n");
 			break;
 		default:
@@ -1681,7 +1685,7 @@ void __attribute__((__used__)) hypercall(u32 hypercall_no)
 
 static bool is_hypercall(union exit_reason exit_reason)
 {
-	return exit_reason.basic == VMX_VMCALL &&
+	return exit_reason.basic == EXIT_REASON_VMCALL &&
 	       (hypercall_field & HYPERCALL_BIT);
 }
 
@@ -2002,7 +2006,7 @@ void __enter_guest(u8 abort_flag, struct vmentry_result *result)
 	}
 	if (result->exit_reason.failed_vmentry) {
 		if ((abort_flag & ABORT_ON_INVALID_GUEST_STATE) ||
-		    result->exit_reason.basic != VMX_FAIL_STATE)
+		    result->exit_reason.basic != EXIT_REASON_INVALID_STATE)
 			goto do_abort;
 		return;
 	}
diff --git a/x86/vmx.h b/x86/vmx.h
index 99ba7e52..5001886b 100644
--- a/x86/vmx.h
+++ b/x86/vmx.h
@@ -343,67 +343,72 @@ enum Encoding {
 #define VMX_ENTRY_FLAGS		(X86_EFLAGS_CF | X86_EFLAGS_PF | X86_EFLAGS_AF | \
 				 X86_EFLAGS_ZF | X86_EFLAGS_SF | X86_EFLAGS_OF)
 
+/* Naming scheme aligns with Linux's arch/x86/include/uapi/asm/vmx.h */
 enum Reason {
-	VMX_EXC_NMI		= 0,
-	VMX_EXTINT		= 1,
-	VMX_TRIPLE_FAULT	= 2,
-	VMX_INIT		= 3,
-	VMX_SIPI		= 4,
-	VMX_SMI_IO		= 5,
-	VMX_SMI_OTHER		= 6,
-	VMX_INTR_WINDOW		= 7,
-	VMX_NMI_WINDOW		= 8,
-	VMX_TASK_SWITCH		= 9,
-	VMX_CPUID		= 10,
-	VMX_GETSEC		= 11,
-	VMX_HLT			= 12,
-	VMX_INVD		= 13,
-	VMX_INVLPG		= 14,
-	VMX_RDPMC		= 15,
-	VMX_RDTSC		= 16,
-	VMX_RSM			= 17,
-	VMX_VMCALL		= 18,
-	VMX_VMCLEAR		= 19,
-	VMX_VMLAUNCH		= 20,
-	VMX_VMPTRLD		= 21,
-	VMX_VMPTRST		= 22,
-	VMX_VMREAD		= 23,
-	VMX_VMRESUME		= 24,
-	VMX_VMWRITE		= 25,
-	VMX_VMXOFF		= 26,
-	VMX_VMXON		= 27,
-	VMX_CR			= 28,
-	VMX_DR			= 29,
-	VMX_IO			= 30,
-	VMX_RDMSR		= 31,
-	VMX_WRMSR		= 32,
-	VMX_FAIL_STATE		= 33,
-	VMX_FAIL_MSR		= 34,
-	VMX_MWAIT		= 36,
-	VMX_MTF			= 37,
-	VMX_MONITOR		= 39,
-	VMX_PAUSE		= 40,
-	VMX_FAIL_MCHECK		= 41,
-	VMX_TPR_THRESHOLD	= 43,
-	VMX_APIC_ACCESS		= 44,
-	VMX_EOI_INDUCED		= 45,
-	VMX_GDTR_IDTR		= 46,
-	VMX_LDTR_TR		= 47,
-	VMX_EPT_VIOLATION	= 48,
-	VMX_EPT_MISCONFIG	= 49,
-	VMX_INVEPT		= 50,
-	VMX_PREEMPT		= 52,
-	VMX_INVVPID		= 53,
-	VMX_WBINVD		= 54,
-	VMX_XSETBV		= 55,
-	VMX_APIC_WRITE		= 56,
-	VMX_RDRAND		= 57,
-	VMX_INVPCID		= 58,
-	VMX_VMFUNC		= 59,
-	VMX_RDSEED		= 61,
-	VMX_PML_FULL		= 62,
-	VMX_XSAVES		= 63,
-	VMX_XRSTORS		= 64,
+	EXIT_REASON_EXCEPTION_NMI	= 0,
+	EXIT_REASON_EXTERNAL_INTERRUPT	= 1,
+	EXIT_REASON_TRIPLE_FAULT	= 2,
+	EXIT_REASON_INIT_SIGNAL		= 3,
+	EXIT_REASON_SIPI_SIGNAL		= 4,
+	EXIT_REASON_OTHER_SMI		= 6,
+	EXIT_REASON_INTERRUPT_WINDOW	= 7,
+	EXIT_REASON_NMI_WINDOW		= 8,
+	EXIT_REASON_TASK_SWITCH		= 9,
+	EXIT_REASON_CPUID		= 10,
+	EXIT_REASON_HLT			= 12,
+	EXIT_REASON_INVD		= 13,
+	EXIT_REASON_INVLPG		= 14,
+	EXIT_REASON_RDPMC		= 15,
+	EXIT_REASON_RDTSC		= 16,
+	EXIT_REASON_VMCALL		= 18,
+	EXIT_REASON_VMCLEAR		= 19,
+	EXIT_REASON_VMLAUNCH		= 20,
+	EXIT_REASON_VMPTRLD		= 21,
+	EXIT_REASON_VMPTRST		= 22,
+	EXIT_REASON_VMREAD		= 23,
+	EXIT_REASON_VMRESUME		= 24,
+	EXIT_REASON_VMWRITE		= 25,
+	EXIT_REASON_VMOFF		= 26,
+	EXIT_REASON_VMON		= 27,
+	EXIT_REASON_CR_ACCESS		= 28,
+	EXIT_REASON_DR_ACCESS		= 29,
+	EXIT_REASON_IO_INSTRUCTION	= 30,
+	EXIT_REASON_MSR_READ		= 31,
+	EXIT_REASON_MSR_WRITE		= 32,
+	EXIT_REASON_INVALID_STATE	= 33,
+	EXIT_REASON_MSR_LOAD_FAIL	= 34,
+	EXIT_REASON_MWAIT_INSTRUCTION	= 36,
+	EXIT_REASON_MONITOR_TRAP_FLAG	= 37,
+	EXIT_REASON_MONITOR_INSTRUCTION	= 39,
+	EXIT_REASON_PAUSE_INSTRUCTION	= 40,
+	EXIT_REASON_MCE_DURING_VMENTRY	= 41,
+	EXIT_REASON_TPR_BELOW_THRESHOLD	= 43,
+	EXIT_REASON_APIC_ACCESS		= 44,
+	EXIT_REASON_EOI_INDUCED		= 45,
+	EXIT_REASON_GDTR_IDTR		= 46,
+	EXIT_REASON_LDTR_TR		= 47,
+	EXIT_REASON_EPT_VIOLATION	= 48,
+	EXIT_REASON_EPT_MISCONFIG	= 49,
+	EXIT_REASON_INVEPT		= 50,
+	EXIT_REASON_RDTSCP		= 51,
+	EXIT_REASON_PREEMPTION_TIMER	= 52,
+	EXIT_REASON_INVVPID		= 53,
+	EXIT_REASON_WBINVD		= 54,
+	EXIT_REASON_XSETBV		= 55,
+	EXIT_REASON_APIC_WRITE		= 56,
+	EXIT_REASON_RDRAND		= 57,
+	EXIT_REASON_INVPCID		= 58,
+	EXIT_REASON_VMFUNC		= 59,
+	EXIT_REASON_ENCLS		= 60,
+	EXIT_REASON_RDSEED		= 61,
+	EXIT_REASON_PML_FULL		= 62,
+	EXIT_REASON_XSAVES		= 63,
+	EXIT_REASON_XRSTORS		= 64,
+	EXIT_REASON_UMWAIT		= 67,
+	EXIT_REASON_TPAUSE		= 68,
+	EXIT_REASON_BUS_LOCK		= 74,
+	EXIT_REASON_NOTIFY		= 75,
+	EXIT_REASON_TDCALL		= 77,
 };
 
 
diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 338e39b0..dd4bd43c 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -106,7 +106,7 @@ static int vmenter_exit_handler(union exit_reason exit_reason)
 	u64 guest_rip = vmcs_read(GUEST_RIP);
 
 	switch (exit_reason.basic) {
-	case VMX_VMCALL:
+	case EXIT_REASON_VMCALL:
 		if (regs.rax != 0xABCD) {
 			report_fail("test vmresume");
 			return VMX_TEST_VMEXIT;
@@ -178,7 +178,7 @@ static int preemption_timer_exit_handler(union exit_reason exit_reason)
 	guest_rip = vmcs_read(GUEST_RIP);
 	insn_len = vmcs_read(EXI_INST_LEN);
 	switch (exit_reason.basic) {
-	case VMX_PREEMPT:
+	case EXIT_REASON_PREEMPTION_TIMER:
 		switch (vmx_get_test_stage()) {
 		case 1:
 		case 2:
@@ -212,7 +212,7 @@ static int preemption_timer_exit_handler(union exit_reason exit_reason)
 			break;
 		}
 		break;
-	case VMX_VMCALL:
+	case EXIT_REASON_VMCALL:
 		vmcs_write(GUEST_RIP, guest_rip + insn_len);
 		switch (vmx_get_test_stage()) {
 		case 0:
@@ -361,7 +361,7 @@ static int test_ctrl_pat_exit_handler(union exit_reason exit_reason)
 
 	guest_rip = vmcs_read(GUEST_RIP);
 	switch (exit_reason.basic) {
-	case VMX_VMCALL:
+	case EXIT_REASON_VMCALL:
 		guest_pat = vmcs_read(GUEST_PAT);
 		if (!(ctrl_exit_rev.clr & VM_EXIT_SAVE_IA32_PAT)) {
 			printf("\tEXI_SAVE_PAT is not supported\n");
@@ -429,7 +429,7 @@ static int test_ctrl_efer_exit_handler(union exit_reason exit_reason)
 
 	guest_rip = vmcs_read(GUEST_RIP);
 	switch (exit_reason.basic) {
-	case VMX_VMCALL:
+	case EXIT_REASON_VMCALL:
 		guest_efer = vmcs_read(GUEST_EFER);
 		if (!(ctrl_exit_rev.clr & VM_EXIT_SAVE_IA32_EFER)) {
 			printf("\tEXI_SAVE_EFER is not supported\n");
@@ -556,7 +556,7 @@ static int cr_shadowing_exit_handler(union exit_reason exit_reason)
 	insn_len = vmcs_read(EXI_INST_LEN);
 	exit_qual = vmcs_read(EXI_QUALIFICATION);
 	switch (exit_reason.basic) {
-	case VMX_VMCALL:
+	case EXIT_REASON_VMCALL:
 		switch (vmx_get_test_stage()) {
 		case 0:
 			report(guest_cr0 == vmcs_read(GUEST_CR0),
@@ -599,7 +599,7 @@ static int cr_shadowing_exit_handler(union exit_reason exit_reason)
 		}
 		vmcs_write(GUEST_RIP, guest_rip + insn_len);
 		return VMX_TEST_RESUME;
-	case VMX_CR:
+	case EXIT_REASON_CR_ACCESS:
 		switch (vmx_get_test_stage()) {
 		case 4:
 			report_fail("Read shadowing CR0");
@@ -719,7 +719,7 @@ static int iobmp_exit_handler(union exit_reason exit_reason)
 	exit_qual = vmcs_read(EXI_QUALIFICATION);
 	insn_len = vmcs_read(EXI_INST_LEN);
 	switch (exit_reason.basic) {
-	case VMX_IO:
+	case EXIT_REASON_IO_INSTRUCTION:
 		switch (vmx_get_test_stage()) {
 		case 0:
 		case 1:
@@ -776,7 +776,7 @@ static int iobmp_exit_handler(union exit_reason exit_reason)
 		}
 		vmcs_write(GUEST_RIP, guest_rip + insn_len);
 		return VMX_TEST_RESUME;
-	case VMX_VMCALL:
+	case EXIT_REASON_VMCALL:
 		switch (vmx_get_test_stage()) {
 		case 9:
 			ctrl_cpu0 = vmcs_read(CPU_EXEC_CTRL0);
@@ -936,9 +936,9 @@ static struct insn_table insn_table[] = {
 		0, 0, 0},
 	/* LTR causes a #GP if done with a busy selector, so it is not tested.  */
 	{"RDRAND", SECONDARY_EXEC_RDRAND_EXITING, insn_rdrand, INSN_CPU1,
-		VMX_RDRAND, 0, 0, 0},
+		EXIT_REASON_RDRAND, 0, 0, 0},
 	{"RDSEED", SECONDARY_EXEC_RDSEED_EXITING, insn_rdseed, INSN_CPU1,
-		VMX_RDSEED, 0, 0, 0},
+		EXIT_REASON_RDSEED, 0, 0, 0},
 	// Instructions always trap
 	{"CPUID", 0, insn_cpuid, INSN_ALWAYS_TRAP, 10, 0, 0, 0},
 	{"INVD", 0, insn_invd, INSN_ALWAYS_TRAP, 13, 0, 0, 0},
@@ -1024,7 +1024,7 @@ static int insn_intercept_exit_handler(union exit_reason exit_reason)
 	insn_len = vmcs_read(EXI_INST_LEN);
 	insn_info = vmcs_read(EXI_INST_INFO);
 
-	if (exit_reason.basic == VMX_VMCALL) {
+	if (exit_reason.basic == EXIT_REASON_VMCALL) {
 		u32 val = 0;
 
 		if (insn_table[cur_insn].type == INSN_CPU0)
@@ -1323,7 +1323,7 @@ static int pml_exit_handler(union exit_reason exit_reason)
 	u32 insn_len = vmcs_read(EXI_INST_LEN);
 
 	switch (exit_reason.basic) {
-	case VMX_VMCALL:
+	case EXIT_REASON_VMCALL:
 		switch (vmx_get_test_stage()) {
 		case 0:
 			index = vmcs_read(GUEST_PML_INDEX);
@@ -1348,7 +1348,7 @@ static int pml_exit_handler(union exit_reason exit_reason)
 		}
 		vmcs_write(GUEST_RIP, guest_rip + insn_len);
 		return VMX_TEST_RESUME;
-	case VMX_PML_FULL:
+	case EXIT_REASON_PML_FULL:
 		vmx_inc_test_stage();
 		vmcs_write(GUEST_PML_INDEX, PML_INDEX - 1);
 		return VMX_TEST_RESUME;
@@ -1374,7 +1374,7 @@ static int ept_exit_handler_common(union exit_reason exit_reason, bool have_ad)
 	exit_qual = vmcs_read(EXI_QUALIFICATION);
 	pteval_t *ptep;
 	switch (exit_reason.basic) {
-	case VMX_VMCALL:
+	case EXIT_REASON_VMCALL:
 		switch (vmx_get_test_stage()) {
 		case 0:
 			check_ept_ad(pml4, guest_cr3,
@@ -1452,7 +1452,7 @@ static int ept_exit_handler_common(union exit_reason exit_reason, bool have_ad)
 		}
 		vmcs_write(GUEST_RIP, guest_rip + insn_len);
 		return VMX_TEST_RESUME;
-	case VMX_EPT_MISCONFIG:
+	case EXIT_REASON_EPT_MISCONFIG:
 		switch (vmx_get_test_stage()) {
 		case 1:
 		case 2:
@@ -1472,7 +1472,7 @@ static int ept_exit_handler_common(union exit_reason exit_reason, bool have_ad)
 			return VMX_TEST_VMEXIT;
 		}
 		return VMX_TEST_RESUME;
-	case VMX_EPT_VIOLATION:
+	case EXIT_REASON_EPT_VIOLATION:
 		/*
 		 * Exit-qualifications are masked not to account for advanced
 		 * VM-exit information. Once KVM supports this feature, this
@@ -1731,7 +1731,7 @@ static int interrupt_exit_handler(union exit_reason exit_reason)
 	u32 insn_len = vmcs_read(EXI_INST_LEN);
 
 	switch (exit_reason.basic) {
-	case VMX_VMCALL:
+	case EXIT_REASON_VMCALL:
 		switch (vmx_get_test_stage()) {
 		case 0:
 		case 2:
@@ -1770,7 +1770,7 @@ static int interrupt_exit_handler(union exit_reason exit_reason)
 		vmx_inc_test_stage();
 		vmcs_write(GUEST_RIP, guest_rip + insn_len);
 		return VMX_TEST_RESUME;
-	case VMX_EXTINT:
+	case EXIT_REASON_EXTERNAL_INTERRUPT:
 		if (vmcs_read(EXI_CONTROLS) & VM_EXIT_ACK_INTR_ON_EXIT) {
 			int vector = vmcs_read(EXI_INTR_INFO) & 0xff;
 			handle_external_interrupt(vector);
@@ -1867,11 +1867,11 @@ static int nmi_hlt_exit_handler(union exit_reason exit_reason)
 
     switch (vmx_get_test_stage()) {
     case 1:
-        if (exit_reason.basic != VMX_VMCALL) {
-            report_fail("VMEXIT not due to vmcall. Exit reason 0x%x",
-                        exit_reason.full);
-            print_vmexit_info(exit_reason);
-            return VMX_TEST_VMEXIT;
+	if (exit_reason.basic != EXIT_REASON_VMCALL) {
+		report_fail("VMEXIT not due to vmcall. Exit reason 0x%x",
+			    exit_reason.full);
+		print_vmexit_info(exit_reason);
+		return VMX_TEST_VMEXIT;
         }
 
         vmcs_write(PIN_CONTROLS,
@@ -1882,15 +1882,15 @@ static int nmi_hlt_exit_handler(union exit_reason exit_reason)
         break;
 
     case 2:
-        if (exit_reason.basic != VMX_EXC_NMI) {
-            report_fail("VMEXIT not due to NMI intercept. Exit reason 0x%x",
-                        exit_reason.full);
-            print_vmexit_info(exit_reason);
-            return VMX_TEST_VMEXIT;
-        }
-        report_pass("NMI intercept while running guest");
-        vmcs_write(GUEST_ACTV_STATE, ACTV_ACTIVE);
-        break;
+	if (exit_reason.basic != EXIT_REASON_EXCEPTION_NMI) {
+		report_fail("VMEXIT not due to NMI intercept. Exit reason 0x%x",
+			    exit_reason.full);
+		print_vmexit_info(exit_reason);
+		return VMX_TEST_VMEXIT;
+	}
+	report_pass("NMI intercept while running guest");
+	vmcs_write(GUEST_ACTV_STATE, ACTV_ACTIVE);
+	break;
 
     case 3:
         break;
@@ -1982,7 +1982,7 @@ static int dbgctls_exit_handler(union exit_reason exit_reason)
 	debugctl = rdmsr(MSR_IA32_DEBUGCTLMSR);
 
 	switch (exit_reason.basic) {
-	case VMX_VMCALL:
+	case EXIT_REASON_VMCALL:
 		switch (vmx_get_test_stage()) {
 		case 0:
 			if (dr7 == 0x400 && debugctl == 0 &&
@@ -2061,7 +2061,8 @@ static void msr_switch_main(void)
 
 static int msr_switch_exit_handler(union exit_reason exit_reason)
 {
-	if (exit_reason.basic == VMX_VMCALL && vmx_get_test_stage() == 2) {
+	if (exit_reason.basic == EXIT_REASON_VMCALL &&
+	    vmx_get_test_stage() == 2) {
 		report(exit_msr_store[0].value == MSR_MAGIC + 1,
 		       "VM exit MSR store");
 		report(rdmsr(MSR_KERNEL_GS_BASE) == MSR_MAGIC + 2,
@@ -2083,7 +2084,7 @@ static int msr_switch_entry_failure(struct vmentry_result *result)
 	}
 
 	if (result->exit_reason.failed_vmentry &&
-	    result->exit_reason.basic == VMX_FAIL_MSR &&
+	    result->exit_reason.basic == EXIT_REASON_MSR_LOAD_FAIL &&
 	    vmx_get_test_stage() == 3) {
 		report(vmcs_read(EXI_QUALIFICATION) == 1,
 		       "VM entry MSR load: try to load FS_BASE");
@@ -2113,11 +2114,11 @@ static void vmmcall_main(void)
 static int vmmcall_exit_handler(union exit_reason exit_reason)
 {
 	switch (exit_reason.basic) {
-	case VMX_VMCALL:
+	case EXIT_REASON_VMCALL:
 		printf("here\n");
 		report_fail("VMMCALL triggers #UD");
 		break;
-	case VMX_EXC_NMI:
+	case EXIT_REASON_EXCEPTION_NMI:
 		report((vmcs_read(EXI_INTR_INFO) & 0xff) == UD_VECTOR,
 		       "VMMCALL triggers #UD");
 		break;
@@ -2177,7 +2178,7 @@ static void disable_rdtscp_main(void)
 static int disable_rdtscp_exit_handler(union exit_reason exit_reason)
 {
 	switch (exit_reason.basic) {
-	case VMX_VMCALL:
+	case EXIT_REASON_VMCALL:
 		switch (vmx_get_test_stage()) {
 		case 0:
 			report_fail("RDTSCP triggers #UD");
@@ -2230,7 +2231,7 @@ static void skip_exit_insn(void)
 
 static void skip_exit_vmcall(void)
 {
-	assert_exit_reason(VMX_VMCALL);
+	assert_exit_reason(EXIT_REASON_VMCALL);
 	skip_exit_insn();
 }
 
@@ -2410,7 +2411,7 @@ static void do_ept_violation(bool leaf, enum ept_access_op op,
 	/* Try the access and observe the violation. */
 	do_ept_access_op(op);
 
-	assert_exit_reason(VMX_EPT_VIOLATION);
+	assert_exit_reason(EXIT_REASON_EPT_VIOLATION);
 
 	qual = vmcs_read(EXI_QUALIFICATION);
 
@@ -2661,7 +2662,7 @@ static void ept_misconfig_at_level_mkhuge_op(bool mkhuge, int level,
 	orig_pte = ept_twiddle(data->gpa, mkhuge, level, clear, set);
 
 	do_ept_access_op(op);
-	assert_exit_reason(VMX_EPT_MISCONFIG);
+	assert_exit_reason(EXIT_REASON_EPT_MISCONFIG);
 
 	/* Intel 27.2.1, "For all other VM exits, this field is cleared." */
 	#if 0
@@ -3522,8 +3523,8 @@ static bool vmlaunch(void)
 	return false;
 success:
 	exit_reason = vmcs_read(EXI_REASON);
-	TEST_ASSERT(exit_reason == (VMX_FAIL_STATE | VMX_ENTRY_FAILURE) ||
-		    exit_reason == (VMX_FAIL_MSR | VMX_ENTRY_FAILURE));
+	TEST_ASSERT(exit_reason == (EXIT_REASON_INVALID_STATE | VMX_ENTRY_FAILURE) ||
+		    exit_reason == (EXIT_REASON_MSR_LOAD_FAIL | VMX_ENTRY_FAILURE));
 	return true;
 }
 
@@ -5239,7 +5240,7 @@ static void report_mtf(const char *insn_name, unsigned long exp_rip)
 {
 	unsigned long rip = vmcs_read(GUEST_RIP);
 
-	assert_exit_reason(VMX_MTF);
+	assert_exit_reason(EXIT_REASON_MONITOR_TRAP_FLAG);
 	report(rip == exp_rip, "MTF VM-exit after %s. RIP: 0x%lx (expected 0x%lx)",
 	       insn_name, rip, exp_rip);
 }
@@ -5464,7 +5465,7 @@ static void vmx_mtf_pdpte_test(void)
 
 	enable_mtf();
 	enter_guest();
-	assert_exit_reason(VMX_MTF);
+	assert_exit_reason(EXIT_REASON_MONITOR_TRAP_FLAG);
 	disable_mtf();
 
 	/*
@@ -5626,10 +5627,10 @@ static void test_guest_state(const char *test, bool xfail, u64 field,
 	__enter_guest(abort_flags, &result);
 
 	report(result.exit_reason.failed_vmentry == xfail &&
-	       ((xfail && result.exit_reason.basic == VMX_FAIL_STATE) ||
-	        (!xfail && result.exit_reason.basic == VMX_VMCALL)) &&
+	       ((xfail && result.exit_reason.basic == EXIT_REASON_INVALID_STATE) ||
+		(!xfail && result.exit_reason.basic == EXIT_REASON_VMCALL)) &&
 		(!xfail || vmcs_read(EXI_QUALIFICATION) == ENTRY_FAIL_DEFAULT),
-	        "%s, %s = %lx", test, field_name, field);
+		"%s, %s = %lx", test, field_name, field);
 
 	if (!result.exit_reason.failed_vmentry)
 		skip_exit_insn();
@@ -5810,21 +5811,21 @@ static bool apic_reg_virt_exit_expectation(
 		config->virtualize_apic_accesses &&
 		config->activate_secondary_controls;
 	if (virtualize_apic_accesses_only) {
-		expectation->rd_exit_reason = VMX_APIC_ACCESS;
-		expectation->wr_exit_reason = VMX_APIC_ACCESS;
+		expectation->rd_exit_reason = EXIT_REASON_APIC_ACCESS;
+		expectation->wr_exit_reason = EXIT_REASON_APIC_ACCESS;
 	} else if (virtualize_apic_accesses_and_use_tpr_shadow) {
 		switch (reg) {
 		case APIC_TASKPRI:
-			expectation->rd_exit_reason = VMX_VMCALL;
-			expectation->wr_exit_reason = VMX_VMCALL;
+			expectation->rd_exit_reason = EXIT_REASON_VMCALL;
+			expectation->wr_exit_reason = EXIT_REASON_VMCALL;
 			expectation->virt_fn = apic_virt_nibble1;
 			break;
 		default:
-			expectation->rd_exit_reason = VMX_APIC_ACCESS;
-			expectation->wr_exit_reason = VMX_APIC_ACCESS;
+			expectation->rd_exit_reason = EXIT_REASON_APIC_ACCESS;
+			expectation->wr_exit_reason = EXIT_REASON_APIC_ACCESS;
 		}
 	} else if (apic_register_virtualization) {
-		expectation->rd_exit_reason = VMX_VMCALL;
+		expectation->rd_exit_reason = EXIT_REASON_VMCALL;
 
 		switch (reg) {
 		case APIC_ID:
@@ -5842,25 +5843,25 @@ static bool apic_reg_virt_exit_expectation(
 		case APIC_LVTERR:
 		case APIC_TMICT:
 		case APIC_TDCR:
-			expectation->wr_exit_reason = VMX_APIC_WRITE;
+			expectation->wr_exit_reason = EXIT_REASON_APIC_WRITE;
 			break;
 		case APIC_LVR:
 		case APIC_ISR ... APIC_ISR + 0x70:
 		case APIC_TMR ... APIC_TMR + 0x70:
 		case APIC_IRR ... APIC_IRR + 0x70:
-			expectation->wr_exit_reason = VMX_APIC_ACCESS;
+			expectation->wr_exit_reason = EXIT_REASON_APIC_ACCESS;
 			break;
 		case APIC_TASKPRI:
-			expectation->wr_exit_reason = VMX_VMCALL;
+			expectation->wr_exit_reason = EXIT_REASON_VMCALL;
 			expectation->virt_fn = apic_virt_nibble1;
 			break;
 		case APIC_ICR2:
-			expectation->wr_exit_reason = VMX_VMCALL;
+			expectation->wr_exit_reason = EXIT_REASON_VMCALL;
 			expectation->virt_fn = apic_virt_byte3;
 			break;
 		default:
-			expectation->rd_exit_reason = VMX_APIC_ACCESS;
-			expectation->wr_exit_reason = VMX_APIC_ACCESS;
+			expectation->rd_exit_reason = EXIT_REASON_APIC_ACCESS;
+			expectation->wr_exit_reason = EXIT_REASON_APIC_ACCESS;
 		}
 	} else if (!expectation->virtualize_apic_accesses) {
 		/*
@@ -5869,8 +5870,8 @@ static bool apic_reg_virt_exit_expectation(
 		 * the use TPR shadow control, but not through directly
 		 * accessing VTPR.
 		 */
-		expectation->rd_exit_reason = VMX_VMCALL;
-		expectation->wr_exit_reason = VMX_VMCALL;
+		expectation->rd_exit_reason = EXIT_REASON_VMCALL;
+		expectation->wr_exit_reason = EXIT_REASON_VMCALL;
 	} else {
 		printf("Cannot parse APIC register virtualization config:\n"
 		       "\tvirtualize_apic_accesses: %d\n"
@@ -6111,14 +6112,14 @@ static void test_xapic_rd(
 	args->apic_access_address = apic_access_address;
 	args->reg = reg;
 	args->val = val;
-	args->check_rd = exit_reason_want == VMX_VMCALL;
+	args->check_rd = exit_reason_want == EXIT_REASON_VMCALL;
 	args->virt_fn = expectation->virt_fn;
 
 	/* Setup virtual APIC page */
 	if (!expectation->virtualize_apic_accesses) {
 		apic_access_address[apic_reg_index(reg)] = val;
 		virtual_apic_page[apic_reg_index(reg)] = 0;
-	} else if (exit_reason_want == VMX_VMCALL) {
+	} else if (exit_reason_want == EXIT_REASON_VMCALL) {
 		apic_access_address[apic_reg_index(reg)] = 0;
 		virtual_apic_page[apic_reg_index(reg)] = val;
 	}
@@ -6130,7 +6131,7 @@ static void test_xapic_rd(
 	 * Validate the behavior and
 	 * pass a magic value back to the guest.
 	 */
-	if (exit_reason_want == VMX_APIC_ACCESS) {
+	if (exit_reason_want == EXIT_REASON_APIC_ACCESS) {
 		u32 apic_page_offset = vmcs_read(EXI_QUALIFICATION) & 0xfff;
 
 		assert_exit_reason(exit_reason_want);
@@ -6141,7 +6142,7 @@ static void test_xapic_rd(
 
 		/* Reenter guest so it can consume/check rcx and exit again. */
 		enter_guest();
-	} else if (exit_reason_want != VMX_VMCALL) {
+	} else if (exit_reason_want != EXIT_REASON_VMCALL) {
 		report_fail("Oops, bad exit expectation: %u.", exit_reason_want);
 	}
 
@@ -6158,8 +6159,8 @@ static void test_xapic_wr(
 	struct apic_reg_virt_guest_args *args = &apic_reg_virt_guest_args;
 	bool virtualized =
 		expectation->virtualize_apic_accesses &&
-		(exit_reason_want == VMX_APIC_WRITE ||
-		 exit_reason_want == VMX_VMCALL);
+		(exit_reason_want == EXIT_REASON_APIC_WRITE ||
+		 exit_reason_want == EXIT_REASON_VMCALL);
 	bool checked = false;
 
 	report_prefix_pushf("xapic - writing 0x%x to 0x%03x", val, reg);
@@ -6183,7 +6184,7 @@ static void test_xapic_wr(
 	 * Validate the behavior and
 	 * pass a magic value back to the guest.
 	 */
-	if (exit_reason_want == VMX_APIC_ACCESS) {
+	if (exit_reason_want == EXIT_REASON_APIC_ACCESS) {
 		u32 apic_page_offset = vmcs_read(EXI_QUALIFICATION) & 0xfff;
 
 		assert_exit_reason(exit_reason_want);
@@ -6194,7 +6195,7 @@ static void test_xapic_wr(
 
 		/* Reenter guest so it can consume/check rcx and exit again. */
 		enter_guest();
-	} else if (exit_reason_want == VMX_APIC_WRITE) {
+	} else if (exit_reason_want == EXIT_REASON_APIC_WRITE) {
 		assert_exit_reason(exit_reason_want);
 		report(virtual_apic_page[apic_reg_index(reg)] == val,
 		       "got APIC write exit @ page offset 0x%03x; val is 0x%x, want 0x%x",
@@ -6204,11 +6205,11 @@ static void test_xapic_wr(
 
 		/* Reenter guest so it can consume/check rcx and exit again. */
 		enter_guest();
-	} else if (exit_reason_want != VMX_VMCALL) {
+	} else if (exit_reason_want != EXIT_REASON_VMCALL) {
 		report_fail("Oops, bad exit expectation: %u.", exit_reason_want);
 	}
 
-	assert_exit_reason(VMX_VMCALL);
+	assert_exit_reason(EXIT_REASON_VMCALL);
 	if (virtualized && !checked) {
 		u32 want = expectation->virt_fn(val);
 		u32 got = virtual_apic_page[apic_reg_index(reg)];
@@ -6398,7 +6399,7 @@ static void apic_reg_virt_test(void)
 	vmcs_write(CPU_EXEC_CTRL1, cpu_exec_ctrl1);
 	args->op = TERMINATE;
 	enter_guest();
-	assert_exit_reason(VMX_VMCALL);
+	assert_exit_reason(EXIT_REASON_VMCALL);
 }
 
 struct virt_x2apic_mode_config {
@@ -6461,7 +6462,7 @@ static void virt_x2apic_mode_rd_expectation(
 {
 	enum x2apic_reg_semantics semantics = get_x2apic_reg_semantics(reg);
 
-	expectation->rd_exit_reason = VMX_VMCALL;
+	expectation->rd_exit_reason = EXIT_REASON_VMCALL;
 	expectation->virt_fn = virt_x2apic_mode_identity;
 	if (virt_x2apic_mode_on && apic_register_virtualization) {
 		expectation->rd_val = MAGIC_VAL_1;
@@ -6569,7 +6570,7 @@ static void virt_x2apic_mode_wr_expectation(
 	bool virt_int_delivery,
 	struct virt_x2apic_mode_expectation *expectation)
 {
-	expectation->wr_exit_reason = VMX_VMCALL;
+	expectation->wr_exit_reason = EXIT_REASON_VMCALL;
 	expectation->wr_val = MAGIC_VAL_1;
 	expectation->wr_only = false;
 
@@ -6578,14 +6579,14 @@ static void virt_x2apic_mode_wr_expectation(
 				       virt_int_delivery)) {
 		expectation->wr_behavior = X2APIC_ACCESS_VIRTUALIZED;
 		if (reg == APIC_SELF_IPI)
-			expectation->wr_exit_reason = VMX_APIC_WRITE;
+			expectation->wr_exit_reason = EXIT_REASON_APIC_WRITE;
 	} else if (!disable_x2apic &&
 		   get_x2apic_wr_val(reg, &expectation->wr_val)) {
 		expectation->wr_behavior = X2APIC_ACCESS_PASSED_THROUGH;
 		if (reg == APIC_EOI || reg == APIC_SELF_IPI)
 			expectation->wr_only = true;
 		if (reg == APIC_ICR)
-			expectation->wr_exit_reason = VMX_EXTINT;
+			expectation->wr_exit_reason = EXIT_REASON_EXTERNAL_INTERRUPT;
 	} else {
 		expectation->wr_behavior = X2APIC_ACCESS_TRIGGERS_GP;
 		/*
@@ -6928,9 +6929,8 @@ static void test_x2apic_rd(
 	/* Enter guest */
 	enter_guest();
 
-	if (exit_reason_want != VMX_VMCALL) {
+	if (exit_reason_want != EXIT_REASON_VMCALL)
 		report_fail("Oops, bad exit expectation: %u.", exit_reason_want);
-	}
 
 	skip_exit_vmcall();
 	report_prefix_pop();
@@ -6978,7 +6978,7 @@ static void test_x2apic_wr(
 	 * Validate the behavior and
 	 * pass a magic value back to the guest.
 	 */
-	if (exit_reason_want == VMX_EXTINT) {
+	if (exit_reason_want == EXIT_REASON_EXTERNAL_INTERRUPT) {
 		assert_exit_reason(exit_reason_want);
 
 		/* Clear the external interrupt. */
@@ -6987,7 +6987,7 @@ static void test_x2apic_wr(
 		       "Got pending interrupt after IRQ enabled.");
 
 		enter_guest();
-	} else if (exit_reason_want == VMX_APIC_WRITE) {
+	} else if (exit_reason_want == EXIT_REASON_APIC_WRITE) {
 		assert_exit_reason(exit_reason_want);
 		report(virtual_apic_page[apic_reg_index(reg)] == val,
 		       "got APIC write exit @ page offset 0x%03x; val is 0x%x, want 0x%lx",
@@ -6996,11 +6996,11 @@ static void test_x2apic_wr(
 
 		/* Reenter guest so it can consume/check rcx and exit again. */
 		enter_guest();
-	} else if (exit_reason_want != VMX_VMCALL) {
+	} else if (exit_reason_want != EXIT_REASON_VMCALL) {
 		report_fail("Oops, bad exit expectation: %u.", exit_reason_want);
 	}
 
-	assert_exit_reason(VMX_VMCALL);
+	assert_exit_reason(EXIT_REASON_VMCALL);
 	if (expectation->wr_behavior == X2APIC_ACCESS_VIRTUALIZED) {
 		u64 want = val;
 		u32 got = virtual_apic_page[apic_reg_index(reg)];
@@ -7180,7 +7180,7 @@ static void virt_x2apic_mode_test(void)
 	vmcs_write(CPU_EXEC_CTRL1, cpu_exec_ctrl1);
 	args->op = X2APIC_TERMINATE;
 	enter_guest();
-	assert_exit_reason(VMX_VMCALL);
+	assert_exit_reason(EXIT_REASON_VMCALL);
 }
 
 static void test_ctl_reg(const char *cr_name, u64 cr, u64 fixed0, u64 fixed1)
@@ -7663,7 +7663,7 @@ static void test_perf_global_ctrl(u32 nr, const char *name, u32 ctrl_nr,
 		val = 1ull << i;
 		vmcs_write(nr, val);
 		report_prefix_pushf("%s = 0x%lx", name, val);
-		test_pgc_vmlaunch(0, VMX_VMCALL, false, host);
+		test_pgc_vmlaunch(0, EXIT_REASON_VMCALL, false, host);
 		report_prefix_pop();
 	}
 	report_prefix_pop();
@@ -7678,7 +7678,7 @@ static void test_perf_global_ctrl(u32 nr, const char *name, u32 ctrl_nr,
 		vmcs_write(nr, val);
 		report_prefix_pushf("%s = 0x%lx", name, val);
 		if (valid_pgc(val)) {
-			test_pgc_vmlaunch(0, VMX_VMCALL, false, host);
+			test_pgc_vmlaunch(0, EXIT_REASON_VMCALL, false, host);
 		} else {
 			if (host)
 				test_pgc_vmlaunch(
@@ -7689,7 +7689,8 @@ static void test_perf_global_ctrl(u32 nr, const char *name, u32 ctrl_nr,
 			else
 				test_pgc_vmlaunch(
 					0,
-					VMX_ENTRY_FAILURE | VMX_FAIL_STATE,
+					VMX_ENTRY_FAILURE |
+					EXIT_REASON_INVALID_STATE,
 					true,
 					host);
 		}
@@ -8709,7 +8710,7 @@ static void vmx_pending_event_test_core(bool guest_hlt)
 
 	enter_guest();
 
-	assert_exit_reason(VMX_EXTINT);
+	assert_exit_reason(EXIT_REASON_EXTERNAL_INTERRUPT);
 	report(!vmx_pending_event_guest_run,
 	       "Guest did not run before host received IPI");
 
@@ -8756,7 +8757,7 @@ static void verify_nmi_window_exit(u64 rip)
 {
 	u32 exit_reason = vmcs_read(EXI_REASON);
 
-	report(exit_reason == VMX_NMI_WINDOW,
+	report(exit_reason == EXIT_REASON_NMI_WINDOW,
 	       "Exit reason (%d) is 'NMI window'", exit_reason);
 	report(vmcs_read(GUEST_RIP) == rip, "RIP (%#lx) is %#lx",
 	       vmcs_read(GUEST_RIP), rip);
@@ -8890,7 +8891,7 @@ static void verify_intr_window_exit(u64 rip)
 {
 	u32 exit_reason = vmcs_read(EXI_REASON);
 
-	report(exit_reason == VMX_INTR_WINDOW,
+	report(exit_reason == EXIT_REASON_INTERRUPT_WINDOW,
 	       "Exit reason (%d) is 'interrupt window'", exit_reason);
 	report(vmcs_read(GUEST_RIP) == rip, "RIP (%#lx) is %#lx",
 	       vmcs_read(GUEST_RIP), rip);
@@ -8920,7 +8921,7 @@ static void vmx_intr_window_test(void)
 	report_prefix_push("interrupt-window");
 	test_set_guest(vmx_intr_window_test_guest);
 	enter_guest();
-	assert_exit_reason(VMX_VMCALL);
+	assert_exit_reason(EXIT_REASON_VMCALL);
 	vmcall_addr = vmcs_read(GUEST_RIP);
 
 	/*
@@ -9126,9 +9127,9 @@ static void vmx_preemption_timer_zero_expect_preempt_at_rip(u64 expected_rip)
 	u32 reason = (u32)vmcs_read(EXI_REASON);
 	u64 guest_rip = vmcs_read(GUEST_RIP);
 
-	report(reason == VMX_PREEMPT && guest_rip == expected_rip,
+	report(reason == EXIT_REASON_PREEMPTION_TIMER && guest_rip == expected_rip,
 	       "Exit reason is 0x%x (expected 0x%x) and guest RIP is %lx (0x%lx expected).",
-	       reason, VMX_PREEMPT, guest_rip, expected_rip);
+	       reason, EXIT_REASON_PREEMPTION_TIMER, guest_rip, expected_rip);
 }
 
 /*
@@ -9191,8 +9192,9 @@ static void vmx_preemption_timer_zero_test(void)
 	vmx_set_test_stage(3);
 	vmx_preemption_timer_zero_set_pending_dbg(1 << DB_VECTOR);
 	reason = (u32)vmcs_read(EXI_REASON);
-	report(reason == VMX_EXC_NMI, "Exit reason is 0x%x (expected 0x%x)",
-	       reason, VMX_EXC_NMI);
+	report(reason == EXIT_REASON_EXCEPTION_NMI,
+	       "Exit reason is 0x%x (expected 0x%x)",
+	       reason, EXIT_REASON_EXCEPTION_NMI);
 
 	vmcs_clear_bits(PIN_CONTROLS, PIN_BASED_VMX_PREEMPTION_TIMER);
 	enter_guest();
@@ -9287,14 +9289,14 @@ static void vmx_preemption_timer_tf_test(void)
 	for (i = 0; i < 10000; i++) {
 		enter_guest();
 		reason = (u32)vmcs_read(EXI_REASON);
-		if (reason == VMX_PREEMPT)
+		if (reason == EXIT_REASON_PREEMPTION_TIMER)
 			continue;
-		TEST_ASSERT(reason == VMX_VMCALL);
+		TEST_ASSERT(reason == EXIT_REASON_VMCALL);
 		skip_exit_insn();
 		break;
 	}
 
-	report(reason == VMX_PREEMPT, "No single-step traps skipped");
+	report(reason == EXIT_REASON_PREEMPTION_TIMER, "No single-step traps skipped");
 
 	vmx_set_test_stage(2);
 	vmcs_clear_bits(PIN_CONTROLS, PIN_BASED_VMX_PREEMPTION_TIMER);
@@ -9369,7 +9371,7 @@ static void vmx_preemption_timer_expiry_test(void)
 
 	enter_guest();
 	reason = (u32)vmcs_read(EXI_REASON);
-	TEST_ASSERT(reason == VMX_PREEMPT);
+	TEST_ASSERT(reason == EXIT_REASON_PREEMPTION_TIMER);
 
 	tsc_deadline = ((vmx_preemption_timer_expiry_start >> misc.pt_bit) <<
 			misc.pt_bit) + (preemption_timer_value << misc.pt_bit);
@@ -9448,7 +9450,7 @@ static void check_db_exit(bool xfail_qual, bool xfail_dr6, bool xfail_pdbg,
 	const u32 expected_intr_info = INTR_INFO_VALID_MASK |
 		INTR_TYPE_HARD_EXCEPTION | DB_VECTOR;
 
-	report(reason == VMX_EXC_NMI && intr_info == expected_intr_info,
+	report(reason == EXIT_REASON_EXCEPTION_NMI && intr_info == expected_intr_info,
 	       "Expected #DB VM-exit");
 	report((u64)expected_rip == guest_rip, "Expected RIP %p (actual %lx)",
 	       expected_rip, guest_rip);
@@ -9640,7 +9642,9 @@ static void irq_79_handler_guest(isr_regs_t *regs)
 {
 	eoi();
 
-	/* L1 expects vmexit on VMX_VMCALL and not VMX_EOI_INDUCED */
+	/* L1 expects vmexit on EXIT_REASON_VMCALL
+	 * and not EXIT_REASON_EOI_INDUCED.
+	 */
 	vmcall();
 }
 
@@ -9685,9 +9689,10 @@ static void vmx_eoi_bitmap_ioapic_scan_test(void)
 
 	/*
 	 * Launch L2.
-	 * We expect the exit reason to be VMX_VMCALL (and not EOI INDUCED).
-	 * In case the reason isn't VMX_VMCALL, the assertion inside
-	 * skip_exit_vmcall() will fail.
+	 * We expect the exit reason to be EXIT_REASON_VMCALL
+	 * (and not EXIT_REASON_EOI_INDUCED). In case the reason isn't
+	 * EXIT_REASON_VMCALL, the assertion inside skip_exit_vmcall()
+	 * will fail.
 	 */
 	enter_guest();
 	skip_exit_vmcall();
@@ -9928,7 +9933,8 @@ static void init_signal_test_thread(void *data)
 
 	/*
 	 * Signal to BSP CPU that we continue as usual as INIT signal
-	 * should have been consumed by VMX_INIT exit from guest
+	 * should have been consumed by EXIT_REASON_INIT_SIGNAL exit from
+	 * guest
 	 */
 	vmx_set_test_stage(7);
 
@@ -10011,10 +10017,10 @@ static void vmx_init_signal_test(void)
 		report_fail("Pending INIT signal didn't result in VMX exit");
 		return;
 	}
-	report(init_signal_test_exit_reason == VMX_INIT,
-			"INIT signal during VMX non-root mode result in exit-reason %s (%lu)",
-			exit_reason_description(init_signal_test_exit_reason),
-			init_signal_test_exit_reason);
+	report(init_signal_test_exit_reason == EXIT_REASON_INIT_SIGNAL,
+	       "INIT signal during VMX non-root mode result in exit-reason %s (%lu)",
+	       exit_reason_description(init_signal_test_exit_reason),
+	       init_signal_test_exit_reason);
 
 	/* Run guest to completion */
 	make_vmcs_current(test_vmcs);
@@ -10027,7 +10033,7 @@ static void vmx_init_signal_test(void)
 	/* Wait reasonable amount of time for other CPU to exit VMX operation */
 	delay(INIT_SIGNAL_TEST_DELAY);
 	report(vmx_get_test_stage() == 7,
-	       "INIT signal consumed on VMX_INIT exit");
+	       "INIT signal consumed on EXIT_REASON_INIT_SIGNAL exit");
 	/* No point to continue if we failed at this point */
 	if (vmx_get_test_stage() != 7)
 		return;
@@ -10138,7 +10144,7 @@ static void sipi_test_ap_thread(void *data)
 	/* AP enter guest */
 	enter_guest();
 
-	if (vmcs_read(EXI_REASON) == VMX_SIPI) {
+	if (vmcs_read(EXI_REASON) == EXIT_REASON_SIPI_SIGNAL) {
 		report_pass("AP: Handle SIPI VMExit");
 		vmcs_write(GUEST_ACTV_STATE, ACTV_ACTIVE);
 		vmx_set_test_stage(2);
@@ -10151,7 +10157,7 @@ static void sipi_test_ap_thread(void *data)
 	/* AP enter guest */
 	enter_guest();
 
-	report(vmcs_read(EXI_REASON) != VMX_SIPI,
+	report(vmcs_read(EXI_REASON) != EXIT_REASON_SIPI_SIGNAL,
 		"AP: should no SIPI VMExit since activity is not in WAIT_SIPI state");
 
 	/* notify BSP that AP is already exit from non-root mode */
@@ -10290,7 +10296,7 @@ static void vmcs_shadow_test_access(u8 *bitmap[2], enum vmcs_access access)
 	vmcs_write(VMX_INST_ERROR, 0);
 	enter_guest();
 	c->reason = vmcs_read(EXI_REASON) & 0xffff;
-	if (c->reason != VMX_VMCALL) {
+	if (c->reason != EXIT_REASON_VMCALL) {
 		skip_exit_insn();
 		enter_guest();
 	}
@@ -10332,9 +10338,9 @@ static void vmcs_shadow_test_field(u8 *bitmap[2], u64 field)
 		set_bit(field, bitmap[ACCESS_VMWRITE]);
 	}
 	vmcs_shadow_test_access(bitmap, ACCESS_VMWRITE);
-	report(c->reason == VMX_VMWRITE, "not shadowed for VMWRITE");
+	report(c->reason == EXIT_REASON_VMWRITE, "not shadowed for VMWRITE");
 	vmcs_shadow_test_access(bitmap, ACCESS_VMREAD);
-	report(c->reason == VMX_VMREAD, "not shadowed for VMREAD");
+	report(c->reason == EXIT_REASON_VMREAD, "not shadowed for VMREAD");
 	report_prefix_pop();
 
 	if (field >> VMCS_FIELD_RESERVED_SHIFT)
@@ -10347,10 +10353,11 @@ static void vmcs_shadow_test_field(u8 *bitmap[2], u64 field)
 	if (good_shadow)
 		value = vmwrite_to_shadow(field, MAGIC_VAL_1 + field);
 	vmcs_shadow_test_access(bitmap, ACCESS_VMWRITE);
-	report(c->reason == VMX_VMWRITE, "not shadowed for VMWRITE");
+	report(c->reason == EXIT_REASON_VMWRITE, "not shadowed for VMWRITE");
 	vmcs_shadow_test_access(bitmap, ACCESS_VMREAD);
 	vmx_inst_error = vmcs_read(VMX_INST_ERROR);
-	report(c->reason == VMX_VMCALL, "shadowed for VMREAD (in %ld cycles)",
+	report(c->reason == EXIT_REASON_VMCALL,
+	       "shadowed for VMREAD (in %ld cycles)",
 	       c->time);
 	report(c->flags == flags[ACCESS_VMREAD],
 	       "ALU flags after VMREAD (%lx) are as expected (%lx)",
@@ -10373,7 +10380,7 @@ static void vmcs_shadow_test_field(u8 *bitmap[2], u64 field)
 		vmwrite_to_shadow(field, MAGIC_VAL_1 + field);
 	vmcs_shadow_test_access(bitmap, ACCESS_VMWRITE);
 	vmx_inst_error = vmcs_read(VMX_INST_ERROR);
-	report(c->reason == VMX_VMCALL,
+	report(c->reason == EXIT_REASON_VMCALL,
 		"shadowed for VMWRITE (in %ld cycles)",
 		c->time);
 	report(c->flags == flags[ACCESS_VMREAD],
@@ -10390,7 +10397,7 @@ static void vmcs_shadow_test_field(u8 *bitmap[2], u64 field)
 		       vmx_inst_error, VMXERR_UNSUPPORTED_VMCS_COMPONENT);
 	}
 	vmcs_shadow_test_access(bitmap, ACCESS_VMREAD);
-	report(c->reason == VMX_VMREAD, "not shadowed for VMREAD");
+	report(c->reason == EXIT_REASON_VMREAD, "not shadowed for VMREAD");
 	report_prefix_pop();
 
 	/* Permit shadowed VMREAD and VMWRITE. */
@@ -10401,7 +10408,7 @@ static void vmcs_shadow_test_field(u8 *bitmap[2], u64 field)
 		vmwrite_to_shadow(field, MAGIC_VAL_1 + field);
 	vmcs_shadow_test_access(bitmap, ACCESS_VMWRITE);
 	vmx_inst_error = vmcs_read(VMX_INST_ERROR);
-	report(c->reason == VMX_VMCALL,
+	report(c->reason == EXIT_REASON_VMCALL,
 		"shadowed for VMWRITE (in %ld cycles)",
 		c->time);
 	report(c->flags == flags[ACCESS_VMREAD],
@@ -10419,7 +10426,8 @@ static void vmcs_shadow_test_field(u8 *bitmap[2], u64 field)
 	}
 	vmcs_shadow_test_access(bitmap, ACCESS_VMREAD);
 	vmx_inst_error = vmcs_read(VMX_INST_ERROR);
-	report(c->reason == VMX_VMCALL, "shadowed for VMREAD (in %ld cycles)",
+	report(c->reason == EXIT_REASON_VMCALL,
+	       "shadowed for VMREAD (in %ld cycles)",
 	       c->time);
 	report(c->flags == flags[ACCESS_VMREAD],
 	       "ALU flags after VMREAD (%lx) are as expected (%lx)",
@@ -10645,7 +10653,8 @@ static int invalid_msr_exit_handler(union exit_reason exit_reason)
 static int invalid_msr_entry_failure(struct vmentry_result *result)
 {
 	report(result->exit_reason.failed_vmentry &&
-	       result->exit_reason.basic == VMX_FAIL_MSR, "Invalid MSR load");
+	       result->exit_reason.basic == EXIT_REASON_MSR_LOAD_FAIL,
+	       "Invalid MSR load");
 	return VMX_TEST_VMEXIT;
 }
 
@@ -10735,7 +10744,7 @@ static void atomic_switch_msrs_test(int count)
 
 	if (count <= max_allowed) {
 		enter_guest();
-		assert_exit_reason(VMX_VMCALL);
+		assert_exit_reason(EXIT_REASON_VMCALL);
 		skip_exit_vmcall();
 	} else {
 		u32 exit_qual;
@@ -10804,20 +10813,20 @@ static void __vmx_pf_exception_test(invalidate_tlb_t inv_fn, void *data,
 
 	enter_guest();
 
-	while (vmcs_read(EXI_REASON) != VMX_VMCALL) {
+	while (vmcs_read(EXI_REASON) != EXIT_REASON_VMCALL) {
 		switch (vmcs_read(EXI_REASON)) {
-		case VMX_RDMSR:
+		case EXIT_REASON_MSR_READ:
 			assert(regs.rcx == MSR_EFER);
 			efer = vmcs_read(GUEST_EFER);
 			regs.rdx = efer >> 32;
 			regs.rax = efer & 0xffffffff;
 			break;
-		case VMX_WRMSR:
+		case EXIT_REASON_MSR_WRITE:
 			assert(regs.rcx == MSR_EFER);
 			efer = regs.rdx << 32 | (regs.rax & 0xffffffff);
 			vmcs_write(GUEST_EFER, efer);
 			break;
-		case VMX_CPUID:
+		case EXIT_REASON_CPUID:
 			cpuid = (struct cpuid) {0, 0, 0, 0};
 			cpuid = raw_cpuid(regs.rax, regs.rcx);
 			regs.rax = cpuid.a;
@@ -10825,7 +10834,7 @@ static void __vmx_pf_exception_test(invalidate_tlb_t inv_fn, void *data,
 			regs.rcx = cpuid.c;
 			regs.rdx = cpuid.d;
 			break;
-		case VMX_INVLPG:
+		case EXIT_REASON_INVLPG:
 			inv_fn(data);
 			break;
 		default:
@@ -10838,7 +10847,7 @@ static void __vmx_pf_exception_test(invalidate_tlb_t inv_fn, void *data,
 		enter_guest();
 	}
 
-	assert_exit_reason(VMX_VMCALL);
+	assert_exit_reason(EXIT_REASON_VMCALL);
 }
 
 static void vmx_pf_exception_test(void)
@@ -10965,7 +10974,7 @@ static void handle_exception_in_l2(u8 vector)
 	vmx_exception_test_vector = vector;
 
 	enter_guest();
-	report(vmcs_read(EXI_REASON) == VMX_VMCALL,
+	report(vmcs_read(EXI_REASON) == EXIT_REASON_VMCALL,
 	       "%s handled by L2", exception_mnemonic(vector));
 
 	handle_exception(vector, old_handler);
@@ -10987,7 +10996,7 @@ static void handle_exception_in_l1(u32 vector)
 		intr_type = EVENT_TYPE_HWEXC;
 
 	intr_info = vmcs_read(EXI_INTR_INFO);
-	report((vmcs_read(EXI_REASON) == VMX_EXC_NMI) &&
+	report((vmcs_read(EXI_REASON) == EXIT_REASON_EXCEPTION_NMI) &&
 	       (intr_info & INTR_INFO_VALID_MASK) &&
 	       (intr_info & INTR_INFO_VECTOR_MASK) == vector &&
 	       ((intr_info & INTR_INFO_INTR_TYPE_MASK) >> INTR_INFO_INTR_TYPE_SHIFT) == intr_type,
@@ -11396,10 +11405,10 @@ static void test_basic_vid(u8 nr, u8 tpr, enum Vid_op op, u32 isr_exec_cnt_want,
 	if (eoi_exit_induced) {
 		u32 exit_cnt;
 
-		assert_exit_reason(VMX_EOI_INDUCED);
+		assert_exit_reason(EXIT_REASON_EOI_INDUCED);
 		for (exit_cnt = 1; exit_cnt < isr_exec_cnt_want; exit_cnt++) {
 			enter_guest();
-			assert_exit_reason(VMX_EOI_INDUCED);
+			assert_exit_reason(EXIT_REASON_EOI_INDUCED);
 		}
 		enter_guest();
 	}
@@ -11468,7 +11477,7 @@ static void vmx_basic_vid_test(void)
 	/* Terminate the guest */
 	args->op = VID_OP_TERMINATE;
 	enter_guest();
-	assert_exit_reason(VMX_VMCALL);
+	assert_exit_reason(EXIT_REASON_VMCALL);
 }
 
 static void test_eoi_virt(u8 nr, u8 lo_pri_nr, bool eoi_exit_induced)
@@ -11526,7 +11535,7 @@ static void vmx_eoi_virt_test(void)
 	/* Terminate the guest */
 	args->op = VID_OP_TERMINATE;
 	enter_guest();
-	assert_exit_reason(VMX_VMCALL);
+	assert_exit_reason(EXIT_REASON_VMCALL);
 }
 
 static void vmx_posted_interrupts_test(void)
-- 
2.43.0


