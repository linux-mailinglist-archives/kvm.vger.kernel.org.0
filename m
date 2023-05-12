Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C74D46FFF3B
	for <lists+kvm@lfdr.de>; Fri, 12 May 2023 05:23:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239829AbjELDXm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 May 2023 23:23:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239158AbjELDXi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 May 2023 23:23:38 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EB9F1FF6;
        Thu, 11 May 2023 20:23:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683861817; x=1715397817;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=fhA+wivl9bxQFEBIWO6r6nXXblPUB4yrs9rBIiaGnb8=;
  b=HIBidjOVKtlNOms7lY+pJAA5QnNPmez0i//bx17u2vrFgp2YATVA3u8I
   uZ5GSYr+d7PAFs+Xchi04MlK8RCg/qz5DcB103mehoBxPgDyxW8eRONXW
   7OMpq5R5p9qIOG2Y5mnQEexkgyl70x4lsA0CIGkG8v6pCOPfrbC4qGGaD
   W4ToQ2VrsLQYABeo6FaTDbc+1r5XYK6RNFTXF2l11aawukFCTCnOq1jFS
   8RLua5TrKCmmb1Sv5Wa+TUKetYy9v6Ymxeq/FIppNXgYcv4prsNg/FsXo
   xjadAg3ZqtEKsGeWd+RBmXjrGlyhOtxqr9AcUTi8YU9Ly+m1JZ6rTQCWN
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10707"; a="416319245"
X-IronPort-AV: E=Sophos;i="5.99,269,1677571200"; 
   d="scan'208";a="416319245"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2023 20:23:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10707"; a="730645938"
X-IronPort-AV: E=Sophos;i="5.99,269,1677571200"; 
   d="scan'208";a="730645938"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga008.jf.intel.com with ESMTP; 11 May 2023 20:23:27 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 11 May 2023 20:23:26 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 11 May 2023 20:23:26 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.174)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 11 May 2023 20:23:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dxJ8TaVWWH3RyagcH7sOE7BT+8Sv/2H99tgz0vsGn0UX/3NCdmWSW8z/+PuJ4w03y1JOQ1tVb/XH1UuofTuHmBqZ7yaW4K9VJkVczsUOC6ooJjq8jCMtIuYxCNRx/pPbcUqnpodyLjmmnjfzp6sFnMReyWtydFg3m1Aloy3IVozNJXGW4f2eDyWRgxOxRtS1iHR4AHIOoq1nr8QhH41fC9Z630W3tsvTfaoHTP0rNesWOZqH8lqQFlQa4WFbsz/kQvqIt5xiAu6NENor77iYytR+fmlgOgG0Phcs7NrCd/r/PUJ9Qf4Li3iO/ilFqIvzA/MUlUJLLHJfV1BWaUgq1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=shtrCStAY7cjPJhKhUXT2pC/3tfMAcwRtxdL4fnFwAE=;
 b=nKdEPo+cDTVu7V/ucIjeHWABGBuiEAT5Qfg05ADriWt7NmAS9ZgQkgvDp+wTIABnALpOIjkyTnUwNwOP4D/HsduXPIbbrDiawlE5gaAcRmzIMmYNY0cb6SLC1wqLwKE0LTp5QRFE8wDvuxr4PDTsIxWteOORCZI1PRWtCS7XokUn9YWZD2wYD5hVgcFAhAoJo/V7PjhenbhkPd3dNb35+/+ty+FsvULgas9TxTpTi19IxBVujd4YTuVpfww6LvM1n0XPzWpL3OvmwFwh0RJxD7P7qlax9Eewu8rbo/wRT4NV9c7Lw74gyyrI+CVo2+AWZGIBwVuTr4wxkZP73NhUyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DM4PR11MB5565.namprd11.prod.outlook.com (2603:10b6:5:39e::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6387.23; Fri, 12 May 2023 03:23:25 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::a670:49f5:d602:e2e4]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::a670:49f5:d602:e2e4%6]) with mapi id 15.20.6387.020; Fri, 12 May 2023
 03:23:25 +0000
Date:   Fri, 12 May 2023 10:58:20 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     <kvm@vger.kernel.org>, <intel-gfx@lists.freedesktop.org>,
        <linux-kernel@vger.kernel.org>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        "Ben Gardon" <bgardon@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        <intel-gvt-dev@lists.freedesktop.org>,
        Zhi Wang <zhi.a.wang@intel.com>
Subject: Re: [PATCH v2 25/27] KVM: x86/mmu: Drop @slot param from
 exported/external page-track APIs
Message-ID: <ZF2rTFD9pTIVK/A3@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230311002258.852397-1-seanjc@google.com>
 <20230311002258.852397-26-seanjc@google.com>
 <ZBQkyB3KJP34D9/h@yzhao56-desk.sh.intel.com>
 <ZBwS0DNOwMf7OVmV@yzhao56-desk.sh.intel.com>
 <ZFLrOgUL4T/lrVLo@google.com>
 <ZFMVsFzpN16hiPUH@yzhao56-desk.sh.intel.com>
 <ZFhNHB4VWp8+5wWp@yzhao56-desk.sh.intel.com>
 <ZF1usP8CGPxZWIj3@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZF1usP8CGPxZWIj3@google.com>
X-ClientProxiedBy: SG2PR02CA0103.apcprd02.prod.outlook.com
 (2603:1096:4:92::19) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DM4PR11MB5565:EE_
X-MS-Office365-Filtering-Correlation-Id: 0b8ce9e8-2707-4e55-2291-08db52983e97
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +IqJLyT+1MIXZKBZjpMwZno03u1LiMipHxGRcXvFlUM04HAex5h933/rFt7mKI9YUVuaz9+wQGBCmRf4wCehzdNQ0fci0W0RZvVuvkCDAtTYpNX+0ptNGmhzKS+fE/SPXdW+fqHiXmmwMj/boi/6ct+SZm8CVZT/Rq/VbZzgQAiPCQlQ3WS1ahRBMB3Zjr/qs7uQmHg4+D9Yq6abz7DW+PL+LDlWLJ/c1TT4i0ctxta0vdHaymY6sNJtdg6K5ZPtxGmA4epOm08RAjiUMP5puu4r3ESQs8q1CBf+EQR4VlQAVuRNDCBn2f7FLCJCl26gqinwyG3THtSZ+C/gRvQa0vhqldq3UtP1w9s54e7tXhSRLEq6SC2sJPLHyz++BMRS46YovkvjIeRc002H7S7YWo6gXDcC+BbvQLYJEtGfcIn9p7rSLKE5LtUOUyx6us8JPlBaz+Nbfr6HWTRvjpN3QhUFn4bjAGwqf9UEtsgPxkdZeC1eZYOpfnrbbdfOTK6g312qJ6NfKYH1Yk1DaxJEUAN7Oexp+MAf/PYO/z0FIXZJjqg/lwu4h12PwSFdqEQF
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(136003)(366004)(396003)(39860400002)(346002)(451199021)(66899021)(4326008)(66476007)(6916009)(66946007)(66556008)(478600001)(6486002)(316002)(54906003)(86362001)(83380400001)(26005)(186003)(6512007)(6506007)(8936002)(8676002)(5660300002)(6666004)(3450700001)(2906002)(41300700001)(82960400001)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cBXogHY5pZQMJ55ZVATI2zzYZBnqr0ZiKPE4yiMyYksFwm1wUt7Hx25z7g7i?=
 =?us-ascii?Q?6oX3jbXgRArQUFPPtg4EWyWJw6xJfCad/u+k7JNt3uo42FRDCM/LbRMoq6vK?=
 =?us-ascii?Q?JOWl7kgFSOko0VCCrwQaikCIqnWvXjrHjcp7EsP+z2abkkQlg3RW27mR4oIH?=
 =?us-ascii?Q?pUV24VLBioLnrdOnHmmpMoiKsPZbOcQ3FsLmW259tCMR1IWZPmjaZTqbN27Q?=
 =?us-ascii?Q?iHZlwjwYJON+CVWMlMNvuZ+BbGUsxBpC7T8ib4q8417Mkug6LW5HSNqtdWsd?=
 =?us-ascii?Q?emU7Weqj6DISlUgfJP/71rPOIW6JBF4v+eSfmRr7EbUcpO0cdu/PNWSGF5yp?=
 =?us-ascii?Q?jkfstez1wkaW0Fc14WHe44gPBGsT5iJTeFobqSDu7CLPQ7nW597MzkeVIdfg?=
 =?us-ascii?Q?cVf2ZpX1kHw41JhQG/fM+1c/9X/OwZ0zGQOYsmyHSdWM774fNA6IPddxvfDj?=
 =?us-ascii?Q?Kex6FRYLEcVLjpiZAlJzWs1fxKxM1mhZmQqxQ9XvoMCGwEj8gagFySvfJAw8?=
 =?us-ascii?Q?g/LSdIvAb3MJf6F6TGNFsGIW12kdnrMCIcQvRCDoEo7UlLHD5GhU9ka0WKXg?=
 =?us-ascii?Q?hzoM8UcMPUWLt+lwAprD4NGKl8dlcU5QUHBip7eiWtxnMI4i7z1cnKSV53xx?=
 =?us-ascii?Q?Iaf7x7MDFEnj1sw5gA4EYEJeTNRgrMi+PwN8OngRADdC8I+mCiMAXd1SWIRn?=
 =?us-ascii?Q?nqpYY3CDKjyK39EYCWI2mgbwWI4y3qs1o3X8HNsYbsu+AdDTj397rej8/U1j?=
 =?us-ascii?Q?2jTfUrgDrp8t6wGvBuowtBw9wIcccutqYRJa9E3E7uUQZybyU/zWLenVlMRc?=
 =?us-ascii?Q?sey/TsYsIjVZfs//YEhNO9vsBPE8KBj0S/O5VLnyxq2XkiAkUpKyRsV4CmBt?=
 =?us-ascii?Q?VGC7aDF5AuQ5I0+1AHTrReqi0M2mfy/hkeTnybfHXzLjRjHGtFOHmfX57Sc/?=
 =?us-ascii?Q?SzgpDO0NQhsbRzeLwsoX8rvv0qHiVcPK3QqPrIP6GWxALq0AykHSD1lSOmsy?=
 =?us-ascii?Q?OPAcvb0L2AMkBaE0Kjn1j1bEtzchFMagJgTmX9AUoan8Bfcw+NDni+2zeXO+?=
 =?us-ascii?Q?1BCZYW8Uv9IWGOe+ndrKD6ckRlxDKtDAPH+ivzGSi3YXQyelQBQ5LIUX7dC+?=
 =?us-ascii?Q?sJ+YoiJwgCvg9GdHWhw/ZGPkzw8CreqkJ7iVWaawMPfRi9lqVYf4sBB8tjGh?=
 =?us-ascii?Q?+tSZaNPRbHloIccBsyf+86OKCmOtCZZslIazPvpISeBaAeln4pczAYflVCNd?=
 =?us-ascii?Q?w8IyuPtEFDsBlbMPhdT6v1ypSYIjES8/K67uOCjvFFhftJjiuQdsnmeHA3WS?=
 =?us-ascii?Q?95IrQDwt0fbPURiPlkEoNy1LsYGLEdYbCbySzjecPwyn0/S+kt9Qo6rQQTqK?=
 =?us-ascii?Q?LBlVk7093YlLgvzCrz/+8557xcUl3sWUXQX7HTlcLzsT6dLpe++OLyDC9yZA?=
 =?us-ascii?Q?S4/e20bRGiF6RgyNtOTgGcLIryIghgyxPCfQ57ArlJvXBYUImcpD24bh51FG?=
 =?us-ascii?Q?AdrNVSxLqLh4p18VxhKA2rquS5nRKgvy/toOEgsttMIw4TcFPCI4aLsuFi6r?=
 =?us-ascii?Q?pCIdmw+/iT5C5kUXDQFBXyibOMk4s3KalVg3NbIi?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b8ce9e8-2707-4e55-2291-08db52983e97
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2023 03:23:24.4998
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lkE+gPv9WSf1r8vllE1aaEnd+T2YSuWtGBymFNcfv5SWTS5xNo3Yg+MDltugqLwVsMMQITvvPayRGlHxIBUkZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5565
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > Hi Sean,
> > After more thoughts, do you think checking KVM internal memslot is necessary?
> 
> I don't think it's necessary per se, but I also can't think of any reason to allow
> it.
> 
> > slot = gfn_to_memslot(kvm, gfn);
> > if (!slot || slot->id >= KVM_USER_MEM_SLOTS) {
> > 		srcu_read_unlock(&kvm->srcu, idx);
> > 		return -EINVAL;
> > }
> > 
> > Do we allow write tracking to APIC access page when APIC-write VM exit
> > is not desired?
> 
> Allow?  Yes.
>  
> But KVM doesn't use write-tracking for anything APICv related, e.g. to disable
> APICv, KVM instead zaps the SPTEs for the APIC access page and on page fault goes
> straight to MMIO emulation.
> 
> Theoretically, the guest could create an intermediate PTE in the APIC access page
> and AFAICT KVM would shadow the access and write-protect the APIC access page.
> But that's benign as the resulting emulation would be handled just like emulated
> APIC MMIO.
> 
> FWIW, the other internal memslots, TSS and idenity mapped page tables, are used
> if and only if paging is disabled in the guest, i.e. there are no guest PTEs for
> KVM to shadow (and paging must be enabled to enable VMX, so nested EPT is also
> ruled out).  So this is theoretically possible only for the APIC access page.
> That changes with KVMGT, but that again should not be problematic.  KVM will
> emulate in response to the write-protected page and things go on.  E.g. it's
> arguably much weirder that the guest can read/write the identity mapped page
> tables that are used for EPT without unrestricted guest.
> 
> There's no sane reason to allow creating PTEs in the APIC page, but I'm also not
> all that motivated to "fix" things.   account_shadowed() isn't expected to fail,
> so KVM would need to check further up the stack, e.g. in walk_addr_generic() by
> open coding a form of kvm_vcpu_gfn_to_hva_prot().
> 
> I _think_ that's the only place KVM would need to add a check, as KVM already
> checks that the root, i.e. CR3, is in a "visible" memslot.  I suppose KVM could
> just synthesize triple fault, like it does for the root/CR3 case, but I don't
> like making up behavior.
> 
> In other words, I'm not opposed to disallowing write-tracking internal memslots,
> but I can't think of anything that will break, and so for me personally at least,
> the ROI isn't sufficient to justify writing tests and dealing with any fallout.

It makes sense. Thanks for the explanation.

