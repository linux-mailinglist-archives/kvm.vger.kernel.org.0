Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2ABE43BF24
	for <lists+kvm@lfdr.de>; Wed, 27 Oct 2021 03:42:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236313AbhJ0BpM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Oct 2021 21:45:12 -0400
Received: from mga03.intel.com ([134.134.136.65]:17269 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235525AbhJ0BpL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Oct 2021 21:45:11 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10149"; a="230001022"
X-IronPort-AV: E=Sophos;i="5.87,184,1631602800"; 
   d="scan'208";a="230001022"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2021 18:42:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,184,1631602800"; 
   d="scan'208";a="447342143"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by orsmga003.jf.intel.com with ESMTP; 26 Oct 2021 18:42:45 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 26 Oct 2021 18:42:45 -0700
Received: from fmsmsx605.amr.corp.intel.com (10.18.126.85) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 26 Oct 2021 18:42:44 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Tue, 26 Oct 2021 18:42:44 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.105)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Tue, 26 Oct 2021 18:42:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=atTxJc3gHjH/PkDEEbnP/VlUylUJJrnfvzCs3HZ3dXWKrry0T/W7Y0cJg6QB026hGsU/c62N64F1LkhPA0oib+MXOgd+jjhKkY990IQ590KrsWDIavu/CyzITinQZ+BE1tnnI/yksHxk5peoHUP/97pcv6ADLcJp7y7ANuqn7KZUlxLOeav8yCmvRenvFHNReCHP+Zpcl9sG9CN4fhii1n6d1oCyHvvT67b7FDJMSSjEyq58F+jyk4tTNlXtGewiEszFGbEN/L642FDGW7++U7KLVwFicwS+u0SRGK/V8bm6ygK62l8k+vkadHjmWePzavVG67wNrEB2m2iTYyEm0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bKI8oSDr75MoFual1Joch+ul0PDkeR0aTQJl4KwmZig=;
 b=fFT+ZrG2Z6WTIKLVYvIWm4mFGnqiS31I8Od2ni8qkwNrnPQetizkzFlOmih0ELngYCdcd2IPncnC4yaMnCsXhV/bknduXfXuzxSupgccQSr49Rh6niPZWHMRtOkW73bOlnV9iVd3/uxbFl8qRZukc7C5SK3LDEJtykduylacYw3MvISCggmHGvVJWVuY+IMIXmBrpB67LWkPwM/ICrrt1cO756orFx6ZIZsA9XUJdCBGrnwajD/LntJM2PbgajAOyUUEjRDIcxkdc8cHpWMuyYlSCFgRQwGluoeJdUT23VN73H4ggusTiMy6oKo/ERzzOvSc7WnE6Mear+JeEJ6Dgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bKI8oSDr75MoFual1Joch+ul0PDkeR0aTQJl4KwmZig=;
 b=GEdQ6Ht+cB99JBtOReDgRQ+c4T7KnsXtFrvvpMVhbN3kxq0NbjxY/l22OVTd2GR6op6cpTOFR3+XDqku62Hh/ly5hz/Il+3RDeYqTENR4iduBq7WNbo0ZDORaysstxgOPj1LIUkJThTAyolSIrGuqBHoxcBuvWQ0P8X663+0mgE=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN6PR11MB1329.namprd11.prod.outlook.com (2603:10b6:404:47::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Wed, 27 Oct
 2021 01:42:42 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ecad:62e1:bab9:ac81]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ecad:62e1:bab9:ac81%7]) with mapi id 15.20.4649.014; Wed, 27 Oct 2021
 01:42:42 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "hch@lst.de" <hch@lst.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "lkml@metux.net" <lkml@metux.net>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "lushenming@huawei.com" <lushenming@huawei.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "yi.l.liu@linux.intel.com" <yi.l.liu@linux.intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>
Subject: RE: [RFC 10/20] iommu/iommufd: Add IOMMU_DEVICE_GET_INFO
Thread-Topic: [RFC 10/20] iommu/iommufd: Add IOMMU_DEVICE_GET_INFO
Thread-Index: AQHXrSGNbNtRgavabUSKJjvt8l12BauwlhaAgAAouwCAACufAIAAEL4QgACKr4CACtdfoIAA3DaAgBUX8GCAAHivgIAAl4FggAl6ZNCAAXETAIAAHLdQgAYt1oCAAbXnQA==
Date:   Wed, 27 Oct 2021 01:42:42 +0000
Message-ID: <BN9PR11MB54333B2F59E8B45CB523A36B8C859@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <BN9PR11MB54333BDB1E58387FD9999DF18CA39@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210923114219.GG964074@nvidia.com>
 <BN9PR11MB5433519229319BA951CA97638CAA9@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210930222355.GH964074@nvidia.com>
 <BN9PR11MB5433530032DC8400B71FCB788CB89@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20211014154259.GT2744544@nvidia.com>
 <BN9PR11MB543327BB6D58AEF91AD2C9D18CB99@BN9PR11MB5433.namprd11.prod.outlook.com>
 <BL1PR11MB5429973588E4FBCEC8F519A88CBF9@BL1PR11MB5429.namprd11.prod.outlook.com>
 <20211021233036.GN2744544@nvidia.com>
 <BN9PR11MB5433482C3754A8A383C3B6298C809@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20211025233459.GM2744544@nvidia.com>
In-Reply-To: <20211025233459.GM2744544@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a88ff1f7-b36c-4b65-e7a2-08d998eb114d
x-ms-traffictypediagnostic: BN6PR11MB1329:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <BN6PR11MB13299E866AA6DBCBFE4383A18C859@BN6PR11MB1329.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kEjWTug5oatMoQYhsM3Nu7euO45eCXJ65N0lpariVKKDqzHIrEzC7zCtEbv5dXF3FNIB+IcyNuMuj3awvfgKTLPkACe4tEKgk8nqnFchxgED7FFtl9kxaZDvUyHEsUbTlqi1xw4APeNVQrGDkqzwMKgNcqsv/8GwAnSy1+igYHMhlaok4PlFxa300ra8JR4rz4UBHJyV5G3ia0fk9T3Gm0gRiwSW0tZFH+Sj5uB4NLGETK0ZQa+uEV66awFTu/jx6YKnCy46baHVB+wNRUTE7BhKgBZ9BpsW1ue8ioQ+QA3KBjrPKCaCjeoFGeClTkJsJGKianhvLOsIuKzSNrAzclAg17kqh/KNNtegctl15mLyij0er7eO1PIvS35GNI7EiEe/GBHc9w7vf+VS3KbgUTBoNjaEFYbQpfiM03/xh3470CKjGzmMqfQNBuPZ4fNt9dTeznvbW7beC0/GruTe9lKtuQNIvDl3ZiVSgYKqMpokG/9skhyGMshIIhnHxQWVlhU8AhmUbbrbvTNqlreQsJxJBHHXNFdoz/8Pu17bwQyfg6kJAdtGUaCoTDKAZwc7SKTa3Xh38icSgNh4a4rU2seWzbYDdWRr3TiPWe8ROnnVpcg/YDzvbSWPiaLym4GJN2KyGnZestRoX7C8pr0uTd6Zy/XsTLrXlWFFwANgQ5iQW+UROl7eswqAtRy36c/PNxotQFUxe3SAtXFQRJr+fw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66946007)(54906003)(4326008)(33656002)(66446008)(76116006)(7416002)(38100700002)(64756008)(82960400001)(26005)(7696005)(8936002)(86362001)(2906002)(52536014)(38070700005)(122000001)(508600001)(8676002)(6916009)(55016002)(186003)(316002)(6506007)(9686003)(83380400001)(71200400001)(66556008)(66476007)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?brZ/NsPL9+KWc8LChDRAP2OtQV7jY9X2teONOdS23SHOKy/ryY0CrhlW02vt?=
 =?us-ascii?Q?nhkJa0ZE52FYqEaaUWpHyCvuAe6utlVSDfrPg4aHPs1F8CIk51ZvWIMrbUDq?=
 =?us-ascii?Q?1aafjn1m7lef1OV9hUkpb5o253TkpLrNJPp71GPAfy1cWqezpoufw7zF9Tju?=
 =?us-ascii?Q?c9IiBA1QXsRz2C//k/rlYT2z50waB5+mXSRwBiI4NDGwvgMypWHjU9IjewJn?=
 =?us-ascii?Q?H9DkonTgTqc91c8Z4dDtJlX8gLzznf1DHtFF6RWOVv7AZ8mHhieW+vhN7Vu/?=
 =?us-ascii?Q?wcIjW4oEiKVnFGh0xxi1UV75VHIs8akI/XO8vXdg+UQk/lS9XflIFEo6K/aV?=
 =?us-ascii?Q?VmQMUUfiBRSMcLZRKrrFjzhU+pI/YknygZVbhztVbRq3NXjO/0wTQeEpuCsS?=
 =?us-ascii?Q?aXl58aXNbTpZq4wSqJ2us8/r8bobmVVJPPMnB8UGEeEUylhqfvtCtbM2znpv?=
 =?us-ascii?Q?IMsSm2G/OspfgKWn6v+fuDMTuCUSA/JtLBmgTkEgJayYk0YFox4uJdDVmh/k?=
 =?us-ascii?Q?e5rsQT5pNpp7Lp9WtjAZsz9aNpaalLW4ZmQ5NhRYAc5tqkdZ7ohIjCwczOIu?=
 =?us-ascii?Q?4F6YdcPAbKFvMRUI3u2PM93OrIU1z/x5t1gclqJfjQzxwG+wyA9tKoIkeOE2?=
 =?us-ascii?Q?Jywc2RMs7m7N0HufzGJidYJPQn9YipvjH1qjI7cL/3mr6HiludwbQi75EUPf?=
 =?us-ascii?Q?blTDc2RrW/kKVIymc4pB6NBrqbTQJzxPh8ItTUiqsmS51P8HG1jAAiTpVYXG?=
 =?us-ascii?Q?sV4VDXtfwY+stBuUncgN5fr9+Rmij8n0WKP7Y9dnFAi+U96riZYujSZsNolV?=
 =?us-ascii?Q?4wevmQh1Q5DlsoQQZJqsUz7SGZM14n7bgdPpOGV+6iTnAD52l0SMnIMoZyCD?=
 =?us-ascii?Q?mDzxBrtGQ/qCHG91is3ZhEHMmEm8FrHoqf70SBF11hLvbayr3indNtoVrG5q?=
 =?us-ascii?Q?hFc/mshF4MORRECDftxyPYbxpYdovm9+gujqmw0YPtq6kUFEdoT0lUFJun2W?=
 =?us-ascii?Q?tdt6GxolmUrv64+0noikT6tB36/FMJqTRNzHZknhDNyfFrC/lrq3c+nZt0rX?=
 =?us-ascii?Q?juflPeGPnLfye8q+uhMj4ehtCMrPf0FPz15pdKQ2cE68kfAipoNHbpLF5cuR?=
 =?us-ascii?Q?8B/uXrBjR6lFHAYKTiqsF3sD+JPc25uS4kuS/Aw3v5JFxG5eCB6fzYnMey/T?=
 =?us-ascii?Q?ODJF3P1/JeEi77MrjGPYkKGdU3vMKNSIJWJJlw34hlq6nIH0ZaCPU12s3elT?=
 =?us-ascii?Q?OHSdhkn6nL5HxPLXv4z71uqydC7yyGRlbIcFSCZAIIFH2yLy3HDyrBEYxPIw?=
 =?us-ascii?Q?i3kJPiup+IC0CrUvqiLJ1I/IxgJ0eqoD/tv0It7BA35CZNgEWdWa6CwW5CG1?=
 =?us-ascii?Q?w7LBigt8Tr5A+uywak/n/5apyhVZ4GR7PbmKTtQwPKNTfhY8TDgJcZVg3e9V?=
 =?us-ascii?Q?uFYGFhneLLu+V5l+/Bnr+fPp7tZLGF/8NROKW6iTrxRAB8q2pn379l5wtey2?=
 =?us-ascii?Q?PIVsU44ImpG0VNA9agH5GdQdBNqZL7WavuSUPgRh0YDzUnH7z6plgT+WH6IV?=
 =?us-ascii?Q?j7hYRsXYjf5MkSiZFQDi86hgZ8OpHmOhd2YMHOk5jDJCNSXlfyGbVAzlU+fS?=
 =?us-ascii?Q?J3ozTFW8vIqDK4J74rZkX+8=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a88ff1f7-b36c-4b65-e7a2-08d998eb114d
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Oct 2021 01:42:42.1076
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: c5Y6ZfH30o7dlvX9slzt+PJVAdj0yl/Sgn7YpyNas8wYw7BNe2HLiRlJz1d3hGHMsmHTQhqHJKLFfQflpkc62w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1329
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Tuesday, October 26, 2021 7:35 AM
>=20
> On Fri, Oct 22, 2021 at 03:08:06AM +0000, Tian, Kevin wrote:
>=20
> > > I have no idea what security model makes sense for wbinvd, that is th=
e
> > > major question you have to answer.
> >
> > wbinvd flushes the entire cache in local cpu. It's more a performance
> > isolation problem but nothing can prevent it once the user is allowed
> > to call this ioctl. This is the main reason why wbinvd is a privileged
> > instruction and is emulated by kvm as a nop unless an assigned device
> > has no-snoop requirement. alternatively the user may call clflush
> > which is unprivileged and can invalidate a specific cache line, though
> > not efficient for flushing a big buffer.
> >
> > One tricky thing is that the process might be scheduled to different
> > cpus between writing buffers and calling wbinvd ioctl. Since wbvind
> > only has local behavior, it requires the ioctl to call wbinvd on all
> > cpus that this process has previously been scheduled on.
>=20
> That is such a hassle, you may want to re-open this with the kvm
> people as it seems ARM also has different behavior between VM and
> process here.
>=20
> The ideal is already not being met, so maybe we can keep special
> casing cache ops?
>=20

will do.
