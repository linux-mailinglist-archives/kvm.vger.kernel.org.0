Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FB64514037
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 03:21:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353925AbiD2BY7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Apr 2022 21:24:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353914AbiD2BY5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Apr 2022 21:24:57 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34145BF30E
        for <kvm@vger.kernel.org>; Thu, 28 Apr 2022 18:21:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651195301; x=1682731301;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=FVDa22NkUznuk977ChlKY16nVqfLmZCk1FQayHQ8PyE=;
  b=CJ/giGPnbj7C6x/bbbC98b2hWwzVaJMY/wZymqqyXEkogBah0+Cskbg2
   Ppy9ahm0PmLoBN9Gq/vbQhChzs9E8eF7GfT8ohyFQwMobtnSEOOoIzVTj
   oj7s/tKvdZVjsqW89g+N1bkdL0kNSuoJlC15ZfovFdWzxDBIWI41FPP7y
   KtRmrJSrTVzORme/PAV9pqsxbXHQ8M4zAfQtvwEy+kaoryLhqLRevAtFw
   k++pH12qX8s2slmPW3XKW8aAmrbPqKVP3F8p2Hj3SzEcpWGt8LNY3RpaB
   bKEv2xj+S7GxAQGSC1vUTCejPekvluOLh6ziKHw4tCyIz+pqWV1Z4n1Jm
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10331"; a="264074264"
X-IronPort-AV: E=Sophos;i="5.91,296,1647327600"; 
   d="scan'208";a="264074264"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 18:21:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,296,1647327600"; 
   d="scan'208";a="581767337"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by orsmga008.jf.intel.com with ESMTP; 28 Apr 2022 18:21:40 -0700
Received: from fmsmsx606.amr.corp.intel.com (10.18.126.86) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 28 Apr 2022 18:21:39 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Thu, 28 Apr 2022 18:21:39 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.104)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Thu, 28 Apr 2022 18:21:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bVDhNpLmlVAMlA1bPWXUxMZMTn+1ogPjVnRS9qgZf6OISvJvB8wSx9rpBvZjaJ2GDgnJH29m3HrOxdk8rUeZ96mgaoaxOoP13gj+hD+wXxESyuhHRozb9IZQiDys7BCmG1HSrCNn+RvePhjnktdsPbxrybKuXZ7ttsOB56ViOjkyVoJtmhAoiSDqb6ELIIF03rIxG6kBahsyFQUmRvxJNTmNh6vh//lTufCsOcsQL8LlHU8CZM1v0NQs/t22im5bv0M07RZ9djMF/IkgaQXUqia8a0DaRvXyfpvZiG6cMfWtgn4rYp0Vd2s859MxUrk6o+slzlaM8lBjmilJtHGvkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XO1d1IanOj00M2kMl9INK10CudalvO7Gr0+AqzeK33Q=;
 b=W+1w7RaAU0Eop74BD2vZWr2VMLirAfkL209+2sRuoIn7mWwK/aOJjxcqcYkB7RpLMHq/E7RXMmv/EIDKiVjKiWnjTp99fY/4SSaRH7svZ8/WrXbFSAFbKHHlswwVlItb3p6boxzgPHP8RrWC+n9hOukVEaE1yQHSDd7yexLo1fcCfbJT0t+Qtyek7U/cL+hk2YBT0WZTGoB+mr0ax/owydV9ujfQNLysqvc/vw93Lb6p4KFsySuUplNfqJh7ewMxzYY1cKB0VHmimElFgBZ9Nm9LIAsmMppZkLZJbA3Rww5iHGYkllf4zUGbWVycLzr8jDEp3sirEw8wDCLcRG7BQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BN6PR11MB3890.namprd11.prod.outlook.com (2603:10b6:405:7a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.23; Fri, 29 Apr
 2022 01:21:30 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::24dd:37c2:3778:1adb]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::24dd:37c2:3778:1adb%2]) with mapi id 15.20.5206.013; Fri, 29 Apr 2022
 01:21:30 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        David Gibson <david@gibson.dropbear.id.au>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        Eric Auger <eric.auger@redhat.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "Jason Wang" <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Martins, Joao" <joao.m.martins@oracle.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        "Shameerali Kolothum Thodi" <shameerali.kolothum.thodi@huawei.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>
Subject: RE: [PATCH RFC 11/12] iommufd: vfio container FD ioctl compatibility
Thread-Topic: [PATCH RFC 11/12] iommufd: vfio container FD ioctl compatibility
Thread-Index: AQHYOu2EhhTTZTsn5EqajxaIjlC6M6zNmzGAgAAclACAAWiFgIA2iT0AgAAE2ICAAKo2cA==
Date:   Fri, 29 Apr 2022 01:21:30 +0000
Message-ID: <BN9PR11MB5276C4C51B3EB6AD77DEFFCD8CFC9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
 <11-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
 <20220323165125.5efd5976.alex.williamson@redhat.com>
 <20220324003342.GV11336@nvidia.com>
 <20220324160403.42131028.alex.williamson@redhat.com> <YmqqXHsCTxVb2/Oa@yekko>
 <20220428151037.GK8364@nvidia.com>
In-Reply-To: <20220428151037.GK8364@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f655b7c6-1d60-4272-c243-08da297e971e
x-ms-traffictypediagnostic: BN6PR11MB3890:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <BN6PR11MB3890A33D65399B669A027DA48CFC9@BN6PR11MB3890.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wCQ4zoc8hRRl944T60Xl1RvuAVpsw11H5nfAPtJAmrA92ymTBEHt7o+kdBxeZvf+7HqnqgYoFfnahs+mhPGu40i8gExlJackrt17xOf/r9GbAxjVtZ+XJ1qURU+haCJdT5FZ6PzwAvoIk83wKjLe8WGL1qFmlpcxFXxsOV2N+HitH3GcejWTW/+tLX0omBxXQl9kbJofpvz3Ie+a9M2OK8wU+arF0i0pUDPEGjwLLzV5gyEH6z8OQSntUfxsze8zI+fc7lyjgLIQpoeXcz6WxY4H+7vT5dWrfP0QFx9WZwURwkfB+/3Z1Dxzm/iqg6T7rOZqeiK8/SljA6nrkkT5HuVfadyxcXq0z1SU4ke7sP5dJ84ybphS2Eb75uxqrs1HTx772xSfC7VvP5Nd0vertFDg+fx8K8iYUgMYxCLpcLrmSt7zWfScr8IT7ukdsbQfrlqjoK7UIttiGqJsZpYIsL49vXy7KJjxYaqEKCNZ6905s+J5JX9+ybiWvbRnJlx7oCJHsVYu9N9uSZ7U63zTZZ9xXTWk8ZDKI868KqwjLSm7p62dggy8hajYJdkCyHf0J8K0X7xuE5GGyvPSjns/zt1u7o8xaz8/Bd2BfcUK9gBkEZxsv0/vBFAQYxPW80F58WyeQaJDsqQ9t/8NUWNsdjsyan80gP+Qw/QX1awlpntfbrRNq+DpHOcRW0PI/OeI8UcBiIM+rXEE5yUUFyL+qg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(26005)(55016003)(9686003)(5660300002)(86362001)(316002)(7416002)(110136005)(508600001)(38070700005)(38100700002)(8936002)(54906003)(7696005)(52536014)(4326008)(6506007)(82960400001)(122000001)(186003)(33656002)(66946007)(66556008)(64756008)(76116006)(66446008)(66476007)(83380400001)(8676002)(2906002)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?OaoP9Z9EY1imLeufvX3WBcxTs4azEecSjUgwCzXBwn7nuxbjto26G2RFxGFt?=
 =?us-ascii?Q?cGJTpXj/peDoR7DMLK2l1Jr/EGHf23gubAgPragOR8QQjXkJd7Na/sdtn1nb?=
 =?us-ascii?Q?5vInRcctvmJvqHm/hF6OMd0nboTa+fW01mSXn0w/KEkEeDFEizMrXQ9cNZ8L?=
 =?us-ascii?Q?vdIftIC04efmbY0EDwav4RNINjpHqqP92SbOFqaCcnzYyE8KaFKqjgpj8AcX?=
 =?us-ascii?Q?Et58jAaV8yD753dt7EmEkMGfVOac22CjM00/qMPIBrL0thytWT2XqiOsfTxO?=
 =?us-ascii?Q?FA4KpZicEJvTNhgA+3+LoHdR8FBwH2LFFJ2jzCL5D1Xts1k9zCc9LN9RTmIY?=
 =?us-ascii?Q?uk4In5/xR9hp0arAUZGttfRL3OtVF+VsfT6eFTIGe7kdpmhFkR/5qxBjWlW0?=
 =?us-ascii?Q?iYCWIIqQClnuo5P3KkBtOCO04h/WEcSaoQ/EDysbZMVTgGVDaqIMafiYe8Ag?=
 =?us-ascii?Q?8vAko8uTEi6YKyvBJEcplOUEkbksL8PItD9/2Fm/CDH0fmDlGy6uzBNX1eLh?=
 =?us-ascii?Q?FhLvZzr2pYK49U8BB7H8dFDYp93lndbJcJ/3kkOA1hTxFeKqjzmlHZoOE7+n?=
 =?us-ascii?Q?A0MbcvZByKuKvEOrmXa1gq+59L2znXjeJxwOrMPRv/pxSUeJwKmRtyPrYq2D?=
 =?us-ascii?Q?oul6tL3zRUuCqVZQE+/E/Zv13w0/DpV7A0j/BoXfmdtoGOjvANEQL5i+bcvK?=
 =?us-ascii?Q?Z1IWBeKvytMJFDDVUh+nQToP/kOBE51I61Z/RUxCKUM+9aYkJJP2xGoEG/DZ?=
 =?us-ascii?Q?J9Ss9ovsP8HBQC2zHtm+Ur4Da6r//ftjRHF51Xp+NP3oDRu9nzi/Wh88pQZL?=
 =?us-ascii?Q?U6ckoRe9VoAWZXfdeFwO/ToYG0eDaYMHUpDS1zUvHBPytjc+QKf10mCCCaG0?=
 =?us-ascii?Q?nJT0m6q9VK6pnG31wixscIekwHPVYiI/B3ng5k4XYZKnxIrHBBOcC4y+n5Uf?=
 =?us-ascii?Q?xbedSPoQ8mCE5c38aUUdKjy4fdDDj7U+oERed9CnlrIvEqNoFoFTZ8GvCwNL?=
 =?us-ascii?Q?NhS0qASI07rXFjB509eSc+37iRC0uk4qasbNKRtXnX9dtQPhU4vRcQ0p+Bnd?=
 =?us-ascii?Q?f6Ym4lxziUcq0qwRH45fAFp6bwbj1SyNYKEgIgnrT1s1GShkY+8eY+PZOqyi?=
 =?us-ascii?Q?PodyzUlY8pUZVhy8JwY03F4AFS4to0kkFC5qD6pXSuzwnFLP/31/U5/L0pzm?=
 =?us-ascii?Q?+pBgtxMwE6S9cAplomABYK4CA1+LCDRDlNj2Crk6Gt/mQJTPUeOSAOk9Enzk?=
 =?us-ascii?Q?RKlxhe/6V3t0Xf/fq3jVyHEV8YQa/xmnctZNkKhyNL6zUJdVM1pS4GcInXbQ?=
 =?us-ascii?Q?GzhoNeV+bkBlwFeQC8ht6pY4R2N2iLVBHMTpLucaYxVUARiClnnAuyE0xkwZ?=
 =?us-ascii?Q?8pWRm+6C9HF2pisPDdS35dgGKsxM+W+y7YJ8HsqqDRK1Zvq1pv+p974Mz1Bn?=
 =?us-ascii?Q?TpJaoGNI8xkGBjDQZO88ovBjxCdi5d2b+FCTR/3KPu7pdeT+zYNLJNh8a7GX?=
 =?us-ascii?Q?eucSLvd39AcZqSatxvCSn7UiOrhi1VSN7xLq8xJK1ma1FKMfX86wmpUBuFY5?=
 =?us-ascii?Q?+55RcEFzRKYcXOXRCKc6kp30H6ZXM7fBIOJbaLvLK+IReAKIrcrLAom28uMJ?=
 =?us-ascii?Q?2bzjtQ55sgq3Xyndu9E48l1U1Br6fs4Q9W3P6d9G0J52j1ZlKjorF7eyX2np?=
 =?us-ascii?Q?W2BtX2pgquoJMyh4vaGEB1IsajuXy3HZBhkWmZLy+QHlfOQhLeXG9koFqJnx?=
 =?us-ascii?Q?C+57pQ1dtA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f655b7c6-1d60-4272-c243-08da297e971e
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Apr 2022 01:21:30.4027
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VMJdtX466EJmOEicCK6T+w+MOqQjQINdPA1VNJX7/wyS+ZquiS1jCa7GsVPZCpH8MkcDIr3PN5Bg/lKi1xmj/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB3890
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Thursday, April 28, 2022 11:11 PM
>=20
>=20
> > 3) "dynamic DMA windows" (DDW).  The IBM IOMMU hardware allows for
> 2 IOVA
> > windows, which aren't contiguous with each other.  The base addresses
> > of each of these are fixed, but the size of each window, the pagesize
> > (i.e. granularity) of each window and the number of levels in the
> > IOMMU pagetable are runtime configurable.  Because it's true in the
> > hardware, it's also true of the vIOMMU interface defined by the IBM
> > hypervisor (and adpoted by KVM as well).  So, guests can request
> > changes in how these windows are handled.  Typical Linux guests will
> > use the "low" window (IOVA 0..2GiB) dynamically, and the high window
> > (IOVA 1<<60..???) to map all of RAM.  However, as a hypervisor we
> > can't count on that; the guest can use them however it wants.
>=20
> As part of nesting iommufd will have a 'create iommu_domain using
> iommu driver specific data' primitive.
>=20
> The driver specific data for PPC can include a description of these
> windows so the PPC specific qemu driver can issue this new ioctl
> using the information provided by the guest.
>=20
> The main issue is that internally to the iommu subsystem the
> iommu_domain aperture is assumed to be a single window. This kAPI will
> have to be improved to model the PPC multi-window iommu_domain.
>=20

From the point of nesting probably each window can be a separate
domain then the existing aperture should still work?
