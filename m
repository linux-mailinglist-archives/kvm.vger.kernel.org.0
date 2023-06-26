Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A015373D560
	for <lists+kvm@lfdr.de>; Mon, 26 Jun 2023 02:36:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbjFZAeC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 25 Jun 2023 20:34:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbjFZAeA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 25 Jun 2023 20:34:00 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2543218B;
        Sun, 25 Jun 2023 17:33:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687739636; x=1719275636;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=2mO17IMUP9beUAhVS7Rihq9IN22H3QiTRa0RfceSjKs=;
  b=jfNoa5UAtaVfI7xkTVy0w7e4QKZViMviKfJe7OS6JCTHAlOy/ZQ4YXze
   U8qfKd4dCZJq6Tv5auJUmaXSWMz6/VxV1gzSQyrJJGS3p+/BEZnfnkpLu
   v39R0DORGCirWweNizQslglIHGGhVCHLOw4UXKCxCN2zZ/uwjlVVb2HYh
   PCSihwGOIo3EN8c3/a7ZKAdwCcoB/H00FS1gEEWwU5o579o9ZY5ZNocpt
   3IjeQnbY6YKG58YB0m+9AvBJ8wacinjEf4wYLasOXpTEIuY9uW5HPJ99N
   h8lorqNx7fghlib5bpepn5FxzioD1m3PwhaJmcr2UvmszYkBehwGEWimv
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10752"; a="341478753"
X-IronPort-AV: E=Sophos;i="6.01,158,1684825200"; 
   d="scan'208";a="341478753"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2023 17:33:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10752"; a="962576832"
X-IronPort-AV: E=Sophos;i="6.01,158,1684825200"; 
   d="scan'208";a="962576832"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga006.fm.intel.com with ESMTP; 25 Jun 2023 17:33:47 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sun, 25 Jun 2023 17:33:46 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Sun, 25 Jun 2023 17:33:46 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Sun, 25 Jun 2023 17:33:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W8FrwXzFhdKMJxxiIxNUnewaj81p9cqVbSVMV9qaN85HKIU/Ywu2GEaO5HgFa2Dc6AXTiuVBcibU6OvV+LRCrxpae3hd8H/wB6LZtLO3WsD/C9opBgda8Lq4aX7BpAN74gSKCZquZEcnhQGj/hiD9r5eqQyLRwfXoADyT2tkE+gzCPPcvpyAoszQpghXEpEjEDEF8KKPrl3z4+A2X2M5fWBkQfCjsHT9WMgf2Zkra8VWRvrzg/xvrl79kKb6Ad8fdKYZAt9JPCPGA02UC5cmxv2UZEZT0Q8HelDpUN5C+dnRnYMke6+j+ImBs5McBEKEBqOadgUDy5KyHS+4IhNbrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XMjPmB8tqLz6t/AhTcqbvcyZpxLvtoSa0hjyHJWLK9g=;
 b=Dc2N86ro5MWck8dMl7tWo7T4PL8rKHTWasy6YVAjk/80ntwj4jFU0sjF9IyaF7tZhvtXe5EDmRePDda4SAxzZC/arzmlXj+FoiN1HWMhJRLgmq0V0joyHUhRzT/HvIBTFHUTPenEM6bAT0vux62M2EkHTFq5zMNoXeIrVFY6WA3KTcuYeZxLisw4Xs5ad3Yga7/EJlFOJ2w9WB0j9QXlMZS2/nOyXwKpJFeH3OgnwWpRQXvtZPx7iED0USuPs/HlEgPnztqFCIXNlkg99jF8nca2xILxgnzlHl5y0DN6OuapgFs89J1zxD269+DG2uscTNqaXLAQc+4ZaBUmXCwQ0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 MN2PR11MB4693.namprd11.prod.outlook.com (2603:10b6:208:261::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.24; Mon, 26 Jun
 2023 00:33:43 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::9f93:c41e:2b80:1d6]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::9f93:c41e:2b80:1d6%7]) with mapi id 15.20.6521.024; Mon, 26 Jun 2023
 00:33:43 +0000
Date:   Mon, 26 Jun 2023 08:08:20 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
CC:     Chao Gao <chao.gao@intel.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <pbonzini@redhat.com>,
        <seanjc@google.com>, <kai.huang@intel.com>,
        <robert.hoo.linux@gmail.com>
Subject: Re: [PATCH v3 07/11] KVM: VMX: drop IPAT in memtype when CD=1 for
 KVM_X86_QUIRK_CD_NW_CLEARED
Message-ID: <ZJjW9Kstbfa+LmAV@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230616023101.7019-1-yan.y.zhao@intel.com>
 <20230616023815.7439-1-yan.y.zhao@intel.com>
 <ZJESMaG5Thb5LWtt@chao-email>
 <ZJEQNTvfwOSsSzrf@yzhao56-desk.sh.intel.com>
 <45be3429-f352-920a-d1af-7f3a07930f5d@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <45be3429-f352-920a-d1af-7f3a07930f5d@intel.com>
X-ClientProxiedBy: SGXP274CA0011.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b8::23)
 To DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|MN2PR11MB4693:EE_
X-MS-Office365-Filtering-Correlation-Id: 83fd7e15-3291-41db-86ef-08db75dcfede
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c4Peb0b4Mzz3BUAqtDy+Gt1n2viLeW2uGVEuz+RkLF3FwcqF+Gn7ipqAV9pV6qiIQTAXlfQtUcdVFseRiJTxWoamCGWGkARI9V7tTqF2gltuRKGkoIyXYrfonsBri1zjXE/+Y8Vzl6ocCvinVdalS7Qwm92JgC31IfhjCYfRlI7PjKjThFCOyW0P4Kx0TFHToA8p2gVgF0AHHLcBU/1PdYZlnW2vwrrxLVjmbZ8zCtKdN4GZ+DIXuByaDbikotuzSlSmoe601q6/+fsEXIGBUO4QY56LOT6jIx4G2k+avjock0UWliO6k+iklHrOlMs2WsKkgxtFhACNbF5aBw9r09l9dXED3ixbqZnVy29H9KhXxQN3gVdLM6JnaXgYO5M0Y0QrzeYHUxPUP+pgF9NMr0NGmURIApyXrzdS3cPBwIh0VhaH82ZdK5eql2BG/xq94OdVg4HVasHNQpMMg8/EA4wTphRj8zHWpNu4fvjGGJZu2vgqD2/ACPnm7Q0fuH/C6eGrD5IQvrMOIkW/75vVsOUEMFcKFTER3dcwXh4wycrEJ2AusIKx730Tb60vjTo44itN8EIf6hN0ISfKMjsVJQIbiP8fnL/logu5yo8hROg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(39860400002)(366004)(346002)(396003)(136003)(451199021)(5660300002)(6862004)(8936002)(8676002)(41300700001)(86362001)(66556008)(66476007)(38100700002)(4326008)(316002)(6636002)(66946007)(82960400001)(478600001)(6506007)(26005)(6512007)(53546011)(2906002)(3450700001)(186003)(6666004)(54906003)(6486002)(83380400001)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?72afpJis1qv9VB/eVAwFed0DY4MG+suLT1L1zeU/0gQOCN6RhBOVceHNUI9j?=
 =?us-ascii?Q?bt+PaN8AuQ2cQY0j1Y+3yod6u2bbLQEY+ErYLGZVzbv6MIRMzRdG8JgkrEJa?=
 =?us-ascii?Q?pofKAEQvH/aFnddCTZnwZxEh432fME5kh1uLLuL4smgmijq+e/3awZ8O8XU+?=
 =?us-ascii?Q?BnQbhY0zqgZK1SxNwypqMw3rvRMFAFvM98JAR+rvbNS0PmO3ST3Fm6APOjKT?=
 =?us-ascii?Q?vo5g0c0A3inky4TeZJI1FCvl5Wc2POYLdpFONZobGGOocab9QsJwciYqWZiQ?=
 =?us-ascii?Q?x+F/WRTNC9wlf0ZMjY1/2rc0iLfJGs91gNue5W8KETWP9a41kmv77jquiwpx?=
 =?us-ascii?Q?dwB4MY+Walw1SVH5fgjJ6rLtDPLFok0LkFadE5GMGQZDlUOg25P6GhfeJ9lp?=
 =?us-ascii?Q?c1eJj6BwKPgzEldKdx37RPlfuqK0N5FHX4R3LFvFdLAF235XYQlI3GlctBvC?=
 =?us-ascii?Q?YbMQVyg3eIXzmLH3nQV53UA2nQoxta6cyAGt8zcAJVGklwPR1XzPSL7CfU61?=
 =?us-ascii?Q?YMsZM/S6jZ2grKXLoOhKqBsj/vt5+wu9+iUTHiqoN8IJNIosGDkZfdaWyPRZ?=
 =?us-ascii?Q?lcZwIs4oY9xBai9kyFrW6iuDWdLt/eNkHDFDCstrLhVzRRBSi/evnAGBI28J?=
 =?us-ascii?Q?NN4RiSlI1XJJdD2AzJ5NH0UxECpSH67hq/qViToVXhFyrP5D6qSo4FDdgJ7L?=
 =?us-ascii?Q?4EnTf7PCkQf1WvCr3zRgdf7P/wUkDdg3t71HvYcrkXKlY9L78MMjSl3qofiO?=
 =?us-ascii?Q?82dzbHl+bnGWp65tRS++w2LFAHwYhAlsmNViWMq7AzwYbs6RjNCfe2OjW+4f?=
 =?us-ascii?Q?QoUf0eABEeeB/kJX7QdXx4sK/jKwcr8qnXC4EqtQ6Upw3ktHDk2xki5mfw0Q?=
 =?us-ascii?Q?r8ZJY+Qu/JufvizHagyxzPCzPdhnsH8kRmb0hsBHi3qRmFlr/LsECO8vi06l?=
 =?us-ascii?Q?3M/fT/f3CuCybZcHserrCyuZ7xlhpuPKYs3yamB4zie2htmU1XbvxWUnvUGV?=
 =?us-ascii?Q?xDvB3M2HL/FbdUc26sm9XdJPAZ41Jd/+ucFGwXAykR7+fmVJRc+ciAANENtr?=
 =?us-ascii?Q?oUqmhoXx4Vvl3jNSrkxlCezwwtfl3AGqQfBYsMaisrM47rOhvBrg89Y100fZ?=
 =?us-ascii?Q?VmU/eMLbgj8adF/VLCqdHqKrgogRtg0X7BDsTN5iMjSPDk9rXUPIdgY66Z+b?=
 =?us-ascii?Q?pRtnpwJ8uaXjIr3w/EvDIf1TeHN+5+cuO4AFWBisJpIlQ13Jkqpsi6x8EeXX?=
 =?us-ascii?Q?S6rh1hv9B3hoPYxg25aWiGUDh4pZgOXBZOXGqpDyo5NO3taALrqhJsZJ8DOJ?=
 =?us-ascii?Q?3jCgqcwK7vlSHH9wj4ewZBBUm/BHyG8io74459jiZ4blSvEwyL9XOpv+hNBr?=
 =?us-ascii?Q?7U6k4NGiF8B7VoX8NN0M84W9NHlavE4n7w4OySq+nh588KnhnJBjhvBMhlj0?=
 =?us-ascii?Q?WPnC4orDZlKTP87dSSPqdc4U0EpZKTS2vB5sIXvYH2a8tnAQbXAKT5HQnxgg?=
 =?us-ascii?Q?gTYDjRoZR1GpAlxdd0MD9N2BNWaxAiIzky3hDU+W5Aeu7fEOtBo6nEYjvuR8?=
 =?us-ascii?Q?lpWRuFDHcDYYW/QgF2MPjuXb5vtOMDUe2ujHNMJ5?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 83fd7e15-3291-41db-86ef-08db75dcfede
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2023 00:33:43.4298
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EjvyqF0PEb2i/zBNzJgCksGavPuwiC76axSQ49grrczrvJbI0DZDIANPUx+cBkzte7RggfKM1b+EQr3NodCdKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4693
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

On Sun, Jun 25, 2023 at 03:14:37PM +0800, Xiaoyao Li wrote:
> On 6/20/2023 10:34 AM, Yan Zhao wrote:
> > On Tue, Jun 20, 2023 at 10:42:57AM +0800, Chao Gao wrote:
> > > On Fri, Jun 16, 2023 at 10:38:15AM +0800, Yan Zhao wrote:
> > > > For KVM_X86_QUIRK_CD_NW_CLEARED, remove the ignore PAT bit in EPT memory
> > > > types when cache is disabled and non-coherent DMA are present.
> > > > 
> > > > With the quirk KVM_X86_QUIRK_CD_NW_CLEARED, WB + IPAT are returned as the
> > > > EPT memory type when guest cache is disabled before this patch.
> > > > Removing the IPAT bit in this patch will allow effective memory type to
> > > > honor PAT values as well, which will make the effective memory type
> > > Given guest sets CR0.CD, what's the point of honoring (guest) PAT? e.g.,
> > > which guests can benefit from this change?
> > This patch is actually a preparation for later patch 10 to implement
> > fine-grained zap.
> > If when CR0.CD=1 the EPT type is WB + IPAT, and
> > when CR0.CD=0 + mtrr enabled, EPT type is WB or UC or ..., which are
> > without IPAT, then we have to always zap all EPT entries.
> > 
> > Given removing the IPAT bit when CR0.CD=1 only makes the quirk
> > KVM_X86_QUIRK_CD_NW_CLEARED more strict (meaning it could be WC/UC... if
> > the guest PAT overwrites it), it's still acceptable.
> 
> Per my understanding, the reason why KVM had KVM_X86_QUIRK_CD_NW_CLEARED is
> to ensure the memory type is WB to achieve better boot performance for old
> OVMF.
It works well for OVMF c9e5618f84b0cb54a9ac2d7604f7b7e7859b45a7,
which is Apr 14 2015.


> you need to justify the original purpose is not broken by this patch.

Hmm, to dig into the history, the reason for this quirk is explained below:

commit fb279950ba02e3210a16b11ecfa8871f3ee0ca49
Author: Xiao Guangrong <guangrong.xiao@intel.com>
Date:   Thu Jul 16 03:25:56 2015 +0800

    KVM: vmx: obey KVM_QUIRK_CD_NW_CLEARED

    OVMF depends on WB to boot fast, because it only clears caches after
    it has set up MTRRs---which is too late.

    Let's do writeback if CR0.CD is set to make it happy, similar to what
    SVM is already doing.


which means WB is only a must for fast boot before OVMF has set up MTRRs.
At that period, PAT is default to WB.

After OVMF setting up MTRR, according to the definition of no-fill cache
mode, "Strict memory ordering is not enforced unless the MTRRs are
disabled and/or all memory is referenced as uncached", it's valid to
honor PAT in no-fill cache mode.
Besides, if the guest explicitly claim UC via PAT, why should KVM return
WB?
In other words, if it's still slow caused by a UC value in guest PAT,
it's desired to be fixed in guest instead of a workaround in KVM.




