Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A98432DDE2
	for <lists+kvm@lfdr.de>; Fri,  5 Mar 2021 00:32:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231483AbhCDXci (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Mar 2021 18:32:38 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:6528 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbhCDXch (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Mar 2021 18:32:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1614900965; x=1646436965;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=RusSpL0HJeNvqdaTfGwlPi7UHcI37pnMO1x1BqU8gdA=;
  b=AKXaImyiAgGnKoFtPwqR3MjkQinj41GdnKUKc1JuPbZoqX8nrlg1ZymG
   RyrpurPKAgYcOjRopjRHFFDa9Z8E+saBWwEDSZbiX0LN5F44CX2NA3mGi
   PNOhCu6v0/aug2cuo+AjKnHJBWj42aGBCmcD1WLMTaQGteNPSwqGZuvIE
   aauwbkVvlRM5dRgKyrcx4SvU6EEmVqKL/WKAWuy9nPzQ02E/5DStHbiPK
   3VIckNYJ1nMhgi1cMLVOyVC2TKvJHfowBsdIPjl00QgzEubRYnhdJmx6i
   2Y5X2qLXelp31qmLEU+6rj6mFmPdXR3mORr5I2TUq2v1K7VwG3+4jvzX4
   g==;
IronPort-SDR: RahzdLlOpqmx7HPJr5S9KSX9NVhBlUg5j2Wby7XVoU9RsTUrWqahQYT2XdlUzGglkQ0cASW7VE
 +7EbPNuAzcGXy67cHlt0e8E9SKEVuZ4DVZVE5cBjxQCij4LtA30qUv6EWiOgQ6h1C5g1+qk32Q
 6JKJjTzqSKZyh5D7dmYpx7qqckScFm8yB8DqHJDfFRDqR7gojWkKL9/2odDhFZU3gF7iDNSQNY
 ldXV/j4t/IvxDhaCApQkkwvGDJ7Dq4n0RumyeNsBFnCqm1cyn+naKwijw/APPRlyhKLPfcLQM7
 Wdo=
X-IronPort-AV: E=Sophos;i="5.81,223,1610380800"; 
   d="scan'208";a="265705344"
Received: from mail-sn1nam04lp2059.outbound.protection.outlook.com (HELO NAM04-SN1-obe.outbound.protection.outlook.com) ([104.47.44.59])
  by ob1.hgst.iphmx.com with ESMTP; 05 Mar 2021 07:36:03 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MifstauLvAXN/z0nChtaqfdd2PCJl0kd2Wpoumqt+ikRkerbK+xERTytT8gxP198T7TYqCl37RQtvUNrHYf8GcIOvZ7K7qh4VbQ9cT/HRyH7aKgjd1DEKlLNYXObZ6qkPZQsFW8nOORNHubTVwIuNYcohaw5/3qAhLspSTD8q4brNbfDhLFTuO1Vr+KRdFwe32Hw3fUGxJaLLg3AC50peH+NyJCebsgIt/z0PBxpZ7WylV2PJY6naqHgCpBDtAsOaBSybLf5NjrHZlGxnuAa8nF7xjnZSpUJQs4MDKNAM/0VgPMRlQQLnlzfo1vr8cQXnVjvVOUohuX81k8XjFexMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ClJjtAXGvzQQndqwrzntsiEMgBL/5Jeg8yPzdL8aCow=;
 b=LZZa+koe2rwzuaYci2DkVLBjTdPlMqQa7UoypWhjFwTgNSbhbMSPGQBNBUF85uBbbzhygWjCCfTkzpVE1KM1XwFmMl1ORscSrJqH1Eko4VuCqkiiKofBDk/rQSkriE8OkLwjO2aWwYB/Q0KP9nfjVqmQlPUKPWtyqhkbjRKnyZxw4LL5AVPmbVjkk4GrIG68WYO95OcqKFy3Hj/GCiafbbX+9ljvIOj9upFvv+ru0L8nr+AEYBkbLDsrVrpzanVV6tvJMx8YdVoEK+q2eOddDPTQxGNE66NFkV4DT72U8GvNBo7bf8xa3swkYYEjskzl90maZe5Up3eKwktiCPrptQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ClJjtAXGvzQQndqwrzntsiEMgBL/5Jeg8yPzdL8aCow=;
 b=cK7nd/Lt+JIFs381g6lLQSFKRAQcQPVlONW42Zv9TmF4qrQk1LkdQhtXiiPrIdY7lXaLB8M2e36uzNHRUPR2k3VMmOtbX+xaYDZHfDdjqBxixU5B6b/4EFf6+mDAXAqOoocakqicLZHOt1NcJs6WIUX2XTlPJlinAaka6PWVBIk=
Received: from BYAPR04MB4965.namprd04.prod.outlook.com (2603:10b6:a03:4d::25)
 by SJ0PR04MB7680.namprd04.prod.outlook.com (2603:10b6:a03:324::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.20; Thu, 4 Mar
 2021 23:32:35 +0000
Received: from BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::c897:a1f8:197a:706b]) by BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::c897:a1f8:197a:706b%5]) with mapi id 15.20.3890.031; Thu, 4 Mar 2021
 23:32:35 +0000
From:   Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To:     Dave Chinner <david@fromorbit.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
Subject: Re: Problem With XFS + KVM
Thread-Topic: Problem With XFS + KVM
Thread-Index: AQHXEUaJ81+kylbMeUuYIeYf5OnWpA==
Date:   Thu, 4 Mar 2021 23:32:35 +0000
Message-ID: <BYAPR04MB49657CB2E5F0C2F2FC4F24E686979@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <BYAPR04MB4965AAAB580D73E3B03E7E7886979@BYAPR04MB4965.namprd04.prod.outlook.com>
 <20210304231359.GT4662@dread.disaster.area>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: fromorbit.com; dkim=none (message not signed)
 header.d=none;fromorbit.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 3321c2a1-cb07-41b4-b65a-08d8df65ca6c
x-ms-traffictypediagnostic: SJ0PR04MB7680:
x-microsoft-antispam-prvs: <SJ0PR04MB76808B7DB737984C05B9D83D86979@SJ0PR04MB7680.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Or5UIp5Z+nMSkNL4Xk+m0BXUQ/sh5B/YChQG+oTsdAz6oQRj+SX4BJm1PV1OgeY4ilhx6m1e4XYqUOcUoD59GMMHdWqT6A3yUxrBypcdLBvndEaIW0MEFdkH9OkN5W3F2LMq3huNPekXhlz5cho7ODe8BN/W4A/RKGLkIdu2U0NtCPSR8muucIcjBAad4i0yohpHIeSA9QYVLL5YodztJ4Sj8yI4MpIu4F6pIThgtfjL4qqxqqRZkkEC31EXqM13ieNp+Jgp4hEZIWYq4iooCJPJ3bInvQaJGPyNYnvG3zku9VGfTOeA4GckiMO1wKdbZBT5QVPaccp/doXDLQ2utEN/p8fLcBg9fsNnvzCQ8BzTG7pF+FGTR5zQBBwJv7Ex9DUDNBB8qcMgC/pOuPrSdElTbkhXi+uOtsyG9meeA8pzDWETyEg02KUWUUa/yoGyjbwS6IPGO0v+kpn3CS+ZuOb+BeTce386DpkltW2CXjQWhGdI3zMt7suuzWlRaf6TlHwMQf1/4gFgckM8C0jwDw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR04MB4965.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(39860400002)(136003)(376002)(346002)(316002)(186003)(6916009)(54906003)(26005)(55016002)(8676002)(4326008)(53546011)(8936002)(478600001)(6506007)(5660300002)(7696005)(33656002)(64756008)(66556008)(66446008)(52536014)(76116006)(66946007)(86362001)(66476007)(71200400001)(9686003)(2906002)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?S+UCMmDwXK1sJrmzKHSaCr0fBh8e83Un6/iAKRHkPqY5fk2oXlfbNZzbugc+?=
 =?us-ascii?Q?527kaQnO0lNQPVrJ6CRSqhNpt3tlPabfw6DIFhNXl+Jl4zsI+mAxe23cEaLD?=
 =?us-ascii?Q?0fHdQWC7Al25L2vXe3z90t1mFdw4b4JBqnCl8GbERj4XJK4hTrUTA/SEIeQj?=
 =?us-ascii?Q?A2krfoXvyGTkhflcnBzkMFD+vq9Mz7OR7mVcmF69UtO+EOyD+7NpBNROF3mF?=
 =?us-ascii?Q?HvKUU2LmdlmNHXQL+Ccdnx1EmdJI+vx5f81ai7LVbGYdpJA2k3xBTFiTS4CG?=
 =?us-ascii?Q?86NzWXN5i3l8vJmOfUYBOcD3+R0FxdQT+EU9Hxf+nUffVFa50FeW4jO5c4yj?=
 =?us-ascii?Q?HWlH8XYap9nfcRUon6FCoGEj9jbT8zugZrxB47w2MedXOymyxhsvRYxaKiaO?=
 =?us-ascii?Q?dVRS9zdk1mfX7/6T7b2ZJtRIL7N8EyUkqkaEhzAhh6U7zGJRdq6aZ2tiGRCS?=
 =?us-ascii?Q?XfZV4BJcCB+Zsx1gH4CHO1vod2yBHQHrfoWwkDbmfMzyenzhstsnUTatNugF?=
 =?us-ascii?Q?0HcWfH2jIXtKY+qf5DVThhM+8VhZK6OMxB4r5SN938vG/TJaSngf5CkFHDMY?=
 =?us-ascii?Q?rOZy6OOMZGgkorRecVPH1jreP2MKsuux3/bctNVZcMupEYwwfTvQDqejeih6?=
 =?us-ascii?Q?s6BI6UdZMpghNyhoeeDYuiP/ALPXyM5AQ5PhoNqAUR/GyXlgr9UvYdh1lzXw?=
 =?us-ascii?Q?Pwv+P+E9/zKwhWB77C600yeujh3PvHR9osMNd5rbN8Zddf870aMasLRXqwes?=
 =?us-ascii?Q?KAQb7wlG48XO46xjBzrVxQrGXULchT7kgW5uyVaSE8nk4N3b09cse7c7uIXK?=
 =?us-ascii?Q?FOulXe/auUs78SKY30KMjprCGE13aN6BAuY4pc6A1t2LpsYD4X7eCi6MV2ru?=
 =?us-ascii?Q?Pn465ytfQUYhnX/OgpqdVMmLiviug+syHCCaI33d8Y/dv9TBAnRMkZgyWxBn?=
 =?us-ascii?Q?2H9XA56CJ3fu0x+0jVJKE3qRRsG/XeymK645Xr6XRAgzAZYFFOYJM4aGWPjJ?=
 =?us-ascii?Q?YmZ15inrYjjpQscHDwLAEKtP0IxAV7VJka8Cgu8egn+sFY11PtNtsLpiuYPa?=
 =?us-ascii?Q?54Ti7Oa9ehT8njmJ0z//4TRzU1WC4TxFihrbTB7vUcJfGi7u2TIJhQ5DRGQi?=
 =?us-ascii?Q?GnzndeqhMY/K/VrhYJoP9/iYVw/tdMSiSpngZAL1/VnOETnD8QkhuAB8S8Da?=
 =?us-ascii?Q?BfIbarQ5QFfXMfLl9Ub1smjA9GGC1AC6FUOzc+DjAGZLY4KTRAlpMjhlg9CG?=
 =?us-ascii?Q?p/IyB1+D5RUsBgTj46346xv2vegrm9iMUaBjDj6rs+G58YUjODVBvDopma92?=
 =?us-ascii?Q?iyAcPRo1ZgwIQRHA8ypWTG9W?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB4965.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3321c2a1-cb07-41b4-b65a-08d8df65ca6c
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Mar 2021 23:32:35.2219
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4x5HrBbtAifNV8U2m7NOiDmiMZeNrYV8+IyvUS0RD79pyj95ovJ8yyFl/WnsgeZqIyDnaGGu+HiGxt6uFVcEhRQjDfqHee9auWj8zx96svI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7680
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/4/21 15:14, Dave Chinner wrote:=0A=
>> 00000000003506e0=0A=
>> [  587.766864] Call Trace:=0A=
>> [  587.766867]  kvm_wait+0x8c/0x90=0A=
>> [  587.766876]  __pv_queued_spin_lock_slowpath+0x265/0x2a0=0A=
>> [  587.766893]  do_raw_spin_lock+0xb1/0xc0=0A=
>> [  587.766898]  _raw_spin_lock+0x61/0x70=0A=
>> [  587.766904]  xfs_extent_busy_trim+0x2f/0x200 [xfs]=0A=
> That looks like a KVM or local_irq_save()/local_irq_restore problem.=0A=
> kvm_wait() does:=0A=
>=0A=
> static void kvm_wait(u8 *ptr, u8 val)=0A=
> {=0A=
>         unsigned long flags;=0A=
>=0A=
>         if (in_nmi())=0A=
>                 return;=0A=
>=0A=
>         local_irq_save(flags);=0A=
>=0A=
>         if (READ_ONCE(*ptr) !=3D val)=0A=
>                 goto out;=0A=
>=0A=
>         /*=0A=
>          * halt until it's our turn and kicked. Note that we do safe halt=
=0A=
>          * for irq enabled case to avoid hang when lock info is overwritt=
en=0A=
>          * in irq spinlock slowpath and no spurious interrupt occur to sa=
ve us.=0A=
>          */=0A=
>         if (arch_irqs_disabled_flags(flags))=0A=
>                 halt();=0A=
>         else=0A=
>                 safe_halt();=0A=
>=0A=
> out:=0A=
>         local_irq_restore(flags);=0A=
> }=0A=
>=0A=
> And the warning is coming from the local_irq_restore() call=0A=
> indicating that interrupts are not disabled when they should be.=0A=
> The interrupt state is being modified entirely within the kvm_wait()=0A=
> code here, so none of the high level XFS code has any influence on=0A=
> behaviour here.=0A=
>=0A=
> Cheers,=0A=
>=0A=
> Dave.=0A=
> -- Dave Chinner david@fromorbit.com=0A=
=0A=
Thanks a lot for the response Dave, that is what I thought, just wasn't=0A=
sure.=0A=
=0A=
=0A=
