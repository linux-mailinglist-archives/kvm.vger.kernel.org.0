Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 046C465084B
	for <lists+kvm@lfdr.de>; Mon, 19 Dec 2022 08:59:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231520AbiLSH7U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Dec 2022 02:59:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231425AbiLSH7K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Dec 2022 02:59:10 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B863BC2E
        for <kvm@vger.kernel.org>; Sun, 18 Dec 2022 23:59:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671436749; x=1702972749;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=kBL8B6Pzdqd/Rbiqdmvq8faBNQLkZVMrcfQv6l3KlRA=;
  b=SHEZYCLo+xHRQ1R+ABWxh9vnAtGGzPN+LQSDw6HA76aoDEGGImNu+dcg
   6OqayeR1qunLJLQUgExl0ETA5QDw+FrYUa7bA0v15mGLmYx0Bi+n2T6Jq
   iLGNZuR1l5d6/ULDj9sEg2TsxNnA2t8FzQxOU4OwPRJ5CbL9Og7p6I5OH
   BPB+aSxToMzh+93HBG0+019I1zrsl+ROsBHitNQoIkfyXLnvWUw9YETmC
   tJs24J3cf5Xx9EcJPiQaj+MEiTfeap2pXYKMAVqYNOsEUQLmp8S8SZi3q
   zt5mni6gsDZ2Pz6GKpENFfC0z2SxesOGfyIFF8E9OhLFqu11P+iVY0Og3
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10565"; a="302716545"
X-IronPort-AV: E=Sophos;i="5.96,255,1665471600"; 
   d="scan'208";a="302716545"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Dec 2022 23:58:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10565"; a="824756605"
X-IronPort-AV: E=Sophos;i="5.96,255,1665471600"; 
   d="scan'208";a="824756605"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga005.jf.intel.com with ESMTP; 18 Dec 2022 23:51:40 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sun, 18 Dec 2022 23:51:40 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Sun, 18 Dec 2022 23:51:40 -0800
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Sun, 18 Dec 2022 23:51:38 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WdDraGwTL+LRy+kc38G0xK3Y7lk8Y8uwpkXhzbaUzM9LlkJZLKERJ3gegGDUhkp6d1zJ+82lyOCj8icLz2Lbyc0t6WMOknJ7vbWF1VnG+biszEXXEbBqYugWGyZPrDxiZC+ipNtAd7RCq3l2ZI2T01+TiQ79faz3NmuGIOPrAi3Pe5yLmNPpDcgpMDjk43A/BNPu1tUXfL6gaA9AQ+G8KoqK1FnAy0wcu8XCznxC963ZbG+InjQfy+C9gxBsgolGIA1ch1jOvFL0dsD+DsyNAJI7qstsH8CLbvg15Paq0agGqqIxxs111pZUQ28aLj5X/Zum6Jp+WHHbh/R+lhLMgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fc/oaCLS0yPxttiWEiFmdpTCb/IaSSIdWW+Bi1Hl/QA=;
 b=SlWfu8UJow28Zu4UbhXjPedqSX5cl79U3B9XE2XYqoT2ZjWbAkPWNvvDYKtDs6S47ESEmgO33ITbhbvTAhASyKl687AIdxAzVkCN1dMOXshNGZKPcbwzEwbhFA8ngrsO7BhnhoCcwf4MPP3V7L1OT2QHznai9wpACib5tATtdnDjuLn3CleGdwMfGkK5txorIO+d9r98Q8YsUL4eW4ODAVZ3n2N4UpQI6nB4jYeQitQXQeyg3RYIWTh+K5emeC/CvbFMs5r/0NJbioGeOuTGfA6rPdaXd6GAFHgLw0B6UgVCrV6CQHa7Rin3rJ85TmUF7TUaNyjEoh4iDrV9bSgWzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by PH7PR11MB7551.namprd11.prod.outlook.com (2603:10b6:510:27c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Mon, 19 Dec
 2022 07:51:36 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::8032:d755:9eed:e809]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::8032:d755:9eed:e809%4]) with mapi id 15.20.5924.016; Mon, 19 Dec 2022
 07:51:36 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Steve Sistare <steven.sistare@oracle.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: RE: [PATCH V6 3/7] vfio/type1: track locked_vm per dma
Thread-Topic: [PATCH V6 3/7] vfio/type1: track locked_vm per dma
Thread-Index: AQHZEX9RKu5d5T+k60Go8gdiIH6ata502b8g
Date:   Mon, 19 Dec 2022 07:51:36 +0000
Message-ID: <BN9PR11MB527679E54B7783B9DEED9D418CE59@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <1671216640-157935-1-git-send-email-steven.sistare@oracle.com>
 <1671216640-157935-4-git-send-email-steven.sistare@oracle.com>
In-Reply-To: <1671216640-157935-4-git-send-email-steven.sistare@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|PH7PR11MB7551:EE_
x-ms-office365-filtering-correlation-id: ee7e31c6-df57-4499-0f4b-08dae195db0c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: N14wHixRekPpimyWj+QM7D+mfpen/hiVxpuD3dpnoYs4udhdcnVf1ByqpCn9tOe9XzliOsxOJFcWXRf8gcuIP0zVGVuifHF5VNMPhQiixoIckRSlA9RxbVRlF19l/UPPJRMgWHRCnhzYYPBpwz22yaVAZhdNtf8HeCa4evc5K5+8u02Fr9LqSJZGRS4fSxbP3XtPvYg+vj0ZMXFS2ZDDBwqDH6JbHhFjUVRsTPhdxkAHouo1Jd/iw1+8cPjFapYOivyKsFqB0V9sWHc9H0sG07SGEhk6M3TxjrvDRnnKt5SOb5TzRMml2L5UPPio2irUtcPey+gq/VsOEMjsqfBxsIvBlkeyOCfRELZ+qb08UAYAbx73GoYf7N9y0UGypZ4tdl6WkmNCYNbXyCAXmP43MyHDwIxL47ltg9GCudRTFXl1BHt6qL0rwKqhjxH2NJQtoafFp2FI1u7MuR6iR3+/mpa30GP4JeeOya/G/Hdi8KeFYDtVurPcapL7YYIL7I5INxgD27ZXSnQ/CP3ucI+aH3/g4G9DYHYGAgCj0P8YIyWmV9sH7ahFV9ZVY4eWuxMzvD9cpAzwtS8AUFyvhAZgLeClG184I2bQkKxF6ttuPQ5ZNJduiVIusSERZHNnxV2UioYjm8u+m+0zyRM0Fq1I+4Ki/ZT87sLzzmlDvT9WcsrKwFqI8lZZFroGSk8jDe2wccZB5iJ0/iznlVRF5Xh9iQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(136003)(366004)(376002)(346002)(451199015)(83380400001)(86362001)(55016003)(33656002)(122000001)(82960400001)(38100700002)(8936002)(316002)(38070700005)(54906003)(110136005)(64756008)(66476007)(2906002)(66446008)(76116006)(66556008)(66946007)(52536014)(8676002)(5660300002)(4326008)(4744005)(26005)(9686003)(41300700001)(7696005)(186003)(71200400001)(6506007)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?EUL7ehMMMhQt7CYEB18o/uD4w7Vr7eSez6v5dWkqlqgPbYNgjKDEOubS5l12?=
 =?us-ascii?Q?SydVkGE+SIbtjA9Etr6HtMc1KvL5AJ/yDVF/VAv7nkyDGWArvUOkAeMui5UJ?=
 =?us-ascii?Q?xkrHSiU7FtBR4Nxk3KaHFfT2LaRLYXV56YDt7nFgucJKYVrX6SHKckDg51eL?=
 =?us-ascii?Q?uPixI+LJyBs6VR02ULv9emvOo7+HOSMC7sfQ/Xc+y59E9SL4IsapCkK/hw5N?=
 =?us-ascii?Q?q8J1E9aRiWK0kz0sXzX7ebopcfCkrrg9NMrpLcTMbdpJp3EtopFw4nAPDCcA?=
 =?us-ascii?Q?wKvc2ubpo8Z/JUIIdMoViIS/jVQpzIKqGKeoYGEKkZoDW18V41jTaZmuAYVE?=
 =?us-ascii?Q?aShh39enQ49zHZ17cEqKOCBdoRz+ejX48Axzr9U0+aeApirCVEV82xsm0roE?=
 =?us-ascii?Q?AEEU7oNGWXuie/2v2iagahzI6TQWillYnmaIh0PWIETfvRax8vBr6rS1yMts?=
 =?us-ascii?Q?DvJ9+f4N4GXLSHz7ia8TPmA10EBiu240aUAcZfqj6PYb4A/Xo1SnGpEZyGIO?=
 =?us-ascii?Q?9DKke5PuVtyt5S3PzFG9eSsub56FvxzQtfRDhVfw1vDsVkjBf/Fur3B5kkT2?=
 =?us-ascii?Q?q/BeNKIWafHL3TjBXg3sBjwfu2KwhwtTok1z5LetSPtMN7Tf4HuxMQMmb8nc?=
 =?us-ascii?Q?+iClFz93z9pHRXEmMIio5fJSTuAfRdJZzgmhpnhzY4KP9uNYgqzW4OimJ2eE?=
 =?us-ascii?Q?zbYrbaccp4YGUty9YPNanbUXbu2Xx2uNtPyBVkyXjT0cs5XyImRe5anPIXku?=
 =?us-ascii?Q?aOz95FOrPJY+7iK6nC72kTLt9RbC7+tTjHLJ4K1/vMaowSZGGO9rPzHLlCPA?=
 =?us-ascii?Q?kiV4fenmGuz2rDSv1wUOLSBtEUhf61FdFXPT0x4OymTuUbmcoHwdXTfYXqBL?=
 =?us-ascii?Q?4NrILTUNf3Gh8+/jR4K1ufPpDeBMPQVJQU4U7uEejz/U4kw8/NYOXT9s6upi?=
 =?us-ascii?Q?+1BtSLElMLJapUQo2bQnnRLWcbViul1WsiwxNrVo2PGXWPHOqa7xLkjFmTlq?=
 =?us-ascii?Q?dYM0jtb3IIjBUoaJfKJ8fmJNBXqfhNcVQBjQnlzgg5QW6nagwdttknKGGXOa?=
 =?us-ascii?Q?5ZSJD+a4OMeHuzAbxRIQocVj4jVfV8Ykgaz8naMdC7+7VSrnYu7Ygr1pXI5O?=
 =?us-ascii?Q?+WS/CXkJBhMJwoWL6XWqpQONW6jj7Od+5shlyd5YO/+JoKUB0gNFnFDqmLNP?=
 =?us-ascii?Q?7B5DH7TUn88e7e/I6hS479muTSVKlJQDcXU4PpJ682mLHvU6f6XMi9xDU6Sd?=
 =?us-ascii?Q?bbrFDhQqPHAJAzGIoeV6u9euPKMl5VT+PS9iuIScShtz3dq1AmHMEX3AtjeD?=
 =?us-ascii?Q?cDDXskDdcHXJ0Wf2PHJKMvsqbFGATUZ/YN9OkVzybEMWjaT7Pop+R9OqUDGN?=
 =?us-ascii?Q?/fgHOiLb1FaMi4+i+MfKLw+UF4QzKDGqp8NW8VciiqL0tjGpIDeNujsoxNUU?=
 =?us-ascii?Q?9K8FuvKZOGHm51BgGYUxbm9l5QjvrT4rjYo08RHe5drCVX5EeVODoVYx7K0f?=
 =?us-ascii?Q?TGRHR7hPj6xgforxaw6Bpx6N6MQIwrytowXKYeL5rfrYIvqHDPZD6UFY9sPu?=
 =?us-ascii?Q?UG7dkvJyz8MQ9aannh5tfwpKIiCO3+o+J7vpRJ+X?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee7e31c6-df57-4499-0f4b-08dae195db0c
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Dec 2022 07:51:36.7254
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: el18kvUFx8NyzFOqAKJ0/35Ef5IxQ4oGZaZg1g++y3WvcFyodYO3kB3P19Tq3D7WNKanHYkcKNjx6+XsSq9YPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7551
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Steve Sistare <steven.sistare@oracle.com>
> Sent: Saturday, December 17, 2022 2:51 AM
>=20
> Track locked_vm per dma struct, and create a new subroutine, both for use
> in a subsequent patch.  No functional change.
>=20
> Fixes: c3cbab24db38 ("vfio/type1: implement interfaces to update vaddr")
> Cc: stable@vger.kernel.org
> Signed-off-by: Steve Sistare <steven.sistare@oracle.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>, with one nit:
=20
> -static int vfio_lock_acct(struct vfio_dma *dma, long npage, bool async)
> +static int task_lock_acct(struct task_struct *task, struct mm_struct *mm=
,
> +			  bool lock_cap, long npage, bool async)

is it more accurate to call it mm_lock_acct() given almost all invocations
in this function are around mm?
