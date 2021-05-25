Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D96C38FC17
	for <lists+kvm@lfdr.de>; Tue, 25 May 2021 10:07:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231477AbhEYIJP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 May 2021 04:09:15 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:59604 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231671AbhEYIJE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 May 2021 04:09:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1621930054; x=1653466054;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=pbigpCX8/qrzdKrZfSBoq6CC4r+aHHsXkMU2s56zKJY=;
  b=mzA+HfoZDZDn1xdYuSSZPJ9A3jEW0iC/rzpSIO7Se4aeFAVmH1G/2i1i
   KrfWqjqWAi0oV/rll9GWTDM8RwiNMNuzxDiNG4tGBou9UI3+Z1Y8EtusB
   HvhB0Y988DXAEl/vBrYCO2Xmx+MP2KmInAOig+GILWMxDxEsqjTwWJUzj
   mYYWnsYJo1bZx6wHTT3Qc3xQOxsVD0QB/X5BZGaAWKzO7p7gCSsVPx3KZ
   6rI7lKZ7+xFU+GPUoeGWcpi83WqoyU7+Iua0AbQ2qlYj0WOgAAOroerkN
   EiqwwdnYjn28viHbCURtQQuUuWzSZ5Ec1lhyrHmMhL0DxgyAEYVF/8cBc
   g==;
IronPort-SDR: QHjzdW5EFe5chYEQdl6q8PP5VzM8G+AQPhy6Yi72v6M7ozQ8c+CLW3kqOoHej5v/j2+ZJqLN4+
 9VraZLV4ElnXzzz8EsgXmDOJMsW/BRhwv3/wWm09jJekON5Qdf0zAmMBDK9uQgJLcaayjhvcxF
 NW2u6sFqs5A8ZoyV+dxvYHd/+3jyA16/lnHo/AuFDvvdvqNrP0a9WANa+kPP/pdBFpLEB8l83E
 AHMHHZ8Y2/CviMeMYSYW+c+uSZa/9d3dt81EoKWVH1gJd/rzIz4sm0Vh3imKiCakqfr2NVBQ+a
 EZg=
X-IronPort-AV: E=Sophos;i="5.82,327,1613404800"; 
   d="scan'208";a="174008586"
Received: from mail-dm6nam11lp2171.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.171])
  by ob1.hgst.iphmx.com with ESMTP; 25 May 2021 16:01:01 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m56DENmyAnDqcaDPU2Qm24cvuDun6oc957bgYhERhY92oAharW9nsIEUiG0m/KA2C9Q0y1sBfkw3DzRcFpivhaSzC6iml3Bd/uKf4xgQIP6qBlZiOkVHsJzpV+bM3g9ilJKRjjlfVa9JAY5ahEsohqNz1lw+Htd6JMnU6xyH2IDIhZYSNPRrb1l0srGjl2RW7inVYubKYkohZec4EULy2rPUtbrtgx9IaCmWUbpY5+nm/2i2DfH5Nw7QPEOlN1ywUQ/S1chs0UqjePi+90ZBoOxlXOwhlUC8H219R169K2ndo2xCIy2uPZ+UfSiPrTAvnUt/UJYD90C94Id6iUnANA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+A5slVtRdabLl5SY8i2KizzFk1srTS7swphq0J/g2co=;
 b=nfkaCXMNUSL+fdHFhSQXpdNaxUgXg35IS9O7vhuAfGVYOmomdB1ckXcj67bEBfRfMxbghndkdDwT9iHBijTGJ7WC6+pafsEA0qi1bG0VrLWoi5IBvHVXgBJaiWEcpKNZx6BPhnDot0DG8IEDUIyuWu30ihzbvXQRc1jxrr4YwKoOROollKs+7ijDjl5dI1CC/z3eUusNgkbVJlhR0wFbj2Hd4zeZ5mc49Myfr98rCn3bzRGwdrr4MfuLhmM1zCtsmRcGkMiV2vpZ02xuUnh/JYn21v5T0mMsBFWREmJlLzazrQOu4BmgWSMNATypusMIzAGT70/WhApAZTD+MDvP+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+A5slVtRdabLl5SY8i2KizzFk1srTS7swphq0J/g2co=;
 b=N454iR7JUWwyhGkZy55fXR1Vzzoxc8G++chCUWnVrR1GJECCqsK9V4hFtFwp3vy8MtJjv7cv4CCVkhV/Zz+9e1rqSshGn874Dr6noSHrj8N5mZ6fsIySOxCmJGX9f1qQSGNcrQdUbpzBN+wKtTL+4q07wRSlEmUGd/i13PAXFeA=
Received: from DM6PR04MB7081.namprd04.prod.outlook.com (2603:10b6:5:244::21)
 by DM6PR04MB5996.namprd04.prod.outlook.com (2603:10b6:5:122::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23; Tue, 25 May
 2021 08:01:01 +0000
Received: from DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::64f9:51d2:1e04:f806]) by DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::64f9:51d2:1e04:f806%9]) with mapi id 15.20.4150.027; Tue, 25 May 2021
 08:01:01 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     Palmer Dabbelt <palmerdabbelt@google.com>,
        "guoren@kernel.org" <guoren@kernel.org>,
        Anup Patel <Anup.Patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        "aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
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
Date:   Tue, 25 May 2021 08:01:01 +0000
Message-ID: <DM6PR04MB7081843419AFCECABA75AD74E7259@DM6PR04MB7081.namprd04.prod.outlook.com>
References: <mhng-b093a5aa-ff9d-437f-a10b-47558f182639@palmerdabbelt-glaptop>
 <DM6PR04MB708173B754E145BC843C4123E7269@DM6PR04MB7081.namprd04.prod.outlook.com>
 <YKypJ5SJg2sDtn7/@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=wdc.com;
x-originating-ip: [2400:2411:43c0:6000:9d12:5efd:fc6d:4ecd]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9355121c-ce25-4381-ae9a-08d91f533ce8
x-ms-traffictypediagnostic: DM6PR04MB5996:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR04MB599669A65BDA821D3A1602BBE7259@DM6PR04MB5996.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: g6x7AP/iLDXf80hkssDE1SvUmBBHrFIVkou05jQnHJJ/YbURAhQUYoZx+glkEkEmeB96W+bmMQg9TwIq0j/XWQ0Srqv89W2zJcFC5fxY9FfnivHaI3AdIZYrXKIH8+gF2/cpwNGl35ZENzJAgWp/hQCthylSb++1E3zTSf0VRodqKY+YyB5mJfXCSg7o8m6SyHtCpGxDfO/U/LXWTJWS0k7Tx1/GlDcxjFMmO/4Kl1yJIhujj5dYwXdZT/68P8Ksq5qnQ7iVoSOtNNugEOtY/x8cmmqi+od3L3ZVVNSi1zXwy2XvJ2iHdmLZ+qIYI3q9MKaWJE01W3WT2jUQulj8XFikc6n6an0rgdFw3jn1asq8qRbr4sNzG9iZsOGMyPv5NHnJHnkHnaJ+0BW2jQN4V4BZEzLbkkG/WMHrT72R6u+f2B2vmJGcY+WaiHB6VGkfCe0LesmVB5SPw1mWZzsnzmGC2w0BrOEMSq/co5Q9V1AdoQFIP38jzzMA0qHtylU4zeznjuzK4lqBlgKEKekAPRWHy7C0pV4E6urqNOJF1k8LV/fJgnR7WgjQZmm/Lf7hPpbxTpFDs9oDimYnaw2GsFcU+TnrJKO4lg7wn2lELFY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB7081.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(39840400004)(376002)(136003)(396003)(33656002)(4326008)(91956017)(122000001)(8676002)(8936002)(66946007)(76116006)(6506007)(53546011)(66476007)(2906002)(38100700002)(64756008)(66556008)(478600001)(7696005)(66446008)(83380400001)(52536014)(55016002)(6916009)(9686003)(7416002)(54906003)(316002)(186003)(86362001)(71200400001)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?tgTSZoUB5Qtj69Kb22l5bqquU3HGvA6Cue/vjPpbCdUbHF/a59RlAxQM++Us?=
 =?us-ascii?Q?xP1q9OqlF+hYqf9idTh60qbbgV+f/ANP5qEF/eYWtVX4nlfaTDvzJw+sHiJ4?=
 =?us-ascii?Q?3FkbV+KY22XhssyMwZAKMG5kH0ihbZqZhk9svzrTXwM+IKJ4m5fKTgbwwn2O?=
 =?us-ascii?Q?Wn8s/AUwES7A5CkxzTv+dx4b232qnvD2khpvLtqJx2X4AlumIkCCll5DzR96?=
 =?us-ascii?Q?1y/g5nMG1zAhRAXq34qZ2JyZvmT0OKWkKGWvGQvg4flH5tDh5u0CD5ZAWJsG?=
 =?us-ascii?Q?ObPmhk1swAT53yY9vNuEvtHgWI/5u6bFq4H2Nsyusc8aaIlzcXPKJE/FWg/k?=
 =?us-ascii?Q?1kljtTg/yOpzxnxQph2fQoNtxmgGZQ34IvKn7zeIEUxv88xoti44WrFDerUJ?=
 =?us-ascii?Q?sEC589VJKvyraLjVS5WnTLcZiO9chFYSgZkqnP7o9wBpV7bNdxj67iyJB3+V?=
 =?us-ascii?Q?Ho+ohkP79GIQmSHGqeehjDehREMRNF2yK54LGSXc394yTKn2okizOgdS9stL?=
 =?us-ascii?Q?CgCGfHPLQjq9SHkJ5yBV9daePYxxxWhUefbSdcfxcMYQlIvamHkimYF9HCfA?=
 =?us-ascii?Q?QXirr5zjaUVeP0zw29g8W+DTWs3E/Va6OmSLZ3I1Il8pRQV1tDQCgF3P6WBk?=
 =?us-ascii?Q?AX+kh6TwN6rcLxZY1ItBYQ+wzeoQ/IWhplG6urR17QAqBTDZ8DR9UkrBypeg?=
 =?us-ascii?Q?x5F8hqwtW9Qn73qAmGDu/abnJNQV4alCtEeM8gBU+6YLwLyooih56u49x2DM?=
 =?us-ascii?Q?q1St6YJND6Bgo4htpKvT3waI+kz4nAaOCzdTsKvfMWi/r1NO9uzjvP22QD++?=
 =?us-ascii?Q?Gilrw89MNdWzYtnB83vbjTjW5MpA7wGlXd3w/BY5DmJs5Xj534g6oY8qInGq?=
 =?us-ascii?Q?kwSQrdDpbcxdIbdHw8KLQD/nLe854Dwy9r0tQq7opGcRjGCKJKR5shJuWDeT?=
 =?us-ascii?Q?czsHqWX2rU/pf5jgKeQ/Dj9jQyFk4/aKjk8tEWDLwocAEoNhB0Tv5AUqHLlg?=
 =?us-ascii?Q?ByHsucujT6w8MPlsfVxPkeG+ayuhJ3zsKZ6zCgon9suYK18FigvoUnsFOLQG?=
 =?us-ascii?Q?N+kvW3UgIqtbUOKUTRy4D7XxiFk4yd/O5pP27Lsxun8s5d5gqzS+QoSDk7ly?=
 =?us-ascii?Q?MyE1OobZvayzX5YkzuyqkdxWGGaANBYteWKqt+A+TQhrUlDVP6pv7jUNZnQw?=
 =?us-ascii?Q?RgNqndXOyO5BO30JcfkoYwMHk/wEjC69O2kVPnixZ+WODG8FV4doupk+Lys2?=
 =?us-ascii?Q?f2wfWBLKlKKnDmCHcj9+LgCHqgAz8X+9HnpZzXnfbl4vYHTfk0fCiZRicxhi?=
 =?us-ascii?Q?o3gTyfnrA7T4H43Y5MtlpnB+Xu99/4rS/JYpJmROBujbsbFZ72tfU9fUxkGp?=
 =?us-ascii?Q?oLtWareuoBF97G+y8VCkgRim0bM662MJzzN0JD/HMdFEW3btgw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB7081.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9355121c-ce25-4381-ae9a-08d91f533ce8
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 May 2021 08:01:01.3706
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: khNl1E77Z884NdL90degL8CQ/jcQq8lLBf/ptl/jnl1oONyWN3s8nPMdQ394YqUqMIAC7Iof1//bKeEbA0MA9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB5996
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021/05/25 16:37, Greg KH wrote:=0A=
> On Mon, May 24, 2021 at 11:08:30PM +0000, Damien Le Moal wrote:=0A=
>> On 2021/05/25 7:57, Palmer Dabbelt wrote:=0A=
>>> On Mon, 24 May 2021 00:09:45 PDT (-0700), guoren@kernel.org wrote:=0A=
>>>> Thx Anup,=0A=
>>>>=0A=
>>>> Tested-by: Guo Ren <guoren@kernel.org> (Just on qemu-rv64)=0A=
>>>>=0A=
>>>> I'm following your KVM patchset and it's a great job for riscv=0A=
>>>> H-extension. I think hardware companies hope Linux KVM ready first=0A=
>>>> before the real chip. That means we can ensure the hardware could run=
=0A=
>>>> mainline linux.=0A=
>>>=0A=
>>> I understand that it would be wonderful for hardware vendors to have a =
=0A=
>>> guarantee that their hardware will be supported by the software =0A=
>>> ecosystem, but that's not what we're talking about here.  Specifically,=
 =0A=
>>> the proposal for this code is to track the latest draft extension which=
 =0A=
>>> would specifically leave vendors who implement the current draft out in=
 =0A=
>>> the cold was something to change.  In practice that is the only way to =
=0A=
>>> move forward with any draft extension that doesn't have hardware =0A=
>>> available, as the software RISC-V implementations rapidly deprecate =0A=
>>> draft extensions and without a way to test our code it is destined to =
=0A=
>>> bit rot.=0A=
>>=0A=
>> To facilitate the process of implementing, and updating, against draft=
=0A=
>> specifications, I proposed to have arch/riscv/staging added. This would =
be the=0A=
>> place to put code based on drafts. Some simple rules can be put in place=
:=0A=
>> 1) The code and eventual ABI may change any time, no guarantees of backw=
ard=0A=
>> compatibility=0A=
>> 2) Once the specifications are frozen, the code is moved out of staging=
=0A=
>> somewhere else.=0A=
>> 3) The code may be removed any time if the specification proposal is dro=
pped, or=0A=
>> any other valid reason (can't think of any other right now)=0A=
>> 4) ...=0A=
>>=0A=
>> This way, the implementation process would be greatly facilitated and=0A=
>> interactions between different extensions can be explored much more easi=
ly.=0A=
>>=0A=
>> Thoughts ?=0A=
> =0A=
> It will not work, unless you are mean and ruthless and people will get=0A=
> mad at you.  I do not recommend it at all.=0A=
> =0A=
> Once code shows up in the kernel tree, and people rely on it, you now=0A=
> _have_ to support it.  Users don't know the difference between "staging=
=0A=
> or not staging" at all.  We have reported problems of staging media=0A=
> drivers breaking userspace apps and people having problems with that,=0A=
> despite the media developers trying to tell the world, "DO NOT RELY ON=0A=
> THESE!".=0A=
> =0A=
> And if this can't be done with tiny simple single drivers, you are going=
=0A=
> to have a world-of-hurt if you put arch/platform support into=0A=
> arch/riscv/.  Once it's there, you will never be able to delete it,=0A=
> trust me.=0A=
=0A=
All very good points. Thank you for sharing.=0A=
=0A=
> If you REALLY wanted to do this, you could create drivers/staging/riscv/=
=0A=
> and try to make the following rules:=0A=
> =0A=
> 	- stand-alone code only, can not depend on ANYTHING outside of=0A=
> 	  the directory that is not also used by other in-kernel code=0A=
> 	- does not expose any userspace apis=0A=
> 	- interacts only with existing in-kernel code.=0A=
> 	- can be deleted at any time, UNLESS someone is using it for=0A=
> 	  functionality on a system=0A=
> =0A=
> But what use would that be?  What could you put into there that anyone=0A=
> would be able to actually use?=0A=
=0A=
Yes, you already mentioned this and we were not thinking about this solutio=
n.=0A=
drivers/staging really is for device drivers and does not apply to arch cod=
e.=0A=
=0A=
> Remember the rule we made to our user community over 15 years ago:=0A=
> =0A=
> 	We will not break userspace functionality*=0A=
> =0A=
> With the caveat of "* - in a way that you notice".=0A=
> =0A=
> That means we can remove and change things that no one relies on=0A=
> anymore, as long as if someone pops up that does rely on it, we put it=0A=
> back.=0A=
> =0A=
> We do this because we never want anyone to be afraid to drop in a new=0A=
> kernel, because they know we did not break their existing hardware and=0A=
> userspace workloads.  And if we did, we will work quickly to fix it.=0A=
=0A=
Yes, I am well aware of this rule.=0A=
=0A=
> So back to the original issue here, what is the problem that you are=0A=
> trying to solve?  Why do you want to have in-kernel code for hardware=0A=
> that no one else can have access to, and that isn't part of a "finalized=
=0A=
> spec" that ends up touching other subsystems and is not self-contained?=
=0A=
=0A=
For the case at hand, the only thing that would be outside of the staging a=
rea=0A=
would be the ABI definition, but that one depends only on the ratified risc=
v ISA=0A=
specs. So having it outside of staging would be OK. The idea of the arch st=
aging=0A=
area is 2 fold:=0A=
1) facilitate the development work overall, both for Paolo and Anup on the =
KVM=0A=
part, but also others to check that their changes do not break KVM support.=
=0A=
2) Provide feedback to the specs groups that their concerns are moot. E.g. =
one=0A=
reason the hypervisor specs are being delayed is concerns with interrupt=0A=
handling. With a working implementation based on current ratified specs for=
=0A=
other components (e.g. interrupt controller), the hope is that the specs gr=
oup=0A=
can speed up freezing of the specs.=0A=
=0A=
But your points about how users will likely end up using this potentially=
=0A=
creates a lot more problems than we are solving...=0A=
=0A=
> Why not take the energy here and go get that spec ratified so we aren't=
=0A=
> having this argument anymore?  What needs to be done to make that happen=
=0A=
> and why hasn't anyone done that?  There's nothing keeping kernel=0A=
> developers from working on spec groups, right?=0A=
=0A=
We are participating and giving arguments for freezing the specs. This is=
=0A=
however not working as we would like. But that is a problem to be addressed=
 with=0A=
RISCV International and the processes governing the operation of specificat=
ion=0A=
groups. The linux mailing lists are not the right place to discuss this, so=
 I=0A=
will not go into more details.=0A=
=0A=
Thank you for the feedback.=0A=
=0A=
Best regards.=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
