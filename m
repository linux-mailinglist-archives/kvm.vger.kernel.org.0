Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22EF066A0E0
	for <lists+kvm@lfdr.de>; Fri, 13 Jan 2023 18:42:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbjAMRmh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Jan 2023 12:42:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229777AbjAMRmK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Jan 2023 12:42:10 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 653957F9DD
        for <kvm@vger.kernel.org>; Fri, 13 Jan 2023 09:28:28 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30DHB02Y020766;
        Fri, 13 Jan 2023 17:27:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=yhg1cROxP+dRJ/158UgxZ3uSIfx7vvGw4cAUaPn3Wug=;
 b=hddB8MHDkZcP0v8Y+XmfhDt0C2X5/em045XkypQGRA70hPGLoieE1HAmmcRvqqMD/THE
 2zGBw7h6vsSEVpv+9MMWgDBZSBHvvdONqW1VxVrRW71fyeOnIFxaZmsPA3oUBhjTv1AK
 zoY/zlEk497GN9a04XHi+iciRDndZsMyo8jY4Di1XgM0P/mVaxPo9z2mHktivo+jA8ja
 ok295mtbT7jGj3nB0kvJzFnQJ/z+vNwihHVQBmxg8v/t9gcEubpzrdKrkEjsYe93VIJI
 iIT/yPD5bjtyZjoeINotlrjqHQPMZwFXV7sYLUZMrwYWfDfUSaq2h13cEfZD+FyXU02R vQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n33spgyxx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Jan 2023 17:27:40 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30DFt5Wa008339;
        Fri, 13 Jan 2023 17:27:39 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3n1k4sf7qt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Jan 2023 17:27:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C0TZC/Dlvnwmnk2zxVIqsQKOCL86vkG1ziCxfmjI5ukvmtz5FapxjOJSgEViKbDEt6AWgnAZDiaHeduavzmvApZISUdIk9P3pCgm5zGH6H3juUXTO2pyB30ltq83K+xJ240I2TtS4azD9ydeTU6nwkS6oxFTnm5sEIq4DESZ5Loa2K/TwTpACYY2+Tg99HT/9PBnV0fyDe+FxAcCde2EDvHnyCH4Fe+kMMjpAp+TAO0erQaCJGthcrrj+xVoxzVgmj/D9V5uqeG08tcrRQWDe6VMvY15r1HoCdmbCXlcAHVACHoxZ4+jOYYgU+zkiPQ8ZCg56LV9rBccZlZAjO6hVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yhg1cROxP+dRJ/158UgxZ3uSIfx7vvGw4cAUaPn3Wug=;
 b=ezd8zub44+28zm60GjXQYCZml4QkeycVDaevJF1qAlc+7IK8JzXyKfbopDgsn98OQAtps1hFhU8I1Ro1yxTPWrBITOEH7NTANI6H8qJ0gS55XG72myJdrf9jpKMEsIVrx2o/+lCkl3ofeW6srYe5MQfzLkvUP90tBO6OBHNKI5UTlBT+8LH4AmO3blvZe9rxz1lo2HbRO6sXRk4k3KbHd5r9Gvv6boHnIJk5ISp4/Ij8dmlkKGULA1hePV1ronsqF9qEbMZCgSVqxKggtifkNTsNF20KM5gSurBU6qAi5/L0hU2EtNd0RJdvyK76HDDwANO9p89pk4UPvJ7vzeQhNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yhg1cROxP+dRJ/158UgxZ3uSIfx7vvGw4cAUaPn3Wug=;
 b=UXN61aSB5SmRLfO3vT4xxcp3jqJiE5KTp4/bECB9G5avAYMJKbLH7InkP5OggqtkrdWjKMf1xgnSpO7/fLZfqovqhE/F6NFMXyNh9IN3pyHazhPYJq2iL4rJLnNhRjvZ6s/eaa285PIQXWUNWCK413rvmIFAtAsiUsG17brB9dM=
Received: from SN6PR10MB3022.namprd10.prod.outlook.com (2603:10b6:805:d8::25)
 by SJ1PR10MB5931.namprd10.prod.outlook.com (2603:10b6:a03:48a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.12; Fri, 13 Jan
 2023 17:27:37 +0000
Received: from SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::a02:2ac8:ee3e:682]) by SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::a02:2ac8:ee3e:682%4]) with mapi id 15.20.6002.012; Fri, 13 Jan 2023
 17:27:37 +0000
From:   Liam Howlett <liam.howlett@oracle.com>
To:     Yu Zhao <yuzhao@google.com>
CC:     Pedro Falcato <pedro.falcato@gmail.com>,
        Jiri Slaby <jirislaby@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        mm <linux-mm@kvack.org>, Michal Hocko <MHocko@suse.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "shy828301@gmail.com" <shy828301@gmail.com>
Subject: Re: Stalls in qemu with host running 6.1 (everything stuck at
 mmap_read_lock())
Thread-Topic: Stalls in qemu with host running 6.1 (everything stuck at
 mmap_read_lock())
Thread-Index: AQHZJZLE7wnGvcxcYkmTyh5912LaH66Z8PiAgACCIICAAipiAA==
Date:   Fri, 13 Jan 2023 17:27:37 +0000
Message-ID: <20230113172730.lg65yzqw2nhvb77r@revolver>
References: <b8017e09-f336-3035-8344-c549086c2340@kernel.org>
 <CAKbZUD0Tqct_G9OcO8ocdH1J_YvLSEod-ofr97hsyoHgcvBwuw@mail.gmail.com>
 <CAOUHufapeXp_EFC2L5TFhLcVD95Wap2Zir8zHOEsANLV5CLdXQ@mail.gmail.com>
In-Reply-To: <CAOUHufapeXp_EFC2L5TFhLcVD95Wap2Zir8zHOEsANLV5CLdXQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR10MB3022:EE_|SJ1PR10MB5931:EE_
x-ms-office365-filtering-correlation-id: 8eeec812-6d78-4812-4592-08daf58b7703
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GIEfEtwGEBYpBPybiU47a2167H9PiOJcCfhe43BnXdW4avFlmDFOkPe6CR27mvj0tAvIxL7/kbAU5yCP8ZAuyOfscr98ZPAU5eUUDlFEVKgWMJdsHzsqGIOcexuFGGLUfdC2g3SfSGXiMMcC1EMwfqkxaFcP76Pn3RE/0O6xjJ2AEL/YAzrQrLJEf5+eoY/lvxkhJfw+HRMNhdKGaffkrUwrN6Vg1RriqQhiHZD3/9J/fKdK5eD8xIVJZOhhhkFvjGJJzJ4ro3dtU6JkOXnOgLUHwUCQMQlgcjX3xWNMIDGT7lCAbOkApTPSFykM45cmkFIJw3SFEBVbPA01Sg/tjuyDKAlSIByQqVoHxMoPYNtmDux28pZGK/TVvjlTcxq1Q0sLC44qQmINob5y/6kedOaquZ67piui0TATQO4OvzVeI0JFADIhq0BUVc7HdjshzeRQD/fhoJPX44Ecmxnpxe8j5k3zq8wVEY1005nzQG9JLgvpctQXeW2sRVlTdoktENIiwfwjVkVI7vgXXePCwJPyRuXKdH7M2kSmq7t/LazhjyI6pKfKDjUf7TDa/wS5F95d8yYU9EFWueYefTG9K1If+lG1AnHoPVnKReA1bSgBKTQtWn4vm6WE+xPmn+ZgfgTN+Gv/WooJL1Gwfn++V41O4AZGv33Eo1fAHl3G84EfV2VK/LnSB+o3L9JGdy9ELGfk/DZHbD9ZYbz1qYlfipfYyp1UH6LqElDy3y4VhDD0ljgaxs2qFzuhfKZcyowq0nNxXZqC0ge9v1ZtkC4BJA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3022.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(376002)(366004)(346002)(396003)(39860400002)(136003)(451199015)(44832011)(5660300002)(8936002)(7416002)(41300700001)(316002)(66446008)(8676002)(66476007)(64756008)(76116006)(66946007)(2906002)(91956017)(54906003)(66556008)(6916009)(4326008)(71200400001)(478600001)(966005)(6486002)(186003)(122000001)(38100700002)(9686003)(53546011)(6512007)(26005)(6506007)(33716001)(1076003)(86362001)(38070700005)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Po1FStqHQE9DYZ4/GQMuBFTYdIzZKTKzcFbm+vt1ZOAKlcrbq7YbmsxlDlnz?=
 =?us-ascii?Q?uAdntrqOr83cPx42JLG/3c7dQGhmq626I1BZOwZUzPI3RTOg9krsAT3XZiU0?=
 =?us-ascii?Q?jvhMxAF3fI5T7jY25yJp9vqBK98UxssJv9QbBglPBgXAq8RhrLmSB3cE5c8R?=
 =?us-ascii?Q?PVqgEkXHlCKUGjcxoWWvZKLOG2DK85bR3Rp25Py6Ukn487Im0ZuHhSxgH2PY?=
 =?us-ascii?Q?/4X2L/1fsM4fn34Z2+8KKCnY0I+xTzwGWU5Gm852fmHBk0nn7RRqWfrYFGqe?=
 =?us-ascii?Q?LvQYHEA3/Fsvu7KNXMmVrrsRd65sZGwaJMH3AlXIck8oVmCfYDVvBuFTTHZe?=
 =?us-ascii?Q?0hk+CMLIglcDlhq8XaVH/68zND9gYpAXAU4c2XAXIWTOAy5HoTc4qw35A1Cr?=
 =?us-ascii?Q?o1PXHeIOdpqmz3q9/KgwZ7GcvC0aq0Itxk7Gb7VW5GZFXGz9gQpkyFlYh0Bg?=
 =?us-ascii?Q?+gWGSjUmTbLon29thM6tzOg3evP8121A0sMJQPLlrNyRolYviLuuC3PbSykf?=
 =?us-ascii?Q?64cpP/nKH7gNY75psJ+CBXHwuVR1bhf0+Lh9JFBWWciMtp1QfDGyaW9CkZB0?=
 =?us-ascii?Q?wPPnbF4TwA0/m3x60AacCVJluJyHnx9o+yNdHa6SIHp+6ScN4DMUdddpm1BF?=
 =?us-ascii?Q?McE5XStHrdrgRHmlNWOkiaxzgOI15+/VqHsbs80l5W14frL4cjOn7+py8KRM?=
 =?us-ascii?Q?bXh83vUNAB9mGjtGrC6l5I4cZgFC3ji7hfjlezN5xvWp0dlGv/wMEEJoyJia?=
 =?us-ascii?Q?49I5KwCRc4KYXEzafMzI01TOPymNud87s5ql24+bnZ4wtPSyqP6I5mB71+TU?=
 =?us-ascii?Q?curUGE2Via0wE7nBziQN26puis8c6dYlL1j6TkQ+lZUNeF7I/kd1dLknP6r6?=
 =?us-ascii?Q?OtMMB6OIo384Pw4fAQirle5KB7r69FsohRAv8jUcaPYPk43Gwx0K0iRL+X8k?=
 =?us-ascii?Q?rnhM5GWVXpSL80IGynFuiNGWpd8C30rMJAQ9/i+MZzP+r8O3Wl5Z+UxSdt98?=
 =?us-ascii?Q?J1vRMS/tQ3JrHWFVSTVRBqSRn7xQK62qHsALBW381JHtuKeSFdCnl4UgeRo0?=
 =?us-ascii?Q?maspJrbsL8TFroI8LLgwpLp2/meENB+Ts42aSwnQKUtBP/XjHlFCdmVRYlgq?=
 =?us-ascii?Q?wMoIZngldLwcFahy4ANxhyOVMkFMykugNrHgKRXPhJj7bNcUnJ6eXs3c419f?=
 =?us-ascii?Q?3mK+pelwypoGVLzKPx38xrsG+xZPDRZQWlYOtzeY6HTCAeSTM4l2wMu5k7Sl?=
 =?us-ascii?Q?m3nsWqPsgRvKpQcra7ECtFBjYwn7R9iIKB2hOdYmS5rQ0GR0uk3EVD4J7rO4?=
 =?us-ascii?Q?GTgL/Ohf8s4GBkcLEak8l7JnInWmtYxCNnLwiRgIa4oTDKkAztLnmJYSS+Iw?=
 =?us-ascii?Q?tBRLmq25er26AvDSRNoP3qql4Kn3fz4eDYkD3nmPK7RtdqmNyleJlFVnZoxl?=
 =?us-ascii?Q?RXNywoE30R9QBpjt1HkjM7AVvEUqe7I5Yo8pJxt7eF7fHqkvAqrTyy0ZwAdM?=
 =?us-ascii?Q?QF9DRXr8hNT7aYo5RMSEfRFUhGuGvsw7ioOLF2gBFj0wl/wqwc6KOaqghPHR?=
 =?us-ascii?Q?RJfdXyNBuqh5+pi0Pn0yLBT6x73axL4BlZB9W3RXezuLZZVQqYkBcKmMGCxW?=
 =?us-ascii?Q?7g=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A9A7CCEE639DC84381370DF8DD46CFAB@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?gNXyIHXCo1NhVeftEcZKPYPV03pBQLdouosjDrgv3Dw+vlpg7Ocr0Ndv0D/Q?=
 =?us-ascii?Q?JkN6kqvOr4TliFuLH70F6SQ6Uaep+KikpQ12mQE9RO7xqi5L1+2LpVbJzfL4?=
 =?us-ascii?Q?qdPH0pSfDv0CLVpDL3qrCpnpQkzciYA/RcvXqhZFiwZVtI8ezAxZJS4FjW+O?=
 =?us-ascii?Q?lzWbJmfM+wK5Hqj50ISav7l5rPLs8oeflLgZqfmsHAQM2VAZjV667E0CRpO6?=
 =?us-ascii?Q?v9TqwojsEikr7hf0T4I3Nl59l8fZh3j3/9Fu7Fs1Ab2VJoWVLbWtVfBZROEP?=
 =?us-ascii?Q?0QxU8M3XKL84O24RcNZHKDW9wWv3sThHNiUcRqAxl7ifDmzrxNkE6GciSy7y?=
 =?us-ascii?Q?aMdnzw+y/77EEAcRU8PVyoeCv2GExk/g4tsIi9gACZ5EomMe9OBHSh/gAt02?=
 =?us-ascii?Q?tP21Zeh2ZNWCpGgAW+NZTr4YlfJGlEP2+KYH+siapXuFqZkVe/k4LTdOXRyE?=
 =?us-ascii?Q?CZ0ANUaKOzibSO3FesD93ydI842VfjzikpxSlVztaoi3uwb2h7MSx7uRVe80?=
 =?us-ascii?Q?q41/tSGtbdgEZGwVbC9YLiB8/WegTv7w2m1sNEPC+fs8IuqvKli6/DyIE2gU?=
 =?us-ascii?Q?7N/Muc8rdsoU2JpqQviAIsctMdt60J04wtRgKpnkOW3aZlMxZgPg0/I/z1Jz?=
 =?us-ascii?Q?4kDZfbjzo8u/LwTkrN9tumya2GnSi03xX9b4M56ctiB7doHR0O4DsBHGrEtV?=
 =?us-ascii?Q?wkkZPpodYFIgwF03uqGseli3cCfEABcI/QfCVqDSiTKjCZ0bdg2kHqPFZU1q?=
 =?us-ascii?Q?MaFPLc1gy4q4Lieke/gmm8NFXiWkJ3/czZAiJ2hc5beTNe88bUET6jBJz7hk?=
 =?us-ascii?Q?gupJOoU61ON2l939Z0swQ5sZfK99MmsbYc/S4td7oVk3KdrZfNRIEplit2xr?=
 =?us-ascii?Q?iiY1e0+1Ej5A/5dllOWyNuCZDuF+Hgy4orhPTOHe0gRDVunBhaATvhMxQQSf?=
 =?us-ascii?Q?Tvl8UUrS/5aaNXwjHQB3mB8LBjT0/S4wdOdab8Ideb9s9NYCfomw2SbXqhGk?=
 =?us-ascii?Q?qDA2?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3022.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8eeec812-6d78-4812-4592-08daf58b7703
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jan 2023 17:27:37.1996
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iNzfNuqO+x++5f/FFyWdyp5A1wD1soQ5bAvn74jUHfeFZhazRuXW1Ml3wmK1ZyeC2qvjCYBuKhSm0iKzaByU2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR10MB5931
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-13_08,2023-01-13_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 adultscore=0 spamscore=0 mlxscore=0 mlxlogscore=999 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301130116
X-Proofpoint-GUID: 87rg5Yum_PYbs2lZf1diAqAgLTWI9HLR
X-Proofpoint-ORIG-GUID: 87rg5Yum_PYbs2lZf1diAqAgLTWI9HLR
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* Yu Zhao <yuzhao@google.com> [230112 03:23]:
> On Wed, Jan 11, 2023 at 5:37 PM Pedro Falcato <pedro.falcato@gmail.com> w=
rote:
> >
> > On Wed, Jan 11, 2023 at 8:00 AM Jiri Slaby <jirislaby@kernel.org> wrote=
:
> > >
> > > Hi,
> > >
> > > after I updated the host from 6.0 to 6.1 (being at 6.1.4 ATM), my qem=
u
> > > VMs started stalling (and the host at the same point too). It doesn't
> > > happen right after boot, maybe a suspend-resume cycle is needed (or
> > > longer uptime, or a couple of qemu VM starts, or ...). But when it
> > > happens, it happens all the time till the next reboot.
> > >
> > > Older guest's kernels/distros are affected as well as Win10.

...

> > >
> > > There should be enough free memory (note caches at 8G):
> > >                 total        used        free      shared  buff/cache
> > > available
> > > Mem:            15Gi        10Gi       400Mi       2,5Gi       8,0Gi
> > >    5,0Gi
> > > Swap:             0B          0B          0B
> > >
> > >
> > > I rmmoded kvm-intel now, so:
> > >    qemu-kvm: failed to initialize kvm: No such file or directory
> > >    qemu-kvm: falling back to tcg
> > > and it behaves the same (more or less expected).
> > >
...

> > Some data I've gathered:
> > 1) It seems to not happen right after booting - I'm unsure if this is
> > due to memory pressure or less CPU load or any other factor
> > 2) It seems to intensify after swapping a fair amount? At least this
> > has been my experience.
> > 3) The largest slowdown seems to be when qemu is booting the guest,
> > possibly during heavy memory allocation - problems range from "takes
> > tens of seconds to boot" to "qemu is completely blocked and needs a
> > SIGKILL spam".
> > 4) While traditional process monitoring tools break (likely due to
> > mmap_lock getting hogged), I can (empirically, using /bin/free) tell
> > that the system seems to be swapping in/out quite a fair bit
> >
> > My 4) is particularly confusing to me as I had originally blamed the
> > problem on the MGLRU changes, while you don't seem to be swapping at
> > all.
> > Could this be related to the maple tree patches? Should we CC both the
> > MGLRU folks and the maple folks?

I think we all monitor the linux-mm list, but a direct CC would not
hurt.

>=20
> I don't think it's MGLRU because the way it uses mmap_lock is very
> simple. Also you could prevent MGLRU from taking mmap_lock by echo 3
> >/sys/kernel/mm/lru_gen/enabled, or you could disable MGLRU entirely
> by echoing 0 to the same file, or even at build time, to rule it out.
> (I assume you
> turned on MGLRU in the first place.)
>=20
> Adding Liam. He can speak for the maple tree.

Thanks Yu (and Vlastimil) for the Cc on this issue.  My changes to the
mmap_lock were certainly not trivial and so it could be something I've
done in regards to the maple tree or the changes to the mm code for the
maple tree..

There might be a relevant patch [1] in the mm-unstable (Cc'ed to stable)
which could affect to the maple tree while under memory pressure.

The bug [2] would manifest itself in returning a range below the
requested allocation window, or the incorrect return code.  This could
certainly cause applications to misbehave, although it is not obvious to
me why the mmap_lock would remain held if this is the issue.

1. https://lore.kernel.org/linux-mm/20230111200136.1851322-1-Liam.Howlett@o=
racle.com/
2. https://bugzilla.kernel.org/show_bug.cgi?id=3D216911

Thanks,
Liam=
