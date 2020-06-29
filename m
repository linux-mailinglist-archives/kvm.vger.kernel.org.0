Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08A8420D37F
	for <lists+kvm@lfdr.de>; Mon, 29 Jun 2020 21:12:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726900AbgF2S73 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Jun 2020 14:59:29 -0400
Received: from mga09.intel.com ([134.134.136.24]:65096 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729580AbgF2S6x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Jun 2020 14:58:53 -0400
IronPort-SDR: XY9UMfX/hneGulcR8bC1PWmfEBgLLgbZ9iiaXxXXkwuyx9IhOXxMiLYWrczpHSD8MoLh1QN6Ip
 8POW4h6I9lHQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9666"; a="147481331"
X-IronPort-AV: E=Sophos;i="5.75,294,1589266800"; 
   d="scan'208";a="147481331"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2020 02:24:54 -0700
IronPort-SDR: tI5Ohju9i3K+OadxL2HBTr9fOzcCn+beT76uV7xRaQYyW9I/YuorN5TKT8sBqVJzVUD+8/TSqU
 KHRjoSN9A8Jw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,294,1589266800"; 
   d="scan'208";a="266156684"
Received: from orsmsx110.amr.corp.intel.com ([10.22.240.8])
  by fmsmga008.fm.intel.com with ESMTP; 29 Jun 2020 02:24:53 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX110.amr.corp.intel.com (10.22.240.8) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 29 Jun 2020 02:24:53 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 29 Jun 2020 02:24:52 -0700
Received: from ORSEDG002.ED.cps.intel.com (10.7.248.5) by
 orsmsx609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 29 Jun 2020 02:24:52 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (134.134.137.101) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 29 Jun 2020 02:24:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CzOkKJDar7ZVVw4EZ4o11kfys8JauxTJrk1vHIfASW0gAzrxmbl6khyzhdin+iqw509eK3ZeP9twrmfn1KdRMMUi82EpdscYFd2iNUu85ePzmHTypUt/mM+wA8wbUoOr2Fm7LmmTmZW52QDsBKk2lTRGFJoSqLBnpj2/1b6rIdjXLC6dfywV8qgw1KLrrB+gPtlf3FG0O6Jo+TKaIN+2WvPBGI794f0oinQiQca/ZkVYDR4MQ+eKijnyJXtwtOJGecCili0hnQvdLCqkyqJ5do9/X1FWO0MgvlGeoABQG9+An0zH04PooH/baG6bXXvSgsWQ9pGzkUaFpga4LVEaHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jRk8u28uye2ch7b4Wxc0y7sbq3f/DByKJkO9iEZUIDk=;
 b=A5B+LeROEw4ByHjoNPKS7TKtA63cJruW5DokNIc/PyxK3cCuFpYIJIeG8SrUyu/RA57YJXhVRaWzH6FLPYJxJyQZsHjBB8BOWlhR6HFBwwtsNASvV2nxZmQyQfIGmF+Ngi4MhRtLdOP9qIAFKVDLNpc/GrYqo7wAEOrXahN3YR8YMc58R77knZWrVjZGG3bxbMKkkP1sSRqOkaMJeYQsgk28ODH0E9sMBc+pZs7SD7x7fwXyaIl16ySMzP95LqVUcZMNdolBLzvvagNmdpLVQgA4MjoHwEANXSsGsboASVryuYo6mkfM0s6yXPDuHQy8owyGrrwJPR5c2tSjVuXErA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jRk8u28uye2ch7b4Wxc0y7sbq3f/DByKJkO9iEZUIDk=;
 b=rESw7DDbmfDGzqHa0JuKbp8EcJD4Tb0WkR7NmDJRzoVSQRfY0ZRxGKF75mHJHVDr8G6tQY+6Z5ESelx46EI7z2dtnrCg6unp0X8iLpVFSQ0BPiIYDFHCt1AAk/zf+Lc/CaJZqX+2VAIsSSWphlngsURB4VZ76oF6en/O+R7LUoM=
Received: from CY4PR11MB1432.namprd11.prod.outlook.com (2603:10b6:910:5::22)
 by CY4PR11MB1574.namprd11.prod.outlook.com (2603:10b6:910:f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.25; Mon, 29 Jun
 2020 09:24:51 +0000
Received: from CY4PR11MB1432.namprd11.prod.outlook.com
 ([fe80::b46e:9dcb:b46b:884a]) by CY4PR11MB1432.namprd11.prod.outlook.com
 ([fe80::b46e:9dcb:b46b:884a%4]) with mapi id 15.20.3131.026; Mon, 29 Jun 2020
 09:24:51 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Stefan Hajnoczi <stefanha@gmail.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Wu, Hao" <hao.wu@intel.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v3 13/14] vfio: Document dual stage control
Thread-Topic: [PATCH v3 13/14] vfio: Document dual stage control
Thread-Index: AQHWSgRSM+uqgdGjpEOT7nvP3+zeDKjvWVIAgAAAwoA=
Date:   Mon, 29 Jun 2020 09:24:50 +0000
Message-ID: <CY4PR11MB14322E99A64BC0B2E06CD33CC36E0@CY4PR11MB1432.namprd11.prod.outlook.com>
References: <1592988927-48009-1-git-send-email-yi.l.liu@intel.com>
 <1592988927-48009-14-git-send-email-yi.l.liu@intel.com>
 <20200629092132.GA31392@stefanha-x1.localdomain>
In-Reply-To: <20200629092132.GA31392@stefanha-x1.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.2.0.6
dlp-product: dlpe-windows
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.147.219]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cea3d932-ea3b-480e-c016-08d81c0e4677
x-ms-traffictypediagnostic: CY4PR11MB1574:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR11MB157442D535B74B1AAC0C281FC36E0@CY4PR11MB1574.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 044968D9E1
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AmcsE1Cv0tmD0bWGatIpr6AXEY+73/1COSqlXY8LFVZdV9vioG4VjIzR+GZWMZQN9dp7Xavf2jqzB3uzH3l4CrdNMSFUi9G4bU9gw7P76S3751vX5+OlVh6FrKHCenfGUbT7U/SWd4MOciFIeRVTjz1J99P3981RW5tkb+cc9Btm5YWsMiHXL4cTxs/8QLDcvgJjsi50nc2ynCM4kU6/2LXcgrxVJkESAtjJw9kpH6uy3YQ7Xy5RQMmDtmy7ZjWnItIT83ZTnABbVDFAcPm5P43ZHkBlXED4rwuKbZtw36VXfCPSugVhcUweYfUAEAwl
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR11MB1432.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(346002)(376002)(136003)(366004)(396003)(6506007)(9686003)(7416002)(33656002)(55016002)(2906002)(6916009)(66446008)(64756008)(66476007)(66946007)(66556008)(76116006)(4326008)(54906003)(8936002)(26005)(71200400001)(8676002)(86362001)(5660300002)(52536014)(186003)(478600001)(7696005)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: ot80ypviLdqi2cWASLCsQLRJOskY5BSGNYBIRehnxaz+VA90nybLJQMHEDTlbmVH622PIJ6mnO7byc0+AkhZzShX6q60jyb8beZjuOvYxSKtzl974TPblF8yi/OY6XF3hhQeLWr+oECK6yY4luNVwApm7LMh3IXr5GUXIcl7K94ZsTg4xhvFimehTvMVKwz69dwE38E7XpaY5dc6UbWUBdG6rifhu2PKxIqDd0XtliJ3HNetY+//kuxAmcoBVUehZgDNkhh/IsspT9PloJUxIJw9Lr3OZc19InhlzrYCkQViKOzhE38CId4xDGy+C8dp5LzdzbWOKnxAux4VrJJ7yscLey0a1byYSHpI3R4Ln3P5t575VGWosSdYwzckjod0lLWkWE40QkXO9ul5opPHbu2+hcPQL+9MnuG9aKq0z3+3OL7GBM9/SnQqkRr0/MpktvggWPZ0js7g0Pmg4lqi8CQloN7xTH92OwHajKyYWpbXm2nD/XpsfvfDJ7gldLlA
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR11MB1432.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cea3d932-ea3b-480e-c016-08d81c0e4677
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jun 2020 09:24:50.8738
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kaMH13DW3Uvu2QUbZdgwyXwcjj5R7CJMtVaDu10oI76uIjyyWqK5YOfhR10xp9HjjZNjFKjfFfiTdiVCYjSANw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR11MB1574
X-OriginatorOrg: intel.com
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Stefan Hajnoczi <stefanha@gmail.com>
> Sent: Monday, June 29, 2020 5:22 PM
>=20
> On Wed, Jun 24, 2020 at 01:55:26AM -0700, Liu Yi L wrote:
> > +Details can be found in Documentation/userspace-api/iommu.rst. For
> > +Intel VT-d, each stage 1 page table is bound to host by:
> > +
> > +    nesting_op->flags =3D VFIO_IOMMU_NESTING_OP_BIND_PGTBL;
> > +    memcpy(&nesting_op->data, &bind_data, sizeof(bind_data));
> > +    ioctl(container->fd, VFIO_IOMMU_NESTING_OP, nesting_op);
> > +
> > +As mentioned above, guest OS may use stage 1 for GIOVA->GPA or GVA->GP=
A.
> > +GVA->GPA page tables are available when PASID (Process Address Space
> > +GVA->ID)
> > +is exposed to guest. e.g. guest with PASID-capable devices assigned.
> > +For such page table binding, the bind_data should include PASID info,
> > +which is allocated by guest itself or by host. This depends on
> > +hardware vendor e.g. Intel VT-d requires to allocate PASID from host.
> > +This requirement is defined by the Virtual Command Support in VT-d
> > +3.0 spec, guest software running on VT-d should allocate PASID from
> > +host kernel. To allocate PASID from host, user space should +check
> > +the IOMMU_NESTING_FEAT_SYSWIDE_PASID
>=20
> s/+check/check/g

got it.

> Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

thanks :-)

Regards,
Yi Liu
