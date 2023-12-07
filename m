Return-Path: <kvm+bounces-3789-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AC054807EF7
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 03:53:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9321A1C211D5
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 02:53:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 298E21877;
	Thu,  7 Dec 2023 02:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Qtb9U/tH"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2077.outbound.protection.outlook.com [40.107.94.77])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4BD110B;
	Wed,  6 Dec 2023 18:53:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eqHjitjwy/oRvBFPn5uVCg5plA3rgJIP1ySK5V9tLXvSSIwlSwOeK8VUvVX/e1WYXiXozg1cCWFrBZP3+gPpJUqPLxmUxuoViLLdcDJX3YB3I+oWDvSNAG3O+5zr7KFrIdNsBtIXFS71LIjIinhJ+UbJSSFJLQ9wUZvC4QcVdbO2FexXKBqc+2cSB22hTaHueoK1u/Xvn3VQxVqmw7AjYe6lMJ+8ve7MubYLE5RmjeFV2qUoM/q4iSanQ7ByA+uI3stabQvRmIjPiGXZimFHBc9LDF7zsCMotL05Q5CIVCo6Yy1X9RTPw4Z1xPRFofzHxy65yotEstumYsM4ajE/8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=En0d8YGc8fEKaq28QcrL91ZMBRJYbiS3IcE4DxBaCrg=;
 b=QsbJtLYzprgN/s7XQSPTPbB4lsdRly1FvPJdsLh8RemsmGB3/dbmfJY2fx97o4R9qX77Nc7WiZS+X5aAIcjBn9BfVtsRdTaG6D3iFNZzlIEV/Thd6Tkg24gyBLgVxhT6fexUh5HVpl6LLl91H7ZOdYfKwqXxGxVp7zbqgDxZifBStMPIJfha7xm4OsieLIy4FxbfoVp6riMedHiLNGO2Kc5ePvQ9C8YJ3IGcgqBOrG3X79AOP8JZUtOfL0EvRULTmml7GHAo2yPH18ZKv+6L0XwJmRe4xWUdGWZJ6Ka4o7qIekN7znSpfCWOT7UMOCnZx2I5aO03i8i+XMbEA1qhGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=En0d8YGc8fEKaq28QcrL91ZMBRJYbiS3IcE4DxBaCrg=;
 b=Qtb9U/tHQIW0UATAT9rv8OmPILMiV+Qm7FA6cd+UUYQ/jl2tQ1wGBqDe4ZbODwzZBp5n0nsSi3v07nRMyPkJIXiczlPaKVq1oxRSUf2Aeb9pq+OkEHnNUMu2A4NrDQILxp2kuAYw6H9EPpv+CJcjdQSTrXUpK1XL34++tlF/JN+cf2acvCrpZ+VGM57dVVhCU2IAOR4RCwyY69HdimEl5ll2srer6nHnaxoxB2t4Jf0Eon3CLJR1yxp9d3RiioJfIFpTEjB+G8Dv2iRby7mn1kh4KnuISkQlpUOdJ3Ksd2vj/DyH96rSmPKb944ZRMp5rzx8o9F4O9x4kxyo3eEr4g==
Received: from BY5PR12MB3763.namprd12.prod.outlook.com (2603:10b6:a03:1a8::24)
 by IA1PR12MB8539.namprd12.prod.outlook.com (2603:10b6:208:446::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Thu, 7 Dec
 2023 02:53:24 +0000
Received: from BY5PR12MB3763.namprd12.prod.outlook.com
 ([fe80::946b:df84:1f08:737a]) by BY5PR12MB3763.namprd12.prod.outlook.com
 ([fe80::946b:df84:1f08:737a%5]) with mapi id 15.20.7068.025; Thu, 7 Dec 2023
 02:53:23 +0000
From: Ankit Agrawal <ankita@nvidia.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Jason Gunthorpe
	<jgg@nvidia.com>
CC: Marc Zyngier <maz@kernel.org>, Shameerali Kolothum Thodi
	<shameerali.kolothum.thodi@huawei.com>, "oliver.upton@linux.dev"
	<oliver.upton@linux.dev>, "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "will@kernel.org"
	<will@kernel.org>, "ardb@kernel.org" <ardb@kernel.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "gshan@redhat.com"
	<gshan@redhat.com>, Aniket Agashe <aniketa@nvidia.com>, Neo Jia
	<cjia@nvidia.com>, Kirti Wankhede <kwankhede@nvidia.com>, "Tarun Gupta
 (SW-GPU)" <targupta@nvidia.com>, Vikram Sethi <vsethi@nvidia.com>, Andy
 Currid <acurrid@nvidia.com>, Alistair Popple <apopple@nvidia.com>, John
 Hubbard <jhubbard@nvidia.com>, Dan Williams <danw@nvidia.com>, Matt Ochs
	<mochs@nvidia.com>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "lpieralisi@kernel.org"
	<lpieralisi@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 1/1] KVM: arm64: allow the VM to select DEVICE_* and
 NORMAL_NC for IO memory
Thread-Topic: [PATCH v2 1/1] KVM: arm64: allow the VM to select DEVICE_* and
 NORMAL_NC for IO memory
Thread-Index:
 AQHaJytta4jh43n1R0K/JmrIL66tjbCaaoMAgAAm7ICAABecgIAANx6AgAAFzACAAAUTAIAACNGAgAAE34CAAA4KAIABHIaAgAAJ2QCAADLIgIAAFSoAgAANooCAABtsAIAAAXQAgAAA2QCAAIEOaA==
Date: Thu, 7 Dec 2023 02:53:23 +0000
Message-ID:
 <BY5PR12MB37634D7D2B66D772986C4C1DB08BA@BY5PR12MB3763.namprd12.prod.outlook.com>
References: <ZW9ezSGSDIvv5MsQ@arm.com> <86a5qobkt8.wl-maz@kernel.org>
 <ZW9uqu7yOtyZfmvC@arm.com> <868r67blwo.wl-maz@kernel.org>
 <ZXBlmt88dKmZLCU9@arm.com> <20231206151603.GR2692119@nvidia.com>
 <ZXCh9N2xp0efHcpE@arm.com> <20231206172035.GU2692119@nvidia.com>
 <ZXDEZO6sS1dE_to9@arm.com> <20231206190356.GD2692119@nvidia.com>
 <ZXDGUskp1s4Bwbtr@arm.com>
In-Reply-To: <ZXDGUskp1s4Bwbtr@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY5PR12MB3763:EE_|IA1PR12MB8539:EE_
x-ms-office365-filtering-correlation-id: af19246b-a858-4d36-3f63-08dbf6cfadd3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 wCOkHpoaeD4xz2Fv/GVU/C1bpAadNiflD1yN1S0aeJS+e0nF2rPhK0BwEGczy7OSczHdbIZw/AgQ8mB8dcrL7UjdZOgcOsddCN1Z2qPSLDXE3rYuGxiJwIkkkuQlWr8s92j0eX7t8OgDGKL8/fIyrORtE09Hxvgf/SDtoqqFZq+apahrkDQMvfZOxNlJ1WnbJIlrfcHvkeBEZrwOWxScSJyFDaPplR4/C8QdvPMtbYuLOjKerec5sK9v83CF7Z1O9XL06MjedCj0km2JSt5yIzm+oAOSIIoCgOnU7Lmu2CLiw3vJhlmQ9mrnSC2fE2lz4ot91gv/jQx2DdNfVCvvtKvs0KbHTx55oSRYFXhlVSX+Irhh6cz/DewfLgLf8fY1rCH7Xetwyf7ltJxTQESKU46QGL0ws+L/fUM+mapSsgVTsvenY3NWAV/55iq71FMwxC6qD52q8gkd44FqWGRafKh2Y2iaWEEOVBlOqwO0ZCrg4/0R4vMkW7wuiyFAROZbconPBPxEo2/INFibKx8Xy8bngyu7+5v4vohQjTlklnSbGAZuZDcjQQoh53NbD52xo9jo6AuFmjspG1aU56+3Wl+cqS6kVVsr8xm63JDVqiQ/8JPgxfdxNAblhxriSKjL
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB3763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(39860400002)(366004)(396003)(346002)(376002)(230922051799003)(186009)(1800799012)(451199024)(64100799003)(83380400001)(122000001)(41300700001)(38100700002)(55016003)(38070700009)(2906002)(9686003)(33656002)(26005)(7416002)(71200400001)(478600001)(5660300002)(110136005)(7696005)(86362001)(91956017)(76116006)(64756008)(66476007)(316002)(54906003)(6636002)(66446008)(66556008)(6506007)(52536014)(66946007)(8676002)(8936002)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?IrjAg740V2OzCDIx0rDibNf4cd6Nfxvx3Myo6ZG/UMh+8SWiucs3hH23tV?=
 =?iso-8859-1?Q?zB0GQfdxthps3+OnaHqirbaWAa1GDI8zy1oYmcNWpPnAqKrY63jClCHrtk?=
 =?iso-8859-1?Q?QvIg7sG3SC9WmZONJDloIV4gBO9S55Imuuy5vtScXZIlnuEW1HENClPAuY?=
 =?iso-8859-1?Q?2A9E8QgWV73xfbtGPt4LIkNcZvrQvE54hR6HaMGQaCZAsHwwlpc81B1vLS?=
 =?iso-8859-1?Q?UETWyQzQ8qwElnCQ/X93sVgN/T8N7jCXwRBzI+rD94oxa5chP6AUx8eD2X?=
 =?iso-8859-1?Q?yMEdT2RtzmkuL2SBN0UhjSGI05E0F4CtDziPrm6T1kFZZsvhWGla30aL67?=
 =?iso-8859-1?Q?wVNCvA8iX4i+VllpZ/qQEvkbzd32mrtGyxPqM2/Ymaj/75ztQj5U0NXAHR?=
 =?iso-8859-1?Q?x37maZ+vpW1tPtAApuVtctyynJtUDGgKL20n//9zjNaOHNdmbl6Ppu3fH/?=
 =?iso-8859-1?Q?ioirHJP3F2hzO4YeIRylgY/6NphmbnmjhZLrcYJ82vsyEd8yPqczwRAfaD?=
 =?iso-8859-1?Q?In/FMzeXdXY0xnB0obvzaU5Lq9t042yyg0gC15YVVg+jb+SoFZTNysBHzd?=
 =?iso-8859-1?Q?rhwmZWJL4qb9iOTjQ3FFcLJ06/dnPvpmzfLhRbfH/5quyvVG876ekG8EgQ?=
 =?iso-8859-1?Q?+oRiYhNBPpSk8HViJkLOZQpJOBPjmShJRF43mX2hG+z9SbcDuHMkHaQWnN?=
 =?iso-8859-1?Q?g5oio5YS0fSEi/j+NIKWIKnQmRdTLDB3LmsHDLkRMl7Vjnmp2EZzKFeBJ1?=
 =?iso-8859-1?Q?TKZqnbuiGeKzyqVc0fzcUDBKShNZPq2GIkt08L3DWRtLQOjz966nHUIgWZ?=
 =?iso-8859-1?Q?yWkw2loOfr5AeqNkq5P7nRQvo5/t8S6c1B8inMgt9k+Tzt7ppeWDBpTff2?=
 =?iso-8859-1?Q?SGlGXCtH/32fxNgzGKVxtMDzzGiub1E6KF36lY3RIIWY5QolzQdML6XG96?=
 =?iso-8859-1?Q?nGTSNZ6MObcbHXYsj0VeJyexaRxdnO+av8nMS89Z2x+Itehm0kqix4+2BG?=
 =?iso-8859-1?Q?sxouqTIJLi5LGgGP530PErSbBl1Hp1vLB4AN8OpVMc304CQNZZMvyLIZSI?=
 =?iso-8859-1?Q?gx0S8QvLFdRh75eYWoLinwBdtSJSwdqvuExHVPVa6oeOSnTltr4v15nNqx?=
 =?iso-8859-1?Q?nXp9VP1+Tao1RHiKI61UDYNmdgJcyYprO5bikNJNVj4xFoYyR64EjmJmCC?=
 =?iso-8859-1?Q?HRJUF57uYwCeQ4QD01HToWummNnbzVDyL6Id8+u2U5LSlq/TaMVWn/TCyg?=
 =?iso-8859-1?Q?DfP520L9FFSp2d6TfPZ8GE6k81qSRm7rM1CKBte1be72ifGbsxNMDSTZA6?=
 =?iso-8859-1?Q?KtsbrKy/LS/oDaInBjO2SnUvzLsT0vw4/Dd19IHlZy98RJbrWeLfs3MWek?=
 =?iso-8859-1?Q?gHXgnl1JmPp88xcFbcTAVMXT+60c7Je7JNp25/sj11f6PPQTu7lFZwjTJH?=
 =?iso-8859-1?Q?Wd9dESOJfZPUcUPrwP3qlk3Pn/vm25rKBv6PucEM6ncNL/n9Kc0JIjjHe5?=
 =?iso-8859-1?Q?3dBuHv2GDhuZQy5Fq3AXeyQ2IwNgqGp2pLnGmlLBg9T7j2LpFSl2gJ7JrP?=
 =?iso-8859-1?Q?qxgy8fdMxFO9+/wCx/pkGw+ZaY7Tkqez/5d0JZHinWRaHI3HijGw3WYNXH?=
 =?iso-8859-1?Q?XnHGVy/O/f0VE=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB3763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af19246b-a858-4d36-3f63-08dbf6cfadd3
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Dec 2023 02:53:23.7824
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Et2hFnb4xftzhJcMS43YEls1LQX+6b57pc91/4JDE49RfSEInUNJk+FQ0Fg021ak3CzcBqsLPvHk32bFrDrLVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8539

=0A=
=0A=
>On Wed, Dec 06, 2023 at 03:03:56PM -0400, Jason Gunthorpe wrote:=0A=
>> On Wed, Dec 06, 2023 at 06:58:44PM +0000, Catalin Marinas wrote:=0A=
>> > -------------8<----------------------------=0A=
>> > diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_=
pci_core.c=0A=
>> > index 1929103ee59a..b89d2dfcd534 100644=0A=
>> > --- a/drivers/vfio/pci/vfio_pci_core.c=0A=
>> > +++ b/drivers/vfio/pci/vfio_pci_core.c=0A=
>> > @@ -1863,7 +1863,7 @@ int vfio_pci_core_mmap(struct vfio_device *core_=
vdev, struct vm_area_struct *vma=0A=
>> >=A0=A0=A0=A0=A0 * See remap_pfn_range(), called from vfio_pci_fault() b=
ut we can't=0A=
>> >=A0=A0=A0=A0=A0 * change vm_flags within the fault handler.=A0 Set them=
 now.=0A=
>> >=A0=A0=A0=A0=A0 */=0A=
>> > -=A0=A0 vm_flags_set(vma, VM_IO | VM_PFNMAP | VM_DONTEXPAND | VM_DONTD=
UMP);=0A=
>> > +=A0=A0 vm_flags_set(vma, VM_VFIO | VM_IO | VM_PFNMAP | VM_DONTEXPAND =
| VM_DONTDUMP);=0A=
>> >=A0=A0=A0=A0 vma->vm_ops =3D &vfio_pci_mmap_ops;=0A=
>> >=0A=
>> >=A0=A0=A0=A0 return 0;=0A=
>> > diff --git a/include/linux/mm.h b/include/linux/mm.h=0A=
>> > index 418d26608ece..6df46fd7836a 100644=0A=
>> > --- a/include/linux/mm.h=0A=
>> > +++ b/include/linux/mm.h=0A=
>> > @@ -391,6 +391,13 @@ extern unsigned int kobjsize(const void *objp);=
=0A=
>> >=A0 # define VM_UFFD_MINOR=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 VM_NONE=
=0A=
>> >=A0 #endif /* CONFIG_HAVE_ARCH_USERFAULTFD_MINOR */=0A=
>> >=0A=
>> > +#ifdef CONFIG_64BIT=0A=
>> > +#define VM_VFIO_BIT=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 39=
=0A=
>> > +#define VM_VFIO=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 BIT(VM_VFIO_BIT)=0A=
>> > +#else=0A=
>> > +#define VM_VFIO=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 VM_NONE=0A=
>> > +#endif=0A=
>> > +=0A=
>> >=A0 /* Bits set in the VMA until the stack is in its final location */=
=0A=
>> >=A0 #define VM_STACK_INCOMPLETE_SETUP (VM_RAND_READ | VM_SEQ_READ | VM_=
STACK_EARLY)=0A=
>> > -------------8<----------------------------=0A=
>> >=0A=
>> > In KVM, Akita's patch would take this into account, not just rely on=
=0A=
>> > "device=3D=3Dtrue".=0A=
>>=0A=
>> Yes, Ankit let's try this please. I would not call it VM_VFIO though=0A=
>>=0A=
>> VM_VFIO_ALLOW_WC ?=0A=
>=0A=
> Yeah. I don't really care about the name.=0A=
=0A=
Thanks, I will make the change to set the VM_VFIO_ALLOW_WC flag in vfio.=0A=
Then make use of "device=3D=3Dtrue" and presence of the flag to decide on=
=0A=
setting the S2 as NORMAL_NC.=

