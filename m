Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 740D7736232
	for <lists+kvm@lfdr.de>; Tue, 20 Jun 2023 05:35:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229901AbjFTDfA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jun 2023 23:35:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbjFTDe6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jun 2023 23:34:58 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F4025E61;
        Mon, 19 Jun 2023 20:34:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687232097; x=1718768097;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=tqLwrVs2oRdgzw7ekDobrt62lRcyDYnab28X6KRiWbM=;
  b=aMeZlaXNLVeUObPAZHht/nz2ceSxB9L52QMqlxKpSDw0JxwUyGHtl+ZN
   tV5wULKehXvE0Y8KZKU042qc5YdxqFXEfldRv4tMuQw25/ouqx5AQy8nA
   F8uyP8U1vZLoz5jqf7NXNcrrpzydaFz7DZqdmSZTpMrKcEk2mybypXlYo
   C1xG4zAZmKrvKuaC6sY9ajtCN80YYJrNgY5kEV2fuhkX5ljlsdrCdRQV8
   plZN+VJmri/rsJVcjAioGA7f9c2J5jaJSnLOSneFK+gWg5S4VTM/h79go
   weZPdD1ExrZpoF3m0/bxTki+zacr116ics29xhXGy/IdDdBQOSfh+A5l1
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10746"; a="344501082"
X-IronPort-AV: E=Sophos;i="6.00,256,1681196400"; 
   d="scan'208";a="344501082"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2023 20:34:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10746"; a="717078657"
X-IronPort-AV: E=Sophos;i="6.00,256,1681196400"; 
   d="scan'208";a="717078657"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga007.fm.intel.com with ESMTP; 19 Jun 2023 20:34:56 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 19 Jun 2023 20:34:55 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 19 Jun 2023 20:34:55 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.108)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 19 Jun 2023 20:34:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mjm1FnCEpr2OIPzgSRzAtRhoRPNwwwBck1kor7WUuza6hD7+ZjNQI+cM40sg1ivOUbBhhomdRck/hIHtQhJrKikCHyiEo0xkm8DpGV/FLrenPWMb+ZpIQy2OT5KEz9YzzvTphTTUCGRyp381QUT0X+rAK24eYtD34yqyt3hPwWfZVupz6xyRiemZNDmYdieNFA66GCGBh+dcUACImPdA0mBiEKdkwlUL1FX8qrmHDj1KkCD3bxHPNFgss4o2A5EApSr40+OW0u3qp3W0eXcoHgvRhyWvEcG/hu4hCkrJV9llLCDqm6+8bsQAwodVoVCpq/56GH9XOwMbelUfm8kz+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=58ysYbUoUG7SnzN9kFBDHepikHTT1tQGcQZqsVFHxis=;
 b=NuNvFxGnpVMIds01sFMxIN70H/+pLVVKhJNecZdLiXse1L0pJbwk+ePxiUNhJPMauzMbwbG6R7/G40HVU1IvKmpG1B+SIx9gRoF6AMEZujykKmBNO1X9kpvbP+8q3gMksNstSepxlyA1qn0Kh7FGQkB4lwFIDPMWAkB8RsZnGJwrTh7ZXQMPvh/q5Bay7aWo75hMBHO830lL+MPW7EbkYfWxxfWKX596GChnyimpiiY6xUXoDxI+7vSUWgVgEkisOqoMhegiB/+ddeWHBDz2Tu8JK2fQloKlxiNY5zyxZMjUTI2SeorBd2tOmO5WiI+yuqvhduIDIgfczKM7kFCQKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by DS0PR11MB7733.namprd11.prod.outlook.com (2603:10b6:8:dc::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Tue, 20 Jun
 2023 03:34:53 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::5817:cb8f:c2b7:f1e5]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::5817:cb8f:c2b7:f1e5%4]) with mapi id 15.20.6455.028; Tue, 20 Jun 2023
 03:34:53 +0000
Date:   Tue, 20 Jun 2023 11:34:43 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <pbonzini@redhat.com>, <seanjc@google.com>, <kai.huang@intel.com>,
        <robert.hoo.linux@gmail.com>
Subject: Re: [PATCH v3 07/11] KVM: VMX: drop IPAT in memtype when CD=1 for
 KVM_X86_QUIRK_CD_NW_CLEARED
Message-ID: <ZJEeUywBg5q/bSYi@chao-email>
References: <20230616023101.7019-1-yan.y.zhao@intel.com>
 <20230616023815.7439-1-yan.y.zhao@intel.com>
 <ZJESMaG5Thb5LWtt@chao-email>
 <ZJEQNTvfwOSsSzrf@yzhao56-desk.sh.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZJEQNTvfwOSsSzrf@yzhao56-desk.sh.intel.com>
X-ClientProxiedBy: SI2PR01CA0054.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::22) To PH8PR11MB6780.namprd11.prod.outlook.com
 (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|DS0PR11MB7733:EE_
X-MS-Office365-Filtering-Correlation-Id: e4abfd90-cfb8-41ec-5179-08db713f4f0b
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FuoLCSCZFTEp2loUUVyhTx3NHqlutqv9WIoeTy1jUm1IqylzC53Of9oDszXtY3r2y+jPrdB9OLZbtzutveRQ6xik+yoy00n5tWB4otWs0L9HMzb7tmAMqHJ0OPpBFQyD0LYtdINvZWgto72m0XnAh6KjR47LqoPiHifomvLzcdEAkXDMQ/5pLpiiZAwUF0VEH+6/NHmFS1E7VEvotFaQcm3XaOom0hSPHRC1sq9V6WqnWXuKuP9AHhrtWEmnfVi/kil7QqFEBZXVwG29R7ToWkzGPwoUvwh9SLybtT3RJGVR8e3JB8BX6uh0gMQjSIInDfsRB1NO0Pyad70eMj0jPGyqrHQxbnAB3jv2/YaXQgVhP5tHUmyFWx2djMRq+GHqixjPXa9HmWFoYOYZqhiV3Q1JdT22UgorYqTGzDHraSaHynFyqy32+ilg14jdFUmnsO2+0uZNl9Nk+a/a7af3cfw+N+J+G99BZC2y0U/1Ge5I40tYf/RHJYTOa4W08hEWOlceBPoNFSS5DjS68blJIsyNAP8AtnMW7hKWgbykwDD2dXbIDORWiEyYPrBZEPQ3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(396003)(366004)(39860400002)(136003)(376002)(346002)(451199021)(82960400001)(33716001)(38100700002)(6666004)(86362001)(66556008)(66476007)(66946007)(478600001)(9686003)(6506007)(6486002)(186003)(26005)(6512007)(6636002)(2906002)(4326008)(83380400001)(44832011)(316002)(6862004)(8936002)(5660300002)(8676002)(41300700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?R/fun/yXw02NmSWlJCxy6ifOIVTr/uSzIiHgXdZN9tjZ0kA/kNyvsB8aoAoz?=
 =?us-ascii?Q?Z/LS79E/bEefAA73juJ1RjJlwUXCs/rUCt6OsuKzhcCoZVCz46vF+KRJ2dm+?=
 =?us-ascii?Q?YqruM1JOA5N2F+WVpzzuRlslPiwFPFQBuVxCigAicYs9LgBnLYmTk9VtDo1B?=
 =?us-ascii?Q?Zkr/gzN4ZrgXV5zd0TpFu1WCbQKCoBJoiD7gI5s7aSfCwosyCJm2d+kgioGU?=
 =?us-ascii?Q?MjtMbYRD+UxYdZmJQApTqtDt+YUTcFZT4NaQ52/mY/cdpBEpHLwqJx55xTfQ?=
 =?us-ascii?Q?buKuBWVcYtbuXib/JcMJghKpnBUJBlf7uYGgb1mLvu2SAQCOs9AsBpmcnG8+?=
 =?us-ascii?Q?lGZE9DgcmI0gQ3PpZv3OtuOqY+yy1ji9R72yRxgyZu3hc+R8TevfoOdkJmqq?=
 =?us-ascii?Q?5ExlzG7zzyqZ/23uMpfGhnFp3BftojU/0iCR2j58FZRq+fAorGMeR6yDjn+S?=
 =?us-ascii?Q?+Y4+4Dc69E0KfuBxKKfl5d4hZkq9BH0K4w1V+HJJtgMop99mV8s4yjzeeNcr?=
 =?us-ascii?Q?tpvUJvBuk9bnO6MypWCsi+pei524t9O1wB/S3Ox5ckx+Co3hcl7vSuIbQg53?=
 =?us-ascii?Q?OVbqtjV0BHafijnVZ32cXLsYPWEDC178GjTRlocifAfD8EoWFdpd+MyqLLOa?=
 =?us-ascii?Q?uM01zPjHOOcsfgc1XuYDi2t8TF4Dv+NutR05kpWRfqNr4Si+lSoQAIrLq1Vf?=
 =?us-ascii?Q?Am3ziwFwHQI3lLOYpVfHS2+iZAF423FQwtRc4n52f1sDdcOI2aQ0XkWHFUGO?=
 =?us-ascii?Q?8Sjf1My6o7nF86Cxb+d0bpHALxj3NWu/xFWv0LJQTzmUAnyLQ1Gydsz7JKAm?=
 =?us-ascii?Q?/jpmTY/ooWFUzHdnqMo/ch9RxKsWpjMV2nsL6qwpGQwwLVqqkA1gso7LGOHN?=
 =?us-ascii?Q?lKCRjH1gkzaVBcUoQx36bcdL4dC+WTXppGZa4ZoH1vBy6DQ9rzIHLBNsK8e6?=
 =?us-ascii?Q?x1z3XU+wuqHRQVcufDybCnv9P4wVMbR1ivtakk9eiYXNYFtQEUXhhS19aV1n?=
 =?us-ascii?Q?/A0jEr1eEV2V94InrDr5BlOHwsZ3CyOttVVh5St8sN1HVsXPSs5cH9XZy20C?=
 =?us-ascii?Q?QJLd+Q7Q8Eu3CjWVPrsN+OJPnesFGTaMYoNqHqNBziGPfesMdAwezaKP7czA?=
 =?us-ascii?Q?d5jMjWwYpfLCGolof6buOrGoWhR252prD+KTnXXfLLfXIgrjl1HU+KoCxjEU?=
 =?us-ascii?Q?0ptz2MneSD4pWyelBjYtVKr80y+4v+7e1D3TIUpvZ8QAdy5MlFA9qmYVh3Qi?=
 =?us-ascii?Q?YQ7bMUcTuVg/WFkYLTRnrysvQ4xmeOOEtVdH+j+UMFOd6DHVzAfDh/rOaUau?=
 =?us-ascii?Q?seUFjIplNGc8ZbZRpgAyRlyM6CmX4IO9zDTA/Vuf3aSLBUM9vRawM4UolUGm?=
 =?us-ascii?Q?EFnBy7s0VeG6dMEp5385ONE0qsMXpJpqI5s9AATFvGGn+MryjB/xljn8xyiR?=
 =?us-ascii?Q?1XbdQK11pWcxGTinDMXTQI+97g+GMX+1VooYWzrtEbWjtNHKN5Os8XRuETZf?=
 =?us-ascii?Q?b8ZBAJRTZ7fryhe1Udt/vmKmFsoyPxtOnjVk7kjAcPMNvBGLN5ubv7uzavLW?=
 =?us-ascii?Q?jND3a934yPQTZe71Kx0DmHEUs2cxBsIT77KJ+wns?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e4abfd90-cfb8-41ec-5179-08db713f4f0b
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2023 03:34:53.0597
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u5+C2ylgQ8Ky0jruDBxFJ1yGYXRGkBYfgWBUTtI6vnsCNjBXr7xeEgw8TXg3owosXGuFRmiXF7vcesBR2uC9bg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7733
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 20, 2023 at 10:34:29AM +0800, Yan Zhao wrote:
>On Tue, Jun 20, 2023 at 10:42:57AM +0800, Chao Gao wrote:
>> On Fri, Jun 16, 2023 at 10:38:15AM +0800, Yan Zhao wrote:
>> >For KVM_X86_QUIRK_CD_NW_CLEARED, remove the ignore PAT bit in EPT memory
>> >types when cache is disabled and non-coherent DMA are present.
>> >
>> >With the quirk KVM_X86_QUIRK_CD_NW_CLEARED, WB + IPAT are returned as the
>> >EPT memory type when guest cache is disabled before this patch.
>> >Removing the IPAT bit in this patch will allow effective memory type to
>> >honor PAT values as well, which will make the effective memory type
>> 
>> Given guest sets CR0.CD, what's the point of honoring (guest) PAT? e.g.,
>> which guests can benefit from this change?
>This patch is actually a preparation for later patch 10 to implement
>fine-grained zap.
>If when CR0.CD=1 the EPT type is WB + IPAT, and
>when CR0.CD=0 + mtrr enabled, EPT type is WB or UC or ..., which are
>without IPAT, then we have to always zap all EPT entries.

OK. The goal is to reduce the cost of toggling CR0.CD. The key is if KVM sets
the IPAT, then when CR0.CD is cleared by guest, KVM has to zap _all_ EPT entries
at least to clear IPAT.

Can kvm honor guest MTRRs as well when CR0.CD=1 && with the quirk? then later
clearing CR0.CD needn't zap _any_ EPT entry. But the optimization is exactly the
one removed in patch 6. Maybe I miss something important.
