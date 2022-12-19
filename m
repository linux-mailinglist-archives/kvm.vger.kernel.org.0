Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E01C650838
	for <lists+kvm@lfdr.de>; Mon, 19 Dec 2022 08:55:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230484AbiLSHy7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Dec 2022 02:54:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229730AbiLSHy4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Dec 2022 02:54:56 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 262EDB4A5
        for <kvm@vger.kernel.org>; Sun, 18 Dec 2022 23:54:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671436496; x=1702972496;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/OoUjo9pSbUYvOzVbBjn5K88DNuPnRH7EGS816A8Fi4=;
  b=ZcotyRDuZA2a+jC3pF4gu7QtSsE1gWHu5wrfVM2F251nqGevtpmhcW4z
   B13WnGy4QcZCkubjleBU5SFYEc9Pm/bhREFZHon61IXawxdI2UJUQFv/8
   EQbl1OhapuTIxH1MVrPuQfo66zWLbk+bn+DwA9pjdvthtCnXcUiTjHr8c
   vHJSCTqzytv0ElFlSxcNgSJgpM5eKf8+tzUSwy3TSDxNwpueKbKcEXP52
   2ntk+bQfXglSmMeDrEt8Au1Byh7kyVWoaYfyrvWZ5+mlyUIjvkjD0xCYw
   e7y2xtMeOm3A286FlJk9HJ0n3fhWNgrs027KPeozpJ/3/4MGfU0pYT3KR
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10565"; a="381519583"
X-IronPort-AV: E=Sophos;i="5.96,255,1665471600"; 
   d="scan'208";a="381519583"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Dec 2022 23:54:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10565"; a="600594322"
X-IronPort-AV: E=Sophos;i="5.96,255,1665471600"; 
   d="scan'208";a="600594322"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga003.jf.intel.com with ESMTP; 18 Dec 2022 23:54:55 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sun, 18 Dec 2022 23:54:54 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Sun, 18 Dec 2022 23:54:54 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Sun, 18 Dec 2022 23:54:54 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lUDFAYaihv2s0UnWE74vHAi8AEhMiAhceRXBqx8QpS+8vP9VYddNzOQNGoxT/7swD30E44FQoNObQKyQMI2F/GTG5CAA/dQwxUZlzq9IFpZdugpX+dq102sHCyVrtK+PEvDQTmygvZ3/lKeYCN+ns4xZLM8qh5qruDAoWLAF17irugGatxkulYONRrCrYjU8SS5AF14zVo4iJQ1XJWEfRfJ3SDlmjemxkf0SokHicyK0ArG0WXhqzAgtvZNViFhpcTWu8cNLXY22WHNNZdXz5OB2kDG6gCR+FRfmDA7cT3Prh+B2mF2iUjxnCsg9yBhfAv+x3aUvopN18aop2wgcbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mEdAIJj/t/NK+ea1FnjJM4caJ4jWKyU7/oqJg5n2bdI=;
 b=bOKZ+p4CUKZpFnro+bXtG5ByZdFqwJ+L2bwI6ME+1nPGmMoBEZptY6zkN5S3KsFVyhiPej4LBLdyjwDhMxcDF/RX5Yz7Jtw26KDW+au+dGoaoH4ZDK9OHG55YkkHG7ms2NC8V4sQry3WeZV2whvhg5IRZn3cNb8FeVEQ1RvP55xf035Y8N9gf3Td1PZ3tg1sFHnlCHXx2dVbMIWhziYjCWoCb+rPRSFrCoHnM8KVIPcPO+lNnpM8eDwYbNAlygoOiLCdQ/h5hgTGEUBmtYN9pLnvsW78ztg6S4guU0iSzfju8xJTNIA/2pKv8v9EgX9p+oJET9+3A+pOgfh205aX9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by PH7PR11MB7641.namprd11.prod.outlook.com (2603:10b6:510:27b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Mon, 19 Dec
 2022 07:54:53 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::8032:d755:9eed:e809]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::8032:d755:9eed:e809%4]) with mapi id 15.20.5924.016; Mon, 19 Dec 2022
 07:54:53 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Steve Sistare <steven.sistare@oracle.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: RE: [PATCH V6 5/7] vfio/type1: revert "block on invalid vaddr"
Thread-Topic: [PATCH V6 5/7] vfio/type1: revert "block on invalid vaddr"
Thread-Index: AQHZEX9itzEuUEg4GUmjbMSnJ6gxPq502z/A
Date:   Mon, 19 Dec 2022 07:54:53 +0000
Message-ID: <BN9PR11MB52760EC84CD0E7F473702EF08CE59@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <1671216640-157935-1-git-send-email-steven.sistare@oracle.com>
 <1671216640-157935-6-git-send-email-steven.sistare@oracle.com>
In-Reply-To: <1671216640-157935-6-git-send-email-steven.sistare@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|PH7PR11MB7641:EE_
x-ms-office365-filtering-correlation-id: 50352744-22f9-454b-366f-08dae196501b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: maPEwaRZNeJPkW3Rlx8iTGjd3eacPNvyWlO/8jAJL6r7VFLSzEr+1DnTMpJKfS446ALBGKR5ILOb1/Y6QdCRwxZ20i08FjW+rcGo6SZRushrSn25P3Hm6Lflq3rFzYXSm8J29IjpQJdmeHTFfMGpik1F/g8LnsNdLBHUDA77M65pjOj+MgI8J8vV7LOAztB5auaAF2iynwnaTRp2CNQUCdCagBnjp4OzTlweNnUfN2RVr9krU1Uh9woz2V7Pa5bLHALWJIXpir54FWCg8Ol2qSc3ZX5xePPqP21/98ohVqvWKkfejn76diOmjN6hLY9GVrbtT+b6LaZtLOxQm5LdhbDZodwH44pnqaNsoOLuAfTc+IAdwk7RIP9poQ4G7FZbkuppg7U2Kd/rwccrClsLkTQz0gXA3vRRGoIdCnNlNqmlFDnQFH6rEaUCzHqGN8aBZ0eKwAn8nOCzmNrgiBPJwWh899mgopx5wlJTZROG250lrjtAnDyD5xvX69b3xRQ4+UTAjS6BoU8ONwWicTNTQtVROKgqt+TRV30ADvTrijd3XYVKUyOEA+IloYqI69r8vSFrPIXypahgGvOmWEtWh7EWzdnawIJSZx6lTSS0iA8VWL77ZMpJc157wo9DCLhWU9V3ljkHMq/te9M2XJnRMhu/pBjtZ8kqX22gvpkvtMRwpBIcIGjoLPGK8wdApAJCyvVJ7/elvD876VsajOFkaQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(366004)(376002)(396003)(346002)(136003)(451199015)(9686003)(186003)(26005)(478600001)(7696005)(6506007)(66476007)(66556008)(8676002)(64756008)(66446008)(66946007)(4326008)(52536014)(41300700001)(8936002)(5660300002)(2906002)(76116006)(83380400001)(55016003)(33656002)(558084003)(110136005)(38100700002)(122000001)(86362001)(71200400001)(316002)(54906003)(82960400001)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?SvW5d3KlvEwlvov8stUEoTRWbvUuM8JxkalEhnlQ+/OKprAHr1TYphj6WI1U?=
 =?us-ascii?Q?EOqULvIPEZWlfgWnw2o9VQ495W+cMRM8H1HG+gisehSf2zPlCGjQr/uisevz?=
 =?us-ascii?Q?LmMATrBEQLU7Chtb0WwPeOmkEwkXdTkDACcfisl6NDkASH80I90ViIUTR0kO?=
 =?us-ascii?Q?Mq6oS3sUWmESgiwPqIxLz+Siv1ZKt0qEQOPzJqDbOX1djJOjdDTeewl3Ucws?=
 =?us-ascii?Q?iTAnwauYimShEwug8yDZShKyPo+DVhwqa3mCYAu3FYX2vyORFkCIvZQbFlZi?=
 =?us-ascii?Q?k1aYHgIpVN6gS/bOq3c/OS+NI1f3Zvx0xyJoOd2Vl1LaJGEbt5M/31sodgS2?=
 =?us-ascii?Q?mzZnYzKTpfp0ThxDLZNUj27YF0lg1+xugfQ6y4/w7MBTAb+dCHiiYMhe5o3x?=
 =?us-ascii?Q?3zIbW1vNxSV/ckTK5uk4GMeCi04mlbcrECe4Fj7ysfAwFlJqXxJ9mHwoJPif?=
 =?us-ascii?Q?hzSUA5ZyO/9ZBwEBH3f03qWuxRJh9eKm2ZcC2Ouu9SqVrPihkFJHMf6X2c0M?=
 =?us-ascii?Q?OshondSuxcKU68sfP5l5MbIQSZsJyLjVmUcVH34t8dr5xVgUPy1cVZXKC7iN?=
 =?us-ascii?Q?BuZis1ys3eCcVViwE3ytj+v3nv4SaM0xMZOiBoEDGCPfn5u+QCYq+v99n3/F?=
 =?us-ascii?Q?RoOzPAsRuHoWvo56YqHxEuOiOMHwbQieyxub8sJXq1V71HIvD9ckmilmKnRP?=
 =?us-ascii?Q?0n+Mg7VAh7HzAJ5vO71qPeFWPJjW5camuMGjN1ymGQLFWT+eC3NvQ0pUbCs2?=
 =?us-ascii?Q?Fp/US65hcjCT+JwnYAyjR4mBjYDR69o9c8z5eyLH4NnKuontyjF1kybqVjBW?=
 =?us-ascii?Q?IfJf2Fm1Ahn9M31h1Bsg5H01QgRFVbpzuoyeuGvhe37FQZZd5Npq/ldkfj44?=
 =?us-ascii?Q?2Ms/kfVpqoJl1Al/xObE8d1uYB73kYxKuGSp3rl5XtUldGejifk0Jw/JxNFQ?=
 =?us-ascii?Q?HfYAx2mDqEVxLyGN/sr3VcWsrcPd28eF22JMd7pNFZsraBC9FzHoBpLPSHh5?=
 =?us-ascii?Q?zu+XO11cLh8tzwLy6bbnlM/LZ2cA2VF0Vj68OkQRCBNaW4FvkFPOS8ZSS1F2?=
 =?us-ascii?Q?bUVTpxz+CLqjZytmp97f/nvZLNj5AidvxfRixh5WzJd4IEr/Eq79udUQPV2C?=
 =?us-ascii?Q?HjiHdNUWRyyARBGW6YGkVCvvATPRStm3xQgbXmQEAUmF8o5O5R8efXhFVInF?=
 =?us-ascii?Q?+Gz+8b0iAJzTEaXCqnpJ5Sxb5FVECofvDnqPSgohhPlUcXZbnYzeg7kKuGc1?=
 =?us-ascii?Q?nTl+rD6gP3FRw1UMXYNndvScvUnJ7MBENbXadzluVpBnMXQG/HrQ0E8WeJR6?=
 =?us-ascii?Q?CiY3MHLiIt6EVf6ICibW340oS8gt6m0vX0yNSe5gZxWdB1KgaoJI/Zdla4kC?=
 =?us-ascii?Q?EUQreONVkY5yGJrmOUvw6gRp+xzvjPYtWOMmJzMerjPxT4g7pMAS1BmU3Jm2?=
 =?us-ascii?Q?juD2N3Wc7fNR4W5XDvkfbK2yr1Jdp1J+BXzXQat3kfMtt7GtfJ3P7atobFaf?=
 =?us-ascii?Q?nbig+VTMBQrwFiLfmtWCwRppvADJwVIQR9eWHojfpwfOr7QCcaQqiyfsnHw9?=
 =?us-ascii?Q?4R/I6yZcbjqxuFe9iVAgPIQ3TEyDwbAfqggvnsdr?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50352744-22f9-454b-366f-08dae196501b
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Dec 2022 07:54:53.1494
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 61GeVsX+h0rzMHB4l/e9kLzMO9k5TtTmip7KQhTiEbnYDNsCc+AUvMDn74G8Biz9EAM4hfo1KhB5V8BxYptYZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7641
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Steve Sistare <steven.sistare@oracle.com>
> Sent: Saturday, December 17, 2022 2:51 AM
>=20
> Revert this dead code:
>   commit 898b9eaeb3fe ("vfio/type1: block on invalid vaddr")
>=20
> Signed-off-by: Steve Sistare <steven.sistare@oracle.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
