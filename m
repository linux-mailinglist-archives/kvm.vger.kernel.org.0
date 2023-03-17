Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B8206BDE30
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 02:38:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbjCQBiO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Mar 2023 21:38:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbjCQBiN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Mar 2023 21:38:13 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F173A42F1;
        Thu, 16 Mar 2023 18:38:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679017091; x=1710553091;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=b8hHafVrinDGBZW798DLihEanuHIwxkVijvhncDZzYg=;
  b=bnAB4Q78VevAI9XV/qPgL7b5mx93uF6eGZta77sLS53fYtjD2hqEzrsq
   ioRdaInt4a9pLpey7me9olXaU0lhizcULzf5IGcp9Xl8ykqZFtpfxoBrF
   4IyVPzTNfkB/hSwPoitXFZN8BnSCQUTXQCic+9P6gcJykMzsxslURv3Jg
   M6gC4v93oQ/mppgv0JEtDSefJ7qpf+xub4mcSqlb6yt4mGyo5Gdcvi64j
   Bg6llRIw6v1Ab08buIXb0Iz5skSAmjdTJ8gWenXJ0NWu0V1iSXEw8LBGE
   zt4h0+xTktal55u4F9l9vidQli/z0JPw4VNHdcVrJ0akhYduQMo3bum4E
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="400739676"
X-IronPort-AV: E=Sophos;i="5.98,267,1673942400"; 
   d="scan'208";a="400739676"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2023 18:38:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="749081161"
X-IronPort-AV: E=Sophos;i="5.98,267,1673942400"; 
   d="scan'208";a="749081161"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga004.fm.intel.com with ESMTP; 16 Mar 2023 18:38:10 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 16 Mar 2023 18:38:09 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 16 Mar 2023 18:38:09 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 16 Mar 2023 18:38:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XEd+uDOyLkBmB1KAFaP/IpkWnfjs9OQtsKSfJI15IExIgUxamUXAYApvLFdjEK3UCajJy704Lu69hWYpw9bKE7d167I8g2WG+j1sg+XZroOvTfKEkLhZkF9J38eNcdhxKYZj3PrGJHmzafAIHCkVQywRGE+TPHeEGQAK1BFHZ12sEvijlnaKLAUCPanEEaD/OnsosdvPQ/8Xd0sWZFRvucDNFL50RBCdksPwuira6R4RMi/5gymrfDMY9GuQCnx3ikjuCPZPoiVOkWK/pNXT4BdKCeDT9jOs03MHjUu5QTk5NZ9GjsPosAM2G6xT/4eRcMgPjjcZ0aW/V1voEhghYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b8hHafVrinDGBZW798DLihEanuHIwxkVijvhncDZzYg=;
 b=dZEeZhFEGDCkg6BX0MGB0/+NVqXhoT6t79MnzB2Wc+ciLZR37ryu5z7S0Yobj387EyrAs0sbz7bkCaXheUEdRPf+A1NVxSr7InS8ZjKlsAx/9DTLW6xTDLZ8PH3u4B8AVNpAaUYn6eBhMQETNi6lwVoEPvadDjMAds/VP/rRMkeVs17CZfwls/oEQiwelMpPmTlokA2sB6J/Ysn3kAD3/QegQ+dqkcCWwUggLu26FvZGDhUdQTeY3oNE2DbEfwNIRe+9U64NJL6JGOwgkmXrwmEP5Dn7u9uQCVcgPh9XVAknTwBh9gJYeABIxmcKpO6fNnIH5l42RXgG9s7VVnQVuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DS0PR11MB7766.namprd11.prod.outlook.com (2603:10b6:8:138::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.31; Fri, 17 Mar
 2023 01:38:02 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac%8]) with mapi id 15.20.6178.035; Fri, 17 Mar 2023
 01:38:02 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "joro@8bytes.org" <joro@8bytes.org>,
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
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Xu, Terrence" <terrence.xu@intel.com>
Subject: RE: [PATCH v7 03/22] vfio: Remove vfio_file_is_group()
Thread-Topic: [PATCH v7 03/22] vfio: Remove vfio_file_is_group()
Thread-Index: AQHZWAaeBmj8E4Oj6Um63j88ogpzf67+MhMw
Date:   Fri, 17 Mar 2023 01:38:02 +0000
Message-ID: <BN9PR11MB5276BCEFFE0FBF73127A7A228CBD9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230316125534.17216-1-yi.l.liu@intel.com>
 <20230316125534.17216-4-yi.l.liu@intel.com>
In-Reply-To: <20230316125534.17216-4-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DS0PR11MB7766:EE_
x-ms-office365-filtering-correlation-id: d8a04b71-a715-4efa-3170-08db26883f72
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bLxWQfJDQ1kU46bLKyAVz9on/UrFKHMUoFRQ9GBhy0Yf2NKwVMzRGB7H/VM1tjqu8hX2juEPCgCBQZtoVzOYzcFE5sdspxOUgNCAPP8WF9MnfGeL43F49wqZmax1RT4tJsbFjAHHU0J94csQvnpFSjsV09thPWWrqOZp6CawdJWpPojNXQlbhDAohx83QAgT9Fh7esv6M+VVH3fK14L7DOkgtEJX0h6ONhrHCKzzDsh0MeLx3UCeJNrx9Hk5F5jsTGhL5sumO1ucRGPrp8scLtkOZ6wupLXqDHc8d1roV8PlmCVdW3wydVCgeAed25+OZ3pYguRUY0PLuzzEUx6HGeTi8+SAWJGKSRuvynzzrcmuv7wZP8JdHxK7SVZn+utTL8NrhKw2dK7+g+2XPUgtxdOZZ47BR6ulXNdFL5oEkMD8y9OCEbZKa41La4nsSqFWe/b76i/5tNVeMhFYTLKHrbTms73pcy2kwwhWekUC4Gq1D02OAgiKDHaeL/Sl3O1tFX384Tg3UZVNPicATuHS27WSibLxsZlL/4/kOzV2Z9sl5smJNwEgSVYPn0WAx7e61Xr3QJLdPQ/spZ/88rOaCye5/c//E/C47bsrJV0XOcCjjYNm9+/aYHdBKDpcQO2w2o4/FDBzwQrKr2WPmjFSwkxCzRXuAvjT8xTa7FEYqPVKmDiAafylxdlrUramK3r5MwhuMtz/zdbxjU0Wsg75dQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(39860400002)(366004)(346002)(136003)(376002)(451199018)(38070700005)(33656002)(558084003)(38100700002)(82960400001)(122000001)(2906002)(52536014)(41300700001)(5660300002)(7416002)(8936002)(4326008)(55016003)(7696005)(26005)(186003)(6506007)(9686003)(86362001)(110136005)(316002)(66946007)(66556008)(76116006)(64756008)(478600001)(66476007)(66446008)(71200400001)(54906003)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?k5iwlBIe8mKs1VDYvqr9iNU6oSaPMOogO2/cBQ3j68/gU5jtAu/QKieYpu/M?=
 =?us-ascii?Q?x9yzUshcNP3SEx57A040LYlK5T7NEYwSCHEev7WheJrTGOT93eMI930pTBFW?=
 =?us-ascii?Q?/muACHHPqqqwqUHT/2DiA3PpwrpuEls8m5kJNk20rPzSbrCsd6k+UXEqJZAr?=
 =?us-ascii?Q?hve7IOyTmiID70Yz0CSz9YluLrFVr1HUhETaGSvGPwaVxIag8DqCJ80YQSaP?=
 =?us-ascii?Q?JTnkAbJd2FC/pEZ7fSzeYmqiIR31Ws3Ss97soWwfNiMJDvqAwT9bMCYn/BRy?=
 =?us-ascii?Q?3h5gkExiNgr1JcdOZ4ZvflarrS12YOjZZq0IsfAjNT1Zypu7c7qLDSASXlux?=
 =?us-ascii?Q?FcGf7pi2yEs24LXvY5ng3J4ZwcFf/bdc6L4y1d5dnnf9pB4p8jEdTUI2ajyd?=
 =?us-ascii?Q?9WmhJ397eUg7aqMXwbNTssymt4bEmxQal4krP9eY9elm65ihSVHVWFRKZo5Z?=
 =?us-ascii?Q?Hc5/ZDRHe+XRh/pUQX/CQFQLsnQgFKkKMhYAcF//yYA7wFAqGbjZYQWtjC20?=
 =?us-ascii?Q?dE71WPp0BscVaYSn/z8fL3Z7TNMk4O/mcvPz6OvBSZcXR/2/tfKeiUUsokjp?=
 =?us-ascii?Q?z73ZkxeL1XTAiJ1yCyOF/G12PgqNMdVaBJ/EYbk9ihrD6sNKkpEO0tvclJZ8?=
 =?us-ascii?Q?JoD0UcunutV8HTkRkcRKiPqlhf8ntUAcjJO1OGlHEbRemo5X8fMBvAOsZbo8?=
 =?us-ascii?Q?owt5DthY0JUzZMRkGEpJjSnMRnp8fqvE+SlW2ycqBf3WwM3T/qaVhZ6otO3z?=
 =?us-ascii?Q?zYft3CL1WeJnlrJ7YhPe2PqLG9F9ubpNRH90uAv7p14J2kp+LfDtUK2u8fcS?=
 =?us-ascii?Q?CQwUYbDOhAX5DPCBm3IR4i1PIlLoQzshM0I6g9xltWPT5bk1E8lhfwaQs6C2?=
 =?us-ascii?Q?zQAVee22hoBNNaYnlf2jN0Lftyn0ujm1ihokXznr7fkTS/EOP/XHyd/9Z0YS?=
 =?us-ascii?Q?vS7Cv2bFcgYxlbWGfIVhT8g2f10aQ4RQ2d5eFGBS3wtiwzLE0ZDd7U09KJfp?=
 =?us-ascii?Q?BtiJKsjitiUbjmkuRpB0T5yLyaHPFz96bwTexUYcab3DsZ2EjIe6d+Oua/Cz?=
 =?us-ascii?Q?q0MgpK2ihdUTgngKOsdEbNb68zDFDZ2JXUlwaZBSy/cl5i2mw7bS5K99kjlL?=
 =?us-ascii?Q?bjfevLqVG8XR2nPQKBxldro65mB3rR8TTxdFodKJM6aQm4fL9IxzT9KxADl+?=
 =?us-ascii?Q?oLfS7nwLix8FoWXlSRua5kWIWCEEoKnNYAxzM87cAag7MSRUq+gFG6W9svI2?=
 =?us-ascii?Q?7J96QJhoJolW74080VBRBHJPmYrbJ/2DfqWZ5QrS+n/hZyYuELF2Lq8hm+wy?=
 =?us-ascii?Q?BwkezYfgSQnuU8L0vtpoJqkiJwH1eggtkpI6qPKdmQ43fxruLCuvNtvZshK/?=
 =?us-ascii?Q?DeM/20oh6t8ewjDqwKkYmsIfPKiCVMiXsY/0WDMLxGuvLGp2Uj/MIJRJbeFu?=
 =?us-ascii?Q?m5DEUV4agAr+RtcjsXIaFtjxPyNbb+SGoZeYkQWXFhFcHRDS7rRWp9fjM10/?=
 =?us-ascii?Q?pZ9w72H8dg2YnUw4toDq0cov6eH82mfQyYpTmqLCMEc+8u62dc7NtRizlT0K?=
 =?us-ascii?Q?PRjcmA0kvyD7x9ZNnhBmoKxUlIdk58cvzr0nVzod?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8a04b71-a715-4efa-3170-08db26883f72
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Mar 2023 01:38:02.4272
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PRWM2qIJfjQveNrdvxTuB57hVbFFY8bpP/YQkCm7/8++CCbjHhpq2x0f0v0Horsjye22RvHs4w0oSTo3EkUCJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7766
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Thursday, March 16, 2023 8:55 PM
>=20
> since no user of vfio_file_is_group() now.
>=20
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
