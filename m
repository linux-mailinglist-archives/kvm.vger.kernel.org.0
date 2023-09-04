Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8DEC791027
	for <lists+kvm@lfdr.de>; Mon,  4 Sep 2023 04:46:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350934AbjIDCq6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 3 Sep 2023 22:46:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243186AbjIDCq5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 3 Sep 2023 22:46:57 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 099F3B7
        for <kvm@vger.kernel.org>; Sun,  3 Sep 2023 19:46:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1693795614; x=1725331614;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=lJ/E6AdUofMsdZrTwgc32ACjyVvbYmewOHUSHx+YLhU=;
  b=WIOm5LSUAoVHR39N9dFepCbT+cjeY7j9gxzMJ4bohFF2bEC1CVQfIUND
   ko2Eai8cnTVv8FoFkHgAxfzOOLigyq2Th66fO6tyxuLSNhGhCwMKffHGk
   ihVwcSuonhs6cwfib0ZNPVyK4YgOpFLr7eOvgu/lFLgppw14vSpvBj+oX
   G+yhZNmzU6vT9dJMhYZcTqMWYT9W4kJnIXeQoJUZyvMxPFhdU1hnYqmLc
   gK/Av43gfNxvdIiv39OWEqzgAA8HIH3PrBJjEsQb2nEoXfveDsgD9IZ/i
   QNLd0j9vZplOXIh0y2I505w8mEde1HqpYBu27bBTzOnaBW5XB2q6QBjzL
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10822"; a="442899533"
X-IronPort-AV: E=Sophos;i="6.02,225,1688454000"; 
   d="scan'208";a="442899533"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2023 19:46:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10822"; a="690431251"
X-IronPort-AV: E=Sophos;i="6.02,225,1688454000"; 
   d="scan'208";a="690431251"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 03 Sep 2023 19:46:52 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Sun, 3 Sep 2023 19:46:51 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Sun, 3 Sep 2023 19:46:51 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Sun, 3 Sep 2023 19:46:51 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.109)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Sun, 3 Sep 2023 19:46:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lcRQGHMWbtD89mKr+EWuC5QlEXLrfP0uPDNtYBle/mmvmolsyiFeCmpJGlDin9rbJpbjcahz3C7RPlejL57p0NlAoi7usFQwc+dDLFmJ++0SMsCYpbZp4TEdXveA8LnJhRZkTrYz0s2NgeluH37GR7y1xVJQJ3GUclutOOXHyZkG1dR3kz09LBc/bCVPo9+tQ/Ok3lbteIfuPqZW2uHc4/DFb/AP1r1Yv79QiO+IpTxFEJM1fhERnJN0mG8TX7lIVoHFSMzUEG1cUutjfCzusfyNsRQKHbcDOEuI7N65So2K7cBGCSfDeLMQEY98sBw3dW+U486iUKEkRdRr7577hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fS1eN3iiMBg77KlfgBJ1Ca3vnGSFKskbDx3DZBO31wY=;
 b=U72yi2pwDpaQslXP9kA/ER0J5magLslHQ7E+H46bs+5gfMoZJFLo1KoV+3K3PeypQ0jygCW3uwroTPJ9M3cQTp2Vi12NS31snz0h7YTdYLGPbUOc1PeEvhDord4TwUh34z3OxcOuKnTXufD2v65DL4Zt3kqoYUTW2FGPZ3ctzlBvZ4E3RInnKwL+UWmm8t/fv9yA3Cup2KVVYq9s9nvyZWoJNOmfjNRl6IAgWrJQjn3fJYv5bNIH6/7OXQNDLU4S5SHBraNNLI9YodyMJMquLKEVE14JIUIFh5rCZH569UHuq7znAH8UBUdW5h4XteGNGs5uqXe0jEaO0qk7bIu7ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by CY5PR11MB6461.namprd11.prod.outlook.com (2603:10b6:930:33::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.26; Mon, 4 Sep
 2023 02:46:49 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::146e:30d4:7f1e:7f4b]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::146e:30d4:7f1e:7f4b%3]) with mapi id 15.20.6745.030; Mon, 4 Sep 2023
 02:46:49 +0000
Date:   Mon, 4 Sep 2023 10:46:38 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Tao Su <tao1.su@linux.intel.com>
CC:     <kvm@vger.kernel.org>, <seanjc@google.com>, <pbonzini@redhat.com>,
        <guang.zeng@intel.com>, <yi1.lai@intel.com>
Subject: Re: [PATCH 2/2] KVM: x86: Clear X2APIC_ICR_UNUSED_12 after
 APIC-write VM-exit
Message-ID: <ZPVFDiB+HojAxuIz@chao-email>
References: <20230904013555.725413-1-tao1.su@linux.intel.com>
 <20230904013555.725413-3-tao1.su@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230904013555.725413-3-tao1.su@linux.intel.com>
X-ClientProxiedBy: SI2PR04CA0010.apcprd04.prod.outlook.com
 (2603:1096:4:197::11) To PH8PR11MB6780.namprd11.prod.outlook.com
 (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|CY5PR11MB6461:EE_
X-MS-Office365-Filtering-Correlation-Id: cf7d6b12-247b-4a17-eaaf-08dbacf12fc0
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CxquiPvuWy+aG5rUNYmgRZJnzgexidUhDcrnOSCthBrGeRXSEyY7eMbqXJHx5GKilLqcaT0cCMrUVUN/q846nmzonMVHhwUp8gNAwQ+kA5sh/oHhLzK6gbuQfKA54Jicb1TardFUNH820eZxqhDnxieMEjNWCg7CFAgmXUTB4Cku0S4h+H7yNJvEMKwQuY9GZue0Ixai8NOBj26ZQSt5LQ/nxNQUEnWq7kvhjnxnwBpRyJZnq/XdY26bmbIDYW0CyclbiIBf0Mh0QF+Ll08YEhtM655gjL4HHbPpYZY64NQOa1pN2aBJ8vTAz5DjoNpOCc7Wc1xFM3qM31rwwbr+KQBRVjhQ7oj0N6l0SReniBd2ibopVL5gcLvEt5IUPWloajOvsTXhqAwcuOcLAQ2dKBY03uHYMHZfTwStZeKRLiGZBAdByGWf/0fgsJDUv0b5pJ17G+Wt5vqAHIQk28XHElG9iNmKOmGip4Rb5acOaGbTQgzIWU7oyqrYxo7VYV4cC0JRHgfjilgIUrCoYeXE4rt2q4+zZw+6jz8K+nCXLVmG3lO32O4hYdLieGfvo+5PFRosbOuclJ1O+bR+Tw1qHg2zHpufoLBBoiyXX4gS/ac=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7916004)(396003)(376002)(346002)(366004)(39860400002)(136003)(186009)(1800799009)(451199024)(41300700001)(83380400001)(316002)(33716001)(2906002)(82960400001)(26005)(38100700002)(5660300002)(4326008)(8676002)(6916009)(8936002)(44832011)(6512007)(478600001)(6666004)(9686003)(86362001)(6506007)(6486002)(66556008)(66476007)(66946007)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6xHc08ipYeu5gK8lTZ9lEpx7KVlGE7e1cEFB2IJhqG/drXMYKt5ssXZHUD54?=
 =?us-ascii?Q?D6Hp8O5nFkAQr5JnXK6fN6vT3PTl+wIs7zzuDphdeOz2t22Rp0rGNaoSVibQ?=
 =?us-ascii?Q?hURrQiRRu288YAyWhPAGPCGZqFNH+xVNHSmCKyeQC8Qzll1DgT6o/OC7Boek?=
 =?us-ascii?Q?++2d5YqE7HYQ26srqZWQyVAFzXR+uUK9vUjU6aJgip7b8CDEDyojKm8K/lPj?=
 =?us-ascii?Q?8kaJRS030TuLcFVYt1Dx2G+y85b4f19Mo5ICUkZiBlqeQZSibdY6b6nqLdEF?=
 =?us-ascii?Q?xkiUuwZvzWX6qgssjn9+Ggnfy7pWo25PQ8or41oWS81VHQ46TVoQICRrwJjS?=
 =?us-ascii?Q?JzCubSKfRM5NT46N3LeAzmK7ObIy/cpPNeedXAZ422M4psKnVFwa60bIpzRb?=
 =?us-ascii?Q?w+VlB06QdyG2QDgaoXPXCAdpy7O0/geFDbWcc1n70QltrH9oX0CDzYz8XPuC?=
 =?us-ascii?Q?qOe/3kdG5twMSDSb4+/F4/Q2mkRCTGOybjBYyC2hfr9qf7nS3pCEsrYHCVqH?=
 =?us-ascii?Q?YyWC/B1JiWPtfFACk3NCzDKgQIa7NaEUTiir3Yxnil69sxdbb34rE0pxeTI0?=
 =?us-ascii?Q?cMssf1F2zxgW1nLOMkalykn1R7Un6rJ05Z01MaPfU8QvhufIAPxF0dPIWrab?=
 =?us-ascii?Q?O81qFojKC+2eniz6H5YOAzN5eNGCBICK8C7hgttIpTVpB0qKCx8GSG+JVgYW?=
 =?us-ascii?Q?sM+NvQ/q2yrgZT69LYaX7bLoVWwzDSnC5hP7G8D0FOmnBaGSYjrD/MuBe1VC?=
 =?us-ascii?Q?RPHp3J87oUYCIYRquWy3bqJYnsAMFu2leBnZxF4tVMlwdW8hkszRxZs4O5Kf?=
 =?us-ascii?Q?XFYV5R4XMba3SOW2fXBWN4Zy1R4serQJ9shotG46Pb5fVaejKGiy2g1Qtm7l?=
 =?us-ascii?Q?YHYpjtIsZmtbktm7un4uLhg7v7NZfunaHb3ByAYT0GPmkXPzz+MOkuZInOS9?=
 =?us-ascii?Q?usmXF+PtpvvuMqf1LP3g37fgdPC2AFrt+RcokyNKbdHSO4Gy8fEKWaGkCMCb?=
 =?us-ascii?Q?q4A178dUUGisRJ97cqE0RHjvLJTnWHpbiyNheC599BECxVz7E3qGLzfFovsM?=
 =?us-ascii?Q?OGL2vuxJN3Q2VEBjAk5Z3DJVMb+MjFCm9y+JRzMxnoTbqu6dZ8YkOzapnn2U?=
 =?us-ascii?Q?664es8ZzSX4wifONKr2u2WarYa5d4oCuwuBYTBtjvF1V1JK6NwBFlocOVRLm?=
 =?us-ascii?Q?UcSRWPLRu/xo9UKepsZUDc7NAN8UFra5XyOALUabNyyjLyosxbPp9bqxRW3i?=
 =?us-ascii?Q?jTSAL+6YcQNuAUQzhLy+8S5yotUcN4/6611PUKAxme4IWXbZTq0ZZPeURiSe?=
 =?us-ascii?Q?/8b33r1Sgn9vHky7yeJaqOMEU1zfhkF0idDiT6S25NV1u+wOs6MKwAAg+bRT?=
 =?us-ascii?Q?zGTx7E4hQJunC4AbfmuIr1zwhySCYcr9tcQ58Jbto5HC8FahaJ8kdkRAaTqA?=
 =?us-ascii?Q?tksTGBT9L4tt978A8FGXZLxMPYrYPh7jei582P7bMA60/cv0XQJ6kLkAsmxl?=
 =?us-ascii?Q?pMwFcKxMpic92+jiWR71eyDPb02s6e3LYdVVjp9zPEXc0BZo0VUbhZv1rna4?=
 =?us-ascii?Q?h7vbtFbMiwK6Vr+BYZyDVa5QAFDeiDkizRmdGOGf?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cf7d6b12-247b-4a17-eaaf-08dbacf12fc0
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2023 02:46:49.2612
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZMPbTI6DjcYhikudVGrhZhL+kJfduT3HfoD6nDsIQQlJbBZYJiUrVy/53mSjrRS3W6QRFXgHHffRbRNBQegXYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6461
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 04, 2023 at 09:35:55AM +0800, Tao Su wrote:
>When IPI virtualization is enabled, a WARN is triggered if bit12 of ICR
>MSR is set after APIC-write VM-exit. The reason is kvm_apic_send_ipi()
>thinks the APIC_ICR_BUSY bit should be cleared because KVM has no delay,
>but kvm_apic_write_nodecode() doesn't clear the APIC_ICR_BUSY bit.
>
>Since bit12 of ICR is no longer BUSY bit but UNUSED bit in x2APIC mode,
>and SDM has no detail about how hardware will handle the UNUSED bit12
>set, we tested on Intel CPU (SRF/GNR) with IPI virtualization and found
>the UNUSED bit12 was also cleared by hardware without #GP. Therefore,
>the clearing of bit12 should be still kept being consistent with the
>hardware behavior.
>
>Fixes: 5413bcba7ed5 ("KVM: x86: Add support for vICR APIC-write VM-Exits in x2APIC mode")
>Signed-off-by: Tao Su <tao1.su@linux.intel.com>
>Tested-by: Yi Lai <yi1.lai@intel.com>
>---
> arch/x86/kvm/lapic.c | 27 ++++++++++++++++++++-------
> 1 file changed, 20 insertions(+), 7 deletions(-)
>
>diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
>index a983a16163b1..09a376aeb4a0 100644
>--- a/arch/x86/kvm/lapic.c
>+++ b/arch/x86/kvm/lapic.c
>@@ -1482,8 +1482,17 @@ void kvm_apic_send_ipi(struct kvm_lapic *apic, u32 icr_low, u32 icr_high)
> {
> 	struct kvm_lapic_irq irq;
> 
>-	/* KVM has no delay and should always clear the BUSY/PENDING flag. */
>-	WARN_ON_ONCE(icr_low & APIC_ICR_BUSY);
>+	/*
>+	 * In non-x2apic mode, KVM has no delay and should always clear the
>+	 * BUSY/PENDING flag. In x2apic mode, KVM should clear the unused bit12
>+	 * of ICR since hardware will also clear this bit. Although
>+	 * APIC_ICR_BUSY and X2APIC_ICR_UNUSED_12 are same, they mean different
>+	 * things in different modes.
>+	 */
>+	if (!apic_x2apic_mode(apic))
>+		WARN_ON_ONCE(icr_low & APIC_ICR_BUSY);
>+	else
>+		WARN_ON_ONCE(icr_low & X2APIC_ICR_UNUSED_12);


Hi Tao,

Using the alias for APIC_ICR_BUSY is not strictly necessary for the bug fix.
I think it is better to move this hunk into patch 1.

> 
> 	irq.vector = icr_low & APIC_VECTOR_MASK;
> 	irq.delivery_mode = icr_low & APIC_MODE_MASK;
>@@ -2429,13 +2438,12 @@ void kvm_apic_write_nodecode(struct kvm_vcpu *vcpu, u32 offset)
> 	 * ICR is a single 64-bit register when x2APIC is enabled.  For legacy
> 	 * xAPIC, ICR writes need to go down the common (slightly slower) path
> 	 * to get the upper half from ICR2.
>+	 *
>+	 * TODO: optimize to just emulate side effect w/o one more write
> 	 */
> 	if (apic_x2apic_mode(apic) && offset == APIC_ICR) {
>-		val = kvm_lapic_get_reg64(apic, APIC_ICR);
>-		kvm_apic_send_ipi(apic, (u32)val, (u32)(val >> 32));
>-		trace_kvm_apic_write(APIC_ICR, val);
>+		kvm_x2apic_icr_write(apic, val);
> 	} else {
>-		/* TODO: optimize to just emulate side effect w/o one more write */
> 		val = kvm_lapic_get_reg(apic, offset);
> 		kvm_lapic_reg_write(apic, offset, (u32)val);
> 	}
>@@ -3122,7 +3130,12 @@ int kvm_lapic_set_vapic_addr(struct kvm_vcpu *vcpu, gpa_t vapic_addr)
> 
> int kvm_x2apic_icr_write(struct kvm_lapic *apic, u64 data)
> {
>-	data &= ~APIC_ICR_BUSY;
>+	/*
>+	 * The Delivery Status Bit(bit 12) is removed in x2apic mode, but this
>+	 * bit is also cleared by hardware, so keep consistent with hardware
>+	 * behavior to clear this bit.
>+	 */
>+	data &= ~X2APIC_ICR_UNUSED_12;

Ditto.

and can you also swap patch 1 with patch 2? Because patch 1 is an optional
improvement, putting such a patch at the end of a patch set gives
maintainers an easy choice about whether they want it or not.

> 
> 	kvm_apic_send_ipi(apic, (u32)data, (u32)(data >> 32));
> 	kvm_lapic_set_reg64(apic, APIC_ICR, data);
>-- 
>2.34.1
>
