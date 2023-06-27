Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39B0573F4FE
	for <lists+kvm@lfdr.de>; Tue, 27 Jun 2023 08:56:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229983AbjF0G4J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jun 2023 02:56:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230468AbjF0Gz5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jun 2023 02:55:57 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F298F109
        for <kvm@vger.kernel.org>; Mon, 26 Jun 2023 23:55:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687848953; x=1719384953;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=uHQzKMcn+kxVBJ402JxANROCqtzXq7odPwDYncKyJTU=;
  b=ZJdjKLCEKOl5SGR2Lbm+91iO8GIyyaglNDXxnUtBGcWYesYLWh3SzjY3
   6p8P0eXtfgNJpnCz+j+pnl+JHHVDsPJTEIS6TMkJ2SWhzM+TzRJGyHjt9
   sN8w/VXqEFS+de+GnJPl0As0oeAwBUUM+y0EnwPgfcaivSh2EU6qxGcRO
   NR6gRBq+BgD+9eXZ923BULvHRCHYPrlBpozNob/LWUjAKbyOjV+k6Dh0m
   A+pjIx3J5gk9+Rt+q4tOaN3+j90xrYPEvuoJdpip6UbNabV9XDZ+yxLuB
   ILFtAW+ViVwXS5cbZ5f2W+CyXxfS7x/24qGKXlPybylCsJFmql84DTYGw
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10753"; a="391971967"
X-IronPort-AV: E=Sophos;i="6.01,161,1684825200"; 
   d="scan'208";a="391971967"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2023 23:55:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10753"; a="1046793325"
X-IronPort-AV: E=Sophos;i="6.01,161,1684825200"; 
   d="scan'208";a="1046793325"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga005.fm.intel.com with ESMTP; 26 Jun 2023 23:55:53 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 26 Jun 2023 23:55:53 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Mon, 26 Jun 2023 23:55:53 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.44) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 26 Jun 2023 23:55:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oGkRNTPWuSZprpxSVevsMpHngt9+wxkF00iGY5uAzHcbcc5cTYnWYl6lt9cNGqTwnAr8AaGjl3ZCRumyHa7CQfEL5//fG30t8AMWNnK97VFLzAZBo3hcCrPq8k4sV1741roEDEUlStp4yiNFz0CqcNYwMf6yIn0QN3+FyDHWAWNu5oyZo+eR0sgFia5A6UCYLe/PxEVFSFJnecTczD7bo0N7EgWX6Q7mAnXVCxwgjyPOsfC3/TFNrojKS+JiSIw8kXLGWurTY2f0w/ZQezpl5dG3kpPTvU0W/nkcaxe5vTIISxQTaNfA+GN8EAgofLD6qeSUnm+EWTapC7DEImeKWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h6lFrN7QiBM/tz2BNfmejmbbvHPLakJfjz5p5iK/QjY=;
 b=Lc42aF8mK5BJ/UKsxqETsxbnVm3LNBelThc3VDMBkcvuUw5G5nbvfE+HSKBC5PSSb28RKpVZLU9KqqPBd/JEIxuWFVe3ZkEQwQZVpdm2AgtnpKVzlRN74XiXaFKIfkSFfBwwPM4EVeH3PLzo2ZRCF5yEgCX8pz3EMq1Jv03iUzw1HzrriKrjtWI/6NBxuPUeoQ2eb1RONgHptIIyhLg6LMkMVFUFb4WLjVQHdNuB+fnaDU2/CQvJkHKSyF6PvM5sJc5Trp5JyODwdkQjvdn5hXWAwWGxH3Ji8FQusqMbMjH5Qhgmrwh6Db+StJZkSWwVyUTyOB35y6yvXk3YHHhydQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by LV3PR11MB8508.namprd11.prod.outlook.com (2603:10b6:408:1b4::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.23; Tue, 27 Jun
 2023 06:55:51 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::4f05:6b0b:dbc8:abbb]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::4f05:6b0b:dbc8:abbb%7]) with mapi id 15.20.6521.026; Tue, 27 Jun 2023
 06:55:51 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        "Liu, Lingyu" <lingyu.liu@intel.com>
CC:     "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "Burra, Phani R" <phani.r.burra@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [Intel-wired-lan] [PATCH iwl-next V2 10/15] ice: save and restore
 TX queue head
Thread-Topic: [Intel-wired-lan] [PATCH iwl-next V2 10/15] ice: save and
 restore TX queue head
Thread-Index: AQHZpCB1ah9A4W1eO0m2o54BmDbDWa+VU4CAgAjlZSA=
Date:   Tue, 27 Jun 2023 06:55:50 +0000
Message-ID: <BN9PR11MB5276EAA78AD4E3B7B7A93B168C27A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230621091112.44945-1-lingyu.liu@intel.com>
 <20230621091112.44945-11-lingyu.liu@intel.com> <ZJMLHSq9rjGIVS4V@nvidia.com>
In-Reply-To: <ZJMLHSq9rjGIVS4V@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|LV3PR11MB8508:EE_
x-ms-office365-filtering-correlation-id: ffad2cfa-47db-415c-cdeb-08db76db8b4e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zsEQ4dnEcXPfAGbjTBeo4aXJLGZfgTIj0NAd3hfRt8h7xSPhJmqsCm5yrB8sJNM8BQ7FB+PvDw/4RATA2BYchnImlrDZaTSp4sJAz4iPEZ6IKhWjWrhD1HZQv9vKGGkc53mRDdokQ9GX+2+v2HNJn35mCnMv1jhUMwUI9Hx7DdyZnJXxO2Al8/FjwEg2QDUoZxDGzhQEZYapm1rT4HYQ4vyquMjmiRLvu1jT7CHr6VzPRjCs2F+HqlzmLe4ajHNQy0QHe7muC2J/wF+BJYwNA/B4BLRwMN92DsY13h84Q9da03+MkrhXEdU9pl7VwkmqjSBVUb9cw+kL4gCh/ZUujAaBUrAT/GeZEVbkszMb8jhEvFwcEDwbJjvcl7hMaNoLyP2bB7w+X6h4WlpnsP2IgsYMLte5UXTPAxujTwACTUbvXXi1+e8+tptT/NTFicy3UusTi/aIc1UQZVUayxiB8sT82MWYiGUJVPYmuDiPqCpXge9vuAKnpXsbDByUNYNnm6cEs6xzs205VJYPEMmv5oP4mc3gAUq2PXUTV1YKNUJoHfeCkAmNCFHCUK3NLFoHsmt/osi/HX2LTMve04WyYOAu3v4zHutpWFpulIdtXTkgW/LFj15e3UTZWahGjczq
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(366004)(39860400002)(346002)(396003)(136003)(451199021)(38070700005)(66556008)(66476007)(33656002)(122000001)(5660300002)(52536014)(86362001)(8676002)(8936002)(41300700001)(4326008)(316002)(6636002)(66946007)(76116006)(55016003)(64756008)(82960400001)(38100700002)(6506007)(66446008)(26005)(186003)(9686003)(71200400001)(2906002)(54906003)(110136005)(7696005)(83380400001)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?YxcntkKSrYX3pRwCekb7WFiqdgsEqdINbrOWOx8FEeKvNAN3xM89BCiQSzg5?=
 =?us-ascii?Q?4U8W/1ct7HBac3Qe413v1VTLCdYGlWLWzlha5lwcm1r4DC5tZpwTtmH4KFdl?=
 =?us-ascii?Q?BTD+lNycJvUGIlHKcsEkrO2QvQHdHoMohfdCiK224MhoC7Nk0y/NUxrScks6?=
 =?us-ascii?Q?+k3WBvZrTGXQSrulPEJ8fxAvjdd0odsQ8M8fP9vq+nsnQYolbxRZcFuKyX7W?=
 =?us-ascii?Q?BYe1bYI1pfiRPlFZDezq28srERproY8KJxOlfnYUPpxIABpEvfVQthgqCC4d?=
 =?us-ascii?Q?3mW6jPzPVJiMo8TfvDe41yTbM1tB/NUAowLQYqulpGEPClChmCVQZgWl2lGM?=
 =?us-ascii?Q?b7hejj6UZX3luVozDPgfhn/Zy9jrEvhgocxSO/3xyApQLCf+5qDX//8KejkR?=
 =?us-ascii?Q?7ut2cGOlgURObEOzmFxLr6KoZwM79g3Dw9QT/R3/MApUsZLqOhQCwCZZx5kb?=
 =?us-ascii?Q?EkWMUqgr2nlHWKjhn0eIcM7LoHYhMFrF2uRTUoRlursRlE1VWwNu/8ap2N3T?=
 =?us-ascii?Q?qMLe7pcmHv/ORBbPm4BduHtQzEOvr28bU40LYPz3TM1ydneSubRixOmkIH+Q?=
 =?us-ascii?Q?x/z+idcUIhMA7oiDjplNcFNMC/ydFYPK+ntLUx9Ls777EY5sQul7N2NM0W7n?=
 =?us-ascii?Q?9imJ24DXpGTmZdIU6OYORPuiz8WYdtJMLpvom7NQBsCUAcM/LOH0uq02srnd?=
 =?us-ascii?Q?eLMQVvkf8cH5LbCnM/YedI8WF7fm4COZdgd42IeKLox3jzjj3KAyiI/L594U?=
 =?us-ascii?Q?N0VjUrxn0Fa4ZUGbg+sck2pTMBINGeexMixG0wIpVpgw+iNxvvwHLJiUW4J0?=
 =?us-ascii?Q?fkChg3p+7Wu1nkH83+RZsLfRXrjuT5EVOmlPT27vdVDfB5uwCXBfpFd4/159?=
 =?us-ascii?Q?YrgOsMZy8pSpnjGihP9WmRHBFhj/3Nq6yA9bFoDyXRHlTLtsD10p+z20p9hB?=
 =?us-ascii?Q?oJ36zuFovwbID1sWD55HJQCMVJPw732q9mrdmAbVcfF8fjxEZ14mb+15/wAD?=
 =?us-ascii?Q?SqU7oGIdFGsZb7GeT+bJOvL3/zFYH0XzJC+heH3VzT6QOCPcF0g5PQhcUs/C?=
 =?us-ascii?Q?WxQaIe32lw5K47F2b7vaSamjmQd9wVU9Ezkn0s7+WwWotxM1xX7dLSA777l6?=
 =?us-ascii?Q?cQ9X2GgpdwP+wvpV5ssr2/M8Ls5sQPjaX58ePY7ju1gW5dPs8D2Y1fh9fZzQ?=
 =?us-ascii?Q?6sOKhKMYjEY3LT2PWqFqx+pwPmVs8rJgQ9j2kPp+DtkbCB1QZhzeHZNAB4eM?=
 =?us-ascii?Q?p0LD9J2VL9WSMCgGbF0bYPabi1Z11amyo7VEdHCQNzZY0AtDFu7PRhIhWS9Z?=
 =?us-ascii?Q?aq+e20dIFFCuDkR4TU4FYcknK4UVvJ1svXa/whdNSn4A4EF+upWtjTHTwaMC?=
 =?us-ascii?Q?jKx53ViImr3MNvuc4knAwf0vduXJRgvq6VFJbWefd+7lJvnEFaAmhWkKE7Sh?=
 =?us-ascii?Q?Zb5CmkKXOg/++B3rgF79TJEuld5m4yPwMW11mZnYjd01pjOo5atEEyUbWPCk?=
 =?us-ascii?Q?/ulgLy9Q/6Q3MtmlpDikBQo1/KSDlZrxC9uuFFhEHYNWSbx8TZkGoIOTU6u2?=
 =?us-ascii?Q?sfmu2Tow3secsx8/h3GXw+7hVVWbmOy8BDgKW8PT?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ffad2cfa-47db-415c-cdeb-08db76db8b4e
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jun 2023 06:55:51.0025
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ovzZ5c5DTmPv1VnfQ4ktHRP8CNkoTWTrgiQLSxTVnih3E1j3WaNAz9KR6mKKP4suAUNSgy6IOA3pf/VZv5NyrQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR11MB8508
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, June 21, 2023 10:37 PM
>=20
> On Wed, Jun 21, 2023 at 09:11:07AM +0000, Lingyu Liu wrote:
> > diff --git a/drivers/net/ethernet/intel/ice/ice_migration.c
> b/drivers/net/ethernet/intel/ice/ice_migration.c
> > index 2579bc0bd193..c2a83a97af05 100644
> > --- a/drivers/net/ethernet/intel/ice/ice_migration.c
> > +++ b/drivers/net/ethernet/intel/ice/ice_migration.c
>=20
> > +static int
> > +ice_migration_restore_tx_head(struct ice_vf *vf,
> > +			      struct ice_migration_dev_state *devstate,
> > +			      struct vfio_device *vdev)
> > +{
> > +	struct ice_tx_desc *tx_desc_dummy, *tx_desc;
> > +	struct ice_vsi *vsi =3D ice_get_vf_vsi(vf);
> > +	struct ice_pf *pf =3D vf->pf;
> > +	u16 max_ring_len =3D 0;
> > +	struct device *dev;
> > +	int ret =3D 0;
> > +	int i =3D 0;
> > +
> > +	dev =3D ice_pf_to_dev(vf->pf);
> > +
> > +	if (!vsi) {
> > +		dev_err(dev, "VF %d VSI is NULL\n", vf->vf_id);
> > +		return -EINVAL;
> > +	}
> > +
> > +	ice_for_each_txq(vsi, i) {
> > +		if (!test_bit(i, vf->txq_ena))
> > +			continue;
> > +
> > +		max_ring_len =3D max(vsi->tx_rings[i]->count, max_ring_len);
> > +	}
> > +
> > +	if (max_ring_len =3D=3D 0)
> > +		return 0;
> > +
> > +	tx_desc =3D (struct ice_tx_desc *)kcalloc
> > +		  (max_ring_len, sizeof(struct ice_tx_desc), GFP_KERNEL);
> > +	tx_desc_dummy =3D (struct ice_tx_desc *)kcalloc
> > +			(max_ring_len, sizeof(struct ice_tx_desc),
> GFP_KERNEL);
> > +	if (!tx_desc || !tx_desc_dummy) {
> > +		dev_err(dev, "VF %d failed to allocate memory for tx
> descriptors to restore tx head\n",
> > +			vf->vf_id);
> > +		ret =3D -ENOMEM;
> > +		goto err;
> > +	}
> > +
> > +	for (i =3D 0; i < max_ring_len; i++) {
> > +		u32 td_cmd;
> > +
> > +		td_cmd =3D ICE_TXD_LAST_DESC_CMD |
> ICE_TX_DESC_CMD_DUMMY;
> > +		tx_desc_dummy[i].cmd_type_offset_bsz =3D
> > +					ice_build_ctob(td_cmd, 0, SZ_256, 0);
> > +	}
> > +
> > +	/* For each tx queue, we restore the tx head following below steps:
> > +	 * 1. backup original tx ring descriptor memory
> > +	 * 2. overwrite the tx ring descriptor with dummy packets
> > +	 * 3. kick doorbell register to trigger descriptor writeback,
> > +	 *    then tx head will move from 0 to tail - 1 and tx head is restor=
ed
> > +	 *    to the place we expect.
> > +	 * 4. restore the tx ring with original tx ring descriptor memory in
> > +	 *    order not to corrupt the ring context.
> > +	 */
> > +	ice_for_each_txq(vsi, i) {
> > +		struct ice_tx_ring *tx_ring =3D vsi->tx_rings[i];
> > +		u16 *tx_heads =3D devstate->tx_head;
> > +		u32 tx_head;
> > +		int j;
> > +
> > +		if (!test_bit(i, vf->txq_ena) || tx_heads[i] =3D=3D 0)
> > +			continue;
> > +
> > +		if (tx_heads[i] >=3D tx_ring->count) {
> > +			dev_err(dev, "saved tx ring head exceeds tx ring
> count\n");
> > +			ret =3D -EINVAL;
> > +			goto err;
> > +		}
> > +		ret =3D vfio_dma_rw(vdev, tx_ring->dma, (void *)tx_desc,
> > +				  tx_ring->count * sizeof(tx_desc[0]), false);
> > +		if (ret) {
> > +			dev_err(dev, "kvm read guest tx ring error: %d\n",
> > +				ret);
> > +			goto err;
>=20
> You can't call VFIO functions from a netdev driver. All this code
> needs to be moved into the varient driver.
>=20
> This design seems pretty wild to me, it doesn't seem too robust
> against a hostile VM - eg these DMAs can all fail under guest control,
> and then what?

Yeah that sounds fragile.

at least the range which will be overwritten in the resuming path should
be verified in the src side. If inaccessible then the driver should fail th=
e
state transition immediately instead of letting it identified in the resumi=
ng
path which is unrecoverable.

btw I don't know how its spec describes the hw behavior in such situation.
If the behavior is undefined when a hostile software deliberately causes
DMA failures to TX queue then not restoring the queue head could also be
an option to continue the migration in such scenario.

>=20
> We also don't have any guarentees defined for the VFIO protocol about
> what state the vIOMMU will be in prior to reaching RUNNING.

This is a good point. Actually it's not just a gap on vIOMMU. it's kind
of a dependency on IOMMUFD no matter the IOAS which the migrated
device is currently attached to is GPA or GIOVA. The device state can
be restored only after IOMMUFD is fully recovered and the device is
re-attached to the IOAS.

Need a way for migration driver to advocate such dependency to the user.

>=20
> IDK, all of this looks like it is trying really hard to hackily force
> HW that was never ment to support live migration to somehow do
> something that looks like it.
>=20
> You really need to present an explanation in the VFIO driver comments
> about how this whole scheme actually works and is secure and
> functional against a hostile guest.
>=20

Agree. And please post the next version to the VFIO community to gain
more attention.
