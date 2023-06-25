Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DE3A73CE5B
	for <lists+kvm@lfdr.de>; Sun, 25 Jun 2023 06:03:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231552AbjFYEDL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 25 Jun 2023 00:03:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230307AbjFYEDI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 25 Jun 2023 00:03:08 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 331A9118;
        Sat, 24 Jun 2023 21:03:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687665787; x=1719201787;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=N56Kqkp+DfhCfUrZCPN7iug+0r8RB2JUk3vf6q3Iknc=;
  b=lVpkn8Zq+hRepjRbahuYtd/oKy17765pSNUQKef/QIu/btM7QKl6oMIn
   ygJB1HonJ+Phw4iKlN/ywgEReRgkDs7xOsoWchYL2OoE7bKcJVyNdCVdM
   VT+MfI0RrMLFyXCtu07FBrkk3ekXwkna+y9rypW6D+l4E2oxvKMqDWSI8
   qilJZvpwjafDwV916AnyFszCk43MWpF+wr4Ks2vKuS17x6PhgHDU4OqMX
   7in8ozoothO64zvVyJOH/bNKsJDc6i+ThTs3PBKzOY8B95h+TnrUTz42D
   Rya0nnMVL/w79NVh4U7zwbmKtJlDsXXQ3laJtw2aWvhR03X4M5rf4KrS7
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10751"; a="361055438"
X-IronPort-AV: E=Sophos;i="6.01,156,1684825200"; 
   d="scan'208";a="361055438"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2023 21:03:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10751"; a="665900125"
X-IronPort-AV: E=Sophos;i="6.01,156,1684825200"; 
   d="scan'208";a="665900125"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga003.jf.intel.com with ESMTP; 24 Jun 2023 21:03:06 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sat, 24 Jun 2023 21:03:05 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Sat, 24 Jun 2023 21:03:05 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.40) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Sat, 24 Jun 2023 21:03:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yp9YhsZhjy5FnvRxItVev3AOBicecLHSxwt9+jer+vgqhPEOZywtzHo5b0OKn7I4p5UCVictcyMf/37IrSpEzrmge7At9uogU1Rj5Lcg2mDxW8LxG+tBFL5pLqDMaLici56SEoT9ZgKSQOUEj0Hp1EfLzL35FuUogdVe5YXL0MKhq8czUuxI1KvtLDt0XHTLczNSwpmPTnGCziJXTBluAIDj3XS1gfxn5g6zCRqH/ovUiMCLBiZLmaGEqgS1rUCrrnuNHOIw1t2QwukSYpohptYBnSXujon6KJxsRmJL+LYGVxLxCSU593MNx7IaRj67nGv+OSgWxwX9W7SsOTKTPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5e0ADpV8UNzFSdm2ELDRxHVHRx/O5rQzyOo091mAaTM=;
 b=LSvoqlVsiwugsLX8e/mw+e6CqX7hRZ1CK9QYc3TL+NISd3sVebN7PZRj9Wb2OGa21NoRMgKjU51baqPayEDD6h8XEogr9uLd248qCDf/J16WPKt43WyAF+odriogLBu4jxGierpHyhvDmHpMpkK6GaJQKsps+lOnR3V0QJ6768OhEga3Xqp1YSEafyFYzjjDD+w2PoZ4L5xmLGh8rd1Da6VpOKLTo3JgpAcK1SAOLe6XZFrdHjFCLhW1fgKWflg0rMh7DsJ6FKXid2q3v9SPPdW63Byt1WNcThxGr5Xqspu7TaHHXW7WkppWbztF3ihd6lJMUNCHTadtdE5idHe3Dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB5824.namprd11.prod.outlook.com (2603:10b6:303:187::19)
 by PH0PR11MB7588.namprd11.prod.outlook.com (2603:10b6:510:28b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.24; Sun, 25 Jun
 2023 04:03:02 +0000
Received: from MW4PR11MB5824.namprd11.prod.outlook.com
 ([fe80::c3fd:5b99:a829:ebc6]) by MW4PR11MB5824.namprd11.prod.outlook.com
 ([fe80::c3fd:5b99:a829:ebc6%5]) with mapi id 15.20.6521.024; Sun, 25 Jun 2023
 04:03:02 +0000
From:   "Zhang, Xiong Y" <xiong.y.zhang@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "like.xu.linux@gmail.com" <like.xu.linux@gmail.com>,
        "kan.liang@linux.intel.com" <kan.liang@linux.intel.com>,
        "zhenyuw@linux.intel.com" <zhenyuw@linux.intel.com>,
        "Lv, Zhiyuan" <zhiyuan.lv@intel.com>
Subject: RE: [PATCH 2/4] KVM: VMX/pmu: Save host debugctlmsr just before vm
 entry
Thread-Topic: [PATCH 2/4] KVM: VMX/pmu: Save host debugctlmsr just before vm
 entry
Thread-Index: AQHZoEaZAhnIALyoOU+xDntcJVMGqK+Y3lAAgAIAd6A=
Date:   Sun, 25 Jun 2023 04:03:02 +0000
Message-ID: <MW4PR11MB5824480492ED55C63769FF11BB21A@MW4PR11MB5824.namprd11.prod.outlook.com>
References: <20230616113353.45202-1-xiong.y.zhang@intel.com>
 <20230616113353.45202-3-xiong.y.zhang@intel.com>
 <ZJX9WHFPdEVjRtC+@google.com>
In-Reply-To: <ZJX9WHFPdEVjRtC+@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB5824:EE_|PH0PR11MB7588:EE_
x-ms-office365-filtering-correlation-id: 187ee2de-d0a0-45d7-4995-08db7531121f
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: S89BYumSkGDa5wg9Q7ke3uPhmzIIvf7xddZ9HXRDcdbRxZ9QNpbeu/X8y7DIUO3ApRb0/s8T5C087/X1NPgSyKrp6m31G/uHfF+6wVgB2px5Oiz21rg/ro/bl+yzxSGiPPA26niDhmGWTOBXwRrlBKkp+8wCpVtroJzDNKMW0CBYFhwv3DTYSZ4IEl0N3UrcNJif9FgDibDNHmCMd6Vy5pdUyXtGqbDgqe6WJfHGHtEiw0FwRYyA0CFoIE5Q7Yz2awH5Vi5EhuBhAV0YBTxZABzhwBskJkYopF3qGs0dWD0g3vByp+YAGmsx22zUkKBH4uAFVA9bAZ0gGNk2kU0jVz3dTTZkqhyJoxMFl8fsoD6uSECdiJH7mhmAWVdNL1ozwd/aTU6srGZ6tbSBg0uGjsXQ5gbo0Wvz8M/+jIIM2R5IkIBBKkNM1agF4LZOl/jNI/SyW+72S1jVy5i1mmbdb+6hdgB7vukZVnWzMOOgOvVYW3lKlzO/MRELcGgTyDfn1Pov1Itrl5Q0TRlxLpkJXJLfZwAj4B+rXhK5ofo8svP7IwCpGXuUA/042laaop+Znr909Ik2XpvEl7lIAbCBruhnHcbiaOgcA2QjuHRW8RUI6/KZvnOwmvTbjHkdA4oY
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB5824.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(396003)(376002)(136003)(366004)(39860400002)(451199021)(5660300002)(52536014)(8936002)(8676002)(122000001)(82960400001)(38100700002)(2906002)(38070700005)(66476007)(55016003)(71200400001)(478600001)(186003)(7696005)(86362001)(54906003)(33656002)(26005)(64756008)(66446008)(66946007)(66556008)(6506007)(9686003)(6916009)(83380400001)(76116006)(316002)(4326008)(41300700001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?9UJy6X0a4ZNaBtoAl6UBj8dm9ifG9Zb0oHKWi9duJIiksSAg8lwJVHTZWgr/?=
 =?us-ascii?Q?sN6LZiO3ylVplktKkZiMXd7VCBmpirsfIMKeKmsb/FaLJXymkfqo5uWPOekn?=
 =?us-ascii?Q?Uux4PfUnW8gzSjb1YlMUpaQfZ3w1AUX+j+6zh6KZCRAnw8LLbec91XBvxeeU?=
 =?us-ascii?Q?yEIEzVrmJJKZBge9tksrjOI4Snfx7pGdf1qzqGDjYByX88cbcRqlBASkPMNV?=
 =?us-ascii?Q?dsZeqv2r6F6g7cO4vNlrTvxd3xERfQtybwBPYFc622oJhCxwmwMAw+mM5oAk?=
 =?us-ascii?Q?oO39mcNba6CQhSUYf7Nh5R2L1C1xfFqly2Dkz2ZcWW5wAAywMD7hkHcqNo30?=
 =?us-ascii?Q?v8OiyNuOBegJYruPyLrytoNA69iK00V3wtFzo6eR4cQfwNHbdFuKL3s/zREA?=
 =?us-ascii?Q?RUcz9DGquWfrY/E3kgQd0UizC3QjKOta5Oxva3CBCpN+m4x5sPgnUfSJoE+B?=
 =?us-ascii?Q?wNL/7REGrDMyac2ZZa2NzFWBCZMK0uTeqiAqVq5jdfLsjlP6mbv/V8+XgjEC?=
 =?us-ascii?Q?K5qoS0OKQ6yfGw+oFdhOivhknsKC8Gm5/3vUy3q4J2QCKrV9Y1D8oJjIDry4?=
 =?us-ascii?Q?WIQeYYwY/dbQiOVBQPcPr5hh1GCvs85q0CalBCkmaUJ0Ve8Kx5Q7pumbKLfH?=
 =?us-ascii?Q?6SPe4TVNfEgwERNLfA6Qi03bGnx8FSRTBHprrQaWKDHlKJ7OPMwqC5Zp7mAz?=
 =?us-ascii?Q?eYr1dQV3c8NrC14oQcKY7rqizOvhWp7YkPVNcbEtTWK0khmac0vBhZ2yjlKA?=
 =?us-ascii?Q?Yh0kWfGfhBw8xs7WPqZBH5TZ8ON5j5BMGdN9FUFqzGAl1db8mFCkjFGK+KLh?=
 =?us-ascii?Q?rqGC7XvzulCfqKljKY4NHAfPx/acHX2nji8Gy5UShqkQMa5tDrK8JqnMAJ0k?=
 =?us-ascii?Q?baH472JtAHHy36GD94BGQjoM8Tyb559ufAoH+mBRwnelDAPqn40N6J7pavR6?=
 =?us-ascii?Q?Tg8ozS0XYlaPi0Upy5Nl2SrvVR1clnYkP4+UnL3th0hZXmcOX1axnYniWwBQ?=
 =?us-ascii?Q?JjfbYCPaOVpzNYeZnAP2oCpcB2am2XOlyWPXHA8d9Hfjb6L6F2a7GmpUrxDl?=
 =?us-ascii?Q?mYFRb8MK8huQV6fT0BctebIijlZ4mXAt1Evh1G73RG2MxKnTb5OVVqIAtq7V?=
 =?us-ascii?Q?p3b+52ucwbt7wRS5Vql6TCrL5YycbCKya8vxHK8EVp44dzbxz3itIcdMacPc?=
 =?us-ascii?Q?IKeLhWCDDY+QN09zewJiTDr/vBe4Q6UFdZDqH9ECkDTgjsigCpR6jnrKa2jm?=
 =?us-ascii?Q?m5vvb2i2AzExerrpU9bLETod0+MtwoRTXttY9ykS4WYW1KSQaBzVkRnWRZOv?=
 =?us-ascii?Q?YelUJ2uygCbynx7nSLusU4QF2B25xySqBFvAiH1HgE9uraCCNoSNiORy5foG?=
 =?us-ascii?Q?TqfXoFad+McYhX67XTJEnVEQWYvYpFT1i3NeTenvuYpZXz6CcZzeVk+jEvcg?=
 =?us-ascii?Q?nCi6p4U0epKGz30xjO4ltK2CGHsUWA/00jkTxWsC/cjkkNR1d7q4PKUA2vlh?=
 =?us-ascii?Q?DXf4YoVMCaBEusWJyJQVd6wY6HuLU5gwpnMQiIHptL2LSk9fBmorUjm0vByz?=
 =?us-ascii?Q?p2MvR0qUivzBV4heXArVMTSyK9S4lDcNLKhuQ/f8?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB5824.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 187ee2de-d0a0-45d7-4995-08db7531121f
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2023 04:03:02.0942
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2rsjoBqSWfJcsFFB0EF5nxa/ZQYGVJWPlsT9pK8ODx9Y9SFImmzpeZes616hUolUMOkqCG5xKvGiDk3ORaeOYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7588
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Fri, Jun 16, 2023, Xiong Zhang wrote:
> > Perf defines four types of perf event: per cpu pinned event, per
> > process pinned event, per cpu event, per process event, their
> > prioirity are from high to low. vLBR event is per process pinned
> > event. So durng vm exit handler, if vLBR event preempts perf low
> > priority LBR event, perf will disable LBR and let guest control LBR,
> > or if vLBR event is preempted by perf high priority LBR event, perf
> > will enable LBR. In a word LBR status may be changed during vm exit han=
dler.
> >
> > MSR_IA32_DEBUGCTLMSR[0] controls LBR enabling, kvm saves its value
> > into
> > vmx->host_debugctlmsr in vcpu_load(), and kvm restores its value from
> > vmx->host_debugctlmsr after vm exit immediately. Since
> > MSR_IA32_DEBUGCTLMSR[0] could be changed during vm exit handler, the
> > saved value vmx->host_debugctlmsr could be wrong. So this commit saves
> > MSR_IA32_DEBUGCTLMSR into vmx->host_debugctlmsr just before vm entry
> > to reflect the real hardware value.
> >
> > Signed-off-by: Xiong Zhang <xiong.y.zhang@intel.com>
> > ---
> >  arch/x86/kvm/vmx/vmx.c | 5 +----
> >  1 file changed, 1 insertion(+), 4 deletions(-)
> >
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c index
> > 44fb619803b8..5ca61a26d0d7 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -1459,13 +1459,9 @@ void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu,
> int cpu,
> >   */
> >  static void vmx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)  {
> > -	struct vcpu_vmx *vmx =3D to_vmx(vcpu);
> > -
> >  	vmx_vcpu_load_vmcs(vcpu, cpu, NULL);
> >
> >  	vmx_vcpu_pi_load(vcpu, cpu);
> > -
> > -	vmx->host_debugctlmsr =3D get_debugctlmsr();
> >  }
> >
> >  static void vmx_vcpu_put(struct kvm_vcpu *vcpu) @@ -7273,6 +7269,7 @@
> > static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
> >  	atomic_switch_perf_msrs(vmx);
> >  	if (intel_pmu_lbr_is_enabled(vcpu))
> >  		vmx_passthrough_lbr_msrs(vcpu);
> > +	vmx->host_debugctlmsr =3D get_debugctlmsr();
>=20
> Reading DEBUG_CTL on every VM-Entry is either unnecessary or insufficient=
.  If
> the DEBUG_CTL value is being changed synchronously, then just fix whateve=
r
> KVM path leads to a change in the host avlue.  If DEBUG_CTL is being chan=
ged
> asynchronously, then I'm guessing the change is coming from NMI context,
> which means that KVM is buggy no matter how close we put this to VM-Enter=
.
When a perf event reschedule is needed on a physical cpu, perf scheduler se=
nd an IPI to the target cpu, LBR will be enabled or disabled in the IPI han=
dler according to active event attribute.
If vLBR event is active, LBR is disabled in IPI handler.
If Host LBR event is active, LBR is enabled in the IPI handler, this could =
happen when host LBR event preempt vLBR event during vm exit handler.
DEBUG_CTL[0]'s changing is asynchronous in the perf IPI handler,  host irq =
is disabled near VM-Enter, so IPI couldn't happen, then host DEBUG_CTL[0] c=
ouldn't change before kvm enable host irq.
Perf event counter overflow (PMI) is a NMI, but this NMI handler doesn't ch=
ange LBR status, the kvm saved host_debugctlmsr is correct still after PMI =
handler.

thanks=20
