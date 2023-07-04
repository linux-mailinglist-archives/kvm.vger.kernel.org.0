Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A55D746B9A
	for <lists+kvm@lfdr.de>; Tue,  4 Jul 2023 10:12:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230299AbjGDIMU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jul 2023 04:12:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbjGDIMR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jul 2023 04:12:17 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on072d.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe0c::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D8AFCA
        for <kvm@vger.kernel.org>; Tue,  4 Jul 2023 01:12:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oOWkaiglxCly8I61+vboHCQirDXgu0KpqiqykEwLbx2CH1GV7j5PGDNjXNJYm+joQOXi4SK61qkZhQhzyiWwkkT1+7WMtRC4v8yOeN6+ba3XgMCnB5UzHfpK98NfO1b3GiWdtd6L66zLyOX1o2NJuIP79pGTjnDmsN3GnMObsVS2dYdL220pdsDXTQaHNDUjy6isCqQSu6BYqFJkM6ZusIGkl/vkc4hjk8FAAjE+ySFQiLaFabvFx96lQFJEsLHSIprye7HvCY5WAI8nxB0kry4O0PDS9aBejnU0aEq9upRD9R6gX1Vhc31wkNRx2+5JX5GCN+1ZEx6MPI26muHNfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KJsX5B/lsifYbqw3otpO6ISTUWtezOr1jK4I1mGJHtc=;
 b=c21dP8plIhVqbDX/GPnkAf8UmiPYSvCGq6xnymDUlT8CrbGbjoHGvsNA6UT+jb4lfJL/mXhBDJQjiPQFZQcwCljNpOei31EPfy2RAJYkwVUJSh/A3zvzOBNRBcunYoGwQGF8jEKcVx9ObgQQ0fovV6qGgzt2qyKHEm7mJb9MktxcuxD9afz125CORqYom37VbnuX5mZMfdXekEuZ8VtaTJkGtOKjlr1WuujIagn/KU5JBySCFbD4ntzr3p5rTT4v50Y48CsqtTwYV8FBcGO6qe6OX2Xix8+B8TymzzJN2dx2jWRmV1zRkqOOZ5VffUq7SiLv994IAYrGEPvl1d7u/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=knorr-bremse.com; dmarc=pass action=none
 header.from=knorr-bremse.com; dkim=pass header.d=knorr-bremse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=knorr-bremse.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KJsX5B/lsifYbqw3otpO6ISTUWtezOr1jK4I1mGJHtc=;
 b=DnPWVbjXHJ1hMX9/+66ZfBQvp9tj5v/argauNYGJ/CJ61nxMEbsGqR/MrlziP7vK7++MYaAG2CHQQHjmK7fiuSRDV76J5akGDVe9E07brI+A+qozyT0SOZDs0O/dY9BEiewfqrntBIrCxy+HNdbQYP+7QZ3GWu0bP1iafPi3a+M=
Received: from AM8PR04MB7396.eurprd04.prod.outlook.com (2603:10a6:20b:1da::6)
 by AS8PR04MB8417.eurprd04.prod.outlook.com (2603:10a6:20b:3f9::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6544.24; Tue, 4 Jul
 2023 08:12:12 +0000
Received: from AM8PR04MB7396.eurprd04.prod.outlook.com
 ([fe80::9072:398b:adea:17df]) by AM8PR04MB7396.eurprd04.prod.outlook.com
 ([fe80::9072:398b:adea:17df%7]) with mapi id 15.20.6544.024; Tue, 4 Jul 2023
 08:12:12 +0000
From:   =?iso-8859-2?Q?S=E1nta=2C_M=E1rton_=28ext=29?= 
        <Marton.Santa@knorr-bremse.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: KVM with PREEMPT_RT
Thread-Topic: KVM with PREEMPT_RT
Thread-Index: AdmuTw9kT/M41sYgTvm67GKv0NpdGA==
Date:   Tue, 4 Jul 2023 08:12:12 +0000
Message-ID: <AM8PR04MB7396D7A5DF8D712B49317E59B02EA@AM8PR04MB7396.eurprd04.prod.outlook.com>
Accept-Language: hu-HU, en-US
Content-Language: hu-HU
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=knorr-bremse.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM8PR04MB7396:EE_|AS8PR04MB8417:EE_
x-ms-office365-filtering-correlation-id: 95dac51d-df2c-4ef5-b797-08db7c665eff
x-kbdisclaimer-set: True
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xN6WA0Hx2xz4ToVHo/sClGOOcK7FMCSxg32cWpRaJn4nHFTK4w93C05HbGiIjYIwi9iJLgnvADkQGwCFXbjP39HSyxQ4PErXqDKfCaPvf9MbKflWqH9yZ5fmQm1d5RAaHQw6Hbbocu2FQ2oYU7X0mQF/GB7lav0iWwUin/MlVD6d18T4drujeTY1qk07FqkH3b4EqewqXXHLKT1AoWgVQVfGnSikIua2LTnWOIsdYTVY1gFsvAttZeb+K7VH1MgJE+UwX7LWhyNM/tRma9GGhfNAl1QCf4sqcrRXcVkDIbSNRjm8E76qoqhkruUylWoJi5/fmTmxt294deTz7Uhx1BpODj5LhCkBuYeWOO8pyThMr7HWXignMZbvBj/ngN2TDpPg0+8Q3nwmtmafZfpfOL7PFK6UByUqLMUx47HqBdxYfnU9f/BPGz3bIszY7A9edDKhhqUBpuHCDq2NZAz0qAKn6IDiDcGuAouBnq7AXk27N3wm9jWDU09uZ1qZY36oeN6F3Mq+gDNq5PFa2eq3/tAz60JPFgPFYu8cDiEKudqSglpBgdCZDIqacfjs1Z9fmz9Az8VV5eGTuvZVZ4BOojN8qyLuzi15ulON/lkghyI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR04MB7396.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(366004)(39860400002)(376002)(346002)(136003)(451199021)(316002)(41300700001)(7696005)(26005)(83380400001)(66574015)(186003)(9686003)(6506007)(478600001)(71200400001)(122000001)(38100700002)(66446008)(66556008)(64756008)(66946007)(76116006)(66476007)(6916009)(55016003)(52536014)(7116003)(5660300002)(38070700005)(86362001)(33656002)(2906002)(8676002)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-2?Q?qxhuRGCS4NztqbCddjte+w0dKUx/+1nQGNvG288IAMLrZcaKDJD2RuMgNZ?=
 =?iso-8859-2?Q?DBTLeZ5vUr4RMZ1/You3bxgnVM8rPDHHHQxhGYnZjRuMtubICIQLNYsHZW?=
 =?iso-8859-2?Q?4f18UUBw12NQyz7PfcKmggkkdbr9fimBuh2bfu0/MlFlyh+rjx0NHv0T74?=
 =?iso-8859-2?Q?4B7MmDX0By1mI8HhRjd9kQrlNyrRF9V0X1ahdcnnCI3umZ6J/uJ+Kdtalu?=
 =?iso-8859-2?Q?bzfOK1qVtds7grkgC0sdFh47ARUPVcpErW4mzT044QbZQSfEKd3Qan0Byw?=
 =?iso-8859-2?Q?3DU2T4TPfaomTHby+3MZd2Bvjt9WkskocjswBLuodfDHMCvVoXABoxJnyX?=
 =?iso-8859-2?Q?YVrEpD6O8wxs3giODmEPbRZ66o3PWcGRTaWKJJNfbyd77kniqvJtJDxgNR?=
 =?iso-8859-2?Q?QiguWm2KVcOebmtgaL8Tnm2mIfZHuGDdhC2zHADs7csPfein1e0VQnbW72?=
 =?iso-8859-2?Q?T2YkvVUEJotG0wwMOh3VnxT2MpG2ySupB4KTRQRWL3BnLTzeXABbzoTIUl?=
 =?iso-8859-2?Q?8dnC9K2dZDxHizKdk7O/APnpqqhkwPVNAFl+H23p9zMgIM1u3zLfNspcp7?=
 =?iso-8859-2?Q?C8T5NAbvbPXJlKi8qLY4wlfrGrMQXsTqzaxXFFrK16Tjx/tYIFNRv4rnTU?=
 =?iso-8859-2?Q?D8SwVTjv5bIBCzHAV4j52SP87QhZ3BIeUdfNX90aDJqdjBGhNFCT4UzHDm?=
 =?iso-8859-2?Q?CaHoVBc9VIMJJzFaViAMMR0e0UQNteQBB+Ag05G3etOcsa1h4Sz6oHmV/g?=
 =?iso-8859-2?Q?mOaxKba3bSM69b21eQYRHvszKW+wGX4OF0NdhT/N/q5y4pCsapNleydhMq?=
 =?iso-8859-2?Q?rFflsWwMH8oXl7siUva7yDOu+SRlY/7xtPX1qiSmGM6z1+C2o6alAFkOt8?=
 =?iso-8859-2?Q?w/pLn/28OAJmpZ0FMqSqDyxskyZOejhvf0hg8rhAvdyMChfQAgk+IHflLd?=
 =?iso-8859-2?Q?NXOLxoOLXm3YsS036/NWrHgae07EJ+kig/GOwOOai/Gd34UBbI35glqCG5?=
 =?iso-8859-2?Q?UYajfRcTcYa45XUx6tfrElFYgm/3fAXojRPsoqIwajUCsGs5pF3nWBtCFO?=
 =?iso-8859-2?Q?8iwZc17clGH2XIwYxblyoy0xxAOhGpBU28z/qY3JAOWoJDpmOqSg6sYaXr?=
 =?iso-8859-2?Q?5LRoSiq9GVK7W4s+fUU2oQoXTRYxUSXPssJir+BWZsoMMS62Fr65WvORSH?=
 =?iso-8859-2?Q?lYUYFflH+d9huLZSHjfLqq6ncqoDqNbffm34sLtPHAKL48KaESf/Y22t3y?=
 =?iso-8859-2?Q?RMreBHH7HsDgex0RebQKnV/PRP/0XJs/IH9aofKrdXVA3Kf3/7C4tG9JQ6?=
 =?iso-8859-2?Q?shx8Qc5B4YNoAyjpF7cCUePGYL94grrAtOP7TXPGvCAsM3512xf9tzS8JX?=
 =?iso-8859-2?Q?15WJ3vbdYCrfo0JHXQRKNkKHPJHCHjJtK76efhWfTti8G0+3iK6S6Q91EB?=
 =?iso-8859-2?Q?0ULckwWk8xGp9IpYVmVxVbpllpJI+G2l2Jc/dOt/oEg74trlsrMuzk1cJ/?=
 =?iso-8859-2?Q?a/xDua7ddm1phSnbz6IKgY2+Ry9ARxdUHETP6Ps/Y2q2kXdxuxTIhrdcf8?=
 =?iso-8859-2?Q?8KDnRZQnyI9ha86quQQHdUlnK9mAl0BSGAniCuoETSSC5Vja3tihHA4qvY?=
 =?iso-8859-2?Q?sDnZT3O/vYBTQf/MMk7Uj/cNr00tv+EU+9VVjkJZ73pABjSHBWDp5GWw?=
 =?iso-8859-2?Q?=3D=3D?=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: knorr-bremse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM8PR04MB7396.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95dac51d-df2c-4ef5-b797-08db7c665eff
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jul 2023 08:12:12.5114
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 66f6821e-0a30-4a06-8b8b-901bbfd2bc60
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 88UVMpDflU+QDp/+3AhmPAzf4SkNW3AqJJxlBsaK/RwcvivNAcQLcvYF671XVM7DlLuY3OcSRWjAQgXPkSnvvSnwxKE2DoUpl6H6m1u9AfA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8417
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Dear All,

With my colleague, we use aarch64 architecture and we managed to build AGL =
needlefish with KVM features enabled. When we wanted to apply also the PREE=
MPT_RT patch to the kernel to have a real-time system with virtualization c=
apabilities, the "Fully Preemptible Kernel (Real-Time)" option did not appe=
ar in the kernel configuration, only after the KVM support was disabled. We=
 found that it worked like that after a certain kernel version (https://lor=
e.kernel.org/linux-rt-users/20200824154605.v66t2rsxobt3r5jg@linutronix.de/)=
, but we also found forum posts that KVM and PREEMPT_RT can coexist (https:=
//lore.kernel.org/lkml/20211129145706.rvfywpvt6sapiwy2@linutronix.de/T/) in=
 newer kernel versions. Does it work now? What does that mean? Can we build=
 a real-time KVM host OS? What is the process we should follow to build suc=
h an image? We use AGL needlefish with kernel version 5.10.41.

Thank you very much in advance for your early reply!

Best regards,

M=E1rton S=E1nta


This transmission is intended solely for the addressee and contains confide=
ntial information.
If you are not the intended recipient, please immediately inform the sender=
 and delete the message and any attachments from your system.
Furthermore, please do not copy the message or disclose the contents to any=
one unless agreed otherwise. To the extent permitted by law we shall in no =
way be liable for any damages, whatever their nature, arising out of transm=
ission failures, viruses, external influence, delays and the like.
