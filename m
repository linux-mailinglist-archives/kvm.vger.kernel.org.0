Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 248DD6C6311
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 10:15:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230002AbjCWJP0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 05:15:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbjCWJPY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 05:15:24 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F91B1982;
        Thu, 23 Mar 2023 02:15:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679562923; x=1711098923;
  h=date:from:to:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=Ol+e0BQS+bBfUjMfCJRZPjqPBVSvdfYCHW/bhD/+sQw=;
  b=AMjv/HX3635SBa/je4qJ13197rtxoWdRGWCDIfGVZzZM8/1t3RuSYo8z
   Th1ONzL/QDPLyZ+dWb2kgAFJkB/ITbagrL/gQ3GEf+uMCUy1ldNPElqjj
   SOE99b0xMqzar5oXsRva74HpnbqbUyCdyKSXfVs37dCcsq1ZUZFbNPBKj
   9rRR/eVuBCXyfz/Qpr/YUYcye0rCK3rN5OsOB92XXmGPi/PK4f9VEm+Ob
   ATbt66upaXKNulDUGiLbjszBOSTbQPwy74UPq9VqEHUgHTtxJzrqrDGjc
   pjLuEFV210WCpCkGxt9lyap23sHEzBoomWbHV5iYCKjID3imTdto43mW6
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10657"; a="340976428"
X-IronPort-AV: E=Sophos;i="5.98,283,1673942400"; 
   d="scan'208";a="340976428"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2023 02:15:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10657"; a="712586682"
X-IronPort-AV: E=Sophos;i="5.98,283,1673942400"; 
   d="scan'208";a="712586682"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga008.jf.intel.com with ESMTP; 23 Mar 2023 02:15:22 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 23 Mar 2023 02:15:21 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 23 Mar 2023 02:15:21 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 23 Mar 2023 02:15:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=npLTMGsREEOxsjtrdvwSAyc0foK9gOgsBQQ5HgBsoZMKD0jMTHSqAaK8HMcaQYFNug+QLigxOF0gs4Ah4yqX7CXj2G8BFGHcSgOfKBCT+gdJuG5ENyW5ggs2YcT9UDfmsyalm4N1TZ7mMrN91uTP1R3IlWcPkGQ3aWqJaiHf7TM9Os6lVUGUfq66dAcFNn5mIt5BbclB5iG3NFzIbXCPyAD2XCHUazKufukWtWmvwOOI3F6HJb2PMt/1e9LB9bMpGMwL2CENnLkMQk1/DKHVnsOV3BlTcZIusnXcOftcZuu6BB36DQS6ttWrjSmAibq/drjdNZBv0CcLgfpL9Z1O+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C56y6LjXp8+7GJt5ld8yW+OfCD22PGgRmTHR0dwJuro=;
 b=XUJCcibGaOZSXMTV2ojC1UUoKI64lmbK+woTdWOq50s0FYGEcgWrHsQpybMjnUqY3/gOZyDiKV3PKJNglbe/5PacPriHh6VAwVXhfg7d9CGbFMhQHrKjb8G6RjRKrDI3cIm7b0ZuCbS6AklLg61HSlvxckutwILla+qSZBgsgNLXWcyB0XMX3uNoos3MyFG6/6tIkfNfhMKPhnoYXY85cxZjza74yVn0KfiglnF0C58XC1kqb0E1lQUUV/Y4QeDMpIMjxxNP9aw7f6bXCsqPuKqpQf5YuQOvjuoukgf6dTo0yR88OXLyBIC4zoyivVw6m1xA2yUOY+dQuRwebwaHqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SA1PR11MB7130.namprd11.prod.outlook.com (2603:10b6:806:29f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Thu, 23 Mar
 2023 09:15:15 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::b00e:ac74:158e:1c7e]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::b00e:ac74:158e:1c7e%4]) with mapi id 15.20.6178.038; Thu, 23 Mar 2023
 09:15:14 +0000
Date:   Thu, 23 Mar 2023 16:50:24 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>, <kvm@vger.kernel.org>,
        <intel-gfx@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
        "Zhenyu Wang" <zhenyuw@linux.intel.com>,
        Ben Gardon <bgardon@google.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        <intel-gvt-dev@lists.freedesktop.org>,
        "Zhi Wang" <zhi.a.wang@intel.com>
Subject: Re: [PATCH v2 25/27] KVM: x86/mmu: Drop @slot param from
 exported/external page-track APIs
Message-ID: <ZBwS0DNOwMf7OVmV@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230311002258.852397-1-seanjc@google.com>
 <20230311002258.852397-26-seanjc@google.com>
 <ZBQkyB3KJP34D9/h@yzhao56-desk.sh.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZBQkyB3KJP34D9/h@yzhao56-desk.sh.intel.com>
X-ClientProxiedBy: SG2PR02CA0106.apcprd02.prod.outlook.com
 (2603:1096:4:92::22) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SA1PR11MB7130:EE_
X-MS-Office365-Filtering-Correlation-Id: 3f99932a-e2db-4b67-79b6-08db2b7f1ca8
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oAn8gyPEVprPV3weWZaGqFrwdHazSzf8HLt2RJbbhDIE7Rn90wchJC+RwWgeoc8DUAqekxfJdwwMPMvdVg5ITvpNvD9WZxiG2RgLYhScbaKzI+k3AsUKNnoYYzpiym5cyNJeIUwPX9kvgKbR2aKr8qnVhlcE/cYueVcS8pSkOeXMioiOkczGtRLf9itcbIVZEsYGjqStsBPNyouzMLt1zdH5Xe0iZBqI661wERgeRZ8inEKVr68LUOiGstYtv/Yc3DD1KsG0VYkC+P6hM18ZftLnGWmP1Faknwky8D7U3sMQfc4GZa4kipwZ8xo8/XDhtFLKBW2O7Ed7Ci7uWd0xCQT8REpHpl0OEmQq0fA3j0SPYSeV/lrPRUJWaeKJuPMhlg7Np6v3yGHdwyEWJE2f2O9Qn+MkYE3bpdvzzXN4cSXAymqCN8UISpQtlQyoDT6or8pFWMVvdkE3NYdVn4NGT1YnN8s0mRcjwvzjW3oK3yphz/FUnKIhEICMtHHcslzBaxLOJLRkHXt+4236F5TYF2HCqfumFMO6Mcgg2Lzob9BZaF+7jGFbX5Q+0FuzClLpG/SgF0dhrjTWwWEI8Yoh7COoaWper34STEkwnSLuMSGE8ywNK8cUEtwwJVYBsypXINfNLgmiowp9Gv6TPTIpbg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(346002)(39860400002)(376002)(136003)(396003)(451199018)(6512007)(83380400001)(26005)(8676002)(186003)(66946007)(6506007)(316002)(66476007)(6486002)(478600001)(110136005)(6636002)(6666004)(66556008)(41300700001)(82960400001)(5660300002)(2906002)(3450700001)(8936002)(38100700002)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?s8RoL6UXcxtKTGPeWIZ/Y1I/cYlYEkKv2C3DkVFPKaS/kuMWQrBN5HfB2BUO?=
 =?us-ascii?Q?g0L4y3/UTx2rbEW3TQayZeSy9V10Cx1alei47BAefJNCuw/qo56qcuDUGG83?=
 =?us-ascii?Q?s7hys9Ad0bZPUsKL9XFukRi0Sj4x+caSkplPH0B03Md098f9B8MLWTk8iKs0?=
 =?us-ascii?Q?pL6pXvQQnwvIFqJF6M4Yz2+cnI//mnu4ZS4k9xL7KLl2fs5UFIcbkw7MZdTR?=
 =?us-ascii?Q?q3Z+QGRvNNJq1vJUdqMbKLRjnl5Gv1jbv5ZbYF1QPme+3jc4B1sMopqC/VvC?=
 =?us-ascii?Q?Ewxn7Bk3BH7LlQ0ezFmnEFSulkmqikRCpohKjcEoQaJOiDn+4P1GmHDcr8/T?=
 =?us-ascii?Q?VcPfazRoH8MUs35UeZcnBWw3fiQn6bI/GUvO/OorN3bH3cowiBNGQmAMelSw?=
 =?us-ascii?Q?7TeqthkIx1S01aNvLrppdj6Xx5wSBfm7H3jy0VkgIOMnKkXXSpFYTKkK8wVj?=
 =?us-ascii?Q?2ToGHtvOlwdb9+ZuFR9Lqh01WSaA8pOSl9lNpwH2Cb2anWeY2wYEYpGtDBRY?=
 =?us-ascii?Q?su1gvNoIt9OVG8pCygiXbj0lvl8nOh8EqYEtt9skI96XF96mlnultf+UuQjX?=
 =?us-ascii?Q?IiznzspTgd4GBZZTniDSjQ1VFY84lXQ5B5opU4QdUh5gInuEWg32HNuoQtLh?=
 =?us-ascii?Q?oF4GOMVdsc3KWS3+K3EpkU7O8DxdYcAl9O5bkdTFdDqP1SJdOtyTyX7Ndg7Y?=
 =?us-ascii?Q?ZvxSHkg7TRbcQcs/OnY815cgD5S30RhDQZbDU5D3HWPU6vaQ6xp8VOTi1H1Q?=
 =?us-ascii?Q?uy0u40uynCZGdpCMCvtOxFBpyalR+tWGyECkEKk2PKxtlBBJTZ3m6A0hcvHf?=
 =?us-ascii?Q?AP26sKSlhyuda3dvXJ65oUfii+nZaA1wxEcQ/H3zVzWF9J8ByNYBx9KKNudN?=
 =?us-ascii?Q?KA/iqWrSlhId9K1U8H39yt8dbt6Sunu9zPooqNlwEkKOidXOaUqRVDXZXKml?=
 =?us-ascii?Q?uxAxS3HkV7AvH5rzFgYn2RkhY9CY/FGIDao5bTgRkPTXyCH5Elp9rWLNaxih?=
 =?us-ascii?Q?zkpbhLf+BCC4LIrNytwGWy4ul5RQ3HR/nxxH79zN5Annr+tEUheOiPKc0/Bz?=
 =?us-ascii?Q?ODRrCvQXct5RzZT6RlgLtIYmgLVkzv+1M6B5PP4MrahHxHi8hyrKYBbQ4l34?=
 =?us-ascii?Q?Jolk5a5La2tZTWW1+fiImjfdV6HHjASKGu9XBFuU6213a3zjWd54Aw6eTqUZ?=
 =?us-ascii?Q?FqvJMW/8IMmJado9qKChQHE8tc77rBNNF8/0jqRf1yIwAwNUNp3lKTt7RGec?=
 =?us-ascii?Q?iXT+d4toBFzyjhv3Or/tDRSei6RG8eukWonBSnma8BRtmS4MOWOCRXz4Eybu?=
 =?us-ascii?Q?qtCWHFlb5Vfj/FMIjfmDpIrZdYmJTUsCeBK0JeilQg+9EBQACMTp38sg4Qh8?=
 =?us-ascii?Q?eYD9FC33CUOU3bnY5WvSP3HR4HKVC0chmlhtjhQ5XA9tn8HcygVtX6BkgbiV?=
 =?us-ascii?Q?xudalaGU2A4B8udqnVnyV7Tx8QDclsWVgXPOMD9M32nCvVCnSd5+YIbfLs2Y?=
 =?us-ascii?Q?WwPiM6ppglb8/5kK2M0AzNxWnrfRbVe0OgxuJGUzSmRNvNMytnJP/cnmkDBC?=
 =?us-ascii?Q?gzmlP+6nZqWw+OYBjBWNxf1pL5rPhrWPyjjF9YSMfv8MmqSCDRLLinpcuIQI?=
 =?us-ascii?Q?KA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f99932a-e2db-4b67-79b6-08db2b7f1ca8
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2023 09:15:14.6744
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: avj5XMDXIoZvuJhDjhlTV2eY4Esd+RV1XywZ79pdkMYau6HaIJsM7tvnnm77rPQtVaUzKfvQtmNykQyHO31kEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB7130
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 17, 2023 at 04:28:56PM +0800, Yan Zhao wrote:
> On Fri, Mar 10, 2023 at 04:22:56PM -0800, Sean Christopherson wrote:
> ...
> > +int kvm_write_track_add_gfn(struct kvm *kvm, gfn_t gfn)
> > +{
> > +	struct kvm_memory_slot *slot;
> > +	int idx;
> > +
> > +	idx = srcu_read_lock(&kvm->srcu);
> > +
> > +	slot = gfn_to_memslot(kvm, gfn);
> > +	if (!slot) {
> > +		srcu_read_unlock(&kvm->srcu, idx);
> > +		return -EINVAL;
> > +	}
> > +
> Also fail if slot->flags & KVM_MEMSLOT_INVALID is true?
> There should exist a window for external users to see an invalid slot
> when a slot is about to get deleted/moved.
> (It happens before MOVE is rejected in kvm_arch_prepare_memory_region()).

Or using
        if (!kvm_is_visible_memslot(slot)) {
		srcu_read_unlock(&kvm->srcu, idx);
		return -EINVAL;
	}

> 
> > +	write_lock(&kvm->mmu_lock);
> > +	__kvm_write_track_add_gfn(kvm, slot, gfn);
> > +	write_unlock(&kvm->mmu_lock);
> > +
> > +	srcu_read_unlock(&kvm->srcu, idx);
> > +
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(kvm_write_track_add_gfn);
> > +
> > +/*
> > + * remove the guest page from the tracking pool which stops the interception
> > + * of corresponding access on that page.
> > + *
> > + * @kvm: the guest instance we are interested in.
> > + * @gfn: the guest page.
> > + */
> > +int kvm_write_track_remove_gfn(struct kvm *kvm, gfn_t gfn)
> > +{
> > +	struct kvm_memory_slot *slot;
> > +	int idx;
> > +
> > +	idx = srcu_read_lock(&kvm->srcu);
> > +
> > +	slot = gfn_to_memslot(kvm, gfn);
> > +	if (!slot) {
> > +		srcu_read_unlock(&kvm->srcu, idx);
> > +		return -EINVAL;
> > +	}
> > +
> Ditto.
> 
> > +	write_lock(&kvm->mmu_lock);
> > +	__kvm_write_track_remove_gfn(kvm, slot, gfn);
> > +	write_unlock(&kvm->mmu_lock);
> > +
> > +	srcu_read_unlock(&kvm->srcu, idx);
> > +
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(kvm_write_track_remove_gfn);
> 
