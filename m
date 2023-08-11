Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29CF4778713
	for <lists+kvm@lfdr.de>; Fri, 11 Aug 2023 07:49:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232898AbjHKFtZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Aug 2023 01:49:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232788AbjHKFtY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Aug 2023 01:49:24 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC8532D52;
        Thu, 10 Aug 2023 22:49:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691732963; x=1723268963;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=F0KyBAsh/yPpfpxlIJ0N7vvCJyOiEO1TPChGiALt3yQ=;
  b=mjMDsgwB0+FF9vwOdHNpp3z6Su8ATI68cLYgf0rnxd0AAS971b93ypzu
   929JiVG8iUBPhz7iwm1bB5kGDsbZrn8mEzzsXIle1Nx59/EPn+cRNDYL5
   6+SQ+n5nCphgX74aHjsRtbYzEQ7K8GSlOrShXtVDdw13iVeoDlwmJ1jDq
   Ojz8Zi9THfLysHmopYw4NjsdBH9qONoDDiuRlYi5n3OQ3xeS0k2Y2KD1S
   Zmjn7vCXLJEgNrgCdDg8gZj+qdtPrIbzjyaykUufW8q7Eq7fVzZxsFWTf
   VsgZzmzcc0FtfwML4k7+lB/u3V8IzVZb9hPBsAWbwRzFzZXE07yTY20Zd
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10798"; a="369072417"
X-IronPort-AV: E=Sophos;i="6.01,164,1684825200"; 
   d="scan'208";a="369072417"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2023 22:49:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.01,202,1684825200"; 
   d="scan'208";a="876037972"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga001.fm.intel.com with ESMTP; 10 Aug 2023 22:49:26 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 10 Aug 2023 22:49:23 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Thu, 10 Aug 2023 22:49:23 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Thu, 10 Aug 2023 22:49:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eI48cpOHdKSY5m673bURNTdqHpzuMJDV7QpaU3qq76XkaY/nt9SBmOqLp4AmwhebJbs8yI7/OD/EBX9KdEDgx0x+lvgqLPuYgLyC1yF6aOsWCTQ0jYZDXZUDDBpiFkhmnfLmFpuqPsh2vSFSAYyMa3pjQh32I8SnHiaXxojBWwMijj7RrEUsbllO+7DF0V9/fOfcxQKVEuButYMNfjpSCEBCSLJViQ4ZtYTNX+sMVaJvCsNcUfa3kvMnzNKvpRCkGvar/e+kAnNPZkqAvCJGhtSVH6tl89DX/k+V0ePf8szcps3BRVU4qcDDLsbI5JMM7KTz2pClkRGHAC6Hzf8wqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E8LB5rOySyBBgdWvBzuhDQibnFtQRwHwEEOYTWbcbwA=;
 b=Fyunw8UsZYsyt25V3ct1ZFr8hxmHHRf+CJ8MBQJaVwLZYr42Ic66kX5iiSw9xXSquGolBnvUTcxrEFMeFlq6eAzCZXl7QpuritZu2LvPsbRZ35u0cYFqGODK2j8mX+Cgg2k4sLSxVDMjlXKqiwYXZS0d0jsm05mzTgMCiG1aI1BBucz8CSCbQQHbbbgCgXL4HAvMeW94/wL+clPtBCAG5iynAb93xfdHVP1DPVab0QhSEkPICF3aq9kM86Nt+GfW0Bp5Xcp2Ptz551ivdXrCsnFYVVCkerkN/ljrMNarQoD6OQbUAm2pVD/jEKF1AIZJAl+7LFkm+Zv7HNLMhL++EA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CO1PR11MB5138.namprd11.prod.outlook.com (2603:10b6:303:94::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6678.19; Fri, 11 Aug 2023 05:49:15 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::1b1a:af8e:7514:6f63]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::1b1a:af8e:7514:6f63%2]) with mapi id 15.20.6652.029; Fri, 11 Aug 2023
 05:49:15 +0000
Date:   Fri, 11 Aug 2023 13:22:15 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Chao Gao <chao.gao@intel.com>
CC:     <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
        <mike.kravetz@oracle.com>, <apopple@nvidia.com>, <jgg@nvidia.com>,
        <rppt@kernel.org>, <akpm@linux-foundation.org>,
        <kevin.tian@intel.com>, <david@redhat.com>
Subject: Re: [RFC PATCH v2 0/5] Reduce NUMA balance caused TLB-shootdowns in
 a VM
Message-ID: <ZNXFhzwWIGAI8KP2@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230810085636.25914-1-yan.y.zhao@intel.com>
 <ZNTtExiPZx4b180d@chao-email>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZNTtExiPZx4b180d@chao-email>
X-ClientProxiedBy: SI2PR02CA0027.apcprd02.prod.outlook.com
 (2603:1096:4:195::14) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CO1PR11MB5138:EE_
X-MS-Office365-Filtering-Correlation-Id: 3a058e89-e44a-4cde-9870-08db9a2eb225
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bXUJm66sDudUO7AxN7mLenwigtL+NtfNNBCnsbarviBcV7C+zCQ99YawiKnPr8PpgOkyAV2Z7tj0sbeo4n4KHcK4XgHDDmB5rVEXaID25O3BsqmbCV9q9a7FAeKKE2lZJWrmYSNU6dB8tpv4L41FxmBCuS79tPV3vCWQqpQJVkcoSpw6l2ZJHEn2Hh1fy0aYD/PUXzOXU6PN24Y9yZXzjUYMewwHtlIEYF8jfbaOsZSWT/075gUjYYHIbNGwEh9VReG8wyXcwt8+lS12j394mgIY/hdv8Ct6Z8XUepA/eP1EuSJPkwLOT/p/V91BBxc+GjsaEmW0u18ijbM2h6Mok5JYhjCsRoW0ga9HwGyXOLv7CXyCklo+BD6yPnGb65jpSTKEn6CUAVoSWJ1e2gHYaVuPTNbeAAOOgV68fp9sKWZmBWpnT/CRTcTUd5ujNHSPD2L0PGgRP1rdHkEHRHK8YNk9nsApUkxNO98IK1/fJIUHLWMDCsQIw4zKG1KBitrFJmPDhpOipWh/PTDWX83I7Wev+Hm069w9ZLqIyJNNro6v2+uBFmbO8EVu9teuVNKk
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(376002)(396003)(366004)(346002)(136003)(1800799006)(186006)(451199021)(66476007)(66946007)(66556008)(4326008)(6636002)(41300700001)(316002)(6506007)(26005)(83380400001)(86362001)(38100700002)(82960400001)(6486002)(6512007)(478600001)(2906002)(3450700001)(8676002)(8936002)(6862004)(5660300002)(7416002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?phQigCwxc18JFkSYe6Cj0fgccNiPPsG6p/a18Geew76jd3qd2BQZqvnbdcVo?=
 =?us-ascii?Q?REagu0SE4O/j/BDUXa3YQG9i0aJuH4o+/DizH60BG+LMHbD4iz/3GcqqZU/4?=
 =?us-ascii?Q?g7TsnTi29mDH0tpmjpk0eELhfgxsfcrsWDs+O+ZRO6/LF36CKdO91UbuOitU?=
 =?us-ascii?Q?YZuCDuFUv3NjhswKCFeCBFW8ffnkV89yc20zsv8gmyt4beWP0gJMJib+m4kT?=
 =?us-ascii?Q?RwcWCjRrCSkc791qgTeeHq0IbiljFP/Eu4hBakEgzzdmY6GVzLs6d4v80Rjn?=
 =?us-ascii?Q?rBGXMz2hpUGu1v8Tj2SVN2i0jJRVpmQcNbB/nfrEs4WjZkH3ZTsIbeeDuwiW?=
 =?us-ascii?Q?57a+2jEqZ0CkjQe2tQieuEnA1UinfeLrQ3UqjiTdPOufLGTuty+DJhYGxw3T?=
 =?us-ascii?Q?oEIdMVUD2iBuxrDIPj6CRCWqIasFt0ox5GyFTMpzu0Y1Fai8w33cn/K/AwWr?=
 =?us-ascii?Q?lVJvwJUnUjZxjgAjt68xUKyW1WNfPhqDS2q1OgvkJiEqxiVInKudunG8Jg2K?=
 =?us-ascii?Q?UEFCfsWkeBm0kvDsc9WuT7soXJIQfyMd4GA43uoygoQVym1hnsUPy0NRNson?=
 =?us-ascii?Q?NI98W1OzKbGmAklre1pXS3mr8cq86TxBXtUk4HflJ5B+YmFw1iAkLr/i+Srh?=
 =?us-ascii?Q?9JGKRhu4eR1tJUCnyDR5l4ZLVhJdAOc4pRRbBV9U+d5fCSbyZlZUUPaUEC/T?=
 =?us-ascii?Q?sKEUMkhb886n/s1SxSRRbltdr5sfSQ+9N+KXHKOlLScc2on328apgq3cebks?=
 =?us-ascii?Q?YzMkRH0EGTMFkyGBmx9R+eVgwe97UVAwu/gTN7Cr3t/HzNmZVXF4tJ65p7Fp?=
 =?us-ascii?Q?rTfmUU8EYOgkXKpL9TgWzL84oQ6PnqWpZ9YpkI4WjuV1ViS7uJ++2z/iQSr6?=
 =?us-ascii?Q?k2NfTKkqPxP0r6VGsHuZ3spAyNnYNs2zIQ5JfMQGgaIGj3n0D2Vt9zbV6Xwz?=
 =?us-ascii?Q?QQro5Ku54j5U6efii7hazods4kUgRS5pVnByc9D3ajWnD/GLwWuFbFu3nzYy?=
 =?us-ascii?Q?gh0BmuTZPLbbpyk8jH7erq4e3JDBDki5AXNkqM7CQjzG6OkIpIMInINSWqKD?=
 =?us-ascii?Q?ywv312iWu7dsAza9JlSb66dEcRP8XIxHX62+QwYjUq1GSpXEnINCClEi3mQ/?=
 =?us-ascii?Q?PcQ5kumyv/jBStXJPcwiv+D4hdlSGv5y1ANp6jtJOVPCJ7YzYTxnGxMwLVfA?=
 =?us-ascii?Q?nJ6EKNSEWZLVeeyf2OlbSdjlpgeJH1HPuha+Jju2My5PDpsrWaTFJanY6FAa?=
 =?us-ascii?Q?iTLzBjYvKHxH7Tc3g/ehgUd3JpayUFOP3XA/HQwvCAaVCALlFJDardxz+GMF?=
 =?us-ascii?Q?pdqFd93dbpw7XTEyhfEuK+2N0a4Cf/eL2huIb+huM1I8OuL7C/wl84M/TswS?=
 =?us-ascii?Q?4oF6nm3FovCbfUFm7z70+MN0ltFjygqMuMUPvs4AQQpghE/Ms/5J+S1Bo5nE?=
 =?us-ascii?Q?pmlLOEN4fFcIrM6kTkXIx4fz5sXgcfxV1qjIExG/eulreakyP/ljgQFBmsSa?=
 =?us-ascii?Q?kjmg7Tz2Gc13vNrMXcl8zDEO8o49UtcAGg/m0fxY0EmMDE6Vs4yOtghXChb0?=
 =?us-ascii?Q?B6gh210FPhjKpYCG9o4qNbV1t7W4K5YLNYe0MghY?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a058e89-e44a-4cde-9870-08db9a2eb225
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2023 05:49:15.2402
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UFufpkBpKxSVFoqVZ9UL/ATydQrkn+VIYuJeoYRXR3XVFAdLbxS86wfhSACk5WDm8sOFq+lh4Ojcna2C1SfJQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5138
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 10, 2023 at 09:58:43PM +0800, Chao Gao wrote:
> On Thu, Aug 10, 2023 at 04:56:36PM +0800, Yan Zhao wrote:
> >This is an RFC series trying to fix the issue of unnecessary NUMA
> >protection and TLB-shootdowns found in VMs with assigned devices or VFIO
> >mediated devices during NUMA balance.
> >
> >For VMs with assigned devices or VFIO mediated devices, all or part of
> >guest memory are pinned for long-term.
> >
> >Auto NUMA balancing will periodically selects VMAs of a process and change
> >protections to PROT_NONE even though some or all pages in the selected
> >ranges are long-term pinned for DMAs, which is true for VMs with assigned
> >devices or VFIO mediated devices.
> >
> >Though this will not cause real problem because NUMA migration will
> >ultimately reject migration of those kind of pages and restore those
> >PROT_NONE PTEs, it causes KVM's secondary MMU to be zapped periodically
> >with equal SPTEs finally faulted back, wasting CPU cycles and generating
> >unnecessary TLB-shootdowns.
> 
> In my understanding, NUMA balancing also moves tasks closer to the memory
> they are accessing. Can this still work with this series applied?
> 
For pages protected with PROT_NONE in primary MMU in scanning phase, yes;
For pages not set to PROT_NONE, no.
Because looks this task_numa_migrate() is only triggered in next page
fault when PROT_NONE and accessible VMA is found.
