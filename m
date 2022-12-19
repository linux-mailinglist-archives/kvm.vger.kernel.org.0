Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D86465083A
	for <lists+kvm@lfdr.de>; Mon, 19 Dec 2022 08:55:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230226AbiLSHzX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Dec 2022 02:55:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231261AbiLSHzU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Dec 2022 02:55:20 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46FBCB4A5
        for <kvm@vger.kernel.org>; Sun, 18 Dec 2022 23:55:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671436520; x=1702972520;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=isBKxhgBWPJXrFJ8rB3UM1/yfaXZnn+oa0TSJe0SQmc=;
  b=JrScWI9ggWmWF0J+mW1QeQdsbJ8I3L9PDdnqywJ4x1Vik0or8hFzicHi
   xxWHRAXVroMg3qQ6akc9j5JqqxuDUAC3cpzm3pMjFOeQWypMXRREZfkOl
   L35lwU6Fr+igvn1NQavjN/7HezaMkKID/CNkpXbPldxHY0RyauhtxsNy5
   MV6E1u+Hl0D94Qd3+MeRJaJ1OGKpuiFrN6WD1EfqUv98x7588zD+v9jY0
   OAsOsep/S7lBbDQQ+47YGSJjYxfdypNEP5cRPm8gaF129iWQ3NyYs9M8+
   x1TFXqrp14dODiXmMMV2E9uHQs1y4ZaLJ2XYgDUiMUQ5LxqRz8ZC2qvoe
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10565"; a="321182309"
X-IronPort-AV: E=Sophos;i="5.96,255,1665471600"; 
   d="scan'208";a="321182309"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Dec 2022 23:55:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10565"; a="628219243"
X-IronPort-AV: E=Sophos;i="5.96,255,1665471600"; 
   d="scan'208";a="628219243"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga006.jf.intel.com with ESMTP; 18 Dec 2022 23:55:19 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sun, 18 Dec 2022 23:55:18 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sun, 18 Dec 2022 23:55:18 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Sun, 18 Dec 2022 23:55:18 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.174)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Sun, 18 Dec 2022 23:55:18 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jr/Ku6murGz+bNxjrJ500WuD8pf/+/UQnYe6E312KdFT04I0beM8omt8HTxDaFmtWaFtZ7pfjRX3aw8JJXw6+3mHt3X2Pp/+a6UefTJn22sYd9Mhd1PoBdKbRFcfTM5V2rshoTR+amL6l16LPFHfKHByz9dC7Iq+jp9MosjkRW2L/lXqoaoXFvfpCYUdWRSkc5NYtPfN+8+tFC18hxhLj5QV9R5Dl2n8WPm2j+XWeevQ7vuL6bqcHME2oPmRbnaMH8OB+WTCo7EXJJgze1LJjJxbdk2Ww4C4Dsw42Ci02y2Yb/LBNXrG3fcqiu6nyjF8EqEmrrxTCmWA2xLvhEQVKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t/yQNj1dOmydYIEE2WLkVXcQU1ndUCUblXrGq2tjH6c=;
 b=RlUH/TCYh61BnfOSpI9Gozo6c+vFU4V5JV1od9AR1cgC9yZxzWZUEhT/w7BDneM0RImOB1KrUv43StW81SNWOY/AjEoDE0HSPZvzDZe2TTWHlQgKbwlz0/El26lbO/uwEQpNfth8yKXOixaHaghelp+g62o9zm8Ns/2oSVyIHKqSBoN/L5Pu3Fn3QI84Oh+e2mR3fSO+K3Dw0rn2eZXitzHSDxhFXHElJIc0JKXjW7lQxR+7OwlxeSkASFgMbgk7HRnVJDS3k3sPI26G9w3IzMro+TzxFJycUVTz4hX6JMIK64Nb5JZwWMqixK3ojfSLC+ynA+uPk/L3IzId7TZUfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by PH7PR11MB7641.namprd11.prod.outlook.com (2603:10b6:510:27b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Mon, 19 Dec
 2022 07:55:11 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::8032:d755:9eed:e809]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::8032:d755:9eed:e809%4]) with mapi id 15.20.5924.016; Mon, 19 Dec 2022
 07:55:11 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Steve Sistare <steven.sistare@oracle.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: RE: [PATCH V6 6/7] vfio/type1: revert "implement notify callback"
Thread-Topic: [PATCH V6 6/7] vfio/type1: revert "implement notify callback"
Thread-Index: AQHZEX9bp6DzqaL/R0qnCzQoffCWYa5022EA
Date:   Mon, 19 Dec 2022 07:55:11 +0000
Message-ID: <BN9PR11MB52767E24648F36D74ECE807D8CE59@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <1671216640-157935-1-git-send-email-steven.sistare@oracle.com>
 <1671216640-157935-7-git-send-email-steven.sistare@oracle.com>
In-Reply-To: <1671216640-157935-7-git-send-email-steven.sistare@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|PH7PR11MB7641:EE_
x-ms-office365-filtering-correlation-id: 6c590f3b-56d4-4cd0-c77d-08dae1965b13
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6NXU/JbsLJE7qi43BgGJYgUlIaPzhK9uOHJ4+JFYQRxE+KLqHQPj2Nhc8TEG1k6CPe/pXXkRr1Rzqt3iI0TGV7+bNGhlakWyxqKJJvwKqDMWbiJV2ppCZjHE6NGiiZY79bEzNi0+nQw9BYBjiRBHSHE6uhirJM9NmL3hLPbSLgNJ8ymfIANpCeMUI6BgFR6v4Ua28AJUl+BRTEkKhBkh9w68Srb30VSryiLYPt0sz36aupTWqDjIKEJrZmGZcOu5p3zvaxUGqynvX+B8AtgvVIEj8LWRGk2iwDN8c6a5S2oBpIDolnXlxrJ5pbV6bcHeuEnDghws+m0io70ux62JeLKvQ+vxGuYXPrPxviWhdRW4hNqsVSU3NiFrmK446r8zPl/nkMTymxhbElT3NFNWG4Apf7kToN0JR5gA/dRWm2khp++lVEd/pjuSZ926KNZYyderKEqEGgsG86e3QZhhhhazULBIYZJgRjaonn8VL/Idg1sKrBuq2dsafpVq6EGb7vGxsyW1F5uYEYDnARNq1KQYPs/SNPwaaGZRiskMKFcb7AfmY+/ay0HcZNLld3/ex+PhCuXiZAaZN2pmpB5an5HsqZt5yLLIr65mug/r66jF6CVfRD47/mGZFGqp41Q35ZYZriq29+26k6tBR+oEgyLDq/YH7T0pRDhgy6MykvE8iaMRMRdlyWDy6dSqDzR4kUs9pbFcukIyvAkozayDsg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(366004)(376002)(396003)(346002)(136003)(451199015)(9686003)(186003)(26005)(478600001)(7696005)(6506007)(66476007)(66556008)(8676002)(64756008)(66446008)(66946007)(4326008)(52536014)(41300700001)(8936002)(5660300002)(2906002)(76116006)(55016003)(33656002)(558084003)(110136005)(38100700002)(122000001)(86362001)(71200400001)(316002)(54906003)(82960400001)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?BfTf+2b1LvlVEhhFHMT5gZf6NUcwYzvVH0irgaUzhMIoJdo0P4lM5a+Ii4Mu?=
 =?us-ascii?Q?hvZE8iD5BoBL9OnhHpuVFiFXKilE9wKTBmJV8HSASul/CRITZp+8uU4rUHSH?=
 =?us-ascii?Q?+EgmLCVl+KL5tXeocCdqcDpEdZXi4uqDpdME9tCK9VTT3kvfcisT4zUNGNmR?=
 =?us-ascii?Q?4fMkFcjVuEt1LwCqgl3iuND4l6I9c/yDWPbVbXFG81c90/LNy+OVHDAOJcX9?=
 =?us-ascii?Q?wDw68aENcXxWS7vMfsuOz7WOXzXY67YHeu18L+k4N5E3soH9PyJ+LaF3FyTK?=
 =?us-ascii?Q?LtlDp8NedF+D6DzSLNlElkvzNzwIAfFlD0HJ8PdXI9hcInvXDbVkRkEv+V4M?=
 =?us-ascii?Q?P6AarN+8XrdWoveOBDxAPKSmcE0tsB+W3oLZogH9TFz+I3ODt4P2DpXvTQyI?=
 =?us-ascii?Q?hq+4+1FLxr4NLCBqr1lQcefsI19oUVLNov12N+yNJlKk67BRddsYSgTDTz96?=
 =?us-ascii?Q?RRScOgRGfTE+KxBwMGhC4zBEjjfbdmseA31vcbKF8Xr/dIJQGsFl1Csx6SRa?=
 =?us-ascii?Q?j2AdjGCem6O3pcXSSX+j0kVCCPNTXHxBM71brKdaVpcBF+x2n9xXyrUnC/FK?=
 =?us-ascii?Q?3KBJ5amecSuWu0067AVQf/KKVZ9wDJAAxPSLxCUIVsyeYJpAr8KNvwpq61dg?=
 =?us-ascii?Q?XgfVyMbvDgD0UgfFGpIiga7d5iXhS0vC7x9pTNpU7WVuY/AA2rOjL4gHk1IP?=
 =?us-ascii?Q?Ux6HIJMwN5EGVusAFDI1UJ9FNsBwV47BTx8Max5pQ+rsfg99ZDwZ6HPYg4b2?=
 =?us-ascii?Q?WxvPEg6BlYjvMfBxOfWh2IkgQTRsq0YGCnNUhtiPc+QibkQS0//KPKvtg52e?=
 =?us-ascii?Q?9r59WVvTtklknA/G4utczzplZ+l1F6muwmrNp/UCRD2UMYvY4XLBQUz1mhn6?=
 =?us-ascii?Q?aY3D/Ih54zCqs81ub/MYV47lnAft97A3vvs83FVJ7yvmAFjh67XHB1W6vYN0?=
 =?us-ascii?Q?1fob5Wi/SUW8bxsGPODn5LX4qBTd+zaRioI9yGyn2EteYAhp9Uj2omTxdvuM?=
 =?us-ascii?Q?qBSzN2wXiLniRn/V1uGTBSamhE8VcbPYW9RBQayIHR4N/svW4Q+TI982AONw?=
 =?us-ascii?Q?nAEqnjyIA9ez+Z+W0I2i7ccGReGsYs/BX08xeLaP7M96/UsH9mMGqTNUoUd2?=
 =?us-ascii?Q?hA7LtfGKQ4kdWmZHS4qERBaZEuuteDEPC4EUeqwU3NbuK9aAm+0TgspakK2V?=
 =?us-ascii?Q?9Hyrh1GyUk0ntSayfF7Q9Y+tEJbxWWLMkghsjiT0cSa/lpnL3R9juEbq80Z3?=
 =?us-ascii?Q?s55sZLZuqv5lOlQ8j2aHtitaCtV0uiVpZdbWdUK9JsvHmgV6Ywb/aavksA5w?=
 =?us-ascii?Q?1X4bDoF4ZznQNDk+6sek2HfztJrQcXq5xvKtuaaIq8EAEz5/OFl8pvaqA2Tg?=
 =?us-ascii?Q?wJuGN11+yTe+haim70bDuLor5SS3ONrv9UWZ6b99C0emkNA/Atz16CfJMkiE?=
 =?us-ascii?Q?scF0v0qGxHtyBb1rshti256lNXTGYWIYI+UckGOSLr1VIdLi5e4wVi3uSbZw?=
 =?us-ascii?Q?+6rFhVJfQl8gL4hRYhSwjnRuiiQw/gip/SdfGdOVDZVm0pn+4eT+9UH5hXAY?=
 =?us-ascii?Q?5us1lZAKssR4t61qx9qlrzTMIxbMoTU6ZowzBqy7?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c590f3b-56d4-4cd0-c77d-08dae1965b13
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Dec 2022 07:55:11.5558
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fMYqsUi+nUS2iDUrGFCmo8YjwqzReHWb6FD6iwCmhNIzrvuEWD91xrRsETR8ucbhKl+dyltDEfortF6m6Z4xAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7641
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Steve Sistare <steven.sistare@oracle.com>
> Sent: Saturday, December 17, 2022 2:51 AM
>=20
> This is dead code.  Revert it.
>   commit 487ace134053 ("vfio/type1: implement notify callback")
>=20
> Signed-off-by: Steve Sistare <steven.sistare@oracle.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
