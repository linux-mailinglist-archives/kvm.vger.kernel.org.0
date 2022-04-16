Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E16395033CD
	for <lists+kvm@lfdr.de>; Sat, 16 Apr 2022 07:48:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356683AbiDPACw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Apr 2022 20:02:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230458AbiDPACv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Apr 2022 20:02:51 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DCB141332
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 17:00:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650067221; x=1681603221;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=pXUTsWol29t3/xaIxMSwkgECzzUCQwjH1r98GX2AdMM=;
  b=cvt/diTpGm+7tvydwM5/WRN29DD3EXWE8HB2TDxJvK4cS2n/Urx7+6rO
   y+W/V+G7ydX/wrUSQJNgyZp1wzG7UOieIByO2zId72FO1oskSDxLps7z9
   ii+DaicRnY0yvHLRjvelDAve3s0dqSfK11fIPp4eUezKy7p0dc4MT5ySi
   W99gnsE19hNORZXWYF6cixoCAlMTKCXkd8fYcdZye0BSthRHV2vptzGET
   cuRolVd1ph3vIp1nhxH0qqrST7D1MmyFeRRoiq7ltejyuJmTFYSLpxOMR
   8MfQnH+mvcsocdIygruiNsJXOPfTFICNmuhIbHuiXQgtb5Vk5dYMVK08q
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10318"; a="263425580"
X-IronPort-AV: E=Sophos;i="5.90,264,1643702400"; 
   d="scan'208";a="263425580"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2022 17:00:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,264,1643702400"; 
   d="scan'208";a="527674519"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by orsmga002.jf.intel.com with ESMTP; 15 Apr 2022 17:00:20 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 15 Apr 2022 17:00:19 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Fri, 15 Apr 2022 17:00:19 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.102)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Fri, 15 Apr 2022 17:00:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QqDFQttTYfnjaemawR2ZvD0coQAOsUg08Uwl+HpAIV6UMNiLc4BcSJhgA9d25UgPmbnD7b5C3dicMpmVlk88on8LZZg6dfqvHXolADZrmKcTRobok8qOMXMOT6NojwtXK676FJpSZApDpSXrsUEYmXYIW8MvXDBkJx/raC2qtXzQD2+BILu4cXem/QYvOKWguY5x+/vwj52CPzb7RjRqOX7Azb2Ma8fJP2m8ZPQeaFq8tV0AzkkkP4Ir52kS3Oraqwkr5iIa17vctqsgaon9fkiwKNorUsL1zji64MzTkWlA+U9xxP31JhOs+ouxvXPIwNs9UEXD4fL4kb3bZw311w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pXUTsWol29t3/xaIxMSwkgECzzUCQwjH1r98GX2AdMM=;
 b=OifZiYptosgLZYmYBHxcXfQcfEhau7G+hz7Kp9/PsyEVIyVeLHXegyn7OFdtceSvKPTz5bVoVnXv7l3y7F8Dx9qykLWgg7NrNdCmuSQi2+72NDC2hpkVyAzXWI2i54N0WwtdFNnv1Z9ge9P/FPFGu+ILAC7qqeGG/iGi/byJSX+JE9IukhH4R1nPLByZ9epXf3NObeaTaHEQpZLxnWmemBivT/FvznP2RziA+F4op8pmIY9lblEDmuo7I3l2XidjjgqdI68ckHMCjrRhN6jVSEpozkD3rZYbrXxmXtqFENSd/wLd/m3g2fGk+hNb+p4T2rYizKQfXRNhcGX+ikL0UQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CO1PR11MB4836.namprd11.prod.outlook.com (2603:10b6:303:9d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Sat, 16 Apr
 2022 00:00:12 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c4ea:a404:b70b:e54e]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c4ea:a404:b70b:e54e%8]) with mapi id 15.20.5164.020; Sat, 16 Apr 2022
 00:00:12 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        "Liu, Yi L" <yi.l.liu@intel.com>
Subject: RE: [PATCH 04/10] vfio: Use a struct of function pointers instead of
 a many symbol_get()'s
Thread-Topic: [PATCH 04/10] vfio: Use a struct of function pointers instead of
 a many symbol_get()'s
Thread-Index: AQHYUDAMID4ey+ocu0eeixgszfXfG6zwV6bggAEuooCAAB86sA==
Date:   Sat, 16 Apr 2022 00:00:12 +0000
Message-ID: <BN9PR11MB5276D64258C6C41C252C5C4F8CF19@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v1-33906a626da1+16b0-vfio_kvm_no_group_jgg@nvidia.com>
 <4-v1-33906a626da1+16b0-vfio_kvm_no_group_jgg@nvidia.com>
 <BN9PR11MB52764D80F73203162C8E82268CEE9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220415215407.GM2120790@nvidia.com>
In-Reply-To: <20220415215407.GM2120790@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.401.20
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 64f391fd-bca5-4f65-963f-08da1f3c1468
x-ms-traffictypediagnostic: CO1PR11MB4836:EE_
x-microsoft-antispam-prvs: <CO1PR11MB48366A812B89F6D76E6DC2BB8CF19@CO1PR11MB4836.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: W1q3qfPrEAWYT1Tjr3hQJLgMc2LJuqHmEaX8IbTmU0hoJqHkF+H45ubUDQVHF1IhfWbnHtQfbmVndU8wTq1gUzfq6Y7KQyPR4iaVC3f7F2bLHWTIkBGw9AXkjiTB9z/u8VrgPHoHt1OL55FRNLJ6ErblO2HXEAZH2Ywun2SunbH90Nvs/NQUlPYDeZJx17bSx15tbrZf9rKGY0UAyUPOIw8B2FLNyL0+FXP/DmTivh7YWPkapDNtVr3SVK6YTSiyMk/WyodihUJHr5xtHBC/vJge2f9xELuwbpWQun0J5KgXoJOl+sCu6N8v1y9PNOfgTA+hWb46xxmUkaMGjMSy1/Yq5LCVgKAZzsEmHUn8CXVDMlmd6xR/OVprHbt6Ory09R3HhtE/mIxEAOD7amjIkvOdce0FLS8BidN5tLkGmwuCv52HYMDGV8JDtYznsjD0ahwus3YrC/ga+Sms5xCtujuQwLLXo6fGeXQDlxrdmsQGiIyVwrploudPtPYJoOsMp1dgYEkx100ncm2l1SQAtk1hjYvxCkzeDe08h3gD8BAEHklyXVB3bdtMLb75ptJalReobvHu8cPwQ0Ud8ttGNSJ4sCW+4mtqp9IfC4DljuoxnXGA+hxS+68Ff8NHG+hFkfaFFzv9wnXXK6N7u08C5MpCANzcmRPodZ9DsnDi9xwKpIwJd1bvvf3IUdKkGMUvueoL8yEo2HTqTC/i/KRd5w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8936002)(82960400001)(83380400001)(7696005)(6916009)(52536014)(38070700005)(107886003)(71200400001)(86362001)(64756008)(4326008)(66476007)(66556008)(8676002)(66446008)(66946007)(76116006)(5660300002)(6506007)(54906003)(2906002)(316002)(33656002)(508600001)(38100700002)(122000001)(26005)(186003)(55016003)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?5ax0eC76xis9d1qNsztSUxLMGSwHGPB3nG0FXEq+Ylk/gJTCrEKGRcwU6T+1?=
 =?us-ascii?Q?lw41D/2pbY7Zslf3LX6qg7fQryVUHkcjJza00oslT/rOPo5HumoA+jU5n/3D?=
 =?us-ascii?Q?hq3YkRduldpeyuxjCbaUVN3fLGHCSeDQLaz6JTK3yolXLM5v9b8aT0YzpCdv?=
 =?us-ascii?Q?6vO8r+cb1MTeRng6HSP2xaT5fFrDTqjrtNe87xsGp2Fvm18T7bgKn9wkLV3O?=
 =?us-ascii?Q?gLKlB3enY2yku77ICa5Rk4W9nMmq4z9a3w6HNx34w9n4eEf6wmrtCeH85wIO?=
 =?us-ascii?Q?1Py48MqRJK4AbYH/uL9uTPVt68g3CUrkKO645H/HLn92kY5iwpVsbNBoEXq9?=
 =?us-ascii?Q?RoMyasB9vsmaV9mM/gK0xW8IdoSKp98RtrJetYe/YzVX0KtORLmW/JG01lcK?=
 =?us-ascii?Q?Lz7pI7nefEJY8HZf4J1Wj9NWXhSlDUk4WsZTrNbBlv8k5Cye1lz8z8CHzaYo?=
 =?us-ascii?Q?tcHm1vTnKMQzw9zqtY/dYuyuco6176ZR2hZe5HrCptyo/U59rJdaHaVRpb1Y?=
 =?us-ascii?Q?Ui/SyifvuWRyxWSIfDwYmFs/PliGQmKIErnrEAJmF6h8OjlZEVXzpZhdY8Cb?=
 =?us-ascii?Q?BF8cS4Mjs0kUupOMIZIGUc++M5V3gkZPhusWoG95SY2eKT7mN4zP/TZkvWJj?=
 =?us-ascii?Q?NjG64tKW6EoFlZHYlg2d9F5UquSuZMg8hv8XWfOJVcyU5QnMCDzU/+UAk6yH?=
 =?us-ascii?Q?pUMOdPCZBXtNHZ+GajfENtTh2JFnYFETseTe+O26vRvljdIygUiTsTVmhjr1?=
 =?us-ascii?Q?pa/a2Yxs1zRZRiz/OJCZPptge6VHyUm0SC8h1brAEA9TAAolrGYVvIyIUk3a?=
 =?us-ascii?Q?dixxq1CCfxVdqAsDOQbp7vtkKyULg7II1+F3lBUCJumoNnndpEmfTxktVhHB?=
 =?us-ascii?Q?nrzhfUxU/69+4bDCyDozrpLwPzIoTcRWfaoFW/nf+tB2+ecAP54gFllde4K8?=
 =?us-ascii?Q?+cH1l+DUgt7G2BsGrtKIcW+9k0gBK6nSjXOn49movMRMnxO3X6ZN43OSWsvF?=
 =?us-ascii?Q?L6HajWg6Fd0ExQH9Mj3+idWYjfij+c1WBhQs+HY3190CoXsLdqVP2AH7vpKV?=
 =?us-ascii?Q?ppecgngZnC6Sop1k0EjJ8m99zg+nQVIWyzKK/NyP13vJId6cZuvFR7+er6UP?=
 =?us-ascii?Q?lqPBJcq6AVAgakEQKZx6hkoT2Usl2CUXgoic/N3101LmN1//1qeX/ObwhYDK?=
 =?us-ascii?Q?O3y3NUQFGhDS+tGmoPHp9LUqRt69Yt2fmpjfO8zM+RZf0YXlulWAf/qqC/Gb?=
 =?us-ascii?Q?eG8JlkGw4qUDxcqmbm5BJkIVI+8HJHeabdAECarwhOc18+Du9QFFGZCocyqi?=
 =?us-ascii?Q?UMcytDZUvYGzDRQHIXIPkJDUERqE5xKjWueNJX91Y4p8nVFP2lxJw7taPx5E?=
 =?us-ascii?Q?b7MhzU3sXqAQ0hiz3rfDOFPy/4BxnW2gjR6gaN55dMnrH94EPRs/5wLei6+Y?=
 =?us-ascii?Q?hvIqA66KmTcF30mpo79KPJCv4omY1Or0iF4l0aT4wKi1jB0zMZHa6B2W2ZTl?=
 =?us-ascii?Q?pBR83C9U1gu5IzhmY8Viokc1mQ7QsFHUCLyJyAEXeZuO9S9Ib55OR4FlfHVC?=
 =?us-ascii?Q?C6tOh9wyt+pc9TtWUCRPXVEsxgMzr6Dye/EmEZ++cGI601HSkYS1MNW94d8b?=
 =?us-ascii?Q?fBkNBKOldwK5e+STQ2Z2bQ/jBsC9h0Xi7lDEwSAoEhs7EcW8LUTJKg/qc/qd?=
 =?us-ascii?Q?7FGVq+sTw8IIwkWIrOdKndvp29aJeR1diNnxpUGmEtePUgg9gLCAHdWZKUm/?=
 =?us-ascii?Q?zRehY0hCDg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64f391fd-bca5-4f65-963f-08da1f3c1468
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Apr 2022 00:00:12.6150
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TrZ3+waX0fRH8rwSbw4Hi5not6iIFLyvlXEsN7OrdriC8QUGbxpxBPiIcZW4qeyrfAnFkEbyF+z96TYJ6cLAfw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4836
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Saturday, April 16, 2022 5:54 AM
>=20
> On Fri, Apr 15, 2022 at 03:57:14AM +0000, Tian, Kevin wrote:
> > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > Sent: Friday, April 15, 2022 2:46 AM
> > >
> > > kvm and VFIO need to be coupled together however neither is willing t=
o
> > > tolerate a direct module dependency. Instead when kvm is given a VFIO
> FD
> > > it uses many symbol_get()'s to access VFIO.
> > >
> > > Provide a single VFIO function vfio_file_get_ops() which validates th=
e
> > > given struct file * is a VFIO file and then returns a struct of ops.
> >
> > VFIO has multiple files (container, group, and device). Here and other
> > places seems to assume a VFIO file is just a group file. While it is co=
rrect
> > in this external facing context, probably calling it 'VFIO group file' =
is
> > clearer in various code comments and patch descriptions.
> >
> > >
> > > Following patches will redo each of the symbol_get() calls into an
> > > indirection through this ops struct.
> > >
> > > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> >
> >
> > Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> >
> > Out of curiosity, how do you envision when iommufd is introduced?
> > Will we need a generic ops abstraction so both vfio and iommufd
> > register their own ops to keep kvm side generic or a new protocol
> > will be introduced between iommufd and kvm?
>=20
> I imagine using the vfio_device in all these context where the vfio
> group is used, not iommufd. This keeps everything internal to vfio.
>=20

In this case although the uAPI is called KVM_DEV_VFIO_GROUP_ADD
Qemu will pass in a device fd and with this series KVM doesn't care
whether it's actually a device or group and just use struct file to call
vfio_file_ops. correct?

You probably remember there is one additional requirement when
adding ENQCMD virtualization on Intel platform. KVM is required to
setup a guest PASID to host PASID translation table in CPU vmcs
structure to support ENQCMD in the guest. Following above direction
I suppose KVM will provide a new interface to allow user pass in
 [devfd, iommufd, guest_pasid] and then call a new vfio ops e.g.
vfio_file_translate_guest_pasid(dev_file, iommufd, gpasid) to
retrieve the host pasid. This sounds correct in concept as iommufd
only knows host pasid and any g->h information is managed by
vfio device driver.

Does it also make sense to you? Just want to think forward a bit
to make the whole picture clearer.

Thanks
Kevin
