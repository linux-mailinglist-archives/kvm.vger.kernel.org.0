Return-Path: <kvm+bounces-21935-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 528C3937A0F
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 17:40:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 766791C2197C
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 15:40:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D08AA145B0F;
	Fri, 19 Jul 2024 15:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=marvell.com header.i=@marvell.com header.b="cPAse5Qc"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD4D2145A19
	for <kvm@vger.kernel.org>; Fri, 19 Jul 2024 15:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.148.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721403611; cv=fail; b=drZ8+vyspJyt64wpsm5WOxU+56p7JhdD+DfE8aZDhWGb9BHKnHBzW0QPDtJMarrqPFrO2tTGksU+8y4Xc7kvuQ+mqBLMxljmrZdcb3tWfyMfSx7tfBIRU5BxCynoB9M+HFr7OQg8VPFnwMN3TVNX5rucfiEjC+FTwi2FSfQ7WgY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721403611; c=relaxed/simple;
	bh=nVQzDE8OOUbLwXTNv1BXwJLgrlUUB3+5vIN8UNlzqBI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=rFV/bqYE7aQmY9ZdD+Rz8DImbmGSAGmtmzP7BZZ+ssMM18nSPBbTrDjlWVtDGd42EEIGfDvdJ4IIVbS2OjI58Tu4RFJCq6TZBzNM9/XK1qF7rmeBOKFjYyEYtJEerEjl6MIsimFEARAazjmyh3gGKuTRYKh+J1XcdStYyJWHNks=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (1024-bit key) header.d=marvell.com header.i=@marvell.com header.b=cPAse5Qc; arc=fail smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46JEjr3u016646;
	Fri, 19 Jul 2024 08:39:42 -0700
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 40ft6jr7kf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 19 Jul 2024 08:39:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=p9y/5VXm5XvN7LGMNFR41wK/zyG9Fr4bai7yZvzdG99m22+S05BBm0McOgUX2ZfhUhCHydwa6uo4Nc2JxEpi8rk2Nts6i6cnsycbWKeBfwBPX5cLo+0bYJS6HM8t32PnCdihNVwYp6lRVLtYcJFsOmVm/6HKn9EY7w+Z7kwd7AZXhKWBeffIumWgISTBDGTslygpaEsCr96P8zDL9j2F4WzSXs7YQsaAKDE0OtsqYNoEHLrzy5qNaOHlCzS+3QC4+XganPIplGYUC2Erv0eQ0CAHpbDJ+cke4YANIueb3TBw8HKIc0h3N8mHojCXCqSrFZl4gSRcRNRucF+k8yAOUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nVQzDE8OOUbLwXTNv1BXwJLgrlUUB3+5vIN8UNlzqBI=;
 b=qCCEcMNhJuHK6SK5JfqAdfzuvJ391KEQWUtHiP0YgP3dvFwdPMoCXpDsibO5R9RBCPkoGq/vmUoXAOYJMjFc+gZ/XWdUxGitM8fZcTbzJPzQKBUsEhFUCaJxfe6kHCSJqKM0DjuLgpzK0m2YoD+VT9HJorIQG/D5/0cXZom3AjcHmnZKLHvne8cZVnL7RfeVQXv1rhNV+YuMIUsjj381df73JugJUF0z5/uDe/Wi6b06LdQ76Rxse92lEciILG6VbUIhyhBpDnO5FdG3QmcHMy2PigyQoPKmuuqkXrjFIxOG2wUwuau8ycfVCzVZrd0NoJ1PDXjHggjQ76ZI33FsAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nVQzDE8OOUbLwXTNv1BXwJLgrlUUB3+5vIN8UNlzqBI=;
 b=cPAse5QclrORDxkK7bjrW/HaA+Ps1ZmI69M+L7vOYFQBh5PwNW0KXoQETRof5E0FcjqyPo+680TsIllWWFJx0nTTnbnMjy+Gv+Njoeby60/JrEqPApg7BDBClSfqoj6gfJ6Lt1N611g88FRtxMkC0Xt2je8eJYWoXQrKLMpLtbU=
Received: from DS0PR18MB5368.namprd18.prod.outlook.com (2603:10b6:8:12f::17)
 by BN9PR18MB4251.namprd18.prod.outlook.com (2603:10b6:408:11c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.17; Fri, 19 Jul
 2024 15:39:39 +0000
Received: from DS0PR18MB5368.namprd18.prod.outlook.com
 ([fe80::ad53:bef2:cc17:13ac]) by DS0PR18MB5368.namprd18.prod.outlook.com
 ([fe80::ad53:bef2:cc17:13ac%5]) with mapi id 15.20.7762.030; Fri, 19 Jul 2024
 15:39:39 +0000
From: Srujana Challa <schalla@marvell.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: "virtualization@lists.linux.dev" <virtualization@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jasowang@redhat.com"
	<jasowang@redhat.com>,
        Vamsi Krishna Attunuru <vattunuru@marvell.com>,
        Shijith Thotton <sthotton@marvell.com>,
        Nithin Kumar Dabilpuram
	<ndabilpuram@marvell.com>,
        Jerin Jacob <jerinj@marvell.com>, "joro@8bytes.org" <joro@8bytes.org>,
        "will@kernel.org" <will@kernel.org>
Subject: RE: [EXTERNAL] Re: [PATCH] vdpa: Add support for no-IOMMU mode
Thread-Topic: [EXTERNAL] Re: [PATCH] vdpa: Add support for no-IOMMU mode
Thread-Index: AQHasnq4Ve/zJa91a0mQb+nM4LHR9bH6+HqAgANtqRA=
Date: Fri, 19 Jul 2024 15:39:38 +0000
Message-ID:
 <DS0PR18MB536893E8C3A628A95BF8DDA0A0AD2@DS0PR18MB5368.namprd18.prod.outlook.com>
References: <20240530101823.1210161-1-schalla@marvell.com>
 <20240717054547-mutt-send-email-mst@kernel.org>
In-Reply-To: <20240717054547-mutt-send-email-mst@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR18MB5368:EE_|BN9PR18MB4251:EE_
x-ms-office365-filtering-correlation-id: 132e81fc-cb1d-4926-0c02-08dca8090018
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?RXdYOEptNmZabmZWRmJZZlZjejBiTFc0ZENmN3pTRW8zek9yZTlpbTBCM0hy?=
 =?utf-8?B?V2VMRGVTbmk0cjNydm5ZY3hlNFlNTWQyTStsWnN5L1lCTEx4bDRueEdDR25r?=
 =?utf-8?B?MDcvamRiQXVpTFhHR0pxV3JMWGhYeXZ5RkpwOEZmR1hzaEkrQWtMbWp0U0pL?=
 =?utf-8?B?RDlmWTBaa29IVjFBLzkxSnNMZEtpVE1sY0poZkkzaTdaQldMNVQvdVJMR1Fa?=
 =?utf-8?B?a2psWEMwU2t5QXU1clJWa1lOTjNCQlZGQ3RKWm1RbHRNaE9jWFp4YVVhMm5Q?=
 =?utf-8?B?VXhhSjd1R2VaREQ5OStTQVFnQXJhYU11NE43YkVKQnkwRFYzeTEySUZzK0p4?=
 =?utf-8?B?ZE81M2J2YXNsSDNkYWVkLzY3d29HR0MvK1lrTzhwOWZmWCszTWh1SkdsOXhQ?=
 =?utf-8?B?d25VNG9DUWRDUThkOUkyMytkZ0VzMTNadjJtTDhhTTB3Qk5JY0NDWVliOGxP?=
 =?utf-8?B?WEszcng3WTNscmJRUWpjTHozS1lBc3pncUVmQi9ieEFjV24xaTY4RC8zZG95?=
 =?utf-8?B?SW5WSkZvZnFkMTMzcXEvSTNKOEVLd2FNWk11QXIrTktBY2JkazJYRWVHRXNZ?=
 =?utf-8?B?WWNFYjhsMVUwZkVVTzl6Q1BLMjhLUUJ0cWg4QUFLVFAvcjFKY1VJQXZoRHpB?=
 =?utf-8?B?U1VlUE9RQXRBWkR4TU9qUmx3NkVXN0dMeUt6V3dEcnl2NEpQVUFyYWtKYkxL?=
 =?utf-8?B?MGVPWFkybi9qRzN5VEdGU24zVlh1M3o2Z3V5dlI4ZzlydmdaeHRDM3ZHN0g5?=
 =?utf-8?B?QWhJVm5Jc012S0IrU0QyV0h3Ni9VblUwOHNWYUttMi9zZGIxVnQ1SGhTZ3Zz?=
 =?utf-8?B?MnhBQjZLMEVjU09IV3NyamQ4STNrRVZjVk5qTUtaczBlODAxU0JkaytiU0Zj?=
 =?utf-8?B?NnMxa0ZrejJzOFlyWWwwMGdEN1BkODB0Ri9kWmc3bUdYM0pBK3d0eWRhZlBh?=
 =?utf-8?B?K1B1TS9ORkFSUllQNC9zUmRESlI5cC9KTjZrNVNMc05RQTZlMVAvdDNxNTBT?=
 =?utf-8?B?bEpmR0RQb3huVUlBeXA0V2J2M2k2b2phVkNQNTJzUVVlTFI3QW1hendKeVNa?=
 =?utf-8?B?ek5XOGNrWjBVNFYyMUtOUnRvbEovQ3FGeStnZlVTVzB2Qk4wVWNNaFJ4emRV?=
 =?utf-8?B?YkNVSXVuYm0rZWhzeXI4bUFEeVBCY21ISUFaT2tFTGpjdy8zbjVyakI4dlRp?=
 =?utf-8?B?eFhVbHJYYTZ5enNqZ255cHdoUTFaVFJhcnFHZytpRFo2OXlOZUQ3UWVITDBq?=
 =?utf-8?B?Vk9zS25VTGJ2MnlhYmliRlQ5S0RtZGxUK1BwbzVUcTJad0lCdzdVelhkZTd6?=
 =?utf-8?B?MnRWNmorUC8vSU1QT0tETFlaVnBYZWllQmU1TzlqVTdmRFBUbitRN1k4V3ky?=
 =?utf-8?B?WEJpL1FZelo5WmVEWHFXT0RkQjN4RnpIMmcrQmc3L3Y3L2VOSVVHR1plM2RY?=
 =?utf-8?B?RGgrUWM0Tzg3eElQK3drck9pOURsZDlHYTlCNElCZlVHWS9NdTByY2VKZFJK?=
 =?utf-8?B?WkpKNFVpL2NodUVLa2s4c00xWGdEaFVxeWRuNkJEUGY4a0Z5WCsrVE5aNUZl?=
 =?utf-8?B?TUZDYlA3NjRPelBGaVJJMWh5bmtyVkw4OUpVcG5VS1ByZjg3NTZNR202aTEz?=
 =?utf-8?B?TFlyQjB2QjdlZHJtR3NYczNSenM3NFB0K0xpK1l2SWlTc09FSWFQb0JlOUsy?=
 =?utf-8?B?UFQyMGdmVGg3QWlOT2s2MTR4LzVvK0d0NjM0dHQrcWFyYjN2akhjYlhySC9o?=
 =?utf-8?B?SWQxY3J0eVhYQ0h0Zjh6NWExdFJuSnJyR0pXOEprK1M5OVhQL1E1T0tORmtN?=
 =?utf-8?B?YTAxRFBVWTBncjMyVUJXUElBb2RyWlZtU3p3Uy96V2FkRldja1JjNTl1aHFT?=
 =?utf-8?B?WkRPMkUxNDQvM0NUVDlzOGNMRW5tcFhzMnArci9CWU1VZFE9PQ==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR18MB5368.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?bXRaQk1yTzZIMkpjSmJDVFUrQXVPS1k0OUxiY3BrRXR2cXU2Mk45NHlXQ1Zu?=
 =?utf-8?B?OVRUdlM0dXB5dVpBTjVEY1dGY2hOUTJLV1FzZHYzWUVFOEVWTytYa2FTdEJx?=
 =?utf-8?B?eHZRWWFaalREcFNndzVQSFZKeGp2eGRuQlltY09vbDlseks0dEkwQU5KbHZh?=
 =?utf-8?B?bG5TUFByajJKUTYrRmdhRG15Ry9sS3NSeU5wUWk3U0dCQVMyaVBDTjRnRU1P?=
 =?utf-8?B?aWlSWDNXZ3VDMVVGNHBWdnN2MjE1aHFzUWtXU2xxemlpMWZBUFJlWWU0MzlI?=
 =?utf-8?B?TUpla2h5RVUyVThURjREdFJpbFhxNk5PQUdoMllXQ1hBMEhVR3JKS2xBQ3Vk?=
 =?utf-8?B?aGdWT29hOXF2Q3dZYXlHWXZCZitHeEJ2Sml0a3hHS015MzBJcGNDa2ZlcDcx?=
 =?utf-8?B?Q216ZE9uRk1SdkNtaEhYUDdTOGppenNOKzdOV01IZHJsZTZYQktWTndNcUt0?=
 =?utf-8?B?OTJGV2dLYjkzOUMwcjFwUk9IL0RVTFlLL3ZEbDg0MExZWkhFbTFKWmlEUEJm?=
 =?utf-8?B?cTlQZGNEakV3U1Y1YldWRFUxU3lNdGNha3hOTklWemNZN3BybTM0UDlrWVdD?=
 =?utf-8?B?OWlzVmxxMXE0ZGNUTW1RRU9ZMU9UclBQM2tmMVBRdGFKZHZnSSt2MEUwczNs?=
 =?utf-8?B?aTZwZVB5UU5waGxSZThTWm5JeHlSYVc2QVpkK29lMmdJcEZVYXp6eEtMZ0Rq?=
 =?utf-8?B?RWdzbWxTYkpJUngzWm5qRWJ5NS9XbEdGNFR0K3pQSFlpTDlpcnFMVlhaVDRu?=
 =?utf-8?B?Mlo3eVJUMmJaT1hLckQzblVQZzRaQVVsNGkycEgyVEt6MENrd256eWs3Rkpp?=
 =?utf-8?B?L3VFNDYxVEtFRitjdnhNTjF6emV1RU1YRGZ4NkVGTHgvbzlZd2lCalJsbGVl?=
 =?utf-8?B?UVZTRzNyUlE3Nkx1OUF0RnZVcnBYMS9IaGxTV1pIa2JPOGJmNWFRNlJLK01a?=
 =?utf-8?B?ajEzUGdSMllJWkFmTURUcnN0ZEdPWFh2YVhmcVRLcERZd0NvRzBrWVBhQ0xm?=
 =?utf-8?B?bEJpZGY2cVppNXczR2xVR2tqcEc4OVVMc3FTUDh3czdDbnFmMzJiYnpzSmxv?=
 =?utf-8?B?SmkyelV6NnlDYzZkcVV1c1JMT0N5aWZhNGtaS3I3SWZuN1EzbXBrUFoxQXlj?=
 =?utf-8?B?NitSYU1aLytRbnkwR0owVVlGRWlrWjlwTzFmYUtLWHBiTkJyTFprd3Q3VEpC?=
 =?utf-8?B?VmZCTW1jbzV6VFl6QStLR1VlVXk0TWZJVXFCekltcXA1MzJXQk56MGhYbGt0?=
 =?utf-8?B?azVKZ0ZhckpwOW9QUTNJa2NqL0xYaFJ6M1JmMHRTWU5mdFJnUDVPS2NmTGlr?=
 =?utf-8?B?cStYL1hjbGYvalhpemYyWmxrUmFoSVZZTFZ3Q1poU2M4Ykd6TUZLTm1rcnVG?=
 =?utf-8?B?YXVQdkhRdTRzZlhMa0VOTVFub1R6YnJteWIvMy9CemRRVFJBRDJvWjlDWXIx?=
 =?utf-8?B?anY1bXhMWjBBY3ZHZDZFRFlLMEk1cFVEUEtzdDRHSEx4d0lPZWM2cWlMTTd6?=
 =?utf-8?B?Tk1GdzhDOHhlZ0ZNazk2VjZUNE9RKzRiOG01L002V1NTVGFzc1RldVI3U3pl?=
 =?utf-8?B?d1dvNnZGVWQxNXR1emIxazJPUG1LcHhoMDVoUldwUDlYdDVDNVlEM0NEeFVE?=
 =?utf-8?B?TjFuckwvMmVDUUhCckRIUGRiQ0ZxbVVPcUpQeHMvVXM3RUl6M05PcldQanVk?=
 =?utf-8?B?VDEwTW4zditPZmJ1OXlJa3ptV053RytUV1BlMTVjdlNhK3ZQbXlucUQ3dXM2?=
 =?utf-8?B?ejhKQ05oVGhnelNYOVNXTThhSXhSd1NZRW91Q1BYUXNXTENkVGZLeEsxMVI3?=
 =?utf-8?B?VmFDdjZYdW1pbExpWmtXaWZnekdoL2k0b2ZSUHJLOXdJbG1VMWlCaEhFMkFv?=
 =?utf-8?B?TTNSOFNWcFFOZXhhRzVpdG1wT1BOS1dSNDk5MEthOEg0Ry9oYlNENjB3ampV?=
 =?utf-8?B?ZEdac3RZRjNFYVpyTk1PaThOc2dHdVdmTHVMRitUOVF0ZUJVNEsyRTZZVCs0?=
 =?utf-8?B?YnlaalJJVm9YTWROa3phRmYwUHdiY2hSZXNKL01pSjh2Ykk5SU4zWExqODl5?=
 =?utf-8?B?U0pPb1JxVk5TK0tUSGdyVUxPcG9oYVlNQUJvOTg1MlRKaUlldHF5OUQ3TTV0?=
 =?utf-8?Q?9tAo=3D?=
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
X-MS-Exchange-CrossTenant-AuthSource: DS0PR18MB5368.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 132e81fc-cb1d-4926-0c02-08dca8090018
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jul 2024 15:39:38.9481
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jwIez+myrxiMxKd6esH8kVF132lI7QvavByRYDkAf1LdL5coeEapK56i5mjvIK0AkB/e2NrhQUm2Tf7XAQGDNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR18MB4251
X-Proofpoint-ORIG-GUID: -C_fdeQ_RW1EI28M6IbweKk-gFeQ4Ywf
X-Proofpoint-GUID: -C_fdeQ_RW1EI28M6IbweKk-gFeQ4Ywf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-19_06,2024-07-18_01,2024-05-17_01

PiBPbiBUaHUsIE1heSAzMCwgMjAyNCBhdCAwMzo0ODoyM1BNICswNTMwLCBTcnVqYW5hIENoYWxs
YSB3cm90ZToNCj4gPiBUaGlzIGNvbW1pdCBpbnRyb2R1Y2VzIHN1cHBvcnQgZm9yIGFuIFVOU0FG
RSwgbm8tSU9NTVUgbW9kZSBpbiB0aGUNCj4gPiB2aG9zdC12ZHBhIGRyaXZlci4gV2hlbiBlbmFi
bGVkLCB0aGlzIG1vZGUgcHJvdmlkZXMgbm8gZGV2aWNlDQo+ID4gaXNvbGF0aW9uLCBubyBETUEg
dHJhbnNsYXRpb24sIG5vIGhvc3Qga2VybmVsIHByb3RlY3Rpb24sIGFuZCBjYW5ub3QNCj4gPiBi
ZSB1c2VkIGZvciBkZXZpY2UgYXNzaWdubWVudCB0byB2aXJ0dWFsIG1hY2hpbmVzLiBJdCByZXF1
aXJlcyBSQVdJTw0KPiA+IHBlcm1pc3Npb25zIGFuZCB3aWxsIHRhaW50IHRoZSBrZXJuZWwuDQo+
ID4gVGhpcyBtb2RlIHJlcXVpcmVzIGVuYWJsaW5nIHRoZQ0KPiAiZW5hYmxlX3Zob3N0X3ZkcGFf
dW5zYWZlX25vaW9tbXVfbW9kZSINCj4gPiBvcHRpb24gb24gdGhlIHZob3N0LXZkcGEgZHJpdmVy
LiBUaGlzIG1vZGUgd291bGQgYmUgdXNlZnVsIHRvIGdldA0KPiA+IGJldHRlciBwZXJmb3JtYW5j
ZSBvbiBzcGVjaWZpY2UgbG93IGVuZCBtYWNoaW5lcyBhbmQgY2FuIGJlIGxldmVyYWdlZA0KPiA+
IGJ5IGVtYmVkZGVkIHBsYXRmb3JtcyB3aGVyZSBhcHBsaWNhdGlvbnMgcnVuIGluIGNvbnRyb2xs
ZWQgZW52aXJvbm1lbnQuDQo+ID4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBTcnVqYW5hIENoYWxsYSA8
c2NoYWxsYUBtYXJ2ZWxsLmNvbT4NCj4gDQo+IFRob3VnaHQgaGFyZCBhYm91dCB0aGF0Lg0KPiBJ
IHRoaW5rIGdpdmVuIHZmaW8gc3VwcG9ydHMgdGhpcywgd2UgY2FuIGRvIHRoYXQgdG9vLCBhbmQg
dGhlIGV4dGVuc2lvbiBpcyBzbWFsbC4NCj4gDQo+IEhvd2V2ZXIsIGl0IGxvb2tzIGxpa2Ugc2V0
dGluZyB0aGlzIHBhcmFtZXRlciB3aWxsIGF1dG9tYXRpY2FsbHkgY2hhbmdlIHRoZQ0KPiBiZWhh
dmlvdXIgZm9yIGV4aXN0aW5nIHVzZXJzcGFjZSB3aGVuIElPTU1VX0RPTUFJTl9JREVOVElUWSBp
cyBzZXQuDQo+IA0KPiBJIHN1Z2dlc3QgYSBuZXcgZG9tYWluIHR5cGUgZm9yIHVzZSBqdXN0IGZv
ciB0aGlzIHB1cnBvc2UuICBUaGlzIHdheSBpZiBob3N0IGhhcw0KPiBhbiBpb21tdSwgdGhlbiB0
aGUgc2FtZSBrZXJuZWwgY2FuIHJ1biBib3RoIFZNcyB3aXRoIGlzb2xhdGlvbiBhbmQgdW5zYWZl
DQo+IGVtYmVkZGVkIGFwcHMgd2l0aG91dC4NCkNvdWxkIHlvdSBwcm92aWRlIGZ1cnRoZXIgZGV0
YWlscyBvbiB0aGlzIGNvbmNlcHQ/IFdoYXQgY3JpdGVyaWEgd291bGQgZGV0ZXJtaW5lDQp0aGUg
Y29uZmlndXJhdGlvbiBvZiB0aGUgbmV3IGRvbWFpbiB0eXBlPyBXb3VsZCB0aGlzIHJlcXVpcmUg
YSBib290IHBhcmFtZXRlcg0Kc2ltaWxhciB0byBJT01NVV9ET01BSU5fSURFTlRJVFksIHN1Y2gg
YXMgaW9tbXUucGFzc3Rocm91Z2g9MSBvciBpb21tdS5wdD8NCj4gDQo+ID4gLS0tDQo+ID4gIGRy
aXZlcnMvdmhvc3QvdmRwYS5jIHwgMjMgKysrKysrKysrKysrKysrKysrKysrKysNCj4gPiAgMSBm
aWxlIGNoYW5nZWQsIDIzIGluc2VydGlvbnMoKykNCj4gPg0KPiA+IGRpZmYgLS1naXQgYS9kcml2
ZXJzL3Zob3N0L3ZkcGEuYyBiL2RyaXZlcnMvdmhvc3QvdmRwYS5jIGluZGV4DQo+ID4gYmM0YTUx
ZTQ2MzhiLi5kMDcxYzMwMTI1YWEgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy92aG9zdC92ZHBh
LmMNCj4gPiArKysgYi9kcml2ZXJzL3Zob3N0L3ZkcGEuYw0KPiA+IEBAIC0zNiw2ICszNiwxMSBA
QCBlbnVtIHsNCj4gPg0KPiA+ICAjZGVmaW5lIFZIT1NUX1ZEUEFfSU9UTEJfQlVDS0VUUyAxNg0K
PiA+DQo+ID4gK2Jvb2wgdmhvc3RfdmRwYV9ub2lvbW11Ow0KPiA+ICttb2R1bGVfcGFyYW1fbmFt
ZWQoZW5hYmxlX3Zob3N0X3ZkcGFfdW5zYWZlX25vaW9tbXVfbW9kZSwNCj4gPiArCQkgICB2aG9z
dF92ZHBhX25vaW9tbXUsIGJvb2wsIDA2NDQpOw0KPiA+ICtNT0RVTEVfUEFSTV9ERVNDKGVuYWJs
ZV92aG9zdF92ZHBhX3Vuc2FmZV9ub2lvbW11X21vZGUsDQo+ICJFbmFibGUNCj4gPiArVU5TQUZF
LCBuby1JT01NVSBtb2RlLiAgVGhpcyBtb2RlIHByb3ZpZGVzIG5vIGRldmljZSBpc29sYXRpb24s
IG5vDQo+ID4gK0RNQSB0cmFuc2xhdGlvbiwgbm8gaG9zdCBrZXJuZWwgcHJvdGVjdGlvbiwgY2Fu
bm90IGJlIHVzZWQgZm9yIGRldmljZQ0KPiA+ICthc3NpZ25tZW50IHRvIHZpcnR1YWwgbWFjaGlu
ZXMsIHJlcXVpcmVzIFJBV0lPIHBlcm1pc3Npb25zLCBhbmQgd2lsbA0KPiA+ICt0YWludCB0aGUg
a2VybmVsLiAgSWYgeW91IGRvIG5vdCBrbm93IHdoYXQgdGhpcyBpcyBmb3IsIHN0ZXAgYXdheS4N
Cj4gPiArKGRlZmF1bHQ6IGZhbHNlKSIpOw0KPiA+ICsNCj4gPiAgc3RydWN0IHZob3N0X3ZkcGFf
YXMgew0KPiA+ICAJc3RydWN0IGhsaXN0X25vZGUgaGFzaF9saW5rOw0KPiA+ICAJc3RydWN0IHZo
b3N0X2lvdGxiIGlvdGxiOw0KPiA+IEBAIC02MCw2ICs2NSw3IEBAIHN0cnVjdCB2aG9zdF92ZHBh
IHsNCj4gPiAgCXN0cnVjdCB2ZHBhX2lvdmFfcmFuZ2UgcmFuZ2U7DQo+ID4gIAl1MzIgYmF0Y2hf
YXNpZDsNCj4gPiAgCWJvb2wgc3VzcGVuZGVkOw0KPiA+ICsJYm9vbCBub2lvbW11X2VuOw0KPiA+
ICB9Ow0KPiA+DQo+ID4gIHN0YXRpYyBERUZJTkVfSURBKHZob3N0X3ZkcGFfaWRhKTsNCj4gPiBA
QCAtODg3LDYgKzg5MywxMCBAQCBzdGF0aWMgdm9pZCB2aG9zdF92ZHBhX2dlbmVyYWxfdW5tYXAo
c3RydWN0DQo+ID4gdmhvc3RfdmRwYSAqdiwgIHsNCj4gPiAgCXN0cnVjdCB2ZHBhX2RldmljZSAq
dmRwYSA9IHYtPnZkcGE7DQo+ID4gIAljb25zdCBzdHJ1Y3QgdmRwYV9jb25maWdfb3BzICpvcHMg
PSB2ZHBhLT5jb25maWc7DQo+ID4gKw0KPiA+ICsJaWYgKHYtPm5vaW9tbXVfZW4pDQo+ID4gKwkJ
cmV0dXJuOw0KPiA+ICsNCj4gPiAgCWlmIChvcHMtPmRtYV9tYXApIHsNCj4gPiAgCQlvcHMtPmRt
YV91bm1hcCh2ZHBhLCBhc2lkLCBtYXAtPnN0YXJ0LCBtYXAtPnNpemUpOw0KPiA+ICAJfSBlbHNl
IGlmIChvcHMtPnNldF9tYXAgPT0gTlVMTCkgew0KPiA+IEBAIC05ODAsNiArOTkwLDkgQEAgc3Rh
dGljIGludCB2aG9zdF92ZHBhX21hcChzdHJ1Y3Qgdmhvc3RfdmRwYSAqdiwNCj4gc3RydWN0IHZo
b3N0X2lvdGxiICppb3RsYiwNCj4gPiAgCWlmIChyKQ0KPiA+ICAJCXJldHVybiByOw0KPiA+DQo+
ID4gKwlpZiAodi0+bm9pb21tdV9lbikNCj4gPiArCQlnb3RvIHNraXBfbWFwOw0KPiA+ICsNCj4g
PiAgCWlmIChvcHMtPmRtYV9tYXApIHsNCj4gPiAgCQlyID0gb3BzLT5kbWFfbWFwKHZkcGEsIGFz
aWQsIGlvdmEsIHNpemUsIHBhLCBwZXJtLCBvcGFxdWUpOw0KPiA+ICAJfSBlbHNlIGlmIChvcHMt
PnNldF9tYXApIHsNCj4gPiBAQCAtOTk1LDYgKzEwMDgsNyBAQCBzdGF0aWMgaW50IHZob3N0X3Zk
cGFfbWFwKHN0cnVjdCB2aG9zdF92ZHBhICp2LA0KPiBzdHJ1Y3Qgdmhvc3RfaW90bGIgKmlvdGxi
LA0KPiA+ICAJCXJldHVybiByOw0KPiA+ICAJfQ0KPiA+DQo+ID4gK3NraXBfbWFwOg0KPiA+ICAJ
aWYgKCF2ZHBhLT51c2VfdmEpDQo+ID4gIAkJYXRvbWljNjRfYWRkKFBGTl9ET1dOKHNpemUpLCAm
ZGV2LT5tbS0+cGlubmVkX3ZtKTsNCj4gPg0KPiA+IEBAIC0xMjk4LDYgKzEzMTIsNyBAQCBzdGF0
aWMgaW50IHZob3N0X3ZkcGFfYWxsb2NfZG9tYWluKHN0cnVjdA0KPiB2aG9zdF92ZHBhICp2KQ0K
PiA+ICAJc3RydWN0IHZkcGFfZGV2aWNlICp2ZHBhID0gdi0+dmRwYTsNCj4gPiAgCWNvbnN0IHN0
cnVjdCB2ZHBhX2NvbmZpZ19vcHMgKm9wcyA9IHZkcGEtPmNvbmZpZzsNCj4gPiAgCXN0cnVjdCBk
ZXZpY2UgKmRtYV9kZXYgPSB2ZHBhX2dldF9kbWFfZGV2KHZkcGEpOw0KPiA+ICsJc3RydWN0IGlv
bW11X2RvbWFpbiAqZG9tYWluOw0KPiA+ICAJY29uc3Qgc3RydWN0IGJ1c190eXBlICpidXM7DQo+
ID4gIAlpbnQgcmV0Ow0KPiA+DQo+ID4gQEAgLTEzMDUsNiArMTMyMCwxNCBAQCBzdGF0aWMgaW50
IHZob3N0X3ZkcGFfYWxsb2NfZG9tYWluKHN0cnVjdA0KPiB2aG9zdF92ZHBhICp2KQ0KPiA+ICAJ
aWYgKG9wcy0+c2V0X21hcCB8fCBvcHMtPmRtYV9tYXApDQo+ID4gIAkJcmV0dXJuIDA7DQo+ID4N
Cj4gPiArCWRvbWFpbiA9IGlvbW11X2dldF9kb21haW5fZm9yX2RldihkbWFfZGV2KTsNCj4gPiAr
CWlmICgoIWRvbWFpbiB8fCBkb21haW4tPnR5cGUgPT0gSU9NTVVfRE9NQUlOX0lERU5USVRZKSAm
Jg0KPiA+ICsJICAgIHZob3N0X3ZkcGFfbm9pb21tdSAmJiBjYXBhYmxlKENBUF9TWVNfUkFXSU8p
KSB7DQo+IA0KPiBTbyBpZiB1c2Vyc3BhY2UgZG9lcyBub3QgaGF2ZSBDQVBfU1lTX1JBV0lPIGlu
c3RlYWQgb2YgZmFpbGluZyB3aXRoIGENCj4gcGVybWlzc2lvbiBlcnJvciB0aGUgZnVuY3Rpb25h
bGl0eSBjaGFuZ2VzIHNpbGVudGx5Pw0KPiBUaGF0J3MgY29uZnVzaW5nLCBJIHRoaW5rLg0KWWVz
LCB5b3UgYXJlIGNvcnJlY3QuIEkgd2lsbCBtb2RpZnkgdGhlIGNvZGUgdG8gcmV0dXJuIGVycm9y
IHdoZW4gdmhvc3RfdmRwYV9ub2lvbW11DQppcyBzZXQgYW5kIENBUF9TWVNfUkFXSU8gaXMgbm90
IHNldC4NCg0KVGhhbmtzLg0KPiANCj4gDQo+ID4gKwkJYWRkX3RhaW50KFRBSU5UX1VTRVIsIExP
Q0tERVBfU1RJTExfT0spOw0KPiA+ICsJCWRldl93YXJuKCZ2LT5kZXYsICJBZGRpbmcga2VybmVs
IHRhaW50IGZvciBub2lvbW11IG9uDQo+IGRldmljZVxuIik7DQo+ID4gKwkJdi0+bm9pb21tdV9l
biA9IHRydWU7DQo+ID4gKwkJcmV0dXJuIDA7DQo+ID4gKwl9DQo+ID4gIAlidXMgPSBkbWFfZGV2
LT5idXM7DQo+ID4gIAlpZiAoIWJ1cykNCj4gPiAgCQlyZXR1cm4gLUVGQVVMVDsNCj4gPiAtLQ0K
PiA+IDIuMjUuMQ0KDQo=

