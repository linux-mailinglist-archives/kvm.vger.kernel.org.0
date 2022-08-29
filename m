Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E83485A4067
	for <lists+kvm@lfdr.de>; Mon, 29 Aug 2022 02:39:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229589AbiH2AjH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 28 Aug 2022 20:39:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiH2AjF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 28 Aug 2022 20:39:05 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BE8E31EC2
        for <kvm@vger.kernel.org>; Sun, 28 Aug 2022 17:39:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661733545; x=1693269545;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=19JV5alu4p+hLCc/wa7ASMA1Inch7WzUKh6uTTeY1mk=;
  b=WqKZaCpEHUYG4Mxk1dY37xCZ9ex5RLx7ifVa7kMGYS0EOYkSQCKb+2BC
   kgV/chGZITKRkKgjf/BTL8Ob88Fd4AuwKe1WLjozM4iczNLB17Ym+Uf4G
   ixh3xEQVTkDotQeHv/U4MkWCcMEqMPx8I6ccbtFMNxzCvB/O0E9TCCJHK
   Ap8u8hV0d9PLDSjZucbnQuGb8SxJmR5XqboTXRZCFlq1q7sOxJqfNqpRn
   +PTqMy9p/JBRWSh6kemFMMRylo1HkY+SBdGn04VHJWrExlqqP0Qfe98lo
   oknz412YAXHXBUp5UCbOp+KeKCZDTtGcE9I11tjQAi20HlrGfG+weu/5q
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10453"; a="358746397"
X-IronPort-AV: E=Sophos;i="5.93,271,1654585200"; 
   d="scan'208";a="358746397"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2022 17:39:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,271,1654585200"; 
   d="scan'208";a="611113864"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga002.jf.intel.com with ESMTP; 28 Aug 2022 17:39:04 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 28 Aug 2022 17:39:04 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Sun, 28 Aug 2022 17:39:04 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Sun, 28 Aug 2022 17:39:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M4kN3F845mhcC3ZTTnBXeWeqaC5ic2W7HsOx/nlHTReDXWXzZWXux487CknRSFQS0CiQ8Eadnc9thx3aU6F1hF6xUBokhDdl0RiwtGcsynHl6beHd//HNVvzkDOBQLQn0nbS0ocAg4xdaEdNqDwLACxC/sT2XBFqiej2h0nWGd1PiBVcMtr4n3U/JTBt+7wZLBW+wW2zjz6aVP2+vjdIM/WspyyyfCw+XDrgEsvVD7aG1tieCMm06Q7hQ+GgO5Vn6HBUZCrAZ5+a0MyULTj/vIWBCIhCc8C2O8exUp8iq+zePvtRSMJ/GOT0sg8ZXqDjx8B9tmfSp2N5zF5PP6d2hQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=19JV5alu4p+hLCc/wa7ASMA1Inch7WzUKh6uTTeY1mk=;
 b=i3TJ2ZLn6lMl1Magc3ZjPfeYxc3QNrYCMdFl4dV1weKtifzExwdpW9364uqKuTCzvwBdH6xqpHLeYptGRUPQrnx7LcdM6H7NrTafUJJfo0hWuKLEVAjOr4cV6zOGPPk+0kdP+7O3LQtGHEg9J5FCNt2JnKFARKPFw91TB1nRPsFIj9k6v1BB2SmxNNg0o1ygZ793D9R5vi1kNEiGwQ+PI0zTqirk5bmOzdrjTOC2tMvV+dawCk4CpeZzCc2i1QpWT2SVfWpilUaNvZMyTVglMpAihBLV0oNrot/Enn/x6/j2EGesEVkI4kzNcwLyX00dHtLjT3g/rdH52BUI8snGDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CY4PR11MB0053.namprd11.prod.outlook.com (2603:10b6:910:77::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Mon, 29 Aug
 2022 00:39:02 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::3432:5d61:f039:aae6]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::3432:5d61:f039:aae6%4]) with mapi id 15.20.5566.021; Mon, 29 Aug 2022
 00:39:02 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "llvm@lists.linux.dev" <llvm@lists.linux.dev>,
        Nathan Chancellor <nathan@kernel.org>,
        "Nick Desaulniers" <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>
Subject: RE: [PATCH 6/8] vfio: Fold VFIO_GROUP_SET_CONTAINER into
 vfio_group_set_container()
Thread-Topic: [PATCH 6/8] vfio: Fold VFIO_GROUP_SET_CONTAINER into
 vfio_group_set_container()
Thread-Index: AQHYslOGFW6sHspkKkGOTCVAyB2d7a3FGr+w
Date:   Mon, 29 Aug 2022 00:39:02 +0000
Message-ID: <BN9PR11MB5276E9D37A9BD2E9B87456848C769@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v1-11d8272dc65a+4bd-vfio_ioctl_split_jgg@nvidia.com>
 <6-v1-11d8272dc65a+4bd-vfio_ioctl_split_jgg@nvidia.com>
In-Reply-To: <6-v1-11d8272dc65a+4bd-vfio_ioctl_split_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d9769a60-aea9-4246-039b-08da8956dedc
x-ms-traffictypediagnostic: CY4PR11MB0053:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3ZUOz1omcRr92IcNf/hQtRdPIsOicxGFty+tvJJ5yh+Q4DZWgQSbV6rE4riYFVQE66HvRKjgc1ToGd6tA+PYnPedXGjlFCMUuVUTltP3dYQCVbCAHnvaPbDnnnHp6ElmaSh4ZLzTNlBo1d8nzoleTMCzLkSsQCgptM/IePxvlSZCqMGhVz42Q4w5IhJk6Z/cwIdh0Ez3AZkibqEOV9TeSJwYzVnX4fKD9X2C+N8o0cAQ9/VC0ybETKgkBu4nJmHDXMhuzxU45Yh62iVR7D9ywuWKIVAn5JjjtAByPkBwWkr3g9CvZeO+OervNzgQw/a7mUFkn8GcJWEn/f3JttvnH7rOdS43/UURJiipyohDKAxPcaN/qEmagbJKS9/hO/RxiUJqzxwkRscnpZsLIone0yvs6jBVKoKlRfR2FsqXWogWb3BGDhtbG2dxgprtyfluGVabCnLxWJqn++YhH346Z9gguQHvwEwFtqHqe/KKwYAqiqvCuMZ2mgjT11xuGcEDicpPNp+pWt2L6qcbtuRfdKkYjTVC0wQ6ZdlWN0N7D6q8nI33OruAsKmfYsnTTXlSnY0sb5Bh0WMeBdSd1+QAM2Y9oaKWtud/1dBiAqEbRFYv1s17mmBzLun9fObKdw2vpeBh4zsYQ7K3z0EK8td0FqLAQhaSMQo9JZGug8ahMPdpJs2KNQ4YZxBQmIY6lbvNQF6pJX+pS2+AgMKi5vRlvRed3sh8QEnd/FJwgB4bLMeiZyGZMFiyYoxIgndg1PxcOk26xzNa+Z2bHZdxDUUsiQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(366004)(136003)(396003)(39860400002)(346002)(41300700001)(8936002)(5660300002)(122000001)(52536014)(110136005)(66446008)(316002)(38100700002)(478600001)(71200400001)(64756008)(66946007)(66476007)(66556008)(8676002)(76116006)(6506007)(186003)(33656002)(7696005)(9686003)(26005)(83380400001)(2906002)(38070700005)(55016003)(82960400001)(558084003)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?gFP2SFeuDIDLeQdzJRpfzR+i2eAQ08HHqJPp57dbmH+dr7Yu8Np7KTUHDMlI?=
 =?us-ascii?Q?vuoiQGNMpcMfPn1BGPW4owq4N8XtmCA0Tt3byhXNMooEwivh+IcYtXffdCLD?=
 =?us-ascii?Q?aTm7G8CFPgZ2qWA1snRiAdT28uoo9L7H9d90Ab8CSpQgm1cinn1wD7OiD10N?=
 =?us-ascii?Q?nD/E/N8blyFKT6Hnb1+GIOZfvbByGJqHHNWEprhE7u8vTb0UnX1p2eBLhSwr?=
 =?us-ascii?Q?hrb9DzNJPnHg5i9WH01TBpH1gtlmGcNowFDfuNn5NEownVd3GykB8bCbRgMD?=
 =?us-ascii?Q?9kBdXA3XJ7CPf/kqpLIF4d1/mf2dr+ZNfYfxuEmYLBsIziMIe6adJc6xwaKm?=
 =?us-ascii?Q?m9QBK0ec+AanVGsW0mKbsjSKqg0uwxq8+cLr66fSw9jjjZKl3kvpdaD3x9oY?=
 =?us-ascii?Q?s2E8esjqPJ1noJqbpLEUjtVSrVm5JLaK6iKAv8FqYjAO2xC17kHHdzwETp40?=
 =?us-ascii?Q?Jugq48pQHBhJrQJvSt6dhihrh15Go349HPcohvnt2JzEulZsDC4SlhfSIYjc?=
 =?us-ascii?Q?lcVCt7AjBePa7zAfVl/THCMRYPA/nTE3JtskjpmLwHbuaNyfSyjqkkHMbm3Q?=
 =?us-ascii?Q?5hP60HralNivaj/pq0JCvw/jXhwjecZrLRi3zq2l+W1kBATVBYdHxjq0Vvj3?=
 =?us-ascii?Q?nWC8psK4m3QOjrETCCMxkms8Ui0sLIKc0ayqHcLmrFmOgM1YS2MYfrntMrQ+?=
 =?us-ascii?Q?zWDUFrfYos61bjKCIOs8j02jwCy20N6OZ+4MvJ6ygYRafuPBybPL6GuDftLX?=
 =?us-ascii?Q?xcCIaTf55vJn6V/N1o/8hiZg6+8H1snqwrtvoF6KkuAX8IOPUfbGpX6Js3kr?=
 =?us-ascii?Q?UwiGbHpOs3QIFpmGQhsXFRhmehgjNwpDSpX+nXjA+nBJ28W5hK7VWCvhWrXX?=
 =?us-ascii?Q?x3qb3UdQ/JH0poXh6vbxvdNzZSCpn1BQu1RmDf++7IeKC7gChXqpk6PGqCEk?=
 =?us-ascii?Q?ggQ3zV4lBxiZwE9XuW4AE/GEQiB6rXSvBYd2kKqyq3E4poE77GLWnlqLlM0Y?=
 =?us-ascii?Q?fK8qyxMwVDpE0n7PbRlEyUuXLcA2CTsBKwLqmpEOfspuGKUAfKa0mrdiT0O4?=
 =?us-ascii?Q?rL76gWa9qs0WEby8i+GUdaCMCU7/Npck+W40gW3nnq0Bxb2x/at4rEmN2JFE?=
 =?us-ascii?Q?agONDhPTrM2DUH4HqnVQgyzHF1/3Qm/7jDy3RmJ91xQ/WcSd2ClRlDpH9jQw?=
 =?us-ascii?Q?YKbthxxS+dsbjG0WqUhN2Hyscrjvbr4MCMYzovnsjCw3n6837H9xqB7N5Kci?=
 =?us-ascii?Q?ZdazqtSZ0Fc1olTMvAN7pNbZl67TmJqRGgBvlXYPSnacb9nNYzTzbcD7OtWa?=
 =?us-ascii?Q?LqhsPosf2TfBTqET+G3d56SMd4waAMgI3xZXxiAf8BiWQmtAOFcA0InXr2TH?=
 =?us-ascii?Q?TzUWyqtvp8misi9+kQ4hLzy7VL+zVGVzRSUzwRgAWYni3E1N8siaS76a1Wxb?=
 =?us-ascii?Q?0Ls4eLb5PVZyFILRab8AnHucqZWqe94X+EHFVTIGDAJrEDOB8v2cHyuWIPYl?=
 =?us-ascii?Q?r4k8ikUd9PD0Ivlm3IppPgr3RWkPePcWiL8dJqADIbo+kiC0nkwuieuttOaN?=
 =?us-ascii?Q?Kv4eFp9FRqy9iwsu2OZjPe8HOqmRQVGT+DbSJ6p4?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9769a60-aea9-4246-039b-08da8956dedc
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Aug 2022 00:39:02.4875
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XgPGmed0O7JthaGDhPlK0eIh3lYzJugHdnyUOZyIFYSkHN0+1/MusbA4cWZJFvCImm/RhEpQodBDaQb/G2R4cg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR11MB0053
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Thursday, August 18, 2022 12:07 AM
>=20
> No reason to split it up like this, just have one function to process the
> ioctl. Move the lock into the function as well to avoid having a lockdep
> annotation.
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
