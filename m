Return-Path: <kvm+bounces-1125-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 76DC27E4EA3
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 02:41:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 75F751C20C98
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 01:41:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C408812;
	Wed,  8 Nov 2023 01:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="IH4ab2vQ";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="TJQkViab"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEAD47EA
	for <kvm@vger.kernel.org>; Wed,  8 Nov 2023 01:41:40 +0000 (UTC)
X-Greylist: delayed 1721 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 07 Nov 2023 17:41:40 PST
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AC4F12D
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 17:41:40 -0800 (PST)
Received: from pps.filterd (m0127841.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.17.1.22/8.17.1.22) with ESMTP id 3A7LJjeF028017;
	Tue, 7 Nov 2023 17:12:50 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	from:to:cc:subject:date:message-id:references:in-reply-to
	:content-type:content-id:content-transfer-encoding:mime-version;
	 s=proofpoint20171006; bh=tWG8/fFqvnndDQkc8EV3Bw7idJidwVZ2mTEuFH
	NnS9Q=; b=IH4ab2vQPpGWx9LK2uLg7Cc9cI0DKUigD99OL578b0PNYpubWEmSvV
	yWf6K8hXxgo38KOBa0ffc9WnoMs/n6DnJmSogBbnDvEEnfWrEKil4P+wBjW9VQLU
	g4QNI3QPpPFVBBNmnkPGpqFAGucLU5pqJuVJCq6Ph2UW4nMGqmy6uKhGa98ZHC67
	+L5dvovbnEMZ625ArA//S5MiKpeDhWJSsTeIYp2HFDOn1EtK7/dj5JFbnRFGBJFl
	xJ0NUS8jDa6mkLyhOkgWzGjehkurKGbrgCqJDCvhNTb8MC82f766Kg97s9Ew66dt
	kosZ+5glvKvt4Uy2/vg7Wbuik8P4HWCw==
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 3u7w238ahg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 Nov 2023 17:12:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VW8MiG6TQBxaxyKC/yvmdjG4KFijxgjtG979aAcGFwZG7PUgXzl18bBWHKCN2miZlkS7FEeJww6Vo/uDwq7LFh1GvIG0f5l0YmHduKb/Tox9mCF00bN3lxKiU/eQ9HrXzfzKjQD9IdIY26KRvOP4tYha/klRLozuh9CD/EfzU7ONRMJub42aF4JWbrcj2t00xWl64HM3UstnacQVl5e9rVVP/l7kc06jEDalfILHugml6MmkpTTv7pqG8XfuDLrsc/pZe8xzPp0p1398CbHe23o2cKUzGumkfkolAmll2MgPRYD/3LeJRUel+WggquiWJXA8nrgCJXAHQuRRbCbOVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tWG8/fFqvnndDQkc8EV3Bw7idJidwVZ2mTEuFHNnS9Q=;
 b=OZ/2O3boESyPTOfyqG4t9LDnWwNzUeXVgHLKsiwaP4N5oZM99wUh8ICGl8vYBZ49YM6yrApApm7hVL0CRXzmmq+9meKqzRNg1SvQZKf03YzRvMHWhJPUWNqhLQT7aQObrAYYmlnvAlgkbIBxhbdn9ZPvoUy/uggKxAg8Pk9c3qEbkP2mybyTeRANeHHOUHl7o32PY4Jl8fZA6zE7ZD/e4AhpHKDJUMhzNnFpZj1fPrYVtdQ1yAYdlgJdqID7Pz8j5TFdyN93H0uW2fg2FnlGI7SqyiJiAOtVsLA7IS5hzxXju9N6G38aRfMctGMRstuSOnrDcTVPVzICIh5CLQC19g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tWG8/fFqvnndDQkc8EV3Bw7idJidwVZ2mTEuFHNnS9Q=;
 b=TJQkViabOYS4GWTQIwjoFOd81AV5d4mkBKWv7JCzxbyiUlfgDZPfVHktZWlChAS0xYtEyl3z0m3DnW113FEu+lII80ee2ojnHtAh7ipONtWUw26nw2oC0SRyn683VfVnZ0DRZ+/gJnSOrNWLqCatT8WBWL6CzDKM5BYeyec7tt7eDcChgGnsUmNCRqiJj/MGOMr6zoYE8QRg4b5V3PTH0wthXoH1xlJ0/TCEA2yBw2M7FXRtJyCCIf823k9Shix7kH0/KxCvbsVAPsAksg8oRPxCoCy1tTThAolg466vUD9zmfeNqeVhJoS2pd8twG5hIOJ1+2STfd0UEdN2Me0/8A==
Received: from CH0PR02MB8041.namprd02.prod.outlook.com (2603:10b6:610:106::10)
 by CO1PR02MB8587.namprd02.prod.outlook.com (2603:10b6:303:15e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.29; Wed, 8 Nov
 2023 01:12:48 +0000
Received: from CH0PR02MB8041.namprd02.prod.outlook.com
 ([fe80::2de1:cf59:9c08:493e]) by CH0PR02MB8041.namprd02.prod.outlook.com
 ([fe80::2de1:cf59:9c08:493e%6]) with mapi id 15.20.6954.029; Wed, 8 Nov 2023
 01:12:46 +0000
From: Eiichi Tsukata <eiichi.tsukata@nutanix.com>
To: Vitaly Kuznetsov <vkuznets@redhat.com>
CC: "pbonzini@redhat.com" <pbonzini@redhat.com>,
        Maxim Levitsky
	<mlevitsk@redhat.com>,
        =?iso-8859-1?Q?Philippe_Mathieu-Daud=E9?=
	<philmd@linaro.org>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "qemu-devel@nongnu.org"
	<qemu-devel@nongnu.org>
Subject: Re: [PATCH] target/i386/kvm: call kvm_put_vcpu_events() before
 kvm_put_nested_state()
Thread-Topic: [PATCH] target/i386/kvm: call kvm_put_vcpu_events() before
 kvm_put_nested_state()
Thread-Index: 
 AQHaB89aXI5Xqc3T6k+NVdRuk3VgqLBbkLwAgAAA7YCAADJMAIAI/UwAgADHy4CACiilgA==
Date: Wed, 8 Nov 2023 01:12:46 +0000
Message-ID: <7A7A55C5-6151-453A-852C-96CD10098EE6@nutanix.com>
References: <20231026054201.87845-1-eiichi.tsukata@nutanix.com>
 <D761458A-9296-492B-85B9-F196C7D11CDA@nutanix.com>
 <78ddc3c3-6cfa-b48c-5d73-903adec6ac4a@linaro.org> <87wmv93gv5.fsf@redhat.com>
 <D3D6327A-CFF0-43F2-BA39-B48EE2A53041@nutanix.com>
 <87edh9h8nk.fsf@redhat.com>
In-Reply-To: <87edh9h8nk.fsf@redhat.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.700.6)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH0PR02MB8041:EE_|CO1PR02MB8587:EE_
x-ms-office365-filtering-correlation-id: e17dea03-28eb-4b90-0807-08dbdff7d180
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 KgNb1wWHDIku9L2evrf9s1UGfKAf4kCPF4n0Ou38BjrcogBhRnPE4H8v7oqfHfaLnLt9NRqu9vvWD6dWbJb+3TFiD05+w0TEyneYj8uSgcx2xQBPgZzx8vD/wkuWB6yjX/er1l1XpEI2Stmz6H3aVwGk4qRwvytssQtFLBXqIbJO7HmfZDveyEhTV6ruS1DRbSz1XH+GGvt4Pjmhtjfr2jtsrb3Rgl4MEg/7SBfevD4j+U4/fySn3HidgGIB0r7tprF5cxZaOYsOx4/p5qMuxds99yM20RND/iVstubX0z98ktZPYXJNbq7Wj9b7L99uE/arUaLPpPqKgGPu00RNVpWOLnr6L4oolF3HxOUsQluOeGXCH8fE7Anx3IFkxLBTgQ6g24ByYLvlsR1RCDa3sX+4x3IrTEC62zf+M4eiISrkcTunIZoADpNAekTwKz9mrrOuiIocPHJJ4UXeYhkAslAKynHZfa8HqXUl7K8zf5YVpZK1Xk4Knh9cDvuaUPHxSpyOi2bgfQwC0D7G1d2d8Yj2MnHKinI9QeowfQGza3/QQzbnPmMo4V0U0dMkt6VFyssDX9pOH15UeJUCyLewe1AQCCi3PFDP3D9+7Mzj8fKNfv1bOeesjKraySd+ooXuosrnc2+nbMtKaLhukkfLSw==
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR02MB8041.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(39860400002)(376002)(396003)(346002)(366004)(230922051799003)(64100799003)(1800799009)(186009)(451199024)(5660300002)(71200400001)(53546011)(478600001)(2906002)(41300700001)(8936002)(4326008)(8676002)(44832011)(86362001)(38100700002)(6506007)(66556008)(66476007)(6486002)(54906003)(66946007)(64756008)(66446008)(6512007)(26005)(316002)(91956017)(76116006)(122000001)(2616005)(6916009)(36756003)(33656002)(38070700009)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?iso-8859-1?Q?NzEBjkdUXkw2dXBT44HqCnslh7Sje/8OAkB9O9cFPD2OIizn++mtWZt0jP?=
 =?iso-8859-1?Q?LTUL/7ThDFsK3tlFVoutSw3tqkwBIO4y6P/u0cx2+F3pKp2/WxHQY0upQT?=
 =?iso-8859-1?Q?3d3/trkMLCoATqm5Zqp9//m8l0LB/lcE7uhQ4LjeDKaOqLXdeNeiTO9rhO?=
 =?iso-8859-1?Q?yxp6aggzqPVNhbPR1DNqCkrqp+iqgNMC5pL48xFbQmE1ObpS6AKjxp4Xm+?=
 =?iso-8859-1?Q?iMND+7LCMGxF4jtks4z2q9H4uDEUqIFNOqJ/+/NAEJ5zN2y61mod0KSVg2?=
 =?iso-8859-1?Q?KSi5V4WUVNMaFx8UpFqb2UwXP2Zs2r/vuUa7wbctk9ksrqBSoNerzvfZ5E?=
 =?iso-8859-1?Q?0h3aObFSFV648s/fMl5RqwU1V9uI/RKvQVGIEi4QjvbqM4Ob/7XHYQjGJX?=
 =?iso-8859-1?Q?EEqw7WvVn+7G8YECR1fE3Niploq8rxfhjeol7zIw7sJDZnnH86b6vlogf1?=
 =?iso-8859-1?Q?RLptoGHRZVupa0h/+aFhTD+JEriAheHnHkerVfZsxeecjkKOMeNbF59Jhg?=
 =?iso-8859-1?Q?LQbJJlhr1RGNWU6jC9i1TFOHldD66XZkGT2Dwak6eCLh9DbxKATq32TSxu?=
 =?iso-8859-1?Q?fSuB0I+jBa2fswkvuslb2wtYsWa6dgNHfDOcBV51AL2ptjHjP6d17vavEV?=
 =?iso-8859-1?Q?XwujyXS2tPWqLZqAFRXZuf3xmlC3J5eTnmtvO9r8H8b2NukVRavbVaRu6m?=
 =?iso-8859-1?Q?ZaH1CFkvveJtcHf2cpTvfjcJHcexAcvxScih6DLskmQWxuWWjsu/ywUbcP?=
 =?iso-8859-1?Q?4tB6y5Dv0TlKCnS19Ajczj18EkyuOqpeamtlpYKuR/Y/TRsSI0VZTAx2gq?=
 =?iso-8859-1?Q?cDTTs63kTzZF5xxTndx0HaQcKbEJG8gFgKdmIFPgiV9yqEFwqIIVrOmJ1R?=
 =?iso-8859-1?Q?CDjj7eSEV067P8qst3iWOb1L4xN3g0q9l3dKiCXmKdmL4kulkMouyGQEGd?=
 =?iso-8859-1?Q?wOvqoRj/Mtp/E5iLTPlwiPQmLiYGhX83TX86akNyjPeLJpjX1F2ePUhEBO?=
 =?iso-8859-1?Q?ICRSMMd5aBY+q8UfpCZHu7dwlcpn+NdD0Yc+TRzCoSNRjITvRl0kukD7N+?=
 =?iso-8859-1?Q?bFtK9u8Y8/ehzXt09srRB9ykHI+fhMmcE9mObyxxk2zYkVdTpm2l5aD6M5?=
 =?iso-8859-1?Q?F4twNQ3GflupQo7/mF2ctexoxqO+RvR2w4RsXTE9FZUWAoghC+VoIQvS5h?=
 =?iso-8859-1?Q?yxqT47y+eeKW7JiVD4kH5ML0JcA1RLLjA+5I5myFfuKTeiljXkXhivzO+G?=
 =?iso-8859-1?Q?/kROQZ8lJNR/eNGWCC+2C1TIG0Vja6yOGTffmv0Xtel5f9CWzDENqjL7Wd?=
 =?iso-8859-1?Q?inGHY8Pt7Htwh7jF2CYatGRUf/n0aElQp7K+jkvE7sfebOGqP51uZziFJr?=
 =?iso-8859-1?Q?sOXeDbxk2iRLcJ7y9Z0SeEGVlTFuSSZ099dQMOLdtFp9jcingHQ+91bHrd?=
 =?iso-8859-1?Q?pBDrIxx8xRoVR6pTlkUPyRlrUJEH6FLwJZCb9GlgF5QxfFwshlfY6JQz+2?=
 =?iso-8859-1?Q?7P9cFEkwzVFelpPR9QKEF/G7prtQjKJk0OSpIcRDT/DHwHizfHqRy1YUDv?=
 =?iso-8859-1?Q?pmuFEOxzNR/i4RlFAo3/LvJgd+l/0kx8PHGiOPFk85/hlmPsL9/Igz0H9s?=
 =?iso-8859-1?Q?A74u8eRaI+foIwj8kPqxQhAR5inGhm4NZ98nVoz1a1nawMteOtkSGCCw?=
 =?iso-8859-1?Q?=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <51701B0F81B8444DAAA6100B2A7CD145@namprd02.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH0PR02MB8041.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e17dea03-28eb-4b90-0807-08dbdff7d180
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2023 01:12:46.7795
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UjDSOkyju+3GZJS2uKvj8JQHjO02GKAfpb9Xhu7tfF2Im63fo1Iw4JY3jrENoA9C5hftMhpPPfddZAXwMBJmtTpnbYp+mCgppOZrR9bbz+M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR02MB8587
X-Proofpoint-GUID: Y6QYfKBOfUGHlez1zHJhPMGba1HwSnKr
X-Proofpoint-ORIG-GUID: Y6QYfKBOfUGHlez1zHJhPMGba1HwSnKr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-08_01,2023-11-07_01,2023-05-22_02
X-Proofpoint-Spam-Reason: safe

Hi all, appreciate any comments or feedbacks on the patch.

Thanks,
Eiichi

> On Nov 1, 2023, at 23:04, Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>=20
> Eiichi Tsukata <eiichi.tsukata@nutanix.com> writes:
>=20
>> FYI: The EINVAL in vmx_set_nested_state() is caused by the following con=
dition:
>> * vcpu->arch.hflags =3D=3D 0
>> * kvm_state->hdr.vmx.smm.flags =3D=3D KVM_STATE_NESTED_SMM_VMXON
>=20
> This is a weird state indeed,
>=20
> 'vcpu->arch.hflags =3D=3D 0' means we're not in SMM and not in guest mode
> but kvm_state->hdr.vmx.smm.flags =3D=3D KVM_STATE_NESTED_SMM_VMXON is a
> reflection of vmx->nested.smm.vmxon (see
> vmx_get_nested_state()). vmx->nested.smm.vmxon gets set (conditioally)
> in vmx_enter_smm() and gets cleared in vmx_leave_smm() which means the
> vCPU must be in SMM to have it set.
>=20
> In case the vCPU is in SMM upon migration, HF_SMM_MASK must be set from
> kvm_vcpu_ioctl_x86_set_vcpu_events() -> kvm_smm_changed() but QEMU's
> kvm_put_vcpu_events() calls kvm_put_nested_state() _before_
> kvm_put_vcpu_events(). This can explain "vcpu->arch.hflags =3D=3D 0".
>=20
> Paolo, Max, any idea how this is supposed to work?
>=20
> --=20
> Vitaly
>=20


