Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFE143D0CC4
	for <lists+kvm@lfdr.de>; Wed, 21 Jul 2021 13:09:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238151AbhGUJsS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jul 2021 05:48:18 -0400
Received: from mga06.intel.com ([134.134.136.31]:58471 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237919AbhGUJVh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Jul 2021 05:21:37 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10051"; a="272521459"
X-IronPort-AV: E=Sophos;i="5.84,257,1620716400"; 
   d="scan'208";a="272521459"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2021 03:02:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,257,1620716400"; 
   d="scan'208";a="470107477"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by fmsmga008.fm.intel.com with ESMTP; 21 Jul 2021 03:02:06 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Wed, 21 Jul 2021 03:02:05 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Wed, 21 Jul 2021 03:02:05 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.173)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Wed, 21 Jul 2021 03:02:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O7tnOp0+vwjT9+RdxvgxXbmT1y+T1iNg0k0V2J+55JBKkwL05QSKx0KtFnuVA5bVXu2VCjqz0URQcOdGAR1N+IRiI0LdkEXPuWDvZ7fGQ7lIH7h1rKfFtbZaO8p0JL8pxQBhKeWMjnDm96sgq+X0Gj4BMnObg90das37WGqo1UoeG6H8C8eMh++/IJ1MERc+IMJ5d4Wp2zOc276kki2Sbz73HZy/KnVKLIymm++jT7gNwiuPI16ViFy3KndMsF0rAcqw73Xu0AZko2quDt4aj85FiorZK6W/MZCeM3H5MZ2vL6ccNIOwIAhP9s7UomzezWnC9TIAZK+GZhADIpQQXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zAWjP+Vp2B+XLtJjxmEvx5hz2qErRTfk/uA2/Lc5QlQ=;
 b=GgYYHrGLXn5zIhFHUaPYCufPt8qRWUBJNiXycJI+RipFdKlZ+eSUMRihZi4RR+lrg3gz0lHQyrgio38bptVup0PFxm/gdyNj0WFTRSJmWIemRekm5vQ7XMi2cAd6pEqXBa8rwffiQpLMmsLMQRckWC/NajQ4PUARUpm3rBHU+MBG6W2cREHlsNwmajgsheR1OHS6cdkyeC1CQYEKjpS9NJ4PsBJN4FCYmbwmwrvBO86ujNFmm//A+Z+EjXPxafVYkf5bHAe4OKVGmaP9tBCUxWaysokytkrU3E0UngRGUEHrJ787xUWmgbJJkXa/mUlPfLZ6K36NyjnwxYnMr1vfsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zAWjP+Vp2B+XLtJjxmEvx5hz2qErRTfk/uA2/Lc5QlQ=;
 b=QVkS/OLLdCwMNvDua6aLZuyWN6jKuNsQxzZXRQm0TS3sA+ZaC1IA0Kzjkk73trS3DvagyQgc64YQGAZMRLufs1h5EsQajQoOeW5QKTOqBaXhNIGKgsT/fGmxFVTnHJ1UicaPC6IKl3DBrulyOB7rjnWgT6DXlKV3mFPfKxX9fFA=
Received: from DM4PR11MB5453.namprd11.prod.outlook.com (2603:10b6:5:398::15)
 by DM4PR11MB5551.namprd11.prod.outlook.com (2603:10b6:5:392::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.32; Wed, 21 Jul
 2021 10:02:04 +0000
Received: from DM4PR11MB5453.namprd11.prod.outlook.com
 ([fe80::38aa:9c52:efcd:4652]) by DM4PR11MB5453.namprd11.prod.outlook.com
 ([fe80::38aa:9c52:efcd:4652%3]) with mapi id 15.20.4331.034; Wed, 21 Jul 2021
 10:02:03 +0000
From:   "Hu, Robert" <robert.hu@intel.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
CC:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Robert Hoo <robert.hu@linux.intel.com>
Subject: RE: [PATCH] KVM: nVMX: Dynamically compute max VMCS index for vmcs12
Thread-Topic: [PATCH] KVM: nVMX: Dynamically compute max VMCS index for vmcs12
Thread-Index: AQHXZIuB9zPySR3qkk2RxIcrlGLzAKseKLEAgAAIJYCALy/4cA==
Date:   Wed, 21 Jul 2021 10:02:03 +0000
Message-ID: <DM4PR11MB5453A57DAAC025417C22BCA4E0E39@DM4PR11MB5453.namprd11.prod.outlook.com>
References: <20210618214658.2700765-1-seanjc@google.com>
 <c847e00a-e422-cdc9-3317-fbbd82b6e418@redhat.com>
 <YNDHfX0cntj72sk6@google.com>
In-Reply-To: <YNDHfX0cntj72sk6@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-reaction: no-action
dlp-product: dlpe-windows
authentication-results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4be4a210-c5f7-49b2-d3fb-08d94c2e9745
x-ms-traffictypediagnostic: DM4PR11MB5551:
x-microsoft-antispam-prvs: <DM4PR11MB55516D3FE3F9ECB0D098D91FE0E39@DM4PR11MB5551.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PqqWt4jY924UDURcYdVHyztEhtp/h57Ma2BDCv24bsQbI5uC2Wy9FYHCAYAGmfyTpuFCWlKUrGneFqY5bGNMUosLRhleRk5x3Y/lz5hCNdvnduu4choGAbYb+Zwok6UQgh+7cOFv1E5URz7OCRxVCSTRzTL8i7PDYlaPnrHUv+g8owN62ltVe0QIWcpXc5yzHDYTMeepopctmtoitmjNYi3QN1EVjJjpH82+cMTBFC5ekMmEv3P77XOgmIzjtCdhHytxPLBTVRNUclLflUfBWJjmNUUL894xuF/w7YiK1BW1QZgjheV2bc5Z++VeDSAoRAq/MRsJ23QjYoT/81ZWpmraiNRWhFk4wDEwvruvnVHa4T1LmO6ZyWfFdEWgGowhiUyBXtzoGe7DfDbrfZQqJBfE5ywwA/HxD1wxEGPlk+/9+Xtl59ujGrC8IA2NbEcCcdzOj8BU9FGp6W7nqMwuJXKxSiGY0Gtn7w8mD+4jiX3QBS3IYEsjSoufkxDH4v9NbtzwJKhzIZvTQnu354aUdkbpT0nUu0wYcHpKLYC5yOapM4q+PV8PPKef71qWKNMZf9SimLVywqaYR/oaM5Sfjci6C0Rwo7M/bmMGsdxf9axGi9jrLyOZku1ynwp7tBx4z2CSZVXRua1v/jGDDx1z565WVhMTeIWMWnrsJDveI6hI3aNTp9tirrQZnAAqZI2RwRS9jd5Sm8M+UcatMOqO0w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5453.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(136003)(366004)(39860400002)(376002)(7696005)(8936002)(8676002)(186003)(55016002)(83380400001)(52536014)(71200400001)(86362001)(110136005)(54906003)(5660300002)(64756008)(66446008)(6506007)(66556008)(4326008)(66476007)(76116006)(26005)(53546011)(316002)(66946007)(122000001)(38100700002)(478600001)(2906002)(9686003)(33656002)(38070700004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?tu+6aGt0+DQwt0K4atvtuMnGSnqvyGn7Ba7pHY2z4TiBjXs+qR5VmdBAmRk6?=
 =?us-ascii?Q?Z8DIgg8W3bkrwMiNlaiNXm83Aj+w+W+LvIqxDH/ZjM2Om+W8YITG9zL0KlsE?=
 =?us-ascii?Q?PR2Mh/N+gazQb6y/tQWcpkVxu801vm0ap3qcEZjw75FGpuQpVG1EutahJ596?=
 =?us-ascii?Q?+QE2Gv+slyWN/XpIZ1PTBKuuFDLgzVg/BH/um3tP+2QJQ/eHbwl1BlR/KHCn?=
 =?us-ascii?Q?XkkuXtnaeZ7+Zd7ln/o+6eKhpjy9Ip/dHZyUVNg7l7WpU1MwcyRwX7IoYHJ1?=
 =?us-ascii?Q?89RAVpoeWOLHpokXLRjlA1dLKpUStl1V8+uMhtP8Mo8TysL5IFOISeN3dGTg?=
 =?us-ascii?Q?pebWc9TaQ+u9KAN342yc5rgN1/rRRjDw6Q79OzuiXJZnk17ZlvWr61T/OPcp?=
 =?us-ascii?Q?ZHvJY0k2c+IPbVuDwDORQO7bwSZNmT+o2Y6wUAryGdbiMQiqAlCD28alRAZ7?=
 =?us-ascii?Q?0H/TD3ydUfSoqR8kNgx4xifmWKVt6Vf66BfZatUwsF4TjirXK1OPcL5wxtru?=
 =?us-ascii?Q?BksICNnO//F0y+GU9fmRsZC8OxDgsP8nLYpUMyOLkJJb0govJBfbffdF3Xjf?=
 =?us-ascii?Q?Mqmdg+7SZhzCYRC49NyMmlPg4WJ5Eglwl34A2SGZzTcDkMyX755TQcgl8u3k?=
 =?us-ascii?Q?iE8Srw608nj8CpWyVZ6rXi3HXI/2GRXp8gCPX1OiKJ+6x/Ck6nSJHnK07SuH?=
 =?us-ascii?Q?G/WXIuYtYPauRNRTlfU2uyXeaJ/gbbEfpwV3zskLHHYrXQWvW7BL3iRexVgG?=
 =?us-ascii?Q?v9uKYqrfmE5xB+XBMX5EhQmYhiIAnu0TaK/3342ZHCtNb6SywDcZ9IhcPQ6m?=
 =?us-ascii?Q?aEJTmBWxOym+13kU6LTpnXJRX/wVUwk/CysO69Of1l3k7nvcIIFiUMwnatmU?=
 =?us-ascii?Q?8bMpkk0kQJ903hhxH8GMzc6ruF/BPta7h6U60TS71Y/67+zHhOhhKum27wo8?=
 =?us-ascii?Q?5Q6+bE0n6vYcUTJajRZDoxFrjdXKrvS5MPTIwwRbvMggjIrX1s/LW5GhChxJ?=
 =?us-ascii?Q?5+6pIZ3JUVDRzHmnSmvghyV2NpJMfgQ4QI4wukxqD+3ijOYnvAbH29khVsMT?=
 =?us-ascii?Q?HPYA2tnn6Ri207DZ8Z5tD+VHGcqN9AZWpBbT0gqWxdeBMAbDjaiTqCLvvXI1?=
 =?us-ascii?Q?e8dqZYBHrjaQGHwNxZbxYFKSSVRlZ8eul4/7PtJmhzTNnGCL83hUorfrUhef?=
 =?us-ascii?Q?7XWaO6IhNYJ1bmlLMncEqAV7nBWbt2MonLHa3uEsMHgceuqbeiVXg4YZDvBD?=
 =?us-ascii?Q?FY6EqZCYpLuDeJeB4BGrJBaRghd6VTCeQL3zobiEOJ2lGrP3DDnRcK0OTLJm?=
 =?us-ascii?Q?p+cR6iBdrwuwjlpuaUjYZOnE?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5453.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4be4a210-c5f7-49b2-d3fb-08d94c2e9745
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2021 10:02:03.8513
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /e6MpeGZ+cI+mZ/rXVQ//TPjz8ALt2LbMibJomJJVkICEugJoi91zNCZRHDOAnrCpMHLW6cCGu2RQLHFxxs3MQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5551
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> -----Original Message-----
> From: Sean Christopherson <seanjc@google.com>
> Sent: Tuesday, June 22, 2021 01:08
> To: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>; Wanpeng Li
> <wanpengli@tencent.com>; Jim Mattson <jmattson@google.com>; Joerg
> Roedel <joro@8bytes.org>; kvm@vger.kernel.org; linux-kernel@vger.kernel.o=
rg
> Subject: Re: [PATCH] KVM: nVMX: Dynamically compute max VMCS index for
> vmcs12
>=20
> On Mon, Jun 21, 2021, Paolo Bonzini wrote:
> > On 18/06/21 23:46, Sean Christopherson wrote:
> > > Calculate the max VMCS index for vmcs12 by walking the array to find
> > > the actual max index.  Hardcoding the index is prone to bitrot, and
> > > the calculation is only done on KVM bringup (albeit on every CPU,
> > > but there aren't _that_ many null entries in the array).
> > >
> > > Fixes: 3c0f99366e34 ("KVM: nVMX: Add a TSC multiplier field in
> > > VMCS12")
> > > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > > ---
> > >
> > > Note, the vmx test in kvm-unit-tests will still fail using stock
> > > QEMU, as QEMU also hardcodes and overwrites the MSR.  The test
> > > passes if I hack KVM to ignore userspace (it was easier than rebuildi=
ng
> QEMU).
> >
> > Queued, thanks.  Without having checked the kvm-unit-tests sources
> > very thoroughly, this might be a configuration issue in
> > kvm-unit-tests; in theory "-cpu host" (unlike "-cpu
> > host,migratable=3Dno") should not enable TSC scaling.
>=20
> As noted in the code comments, KVM allows VMREAD/VMWRITE to all defined
> fields, whether or not the field should actually exist for the vCPU model=
 doesn't
> enter into the equation.  That's technically wrong as there are a number =
of
> fields that the SDM explicitly states exist iff a certain feature is supp=
orted. =20
[Hu, Robert]=20
It's right that a number of fields' existence depends on some certain featu=
re.
Meanwhile, "IA32_VMX_VMCS_ENUM indicates to software the highest index
value used in the encoding of any field *supported* by the processor", rath=
er than
*existed*.
So my understanding is no matter what VMCS exec control field's value is se=
t, value
of IA32_VMX_VMCS_ENUM shall not be affected, as it reports the physical CPU=
's capability
rather than runtime VMCS configuration.
Back to nested case, L1's VMCS configuration lays the "physical" capability=
 for L2, right?
nested_vmx_msrs or at least nested_vmx_msrs.vmcs_enum shall be put to vcpu
scope, rather than current kvm global.
Current nested_vmx_calc_vmcs_enum_msr() is invoked at early stage, before v=
cpu features
are settled. I think should be moved to later stage as well.
=20
> To fix that we'd need to add a "feature flag" to vmcs_field_to_offset_tab=
le that is
> checked against the vCPU model, though updating the MSR would probably fa=
ll
> onto userspace's shoulders?
>=20
> And FWIW, this is the QEMU code:
>=20
>   #define VMCS12_MAX_FIELD_INDEX (0x17)
>=20
>   static void kvm_msr_entry_add_vmx(X86CPU *cpu, FeatureWordArray f)
>   {
>       ...
>=20
>       /*
>        * Just to be safe, write these with constant values.  The CRn_FIXE=
D1
>        * MSRs are generated by KVM based on the vCPU's CPUID.
>        */
>       kvm_msr_entry_add(cpu, MSR_IA32_VMX_CR0_FIXED0,
>                         CR0_PE_MASK | CR0_PG_MASK | CR0_NE_MASK);
>       kvm_msr_entry_add(cpu, MSR_IA32_VMX_CR4_FIXED0,
>                         CR4_VMXE_MASK);
>       kvm_msr_entry_add(cpu, MSR_IA32_VMX_VMCS_ENUM,
>                         VMCS12_MAX_FIELD_INDEX << 1);
>   }

