Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F15407D0A27
	for <lists+kvm@lfdr.de>; Fri, 20 Oct 2023 10:01:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376449AbjJTIBD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Oct 2023 04:01:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376417AbjJTIBB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Oct 2023 04:01:01 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6843DE8
        for <kvm@vger.kernel.org>; Fri, 20 Oct 2023 01:01:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697788860; x=1729324860;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=6GIXQzcfkzlz7eslCfMns94j6FxsyGo0WayASz2BfR0=;
  b=cjn7rMWsKZM4CLIahfq4xLwD3bAnVbJuiwwni6VsW8JG4DgwfDXjY7R3
   +hJvwPKXA3VRHi4bQhz0zkGzFVDwHJVWElGc+2oLh4nTXrf7/RKwb2xrv
   aCmc+YsUaaZQcUQeE/JLGo3bkAt3Wui+i9fAk+wzELSLguwtgCEs2I15I
   hpmwUOjGZFpVy+yBn0T7BSls1aq7dYkNbDd7pj/iVRL+RSKHfaUZrab/+
   hmpmXUo36fQCqQfkj5NgB7855UdJvQGpIfJo7+tdSkNXer0Q7xTM6WmYm
   A9nAgVYWYcQigyMGClTU8lFQzl7mJIRWTD03OcttG6Mn/4F2u74gqCFDe
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10868"; a="450676970"
X-IronPort-AV: E=Sophos;i="6.03,238,1694761200"; 
   d="scan'208";a="450676970"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2023 01:00:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10868"; a="827651175"
X-IronPort-AV: E=Sophos;i="6.03,238,1694761200"; 
   d="scan'208";a="827651175"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 Oct 2023 01:00:59 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Fri, 20 Oct 2023 01:00:58 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Fri, 20 Oct 2023 01:00:58 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Fri, 20 Oct 2023 01:00:58 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Fri, 20 Oct 2023 01:00:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oGE7b7KBUQE4ORK2Xn56JtpOGuysBO6uArE+9idRpZB/QkL4FgngRBB/kJHLmiwQ80Ky+Q/HkVbokofr1+lbedNDFmqAJF8EKGqU5JEZKqy/nYJ9yeTWRSzoeoSBbiEDZyqjB2wvJQ3fHxkEWMYdHWz6EHDXfkDA1mlQ72HpPgu2loxrfmytInATxpo/ls0FtzsTx5w452jiZDb/OqN+mkUiZ1pl10cyBPbFVKylioZlIr82G190I0U64W4n7Q/WGY9tkniy2WqT/mnN2yfyzXFE8rITB/ETWpPi5cvnBBeOn+HB2X+yGG37dd/jdKLabKp/5Z74MeiryQ75oQFgKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6GIXQzcfkzlz7eslCfMns94j6FxsyGo0WayASz2BfR0=;
 b=OCL/qpfrvrTLQLsZoWcKSKgYsCInL9dBKefFsVH6gVCuFAHwLGUlfNcvTxgrnkiJIihwXpCmRZPvFiS8rPcA27D+Sx+qYy9GK9ppbEJSWDvzrsxMrIKO7Y70cNN0KnvC2HllWcMaSTFJ7/nz9EJrxH3sJJW+FFSqb9OLaboL9hGf/fFs3OIDwmJAkAKPPIy9F7Ll2YQGwH/CtMC6xapHrFJK6V3T/JbME0MfbTaUhktLGQDctMF3g5UBRcFd+W2GA1f6A6w1txTmStERonl2yydSESHK+HBdu/H03nBz335uyrD1exUv3utg834nyWvG1kto+A9l8aKXTcdKcUvXfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BL1PR11MB5285.namprd11.prod.outlook.com (2603:10b6:208:309::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.26; Fri, 20 Oct
 2023 08:00:55 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::7116:9866:8367:95b4]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::7116:9866:8367:95b4%3]) with mapi id 15.20.6907.025; Fri, 20 Oct 2023
 08:00:55 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Martins, Joao" <joao.m.martins@oracle.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>
CC:     Jason Gunthorpe <jgg@nvidia.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Sun, Yi Y" <yi.y.sun@intel.com>,
        "Nicolin Chen" <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Suravee Suthikulpanit" <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Martins, Joao" <joao.m.martins@oracle.com>
Subject: RE: [PATCH v4 15/18] iommufd/selftest: Test IOMMU_HWPT_SET_DIRTY
Thread-Topic: [PATCH v4 15/18] iommufd/selftest: Test IOMMU_HWPT_SET_DIRTY
Thread-Index: AQHaAgHFc9xtA7Bbw0ab9nPbhdIk7LBSUv0A
Date:   Fri, 20 Oct 2023 08:00:55 +0000
Message-ID: <BN9PR11MB5276C27CC96DA39AE619B5CC8CDBA@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20231018202715.69734-1-joao.m.martins@oracle.com>
 <20231018202715.69734-16-joao.m.martins@oracle.com>
In-Reply-To: <20231018202715.69734-16-joao.m.martins@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|BL1PR11MB5285:EE_
x-ms-office365-filtering-correlation-id: d10457f4-3708-44f4-0491-08dbd142b005
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vQsldbewO6GLkQ5EMIE5ZviNC/SDah/MexnAs/sqQDU0tOISo2GW/F41kqGumEr5yi2scFUym2ZAD2m5WzgzQzg9DWw6RRXOlxcQI9RQ8viFgYfw3N407BO1a+bXfsdQNSzTz+tS+1ve8MuPnHLov+pBg8ZDR+apqQ65ePctZaMPq7VyAgLm5wV42tvF/+b8+qZGMxrhiQNhmqWOMSdfMIXdVXxkC88eWZXRcTY4gLiww7b4ZmLTJ7DeRkrq23zcNgqGP5IpgR6FhTi13ILEDS7yidW1R29VqbxcHZEGXR0rRIQA0V1rqm1+eQ7IbnVma6WwiyCgum40jZQZ21/F5U+rJkETNZ1FEivGJpbdSG/ZOO5pDeKo1DaMSI/UQCIm+yU+LyZAE/BCFRgBr7zfd9cj6oghaxltL9nhtBpqQEDJO4idLrrW+zaEr7J9xwzhX4CeZ8vaZnfmxs+O2x0eErmstOK7Jx8VmfbrYspvQbDwOmJcaH1yd+ek3kDyqPhYKrpYRBFG5SVpnnrS8tFqUyLA5PyyDR3J8m60qVPxNDaf+jPBMfEoZnUCU9qKLkA+qvREvCKovb53HPIj5bITcxQeczoGAbqIQkisCQ3ard4T7cxTo+ogEvYrKR+uPGJBtQ5jYc0oOy2wCJEib/C+wg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(396003)(346002)(366004)(136003)(39860400002)(230922051799003)(451199024)(1800799009)(64100799003)(186009)(33656002)(558084003)(38070700009)(55016003)(316002)(64756008)(66946007)(110136005)(66556008)(66476007)(76116006)(54906003)(66446008)(86362001)(38100700002)(82960400001)(122000001)(26005)(9686003)(71200400001)(6506007)(7696005)(2906002)(478600001)(41300700001)(8936002)(5660300002)(7416002)(4326008)(8676002)(52536014)(14143004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Fmkspwh1Zf77KMs3EKIyy0retpd0M7YByxMvKK7+CaOz65eRwjPcsqUFGEKI?=
 =?us-ascii?Q?3GLcWn8o8WGCxGb/FBmmI2TM4guc/2IwJUB14O8v2ONPIbP3Un1JGPz8TecY?=
 =?us-ascii?Q?m0QgGCGKLySJQoh22LEztPZSEHZVirLDtMwTc2Vjex1dsSZ/EwonyUHHjQ15?=
 =?us-ascii?Q?fht5zWiFBBG5a/K9xfuljd6HKnI7Pnmj6Emg3Sxgr4kPXlkOpPi077PX0rAV?=
 =?us-ascii?Q?x/PbpdoU7J0Z5+nD3FZ/2QoK6WRSCBZKi1FaM/X7qaaxi/11tvnU2SWkZzz0?=
 =?us-ascii?Q?DGEFxyMTu+eXX6bWgYTw+qKrEIPqs92v7ml1KxXpLfTLL6Z0Uv3/SqtWOfKU?=
 =?us-ascii?Q?/5A36Dgb7Z6mjN5kS41H3p7ndMsGI9oPluIoWaiQ5BozOwWdaj7xaOItBn0b?=
 =?us-ascii?Q?Ywq26QtFms+tINDcMHNA4F0XG4NNszfnrVBbdg19VJVzNAHG8/bRuMWiq7cH?=
 =?us-ascii?Q?A8eCCAJD0G+wW+GD6uLSnaGtOcb9YrMSgJCfXw5jXOn33VyC3rDHh2e1NFxz?=
 =?us-ascii?Q?ekKG18kqId5iWReVdNIYribTDpee894vlH0wUCJ1WAzcU3RRJdMmmDuCm/8n?=
 =?us-ascii?Q?0B7KDUq/T1D74wYmx6masPiL47jfi/R0wmfX8sBaXWs9d5VoSGElnnhAqNRg?=
 =?us-ascii?Q?RIF1x84VoJbaUlPOiZb8AyUt4DgDiIAC+vJy6qSwm/OHmL85h8MLzm6LkH/x?=
 =?us-ascii?Q?Z8509CHg++m9FpBfJw/YrB5Z6M9co67y5PILbxVPXzBKp+Gz0FdKR0DTf4gw?=
 =?us-ascii?Q?6EizxFVdLJO4JzKrCe04NYF/I1KgZB8DyNYKI6gl3mMRGjrXOW3XxYGv4hNI?=
 =?us-ascii?Q?Xr6iUp6hs6pjB1+U1HxVIscDN7iEyE54pEhtUphRhfcOYwPeQT4X29NYcPLo?=
 =?us-ascii?Q?2AxJNDYu7wFPPrqbKHAQCF1hpjgZZXANgQgrICWPyoox0Nk+GTieXDR87xgO?=
 =?us-ascii?Q?62xIPooUaPUb6DIfgDXAQPkzndHDGCVPSWMH1qkk+5TgQpQvAF5ktPiYVCOq?=
 =?us-ascii?Q?Uy92EUx1uARHTWfiJVOlBtdLDkN6mfQUGUvquSWB/8bWZipb2irizLhadROK?=
 =?us-ascii?Q?RzQF067jwv1isXmEBv0eaN4OK610g7UYNPUQtcUE5zP79orXfNWDO+rTkw/F?=
 =?us-ascii?Q?FUPGDQ5XpTnxtN3WuhKgQ4YAEcqVG0Cp8e8aV2Fe4ZB3b27UeYG+hpLLiQcP?=
 =?us-ascii?Q?UIPXGWaEc+ZpPKMu3V7CDPrxYqSxUSmr3T0ryK4qpPnfUEQ1Mzsv70PBAJ9l?=
 =?us-ascii?Q?Hdlzk5XXk4CKbqj8LrQIF9ZQAj690KASldnnlmAbHw/0BjvtIgdjj9VKWY2h?=
 =?us-ascii?Q?M+EdVmNrWIhxj3he3+2UeZGpf+6XSp6Fql5d8Fhy6zIfOtef0u+MLuicIZgc?=
 =?us-ascii?Q?cAtMSHV11K9tg74KUw2GilOwprHHdQ4y79s6yyxthYae5Uwuy9aGB9KJ9olk?=
 =?us-ascii?Q?cGnLmAPjkZgcBUKYSoe1mDUGpnlooYWdsVK9ml7h0kGNXbBR9ynzrwbkoEKx?=
 =?us-ascii?Q?Zp3I0NGxgpyRK8JmLM7JFoB9OcoudKJRFbCgKYGlK+8XPjt1gMYLHxWP3P+V?=
 =?us-ascii?Q?rk5d+XKS2e41uKTB28uWwoYJMjMz6SG6uIuLs6g/?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d10457f4-3708-44f4-0491-08dbd142b005
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Oct 2023 08:00:55.3790
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tL8NJ0W6FJxfWgt1imrM8SCw/Fkl+GRIjEwNlOAnLBdMYAzH691MbwJk3Uu38oDlkNvg/1PTO7mAi/JZfWlgbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5285
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Joao Martins <joao.m.martins@oracle.com>
> Sent: Thursday, October 19, 2023 4:27 AM
>=20
> Change mock_domain to supporting dirty tracking and add tests to exercise
> the new SET_DIRTY API in the iommufd_dirty_tracking selftest fixture.
>=20
> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
