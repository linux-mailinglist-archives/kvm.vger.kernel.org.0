Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBA3D788167
	for <lists+kvm@lfdr.de>; Fri, 25 Aug 2023 10:01:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243243AbjHYIBR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Aug 2023 04:01:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241289AbjHYIAp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Aug 2023 04:00:45 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33CF81BE6;
        Fri, 25 Aug 2023 01:00:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692950443; x=1724486443;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=8JZu+e0hQZs1d+OerUcS8mwuY0nBX6roPB+dtYJCdaI=;
  b=gakYLwFQuJqSazAdIQT25ubtwZeuMcUiYcoYUEdVHxiW/IMRJAhrjbvS
   Yh0x497+rbJz5di7JzNOR9d7gD4wJuuEkATDHkTHe9H1r+dVI1BNR87GP
   M7jSelF61w90wGX/LaOfOGNPzL5CKACjXQ9+yDCqfQqPVQyRZ6oL1KHij
   5qsSsKfGFT+ze26w8UmXTLNDa9yyyeQn4/FBY1llMTt7ef5FVdwsZT1i2
   unflejEmP3Em3ZBc2SbebiwLs6W7F7Mnf+MWp87j8Ppn5gjW1EDuTetli
   DFEbTLswIaSdTrTzej0JL6x46qdafkBEK4wqltRxcawtGrKxeDo+rYBVA
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10812"; a="354988454"
X-IronPort-AV: E=Sophos;i="6.02,195,1688454000"; 
   d="scan'208";a="354988454"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2023 01:00:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10812"; a="730953727"
X-IronPort-AV: E=Sophos;i="6.02,195,1688454000"; 
   d="scan'208";a="730953727"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga007.jf.intel.com with ESMTP; 25 Aug 2023 01:00:41 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Fri, 25 Aug 2023 01:00:40 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Fri, 25 Aug 2023 01:00:40 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Fri, 25 Aug 2023 01:00:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NnmeTA+bQ0Dehxhd7FQ8mU1zSXdzlHvMsudxZ2QQ5c5Nlp60koXNF4ti//HzWoCA0bf/7XgwNKbRuQ5YTYfuoazsSSIiQdKo444x8LEJ1vzEn+FZGyn2NostBkQMQZjebC2Yj2+jnzueckmwEBTZ/nV4IBeADWmy3mIiVSCGoqt38PCMCR3jwLFeT6bVGMnrRHyLcmQstTZnwgc4wsze1nbOR542zPpjLITP8IizdN/t/DrDS3jR/HGqlUWyRHcHXhfT/IIy103m6cwtFi5GfaWHqTIfwUGhLbB5ly16/2WUcA9A5vxRUcAi4SESH1kpwC0IFETbMM1RV8XtyN9R/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xOW36DgWBvA+S1TlFQhQozNl/ubVgWgaVMHAW7totCw=;
 b=d3G/s9sATD/kX6CM0VbjI/qwA+vHyoE/l9xoyhAOX7Xni8KyDIT1knifs4DlI9hffdtFVhw3PeLAclzOZruP+31td4ngOdDaT5P2XOPvVdG5AsE+IBDFn1hbxeZiUviCWqJfM/mpwNhT2QCGHQt+wrjl5wgd8AxMVV2dJy1pJdXe4HAXcl8uRY1DjLUd/Q7ragKaskx+b6Gz1NsoDDM4PqnR4aRSivGjAkBthwRUYzbZYMRR+p2vdjaQeP0NedWWwoVIY3BYvKY3Zv/oGMhhNvhO1tKwTnJgRf4S1Whe6zP33l5z3xUP3jZ3WPNcjPHRN1S63iRu9TqXqCtQ9MgpHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CY5PR11MB6440.namprd11.prod.outlook.com (2603:10b6:930:33::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.29; Fri, 25 Aug
 2023 08:00:38 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::dcf3:7bac:d274:7bed]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::dcf3:7bac:d274:7bed%4]) with mapi id 15.20.6699.028; Fri, 25 Aug 2023
 08:00:38 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Will Deacon" <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        "Jason Gunthorpe" <jgg@ziepe.ca>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Nicolin Chen <nicolinc@nvidia.com>
CC:     "Liu, Yi L" <yi.l.liu@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Jason Gunthorpe" <jgg@nvidia.com>
Subject: RE: [PATCH v4 05/10] iommu: Merge iopf_device_param into
 iommu_fault_param
Thread-Topic: [PATCH v4 05/10] iommu: Merge iopf_device_param into
 iommu_fault_param
Thread-Index: AQHZ1vyQX7ror2rpZECIvUzbX+kMZK/6pduA
Date:   Fri, 25 Aug 2023 08:00:38 +0000
Message-ID: <BN9PR11MB52763B3A72B574587E35CD028CE3A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230825023026.132919-1-baolu.lu@linux.intel.com>
 <20230825023026.132919-6-baolu.lu@linux.intel.com>
In-Reply-To: <20230825023026.132919-6-baolu.lu@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|CY5PR11MB6440:EE_
x-ms-office365-filtering-correlation-id: dbc97c94-1e98-4b3e-5bf5-08dba5415ef9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ICWfiQmukxQK7z7SkviBnpAeignUz4Wx6BIv3zHGAe8maAUqSDJa+vuXADyiawdsL/bDpSsJKyEmvW+gSWi+LL+DvzofoNQPc3RI4an2OEOZSit6s9C/SU8Rih090h1u3F6OHqWryEVNens54CR1JZwR4AxkzXVYarUQy29eFDFUmaA7uEKt/VyH1u4qcELLRfm3dJPdb6FKS45JY/jKWyG0M8l4kU17S7AteoHO+eVo3B5Gpxrfswb37qjJMX2at7jvSgjsvwfDmUuiwsZdmQWmVpDperlRGJxw/4IU8idw+HYzEiHiycdyiKoKACaqQvh3BhOWaN9E4acwOCmOETTLlyG9kafjTTb3twpJKykNSTuXVaKhHvWiOLtJosG4ia8puWK6Wu5Ns8LgEmeMaamrek5NwOODQNFB9uRbD4DAHH3SVog/qV5WuYBF01xzBCHL1WCkLt+7cTgKDJI41mp0cSCpmfPbA4+L/V0TiG2X2/wCYSJ9DtUAwqonfQ5ca70l078ybINmmYswmtVCHwrAeoxUVdBWwe9J6Wm/5G6v5ztNTcCbqQQFQiEynnaB8MjxrDH2d+pxjnrgL/v2cQqzq8a+wNEjrzkn5ulxoVvbnfaenhwks6piKYiGhLn+
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(136003)(376002)(366004)(346002)(396003)(451199024)(1800799009)(186009)(82960400001)(122000001)(38070700005)(38100700002)(8676002)(4326008)(8936002)(54906003)(64756008)(41300700001)(6506007)(33656002)(316002)(66446008)(7696005)(66476007)(66556008)(110136005)(66946007)(76116006)(86362001)(71200400001)(9686003)(55016003)(26005)(478600001)(7416002)(83380400001)(2906002)(4744005)(52536014)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?VoB11KdBCOh01EC/kL/3Jc2FwA/U1PVkh2g0Rr2jio+tI5mumJ86FEui8u5H?=
 =?us-ascii?Q?3MyXo6qz0e2AZj2+gmaIUzNYP0MXfDR7fPj17RrKgrYIfJ32xSxZZE0pcPXs?=
 =?us-ascii?Q?51/tLDnEMvwvaDj7MBoDHmI8YZen+MpWQVMp+Kitz6KCV/A3zX3tX0MEcIUd?=
 =?us-ascii?Q?8Re45z7/UZYOexDi1Yh/1J7MJEY/CO+OpSzQXC00eww1Ip+N+y/JLjezOUZS?=
 =?us-ascii?Q?J1li4dtZymNJFZSeCYGKJfb9aSGqZph1rNPczoqho1g5eL/NLClYQSaqzoaa?=
 =?us-ascii?Q?ofg8T0143lYHQmahVmdQmZEQZ6oaj2olP3AITIeEDFRih+yQscDUDRv7ShfW?=
 =?us-ascii?Q?Ye/RQ2y/WurHwbUqrKTgps876bVxt7w3dQPS1GTdtdLaZ7PHpZ26GLw56W0b?=
 =?us-ascii?Q?O0qJZ9AnxAX9XJlL+JuUCF3DEBZOvyreiamn5Q+gIz8CYHObJeeV5ZuBs+YI?=
 =?us-ascii?Q?zIGHTMGdQEjqVlwpTph1h+/8O67XQOroSIb4ss/SlNfVt4z3u3vxhX9ruijL?=
 =?us-ascii?Q?H6oq2iaa7/CWPjqICc44/btQKYrtvPQiM6ql28gkCK6zvj/+w3PwLk+YwOn/?=
 =?us-ascii?Q?Gr+ZjPUzpCfCNsG3ppdT5+U7R2MSHM768ExNyGrkzFBX+748vCZflrhMdXiS?=
 =?us-ascii?Q?8Nb+Ai76zdIhoqOBlKUZqmP4ZJFtwQXVeUrrtIhRHEG/Ux8xlSoFQbN3sXRc?=
 =?us-ascii?Q?rcaQhKdIIv+gwA4+W2zxrvl4gTGpt/wcZfcWwLdnQge6nFZJRl8l0FQ+8NdA?=
 =?us-ascii?Q?267B6Z9qMmoMbUtSyYxADasiRMt2LAXPQ3vEH9KEcUsr7GnQqgWE/K+GcpgL?=
 =?us-ascii?Q?SVH+kk8rfyEFJIIYd+WRCvnnkM+KXt1jckx52XX5QFXbayQHvu84m24Q1XTP?=
 =?us-ascii?Q?YtEF/CSTUIb9tdCU0xS4Y+YXdk3UH2CH358ZoJARh/PRwsPYxazoiDIezZsk?=
 =?us-ascii?Q?RFGYYNm37nHtsx99+yks6cSOo3dbrlFEVa0Y+sQysFz48XCMOKoyxe7Klx5+?=
 =?us-ascii?Q?nM2lHPAIui7+lHWtOYn5Q9Lkc5aJ6eDcX8Bdc4DROui6oBn6jJrfccLcBNbh?=
 =?us-ascii?Q?qnyHgGMDRpBW0plgld8SI6pGvhXHt/v4hXG2v6QWbVzxg9sanQ/54DOUsMp4?=
 =?us-ascii?Q?Tq52HLLSsgcvsZqVyn+TgtBTvmZcimYL7W6L4HHVlnOpFxXzJJDd9EMVA1tu?=
 =?us-ascii?Q?8Lc6qy+IE/30k/7ZfwdwmofOZtVuxqxZw9U6rSlmiA2PTgP4ijRNq+wbYhRU?=
 =?us-ascii?Q?kGvQ6gebCY9dykYdzECfwUuOQppaAc+3JYTyedCbDzGelOEmnB9hoCSYm00l?=
 =?us-ascii?Q?lUFXYkHEysOG+uhZ5YH5SWgffyy7FsxbYc3cxKCqU/7xnLLdf6CYKUbW4e1/?=
 =?us-ascii?Q?uPMBxUYjn7xMsIWPKf4tl0/n7ovQC9qlZjxQs3IPxMueIrUoNgFQLRlox2Bc?=
 =?us-ascii?Q?Z/GADNPk6j2HtnVIPESdK0HVV2zqAcqPrdKM//0t76pNXH8DtEjRUXhwonLl?=
 =?us-ascii?Q?JdeGrBMbPNfNvk201uD88cg39ydq+KvaSWjBzn379osjUIOMlQjCLKMV8wg3?=
 =?us-ascii?Q?TD6AcCAP619ZnqtvcFhi3ACM5NMtPPaxNOHd6W/Y?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dbc97c94-1e98-4b3e-5bf5-08dba5415ef9
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Aug 2023 08:00:38.7575
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ElVh6TUm3LFGwUX6H8Fh5gPNNgZcPfZp0kbC6INrMdQWvmTxp4QkwZwT6/VZ4joQNzdB5Gr1MOoft9EvbfQmDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6440
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

> From: Lu Baolu <baolu.lu@linux.intel.com>
> Sent: Friday, August 25, 2023 10:30 AM
>
> @@ -468,21 +469,31 @@ struct iommu_fault_event {
>   * struct iommu_fault_param - per-device IOMMU fault data
>   * @handler: Callback function to handle IOMMU faults at device level
>   * @data: handler private data
> - * @faults: holds the pending faults which needs response
>   * @lock: protect pending faults list
> + * @dev: the device that owns this param
> + * @queue: IOPF queue
> + * @queue_list: index into queue->devices
> + * @partial: faults that are part of a Page Request Group for which the =
last
> + *           request hasn't been submitted yet.

could clarify that it's protected by dev_iommu lock.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
