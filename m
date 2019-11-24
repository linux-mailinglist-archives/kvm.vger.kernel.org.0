Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F342108144
	for <lists+kvm@lfdr.de>; Sun, 24 Nov 2019 01:39:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726907AbfKXAjx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 23 Nov 2019 19:39:53 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:4996 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726846AbfKXAjx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 23 Nov 2019 19:39:53 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAO0Ueso004900;
        Sat, 23 Nov 2019 16:39:35 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=6SEMaZe4CB3tL8JIbdMVuZRzoKUz/OFWc+jOltOFQrI=;
 b=DR75xRPjh3l5iTbX8IlE5wl2zpEN0ckD9IeI0KpXQUrTAP7V3DFTwy59UqbDwl9WqXwh
 vGLIku5kJ/I5OC1KKtOpivNRr0eC+NukfadYAUAE6ojNgW8y3lbGRdi5bG7UVs2dR2eu
 WUIzCKPQPxXNelwYo40GnM2+0r6LDV7Bxb4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2wf3be25xj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sat, 23 Nov 2019 16:39:35 -0800
Received: from ash-exhub104.TheFacebook.com (2620:10d:c0a8:82::d) by
 ash-exhub103.TheFacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sat, 23 Nov 2019 16:39:33 -0800
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Sat, 23 Nov 2019 16:39:33 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ut2oDbz5qwE/7Y5vyt9eQNbfSoOUe2C5mCmMmulU7/cgMQuwLrkqnFqszFUgQhVLEn1C3WLApWBWb+BfFjgFXi8Xs3FcBhzNyflbzsFKdD4+bL7sTotf5L7w+rn6dLB3s5qid0Rd6EqfDc3dRpciTtuED0D+2xTZnfr9K40z5zHL1mCTHs/i4yy1QVSbCHR4Drc3mlIr6hOZ+8dWupvv9RAeZxOqx1a3d8JqVx7WxvzPEiXo+NJvBGh3aB7O3s6n8vPnOgKJNkcotGujEZDcd9GRR1y+iO6+LkuGmKGO3OENwmjIprmdTFE0URDH8WQ8kpOIxpwzVSk/2DUOFWx9Sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6SEMaZe4CB3tL8JIbdMVuZRzoKUz/OFWc+jOltOFQrI=;
 b=cI56UUC7wqtpcQE+YtLtaeiUZB9pZjNLx6OHsHHWZX33d0Ewd0YBEYic1t9yEvEJBQk4+YAu8GKkMhW7wRT8SOCmz73ALbIT+T6y4/Y8jrJDP4oJg6Q/tCNcX6/tOZ+4k4mJ9PMg4HoibFrHmwjDYLk6L0hvJVVH/Lraw7HwagMlg7tQt3VIQ7Ohjr+iJfXJmbf7LI0i1oxN+ALhzoaiCQUoyD4LMKz43edgJMDC/V0f4NN+WFV8M/2R6qniUQxrhIjPtHXoTImonRQBmrI5JTnn7+rMp1l6TVhqAnt++XOY3qFJoKMxbg9hRJPMbpiGlnlx5cqd4Z3VF5Yufq5rAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6SEMaZe4CB3tL8JIbdMVuZRzoKUz/OFWc+jOltOFQrI=;
 b=Z4NWD/LEeBGsUaDrsunUt1O64wwgi6aR/oR0Ss2k/JZ9zFMgPf9ye6PYRCX07d1G1jZSivxAnSvFMF3gQ4jj92V/xeLg0GFC7pZ/JQf+h9GUo8ogVvGVG5KAo+LtYuF77yfKj6hfKgP9zWYdB3D3kS9VmuJPm7Aw0gKIyy3EIvs=
Received: from BN8PR15MB2626.namprd15.prod.outlook.com (20.179.137.220) by
 BN8PR15MB2818.namprd15.prod.outlook.com (20.179.138.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.16; Sun, 24 Nov 2019 00:39:31 +0000
Received: from BN8PR15MB2626.namprd15.prod.outlook.com
 ([fe80::50eb:bc03:b3de:375c]) by BN8PR15MB2626.namprd15.prod.outlook.com
 ([fe80::50eb:bc03:b3de:375c%7]) with mapi id 15.20.2474.022; Sun, 24 Nov 2019
 00:39:31 +0000
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
Thread-Index: AQHVoF1eUJGIXl/jo02oA2+fhmBRU6eV2PaAgAAAgACAAB16AIABbCgAgAIbagA=
Date:   Sun, 24 Nov 2019 00:39:30 +0000
Message-ID: <20191124003924.GA7816@localhost.localdomain>
References: <20190611231813.3148843-9-guro@fb.com>
 <20191121111739.3054-1-borntraeger@de.ibm.com>
 <20191121165807.GA201621@localhost.localdomain>
 <c6a2696b-6e35-de7c-8387-b21285b6776f@de.ibm.com>
 <20191121184524.GA4758@localhost.localdomain>
 <903c101d-45bc-1e52-3c01-1e65cd4ef43e@de.ibm.com>
In-Reply-To: <903c101d-45bc-1e52-3c01-1e65cd4ef43e@de.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR03CA0011.namprd03.prod.outlook.com
 (2603:10b6:300:117::21) To BN8PR15MB2626.namprd15.prod.outlook.com
 (2603:10b6:408:c7::28)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::7157]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0e0e107d-70e9-4ac6-ebb0-08d77076c49b
x-ms-traffictypediagnostic: BN8PR15MB2818:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR15MB2818AE3F552C6951F5675CEEBE4B0@BN8PR15MB2818.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1751;
x-forefront-prvs: 02318D10FB
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(346002)(366004)(136003)(396003)(376002)(199004)(189003)(71200400001)(71190400001)(446003)(11346002)(54906003)(46003)(305945005)(76176011)(316002)(102836004)(6116002)(81156014)(81166006)(386003)(6506007)(53546011)(8676002)(14444005)(8936002)(7736002)(256004)(99286004)(52116002)(1076003)(6436002)(25786009)(478600001)(6512007)(86362001)(9686003)(7416002)(229853002)(186003)(6916009)(14454004)(6486002)(2906002)(4326008)(66556008)(66476007)(66946007)(66446008)(64756008)(33656002)(6246003)(5660300002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR15MB2818;H:BN8PR15MB2626.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: =?us-ascii?Q?0Ab8iBQmBvlYMZas8X8sx717ECIK0i70otJxTU0ips3+yvIGn6TdYVqd4IgW?=
 =?us-ascii?Q?YYatutixkIuEkJT5iuv0txRm/olgo8BGa90dkm+jLXlB5Oo3PC5xaPjWncl8?=
 =?us-ascii?Q?/PMG+YHGC4KXvcWSY+j2uG0p9TTzTWMe26pSxt3IMU/4Sg2+ok8kORuPFUqn?=
 =?us-ascii?Q?Lk7xvz5rY/koK+Z9UFzfc6EdOBNguh/ylub7uZq75/FlUgIQt+CCuAZBe7di?=
 =?us-ascii?Q?uqpNRcseybVkwsEXs/WnWFvdUnOsVoJpz9rDD3SxkMqEj6El7LPV1jhFlgGj?=
 =?us-ascii?Q?C0F8/xKG/Y0ocszY1vb+/AnnqbmaH8uq/+UOVNRNW8WWex+6eH2tYSSJkR3J?=
 =?us-ascii?Q?mEMF4oZCdQLkbLtpVcnSvOtz0SJ3lXinlbVJKO32ofPfgzggbIY4JMZDGdMz?=
 =?us-ascii?Q?DxV0WIi5Gq2v5zCUj0eYMWlX3BcKxFEBbMlj7S8cNpOUI3HQAFLKFdjagqul?=
 =?us-ascii?Q?quwNWssMn+TbBtvS4j+8mdWXCnPrysi8z5Tk7smRHcHjuq6DtIxNkZsuG5ca?=
 =?us-ascii?Q?5UcCGz5emoKDtKFcFxKSFy5yBLgaNftkIYuAN55jfFCvWdirii/NqEcvPkKL?=
 =?us-ascii?Q?HYinhLffb085f0ZITDil6DwWnnOLlTbFAY+3Y2BcDeJSE7xWgXON0/nhwK4o?=
 =?us-ascii?Q?790Gpf/DzJDNl+dqwgsV7239BMwJ2VUvvMPJ/5u8PxDW7v1Y+UF4og6yFTsW?=
 =?us-ascii?Q?/Uwi9HWt5GQkhJjwr+rwxy0oLFYR1Ek5t+/ikjVs5ndDHz3CXh6twmCZLaQf?=
 =?us-ascii?Q?rykhfh+2wDhK/HuSrKna9o+suuT8dfTxRzVMgI9/1ZX27EJ+ni0DYcGFV/k/?=
 =?us-ascii?Q?F5boFdu8ytz5gtSA9Ms51Go5FDlA4XFwG/WISeiLZxntmUyyZcDSWTMxFo1V?=
 =?us-ascii?Q?gQYc5LyjlUPSjyR42l8c+tI+Yi4qyjNWIdlrN+D/VGflIjE7klmxOjZzTxsm?=
 =?us-ascii?Q?C5xuzZVlb5R69t5uxceX3FFU246Xhl8kHx4/YcGFYhIW/LI3XYpd/ggblXoC?=
 =?us-ascii?Q?7ObFdh3af4NVcQ62ntVIw6lfpkDSn9mM/iINy1gxoIBnP+xNZi+8Yisxox/i?=
 =?us-ascii?Q?1hHtFdMXEpezQKOTjsXFWZkcbmNAxQ9oNtUj2r4XT7b6C5sTKx3CLgc++QBV?=
 =?us-ascii?Q?IdO/bBddmzFWMcW7mojLLwSONiYMAaje6n1VS8Tj8Kp9gJaVr5fSwB8zG/bR?=
 =?us-ascii?Q?h+PLSRQG6H40V0K11lj61NCd7Bk2lPafZR256NfEu+zVA7lV/n6eYR7Vp4ko?=
 =?us-ascii?Q?Uj+L3j2B3FWO00DDA7rfVxuyDHhpUt7iKSWeahvGJ9W+cPbGVNukKJlnFjMj?=
 =?us-ascii?Q?p3UAvOviCvj4e3eap2C+3mcXJW2PDe/W8sc2gBbkagtkcWQQdQ5SZH6kBuWq?=
 =?us-ascii?Q?GNVFfGS9ngGn7lvJX1F8+KZX94c4wDy+dP1sK2AHgKdwEZyGEyKXJRhLMjR/?=
 =?us-ascii?Q?p+f9XK+KewBSyPPH+0h64LGbPvtH0X64OvjnL+jgoE9SvnAUb5+zyVXx4YEj?=
 =?us-ascii?Q?DAL2/dOHwPYmliJYhiTUwqjGvwaFeMnD9JwHKpp+gdeok3UNbIuH8YkqAdTi?=
 =?us-ascii?Q?SYIW0GE/EWJKll0HoOfYeQbowEDQ3bhsedjiqbQh2/guCFu8wzyKPhq23MxC?=
 =?us-ascii?Q?4vliQooYoPASM5xg1Qf1G6Srb8gNWlJTf50jgXaZIdynBnGL3un9twUUG5c+?=
 =?us-ascii?Q?dijutZbD+2es+DvtB3eYs3EwmiY=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E17F9E527BB3F541A8A1FFD429D68F89@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e0e107d-70e9-4ac6-ebb0-08d77076c49b
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Nov 2019 00:39:31.0255
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4AJk1vynSxIUlCqXWigqY1yDbIgAcJ5BX6LYrkojzhwZ74ipZf50HOynilmuoVqo
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR15MB2818
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-23_06:2019-11-21,2019-11-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 phishscore=0 spamscore=0 malwarescore=0 mlxscore=0 adultscore=0
 bulkscore=0 mlxlogscore=999 priorityscore=1501 impostorscore=0
 suspectscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-1911240001
X-FB-Internal: deliver
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 22, 2019 at 05:28:46PM +0100, Christian Borntraeger wrote:
> On 21.11.19 19:45, Roman Gushchin wrote:
> > I see. Do you know, which kmem_cache it is? If not, can you, please,
> > figure it out?
>=20
> The release function for that ref is kmemcg_cache_shutdown.=20
>=20

Hi Christian!

Can you, please, test if the following patch resolves the problem?

diff --git a/mm/slab_common.c b/mm/slab_common.c
index 8afa188f6e20..628e5f0ee19e 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -888,6 +888,8 @@ static int shutdown_memcg_caches(struct kmem_cache *s)
=20
 static void flush_memcg_workqueue(struct kmem_cache *s)
 {
+	bool wait_for_children;
+
 	spin_lock_irq(&memcg_kmem_wq_lock);
 	s->memcg_params.dying =3D true;
 	spin_unlock_irq(&memcg_kmem_wq_lock);
@@ -904,6 +906,13 @@ static void flush_memcg_workqueue(struct kmem_cache *s=
)
 	 * previous workitems on workqueue are processed.
 	 */
 	flush_workqueue(memcg_kmem_cache_wq);
+
+	mutex_lock(&slab_mutex);
+	wait_for_children =3D !list_empty(&s->memcg_params.children);
+	mutex_unlock(&slab_mutex);
+
+	if (wait_for_children)
+		rcu_barrier();
 }
 #else
 static inline int shutdown_memcg_caches(struct kmem_cache *s)

--

Thanks!
