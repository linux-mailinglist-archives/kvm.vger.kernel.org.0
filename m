Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6596655988D
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 13:27:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231258AbiFXL1l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jun 2022 07:27:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231138AbiFXL1k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jun 2022 07:27:40 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39F2B794FB;
        Fri, 24 Jun 2022 04:27:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656070060; x=1687606060;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=e5RqOyieRrgpceUiVHqgjF0xxjOK+K1asIzYt45g8J0=;
  b=jMdWAyzjGxDgjmOfZKj9vuhyaknk1UbwZGrfiM2qh8UkMpp6tJ+4L/11
   ZdVfTrROJme4RmxmsivU4tqrbEhYPdrVm02nIuKTKr6Irh7pTmvFOfZnJ
   QNsJtE4NfSeS1lPIazJy0kNWT+hPDDo8pclUdrKTtuubn2ccglR3SDD1U
   rlPlyWnu25OYiqWWHHcXKnhHc3IpEb6m3o1kgbSdceLbV6D6LOkI4MMu/
   UASLPI2XWAdnNchfGntxBYTlVIa4h+XneJr6JnqBy3s3fVUGqkMASebmJ
   t20ttW+fjbn6cyeGRFG0IRKD2HmTcgGBrNEuULhrCjNy6kVM5hewElmPs
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10387"; a="306447594"
X-IronPort-AV: E=Sophos;i="5.92,218,1650956400"; 
   d="scan'208";a="306447594"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2022 04:27:39 -0700
X-IronPort-AV: E=Sophos;i="5.92,218,1650956400"; 
   d="scan'208";a="539254648"
Received: from jvrobert-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.99.67])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2022 04:27:36 -0700
Message-ID: <c57df7a93a4ba87a834eef88227f599e00c15477.camel@intel.com>
Subject: Re: [PATCH v5 06/22] x86/virt/tdx: Add skeleton to initialize TDX
 on demand
From:   Kai Huang <kai.huang@intel.com>
To:     Chao Gao <chao.gao@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        seanjc@google.com, pbonzini@redhat.com, dave.hansen@intel.com,
        len.brown@intel.com, tony.luck@intel.com,
        rafael.j.wysocki@intel.com, reinette.chatre@intel.com,
        dan.j.williams@intel.com, peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com
Date:   Fri, 24 Jun 2022 23:27:34 +1200
In-Reply-To: <20220624023916.GC15566@gao-cwp>
References: <cover.1655894131.git.kai.huang@intel.com>
         <c751d1ce046ccc139a8bb34e04d70b1d6bc34a8d.1655894131.git.kai.huang@intel.com>
         <20220624023916.GC15566@gao-cwp>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.2 (3.44.2-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


> > +	ret =3D init_tdx_module();
> > +	if (ret =3D=3D -ENODEV) {
> > +		pr_info("TDX module is not loaded.\n");
>=20
> tdx_module_status should be set to TDX_MODULE_NONE here.

Thanks.  Will fix.

>=20
> > +		goto out;
> > +	}

--=20
Thanks,
-Kai


