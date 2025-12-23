Return-Path: <kvm+bounces-66583-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id D14E5CD80DB
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 05:27:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id B345D30028B1
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 04:27:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62FE42E1F08;
	Tue, 23 Dec 2025 04:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="ZMzPy0Rq";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="GJp8llsN"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68C77283FC5;
	Tue, 23 Dec 2025 04:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766464033; cv=fail; b=jqgl/D6/HYF0IbKieLurP2amI8xPgqL+EDRdGm5fmF7BdRiwAiAzB1f4vTX7mTGyTeTo/7mCMokCF54tBMiTWgJ+JYpUjXhXNz/daEjyMz7mXQZyJc+qqOYld12+HAldJgzhSvTBkvsEtozMeCLyAopEJiJ+O/34IdYEB9GwI30=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766464033; c=relaxed/simple;
	bh=aO8zE7Jj3TzNXQyMUEAifhs2viHQ/91D7Cek1/uiUxk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=SxYfp0HbZPFUblm5CURARKp3pNHbDDzC4IUDMshZ2EDBHq/GgMHuW45LZ4baL/G1PFoChgyOARYEZy+/Htj/B71Vl8of/XaWG+/wLrRIbPw8MhvnWkcKul0R2O0lD/wJKxDfrnW0QO6ASlcmPAWwJhInnhdi1Xbk64pAeRjtlec=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=ZMzPy0Rq; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=GJp8llsN; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127839.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BN3G4OJ2849720;
	Mon, 22 Dec 2025 20:15:45 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=aO8zE7Jj3TzNXQyMUEAifhs2viHQ/91D7Cek1/uiU
	xk=; b=ZMzPy0RqfzUBmyOYDmaF4M0nyPoTqHhwoZgiIGjEiSv6GP8pyxDPBFDEC
	ToL13eZ5vJ/M/BMvVvv6H+WHG8C9lNvG0Ir2gh14fG6YFZJsNPk7Ujv3FWTfEeyY
	ueqbGi7ql93iEG0PzCvY6BiC+vSiAdLB8IyCKHMTkrszOC+gaAJrt8gcOu1bN0qO
	UuFiBXFoIRif1BOrGmfYXjFG23EAW4vCOo47Hd4bHOTa1LmIbQJJPkwdX2QiK481
	DEq0UQyyKtC79Z4ll9kDe0/KsbkjV+EgPYHbT1/9XhSDmk0Oa4LYybirt7pCgkYG
	aCqvjpE3p8kqihlzyK9i3AFrP1ESw==
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11023142.outbound.protection.outlook.com [40.107.201.142])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4b77f7hmfy-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 22 Dec 2025 20:15:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=x69gAJfwBNnle4sxzT81GETYMQxTjtO+BQbZvFVJTBYRIX51BTUazrewLGBC4QBidiAhynnmYH9qOZivk/TJWJ/IJXt7j0bA332SDl6ne77d63YZmffYb47P3sGkew0FM6f/8pjkb9iqPnrCyL2bCRwtgd0wnHctvnpDwnmTz48sx49cx8/PHrFDdgMPWDA6kEEEbg6JKpuGghQvJEG506YDYQcNeeRbLa8iCwrekK2BEvBmkoAclko+LOOPYbuIEzLhCTpKr3rNAcchbLYcsGAjZAykUDzbMQuXlKu9v1pGzVApwOVmz7fsysbLmLFQUXwNz+QKvf8HxYEGIVkXLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aO8zE7Jj3TzNXQyMUEAifhs2viHQ/91D7Cek1/uiUxk=;
 b=mA9rYCjo1tbQv72vdc676GR482toALTeVOr3h32+0q3DbEmDbI7wE/Ke6GLhd3F9hVbQjcBu8/3s7kSjCLDvch3TC5uI8bNUhPmYaYPeRo1WazM7GowO4A1WbQspSLrhlo2mCh41xKSf4cU0HNepAib2/Q2G2siIsLzzZwf/zq93UpIYEq+ZQ5LyzXh+KQaWrmDY3nzQSKrKvuWCPyW4+HC//j9jY9/Wqq1Srit36H2Fx1D9jcv5CxAvJJ6mZ1KGZvpATXEn9fVCzH3H9+TPrtJe5RUKh09JJV+sEClxKKpeV6vitNhcE0bmBaHq8eDEGODgYPPoBq6ySHUCpFRq9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aO8zE7Jj3TzNXQyMUEAifhs2viHQ/91D7Cek1/uiUxk=;
 b=GJp8llsNXSbK/WA3LOd2gl8b1wMzhaneL2JvpsVMEgyRC9XQq0BifCTIVn1cjckMrKsQC6JA0SQFlcK8dyWNSMiDvLFru/JY61L2f8z2EGqxf0DetMYxfVX7YhCwRuJ6MRn1cXUo2dzEPYOayyMLvMdhhOskmqR21ooSOaTpohkRVudHy9v1jHFgRC/1sJH3ngSBvzPjqsNPN0mEr2Pt5B8uVYRmV1bCAdsxhC/5qLI4trAnm/QKlChDraG3X2G4cocrUOLKq6CqsVgbJmQKpcwEi3EX6NgN4gM7wpOx565Toh6ynzUe1NEh6dPAv3u7XcNEnc0yyThEcijhj6ejJg==
Received: from LV0PR02MB11133.namprd02.prod.outlook.com
 (2603:10b6:408:333::18) by SA1PR02MB8512.namprd02.prod.outlook.com
 (2603:10b6:806:1fb::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.11; Tue, 23 Dec
 2025 04:15:43 +0000
Received: from LV0PR02MB11133.namprd02.prod.outlook.com
 ([fe80::10e5:8031:1b1b:b2dc]) by LV0PR02MB11133.namprd02.prod.outlook.com
 ([fe80::10e5:8031:1b1b:b2dc%4]) with mapi id 15.20.9434.009; Tue, 23 Dec 2025
 04:15:43 +0000
From: Jon Kohler <jon@nutanix.com>
To: Sean Christopherson <seanjc@google.com>
CC: "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de"
	<tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de"
	<bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 10/18] KVM: VMX: Extend EPT Violation protection bits
Thread-Topic: [RFC PATCH 10/18] KVM: VMX: Extend EPT Violation protection bits
Thread-Index: AQHblFP1maqqLtVwJ0mPkDFh05SIPbPPsQ+AgWCr1wA=
Date: Tue, 23 Dec 2025 04:15:43 +0000
Message-ID: <8B9EBE3E-0EA0-4EAA-A0B6-731F08A172DE@nutanix.com>
References: <20250313203702.575156-1-jon@nutanix.com>
 <20250313203702.575156-11-jon@nutanix.com> <aCI_0WqSzrgtz6IW@google.com>
In-Reply-To: <aCI_0WqSzrgtz6IW@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3864.300.41.1.7)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV0PR02MB11133:EE_|SA1PR02MB8512:EE_
x-ms-office365-filtering-correlation-id: 8a3fee4c-ee7a-4cc9-a359-08de41d9f096
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|7416014|376014|10070799003|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?T21QeVJjZG03Q1o1TEJtdEdjWksveWhpRDI3cUF2K1BkYUZmUWRsRmZjVUpv?=
 =?utf-8?B?clZ1c2pUcEsvenNmcE9FQXZHL1ZrZGxqQkhBa0d3Y1IyZWROaXd1bEFyMW9h?=
 =?utf-8?B?NTdsTWQySWVXbEVweWplS0ZVQ2tJZEpWb3lmZkZBTHVWVHc1ZFFxMDVEZ243?=
 =?utf-8?B?REN6Nkg4bjUxZDU3S2dSd1pLMmdueGM5QXB0NFRCeWxMNzY1bnVJbGlZUlVw?=
 =?utf-8?B?aXZqV3Q0UnNuVUttZ0tRVEkrV2JBOHBPZjF4YldIQ29UMFo2UklveTBRUUh3?=
 =?utf-8?B?UDdlNVJXSXppb0NtSTl4L1kvWWNka1lLZG1BZ0VCUWR3UjRIczhZallaeEJU?=
 =?utf-8?B?UjVhMCtFM2JvbkNsUWdHZFJod3lTL0NDSFk3UG9BOEVuaUU2N1RQQTJPcVVp?=
 =?utf-8?B?S1FqSGRSYnNRekE3dDFLWXBmaEdJR3licUs4ZGJ3YWQzNHdFMDVHNzFwSXBF?=
 =?utf-8?B?dVhRUlVBZ3FOeXlOQmcxZzFqWjN6c243dDFYU1BxM1UxQThhN0RrcDAwbUEx?=
 =?utf-8?B?MktJbG5DSFVkS3pBYTBrV3F0Nk1hWjVwTW1TNCsvb0tJeFZaUmJ3SzI4NHlH?=
 =?utf-8?B?NWhTVlR2WVlWSldCWDg4c0I3VjhoQVlYUGlMcDV4NFErYkVxaDl1OWtiZWpV?=
 =?utf-8?B?L1NoM0hkU3VzVFphMkh0U2xGOFNnM0JlTWtYRUtOV1h4QnpsODczRkxNZktC?=
 =?utf-8?B?L21KU1M3Q090N2FpS2djR0VvWTZRSlBEZTZJZ2NpWEVSRm1iWENOK0U2WVBO?=
 =?utf-8?B?bVpFQm9Zb3FOTUkrTWpwZ2VOQUEvTEE2UFcrYXdTNDh2SUoxVUZCdWYvNUZK?=
 =?utf-8?B?YmJZTXE1QWQrZnZhQ2xOeHZuZ1ZTUXZpVWxweWp6OG54VW1UK0lDcFVBWE1j?=
 =?utf-8?B?MWc5YjRvUHVSMFM3TUROZGZDdGR3VFI5RWJWZVluK1psZUh5ZHVpNFBIcVhv?=
 =?utf-8?B?QjZrb0N2S1JHT0F3TysvL3ZwK0ZtWXB1eFFhYmNYclpYMkNkN0FUWVlKdzRy?=
 =?utf-8?B?UTBJdXlFVVhRNHJ6NGY5UkRFNnIwRkFaaUF5M3cybUJqV1ZPZVZ5WS8rb1FY?=
 =?utf-8?B?R2sxM3NmbVA0enVpZnpPTFpuYkc3TnBFZ2EvVU1wRDk4SkxmeURSYjQrT1RN?=
 =?utf-8?B?QnkvWDlMa3p0RkV5aVUxaWZIc0J2em5xNjg3ZlNHazhTeUJJRFZBUTdPdHZP?=
 =?utf-8?B?YXE5TjE1SDdMWFhabXN2RHlRWEdqQ21zVzgwcUFmbWhZMGRlcEtMcEx6YTNN?=
 =?utf-8?B?QjNsMjlLamQvcmlqMCtZTDQ5VHl1MEJsY2FFUW5hRExudTlBSHZxYXA3bGNC?=
 =?utf-8?B?bEZlMXo4QnMwNFNCUnlDV2REdEZKU3hPTytPdHA1MWZwUmEwZWI4VVpUMGs0?=
 =?utf-8?B?VlBPaDVFL2xhQ01nblhyVFYvSEl4ekp4ZGpxOWE2N2xTRm1lb000ZlJaQ21L?=
 =?utf-8?B?enpjbDB2dDQ5T1hFVlRML3RlbEJYZEFuZ2pQN0lmc2Y0Sk9FUHo4RzhSTDg4?=
 =?utf-8?B?c3Y4SHNnWUtLRm9xSXJSMHhseTJMVkljbDdWVU1TMGVCcXdLZ0VuVkdCcFF4?=
 =?utf-8?B?T1NvemUvcXpEU2F5ZnNiVURVOWR2UXQ5YjVxY0VEUS9BalhMOE1DNEZiR2k2?=
 =?utf-8?B?SE8wV2NQR0RVZnY5MTNmbnpWTUFMZyt0VHZmbVZ2Y1pybEZkWHhuK0ZuQ0JS?=
 =?utf-8?B?eUg1Ujl2QXplNzZBd00rNFhFVmJ4T2lXZFk5VDRxdW9EQnppNlF4TDlOVWxV?=
 =?utf-8?B?Ukt0SkExb3N1QTVQdjUrNmhGM2hpN3JZcFFBaEVJU1NpT21MaVRnMWc4eXFU?=
 =?utf-8?B?eHk2bWgvN2tMQXVzT2ExcjNQeWV1bHN0L3pjUDhxTHd4cHczVnhuaXhUeUNr?=
 =?utf-8?B?TGhlcVoyR1ZCUHFlRjk4UVpHQkpidDdUWWdMZzFFQ0dzMjJOM1FINGI3RDU1?=
 =?utf-8?B?c2V5M3lyVTRDb2JCQkdjZUI5SUd2M0hrQll5dUhRVExtdVgyNmtoWU1zVjlh?=
 =?utf-8?B?eEdZbE1wWUc1TnU0VnFURWhCSGlaOUxWOXYydUFLbnh0Q3FLSWNDMS9wNHdK?=
 =?utf-8?Q?sUs9b6?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV0PR02MB11133.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(10070799003)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?NDRIYURKUGdmUEl6SDdaeVpWNEFLR1RySTZybVdDNEJrUHppUzNlNFFYcjZX?=
 =?utf-8?B?citha1RDbFdwMU51UkZxZ0lQZVVJQ01WRTBYRkgzMFcxb3pBb0d3UFlYa3Bo?=
 =?utf-8?B?U1dEYmJ6QzRzQWFZRmk2eVppVlp5RDNpOFFaM0toenBIWThRb3l5VndxMXpU?=
 =?utf-8?B?MWFyTS9Ic0htT2x3WEpvaXFVVW43RHp3eVlUcWErVmZFRUtIOGZqTlMrUU9z?=
 =?utf-8?B?N3hXQ2VvQk8yNkZQQXRTbzdOWDIvK0tCLzAweFU1NS9kZ3dEVDFxMDA2ajly?=
 =?utf-8?B?NFVJS3hMbGZBOHZiQW5pU0ZPd05tUVFCdVBnUUFWU3BabTFkeGVrSmR1cHFy?=
 =?utf-8?B?TmtVK2FJOHQzdHdZV3h2N1R4dWtEeTI5MEtJR1hnSWF6V1l3OUhyb3N6eVZ3?=
 =?utf-8?B?bnpuMlZZR3o2Q0JoaGVnSDZCQmtFQ2VNMStjdTRlZjN3NkRZY3BlVTNPUFRo?=
 =?utf-8?B?TUlsdW1UNjBDM29MTlR4Tkt4dmtWNDdVdUpLQWpqSVFobHhVZCt6cnFYd3cw?=
 =?utf-8?B?QkRlMW5SenBmQzA1Wm1qRWFuL0hkU2Juak12a0MxZWtwWDF4YUEzSkc4dVBY?=
 =?utf-8?B?amhuS0NVWWIrNGtFWjlvamVLd3RrTkMyc1JOUnJzZStYZ3p1K1lLYWluY2U0?=
 =?utf-8?B?Nkk2Vm1WTTZ3U0l2VEZGU2xWRzhGL09LWkU2ZTJLS05DQlI4Nk5SZWlaYVQv?=
 =?utf-8?B?RGVyTUdnR1BiSVU2dlJSZnU0c1RFU2RlbHdRRmlLMkhuUGtPdjMrdHlMa1pX?=
 =?utf-8?B?UGEvY3RzZXJ3S0tzbHJOMVg5NjdTWkVzcHVDMEN4azV6N2FvQjl5cVZSdUx4?=
 =?utf-8?B?SG9wN2tVcUZ2NC9OQXFPbGFIREErbnZMZUtLODVETDgyQ3g4aFBsV2d6djZk?=
 =?utf-8?B?bWZYMGlSdTA0VWVFcWM3YmR0SzlPWGV1UkN2VkVVa1ZTemI5dy8wM1dCNGZn?=
 =?utf-8?B?dWUzVG1oTDBMZjBncWw2V2RXUkZxTGxiUE9TYmFNKzAvaDR4MUZtNXBvTHJE?=
 =?utf-8?B?YUVKWjU3QU56NWtUQzd3dWZ4TlBxQ0FGSTZZaVUzMjJTSU4rUGlHaFdFSk9u?=
 =?utf-8?B?ZWtXT2xWU0RkeDdsZzNHV1QxS01NNHhrc1AwTU9yYnRPbWh1a201Q1VxYWlV?=
 =?utf-8?B?bHFxWXZBM0YzQmxoQUpxQUxtekM5MHF2UkdzQ2p6SSs2dlVpZ3EzNTA0eEt0?=
 =?utf-8?B?WXdIVUZ3TExLUTF5MHlHNmhHSm0xaDUxVml6cUVnNGYvdXQ3SmhibFlYRzJy?=
 =?utf-8?B?NjExdFJCVzVINjdobk82UFB4VWRZZzI4c09XSm03L3JLQzV6ZnY5TUpDZ3FH?=
 =?utf-8?B?aE1jcmtHTUd1RFd1aHFYUjI2a1NaN3pyUG1panAzVTlES2pvOVIvMm1BdVVL?=
 =?utf-8?B?Q05yNWkySVgvTW5mV1phc25ZNWRSMWpCK3VtOW04d0Nqak9pQXhvSE9HcE1o?=
 =?utf-8?B?YTFiclBLQzhISHQ2clhNbVRVU2grb1JDTzdZclpUNFZaVDRWZ3piamVOd1F1?=
 =?utf-8?B?dGl2Rk5xTGswZWl2c1VXOEdBbEJDeWtUa0RuQVpOUHBMYUdQRElXZ3pVOWRB?=
 =?utf-8?B?Wml5YW5BalR1dlZ5eHArajdFODVuRDBGYkpJRzFvWFZuc1pRMzhyZWVKQlZQ?=
 =?utf-8?B?RUo2NTFEcDhqRmJNVlg2NFk2K29NcW9Ob0NzREwvS25WWkpWYXAyb3YyVjRy?=
 =?utf-8?B?dFdIMmlKNlJXS1dlMFcvNFY3YkJrWGloUnQ5SU55ZE5zZXA2QkFSQUJxa3dZ?=
 =?utf-8?B?MWdVejN1OUdPUlBVcXpvVm5PcnN0MnZnU3JoREJwaGVwbnVNNFU3ZUFrd1ND?=
 =?utf-8?B?Zm93VXIyMmxJcjhEZmRoRVVITUtHNVR0elJOL3Y2VlpTY3NrYWNsTDNUTGoz?=
 =?utf-8?B?TmlMaXUxRVoyTzNvaGhHYVZLbnpxMmhLYVl3MDBwcVphQm15QmRjaEs4bFo2?=
 =?utf-8?B?Nkd3RmpDQURMZ29tSEFENmJaeWY5QjNlL09kZHdVN205NWhNR2NqbkNHaGti?=
 =?utf-8?B?U2xCUGlIUnF0RmhaSUR1WGdQWWFralBaK25TVWEvZmJzSXpmMG5qYmU4bnpW?=
 =?utf-8?B?TDVrcjIvcjVHcDg5d0hCQ2lacjcwMkpzQ2xzRStwMHdEYUpoVnY5cXVQdFJu?=
 =?utf-8?B?aHhuZFBzOE0wSFdiRENNdFpIUzdBRGhSTHBhRnpZVlltVVh2L3Y0alRFRDMy?=
 =?utf-8?B?bzMzRmJ5aGFWblF2cWo5LzNwSnNWcWxiTGE3M0grdXJvY3k0dlFxVjdqaXFt?=
 =?utf-8?B?Qy9tNDVEWEI1Rk5MOFQ1Mkx6dU1DbTJVQTF4cEpFWlJCTDZXV0hlamRLMlF4?=
 =?utf-8?B?Z2g2bFJpV3EzL2NuL09OQ2FzUzUyWWNXUUh0am5BZDYwTS9veFJCcXZIY2dl?=
 =?utf-8?Q?Y3r/ce5tuOd1nnlmeF1ZF13ylo2XTx92uGlwn1U0u4U/J?=
x-ms-exchange-antispam-messagedata-1: Vkyn0BfxPVs5U1R3BwNEduzIdpxGktTlNAU=
Content-Type: text/plain; charset="utf-8"
Content-ID: <71E410BA36CFAF4E87DCE72EDE7B7B6A@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV0PR02MB11133.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a3fee4c-ee7a-4cc9-a359-08de41d9f096
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Dec 2025 04:15:43.3064
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0+Fqsn/XrxjxQNWoy83UMZoxM9mm6T+rg87HQvmY1w6m82Ta8mtBO6TGPB5y46fDS2iSPS/2xUaVvoZfxm4Vyg1Xt3ekvMEjHuScHqgkjn4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR02MB8512
X-Authority-Analysis: v=2.4 cv=Jtv8bc4C c=1 sm=1 tr=0 ts=694a1771 cx=c_pps
 a=nzP3m+/CqRdBhj8fzGTHBQ==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=wP3pNCr1ah4A:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=1XWaLZrsAAAA:8 a=64Cc0HZtAAAA:8 a=pE-IvA_VBSsmqSND6sgA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjIzMDAzMyBTYWx0ZWRfX4mMFVvuPtRL8
 t42We5L7fYt8FK7A3q0EYW7sUk6MyXLD9Xi5VdTAIpmVlw3/fWDtghiXnjpRicsLKM+/huANaSI
 HOpt/QcbJiKBp1X8cq/ciGHWw3J9lkkfVKni1ZZbalP7dkUcHOqRzuZ7TwZYInfcj/DqVMZcK+6
 zA5AsE9LavA3OK3iF7P9lSaXkH0HpcfZU6iOrBumbuM8/wcwt5q6Jz2MbkhItxKbP0LOVny7KpU
 I5NvlXUQzwL1ghRRrOIJ6hc4n6UG0qqYgxSAx/ao5epmKTFd1HW4GpeljDDC/5nEZ5tCjbVLSyA
 5P5TDbUnNSAsyQfq9dqjpnTiXntuXNa85KbBpuXGdryf4lwI6n8cp9BkCi1g/40G+aZs8YF96Yw
 TN0krUeEuEn8bw6sfCS18bsdonMRzT1kO1ufD/pYTNT7wX3B8yk0pZZajKNoBr2bSYuurUpR7U1
 DGhz3PeMxxJzFsW3FKw==
X-Proofpoint-ORIG-GUID: 0GPklAgK9HOrgAIcFZeAM4h8Fz523CLE
X-Proofpoint-GUID: 0GPklAgK9HOrgAIcFZeAM4h8Fz523CLE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-23_01,2025-12-22_01,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gTWF5IDEyLCAyMDI1LCBhdCAyOjM34oCvUE0sIFNlYW4gQ2hyaXN0b3BoZXJzb24g
PHNlYW5qY0Bnb29nbGUuY29tPiB3cm90ZToNCj4gDQo+IE9uIFRodSwgTWFyIDEzLCAyMDI1LCBK
b24gS29obGVyIHdyb3RlOg0KPj4gRGVmaW5lIG1hY3JvcyBmb3IgUkVBRCwgV1JJVEUsIEVYRUMg
cHJvdGVjdGlvbiBiaXRzLCB0byBiZSB1c2VkIGJ5DQo+PiBNQkVDLWVuYWJsZWQgc3lzdGVtcy4N
Cj4+IA0KPj4gTm8gZnVuY3Rpb25hbCBjaGFuZ2UgaW50ZW5kZWQuDQo+PiANCj4+IFNpZ25lZC1v
ZmYtYnk6IEpvbiBLb2hsZXIgPGpvbkBudXRhbml4LmNvbT4NCj4+IA0KPj4gLS0tDQo+PiBhcmNo
L3g4Ni9pbmNsdWRlL2FzbS92bXguaCB8IDkgKysrKysrKysrDQo+PiAxIGZpbGUgY2hhbmdlZCwg
OSBpbnNlcnRpb25zKCspDQo+PiANCj4+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9pbmNsdWRlL2Fz
bS92bXguaCBiL2FyY2gveDg2L2luY2x1ZGUvYXNtL3ZteC5oDQo+PiBpbmRleCBkN2FiMGFkNjNi
ZTYuLmZmYzkwZDY3MmI1ZCAxMDA2NDQNCj4+IC0tLSBhL2FyY2gveDg2L2luY2x1ZGUvYXNtL3Zt
eC5oDQo+PiArKysgYi9hcmNoL3g4Ni9pbmNsdWRlL2FzbS92bXguaA0KPj4gQEAgLTU5Myw4ICs1
OTMsMTcgQEAgZW51bSB2bV9lbnRyeV9mYWlsdXJlX2NvZGUgew0KPj4gI2RlZmluZSBFUFRfVklP
TEFUSU9OX0dWQV9JU19WQUxJRCBCSVQoNykNCj4+ICNkZWZpbmUgRVBUX1ZJT0xBVElPTl9HVkFf
VFJBTlNMQVRFRCBCSVQoOCkNCj4+IA0KPj4gKyNkZWZpbmUgRVBUX1ZJT0xBVElPTl9SRUFEX1RP
X1BST1QoX19lcHRlKSAoKChfX2VwdGUpICYgVk1YX0VQVF9SRUFEQUJMRV9NQVNLKSA8PCAzKQ0K
Pj4gKyNkZWZpbmUgRVBUX1ZJT0xBVElPTl9XUklURV9UT19QUk9UKF9fZXB0ZSkgKCgoX19lcHRl
KSAmIFZNWF9FUFRfV1JJVEFCTEVfTUFTSykgPDwgMykNCj4+ICsjZGVmaW5lIEVQVF9WSU9MQVRJ
T05fRVhFQ19UT19QUk9UKF9fZXB0ZSkgKCgoX19lcHRlKSAmIFZNWF9FUFRfRVhFQ1VUQUJMRV9N
QVNLKSA8PCAzKQ0KPj4gI2RlZmluZSBFUFRfVklPTEFUSU9OX1JXWF9UT19QUk9UKF9fZXB0ZSkg
KCgoX19lcHRlKSAmIFZNWF9FUFRfUldYX01BU0spIDw8IDMpDQo+PiANCj4+ICtzdGF0aWNfYXNz
ZXJ0KEVQVF9WSU9MQVRJT05fUkVBRF9UT19QUk9UKFZNWF9FUFRfUkVBREFCTEVfTUFTSykgPT0N
Cj4+ICsgICAgICAoRVBUX1ZJT0xBVElPTl9QUk9UX1JFQUQpKTsNCj4+ICtzdGF0aWNfYXNzZXJ0
KEVQVF9WSU9MQVRJT05fV1JJVEVfVE9fUFJPVChWTVhfRVBUX1dSSVRBQkxFX01BU0spID09DQo+
PiArICAgICAgKEVQVF9WSU9MQVRJT05fUFJPVF9XUklURSkpOw0KPj4gK3N0YXRpY19hc3NlcnQo
RVBUX1ZJT0xBVElPTl9FWEVDX1RPX1BST1QoVk1YX0VQVF9FWEVDVVRBQkxFX01BU0spID09DQo+
PiArICAgICAgKEVQVF9WSU9MQVRJT05fUFJPVF9FWEVDKSk7DQo+IA0KPiBBZ2FpbiwgYXMgYSBn
ZW5lcmFsIHJ1bGUsIGludHJvZHVjZSBtYWNyb3MgYW5kIGhlbHBlcnMgZnVuY3Rpb25zIHdoZW4g
dGhleSBhcmUNCj4gZmlyc3QgdXNlZCwgbm90IGFzIHRpbnkgcHJlcCBwYXRjaGVzLiAgVGhlcmUg
YXJlIGV4Y2VwdGlvbnMgdG8gdGhhdCBydWxlLCBlLmcuIHRvDQo+IGF2b2lkIGN5Y2xpY2FsIGRl
cGVuZGVuY2llcyBvciB0byBpc29sYXRlIGFyY2gvdmVuZG9yIGNoYW5nZXMsIGJ1dCBrbm93IG9m
IHRob3NlDQo+IGV4Y2VwdGlvbnMgYXBwbHkgaW4gdGhpcyBzZXJpZXMuDQo+IA0KPiBQYXRjaGVz
IGxpa2UgdGhpcyBhcmUgZWZmZWN0aXZlbHkgaW1wb3NzaWJsZSB0byByZXZpZXcgZnJvbSBhIGRl
c2lnbi9pbnRlbnQNCj4gcGVyc3BlY3RpdmUsIGJlY2F1c2Ugd2l0aG91dCBwZWVraW5nIGF0IHRo
ZSB1c2FnZSB0aGF0IGNvbWVzIGFsb25nIGxhdGVyLCB0aGVyZSdzDQo+IG5vIHdheSB0byBkZXRl
cm1pbmUgd2hldGhlciBvciBub3QgaXQgbWFrZXMgc2Vuc2UgdG8gYWRkIHRoZXNlIG1hY3Jvcy4N
Cj4gDQo+IEFuZCBsb29raW5nIGFoZWFkLCBJIGRvbid0IHNlZSBhbnkgcmVhc29uIHRvIHNsaWNl
IG4nIGRpY2UgdGhlIFJXWD0+cHJvdCBtYWNyby4NCj4gDQo+IFRMO0RSOiBkcm9wIHRoaXMgcGF0
Y2guDQoNClNvbGQhIERyb3BwZWQgdGhpcyBvbmUgYW5kIGNsZWFuZWQgaXQgYWxsIHVwIGZvciB2
MQ0KDQo=

