Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13823488FEE
	for <lists+kvm@lfdr.de>; Mon, 10 Jan 2022 07:01:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238857AbiAJGBt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jan 2022 01:01:49 -0500
Received: from mga02.intel.com ([134.134.136.20]:12263 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238848AbiAJGBs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jan 2022 01:01:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641794508; x=1673330508;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=YunOolNa+CAUSbf612/jN9ikldLAhGqq5nYbI8hpvp4=;
  b=br/A6KI0qmmvAz6Iku/oUyKiORwap9DMFEPrbWU3dXEsw3ve/e2Z/K5p
   56atVmI41/7GLUAq3xDj3CtytDtCBdVTDoA8tqJJDTYwXqaKvZRa89chW
   7FhOVBtc6R4eAiDox+UOXxKip9xpp+zBMxunwovsyejRwDcdSMXxFldZW
   HfWedMDs5czZJXco7tD0V8BxL3SYYZPfQPamH3T2Jep/Nh2ID+3gieJuQ
   W5bRDAQBLKGRs+LU5BI7aS4oOCXjoFRMn8MyBteHZQt96sC2Hm65jr9VG
   6ggK4ZMtjrtX8+nlzQ57UO0CbFhBgZ2eUvnP7EhcP2PvItO1LpNLQC1wy
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10222"; a="230499997"
X-IronPort-AV: E=Sophos;i="5.88,276,1635231600"; 
   d="scan'208";a="230499997"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2022 22:01:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,276,1635231600"; 
   d="scan'208";a="612753714"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by FMSMGA003.fm.intel.com with ESMTP; 09 Jan 2022 22:01:47 -0800
Received: from orsmsx605.amr.corp.intel.com (10.22.229.18) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Sun, 9 Jan 2022 22:01:47 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Sun, 9 Jan 2022 22:01:47 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.101)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Sun, 9 Jan 2022 22:01:46 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oCJ98XPKnz9JEbWRboqauf+eMF0cAzKQYgFdWhclCh+fP2RV4LfiDPQiC4z0VS4TYqYDiLXfzSadJB2h5xkaRnMrVwsTnkFCtczE5Qqb8ozMP7aiQ5fnJ4q9/uaqb1rmZSZR8O2X7D84sjMMCWfee5a6fQ0vlmvHHRCpdTHsZYecLCht20kwuzuz4TTU3rHJ+GJIFUkI2hTsecCaogLsDlmkbvfz8llJH8Gvx+dyNoDYrZob2FEY79OjHxliqOTM/60/j5Xj6INavN3HtQqj8kVDKaeSyhV8Ei9v35B3ObqwI6Z6shIW/ypIiWTy44vyMd/IinCm0FTnpg8JcouKBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ftNAb3UDJCPg498ODFNvLhrOYycIsOWIrs7hKIX2Bbg=;
 b=HTXzCThCDEzYQjqWFztWipU8hLBH9mfBjL4qwJfdMZQVojORQqkGxAVr+jamn/rSx5xuIJvrUXvL/evcGhQ+yuf80raqITsy73Yk4oIJUmTrfzEK3qX4co6jgLjO31wGISwa6r7mBRXnFrXZu4q7PLhM+LkeEG0RVRyPQE+ED6XcZDnvp1L+buFeItjW0QvJfXIQ/hNkyo8pdOKsIr9aprXfa2yomcFRR6ft63i63RlltFmW5C3sVKWrYXz2htKWv1QI7axDNB32jRDXHg508K/HMu2XyA8BOrjzGtbIQcxgy6erlH7UVLO/AQOiGL2XngKcvk5UCTE0Nyu3hMNpaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BN9PR11MB5484.namprd11.prod.outlook.com (2603:10b6:408:105::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Mon, 10 Jan
 2022 06:01:45 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::5c8a:9266:d416:3e04]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::5c8a:9266:d416:3e04%2]) with mapi id 15.20.4867.011; Mon, 10 Jan 2022
 06:01:45 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "jgg@nvidia.com" <jgg@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>
Subject: RE: [RFC PATCH] vfio: Update/Clarify migration uAPI, add NDMA state
Thread-Topic: [RFC PATCH] vfio: Update/Clarify migration uAPI, add NDMA state
Thread-Index: AQHX7VV0XQcySACwoUuiLSnTAAZEGKxXTBHggACin4CAA/2tAA==
Date:   Mon, 10 Jan 2022 06:01:45 +0000
Message-ID: <BN9PR11MB5276701E9AF2C6167E0D3FCC8C509@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <163909282574.728533.7460416142511440919.stgit@omen>
        <BN9PR11MB52769D49A29D1CD7A0C87C888C4D9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220107093611.6cbc6166.alex.williamson@redhat.com>
In-Reply-To: <20220107093611.6cbc6166.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9a39bbdc-aed4-4c3b-e5d0-08d9d3feae9d
x-ms-traffictypediagnostic: BN9PR11MB5484:EE_
x-microsoft-antispam-prvs: <BN9PR11MB54840A115223C5D828EDDEDD8C509@BN9PR11MB5484.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Lrd250gd2R0p7qTLcUPUdTGdlCM+358lh0M1rO4i8gbpMiXSC7Q7kP5CcoZbHu0BDRLSbrMG6qBgvKF2esjjpULKhqG+XZkObf5Cg64Hr/g+RBqNFkPkNWq+8yqMbhOZVZnt2be+S4619PO3DOmcr+2YwTFlQs93Iha4A8lxrsf3ASczx04iRy7/8dGYQJaAabBJOSZSoGx2/iQhLANB39kyh12KqC/Ln9/Slaszulsa04wjC2C//tjX8/eI2hOblHMdbuP2arqtXNyKp1r+8JbZgtuXji5IuirY3pZQhoGECtkUByapJt4oTKN5qoUvFXE63AsJLN0L0O+u0Zymufk0gzTWVfZYSiTjrKEKbLC7XAIT5wLuVxX84dhwmMms4xBK3bQOX6bC0mEFiyfeA60h0fYX78LPW8QBWZqdw17JavSCS6ltjUJro+8JJIYs9trKuZJuAE7c3gppSzwaJmDwG0PzN84/5Y0WMQzZKMhY1FZeN/z287BVYhuJ5HZFNP6ia0BWhIx/CCjSkF7TyHg2jlYTTv0ZR0kVoJZElwbTnGzqK6if77s4EYIZE5oPGyFNCuFqtXtAlZ10Pjpy6L+WHF/fGhNUq0+BVZhqxWeXTApKkar3HbSDE3lOIYA8RuWXJkxG23Q4Q3KgQKEmB9oKJJ4v3zPMQbcM2JNajeSMpIV/RqDjqRmUYDsYfDvAgLnYj/e180W/GbhvtB4VYg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(316002)(508600001)(66946007)(55016003)(33656002)(9686003)(71200400001)(4326008)(8676002)(82960400001)(7696005)(6916009)(122000001)(5660300002)(26005)(86362001)(38100700002)(83380400001)(54906003)(76116006)(38070700005)(66476007)(64756008)(186003)(8936002)(66556008)(52536014)(66446008)(2906002)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?hBgkeHIE/FfYSY/6ac2k+71zonUfwZUd2Caq0rm4lVhSK10eul/w5Gp0Sh5a?=
 =?us-ascii?Q?D9UqM7AoG89ffxxFsWLC3daEkDKR02ZmSAle2H9Gu2cYCMeBgDvwfu5OWaa0?=
 =?us-ascii?Q?KXVzMp21CdGOaafjgJFKSQAEVKOvkHz8iXMY3A/tkKKEAJswHxbKUfPzXRT6?=
 =?us-ascii?Q?rTs1qjh1ie9QIVuqSqnhK5fV998RRsZ2teLBVfvjPE1Mp04607pPvsJljdiR?=
 =?us-ascii?Q?diWx6SlbLLFuJTqK1YyrzG4ryO3T0pBiKRKcLbtKTdAnwFlZ3lp+SpOnOGy7?=
 =?us-ascii?Q?Jfuyi0bm5nufUqfycMe4FWCpnXjFUGhpDRibIOoeJ784yDOdpD5zLT64wQcP?=
 =?us-ascii?Q?k/RVxESzawSInkuOd6YY6Hsi5PeyWbuYMwQnKey72Jo7uN9dZ7KzbQBydLuM?=
 =?us-ascii?Q?Y8FM/x5XOjUjwkh2c09AtY6hMC8RVCrqW2jjSmzn1uRZUoTpBKFVRjXX6XRO?=
 =?us-ascii?Q?l+vQWON/xkW2EpFE2vmvWxrLR/zBy5ZdFwhZjsxxybWSilTN1Vx44D1s345C?=
 =?us-ascii?Q?KjfOE5K6aNh2x5SIUVzllN3iTtXyRI8ph9OakfDsgT01sM5TYP9hWnoFBl3P?=
 =?us-ascii?Q?/TTW8NmkNl6bjWk8xfjg1AU6U0gSKQdrOo9LRZ6rvPjSxGYOsnjN79vtcJ5R?=
 =?us-ascii?Q?GXbdlqYLsFpDPyoCBnKhgHTWZ1bcn9MVY59F7SUqILvnHif+WBJp0oqmk0dE?=
 =?us-ascii?Q?5h52XeOwbipC8oxnH2iw1h9zlGqTk0IMJQCJEQSWozfIp5osigYLm3iEtFQ6?=
 =?us-ascii?Q?usKi7Kdypy/MR7ZiDg+JH+5fwFaO/deP7jPopjnYGPRZsOB9ktk6Nv/m56eU?=
 =?us-ascii?Q?hgSnbHkIsAl03U49nzHCglh4kVsxmi+lgHaErxN/635BF3PLcRek9K6su/qH?=
 =?us-ascii?Q?/YAC91ZGJ32kY13wqSpX3o0J9Grr5zN5aASKRYn4p3W1EX/h5YQ2RWT542eu?=
 =?us-ascii?Q?vTGC1hy92DyIwNYi2/cQ+zzsh1yUiA0DNW6xFgDhbAj+V3xuP4ewXquEUNXM?=
 =?us-ascii?Q?w7hbMQREbe3gELmW0v2zhThSoZiJJO5o3X+KcIg7YQG0gQElBdtPKuicSiEs?=
 =?us-ascii?Q?XE0A/+ELhSWEQEZmRLBA1P9RbbiMRv9PuOTFOGm/+3yztz5VIt9i3OnnxcJQ?=
 =?us-ascii?Q?ivEg1KPdm+l9I0SnSiKzmyn8tfTISvEENx2NI4BkAHz23gWV0KWbO6Cu/L1s?=
 =?us-ascii?Q?xwDfwACocIU/btcZn00SFrI7mF9ZPF5zCgP2dCYuhMPAcLH3B7epfsNsrWAP?=
 =?us-ascii?Q?XGX6W9j/E+B0bAsQzmA1lJo0I/IMg/RdJa9aM3LBGBAoVgs7cZ/wlglzcgLk?=
 =?us-ascii?Q?xs5Nu5vgmgJVeOMZNRU+BZlR2KryiaSj2FEibKJaLONLr1I+I11t0719mIlZ?=
 =?us-ascii?Q?SYYg6mhQCaYvv1QXC6FEYFbn6ZQqUNcgjOiNEkpd6noqhoB9bFBUCgmTw2Jn?=
 =?us-ascii?Q?7wntZ6sJKub72hv4dDQxxROaJgqR0bwCjT+GZe4HB79qjkNkhqhrBqQQGiBG?=
 =?us-ascii?Q?qFbDP5EWihZnILu8H1a67a2WDdmGwFs6tCM3seErgbnbYNzFdP5oOd6Au+9Y?=
 =?us-ascii?Q?inh5bIkRhxAjFh9yFRx0SeTw8yf4raeVtUS7iCNRoFM4x832jdobGscJDCnD?=
 =?us-ascii?Q?j76feupuNLEsoRGD1+pAVd8=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a39bbdc-aed4-4c3b-e5d0-08d9d3feae9d
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jan 2022 06:01:45.2909
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IbZjgFT4XqGB45h1ncHCAa4tlhn5gu3Tbj6/gJa5Yrz/J4r5UTy8k3SyH9IvLAfT+EFDYVetxv89sFwvqunkxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5484
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Saturday, January 8, 2022 12:36 AM
>=20
> On Fri, 7 Jan 2022 08:03:57 +0000
> "Tian, Kevin" <kevin.tian@intel.com> wrote:
>=20
> > Hi, Alex,
> >
> > Thanks for cleaning up this part, which is very helpful!
> >
> > > From: Alex Williamson <alex.williamson@redhat.com>
> > > Sent: Friday, December 10, 2021 7:34 AM
> > >
> > > + *
> > > + *   The device_state field defines the following bitfield use:
> > > + *
> > > + *     - Bit 0 (RUNNING) [REQUIRED]:
> > > + *        - Setting this bit indicates the device is fully operation=
al, the
> > > + *          device may generate interrupts, DMA, respond to MMIO, al=
l vfio
> > > + *          device regions are functional, and the device may advanc=
e its
> > > + *          internal state.  The default device_state must indicate =
the device
> > > + *          in exclusively the RUNNING state, with no other bits in =
this field
> > > + *          set.
> > > + *        - Clearing this bit (ie. !RUNNING) must stop the operation=
 of the
> > > + *          device.  The device must not generate interrupts, DMA, o=
r
> advance
> > > + *          its internal state.
> >
> > I'm curious about what it means for the mediated device. I suppose this
> > 'must not' clause is from user p.o.v i.e. no event delivered to the use=
r,
> > no DMA to user memory and no user visible change on mdev state.
> Physically
> > the device resource backing the mdev may still generate interrupt/DMA
> > to the host according to the mediation policy.
> >
> > Is this understanding correct?
>=20
> Yes, one mediated device stopped running can't cause the backing
> device to halt, it must continue performing activities for other child
> devices as well as any host duties.  The user owned device should
> effectively stop.
>=20
> > > +*           The user should take steps to restrict access
> > > + *          to vfio device regions other than the migration region w=
hile the
> > > + *          device is !RUNNING or risk corruption of the device migr=
ation
> data
> > > + *          stream.  The device and kernel migration driver must acc=
ept and
> > > + *          respond to interaction to support external subsystems in=
 the
> > > + *          !RUNNING state, for example PCI MSI-X and PCI config spa=
ce.
> >
> > and also respond to mmio access if some state is saved via reading mmio=
?
>=20
> The device must not generate a host fault, ex. PCIe UR, but the idea
> here is that the device stops and preventing further access is the
> user's responsibility.  Failure to stop those accesses may result in
> corrupting the migration data.

ok. With this background I can understand what the last sentence tries
to say. It basically clarifies that while user access to the device is rest=
ricted
(by user itself) the kernel access (e.g. pci core, or the mediation driver=
=20
itself) is allowed as long as doing so doesn't advance the to-be-saved stat=
e.

>=20
> > > + *          Failure by the user to restrict device access while !RUN=
NING must
> > > + *          not result in error conditions outside the user context =
(ex.
> > > + *          host system faults).
> > > + *     - Bit 1 (SAVING) [REQUIRED]:
> > > + *        - Setting this bit enables and initializes the migration r=
egion data
> > > + *          window and associated fields within vfio_device_migratio=
n_info
> for
> > > + *          capturing the migration data stream for the device.  The
> migration
> > > + *          driver may perform actions such as enabling dirty loggin=
g of
> device
> > > + *          state with this bit.  The SAVING bit is mutually exclusi=
ve with the
> > > + *          RESUMING bit defined below.
> > > + *        - Clearing this bit (ie. !SAVING) de-initializes the migra=
tion region
> > > + *          data window and indicates the completion or termination =
of the
> > > + *          migration data stream for the device.
> > > + *     - Bit 2 (RESUMING) [REQUIRED]:
> > > + *        - Setting this bit enables and initializes the migration r=
egion data
> > > + *          window and associated fields within vfio_device_migratio=
n_info
> for
> > > + *          restoring the device from a migration data stream captur=
ed from
> a
> > > + *          SAVING session with a compatible device.  The migration =
driver
> may
> > > + *          perform internal device resets as necessary to reinitial=
ize the
> > > + *          internal device state for the incoming migration data.
> > > + *        - Clearing this bit (ie. !RESUMING) de-initializes the mig=
ration
> > > + *          region data window and indicates the end of a resuming s=
ession
> for
> > > + *          the device.  The kernel migration driver should complete=
 the
> > > + *          incorporation of data written to the migration data wind=
ow into
> the
> > > + *          device internal state and perform final validity and con=
sistency
> > > + *          checking of the new device state.  If the user provided =
data is
> > > + *          found to be incomplete, inconsistent, or otherwise inval=
id, the
> > > + *          migration driver must indicate a write(2) error and foll=
ow the
> > > + *          previously described protocol to return either the previ=
ous state
> > > + *          or an error state.
> > > + *     - Bit 3 (NDMA) [OPTIONAL]:
> > > + *        The NDMA or "No DMA" state is intended to be a quiescent s=
tate
> for
> > > + *        the device for the purposes of managing multiple devices w=
ithin a
> > > + *        user context where peer-to-peer DMA between devices may be
> active.
> >
> > As discussed with Jason in another thread, this is also required for vP=
RI
> > when stopping DMA involves completing (instead of preempting) in-fly
> > requests then any vPRI for those requests must be completed when vcpu
> > is running. This cannot be done in !RUNNING which is typically transiti=
oned
> > to after stopping vcpu.
> >
> > It is also useful when the time of stopping device DMA is unbound (even
> > without vPRI). Having a failure path when vcpu is running avoids breaki=
ng
> > SLA (if only capturing it after stopping vcpu). This further requires c=
ertain
> > interface for the user to specify a timeout value for entering NDMA, th=
ough
> > unclear to me what it will be now.
> >
> > > + *        Support for the NDMA bit is indicated through the presence=
 of the
> > > + *        VFIO_REGION_INFO_CAP_MIG_NDMA capability as reported by
> > > + *        VFIO_DEVICE_GET_REGION_INFO for the associated device
> migration
> > > + *        region.
> > > + *        - Setting this bit must prevent the device from initiating=
 any
> > > + *          new DMA or interrupt transactions.  The migration driver=
 must
> >
> > Why also disabling interrupt? vcpu is still running at this point thus
> interrupt
> > could be triggered for many reasons other than DMA...
>=20
> It's my understanding that the vCPU would be halted for the NDMA use
> case, we can't very well have vCPUs demanding requests to devices that
> are prevented from completing them.  The NDMA phase is intended to
> support completion of outstanding requests without concurrently
> accepting new requests, AIUI.

By current definition NDMA doesn't require the user to restrict access
to vfio device regions as for !RUNNING. So it's probably not good to tie it
with vcpu stopped.

As explained above it's also required when vPRI is enabled. At least for
current SVA-capable devices from Intel and Huawei they all require
waiting for vPRI completion before transitioning to NDMA can be done
while completing vPRI requires running vcpu.

New requests between NDMA and !RUNNING need to be mediated/
queued by the migration driver and then re-submitted on the=20
destination node. This further requires certain mechanism to allow=20
dynamically changing the mediation vs. passthru policy on the submit
portal.

>=20
> Further conversations in this thread allow for interrupts and deduce
> that the primary requirement of NDMA is to restrict P2P DMA, which can
> be approximated as all non-MSI DMA.
>=20
> > > + *          complete any such outstanding operations prior to comple=
ting
> > > + *          the transition to the NDMA state.  The NDMA device_state
> > > + *          essentially represents a sub-set of the !RUNNING state f=
or the
> > > + *          purpose of quiescing the device, therefore the NDMA
> device_state
> > > + *          bit is superfluous in combinations including !RUNNING.
> >
> > 'superfluous' means doing so will get a failure, or just not recommende=
d?
>=20
> Superfluous meaning redundant.  It's allowed, but DMA is already
> restricted when !RUNNING, so setting NDMA when !RUNNING is meaningless.
>=20
> > > + *        - Clearing this bit (ie. !NDMA) negates the device operati=
onal
> > > + *          restrictions required by the NDMA state.
> > > + *     - Bits [31:4]:
> > > + *        Reserved for future use, users should use read-modify-writ=
e
> > > + *        operations to the device_state field for manipulation of t=
he above
> > > + *        defined bits for optimal compatibility.
> > > + *
>=20
> FWIW, I'm expecting to see an alternative uAPI propose using a FSM
> machine in the near future, so while this clarifies what I believe is
> the intention of the existing uAPI, it might be deprecated before we
> bother to commit such clarifications.  Thanks,
>=20

got it.

Thanks
Kevin
