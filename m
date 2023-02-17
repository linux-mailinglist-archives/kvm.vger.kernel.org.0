Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9358569A54C
	for <lists+kvm@lfdr.de>; Fri, 17 Feb 2023 06:49:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229554AbjBQFtG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Feb 2023 00:49:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjBQFtE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Feb 2023 00:49:04 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBFF2498AA;
        Thu, 16 Feb 2023 21:49:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676612943; x=1708148943;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Lsd6w3D+vYyy7MwkUzzGO+J+M2YqKiL1k33W8DF4CZM=;
  b=TjHH7IHvSw49kWY0FVv7nv6k2WOaap9kBSj/WcDmGrdkbSK6DjZxBylY
   1WPeGrKHmDgGbQXKBUohP98CUwxhwfgBqYXJTbJpjnw05nqbKhMywbh3W
   tC/Dv4zX4+haUmWU7gmThnmQwekATSJtoegkd9lzzUhqqzquouElJZtvK
   7urpoK7ADYwILNmmfu3jOpeiWDtwcjh39ug67uF2qUVlYvJJdbcolz+ag
   4H8zFgSm5KWDjifwk6W7wYJwCIJLzEbSQKfmaUSJGin9OjnGqTaZdpasr
   SSaOXAB6dvwy6vE0Dzs1bYVNUu2vpiumuuvmXJpDkwoDiZIpQGYOmwCHc
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10623"; a="396591547"
X-IronPort-AV: E=Sophos;i="5.97,304,1669104000"; 
   d="scan'208";a="396591547"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2023 21:49:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10623"; a="672481878"
X-IronPort-AV: E=Sophos;i="5.97,304,1669104000"; 
   d="scan'208";a="672481878"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga007.fm.intel.com with ESMTP; 16 Feb 2023 21:49:02 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 16 Feb 2023 21:49:02 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 16 Feb 2023 21:49:02 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 16 Feb 2023 21:49:02 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Riy8VSJmZushJCrOQwVg0tJV0RnDCS+NEjUIaXjfX7392zQmygIYeZvsRdSDTLP29re4CgnH7HMxXp1vfD/nt9/48qmoD/aCYALb+rpzFEg6PSqvd7nPNMW48cwA43MipR9y5AVCqVcNteV9oTnBoxIpGPprMlzi6S7Bk7KFGBe9VCLzAngMFDiO/By785lvgTOCZGia3DmgOunPZAw7Mbdzt0v8LyWoa16ikEq/WrystHdkbHwnZcW1Iccoo3sTqeEsts3schIzf8buBh99bKlMHHcyHyGsEmNr8wMAQn2JVJP5KAmIokxBQH/ZvQsA+qDYDfD6vMmQXQnGyYor1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cgM6wP48nFSW5QVFyI5RMNOGbzWtRnTRenpt+ei+Ktw=;
 b=g+mDU5aVVbrH2mMA04s912Esc8pRbU7ykChCxQ7e6oeRv9kj9y5jhGUWH6u17TBLBKRMOyUqEuUEQ0tcTRZ3AE1f/AqaQSxs2/wFXSXFENtMZtuEJR4zLInVQBofvBbAjIfW9PIvfVkQkNeR66y7vyjCwwJFpuDWDueIhoMlOV4IN8c455zaSSZumpKbACsaqam+ELn5cJTOValTVwrQnRq1NtDl228C/ZuzMw4+Z9AF0VYywYApSek/iHIPQO7m+0o5N8BMgMevbo9UCImKoz9UNPt4wqFVRZ8gRIgIF9ZWToklNh++7vf01G/RZazYEnqod+OnX89er3RAs6H68Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by BL1PR11MB6002.namprd11.prod.outlook.com (2603:10b6:208:386::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.13; Fri, 17 Feb
 2023 05:48:57 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3%4]) with mapi id 15.20.6111.013; Fri, 17 Feb 2023
 05:48:57 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>, Jason Gunthorpe <jgg@nvidia.com>,
        "Alex Williamson" <alex.williamson@redhat.com>
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
Thread-Index: AQHZP73PxotwwywX40uQF9TRO5UlQq7PB0WAgAAQc4CAAATTgIAACdQAgAN8qMCAAAI8QA==
Date:   Fri, 17 Feb 2023 05:48:57 +0000
Message-ID: <DS0PR11MB7529ECA0D4D0E1FB8B4B1A0DC3A19@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230213151348.56451-1-yi.l.liu@intel.com>
 <20230213151348.56451-6-yi.l.liu@intel.com>
 <20230214152627.3a399523.alex.williamson@redhat.com>
 <Y+wYX34sPvPQmGSr@nvidia.com>
 <20230214164235.64e2dccb.alex.williamson@redhat.com>
 <Y+wkqnCAe42Ogcof@nvidia.com>
 <DS0PR11MB752967E3A3A8B8693A523D54C3A19@DS0PR11MB7529.namprd11.prod.outlook.com>
In-Reply-To: <DS0PR11MB752967E3A3A8B8693A523D54C3A19@DS0PR11MB7529.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|BL1PR11MB6002:EE_
x-ms-office365-filtering-correlation-id: d9f47c6c-b1ab-4697-ad26-08db10aaa94e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1y6J83vKRLmtJeBzMLQi8xj0LrajTQNnRRjZ7gdHvGE7v0bi8vuNMpMjbVWYPu5Crv+qjCMpwEAYC+KAidTj7wmnhDnhNQFT9cpY0Aewfi0CERbNPjWTXoK4k/L6004fcSrXl5DwthSvBqHGy0vSvmZ2nsyioDbgLB6Evu7M0fCEhisBiUwvfX1C+syF5xuRFGJvgUq/0AaeqymM+rFTQVx/UgwQiNxKr47OtblQPQqejYc7wIx2ybXOVxM9E9UX9b9pKjh4/p6xF5m5iGjdPohDoyRDsS1Qe+E9LH1/2Eho9XbwcZZ7qYvTegWBTS8G8INy37d4p1T1DmP84UiBA9bMl1IV65HLpX2yxe4QUqd8RZAe3pxEtBZMNYSk1VRk1BMBqkiq4jwNaEc9xBAjtqh3eq31T9xsTUZ2lpZq+hzsCL7yZOKV1l43bSm1yH/N+8tSTdsLu84Q6JMSs4IVkl6OWebKei+mCIvLewtty/SbULItnzrmyB1Whp81zTW9R3DOUsKx9wOdTtqCPKb5+pjz0A9b+Y9Eem//nj97JtQ9mnAueziuqhPB4grlyBT0XIAezooMJ7wWdhk8DgpL65SN92vNUeQESGFeWFONWF9hhGtgYfRM0aKud5aeVzuoAsgtgR2Oq/sCoE+4O/d1eYXc550DUjffZNyr/cAilcMTkjKzJEECGtqZzSWHbwF75V3zHF9jYGBMyK0QemwDqQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(376002)(366004)(136003)(39860400002)(396003)(451199018)(2906002)(83380400001)(86362001)(55016003)(478600001)(82960400001)(38100700002)(122000001)(38070700005)(76116006)(66556008)(66446008)(8676002)(316002)(110136005)(66946007)(66476007)(54906003)(5660300002)(8936002)(7416002)(4326008)(64756008)(41300700001)(52536014)(6506007)(186003)(9686003)(26005)(2940100002)(7696005)(71200400001)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?X+t7MnOZry9+TZEkzZTs8FTxX7mgYx72U0ytsvOS/oG4mwWrNDOtnfZ4mCKk?=
 =?us-ascii?Q?eq1fGnwPq8Sly1k8sp2OhO+FS67A0Gc8Bl1twNmfomUAC3y8WZ8Eh60iXyx8?=
 =?us-ascii?Q?lm26nRwiIxXd2n42nmIwczsnjLc8ORdcjYnfH0mc1oEqbk/fruT00gQnU0Y5?=
 =?us-ascii?Q?05RdxaOW+/Ypnva0eeFT/XDsPNcD2184FTyrPBTsEydBxKtn9jo72/MdkbBM?=
 =?us-ascii?Q?WldANprojcyp9+e18ZgtnNBzCHm7d1EBaJxXVoKMtnxLn8HQGhPr4uIMfAKa?=
 =?us-ascii?Q?QGm5cXHL8SmKu7OXfp9zAf+gpi5rlBEvyiGSi7aMfEXXUQzkJRxe3fLoU8AC?=
 =?us-ascii?Q?8371UqLT58RrK6IVw3cEcMvqN52mjVjzhBku3afxKd99xKvhbny9QWMwGkDV?=
 =?us-ascii?Q?YLohdh6HvMz+1UxevGMvmnA+ZV5U/nfSYgu9Ibj0TmyMmq9yHOGY1Cxm3eLM?=
 =?us-ascii?Q?EaC8AFchQw4gyoJ119Au3HlCYQIbaIHJY43kv3umNqT3lc4cNOoeS+2CMGOY?=
 =?us-ascii?Q?Z8qkq6d88KV+30iQLH1zQmvKMFSJKFQDi4qCOUMRorOPp4Q6+IVb/7SlCJty?=
 =?us-ascii?Q?RaO+tvZ2Bcifjmu6jM68gti7NKsCcNWAOlpVQtI1SbDjY21DACY9hGBTj8Fp?=
 =?us-ascii?Q?/jX8BG41zXmKqdsPnufOfygwQo7jxTiGxzXtmvplb1sy2XEXCk3VUIoCFLm/?=
 =?us-ascii?Q?hO5WN9ynq+rXKYGnbUqIaA+7+RBrkviHCHAJSlvPVhFF5HV+oIzAT5o16XhI?=
 =?us-ascii?Q?Ntq82+s4sffmLsvDOCeMtD/Kbz99SM/LqejanTSMFj+msyisA7qhoYailiH8?=
 =?us-ascii?Q?2gAxf4Di3gNWxQMmhFy267QTvoFtUYOa0zmeXRaOxe9m/oEgNgbBIx38wgAA?=
 =?us-ascii?Q?i/Un3SAKHDrheZd5Xy+PQBczHhz5RtwoZB43EfNVsjNh6QxLv8cud3atyW8y?=
 =?us-ascii?Q?7wPyzxfydLZg+e2M7v2ILWs/D0lZj/hPnIXwzOct6QXussCGzin1mN+dmNIh?=
 =?us-ascii?Q?eBxWtsdG1qsSEvEuDWGv4KqBJSyE6ooNR+7GEBF0iECO6FiRMUwy7BGMxDS+?=
 =?us-ascii?Q?0YNmwgineAQ6HNYTS1rsU8OkDVrmVafWTaL6gvzTNS0UbDrcsIz+nTR0/fyU?=
 =?us-ascii?Q?xWHFJ5F42/nxu7K8AS0KMeLeX+LJbMR6E7HA5a3tGkLxOF0sVcBzkpaX8Q1l?=
 =?us-ascii?Q?oARU0FmVsfNGgX5YgbdcFWOSR+oZ9eKWsDFqmS34bUsU1iey86wXht+XI6f7?=
 =?us-ascii?Q?lSTBY7Cx55yXA8j6qzFVHCl2j6KpFeZldP/I3pgGp+ugUWNAY5l2F1v+N4lu?=
 =?us-ascii?Q?Uuxc+9ZeogviMy78ixKWiAb1KF8TrLcKAhpqr/SfcJcEJcuilJf4S0oRVY0L?=
 =?us-ascii?Q?HP49wfq39MnCSNIU24tCNHcJ150q5nJ8pd73TvKeF2SCrOmol8qcBtyqWIRH?=
 =?us-ascii?Q?Y7mvENKrD6tDHEq+E6ls8UtFfWfxmvm8wQ70mlq8ezW8yba0rU0/2Alhz8fF?=
 =?us-ascii?Q?/lt6aE+s4Ia5akUwn+pVredT598TGAj2YHiLJVKoN4o98sotwdXz2K+JA6Wr?=
 =?us-ascii?Q?RmTPiPEkefiBpRGYy/CWxJG/dqu2qjb6LdyXmZ+l?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9f47c6c-b1ab-4697-ad26-08db10aaa94e
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Feb 2023 05:48:57.3891
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CPIU0OZ+SBp2VKM4nxU4Fnp+gI5N/qg1gbwb+87J4nLCaJ2eFn7xmCI+B1JYKdMQStRhozxX4PEMQOAmUEICzQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB6002
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Friday, February 17, 2023 1:34 PM
>=20
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Wednesday, February 15, 2023 8:18 AM
> >
> > On Tue, Feb 14, 2023 at 04:42:35PM -0700, Alex Williamson wrote:
> >
> > > A device file opened through a group could be passed through this
> > > interface though, right?
> >
> > Yes, I think so
> >
> > > Do we just chalk that up to user error?  Maybe the SPAPR extension
> > > at least needs to be documented as relying on registering groups
> > > rather than devices.
> >
> > The way these APIs work is you have to pass the same FD to all of
> > them. The SPAPR stuff is no different, if you used a cdev with
> > KVM_DEV_VFIO_GROUP_ADD then you have to use the same cdev fd
> with
> > the
> > SPAPR group_fd. Yi just didn't rename it.
>=20
> This is because SPAPR cannot accept cdev fd yet. It explicitly requires
> group fd and get iommu_group during the handling.

Sorry I misunderstood it. I think this can be renamed to be fds if
no objection. Maybe as below, so that old userspace that uses
group_fds can still compile. I doubt if a new flag is needed to
identify the provided fds are group or device fds. I guess no since
the pci hot reset code does not really care about it. It cares more
the fd is held by the application.

struct vfio_pci_hot_reset {
	__u32   argsz;
	__u32   flags;
	__u32   count;
	union {
		__s32   group_fds[];
		__s32   fds[];
	};
};

Regards,
Yi Liu
