Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F222624FFB
	for <lists+kvm@lfdr.de>; Fri, 11 Nov 2022 03:06:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230323AbiKKCGK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Nov 2022 21:06:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229958AbiKKCGI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Nov 2022 21:06:08 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CCE75D6BF;
        Thu, 10 Nov 2022 18:06:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668132366; x=1699668366;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=XcHlKstWJwcqypYdcJFLgWyXK/c+pS5/NlMwS5QdMMg=;
  b=EgkhvPbabUjden6Kt+Gqd67ar/65OIc1unY4nhvmnHCuJFRHHl3OsWsj
   jz3DLWP5a88IQyF2ZcOJvk3AR+EAajV24r24oNVDyXyxDpSmRyxOoyRU2
   gHtCYWdDE4nNdFHh/aBum/SnlTlVXQ9kdiX9l56QKIcg76/n2kYNWMvDQ
   6cj7K3LGFWYwwGptNWsmS1FokRR4mZSREhD+88ELgm1UJnkoZTnH6lgW/
   s0gJhbCdKCQFfm9vrzpnZG05FAcav0bU9FcNiRCNBFflJ//kQKayfSKsj
   IJTjxHHxaT2xcTmMbCr7qeAQ4vqU92mx+nMbHy49+XJHAYAUPzBzvAhJl
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10527"; a="338265190"
X-IronPort-AV: E=Sophos;i="5.96,155,1665471600"; 
   d="scan'208";a="338265190"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2022 18:03:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10527"; a="670583054"
X-IronPort-AV: E=Sophos;i="5.96,155,1665471600"; 
   d="scan'208";a="670583054"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga001.jf.intel.com with ESMTP; 10 Nov 2022 18:03:42 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 10 Nov 2022 18:03:41 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 10 Nov 2022 18:03:41 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.105)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 10 Nov 2022 18:03:41 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=je07pAJ4aXvkKb5JcjwVP1oyaVrHWrlAOf+D3qpaOoOjbk9gW8fNG2g3tj5wGIo/KNoyH1Fln+c4l/oG5GFGehJuc31nxg7CMcSOtbj7D9nKH5UOk9BCjhmimVCgf7A7y4EtYs+2fiAqiyoPJZo9rHTQM/2tSYEPQzqU6rKEPXfQZ3ms3nCMmJgCXojkjSry5ijb6b8kGiSdYl7Ks6VvxjFnLVlAXfWFHiSgU7Cu7MMtkkCJSkWjSBqudqMuyYXAQLQltxd36jgwBhVMR47hdFP+IRl5FxN7DOLDyIA9iwS0mBcz1JbSpG7oFNQzJPMRzkf2tvdC1nbiIGCVP7PQ1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qr9AowaRUWTs5Ucc7h8SipER1JCAv9SQSIb2oehzCIs=;
 b=HjAtQboUPylTImd+sVrxGaC1atRXDAHr4D2zf4ocwPECc05iW1pD3eZ+Eq/IgB6kezlaxSQBq2eXrUn4o9M/H9+Yg3BdsIWkjVGyX/8qVWCHAP7fa1ZNDAWcJ5Jw4JJxsS/VyZjttmNvJPRZdRkmqymmmU2k5kx1QWPwVjXfXNye4L1lpzCd2/h160zSKKzQsa1CJaUoJOLQLmkqEMlaPYZGBiD5UdpQINpj6rbZDVvG0NsDNIw6UedKHuOFtXEb+7geeyKPY+oT/fUJOQyVO1mreGFbx6R6bjAXfrHKy5mbObvG16fpcXZcNsnjHdod1t+gblVD63UkWRw7xh5FGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DS7PR11MB6061.namprd11.prod.outlook.com (2603:10b6:8:74::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5791.26; Fri, 11 Nov 2022 02:03:38 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::dc06:6d36:dc8a:fe7f]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::dc06:6d36:dc8a:fe7f%7]) with mapi id 15.20.5813.013; Fri, 11 Nov 2022
 02:03:38 +0000
Date:   Fri, 11 Nov 2022 09:40:54 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <pbonzini@redhat.com>
Subject: Re: [PATCH] KVM: x86/mmu: avoid accidentally go to shadow path for 0
 count tdp root
Message-ID: <Y22oJhrIxSgkMrj4@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20221110034122.9892-1-yan.y.zhao@intel.com>
 <Y20svCKydu/iS0TY@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Y20svCKydu/iS0TY@google.com>
X-ClientProxiedBy: SI2PR06CA0011.apcprd06.prod.outlook.com
 (2603:1096:4:186::16) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DS7PR11MB6061:EE_
X-MS-Office365-Filtering-Correlation-Id: 696eef92-6269-4e0a-651c-08dac388f2f7
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: epau7QtPDZNTsaccBy7GcT9zG9PgdKPqilTGAwZkq8rjIfXo7D85kqmZSMH6EQo/Hkj1LlEY9euXpA75k+DTRo9GTsBjEtlJgM+RGiSPc9c4gtOfnwsuD+aHbbgOUzCWZR4o3iKD7crPDIXXNs4rj302kEbu2HD2Jrlrm2csPRCEjtowOMbOx9djdIUHKcAMjXw8wUkYU6N/62wH8ZDq2vT/YZHuB5iXiQiRLX7S19VneYMHx5KXmENYqBZQ1vcnfEfjcTjOD1JB3vjcVrtohr7pboSImQ5qvyPjV4S0I1aALrAD34OoKOZTT1CLj1SEwyhAKgADO3TWRV8jsvniownnd46M3u/e3sw7hbna60uU44rwbxIM7nKHChNzD54hAB5pZmbOUulnWb/waWG6NmOyJI0cmRgZv/xV7kTkSV5fCCOZir8m8j1AtHbDHncWojyeDEvOgElJTMH5ZL8PX7KxNE7qmBub0d9eJtzCN/IHS5EXMk8zVcbiqeQOV4HqPxI4GCNFnWiuj2Jujg929WStpjpI4dd6upBFrsCeHfwVYH7mg6SQITM+G4uZdZaCC6oTrclAxJIUSHfBPBTi1VPjp7VxtoBfLn21HARZvj9MhOcDH3oueDqF7aPMlor8kVdAT6kEtFeBnw1KzBpqkavKZZHg7jh8A+m23Hl2ivLZ8QbYp9OFIH0evisfymzYUdGQjGK15aEOh0xDSWDrLH2B3EE9oAMYjwpGuzT3kb/OxBBxzdsmC75+v5uh1EPk
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(376002)(136003)(366004)(346002)(396003)(451199015)(86362001)(82960400001)(2906002)(6916009)(6506007)(6666004)(3450700001)(186003)(26005)(83380400001)(8676002)(38100700002)(66556008)(316002)(66946007)(66476007)(478600001)(4326008)(966005)(6512007)(5660300002)(41300700001)(6486002)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PSBb5lvZ2FG0XevQLMdiUX5ZtkGT9DZd1V6euqIsfSQ0uXj5HPM89sXKw7DE?=
 =?us-ascii?Q?3+sx4ydhyr/i1AspIIAjOdAh5vbmfDQTsxLmHtTGZwvbraLFBp+GRFjzODXn?=
 =?us-ascii?Q?dzJo+lM1TKcS6dMW7Hknehhm/p5hFwDu2uv/7h2DqvIcft5WofAI5pBcNO3S?=
 =?us-ascii?Q?jBACPkxnp691Jz2AmD+tEn1vSZfb3KpgLP8RYg6mioTFrqcXuZDxqHRAdDnb?=
 =?us-ascii?Q?Z3GsPDvIKKpwsViR0yKmmjdFIYBafWhMm5TQmc5t98UXUoPwBI36l6HX89Ck?=
 =?us-ascii?Q?P3emqd9OEUKImWmP/x4qGWw6ZjXSTjq0OpmZ7hlPUWLgyccQ2G+OmivC6TQv?=
 =?us-ascii?Q?3OzzumcdX+SJxHG0nxeV/KYqSj/ylhmlPxe+c/x+2AhEsiVgvDep4Vzc2bX7?=
 =?us-ascii?Q?ajkOuYgPtc/v6MNowj1tkCDmqXzR6djJQ881NOrHri82gplMGsVAB29GOtyx?=
 =?us-ascii?Q?Ypikzf1tALlR3WKg/AbZNnJ7qx1YM6vx70UaUjzqf59QdoHIl0L0RPDT8odO?=
 =?us-ascii?Q?weniXnzAv/thg9ByUFXsuq4cSQ+eZqUTr9iaOfuf9227YM4JL3WPSSpCU+KW?=
 =?us-ascii?Q?M0/mcz8GXTwAem09hZ1iDg5XbXbFxF5gzuLSWeVd43kl2cho7MDBQZXe8vfD?=
 =?us-ascii?Q?OdTeYIGNU8nXrqkXtpnjA5Qr7OrF+pgj4PDsOccTAE87GX0znhbviKV9Wy3h?=
 =?us-ascii?Q?bx8c9L8hNTt6JFaPs8lVIktbf8WNtNG1t/JCkgf/1L6VY6QguM3ek90nmp4m?=
 =?us-ascii?Q?jN7xRPUwAH7bcHhjLNpmVwmC3GHiMxyUEMs3FKHjO2RKVpPCua+zOavrnVcX?=
 =?us-ascii?Q?GLLssT9g1lU4rc3LRbhelWZnP5Fif08Ujsi7NLCtI/mum7uaz8a+uthyz/sz?=
 =?us-ascii?Q?V5UrA2jqtdxpaiFJlACzc5DHDLzopKCp7/vQdWH4D4yJiv0K5rJISzKUMCXN?=
 =?us-ascii?Q?BGqsnGteGFIrXiRvLQ76oS66WFLyyD1g/YEu5YYyncbLMQMsefnDf9qJ8kjq?=
 =?us-ascii?Q?jG70EDD36nrJki9DtX2PGaUokoTe8VmHywJicZ7tda0wQKlOtidr2sNf3Gip?=
 =?us-ascii?Q?mEhllz42mKPyLtOnkFkoDbRGN8mhxD5BL6cP+xYc9VTG1GJYvfHbh+d5zsNW?=
 =?us-ascii?Q?sKAQdSo7e8rsGF1EA/x+DUGfIJut4LIQHKty0VW9ztL/iS3mMHyv6++kgzSF?=
 =?us-ascii?Q?HjneX/H3aEMGXrNpWhn7P0MqnHakeuSC+c8vnmbwHho8vALA58EkW8DxZHcz?=
 =?us-ascii?Q?DkLK8DT5zfaQsFHJV2lKtwaME9vcsJEak9aKmAsYR6O4BLKY4T2ETZAlUSbx?=
 =?us-ascii?Q?ADP02fG/jvuTkfpWO4322A5KOOhi0TXo5cs9cyajAYR6tZLx8iE7HTZvBSik?=
 =?us-ascii?Q?+Ow8kSVg2Em061UQpfMv8fEP0+5ptl1lPpzpAsBaoXM0uSiCoMgZs6RyDxSo?=
 =?us-ascii?Q?PyNM9E/zEJU5N9ec5xMOndahzUzjaYsdfHwyuo6ZrhQHps9Rgxtday6891z5?=
 =?us-ascii?Q?zQwAkMK9MXhx1Ohu/pNqzB/uf57vbkvmINhLTrQ+lLyNwqPGMomWNTHRJKOR?=
 =?us-ascii?Q?gKlNLT10ueU2BiaT/5FwSe9HaoRLoKLBtFStJYc3KWOH8O+WIxcmg6UiZQ39?=
 =?us-ascii?Q?cw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 696eef92-6269-4e0a-651c-08dac388f2f7
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2022 02:03:38.7176
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /XiPLPyuSwppVXXiprxSXc3W3kAbjsan/bUoOqyYnpSoeNw02KTkmxw5Lp3Lxx7hNxlioBuAtF3HsoM4dD8l8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6061
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 10, 2022 at 04:54:20PM +0000, Sean Christopherson wrote:
> On Thu, Nov 10, 2022, Yan Zhao wrote:
> > kvm mmu uses "if (is_tdp_mmu(vcpu->arch.mmu))" to choose between tdp mmu
> > and shadow path.
> > If a root is a tdp mmu page while its root_count is 0, it's not valid to
> > go to the shadow path.
> > 
> > So, return true and add a warn on zero root count.
> > 
> > Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> > ---
> >  arch/x86/kvm/mmu/tdp_mmu.h | 6 +++++-
> >  1 file changed, 5 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
> > index c163f7cc23ca..58b4881654a9 100644
> > --- a/arch/x86/kvm/mmu/tdp_mmu.h
> > +++ b/arch/x86/kvm/mmu/tdp_mmu.h
> > @@ -74,6 +74,7 @@ static inline bool is_tdp_mmu(struct kvm_mmu *mmu)
> >  {
> >  	struct kvm_mmu_page *sp;
> >  	hpa_t hpa = mmu->root.hpa;
> > +	bool is_tdp;
> >  
> >  	if (WARN_ON(!VALID_PAGE(hpa)))
> >  		return false;
> > @@ -84,7 +85,10 @@ static inline bool is_tdp_mmu(struct kvm_mmu *mmu)
> >  	 * pae_root page, not a shadow page.
> >  	 */
> >  	sp = to_shadow_page(hpa);
> > -	return sp && is_tdp_mmu_page(sp) && sp->root_count;
> > +	is_tdp = sp && is_tdp_mmu_page(sp);
> > +	WARN_ON(is_tdp && !refcount_read(&sp->tdp_mmu_root_count));
> > +
> > +	return is_tdp;
> 
> I have a series/patch that drops this code entirely, I would rather just go that
> route directly.
> 
> https://lore.kernel.org/all/20221012181702.3663607-9-seanjc@google.com
Thanks for pointing me to this link.
Yes, it's a much better fix!

Thanks
Yan

