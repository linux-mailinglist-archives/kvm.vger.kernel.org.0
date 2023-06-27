Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C3D473F687
	for <lists+kvm@lfdr.de>; Tue, 27 Jun 2023 10:11:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231345AbjF0ILK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jun 2023 04:11:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230224AbjF0ILI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jun 2023 04:11:08 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CA4C1FCC;
        Tue, 27 Jun 2023 01:11:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687853465; x=1719389465;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=J5zaWMHxEIuUEUT0c8gTpcqueHRHJninNFJ24Pag+/Q=;
  b=NbW6UuxeZ+vyL6RarzM7Gg8pQF1H1d9hX3ZqlhGnZdm2InTZYBt2RIKp
   5Os+CccoEe/kERqCbT2NWSWI9RT3MEmkUZPrQ2IB8VePtmPsj0RP0ET5U
   YOSsXdOtyZ01WYUCb2RW3MIBNZYC0sigko7p4bzrc21r33w87BzbWvVi9
   WwTSzdrsukmCKgAxAmUsqkZAI2NUNSoWkK3dwVxR66kqyyYRZ4EM6+iN5
   hyBWJS0pUl+kmw9Kdoyd794btBSxymIaDGI323LuBYWr9wzLnQtTB2nls
   SE/U2d0DPPa6nI0/9ZQGZmD91vWfrJxKaBrlI5BI+tPnpNt/4bmUEu/4d
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10753"; a="425176038"
X-IronPort-AV: E=Sophos;i="6.01,161,1684825200"; 
   d="scan'208";a="425176038"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2023 01:10:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10753"; a="806375692"
X-IronPort-AV: E=Sophos;i="6.01,161,1684825200"; 
   d="scan'208";a="806375692"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by FMSMGA003.fm.intel.com with ESMTP; 27 Jun 2023 01:10:53 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 27 Jun 2023 01:10:50 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Tue, 27 Jun 2023 01:10:50 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Tue, 27 Jun 2023 01:10:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eTjL59rAEI9ylJQkqr6wNxcbY60i/K5T+XD1lRxR6GBV6Of/qClUmDXOa7u+BMBe0/CdtAjmlI5T5BgSeqYfg/xN/VoY6gUNaruPPDvctcyQrhh+Xku9U0syIyh3oTbdaWLCY6/kyVbyeJ56vIVfE4wPVBhQsKQr5vm5d2nVa4fGYBLZD8vkwgUXizu0BFdB7ypWxm38q/ZVCUzQ6MFSX5HaR3QjukEBGl+gBV9nQuFIvDstgYuM1mCg78AaoM2QFK6JDVgWShpC8AllHXbRigqk3Zw0+kG879a4E58fSoivpKRBc5MbkFBVk1IiPYcPUo9tPznKFGpO6QbdUBi6SA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J5zaWMHxEIuUEUT0c8gTpcqueHRHJninNFJ24Pag+/Q=;
 b=dp83oK3swkyg8ZIpEDD+GHiNTunZgY6SqE4vczCBnYi1QON/CGwRcgwP3Q/upMfnkQpHQHQjA7o8tewah5wzU9P+YFv47xOxT0zsX43Oc4HT/xW2MrOFNnWQNFTW+PD0vZeDdZaSXGcbuRK5E+hG2+JY6mQdcnx3EsewPO6h+2Lge2T4yNyTQwvElY92XeJTkp098BycyLNoNuNHWui4n4swjbNI9bkMAZEZczUZJVD++Lak5bRG0rBiwCRiQDPtt3DX7pFnOCXcl/tZLgoN+fI6nm5HfnxUcoLGq8xNgiOz+3wCivHjJwHa1zseqCrFbrmBOWCMWTBW3uIwpnHcaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by PH7PR11MB7479.namprd11.prod.outlook.com (2603:10b6:510:27f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.24; Tue, 27 Jun
 2023 08:10:48 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::4f05:6b0b:dbc8:abbb]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::4f05:6b0b:dbc8:abbb%7]) with mapi id 15.20.6521.026; Tue, 27 Jun 2023
 08:10:48 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>
CC:     Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Will Deacon" <will@kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/2] iommu: Prevent RESV_DIRECT devices from blocking
 domains
Thread-Topic: [PATCH 1/2] iommu: Prevent RESV_DIRECT devices from blocking
 domains
Thread-Index: AQHZmPOfW21nPHSVEEOmSVh5Edp4ra+SM08AgAACagCAAArGAIAAE4eAgAwTMHA=
Date:   Tue, 27 Jun 2023 08:10:48 +0000
Message-ID: <BN9PR11MB5276478406FDC2119A8EBD568C27A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230607035145.343698-1-baolu.lu@linux.intel.com>
 <20230607035145.343698-2-baolu.lu@linux.intel.com>
 <5d0d6665-93e4-f61f-d700-008c0fcb4a2f@arm.com> <ZJBbJHevOa8mAdll@nvidia.com>
 <0c1aec7a-8724-0f49-bccb-6025f5863bb7@arm.com> <ZJB0jyMQpZXWVANP@nvidia.com>
In-Reply-To: <ZJB0jyMQpZXWVANP@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|PH7PR11MB7479:EE_
x-ms-office365-filtering-correlation-id: 5d221269-ab85-4d53-ced4-08db76e603e5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Y3GvEMLb03r+yIdGaVuUIRN9KaavHF/dcmF0UIyzlp8AQP3syft/JhNsqFLchVyy0K5KaS6VfhsD8VKvjWqyy6l1lZ+/AAa6LE7MqD6TfZ8FdwG3JPmiufqBSev7Cz2pxGfR3WkqHnnl9Y0FNYlKWs9aQLXP5WHrs717uJ16CN2y7SCuLciEoDbEgP3OLbixmi2fXSzACWDMtHvM9UuO7C2OI4ruiEblfmMnMTH8bJpLwKQQBhQH4LR7NFtViu42F2sdtfz6Mco5T44aJL98TsjbC+/laaFiY1bNPPxNH88Jkp9s9kxaeCste1TiXvQd4HQH36Ktfo5rP5DaYKBbfxjBmbzXCk2PerHrtJLYeP1MD+NzHaYROoCMHYfNmliX/yNvwLcmo/1EnApAh/ocHCXbtFrAIrxPciH5L47wV8NKVeWAOna363Q6yenUrIemkSMb4YZSAz3hUOIHc9K5wOjbSKsVYRVVCKx8i0ltRr+B16gyyxYjQudyJZmnmDpIESE0Biwdp3qH8vStHWHE/ZY8q3QolaDGAtVcLjwpUGAKwH7N4WABtn1vsEKAah33NkXNiZohQGqkFRyCl0HXn/HhC+R5X7uePNNSLmeDTGgWXihkVjwSej+uNNnYJsp8
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(366004)(396003)(376002)(136003)(39860400002)(451199021)(66899021)(38070700005)(66556008)(66476007)(33656002)(122000001)(5660300002)(52536014)(7416002)(86362001)(8676002)(8936002)(41300700001)(4326008)(316002)(66946007)(76116006)(55016003)(64756008)(82960400001)(38100700002)(6506007)(66446008)(26005)(186003)(9686003)(2906002)(71200400001)(54906003)(110136005)(7696005)(83380400001)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?m5r0dsqwGRoavbTjswRSGHVVFprqVIQ00kpHfx2MQMnV6DGgln6KaQNqYw2a?=
 =?us-ascii?Q?14wWeG7DZhC1Ep2kysVacCXnJ0qwRS086C+SEj+ogbPXYGgCaqddSfGojLjF?=
 =?us-ascii?Q?0y3Fifip2g83pY3KX8xnhf176uWXnQ0E5U0/erhd0tVpwNUfeSiIC10mJvbn?=
 =?us-ascii?Q?O7xV8v6ejgK13OcKNPxijVQD3eZFLtWuHC3pDUI84ztdIralfkqycU9x2GDd?=
 =?us-ascii?Q?7MUuwNdVIA9i0Yd8uyAgzF5SZxs8WPCppf5bfjbsaSMdLdxUkewDjQzIeagE?=
 =?us-ascii?Q?9JGjqnoBYh7WDRM7NXvAn4CJWGxkyj604UBabKRy3WTksv18oxCmFJBDZNIQ?=
 =?us-ascii?Q?UvGtVytRkS2VIrVFknbQCwkt38wqYClkuQQM8GPg9QD25oY5Z+DlU597UJiE?=
 =?us-ascii?Q?JF4NyvmmsTuQi21myhSYAOpiNw2TK2nbY+KyTngGUCxdwkxh1iRZS92dHKVv?=
 =?us-ascii?Q?SF3LlzRAlnwbwqw/xTplh6TN6mK6B0LHvX6lJ33vkK65JuYnBfa90YPsy/pE?=
 =?us-ascii?Q?nJoDhet4YYZQAMCeQ8NYbZO15ZCXJpRnCWcckIzv9/aep3Blk2XdfU70vaHF?=
 =?us-ascii?Q?kC1t6NH3pSVncq60eDmPa05NMgp1fj1aldGwTzxeqzBLeZMlhJmixP7IQkIP?=
 =?us-ascii?Q?IEO1PiB+ehieJw9lHQUh/2gvv1k/1CVcrDVorR2UxxyYnlUx/EwiW6gU8T+k?=
 =?us-ascii?Q?/ck5eGpdqdKechGYb9Ek3YW5vVzwTXh+tx8pqHKamMewsb6p5+8gBQ/wr25f?=
 =?us-ascii?Q?I+hxXAzimtEdat2wOGD+c/SJQR7aUghF24zQ7IqV6Ufq9EZn1hJA9Un+8sHc?=
 =?us-ascii?Q?17caqtGbm3neG96K5xuC6ZJMX+iNU4SPGpPvCJPggVeFGe1VnAcT58SAy97O?=
 =?us-ascii?Q?9Yznva1x5F1Ji7XsTzk1kwEuMh3CFqv+mdWvMRWiv4QoNqoWR98X69WUkTzT?=
 =?us-ascii?Q?MeKLs9Y5lJYiO+NBv1pyurgLAqkSJjk8ePHQ7CaBUCdkXd8hwOeCoN4OibkW?=
 =?us-ascii?Q?BMFGmiG8FOCtWkTeHUwT/ZiIgFFdTSZyygZLzwVXLNfM71JK4iiwEyaBSGad?=
 =?us-ascii?Q?Yvc4ML+UbbZhJdyDwQxED4TnQ1yXcLbKMHrY9yxhrT0xYssygSuYE+Ab6q5M?=
 =?us-ascii?Q?Ppx4QwtCiGaZf5P6pj55lBWgzCgj4bAI0IOSZlVqTGFt/KanudWWtotOKtTD?=
 =?us-ascii?Q?r10tlrBZWONNjY3MO7IO4Wgd82U7ZkjVt2KRtcu1oQK0MwOOr/2H1WMyQTSP?=
 =?us-ascii?Q?2yiLGU9sreIszqjmeulSXKwwIgSWx1SlpBRrNSatkzk14a3Pd2Uv/ot4auM0?=
 =?us-ascii?Q?x5sWWdXvsP9gscNhUZZf4iIZcNxSDQKD/CC2QdcE22KzUwS4KUkT4NqJrCs3?=
 =?us-ascii?Q?zFPsa1CBfjmdvWiSlWgx/tgBKx9eVC9QjMsAItkx6IBKKmpSwPsoJd6rQd1J?=
 =?us-ascii?Q?DBQm9HB4VwxaToCVyK3e+P0X65GR0LVPnUGkvspboOZseDxh6Q2vIKnWMa+e?=
 =?us-ascii?Q?511p6MBKaVXZtsDVIvIIEUf66l9ZCVwb3PNz+tylbk7p95SnzNECq19a2isf?=
 =?us-ascii?Q?GwkUGa/naSvWvdhWQ8N+RX6mCgoT2ZXiehOaMNCs?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d221269-ab85-4d53-ced4-08db76e603e5
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jun 2023 08:10:48.2989
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Vl7zZrc0iF0wKr0ijXok6yW/cF4UyVTEbSOPu01NfwjxUC2CaVLdrH+Zs0UkZPLiwikoOE0H082VTa4Bno7KJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7479
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Monday, June 19, 2023 11:30 PM
>=20
> On Mon, Jun 19, 2023 at 03:20:30PM +0100, Robin Murphy wrote:
>=20
> > so if the only time they're used is when the IOMMU driver has
> > already had a catastrophic internal failure such that we decide to
> > declare the device toasted and deliberately put it into an unusable
> > state, blocking its reserved regions doesn't seem like a big deal.
>=20
> I think we should discuss then when we get to actually implementing
> the error recovery flow we want. I do like blocking in general for the
> reasons you give, and that was my first plan.. But if the BIOS will
> crash or something if we don't do the reserved region maps that isn't
> so good either. IDK would like to hear from the people using this BIOS
> feature.
>=20

The only devices with RMRR which I'm aware of on Intel platforms are
GPU and USB. However they are all RESV_DIRECT_RELAXABLE type.

Here is one reference from the Xen hypervisor. It has a concept called
quarantine domain (similar to blocking domain) when a device is
de-assigned w/o an owner. The quarantine domain has no mappings
except the ones identity-mapped for RMRR types. I'm not sure whether
they observed real examples of RMRR devices which are not GPU/USB.

I guess the reason of not going fully identity or fully blocked is from
the same worry that the BIOS may go insane while Xen still wants to
quarantine the device as much as possible.
