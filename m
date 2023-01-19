Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7530F673022
	for <lists+kvm@lfdr.de>; Thu, 19 Jan 2023 05:27:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230254AbjASEXl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Jan 2023 23:23:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230059AbjASDrH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Jan 2023 22:47:07 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0E516D6BC
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 19:45:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674099930; x=1705635930;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   mime-version:in-reply-to;
  bh=gHEAWULJPAmzCEthGwZ7zuKWudmRxTX2m7Zgvz5sX3Y=;
  b=Q5s09AnkQIZS+ao6ZWS+ZToTxTLmobB4P6sH9+NSnxEAE7QlmVk8rjRW
   DkcDBWpwzsBsXqftc+MWz2MNneSHZN1plTJPB36A1NAz5d1FaF6CrDjuV
   08tk/8n8hViQS7ptIxNS7dbX8QQHBDTvuepY9BmmrtdNhm4AAo/2twKdw
   sxu6ZADcl4PVm36tc7pR6cbr00b6HMZ3Ck32Y8Wr5nbgvQIN1EII64lI/
   M62VAq818UPzFbbPxjUSsLTpnIGyqYcC4IVhPslTJg597MYLiXlf+tzI4
   HaySeJGYNKBK9PKmBonSOrG3lHLgjaIAXYsmRlHSMlF/JYSZIakP9J+df
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="322868079"
X-IronPort-AV: E=Sophos;i="5.97,226,1669104000"; 
   d="asc'?scan'208";a="322868079"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2023 19:19:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="802467938"
X-IronPort-AV: E=Sophos;i="5.97,226,1669104000"; 
   d="asc'?scan'208";a="802467938"
Received: from zhen-hp.sh.intel.com (HELO zhen-hp) ([10.239.159.108])
  by fmsmga001.fm.intel.com with ESMTP; 18 Jan 2023 19:19:39 -0800
Date:   Thu, 19 Jan 2023 10:58:42 +0800
From:   Zhenyu Wang <zhenyuw@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Yan Zhao <yan.y.zhao@intel.com>, kvm@vger.kernel.org,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Ben Gardon <bgardon@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        intel-gvt-dev@lists.freedesktop.org,
        Zhi Wang <zhi.a.wang@intel.com>
Subject: Re: [PATCH 03/27] drm/i915/gvt: Incorporate KVM memslot info into
 check for 2MiB GTT entry
Message-ID: <Y8ix4lqk8QYH4g3h@zhen-hp.sh.intel.com>
Reply-To: Zhenyu Wang <zhenyuw@linux.intel.com>
References: <20221223005739.1295925-1-seanjc@google.com>
 <20221223005739.1295925-4-seanjc@google.com>
 <Y6vXTcxDNovrmeVB@yzhao56-desk.sh.intel.com>
 <Y7SaklDQD0EoIs8l@google.com>
 <Y7Y+759IN2DH5h3h@yzhao56-desk.sh.intel.com>
 <Y7cLkLUMCy+XLRwm@google.com>
 <Y7e3fT8/V2NoXAUP@yzhao56-desk.sh.intel.com>
 <Y7ioYegkgKIH8uJL@google.com>
 <Y7vlOCKkJ+QyO3EM@yzhao56-desk.sh.intel.com>
 <Y773+EB35bAchVTC@google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="RHzMosFFWrhGOrzc"
Content-Disposition: inline
In-Reply-To: <Y773+EB35bAchVTC@google.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--RHzMosFFWrhGOrzc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2023.01.11 17:55:04 +0000, Sean Christopherson wrote:
> On Mon, Jan 09, 2023, Yan Zhao wrote:
> > On Fri, Jan 06, 2023 at 11:01:53PM +0000, Sean Christopherson wrote:
> > > On Fri, Jan 06, 2023, Yan Zhao wrote:
> > > > On Thu, Jan 05, 2023 at 05:40:32PM +0000, Sean Christopherson wrote:
> > > > > On Thu, Jan 05, 2023, Yan Zhao wrote:
> > > > > I'm totally fine if KVMGT's ABI is that VFIO is the source of tru=
th for mappings
> > > > > and permissions, and that the only requirement for KVM memslots i=
s that GTT page
> > > > > tables need to be visible in KVM's memslots.  But if that's the A=
BI, then
> > > > > intel_gvt_is_valid_gfn() should be probing VFIO, not KVM (commit =
cc753fbe1ac4
> > > > > ("drm/i915/gvt: validate gfn before set shadow page entry").
> > > > >=20
> > > > > In other words, pick either VFIO or KVM.  Checking that X is vali=
d according to
> > > > > KVM and then mapping X through VFIO is confusing and makes assump=
tions about how
> > > > > userspace configures KVM and VFIO.  It works because QEMU always =
configures KVM
> > > > > and VFIO as expected, but IMO it's unnecessarily fragile and agai=
n confusing for
> > > > > unaware readers because the code is technically flawed.
> > > > >
> > > > Agreed.=20
> > > > Then after some further thought, I think maybe we can just remove
> > > > intel_gvt_is_valid_gfn() in KVMGT, because
> > > >=20
> > > > (1) both intel_gvt_is_valid_gfn() in emulate_ggtt_mmio_write() and
> > > > ppgtt_populate_spt() are not for page track purpose, but to validat=
e bogus
> > > > GFN.
> > > > (2) gvt_pin_guest_page() with gfn and size can do the validity chec=
king,
> > > > which is called in intel_gvt_dma_map_guest_page(). So, we can move =
the
> > > > mapping of scratch page to the error path after intel_gvt_dma_map_g=
uest_page().
> > >=20
> > > IIUC, that will re-introduce the problem commit cc753fbe1ac4 ("drm/i9=
15/gvt: validate
> > > gfn before set shadow page entry") solved by poking into KVM.  Lack o=
f pre-validation
> > > means that bogus GFNs will trigger error messages, e.g.
> > >=20
> > > 			gvt_vgpu_err("vfio_pin_pages failed for iova %pad, ret %d\n",
> > > 				     &cur_iova, ret);
> > >=20
> > > and
> > >=20
> > > 			gvt_vgpu_err("fail to populate guest ggtt entry\n");
> >=20
> > Thanks for pointing it out.
> > I checked this commit message and found below original intentions to in=
troduce
> > pre-validation:
>=20
> ...
>=20
> > (I actually found that the original code will print "invalid entry type"
> > warning which indicates it's broken for a while due to lack of test in
> > this invalid gfn path)
> >=20
> >=20
> > > One thought would be to turn those printks into tracepoints to elimin=
ate unwanted
> > > noise, and to prevent the guest from spamming the host kernel log by =
programming
> > > garbage into the GTT (gvt_vgpu_err() isn't ratelimited).
> > As those printks would not happen in normal conditions and printks may =
have
> > some advantages to discover the attack or bug, could we just convert
> > gvt_vgpu_err() to be ratelimited ?
>=20
> That's ultimately a decision that needs to be made by the GVT maintainers=
, as the
> answer depends on the use case.  E.g. if most users of KVMGT run a single=
 VM and
> the guest user is also the host admin, then pr_err_ratelimited() is likel=
y an
> acceptable/preferable choice as there's a decent chance a human will see =
the errors
> in the host kernel logs and be able to take action.
>=20
> But if there's unlikely to be a human monitoring the host logs, and/or th=
e guest
> user is unrelated to the host admin, then a ratelimited printk() is less =
useful.
> E.g. if there's no one monitoring the logs, then losing messages due to
> ratelimiting provides a worse debug experience overall than having to man=
ually
> enable tracepoints.   And if there may be many tens of VMs (seems unlikel=
y?), then
> ratelimited printk() is even less useful because errors for a specific VM=
 may be
> lost, i.e. the printk() can't be relied upon in any way to detect issues.
>=20
> FWIW, in KVM proper, use of printk() to capture guest "errors" is strongl=
y discourage
> for exactly these reasons.

Current KVMGT usage is mostly in controlled mode, either user is own host a=
dmin,
or host admin would pre-configure specific limited number of VMs for KVMGT =
use.
I think printk on error should be fine, we don't need rate limit, and adding
extra trace monitor for admin might not be necessary. So I'm towards to kee=
p to
use current error message.

thanks

--RHzMosFFWrhGOrzc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EARECAB0WIQTXuabgHDW6LPt9CICxBBozTXgYJwUCY8ix3QAKCRCxBBozTXgY
J4qHAJsEvRUf15RF9hsDYy/tIRkTiOSYkQCgnkyM5EFADi+LMKdieUHUeP/y9aE=
=2IMQ
-----END PGP SIGNATURE-----

--RHzMosFFWrhGOrzc--
