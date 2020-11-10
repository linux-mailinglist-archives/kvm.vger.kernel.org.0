Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D2952AD771
	for <lists+kvm@lfdr.de>; Tue, 10 Nov 2020 14:25:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730590AbgKJNZX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Nov 2020 08:25:23 -0500
Received: from mx0b-002c1b01.pphosted.com ([148.163.155.12]:47044 "EHLO
        mx0b-002c1b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726721AbgKJNZV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 10 Nov 2020 08:25:21 -0500
X-Greylist: delayed 800 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Nov 2020 08:25:21 EST
Received: from pps.filterd (m0127844.ppops.net [127.0.0.1])
        by mx0b-002c1b01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0AADBWs4021327;
        Tue, 10 Nov 2020 05:11:55 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=proofpoint20171006;
 bh=tX3wW7i9YtZ7CiSkrMCJwO0hTJRS047Q/kth45eRm1A=;
 b=06uRQAXFAOsNMljDWJUNR2UUkmNGaEgsAeCX3YF7YXwJWbOmDt/e+MQeKbBjyqneMiGh
 euD0QxM9nxTfcOMrDD5nwvLOVaNNG47MfS+BCeKivAOrdFU07aw9TlIPSMBYtaa80Rxv
 YEISEA/OlMNuzjgLcri0r3KdCo1591/EmaWhndEUJ81xprgk7QHbbHelMd5IM1G604E0
 FplIoOxvjrtPBrqizxYaJ5ar0O24HJNfjTIdWy9iO9poZH1d0wEUnrj/7sUl/giZknXh
 orw1/D3fAzwxsYuGH/RgVqFj8W6GmxHMYtYXGa56FVECjaGowhieTDKfyiLbwRmn3ZJT DQ== 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2107.outbound.protection.outlook.com [104.47.70.107])
        by mx0b-002c1b01.pphosted.com with ESMTP id 34nv04x088-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 Nov 2020 05:11:54 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SPTphZrzzMyzuYsczkwCnIwMSBdk5Nr47CrqQ0AtPRzlvTQNKIUeH3GOan9iqiUxfqAgC0lV60zAjUXmj2G5+rk2mvep3oIolGMMFXfqDnlP0mjgEgY/fs7vo0TJiH4cA0hG81f6Mh9L+y+0lHp++AmTi/xVSLqs9DCmCnVRkfBDnqnI+kPncnjpnwfraj4GXOvSWq/QBBY3y8MQ5xJuqsEVVvv00KhFaOKVT375puyoobZXv3ryMGbBaatPEwPPScFsEozg+LXhdxAe2ggrLGa4XgsCHjFXtxhJl3naPmC1oy+INVY2/QjQNmgw7w5iGC3oUtJmeFkjpKLP1cHLvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tX3wW7i9YtZ7CiSkrMCJwO0hTJRS047Q/kth45eRm1A=;
 b=nUVRJQYI5o5IkUU508YXpYKznH5bNb7HTGpY+iM5dTFEg3Fvx0CftmMlsWaxtcvCXKjGkZQi0VyQwohbLzqdDgKI1fMz62bIzJXtUU3T2cQcRweVpF1NoiaASJkq7Luz0eFF1R36NMIyMtgcdjLCfpkwA/s2FJwH4Gm8n7qdh+IN+nlILxEnPqZEhPtIkoR6fmIeZ/Qi10n3qRyghWj0hXqQs7NhN3nuPhKwZnpZnHi8KHPe/b2JdCizteckDwoSk8ypLKsj61hrNd+p7L6Nwx9lAg0PC90wdgDnP9CYt+3rRZTpunjrrmRNXgu7X5K3tmz7Rw7lNVbzEYTqCDKFWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from MW2PR02MB3723.namprd02.prod.outlook.com (2603:10b6:907:2::32)
 by MW2PR02MB3658.namprd02.prod.outlook.com (2603:10b6:907:2::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.23; Tue, 10 Nov
 2020 13:11:52 +0000
Received: from MW2PR02MB3723.namprd02.prod.outlook.com
 ([fe80::950e:a59c:cc5b:4908]) by MW2PR02MB3723.namprd02.prod.outlook.com
 ([fe80::950e:a59c:cc5b:4908%4]) with mapi id 15.20.3541.025; Tue, 10 Nov 2020
 13:11:52 +0000
From:   Thanos Makatos <thanos.makatos@nutanix.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        John Levon <levon@movementarian.org>,
        John G Johnson <john.g.johnson@oracle.com>,
        Swapnil Ingle <swapnil.ingle@nutanix.com>
Subject: clarifications on live migration in VFIO
Thread-Topic: clarifications on live migration in VFIO
Thread-Index: Ada3YuV2NCnGJFSnQQyV1IuvmCnhMA==
Date:   Tue, 10 Nov 2020 13:11:52 +0000
Message-ID: <MW2PR02MB3723556EAC82D2EAF13B54BD8BE90@MW2PR02MB3723.namprd02.prod.outlook.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=nutanix.com;
x-originating-ip: [78.149.9.252]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c09b19f2-bcd0-4f59-0abc-08d8857a30f7
x-ms-traffictypediagnostic: MW2PR02MB3658:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW2PR02MB3658142B1F5FA567AB7E54F88BE90@MW2PR02MB3658.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 53CFEsjbr7e/D9gOzj/wzoemIu/Datk20W532hMbijIsF5IZ/QA/vK7Uqpt8sa40an2/lZ6h6R+nq6e5WQQ+tNQfsxoz6lLtFImFwwJPEjZyHhBHkwpKa5+r6EYTncmRlJM5R/SKjOAPNcxSM0kLdhGmCiJfmN2+BY2WQ1jaNi3qG9x619tA2HmkMBzlEnves0LfTF98DdehxH7clJutRLhc9u8RxWlZiQjkVUZYI4kndpOhT1oCHFhyxlVLAWXCosLSAciosqqPusMZbrx6bIsyibmTpzLvN03wO7+Fl1blOUuQ9Hcd3X4PPfdQSkGyGfZqx0bCrYA4sJ6NfPuK7w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR02MB3723.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(346002)(396003)(39860400002)(136003)(52536014)(26005)(54906003)(4326008)(2906002)(107886003)(7696005)(6506007)(55236004)(478600001)(66556008)(76116006)(83380400001)(64756008)(66946007)(8676002)(66446008)(66476007)(9686003)(55016002)(86362001)(44832011)(316002)(71200400001)(33656002)(5660300002)(186003)(6916009)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: F7NV1bAs9vP72eAImy+5DitTneJ2YefAQfeXZT/PITsckgtfJmAWbCPQ5yvCkE/0tQehZdY7kF5RGvhysUYWVYNjzxGK15nvOZU5EdgVEK8y/2tkIJ5hW7DroGbvoHPk6WCB3YlK/zCGIgbhP4LVMa2tJmNouRa7VpZWINaaoY8zLq/QSqpsw+CHJ6QvaWaq/YBq3yXPfovt2OAp+I2tVekddfiIA5QwpYFF4sbb17xIN9L+RPvolCH7To8x9H0S8I/xLPjONcMUNnSHgm48q0hd2/xapXa6kzREIooflWHbvwpL5Hx5/0ebEBhlwaLfWFN2DvvUVNmH3WBFbblDcOe5OkTVbgmFIPl899lmeukT+qS3EFcJxCyw5LQLp4hSepbFJanOPd9/12pEHo4kEQYio+x67ij6hl6LOyrFvsB4T4BJ8qwrPB6n/f0wGVw2n/IKrp3NduTVtMOaZmsn1PZSzDPfcM0URylczyPiQSMAQ0ORurLCTVckordrBBuGtGkIywObklznaDiLgcmhbDCx7b8lSBMgqjPeIJP2e4lxIgiOrFRzvXKg3a3dj/Ke1D6CXwKJRRAV5rqaOXT83KhSt2mTMLV1SOayxJ255bbdJIAZOjBDUFuMJIkfUgT1WCUEepSnh19CSKKx+VPApg==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR02MB3723.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c09b19f2-bcd0-4f59-0abc-08d8857a30f7
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Nov 2020 13:11:52.5516
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ijd9j/nxZqcuh5nuyfXp8zLxlmZfK4StbAnIYOG0SB4mHwVFgGd3dS3m0a30vg+c4/oW1oGaQ4X+RExwlSA0uKbTKdYISn8LQqP5+YmjA/k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR02MB3658
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-10_05:2020-11-10,2020-11-10 signatures=0
X-Proofpoint-Spam-Reason: safe
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I'm implementing live migration and I have a few questions:

* Do the stop-and-copy and stopped states have any effect on the operation =
of
  the device? E.g. is it legitimate to access registers of other regions ex=
cept
  the ones of the migration region? Can the device effectively "shut down"
  apart from functionality related to handling the the stop-and-copy state?=
   =20

* What happens if an iteration has started (pending_bytes has been read), b=
ut
  pending_bytes is read again without the migration data having been read
  entirely? I suppose this is a user bug?

* Regarding the pending_bytes register, can its value fluctuate in time or =
must
  it decrease monotonically and by data_size bytes during each iteration? E=
.g.
  can the size of migration data increase during e.g. the pre-copy phase?
 =20
* What are the semantics of reading data_offset or data_size if an iteratio=
n
  hasn't started? I suppose the read value is undefined?
=20
* Regarding the following statement:

 "Read on data_offset and data_size should return the offset and size of
  the current buffer if the user application reads data_offset and
  data_size more than once here."
 =20
  I'm not sure I understand here, does this mean that data_size and data_of=
fset
  don't change during an iteration, even if the user reads migration data
  without multiple read(2) calls during an iteration?
