Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3123F69A51D
	for <lists+kvm@lfdr.de>; Fri, 17 Feb 2023 06:34:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229524AbjBQFe1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Feb 2023 00:34:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjBQFeY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Feb 2023 00:34:24 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3238E4D633;
        Thu, 16 Feb 2023 21:34:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676612064; x=1708148064;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=A9ce7E7F4y/Re6b8XXCFKisif45pzsh+d39YQJBCBxc=;
  b=EQSB7bM0jYCRSYj9/u2QcON63fAkmKDlbhdZKG4t/NtEfzEwfiXR8t0a
   tt6t7AR3ygFAv7QlaLrVOv+EXtKXe5Otl2KtooXji3+j5wExl+HMXHu+G
   cmSZF9KWfpS6bKqwrFYb0lsBit+oGIIm6/0VyQoLEvjeC7GHncZlGbfRn
   hd8cRzfeezBFI/aKwNrxRrWHVGj533B8luyQEFRd8+xn7tOG6HnQS6i0C
   iRo/mYtMQk/nCa9ulAMsQr9al0iK8E6VYGPhfcy/eO0fpp0owTlSa9711
   5F1t8NeIr6UW5fS0s0Xvi3eh3rdv+9UqtzK2BD+nYDtmtfQtWhiGRsmUI
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10623"; a="394389062"
X-IronPort-AV: E=Sophos;i="5.97,304,1669104000"; 
   d="scan'208";a="394389062"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2023 21:34:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10623"; a="700791661"
X-IronPort-AV: E=Sophos;i="5.97,304,1669104000"; 
   d="scan'208";a="700791661"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga008.jf.intel.com with ESMTP; 16 Feb 2023 21:34:23 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 16 Feb 2023 21:34:23 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 16 Feb 2023 21:34:23 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 16 Feb 2023 21:34:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G2uNYXlY+0tVn+1RVGKThYtxI/4E5EbDkeaL4KvATZqvn/wvunPMUhCZHNyCvqEJUgAoRHZM4rntxv6m2aB4jP6KjSK8dgvg2TbCF+PvaQbZT987IJrZsR9qDoykBdQAlrFjf+NIadHG9gFs9Ey9JGcuwGCiZOYKQsepL44jiGzADQTHIZ2tUcpb1z+NKDz55+N6ivAUidadteUXdFrhfEPXkf6zfW0l3jmoxHu52j64oU2/jVlqgJj5MFZdfQbSHc1tk03CrATamJpiI9VgwTkpddylgEkoHyu+0M5F3xgiEN5Z50RETteyc0ZEI9w9LzmwjCjQ8hhHHAA2IFG5yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5tFCHL7vbBbQ4J8LMUuPTeArx5Eks1CaWvKrkYZLYHs=;
 b=WQFAI4Ab7r5tT3BN3DQcpik3bnlzfj6jqipSey9XQ7OUH8sq6qALkMdDhw9YOjw8eNRR85RwJqV9PKVo7q9bEPvVZUIsxG2QKB47Om8nLRq7xR2/lgiyIYpDc8neVNXSNrv9aC7t5dmog2bm/TK9r5U/gTbbnxyI+gMBCPsWMSPIP3PwUo87lRdj7hjYtg504L1+tlWyWgOjhnZ7iaN+mLtDSnSrVI2dl8AHcHQ+OHmsh69lL77pAlWCNIMVONArYUUHjemXridakH3ZFYhea2hGr8IfOfY6gMFhYMnto35yU4VQjKYly/s/pTpEG/NLYH7U0UuEiCRAWva+Qe3uMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by CH3PR11MB7299.namprd11.prod.outlook.com (2603:10b6:610:14b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Fri, 17 Feb
 2023 05:34:21 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3%4]) with mapi id 15.20.6111.013; Fri, 17 Feb 2023
 05:34:21 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     "joro@8bytes.org" <joro@8bytes.org>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        Timothy Pearson <tpearson@raptorengineering.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: RE: [PATCH v3 05/15] kvm/vfio: Accept vfio device file from userspace
Thread-Topic: [PATCH v3 05/15] kvm/vfio: Accept vfio device file from
 userspace
Thread-Index: AQHZP73PxotwwywX40uQF9TRO5UlQq7PB0WAgAAQc4CAAATTgIAACdQAgAN8qMA=
Date:   Fri, 17 Feb 2023 05:34:20 +0000
Message-ID: <DS0PR11MB752967E3A3A8B8693A523D54C3A19@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230213151348.56451-1-yi.l.liu@intel.com>
 <20230213151348.56451-6-yi.l.liu@intel.com>
 <20230214152627.3a399523.alex.williamson@redhat.com>
 <Y+wYX34sPvPQmGSr@nvidia.com>
 <20230214164235.64e2dccb.alex.williamson@redhat.com>
 <Y+wkqnCAe42Ogcof@nvidia.com>
In-Reply-To: <Y+wkqnCAe42Ogcof@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|CH3PR11MB7299:EE_
x-ms-office365-filtering-correlation-id: 0552a87d-2c72-44e6-8408-08db10a89e78
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wQQcvbh6NyNI/r2vqnQLoGEyoEM6TMUv6rRByao7QdM2om8zy4v1wvTaIaonb1jcEigGTAclIkhkomsnMFApRSlokVoUXk7GMnA5il8QoZ8lTA3el2tJXRL/pqLWfqWGzCqfFheTBlvc5TyDouJKqxH94XsA4AiJX2ewCODcjIEdkjXFdlN93jEZ0KD8T8+CwKWQrT/LK3G8AUkeMaAyvIHayDrniDn8Qlx0OsbEFx3jDcSkH50Pf6baPuyXPhaCfeclVZR0AQyEURO478t++nfES8DBu7K1GpI4GyBZnC9ZKOi96yo/PoB7uMLKxwZYU/x4Y/jhbNPyAXIlSlIF686sUri1W2J2g9f24Xo9PG2d/lWppo7guwodR6CxFOsoFvFzlji4YeKHr8kLT8LsV6fhUFAGpIHtgH2ZKRew1YWgl1/gXgOMH2VbT+6XpnM46HYlA3v0BYhV6SUVNUzAkXXbFeMD2BGdj97HwLlALRBP0U5bQY4iXXKdWDULZW6csMFhQpsvT+EU0+cU5gcYGp2UE7d7JGo0l3ndUiyIPuZ/3Ois1gsBntBM77Q9VsCWxoInSm9dNVulgOOGTSxU8mbrWc0T5ao5/rvSCA2fPZALAVegpvv2gCH1MsBPBAs/EAP+8+D10sxr2saFsivF5Mcdp8jO6pajNu3DBPZraFAwXSPPxeVeOKSitHpYDjsRUWaMRrnowGad/YOaQYgi2Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(39860400002)(136003)(376002)(396003)(346002)(451199018)(2906002)(4744005)(7416002)(5660300002)(52536014)(55016003)(83380400001)(66946007)(8936002)(41300700001)(82960400001)(54906003)(8676002)(4326008)(76116006)(110136005)(33656002)(316002)(66556008)(66446008)(122000001)(66476007)(64756008)(38100700002)(86362001)(186003)(478600001)(7696005)(6506007)(38070700005)(9686003)(26005)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?2ffyiyLDyu9LfUv8+LNTH+6JOUfQZYjlHr6C+POuz6l3HPEi5F/p3U8WRpna?=
 =?us-ascii?Q?K0NFpjnv0VjSLtzf6ZToAYRCFYy0XWdhiWNDGPWkHKqATerBWya4Ho2hUTRu?=
 =?us-ascii?Q?8N+6znux40dbkIg32BdMDJHM4c4tfAnjbbQSE0B7ch3AvL2NjNtIJFwDB9/m?=
 =?us-ascii?Q?EMjMYXtPR3qJZwcAKVSaS4u7H6deIcy1P9GkQn64R9YRBbOHkR0sE0jUn/pX?=
 =?us-ascii?Q?ow1lnAtVWoNMa0ECprEvIIj1PyhPau6uq1w/yhUc2Z8HGEjmiQsgZ8YCSN8l?=
 =?us-ascii?Q?6Jw4pe4juePXt0lL+OoTH5pBx9QSz8myrBgVBTZLi+NinL0ed5vOjW4clL2t?=
 =?us-ascii?Q?WOTUJuG4CVQ3vagmGnM+t3Ih8Ol5XoX+rtr/TUmmfflrVDFdDH9ASvFbcQ9L?=
 =?us-ascii?Q?kU7GJrabelmO374IN6XNlR5jOIaQn8+o+tB8btReYr2LFV8zU34cM6mfPVPy?=
 =?us-ascii?Q?39jOZSPKxZQQ2HpaF8EssLjGeADkY0NKRJwhsnRE/ANmSAOaZdGwpygYlXXq?=
 =?us-ascii?Q?Q11YmY06uMMoXLyFZPwLVP2bk64U5wEvB27Fof/vt6EC/6CGW4ePx1Cm7f4K?=
 =?us-ascii?Q?8fYIt9zcquovpHrcFCzOSTeJrSqWk8wvm017S7zxbPDXPreOQlhQM9LxlEuF?=
 =?us-ascii?Q?fqouJ5JvjWbWUpeqxjh304X7d8hs0dcmevhWtUKTe4NjOuemXPs3NrPyaHmC?=
 =?us-ascii?Q?HkPRnB07ihwy3J79Hpu7tD3dQWnQMRSCkeftCfxAI4aok0SIl+zbfsNALwTE?=
 =?us-ascii?Q?+8/9g/0yuYL4ltrJ1oVhIm5MbZQlqcagrmn80WSQFCqsdPT2bnmBT3h0/JjQ?=
 =?us-ascii?Q?nmXCRrafeCR/3q5jWfACLmfzYPtOSAbDVr2MiyYrenOckLZ1IHeglFINYRNh?=
 =?us-ascii?Q?bCYRZGYhV6XNaI/HpAJ7HWKYuZyktzSVnZhoj7dTNuyYsltZeOyfuZ4zBxC+?=
 =?us-ascii?Q?PDYfIqSaUnes6gmQHPnREoAYdy2++8bjwwBqrPsF9wPKrSKcO/86azPi9HPt?=
 =?us-ascii?Q?KU/LnctlXwK6OB7Okc8akQgfsPqv6WciCFkCZ5238qpCIx/oQKzb1vhwBAJ/?=
 =?us-ascii?Q?qKEBVh1nqkp7M/c/f+SDPHXXnX0g9odq4r2OzkfyuiLqEY+pdi2PFwu5a97N?=
 =?us-ascii?Q?n1S5oBw+zm1Ns/0BTd1ovIk6i5idVxri9slB4DxLcwxabMcapiRJ3O+n+yve?=
 =?us-ascii?Q?L6D4BKw6g66VtM26HmlwKg5ahKadXiIWy0Hl24NbtmINdiYFRZAseukgjuMq?=
 =?us-ascii?Q?W3PZqIUIcMCLLMrmJpuzS1ZC9BRNkYTTvTG4lUG6h7nysbFhubfxAjg+eia9?=
 =?us-ascii?Q?0Fqu8DyWpHw6GpnXO5GqRX0OQw0J8XJ7TTbzMkuDnD63pz5L2F/lMxk6psfU?=
 =?us-ascii?Q?7Lii2npkLO9NZBsQaC16e9Q0ZyTBeYaujJ/zycNFy3zE2sAYprpdzMD+VUXn?=
 =?us-ascii?Q?E1SbCFTnb0PTkJuIKSIevxufuf3R7gN/3xDZ/fL3NVW2FkT+yI70Km9aTP8r?=
 =?us-ascii?Q?biRrCclyJ8RzC5aHc1PajZDnJ6rsH9p+2SoxDCEf+ZfKhL/AwWNXG+K8kq5c?=
 =?us-ascii?Q?6gKkuo/0pkPv8baYc+KsLWbSEWmu+M4Wh4w6GWLm?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0552a87d-2c72-44e6-8408-08db10a89e78
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Feb 2023 05:34:20.2149
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lT4157hK7WA4vmd/xzHcFpg6PLW2WDdHXZSSdVIE1XZt34cZrayPXWHixVy4f2yA/cL+xtLksrq1sasbBaImcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7299
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, February 15, 2023 8:18 AM
>=20
> On Tue, Feb 14, 2023 at 04:42:35PM -0700, Alex Williamson wrote:
>=20
> > A device file opened through a group could be passed through this
> > interface though, right?
>=20
> Yes, I think so
>=20
> > Do we just chalk that up to user error?  Maybe the SPAPR extension
> > at least needs to be documented as relying on registering groups
> > rather than devices.
>=20
> The way these APIs work is you have to pass the same FD to all of
> them. The SPAPR stuff is no different, if you used a cdev with
> KVM_DEV_VFIO_GROUP_ADD then you have to use the same cdev fd with
> the
> SPAPR group_fd. Yi just didn't rename it.

This is because SPAPR cannot accept cdev fd yet. It explicitly requires
group fd and get iommu_group during the handling.

Regards,
Yi Liu
