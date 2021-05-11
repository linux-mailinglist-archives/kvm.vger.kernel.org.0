Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50A0737ACC4
	for <lists+kvm@lfdr.de>; Tue, 11 May 2021 19:12:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231329AbhEKRNK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 May 2021 13:13:10 -0400
Received: from mx0b-002c1b01.pphosted.com ([148.163.155.12]:6172 "EHLO
        mx0b-002c1b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231230AbhEKRNJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 11 May 2021 13:13:09 -0400
Received: from pps.filterd (m0127842.ppops.net [127.0.0.1])
        by mx0b-002c1b01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14BGrsKw027623;
        Tue, 11 May 2021 10:10:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version;
 s=proofpoint20171006; bh=F6zEC8v8M9F5PIeJtauhFj00frxZdayYDTlUoP37zHI=;
 b=MVlbsYHVM1OSKxpS6Uj3BNiI3IvsUXVsTUH9+02UuxTzyF262tA7sPdKm2cqt7tPAzCu
 +E9jjAa1D8HAHMiLnJn2IykS4SKNsfSfPURV4PRRQHsW378C6QtZjCWelDGEO5zQv6HM
 IGbLWe0If8DAcgNkdZNI+4w7Tj2fYgb9Ne4nl2mElie2bGguvEa3YirYr/jhVxUF9Sq2
 ikZ29QcvBwbVVN1yirdesEKsYlmAacnZi4hjpnhFJ/Uc6pU8Lu8Jsd/xWYJRk55QJFT9
 NMAKxamwn4hc2M1aO+57bUNFSubWXP2yBig5+ermZ/IntRjFn6xTTWPwTghge7c7XZTO /g== 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2109.outbound.protection.outlook.com [104.47.58.109])
        by mx0b-002c1b01.pphosted.com with ESMTP id 38fm9c9c7q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 May 2021 10:10:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CVjPMgTLMDIRnBTR404DEhTAJCgppPI8Hapb4FfeMrNcGH+NUGZeoTtdOkdO01zZ1P4uHdxPc2iYtax7OmxFCGjMVCkJqTyHkQqjRoPUGl45hYlYRRDVZmgBhVCbtmW2cZtf3zzBLv7Xb3Wg+mYRLTyVy73t3Z5Vpxw7RlFAbuHGcf+OszowkNpw0Q91GIyljvzZLh+jzvuxARP/juFjppYYkj+xez6rl0uZDhmNdnj2bAxM81TBxZW61rLkPnimnc6JLRL7I8mygYiEpeU3styeAvtMMcXJMdVabkp9br11/cMmEr737ON2YbX1a6FSHOTI8MuXiRKmdlZgHSvJDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F6zEC8v8M9F5PIeJtauhFj00frxZdayYDTlUoP37zHI=;
 b=OTSaBF7/WNtKpgM/eR/3fCSdgI+oWEE+4IqvAg2D27kudvxSej89c8tR0qhLjbxxmLqFo+h7lcOjjBNtb9mHxT1mpM0pSbKfWLzUpC+BJKdCFXWK4oXlub/8M53cV2T3KVOfXbbvF5y8yApVnx36/l+uu31Cge+YBbW1WPWb4W1ddwSXr9VT6tEQFFEGkhikIw7XpdvQxQIWOTjpTGo3QJvH6sZe0WLmLOUK/3DrzAn/3mV+ZwZc1pJia15LlQcg4SvP19yqu4rVdHBokH+Ftv947eSTbsdNFSFeaUiJxKiAh7ZX5iibGP4qUGO/N6G+APzlLw0tojLwonzIs+ZRWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from BL0PR02MB4579.namprd02.prod.outlook.com (2603:10b6:208:4b::10)
 by MN2PR02MB6623.namprd02.prod.outlook.com (2603:10b6:208:1dd::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25; Tue, 11 May
 2021 17:10:44 +0000
Received: from BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::75cf:5b99:f963:cc07]) by BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::75cf:5b99:f963:cc07%5]) with mapi id 15.20.4108.031; Tue, 11 May 2021
 17:10:43 +0000
From:   Jon Kohler <jon@nutanix.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     Dave Hansen <dave.hansen@intel.com>, Jon Kohler <jon@nutanix.com>,
        Babu Moger <babu.moger@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "x86@kernel.org" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Yu-cheng Yu <yu-cheng.yu@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Petteri Aimonen <jpa@git.mail.kapsi.fi>,
        Kan Liang <kan.liang@linux.intel.com>,
        Uros Bizjak <ubizjak@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport <rppt@kernel.org>,
        Benjamin Thiel <b.thiel@posteo.de>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Juergen Gross <jgross@suse.com>,
        Fan Yang <Fan_Yang@sjtu.edu.cn>,
        Dave Jiang <dave.jiang@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ricardo Neri <ricardo.neri-calderon@linux.intel.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v2] KVM: x86: use wrpkru directly in
 kvm_load_{guest|host}_xsave_state
Thread-Topic: [PATCH v2] KVM: x86: use wrpkru directly in
 kvm_load_{guest|host}_xsave_state
Thread-Index: AQHXRn60EiNtzlJMoki1ZErBKAvrd6refSyAgAAGQQCAAAC8gA==
Date:   Tue, 11 May 2021 17:10:43 +0000
Message-ID: <1590C6A2-CA65-4110-BD1C-DD9E24EE4394@nutanix.com>
References: <20210511155922.36693-1-jon@nutanix.com>
 <ab09f739-89fa-901d-9ee3-27a6c674d9a0@intel.com>
 <95947b5c-9add-e5d3-16a5-a40ab6d24978@redhat.com>
In-Reply-To: <95947b5c-9add-e5d3-16a5-a40ab6d24978@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.60.0.2.21)
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nutanix.com;
x-originating-ip: [2601:19b:c501:64d0:68d9:a99b:e44a:d275]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7e215847-b36e-4824-303e-08d9149fb644
x-ms-traffictypediagnostic: MN2PR02MB6623:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR02MB662324BEA1C311FB1079D674AF539@MN2PR02MB6623.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wGc4PuxQ50epQN1uE/GR/cn55uAbEHkOCqflWSzCF3hCpT2Mt0y9Cvtd+tV9266gKLFJQmilG5gia+egWqSt4A/bwBbe1W0sFFQqO6NFCfVSg2dKe3KpDfOhiDK3ON6jWIMzsouKrkCw86s74wtoak0NL4Oy6z4HZUl/Zc+ebkGBmfv5H3g8I2ClemMXiXhCFLznBqMmTrsfGioeFo/AhUo7P68SdsMG9yZxeUzsjKnO+/ZVYYljPA6woAmD1LGjB53yMuOhtm8nBdGxSp1QwDmTUPDDAggZpg1A+hQAU+0D2P6/D43b9Mdlil72tOteHxKBnJwOg9EOsvkuyVYhbggZ+sVvIGkg261BeCtn3AprQHS0TCcXhoozCnXD1pq0BmTorJrFUWAsm5AFM5luhx/RYvu3rLpQdA3yjKOXrWj1HqaD1I0CdRsgTVp57WCboEv1jPWwFuhygpeGVBVEbBC5/r6S/yRP3clRVJCOIYbtxuQn3me9FCKlwNJMPLWT4GgQHGhfkVaMm6m05bNCT+rgvnUs7wM+iXGzQIjXbO7iTE6WEQqloW/zXYdFnaKb4g5lgA54H0fSSRHgKaxd49hnXVtJo2YUmuY41ZInddj4dUBCPBmfw/EZVNzkNVZ2spfspaOZ1DdtHSj0StCvDbg7OFQVUTPXaA40OH6SuWI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR02MB4579.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(376002)(396003)(39860400002)(136003)(53546011)(54906003)(33656002)(186003)(8676002)(6916009)(478600001)(4326008)(122000001)(2906002)(6486002)(2616005)(6506007)(83380400001)(71200400001)(66946007)(66446008)(7406005)(66476007)(36756003)(64756008)(76116006)(91956017)(6512007)(66556008)(7416002)(86362001)(5660300002)(38100700002)(316002)(8936002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?aRcdculK5MsO6UOnlpImk1ALFWFR9mBPgYt54gQ0QkEBOsGnPtTPfLyOqEMm?=
 =?us-ascii?Q?tHIQv60MUdpn0ZtoLKaBWXrF6P68vYaFsJzun72mLGPe7eX73KYNv34eIl2I?=
 =?us-ascii?Q?HP+NUTKgNpVXJoYLAKu4SGGoq1ttYM2mXb3EwR9uPwJo6pa2kFmsIUufa/lk?=
 =?us-ascii?Q?KCoOJBf16pmmHLYwtA57x34Gpr1QCxj/462GOT062a+bVEBkzZ/cGEue1AzQ?=
 =?us-ascii?Q?WWPp4utLGeO7vOnuoQd+FJlHT0YFpFzSUJUr8cLTS+NWvctL5UUQjTweuFO4?=
 =?us-ascii?Q?dhDaYQ3A8bFhKSVP0Kt/UU4LZ7KNe9jFuxLo9T290BjST0PnJrJJ+kmY+Oth?=
 =?us-ascii?Q?K1dVoSDiK4fWLg+4sOw0GNhBVxde3bVdUXg0kt/cc9DpFBJNeJFGBKx8WWSe?=
 =?us-ascii?Q?KLskjSq3pzUoipOgYZfupFvSXOSGSwUgY71dXUn6EDhxgCvTc5jkrxpG5rn7?=
 =?us-ascii?Q?EygkstvkGybBOjVTWevYItwe11jkxc52o6/lDyRBLl7XxJtd9gcHqsPXBOCF?=
 =?us-ascii?Q?vIS/5AheWt2RgC9ALsTsIzV8ZiQoHBwITMJbITJgtp1pYN/5y7syOX6MUdtj?=
 =?us-ascii?Q?+c4gW0Vr8xtlK/VezyQ7iL2lFYiZb5KzEyBK1z+eVjvksgsO8yIkPkOuT9b4?=
 =?us-ascii?Q?mzinlIAcBHJOR7/o7y/XGyBBYEn8D6ObaGt9h6uL0WVqS8I7Q0RsY2zsnOX/?=
 =?us-ascii?Q?y49B5sZBvljUc9FtdHC7hZHyZZL3QsazEzO7X3AStnqV0tO4gQzi+Oih7A/9?=
 =?us-ascii?Q?JD+dpN4hhyHI2Wlu15skmxxVFjCc2q9HuzG/u7ULFrRKFyd6zdmqWt6P3yAF?=
 =?us-ascii?Q?QKE3DFzhc4qIC3ns2ABFzBm3muPDT/cFb78uY8egSZVO0bqPNa3mpCmKmHYC?=
 =?us-ascii?Q?EDHxZ4ENAqNfrmMcY8n+lwllzo2fcFHj57PHXNSUeqjcUtvaQU/XHQHZCBWu?=
 =?us-ascii?Q?QWzigpt5D1A6h8YHmD8IU9IbjZJxFuEe9luuAp9BVKXZyXHem671D7Mv8sqs?=
 =?us-ascii?Q?FuF4hYx0d63n5Fd3c7TQyAfL3c0THwGokAqiZHcdFLMk2cSSGTLHiJLJNLhh?=
 =?us-ascii?Q?OM6kgANZNDpD/ClEg3nMxI+6+b74iUqH+butX+IJeGva/rrABp8CNZJ/e2nn?=
 =?us-ascii?Q?jCU/GFp2zilkEz46QiNn4PSFiFai8JGyiY9ulban5lbQWUT80JSlif8ocIS+?=
 =?us-ascii?Q?V8ic9T8cIZEm8mDl+DKEY09jRmn0XGKGAscb4KytSBrd7MQXvn5Est/FQKPV?=
 =?us-ascii?Q?jV1inHzZXkhgzDn6jRUJT3O/VgsHbi3Ma24KjK3BchZJFOOCddmkdiAepC01?=
 =?us-ascii?Q?d3E5vhhnHIDUSi3wmCfsMI3KlWlD7JWMmxhz53VcKB3BEBg3npIoY6C8kXwn?=
 =?us-ascii?Q?Vq79I5TDERfteBAqSJ7MBsgAb/Nl?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <FA720C7A3E980D4EB17D4ED394A80D5E@namprd02.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR02MB4579.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e215847-b36e-4824-303e-08d9149fb644
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 May 2021 17:10:43.9443
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UH98tJmsLykoH/mUq1/kxvexUButQFwaYZcRCdRUb2l0+VH81QFQLfY248oq+J8wcFUVwiZPVBfeAsEKp23jZH8nFzPZykR0aZRWN3Yf+DQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR02MB6623
X-Proofpoint-GUID: 6DFaLmnpioBAzFQTPzGzOKaf68qn54wo
X-Proofpoint-ORIG-GUID: 6DFaLmnpioBAzFQTPzGzOKaf68qn54wo
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-11_04:2021-05-11,2021-05-11 signatures=0
X-Proofpoint-Spam-Reason: safe
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On May 11, 2021, at 1:08 PM, Paolo Bonzini <pbonzini@redhat.com> wrote:
>=20
> On 11/05/21 18:45, Dave Hansen wrote:
>> On 5/11/21 8:59 AM, Jon Kohler wrote:
>>> diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgta=
ble.h
>>> index b1099f2d9800..20f1fb8be7ef 100644
>>> --- a/arch/x86/include/asm/pgtable.h
>>> +++ b/arch/x86/include/asm/pgtable.h
>>> @@ -151,7 +151,7 @@ static inline void write_pkru(u32 pkru)
>>>  	fpregs_lock();
>>>  	if (pk)
>>>  		pk->pkru =3D pkru;
>>> -	__write_pkru(pkru);
>>> +	wrpkru(pkru);
>>>  	fpregs_unlock();
>>>  }
>> This removes the:
>> 	if (pkru =3D=3D rdpkru())
>> 		return;
>> optimization from a couple of write_pkru() users:
>> arch_set_user_pkey_access() and copy_init_pkru_to_fpregs().
>> Was that intentional?  Those aren't the hottest paths in the kernel, but
>> copy_init_pkru_to_fpregs() is used in signal handling and exeve().
>=20
> Yeah, you should move it from __write_pkru() to write_pkru() but not remo=
ve it completely.
>=20
> Paolo

Thanks, Paolo. Just sent out a v3 with that fix up included, so all of
the previous callers should be at par and not notice any differences

