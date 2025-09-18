Return-Path: <kvm+bounces-58028-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 69483B85E40
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 18:06:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id ED3527BB95F
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 16:04:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5ECBE314D32;
	Thu, 18 Sep 2025 16:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="IGbh2ypD";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="lSe+0fGS"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F76C23B615;
	Thu, 18 Sep 2025 16:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758211534; cv=fail; b=tySEqNC3jKUzfFEeE/eOfbHIXwH+EzVclb8pY3QifjuJse6fcjh9puavR3+I/VYi9rQC5gmL0sk2YwFJSm45MRLhWreGTKdIoZvDhvjxBsZNZs0X+W+ftDWC+arBnEdT5kYtNR2vgZXN4JLBgen6YkRzNf6R3AFYAryb6xELZPA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758211534; c=relaxed/simple;
	bh=XGqU1MlTqVifc3xk3AsxFI9BV3SR+OiduosTGwDwAcg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=AiS1dzjIxi37X99buyy4hT3w44gpgv9CFQIcSnt9PtV7stNUP0aLSv4YtY3URQLDh4G+1lCKK1jGAqh3qoRz9PIix6YDE+1OAiaVOUlTXxqgt2jeTNu2wo4h71OWubdylNIfF67aZA/j6z6rGxyzhmmhU4+G3W2l3dh0oQ/aI/g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=IGbh2ypD; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=lSe+0fGS; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127841.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 58IAS1v43718781;
	Thu, 18 Sep 2025 09:05:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=XGqU1MlTqVifc3xk3AsxFI9BV3SR+OiduosTGwDwA
	cg=; b=IGbh2ypDX/mjpig0/LjJdxQ8p+9fMWESr5l/Ywqk74Hl6DkHzoEj6JHat
	lvirWJTfj1cFuOHNcY5jFBfwOR/DrURtif+YO/M/x6nLmO9+kgMxFXJ4Y/H1h4x/
	WiyOH62Vo78QDIVZLChvKLpF/1lZio3r3JY3DjyD7MAxkAQiUeFyBZvxLnLJU9OH
	P4sXPkzy8i77hzZW7jik7ebGuysXHDM5lB+zK+iTHl3WE+AoLPL3VCTX7Y4htR41
	wkjeAixUkmpwNWulX6bdGvU3JfJs9kH72ffx5F76B0WmB8FCMno7WwrjAQ+rYkbf
	aDFaW4ECAak/CqaWgfmcsWSRyPk8g==
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11022110.outbound.protection.outlook.com [52.101.43.110])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 498gbm8srt-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 18 Sep 2025 09:05:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Js7W8qOirO4wukp1JHL3jd+5xiEpUB2VwUgFX0XhERFq1X65Et3C5euq3pUvvMUhzJ2C4X0AEPvYWTpys3f17QDdaDIDlu8/1LO22fXHBwqEDslyS4Jw1p3CTjfLArRBSNtsQHv8KKpUwSeaMIac6mMzzFJBdlYy6fjKLRmL3X4sXr+UNrSIlwVBSwd584mFXNM1CY7uoPlvvEn8zhcCzvQw1AovyTrIYodjPMz0Bu1nmIZuD3Fmytm8JHUHqatVWXskoamaa9QH26w0jd9rRYjbImBbM7ta1t5zaAt4Z/aXUk8kh75mkd9Ayedzetcp+JGN8Ff1X2QvRY755mSGPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XGqU1MlTqVifc3xk3AsxFI9BV3SR+OiduosTGwDwAcg=;
 b=VcVHN2oIoDSho01OI56IWEHbtv6XA0W1M0vbbjfMwXqHQOpPdgbBOkx6b2e3tEWPiIX/reWAfg4wJxxsPkZHpEkTnqgHe1aO0LZ4pvjyHPmipPQF08vQLT8nfnPnnwI17k4WxfJP4zNfbBL6Da2SHCjnL0en6ZMcXd+VyJ4/rWLBIC3j/CiExBwjIpJT6oq6CY6XyYtNgaD3g1nHlGkTn1netW/jmkyJq+GSFWb0hjZQwz4BW2nf3MfZIS5Knof6iwFqtth3ClJgvhm/UkUKSfFgR0wB0N9J+1Opa59GtSmchaLptpOP5FbZ5WRV3v1lI05Lr5CPZRljz5hIOg+YGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XGqU1MlTqVifc3xk3AsxFI9BV3SR+OiduosTGwDwAcg=;
 b=lSe+0fGSt34NTOUPBdSHXSroXZ5ZFQD3XsULnw1U/kAf5/1N8hliU5ZRDbVa/DfeuWtIDZWezECN7HyIjS4ksvhkp87FIJmRXGupG29n1UyKpqZ0+19JH8fucrcP4BFiZs+keyJIXLcsGUbx2acOQAcvOj+Yz6PGNFauVWVDEiNd2QT35XfsAQnuEwOoclw1EbckTM2TWqJYwJPxhlEk3jIwd69cOvvCmH88epdbdS5lcK0dcbrs+0zzo5KC+FuhTwsqfrEGsIKfQhgWQ2xffjkPUMszTGUqOpxIQ0VZoBzfJAPv5hSAUkp0zW1MEVlOpA6ItKNBikzu7taq17KFAg==
Received: from MN2PR02MB6367.namprd02.prod.outlook.com (2603:10b6:208:184::16)
 by PH0PR02MB8764.namprd02.prod.outlook.com (2603:10b6:510:f1::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.14; Thu, 18 Sep
 2025 16:05:11 +0000
Received: from MN2PR02MB6367.namprd02.prod.outlook.com
 ([fe80::e3f8:10bc:1a6c:7328]) by MN2PR02MB6367.namprd02.prod.outlook.com
 ([fe80::e3f8:10bc:1a6c:7328%6]) with mapi id 15.20.9115.020; Thu, 18 Sep 2025
 16:05:11 +0000
From: Khushit Shah <khushit.shah@nutanix.com>
To: David Woodhouse <dwmw2@infradead.org>,
        Vitaly Kuznetsov
	<vkuznets@redhat.com>
CC: Vitaly Kuznetsov <vkuznets@redhat.com>,
        "seanjc@google.com"
	<seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>,
        Shaju Abraham <shaju.abraham@nutanix.com>
Subject: Re: [BUG] [KVM/VMX] Level triggered interrupts mishandled on Windows
 w/ nested virt(Credential Guard) when using split irqchip
Thread-Topic: [BUG] [KVM/VMX] Level triggered interrupts mishandled on Windows
 w/ nested virt(Credential Guard) when using split irqchip
Thread-Index:
 AQHcHnl3X2e3RPdxkUCpUW5qLv/tRrSJApSAgAAlboCAAAZagIABfzMAgAFw1oCAABIkgIAM/n2A
Date: Thu, 18 Sep 2025 16:05:11 +0000
Message-ID: <BF4DA74F-8117-4388-842B-9FFB582C9E61@nutanix.com>
References: <7D497EF1-607D-4D37-98E7-DAF95F099342@nutanix.com>
 <87a535fh5g.fsf@redhat.com>
 <D373804C-B758-48F9-8178-393034AF12DD@nutanix.com>
 <87wm69dvbu.fsf@redhat.com>
 <376ABCC7-CF9A-4E29-9CC7-0E3BEE082119@nutanix.com>
 <87ms72g0zk.fsf@redhat.com>
 <dcc29d43904f4d26fea25dbdf8a86a2bae1087a9.camel@infradead.org>
In-Reply-To: <dcc29d43904f4d26fea25dbdf8a86a2bae1087a9.camel@infradead.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR02MB6367:EE_|PH0PR02MB8764:EE_
x-ms-office365-filtering-correlation-id: d5e75e14-5e0c-4165-1a10-08ddf6cd2594
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?YkM4T3A1UFhENHY0N3BhajYyaWdUVjRoN1dFeGp1eW5mVCtpUEVIUVpqTTdC?=
 =?utf-8?B?cmEwUW80Q2VPUlFzdDF1aW0vUzJ1aUVWYjFuWWc5U0xLeWRJQjVEemI4ZmVl?=
 =?utf-8?B?ZHd5cDJ5blhvaE9vRU5VcTBYamVRTnJYZzNXQUNhSHpzQjFmVndTeHVxMVp0?=
 =?utf-8?B?QUVFYVBIZFhqS0ZIKzZKTEdMY0YrMVZSSUhoYTlNNkdzcExpUTJMWHplQVN3?=
 =?utf-8?B?UElQaWlsc0RhbDZ6VDlaN1kwRGFwVHVmSHptdkFRb0UzTlBtNG9RVFhBWkRn?=
 =?utf-8?B?L2d3K1dtSW0yeEk2Q2RhQUlVckdmU3ZlY3kwNHc3OXhyZi9ORG40Y1I1cFNp?=
 =?utf-8?B?ZWxYdHgvMFJvM1Y5aUphTWFCdnE2TlovKzl1d2ZnUGFobkpFSFdHWXg0Qm5L?=
 =?utf-8?B?T21MbWUrYVg5TjN0N1NYOW0zVFo4ZG94UUlnNElwN25UYmNBTlM4SnZVT0tm?=
 =?utf-8?B?SXJEcGthcWZvZnIvUitVQXhQQSs5dG9vNHJOL3c4T1NPVm4yMG5EbkFUYzNQ?=
 =?utf-8?B?dDJBR2tRaVUzZlNURXRrcEpVa0VQK1FBa2hJVzFlekdsU3E1OUNCa1dLam4w?=
 =?utf-8?B?QTFBaEhYL1UvMkd4bGgrSHVCS0pmTGZtN2pKYjZlaVp6dVZUSWl0RGZqeW0r?=
 =?utf-8?B?OGd0b2RlN29yYnUyTy94aTR1S1UzcDJNdHNDOE84eVViZHZ5WEt6cENHdElj?=
 =?utf-8?B?aU9qZm9PUDlJeGZPZWtKVkY0cW9lbzY1OUJHcWYxWTJsamQyTHlCZ3NQTzQw?=
 =?utf-8?B?ZWFCa0MzTlFmUHQzeDRtMEpxNzNNRjNvTjFLNUt5S0Z1VzJIdEU4R1dQWGJZ?=
 =?utf-8?B?d3BmTFJDenJDYTV3K0ZpSmhyZXJ0cEloeWlSd2h5dkw2ODgxZUk1NHpudEJz?=
 =?utf-8?B?eDlHVTBVdTBpeFhobmdUSUtZbkhIejZLeGx6ZE9tMi9MbUxraVRQaWtUcU0z?=
 =?utf-8?B?d2V2OFdHcEkvZXNTUWduNW5tTnNydmQ2WWRGdVBZSzN6cTFkM0o1L05kRTBQ?=
 =?utf-8?B?TGF2SjhaUW1Wb3dGZFlsVk1FQWZjTDhIdTV4THljcVNYZTFnaVk1OS9uTDJr?=
 =?utf-8?B?SWdHZEpqcTRNRklzZk1NRXFaNHE3d2ZTWWhHWTJuZFUzOU9GdGx0TVJOdkdm?=
 =?utf-8?B?UW9hbDk5REFjVURVM2lSTVMvMU9ScmZ2cmRwZmQ3YWtEMnhKMG5pQ1ZpMUpH?=
 =?utf-8?B?cDNGSEFVdHIzRWVMTDhBWHl2T3ZVWG0wRUU3dHlsclF3VUxiNVVZUFZpSklu?=
 =?utf-8?B?MFdHdFRSYkFKbTBlWjAvdjJJeXNtdjhKY0pCZ0J2c1N2L0FwM1dzMkJ6NlI4?=
 =?utf-8?B?QlZlZVFyd0R6U0d3V0l6ZEUxeTIvMFZhbkg1SThIbWFKdGJrc2pFemNVaUhW?=
 =?utf-8?B?RUtDN2xlMFhiNG5iMVhWNFkxTnpJOVZ4WWppQ0xpeit5SnI0dkhHUzRQcGJI?=
 =?utf-8?B?VUJnZmdJcWFESmlsSTBjUHk2ZzlmK05qMDFXdHBkTHlZeUZqL243UHJqZWd2?=
 =?utf-8?B?ZTIxWW1HWjh5NjFUSjVqZUE1Rjh6QTM1UWIrcnFsS3Rtb0c0Ym9pZnV0OVJu?=
 =?utf-8?B?TzlKSTdzMURyWkVLV2NmKzZCY21xNXdVZ0c5QjVaMk5vMWNrL0IzVG1Ib1Va?=
 =?utf-8?B?eElKSDRaMDF2SUVQVzRBQ0tJVG1PN2s4UnVxU2lsZW9MbzFMU2d6TnVYZ2VJ?=
 =?utf-8?B?dnp3VXVXWnRmSUErTEp1VXBNMjRBQVVrVU5RM0ZEUDlNVzQ5OHBaSG15ZWtl?=
 =?utf-8?B?SHpxcm56K0c0MFcyRjgxREFzMnpDcHFQano2aEprSXBUYXpzT2hyUXI5bUla?=
 =?utf-8?B?RFZxWmYrVDd6K1dQUzlqZnB0MmpmVE1jb3V0aHNQQklraUhGWC9oRzlwaHBI?=
 =?utf-8?B?aEt4OUdZTitOWFZYcVkweXV4V0hGSVc4U21WQ3F5TlN2WVhFVU82aXdCMncx?=
 =?utf-8?B?R051S2tEcVFWMzZSUkZWNWNqbUd6ZU5ydHM1Yk93anA3enl6eHBTWklEOE5w?=
 =?utf-8?Q?xuQmHwRG9VRIvC7pS3I6dK/I49U+s4=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR02MB6367.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?cEQ0UTQrUVBnLzhudWREeEMzZk9tdHY0K2hSdmNvSXdyU3c1Wk5VRVJBc3NT?=
 =?utf-8?B?V3ZNRDVoSVMvTnptRzUxQXpEVnE3ZTJ3bDl1eTM2NXFkbjBGY2RMblBjZVg2?=
 =?utf-8?B?Wmo1ZVdQeThVblpURGtJU1dyTm8ySmd0WEVwcnZCM3pYclpCdHp5c0d0aEgz?=
 =?utf-8?B?V0xNYWVTRGVtTWl5Yk52N20vSU9qZktiUEJHRnQvWDZWTlNOaW41a1ZnNWtp?=
 =?utf-8?B?SWdCOFh0WHd4bWxOeEg1bmRLdzhhQkVzc3YzOExTRFVtNUJPUlVKVEUwVmw4?=
 =?utf-8?B?ZE1NdzVEVzhkTUxWbFBzcURySXFCeXI2TEhUMnVUVlBPRXV0RzBmUTNORzlr?=
 =?utf-8?B?dE80RTBjYXdIdTkrZzY0OUlJM2R3RVh3SnBkejVpRkpKUHFwcFBmV2ZzdEVn?=
 =?utf-8?B?NUhETUpEWUZ3QUI4TjVuOHJCWmxpMEdoN2tPM0ZhMDRTWDNCM21Hci9HaUtW?=
 =?utf-8?B?bUJ3RXlkWlZjUVVOZ0dFMnNyYTRNTERmN1BlRkE2N2ViOE1jSU9CWnlMMnl6?=
 =?utf-8?B?YnZHWXNxSDZIeDdCaHowWkY3aVhIT0Q0cUVQd1A1R3FwdnlOWEN2b3ZqWXgv?=
 =?utf-8?B?R1NOam1JeVZnTTNjbFVLd0p6VExRNU82ZTlwWVh5VGs3VG1mY21veG5mbjdN?=
 =?utf-8?B?WE5XMEF6UzlTenpzWXZzRVBVMy93Y2RYMWpHWjNqMWgrdUpCZ05LQ1U3YXZJ?=
 =?utf-8?B?RUlFczF6WWhzV05CZVF2T1ZVTDBPa29EV2dLNVZzRll0RE8vL3dmejNIT1Y0?=
 =?utf-8?B?TzNnek5WMk1hRUJibkt4SnlTbTU0eHpBbytIWG53Nnpaak5YQjJBVVZ2cnBi?=
 =?utf-8?B?czM2U3ZnaGhyM29STkt6TFZCdFhLOGVNUkEwUGNMcm93YUViNU1kdlpkdENG?=
 =?utf-8?B?OU5lSlNCWW9STUYxckpaRHU4YmU1ZEdraEVhbjFTVU1oTDVsc3BIUGN6dGVy?=
 =?utf-8?B?TDdiTkx0T0o3c0c2K0QwY3JEYW5kWHZacm5vNXQ1elRGZm5Ma1NFbHpGTXN0?=
 =?utf-8?B?cEZ0NUhES1BxeXlWSDZSd3ZNWXF6YkdYbHhEdkFBUGExOFdqQWk1Q0dVSGE4?=
 =?utf-8?B?b2lMb0FSenNSemcyNkQyVFVtQ2cxTVI4dWwvWm9kZ0h1VVgwV1ltTE5WWjdv?=
 =?utf-8?B?WmlSbERVeXpBakJXZ2M3NzEvS29QUXlBR3JIdm0vMVZDNC91enc5dFVQRFlZ?=
 =?utf-8?B?WTdjWXRIdDZ6ajhMQzY5ZkVCb1UvV2h2QnN5anRUSW5XVVRybHJxRmJuMCtU?=
 =?utf-8?B?dzVTV1JEdStiNERBTlJEK1NUcUFNSTV4Qy91UWZ5dUN2LzZRbDJFN2lGNUVZ?=
 =?utf-8?B?UjZ0ZGRFT01RWDZUSW1jcGszQksyQnBSZ21PU1hCZGdhRHEwc1ZlbHdGS1VF?=
 =?utf-8?B?MVN4anp1V3JqazdUS3djdVVDeEhtM2NjUHJ0ek1hQllmWkVDd25OcUc3SjJK?=
 =?utf-8?B?emJxQTlqM1hET1A5QTQ1QWVVMHYycUEveXlSMjVwK0p1Vjg2Zi85T1EwQkJ4?=
 =?utf-8?B?SnJJNnR5UVF4UlJOWHE1eHJqZURseXNkTDJmM3FDYUtBZ3hLQVhaZ2dSMUdE?=
 =?utf-8?B?M0xZemM4UEpXc28wSUs0ZENQM29XZ0RiL3lvYXJ6ZDFCMTFvczRxek5QdWhX?=
 =?utf-8?B?Z3psVVJvM2tBc2xDUE9ZOXphaE43Qm4ybW9aT0huUGhCNWxNeS9VZU9VUmNa?=
 =?utf-8?B?dTQ1bXA3cHRKM29BTWY0cmdYa1RaQm84SUtBQ2hTWldWbHdPNlVDVDJ6eGZa?=
 =?utf-8?B?WDFvc2thL0VFaHhkYjFUQkx6d1F1bnNpL2k4eHlRYmpLNlRhcmFoellTYThm?=
 =?utf-8?B?TVdtMW9MYTJ3ZCt6Wm5CZk0wN1puMVJ2Q2QyK29RcEV6NjZGN0cwUEtQZDFK?=
 =?utf-8?B?ZS9zM0svaWU0dUpQYzhkNGNydWxWenFpNzFEeFRpRXZzSjMzSnlHb0FmdW1Y?=
 =?utf-8?B?V09DU09LQWZ3SjdlellkbDd6emxrOCsySmxmQjNNcWROc2xTWVVvR2tDdWln?=
 =?utf-8?B?Ri9OTlV3RFFsRlF6NEQwR2dSN3BRQ25ZQkdHMld6TURmTHBqWTlZWEo2M1A2?=
 =?utf-8?B?c08yQ0xBNjVkT2Fyb3gyQVZxMGw3blJJL1N4VkR4SjFRK1JCTVdJT1hPb3Rq?=
 =?utf-8?B?SUE2M2VFK2YwQmpRSkZHRFREQXhxdjRtQmVFaEwvMnhmbkh3Z01EeVh5dUsw?=
 =?utf-8?B?aGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8F836ED97981F64D9A387E0B236BCB3F@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR02MB6367.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5e75e14-5e0c-4165-1a10-08ddf6cd2594
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Sep 2025 16:05:11.5227
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nMVF+RfYuX87kKkDniAPy7aLsKZZQm4gdCu9CguYACoRwoOhLXkeK1MCd5c2E3nCoYuFoIUbbJrl7zy/WO9ZbRH4OnPoM+C5sesKGVOKx7Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR02MB8764
X-Proofpoint-ORIG-GUID: jQBUbmHzg9KthM8p-RT2WXs5QO4v0fro
X-Proofpoint-GUID: jQBUbmHzg9KthM8p-RT2WXs5QO4v0fro
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE4MDE0MSBTYWx0ZWRfX3agEPsx4JOvH
 SEGFw+6l2FqjyRL8Vzixn+CJ840MMPLwhDRvl7hDXft2+AMoR8klrq2zNhPy3SQbZJmr/9ic77Y
 Gk1F8y0jPxTL0f/9jLM8rtEOGtcHLf4+RIKYcQuGfx3Q64YqOqjn+aYS+RxYi+feGSDeJuDnapb
 ldIb2Dd+mIzae1mkwrqQomA7Fa+QoHobWiJ7H4U8ak6zTCEwnkx5nHYPJtE1RFZJiUVZYmLWRNg
 E/ooE5TtQF2qFVn50cJDXJqNPcRrhUw9upyOPAcJ22wMRSB4pVfAZmrNc+SmdbTi00KFj2t4cl7
 GE8+96jzaQnRXQxxEIKn0+0nqYaLgp6kISZRvzYPT/cQqoC23TLbOc93edzfTI=
X-Authority-Analysis: v=2.4 cv=ObiYDgTY c=1 sm=1 tr=0 ts=68cc2dbb cx=c_pps
 a=R5lJJwLUw69E8voCr07FQA==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=0kUYKlekyDsA:10 a=VwQbUJbxAAAA:8 a=64Cc0HZtAAAA:8
 a=20KFwNOVAAAA:8 a=0OLWMGjaGhXTh-rPZpYA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-18_01,2025-09-18_02,2025-03-28_01
X-Proofpoint-Spam-Reason: safe

LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KUkNBOiBL
Vk0gaWdub3JlcyBEaXJlY3RlZCBFT0kgYml0IGluIHNwbGl0LWlycWNoaXANCi0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQoNCldlIHRyYWNlZCB0aGUg
aXNzdWUgdG8gS1ZNIG5vdCByZXNwZWN0aW5nIHRoZSBEaXJlY3RlZCBFT0kgYml0IGluIHRoZQ0K
TEFQSUMgU3B1cmlvdXMgSW50ZXJydXB0IFZlY3RvciBSZWdpc3RlciAoQVBJQ19TUElWLCBiaXQg
MTIpIHdoZW4gdXNpbmcNCnNwbGl0LWlycWNoaXAuDQoNClBlciB0aGUgeDJBUElDIHNwZWNpZmlj
YXRpb24sIHdoZW4gQVBJQ19TUElWLkRpcmVjdGVkRU9JIGlzIHNldCB0aGUNCkxBUElDIG11c3Qg
bm90IGJyb2FkY2FzdCBFT0lzIHRvIHRoZSBJT0FQSUMuIEluc3RlYWQsIHRoZSBndWVzdCBpcw0K
cmVzcG9uc2libGUgZm9yIGlzc3VpbmcgYW4gSU9BUElDIEVPSSBieSB3cml0aW5nIHRvIGl0cyBF
T0kgcmVnaXN0ZXIuDQoNCkhvdyB3ZSBjb25maXJtZWQgdGhlIFJDQToNCldlIGFkZGVkIGEgbWFu
dWFsIGRlbGF5IGFmdGVyIHRoZSBsZXZlbC10cmlnZ2VyZWQgaW50ZXJydXB0IEVPSS4gUmlnaHQN
CmFmdGVyIHRoZSBFT0ksIFdpbmRvd3MgcGVyZm9ybXMgVk1SRVNVTUUgdG8gTDIsIGluamVjdGlu
ZyB0aGUgc2FtZQ0KdmVjdG9yOyBMMiBzZXJ2aWNlcyB0aGUgaW50ZXJydXB0IGFuZCB0aGVuIHdy
aXRlcyB0aGUgdmVjdG9yIHZhbHVlIHRvDQoweEZFQzAwMDQwICh0aGUgSU9BUElDIEVPSSByZWdp
c3RlcikuDQoNClJlbGV2YW50IGxvZ3MgKGFicmlkZ2VkKQ0KcWVtdS1rdm0gMTY5NzIwIFswNDNd
IDM5NzUuNTUwMDQ5OiBrdm06a3ZtX2VudHJ5OiB2Y3B1IDAsIHJpcCAweGZmZmZmODA1MjM3NzE2
N2UNCnFlbXUta3ZtIDE2OTcxMCBbMDM5XSAzOTc1LjU1MDA2NDoga3ZtOmt2bV9zZXRfaXJxOiBn
c2kgMjEgbGV2ZWwgMSBzb3VyY2UgMA0KcWVtdS1rdm0gMTY5NzEwIFswMzldIDM5NzUuNTUwMDY1
OiBrdm06a3ZtX21zaV9zZXRfaXJxOiBkc3QgMCB2ZWMgMTYxIChGaXhlZHxwaHlzaWNhbHxsZXZl
bCkNCnFlbXUta3ZtIDE2OTcxMCBbMDM5XSAzOTc1LjU1MDA2NToga3ZtOmt2bV9hcGljX2FjY2Vw
dF9pcnE6IGFwaWNpZCAwIHZlYyAxNjEgKEZpeGVkfGxldmVsKQ0KcWVtdS1rdm0gMTY5NzEwIFsw
MzldIDM5NzUuNTUwMDY2OiBrdm06a3ZtX2FwaWN2X2FjY2VwdF9pcnE6IGFwaWNpZCAwIHZlYyAx
NjEgKEZpeGVkfGxldmVsKQ0KcWVtdS1rdm0gMTY5NzIwIFswNDNdIDM5NzUuNTUwMDY3OiBrdm06
a3ZtX2V4aXQ6IHJlYXNvbiBFWFRFUk5BTF9JTlRFUlJVUFQgcmlwIDB4ZmZmZmY4MDUyMzYzYWEz
NCBpbmZvIDAgMA0KcWVtdS1rdm0gMTY5NzIwIFswNDNdIDM5NzUuNTUwMDY4OiBrdm06a3ZtX25l
c3RlZF92bWV4aXQ6IENBTidUIEZJTkQgRklFTEQgInJpcCI8Q0FOVCBGSU5EIEZJRUxEIGV4aXRf
Y29kZT52Y3B1IDAgcmVhc29uIEVYVEVSTkFMX0lOVEVSUlVQVCByaXAgMHhmZmZmZjgwNTIzNjNh
YTM0IGluZm8xIDB4MDAwMDAwMDAwMDAwMDAwMCBpbmZvMiAweDAwMDAwMDAwMDAwMDAwMDAgaW50
cl9pbmZvIDB4ODAwMDAwZjIgZXJyb3JfY29kZSAweDAwMDAwMDAwDQpxZW11LWt2bSAxNjk3MjAg
WzA0M10gMzk3NS41NTAwNjk6IGt2bTprdm1fbmVzdGVkX3ZtZXhpdF9pbmplY3Q6IHJlYXNvbiBF
WFRFUk5BTF9JTlRFUlJVUFQgaW5mbzEgMCBpbmZvMiAwIGludF9pbmZvIDgwMDAwMGExIGludF9p
bmZvX2VyciAwDQpxZW11LWt2bSAxNjk3MjAgWzA0M10gMzk3NS41NTAwNzA6IGt2bTprdm1fZW50
cnk6IHZjcHUgMCwgcmlwIDB4ZmZmZmY4MjliMmE0MTQyYw0KcWVtdS1rdm0gMTY5NzIwIFswNDNd
IDM5NzUuNTUwMDcyOiBrdm06a3ZtX2V4aXQ6IHJlYXNvbiBFT0lfSU5EVUNFRCByaXAgMHhmZmZm
ZjgyOWIyYTg1NTYxIGluZm8gYTEgMA0KcWVtdS1rdm0gMTY5NzIwIFswNDNdIDM5NzUuNTUwMDcy
OiBrdm06a3ZtX2VvaTogYXBpY2lkIDAgdmVjdG9yIDE2MQ0KcWVtdS1rdm0gMTY5NzIwIFswNDNd
IDM5NzUuNTUwMDczOiBrdm06a3ZtX2VudHJ5OiB2Y3B1IDAsIHJpcCAweGZmZmZmODI5YjJhODU1
NjENCnFlbXUta3ZtIDE2OTcyMCBbMDQzXSAzOTc1LjU1MDA3NToga3ZtOmt2bV9leGl0OiByZWFz
b24gVk1SRVNVTUUgcmlwIDB4ZmZmZmY4MjliMmE0MTMwOCBpbmZvIDAgMA0KcWVtdS1rdm0gMTY5
NzIwIFswNDNdIDM5NzUuNTUwMDc1OiBrdm06a3ZtX25lc3RlZF92bWVudGVyOiByaXA6IDB4ZmZm
ZmY4MjliMmE0MTMwOCB2bWNzOiAweDAwMDAwMDAxMWIzYmMwMDAgbmVzdGVkX3JpcDogMHhmZmZm
ZjgwNTIzNjNhYTM0IGludF9jdGw6IDB4MDAwMDAwMDAgZXZlbnRfaW5qOiAweDgwMDAwMGExIG5l
c3RlZF9lcHQ9eSBuZXN0ZWRfZXB0cDogMHgwMDAwMDAwMTAzMGE1MDFlDQo9PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0gTDIgU2VydmljZXMgdGhlIElu
dGVycnVwdCA9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQ0KcWVtdS1rdm0g
MTY5NzIwIFswNDNdIDM5NzUuNTUwMTIzOiBrdm06a3ZtX25lc3RlZF92bWV4aXQ6IENBTidUIEZJ
TkQgRklFTEQgInJpcCI8Q0FOVCBGSU5EIEZJRUxEIGV4aXRfY29kZT52Y3B1IDAgcmVhc29uIE1T
Ul9XUklURSByaXAgMHhmZmZmZjgwNTIzNjJkMzZjIGluZm8xIDB4MDAwMDAwMDAwMDAwMDAwMCBp
bmZvMiAweDAwMDAwMDAwMDAwMDAwMDAgaW50cl9pbmZvIDB4MDAwMDAwMDAgZXJyb3JfY29kZSAw
eDAwMDAwMDAwDQpxZW11LWt2bSAxNjk3MjAgWzA0M10gMzk3NS41NTAxMjQ6IGt2bTprdm1fbmVz
dGVkX3ZtZXhpdF9pbmplY3Q6IHJlYXNvbiBNU1JfV1JJVEUgaW5mbzEgMCBpbmZvMiAwIGludF9p
bmZvIDAgaW50X2luZm9fZXJyIDANCnFlbXUta3ZtIDE2OTcyMCBbMDQzXSAzOTc1LjU1MDEyNTog
a3ZtOmt2bV9lbnRyeTogdmNwdSAwLCByaXAgMHhmZmZmZjgyOWIyYTQxNDJjDQpxZW11LWt2bSAx
Njk3MjAgWzA0M10gMzk3NS41NTAxMjc6IGt2bTprdm1fZXhpdDogcmVhc29uIEVQVF9WSU9MQVRJ
T04gcmlwIDB4ZmZmZmY4MjliMmIwNGI4MiBpbmZvIGQ4MiAwDQpxZW11LWt2bSAxNjk3MjAgWzA0
M10gMzk3NS41NTAxMjc6IGt2bTprdm1fcGFnZV9mYXVsdDogdmNwdSAwIHJpcCAweGZmZmZmODI5
YjJiMDRiODIgYWRkcmVzcyAweDAwMDAwMDAwZmVjMDAwNDAgZXJyb3JfY29kZSAweGQ4Mg0KcWVt
dS1rdm0gMTY5NzIwIFswNDNdIDM5NzUuNTUwMTMwOiBrdm06a3ZtX2VtdWxhdGVfaW5zbjogMDpm
ZmZmZjgyOWIyYjA0YjgyOiA4OSA0OCA0MA0KcWVtdS1rdm0gMTY5NzIwIFswNDNdIDM5NzUuNTUw
MTMxOiBrdm06dmNwdV9tYXRjaF9tbWlvOiBndmEgMHhmZmZmZjgyN2EyNjA2MDQwIGdwYSAweGZl
YzAwMDQwIFdyaXRlIEdQQQ0KcWVtdS1rdm0gMTY5NzIwIFswNDNdIDM5NzUuNTUwMTMxOiBrdm06
a3ZtX21taW86IG1taW8gd3JpdGUgbGVuIDQgZ3BhIDB4ZmVjMDAwNDAgdmFsIDB4YTENCnFlbXUt
a3ZtIDE2OTcyMCBbMDQzXSAzOTc1LjU1MDEzMToga3ZtOmt2bV9mcHU6IHVubG9hZA0KcWVtdS1r
dm0gMTY5NzIwIFswNDNdIDM5NzUuNTUwMTMyOiBrdm06a3ZtX3VzZXJzcGFjZV9leGl0OiByZWFz
b24gS1ZNX0VYSVRfTU1JTyAoNikNCg0KV2hlbiBBUElDX1NQSVYuRGlyZWN0ZWRFT0kgaXMgc2V0
LCBXaW5kb3dzIGV4cGVjdHMgdGhhdCB0aGUgTEFQSUMgd2lsbA0Kbm90IEVPSSB0aGUgSU9BUElD
LiBLVk0sIGhvd2V2ZXIsIEVPSXMgdGhlIElPQVBJQyBmcm9tIHVzZXJzcGFjZSB3aGlsZQ0KdGhl
IGludGVycnVwdCBoYXMgbm90IHlldCBiZWVuIHNlcnZpY2VkLCBzbyB0aGUgbGluZSByZW1haW5z
IGFzc2VydGVkDQphbmQgdGhlIElPQVBJQyByZWluc2VydHMgdGhlIGludGVycnVwdC4gVGhpcyBs
b29wIGNvbnRpbnVlcyBhbmQgV2luZG93cw0KbWFrZXMgbm8gcHJvZ3Jlc3MuDQoNCldoeSB0aGlz
IGlzIEludGVsICsgc3BsaXQtaXJxY2hpcCBvbmx5Og0KVGhpcyBpcyBub3Qgc2VlbiBvbiBBTUQg
d2l0aCBzcGxpdC1pcnFjaGlwIGJlY2F1c2UgV2luZG93cyBkb2VzIG5vdCBzZXQNCkFQSUNfU1BJ
Vi5EaXJlY3RlZEVPSSBpbiB0aGVzZSBjYXNlcy4gV2UgZG8gbm90IHNlZSB0aGlzIHdpdGgNCmtl
cm5lbC1pcnFjaGlwIGJlY2F1c2UsIERpcmVjdGVkIEVPSSBjYXBhYmlsaXR5IGlzIG9ubHkgYWR2
ZXJ0aXNlZCBpZg0KdGhlIGlycWNoaXAgaXMgbm90IGluIGtlcm5lbC4gKHJlZjoNCi9hcmNoL3g4
Ni9rdm0vbGFwaWMuYzprdm1fYXBpY19zZXRfdmVyc2lvbikuIFRoaXMgaXMgYmVjYXVzZSBpbi1r
ZXJuZWwncw0KSU9BUElDIGltcGxlbWVudGF0aW9uIGRvZXMgbm90IGhhdmUgRU9JIHJlZ2lzdGVy
cyAoSU9BUElDIHZlcnNpb24gMHgxMSkuDQpXaGlsZSBRZW11J3MgZGVmYXVsdCBJT0FQSUMgSW1w
bGVtZW50YXRpb24gaGFzIEVPSSByZWdpc3RlcnMgKElPQVBJQw0KdmVyc2lvbiAweDIwKS4NCg0K
VGhpcyBpcyBwb3NzaWJseSBhbHNvIHRoZSBhY3R1YWwgUkNBIGZvciANCmNvbW1pdCA5NThhMDFk
YWI4ZTAyZmM0OWY0ZmQ2MTlmYWQ4YzgyYTExMDhhZmRiDQpBdXRob3I6IFZpdGFseSBLdXpuZXRz
b3YgPHZrdXpuZXRzQHJlZGhhdC5jb20+DQpEYXRlOiBUdWUgQXByIDIgMTA6MDI6MTUgMjAxOSAr
MDIwMA0KDQoJaW9hcGljOiBhbGxvdyBidWdneSBndWVzdHMgbWlzaGFuZGxpbmcgbGV2ZWwtdHJp
Z2dlcmVkIGludGVycnVwdHMgdG8gbWFrZSBwcm9ncmVzcw0KDQoNCg0KUGF0Y2g6DQpodHRwczov
L3BhdGNod29yay5rZXJuZWwub3JnL3Byb2plY3Qva3ZtL3BhdGNoLzIwMjUwOTE4MTYyNTI5LjY0
MDk0My0xLWpvbkBudXRhbml4LmNvbS8NCg0KQWRkaXRpb25hbCBmaW5kaW5nIChwb3RlbnRpYWwg
c2VwYXJhdGUgYnVnKQ0KSW4gL2FyY2gveDg2L2t2bS9sYXBpYy5jOmt2bV9hcGljX3NldF92ZXJz
aW9uDQpEaXJlY3RlZCBFT0kgc3VwcG9ydCBpcyBleHBvc2VkIHRvIHRoZSBndWVzdCB3aGVuZXZl
ciB4MkFQSUMgaXMgcHJlc2VudA0KYW5kIHRoZSBJT0FQSUMgaXMgbm90IGluLWtlcm5lbDoNCmlm
IChndWVzdF9jcHVpZF9oYXModmNwdSwgWDg2X0ZFQVRVUkVfWDJBUElDKSAmJg0KICAgICFpb2Fw
aWNfaW5fa2VybmVsKHZjcHUtPmt2bSkpDQogICAgdiB8PSBBUElDX0xWUl9ESVJFQ1RFRF9FT0k7
DQprdm1fbGFwaWNfc2V0X3JlZyhhcGljLCBBUElDX0xWUiwgdik7DQoNClRoaXMgYXNzdW1lcyB0
aGUgdXNlcnNwYWNlIElPQVBJQyBhbHdheXMgc3VwcG9ydHMgRGlyZWN0ZWQgRU9JLiBRRU1V4oCZ
cw0KSU9BUElDIHZlcnNpb24gY2FuIGJlIDB4MTEsIHdoaWNoIGRvZXMgbm90IHN1cHBvcnQgRGly
ZWN0ZWQgRU9JLiBXZQ0Kc2hvdWxkIHRyYWNrIHRoaXMgc2VwYXJhdGVseS4NCg0KVGhhbmtzIGZv
ciBhbGwgdGhlIGhlbHAhDQoNClJlZ2FyZHMsDQpLaHVzaGl0

