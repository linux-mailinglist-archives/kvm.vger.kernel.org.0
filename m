Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3C70690210
	for <lists+kvm@lfdr.de>; Thu,  9 Feb 2023 09:24:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229628AbjBIIYv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Feb 2023 03:24:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbjBIIYt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Feb 2023 03:24:49 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 119FE83DC
        for <kvm@vger.kernel.org>; Thu,  9 Feb 2023 00:24:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675931089; x=1707467089;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=j2L1HSYpsdaqUfTGaXg0W3cizVZKnsGmsRPqTR51VUM=;
  b=VprUGRGyYhiBEp1aVHtvDV3WR8iu8JfNwZML7XMko6s5TbFcweQTI5GM
   4SSE8ZVR4wBVAFTceXfj2DY9OI5qF50GZY8B3xfhS5/1jZ90r6zeDEtQy
   TfI1a8H6n0PTZjqvpijlXEtrpdlqMUWhxP9oK9/LaZiWmAaKWS4gMZxAa
   R1YjmXaU1YAT4IPQHF2qetYPUcmcWNu/UWPVIy4YqC9QuXK2ag2uRRUTh
   zDI+v/F0RSexmbl0vkzkC2JOaRg4k7Vyx31hqiYF9jukwMNpu4qG7Hde5
   lSDWVSCYH2KH1S4bWgrXsD6Pl771HzeXIuDP77EQ8dupjPrVQ90YFxozx
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="309697969"
X-IronPort-AV: E=Sophos;i="5.97,283,1669104000"; 
   d="scan'208";a="309697969"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2023 00:24:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="736250470"
X-IronPort-AV: E=Sophos;i="5.97,283,1669104000"; 
   d="scan'208";a="736250470"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga004.fm.intel.com with ESMTP; 09 Feb 2023 00:24:48 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 9 Feb 2023 00:24:47 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 9 Feb 2023 00:24:47 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.109)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 9 Feb 2023 00:24:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RbHPYg4bNC9agtp3CXHL4iZm+mQDdEBhQ7RWri+JJtIJy9sXYxlAHBGtX4UylIe5u+gczfI7OtvpKuvJ8s3zRh7FOFbs7j+flokrj0yTW+vCyHpnHk0BklA8C2RD5HGuCmNBN7syMs2RauSvL18V/z3noLeEULezGITyyJYjU1vmCguSXP5dFNAxkoHoXH4obDqZLJ+g9fhYTEYBb7GwujwI96VAMQFu928JaSgmsdUeVoNQC5J7sLij0WeLKQ+RrQ1Xb+JovAYxOFWlc0kHQwVCS6uMoNBR1tISvVA65xUL/bDAE+H05JYQ2w2ycH5Sxv63P3txieGysVdWw2lxzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j2L1HSYpsdaqUfTGaXg0W3cizVZKnsGmsRPqTR51VUM=;
 b=bXkvfpMZ7wh7J90YUmII2eBrcPCivJOXgjyPSrYQpn1Sx3aE5ghVEdvFZy0iemd7MZy5sR0O1RbT6TeSRQr52G0aJEFQT0cqnnPzqewabz6yeSF/lb2k5fTAACIARatiuAimD7rKAaK6K/HDpKE354mfMzP7LHL9rBkVRNMSPjQuLJuLjF8d64whMvYMx/xJv7bLgn43uoYBukkfLE5Q9YfT4UAa1eT3Fp1q1xqfSH2aFdEOLBk4s5dx95XRy8YQXxdLB1O7ZiwOE6hXhCM+6Iy+zXZqrVSSlmnnyIDsvoxum3X7gqXTcs4Zmgr7hteYDb5OeCg2bbi+BAHEJS1Cow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MW3PR11MB4635.namprd11.prod.outlook.com (2603:10b6:303:2c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.19; Thu, 9 Feb
 2023 08:24:46 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d%8]) with mapi id 15.20.6064.034; Thu, 9 Feb 2023
 08:24:46 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH v4 2/2] docs: vfio: Update vfio.rst per latest interfaces
Thread-Topic: [PATCH v4 2/2] docs: vfio: Update vfio.rst per latest interfaces
Thread-Index: AQHZPF46M8pzpqT57U2qTO6RGMD0xa7GRyMg
Date:   Thu, 9 Feb 2023 08:24:46 +0000
Message-ID: <BN9PR11MB52760C0CFBAF8B1E0834FD738CD99@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230209081210.141372-1-yi.l.liu@intel.com>
 <20230209081210.141372-3-yi.l.liu@intel.com>
In-Reply-To: <20230209081210.141372-3-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|MW3PR11MB4635:EE_
x-ms-office365-filtering-correlation-id: 01e4cc70-060c-475f-268a-08db0a771a63
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ph0frDWzJUOy/NfQqbhBu/wb4fo+WRBDEiQtISQl777PSOs6oCAyoJnhKNEtbk3WTIvBv+NCOWTMDFrra3VvKvtoX8Ku+lfDmhir5Eku/w4TUjrBdUEFOkY2vWW8WQRDCm3UHqz14O3RzIgBMgFFMS4CoyQTyXddFmuuM1lsIScf9XTirz99y39TEtp2t+VJxwKFO0saurasUUp1kgpNQp8scVkwc29melydl0Ku2mlycimIPY9dL5zGMDXYfxyqePBBj/3gFc7twC9Paq5wdZP52KJjB9sm16BIOgL32ukk/9Z/Z1vz/ze0ChkGpQoXkJadMTV4ZVqvpr9IIYTYNYMehty7pd5RIyJezbLaZhRqzkjQDUOnUGNrVqDIDI5USMEbSahJlMJNT2e6ywerjRq5frStCqanCFRnyv/NkgnJ374FdVigua7KZovQQctpkdAUtMMdrMoIm+wAT16Snl5Q3q+FFoITeEYwhEDrZLwjK/OUQ+mrPv6Q5diDVTK461PnPy/S9ZPpg5ITH+srucehX3hq5eUBOSc9O9BCUJnqtEKOvqFflfBAuOLJKcWV3sXeZBXUXzlUq2ijIMiRDZ6SHJvUtHULVHMj4olujLFtQT36NChLxBIP+VRx5usDqGlcVjzq3Qrj3Eh/hZrljgW9lchtlyKaqdv9lp/nkONTQ1MJgyZxibLAnB9AtKgcvwB5TsYqEuMKgDSBhdLsnw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(39860400002)(396003)(376002)(346002)(136003)(451199018)(5660300002)(38100700002)(186003)(26005)(122000001)(8936002)(82960400001)(52536014)(6506007)(2906002)(9686003)(41300700001)(38070700005)(8676002)(66446008)(4326008)(64756008)(66476007)(76116006)(66946007)(66556008)(316002)(86362001)(478600001)(55016003)(54906003)(110136005)(558084003)(33656002)(71200400001)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?XiLQls3rXLFeE8X7htuTiVikAOpr21OlBJjpKFiJx/MH0oIbZ/Dy1s87lSqx?=
 =?us-ascii?Q?XRmb5+59m3JnS5fbTdtFa+A6skNc7kZD9OBfk8Wsq0+1sgW0N5Q41M+OtIod?=
 =?us-ascii?Q?RJeybz4X0Ho9JGs8S4/Eo8PiJ4lN8Nsez7l5tJjrIjrO2dltSxl1wyYs52PE?=
 =?us-ascii?Q?NoDwCLETePfE+PVvWi1EQw2Wzkhe/t521n8mN32H4NthPBCmK059RzsSwfkB?=
 =?us-ascii?Q?c8XIteKph1zUsIfxAE5uySsJWmp/5IZ09P6QOIWYT4sITP5X3ilvjgLiRo02?=
 =?us-ascii?Q?r5dLmdKySYsAH09JppgCUdVEoZYLvShdOFuwIfuI6puHlqcld3wggXVDrQk/?=
 =?us-ascii?Q?p4YcubSD1jWILbOTk1nNm5NeLzPhHJBQgLQkRHkADv3JEAGHzWU4dD4ud6PY?=
 =?us-ascii?Q?sP73tyDyxNxBxB0jsfSFt70x9b3gYHMQ/JuipNQ5/Mi82k3G7UgXwLRBSb9F?=
 =?us-ascii?Q?66gl1Wd9XAxDK4wi49SA7BtgnkK0RLbjBQQAAbH1H31PVAumAFqpQp7/bnsX?=
 =?us-ascii?Q?CEmQpylXOWEbAWL7vL6+m1d1wlLgCFu9ZTaFoVtIBmxrlVRomAOEnh1AR/EL?=
 =?us-ascii?Q?G4RYqy6tkYMaC2nzy9bOHotYDs+qaTP6085zVjgFyHi0qT2hOF48yQ7Oe7IU?=
 =?us-ascii?Q?aRHFLwGFgpK31gbWfApqjAsGuBSth9/RMUooyJTd5hbyuGqT2StsW5Uhc/Qu?=
 =?us-ascii?Q?XvqZ5eGhdLaPap1IuSLK4OluTHih9hvzazfADJwHSffk+HNWUJXahYBCBdN9?=
 =?us-ascii?Q?gAWIGVuTJNkdYZoRP4f8CgcZhokp97RbaZhMmyL9Y+2fOn1dH6miCWAwswvb?=
 =?us-ascii?Q?toM8yAjMHGe1uy5TkqLjkGQntXpkrdOU9kTSG4m8ze767ZvqESNal95x1aKI?=
 =?us-ascii?Q?Z6Wbje3x5N7RkCZhc1ak5g4iH6a3w9ZrhDhnzuVEMOCB7mf479K8KoRD6NtB?=
 =?us-ascii?Q?M0GKWgLturtb8IT2x0HgaColHlV1MKJh88ZXBXYvirN86AEcezHb7dXhujEG?=
 =?us-ascii?Q?+f5luWEkYpIyc5TyjifqR8aLbkCO75ZcJmZGCjx0IsinDQp1Dx1I9yr29M1i?=
 =?us-ascii?Q?uqLlQFNXVaAC4cQaYTTKI9OUTGMA0XI8vrimMMDU9MuTEovWfqHaJI+xZEpO?=
 =?us-ascii?Q?7xJOde2ag/3xFUv+OeGNbNyeUeX5d1Ly+XzmPrvYCb5oZFIVNFYJPuxJ6BBT?=
 =?us-ascii?Q?h3Op4XEQpRxdaNV8VuEKGZHnj8bEcp0ahTQw/rkgwcMntLRY6BskPdEhGVt/?=
 =?us-ascii?Q?0FjmYLJ1KQeGvAKV/fK/ixK60nUXIV72xB+kvRmvWxBLjgTeuw+8AluVULWy?=
 =?us-ascii?Q?OIMDKe/zgFo4tEvuLa1J/Iagd6UOCn04dNkLRjHUotRu7zmC53tX2YGf7W2E?=
 =?us-ascii?Q?xV0BHITU0HcAguTWwNDvusqNuAzG51dhlnk9HHtLbajwYm1WEgFkT5e6zriE?=
 =?us-ascii?Q?esoH2nIqWVL0ixE2aUf8JNwaKWy8VF6x/UnwuAPhrmRN+jp8WiHVf2URgi7p?=
 =?us-ascii?Q?8wXDevQ6mqbPl3NMU5LXMMWSjaJAe/2HN1DxV9K9i2W+YokIYM64J62FnV9S?=
 =?us-ascii?Q?SsSWgPWOeAkp2F+0A63NcCI/z6bsUN79UtyCeku5?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01e4cc70-060c-475f-268a-08db0a771a63
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2023 08:24:46.2680
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gslRCH09a6IMnlvRR9w5YPEsWJ8ilyPo258LQj/N4so8EAcKEqkEsKAHuDYh9APXvni6yNVn3hwrrKvN/JK3wQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4635
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Thursday, February 9, 2023 4:12 PM
>=20
> this imports the latest vfio_device_ops definition to vfio.rst.
>=20
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
