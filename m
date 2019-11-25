Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FCEB109346
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2019 19:08:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729284AbfKYSIm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Nov 2019 13:08:42 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:1622 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727722AbfKYSIl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 25 Nov 2019 13:08:41 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAPI7ENg031551;
        Mon, 25 Nov 2019 10:08:05 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=rW9alH6/9vNgEUeMGHz5SORSEbxri1Rb35XfLT6ieng=;
 b=bsu1D6Txg3/l8tRR6NEx2IpE45XgK5IPqEAKIvXmrcT961VI2sOTe4e3YH6nl7K0h0Vl
 biopHT5mjylj2fFvWuanvOUsdVgVrAv9NZt7srg5TUX8ezebB3j/cjjwrpLWCZ1glH+Q
 mqmatsBReZ9m8n7KvURkwm3Fhqqf8ICfQMI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2wfnbfy517-18
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 25 Nov 2019 10:08:03 -0800
Received: from ash-exhub104.TheFacebook.com (2620:10d:c0a8:82::d) by
 ash-exhub101.TheFacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 25 Nov 2019 10:07:52 -0800
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 25 Nov 2019 10:07:52 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HqTSkFdy1Hv6g0wRrO8dFw4mefUEuFwCLpAIpl16DzJF/fc3L6zjv5kvl/lQIexPyeDrDocMV+REffwHRm8KMep/23K3NcS0fXevLoevPmuge4t8yMZCfGK15MtWwF8j6q6ukg16hUc69aJZJNiDaPISDR7ZPbiuAY48cSZx8MXbudGADz5EtdOTeqVp6zlhabiLx+CVM/CFNmSotqS1hAGDyDPLOrNKhzpI9KAeygRR79P5x8IPSYomAKHizdR/BnRGmvBz+9BqnJH18EzKjxpal8b8pi8jOcTCddlAWeVQaFT6TLCKdOSH2fLRRB3TzZFj+YzdZEg/PYrKCw2/3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rW9alH6/9vNgEUeMGHz5SORSEbxri1Rb35XfLT6ieng=;
 b=k8+cAH78PhqKg0T8yrPN2avAWzRWovhWmgmlpEr9aMJo7oW1MHqZefz33jdslCd+lC8Hkl+sCHQfBzFXEyY7t78SdIb06awePCV629E8121OHKxFY8aorhNOZ48/lofofcdv7nIug6956gRJZQjII+x+iQ6J0TxGDHptLnAPrYZkTf91o4STAZbAMAAHI1YUxB+gTmsYqTSVVt3dBlAPNOPnQPTx9ErXyODAzDqWutbuEP1KTODRuyNUYO60+TpkVop9p+WViFIZi6nqOxhpPSgn/Uf6ZwR6OJKwQaFqPNGZ+HOXEG3G45qlul0LDBLjgdOgvQebwXsvM79zpoRSeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rW9alH6/9vNgEUeMGHz5SORSEbxri1Rb35XfLT6ieng=;
 b=C3wDHeZJzexC3OasJ3oD9RsCxdS1bUkYcoz0Zv6XoVuBglW3gZiCOYs1GhZUMIQurJLB+mnnHRMnJHKnYVcp3TEUHAfp3urWC7n/iOkrmAUbmsZdTlSSschhDSUXN3BoaPyW8HK13xSql9A8YPqKF5X3Z+vAa09a2d0b2u1I0Yo=
Received: from BN8PR15MB2626.namprd15.prod.outlook.com (20.179.137.220) by
 BN8PR15MB3426.namprd15.prod.outlook.com (20.179.76.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.21; Mon, 25 Nov 2019 18:07:51 +0000
Received: from BN8PR15MB2626.namprd15.prod.outlook.com
 ([fe80::50eb:bc03:b3de:375c]) by BN8PR15MB2626.namprd15.prod.outlook.com
 ([fe80::50eb:bc03:b3de:375c%7]) with mapi id 15.20.2474.023; Mon, 25 Nov 2019
 18:07:51 +0000
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
Thread-Index: AQHVoF1eUJGIXl/jo02oA2+fhmBRU6eV2PaAgAAAgACAAB16AIABbCgAgAIbagCAAg2xAIAAqYoA
Date:   Mon, 25 Nov 2019 18:07:50 +0000
Message-ID: <20191125180744.GA9800@localhost.localdomain>
References: <20190611231813.3148843-9-guro@fb.com>
 <20191121111739.3054-1-borntraeger@de.ibm.com>
 <20191121165807.GA201621@localhost.localdomain>
 <c6a2696b-6e35-de7c-8387-b21285b6776f@de.ibm.com>
 <20191121184524.GA4758@localhost.localdomain>
 <903c101d-45bc-1e52-3c01-1e65cd4ef43e@de.ibm.com>
 <20191124003924.GA7816@localhost.localdomain>
 <e2923bb7-19bf-b303-9457-49040acffe92@de.ibm.com>
In-Reply-To: <e2923bb7-19bf-b303-9457-49040acffe92@de.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR13CA0017.namprd13.prod.outlook.com
 (2603:10b6:300:16::27) To BN8PR15MB2626.namprd15.prod.outlook.com
 (2603:10b6:408:c7::28)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::a91]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 24ad1d79-e9bb-4fa9-2efd-08d771d26278
x-ms-traffictypediagnostic: BN8PR15MB3426:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR15MB3426F17E533487467B240458BE4A0@BN8PR15MB3426.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:206;
x-forefront-prvs: 0232B30BBC
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(39860400002)(366004)(376002)(346002)(136003)(189003)(199004)(76176011)(25786009)(9686003)(1076003)(71200400001)(102836004)(46003)(53546011)(6512007)(6486002)(6506007)(386003)(6436002)(14454004)(316002)(99286004)(54906003)(71190400001)(6916009)(86362001)(14444005)(256004)(52116002)(8676002)(81156014)(81166006)(8936002)(305945005)(5660300002)(229853002)(6246003)(186003)(4326008)(446003)(11346002)(66556008)(66446008)(66476007)(478600001)(2906002)(66946007)(64756008)(6116002)(33656002)(7736002)(7416002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR15MB3426;H:BN8PR15MB2626.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uXNZvMbcq0j82wuDuZ6in0Y8v7jjeuZTxMSCI7WEjt3rdNWBqBK3sxZwuKfS2aUnfBCaXCi9HCZAhsUHBbgXY9koMwZxq8EdW5qOwjwlrU3rcmlLx4ITJb5/lyOQ1HOgYk9uJgcg7+uv4G3t3usWAT77iYVLgJssh9ei2NbX8mQYImcZ2wyIfgTll+dsTPRi3GGFxzI5L6Z/W2ePWqxnND0v5vKNm8iE5usfk13o6tEOxL2ijEiJPoLQJdc+g5qKWFglIkWEHqHpUD2WkC7ZgDXswbKrLBOCkxKxZPtlBocCFxOihYp6VGI3+tcqxuOMNGl1O+/QxRaeVQsxGHKoJbQcfcnyj55KcmRkXKFsWXc79OFOOlutrj8GrzHJbCJOuTt+aMupTnmuZYz2Fep3bRZnUA+wrprYhSqPHR1hxKEsvr0AqoAupAMw8rScC5E5
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A2A2E360053E3F418DD07C62E45FC4F7@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 24ad1d79-e9bb-4fa9-2efd-08d771d26278
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Nov 2019 18:07:50.9126
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qdDKOXCxz9OdjcBxzx5Ns1GcgFEFdsK4ZsxOhqFrTzMpaYqzV0+QQ8v9dqYtgU/5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR15MB3426
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-25_04:2019-11-21,2019-11-25 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 malwarescore=0 clxscore=1015 priorityscore=1501 spamscore=0 adultscore=0
 suspectscore=0 bulkscore=0 phishscore=0 impostorscore=0 mlxlogscore=999
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911250148
X-FB-Internal: deliver
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 25, 2019 at 09:00:56AM +0100, Christian Borntraeger wrote:
>=20
>=20
> On 24.11.19 01:39, Roman Gushchin wrote:
> > On Fri, Nov 22, 2019 at 05:28:46PM +0100, Christian Borntraeger wrote:
> >> On 21.11.19 19:45, Roman Gushchin wrote:
> >>> I see. Do you know, which kmem_cache it is? If not, can you, please,
> >>> figure it out?
> >>
> >> The release function for that ref is kmemcg_cache_shutdown.=20
> >>
> >=20
> > Hi Christian!
> >=20
> > Can you, please, test if the following patch resolves the problem?
>=20
> Yes, it does.

Thanks for testing it!
I'll send the patch shortly.

>=20
>=20
> >=20
> > diff --git a/mm/slab_common.c b/mm/slab_common.c
> > index 8afa188f6e20..628e5f0ee19e 100644
> > --- a/mm/slab_common.c
> > +++ b/mm/slab_common.c
> > @@ -888,6 +888,8 @@ static int shutdown_memcg_caches(struct kmem_cache =
*s)
> > =20
> >  static void flush_memcg_workqueue(struct kmem_cache *s)
> >  {
> > +	bool wait_for_children;
> > +
> >  	spin_lock_irq(&memcg_kmem_wq_lock);
> >  	s->memcg_params.dying =3D true;
> >  	spin_unlock_irq(&memcg_kmem_wq_lock);
> > @@ -904,6 +906,13 @@ static void flush_memcg_workqueue(struct kmem_cach=
e *s)
> >  	 * previous workitems on workqueue are processed.
> >  	 */
> >  	flush_workqueue(memcg_kmem_cache_wq);
> > +
> > +	mutex_lock(&slab_mutex);
> > +	wait_for_children =3D !list_empty(&s->memcg_params.children);
> > +	mutex_unlock(&slab_mutex);
>=20
> Not sure if (for reading) we really need the mutex.

Good point!
At this moment the list of children caches can't grow, only shrink.
So if we're reading it without the slab mutex, the worst thing can
happen is that we'll make an excessive rcu_barrier() call.
Which is fine given that resulting code looks much simpler.

Thanks!
