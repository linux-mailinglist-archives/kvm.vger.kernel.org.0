Return-Path: <kvm+bounces-29171-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 63CC19A3F29
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2024 15:09:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A08B3B20C9B
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2024 13:09:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C94918FC79;
	Fri, 18 Oct 2024 13:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=marvell.com header.i=@marvell.com header.b="sFJTHVcA"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66B6D1CD2B
	for <kvm@vger.kernel.org>; Fri, 18 Oct 2024 13:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.156.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729256937; cv=fail; b=VoyQzfdLMF5EmLYHb4cY+Al7h7VFZGPwd7fVR77h4YnUDQZ6E6vgF5SxtyLZutfBUeSS9b4JYkbgnObBHbMCPEzgFLXJcVrZi2aF9VShZ023fuKhL61qRMtso+PlKBTIZvLdaK2ECIn/1Xij9s8+JekdwTF7SPisTgjHfirLLP0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729256937; c=relaxed/simple;
	bh=u0aN4eb7PdfDNd+XnvPo/rWKF733AS8fNifnQyiV99k=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 MIME-Version:Content-Type; b=nR+TM6/6FuCbp/gyBP/Z8c3Pig2guUOJGgbZ+Iq+AO2xlTLBgicDcg4ullrSJfv1AbMEvVLCDHEG0rSXpAfFSNJPCqnqgus9UyBmzv2Z7RZ3FtwvSqdg1i1yFY8jUfvmvsKmvda+drUVVR4FuD8DoxTpV6uDkNFwxQq8blhprdE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=fail (1024-bit key) header.d=marvell.com header.i=@marvell.com header.b=sFJTHVcA reason="signature verification failed"; arc=fail smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49IAPGaT023317;
	Fri, 18 Oct 2024 06:08:41 -0700
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2044.outbound.protection.outlook.com [104.47.56.44])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 42bnvug9c3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 18 Oct 2024 06:08:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Znaar6nONDEZo+pIuRJD+1mRPXLyg44uKaeGBY1tKVjWOMnot2VeskOlCJrL6i4MzebLXjdf54VyhxFhYbQPj4osuwAe44X0CfEMPGFiQW9D5OX8QnmS3E9Ym4Bi718Gh6kBMwhOHliZ8iSX2Bu57DpZjgCY3/eVMSQWT1Kf4vJVesyJapvCJ5eZ63Ge3P3UtP0KODApnAS60yTLeVGZhXJ2HvLVon9b50Be9bjJVW42H0/WN0ATQ+LY0arQtfcXO9NYjshcf0H5OEd+5AzcoeqH3ez4gmrhogX+zzm54krZ+L4UXCElxIJukP2EcbG/k2pd55Di8zznLN2TeNtfTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bRz0yxinlIUya/qkdJgK1uvvgHCojMzRmC5+YguFzho=;
 b=dY0gBLKh/V3EdQ9Vf0neajjQFukvYptd8x59Krojp5Gda2fYIk0ff4YipoARnp9Bt07mXO1gbGgOLbckHLRTqAGmrH4BrKBW1cX7dRLHastmuRXTxdfNzhoUBlp7h6Q8i9CV0/5bq4NlYQUp83a+zbS+AHFCusmETVRy5jr4biHeeGupn4wLB3qzzx6iFqjD8urXkZ00Zrop77LEdyhGyDRlfOWBR/4/CkE1sBs0X5+vCO5rdnzsGopRUCsvUm6Cl+l1kOfq74YDAZoYDESSQtax6Vw6sBPesKRzcNr9NhZyZ26JCiZ39kfvXew2aRQX+Mjg6f9hjgwqgNgPndBeFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bRz0yxinlIUya/qkdJgK1uvvgHCojMzRmC5+YguFzho=;
 b=sFJTHVcAaHgQbUyAoNmp4kOgsopxKEPZpsudwhbej73EQGt4/Lg3t6lKT78bEykkNSbB6uLZrEeYuncH6R3Z9WXazn54g/aOD/sCmKJMFJmWd/025qZ4/EJAFFeX4RbGIR2DAAQUiyYgaQg9z+AHUSKXAOzZamFnxeQxd07GUeo=
Received: from PH7PR18MB5354.namprd18.prod.outlook.com (2603:10b6:510:24d::11)
 by PH0PR18MB4040.namprd18.prod.outlook.com (2603:10b6:510:2::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.20; Fri, 18 Oct
 2024 13:08:37 +0000
Received: from PH7PR18MB5354.namprd18.prod.outlook.com
 ([fe80::7f70:2c74:a8e2:a610]) by PH7PR18MB5354.namprd18.prod.outlook.com
 ([fe80::7f70:2c74:a8e2:a610%5]) with mapi id 15.20.8069.016; Fri, 18 Oct 2024
 13:08:37 +0000
From: Srujana Challa <schalla@marvell.com>
To: Christoph Hellwig <hch@infradead.org>
CC: "virtualization@lists.linux.dev" <virtualization@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mst@redhat.com"
	<mst@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "eperezma@redhat.com" <eperezma@redhat.com>,
        Nithin Kumar Dabilpuram
	<ndabilpuram@marvell.com>,
        Jerin Jacob <jerinj@marvell.com>
Subject: RE: [EXTERNAL] Re: [PATCH v2 0/2] vhost-vdpa: Add support for
 NO-IOMMU mode
Thread-Topic: [EXTERNAL] Re: [PATCH v2 0/2] vhost-vdpa: Add support for
 NO-IOMMU mode
Thread-Index:
 AQHbE96PlQaeJdnt006ohvbKHfff0rKGTA1AgAD2ZICAAnCmAIAA3iwAgAALuYCAAXcsgIAATAOQ
Date: Fri, 18 Oct 2024 13:08:36 +0000
Message-ID:
 <PH7PR18MB5354CF1D29BDEAC106C641E5A0402@PH7PR18MB5354.namprd18.prod.outlook.com>
References: <20240920140530.775307-1-schalla@marvell.com>
 <Zvu3HktM4imgHpUw@infradead.org>
 <DS0PR18MB5368BC2C0778D769C4CAC835A0442@DS0PR18MB5368.namprd18.prod.outlook.com>
 <Zw3mC3Ej7m0KyZVv@infradead.org>
 <DS0PR18MB5368CB509A66A6617E519672A0462@DS0PR18MB5368.namprd18.prod.outlook.com>
 <ZxCsaMSBpoozpEQH@infradead.org>
 <DS0PR18MB53686815E2F86EFC5DFE1E45A0472@DS0PR18MB5368.namprd18.prod.outlook.com>
 <ZxHw9dZ-EolHR0k3@infradead.org>
In-Reply-To: <ZxHw9dZ-EolHR0k3@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR18MB5354:EE_|PH0PR18MB4040:EE_
x-ms-office365-filtering-correlation-id: 2ec26069-7aca-4d58-ef5c-08dcef75fa49
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?dEJYd081TzZYaDJnSnhtUzd2OXRyREVkd09YYWhBZlVBWVgyR3ZtYStTV3lM?=
 =?utf-8?B?SWFjclRReS9INURKYWtHNndKK1hYYVNnZGdkcW1HT2JwZTdyWEtMZFdZTjRn?=
 =?utf-8?B?Wk1BanFjNDFrTktvSnNST2p1bFNVSFNWMEVaOEdFOVpWRk8zeENqWFkvbnNq?=
 =?utf-8?B?MFZOaS9mTDhrQXEzMFNkdzgxZmxQZkhzWk83RHl2NzloMS9Fdm5uSlF2UGRM?=
 =?utf-8?B?dWIwOGMxcTl1TUl1YSthYzRRcVBZbzZIdWFLUHV0V3FNdm5DVnpBeC9iOFBS?=
 =?utf-8?B?enEwN3dEQmU2OU9TNDBxdVNFdlRwd1ZjQldPamFuVEp1MEw4YnkvR3RzL0tF?=
 =?utf-8?B?T0NkQ1J6ZVRjVHNtbkh1MkZMc0xkYXFIaTQvK1lMcnZvRnc1NnR4YndleWxM?=
 =?utf-8?B?SnI2KzBaMHdWZ0UvK09xVFZUNm1lNnJKN1VQNS9tUHBsdE82ZEZiVFJuYVFw?=
 =?utf-8?B?aTVFSUI1TGZsN0U2NjduNldoOW9rQW1DQ1o5aXVjZGxrK0JYbmllK3EyWGd2?=
 =?utf-8?B?dmUvVXBSMmxkVGxwT1U5bGtJVkgzU1dyKzJuakpmeW5uUmh6YVRQekx6S3pN?=
 =?utf-8?B?NXdZNnYzWFhkMkV3VHRMc1ZZYjdmSTVKUG1CV0x3ci9DNmVXUlJxTmVDM2N1?=
 =?utf-8?B?V0FsS291ZzNFS3ovc0EyMWxoZ0dVY1BNcHBpVzZKZnEvdTJNNGFrK093VC9R?=
 =?utf-8?B?K2lMY1dXK0J2S3N4WkFjR2cra1N0Y2Z5YlJWOTd0RjVkSlhIMDdoQnF2VENp?=
 =?utf-8?B?b21LdVFDanAyZnlUeGFJU1dGdWM4MU1QNGpndEZGU2szTjlpUjZ1c2JlVEV5?=
 =?utf-8?B?MklSRXpqa3lSNDJYZ2xxeDdaVHB1WEFjVGJnL2JHZlk0SXJZSWJVTTJhNUU1?=
 =?utf-8?B?UlN5K25xNTYvNVlrL3dJdGpJYXZ3YUVvM0VjUlJCdnBFWitkTTcrcFhXTzM4?=
 =?utf-8?B?OUxYWjZBWmZPREpscDViZE96OUNya3pFT2paOXpKV2YxQXhQR0pJcWZVMkVP?=
 =?utf-8?B?VVB5REtMbUdGS25YMFBBNnpNVDY1RDlzcUpJc2pCWE8zeGoyVEJYZ3BDYTQy?=
 =?utf-8?B?SkFmOWlkTHpRSml4aXlWTFcxN25ZM3hEZ29GWms3WEc2bVo4Q0F4MXJ5Z0Zv?=
 =?utf-8?B?dWJ1QzNiNDhkeWdWM29PbHJ1MUpTdjRwdVNDQXJUenZwZi82dm9OS2lyckVE?=
 =?utf-8?B?KzJPbHIzbGJiR05rUGx0RFl5NGJwa3Z4OWpZNFFZbklHMWZKTXF0Yms5NXQ5?=
 =?utf-8?B?N2UxUVFuVXZDUUlKSWIxcUJRNlFZUlFPNU1hcmlnVE1hbHI5U2pUajFYNWli?=
 =?utf-8?B?K2NneS9kK3FIQUhaZ0hibHRkbUtobC95dDlkV2lGZzl3QUNydVJMY0tabGhR?=
 =?utf-8?B?M1ZoWlFzTVJhdjlGMFVMVVAxbnc5UlVld2lxZFdaSkt4LzVLTklCcmtLVW9v?=
 =?utf-8?B?cnQwTWFUZzVaZGpoenRzMnh5clZ3K0d1Nk5iYzJ3ZXJhcVpVaTRWcjZKOXMw?=
 =?utf-8?B?OW80ZFpuclZxWDZ4dGJhMkpvdDZ2d3ZYZkZ2c2gvWjI0eWlWSTRoYWJhLzNM?=
 =?utf-8?B?dG9kSFVtUlFVMmZ5ckxBc2R5Y0c1RUxoOUVpN2I0d3RoNUpWcUR2eWM2aDFw?=
 =?utf-8?B?YW95YWdwcTBidDJtK0JGRk5nZU05NEpKQm5PdjlCb0NUT0dZaXB1RzVFckRm?=
 =?utf-8?B?NmR5Z2dxc2hnZWtXamtTNWl0M0lmK251RU1zVUsvWDgxY3NFU1Rhd0pMUGVS?=
 =?utf-8?Q?98fP7C6Zn5M5cDhqibJpv3qsVPvm1KnxuY2FPJ/?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR18MB5354.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?T25CdCtPZHZaMGVGT0lCYjZ5QjFpbU1pa1JZMHM4b2syYXA4SnlQbStZcWFN?=
 =?utf-8?B?VlkzNGhSd3dLYStueWwreWdtcmhsTEkwVzI0L3dJaStOODhxMnQ4eVdScTQv?=
 =?utf-8?B?T2hsMGRPZ0dhUWpYTnQxZ2t1Zkdkc3ZzU0lIZCs1MHM4b2xTS25xUDB2b1B6?=
 =?utf-8?B?QVhlV1VrU1o2ZXVzZGNmZVJTQ3JDZzlEWFBBc0gwcXdyeXdWYm5wZlM1ZDQy?=
 =?utf-8?B?Uk44SktQV2VwdGVGUUg5cDR6NDVSSS9iM3ZkYU0yT0hDUXZsS1ZTb1FENmk2?=
 =?utf-8?B?YVljakJPUHIzeXNJVkNRWUdNSHphRVlQTUQrTG45YnY3S0s3WXl0dzF2SXJY?=
 =?utf-8?B?Y2J0WU1iWlJ0WnFneDVnNE5aUGNoTktVY0oxNk5qb3dvUTRBZXg3N05sM3dH?=
 =?utf-8?B?M2ViUlBKd1VNVEN1VGlJeUtIMTNZNmd1Vnp4ZnR4SWtOZVJvSGJ1a3RWOFhO?=
 =?utf-8?B?Vi9rb21MdldwbXJRMlF2TzlUTUhYVk1mMmFsMmJTUmx1NkhmdmE2UTNSTEJo?=
 =?utf-8?B?djc4MTJCZm0zejI0Nk0yZXhmalZYZGtKL0JKZ3pWQUZpZTFzLyt6YUZmMG9v?=
 =?utf-8?B?S3hEa29zS2UwcXdYQUE1MmRHQnJCQnEycTVkM2xkb08zZWJXUGduWjd4WDg0?=
 =?utf-8?B?ZnlWRE9oai9MM0pTN0ZTaVdCRFVDa0F1SFZvMitOUHNZUm9rbDFvc0hRU3pi?=
 =?utf-8?B?K09EUVJSMm8zL3IyeUNOL1RPNjEzME5NNlpvNU5FTjhaNDY0L2kzVE5RSDF5?=
 =?utf-8?B?Yk5VRUUxRWIrdlAvSWpJS2J0ZmVqSXNmeFA3MlBPUDJyTmtSZE5Za1pOUWdZ?=
 =?utf-8?B?UXo4Q2lOenlDeHB6YzZqRW9hMEJzcXFFMmRFMXhQY2VhZDF4dWZCYktVMDVC?=
 =?utf-8?B?UDJzcEFPMjlTZG1ZMTNWaUVCSlB2ZC9DeHZmK2VLU0VrSWdPSjVHcGE5SVkz?=
 =?utf-8?B?TDdkdHI3d2pzM2Vvem0xYy9DTk93NjIyenN1cDFJWjBOSzBjdmF2UFZrM0U2?=
 =?utf-8?B?ZzBuckt5UkNRSlhESi9WUVlsK1ZTTWRrcVY0djByUkZTdmI2dmJya3FyaWls?=
 =?utf-8?B?eHRCcVBaaG5hMTByUG9LSm50WUpoeGtCZkFjRmNDdUtOWWtHMXBkMXpvU2ZP?=
 =?utf-8?B?SnFQaFRXNTlTdXRXUityZ3JDVFV1TjhXUU9tUE5WK0JtdnNZNUZaRFNQaVY5?=
 =?utf-8?B?QjdZd0VKbDlWdVNVTlZVTkRKejI5RkUwSk5HTkNmRmRpQlBMSmh5VitWNllr?=
 =?utf-8?B?OG1XaU9OZGJpb2s2STUzTjg3a1V5VlZzVFllWkdBT0NITnVhQ0lPZGNoZ0t5?=
 =?utf-8?B?U2xoS3RMYTliVmRNb1N3NTg3eGZFR0lZVDlWdkZtMFdaWVk2WEpKOHpuY3Z6?=
 =?utf-8?B?eVhvTXNkL1pxWnZaRllOeTUzeUdKejBjaVk0S2k0bVBvcTlyT01GNDJQMHpa?=
 =?utf-8?B?cmhXTitSWWRVa2ZaN0p1ZWpWK1M3MzN3WDRtREp5Sys4TnFPazNGRmtSVHQ4?=
 =?utf-8?B?anFmck51V2hPWEhKWXYwMWJXRDVxbmhqYlphMDVsN0NCNnNFMTY5VjhxTExG?=
 =?utf-8?B?NGZPeHVMd2dzL0FaZE44eGVvTGlnRFJONThWaDg3UE5qNHlESlpNWDhLOWx1?=
 =?utf-8?B?Y1hjRk5WV3NpTmZxMnJEdXRIbWEyTW1TQjN2WGFPY1NRbERnejFuNzBuQmhC?=
 =?utf-8?B?YnZJbi85NktnYUtYTWFVYXpJSUF3dEhNeUZGZkloaXZRMWhJOTQ1M2NtMXl1?=
 =?utf-8?B?MWtSdHBzcHNwbjBwbGJ3VEFZVFB2eEZmd3duT3BFcmlyZCtwb2VQN0lOamtU?=
 =?utf-8?B?TnhhWnN3L3JoeTBhbWk3U01jVVIvTmtqVmNEdmorRnM1SGg3K3dDSS8vVjBm?=
 =?utf-8?B?WmNnelZmNWZFbHF0T0FlR2NGYWFUdHZJbWh2ZTRJRDVERWJLRVdPQUw5YUVX?=
 =?utf-8?B?dkJGUHNwaUxjMDFoV1VEdjBDejdmVk5nRXluODNDQlNIRnc0em13bS9wWWlU?=
 =?utf-8?B?VEU3aSs2YkJCdEJhM29IUWVma3BIK2NPM3JsNXQ2Y1ZtS0NQSXpZeVIwRXhV?=
 =?utf-8?B?WXBvcmR3bFhVelp0VFNDbGNSOUd6NjQzRUNPN0EvNjcwN1FrYkhPU2R0TTV0?=
 =?utf-8?Q?x+X3tFPf3AjKOeVEhfdwzyQNl?=
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR18MB5354.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ec26069-7aca-4d58-ef5c-08dcef75fa49
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2024 13:08:36.8676
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1Spm8sdSx/3SpzGYh0YMZd/9fthUHiMsgkvyE6ONVfpMJ3w3Oveokl3PdTMOUar5mUaQ8tE/FRGy11A+nkWVqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR18MB4040
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-GUID: Qy2Jrg1PPMC43HwPDTn-j6wDpFuQIr20
X-Proofpoint-ORIG-GUID: Qy2Jrg1PPMC43HwPDTn-j6wDpFuQIr20
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.687,Hydra:6.0.235,FMLib:17.0.607.475
 definitions=2020-10-13_15,2020-10-13_02,2020-04-07_01

> Subject: Re: [EXTERNAL] Re: [PATCH v2 0/2] vhost-vdpa: Add support for NO-
> IOMMU mode
>=20
> On Thu, Oct 17, 2024 at 08:=E2=80=8A53:=E2=80=8A08AM +0000, Srujana Chall=
a wrote: > We
> observed better performance with "intel_iommu=3Don" in high-end x86
> machines, > indicating that the performance limitations are specific to l=
ow-
> end x86 hardware. What does=20
> On Thu, Oct 17, 2024 at 08:53:08AM +0000, Srujana Challa wrote:
> > We observed better performance with "intel_iommu=3Don" in high-end x86
> > machines, indicating that the performance limitations are specific to l=
ow-
> end x86 hardware.
>=20
> What does "low-end" vs "high-end" mean?  Atom vs other cores?
 High-end, model name      : Intel(R) Xeon(R) Platinum 8462Y+,  64 Cores
 Low-end,  model name      : 13th Gen Intel(R) Core(TM) i9-13900K, 32 Cores
>  =09
> > This presents a trade-off between performance and security. Since
> > intel_iommu is enabled by default, users who prioritize security over
> > performance do not need to disable this option.
>=20
> Either way, just disabling essential protection because it is slow is a n=
o-go.
> We'll need to either fix your issues, or you need to use more suitable
> hardware for your workload.
I disagree. Why to pay more HW cost if the use case does not need demand fo=
r it?
fox example, embedded environment and trusted application are running.
It is the same thing is done for VFIO scheme. I don't understand your reser=
vation
on a mode you are not planning to use and default is protected.
There are a lot kernel options, which does the correct trade between various
parameter like performance, security, power and HW cost etc.


