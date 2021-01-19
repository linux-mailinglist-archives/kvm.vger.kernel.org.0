Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 660A72FC164
	for <lists+kvm@lfdr.de>; Tue, 19 Jan 2021 21:44:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729788AbhASUnN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jan 2021 15:43:13 -0500
Received: from mga06.intel.com ([134.134.136.31]:21693 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389866AbhASSut (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jan 2021 13:50:49 -0500
IronPort-SDR: BAXzdv8TmFb1NMwE5gmtPySjMwleFR1eQjw0cdjIr0jBINaQ/ECLpJv2Di1UGX8hk1c/Zuyz0e
 YJ3dJQMYrbVA==
X-IronPort-AV: E=McAfee;i="6000,8403,9869"; a="240518635"
X-IronPort-AV: E=Sophos;i="5.79,359,1602572400"; 
   d="scan'208";a="240518635"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2021 10:49:51 -0800
IronPort-SDR: wR2dxK2hRdjxNhe8Jqqta3FHkGhUjtdz1NQ6Fo7/Jd/mIyaBrKlULROkjJUJOFOiaXwwuRn1rp
 sI7IEPxkbWaA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,359,1602572400"; 
   d="scan'208";a="365961176"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by orsmga002.jf.intel.com with ESMTP; 19 Jan 2021 10:49:51 -0800
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 19 Jan 2021 10:49:50 -0800
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 19 Jan 2021 10:49:50 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 19 Jan 2021 10:49:50 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.103)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Tue, 19 Jan 2021 10:49:49 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PiubwsVl7s1offWRg6Wn2FelLqNT+QckPrm7WXFwUgEAWx10+B09pu4VS+wfInOEIuuFV2B8SI02dCova7Dsx2gvvn8lcnEV0BI5d1cOBW/TQiqoukBQfpBxK46ICxrwbIwDg9yGhBjzPsyhi3pn4XxxkvMmqRByuo5v3h4xcv2jS91La/RlYCyIoTPIEFrf6z9kRtjFtqkaoExMaUQK9t0qse69ZxF2cmUPn88X0juKFrolEBcPEfmZz9ybXUq2iqZKwAPWPz0QG3PHOTK8rhOTAKo//gkgbgzJUqGbT13qk7i2VHF7nnROsUOzSaKIaAy1qzWH4yLKPzRxp2R3eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VJ8zVAN1dZgUiEbOap1yGiuzxJIc6V8QfbgdLp5dmMA=;
 b=RvB5hfnf2NiYzTfwKvAgIE/DjVviuLV3ian20zBBs/P9nkm07bk0deMA82QjAoUBxpgE5/1nDHO8NvJSg2y47dMyTs8/V7xGNuiWRjYIp/o7jzh4jMbgF/afrcDv9JFad8q5n9Gny6FNi05Vhy1azwTAvMlgxM49wcyB/L/Vz5UHaEy+/pRxznCNTl+65tzF7wpOqQ3wQwp3r2Sn/l5/1QXlsbsH/Jy4wXLOoDj/IMWrJDmD5Cu24NEiUW9Z/BSZymnmsdXzw7xykWoos7aNgu+7JLH9LuZOI+cP9kSeqb3jtYVA44WyVwCAAY15m+Ayt2qkwxoxS73ecXi21YRqVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VJ8zVAN1dZgUiEbOap1yGiuzxJIc6V8QfbgdLp5dmMA=;
 b=lk5liFPG5+L2VdsbUdCfBJGhDl5O+9zGf7v+C5GpBdMNTQ6Sq+ABbf62ec1CUC3oy9eExTynuyjxxqIVvkYywa6IgUHfvEwleX6kPdOXwjXXF8GhdANQowIpkD8PSO+02Wrhc4leiZMjmjfWI+57XhFMUWe8GAOpNsd4+mkoVF0=
Received: from CO1PR11MB4849.namprd11.prod.outlook.com (2603:10b6:303:90::13)
 by MWHPR1101MB2109.namprd11.prod.outlook.com (2603:10b6:301:53::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9; Tue, 19 Jan
 2021 18:49:47 +0000
Received: from CO1PR11MB4849.namprd11.prod.outlook.com
 ([fe80::f598:e5a4:43da:794b]) by CO1PR11MB4849.namprd11.prod.outlook.com
 ([fe80::f598:e5a4:43da:794b%4]) with mapi id 15.20.3763.014; Tue, 19 Jan 2021
 18:49:47 +0000
From:   "Bae, Chang Seok" <chang.seok.bae@intel.com>
To:     Borislav Petkov <bp@suse.de>
CC:     Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, x86-ml <x86@kernel.org>,
        "Brown, Len" <len.brown@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        "Shankar, Ravi V" <ravi.v.shankar@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 04/21] x86/fpu/xstate: Modify context switch helpers to
 handle both static and dynamic buffers
Thread-Topic: [PATCH v3 04/21] x86/fpu/xstate: Modify context switch helpers
 to handle both static and dynamic buffers
Thread-Index: AQHW2UToyWho2se2FEue5rFVxEMKxaoozykAgAamAwA=
Date:   Tue, 19 Jan 2021 18:49:47 +0000
Message-ID: <A1A818AB-4F53-4462-8E7C-8D9ABEA18880@intel.com>
References: <20201223155717.19556-1-chang.seok.bae@intel.com>
 <20201223155717.19556-5-chang.seok.bae@intel.com>
 <20210115131802.GD11337@zn.tnic>
In-Reply-To: <20210115131802.GD11337@zn.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=intel.com;
x-originating-ip: [73.189.248.82]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 94f00541-460d-4ff0-7643-08d8bcaafed5
x-ms-traffictypediagnostic: MWHPR1101MB2109:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR1101MB21090929CE14CC012AE19B0DD8A30@MWHPR1101MB2109.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eyH/iyXZ2nLEC6ltPoeQBegADdX2lLc7VT6V+rfacbSK3KsV7fjeMQVXWdf+g+q/TuQKALpPTCZiifCWPdTt1Z1eWuPoGiA7Rw67ZcHJzkR9k5MoApRMGRq3CjRxa4HAds2XkEMTEK5meGsNWB4rYO/wh2OTQdHB+PA6AnEHqT4c1SY4QADeq/fOsKi7oa+cST0G9wWju5q/+SV4/HOcq4VOVygq3M6Zz12BGn3Yj2H4DlXj24b+UfLwfQNMUQJGCrv8OoGbzRDmtfgDbFFR0mkuIDZ7sYHV0JbBEpWR+gApik6ac/i3LHJgFaig4f69T8Fua8MvCshiVDrhBNd1ELSlOCalOoFFXK90+Okxkpb9cn4zPUA1UYfRMbN6djHhiesEgDUHtTIva0XJAfHuV2ic3AzhDzorx76oNyrX41oFCefN/+nJ8f5Cr5Rmd8A7
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4849.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(39860400002)(366004)(376002)(346002)(8676002)(53546011)(4326008)(36756003)(33656002)(6506007)(2616005)(6916009)(26005)(66476007)(478600001)(66556008)(66446008)(8936002)(66946007)(64756008)(6486002)(6512007)(316002)(5660300002)(76116006)(558084003)(71200400001)(2906002)(86362001)(54906003)(186003)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?SAEgaTexwUTVwv9HDWhA5XwOs2sy67NYhe7BMfnayLBtUnSloM7DNMk33G0u?=
 =?us-ascii?Q?aYW+KPd9VYTvdKRjPr+Q0f/H8kkcj+ULzCGn4QpLCW4TCyOA4Q+huUx/N+oq?=
 =?us-ascii?Q?j2R/q2+7uTuI/WwTv+aQU3vqz14de9mkxe8t+C3nRJxTBhXv7PjHBH3rmeKa?=
 =?us-ascii?Q?TE9u5k+HZL9ln5oD6K8k95/Z2E16h93j4fSi0zy5noOxnspGJSD0NofBgDa1?=
 =?us-ascii?Q?3uqiu4G708QaBL6JbMSkT/ieNfQu1D4bRwwtx1hoamBLro0NcHuBqAHFuGXg?=
 =?us-ascii?Q?oJqY4yLoEBtJfheOE/G0lSWpi0z/AiiY8y8QLfniC0q1aLvNGw3CAjtlzEJs?=
 =?us-ascii?Q?LCG+wXuUuGAND8rA8gCYZ5KSlFWR1CEOYg5nina3JuisXp2xn3B5FKkOEnO0?=
 =?us-ascii?Q?ydnrKv8qAaiQAqwQipXj1ZB5lgbVATkWmk/rIOJ8wK84GsZ9Pjemf1ugFyqx?=
 =?us-ascii?Q?uVSZnTsBBJzBrXeFB2Uzw7qRHU8Yr6dR8v5N7zdDWkCshBG1Yoj+BhelnAZ7?=
 =?us-ascii?Q?Cclr3ROLxxIVvjmSMzu2goKJJLTDfTvok8Odm+4gzbbaj3+k4g/d9xw+PLkZ?=
 =?us-ascii?Q?+5LRuPTMM4bFLb+RcFvXlJ35OhFswHdsFl9UjNOO0JvsKVIBcNOhXxzrcBiR?=
 =?us-ascii?Q?ibqD7xcOZIcEuAYaTgaJw0r7hvZLbPrzP5ubZPPBBH0fB8EK8aRpnLVYaM3o?=
 =?us-ascii?Q?9ehgDGatKMPU7MRgjdpeADcHEWpADGOvgu3YDRyxd1++ttNQXFDzxGHvxKWh?=
 =?us-ascii?Q?hflcbV9SnvAma2Nflbul5DfirG5s92JADUGzXqLwkb3X350kdwkL8Jt4s5YZ?=
 =?us-ascii?Q?+1OPTgZq5Ooip5thp9BM6oxN05hCbF5xfJhMuUX226o9DluH0WVf1vTH6SY3?=
 =?us-ascii?Q?04yCXZ9r7KVn4ZtbgZZLJQFvc1nX0b5bXHgy+9rjKkk6WKXAnU7OD8LOEIrC?=
 =?us-ascii?Q?UkK5JoEil7Hp29D9n3FUUPhYqTmdv/VY/uH+mTgQBoqOf3Z9uaIrZz/02k4e?=
 =?us-ascii?Q?cMVjq3cYcyDyTiMsHDI8nf84CEDrl7wCbEFrfpkNK6X/HoTZ/qDtGNx5UG/W?=
 =?us-ascii?Q?0LuVDLbbTqPheYEG1v+g5MmDlExppQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <636A5A48AD0B294EBB2231356FA0E0FD@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4849.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94f00541-460d-4ff0-7643-08d8bcaafed5
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jan 2021 18:49:47.6360
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +wrjBCOYzHylwiUZM1jFHNm9Ud8D/h2t35jHJLHg0JXo6sMLxjdq4hoRYc6MOJPV5z/AIStIweCmeV9OA8+B006Iy+W4wgaocDH6iB05qXk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1101MB2109
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Jan 15, 2021, at 05:18, Borislav Petkov <bp@suse.de> wrote:
>=20
> What I would've written is:
>=20
> "Have all functions handling FPU state take a struct fpu * pointer in
> preparation for dynamic state buffer support."
>=20
> Plain and simple.

Thank you. I will apply this on my next revision.

Chang
