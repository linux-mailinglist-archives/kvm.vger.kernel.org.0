Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 258FB6ACD55
	for <lists+kvm@lfdr.de>; Mon,  6 Mar 2023 19:58:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230052AbjCFS6A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Mar 2023 13:58:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbjCFS5n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Mar 2023 13:57:43 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCEAA3527C;
        Mon,  6 Mar 2023 10:56:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678129013; x=1709665013;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=D85FeX9FuplasrqETNP7JxR6wMU8a+SvqDKCxhf5BO8=;
  b=OQx5YaOHjoddXzX0RsGMm9Yv0Xq+CuSEE3I/5GEbRo14yJj3bZw4QEZy
   Fe5b0XibNemJbDshSc9sVYErUPnvkwyJ1bSMGzUnISgKbiDYV+iCfUsOT
   oUxTz8U3+KLb8NXv0NPjlqJvM4cRLLU8WPOtPkgEhylyD+iEAJd+35n67
   McBuZB0ZNdAmtQbhwHQ/odR5TkRrk3zxbZ2oEUuy1Li+UXsZltBPwfayO
   ycTNmDpnH/jP47T/7WIheIh1gHOiQ7nyH7flE+S9ynRiZ101kd5/zVynQ
   eWZwxa7wwp2A+pqGIfHV86kAUlYdCIIZTyehLWdD85FJ+iV0aLVLMCmc0
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10641"; a="421920545"
X-IronPort-AV: E=Sophos;i="5.98,238,1673942400"; 
   d="scan'208";a="421920545"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2023 10:56:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10641"; a="653698648"
X-IronPort-AV: E=Sophos;i="5.98,238,1673942400"; 
   d="scan'208";a="653698648"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga006.jf.intel.com with ESMTP; 06 Mar 2023 10:56:26 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 6 Mar 2023 10:56:25 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Mon, 6 Mar 2023 10:56:25 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Mon, 6 Mar 2023 10:56:25 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dTJKOE92UeKRHLPKKUxs/vVuoNgigySlTXpCcLhyNJeeaxMd6H5TCLGOKmMTWDv73CqbeNGauQCP3RRS9lK6OCfmBHhjIb7i8hHlRq9aucEAjMK/4vHGiIucWboASgnMlTkydnM0zeKRKfmmJ+6AcrWDaiLIbWjSWIr9aipwXHmq+GhpQydOVuhZsy315Owbd/6rjJiIGi6o7yiA4nuB+zP3gT11E6BmmQ65USUGccfAuDTKFTMOMDQtDcV04eABNmijaIrBJw7DTpzizgh/tPohomiI4GBkDctAxwzigzRK+abZrMQsMF+Jt5kTQU362RntixdCeh5KjJpZW2+1xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LeWQUcPvGoxNOE2YR9Z09SJtvxo3jqlLeQEQXG68rrs=;
 b=iSRve801V8+/A7CpaaFszXXu6TFCpznRvvj0NVwJoy8eQWLzwlZ05ixknfOAbm6e1V7Zl3akUHNbSExT0xLzfasTfO7iCnc9ozwVUM1LQTwbZofPgfTi9QenCoNqHAv7J4HmUQqOzcPK//NvKiRUBQRuS+LF1JlirzasJvWFsql7839wq21rGc9TbwWtHybs/83z0DXFiq2KhXMB4sAUmx0twnipg19PWZU1b3JT7dnN/i0xyHcS+fbecrn7TY/r5NqEUIjLOrcNN9pvbHB3+Yskp4P0OAuS+UWqO0aEyHoPii3bxnegCRRTL8ZVIkV0v509ncZAlVc1fBTBRuahiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB6734.namprd11.prod.outlook.com (2603:10b6:806:25d::22)
 by CY5PR11MB6319.namprd11.prod.outlook.com (2603:10b6:930:3d::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.25; Mon, 6 Mar
 2023 18:56:22 +0000
Received: from SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::7576:1f4a:2a6c:72f7]) by SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::7576:1f4a:2a6c:72f7%2]) with mapi id 15.20.6156.027; Mon, 6 Mar 2023
 18:56:22 +0000
From:   "Li, Xin3" <xin3.li@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shankar, Ravi V" <ravi.v.shankar@intel.com>
Subject: RE: [PATCH v4 34/34] KVM: x86/vmx: execute "int $2" for NMI
 reinjection when FRED is enabled
Thread-Topic: [PATCH v4 34/34] KVM: x86/vmx: execute "int $2" for NMI
 reinjection when FRED is enabled
Thread-Index: AQHZTMtZdc3LQpOIUkm1svBil4qrLq7uFGwAgAAIeGA=
Date:   Mon, 6 Mar 2023 18:56:22 +0000
Message-ID: <SA1PR11MB67348F307555E2BA65D003D3A8B69@SA1PR11MB6734.namprd11.prod.outlook.com>
References: <20230302052511.1918-1-xin3.li@intel.com>
 <20230302052511.1918-35-xin3.li@intel.com> <ZAYstMn9mwPS5hOT@google.com>
In-Reply-To: <ZAYstMn9mwPS5hOT@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB6734:EE_|CY5PR11MB6319:EE_
x-ms-office365-filtering-correlation-id: 2610e99e-1d7a-41f8-e0fd-08db1e747a6e
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: U7GLxqaUf20LACrc6qDoF7BEoBBviMPzITRhd0G+aTKEKIEwAj8IWOm2Si2vk/i1DxH6h5JUoYwqy2AkT+b2VbpuMiapOe04JJ8D9Fan3jkigq/rZ0VgRU4aMS9wYWUkTDnrhyMrbJiJ2G29YxjqSqEtLDkUxfXbtOT2em/h7Apb14ptVNdY03Bdrxh/y70M50s4Jy7GnYxc7idBdtkmFiqgS6y8fG6a6xd1oviz4bzvAlvn7Dw9hP7w6iTtKI0yiewA3fJLPS+bj8aiZZBgXUGM0wd+zx3g1RDlBC4nhrykaB02u4waRyFVpe+0ZcsawwjoEhTI/2rTWdgK8kpyrpXlbdmf7kRCVxuuBaTSIveTwTdA65NEsPgR8VU9g404gOZgI16tsc1P/uOl1LD7qdncJ04MxJMysuv7zaLB0At/yCWfoe2DgEcSQytbrobTp3y5xMt0FyFnpFZNVaDGWoWWdyu+dELQSJ1yXTnDeG5qcOBhtBkrZtvJ9oMixGxyFiqGJVXp7ZNSI13kuvn6NmWRtNSgmx6Wb8rta8fSEH3uoqgkzEIAYVFE1FwDY6lA0XUHQwLfJMKkcq5qrypod+1XVRtQfxghdI7wQ+FSaZ5RSrhdQKmhDxdj/ayzeGEens4yXjvqkX+OQpo83dMGHz0nz1cbCpP0upTbpyOYsIgRse2WBqGtcz3Mh/SaymwU
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6734.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(346002)(39860400002)(396003)(366004)(136003)(451199018)(83380400001)(82960400001)(86362001)(55016003)(33656002)(38070700005)(38100700002)(122000001)(2906002)(54906003)(478600001)(7696005)(4744005)(966005)(7416002)(66476007)(8936002)(52536014)(41300700001)(64756008)(5660300002)(76116006)(66946007)(66556008)(6916009)(4326008)(8676002)(66446008)(316002)(186003)(6506007)(26005)(71200400001)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?0pcqLCh8xYQSTq3oWSV8tMtDWVDOa8sope19mlWmb3VQmBK/dwSnSUNKTVLR?=
 =?us-ascii?Q?UMX/TZ07+v9QlfBB8wBbD/vclETlUiVSkugfZq9S/fhyepfl+jO+4D7CtdSX?=
 =?us-ascii?Q?L2HrJiR1wI3iASFM4Iiy72qVTYPsiwTVS8E/p79/L4lTHARagpLRDtZ6zsRw?=
 =?us-ascii?Q?IeQDB3LNhCqo1nnXZhUgrura0ZjaOJheH9cxlcCXKPtdxDJW7lMgKNaeMaRJ?=
 =?us-ascii?Q?8gnSplRe1EDgACOHC/3JyYclKDdKRn0q/7W+8gPD+aD5RYXqRiweKRwwG9Y+?=
 =?us-ascii?Q?YS15mpAhOgtZizapXyXy/AQgUovqOdMBVcE4sFYEPyY526Mwt/hfuxodK4Sp?=
 =?us-ascii?Q?AYd0Xv6NVgkv6J9P4aVtIqQMMm5Q49zFZTjUisT/+38IQZ77NRB8tdmqYSPv?=
 =?us-ascii?Q?MwQJEM0RXUAis6OqokpzHelj7q7lIbphmRHYaRCyv+akr5TCDQmbKnhcC6VS?=
 =?us-ascii?Q?IroumAbJHq5fIDpLy3ic0YqtH3b/2B/jkIa0hfLQaJBZQAx3OIzqtSaV5dU6?=
 =?us-ascii?Q?ZeCSRk74qflz3QjLK+Al7ntyQJgTVP8HLiwNf7oTyOGfh4LXcTXpnpZ0ewTg?=
 =?us-ascii?Q?A/YQ40WejbK0WXlt+ZUKKc7be7gRh1KQAQ42XGwrRFih+7yZTg8skPugKk51?=
 =?us-ascii?Q?CDucIm+EMKRvv8/fVd/eVsNeDHMu2rVKVeVZPl75BSwCW5A7DDehUMJLJzxi?=
 =?us-ascii?Q?GSlUzzDNKyb+kFQrGG+w7UK4bhs0Jxi0O8iUaJXAEIe6amAmZ+eSBvQuzrgi?=
 =?us-ascii?Q?G81lMv4h+Rxfkdm3YY+IhiUc/qDpLZjidwJFULkfm6ydfaSEMAXzmZF07V5D?=
 =?us-ascii?Q?s8U5SwBRa1SDqG+9tDMqYNjXK3Kq619PVhXLkz8oLHN/nGCVKEY5cmzMU/Bo?=
 =?us-ascii?Q?w/EK7GpecB4S3tZmc89mcdTiAsip5JQgF0552Br6vPv/8ogb/sVMdWf63mT6?=
 =?us-ascii?Q?KSIezRH5kNapcxtoBiZirv5wj3EZkKGkoTNQxwYvJw89Jj4y3G5s3EsEYWVc?=
 =?us-ascii?Q?vF5dJZK5G8HYIgDfA2FCeupWMU2iaMIiUVDNgXSMOPNfzd/+xv0np/nsghvK?=
 =?us-ascii?Q?Gez25sV+w9478dkvHKSrTaaHnmz36psu/86KFGACV1/Qo0eQ5d4Ymasa/ch9?=
 =?us-ascii?Q?0vQyMh0vvKwjfIyy2G9nrg+auF8+0tHClo9h5tancGGToO4aQGyvYg2c9YME?=
 =?us-ascii?Q?ew46S6gCO9PFVeHEAgn/MYhwGHqzkJfiv+syCZbuvsiDlIDBNP24ZmySU2AW?=
 =?us-ascii?Q?PoIGc+aa4f+tTXpfIN/2vTrKTCvfgPN8BfOC5tp7FUbkfJpsLdQGhzaGDdo6?=
 =?us-ascii?Q?OoPSRO2/cLorShjZ3xS7gKlSmQB8JJZXrwzrY3/y5f/kow+OwSQuLj07Uy8j?=
 =?us-ascii?Q?jFpW08deYUiinwflx6puVEOSqrQV3tTs7Evz0k14gojoVXA3XAC6y1AfPOmW?=
 =?us-ascii?Q?Loel9aGBKWRR8aBTaWGrdyzprcKMJFJNqLysFfd79vwqb3zHs5gmfnnIwIrp?=
 =?us-ascii?Q?AkHSWduW6+7RBe4GsNGrhiP7bnWhrAPaoC37abOQwrg0ga19XmqWFyE+65Cz?=
 =?us-ascii?Q?5P11MkY1aXQIrY6VqLo=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6734.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2610e99e-1d7a-41f8-e0fd-08db1e747a6e
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Mar 2023 18:56:22.2027
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xQ/73XsRJ0XjEvLLco5xxSqMtc8z+JcGQ3CWwhp4jOJPtPniZsBMJScfdeP6n2nzrJchnyztK5RRmyPLmBnIXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6319
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > Execute "int $2" for NMI reinjection when FRED is enabled.
>=20
> This needs an explanation of _why_.  And as requested earlier[*], please =
avoid
> "reinjection" in this context.

W/ FRED, we use ERETS to unblock NMI when returning from a NMI handler
(Setting bit 28 of CS).  And there are 2 approaches to do it:
1) "int $2", let the h/w do the job for us.
2) create a FRED stack frame, and then jump to fred_entrypoint_kernel
in arch/x86/entry/entry_64_fred.S.

I prefer "INT $2", what is your opinion?

> [*] https://lore.kernel.org/all/Y20f8v9ObO+IPwU+@google.com
