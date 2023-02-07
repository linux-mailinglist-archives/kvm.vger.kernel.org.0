Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BC8368D9F4
	for <lists+kvm@lfdr.de>; Tue,  7 Feb 2023 14:57:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232459AbjBGN5a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Feb 2023 08:57:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232312AbjBGN4x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Feb 2023 08:56:53 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A2C53B665
        for <kvm@vger.kernel.org>; Tue,  7 Feb 2023 05:56:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675778185; x=1707314185;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ZJ06Ip1pwITOlLyZjMF2uTQPzwZOWUmNEMlwvLi3V/o=;
  b=CtCFYvTerXdPjU5KhJLpmUkRJnW3K68VdWQ1Cavxifrg+Ob990HduOfO
   ejaqxvL5LgoHJ2StSw/vfrUADwSN+ybotPSYj/TARc91DyGyVwW24xGoR
   BqcQRW6yVlFx4y0s/5ZuqVoUpkxRxbl1nb/X85vdmm+Y/5my+xV1RAa1s
   pk5qE8brbLTnmFSaMTOWnpROHmFrmmWeI054stTkDEBN6RRIaL3+9daom
   Sn0oxtM8P+Mqwzo+a4VmjWgavvwtmVr+go9HAcSMoIi1ABpAiFoLu93Aw
   dnzMTOp8vwUVFwU/GSpM5pGdIiW0NfbCPJ8Gi5XQMEDTuOKn5LCXEi6EE
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10614"; a="329526160"
X-IronPort-AV: E=Sophos;i="5.97,278,1669104000"; 
   d="scan'208";a="329526160"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2023 05:55:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10614"; a="995734189"
X-IronPort-AV: E=Sophos;i="5.97,278,1669104000"; 
   d="scan'208";a="995734189"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga005.fm.intel.com with ESMTP; 07 Feb 2023 05:55:35 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 7 Feb 2023 05:55:35 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 7 Feb 2023 05:55:34 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 7 Feb 2023 05:55:34 -0800
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.40) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 7 Feb 2023 05:55:34 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IJWozzAKbMHyFnqn9cQx9nY3R8H3eBg1Sm2n9TtX/+ebisV40gS/UyLMQ4ZwhQgmjWmk9PzE7r6FAxa4PcIC/lQ78/ZHzRHWppBALmJGGUUfUExCmKXuQlmnpvcQzT+UF1g8Z2KW4KI82mmwEMw++6d4SGsol4nS3XRggD/AwS24iSfn2WXsD8Srk+YWs0+KQizUcQ6ajNp4kLX4XmcsPFB6hZWoktslWChq16kcOKdwJTvCwTWkYZUroyQYMKwcvZ8laeuVuiCJCX14wAjF3WAEXB3lIB5Zm6qFeCkowKh+1jF7/jUygJ/Q4hEWL/t6f2Svs0BTDa4h/PksZNq0ZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YlcuYu4f2OLg0hhWLFbSUdLjtSBr40y9P+XZ96bAvok=;
 b=BLXkxK4qAFInmuiq5Hj0uz9HIOTfIuGBpKOYpqIonMDwX9mvUGNds1LTCcBMSEzsAeA1ylqDR7AF7mexT/9Xg8HyboGI9/dCm0sPYE9RNXGpTh6B4tBlHHbvHAfsepqxZT5iDSb7Y1AR76A+UzosCc4RVOfWDHGZwGk8PDruZ0kXKkUTLY5QP3PCav2FVebhdJdUwNm11N/aiGmarwTaIB4AebH+eLSe4LyuCrS35lgnM8RAK/KNai/oaBT+51Ol3dgHymt4Pb/bK+Neg5fX+taIVquw6IC9KNKl2t3H1cA6mfA2RCmXCxnmsoE51ulz+q0ulWBGwkFiWYnbGNeGXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by PH7PR11MB7099.namprd11.prod.outlook.com (2603:10b6:510:20e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.32; Tue, 7 Feb
 2023 13:55:32 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3%3]) with mapi id 15.20.6064.034; Tue, 7 Feb 2023
 13:55:32 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "Tian, Kevin" <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>
Subject: RE: [PATCH 10/13] vfio: Make vfio_device_open() exclusive between
 group path and device cdev path
Thread-Topic: [PATCH 10/13] vfio: Make vfio_device_open() exclusive between
 group path and device cdev path
Thread-Index: AQHZKnqawLpQ51DKRkSs/ALC/dgVdq6mbRKAgBCCdhCABEMGcIACZfGAgAPY7eCAAF/tAIAAVAKAgAAKR0CAAJOnAIAA02sAgAAAXACAAAHQAIAAAFDQgAABlACAAAOewA==
Date:   Tue, 7 Feb 2023 13:55:32 +0000
Message-ID: <DS0PR11MB7529FAD0089689A81EE28F34C3DB9@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <Y91HQUFrY5jbwoHF@nvidia.com>
 <DS0PR11MB75291EFC06C5877AF01270CFC3DA9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <BN9PR11MB527617553145A90FD72A66958CDA9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <Y+EYaTl4+BMZvJWn@nvidia.com>
 <DS0PR11MB75298BF1A29E894EBA1852D4C3DA9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <BN9PR11MB5276FA68E8CAD6394A8887848CDB9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <Y+JOPhSXuzukMlXR@nvidia.com>
 <DS0PR11MB752996D3E24EBE565B97AEE4C3DB9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <Y+JQECl0mX4pjWgt@nvidia.com>
 <DS0PR11MB7529FA831FCFEDC92B0ECBF2C3DB9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <Y+JRpqIIX8zi2NcH@nvidia.com>
In-Reply-To: <Y+JRpqIIX8zi2NcH@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|PH7PR11MB7099:EE_
x-ms-office365-filtering-correlation-id: 52e8891c-19b8-46fe-f6e2-08db0912faa5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UFtkXByJYPzv+O3vhSGRSr86y98DRV9iYXwPLvMtLDBYr3wsS9W7ypJZ4o2/CXxvDnKK5yMt4+yAOSSxqYxsZxKPlNB29bpRCDod5nSTLX058jAc5cS9YhE9hN8K1t/qQ1mO5DpJDqwLeGVitLWXgkEgvvD5SorqTZ+XI+zMfFKv2F/0vzIgfs2/GTQL51ZWj45LMAQqrF7yxkQTOj8GyIhzNxR4UhcUFxvvLkmDE2fC1/t6EIdqykaWsUZjXAzMgDNEZhKyni1+a9LErsP8LZGShx33KBP1kO0pk0LNxnDIG+XebLhwpyrbQEEK2EZ1BrNqRPZoABUmQCI+daE5LPGUWv1gpGF6G/h3jWeqm1B1AOOBa/qBGysr00ALjDbSmHTnnMSurjznuqJ0RHQiKZkDfUWDxrWpEdylCQmOqDUghfAD2VQ2sHMKGtIVs4gCUISRQRvEf7qQFIK44swmcE6T2vl2PLVxaH/8yZDiR28hzYTO5L7LIvTbfrpAS1LkiQ0QT98QEOTLrNCSpMJGgD+7M9x6fvEOSTZvMG8QSzv29tmPbUrkrs8T+OheYsWfyAT3m4+B2BCjIhY5T77I2yiPToR7seK5yON+eGI6q8mCgexr4+QYM8l3WVYC2q2Z9fHTi75YwOMOkoroEhVXE5TKicUHXJloBLBxp6wPkff4qcNQLq7vrG0iUa0EBsfyP8FwaQMNVYN3pNLWjA227g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(39860400002)(396003)(136003)(346002)(366004)(451199018)(54906003)(52536014)(316002)(33656002)(86362001)(82960400001)(478600001)(7696005)(71200400001)(186003)(38100700002)(122000001)(9686003)(26005)(7416002)(38070700005)(5660300002)(6506007)(55016003)(2906002)(66946007)(8936002)(76116006)(4326008)(41300700001)(6916009)(64756008)(66476007)(66556008)(8676002)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?QcWdeb/VZ9YX3xKJ2GcZJQYaQ9VKiozqfXPXyttZ5c1A5b+rK73onQ/erFrM?=
 =?us-ascii?Q?ehfu7WLUpBo/YYy62mPxL3fy8L+42JgsjwfCrtoj8Sdv4UbznR+Q8LXr+AwD?=
 =?us-ascii?Q?W1usTVpIY8tbee5QbRmaSQo4qSGvuVLyiw8ez13Xs7SWcbwSsGqeZezRTJSo?=
 =?us-ascii?Q?ZTFKWTr98ZNux0MNvt/zuPHQJBYTN4eSGRdfz8Gn64RFsO/QakgNhWwvXf4d?=
 =?us-ascii?Q?ybX9NQneV0JHJtaAbr2ExFJA/cmVxJORtu09WwhFn9hKYDXypmUtCNWYmj6M?=
 =?us-ascii?Q?Q5JvgVjG2SnNB9mR3TBaFl91oS0v1WTnKPigzPa/vJp5aM18SSwjY9PhZCRx?=
 =?us-ascii?Q?lAOF3uMwFp3P6mEBKPF4WZT7aguVNzHx6AFvhwsNkwG20nWvJdCmRhdA5BCm?=
 =?us-ascii?Q?edoyq93Fq4rdvymhqF+5lHSf4V2AnTOnOCRmdFV3tlGDArexhS3LxJJDkI1o?=
 =?us-ascii?Q?2QQAc5d9GP/z/keyWtgPzvAUjFZKYhCgaMx80CHolK5NknJGNb0o5yKnutwT?=
 =?us-ascii?Q?0IYZElEQOhggY+pL56Lt0ha87jW4BjlGnOkrTNUuX+JvisPahZP5TmnggqZ0?=
 =?us-ascii?Q?1hMgHDpmb4g5hSRixkFii0PwyEUHYPpgMKljR/JMX1Ux4jsXXENC7IRGVrU0?=
 =?us-ascii?Q?bfn2bZ0P/takfvdsotDAGbOZES1aOz25lelBGtMnq4vgU+BgsbqMW2YBM3pM?=
 =?us-ascii?Q?Tasw4Q3t5BnUMiSQYYcxNqd791Ha5DHlPqF1Q+ZwZA5f4hWj1iAwrcye5O2q?=
 =?us-ascii?Q?kW7z2Bib0/TYwIzdfcarCiMLf4pK7YOypNMtJFeIpAINqNbYTHvAhG0pLRai?=
 =?us-ascii?Q?kw9kmWs2kk6LlKyYGCPlrcrzIJIEUZ2gkRkOvnch7OdDQU8seRitBEIar0Pi?=
 =?us-ascii?Q?dPGT9e/h5WG89/osRh410q+uTrMh+FSmLWJiQRH78AkdmY6GzhpgKLeolS9B?=
 =?us-ascii?Q?4IThyls1iHXPkOvhOFdR+E+QzL6w7uXWdU74Hk+QeU0sRJIFYTSHZFO+SQNl?=
 =?us-ascii?Q?EmGTwzN9VvVGERDr4AoscV5lLIGBrG6VOztzh3mzq9HMOXBYT2gdQmT8QCIS?=
 =?us-ascii?Q?PzetTrvRDrurZz9XIdGtKKCvqWhOiN1VGhtyNcMCptMAP5YEgKqt4n1Q4Q4Z?=
 =?us-ascii?Q?ca+r/XJgHFPuuE1CK3NN9zMGPxfzeNewrRMbog55JvYlJrpsVIkp/WzkbYcV?=
 =?us-ascii?Q?wZ5rf8Dz22ck5RkrO1SFNQohoxv0ZWkNnZEF+AgEsOwCfkdykSF9sB57HXD1?=
 =?us-ascii?Q?S0R+M3k6YOXa/lZKU+IsxIOxJ/WR1DpGOWQWS3k1fCPhr6w2XH94J44961eN?=
 =?us-ascii?Q?fsTvSz5i0FDnL+TSv2ZhaRvSXCH0tzMr396ktyKU9nNIkE/YPwl07wFOqXk5?=
 =?us-ascii?Q?Wn+owZ1FUuI/lyW25+bBRij+Z59R1yYUmuAYdNWNwNSHxoTXBORZT4OUYj1w?=
 =?us-ascii?Q?t5788Xfb76bQdIMVHYQG1IX7/DREVmUbBHTHgfrsA2fifuTuDQ+pOtPnujLE?=
 =?us-ascii?Q?i1lS8JzejlyCP0dO+C5DVD09QzoFINMCrZq2FC086LgK4akg89MhTcf+GHmd?=
 =?us-ascii?Q?iORxnScbmr2pMhCy2m0TpMOmrBaz8533U7kMO+9K?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52e8891c-19b8-46fe-f6e2-08db0912faa5
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Feb 2023 13:55:32.1986
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cnVaJljST7Mu6yIiFl8vyibBvXI0K2zI73PW8mrU4oxC4zl+tULO/9agpwX4lGySutMfMuKKB2V3xYm1XIsd8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7099
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
> Sent: Tuesday, February 7, 2023 9:27 PM
>
> On Tue, Feb 07, 2023 at 01:23:35PM +0000, Liu, Yi L wrote:
> > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > Sent: Tuesday, February 7, 2023 9:20 PM
> > >
> > > On Tue, Feb 07, 2023 at 01:19:10PM +0000, Liu, Yi L wrote:
> > > > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > > > Sent: Tuesday, February 7, 2023 9:13 PM
> > > > >
> > > > > On Tue, Feb 07, 2023 at 12:35:48AM +0000, Tian, Kevin wrote:
> > > > > > > From: Liu, Yi L <yi.l.liu@intel.com>
> > > > > > > Sent: Monday, February 6, 2023 11:51 PM
> > > > > > >
> > > > > > > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > > > > > > Sent: Monday, February 6, 2023 11:11 PM
> > > > > > > >
> > > > > > > > On Mon, Feb 06, 2023 at 10:09:52AM +0000, Tian, Kevin wrote=
:
> > > > > > > > > It's probably simpler if we always mark DMA owner with
> > > vfio_group
> > > > > > > > > for the group path, no matter vfio type1 or iommufd compa=
t
> is
> > > used.
> > > > > > > > > This should avoid all the tricky corner cases between the=
 two
> > > paths.
> > > > > > > >
> > > > > > > > Yes
> > > > > > >
> > > > > > > Then, we have two choices:
> > > > > > >
> > > > > > > 1) extend iommufd_device_bind() to allow a caller-specified
> DMA
> > > > > marker
> > > > > > > 2) claim DMA owner before calling iommufd_device_bind(), stil=
l
> > > need to
> > > > > > >      extend iommufd_device_bind() to accept a flag to bypass
> DMA
> > > > > owner
> > > > > > > claim
> > > > > > >
> > > > > > > which one would be better? or do we have a third choice?
> > > > > > >
> > > > > >
> > > > > > first one
> > > > >
> > > > > Why can't this all be handled in vfio??
> > > >
> > > > Are you preferring the second one? Surely VFIO can claim DMA owner
> > > > by itself. But it is the vfio iommufd compat mode, so it still need=
s to call
> > > > iommufd_device_bind(). And it should bypass DMA owner claim since
> > > > it's already done.
> > >
> > > No, I mean why can't vfio just call iommufd exactly once regardless o=
f
> > > what mode it is running in?
> >
> > This seems to be moving the DMA owner claim out of
> iommufd_device_bind().
> > Is it? Then either group and cdev can claim DMA owner with their own
> DMA
> > marker.
>=20
> No, it has nothing to do with DMA ownership

sorry, I'm a bit lost here. Back to Kevin's suggestion. He suggested below.

"It's probably simpler if we always mark DMA owner with vfio_group
for the group path, no matter vfio type1 or iommufd compat is used.
This should avoid all the tricky corner cases between the two paths."

This means to enforce the group path uses vfio_group as DMA ownership
marker, while cdev path uses iommufd as DMA marker. Then there
will be no possibility that the vfio iommufd compat mode group path
can share the same DMA ownerhsip marker with cdev path. With this
the devices within the same group can only be opened either by group
path or cdev path, but no mixture.

Regards,
Yi Liu
