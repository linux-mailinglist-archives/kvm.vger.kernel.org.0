Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB59F22B8C9
	for <lists+kvm@lfdr.de>; Thu, 23 Jul 2020 23:38:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726334AbgGWVif (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jul 2020 17:38:35 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:56800 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726033AbgGWVie (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 23 Jul 2020 17:38:34 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06NLUkVY013129
        for <kvm@vger.kernel.org>; Thu, 23 Jul 2020 14:38:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : subject
 : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=pfpt0818; bh=+cNf+7bcSbfKHMlwj3gpV7YcJfZ+dLUg98hYL7jy0H0=;
 b=r2AonhkMu7C45e6Ca721e3j+F/38JkDkG2O/F+MY27WgkXTxrEYADQ34ys+XL6b1tSc7
 d2M8bBAdARLpUwM1TkwXOXN4BDOPYeD4MnTh5arg7C3t6lHtCEhbTDcf3/w97sotwZ2X
 t0E1Pjv3vfTJf7pFZaL0gvtdBZjESzXwAl1nNK6Jv1IJB4TIz3CM1dI31wmIB6waPepn
 jQQ0Lg0JkRlZpJcUedyG5an4zifNidmDI/Vqmc9Mhrb3hPyBbMqS/E74bRG1dRKn8vEL
 5GwtGlFfWGK7Qfg8R88YVSdfZ/iL4vdk4NeCtYbH+4i7WkxZQsjiV4N4DFmRLnh93ldP rA== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 32bxenyt9n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 23 Jul 2020 14:38:34 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 23 Jul
 2020 14:38:33 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.102)
 by SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Thu, 23 Jul 2020 14:38:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZKfGvEjnSALldiNkYGGJbpV16nuVlrQDU1odtOkdr2cVHJDWvkJz6iAjHiQQiFwIdhYSbAEz4Q48imKkn+bCpZ8WIMtAWlID3TyHQDS5fDWilNbmOLmtTsPMifQ/yPTl6RD5//32gpT6xtlkqnA2hbjh3YEfRgdo8UCAXAsXt6BZ1w/k1acbDaiGHq6j0Xe2rk1tmqwd4ZVy6Ae+dWLh4EbIG5azF5yhpjhXtadph4dNuZTj7ZmuRfl2L6C73fbk1H4Y9r5tv+ZM8a4T+g2AOyR6CAMsxsHOf8k2Vdi28LQZ3mb7aaG4CMsZWaghzQOnuCW7YAynWcq101GiNFddmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+cNf+7bcSbfKHMlwj3gpV7YcJfZ+dLUg98hYL7jy0H0=;
 b=CnyMpURhORJvNzSQdWIgVesQtxUwkvpRg+rkAVwrhTrZZK+YarqFxNChpABmQ1rZCI+HQDxJmpCgPYzHgmSBlBVHUz4JfSYQD8V9W8Wz2DOTV85sNsGvbZKtZ+kPJmo2hs5PcBT20zzmM+L+mG+rLpxjOzntyXyksJDE21pLp+3YgBreX7yBo9iNRNF+PCeDOEl6oeBcFeoeM6nYb5wxLi0uqR8y8eqa+I0fYUoiriTyNmb58MUlTfvyaeeiX67b4MvT79sec5oUUVEvWvZzlVZR3lCtP2O0ejdy7v1nbYOqnBDEs7ugy/kBmr6I7anw54dOGDAVdoE3UIuc54bJ/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+cNf+7bcSbfKHMlwj3gpV7YcJfZ+dLUg98hYL7jy0H0=;
 b=jXbXHiZQg5A7Qd3xA03z22ltWtw3fdXOqjOF371rRvW4bpIA8hUB2KfR4CDf9O1QKyYu7hLFSBgZHF1+YJhIyTO+v82mPwsEmStHkN/DLuPW2cjiiNDw8wsW2q06b1GP3EnCOctQ4VPuHTpDN5Y6ESaVgekmHQEwmrIZK6dDlf8=
Received: from BY5PR18MB3282.namprd18.prod.outlook.com (2603:10b6:a03:1ac::15)
 by BY5PR18MB3186.namprd18.prod.outlook.com (2603:10b6:a03:1af::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.22; Thu, 23 Jul
 2020 21:38:32 +0000
Received: from BY5PR18MB3282.namprd18.prod.outlook.com
 ([fe80::f948:e533:540a:8adf]) by BY5PR18MB3282.namprd18.prod.outlook.com
 ([fe80::f948:e533:540a:8adf%5]) with mapi id 15.20.3216.024; Thu, 23 Jul 2020
 21:38:31 +0000
From:   Ross Deleon <rdeleon@marvell.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Could multiple PCIe devices in one IOMMU group be added to different
 KVM VM separately?
Thread-Topic: Could multiple PCIe devices in one IOMMU group be added to
 different KVM VM separately?
Thread-Index: AdZhOZr8DFKi39UsTGyXZ0YdgDbVFw==
Date:   Thu, 23 Jul 2020 21:38:31 +0000
Message-ID: <BY5PR18MB3282589C431572AC89EC531CA3760@BY5PR18MB3282.namprd18.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=marvell.com;
x-originating-ip: [69.181.108.88]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 33fba8dc-cd0b-4b33-90c2-08d82f50bed3
x-ms-traffictypediagnostic: BY5PR18MB3186:
x-microsoft-antispam-prvs: <BY5PR18MB31863591E783C24B41939296A3760@BY5PR18MB3186.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GJeoKUFkk0x6XXQZ6Rauz9TX1bSkPGkbe1dJmHA6x6ArSng6xwtAnj1HmqBrfRCnVEVfnnZtbYOLWZbjhB2x483ku0Bz1hVkhGCGjnRrC8qUoGq9pWo4mvqUA/nptVwvKxMyKmc79WnI0NmxRm1hOqNqkALIuXNWHOIvGeU2ge0ExFPJEBhJfMLqDUrLOsJO1NArtiK+V9G79BGl6gylTI21Ulab6xuJ04SZL+r/BPub0KjQBDjhI0dvsH0+/dJWicBa7S5BaQZIum2+ckLr5qOa8CCkiEX0pPtsLFoxcvquKeYL6OmyxFHP2qFTmyMcsgirtSaur/IREzYIhhhCIw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR18MB3282.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(136003)(346002)(39860400002)(396003)(376002)(316002)(33656002)(66446008)(5660300002)(2906002)(478600001)(4744005)(66476007)(66556008)(64756008)(8936002)(52536014)(186003)(9686003)(55016002)(7696005)(83380400001)(26005)(71200400001)(86362001)(6916009)(6506007)(76116006)(66946007)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: SlpeOMq8K1T1tp2qyKNZjwWSZqHXlgB7n98U26dl9v6UvYq+MbHWXEBhwW8FNy8iOY1lfsv6U1VIbu4nNjAyrZre62ZwPvimYMRfBIKWmmWRnfJLzJ8ok4CJaSVF2or9lRJZQ0ZfeJNHuseY1jgTiJUuc0XQHrqDOe6HrNXISzC1P0B1tdvOdOp9UBr6jdSEV3Yd5GnXqAQ2vW4TFDGy+RIxdJ/Kr5NkaenaTC/RyO8tpmiWyaSm1r4VA91/icUyjaxziSGGc8Vd7vYowGDlUdLs3igOm1f3ZkupKQbBzXZWtBZQ+apDyxKE6yuKoMUQPoz8L3z/OtTrSNG3ESwSddZDvxSvT5F4+zUiWA4l4WiE7EJa0pyL+10xTBkREf9886sTY1XESkloSzgVq+y+yn2LaUPewxFN+uUenyYq2qZE5t2nMRjzy5DImg6QRj3ETIVjB7iwm0idhrjuGKTGUdYR3k/HEa7aKUI4OD96t+EMxBee2Kgn/iqSHKwOf/ut
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR18MB3282.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33fba8dc-cd0b-4b33-90c2-08d82f50bed3
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2020 21:38:31.6381
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jaR8kzzGMDjnfQ3l6MBFKqygD9/04bnXYAsxRitwifYeoutQLxRo4la1kHTeoKIenMOh65T85eBjY9uB8jskLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR18MB3186
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-23_09:2020-07-23,2020-07-23 signatures=0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi:
I want to know could multiple PCIe devices in one IOMMU group be added to d=
ifferent KVM VM separately?
Mother board: ASUS 390-A(intel supports VT-D)
host OS: Ubuntu 18.04 with kernel 4.18.0-15
KVM-QEMU: version 2.11.1
I have got failed message like *card1 is used by VM1, and card2 is in the c=
ard1's group and added to VM2, then VM2 can't boot*
I have tried vfio driver, but it didn't work, so what should I do? try SR-I=
OV? or update KVM-QEMU or update kernel?

Thanks
Dahui
