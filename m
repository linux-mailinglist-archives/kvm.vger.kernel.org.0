Return-Path: <kvm+bounces-63211-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 17C77C5DE68
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 16:35:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 066F9384023
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 15:03:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C701C328B77;
	Fri, 14 Nov 2025 14:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="oLAgR6RR";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="a0J3pL7a"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEF0032863E;
	Fri, 14 Nov 2025 14:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763132008; cv=fail; b=F6rHGeCnZuwbEYAJwMjN5aYepkYDVwIKpBm+yoH1FX7TicXfjJ0Os4QyVFk3SCzUHbZc+2i+adNxojd0awfzipt/1Kwf0VkO/L6FZgAJPdUh4VIm8OMhPA8QNRS1Xpkm3prw2XCFAOi7wOtOGx2DwFnQk5RqB9ULYHbKhNh460M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763132008; c=relaxed/simple;
	bh=UNJs6d+M8Mc96LhlxIYf2hpa+tLE3YqhVlstT6fphes=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=qXL1u8O2tHacSBrtqSwr49s5q+l3K8h/LhqpsNXlbzOvFDdKg8DIZN4SZe7Ew6e8hp1Cf3GGrT4HEiViZh24gykde70rBxevGNIJip5/E6F8IDQ5/WdPIF2mdAlBYB1bfx3K8XdpCfZBhzmipI5cGgmPDXpUgX9sHqCL4j+/8eA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=oLAgR6RR; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=a0J3pL7a; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127843.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5AEDsAg1977526;
	Fri, 14 Nov 2025 06:53:06 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=UNJs6d+M8Mc96LhlxIYf2hpa+tLE3YqhVlstT6fph
	es=; b=oLAgR6RRH1bKrZzVtrvUKDj4kkEMdFisWr84J+ux3Hjd81aI4L9xGh3/O
	eiUsCEFUAXo2WZDgjaoh2JUE9C92QvQ5xAxUlinc/KptOHYhJCaN6Ynq70AsS7S8
	6J7zYmVMleykbvmMsXi0zjRz/CBOT1iZpJEFUMOtqO05FfXOBCeu/30CTZK5pnfm
	X/Hk7+PB1j+4RjAgWabSwGATYjjbExqzrc26XXkKPDrBPsqOxsk9d6zYh5GGjY2u
	ZwLMaf65Z58ibXMbjSUcEVHyXhF/lCFxjDjx56T59L5gq5yALwkvfjbWroBoO5JJ
	Bi+cPXvemS3TsRwVJZvcKeXKvXb0w==
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11022093.outbound.protection.outlook.com [40.107.209.93])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4adwap988j-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 14 Nov 2025 06:53:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TmePt3ThSfc/PdmLuqfRyjUAZrXWiqiqxOkoHwOFijmI+MkpdzKr7iMVEOSHhX/lhTmZNU+PConPQWyknWdCQGKsFKGg9LEpnBg/kYfSm14nb8ipKnwo/s7/dC9hD8k4r4bima1BMKaZ2Zkh+7ok3SFCKV0Omgd3mdpLUumLe5tIMulLJPgk2rP+LM454EA2yKb2G5O/bDp1Au7RKP6Ib7jaRazJRzyqnUErfxnmc/+JXtu5I8bOkW+3JClsbkdOk4EKlavIZubSADpbBlnNooHJ5xCO+J0aSm8q2ubYg/WnlLUNMfFqZG6A6JAC3ERgdYfDXcm58LF3V4YVwCt8PA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UNJs6d+M8Mc96LhlxIYf2hpa+tLE3YqhVlstT6fphes=;
 b=Niv7txhT4lfB4xKQ/J145hKY3PmQMhJ2JerFJv2w5843aCBTVLFIsnjRB7OM5pHatddSYLrFimGwZ6TPbhTrU/dnZUeJW/JuU9MacVuHBMtNyjUn14It/HMnisySCvhPK+sW5czjMvES1+p4Upv/7AuiW5X6kkMK8fBxc7EiCTZJbDFkuqsFG1gbz1SJTb/vkcTmqv9UYF/2Yh9RXQpMuXe5TTxpTqKQKws1kG5Traqtd7lGgD3gCj9LWmQlau4X+n0vBZey8AKMUzVovXvjk32OWgGnAqOLqM8JN2Hfu/8ACn/GJJkqx7tbCkQmHahXEHS6dUef0V+9Pbp+Ek7vfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UNJs6d+M8Mc96LhlxIYf2hpa+tLE3YqhVlstT6fphes=;
 b=a0J3pL7aRSZGxGZznJilpR+GnLKQFPHk2xhaktR5N17d5d/Sz5yUJAdqeGUsLt4BV3s5mf+Z65RhfVsWkVwBrFEZiqEKzF3J6cbgpi+Ks9OD8G0NXNydZnURjHhFLqa6lRLC3iRbUNFXbF9PTbat72U5RQsJhQHLfH0JdsxHXYgNX+m0TOvLQf4Wfacv3AZsjkGcg9P0+5woo5qxOTYSG8QR8I8rMeJcs0L9jcwkkbCpHxcpb/JcfY4G6nbxcEolKeCDO7bUuYZ8VvTHwizOvhPRBCrK8UfNrvZWEB/MZEfbqZp5OQYpWpqgaPs6G0NG+S8jr5SJJcL9XdFGx0mwDQ==
Received: from LV0PR02MB11133.namprd02.prod.outlook.com
 (2603:10b6:408:333::18) by CH2PR02MB6523.namprd02.prod.outlook.com
 (2603:10b6:610:34::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.18; Fri, 14 Nov
 2025 14:53:04 +0000
Received: from LV0PR02MB11133.namprd02.prod.outlook.com
 ([fe80::10e5:8031:1b1b:b2dc]) by LV0PR02MB11133.namprd02.prod.outlook.com
 ([fe80::10e5:8031:1b1b:b2dc%4]) with mapi id 15.20.9320.013; Fri, 14 Nov 2025
 14:53:04 +0000
From: Jon Kohler <jon@nutanix.com>
To: Jason Wang <jasowang@redhat.com>
CC: "Michael S. Tsirkin" <mst@redhat.com>,
        =?utf-8?B?RXVnZW5pbyBQw6lyZXo=?=
	<eperezma@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux.dev" <virtualization@lists.linux.dev>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds
	<torvalds@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>,
        Sean
 Christopherson <seanjc@google.com>
Subject: Re: [PATCH net-next] vhost: use "checked" versions of get_user() and
 put_user()
Thread-Topic: [PATCH net-next] vhost: use "checked" versions of get_user() and
 put_user()
Thread-Index: AQHcVDJryQXjlObInEG9J4YkYYZKUbTvzAyAgAJ4RQA=
Date: Fri, 14 Nov 2025 14:53:04 +0000
Message-ID: <E1226897-C6D1-439C-AB3B-012F8C4A72DF@nutanix.com>
References: <20251113005529.2494066-1-jon@nutanix.com>
 <CACGkMEtQZ3M-sERT2P8WV=82BuXCbBHeJX+zgxx+9X7OUTqi4g@mail.gmail.com>
In-Reply-To:
 <CACGkMEtQZ3M-sERT2P8WV=82BuXCbBHeJX+zgxx+9X7OUTqi4g@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3826.700.81)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV0PR02MB11133:EE_|CH2PR02MB6523:EE_
x-ms-office365-filtering-correlation-id: fdea1cab-dfe9-4a46-ef5e-08de238d83fb
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|10070799003|1800799024|366016|7416014|376014|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?VVpqZTdDWXMxRDFWN3NYMDVQcmNVV0t2dHB4eVdraklSajV5bnh1b1ErWjc2?=
 =?utf-8?B?MUtQTko1eVQ4VTJKOXRWU3lSVVZHT2x3OGlPdU9Ic0svMzdlK1UrQXk4N2hs?=
 =?utf-8?B?a3M4NFRPeXZnVDlHSTJvSTlDMk9RRis1Z05mdzNLcUR4YkhaSkRDcGFGMmNF?=
 =?utf-8?B?RVExU0xYV0JIdllOOFh0eFE1WDZUTDgrMkNHZ0VoZU16MHNybXgwQzEyOURS?=
 =?utf-8?B?MFdpOW9TRWFvUmU0OVJQR1pCQ0x4OHVWamRvNWFFdTNKRkhsQ1BmZDNvZkFC?=
 =?utf-8?B?aGZvbDRqNmhEK0VZWUptZXNlcGR2bTFwNC9UMFo5REl2RmNiOUdua2ZRNHcr?=
 =?utf-8?B?TEpjd1M4MFA5dEQ1WFBLN3ZJUVZXbGxDN0o2WG5EVDRKTkg4dGdkZnB3N0pI?=
 =?utf-8?B?L3l6ZW1GUGJtaHRFWEp1azFSSUVxcXZDNUhkNno3bkltVUh2RXc2eEs3N0M1?=
 =?utf-8?B?Q1NURTN2NHJGemdKQVRjSnVscnBnZ0xNZWV3V2VQcmxwNFZ5MHFTQStFSnhh?=
 =?utf-8?B?T2RGektIRFh1SElmaFRjUmFISEp2eGYzZlhwekRCamRCMUYvc0dWSEx0aVFW?=
 =?utf-8?B?Wnphc1RqL1k4UFZEajFWT25XNFRsNElseVoxQWpPbnQ5VDBFdE1GOE1jelZB?=
 =?utf-8?B?STVWQ1A4WGxxL3lkM0JZZkhXTEFna3V1YnBTbjZFempSOFpRTDFRenUyOUdC?=
 =?utf-8?B?WTduRStKTm1IRTZScDNsSEFNakJpbGY0QnFVZlA4QXhQWk9raEtGS0p1OVAx?=
 =?utf-8?B?TFFFUkwwQXQyeTNXUWZYdHZCQVRDdjdmdHFaVGRYRG5tc3l6ZG9yZlpFTEtV?=
 =?utf-8?B?ZmFQekxhWG5QcERJSG55OUlQQUhGVnMrNnI3N1Y3Wk9CTjNIZ1FYVnhiTmtW?=
 =?utf-8?B?UzR1Y3RVTFZSbGZIbnpKRURmRVFNZ3daRDM4ZDhHVHJIeU9PNE1rbmtyU25E?=
 =?utf-8?B?RkV3M3pwV0RmbXVEQm1Eb0YxN2p6REVDYmdyNVp5VEVzZmhNQWxUVVljNWhF?=
 =?utf-8?B?RUhDQ2huYVlMQVg5eXFhMm9uRkU0SmJ4VHhsVU42T3dVT2ZHOS9IZGpGZ1Ra?=
 =?utf-8?B?ZUFYcXNneVNBWkxqbEs5N3RWV0xQWjFtaEtOM0xQWmUvcnY4M05GUy9rZGxw?=
 =?utf-8?B?emxyakpiNEZFVjhlWlRKOHpXb0IxaGNrZmh1RUtUSjQ1bDByb2dsWjJCUlBu?=
 =?utf-8?B?Rkc5L0Vmb3FDZWp1NCs1SDk4WXA1VHliQVNpVlRObFBWT3A1UUlpbjdxTWpD?=
 =?utf-8?B?QWtMNHB0VytvNG1RUDM4Y0NUUkcrRUdjMFBOb2o2RTgvc3BObk9FYlBWM2cr?=
 =?utf-8?B?WjNyVDkwbnlOSUhmQlZzLzhoYkorazRvTTlQR3hkVVlOWEZGSnRJdFZNWk9N?=
 =?utf-8?B?OFJyREFpT0hWcFFjZ3hxVXo1bkN1anVmSm45NWV3RWNWcDdQeDVqWHBQKzRQ?=
 =?utf-8?B?SWhsNGZDajVJaHJUdGVzZExZTnVzM1Awd0d5RTBmdVBmSUllQWNhZlZQRWNw?=
 =?utf-8?B?eTBjcnZSWHpNTjkxZUV6UFFUY2pDOEd2dEdxd0d3VmlQTC9hbGZhODJHamNH?=
 =?utf-8?B?NkpKaVlNTXNqZklMZTdjTDR4N0ROamtuYlJNMlYzRnZFYlg2bkdPWVVEL2NZ?=
 =?utf-8?B?SmRsRjF4RFRxc2dETTRkTm1Gb2RnWUJKOFhOQkEwWVVTa2JETGdNOWtNcUZY?=
 =?utf-8?B?VDN1SnNzL1ZRUG9nZ0hhaWlHK3dCUEtYeEgwN3hzRG14QVBxS0ZGTCtXU1li?=
 =?utf-8?B?N3NZSVFDczZPTjFmRmNpRlkzNVk5M01Sc0NFVjBGeE9qaHlLZUhZZnFCS2gr?=
 =?utf-8?B?eHdUdWxRZ25GOFlMTnpjcGFEaVpGaFpsbThuS1NVK2dXdWUvZXEydmNubHlw?=
 =?utf-8?B?SHYrT3NqM0JaVE0rTlN2VkVoMzBuTXpreGlvTjcwQTZxNGMwUllaV0hrR1Zw?=
 =?utf-8?B?bzU4elIzTk5EU0Ric1h2TS9RYkVqVW9MUmNHeUkrbmVUb2pPSlF2cEpMbkpS?=
 =?utf-8?B?dWtRS1NmVGhvQzZleVcwSEFCTTlCRCtDWm1oVmFZN0pheGxJTEtHOEs4VGtk?=
 =?utf-8?Q?oXEnAb?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV0PR02MB11133.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(1800799024)(366016)(7416014)(376014)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?STRCbllpOEcvNEh2cDROS25VYW5VTURhVnk1ZFJQL011WjMvK201VEVOK1B5?=
 =?utf-8?B?eWs4alV4bG5iUjVqQm9FUDJ6eVpXS0JUWkFMSFhRU1ZSTzVhU1JQTE5DNy9T?=
 =?utf-8?B?WUptTTM0WWJhUW5xSFNmSXpRK0k3Q3Vua2NMc0g2cm81VVF1UkZMeDBhRGlL?=
 =?utf-8?B?bmpnSzM3R2hsK3djY3dJZ1lZSGFYa1NaRXBMa0hKMkMvTi9qYXZqeUU1Smox?=
 =?utf-8?B?U3ljWU9ETmlWYUlsU09SSGR0bFcrSXFya0pEUDR3OG9tcFhTbXZ5VG4yZnhD?=
 =?utf-8?B?YUJ5V294aXhvMkNhYzgyb1p6Ni9wblhSbjBwZkh4YzFhSlRrZk5iMkdsUjJ2?=
 =?utf-8?B?MjFTM08vQndXYkhscFh0a0VIVU4rdVRXZGlJNEhOZVd5WWdhV1UvNnpQS0hM?=
 =?utf-8?B?Lzh2UFpQaG5jMSs5ZXdLZlo3U3lhQys5ODlqczBlN1MxODBqMDVmcmkxNE5U?=
 =?utf-8?B?OTFSZm4xaXlvT2pNeFlxRjVpNDVkWEVXWlRVenlFQW52TVlVMWs3ZXFydFlk?=
 =?utf-8?B?OUx3MnUrTSs3YS9Gc0FkNkV0UXBwTW9DSDZQeUVKYVdMeXl6cmliS2c5cHg4?=
 =?utf-8?B?YzVqUVZzN3NFUWN4TXo2UEk4dmRUTzBnQkFNTzNWSjZkdUxNbVFJcFJqTUtB?=
 =?utf-8?B?QmRVZG9WSlcycitGSVFpUlNEa0M0MnluaVRYd3FnYlZqNVhucWYyalRqeGx1?=
 =?utf-8?B?UEhXRzlSWDd6RzRSTEhTUSt6eEdwVWFvd1VuK1ppWTF6TDcrdWdSWW8yVlRY?=
 =?utf-8?B?eElzNjVFdHg2WjBLZUJPVGE1OVZGKy9xUWRnRVExK1c4UFZGTExwV3I3MDVZ?=
 =?utf-8?B?M2xJT05RaXV5aUlyQVZudU5aT1dlUHVETHJQcWZUcWJLSlNCOG0rcUdKVTRX?=
 =?utf-8?B?RkQrYmFqN1U4Z20zMUJ1YlE4ZmZrMFlFNWdnODdxUm5FR1cvenJRYmRnYWJC?=
 =?utf-8?B?d2crRUU0cWVORVEvTVV0RFdhKzNDd0hQQXB6L1NFTHBmNnRWR0F3c3VUNkhy?=
 =?utf-8?B?RUdRcDhZaUFoK2xoaGlGVGVneHdNM2Z1NjQwVTJISWlWNWlXTVUzcUU4YXMr?=
 =?utf-8?B?dmk4R3hIZVhrNEZBVjRSbU5mRW5qQzBJOVlCU0NLVUhwaHJYRDJUaVFaZU5R?=
 =?utf-8?B?OFIySFNpczJ0bmJ5WFAwekdMT1JIdjJ6cXZoUFZtZlUzVVU5ZnVmS2l6eXJq?=
 =?utf-8?B?S05DSjV2MVN5QU1OUXQrOXU4dTdQWHg5MGd0TEV6eURXOHEwYnIxNjkvZDlm?=
 =?utf-8?B?UERlczdlODgrWmM4TDFZVjlEOXp2azZ0UFN3d012YnlVT3pkU0N4by9Qdzkz?=
 =?utf-8?B?M0dneGxNdnJiN3QwSy9adHRPcjhLMktCNTJQL0xwRm9JcDRaV05SZklZOUJ4?=
 =?utf-8?B?YW5mSHFSNU5DU0RCZUJheWxuVitWM2dxR09IbVcrNzI0d242Q2haakNmUmJa?=
 =?utf-8?B?Ukc1czUwU3lHRER4SkFvVVhuWjF0cmlTYzVNbmFISDA0clR0cGtidmJlZmZm?=
 =?utf-8?B?WktJNzZDenpMUFp3QmVmYmQ2REo0NWJRRld2VTZJRWJvTFByd2djem1QaTVk?=
 =?utf-8?B?SnF3WVZjUi8yWThpN2tDNkZHUTlrRk9sLy9NeWY5dW0zNzcrKzZNMTNOMVRB?=
 =?utf-8?B?UWVLRkoyeTVVdUZ6Y200cCtzb0JIdHNKenFYcWcrbWxRTFVCUnd5ZWpaTFhp?=
 =?utf-8?B?ZnFMaVdaZ002RWN0dlJVY01WL2hUYmlFTHNTYUZzVDM3ZDFPcXJlcEJkV0NX?=
 =?utf-8?B?OGRkaytyYjJyU3QrTFUrYjcyMVlMd2k0c0ZocXZ5djQ4L1g5Y0wySTVMcGhM?=
 =?utf-8?B?Wkl1c0FWMmVZYm1NN2NHcm83N1RiYXUvUzRyTkhDaXZONHRlS1ZGb2tYRFpw?=
 =?utf-8?B?d1NSL3FTRjBRSGsyRlJFYjUwZEF2UDJiZTJNWkpVL1R6L2xQdlhNWjNsL1FM?=
 =?utf-8?B?QUdwOG12RGRmb1M0aXRIbGpLMmFVa3pZNzBpbmxQNzdWQnVrcDhPN3RVdmtr?=
 =?utf-8?B?ZDZjejRpcWZ6U2hjbXU1L1FBa01oRTVlcEJkY0c1dXo2b0FSSUtHaHpyak1Q?=
 =?utf-8?B?VDNuT1ZobFRwb1lhRlBtVStJSUNNU1k5MUg0bDZOQ1JxdTIyVFRDZFJTSmU4?=
 =?utf-8?B?blFNS2JKZVkwRHJGWWllVzhIQjJqbHZKRVc1RnBmSm9ER04rN1J3bWRFWDhL?=
 =?utf-8?B?MG9ycmt6WHJzLzZUUDk2a3h0Q3hHU2d3M05OUk5OajYxcG9oRmJNUXJVQUFs?=
 =?utf-8?B?YUhuU2Y4MjlGV2N5VmpiOFc1TEp3PT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <104ABD224BE8A448AB4AD4D117E67B00@namprd02.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: fdea1cab-dfe9-4a46-ef5e-08de238d83fb
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Nov 2025 14:53:04.4398
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Lva3R+J3XO428EPpNEUhxrhxXiK5a2+C5HebM9OcsLsUQScTSte1rCs91G5xkuK9Vm0JOuq2ReITDTXpzMrKwp9lsUxf63BMktZw98gfzbk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR02MB6523
X-Proofpoint-GUID: uNZ6pM8ggaMWwLHS6WdU1LC_5lb5y8nz
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE0MDExOSBTYWx0ZWRfX6e9HopjtD1dE
 cyBHqnZOjMvR9UDm4VwLO34iN8GWsXvDI5vJHxFkCVlKw5ojxcUKr9hgiKFGivgUtdgX9ZiqW28
 wsTYCq+j0suPFgXhg7ZyrAbo94/8OKuDZBdUYJtKFxNZHZIpiV+lpUWVll5SixbCHX4uk8aqrlz
 30+BMPZk5SmRSUnuPuauwHl2YeMfydSZYzqCbBT+UddGP5tP4FU2gWfQF4YybNDfb5IHvWneA74
 Tb5OFlBLIWh3YOmWB0QkM03+dKIp7ikdIWWT7jxYhWJ9vaeIGplqjszEBxXLEwSxZCE3Zmt3X9O
 xQ8j53YtRMopsHVKje4+AtsJuZmg6jugrK8m/lhPSlCP9nomj3QiUr0/QwYisGlc8hESH2xp2HH
 nfAFWcLR8kCKEvqihSgADwMEsT1eVA==
X-Authority-Analysis: v=2.4 cv=HbAZjyE8 c=1 sm=1 tr=0 ts=69174252 cx=c_pps
 a=+aoWgcdf8QL7nCWWbKbTBg==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6UeiqGixMTsA:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=20KFwNOVAAAA:8 a=64Cc0HZtAAAA:8 a=UzVwSd0kqnFRxpt--QAA:9 a=QEXdDO2ut3YA:10
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-ORIG-GUID: uNZ6pM8ggaMWwLHS6WdU1LC_5lb5y8nz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-14_04,2025-11-13_02,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gTm92IDEyLCAyMDI1LCBhdCA4OjA54oCvUE0sIEphc29uIFdhbmcgPGphc293YW5n
QHJlZGhhdC5jb20+IHdyb3RlOg0KPiANCj4gIS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS18DQo+ICBDQVVUSU9OOiBFeHRl
cm5hbCBFbWFpbA0KPiANCj4gfC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0hDQo+IA0KPiBPbiBUaHUsIE5vdiAxMywgMjAy
NSBhdCA4OjE04oCvQU0gSm9uIEtvaGxlciA8am9uQG51dGFuaXguY29tPiB3cm90ZToNCj4+IA0K
Pj4gdmhvc3RfZ2V0X3VzZXIgYW5kIHZob3N0X3B1dF91c2VyIGxldmVyYWdlIF9fZ2V0X3VzZXIg
YW5kIF9fcHV0X3VzZXIsDQo+PiByZXNwZWN0aXZlbHksIHdoaWNoIHdlcmUgYm90aCBhZGRlZCBp
biAyMDE2IGJ5IGNvbW1pdCA2YjFlNmNjNzg1NWINCj4+ICgidmhvc3Q6IG5ldyBkZXZpY2UgSU9U
TEIgQVBJIikuDQo+IA0KPiBJdCBoYXMgYmVlbiB1c2VkIGV2ZW4gYmVmb3JlIHRoaXMgY29tbWl0
Lg0KDQpBaCwgdGhhbmtzIGZvciB0aGUgcG9pbnRlci4gSeKAmWQgaGF2ZSB0byBnbyBkaWcgdG8g
ZmluZCBpdHMgZ2VuZXNpcywgYnV0DQppdHMgbW9yZSB0byBzYXksIHRoaXMgZXhpc3RlZCBwcmlv
ciB0byB0aGUgTEZFTkNFIGNvbW1pdC4NCg0KPiANCj4+IEluIGEgaGVhdnkgVURQIHRyYW5zbWl0
IHdvcmtsb2FkIG9uIGENCj4+IHZob3N0LW5ldCBiYWNrZWQgdGFwIGRldmljZSwgdGhlc2UgZnVu
Y3Rpb25zIHNob3dlZCB1cCBhcyB+MTEuNiUgb2YNCj4+IHNhbXBsZXMgaW4gYSBmbGFtZWdyYXBo
IG9mIHRoZSB1bmRlcmx5aW5nIHZob3N0IHdvcmtlciB0aHJlYWQuDQo+PiANCj4+IFF1b3Rpbmcg
TGludXMgZnJvbSBbMV06DQo+PiAgICBBbnl3YXksIGV2ZXJ5IHNpbmdsZSBfX2dldF91c2VyKCkg
Y2FsbCBJIGxvb2tlZCBhdCBsb29rZWQgbGlrZQ0KPj4gICAgaGlzdG9yaWNhbCBnYXJiYWdlLiBb
Li4uXSBFbmQgcmVzdWx0OiBJIGdldCB0aGUgZmVlbGluZyB0aGF0IHdlDQo+PiAgICBzaG91bGQg
anVzdCBkbyBhIGdsb2JhbCBzZWFyY2gtYW5kLXJlcGxhY2Ugb2YgdGhlIF9fZ2V0X3VzZXIvDQo+
PiAgICBfX3B1dF91c2VyIHVzZXJzLCByZXBsYWNlIHRoZW0gd2l0aCBwbGFpbiBnZXRfdXNlci9w
dXRfdXNlciBpbnN0ZWFkLA0KPj4gICAgYW5kIHRoZW4gZml4IHVwIGFueSBmYWxsb3V0IChlZyB0
aGUgY29jbyBjb2RlKS4NCj4+IA0KPj4gU3dpdGNoIHRvIHBsYWluIGdldF91c2VyL3B1dF91c2Vy
IGluIHZob3N0LCB3aGljaCByZXN1bHRzIGluIGEgc2xpZ2h0DQo+PiB0aHJvdWdocHV0IHNwZWVk
dXAuIGdldF91c2VyIG5vdyBhYm91dCB+OC40JSBvZiBzYW1wbGVzIGluIGZsYW1lZ3JhcGguDQo+
PiANCj4+IEJhc2ljIGlwZXJmMyB0ZXN0IG9uIGEgSW50ZWwgNTQxNlMgQ1BVIHdpdGggVWJ1bnR1
IDI1LjEwIGd1ZXN0Og0KPj4gVFg6IHRhc2tzZXQgLWMgMiBpcGVyZjMgLWMgPHJ4X2lwPiAtdCA2
MCAtcCA1MjAwIC1iIDAgLXUgLWkgNQ0KPj4gUlg6IHRhc2tzZXQgLWMgMiBpcGVyZjMgLXMgLXAg
NTIwMCAtRA0KPj4gQmVmb3JlOiA2LjA4IEdiaXRzL3NlYw0KPj4gQWZ0ZXI6ICA2LjMyIEdiaXRz
L3NlYw0KPiANCj4gSSB3b25kZXIgaWYgd2UgbmVlZCB0byB0ZXN0IG9uIGFyY2hzIGxpa2UgQVJN
Lg0KDQpBcmUgeW91IHRoaW5raW5nIGZyb20gYSBwZXJmb3JtYW5jZSBwZXJzcGVjdGl2ZT8gT3Ig
YSBjb3JyZWN0bmVzcyBvbmU/

