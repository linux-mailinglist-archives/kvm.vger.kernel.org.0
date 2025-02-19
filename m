Return-Path: <kvm+bounces-38578-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 29775A3C2FE
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 16:05:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 894D5189B1D6
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 15:04:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F0551F3FEC;
	Wed, 19 Feb 2025 15:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="ZS296iLe";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="TuwIxTtk"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B5FC1F3BB4;
	Wed, 19 Feb 2025 15:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739977472; cv=fail; b=QVKEtv3dLRGfY8vp7kkGt74wNzP8wSFdx+76RmZTOBkSp55pNvZmh+VUDuOj8QtzeqyCJrISXASHHMqEmsnGmTIWE4T14Sk3AyO0hZJzBaJK+hcvWZYxf1vEib+R2VYIyty2iWIr+UFVAWfosTqi3S+tJvK+wd+vErYsV0w2ye0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739977472; c=relaxed/simple;
	bh=IhDQrCuVl9j7RuDeo9UOgNtbI1M17To/K5VZrwKP9qc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=bVf9msL65SWscXvlyPVooY+HyWrEgNQv/2d2fMczIC98G4GLbLwNrU+dKC4VPNmRQQRDgn5WB3LCZB9Ai5ZlBdV4Aua3pzK7XuMOsOaYWZEPUelLGiILV1ptV8vC7tsPs4KP/N7kzYJtfYAyt9Ia+fI1ikLzISBejT9kr5KXti4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=ZS296iLe; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=TuwIxTtk; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127843.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51JBFBNQ000941;
	Wed, 19 Feb 2025 07:03:41 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=IhDQrCuVl9j7RuDeo9UOgNtbI1M17To/K5VZrwKP9
	qc=; b=ZS296iLeSaB0XteuryO5jXvkp6LQM1kRUffEWoKTBHBUzTM8VN+o+W2UR
	zA8i3CCNxgniybjBD8zX+zei6x0VOLnw1F1j3twhokuHNk42k8rUQUp09tDW4pyR
	gQt3ks/i6A/sIoLqY3nWzVJOHsdVKqW+p1XR0+lBbd0emrotbN8hbOG4hXXnYGcZ
	e8gcUQm2rGrT1MsaDbsFZKU6xB4MTGEInVc7UGa5TD9TJldy6JRP2oip72YnRGgf
	y7JVvr62G5ysOXJUto4OVztQ/NtD3OB42t7WZ0kWv7aKaoauw37KSxr6lnh9d1gW
	hLXUGZs1B1/z7tSnLtqqgb94OP0Fw==
Received: from bl0pr05cu006.outbound.protection.outlook.com (mail-BL0PR05CU006.outbound1701.protection.outlook.com [40.93.2.9])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 44w4b9t0sg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 19 Feb 2025 07:03:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=G3MmutR7RDrNs9AF8nwH7Amk6/ua0yiBpt2TlGIRRIA0CWuju1RrA60pLATOWvRe69f6Jkfxbyiwj2CbiHC80hhTskTSxbe3nnSKNUswcdiyUEoi1LepxUNYzm9AtFrotpnamDTPr0UlsvsVJoW0uw7U+/85RhmPcNje9uSiE4W4l4BFWwNkjEQmdbOMqsviFdbNk437EkW8Wm6PQ7WirgQxh2//Pu69sqeHAo0XYZqz3gUtylcssULeUkKgMWK/GDjTSzFEMg2cULtuDuogfKgwc8AzgUz3u3wABY7X91n8t7gS6o6b729KtqkHqVXT8ixinONL+yUHqOl02vf82g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IhDQrCuVl9j7RuDeo9UOgNtbI1M17To/K5VZrwKP9qc=;
 b=aUWbHkXwQpIr/TRibrJhksmePe1wZN/0FXUG/X47zKmt4eIhG8loYojK1ltjVb4gUcK5td2SKyGc+FQRMWBQkllS/KkaLH5eFd9GQbi3pFKmvnVIrG47DjRiZdqyDbg79CbG22MdzNe1zePOrWOgf0yVSByCUo73277GreLOWFsXISA2EzMb23vcvbo5p4u7Z3XmJn3MLCGvp1JL6b+6H/gWDwQpjCJxcZCqQqM9vVqF9ZC0sIKPJo6IY5CLsc7iZmqtwxOz4R2VuVAuIKWvxwe9pBt4RBK23HXxa5ZDHdcwhQ5YLTV6scjr9dfr0XjyaE7jnTCcBQhsBdy7fUtI6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IhDQrCuVl9j7RuDeo9UOgNtbI1M17To/K5VZrwKP9qc=;
 b=TuwIxTtk6Fz0Wq/FQZo/tAgSfhCvmIC1bBumF8PjuTkNMYXmphetQ1UiP3Qg6sTDDdDk0i5MgDVDcV1MelARM8IFjY7Gkligt2QiazSdkeV0AR5SNy3YDxqduH/y7wUVdG+f9QtqZAdAbsxi4CD7kP8sVEtfZFPZ4qPS62N43XMPlprpNPCjtfSgpxBHgh7TvcwkwONZxEK9Dq9SQyfymj1po7+wiuYAdl7fsWrI0GrXGrJY5irblnA9noYBpb/OVdXziYuRMtzMJG4P0AsSwdxEIImhK4sd7PG3y9KHrWz4CLgDoQIV7zN/qtnezChOarDb9H3KpoDYtjzbwaURWQ==
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10) by IA0PR02MB9777.namprd02.prod.outlook.com
 (2603:10b6:208:48d::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.19; Wed, 19 Feb
 2025 15:03:39 +0000
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054]) by LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054%3]) with mapi id 15.20.8445.017; Wed, 19 Feb 2025
 15:03:39 +0000
From: Jon Kohler <jon@nutanix.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>,
        Eiichi Tsukata
	<eiichi.tsukata@nutanix.com>,
        "chao.gao@intel.com" <chao.gao@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com"
	<mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "x86@kernel.org"
	<x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "vkuznets@redhat.com"
	<vkuznets@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] KVM: x86: hyper-v: Inhibit APICv with VP Assist on
 SPR/EMR
Thread-Topic: [RFC PATCH] KVM: x86: hyper-v: Inhibit APICv with VP Assist on
 SPR/EMR
Thread-Index: AQHa58K/KxruaTnPP0WJ1QBPubwxnLIaZL+AgAAFGYCAAVzcAIE0J90A
Date: Wed, 19 Feb 2025 15:03:39 +0000
Message-ID: <028DBF5C-FB12-415C-B128-3EF275CF2A8C@nutanix.com>
References: <20240806053701.138337-1-eiichi.tsukata@nutanix.com>
 <ZrJJPwX-1YjichNB@google.com>
 <CABgObfZQsCVYO5v47p=X0CoHQCYnAfgpyYR=3PTwv7BWhdm5vw@mail.gmail.com>
 <ZrNyKqjSiAhJGwIW@google.com>
In-Reply-To: <ZrNyKqjSiAhJGwIW@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3826.400.131.1.6)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV8PR02MB10287:EE_|IA0PR02MB9777:EE_
x-ms-office365-filtering-correlation-id: 5f5691de-a539-4875-55d7-08dd50f697db
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|10070799003|376014|7416014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?aERhTTJQTlQyZ3RaODlwYUFLSXp0Sm5SVjFheXdWWkJEYWMybXg4Z1BCRWJO?=
 =?utf-8?B?RGlLNnBON1ZaRWJTeE9rL2dNTHNKV0lVV2V0dFJYM2dIV0lsVUlCRm5jT0tr?=
 =?utf-8?B?UTZxeUtJLzM1cE01eHQwRnpLb3l0dUZRTFEyYUIrRU1qQzRRR21yemgwaXFP?=
 =?utf-8?B?bU12RXBhREJJQTlDYzEwbG5oOHA4SitYWFFSbzFjWGdCek85am1DNEZkT1dU?=
 =?utf-8?B?Y3BnSTd3S3NsOHpqRWZUQzJPemxjd2hnTnI4TlFpYTk0ZEVZZ01HbnBsWUlv?=
 =?utf-8?B?Q0dZcFdzUURvRlFjSkdlbVdHY3hZa3FSa2U5NkRrSlhJUEpnWE10Z2FtZWNK?=
 =?utf-8?B?QjVhcUw1ZGxYTEc4b3lqdHJEOU1SNFpydEV1blpLZmdOejB0cUVyN29wUFFH?=
 =?utf-8?B?TVcwQjBGaDkyZnBXSDdNT2trWkxXbVVrNUtYZ3NJSDhpbDFaMHFyaHhsSUw4?=
 =?utf-8?B?SlgvbkZzU3pNRHlvUVYzNDQ5bU5ueHY3UDFidGZtQnZpMEZ2VHBsN200MUhI?=
 =?utf-8?B?SFJnMUoxWHdrMjNXcExnVm5TdnZaTHZ2Ym05aVFzeklRYTBlUUV0NWtPeWU3?=
 =?utf-8?B?Nit3TzBGNnJlWjVIdnBQTzFudTRTZWFzd1hXSGFuYnNTRWR6bWlhRERTMi9j?=
 =?utf-8?B?Rm92VUtIYTd4cnlaUEhBOWYvb1IyNVBKc2xuYUdDL25ZaWdGVXo2SjFSNWpu?=
 =?utf-8?B?K3cyaGVLNUJGTGtmSlZ4L0E0UTFUZmFZZzZQUWwxNWdZUUtvNDlBWlNHQmcr?=
 =?utf-8?B?MktEeDcvVHUvUXFQdWpLRGE2enFIbnM3c3VGWUt2bzVQcnVJenMxbW5zVThV?=
 =?utf-8?B?cFFDWWVTMnNoNmc1MFU3cE9tQktUOWl1akxkVUNENm45dUZYVCsvRWhVbEZi?=
 =?utf-8?B?N1UrOGgyeHhicUlrVXp0d0NWQStsNkFFRUlxRUtGY0Z3TFFDOVJxc1ZOc0kv?=
 =?utf-8?B?dU1hS3hYVFAxcGxoWHFVS3BJanVQaWdibjc0WnlCeXc2bjNQc1Z1UUdqMFQy?=
 =?utf-8?B?c3o0UGtrclNrRkl0SXZwdVNUalZyMlByajR3M2JXRVYyRjd2VkcxUFg1RFRT?=
 =?utf-8?B?VHRHdWNmVVhkZEcyMGowQWNRb0xHeXBhSjQ1VlVQNlRiOHFKU3BIcGYyS0xP?=
 =?utf-8?B?RVBtam40dk9VVUhlYUhrc2Q4VHA2YUtoSEFRT3pKTkU3Mzl1M1ZPTVZma3F3?=
 =?utf-8?B?RjEyL3hUbFg1aFg1ZVRpSEJJN1ZHSmM3d052SDVONHJvMmdzWTlWdUtyWms2?=
 =?utf-8?B?eVV5N2NjcVBsRnRHSThOcDJENGVIWG1ybmJDalhicGZadzc5bDQvenpkS0x6?=
 =?utf-8?B?a0dDc3c5T2d5Sml2RnZ1cHlYR1pzQ3I4RWJYRHBnYVd4QjJYY09CVWhaWnMz?=
 =?utf-8?B?RGNaeDhHb0VNbmZQZmVXSlFJdndVd1VOK0tkR1c3Vk5sSDVTd3VWMXMzZk9L?=
 =?utf-8?B?SURiQXFSU0lGSGpaazJUUzVPdFdITlFHK1BNVVJDc2kzMWdBaDFoS0V2R0JT?=
 =?utf-8?B?Mk5UeGlFcjFrVDZTNTl1NWtWZHk5aEp4djc1YlZpSVZXb0dZT2FzeDIyckdW?=
 =?utf-8?B?QnlpLzNJZGM0Y2ZMd2FpTWRyL2RObDNzVXo1eG53Smk5Nmh3MTY1V1dyVDdU?=
 =?utf-8?B?L2RqNUhJRWZkWU8vbzV3STBzendsV3dqMXBUMU4zY0MzVDcyTEZsQk9aYnAv?=
 =?utf-8?B?YmI0L1Z6eXAxWHVCMVl2UCt1QWk2S1pZV2lSc0ZUMEd2Z3pUT0JaZXF3UEM5?=
 =?utf-8?B?blBnaENpa2VkWm4wQWVSYlhySVluczY0ZXpRNUhsSzNDREpQRTRjbUtHNGJi?=
 =?utf-8?B?bWJzejRaZ3pYVldKZTlSMlVPRGFFV1NJNjdrcFpZKzZoZlNYTGZtTE1UWGht?=
 =?utf-8?Q?uaAyQT5H+WiBd?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR02MB10287.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(10070799003)(376014)(7416014)(38070700018);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?eXlIaDA1US9aUUlLT3ZrZkZMM3dQSEdrTjF1L1Z1NTVNUXRsMzY1bTRyTk90?=
 =?utf-8?B?YlRjUGlVMm9tTTcxL2lOV1dlbjhRQTMwcVlHSC9Ibk00dTUwZFdEcllKMUxN?=
 =?utf-8?B?QzBaNUYrWnFWMk4zTWRkL0JsUkhpdEtNZHNhOXd5bGFYUzd1b3dpUkp4MEh6?=
 =?utf-8?B?aUVQZ0FwRjNQdU5tSHh0bkwyYitOMWVTYzJUaFIwMGpDM0pFLzdHSHhSTC96?=
 =?utf-8?B?NTdmK1kxTzdhUUdZWCsveWJ2TkJQdXBFdmkwWk1ENXQzMXhwSlc0QXBTNWdV?=
 =?utf-8?B?NWtqUW1odzdMMXJiL253M0FwRUxpZTB1MHJ4dEFRZFVnOTN0Mng2YWpZM011?=
 =?utf-8?B?d1hNVWYvRXBmQWhuQlYzTGxoNUtpWC93bjAwaCtSY25KTmpqdDRvTzdFUklj?=
 =?utf-8?B?Z0ZnQzBSa25oY1RoUFFyWGFZN0lQV2QyR3FuWENGYUt3TXp3ME5qRmRqbzJ3?=
 =?utf-8?B?eDVuQU9JUTh3MW5NcTBRK2E4NDlrc1JkQk0rRHJGS3NhZ1VuNS8zdWppbVRO?=
 =?utf-8?B?a2tYMHJ1SEN6SEpROVRqblRjTkVFMDhzemZibmxYVktBOE10VGVZUlkvdldT?=
 =?utf-8?B?aFg4MnAzNmJ0NlZHV0VMOXlDS2pLOWwyMEdZM0hRR1ozVnc5c1crdW9TZjV2?=
 =?utf-8?B?cFNtMU44Wm1aYmk2cUMwTHFCZmtDblk1Wm1jMVRJNTlpUndtYS84dThNdDQ3?=
 =?utf-8?B?dE1sbHdFN0JnejljYnFKVWc5ZjZsWXF4TDBGSVNRRmgxd3BhSUhhd3NGYVJE?=
 =?utf-8?B?ZmxCY1U5UHpGRmxvZ3pLVEIzUTFLeDZncGRuVXBJWXFqQ0lmdVdLK01XWXp1?=
 =?utf-8?B?ekdjZmIvWFRDNHJUdXh1bnBUVmhCZlZhU0ZpTUdZMEhnVDhTTHpCUmMrTy9w?=
 =?utf-8?B?cGdhWWdsVkxsbmJCZ2FFUTFUbHN3ejY2RUUyNGVTc1RWSUIyQVc0MG0vUmN4?=
 =?utf-8?B?ZTVQbU9Qd0RjNEo5ZXJnOVhjZkhjODZCSXpmRWNmR1k0blpVMmhWTzFFSlpR?=
 =?utf-8?B?YWFoTG8yK01ybzlSVXU4a0VSbnRQcXdCVXB2NDl3dWNGelh4TmY1UHRXV2ha?=
 =?utf-8?B?Nk95M1ZvOWRyODN5ZHJ3ZmNKeGg1NWZoT0ovZkJRTHYySWp4ZnVZQmQxRnVi?=
 =?utf-8?B?VkpLSFNNSTVwVng2a0VFK05NUnhpd1crc0NMODVNL01iSUxGWXEzVkQrOVcy?=
 =?utf-8?B?b0tmMkI3T0NUNlh1QW4ycTFmRytSM2plb1diK016aVROUThCeHo2ZHJFaGpP?=
 =?utf-8?B?S3Y5ZmcyTHJoQ3kwV2U1WldUQjRJQ1JhVS8zNWd3ZGVNR213NTQ5QTBHVm01?=
 =?utf-8?B?ZXlDV0l5UDk0R0xUWElQTkV1bkxpa1U1eXRLMkpsZzVqSHFHemlRMU1CZG40?=
 =?utf-8?B?Mkw5OUM1aHVLeVRvYXpYR2gzaTVrRkwvM1VFRjFMajF2dW1URVBpQkFRN2JZ?=
 =?utf-8?B?SmQxd0cvdy9PWmt6YmVtcVdPSXNkMkx3QXhMSHZpb0JwUGNMZy9sTysxUytY?=
 =?utf-8?B?KytXWUMrV1ZrZUk3VlFSb1BzQzRreEMyRGJPL3V5TStEenRXTkxieHNyeXVC?=
 =?utf-8?B?UzNvNG44YnpsdjFzZXBKT2RpaXJiQ1ZPdTFKd0k4Q3hsM0JMNTFxcExreFlk?=
 =?utf-8?B?cUFGSUFOZzhLV2RmR0xTQ3U3dmR1UllOY3ErZEdoMml1VjdEZlJOVGZRMVd0?=
 =?utf-8?B?K0VmaE9NTTdMRWpndjFYNW5uVjNObWlMSkpZKzM0UkhtdXI1U2xBUmhNM3NN?=
 =?utf-8?B?TlNtUElNaC9XTEVlci8rd3dZM2ZyTFR3L1pqbmpHWDZUS0JxRDNLaFNNcVE1?=
 =?utf-8?B?cTd5ejkxOGcwdHpZTjd4amdMSVZkQ2hoRW5mSXRMeWxsUlNYTjY0a1FjNVdU?=
 =?utf-8?B?Ukg1d1ROQURhbTFFZ2hnK2NiZFlGQjA1LytSSmlNOEpBZzRLZUJ4SWREdFNi?=
 =?utf-8?B?UjRoM3pERDVCN2o3QXNMVitUblZtTnRrUUllKzNia1A5K0hCc0o1bzBRdVZn?=
 =?utf-8?B?Mi9DSmo1WDRuN09xN2c3dDROQ1A3YUNETFlrcDVlcU1oRy9VZ1RON0w1ZkRn?=
 =?utf-8?B?ckkrZXFHQzE4Njhvd2s2R1FKNkJ6YSsxK3J2Nlo4V1VvcE5aZ1E2dTliTjBx?=
 =?utf-8?B?bFJaRUJnTURQSXQzSTFwMDFtZ1gvcUdPY3h4QTREcjNSZGJIekJ1K3liZ3Bi?=
 =?utf-8?B?SHJ4bGZrSzJ3blhPRG40TWsxT3RRZXJPak5BVXQxS3N2Yy9aTUtDNmluTG1x?=
 =?utf-8?B?WHZkQ0NNR1Y3RWFGbjBCWkJhRUJBPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A5AB5212EF10F34B989E93DAE3B222C5@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV8PR02MB10287.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f5691de-a539-4875-55d7-08dd50f697db
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Feb 2025 15:03:39.6014
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Hh36UxSx31Tm52Fi1uTtN5yK9inDZ/NBh8MahpBwlUZKIcT8SW5MSDgmvt0IMEryZkXxBJTqU0cMyWFYVMF8GDWMdHzjO8c4KCvoaxZKECc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR02MB9777
X-Authority-Analysis: v=2.4 cv=P4bAhjAu c=1 sm=1 tr=0 ts=67b5f2cd cx=c_pps a=yfQ+ne3pfVgCfke9fm/9IQ==:117 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=T2h4t0Lz3GQA:10 a=0034W8JfsZAA:10
 a=0kUYKlekyDsA:10 a=NEAV23lmAAAA:8 a=QyXUC8HyAAAA:8 a=1XWaLZrsAAAA:8 a=KSrsWy1WaH4bI7k7A9QA:9 a=QEXdDO2ut3YA:10 a=xjj0GC5SL0ELW4ibpBgG:22
X-Proofpoint-GUID: ukNXNuNV3zF0udwQ67uLEXLUy9Nghh_3
X-Proofpoint-ORIG-GUID: ukNXNuNV3zF0udwQ67uLEXLUy9Nghh_3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-19_06,2025-02-19_01,2024-11-22_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gQXVnIDcsIDIwMjQsIGF0IDk6MTDigK9BTSwgU2VhbiBDaHJpc3RvcGhlcnNvbiA8
c2VhbmpjQGdvb2dsZS5jb20+IHdyb3RlOg0KPiANCj4gIS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS18DQo+ICBDQVVUSU9O
OiBFeHRlcm5hbCBFbWFpbA0KPiANCj4gfC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0hDQo+IA0KPiBPbiBUdWUsIEF1ZyAw
NiwgMjAyNCwgUGFvbG8gQm9uemluaSB3cm90ZToNCj4+IE9uIFR1ZSwgQXVnIDYsIDIwMjQgYXQg
NjowM+KAr1BNIFNlYW4gQ2hyaXN0b3BoZXJzb24gPHNlYW5qY0Bnb29nbGUuY29tPiB3cm90ZToN
Cj4+Pj4gQXMgaXMgbm90ZWQgaW4gWzFdLCB0aGlzIGlzc3VlIGlzIGNvbnNpZGVyZWQgdG8gYmUg
YSBtaWNyb2NvZGUgaXNzdWUNCj4+Pj4gc3BlY2lmaWMgdG8gU1BSL0VNUi4NCj4+PiANCj4+PiBJ
IGRvbid0IHRoaW5rIHdlIGNhbiBjbGFpbSB0aGF0IHdpdGhvdXQgYSBtb3JlIGV4cGxpY2l0IHN0
YXRlbWVudCBmcm9tIEludGVsLg0KPj4+IEFuZCBJIHdvdWxkIHJlYWxseSBsaWtlIEludGVsIHRv
IGNsYXJpZnkgZXhhY3RseSB3aGF0IGlzIGdvaW5nIG9uLCBzbyB0aGF0IChhKQ0KPj4+IGl0IGNh
biBiZSBwcm9wZXJseSBkb2N1bWVudGVkIGFuZCAoYikgd2UgY2FuIGltcGxlbWVudCBhIHByZWNp
c2UsIHRhcmdldGVkDQo+Pj4gd29ya2Fyb3VuZCBpbiBLVk0uDQo+PiANCj4+IEl0IGlzIG5vdCBl
dmVuIGNsZWFyIHRvIG1lIHdoeSB0aGlzIHBhdGNoIGhhcyBhbnkgZWZmZWN0IGF0IGFsbCwNCj4+
IGJlY2F1c2UgUFYgRU9JIGFuZCBBUElDdiBkb24ndCB3b3JrIHRvZ2V0aGVyIGFueXdheTogUFYg
RU9JIHJlcXVpcmVzDQo+PiBhcGljLT5oaWdoZXN0X2lzcl9jYWNoZSA9PSAtMSAoc2VlIGFwaWNf
c3luY19wdl9lb2lfdG9fZ3Vlc3QoKSkgYnV0DQo+PiB0aGUgY2FjaGUgaXMgb25seSBzZXQgd2l0
aG91dCBBUElDdiAoc2VlIGFwaWNfc2V0X2lzcigpKS4gIFRoZXJlZm9yZSwNCj4+IFBWIEVPSSBz
aG91bGQgYmUgYmFzaWNhbGx5IGEgbm8tb3Agd2l0aCBBUElDdiBpbiB1c2UuDQo+IA0KPiBQZXIg
Q2hhbywgdGhpcyBpcyBhIHVjb2RlIGJ1ZyB0aG91Z2guICBTcGVjdWxhdGluZyB3aWxkbHksIEkg
d29uZGVyIGlmIEludGVsIGFkZGVkDQo+IGFjY2VsZXJhdGlvbiBhbmQvb3IgcmVkaXJlY3Rpb24g
b2YgSFZfWDY0X01TUl9FT0kgd2hlbiBBUElDdiBpcyBlbmFibGVkLCBlLmcuIHRvDQo+IHNwZWVk
IHVwIGV4aXN0aW5nIFZNcywgYW5kIHNvbWV0aGluZyB3ZW50IHNpZGV3YXlzLg0KDQpIZXkgU2Vh
biwgQ2hhbywgUGFvbG8sIHF1aWNrIGZvbGxvdyB1cCBvbiB0aGlzIG9uZS4gDQoNCkVpaWNoaSB3
YXMgd29ya2luZyBvbiBwdWxsaW5nIGRvd24gSW50ZWwgTWljcm9jb2RlIDIwMjUwMjExIFsxXSwg
YW5kIEkgaGFkDQphc2tlZCB0byByZXRlc3QgdGhpcyBvbmUuDQoNCktub2NrIG9uIHdvb2QsIGl0
IGxvb2tzIGxpa2UgdGhlIGlzc3VlIGlzIOKAnGdvbmXigJ0gd2l0aCAyMDI1MDIxMSBvbiBTUFIv
RU1SDQoNClRoZSBFTVIgWzJdIGFuZCBTUFIgWzNdIHJlbGVhc2Ugbm90ZXMgYWxsdWRlIHRvIHNv
bWUgRXJyYXR1bSByZWdhcmRpbmcNCnNvbWUgdm1leGl0IGZpeHVwcyB0aGF0IHNvdW5kIGludGVy
ZXN0aW5nLCBidXQgSeKAmW0gbm90IHN1cmUgaWYgdGhleSBhcmUgYWN0dWFsbHkNCnRoZSBiYWNr
aW5nIGlzc3VlLCBvciBpZiB0aGlzIGlzIHNoZWVyIGNvaW5jaWRlbmNlLCBvciBpZiB0aGVyZSB3
YXMgYW5vdGhlciBmaXgNCmJ1dCBqdXN0IGlzbuKAmXQgZnVsbHkgZG9jdW1lbnRlZCBhcyBhbiBl
cnJhdGE/DQoNClRoZXNlIHR3byBhcmUgbGlzdGVkIGFzIOKAnGZpeGVk4oCdIGluIHRoZSByZWxl
YXNlIG5vdGVzOg0KRU1SMTM3LiBWTSBFeGl0IEZvbGxvd2luZyBNT1YgdG8gQ1I4IEluc3RydWN0
aW9uIE1heSBMZWFkIHRvIFVuZXhwZWN0ZWQgSURUIFZlY3RvcmluZy1JbmZvcm1hdGlvbg0KU1BS
MTQxLiBWTSBFeGl0IEZvbGxvd2luZyBNT1YgdG8gQ1I4IEluc3RydWN0aW9uIE1heSBMZWFkIHRv
IFVuZXhwZWN0ZWQgSURUIFZlY3RvcmluZy1JbmZvcm1hdGlvbg0KDQpAQ2hhbyAtIGNvdWxkIHlv
dSBoZWxwIGNvbmZpcm0gb3VyIG9ic2VydmF0aW9ucyBvbmUgd2F5IG9yIHRoZSBvdGhlcj8NCg0K
WzFdIGh0dHBzOi8vZ2l0aHViLmNvbS9pbnRlbC9JbnRlbC1MaW51eC1Qcm9jZXNzb3ItTWljcm9j
b2RlLURhdGEtRmlsZXMvcmVsZWFzZXMvdGFnL21pY3JvY29kZS0yMDI1MDIxMQ0KWzJdIGh0dHBz
Oi8vY2RyZHYyLmludGVsLmNvbS92MS9kbC9nZXRDb250ZW50Lzc5MzkwMiAoRU1SIG1pY3JvY29k
ZSByZWxlYXNlIG5vdGVzKQ0KWzNdIGh0dHBzOi8vY2RyZHYyLmludGVsLmNvbS92MS9kbC9nZXRD
b250ZW50Lzc3MjQxNSAoU1BSIG1pY3JvY29kZSByZWxlYXNlIG5vdGVzKQ==

