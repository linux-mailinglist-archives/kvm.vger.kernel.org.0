Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64E1F307901
	for <lists+kvm@lfdr.de>; Thu, 28 Jan 2021 16:05:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232396AbhA1PCM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jan 2021 10:02:12 -0500
Received: from mx0b-002c1b01.pphosted.com ([148.163.155.12]:5488 "EHLO
        mx0b-002c1b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232301AbhA1PCA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 28 Jan 2021 10:02:00 -0500
X-Greylist: delayed 1377 seconds by postgrey-1.27 at vger.kernel.org; Thu, 28 Jan 2021 10:01:59 EST
Received: from pps.filterd (m0127842.ppops.net [127.0.0.1])
        by mx0b-002c1b01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10SEWgI3023590;
        Thu, 28 Jan 2021 06:38:10 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version;
 s=proofpoint20171006; bh=A4jxP9gtGLUS67XGPkUIUvR90swwnMZoDCFnxYReFGE=;
 b=lCVHPlTdotrMkqhpK8Xg6z+u5pn+gzLtE6JFfR7Oove58Fhwbrsq+vitXCRwnYjDXlrD
 Knj6uDdOP7CU5IjeCa9F2gtnkME/7vSLCrEohCnw5gyDtc8it2cmWeB70Ozn9b32tF6T
 jmOz27wJ9ISB+/ifCAXxYpe3SUdzbRb0YO9gFcTUK7nup+/+wNCJSO9UK3RUa5yncsTc
 TjRc3hx29mIJF0OJ6w2/wS+fUabqWzRFqH1YkZsFnTtx5oZMC+THyBIApJ1RHLi/dajO
 sYDMBaDeN97OQdHVSaBIXpBletvhwM5bgCvMf6ew3RCQtV9tVUyNyfAPBTwQGcI8Xbb2 VQ== 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
        by mx0b-002c1b01.pphosted.com with ESMTP id 368m0mc005-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Jan 2021 06:38:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WpIXNPVK2jRnkFQO1IoKm1sz2HySFynHU3TPSm2VkJfKttuT5vrYBtDNTslBeZ8Cii+YDS2hc2TMYTg1cPkpYx4ELpfp2boU5QkhL3vlhoBahaTPtYqaLu9olDPy/g2BpLD9HAz8uobymXzuA0yiwbdei9NqDK1tHKkqUn/aYdQpCDktYFm5RVQBV9wqyZQkfdONwhdXulnIovDlWwad6DL+UA0uKp8rWqvZ1JpXtSlQwInCsgrVn0g8km4MmGhjGOzBrZnQ2ivl7DPn+Qs9ztwxnRbEVS/s4sRfr/pvWZzJwWUBHgrxQ6dq0dqVKTFvt7TYDkBraft1IH8xW+s/zA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A4jxP9gtGLUS67XGPkUIUvR90swwnMZoDCFnxYReFGE=;
 b=lA4ixWIroNqkMG7r2NEfqTl1eialBCT7yTbvmvh36/XnGFDByfpqURX6XhajOcgint8A7Ye5dvEfB9dUS4dbewE4cvsryX0DirtUUR+gbj9wFnu0Wy42TuZesvLeq784yIhGIS036FzBD/rpF1bjlZ5mLCFFLqTwDM70/nLXptzUi4xstkmPT+uO4pXebtzq0GRz8CFcGA9axrdQpQ6QmKVJ+C8PF5MD9Oz+08uaDPhjmzb7UJwGSIf6YNj7eGBq+o6SH+byBovpHT/0Aut2cNznq1v6deX/lpHj+3YeIMX0EDdVASp1aTTIgabGMsSCPFIVx78/gtLDJw9G1NNPhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from BL0PR02MB4580.namprd02.prod.outlook.com (2603:10b6:208:40::27)
 by MN2PR02MB6174.namprd02.prod.outlook.com (2603:10b6:208:184::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17; Thu, 28 Jan
 2021 14:38:08 +0000
Received: from BL0PR02MB4580.namprd02.prod.outlook.com
 ([fe80::d853:efb7:2d8b:f191]) by BL0PR02MB4580.namprd02.prod.outlook.com
 ([fe80::d853:efb7:2d8b:f191%5]) with mapi id 15.20.3784.017; Thu, 28 Jan 2021
 14:38:08 +0000
From:   John Levon <john.levon@nutanix.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>
CC:     John Levon <john.levon@nutanix.com>,
        "libvfio-user-devel@nongnu.org" <libvfio-user-devel@nongnu.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Cornelia Huck <cohuck@redhat.com>,
        "john.g.johnson@oracle.com" <john.g.johnson@oracle.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>
Subject: Re: [DRAFT RFC] ioeventfd/ioregionfd support in vfio-user
Thread-Topic: [DRAFT RFC] ioeventfd/ioregionfd support in vfio-user
Thread-Index: AQHW8A/A4RU7AycUJk25Cn4pd6oBpqo5xPQAgANhTIA=
Date:   Thu, 28 Jan 2021 14:38:08 +0000
Message-ID: <20210128143805.GA95453@sent>
References: <20210121160905.GA314820@sent>
 <20210126110104.GA250425@stefanha-x1.localdomain>
In-Reply-To: <20210126110104.GA250425@stefanha-x1.localdomain>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nutanix.com;
x-originating-ip: [88.98.93.30]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 96d42a07-903d-465d-de28-08d8c39a547e
x-ms-traffictypediagnostic: MN2PR02MB6174:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR02MB61745D3E36E193EC51B97BBA97BA9@MN2PR02MB6174.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 51LglCCyk9oInEuY2aKClprwHMyNtaLofXul4tivhwVjmhwVXOjYNGgYAsQr4e3IW+03ltRe+FO+qtAM89Uuo05j4/cWI0WQnAQBjQOHmZj0dICPAIh3Ba97IHQEfQ8QSfX1yfMT7D9lj5yPOr5mGwIRq/3EjDx1b81O39/LjZiy3hdhlU0YDvjZ6FhocQ8v7AlO4ispzgISyADQ8UXvjMY0Scif5GK6AcXtGHxN1zp3Om20qL6LOzx/cJ5X0+D9H9pDov9BcQXQC/SP8P0+ihv3flkBfWN6vhuor9TZVrtNtvgq3EoIlfBirwwjX80YcU/mnfmBnjq9ZIshDLGy9fY2eVPUlGvqA0zGnJ8aw4tvPVV4ajf2/hweREXEHZ2lCqamYuP2joYcvx8Gf9r3U760Vg2g659jHaCD3auKo7X59a2BQ3AO9X7UvIbCQypJNZyXJ0UHrsLx/RRwzxTgljdpUDlUiDrjCRVtPJ4q2J0PZ/u/tho87Av2B9T7p5+UEW5w1qY+h5LkUdZ/MBEAQrjcdv3HreYffSWdhCirZyFQScOhVcic8Bl4LzPNVKUn0BBgR3ymDOgWB80sAFIItP//0q0K/zmI21I8y3mV3lo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR02MB4580.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(396003)(376002)(39860400002)(366004)(346002)(136003)(54906003)(6916009)(2906002)(71200400001)(4326008)(6512007)(9686003)(33716001)(966005)(8676002)(1076003)(66446008)(4744005)(66946007)(66556008)(6486002)(66476007)(478600001)(64756008)(8936002)(5660300002)(44832011)(6506007)(33656002)(76116006)(186003)(86362001)(26005)(316002)(91956017);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?2ukrrD54I1XeURrJfIHhvFe0L5JZmxDcpGYpwp8+whQDTxM+amXPYBSTOBRK?=
 =?us-ascii?Q?ONSfGM8kOL8r2hP9hzthpMiwes1HBzxLDsI+aLiyGgPPc+Jqm4FqNt7ExWed?=
 =?us-ascii?Q?Rf+YDTMRzto4r2pxTRRm29bYtseMlE1rZaO4UA72RqMK1rkUJq9xm57xIpIR?=
 =?us-ascii?Q?/mEPFDuvJwRNNTh3YO18fiUhW1CuuzVIAXt5Kc4uKajpGCdThq6jSYxde+aH?=
 =?us-ascii?Q?zqltGRdmoi/Us8KcZRs0bPcpRsHn28ydORflqchAiSOU+AfAOPQxjI+BmNJE?=
 =?us-ascii?Q?omQDGDC6Ex9Fw8e/jHTkEa+FewTzU05uOvYvrRz77Y4YAN3P7+SM3yEq0Ady?=
 =?us-ascii?Q?EW6X1Q/gabVmTxyoLBAgsJSBZo697yWHewelXbOLVB1yPofx82CBbXCXepv9?=
 =?us-ascii?Q?2kq69GWUoomalYLR3EDabRSaOtYqqy/o7+gKc1McMBh4NesbcxK9zVI/mRyX?=
 =?us-ascii?Q?ABIv0I0btOg5CAHM7USMvNqUuRE+Xta8KD+CuzekGWZb3bFMvQmFv9HXIfxz?=
 =?us-ascii?Q?xjR6AlMsUi+B3t1OQMAaq11Jzt+ReFBojdjOwDv1/g/6akRyhJvKBTnre1/z?=
 =?us-ascii?Q?WeDTeWrti8Jve2/yS3Zq4ZdevJEilDclIAyrqx6ze3PB3G1v6Yk4G+nY6ZC/?=
 =?us-ascii?Q?YrmBuGnsjDgdGk+VwBWkql5kpPOdhQGu03kcotnvAHW6NJ+MEWxUdpPz2F3Y?=
 =?us-ascii?Q?0GH4vIaCIhZ8BP4M0hBZIpp2ycIcVNg4NZWTsH343FJa6V+Jg3AmOz5xCUAA?=
 =?us-ascii?Q?BHgOS6ORObdnLazxkBUjrHDmRS2teZAUdb5kqlKcv8Fhqk5hUXVqP+evkP6+?=
 =?us-ascii?Q?Dwh7RVIVTd0SoasVJ6E18O/y1pMRyaSaobfKQ2HbN2lbhL6uKTOUQm6FPwBB?=
 =?us-ascii?Q?1k76p2Svy1QHwSNLDgWlCc8dx6mE5WgzxQp7r1fGAFgKs9YiSQja0Pyau4Gn?=
 =?us-ascii?Q?oyiiafyNT4kDZb59EhS0mei0p9oMcrcbWwbFhsCcf0rdea/QEjMTmju/vcA+?=
 =?us-ascii?Q?9rJ2kretzjFbVcgLlkhhQPY696SsPNGvoPEuOrLjMRcISQ0yZsU6q9ln5K+3?=
 =?us-ascii?Q?hXrwCSFS?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5A6353160F83AE4C801B2F37F2107E0A@namprd02.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR02MB4580.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96d42a07-903d-465d-de28-08d8c39a547e
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jan 2021 14:38:08.2315
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qG+AmxlN9zzR/GRX7QqU6qDN3YS0UCb5vw4PvbXHH0AnrmVcMa4cLSsP30lsz/rgdKnDSUNNQ9cW9lfq3ImcRg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR02MB6174
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-28_08:2021-01-28,2021-01-28 signatures=0
X-Proofpoint-Spam-Reason: safe
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 26, 2021 at 11:01:04AM +0000, Stefan Hajnoczi wrote:

> > 4) (ioregionfd issue) region_id is 4 bytes, which seems a little awkwar=
d from
> > the server side: this has to encode both the region ID as well as the o=
ffset of
> > the sub-region within that region. Can this be 64 bits wide?
>=20
> The user_data field in Elena's ioregionfd patches is 64 bits. Does this
> solve the problem?

I had missed this had been changed from the proposal at https://www.spinics=
.net/lists/kvm/msg208139.html

Thanks for pointing this out.

regards
john=
