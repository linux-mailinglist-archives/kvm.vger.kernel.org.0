Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4AF21619C7
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2020 19:35:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728543AbgBQSfx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Feb 2020 13:35:53 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:34836 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727429AbgBQSfx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 17 Feb 2020 13:35:53 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01HIUxDf032516;
        Mon, 17 Feb 2020 10:35:41 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=15xYWZeFBjk4Rhv9AQ469MhHFA+IXhOHiZk+CVfsMco=;
 b=wD6kWsmU8JML0ZVsWw4SdMqzkcMp0aPlphjfPw6QAjVwQX7dCDheQpDEE50i2wx7cNZL
 gVZab/d4cCAe7IYGTX9PprXr1b6wAfF5BSMEVzrMrJneYwkZcS9D4DX6oF6UlCoIHUUn
 ebF4JDZNX7ysG2ZnUa3/TbpjAADZEvEQeXoI1/9UUFvCKNp3qzspZ+5fBGHGpNIiz51b
 +sZPo/1+Y+nELK/w1c1/W7VdxUDTuF4pGmUmRLcWqRFuJaLeu73F87QVa6MfITZaHpPj
 ZwoeQSEx1pBYaudFepmlsKfJ387QpWVQsQBlyxv9Y1GcbII/eyIa5Ygv4coyX47pvFnX Og== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 2y6h1t00ku-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 17 Feb 2020 10:35:41 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 17 Feb
 2020 10:35:39 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.171)
 by SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Mon, 17 Feb 2020 10:35:39 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aOSqU/qtpgi3rVRd5ljSpEkiwNmzFCWbiFCvKKqoSsv0hFgYb1RLPGWEU5XDeLE1erAxuH+w6eZnDEcsQBHU/OHBUzX6LrNv5Z7AsRfgh6MudtcjRRqmOBo6oO7X4z1eJBKsG/OSKeIZksk2n4QKiL8EMnofT9vzZyCn6AmpN+qMXLGLIWljJNoUEk3bWfWZ7QweUbGJxIWUxO2GpQ7yO1Pyh/ONiqpFy2xxsfGQ506A5ahGmszKwNsauEFYj6jwuWaPQby/CbGirtCdjx5JZbvXCyi1hLb88NoCISSIOnU1mMnpQfD3gAFdiX7Co1YZXli7vXdn2VOz5ppLYe/Tbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=15xYWZeFBjk4Rhv9AQ469MhHFA+IXhOHiZk+CVfsMco=;
 b=l06X9+LEqR6FNiHWWpQWVqKZyeTYDzHYFjmoT1d3AnxYhp6BRmWLK6DF3fv7qBBbUUp8LSRwgvjuclYngRzxm+k5DHJSO+XnRJLTdjDYhFrE+nvY46nyy7QxQ2eCCdvxUwWLFzOBbPi9CfOTLzaDhDUrrpPS3DEIvwhiRY3RFcGZYVKha5x7mb5prxY1rqMpmTnOxdF6L3JbQTumwVCZZrsdeXzEsBVZSUSQLBccUQtTOmTqRgHX+xO2L7HBAfFWV71lGNJb/VWdVz+vm1pjzqBE7lAWZL2MJbZ/q5CGFJZfk8jyokcSKWKKUUdaC6CHH/KT1+t31rcdPxd44v7VdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=15xYWZeFBjk4Rhv9AQ469MhHFA+IXhOHiZk+CVfsMco=;
 b=L/dMGdFL8zlJp19OwPG3PaEZFPsHpDaFuUYLDFk50cy9ywxa366WvqZkOvnTqGdlyOuZdDH3VTbwyMAA1V1ss+ozWLwUcZfZ2bTs8htRtLpIaxwIniLNuHU566/GKIfBOiI9BeI86GyxEWEi8aof9G3zHmFGt+CZVuozAFPcIJ4=
Received: from DM6PR18MB2969.namprd18.prod.outlook.com (20.179.52.17) by
 DM6PR18MB2377.namprd18.prod.outlook.com (20.179.107.85) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.23; Mon, 17 Feb 2020 18:35:37 +0000
Received: from DM6PR18MB2969.namprd18.prod.outlook.com
 ([fe80::d890:b3b7:629e:352c]) by DM6PR18MB2969.namprd18.prod.outlook.com
 ([fe80::d890:b3b7:629e:352c%6]) with mapi id 15.20.2729.031; Mon, 17 Feb 2020
 18:35:37 +0000
Subject: Re: Re: [PATCH 0/2] KVM: arm/arm64: Fixes for scheudling htimer of
 emulated timers
To:     Marc Zyngier <maz@kernel.org>
CC:     <kvmarm@lists.cs.columbia.edu>,
        <linux-arm-kernel@lists.infradead.org>, <kvm@vger.kernel.org>,
        <christoffer.dall@arm.com>, <james.morse@arm.com>,
        <julien.thierry.kdev@gmail.com>, <gkulkarni@marvell.com>,
        <rrichter@marvell.com>
References: <20200217145438.23289-1-tnowicki@marvell.com>
 <f70d41fd006319e3d62224c410d62e20@kernel.org>
From:   Tomasz Nowicki <tnowicki@marvell.com>
Message-ID: <0753e1a3-3b5e-3e55-d684-3ec3f9033f4e@marvell.com>
Date:   Mon, 17 Feb 2020 19:35:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
In-Reply-To: <f70d41fd006319e3d62224c410d62e20@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR07CA0026.namprd07.prod.outlook.com
 (2603:10b6:208:1a0::36) To DM6PR18MB2969.namprd18.prod.outlook.com
 (2603:10b6:5:170::17)
MIME-Version: 1.0
Received: from [10.11.201.210] (108.20.23.69) by MN2PR07CA0026.namprd07.prod.outlook.com (2603:10b6:208:1a0::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2729.22 via Frontend Transport; Mon, 17 Feb 2020 18:35:34 +0000
X-Originating-IP: [108.20.23.69]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c9dc87d2-f725-4692-45fc-08d7b3d82e56
X-MS-TrafficTypeDiagnostic: DM6PR18MB2377:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR18MB2377F724D350CE986A0B2082D2160@DM6PR18MB2377.namprd18.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-Forefront-PRVS: 0316567485
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(39860400002)(376002)(366004)(396003)(136003)(189003)(199004)(478600001)(6666004)(52116002)(31696002)(86362001)(16526019)(956004)(2616005)(5660300002)(186003)(26005)(316002)(4326008)(81166006)(107886003)(2906002)(66946007)(16576012)(66476007)(66556008)(31686004)(4744005)(36756003)(8676002)(6486002)(8936002)(53546011)(81156014)(6916009);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR18MB2377;H:DM6PR18MB2969.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bIlidpwKcpsb9AfGQZ+W4XYjbNk++g8wQVxqv+Utpa2hZ396kkNdFjZf7EFD45ZQcZbTZ4cgspbpNB2S4/8ExXEVo6i+YWxV0AL18jML0EXOVPmH5tOT4bum5x+wGjxMXm2GgcMokXzVObssz0SzkP5rxyPzMOW6niEZyh6RKM8eSL6hHRh+a+M7Pld5uGikplAkZB6TMO2XIwlpSazy7acnkxhyy1xXM2XMYtWsLc/w960QCWKnQ5TM41N7fv7RdaQmlZOtEeA5ugTKDNY2GJEEWhJKRx1M1PhyboFfDIJDrVJxJR/1OXh6lmkP7nTktevPQhpNY5BgqhCvAW/W4kvxr69ZvesfRz//Y2EGUsz/hQ7dIrURcrBmGnXZARZ6Izcr9mcClbzQCA90XtAoT4h0CVyrLkBAAglbVx+SOEHFKUmgvFx1iYLmoanwEHOn
X-MS-Exchange-AntiSpam-MessageData: zKq46SFJ9Q7jAW/yojX5Nj02UXaROsxvwpQCRHQbc+vJraKkidWHfoO6Z/lkiBeSebedWWc9wgaGqwlzNH++aopPXn/NN0nKrNOH3aYN7JKW3hedtM9+y0COn0zjJlVPXK2uCA5OABtQqwbfrdDdpA==
X-MS-Exchange-CrossTenant-Network-Message-Id: c9dc87d2-f725-4692-45fc-08d7b3d82e56
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2020 18:35:36.9817
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Dt3mp4Kkwzcly+ACG7Nu7AXiocaxSmaRzinM+qM5MRS0YlIwamTYfOdqLhc1ESggn4UZCMeVrKQdup1ccIA4WA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR18MB2377
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-17_12:2020-02-17,2020-02-17 signatures=0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17.02.2020 19:00, Marc Zyngier wrote:
> ----------------------------------------------------------------------
> On 2020-02-17 14:54, Tomasz Nowicki wrote:
>> This small series contains two fixes which were found while testing
>> Marc's ARM NV patch set, where we are going to have at most 4 timers
>> and the two are purely emulated.
> 
> What are these patches fixing? the NV series? or mainline?
> 

Both, but found when testing NV.

Tomasz
