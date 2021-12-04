Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F097A468235
	for <lists+kvm@lfdr.de>; Sat,  4 Dec 2021 04:57:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376971AbhLDEAi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Dec 2021 23:00:38 -0500
Received: from mga17.intel.com ([192.55.52.151]:18942 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242844AbhLDEAh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Dec 2021 23:00:37 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10187"; a="217780255"
X-IronPort-AV: E=Sophos;i="5.87,286,1631602800"; 
   d="scan'208";a="217780255"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2021 19:57:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,286,1631602800"; 
   d="scan'208";a="501417816"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga007.jf.intel.com with ESMTP; 03 Dec 2021 19:57:11 -0800
Received: from orsmsx604.amr.corp.intel.com (10.22.229.17) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 3 Dec 2021 19:57:08 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Fri, 3 Dec 2021 19:57:08 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.45) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Fri, 3 Dec 2021 19:57:08 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ANvT9ClbJOxbimrqwE1DxLkIQZdGUybCAY6Znfb6yFKludbnHi991HyNCG2e6H5FNWY/nCBFGT4ot/SDAFoJqiLRKAtlTcNcfetzPUeFBrPCfk+QRRQF1CPahZdAgqNUTs23ysE0wLsOB+RW0aL6uzmjTCk1XrGd8LGFWidp4Xkl7qoET5p9S/7QKxM75KP3WWnN2xhZWvbV/O3PNPypNyW3DQc33j91i4cFrY42O+nJM/7KGgF1KNY/rs3Tz1D/OLaclG+urk9KEdWCwGwK2mn40CWCHSmLdbDUStN8BrJZTehn5XM/7as6K5k8TXlUbX0hGVA6jidAe6Hf6HUyCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KXiQp3FHjtzyZHi3/Z+3PWUghaxNSMYXd94dgruicq4=;
 b=D/FofA4nwxwZkQH2fftM6GADZOEjstYu2fWy5HwqimzXKMLPYER/eBtoMt4AkOAsajlBPPufbt1eIE+WHrvLK/VfXECUgFUtUKDqkRZXtVuGgVBU6birPidO6WvnzR+givtvUhnk8l0nMSzZVdd5i5UPusSvPZqulQIbhqbidHR0a3Jn0ipd6eDJqsoXkQwVrgCFNCNaxxJmVKW9HmsKI75utcum0k2IvIGJj7j7GwR9nW9AV1Yorxo4Um4zlMq+hwFi4osuCSZ/1TYKwgESa6P9jnNGksC56O2xuyUPxF9FGyz4GjJWO3B6jRIEFfp6B91YjqB4i88hHO5hlNwr2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KXiQp3FHjtzyZHi3/Z+3PWUghaxNSMYXd94dgruicq4=;
 b=JS3YtCDiYjp5d+S9M85Vxc/P/1UxZJJuOcPkJ9wmy1flFjcZJIGTb/Kbk/1XGxUka0a3pKMN9y1V0PpYdFyWBJscIUvmE/ogrM0slt58iTZFnu4HqrB3Kzzdosee3tkZjpT+F2BgbvNn6Fc7qXIbQeXWMaB8JHOmnafKDRV+ZO8=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN6PR11MB1538.namprd11.prod.outlook.com (2603:10b6:405:e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Sat, 4 Dec
 2021 03:57:06 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::3d42:a047:dc28:e92b]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::3d42:a047:dc28:e92b%9]) with mapi id 15.20.4755.019; Sat, 4 Dec 2021
 03:57:06 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "Huang, Kai" <kai.huang@intel.com>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Gao, Chao" <chao.gao@intel.com>
Subject: RE: Q. about KVM and CPU hotplug
Thread-Topic: Q. about KVM and CPU hotplug
Thread-Index: Adflvg/SIgoQKcU9QlaunmfcAiKUJgADptsAACzuVmAAB4iHgACJE/aQ
Date:   Sat, 4 Dec 2021 03:57:06 +0000
Message-ID: <BN9PR11MB543302C3841AED15AF52B2A28C6B9@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <BL1PR11MB54295ADE4D7A81523EA50B2D8C679@BL1PR11MB5429.namprd11.prod.outlook.com>
 <3d3296f0-9245-40f9-1b5a-efffdb082de9@redhat.com>
 <BN9PR11MB54333C976289C4AA42D7B1AA8C689@BN9PR11MB5433.namprd11.prod.outlook.com>
 <87bl20aa72.ffs@tglx>
In-Reply-To: <87bl20aa72.ffs@tglx>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4bb7f881-74b4-405b-6778-08d9b6da2373
x-ms-traffictypediagnostic: BN6PR11MB1538:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <BN6PR11MB15381CA737114622E2F861498C6B9@BN6PR11MB1538.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /vcS4tJgWCJVeixQJ2uJNElaLo5aamsMx4E12OkqKiHHkP//f9WmZyam0/uIcAVesusHiDi6HG2BCBoQPbSFx33FKJpwH8/fftC4x4hSUeeKxnwY/+oqBltQvGAV3SBaLZcR5QqptCA/LcV1JYH2i03eH8jD/0RGunMkT7mMuGK8KpP+qqnLgmJrHY3qg77WtmN5l8dcjjbazkQeAz44XBUAn8crbbzkc1k9KRF2B/D0b3t4YwVvnBhiBWmDTjG4DfCoMyn8X9XSdTv0iuAMZwfQzd8YcJAWO5aMsHFxLy8IZXDQkiR+RpcxnGPaGBdTBGp9ez0lac03jJamYI/Vmvr5KLj+y2sNvR7/QZuaYIVE2eZ3YRQS6jXe3DmDw/vAXcLh6ugo9cm8M67CS8owWTrm02AUY9ur+sTgTLAdfUr9BtZgA3lYjUUE3AGPC0yTsdmRr171LQl775QnJST5DJbvLNS6wGzTa07Y6XYDZMDU21gd0hhQMPRWeKUhY+Rj33wC1nQT7E5zpU5wijsU2kLs5EBHCMSb+5ARaEHroAkc+0QztFlX/QXHXJlA4TZ6tca7nFGX9eLQCSYJuirhEfwSgaeMpO0o0cNAoHsloAu+SMa0YieRT5YoqrGI6wUJrKi4ei28PV5b8MHDiyRChvk9YiiZw88GZviVcaYO0gzAXgBXyYFa2fZgMjF2AeVu/MjIHyyflWvPvJ3cDLG2YA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8676002)(38070700005)(26005)(8936002)(82960400001)(7696005)(122000001)(107886003)(4326008)(66946007)(110136005)(55016003)(76116006)(2906002)(54906003)(6506007)(64756008)(38100700002)(66446008)(508600001)(52536014)(66556008)(83380400001)(5660300002)(186003)(71200400001)(9686003)(86362001)(33656002)(66476007)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?hJ0+QN837cuh22TyQJUIpnzmzGIy/97jyWCYXKlPklgt+q4FTJW3umG1olyk?=
 =?us-ascii?Q?En+sYhd3i3KnZwzy0B7rxVK8vNtiNyZq+7723X1X4ngghYYbwqBc671Hvj46?=
 =?us-ascii?Q?POq708qRJYS+pXca8IAfnfbe/Jj0Qwz5lUt6DHNcH2o8SS3uM53HdJME51j9?=
 =?us-ascii?Q?qvYV6B1965Pehi0avFM3HhegZxjwEa+2pNKLNn3mUSQ1lCAC8vExQUpZ4KpX?=
 =?us-ascii?Q?44bgjPsRfqBlMFROGKjSG6jzkl/OUiAmg6DQeAuheCSoS2bR31ZwvCPfZGG0?=
 =?us-ascii?Q?TyVrpAibIp9mVTchvr1i6tByAorBzM6spk4Gj50ce4re5JdQnUS93lq8aAnq?=
 =?us-ascii?Q?+ASG1+KvCOGBePKDK9I2sbKxTPGnOe7nG5yKN6Op7nIcG1DN+vxe8mfALt5I?=
 =?us-ascii?Q?OFLuZxYB3kYSug1LRDErHaMNwzDg8wwD4P5/RHqINNYRPnljWlnNOBo+Anws?=
 =?us-ascii?Q?2c/R8h1QUXGPB+ixnNx1o4ylrF1yz/9fxwb1DYm6TCSqRSNUbTqtqD+vgqRI?=
 =?us-ascii?Q?3zJLPXHNIo6+adbR75DKgCarCzahCIKXm7CMihpJnJamaIK6/E9nPZTdQcOt?=
 =?us-ascii?Q?J6oFWuzNJ9aBrs5lmtVjuUEmWz0qUX8jhg4F4BNwHgc90sPnQGtp3Ij2hvUx?=
 =?us-ascii?Q?aI5PDguyF51HPv4U9GUkOkYr0YJplZB3b/b8JXTLdTCNRGdh5vWyrdfLn+wu?=
 =?us-ascii?Q?QNU79nQgQZZKgKdrFuUEnX5qSF03Y0JRpOaybwy7bHpu3QMtmmy/n5qUjuFZ?=
 =?us-ascii?Q?IGNMcleFHgRO60SpQTih8LEqLA0zW94j45sO1X14aEy+fy0o/RmdU0PwI+rL?=
 =?us-ascii?Q?cnnBn7xoqygxG9Hy7f6+YFyFLDM3S4gxP3zkjRl6JRQgM62Wcn/7OCSyH3kD?=
 =?us-ascii?Q?oq4OriazBGHdAfCf7YPyijqqMAYBvYTUp6N9nOo11BT2GERASiv+xDOHNqGG?=
 =?us-ascii?Q?idvzA8ZhskmgpZ+f3sDb8cti/iCmDxpCiUAbTBQREdfJohWdaHm/rFamkvk8?=
 =?us-ascii?Q?stZnKnONOiZ1xha2VeVLyzQM//oa+I0vTlVMdJQ/VMHDw72YZ4kcWkPw85ju?=
 =?us-ascii?Q?enmjCD8XvaAUtuM2JXsXhVIxj/i3u0BJneWUKMvjWpPlFdV3xDb9ANTxcrna?=
 =?us-ascii?Q?x0TYGunn2dZxxk6VqGaxfsg/bxi/mgztUIQWlFpZuVkF+2+tJns9XMiuvaqN?=
 =?us-ascii?Q?ZtRioJlXfTJO4twe9S+znU6gfafbJDrx/rNVfQeBkRm2NVe0MMkKwkqHy8pP?=
 =?us-ascii?Q?AErBEYsNT//5FM74KjBMAKYQFOYilcqFLt95NInFfjLIxGKONdzE0zKH0hz1?=
 =?us-ascii?Q?+xQydmyAAN415XovAy7Njg7HTcSWbAajhvbfKjkXPTpcpbuEAPPXzh8GWHuN?=
 =?us-ascii?Q?g1XDR/pXxymQaCJRUJ+t3lW5BQjzYQKpcLBiGq217nk/7rIWEevJelXXePxv?=
 =?us-ascii?Q?YQK/WnBndQfYm1tHpYhGBNvGuhne+Zn2t/WoP5Nxep7qFK9vHVbzHQ0Rl5QP?=
 =?us-ascii?Q?UH7tOd1GcRFB6taa3sROqH6gB6Tor+WB7upXEZeSmupgP40hxDjWL6SMOJwr?=
 =?us-ascii?Q?1//V3Tzz+mQIIjppbSKvSODLPoob1fPNV1RZJ21cpS05HhWHZnLOdP4OZsQL?=
 =?us-ascii?Q?5g=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4bb7f881-74b4-405b-6778-08d9b6da2373
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Dec 2021 03:57:06.2621
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +iozyZyC2PY5QGs/D2s3gQizDV0olukf+8Zh00oOhZDe1g2Ktn/kozWHsNmJ6zSEgmDlMi4ar8JfegIoEzPqyw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1538
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Thomas Gleixner <tglx@linutronix.de>
> Sent: Wednesday, December 1, 2021 6:31 PM
>=20
> On Wed, Dec 01 2021 at 06:59, Kevin Tian wrote:
> >> From: Paolo Bonzini <paolo.bonzini@gmail.com>
> >> It should fail the first vmptrld instruction.  It will result in a few
> >> WARN_ONCE and pr_warn_ratelimited (see vmx_insn_failed).  For VMX
> this
> >> should be a pretty bad firmware bug, and it has never been reported.
> >> KVM did find some undocumented errata but not this one!
> >>
> >
> > or it may be caused by incompatible CPU capabilities, which is currentl=
y
> > missing a check in kvm_starting_cpu(). So far the compatibility check i=
s
> > done only once before registering cpu hotplug state machine:
> >
> >         for_each_online_cpu(cpu) {
> >                 smp_call_function_single(cpu, check_processor_compat, &=
c, 1);
> >                 if (r < 0)
> >                         goto out_free_2;
> >         }
> >
> >         r =3D cpuhp_setup_state_nocalls(CPUHP_AP_KVM_STARTING,
> "kvm/cpu:starting",
> >                                       kvm_starting_cpu, kvm_dying_cpu);
>=20
> Duh. This is silly _and_ broken.
>=20
> Using for_each_inline_cpu() without holding cpus_read_lock() is racy
> against concurrent hotplug. But even if the locking is added then
> nothing prevents a CPU from being plugged _after_ the lock is dropped.
>=20
> The right solution is to move the hotplug state into the threaded
> section as I pointed out and do:
>=20
>          r =3D cpuhp_setup_state(CPUHP_AP_KVM_STARTING, "kvm/cpu:starting=
",
>                                kvm_starting_cpu, kvm_dying_cpu);
>=20
> which will do the right thing automatically. Checking for compatibility
> would just be part of the kvm_starting_cpu() callback.
>=20

Yes, this sounds the right thing to do. We'll work on a fix.

And as said in another reply to Paolo, future TDX compatibility check
will also be added to this callback.

Thanks
Kevin
