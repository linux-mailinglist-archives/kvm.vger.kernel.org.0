Return-Path: <kvm+bounces-65092-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id A5F42C9AD0B
	for <lists+kvm@lfdr.de>; Tue, 02 Dec 2025 10:15:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id F32AC3470A0
	for <lists+kvm@lfdr.de>; Tue,  2 Dec 2025 09:15:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E4DB29BDB0;
	Tue,  2 Dec 2025 09:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="xwcBQCWQ";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="fWHRM3db"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8D5A25D208
	for <kvm@vger.kernel.org>; Tue,  2 Dec 2025 09:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764666951; cv=fail; b=DUE+LVOgbZBBkQQgAVn42VOodOWU5OeaFvqPuWcTmrtxk4lNHN/BT46dlNBH0zMn9oWCMYRDWKkKj/GwUszsp11Huw3jeLhCfAi74MtLBRlLKKGma0Z1LbDU6kab7PM5nQz7B5psvsFW+xi23v271ENHFIK+NUKgFpha/iWNjJo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764666951; c=relaxed/simple;
	bh=NUk1mfy0qZVmHl6LfeEN73ZWpMzvZO/EERO7+Vl0I5Y=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=PQmHKx+3wZKWjuN54bSR0KODsByAkebp36jF43Seq5yg+uawTJRIYfzeunBxf+q2WOT3m+yGB7PD/Xprj498tY16O0JdnwG/o+nSlF02RJ9tg9d9sWVrlIKLE1cjCq0jbA0yFAT9sIFyQA0eYrKh8nwbap1/plxMLUjROOB2HVY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=xwcBQCWQ; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=fWHRM3db; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127844.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5B271iEa3553546;
	Tue, 2 Dec 2025 01:15:32 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=5IYRArGLbAj983z5FJBjtmS4B89K4OTJWbvrkgT9y
	WU=; b=xwcBQCWQMVO8IQranZFh9u6agxFdeXR+/4mthgtp5oQ05HLD8aM+Al80O
	I8rex/6B3+J9QkvhBtsAWFy7VEPcJRHupJJr983WaLd7PqTDAAANso89dbZBbr7C
	7p6uL4+RILLxEfetkfVJ22cn1so58FEvrw3fI9GfAAabNd2CydYI1d+ABwFywlIB
	AeBuMIvgGF+H1OcTBCe8LmtMzRDyI9eisL43UFH+5GEdfs392GUE9NLgahXu1fsH
	De70vVYpjWYBdvQaXC5c5sYazLP3JIjS+b3UU+7LYighdKICMfHVTqNSvK5ypLxU
	SkwkGbkGBKfbmttSAvbBXD6RjkeTA==
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11023143.outbound.protection.outlook.com [40.93.201.143])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4as9rajkf8-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 02 Dec 2025 01:15:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Yj7f3igFAFlqPKovOD7dz3MH88RaP5525SXZWpAi/qcrhivbOHP62udnU25dItNv0onx+MemL2Gtn2qKPWOX+X+l5RwfOmTyC0WWhxQMZpzKvTns4KJCFVD/Kkl+UEpbdgMgxXEsUgd2YkA4ywKY5nSYWnLJAGxKhqqn/LUJrsbnKbbNj5esQyiGYRX3DcBfPbw9tEOXFDBT16dWg2unYDu/D9wXHXABSX+e6b+kVINwczfQ7w5Dl4/VxSMjnGnctiTlMWW08ym4tIYHNRPIx/fu+GU1QtGM5I9TzHJkr2eZWLfR3KA464BFpNM/m14W1v5rybNX4W+EQVaRP4urtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5IYRArGLbAj983z5FJBjtmS4B89K4OTJWbvrkgT9yWU=;
 b=xTQ0vG+obv+Y73lZE03Wh/LttKR8FLr+FsSZFgs/jFSxufhrZwWezglXrFgMgp4M6Src8wo9anvWJR0fPP7aaeQgkTQIQ7955uGG0sYqpMdId/HR8RMCYBKP03q8cY1aoxoOdQhazVtESQETl+XybQMQIIX0HTR03cViHr9LsL+9P/uFDsDsqO8NZGl8rr8CCnW1FclzNaNC3YToo9HkbYtc49QDxtY9FHo2YGXPEiO5aananY+770U2jYiAgkjyQhaaMJoDGuahCfzNRRfO26NQky3pIDyRrHkUbHDOAoYfnk5SVCOJB6L5XwQe2vSu0DchKKrs06Vpp4JXZMcyhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5IYRArGLbAj983z5FJBjtmS4B89K4OTJWbvrkgT9yWU=;
 b=fWHRM3dbZI14wq0aGgc/IxDD/KmDIEEuhkmq7FXTUjClcWdWbdrN2P9Ds4cKnNVBzCogVfr2nqFD4Lkke6oGBu4qAUnHV4IElO3Q6n+8U9nURNT1qqOjEiw0/NhUoTUFpEyLz93oY3NiXaTBMp95ZVYmJarKp/JXrPeczzyPyigzXbApzDSV6xlsXbMR5Qt6DSxP3gfUTxwssS8xXyn/OdoTZHnitOZlTAyA55IkPS6wx5fFXISUTvSXRMIbPoesJKEbY6SOpKd13F8mvHh624auICVXAsl8oi85sndEW+CssYhKF6cpb44DwwJxo0npp7GeUXty+oVQVcpypWzBHA==
Received: from DS0PR02MB9321.namprd02.prod.outlook.com (2603:10b6:8:143::21)
 by PH0PR02MB8520.namprd02.prod.outlook.com (2603:10b6:510:10d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.17; Tue, 2 Dec
 2025 09:15:29 +0000
Received: from DS0PR02MB9321.namprd02.prod.outlook.com
 ([fe80::16f2:466f:95b5:188f]) by DS0PR02MB9321.namprd02.prod.outlook.com
 ([fe80::16f2:466f:95b5:188f%3]) with mapi id 15.20.9366.012; Tue, 2 Dec 2025
 09:15:28 +0000
From: Thanos Makatos <thanos.makatos@nutanix.com>
To: Sean Christopherson <seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        John Levon
	<john.levon@nutanix.com>,
        "mst@redhat.com" <mst@redhat.com>,
        "john.g.johnson@oracle.com" <john.g.johnson@oracle.com>,
        "dinechin@redhat.com" <dinechin@redhat.com>,
        "cohuck@redhat.com"
	<cohuck@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "stefanha@redhat.com" <stefanha@redhat.com>,
        "jag.raman@oracle.com"
	<jag.raman@oracle.com>,
        "eafanasova@gmail.com" <eafanasova@gmail.com>,
        "elena.ufimtseva@oracle.com" <elena.ufimtseva@oracle.com>,
        "changpeng.liu@intel.com" <changpeng.liu@intel.com>,
        "james.r.harris@intel.com" <james.r.harris@intel.com>,
        "benjamin.walker@intel.com" <benjamin.walker@intel.com>
Subject: RE: [RFC PATCH] KVM: optionally commit write on ioeventfd write
Thread-Topic: [RFC PATCH] KVM: optionally commit write on ioeventfd write
Thread-Index: AQHcHm7Hwacz3qdkkEq6uKZSQzLqQrT47Usg
Date: Tue, 2 Dec 2025 09:15:28 +0000
Message-ID:
 <DS0PR02MB93218C62840E0E9FA240FAF68BD8A@DS0PR02MB9321.namprd02.prod.outlook.com>
References: <20221005211551.152216-1-thanos.makatos@nutanix.com>
 <aLrvLfkiz6TwR4ML@google.com>
In-Reply-To: <aLrvLfkiz6TwR4ML@google.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR02MB9321:EE_|PH0PR02MB8520:EE_
x-ms-office365-filtering-correlation-id: ca6a2982-4ae8-4cdd-f970-08de3183562b
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|7416014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?PKCktto4Jr4nlr5l430T8M8ckW4cXyR/LK07QRLx1Q9fFAmK3cULrfkPKQIF?=
 =?us-ascii?Q?a7cPRlWKXLQfEOCW7V/PKNThUuBNZQXHgky1yZbJfqaWoxqLuafKF/G8TgNR?=
 =?us-ascii?Q?H+IE9kwmf2BkL8wFwinDeGSiLixEV7dgUgq/Gwf+poqbE9aKEA6RFa86mVnh?=
 =?us-ascii?Q?TqnW0oMMFV/iRfAzEwxd4ZJI40OyxFVppvWsYUIfabrrKwrmLlUiQwros6Oa?=
 =?us-ascii?Q?fcyA88PAxAcvXXhRHSZrQ3vmUehgUNkQ/zWMBM93KrbgWfwLxUNsucd1MwKs?=
 =?us-ascii?Q?61fjHf1+Gz2XktmYv7rpGng8Bq6TTGa96UbwjGjVwrWnEVdduIrt7lGALw+6?=
 =?us-ascii?Q?xEgRQT98RLOV1WEXL7hXiHQKGHJ9RpwFme3gTz4DpIsLX9eEa2W0L3Hlc8ws?=
 =?us-ascii?Q?AjN1zhaqC/XJpoYre356LYmDNbJv2LN4u3fEP0OaqEQb3Ep7Yqk4QRKPLmMD?=
 =?us-ascii?Q?N7x8bBBYdZO5ma6SLuVQRGazjhfNuMMEVV2uZi469F/mhhnV+aBT4vyfa2pT?=
 =?us-ascii?Q?yzl8SUvPCKeZpAoLgDIQN5yBavtyHGpt05PmH4zf30NixdMrAR9qZsdcmNsl?=
 =?us-ascii?Q?ocEy0XOJ9oXxRxVWHV4wFJ4hk8iLqaCcPeI2O5pEO1zhU+AKPd5h0Ku8Ozm/?=
 =?us-ascii?Q?VUhYQpp6Yo9ey85Q+cGtSFXUhOOQGiHORyGe0J0OKVoIlA3OuZBvBypJvaEJ?=
 =?us-ascii?Q?gKwmADAvYPly20leoVckoExtWryj6xovIsT8L/NQh/4GJyK3KLAmTXRadLWb?=
 =?us-ascii?Q?T0FRd9dQjt5xarOky6TE5LmsRTK7lSOB3oZG3GsEJ6ghqE7mJi7/Zjfl2vi3?=
 =?us-ascii?Q?gHRxKdmwmN6rJlFyAkwKIOwC86DTABwzkZ9JkUfY2UsmUhdrKckoJTr56KVF?=
 =?us-ascii?Q?Irdrz9n05XdDGgDkJkhgxi0mU2HF08MbD3sPPhb2vcpyqRzRO7IHtSBi0Ry4?=
 =?us-ascii?Q?SUnaPUA2CCdMn8ZhSvHicRMlTFwGqDBz/Jb6svDoPAtwqkus03229o3UcYEs?=
 =?us-ascii?Q?EUN5kJavopc2qQ/tnzzNDSevqAZw/P3/Uq0h9GEOF2rQSMazwQqqQiKV9j2+?=
 =?us-ascii?Q?sHvRroUcApS3WlTK2zlLgQyX88YcUuOT+y8fY1kNFuRRrAOGHcujgzF/y1Za?=
 =?us-ascii?Q?927eCm4ysGksky6u8vxQ/PXzZ3yFGqLYQZB/P4/AZCQ+qFYIzFaY51gS1d94?=
 =?us-ascii?Q?pfhRkoYmHZ8XN1vXkQ8rlf/CzRAMS6ySiuwotdX7XaJYJW4JpYb8Lxw7A16F?=
 =?us-ascii?Q?KVqxvomcNl1QaM91eQg2CDspW/jVSLZ5YH/nk/UCga1gyK1dee1ioRgpubc2?=
 =?us-ascii?Q?vxmX2p0xSW24sEZcA4b/Fsni9hN2FFfTHTJdr6p5LsxAYCw1cyhQr3UQ/5LJ?=
 =?us-ascii?Q?K7rVWEPkLWcLyaY40vJ9rb0YYaCm1BFGS81n8qi8Lg5PbfaRHLcupDs4OZqX?=
 =?us-ascii?Q?xfWGmVxZhsW5Si1DeaoOfzXZFsC+viN+oKFdkvz0mvzkLMTZhXn53m+Q1F9e?=
 =?us-ascii?Q?tCQPjJkt1MmEGkZ/+nAtS3EiGbCKOmmRbfkK?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR02MB9321.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?/2LDSW3NQUsHEm/Nk1s03Xc97TPNocfq+/QavULRzkSdZ5uq88sRf7EPGcNT?=
 =?us-ascii?Q?xLrNazDsoKH+bP3O1whUW00bDZZnTyKP2LFb8N9pyxqqXsUCOLIkT1+B/2zm?=
 =?us-ascii?Q?B7oVCaqvDUmsmP7OasSWAEy74GWnkcu+55/YmIuVyt9/aX7iFQ3JvEKgR6wB?=
 =?us-ascii?Q?ZL9eRhstjwXLMyJrr68quuOk0wPLalpIQS3t9tgd1cWJ+1drk6lKFn/INHuw?=
 =?us-ascii?Q?PRgv2+9jdE0JTIXCRZqsvRHOhpLlKMTvd02zUp9zBAhVR0sh4pUFHybO7WUZ?=
 =?us-ascii?Q?JBLG2zbC7ou3Lz2WvBMIB3DVpEAvJz+yDsDz/oDPFG0fiko5R7/76v9r99W4?=
 =?us-ascii?Q?aABFzCaQQ4onb7gkrwKmqHKZvUTOr3yjSa98AFPxGhywSvz8M6HcnXGjDxc/?=
 =?us-ascii?Q?W/txzguVSRAVAYGRnOVvYVUIcu45kFELWnAB8nujeDfaWKLtc6HlA+igGW5d?=
 =?us-ascii?Q?w+ZAb3a8F8GCS38wtbyTaB/IDHVwS6jSz5nbIg0xJbirUof8PQp9luJcYoOI?=
 =?us-ascii?Q?T99qUAZYII7BICDDP+ek6qsVvpkxKjppEOtNTg8+EQCJk5E9z2h3MQDpV0SQ?=
 =?us-ascii?Q?U3sDqI6BGFi/lkGGiOmGdNli7zHn+s9+2uLo4MFEbBc4j5Q7wslym77zLaTo?=
 =?us-ascii?Q?AqWDA799faVkF31Jl7g5uj0ba2328jn+qOEzD0RYyIkKQYFGQqqm22hH8Gf6?=
 =?us-ascii?Q?cAHSXN1eviCntZREzk9bq6Wgp/P7Kd7Atu5Te/+dGkleo/HZ1VQtzFeX3C+a?=
 =?us-ascii?Q?SwrbAb34bPlxqphp9NVJVKi7tJukWgOhe7RBY8Nrs7HnvgjdcWIZRf+ASbnE?=
 =?us-ascii?Q?cx6j1U5u8dq/FFYUd0nC37Cq+aFS0nZ3wsnT2mGLyT3cjH+AfSXfwRSHvIE/?=
 =?us-ascii?Q?X3dLYmXDSyLCdrK4ldRep1qC/LOWXN2JInSbs+PiU3A+NBYrFs1tUr5SGvYo?=
 =?us-ascii?Q?2kXSV0e6TGjwGb29dZocEOZGJelIDmlbn7sqw3Ndnp0boWnHZSdlBlpKn9xi?=
 =?us-ascii?Q?SV4zHp9jP6kod8vcyqiV8kRhVclSwWqAo/HhYQkQCs0gGfDfxJrxGZ44EMls?=
 =?us-ascii?Q?Fmqd6W3pbHwhNCDPSF9ACqcTRP0Z/VWQ1udI9Euajfsd77IzoMEr5044OVDq?=
 =?us-ascii?Q?2zrwr4sEvAGhKnvbUnhw/OR5IIoottDEMJvU/SUOiU99Br7abZ+QLCw+4o48?=
 =?us-ascii?Q?RIsdasgOI9Js8qleX9FZKNm9ro/novrmDSUp+UedhzkN0/3dmtVRGhOHrioU?=
 =?us-ascii?Q?R/Xv6fVPEOFg++0FGrL9M60Z1tBSaOHkDevCDBkQVEC8bLHnVWv0duP69QB/?=
 =?us-ascii?Q?t4PYM9DUaFyT+FOLYsD719jqGo3LVhWjbWxciydCSz4kzkMXaDdFh+AXiwMt?=
 =?us-ascii?Q?0r78UEYHzaOKBLSKHbmW82cn2K9zgQCnooLJOhumR9h+PZ5zoabiov7v/PC3?=
 =?us-ascii?Q?ntigub0yvvPnG8FCV5cL0jjq1fpF156+aw5mEyP3lVrPlvlkQjNgX8Nrlxuh?=
 =?us-ascii?Q?SlL2IMK/2yOYd3zL4JnzshInSoW0eLIvFca/ZakFltAUXsLZKEPvmKZuFnF5?=
 =?us-ascii?Q?vU+gO98NkJ7fQhG+kapl7paXc92jnm+SUYFwAkoB?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: ca6a2982-4ae8-4cdd-f970-08de3183562b
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2025 09:15:28.9297
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /R2xyofN0Qnsw4CqCmHsjK7ogM5Mzewx/jgX90p2xbslRHulJORjSFaQO49cw0rBcX7bVVJ1oDaz/59ZZW58hAJgOxtixi4Hg+Y4v0Yg8RQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR02MB8520
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjAyMDA3MyBTYWx0ZWRfX8RLCFju6Xy5m
 Za7KvVBo16jNzpwKbWIqpE3IgYIGBGtwwpPXoD3jVTRW0TXpsgtn8DF5bUTm0/QJ93w4cgiqh/4
 xFgHB/UqWHWCE+yohFD9mUAFDY1tdzwC8/YIt5GH3cKFJUa/evBYqcQK1jz+C8btoSS9KVYAFV9
 0djw5njibP7FSlHb9tjm4N6hSZbmGLdH43VnTN0tyR+oXvLTLXNSIpklSk4j/56+kpR39cevYda
 s11+0prlX2SSI2YLAqkhmsLhcJByFe0tT8qs/hC0xQYfcluzYO1bKii111p2EhOthgkyYO0VevH
 Lb491nnBx5UNWNaAmmsDN/iGiBud0cGFRHwn/8+hJ/MbC4paHWcooq5plQMG1DBg1FTCWWqiHZs
 DRkgW11tXEcJz6PCaTZAkb5wNwH7mQ==
X-Authority-Analysis: v=2.4 cv=V7xwEOni c=1 sm=1 tr=0 ts=692eae33 cx=c_pps
 a=ZOsnctmsBCw54sLOPzIoIA==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=wP3pNCr1ah4A:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=1XWaLZrsAAAA:8 a=64Cc0HZtAAAA:8 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
 a=yPCof4ZbAAAA:8 a=pGLkceISAAAA:8 a=QyXUC8HyAAAA:8 a=-VPUKGdZ2qMZ9JG55tkA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: 4MAO1N2RSrNyZPVkQRTTWuItZbnPpu_v
X-Proofpoint-GUID: 4MAO1N2RSrNyZPVkQRTTWuItZbnPpu_v
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-01_01,2025-11-27_02,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

> -----Original Message-----
> From: Sean Christopherson <seanjc@google.com>
> Sent: 05 September 2025 15:10
> To: Thanos Makatos <thanos.makatos@nutanix.com>
> Cc: kvm@vger.kernel.org; John Levon <john.levon@nutanix.com>;
> mst@redhat.com; john.g.johnson@oracle.com; dinechin@redhat.com;
> cohuck@redhat.com; jasowang@redhat.com; stefanha@redhat.com;
> jag.raman@oracle.com; eafanasova@gmail.com;
> elena.ufimtseva@oracle.com; changpeng.liu@intel.com;
> james.r.harris@intel.com; benjamin.walker@intel.com
> Subject: Re: [RFC PATCH] KVM: optionally commit write on ioeventfd write
>=20
> !-------------------------------------------------------------------|
>   CAUTION: External Email
>=20
> |-------------------------------------------------------------------!
>=20
> On Wed, Oct 05, 2022, Thanos Makatos wrote:
>=20
> Amusingly, I floated this exact idea internally without ever seeing this =
patch
> (we ended up going a different direction).  Sadly, I can't claim infringe=
ment,
> as my suggestion was timestamped from December 2022 :-D
>=20
> If this is useful for y'all, I don't see a reason not to do it.
>=20
> > ---
> >  include/uapi/linux/kvm.h       | 5 ++++-
> >  tools/include/uapi/linux/kvm.h | 2 ++
> >  virt/kvm/eventfd.c             | 9 +++++++++
> >  3 files changed, 15 insertions(+), 1 deletion(-)
> >
> > diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> > index eed0315a77a6..0a884ac1cc76 100644
> > --- a/include/uapi/linux/kvm.h
> > +++ b/include/uapi/linux/kvm.h
> > @@ -804,6 +804,7 @@ enum {
> >  	kvm_ioeventfd_flag_nr_deassign,
> >  	kvm_ioeventfd_flag_nr_virtio_ccw_notify,
> >  	kvm_ioeventfd_flag_nr_fast_mmio,
> > +	kvm_ioevetnfd_flag_nr_commit_write,
> >  	kvm_ioeventfd_flag_nr_max,
> >  };
> >
> > @@ -812,16 +813,18 @@ enum {
> >  #define KVM_IOEVENTFD_FLAG_DEASSIGN  (1 <<
> kvm_ioeventfd_flag_nr_deassign)
> >  #define KVM_IOEVENTFD_FLAG_VIRTIO_CCW_NOTIFY \
> >  	(1 << kvm_ioeventfd_flag_nr_virtio_ccw_notify)
> > +#define KVM_IOEVENTFD_FLAG_COMMIT_WRITE (1 <<
> kvm_ioevetnfd_flag_nr_commit_write)
>=20
> Maybe POST_WRITE to try to capture the effective semantics?=20

Ack.

> As for read after
> write hazards, my vote is to document that KVM provides no guarantees on
> that
> front.  I can't envision a use case where it makes sense to provide guara=
ntees
> in the kernel, since doing so would largely defeat the purpose of handlin=
g
> writes
> in the fastpath.

Ack.

>=20
> >  #define KVM_IOEVENTFD_VALID_FLAG_MASK  ((1 <<
> kvm_ioeventfd_flag_nr_max) - 1)
> >
> >  struct kvm_ioeventfd {
> >  	__u64 datamatch;
> >  	__u64 addr;        /* legal pio/mmio address */
> > +	__u64 vaddr;       /* user address to write to if COMMIT_WRITE is set
> */
>=20
> This needs to be placed at the end, i.e. actually needs to consume the pa=
d[]
> bytes.  Inserting into the middle changes the layout of the structure and=
 thus
> breaks ABI.

Ack.

>=20
> And maybe post_addr (or commit_addr)?  Because vaddr might be
> interpreted as the
> host virtual address that corresponds to "addr", which may or may not be =
the
> case.

Ack.

>=20
> >  	__u32 len;         /* 1, 2, 4, or 8 bytes; or 0 to ignore length */
> >  	__s32 fd;
> >  	__u32 flags;
> > -	__u8  pad[36];
> > +	__u8  pad[28];
> >  };
>=20
> ...
>=20
> > @@ -812,6 +813,7 @@ enum {
> >  #define KVM_IOEVENTFD_FLAG_DEASSIGN  (1 <<
> kvm_ioeventfd_flag_nr_deassign)
> >  #define KVM_IOEVENTFD_FLAG_VIRTIO_CCW_NOTIFY \
> >  	(1 << kvm_ioeventfd_flag_nr_virtio_ccw_notify)
> > +#define KVM_IOEVENTFD_FLAG_COMMIT_WRITE (1 <<
> kvm_ioevetnfd_flag_nr_commit_write)
> >
> >  #define KVM_IOEVENTFD_VALID_FLAG_MASK  ((1 <<
> kvm_ioeventfd_flag_nr_max) - 1)
> >
> > diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
> > index 2a3ed401ce46..c98e7b54fafa 100644
> > --- a/virt/kvm/eventfd.c
> > +++ b/virt/kvm/eventfd.c
> > @@ -682,6 +682,8 @@ struct _ioeventfd {
> >  	struct kvm_io_device dev;
> >  	u8                   bus_idx;
> >  	bool                 wildcard;
> > +	bool                 commit_write;
> > +	void                 *vaddr;
>=20
> There's no need for a separate bool, just pivot on the validity of the po=
inter.
> The simplest approach is to disallow NULL pointers (which aren't technica=
lly
> illegal for userspace, but I doubt any use case actually cares).

Ack.

> Alternatively, set the internal pointer to e.g. -EINVAL and then act on !=
IS_ERR().
>=20
> The pointer also needs to be tagged __user.

Ack.

>=20
> >  };
> >
> >  static inline struct _ioeventfd *
> > @@ -753,6 +755,10 @@ ioeventfd_write(struct kvm_vcpu *vcpu, struct
> kvm_io_device *this, gpa_t addr,
> >  	if (!ioeventfd_in_range(p, addr, len, val))
> >  		return -EOPNOTSUPP;
> >
> > +	if (p->commit_write) {
> > +		if (unlikely(copy_to_user(p->vaddr, val, len)))
>=20
> This needs to check that len > 0.=20

Ack.

> I think it's also worth hoisting the validity
> checks into kvm_assign_ioeventfd_idx() so that this can use the slightly =
more
> optimal __copy_to_user().
>=20
> E.g.
>=20
> 	if (args->flags & KVM_IOEVENTFD_FLAG_REDIRECT) {
> 		if (!args->len || !args->post_addr ||
> 		    !=3D untagged_addr(args->post_addr) ||
> 		    !access_ok((void __user *)(unsigned long)args->post_addr, args->len=
)) {
> 			ret =3D -EINVAL;
> 			goto fail;
> 		}
>=20
> 		p->post_addr =3D (void __user *)(unsigned long)args-
> >post_addr;
> 	}
>=20
> And then the usage here can be
>=20
> 	if (p->post_addr && __copy_to_user(p->post_addr, val, len))
> 		return -EFAULT;
>=20

Did you mean to write __copy_to_user(p->redirect, val, len) here?

> I assume the spinlock in eventfd_signal() provides ordering even on weakl=
y
> ordered architectures, but we should double check that, i.e. that we don'=
t
> need
> an explicitly barrier of some kind.

Are you talking about the possibility of whoever polls the eventfd not obse=
rving the value being written?

>=20
> Lastly, I believe kvm_deassign_ioeventfd_idx() needs to check for a match=
 on
> post_addr (or whatever it gets named).

Ack.

>=20
> > +			return -EFAULT;
> > +	}
> >  	eventfd_signal(p->eventfd, 1);
> >  	return 0;
> >  }
> > @@ -832,6 +838,9 @@ static int kvm_assign_ioeventfd_idx(struct kvm
> *kvm,
> >  	else
> >  		p->wildcard =3D true;
> >
> > +	p->commit_write =3D args->flags &
> KVM_IOEVENTFD_FLAG_COMMIT_WRITE;
> > +	p->vaddr =3D (void *)args->vaddr;
> > +
> >  	mutex_lock(&kvm->slots_lock);
> >
> >  	/* Verify that there isn't a match already */
> > --
> > 2.22.3
> >

