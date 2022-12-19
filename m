Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88C6765082C
	for <lists+kvm@lfdr.de>; Mon, 19 Dec 2022 08:49:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231530AbiLSHtK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Dec 2022 02:49:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229957AbiLSHtI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Dec 2022 02:49:08 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 421063885
        for <kvm@vger.kernel.org>; Sun, 18 Dec 2022 23:49:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671436147; x=1702972147;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=9GfP/kaUXyDU/xuGB8UZ19nmioZpGE56HcA+qLWnLCo=;
  b=HawC/Lca7XYFvDraSWC0pAU5kHigR0i0TRMgEIII8msU8oZARWGAGTIU
   pbhoF4sPx8ZidQWff8Y8GDqlEyYXaTv8ejTxtWlO30veylmSEj3fkfjfI
   lJgQP2I+nYnJ2rmOgzvR+bzdqcbMD+93i4sDVqFBcjFIgqabr7/F6CikM
   hLnufwA81Ivc56lhMetuzSaK7u230sL0RY2QL098P31aWPejHMcHNgZpf
   vTvyZiMA9tAzWU76sf+xbU7NeY6mAG2QScXbDJVIqKVm27UZpLeFaTYmR
   Ryq/onCEht4Hx68TFwcoY1NlTmnFy9zNT9y48zCV65uII6MWyH8rEqxDy
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10565"; a="306968594"
X-IronPort-AV: E=Sophos;i="5.96,255,1665471600"; 
   d="scan'208";a="306968594"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Dec 2022 23:49:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10565"; a="652602322"
X-IronPort-AV: E=Sophos;i="5.96,255,1665471600"; 
   d="scan'208";a="652602322"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga007.fm.intel.com with ESMTP; 18 Dec 2022 23:49:03 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sun, 18 Dec 2022 23:49:03 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Sun, 18 Dec 2022 23:49:03 -0800
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Sun, 18 Dec 2022 23:49:03 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R0GX5ldFnEnIlPrW+fkYgna4F0g5vII7hoQCjCXRFYf6pMyaaSM96nFqxaYcYYvR8tinvmSvtV+Wmok6Or3OQUsMuWYe1BO8BVzQdZ9M+Jjt7Qi+F8zUasdAgiN/P7da0k6ftv/ztR/skdDBluxcwmkl4x4nqLR7e/jFa+dvveQWmnZL3b89vSgNXBefcjwnwGta0DEtLO3ar5YtvvHI+B9D0/aCs+cBtAfCpRUSLNxhpF8oY36xmchnbGWGSa/qMRkGR2L+0PhGMYjHYhrkKj8cN/w8UO4I0YW2/1cuHv/ZCqnblVRo3rnlkfthFwfV1sK95kEWGeF7OzZxbzs0+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T1nIw1vageV1M4Tq+7VmhAIfzhMOLc0CqCAqRT9McBo=;
 b=VkIQ2ZmdwkZGvuP1ppz9rR/155JZKB+q/AtvWwAAsVABNvrAoomA9TRvoh3czAZJfYi2VJrtrZsLfOvewbqE1rxH2LcU/ZU01sPpBTZWC5ourgyHRW6m/8soOWkbeFzde6s/cMHUHGlaK3NC3RoFDj3tob1B1/Yydp5eYJ4I7TTvKPmfhbYojblDu5N09vSK6wM4Q7gcpT09oXznNvck8rfeK2hv5oUlbedhnMiPk0YgihIbO81jegTcrE8aiZbHgVWYFDJVPtuzm1dvyH0dp3ekMo5r7w6vGGkhQvsut+eKXyoc3Q05wxwaxz7wWM5uOkSREKYa5ZyDEFvHbOpPWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by PH7PR11MB7551.namprd11.prod.outlook.com (2603:10b6:510:27c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Mon, 19 Dec
 2022 07:48:56 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::8032:d755:9eed:e809]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::8032:d755:9eed:e809%4]) with mapi id 15.20.5924.016; Mon, 19 Dec 2022
 07:48:56 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Steve Sistare <steven.sistare@oracle.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: RE: [PATCH V6 2/7] vfio/type1: prevent underflow of locked_vm via
 exec()
Thread-Topic: [PATCH V6 2/7] vfio/type1: prevent underflow of locked_vm via
 exec()
Thread-Index: AQHZEX9X04d51i2VHE+S4jt0Pq2Ivq502LVA
Date:   Mon, 19 Dec 2022 07:48:56 +0000
Message-ID: <BN9PR11MB5276E8FEF666B4E7D110DE278CE59@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <1671216640-157935-1-git-send-email-steven.sistare@oracle.com>
 <1671216640-157935-3-git-send-email-steven.sistare@oracle.com>
In-Reply-To: <1671216640-157935-3-git-send-email-steven.sistare@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|PH7PR11MB7551:EE_
x-ms-office365-filtering-correlation-id: 7b8c47d8-2df9-4d5b-7292-08dae1957b67
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: l9NsrMXuzPBS1YnzuNgOAFW8p2gB76gNsQzqT9qN7lk7FuWGtrR4AUJHssCv4OPVUc5ymQXQZGeo9QKPIzIpTFs24xvSTJkr0Bq62hmdXra+A+GHfc1D5p/scUTc/DDWa91ObzqYr59XMhIjq2SzNFBWX8Ad6Th24Zj8aaIWWzb4iG4qH8bjaCZ4Ap85wp8p5gwOYAb4IUIuwJ396K0rhyUZx4ZJq4f0xD9VqE9dG9zHVfVtcsWJYq6Fx8G5wg1r28MA11qNr8UImA0biYYmFvKQ8hSh14K7knm2VWRnSj4RugfIKvjdrlG9ABAks+SDmhUmnMde8bzXKjcBpiNrxVugB8U4SirNIZI3Q70UB+hXeS0phPE492YRcGeUx4xn9aCmHCoPhVu0xkNl+M5z4S+tyyzacq+7zQQIEqwGPn1mssyaAEUWYEIxZzbp/Mop0cWG4Yyg9t0w4F2k5wBsZWik8+MHuv7n9A9IP9ec8YuABsGNbfGNl4BzSlsmQIZKrZ0FcqV1CQAMyg5rTPfgRT8rjDyK8pFpoy3O+PuUlO240X1FucLJUreFLjIHmXaSE2b/QdATlUBQGTjCwcQb4ekZ3Estu3nZIjv1cos90e51xzBufo9pqNdO9undFSiFkE99jylKquxdFQWwxexKr4RIHMMQCP/YDSWYveeetd8PW3zQNDKOFLUcQPfwU+FzF0kRphfYKV5ZMQ8sNx4a0w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(136003)(366004)(376002)(346002)(451199015)(83380400001)(86362001)(55016003)(33656002)(122000001)(82960400001)(38100700002)(8936002)(316002)(38070700005)(54906003)(110136005)(64756008)(66476007)(2906002)(66446008)(76116006)(66556008)(66946007)(52536014)(8676002)(5660300002)(4326008)(26005)(9686003)(41300700001)(7696005)(186003)(71200400001)(6506007)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?9jmXyaskdFnF6rMz21o+fFrhaguwopNThAA/7xd7CyzEyctppNbknXDLkFAF?=
 =?us-ascii?Q?HYMcVEMQGca2MvJBIxc7hWiTYlKTVOppotG1TIXEs3B/7q6jTq0LKQ2KNKqV?=
 =?us-ascii?Q?DAye7cvbfgBWs2suUkcIu3eK0oCucY7495kPQ5lEseT+r/yggqpHyD/JMD5J?=
 =?us-ascii?Q?xUYmv0YEHQ1BrgSiTjGnezGTgQRqD6zIkL5ZzPe7AZz8UM63aZogJddabvKv?=
 =?us-ascii?Q?kpun7pd8s8qTId3nIFMdYV4OjEaG0H1UKv6Y8J/z+BnompG2VVLPqq/bQvGI?=
 =?us-ascii?Q?gLLNmdKzmX+DPa+hJcgzTGWwWYQE17sM3bVhtx/+wdw1KSko+/XP6PkWBW8A?=
 =?us-ascii?Q?jOYpovWJqXZ3LJpLDAcnAzzgzGpuWAtNajAWdOhgj8Uil6LRzUHTwsRsx4LK?=
 =?us-ascii?Q?L2hHryikF5uHdtSO/ydB0CtOtenfjHKZM5ruJAZOLKVnm+E9UCYYg6xhPZhL?=
 =?us-ascii?Q?MjPYRKHDkLL5gDGNj/lWe6dABfJ3GVwkjY/Tg7tF5fh5o/gI7zVo+AN3q/cU?=
 =?us-ascii?Q?uBJROkD4zPvNExX9cYoQFidxprq1CTr18nUtEWwHsZJxudJ/mHZk7GzQ066X?=
 =?us-ascii?Q?mPtQg+ZOCV3/qmwpgL9dcHGYPUDNbygEq5JvzqNSrGqosdv26hnXMi6P41/R?=
 =?us-ascii?Q?hHMoUpQ6KTQZ1GmHhCJpbOl0hB7Krvho0eGk2PfRygDRYQrTQHK/UMNyG3Bz?=
 =?us-ascii?Q?ekOJYxT+c6i+lbI/lbEkMWG/AUu83XLpa4UsSUiEEsGKmn/pF1eHYhSo5HYw?=
 =?us-ascii?Q?HW2/CdEmE4Ond6TLRzd11UnAR8JOCzWHYbyzaAAiZrxSKHdUjr81bOZL5PH0?=
 =?us-ascii?Q?IcKpLhYa68yEBQJ4TMgRgr81ALvIBWFlshJsyd+cQr2UDM90h8VBT7oClOyr?=
 =?us-ascii?Q?Yfb66DeJq1BmKhe72Ozhjf1pCMPgR1t/qVc+aEg52CCOxZL7Y8HtAJqCk5Ks?=
 =?us-ascii?Q?qSR9N6JqnZL2LFSGiKhccX83nOKm+0JiqbFds33bYI/gn5u7TSyC8DT4JlUi?=
 =?us-ascii?Q?GfZTw+W0Wm2nAKsU1hQvrtuzSDo7G7iwatJMSfMw8ttQT7mUaGM161oCy4B2?=
 =?us-ascii?Q?tGyriw2CzXgCPdbQMx83s0jpLY9f4TOQ11j6VGXUHVapKDhZBeImNjDRWjQu?=
 =?us-ascii?Q?f8PFE7jSaDC6/cGx3QYD1sQyymJpFTC/wNX6lCdVPUaFsuqHeQXKj2R5xF1a?=
 =?us-ascii?Q?3V/S07T+DsA3olmeiGm3LM9Y5NfmUpV8g7/O1K8hHm2gMnPHtaqrfYw/Og8o?=
 =?us-ascii?Q?G4tpapQhC3TsP8pGkodPi0hQLjjDMvQORuahx6MU21U6mJ+gbvh+CQKCQ4I8?=
 =?us-ascii?Q?InV2ECWBOXr/xXUtuFldlmipdr1Cycq6t1551vGt1cOp73YBtaSiiKQRrVD0?=
 =?us-ascii?Q?rLcJ/sSSjRUBas+151bLgrowCpga85dp+/RtWfnuPvGjNRSG6IlX3QV36e7I?=
 =?us-ascii?Q?4OmTiz30Ae8JXV7yr1YnFCJtMbqUba3q/6YdLvcizkK/69c+aCEJKPfT+X38?=
 =?us-ascii?Q?EZT0dc3royO36XvD/gZbcburqrHaAtYrRkBG0jHB/R2k2MlsaN7v+ibEDCRh?=
 =?us-ascii?Q?iGB8ZUgPr9UK5Vx4UM9lQGOcPzB8+Ml4H+wZ3C1N?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b8c47d8-2df9-4d5b-7292-08dae1957b67
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Dec 2022 07:48:56.2944
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3+OPcoVui4E4qFQDrnY2D2zow4ftE3cjAhn/F0OCk/T7yQUrG+XIxCHzi+0dLyFqv/uOMu7O62OiO/M5jWbXiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7551
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Steve Sistare <steven.sistare@oracle.com>
> Sent: Saturday, December 17, 2022 2:51 AM
>=20
> When a vfio container is preserved across exec, the task does not change,
> but it gets a new mm with locked_vm=3D0.  If the user later unmaps a dma
> mapping, locked_vm underflows to a large unsigned value, and a subsequent
> dma map request fails with ENOMEM in __account_locked_vm.
>=20
> To avoid underflow, grab and save the mm at the time a dma is mapped.
> Use that mm when adjusting locked_vm, rather than re-acquiring the saved
> task's mm, which may have changed.  If the saved mm is dead, do nothing.

worth clarifying that locked_vm of the new mm is still not fixed.

> @@ -1664,15 +1666,7 @@ static int vfio_dma_do_map(struct vfio_iommu
> *iommu,
>  	 * against the locked memory limit and we need to be able to do both
>  	 * outside of this call path as pinning can be asynchronous via the
>  	 * external interfaces for mdev devices.  RLIMIT_MEMLOCK requires
> a
> -	 * task_struct and VM locked pages requires an mm_struct, however
> -	 * holding an indefinite mm reference is not recommended,
> therefore we
> -	 * only hold a reference to a task.  We could hold a reference to
> -	 * current, however QEMU uses this call path through vCPU threads,
> -	 * which can be killed resulting in a NULL mm and failure in the
> unmap
> -	 * path when called via a different thread.  Avoid this problem by
> -	 * using the group_leader as threads within the same group require
> -	 * both CLONE_THREAD and CLONE_VM and will therefore use the
> same
> -	 * mm_struct.
> +	 * task_struct and VM locked pages requires an mm_struct.

IMHO the rationale why choosing group_leader still applies...

otherwise this looks good to me:

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
