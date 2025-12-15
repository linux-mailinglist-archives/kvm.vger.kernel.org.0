Return-Path: <kvm+bounces-66050-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 84EE9CC026C
	for <lists+kvm@lfdr.de>; Tue, 16 Dec 2025 00:05:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E1A5E301C906
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 23:04:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A14A0314A9F;
	Mon, 15 Dec 2025 23:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="NX+Uk74+";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="Cg2f3Dhj"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21C6428000F
	for <kvm@vger.kernel.org>; Mon, 15 Dec 2025 23:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765839876; cv=fail; b=JJ/AdGZWZztr3Wo9u5j6dQiwJKiiu1FsnoBwmYkeFtYJaob6+WCZIt/FMICU/AjzEPgum+HnLbtWdBsp6SPcJunBF9LkZUwkZmDf2LFCjJOAaQjhEP06ZY41lizd4xT2OxQRPYs85/BLQESFJrmJ+d7NE+g+kSqdsl68e35kAuI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765839876; c=relaxed/simple;
	bh=nipz7Ew5XjD0mG2a57n+FD/N0Mu7YD/WnbOa8pCDDAg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=g2KJs23kHSIP0LbTM/DwAMN/Me/MbMWPA+SEgBcHZkJCEz5gZn/hA45KvHGS3Ti0YgTMMUIwBcTMLQRYSTHC7/+W+26LyjnYmtVgBqzibFks33KnZR3hNz54DLm7eIujlhVGwAkiAKGY04A6KGgyywaKzyO6KW+Psa974T4CfSE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=NX+Uk74+; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=Cg2f3Dhj; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127841.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BFEUEPk1813408;
	Mon, 15 Dec 2025 14:42:07 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=eM2QDrKo2vxlLsxOmNQbTAHvBp5tSQuiSvGLHrTiv
	hI=; b=NX+Uk74+UE0yL1uQn2/b4GJjsgeFq0VCG9WOwIO8beApOUqjZPRadG+Be
	OQwh1oSo3N+xFs+qanEhdmTHoQBspdf+L1KvQ0c0gBdg6L40CuyDa+wlCo4za7j3
	pHE93yJ4wqQpaYPTH2coLbuXysQylsgwESNCUOEd126l0TnciFqezPsWw6Eu4PmM
	PJn3gzhFTy7nPz4xJY+gml6r2b2IvDMG71kqjESF/zmrvTsoiNmJYRlJYTSlfucN
	zXdpz5KL0EAsSiHUl+aqwaTqF2EIX08DdxYFH8QG7dj9egkUsruD6iYWHsAhKW7E
	n4QInXZmHE0TckGxMdZnUhgiYQJLg==
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11022125.outbound.protection.outlook.com [52.101.48.125])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4b2m5994u5-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 15 Dec 2025 14:42:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=q4dIL+NTsNb1GWQXqr7qM+0X0rcxAMXbnSjXRW//r0oIyFQ6zYoMQzzWHPOOxugjwXrxkMx7OBW+XDzgaHF+o3V6pHq02Pp0J2mCWmdvXVb836DerKMs3a8XTcbDrYarF3qFzbIOzTSrrGYvPUFHRURzWRIFUIc6NAi2dGzvc/xrwOnoXdh9YaSpj52a5E2043rvWptBir/quarjv9YjRhlR6Yo7dAgD6WFZ9PCR8XRLrC5VCSBlydwsvIttLF8/FWdlEZtVE64zser96I85psOJR6dvFwHMcyFgIz5kDutWZmDNVy7ZB+RI7bsH+3AEXK/SnVAm6ZAAhzAYqaIilg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eM2QDrKo2vxlLsxOmNQbTAHvBp5tSQuiSvGLHrTivhI=;
 b=hzHQpsYCwbtfgt9ybF0cgihyi4LEVdZHS8cnDIkcECuR8UCXe5g1Io7k21I2Iaw5QrNmqGeZxTuRcYOFLwSMxgLzWejUpeJbUUIEVWyI6ARsAr55TqbatNmNCKGPMGHlEipoUDNHUAosAZKVAQcQM8VRnYWTcHzuL9m4Ts/1XRzqysMZcAtRL1RSS6omf/sB0SyYfkGXRfLRPSgAwHC0c7xXYBn+40ElC96DYoHxJE4VkuO2IZW1GvnHe56V23WGnSyGT9m5hp1ELj8UxD5Et7KbSd54BrrOkW9J+JuykcSrAT6d7yppf+fI6HeUY9M8hq/eE5rPatgi1Nm+6kRjdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eM2QDrKo2vxlLsxOmNQbTAHvBp5tSQuiSvGLHrTivhI=;
 b=Cg2f3DhjIZTBkm356ZhIhVL66+VhtoprjKRhT6ORdjsyM+xHvdbdw/WcPnCWT/hrQUS44BrnWu9wr22EbZkoz65/zzBTaslBuSI15eOQzDCTggcVbuTbv/Q5XHkrEImVZfEGUSfVIg0q7Pz50KOwnwoTO6lCrgLhuhhoVaWAtYIabJbmEz3H8uqSJ+uh5KBkHZcpwK6i/VlocayYZsAHmM25vit2ntmen3Xe+AbqUO+bkHuT6vDkTUQgd6aZWHJCQPz4cyz0jYbhST7sICL911RKZUZQCXGuEHYsG04T+SsCidflJ7qnBSY8wm4gzl1V1be48oiyyjulbtFGdg1GdQ==
Received: from DS0PR02MB9321.namprd02.prod.outlook.com (2603:10b6:8:143::21)
 by CH3PR02MB9714.namprd02.prod.outlook.com (2603:10b6:610:173::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.13; Mon, 15 Dec
 2025 22:42:04 +0000
Received: from DS0PR02MB9321.namprd02.prod.outlook.com
 ([fe80::16f2:466f:95b5:188f]) by DS0PR02MB9321.namprd02.prod.outlook.com
 ([fe80::16f2:466f:95b5:188f%6]) with mapi id 15.20.9412.011; Mon, 15 Dec 2025
 22:42:04 +0000
From: Thanos Makatos <thanos.makatos@nutanix.com>
To: Sean Christopherson <seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        John Levon
	<john.levon@nutanix.com>,
        "mst@redhat.com" <mst@redhat.com>,
        "dinechin@redhat.com" <dinechin@redhat.com>,
        "cohuck@redhat.com"
	<cohuck@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "stefanha@redhat.com" <stefanha@redhat.com>,
        "jag.raman@oracle.com"
	<jag.raman@oracle.com>,
        "eafanasova@gmail.com" <eafanasova@gmail.com>,
        "elena.ufimtseva@oracle.com" <elena.ufimtseva@oracle.com>
Subject: RE: [RFC PATCH] KVM: optionally commit write on ioeventfd write
Thread-Topic: [RFC PATCH] KVM: optionally commit write on ioeventfd write
Thread-Index: AQHcHm7Hwacz3qdkkEq6uKZSQzLqQrT47UsggBaS7oCAAOx5cIATfnEw
Date: Mon, 15 Dec 2025 22:42:03 +0000
Message-ID:
 <DS0PR02MB93219E3C7754DB3EFF7F67138BADA@DS0PR02MB9321.namprd02.prod.outlook.com>
References: <20221005211551.152216-1-thanos.makatos@nutanix.com>
 <aLrvLfkiz6TwR4ML@google.com>
 <DS0PR02MB93218C62840E0E9FA240FAF68BD8A@DS0PR02MB9321.namprd02.prod.outlook.com>
 <aS9uBw_w7NM_Vnw1@google.com>
 <DS0PR02MB9321EA7B6AB2B559CA1CDFDD8BD9A@DS0PR02MB9321.namprd02.prod.outlook.com>
In-Reply-To:
 <DS0PR02MB9321EA7B6AB2B559CA1CDFDD8BD9A@DS0PR02MB9321.namprd02.prod.outlook.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR02MB9321:EE_|CH3PR02MB9714:EE_
x-ms-office365-filtering-correlation-id: 2c0e4037-ca1f-4637-d8a3-08de3c2b2b42
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|366016|376014|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?WZmF2lqRdlQGDZVtnbKSvWwrHbYUdynnUiKUeKWYrXhQxO++3B3xH8bMvWv3?=
 =?us-ascii?Q?dvxyOBt0+CCxbczi5tN2jEYMbCHexWCZvG2lPgtuBr+awYtynHAtx5vejbjb?=
 =?us-ascii?Q?1BgbVifz5apPgzn2v0gsbCopXtpPSoKlwqAGt3rpdfdRgV1zFQil76TOeeGT?=
 =?us-ascii?Q?F7R/JIS/CRYYY4C01KCy/Au3QyfjWYZa9TlpO8N9XDrpe+OTzL1qqYih2+Gy?=
 =?us-ascii?Q?oZKQ7Ovh/7vQ9NrHgkc+mMHpaBlH3pbsk3O1Rq+GSphWaYXxnowNSo8fsHQO?=
 =?us-ascii?Q?kZQn+61+No3PNv2UCOu1ohqEmvxTrpCYPBkGjbZm/DZLyoLsl+4+wVs0XCSd?=
 =?us-ascii?Q?BEJ/qgkVMeXBKtX79Qsdu4H3RekmKAqrTJIkWe34Ayr+/t+X0Mdq4YnGEE5Z?=
 =?us-ascii?Q?tYpru3Y+DNKOd6ddeyFw/g+W1g3CpSpKryLmFl8ziGgzGOyvo/+SNqb+EEla?=
 =?us-ascii?Q?ml6OePLyBBkIS8lxFCS3lBuJ1LY9HkdA0eCnb8y5zbgTLlnpyGljai5gL2S4?=
 =?us-ascii?Q?94Y2ggLuWtsgtJ9AjukRQ3d85vRWTzgaqbocpo8uaj0JgZdYeOv6ZRsa8g/r?=
 =?us-ascii?Q?z5vIpz+l7joOmQfGb7d1FfU/4NF+mny77QhYKG4aYXupTHTfg03FLd9tNi83?=
 =?us-ascii?Q?M4nHpcU/7uiSWJJqj5pgPL3r8nQrJnV6bwUTQ3t3ujwS4u5Z4XPgCNvZd+dl?=
 =?us-ascii?Q?jbimCOL48811rNFPShOSVXKZfuDcQIPsiwBtEcXDx2GzbAb1q6ZBy54XlGXz?=
 =?us-ascii?Q?sbp2wNd/3O/W71SiKP65bLHBbjHsHmJaTn0ADS16Pj3piXI2XVOCdVV9FefJ?=
 =?us-ascii?Q?sW+TB3N59lwi8q3Xrn2iYorI3v+fm2KvqnOsv1rYIvouakCdTMhjoDkUtlG6?=
 =?us-ascii?Q?N9NR51DVOzm5irzNnJvKQaQcq9UZodpajuuCSShMx7wGmWnH91XQa3gcXPZW?=
 =?us-ascii?Q?QNtNT0ewHxC1SbUsn/PoqDOGgNj016tve73HRSrDOx9gt+Gnam6dhGV2u/c7?=
 =?us-ascii?Q?+9uVtn740tIchpgl3V0+H3uex+vM5yFDPuZU1+VH9jFN9Nssai2FNPcq3qjv?=
 =?us-ascii?Q?TLWFHEgV9NmxiIQ47SlB+DSzHkQSWjNhFDotzNTnBQdAAhcXC+BHIPuhVbSU?=
 =?us-ascii?Q?k+CxG0QOIiLFSXYizEsHgXd7rRNvi1froVhGcNNr0ugmoVhzeFuYvq0/USiQ?=
 =?us-ascii?Q?vhOsMSxVbkh1KZkOHe/+2K5NVQuuXMdqvkAUd+1UjfvsQ45FGklJBc23+Q+m?=
 =?us-ascii?Q?Jv1lB3zpoNIpnHS7JHTCXzRxaYCs+Qj+7uarxiCB4DatwD8G4YLJSEiTbSlO?=
 =?us-ascii?Q?pt8ChnXMIasbSlPnP0jYuBCmU6jtESBAlAoayJdpryYhxmD9a3LrUjpz70gw?=
 =?us-ascii?Q?p7rEcdzBx++C6rPEsuFbrxB+u7ABafmwhpt1EUPDSepP1mWVadJ6WkyAcwLo?=
 =?us-ascii?Q?z9/DgaOADK5lDb8pAMdZgTZvzrJP9NcRz+o7ZFbpjhXnzgwUIeh1CYc4j3Ia?=
 =?us-ascii?Q?sjuJ8nVlCFLmrn2XLo/mnI2qpsIMBi2XsSQh?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR02MB9321.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?alZ/TqhdmIpP+AVgq3XwggjVxbEr7X9yoArV7RtvzjUPxwYFHbhcVmJ5wuIr?=
 =?us-ascii?Q?qzp04LgvfrXnZWGfRzTjyMU7qWBtPIRoH40sQSPgQcfwrg23VrW5zHudjhc2?=
 =?us-ascii?Q?JZkMz3mpvLALPFAGuPPI7gBYAuqv/shXnybwErYkMY0B6xl1o2GFpbkrGGpP?=
 =?us-ascii?Q?bFQM4zhTmQXOXTtsM+veBGeH21GU2uPa11+K71RPjAF8LrUOWN+6Jigla2wt?=
 =?us-ascii?Q?ANitdyVt4T7P0/ch0i3nCtEsEmO38jjkhIU7tPfvhB6osq1gNqhCFbza6lO6?=
 =?us-ascii?Q?STGz/gjEUjjPISsYn2v4WZFde40+CjGxW7LmWFQS+lgqCc6ycbbCnasFcAJk?=
 =?us-ascii?Q?AfLH9qv+MX8uw7KYxLbVjQSH9p2zZSZoXb6rdPXmcTSs5TSI+9pQg8q7b5dh?=
 =?us-ascii?Q?TsuPBqwEH4fcrmjnJGhceVwSLXKTBkYS7O8Ha/dpbsJQvbdb5YbSGTz+B+wc?=
 =?us-ascii?Q?IKKWX3hHpP9e5ePv7ugCIhQq5n0FJLlNthQT6C11zODM3SR45YCpI0tovFPJ?=
 =?us-ascii?Q?2LyfftXZkV9z9SRUbdIYYZnRRE3kc/kjiXpRrDXf/+Y4qu5ypUGNYe8b4AuY?=
 =?us-ascii?Q?rx67y/4CApgt5Us353R0h2jcsKYNrZbhgehK29YCeJbVtFREi8uNY4VQGjzK?=
 =?us-ascii?Q?8jQc2y/LQG8vpjNIWnL5K/rPOITgxqQjITdXyGTbB47dkW29fuNBiuH127tw?=
 =?us-ascii?Q?GvIp3W1qKM0erOy+IIJ3gp9xEo5byG/VrEOFe0gcknE9YodwicUc7awKl5Th?=
 =?us-ascii?Q?n8V2yA21P1A83tErsdUIXQj22iA2WpYC8F7oZqRJ+WBsjUjRMZcjmGk4oZAQ?=
 =?us-ascii?Q?Z3GdcR6fU14x3LdUVJkQd5QemmRelRbwdm0I7yAKz1YTMG8EUBKaogGONEE1?=
 =?us-ascii?Q?wDWkANZjfDp4x8Tgi0ybI5LuNyoAOaZOiCNskN0LXF+dcUZF0T2GxtRcLAun?=
 =?us-ascii?Q?T2agRty8ANOUMMjyoO57aZ6Djb40qD+67oHGw+j3gF6RXz28xyz6ln8/f9MI?=
 =?us-ascii?Q?QOEvAL4WVHrrD9F6YvLCqG9/21yMWp8BbqYe4op91CHUNJ+Dvna+iFCi7vi9?=
 =?us-ascii?Q?2pfSr+qhEyxnf2wG/eXMUi5h/YQXpjENGgKQKS7ZgZKz0WNk3imaq7EyPbD7?=
 =?us-ascii?Q?g6HF29PfyPjz/u+QZY3coQDU4wQd7XynBl8vHfEauEHv9VsIu3ztJ5/MMR+a?=
 =?us-ascii?Q?kTJbK8WKs9/fICP3WykeZU7yjQWuJIBPzNVWOt282mMsODYY5rqdeJMxPfC+?=
 =?us-ascii?Q?Qje4UIfJvVizFZJjs30AxZnSQ99znlrboaTwHvsS6l6167mElfuqG3znrAbX?=
 =?us-ascii?Q?C0a9fCFCPclYEAmejh4fVSQJKfg0me8YKCTFKjuoPaYTgHHw+UYc2EfP/b5+?=
 =?us-ascii?Q?EeZYm9uIHoCHVw3rVQXh7an+OsRiolbwjJuj/wwwwZxknI584EP5tg1krlsE?=
 =?us-ascii?Q?XGO9WlQqWnU98F/hzkGeDqKOJZZ18Bmc1iZlDdU4wuPtio7O/GpxQ3JdNcdI?=
 =?us-ascii?Q?132AqXwcs8m+2gIiYOd/3dXUxVaXuLhvhqsdreAWUM1CjLlDw3uaChtegLlJ?=
 =?us-ascii?Q?QR/P9cQQumiSepbC7flgMJE4pSzVmSKvTxIaI58u?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR02MB9321.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c0e4037-ca1f-4637-d8a3-08de3c2b2b42
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Dec 2025 22:42:03.9612
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jTz5caZ3Qps7CXy9SIAajk1uEumYzQB40e9GxMPH96ZS/BKOgM4xHsyhYeLHVjY5DZQoszH4uEisqnX2DERN2E6QUyqVPt0ygej6ePgGAII=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR02MB9714
X-Proofpoint-ORIG-GUID: CWhe13uNEHhYt3PGTEjHK18yjx-8JtEN
X-Proofpoint-GUID: CWhe13uNEHhYt3PGTEjHK18yjx-8JtEN
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjE1MDE5NSBTYWx0ZWRfX69zCukJ//e7A
 5H1wRGhZjk9x7tSqz7ay4+dG00XKNYdNQHr4UfdtCw43Vgltcx5wh0bmGY9wqCzYxaaTPZ0nG+V
 QMUUw3xikaqSslbcxkIKkR1SwgfloLhaW+WFZf56IeuYFgIL4Ujen3ecwCLBcGgO0Yq47G8ECDm
 /WxZ60xQY05RQj93XHZI5x1JMJ7gZd/dY6Emxqtcuq5zhXCHTDT8BNnw3T0kTbDreMSbOADRhxO
 XVWqwfl978JMLMVtpX30yetIyIv9ovmOArEYiCHm8BDXL+HvTPCNpcSp99zx+bbSbAl0hoF4aOz
 yWzoq+bG+qZ0+hBqeKvvuOapUxvujD607v60X72Fb1CepiZXL0bwdExB18wgz6twtoh9qiRWQ1C
 6C4fhLor6n4G0Jih4EzfatXFdLNsBA==
X-Authority-Analysis: v=2.4 cv=at+/yCZV c=1 sm=1 tr=0 ts=69408ebf cx=c_pps
 a=qTO11YbfUBYfkhAk4rXMnw==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=wP3pNCr1ah4A:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=64Cc0HZtAAAA:8 a=20KFwNOVAAAA:8
 a=yPCof4ZbAAAA:8 a=pGLkceISAAAA:8 a=QyXUC8HyAAAA:8 a=FUWPOPijflce5ebzY1sA:9
 a=CjuIK1q_8ugA:10 a=jySUje4VR5YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-15_05,2025-12-15_03,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

> -----Original Message-----
> From: Thanos Makatos
> Sent: 03 December 2025 14:26
> To: Sean Christopherson <seanjc@google.com>
> Cc: kvm@vger.kernel.org; John Levon <john.levon@nutanix.com>;
> mst@redhat.com; dinechin@redhat.com; cohuck@redhat.com;
> jasowang@redhat.com; stefanha@redhat.com; jag.raman@oracle.com;
> eafanasova@gmail.com; elena.ufimtseva@oracle.com
> Subject: RE: [RFC PATCH] KVM: optionally commit write on ioeventfd write
>=20
> > -----Original Message-----
> > From: Sean Christopherson <seanjc@google.com>
> > Sent: 02 December 2025 22:54
> > To: Thanos Makatos <thanos.makatos@nutanix.com>
> > Cc: kvm@vger.kernel.org; John Levon <john.levon@nutanix.com>;
> > mst@redhat.com; john.g.johnson@oracle.com; dinechin@redhat.com;
> > cohuck@redhat.com; jasowang@redhat.com; stefanha@redhat.com;
> > jag.raman@oracle.com; eafanasova@gmail.com;
> > elena.ufimtseva@oracle.com; changpeng.liu@intel.com;
> > james.r.harris@intel.com; benjamin.walker@intel.com
> > Subject: Re: [RFC PATCH] KVM: optionally commit write on ioeventfd writ=
e
> >
> > !-------------------------------------------------------------------|
> >   CAUTION: External Email
> >
> > |-------------------------------------------------------------------!
> >
> > On Tue, Dec 02, 2025, Thanos Makatos wrote:
> > > > -----Original Message-----
> > > > I think it's also worth hoisting the validity
> > > > checks into kvm_assign_ioeventfd_idx() so that this can use the sli=
ghtly
> > more
> > > > optimal __copy_to_user().
> > > >
> > > > E.g.
> > > >
> > > > 	if (args->flags & KVM_IOEVENTFD_FLAG_REDIRECT) {
> > > > 		if (!args->len || !args->post_addr ||
> > > > 		    !=3D untagged_addr(args->post_addr) ||
> > > > 		    !access_ok((void __user *)(unsigned long)args->post_addr,
> > args->len)) {
> > > > 			ret =3D -EINVAL;
> > > > 			goto fail;
> > > > 		}
> > > >
> > > > 		p->post_addr =3D (void __user *)(unsigned long)args-
> > > > >post_addr;
> > > > 	}
> > > >
> > > > And then the usage here can be
> > > >
> > > > 	if (p->post_addr && __copy_to_user(p->post_addr, val, len))
> > > > 		return -EFAULT;
> > > >
> > >
> > > Did you mean to write __copy_to_user(p->redirect, val, len) here?
> >
> > I don't think so?  Ah, it's KVM_IOEVENTFD_FLAG_REDIRECT that's stale.
> That
> > should have been something like KVM_IOEVENTFD_FLAG_POST_WRITES.
>=20
> My quoting somehow removed a line, here's what you wrote initially:
>=20
> 	if (args->flags & KVM_IOEVENTFD_FLAG_REDIRECT) {
> 		if (!args->len || !args->post_addr ||
> 		    args->redirect !=3D untagged_addr(args->post_addr) ||
> 		    !access_ok((void __user *)(unsigned long)args->post_addr,
> args->len)) {
> 			ret =3D -EINVAL;
> 			goto fail;
> 		}
>=20
> 		p->post_addr =3D (void __user *)(unsigned long)args-
> >post_addr;
> 	}
>=20
> It's the "args->redirect !=3D untagged_addr(args->post_addr)" part that's
> confused me,
> should this be the address we copy the value to?
>=20
> >
> > > > I assume the spinlock in eventfd_signal() provides ordering even on
> > weakly
> > > > ordered architectures, but we should double check that, i.e. that w=
e
> don't
> > > > need an explicitly barrier of some kind.
> > >
> > > Are you talking about the possibility of whoever polls the eventfd no=
t
> > > observing the value being written?
> >
> > Ya, KVM needs to ensure the write is visible before the wakeup occurs.
>=20
> According to https://docs.kernel.org/dev-tools/lkmm/docs/locking.html the
> spinlock is enough:
> "Locking is well-known and the common use cases are straightforward: Any
> CPU holding a given lock sees any changes previously seen or made by any
> CPU before it previously released that same lock."
>=20
> >
> > Side topic, Paolo had an off-the-cuff idea of adding uAPI to support
> > notifications
> > on memslot ranges, as opposed to posting writes via ioeventfd.  E.g. ad=
d a
> > memslot
> > flag, or maybe a memory attribute, that causes KVM to write-protect a
> region,
> > emulate in response to writes, and then notify an eventfd after emulati=
ng
> the
> > write.  It'd be a lot like KVM_MEM_READONLY, except that KVM would
> commit
> > the
> > write to memory and notify, as opposed to exiting to userspace.
>=20
> Are you thinking for reusing/adapting the mechanism in this patch for tha=
t?

ping

