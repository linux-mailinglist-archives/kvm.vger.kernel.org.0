Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 319876FEBC5
	for <lists+kvm@lfdr.de>; Thu, 11 May 2023 08:28:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236538AbjEKG2p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 May 2023 02:28:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236017AbjEKG2m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 May 2023 02:28:42 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10CC110F;
        Wed, 10 May 2023 23:28:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683786521; x=1715322521;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=UUof1FgrYKlQggSayzOz1CU9VhkVOc9i/Jln7rRT0zo=;
  b=Cxrp07JJV2xuwsSgkAGk4TUCLIh2n7Do1yMM0QLq//YK0uLx7vtpe3Ct
   xm8x9aaQuPzrzLk+P4gc2LzgMjLit2+rC13uCKG8nsPcsSAXyBnmmPynC
   3b0lubYeX1QZanyMyjwQ3bdWUqLG5V9PgWpp7NzRVm/D33C3wGYv+F2A6
   +lr3Ryj65ucKPyTLgwzIO9GoncTWwItDdTJqLOW3OvQEHuXMlyyK8QfYP
   vlXKlpwYuwGmzclZRgC8Awr6IqO+cppA1q+44Cdzg02rDR1Wrterl43ol
   06/HyMcVEeRIJwbLGI0NMCS7f3TSVJLu8bOoRfkAeO60x3OukL7/7me71
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10706"; a="347878642"
X-IronPort-AV: E=Sophos;i="5.99,266,1677571200"; 
   d="scan'208";a="347878642"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2023 23:28:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10706"; a="702607282"
X-IronPort-AV: E=Sophos;i="5.99,266,1677571200"; 
   d="scan'208";a="702607282"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga007.fm.intel.com with ESMTP; 10 May 2023 23:28:40 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 10 May 2023 23:28:40 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 10 May 2023 23:28:40 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 10 May 2023 23:28:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TE+mi0cDJ6ZVvwaUjdGvX5PvlnLxfX/5ucOmWvdaS36pmiNo8wQQr7G+pkztNP/Qu6HNJ209yNT/4tiVBOsZmHbJK9OSfldX0vUO76jHXuImuxn8HPg2B4Zbtuh8E1ruNkCNYFsqps12+iD7iw2EggnLT9WTEMoDC/6krKGsjydQPPQfveuvoLGIj+11rYKord2Hdqvf6YjgO46zdG3J0Nr03CdykkZ1nH1lYZYbMTgJJhAKCtXXMVnkMUHi271ebktixAzPe2m7ovgbwkHnIq59PwOQSwnLnq3hdyCMZb7ahMp9fD2CVoS+WsazK9cuAIy8zQd8T5IRkil7gOqDhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fpf4yQ9IT1DzWPryR+fpoGdPP/M6IkaXU4LoUJ3kiO8=;
 b=lO8lCviytmJlWWQ+uZzYJxDSC+S/QSMxOgR9tS3upWMr1cx3OXjO762lpIhqeOZvu03Xg7THpv/lDcqJJhs2h/uA3Z5tWE/KdlMavIc++lRG/axpAbXUGVvIJ8tp9XjsLfL3Jx8O0ZGjIGnsrik886ZSqMcfZhurME8wSivabl421iTmVMnXd+Yas6DDP944XVRQ62C+1Is140txBfh5mwVHWpcLWye8UVkp5xifNRBFrSWeoagg2me6ZZleTTuUt8TaCsbaDM5udMCo3HM3LdYs3PaH4EFf8L14hOZiHho+eRehGyTMZThxiLtk3rXx7h7UBXkPyQq3jGe62B6MKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by CH3PR11MB8137.namprd11.prod.outlook.com (2603:10b6:610:15c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.20; Thu, 11 May
 2023 06:28:30 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::b4cb:1f70:7e2a:c4f5]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::b4cb:1f70:7e2a:c4f5%9]) with mapi id 15.20.6363.031; Thu, 11 May 2023
 06:28:29 +0000
Date:   Thu, 11 May 2023 14:28:16 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Binbin Wu <binbin.wu@linux.intel.com>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <seanjc@google.com>, <pbonzini@redhat.com>, <kai.huang@intel.com>,
        <robert.hu@linux.intel.com>
Subject: Re: [PATCH v8 5/6] KVM: x86: Untag address when LAM applicable
Message-ID: <ZFyLAGastgJ5NGrN@chao-email>
References: <20230510060611.12950-1-binbin.wu@linux.intel.com>
 <20230510060611.12950-6-binbin.wu@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230510060611.12950-6-binbin.wu@linux.intel.com>
X-ClientProxiedBy: SG2PR01CA0160.apcprd01.prod.exchangelabs.com
 (2603:1096:4:28::16) To PH8PR11MB6780.namprd11.prod.outlook.com
 (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|CH3PR11MB8137:EE_
X-MS-Office365-Filtering-Correlation-Id: 2dd0cdd6-9a26-43a9-520a-08db51e8ef39
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0k99v6KZHzd+tceGoUzswqQK2/gVvmyCswGGXH2Os1qsAd9YTDbGu+AZqjDxWJEgiAh0DbvasEU06BF2ZtV1fyCtvUrgqINCW37J0XczarmKV/kB6t6pJ2MUsw8ZswsPQygU/F+RnVNL5Eb8N5TWb/j5yzAaPafaDOtJRq9AwvkgYSoneib9mFkuzOsu+8f5YcuFJr3d+FqtTRa9V+hA/DujSbWXPjMlDLIE8Oi6+FQd2J9o3JedpF0MKBezB0liPxIWc0xG5bRW4Y567ZcEPep8BdoWdD+X9exD6PeNFMWiUatyX3Pg/NvGL6dVBGROW0T8dx/MMEKFosTQRDX+f24MNABqX0LTyixnQjCdnxyf0Tkn9Tx3SOVSAKJvoOJzXiw0ZuVGUp1jd6xdS7fgCX+6i0L91ZllHCBk+03UrUn4VuYL3FPZzohGyp1q05Gul1dELkZpKiZaQIQUXZt2p5+Za8+Byu4Mbpb/vgGqp8Dl9WNP7hgvl5Es0eHNLFv+BjiBagzzRnrR4Mx+BKcDAM8+1c9b0WBqa2NVdQXuxbaRuFcxuVSD0Yc6G9gsuFPF
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(366004)(39860400002)(396003)(136003)(346002)(376002)(451199021)(6512007)(186003)(6506007)(9686003)(478600001)(83380400001)(26005)(6486002)(8676002)(6666004)(316002)(82960400001)(38100700002)(41300700001)(86362001)(8936002)(66476007)(66556008)(66946007)(5660300002)(2906002)(6916009)(33716001)(44832011)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fOQVcYLVOBRWLiKkJpMkmHUbbVFrrUjTQyphV2yM3eytDmyDMFek8shbhwbk?=
 =?us-ascii?Q?M8ddIGr6rxMW64whXoaaPJBbebZCLNpSSrHubC9arsCptWN+SjSLyzjQjD86?=
 =?us-ascii?Q?58l2QD+fxMMDgM4ZwtLQB0EYazT8KdfprKmOObWroIhRISE4PqLtl1zAxULO?=
 =?us-ascii?Q?a2vpUS9S1tByP55TEYX3h8FM8DJzRrqWGf59B94oz4CthupcbAZYgx+RLN/c?=
 =?us-ascii?Q?Fu36cgJHUhjNmcGAWa+qgKLfLRdZ6Len1s2P27nVBJv5psHn5igTpu5ggx1k?=
 =?us-ascii?Q?2etPbdfJODdd25TBZFzUBNVDoKZHAcmyLbyY7s4qKGacqi/sRP+skvDPFTPU?=
 =?us-ascii?Q?5zflBr7+jaxjIw5yjeZxDkE6t+XSUN8BAEKlvCu/wIhBt9ZcYkl2OTftE0cZ?=
 =?us-ascii?Q?E04I6TKGUEGtn+RC3BPdQ8jVajhHkkYe89ekccdOphjwjY/ZMF8VZdE942Fr?=
 =?us-ascii?Q?RRjFZifzha93X693eO2FAZ2/FGF0vfPtVHElUHSrX7rT1D+q8Bmz5OI6e406?=
 =?us-ascii?Q?Zp+v7qKDVyNsRAi3+cYVrZUh4ZPijGBc1ege8Jnbuwy3IzbZmHg9JzlI1IMf?=
 =?us-ascii?Q?BLGeQZMYXmf/y//mBnxlluNnlXCoSOpaDW44zbbHKyJpQvfhnJnVealwR8sj?=
 =?us-ascii?Q?QWGqtavIr/91REffLjpksEDTwxCx1fd3DWxBrDe+MiRqc5Yk09HaUobjM6bn?=
 =?us-ascii?Q?1LwXrlZQlU2sj+23wszPkxEbtLI3CepyrYAl1E0t4K5ei6QBPkVBiRTSoerT?=
 =?us-ascii?Q?nHVxd5nzbkPyx1P6/dyMkS82mpK5nDbcZXYSzNY0I3Qqqli+C3HBWh6wMlcC?=
 =?us-ascii?Q?AO939HPDhpMyebgakC4pNp5HKleFT0BMCpTsCyilP4jaZGLC10ETMoXE4XH8?=
 =?us-ascii?Q?7psw8S//zFqU1uaxdm7p/+eFh3yPZoH9sli/2Q6RoZDPO3X2xO/qtanJ50xp?=
 =?us-ascii?Q?/jeqfd/v7dTBp8AK8eVGRREmLcYrrPjakNvTpTQnkQAWPn+IMCdNX1vQdv77?=
 =?us-ascii?Q?CKU759LnwOarV48cpo/9FmNcaRddV1KlOkS9NwGC/EhbtZZSLJMyQKWciPnG?=
 =?us-ascii?Q?0qn7XT46WNUzXxocT3oPKJE4QdGUjBI1PNPFlVPQF8sxUsFTtHYRhN3rLpG1?=
 =?us-ascii?Q?B7pbI1PXKXJBQo8VLgN8PsSOTFj9Ee5+t5Easx2sceIR9MgFIO3k7eRO9eu1?=
 =?us-ascii?Q?tPcZqHit2JY1aDvi528O6BXNvQBfFKyOfOrIPOOY46mA3qyKiYigbU92QR9s?=
 =?us-ascii?Q?HydxpJ8iWE3pWGu+1bBoJHxTAk3+lw/vXxyn7MdN6VU8zqpxsSZzLkjXEkmA?=
 =?us-ascii?Q?1UaKJ+Px33oYrIpjrmwZ/0D+sTxIUA1tBOX4Earu/SOnE5WrhsR/dcph2gax?=
 =?us-ascii?Q?9HSkGuY40zVC+6Ew/5gGJ6CppUNKXJhi8zbht918aldfCsPOd5Rd/GBABtfb?=
 =?us-ascii?Q?ryl3EkokaE9ZhdTGZA0R1Hvsz163gXVX4Xwtl2fM2VLJNXN0ZxNmW5LMU9Cc?=
 =?us-ascii?Q?a8pmbbecpXJFNRwbHtA+mtUYXUfRRasy7JESxD7CpRs3vakBhQP0K8jgurcL?=
 =?us-ascii?Q?a0p6ZhjDgDsDYhSOR2H2RD6pex9pp8aFwkeCC09f?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2dd0cdd6-9a26-43a9-520a-08db51e8ef39
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2023 06:28:29.3594
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /UQzeEUec7S40t47jtm94hK0sVrcd8lMBnMIxBADTuCH4RHGIeUQ9r5iyFD50tyy6knZ6+cR4qQFPdhfiMxPJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8137
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

On Wed, May 10, 2023 at 02:06:10PM +0800, Binbin Wu wrote:
>Untag address for 64-bit memory/MMIO operand in instruction emulations
>and VMExit handlers when LAM is applicable.
>
>For instruction emulation, untag address in __linearize() before
>canonical check. LAM doesn't apply to addresses used for instruction
>fetches or to those that specify the targets of jump and call instructions,
>use X86EMUL_F_SKIPLAM to skip LAM untag.
>
>For VMExit handlers related to 64-bit linear address:
>- Cases need to untag address
>  Operand(s) of VMX instructions and INVPCID.
>  Operand(s) of SGX ENCLS.
>- Cases LAM doesn't apply to
>  Operand of INVLPG.
>  Linear address in INVPCID descriptor (no change needed).
>  Linear address in INVVPID descriptor (it has been confirmed, although it is
>  not called out in LAM spec, no change needed).
>
>Note:
>LAM doesn't apply to the writes to control registers or MSRs.
>LAM masking applies before paging, so the faulting linear address in CR2
>doesn't contain the metadata.
>The guest linear address saved in VMCS doesn't contain metadata.
>
>Co-developed-by: Robert Hoo <robert.hu@linux.intel.com>
>Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
>Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
>Tested-by: Xuelian Guo <xuelian.guo@intel.com>

Reviewed-by: Chao Gao <chao.gao@intel.com>

>--- a/arch/x86/kvm/kvm_emulate.h
>+++ b/arch/x86/kvm/kvm_emulate.h
>@@ -230,6 +230,8 @@ struct x86_emulate_ops {
> 	int (*leave_smm)(struct x86_emulate_ctxt *ctxt);
> 	void (*triple_fault)(struct x86_emulate_ctxt *ctxt);
> 	int (*set_xcr)(struct x86_emulate_ctxt *ctxt, u32 index, u64 xcr);
>+
>+	void (*untag_addr)(struct x86_emulate_ctxt *ctxt, u64 *addr, u32 flags);

Nit: using 'gva_t *' as the second parameter would eliminate the need to
cast to 'u64 *' repeatedly.
