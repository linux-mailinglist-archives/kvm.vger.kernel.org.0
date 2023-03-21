Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADFE16C2B9D
	for <lists+kvm@lfdr.de>; Tue, 21 Mar 2023 08:45:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229677AbjCUHp4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Mar 2023 03:45:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230171AbjCUHpy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Mar 2023 03:45:54 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E1DC38465;
        Tue, 21 Mar 2023 00:45:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679384720; x=1710920720;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=HL+im2NXgeurU9kAUu5Wy9d5mrjpMFGvo8ppuf70QuM=;
  b=eznc7yon2KtXORvKXYxioJob0nhZlgW/IerVKJO/8z3K0Spqq4IE+Hea
   oPxnv+rC7VidYuFZlglEvWgwn9erN2tw3c8IhpDYJ9Gq31yRaMCuJI8Qp
   fnjRHZqLki1egTogs2s/3Ei4/GyLNS1rFBkkPZTT2fD+1CtVS8TcCC/ni
   v+3QWff/iw6iCp22r6HHHykvyPx5YVbgzwvUhhF6ReoCc7Ayl3iMNvggi
   DpyznXCCVklLZxra+mnSNVPKsczvVd6VAs1jqdnrT9MxajMqxh5r5uFX9
   5nb1m53EQnQCt+xxNEqKT7zUMlVRUyZ4x47sqKF8fXOq9+up3xBepkEWS
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10655"; a="401444571"
X-IronPort-AV: E=Sophos;i="5.98,278,1673942400"; 
   d="scan'208";a="401444571"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2023 00:44:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10655"; a="631465869"
X-IronPort-AV: E=Sophos;i="5.98,278,1673942400"; 
   d="scan'208";a="631465869"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga003.jf.intel.com with ESMTP; 21 Mar 2023 00:44:50 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 21 Mar 2023 00:44:50 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 21 Mar 2023 00:44:50 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.44) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 21 Mar 2023 00:44:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=irLRGELx0hKN3rp8CgujW43MOLfFlaNa7Sv44JyKce1tlstqqvPSxtQYqJe2zt+R/eX2TC6r3Ova0CRs5y1WehupJNPdgdpkkPtpq1T9L20sQ/fAx5k9CQqxAhuQR13jQIHTzXCgaGSzFZo4Z10tQCPpHESXbm2e0u2Th/VggDyV5McEjdMgPp7W5rpd4TvIk0+b/6fO2+QrY0iK+1rOpsb760THvsEPoe1gNfOPQMpuRGEIKH3T4yyNgeJDMGIg6jY07cIGWp6YpFQf1GXPDf2tWwXV7BgtW04WTTtBshnCVxz6xmT2KLQ6aTrFRxJjjWoPkLekznbhJxTG1JsI+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nZTx1inCowPpeQr0ph4gsna0OUnCuqWrUQ3Rxq9FttM=;
 b=nnUiHr5fbq0lTgQSn+nceLzvle6wMs7iyhdaTgEBOOx5Pkc/e0SliBTSM6VpCKr1WPzfQSXaIDvi7b1EPu5np5lJ5lWyPFv9flin011JPFGtioNDhUmnQo+nDTnjI1HtbPzFCBUCimpTXvwV+2KMKAvV1CLMNws+FjieZao9CXlDK3zpyeUgYHia9jpuoRf/p861QWSPiZuEox6j3MQkTHd2euRfrAw84exFlBXE5pYhasDHcFVHQWTs8jbOCO29nzquITXZFd+TRozWu1rhy4tSoLIqEYife1nHBkYpSEdcqdCiSZ8xYDbbgdZ9VM/8ktyantomj5uXCXFrueLIWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL0PR11MB3042.namprd11.prod.outlook.com (2603:10b6:208:78::17)
 by SJ0PR11MB5631.namprd11.prod.outlook.com (2603:10b6:a03:3ae::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Tue, 21 Mar
 2023 07:44:45 +0000
Received: from BL0PR11MB3042.namprd11.prod.outlook.com
 ([fe80::9686:ebdb:db09:6e1e]) by BL0PR11MB3042.namprd11.prod.outlook.com
 ([fe80::9686:ebdb:db09:6e1e%3]) with mapi id 15.20.6178.037; Tue, 21 Mar 2023
 07:44:44 +0000
From:   "Dong, Eddie" <eddie.dong@intel.com>
To:     "Huang, Kai" <kai.huang@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Huang, Kai" <kai.huang@intel.com>
Subject: RE: [PATCH v10 10/16] x86/virt/tdx: Allocate and set up PAMTs for
 TDMRs
Thread-Topic: [PATCH v10 10/16] x86/virt/tdx: Allocate and set up PAMTs for
 TDMRs
Thread-Index: AQHZUDbeJDtbeMbY0Eq6QEyUmBYQe68E8Txw
Date:   Tue, 21 Mar 2023 07:44:43 +0000
Message-ID: <BL0PR11MB30427B24E47E9612FD2DD27A8A819@BL0PR11MB3042.namprd11.prod.outlook.com>
References: <cover.1678111292.git.kai.huang@intel.com>
 <5192c24339960c11dcedd42fecb5d49128bbe072.1678111292.git.kai.huang@intel.com>
In-Reply-To: <5192c24339960c11dcedd42fecb5d49128bbe072.1678111292.git.kai.huang@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL0PR11MB3042:EE_|SJ0PR11MB5631:EE_
x-ms-office365-filtering-correlation-id: d89eb4f5-e925-4770-b9ac-08db29e02303
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9VFOhAATNQkmTJJ5uffCWg/h+Gy721qWqX2+tPag8qk5QE0f/UoIRsZmA8AB/VVsNNuv5eD1d0yY+FmsZPeW6wNrM84iiOZIFYD2dZ+5S9Pop5sQnC0po5cf5PJ4++qpeln/3RU5KWA23f7MRGQ6F8dNm4N1TC7qkHh0I19IWodxgZPRNfOOX5wrsW799xejt9eGgcHvQYdQcYLBAyM391IaRZ4gDdA8ofy5IdixvEWOeDUsOq3qDD+CBTzrBCt1+ZNW0f4Efk+Mdm1JpIKIexYgqOmj0dqySfmbMSR7j6uOyOTjcd5Wya7HLl+OAneEy7m41wVVwXhtIWpxTBPChVD5waR2b/PnUVlERV9fqjya1pUu+eBYARv8l29XgfJeaxSFCe+dt66AtD1TtJRihAgyNkxKCKV+d6FMSV0NW6rQM8LT7nrzizQ6JfwXCQIiYDapa91RU2RlQC9Xk70T6fvNKFOso/MYW0qHvsJsMynJJkbUQXRw2ecrqhmCD9c1WHLBKtxU+N36lSkO7qdGQG+UKhc56FoLUVoLu/0TWqqzyNcU+3zRgOSXpKCK1A5RBJSXh7dlt18i2HLucpMaauvJuModi/74Ubv5FyHZKMIrov8gqVXuELkHFmXssU74oIk3X20i43+/O69Bw+amdajMlXLFXIS1/PBhMnJXGQs46oTmMKRBzfq7O+TleRaG0ih9ogTz6qtTv3k8kmE5/5izKtQJKxtu1AG1HIVPBvA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR11MB3042.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(396003)(376002)(346002)(136003)(39860400002)(451199018)(8936002)(7416002)(5660300002)(4744005)(52536014)(41300700001)(55016003)(33656002)(86362001)(122000001)(38100700002)(38070700005)(2906002)(82960400001)(4326008)(186003)(478600001)(7696005)(71200400001)(6506007)(26005)(54906003)(110136005)(316002)(66946007)(8676002)(66476007)(66556008)(66446008)(76116006)(9686003)(64756008)(17423001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?LTcNKivqvPp4q1hQBjy21NFTVTkjZLQm/Q+sQkHtFsf9VSxcduiuNz/7+Ifv?=
 =?us-ascii?Q?P4oRgNrvIdVzdPoIdCdfA2GBwtCPTHw2HwCEbOnKJYIn3ABjzkCuQQR8vigj?=
 =?us-ascii?Q?sUPw+4goGN2c6dLIpvKDjuoh/VXcjHMJBRyHeyXyE5iv8OP0iv9II/GSZ8FF?=
 =?us-ascii?Q?/s1TJIomo4I7wkmXABYRxDaxl8nreTM8f43frisDJYw6qowsw1IdIDJ3Nw9e?=
 =?us-ascii?Q?H6e2/rDnytoAqFEKmDeefm3pgFaVNcYxCByugQfEF8xrADHkB2PFG1oIB0RF?=
 =?us-ascii?Q?LGJ7wdHb0jFjsjOaNsg62m8FSByTyAcGmWBF8GRc/lXGUhDKfijCj2bn3z6J?=
 =?us-ascii?Q?PBFqtYU/3DAWielQgtOUvocAqdsll2MMZWzUyRBYr1IqgXKd32FW7JHuJI3f?=
 =?us-ascii?Q?C4WHjA+YY3CHGQIM/TqaeQgXUavgwBkOJoVo0e8Hwb737vvlvnWaX5WLuAJC?=
 =?us-ascii?Q?jf0hNnRYAf5S1bIT+1vb3PTNKTQ5kFfZ1LdFSDyQUoNOkKuZ9ku/1AHlVUfT?=
 =?us-ascii?Q?AHjigYGQkuIXh3KKbm6ho3HRhk4AX+1AYfJAwvf3sxxY77lCFEPGzFkdwLu3?=
 =?us-ascii?Q?q8c69agjECANMZmjmVJqVGmqE0eJZlEKnPppOFJaZo6NkxSwecB1Spb8lMt0?=
 =?us-ascii?Q?7tQuCvnJZQipT6PQybn5V2y/fxm11R/g9o3+YpGNZuFGScPChcl5ub/KksZf?=
 =?us-ascii?Q?W68zEB7GNHqVYO/PXUlWP1aSX4+8RFmDCIJIzQyzGGeOaDtXRdpyUNd6/Drw?=
 =?us-ascii?Q?REABa7XSiuSNPF0/jP0Y9VD3N6EqPI5fv5L6ubVZjUdShP17rNtB6gNYSOZW?=
 =?us-ascii?Q?5Exa5qQ460smSGCnH0+RW58dejJaA9V6d0YCYVT0vPHqF9wiupAePYZ4TXl9?=
 =?us-ascii?Q?0IBygzIc/me86yf5hqeI59TlQPw0+HxBi4R+KgHDwkh8+X7K5GCcXwSgSpAl?=
 =?us-ascii?Q?d5QfzrA9DsbhyKKUCEYZxxKjyL0BY1CZ6pnaUuEi38LeR9iSt3NJpyys/6x4?=
 =?us-ascii?Q?p2c6HbGoaRmpHua/pwjhXMqK/D35aDfzbQtKxtGhHhLeX+P3h1TqAJOyrTmw?=
 =?us-ascii?Q?noqyob+Gx4AkNmPePM84PT7u4jHTSB1Fs7T5ZOrsQaYnQa8WO/HNlbwcJpkS?=
 =?us-ascii?Q?JttgysoFCdFY5Xp4rCARk+E2NaYoqnZMfWOC8npZLGlDlyITDx/WiATUJPOT?=
 =?us-ascii?Q?mmCraN9PEWKzGaoz9OF9VOhgj9PeMPTnePmR1yDHw82qOJOMwECyZDFo9UAR?=
 =?us-ascii?Q?75KcO4Ks/gArLEv71+hbjIHyio1FKhCvnL4nCKcU/pEkNKBw0EBW4sg7QIyE?=
 =?us-ascii?Q?u/u0FAEOWXYTcGqSHvf7WfIz4eUrhfG3HAeokgGXX+n3jKNaBE+7BiTb9Zlm?=
 =?us-ascii?Q?p6/IKwOIf6dO3Ved7WWnOzlH5kiDEp/glE++sqBd7POJ6CS/hlsRogtqQOzV?=
 =?us-ascii?Q?N12hyjdkWqToHcFyVxYxLl61NxmP0zlJzq7oD93O1d6X0xlMQff7wdgs6CRU?=
 =?us-ascii?Q?vxp6PKSbd66/C5ay6D8xU13Z/UXhDNTuTc+k7FZRhsZ3swwU1Sby7+FwzFpg?=
 =?us-ascii?Q?/PvFJqDzkLgJywuqKu5Cy81ETgRU0Dotol47axHA?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR11MB3042.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d89eb4f5-e925-4770-b9ac-08db29e02303
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Mar 2023 07:44:43.9292
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: q58aWuCL+CrABabSokPkJ8jRP0vpfUYi5H/YjOQe4IecKnrk7n62xX2lfERVCVwCKSMxhgCYL5IwmJmgrXqSPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5631
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

>=20
> +/*
> + * Calculate PAMT size given a TDMR and a page size.  The returned
> + * PAMT size is always aligned up to 4K page boundary.
> + */
> +static unsigned long tdmr_get_pamt_sz(struct tdmr_info *tdmr, int pgsz,
> +				      u16 pamt_entry_size)
> +{
> +	unsigned long pamt_sz, nr_pamt_entries;
> +
> +	switch (pgsz) {
> +	case TDX_PS_4K:
> +		nr_pamt_entries =3D tdmr->size >> PAGE_SHIFT;
> +		break;
> +	case TDX_PS_2M:
> +		nr_pamt_entries =3D tdmr->size >> PMD_SHIFT;
> +		break;
> +	case TDX_PS_1G:
> +		nr_pamt_entries =3D tdmr->size >> PUD_SHIFT;
> +		break;
> +	default:
> +		WARN_ON_ONCE(1);
> +		return 0;
> +	}
> +
> +	pamt_sz =3D nr_pamt_entries * pamt_entry_size;
> +	/* TDX requires PAMT size must be 4K aligned */
> +	pamt_sz =3D ALIGN(pamt_sz, PAGE_SIZE);

Should we ALIGN_UP for safe ?

> +
> +	return pamt_sz;
> +}
> +
