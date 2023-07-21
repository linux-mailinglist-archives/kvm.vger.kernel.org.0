Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E210275BCD8
	for <lists+kvm@lfdr.de>; Fri, 21 Jul 2023 05:38:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229699AbjGUDiH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jul 2023 23:38:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230053AbjGUDiB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jul 2023 23:38:01 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1E4B1726
        for <kvm@vger.kernel.org>; Thu, 20 Jul 2023 20:38:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689910680; x=1721446680;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=LZI+OBoeZhVoOFW1KQvwYtbmhA7o1ZwfPYvR/uE0RVI=;
  b=HWxN6gKMIsgNFoZ2cfHDGoVhheDSniECVatBPA3tscT1036tXV7EmAf4
   xU6XWrDPL+623zx1Ch+uP5+v2l0BxONZMvKJWbqV1fD4RccjHZCH1wDD4
   Fuo6tSZJ5HEqY28wOKx5qYIx4aNTrHoD92uFRtF2PPWF3nT5WOU7VlO5u
   pIkRNs+BmnM5xvhRb807UPtd2k4CxaYunekz++GfXf94IR0NhLQOoXb4U
   MkFlG6igtZaxKeTprQ/PJv9wvoJ9aDaWNJ2yeJyRlmy9OxymcaOpXLH0R
   BYVipcomwmrtEwDVgIWXKnYG0wI1xQqShfLoDHcTCHRxUJPJ7mjuRL3+m
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10777"; a="366963441"
X-IronPort-AV: E=Sophos;i="6.01,220,1684825200"; 
   d="scan'208";a="366963441"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2023 20:38:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10777"; a="759809746"
X-IronPort-AV: E=Sophos;i="6.01,220,1684825200"; 
   d="scan'208";a="759809746"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga001.jf.intel.com with ESMTP; 20 Jul 2023 20:37:59 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 20 Jul 2023 20:37:58 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Thu, 20 Jul 2023 20:37:58 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.108)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Thu, 20 Jul 2023 20:37:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gL7ZCBjAE0wLP0DiYYpFAURYDxUKG2FaA9OgFkdQkB2jjy1n591if/H92clK1aRFMToB3RfZQCQUv4SOdgeinH7dS+0jhgq6y13mJECQPmsBoqnA+I+Ng0l+8VRUCr+CbHFyU3zDdQ2CtOMHLMu/83NhfVdPoAmZse/OI9syijKp3LHvm4bb+6TG1NK9rEaD/4P0cwYg2ZVYOwU9B7d6RPi9S7gz2ENHK7CKcq67PQvwVIV1nP5Kx7z8+FEYwRQYdQ+uVgfLB9XlaXxPgVHSnkhTJ1FRslTggt4C7kUuGtsOYFi9wx1DbDBngFSzb5EEaSRL6NFapZCA1K5PXfWzug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LZI+OBoeZhVoOFW1KQvwYtbmhA7o1ZwfPYvR/uE0RVI=;
 b=XRFN8YnLP25x29yWTn7yqND8AZ/2AbdSkw9AKKpErQDScjazhFPkyfQACGfbhoyixcelJl+QRXiYxk/wzd7pwXwfhUarsWXRzAS5ccXK7Tn+K4/P60Rbu6A6wNhe5eotiB2YExajGLNf9SeUv6V8VWF2tGenjgv6cRucPkKC4eJvrVGvnOljXwrXcrhfKvBS2oMduwn+IY0eSt9rNDTbfxInWARKPx8ye3bkvtvKNgKLg/DVL29poq9pwKVuo+xN08IiOPVlHmamzlghiaQ2xh/z4+JMsW2IRpWK5lauZuZ83xi/QwcwZN5ccPVIMBU5zcrb3X3lw9LYDWqA/bvabg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by DS0PR11MB8070.namprd11.prod.outlook.com (2603:10b6:8:12d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.25; Fri, 21 Jul
 2023 03:37:52 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::2803:94a7:314c:3254]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::2803:94a7:314c:3254%7]) with mapi id 15.20.6609.024; Fri, 21 Jul 2023
 03:37:51 +0000
Date:   Fri, 21 Jul 2023 11:37:42 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Jim Mattson <jmattson@google.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
CC:     Xiaoyao Li <xiaoyao.li@intel.com>, kvm list <kvm@vger.kernel.org>
Subject: Re: KVM's sloppiness wrt IA32_SPEC_CTRL and IA32_PRED_CMD
Message-ID: <ZLn9hgQy77x0hLil@chao-email>
References: <CALMp9eRQeZESeCmsiLyxF80Bsgp2r54eSwXC+TvWLQAWghCdZg@mail.gmail.com>
 <529cd705-f5c3-a5d1-9999-a3d2ccd09dd6@intel.com>
 <ZLiUrP9ZFMr/Wf4/@chao-email>
 <CALMp9eTQ5zDpjK+=e+Rhu=zvLv_f0scqkUCif2tveq+ahTAYCg@mail.gmail.com>
 <ZLjqVszO4AMx9F7T@chao-email>
 <CALMp9eSw9g0oRh7rT=Nd5aTwiu_zMz21tRrZG5D_QEfTn1h=HQ@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CALMp9eSw9g0oRh7rT=Nd5aTwiu_zMz21tRrZG5D_QEfTn1h=HQ@mail.gmail.com>
X-ClientProxiedBy: SI2PR01CA0010.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::12) To PH8PR11MB6780.namprd11.prod.outlook.com
 (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|DS0PR11MB8070:EE_
X-MS-Office365-Filtering-Correlation-Id: 2d783e26-997d-4a62-2775-08db899bdc08
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JaogOoBnmo7fHaHLHPimZjBXsnE9Eq0bA0mQdojRslz/ATSkhaUzcxRBVbwmLHYUjYDYuHo/90RJeROSEzZsD68/GQchuL4sghpSV/OZMNr50G0nT0E49CCwxrXkjOV3zUWrdfcpWUZuC1NmFQwX/JHngxlcLTDx0+UJyEiuoRYBQ8e/g5q0Zy5juP7QDi7T8V+nGU9aNmMLPVznmJs89tIINKAXOaZHNJr45mZR3SspfxhsRN4fQ3FBZLiaS+iPTmigd8L3NyFgLyTSifR6WflWaOoyUjNakR946RN1QcVHLEgBXaG4asiT/si1Jq2YmavAzMOfnRbb0mBQgh2SGGLs61DpmbmhjcpEhwYp4qFS8SRzHncrU36AJjpKRUY26xT0EvfDXBVgN6Qp6mZgOEdjxzVjB13d24sGa11EmH/G1ljU4U1lrUM2i92sUvVwmbLxaIwqg4b5HBjaEe8EaXUIl4uQRjqveUMcjIRel2gHjelM7U7Ji8cA63Z/wzXtwJRt4czWE/S3eqPye781VWFu2R4z2p2uyR3EVSQwWjCTbIDfk2+odpPeUkBfEIlM
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(396003)(376002)(346002)(39860400002)(366004)(136003)(451199021)(41300700001)(6506007)(186003)(26005)(478600001)(316002)(110136005)(4326008)(66946007)(66556008)(66476007)(8936002)(8676002)(44832011)(5660300002)(54906003)(6666004)(6512007)(6486002)(9686003)(83380400001)(2906002)(38100700002)(82960400001)(86362001)(33716001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?q5RVCXewooNSvwA7KCHZiU26q/8I/k0LcwQ14wz2B4FuWciWFxdTpBovN7NB?=
 =?us-ascii?Q?zDPjfmMkTpN7Q+XysqxZ7cve4qAIYvA6vIXEgu9SCTdb4QLi1zCk0KPmjQWP?=
 =?us-ascii?Q?CZZi6Ogdj9ArtIxlcqqVxGFIbe/8LzWFBWDrJ5rpxBp1i9VmSYKMjFWfMvHN?=
 =?us-ascii?Q?zzvaElKT7T9CTwJwI01AoK8ty/+CUvM1iGr4WGcvy/2ZoXu57cs/IeXrJ9i8?=
 =?us-ascii?Q?ytFoRJebwYCvsvkQndaEwfslbxjV/1B5Axf9OiGvBnJSFd71grSrS07TrseY?=
 =?us-ascii?Q?CGNxjsRrr5gykA6HPNhveE5gaar1nMA3+Joekyv8IIx9l4JFsT86LFnT9nUH?=
 =?us-ascii?Q?+r9AjT71tiPfXHbkA7u9F+yAhtqoZy4M5dgseiVQC3APY01WYba7HT/6TJLC?=
 =?us-ascii?Q?ZB9CSAH+wgqsUQcrWm3Vc8ymYZHbWt1dH7vQ6w9VmZ7hodeWs8tEj8VxLM6g?=
 =?us-ascii?Q?oBHihRTyB0Zb6H3rENFby5pvAywoCRjSqtsbfwTo8/KA3BP3D0eLVGFKrubk?=
 =?us-ascii?Q?w28jjUfS3X0a3pybFr4wDWC/+h6/eoce2PUvNRanJSTGLAEnU/p+fqGbP8wo?=
 =?us-ascii?Q?9VeUFtOBSL88RSIrij3dbkRLXWhQtpGwObJ+ak+LKq4uV6Mjt6vLlQIyTk37?=
 =?us-ascii?Q?09Cnpny6jAKMVw27Nw7C5p5mAVEuwIGxl2pSL98ybk1PV7o+P49a8DoueNde?=
 =?us-ascii?Q?R/pLSu+fxs9DtPqO7J0gZnNZmH3bgSRk/VvNWH6cmZX26EKKBKyf3vGxCzQ4?=
 =?us-ascii?Q?GpexEgPcSVUXzAxUUwIOBB7B9XDvyY6uX717OppMrNA4wY5NlpnqWLh/am8c?=
 =?us-ascii?Q?9nWFMRMgKL1Pz/cI+JZWgxTmkgg2PcRU3ZbDBGBhSWrrTOw7HqLjYsflsWWO?=
 =?us-ascii?Q?dodntWCUpGY4fqzlg+jPy3AxMiXosbfj3gzh4IxS9iHHhURg0ICOCdkwq9Rv?=
 =?us-ascii?Q?MzPConXdu2kqWx8eIOl2pMm0Q4E2UkeZTILGGuQkOFGMRMhSnaB2UcHtlgQP?=
 =?us-ascii?Q?oS9DNfveGCRKywqsPCHAJ+QpmwjHLxNqFSxriI12nyyplYw5seGrL71fYJEo?=
 =?us-ascii?Q?wwuLFbxnPjZs/DgxBLX5OnxukiOc2tV20ZWFs65qhi0Q46E4EhQ5HcTXgk6T?=
 =?us-ascii?Q?p44zVPQWP2u/cNY30fMNKHpInPzpFv8pcAtrj3u+/fqdual2xJyqH0PjYTE5?=
 =?us-ascii?Q?ZJICHF+60K3SotmdXIeFnKlW5pgZcaUKi8aOzMeZsBMSQJbDfyLQ+sAdGOY/?=
 =?us-ascii?Q?tF40Lcl14jzeTrixVj7NnrQrDnx23khdoQGlHd2BaEhqDfy+BOOODBVleMxs?=
 =?us-ascii?Q?wvT6vyKoLXWJDua8BqsNa9WfHK08ZDjtXkbsbFW5dPuuHErj6FZKyl6BM2p6?=
 =?us-ascii?Q?x3iVUH9WzWy4qgm3xxn1bUTA+fMxUFNeC2nJgAfMP6e82F/tn5eeISs8VDHC?=
 =?us-ascii?Q?xy83fOu7poX1lJoo81XSHafE0uernnFh0PLz42B35c+jJUfdp6IjJu0vt5JY?=
 =?us-ascii?Q?vKVGRdKkmipD+x5pKzkX2IDgXBBYYG3+4oEIJJd20nJWOG2ZT9X5j9PY0aLd?=
 =?us-ascii?Q?xVNulMMq4ohRSHrmUBvbgTcF98/45iPoGHK1bOAF?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d783e26-997d-4a62-2775-08db899bdc08
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2023 03:37:51.0506
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I1VjFA72j4zN/xacV2jM4x+ZfInVzA8WUeW4JG1nsLrajadAFUyLWk5pPGu53wgaL9HZX6U9jhGLkfZ+O/swmA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8070
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

On Thu, Jul 20, 2023 at 10:52:44AM -0700, Jim Mattson wrote:
>> And is it fair to good citizens that won't set reserved bits but will
>> suffer performance drop caused by the fix?
>
>Is it fair to other tenants of the host to have their data exfiltrated
>by a bad citizen, because KVM didn't control access to the MSR?

To be clear, I agree to intercept IA32_SPEC_CTRL MSR if allowing guests
to clear some bits puts host or other tenents at risk.

>> >As your colleague pointed out earlier, IA32_SPEC_CTRL.STIBP[bit 1] is
>> >such a bit. If the host has this bit set and you allow the guest to
>> >clear it, then you have compromised host security.

...

>>
>> If guest can compromise host security, I definitly agree to intercept
>> IA32_SPEC_CTRL MSR.
>
>I believe that when the decision was made to pass through this MSR for
>write, the assumption was that the host wouldn't ever use it (hence
>the host value would be zero). That assumption has not stood the test
>of time.

Could you elaborate on the security risk of guests' clearing
IA32_SPEC_CTRL.STIBP[bit 1] (or any other bit)? +Pawan
