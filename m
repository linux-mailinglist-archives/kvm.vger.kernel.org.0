Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2C1068CF48
	for <lists+kvm@lfdr.de>; Tue,  7 Feb 2023 07:08:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229756AbjBGGIi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Feb 2023 01:08:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjBGGIe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Feb 2023 01:08:34 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74D8040F7;
        Mon,  6 Feb 2023 22:08:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675750113; x=1707286113;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0TKUNV2LyHM79myW2Frdi4ccj/fjpwOWn6Yw8Yq21kg=;
  b=MW3Li3hyc33yFnLzNficBFS9QdcihaJ0IAZ1GJPsJprD3Uey0qOrPOTA
   yucmaF4rXESvXU6bT5+ob1+H9ypwNK67nG/oFGymmfYEVhDvaxSloBS2H
   obzEJsB5sBl8b3D0+rpj0fLL2AzFBAgbou6wWjn2CEXHsssivrpOxIMs/
   P2/nVfpwbLcz1xmdR72uZDEWOCzCramVvrr9DVsxspAw1ceP9vsnUZx/m
   dMfu1XvZm9lE4P4vBsGayeK34O3TrvuhLSMWoBVpa+0d+LpyyuT4m4a5B
   PpEp5yZdx61OQxy+drPTIOc/suA5G3hVLKmlWM0xsXazXcpQdUE2BO0Z5
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="415637176"
X-IronPort-AV: E=Sophos;i="5.97,278,1669104000"; 
   d="scan'208";a="415637176"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2023 22:08:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="809402285"
X-IronPort-AV: E=Sophos;i="5.97,278,1669104000"; 
   d="scan'208";a="809402285"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga001.fm.intel.com with ESMTP; 06 Feb 2023 22:08:32 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 6 Feb 2023 22:08:32 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 6 Feb 2023 22:08:32 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.105)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 6 Feb 2023 22:08:31 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ebdQNht7T8lFgFdEmefV0voZpx52HS31RNBM7DTNh9eTGrsWWm4cyOsBvhaNhpy3RiQhepR2gtVdEUdz7PkTl/BEyiohlB6endfedaHe2bZn4u4+xkYA6BBa2+ZROlUXMvVSmCl5vCl5UrCULr4Xj+zoggTOkXMLppSsITMfE9f9tLfkillkFcAY6xM3AjJzxfBRA7HkweaLJGyZiMpNMpEn+LNN6hB6FXlPpxGEXSQD+HKzlL5WtAmzB00xzoT3bfMz4+c/6o9GZBVvP+AWyIMbWdrXv5TUEXZpd83YchOsXyY79mEgRbZN/NzjGoeSbQKZgQBgYIc3FKFhaaZl+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y4FxyK1qIEDPXlIidXZ/u9Xz23mDcDx7YRC3f6tbqOA=;
 b=mBeJHvPFy5VdVsv/aC7194QbsNPwsle1SMZ9QFKCh4PfKp0vZCcAoraUh3AZ33SQQTii/eU1cEP+oUXzESUgIuF7B/fu6W0GsbBD+l1whAXkoQ6OaGbd+KtpY6kAxmqZFHq4cjKBKWAbRoQaYLSksFvhEUYGfKR7h6Xbi6FDFJD8EktE4vV9eeyqq31ixLc/WqSOlrCy6Ea55l0tCXoyaJ/BhcDXqnCDoHGuqEe6KRSVDKEjR0VGhbr1odziIe27ceY9PvqhGE/s9yR2jtm66vaAgZKD3uEqLHrihYSjH0GbOQQzpe5Ecfy+qWkpWYIPX/NqUqlmhc1wwA+fowMnBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SN7PR11MB7509.namprd11.prod.outlook.com (2603:10b6:806:346::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Tue, 7 Feb
 2023 06:08:30 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d%8]) with mapi id 15.20.6064.034; Tue, 7 Feb 2023
 06:08:30 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "cohuck@redhat.com" <cohuck@redhat.com>,
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
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>
Subject: RE: [PATCH v2 10/14] vfio-iommufd: Add detach_ioas for emulated VFIO
 devices
Thread-Topic: [PATCH v2 10/14] vfio-iommufd: Add detach_ioas for emulated VFIO
 devices
Thread-Index: AQHZOgpBycYF2k4go06YrPFjr863NK7DAPzg
Date:   Tue, 7 Feb 2023 06:08:30 +0000
Message-ID: <BN9PR11MB5276A57FBB6F999DB242CFB78CDB9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230206090532.95598-1-yi.l.liu@intel.com>
 <20230206090532.95598-11-yi.l.liu@intel.com>
In-Reply-To: <20230206090532.95598-11-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SN7PR11MB7509:EE_
x-ms-office365-filtering-correlation-id: 97495722-e618-4e87-c830-08db08d1bc5b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VLsqdOAtFkGjCZaIuXT2pVM/8jwa+mcczfBSe1nNKXsxKszM9lnlNyE1QLHX9oiPyqeWElBOTfx+6G9ipeeSy3gebJkH/tz+PvLrE31YqSYYsr5dEfudz1Aw268QV3GwzpHPMVpgIWJtFj+KPmlUM4UJ08ZCrvXLeYO5b/YEZgAK92gONbJtInhrX887/ex19c8OtrfhKBGZiWOHjyuXx85TYaEf7g+dOzzc4E2rop+Lf8lrOBEHP/QqSSxEDcm16G/PWqKlbO7YV6BvpcrX7Hf0Ya3K1FyoAmbfD5haZ7fZAgnHYyQWKhP5swaPctqhXAQHFmrZHyucR+AKcxS/8iaw4Z/BqOoqWvSqQgmkeOW5X1EuG7IkktmsQUw+3YAfWgHIQJcY3DOyUNqvh4YobB+uZDLK1HQ09zk4h06l4bYw3/iemOgYbbx6vqsEitFtBGxnLV91VyekJJvX4cB/7Kudrd8Vc6B4Nj18BknGsqOwi3qJqKInXFF0h3FLXEI5RNss7twcnI5ID5PZCCIGOfn9pQct440mrR0k7HbrNfNQ9xrM02qlH4rKewpHw9eSRfWEC6yM+LABCv3z+Tmg40VI6fcLd7NID2l7k/ITQ6PQEXkXli11cjZLVRXIpoqcmKMTU5oWg1Rqbo6ytGO76LfP+uVH7BSH1ALWE7ffGIpiUP3ApzF9Hsjx+CAytQrlHjCCmpjUgB3tr8Met9pCWA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(346002)(396003)(136003)(39860400002)(366004)(451199018)(38070700005)(122000001)(82960400001)(2906002)(83380400001)(38100700002)(55016003)(41300700001)(66446008)(66476007)(66556008)(64756008)(8936002)(4326008)(8676002)(66946007)(76116006)(52536014)(4744005)(6506007)(7416002)(9686003)(186003)(26005)(71200400001)(316002)(478600001)(110136005)(54906003)(7696005)(86362001)(33656002)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?hkwFRHftXwyCtKrA9RoZYoQEQ7hDn9bsAEJGFSFKqRajS58K+zhFDY+2USCi?=
 =?us-ascii?Q?qi5hdTtvuM5HyrP/+HI1y/1FWH/w0lRchPqqhTZ4JcPJPpQ9VdPzb5Dn9enQ?=
 =?us-ascii?Q?cqPtVYKkuBw87G6cTYH7xYOGAuOuKny0IwF7jWR6t3WwYJH+FppndvOWJggb?=
 =?us-ascii?Q?CHxi1PFF6MRsCswdjDip4LOvwi+QxmtHWG5oFGaW9bY8QK+DOtjjwJpC7vVo?=
 =?us-ascii?Q?cSahAPEsok0dm0RHvOfsfbqIIJ+81EaLV8z0It8VNKd1NLn8Hm++wCFLry+A?=
 =?us-ascii?Q?kMsz8kz06h47ZK1NQgf0yDkLAn7SfDISG0Efz1t+fQGurs0WfsT19KfTT9DG?=
 =?us-ascii?Q?2y3yX/e+5CcZyCBvKcbUGvL+pgBKF5El5GJm98VY6bmGAAvF302vLWI2BWBf?=
 =?us-ascii?Q?4OuqtazkuiH89YxgZh42/V8O2jDbHT1n/9mjnE994bLZ4OPdefebvHj74aN7?=
 =?us-ascii?Q?RO7NBZ/J/J53Fd6Md8OdPJK6cAheN/+kyQetZmdJB4W+5Vzs6v4AocJ9bpJ8?=
 =?us-ascii?Q?eW1n00QeyiLqrsOLJ/YMDJq/GXD7kxatJNnLr2S75zB6s/JzaX+IF/0gsIke?=
 =?us-ascii?Q?3LfQQr+8O2Ddp5yWmszGCGzO7l7aR8/0+RzLpGePLYkwyR7/7uxlDEL8rqvz?=
 =?us-ascii?Q?JMYW4diYcyToXNY44T0/MSfMPhgA0eJmyOdKaNdVhQMM0rFBF5Zm+H2ES1HY?=
 =?us-ascii?Q?/7JdpqZEO+bttEE8PC7XsaRoCA55h040E7ird8GF9nlFBTU1TDJByUEpvfDY?=
 =?us-ascii?Q?x6aS0zkFBWXh714oxSkqif6qTP+ICjETBsT5mkGx/IMnqyoxcgk6Edy4gbQw?=
 =?us-ascii?Q?vnerzpNSfVgy60H4uTTCxsUvUKo9uD4tFqfwoAvFVNPRYj2EejoBnTrjnu79?=
 =?us-ascii?Q?4oLOBcH8iwurnLck2Ouui1aNTWEgLpbgCKQivLKkb8Wsy9GVG3mBeNDMOgFQ?=
 =?us-ascii?Q?VJ2Yi7YoY0G3TjUPHjzcvDU+jy8BWzqpwoXsOTMj31tHdoY9AnUpvp7BB/MQ?=
 =?us-ascii?Q?2mmcnaTXtDPPOPxbDAprpLsoE2tmhOsXWa2ABFRHfacrO8FC3ivNjnpOR3en?=
 =?us-ascii?Q?UB6fn/w41MYHFFShBnMQoIpV1mzJtGS96DCk/0bjhZx9bOYVM35CxnEU0HXh?=
 =?us-ascii?Q?xk9qWCq7BoIShLSwNU3ay4tg1ihX8i9VqTzdtKqwsviUusCPDwafeVRgNMg7?=
 =?us-ascii?Q?NL3cCd4Y+0AWLj3DotaAmZHCTjcUAEKTMOpoagYwdmMX2GmVEnwHQxM4NhYx?=
 =?us-ascii?Q?8EC/8jFMYiJ5WAsVvWmLhso+iMtbCT06oAb6gQa9mm19kavhAhbWvrs6KwL8?=
 =?us-ascii?Q?oz77w5LNZF0nPUmHTjT3HQZ+mosg1tCgfGjF6iIz1nb5wRRRbNfJnx0zB6yD?=
 =?us-ascii?Q?c8r3irs7uZvjKCAZHqbjAjLkaM0tmuX/MPrE2lLmAu59bwTQABVLMeQlTCk0?=
 =?us-ascii?Q?BPuqzw6wjvFBeVhDOe1mTDyc0n/ROtzlNMzWsG+dqsltA61nFSHGD4lxgSBd?=
 =?us-ascii?Q?x6CL9EocFMyNf0vE9XCSiaZmJBgnioDEQKBra9LBT1xxA6+0pEJDTDnS/aMd?=
 =?us-ascii?Q?JjqsxwI89bLPkErAKRAGUO6o1+lqpdQpOB7QKpSQ?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 97495722-e618-4e87-c830-08db08d1bc5b
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Feb 2023 06:08:30.4063
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3NGS0Cq0THCWpOdjUw8fLJpznvs64JW7rt3QKOlaUrWuWox0x/8haaNwxY8QWbWP2o5jx7Lzo+Ao6UA0UrujSQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7509
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Monday, February 6, 2023 5:05 PM
> @@ -149,14 +149,18 @@ int vfio_iommufd_emulated_bind(struct
> vfio_device *vdev,
>  }
>  EXPORT_SYMBOL_GPL(vfio_iommufd_emulated_bind);
>=20
> +static void __vfio_iommufd_access_destroy(struct vfio_device *vdev)
> +{
> +	iommufd_access_destroy(vdev->iommufd_access);
> +	vdev->iommufd_access =3D NULL;
> +}
> +
>  void vfio_iommufd_emulated_unbind(struct vfio_device *vdev)
>  {
>  	lockdep_assert_held(&vdev->dev_set->lock);
>=20
> -	if (vdev->iommufd_access) {
> -		iommufd_access_destroy(vdev->iommufd_access);
> -		vdev->iommufd_access =3D NULL;
> -	}
> +	if (vdev->iommufd_access)
> +		__vfio_iommufd_access_destroy(vdev);

same comment as in last patch.
