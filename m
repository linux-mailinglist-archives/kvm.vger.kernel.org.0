Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2567549C0E3
	for <lists+kvm@lfdr.de>; Wed, 26 Jan 2022 02:49:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236011AbiAZBtU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jan 2022 20:49:20 -0500
Received: from mga05.intel.com ([192.55.52.43]:26495 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236010AbiAZBtM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jan 2022 20:49:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643161751; x=1674697751;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=mxMUUzy+rW7ETsiH129ah0rVstY5U4AsLvLOTviAQIY=;
  b=N2gj0/hTqujkGmhrEex/ZCti6T9OtVyFgaufGcnL1IxzEya1H7jt5fMJ
   kbAg3lb/3urvp2Ifjolqetk8CH2lc3pVJpIDrkQWAIkbfZdrRpo3l5L87
   aVV20G5ihI1mzEv6Ids20zp74F1vr8VBBELjSx1pRhnVv3+JnQJ2udxUA
   hMotncRpE7YCnfjjl7KsG9DYRrn+sG+E149AuR38nUOs1jLX5QlB75ZgQ
   fMkbhkvMSrdic6mhqu5/7PkHrc5ph3T1GCuEx+dthhhowMT9OX7lTgzMi
   OlcmwegLetrlo4rfys1TdzWIn/i7NtADToPX33zoA0CdVMjDJIyR6rws3
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10238"; a="332813795"
X-IronPort-AV: E=Sophos;i="5.88,316,1635231600"; 
   d="scan'208";a="332813795"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2022 17:49:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,316,1635231600"; 
   d="scan'208";a="624685832"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga002.fm.intel.com with ESMTP; 25 Jan 2022 17:49:11 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 25 Jan 2022 17:49:11 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Tue, 25 Jan 2022 17:49:11 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.175)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Tue, 25 Jan 2022 17:49:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a8fOGMb7SOCHdQRnWNoI47vMGqmCZhtciV6nmFdpBZvZks0z1q7nrXFBSQLZe2mte4At77kwXzm9y6sT6KE9QkWh8WJrkhnxbiOzJykD4vg4I2pt9eimxTjTIU/2rcYtjhgWSHNfgaGUrycY7vXtZD1HUZqGAcZ0IDTF5sLRQj2V6QwR2J1pY05Bk7fqfIBaQi1K1g66Nvlrl4ORb2RZZxNLotzcOymmDZkKGVa7A5vL/3slGBfwoFzJGVJ9Yy7LK5xfi4lJONMH2NhQgnm0/SPr3w7Eip/o6Th8IoUGCUGU5W+cgzcIfrqYErzcY5fvCAlV63y0qsq/2ryRDd+9lA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GiB2ljPUJAerm5H5r2i6b+jB+80P4JletkoLxdMGV4E=;
 b=IVJ/GraJ6z55EyOGCAeffdUpobFYuUwhPh9e3neww04nPtCFcwdLWIKhDg3o79vHX06ukypjw+Pd0rT5eEdu275z3QXzaPdX+thl7QNFveVSJFZdl4VHKbOsRWIzTLcdabskT56vTtYgs7EzkW9Y7VwZQ0eAQxmQ8rYRNas/IQdjpOKF4qc6FMu1Mz/+SYcQ1+5jrooeCXikJFVQk9CdE0a7sOb35QM9inFAbYMOT91BG+kDVhFVbJNFuDehRwnK+pwKMqyTWfX7T9R198d5LHcUu+JqxKo9DUgJ2sGrMr0Wg2sFaGR1yqLg1W181YhGj7ZYl4Z/OsQl8OeZFpcwCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BL0PR11MB2995.namprd11.prod.outlook.com (2603:10b6:208:7a::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.17; Wed, 26 Jan
 2022 01:49:09 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::e46b:a312:2f85:76dc]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::e46b:a312:2f85:76dc%4]) with mapi id 15.20.4909.019; Wed, 26 Jan 2022
 01:49:09 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: RE: [PATCH RFC] vfio: Revise and update the migration uAPI
 description
Thread-Topic: [PATCH RFC] vfio: Revise and update the migration uAPI
 description
Thread-Index: AQHYCX3pQbl/KJiueUy+Ou1rwdnoq6xzKCRggACfIwCAAMkU4IAABfUAgAAA/XA=
Date:   Wed, 26 Jan 2022 01:49:09 +0000
Message-ID: <BN9PR11MB5276CC27EA06D32608E118648C209@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v1-a4f7cab64938+3f-vfio_mig_states_jgg@nvidia.com>
 <BN9PR11MB5276BD5DB1F51694501849568C5F9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220125131158.GJ84788@nvidia.com>
 <BN9PR11MB5276AFC1BDE4B4D9634947C28C209@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220126013258.GN84788@nvidia.com>
In-Reply-To: <20220126013258.GN84788@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 28661110-16a0-45ff-eeaf-08d9e06e0ba9
x-ms-traffictypediagnostic: BL0PR11MB2995:EE_
x-microsoft-antispam-prvs: <BL0PR11MB29951282B08AE865CDDBE9538C209@BL0PR11MB2995.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VXg9dRkKTlsPVipCkH325Z6QzW4n/i1yLAHyZUYjZVIuhJeWEQEGHBHUvH3xRrcUPO9W+0Pmw0mzgZAFWRdiOOMJhcRsLA7zskV41sEYCtm918JEuTUxFQj7Xm8IzKcZ8dRxHA+2NdpFQmLydTk7q5GUwaJXrMM8zgCS9J/PGaIiH3BVMVHRdSISrXS1ZR139zEsZeqCR1X2jeZISITS5yaomRVq4i+PzhT4L5ge8grFcJhKdAy5yF8xE1sw2u8nsgxRzBgtO+QFKPfcVFK/oin5zNhQzuH77nRe1kLvQeDjQAY+4HHNBPXmPurqIlLdrPdeR31bQ/Ebhj5gn/ee1+PoP8Xxioq1iCV2TBgeBFr3UpEN7gvx5ibxm7ZI16nPk0FIcw5LNk0xLeOkCQi/UALqfCewSmAm3JY/JI9gCNbNUEBfOrvEEoMQ5oR3nxne7HXgAQUln1HqphI9ERSWXLrInK3u1cnQ3FLtJblA8ujJXtbRmIp4I4pClCk6wNVAGE0aBoG0DlJAN5GhOjJ0MZ09JG9QGaX3BaAqBP5YQeY0DTGXkFubeHY5O58bw1XyLIf50MCFKdGEzxvyrDyJLkIaEYQY1YyCJKR85Nh8WuZ/OXKyMDrfYSutgAkfk1VKWUvGkETGRfKecgxlqUNpnN9UHF1aC0TydbQ3B6WS3KnC9j4Arrq8aVN02l1lm15DJ2rD+KbAFiEQ0SS4tfd2Uw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(33656002)(6506007)(5660300002)(66476007)(54906003)(38100700002)(55016003)(9686003)(508600001)(316002)(8936002)(122000001)(8676002)(83380400001)(86362001)(2906002)(52536014)(186003)(76116006)(71200400001)(64756008)(66946007)(66446008)(38070700005)(4326008)(7696005)(82960400001)(66556008)(6916009)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?2gomUcAJAt4PMSJQMU17XfzhUoCf7kOZPNUGjqp9C35U6/GO3l3fDBCoQLBi?=
 =?us-ascii?Q?SD4wWSdgJ8TXZX+zG56Xv7JRGfN75IafjSqHw3uVnnQGCdyhADO48J+ueaB9?=
 =?us-ascii?Q?ykSIYuWB6TtbqLV5ZBX9gf+CgM+oCZh6CNwBEmLDh+roFgcEavvTUGFcM8LG?=
 =?us-ascii?Q?aDLU9K7Y67T3IgFRvhTveiYxIc8URlwcFJbHrtOH7FtrAIHcBpjQSZlArboj?=
 =?us-ascii?Q?jHk6E+xxuS+PynZAr/fztqV5KKE8/XlNhjGiccRpRmCBi5O85wkSvzqieQ17?=
 =?us-ascii?Q?JqysC1eAfGWftxE92I9T4mng+nwGTjN5d2uPlSpzHipiO6r28qWpkhrZEsF3?=
 =?us-ascii?Q?mRJYIZjLDar4hk2eFaxBakYkdIHaGjcB48+nhlG5OMpPQGWUd345a1XD6/Jl?=
 =?us-ascii?Q?lI6RAnrx7D4OMmwoWHirWzC8uxAKzfnFhdnqNzCMxaQNoWDkaolQa1WREUVo?=
 =?us-ascii?Q?R8btUmKtnKF+ORr94o3vtRN07ohrpf0q17lB5q2o0zmATmSI181skq85cr7z?=
 =?us-ascii?Q?+uthxiDxsQFBCQmd68vOwsSAqSCIrnuU+41zopcZcqlcYNrLcej2SfSzJmhF?=
 =?us-ascii?Q?eTuVsrJXdqxdQfYy2IgMgt3km/shd4EPs6N3mboPa4UwKQwUF+xeqEEUBaqr?=
 =?us-ascii?Q?WETxL5L8+fDGZebrXaWTvvsBr606zfShqpnD2tnpWroeM366G/oNOsO+o/F8?=
 =?us-ascii?Q?IBUQ8LoVmkaU0Z7Z+TVm6RP54ujBLlPDa4xxrG76LNCZa8L9dld2aqmcYoDP?=
 =?us-ascii?Q?HvxdPvrXncv3RJUbxUTvOiscFL4bQ8h+POXWlGOG2rTRmKyw4/1xX3Ct8AWj?=
 =?us-ascii?Q?hPiaYFJwZC9o89QPrqnWn/XwsZnjNd1KlrHm4f7PCUvyfKFcPqO/1yuT8Dbo?=
 =?us-ascii?Q?9vJohd+wXIzNQH88lmTqdwOSCg10QOtrQywQvl7uGbjE98o7Q2iGPPvPSGRA?=
 =?us-ascii?Q?mbVWpZ22QMS8xFmuQep0wdn8aee/QTs77KXK1KwhvH7GuG5MBhR3hOd7CPJn?=
 =?us-ascii?Q?bhiJ5fm49M7L7g/DjJqm32ZIzYE1l967WXaKWU6ORg7GCxZWBPqiMoBYYNB2?=
 =?us-ascii?Q?I6n15Gc+0TlwGe7nukBEuE19evETgr6VYTO+tuyzriZXnHu6b42lB1x3Dmlw?=
 =?us-ascii?Q?vrR7cLkNC71u/HT9hjytaZ8e+Pkj7Fvpu6ffoLRj28KYXBkFzMc1Xw1b9H4V?=
 =?us-ascii?Q?WAEmAdrmJHUvkt2JIglOuyUV77nQB5FfTQrddYNojGvOfQ43PbKj3SjVd4It?=
 =?us-ascii?Q?q7K1coom0Z2nlkB+P3YNS0I2PPdfwD1QNvT86HVRDNJoJldz/6EZhslYsUJa?=
 =?us-ascii?Q?zQxHpHi3lDfz/N5epPYhigwXFaMkbnDBAKvsPSLSB47n4e+jtUdEaMeJx720?=
 =?us-ascii?Q?TBwKnctGYOrFIuEdZ1dzir71IYPZjlYgLdjnGtz+QeACwVRjQDBn6B+2h7Kh?=
 =?us-ascii?Q?9Y7Chk6bQbVXVa0/ca5RjAs1xZW2qDf/+sW/C78M3Szr0j8LfhYIpiDrcQst?=
 =?us-ascii?Q?LWplmUPE7Nc6Zgnxc+5teVUG0tCEmIcutjxIba8xPUFhOyURu6m5QDKOOWP8?=
 =?us-ascii?Q?+qoC5I7oEN5hVt2pplp+AqSCIh6bqAr8sR7o0C4+AVE1fuaLeMW2SzuzvbZa?=
 =?us-ascii?Q?kyTV0OwofeFIqP23WZS1/68=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28661110-16a0-45ff-eeaf-08d9e06e0ba9
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jan 2022 01:49:09.5408
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: frX4FiJqkKfroWW8UqUXsbZTASSkrL5XQCbM3hOWiSWKIOJKGuhMk8psBQ1DkT9HZelj6wXO25GNQK1FBFEAjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR11MB2995
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, January 26, 2022 9:33 AM
>=20
> On Wed, Jan 26, 2022 at 01:17:26AM +0000, Tian, Kevin wrote:
> > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > Sent: Tuesday, January 25, 2022 9:12 PM
> > >
> > > On Tue, Jan 25, 2022 at 03:55:31AM +0000, Tian, Kevin wrote:
> > > > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > > > Sent: Saturday, January 15, 2022 3:35 AM
> > > > > + *
> > > > > + *   The peer to peer (P2P) quiescent state is intended to be a
> quiescent
> > > > > + *   state for the device for the purposes of managing multiple
> devices
> > > > > within
> > > > > + *   a user context where peer-to-peer DMA between devices may b=
e
> > > active.
> > > > > The
> > > > > + *   PRE_COPY_P2P and RUNNING_P2P states must prevent the device
> > > from
> > > > > + *   initiating any new P2P DMA transactions. If the device can
> identify
> > > P2P
> > > > > + *   transactions then it can stop only P2P DMA, otherwise it mu=
st
> stop
> > > all
> > > > > + *   DMA.  The migration driver must complete any such outstandi=
ng
> > > > > operations
> > > > > + *   prior to completing the FSM arc into either P2P state.
> > > > > + *
> > > >
> > > > Now NDMA is renamed to P2P... but we did discuss the potential
> > > > usage of using this state on devices which cannot stop DMA quickly
> > > > thus needs to drain pending page requests which further requires
> > > > running vCPUs if the fault is on guest I/O page table.
> > >
> > > I think this needs to be fleshed out more before we can add it,
> > > ideally along with a driver and some qemu implementation
> >
> > Yes. We have internal implementation but it has to be cleaned up
> > based on this new proposal.
> >
> > >
> > > It looks like the qemu part for this will not be so easy..
> > >
> >
> > My point is that we know that usage in the radar (though it needs more
> > discussion with real example) then does it make sense to make the
> > current name more general? I'm not sure how many devices can figure
> > out P2P from normal DMAs. If most devices have to stop all DMAs to
> > meet the requirement, calling it a name about stopping all DMAs doesn't
> > hurt the current P2P requirement and is more extensible to cover other
> > stop-dma requirements.
>=20
> Except you are not talking about stopping all DMAs, you are talking
> about a state that might hang indefinately waiting for a vPRI to
> complete
>=20
> In my mind this is completely different, and may motivate another
> state in the graph
>=20
>   PRE_COPY -> PRE_COPY_STOP_PRI -> PRE_COPY_STOP_P2P -> STOP_COPY
>=20
> As STOP_PRI can be defined as halting any new PRIs and always return
> immediately.

The problem is that on such devices PRIs are continuously triggered
when the driver tries to drain the in-fly requests to enter STOP_P2P
or STOP_COPY. If we simply halt any new PRIs in STOP_PRI, it
essentially implies no migration support for such device.

>=20
> STOP_P2P can hang if PRI's are open

In earlier discussions we agreed on a timeout mechanism to avoid such
hang issue.

>=20
> This affords a pretty clean approach for userspace to conclude the
> open PRIs or decide it has to give up the migration.
>=20
> Theoretical future devices that can support aborting PRI would not use
> this state and would have STOP_P2P as also being NO_PRI. On this
> device userspace would somehow abort the PRIs when it reaches
> STOP_COPY.
>=20
> Or at least that is one possibility.
>=20
> In any event, the v2 is built as Alex and Cornelia were suggesting
> with a minimal base feature set and two optional extensions for P2P
> and PRE_COPY. Adding a 3rd extension for vPRI is completely
> reasonable.

I'm fine if adding a 3rd extension works. But here imho the requirement
can be translated into that the user expects to stop all DMAs while=20
vCPU is running. If PRIs are triggered in that operation, then it will be=20
handled by the running vCPU. If any corner case blocks it, the timeout
mechanism allows aborting the migration process.

>=20
> Further, from what I can understand devices doing PRI are incompatible
> with the base feature set anyhow, as they can not support a RUNNING ->
> STOP_COPY transition without, minimally, completing all the open
> vPRIs. As VMMs implementing the base protocol should stop the vCPU and
> then move the device to STOP_COPY, it is inherently incompatible with
> what you are proposing.

My understanding is that STOP_P2P is entered before stopping vCPU.
If that state can be extended for STOP_DMA, then it's compatible.

>=20
> The new vPRI enabled protocol would have to superceed the base
> protocol and eliminate implicit transitions through the VPRI
> maintenance states as these are non-transparent.
>=20
> It is all stuff we can do in the FSM model, but it all needs a careful
> think and a FSM design.
>=20
> (there is also the interesting question how to even detect this as
> vPRI special cases should only even exist if the device was bound to a
> PRI capable io page table, so a single device may or may not use this
> depending, and at least right now things are assuming these flags are
> static at device setup time, so hurm)
>=20

Need more thinking on this part.

Thanks
Kevin
