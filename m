Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F37044C1C7
	for <lists+kvm@lfdr.de>; Wed, 10 Nov 2021 14:01:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231982AbhKJNEN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Nov 2021 08:04:13 -0500
Received: from mga03.intel.com ([134.134.136.65]:57936 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231151AbhKJNEM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Nov 2021 08:04:12 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10163"; a="232608135"
X-IronPort-AV: E=Sophos;i="5.87,223,1631602800"; 
   d="scan'208";a="232608135"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2021 05:01:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,223,1631602800"; 
   d="scan'208";a="452312112"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by orsmga006.jf.intel.com with ESMTP; 10 Nov 2021 05:01:23 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Wed, 10 Nov 2021 05:01:23 -0800
Received: from fmsmsx605.amr.corp.intel.com (10.18.126.85) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Wed, 10 Nov 2021 05:01:22 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Wed, 10 Nov 2021 05:01:22 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.173)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Wed, 10 Nov 2021 05:01:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y4pWl8+SHoEODcegHGQ/+XW/H7quCC4Diy2EaXP4Rftm+LaEC2w0F4spi/tJnGwd19bCbzccSRb33E5A4mOuidg9+wYHqOONHbdbZDNhnqkW5g+YPDIR6pbV5pfCkW3qQrckTEx4qmU6ZQXTVYIcMwgkoczRLAV3IOgWcrZJt3WOf9t9aheP2NsY7KS9fWowEbrMp1buem+7OSH78FUj/iqwnL6JG3+86lcplzx55XrSe3BTmumyMlAmWSgR5dqphogUak+OzUrpF9MQCA0cphx57Zj7wDo48DjB8fTSwAs1U90sB7vucwUXY9SchnYInzdl8+S+k90Y2bZEkgc0sA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3nTtQX5MN3Z/P4FII6YHF6sem5wkT0yXqrbMQ9/Aga8=;
 b=JtscLfKxgbodJEVXLs3fI6eMObemfOH2UWgNRLohR+cPtzf77cUKTst7NCLjz+toHb6QFjfGoTl1cAQnMaoyM3Mo5qD+KtNk4iYg5xEGWYLVCNhHGjukpDbVWa399/MWKaM/8w2+AhpYAO9ZqGk0Oh1C1UIEOFCIIqADEAoFxYx0MWCL9gVH4AvJPv9VVhcnKLQa2yyZ0J01v1531eAKJ2z5dGREVxSO9cfCv0EZL8zaikBNa+07uRAg1sTZsW237BrS84c5ltAcdn6VmjXjAcyJY1ylMC9LJ4qKnd4Jw3h+ISmHEAzD66DqxNAIbBtbh0B09FiCp8n8AJqn4xdnoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3nTtQX5MN3Z/P4FII6YHF6sem5wkT0yXqrbMQ9/Aga8=;
 b=JB/Sxz+N4Z5dHWL7CYk/mchNj+Zx5RUMNk4+pDn5LR6BOU72NgjMjfmkQtNeMYBCN3mVGw/4Md+PUSHy3D7flW2Ikj3yry6NbcOFQck8bKxJKKqS6qcdcmHnZ/zCUG9Dik6ljfKJjNZfeONtmPXam9isHv9omEkRr12r2BnS0X0=
Received: from BYAPR11MB3256.namprd11.prod.outlook.com (2603:10b6:a03:76::19)
 by BY5PR11MB4182.namprd11.prod.outlook.com (2603:10b6:a03:183::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.13; Wed, 10 Nov
 2021 13:01:20 +0000
Received: from BYAPR11MB3256.namprd11.prod.outlook.com
 ([fe80::61d4:ab77:cc62:fabf]) by BYAPR11MB3256.namprd11.prod.outlook.com
 ([fe80::61d4:ab77:cc62:fabf%6]) with mapi id 15.20.4669.016; Wed, 10 Nov 2021
 13:01:20 +0000
From:   "Liu, Jing2" <jing2.liu@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>
CC:     LKML <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "Arjan van de Ven" <arjan@linux.intel.com>,
        Jing Liu <jing2.liu@linux.intel.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "Cooper, Andrew" <andrew.cooper3@citrix.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        "Bae, Chang Seok" <chang.seok.bae@intel.com>
Subject: Thoughts of AMX KVM support based on latest kernel
Thread-Topic: Thoughts of AMX KVM support based on latest kernel
Thread-Index: AdfWMJGMz5/jeSLQRn+nYCX+7Qj8nw==
Date:   Wed, 10 Nov 2021 13:01:20 +0000
Message-ID: <BYAPR11MB325685AB8E3DFD245846F854A9939@BYAPR11MB3256.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
authentication-results: linutronix.de; dkim=none (message not signed)
 header.d=none;linutronix.de; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: db9a8678-308f-44a8-0cef-08d9a44a30d4
x-ms-traffictypediagnostic: BY5PR11MB4182:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <BY5PR11MB418299BBCD1C50FD8D341E79A9939@BY5PR11MB4182.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sWESvMMpF4m8aQe2uL0v8x9lWml5FJ4JC6iJdKfxkQBbRPbXSo0E1+9LVrLlSCy3EWwzf8Lqk6V0/CbUfCo9LYIk/nSHj1SBdh/vh3dMQJeKlc71YGqRWrtvBBN7ypwG9Fk88yrpbk05cJRx6tinoRm/wWSbiBGPMxInmQIGzSlUX9zG1zVXRfN75PR5rii/k4UKXM7uIwr9+hmKJMv0pA7jMWVGmQpmv/y39HRh+O9pAFOhwQ0jZY268DhbsL1VVFaPurhug5STD3rK+uGdA2HnZco8KkyyOBJPkHa7xBjh2PwZAkcXCs2wGhQf7n/AM/JafROrRVplaM10iv6Jj2fqJQWuVaY9eAhNnKPV8fj3w/6SyTsOmyJNj0ANh40s+BmA20MGCi/tow5utuucOPMY4uruRZ7Eg639VpMsTpoQJJgZFafeh9LCqJJqL4KDx5wnHZtmJiIQqAfhsFnqDERjPpYrfiUj7Pe+Ab6xvjyMTrl+TdUHNQHy57DdAMKIyOxSfmWdYmGr8eexqnEbd4q6q898IiSlrlcwiKcBV0a2gSKiLPTu0+O77sg+Jyi1oDJTXTEgAWM4cWgGK0uDn5ui9s+CddW4bJklTdIJjbSF7g2t6SFXeJiaCO6NJDnieP8Z7ASvW7ikf03ekkiw7YZhNJPDqAsW9A2Ht1KqxHUx2b7oygeRjBiZCL+bbG5GIwt1M4OGTIyaAy6I/+14hQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3256.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(508600001)(9686003)(4326008)(186003)(82960400001)(6506007)(33656002)(110136005)(86362001)(38100700002)(38070700005)(26005)(5660300002)(54906003)(2906002)(66946007)(8936002)(7696005)(66476007)(76116006)(71200400001)(66556008)(122000001)(66446008)(64756008)(316002)(52536014)(8676002)(83380400001)(55016002)(7416002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?z+o7aJbZAdQ/pZBI/u+yEIssLp9ir6QnkZJF6MCDt03Q1qA07R6u1PQGW1aP?=
 =?us-ascii?Q?2//ieNhKPPPVZ9WcnCjEi0eb5q5BXoj55WTxFNSCfOk9m45MU6pLySM7KmUf?=
 =?us-ascii?Q?jILcAPBprDZ+OUaOuJk+jNSoiQ3FdJKdIAK3tzfQ59C3pNisaXhGG9OiKiBd?=
 =?us-ascii?Q?VRbh8QUBg3uMNTTKrvIoOHtPscra0zGtNImaFfit5vvth+atsLgaxFMT9z9N?=
 =?us-ascii?Q?boWsFSK2ilJt2RF3S78BAgY5IC3zUbz3AheTdaDwVSdZTZdOQkQKXDScdfFT?=
 =?us-ascii?Q?GyDE5GE7z+LbVNrVIonHFBgrdu/rypWtDeX1sBUdzq+ie1LDSVDdJTH35YLV?=
 =?us-ascii?Q?lEsf7/7uJb3lazm6DqgzXA2f7cyRpSP3km0Z4dUTEpcPpDz0eNBPnt6bqIVg?=
 =?us-ascii?Q?e7zDf4/CDoCR6MAM/NHcFL0BHMQeZZHpmbcLrq1p1nI5rSC2aFZ7O6V+H8LI?=
 =?us-ascii?Q?l1Xf/Ei92QC5HvwEqwvse1NJKMmP6FbhbjUh2SwSx6zJ3YQCelygDeq02Q2l?=
 =?us-ascii?Q?7TRjo+bCblaLjvsGw8S1qixRAGsRnrAJAcGbT+8WTB9RObknRSd1/WWd2m2k?=
 =?us-ascii?Q?sg60PKeBCHUezGFfndvmK0ohygVxsNG5QGRBNfT2qRT+0lNiBBVuyknCoIC1?=
 =?us-ascii?Q?U8t3fQArQ70FhDnQzQGqZcv6oU2wnd1Km8FGxxTtI4UQdzDz8fBN8IGEalD8?=
 =?us-ascii?Q?ybR7fEYHTSrnh9YdClkoWZI2uNwGeTeso4k8aGkcfbAFLDmEsa1mBj4ELClT?=
 =?us-ascii?Q?d14uoxjQ5rt0/89ek8MUF7R8kQPDnFRuRVdyTW5XQUbhv6YlvjOo5bXrV5U1?=
 =?us-ascii?Q?YpoWQyWU8b11KkJmI7FT17t0c+Puik/Tx269+5j08vu58DOh13G3G7+4T97x?=
 =?us-ascii?Q?mD18YrIMAtJcLrSDv+hIhDFLkWryFRtZL+i1zwLx9M58Qk+coF0tFHp4yTaj?=
 =?us-ascii?Q?FUNpjQ9bsQtgMeDArI6R61L9gfzfVWCa8d6Gg+kp2F1I3L6WIQ00aPa3KP8o?=
 =?us-ascii?Q?Unx4OB+hz1szuY0ZUdiqu5hu/cBdr9iReLVpk0DVlzU1nJe+UmmF8LR1b8Ti?=
 =?us-ascii?Q?ReLw87j/yQwQcm2t9Bq4T/MDkWPtIF8rp3N+DsTPRW1u8WmBanQyZ84hOS44?=
 =?us-ascii?Q?hHC2cpzt4CVuvANzNJPYlOxK0yb9JT9tpaQCLsgSkGN89IwcXp3gRQ9ksxD2?=
 =?us-ascii?Q?pGJMhfOr2s6D7TzdqmcJ9JDJ0ZzMRERD9L/Mbebf5lE1iriSV+9NflbqVBoh?=
 =?us-ascii?Q?4iOrDnVr7nNYL3rI0PocBbTa79kdnlxTtteDuHgVwCt/yUZdbhHH3CAPeqje?=
 =?us-ascii?Q?YfOl22JcS7+XCShG4v3d6wj9Ll8WzefKxkB6Bf5JEfu6pNLh0Bm0cxtaBaA3?=
 =?us-ascii?Q?5liK4AENMGxpdhn8C5RSAbsNwM/aGxfGFM9qvDU3uUZFQ3YkJLMIWe1Hp7ty?=
 =?us-ascii?Q?DGr/Z1u2Mp+iIVxXEJr5QiHqFe/w8srDDAsGrv51dp0rOgyeV/6ifLhrljk2?=
 =?us-ascii?Q?1M3lu1SO7kCqO188mKpQ+FB0BhNRHywITrs4J0LlT7YFzviMrtPuoZ9K9SQp?=
 =?us-ascii?Q?TpzCtO+2RTMUY9qQmaK7OFJt6HGNlQYmqB18HvOqQZmpEb+6nYZU+6/SKqT5?=
 =?us-ascii?Q?gk+osHF23/hG+Euvw69N208=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3256.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db9a8678-308f-44a8-0cef-08d9a44a30d4
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Nov 2021 13:01:20.2065
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: B1Ri0m6HF+DoZ5/KG+2Hs2ugTKb5ADSnkGcKbex8J2d4hpfEHjoEeCKMCygquG8gbRJIkDbyZD1/j5nU+Wc8hg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB4182
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Thomas and Paolo,=20

Thanks for your thoughts and suggestions. After reading the emails
and looking at the code, we'd like to explain our thoughts of AMX=20
KVM support based on latest kernel and the code from git:=20
git://git.kernel.org/pub/scm/linux/kernel/git/tglx/devel.git x86/fpu-kvm

AMX support based on existing design concepts=20

One of our objectives is to have a simple and clean KVM implementation by
utilizing the new dynamic extended-features handling in the FPU core. =20

Dynamic reallocation and "lazy passthrough"=20

The new code allows us to implement "lazy passthrough" of the XFD MSRs
by coupling a buffer reallocation request, which is indirectly made by vcpu=
s=20
(VM exit). With "lazy passthrough" of the XFD MSR, we can avoid unnecessary
save/restore of the MSR and allocation of the extended features until the
guest really requires and is allowed to use. Until that point, the XFD MSR =
is
virtual, and thus we do not need to save/restore the actual MSR at VM=20
entry/exit time. And the vcpu does not have an extended state until that po=
int. =20

Once the guest starts using the XFD feature (e.g. AMX) and it is permitted =
to
use it, we allow the guest to directly modify the MSR (passthrough) to avoi=
d
(potentially frequent) VM exits.=20

Triggering of a reallocation request and error handling=20

First, we want to avoid weird guest failures at runtime due to (more likely=
)=20
permission failures of a reallocation request, checking the permissions of =
the
vcpu (for the extend features) at kvm_vcpu_ioctl_set_cpuid2() time, when
QEMU wants to advertise the extended features (e.g. AMX) for the first time=
.
We have no idea at vcpu_create() time whether QEMU wants to enable AMX
or not at that time. If kvm_vcpu_ioctl_set_cpuid2() succeeds, then there is=
=20
no need to further check permission in reallocation path.

Upon detection (interception) of an attempt by a vcpu to write to XCR0 (XSE=
TBV)
and XFD (WRMSR), we check if the write is valid, and we start passthrough o=
f=20
the XFD MSRs if the dynamic feature[i] meets the condition
XCR0[i]=3D1 && XFD[i]=3D0. And we make a reallocation request to the FPU co=
re. =20

We simplify the KVM implementation by assuming that the reallocation=20
request was successful when the vcpu comes back to KVM. For such VM exit
handling that requires a buffer-reallocation request, we don't resume the
guest immediately. Instead, we go back to the userspace, to rely on the=20
userspace VMM (e.g. QEMU) for handling error cases. The actual reallocation
happens when control is transferred from KVM to the kernel (FPU core). If=20
no error, QEMU will come back to KVM by repeating vcpu_ioctl_run().=20

Potential failures there are due to lack of memory. But this would not be
interesting cases; the host should have more resource problems at that=20
time if that is the case. =20

Additional KVM-specific or and virtualization requirements=20

KVM needs to virtualize the XFD features, and we have additional
requirements.=20

XFD reset value=20
The XFD reset value needs to be 0. =20

KVM-specific XFD handling in XSAVES/XRSTORS=20

Once we start passthrough the XFD MSR, we need to save/restore
them at VM exit/entry time. If we immediately resume the guest
without enabling interrupts/preemptions (exit fast-path), we have no
issues. We don't need to save the MSR. The question is how the host
XFD MSR is restored while control is in KVM. =20

The XSAVE(S) instruction saves the (guest) state component[x] as 0 or
doesn't save when XFD[x] !=3D 0. Accordingly, XRSTOR(S) cannot restore
that (guest state). And it is possible that XFD !=3D 0 and the guest is usi=
ng
extended feature at VM exit; we can check the XINUSE state-component
bitmap by XGETBV(1). By adding more meaning to the existing field:=20
fpstate->in_use, it can be useful for KVM to set the XINUSE value.=20

The usual VM exit handling in KVM, however, is done with=20
interrupt/preemption enabled. If a guest has a non-zero XFD and AMX
is in use at VM exit, the host and KVM need to maintain the guest state.
There are two cases where the host and KVM may lose the state: =20

a). KVM is scheduled out and kernel context switch does XSAVES,=20
b). KVM is interrupted and the softirq path calls
kernel_fpu_begin_mask(), which may execute XSAVES. =20

One crude way (Option 1) would be clear XFD temporarily at VM exit
time if the extended feature (AMX) is in use (XINUSE). It also causes=20
unnecessary overhead because interrupt/preemption may not always
happen.=20

Given the new unified handling of the XFD state management and=20
guest awareness in the FPU core, we think it might be better to defer
this to the host (Option 2):=20

a). Before the host kernel executes XSAVES, it clears XFD by checking if=20
this is a KVM guest fpu and if guest AMX is in use (XINUSE). KVM can
convey the condition by using fpstate->is_guest and fpstate->in_use,
for example. We need to add more meaning (and code changes) to
those fields.=20
b). Same for XRSTORS. =20

One of potential drawbacks of the Option 2 might be additional=20
checks in the host, although we can minimize the impact by having
CONFIG_KVM_TBD. We believe that the case
"XFD !=3D 0 and XINUSE !=3D 0" should be very infrequent.=20

Propagation of reallocation errors =20

As noted above, a reallocation request can fail, and we need to
propagate the error code to the userspace (e.g. QEMU) so that
it can handle the failure properly. Since we do not want to=20
terminate the guest after running due to permission errors=20
("weird failure"), we think we should check the permission at
set_cpuid2 time, return failure if no permission. =20

Looking forward to your comments.

Thanks,
Jing
