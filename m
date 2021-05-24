Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EBA838F616
	for <lists+kvm@lfdr.de>; Tue, 25 May 2021 01:08:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229748AbhEXXKD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 19:10:03 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:29879 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbhEXXKC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 May 2021 19:10:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1621897714; x=1653433714;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=u5hxu/oLMUwpJxXL7qYIX+G7am8QB+9rKdd7n11Oico=;
  b=dXb6e7aTvaoxZoSnLXnmqkRjw7SE53kSlX0gqpbde8Qy7/imOn87O+vz
   za/NzszYbkBuGnBdpl7GNZmVW/5YAjZr6G4VsVKLdM30nhX/NevSG1PnR
   354XUhapgJwP8taAxLugGfGNBqr5dmI5BQvvg2hZTQUXztR+eFjfMvgUR
   nVVKJiX7FsVwT32jpmq35ZNpYR0cFhD16fe772Ubv3nDpyaKwlGJjlIvI
   yxO56tK9NFQ/ke5TpX4o92JJ8G02yO6ww+gRcjtYH9RmCvMVf41wYMPMb
   M2Oqo82aXAf/JeUs6c54Ajw27QqGjHJN+QKbav/t/gBX7ePZYALIu412Y
   Q==;
IronPort-SDR: J0DZGpyptfWeeEH4yGdhG7C8BIonjtWgzWREQpGcmpv8sGCkXMCbo1N/a0caYS3ZnlQ0ZhxMl4
 ozlo0SOTGJYazygpnYlYwg4dd25WTVc0uorJHLUpYVdhNs9/6lZnZhBBDFNeypHxsj+Tz4Dz8D
 0ml2uQ3cxkA4mcsIbFNSjqsLzka1z0FPNPY/1ud0H5NooSps7ayABdw15sGT+khtAy5wLEwxnh
 Qh90pOzvVX55EcRpmhH/ppf3tfSIOT4YsN19ZvnN7Iy6ar0MTIhQ1XnYiMhn25PX5+PnIkvdRI
 A5k=
X-IronPort-AV: E=Sophos;i="5.82,327,1613404800"; 
   d="scan'208";a="280587040"
Received: from mail-mw2nam12lp2043.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.43])
  by ob1.hgst.iphmx.com with ESMTP; 25 May 2021 07:08:32 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UMQF20omfak5RyHZvz++mnwuBPWq76rSeKmS5ey0LUved/h4BzZimNDZN7s4c6lJIdJllMZ8exwpRAE4lbC+NlmVymlXaAgrDC4c17FaxQJbCYJ5gwUYqQL2qUn3HV/7sDlD9313grw512Pn4CNd4ozzdtZQ+zQ9leKLA7PZIQNki5qAnBauch1mac0CM/xFvnYqf9OdLwm1IJn08r866izOzl+WkP7u10zz0Yyh8ZSZTmMZm8XbjN5m+Qwj+aW0m9l6ut8LkklmA+nmFo2dUc6+HIStSjTqgNA9mehYa4un3ahdJ2bZLjT0m9L3eYezU7BhN5vRoeVnvHuMOvDHjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EPuNmpaB8CJpY0oMAsNQwmn9udWlehH/GjazbAckpL8=;
 b=BVzYpDOOkAgT2ynN9J0ZEDAEWpvG12NgP1qvC6i44ebwJf42JjhOKHFQi9ZWL0fsmsOoQxeF5LSHgW5eLTAnPG3TyI6sQvP6qQW5DwC6JsG3jtHXJk78NktokADiJBvd3uIHL+kCyQOcr7L2UfoGJNRm71KJwyAx0j1bOcljboauuEUc+797lzY/3yQmlqxIpq+295S/P4Kxhld8iQ7WvXIBwxvZecQJAF2EoqTH8NPRHEe8Cifl6R4VAIpSEX/XyJbIu8bZgId9GEJRNPVWBjrm8BEiXZMMS/ktUS4GHfbChXC/yVnAXU+sFsqL4glSz7of6PbPVGQ3D0rumkdBeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EPuNmpaB8CJpY0oMAsNQwmn9udWlehH/GjazbAckpL8=;
 b=jIGC8n6hT+x1m1HKk+RxdbYsBbcH+Tht4Nbrpwq+bPzeCDR9dJTK0H9lONgfI7CX+Af08UT4aielfq51+RnMhVuPtHeXOGOwjiCuowu/5dzXMGKTWPPKc655K6UCOx9/HvW5L7C5XVGShAeUkIgxv51xrsI2vPPd+21a35dWHHI=
Received: from DM6PR04MB7081.namprd04.prod.outlook.com (2603:10b6:5:244::21)
 by DM6PR04MB4346.namprd04.prod.outlook.com (2603:10b6:5:a3::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.25; Mon, 24 May
 2021 23:08:30 +0000
Received: from DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::64f9:51d2:1e04:f806]) by DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::64f9:51d2:1e04:f806%9]) with mapi id 15.20.4150.027; Mon, 24 May 2021
 23:08:30 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Palmer Dabbelt <palmerdabbelt@google.com>,
        "guoren@kernel.org" <guoren@kernel.org>
CC:     Anup Patel <Anup.Patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        "aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        "graf@amazon.com" <graf@amazon.com>,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        "anup@brainfault.org" <anup@brainfault.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-staging@lists.linux.dev" <linux-staging@lists.linux.dev>
Subject: Re: [PATCH v18 00/18] KVM RISC-V Support
Thread-Topic: [PATCH v18 00/18] KVM RISC-V Support
Thread-Index: AQHXTGAgKECmO/ER7EehkQtXersO1g==
Date:   Mon, 24 May 2021 23:08:30 +0000
Message-ID: <DM6PR04MB708173B754E145BC843C4123E7269@DM6PR04MB7081.namprd04.prod.outlook.com>
References: <mhng-b093a5aa-ff9d-437f-a10b-47558f182639@palmerdabbelt-glaptop>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2400:2411:43c0:6000:9d12:5efd:fc6d:4ecd]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0b83efae-2391-48b2-b0af-08d91f08d8f1
x-ms-traffictypediagnostic: DM6PR04MB4346:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR04MB43468BB1FA3EBA0F467C47D8E7269@DM6PR04MB4346.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KKh+S+Jqa0bw78lcZ8CEn0vee5e7PnfW/IydDl5IvU32eacz5osf6RXOHxA+muEZ4t7aqOdWUAgM2tocwxdX+g7olSue3Ak8HI70hYhakdtHpp3j37tcVrY+XJ2Z0VN/gkS/zM128mh4zV5hADDrPmfAFGM6hS1etl60iHsGQskhyUwbfP9i+D+oqSX0mhxzLVss+vPN4U6v7TB6b5nJZQXQMmgwIWYjYreP61ZDyh0bQVh8qeBLu9P0N1DRya38vysgIH59w3u892AI2gLRTSp5oOm+DkkTe37guVBUN0j4mKq4RnSr3l5Kl53aY3cYRsESp55fTCyPL70LUWb35ZZL65u5zUMzSBljYEc4sVPSCKX0EjjSGPLfTUect4EfkbkYyqxZ/jA6qYaZRU3p+Urk9Eq4qM8ECc8ZzrHjsIro9ir29iHoJw+qrp/0gbVIodn+Mw7laAdkKUSjkyJJ44zofsWL3BWgdWoS7r+DsbyG0ha5q0yze9fkO4L+UrESWplvGQl/8SVemPbvKQZBILh2Ugh2O1dES3VZZWav2roLX8QMg8fPOK9FC3okgpWcfKuL+FRlgm1iNTdgColMdSWCELjVnOBhooDOWYemJqQNbQKnt4jhvrlZD292aBrah8PjZg9Trh2WfAX6jEmLzNu0dVdp8QwZVBFix/5h/B8xLL4wx2VSg6nCLiHdv+NW/Kw3YprMQEMObEOmMeICFR/hZwkRZWID2bErep05m5oPkXXnzO/niMz8Kf2Xqdm+x5DnY9DXS1hMxQsM3xkykA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB7081.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(376002)(366004)(39850400004)(346002)(33656002)(7416002)(5660300002)(966005)(478600001)(54906003)(186003)(110136005)(4326008)(8936002)(52536014)(9686003)(66446008)(122000001)(8676002)(66946007)(38100700002)(71200400001)(76116006)(91956017)(66476007)(66556008)(64756008)(86362001)(7696005)(2906002)(30864003)(6506007)(53546011)(83380400001)(55016002)(316002)(42580500001)(579004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?iPlNiCd5iSNkPkcWZGRDsxKlttlCiXyiVOicahhOiATCz6xvNO2sdbUBRcjm?=
 =?us-ascii?Q?9s8rkrMmIK0nfFz/mBkWH9BrnsycSocurNICiRIx0qI/mx3e18bIzrgxSjph?=
 =?us-ascii?Q?lARrpEccwfWseC2NQYXcmfCpEYIxT4bPoJ7x/CNyQ7+NZdCIeN4flerjAxaI?=
 =?us-ascii?Q?OauhiVZgjiZ/Msax2NqAJzGr8gG/UcLeikAmDeFUZGzgV9c36EyZjvixANAJ?=
 =?us-ascii?Q?9hpK3iw28pevC57OE7HBcHGRXlCzwVsa+pgREOCiYotwL6VvxOOYPreK0JrQ?=
 =?us-ascii?Q?YqhqaifAXF/OJGr1Trl/7TuWoCUDg277Faq2j8toDWbkYNRKdAYJI89KaROj?=
 =?us-ascii?Q?wXttchUSvbrStOENRMOaXPd3G/VuLlgtxMD/pGBSyGhj9n7pBPdkJgsBOXBA?=
 =?us-ascii?Q?Wsv/N5HGVEOVni9Oo0bn78LT+1LaPHB2ywDWREAMgbM6Pk2DDLsiu3Umag/l?=
 =?us-ascii?Q?HqF9fAzOmr6yiZwUfz4He9X7lL4YMv0O8OIeat3q3VgrTYCQ/upU3oyEnHo+?=
 =?us-ascii?Q?NFLww++7mFtIYiIwe/ew69JK+mCrmPAg2U2gqnkIfsyOtwyz0VLFrZqIwsn6?=
 =?us-ascii?Q?Cpz13sIgCyxPqSjeZsRHPeSd3vYExW9i0dKqcXaSYw3D1GgoF0alIIzoLuob?=
 =?us-ascii?Q?o31JI8qUhq3Meajp06iUfxlas7Lrn9WImki9GTnCZjwvcAGdQd/WsHJPskJV?=
 =?us-ascii?Q?B4SFVKjahxQG632vS0Hq7Y0vZRFimotEPAC6V3b7rZUCXhf46Qrs/PWssMqW?=
 =?us-ascii?Q?vIP+VZctDObj/+2+WpnFdW3G7UgFhKgwqLx1SVj3RYGRe21K4nwMI7UqtoTv?=
 =?us-ascii?Q?s9fECEcuMt5a1f40RN1INorlmgoSRaLPoRQwM6ERjw5rA/qeQxChpyjX0O1J?=
 =?us-ascii?Q?475SV1K2WOCBcTzKAXA/vV2Ngvb+qLH4D1Q+7jjdmezWRdGBIkBZ9ZDOO5po?=
 =?us-ascii?Q?CH/uH/I0x9iUFzwrnvjJtt+Vi7UfPNGcnckGJPgFI6IgZWL+1n9XpCKRncPp?=
 =?us-ascii?Q?CfFS9D6xwLycYPzLFt72Q/2XCWxXrD4xo5QCS9ldM8jQaImj7kHcgY3IMBJc?=
 =?us-ascii?Q?/jo7HA/jyh0qpHzHRoyZMJzGt8swSgOWNJFRhmSQHpoGduiqZfqhmqkTGGOr?=
 =?us-ascii?Q?mIZdkKJHjwf5I3MYMNpSP+BmrnypyAvoh2REdYw6gGQsIfK4WzaApbtDyS5t?=
 =?us-ascii?Q?yELnJpHCYfhoX8JZuHInLvOucwt1QGuYmJ99OkGsmYmnHT0eSI5b/2De5lhH?=
 =?us-ascii?Q?bJ9EpsyT84h+V0arfAHfEUwbG39QPfpuQiZ4JC+kGh47a3QkA23lM/C3DqsV?=
 =?us-ascii?Q?L5a/bGEmwsSzggDLVPC76AdKoNbVuDyvfPiE7lsKovrxvDseGV/BjJNt5NBQ?=
 =?us-ascii?Q?t8zfdKgliCkyYD+gx6wKASrSD5n5AjWpBZPX6otrcK+5g6ybOQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB7081.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b83efae-2391-48b2-b0af-08d91f08d8f1
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 May 2021 23:08:30.8229
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MskZXvNnDRynah0SfI12/OB3HJ81v7DlMUmN/bxmZIOJi4PWn+e2bNoZA7rOYjukucP7VhU3qIrhtOSI2Qtk/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB4346
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021/05/25 7:57, Palmer Dabbelt wrote:=0A=
> On Mon, 24 May 2021 00:09:45 PDT (-0700), guoren@kernel.org wrote:=0A=
>> Thx Anup,=0A=
>>=0A=
>> Tested-by: Guo Ren <guoren@kernel.org> (Just on qemu-rv64)=0A=
>>=0A=
>> I'm following your KVM patchset and it's a great job for riscv=0A=
>> H-extension. I think hardware companies hope Linux KVM ready first=0A=
>> before the real chip. That means we can ensure the hardware could run=0A=
>> mainline linux.=0A=
> =0A=
> I understand that it would be wonderful for hardware vendors to have a =
=0A=
> guarantee that their hardware will be supported by the software =0A=
> ecosystem, but that's not what we're talking about here.  Specifically, =
=0A=
> the proposal for this code is to track the latest draft extension which =
=0A=
> would specifically leave vendors who implement the current draft out in =
=0A=
> the cold was something to change.  In practice that is the only way to =
=0A=
> move forward with any draft extension that doesn't have hardware =0A=
> available, as the software RISC-V implementations rapidly deprecate =0A=
> draft extensions and without a way to test our code it is destined to =0A=
> bit rot.=0A=
=0A=
To facilitate the process of implementing, and updating, against draft=0A=
specifications, I proposed to have arch/riscv/staging added. This would be =
the=0A=
place to put code based on drafts. Some simple rules can be put in place:=
=0A=
1) The code and eventual ABI may change any time, no guarantees of backward=
=0A=
compatibility=0A=
2) Once the specifications are frozen, the code is moved out of staging=0A=
somewhere else.=0A=
3) The code may be removed any time if the specification proposal is droppe=
d, or=0A=
any other valid reason (can't think of any other right now)=0A=
4) ...=0A=
=0A=
This way, the implementation process would be greatly facilitated and=0A=
interactions between different extensions can be explored much more easily.=
=0A=
=0A=
Thoughts ?=0A=
=0A=
=0A=
=0A=
> =0A=
> If vendors want to make sure their hardware is supported then the best =
=0A=
> way to do that is to make sure specifications get ratified in a timely =
=0A=
> fashion that describe the behavior required from their products.  That =
=0A=
> way we have an agreed upon interface that vendors can implement and =0A=
> software can rely on.  I understand that a lot of people are frustrated =
=0A=
> with the pace of that process when it comes to the H extension, but =0A=
> circumventing that process doesn't fix the fundamental problem.  If =0A=
> there really are products out there that people can't build because the =
=0A=
> H extension isn't upstream then we need to have a serious discussion =0A=
> about those, but without something specific to discuss this is just =0A=
> going to devolve into speculation which isn't a good use of time.=0A=
> =0A=
> I can't find any hardware that implements the draft H extension, at =0A=
> least via poking around on Google and in my email.  I'm very hesitant to =
=0A=
> talk about private vendor roadmaps in public, as that's getting way too =
=0A=
> close to my day job, but I've yet to have a vendor raise this as an =0A=
> issue to me privately and I do try my best to make sure to talk to the =
=0A=
> RISC-V hardware vendors whenever possible (though I try to stick to =0A=
> public roadmaps there, to avoid issues around discussions like this and =
=0A=
> conflicts with work).  Anup is clearly in a much more privileged =0A=
> position than I am here, given that he has real hardware and is able to =
=0A=
> allude to vendor roadmaps that I can't find in public, but until we can =
=0A=
> all get on the same page about that it's going to be difficult to have a =
=0A=
> reasonable discussion -- if we all have different information we're =0A=
> naturally going to arrive at different conclusions, which IMO is why =0A=
> this argument just keeps coming up.  It's totally possible I'm just =0A=
> missing something here, in which case I'd love to be corrected as we can =
=0A=
> be having a very different discussion.=0A=
> =0A=
> I certainly hope that vendors understand that we're willing to work with =
=0A=
> them when it comes to making the software run on their hardware.  I've =
=0A=
> always tried to be quite explicit that's our goal here, both by just =0A=
> saying so and by demonstrating that we're willing to take code that =0A=
> exhibits behavior not specified by the specifications but that is =0A=
> necessary to make real hardware work.  There's always a balance here and =
=0A=
> I can't commit to making every chip with a RISC-V logo on it run Linux =
=0A=
> well, as there will always be some implementations that are just =0A=
> impossible to run real code on, but I'm always willing to do whatever I =
=0A=
> can to try to make things work.=0A=
> =0A=
> If anyone has concrete concerns about RISC-V hardware not being =0A=
> supported by Linux then I'm happy to have a discussion about that.  =0A=
> Having a discussion in public is always best, as then everyone can be on =
=0A=
> the same page, but as far as I know we're doing a good job supporting =0A=
> the publicly available hardware -- not saying we're perfect, but given =
=0A=
> the size of the RISC-V user base and how new much of the hardware is I =
=0A=
> think we're well above average when it comes to upstream support of real =
=0A=
> hardware.  I have a feeling anyone's worries would be about unreleased =
=0A=
> hardware, in which case I can understand it's difficult to have concrete =
=0A=
> discussions in public.  I'm always happy to at least make an attempt to =
=0A=
> have private discussions about these (private discussion are tricky, =0A=
> though, so I can't promise I can always participate), and while I don't =
=0A=
> think those discussions should meaningfully sway the kernel's policies =
=0A=
> one way or the other it could at least help alleviate any acute concerns =
=0A=
> that vendors have.  We've gotten to the point where some pretty serious =
=0A=
> accusations are starting to get thrown around, and that sort of thing =0A=
> really doesn't benefit anyone so I'm willing to do whatever I can to =0A=
> help fix that.=0A=
> =0A=
> IMO we're just trying to follow the standard Linux development policies =
=0A=
> here, where the focus is on making real hardware work in a way that can =
=0A=
> be sustainably maintained so we don't break users.  If anything I think =
=0A=
> we're a notch more liberal WRT the code we accept than standard with the =
=0A=
> current policy, as accepting anything in a frozen extension doesn't even =
=0A=
> require a commitment from a hardware vendor WRT implementing the code.  =
=0A=
> That obviously opens us up to behavior differences between the hardware =
=0A=
> and the specification, which have historically been retrofitted back to =
=0A=
> the specifications, but I'm willing to take on the extra work as it =0A=
> helps lend weight to the specification development process.=0A=
> =0A=
> If I'm just missing something here and there is publicly available =0A=
> hardware that implements the H extension then I'd be happy to have that =
=0A=
> pointed out and very much change the tune of this discussion, but until =
=0A=
> hardware shows up or the ISA is frozen I just don't see any way to =0A=
> maintain this code up the standards generally set by Linux or =0A=
> specifically by arch/riscv and therefor cannot support merging it.=0A=
> =0A=
>>=0A=
>> Good luck!=0A=
>>=0A=
>> On Wed, May 19, 2021 at 11:36 AM Anup Patel <anup.patel@wdc.com> wrote:=
=0A=
>>>=0A=
>>> From: Anup Patel <anup@brainfault.org>=0A=
>>>=0A=
>>> This series adds initial KVM RISC-V support. Currently, we are able to =
boot=0A=
>>> Linux on RV64/RV32 Guest with multiple VCPUs.=0A=
>>>=0A=
>>> Key aspects of KVM RISC-V added by this series are:=0A=
>>> 1. No RISC-V specific KVM IOCTL=0A=
>>> 2. Minimal possible KVM world-switch which touches only GPRs and few CS=
Rs=0A=
>>> 3. Both RV64 and RV32 host supported=0A=
>>> 4. Full Guest/VM switch is done via vcpu_get/vcpu_put infrastructure=0A=
>>> 5. KVM ONE_REG interface for VCPU register access from user-space=0A=
>>> 6. PLIC emulation is done in user-space=0A=
>>> 7. Timer and IPI emuation is done in-kernel=0A=
>>> 8. Both Sv39x4 and Sv48x4 supported for RV64 host=0A=
>>> 9. MMU notifiers supported=0A=
>>> 10. Generic dirtylog supported=0A=
>>> 11. FP lazy save/restore supported=0A=
>>> 12. SBI v0.1 emulation for KVM Guest available=0A=
>>> 13. Forward unhandled SBI calls to KVM userspace=0A=
>>> 14. Hugepage support for Guest/VM=0A=
>>> 15. IOEVENTFD support for Vhost=0A=
>>>=0A=
>>> Here's a brief TODO list which we will work upon after this series:=0A=
>>> 1. SBI v0.2 emulation in-kernel=0A=
>>> 2. SBI v0.2 hart state management emulation in-kernel=0A=
>>> 3. In-kernel PLIC emulation=0A=
>>> 4. ..... and more .....=0A=
>>>=0A=
>>> This series can be found in riscv_kvm_v18 branch at:=0A=
>>> https//github.com/avpatel/linux.git=0A=
>>>=0A=
>>> Our work-in-progress KVMTOOL RISC-V port can be found in riscv_v7 branc=
h=0A=
>>> at: https//github.com/avpatel/kvmtool.git=0A=
>>>=0A=
>>> The QEMU RISC-V hypervisor emulation is done by Alistair and is availab=
le=0A=
>>> in master branch at: https://git.qemu.org/git/qemu.git=0A=
>>>=0A=
>>> To play around with KVM RISC-V, refer KVM RISC-V wiki at:=0A=
>>> https://github.com/kvm-riscv/howto/wiki=0A=
>>> https://github.com/kvm-riscv/howto/wiki/KVM-RISCV64-on-QEMU=0A=
>>> https://github.com/kvm-riscv/howto/wiki/KVM-RISCV64-on-Spike=0A=
>>>=0A=
>>> Changes since v17:=0A=
>>>  - Rebased on Linux-5.13-rc2=0A=
>>>  - Moved to new KVM MMU notifier APIs=0A=
>>>  - Removed redundant kvm_arch_vcpu_uninit()=0A=
>>>  - Moved KVM RISC-V sources to drivers/staging for compliance with=0A=
>>>    Linux RISC-V patch acceptance policy=0A=
>>>=0A=
>>> Changes since v16:=0A=
>>>  - Rebased on Linux-5.12-rc5=0A=
>>>  - Remove redundant kvm_arch_create_memslot(), kvm_arch_vcpu_setup(),=
=0A=
>>>    kvm_arch_vcpu_init(), kvm_arch_has_vcpu_debugfs(), and=0A=
>>>    kvm_arch_create_vcpu_debugfs() from PATCH5=0A=
>>>  - Make stage2_wp_memory_region() and stage2_ioremap() as static=0A=
>>>    in PATCH13=0A=
>>>=0A=
>>> Changes since v15:=0A=
>>>  - Rebased on Linux-5.11-rc3=0A=
>>>  - Fixed kvm_stage2_map() to use gfn_to_pfn_prot() for determing=0A=
>>>    writeability of a host pfn.=0A=
>>>  - Use "__u64" in-place of "u64" and "__u32" in-place of "u32" for=0A=
>>>    uapi/asm/kvm.h=0A=
>>>=0A=
>>> Changes since v14:=0A=
>>>  - Rebased on Linux-5.10-rc3=0A=
>>>  - Fixed Stage2 (G-stage) PDG allocation to ensure it is 16KB aligned=
=0A=
>>>=0A=
>>> Changes since v13:=0A=
>>>  - Rebased on Linux-5.9-rc3=0A=
>>>  - Fixed kvm_riscv_vcpu_set_reg_csr() for SIP updation in PATCH5=0A=
>>>  - Fixed instruction length computation in PATCH7=0A=
>>>  - Added ioeventfd support in PATCH7=0A=
>>>  - Ensure HSTATUS.SPVP is set to correct value before using HLV/HSV=0A=
>>>    intructions in PATCH7=0A=
>>>  - Fixed stage2_map_page() to set PTE 'A' and 'D' bits correctly=0A=
>>>    in PATCH10=0A=
>>>  - Added stage2 dirty page logging in PATCH10=0A=
>>>  - Allow KVM user-space to SET/GET SCOUNTER CSR in PATCH5=0A=
>>>  - Save/restore SCOUNTEREN in PATCH6=0A=
>>>  - Reduced quite a few instructions for __kvm_riscv_switch_to() by=0A=
>>>    using CSR swap instruction in PATCH6=0A=
>>>  - Detect and use Sv48x4 when available in PATCH10=0A=
>>>=0A=
>>> Changes since v12:=0A=
>>>  - Rebased patches on Linux-5.8-rc4=0A=
>>>  - By default enable all counters in HCOUNTEREN=0A=
>>>  - RISC-V H-Extension v0.6.1 spec support=0A=
>>>=0A=
>>> Changes since v11:=0A=
>>>  - Rebased patches on Linux-5.7-rc3=0A=
>>>  - Fixed typo in typecast of stage2_map_size define=0A=
>>>  - Introduced struct kvm_cpu_trap to represent trap details and=0A=
>>>    use it as function parameter wherever applicable=0A=
>>>  - Pass memslot to kvm_riscv_stage2_map() for supporing dirty page=0A=
>>>    logging in future=0A=
>>>  - RISC-V H-Extension v0.6 spec support=0A=
>>>  - Send-out first three patches as separate series so that it can=0A=
>>>    be taken by Palmer for Linux RISC-V=0A=
>>>=0A=
>>> Changes since v10:=0A=
>>>  - Rebased patches on Linux-5.6-rc5=0A=
>>>  - Reduce RISCV_ISA_EXT_MAX from 256 to 64=0A=
>>>  - Separate PATCH for removing N-extension related defines=0A=
>>>  - Added comments as requested by Palmer=0A=
>>>  - Fixed HIDELEG CSR programming=0A=
>>>=0A=
>>> Changes since v9:=0A=
>>>  - Rebased patches on Linux-5.5-rc3=0A=
>>>  - Squash PATCH19 and PATCH20 into PATCH5=0A=
>>>  - Squash PATCH18 into PATCH11=0A=
>>>  - Squash PATCH17 into PATCH16=0A=
>>>  - Added ONE_REG interface for VCPU timer in PATCH13=0A=
>>>  - Use HTIMEDELTA for VCPU timer in PATCH13=0A=
>>>  - Updated KVM RISC-V mailing list in MAINTAINERS entry=0A=
>>>  - Update KVM kconfig option to depend on RISCV_SBI and MMU=0A=
>>>  - Check for SBI v0.2 and SBI v0.2 RFENCE extension at boot-time=0A=
>>>  - Use SBI v0.2 RFENCE extension in VMID implementation=0A=
>>>  - Use SBI v0.2 RFENCE extension in Stage2 MMU implementation=0A=
>>>  - Use SBI v0.2 RFENCE extension in SBI implementation=0A=
>>>  - Moved to RISC-V Hypervisor v0.5 draft spec=0A=
>>>  - Updated Documentation/virt/kvm/api.txt for timer ONE_REG interface=
=0A=
>>>=0A=
>>> Changes since v8:=0A=
>>>  - Rebased series on Linux-5.4-rc3 and Atish's SBI v0.2 patches=0A=
>>>  - Use HRTIMER_MODE_REL instead of HRTIMER_MODE_ABS in timer emulation=
=0A=
>>>  - Fixed kvm_riscv_stage2_map() to handle hugepages=0A=
>>>  - Added patch to forward unhandled SBI calls to user-space=0A=
>>>  - Added patch for iterative/recursive stage2 page table programming=0A=
>>>  - Added patch to remove per-CPU vsip_shadow variable=0A=
>>>  - Added patch to fix race-condition in kvm_riscv_vcpu_sync_interrupts(=
)=0A=
>>>=0A=
>>> Changes since v7:=0A=
>>>  - Rebased series on Linux-5.4-rc1 and Atish's SBI v0.2 patches=0A=
>>>  - Removed PATCH1, PATCH3, and PATCH20 because these already merged=0A=
>>>  - Use kernel doc style comments for ISA bitmap functions=0A=
>>>  - Don't parse X, Y, and Z extension in riscv_fill_hwcap() because it w=
ill=0A=
>>>    be added in-future=0A=
>>>  - Mark KVM RISC-V kconfig option as EXPERIMENTAL=0A=
>>>  - Typo fix in commit description of PATCH6 of v7 series=0A=
>>>  - Use separate structs for CORE and CSR registers of ONE_REG interface=
=0A=
>>>  - Explicitly include asm/sbi.h in kvm/vcpu_sbi.c=0A=
>>>  - Removed implicit switch-case fall-through in kvm_riscv_vcpu_exit()=
=0A=
>>>  - No need to set VSSTATUS.MXR bit in kvm_riscv_vcpu_unpriv_read()=0A=
>>>  - Removed register for instruction length in kvm_riscv_vcpu_unpriv_rea=
d()=0A=
>>>  - Added defines for checking/decoding instruction length=0A=
>>>  - Added separate patch to forward unhandled SBI calls to userspace too=
l=0A=
>>>=0A=
>>> Changes since v6:=0A=
>>>  - Rebased patches on Linux-5.3-rc7=0A=
>>>  - Added "return_handled" in struct kvm_mmio_decode to ensure that=0A=
>>>    kvm_riscv_vcpu_mmio_return() updates SEPC only once=0A=
>>>  - Removed trap_stval parameter from kvm_riscv_vcpu_unpriv_read()=0A=
>>>  - Updated git repo URL in MAINTAINERS entry=0A=
>>>=0A=
>>> Changes since v5:=0A=
>>>  - Renamed KVM_REG_RISCV_CONFIG_TIMEBASE register to=0A=
>>>    KVM_REG_RISCV_CONFIG_TBFREQ register in ONE_REG interface=0A=
>>>  - Update SPEC in kvm_riscv_vcpu_mmio_return() for MMIO exits=0A=
>>>  - Use switch case instead of illegal instruction opcode table for simp=
licity=0A=
>>>  - Improve comments in stage2_remote_tlb_flush() for a potential remote=
 TLB=0A=
>>>   flush optimization=0A=
>>>  - Handle all unsupported SBI calls in default case of=0A=
>>>    kvm_riscv_vcpu_sbi_ecall() function=0A=
>>>  - Fixed kvm_riscv_vcpu_sync_interrupts() for software interrupts=0A=
>>>  - Improved unprivilege reads to handle traps due to Guest stage1 page =
table=0A=
>>>  - Added separate patch to document RISC-V specific things in=0A=
>>>    Documentation/virt/kvm/api.txt=0A=
>>>=0A=
>>> Changes since v4:=0A=
>>>  - Rebased patches on Linux-5.3-rc5=0A=
>>>  - Added Paolo's Acked-by and Reviewed-by=0A=
>>>  - Updated mailing list in MAINTAINERS entry=0A=
>>>=0A=
>>> Changes since v3:=0A=
>>>  - Moved patch for ISA bitmap from KVM prep series to this series=0A=
>>>  - Make vsip_shadow as run-time percpu variable instead of compile-time=
=0A=
>>>  - Flush Guest TLBs on all Host CPUs whenever we run-out of VMIDs=0A=
>>>=0A=
>>> Changes since v2:=0A=
>>>  - Removed references of KVM_REQ_IRQ_PENDING from all patches=0A=
>>>  - Use kvm->srcu within in-kernel KVM run loop=0A=
>>>  - Added percpu vsip_shadow to track last value programmed in VSIP CSR=
=0A=
>>>  - Added comments about irqs_pending and irqs_pending_mask=0A=
>>>  - Used kvm_arch_vcpu_runnable() in-place-of kvm_riscv_vcpu_has_interru=
pt()=0A=
>>>    in system_opcode_insn()=0A=
>>>  - Removed unwanted smp_wmb() in kvm_riscv_stage2_vmid_update()=0A=
>>>  - Use kvm_flush_remote_tlbs() in kvm_riscv_stage2_vmid_update()=0A=
>>>  - Use READ_ONCE() in kvm_riscv_stage2_update_hgatp() for vmid=0A=
>>>=0A=
>>> Changes since v1:=0A=
>>>  - Fixed compile errors in building KVM RISC-V as module=0A=
>>>  - Removed unused kvm_riscv_halt_guest() and kvm_riscv_resume_guest()=
=0A=
>>>  - Set KVM_CAP_SYNC_MMU capability only after MMU notifiers are impleme=
nted=0A=
>>>  - Made vmid_version as unsigned long instead of atomic=0A=
>>>  - Renamed KVM_REQ_UPDATE_PGTBL to KVM_REQ_UPDATE_HGATP=0A=
>>>  - Renamed kvm_riscv_stage2_update_pgtbl() to kvm_riscv_stage2_update_h=
gatp()=0A=
>>>  - Configure HIDELEG and HEDELEG in kvm_arch_hardware_enable()=0A=
>>>  - Updated ONE_REG interface for CSR access to user-space=0A=
>>>  - Removed irqs_pending_lock and use atomic bitops instead=0A=
>>>  - Added separate patch for FP ONE_REG interface=0A=
>>>  - Added separate patch for updating MAINTAINERS file=0A=
>>>=0A=
>>> Anup Patel (14):=0A=
>>>   RISC-V: Add hypervisor extension related CSR defines=0A=
>>>   RISC-V: Add initial skeletal KVM support=0A=
>>>   RISC-V: KVM: Implement VCPU create, init and destroy functions=0A=
>>>   RISC-V: KVM: Implement VCPU interrupts and requests handling=0A=
>>>   RISC-V: KVM: Implement KVM_GET_ONE_REG/KVM_SET_ONE_REG ioctls=0A=
>>>   RISC-V: KVM: Implement VCPU world-switch=0A=
>>>   RISC-V: KVM: Handle MMIO exits for VCPU=0A=
>>>   RISC-V: KVM: Handle WFI exits for VCPU=0A=
>>>   RISC-V: KVM: Implement VMID allocator=0A=
>>>   RISC-V: KVM: Implement stage2 page table programming=0A=
>>>   RISC-V: KVM: Implement MMU notifiers=0A=
>>>   RISC-V: KVM: Document RISC-V specific parts of KVM API=0A=
>>>   RISC-V: KVM: Move sources to drivers/staging directory=0A=
>>>   RISC-V: KVM: Add MAINTAINERS entry=0A=
>>>=0A=
>>> Atish Patra (4):=0A=
>>>   RISC-V: KVM: Add timer functionality=0A=
>>>   RISC-V: KVM: FP lazy save/restore=0A=
>>>   RISC-V: KVM: Implement ONE REG interface for FP registers=0A=
>>>   RISC-V: KVM: Add SBI v0.1 support=0A=
>>>=0A=
>>>  Documentation/virt/kvm/api.rst                | 193 +++-=0A=
>>>  MAINTAINERS                                   |  11 +=0A=
>>>  arch/riscv/Kconfig                            |   1 +=0A=
>>>  arch/riscv/Makefile                           |   1 +=0A=
>>>  arch/riscv/include/uapi/asm/kvm.h             | 128 +++=0A=
>>>  drivers/clocksource/timer-riscv.c             |   9 +=0A=
>>>  drivers/staging/riscv/kvm/Kconfig             |  36 +=0A=
>>>  drivers/staging/riscv/kvm/Makefile            |  23 +=0A=
>>>  drivers/staging/riscv/kvm/asm/kvm_csr.h       | 105 ++=0A=
>>>  drivers/staging/riscv/kvm/asm/kvm_host.h      | 271 +++++=0A=
>>>  drivers/staging/riscv/kvm/asm/kvm_types.h     |   7 +=0A=
>>>  .../staging/riscv/kvm/asm/kvm_vcpu_timer.h    |  44 +=0A=
>>>  drivers/staging/riscv/kvm/main.c              | 118 +++=0A=
>>>  drivers/staging/riscv/kvm/mmu.c               | 802 ++++++++++++++=0A=
>>>  drivers/staging/riscv/kvm/riscv_offsets.c     | 170 +++=0A=
>>>  drivers/staging/riscv/kvm/tlb.S               |  74 ++=0A=
>>>  drivers/staging/riscv/kvm/vcpu.c              | 997 ++++++++++++++++++=
=0A=
>>>  drivers/staging/riscv/kvm/vcpu_exit.c         | 701 ++++++++++++=0A=
>>>  drivers/staging/riscv/kvm/vcpu_sbi.c          | 173 +++=0A=
>>>  drivers/staging/riscv/kvm/vcpu_switch.S       | 401 +++++++=0A=
>>>  drivers/staging/riscv/kvm/vcpu_timer.c        | 225 ++++=0A=
>>>  drivers/staging/riscv/kvm/vm.c                |  81 ++=0A=
>>>  drivers/staging/riscv/kvm/vmid.c              | 120 +++=0A=
>>>  include/clocksource/timer-riscv.h             |  16 +=0A=
>>>  include/uapi/linux/kvm.h                      |   8 +=0A=
>>>  25 files changed, 4706 insertions(+), 9 deletions(-)=0A=
>>>  create mode 100644 arch/riscv/include/uapi/asm/kvm.h=0A=
>>>  create mode 100644 drivers/staging/riscv/kvm/Kconfig=0A=
>>>  create mode 100644 drivers/staging/riscv/kvm/Makefile=0A=
>>>  create mode 100644 drivers/staging/riscv/kvm/asm/kvm_csr.h=0A=
>>>  create mode 100644 drivers/staging/riscv/kvm/asm/kvm_host.h=0A=
>>>  create mode 100644 drivers/staging/riscv/kvm/asm/kvm_types.h=0A=
>>>  create mode 100644 drivers/staging/riscv/kvm/asm/kvm_vcpu_timer.h=0A=
>>>  create mode 100644 drivers/staging/riscv/kvm/main.c=0A=
>>>  create mode 100644 drivers/staging/riscv/kvm/mmu.c=0A=
>>>  create mode 100644 drivers/staging/riscv/kvm/riscv_offsets.c=0A=
>>>  create mode 100644 drivers/staging/riscv/kvm/tlb.S=0A=
>>>  create mode 100644 drivers/staging/riscv/kvm/vcpu.c=0A=
>>>  create mode 100644 drivers/staging/riscv/kvm/vcpu_exit.c=0A=
>>>  create mode 100644 drivers/staging/riscv/kvm/vcpu_sbi.c=0A=
>>>  create mode 100644 drivers/staging/riscv/kvm/vcpu_switch.S=0A=
>>>  create mode 100644 drivers/staging/riscv/kvm/vcpu_timer.c=0A=
>>>  create mode 100644 drivers/staging/riscv/kvm/vm.c=0A=
>>>  create mode 100644 drivers/staging/riscv/kvm/vmid.c=0A=
>>>  create mode 100644 include/clocksource/timer-riscv.h=0A=
>>>=0A=
>>> --=0A=
>>> 2.25.1=0A=
>>>=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
