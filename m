Return-Path: <kvm+bounces-61721-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DFE1C2682D
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 19:01:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 125973BC4E4
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 17:58:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22BCF333433;
	Fri, 31 Oct 2025 17:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="NkuM+eza";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="CduKlsUB"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69B2E309EF8;
	Fri, 31 Oct 2025 17:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761933520; cv=fail; b=TJE1zmv4ut5l1z/nR2JeutPHeRjwPexpx8pEvUFHw105XtrniR5J99XDYTuSpMOhyWyFjJYDXJGrZ4+K7t5LRcriCcvVwzfjGP0ctGsrko2Ly/zUzDbHZIeh/2eJ3HUQFR/VAguhkAmuynRr3Lx2aeWE8cKxDf4IuoFfGVz1AQs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761933520; c=relaxed/simple;
	bh=4l7lokOfcRii1yEjSac+OhG3v56Flb5IH2W/793Xt+c=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=cbrycN65wvbTOLX0Xnh3akLkYv7XHfr69py07shmHWPogI9CDKxs2J+N+oTCOhtxzoYplvY8Vj5IM7rn0Th+3XZPOsZ+liSuvwuJS0VlHjFS8HEFkrjMhtqmSYhorlyemdieGD+xetXMbTgRSIA2f8HydBGFh8q7wxAmNlgeRsQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=NkuM+eza; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=CduKlsUB; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127841.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 59VGp5X63754131;
	Fri, 31 Oct 2025 10:58:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=4l7lokOfcRii1yEjSac+OhG3v56Flb5IH2W/793Xt
	+c=; b=NkuM+ezavkNmV2R3+gl007hKRp+hZFezILKKTFmjDZvJHLCxgMKdT1577
	cSTjdUcEtxv3XzvJ4sUrIfycFQuDDZgbWOOdHtwklghiyZg91wEMKmvKmwuZvmur
	L5bALNV2Hn+qHjwnU/RRz81NghGoHBYsg1p4nNG/V4bkswLP4rBqtHDR2VOn8msz
	zslQoDIlFDKpHxuTqb7C9mmUZocYdUmAPEuok2x8G/7bScDZaDIYjXj/f2dhQSNS
	rCuL7inSaVqof0OwZj+SVQDFxMHU2Bt0N9O5lVvl1+zUgVdUJVtoq5K7sJN+tUpm
	cVZ1WyvIJYZHX23V13SJk+QGFl7Ow==
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11022139.outbound.protection.outlook.com [40.107.209.139])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4a4fstjd3x-3
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 31 Oct 2025 10:58:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=phdT0LuvZdGRtiYmFbf7Lc/2HQ2ed8gSD8Lq2E3kc7xEDmE/18MwLNSxrAq6mx5baFMRaYobQM246XQzflyoEdA6kQVOQzTAPnamAlhkYV/tx3GCZqj5mOiCWiLLjjDZEsJzCi3JyR6rCJ3p0XdJ34Hc2DM+2oUUF3oZIs+aS+2gVJx6seGSRkI4KYEmKEspNROy35XVVYBN4HsndqTY9/apQ76ysU6j+6GwNcYm3OZG6bcOW/WRT3zxeINtENLqMKNrxP51LtN8L2ZCZRartVUxvoH6L0H/BYXVBY+c0RvpA06Ntyj/0N2SgdiUYJbqQT/m5vOdMo0CpTcbpo+uBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4l7lokOfcRii1yEjSac+OhG3v56Flb5IH2W/793Xt+c=;
 b=h6Wv9d4LEwu/+3cOQJ+Av7crXSfxDPkNCvh1KaWfJmebU2xv1VAydKKDPQ3nMuS9Xuz7waUfqzYyd2SABh96I5F9fHBOlDnsotXjMYlU/Ctxu3uGyHXZwhz2S87tP6WEwHAw9WO5HdF1T/CKEINniv9nloIYEuV5p+24TrKY4x5aWNYprjdKA5PG4NGSixzPzkhI4pJXHcBzmBcPXulQC4ybwd828rSMsnukaZUXZs/006k5Hh1sxn9m8ExnTgQfpxsuJFPPAmYIhtu05PhuViVgyJyngY38eWpXx2r2+nM41Yxu6z72GJRH/dDLpIAxesP6MyRDY/fKFpJCWIxA7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4l7lokOfcRii1yEjSac+OhG3v56Flb5IH2W/793Xt+c=;
 b=CduKlsUBZL2l6qrayd0Mo0T9pvOBznq0fHWodV3XQAqEurQGQaQ3e8m2bufnU1HxZfnMLz6BYgJpoho1srSEufpFFBNCoGG12Mgen3biPnXxrQ6bZ4OJf7AVByT4eml4nNgqp+2G3+knVyK+3j90bkJFhzWvIf1c+MbdTw7NAv7Egfw3xw1kzpdzuOzMI89XsXFNsVFwDGex+6seZo122qlNr4woLr3W4GOf/byCdCuzrEhysPIDuDrrmCJIdZeIoowi6vFna4gaFYS5mI3jf+3fyxuYtKqkPu12VYxXolFCcDYc4w+RuUKf5QD/DScYoGtTpGT+iNrkvoYzjqZL3g==
Received: from LV0PR02MB11133.namprd02.prod.outlook.com
 (2603:10b6:408:333::18) by CH3PR02MB10382.namprd02.prod.outlook.com
 (2603:10b6:610:203::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.13; Fri, 31 Oct
 2025 17:58:30 +0000
Received: from LV0PR02MB11133.namprd02.prod.outlook.com
 ([fe80::10e5:8031:1b1b:b2dc]) by LV0PR02MB11133.namprd02.prod.outlook.com
 ([fe80::10e5:8031:1b1b:b2dc%4]) with mapi id 15.20.9253.017; Fri, 31 Oct 2025
 17:58:30 +0000
From: Jon Kohler <jon@nutanix.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] KVM: x86: Cleanup #MC and XCR0/XSS/PKRU handling
Thread-Topic: [PATCH 0/4] KVM: x86: Cleanup #MC and XCR0/XSS/PKRU handling
Thread-Index: AQHcSe6JPye2TB6n3U+tXh+pCufTf7TciyAA
Date: Fri, 31 Oct 2025 17:58:29 +0000
Message-ID: <FA141DE5-1EAD-4362-BE90-2E24D51749FA@nutanix.com>
References: <20251030224246.3456492-1-seanjc@google.com>
In-Reply-To: <20251030224246.3456492-1-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3826.700.81)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV0PR02MB11133:EE_|CH3PR02MB10382:EE_
x-ms-office365-filtering-correlation-id: b426ce33-5055-4a42-f08e-08de18a719c8
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|10070799003|376014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?aDE4WldoeGpaNEVQb3ZzRjg4dGV3Znd4ZE05c3dwY1Zpcks1REY2UUJDOUtn?=
 =?utf-8?B?Uk56U0tPREtNTncvNi9lY2pVaTg2eUMvdUlmSU1qc29qUjFqMTk0WHN4eFhs?=
 =?utf-8?B?LzEwY3dHTFlPbHRuTlE3QS8ydlo0UEhGejZ6Ui8yRUpDbVlvZjNzUm53Q08y?=
 =?utf-8?B?RGdyMUkwRWxtdEYrcVhoMWRWWU1JVTFlMm5SMHZIejNBZUxUbkp5YW1JVXF3?=
 =?utf-8?B?dUJtUnVJSFRTL0ZvOGMxT2lyMHBpNDVoTmNqdWl5QmtEa3NoaFprY3E3Z2lr?=
 =?utf-8?B?RXFYZDJ5VHdvVkJkdDZaL0FSeWRqRmtwODZBb2I2bEpISVJ1TE9HcXZGM0Ji?=
 =?utf-8?B?S2VZalZyZ3dUMVJlbUxEdXljZmtnUWRQYUxVNGxsOHdCb0xPRmVaMHg1cEdv?=
 =?utf-8?B?NTAxU0tldDkxZlF3TVQ3ZEY0U2JVZ0lIb1hwLytVOE1HS29XSmJGTVJVYmtZ?=
 =?utf-8?B?Y0lwQXoxcytSYWI2RVNxUW5kZndOTnI1MkNkS2JQS1pUSXRIdGFTM1pUOWMz?=
 =?utf-8?B?L1ZDT0kyVXpZY2ZOQTdZdUp1Z2IzU3orcitVNjlEdXZncGUyYjB2Z1ZseVEx?=
 =?utf-8?B?RjhKeFJtWGxaT244VG9xMWJWRzI3ZUxrVUJDOG1mdVNKclAwNW1zWTdGbTI2?=
 =?utf-8?B?NGxicTZWVmwvdjFMRFlqVWp3UHJpM0RQeEpxMEYyamQwTHp1Nzl1WDM1NXJh?=
 =?utf-8?B?WFIzVHpOaUdEeFlidTBzbXh5eTV1eTZDelAwaDFFOFBNTGNpeHJhelk0Z1Qy?=
 =?utf-8?B?TXVtT0hiYWdFLzBtbS90MERHZlBuYU5oenRXKzdxYXJIWVM1VFJNV2dzaUVr?=
 =?utf-8?B?V1N4ekc3eXFBL3dDUE9ZcWRUZDRybHc2eThuRTM3eXVzOVJFRkNzb0dSc0Iz?=
 =?utf-8?B?MmRmOEpJcHJBUGVPbFZlL1pMMElDMDlQM2tLOVVOa2NtWGF1WjhsWGFNcHJh?=
 =?utf-8?B?Unlrc1A0ZnFsdVBkM2lJeEViYVo4UXplK1BwWHNVVWE2bE91aUg3Yy83Q3lV?=
 =?utf-8?B?a3dNVjArZElaWllOSTlFSDF4NVhYQlNNdklwNTMwZTlyajE4aDNCQ0tialov?=
 =?utf-8?B?RFJxcTNJKytTeDJwcUdDOUx5d1dhV2ZabU1kKy9wbTUwM3F5NDZhNVNwYnR0?=
 =?utf-8?B?d3VCdExVOEtCcmt1SThWUFY5Z3NLelVONk5lTWtqREQ4Z2tZUlcwdVE4d28z?=
 =?utf-8?B?WTNrMWhzZ1luRHZqdXE3dEt0c3Yzc2N0cGZDSXlocUliTGxXcTF3NVp0THNy?=
 =?utf-8?B?ZVJZWS83RUhZUW9BM1o2ZmplWkVNR1U1T05McGp2VHlJVDBBRlZVd0w5OUkz?=
 =?utf-8?B?bnJIRm4xeFNUTGdJVXBaTWZWZUdXZUlTdG45em1lbXB0N3l5TW9OQXd2NFVP?=
 =?utf-8?B?UzFCbG1RUkV3WFJPbTYzVzdXZXk2amJnb1haOVZnakIxOXNxU2kwblRoRHZC?=
 =?utf-8?B?dzVxeXFUVWNOS0VGbVZ4RVYzUG11NWRCMG0rMEsyMDhuUk5MZUJlQXhMRSsv?=
 =?utf-8?B?dGx1SS8wRDBWQUtSOWF2ZVBvdUtzYWtsUWZkQ2pLa3FKMVgzTUhtVm9nczZ2?=
 =?utf-8?B?aSt2c2VmMTJ5RzhMWGlZWE85cVYzWUF1T0RBZmVqN2RBcmFORVBSZjAvUzhJ?=
 =?utf-8?B?b0Q1RlpFajhlRFVjSHVEY0g3MFAwOXIwRmdjc1BodUdnRHBtdjR6ZEQ5ZTdW?=
 =?utf-8?B?WVVpVTVZWHF2M2dSL244RmlBUzk4WDJxR0F6ejJWOGtFRHlhRitNWm5yTmo3?=
 =?utf-8?B?a1BNbmlOcDRsRlgzQjVMcnVFeGVnVEpLNFNpQ0lBNTg5OFJLaHZVc2NKNmdO?=
 =?utf-8?B?anpUWExWNWpKL09YdUtBRitPOHM2eWVIa3pZYWlJTmV4a3Fvc09pT2o3eFpO?=
 =?utf-8?B?QnMwZFRxb2tVMGNNV2MyWVF5L09BSTV0N0kxaDdhbFJzYjA0S3B3N1IvdjdZ?=
 =?utf-8?B?RENOSGpaNlcrbWV3NmtTdW1WbHllYmxiVUpzSURqbytsQ0QxdEd5MEQ3WnhH?=
 =?utf-8?B?UHljTVZ5bkR3PT0=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV0PR02MB11133.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?NURnSGp2R0FEeWhOVzdBekVHUWxpRWFQbWhvamRIZTlqZUozTU55cks0L1p6?=
 =?utf-8?B?d04zUTZNNnFVd2lQdGxSK3lxaklueldZQlVwZ2JIMHhsalFQelgzcC81Q2hF?=
 =?utf-8?B?SkZydWU3SnJqQk81cStvK3NROC9SVzN5SHRZR25CeS9XUGRYemJodjViYzBJ?=
 =?utf-8?B?UTRxNXFRRTVjL3dab3MzQkNNbHN1bzI1TDB0c1VCR1RQdGhXRUw5OU43MHlV?=
 =?utf-8?B?RGV0MEZIbDJ5VzV3cDg4SVc2eTRMT3lIL2RDL3RiQXplbjJjbUd4eHIrbnRW?=
 =?utf-8?B?c0cwQlRlTnZYQXR4aU51UUVMelR6NzVMSlVUZzYyZG9GNTVUeW0xWldHUEpm?=
 =?utf-8?B?SXE4R0hRQ3JHdlRkODdvVmdsbk1ycDI1aGVWT1JmSTN6YjRMMm9pYWM5VDRI?=
 =?utf-8?B?akh5ckpnNFlkeEFyTGROVitUSG5KN2pwejg0M3hqZWFSeVNaVXh3Q3pQZ2pM?=
 =?utf-8?B?dDFVV0ROR3NFakxqc05XNzFNV2pVMGh3d2laRW1VQ1loWjA3NWR3TXZJMkxE?=
 =?utf-8?B?S1NGZTRWQlFQYXdZRW83OXlSQlNNVGk5d2ZUYk0rT3orNlZ1UE1wcTcvZkY4?=
 =?utf-8?B?ekM5TlBaREFlWmdOL0sxVXd3azFibnFYK3M4aDNlSC8xM1ZXL0Q3Rk95TUNX?=
 =?utf-8?B?Vm1uRkI5TlV6TDdSVWlNOHR4eGZMazUyUkFZNFFMeWF2MDBhc3VoVDN6UUpl?=
 =?utf-8?B?dTNpbUUwU2NDZ3hMTEZXQ2FiSVBnRjkvNHdDN29DZ0JhZFh2RHdPa216VjFR?=
 =?utf-8?B?cWNTNkZMVk5nK2pUV3JWVU54SlJ6WXJ5SDkycVQ3ZmZmT1dUZ3FVK3JhQmYx?=
 =?utf-8?B?RFFOT2Q1anROUWE2Z05YOGp1WXRmbzNUenNjbTh5WVNZQ1VXek1UMW01OWtH?=
 =?utf-8?B?TTl4Z1lXa1ZvWGJ2bGFMbUxPRnZJM1J1eGo2bUlUaVI1OVpLYVRocmoxTkts?=
 =?utf-8?B?N3hHK3B0QXg2NjZXVmxWU0VOMnBNY1Fpc3Rvd2REYm9TRHdZalhBTUlzcjVq?=
 =?utf-8?B?YURtOXRPekZCeXc1U1pFRXE3aEdkSmlXVFB2d2c0VUtDQ2hFOThBUzU4bkdJ?=
 =?utf-8?B?OGhOdURnL1MrWVhscGpLYmZaYWNFTW9iMStGbk91OXYwN2NYLzhrK0lrMW5J?=
 =?utf-8?B?dmZOQkVFbXBLdTI1c3hRZ2Y2cHdlVjAra1dibGlKSkhONklYZWY1MmhvK0I1?=
 =?utf-8?B?L0taWWRVdnYvOFRTNUFyRGtqdkthdkRRbDV1Z095ZGo2aWRoWWJ5Qk9RQWFT?=
 =?utf-8?B?RjVoMXFUUDJIalpnK0lsQzhwTzJveFAvSkxQc1VVWjFTRUhnNEp1bUtxR0Ns?=
 =?utf-8?B?VzU1YjlJSzBJYytGenQ4KzRLam8wSXVnOWhsSDF6MFFsSnM2a0pTRS9FMXF0?=
 =?utf-8?B?L2xJUU5WeHlQTFhheHA0R0tmb2p0UnR1Q2k3L0ZCcTE5WUM2N0RzbTdwcy9D?=
 =?utf-8?B?M3dMYm1zUDRPZDhLTkM3a25rcE5xNlBxeWVvOFV4cjNueVJJSnNvVTQwUDdu?=
 =?utf-8?B?UkRocjdtWlFrd2Z5M3BJQklheS9XY2Yya3VidXdKdXdPSjZyMWpkK0hKNkpl?=
 =?utf-8?B?cGlDTGttOGo5VjlyRU9wRmVkQ0pvdXJCQnRVRXVyMzgrQlp3V1YrNDNFcjND?=
 =?utf-8?B?RElYcG5zaTVlUmdVWjBrR25KRWZWMGUvaW4rMkhRSkw5K2M5bml5WmdHam5v?=
 =?utf-8?B?dW1DbDA0L2RIYm9ibkcxeGtMVDVQeDZNTVg3K3ZybFBHRXdzaE9SQytrZDlN?=
 =?utf-8?B?U2x1ZGFodWR2bEpsa0dpaE44L0xYazRzOC9Ma2dBZXpKOTZXbExScUcwK0FR?=
 =?utf-8?B?R2YyVkM5eFA3aVVtZE1oOGVMREVXdGhxeVJDMGlDd3BSQTFOdTlzZW9ZWmJM?=
 =?utf-8?B?dldHUjRzQ2V6b3FySTdVb3dETkZXZkRIQTBpaXlqR1RxaTBSekFNNERsTjNa?=
 =?utf-8?B?T0QzclNRR1ZSeDBORExvbHJDVTBZdlNoVWtHV05pSHgyYTEvZHNVODRVQUYr?=
 =?utf-8?B?eUVsclliYzczSXlseVJqWjFhL2YzT1kwSngwMnpQWkxjVnc4U3VnTy9IeitK?=
 =?utf-8?B?YzdGb1BvMWx1TXZZWXJCZ1ppc1NBT3ZTd2x3eTZudDh0NEZaUnVPejkxQlhI?=
 =?utf-8?B?SHJmaDA5M095MVZIRWNqdTV5TnJhWVp1RStMLy9pOC9RMGNZZVRPMXI1MlRS?=
 =?utf-8?B?cGphZE9QN3BCNllNVEZPYWV3dDVPOVBZU0gyVE9ZT2E0SnRuQ0hPZzg3aWlo?=
 =?utf-8?B?NUFUdlQrdlFpWFFrTkJ4K1RGVW5RPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C128D45FE09FEB4DBC50D8D312234123@namprd02.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: b426ce33-5055-4a42-f08e-08de18a719c8
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Oct 2025 17:58:29.9438
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QnF5yn2bK+djYzEy+80szF/zV08Va4noTONacBwGMkfE6/Tgu/M+FCvx5lUSH5MXM/ZVTlfzoxShlLgY312XUf6nLk7T1TmbJ8SEkBy3myo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR02MB10382
X-Proofpoint-ORIG-GUID: 5a_wFofvRwvz3gYd78w5iAbjHAJs9HWa
X-Proofpoint-GUID: 5a_wFofvRwvz3gYd78w5iAbjHAJs9HWa
X-Authority-Analysis: v=2.4 cv=N8Yk1m9B c=1 sm=1 tr=0 ts=6904f8ca cx=c_pps
 a=A91p8pFdSY8iZOlwlHItIA==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=x6icFKpwvdMA:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=9PN3anHYAAAA:20 a=1XWaLZrsAAAA:8 a=64Cc0HZtAAAA:8 a=P_uzQyMkqA7qUkDK5Z0A:9
 a=QEXdDO2ut3YA:10 a=CTwFTDRtctY-zZ8oRDn3:22 a=yULaImgL6KKpOYXvFmjq:22
 a=pHzHmUro8NiASowvMSCR:22 a=6VlIyEUom7LUIeUMNQJH:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDMxMDE2MSBTYWx0ZWRfX4gHft4+1spSS
 ISzFm5QCGvDZuduzctAGp0Ve8MGke8itD9sUoy8TYq41ix+qbAZS4fO3t1Hf2VrS4UIezC6j/sl
 XDFs3SI0b9Gwf/5JFq27pZGisDt9VEi7+rlOb4w6xpzz4v3gCe+x5ubon7VOFrha9ATjzM4NpHs
 cocFADrsLLX9irNj9/UHtWNHh/3F7chmkcSoRqD5aqNdgJaW8brZEqLtOrmTuSyF9R4Z8AOoR73
 J/WQCYUPRTNv7zf0dE13ew+yKVaTM6W5NgUxisC7aUJ0mYPJzVz0XOdz7gpXdxVOeG84MjW5PcF
 b+BnKQrSJqRjrCRArd8ar9AsMQrw0i4deCuRpvAf5lWX1a0fNO5wd342W0XUMpPmPI9xMeImE0d
 p2FY//vfg0L6n+g+bWnlrtowy/Dwow==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-10-31_06,2025-10-29_03,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gT2N0IDMwLCAyMDI1LCBhdCA2OjQy4oCvUE0sIFNlYW4gQ2hyaXN0b3BoZXJzb24g
PHNlYW5qY0Bnb29nbGUuY29tPiB3cm90ZToNCj4gDQo+ICEtLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tfA0KPiAgQ0FVVElP
TjogRXh0ZXJuYWwgRW1haWwNCj4gDQo+IHwtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tIQ0KPiANCj4gVGhpcyBzZXJpZXMg
aXMgdGhlIHJlc3VsdCBvZiB0aGUgcmVjZW50IFBVQ0sgZGlzY3Vzc2lvblsqXSBvbiBvcHRpbWl6
aW5nIHRoZQ0KPiBYQ1IwL1hTUyBsb2FkcyB0aGF0IGFyZSBjdXJyZW50bHkgZG9uZSBvbiBldmVy
eSBWTS1FbnRlciBhbmQgVk0tRXhpdC4gIE15DQo+IGluaXRpYWwgdGhvdWdodCB0aGF0IHN3YXBw
aW5nIFhDUjAvWFNTIG91dHNpZGUgb2YgdGhlIGZhc3RwYXRoIHdhcyBzcG90IG9uOw0KPiB0dXJu
cyBvdXQgdGhlIG9ubHkgcmVhc29uIHRoZXkncmUgc3dhcHBlZCBpbiB0aGUgZmFzdHBhdGggaXMg
YmVjYXVzZSBvZiBhDQo+IGhhY2stYS1maXggdGhhdCBwYXBlcmVkIG92ZXIgYW4gZWdyZWdpb3Vz
ICNNQyBoYW5kbGluZyBidWcgd2hlcmUgdGhlIGtlcm5lbCAjTUMNCj4gaGFuZGxlciB3b3VsZCBj
YWxsIHNjaGVkdWxlKCkgZnJvbSBhbiBhdG9taWMgY29udGV4dC4gIFRoZSByZXN1bHRpbmcgI0dQ
IGR1ZSB0bw0KPiB0cnlpbmcgdG8gc3dhcCBGUFUgc3RhdGUgd2l0aCBhIGd1ZXN0IFhDUjAvWFNT
IHdhcyAiZml4ZWQiIGJ5IGxvYWRpbmcgdGhlIGhvc3QNCj4gdmFsdWVzIGJlZm9yZSBoYW5kbGlu
ZyAjTUNzIGZyb20gdGhlIGd1ZXN0Lg0KPiANCj4gVGhhbmtmdWxseSwgdGhlICNNQyBtZXNzIGhh
cyBsb25nIHNpbmNlIGJlZW4gY2xlYW5lZCB1cCwgc28gaXQncyBvbmNlIGFnYWluDQo+IHNhZmUg
dG8gc3dhcCBYQ1IwL1hTUyBvdXRzaWRlIG9mIHRoZSBmYXN0cGF0aCAoYnV0IHdoZW4gSVJRcyBh
cmUgZGlzYWJsZWQhKS4NCg0KVGhhbmsgeW91IGZvciBkb2luZyB0aGUgZGlsaWdlbmNlIG9uIHRo
aXMsIEkgYXBwcmVjaWF0ZSBpdCEgDQoNCj4gQXMgZm9yIHdoYXQgbWF5IGJlIGNvbnRyaWJ1dGlu
ZyB0byB0aGUgU0FQIEhBTkEgcGVyZm9ybWFuY2UgaW1wcm92ZW1lbnRzIHdoZW4NCj4gZW5hYmxp
bmcgUEtVLCBteSBpbnN0aW5jdHMgYWdhaW4gYXBwZWFyIHRvIGJlIHNwb3Qgb24uICBBcyBwcmVk
aWN0ZWQsIHRoZQ0KPiBmYXN0cGF0aCBzYXZpbmdzIGFyZSB+MzAwIGN5Y2xlcyBvbiBJbnRlbCAo
fjUwMCBvbiBBTUQpLiAgSS5lLiBpZiB0aGUgZ3Vlc3QNCj4gaXMgbGl0ZXJhbGx5IGRvaW5nIF9u
b3RoaW5nXyBidXQgZ2VuZXJhdGluZyBmYXN0cGF0aCBleGl0cywgaXQgd2lsbCBzZWUgYQ0KPiB+
JTI1IGltcHJvdmVtZW50LiAgVGhlcmUncyBiYXNpY2FsbHkgemVybyBjaGFuY2UgdGhlIHVwbGlm
dCBzZWVuIHdpdGggZW5hYmxpbmcNCj4gUEtVIGlzIGR1ZXMgdG8gZWxpZGluZyBYQ1IwIGxvYWRz
OyBteSBndWVzcyBpcyB0aGF0IHRoZSBndWVzdCBhY3R1YWx5IHVzZXMNCj4gcHJvdGVjdGlvbiBr
ZXlzIHRvIG9wdGltaXplIHNvbWV0aGluZy4NCg0KRXZlcnkgbGl0dGxlIGJpdCBjb3VudHMsIHRo
YXRzIGEgaGVhbHRoeSBwZXJjZW50YWdlIHNwZWVkdXAgZm9yIGZhc3QgcGF0aCBzdHVmZiwNCmVz
cGVjaWFsbHkgb24gQU1ELg0KDQo+IFdoeSBkb2VzIGt2bV9sb2FkX2d1ZXN0X3hzYXZlX3N0YXRl
KCkgc2hvdyB1cCBpbiBwZXJmPyAgUHJvYmFibHkgYmVjYXVzZSBpdCdzDQo+IHRoZSBvbmx5IHZp
c2libGUgc3ltYm9sIG90aGVyIHRoYW4gdm14X3ZtZXhpdCgpIChhbmQgdm14X3ZjcHVfcnVuKCkg
d2hlbiBub3QNCj4gaGFtbWVyaW5nIHRoZSBmYXN0cGF0aCkuICBFLmcuIHJ1bm5pbmcgcGVyZiB0
b3Agb24gYSBydW5uaW5nIFZNIGluc3RhbmNlIHlpZWxkcw0KPiB0aGVzZSBudW1iZXJzIHdpdGgg
dmFyaW91cyBndWVzdCB3b3JrbG9hZHMgKHRoZSBtaWRkbGUgb25lIGlzIHJ1bm5pbmcNCj4gbW11
X3N0cmVzc190ZXN0IGluIHRoZSBndWVzdCwgd2hpY2ggaGFtbWVycyBvbiBtbXVfbG9jayBpbiBM
MCkuICBCdXQgb3RoZXIgdGhhbg0KPiBkb2luZyBJTlZEIChoYW5kbGVkIGluIHRoZSBmYXN0cGF0
aCkgaW4gYSB0aWdodCBsb29wLCB0aGVyZSdzIG5vIHBlcmNlaXZlZCBwZXJmDQo+IGltcHJvdmVt
ZW50IGZyb20gdGhlIGd1ZXN0Lg0KDQpuaXQ6IGl04oCZZCBiZSBuaWNlIGlmIHRoZXNlIGJpdHMg
d2VyZSBsYWJlbGVkIHdpdGggd2hhdCB0aGV5IHdlcmUgZnJvbSAodGhlIG1pZGRsZSBvbmUNCnlv
dSBjYWxsZWQgb3V0IGFib3ZlLCBidXQgd2hhdOKAmXMgdGhlIGZpcnN0IGFuZCB0aGlyZCBvbmUp
DQoNCj4gT3ZlcmhlYWQgIFNoYXJlZCBPYmplY3QgICAgICAgU3ltYm9sDQo+ICAxNS42NSUgIFtr
ZXJuZWxdICAgICAgICAgICAgW2tdIHZteF92bWV4aXQNCj4gICA2Ljc4JSAgW2tlcm5lbF0gICAg
ICAgICAgICBba10ga3ZtX3ZjcHVfaGFsdA0KPiAgIDUuMTUlICBba2VybmVsXSAgICAgICAgICAg
IFtrXSBfX3NyY3VfcmVhZF9sb2NrDQo+ICAgNC43MyUgIFtrZXJuZWxdICAgICAgICAgICAgW2td
IGt2bV9sb2FkX2d1ZXN0X3hzYXZlX3N0YXRlDQo+ICAgNC42OSUgIFtrZXJuZWxdICAgICAgICAg
ICAgW2tdIF9fc3JjdV9yZWFkX3VubG9jaw0KPiAgIDQuNjUlICBba2VybmVsXSAgICAgICAgICAg
IFtrXSByZWFkX3RzYw0KPiAgIDQuNDQlICBba2VybmVsXSAgICAgICAgICAgIFtrXSB2bXhfc3lu
Y19waXJfdG9faXJyDQo+ICAgNC4wMyUgIFtrZXJuZWxdICAgICAgICAgICAgW2tdIGt2bV9hcGlj
X2hhc19pbnRlcnJ1cHQNCj4gDQo+IA0KPiAgNDUuNTIlICBba2VybmVsXSAgICAgICAgICAgIFtr
XSBxdWV1ZWRfc3Bpbl9sb2NrX3Nsb3dwYXRoDQo+ICAyNC40MCUgIFtrZXJuZWxdICAgICAgICAg
ICAgW2tdIHZteF92bWV4aXQNCj4gICAyLjg0JSAgW2tlcm5lbF0gICAgICAgICAgICBba10gcXVl
dWVkX3dyaXRlX2xvY2tfc2xvd3BhdGgNCj4gICAxLjkyJSAgW2tlcm5lbF0gICAgICAgICAgICBb
a10gdm14X3ZjcHVfcnVuDQo+ICAgMS40MCUgIFtrZXJuZWxdICAgICAgICAgICAgW2tdIHZjcHVf
cnVuDQo+ICAgMS4wMCUgIFtrZXJuZWxdICAgICAgICAgICAgW2tdIGt2bV9sb2FkX2d1ZXN0X3hz
YXZlX3N0YXRlDQo+ICAgMC44NCUgIFtrZXJuZWxdICAgICAgICAgICAgW2tdIGt2bV9sb2FkX2hv
c3RfeHNhdmVfc3RhdGUNCj4gICAwLjcyJSAgW2tlcm5lbF0gICAgICAgICAgICBba10gbW11X3Ry
eV90b191bnN5bmNfcGFnZXMNCj4gICAwLjY4JSAgW2tlcm5lbF0gICAgICAgICAgICBba10gX19z
cmN1X3JlYWRfbG9jaw0KPiAgIDAuNjUlICBba2VybmVsXSAgICAgICAgICAgIFtrXSB0cnlfZ2V0
X2ZvbGlvDQo+IA0KPiAgMTcuNzglICBba2VybmVsXSAgICAgICAgICAgIFtrXSB2bXhfdm1leGl0
DQo+ICAgNS4wOCUgIFtrZXJuZWxdICAgICAgICAgICAgW2tdIHZteF92Y3B1X3J1bg0KPiAgIDQu
MjQlICBba2VybmVsXSAgICAgICAgICAgIFtrXSB2Y3B1X3J1bg0KPiAgIDQuMjElICBba2VybmVs
XSAgICAgICAgICAgIFtrXSBfcmF3X3NwaW5fbG9ja19pcnFzYXZlDQo+ICAgMi45OSUgIFtrZXJu
ZWxdICAgICAgICAgICAgW2tdIGt2bV9sb2FkX2d1ZXN0X3hzYXZlX3N0YXRlDQo+ICAgMi41MSUg
IFtrZXJuZWxdICAgICAgICAgICAgW2tdIHJjdV9ub3RlX2NvbnRleHRfc3dpdGNoDQo+ICAgMi40
NyUgIFtrZXJuZWxdICAgICAgICAgICAgW2tdIGt0aW1lX2dldF91cGRhdGVfb2Zmc2V0c19ub3cN
Cj4gICAyLjIxJSAgW2tlcm5lbF0gICAgICAgICAgICBba10ga3ZtX2xvYWRfaG9zdF94c2F2ZV9z
dGF0ZQ0KPiAgIDIuMTYlICBba2VybmVsXSAgICAgICAgICAgIFtrXSBmcHV0DQo+IA0KPiBbKl0g
aHR0cHM6Ly9kcml2ZS5nb29nbGUuY29tL2RyaXZlL2ZvbGRlcnMvMURDZHZxRkd1ZFFjN3B4WGpN
N2YzNXZYb2dUZjl1aEQ0DQo+IA0KPiBTZWFuIENocmlzdG9waGVyc29uICg0KToNCj4gIEtWTTog
U1ZNOiBIYW5kbGUgI01DcyBpbiBndWVzdCBvdXRzaWRlIG9mIGZhc3RwYXRoDQo+ICBLVk06IFZN
WDogSGFuZGxlICNNQ3Mgb24gVk0tRW50ZXIvVEQtRW50ZXIgb3V0c2lkZSBvZiB0aGUgZmFzdHBh
dGgNCj4gIEtWTTogeDg2OiBMb2FkIGd1ZXN0L2hvc3QgWENSMCBhbmQgWFNTIG91dHNpZGUgb2Yg
dGhlIGZhc3RwYXRoIHJ1bg0KPiAgICBsb29wDQo+ICBLVk06IHg4NjogTG9hZCBndWVzdC9ob3N0
IFBLUlUgb3V0c2lkZSBvZiB0aGUgZmFzdHBhdGggcnVuIGxvb3ANCj4gDQo+IGFyY2gveDg2L2t2
bS9zdm0vc3ZtLmMgIHwgMjAgKysrKysrKystLS0tLS0tLQ0KPiBhcmNoL3g4Ni9rdm0vdm14L21h
aW4uYyB8IDEzICsrKysrKysrKystDQo+IGFyY2gveDg2L2t2bS92bXgvdGR4LmMgIHwgIDMgLS0t
DQo+IGFyY2gveDg2L2t2bS92bXgvdm14LmMgIHwgIDcgLS0tLS0tDQo+IGFyY2gveDg2L2t2bS94
ODYuYyAgICAgIHwgNTEgKysrKysrKysrKysrKysrKysrKysrKysrKysrKy0tLS0tLS0tLS0tLS0N
Cj4gYXJjaC94ODYva3ZtL3g4Ni5oICAgICAgfCAgMiAtLQ0KPiA2IGZpbGVzIGNoYW5nZWQsIDU2
IGluc2VydGlvbnMoKyksIDQwIGRlbGV0aW9ucygtKQ0KPiANCj4gDQo+IGJhc2UtY29tbWl0OiA0
Y2MxNjdjNTBlYjE5ZDQ0YWM3ZTIwNDkzODcyNGU2ODVlM2Q4MDU3DQo+IC0tIA0KPiAyLjUxLjEu
OTMwLmdhY2Y2ZTgxZWEyLWdvb2cNCj4gDQoNCkhhZCBvbmUgY29udmVyc2F0aW9uIHN0YXJ0ZXIg
Y29tbWVudCBvbiBwYXRjaCA0LCBidXQgb3RoZXJ3aXNlLCBMR1RNIGZvcg0KdGhlIGVudGlyZSBz
ZXJpZXMsIHRoYW5rcyBhZ2FpbiBmb3IgdGhlIGhlbHAhDQoNClJldmlld2VkLUJ5OiBKb24gS29o
bGVyIDxqb25AbnV0YW5peC5jb20+

