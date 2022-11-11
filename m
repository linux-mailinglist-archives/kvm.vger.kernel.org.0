Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68CB562513E
	for <lists+kvm@lfdr.de>; Fri, 11 Nov 2022 04:04:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231802AbiKKDES (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Nov 2022 22:04:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231685AbiKKDEO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Nov 2022 22:04:14 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DA7E48777;
        Thu, 10 Nov 2022 19:04:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668135854; x=1699671854;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=GRXEf78bZ0payp2y9lAiI+ovSSORYQAuFyQxgGMWLuM=;
  b=IHD3Xcsmbc8eNV+oGzp6BBy26f49uMm9Y6pCqu+c7W/QdJrHilCzZnYU
   KQb0OtvWuTsBsgQ/F2rae79rFeYINFgz2JUt68ROh2gllqk88dx9SttoJ
   XydzF0FotkMvKhkbSbZJamkgGUZ/qgJ8ylQpDZCtG1J+1P12YG/b418Ih
   2SNyK9MliBMUtb9xLWIzaxchvuR4JqlVCH8FlEO0+ZIBCdMnNKqYutCkt
   TdECs1SXrZRssi5ytPet7WZbNGeBpymmIQpPVDVTrSygIIjV/B+r2O24F
   /24KJ5iZgZiN/A4o79Qj73rmdf8+DjCcyiyndBnP2kL0IXO5sPw4DxDYn
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10527"; a="310223184"
X-IronPort-AV: E=Sophos;i="5.96,155,1665471600"; 
   d="scan'208";a="310223184"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2022 19:03:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10527"; a="780026691"
X-IronPort-AV: E=Sophos;i="5.96,155,1665471600"; 
   d="scan'208";a="780026691"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga001.fm.intel.com with ESMTP; 10 Nov 2022 19:03:27 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 10 Nov 2022 19:03:27 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 10 Nov 2022 19:03:27 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 10 Nov 2022 19:03:27 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k15cLGqUSCcV44DN+/itVIeXrNr5mEqAHiUMC/AX1ESPMa5gzz8/LrUXGGJ+6QDD59bos7TfVyT5oyp3qxAIxmcpfFyPAYCzus7dWdtnUwFCy4Sz59ljwX6Z/zCK40T/H9IjvgzoLyd7O1k8UKilIbzeTWcMyjAycpeWOiPl8rhRIQYweon5dMCVPM0c1ZoE8S0efM1TCphxGzoScNHgXQyDwhDqwzofqAIjrnemBYiaJY0wJ5IKRrIm3I0GZNPVDnr4HOtdA7X9HoEse+9Sg5Ms1FWG1nnbzKTCBlrcYzY3B6iz4x7S1fqgUYI7Rh2eJLkl+ffKT409dRgFhzzhWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GRXEf78bZ0payp2y9lAiI+ovSSORYQAuFyQxgGMWLuM=;
 b=CKFjPt60G6WQinBPUc8CHC6bD+zNDo+ojd70ZTHglR+/2Uxq7NQ+VYJ+d08awnJQS5uPQcwdLDI7r/VFd47CyEg9/2mASqmPWJzVjMxFdIFMKPKOxiiN8zW5eUb2I7VuMYqbSu7OhitgNMWDYkyUyCh94hm0yp5wd0FSQ1IHywVJ4EZHeDc+6/KFYzxkxwQ0XdEjHvdB4YrTf47DjOngxve4qYGjEdi5+h57Ulx7T/6c2/9t2l9cIXFfsH6ja+eFJN2OamB80KctGpwkMODAoQnk2EtmO6mBfqCfOwWHwlx0L2vDELgm0NiLUsbjeUzAPcBvu2WWB0qPB2zCkLW+OA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN6PR1101MB2161.namprd11.prod.outlook.com
 (2603:10b6:405:52::15) by DS0PR11MB7262.namprd11.prod.outlook.com
 (2603:10b6:8:13c::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.27; Fri, 11 Nov
 2022 03:03:25 +0000
Received: from BN6PR1101MB2161.namprd11.prod.outlook.com
 ([fe80::40a1:5197:e1df:bb6c]) by BN6PR1101MB2161.namprd11.prod.outlook.com
 ([fe80::40a1:5197:e1df:bb6c%11]) with mapi id 15.20.5813.013; Fri, 11 Nov
 2022 03:03:23 +0000
From:   "Li, Xin3" <xin3.li@intel.com>
To:     Nathan Chancellor <nathan@kernel.org>
CC:     Peter Zijlstra <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "llvm@lists.linux.dev" <llvm@lists.linux.dev>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Kees Cook <keescook@chromium.org>
Subject: RE: [RESEND PATCH 2/6] x86/traps: add a system interrupt table for
 system interrupt dispatch
Thread-Topic: [RESEND PATCH 2/6] x86/traps: add a system interrupt table for
 system interrupt dispatch
Thread-Index: AQHY9M85Yu9uY6afW02HaiePlaJ2sq432uWAgAC2DaCAAAq8AIAADReAgAAaLxCAABbMgIAALlwQ
Date:   Fri, 11 Nov 2022 03:03:22 +0000
Message-ID: <BN6PR1101MB2161713681B883834D2A6B1FA8009@BN6PR1101MB2161.namprd11.prod.outlook.com>
References: <20221110061545.1531-1-xin3.li@intel.com>
 <20221110061545.1531-3-xin3.li@intel.com>
 <Y2y8obdYDXo9vlH/@hirez.programming.kicks-ass.net>
 <BN6PR1101MB21619E2092AFF048422C6311A8019@BN6PR1101MB2161.namprd11.prod.outlook.com>
 <BN6PR1101MB2161DDABE8095ADC95B8BC73A8019@BN6PR1101MB2161.namprd11.prod.outlook.com>
 <Y21pVXipq4lRiDMf@dev-arch.thelio-3990X>
 <BN6PR1101MB216109C51162ABB27C8AA735A8019@BN6PR1101MB2161.namprd11.prod.outlook.com>
 <Y22Sa9N7DU+JQoeQ@dev-arch.thelio-3990X>
In-Reply-To: <Y22Sa9N7DU+JQoeQ@dev-arch.thelio-3990X>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.6.500.17
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN6PR1101MB2161:EE_|DS0PR11MB7262:EE_
x-ms-office365-filtering-correlation-id: ba688f60-d6d4-447c-4c0b-08dac3914b73
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4QhttEKbm7cYDmY/vLB9HJLFOGQJtgt0/0qbSoOF6fNfFFTw2WaBmomPIxvFl8XUhdf4IFlCKS7QJW5PO9WbyfpJxIVjbpKqTzzExfIdW2t9F1KlOWZEj5ClkK6+8BPEWQVO+L+MXLge7cXU7n7p7LiYg1CuA6BStgoeu14uK3cT18YxChlH7xaPdBH54L0GwTrVYvOTBg0JsyCIVnyWtKEq8mNvB/VL2/69J1diTI7eWU0bhoEJD4dTg3TO2Df4PMAkt+QwwGGkZspla7VMJ1yYl3iSG9ZhiCvbcokxhmGlBCxr+LbzFzJ1hK+WYmJGWxbG4BcriIyqTx25g9FEhbnsVwwLcUtb2+D7NvK3nWXtLjfE/B82y8d/B0vYTNEijTKu4UOiEC1azJ7OK6wb6k4yoc7xicdqcGo4OazXf1sr/wwQM3KuNv6T8vzcReLA9VaGuafhlCx6+ng4M5E0b9bJSy+Gfc8M2PzUP5nj4I+UyLtm4jzciHq/2EfpQJHoa1QxkeB5car305k2RgojrVcGse6iVnwIMVvd/7GWeXMk4nFUJIKov7mk5gOarVVKNAzjBPeOLY2i81E6IsB8KQuClyq5QOi3HH8oKYWruUnNfms2x+gbJaI8sWAAe4/97vorJjDg4Q1vOaedxLY2SYFqA6M3AfPm5qJrYi8UgEBrSBb2oL1xuyf356cCiM92d6AFsQgEdyFtYXRBSbaxu8XbESkT+76EaBvzYMQAsn5FztU/wy9htiwaPp0uzz1CkHQPffa6h88nNgR8ZSz/sQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR1101MB2161.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(366004)(136003)(396003)(39860400002)(346002)(451199015)(5660300002)(4744005)(9686003)(7416002)(7696005)(6506007)(83380400001)(26005)(33656002)(186003)(478600001)(71200400001)(2906002)(8676002)(66476007)(66556008)(64756008)(41300700001)(76116006)(6916009)(38070700005)(122000001)(66446008)(316002)(52536014)(54906003)(86362001)(8936002)(38100700002)(82960400001)(66946007)(4326008)(55016003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?cnar5LpWb9fexgMBiAW9vE55/uIJOAIExg1FxnCRbPB8sThbRoouOu8C92wS?=
 =?us-ascii?Q?vhK544pZbxgDQqNMHtvxZQG5SFqRLr83qPDWD1y6U3/BsgqSyK7LOnjqGICT?=
 =?us-ascii?Q?WPq1zwaSImVUSEu2eV4n7CiQDvlPRFaEZJK0WpcC0b68qHn7pnBr+ieYdLLO?=
 =?us-ascii?Q?M7wgDIdpSsn6dYEd7frz1/yWhnqN2wYXxL5x6M+eS/KWYxw7EaONaCjkhGtx?=
 =?us-ascii?Q?38KrBDVue7OjQCtNkpK89JWJ82OKxvlJGnCVO9K9nW8lYLC4bYRvfU9IECnB?=
 =?us-ascii?Q?Q54BTsRGoVvFPfbsaovlN/POvokB40u5OlfRlLjqVALztGNTxz+hBEOePZf/?=
 =?us-ascii?Q?JzF+9orl3FjdVBy2xFhbpfWywseWfWHEzzh8J6lLGSURDCVhJZbdfQFOrpus?=
 =?us-ascii?Q?1nY8NkZscm5mQFZmMXm/3x6HdIq2eAKZ8cq55WQbqcLlLVWwZUMb8Y+VtUDk?=
 =?us-ascii?Q?T0w4qg2TOMJCGjabQJJYoL801HF664RJF/Yu7Oz9EgFEC1Uac4vzt0WfK6jn?=
 =?us-ascii?Q?ITjVREB9t9nf+niTv4Uk9a2nDU5XLCHM7MxnrHJB9spR8bJ0QXdBc7NNcTqI?=
 =?us-ascii?Q?A0FO4/F0vq6KdKrdg5rIXiSetuLd+KOP6mnJDA8Dl5UyeDDq1nfHt9I11RWb?=
 =?us-ascii?Q?divuEGudOEqaKZ/Ccg9GXoh5bqkj/vIL8eYsYsIQFBp5HeJk0wZfw0hGgv4B?=
 =?us-ascii?Q?tOjxMGLg5OoWN1ydUBuWVrZg4Ik9jWOWGf77CvuDSv18RdFnLsQ/rH0VcJji?=
 =?us-ascii?Q?b/rPXLlxMzJkDYjYRJf4jsD0TkSjJle33CqAEjRT2U5Jh3M1V1lE4N4m4mKQ?=
 =?us-ascii?Q?W60LfTSiXXrBB12M94mXgvZvZSieBAZYnSOmLt1El77MsvXCKdp07FJM6+zh?=
 =?us-ascii?Q?n7+AEKO9jvq8woolE7IFw+AKLi4VnWx6w2xRaOd7fAWuDN7FjHrplnEZNeLk?=
 =?us-ascii?Q?fAEKFr/CVPV3zmu/dpOB0g9Jiou6vkYSKDOjrz7AKlEVgMJa0ANbxzMoLIro?=
 =?us-ascii?Q?Oh8bzEqWrPuRksXifGTonK07pDNwUE6PhssHAr6TeY+iI34P/XwUFYljiAJa?=
 =?us-ascii?Q?yMmm5FHXbF9HDQStb6YutUJl758MN0XGbXJyyqCt2UgDUeAD95vkr2G64Fdl?=
 =?us-ascii?Q?BsQvPPxxl8rhXcDYLkKTaSweUdHy68DkJOyTJAfWnxd8lTA+nynAnAMlDM8+?=
 =?us-ascii?Q?+tHE42ZrULkkeTddI72ZqdJEqtlNM2cUAbRgE9QXewCFWsvbge2Ym87pn+Ki?=
 =?us-ascii?Q?X5wA4+AgmTr7c4b0n+2x9c0OMmT/xwWKXo5R2QP9JKwBFtwTinTBQbKiAVWK?=
 =?us-ascii?Q?GijYQ5GotBjySK7tGbdYsC8qz0RR9N1Uo1MvqMtwttHJnQa1yo755ILH3ZRp?=
 =?us-ascii?Q?+CxlDRRm1LXh7MM4+VJkohg5K6vB9bKGka7nzti3cMXc4uaLPJ7YVdcUQw60?=
 =?us-ascii?Q?keYrMp+wa+D/hNTLRki7kLRV7Qqpf84nlHcOuas2lkduEZLUYPf8LYL+0iEm?=
 =?us-ascii?Q?2ywG3JfQxNc0wmyERCg3LbWKBwHDt64T5iP1+fp65Xqc7k+qJ+OmJ64jkif7?=
 =?us-ascii?Q?CKKcm0BXcvfHqLGz4Uo=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR1101MB2161.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba688f60-d6d4-447c-4c0b-08dac3914b73
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Nov 2022 03:03:22.9555
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LscdlzNAQN4vJ07jOqrI2aLsvrjvUia6GvWm07XKXRyyrCcE0OmlNGXdtFHlreYBxGSKe3QLYBpwEOchgY6DvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7262
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > > Well, the entire point of the warning that you are disabling here is
> > > to catch potential CFI failures at compile time, rather than run
> > > time :)
> >
> > Oh, of course I didn't intend to be opposed to CFI.
>=20
> Oh, I apologize if I gave the impression that you were, I did not mean to=
 put
> words in your mouth! I was just giving additional context as to why we ha=
ve
> that warning enable and how we use it to help catch potential run time fa=
ilures
> at compile time, which does not require running CFI to keep CFI happy.

No, I don't feel impression at all :), maybe just a little bit upset that
I didn't realize it at the beginning.

I actually appreciate you provided additional context into this thread.
Xin
