Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C50F79857F
	for <lists+kvm@lfdr.de>; Fri,  8 Sep 2023 12:12:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231311AbjIHKMb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Sep 2023 06:12:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbjIHKM3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Sep 2023 06:12:29 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93AFD1BCD
        for <kvm@vger.kernel.org>; Fri,  8 Sep 2023 03:12:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694167945; x=1725703945;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=NtVGZdjuF0o2b+GeyEQpaicGVcirlSi4/c95WtlFUcw=;
  b=cMUpoLtq2J1Po7qnBk6ouF/WRXKLhBc0QlX8KaSUNZMLRxBSduSXQWS/
   YoZx2++S9rKuAS6xwwRETH4Daf48vXR/FGPhGFryxWBq+R2gDRXcOJWmn
   TH7ACnfVwbd37O+HYPCAo6qng9icijtwdGOwmfNfDUse40CCPC+P1xOZg
   9zsG5io/31pLtHy+K4FsgZZXuidxipZ9DSD+YIJktv3Fflaxx/rlVdbMm
   pyCNnuVwU4/DDKm+v+NwTy+V06OHy2TWGCWqsHfsr1uJQTu0FqYWssB2m
   cGoXtDlKG4lsWLIMbMVYLn9yngqGaxh9J1U5ObhT1hw8LEh1Sq38DLZCr
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10826"; a="357075583"
X-IronPort-AV: E=Sophos;i="6.02,236,1688454000"; 
   d="scan'208";a="357075583"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2023 03:12:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10826"; a="735913120"
X-IronPort-AV: E=Sophos;i="6.02,236,1688454000"; 
   d="scan'208";a="735913120"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 08 Sep 2023 03:12:24 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Fri, 8 Sep 2023 03:12:24 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Fri, 8 Sep 2023 03:12:24 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Fri, 8 Sep 2023 03:12:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jxtDbnp0eR84QrGnmSKzytTlzBAn4jv15AWAuDLNlJhH4IyA6nwajqq08OBu74fYy6skYjo2dAZcrDY2kSCuQNBHMVnTvxHWNuV6ZNAOi2sFyQt5V9v52tqBhKbzCtOfhg5cfrgNLW26y/WLXIua9khLFuOGRyY4lPmiMF3XqukTAgmF4OBsYhfuwEr5p3ShzTfEf9JfpcQ7b019G5Dru4D48A0KacUxGMuUcv73w7HtyTkT4Nj02i8a7NyktorLCmB5O0iko40j/Yyp6Refza9k0FPnWxWa46X5H3KLSdk1AVxxf9FazceNE/Iq98Q5AiwAYGbVQGvQ48OgFGOGfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0M2F9rY9DevFQ1iNh+/a1tbS/zirzYKCha2HRKfbxAs=;
 b=L9LDkiUlf09f8tEv33eAl1JkRBONeqq7RoHtlOgxm078Y2sZ5tnrD80PtcCjcV4O1Wzw7CROb6DUHHsjVWQz0jLV9MU+jFkY+vLg8h3NilZZCcaKAlf+hy81rheoLxUrTw5NPajpU8Kh2fda/u7trnJUSR9sufLPgzCtMl4Mzn14jhQrGwBm/jvuSio758/kQwnGXvXwYm2C7p44AGCqULF8nYp0oDtTUbVydd0zAQ3cABY5R4AHNVf8zZnRkLJZa/PXq69sMsf3b8k/uWOj6eWdTYN3zHlBcntrLOOPZYLpGT0fSWr7ctegdfEkiMst8b2JMOQDysTsIpw3Zs3oYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by SJ1PR11MB6300.namprd11.prod.outlook.com (2603:10b6:a03:455::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.33; Fri, 8 Sep
 2023 10:12:22 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::5d9f:7e54:4218:159f]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::5d9f:7e54:4218:159f%6]) with mapi id 15.20.6745.035; Fri, 8 Sep 2023
 10:12:21 +0000
Date:   Fri, 8 Sep 2023 18:12:12 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Tao Su <tao1.su@linux.intel.com>
CC:     <kvm@vger.kernel.org>, <seanjc@google.com>, <pbonzini@redhat.com>,
        <guang.zeng@intel.com>, <yi1.lai@intel.com>
Subject: Re: [PATCH v2] KVM: x86: Clear bit12 of ICR after APIC-write VM-exit
Message-ID: <ZPrzfPkpLc9nSEZP@chao-email>
References: <20230908041115.987682-1-tao1.su@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230908041115.987682-1-tao1.su@linux.intel.com>
X-ClientProxiedBy: SG2PR06CA0230.apcprd06.prod.outlook.com
 (2603:1096:4:ac::14) To PH8PR11MB6780.namprd11.prod.outlook.com
 (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|SJ1PR11MB6300:EE_
X-MS-Office365-Filtering-Correlation-Id: a78695ac-562a-45f2-4efe-08dbb0541708
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: J006ZoXZf2ABzEWCGrDdr5GCAcYfW1GBPM7n+Qj+Ry8JIWTr4CzpM3gCLsAL8H6f+FLPV2iIkK4lhIUXqwjrMBrd3SZMUA9mP51ZGFdabYiNFL/REf4566F34JqGfyp1T3e4WlSZFZv3+dVRwFsnXDhoqAn7GfaCinf3eTIHadf5tnm2bfoBZAN4QVy3u3ltVDjwgUndp5/frYoQGt9zfbaEAUWxtyZahE0BfH6/6hbL1CwiiM5zeChuzu/EyxNDluQ2rbIEjCpyS5RuggKCtG19gty5BSv4Pf/T6CoRns3oJCf2PsmQARDzX5DLIQ276zaYetx+ZrcibqxxBsavXNjRo2bfmlIKeUOQti6aMWeITJXxEuGNosJWYZKlNa1TBPeZY4jcXgCW9p/BVoluzdf5fWh5WY7e3tTTQvE9B2MGgEyjF1Mn9nXjhAW2752kSrwhZIUz2ljnsAM7yta1E1h5RHK3ZKxwNNEpDyx7kTUbBjXpO3k8jrjZ+r6vqYLWZBx7QMcu+khNzoJh72v/8l3By2yb78sF6SY2ASdMcHIw4SuqhjlQM4HEQj+7+qhb2WfYbebsQEE7aWWcHW7nBw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7916004)(39860400002)(396003)(346002)(366004)(376002)(136003)(451199024)(1800799009)(186009)(478600001)(82960400001)(6666004)(6486002)(33716001)(44832011)(9686003)(6512007)(5660300002)(6506007)(8676002)(4326008)(2906002)(966005)(38100700002)(8936002)(66556008)(41300700001)(66946007)(83380400001)(6916009)(316002)(26005)(66476007)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?D9i7b4auyq4evny0/LH1oPiGliZDItJ8hErF33vtDYiRite/Otlb6TGkcgJf?=
 =?us-ascii?Q?K1nZVgfYkBJ3+6R7pKB/pS5obH5XHIm14KJLaB7dZn0DrXRd5UuBioL8Jc1G?=
 =?us-ascii?Q?gAPc2/xLrmwWIK76gzZ0+BIZZHzxQz59Vs22EsQNLa1tcLEp/qNmixVhjj+J?=
 =?us-ascii?Q?GWyK7qat2zZgH6Hp9UIJGFYsWLy35S1cuhF375+koaEa7hU1t5WQt0hCPMs9?=
 =?us-ascii?Q?eorgF5lwtZiXpq1gHxjzJL6RErSmavGuYZXocnIkmtZdgI9EKp6KGMZ16QUd?=
 =?us-ascii?Q?6MHeoC9W5pqilnlksTToXDH2RZR3+sbC/h6zYYvEXt1D0s/lzBLYx5yEzzy2?=
 =?us-ascii?Q?zSlLFmxPA8qnwtvugn2G9bOtVRNXjr61inSJvlTrZvTaMGZ7SnWqoqv8hpP+?=
 =?us-ascii?Q?5Qt1oN5p7Jp001PVujFTg2Y9sS0JikGnpGeKOC5IGWlQsWv9Y2ZoH30KlY4u?=
 =?us-ascii?Q?HenYsBSbn4VDFSo0u6qTjpFixN8wDJSIjSowOFdHjuJMTsO0SCBVeTvwvTC8?=
 =?us-ascii?Q?BNHlM+iG6sIHyXEc0fiPReNto1S39Fz8kJEYkYZcO2+sqlvvcCWkSSJpt27E?=
 =?us-ascii?Q?/dqTmb9ULKzZc+OOwvVONQ7kBPd4oLJy+M1eDciRHuN/ZG647JaroTsefUXz?=
 =?us-ascii?Q?RibyFN/wpw7sgrZNNzX6JwlhqQ+mwZAuKu5RLf3xYSL7RbvhlfEyiMCaxUXV?=
 =?us-ascii?Q?a2wC0gaCATbSuSq2QkVtKWNr3yG4PWcHV8UpLj0xEzqBIY82xBB8ihb/LxZf?=
 =?us-ascii?Q?9SRFg8C19GFNFHDex2FCCuYbqa+uqx92ol71X/JXEDLSaMCnNM3t9w1Zd3Ga?=
 =?us-ascii?Q?I5LQ6UUJ7LxiWUgjXpF06+6JQZrvJxZw67HS9eGOkpIEz56fC6eoGNLdW72y?=
 =?us-ascii?Q?pfdF9bk6tpH6Mye8nhNFkrb//ubSiRTpA/BzcjKaY+xQ0EKum6hrns7z1WMs?=
 =?us-ascii?Q?qtIjYc0DZ//vJdcN703N8BEpNoVcZRHV0euGl5hbECUJPuH1lGtk8oNbLDHU?=
 =?us-ascii?Q?424lJvxsXvABUtG0YsG/gs5cln1/KHFQXnWgw7TQwEJhji5Y2iG3t2WvcRKO?=
 =?us-ascii?Q?xDKJvXXh1p57WOXnNPoLAi/nS82IZRjlgN3swU4tJj8+LvHIS4t8hL5Qq/B+?=
 =?us-ascii?Q?ZamftqTJthVCI0QyPE5l/Qk4XF8HzaHTKDwfM8ltrQWYlqEx1m3Jt6PFZak8?=
 =?us-ascii?Q?TEQHK3Clt8PIjU1/yxqS6CDPPH/jD3rUG/BYKrV4OgIAF3elSzKbkCZkH73E?=
 =?us-ascii?Q?Ew8Ooi4rr/OrLg2zVtwItDlYsKFDHckM1YPJOHK+rNvaZg2eXjFbHu/5ek6f?=
 =?us-ascii?Q?nQ8zMMR+L1l1N5CN3wgINMigXIGN7wdxww6WNJyQ+LHyOyPr/wtFgLaB9QOJ?=
 =?us-ascii?Q?n8hqwxzdHQ3jzGGWrWqshU42eHV74TT03onLdcz0VhBzsXA7CXzEPBDNXnfH?=
 =?us-ascii?Q?6KjBhSsqFamVWLzMW8RKqtbY0ZsyRKHN9SSA4/3kmystbhXo9sSCS7PYZnf4?=
 =?us-ascii?Q?m1oHN4EUQPTEBTJpyP2hlSqp7BJE8XSDvUeB1qzxGCZd3Uul/sJsEbOlR01J?=
 =?us-ascii?Q?enNuU14icv695b9USPO0ygxDJ0tjk1fdllaxn8k4?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a78695ac-562a-45f2-4efe-08dbb0541708
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2023 10:12:21.5443
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: icDApB+pzqL98ATKbB0NoJTjURI7AeceSrE7jfBn9AaCiD/wJaTLJ3BfrPOK6nsrMMlZRw0ddvJySdsyZUmBdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR11MB6300
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 08, 2023 at 12:11:15PM +0800, Tao Su wrote:
>When IPI virtualization is enabled, a WARN is triggered if bit12 of ICR
>MSR is set after APIC-write VM-exit. The reason is kvm_apic_send_ipi()
>thinks the APIC_ICR_BUSY bit should be cleared because KVM has no delay,
>but kvm_apic_write_nodecode() doesn't clear the APIC_ICR_BUSY bit.
>
>Bit12 of ICR is different from other reserved bits(31:20, 17:16 and 13).
>When bit12 is set, it will cause APIC-wirte VM-exit but not #GP. For

s/wirte/write

>reading bit12 back as '0' which is a safer approach, clearing bit12 in
>x2APIC mode is needed.

how about quoting what Sean said:
(w/ a slight change to the last sentence)

Under the x2APIC section, regarding ICR, the SDM says:

  It remains readable only to aid in debugging; however, software should not
  assume the value returned by reading the ICR is the last written value.

I.e. KVM basically has free reign to do whatever it wants, so long as it doesn't
confuse userspace or break KVM's ABI.

Clear bit12 so that it reads back as '0'. This approach is safer than "do
nothing" and is consistent with the case where IPI virtualization is
disabled or not supported, i.e.,

	handle_fastpath_set_x2apic_icr_irqoff() -> kvm_x2apic_icr_write()

>
>Although bit12 of ICR is no longer APIC_ICR_BUSY in x2APIC, keeping it
>is far easier to understand what's going on, especially given that it
>may be repurposed for something new.

Probably you can remove this paragraph. it is not clear w/o the context
that there was an attempt to rename APIC_ICR_BUSY for x2apic while fixing
the issue.

>
>Link: https://lore.kernel.org/all/ZPj6iF0Q7iynn62p@google.com/
>Fixes: 5413bcba7ed5 ("KVM: x86: Add support for vICR APIC-write VM-Exits in x2APIC mode")
>Signed-off-by: Tao Su <tao1.su@linux.intel.com>
>Tested-by: Yi Lai <yi1.lai@intel.com>

Apart from above nits on the changelog, this patch looks good to me.

Reviewed-by: Chao Gao <chao.gao@intel.com>

>---
>Changelog:
>
>v2:
>  - Drop the unnecessary alias for bit12 of ICR.
>  - Add back kvm_lapic_get_reg64() that was removed by mistake.
>  - Modify the commit message to make it clearer.
>
>v1: https://lore.kernel.org/all/20230904013555.725413-1-tao1.su@linux.intel.com/
>---
> arch/x86/kvm/lapic.c | 6 +++---
> 1 file changed, 3 insertions(+), 3 deletions(-)
>
>diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
>index dcd60b39e794..664d5a78b46a 100644
>--- a/arch/x86/kvm/lapic.c
>+++ b/arch/x86/kvm/lapic.c
>@@ -2450,13 +2450,13 @@ void kvm_apic_write_nodecode(struct kvm_vcpu *vcpu, u32 offset)
> 	 * ICR is a single 64-bit register when x2APIC is enabled.  For legacy
> 	 * xAPIC, ICR writes need to go down the common (slightly slower) path
> 	 * to get the upper half from ICR2.
>+	 *
>+	 * TODO: optimize to just emulate side effect w/o one more write
> 	 */
> 	if (apic_x2apic_mode(apic) && offset == APIC_ICR) {
> 		val = kvm_lapic_get_reg64(apic, APIC_ICR);
>-		kvm_apic_send_ipi(apic, (u32)val, (u32)(val >> 32));
>-		trace_kvm_apic_write(APIC_ICR, val);
>+		kvm_x2apic_icr_write(apic, val);
> 	} else {
>-		/* TODO: optimize to just emulate side effect w/o one more write */
> 		val = kvm_lapic_get_reg(apic, offset);
> 		kvm_lapic_reg_write(apic, offset, (u32)val);
> 	}
>
>base-commit: a48fa7efaf1161c1c898931fe4c7f0070964233a
>-- 
>2.34.1
>
