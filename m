Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 852083FCCC5
	for <lists+kvm@lfdr.de>; Tue, 31 Aug 2021 20:10:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234807AbhHaSLa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Aug 2021 14:11:30 -0400
Received: from mail-shahn0103.outbound.protection.partner.outlook.cn ([42.159.164.103]:61815
        "EHLO CN01-SHA-obe.outbound.protection.partner.outlook.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230145AbhHaSL3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Aug 2021 14:11:29 -0400
X-Greylist: delayed 957 seconds by postgrey-1.27 at vger.kernel.org; Tue, 31 Aug 2021 14:11:29 EDT
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gWDgTC7wKhKe4DwUxVnLkYQehk0okaXJo2PD0yHtBFTJCeTYUSbQTaL/EQrAKblrnpVvVt/vS4iOPWCKD/f96hrnfaKz0txsB+0PDwnM/k51OjKNbv9HRjKUOFXPSib8MjSdBUP6413Sor0hLiYAF+I4vWEFUJn/wuF0Ic0ClRldMhJygOjosxecB6O4E71/boA3j3kKIjEey+p8LShdjs0Wz1FLJqXCRMM+LeuNX//JfalN+Tn7GssufLw+E2Y2kZrz6/Y99hKI5oOa5lWaLdlOIHzgSy+3/YRQi7b+a+AbETJn4yCrXTTlC4O3beFJzTwLZGbNt6rFeK3zAwuGSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wnVPoLOUWRSUeFuNHnrZ9qW8Amx3k+m6ds6pdyIeeLM=;
 b=kmQDaLnjG7YCWmNlFqBHA2NZ5JA3e0XGP6G4Pkxtc25zmILVJppVpLNdoEejdX3Y5agKf/LEMFOqzD55tjgHwZxNI8ouJSPar55JAeYwZKoZRVoZ34Nuo+OhyW9BgoF6h1evahm0Pc9RMhiEPma/exq73z/k1WUJXolLp8APlk3hddoc9kaF38cnBB3SixdNlRTwuPRFIgm0cVbzKpXYPfAzkIo9JtZ8PSTZa14bhi6BHuD+pS6ZG7PWVX+gTxyGRQ/2ETqev7MEbZOQcnZnffCWYmNkgpc1uJ2+pDOcgaAQtQagGBKdgD3wucsLbz6Gmub0XeuBGDe65SPZv251mA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=pactera.com; dmarc=pass action=none header.from=pactera.com;
 dkim=pass header.d=pactera.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pactera.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wnVPoLOUWRSUeFuNHnrZ9qW8Amx3k+m6ds6pdyIeeLM=;
 b=NF1P6gJERVa2dQnpcuty8Ur0YDRI+KJ832OXIIj7W4Qr3LuIDwtMO9xVMRS5OKFlt/SiafDJB4OUKM6DzDXCiDz37qgHCHfkJbVOXihFopK1p2130TcQPhHY8BPq3fePuCdRZTIpCBphzkT4ThfqdeDy+bFr1uGf/R4cA8bWYpdp9Plkk86lQOvarjSnBfsPPpcgDHAvr9/zjHhYvXXSg9ewTeJ1bz4jTfFqdEhiF6KtK3HFiVL44yxb4tp/KOsIlKz60Ex4Ak8fCXi3hNweeW91cn1vPyT4fH8NSqAC+KVWLs991LRguKPRvjXFa8Qmme2Lr0HaYoH+Kfcv9FHiSw==
Authentication-Results: design-joomla.eu; dkim=none (message not signed)
 header.d=none;design-joomla.eu; dmarc=none action=none
 header.from=pactera.com;
Received: from SH0PR01MB0730.CHNPR01.prod.partner.outlook.cn (10.43.106.147)
 by SH0PR01MB0619.CHNPR01.prod.partner.outlook.cn (10.43.108.202) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.17; Tue, 31 Aug
 2021 17:54:27 +0000
Received: from SH0PR01MB0730.CHNPR01.prod.partner.outlook.cn ([10.43.106.147])
 by SH0PR01MB0730.CHNPR01.prod.partner.outlook.cn ([10.43.106.147]) with mapi
 id 15.20.4436.029; Tue, 31 Aug 2021 17:54:27 +0000
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Description: Mail message body
Subject: RE:.
To:     "info@mail.com" <wei.li115@pactera.com>
From:   "Yi Huiman" <wei.li115@pactera.com>
Date:   Tue, 31 Aug 2021 18:40:21 +0200
Reply-To: yihuiman1@csrc-cn.org
X-ClientProxiedBy: SH2PR01CA015.CHNPR01.prod.partner.outlook.cn (10.41.247.25)
 To SH0PR01MB0730.CHNPR01.prod.partner.outlook.cn (10.43.106.147)
Message-ID: <SH0PR01MB07303FEFE634CC6F50F705A6A0CC9@SH0PR01MB0730.CHNPR01.prod.partner.outlook.cn>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [0.0.0.3] (45.133.116.112) by SH2PR01CA015.CHNPR01.prod.partner.outlook.cn (10.41.247.25) with Microsoft SMTP Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.4457.17 via Frontend Transport; Tue, 31 Aug 2021 16:41:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d665ba49-89db-4018-5ae5-08d96c9e4390
X-MS-TrafficTypeDiagnostic: SH0PR01MB0619:
X-Microsoft-Antispam-PRVS: <SH0PR01MB06199B6EB6857DAD58380503A0CC9@SH0PR01MB0619.CHNPR01.prod.partner.outlook.cn>
X-MS-Oob-TLC-OOBClassifiers: OLM:972;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?EUlXGYuNik4mHv8RvbRP8SjVt/oKqMyxz+finURMA6HBg8DdnEheXgpsDa?=
 =?iso-8859-1?Q?eTPKN8ngoayUD2jJMya+l0HIIlqEjzpajIvTEm/QSBBHWNS0yusd4lpngi?=
 =?iso-8859-1?Q?hsY8E50+b4leW4Ptcsf+HyB4GLD4lZrDqNWJSEsy3HBKVAcXZWhlbnvkYJ?=
 =?iso-8859-1?Q?uV8h0Amlnpb8tfZadOzrh793C2ROFI7MYdly3kzL/J3OpRczIWn+Hdf6Mu?=
 =?iso-8859-1?Q?G1brGRLsrZ5yIEuBGagVlpmiyvzY/+c/4ECcQ3AcjnUdwabjJ3lFJZdvgv?=
 =?iso-8859-1?Q?/Cux3+6s0QN5wDQ28OgGjkF+5iX9JjpPvg4efifHyctzjRqLAvIdPIM4L4?=
 =?iso-8859-1?Q?QoAWC/yrfH9omTwovubcFJOLCjPr2BbI88P6YmsRgYWsm4FR0XXPPdGW/Z?=
 =?iso-8859-1?Q?YE2v+JT4vGOeMgM7cwkKmRZAnu0lA2f1azDfy7S42+Ffv2wk1ciEt/2R8y?=
 =?iso-8859-1?Q?o6Cnqe7Ee75Dn3/KLi6C0FeP3c4wm6bMe+iUtEgChLWav5DxhicjY2tLfs?=
 =?iso-8859-1?Q?QKli9sBfpPOVBoP7ULmHJQSks1IM4zyJfIR7/5CppruhzAQsODGmLO8ZJu?=
 =?iso-8859-1?Q?xoOOIgTYi0asq9O79BTxNDlSGY/WB0SUoV7wRk9Ub7S0erMAQa41Fhx7OH?=
 =?iso-8859-1?Q?g17B1gpobMev6+z1zqjUE1mOe3TGZN9jRzhVIaxSUIqqE9uGJEO/TriS3P?=
 =?iso-8859-1?Q?iOfvTBekEpzqd3VbLPH6KeTpmGdaWFsavvLawD2SJKwaYRjIeQLKQ5yr3D?=
 =?iso-8859-1?Q?0W9ElBDpcIMutCX0iqtxieJ5JxT/Tkd2iNj/H6n/QIqCQzVhLVR3i+N4XA?=
 =?iso-8859-1?Q?ykIC/dlsdNCsRWrTswmbiTItk7JO/s76jv5jaGROaD5YzwxXwdP9S1nSb8?=
 =?iso-8859-1?Q?TW2LObQmiZ/EIQKEHs1TlcOhUpdcW8Z1Bg6F0IU3OUj3+/5dy57QxfQWKj?=
 =?iso-8859-1?Q?x5l8jgGxdWr1QEn4PmZFO/5+HnPnJZjwbAdX8EclrSkP9tPgcVE+UcZJDm?=
 =?iso-8859-1?Q?/GIw91InULhJ/Ljhwmy17RAPFxH2B93pF07fINL1nGki+f1o18v0hR3oaL?=
 =?iso-8859-1?Q?iFxKHvUeRz5Zi1WNoAkW/W8=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:5;SRV:;IPV:NLI;SFV:SPM;H:SH0PR01MB0730.CHNPR01.prod.partner.outlook.cn;PTR:;CAT:OSPM;SFS:(376002)(346002)(366004)(329002)(328002)(7416002)(558084003)(9686003)(86362001)(6862004)(95416001)(63696004)(38100700002)(8656006)(186003)(26005)(38350700002)(2906002)(7406005)(7366002)(7276002)(956004)(6706004)(7336002)(7116003)(33656002)(8666007)(6666004)(5660300002)(8676002)(16576012)(6200100001)(66556008)(66946007)(66476007)(52116002)(508600001)(8936002)(100990200001);DIR:OUT;SFP:1501;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?ohzM/E764CFdlSRXL/H+SeJtl77eE83Qn2Ofi9BKtNvVvNUcSMYdA3Y54C?=
 =?iso-8859-1?Q?qcs+eMAzzUQZ93KLNVZtS8QeaCAuasE8TLGUND6qD1Dzby8/eDbsgmebrJ?=
 =?iso-8859-1?Q?q6316jGKoKuAMf5IK4Wmuvj6QdYeIpZNo3yJC4t2CxyOaWeA6eZ5wyl3hc?=
 =?iso-8859-1?Q?EdjkUo7xGeSQf4OYaGdDThYZum4r8tg3ecgSrCJXBi/N/6I41eQT1Lqk4t?=
 =?iso-8859-1?Q?IrjJXkE8GrMM1/xPb8Yi0kBPvyZ8Pc3IH4cIc60hLOk4xYJVLuY6m+8q/d?=
 =?iso-8859-1?Q?mw+ZKTSxh7a6e+i8AUmKGmm1IZveZkyHUR5LS9cUGRBCM1Yo1iUKwrG77A?=
 =?iso-8859-1?Q?8AX0SKk+3lBKsmcJZg5xgi1Zx6yxLCFOLkHh0p6YeY2j2ckxewadQQfEez?=
 =?iso-8859-1?Q?b82ur2cah4tiomThQCz+Hlqr0ubMhN6GlCVtTBAl9HO/5hkqZWe33m3BRC?=
 =?iso-8859-1?Q?QH3tSsTTgeDiJ1M7KnGgm3k2eqd0sw2yUMBbMu8lmxCK8nYzGDPWiGYZPB?=
 =?iso-8859-1?Q?1elv8RaNsi4xprKEZHINUSuU1f8gTzRCoZGrT13kS2CnwyE3BIr75dyDa9?=
 =?iso-8859-1?Q?o99MxCLIJPvcYPI8Ym0BbEXOXAi3pz0mUNyPnL0kNmcfdNb80CsWeCLbhE?=
 =?iso-8859-1?Q?Yg/8DrpW8JqfQzCYqxabde6x3fV472qunj98rEH8jnqefN+F7rdocrgQ07?=
 =?iso-8859-1?Q?nehFbDAa+xRnsms8npsv96bDkd7sAuKzdfPw8orIhZFpJd8nr/uuo9n2Gf?=
 =?iso-8859-1?Q?2QbBhXj6/rg4RfvJoyZ4s09VgVjTzqRpF8orX1QpxZMNXf5tVIgFICbnrz?=
 =?iso-8859-1?Q?h9AFLY62V7JpY0OmwfjoOsaUhVUx1eneDFL7e1NnxoibVnvHWKr9e/axZB?=
 =?iso-8859-1?Q?BMIYCW0QUGRVy3BjGVGCqWorVS8kwLzkrxJ0oyMBqdvIZfID1urebcP2m8?=
 =?iso-8859-1?Q?aDS7ILpz0M5BvtflngsJEkal9OwZa4j4DSrQT3tCMTrI9DsgLq0zf+C+zr?=
 =?iso-8859-1?Q?DUqGYY2ErqVSXqlLD0qH7sn5rs/YSBtuFJE5QH2mUnNLEfBgXTqhaWOtcR?=
 =?iso-8859-1?Q?4jChT3nGcpd3C6wbGvjN6QRCY/nh/bAYehvOuIm+wOU2CkLuovWc5iCuRJ?=
 =?iso-8859-1?Q?vWpNE79bb9DQcMCi+Tp45oaN6fHQVN2/WqpyxvhLEDZpLqZ7sGFyZqd1bF?=
 =?iso-8859-1?Q?uO1dyjDBtl/LHv7qEVDVBJdon+cnNeHe/NVPqx/F2nU9PF2oewrtpxJcR1?=
 =?iso-8859-1?Q?FuU65ZcOy+rTaJxDzOAS5dLxaWzgMkBTl47L4DqacmQiQu4KQFrzAahiUc?=
 =?iso-8859-1?Q?CTso?=
X-OriginatorOrg: pactera.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d665ba49-89db-4018-5ae5-08d96c9e4390
X-MS-Exchange-CrossTenant-AuthSource: SH0PR01MB0730.CHNPR01.prod.partner.outlook.cn
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2021 16:42:04.6580
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 89592e53-6f9d-4b93-82b1-9f8da689f1b4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tXL98MYi1VZJDJu8EFo4zbIaqiM+kcnF8Nm/WtuWVuLCR1dqThN7zETJESXwke9EJpC+dxOxixz270LBC18G/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SH0PR01MB0619
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--I have A secured transaction for you to handle..
