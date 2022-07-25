Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6030558085D
	for <lists+kvm@lfdr.de>; Tue, 26 Jul 2022 01:44:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230021AbiGYXo2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Jul 2022 19:44:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229764AbiGYXo1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Jul 2022 19:44:27 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05E9B23BF9;
        Mon, 25 Jul 2022 16:44:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658792666; x=1690328666;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=HIQkxXnnxwGw/G+Mjp+HfguE24mecr/OossbS3N6hOo=;
  b=m7adlDtC+FI8m6uTHN/t49mIzcvv+Dp4F+sS2iCPpNsOgdYRWjstUqVh
   y+6LKO3y2O+N9q8t0OXColE9XSazLKGRu9kj3nGgJ5dQnLI1zRySk/75X
   F5xIDKGOhf9G0lV51EVJ9/v/v3auW9E4JgYUgcSKqo1G8nWEODJVMINDN
   jk/t8nSlmm3o8/Cv7FJPsIoyyoRyq87+Zwawzuczrq3D3zJHCy753eiiA
   Duzz8tCC05SL0nASu+5pkZ/x9+q1XEiArttZzdaEtsysP1654Y6/u99xa
   bAH+rhrViIsr1mijTlp4/KXKp+3cqHxY/3Y5XA+G0hNoXggpVTOHYKx2M
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10419"; a="289006583"
X-IronPort-AV: E=Sophos;i="5.93,193,1654585200"; 
   d="scan'208";a="289006583"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2022 16:44:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,193,1654585200"; 
   d="scan'208";a="596837365"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga007.jf.intel.com with ESMTP; 25 Jul 2022 16:44:24 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 25 Jul 2022 16:44:24 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Mon, 25 Jul 2022 16:44:24 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.49) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Mon, 25 Jul 2022 16:44:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QP5QF/9gdePkFTKcnKnjyYKiI+y3GXyUC6bjl0qwz2r5COejbu8NG6Yw9kOMafnTR0vDL9CecrHq9OIJSLteV0n8Nb9prVW/ZoRNXpa1E1raeJfcDvAzp78RrQpIjCQWGSvVTTWrOvKsK2++MMzgxZib7k8qLGOC2gNcR8ORqs4WL4Tbj/MuUxd5cdahfSBd8unO8MD6rA4ZTGMWQn2gBuazcYhQniqY8iN8yqSTJ+D1VbS7Mqh3kdqAjXr93mskPy6LTtPez8cXo3IEjuPpKcbgsIV8ZZQsBpjltCSVq41Fw/5BnVrLrtN9C3qGivyyIoJGf26rRLRjdnztSg2Liw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rqAkauYvT2S5NC4LIPan2Y9+slGfv0W82jrh2CaUx2I=;
 b=IzxamjHr+1GMIxtsFSNsOTBOP6P4Q75+q3oEsf/OZZOjyjMtMqTz3Dn8ENcRrWE0rNZNwyB65/Q0Ebr3XerH6SRzNeedmJyVydwUSaU9xf4srXLTtNzY5nC95Q17OgXSiE5yX87ZQIm3GXn8pLiYOcuogQWw6hFEDlAraTfrlkBN51XRrjIY3yhXjAlnQvO20ax+lM/uivIVK2LiwUfqJuPPWVWwEwfUKRMu1p6q2XECi3lBQItFgFsyargsPSj3nJmhxv52UeYK6R0BoZbEY39iTurCzxqslJPqsyxhZDvl+UDdqKnTC+YWZvbOWeIAO99bx+pJjYBaCnOW3+fOxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW3PR11MB4554.namprd11.prod.outlook.com (2603:10b6:303:5d::7)
 by SJ0PR11MB5136.namprd11.prod.outlook.com (2603:10b6:a03:2d1::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.18; Mon, 25 Jul
 2022 23:44:22 +0000
Received: from MW3PR11MB4554.namprd11.prod.outlook.com
 ([fe80::f5be:f0a4:1874:ba19]) by MW3PR11MB4554.namprd11.prod.outlook.com
 ([fe80::f5be:f0a4:1874:ba19%5]) with mapi id 15.20.5458.024; Mon, 25 Jul 2022
 23:44:21 +0000
From:   "Liu, Rong L" <rong.l.liu@intel.com>
To:     Dmytro Maluka <dmy@semihalf.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Eric Auger <eric.auger@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Tomasz Nowicki <tn@semihalf.com>,
        Grzegorz Jaszczyk <jaz@semihalf.com>,
        Dmitry Torokhov <dtor@google.com>,
        "Liu, Rong L" <rong.l.liu@intel.com>
Subject: RE: [PATCH 3/3] KVM: irqfd: Postpone resamplefd notify for oneshot
 interrupts
Thread-Topic: [PATCH 3/3] KVM: irqfd: Postpone resamplefd notify for oneshot
 interrupts
Thread-Index: AQHYmGQnHF1zT77+b06fnEQmaAbtmq2Pyl+g
Date:   Mon, 25 Jul 2022 23:44:21 +0000
Message-ID: <MW3PR11MB4554E98CE51B883764BE4FB4C7959@MW3PR11MB4554.namprd11.prod.outlook.com>
References: <20220715155928.26362-1-dmy@semihalf.com>
 <20220715155928.26362-4-dmy@semihalf.com>
In-Reply-To: <20220715155928.26362-4-dmy@semihalf.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.500.17
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2d9c8ea6-eeb6-4d33-b70e-08da6e979949
x-ms-traffictypediagnostic: SJ0PR11MB5136:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tdiCLmDjMr7PnAMLEPSj4OBdICo1cZFpLuDrrv7oY73dQ6RDrSNtSxC7rCk6zMIPUxlljkzGUV5Yr298U+JmQM8cEvjhxbGydLPNpAuROMKDPg5QOYr6wt7QOEW/u8lLiS2ZI5mTrTugFy4BX9m6h4T2VO/inO2NZhebxjQDxm7aI/Fw3/EWvmcIm8qT46gyFSoT536AlPnmYP0jcltdiT4K+SBHu50C9gRLBkzBhPot5szXQjH+MQkrFJ85iX361cC/lpOCTv/F0Ioe7DxhlLLAZ98gOsppwjroo2cvORhN7Ldm2PKh8ypuGnkLWNJPOWgfW0qnZEp+z9DvtxD9y/nmUWZlP68EcuLQL0Jztf7wR5PoB+ovqQlsheFqsPmUijCsQmdQBp3Ydk1juaGUWG3qrqDuQR58t/wWpvAnfpPIEs3cNoJSmMU9LGaQmX73xWRP11FtiKhOINKwDH8vma7kHE135YyJs+yNj84J/KbQdIvMJtWNwxoQkUn0xdDmPdr82eqOofVEODmQDAZgpdniOG/A7R2rafo0zi+mlgB31Fw6K9QflnLG5MxNlvjnsoqaj0HqGXeDlDaVyvBJ1rjuMtLeF/KSh9kcP2I/mubcOc9XFKtu/D3qYgcpPaiuQcekkuvMD9vuajHeV2YtVhNucZKmdkoSwj0QMWgeHHgzBbDJOgh7mmahqeZ7F0vQtsIYfcoemcGOckAVFGQLQD1oNW6HbN3baJ1PtOpi26KAjD0lzG4qCujGRued77myN/Rr17ueyf/aq8N1L4RxCsjseqew7wpr+8yjyDtUccfq4Xoukgn7Y2bj9imqg9sahQBz3RYaSxasHvvcbg+fZg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4554.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(39860400002)(136003)(396003)(346002)(366004)(82960400001)(66476007)(122000001)(110136005)(54906003)(64756008)(55016003)(4326008)(8676002)(66946007)(66556008)(66446008)(316002)(38100700002)(38070700005)(76116006)(966005)(6506007)(52536014)(478600001)(71200400001)(5660300002)(41300700001)(86362001)(53546011)(186003)(7696005)(7416002)(26005)(83380400001)(9686003)(2906002)(8936002)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?N/kB3D70BMedhW74R8G59CZDbVMfQ4wVq5Nf6NaCe6szhGo1oUR35DOnHiW4?=
 =?us-ascii?Q?4Gd/OAjJ2i5h81A5e7pT1e2d6OwFhwCoI5EHWZxavHUggg473ctRy5OxS2E2?=
 =?us-ascii?Q?GAAsmZQSyHel6XsOGXNGCnPkMaHVnB1t3LZl2UUu/TU7Rm6G8iuhIU8SPksP?=
 =?us-ascii?Q?/3m5HWItROHjokobecJeEwTNFeZUTGKjsqL+YG06pQw9yN3co72q3DeB6Kpk?=
 =?us-ascii?Q?GXYqtxy78XwozjzW60ONBZT89r1iU5zHrgMatZU0ScuCmqrI2oJOJKGTHqV4?=
 =?us-ascii?Q?EL1RD7mxmHA48zlSJOsTdoJid8jYvYiVnMApWwbRZdS/B5sfKWlvHd4DmmYf?=
 =?us-ascii?Q?PVnNMrY65Ei/K5HnUfoYl0Wo+//idGFrT1ZwZ6C36rcq/sMEPd5k3NvIV1r0?=
 =?us-ascii?Q?DiT9qkWRiCu286c+JnvdtLJmGseE03bt0vA7uyjjUplrfPAw8Z8PJ9VieY2Y?=
 =?us-ascii?Q?fk46y/RiaD2syYQ5TcXxT16PvQznRor4urDJXLBC7zi5z/f2Mim/5MLtCOOC?=
 =?us-ascii?Q?CtvYhx5zePXrbiO0xMgWZrHPZ7tFzcUsfvkl7jJzqTpx+MWj7kS/ej5obX2+?=
 =?us-ascii?Q?CrMkZgDcJmc9bp5uf3T6SLdnSmLp/vcedfgA0dQBr3G+Sr9QW2+s62KhV4yx?=
 =?us-ascii?Q?tj4fwYfzB48AOavZuTWSgsNkltNxPIh/XgJc9/xXlO4q0zRTwBwmO7+01K6X?=
 =?us-ascii?Q?qmnWFxsEzqDeHBwp/IPqaCB6G6Djmzx0k8/6zdd0TZ2Q8E93Tsamw+FPkRpE?=
 =?us-ascii?Q?G4DewHwrPRgTosNXmWzw6U//UrfJ4Jm5hXY3f+KIi0t4N41Z51a95waPKlnz?=
 =?us-ascii?Q?+lH8PRgSz+laHC52ukyvdyjppb02aSSKsocBmqOFhA9vOrN0tIJ0oOJ+U9yL?=
 =?us-ascii?Q?oRKp1VNrdKUOV7rytgRRs2Ac+7q0W3IfEOf5hLfkNrAubnd9BhkW4GUBQLU/?=
 =?us-ascii?Q?HZAaL7Tvc2pTW94kCsOIEo5QBNQtds18SYTz22w443HBIepyz2CbPEt2UI/+?=
 =?us-ascii?Q?44shxaOmGeb9+oT2bnAN5G/5sXvxArWDYXAd1I4iaLZRDwDzC9RVtzXbiv9f?=
 =?us-ascii?Q?D7yLSfsj8mpDJ9zoHZAyCgbE48p4iYwFhnmyzsS0sKzxxR7yAHJsmmRhYAe5?=
 =?us-ascii?Q?BbDElirNYljiVX6mqZTqTrd9M/BDsiswWcqeCleA6PnSDgj+55n9Z8EDuilm?=
 =?us-ascii?Q?OW8TZWLYI7w4hRs7LNAtiZ54fr5k6KF9WixGIJQunsk62sjqL2nCjbMvjLSR?=
 =?us-ascii?Q?Nm2Ll+aZ9r+rxFwqNeZQFutpDSObSj9pEWVG2NoSOs+U+ilLOu4NdXRG82mR?=
 =?us-ascii?Q?WKrOHcklVOxs3G/xnGtWvb/vD+dF81Iay/kz2fl5UujCrqbTljEyY2aH6A8X?=
 =?us-ascii?Q?7i6AydKNyWSy6mAJvwQX1KG5huNT+5uNE7OD/9Tz+hmhiKSKmRiARt7Inr0W?=
 =?us-ascii?Q?u7X2x7xshBmq7AOaX1nX8tXdEsD3DGPr2VTpdnU5VcyDgL73OLhKX5tgV3pA?=
 =?us-ascii?Q?RBv83drM39Tc3XGnfIblCGrEGQaWjFUhDY4q8iR/cRU/M4gMejljOk0TbzLS?=
 =?us-ascii?Q?dzEkK5xEzjqxBEiGQjrt8aZeVDbaV9YsvpborT43?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW3PR11MB4554.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d9c8ea6-eeb6-4d33-b70e-08da6e979949
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jul 2022 23:44:21.7052
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: d4bVEVjjwWWFlpW/UcN3odvzLq/0E19VXn4TnVuIoqfUbBPb3q9Ehw9qKuydX9SP4ZtMPgYGIts7oY6hUKpZ8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5136
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Dmytro,

> -----Original Message-----
> From: Dmytro Maluka <dmy@semihalf.com>
> Sent: Friday, July 15, 2022 8:59 AM
> To: Christopherson,, Sean <seanjc@google.com>; Paolo Bonzini
> <pbonzini@redhat.com>; kvm@vger.kernel.org
> Cc: Thomas Gleixner <tglx@linutronix.de>; Ingo Molnar
> <mingo@redhat.com>; Borislav Petkov <bp@alien8.de>; Dave Hansen
> <dave.hansen@linux.intel.com>; x86@kernel.org; H. Peter Anvin
> <hpa@zytor.com>; linux-kernel@vger.kernel.org; Eric Auger
> <eric.auger@redhat.com>; Alex Williamson
> <alex.williamson@redhat.com>; Liu, Rong L <rong.l.liu@intel.com>;
> Zhenyu Wang <zhenyuw@linux.intel.com>; Tomasz Nowicki
> <tn@semihalf.com>; Grzegorz Jaszczyk <jaz@semihalf.com>; Dmitry
> Torokhov <dtor@google.com>; Dmytro Maluka <dmy@semihalf.com>
> Subject: [PATCH 3/3] KVM: irqfd: Postpone resamplefd notify for oneshot
> interrupts
>=20
> The existing KVM mechanism for forwarding of level-triggered interrupts
> using resample eventfd doesn't work quite correctly in the case of
> interrupts that are handled in a Linux guest as oneshot interrupts
> (IRQF_ONESHOT). Such an interrupt is acked to the device in its
> threaded irq handler, i.e. later than it is acked to the interrupt
> controller (EOI at the end of hardirq), not earlier.
>=20
> Linux keeps such interrupt masked until its threaded handler finishes,
> to prevent the EOI from re-asserting an unacknowledged interrupt.
> However, with KVM + vfio (or whatever is listening on the resamplefd)
> we don't check that the interrupt is still masked in the guest at the
> moment of EOI. Resamplefd is notified regardless, so vfio prematurely
> unmasks the host physical IRQ, thus a new (unwanted) physical interrupt
> is generated in the host and queued for injection to the guest.
>=20
> The fact that the virtual IRQ is still masked doesn't prevent this new
> physical IRQ from being propagated to the guest, because:
>=20
> 1. It is not guaranteed that the vIRQ will remain masked by the time
>    when vfio signals the trigger eventfd.
> 2. KVM marks this IRQ as pending (e.g. setting its bit in the virtual
>    IRR register of IOAPIC on x86), so after the vIRQ is unmasked, this
>    new pending interrupt is injected by KVM to the guest anyway.
>=20
> There are observed at least 2 user-visible issues caused by those
> extra erroneous pending interrupts for oneshot irq in the guest:
>=20
> 1. System suspend aborted due to a pending wakeup interrupt from
>    ChromeOS EC (drivers/platform/chrome/cros_ec.c).
> 2. Annoying "invalid report id data" errors from ELAN0000 touchpad
>    (drivers/input/mouse/elan_i2c_core.c), flooding the guest dmesg
>    every time the touchpad is touched.
>=20
> This patch fixes the issue on x86 by checking if the interrupt is
> unmasked when we receive irq ack (EOI) and, in case if it's masked,
> postponing resamplefd notify until the guest unmasks it.
>=20
> Important notes:
>=20
> 1. It doesn't fix the issue for other archs yet, due to some missing
>    KVM functionality needed by this patch:
>      - calling mask notifiers is implemented for x86 only
>      - irqchip ->is_masked() is implemented for x86 only
>=20
> 2. It introduces an additional spinlock locking in the resample notify
>    path, since we are no longer just traversing an RCU list of irqfds
>    but also updating the resampler state. Hopefully this locking won't
>    noticeably slow down anything for anyone.
>=20

Instead of using a spinlock waiting for the unmask event, is it possible to=
 call
resampler notify directly when unmask event happens, instead of calling it =
on
EOI?

> Regarding #2, there may be an alternative solution worth considering:
> extend KVM irqfd (userspace) API to send mask and unmask notifications
> directly to vfio/whatever, in addition to resample notifications, to
> let vfio check the irq state on its own. There is already locking on
> vfio side (see e.g. vfio_platform_unmask()), so this way we would avoid
> introducing any additional locking. Also such mask/unmask notifications
> could be useful for other cases.
>=20
> Link: https://lore.kernel.org/kvm/31420943-8c5f-125c-a5ee-
> d2fde2700083@semihalf.com/
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Dmytro Maluka <dmy@semihalf.com>
> ---
>  include/linux/kvm_irqfd.h | 14 ++++++++++++
>  virt/kvm/eventfd.c        | 45
> +++++++++++++++++++++++++++++++++++++++
>  2 files changed, 59 insertions(+)
>=20
> diff --git a/include/linux/kvm_irqfd.h b/include/linux/kvm_irqfd.h
> index dac047abdba7..01754a1abb9e 100644
> --- a/include/linux/kvm_irqfd.h
> +++ b/include/linux/kvm_irqfd.h
> @@ -19,6 +19,16 @@
>   * resamplefd.  All resamplers on the same gsi are de-asserted
>   * together, so we don't need to track the state of each individual
>   * user.  We can also therefore share the same irq source ID.
> + *
> + * A special case is when the interrupt is still masked at the moment
> + * an irq ack is received. That likely means that the interrupt has
> + * been acknowledged to the interrupt controller but not acknowledged
> + * to the device yet, e.g. it might be a Linux guest's threaded
> + * oneshot interrupt (IRQF_ONESHOT). In this case notifying through
> + * resamplefd is postponed until the guest unmasks the interrupt,
> + * which is detected through the irq mask notifier. This prevents
> + * erroneous extra interrupts caused by premature re-assert of an
> + * unacknowledged interrupt by the resamplefd listener.
>   */
>  struct kvm_kernel_irqfd_resampler {
>  	struct kvm *kvm;
> @@ -28,6 +38,10 @@ struct kvm_kernel_irqfd_resampler {
>  	 */
>  	struct list_head list;
>  	struct kvm_irq_ack_notifier notifier;
> +	struct kvm_irq_mask_notifier mask_notifier;
> +	bool masked;
> +	bool pending;
> +	spinlock_t lock;
>  	/*
>  	 * Entry in list of kvm->irqfd.resampler_list.  Use for sharing
>  	 * resamplers among irqfds on the same gsi.
> diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
> index 50ddb1d1a7f0..9ff47ac33790 100644
> --- a/virt/kvm/eventfd.c
> +++ b/virt/kvm/eventfd.c
> @@ -75,6 +75,44 @@ irqfd_resampler_ack(struct kvm_irq_ack_notifier
> *kian)
>  	kvm_set_irq(kvm, KVM_IRQFD_RESAMPLE_IRQ_SOURCE_ID,
>  		    resampler->notifier.gsi, 0, false);
>=20
> +	spin_lock(&resampler->lock);
> +	if (resampler->masked) {
> +		resampler->pending =3D true;
> +		spin_unlock(&resampler->lock);
> +		return;
> +	}
> +	spin_unlock(&resampler->lock);
> +
> +	idx =3D srcu_read_lock(&kvm->irq_srcu);
> +
> +	list_for_each_entry_srcu(irqfd, &resampler->list, resampler_link,
> +	    srcu_read_lock_held(&kvm->irq_srcu))
> +		eventfd_signal(irqfd->resamplefd, 1);
> +
> +	srcu_read_unlock(&kvm->irq_srcu, idx);
> +}
> +
> +static void
> +irqfd_resampler_mask(struct kvm_irq_mask_notifier *kimn, bool
> masked)
> +{
> +	struct kvm_kernel_irqfd_resampler *resampler;
> +	struct kvm *kvm;
> +	struct kvm_kernel_irqfd *irqfd;
> +	int idx;
> +
> +	resampler =3D container_of(kimn,
> +			struct kvm_kernel_irqfd_resampler, mask_notifier);
> +	kvm =3D resampler->kvm;
> +
> +	spin_lock(&resampler->lock);
> +	resampler->masked =3D masked;
> +	if (masked || !resampler->pending) {
> +		spin_unlock(&resampler->lock);
> +		return;
> +	}
> +	resampler->pending =3D false;
> +	spin_unlock(&resampler->lock);
> +
>  	idx =3D srcu_read_lock(&kvm->irq_srcu);
>=20
>  	list_for_each_entry_srcu(irqfd, &resampler->list, resampler_link,
> @@ -98,6 +136,8 @@ irqfd_resampler_shutdown(struct
> kvm_kernel_irqfd *irqfd)
>  	if (list_empty(&resampler->list)) {
>  		list_del(&resampler->link);
>  		kvm_unregister_irq_ack_notifier(kvm, &resampler->notifier);
> +		kvm_unregister_irq_mask_notifier(kvm, resampler-
> >mask_notifier.irq,
> +						 &resampler->mask_notifier);
>  		kvm_set_irq(kvm, KVM_IRQFD_RESAMPLE_IRQ_SOURCE_ID,
>  			    resampler->notifier.gsi, 0, false);
>  		kfree(resampler);
> @@ -367,11 +407,16 @@ kvm_irqfd_assign(struct kvm *kvm, struct
> kvm_irqfd *args)
>  			INIT_LIST_HEAD(&resampler->list);
>  			resampler->notifier.gsi =3D irqfd->gsi;
>  			resampler->notifier.irq_acked =3D irqfd_resampler_ack;
> +			resampler->mask_notifier.func =3D irqfd_resampler_mask;
> +			kvm_irq_is_masked(kvm, irqfd->gsi, &resampler-
> >masked);
> +			spin_lock_init(&resampler->lock);
>  			INIT_LIST_HEAD(&resampler->link);
>=20
>  			list_add(&resampler->link, &kvm->irqfds.resampler_list);
>  			kvm_register_irq_ack_notifier(kvm,
>  						      &resampler->notifier);
> +			kvm_register_irq_mask_notifier(kvm, irqfd->gsi,
> +						       &resampler->mask_notifier);
>  			irqfd->resampler =3D resampler;
>  		}
>=20
> --
> 2.37.0.170.g444d1eabd0-goog

