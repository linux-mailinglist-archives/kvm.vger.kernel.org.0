Return-Path: <kvm+bounces-46184-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A987FAB3BDF
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 17:22:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 894783AE9B7
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 15:21:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92B0A23BF96;
	Mon, 12 May 2025 15:21:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="WTtQwOV1";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="xUNwlE0q"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9966229B0B;
	Mon, 12 May 2025 15:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747063307; cv=fail; b=Q0pV5fp42aqyWrawtZrW2CWgNblc0n/ZBUfzopqa+S/7XVRWawz7FKqbn237Wfe8/tM74etrWihlZaQdSWfcFluw+yrnUEMCkolz2+FlyDQbFTfVQWw/YIe46SRkEfJkTV/EvWFJ0KtitWhqUq42n2+tW+DSjUPXRNthr7dNGGg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747063307; c=relaxed/simple;
	bh=8+1+5e8ZWuy8xbnakr/pj2+94nN1jmJeiym2tfaRtr8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=qtIO5Dpwldt5LmBwSCNkpNOk9OFi3Z3/0vAAn4tqp2EDZ4k8oL/cyqeWRYzAlCK5LdmY5OyKjT2vvuXNbBycWr0emGUvIN5xetHIReEehGsYk4oHwE3LmCNxQiyTIn/HO8FeF3TIGqZ44fQac0w2pt2KSi+rSH6UpdByUWI0khA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=WTtQwOV1; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=xUNwlE0q; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127839.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54CBUNVJ002705;
	Mon, 12 May 2025 08:21:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=8+1+5e8ZWuy8xbnakr/pj2+94nN1jmJeiym2tfaRt
	r8=; b=WTtQwOV1LdmzVv/vq5OmQ89U4HZuZESLu4YQWXb9wRkYmfu3PzQMqSIoq
	ul0x/Fb/Ei3XpGWSHREqunNSsWxOXkUL3l84QP+vCfqCPjNxu/H1aXoM7zqf7Znt
	0rUzvL9o1b6XS/4OJpFdxrOnZ1V/cCdjeDR5EuKyyWf+P/pkb8C8eOjVI3O8JFBt
	3NTUZkfbaN4v4zxJ3fU9LrXJ6z6HiMjKxGijHyJKh1X8TWEjgVyuhpP+saypWMXM
	aAWpjFr4SUSFjiP9rfyPe47PVSqeO8e9WqUppl82/xDb5rEjxvPwFRKOT3EuBVvm
	M+JDHeCrDXt79ezIA7Z+G81ymDrRg==
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2045.outbound.protection.outlook.com [104.47.73.45])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 46j5vkbcu6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 12 May 2025 08:21:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ksvJF1Um8z17DTpviDM77JxOAB3iFI4nogSD6XwEeU62ws/gvH/EaLmudE7dGmqN5l2cpQu/Hgfvg4vOqjLBUSqOw6xyjA2hlqBlpdMznczr+lCDbs6BU89u+SDcrF1XQet0D8LB1c48Z6WgRBnNQDLix94evXSWJGIJcZFle4mMMcSpOmszRPxQDF5JzUTLWn657ZqS8x1/bjdVXcK3kj4Vw8lfVvsPbiAY6XuHFOGEWJVkVIzrICck1Ofk4oGJxNwdJFkvQSlXt+dXUzfzQrya04ZJ141Q0K0S7IkhTA5wStEQSezgn47vR4T9zZV7Nzl4wcrXFbJt85ap7IRcxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8+1+5e8ZWuy8xbnakr/pj2+94nN1jmJeiym2tfaRtr8=;
 b=WWgpgR8iI6AGdXoQ+XaxhbjiE4tRWSwwcA31yx6KoXWfyOj0E/iUqP+GwzFI6Hwu1hF8u4n46QGv2OiiPBv3doMByrTKGEfEgVabUfiNJmXZTL3ep/GUhNv7sNsC8h3n17G4MpwmGOsqCCpTlY6hMFYGFLKIYGL7iBSvJz5DCrW88NfOKEPS7bqYGBFrSO5Yrsxz1w39SzfrJOFyejgxZnbSq6K8BMQ1r3Po+1/oFbdIs6PKqlRX3Oucxs+Bg0sXpE6Xovua7E3QDVmJI+fbRVDMSmrh4izg11N2u/mejW4HU5B/3oXNOm2jd9otVYSu0W0RPn7T3HG8CtyQCX+/lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8+1+5e8ZWuy8xbnakr/pj2+94nN1jmJeiym2tfaRtr8=;
 b=xUNwlE0qtEAmD9pmvEgU7PAjgfaaWSZxWZf4+OQwNbr40HtnXrJTG79OHKBFfwi59FLiQIDlu1kl/5ir7m5U7lPLeBN3KDzQ6R1BGr0t8ijiKVFVGmA7DTeB+K31BOMI/Nb6eOpKixZjvC8BA7AyHOp6wfFkgXRzodMD3xULu9bL+eKiM8Jrt6DGpTQxrIY/Wq90AWoCoucKEOOClpEo9hNgApdvoP1MEysXE9Jk5QN3TUb9M1gtqujoR76RxiRIQBi8szisch1uPo/vS6Vh2sIOdRYkfaRr9o0+tqQvriCeWG03ZK1tTEfBbcpHCrc9AWATPUKptccEd0WWWjZl7g==
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10) by BL3PR02MB8113.namprd02.prod.outlook.com
 (2603:10b6:208:35c::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.28; Mon, 12 May
 2025 15:21:29 +0000
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054]) by LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054%5]) with mapi id 15.20.8722.027; Mon, 12 May 2025
 15:21:29 +0000
From: Jon Kohler <jon@nutanix.com>
To: Eugenio Perez Martin <eperezma@redhat.com>
CC: Jason Wang <jasowang@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux.dev"
	<virtualization@lists.linux.dev>,
        "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>,
        Stefano Brivio <sbrivio@redhat.com>
Subject: Re: [PATCH] vhost/net: remove zerocopy support
Thread-Topic: [PATCH] vhost/net: remove zerocopy support
Thread-Index:
 AQHbpW031K1yxtchPk+rB14ra05W57OXetWAgAGCcACAAFaRAIAM0lgAgBb9pwCAEjRUAA==
Date: Mon, 12 May 2025 15:21:29 +0000
Message-ID: <A2A66437-60B2-491E-96F7-CD302E90452F@nutanix.com>
References: <20250404145241.1125078-1-jon@nutanix.com>
 <CACGkMEsFc-URhXBCGZ1=CTMZKcWPf57pYy1TcyKLL=N65u+F0Q@mail.gmail.com>
 <B32E2C5D-25FB-427F-8567-701C152DFDE6@nutanix.com>
 <CACGkMEucg5mduA-xoyrTRK5nOkdHvUAkG9fH6KpO=HxMVPYONA@mail.gmail.com>
 <CAJaqyWdhLCNs_B0gcxXHut7xufw23HMR6PaO11mqAQFoGkdfXQ@mail.gmail.com>
 <92470838-2B98-4FC6-8E5B-A8AF14965D4C@nutanix.com>
In-Reply-To: <92470838-2B98-4FC6-8E5B-A8AF14965D4C@nutanix.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3826.400.131.1.6)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV8PR02MB10287:EE_|BL3PR02MB8113:EE_
x-ms-office365-filtering-correlation-id: b4217ffc-1d7a-4d32-0f90-08dd9168ab30
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|10070799003|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?QUZBTmpuT3duMFJiamhlbFNjWEY4amRrM3lpQURWS05SZGxEUFEzR0QzM2Iy?=
 =?utf-8?B?Q29GQ1Y4cGtiTWpEcUpUODJxRDh2ZnEwSXAzZWlQYWVBd1RZc2xLNFdTYUxq?=
 =?utf-8?B?YVFSNG9qNUl1bU9sYVhXQ2pkZi9kcHdkVlVLMzRmTncwM0lSMnJxbDI3MitM?=
 =?utf-8?B?c3laVVJtQ1hQN2FFSE96aFFOV25PSXFQVXhlWlJIbE5oZUltNElUZmxiaUVD?=
 =?utf-8?B?KzE0WTRFbitENXVwOHYrWFB6RlRnQW5LdXJON0NDN0NpTmY1Y0dudU9mcXZY?=
 =?utf-8?B?S0hPb2NWaTBMS3NYZ0xJb2lqcitESWZYVEdLdThFdW1wbUpjN0RsTUx2a21U?=
 =?utf-8?B?ZXpOU3VpdEEyUUR6WFRJb2cxUWg3TjVFN2J1QU9xaTdwbEZyUERRamVPemFU?=
 =?utf-8?B?RHkxMk52cy8vV2VGTXdGcHB3QXg1VGx3UCtkeGZXUHFrZDlzdDh5eWt0bVhC?=
 =?utf-8?B?RFlNdTBMdGk0RGdQWmdoQWkrNmJpY2VPZDI2cnJFY05tQlExUS84a3N5ZXNk?=
 =?utf-8?B?eHZrTzJXUncwVGtBTTVBd1pkeHZmUW9EbnV3YWU5VEJvc2labWUzSSs5WmZp?=
 =?utf-8?B?QktKZm1JanlLZlAyUHVqb1QzS01VeGkyMUJVWFdrYTZxSkpFWmFkVURtcHRj?=
 =?utf-8?B?RnNOME1GM2cvVUgwSXBQSlNnWXBnRVl2anNPd0d3ZEt1aTNuOHl1Q2IxOExs?=
 =?utf-8?B?bzJDR3NTM3ZWbGhsekNCdHhVMDJUZXRpb29QRDFlUTFRWmgvTzRpL0s0Uk5t?=
 =?utf-8?B?UzJUS2luZDdrMURlQzY5NmRkNVEwYWFiaVlyS0RYRzNaeGZWbXRMZ0NDamdi?=
 =?utf-8?B?S25XNVJscWk1VmNVd2NFdFdsS3RqK004TnJMMERiUTVldmhPZ2x2NksrVXIz?=
 =?utf-8?B?bmVaS1p4S1RGRDgzZ2lxTittcmtselBCUEdjMVpSRnlXK2FScHpzSWN5eFBh?=
 =?utf-8?B?c1c1TEpDMSs3N0F3dVkxVFJXSXJkY3V5U1JzNC9lREVQellKa2NPc3E3cSsz?=
 =?utf-8?B?dnN1RjM0R1ZNMTdwbGxUb0JCSmRGZmNTUVladWd4cCthV3pQTDVYamFLU3Rr?=
 =?utf-8?B?VjN6cSt3STgyV1FuL2c2anFISCt2ZUpuTDc2OW5mVDRjV2xlMVdNb3ZsdHlv?=
 =?utf-8?B?S2VhbkROR3dOTU5lbkMvQ2tKZUVPS1pUU2ZTTlR6NG8xejg1d1J4TVJzQ09H?=
 =?utf-8?B?cXlPdStzTnJkVUhOYUtEcjdFRUdWNjRKQ1JsSUpUUkpZVXlQUStkNXQyem5U?=
 =?utf-8?B?eGZBOUc0RCtveG9jNkR0ZlB6clMzUHU0aDl6UTBWU0ZFSUpubjBwS01BWnNv?=
 =?utf-8?B?bzZLYzNlNGMrNHFnMnRvUkdEeWhmZnJweXBTcnE5NUF2NFRtT2owc3daeXl2?=
 =?utf-8?B?MUtoNFk3NThqRUJ2MmtBMHVhcU9qR3R4YmdlMVRPN09HcS9MSDUzWkNRVnkr?=
 =?utf-8?B?U3BnNFIySjRGaEZiakhJUmZ0bGl2azNzSWNPSmtnZmFsSzJFT1p1L3BUeldF?=
 =?utf-8?B?Ty9RdG1EeUxESTY5L0lEdHRFQnVQS212WSs5QXhsKzV0R3NIc0VBSjBrK0l4?=
 =?utf-8?B?R0FvSWNFQUxxb0FPSndRNTdjd0szZDhWNnNYVEc3emgzQUJOVE1xWE1sWlRq?=
 =?utf-8?B?UHRvaEpoR2dOcExQTHB2UVQvcTdtK1F5aXoybkZSTm5mbXlyeWc0V2IyOVNy?=
 =?utf-8?B?WkhYVTUvc0I2aENDQlVicTRBYk03Tm52VnU1a0NFUlFFZ1ZMUC96Tm9ZazRs?=
 =?utf-8?B?clpNZ3B3U1ZsSGV0eXJjOVVHUUZhNndhVk4vUEFuWWg0OVFJaE9sdlAvZ0Rt?=
 =?utf-8?B?aWlBbXVqT1NkU0pNZnMrcnBudE9IblZUSlprNnU4M0twQ3hqcnVvbm1zVVRQ?=
 =?utf-8?B?QnRnQjBReXhiTklEalNEQjFicCtaVlBaN1pyTFc5Q2MzRUFLKzZ3Rmt2NUdl?=
 =?utf-8?Q?c0Z0SrLWPbQ=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR02MB10287.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?bGJidlhtSFoxUnJUaWhEZzV6TTM5MlB1bFNac0Z5dlp2WFVIV0RwYk1FZktX?=
 =?utf-8?B?OW9zVC95am1WRExkWWRtZmwrVzF1dTNrbVZpZEt2VkhrNzRUQzh5b0x4SjZs?=
 =?utf-8?B?VjQzdHBremMxOHlNQ0hJNWZ3bTBHRzFLbFg2cjFsR1BRS3lITWUzSy83MVpW?=
 =?utf-8?B?UVR0NU1JNG4yRE5Sa1lVdkYyRWxSY1AvMEN1cGdBV2hOdUpsVExoY2FSZmtQ?=
 =?utf-8?B?RyswTzk5WDAzd1BqV1BpdjlVb2tSMjBTVEdVT0V5TENyNDRuckUycXMyMWRH?=
 =?utf-8?B?bDljSlVqZUhBVU4wbmZMaEZ6TUtLV1BOZFplMkI4ZlhaMXNZNjVHY0hzckpv?=
 =?utf-8?B?R1VWL3pMb3czS01DUnhJR0djWmhhM1VqTjZhM0ZjL3p0d1hNNStiZDhrY2R0?=
 =?utf-8?B?ZVdJNWUvMXBsZ09YL0M4TTBMTlpjaFlRa2xZS0dkT2RIK2JseHVBcklCYXp1?=
 =?utf-8?B?OFpLbXVIRERsdG9UMzYwN0J6b1pDVVZJQUw4Q2RGbFdLRGExaSt4T1l5VERS?=
 =?utf-8?B?V2FzNXBYTnN3aldFTUprZURKSTVnQlhZdzlWM0ZnRkVIMEJmQzlUV1l1bFdx?=
 =?utf-8?B?K0tDektZOHdrc1RlNnZya3Bzd1NkaHZMWkJNa2hZSXRHU25pYUIyS01rbmFN?=
 =?utf-8?B?c0tYRytkeUJPaHRkRG43N2gwblNCdGZJWk5wbjc2clFrRU05SjJObTRFNzBL?=
 =?utf-8?B?aGRETzlxMGVPcXlSZW1IMzVMRkprY1RhVFpJUnhva29IVkZvbDh4MzZpMVM2?=
 =?utf-8?B?OUNBWGlBTVhWSS8za2tSRHVEMXJQRGUwV2FGZHZ6NW1GWDd0cGRiR2ZBNDdF?=
 =?utf-8?B?VERqeC9jemtSVzQ5MXluYnBoWXBiZWhkandvY3d6WnhSUDU0NGY5OU5KZGNQ?=
 =?utf-8?B?c0RzQk0wUnhxRVBxUUdxZEptZUtpd2l2Q25uR0h6ejhubUtSTDlpYXNBcmtC?=
 =?utf-8?B?c25pQjVKWDd6TTZ0U0xrSU1hazFRTWtFNHFwUm5yTDBsZElqUkpZcHV0QXBP?=
 =?utf-8?B?dStYRjIvek9GalNLUTErejdyajJwMEorSjVTQ1JzUzVwWHNKZE9EQVZqUHJX?=
 =?utf-8?B?VHBsdHpTd0RxOFhUMDB1bWg3dlRYenlaRENIc2R6YVhQWFBvMGxWUjhLSDQ2?=
 =?utf-8?B?aTJuUzc5dHNJVnFTYTNlMWE4d2pDa2VWUzhLR1JVeTRJRGlxaGs1bHA0QWRZ?=
 =?utf-8?B?STlKYjdERUtmMUZMNG11TzVrbjJoR0RwWktUZDRhK2tweEJEcTlZL2ZHY1V6?=
 =?utf-8?B?Qm9oUUpIYm9tMW9SZTE5ZHc3TEtHQXZqLy9QSHZVRnpSeFViNG9zQXk2Zy9z?=
 =?utf-8?B?eVpia1JjSldJeDR1aDJzaHZINjgwN2xXdXhITXpkUTFwdEo5MTJkM0EwZkpL?=
 =?utf-8?B?aExOanJFZ0J3VmVDTXk1Z2F5UkRZS29HN1Mwb3RmRkNyZDl4SVZaYUhPT1Fy?=
 =?utf-8?B?NjhFVEJRM2ZZSStvUUNiY2JnY0svdlZiUVRLd29IbS9SWXN1Q1Y4VXBucUMr?=
 =?utf-8?B?YzFMLys5VkNxMmhsT2FCNldOZDBQN21DUW1nWUR0V2s0L01EVXdqQ3d6QnAr?=
 =?utf-8?B?aFZmYzBpbW5wN0diaXJrMUZXeklHOW5jQnE3MFBQWThrZDB5WmJMYU02NGY5?=
 =?utf-8?B?V2Nud1g2RDc4UXlQWE9qY1Jobnc5ekwrdUdMYkdOSGExcnJBOUFHZXJYT2Rl?=
 =?utf-8?B?aURGQ0ZLVHY4Qmo1ZzNQcGpkOEh3L0F1d1pvVXdGOUFUQnliY05RR3pVZmN1?=
 =?utf-8?B?VE15MTZVTi8vb0Rsb2pVVzdvcTFLVVpOVmlNWHNDSUFiOGkyNnRzd2JQdmt2?=
 =?utf-8?B?SHMwNkxWZW00TGVpWDJXZGdtT0NOYytILytzVUZZblBCb2FwNzBnK2xkZ05B?=
 =?utf-8?B?R0lvRDdaWHR2L2YxeHl3a251ak53SFBqRTZtNGtoSFJ1Q05jZElNN09oQkNU?=
 =?utf-8?B?TGxXaWlTQTdkUGIrYnR6b0lQMW1helNla3RYbXpJeVM4SHdQS1hLRjFFc3pm?=
 =?utf-8?B?OTh2d0oyNnJPbVgvTURZUkFOUjkxanBtcmFDU1FPVVpuelJHOEZwbDhaNExJ?=
 =?utf-8?B?emdSTkZ2dHlibkc4RTYrOGpYbCtFcXo3K01EMXVESlcyeVArQzdFNnllVVJs?=
 =?utf-8?B?bHJMeHZ5SkduWk5ObHp5SnVWVTFCSTJ2OTVVQ2JxYXgya2N6V1NHUW5tVGwz?=
 =?utf-8?B?bTNLRjBScjdnK0ErVUNxTWVCZlNaQWxUeWx6L3NldGFsRVg2NmcxMXY1M0R0?=
 =?utf-8?B?Z25nWGZIT0MxS1RacEM2T0UyMjd3PT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D3164816E3B37147851A36131DC8E2AB@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV8PR02MB10287.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4217ffc-1d7a-4d32-0f90-08dd9168ab30
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 May 2025 15:21:29.0750
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ys7NmFOva1ASRfwEs1pVDtcpmVvNoVLQLkQSew2v4sFGvVaSxMJM4ulSe12chM4cX7ifWjyE0Xk1nb8DPBLDH6plJbspzulPNDfnaYv0wSM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR02MB8113
X-Proofpoint-ORIG-GUID: 79HgfMGSN1B0Kr4_2KuImmiPmr7CLlxW
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTEyMDE1OSBTYWx0ZWRfXx4DoQLFBYK5X 6vFstiLyD8fGvDZouXEnV11if0cmcImAXvIvcqIimhp222sME7ttmI/Isz93w0fY2wt9jiisig3 aO3Ww5ladXH6bCoBDJGpn2RkFfzlM+QXAL6ySeTH7XTRgdAzMmvGsJN4aq0KmhFcwg62xMwS6Vi
 suUL1dPcb3X9jtUD1qHU8zyhtGYVtpnzeCpJ8gkPbhdDftuit6aH97WRmnSOhLypqEqLiK1sTsN KRKs8wkacphK4NAH1i5tzgek+/25mbq1bq6OPQOoa+R+l90LduiGBQyuI8QqyPB45Htd7gcEhHo 0r2MWpKvoUNbGCpO4/dPM5catl/jk5o7WNaXkiqOHarbDnR6lbDWOAz1QQQifRC8zEj4FTTkSSM
 hR0VKFlddld9LE3ZrVwEqUZem4Dw/x4XA3Ok/dZcj4tWLKbXhx8mBGPmyl4R50Ze8Ox1OvwY
X-Proofpoint-GUID: 79HgfMGSN1B0Kr4_2KuImmiPmr7CLlxW
X-Authority-Analysis: v=2.4 cv=Qapmvtbv c=1 sm=1 tr=0 ts=682211fb cx=c_pps a=o99l/OlIsmxthp48M8gYaQ==:117 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=dt9VzEwgFbYA:10 a=0kUYKlekyDsA:10 a=NEAV23lmAAAA:8 a=64Cc0HZtAAAA:8 a=20KFwNOVAAAA:8 a=_NEaW80ZsJpL1gdVkwYA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-12_05,2025-05-09_01,2025-02-21_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gQXByIDMwLCAyMDI1LCBhdCA5OjIx4oCvUE0sIEpvbiBLb2hsZXIgPGpvbkBudXRh
bml4LmNvbT4gd3JvdGU6DQo+IA0KPiANCj4gDQo+PiBPbiBBcHIgMTYsIDIwMjUsIGF0IDY6MTXi
gK9BTSwgRXVnZW5pbyBQZXJleiBNYXJ0aW4gPGVwZXJlem1hQHJlZGhhdC5jb20+IHdyb3RlOg0K
Pj4gDQo+PiAhLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLXwNCj4+IENBVVRJT046IEV4dGVybmFsIEVtYWlsDQo+PiANCj4+
IHwtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tIQ0KPj4gDQo+PiBPbiBUdWUsIEFwciA4LCAyMDI1IGF0IDg6MjjigK9BTSBK
YXNvbiBXYW5nIDxqYXNvd2FuZ0ByZWRoYXQuY29tPiB3cm90ZToNCj4+PiANCj4+PiBPbiBUdWUs
IEFwciA4LCAyMDI1IGF0IDk6MTjigK9BTSBKb24gS29obGVyIDxqb25AbnV0YW5peC5jb20+IHdy
b3RlOg0KPj4+PiANCj4+Pj4gDQo+Pj4+IA0KPj4+Pj4gT24gQXByIDYsIDIwMjUsIGF0IDc6MTTi
gK9QTSwgSmFzb24gV2FuZyA8amFzb3dhbmdAcmVkaGF0LmNvbT4gd3JvdGU6DQo+Pj4+PiANCj4+
Pj4+ICEtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tfA0KPj4+Pj4gQ0FVVElPTjogRXh0ZXJuYWwgRW1haWwNCj4+Pj4+IA0K
Pj4+Pj4gfC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0hDQo+Pj4+PiANCj4+Pj4+IE9uIEZyaSwgQXByIDQsIDIwMjUgYXQg
MTA6MjTigK9QTSBKb24gS29obGVyIDxqb25AbnV0YW5peC5jb20+IHdyb3RlOg0KPj4+Pj4+IA0K
Pj4+Pj4+IENvbW1pdCAwOThlYWRjZTNjNjIgKCJ2aG9zdF9uZXQ6IGRpc2FibGUgemVyb2NvcHkg
YnkgZGVmYXVsdCIpIGRpc2FibGVkDQo+Pj4+Pj4gdGhlIG1vZHVsZSBwYXJhbWV0ZXIgZm9yIHRo
ZSBoYW5kbGVfdHhfemVyb2NvcHkgcGF0aCBiYWNrIGluIDIwMTksDQo+Pj4+Pj4gbm90aGluZyB0
aGF0IG1hbnkgZG93bnN0cmVhbSBkaXN0cmlidXRpb25zIChlLmcuLCBSSEVMNyBhbmQgbGF0ZXIp
IGhhZA0KPj4+Pj4+IGFscmVhZHkgZG9uZSB0aGUgc2FtZS4NCj4+Pj4+PiANCj4+Pj4+PiBCb3Ro
IHVwc3RyZWFtIGFuZCBkb3duc3RyZWFtIGRpc2FibGVtZW50IHN1Z2dlc3QgdGhpcyBwYXRoIGlz
IHJhcmVseQ0KPj4+Pj4+IHVzZWQuDQo+Pj4+Pj4gDQo+Pj4+Pj4gVGVzdGluZyB0aGUgbW9kdWxl
IHBhcmFtZXRlciBzaG93cyB0aGF0IHdoaWxlIHRoZSBwYXRoIGFsbG93cyBwYWNrZXQNCj4+Pj4+
PiBmb3J3YXJkaW5nLCB0aGUgemVyb2NvcHkgZnVuY3Rpb25hbGl0eSBpdHNlbGYgaXMgYnJva2Vu
LiBPbiBvdXRib3VuZA0KPj4+Pj4+IHRyYWZmaWMgKGd1ZXN0IFRYIC0+IGV4dGVybmFsKSwgemVy
b2NvcHkgU0tCcyBhcmUgb3JwaGFuZWQgYnkgZWl0aGVyDQo+Pj4+Pj4gc2tiX29ycGhhbl9mcmFn
c19yeCgpICh1c2VkIHdpdGggdGhlIHR1biBkcml2ZXIgdmlhIHR1bl9uZXRfeG1pdCgpKQ0KPj4+
Pj4gDQo+Pj4+PiBUaGlzIGlzIGJ5IGRlc2lnbiB0byBhdm9pZCBET1MuDQo+Pj4+IA0KPj4+PiBJ
IHVuZGVyc3RhbmQgdGhhdCwgYnV0IGl0IG1ha2VzIFpDIG5vbi1mdW5jdGlvbmFsIGluIGdlbmVy
YWwsIGFzIFpDIGZhaWxzDQo+Pj4+IGFuZCBpbW1lZGlhdGVseSBpbmNyZW1lbnRzIHRoZSBlcnJv
ciBjb3VudGVycy4NCj4+PiANCj4+PiBUaGUgbWFpbiBpc3N1ZSBpcyBIT0wsIGJ1dCB6ZXJvY29w
eSBtYXkgc3RpbGwgd29yayBpbiBzb21lIHNldHVwcyB0aGF0DQo+Pj4gZG9uJ3QgbmVlZCB0byBj
YXJlIGFib3V0IEhPTC4gT25lIGV4YW1wbGUgdGhlIG1hY3Z0YXAgcGFzc3Rocm91Z2gNCj4+PiBt
b2RlLg0KPj4+IA0KPj4+PiANCj4+Pj4+IA0KPj4+Pj4+IG9yDQo+Pj4+Pj4gc2tiX29ycGhhbl9m
cmFncygpIGVsc2V3aGVyZSBpbiB0aGUgc3RhY2ssDQo+Pj4+PiANCj4+Pj4+IEJhc2ljYWxseSB6
ZXJvY29weSBpcyBleHBlY3RlZCB0byB3b3JrIGZvciBndWVzdCAtPiByZW1vdGUgY2FzZSwgc28N
Cj4+Pj4+IGNvdWxkIHdlIHN0aWxsIGhpdCBza2Jfb3JwaGFuX2ZyYWdzKCkgaW4gdGhpcyBjYXNl
Pw0KPj4+PiANCj4+Pj4gWWVzLCB5b3XigJlkIGhpdCB0aGF0IGluIHR1bl9uZXRfeG1pdCgpLg0K
Pj4+IA0KPj4+IE9ubHkgZm9yIGxvY2FsIFZNIHRvIGxvY2FsIFZNIGNvbW11bmljYXRpb24uDQo+
IA0KPiBTdXJlLCBidXQgdGhlIHRyaWNreSBiaXQgaGVyZSBpcyB0aGF0IGlmIHlvdSBoYXZlIGEg
bWl4IG9mIFZNLVZNIGFuZCBWTS1leHRlcm5hbA0KPiB0cmFmZmljIHBhdHRlcm5zLCBhbnkgdGlt
ZSB0aGUgZXJyb3IgcGF0aCBpcyBoaXQsIHRoZSB6YyBlcnJvciBjb3VudGVyIHdpbGwgZ28gdXAu
DQo+IA0KPiBXaGVuIHRoYXQgaGFwcGVucywgWkMgd2lsbCBnZXQgc2lsZW50bHkgZGlzYWJsZWQg
YW55aG93LCBzbyBpdCBsZWFkcyB0byBzcG9yYWRpYw0KPiBzdWNjZXNzIC8gbm9uLWRldGVybWlu
aXN0aWMgcGVyZm9ybWFuY2UuDQo+IA0KPj4+IA0KPj4+PiBJZiB5b3UgcHVuY2ggYSBob2xlIGlu
IHRoYXQgKmFuZCogaW4gdGhlDQo+Pj4+IHpjIGVycm9yIGNvdW50ZXIgKHN1Y2ggdGhhdCBmYWls
ZWQgWkMgZG9lc27igJl0IGRpc2FibGUgWkMgaW4gdmhvc3QpLCB5b3UgZ2V0IFpDDQo+Pj4+IGZy
b20gdmhvc3Q7IGhvd2V2ZXIsIHRoZSBuZXR3b3JrIGludGVycnVwdCBoYW5kbGVyIHVuZGVyIG5l
dF90eF9hY3Rpb24gYW5kDQo+Pj4+IGV2ZW50dWFsbHkgaW5jdXJzIHRoZSBtZW1jcHkgdW5kZXIg
ZGV2X3F1ZXVlX3htaXRfbml0KCkuDQo+Pj4gDQo+Pj4gV2VsbCwgeWVzLCB3ZSBuZWVkIGEgY29w
eSBpZiB0aGVyZSdzIGEgcGFja2V0IHNvY2tldC4gQnV0IGlmIHRoZXJlJ3MNCj4+PiBubyBuZXR3
b3JrIGludGVyZmFjZSB0YXBzLCB3ZSBkb24ndCBuZWVkIHRvIGRvIHRoZSBjb3B5IGhlcmUuDQo+
Pj4gDQo+IA0KPiBBZ3JlZWQgb24gdGhlIHBhY2tldCBzb2NrZXQgc2lkZS4gSSByZWNlbnRseSBm
aXhlZCBhbiBpc3N1ZSBpbiBsbGRwZCBbMV0gdGhhdCBwcmV2ZW50ZWQNCj4gdGhpcyBzcGVjaWZp
YyBjYXNlOyBob3dldmVyLCB0aGVyZSBhcmUgc3RpbGwgb3RoZXIgdHJpcCB3aXJlcyBzcHJlYWQg
b3V0IGFjcm9zcyB0aGUNCj4gc3RhY2sgdGhhdCB3b3VsZCBuZWVkIHRvIGJlIGFkZHJlc3NlZC4N
Cj4gDQo+IFsxXSBodHRwczovL2dpdGh1Yi5jb20vbGxkcGQvbGxkcGQvY29tbWl0LzYyMmE5MTE0
NGRlNGFlNDg3Y2VlYmRiMzMzODYzZTlmNjYwZTA3MTcNCj4gDQo+PiANCj4+IEhpIQ0KPj4gDQo+
PiBJIG5lZWQgbW9yZSB0aW1lIGRpdmluZyBpbnRvIHRoZSBpc3N1ZXMuIEFzIEpvbiBtZW50aW9u
ZWQsIHZob3N0IFpDIGlzDQo+PiBzbyBsaXR0bGUgdXNlZCBJIGRpZG4ndCBoYXZlIHRoZSBjaGFu
Y2UgdG8gZXhwZXJpbWVudCB3aXRoIHRoaXMgdW50aWwNCj4+IG5vdyA6KS4gQnV0IHllcywgSSBl
eHBlY3QgdG8gYmUgYWJsZSB0byBvdmVyY29tZSB0aGVzZSBmb3IgcGFzdGEsIGJ5DQo+PiBhZGFw
dGluZyBidWZmZXIgc2l6ZXMgb3IgbW9kaWZ5aW5nIGNvZGUgZXRjLg0KPiANCj4gQW5vdGhlciB0
cmlja3kgYml0IGhlcmUgaXMgdGhhdCBpdCBoYXMgYmVlbiBkaXNhYmxlZCBib3RoIHVwc3RyZWFt
IGFuZCBkb3duc3RyZWFtDQo+IGZvciBzbyBsb25nLCB0aGUgY29kZSBuYXR1cmFsbHkgaGFzIGEg
Yml0IG9mIHdyZW5jaC1pbi10aGUtZW5naW5lLg0KPiANCj4gUkUgQnVmZmVyIHNpemVzOiBJIHRy
aWVkIHRoaXMgYXMgd2VsbCwgYmVjYXVzZSBJIHRoaW5rIG9uIHN1ZmZpY2llbnRseSBmYXN0IHN5
c3RlbXMsDQo+IHplcm8gY29weSBnZXRzIGVzcGVjaWFsbHkgaW50ZXJlc3RpbmcgaW4gR1NPL1RT
TyBjYXNlcyB3aGVyZSB5b3UgaGF2ZSBtZWdhDQo+IHBheWxvYWRzLg0KPiANCj4gSSB0cmllZCBw
bGF5aW5nIGFyb3VuZCB3aXRoIHRoZSBnb29kIGNvcHkgdmFsdWUgc3VjaCB0aGF0IFpDIHJlc3Ry
aWN0ZWQgaXRzZWxmIHRvDQo+IG9ubHkgbGV0cyBzYXkgMzJLIHBheWxvYWRzIGFuZCBhYm92ZSwg
YW5kIHdoaWxlIGl0ICpkb2VzKiB3b3JrICh3aXRoIGVub3VnaA0KPiBob2xlcyBwdW5jaGVkIGlu
KSwgYWJzb2x1dGUgdC1wdXQgZG9lc27igJl0IGFjdHVhbGx5IGdvIHVwLCBpdHMganVzdCB0aGF0
IENQVSB1dGlsaXphdGlvbg0KPiBnb2VzIGRvd24gYSBwaW5jaC4gTm90IGEgYmFkIHRoaW5nIGZv
ciBjZXJ0YWluLCBidXQgc3RpbGwgbm90IGdyZWF0Lg0KPiANCj4gSW4gZmFjdCwgSSBmb3VuZCB0
aGF0IHRwdXQgYWN0dWFsbHkgd2VudCBkb3duIHdpdGggdGhpcyBwYXRoLCBldmVuIHdpdGggWkMg
b2NjdXJyaW5nDQo+IHN1Y2Nlc3NmdWxseSwgYXMgdGhlcmUgd2FzIHN0aWxsIGEgbWl4IG9mIFpD
IGFuZCBub24tWkMgYmVjYXVzZSB5b3UgY2FuIG9ubHkNCj4gaGF2ZSBzbyBtYW55IHBlbmRpbmcg
YXQgYW55IGdpdmVuIHRpbWUgYmVmb3JlIHRoZSBjb3B5IHBhdGgga2lja3MgaW4gYWdhaW4uDQo+
IA0KPiANCj4+IA0KPj4+PiANCj4+Pj4gVGhpcyBpcyBubyBtb3JlIHBlcmZvcm1hbnQsIGFuZCBp
biBmYWN0IGlzIGFjdHVhbGx5IHdvcnNlIHNpbmNlIHRoZSB0aW1lIHNwZW50DQo+Pj4+IHdhaXRp
bmcgb24gdGhhdCBtZW1jcHkgdG8gcmVzb2x2ZSBpcyBsb25nZXIuDQo+Pj4+IA0KPj4+Pj4gDQo+
Pj4+Pj4gYXMgdmhvc3RfbmV0IGRvZXMgbm90IHNldA0KPj4+Pj4+IFNLQkZMX0RPTlRfT1JQSEFO
Lg0KPj4+IA0KPj4+IE1heWJlIHdlIGNhbiB0cnkgdG8gc2V0IHRoaXMgYXMgdmhvc3QtbmV0IGNh
biBob3Jub3IgdWxpbWl0IG5vdy4NCj4gDQo+IFllYSBJIHRyaWVkIHRoYXQsIGFuZCB3aGlsZSBp
dCBoZWxwcyBraWNrIHRoaW5ncyBmdXJ0aGVyIGRvd24gdGhlIHN0YWNrLCBpdHMgbm90IGFjdHVh
bGx5DQo+IGZhc3RlciBpbiBhbnkgdGVzdGluZyBJ4oCZdmUgZHJ1bW1lZCB1cC4NCj4gDQo+Pj4g
DQo+Pj4+Pj4gDQo+Pj4+Pj4gT3JwaGFuaW5nIGVuZm9yY2VzIGEgbWVtY3B5IGFuZCB0cmlnZ2Vy
cyB0aGUgY29tcGxldGlvbiBjYWxsYmFjaywgd2hpY2gNCj4+Pj4+PiBpbmNyZW1lbnRzIHRoZSBm
YWlsZWQgVFggY291bnRlciwgZWZmZWN0aXZlbHkgZGlzYWJsaW5nIHplcm9jb3B5IGFnYWluLg0K
Pj4+Pj4+IA0KPj4+Pj4+IEV2ZW4gYWZ0ZXIgYWRkcmVzc2luZyB0aGVzZSBpc3N1ZXMgdG8gcHJl
dmVudCBTS0Igb3JwaGFuaW5nIGFuZCBlcnJvcg0KPj4+Pj4+IGNvdW50ZXIgaW5jcmVtZW50cywg
cGVyZm9ybWFuY2UgcmVtYWlucyBwb29yLiBCeSBkZWZhdWx0LCBvbmx5IDY0DQo+Pj4+Pj4gbWVz
c2FnZXMgY2FuIGJlIHplcm9jb3BpZWQsIHdoaWNoIGlzIGltbWVkaWF0ZWx5IGV4aGF1c3RlZCBi
eSB3b3JrbG9hZHMNCj4+Pj4+PiBsaWtlIGlwZXJmLCByZXN1bHRpbmcgaW4gbW9zdCBtZXNzYWdl
cyBiZWluZyBtZW1jcHknZCBhbnlob3cuDQo+Pj4+Pj4gDQo+Pj4+Pj4gQWRkaXRpb25hbGx5LCBt
ZW1jcHknZCBtZXNzYWdlcyBkbyBub3QgYmVuZWZpdCBmcm9tIHRoZSBYRFAgYmF0Y2hpbmcNCj4+
Pj4+PiBvcHRpbWl6YXRpb25zIHByZXNlbnQgaW4gdGhlIGhhbmRsZV90eF9jb3B5IHBhdGguDQo+
Pj4+Pj4gDQo+Pj4+Pj4gR2l2ZW4gdGhlc2UgbGltaXRhdGlvbnMgYW5kIHRoZSBsYWNrIG9mIGFu
eSB0YW5naWJsZSBiZW5lZml0cywgcmVtb3ZlDQo+Pj4+Pj4gemVyb2NvcHkgZW50aXJlbHkgdG8g
c2ltcGxpZnkgdGhlIGNvZGUgYmFzZS4NCj4+Pj4+PiANCj4+Pj4+PiBTaWduZWQtb2ZmLWJ5OiBK
b24gS29obGVyIDxqb25AbnV0YW5peC5jb20+DQo+Pj4+PiANCj4+Pj4+IEFueSBjaGFuY2Ugd2Ug
Y2FuIGZpeCB0aG9zZSBpc3N1ZXM/IEFjdHVhbGx5LCB3ZSBoYWQgYSBwbGFuIHRvIG1ha2UNCj4+
Pj4+IHVzZSBvZiB2aG9zdC1uZXQgYW5kIGl0cyB0eCB6ZXJvY29weSAob3IgZXZlbiBpbXBsZW1l
bnQgdGhlIHJ4DQo+Pj4+PiB6ZXJvY29weSkgaW4gcGFzdGEuDQo+Pj4+IA0KPj4+PiBIYXBweSB0
byB0YWtlIGRpcmVjdGlvbiBhbmQgaWRlYXMgaGVyZSwgYnV0IEkgZG9u4oCZdCBzZWUgYSBjbGVh
ciB3YXkgdG8gZml4IHRoZXNlDQo+Pj4+IGlzc3Vlcywgd2l0aG91dCBkZWFsaW5nIHdpdGggdGhl
IGFzc2VydGlvbnMgdGhhdCBza2Jfb3JwaGFuX2ZyYWdzX3J4IGNhbGxzIG91dC4NCj4+Pj4gDQo+
Pj4+IFNhaWQgYW5vdGhlciB3YXksIEnigJlkIGJlIGludGVyZXN0ZWQgaW4gaGVhcmluZyBpZiB0
aGVyZSBpcyBhIGNvbmZpZyB3aGVyZSBaQyBpbg0KPj4+PiBjdXJyZW50IGhvc3QtbmV0IGltcGxl
bWVudGF0aW9uIHdvcmtzLCBhcyBJIHdhcyBkcml2aW5nIG15c2VsZiBjcmF6eSB0cnlpbmcgdG8N
Cj4+Pj4gcmV2ZXJzZSBlbmdpbmVlci4NCj4+PiANCj4+PiBTZWUgYWJvdmUuDQo+Pj4gDQo+Pj4+
IA0KPj4+PiBIYXBweSB0byBjb2xsYWJvcmF0ZSBpZiB0aGVyZSBpcyBzb21ldGhpbmcgd2UgY291
bGQgZG8gaGVyZS4NCj4+PiANCj4+PiBHcmVhdCwgd2UgY2FuIHN0YXJ0IGhlcmUgYnkgc2Vla2lu
ZyBhIHdheSB0byBmaXggdGhlIGtub3duIGlzc3VlcyBvZg0KPj4+IHRoZSB2aG9zdC1uZXQgemVy
b2NvcHkgY29kZS4NCj4+PiANCj4+IA0KPj4gSGFwcHkgdG8gaGVscCBoZXJlIDopLg0KPj4gDQo+
PiBKb24sIGNvdWxkIHlvdSBzaGFyZSBtb3JlIGRldGFpbHMgYWJvdXQgdGhlIG9ycGhhbiBwcm9i
bGVtIHNvIEkgY2FuDQo+PiBzcGVlZCB1cCB0aGUgaGVscD8gRm9yIGV4YW1wbGUsIGNhbiB5b3Ug
ZGVzY3JpYmUgdGhlIGNvZGUgY2hhbmdlcyBhbmQNCj4+IHRoZSBjb2RlIHBhdGggdGhhdCB3b3Vs
ZCBsZWFkIHRvIHRoYXQgYXNzZXJ0aW9uIG9mDQo+PiBza2Jfb3JwaGFuX2ZyYWdzX3J4Pw0KPj4g
DQo+PiBUaGFua3MhDQo+PiANCj4gDQo+IFNvcnJ5IGZvciB0aGUgc2xvdyByZXNwb25zZSwgZ2V0
dGluZyBiYWNrIGZyb20gaG9saWRheSBhbmQgY2F0Y2hpbmcgdXAuDQo+IA0KPiBXaGVuIHJ1bm5p
bmcgdGhyb3VnaCB0dW4uYywgdGhlcmUgYXJlIGEgaGFuZGZ1bCBvZiBwbGFjZXMgd2hlcmUgWkMg
dHVybnMgaW50bw0KPiBhIGZ1bGwgY29weSwgd2hldGhlciB0aGF0IGlzIGluIHRoZSB0dW4gY29k
ZSBpdHNlbGYsIG9yIGluIHRoZSBpbnRlcnJ1cHQgaGFuZGxlciB3aGVuDQo+IHR1biB4bWl0IGlz
IHJ1bm5pbmcuDQo+IA0KPiBGb3IgZXhhbXBsZSwgdHVuX25ldF94bWl0IG1hbmRhdG9yaWx5IGNh
bGxzIHNrYl9vcnBoYW5fZnJhZ3NfcnguIEFueXRoaW5nDQo+IHdpdGggZnJhZ3Mgd2lsbCBnZXQg
dGhpcyBtZW1jcHksIHdoaWNoIGFyZSBvZiBjb3Vyc2UgdGhlIOKAnGp1aWN54oCdIHRhcmdldHMg
aGVyZSBhcw0KPiB0aGV5IHdvdWxkIHRha2UgdXAgdGhlIG1vc3QgbWVtb3J5IGJhbmR3aWR0aCBp
biBnZW5lcmFsLiBOYXN0eSBjYXRjaDIyIDopIA0KPiANCj4gVGhlcmUgYXJlIGFsc28gcGxlbnR5
IG9mIHBsYWNlcyB0aGF0IGNhbGwgbm9ybWFsIHNrYl9vcnBoYW5fZnJhZ3MsIHdoaWNoDQo+IHRy
aWdnZXJzIGJlY2F1c2Ugdmhvc3QgZG9lc27igJl0IHNldCBTS0JGTF9ET05UX09SUEhBTi4gVGhh
dOKAmXMgYW4gZWFzeQ0KPiBmaXgsIGJ1dCBzdGlsbCBzb21ldGhpbmcgdG8gdGhpbmsgYWJvdXQu
DQo+IA0KPiBUaGVuIHRoZXJlIGlzIHRoZSBpc3N1ZSBvZiBwYWNrZXQgc29ja2V0cywgd2hpY2gg
dGhyb3cgYSBraW5nIHNpemVkIHdyZW5jaCBpbnRvDQo+IHRoaXMuIEl0cyBzbGlnaHRseSBpbnNp
ZGlvdXMsIGJ1dCBpdCBpc27igJl0IGRpcmVjdGx5IGFwcGFyZW50IHRoYXQgbG9hZGluZyBzb21l
IHVzZXINCj4gc3BhY2UgYXBwIG51a2VzIHplcm8gY29weSwgYnV0IGl0IGhhcHBlbnMuDQo+IA0K
PiBTZWUgbXkgcHJldmlvdXMgY29tbWVudCBhYm91dCBMTERQRCwgd2hlcmUgYSBzaW1wbHkgY29t
cGlsZXIgc25hZnUgY2F1c2VkDQo+IG9uZSBzb2NrZXQgb3B0aW9uIHRvIGdldCBzaWxlbnRseSBi
cmVhaywgYW5kIGl0IHRoZW4gcmlwcGVkIG91dCBaQyBjYXBhYmlsaXR5LiBFYXN5DQo+IGZpeCwg
YnV0IGl0cyBhbiBleGFtcGxlIG9mIGhvdyB0aGlzIGNhbiBmYWxsIG92ZXIuDQo+IA0KPiBCb3R0
b20gbGluZSwgSeKAmWQgKmxvdmUqKioqKiogaGF2ZSBaQyB3b3JrLCB3b3JrIHdlbGwgYW5kIHNv
IG9uLiBJ4oCZbSBvcGVuIHRvIGlkZWFzDQo+IGhlcmUgOikgKHVwIHRvIGFuZCBpbmNsdWRpbmcg
Ym90aCBBKSBmaXhpbmcgaXQgYW5kIEIpIGRlbGV0aW5nIGl0KQ0KDQpIZXkgRXVnZW5pbyAtIHdv
bmRlcmluZyBpZiB5b3UgaGFkIGEgY2hhbmNlIHRvIGNoZWNrIG91dCBteSBub3RlcyBvbiB0aGlz
Pw0KDQo=

