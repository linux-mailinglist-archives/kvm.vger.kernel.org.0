Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 084161059E5
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2019 19:46:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726802AbfKUSp6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Nov 2019 13:45:58 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:62288 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726279AbfKUSp6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Nov 2019 13:45:58 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xALIjYYd025812;
        Thu, 21 Nov 2019 10:45:43 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=Ch07m4GGEE/Y7c9pS6KUdokHKD/JU8bNtx84vNDkFFE=;
 b=fQlIibgWJAAhbh4VIEJAbTfLFEoiPBeT8DdSWQU9WUG12itagazBeq4AC3hb+hzv4kiq
 d83aZTZMd5UpXRpADA7RJ4sSd4HMhO2C1i8O6CGe7WgoOgjvlPsgHRrdTAisrfmuh+6T
 Y3Yy/Z0uUhdniRIrIevSg1TGKnBGwt4g2Ts= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2wdxtm0f1v-10
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 21 Nov 2019 10:45:43 -0800
Received: from prn-hub02.TheFacebook.com (2620:10d:c081:35::126) by
 prn-hub03.TheFacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 21 Nov 2019 10:45:30 -0800
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Thu, 21 Nov 2019 10:45:30 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nAPOFdeh1UuZsL/JHcWtp3JhHbxlMNMyMmf2h4CNqrSFsVVBkGQGYj764JDgJPlwxnJxUDDXeBLC5dwy9x9Dx6wSlomxdN5PJo5Wlun/lvXaxyTVSPTzFmCi4QKBOz4Rmrv6VX5HFXEMq+S8ZpV+gC0ScLL083QwA0tcQQJ+TrZbqd13p8QsvHBcCuVsGSqAAgVyJcvHneArf6DQ0AmIBCejY2EOYfrX5aIdK1hqLx78hOL4moUU71qCmPo8B0hZCprNG8nhCi9H1ngyfpClFGlYZk+QwGMqmThU2XKst4XE9fay1ZVP0+UtV5ZQZ/8cnyAK0+pecsVXMYSqu+Q+gA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ch07m4GGEE/Y7c9pS6KUdokHKD/JU8bNtx84vNDkFFE=;
 b=Z3PRhFUBjJSP6cLTj+jES4tfTMJgPSehQt9S6L+Dqrsj1lWdc/6KrEsfv6EgfHBpITjtOIMTQGWRTWxhOpDGY/iY/C5Ia1Dn9XcUgRJc1OdLoogIxd9ABSXoJz4MY90U/Plg2Yb+CQgiBqd6uqfI/RCcc5h6fBkO26y+B39tkRG4NDYfj24lQvriqD10CfW+U65Ou7yBd49aZENK7lDsDlgn5tgO3Sm0BKw8HYHDc4kC0oGJNXNWzWBVlZYS8mh6FZ8s9FnjLMeRoKnYF6iwGi9iq+OoV4BoTaOiqGqJRq7wRpa9ohWXeSbwpH/XRCcDPB9FE7pgmj4vdjvhIOBZ7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ch07m4GGEE/Y7c9pS6KUdokHKD/JU8bNtx84vNDkFFE=;
 b=dRCuLcC13+VKVuagkD9SfBhqlFXBnpNIq2dSfkwXv5Q5nKEwgM1vUqjKAu0s065FVfAsaaCLHNoc5GcwrSw1bUQZOxL4ViOmAXqLSWk5ELsuFjnADDpOZKFnHJtsC/s5Fie0uFq+xYxvXK7gcWCWM3HqJm+U2LeLhEKztsYyxfI=
Received: from BYAPR15MB2631.namprd15.prod.outlook.com (20.179.156.24) by
 BYAPR15MB3191.namprd15.prod.outlook.com (20.179.57.81) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.30; Thu, 21 Nov 2019 18:45:29 +0000
Received: from BYAPR15MB2631.namprd15.prod.outlook.com
 ([fe80::fd23:27b9:7fe4:f4ac]) by BYAPR15MB2631.namprd15.prod.outlook.com
 ([fe80::fd23:27b9:7fe4:f4ac%3]) with mapi id 15.20.2474.019; Thu, 21 Nov 2019
 18:45:28 +0000
From:   Roman Gushchin <guro@fb.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
CC:     "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        Kernel Team <Kernel-team@fb.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "longman@redhat.com" <longman@redhat.com>,
        "shakeelb@google.com" <shakeelb@google.com>,
        "vdavydov.dev@gmail.com" <vdavydov.dev@gmail.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: WARNING bisected (was Re: [PATCH v7 08/10] mm: rework non-root
 kmem_cache lifecycle management)
Thread-Topic: WARNING bisected (was Re: [PATCH v7 08/10] mm: rework non-root
 kmem_cache lifecycle management)
Thread-Index: AQHVoF1eUJGIXl/jo02oA2+fhmBRU6eV2PaAgAAAgACAAB16AA==
Date:   Thu, 21 Nov 2019 18:45:28 +0000
Message-ID: <20191121184524.GA4758@localhost.localdomain>
References: <20190611231813.3148843-9-guro@fb.com>
 <20191121111739.3054-1-borntraeger@de.ibm.com>
 <20191121165807.GA201621@localhost.localdomain>
 <c6a2696b-6e35-de7c-8387-b21285b6776f@de.ibm.com>
In-Reply-To: <c6a2696b-6e35-de7c-8387-b21285b6776f@de.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR02CA0023.namprd02.prod.outlook.com
 (2603:10b6:300:4b::33) To BYAPR15MB2631.namprd15.prod.outlook.com
 (2603:10b6:a03:152::24)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::96fa]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: aa342e54-12dd-4fc8-9e70-08d76eb2fab7
x-ms-traffictypediagnostic: BYAPR15MB3191:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB3191B745BC9C9A8E5B4B5181BE4E0@BYAPR15MB3191.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0228DDDDD7
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(366004)(376002)(39860400002)(346002)(136003)(51234002)(199004)(189003)(66476007)(33656002)(86362001)(6916009)(316002)(6436002)(81166006)(9686003)(81156014)(52116002)(6512007)(102836004)(478600001)(229853002)(76176011)(6486002)(45080400002)(14454004)(54906003)(53546011)(7736002)(66446008)(7416002)(66946007)(66556008)(71190400001)(71200400001)(305945005)(99286004)(64756008)(386003)(4326008)(6506007)(1076003)(6116002)(46003)(8936002)(5660300002)(446003)(11346002)(8676002)(25786009)(2906002)(186003)(256004)(6246003)(14444005);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3191;H:BYAPR15MB2631.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zJIdUgny6Pd6lXnyiTvF+OUMff4MrZbZjq5sS3V9wb5dzcaNbp4E4X+ljiQSUumT8vk0uRAbcU//nBGYWso40WMipv5UjREofLGUzlikRuLbeV9P8FMNtIZ7ze+KMZwXowMV2+Mo4OdGDzNnPH5+Ski8Tq0BFjhKSs47/TmO7ST4Ftk1ryvrp08ZHPWD96z6FkX7nn5R/h0Tooe1HIFF5SFLxYp8Lp9geXKpDmnWSjkFlryrHddfAcMS1Zs0upac6+SYaY6zbxOVycz+cU8fxgQjNjUiw0AGt47tH4wQx+aRtjWNABB/tRr7xXRD63wQuxktxl3Z0h9bya9d67XIwnHYQXIDKXJp+D9K4zvh/UA04fAaFLXsTUIwF5SeQOWMwEVacFzv2zFkhIDGfN0VWJN7XaS1uo5jlV2bf1mLOFOcToJfV4gz5O8z3CdyCLTl3o0/GSgdiXalZT0W1bLBag==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <74B1471C480D364FBDA101CF7DF9CA99@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: aa342e54-12dd-4fc8-9e70-08d76eb2fab7
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2019 18:45:28.8054
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 69Ud54YE0DNOTCZETTFCqERlXCEJN4Jcllwu0zHwUxss14cIqAEZmU99FzOucwnA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3191
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-21_05:2019-11-21,2019-11-21 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0 mlxscore=0
 suspectscore=0 phishscore=0 priorityscore=1501 malwarescore=0
 impostorscore=0 bulkscore=0 lowpriorityscore=0 mlxlogscore=845
 clxscore=1015 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911210158
X-FB-Internal: deliver
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 21, 2019 at 05:59:54PM +0100, Christian Borntraeger wrote:
>=20
>=20
> On 21.11.19 17:58, Roman Gushchin wrote:
> > On Thu, Nov 21, 2019 at 12:17:39PM +0100, Christian Borntraeger wrote:
> >> Folks,
> >>
> >> I do get errors like the following when running a new testcase in our =
KVM CI.
> >> The test basically unloads kvm, reloads with with hpage=3D1 (enable hu=
ge page
> >> support for guests on s390) start a guest with libvirt and hugepages, =
shut the
> >> guest down and unload the kvm module.=20
> >>
> >> WARNING: CPU: 8 PID: 208 at lib/percpu-refcount.c:108 percpu_ref_exit+=
0x50/0x58
> >> Modules linked in: kvm(-) xt_CHECKSUM xt_MASQUERADE bonding xt_tcpudp =
ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 ipt_REJECT nf_reject_ipv4 xt_connt=
rack ip6table_na>
> >> CPU: 8 PID: 208 Comm: kworker/8:1 Not tainted 5.2.0+ #66
> >> Hardware name: IBM 2964 NC9 712 (LPAR)
> >> Workqueue: events sysfs_slab_remove_workfn
> >> Krnl PSW : 0704e00180000000 0000001529746850 (percpu_ref_exit+0x50/0x5=
8)
> >>            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:2 PM:0 RI:0 EA:=
3
> >> Krnl GPRS: 00000000ffff8808 0000001529746740 000003f4e30e8e18 00360081=
00000000
> >>            0000001f00000000 0035008100000000 0000001fb3573ab8 00000000=
00000000
> >>            0000001fbdb6de00 0000000000000000 0000001529f01328 0000001f=
b3573b00
> >>            0000001fbb27e000 0000001fbdb69300 000003e009263d00 000003e0=
09263cd0
> >> Krnl Code: 0000001529746842: f0a0000407fe        srp        4(11,%r0),=
2046,0
> >>            0000001529746848: 47000700            bc         0,1792
> >>           #000000152974684c: a7f40001            brc        15,1529746=
84e
> >>           >0000001529746850: a7f4fff2            brc        15,1529746=
834
> >>            0000001529746854: 0707                bcr        0,%r7
> >>            0000001529746856: 0707                bcr        0,%r7
> >>            0000001529746858: eb8ff0580024        stmg       %r8,%r15,8=
8(%r15)
> >>            000000152974685e: a738ffff            lhi        %r3,-1
> >> Call Trace:
> >> ([<000003e009263d00>] 0x3e009263d00)
> >>  [<00000015293252ea>] slab_kmem_cache_release+0x3a/0x70=20
> >>  [<0000001529b04882>] kobject_put+0xaa/0xe8=20
> >>  [<000000152918cf28>] process_one_work+0x1e8/0x428=20
> >>  [<000000152918d1b0>] worker_thread+0x48/0x460=20
> >>  [<00000015291942c6>] kthread+0x126/0x160=20
> >>  [<0000001529b22344>] ret_from_fork+0x28/0x30=20
> >>  [<0000001529b2234c>] kernel_thread_starter+0x0/0x10=20
> >> Last Breaking-Event-Address:
> >>  [<000000152974684c>] percpu_ref_exit+0x4c/0x58
> >> ---[ end trace b035e7da5788eb09 ]---
> >>
> >> I have bisected this to
> >> # first bad commit: [f0a3a24b532d9a7e56a33c5112b2a212ed6ec580] mm: mem=
cg/slab: rework non-root kmem_cache lifecycle management
> >>
> >> unmounting /sys/fs/cgroup/memory/ before the test makes the problem go=
 away so
> >> it really seems to be related to the new percpu-refs from this patch.
> >> =20
> >> Any ideas?
> >=20
> > Hello, Christian!
> >=20
> > It seems to be a race between releasing of the root kmem_cache (caused =
by rmmod)
> > and a memcg kmem_cache. Does delaying rmmod for say, a minute, "resolve=
" the
> > issue?
>=20
> Yes, rmmod has to be called directly after the guest shutdown to see the =
issue.
> See my 2nd mail.

I see. Do you know, which kmem_cache it is? If not, can you, please,
figure it out?

I tried to reproduce the issue, but wasn't successful so far. So I wonder
what can make your case special.

Thanks!
