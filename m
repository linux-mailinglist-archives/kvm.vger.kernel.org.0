Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1E4F161536
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2020 15:55:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729222AbgBQOzb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Feb 2020 09:55:31 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:24496 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728493AbgBQOzb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 17 Feb 2020 09:55:31 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01HEj2rm001185;
        Mon, 17 Feb 2020 06:55:22 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version; s=pfpt0818;
 bh=Icm/nTLE7WM0LljVbU4iGYBVV7o0LT/PgTM9tV5xYIc=;
 b=ZileLVsU3LFp/brwQNIHi8YN25LwIiXcBaULLzI2D0TQVCDFV3AtxPbs3a4YrZfcttLF
 T+cwBdviH0Ya+TFdA2DgeBF/R3XZmT6X1TK3D4zVuYeClpsH/QniT42Hd8aUDOppmbIq
 yvE4gubOpyGCl/Ym2QWwa2I3l9Wn5zbmtKZErPlbmyMva6m1hEUPj71HWJeMBP/owSUm
 1qtV8bA0W0RyVTaxGiLuag2VMYk7A1KjVp5xoK1m5hN8JCqHde710D5xBzZoVx2721o8
 +eWehVqNaSpsyPbhD/u1YBeKuh1VveBOQH8BU5TBCq0oTv+TO7epALBYEAN1ZZ8JyMmn SA== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 2y6h1sychh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 17 Feb 2020 06:55:21 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 17 Feb
 2020 06:55:20 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.174)
 by SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Mon, 17 Feb 2020 06:55:20 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YXCCqiymTE2mWGVmLTBKGggd4GmTnQTHX+HKzmJWyaj7V1kyjBqGs/kaOEPbqu79sGJG6EEHGXiIP3zu3oGR8GMwYxy/xd8VSLox/SnDI8KS2KCT2TIt0kMgg4VxplCpiw3rXgbHPnBFNMI7t8WUdG3cPP/C2WLwvYaZQT7BH4tiT+8rR4h4ixZBjrO5QWo8aFdnHYOX46zPEmqPwDm+rq8nydYrC44vkdHSUB/7xKHDlTc6ZvkyrlxjF1BJ0UIlmSFZNhI++ePwH+hpeFyAEbu6vLQEIlQvI3NvNVvQnq/zbDNRHMSTmWvzDqXqyL2BIX6D6JTx/vmX8d+Bsb6gSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Icm/nTLE7WM0LljVbU4iGYBVV7o0LT/PgTM9tV5xYIc=;
 b=L8UZn+snPxCpz20CXew8RZeAabkBUEXatVtmj5Ttw5YycIwIxI7w4aBCSvX120OruEBlJg5hDZ2LMxFR0ArTjRwmVguYzWoreHg7IXyzfi6FzGryRKTvhGgMWKoGOdhHb9TbrJ2RpVsUPHcV/Xyz0nf7Og7rIJITJ8JB5QfmZcCnuN4yBA836wQxqpJChVkpbc/K+hiIzNOG714tsMJA7UpTdG2E3nReiheaLJatJYPVW1sODlq0PVqbRauiqFbqplX3Wac7iWHaKFA4eJntHkiG7Sdw/afGEW4O25QmjWTYE9bcysJGl9nE5WKPokhsR8g/YkVIbxNnKcC7zpYtJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Icm/nTLE7WM0LljVbU4iGYBVV7o0LT/PgTM9tV5xYIc=;
 b=IjsF9ubgHAauezKwTnvg8Au1kXP/nqyaW6+Ixn7MWU0OzsV4+ZHE3y259YGp06LBn5bM1NeWUPSaawvZ51dOYPg3a9KQivCz3RtjFOZTpfe4Au6rzwG/iktKD9kbwXI2A1LriOUsEwJdoPInm0JLteYNXKiheurqKRsbttL+YSA=
Received: from DM6PR18MB2969.namprd18.prod.outlook.com (20.179.52.17) by
 DM6SPR01MB0045.namprd18.prod.outlook.com (20.176.120.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.22; Mon, 17 Feb 2020 14:55:17 +0000
Received: from DM6PR18MB2969.namprd18.prod.outlook.com
 ([fe80::d890:b3b7:629e:352c]) by DM6PR18MB2969.namprd18.prod.outlook.com
 ([fe80::d890:b3b7:629e:352c%6]) with mapi id 15.20.2729.031; Mon, 17 Feb 2020
 14:55:17 +0000
From:   Tomasz Nowicki <tnowicki@marvell.com>
To:     <kvmarm@lists.cs.columbia.edu>,
        <linux-arm-kernel@lists.infradead.org>
CC:     <kvm@vger.kernel.org>, <christoffer.dall@arm.com>,
        <maz@kernel.org>, <james.morse@arm.com>,
        <julien.thierry.kdev@gmail.com>, <gkulkarni@marvell.com>,
        <rrichter@marvell.com>, Tomasz Nowicki <tnowicki@marvell.com>
Subject: [PATCH 0/2] KVM: arm/arm64: Fixes for scheudling htimer of emulated timers
Date:   Mon, 17 Feb 2020 15:54:36 +0100
Message-ID: <20200217145438.23289-1-tnowicki@marvell.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: AM6P192CA0037.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:209:82::14) To DM6PR18MB2969.namprd18.prod.outlook.com
 (2603:10b6:5:170::17)
MIME-Version: 1.0
Received: from localhost.localdomain (83.68.95.66) by AM6P192CA0037.EURP192.PROD.OUTLOOK.COM (2603:10a6:209:82::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2729.22 via Frontend Transport; Mon, 17 Feb 2020 14:55:15 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [83.68.95.66]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 04e52687-9463-476c-06c6-08d7b3b966b6
X-MS-TrafficTypeDiagnostic: DM6SPR01MB0045:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6SPR01MB004550F7C86687D575DB5CFFD2160@DM6SPR01MB0045.namprd18.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 0316567485
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39850400004)(366004)(376002)(346002)(396003)(189003)(199004)(69590400006)(4326008)(5660300002)(36756003)(26005)(4744005)(107886003)(478600001)(2906002)(16526019)(186003)(8936002)(52116002)(2616005)(81156014)(8676002)(81166006)(316002)(6666004)(6486002)(86362001)(956004)(66946007)(6512007)(1076003)(6506007)(66476007)(66556008);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6SPR01MB0045;H:DM6PR18MB2969.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4t615iIS5SXyqr+yOko5ESnzoah7X7Q0EKPk2mx3XFMocAbdRRgYs5z9J4WI2AcwvNb+8Hndyb+UBw5UD2QnHsTVHVz09OHXhgF4QV9X6WGTf6vb+lPIS0gkUdPVaS4kacmoX0SWl9Xsik236YALeQ+XStlXZCDTdk3hXhYBuV/iLxuo4AoBFWmWJHz/7vJxf1C/+9S6qspPhKwVLgsmPm87DLQhYWWRiSMTKaqm0p+Ya9ZLi9oEJliz2ielxhC7T+4isgtrqy2GFfm4VenRJc/5qr75CDsyUWCWNAhSalqF1hSKYVXbPjvO+gLC5rexdilyAQyTo2r4mjUm8le4yQtoSe3aW9RmCRZ4snfcmOtRc9RBBsvQm/vkpdMAmDnImInqlqaGGtp9I0J9SuPD7cBepTVpnaAkDRskBkx4EXHuv8onz8vjGnGtepScabplLq8A0dOgnDupROmelwaItZjA7pQyGYZQklW0t1owtSXE5pu6/RpxuHGNH80hlYPTUBirZq8og2zv0YyLQBeBWHq+kL0ufpQ3g0gN9I0UDg8=
X-MS-Exchange-AntiSpam-MessageData: AxAZvssiNDQ9t8tljH0Kq9nooKPKgUUvX/O8jiW1Rh87JlH5zIFAsqgkSbZidYYFXLUvbax4CNtzOS6S4+L6jSRUd5KvxZ4ST9eGtrg69xggmNplQUf/74x8H5/rRiPA3+luYU2v1qKuOylq5v1Vyw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 04e52687-9463-476c-06c6-08d7b3b966b6
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2020 14:55:17.2270
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gKSdOS1P3gnDf+Famcd/M91iPn6eHAFZEu7WpZFUVxjrqdnMb5ciyO+kMOhSa0L68Sc9Z7epURX/6V3K9+kJWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6SPR01MB0045
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-17_08:2020-02-17,2020-02-17 signatures=0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This small series contains two fixes which were found while testing
Marc's ARM NV patch set, where we are going to have at most 4 timers
and the two are purely emulated.

First patch cancels hrtimer when the timer should fire and there is no
change in irq line level which suppresses timer interrupt storm when
guest enables interrupts.

Second patch makes sure that hrtimer is scheduled when timer irq line
goes down and there is still some time to expire.

Tomasz Nowicki (2):
  KVM: arm/arm64: Fix spurious htimer setup for emulated timer
  KVM: arm/arm64: Fix htimer setup for emulated timer when irq goes down

 virt/kvm/arm/arch_timer.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

-- 
2.17.1

