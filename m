Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FF5355C650
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 14:52:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344626AbiF1J5K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 05:57:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344596AbiF1J4y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 05:56:54 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37D213055D;
        Tue, 28 Jun 2022 02:56:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656410185; x=1687946185;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=QnUW6wm/bfYnSR352YpiCc0U1QJ1tNbNLrpr9mbybGY=;
  b=mKpQd49uD9q0zVsvzRsaP701PtLjz51aiIZRECNdQnGEejUYwzFlGGRb
   OZJbkN+XD+2GHWMLaM0SYqiVk3sUn752DCFF2nFcdfpiqr4ADZ9uM9bGW
   zxKX13wVLF608M1Wnh9TLBpO61ESGKohnoxv2OJnQ7f0z2RWG5pAdmZsT
   BleoMboVUN2wyoW5g6YpuUcERmBo7aYbOgoMPGyxSjn8LGVFACXn7a3u0
   4331obMj+iUK/CR64J1bFMNczqqPWAWJcBjSpmaSrFplBQyoAYTJ3tdq/
   aIKGdBUUKJVuhMRKmaImV+0dijnc0rBVqc7I5ulk2QJjfewZRewWQ41yM
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10391"; a="281734368"
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="281734368"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2022 02:56:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="617131997"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by orsmga008.jf.intel.com with ESMTP; 28 Jun 2022 02:56:24 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 28 Jun 2022 02:56:23 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Tue, 28 Jun 2022 02:56:23 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.105)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Tue, 28 Jun 2022 02:56:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e+hwRkfsIl+wmNLMjUPCH0Ef5fgPkT+pzMXRfATXUv1VpAz++VzVVO0o2MneXCqX9nyzgfEMkd/wHwwPELJcCUAKPOKJRfEIXpZV/04+Im58UAK4ze0kc2bytj/I5JJpbWCSKMBiVSUCEnIHah172vQSFSo4PNR+222oczY2MfdpuMf58Rd1p0U1uXDm8x+DkPyqfpEkbUJXG9gitlI4lOlFYWnlrmAwayRBhq6b8EBkoS4Mub5TdXzr8ncRrI8bheIT12p181OfOvfefQhFRV4CLLwaDwY559k59M4ZRaKrvmbkI4dGeEcwDMAnxIeslTgHXdT0QsQjBfn20Hc+Qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QnUW6wm/bfYnSR352YpiCc0U1QJ1tNbNLrpr9mbybGY=;
 b=UekperPdZ4EpEwd3WxwFLvagTUfGbQQ4i8fs0OJ5HQDUwypVZdFZP7/iUuALRVwghLIgfjiVIviXmcYEg1Xb34+0MVhJckxyk76p3+DALc5RwvDkPGt6sKIYO/hqhPUc6GwjNrlyqHQ0CINieamkYP0ubitQpPgzzEhxh8Os6s80Npypd922+/udgB3bH78lTMIhDzREfxkcn1pKzkMloeRzQFkoh9ixmlTsGgvSwD+E364SZM3Pn8gCcHwCxlzHCJbI3yMsFae6RcFJyCCbMKBPnmdx97WehSdT3MNrTvG1Lm1r2vmeyQBXdB3OYKE+DF3yp8SUgTpj4W2awwlt/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SA0PR11MB4703.namprd11.prod.outlook.com (2603:10b6:806:9f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.16; Tue, 28 Jun
 2022 09:56:22 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::8435:5a99:1e28:b38c]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::8435:5a99:1e28:b38c%2]) with mapi id 15.20.5373.018; Tue, 28 Jun 2022
 09:56:22 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Christoph Hellwig <hch@lst.de>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        "Alex Williamson" <alex.williamson@redhat.com>
CC:     "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: RE: [PATCH 13/13] vfio/mdev: add mdev available instance checking to
 the core
Thread-Topic: [PATCH 13/13] vfio/mdev: add mdev available instance checking to
 the core
Thread-Index: AQHYiq4iLGy5iRxL6UuW51hjzn1nnq1klSPw
Date:   Tue, 28 Jun 2022 09:56:22 +0000
Message-ID: <BN9PR11MB527698C77AF72A095672587F8CB89@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220628051435.695540-1-hch@lst.de>
 <20220628051435.695540-14-hch@lst.de>
In-Reply-To: <20220628051435.695540-14-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 62b04f21-6b6e-4ca2-f133-08da58ec74c9
x-ms-traffictypediagnostic: SA0PR11MB4703:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Y3Ejq8zPVVLR36QtDRaHENtaMAO/9QqCC+Zjxp+qGxvtxeCcLq2Ogc24wRKS4+nNUWtrBtiZM7Lc2Xa4U2scIh5GY3cUvM2Zm+tGorq3sBxw3h+fnXNyDpSvveH02Ux0LuYj8UchfpsmhJgfseAUFHGdmq8aGShIiyKSLIYFFhNPhxZC1ECc6z/iQv7zEL4kUMDiLt+MR25msUkDAnPxGuLBQwkmcFEnMoLsnNU+axhmT4fXAn3c/xhlnIXjgKi80C3Oqp9P1vRqvYh+4mbUXyeqy+OFbu/PFvNEa/wQbK9Wcsl/+G8pq5lB957KnCUwrjXF3tZvDe4zCQ2rfMatclAtWBzlH2zYgYtiKTk4yPBkuZNplu5kko5ShUnqetVIQSPNAi/9qJMbAuegJ7uY3Ofi4fZyiyp7CUkp5kMIjudDEXTnZnPT8AlXzfl5Hl+XjwScGo2cFEsNAGMrEjsIpad6ABsqoSosoyzJIZljfSZFhHkN+g2REChrSkmqjIiY6f0TsA+w7IoYkSgYxH9Liw7ZeUQ3VpdIfz4JnrcATfSDXcV97vlM0qhUBDeQVg8J1wa1G+UYa/NH8nK4T5TzXx+dlEV8FL7D8XTONVRAIkqD3PuKCQria1Ppu7iefVTnJOuy0fvqPO1YgKjBshNm1sIFfERUBTOfaMNo1ZK644TOBSwat5VF+JvFsmaLx8eHm1G5HfSWVBDmID3NHsWXW83Fzh/L7ucrcTR3xJZmFg98yIOyhZo6BtzRiOErd244Ww5nXDsdezEgrJ4SJptsSrHolQ1g2stcBBTBY9ER9RJSRm874uhZS65tE7oTX4Raf+9B/lIvsfsNATexTV/enWxHmxGNvFpoFz3J/8l3sBY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(136003)(39860400002)(366004)(376002)(346002)(9686003)(316002)(83380400001)(26005)(4744005)(55016003)(921005)(82960400001)(38100700002)(2906002)(86362001)(38070700005)(122000001)(7416002)(6506007)(110136005)(186003)(33656002)(52536014)(7696005)(66446008)(66476007)(76116006)(5660300002)(4326008)(54906003)(41300700001)(71200400001)(66946007)(8676002)(66556008)(478600001)(64756008)(8936002)(131093003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?42KBrTzRQx45Dx+46U/wla0gcIiVfM9TEfte8AoGIWYDbdm3xsuXTug2Uylh?=
 =?us-ascii?Q?0S/hrsYfRZhf6ns0pZsprzm6db3sF4JKBZR2azFHFfrNv058/w+pgnXWqJ64?=
 =?us-ascii?Q?leD+pZb9SmXDEdLB0xdCxknZ8lB/5x5CaFgt+2n1hfVJEmoHt/4opFHlGCFC?=
 =?us-ascii?Q?V5Kqvvd8FWTGysyQI+MozGzgZScz597lQXYndKvT8gbhSWyjXY4wSsV6lV7s?=
 =?us-ascii?Q?khefXXMluwht+snymzLSiV5mnm0H2AHeq/irnmWeeMLheW46g8OiVyIyTc0t?=
 =?us-ascii?Q?y1Ce64z0ZngRwXAIhkjltP6I8qpl0dVVP9jIVTZBt/cNJYaZV36tHGXMnRi5?=
 =?us-ascii?Q?2l9CH9Eeslxegw9yH+A7LVEmS87ZVSDGVOtUNDDkbWKKi533ntKGIqH1dYix?=
 =?us-ascii?Q?igDGtc9qesEtQNErSBZ9irTJNYYdRNBLepEmVKDZrs/u/6dDAvA6HruJmIlI?=
 =?us-ascii?Q?gv/spb1fLZCyNFhFt3i4ZBXXja1vLGholdmghlgNdAjj40nNQJsNKbLTsiIR?=
 =?us-ascii?Q?OWmWd2YBnDpGhUHU+mtdnWIP1t4sJrZg+dFW/ix47Hihg/SCjAXorlps80lT?=
 =?us-ascii?Q?OX62H2nhmgM+S78nmpdY/ZdEdWAZDmzRaEJra/TXSwpmWYFvYVPwvCh+F8cu?=
 =?us-ascii?Q?vcsFqTBGS6jVuc55bpctTPNgzcK+5OmPz6rkiQW8/p/AlkZNtKuFebMGkW8M?=
 =?us-ascii?Q?zs6GCYrcArtdvru9h0ZsCKwkGcvJBb+/037In4O9Vv1EdJmQPHjMZc8X/6Pm?=
 =?us-ascii?Q?YBuM/NOsr3A723sZ8uMrWPsAqsd06IYx+2wuKOA9f2YMe+xwd/208EqExZ9m?=
 =?us-ascii?Q?E9Tefg3qdQfD/Rwh+i3z5iHFEFRxygWENQ7Vs1CM7XARBSildoev8cDwSF8M?=
 =?us-ascii?Q?nP7e1sSu3tk9CzhW3nLs4kchYkOThhaqBmFPA6fTfqfdUFC4uGOqb9juJ9JE?=
 =?us-ascii?Q?Yw2D6vZmi6xN1UysFJEk6q6+Pn8jUdHyF+sKowpmvm2a/NfHl90PjN2+Qbm7?=
 =?us-ascii?Q?0DaQ3RV8opTAmC+8MbS1YkZJtqcf8qIrAPx93iIZuYiXzffqbmCKTwg2mBk0?=
 =?us-ascii?Q?rgjsaCdgB1vinZ1sfCF88NNEeSXmz983G82p2badYoJ1FUI0KmtwXtjaRQfL?=
 =?us-ascii?Q?pQEF8OOAIkVXJTnIirCb05iG4v6rfIIWg1tePI2Rox9SUyM6jOtxTWiyo1Qu?=
 =?us-ascii?Q?Op0sqlh0sEfSaKsT/+FbLZzjnFmZCwLhikcVZRw8PTvpFs7yUAxEjyY+QOf0?=
 =?us-ascii?Q?rzdwXEQHOVcx9Gh5suCw2zWXjHGT8knNEy9CiTR/7bxJgH+/t8AdE8m+JKF6?=
 =?us-ascii?Q?hBTraIzfrX/l0IiT64o89R1yrm69gbxxAw5lwnCB3JYYe9RrlunTFCaBA5kN?=
 =?us-ascii?Q?qtJ2zAIprkWMqLpiU32+iG3YmIzEMwYtsYi0zDsrIchgInpPTHvWUTFes8Lr?=
 =?us-ascii?Q?y1EDITwTUaSyaboCTyOPIluPyIAibSfnXvOidG5IhC7LswVxRQFMoFPTAA3X?=
 =?us-ascii?Q?rcYWm261Xzap1W8jtXwOGMREgDA00wt9Oxo+3bHgxltLIHSjpkJBaC+qOnSB?=
 =?us-ascii?Q?kXOWup64xznREjpGY/fcW4ghyvzyDEbwAf0un1P1?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62b04f21-6b6e-4ca2-f133-08da58ec74c9
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jun 2022 09:56:22.0639
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: H3W1Ha6r/jv4u13VaQpwnKB5qJAzU+lCENCTholi9HsM0jDCWN8/ST0EGG2+QCuJdkus0ZNMhOuCpbsO+FztDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4703
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Christoph Hellwig
> Sent: Tuesday, June 28, 2022 1:15 PM
>=20
> Many of the mdev drivers use a simple counter for keeping track of the
> available instances. Move this code to the core code and store the counte=
r
> in the mdev_parent. Implement it using correct locking, fixing mdpy.
>=20
> Drivers just provide the value in the mdev_driver at registration time
> and the core code takes care of maintaining it and exposing the value in
> sysfs.
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> [count instances per-parent instead of per-type]
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
