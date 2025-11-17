Return-Path: <kvm+bounces-63404-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 682EBC65A5E
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 19:02:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 8D8BB4E9462
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 18:01:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D8612D6E6A;
	Mon, 17 Nov 2025 18:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="ioltG/OS";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="No0YbZ+V"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF6FA19005E;
	Mon, 17 Nov 2025 18:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763402481; cv=fail; b=swfI4ya5HDSX2wzNmNkiEScMlZcPcQYz72E0zIqeZ73HBxZowuS1R1f5T5Z5RNxH/WvcvcjN8GPexPLs0AAn2IoFCH++fq9Wnfq8aoje4eQrcEo77n1z46oavzcrBOiOe8SaEyi4d5iW7iWsoH5tokow/PJ5i3Yws9hRNOxgll8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763402481; c=relaxed/simple;
	bh=vNlld6GWqYXhTRG6GWmLdQHIDN2PrV/9yqJFmJXWtWc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=iOoAkcqhl88b58IUL9RsoLWDMpUNLovGdie90mApzCvTKEI2qqnG1Io9k5+jDTAV7kyZNlC+Bx+6TJmpvTmA2uQYHtqI86CXGZupcSQI8HbAfVFfbPbNTusTsZyR+4OIaHlaetoNbDIFe6TXstclxYqzxKuQcHr6BSQp/bp/NEQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=ioltG/OS; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=No0YbZ+V; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127837.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5AHAhbeu456137;
	Mon, 17 Nov 2025 09:34:58 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=vNlld6GWqYXhTRG6GWmLdQHIDN2PrV/9yqJFmJXWt
	Wc=; b=ioltG/OSjsEH+joGr+AN+epVYW3+BGEkvzri8UFYTus66pQGmG+U4yyAH
	WEK9WRcsbg/1R1xqSvFceHOoWTlwzzxyjOdDuYf0K/7ihI71JR2X0et/lEjgDK4K
	2Lvxw8SFd/IBg/JxrBI5Ewqp9gyuJuPhRttQG6XWq+m3VAS9XowByfHGTBBsMMs4
	yMxmGf0/LfMU0JMZ1BC1RbbnKqllHmWeM0Fbw68z0IZYs4cyOya9uMzdtXZniH2u
	9MUcLdd5/iQIfOpm/oFkiuVGSRx5FO7Qb8NiKjbxLfyJgWR/Ph2KXU196zs8iB0T
	DH0boMKm3WSZzIWiKdlUH4mf9Heqw==
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11022114.outbound.protection.outlook.com [40.107.209.114])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4aepa8kxgv-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 17 Nov 2025 09:34:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XRS5Bd1LWCa+DtqcdIDhLDdVz0SRtNvH+2rpaVOGg5mhbLVX5b9AJZwAdzRO3oE3oywGK+q9t16ajBd/7YkYL3WKVDEqXCxcD9RZTE9DHOrgIol6mDT3txvtVlymR1N5FmZIvlcPz81aoe/LPGmV0BF0E9OEPnriRjDrpCPlTD8h9uWH7YKlYVOveBkqvwNwyJ8A+6WDEgTbDhbnRXGvhiPHEC6SZY5rxtl7BI5DdTvaIO7R+YCLYfRMVkYb6WcxHqw1FKRyeXFqO2xswWpe3bgJshh+YvFa1Y+GF8tXiTw7UKDlrkvGuphSkyoyzQA32FwWKU3hCO4qCf94I0cZsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vNlld6GWqYXhTRG6GWmLdQHIDN2PrV/9yqJFmJXWtWc=;
 b=r5KWafTYbIYqgnXWQQWMwfGkrYJHEFT12mwk4CgMhh17nfXKMMx7hUYodFcA8pUQbfUcRsM9sGwoAQ4a7SAvuPXsMsDbN+nPtXWpqfzCIOm34FLLNVnNoHYbDfZtlAD6v6yq7vB+tN9LO6TzX9V7QHhU4yM/zFS+FpS6LsZ7X+SGneSbwtqu+M+sO+8XaeDgCiIs+TXOS8GcKDFVR9miZiB66+EJQoMrVPNkq5c9rKlbc5Cl1MXSykfUy9SSqhJjO4LL8IcpOqk0L47eG1lLUOcZmAr84KAzpAw65/O7gFP2qUTkPmZpXaqsPYdHKfNzl9ivrSOCpzcJ+Wk6xo7gpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vNlld6GWqYXhTRG6GWmLdQHIDN2PrV/9yqJFmJXWtWc=;
 b=No0YbZ+V4XQswXsoqAmEqxTgbfWq0LI/bArqxS0MWou6doViOw97ScXisqYkcaIbb9wNYOKzUhHdiGWF0zOS4EXjOgQph/QNP+v9EOYBQ/t/MKJ90zPMpyAB2cHFgXw5xG0Av9wtBg4nnXZipA0C+U6cUQFF8JTvgeTYrW9ZucZJuNH06QpDONABAa6EbvFUYbprdIuZ2tX7MZaO/Q9tqaR0fBo53+07CMRjZKzimKO9G43g/TNfdAjtmkhiEMYwQt7WscsKptpZ9o+skIXQy/XrGt2K1+thCf/COuSb2A4gEStP9qAhwt1k1b/Pj0Ym0OdcEJdR/RHMi4qJtzeVLg==
Received: from LV0PR02MB11133.namprd02.prod.outlook.com
 (2603:10b6:408:333::18) by IA0PR02MB9898.namprd02.prod.outlook.com
 (2603:10b6:208:48c::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.22; Mon, 17 Nov
 2025 17:34:55 +0000
Received: from LV0PR02MB11133.namprd02.prod.outlook.com
 ([fe80::10e5:8031:1b1b:b2dc]) by LV0PR02MB11133.namprd02.prod.outlook.com
 ([fe80::10e5:8031:1b1b:b2dc%4]) with mapi id 15.20.9320.019; Mon, 17 Nov 2025
 17:34:55 +0000
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
Thread-Index: AQHcVDJryQXjlObInEG9J4YkYYZKUbTvzAyAgAJ4RQCABAmigIAA2pWA
Date: Mon, 17 Nov 2025 17:34:55 +0000
Message-ID: <A0AFD371-1FA3-48F7-A259-6503A6F052E5@nutanix.com>
References: <20251113005529.2494066-1-jon@nutanix.com>
 <CACGkMEtQZ3M-sERT2P8WV=82BuXCbBHeJX+zgxx+9X7OUTqi4g@mail.gmail.com>
 <E1226897-C6D1-439C-AB3B-012F8C4A72DF@nutanix.com>
 <CACGkMEuPK4=Tf3x-k0ZHY1rqL=2rg60-qdON8UJmQZTqpUryTQ@mail.gmail.com>
In-Reply-To:
 <CACGkMEuPK4=Tf3x-k0ZHY1rqL=2rg60-qdON8UJmQZTqpUryTQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3826.700.81)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV0PR02MB11133:EE_|IA0PR02MB9898:EE_
x-ms-office365-filtering-correlation-id: 849275d4-f59c-42c6-7747-08de25ff9f79
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|7416014|10070799003|1800799024|366016|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?bmxnbGpQRW9vajNSR1l2RnBUbjdoQnEva1M2Z0JJa05nY1B3SnBlOG1HcFRT?=
 =?utf-8?B?SjRjaDFONEhiSlZvNENPS045MUlCb1pLYXpPLzYxdi9zRXZOYy9DV1RSUnRV?=
 =?utf-8?B?Y25qaWcySWExNEozN0FEUXQyOEYzQ0QvZ3RkSUNwN3ZPb3BtL0N0dmorazZE?=
 =?utf-8?B?dGNFbk5lTW5mWnppaXhLK3JsS1hMNGIyTm0wYUNLbThDUEtlUm04UExMYjNC?=
 =?utf-8?B?dEFLUzA4cHBaYUwwc2UxWHV5VkQ5cklLWTlOcC9VamhiUXlIN2FDTXhyZ2Ny?=
 =?utf-8?B?ZXpkR1Y3VjlaVU80WXFlQkszME1kdGQ5bDZFbjZMWjlaVHlnaFo0TG5zUlYv?=
 =?utf-8?B?YnVKQXJBYVN3aW9USlo0VHZPaXk2RUtJYTIyRkpSWEcvekNabzRBRExydGk1?=
 =?utf-8?B?WDNTcmJBS1lVV1hkYmtOenkyZHpjbStUYlB1eW9JMTY4STd5VTlkdU5sWFZF?=
 =?utf-8?B?SHRQaVZNNi9HeWpRWFRneXZQWVJTWExzTEs3M1lnb1VVR0pibE5Kb2NpbWdk?=
 =?utf-8?B?TGU4MkV6U1locnZTbWdEblUvK1JWOWI0eUQ3VldTVHE3cnhLaW5PSm4zK2hQ?=
 =?utf-8?B?OTNPbjRRcWJPS0c3aStHdmwzblM1WjVFL01EaUh6cGhONGJHYVJnSytHQ2Fw?=
 =?utf-8?B?UXl5d0tQTEFVbngwR3pwaVNYTUVnb21sYTFSOGR2UTYxTkg3K0xLNnRZa0FT?=
 =?utf-8?B?TEFXbjRVWU9tNmFmM1AwREYxSzBRakxYazl1NUp6ZHlMUUltVDQ5TmZrcXRS?=
 =?utf-8?B?QmNvS0VmWXd6ZEIxcUhjOUUrZTI4Y1A0Y0hBNldhUU1iWVp0ak0zYjVXbllW?=
 =?utf-8?B?c1BmZGRDQ0ErZFQ3MXNuYXlMMjNNUlRSVG5laGxJNXBpaFAvVVUzT1JxTjhl?=
 =?utf-8?B?VkF6K0xGd2t2Tm5sN1l5RVhkMUFTWHZJUUkvbW5kK0YzdkpaTjRDcUViOUJq?=
 =?utf-8?B?STFIYkIvTnFadWRqTnhWcmRQdXJrdytVdzNYK1d5V2ZpK0l0TnR2T3NZeDhW?=
 =?utf-8?B?YjlJUDhkaUdGRTE3NXd0ZGhsZHM5aUxSWU0xRlRyU3BsUGFMeGEvSzhNS0Rs?=
 =?utf-8?B?VGEwVm1udWdFOFFiZUg2MzJOYzBzdVRaeVk5aFJnNWlvUFdEajZFRXVXZ2pt?=
 =?utf-8?B?TWpGVlMvMDE3NSs1SHFkb2FKNkd4TVV0c2lKREJlUUY2cWs4TUhKNTdnTk9n?=
 =?utf-8?B?TUpiTVF3dmpZazM2OG8wbStHcDlZdy9lc3NveitYdTc1VUh3ODBzV3hmck0x?=
 =?utf-8?B?aFl2NUtmVXFGYlh1SFB6L0owSXliTnZzVjV4OGxsZU1TNnB2amJ0T0syNCtT?=
 =?utf-8?B?VnF1L3RtQTBnd2pTWFdzaC9uL3ZXQVFWWGl4YUpGdmlMRmhJUFFESHZBMk4x?=
 =?utf-8?B?enN1L1ZuU2p6RG1CNDJNRVI0eWcrdVRRQVY3cDJKS3lwU2diMmpUQVhDcVJv?=
 =?utf-8?B?ZHJ4RG1hcFZTWjJoTUZIYmJMc1JEd0prK25UM3VQeW5lcFNQZ2x0bEx2Ym8y?=
 =?utf-8?B?Q080RERBUUlVRFlzVlFCTlZBNHpSenBBUEU3VDlETFVCT1lJcDlWeTdLeGFB?=
 =?utf-8?B?YURlOU9UV2ptcXJkZjNESCtjWXNLUjZTaDhTMWtRMVVlRnhpZGNSeXNtRUwv?=
 =?utf-8?B?OUhhazZnWCtiTTNMcHpBQ0VVZDdxdlk5Q3UxVDlleUVxTGNMVVRkeTRYb0lF?=
 =?utf-8?B?cXhOZSs5QkcvNnFzS3NhY0o1NFVNT3ZHSkVRNlB3K1IraklBenliU29manMx?=
 =?utf-8?B?dFhZNWtXeHRIMGp5MUc0bVZwS0c3bVp6S3oyWmVCRFQ3SGFBeVU4T2pxUlIv?=
 =?utf-8?B?Q3Vqc0srTDJOTFAvUGRjSjhCZXh1RjZRazgyOHdOSk1BZDdSZE5JZVEzTjdn?=
 =?utf-8?B?NzB5WkFNSVRBNEd2VGxFVmRlMXV2MER3dE5LZkl5T25tYjAzczNhd0ZnZ3VC?=
 =?utf-8?B?YUcrc3B3UkllVTJnbWdyUDNySTFPNmxPM3JjajZ1VVhBQ20vS1ljNCtzN2Rh?=
 =?utf-8?B?eUNoaG5IckdjTytvY0xHc1EwU3FYcDFja2F4MC8zVzFnOWFjdzFiUnhzUjVq?=
 =?utf-8?Q?WvTkBV?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV0PR02MB11133.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(10070799003)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?LzdPSmdIcnFGTmxHQ0I3Q0NUU0U3SW1SbWErQ1Jlc24zdXVod3RkYkRvcHQz?=
 =?utf-8?B?ZWF5THo2bG5pTzQyYWFZNkVtQWFpeGlzTGpURk5aVVp4NjJVdDZhVjBGMjN6?=
 =?utf-8?B?S0VyRVp5bWs4MldqeW1xUUFkTzZLdk9NVnFTd2FPTkdTSGUxeGZpR3RJb3hM?=
 =?utf-8?B?RVVrYXJyREhCK1JiYXVsTHBZb0MwbXBHS3Z2dm54anNCRDR5YmN4R3U1VXBk?=
 =?utf-8?B?U1g5SnFmODdRQzNRTTV0QW5RenhybjFONktoc0V0VEFheVRRMGNJbDUxRFVU?=
 =?utf-8?B?Qm5wWDZDWFRMNC9zeGh1NmYzNGZCR3NsSXhtTDdadXhUQ1BPRm9xeWFzV0FQ?=
 =?utf-8?B?RzRnajJFQXdkQ29DQWx1TS8zVVdyMjBWMHlHL1E5M0tCTTlieDVSVTJsZ0xQ?=
 =?utf-8?B?TDZhUGp2Sm1rMk5IZGxtTjZKUTlFQ3FvSVBFWU8yRjRGYlpMK2dJTm5xTDFR?=
 =?utf-8?B?SERCNWowZ0Q5NkJkSnltdEZzekZnVUpYN1JZVzg3MkF3MkpPYjJxbEticC9R?=
 =?utf-8?B?aU5tcy90bmNCU3hTWmNkMmVXTVh6ejZoM1d5L0FqTnRLalZ4OTdVNjhWS3dH?=
 =?utf-8?B?T2FhcG9tUEFDZ201S1ZWSTNkdDFSTHhJckxmQVEzQU51VWZHZCtDNzBlUnd6?=
 =?utf-8?B?aTAwekthRFJ3cGhBemNoVlUyVVZxcHh4eXNDanJrR1VwaWQ3MEpOQTNyeStt?=
 =?utf-8?B?dkR3MHZPc3dyTDJ1ckFTamZ2bVB5NFE4ZE1wTUFOc3FKNGl2T0VFZzVUdXIr?=
 =?utf-8?B?LzhBVlJUK1pPNTNVRjBwL3dreEhaeXZwWGFmaHl6LzFWOGFUNUdrNnc5Q0V4?=
 =?utf-8?B?ZWFqWTMwQ0xKVGZ0ZWpHblhvbGkzT2pZcUpiNXlIK1laOFg1R09YVEViZ1Yy?=
 =?utf-8?B?cDlNN0YzYW54aXlnMzFNZzhsbys1UUh6RERhR2NieTZxZktoaGlvMnVHRW5u?=
 =?utf-8?B?QlJoSmsvSlVUTlJOQW9VbmhMV2pxU0hJQ3ZIWWxkWFJ6RDhTVmxHeUcxUjZk?=
 =?utf-8?B?VktxM3JiWUwvbzdKdXdMNmIxRExmOFJQSi9CZFJtb1JzWTRFMWZxWXcxWGFz?=
 =?utf-8?B?SHF1RlNvYzhnYWNmM1NpeGhmODh0Rnl2OS9UNkg3L3J0MXBHai9XRTdDamYr?=
 =?utf-8?B?SFFmQjJoZ09ybXFxeGFqczdwQ0pYTXcrNlU0NnROZmVIR0hsSUpXSnZkc05O?=
 =?utf-8?B?WlFsY2Fmay9Dbm50d3JUaE5CQXVrZmgyTWJDR3NNOXdEZDc5TEl6a0xDT1JT?=
 =?utf-8?B?bkt0WDZQZjZLVmJrcmZHZkZBajFQZmtUNFpTMGg0eG1KcDladitGVUlqWEJO?=
 =?utf-8?B?WTJSTWhoMERvWWllS1NTaXJaR1V1WEdKeDFraHkxMVNoVFJQNVh5Z0NLVFBm?=
 =?utf-8?B?bWlMVC9mR1NEV3V0S0JOaVJmNjlzaktRcGlxVDhtUVM5OTBBU3BySlhsVkE3?=
 =?utf-8?B?dWZ0L3J0MkxZQU5DOHUxckhCWGlYbEdLM1h5SytmRGV1eFRpazJhb0dHNkI4?=
 =?utf-8?B?Y1VhQUF0d1hPNnNFS21BVHFnZEhteC9MRDZJcW15U1lqSzF4Y05MTTNvdWpt?=
 =?utf-8?B?YTlLOEVGUjBDckgvOWNIaE5icmN5NnNTeHlZV0tHdmNvSTZyWVRHeU9WWVRi?=
 =?utf-8?B?RmcxT0ZUQjRGaGt1V3JLWE1IREpnTi9XNlhVL3ZiYmYxb2ZacXl3QXY5MTdK?=
 =?utf-8?B?MGl4cDB0aTRoREs5ZlNjeTBVRjB4YWlLVTVkQW9CeTIwUUhZN0hodFpUbmR3?=
 =?utf-8?B?cTI0TDJwUm0yblMyUkVkZVQ0ak5YempIUnlDc1BCb1FmTnkyU3hlbWpLNy9B?=
 =?utf-8?B?ejhEYUFhTU45SmtPUVE2MVhEOWpyR0hTYnFQaEZuVnZuZTR5RDZxME1saDFr?=
 =?utf-8?B?V2tRM2FIRmlGUE5xN09xanBhakYzRWt4THNQNnBubGlEOGozQXlUZHBXcTcv?=
 =?utf-8?B?SFAvbXNkU004b3ppaGo4ci9wQnUxOVVRTk1xdWhMZTlNTGVKNWJ5QkwrWmF4?=
 =?utf-8?B?QW9DNzhHQ21Ccytvem1OMkNqL2dtUllWZC9vQ0VaZWtnY3owNDFKY0d1bmNB?=
 =?utf-8?B?YzRDR0R2Z2V3T3FnZ2NJOHRjUFZJclJlR2Q2d0RuWUFuTFI2U2FUelQzVjhV?=
 =?utf-8?B?Z2x5QWJlMitmSmNnd0xveGsrSFFTakdxNDlqRFdtZlBiUzBDa1RKSUhFdDFz?=
 =?utf-8?B?K3N5Wm5BWVpjeFUvYmpsb2NFM3dSa2FuWFNiSm9IUnF4Qkp3TGdTbk5BK05y?=
 =?utf-8?B?MHVCUjBkRjNuZUhmVndBMXE2MTR3PT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <56DB871389AF284A83E7DE9AADC9795B@namprd02.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 849275d4-f59c-42c6-7747-08de25ff9f79
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Nov 2025 17:34:55.5074
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: u+FTNTRzmD5mrnliYA0P5gnYlR2V06ALkCELXMLS3HZWHOo140rmzVkPba0SJSeXA4ktk00G9h1pzlKpCEOtPCSFyw81MXftGpnE9F5tLe4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR02MB9898
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE3MDE0OSBTYWx0ZWRfX++49tQ7gzI2G
 JPWXRTHi7Dljechb9LwyLwv0N6HbjZRGr5CwP1b0e5pOQfKVBJS9z36EU7Afd/CHCUryKvbZk3a
 dNycT0IByL8Ht8AQlRVJJA2ZHKXyrOK9+DyUg/iU/app8nTB3b0NBrY151lhhW7I1P8rdQxfZ5O
 SQ8wjUhQBNV62FnJ+bnWJLW9QqeTcnCXw03mzQDkRE0+kRSnUOtdW9JZgMp7zHpFck3rkDmxzhB
 TWBiwr4Zb5vRsrQxXmcsmSY5iYK3ytOS6t0JZ+fzNLY3Tdqyf9na2PlPWMcKMRUbfftYBeFlecE
 8EMJVvymEWaLTOEZrmzmulCQ/Qqw13luuqw0rGO5AtutQZNto3s1ssdq98yTkwFthzzxSfTJzuL
 DMiIk5AU1vTJqT5Py3MZpgDjwkgdPQ==
X-Proofpoint-ORIG-GUID: -b3ksOTk4MM_8NWOhX4HoDjXhTAf_h4_
X-Authority-Analysis: v=2.4 cv=PaPyRyhd c=1 sm=1 tr=0 ts=691b5cc1 cx=c_pps
 a=4EVvFC7fyiOjnGrcsbJlsg==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6UeiqGixMTsA:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=20KFwNOVAAAA:8 a=64Cc0HZtAAAA:8 a=BtCJtR0DzrmPStnaoQcA:9 a=QEXdDO2ut3YA:10
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-GUID: -b3ksOTk4MM_8NWOhX4HoDjXhTAf_h4_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-17_03,2025-11-13_02,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gTm92IDE2LCAyMDI1LCBhdCAxMTozMuKAr1BNLCBKYXNvbiBXYW5nIDxqYXNvd2Fu
Z0ByZWRoYXQuY29tPiB3cm90ZToNCj4gDQo+IE9uIEZyaSwgTm92IDE0LCAyMDI1IGF0IDEwOjUz
4oCvUE0gSm9uIEtvaGxlciA8am9uQG51dGFuaXguY29tPiB3cm90ZToNCj4+IA0KPj4gDQo+PiAN
Cj4+PiBPbiBOb3YgMTIsIDIwMjUsIGF0IDg6MDnigK9QTSwgSmFzb24gV2FuZyA8amFzb3dhbmdA
cmVkaGF0LmNvbT4gd3JvdGU6DQo+Pj4gDQo+Pj4gIS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS18DQo+Pj4gQ0FVVElPTjog
RXh0ZXJuYWwgRW1haWwNCj4+PiANCj4+PiB8LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLSENCj4+PiANCj4+PiBPbiBUaHUs
IE5vdiAxMywgMjAyNSBhdCA4OjE04oCvQU0gSm9uIEtvaGxlciA8am9uQG51dGFuaXguY29tPiB3
cm90ZToNCj4+Pj4gDQo+Pj4+IHZob3N0X2dldF91c2VyIGFuZCB2aG9zdF9wdXRfdXNlciBsZXZl
cmFnZSBfX2dldF91c2VyIGFuZCBfX3B1dF91c2VyLA0KPj4+PiByZXNwZWN0aXZlbHksIHdoaWNo
IHdlcmUgYm90aCBhZGRlZCBpbiAyMDE2IGJ5IGNvbW1pdCA2YjFlNmNjNzg1NWINCj4+Pj4gKCJ2
aG9zdDogbmV3IGRldmljZSBJT1RMQiBBUEkiKS4NCj4+PiANCj4+PiBJdCBoYXMgYmVlbiB1c2Vk
IGV2ZW4gYmVmb3JlIHRoaXMgY29tbWl0Lg0KPj4gDQo+PiBBaCwgdGhhbmtzIGZvciB0aGUgcG9p
bnRlci4gSeKAmWQgaGF2ZSB0byBnbyBkaWcgdG8gZmluZCBpdHMgZ2VuZXNpcywgYnV0DQo+PiBp
dHMgbW9yZSB0byBzYXksIHRoaXMgZXhpc3RlZCBwcmlvciB0byB0aGUgTEZFTkNFIGNvbW1pdC4N
Cj4+IA0KPj4+IA0KPj4+PiBJbiBhIGhlYXZ5IFVEUCB0cmFuc21pdCB3b3JrbG9hZCBvbiBhDQo+
Pj4+IHZob3N0LW5ldCBiYWNrZWQgdGFwIGRldmljZSwgdGhlc2UgZnVuY3Rpb25zIHNob3dlZCB1
cCBhcyB+MTEuNiUgb2YNCj4+Pj4gc2FtcGxlcyBpbiBhIGZsYW1lZ3JhcGggb2YgdGhlIHVuZGVy
bHlpbmcgdmhvc3Qgd29ya2VyIHRocmVhZC4NCj4+Pj4gDQo+Pj4+IFF1b3RpbmcgTGludXMgZnJv
bSBbMV06DQo+Pj4+ICAgQW55d2F5LCBldmVyeSBzaW5nbGUgX19nZXRfdXNlcigpIGNhbGwgSSBs
b29rZWQgYXQgbG9va2VkIGxpa2UNCj4+Pj4gICBoaXN0b3JpY2FsIGdhcmJhZ2UuIFsuLi5dIEVu
ZCByZXN1bHQ6IEkgZ2V0IHRoZSBmZWVsaW5nIHRoYXQgd2UNCj4+Pj4gICBzaG91bGQganVzdCBk
byBhIGdsb2JhbCBzZWFyY2gtYW5kLXJlcGxhY2Ugb2YgdGhlIF9fZ2V0X3VzZXIvDQo+Pj4+ICAg
X19wdXRfdXNlciB1c2VycywgcmVwbGFjZSB0aGVtIHdpdGggcGxhaW4gZ2V0X3VzZXIvcHV0X3Vz
ZXIgaW5zdGVhZCwNCj4+Pj4gICBhbmQgdGhlbiBmaXggdXAgYW55IGZhbGxvdXQgKGVnIHRoZSBj
b2NvIGNvZGUpLg0KPj4+PiANCj4+Pj4gU3dpdGNoIHRvIHBsYWluIGdldF91c2VyL3B1dF91c2Vy
IGluIHZob3N0LCB3aGljaCByZXN1bHRzIGluIGEgc2xpZ2h0DQo+Pj4+IHRocm91Z2hwdXQgc3Bl
ZWR1cC4gZ2V0X3VzZXIgbm93IGFib3V0IH44LjQlIG9mIHNhbXBsZXMgaW4gZmxhbWVncmFwaC4N
Cj4+Pj4gDQo+Pj4+IEJhc2ljIGlwZXJmMyB0ZXN0IG9uIGEgSW50ZWwgNTQxNlMgQ1BVIHdpdGgg
VWJ1bnR1IDI1LjEwIGd1ZXN0Og0KPj4+PiBUWDogdGFza3NldCAtYyAyIGlwZXJmMyAtYyA8cnhf
aXA+IC10IDYwIC1wIDUyMDAgLWIgMCAtdSAtaSA1DQo+Pj4+IFJYOiB0YXNrc2V0IC1jIDIgaXBl
cmYzIC1zIC1wIDUyMDAgLUQNCj4+Pj4gQmVmb3JlOiA2LjA4IEdiaXRzL3NlYw0KPj4+PiBBZnRl
cjogIDYuMzIgR2JpdHMvc2VjDQo+Pj4gDQo+Pj4gSSB3b25kZXIgaWYgd2UgbmVlZCB0byB0ZXN0
IG9uIGFyY2hzIGxpa2UgQVJNLg0KPj4gDQo+PiBBcmUgeW91IHRoaW5raW5nIGZyb20gYSBwZXJm
b3JtYW5jZSBwZXJzcGVjdGl2ZT8gT3IgYSBjb3JyZWN0bmVzcyBvbmU/DQo+IA0KPiBQZXJmb3Jt
YW5jZSwgSSB0aGluayB0aGUgcGF0Y2ggaXMgY29ycmVjdC4NCj4gDQo+IFRoYW5rcw0KPiANCg0K
T2sgZ290Y2hhLiBJZiBhbnlvbmUgaGFzIGFuIEFSTSBzeXN0ZW0gc3R1ZmZlZCBpbiB0aGVpcg0K
ZnJvbnQgcG9ja2V0IGFuZCBjYW4gZ2l2ZSB0aGlzIGEgcG9rZSwgSeKAmWQgYXBwcmVjaWF0ZSBp
dCwgYXMNCkkgZG9u4oCZdCBoYXZlIHJlYWR5IGFjY2VzcyB0byBvbmUgcGVyc29uYWxseS4NCg0K
VGhhdCBzYWlkLCBJIHRoaW5rIHRoaXMgbWlnaHQgZW5kIHVwIGluIOKAnHdlbGwsIGl0IGlzIHdo
YXQgaXQgaXPigJ0NCnRlcnJpdG9yeSBhcyBMaW51cyB3YXMgYWxsdWRpbmcgdG8sIGkuZS4gaWYg
cGVyZm9ybWFuY2UgZGlwcyBvbg0KQVJNIGZvciB2aG9zdCwgdGhlbiB0aGF0cyBhIGNvbXBlbGxp
bmcgcG9pbnQgdG8gb3B0aW1pemUgd2hhdGV2ZXINCmVuZHMgdXAgYmVpbmcgdGhlIGN1bHByaXQg
Zm9yIGdldC9wdXQgdXNlcj8NCg0KU2FpZCBhbm90aGVyIHdheSwgd291bGQgQVJNIHBlcmYgdGVz
dGluZyAob3IgYW55IG90aGVyIGFyY2gpIGJlIGENCmJsb2NrZXIgdG8gdGFraW5nIHRoaXMgY2hh
bmdlPw0KDQpUaGFua3MgLSBKb24NCg0K

