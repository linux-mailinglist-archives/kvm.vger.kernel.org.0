Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE292343E24
	for <lists+kvm@lfdr.de>; Mon, 22 Mar 2021 11:41:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbhCVKlS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Mar 2021 06:41:18 -0400
Received: from mail-eopbgr70049.outbound.protection.outlook.com ([40.107.7.49]:31825
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229829AbhCVKlC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Mar 2021 06:41:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lKvdQiD1DeK3WgzNNMXYT7Seqv2iEvfsMW54C+WUDqY=;
 b=UZaG8dXP1iFFWS/hUtqApY1LVEtyyhwPe3+hnNnp2MOoWIUDSkRdVkyZ6aT6UzW8qzyXx6XRQrEBBji2SZKZWhIqHmqI0zAVxcBrLRSMX2gRdaTO0JKYigijRCIKPOk9EGAr601SLdbZvXzwFS0tFuKXYvb3eWisWchp8oXScrY=
Received: from MR2P264CA0059.FRAP264.PROD.OUTLOOK.COM (2603:10a6:500:31::23)
 by AM8PR08MB5764.eurprd08.prod.outlook.com (2603:10a6:20b:1d2::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Mon, 22 Mar
 2021 10:40:51 +0000
Received: from VE1EUR03FT050.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:500:31:cafe::e2) by MR2P264CA0059.outlook.office365.com
 (2603:10a6:500:31::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend
 Transport; Mon, 22 Mar 2021 10:40:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=pass action=none
 header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 VE1EUR03FT050.mail.protection.outlook.com (10.152.19.209) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3955.18 via Frontend Transport; Mon, 22 Mar 2021 10:40:50 +0000
Received: ("Tessian outbound 04b74cf98e3c:v87"); Mon, 22 Mar 2021 10:40:49 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 728eac1e6acf68b8
X-CR-MTA-TID: 64aa7808
Received: from aa67cd9c82db.1
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 0261072A-9CF0-42D1-A740-DFE8BF9CC216.1;
        Mon, 22 Mar 2021 10:40:39 +0000
Received: from EUR01-HE1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id aa67cd9c82db.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Mon, 22 Mar 2021 10:40:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FJqG+YVuVLbGxaUk2btdkB7kthGCqSwN4zz2FG8XWjYm60F6TnbHT/K8Gu5QMPh13/NkX9BTgcDKbJhOJu9zm4eJjlUTDP4MYwL1q4nui2mv9BvW1xiu//5MvGdD2nTzIRaCtPrKelOySGwcbFfksnpu6FOeODGcbVdtGnssVNjXJKrCFU5DTR48jTvURPqCnJ77HiV31gRw4pMyJCVLSo7pcCh5QCbIeMn3fQ/FKkYuVDKJ7A5Mq0r1RDhnZPPAqUGKGHk1qpUnyG9O5qNWy85I9vC1N48N1XXaaxTyORsBQwwm9caOkPSEVt3INZZFsg6+qVlc18MPWrcQ2GhVLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lKvdQiD1DeK3WgzNNMXYT7Seqv2iEvfsMW54C+WUDqY=;
 b=RLwEVBfZhsPiMK9TThhrv+qk0EngSSdzxyjS3y0qApb7yc9VwvmGbPWc6cJrVWHbFQb9XZB5nc18xzdTWgP5qJC4sz20R5mjVDWUnP/51n57bB/Q+gt43lq9qLA5aXcxES8zLofKPgs2TU01UkwElkVnyJ5na5V8cCJbkKOkSWwb0rCZ4511rFuqBsSnM+mMCFwfQ20Rt6E/ia3EIq8afVy5xdzPxFW9tRGFNlgiBm7vW5GYHr8qFvqFU33bJ9kE/gduWGmA9atcniunxNsyOJwX8uDOKn+hZ2MelZYhV20ybo6jR9+vUPZ7mtjzEn6LvWPz+SWP7sbxXnNWoa5K6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lKvdQiD1DeK3WgzNNMXYT7Seqv2iEvfsMW54C+WUDqY=;
 b=UZaG8dXP1iFFWS/hUtqApY1LVEtyyhwPe3+hnNnp2MOoWIUDSkRdVkyZ6aT6UzW8qzyXx6XRQrEBBji2SZKZWhIqHmqI0zAVxcBrLRSMX2gRdaTO0JKYigijRCIKPOk9EGAr601SLdbZvXzwFS0tFuKXYvb3eWisWchp8oXScrY=
Authentication-Results-Original: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=arm.com;
Received: from VI1PR08MB3550.eurprd08.prod.outlook.com (2603:10a6:803:84::21)
 by VI1PR08MB3375.eurprd08.prod.outlook.com (2603:10a6:803:87::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.24; Mon, 22 Mar
 2021 10:40:29 +0000
Received: from VI1PR08MB3550.eurprd08.prod.outlook.com
 ([fe80::8834:fa36:9de8:e6e0]) by VI1PR08MB3550.eurprd08.prod.outlook.com
 ([fe80::8834:fa36:9de8:e6e0%7]) with mapi id 15.20.3955.024; Mon, 22 Mar 2021
 10:40:29 +0000
Subject: Re: [kvm-unit-tests PATCH 1/4] arm/arm64: Avoid calling
 cpumask_test_cpu for CPUs above nr_cpu
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, alexandru.elisei@arm.com
References: <20210319122414.129364-1-nikos.nikoleris@arm.com>
 <20210319122414.129364-2-nikos.nikoleris@arm.com>
 <20210322093125.qlbr3wjvinyu7o6m@kamzik.brq.redhat.com>
 <df9a70d0-0129-d3a4-9530-77a7354b8e47@arm.com>
 <20210322101229.5f4epjxjzaq7i5ti@kamzik.brq.redhat.com>
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
Message-ID: <d30766b7-97d2-cfd6-cf6a-3799bd9a6fd6@arm.com>
Date:   Mon, 22 Mar 2021 10:40:26 +0000
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.1
In-Reply-To: <20210322101229.5f4epjxjzaq7i5ti@kamzik.brq.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [2a01:4b00:88be:aa00:e1b6:307a:e182:1112]
X-ClientProxiedBy: LNXP265CA0022.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:5e::34) To VI1PR08MB3550.eurprd08.prod.outlook.com
 (2603:10a6:803:84::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from C02W217MHV2R.local (2a01:4b00:88be:aa00:e1b6:307a:e182:1112) by LNXP265CA0022.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:5e::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.24 via Frontend Transport; Mon, 22 Mar 2021 10:40:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c612008f-6af9-475c-adc2-08d8ed1ef605
X-MS-TrafficTypeDiagnostic: VI1PR08MB3375:|AM8PR08MB5764:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM8PR08MB5764A9566F3C63764A8FA2E8F7659@AM8PR08MB5764.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: 3xLsXsy8MJw8NnEnjBfIutNTpzEoPbGQtEAvNnE0b9+z6oYogATQq3C52t0aq3CS5sskt2Si8G4gWcasmjZ1MYjmAmUEF4eQXojpiPCBldeyMa1MRtXpM9UcOyCiQZoBR5GC+Xy4VrB+xL5IulWo+94DQ9DNUIDnFw2SBVdKIEKEOYVG/ZeP6+eR5jUobqyfcH0uGvsOxFxTHHV9xv/BS00I82WOpJ00gtcpd87pb5m+ftY6dRLfSqSPVnbEOdC3V8JvlajVvPDERTs4j7I/iBx3wUJ4EnRDzLt79ozV3EkQEK0Q5DhB/Bj9jpOG2jorxK7kwvowJQvUhHxCuDXXwWd7x0vT0jvhxkpBNuvk+s/+AAzNZDOpIMYxlxUNTPun/mi8OdAojsxnrsyTOaaNsQSPBUnzZkPyL3z9Usx7ibZ3Hi9jZvpBASVmcKlzB8T8Ntn5nOt9gMNdY6l+CBASDGtbn7hFQ5nzh7wOCAhVxV0racAJLCHWVz5XbM4zjwP0k4fO9BFKPTQagmm/EmNafbJ3YmkfBel3q5gi/kMEyEqXI2fikeM53HsFTwCIC5QQA365accE3M6T35scLBIOK80pdlIRqA8b3vR9CA1tvbQ2VKKwTNx6ctMdIUsiPOO5zmJ4gkxYjD+nZmrMcaAhglIeR7lODJIkqfhPa0kTnlg71BPHi80IDYFRMmqjJY4SOw++u7uPEj2jp4tsdCAudSJUSybYw94PRpodZwNhscI=
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3550.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(366004)(376002)(396003)(136003)(8936002)(478600001)(86362001)(2616005)(8676002)(31686004)(186003)(16526019)(52116002)(316002)(31696002)(6506007)(53546011)(2906002)(6486002)(66556008)(38100700001)(4326008)(44832011)(36756003)(5660300002)(6512007)(6916009)(83380400001)(66476007)(66946007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?ZG1kdnhBTUNEdHlmdnd2akZTK3NtTjliWDVRZHpMYnAvYndrcEhIdnZESXlr?=
 =?utf-8?B?MkJTVlNCSnBIcHp6TzRCL0c3NnpCQ2U0VlFwM2ltWXdmRngvNjlnTFZremt6?=
 =?utf-8?B?TjJ3eUpRMWdVZVVEalRWek5BamxvaVBKVStmeGNVK1FxNUxzc3Vyd2hSWFkw?=
 =?utf-8?B?YlVwdHNoZ0hSc0FCUUp2S1VZdFo2dHRDT1FYTWpDTXloOHlOSlpuRkpFMUlR?=
 =?utf-8?B?dWNURnR0TVpMbEVjOHljL28xaVhBOWFFT2VUZWxMVUNRMzVXSGNxeTBpV2pN?=
 =?utf-8?B?ZFZNT1U2YzdoNlNjN2R0bTFvMU5ZTnNFKzJ4Zi9HVVcvNC9JT05uTHoyR3VT?=
 =?utf-8?B?ZE1aOFl2UFc1NkNsNzVPZG55R2Z3UDNWaG1VNWVXTnZ6ajNSc0NwN3VtaGkr?=
 =?utf-8?B?M25GUVJDc2UzeGdIZXcwOUNVS2VMc1g4NFBQT25BWHRoNnVuOHVTTmFMTm1K?=
 =?utf-8?B?WHFCR1NPV0tqOGd5NUxHQnpST2FCOUVmS0NkMlNQZTM1S0pLR1lKTVhYb1dq?=
 =?utf-8?B?elhNdkJ5QWltYUxuQ3ZlMkRma0dGSEczS3lna2tyWW9hRzNtNDZydXVOZ0c1?=
 =?utf-8?B?VWRsSzMySTNDUlJ0bWZyMTBtWXlzQlRMK2wrTlJIMFJXazF2SHZkc3FVWGpS?=
 =?utf-8?B?S09OS0JJeVFHZHFxOEptY2hJTytialI5YzU3UVRoaUdTL0I0Uk4rZXB1NXNw?=
 =?utf-8?B?SXQ2QS9QR1JwcUNtM1NGcnd6UjRBQXg5TG9lbHRaOWFkeTFyWkNRRnBXWVV6?=
 =?utf-8?B?UnZ2ZGh6bXNmMWpRYzkxRXdSeHVISkF5dU8raGozYUJTbnIvOURQT3hGRHE1?=
 =?utf-8?B?b3BQc21VanpqamVDQ1dCbkZwMjQ2WmYwV3RmU3V3SWp0WnMxZldndDNUcGlp?=
 =?utf-8?B?QTR0aGFWUWU4MkJabnFnTCt0MHhjZEV1cGs2bURpRzV5Q0F2aHgxSlkwWm1p?=
 =?utf-8?B?Mm1aSVNTbE05N0dLcjFhWXVzWkhZWXBJUjZld1JLMmFIbSttazVBczJKTHFL?=
 =?utf-8?B?dlkxMjQ5RFIxVkJCY1V2SzE5QURVT1MxazZrNjZ3MXQ0NUwxWlRiNklZSm9C?=
 =?utf-8?B?MW5YcGpXanJ6SXJYaGpZOVpuaDY1TVdTVGUzOVhWT0tYRC9ka3JITCtOaUtH?=
 =?utf-8?B?V2pHR3BxK1lYWUc1MlNuNHNqc0d4RHV2dURPUGhkQU1xbG4vKytkckVCZDRJ?=
 =?utf-8?B?bnhLYm8raHA5eXdTZGFTelJhejZmUDEzckV1dUozK09kY3g2cjFaT1h2cmFo?=
 =?utf-8?B?YmdHSllPd2I5dkp6ZjNNRWpsSjJTSlhiQ2h1Tk1tQ2JiT3ZhMVNSY0l6VGR2?=
 =?utf-8?B?WjZqazhOeWVYNi9Qai9rb2xaMlIyQWZFUmlaL2htV2QwcHlwUEFISEJKbC8r?=
 =?utf-8?B?Ui9EMUluMTJiaXY4eHQ1dHgwTFVOei9VamxyN3RZR0dlYzdvRTdsVW55Z0xE?=
 =?utf-8?B?TjJZYzJtOFkvcFhWbnlMbGZ0ZjdSay8xQm1HR1Q4bUluaWo0eHJpdEkrbURL?=
 =?utf-8?B?RjBabi80MEl4RHJEV2VxaTJNTytneTJSbGtwdzdRdU53b2FUMFh1V0poNFg1?=
 =?utf-8?B?anIvNVZiL1hoSEdONjYyV3pKQmR4QUgvN0JLbXIyaGI5SHBHUVByK2VJcTV6?=
 =?utf-8?B?bEEvYUo1eHZrMHp5bElSY1lHWVFSUmdybFRqVXBkOVhtVFN4YUFndHova21E?=
 =?utf-8?B?cDFLb3VNbG5GY204SUprUXhaMUNaTUVLYzZhVm9jVURwSDhTSXFES3pReERB?=
 =?utf-8?B?YXRxeWo4djltZDhEOWdVUnNiYzFyd3ZCSVlZbXc0M2VYYmVxZDJaZk9sdXdI?=
 =?utf-8?B?akxWUWNyVXpOSEdSR1F4SE5SaG9rdTJOa0pQNk1sb244K1prSmxFOFFBQm9R?=
 =?utf-8?Q?11otkfcnHbSJb?=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB3375
Original-Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: VE1EUR03FT050.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: 8b84ef9f-ae15-49c6-2e74-08d8ed1ee91b
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Hlv//+D9upMShL9/tBdNnnSNLhjdwxoSpzCA/3PgQPj2e9Kv4AphK0eTaephieIrVg4h8rcDqhWrRqfFw4NMEnmVWLYQ1wrKMNPGX4iCiQxd4Sj6KdnX0WDzryunsw8Hi9ZFQcd6w4OKxNApI9+yHleOdtHDsmBoAy0n9OjtTodgg+oydPwbwc5nNVBrsf6Wc7aJQ5dBWrjmapHlJ87IimUKo15Hpz/C2mGlol5aYjP9pVFnYHMUtGX/T6dJRj2nNMLFnukkbayKhhI3HFgyua5twU74hy8gyi6oMeweDtciJrKFstEgJURSoScxBA8/1U5QkiG/YY6VQonNEUdGklN5nre+oWoKpwmkAQeclnmusDOQUpraFBIaFzFIUOtXPqE9/rj78sSmxfMy76opOegsGVydZ+pnLVmXnJfif8F2rEXTti9TUzbymMnW5zXWBaVitkceGk6NJ+eAiNZRzhCh8BAhvGGV5nYJthocA2TaRaBvPt0r77G3NUkmy01RqPDMcn5lQ1xts4N6VmfMihf9h1FLd2CYhCNjq9K1EAjLmaGF4OEK9Dojl8BBtknTzvl9Fma14yWmQJmGkzZmudix8IKiCsrYdkROxcIXak9ucT6WuEnMRdg8NiNEKPoP9CAFoHC/wnrlX8PzTEnTrlofayLoxtxDUPkayeAKg+ijIkYpJA4QghhCJCM6XQ8S
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(4636009)(376002)(396003)(39860400002)(136003)(346002)(36840700001)(46966006)(86362001)(336012)(8936002)(478600001)(31696002)(2906002)(82740400003)(53546011)(6506007)(2616005)(356005)(36860700001)(8676002)(44832011)(16526019)(26005)(36756003)(70206006)(70586007)(82310400003)(47076005)(186003)(4326008)(31686004)(6512007)(83380400001)(81166007)(316002)(5660300002)(6486002)(6862004)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2021 10:40:50.3585
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c612008f-6af9-475c-adc2-08d8ed1ef605
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: VE1EUR03FT050.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR08MB5764
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/03/2021 10:12, Andrew Jones wrote:
> On Mon, Mar 22, 2021 at 09:45:09AM +0000, Nikos Nikoleris wrote:
>> Hi Drew,
>>
>> On 22/03/2021 09:31, Andrew Jones wrote:
>>> On Fri, Mar 19, 2021 at 12:24:11PM +0000, Nikos Nikoleris wrote:
>>>> Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
>>>> ---
>>>>    lib/arm/asm/cpumask.h | 2 +-
>>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> diff --git a/lib/arm/asm/cpumask.h b/lib/arm/asm/cpumask.h
>>>> index 6683bb6..02124de 100644
>>>> --- a/lib/arm/asm/cpumask.h
>>>> +++ b/lib/arm/asm/cpumask.h
>>>> @@ -105,7 +105,7 @@ static inline void cpumask_copy(cpumask_t *dst, co=
nst cpumask_t *src)
>>>>    static inline int cpumask_next(int cpu, const cpumask_t *mask)
>>>>    {
>>>> -  while (cpu < nr_cpus && !cpumask_test_cpu(++cpu, mask))
>>>> +  while (++cpu < nr_cpus && !cpumask_test_cpu(cpu, mask))
>>>>                    ;
>>>>            return cpu;
>>>
>>
>> Thanks for reviewing this!
>>
>>
>>> This looks like the right thing to do, but I'm surprised that
>>> I've never seen an assert in cpumask_test_cpu, even though
>>> it looks like we call cpumask_next with cpu =3D=3D nr_cpus - 1
>>> in several places.
>>>
>>
>> cpumask_next() would trigger one of the assertions in the 4th patch in t=
his
>> series without this fix. The 4th patch is a way to demonstrate (if we ap=
ply
>> it without the rest) the problem of using cpu0's thread_info->cpu
>> uninitialized.
>
> Ah, I see my error. I had already applied your 4th patch but hadn't
> reviewed it yet, so I didn't realize it was new code. Now it makes
> sense that we didn't hit that assert before (it didn't exist
> before :-)
>
>>
>>> Can you please add a commit message explaining how you found
>>> this bug?
>>>
>>
>> Yes I'll do that.
>
> If you just write one here then I'll add it while applying. The rest of
> the patches look good to me. So no need to respin.
>

Sounds good! Maybe we can add something along the lines of:

Prior to this change, a call of cpumask_next(cpu, mask) where cpu=3Dnr_cpu
- 1 (assuming all cpus are enumerated in the range 0..nr_cpus - 1) would
make an out-of-bounds access to the mask. In many cases, this is still a
valid memory location due the implementation of cpumask_t, however, in
certain configurations (for example, nr_cpus =3D=3D sizeof(long)) this woul=
d
cause an access outside the bounds of the mask too.

This patch changes the way we guard calls to cpumask_test_cpu() in
cpumask_next() to avoid the above condition. A following change adds
assertions to catch out-of-bounds accesses to cpumask_t.

Thanks,

Nikos

> Thanks,
> drew
>
IMPORTANT NOTICE: The contents of this email and any attachments are confid=
ential and may also be privileged. If you are not the intended recipient, p=
lease notify the sender immediately and do not disclose the contents to any=
 other person, use it for any purpose, or store or copy the information in =
any medium. Thank you.
