Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5253688CD1
	for <lists+kvm@lfdr.de>; Fri,  3 Feb 2023 03:00:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232090AbjBCCA2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 21:00:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230196AbjBCCA1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 21:00:27 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E03D5649A;
        Thu,  2 Feb 2023 18:00:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675389626; x=1706925626;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=F7TseLMnowiHkGNTpHykyn/jZTR2d8S7bB4MZGdHAC0=;
  b=iqgr2ZUYbo82hhaM08VHZMZ732RAqch8Cmy9/jAknQYmAGXfYS0BRNJQ
   0wa7uMSkwB+StG5jWH4C+clXvvjtq3odAKp7TQM9Qg0Ndw4YsLWS10Cr5
   pk8Kg1UlxBQn2utzdFcjUw4khznVdMOnC9Foaq9o/MdD7DXjQAEFM2GPG
   Tjn2sin/X26IxuD3zuBXfpfYhIGW2/H/acsPem8JImlUQUVQ58CnUlsdJ
   vGXctqPsgm3gV5l/o2hFyowLNeWtLDgoacqDDXymre6wDHxOLFmeAKDtT
   KSasjcezWsOuUy9msddyizrHB7onS1mc0Npea0+fafWa20vYm8M2FSiuG
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10609"; a="355973102"
X-IronPort-AV: E=Sophos;i="5.97,269,1669104000"; 
   d="scan'208";a="355973102"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2023 18:00:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10609"; a="774128036"
X-IronPort-AV: E=Sophos;i="5.97,269,1669104000"; 
   d="scan'208";a="774128036"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga002.fm.intel.com with ESMTP; 02 Feb 2023 18:00:24 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 2 Feb 2023 18:00:24 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 2 Feb 2023 18:00:24 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.43) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 2 Feb 2023 18:00:24 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RDCzktI87I7MtyNAjPgEd3BV2mZz04qXrFA9GeHaOJLqI+q6FTdNdhLV6cKp66JvS8kTm18052yTFQj3MG5hAEg93JsJltIH7GTH9/0drtlbZvz5C5fT7IFljTRXvucigjFVT4MBKhFCWiPLbUCDXQ0REv9QZ6Qr+vWklYJX4eSedYi2oh21O97uJxNSDBEnVDoYUnCaDB5NvmfsvzVh6fj+38rrBN7Fu0g8KOIJIjkUmdjvbuoJ/IQGnpgqcaEcdOdm8UfOBDPJ3MosKTaq7PRbumIVvjUaz7XYgEDJEnho20fjvu5+E/8SHm6pjuCfwDQ7TkN4FBtu/tiV+oVH/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FCB6NTKfTirGBIF9r4o1aiTma41j8bPeb9o6Ox4cBVc=;
 b=GrmFOpzucXPvnwBZVVwOlEDLYF1IKsPG4KmIzirpydRKWmn4ru9cLLF6EamtFeCmI3Ja6Sl53Od61TxNbeVaiUIKc5dKj2MxkhgivvRXl6w7nZN6OyMwuqU9D7Xycx6EtYuaEan+6AO0nNXLNebOpofBaQix6ZyWXiTVw4J3Io63BUqoRhCoHYFvUO7YYOUlvgt11/jRs5gHoAfp8YuauDbZdgW6DrN8snJ9npddXfwudfTSNvg1BthVnldUP+2YpxH/UDGS5LTPGsZXC7PIey7NmC7ucPyonBFw08Eu8Tt+eAvx5xPMQm5LdUahj/G3k6joIqZtaPhRR8BZr+u5oQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CO1PR11MB4835.namprd11.prod.outlook.com (2603:10b6:303:9e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.24; Fri, 3 Feb
 2023 02:00:22 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d%8]) with mapi id 15.20.6064.027; Fri, 3 Feb 2023
 02:00:21 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     Matthew Rosato <mjrosato@linux.ibm.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "pmorel@linux.ibm.com" <pmorel@linux.ibm.com>,
        "borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>,
        "frankja@linux.ibm.com" <frankja@linux.ibm.com>,
        "imbrenda@linux.ibm.com" <imbrenda@linux.ibm.com>,
        "david@redhat.com" <david@redhat.com>,
        "akrowiak@linux.ibm.com" <akrowiak@linux.ibm.com>,
        "jjherne@linux.ibm.com" <jjherne@linux.ibm.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "zhenyuw@linux.intel.com" <zhenyuw@linux.intel.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v3] vfio: fix deadlock between group lock and kvm lock
Thread-Topic: [PATCH v3] vfio: fix deadlock between group lock and kvm lock
Thread-Index: AQHZNyMj/DyFlYgOy0urx1B0EjoKIa68DpoAgAA1mqCAAAVXgIAALINA
Date:   Fri, 3 Feb 2023 02:00:21 +0000
Message-ID: <BN9PR11MB5276017F9CEBB4BAE58C40E88CD79@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230202162442.78216-1-mjrosato@linux.ibm.com>
        <20230202124210.476adaf8.alex.williamson@redhat.com>
        <BN9PR11MB527618E281BEB8E479ABB0418CD69@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20230202161307.0c6aa23e.alex.williamson@redhat.com>
In-Reply-To: <20230202161307.0c6aa23e.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|CO1PR11MB4835:EE_
x-ms-office365-filtering-correlation-id: c1a4f503-9901-4ca6-2388-08db058a686c
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: X8q/Kd9UdsuVujHELDwFZZsVODyYbMxkvRpFl6JBErlXLqUeEBkMc48N2d8RjOYDpgBB/C55ovIu2ryVSB6RstwhtvP+RRJzVglmLAmLdZzL3ZZFK89l5n4L/Wr5/yA7HmYrtGCzKkTYo2s5bGIFfB78mLUF/2Jdve0rYozlfQCeUqWkWT9xQ3LZTQOCtfAyPR6su+8QThGBGYn5UsD79gTuwwD1VPV8XEn35Px0SmzfO3i7ZM1OeuPdNW6SF5YLnRvv/Y23Zv4mYfFKjBEQ5A4uZYksEfIgLFzQPhKcVzQ/CQ8+ginfCV8YMzUiGmRoYkNOfBD600NhVtK/ko1qlB7t91U9Kpm3RRT9fQJT2vDIaxAZ08vw75Bxn2irWrnogFfit91IdJ51WeOooqd9Jqg/WYaJnl+hbzHgql9T+Z2Fog8Ez52b41UyH1o8dFdZ79UB+FWJNHwCRdcDGJARqI52z7bYYezckfW23XRA0wTa4f2RpB75D2mk53oCnb+9JKmZmw30b2qBv2Zz6/NC30l0M+tKj0vW4qaJmEWOBs/RgpO4gW9snFyzfH969+Pk21gbcJBd2CmNj5JFCdGJywOOvfwcn9vJHOJuYnMCYE5tWr8zf+oeKzdxmgLEV6HxPy2/yfJtYcu43vOAF1144aHywXxZIxl8aIG2uTIBZAiMhaZPE0BVzz54LR15ZLYJGcc0B6SYKZoJJHHPpb7pYA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(396003)(376002)(136003)(366004)(346002)(451199018)(83380400001)(2906002)(6506007)(52536014)(41300700001)(7416002)(33656002)(7696005)(71200400001)(9686003)(5660300002)(122000001)(186003)(26005)(8936002)(55016003)(54906003)(86362001)(316002)(38100700002)(478600001)(82960400001)(66476007)(66446008)(8676002)(76116006)(4326008)(66556008)(38070700005)(6916009)(66946007)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?B4VWbod3lorMFyHUfjgeU/7m7kzZArNOE0LuLx8KMekDxw6qTo9g6tT/hRVQ?=
 =?us-ascii?Q?ScyOAJcCqwdbT2gGL/TcoVHRLZOtcYiCipTai/XSD0lBZY3jyHrtmUGItfXF?=
 =?us-ascii?Q?Equ/YftueCiuwoOlFhQcxiWWyRtmsPWLIkMhArwVZmqOXtP62q19yPcdRfSl?=
 =?us-ascii?Q?gDJUO2GJgHxwfyXo3dUmvPY2UvH7Z4PELODBGplgsFSSR3qwb7xBXL1c7B3F?=
 =?us-ascii?Q?SvcxwNpzRa+oGqE6HvkXy0hEFc/2VJviRpmsFHpOj+E/B9nxrWQcv+6HfoTx?=
 =?us-ascii?Q?QbN8AsQK+yDhfkzphptqatiIvlihr8AXvn6+M4i2AOlBTAyJ1g00FuVyzPWJ?=
 =?us-ascii?Q?GR3oq6r5BdI5annGwhbt1tDiFxe5+qlUbw5r/rlYdPTvuGutUe1wnvYCVQnx?=
 =?us-ascii?Q?r8jbvU3ta0HkAbWPPoEETFybfHKIsR9CvHMc7Of1GlLKnFtV+wt2qOU+6wWZ?=
 =?us-ascii?Q?Dei2mebXJZJmHAnu6mLACxVqSrBLc0uZ5nm05PF1wHfBg1l0f3IhEQCHQEOI?=
 =?us-ascii?Q?Gl3Ns+Os0hAS0j0bIaTF13WlOQnACgKZIz9D05FqczwytLC39flG5M5ubmPS?=
 =?us-ascii?Q?al943ez8iu4DOV0SZHZLANolDXVHBgEhbiSY0hWUmnYDEebJN0hyJbiJFFaR?=
 =?us-ascii?Q?lo2hstn5x6P0IJJoxuk6TuwXHvfwoKP22M/SyqMpBttUkLpKDAO9GAGaeP32?=
 =?us-ascii?Q?I9ALW+EXcx6WhshBfsiAVXbb0KS71xMH4c7A25bO47MI0o4Ke/OoTs67VKmZ?=
 =?us-ascii?Q?okIqEEakKNRlRJBXqt73TbqHp9kZzwgGhP0MpIC5eBfFz2gWlknwVsU30T7p?=
 =?us-ascii?Q?zWzLEZAuvfxTo/PgwunFh1i72j2icXkRsbl8rA37NfJP2e4ZlZFfdYrUtEUR?=
 =?us-ascii?Q?eyCM4QH9X9Hhcbq1kqwNel6iOtTApvdhsCw15hHkgLXLrKZxQnW4UwNpTqSY?=
 =?us-ascii?Q?qw073dROx2DWKI0/KN1itIeRs2XNiva01N7kdg17gLrnLUpxKK+L0TolPuvr?=
 =?us-ascii?Q?kTdkXd2kuP5DDY5kox7lmHeJK90qUeP+7hw6Z2Hz8ZQ9vzPaA/mqIq+7XAtG?=
 =?us-ascii?Q?vxfy7jOyNR7cgHi3Mn2/kmQTZek6VW+qYEiwC9ALL/PEO6ov9rihQffY+etq?=
 =?us-ascii?Q?ke+5kAMpHO77ysZ8FpAbcKmxhRpanw9iaSRdVwoXlm1iA/Tx812/CBBt53/V?=
 =?us-ascii?Q?3YjkCYOcGjb6PlNLFUSj45JnnokecOYjD5DlpRMILFezpopyhqzWbd7PD2PR?=
 =?us-ascii?Q?+1XGnmn8X2jOPug7lZlQZhnsU4ahAj/EePJsmFXVuR/EUVQS7juv0o8aJbRE?=
 =?us-ascii?Q?bp08TrdCeZ5eQl80cWH70tRWbC0eVujPcupuMM4GssY1k/Q7EPvMSHwCHMRo?=
 =?us-ascii?Q?WAbIdot3HjW05uV1EcksIkegTjCxbTpdh7U8VZl25H1dZ8tONHh6zJLdV28n?=
 =?us-ascii?Q?WEv5FBpeNBXmOkMkWAlceBTWtir26QDXba5FYmItTDsfUIuO/dXdla50v2I8?=
 =?us-ascii?Q?G5YmPtg1Lw2NypWWUG8kzgvGiBFmhkVQOOcw8ut4kEMNjXmIIEwtb9Nioyfc?=
 =?us-ascii?Q?RyAgU7jodwRg6aoi5Aqlxe2XXw2Ugma0qP2nzI3Q?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1a4f503-9901-4ca6-2388-08db058a686c
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Feb 2023 02:00:21.8444
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BE5KNnAIQhLv4gElSrkVufuR5Dv/zwV+SxOYWBJEe1FVPhbwR3A006c0vhIvboxbyXsmPAi1QmpDEZfsCmLeOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4835
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Friday, February 3, 2023 7:13 AM
>=20
> On Thu, 2 Feb 2023 23:04:10 +0000
> "Tian, Kevin" <kevin.tian@intel.com> wrote:
>=20
> > > From: Alex Williamson <alex.williamson@redhat.com>
> > > Sent: Friday, February 3, 2023 3:42 AM
> > >
> > >
> > > LGTM.  I'm not sure moving the functions to vfio_main really buys us
> > > anything since we're making so much use of group fields.  The cdev
> > > approach will necessarily be different, so the bulk of the get code w=
ill
> > > likely need to move back to group.c anyway.
> > >
> >
> > well my last comment was based on Matthew's v2 where the get code
> > gets a kvm passed in instead of implicitly retrieving group ref_lock
> > internally. In that case the get/put helpers only contain device logic
> > thus fit in vfio_main.c.
> >
> > with v3 then they have to be in group.c since we don't want to use
> > group fields in vfio_main.c.
> >
> > but I still think v2 of the helpers is slightly better. The only differ=
ence
> > between cdev and group when handling this race is using different
> > ref_lock. the symbol get/put part is exactly same. So even if we
> > merge v3 like this, very likely Yi has to change it back to v2 style
> > to share the get/put helpers while just leaving the ref_lock part
> > handled differently between the two path.
>=20
> I'm not really a fan of the asymmetry of the v2 version where the get
> helper needs to be called under the new kvm_ref_lock, but the put
> helper does not.  Having the get helper handle that makes the caller
> much cleaner.  Thanks,
>=20

What about passing the lock pointer into the helper? it's still slightly
asymmetry as the put helper doesn't carry the lock pointer but it
could also be interpreted as if the pointer has been saved in the get
then if it needs to be referenced by the put there is no need to pass
it in again.
