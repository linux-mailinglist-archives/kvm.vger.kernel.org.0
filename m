Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7D28585672
	for <lists+kvm@lfdr.de>; Fri, 29 Jul 2022 23:22:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239180AbiG2VV5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Jul 2022 17:21:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238953AbiG2VV4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Jul 2022 17:21:56 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99D5383F01;
        Fri, 29 Jul 2022 14:21:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659129714; x=1690665714;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=58w1ixsT5JNeOukZ8mjq1af7X+X1mwAp3a1TugjBbRA=;
  b=WUZQUlfY2R7LR+ONGlt/BUfs7rfPqPZqgJmzle1yzPT3W4G2P364XV6m
   ENfcZ7WdjRn8v0FglyLy5ke6jP+du5yKtPPn0uCaYUC+1jSC2SfQVbYuB
   DUJx8jgrx7hYznZ7SHVN1zI1h1DEWRXo/yplYYXgxFMi3ySM0wmGS8AVQ
   2gOXFGzIva3BwvZ8J/W6mm0HaptzRCIixxhcEgWpU4PM8Kou58y9Rj+TN
   YRp8dMv2HJp/9pjsWCZihhMIxqxD8XHxaBUV0Qd/RiXTrqdNaUWA97JbA
   oNZfK1H8nx+/8ju7IwivQEBFMthDYyW9OSrDQJ1nS0oh03veTBj5OwEZS
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10423"; a="350555275"
X-IronPort-AV: E=Sophos;i="5.93,202,1654585200"; 
   d="scan'208";a="350555275"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2022 14:21:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,202,1654585200"; 
   d="scan'208";a="847243638"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by fmsmga006.fm.intel.com with ESMTP; 29 Jul 2022 14:21:53 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Fri, 29 Jul 2022 14:21:52 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Fri, 29 Jul 2022 14:21:52 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.107)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Fri, 29 Jul 2022 14:21:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kZWRHDGPTrD/oEBeCqQz3hOp5pR2eo/6j/gl9fF2L3mAfWT7miKUfstNN3is01YdeQbvhgk9Yvs/IfM4pw0EvMfuGx604yuDaH8ljh/48uj6fZnfex1HZ5dHfAPiLE8KX6YGZ8TyOKDG09E7tSPYBLnkmdyhjp5LppA0PECmAEm3mQfSNveFCS8q8ru2uQG+PDa/bl4AQCTRAqFaNowsTvkpgdyyGaMxNeUyxQe0TyNCzgiYSVe4tFyE6YJMKF4D8vooZDifAJ21ruLWbXtZyap3ehpZy4N9feQFfxMpRj1tD/0ggY8VffvKbfM4iEdqeo/lFKR7YxunkTHj1Oa7cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+w9loEimhRseFj0XrV8bodFIvJESdlT4VTuOaoOsXgI=;
 b=cMdsCAToEmyoWPPvI2k1YuKHjOS8E6ekG65K3xdbVC3z3rB7ZsKBHyycAnklpi/qYP4VXjJX1v3ERCDrM27Yeh+V7Xb3FDSwKdgkfegpnCUXljj+nNfzycKSrB1KgknkCl62NDEmA8s8O85reGyKMWDXa+p4taYVHQ1kjUrmyavhkw9MFx5YOIQCfeUzWy49MBGmbiV4rxaiyLLW9HmdiKeRkVhk9GQ8GPX4TEMSBON7pdEDP/faOzpRNlwSFL/vU1KC8a09qIDkYIOdpxOoqGHdOg+75QcNJ+M71DNsHwJOwkxK0ofM5ue+pUkqqh70FdfghuB2lj7tosg5yieFZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW3PR11MB4554.namprd11.prod.outlook.com (2603:10b6:303:5d::7)
 by SJ0PR11MB6621.namprd11.prod.outlook.com (2603:10b6:a03:477::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Fri, 29 Jul
 2022 21:21:34 +0000
Received: from MW3PR11MB4554.namprd11.prod.outlook.com
 ([fe80::f5be:f0a4:1874:ba19]) by MW3PR11MB4554.namprd11.prod.outlook.com
 ([fe80::f5be:f0a4:1874:ba19%5]) with mapi id 15.20.5458.025; Fri, 29 Jul 2022
 21:21:34 +0000
From:   "Liu, Rong L" <rong.l.liu@intel.com>
To:     Dmytro Maluka <dmy@semihalf.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Eric Auger <eric.auger@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Tomasz Nowicki <tn@semihalf.com>,
        Grzegorz Jaszczyk <jaz@semihalf.com>,
        Dmitry Torokhov <dtor@google.com>
Subject: RE: [PATCH 3/3] KVM: irqfd: Postpone resamplefd notify for oneshot
 interrupts
Thread-Topic: [PATCH 3/3] KVM: irqfd: Postpone resamplefd notify for oneshot
 interrupts
Thread-Index: AQHYmGQnHF1zT77+b06fnEQmaAbtmq2V6lcg
Date:   Fri, 29 Jul 2022 21:21:34 +0000
Message-ID: <MW3PR11MB45542DAB98E5A7AAAD38FE30C7999@MW3PR11MB4554.namprd11.prod.outlook.com>
References: <20220715155928.26362-1-dmy@semihalf.com>
 <20220715155928.26362-4-dmy@semihalf.com>
In-Reply-To: <20220715155928.26362-4-dmy@semihalf.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.500.17
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4379d5a4-e7a1-4e97-27ff-08da71a850a1
x-ms-traffictypediagnostic: SJ0PR11MB6621:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QfoKY6Xf/+BjFzY+nFZXbQsDyVmYIhCD02s+6lurisPIz5OWfp0aIG+gYrjR8iObsf21IsLlIltELe2Z9eYBPWgUcUqsysA46h88vOMiQ3tNlE0QvU7PSfR9MibwuPyNw7Fb7w7nqQ2Y81vpaSGRs39y3N79Crm1+hy2dMs0qyxYbR9SvnNAVdM58s18ywz/Ql6QDfrWeIUdKyYXrd7mpoFhcUoG7EJPRWxOovloSpvDccm6vmTL1miALlCxuiMjVGu+DA+Xe5fI516dLHjW7nS6T7Ww/rPe3B/YiiOzB6C+F8Ogkpkc3FYp53UvsJK6+9L8fzdZQ9cbiOeQ6PrLsjU2FOMdWEEqyKYMZxw4CR6WJmrr5xVBMjUXz5Pe/jVITc/9QCBSuKcz2RMNLgSxIEbk0gweafqAEJM+R4ko19DOyzpAkaGGizR11N77ZUzc29GLJoQ3V2pXsZUlMZcQ8BtG2QnzIONasQUpvGWpbMqLcDhTxdpDowkjZPclmUpTK1pTG1nIMLLO1MO4cdeC7YKTp7ZHbI7sesaZ078XTfw7P7vQ/LPGMC0n7KJvs6QQzDVfyuEPAzmvQnUQznOsAPT7btRU0yUk0S3qXn814PMxqorMzQlZ9RojJAjhW1nZdCrv7YiQT6+lWe3gC/XmlM375LPTMECGU/0CzyAXboGQdNX8HYMqcLxyXQDLvw4cKv6627I3nz6K644MhgSvnhXiOzEKOqXPhBOn5xK1uDJLFkCMPmhi/g+siHXUJdofu1RWZsZAbXaYNkDKlubj1uST9KNSiRJwg0uAnw6O+R04XTSgPeIavlNN+7qEnr1zyfIaClGKolQa+9eofvuZ8Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4554.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(39860400002)(136003)(346002)(376002)(366004)(316002)(9686003)(4326008)(66556008)(41300700001)(8676002)(478600001)(186003)(66946007)(6506007)(66476007)(86362001)(64756008)(53546011)(5660300002)(66446008)(122000001)(71200400001)(8936002)(76116006)(7696005)(54906003)(55016003)(38100700002)(7416002)(33656002)(83380400001)(26005)(82960400001)(2906002)(110136005)(38070700005)(966005)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?F6u/+uo2sD+IqzokuoUqvYMLBgatZOPD0uGybUC2HfpN+/tYGFdd3QZnil5s?=
 =?us-ascii?Q?bE5gNbyKF4S6rUDrCtgaxoKx9AEnrK5cmCEgjlMNNENEaoRk42HMnk7O/fHJ?=
 =?us-ascii?Q?Xha8LLRykVLhor8FGNOGEOXigchgmayJt9e/YYZH4nMhSyVdfTDnEPXt4eO+?=
 =?us-ascii?Q?G1CMD5a4t7iUJY6ByOjwSiecpNwKRdFPObQlo60DlX3vNp76dE2TgSbnHc+b?=
 =?us-ascii?Q?4zFvQkfuqmCl/47E3bSpyrcec3ghuHw2CbJcRvGxaP9ooI5xxtIviWxOdeCZ?=
 =?us-ascii?Q?lp6ZKbFaFPySzlj/sh27BjBbrT/Cf8mjAQUljcIBlr1kF6tZxY5FRs7ioU74?=
 =?us-ascii?Q?V9mE4oSWEsE7onVH2NfP12HGKHcdj5pQR/NfA9fRebPKnmsYTy+r7FyFw6Oy?=
 =?us-ascii?Q?FpNRreBqhbd2zVkzGgkGSDucIUrnLk+Ud+772sqwu9pUBNiRkhzEQA09xqom?=
 =?us-ascii?Q?LKzu7uuOxSI7LhoICce8lpMme0hKlSIWi25Q3fBkTMOrWav+l5jUHrdRwuG+?=
 =?us-ascii?Q?GWjfKhH8dYFo30YZI5V1QBo5Z2sAXZP+rMt3G1gpoZ6rPEcoy1zsONgpfI8t?=
 =?us-ascii?Q?fFiBUlbZcA1PRcThF0ZTODRjHb7xDgZtgRv8WfSo3wdpsG5psrLi1L8UIaYk?=
 =?us-ascii?Q?6sh1XFsK/X47mW8ODcVWUmQNgJQ/7SiaMgsHIclyO0rfRzKJVMbpFaTyNEmA?=
 =?us-ascii?Q?Mb+KU3KOIlqU8fyMy6us3l8jV+8VpqcDsQZ3OBc7Vaii3+iOuIsKjjZBfhwV?=
 =?us-ascii?Q?wvYJTJGJyClAas4VtYxbejUFW5mkUAXs1FO9oA2tRXYu6mldeF/0yB5iBaMV?=
 =?us-ascii?Q?BKbEYo9PRhW9d1ijfOIxIrm1d3saDhAoSwwaSPFkzRThTeENwmLHtuyNvn+8?=
 =?us-ascii?Q?IZk+RLWPmyiEnEVt6yEa1VV9l49kLGKDMBRUUD07k7d001u5vPOKoFn01pte?=
 =?us-ascii?Q?9OF3fY38kKu/bonTmhIcFAsJ6KXO2vRcOySH44U3/TsmdtciVLcV92hZRmqG?=
 =?us-ascii?Q?R8ZZSn7OSDRsCrg1O5f6WlFBd4ayC6vbRl7lR4CY0/DbCaoXPlLCEnjQ7wP/?=
 =?us-ascii?Q?T4HXiYFXQqSuC07i2idqB4eZw22VZTDya92i2dW8iGFqu9qZgJqdO/7/KZfx?=
 =?us-ascii?Q?/et+7I0m2e9LVqc/o1uXQBeTg7ujAMKUsuvZ0PjmB+UTpwIoCDQSEpPbTsqV?=
 =?us-ascii?Q?X5p/WB4jt8/tiU2GylcIz2jlCZ9Pn3fbBkeELR+Y05cwy0flm3qHTulWxuf7?=
 =?us-ascii?Q?U/meLGpJc6FRMRxApwPdyaLk8sVNh54vLipProGWfgIFQ0lW11upQa3ukN3y?=
 =?us-ascii?Q?SITKP5PCNtAoYwNUikn8CxlXP9ISdhhhZ942fIn5omIcQcADfPl03bSEfpwM?=
 =?us-ascii?Q?vd6no6A5L94pcFOYRpzl6JAiebQtgxcXoK1v5NJ9/Eq6QZHWOP65IM3anQGa?=
 =?us-ascii?Q?Js+npOjOmIwVwx3RfaIK5dJcbb62R+V1psJEAsojqDvO287Qy6MHUK3RrlKV?=
 =?us-ascii?Q?psKoX5O93jWOK2PtAngG82HX4RttWuIHOjNgOIJ4AaVcorw1ui0r6pQmV1d0?=
 =?us-ascii?Q?s8lA1MKTCJlKiWlcdXw9pC0grxbko1f2Cwsy+i8e?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW3PR11MB4554.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4379d5a4-e7a1-4e97-27ff-08da71a850a1
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jul 2022 21:21:34.7061
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XtvFqkEER/6/RKPqDWoHW1AcrcTQOcbvbn9445f/ufNwaFXcXNBSF+TibtqULjlnXq0tvAZKhxR6dZGYkrigsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB6621
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Dmytro,

> -----Original Message-----
> From: Dmytro Maluka <dmy@semihalf.com>
> Sent: Friday, July 15, 2022 8:59 AM
> To: Christopherson,, Sean <seanjc@google.com>; Paolo Bonzini
> <pbonzini@redhat.com>; kvm@vger.kernel.org
> Cc: Thomas Gleixner <tglx@linutronix.de>; Ingo Molnar
> <mingo@redhat.com>; Borislav Petkov <bp@alien8.de>; Dave Hansen
> <dave.hansen@linux.intel.com>; x86@kernel.org; H. Peter Anvin
> <hpa@zytor.com>; linux-kernel@vger.kernel.org; Eric Auger
> <eric.auger@redhat.com>; Alex Williamson
> <alex.williamson@redhat.com>; Liu, Rong L <rong.l.liu@intel.com>;
> Zhenyu Wang <zhenyuw@linux.intel.com>; Tomasz Nowicki
> <tn@semihalf.com>; Grzegorz Jaszczyk <jaz@semihalf.com>; Dmitry
> Torokhov <dtor@google.com>; Dmytro Maluka <dmy@semihalf.com>
> Subject: [PATCH 3/3] KVM: irqfd: Postpone resamplefd notify for oneshot
> interrupts
>=20
> The existing KVM mechanism for forwarding of level-triggered interrupts
> using resample eventfd doesn't work quite correctly in the case of
> interrupts that are handled in a Linux guest as oneshot interrupts
> (IRQF_ONESHOT). Such an interrupt is acked to the device in its
> threaded irq handler, i.e. later than it is acked to the interrupt
> controller (EOI at the end of hardirq), not earlier.
>=20
> Linux keeps such interrupt masked until its threaded handler finishes,
> to prevent the EOI from re-asserting an unacknowledged interrupt.
> However, with KVM + vfio (or whatever is listening on the resamplefd)
> we don't check that the interrupt is still masked in the guest at the
> moment of EOI. Resamplefd is notified regardless, so vfio prematurely
> unmasks the host physical IRQ, thus a new (unwanted) physical interrupt
> is generated in the host and queued for injection to the guest.
>=20
> The fact that the virtual IRQ is still masked doesn't prevent this new
> physical IRQ from being propagated to the guest, because:
>=20
> 1. It is not guaranteed that the vIRQ will remain masked by the time
>    when vfio signals the trigger eventfd.
> 2. KVM marks this IRQ as pending (e.g. setting its bit in the virtual
>    IRR register of IOAPIC on x86), so after the vIRQ is unmasked, this
>    new pending interrupt is injected by KVM to the guest anyway.
>=20
> There are observed at least 2 user-visible issues caused by those
> extra erroneous pending interrupts for oneshot irq in the guest:
>=20
> 1. System suspend aborted due to a pending wakeup interrupt from
>    ChromeOS EC (drivers/platform/chrome/cros_ec.c).
> 2. Annoying "invalid report id data" errors from ELAN0000 touchpad
>    (drivers/input/mouse/elan_i2c_core.c), flooding the guest dmesg
>    every time the touchpad is touched.
>=20
> This patch fixes the issue on x86 by checking if the interrupt is
> unmasked when we receive irq ack (EOI) and, in case if it's masked,
> postponing resamplefd notify until the guest unmasks it.
>=20
> Important notes:
>=20
> 1. It doesn't fix the issue for other archs yet, due to some missing
>    KVM functionality needed by this patch:
>      - calling mask notifiers is implemented for x86 only
>      - irqchip ->is_masked() is implemented for x86 only
>=20
> 2. It introduces an additional spinlock locking in the resample notify
>    path, since we are no longer just traversing an RCU list of irqfds
>    but also updating the resampler state. Hopefully this locking won't
>    noticeably slow down anything for anyone.
>=20
> Regarding #2, there may be an alternative solution worth considering:
> extend KVM irqfd (userspace) API to send mask and unmask notifications
> directly to vfio/whatever, in addition to resample notifications, to
> let vfio check the irq state on its own. There is already locking on
> vfio side (see e.g. vfio_platform_unmask()), so this way we would avoid
> introducing any additional locking. Also such mask/unmask notifications
> could be useful for other cases.
>=20
> Link: https://lore.kernel.org/kvm/31420943-8c5f-125c-a5ee-
> d2fde2700083@semihalf.com/
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Dmytro Maluka <dmy@semihalf.com>
> ---
>  include/linux/kvm_irqfd.h | 14 ++++++++++++
>  virt/kvm/eventfd.c        | 45
> +++++++++++++++++++++++++++++++++++++++
>  2 files changed, 59 insertions(+)
>=20
> diff --git a/include/linux/kvm_irqfd.h b/include/linux/kvm_irqfd.h
> index dac047abdba7..01754a1abb9e 100644
> --- a/include/linux/kvm_irqfd.h
> +++ b/include/linux/kvm_irqfd.h
> @@ -19,6 +19,16 @@
>   * resamplefd.  All resamplers on the same gsi are de-asserted
>   * together, so we don't need to track the state of each individual
>   * user.  We can also therefore share the same irq source ID.
> + *
> + * A special case is when the interrupt is still masked at the moment
> + * an irq ack is received. That likely means that the interrupt has
> + * been acknowledged to the interrupt controller but not acknowledged
> + * to the device yet, e.g. it might be a Linux guest's threaded
> + * oneshot interrupt (IRQF_ONESHOT). In this case notifying through
> + * resamplefd is postponed until the guest unmasks the interrupt,
> + * which is detected through the irq mask notifier. This prevents
> + * erroneous extra interrupts caused by premature re-assert of an
> + * unacknowledged interrupt by the resamplefd listener.
>   */

I don't really agree with above statement.  Please correct me if I am wrong=
.  In
all modern x86 interrupt infrastructure(lapic/ioapic), for level triggered
interrupt, the sequence is always EOI (LAPIC), which is called interrupt ac=
k in
the context of this discussion, then unmask (IOAPIC).  Oneshot interrupt is
different only because the timing of above 2 events are different from a
"normal" level-triggered interrupt.  It is like for level interrupt:  Hardi=
rq ->
EOI -> Unmask but for oneshot, it is like: hardirq->EOI, then sometime late=
r
threadedirq->unmask.  So based on this, I don't think you need to keep trac=
k of
whether the interrupt is unmasked or not, just need to call the notifier at=
 the
end of unmask, instead of EOI.  And calling notifier at the end of unmask,
instead of EOI won't break non-oneshot case.  The only caveat is guest ioap=
ic
update (virq unmask) doesn't cause vmexit.  But the assumption is already m=
ade
that virq unmask causes vmexit.
=09
>  struct kvm_kernel_irqfd_resampler {
>  	struct kvm *kvm;
> @@ -28,6 +38,10 @@ struct kvm_kernel_irqfd_resampler {
>  	 */
>  	struct list_head list;
>  	struct kvm_irq_ack_notifier notifier;
> +	struct kvm_irq_mask_notifier mask_notifier;
> +	bool masked;
> +	bool pending;
> +	spinlock_t lock;
>  	/*
>  	 * Entry in list of kvm->irqfd.resampler_list.  Use for sharing
>  	 * resamplers among irqfds on the same gsi.
> diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
> index 50ddb1d1a7f0..9ff47ac33790 100644
> --- a/virt/kvm/eventfd.c
> +++ b/virt/kvm/eventfd.c
> @@ -75,6 +75,44 @@ irqfd_resampler_ack(struct kvm_irq_ack_notifier
> *kian)
>  	kvm_set_irq(kvm, KVM_IRQFD_RESAMPLE_IRQ_SOURCE_ID,
>  		    resampler->notifier.gsi, 0, false);
>=20
> +	spin_lock(&resampler->lock);
> +	if (resampler->masked) {
> +		resampler->pending =3D true;
> +		spin_unlock(&resampler->lock);
> +		return;
> +	}
> +	spin_unlock(&resampler->lock);
> +
> +	idx =3D srcu_read_lock(&kvm->irq_srcu);
> +
> +	list_for_each_entry_srcu(irqfd, &resampler->list, resampler_link,
> +	    srcu_read_lock_held(&kvm->irq_srcu))
> +		eventfd_signal(irqfd->resamplefd, 1);
> +
> +	srcu_read_unlock(&kvm->irq_srcu, idx);
> +}
> +
> +static void
> +irqfd_resampler_mask(struct kvm_irq_mask_notifier *kimn, bool
> masked)
> +{
> +	struct kvm_kernel_irqfd_resampler *resampler;
> +	struct kvm *kvm;
> +	struct kvm_kernel_irqfd *irqfd;
> +	int idx;
> +
> +	resampler =3D container_of(kimn,
> +			struct kvm_kernel_irqfd_resampler, mask_notifier);
> +	kvm =3D resampler->kvm;
> +
> +	spin_lock(&resampler->lock);
> +	resampler->masked =3D masked;
> +	if (masked || !resampler->pending) {
> +		spin_unlock(&resampler->lock);
> +		return;
> +	}
> +	resampler->pending =3D false;
> +	spin_unlock(&resampler->lock);
> +
>  	idx =3D srcu_read_lock(&kvm->irq_srcu);
>=20
>  	list_for_each_entry_srcu(irqfd, &resampler->list, resampler_link,
> @@ -98,6 +136,8 @@ irqfd_resampler_shutdown(struct
> kvm_kernel_irqfd *irqfd)
>  	if (list_empty(&resampler->list)) {
>  		list_del(&resampler->link);
>  		kvm_unregister_irq_ack_notifier(kvm, &resampler->notifier);
> +		kvm_unregister_irq_mask_notifier(kvm, resampler-
> >mask_notifier.irq,
> +						 &resampler->mask_notifier);
>  		kvm_set_irq(kvm, KVM_IRQFD_RESAMPLE_IRQ_SOURCE_ID,
>  			    resampler->notifier.gsi, 0, false);
>  		kfree(resampler);
> @@ -367,11 +407,16 @@ kvm_irqfd_assign(struct kvm *kvm, struct
> kvm_irqfd *args)
>  			INIT_LIST_HEAD(&resampler->list);
>  			resampler->notifier.gsi =3D irqfd->gsi;
>  			resampler->notifier.irq_acked =3D irqfd_resampler_ack;
> +			resampler->mask_notifier.func =3D irqfd_resampler_mask;
> +			kvm_irq_is_masked(kvm, irqfd->gsi, &resampler-
> >masked);
> +			spin_lock_init(&resampler->lock);
>  			INIT_LIST_HEAD(&resampler->link);
>=20
>  			list_add(&resampler->link, &kvm->irqfds.resampler_list);
>  			kvm_register_irq_ack_notifier(kvm,
>  						      &resampler->notifier);
> +			kvm_register_irq_mask_notifier(kvm, irqfd->gsi,
> +						       &resampler->mask_notifier);
>  			irqfd->resampler =3D resampler;
>  		}
>=20
> --
> 2.37.0.170.g444d1eabd0-goog

