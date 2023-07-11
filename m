Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACF5B74E6BE
	for <lists+kvm@lfdr.de>; Tue, 11 Jul 2023 08:06:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230308AbjGKGGJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jul 2023 02:06:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230175AbjGKGGF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jul 2023 02:06:05 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 484E5E8;
        Mon, 10 Jul 2023 23:06:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689055564; x=1720591564;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=APTL262QB89cP3DkmCCkfm7Yp8NucF6spt+B+UxvSVM=;
  b=HX54UOciOsB+SoKuKWG+KPP4aH+K4oOSghAv9sBCBYEX2CmSGqxeIVut
   4G9A9Y2Ey5DhN4A9jiLMbLHVWZijwbq7aZScLaI9twGjHYExLXcEQrLJj
   OC70DwcEMzl6ZaZUpjJXMdAwzMupMBWDha4wlQK5WsU34oqCjIQX/KFTA
   rYXcdlZuQsgUiwD0fQfLjLUDJLADKnQ9uAUNrrD5qVPg6gsV/RQaRM6lc
   r4jgn9FT2IMscOBmYYlR7Q3E9vjP/wjoQkfP3Cy3VJiVb483A7c0h6ASw
   /qk0pO9vqK5DgJMn4IzfC/0Z8FLCaBkOXu03HfDEb4a+g4EDV6bF7GOQ2
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10767"; a="363401068"
X-IronPort-AV: E=Sophos;i="6.01,196,1684825200"; 
   d="scan'208";a="363401068"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2023 23:05:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10767"; a="811070025"
X-IronPort-AV: E=Sophos;i="6.01,196,1684825200"; 
   d="scan'208";a="811070025"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by FMSMGA003.fm.intel.com with ESMTP; 10 Jul 2023 23:05:41 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 10 Jul 2023 23:05:40 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 10 Jul 2023 23:05:40 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Mon, 10 Jul 2023 23:05:40 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.44) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Mon, 10 Jul 2023 23:05:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ElTMAq3OBo9y5slX7wxPbMyxngR3UsddYfPH5GT2AdN0BT2D5g6Bj9I0EJhnRNX+xoeWBwyLx/azOod4zz0G3SKCkWd9OLg4lsU1LmWyoqQdFuW2E8p+NJlJQd+TyM8lXs3DDrPyqX0sxHxXCMDlRUZUH+3ns5j0nAuBS4/aCBIkuns6rQhEP3k+yaWnPmv6r5Pg+j8kuXRxeFJkcFdcqmyi6args5/PDIM+YBlDe3k6Herhhk1xo+y4m4hxWLkJZp2biE9geMbfDWqTF+dTU31AaLXsv3Qaj/zy0cSxtQKeBdZ3zRQU/LcIcNqyKf0zWBj2/c4nCD/SDTweQubPQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hyom1UfcK3WSNwRaSsjQLP6TbENuFh3p9iUBpAe0rfw=;
 b=I8HyBcOBOOb4PtGi50oOysKqHo1vwVTbefCJbd6oAO80OEVrjaKhL9J6rJ626Rab7XLJD5meL+BQiBwB49UH0zJ3sKz4O4GdtzF2w7rE26LN4ArBso25+KTSUPRyyEhpbblvb34xhoKehWqdsm5QoYo8E7CfJgt6R5+iYfiCi2u/96iFFBPA6DgGJbPQRD6QJFax06r90eYXHLxNnHZzCqZDyB87clZF0kumhJ4N9Uaq/XHJkk5+zniYz7Y6z4JmGSIX+qc7fB59V3gnwhNXLNv0sWigUesL8RsIN/iF1U0qlzMOnc6zYXTe5sjEBw9Z5zB45ALUWl35J1uqk/Q6Fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CY8PR11MB7242.namprd11.prod.outlook.com (2603:10b6:930:95::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6565.32; Tue, 11 Jul
 2023 06:05:38 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::4f05:6b0b:dbc8:abbb]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::4f05:6b0b:dbc8:abbb%7]) with mapi id 15.20.6565.028; Tue, 11 Jul 2023
 06:05:38 +0000
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
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/9] iommu: Move iommu fault data to linux/iommu.h
Thread-Topic: [PATCH 1/9] iommu: Move iommu fault data to linux/iommu.h
Thread-Index: AQHZs5RFjSKO9r3Ol0q1EtvhMNZbRK+0EKaQ
Date:   Tue, 11 Jul 2023 06:05:37 +0000
Message-ID: <BN9PR11MB5276859ED6825C0A496C9C5E8C31A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230711010642.19707-1-baolu.lu@linux.intel.com>
 <20230711010642.19707-2-baolu.lu@linux.intel.com>
In-Reply-To: <20230711010642.19707-2-baolu.lu@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|CY8PR11MB7242:EE_
x-ms-office365-filtering-correlation-id: 391f6fd8-8146-4bd6-fda0-08db81d4d923
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ghj6LRxMYH75WUZc53fWK0iUw80HbefCbFULnV5Om1pNtoCYWil4LbILRVZkacXIq+zl1aS8PZ7qgkPL9ri5kRU6ibtwconNWA2Je0cvjtcs0N9NfrhDqEwZw2otvUz7ix1w+c0uBGkpYq7xlFIWIoNyvFsRlm1oR+48Xm1987OgQogKNEam431V6x1Guy7jLmDZvVis54n/2D9zahFmB+JOq58c+0ZRU40CcPTdy/+FifLVcxmUObUNf1I/EaiDWBPeXyfQ1Op3a1lnAOSoO5YhfxmQUN0AuQVam5H+0BUIb92euefUDRlPH7PR10K9TpbM8ZevNReGSCkqYUQ266M67cjgxu/CfWhCVB47KJAHSIdfchp15RGFF/dT08MLXnqldcOaoLMeRgFMIN+37ULqbMVLrPc0cysC4Yn/OS7E8KaglZng9gU89H3OxojL9FLXXmx3X56U5D59vZQrVcETZL6BVxtnn8TlftPKLyCHzUiH7AEVVJB3nXjY2Imu6wEPkvuzD4ez3l8YmxxMLK2Ijeft3KzUwhpedi5JDPha+11CH9PUkH/41cROYHJjBLc2ft5bcXqsK/nTvkIzYc56KVEykp/EMcM6fpewBBRJrp+u8n6uzVQWReR6s7V/
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(346002)(136003)(396003)(366004)(39860400002)(451199021)(7696005)(71200400001)(82960400001)(478600001)(122000001)(110136005)(54906003)(7416002)(8936002)(52536014)(5660300002)(8676002)(2906002)(86362001)(33656002)(38070700005)(4326008)(316002)(55016003)(76116006)(64756008)(66446008)(66476007)(38100700002)(66946007)(66556008)(41300700001)(26005)(6506007)(9686003)(83380400001)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?fXYVBalMd2TjOb2ZhsWh24I1vqPAJSnzT3KSqXNODUBxokyqHbXqUpEIHUCl?=
 =?us-ascii?Q?EFRteeK0pLsy17OhXTavwwMDBtFrQLjaZmqXn3DL4GdEeg9F08p/u8N5PgVM?=
 =?us-ascii?Q?8RzzhOZAyxP1zG7Rk+r82+CHeLfLN24juTZfyykoLGTLIOVCvLaozf5b3LeT?=
 =?us-ascii?Q?A6CVqQmS+prrFfYILouq0FU2s04Ad9aUurSRnKOQpIfqItmGVvTqYhf453lK?=
 =?us-ascii?Q?G6Zjn85D0oFgbPFAOfrPuovvFdGHIpptTikHxThioArG2M/agMfc7svNwaXV?=
 =?us-ascii?Q?TcLLRgpfT9GmrLtXkBzObwv8CJe7dB/P6JnZ6ghT8r04SubpaIhYD3pi7+fv?=
 =?us-ascii?Q?kA/7l5QoaknilKzXb0rZUkeR/g7qJDMh54ApYngeqgpKcI/2dEz5tBMSC9dd?=
 =?us-ascii?Q?6Z0Px35uHIsRBTrNOkk2XXZT//oVliencIZJ2Te3g+O12/YChIEfaGK3mTAh?=
 =?us-ascii?Q?LsHbCH7+Rzi/434TD6OUWoZNovJ/gXmenujPc572TzadhA+c66Mh/KUA4XRR?=
 =?us-ascii?Q?ufeaFS/GFB9ALBSdYkwZ7Pjr3X5me/aqOyCv1b7lBYlXKC9w8tTR81jL/Arv?=
 =?us-ascii?Q?/Cawl+q7Qin4k65/qigA37z2ku9r5Ur02eNlpgDFzxQYNYI4c4kqaGbUbjWL?=
 =?us-ascii?Q?QX2MaR8PpmMRy0usf/IGT3zuZy6B41mvHwac5Jcr+ixrjuApEcu+8TFji1i/?=
 =?us-ascii?Q?mG68CKQETk0EDJy6vohe49B2HcMsOhp3vx65YSaswTZOTu9nFU7NGeFOPTyN?=
 =?us-ascii?Q?EBGvoefTODV3QfX1mBAiT0SEuZp3neHxNayjaJ1Bh7VsQ2Ctp96TXXv57qLO?=
 =?us-ascii?Q?DBU4fzB+d6ZAfLsaMpbgwnq+Uaa/LJ1ltW+m1RDZBoZzc4vRdQ/adY0ycQtz?=
 =?us-ascii?Q?CKVhTBfOq65JudSpLelq72dJ7Euw5D1rqqH0mjJN/skyxSw+URVlzhtKqMrn?=
 =?us-ascii?Q?2zgGu6AkLE9ax/owJlEtU0Kmrdrledt24gQ5oDW8kC+jjAxkw4O4hZRcfAhK?=
 =?us-ascii?Q?O5uxn8B/IMMpD+WRHevqGqo4PzL0W5YombkKYMWUK9SxjjerW5eY4+5QsD1y?=
 =?us-ascii?Q?jdnmpasJF0ZnYFmpW3D/8/E6wZRVkzgv2UnN8BzhnX/pk76ag0KS9jZgEhJv?=
 =?us-ascii?Q?paf267i/eW/dv/LP6Ep72SbJk1+SuVnXbYzVI0hv+UgClZYPYfkG2DW0W5dP?=
 =?us-ascii?Q?1XETV+RSNGeSiTsi80P5xNuY8s/6Oy+xRFMOrhoOJnfKbkeameMiWuUo0+iU?=
 =?us-ascii?Q?8HcwoPTfDXQLWvfqnWhJQIWkNRQoWsKc/iJzWuiuB7lcMF2McUVsWt5zAEkP?=
 =?us-ascii?Q?rWU7sq0GAo/jsyJ0xIyrg7YMDg7LzhmNMTftvOYVw0wQeoAsnE3PYW+z+haS?=
 =?us-ascii?Q?VsspcXbOPkPQsjGvMJt0Juy0y5Ha8Y/IaS1pKmyvyWYPg7+ruFitykp6T1qu?=
 =?us-ascii?Q?Zd+kD4cPUsSv86f0fOyb1eapWlHWkxhKx3IXgRm0t08M9CuKh07CxcFXa80i?=
 =?us-ascii?Q?1tBG6HWqDXtghJBztQl8jA90o/+Reih3rV5/bUmd5erUPv/QfUDWMp7siBRo?=
 =?us-ascii?Q?fCVaHy5zX9mvxVK4DVsB9d8gFmcfoc61xNgOrq1z?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 391f6fd8-8146-4bd6-fda0-08db81d4d923
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jul 2023 06:05:37.8597
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uYg1ezuR8KcoeKbeHUt0qoJkJdzMhz5wD3eJyiCZ6cB3W3Ag3pdi0Np86h8DhznfX28DSBMjg5bsJF1PTPLg1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7242
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Lu Baolu <baolu.lu@linux.intel.com>
> Sent: Tuesday, July 11, 2023 9:07 AM
> +
> +enum iommu_fault_reason {
> +	IOMMU_FAULT_REASON_UNKNOWN =3D 0,
> +
> +	/* Could not access the PASID table (fetch caused external abort) */
> +	IOMMU_FAULT_REASON_PASID_FETCH,
> +
> +	/* PASID entry is invalid or has configuration errors */
> +	IOMMU_FAULT_REASON_BAD_PASID_ENTRY,
> +
> +	/*
> +	 * PASID is out of range (e.g. exceeds the maximum PASID
> +	 * supported by the IOMMU) or disabled.
> +	 */
> +	IOMMU_FAULT_REASON_PASID_INVALID,
> +
> +	/*
> +	 * An external abort occurred fetching (or updating) a translation
> +	 * table descriptor
> +	 */
> +	IOMMU_FAULT_REASON_WALK_EABT,
> +
> +	/*
> +	 * Could not access the page table entry (Bad address),
> +	 * actual translation fault
> +	 */
> +	IOMMU_FAULT_REASON_PTE_FETCH,
> +
> +	/* Protection flag check failed */
> +	IOMMU_FAULT_REASON_PERMISSION,
> +
> +	/* access flag check failed */
> +	IOMMU_FAULT_REASON_ACCESS,
> +
> +	/* Output address of a translation stage caused Address Size fault */
> +	IOMMU_FAULT_REASON_OOR_ADDRESS,
> +};
> +
> +/**
> + * struct iommu_fault_unrecoverable - Unrecoverable fault data
> + * @reason: reason of the fault, from &enum iommu_fault_reason
> + * @flags: parameters of this fault (IOMMU_FAULT_UNRECOV_* values)
> + * @pasid: Process Address Space ID
> + * @perm: requested permission access using by the incoming transaction
> + *        (IOMMU_FAULT_PERM_* values)
> + * @addr: offending page address
> + * @fetch_addr: address that caused a fetch abort, if any
> + */
> +struct iommu_fault_unrecoverable {
> +	__u32	reason;
> +#define IOMMU_FAULT_UNRECOV_PASID_VALID		(1 << 0)
> +#define IOMMU_FAULT_UNRECOV_ADDR_VALID		(1 << 1)
> +#define IOMMU_FAULT_UNRECOV_FETCH_ADDR_VALID	(1 << 2)
> +	__u32	flags;
> +	__u32	pasid;
> +	__u32	perm;
> +	__u64	addr;
> +	__u64	fetch_addr;
> +};

Currently there is no handler for unrecoverable faults.=20

Both Intel/ARM register iommu_queue_iopf() as the device fault handler.
It returns -EOPNOTSUPP for unrecoverable faults.

In your series the common iommu_handle_io_pgfault() also only works
for PRQ.

It kinds of suggest above definitions are dead code, though arm-smmu-v3
does attempt to set them.

Probably it's right time to remove them.

In the future even if there might be a need of forwarding unrecoverable
faults to the user via iommufd, fault reasons reported by the physical
IOMMU doesn't make any sense to the guest. Presumably the vIOMMU
should walk guest configurations to set a fault reason which makes sense
from guest p.o.v.

