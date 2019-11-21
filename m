Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CE5E1057A7
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2019 17:58:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726775AbfKUQ6t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Nov 2019 11:58:49 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:39132 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726279AbfKUQ6t (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Nov 2019 11:58:49 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xALGtP4s022256;
        Thu, 21 Nov 2019 08:58:36 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=WwtwVYe4S2A2YByXBkiL6OgEItkgLXiCndl/kgH9y4E=;
 b=c0X7wjRPJopwiSPpglLX1y/FBiFSQ3QgEREKllwtCq/5aMLB7kkUGvdHj+I9vAHTCUhO
 zZyzX46XwSmpdpmVfPHvOC3Nz0XqE7t8qUkewR7tVtwkvSA8GtpPGrz/nqFSgTKNagNJ
 hwKwikVnWHseLIk34ywbLym8YwTTXsYaMh8= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2wct98x0je-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 21 Nov 2019 08:58:36 -0800
Received: from prn-hub04.TheFacebook.com (2620:10d:c081:35::128) by
 prn-hub04.TheFacebook.com (2620:10d:c081:35::128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 21 Nov 2019 08:58:14 -0800
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Thu, 21 Nov 2019 08:58:13 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KjzaAJxxmk6rMQNUzFtj96PNdGwAzJM10cz6kFh1xKoYoFRZAYrSkanpJuIJGD6CM+fimrlkdo54Dg2sN/XhtDzwGJYMgRZZGNaAKgtLYuG0ge2uXzgqYLjAWzhwvRNMIO00vVIhqydxAA6eO7SDMScxERdFGgTsAZ17karl+AqPUZsgef92jpMhuLqpMghL4o5cIp3Ha5qRsQQ2voeGxF8CqX1Sj9fnrjeYvxdvChvjphcWQ+yA6Ir9c7xLqNT6D9t24Kj9MtSE5xOm5sFQ6NVQul1c8lEvV5cLLdATSHwaCuqXOxl1Swzz/sO6dAkPzGVWofDbiC3EEYhA5JfDJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WwtwVYe4S2A2YByXBkiL6OgEItkgLXiCndl/kgH9y4E=;
 b=XZmTT6TgaeMxD5YLsmLUM+jzkRjHG4pW/q9qxdN4P+fKk+yfc/u5ZJo2OCN0LyBmEeo74aYg1SAVtG+EIu04n4TCS8Tpq7mP8xkQ41EhansqiahLaIGatpynq6hwJnVcZ7O+iDfH5AgTwbY/YfPvNn0LXR3a2kenGoWc+VbKT0oO0a9SjjnIDugxmICLhWf7hS0H9Akch6UBu4BvAalNS3fHtMoVgoLGAmS1z/Pi2zZB3jPAxP9qTtm+MgVOfI2eqMt8nq1+wKHLAlSZin8a8Qo+VNmHwZ3+FB5u/5hWJF+kiBNnd6/PF6N7WQd3Oi+OeV7pRgg31Q+xhIlDOlBtRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WwtwVYe4S2A2YByXBkiL6OgEItkgLXiCndl/kgH9y4E=;
 b=Qt/WIkum5m5RsT3l/GwuUxFg/zWe6/vp2x/R2UfcZ1e2wjFXdhrYJk8zZQsv2FIif5mXC8Lcqi282c3XlDjzZxxLEmcg7aPgeOWHMG6eUTgZEUe+EV/KQmuK3mvfRKS5G1gBQmP8ymJXC8QfPWNDD5xajdeVu1b48hVKdQZyIDQ=
Received: from BYAPR15MB2631.namprd15.prod.outlook.com (20.179.156.24) by
 BYAPR15MB3318.namprd15.prod.outlook.com (20.179.57.19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.19; Thu, 21 Nov 2019 16:58:12 +0000
Received: from BYAPR15MB2631.namprd15.prod.outlook.com
 ([fe80::fd23:27b9:7fe4:f4ac]) by BYAPR15MB2631.namprd15.prod.outlook.com
 ([fe80::fd23:27b9:7fe4:f4ac%3]) with mapi id 15.20.2474.019; Thu, 21 Nov 2019
 16:58:12 +0000
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
Thread-Index: AQHVoF1eUJGIXl/jo02oA2+fhmBRU6eV2PaA
Date:   Thu, 21 Nov 2019 16:58:11 +0000
Message-ID: <20191121165807.GA201621@localhost.localdomain>
References: <20190611231813.3148843-9-guro@fb.com>
 <20191121111739.3054-1-borntraeger@de.ibm.com>
In-Reply-To: <20191121111739.3054-1-borntraeger@de.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO1PR15CA0059.namprd15.prod.outlook.com
 (2603:10b6:101:1f::27) To BYAPR15MB2631.namprd15.prod.outlook.com
 (2603:10b6:a03:152::24)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::211b]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bd361ef9-331c-4f0f-7b2d-08d76ea3fe1c
x-ms-traffictypediagnostic: BYAPR15MB3318:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB33187FC22D7A897188D5BE28BE4E0@BYAPR15MB3318.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3044;
x-forefront-prvs: 0228DDDDD7
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(346002)(366004)(376002)(136003)(39860400002)(199004)(189003)(51234002)(478600001)(71190400001)(71200400001)(7416002)(66446008)(64756008)(66556008)(66946007)(81166006)(99286004)(6916009)(86362001)(8936002)(14454004)(81156014)(6512007)(5660300002)(9686003)(6246003)(316002)(66476007)(4326008)(54906003)(6116002)(2906002)(25786009)(446003)(76176011)(6436002)(386003)(102836004)(6506007)(52116002)(14444005)(256004)(305945005)(45080400002)(8676002)(1076003)(46003)(6486002)(229853002)(7736002)(11346002)(186003)(33656002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3318;H:BYAPR15MB2631.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OksYZRjOFTzYkExoMqs1gG1cNXJZIwBCKIrn3WzjYDnp2d5hUIf4m7fDsOEXNlEGSsgiaAXop6cflqP4PjdBHR7pMKa3fpWNnzPHwNfy43P8lyQWoIRsBmAcqgeocgpOPStJyOEdpvqSgYHAeYZoqubf3EcMmxjIsKZQ/VGPhqYYXzMn1N9247NsaZcyy0ZwRpUHEuzhyLfbXYHicAfiiVl/ViuipNEwMeFQktM7h5O1J/ab10O7mxBvGV3luQzLsPvPHvPNLmcGFJS+tzZYZsEa6j1h7maee4cQ6BCt0ha9InIECIy221K55ux+1HTjx9ha6y9j2l+/NiJxMOg3wIakQjBop/WKC+gOcrtvPNZ52SP0TgsmZfFClojgTJYzYIu5Bn52dPwW0FXvhFo3y265QWSEgPNxA45T7NSj7BK3MDk/pxjXSJCPBV4VAYbCUV6bjG4Xbd8c2cITqJmaQQ==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B8AFA05F252BA54B8D86D89DE27F1CF1@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: bd361ef9-331c-4f0f-7b2d-08d76ea3fe1c
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2019 16:58:12.0267
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dIRlw15ZkPSSuXAdCFt4HLNsbpXW9MsNaz90DqRJG/wp2f4NZWYoTQGc7+zfYoau
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3318
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-21_04:2019-11-21,2019-11-21 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 mlxlogscore=664 impostorscore=0 phishscore=0 priorityscore=1501
 lowpriorityscore=0 suspectscore=0 bulkscore=0 mlxscore=0 clxscore=1011
 spamscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911210148
X-FB-Internal: deliver
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 21, 2019 at 12:17:39PM +0100, Christian Borntraeger wrote:
> Folks,
>=20
> I do get errors like the following when running a new testcase in our KVM=
 CI.
> The test basically unloads kvm, reloads with with hpage=3D1 (enable huge =
page
> support for guests on s390) start a guest with libvirt and hugepages, shu=
t the
> guest down and unload the kvm module.=20
>=20
> WARNING: CPU: 8 PID: 208 at lib/percpu-refcount.c:108 percpu_ref_exit+0x5=
0/0x58
> Modules linked in: kvm(-) xt_CHECKSUM xt_MASQUERADE bonding xt_tcpudp ip6=
t_rpfilter ip6t_REJECT nf_reject_ipv6 ipt_REJECT nf_reject_ipv4 xt_conntrac=
k ip6table_na>
> CPU: 8 PID: 208 Comm: kworker/8:1 Not tainted 5.2.0+ #66
> Hardware name: IBM 2964 NC9 712 (LPAR)
> Workqueue: events sysfs_slab_remove_workfn
> Krnl PSW : 0704e00180000000 0000001529746850 (percpu_ref_exit+0x50/0x58)
>            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:2 PM:0 RI:0 EA:3
> Krnl GPRS: 00000000ffff8808 0000001529746740 000003f4e30e8e18 00360081000=
00000
>            0000001f00000000 0035008100000000 0000001fb3573ab8 00000000000=
00000
>            0000001fbdb6de00 0000000000000000 0000001529f01328 0000001fb35=
73b00
>            0000001fbb27e000 0000001fbdb69300 000003e009263d00 000003e0092=
63cd0
> Krnl Code: 0000001529746842: f0a0000407fe        srp        4(11,%r0),204=
6,0
>            0000001529746848: 47000700            bc         0,1792
>           #000000152974684c: a7f40001            brc        15,152974684e
>           >0000001529746850: a7f4fff2            brc        15,1529746834
>            0000001529746854: 0707                bcr        0,%r7
>            0000001529746856: 0707                bcr        0,%r7
>            0000001529746858: eb8ff0580024        stmg       %r8,%r15,88(%=
r15)
>            000000152974685e: a738ffff            lhi        %r3,-1
> Call Trace:
> ([<000003e009263d00>] 0x3e009263d00)
>  [<00000015293252ea>] slab_kmem_cache_release+0x3a/0x70=20
>  [<0000001529b04882>] kobject_put+0xaa/0xe8=20
>  [<000000152918cf28>] process_one_work+0x1e8/0x428=20
>  [<000000152918d1b0>] worker_thread+0x48/0x460=20
>  [<00000015291942c6>] kthread+0x126/0x160=20
>  [<0000001529b22344>] ret_from_fork+0x28/0x30=20
>  [<0000001529b2234c>] kernel_thread_starter+0x0/0x10=20
> Last Breaking-Event-Address:
>  [<000000152974684c>] percpu_ref_exit+0x4c/0x58
> ---[ end trace b035e7da5788eb09 ]---
>=20
> I have bisected this to
> # first bad commit: [f0a3a24b532d9a7e56a33c5112b2a212ed6ec580] mm: memcg/=
slab: rework non-root kmem_cache lifecycle management
>=20
> unmounting /sys/fs/cgroup/memory/ before the test makes the problem go aw=
ay so
> it really seems to be related to the new percpu-refs from this patch.
> =20
> Any ideas?

Hello, Christian!

It seems to be a race between releasing of the root kmem_cache (caused by r=
mmod)
and a memcg kmem_cache. Does delaying rmmod for say, a minute, "resolve" th=
e
issue?

I'll take a look at this code path.

Thanks!
