Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 589B026EAE9
	for <lists+kvm@lfdr.de>; Fri, 18 Sep 2020 04:02:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726588AbgIRCB5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Sep 2020 22:01:57 -0400
Received: from mga02.intel.com ([134.134.136.20]:9326 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726559AbgIRCB4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Sep 2020 22:01:56 -0400
IronPort-SDR: XKg1Bd1Ar6jtsWnp4BRaPbHDQGu3+nPiPQh0mAypDs82pZYqWUABrn+TufnYlO7tPY7GhCXTl8
 kuBGKicq/xaQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9747"; a="147519848"
X-IronPort-AV: E=Sophos;i="5.77,273,1596524400"; 
   d="scan'208";a="147519848"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2020 19:01:49 -0700
IronPort-SDR: u0IPqO1dPLyUdcxT5WqP2QBoYoVgOeF0T0HWHG3n7gj0rOpfrbk7o5GkDbKxId3YE/ZWZSZqCz
 mRZ0TsoIfeTg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,273,1596524400"; 
   d="scan'208";a="508672197"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga005.fm.intel.com with ESMTP; 17 Sep 2020 19:01:48 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 17 Sep 2020 19:01:47 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 17 Sep 2020 19:01:47 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 17 Sep 2020 19:01:45 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.175)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Thu, 17 Sep 2020 19:01:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R1kxscj28EIgGuXZ1hMNHLK/szn7bDIby1Btc3rP5ypctPDupYt9YsG4v2+Po0HhmXFnznt3serFLPKH2jz4ukngr7lcDdIvQOskJrrU2tHNuOv8Bgiy3J+uVBaLQNCZzTRiJm2/Tfx9r96/sO31k/h9+QxYUV5kTZSxSaYdPx4ehCpy9oV4B/lLp1/bVEn7nuZ3ETMQ8zzOxwPUY6Pi/A8TIn9APVxnn4+8GGdF3tpUr20o82R5XUd+Giq03CWn7UxT5Pdgpodq3qA0w+2eEktP3sqAOUckc5OCVvjR7l3VYk4xb+bp4xccEaZEXL15cNE08kdCSoMnPTc96RlpTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=07PSXNUmtiv6bwz+Tg+9fHcA8h4FAgrkozuYvjymNyo=;
 b=KqwQYXKOoOnC46ciGOosnt2qA4XpstZeReX+qcDRzuADvuaLjeTNCqVwtJ6ua9MHIulo5pOh2FHjIrjTYBj/O1OQL+amESZDPPou85sBZa8uSMgbABbpVbvopbtATQrLf9AVux/WAYhP8hwweixhEL+5BrxGdqqJjAGkCuetTM4nm/UxBEp1uS9ZheErCi+jjBXWA8K8ka8geJCI4NBUuvPWt8VM5CKLLaDe8zL3bbgfWOsfEwoRzFOMJ+wlt78l2PF+Wfmbc/JSdPRrFLhV3c0pqysrindYqUDrP/WXoqmL8fat+K8g/jXZTM/dKsLAtXPIur/wOFHcyQ26uWKLtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=07PSXNUmtiv6bwz+Tg+9fHcA8h4FAgrkozuYvjymNyo=;
 b=QZb4cQcyxLWRn19YVCW7IyMCTFt3w2bwZebHxE9PhVT1fW33PsNMq7h9JqUc7LuFxfLowfMW1WPRZ+3nxb3Ng6+pVdRHf7XtBDUGquqmSvrPcwstzF22TGU4LhTZbSrSvn6Pj/tmmjB59F4U9Me04jRjfNM6/stq0h2ywz60RnM=
Received: from MWHPR11MB1968.namprd11.prod.outlook.com (2603:10b6:300:113::16)
 by MW3PR11MB4731.namprd11.prod.outlook.com (2603:10b6:303:2f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.15; Fri, 18 Sep
 2020 02:01:42 +0000
Received: from MWHPR11MB1968.namprd11.prod.outlook.com
 ([fe80::fcf5:948c:28d7:7ee3]) by MWHPR11MB1968.namprd11.prod.outlook.com
 ([fe80::fcf5:948c:28d7:7ee3%8]) with mapi id 15.20.3370.019; Fri, 18 Sep 2020
 02:01:42 +0000
From:   "Qi, Yadong" <yadong.qi@intel.com>
To:     "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>,
        "liran.alon@oracle.com" <liran.alon@oracle.com>,
        "nikita.leshchenko@oracle.com" <nikita.leshchenko@oracle.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Chen, Luhai" <luhai.chen@intel.com>,
        "Zhu, Bing" <bing.zhu@intel.com>,
        "Wang, Kai Z" <kai.z.wang@intel.com>
Subject: RE: [PATCH RFC] KVM: x86: emulate wait-for-SIPI and SIPI-VMExit
Thread-Topic: [PATCH RFC] KVM: x86: emulate wait-for-SIPI and SIPI-VMExit
Thread-Index: AQHWjJnLRj87Fqi/UUSARkmELHUnGqlsh5wAgABmQYCAALUAsA==
Date:   Fri, 18 Sep 2020 02:01:42 +0000
Message-ID: <MWHPR11MB1968E9F0BE3745C3D8A9FA2EE33F0@MWHPR11MB1968.namprd11.prod.outlook.com>
References: <20200917022501.369121-1-yadong.qi@intel.com>
 <c3eaf796-67f1-9224-3e16-72d93501b6cf@redhat.com>
 <20200917150217.GA13522@sjchrist-ice>
In-Reply-To: <20200917150217.GA13522@sjchrist-ice>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.55.46.36]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 98d004e4-43a3-4cde-e058-08d85b76ca2d
x-ms-traffictypediagnostic: MW3PR11MB4731:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW3PR11MB47319BC01E5CA179755BC44DE33F0@MW3PR11MB4731.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XSppooCT01KpzKbDi/Ds79e1A1Cg4VMOYhVQXgmtLw2OcQG6rxovvAMnkwcMTt5f01MVbHw+ujr7QUG6sZTNdKNYP9PS+Q6dcWYCiaTyDf2P5gxBgfhBX/hKpTgWALebdjVWrYkaMoO4s2GZp8iOkZ+vD5XcQ4DmQWrEPdhB7rp1HUyiDRuDo5mw8VhkRAuOT+ZXthbvwr0obcd5IGsC+T/Fwbq/XefESrzCHQPx68mNPnIHoUPLrqDRtOEij0SMgnv9MLbROsc9bVEkq112CLw/HyhyWeix5KCZL5afTKc6PG3BGQ/5e6GPjD0EItRoD2F44OLroUvatg3seZQyDDuU5yiNsOnqRmEQjKsUdp2m88wTb8iDL6pibCkdzvgu
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1968.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(396003)(136003)(346002)(376002)(478600001)(6506007)(7696005)(53546011)(2906002)(110136005)(7416002)(316002)(26005)(186003)(9686003)(8936002)(55016002)(52536014)(66946007)(107886003)(76116006)(54906003)(66446008)(64756008)(66556008)(66476007)(8676002)(71200400001)(33656002)(86362001)(5660300002)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: vVwMINO2k26NeQPEEo1eKtagcJC7SVhM+N+bqXtB7coL3dOFEcZrLg2HCAEnHzUKneVzGDkoAdddVXwI7o/f0vI8PAskRDB19QHWKzDOjsNYmyAi9nozQYrbHmmaZ3C4PGgqRP0NOpRZ1es0+AQdvI0VnQN5fAht7Lu7IMKLbRSyHJz6yprDvsXKf6fakGxGNSOHo0D4gnGoN3bFygi9zbZ9FxfCAdDljTEKKYbzSwTGzTB3tbDdIXtKq3A31Mpy9EuvccFOfwMH6C5rLOzFbGb1taHfW2Qym8MJA08BkxC6JASiFmhxn+AH4PyTCURfxTUJTgqSJcFW6Ov62hXcC1xmJ2aKmetSA8+uE/dnJTkvRdckJ8AkwIZCsTCvoQGpfF4KfQuLuCQQ/US6ZFB+XIfXVIX9LP65R6xQQg4c6f/Gw4ouHfNUBinJ3YY2YLfn14ni01Cc5mBuSQwEHdImonokTs92A25OImz4Rk9GVkBLxLOMmze+DUIvRcZz5VdUUQLciXXvOkYFGWVvSHG/CfyNhFwc2EEGQFcs2G6ape85YfGkJMIJC+4coXLLly6gTJXgtUmzVoNvhAFhCmbPqnFdY7JOLxcPDuVJEKJ36ZgbCYNUVlOK0m/NMuffB2zCRdwZr45PVawPROE3r8Td4A==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1968.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98d004e4-43a3-4cde-e058-08d85b76ca2d
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Sep 2020 02:01:42.6978
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 52epRsH5JmKSboZZwBfrZrkFdk79rlqVLJ5/hx1Tz6+XV+0DUq6LgWJztzE1G/3apmPt8we+CecAe2Q+5zpUHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4731
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Thu, Sep 17, 2020 at 10:56:18AM +0200, Paolo Bonzini wrote:
> > On 17/09/20 04:25, yadong.qi@intel.com wrote:
> > > From: Yadong Qi <yadong.qi@intel.com>
> > >
> > > Background: We have a lightweight HV, it needs INIT-VMExit and
> > > SIPI-VMExit to wake-up APs for guests since it do not monitoring the
> > > Local APIC. But currently virtual wait-for-SIPI(WFS) state is not
> > > supported in KVM, so when running on top of KVM, the L1 HV cannot
> > > receive the INIT-VMExit and SIPI-VMExit which cause the L2 guest
> > > cannot wake up the APs.
> > >
> > > This patch is incomplete, it emulated wait-for-SIPI state by halt
> > > the vCPU and emulated SIPI-VMExit to L1 when trapped SIPI signal
> > > from L2. I am posting it RFC to gauge whether or not upstream KVM is
> > > interested in emulating wait-for-SIPI state before investing the
> > > time to finish the full support.
> >
> > Yes, the patch makes sense and is a good addition.  What exactly is
> > missing?  (Apart from test cases in kvm-unit-tests!)
>=20
> nested_vmx_run() puts the vCPU into KVM_MP_STATE_HALTED instead of
> properly transitioning to INIT_RECEIVED, e.g. events that arrive while th=
e vCPU
> is supposed to be in WFS will be incorrectly recognized.  I suspect there=
 are other
> gotchas lurking, but that's the big one.

Thanks, Paolo and Sean.
We will continue to investigate and submit a formal patch later.

Best Regard
Yadong
