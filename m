Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAF2937699A
	for <lists+kvm@lfdr.de>; Fri,  7 May 2021 19:48:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229476AbhEGRsj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 May 2021 13:48:39 -0400
Received: from mx0b-002c1b01.pphosted.com ([148.163.155.12]:54644 "EHLO
        mx0b-002c1b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229446AbhEGRsi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 May 2021 13:48:38 -0400
Received: from pps.filterd (m0127841.ppops.net [127.0.0.1])
        by mx0b-002c1b01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 147HbZ06027166;
        Fri, 7 May 2021 10:46:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version;
 s=proofpoint20171006; bh=2baEVHFTzQu/Fsmzwz/FJwqFeHtU5fWuYgKRMk3Elb0=;
 b=XMDGq8nyjc6Omj93dnq5V2iMnw9UcDuixeNGBV1wwQrBtOooug9DcHOf0AKlRb3hit1b
 UeEWKbZ3n8Douo464Hi04e3yhHOCuDNSzlsbpVwkSz5HQQdZoosYu55lFUAnfbKLgEG7
 BJs963i4gxAnQqqhTKDmRpSgxWPhYLi0LPpyaBr34GrfzysYnCUqozGNo9sNkcqSGf3Q
 jnfqu4AU+kFQXPwEBRrCF1ILgS3smCzsO42kMmix3e6d4XRWaoO93sjmt5M1YTOcTr50
 2vWCGSs6n1/okHuZd3eSukznwMrKC4M5bvOhSYZGdrTfABqL6dMXYnUxFfpYuUJRRmut iA== 
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2043.outbound.protection.outlook.com [104.47.56.43])
        by mx0b-002c1b01.pphosted.com with ESMTP id 38csqgstm8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 07 May 2021 10:46:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FZt1ESnrorVrwQT11mL42d3nuNExalZ/WpFK1Al03B6aXEY23TAo2dBoy2tPhiuAk9wpP59vL5O7QqjDppLswqTkCcS+YKPsEX42CMPC4FNFpYjkQSztUuFdPQ3B/r7ENGA1Ku/LC8+N9HcpfAnYu5x5qaYS7FgObyL0QQ+19hH4ak4UmAagNEmnXifFRCsqHW2nAFGJW1sktfN0J1daDMg+TJtZYNqALTE98h/UVosbfICSkCAw6HcLpQknDSvFE6f9ljAUeIx2PXgFzoW7ip9qwWR6B/7vjGz2bQ3U7aV4zXd5yLQ7UhqGWg7Bs6UQvS669vwxuzSLALfWHCNv5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2baEVHFTzQu/Fsmzwz/FJwqFeHtU5fWuYgKRMk3Elb0=;
 b=nPSP2k4S1u0IfQeI51yXGudjKo/tGo1C5+PAoevcAetsoZXbKQTMrZW64RIr+ARxKpCp88dZWJu9DxbWvaiw1ivBrxWogv6jEBrrMQP0W/9r/JUQ4ZHpksc3ERorN/HzOmDQ9U/rU1I7l531l2wIi2MlMwfipYLWkSfFIbq6LEuYDzraf3TCzBjbcquEQuEr0jJW53sFZgTp/J3TqCUegtkPw5USA4YmOFD9XbaqyFgtedfQfcFK6RoBE3MHRJASyMJW+25kfGqnhb5+i1b7+wimYUYEl9SxF0YfiHG2QQPH4scR8TZ6Mz8ZD1LIQjJ4eC4ZCs6jgVpz6lRap7lz5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from BL0PR02MB4579.namprd02.prod.outlook.com (2603:10b6:208:4b::10)
 by BL0PR02MB5377.namprd02.prod.outlook.com (2603:10b6:208:37::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.30; Fri, 7 May
 2021 17:46:47 +0000
Received: from BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::75cf:5b99:f963:cc07]) by BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::75cf:5b99:f963:cc07%5]) with mapi id 15.20.4108.029; Fri, 7 May 2021
 17:46:47 +0000
From:   Jon Kohler <jon@nutanix.com>
To:     Venkatesh Srinivas <venkateshs@chromium.org>
CC:     Jon Kohler <jon@nutanix.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "x86@kernel.org" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: x86: use X86_FEATURE_RSB_CTXSW for RSB stuffing in
 vmexit
Thread-Topic: [PATCH] KVM: x86: use X86_FEATURE_RSB_CTXSW for RSB stuffing in
 vmexit
Thread-Index: AQHXQ1KpTcM7v9elUEKaZTZTLSZ4qarYRHKAgAAGz4A=
Date:   Fri, 7 May 2021 17:46:47 +0000
Message-ID: <1D930225-038A-41F7-B88F-137B798B9AEA@nutanix.com>
References: <20210507150636.94389-1-jon@nutanix.com>
 <CAA0tLEoyy_ogDc11r_1T907Rp5CwgM64hFwRt5SX40THp2+C3A@mail.gmail.com>
In-Reply-To: <CAA0tLEoyy_ogDc11r_1T907Rp5CwgM64hFwRt5SX40THp2+C3A@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.60.0.2.21)
authentication-results: chromium.org; dkim=none (message not signed)
 header.d=none;chromium.org; dmarc=none action=none header.from=nutanix.com;
x-originating-ip: [2601:19b:c501:64d0:a9a2:6149:85cc:8a4]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1d1a852d-d106-4b2c-8afa-08d91180164d
x-ms-traffictypediagnostic: BL0PR02MB5377:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BL0PR02MB53774F3A41794A22C4A65006AF579@BL0PR02MB5377.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /BOFs5/X5+xnXs4j2RO2+8frUiuahc9l6wRP8vsDYNFVpk2JQjZ/7b46lRStBRxk79h9SxVZrRseqWahtsqT++QVWuoACV9+wYBg5HExLaShxWVLp2Ggku69yKxDHNBh3exeTJHTgPE4tVxtvRUVxkChD7ueZmIE/MPkWH9miMuhesexBoy9J/womzPq5Nofzt+IyAqHxU+Vwa0olQuI/GSxI51tNBgHK07uLnpheBGzDM2zwa6Dr8lhsRxfYddqJJGjVOgi+c5Re4bhcxwKg1WMsg3OGpLREoa0mVht3d6Uzcb/6rQU+votayKS6ebuYWOmPC2zU70aLQj1bPnCVUm/IyitdbeDAz1vGIlRYld97fxrMhmQLw5+VxZ5NlKyVhY26qE4LDC/nRAo6ypnz55Fk5Jp9BelY1g73+A1rGu1AlZHgVlpIScXx5tc/73FOzRwDF3ThS+C633TMALjkfV2ZBzBCL4M7Qr4y+i8FBLHUZs9QmSRM1BFV9CDrV2kHwdgCo91fMUR2K8/O6PTwopepVgi2UGGjpr/IxVR7PIqfS1XEifiLjdXjjqcLg/XStvBUvuqI7f3bkRjF2yryCVH20nrMLN19vX+xEYSXZeeL1NsXN852TvA5ZUSP187qzt9i8bGVVaL8+/ljvwk5ztb2ZnJ6CW1BYMQpQb7wxy6Pu9wZDA5sdr+YOrovGTwVBxvLO90mTAnZIaR0TYwWyXPs6jG8vtoHT9VjwC0rKpN95nZink5JfI+Z6Xz0g0q
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR02MB4579.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(376002)(366004)(396003)(346002)(2906002)(5660300002)(122000001)(8676002)(7416002)(38100700002)(4326008)(6486002)(316002)(54906003)(186003)(66446008)(66946007)(66556008)(76116006)(966005)(6916009)(64756008)(91956017)(83380400001)(2616005)(478600001)(33656002)(6506007)(71200400001)(53546011)(6512007)(86362001)(36756003)(8936002)(66476007)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?l1Dov3jkPe99+A7UZHlkIP1FuPbk2X0XdbNvgSHQVr9gbu9US5mgNKDpNSno?=
 =?us-ascii?Q?PCV0nUu1wbdF6B/4r/9Ll7jgwEmokdX6DTkUeucZYWl7/Bjo8vV49y0N0m8E?=
 =?us-ascii?Q?GksnvrSCG78C2VsMzP3otqCJmncNX0xCTOUQOR3v1Tvy0YLf+Kf6Sh4oN6fM?=
 =?us-ascii?Q?WURY8kzvlxGnd8R7I/o69TFaBmLzaWBLpE7qjcgIH2SKzOqQ+56AGOWULoHL?=
 =?us-ascii?Q?XnmemICib8dtwKCWOq8skzUCDrwHeNkDgdRvUEIYZmhyH2YOwryrcDK+bxvI?=
 =?us-ascii?Q?Z7K1r186IFQYcBrew5i/i29DpQO6lNp8ZdNPf21PXlyBan8uoBPxthC0CKj7?=
 =?us-ascii?Q?SNp2tuFUhAu3O6vv4mS4MNISTMKyLOdfixnIT5FLdkXkbqy1uYyylof15bK/?=
 =?us-ascii?Q?zY4VI2mbiSPfQ270hGhoFnk1IzFErMlS3GEImcS0XannzKeOgU/ftqukV/Hs?=
 =?us-ascii?Q?v9z0nmPq3l0OHNAsS8HQYWsIchP6hEFtaLjCFuQd9RX1we9VhGXnpca1pj2D?=
 =?us-ascii?Q?1o42iyhkpwtYQ3DhOShy1XvcnH6xeSdYsy4XfjN96q8HoePblJ/OEomLREFr?=
 =?us-ascii?Q?0YMIrRnCnw3NUAAWSyBOxJ2Z1dbMcZ0a6Pq49/mH0W5hsgP2/soqencyzHPn?=
 =?us-ascii?Q?XYVSPG2GjN1s94z2j03+3wjLs9UYtOOI3N0G9ttOqopPsnRcdbsVQ+Wazhaa?=
 =?us-ascii?Q?CWMn+1TjuCuT5jHn8i1u0piPC0RiZEecFvcyMuZNLudawkH0mfmkgU7AzEUC?=
 =?us-ascii?Q?pccfBwhV2LEtNvbI6y/zDCRyc2QVqjDovNld48BijNcpRV9OTXhhQzeLB250?=
 =?us-ascii?Q?6XNWZ9iuMopWvorKE5sPwzaRRMu1rOWHHXhbbRWK/qY5B4tbCu7avFvW/u97?=
 =?us-ascii?Q?QEBD2J8+V7foLxDBiaE0vVnFDLA43LANrLHeLSwiiJF0fiexEHv8Sbg3kY5M?=
 =?us-ascii?Q?zn9e1G4KRH+ydRUvJLdchJ51rVPTf0cuWusJg3mEwSQ0PHxPtYfJeVp5ifsW?=
 =?us-ascii?Q?QnzOMpAGyjbIPQrnUL0MpzfKq4O85u/mjw0HkWQBapaMc+8RD8e3rUrmiBeN?=
 =?us-ascii?Q?kWCMrCErd2xSnOPnzikjORyILpD8sqjPPyIv5UvDJAt5UsHzVMG36kYxLScn?=
 =?us-ascii?Q?Ae9OpKVXCmjBnePEU/ZuBhFVhF0s373PnKOmfOiTZQFg0fJq5PmZqowdngiv?=
 =?us-ascii?Q?EQWRLr+DR3/sWFCaF7gYD9sOPrinPt5ehBUct9VQptj28Yona6M8tQbGV9dy?=
 =?us-ascii?Q?UZvORnxaI3wrisBcfl95jqHlCm2GKDEoS6wFztpfa46eAQrBd67j0QMQQrjD?=
 =?us-ascii?Q?Ced9U6x57Qe0pdlbYllDTIADdoFisB/CFc/qCoh8kv1di1bWnRzU7xwBq1fN?=
 =?us-ascii?Q?BfOQ8rmj/KBqswm+F/UuNdMzNfkon+X75ZWcj9wtjGFpsbTmLQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F4370B5716BE964685165BE08583917C@namprd02.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR02MB4579.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d1a852d-d106-4b2c-8afa-08d91180164d
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 May 2021 17:46:47.6163
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hZwvQS4bJb8BprJmvKdcvz7JdxsK07RtMSwn8qNv7a9LXe9EAw5YNKlUmUxEY4oeeGLZnuz0kttdMAazOH3yXovil/83Kniy1tR3dCOKC5c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR02MB5377
X-Proofpoint-ORIG-GUID: 6CMmhJpo73V2_l-JUWn3tzVd8VwUP2k_
X-Proofpoint-GUID: 6CMmhJpo73V2_l-JUWn3tzVd8VwUP2k_
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-07_06:2021-05-06,2021-05-07 signatures=0
X-Proofpoint-Spam-Reason: safe
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On May 7, 2021, at 1:22 PM, Venkatesh Srinivas <venkateshs@chromium.org> =
wrote:
>=20
> On Fri, May 7, 2021 at 8:08 AM Jon Kohler <jon@nutanix.com> wrote:
>>=20
>> cpufeatures.h defines X86_FEATURE_RSB_CTXSW as "Fill RSB on context
>> switches" which seems more accurate than using X86_FEATURE_RETPOLINE
>> in the vmxexit path for RSB stuffing.
>>=20
>> X86_FEATURE_RSB_CTXSW is used for FILL_RETURN_BUFFER in
>> arch/x86/entry/entry_{32|64}.S. This change makes KVM vmx and svm
>> follow that same pattern. This pairs up nicely with the language in
>> bugs.c, where this cpu_cap is enabled, which indicates that RSB
>> stuffing should be unconditional with spectrev2 enabled.
>>        /*
>>         * If spectre v2 protection has been enabled, unconditionally fil=
l
>>         * RSB during a context switch; this protects against two indepen=
dent
>>         * issues:
>>         *
>>         *      - RSB underflow (and switch to BTB) on Skylake+
>>         *      - SpectreRSB variant of spectre v2 on X86_BUG_SPECTRE_V2 =
CPUs
>>         */
>>        setup_force_cpu_cap(X86_FEATURE_RSB_CTXSW);
>>=20
>> Furthermore, on X86_FEATURE_IBRS_ENHANCED CPUs && SPECTRE_V2_CMD_AUTO,
>> we're bypassing setting X86_FEATURE_RETPOLINE, where as far as I could
>> find, we should still be doing RSB stuffing no matter what when
>> CONFIG_RETPOLINE is enabled and spectrev2 is set to auto.
>=20
> If I'm reading https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__sof=
tware.intel.com_security-2Dsoftware-2Dguidance_deep-2Ddives_deep-2Ddive-2Di=
ndirect-2Dbranch-2Drestricted-2Dspeculation&d=3DDwIBaQ&c=3Ds883GpUCOChKOHio=
cYtGcg&r=3DNGPRGGo37mQiSXgHKm5rCQ&m=3Ds8fqknrIuUa_jGbbihj0anypC4jz86QQ7UzzA=
op3B7k&s=3DoIcZtb8S_gcK5L1yzfPvinSHxjCCsx1PNn-imPMffKU&e=3D=20
> correctly, I don't think an RSB fill sequence is required on VMExit on
> processors w/ Enhanced IBRS. Specifically:
> """
> On processors with enhanced IBRS, an RSB overwrite sequence may not
> suffice to prevent the predicted target of a near return from using an
> RSB entry created in a less privileged predictor mode.  Software can
> prevent this by enabling SMEP (for transitions from user mode to
> supervisor mode) and by having IA32_SPEC_CTRL.IBRS set during VM exits
> """
> On Enhanced IBRS processors, it looks like SPEC_CTRL.IBRS is set
> across all #VMExits via x86_virt_spec_ctrl in kvm.
>=20
> So is this patch needed?
>=20
> Thanks,
> -- vs;

Venkatesh - Thanks for the reply. I read that the other way around, wherein
RSB overwrite still isn't good enough on eIBRS, so one would need to do all
three of the following to be in good shape:=20
a. RSB overwrite sequence
b. enable SMEP
c. toggle IA32_SPEC_CTRL.IBRS on vmexits=20

Said another way, the document reads like one would always need to do the
RSB overwrite sequence no matter what. Happy to hear if that is not the
case though, since RSB stuffing is a little expensive.

Note: I also checked the Intel SDM to see if perhaps there was something
there about this, but the document you linked is the only one I could
find on the topic.



