Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5732BD2751
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2019 12:40:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727330AbfJJKj5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Oct 2019 06:39:57 -0400
Received: from mail-he1eur04hn2042.outbound.protection.outlook.com ([52.101.137.42]:15818
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726201AbfJJKj5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Oct 2019 06:39:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hBtPKlnWTVUPK177pYFOm6gjmGqzw8ufbZt+LInMYycWzeYdX6HQtI5ZrOACS6dg+nhpbfxRmeYha8M+VEWCk6eLIBvbGoXA8WLHIqWhu7vCdyCcuYHOpxTKy2GtSX/Gmp5X/l63OVfIoj1CoVmYkd+MJC0+eUqzAQXnjUlVwoTOhJd5gAth5cJOleSs+lSiVuMrRzV9dwLhRo3gzFnQRChCnUMRFkaJN+XdvC3XwChGn5rx5drai5MpNR2ZwwGO5iuSaJBRotk1qa0RF/F6WjiwH4W9rXnUAVilGpBNxkSuG9IQyFj9UB2r8TndQayxz5szhRbp0OncdWJY/ks50Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B6eBVNXImVRJ+Zn4ZBwLcdGsAa2x61fQwWnkjI78fng=;
 b=dD0DHVloyGqwpZORVeJJIXgqkydU1MEueNs7ffFzCkNDkzIDLkseL6uNOv9ADVPhjus0VVaFZ958Ql37j7+wffmdLiNVIBbJpHLO8Mlme815wqNTEFPkCSUWF0krm8iusL3lYfb11umDzdjhh7HpZPN/0mCLfn/fuGnno61CJ5h65ghh25uv//pX9N3WRpQZkKgHxLsd3prPkbSHZYX+RtcgiQ1yIE8cJmzLsWPW+wdKIW7KEmx6oaQNxbgF8gL37AmlTSJ2sXrZ+Wq8VjQO1N6MqmD7Mwek/o6oxSxvlkzs//yDQYYL0ajcbxlUvitSVgkeU/BmNXVt0FAva17Z3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B6eBVNXImVRJ+Zn4ZBwLcdGsAa2x61fQwWnkjI78fng=;
 b=dNzU6hrjPTJp7FadkEiADpDpWub5lY7VSZJj0QUCWMFRcK+0dzQO7bCQfMDIMvMbJ0ugPZdafNKMI+phC0+kU8EU+LrjSRLAW73pItuPiVRHaoDIf/C4NXTV6OiGKR2qYnGMcb3x9x8BlgnVTH9IIcSywOQNKx6aiOWFpO8asDo=
Received: from AM0PR08MB5537.eurprd08.prod.outlook.com (20.179.36.87) by
 AM0PR08MB3588.eurprd08.prod.outlook.com (20.177.43.159) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Thu, 10 Oct 2019 10:39:43 +0000
Received: from AM0PR08MB5537.eurprd08.prod.outlook.com
 ([fe80::a8ea:5223:db78:dd3]) by AM0PR08MB5537.eurprd08.prod.outlook.com
 ([fe80::a8ea:5223:db78:dd3%7]) with mapi id 15.20.2347.016; Thu, 10 Oct 2019
 10:39:43 +0000
From:   Roman Kagan <rkagan@virtuozzo.com>
To:     Suleiman Souhlal <suleiman@google.com>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>,
        "sboyd@kernel.org" <sboyd@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "ssouhlal@freebsd.org" <ssouhlal@freebsd.org>,
        "tfiga@chromium.org" <tfiga@chromium.org>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>
Subject: Re: [RFC v2 0/2] kvm: Use host timekeeping in guest.
Thread-Topic: [RFC v2 0/2] kvm: Use host timekeeping in guest.
Thread-Index: AQHVfz3XFkTdoUspUUGNpMNFnoCXM6dTr42A
Date:   Thu, 10 Oct 2019 10:39:42 +0000
Message-ID: <20191010103939.GA12088@rkaganb.sw.ru>
References: <20191010073055.183635-1-suleiman@google.com>
In-Reply-To: <20191010073055.183635-1-suleiman@google.com>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mutt/1.12.1 (2019-06-15)
mail-followup-to: Roman Kagan <rkagan@virtuozzo.com>,   Suleiman Souhlal
 <suleiman@google.com>, pbonzini@redhat.com,    rkrcmar@redhat.com,
 tglx@linutronix.de, john.stultz@linaro.org,    sboyd@kernel.org,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org,     ssouhlal@freebsd.org,
 tfiga@chromium.org, vkuznets@redhat.com
x-originating-ip: [185.231.240.5]
x-clientproxiedby: HE1PR02CA0089.eurprd02.prod.outlook.com
 (2603:10a6:7:29::18) To AM0PR08MB5537.eurprd08.prod.outlook.com
 (2603:10a6:208:148::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=rkagan@virtuozzo.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bc42a1a9-cec7-4eb4-8343-08d74d6e290e
x-ms-traffictypediagnostic: AM0PR08MB3588:|AM0PR08MB3588:|AM0PR08MB3588:
x-microsoft-antispam-prvs: <AM0PR08MB35887AAA3B1EDE7C904996C8C9940@AM0PR08MB3588.eurprd08.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 018632C080
x-forefront-antispam-report: SFV:SPM;SFS:(10019020)(39850400004)(136003)(346002)(376002)(396003)(366004)(199004)(189003)(14454004)(7736002)(71190400001)(6116002)(3846002)(6512007)(9686003)(305945005)(71200400001)(4326008)(1076003)(478600001)(7416002)(256004)(8936002)(8676002)(54906003)(316002)(58126008)(2906002)(81156014)(14444005)(81166006)(6916009)(33656002)(446003)(11346002)(76176011)(26005)(52116002)(86362001)(186003)(102836004)(25786009)(66066001)(476003)(386003)(6506007)(99286004)(486006)(6436002)(66446008)(64756008)(66556008)(66476007)(66946007)(229853002)(5660300002)(36756003)(6246003)(6486002)(30126002);DIR:OUT;SFP:1501;SCL:5;SRVR:AM0PR08MB3588;H:AM0PR08MB5537.eurprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: virtuozzo.com does not designate
 permitted sender hosts)
x-ms-exchange-transport-forked: True
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Nrjblv7FVESy1nM0szf/Mz+f/Fa0htb7VW0DcbSyTlrASSE8G2g4kA6p1bTYNbx40D4u/9DBbMraOarfTfX7IYpjEdQUPr2/A/KvWRHZj7k5BhpFVqXlPgre2/0ghvrpzM1IEbirLSZYEEKdMrTwsuMVadCZzPTHOkw7IP/j/f7l8daTwr/MWfU46W5IhiGup026CRJMrhtv3UkF+XRtG+b15tH0rldoqW5TluDQclXEXEuwxreDxm/qn9qBB6sBHncCoVRPNhcAgOXU53Ek/tN0zR3OZUvr8DzknvoLddMD8R8ZSvP+0AWB905DRff9bXMHGcw/ACxisnd8sz6dVaLj4srXGN+7ErZxWKEhudz0WgEtYEZZxgdjkLuA/P4P55uWYOVpMnGaTi7dUzq7hP+0vMEcm96FUTlGMQJ79PnxHz0MiOG9RKCGGXfY68oYKKuXtcq8aW+TfndEFlVbGZhvCUd9rSMYT6s/Kl8xyldpwcpVL0p44c3l0Dp5wyKF
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A759E52CEAD51B4D92FA891FBABF161B@eurprd08.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc42a1a9-cec7-4eb4-8343-08d74d6e290e
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Oct 2019 10:39:42.8311
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zr6LULSiXO5e7tNpsAJlbR5LJ5mWMD9JJCOtIURDmw0H7uJVHZhBR5UtMp76FIpcHbLHFN/y3BQ/ebXK5mY7xQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB3588
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 10, 2019 at 04:30:53PM +0900, Suleiman Souhlal wrote:
> This RFC is to try to solve the following problem:
> 
> We have some applications that are currently running in their
> own namespace, that still talk to other processes on the
> machine, using IPC, and expect to run on the same machine.
> 
> We want to move them into a virtual machine, for the usual
> benefits of virtualization.
> 
> However, some of these programs use CLOCK_MONOTONIC and
> CLOCK_BOOTTIME timestamps, as part of their protocol, when talking
> to the host.
> 
> Generally speaking, we have multiple event sources, for example
> sensors, input devices, display controller vsync, etc and we would
> like to rely on them in the guest for various scenarios.
> 
> As a specific example, we are trying to run some wayland clients
> (in the guest) who talk to the server (in the host), and the server
> gives input events based on host time. Additionally, there are also
> vsync events that the clients use for timing their rendering.
> 
> Another use case we have are timestamps from IIO sensors and cameras.
> There are applications that need to determine how the timestamps
> relate to the current time and the only way to get current time is
> clock_gettime(), which would return a value from a different time
> domain than the timestamps.
> 
> In this case, it is not feasible to change these programs, due to
> the number of the places we would have to change.
> 
> We spent some time thinking about this, and the best solution we
> could come up with was the following:
> 
> Make the guest kernel return the same CLOCK_MONOTONIC and
> CLOCK_GETTIME timestamps as the host.
> 
> To do that, I am changing kvmclock to request to the host to copy
> its timekeeping parameters (mult, base, cycle_last, etc), so that
> the guest timekeeper can use the same values, so that time can
> be synchronized between the guest and the host.

I wonder how feasible it is to map the host's vdso into the guest and
thus make the guest use the *same* (as opposed to "synchronized") clock
as the host's userspace?  Another benefit is that it's essentially an
ABI so is not changed as liberally as internal structures like
timekeeper, etc.  There is probably certain complication in handling the
syscall fallback in the vdso when used in the guest kernel, though.

You'll also need to ensure neither tsc scaling and nor offsetting is
applied to the VM once this clock is enabled.

Roman.
