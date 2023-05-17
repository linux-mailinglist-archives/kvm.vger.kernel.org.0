Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81AE470611D
	for <lists+kvm@lfdr.de>; Wed, 17 May 2023 09:29:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229946AbjEQH3S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 May 2023 03:29:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229916AbjEQH3Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 May 2023 03:29:16 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2709D13E;
        Wed, 17 May 2023 00:29:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684308554; x=1715844554;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=KUTTKyyqSIOhbwnfwoQB9gHTid5Fu1ZCtFhtCiPJX4Q=;
  b=YdOa8lHm6qgjJbCOiKqY7UGlKXLFTU7poYIxWD6nKu0gpmTXMsRCojJ2
   bZVHAyPAQhrn3Qc7FZhtJH1AYCwlrL6hG6/7fZb3zPswBVNJrMWQeAp1r
   siMS8BbQkmsfjdltGR+vXuWs8zIkdoCvwD73MgWwKezvR6EDhn5fNmdEF
   aaJ4sTOnZauhWEP32t63P9OXzldkrMLASvSknUJ6bQ6uggZKzExZFymwL
   4OjgMzyGmCMPwBZzG8jMTesPpbVWbDZDTpmaAsba+JuElm1dmLWuQrvTz
   6efTepfDWNJKxMMcotoMqBprjZQlqiW4WQF9pTAQCHqWp26ilI7JdzAGW
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10712"; a="341073363"
X-IronPort-AV: E=Sophos;i="5.99,281,1677571200"; 
   d="scan'208";a="341073363"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2023 00:29:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10712"; a="845981648"
X-IronPort-AV: E=Sophos;i="5.99,281,1677571200"; 
   d="scan'208";a="845981648"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga001.fm.intel.com with ESMTP; 17 May 2023 00:29:12 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 17 May 2023 00:29:12 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 17 May 2023 00:29:12 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.45) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 17 May 2023 00:29:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ggQJA92T0MlTvovU2VzRisbfBf+7a2iPKGtw2q3AIh1HP4iZsq4KmvEtrqOuhXjszkOmi1SFN8+5SR4+UlvzLp/JlWh4MUn5wUaRPE3eAr2EaWJUOUNF86u0vHnc9nbbgPWSrtMjNxl1jU8hpjhVyIW9TWQdh2kIS3fKZB5dCwAhP22frpXMmLu9mtNCjONjwssUSXCCuUT6QUS07pRgmb0wjGzvh1iKNZqlWBxasRVHfIyIf1ZqA0jEUiUxuqd/Ib9A1z9bKUqioyHQq3Ey34cxb7N1KWRYmNIo4MDU0Bv3bVby6FJiIi7dqgqXrWwrVuevz1NqLBbzvwsEa6OVgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n3vpOu3f8//PmRU4vdDCY5ZJ69YnmHANyojWGdIepi0=;
 b=DLke02tOjsRz4AcGIR6r6Dt7EHwf9cItf5IcBPdxoCRg6YFaNEKvUHBmIsrxY8qYQfndeg76MDW72S74TRnfRK2K4QPNxq6pS434NzbYiP3BetudDgyBvzfFOAnrYVN+FC4rG0QfLKzwCDAM9m1tVFU5H+38WoulK0wPLr8fCSjUc82ONrhuSx020QvdePwDYXK2w4JXmuADYqPQ+AIdBd1aRl+OFqMEulV6ay8jEWOoGZBCQQ7FWrz82+8hlS5g1uNZVa9YuUPK7knIx7dOcICoVq04WriEFiOUBJhVIbinkmxHdG8obudGsF9KYm0zLlsQK87eAzWgNktcK2laxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by PH0PR11MB5095.namprd11.prod.outlook.com (2603:10b6:510:3b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.33; Wed, 17 May
 2023 07:29:10 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174%5]) with mapi id 15.20.6387.033; Wed, 17 May 2023
 07:29:09 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "ankita@nvidia.com" <ankita@nvidia.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>
CC:     "aniketa@nvidia.com" <aniketa@nvidia.com>,
        "cjia@nvidia.com" <cjia@nvidia.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "targupta@nvidia.com" <targupta@nvidia.com>,
        "vsethi@nvidia.com" <vsethi@nvidia.com>,
        "Currid, Andy" <acurrid@nvidia.com>,
        "apopple@nvidia.com" <apopple@nvidia.com>,
        "jhubbard@nvidia.com" <jhubbard@nvidia.com>,
        "danw@nvidia.com" <danw@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 1/1] vfio/nvgpu: Add vfio pci variant module for grace
 hopper
Thread-Topic: [PATCH v2 1/1] vfio/nvgpu: Add vfio pci variant module for grace
 hopper
Thread-Index: AQHZgiwdnOavLCCjbEOsVWRum+0Dua9eG+Lg
Date:   Wed, 17 May 2023 07:29:09 +0000
Message-ID: <BN9PR11MB52763B1BC1C88EB8C24E2AD88C7E9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230509040734.24392-1-ankita@nvidia.com>
In-Reply-To: <20230509040734.24392-1-ankita@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|PH0PR11MB5095:EE_
x-ms-office365-filtering-correlation-id: 5a3b99e1-891d-49fc-3833-08db56a867cd
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bFKISivh5+d+Xxb36Vfg+E4mIPH5tqak1i6Q0wlGKeJ6rH5d10VWsvxpf2sZw1aRNVur/yJz+lGlhgwymXOivTHcBngKfDH4kBJKZEtpLTcK3aKcirMfacRkA0IKGCRAZ96p2m/bPU+7wY2tztnRzMJ5VU2Ys/suG5pYwPH1UytEwCnT4k1zW+KeWCXeCuTxrjFE9pjDtKUeX15vjj7M6mvigwmjLJnp4/t8EizjqngFgckQ3B8K7TVWjB/Jt+K04zdtbR7WbzEVNTPelP0+eOX/e6lLKvUS7J103Nr0f6aGjuxyTj6Og3vKXQJrPipWCchaYLqGfRdQFPc18miVrW+UT7CkVIVtOzvVnA8NYat6hcBZi5cwe9VoSDLaseT6EabvbdK1D9xLi/4g3LkOxlEoOmvwCAHGAsMcNDw9xUK5GkUxNrhrWb0gX4Bot7Y5fpi8nJaY0F7HZcJJHDbqqR92w9dHwgDmlDITmdT/KLfn4MK25kKn/+7JvXfVU+Q/V29rjPKe8HRBbadgPcukOXk8JwzLK9gjNN8A9poFyTuQD3STXv/MQyVkUCBJfGauGLIskajlYTT6j1jsLEPVJEuZy0zc0TqwlXuSzgpuvNT4fYByZ1VnXQdxFBexrj+D
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(346002)(366004)(136003)(39860400002)(396003)(451199021)(9686003)(8936002)(6506007)(5660300002)(8676002)(26005)(55016003)(33656002)(86362001)(2906002)(83380400001)(478600001)(7696005)(76116006)(41300700001)(7416002)(66476007)(186003)(66946007)(110136005)(54906003)(64756008)(66556008)(316002)(38100700002)(38070700005)(122000001)(82960400001)(4326008)(71200400001)(66446008)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?cH7b9tYo1Bkf7RbQs8gWx9RIuyqipbAhmGqGnoSajwPW52I2tTm9FSakFyK+?=
 =?us-ascii?Q?cQP/HJsKY29JvCsWQ9lWUYHqJpZCAV5Sa5f1Ruq3cmU3nBv0PXx7nFONiO5o?=
 =?us-ascii?Q?nHFrLQSBRuwnf5Mk7Ja9aL0m3IriOF5E4YSWAWIIeo5wbgzJyrM7j9Ts2IJG?=
 =?us-ascii?Q?ipX/qfCtJNU8r+XSTC83M3snb2oS6027D0IKyL2X/3kVKQtTnJ9+9pUNDzXC?=
 =?us-ascii?Q?hWVMRqic/wg1BaTjyzftuL78B40Ra1ntnuEURidl9zMILzdqgSI3214R+E0v?=
 =?us-ascii?Q?d+aLL9S0RDRqQQfWrwpXWhuAkU2IcxTljv3z+4tacTmLtR2lFy8iiPaOHiDJ?=
 =?us-ascii?Q?e2z3bZbxRqlc8eAMfI4S8IqB17bm2X9duaHcn1AfJprlElBuC/xl6RGFWssB?=
 =?us-ascii?Q?wB0+PbZF5MKYOW+8zLt8oV6xFsFub5eSgL5CRXQ2/MHasEQ8tBZ3Z4VOpqxi?=
 =?us-ascii?Q?ZG4vJnikFWc37rtsEru+r3jdwxDDg1Zc69fiHhADTOu+sXU8jtb6di1uGumJ?=
 =?us-ascii?Q?wWwuFBIa2O9dGO0RIt/dlkhqlGiw2s2o+NpULs504w8YSM5AwSWgBfMIOMXg?=
 =?us-ascii?Q?EDsowFcBQEg7ME8++PEdDFQGAG1N/FYzLPEOgryQwLGkleWch6wR+UrsBMrU?=
 =?us-ascii?Q?Lxftf4mL30kbJDjzQqB28xtFuedCEhiBwvAooT/EgYfKTAyorj9v4ywBUz/J?=
 =?us-ascii?Q?ul1NDHCXZno9HN4Zi9rJCl4Q5Q2O4Wq8fNHdxcRS74nmIxPfExrGG6H/Ms0N?=
 =?us-ascii?Q?ja9UhKasdFvrE3RZkQkZ2WJVCFE1UyE7Y+wQBT0UscmwM95N/MsELXuwUxgh?=
 =?us-ascii?Q?gJnrIjwf7pgYxOWY+Zp3sYqsemhDgrcNxjTUqt7x8kHMSAP36Vf8CGbeyGmo?=
 =?us-ascii?Q?BRb8lmoOL8Fd4zCX17GmhKMEd+zYpd5YlZu8rFAdo9BvdR/9Ps1qa67KsK+z?=
 =?us-ascii?Q?94OJqYsA33AqqeBZpgevsiV801/m+NM5XC+jIM/0ptBv4xrWT06XF/lrprNS?=
 =?us-ascii?Q?fVOFzBdfcHxp/sakjF4C+5DXjP/i2dhHQoqjAnhxUNcCvWTqtrsRUoBYL/2U?=
 =?us-ascii?Q?zjy9nCI6cVEbDnGHkMQDfKWrr9wJ8+TjHwIucXhoo78CulzURA8sCOpiGqsP?=
 =?us-ascii?Q?GKjXWHUTP8nrtMfOpmWBCgw+b/Iie+pHg/GB71fDIFIFFucCs10qfchNTxuL?=
 =?us-ascii?Q?+bYl8hi02zSaE1ELSWeyzmpM4oHE3BzbTTswf5GCnEeSO81G2ZHqkhMMS171?=
 =?us-ascii?Q?CO2W/AScvDzyUbh7k0r67BlIj3PF/LGlijUAlststXNdv95fc76g4TIiyfwH?=
 =?us-ascii?Q?NmutlmmIel4X/armwh4j94U/7PyEKux0t2Vwcf84Nk+l7bwRDj7iNZCa7jYw?=
 =?us-ascii?Q?Kd+kJPZrlCcSU4Mv6DOf9IgaL/h1M/Vik4vjxKlOSRJ92ozzLM9RZ4QjJ1CF?=
 =?us-ascii?Q?mQAC2992dWq9xW1Ss8swSk0ByxrvRHI/nA+Rd5byQUqI/MHZqOdjK3xqGzxH?=
 =?us-ascii?Q?sFpAiHy77UOMPuaXoTov3S4ZCAIsDnSu9yWuF6OvvVgToGDktHgNLPdDb/n9?=
 =?us-ascii?Q?/vSQ15VI/n2OCR5YNmKAI8Pvy73kckHH8kg9j4lI?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a3b99e1-891d-49fc-3833-08db56a867cd
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 May 2023 07:29:09.8995
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fuunWkcjPkWoxBjBIMZBK8XxWwlaTPGPSlgImgEHI/KESxdkfBUuDZWcXWRFvT9CbTWjN11N0hDSYxPm+4Zdbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5095
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: ankita@nvidia.com <ankita@nvidia.com>
> Sent: Tuesday, May 9, 2023 12:08 PM
>=20
> From: Ankit Agrawal <ankita@nvidia.com>
>=20
> NVIDIA's upcoming Grace Hopper Superchip provides a PCI-like device
> for the on-chip GPU that is the logical OS representation of the
> internal propritary cache coherent interconnect.
>=20
> This representation has a number of limitations compared to a real PCI
> device, in particular, it does not model the coherent GPU memory
> aperture as a PCI config space BAR, and PCI doesn't know anything
> about cacheable memory types.
>=20
> Provide a VFIO PCI variant driver that adapts the unique PCI
> representation into a more standard PCI representation facing
> userspace. The GPU memory aperture is obtained from ACPI using
> device_property_read_u64(), according to the FW specification,
> and exported to userspace as the VFIO_REGION that covers the first
> PCI BAR. qemu will naturally generate a PCI device in the VM where the
> cacheable aperture is reported in BAR1.

BAR2.

and it's more informative by describing how many BARs this device
already implements then BAR2 is selected because it's free.

> +
> +static int nvgpu_vfio_pci_open_device(struct vfio_device *core_vdev)
> +{
> +	struct vfio_pci_core_device *vdev =3D
> +		container_of(core_vdev, struct vfio_pci_core_device, vdev);
> +	int ret;
> +
> +	ret =3D vfio_pci_core_enable(vdev);
> +	if (ret)
> +		return ret;
> +
> +	vfio_pci_core_finish_enable(vdev);
> +
> +	return ret;
> +}

NIT. "return 0" as other variant drivers do.


> +
> +MODULE_LICENSE("GPL v2");
> +MODULE_AUTHOR("Ankit Agrawal <ankita@nvidia.com>");
> +MODULE_AUTHOR("Aniket Agashe <aniketa@nvidia.com>");
> +MODULE_DESCRIPTION(
> +	"VFIO NVGPU PF - User Level driver for NVIDIA devices with CPU
> coherently accessible device memory");

what does 'PF' mean? Physical function?

Probably needs a more specific name for the coherent part... nvgpu-vfio-pci
sounds covering all NV GPUs.
