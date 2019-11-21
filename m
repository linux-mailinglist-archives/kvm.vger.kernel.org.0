Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 960B7105B69
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2019 21:56:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726905AbfKUU4y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Nov 2019 15:56:54 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:62776 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726722AbfKUU4y (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Nov 2019 15:56:54 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xALKubIG005449;
        Thu, 21 Nov 2019 12:56:41 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=2OCbpaHS6orm4nl7xo5ZqCbhiUNlOOgT+wxlBshbgc8=;
 b=DfvuvHfEwhT+UfAu/B9RnwIEJ38UU0k7+Jf13gat06t+SCEIRzViU/XoVUjuJPOUZ7wD
 30at9Z5FAQfLToUrdnKAW7OXjSpRfIjCDUagIUK2gyAu/H8tjEiELfsvDcjG/jNwQT5B
 JcXz7/36jt0XiNnhK3EnECBpxe24X14AaDM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2wddynsmdx-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 21 Nov 2019 12:56:41 -0800
Received: from ash-exhub204.TheFacebook.com (2620:10d:c0a8:83::4) by
 ash-exhub201.TheFacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 21 Nov 2019 12:55:29 -0800
Received: from NAM03-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 21 Nov 2019 12:55:29 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IEWc4f3ewGXOvVCfqaCZhnhmSIZQffRVspuZA3WF20Dus0KzYtJwHLmC4kn3zFaK3yDWIdxNmNjfdpQks3NyUHcnFi80IaGTk/vf6w7Q4PUEBJkRL9JfU0q31Gj8kEYN3qeWJAzdqW0cbRBMnUz9oTZD14rJDAq7wSYMcGQUdxQJPfV8N1GIda3QqK0ulT3nQYGRElYj/ieUpBbuZXKWQOcpcXI54tPFKUQWTup53Z6qfFrZt/+9VyN6TIM9GqfKBKaEhaa3d7OQGQ3GGLDNmqfejY2km5enCjFYvpmQR6E49YU1GZA+HIh83srfE9lGcmthi0OtZc5YZCWiiGEY9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2OCbpaHS6orm4nl7xo5ZqCbhiUNlOOgT+wxlBshbgc8=;
 b=ermh/E5EGJ49jvP7d8caDkkfA8PQNQz0PXctRtwqHdcSBAbYwvR1bQjxW8tjumBxQXC5wMzrTFfuy705o4rp952dNKJZt7xSbYkt2nTMIaDJKd2VwsVOPEnkZQnisDo30tMJls+DeWyXtgx1Cs5qoJ1vLw8rzHUKahoYYIHnQ9CS9ZFQKESLkM0q45CE1OCUgw1+LJ8igZx996tqIiQuYJre+XI1B+vWizraL1b43SbX3w0WEaM92qKTY+LMh4H1PmW0L4QRFVWBl0TsZtQKDvzn0kHJBN2s+Bjp8RsYHFt+L36FAgMH0A188CZgzVZi+Av/UmLV4bDa5Pn6XQm+Fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2OCbpaHS6orm4nl7xo5ZqCbhiUNlOOgT+wxlBshbgc8=;
 b=Fr3iYi9AFlR6Iy/Iza6ebjFaMxVJeVxL1mJ6JmAI3qtEfagiSeL3QLzeJgDJcsndPkU6uSDaxWCNPRxfWElpS++fq/9vir7XIhZ61atht5LwXlwqBZBlb90GVK9DRsdweMXmi0aKQRa9Vtdwri4s/DmOv2ZC5XWHL8m4W5rVuUM=
Received: from BYAPR15MB2631.namprd15.prod.outlook.com (20.179.156.24) by
 BYAPR15MB3430.namprd15.prod.outlook.com (20.179.57.89) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.17; Thu, 21 Nov 2019 20:55:27 +0000
Received: from BYAPR15MB2631.namprd15.prod.outlook.com
 ([fe80::fd23:27b9:7fe4:f4ac]) by BYAPR15MB2631.namprd15.prod.outlook.com
 ([fe80::fd23:27b9:7fe4:f4ac%3]) with mapi id 15.20.2474.019; Thu, 21 Nov 2019
 20:55:27 +0000
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
Thread-Index: AQHVoF1eUJGIXl/jo02oA2+fhmBRU6eV2PaAgAAAgACAAB16AIAAINyAgAADcQA=
Date:   Thu, 21 Nov 2019 20:55:27 +0000
Message-ID: <20191121205520.GA5815@localhost.localdomain>
References: <20190611231813.3148843-9-guro@fb.com>
 <20191121111739.3054-1-borntraeger@de.ibm.com>
 <20191121165807.GA201621@localhost.localdomain>
 <c6a2696b-6e35-de7c-8387-b21285b6776f@de.ibm.com>
 <20191121184524.GA4758@localhost.localdomain>
 <30a2e4babdcb22974a0a5ae8c5e764d951eef7dc.camel@fb.com>
In-Reply-To: <30a2e4babdcb22974a0a5ae8c5e764d951eef7dc.camel@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR18CA0051.namprd18.prod.outlook.com
 (2603:10b6:104:2::19) To BYAPR15MB2631.namprd15.prod.outlook.com
 (2603:10b6:a03:152::24)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::cf11]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cb718519-ad61-47ee-b507-08d76ec522e1
x-ms-traffictypediagnostic: BYAPR15MB3430:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB3430B039C44F00ACBEB34489BE4E0@BYAPR15MB3430.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0228DDDDD7
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(396003)(376002)(136003)(346002)(366004)(199004)(189003)(81166006)(8676002)(71190400001)(71200400001)(86362001)(66946007)(305945005)(7736002)(64756008)(256004)(66446008)(66556008)(66476007)(7416002)(6116002)(81156014)(33656002)(6486002)(229853002)(54906003)(25786009)(316002)(6636002)(6436002)(2906002)(99286004)(6246003)(1076003)(5660300002)(14454004)(11346002)(4744005)(446003)(4326008)(6862004)(478600001)(4001150100001)(186003)(102836004)(6512007)(9686003)(76176011)(52116002)(6506007)(8936002)(386003)(46003);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3430;H:BYAPR15MB2631.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +E05oWs2/WQr9DqHPa8rJnquHlhgZ3JgDVDYNzNNq7h/H3T8ZcOT+jH8DbqT5c8ifchXz9JgASOVm4lMymh3WOHl7QRxsSPxns3Ky5d/0sNaBxhAIfIcjZZhhs1OkFioMLNxzj494c+V5lB+Xi83OtDE7V6YdycQwVi4b75yh6kaiCQeASAaWeiXbw/oSxKYFnmqheiQ8+ry/NUe5UQxjgolqpxuMVvCbTRe8SZwGvWJ+39rXEC18NukgdDSpFtFvM4a+87BHl7mEiHpRFTbIX05DjS5aELwtGXO/cs3juxj1lkvl73uHk+//F2laQspCXFxPakrpcfxcjl5iK4ajUmQYojHt6ElZ6N9G3QyNvB30iYeC69mWh8czFT+bHvLeJzJu3nFZXC97c3aveLeDyCM3oNVckCo8IYv7cROwqSKRlAG/Bf63E9kun29qRyt
Content-Type: text/plain; charset="us-ascii"
Content-ID: <682C7C080732E2458F4105B43CA71D10@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: cb718519-ad61-47ee-b507-08d76ec522e1
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2019 20:55:27.1682
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ic21n3x4juYwU6eCyapD4FoG35NweOebiMKQTo71uhZm6fXj5RO9o/FMX2RRDYqL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3430
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-21_06:2019-11-21,2019-11-21 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 impostorscore=0 lowpriorityscore=0 spamscore=0 bulkscore=0 mlxscore=0
 suspectscore=0 mlxlogscore=999 clxscore=1015 malwarescore=0 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911210174
X-FB-Internal: deliver
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 21, 2019 at 12:43:01PM -0800, Rik van Riel wrote:
> On Thu, 2019-11-21 at 13:45 -0500, Roman Gushchin wrote:
> > On Thu, Nov 21, 2019 at 05:59:54PM +0100, Christian Borntraeger
> > wrote:
> > >=20
> > >=20
> > > Yes, rmmod has to be called directly after the guest shutdown to
> > > see the issue.
> > > See my 2nd mail.
> >=20
> > I see. Do you know, which kmem_cache it is? If not, can you, please,
> > figure it out?
> >=20
> > I tried to reproduce the issue, but wasn't successful so far. So I
> > wonder
> > what can make your case special.
>=20
> I do not know either, but have a guess.
>=20
> My guess would be that either the slab object or the
> slab page is RCU freed, and the kmem_cache destruction
> is called before that RCU callback has completed.
>=20

I've a reproducer, but it requires SLAB_TYPESAFE_BY_RCU to panic.
The only question is if it's the same or different issues.
As soon as I'll have a fix, I'll post it here to test.

Thanks!
