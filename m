Return-Path: <kvm+bounces-26778-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D7DF977672
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 03:38:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 414D328580E
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 01:38:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E22F79DE;
	Fri, 13 Sep 2024 01:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="R5cFq1jC"
X-Original-To: kvm@vger.kernel.org
Received: from esa2.fujitsucc.c3s2.iphmx.com (esa2.fujitsucc.c3s2.iphmx.com [68.232.152.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 670DB4C96
	for <kvm@vger.kernel.org>; Fri, 13 Sep 2024 01:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.152.246
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726191525; cv=fail; b=GZRgkhLrMyEM7EZ5Z6S/5IPKqt9KKipDLad+m+YA7hbhlzUiquGCOgHbw4JEUF28BUdJfvhwSVPxpVIWAuhpB4gGX56XmjEEKf1gzJzxfv/PNrKpZ915/JZ7xDT4moVjEXy1WelP/LBa07ncs43jpAW9cG93A7KkfaIWm1K1afM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726191525; c=relaxed/simple;
	bh=xixiJdwEler2ROnXrSw4Tlar93LWHdTp63lq/5oJc7Y=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=AXX5yfeDPdY5sAP4OnJ3h734+cw8JpW2UT5XtSwRaHdgTqFZPpEQyeVoEsboQKtbiauazSJuVfnWLA7i6Nz25zIOuBjX8LY1o/EXPij+uRPdCTPnN8OdeTSBikKXmukvB7Ey3cJuUuSJX3rtgujezgD8EEUTTvo25X1z4Qjl/bQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=R5cFq1jC; arc=fail smtp.client-ip=68.232.152.246
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1726191522; x=1757727522;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=xixiJdwEler2ROnXrSw4Tlar93LWHdTp63lq/5oJc7Y=;
  b=R5cFq1jCtjN9+3HLX1nf2kb6zCGELPXMUe7PNZswbrj3to6H7zdsJDX2
   sYY5jHDYeVc5aR4SW8u0MbVp+Q/tHPALMustkgEo/I6j/Kf8lmFazc+l9
   VQG6ujeLAOJNn8aG31yFiphZyz9zT8+dRGcjKeq4Y9O6T5mrafMd/2GA2
   WTO0QoQTnjinLvh5UiR6F1rdffzTyAfmH0eNP9VN2Gy2oMXVeAkFLIcc0
   SvGT+TR6yvmbKrh/8vwXZwMQv8Zanp3Jxe7MoNIWhPfnfZPnYN8TS+Lyv
   wgiU8cB9szrU6VhBGSsfuKjlrjJpyYRfc1mUuu4oEsvsbsFiALRkgrfYR
   Q==;
X-CSE-ConnectionGUID: AeV7ToBBSmmvhyCYErfiuw==
X-CSE-MsgGUID: 8Eg9nG67TNuHL9h6DifRYg==
X-IronPort-AV: E=McAfee;i="6700,10204,11193"; a="41741357"
X-IronPort-AV: E=Sophos;i="6.10,224,1719846000"; 
   d="scan'208";a="41741357"
Received: from mail-japanwestazlp17010001.outbound.protection.outlook.com (HELO OS0P286CU011.outbound.protection.outlook.com) ([40.93.130.1])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2024 10:37:14 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=A7X2VKsC6qNBPgJUEfskDsONGEBMuhXAdhkkwHaqOJFUOAyedZEjq4WKBYBd2PPJi2R1kXap37FEFomuP8GlAFxEYGcoSJEC5HMykJ76biDnJf0hgcazl5T3kO5WwLiZGBhoykPgVyVi0wSu/2CqXKy3YZGBmBWrhsg2l9dvG5kTy8DDEXTQQbajJtd/52WrWvDsEu0IehM5bCVPuTBFNAp+yTIJcy83+yJJsEqNjQKG26gXhtw/4MnUfFXNlkCzZORzP7noeuRhr7OCVV+IyPHPV2OaYgL6mHvZmpzuR4AULw/Nkd4MBIUnVwGGc0BTK1wTQWYIRh5bboUBEZuiEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xixiJdwEler2ROnXrSw4Tlar93LWHdTp63lq/5oJc7Y=;
 b=i3ebGT9TO1Z3qGVkRnfBnLh0JSO2n35U/g8UvDhrozSG0Q4E+R4C/lWP9HAvWgoDhGTlJTDFPHn5o3OL37zG6nXRQu+gN3QOFsNWADQ0Nfg+pHJxH1v++ozfnIHQH2VlQcrN2hT03k8Se8mpQti4o8PX9rHxdt/ZXkJEJosayP6c0uObk2ahgQXbJTaCzXkjCCPtJKs8+ZIXtFtuJBLMMewIUHpyqFuD5JwpHakCnPbLaKxjzlhHpz7ugbIhw2WZI7UwtyD05wAJKG3cmTZzuU3LQQwzy65Qq/6pDa3EPwzIrGQq9K3YT9zcFoJjRC8GQdVPDjiyKgjxpzVmR0o61g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
Received: from OSZPR01MB6453.jpnprd01.prod.outlook.com (2603:1096:604:ed::14)
 by TYYPR01MB7069.jpnprd01.prod.outlook.com (2603:1096:400:db::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.19; Fri, 13 Sep
 2024 01:37:08 +0000
Received: from OSZPR01MB6453.jpnprd01.prod.outlook.com
 ([fe80::9ef5:e83:9047:de11]) by OSZPR01MB6453.jpnprd01.prod.outlook.com
 ([fe80::9ef5:e83:9047:de11%5]) with mapi id 15.20.7939.022; Fri, 13 Sep 2024
 01:37:08 +0000
From: "Xingtao Yao (Fujitsu)" <yaoxt.fnst@fujitsu.com>
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, "qemu-devel@nongnu.org"
	<qemu-devel@nongnu.org>
CC: Jason Wang <jasowang@redhat.com>, =?utf-8?B?QWxleCBCZW5uw6ll?=
	<alex.bennee@linaro.org>, Laurent Vivier <lvivier@redhat.com>, Marcelo
 Tosatti <mtosatti@redhat.com>, Nicholas Piggin <npiggin@gmail.com>, Klaus
 Jensen <its@irrelevant.dk>, WANG Xuerui <git@xen0n.name>, Halil Pasic
	<pasic@linux.ibm.com>, Rob Herring <robh@kernel.org>, Michael Rolnik
	<mrolnik@gmail.com>, Zhao Liu <zhao1.liu@intel.com>, Peter Maydell
	<peter.maydell@linaro.org>, Richard Henderson <richard.henderson@linaro.org>,
	Fabiano Rosas <farosas@suse.de>, Corey Minyard <minyard@acm.org>, Keith Busch
	<kbusch@kernel.org>, Thomas Huth <thuth@redhat.com>, "Maciej S. Szmigiero"
	<maciej.szmigiero@oracle.com>, Harsh Prateek Bora <harshpb@linux.ibm.com>,
	Kevin Wolf <kwolf@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, Jesper
 Devantier <foss@defmacro.it>, Hyman Huang <yong.huang@smartx.com>,
	=?utf-8?B?UGhpbGlwcGUgTWF0aGlldS1EYXVkw6k=?= <philmd@linaro.org>, Palmer
 Dabbelt <palmer@dabbelt.com>, "qemu-s390x@nongnu.org"
	<qemu-s390x@nongnu.org>, Laurent Vivier <laurent@vivier.eu>,
	"qemu-riscv@nongnu.org" <qemu-riscv@nongnu.org>, "Richard W.M. Jones"
	<rjones@redhat.com>, Liu Zhiwei <zhiwei_liu@linux.alibaba.com>, Aurelien
 Jarno <aurelien@aurel32.net>, =?utf-8?B?RGFuaWVsIFAuIEJlcnJhbmfDqQ==?=
	<berrange@redhat.com>, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, Christian Borntraeger
	<borntraeger@linux.ibm.com>, Akihiko Odaki <akihiko.odaki@daynix.com>, Daniel
 Henrique Barboza <dbarboza@ventanamicro.com>, Hanna Reitz
	<hreitz@redhat.com>, Ani Sinha <anisinha@redhat.com>, "qemu-ppc@nongnu.org"
	<qemu-ppc@nongnu.org>, =?utf-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?=
	<marcandre.lureau@redhat.com>, Alistair Francis <alistair.francis@wdc.com>,
	Bin Meng <bmeng.cn@gmail.com>, "Michael S. Tsirkin" <mst@redhat.com>, Helge
 Deller <deller@gmx.de>, Peter Xu <peterx@redhat.com>, Daniel Henrique Barboza
	<danielhb413@gmail.com>, Dmitry Fleytman <dmitry.fleytman@gmail.com>, Nina
 Schoetterl-Glausch <nsg@linux.ibm.com>, Yanan Wang <wangyanan55@huawei.com>,
	"qemu-arm@nongnu.org" <qemu-arm@nongnu.org>, Igor Mammedov
	<imammedo@redhat.com>, Jean-Christophe Dubois <jcd@tribudubois.net>, Eric
 Farman <farman@linux.ibm.com>, Sriram Yagnaraman
	<sriram.yagnaraman@ericsson.com>, "qemu-block@nongnu.org"
	<qemu-block@nongnu.org>, Stefan Berger <stefanb@linux.vnet.ibm.com>, Joel
 Stanley <joel@jms.id.au>, Eduardo Habkost <eduardo@habkost.net>, David Gibson
	<david@gibson.dropbear.id.au>, Fam Zheng <fam@euphon.net>, Weiwei Li
	<liwei1518@gmail.com>, Markus Armbruster <armbru@redhat.com>
Subject: RE: [PATCH v2 00/48] Use g_assert_not_reached instead of
 (g_)assert(0, false)
Thread-Topic: [PATCH v2 00/48] Use g_assert_not_reached instead of
 (g_)assert(0, false)
Thread-Index: AQHbBOcD6IgVKZuIjkK8WaTrDJ6NE7JU78/A
Date: Fri, 13 Sep 2024 01:37:07 +0000
Message-ID:
 <OSZPR01MB6453486D937E15FBF6AEAD018D652@OSZPR01MB6453.jpnprd01.prod.outlook.com>
References: <20240912073921.453203-1-pierrick.bouvier@linaro.org>
In-Reply-To: <20240912073921.453203-1-pierrick.bouvier@linaro.org>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 =?utf-8?B?TVNJUF9MYWJlbF8xZTkyZWY3My0wYWQxLTQwYzUtYWQ1NS00NmRlMzM5Njgw?=
 =?utf-8?B?MmZfQWN0aW9uSWQ9ZmViZGExYWEtOTU4MC00YTFlLThlOTEtY2M0YzE4N2Zm?=
 =?utf-8?B?ZGE5O01TSVBfTGFiZWxfMWU5MmVmNzMtMGFkMS00MGM1LWFkNTUtNDZkZTMz?=
 =?utf-8?B?OTY4MDJmX0NvbnRlbnRCaXRzPTA7TVNJUF9MYWJlbF8xZTkyZWY3My0wYWQx?=
 =?utf-8?B?LTQwYzUtYWQ1NS00NmRlMzM5NjgwMmZfRW5hYmxlZD10cnVlO01TSVBfTGFi?=
 =?utf-8?B?ZWxfMWU5MmVmNzMtMGFkMS00MGM1LWFkNTUtNDZkZTMzOTY4MDJmX01ldGhv?=
 =?utf-8?B?ZD1Qcml2aWxlZ2VkO01TSVBfTGFiZWxfMWU5MmVmNzMtMGFkMS00MGM1LWFk?=
 =?utf-8?B?NTUtNDZkZTMzOTY4MDJmX05hbWU9RlVKSVRTVS1QVUJMSUPigIs7TVNJUF9M?=
 =?utf-8?B?YWJlbF8xZTkyZWY3My0wYWQxLTQwYzUtYWQ1NS00NmRlMzM5NjgwMmZfU2V0?=
 =?utf-8?B?RGF0ZT0yMDI0LTA5LTEzVDAxOjMyOjQwWjtNU0lQX0xhYmVsXzFlOTJlZjcz?=
 =?utf-8?B?LTBhZDEtNDBjNS1hZDU1LTQ2ZGUzMzk2ODAyZl9TaXRlSWQ9YTE5ZjEyMWQt?=
 =?utf-8?Q?81e1-4858-a9d8-736e267fd4c7;?=
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: OSZPR01MB6453:EE_|TYYPR01MB7069:EE_
x-ms-office365-filtering-correlation-id: a72c9a87-9902-465e-c373-08dcd394946e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|7416014|366016|376014|38070700018|1580799027;
x-microsoft-antispam-message-info:
 =?utf-8?B?NXBMQlV2KzVyWm9Cdlk4YTh6aFE3TVpYdnhOUnpzV3YzcU9RNGFCa0pVNVNs?=
 =?utf-8?B?NmwrUlFqRU96ckhkcFB4REZtSytJNE9WVEJ1eXprL3huZzdhWDMzSFVNSHF0?=
 =?utf-8?B?WlhtMElVVHk2clIwK0NINCthVEtaYlZnOE05VDd5QmJqOXRRckxSTm1WL0tP?=
 =?utf-8?B?TVpQemdQSHRHc0VTWndwZkRPQUN1MWVEdGYzc1oyQ0RmRVg5SzF3bXpuQWIr?=
 =?utf-8?B?OUpxeWIxZVZ0OHkzcENDVVVUdWQ1czFyWkR0YW5iS08wcGROWFNJZWdPTDdC?=
 =?utf-8?B?SG5qVGM3NW15ZU5tRXh3Tk5JK05kK2pidXJhYUxHNm1NK0ltVEhvM1lHd25p?=
 =?utf-8?B?Nkl0YW8xODRkcFhCdkNVajhxTjFaMFFSejloV3g5QUV0UDlYTFhFTjZzc3RC?=
 =?utf-8?B?U2NHdTEvemVhNmFycG9nWEZSaThaVmVISkM4TTMwN0I3QVgrZGF0VWFxY2ND?=
 =?utf-8?B?OFBVRVZmUlNpaHBlVHprR0dwR0ZkbnZUOG1nV3Q2SGlMaGk1SE5OWFFoaWhK?=
 =?utf-8?B?dVQwTzVrTmdYMTA1V0hORFpoZFhuYnV5VU5OdG9QK3FOREJSa3FvV3VBQ3Z2?=
 =?utf-8?B?L21TaS9CaEtQMGNPdXE1MGhaMXRIKzkwb0hqU29oSGZ6cHNGOWM1ODA2YmYv?=
 =?utf-8?B?RUlLakg3V0RDRUdyeVozdVdLUFJjaFVqMUV6ZFJCTHJBblVUK1UyeUptUjhZ?=
 =?utf-8?B?VGMxRndoRDZMdWxiVUxiZW5BdnN4N2xkRlp0NzluZE9ySVYyWFdWbjZ6NUtx?=
 =?utf-8?B?dEQveUpsOG92ZTcvZjVKN09GaHZiQnJ6WHdybnRCMjBobjZreTZrZFQ4RGg4?=
 =?utf-8?B?TnNmcUo5UzQ0NXRZVlNlVEtGYjc4dFY3MWxhOGFRWkFra2RpYTNaaVVLa3BM?=
 =?utf-8?B?OUJ3WUFGVzdPNlNpV3FWNG1laGl2UGdvL0ZpdFhDdlJrQkYvcXlsdnFoTnZs?=
 =?utf-8?B?MzFBZ1pjMm1Odm9SaWZhSTZKMEhxTTdZS0V1ZFpncFRnUkRDNnU5dTBNT1hQ?=
 =?utf-8?B?RmxWOEZld0xMaHZhTEpxZXFONDhMTG9ndWlPakNVWDJoK29NZDdxVDRlTWcy?=
 =?utf-8?B?aklodWZJWTA4K2lkWGVyc3M1RmZ3YUZmdWR3WElXclUzTkRtZE0rMWlXT1Ja?=
 =?utf-8?B?TldjZGpqTzlSYUtIcVpGa1JMbmpoTXdFOHlzaHVMeDY3aGYzY1VBdlhoazZZ?=
 =?utf-8?B?NjVyTzM2RXRjekpJZHVsUTkzMmRveCtQWWNLSW9vOUVYV0lkeHQyR3hvYWpw?=
 =?utf-8?B?YkFSWm9yL2IrVWNOVTgxUHBQbVZhTTJIU2RWZ2NLY2w0NFYzRHhMV083OGht?=
 =?utf-8?B?em9uU01vNU9iY091UGtEb1hja24yZExWZm4xd1YyR0lMSUZQbWdrRzk2aTMx?=
 =?utf-8?B?alJTZjJTNDlIUG01UnlXM0xManVaYi9FYitLOVpBaS9obC8zZ3MyTTN0QUlX?=
 =?utf-8?B?VjlQRUNScno5aWRTM1c3UWhwbmNSN3lBYm1XcS81M3AvbW54U0pSRUxWMHVl?=
 =?utf-8?B?Z2hGems2dTNzWGhVSXJVTG9VOU11dmVKd2MrcDF1alEzOGhmYmdoeFoyWHRP?=
 =?utf-8?B?WTJvY3NUMWg3VUdyNXdPRmNrc29ZR2pKbCtqYXI3OEl1cUJMT3JEaVRLTjRE?=
 =?utf-8?B?VUdXeGxvc2VGNHRoTnB1QjZkTld0NHNGdG5YUWpEYXBRV1RLNmptaHNrdFB1?=
 =?utf-8?B?eGo2V0xpR0lzR2Z1SjJtNGRJVEUvU3NlNk5oa0dwTHlxQ1ZSenNvMkF1bE9z?=
 =?utf-8?B?cE1lMkllSEgzKzRpRU1KdkVQaDNQbDVWeFU3aXhIYzJoVUdaektSWVBOM3I2?=
 =?utf-8?B?aGFleEtHTGIyZkw1UVBheEhiM0Y3UTJueWRwc1ZCWHhTeGQrdnVjSTdQd3Fs?=
 =?utf-8?B?NmkzazR5SXkvUVhYYnQ0UlYwVTNwVS9NM3AwY1dBNmxEeXc9PQ==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:zh-cn;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OSZPR01MB6453.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014)(38070700018)(1580799027);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?N3FWSzZ6MFhia2k0UWsrVFJCdXZmcisxeEVUWm5jaVVpbCtNR2x5Ly93WUxq?=
 =?utf-8?B?MjdTSm9pTlNJUGlJRWptdlk0ZWJLMndoL1JybVpSYnlIZEViS1g2VzFSamJw?=
 =?utf-8?B?YWlBMkhLMVNsb0JFM3VwOHBrcm55cGZaSzZhYnh3L2hYOGJCNVBMZWhsb3dm?=
 =?utf-8?B?NUF5NVJpQkV1K3NXUmdqeWpnNTJWanRUNWRtZkt5emFmMGhGTHJZNjVvSGFO?=
 =?utf-8?B?Q1VLdVY1RlBIVGtRa05PTFMydU5IaGhiRmN6Q28vaVNWbEVCR0hkOVJvTEx5?=
 =?utf-8?B?b05VclVMVVdLWjRsaXRLVS9iNW1vSXp2US80d0IxRktqNzBGUmdUam5GU0xi?=
 =?utf-8?B?TkZRVmdHUVhBb2szVEtRL0UwVmJNOWo5UDgzNGpxQlh2eFRZM2pIekRYWGNM?=
 =?utf-8?B?TzlGTVdsTVBRMXV2Z0NNOWdkSm9ueDFUNkg5OGNyVkkrQUNVaUJ2SFpkTHhG?=
 =?utf-8?B?OGZETUd0UlpoYkVrelVnUG5EUHVMRGhTRDJBQ2IzM09sNlF1ZlhBQ3k5RzZM?=
 =?utf-8?B?Y3Y3Qk1WMTBlLy9Yd1NCdGJ6R2ExSkpJR2pxblBKZUpXdE5YQjVVUmpCQXVZ?=
 =?utf-8?B?Ui91bGtjbXpoMGozT2RwYXpwM1dpRW52elFOLzY0akFZN3BJU1lmNmlUeGdU?=
 =?utf-8?B?dk5uQ1BSb0JMRVQzYkI2WUx1eUc0RnNWNXExZkkvcFAwN29nSmpoNTcyaWw3?=
 =?utf-8?B?Q0tRTVowVlN4dGROdVpVMHQzcDNKQ0tmOGZ0d08wUDBZWGNzUUVhaVpvM2Ux?=
 =?utf-8?B?ZzFCMnVGU00rS1FYb09xTjlFUVBvQ2F0SHF5NnZBY04ybnlIZGZ3bys4dUZJ?=
 =?utf-8?B?QVlGbXY0NkMyTkhJU01NZFR1RXlnSmQ4bytudU1qVzd1dEpOVkMzRkVjYTgy?=
 =?utf-8?B?Tlp5aHNpV1p2Nkx3Vk5WOTZxcVlzSXVVY2g3WTk5dWduR0FZblU1VlRpVjdK?=
 =?utf-8?B?Z2ZJaVRRVWw0Rm5JN2U0ZkVQUUs3bkxUeFByU2JWU0ZHbHZLL3lid0dla0lE?=
 =?utf-8?B?MEFLTVZWcmtwQUUrb1BvbVQ5TzZQSnUzSkN4bGxReTZtZVVxM0J3ZS8vNytY?=
 =?utf-8?B?Yk5wZFZuOHp0SDd6Nlh6L0l3aTVQNGphaGIzK0RHK1drUlBpSWovb21uOXZk?=
 =?utf-8?B?Z1VFdTU2NW5NQ0QvQmRiMVh6VU10K3pKZnZTQjVJZVoyYy9kMXFQUjdSbHpx?=
 =?utf-8?B?bG4xOUFLSDhvQlY5eENLT0dHYUQ5NnVXU1ZoZ2t1RWNJc1VONm1jWE5QTGtR?=
 =?utf-8?B?QWgrcjZFYjRZKzBhME1FVmMzVGNtbWlMZmRYT0hBVDJYc3dUK1hxVHVhUGxx?=
 =?utf-8?B?YkxGbWR2TXpSSGlIN2dFdEVOeVpXRkxaRmtOeHcvNG5QRGpDdkRxNHBZaUlZ?=
 =?utf-8?B?V09sWXNzSTBGZTFDYmZ4cC9xUDkzRnoxSWFaZVZqOU9kb05rNlpOM05CSDE2?=
 =?utf-8?B?L2xPRTR0dWNYb3ZBdGlXTU1HTUg5NCt3WGd0OEg0QUhYZXErRGlTaS9Xak5h?=
 =?utf-8?B?TUowZHJLTE0xTVRnNkhCaHpMMWo0enc3WHdLamppekxTd0xjSjUyczZaVDQx?=
 =?utf-8?B?YXk2Mjh0YnFvU1pZQUcvMnJqN2NyR0pkbTlTaU9WYWJDT3pwYndYODRaN0NY?=
 =?utf-8?B?ZE9CWWJzQVNHbkY1MklQcXU5KzJJYjdLTTVodHZKM1dlR2hiWjM4YUE5aXdL?=
 =?utf-8?B?N3UzaWRPZm5PRThxVzROTTNMZUE3b0RVb0FQbWZPcndxcVVXTFoxblUwbkR2?=
 =?utf-8?B?ayt6UndsTzlzTSthU3VvSEpZS2M3ZjRlbDZ1VFJYWktsOHZMaFJ5MFlpbFBp?=
 =?utf-8?B?aDVEcUkxNUlUU3RJclRsM00zYjdkVEZsdWp3a25LN0RRYjdPekU3ajVUazdK?=
 =?utf-8?B?Wi9VVUlNTWpaaWdjM3phRUk3bWJuNlhXU0o3M0ZjOWNxWFVOVVlsVEJWL0Fw?=
 =?utf-8?B?c1NEc0JURFVWTVczYUdETTE0cVVlQWl5SnU4N3hFVTZjaTdLaTFtc2VES2RN?=
 =?utf-8?B?aDBHSHVBVis2eTdvWlBnSVo0ZHQ3emFNV1llbVM5S0V1cDkybHdqMXFUWmR3?=
 =?utf-8?B?M3l6VThDYk8wZEhiU3Y4RzRKV0ErQlQzL3htWFErM3hqb2NGa0t5dWJiNVY0?=
 =?utf-8?Q?p/NEuVWmX0NjhsEEOhazLQuzj?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	v6nZmdNrggOi/QmiHbyeXiDNfs7fYKxstrD1KXmX1E5KzPrBVStIHA4KivanwN1RI4FqvMUsoDgkMAApKUV5jWLoWaF9LjY13xfUf41j0non+gdX352GUODxIIkFPIS4y/QLkMGv85ZY9a4aADGLN/pkPsZuE1lnoakit91ZcWkT1skgSdrbqLwdV8pycWTy0ESWxXXADJ99KRyv1fLk1CT55pbD6se9KKbPzfeoEqs8rhngRlzGP4PMTjalT7x/jhG39TaHfeYRV0UW/EzL8Pq76HibNCNME1pCks168f9rjiLG3s3jnbn8Uzur1fZJ6YC7ITm7Bjc1Gtz4AeJDYCOy5OxigxwTH6bPFkF780/recrQMG4VE5083lQFxQh6Z12q8gi/vKGsTb0CH/dUt9rlSpFP0i7sQVjiCb/xuAnalXZtbQrZNF5sjVlFTHRcTcI/dXdDnynS2T+Y/wz6vx5s/HL3ryQzMZmh8dQeLYLkQ75/sORaeFI/WcIh2XJ4OQrXcX/lL8F21/iIhpS50oaciBT3CXnHg9s6SX87xpxECZG9dg/Gia7Tqn61pR7bMTKIGjrC7wbgHspgoNQF+LXSdJiPluL+JKVf3eLCxUpIqREWRToecUc96ZQMjezc
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OSZPR01MB6453.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a72c9a87-9902-465e-c373-08dcd394946e
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Sep 2024 01:37:07.8302
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WWf0qFBNHKPV4SPrjCn34teNK/DUnmrhTbljE52madEKZ+ZFezYyHFsl8xEPlik3w56RRcK7KBUB4Ve2BO51+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYYPR01MB7069

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogcWVtdS1kZXZlbC1ib3Vu
Y2VzK3lhb3h0LmZuc3Q9ZnVqaXRzdS5jb21Abm9uZ251Lm9yZw0KPiA8cWVtdS1kZXZlbC1ib3Vu
Y2VzK3lhb3h0LmZuc3Q9ZnVqaXRzdS5jb21Abm9uZ251Lm9yZz4gT24gQmVoYWxmIE9mDQo+IFBp
ZXJyaWNrIEJvdXZpZXINCj4gU2VudDogVGh1cnNkYXksIFNlcHRlbWJlciAxMiwgMjAyNCAzOjM5
IFBNDQo+IFRvOiBxZW11LWRldmVsQG5vbmdudS5vcmcNCj4gQ2M6IEphc29uIFdhbmcgPGphc293
YW5nQHJlZGhhdC5jb20+OyBBbGV4IEJlbm7DqWUgPGFsZXguYmVubmVlQGxpbmFyby5vcmc+Ow0K
PiBMYXVyZW50IFZpdmllciA8bHZpdmllckByZWRoYXQuY29tPjsgTWFyY2VsbyBUb3NhdHRpIDxt
dG9zYXR0aUByZWRoYXQuY29tPjsNCj4gTmljaG9sYXMgUGlnZ2luIDxucGlnZ2luQGdtYWlsLmNv
bT47IEtsYXVzIEplbnNlbiA8aXRzQGlycmVsZXZhbnQuZGs+OyBXQU5HDQo+IFh1ZXJ1aSA8Z2l0
QHhlbjBuLm5hbWU+OyBIYWxpbCBQYXNpYyA8cGFzaWNAbGludXguaWJtLmNvbT47IFJvYiBIZXJy
aW5nDQo+IDxyb2JoQGtlcm5lbC5vcmc+OyBNaWNoYWVsIFJvbG5payA8bXJvbG5pa0BnbWFpbC5j
b20+OyBaaGFvIExpdQ0KPiA8emhhbzEubGl1QGludGVsLmNvbT47IFBldGVyIE1heWRlbGwgPHBl
dGVyLm1heWRlbGxAbGluYXJvLm9yZz47IFJpY2hhcmQNCj4gSGVuZGVyc29uIDxyaWNoYXJkLmhl
bmRlcnNvbkBsaW5hcm8ub3JnPjsgRmFiaWFubyBSb3NhcyA8ZmFyb3Nhc0BzdXNlLmRlPjsNCj4g
Q29yZXkgTWlueWFyZCA8bWlueWFyZEBhY20ub3JnPjsgS2VpdGggQnVzY2ggPGtidXNjaEBrZXJu
ZWwub3JnPjsgVGhvbWFzDQo+IEh1dGggPHRodXRoQHJlZGhhdC5jb20+OyBNYWNpZWogUy4gU3pt
aWdpZXJvIDxtYWNpZWouc3ptaWdpZXJvQG9yYWNsZS5jb20+Ow0KPiBIYXJzaCBQcmF0ZWVrIEJv
cmEgPGhhcnNocGJAbGludXguaWJtLmNvbT47IEtldmluIFdvbGYgPGt3b2xmQHJlZGhhdC5jb20+
Ow0KPiBQYW9sbyBCb256aW5pIDxwYm9uemluaUByZWRoYXQuY29tPjsgSmVzcGVyIERldmFudGll
ciA8Zm9zc0BkZWZtYWNyby5pdD47DQo+IEh5bWFuIEh1YW5nIDx5b25nLmh1YW5nQHNtYXJ0eC5j
b20+OyBQaGlsaXBwZSBNYXRoaWV1LURhdWTDqQ0KPiA8cGhpbG1kQGxpbmFyby5vcmc+OyBQYWxt
ZXIgRGFiYmVsdCA8cGFsbWVyQGRhYmJlbHQuY29tPjsNCj4gcWVtdS1zMzkweEBub25nbnUub3Jn
OyBMYXVyZW50IFZpdmllciA8bGF1cmVudEB2aXZpZXIuZXU+Ow0KPiBxZW11LXJpc2N2QG5vbmdu
dS5vcmc7IFJpY2hhcmQgVy5NLiBKb25lcyA8cmpvbmVzQHJlZGhhdC5jb20+OyBMaXUgWmhpd2Vp
DQo+IDx6aGl3ZWlfbGl1QGxpbnV4LmFsaWJhYmEuY29tPjsgQXVyZWxpZW4gSmFybm8gPGF1cmVs
aWVuQGF1cmVsMzIubmV0PjsgRGFuaWVsIFAuDQo+IEJlcnJhbmfDqSA8YmVycmFuZ2VAcmVkaGF0
LmNvbT47IE1hcmNlbCBBcGZlbGJhdW0NCj4gPG1hcmNlbC5hcGZlbGJhdW1AZ21haWwuY29tPjsg
a3ZtQHZnZXIua2VybmVsLm9yZzsgQ2hyaXN0aWFuIEJvcm50cmFlZ2VyDQo+IDxib3JudHJhZWdl
ckBsaW51eC5pYm0uY29tPjsgQWtpaGlrbyBPZGFraSA8YWtpaGlrby5vZGFraUBkYXluaXguY29t
PjsNCj4gRGFuaWVsIEhlbnJpcXVlIEJhcmJvemEgPGRiYXJib3phQHZlbnRhbmFtaWNyby5jb20+
OyBIYW5uYSBSZWl0eg0KPiA8aHJlaXR6QHJlZGhhdC5jb20+OyBBbmkgU2luaGEgPGFuaXNpbmhh
QHJlZGhhdC5jb20+Ow0KPiBxZW11LXBwY0Bub25nbnUub3JnOyBNYXJjLUFuZHLDqSBMdXJlYXUg
PG1hcmNhbmRyZS5sdXJlYXVAcmVkaGF0LmNvbT47DQo+IEFsaXN0YWlyIEZyYW5jaXMgPGFsaXN0
YWlyLmZyYW5jaXNAd2RjLmNvbT47IEJpbiBNZW5nIDxibWVuZy5jbkBnbWFpbC5jb20+Ow0KPiBN
aWNoYWVsIFMuIFRzaXJraW4gPG1zdEByZWRoYXQuY29tPjsgSGVsZ2UgRGVsbGVyIDxkZWxsZXJA
Z214LmRlPjsgUGV0ZXIgWHUNCj4gPHBldGVyeEByZWRoYXQuY29tPjsgRGFuaWVsIEhlbnJpcXVl
IEJhcmJvemEgPGRhbmllbGhiNDEzQGdtYWlsLmNvbT47DQo+IERtaXRyeSBGbGV5dG1hbiA8ZG1p
dHJ5LmZsZXl0bWFuQGdtYWlsLmNvbT47IE5pbmEgU2Nob2V0dGVybC1HbGF1c2NoDQo+IDxuc2dA
bGludXguaWJtLmNvbT47IFlhbmFuIFdhbmcgPHdhbmd5YW5hbjU1QGh1YXdlaS5jb20+Ow0KPiBx
ZW11LWFybUBub25nbnUub3JnOyBJZ29yIE1hbW1lZG92IDxpbWFtbWVkb0ByZWRoYXQuY29tPjsN
Cj4gSmVhbi1DaHJpc3RvcGhlIER1Ym9pcyA8amNkQHRyaWJ1ZHVib2lzLm5ldD47IEVyaWMgRmFy
bWFuDQo+IDxmYXJtYW5AbGludXguaWJtLmNvbT47IFNyaXJhbSBZYWduYXJhbWFuDQo+IDxzcmly
YW0ueWFnbmFyYW1hbkBlcmljc3Nvbi5jb20+OyBxZW11LWJsb2NrQG5vbmdudS5vcmc7IFN0ZWZh
biBCZXJnZXINCj4gPHN0ZWZhbmJAbGludXgudm5ldC5pYm0uY29tPjsgSm9lbCBTdGFubGV5IDxq
b2VsQGptcy5pZC5hdT47IEVkdWFyZG8gSGFia29zdA0KPiA8ZWR1YXJkb0BoYWJrb3N0Lm5ldD47
IERhdmlkIEdpYnNvbiA8ZGF2aWRAZ2lic29uLmRyb3BiZWFyLmlkLmF1PjsgRmFtDQo+IFpoZW5n
IDxmYW1AZXVwaG9uLm5ldD47IFdlaXdlaSBMaSA8bGl3ZWkxNTE4QGdtYWlsLmNvbT47IE1hcmt1
cw0KPiBBcm1icnVzdGVyIDxhcm1icnVAcmVkaGF0LmNvbT47IFBpZXJyaWNrIEJvdXZpZXIgPHBp
ZXJyaWNrLmJvdXZpZXJAbGluYXJvLm9yZz4NCj4gU3ViamVjdDogW1BBVENIIHYyIDAwLzQ4XSBV
c2UgZ19hc3NlcnRfbm90X3JlYWNoZWQgaW5zdGVhZCBvZiAoZ18pYXNzZXJ0KDAsDQo+IGZhbHNl
KQ0KPiANCj4gVGhpcyBzZXJpZXMgY2xlYW5zIHVwIGFsbCB1c2FnZXMgb2YgYXNzZXJ0L2dfYXNz
ZXJ0IHdobyBhcmUgc3VwcG9zZWQgdG8gc3RvcA0KPiBleGVjdXRpb24gb2YgUUVNVS4gV2UgcmVw
bGFjZSB0aG9zZSBieSBnX2Fzc2VydF9ub3RfcmVhY2hlZCgpLg0KPiBJdCB3YXMgc3VnZ2VzdGVk
IHJlY2VudGx5IHdoZW4gY2xlYW5pbmcgY29kZWJhc2UgdG8gYnVpbGQgUUVNVSB3aXRoIGdjYw0K
PiBhbmQgdHNhbjoNCj4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvcWVtdS1kZXZlbC81NGJiMDJh
Ni0xYjEyLTQ2MGEtOTdmNi0zZjQ3OGVmNzY2YzZAbGluDQo+IGFyby5vcmcvLg0KPiANCj4gSW4g
bW9yZSwgY2xlYW51cCB1c2VsZXNzIGJyZWFrIGFuZCByZXR1cm4gYWZ0ZXIgZ19hc3NlcnRfbm90
X3JlYWNoZWQoKTsNCkkgZm91bmQgdGhhdCBub3QgYWxsIG9mIHRoZSBicmVhayBvciByZXR1cm4g
YWZ0ZXIgZ19hc3NlcnRfbm90X3JlYWNoZWQoKSB3ZXJlIGNsZWFuZWQgdXAsIGRvbid0IHRoZXkg
bmVlZCB0byBiZSBjbGVhbmVkIHVwPw0KPiANCj4gQW5kIGZpbmFsbHksIGVuc3VyZSB3aXRoIHNj
cmlwdHMvY2hlY2twYXRjaC5wbCB0aGF0IHdlIGRvbid0IHJlaW50cm9kdWNlDQo+IChnXylhc3Nl
cnQoZmFsc2UpIGluIHRoZSBmdXR1cmUuDQo+IA0KPiBOZXcgY29tbWl0cyAocmVtb3ZpbmcgcmV0
dXJuKSBuZWVkIHJldmlldy4NCj4gDQo+IFRlc3RlZCB0aGF0IGl0IGJ1aWxkIHdhcm5pbmcgZnJl
ZSB3aXRoIGdjYyBhbmQgY2xhbmcuDQo+IA0KPiB2Mg0KPiAtIGFsaWduIGJhY2tzbGFzaGVzIGZv
ciBzb21lIGNoYW5nZXMNCj4gLSBhZGQgc3VtbWFyeSBpbiBhbGwgY29tbWl0cyBtZXNzYWdlDQo+
IC0gcmVtb3ZlIHJlZHVuZGFudCBjb21tZW50DQo+IA0KPiB2MQ0KPiBodHRwczovL2xvcmUua2Vy
bmVsLm9yZy9xZW11LWRldmVsLzIwMjQwOTEwMjIxNjA2LjE4MTc0NzgtMS1waWVycmljay5ib3V2
aWVyQA0KPiBsaW5hcm8ub3JnL1QvI3QNCj4gDQo+IFBpZXJyaWNrIEJvdXZpZXIgKDQ4KToNCj4g
ICBkb2NzL3NwaW46IHJlcGxhY2UgYXNzZXJ0KDApIHdpdGggZ19hc3NlcnRfbm90X3JlYWNoZWQo
KQ0KPiAgIGh3L2FjcGk6IHJlcGxhY2UgYXNzZXJ0KDApIHdpdGggZ19hc3NlcnRfbm90X3JlYWNo
ZWQoKQ0KPiAgIGh3L2FybTogcmVwbGFjZSBhc3NlcnQoMCkgd2l0aCBnX2Fzc2VydF9ub3RfcmVh
Y2hlZCgpDQo+ICAgaHcvY2hhcjogcmVwbGFjZSBhc3NlcnQoMCkgd2l0aCBnX2Fzc2VydF9ub3Rf
cmVhY2hlZCgpDQo+ICAgaHcvY29yZTogcmVwbGFjZSBhc3NlcnQoMCkgd2l0aCBnX2Fzc2VydF9u
b3RfcmVhY2hlZCgpDQo+ICAgaHcvbmV0OiByZXBsYWNlIGFzc2VydCgwKSB3aXRoIGdfYXNzZXJ0
X25vdF9yZWFjaGVkKCkNCj4gICBody93YXRjaGRvZzogcmVwbGFjZSBhc3NlcnQoMCkgd2l0aCBn
X2Fzc2VydF9ub3RfcmVhY2hlZCgpDQo+ICAgbWlncmF0aW9uOiByZXBsYWNlIGFzc2VydCgwKSB3
aXRoIGdfYXNzZXJ0X25vdF9yZWFjaGVkKCkNCj4gICBxb2JqZWN0OiByZXBsYWNlIGFzc2VydCgw
KSB3aXRoIGdfYXNzZXJ0X25vdF9yZWFjaGVkKCkNCj4gICBzeXN0ZW06IHJlcGxhY2UgYXNzZXJ0
KDApIHdpdGggZ19hc3NlcnRfbm90X3JlYWNoZWQoKQ0KPiAgIHRhcmdldC9wcGM6IHJlcGxhY2Ug
YXNzZXJ0KDApIHdpdGggZ19hc3NlcnRfbm90X3JlYWNoZWQoKQ0KPiAgIHRlc3RzL3F0ZXN0OiBy
ZXBsYWNlIGFzc2VydCgwKSB3aXRoIGdfYXNzZXJ0X25vdF9yZWFjaGVkKCkNCj4gICB0ZXN0cy91
bml0OiByZXBsYWNlIGFzc2VydCgwKSB3aXRoIGdfYXNzZXJ0X25vdF9yZWFjaGVkKCkNCj4gICBp
bmNsdWRlL2h3L3MzOTB4OiByZXBsYWNlIGFzc2VydChmYWxzZSkgd2l0aCBnX2Fzc2VydF9ub3Rf
cmVhY2hlZCgpDQo+ICAgYmxvY2s6IHJlcGxhY2UgYXNzZXJ0KGZhbHNlKSB3aXRoIGdfYXNzZXJ0
X25vdF9yZWFjaGVkKCkNCj4gICBody9oeXBlcnY6IHJlcGxhY2UgYXNzZXJ0KGZhbHNlKSB3aXRo
IGdfYXNzZXJ0X25vdF9yZWFjaGVkKCkNCj4gICBody9uZXQ6IHJlcGxhY2UgYXNzZXJ0KGZhbHNl
KSB3aXRoIGdfYXNzZXJ0X25vdF9yZWFjaGVkKCkNCj4gICBody9udm1lOiByZXBsYWNlIGFzc2Vy
dChmYWxzZSkgd2l0aCBnX2Fzc2VydF9ub3RfcmVhY2hlZCgpDQo+ICAgaHcvcGNpOiByZXBsYWNl
IGFzc2VydChmYWxzZSkgd2l0aCBnX2Fzc2VydF9ub3RfcmVhY2hlZCgpDQo+ICAgaHcvcHBjOiBy
ZXBsYWNlIGFzc2VydChmYWxzZSkgd2l0aCBnX2Fzc2VydF9ub3RfcmVhY2hlZCgpDQo+ICAgbWln
cmF0aW9uOiByZXBsYWNlIGFzc2VydChmYWxzZSkgd2l0aCBnX2Fzc2VydF9ub3RfcmVhY2hlZCgp
DQo+ICAgdGFyZ2V0L2kzODYva3ZtOiByZXBsYWNlIGFzc2VydChmYWxzZSkgd2l0aCBnX2Fzc2Vy
dF9ub3RfcmVhY2hlZCgpDQo+ICAgdGVzdHMvcXRlc3Q6IHJlcGxhY2UgYXNzZXJ0KGZhbHNlKSB3
aXRoIGdfYXNzZXJ0X25vdF9yZWFjaGVkKCkNCj4gICBhY2NlbC90Y2c6IHJlbW92ZSBicmVhayBh
ZnRlciBnX2Fzc2VydF9ub3RfcmVhY2hlZCgpDQo+ICAgYmxvY2s6IHJlbW92ZSBicmVhayBhZnRl
ciBnX2Fzc2VydF9ub3RfcmVhY2hlZCgpDQo+ICAgaHcvYWNwaTogcmVtb3ZlIGJyZWFrIGFmdGVy
IGdfYXNzZXJ0X25vdF9yZWFjaGVkKCkNCj4gICBody9ncGlvOiByZW1vdmUgYnJlYWsgYWZ0ZXIg
Z19hc3NlcnRfbm90X3JlYWNoZWQoKQ0KPiAgIGh3L21pc2M6IHJlbW92ZSBicmVhayBhZnRlciBn
X2Fzc2VydF9ub3RfcmVhY2hlZCgpDQo+ICAgaHcvbmV0OiByZW1vdmUgYnJlYWsgYWZ0ZXIgZ19h
c3NlcnRfbm90X3JlYWNoZWQoKQ0KPiAgIGh3L3BjaS1ob3N0OiByZW1vdmUgYnJlYWsgYWZ0ZXIg
Z19hc3NlcnRfbm90X3JlYWNoZWQoKQ0KPiAgIGh3L3Njc2k6IHJlbW92ZSBicmVhayBhZnRlciBn
X2Fzc2VydF9ub3RfcmVhY2hlZCgpDQo+ICAgaHcvdHBtOiByZW1vdmUgYnJlYWsgYWZ0ZXIgZ19h
c3NlcnRfbm90X3JlYWNoZWQoKQ0KPiAgIHRhcmdldC9hcm06IHJlbW92ZSBicmVhayBhZnRlciBn
X2Fzc2VydF9ub3RfcmVhY2hlZCgpDQo+ICAgdGFyZ2V0L3Jpc2N2OiByZW1vdmUgYnJlYWsgYWZ0
ZXIgZ19hc3NlcnRfbm90X3JlYWNoZWQoKQ0KPiAgIHRlc3RzL3F0ZXN0OiByZW1vdmUgYnJlYWsg
YWZ0ZXIgZ19hc3NlcnRfbm90X3JlYWNoZWQoKQ0KPiAgIHVpOiByZW1vdmUgYnJlYWsgYWZ0ZXIg
Z19hc3NlcnRfbm90X3JlYWNoZWQoKQ0KPiAgIGZwdTogcmVtb3ZlIGJyZWFrIGFmdGVyIGdfYXNz
ZXJ0X25vdF9yZWFjaGVkKCkNCj4gICB0Y2cvbG9vbmdhcmNoNjQ6IHJlbW92ZSBicmVhayBhZnRl
ciBnX2Fzc2VydF9ub3RfcmVhY2hlZCgpDQo+ICAgaW5jbHVkZS9xZW11OiByZW1vdmUgcmV0dXJu
IGFmdGVyIGdfYXNzZXJ0X25vdF9yZWFjaGVkKCkNCj4gICBody9oeXBlcnY6IHJlbW92ZSByZXR1
cm4gYWZ0ZXIgZ19hc3NlcnRfbm90X3JlYWNoZWQoKQ0KPiAgIGh3L25ldDogcmVtb3ZlIHJldHVy
biBhZnRlciBnX2Fzc2VydF9ub3RfcmVhY2hlZCgpDQo+ICAgaHcvcGNpOiByZW1vdmUgcmV0dXJu
IGFmdGVyIGdfYXNzZXJ0X25vdF9yZWFjaGVkKCkNCj4gICBody9wcGM6IHJlbW92ZSByZXR1cm4g
YWZ0ZXIgZ19hc3NlcnRfbm90X3JlYWNoZWQoKQ0KPiAgIG1pZ3JhdGlvbjogcmVtb3ZlIHJldHVy
biBhZnRlciBnX2Fzc2VydF9ub3RfcmVhY2hlZCgpDQo+ICAgcW9iamVjdDogcmVtb3ZlIHJldHVy
biBhZnRlciBnX2Fzc2VydF9ub3RfcmVhY2hlZCgpDQo+ICAgcW9tOiByZW1vdmUgcmV0dXJuIGFm
dGVyIGdfYXNzZXJ0X25vdF9yZWFjaGVkKCkNCj4gICB0ZXN0cy9xdGVzdDogcmVtb3ZlIHJldHVy
biBhZnRlciBnX2Fzc2VydF9ub3RfcmVhY2hlZCgpDQo+ICAgc2NyaXB0cy9jaGVja3BhdGNoLnBs
OiBlbWl0IGVycm9yIHdoZW4gdXNpbmcgYXNzZXJ0KGZhbHNlKQ0KPiANCj4gIGRvY3Mvc3Bpbi9h
aW9fbm90aWZ5X2FjY2VwdC5wcm9tZWxhICAgICB8ICA2ICsrKy0tLQ0KPiAgZG9jcy9zcGluL2Fp
b19ub3RpZnlfYnVnLnByb21lbGEgICAgICAgIHwgIDYgKysrLS0tDQo+ICBpbmNsdWRlL2h3L3Mz
OTB4L2NwdS10b3BvbG9neS5oICAgICAgICAgfCAgMiArLQ0KPiAgaW5jbHVkZS9xZW11L3BtZW0u
aCAgICAgICAgICAgICAgICAgICAgIHwgIDEgLQ0KPiAgYWNjZWwvdGNnL3BsdWdpbi1nZW4uYyAg
ICAgICAgICAgICAgICAgIHwgIDEgLQ0KPiAgYmxvY2svcWNvdzIuYyAgICAgICAgICAgICAgICAg
ICAgICAgICAgIHwgIDIgKy0NCj4gIGJsb2NrL3NzaC5jICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICB8ICAxIC0NCj4gIGh3L2FjcGkvYW1sLWJ1aWxkLmMgICAgICAgICAgICAgICAgICAgICB8
ICAzICstLQ0KPiAgaHcvYXJtL2hpZ2hiYW5rLmMgICAgICAgICAgICAgICAgICAgICAgIHwgIDIg
Ky0NCj4gIGh3L2NoYXIvYXZyX3VzYXJ0LmMgICAgICAgICAgICAgICAgICAgICB8ICAyICstDQo+
ICBody9jb3JlL251bWEuYyAgICAgICAgICAgICAgICAgICAgICAgICAgfCAgMiArLQ0KPiAgaHcv
Z3Bpby9ucmY1MV9ncGlvLmMgICAgICAgICAgICAgICAgICAgIHwgIDEgLQ0KPiAgaHcvaHlwZXJ2
L2h5cGVydl90ZXN0ZGV2LmMgICAgICAgICAgICAgIHwgIDcgKysrLS0tLQ0KPiAgaHcvaHlwZXJ2
L3ZtYnVzLmMgICAgICAgICAgICAgICAgICAgICAgIHwgMTUgKysrKysrLS0tLS0tLS0tDQo+ICBo
dy9taXNjL2lteDZfY2NtLmMgICAgICAgICAgICAgICAgICAgICAgfCAgMSAtDQo+ICBody9taXNj
L21hY192aWEuYyAgICAgICAgICAgICAgICAgICAgICAgfCAgMiAtLQ0KPiAgaHcvbmV0L2UxMDAw
ZV9jb3JlLmMgICAgICAgICAgICAgICAgICAgIHwgIDQgKy0tLQ0KPiAgaHcvbmV0L2k4MjU5Ni5j
ICAgICAgICAgICAgICAgICAgICAgICAgIHwgIDIgKy0NCj4gIGh3L25ldC9pZ2JfY29yZS5jICAg
ICAgICAgICAgICAgICAgICAgICB8ICA0ICstLS0NCj4gIGh3L25ldC9uZXRfcnhfcGt0LmMgICAg
ICAgICAgICAgICAgICAgICB8ICAzICstLQ0KPiAgaHcvbmV0L3ZteG5ldDMuYyAgICAgICAgICAg
ICAgICAgICAgICAgIHwgIDEgLQ0KPiAgaHcvbnZtZS9jdHJsLmMgICAgICAgICAgICAgICAgICAg
ICAgICAgIHwgIDggKysrKy0tLS0NCj4gIGh3L3BjaS1ob3N0L2d0NjQxMjAuYyAgICAgICAgICAg
ICAgICAgICB8ICAyIC0tDQo+ICBody9wY2kvcGNpLXN0dWIuYyAgICAgICAgICAgICAgICAgICAg
ICAgfCAgNiArKy0tLS0NCj4gIGh3L3BwYy9wcGMuYyAgICAgICAgICAgICAgICAgICAgICAgICAg
ICB8ICAxIC0NCj4gIGh3L3BwYy9zcGFwcl9ldmVudHMuYyAgICAgICAgICAgICAgICAgICB8ICAz
ICstLQ0KPiAgaHcvc2NzaS92aXJ0aW8tc2NzaS5jICAgICAgICAgICAgICAgICAgIHwgIDEgLQ0K
PiAgaHcvdHBtL3RwbV9zcGFwci5jICAgICAgICAgICAgICAgICAgICAgIHwgIDEgLQ0KPiAgaHcv
d2F0Y2hkb2cvd2F0Y2hkb2cuYyAgICAgICAgICAgICAgICAgIHwgIDIgKy0NCj4gIG1pZ3JhdGlv
bi9kaXJ0eXJhdGUuYyAgICAgICAgICAgICAgICAgICB8ICAzICstLQ0KPiAgbWlncmF0aW9uL21p
Z3JhdGlvbi1obXAtY21kcy5jICAgICAgICAgIHwgIDIgKy0NCj4gIG1pZ3JhdGlvbi9wb3N0Y29w
eS1yYW0uYyAgICAgICAgICAgICAgICB8IDIxICsrKysrKystLS0tLS0tLS0tLS0tLQ0KPiAgbWln
cmF0aW9uL3JhbS5jICAgICAgICAgICAgICAgICAgICAgICAgIHwgIDggKysrLS0tLS0NCj4gIHFv
YmplY3QvcWxpdC5jICAgICAgICAgICAgICAgICAgICAgICAgICB8ICAyICstDQo+ICBxb2JqZWN0
L3FudW0uYyAgICAgICAgICAgICAgICAgICAgICAgICAgfCAxMiArKysrLS0tLS0tLS0NCj4gIHFv
bS9vYmplY3QuYyAgICAgICAgICAgICAgICAgICAgICAgICAgICB8ICAxIC0NCj4gIHN5c3RlbS9y
dGMuYyAgICAgICAgICAgICAgICAgICAgICAgICAgICB8ICAyICstDQo+ICB0YXJnZXQvYXJtL2h5
cF9nZGJzdHViLmMgICAgICAgICAgICAgICAgfCAgMSAtDQo+ICB0YXJnZXQvaTM4Ni9rdm0va3Zt
LmMgICAgICAgICAgICAgICAgICAgfCAgNCArKy0tDQo+ICB0YXJnZXQvcHBjL2RmcF9oZWxwZXIu
YyAgICAgICAgICAgICAgICAgfCAgOCArKysrLS0tLQ0KPiAgdGFyZ2V0L3BwYy9tbXVfaGVscGVy
LmMgICAgICAgICAgICAgICAgIHwgIDIgKy0NCj4gIHRhcmdldC9yaXNjdi9tb25pdG9yLmMgICAg
ICAgICAgICAgICAgICB8ICAxIC0NCj4gIHRlc3RzL3F0ZXN0L2FjcGktdXRpbHMuYyAgICAgICAg
ICAgICAgICB8ICAxIC0NCj4gIHRlc3RzL3F0ZXN0L2lwbWktYnQtdGVzdC5jICAgICAgICAgICAg
ICB8ICAyICstDQo+ICB0ZXN0cy9xdGVzdC9pcG1pLWtjcy10ZXN0LmMgICAgICAgICAgICAgfCAg
NCArKy0tDQo+ICB0ZXN0cy9xdGVzdC9taWdyYXRpb24taGVscGVycy5jICAgICAgICAgfCAgMSAt
DQo+ICB0ZXN0cy9xdGVzdC9udW1hLXRlc3QuYyAgICAgICAgICAgICAgICAgfCAxMCArKysrKy0t
LS0tDQo+ICB0ZXN0cy9xdGVzdC9ydGw4MTM5LXRlc3QuYyAgICAgICAgICAgICAgfCAgMiArLQ0K
PiAgdGVzdHMvdW5pdC90ZXN0LXhzLW5vZGUuYyAgICAgICAgICAgICAgIHwgIDQgKystLQ0KPiAg
dWkvcWVtdS1waXhtYW4uYyAgICAgICAgICAgICAgICAgICAgICAgIHwgIDEgLQ0KPiAgZnB1L3Nv
ZnRmbG9hdC1wYXJ0cy5jLmluYyAgICAgICAgICAgICAgIHwgIDIgLS0NCj4gIHRhcmdldC9yaXNj
di9pbnNuX3RyYW5zL3RyYW5zX3J2di5jLmluYyB8ICAyIC0tDQo+ICB0Y2cvbG9vbmdhcmNoNjQv
dGNnLXRhcmdldC5jLmluYyAgICAgICAgfCAgMSAtDQo+ICBzY3JpcHRzL2NoZWNrcGF0Y2gucGwg
ICAgICAgICAgICAgICAgICAgfCAgMyArKysNCj4gIDU0IGZpbGVzIGNoYW5nZWQsIDcyIGluc2Vy
dGlvbnMoKyksIDEyMCBkZWxldGlvbnMoLSkNCj4gDQo+IC0tDQo+IDIuMzkuMg0KPiANCg0K

