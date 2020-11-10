Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17EF62AD838
	for <lists+kvm@lfdr.de>; Tue, 10 Nov 2020 15:02:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730270AbgKJOC0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Nov 2020 09:02:26 -0500
Received: from mx0b-002c1b01.pphosted.com ([148.163.155.12]:32656 "EHLO
        mx0b-002c1b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728478AbgKJOC0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 10 Nov 2020 09:02:26 -0500
Received: from pps.filterd (m0127844.ppops.net [127.0.0.1])
        by mx0b-002c1b01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0AADrbsR001874;
        Tue, 10 Nov 2020 06:02:14 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint20171006;
 bh=wSqp+4I9t+sZioS9rs5f4iD9+lQlC1Dte3F/j2c06pM=;
 b=z966YPK3NkEBTyL8l3RtGn0BT40wvAVPwpWqtzPhj5TiIIFWP/LcMjs2EF7ule5BYtkq
 bkEyBPozV1xpNPy4D7h6X8INAJJynHvV9JvqYUDWdhkbOcna8nYcanzSmgAYrF31gwGU
 auiDpQLFwUpC0npkJNv3Sr9+jSeqYHKkRBy9vCMKfaXZ9d90caNAP9wEP793C59KPhSn
 HSB9gqHVV9uG5d4jHPE1qUpyUfw4mEiGF3TDzqUL+up/xbYLGo9jlmxf35Lv/SeVrGnc
 sWaF6sb8i4701VUdBpGjgbGselFFt/sBkILerxfHGDDGuaMJU8ODjwpNpU3Ms+KbR5BH 5w== 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
        by mx0b-002c1b01.pphosted.com with ESMTP id 34nv04x315-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 Nov 2020 06:02:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b80ay89UzEigiTrrkarCL9dZc6QZZk7yLsr1RIFXZpFvMDBTUK+whKZoRMCORlc0hZ7zYb8O/f3pDz6iEHGNUuwBeRl8XEjdfrfY9a92JHbnl7aKKqFOQ8zzIe0hW7SbFKvnn3KtnB82iwiePWA+H3ouciiagTnD9IKIDrHmQphLvscJRdTTsoemPaZsRjSlR/prfS1YIpno54zuLOCl1bmC2xBicovFQRdDYVu0kvhfs79MuE3LpDH1MYvwM4S5CAd8q86vMWuv3hBBb/Nhv5TV2NkT5lXB62lFwZpOlseNJVDYmPhYua1LwERTosgGXsK/u5DEx3g3LtLLENmGMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wSqp+4I9t+sZioS9rs5f4iD9+lQlC1Dte3F/j2c06pM=;
 b=BEYTEGn9iEwSi/tPCfITEyiMv5dyUKRSfCJfPqqcdXMV4D+nclz3DRmQcz/CA0VwKGvyWe0uZBU9qhNLucr7XlluTu3AYP4CSFpcuyjbaizm8YvcyiEQLLMepqpOt/aGd2W71eLuSU1PH/8vTfoHJuWOMm2gDRPBch9Z5xelG3BeMjmNUh583uYbX3P+p0zSG3u6Ul45LvzIYzGor1g/8Y/WjIDfUVjpNjn+BusxF6bAaejGeHpTivUx7+3gf0zVUGS92mzAzKX3j0SLSHQzxKuyIaXKcrEsFUnaxNgMDC1oNh+rrjmaQdxlUAdPRDewb5BqD5YfCLxwHVa+R0nGdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from MW2PR02MB3723.namprd02.prod.outlook.com (2603:10b6:907:2::32)
 by MW2PR02MB3849.namprd02.prod.outlook.com (2603:10b6:907:11::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.25; Tue, 10 Nov
 2020 14:02:13 +0000
Received: from MW2PR02MB3723.namprd02.prod.outlook.com
 ([fe80::950e:a59c:cc5b:4908]) by MW2PR02MB3723.namprd02.prod.outlook.com
 ([fe80::950e:a59c:cc5b:4908%4]) with mapi id 15.20.3541.025; Tue, 10 Nov 2020
 14:02:13 +0000
From:   Thanos Makatos <thanos.makatos@nutanix.com>
To:     Thanos Makatos <thanos.makatos@nutanix.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        John Levon <levon@movementarian.org>,
        John G Johnson <john.g.johnson@oracle.com>,
        Swapnil Ingle <swapnil.ingle@nutanix.com>
Subject: RE: clarifications on live migration in VFIO
Thread-Topic: clarifications on live migration in VFIO
Thread-Index: Ada3YuV2NCnGJFSnQQyV1IuvmCnhMAABw5IQ
Date:   Tue, 10 Nov 2020 14:02:12 +0000
Message-ID: <MW2PR02MB3723A5DD2F798D9D618037BF8BE90@MW2PR02MB3723.namprd02.prod.outlook.com>
References: <MW2PR02MB3723556EAC82D2EAF13B54BD8BE90@MW2PR02MB3723.namprd02.prod.outlook.com>
In-Reply-To: <MW2PR02MB3723556EAC82D2EAF13B54BD8BE90@MW2PR02MB3723.namprd02.prod.outlook.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nutanix.com; dkim=none (message not signed)
 header.d=none;nutanix.com; dmarc=none action=none header.from=nutanix.com;
x-originating-ip: [78.149.9.252]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e5004f93-b0de-4abb-7f49-08d885813943
x-ms-traffictypediagnostic: MW2PR02MB3849:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW2PR02MB38496C07BD554FE3C88EE20B8BE90@MW2PR02MB3849.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rt6Nr/UMH5uqhvCx644Rwy7hBBE0RJNFwAASEFJ1f9wMVsNOicpGUspm/YcUeXHkLD7wudImLVxdjUgr64YIfulFXNwQkDzH7PSCJkO3s2heJCQoP+COQFygI/wjZPGODwVP/OUSu44qsSYZWvH9aYQPZjkzyfOWAStLsjAZ5QanpURiohOrUzUl5J5Rb44bqdwCVreQzm5Cda8k3P1YOrOki22oKmkjOG/WzFofhgEmGM3hAV/vWIh//oPLs1RNcxpvthkoR/QeIwnbgVFyQ7l3XGcLcdrPGIBLQ90iQ2FwUBZchlJgp2Gnr+j6PzcqUiuAdaKoMcFw9s+/ippiWA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR02MB3723.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(376002)(39860400002)(396003)(366004)(71200400001)(110136005)(8936002)(2906002)(33656002)(66476007)(66446008)(6506007)(66556008)(8676002)(558084003)(54906003)(316002)(26005)(64756008)(478600001)(44832011)(4326008)(9686003)(2940100002)(55236004)(66946007)(55016002)(52536014)(76116006)(186003)(5660300002)(86362001)(107886003)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 4SltoD78eBU2A4OWHaKZ3rB4Wgh6q5/sRxe1HJc+xNW3BTp7YqKsELsqzeJ5t3KuaxsOC9/vMWx5VNcyl9ewoLYmju66rxdJ5NWmkDb+PMciqFS8y0D1e3QDNEv6sGbQFUaiWyZjDMml+jCc5PjYE3jxaZh26Z0FCHUi6ui+oMBVg32EWX+PVA8E12UbUT37Z/DgRsCpK7LrNt5QOvfLhbWPSYE6KXIPw/OqXCSC52/+X86FiUL73QcjV+Z6oR2ZCWEyyqo0ePF7t7fLlcFwklkrTZbWM20OieQj05JKQi5NGuKOSoZBbq7y7i+sLx/a0rdsL41VpH+69YyWPzBvaSLJGzthyeYu2zx4Po9ZaYbqUxsaZbDg5sL8V8GR/Fqh0mNOAAMYYJkP2DRPV8y7StIqrP4WqZ1tBgXRli5sl8FJSxx6htZOAzMxjSBBasho5aZRGhOJp3TAmG1ZnkneHSMJUvnyhwnl3iX3TWLKByf9crvtMIF8+DKMejPZAi04xHOX3tqiguX9HH37vUYLN5WIV1GLG4bA6ineeh2pmZ80PgzJhE8ys/Wh6h8GQFHtmvK05SXhigzQmhsu1g2skQM8CEnAJky3xmF8I6/n2Fsd7/Q2PbDMLRj5C4jVVmWNKcTjcF/kR/qcJMbv1ha5SA==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR02MB3723.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5004f93-b0de-4abb-7f49-08d885813943
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Nov 2020 14:02:12.9845
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sUesbh8sELp8yV9SCeVAjwfPqmO92F1Ye5JLND3das0l5L9wGBKGWPFJdSxBYwA2eN9A1Rz+9JD3u0WbT8AnESyIocrkunmIAWmZOObmxI8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR02MB3849
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-10_05:2020-11-10,2020-11-10 signatures=0
X-Proofpoint-Spam-Reason: safe
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

>   I'm not sure I understand here, does this mean that data_size and
> data_offset
>   don't change during an iteration, even if the user reads migration data
>   without multiple read(2) calls during an iteration?

Correction, I mean _with_ multiple read(2) calls per iteration.
