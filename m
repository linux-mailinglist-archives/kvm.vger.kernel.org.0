Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 407E531D0D6
	for <lists+kvm@lfdr.de>; Tue, 16 Feb 2021 20:19:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230391AbhBPTSv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Feb 2021 14:18:51 -0500
Received: from mail-dm6nam11on2040.outbound.protection.outlook.com ([40.107.223.40]:17089
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230225AbhBPTSs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Feb 2021 14:18:48 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cUcCvkj/p/pc+k+FB1NOm4UrrGQ1dIsxVClkCADAqOvjAj4bziB1OvNsH4dVCN63wiRQ/DLV4bbRxvD2/VMkrDqFI51tLRh9Myomol7efl02/1CjTlN5NvZSWqapWcZRimuKtJ99n6Leikee4KyRTdJTbg6KtRiAVpLvmZAkEMcOsfWh8B6+sR1cPCSuQ7m8T3ANQAmJqOxNxmxsPaOXtGqwIddMdjt4aZ9vX4yO1CZu0cUg0zMsl+Id0hyxmwKfPeV3HlAIddhUMUmamX0Fn8b91H5/kPD3K33d8w7th7Bj3nOtRteTH8D+/izogjY4o9x4r7QKw1e5iCyWz2maCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jWIVzoNz7KPULPlDSYoUIXf7hWoOx4E1oEeVSH8mL5s=;
 b=Lmva3OZfnpTwL6GBRoQyFWiU72yyx9kOXvd1FZH9hGOMgIj9g3Uwp328PLyA6FGKJbI41pmTNtukK/9s7r8mTlXx5/7hXqqjAPmVPyKf/u6Vy9AR4oXSyRq7/7OyTlg/Z9iyOSSbHGIuWXS9CNdirMJtdLi3dYT5NPlYwd++tYqQysz1bTbuo3oxoIcmOKSAbmyHcj1+uX4NryKRCRy6raXK3qp0gCJ2h9K53oQJ4jA76pG6Jo5iVW1+bKnUCL2AnRRJvYHlDxcRk2KULyRrBasJdYI7aqntz2Sgd9aHOF0sdxhuUu1JeaAacST9BWbjvr06LtvHutTF1RzuSlfZbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jWIVzoNz7KPULPlDSYoUIXf7hWoOx4E1oEeVSH8mL5s=;
 b=R9BZir0A3CZetCVcQw+Ja7Y8mbvE/qrLupBhwaWV7JJjYvqeQxwAAs3fnowgXBPmBUWM/2W3NYhrMSphlLGG75Q68UtBa2Mv69x1zJfRKKD4L3C68AzRJcgxS9G4UEhc0erynJtON7Sqn/MSsBYrbc1Uchg/6ItqCvwtbcKLRks=
Received: from BYAPR05MB4776.namprd05.prod.outlook.com (2603:10b6:a03:4a::18)
 by BY3PR05MB8083.namprd05.prod.outlook.com (2603:10b6:a03:36e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.11; Tue, 16 Feb
 2021 19:17:55 +0000
Received: from BYAPR05MB4776.namprd05.prod.outlook.com
 ([fe80::ddba:e1e9:fde7:3b31]) by BYAPR05MB4776.namprd05.prod.outlook.com
 ([fe80::ddba:e1e9:fde7:3b31%3]) with mapi id 15.20.3846.039; Tue, 16 Feb 2021
 19:17:55 +0000
From:   Nadav Amit <namit@vmware.com>
To:     Peter Zijlstra <peterz@infradead.org>
CC:     Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Sasha Levin <sashal@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        X86 ML <x86@kernel.org>, Juergen Gross <jgross@suse.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        KVM <kvm@vger.kernel.org>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        Michael Kelley <mikelley@microsoft.com>
Subject: Re: [PATCH v5 4/8] x86/mm/tlb: Flush remote and local TLBs
 concurrently
Thread-Topic: [PATCH v5 4/8] x86/mm/tlb: Flush remote and local TLBs
 concurrently
Thread-Index: AQHXBFzuDk/+97dVSEa5i3JTefGxeKpbKCAA
Date:   Tue, 16 Feb 2021 19:17:54 +0000
Message-ID: <AFA552C0-88B1-4D58-B3C5-1A571DBF0EA6@vmware.com>
References: <20210209221653.614098-1-namit@vmware.com>
 <20210209221653.614098-5-namit@vmware.com>
 <YCu2MQFdV4JTrUQb@hirez.programming.kicks-ass.net>
In-Reply-To: <YCu2MQFdV4JTrUQb@hirez.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=none action=none header.from=vmware.com;
x-originating-ip: [24.6.216.183]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8d0a60f0-c67d-4e85-3a49-08d8d2af9010
x-ms-traffictypediagnostic: BY3PR05MB8083:
x-microsoft-antispam-prvs: <BY3PR05MB8083829349529D99571540C2D0879@BY3PR05MB8083.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LPbUNtFBn0N04M5Lm1C3N0zrODoag8LRvwSmI5RqGwf1xyR8CgukS91tO8L/m0b3nYZ6QhlPgMXJvHuMNZn3RQdQG8yg4vumbtgl5LsTzw+qlnczlC4GTBRkIbWV4JrUjK/h2vD2VnP1rMtqOqqYSACd32YkR0b9sKUVsJm1YofFd6VDsPPCWB9INz6erPh/Ht00pn3yU0l7DrwaIzN0Lu/Iu2WAcSbL+fnfMyY7ikovSjj03trUGYRiJcxWMTdiX7fIJn30ryMX6VLLdAKcKEz/IPpfnEh61B+SwaUEEBUGLsfu4nyAWb4YgcjZRAP1si7KKjaqv6q/gtzz5r9IHvLaJjd4QIr82803pOylR9vyF3ehkSipoyu/H9iKe/Cdbf7tVI4HYm4Sp5i3pT+8jOnlLyHXyax9ytawwIhBmuQh6AJssDyJNsimjb22KHM6ckNEjvD/j050Hd261/ppZw8DRCtNWPjKfnucdF+/3z3pt2lllHIAjR2vXrD6WENCpPvMR3EaiTixuN48ZoYhb49YNZGkugoNSwheN2V1F64DDjg83NV/52pHQM7ss2aEou6iSote3Z+pky8VysyH+A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR05MB4776.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(39860400002)(376002)(136003)(396003)(5660300002)(33656002)(4326008)(6512007)(6486002)(53546011)(478600001)(66946007)(8936002)(2906002)(54906003)(86362001)(83380400001)(316002)(66446008)(186003)(66476007)(66556008)(76116006)(26005)(71200400001)(36756003)(7416002)(2616005)(6916009)(8676002)(64756008)(6506007)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?fyNbfqSd9ANotjCBaT4ktWFbtGRkNLuUxd1+oQ/DB+m87EmQFbfMxnm2cp+i?=
 =?us-ascii?Q?iM5ozZR5UUJ/OZafBBMcBXa6sqcUtT7+GRC5YnxBQnx2zLH6a+cbLjfeVSTT?=
 =?us-ascii?Q?SQEAfxa/hxr+mvee9M2qM1y/ca56f+I1wgWVF1aZvrCFIQ3GNZNcjWw70/gr?=
 =?us-ascii?Q?Y5f24d5dvrt22Qhz/XC9Pt8BqkR9mLOGDFxvN/ROfnk7lqkscAmMeqtJ8iCd?=
 =?us-ascii?Q?Hlv/cE7tqGlELWkCkjpEZ/hzKpMVPtE63ID7IHlMiIdRAAyU1baBowig2qpi?=
 =?us-ascii?Q?benTkh4oFrj4I61f2zpDqZj/2WbBhs+jfT6xwDHfb3SFLqi8BmDZrZeuxvkd?=
 =?us-ascii?Q?g/NYuJ6KWoTP3kMH6jZYKnoiKpRq6ZPuS7saqUvj+p5zLSt3fSdNzaaYSP7+?=
 =?us-ascii?Q?IgIj31Wi05yZEpfNNDaoqRGJEEBeE0tUVbjvMCORdzx39kzDbwhdq8KLN1aa?=
 =?us-ascii?Q?r/VuRW2HtLN9sneLkCRWh7vFL7Yx/923YXuWNkxRAZ+cvY3Dhq45HHDzdUg5?=
 =?us-ascii?Q?QH6gB6gddZQjJ9AVuGjLQsJzCJfnUj3jRJseN+pcbWdb8FYlJARvO0d/OpUL?=
 =?us-ascii?Q?0cMgZ7mToS8GrRLZKaodp6DvCIpvLZQ4saXcHkbd49RRk8wDKNw3SqL7+ZCz?=
 =?us-ascii?Q?IEAHl8kPzFQY75I7kkxYISxXFccwBhuNTCJhkaVCsbdUXkvbfrQdGkYS67Qf?=
 =?us-ascii?Q?3RLnJ1Z3Yd0ES8q80OlRKiVHHkLiX7mjvRmkI+gt3U8xk3RzUoQIWBi9vzhp?=
 =?us-ascii?Q?26ugbP9cWt5k+JZ5bpvbfDW3CwDsMJRN/5wdpLPsBfG/le3U9kXRWG3jpfTn?=
 =?us-ascii?Q?n5EVMctzKXjEK73qf9VtfAd0W3pecmu8x0w9bZ/1FZsi1g/czrJ4xX6q8yME?=
 =?us-ascii?Q?riZF0aFcqY+hOonx37uKBYI/0tCf3GUd66Ib4DvDpSlqO+EVc2EhkKRYhVqX?=
 =?us-ascii?Q?5Eu88EoeK5OmWfxgCv8zT/YUhQEu8UPVzrI9UEoPC8eKwx6MCXRfvgJNNi3P?=
 =?us-ascii?Q?UTWJCc4KqFJWkaVvjOJY8OfqGjB1Z921aDk26pGyS2Ai0/EQFwcOx2GoSdnT?=
 =?us-ascii?Q?zt32ET24WlMzSz9vYz39fmOQUM+Vn3ftnJUW9i3uuIV808DiBhD0JnyAsJoU?=
 =?us-ascii?Q?TEcDqdJ1QFvWT6yG0uD1ogBw7nfn5eMbBxBp6gtHaOy8sIboedzkV1nZel+a?=
 =?us-ascii?Q?wPGRu8YP61h7t32vVTsHIM7EW1PHD4QYh89z0jUc5NfyU106Z6MGxKhK3IGO?=
 =?us-ascii?Q?jRRUlGtxkFpULb+0Ltk9EO86BIdYRpV6FijKxAUpTPx2ur73S+Nk9tpUWJsJ?=
 =?us-ascii?Q?n7gtPRmstlastTmA2XYCAGyL?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9390762EDE2D8D4786E55865DEDAE795@namprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR05MB4776.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d0a60f0-c67d-4e85-3a49-08d8d2af9010
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Feb 2021 19:17:54.9690
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SKPOxAghkr3M152dfPKEi0yLDWpx04TQBHLmVJW8qpd/dObjW4As10/cLm99NXak6CNWCIRfDRVTBzg4MqdH1A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR05MB8083
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Feb 16, 2021, at 4:10 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>=20
> On Tue, Feb 09, 2021 at 02:16:49PM -0800, Nadav Amit wrote:
>> @@ -816,8 +821,8 @@ STATIC_NOPV void native_flush_tlb_others(const struc=
t cpumask *cpumask,
>> 	 * doing a speculative memory access.
>> 	 */
>> 	if (info->freed_tables) {
>> -		smp_call_function_many(cpumask, flush_tlb_func,
>> -			       (void *)info, 1);
>> +		on_each_cpu_cond_mask(NULL, flush_tlb_func, (void *)info, true,
>> +				      cpumask);
>> 	} else {
>> 		/*
>> 		 * Although we could have used on_each_cpu_cond_mask(),
>> @@ -844,14 +849,15 @@ STATIC_NOPV void native_flush_tlb_others(const str=
uct cpumask *cpumask,
>> 			if (tlb_is_not_lazy(cpu))
>> 				__cpumask_set_cpu(cpu, cond_cpumask);
>> 		}
>> -		smp_call_function_many(cond_cpumask, flush_tlb_func, (void *)info, 1)=
;
>> +		on_each_cpu_cond_mask(NULL, flush_tlb_func, (void *)info, true,
>> +				      cpumask);
>> 	}
>> }
>=20
> Surely on_each_cpu_mask() is more appropriate? There the compiler can do
> the NULL propagation because it's on the same TU.
>=20
> --- a/arch/x86/mm/tlb.c
> +++ b/arch/x86/mm/tlb.c
> @@ -821,8 +821,7 @@ STATIC_NOPV void native_flush_tlb_multi(
> 	 * doing a speculative memory access.
> 	 */
> 	if (info->freed_tables) {
> -		on_each_cpu_cond_mask(NULL, flush_tlb_func, (void *)info, true,
> -				      cpumask);
> +		on_each_cpu_mask(cpumask, flush_tlb_func, (void *)info, true);
> 	} else {
> 		/*
> 		 * Although we could have used on_each_cpu_cond_mask(),
> @@ -849,8 +848,7 @@ STATIC_NOPV void native_flush_tlb_multi(
> 			if (tlb_is_not_lazy(cpu))
> 				__cpumask_set_cpu(cpu, cond_cpumask);
> 		}
> -		on_each_cpu_cond_mask(NULL, flush_tlb_func, (void *)info, true,
> -				      cpumask);
> +		on_each_cpu_mask(cpumask, flush_tlb_func, (void *)info, true);
> 	}
> }

Indeed, and there is actually an additional bug - I used cpumask in the
second on_each_cpu_cond_mask() instead of cond_cpumask.

