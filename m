Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03C1B5F06FB
	for <lists+kvm@lfdr.de>; Fri, 30 Sep 2022 10:58:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231265AbiI3I6n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Sep 2022 04:58:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231295AbiI3I6h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Sep 2022 04:58:37 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B21F31EF02E
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 01:58:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664528316; x=1696064316;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=aju77blqAnUOMWljZgKcqhCY1LW/paUuYywCDFnmOjA=;
  b=W/UKRwImGNChJcuInn8UnqrVXXoIs54qpMK7vtJbGSu5Jj74HjNAIsAG
   sMAUe1f5+WSYp4bpDJ6O1ltDTxSA9zd/0fAaCe8j5A4XggWTtO9QaJnEj
   G2nEnN1UQyL7d8LRhZ2SzFi/YwUFJcXxTrtYhhORKC3dimZhy/ecNHVdF
   adqOoCO7H8L9+V5RhSVkozQmaRwnU0vHmbo+6oZ4Z5yRe88ayxdw+mgD3
   pfKu1l8SrcJPOhVsddwiu9t4vETEQMMtm3IeyJv4TwIQYKaauj1fRQgWf
   EBMqHWmGJ0xK3yL/inq+78AK8YLTiqqigYGgX4/TQojVPA7/dKfC9Xtfk
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10485"; a="388422844"
X-IronPort-AV: E=Sophos;i="5.93,357,1654585200"; 
   d="scan'208";a="388422844"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2022 01:58:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10485"; a="617930176"
X-IronPort-AV: E=Sophos;i="5.93,357,1654585200"; 
   d="scan'208";a="617930176"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga007.jf.intel.com with ESMTP; 30 Sep 2022 01:58:36 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 30 Sep 2022 01:58:35 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Fri, 30 Sep 2022 01:58:35 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Fri, 30 Sep 2022 01:58:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HxWLvTuZ0oQW5s1a+Ewk1QvMuEFkHahEyvZOXpTyVrTuhSgp6I5ouFLFNXAzIuU3uKI5ygFFpOExDbXiphktVj6x7DTKCCsJqOTHtEAYiLpJXKFZptlRx4JR5kFczw5yQgU4LruK3+ZlSBRtjK58zegIGGzf1brvsRF45FTggBPcIgwjDUOkb96zhkBiSOmLz2RPUvTqnFyjH3sPtTHZ+RvJaRaTm/llP55h4dNH2GYbwG7rMdmPNVn9xtE4UfLNcCgFvJSUwiEEkSfDozpTZ4UfKVhTcMYINHGWYpE+7la3LJ1l4oGYLNBcHpzHaVFQ0Tm/H0q5mM+uFfx7XG1PQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aju77blqAnUOMWljZgKcqhCY1LW/paUuYywCDFnmOjA=;
 b=Wf65FbJLyzES2bAmJhMQOSTKVenoexZTWWdAdanw7v9HmU8ukBkbOy4ZM4Vz06qLNPoqHWjOKFf+80N1IGo+zI6mJY5382yDijmcvpvw9SDu986sZm5WvPK49AkPluhOrby1Gg44hhOJDeJrGqwIB00Wci3IgQrCzpybEvFutZbTexLOtbvdfQoaZj6NlUvcxZR74yROPzI1rAifKLn4sNMD4L6KR4Hs+Io4Kzvy4wntt0g2mP5QuH+mUHelJfDtnJrqdAj+BjQ8suwobWDUus4A2aIfMyIChNSUeeEmyZAyQl0+O1XmQPOasz+XePylCzcH7vzbMzubgQc1GJIhfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CY8PR11MB7034.namprd11.prod.outlook.com (2603:10b6:930:52::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.23; Fri, 30 Sep
 2022 08:58:34 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::ff76:db8b:f7e9:ac80]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::ff76:db8b:f7e9:ac80%5]) with mapi id 15.20.5676.023; Fri, 30 Sep 2022
 08:58:34 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH 1/2] vfio: Remove the vfio_group->users and users_comp
Thread-Topic: [PATCH 1/2] vfio: Remove the vfio_group->users and users_comp
Thread-Index: AQHY1BQh1xrLXvqLaECyU6OBFAnK0K33rVmA
Date:   Fri, 30 Sep 2022 08:58:34 +0000
Message-ID: <BN9PR11MB5276192B123C916A377C16538C569@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v1-917e3647f123+b1a-vfio_group_users_jgg@nvidia.com>
 <1-v1-917e3647f123+b1a-vfio_group_users_jgg@nvidia.com>
In-Reply-To: <1-v1-917e3647f123+b1a-vfio_group_users_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|CY8PR11MB7034:EE_
x-ms-office365-filtering-correlation-id: d79d7e3c-3c77-4d5b-d4a0-08daa2c1f4cc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aN6YOXj77R/sR7yzguDaaJd3jwZlCw+AV5j1FKLBIMK+y7IH6/iUY8zjBL4vtRzeCSNdvrEHECguqoe/BLgjRBErl7qwKaRG+D8JNRrh9O399jb99lmavMkGQ64QOT/NTQtJQCi2pF3R9WkCE5KMq3VRsEW2mmOWJR92vY93WFY8DD85AqSabbAM9X5ejKOsCSKZviKbTB4WRzaDqjFldxM0mbY9eaa2bNrxXSpHvm8kXLVXfs/+CwbN8nl/S+VKxqMzpXpIoC5kLYIrWiQ6ZtNj7YIm92ka+tetO8A7h+TXwW26j0zG0jMQb9TfMxRVrO7HeN593jnvRR7MN+gnDQisGniuqZymrdMVx4sQkuXB9g5xBEWZzXwfVj8lblJT5HxWv/d3e2oeE/OI9abxZlO6YMrfoF6YLQbUJg//KlxRQ6o1M22gjjL3nVytnfOzWS+jRCwVWXMJ36xrCv4j/t4tGycob5VHK19Pqq7R2kFmzlLR49o4fMIWtzRxURlZdyHa0smsP59uNtRWTcuuAo41nCpCACoj8r8kHwXXg7a6E/PATPcojKvhQnaRguoJQzJE1G1bfeP5OOCz1IZ+ayWFpsugZucxgITU2Bhh5HB0h7y3Bhicme9XwRzr+zEZ4Zcsy7CSRNoOw6KQehh6tee1jRN0lNcPv2YiFaECCg3V61ykbPxu0+s47vaeE/bohEa6NzikYlvc66PNpmxN3TeDLjb84cad44Ic4EFGr57cKQX/jyarRp+inDDqjm42RYcST6pd5nHDI8/MFG0AvQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(376002)(366004)(396003)(346002)(39860400002)(451199015)(122000001)(38100700002)(5660300002)(86362001)(52536014)(26005)(55016003)(8936002)(7696005)(66446008)(6506007)(64756008)(9686003)(8676002)(66476007)(66556008)(66946007)(76116006)(41300700001)(4744005)(186003)(38070700005)(71200400001)(33656002)(2906002)(316002)(110136005)(478600001)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Gad2qhg3yoEVy9mNrRHIRl4ekLtOX3bC2BtP8/rE0KrvFlh1qJ4EDTmVPn4F?=
 =?us-ascii?Q?ZV+oiGASAaws9GdjgEQhvzrfraeq+DB+fzRV/+mSjnjRCKGRHYp7mhbNUpeq?=
 =?us-ascii?Q?CGUV+9G0VYHTvBwTRJyJAzWagd5nKqgF5UQ3ATvmLikIkZY/daEBDP7UTm0y?=
 =?us-ascii?Q?ix12ibB3d7dzEb7U8h32xBTrCghuVxwbCsqryPQ8nNunlHRO9kCSni9ooYTw?=
 =?us-ascii?Q?W3jI1zITr+uEiy2UaHt7mBnpd4knhLcA5f/QKcjYrgmsJQRi2sbY++NWLZmo?=
 =?us-ascii?Q?lNSacmdPy/V18eoUamnlukmM+Qf2GsReyHcOV9L2ELn6gEhJLwMAHgAf2eH4?=
 =?us-ascii?Q?MvWM0jLEso1QSWTdDUW2Hr1V8f7wDK3L13TEIWXQlY4k+10FzKw2vx9zWrym?=
 =?us-ascii?Q?Tc4F97R27DdPBPQ0xVq0mt1rAeHDdD6XOUk9sA6JyXMkED0K7A3Ad2+zRdRj?=
 =?us-ascii?Q?ipJ8nlZrUvJEqWn+DnHw+g8DYjTLRpEygLdwV4wgabjjhg4OyBZx9wH4uOxN?=
 =?us-ascii?Q?AC+5MqbW0NqliJkUTeJIJ2CrLxPy5DiqaR6kt/WBCpy5urEOPryfjLrZegAH?=
 =?us-ascii?Q?gsW8gaZchmUblIA0wkGBGDNmzEENrIYmXat/zv3je5GNn/qoOL0C79N3NOgX?=
 =?us-ascii?Q?N25oywAqlzRLeTzslKH6vmfkaLj4FZ2pV2EZPV3RsFhHiaoOnjjJoNnQZtm2?=
 =?us-ascii?Q?BWQ4JoCE9JDKXORnqG2Waj3+NqF7rcyhXtSApciWohG63ySQqIs5TYxjVJoM?=
 =?us-ascii?Q?kxUVwc6RZODt/CZdPbUamNajidVv0SAUgn0jLMn8q3IVS1uDI5Zo7DuZsFda?=
 =?us-ascii?Q?RKlFmtS+NwS5hrUIF18gazPqGyQZuTjE3SmuJRB42atN/xn4KUp9EsEkJYfp?=
 =?us-ascii?Q?RgQM1uAZXRveVFGx7BwEbE/PH3oDrIlVpqY3+bGdxag/ODJxG9NsarzKfDeU?=
 =?us-ascii?Q?o6DXkq2NRA84oAHvw+VYgRmIa/+yoPCghMZkhYpQKhgSXGwXQCjrwoq85H+X?=
 =?us-ascii?Q?LvGXf4WzKQFO/CdrTfSgkcG5iACioD4zyOMXPPlxaqT/PA2y26nXuORvu1FR?=
 =?us-ascii?Q?uHPn9rELcSMRbTS7wirrk/bQtB2kZ+4k4QmkDNB7lS2oUID0C6BxifzIqQvA?=
 =?us-ascii?Q?j3FUjOeF2mZI5nUI3NyJfSEgdN/bnNjhMZwdUU57fWiR/znlVUZa1pNvk2iT?=
 =?us-ascii?Q?hViLoTDdDUGS8DyzrZxdrdm5qtbx1cLnJ/f/0nZM9tv5c9jKDE/zmxJjblEO?=
 =?us-ascii?Q?F2c1F4CCy7y3G0B7aubwZRB5z9dlr5zvsYercbopoJVStAJebvPYXtShQFoW?=
 =?us-ascii?Q?Nv9NAsNHLQJ9OWsuMFdRNAjWvCoHfENL4ASPRCNAM9Ib/MiPLIuTHOTi/QpC?=
 =?us-ascii?Q?ntKLmM4lkb0PGf9FRZryA9cAqleLEcXJxVRFwMhZictVtf1xKaCWbyrGF7bQ?=
 =?us-ascii?Q?6m/F3rM7f63Wfe9g9FZoMWxaOzToCQhjGQkg02uanNgsrFixP/lfBnP5YDgn?=
 =?us-ascii?Q?HdEyDiTWjtEHdY7/VbS3sd4/UzZNBiwsdB0oMBi3NLPl+iAIqyzsjfsuna6z?=
 =?us-ascii?Q?+e1mGS/oaWRa6JrDwP1xSQCfYETRRwBEZlurqlfx?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d79d7e3c-3c77-4d5b-d4a0-08daa2c1f4cc
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Sep 2022 08:58:34.5486
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OfrU+mZN0oHuOO0ZBBYk2vn9djENSHznmylC4HATwvZytuy7TMJo4y+TsPaxrJ4l/au5UkwwsfWelVSiqV1mtQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7034
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Thursday, September 29, 2022 10:59 PM
>=20
> Kevin points out that the users is really just tracking if
> group->opened_file is set, so we can simplify this code to a wait_queue
> that looks for !opened_file under the group_rwsem.
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
