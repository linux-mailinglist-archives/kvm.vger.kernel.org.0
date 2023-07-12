Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DB40750314
	for <lists+kvm@lfdr.de>; Wed, 12 Jul 2023 11:28:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232025AbjGLJ2t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jul 2023 05:28:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbjGLJ2s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jul 2023 05:28:48 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A839FB
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 02:28:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689154127; x=1720690127;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=lUHut9h8FNpF4I2+oIgBHdQUJET/rilS2O4/M/t5t/U=;
  b=Kjox44Br3k3nYyWd9dK25/vIVmI3Ztfxp4CNGcsidpWfEi/JcSJoNOdA
   Z4zDRlGOSBYbBVJaocmQ8zUtMCNXIRLIyerH+WkB7IZYLmc54LUWqewzg
   2xWKogyMh98gWmv96wwZ0Xf9TI88bVZP4Ex4jKM7iievcEaRh096v2OtH
   gFBSfgMfk65KEWCiVZkOfTIPimNyJlyyOUTrc2vwMp/FkzrDOtBrRogO3
   2qV1pTzg8SLIKbChOusDNpcgk46G9X4QZeQtGPByjt2rh/11FXFANGMpR
   2EGoLK+SIx4o2zRckQ7LCMUF85z6iXchUU+8TZQTm+wAcxNFwi8eCowDI
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10768"; a="430974414"
X-IronPort-AV: E=Sophos;i="6.01,199,1684825200"; 
   d="scan'208";a="430974414"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2023 02:28:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10768"; a="756693005"
X-IronPort-AV: E=Sophos;i="6.01,199,1684825200"; 
   d="scan'208";a="756693005"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga001.jf.intel.com with ESMTP; 12 Jul 2023 02:28:46 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 12 Jul 2023 02:28:46 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Wed, 12 Jul 2023 02:28:46 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.106)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Wed, 12 Jul 2023 02:28:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FzIc2Iu1uQW9ZV5JUGhsi7SsnEazbHq4UbOgrVHo/btRF+CApZLjCmMhLvM5C8WRF3JwVH1e1j7ddj9OdmcxbnoNPtayBmEGPjmZ5a15QFWW2U4ILyCbu//ZKs18S63g+9jqdjDPL8Mx3SaSHu7clmHk4Di5hdv4740h7RKy21c2vl4lfk/Brge7JYa2iYWxpdpYYOtzIn0dBJsdcqGH0wDHX6lRJQxa5Jv9lC3O5FDS5VOSEvapXOODozvh7D/BAQX1kBR1bd8b+6WkNEo4UBoP5K1Nc0mEHRPWO0pTfA8yq3eo8WGnZlLTwld7251a5y5nJUR0B5fYNaVwEHfEuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HJwct6djwGItwMr8jz0JbkS+eu7seFCgJW1hvMUiDeI=;
 b=Mgj4PCvFup9oNEUEr5kXb3DvR1vF3iGKS4a5ZAsJLubb7dCeeLbD+MYFlAqgv+E6IBp4sse0u+yqlWX7tTPzVTTj0TwoB03ChVmAliKI+uXU/X7CFHa+jJ58LtEiT8VMUKa/cFReFLY+VP0jq93k/Br9hyVTnFUSbzxjpUNpDkaJv1vsYkom6ybALm6UgPOHtwycw25BtU6rQn25F0ZzeGTtXBhhgGQ5UmwxzDG+V9EkCjFjB99jJtMOzAbhoMEQb10T5gKvap8PHisdeVrtOtvznGPkZhxnSE3aGrPAIEefCaEkheoEqXRKygf1IJ7whBDDHMf1SHkxbXDy1grKrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB6722.namprd11.prod.outlook.com (2603:10b6:510:1ae::15)
 by SN7PR11MB7540.namprd11.prod.outlook.com (2603:10b6:806:340::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.20; Wed, 12 Jul
 2023 09:28:43 +0000
Received: from PH7PR11MB6722.namprd11.prod.outlook.com
 ([fe80::a38d:7b08:2962:bf91]) by PH7PR11MB6722.namprd11.prod.outlook.com
 ([fe80::a38d:7b08:2962:bf91%4]) with mapi id 15.20.6565.028; Wed, 12 Jul 2023
 09:28:42 +0000
From:   "Duan, Zhenzhong" <zhenzhong.duan@intel.com>
To:     Cornelia Huck <cohuck@redhat.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "clg@redhat.com" <clg@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Sun, Yi Y" <yi.y.sun@intel.com>,
        "Peng, Chao P" <chao.p.peng@intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "open list:Overall KVM CPUs" <kvm@vger.kernel.org>
Subject: RE: [RFC PATCH v4 02/24] Update linux-header per VFIO device cdev v14
Thread-Topic: [RFC PATCH v4 02/24] Update linux-header per VFIO device cdev
 v14
Thread-Index: AQHZtJP6abAtyMZZQ0mGEdgI1BSU06+1wX4AgAACbIA=
Date:   Wed, 12 Jul 2023 09:28:41 +0000
Message-ID: <PH7PR11MB67221F2DE29B1995918B94159236A@PH7PR11MB6722.namprd11.prod.outlook.com>
References: <20230712072528.275577-1-zhenzhong.duan@intel.com>
 <20230712072528.275577-3-zhenzhong.duan@intel.com>
 <87v8epk1sh.fsf@redhat.com>
In-Reply-To: <87v8epk1sh.fsf@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB6722:EE_|SN7PR11MB7540:EE_
x-ms-office365-filtering-correlation-id: 9292e551-b511-4142-2975-08db82ba6190
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ioeRDcvhLLL5HxyjFJLUxu/SxJJK94GDM1UPVoMI/Wm40lKEhAhmPlYh7KM52tbAkLuRv4b+kTaHXYvYKBykINbgwnnT6kZpOd9bK2Z4busUtkPJrXR5eLNSv1qEdqmiUxehKWqPMXWnFLk9evp74WA8EdHKb7sY2UD1jXwws6TEp1G8PcEwgzPntwRgXwzYnpIQ8ZalsnhNqqzorsKGku7X/xz3IgGp0ZwrhH3trJNHmKx7ABoihAGvgXZDKnVRWRgc3UJ/pisFyPwSaY+R7iA6LVTXRH9u1VvHlDcxF3aMKpeBo4/kfzltjmdp8wSy/mJcPU+WNqPytOi0o9GfI8wakogSX8MqdajNAZpGXTiQLGdBwO2B8unwRaZST+G44Pc3/HFR00cftnqJKjjBgUHKGFXrTR8g87kMYIYYkKltLJ3/KQRAkmHjjpGB2x/QNmeC/GBV0Qwmq8yqYzqdsfzwpdUiWraM3k+G4gIv83i1m2HT8BZc066tC1xpBSF/knA7ccCjO0D7mUOlTQfzOwJObBpRmp2alyPT+HBBPJ8jFTFm5/Yd++hvaPP264io/22AjfCrh14Wx2jSJCRtTQ2KbyojCw7Zicimz3jZA9hmKY04HNRrMW2n3y8ELv4x
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB6722.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(136003)(396003)(346002)(39860400002)(366004)(451199021)(7696005)(186003)(82960400001)(122000001)(54906003)(55016003)(86362001)(71200400001)(478600001)(110136005)(6506007)(26005)(9686003)(52536014)(7416002)(38070700005)(316002)(15650500001)(8936002)(8676002)(41300700001)(5660300002)(83380400001)(33656002)(66476007)(66446008)(66556008)(64756008)(66946007)(4326008)(38100700002)(2906002)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?2b/k7vlNjDwqcooIbe1Y3DNGRoyZ22O/sPSC8AVRC4y6TgTbHuesF4A69ov7?=
 =?us-ascii?Q?32ThJOP9w4f2p8aOCuSTY2C5IGY4yQQOWHyD8kCz3c7P90uW/7YBTlr/jMLF?=
 =?us-ascii?Q?2uBJsUGKz3+QJld5yvBYlZESCDOUAW1yYIk71ldjqonVoSd4M9EwoDNb1y+m?=
 =?us-ascii?Q?ZrgAsdDS5QA5V9c+/RduVXNTudUa9Cn8LkIQgE1Ll40xjEsJC+XBW+H9Mkc5?=
 =?us-ascii?Q?8fn87kap23If/odvvLsc9iFtX+zH+UH3F7rk1c5i7MTItdXH5nYIZLaOvvmX?=
 =?us-ascii?Q?AxMJ47R0XHdo8+CPLpmzTN3NVX0vx9pAsD3ctypHZiP75WM1ay3Ha07cJ0ZU?=
 =?us-ascii?Q?kSN7Jq6CbeF0DUd4mFVM2ueDdqpnLTqhemSGpfI8EAy//Gs5k9iQJtOUWbd5?=
 =?us-ascii?Q?jSm9NYHnOpdjSSHcu9EQgOgGftyJjc+I1yjPeuXaJJgDRckc3ynwl5CtsByr?=
 =?us-ascii?Q?155OzT3XGTqpRx3mNpVALyXvZOJHiryu9/jVY5HSjNPf5VVrnsuSLvhnL1zJ?=
 =?us-ascii?Q?ckWCK7yBJE+fqeRyHiSHwhy/gnBRBg6xKCWRfFaJ15xHo7U/NYexDY2r0Eon?=
 =?us-ascii?Q?G8nDTRPKmUK0f2yYn7bhMTgmAoCreaDkMJRfqxHFhRzL1wrGi+eoqsnlWj/Z?=
 =?us-ascii?Q?p+sj0j/QZtwEtciAlw6x0IyAtsoEsbneU7RWehLsRDzYMsnHpe7i6WFwbNcF?=
 =?us-ascii?Q?K15q0eZUSWtgCV1CAGWvoeLtYKqyILXcoPrhH4tst6wC1nHRupWC+Xty3bSd?=
 =?us-ascii?Q?3bOFrAPtEwI99n03Kzjvpt1s3SmO3DyxOVMCnJsJSaPzRfl9Rarzw7Bq8P/m?=
 =?us-ascii?Q?xwRc7VElQ2Fx3xqTn62zRewVoVyBfRfh9UtsumasHMYDtce0/KejGQxvKRrM?=
 =?us-ascii?Q?Zi2K3t3SuD7AzmLlh3avXfMwqFK1lXplZE1Ftlnpde7a/ffBSoPdQ0wBuS/b?=
 =?us-ascii?Q?ZyP/Hi3ZyNydRSn2lxi6nd/oGFRqSXRsboDR8Hz1d0zM2mNVIIkcHCBzXRfu?=
 =?us-ascii?Q?skc9yny3VLVQYq8fyYvmo0TFyA+Uun44qw163qPSXCycbdG0E9njTk3zQkWG?=
 =?us-ascii?Q?NEez/roRP1lbYbXgeic+fAn9W5U2/IkJLGnqEDpo/D8GggwMl4cP0A6Gf3kO?=
 =?us-ascii?Q?zBybnzru7GjcxFUlEjxZw5xGHoSRxwEugQtLQ0lK6xjMMhwgjbSI7IGGHwe9?=
 =?us-ascii?Q?ay931Prb1JcIyZE0v+fZUmXv7+zaLeMEXSW1kyrbH4QQJyrLZPtQ4vsJCgOO?=
 =?us-ascii?Q?fs0qRKHa/qV4c9lZllVPUNOcJbHCJ2+Z8DfH5Bg4Km55zEuC5qdTiMAvy1f+?=
 =?us-ascii?Q?Vh9JaOoFyq3X7EGx5jvACI6yDHLFThuUskAhjuI6wjpSv3x/CWo8d8xBcSld?=
 =?us-ascii?Q?ABF0yzKYFq/wtrRPFRLghfKgm9JmE72oRxLtD8MKuL8Vo/RwUJQVaV0AO+Xy?=
 =?us-ascii?Q?7azVqVxVZ4mqqrQE1AzX37fx0UHvZUAIE4SUvGSRSY1WPqtZvrlj4bJBxcGN?=
 =?us-ascii?Q?wLArYKqCZDYHd5ojnCZIHXv+dd2v99pAgwfdV09cccswq1wdkixqOvOVu+1K?=
 =?us-ascii?Q?4xB4oZPJYEMrEQooTWk7XwdItM0KJ6EiB7B2KQC+?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB6722.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9292e551-b511-4142-2975-08db82ba6190
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jul 2023 09:28:41.5329
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4meuos3YTR7oG4WJSXaS6pHnz3qAjDg5SrdY3EzdwY62w9abFFN3hIOscnz50+n5TM74pnyWhRvPAx5o4Nnzc7EyyZtmymlThVSDtQR+ecY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7540
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

>-----Original Message-----
>From: Cornelia Huck <cohuck@redhat.com>
>Sent: Wednesday, July 12, 2023 3:49 PM
>Subject: Re: [RFC PATCH v4 02/24] Update linux-header per VFIO device cdev
>v14
>
>On Wed, Jul 12 2023, Zhenzhong Duan <zhenzhong.duan@intel.com> wrote:
>
>> Signed-off-by: Zhenzhong Duan <zhenzhong.duan@intel.com>
>> ---
>>  linux-headers/linux/iommufd.h | 347
>++++++++++++++++++++++++++++++++++
>>  linux-headers/linux/kvm.h     |  13 +-
>>  linux-headers/linux/vfio.h    | 142 +++++++++++++-
>>  3 files changed, 498 insertions(+), 4 deletions(-)
>>  create mode 100644 linux-headers/linux/iommufd.h
>
>Hi,
>
>if this patch is intending to pull code that is not yet integrated in
>the Linux kernel, please mark this as a placeholder patch. If the code
>is already integrated, please run a full headers update against a
>released version (can be -rc) and note that version in the patch
>description.
Thanks for point out, will do in next post.
About "placeholder patch", should I claim it is placeholder in patch
subject or description field, or there is official step to do that?

Thanks
Zhenzhong

