Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5000105C76
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2019 23:09:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbfKUWJd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Nov 2019 17:09:33 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:36278 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726297AbfKUWJd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Nov 2019 17:09:33 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id xALM80Sx028447;
        Thu, 21 Nov 2019 14:09:23 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=bNLZnYjP/wFIyBNpjTIKFYblZQAqTIs5yPGkGrPhqiU=;
 b=eyJ1zYPz2bNvrF9RpczpTnJQFaPSpkzsrcYGpewnIPLOSnjIC5xcHf9Ys362zwQuLpSP
 74I2pf/lrBEFni//SWFhSubt+c5HC7s9QFDGJLHxvodH6nuSw5JSgZCry+6Tu+uMfmV5
 U9XTlWS1AA9+FnrHgJyQn/9xfNxFRj8945k= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 2wdtbk30t9-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 21 Nov 2019 14:09:23 -0800
Received: from ash-exhub102.TheFacebook.com (2620:10d:c0a8:82::f) by
 ash-exhub102.TheFacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 21 Nov 2019 14:09:22 -0800
Received: from NAM03-DM3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 21 Nov 2019 14:09:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PALMcKdWa0nlhZmPm/+IvJeRScjqd1l+uv650jz4JldiCus7R1roxVZpeQTtxOMoK0NqB1azJUrwxnubl4gEfrvMSZtJz5MoBMnorKCtiNcTAUBNCGUGyfwO6yNdVIh4ZerPKQaQj3HiMhISSeL9zMylVXrnChxSqx/LnvQctlsYSuDzRNLxwnqeEwg/+me9EbjjkIYvZqIO3oKidjoRfiPscI8fISlWVuUjiAvNpgKIHKQblnKIhnGWjAoQ43QzaoXCBywCisQtQkiOaME2Qy50wpsJaxkeRefSeRkXtsEQU/jewiT8qC8cHxvQsIkzVEzXLnMl6zFRmFjuuixkMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bNLZnYjP/wFIyBNpjTIKFYblZQAqTIs5yPGkGrPhqiU=;
 b=PeQzjpciWMPiy4vgEu6JSvyXP4fv/3r4+NbEBswxMFtGQc1rFF7+WWxqdeXrhdT90enQiFUal2Qz//CBnl6nwBBxX338Y/HytPwdsSswUbZXFqfGSytGzanIubElYvEj6oBVQxtkHPVRRf0caO8mWWRQmX7vJ12Y59pwQajgA8q7dJSqeu7FJnzgQ4L2tYxJo73VAuJIhvVIb/2En/2pmsA1F6LM0SdWTOEPmWxSF75fYC41joK/6WeQsliLztm6P7eECP0ZGj6QylavdTO/4T9UGPIJxoOFx2YDthRbN2D2RWGHe2jnLHU8wHGruQmktN6EkruJc8Wlvu19rGfpYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bNLZnYjP/wFIyBNpjTIKFYblZQAqTIs5yPGkGrPhqiU=;
 b=BXdsM3g+IrE8qtQuzJ0RCNv8Tc0GHdunS3lYlYh96uY0jqMOKoWSJgP/nEp5TtE0hdTQs2tXR77ugi/5gaCl9Qch1Lyrb6F3lutZ9D+PKlEAqMAV5HIh5fG/1tlu2bV80IVQjXchx9zHMyt515KFX/QnS/PJZVLYekTWqSVskdo=
Received: from BN8PR15MB2626.namprd15.prod.outlook.com (20.179.137.220) by
 BN8PR15MB3458.namprd15.prod.outlook.com (20.179.75.222) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.30; Thu, 21 Nov 2019 22:09:19 +0000
Received: from BN8PR15MB2626.namprd15.prod.outlook.com
 ([fe80::50eb:bc03:b3de:375c]) by BN8PR15MB2626.namprd15.prod.outlook.com
 ([fe80::50eb:bc03:b3de:375c%7]) with mapi id 15.20.2474.018; Thu, 21 Nov 2019
 22:09:19 +0000
From:   Roman Gushchin <guro@fb.com>
To:     Rik van Riel <riel@fb.com>
CC:     Christian Borntraeger <borntraeger@de.ibm.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
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
Thread-Index: AQHVoF1eUJGIXl/jo02oA2+fhmBRU6eV2PaAgAAAgACAAB16AIAAINyAgAADcQCAABSlgA==
Date:   Thu, 21 Nov 2019 22:09:19 +0000
Message-ID: <20191121220913.GA6325@localhost.localdomain>
References: <20190611231813.3148843-9-guro@fb.com>
 <20191121111739.3054-1-borntraeger@de.ibm.com>
 <20191121165807.GA201621@localhost.localdomain>
 <c6a2696b-6e35-de7c-8387-b21285b6776f@de.ibm.com>
 <20191121184524.GA4758@localhost.localdomain>
 <30a2e4babdcb22974a0a5ae8c5e764d951eef7dc.camel@fb.com>
 <20191121205520.GA5815@localhost.localdomain>
In-Reply-To: <20191121205520.GA5815@localhost.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR21CA0059.namprd21.prod.outlook.com
 (2603:10b6:300:db::21) To BN8PR15MB2626.namprd15.prod.outlook.com
 (2603:10b6:408:c7::28)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::af5a]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1de592d8-e0ac-4c0b-bad8-08d76ecf74e3
x-ms-traffictypediagnostic: BN8PR15MB3458:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR15MB3458F393495B245323790508BE4E0@BN8PR15MB3458.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0228DDDDD7
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(346002)(376002)(366004)(39860400002)(396003)(189003)(199004)(6506007)(52116002)(66946007)(66446008)(33656002)(186003)(14454004)(6862004)(446003)(81156014)(4001150100001)(4326008)(386003)(81166006)(8676002)(2906002)(25786009)(8936002)(7736002)(6512007)(5660300002)(478600001)(6486002)(229853002)(86362001)(9686003)(11346002)(99286004)(1076003)(66476007)(66556008)(76176011)(6436002)(46003)(6246003)(71200400001)(64756008)(7416002)(71190400001)(54906003)(6636002)(256004)(14444005)(6116002)(316002)(305945005)(102836004);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR15MB3458;H:BN8PR15MB2626.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: r+b3eW3xYyllzryUvM7Me+dmwx0XwOH8hqM/j7LC5Fuki3Fc9cW5kMefFmktkKFTtuF6y9bN7/PZLYB1H1NBLu5xtTwDBCCqvtaWOlMEQMo/22E4XUDqaa3yoag0hul/nY0xa3LsvzPgNGkPOXhZj1SguM96wBErS3j08WkZa0qdYdB8vOjx7jTSd5QNL2aFd56b/RAtgnxKInCFAUPNXt59aRMt7eYSR4CT3XKpJiMRdpwiWP2cKfQO5Ecs9PqbQz/hh7jUhX54PBQG1rk3cUrtBlw14FOtCgMhYx4gkEzKrRFov7ygROsn6n5a46m0wt/yH+VcxK8CYYcZcxWNNETg521Z5bB8GdnUtv95bj8WjZmGNf46Yeoj6W9RtwYh2E+bsypKoPOk8jE+GNV4tsCXvYw8f7vSUuTRgMH8/EbCkEH/vtKrP1rW7FWLt6Pz
Content-Type: text/plain; charset="us-ascii"
Content-ID: <AA60E95E9191DE4B85FD79D491B82FDF@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 1de592d8-e0ac-4c0b-bad8-08d76ecf74e3
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2019 22:09:19.6950
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jmnQYLxTQJ3nsaDiQHU+ZZTu6l+6l2qQGANALKQxEK2Cp/EH5/fDyQpUYa5Bz8//
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR15MB3458
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-21_06:2019-11-21,2019-11-21 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 phishscore=0
 lowpriorityscore=0 suspectscore=0 clxscore=1015 priorityscore=1501
 mlxlogscore=999 adultscore=0 spamscore=0 mlxscore=0 impostorscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911210185
X-FB-Internal: deliver
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 21, 2019 at 12:55:28PM -0800, Roman Gushchin wrote:
> On Thu, Nov 21, 2019 at 12:43:01PM -0800, Rik van Riel wrote:
> > On Thu, 2019-11-21 at 13:45 -0500, Roman Gushchin wrote:
> > > On Thu, Nov 21, 2019 at 05:59:54PM +0100, Christian Borntraeger
> > > wrote:
> > > >=20
> > > >=20
> > > > Yes, rmmod has to be called directly after the guest shutdown to
> > > > see the issue.
> > > > See my 2nd mail.
> > >=20
> > > I see. Do you know, which kmem_cache it is? If not, can you, please,
> > > figure it out?
> > >=20
> > > I tried to reproduce the issue, but wasn't successful so far. So I
> > > wonder
> > > what can make your case special.
> >=20
> > I do not know either, but have a guess.
> >=20
> > My guess would be that either the slab object or the
> > slab page is RCU freed, and the kmem_cache destruction
> > is called before that RCU callback has completed.
> >=20
>=20
> I've a reproducer, but it requires SLAB_TYPESAFE_BY_RCU to panic.
> The only question is if it's the same or different issues.
> As soon as I'll have a fix, I'll post it here to test.

Ah, no, the issue I've reproduced is already fixed by commit b749ecfaf6c5
("mm: memcg/slab: fix panic in __free_slab() caused by premature memcg poin=
ter release").

Christian, can you, please, confirm that you have this one in your tree?

Also, can you, please, provide you config?
And you mentioned some panics, but didn't send any dmesg messages.
Can you, please, provide them?

Thanks!
