Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE1C4C2FE4
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2019 11:19:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387473AbfJAJTM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Oct 2019 05:19:12 -0400
Received: from mail-eopbgr40113.outbound.protection.outlook.com ([40.107.4.113]:65251
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1733143AbfJAJTL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Oct 2019 05:19:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ke33iLvuMwEPjt0QOdG6jS9hmVZcHRE8XqqL+PsFcuxmEl29xWxr418XZ8KyyXUq2ZSDF7D+BoW0IzyniSHB+/h8GIrshLkvxo8G//qcLDoVrx2z+IiMJRc4DjAg6KVCnquwPyAeXUqdP4hW7k8Anu3CGKWTEtPEWLhBKxEmM6ZbsxbpD35wGq5w5/gAZnTLv8k7WSTl3sVqhZawa6hU9OSXLjg1e2tCpR4KeDOCh6X47hDT6LPJTFi5ahpZkESdAiXdHtSRNPqqe+P3PT1rCAv/ablS3BfJESUAp0v+BXy0UFTvgeeCfPgHY0E41Uz58/RtHl8KrgE2q+1gKzIKKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/8kKwTjtLAIXqK4FeTuwP1FcX35asSchINtnd8Attyg=;
 b=WOH2VRuJwKBixqAcazFwhV5NfWHXV16xqQsteOaRtkGdU7kfEP5gSVyJ5aDYBzXaM5jQKUY7qrhcvqjdDv+Gde9x97IGcsc/qYci+jTJPblAmgJryvKF5t9ZQvhvIjyjrpS/8OgUssG3cfnTJiqzNCpIG2BDZJhem0SBhxXiyKTW6tI0UeQnZXKMnpewLsiF6q+OjiapoZo9aDQH+raAZCGVI352HsVETRcMoOSc3xgkla7lCkSyoUfdJfblFo5dTCnK0JWsyVdBeGDqye8I/IME7vftU9d7YUrBEguzQBcUGXTJcnoDxhx3zglzZp7Vk22egBMHbgzvlnNxqhGFxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/8kKwTjtLAIXqK4FeTuwP1FcX35asSchINtnd8Attyg=;
 b=SK0uK5FpYQ2RV0Wo76VTYk7S0WxF19t0C6UkW3OCdL0U2YhAyXsAnfmfOb1FYBN5v2AgpZMDpzQjtWyi6F976ze20S+4iWU9cSUmTSDBCLV1bgQEt8jdsdP5kM7mmwrMzC23CC/nPMpOjRcyGbid0UPeo6z7ujatHxYLw47ITkU=
Received: from AM0PR08MB5537.eurprd08.prod.outlook.com (20.179.36.87) by
 AM0PR08MB3619.eurprd08.prod.outlook.com (20.177.111.28) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.20; Tue, 1 Oct 2019 09:18:24 +0000
Received: from AM0PR08MB5537.eurprd08.prod.outlook.com
 ([fe80::a8ea:5223:db78:dd3]) by AM0PR08MB5537.eurprd08.prod.outlook.com
 ([fe80::a8ea:5223:db78:dd3%7]) with mapi id 15.20.2305.022; Tue, 1 Oct 2019
 09:18:23 +0000
From:   Roman Kagan <rkagan@virtuozzo.com>
To:     kbuild test robot <lkp@intel.com>
CC:     "kbuild-all@01.org" <kbuild-all@01.org>,
        Michael Kelley <mikelley@microsoft.com>,
        Lan Tianyu <Tianyu.Lan@microsoft.com>,
        Joerg Roedel <jroedel@suse.de>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Sasha Levin <sashal@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH] x86/hyperv: make vapic support x2apic mode
Thread-Topic: [PATCH] x86/hyperv: make vapic support x2apic mode
Thread-Index: AQHVd7Uz7GLeEx2RZ0ukSyO6D+H5XadE0bkAgACxMIA=
Date:   Tue, 1 Oct 2019 09:18:23 +0000
Message-ID: <20191001091819.GA17478@rkaganb>
References: <20190930173332.13655-1-rkagan@virtuozzo.com>
 <201910010607.cwCYMTaB%lkp@intel.com>
In-Reply-To: <201910010607.cwCYMTaB%lkp@intel.com>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mutt/1.12.1 (2019-06-15)
mail-followup-to: Roman Kagan <rkagan@virtuozzo.com>,   kbuild test robot
 <lkp@intel.com>, kbuild-all@01.org,    Michael Kelley <mikelley@microsoft.com>,
        Lan Tianyu <Tianyu.Lan@microsoft.com>,  Joerg Roedel <jroedel@suse.de>, "K. Y.
 Srinivasan" <kys@microsoft.com>,       Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,     Sasha Levin <sashal@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,   Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>,        "H. Peter Anvin" <hpa@zytor.com>,
 "x86@kernel.org" <x86@kernel.org>,     "linux-hyperv@vger.kernel.org"
 <linux-hyperv@vger.kernel.org>,        "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>,        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
x-originating-ip: [2001:6d0:8000:101:c73c:70a0:1973:64c2]
x-clientproxiedby: AM4PR0101CA0055.eurprd01.prod.exchangelabs.com
 (2603:10a6:200:41::23) To AM0PR08MB5537.eurprd08.prod.outlook.com
 (2603:10a6:208:148::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=rkagan@virtuozzo.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c5b6840b-1513-4987-2a03-08d746504f06
x-ms-traffictypediagnostic: AM0PR08MB3619:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <AM0PR08MB36198E2888EB25AB9626D00AC99D0@AM0PR08MB3619.eurprd08.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2733;
x-forefront-prvs: 0177904E6B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(7916004)(39850400004)(366004)(396003)(136003)(346002)(376002)(189003)(199004)(4326008)(46003)(66476007)(478600001)(6486002)(66446008)(64756008)(7416002)(6506007)(6246003)(9686003)(966005)(6306002)(99286004)(66946007)(58126008)(81156014)(81166006)(33716001)(5024004)(316002)(6512007)(25786009)(54906003)(86362001)(229853002)(386003)(446003)(256004)(11346002)(66556008)(8676002)(7736002)(186003)(6116002)(2906002)(5660300002)(476003)(486006)(33656002)(8936002)(6916009)(71200400001)(52116002)(76176011)(6436002)(71190400001)(102836004)(1076003)(14454004)(305945005);DIR:OUT;SFP:1102;SCL:1;SRVR:AM0PR08MB3619;H:AM0PR08MB5537.eurprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: virtuozzo.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RsX0ePaNL8NM3LARaZBpaCGQJ8CMY9EIzM1gbooye86Zo7HD2hdVmSj2fa7K65GGUqSOnAXD438WIAerz8qk/N33+HUSlqhPUYSgNMiz8o5vxA/mA496DhX80t5O9hPWmjbZuf1C8skgE+wjywJ2hbIGg14nZfWbevFhJeiK3fYTdqCiaSMGl2JT0h4lLbY9bdAob/IpBQ9Uun5SXSwhLLe2dQQB4HLYo/pCUo/Gv0foLbQYgt1qnSUYK1SDE6S31g/MjffA+pBVkamqEp9fpTyj/iJ3TRBAEl3CYYaPrp7ApfZOyD79tV4KiWMnIiLy8QsLaPLC3vNFZ2o01nRzFkb2KqrWaHn55zKqNPiXapbFGJZMOljoOWaABEkOX1pHFIVf462mZBYse0v15lbl99E30aDNm9MoB8u0K/Wr5V+bBjhCwwIOAStDCKypgLPgrIyOG7qRwYXA5O3XYLnfhg==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <DA65DD8C26F8934AB3E6236D36C50FF3@eurprd08.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5b6840b-1513-4987-2a03-08d746504f06
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Oct 2019 09:18:23.5405
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LZBcP3YhNcanljlTX1dVeN2mAj5WeAAUaZRDwCwmuNt/61Of4KQHF8/j/8kZwK3XaQDDoYeXhyuV0LC/OLqUVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB3619
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 01, 2019 at 06:44:08AM +0800, kbuild test robot wrote:
> url:    https://github.com/0day-ci/linux/commits/Roman-Kagan/x86-hyperv-make-vapic-support-x2apic-mode/20191001-044238
> config: x86_64-randconfig-e004-201939 (attached as .config)
> compiler: gcc-7 (Debian 7.4.0-13) 7.4.0
> reproduce:
>         # save the attached .config to linux build tree
>         make ARCH=x86_64 
> 
> If you fix the issue, kindly add following tag
> Reported-by: kbuild test robot <lkp@intel.com>
> 
> All errors (new ones prefixed by >>):
> 
>    arch/x86/hyperv/hv_apic.c: In function 'hv_x2apic_read':
> >> arch/x86/hyperv/hv_apic.c:91:10: error: implicit declaration of function 'native_apic_msr_read'; did you mean 'native_apic_icr_read'? [-Werror=implicit-function-declaration]
>       return native_apic_msr_read(reg);
>              ^~~~~~~~~~~~~~~~~~~~
>              native_apic_icr_read
>    arch/x86/hyperv/hv_apic.c: In function 'hv_x2apic_write':
> >> arch/x86/hyperv/hv_apic.c:119:3: error: implicit declaration of function 'native_apic_msr_write'; did you mean 'native_apic_icr_write'? [-Werror=implicit-function-declaration]
>       native_apic_msr_write(reg, val);
>       ^~~~~~~~~~~~~~~~~~~~~
>       native_apic_icr_write
>    cc1: some warnings being treated as errors

Oops, !CONFIG_X86_X2APIC needs to be handled.  Will post v2.

Roman.
