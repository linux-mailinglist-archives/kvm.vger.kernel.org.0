Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A178E6BCB43
	for <lists+kvm@lfdr.de>; Thu, 16 Mar 2023 10:44:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbjCPJok (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Mar 2023 05:44:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbjCPJoh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Mar 2023 05:44:37 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB1D110A;
        Thu, 16 Mar 2023 02:44:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678959875; x=1710495875;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=t9UHHlAHUtR4YWmDtVMclgClxA1IgjudEon84fa2U6I=;
  b=dpQlkjAvmbvpGMEuLurNtfTszkpuAi0AmzrDSrtpBJxp4rurn2NI6bj1
   pEKlGAO1vM5r8gT/jg+SvbE5LXgZUzGxvlHpeyX1qFlP4+fLS9/Cpprbg
   dwseRdkZDNcL6fK3qaWCH1IhWz9CQsM8Z+rSTCq4PIwzb9bkUppUFMxRy
   eNhUt+4IfsHxH3wLWMDwevQnGb6B3tDYVXwNhCjq+s6zhj6VjeeAIewpW
   1XaO4ZmsAzNOxkandOWn9OHZnqI6J1HQydBOawATEQ9sK7xKllZ+YhXwT
   C+OHoHz7EkDgMzTRZeTKJlNupOwczilNOwqhcUikvo19/fpryxpl7E5Kj
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10650"; a="335423402"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="335423402"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2023 02:44:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10650"; a="1009159159"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="1009159159"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga005.fm.intel.com with ESMTP; 16 Mar 2023 02:44:27 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 16 Mar 2023 02:44:26 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 16 Mar 2023 02:44:26 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.177)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 16 Mar 2023 02:44:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VmHOIW4X6YNtaI7j1D3XAFTqn9Vq2DIWCbxLRK34YeQR2H2eYnZmDyyS2BA3L7U1Timc4NqsyVFI1IEwxlLb4IQsaQCoBeEfUVU23xmBlclor4qKRCVbLKfOtEDOgKZEqXc0OadxMq+VrIVDmHdnFLq1pQqQ0cL4FSRZFNPr9Qn5mtYsZcrSsUaJDWcUFDnZiSVz3iBzBjVVvypsDuwNvp5vu6X+fWf0Z4QmRuStZn2aqJ85Rrme8ULb+OrWmtxnKo2vYsmPz8WhoD0IHuLE/XeSQWucvVTf8Nnpvq30iNBvh5WSFhsGP/V0DEVaL18/Vky3UqzTiQg9iBbzbH38Dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vXYZl5v7gxEEpmrRoAh0l8AuEs4xTuRa7mRA9Hzdjaw=;
 b=PkB9B6WMNr8NLi9UffDgqU23rAX0hneetsqbCkj7AkD9cjMjq406mS5ZwfXQPxCwXillOpryx+Q10vtgH66Y14/3nFtlx4S8/YltkxVpXy2w0+il1526TGC51VfzH+lOA5h/+nPjbeViUw9Uyuqnd7joH9ecLzjWw+CrAuISz7KH2kxEhow4nvIQvWfbzv1IL2hkKUyEvoAh6d9FWGQHpUpyLRbATs3HydaLr6v4v6rFXU/AwPI8NshY98+xZ5JbEhmholJvYfhzggZQmr1Wx4/u6MGiWCvrq+Ab8YgkaSsGdykaPxv40NXVIeUpc5140cdqccTMZAv6KxpZaGGb9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DS0PR11MB7409.namprd11.prod.outlook.com (2603:10b6:8:153::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.24; Thu, 16 Mar 2023 09:44:24 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::b00e:ac74:158e:1c7e]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::b00e:ac74:158e:1c7e%4]) with mapi id 15.20.6178.026; Thu, 16 Mar 2023
 09:44:24 +0000
Date:   Thu, 16 Mar 2023 17:19:48 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>, <kvm@vger.kernel.org>,
        <intel-gvt-dev@lists.freedesktop.org>,
        <intel-gfx@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH v2 19/27] KVM: x86/mmu: Move KVM-only page-track
 declarations to internal header
Message-ID: <ZBLfNLb5z2EYdeXy@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230311002258.852397-1-seanjc@google.com>
 <20230311002258.852397-20-seanjc@google.com>
 <ZBGFXrpSXpF5NUlV@yzhao56-desk.sh.intel.com>
 <ZBHgoS/4R35KByOp@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZBHgoS/4R35KByOp@google.com>
X-ClientProxiedBy: SG2PR04CA0172.apcprd04.prod.outlook.com (2603:1096:4::34)
 To DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DS0PR11MB7409:EE_
X-MS-Office365-Filtering-Correlation-Id: f34b43b0-07af-4822-76b3-08db260306b1
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AEfPZixqZyX1f38xlbnqlHlA59PM4KnnHr02KABzE3sSXlJJ9u8OhLqYOhUmVKMWMzAPphJ/+f0HaMKDijDmO/N0xsbBmyqLR1YsXr9T7LimXnxuFs3W4RubCfyKXqfVLDZkLC43kZlV98pzV1QtR3zweDsPDTEIWsuK1v5c1xvUOr0poLxiogErmw5mABcRgcp1aENhgMXjkLZeszTWOBtJnMMC1ZaFSvUHTEeqvnqkY3a9pogMQpQHi4zMOceBGEf+UQadwmN2cd4YSzay+Z6MetCuIUOV89YnZ5DketW36vXXYkEqiRW5by37CRBobljtD5LScQTBIkSWOTF+EzX2x2l7VI/81naZFvJOBdPvo7VvhgfE8ExH/oz5hR0UG5DHCHCg8TqU1QDXRSNh93YF15+3EczA5I/gh8P3oDJtkd2SUxF0YJCG1w43mnA/nOv3Y779n8mN2wDdi6JrpuRgcDx3kdbC8l4edi0oEpoTJgByaoyASdNxHhwz0KL1RptXSa5YCg5Susk6h/DUQYIb3eJBXOFr0GkfkDyTx5N1cCDnjOY6v/jaoc6fAd7lxfN5JgFq6+yNHswlpnvaP2zREXc8lUHZWExPjeVmPqcyYCP4YI6qpOVgGx6pFlfm1jf3Gm16071x46pGc+i2SQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(376002)(136003)(366004)(396003)(39860400002)(451199018)(6486002)(8936002)(5660300002)(41300700001)(3450700001)(2906002)(86362001)(82960400001)(38100700002)(66556008)(8676002)(66946007)(6666004)(66476007)(478600001)(54906003)(6916009)(316002)(6506007)(4326008)(6512007)(83380400001)(186003)(26005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Bv+dBhLc+CV0C7+8sxgcp8gGDDPlezkXu1HYNpGyNRoWh//6DrKDrFvmYl1t?=
 =?us-ascii?Q?LS22Lx49ntY/TS70T+LH3uMJI5YbPu5E4iuHraKfZ2AtCRSsT1x7xbK7bRqr?=
 =?us-ascii?Q?jrrGuiQ8yIHDjjgNgA5aP4QPCZkAgAfNl1/iP/SQkhbYKa/GzoDUHUH7ub7S?=
 =?us-ascii?Q?Qdd0jLh1pn0d4eJW8jM9niX+PFPDYiiicDTijVtz/OS4GkXwiH/mJBzeQTZP?=
 =?us-ascii?Q?VwiQ9s+0h3fTWfhnXqJrBNb1Zlede+KrOPBqulPqubjcjxtcl05xSCa2Z2Id?=
 =?us-ascii?Q?113I+P1asRXYGsIjcBqHUjNMWW0CMpIhgWxaXeUjW/dj9D2oZh+JkLkiKyNA?=
 =?us-ascii?Q?fDiSSxcEDnP0NfHAl35es8ExjCOrhfeOGytlOnwOr63ojjzzz/t5XV6E3zmg?=
 =?us-ascii?Q?1A/i7zdYAY8x/4QEHIdyFRA9X4X2cjTCCQNNW26cMm7tjAN5kV44qOGHFCOZ?=
 =?us-ascii?Q?XQB62cCF/n0B3hJ5hw2GvaMdsyhNktO0pxFmV1S+OPPCcI2k2f8rkfAH3iAB?=
 =?us-ascii?Q?RWQktCRnAjEkNAwWYVDyo/jDWIoc4wYySiNl3q7Q1zzuBNX5/iYvfJpSuW8t?=
 =?us-ascii?Q?TdRHIPIvRjdBpUTa+gGHkX8oVH6ZAU6y6SLkJ15ZEM0A1xh1ooO8dIrSJdA0?=
 =?us-ascii?Q?HP9I7oE35b+b2q22//NJdMBDwYT+GKgN+zGuNeWUVXY1LNtD9Q68VKm+7JCi?=
 =?us-ascii?Q?Hhk1FO/DXyFHBUJafp10kJ8NBbaEdLXDI1oKa8E/Ho/wOSATR2fyucJ9baAF?=
 =?us-ascii?Q?3Gqy55g7HWQDt9Gm2pUXt5zBGt2FOn41n4i3FTQLg8NQ+/jKj5Pw4wZjLoDD?=
 =?us-ascii?Q?gPHmcjRF7lsmb3A6lJYd3hHBPRu5NENhp/WaqKL9XG3OTCbswO0phdB6KlIc?=
 =?us-ascii?Q?YYZ1IfDClM2KkNFffd3GE6x8RF07Yzm0/wXlC+wD2wkiKQVNRtuL8D8XqPBs?=
 =?us-ascii?Q?hWjI2AgnN/q5eII7jYCOyUvmz+WwKR96cE8eIItUQ9BtxANm71zs8y0Eoc++?=
 =?us-ascii?Q?qd+PH5Vy2ltpqxFG7VBEhRbC93A9AaE1aIlXJYG42IWwY4++0CR1iYq3BzUg?=
 =?us-ascii?Q?31YUFQiLKOD/eJmPuAtMh0vOu6+bmoj6EvNgiYGxlN8OCvzq9bzSoWfj7WHc?=
 =?us-ascii?Q?esax6v28Do5gWLnVZfqQiyzUCnN4szNUm9ZXazPomBuCjnQqChepALeb/2uP?=
 =?us-ascii?Q?h2UPCkyrHU6dcE+093mfQVSvGmPe5uvo1yj5k8L3eVHsAqCE6zA0Hr8yQJ6u?=
 =?us-ascii?Q?mm+YTO18yz3oo4owgnTF0grXQ5ho0EtsMshZNNS6Ab0wJZ/va67aCJgY5pvZ?=
 =?us-ascii?Q?dtll5cvZjZm1MtVeTyE8mc5GlAHt7S3jDJ5G79Y6cP5BJaea/sHcw1dvCdvZ?=
 =?us-ascii?Q?oj8CrKk2d06QBmcu9bX4E7It7TxiIsWdaCj8tzMGCMR64hCuQIIbazMRB2k/?=
 =?us-ascii?Q?IaCUd5meyorFE1IGipFqXvl+pyZ72Zp3jnP4BeyR1/gPGLJPOjv1KRsfw5WB?=
 =?us-ascii?Q?98ZllvVEpgIp951XhJyz1zWFvrrTkTl6GYGpp/oe3PsnYDngtSQ4c0vwsIGw?=
 =?us-ascii?Q?aHOO4otWzyZLmYM1LGoYb/7P1wi9lGH8GHcu5kSnUObxcJQajiRvKDLC9koP?=
 =?us-ascii?Q?Hw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f34b43b0-07af-4822-76b3-08db260306b1
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2023 09:44:24.4451
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sbPxdlyIpmydFPjueEJPoWxA20UYRcE7hLbDTosvvIrniH247ABcmT5PhFO/bnNgVzTjnoMH/anyWgIQn+OGdQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7409
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 15, 2023 at 08:13:37AM -0700, Sean Christopherson wrote:
> > A curious question:
> > are arch/x86/include/asm/kvm_*.h all expected to be external accessible?
> 
> Depends on what you mean by "expected".  Currently, yes, everything in there is
> globally visible.  But the vast majority of structs, defines, functions, etc. aren't
> intended for external non-KVM consumption, things ended up being globally visible
> largely through carelessness and/or a lack of a forcing function.
> 
> E.g. there is absolutely no reason anything outside of KVM should need
> arch/x86/include/asm/kvm-x86-ops.h, but it landed in asm/ because, at the time it
> was added, nothing would be harmed by making kvm-x86-ops.h "public" and we didn't
> scrutinize the patches well enough.
> 
> My primary motivation for this series is to (eventually) get to a state where only
> select symbols/defines/etc. are exposed by KVM to the outside world, and everything
> else is internal only.  The end goal of tightly restricting KVM's global API is to
> allow concurrently loading multiple instances of kvm.ko so that userspace can
> upgrade/rollback KVM without needed to move VMs off the host, i.e. by performing
> intrahost migration between differenate instances of KVM on the same host.  To do
> that safely, anything that is visible outside of KVM needs to be compatible across
> different instances of KVM, e.g. if kvm_vcpu is "public" then a KVM upgrade/rollback
> wouldn't be able to touch "struct kvm_vcpu" in any way.  We'll definitely want to be
> able to modify things like the vCPU structures, thus the push to restrict the API.
> 
> But even if we never realize that end goal, IMO drastically reducing KVM's "public"
> API surface is worthy goal in and of itself.
Got it. Thanks for explanation!
