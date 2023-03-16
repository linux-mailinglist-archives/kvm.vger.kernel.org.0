Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 380046BCB92
	for <lists+kvm@lfdr.de>; Thu, 16 Mar 2023 10:54:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231252AbjCPJyP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Mar 2023 05:54:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230492AbjCPJyA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Mar 2023 05:54:00 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE5731BAE4;
        Thu, 16 Mar 2023 02:53:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678960429; x=1710496429;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=dUt85ezuhEPvgOmk/nIkC/WgRAVIjxHV4lfgzogG+DU=;
  b=DIbYmbxbqfIUbit5mRNyMjJR4bbCxwXFV7N+175+PagZgLKBcXm/9zNo
   GOfFauYl2vHoasGqkMYwbVd7CAFCoXFIbY7EolCik1XZEu7mT870FqDxt
   g9JmINDzwfjtF/NSZtDdYxBQN0CpVs6VOzKB7Dc10nPxz1i7i+fYrxdii
   fT4jbIiyIGmcr9tJq/wE4OkJFklM+WqptzPOoJv0So23nW9TBswjH0qWI
   saB1A63A4Og5gq4vRSIQT8Reh9O1RzXD/UYjJ/KkOLerGbRCLIaOz6OsA
   Jv2VtMb+yth09rH+j8OQVhyYX1U7n3Buog7xNOcaN2p9zUPY/6kXHmVcE
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10650"; a="336634638"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="336634638"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2023 02:53:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10650"; a="823162384"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="823162384"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga001.fm.intel.com with ESMTP; 16 Mar 2023 02:53:48 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 16 Mar 2023 02:53:48 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 16 Mar 2023 02:53:48 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.44) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 16 Mar 2023 02:53:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=luVB8hAQrFTLEoPFePYSK6hhBR20EtBk+EileddjXZW6BPwCj4EUD4jwIJeLRMnhOYk6Fdiq0rrRZOH7v8zq3VxeEiMFrGIeSQYOsm2m/g/Zt++cfT6yE17hAv2AT6uBRvkb33NSxJjPg2mkFR/2uqBYIcon6KznkRvkNW4r3wyZyEIp+7igsRdRuBuJoOVW9vygKaSm7JQeImnkJu9ZA/C/BtYsewNMg5Gmjx4p9rptL5g+tmSBi5/x86e5BhZc5yvAoQQRdxG83ph4TI/bRZpsbadhEBjNcQX+1Cq2rtrwHut67jR+sikGJ0N2twdqDnTU+Dk8RmTTYUbJUOaWMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DqMJ7PtsrN+698UjF6p9e7UpSm4RUVvX/TsVSyjblrk=;
 b=K38ssrLHQBSluVROCNDH/oqATWbc6EVKQnoBXYzQRP78OxV5/4T2PtVtBP5fKWVuH5OmTQU+68bbx4ZbRGQtIeHW4JjooksGLbFw5/Poz8+ddRhoRONX8POHibswET0JIArqK9sijyznfD9sxgy65o6gva6S4lLGX69HrTVKeffI5ycXJYciyM3+xOrgRP70Kl10IgTbTgW1SudbXEFOtaE/FAL0YCAQr8hmkxkIUjVb6IgEjrNoBm26O098GY/yxcz2Ve9PuGNRrQYUS0KK0NNsSHdrASRC3acWoU8HA8lxkc8hta33bZUMxfXTtYsqeywGf0qcQ52aKYIAZ2KtpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 MW4PR11MB5824.namprd11.prod.outlook.com (2603:10b6:303:187::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.29; Thu, 16 Mar
 2023 09:53:44 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::b00e:ac74:158e:1c7e]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::b00e:ac74:158e:1c7e%4]) with mapi id 15.20.6178.026; Thu, 16 Mar 2023
 09:53:44 +0000
Date:   Thu, 16 Mar 2023 17:29:08 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>, <kvm@vger.kernel.org>,
        <intel-gvt-dev@lists.freedesktop.org>,
        <intel-gfx@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH v2 20/27] KVM: x86/mmu: Use page-track notifiers iff
 there are external users
Message-ID: <ZBLhZBITQo/ieexM@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230311002258.852397-1-seanjc@google.com>
 <20230311002258.852397-21-seanjc@google.com>
 <ZBGRJaV3tDTVyE/q@yzhao56-desk.sh.intel.com>
 <ZBHwjm2heYeE40xl@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZBHwjm2heYeE40xl@google.com>
X-ClientProxiedBy: SG2P153CA0034.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c7::21)
 To DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|MW4PR11MB5824:EE_
X-MS-Office365-Filtering-Correlation-Id: 916d33ac-dcd0-4c1e-6736-08db2604546d
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZeWZF9hWXSVtjyLAK7giFkLpF1LoVROOs6PMAEH7u7MwIjsYJMIBHYWZMc1UZ7af7x8Ibchc+bNa+p7w0zdVlWPy4C7C+QeNPkhz1UNXLSDTF2U4YEjb76qII6WsJVgD/yqGoOJg7lR/np28P2jiX7J5fuhw2lG1bG5YlW6Yr8w3RRX62VfpOEzx26ltXKQr7rKRsPvxm4Kaq57JncsVb0FvG/S8mAdZiU6v4/JnyeRFgMXAZHVzjl8nBtuXA6kO07QFhcFGmgpJm0AHtHmEw5e+H28e+Avp/vVLkVH3epF0qyOa5YASwXYxq3HOG1mlq0OFx3sqVpjKzZ+qw3o7ZFihG9tpktPcen0LIGA3yC+/NGLrgQaXGWRWvtrqxdosoRTqolromPKWhGIGtkhVWSG64MfWidY6sSVKpwqc6W50KinIxf4b3yPsmw5FZLRrHsOqqE3IEjz86D+8eoFeOKEO0KZ3ue6FN2jE52QD+Ka679hvFgOsJYQ15c61EXqW//21Tm/JLipc7Opus21lKafzRvqzKkRIJw4Q1Iz3KoImpxdZO11e6sCRppIh/I3uZEPLp7u5Vsw8hy79vyJhB4MXjvf+1PjTSbdQqKnLf95cm7OvbKyo+sIzHFIL0fysdI8CYZ6fNyYiQ0I5qgHo1P2QmriQItaDhV3Q++/zHt5e/9wgLMXnF2/bwZBIbtYUUjEFD7heuHCZ8PZwGaCD8on8QN4zMYDWF3FHGXgngr4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(376002)(396003)(39860400002)(366004)(346002)(451199018)(38100700002)(86362001)(82960400001)(4326008)(2906002)(41300700001)(3450700001)(8936002)(5660300002)(6506007)(83380400001)(6916009)(6512007)(26005)(186003)(316002)(54906003)(66556008)(6666004)(66476007)(8676002)(478600001)(6486002)(66946007)(26730200005)(19860200003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7L4GuzPco43zHaPWUENCfhcym2hjJquogTC/tGWMWO67PkSIXHxlJ6EwxDnX?=
 =?us-ascii?Q?3BZe12d2AZR9ngFG4ariUfKV2ZudNGgyn1/q3SyaaeRhPPvPUstoxoIOa2gw?=
 =?us-ascii?Q?LGtDzOpqKqpA/Q8HRHtPDaMKY1EQmZMzSEZj1bW6CBBASxUCUHp9ESK/+xll?=
 =?us-ascii?Q?2mRC8BkTmL2nZA5cOjWp+XFJUlRDUgIuK5TjHJc87f3L2XF99/KbZykQC9LN?=
 =?us-ascii?Q?XVL1ncaMsdaBPrnFV+p4/+X2+iUwdu8U5qCvx+PwKpnDUlbMgO+Vt7lFv05a?=
 =?us-ascii?Q?ZSU2f6wsVALPtfj0Zw6RoCpfEzQr/Cxuruww30e06tiRLBklBO2FMA9pyHYa?=
 =?us-ascii?Q?rrpk59dwCN715u25KXqMADDwAAlVozhnriklWG2jr4CpU2rByXMlN7lJdixW?=
 =?us-ascii?Q?NjtfEBBKrci+LZABT4v0eFrEH3Qt/pzIeTbfnONrK/K8dEu8KuXOWcaEm0OW?=
 =?us-ascii?Q?KX+S++XbnylYkLiFcLOUKQaniApDF9rRpJWHQAoejhA03nX5ripKinJ7A7Ug?=
 =?us-ascii?Q?L0xwc2sERAsxvcIabpbjGBXC7KKnkbRbZvsn7sYcmjYJeB5I3chrHqq5MJFJ?=
 =?us-ascii?Q?WzLolmz+VUq36070gvIHEdWAWXurixh8cz9XWHaxekySxTvvlaoklzlVS1ve?=
 =?us-ascii?Q?TrwlBkSLByo7VBiFWdmn+Y7XZlc1tSTWFsNNZhee96O+wE57CAYQ0LJqDmMC?=
 =?us-ascii?Q?hOQKt7FnvrvtJPCjadFH6EAQvAPSWuBXFAY2g2/ZDapQaPOaaHiDAfVOBWOW?=
 =?us-ascii?Q?JTOWSpsglxQtorY/dnHpunPyelAlO97sbpSgZttPK2UYkusQk4XaVNyP/LCk?=
 =?us-ascii?Q?+Tr7G85hBz0MP07V92US/qIFmluHamzeh9s4Iiv4xQfbh9Rk22XY/VrPVrI9?=
 =?us-ascii?Q?44riUfwQgMPdjSFCr0cQ1P99wSnv5U7Z61bTZw1Myr2nLdUIY1qBW6J06gtm?=
 =?us-ascii?Q?LINgmFVwdD/s/ifikvJXA+viaNJeC9vAvA3R568xUyjS+n4awqhzrUq2JDh6?=
 =?us-ascii?Q?M2WKx+tsm8uyDNbWLVfeYOQRbEDnzKhbno5rGTzAvhvHA7VMMGtKODwGwh8b?=
 =?us-ascii?Q?dQq+w9bnrExthG5UZ/SDruLUjmF+5P2cmkHDQHiY3r2SXMu3fHd6dPk+uP7u?=
 =?us-ascii?Q?wi3qsbzST6aOH+PeW6rj/9jMM6NB+dH/o4FmC1HvRkwYEmXnsYnot6pYcPZd?=
 =?us-ascii?Q?6BVlaujh57FdGnin5UYS+UjtkcKJLMR0o6dIQS3nghPzcWBvCWE1afsyhmMx?=
 =?us-ascii?Q?IARnz+uDDj4/8wOknoCmSSitC0eltmKiAPRUnDCR1hLb6h4mWx86H4SrqGVW?=
 =?us-ascii?Q?/uq8LM374nobfhEqLJou4tlTeNqFY/q9Z+yPDpJyaWf2ZRu6Jfn7+VONi7jW?=
 =?us-ascii?Q?LSb+Tw8xSRascU/8Yxh2tnBDZXn9t4XD6fMiHj4FtNyoHBj/saxrSbCzVI6m?=
 =?us-ascii?Q?PpyQGPg9IJT5f+rKqV/xTjjaYyClF72wzUASrwboZUM1ko5dbIlLKUIPhNOP?=
 =?us-ascii?Q?yVmtqwztdqPQhoaVjLSxNE9WBeDGe0L9lxTZ6/S5A1V9uEhJmO6OStAB5Yhi?=
 =?us-ascii?Q?bhM7Gv2GbqnsPLtAMSN0vHB9NtK5K7FY0kHRkbSwsvMRXj+qJRSTJixz8aqo?=
 =?us-ascii?Q?rA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 916d33ac-dcd0-4c1e-6736-08db2604546d
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2023 09:53:44.3893
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3KPR4O6+dM1sc71259D/2tuCuyHFzIYm+5kPmXTODuhRX3sExFxYAKDAuueRnaKYJoSuZuf1//l+J57kRO+goA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB5824
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 15, 2023 at 09:21:34AM -0700, Sean Christopherson wrote:
> On Wed, Mar 15, 2023, Yan Zhao wrote:
> > Nit: there is a typo in the commit header: "iff" -> "if"
> > 
> > > -void kvm_page_track_write(struct kvm_vcpu *vcpu, gpa_t gpa, const u8 *new,
> > > -			  int bytes)
> > > +void __kvm_page_track_write(struct kvm *kvm, gpa_t gpa, const u8 *new, int bytes)
> > Line length is 81 characters. A little longer than 80 :)
> > 
> > > +static inline bool kvm_page_track_has_external_user(struct kvm *kvm) { return false; }
> > This line is also too long.
> 
> The 80 character limit is a "soft" limit these days, e.g. checkpatch only complains
> if a line is 100+.  In KVM x86, the preferred style is to treat the 80 char limit
> as "firm", for lack of a better word.  E.g. let a line run over if it's just a
> char or two and there's no other wrapping in the declaration, but don't create long
> lines just because checkpatch no longer yells.
> 
Got it. It's helpful to me!

> There's obviously a fair bit of subjectivity, but the guideline has worked well
> so far (hopefully I didn't just jinx us).


