Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9656071F763
	for <lists+kvm@lfdr.de>; Fri,  2 Jun 2023 02:53:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232144AbjFBAxB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jun 2023 20:53:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbjFBAw7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jun 2023 20:52:59 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2C49E4;
        Thu,  1 Jun 2023 17:52:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685667178; x=1717203178;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=2mG5dmg1ZqEtSAK4InmFSMVZWO7LWvd0woXHf/HZ5Ww=;
  b=aDl2lTjWtyc7EK0iB9wPQ+GpZTO4wVKIK8m1QaANCqgzatce9rNdi+dH
   XxDIV1JFA6FFYvyDk1QXrwe7kumqX+LnSEtab7CYvdAXr2MxEM4gGi4VE
   87esuwgmXk6fvRAe+k5FM+2ohP/dtokfK77gDbvqOuoTysM9n2U1scCUD
   JxiFVaDOxFsf9ZwyjdomavKLyvFxmhyWkBVbSAlXrkA4pjOTw8nhHbVIc
   oBy6/maNeCTKfpAAm7BUW7SWVM9LJ11/dOx23pbZ28ObnWZp1RO7pmItD
   v6tey/I+fMH1PH9hSsjBJBffLFVBjlUXL8QgpzyeCwOo9FlRXu6as7tD8
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10728"; a="355744155"
X-IronPort-AV: E=Sophos;i="6.00,211,1681196400"; 
   d="scan'208";a="355744155"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2023 17:52:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10728"; a="851925483"
X-IronPort-AV: E=Sophos;i="6.00,211,1681196400"; 
   d="scan'208";a="851925483"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga001.fm.intel.com with ESMTP; 01 Jun 2023 17:52:55 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 1 Jun 2023 17:52:54 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 1 Jun 2023 17:52:54 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 1 Jun 2023 17:52:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yaz6sGmNJsmAURrDKxEIqjPtRkcmlZ3tWWEhUG8BOKzAircLTQqx/lzpUwn+OijKs0C3JPHVqVxpseIfvrZVi2OuyJxqea9hj2Ylv5UTwaXHETe/NdZM0lminTXfgbm0tWNPMRQ7/8SlWbqWHpHL5wAzcaPY05Ea84P340VYJjlsYw1R/wE1lJIE24FniD41mtZW1n96LSs+pUfYMC24k86smZ6MG4YkrcPQ9coFJL0mjsiC5iOVA66+m7Ct6GDv7iEyD/RvHF29dk+5QPqeECjbMkXSEDZhyOPUs7nzHx1ChyDFCmbfsuYniIm3Nus/TVitB9p1pfdMhUqZjolA2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2mG5dmg1ZqEtSAK4InmFSMVZWO7LWvd0woXHf/HZ5Ww=;
 b=HEVvGdrxBUtfG8IK6JTfFxeuue7IyatqJuXFrBiTIaU0RW4cZ6LkMh6MI6jmonYfed8E5O2HtX47FQFSEnDFmUWIvMG2qt/BIpJPQLpX+o8iQwYgxJwFBC+Z/sRV5IsPvy5vVfYOewfhFw/ik35tJGVabdc6nKlCCMpBc7oFxVNPmVBWYYnHsbM3OwDrJXtLjCV0TsqDyW1JQnRLrLFE+OAC9JNAQSEU+4QpiSGxZrLudAkUZHIAubNLfmiF5PS0xbuU8uOJLhGiCet40MPJGWL9LHrinLK4V8kR8lmJ4rBN+dheorvJSVDQWwkr0nQbV1EUMQM8hZegXp7vMRH9xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB6373.namprd11.prod.outlook.com (2603:10b6:8:cb::20) by
 SN7PR11MB7042.namprd11.prod.outlook.com (2603:10b6:806:299::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6433.22; Fri, 2 Jun 2023 00:52:51 +0000
Received: from DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::14c:205:c858:1ef6]) by DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::14c:205:c858:1ef6%7]) with mapi id 15.20.6411.021; Fri, 2 Jun 2023
 00:52:50 +0000
From:   "Wang, Wei W" <wei.w.wang@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>
CC:     "dmatlack@google.com" <dmatlack@google.com>,
        "mizhang@google.com" <mizhang@google.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2] KVM: allow KVM_BUG/KVM_BUG_ON to handle 64-bit cond
Thread-Topic: [PATCH v2] KVM: allow KVM_BUG/KVM_BUG_ON to handle 64-bit cond
Thread-Index: AQHZUPwYxSWFJqdvM0K0D4p/iJpYU67xiL+AgISXfTCAAIffAIAAi9cA
Date:   Fri, 2 Jun 2023 00:52:50 +0000
Message-ID: <DS0PR11MB637327B3D6B42427E372DC8DDC4EA@DS0PR11MB6373.namprd11.prod.outlook.com>
References: <20230307135233.54684-1-wei.w.wang@intel.com>
 <ZAkZjzQ8pJQXQhJR@google.com>
 <DS0PR11MB6373F567D22270CA3CE86696DC499@DS0PR11MB6373.namprd11.prod.outlook.com>
 <ZHjDra1HbG65o4uH@google.com>
In-Reply-To: <ZHjDra1HbG65o4uH@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB6373:EE_|SN7PR11MB7042:EE_
x-ms-office365-filtering-correlation-id: 05c09536-8607-4e0a-d308-08db6303b0cc
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VdAPIEbRxRb0QC7DMItFWjzq+7YXaD8txhq9Rjch0B0zfxzJ7C/7mkiDfJWYn5mfGTzQET7lV/TWkAVNpiNM0e89IXUYScs1Cof5YP50XNCJRpRHlbVl/2qdWyOIsJfuCqssgEgCALW3eWp8TdHHkWypXOZKiqDN2RCv9aIvjf/WyuK0tO7bhBJJtIsP2kSkbD0buzqfEozofoEqckuFoNTNiY5W94WwL/URbJ5iPE1Ydo7LgqcS8KYuasJpuUJGksf6pFa9DGNWOiF6YcBD1oNgHH2VfU3cyuIytFYm5bAQ/icLRpnZo+IVfzggnEarKvSUGCJqxXlZ8AsOx6AsSuMk+YGISAqoQ+ECdqG5rkEmLhZKl+HdKVfj2plZ3y+LYEZ1zKoY3XEwSBQKzVZbNvFIfGVcMmhMOiHXWKk4sYHBsbdjn6eVwNoDlOE54j+skZkIM8CEXcpQflfXoNPADOhuSjd/6j7glHmk67IbJDllKWCOyWksKkFmR2EufZrCtiZFOnSwvlQwhKB3CQD8FHlCMZPDWmGdHXIYhVHrltMDNq20eYCQCO8oQcgub7Ex2/GqqpLSUiX+a0dTzaJSnKXCuVgP+i9agl/y36ZCKoMpftzIoajbg4m9RZqOU3ILWUE7Twkgj/48ujDhVTvMSQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB6373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(366004)(346002)(396003)(136003)(39860400002)(451199021)(38070700005)(55016003)(2906002)(122000001)(82960400001)(966005)(38100700002)(41300700001)(86362001)(186003)(7696005)(8676002)(8936002)(33656002)(54906003)(26005)(71200400001)(9686003)(6506007)(478600001)(53546011)(316002)(52536014)(83380400001)(76116006)(4326008)(66946007)(66556008)(66446008)(64756008)(6916009)(66476007)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?iLzjQr+TSwNqSC5IB+QeEyLxY6YQFrEz/UiCPNBUIAR6PlvIVVpwTFjwLp84?=
 =?us-ascii?Q?CJXvFM6UVIxiu6OfdI26hvAWDxKd6bfpx1kC5eY6sdGuUknG4OBwxY5u31YF?=
 =?us-ascii?Q?Rj92INIt+k79OiJOFbs0M7T3YFRXaAIGjOrMiPZq/UqOmUg2DKHQGgUFPpt2?=
 =?us-ascii?Q?a2udtSE5LcPHRH6Z+JlEASLtROR149bVh3W0RuM2V5nMSYcjp0EusGpyow0S?=
 =?us-ascii?Q?HIEqOUDR0FEWAYLLWcIsPm9Ge6DpYz/bZ6Z6j1FkJyOwdZnAQXHhd54ycAOO?=
 =?us-ascii?Q?67vFQoqvWsEzOPvpdr9Gq9HXQwP+lUfy6UFFdKnvrr+bEGznrcFffLVtDHVL?=
 =?us-ascii?Q?ntahDn6QkI4P91hEpw0Crac0n/S+m8eWPsTZXc0zNU9VaHmmMprj0sA97URz?=
 =?us-ascii?Q?O+yRZSQ/3/lgkmbF+X0Y9N8RBk0RoETbU8DSmJuQf99CXy12dx0qR4ehnKcE?=
 =?us-ascii?Q?dx/qd5z+gbeiGqwKk5GWsA/zmOyQ0LwaFfsGWApkEuKGgErs4lCLKi75vSYJ?=
 =?us-ascii?Q?jGQp/2OMJeMY7wrxi1MrIbFyJvFJAzWJEmjFIqNZ4Agu+AgTfD01VTVd0DUg?=
 =?us-ascii?Q?qgfWEAUysaCg+0fEDzrioBNe8puvdzZRCvfnfIF3qaIqjct+J1vTvbubTh3C?=
 =?us-ascii?Q?kUWmz/u0g4togryXzqWlMV68tCVE6zmaIRoMkppMVYOVqYj82HEOwQdJuCIb?=
 =?us-ascii?Q?g0tQFWeBN7dvuan+2JRUoi1Rqq/KGr6inaCHxRSG3XadBhp+mvoKzRTycaPr?=
 =?us-ascii?Q?9fPWIGUpto/1wociRJ8TeeIQQNfMSTeP4GzW/Cee8mha/BfbzM2eCQtdrQX3?=
 =?us-ascii?Q?NQ4lTt5ZOQRYYxHgG05SP9MO9zX/3XhmQTM91yd4q34/kqpQC3JgAiHlbHnO?=
 =?us-ascii?Q?TJXXr1RSBxwYAG57p6WYVsGmZgHuYT9kUGe8eeegvtchQk8pcWkui4tHnRy5?=
 =?us-ascii?Q?Qmpw1xjNrAjw0DuKfSJZ2QweXTsr4f1GYG9Wol/QTy/AnwLH1ucX88xW9J5g?=
 =?us-ascii?Q?C9dLTQSa/NYde9iLGWnUHLm0/CG2Vr64a5VrAsXJzGr3sd1IICfVBa5HmcTI?=
 =?us-ascii?Q?VO+xRRDoAbsxpo8MxEsY1nKnPt01qFaLf6TppnhCWl+OJGBQBkui3DDYBp9T?=
 =?us-ascii?Q?Mxat+wTJgBl1/g/BQjyUKxEl6hCWM0u1xVpyRmHmJW3bU7YHij91ranW+YGt?=
 =?us-ascii?Q?AQyTUTcu60mv/QpgZItT9tjEQl6kDj0it5854GvZzwvIppUhVkBuwGWejVtk?=
 =?us-ascii?Q?0ulZ+Uh5aHYRza+nSOw6JjDWXHRjpij+uKn5EkBgYzN+pxY6l9MhaoHpctzO?=
 =?us-ascii?Q?jUzYmDE9mNdukGGPk5aHKQ+UU2+NowKj4R1fZ7cpqt17FQrawGdEHxnoSbrS?=
 =?us-ascii?Q?a0M1a+JCPbXYOtON2h0QkRYKpRpPqo8LgDwOgDXbU+53UKfI4VLSj1NHgg4H?=
 =?us-ascii?Q?IvWCo5c2KFfk/DzmK94XMeQrQ2nnVVDzjESMp+dEK0ZIlZ3MaykR/I2RDuKx?=
 =?us-ascii?Q?Y3nJhfmuk7sLXSw+myXZA6JNWqM5AjFvc++CYD6drEoMYJ0k/J1prrWWOxLK?=
 =?us-ascii?Q?+AjrvOVDoKwYppuIVZT/1W0bsWIld6F+bGssPy51?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB6373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05c09536-8607-4e0a-d308-08db6303b0cc
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jun 2023 00:52:50.5182
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mG5hyLW2kIG8ug/8jP3EVVZmNGH+md5bxHbljtxbwyV4sWeINsu9tJ6m+x7Mxb+aMclokcHxemZxOqg7s5WpkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7042
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Friday, June 2, 2023 12:21 AM, Sean Christopherson wrote:
> On Thu, Jun 01, 2023, Wei W Wang wrote:
> > On Thursday, March 9, 2023 7:26 AM, Sean Christopherson wrote:
> > > On Tue, Mar 07, 2023, Wei Wang wrote:
> > > > Current KVM_BUG and KVM_BUG_ON assume that 'cond' passed from
> > > callers
> > > > is 32-bit as it casts 'cond' to the type of int.
> > >
> > > You're very generous, I would have led with "Fix a badly done
> > > copy+paste ..." ;-)
> > >
> > > > Fixes: 0b8f11737cff ("KVM: Add infrastructure and macro to mark VM
> > > > as
> > > > bugged")
> > > > Signed-off-by: Wei Wang <wei.w.wang@intel.com>
> > > > ---
> > >
> > > Reviewed-by: Sean Christopherson <seanjc@google.com>
> >
> > Kind ping on this patch.
> > Seems it wasn't noticed for months. Just check if it would be good to
> > be merged or not proper for any reason?
>=20
> I'll grab it for 6.5.
=09
OK, thanks. Please check if these two are ready to go into 6.5 if possible:
https://lore.kernel.org/kvm/20230315101606.10636-1-wei.w.wang@intel.com/
https://lore.kernel.org/kvm/20230207123713.3905-1-wei.w.wang@intel.com/
