Return-Path: <kvm+bounces-27351-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 53D869842DE
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2024 12:01:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7719D1C23AD0
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2024 10:01:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 382A71474A2;
	Tue, 24 Sep 2024 10:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=marvell.com header.i=@marvell.com header.b="Hsj6bRKM"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35DA015C13F
	for <kvm@vger.kernel.org>; Tue, 24 Sep 2024 10:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.156.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727172112; cv=fail; b=T7D7GR+F6vEZLVTUb+5R/UooqmLwh0DhRUpWOTddYKiqgsSvPMo74EPL0Z5C0uTRCavrQWehFr4selA1bixV6vHR109DsLBnjGZjOpdQE5aT7v5iLFbcbYCiJ4BgqVgb76iyPWkpj+4mtesTmN6J/P+ScsgmuGnnk2oQZJ78RLA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727172112; c=relaxed/simple;
	bh=SqFeARNbr4S4ZG1nDSL1Cq1nV/mgiMXZa+FISVd/FjY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ns/GuqvjdEiTHSpEQbNnJHArVhhgScoe0x7qpJH7kP//orab7p+ldmfM55FD7ddWT8iSy4LHC7x6NBiKtSavdJXPa2/YGdfMxw2FirYFwzRtWzh3pcTVWG2/dl2lbnVZ9MA0Aknwn/Ojfsv+cANHLEPe6XpencYSf6p9bmmiiTg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (1024-bit key) header.d=marvell.com header.i=@marvell.com header.b=Hsj6bRKM; arc=fail smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48O7WK3f018530;
	Tue, 24 Sep 2024 03:01:44 -0700
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 41swnjv8w7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 24 Sep 2024 03:01:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hYb4c/xODKTmMgvetqfKXnTNBibKCXBvycEYLktwilgmwapszoEpOkC8E65cxwHlFoHZn9An9s0cXYCTvh1ap1Pl14y0ZuQBgN6QYM0DF8fsr/TdnHrQEtB0vpVzA0yL25qbZB03qSO7EkcZzgEkjl8IxqE5wS4bX3RjMCWhvF50tM3RvpSnwQFqYMH4rYAmKpAunfUTmN6d/nuujsLrR3XWzuO/vwwXzyLnQlr8cu+t6xNxogQGPeqrs68FvRWsDkvLcuNq7kDb13f1/srZi4ha8KQZzWWP/QhoCarS2d/7V7xkx/8s9DBNLOKHbvHdQDuGE7X13VztDM78eJ42uA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SqFeARNbr4S4ZG1nDSL1Cq1nV/mgiMXZa+FISVd/FjY=;
 b=XUVdub5KuqzAkH2xAQDhZRT8hHgxCpDKmUx8fZjVYE4mQVksRly3i6z3CaGQ2V7K6/XsSNU62vOYI15DEvKupfebM35nXcGFjstVrD9krnVC8b2le25kXjWowJlpnJ2yKUsA7e2Cchaq8+C9w9Yircbag4UMY7O1Oe7frUkly4W7CDSzWWLz/LikNiK4yP8fpcoB/qIxIYMjNfjFiOproplbXRXdDKpRgRB97Ey4dRppao1rru/sdPP8PdTXSWn8ahGZLCY0pW1tMioT8y0Lbo9zgAKblOXvcAsdXeMF+XnQqSr2TnooD33C0eLSz0lWNrNHROM+2NQeZ97TMiS51g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SqFeARNbr4S4ZG1nDSL1Cq1nV/mgiMXZa+FISVd/FjY=;
 b=Hsj6bRKMqsmkZyqCVZjB1351TIxJpjzTU0XqKJ+q+QRAN1mNtLepjXfukX/9H7ew6zYAjN4V/88TJfr2w5cnCyzuVN3wOXdNuhnbq2wOIKUnUwCQLJLiD8XWBrAqkRgZsK445JqkJBkHWhJC4ggIHCgdxF7cczKI7ZsVJ/pQvro=
Received: from PH7PR18MB5354.namprd18.prod.outlook.com (2603:10b6:510:24d::11)
 by SN4PR18MB4837.namprd18.prod.outlook.com (2603:10b6:806:21c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.25; Tue, 24 Sep
 2024 10:01:41 +0000
Received: from PH7PR18MB5354.namprd18.prod.outlook.com
 ([fe80::7f70:2c74:a8e2:a610]) by PH7PR18MB5354.namprd18.prod.outlook.com
 ([fe80::7f70:2c74:a8e2:a610%5]) with mapi id 15.20.7982.022; Tue, 24 Sep 2024
 10:01:39 +0000
From: Srujana Challa <schalla@marvell.com>
To: Jason Wang <jasowang@redhat.com>
CC: "virtualization@lists.linux.dev" <virtualization@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mst@redhat.com"
	<mst@redhat.com>,
        "eperezma@redhat.com" <eperezma@redhat.com>,
        Nithin Kumar
 Dabilpuram <ndabilpuram@marvell.com>,
        Jerin Jacob <jerinj@marvell.com>
Subject: RE: [EXTERNAL] Re: [PATCH v2 2/2] vhost-vdpa: introduce NO-IOMMU
 backend feature bit
Thread-Topic: [EXTERNAL] Re: [PATCH v2 2/2] vhost-vdpa: introduce NO-IOMMU
 backend feature bit
Thread-Index: AQHbDlWA7SXNUeBFfkidAxJsDIaD8LJmpiuA
Date: Tue, 24 Sep 2024 10:01:39 +0000
Message-ID:
 <PH7PR18MB535480592FEFC291CD6EFD48A0682@PH7PR18MB5354.namprd18.prod.outlook.com>
References: <20240920140530.775307-1-schalla@marvell.com>
 <20240920140530.775307-3-schalla@marvell.com>
 <CACGkMEuB8BikU7or6wso9ortoQfX+cCw-Q=x3o_rtdmVTqLZiQ@mail.gmail.com>
In-Reply-To:
 <CACGkMEuB8BikU7or6wso9ortoQfX+cCw-Q=x3o_rtdmVTqLZiQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR18MB5354:EE_|SN4PR18MB4837:EE_
x-ms-office365-filtering-correlation-id: c1876616-ddad-4765-52f6-08dcdc7fe250
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?YUJLZzhRTGhjb3hzWXVpanRaSDVxOGNPT0lOTWJmUWo0eVd4RTdmZ05zU3FW?=
 =?utf-8?B?VTZPMHlFdkdiVzNGVkVMNUlHS0xDYjdxZ3NtSUZmcFZiUFVBMXdyMFJhbjdn?=
 =?utf-8?B?dWRnTXlpemtKNEZVTUplQ2JDd080UzRmaHFVdkFVaFlpTUNGVWdGOEZTalRC?=
 =?utf-8?B?cUdPdzM0WlQvZHdVR3hXTWhWWDNSSkh3VWtNUTZaVVc4MGV0YnpCbHhXTkZB?=
 =?utf-8?B?VDUvQlhGUzNvaXNuOExYbC9WbWkrSzBWeE1iUml2bEZvc2ozdVYyU0pMR3A2?=
 =?utf-8?B?aVpHSy9NL0RmN2Z0MlJ5REZCTW1lTmJaS1lxWTM5K1ZHZ08zbkZkYUxnS0FY?=
 =?utf-8?B?YzF3OThneGczZzRNV3dDMy80QVR3R2lhSkNRajJaZnl0dFJWWHYzOUtNQVV0?=
 =?utf-8?B?TkgwVlBjaU40cS9XUk02WnZGbmlWQlFRellzMmpaWnpvZmxvOVM2SFJSdzMw?=
 =?utf-8?B?by9sWDBnVExEaG54VXhobnVVM09iM3J2cWtZYTYydHFoRzZGWVJ0YzFKY3dF?=
 =?utf-8?B?eFBUM1d4TWppWXAzTmZwY0FOdUk1bnZOL2ozU1RVT05QamNJSGtSNTJzOFpL?=
 =?utf-8?B?azJlcW5sU1JTWE1wRGlMdStzdkxrR2d2M3lUK1R5M2lvc0oydVFYSHdacVdR?=
 =?utf-8?B?MGdIRHZnbHZRaGdNYmJtVjJ6U3AzRG1FalpVTVREZUl4TWRCWTBPMXJsVHoy?=
 =?utf-8?B?TkRPSHRlNWdHMGozTExWSkxjVlZUcXYyYmltdUFpVnVnS21BdG5IMFVxWGp1?=
 =?utf-8?B?WFJDQ3ZEL3Q1dDVvL1JUK2hXMzJiK3czdHlZMHBCaHpwVHV4R04rdFRnZThn?=
 =?utf-8?B?Y3lFZ1BaTkJMWHl1eXpvZmQ1WkFCVjFXUktCRy95NzB6TEpHQitZQ3BNL3JM?=
 =?utf-8?B?MVJvRUVVSUV3bWRDam1QWVlzVDVBUjR6L3JsSW5HdWNQalhGSkdFNmVBaCto?=
 =?utf-8?B?STZVQ21vclk1RUw5TzlHbkt6VmtVOTdBOGc5bytpU3JLTDhmb0tBRTNCVXNE?=
 =?utf-8?B?bUhpMVRNWHRBR1dEc2s2dmdWa3ErR0Y1d0pINGY5b3JrM1NJbmlMNVBRZzl3?=
 =?utf-8?B?NjliZzRVQUZIL2tWSFhNNFluenpYUVQvYkFyQ1paUkFHcjc5K21GemxZbHQ2?=
 =?utf-8?B?aE5HeXdXSGRJbUc4NXRlNFJmeTAwak9weVBPY2VGMzJUSnEvaWw5RGRmVXNk?=
 =?utf-8?B?Z2FlOHJneHIxclFZSHI5TnFwTmRucGhWdEVlSFZ4R1V4UGo1NENtakFnQ3Vp?=
 =?utf-8?B?dkRTZjJiQVRPL1dCTGR3SFp0R3B0Sng3Y2pJSnhDTlBIVUZySStOSjBFWUto?=
 =?utf-8?B?cnB4bVRzeGhybmpiUzRqMmlDa1Jqc1Z5VTZkaU5JRkpLd250cmI5cFRJc01q?=
 =?utf-8?B?OG9YMVBTNEJteWFzNE1EL3VCN0VHM0g3di8wVmF0T255K1pFT2UwOWQ5NkEz?=
 =?utf-8?B?WFVkNEcwUzJ1OThJSUlXYjltUjJXNThuQVhYRFlWdWxKMXBPU1dlZzJxUmhU?=
 =?utf-8?B?TjZwekJZQVlid21neWZWU3V1cWJTNWcvaFg4TnFjbmI2OWpySFlhUTY0a2U3?=
 =?utf-8?B?VFpOVDVkZlRwODJNakFmUU91L1FISC9mL2UvN2greW5SZEgwRlg3TG8rWmVs?=
 =?utf-8?B?eDcwV0xuTXlIMkpRamVJWnZKTk05RVFpcHBqVXpQU3EwWGg4cEZCTm1MdVB2?=
 =?utf-8?B?VXYwUUFkWUpiS2RZZkVNQzZoeFNzUDhkSlVCYlVMZGFVREpqMVdqS2ZQZTF4?=
 =?utf-8?B?U3llck5JODdLK0Q4eFdhVnZIU01HRk93cFpLWXBON3hFWkh0aDhmSmFSN21E?=
 =?utf-8?B?ekU3b3VQTnZ2RVdpMStLQT09?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR18MB5354.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?ZWgvWk03K2FqbVFlZFA5UE14NGpYNXRkWmw4UmE5SDdLY1JRSzZsS0Z5dTJW?=
 =?utf-8?B?WnpRVGVFbHVFc0RiUkxjdHZkYWNsVUQ4eUFPYkFVWENUdjdycmppWmQxNjlX?=
 =?utf-8?B?L3JXSXMvbE1yMUd1cit4SXhibWJUcndDd3d6OEtvaXRkYkZKM2xGSXE0RmVv?=
 =?utf-8?B?bS9tS1JlR1I2NDdwSzBhVmdGNVZqai90Tmw5TnJpZ2YwbDlHSDhwbVFSRGtQ?=
 =?utf-8?B?MG9iakpNSVdkMkNKMk50aHhkaUtadVV1S01jVXJDblVmVWVaWTlMMUZ4TUJl?=
 =?utf-8?B?eGkwVDh6V2pXVHdCVmxvKytpOU8rT0RJUm8xTStmVWx6RzR0c0RmLys5V3Fw?=
 =?utf-8?B?b3ZXN1lPMGs1ZFlqdys2NGNQNG1HZWJrZlFqTG5LSFE2UFBLY1Zub3VEU0xn?=
 =?utf-8?B?U3MzcnAyV095UEtPRktnL3VwcnlUTEN5WWZWNFVYZmh2TnNKUFYrWE02UzFj?=
 =?utf-8?B?blhnMXU3a1BLbU9SQ05TMUFzOTJvL1NYbmYxdXJ3SktiL2FCcHFaSGEyb1hx?=
 =?utf-8?B?M2lIOVFDT3ovK3F0cStvL1dZMkZuRCtGK1hmeGg3dGgwR0hDaEZqa21lVUVr?=
 =?utf-8?B?Y3puOHF2Yy82VUlITTQxbW51MDZocExyOTVzVkQ4RE42NnhSNWxpRWd3Yi9T?=
 =?utf-8?B?MlZWT1lHa1RLcHJFaUdCaUlvUldMMWt0bldRTGo5STVOZFZIQjgwNmlVWHZJ?=
 =?utf-8?B?azI0eUdLOWNMQjU1cU8yNEZCRytIZk4vaEdhRk1qN0dzTXhJa09HYjdRMktD?=
 =?utf-8?B?elVEU3VhNFRDVllldk9Yb2UyRXhrb09naURmc2RUWWlzaEcyNERzNVFlUnFm?=
 =?utf-8?B?dWRRQTNNVXMwellQWTBwZzY4Z2NIT3NWTFl2ZWpzZWlUZm1GcXc0Wm84bkpw?=
 =?utf-8?B?VFpqY295SFRYcW5BTG9IRHUrdlIxNXd3U3ZrNHFIWitzWVFzRU5oVWlRRDRw?=
 =?utf-8?B?KzdhOE13U2M2dHFKM0RIeGRENDFQa1VKdHQwWW1NMlZ6MkdwWE9VdTZHd243?=
 =?utf-8?B?dFl6VGtnZzFaOWZWaC8rY29oTkJXTmJpRmVZcSsrTHZZMDNtNHIyKzR5NG9k?=
 =?utf-8?B?WjVWRG02cDlDUFJkekk5MHdBUFRmLzdyZGEzYjVyNjVnd2RubGpUa0R5djJv?=
 =?utf-8?B?aTVBemJjZVVHcWcvNkJ1cWd0ZHhPczlOYUExb2k1Z1BQM1hNck43YmNoRGZl?=
 =?utf-8?B?Rm1ObkZjYStDdW1JZXFzcXRlYkFLWjRXczJvbXVpRU5IMjVDZ1NvMTAyWFlx?=
 =?utf-8?B?TmEwb1pDdUNxM1FQMUk2QXZCaUEzSW9WSXNDQ2duem95ajM2dWFzemk4c1Z5?=
 =?utf-8?B?bWJjbWdOVExwU0xIUWpWRC83eVRvU05rbWE5blBmM1BDeXIvdnlFdjdFV0o1?=
 =?utf-8?B?NkpHeU14UDZwWHJKR3hyRDQvbUgxV0ZqYXYyd1o3cFhZOTMydnRXanpXSy9E?=
 =?utf-8?B?QzQxcGwzakNoRU5DUDJXbm5hc0FrQ3J0eWhDTnZXZHlJSDdrc2pCc3JUWGFi?=
 =?utf-8?B?Q2RTNmRmS2ZGNnVVR1lTM2tRVWtnYzBnYW9va2tzdEx3UFcxbDVGT3ltK01q?=
 =?utf-8?B?Q3pkRTlDNzRuWDEzWlJHTzg4OFlqUDVRSWo3Z2lidERCbWlrTnFTSkpWd0ll?=
 =?utf-8?B?QkIzTkd2dUdQMTNMT2RpUDd2QXd1RjEyUlkyb0tFRFVmYUsxeXZtVG0rYm1U?=
 =?utf-8?B?K2M3Snc1U0tkR0R3Mk5ycTRkQitTN1FOVkFJMWttNVBOREtudzk5UndaK0I4?=
 =?utf-8?B?TWk1ZXdrWTdQV0tZcWZDWkRWTDJqZ00vNHBqeGVNYVgxb0ZCL2dUa2prbU5O?=
 =?utf-8?B?K1lNbWhlcTYrVmdQOGZKOTRTQnpUL1plZWJxaEN0bGY0bFBkdnUyWStGc3o2?=
 =?utf-8?B?UmxiM2dhYWFQUGRvbGVib1JZRzhZVDhlajJzY3VxbkVuTWRMdlNiZCtURnc2?=
 =?utf-8?B?S0ZGeHgxNDZIRUF5ZTdhakNIeU9ZODJIbGdkbE1lcjEwZVVUakJQOWhiUFEy?=
 =?utf-8?B?NUVQclZGWFgxdjYxc0tjdnpSZE5NV21wMm9CcURWZFZ2L1lieXcreGlpUUE4?=
 =?utf-8?B?ZXJUVldIYVZsMFpaTnhudElhcmkvMGNUOE5Udkc1cktWYXBqSjNjbHgrdnA5?=
 =?utf-8?Q?YVzg=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR18MB5354.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1876616-ddad-4765-52f6-08dcdc7fe250
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Sep 2024 10:01:39.5488
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UlvIIaGPJ0oOMfwfY0NDvsM8f3BBlpHwdAeVbRo27XXOXh69nU6g19CPlx9ayPlQrdndXGqPhOWLLiJrf75l6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR18MB4837
X-Proofpoint-GUID: 8JBq1hw-s2r5a4p0b9Zh9_DIO9WXS1er
X-Proofpoint-ORIG-GUID: 8JBq1hw-s2r5a4p0b9Zh9_DIO9WXS1er
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-06_09,2024-09-06_01,2024-09-02_01

PiBPbiBGcmksIFNlcCAyMCwgMjAyNCBhdCAxMDowNeKAr1BNIFNydWphbmEgQ2hhbGxhIDxzY2hh
bGxhQG1hcnZlbGwuY29tPg0KPiB3cm90ZToNCj4gPg0KPiA+IFRoaXMgcGF0Y2ggaW50cm9kdWNl
cyB0aGUgVkhPU1RfQkFDS0VORF9GX05PSU9NTVUgZmVhdHVyZSBmbGFnLg0KPiA+IFRoaXMgZmxh
ZyBhbGxvd3MgdXNlcnNwYWNlIHRvIGlkZW50aWZ5IGlmIHRoZSBkcml2ZXIgY2FuIG9wZXJhdGUN
Cj4gPiB3aXRob3V0IGFuIElPTU1VLCBwcm92aWRpbmcgbW9yZSBmbGV4aWJpbGl0eSBpbiBlbnZp
cm9ubWVudHMgd2hlcmUNCj4gPiBJT01NVSBpcyBub3QgYXZhaWxhYmxlIG9yIGRlc2lyZWQuDQo+
ID4NCj4gPiBLZXkgY2hhbmdlcyBpbmNsdWRlOg0KPiA+ICAgICAtIEFkZGl0aW9uIG9mIHRoZSBW
SE9TVF9CQUNLRU5EX0ZfTk9JT01NVSBmZWF0dXJlIGZsYWcuDQo+ID4gICAgIC0gVXBkYXRlcyB0
byB2aG9zdF92ZHBhX3VubG9ja2VkX2lvY3RsIHRvIGhhbmRsZSB0aGUgTk8tSU9NTVUNCj4gPiAg
ICAgICBmZWF0dXJlLg0KPiA+IFRoZSBOTy1JT01NVSBtb2RlIGlzIGVuYWJsZWQgaWY6DQo+ID4g
ICAgIC0gVGhlIHZkcGEgZGV2aWNlIGxhY2tzIGFuIElPTU1VIGRvbWFpbi4NCj4gPiAgICAgLSBU
aGUgc3lzdGVtIGhhcyB0aGUgcmVxdWlyZWQgUkFXSU8gcGVybWlzc2lvbnMuDQo+ID4gICAgIC0g
VGhlIHZkcGEgZGV2aWNlIGV4cGxpY2l0bHkgc3VwcG9ydHMgTk8tSU9NTVUgbW9kZS4NCj4gPg0K
PiA+IFRoaXMgZmVhdHVyZSBmbGFnIGluZGljYXRlcyB0byB1c2Vyc3BhY2UgdGhhdCB0aGUgZHJp
dmVyIGNhbiBzYWZlbHkNCj4gPiBvcGVyYXRlIGluIE5PLUlPTU1VIG1vZGUuIElmIHRoZSBmbGFn
IGlzIGFic2VudCwgdXNlcnNwYWNlIHNob3VsZA0KPiA+IGFzc3VtZSBOTy1JT01NVSBtb2RlIGlz
IHVuc3VwcG9ydGVkIGFuZCB0YWtlIGFwcHJvcHJpYXRlIGFjdGlvbnMuDQo+DQo+IFRoaXMgc2Vl
bXMgY29udHJhZGljdG9yeSB0byB3aGF0IHlvdSBzYWlkIGluIHBhdGNoIDENCj4gDQo+ICIiIg0K
PiBXaGVuIGVuYWJsZWQsIHRoaXMgbW9kZSBwcm92aWRlcyBubw0KPiBkZXZpY2UgaXNvbGF0aW9u
LCBubyBETUEgdHJhbnNsYXRpb24sIG5vIGhvc3Qga2VybmVsIHByb3RlY3Rpb24sIGFuZCBjYW5u
b3QgYmUNCj4gdXNlZCBmb3IgZGV2aWNlIGFzc2lnbm1lbnQgdG8gdmlydHVhbCBtYWNoaW5lcy4N
Cj4gIiIiDQo+IA0KPiBBbmQgSSB3b25kZXIgd2hhdCAiYXBwcm9wcmlhdGUgYWN0aW9ucyIgY291
bGQgdGhlIHVzZXJzcGFjZSB0YWtlPw0KSSBhcG9sb2dpemUsIEkgc2hvdWxkIGhhdmUgc3RhdGVk
IHRoYXQgdGhpcyBmZWF0dXJlIGZsYWcgaW5kaWNhdGVzIHRvIHVzZXJzcGFjZSB0aGF0IHRoZSBk
cml2ZXINCmNhbiBvcGVyYXRlIGluIE5PLUlPTU1VIG1vZGUuIElmIHRoZSBmbGFnIGlzIGFic2Vu
dCwgdXNlcnNwYWNlIHNob3VsZCB0cmVhdCBOTy1JT01NVSBtb2RlDQphcyB1bnN1cHBvcnRlZCBh
bmQgcmVmcmFpbiBmcm9tIHByb2NlZWRpbmcgd2hlbiBJT01NVSBpcyBub3QgcHJlc2VudC4NCg0K
PiBHZW5lcmFsbHksIHRoZSBJT01NVSBjb25jZXB0IHNob3VsZCBiZSBoaWRkZW4gZnJvbSB0aGUg
dXNlcnNwYWNlLg0KVGhlIHVzZXJzcGFjZSBmcmFtZXdvcmssIGxpa2UgRFBESywgY2FuIGRldGVy
bWluZSB0aGUgcHJlc2VuY2Ugb2YgSU9NTVUsIGVuYWJsaW5nIGl0IHRvDQpjaG9vc2UgYmV0d2Vl
biBJT1ZBIGFuZCBQQSBhcyBuZWVkZWQuICBTaW5jZSB0aGlzIGlzIGFpbWVkIGF0IGVtYmVkZGVk
IHVzZSBjYXNlcywNCnRvIGJlIG1vcmUgc2VjdXJlLCBib3RoIEtlcm5lbCBWRFBBIGRyaXZlciBh
bmQgdXNlcnNwYWNlIGFwcCBzaG91bGQgcmVxdWlyZSB0byBlc3RhYmxpc2gNCnN1cHBvcnQgZm9y
IE5PLUlPTU1VIGxpa2UgdmZpby1ub2lvbW11Lg0KVGhhbmtzLg0KPiBUaGFua3MNCj4gDQo+ID4N
Cj4gPiBTaWduZWQtb2ZmLWJ5OiBTcnVqYW5hIENoYWxsYSA8c2NoYWxsYUBtYXJ2ZWxsLmNvbT4N
Cj4gPiAtLS0NCj4gPiAgZHJpdmVycy92aG9zdC92ZHBhLmMgICAgICAgICAgICAgfCAxMSArKysr
KysrKysrLQ0KPiA+ICBpbmNsdWRlL3VhcGkvbGludXgvdmhvc3RfdHlwZXMuaCB8ICAyICsrDQo+
ID4gIDIgZmlsZXMgY2hhbmdlZCwgMTIgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KPiA+
DQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvdmhvc3QvdmRwYS5jIGIvZHJpdmVycy92aG9zdC92
ZHBhLmMgaW5kZXgNCj4gPiBiMzA4NTE4OWVhNGEuLmRlNDczNDllY2VmZiAxMDA2NDQNCj4gPiAt
LS0gYS9kcml2ZXJzL3Zob3N0L3ZkcGEuYw0KPiA+ICsrKyBiL2RyaXZlcnMvdmhvc3QvdmRwYS5j
DQo+ID4gQEAgLTc5Nyw3ICs3OTcsOCBAQCBzdGF0aWMgbG9uZyB2aG9zdF92ZHBhX3VubG9ja2Vk
X2lvY3RsKHN0cnVjdCBmaWxlDQo+ICpmaWxlcCwNCj4gPiAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICBCSVRfVUxMKFZIT1NUX0JBQ0tFTkRfRl9JT1RMQl9QRVJTSVNUKSB8DQo+ID4g
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgQklUX1VMTChWSE9TVF9CQUNLRU5EX0Zf
U1VTUEVORCkgfA0KPiA+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIEJJVF9VTEwo
VkhPU1RfQkFDS0VORF9GX1JFU1VNRSkgfA0KPiA+IC0NCj4gQklUX1VMTChWSE9TVF9CQUNLRU5E
X0ZfRU5BQkxFX0FGVEVSX0RSSVZFUl9PSykpKQ0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgIEJJVF9VTEwoVkhPU1RfQkFDS0VORF9GX0VOQUJMRV9BRlRFUl9EUklWRVJfT0sp
DQo+IHwNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBCSVRfVUxMKFZIT1NU
X0JBQ0tFTkRfRl9OT0lPTU1VKSkpDQo+ID4gICAgICAgICAgICAgICAgICAgICAgICAgcmV0dXJu
IC1FT1BOT1RTVVBQOw0KPiA+ICAgICAgICAgICAgICAgICBpZiAoKGZlYXR1cmVzICYgQklUX1VM
TChWSE9TVF9CQUNLRU5EX0ZfU1VTUEVORCkpICYmDQo+ID4gICAgICAgICAgICAgICAgICAgICAg
IXZob3N0X3ZkcGFfY2FuX3N1c3BlbmQodikpIEBAIC04MTQsNiArODE1LDEyIEBADQo+ID4gc3Rh
dGljIGxvbmcgdmhvc3RfdmRwYV91bmxvY2tlZF9pb2N0bChzdHJ1Y3QgZmlsZSAqZmlsZXAsDQo+
ID4gICAgICAgICAgICAgICAgIGlmICgoZmVhdHVyZXMgJiBCSVRfVUxMKFZIT1NUX0JBQ0tFTkRf
Rl9JT1RMQl9QRVJTSVNUKSkgJiYNCj4gPiAgICAgICAgICAgICAgICAgICAgICAhdmhvc3RfdmRw
YV9oYXNfcGVyc2lzdGVudF9tYXAodikpDQo+ID4gICAgICAgICAgICAgICAgICAgICAgICAgcmV0
dXJuIC1FT1BOT1RTVVBQOw0KPiA+ICsgICAgICAgICAgICAgICBpZiAoKGZlYXR1cmVzICYgQklU
X1VMTChWSE9TVF9CQUNLRU5EX0ZfTk9JT01NVSkpICYmDQo+ID4gKyAgICAgICAgICAgICAgICAg
ICAhdi0+bm9pb21tdV9lbikNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICByZXR1cm4gLUVP
UE5PVFNVUFA7DQo+ID4gKyAgICAgICAgICAgICAgIGlmICghKGZlYXR1cmVzICYgQklUX1VMTChW
SE9TVF9CQUNLRU5EX0ZfTk9JT01NVSkpICYmDQo+ID4gKyAgICAgICAgICAgICAgICAgICB2LT5u
b2lvbW11X2VuKQ0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgIHJldHVybiAtRU9QTk9UU1VQ
UDsNCj4gPiAgICAgICAgICAgICAgICAgdmhvc3Rfc2V0X2JhY2tlbmRfZmVhdHVyZXMoJnYtPnZk
ZXYsIGZlYXR1cmVzKTsNCj4gPiAgICAgICAgICAgICAgICAgcmV0dXJuIDA7DQo+ID4gICAgICAg
ICB9DQo+ID4gQEAgLTg3MSw2ICs4NzgsOCBAQCBzdGF0aWMgbG9uZyB2aG9zdF92ZHBhX3VubG9j
a2VkX2lvY3RsKHN0cnVjdCBmaWxlDQo+ICpmaWxlcCwNCj4gPiAgICAgICAgICAgICAgICAgICAg
ICAgICBmZWF0dXJlcyB8PSBCSVRfVUxMKFZIT1NUX0JBQ0tFTkRfRl9ERVNDX0FTSUQpOw0KPiA+
ICAgICAgICAgICAgICAgICBpZiAodmhvc3RfdmRwYV9oYXNfcGVyc2lzdGVudF9tYXAodikpDQo+
ID4gICAgICAgICAgICAgICAgICAgICAgICAgZmVhdHVyZXMgfD0NCj4gPiBCSVRfVUxMKFZIT1NU
X0JBQ0tFTkRfRl9JT1RMQl9QRVJTSVNUKTsNCj4gPiArICAgICAgICAgICAgICAgaWYgKHYtPm5v
aW9tbXVfZW4pDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgZmVhdHVyZXMgfD0gQklUX1VM
TChWSE9TVF9CQUNLRU5EX0ZfTk9JT01NVSk7DQo+ID4gICAgICAgICAgICAgICAgIGZlYXR1cmVz
IHw9IHZob3N0X3ZkcGFfZ2V0X2JhY2tlbmRfZmVhdHVyZXModik7DQo+ID4gICAgICAgICAgICAg
ICAgIGlmIChjb3B5X3RvX3VzZXIoZmVhdHVyZXAsICZmZWF0dXJlcywgc2l6ZW9mKGZlYXR1cmVz
KSkpDQo+ID4gICAgICAgICAgICAgICAgICAgICAgICAgciA9IC1FRkFVTFQ7DQo+ID4gZGlmZiAt
LWdpdCBhL2luY2x1ZGUvdWFwaS9saW51eC92aG9zdF90eXBlcy5oDQo+ID4gYi9pbmNsdWRlL3Vh
cGkvbGludXgvdmhvc3RfdHlwZXMuaA0KPiA+IGluZGV4IGQ3NjU2OTA4ZjczMC4uZGRhNjczYzM0
NTZhIDEwMDY0NA0KPiA+IC0tLSBhL2luY2x1ZGUvdWFwaS9saW51eC92aG9zdF90eXBlcy5oDQo+
ID4gKysrIGIvaW5jbHVkZS91YXBpL2xpbnV4L3Zob3N0X3R5cGVzLmgNCj4gPiBAQCAtMTkyLDUg
KzE5Miw3IEBAIHN0cnVjdCB2aG9zdF92ZHBhX2lvdmFfcmFuZ2Ugew0KPiA+ICAjZGVmaW5lIFZI
T1NUX0JBQ0tFTkRfRl9ERVNDX0FTSUQgICAgMHg3DQo+ID4gIC8qIElPVExCIGRvbid0IGZsdXNo
IG1lbW9yeSBtYXBwaW5nIGFjcm9zcyBkZXZpY2UgcmVzZXQgKi8gICNkZWZpbmUNCj4gPiBWSE9T
VF9CQUNLRU5EX0ZfSU9UTEJfUEVSU0lTVCAgMHg4DQo+ID4gKy8qIEVuYWJsZXMgdGhlIGRldmlj
ZSB0byBvcGVyYXRlIGluIE5PLUlPTU1VIG1vZGUgYXMgd2VsbCAqLyAjZGVmaW5lDQo+ID4gK1ZI
T1NUX0JBQ0tFTkRfRl9OT0lPTU1VICAweDkNCj4gPg0KPiA+ICAjZW5kaWYNCj4gPiAtLQ0KPiA+
IDIuMjUuMQ0KPiA+DQoNCg==

