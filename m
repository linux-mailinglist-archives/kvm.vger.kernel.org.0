Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B98F96F6843
	for <lists+kvm@lfdr.de>; Thu,  4 May 2023 11:27:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230296AbjEDJ1y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 May 2023 05:27:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbjEDJ1w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 May 2023 05:27:52 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 304413A82;
        Thu,  4 May 2023 02:27:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683192472; x=1714728472;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=wYYjyiUgGUvniNeiN9FhsEPF62k6wQOEocV+fMnT+IE=;
  b=AqeE/wREuJHoYWWSpcmdXwjB1MQZQZnwVe7NmHvAaubgpU/ukBRmSktQ
   qL5lCTJEicTqja8B7SgdGC+GaeG4c+fXAd52rvEUw6yv8NA6VjKa+kUkR
   2UDGPvlxhY099rawd3NpMxbs6p2pYH6PTrvJHLCcbV5NMgTyXfnLUEXqG
   xh5T1lY5Brbtzf0HOfaM75EaVq5Ee2oJFYVJ24dl6b+gFKwAPQ1dv9SMH
   Np4a8RI1BMQIXkQ6yNRiVkyO0TeS5LdAB19YHKJZIqIG86A1fEeWtYa9N
   REcs/V8ZM4JMb4c3YeCyVam4akwAtqEo5Lwv9Ob+NgjC/gTNveX5WNW0b
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10699"; a="346354188"
X-IronPort-AV: E=Sophos;i="5.99,249,1677571200"; 
   d="scan'208";a="346354188"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2023 02:27:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10699"; a="729722133"
X-IronPort-AV: E=Sophos;i="5.99,249,1677571200"; 
   d="scan'208";a="729722133"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga001.jf.intel.com with ESMTP; 04 May 2023 02:27:51 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 4 May 2023 02:27:50 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 4 May 2023 02:27:50 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.176)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 4 May 2023 02:27:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j4sRIGgrfru59f/oGGf+sBvO0saRLKGRBNuEdIz9d+heBrTVDY6PZ0NqOAXURbIjEOy+YDi33296P34VukVPmHW2XFmAo/P7Cz3M5YPNdeXfFlFBE7MwVrrLvS7qnvsDYi05U4kFtyGWs5bwYBqiC1VXbageN+YniHR2HGl7kZzS8vNva/l5Im+xqiDTEwAFpfgSTAIDr3gi3BnoaPLTu06YtJ2GSmzr84HJs9rgHBXGUZUGdaU0WCPTrhFXOnAiYFD5PCnDS/KFSnLSZrT3l+7QvMeBU6UWXSBLD3jUOYt7rIjdr9emHD95kGbgWSZuRp/Kjn/exvnqgDwC8vfjgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wYYjyiUgGUvniNeiN9FhsEPF62k6wQOEocV+fMnT+IE=;
 b=lZd5c8v3BlxjRobSJ5FQhkvvnLXQXioMtTTOkU2KnOzw+pqcWoGxFsNcb/AE5+I1gi/UHahK1kSBjX/giGbX08QXcIqEXsqJhIrTe+ttWhqe0IRVQ/1Qv7HIjFiA6EA+LUhJ8HDHfU81Saj+6uL59w95+jPRE9VStE3rI/XAPhhnTntGTTUw6XvN/Te2MzYt47GHfrAe/uhasNKnCBDS3slR6S925SOAFX2t/mxxkNrIYaqIZJ2rAXFHjikkD1OaxyBsZu3ARjAGioWMtvU21UxNcQcqBfQ15tHWhRlv9tduvcDvd87Py1je6+V+RGR7HpdSAcQdtpgmshlq8ewr4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH7PR11MB6674.namprd11.prod.outlook.com (2603:10b6:510:1ac::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6340.31; Thu, 4 May 2023 09:27:46 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::a670:49f5:d602:e2e4]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::a670:49f5:d602:e2e4%6]) with mapi id 15.20.6363.022; Thu, 4 May 2023
 09:27:46 +0000
Date:   Thu, 4 May 2023 17:02:45 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Wenyao Hai <haiwenyao@uniontech.com>,
        Ke Guo <guoke@uniontech.com>
Subject: Re: [PATCH 3/5] KVM: x86: Use MTRR macros to define possible MTRR
 MSR ranges
Message-ID: <ZFN0tVIOfLaZGxX5@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230503182852.3431281-1-seanjc@google.com>
 <20230503182852.3431281-4-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230503182852.3431281-4-seanjc@google.com>
X-ClientProxiedBy: SG2PR01CA0149.apcprd01.prod.exchangelabs.com
 (2603:1096:4:8f::29) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH7PR11MB6674:EE_
X-MS-Office365-Filtering-Correlation-Id: 43efed08-f8dd-4ed6-a0d5-08db4c81d232
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lQXl+w7RUxiyyV9SQFZOqeroCV4X1QpcyqgveiQ8W+a6q93D+8/k0ZV1asj/UGHyqevZHp87A8DW4zshkqdQQ9pFOQwYTmqNuuZjyQySHLZT3xSYZEmhSLWFDfguskaq1LSdvY7RgILg6W8kOK+mqma7+of4baM8g9xddn2Ag/T3LwNFSIIRNb94JQy1JDExa/L7PFZNr0wwsmADRMGRJVxNSh94YtJGZVlqDXr9qkdpEI/5DtgOBEnkxjo0yARbmu5rSm3hLzb+xM6ltkVGYkuV0nQL6j9nQax6tEzAznLUyF6d+TUx0XNAFulqftfxd/hgU3gRrUgo0wTy6ueBcn9ZQ0gJbKJKq8uPD/pH1QFSvBN/TOk/iBrDiABjh9UAzxx+Yzo0KG7RvUzczYom24cHcXKCT52Dd7bvQJ/RiEfMVMTCc6lc7P4E2hzgXbdaFkzAV4V44tjgMe7Vx+GNkXIpHGkNQAoxpN6LA3gLmB7U+jZCEm6uoJ3HVakY2Q7rB+NvCeYfktIZz9/RwMvIcuvTQc/20orkLxL5zAWTOACaTiYdzxaHbLhEQACxS57U
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(39860400002)(376002)(346002)(396003)(136003)(451199021)(6486002)(54906003)(478600001)(186003)(6506007)(6512007)(26005)(558084003)(86362001)(41300700001)(316002)(82960400001)(8936002)(8676002)(2906002)(38100700002)(6916009)(3450700001)(5660300002)(4326008)(66476007)(66946007)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?++cEUlHXEl6BRmxQfwmLzg34PF1mKUg5HIBxzLaXTCqCJpc+GRWvmJtaGsFt?=
 =?us-ascii?Q?zBjoKOjmgV319PPXvC7SjGbeEUSfMolxy4DdcIFfx+Q6UPZXQ1UA5edaLLK8?=
 =?us-ascii?Q?gHmJxoqmX5hRjRJvo1WGwHD/HYsvLOw/Ucq04Y4PHbe0rdoWHITYHEfGeASN?=
 =?us-ascii?Q?lPx9BQcrsLLaMQ+Ndr1DIMfkauC4rxTGEnvCSRtUMVBUSL8eT1Vu8S0D05sx?=
 =?us-ascii?Q?+X95hsd6HZ9NOTieiFMTONTYAcDqUWuzEYa06oTWi4xkc6igjj7WCjOYNgpC?=
 =?us-ascii?Q?DMewEi5aJBaUpMDFRMHtKTfYL+GJV7LpliXiW3idn+coYl+KUitqGqsN0Rxs?=
 =?us-ascii?Q?g2UjdKaaZIpjIu2a6t6z/eDg3A+7/Le34aCtZht+k9hR+l1mHi5CblwKzFVz?=
 =?us-ascii?Q?98A6yLgCqe+DYIXN8xFaCZGhvJT6kBF5VJjWSbXidmUCDfaDjbeNWQ+PwrFE?=
 =?us-ascii?Q?rRBdLXnMxK2rdyUpMjVtwhU7sD8LdmoIp8yoH+5aXGJwV/kYUICLqkNwS+VS?=
 =?us-ascii?Q?PheX1mwn05CrErSeIY6IMJj+DpN2hDwfGQicoXMPEy3drKHIJJteifLuA263?=
 =?us-ascii?Q?ct4YkiOa+/7kKi5ruexBLNC0eV3Cxol8L3cFaF88WYgJ8oxD7qEB+/Om6Ynp?=
 =?us-ascii?Q?2iuuD5tzM65Hqo3X66C0xsVqkF1oS+BVvyVW39hVCqKh4LD7UKbn/cLVbdcg?=
 =?us-ascii?Q?r5MNLgys6rUTmNS0FBIlEXb+Jzr4VJD2LWefykYlH8qirBr8A7qVP4Yt40u9?=
 =?us-ascii?Q?36c1lA+HPBS6eQxxV1RIr/Oh6hUPugfRf4SitQDivvrCF8sxKDwqATIx8GgK?=
 =?us-ascii?Q?brRNQxYYno6FkrsYeLgQXHjHPukq0jKhQpX+2Y4OgqKNuAaCqYDIUl46pdgA?=
 =?us-ascii?Q?hZxGyBZoHi1BnSb/+yzhHfHkqqJMB2F77+H+cFPh/xTcDcu5CrrUEsh67rKb?=
 =?us-ascii?Q?10l/9ZxziHzO1G6+iJEvoAH0pVTd5jJa5w+So6UKLvK8V9jWUYV0l14l8XRX?=
 =?us-ascii?Q?OY3rbBDOrr1LFUp3LiSQcn0+I6IbbEI9trI7aIsED77YqAUtu8qLbH9ggW2P?=
 =?us-ascii?Q?U8YoCDzMjJ7TqQCNnS+KsQrEAzD7tcSh8yxYYm5MDt5PjKf5hbYBbE6THcQZ?=
 =?us-ascii?Q?1KfKbFx9ZHDJ3w58vbEM6nKsPGrijrci23X3BEEHEMeozWpFei3odcUbuU64?=
 =?us-ascii?Q?sUMlPE2MkgOq4ghKKItTbTild4cO/VFeUwTtRpwYJQFJK0cS3/L00wgs4JyD?=
 =?us-ascii?Q?m3og4V8kdk6+7bgb/eHl1TbafQNH/LjSuq/ntFiwBsv5LsqQTdKQuOpKzciL?=
 =?us-ascii?Q?3ieTSgPkvSIOW3rQVgi/RPfjdqeZyuNkq30KU4PoTJA0+cS9R4jmzKVTJb8b?=
 =?us-ascii?Q?WngVW6yAtN0GB7bLSsmdYDA1bsL+wc77q+qc5PCWDIoHjec7d3t/YX29Ki76?=
 =?us-ascii?Q?T9bp4qDale8OEjAYLwRESwEn8JPSfezA6LkpKaK4FB2t0qe12UwmDV/IzmNh?=
 =?us-ascii?Q?scvTq1LFzrVhUEN5YOWhVZa6XMsRPuMDv/x6Zli2sz1MYqGx9RkrV2GxxXLa?=
 =?us-ascii?Q?PbmPdwF3qfQuaIyFPMgiEm5YTYQYx14oQfe/zokH?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 43efed08-f8dd-4ed6-a0d5-08db4c81d232
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2023 09:27:46.6075
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iZfS0tw9DafU/IpTt+XXYcy2aFNPOb50v6zxYC9wf1gGnY1dzOQAnzjGnUhuwMXUZx7Jpf0fInuhAqhf/M/C6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6674
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

On Wed, May 03, 2023 at 11:28:50AM -0700, Sean Christopherson wrote:
> Use the MTRR macros to identify the ranges of possible MTRR MSRs instead

What about using MTRR macros to replace other 0x200 in mtrr.c too?

