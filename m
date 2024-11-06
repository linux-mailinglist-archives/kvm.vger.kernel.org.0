Return-Path: <kvm+bounces-30950-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B03579BEA85
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 13:47:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 414BA1F24730
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 12:47:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CC611FB3DC;
	Wed,  6 Nov 2024 12:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=marvell.com header.i=@marvell.com header.b="LdJnzd2Y"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 390041EE00A
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 12:38:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.148.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896708; cv=fail; b=Fpn/axFE36sO13xjaElS4YzdmKektDZ9T961yV1eqwyAFWHUSIyiMtgldTLIMQHgqkuipkidGrdphrxDCEQapT25j8GnLJzMjlhJ7rja6j0IrUtuEPiPlw6f1AQPNlj0zJbzc9f0IFx1Yw2k5+tUKoq7YW/RQpr7SGRca1XM4pc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896708; c=relaxed/simple;
	bh=JYz1hrC2SI+4Y67UcItEkqqTrodMQcaqP9iXfPxVgVg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 MIME-Version:Content-Type; b=iltjz+VXJPbCeF8DGieqW0kcw57w1tUuUkaCfNKiWtt9tq5Qt9TflzXpwU/KdAliTuZpGdloP7h7rTLBrJdCbB/q6IoXlWTwAZFaJhpxYqHxTUSDm38HDwtWdXYIroo5gc6+gvq6jPVSwVXo/5cH+UQTeqemtl5aRQAYz0B6SQM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=fail (1024-bit key) header.d=marvell.com header.i=@marvell.com header.b=LdJnzd2Y reason="signature verification failed"; arc=fail smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4A6AltmR013381;
	Wed, 6 Nov 2024 04:38:10 -0800
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 42r715r60b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 06 Nov 2024 04:38:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iccS0T4FqNzbQNMSi/C71Ds8IvTYY3LQ7csyrQyOut1n9BPHcSEUsYrinDaRar03eZJBH6GJ1G5E/cW7+11Q+hSU3lyMsE+w+3992j0U46bMwlWH0MOC2UGVjiAZENO+zVweeLY0GDXtKQFa76Za7xgxxZ1NlE+f2J8QqRaIqsKnycVjk4CtrYgxKWQwnN28rgQJb8DPwaYpVrrcCIq4+HV6cPmWRKKuanmc8M8zuGRdby0qrDhWADVwoY8zh2ScpKqWeu99rccMl4kgG6OkODwwmYTeOoH/kEYE7+/i5IfXdf0uIQTqP+BwBtRxeJ4/vE9SWKBpjbNk93kUKgQIzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S0zmzj4MWBMqgH+yawVSM+Y/ogiwarwGeriFgjxAhis=;
 b=LXV/E7oGxNDjn0YiJFXlY0722SaloJGvR1jCcMOR4SGnXKcZ2Dx9nEV59z1GboAZ4Lzs6Igs/4zYcK0tFNUVt3iUwMqNpR4c443PK+8iy4wamihzgjSY4Jk0DCNqe/Kmd73sIUv7VTRXM85lgg9WjkCtY309UBiS5hrEPJm7w7sJiCpGAS+Co1rzZJqWL8kGE6ix0lBeFBwAzmww2QG5/18GQm+BLVeU83eCpwCPg0vt3fYXHLFehkx5jzQQP9eRy5XkRyJJSkAhgIQ4VrW+u63tafZlbG5N2sp1jNaUEJwk5jsNIppUJIxqhXVC34Sq6Bio6QvpANdGgcJT6K+e4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S0zmzj4MWBMqgH+yawVSM+Y/ogiwarwGeriFgjxAhis=;
 b=LdJnzd2YSc+AT9gJgE+BAIc34hxDaI+v3YTvxZ4EFZbcka+xEYbFTsFYNGoIc1Vm1mcvYfLg+gZJIJPRX0Wu8nrqB+u3sgsBhKzoj5vXcj+hjLCnRAMjxrw7ga8HKvMnsohsbIYbcyxaQQO6GgWZd3DfvuFXtW/5sn5dN2jjIG4=
Received: from DS0PR18MB5368.namprd18.prod.outlook.com (2603:10b6:8:12f::17)
 by CH3PR18MB5981.namprd18.prod.outlook.com (2603:10b6:610:1e2::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.31; Wed, 6 Nov
 2024 12:38:02 +0000
Received: from DS0PR18MB5368.namprd18.prod.outlook.com
 ([fe80::ad53:bef2:cc17:13ac]) by DS0PR18MB5368.namprd18.prod.outlook.com
 ([fe80::ad53:bef2:cc17:13ac%5]) with mapi id 15.20.8114.028; Wed, 6 Nov 2024
 12:38:02 +0000
From: Srujana Challa <schalla@marvell.com>
To: Christoph Hellwig <hch@infradead.org>,
        "Michael S. Tsirkin"
	<mst@redhat.com>
CC: "virtualization@lists.linux.dev" <virtualization@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jasowang@redhat.com"
	<jasowang@redhat.com>,
        "eperezma@redhat.com" <eperezma@redhat.com>,
        Nithin
 Kumar Dabilpuram <ndabilpuram@marvell.com>,
        Jerin Jacob <jerinj@marvell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: RE: [EXTERNAL] Re: [PATCH v2 0/2] vhost-vdpa: Add support for
 NO-IOMMU mode
Thread-Topic: [EXTERNAL] Re: [PATCH v2 0/2] vhost-vdpa: Add support for
 NO-IOMMU mode
Thread-Index:
 AQHbE96PlQaeJdnt006ohvbKHfff0rKGTA1AgAD2ZICAAnsvgIAA0r4AgARSlACABScygIAAFo4AgAGfYICAFKe0YA==
Date: Wed, 6 Nov 2024 12:38:02 +0000
Message-ID:
 <DS0PR18MB5368B1BCC3CFAE5D7E4EB627A0532@DS0PR18MB5368.namprd18.prod.outlook.com>
References: <20240920140530.775307-1-schalla@marvell.com>
 <Zvu3HktM4imgHpUw@infradead.org>
 <DS0PR18MB5368BC2C0778D769C4CAC835A0442@DS0PR18MB5368.namprd18.prod.outlook.com>
 <Zw3mC3Ej7m0KyZVv@infradead.org>
 <20241016134127-mutt-send-email-mst@kernel.org>
 <ZxCrqPPbidzZb6w1@infradead.org>
 <20241019201059-mutt-send-email-mst@kernel.org>
 <ZxieizC7zeS7zyrd@infradead.org>
 <20241023041739-mutt-send-email-mst@kernel.org>
 <ZxoN57kleWecXejY@infradead.org>
In-Reply-To: <ZxoN57kleWecXejY@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR18MB5368:EE_|CH3PR18MB5981:EE_
x-ms-office365-filtering-correlation-id: 5109d832-a8ce-4c42-39ca-08dcfe5fda8a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?Y1BnQ1gyOUpVVENORWxibmtTVlRJNDRQcmtQKzFGRG96alZmMFFrZENSa2t4?=
 =?utf-8?B?QUlUMGlYQzI5QUFCeTl1VmRmc04yclZheFFiNVlNeGl2K1FCS1MrWENkeEJQ?=
 =?utf-8?B?YU1aQi9ETWFBS3VDMmVVRWMzT0lMV1FLMmRZNE10aTFyTnpRa21KQUh2dUl6?=
 =?utf-8?B?UzJyWEFkaWZlaFBrYmh3ZHhnZXdLSFBWc2EzUDNHdStGdGtKSTdCU0xvd0lX?=
 =?utf-8?B?WTZKTDRkU09ib1puT1U3VlJtbUlFbXZhWjNGdFp0d2YzUzB5N0JZMy9PYW00?=
 =?utf-8?B?cW5rNmFoSXZudkQyZkRFc3dDZXN5QlNadlJMWEI0TFYrMTdEa2U2bmo3b3FC?=
 =?utf-8?B?bnVtME0rY3VnMDhldmF0Z1lrWkZmaDBWRUdkZ2lId2R3UWJwNHRmc3JCc3Yv?=
 =?utf-8?B?SjBZVzU0WWt5MmpYdDRaVzk3SEJxbmdJOTV5a1Y4SDBCbklobERCRnFzNzZB?=
 =?utf-8?B?YVhxRzFzMGpta3p1aVhqcVF3c3JZb25SdEZxSkx6cFVuYitCWElCTUluY3I5?=
 =?utf-8?B?T0FvNXl0OWlhNWNTdUhwU2tyU1JTcVhPOVBYbG12RWk2UDJDZkhZQzFGajBy?=
 =?utf-8?B?eGJCa3ZVT2Z2amxzVE9hNVZkRDdjOC9IdFpjajJVUmJWYXNodEc0eXBwQUNx?=
 =?utf-8?B?NTFZbDFqUHVHZmF1eVJ6c3haMTVKWjJpVE5wOUhCMmZsT3VwRWR1K2RrUHla?=
 =?utf-8?B?L25YNEluTGxBV0lNbThJbkdBTmRFVTNFU2ZLK1N0bnVBdDQvSCtocGpwOVB6?=
 =?utf-8?B?cHI0bnpqckZ4bnR1YmdickdVNitGNlVpVWUxNXl1emxOWk4vaFJYMHFKUDdI?=
 =?utf-8?B?WXd4cmpsTlNqc2NaY1FjR1pDWm5ZQzM2Q3NWbHAyanpBditWRENoZjc4TVA4?=
 =?utf-8?B?RDM2dXpJTW5OTWRIVGRzTnlKdERHaU1CR2o1RjdDVUg4aXpxaWZOVldCZE5x?=
 =?utf-8?B?TFBtMWlUbFVtaXNrRFlhWm5KUDMwdVZLZG5GL0JkMG5sWWZlQ2psSG5INGpo?=
 =?utf-8?B?UDYzdGtXY2pDNmhUQnB1bWJwUXJqUFdET0ZpNjJJb0VXRkpEZWZJRlBkY0xq?=
 =?utf-8?B?TDd1UzN0dU5RUWVpRXlUUUJIalRSeE1OcHovQzVHUlpDcE5mUW41dFpWOFl3?=
 =?utf-8?B?dkxhODQ4K3VNcmtzY05kblFieDZQMXdZVGNCQUF1SnJvZFBlRDVyZE55dkZW?=
 =?utf-8?B?aXk0N2x6SytyMlRTbG1DN0M0UCtDSGEvblp2MG1kOFUvVXhwejBpbXV6TE5C?=
 =?utf-8?B?RTg4aXBpQjhwRHRjSkhQTlJHNjVyc0ZUTStlWGswMmhXV082Q2ZkMm9WVTc5?=
 =?utf-8?B?all6UVFqTkxzdEdseTlIMDBRRGYwRElITTdIeE1uSEZKR3BVMjVXd2N4ZjA2?=
 =?utf-8?B?UE9lR2VqeFdrOUl2L3IrN0pTemxyU1dlT0NDalFheDVMYms0TUR2US95QWxu?=
 =?utf-8?B?ZGdQNDJUZkJVcGM2eHB2aEVxc29QMTI5WUM4YzBBekVQODVDZUhoaVIrK21T?=
 =?utf-8?B?SUlXU3g3bE5EbFBORmtZZ1VlYXlJWm1DekVSOXQwSlNxcHVVak9IaEdNa3BB?=
 =?utf-8?B?RWZtV3RWT1Noa25HYjRUcGFubjFuaFdOM2FoZGhuM085Q2xjY2pia1V6L0NS?=
 =?utf-8?B?WHNJYmM1S2kzOERoaUM5RDJjWjNyMGp0ZXBmdkl0eUdQSmJiQkhMY292SkYx?=
 =?utf-8?B?a3h5M2NqQldSZERLVG52RjZ4N09vam8xVTZucWVKcnlXdndnNUxuNUlDT3dv?=
 =?utf-8?Q?7uta/Kn9y2pncG74JOMpPTZ6w1Ju10vzx0ymFU3?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR18MB5368.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?cW5xMENERXpWY1E0bDhYOU03Y1ZOaXY5c3lPbERmMzU3TGR2b0I0V3hDdzdv?=
 =?utf-8?B?bnVWV0JPckUyS2NadFBpVzk5VEZsL2hKNXBRUGNCYzMxU3FZSXRHakt2TEU3?=
 =?utf-8?B?cndRMC91OGFPdkNGK1daTVB5NEU1RHRMVVVQWXd2Nk8zYXlDaDVYWDQvTXFz?=
 =?utf-8?B?SzJZQWNTREQvZ1h0b0lJM2wxcUJCTTE3M3V5Zy9KbnY4ZXBMRTdXMHNTaWN5?=
 =?utf-8?B?eDk4Q1JZV0E4aGdYZVZkNlBocTUwTVUvdk84dFlhNWhDdVg3aHUwZUxaRnNJ?=
 =?utf-8?B?MTdHZFBJMXI1NGh2eEErRUxFdWp6SUZiRENuekU4djJLc0FQdHRsZStSNGFT?=
 =?utf-8?B?c25QbzhTYkVYMExydWFCUFVnaEc2L3VmdHo0Tzd2QzJjQ3o4ZnQ2T0VPVktj?=
 =?utf-8?B?SVB1RWlmOFRrOE91VHVoMG1vNmt4c3ZPaklDdGxabUdvVkIraTRJUTQ1MnhL?=
 =?utf-8?B?cUZ3aHpGQ0NJekFqTkNoU3UxTVFTUVNvd2ZCaVNKUjB5c21KZ2UydWNNM0Ux?=
 =?utf-8?B?Unp2NjBHSFJDUDh3WEx5U3M2N0oydHNja1JkaDFyZ095RFl2SS95WmdHRkU0?=
 =?utf-8?B?TDJRL1JxVkNXSFhzYWRQbHhaSERJeFIxb3RlU0VRV0R4U3VBTS9jaHBKWFNy?=
 =?utf-8?B?TlhoeW91T0EwOEh0T0Y2a3V6aFd1RXJ5SGoxaXBqNnZFRlVaRjd5eUhHUjM2?=
 =?utf-8?B?WUpBdjgxUE1JcE0xR29CQXdDdGFqRlE3Mm53VmNFUWxLK1MvMUtVak1KWklK?=
 =?utf-8?B?WWYwZU1ZdnM4VU4rdTI4cTJWMExKRjdmL2s2SEJ0b0NzRlMrbkhTSHhHODlw?=
 =?utf-8?B?bEp1S0xNc2FLWExSWnk4ZXZJcmYwK0MxeGJhWEVQMndzVXF2c2ZPZUE2eDJG?=
 =?utf-8?B?dWF4QUJkaWgwYXVnOXhqZTFEVVFHUWtBN3VVd1FhRkxkMHFFeEZpU1M0aWFJ?=
 =?utf-8?B?ZUdIT0psbjNnRHFnTXlYd3V5dkIrNVJNYllZRDJ6Z2o2Z0VMaWNqd1RLVWZT?=
 =?utf-8?B?M3V2T2srTWl1RklaMXZpNStkdlY1UjI0SkloVWpTbVJCNnlLcDRheEtOSWJY?=
 =?utf-8?B?STFrYjhpeVYrZFdKV1JqRGVxc21XbGliOUJpUzFuL3JZNHRZR2pDdFBaZStP?=
 =?utf-8?B?dmI5SEZ6eW5wY2dEbjBJTlJRcWt6V1NYVGo5UlpmYnE5VlR3czFra1Q0RHVo?=
 =?utf-8?B?T2tqcEsvWDNFUWIwUFhLQS9vWGJNZmFjSTdMMENMYXVvL3ZydjZwY1V2Y2FI?=
 =?utf-8?B?bjhmVllrVlo3aXNLdzd1dzVINWdraDhkRTgyU3k4RmlmTnlUcWJWaHNvbmU2?=
 =?utf-8?B?THlLN3VSaTJVMkc1TDA5UjNKL28xb2VzRkI3bkMwcC9QSHAxMUhXd1RWemlM?=
 =?utf-8?B?aW9Ka0ZabER0ejgyeDNycVpRdFFCSXlHU2ZITDdNODhkYXNQdi93OGZoR1Nw?=
 =?utf-8?B?RjlXNllSWnYrUVFPN1NLZmFXc0tJOVUrd3R0dzJaQ0xjVHZLazhTVnRyZjVh?=
 =?utf-8?B?SFJZTnZJdWlRak5ybDg3ZGp6RXd5cUZYY2N3ZkhmRE5kWjRsdGpwWmJhS0t5?=
 =?utf-8?B?b0NsaFVheFE5WjhIUlNRNVk0NkNQcWM3ZkRnMHZZdENXTTBNV0RURzd6Nlho?=
 =?utf-8?B?WURoQU1CSVNLR2REdXUrZHJiTVIzSU1QcnFTTmE1Q0dKTzVXQk5wdVYydGxS?=
 =?utf-8?B?Ry9uZ3dHbzhaVElzWUxob3JwZndMRlpmM1BIWFIwT2lFUXdFUXhPbmVBS0ta?=
 =?utf-8?B?QkZlditSSk9xZGUyaWtXRTRrZGYyZ1dnUExEOXFQdUdiR1Z6SkZYZTNLbTdD?=
 =?utf-8?B?Y1N0WThtRUF5TGZWemo3UGFzZHNpbzZkbzcvQ2xONDF6aEpYQXhveHR5Q2Fv?=
 =?utf-8?B?QUptUnZxR0hhakVLNE52dHBZSmFIWlkxRU5UWFczeVF1elJ1eXh0Mmh5eEpr?=
 =?utf-8?B?dzJTQlR5c3ZoaVpTMkFCcVF6TmRwSlJCdnZGMkZ2TGlZWHVwWWkwSDROci9L?=
 =?utf-8?B?WlA1YUF2QlNtUWt5UTJNOVU2eEZKREN6Z1RRRzRZWitiZ2xVeGl4RS9Sb2sz?=
 =?utf-8?B?UDZ5MC9zQjNjbi9qT3ltUFovTHhUTXljK3MxYmh3OTlwS0dma0VnWnZVNVY0?=
 =?utf-8?Q?Zor4=3D?=
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR18MB5368.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5109d832-a8ce-4c42-39ca-08dcfe5fda8a
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Nov 2024 12:38:02.1148
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eu2rvLciuE5KrsxiXUvMypxWWxJ1QXPIxCQ/cl9AuEUYQnh78sTs/zEn3GnMuksMfDP715bMVGKneiMm8OocTA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR18MB5981
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-GUID: XixeEORKBFJRAgomBpI5PymDgXLUGYL4
X-Proofpoint-ORIG-GUID: XixeEORKBFJRAgomBpI5PymDgXLUGYL4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.687,Hydra:6.0.235,FMLib:17.0.607.475
 definitions=2020-10-13_15,2020-10-13_02,2020-04-07_01

> Subject: Re: [EXTERNAL] Re: [PATCH v2 0/2] vhost-vdpa: Add support for NO-
> IOMMU mode
>=20
> On Wed, Oct 23, 2024 at 04:=E2=80=8A19:=E2=80=8A02AM -0400, Michael S. Ts=
irkin wrote: > On
> Tue, Oct 22, 2024 at 11:=E2=80=8A58:=E2=80=8A19PM -0700, Christoph Hellwi=
g wrote: > > On Sat,
> Oct 19, 2024 at 08:=E2=80=8A16:=E2=80=8A44PM -0400, Michael S. Tsirkin wr=
ote: > > > Because
>=20
> On Wed, Oct 23, 2024 at 04:19:02AM -0400, Michael S. Tsirkin wrote:
> > On Tue, Oct 22, 2024 at 11:58:19PM -0700, Christoph Hellwig wrote:
> > > On Sat, Oct 19, 2024 at 08:16:44PM -0400, Michael S. Tsirkin wrote:
> > > > Because people want to move from some vendor specific solution
> > > > with vfio to a standard vdpa compatible one with vdpa.
> > >
> > > So now you have a want for new use cases and you turn that into a
> > > must for supporting completely insecure and dangerous crap.
> >
> > Nope.
> >
> > kernel is tainted -> unsupported
> >
> > whoever supports tainted kernels is already in dangerous waters.
>=20
> That's not a carte blanche for doing whatever crazy stuff you want.
>=20
> And if you don't trust me I'll add Greg who has a very clear opinion on
> IOMMU-bypassing user I/O hooks in the style of the uio driver as well I t=
hink
> :)

It is going in circles, let me give the summary,
Issue: We need to address the lack of no-IOMMU support in the vhost vDPA dr=
iver for better performance.
Measured Performance: On the machine "13th Gen Intel(R) Core(TM) i9-13900K,=
 32 Cores", we observed
a performance improvement of 70 - 80% with intel_iommu=3Doff when we run hi=
gh-throughput network
packet processing.
Rationale for Fix: High-end machines which gives better performance with IO=
MMU are very expensive,
and certain use cases, such as embedded environment and trusted application=
s, do not require
the security features provided by IOMMU.
Initial Approach: We initially considered a driver-based solution, specific=
ally integrating no-IOMMU
support into Marvell=E2=80=99s octep-vdpa driver.
Initial Community Feedback: The community suggested adopting a VFIO-like sc=
heme to make the solution
more generic and widely applicable.
Decision Point: Should we pursue a generic approach for no-IOMMU support in=
 the vhost vDPA driver,
or should we implement a driver-specific solution?

Thanks,
Srujana.

