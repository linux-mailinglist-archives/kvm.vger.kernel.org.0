Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A9A12DC7EA
	for <lists+kvm@lfdr.de>; Wed, 16 Dec 2020 21:47:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727526AbgLPUqP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Dec 2020 15:46:15 -0500
Received: from mail-dm6nam10on2109.outbound.protection.outlook.com ([40.107.93.109]:45805
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727034AbgLPUqO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Dec 2020 15:46:14 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HkZPNZbOUqd8SaHb8dzgcHDGO4IFDcnRaEl77LtdeAV9QIWDea9lweVoV7E8mEd8eNPqBRRy8ONGg6bL2hupE0jMZccPh/Yo4qvWsZwvtvf78gsrv52fRU//2vP8SxBFmxsfzhSUcBYFuGoFe1fp5yqJailHDCEEsX4ZU7nj0+8IgM9GPylCNoD2/xCxeqH4y91onzKlznAuOrN4jBv8lnUARdxu9FSaEFoww/IxkcJ01L9JFwmsiSta1uCY9owi8mmYzfmR+PM553yWnshq1/czysy4/vnts2ZOQ+hMoUdLdYRptZecO59j/cZFG5xTR/2bmFJoGp8fa1j3WMrhZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8cJka2673DUYuWUruf4PzWONyyyxqAMR+oLhGB6ZwDk=;
 b=Z8rACnHr4KKe6NbiBtBBG0dXKV18dYog5JsS2Sez5NhJnNNaN32XSOTtQD/PFzfa0oFHujPvbxBEJypfdTMbMJ6rf01BiWwOn7/56pGffzHMcCyi4FOqZQ/B9eJlJYyBfPLxINAhyMr/bqU8NC1w5srrGBxTau+JXdHUf57qXaf04S8NVrUqGdrku+rTG2ecE/mLRIcv83bPuymhqOX9EbjULHX4l2wzZpQ0ASTxW+7uLbLbwi5gENfWsVW6vjP2/tHUkgN+ez9hklk76JdEyl6S3DjyVGTqCmncVVtAMDQhTwfJ4znceNAofBYm0BfAId7jgR0eJ7PAY8Y3scYqHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8cJka2673DUYuWUruf4PzWONyyyxqAMR+oLhGB6ZwDk=;
 b=fCsNE7r+o2IwLunDI+1WukgWKx/NOEUHqLziCjV6XjYpazhNy+WXtwjA7Fr5Tfyf2D8NEAUcYf8BCp3M+xPUgWmiDa4BvYqXfxTGqJUdgKIetH6Cm3xHeQMqH/vlla48VRUezb3Na7IA9KBvfcl2QJ63QVk0vjfCq8rqWhWEyEY=
Received: from (2603:10b6:303:74::12) by
 MW2PR2101MB0889.namprd21.prod.outlook.com (2603:10b6:302:10::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3700.6; Wed, 16 Dec
 2020 20:45:26 +0000
Received: from MW4PR21MB1857.namprd21.prod.outlook.com
 ([fe80::f133:55b5:4633:c485]) by MW4PR21MB1857.namprd21.prod.outlook.com
 ([fe80::f133:55b5:4633:c485%5]) with mapi id 15.20.3700.014; Wed, 16 Dec 2020
 20:45:26 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Peter Zijlstra <peterz@infradead.org>
CC:     Ingo Molnar <mingo@kernel.org>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jeyu@kernel.org" <jeyu@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        "ardb@kernel.org" <ardb@kernel.org>
Subject: RE: static_branch_enable() does not work from a __init function?
Thread-Topic: static_branch_enable() does not work from a __init function?
Thread-Index: AdbTW3KiWdYv++9aQjWyNkn3nWo7IAAPxcwkABN9BQA=
Date:   Wed, 16 Dec 2020 20:45:26 +0000
Message-ID: <MW4PR21MB18570800B5A2E4C6B578D69EBFC59@MW4PR21MB1857.namprd21.prod.outlook.com>
References: <MW4PR21MB1857CC85A6844C89183C93E9BFC59@MW4PR21MB1857.namprd21.prod.outlook.com>
 <20201216092649.GM3040@hirez.programming.kicks-ass.net>
 <20201216105926.GS3092@hirez.programming.kicks-ass.net>
In-Reply-To: <20201216105926.GS3092@hirez.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=81af6dc7-27f4-43af-ade5-8bc1e894ae3e;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-12-16T20:17:35Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=none action=none
 header.from=microsoft.com;
x-originating-ip: [2601:600:a280:7f70:240f:4d5f:961f:391f]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 8e065f5f-0424-46ec-ff38-08d8a2038465
x-ms-traffictypediagnostic: MW2PR2101MB0889:
x-microsoft-antispam-prvs: <MW2PR2101MB08897094345978648E938CD1BFC59@MW2PR2101MB0889.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cXCHegfRnnt8U+D8zI0lKQiA3GXAWcGM8VY/tqwuwm8FGPkah2e6hgKtZpJomATVgDCwi+b5PppQoIU5aky+ZwOxEyBcfb+/t3veIo6BcYBpZiiFeO41rJ9ravhBDG3tQFIj9j5MIQjpVjtukvgHdLocXKQpst0BTJ8pYJIkOVxF3PRN+paYnvnXYNmmsuZ46XAq+p2rGdcxgCtpIVbmyVaWqGzhEbJxE7XHdjqTk/NrFpc4XlPtu3UbIQGju/eA3EFqRxIFP3PDnS5eBqMH29jjB1Eg9eaN3SXIaBHbUHadh6be7H7xFnxY77JKzWCkPT8J6kXmORBoyhlZBXKW+6S6QhHcOPprskRpOfq3CziOGrRl7G45nA/8RUBANSLYmA6cDaTGCUsoslQtRLAB2w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR21MB1857.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(396003)(39860400002)(346002)(366004)(8936002)(2906002)(86362001)(9686003)(71200400001)(478600001)(66446008)(66476007)(66556008)(64756008)(66946007)(52536014)(5660300002)(316002)(54906003)(76116006)(33656002)(8676002)(8990500004)(6506007)(7696005)(6916009)(4326008)(55016002)(82960400001)(83380400001)(10290500003)(186003)(82950400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?+2HYgZxhRYO4/SbSHGOBs8pQvijuxXJevk6Xr3+tliT9lKs8foNVRsGKbwYi?=
 =?us-ascii?Q?GVj8i2BTnshxVbYBoI4GdDP05a0HOUsWmgxZF70Ue+qJMexvPI9aPEcYlMCk?=
 =?us-ascii?Q?wW5N7ZfSwauRvMoMC85LTUyOxkx9TsR61pICGiM9uSLQx+2FmGjewzLXsdlA?=
 =?us-ascii?Q?zhwjBbQKo/8GrqUGXkS8ht9X78PoSkEAyMf2TibE7lAnWXnVzLn4YFTWRY+u?=
 =?us-ascii?Q?rVuMCimanid+R+HQUIm2URpa7Lhedurof/d1QZMmYuhRPzbduGbkw1IBBPI3?=
 =?us-ascii?Q?//Qnk40m8WWha+7IsJGV9HKoJvXn+BQv1LeP6N/XlXUcthCsakjfRWzlJVH7?=
 =?us-ascii?Q?eA2FOfPky6DMzFh4yvEpowc6Pa8wqB8xiJ/3zxOgzE25/569cRgojiv8Bygh?=
 =?us-ascii?Q?ktAYMANcDrgtHR3oCK4BCBu0T2oS3l0LtJnXFw1DobhOgtRwmrlUvupwM14T?=
 =?us-ascii?Q?YM2ynea0Y7bWvphTicqnLf/Jt/7B6YHMSYrlMzuPWdcR9GJ1BT8Bq6VEkiiB?=
 =?us-ascii?Q?YTtfXV8q/DbZaaCMFsJlQnE+/4PE0aQj6dOyOxXPOTxeq/io0zzcr67DLJcI?=
 =?us-ascii?Q?kY8VxnzWt2vcMdHAQ1QtS7gRl4sv/B6RJYn5KA+YvZzF9ljA6GsCABbjp4Is?=
 =?us-ascii?Q?gNOJgIM4FWJrODOMBS76NfRlZp+yArn6EbWnZnpCMoLTRWbnPk3ILp+qAYP1?=
 =?us-ascii?Q?uvVOiSoowwYv4VdybLeZkflxQEeSOzWMFk1EZNLu9Kq7ym1pPZO6HJCocPm3?=
 =?us-ascii?Q?r3ShHFNTXtm/DRT233aVN+i1rO8IUDdDAcNGH7RGMmRElvXHxz6P5VmCN0D2?=
 =?us-ascii?Q?eY5nTP1R1BVUwmj7WFMgMkHdLOmN7UgM9Un3GeMCNokHEz12W4UJXICzPjzU?=
 =?us-ascii?Q?I6jY1Koa5w32KMRAcauGboll5WU5786LZXnx3hv3kRQ67eYTV9+oerMRRfQI?=
 =?us-ascii?Q?2uKfDEdtnfAV1hgSC+I0S4rn7WOWGIWF5LeRUAr3D/aQTTpyUr4rN/gOL2WP?=
 =?us-ascii?Q?Fji1tqA18smUyD+vWkTzflZjSSK7gooE6kUsESysFKiLBhA=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR21MB1857.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e065f5f-0424-46ec-ff38-08d8a2038465
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2020 20:45:26.1658
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VQ76KwZ/pFtqvHOVhNiDZ3mXeu5rLkXICmEdqImp5jrkr/PG3iv1BbVs6+GIrdmWXByqXu0CLSklpUK/VASorw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR2101MB0889
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Peter Zijlstra <peterz@infradead.org>
> Sent: Wednesday, December 16, 2020 2:59 AM
> ...
> So I think the reason your above module doesn't work, while the one in
> vmx_init() does work (for 5.10) should be fixed by the completely
> untested below.
>=20
> I've no clue about 5.4 and no desire to investigate. That's what distro
> people are for.
>=20
> Can you verify?
>=20
> ---
> diff --git a/kernel/jump_label.c b/kernel/jump_label.c
> index 015ef903ce8c..c6a39d662935 100644
> --- a/kernel/jump_label.c
> +++ b/kernel/jump_label.c
> @@ -793,6 +793,7 @@ int jump_label_text_reserved(void *start, void *end)
>  static void jump_label_update(struct static_key *key)
>  {
>  	struct jump_entry *stop =3D __stop___jump_table;
> +	bool init =3D system_state < SYSTEM_RUNNING;
>  	struct jump_entry *entry;
>  #ifdef CONFIG_MODULES
>  	struct module *mod;
> @@ -804,15 +805,16 @@ static void jump_label_update(struct static_key
> *key)
>=20
>  	preempt_disable();
>  	mod =3D __module_address((unsigned long)key);
> -	if (mod)
> +	if (mod) {
>  		stop =3D mod->jump_entries + mod->num_jump_entries;
> +		init =3D mod->state =3D=3D MODULE_STATE_COMING;
> +	}
>  	preempt_enable();
>  #endif
>  	entry =3D static_key_entries(key);
>  	/* if there are no users, entry can be NULL */
>  	if (entry)
> -		__jump_label_update(key, entry, stop,
> -				    system_state < SYSTEM_RUNNING);
> +		__jump_label_update(key, entry, stop, init);
>  }
>=20
>  #ifdef CONFIG_STATIC_KEYS_SELFTEST

Yes, this patch fixes the issue found by the test module for both
v5.10 and v5.4.=20

Thank you, Peter!

Dexuan

