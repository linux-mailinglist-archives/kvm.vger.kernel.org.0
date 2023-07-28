Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 884BE766B51
	for <lists+kvm@lfdr.de>; Fri, 28 Jul 2023 13:03:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234567AbjG1LDO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 07:03:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233575AbjG1LDN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 07:03:13 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76E4E2701
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 04:03:12 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36S1Bxel002169;
        Fri, 28 Jul 2023 11:02:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=JIcCgiWDrKqc0GJ3uZKmzHdx2sSSVC5sISk8YPjb7ZI=;
 b=cn0qgal5c9PNZ9t6mQkN59sYqkVzl8+s/CuyzaIOkfrT2bBvnKlQyGQk83IKpmjMzrTv
 GzoxpU+EBFu5ebEFJsjErDZHW/32fGhezMH/fWOp+PxZddBRlTjintkguDjQRc6iRPop
 VVmH9BdCsepgq93U+vNiUm6/iPiE0pzO56lHqHxx/k4AWccj3u17zkaaV24x5QErxaFA
 DQFdU4HKHSws9tXIposeaK1adNvGEK9RryPsR4TRkn5simaHbz6YSw04lbjER99WYrWw
 +yuAcQYzlYpbZ6/K+ozDgBSbLW/p3EL18RqONvCEKuer6UC8fdDL5k+E/LRAWDKuXrNq Kw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s061cbqrc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Jul 2023 11:02:45 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36S9f52b029462;
        Fri, 28 Jul 2023 11:02:44 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2041.outbound.protection.outlook.com [104.47.73.41])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3s05j8vwh6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Jul 2023 11:02:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VKMoVPgCtZkKFny+AgK5lFCJeBd0pQTGH8u0oCRRfs8k18oU7TUbABtyU1Uwj2LSKbjo6s8PkqWimeSMNesUpnSkspjCN0tBdZ0rfqVb31LjJJS4jIedgLlVOkV9XBo0WkDYdlT2qLppiVIZUsdF55O537OWCu99wtLrbxo4Kne+5Uw+KKFMbRpJpMBgWsUho3LfM8TmTdtRaWF6tp+OxI7BJ90vjUpOc4f70oemelyZJ2wqrU3la7+DoBBRrbmbVOdfMl1DkwZBzdx91VpTOtnlA4ZM8oUaRCtPMsvgQ40dAmCYt34tkBjn3RtUG2iGeHug6NYVg0QgILmNboBwoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JIcCgiWDrKqc0GJ3uZKmzHdx2sSSVC5sISk8YPjb7ZI=;
 b=m4pbNSoj41h62mVQQrZE69bJwLPa8HaBQfF85FLPwJvnyMNe73E8H/R/85lLTwqW9yKAt5NZmdusK/fKNYnl2eJX3ut9NCp79SxSBZpRUyxu8hvo4vhuBTgOxiQWatse0Quum14F7fp8c4ipLSlGsHpJqqLaF6jz/9qy6lTf1Ezthb2yeljJUPtJeFzMqYFhA5TiIcLBlNxknthWGxMtCKI0aPn76CJbXjgbzsJwCMRkx2E+M9ZtQv9ViMuJvR6R2atB3jHUFVQh+WbAaUD44/RD0WKZV4olUyv2eQdq8E0Y91xwqxVypqd84Kgg8elN0bTjQ2S97hYwuJSuCImafQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JIcCgiWDrKqc0GJ3uZKmzHdx2sSSVC5sISk8YPjb7ZI=;
 b=WuALZCGiDVVKsReIilqRGpl0Rb6rzxUw+dgXObHLhRL9ZOMUdqOUuRWHHHH2jHO8m/lOI2beFz9XM0Qw/XwMrBh+U2MdDLcoRLyEQ9+hn13DtOehm4endCu++yLq90HT2+NLRZXXFLyy1GkPRJayZ8PaYe4R2RztSVqycfHptL8=
Received: from PH0PR10MB5433.namprd10.prod.outlook.com (2603:10b6:510:e0::9)
 by SA2PR10MB4555.namprd10.prod.outlook.com (2603:10b6:806:115::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.29; Fri, 28 Jul
 2023 11:02:41 +0000
Received: from PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::2cd:1872:970d:7c4e]) by PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::2cd:1872:970d:7c4e%4]) with mapi id 15.20.6631.026; Fri, 28 Jul 2023
 11:02:41 +0000
From:   Miguel Luis <miguel.luis@oracle.com>
To:     Marc Zyngier <maz@kernel.org>
CC:     "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Mark Brown <broonie@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will@kernel.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Chase Conklin <chase.conklin@arm.com>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Darren Hart <darren@os.amperecomputing.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v2 02/26] arm64: Add missing ERX*_EL1 encodings
Thread-Topic: [PATCH v2 02/26] arm64: Add missing ERX*_EL1 encodings
Thread-Index: AQHZwS3DaUVzwmqYwUidtS/g37NFHa/PA6UA
Date:   Fri, 28 Jul 2023 11:02:41 +0000
Message-ID: <0F0BA214-D9B8-4FD0-92C0-20EA0EE18B6D@oracle.com>
References: <20230728082952.959212-1-maz@kernel.org>
 <20230728082952.959212-3-maz@kernel.org>
In-Reply-To: <20230728082952.959212-3-maz@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR10MB5433:EE_|SA2PR10MB4555:EE_
x-ms-office365-filtering-correlation-id: cb37f3d9-210c-4140-0865-08db8f5a29ac
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: p3WVKyBRJ3QBq6b+vF6EhdjP+Yo6fTJr27bbLD/yrSlAsCY2IHdKVo3JdBOXsi0id8i5/cH4hnhkUZYKtfsXmI4p+gHkmHPRPnoDsvun26qMWJPbtfOmbK1NZOPVWQOsrjdVN1RedeuADjlk3TYADWSmA+s1xmFdkRie3qDHmgwm5tSao2idD7VNJoyA0jDDxUNtV/U0Mmo6Da8SOjnVQd+Jr9+ZKA94rAtscQM2rxHfNG6wkaLIsR2U4sTN0QfB2CIDtsSzfa70qgFgXtM6ZKth5k+9FTveBAUc42n3Ekg7+0VgXAToP7HHMfi93G8Isyxg7QVrq+xvQVoaewp0a3KluI8UuiD7NLis98fIzZ5j2qS44WjBnT39nw84IZpMvoaAmkXU0+6l5GsJoXsGJ2Hm5sg8litM2rWTSKK21+yfbCDUZeUW6tGOtqFJ7obn8ZU88pjanmOySOtwijW3zfJ1jRCQv0V7RonZuYoroEuPCr5M4EJ0onYKppSOmpisC0GQ/OQFautYVzrrHXuc4LbF6lV6i81eSznhxDs+NogMWCkusLUssUoP4bVUxmeyR5IieGtBLe0S5IA+7N/tj0qV7snKEvN4+haBR/tsECing+B/D/suKy5/YsTuBZt8+QgKdIACFz75kpUUo6hN5w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5433.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(39860400002)(366004)(136003)(346002)(376002)(451199021)(66446008)(41300700001)(86362001)(66556008)(53546011)(71200400001)(38100700002)(478600001)(122000001)(91956017)(6512007)(4326008)(8676002)(6916009)(8936002)(36756003)(186003)(316002)(66946007)(64756008)(66476007)(76116006)(33656002)(6506007)(5660300002)(7416002)(2616005)(44832011)(54906003)(38070700005)(6486002)(2906002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?yYbe+JsJY0Oji0JCqZozXeqbvRdGe/GcKefTSrEChoX+WhBII3EXI5nU6wEv?=
 =?us-ascii?Q?yo++Ftja/S6ahssCV17GR8NHPwF2YSv+wZSCZ2JG0msL5H/1LFCjD4nL8wD/?=
 =?us-ascii?Q?sAjrUVVX8T4ScDbfVXv8wH/YFnH/+UfypbjeTSNpKFJp6drBvA5P8oeRYZi0?=
 =?us-ascii?Q?hWOw1OLlbizlDGDK64N4LeorZvFIT6Lz4U8SL0sM0LODQHKkEC/sCBj01mfB?=
 =?us-ascii?Q?E+TDriHWS52JRJ/+65CdpOnZLRZnUIk4WwQZYAVeQfe4s9WZHQhuXA7/5rEy?=
 =?us-ascii?Q?uX0Lmpa0loyUAZfvJd47NeQU2h/TI2o2Bv16W11GtSRSmMjKI5m3lXZAympR?=
 =?us-ascii?Q?WVnmyFU81jbDWJly2p3jlfng2fLUdPp76FxJ9YZd7sRVNbj4Bp7oOpfofjMT?=
 =?us-ascii?Q?WrVjJLP1Oa3jjWTP4vlPHZR15nRPF+FMtg2Fjd4gEBfXXsmRoCO4xFF/H6wr?=
 =?us-ascii?Q?4YGSQtLJDbAnzoIl9BJkYUlEvGTM3dhFgfYTwJvngrYczXYu8CUlIrk37gIr?=
 =?us-ascii?Q?Q/ucuJBF3jyx95XNT2YinNzoj6/BMMYK0uQoDHYKOc+veV37hiiHw2irjiFT?=
 =?us-ascii?Q?2QxyQBlRkE6CxaC/kvIW7FHOCHBmF+HCjA8BnxqefjT/qMifP3wFCsKOi0Dd?=
 =?us-ascii?Q?5U9Vs6vLSuv9ioCnw7kCCp64ir9DnLntMop0NLCIH9W/25waLmqMsW4TNpuh?=
 =?us-ascii?Q?VWspqSiCsOH3qALYgSy+RylGviYht4VvjFTy84rw25/AsoMyPOtV6cNdkZM1?=
 =?us-ascii?Q?6Ft1b45cxOI5V2s0zXYuTwJGsNZHLEB/g16mBGCzN35W0yWIpnT0GzsUVk3A?=
 =?us-ascii?Q?WI+genbECfTmK6E+txa1Zr7a83f+SiI/fSlhZaZTFtRLyEAXleEpVkfujUBG?=
 =?us-ascii?Q?Dc4KILELWInlBJO9dbRHyXdN6eCByoxc3ZjhgmYHIA08ANQ2Vj1tgGtXj0WJ?=
 =?us-ascii?Q?U98t45dR6PXQrrgjEWX5+fME2BQwsQ6ENyiq1//RokPguC6qfnOXxw9pnaiz?=
 =?us-ascii?Q?Xm1B6pW3y2SBznAd0fE97scigA1zKfztVx+ZdoMOvCfZwvmZEav9UNM7zGGf?=
 =?us-ascii?Q?OE0HlbWn5UmzOQ3Ke97fFIHlwFVHtLv/KDPP5KQqAoniVbM4PL0hf/SMevC6?=
 =?us-ascii?Q?8yp7Frnp5WWZ0cp+wB1jvNkoQE+BFgzL/P+D5oK8DdVB/k1PHAXLS4+5mtk6?=
 =?us-ascii?Q?4xvfX/0+w/itjcx/Fx85RFJ+EIE91LoBpqkMK+BZmVm+aq3QIZfSWoPGFJPo?=
 =?us-ascii?Q?V49cLh1nWF7L26T/H9LOtMRAPpcmfuS4hnt3ieZ2jo7cWEtHtsTOK4AjYiGK?=
 =?us-ascii?Q?yGxHBUek6g0lfp2mECq47c5j99qe+nc8YeBj/87leGEyEEUFguCfA1gwXbDH?=
 =?us-ascii?Q?HcpQ35VwqmbuuJcTukHYPW0gKzA0DcwxibOmfNyouaDfBLk8z5Ehp2u96yYT?=
 =?us-ascii?Q?YxUNntKB+y/zER582dM/wbF/wQ8iRk9xbI22Idg2GPaAu/MY/24bjCcuxP/A?=
 =?us-ascii?Q?Q15h4Hd9fAkrNI/Q/wlUSBXpx7UY05lx8TlOSV2kL0mM2dXR4YtTha7c7mhy?=
 =?us-ascii?Q?9leL0sDlHhKhWxVbS/1wA3R+UsHNOoHtsbiDj1zLYLBWCgQu3Jfp6ZDBghN2?=
 =?us-ascii?Q?3BVSDK764AbMmZBWsLCD75U=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D6F3ED115304EB4EB612CE97170B72DF@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?htykHeStY1pxE8701C8o/PvjTIvvgahTlVLrMwN24T/87RygwkrFxaBXiEhz?=
 =?us-ascii?Q?8sXEaK3G1mHm5QZUmMnF4K90OMKunkpLDx0x4Kk64ztbMTAu8i1CeYBxwS7y?=
 =?us-ascii?Q?DjZvyF3AgQm3L3uBAUuDG1OmY5dEGtgc1x333kiNwzIiY51q4aL/hebiUWg1?=
 =?us-ascii?Q?ghgkmnx6mpyPa2N1leIvI/hCnI7//ff29RUTTiKeMpwBMcGV94QBVOWgs640?=
 =?us-ascii?Q?L2Xig57Nst3ulelGA8WXFwgRiqAgicz6gEkzEK79l2MXeGh+drUq/a1WKTn/?=
 =?us-ascii?Q?mMfu5USwAly1vi79XXLOiJ/WzIV9nobPk15oA7f3B/uayV1W6PkQ1xrBo48q?=
 =?us-ascii?Q?1Zb/tvSe37kwPMh0fAgOo+8IvUucwtWG5kjLc+cX71xR+J/Z1LHLonQEUXJa?=
 =?us-ascii?Q?Sg+39E+54lguOxu9ksmaY9c6wjsLkjhYhYozHpEOBvNGjlk1tuAY0nG7FbS9?=
 =?us-ascii?Q?Stmy2UPaZReAvc2NM6TWU5DYO4Z+mW8j3ExXNbRLcW2wNaoQwVevyypDUNZ1?=
 =?us-ascii?Q?lEwxv3CvFvkQ5/ZRe89/trov6sDRniQRj0egqvbewDq683cO0DYOCEm9pEkG?=
 =?us-ascii?Q?32Ol1HfD3dRvtgZJuXA13JR9PfI6Lq0JaPX9ue1zw4Eiqo1eMJnyZf8M/Csf?=
 =?us-ascii?Q?1SDzWpy+FzsmQv68zjQXWWWrXyb3f4IMswYz+aZvezKfuYkt5QzBdNBeuhws?=
 =?us-ascii?Q?JucgcrofPDzZf4YCTh+Y/5a06y05+0K8ASI9/Ofm4iLyNvaomeFcKowWwNRr?=
 =?us-ascii?Q?IiSJm4ITT7LfOi8yDKnFoq+V5iV1gW7q7JsDVChdPh+3BKvytS+d0uVjZlad?=
 =?us-ascii?Q?F26jUuRyEi82Gx3u4/cBX4jkVtgG+i7BreH3MtRH4pJyW6KM3zHdqCFRnJ9J?=
 =?us-ascii?Q?djfOHOSlY77U3XnZyKqYOKJl7LFAKXJjOPG9GTHwBNKjArCwlMk8Rc+9xVpx?=
 =?us-ascii?Q?FVfuyeey/Y6GyeMh//Wlt+/GXHeLtX0CaD1ShXRZZgitJwu0ibkav2h4oiQM?=
 =?us-ascii?Q?bRxF9ThZYKqVvj/ejWLa1ALRGBcOqI1S7jHkpRcvv8YRTrvBcv5/4S3TRNKY?=
 =?us-ascii?Q?s3h97Kbe?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5433.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb37f3d9-210c-4140-0865-08db8f5a29ac
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jul 2023 11:02:41.1811
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uKRuMsaNQnO75yb29F35Eask+U0U64tAo8Kg6HDRiJK0EjuUiFIWp0lEuTqmn89EW/R3R6KXY2Seqt779JjXAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4555
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-27_10,2023-07-26_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 adultscore=0
 phishscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307280101
X-Proofpoint-ORIG-GUID: -DfDK9IUzDoHt3B6gfvqTuyHRcJwjlTW
X-Proofpoint-GUID: -DfDK9IUzDoHt3B6gfvqTuyHRcJwjlTW
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

> On 28 Jul 2023, at 08:29, Marc Zyngier <maz@kernel.org> wrote:
>=20
> We only describe a few of the ERX*_EL1 registers. Add the missing
> ones (ERXPFGF_EL1, ERXPFGCTL_EL1, ERXPFGCDN_EL1, ERXMISC2_EL1 and
> ERXMISC3_EL1).
>=20
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
> arch/arm64/include/asm/sysreg.h | 5 +++++
> 1 file changed, 5 insertions(+)
>=20
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sys=
reg.h
> index 85447e68951a..ed2739897859 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -229,8 +229,13 @@
> #define SYS_ERXCTLR_EL1 sys_reg(3, 0, 5, 4, 1)
> #define SYS_ERXSTATUS_EL1 sys_reg(3, 0, 5, 4, 2)
> #define SYS_ERXADDR_EL1 sys_reg(3, 0, 5, 4, 3)
> +#define SYS_ERXPFGF_EL1 sys_reg(3, 0, 5, 4, 4)
> +#define SYS_ERXPFGCTL_EL1 sys_reg(3, 0, 5, 4, 5)
> +#define SYS_ERXPFGCDN_EL1 sys_reg(3, 0, 5, 4, 6)
> #define SYS_ERXMISC0_EL1 sys_reg(3, 0, 5, 5, 0)
> #define SYS_ERXMISC1_EL1 sys_reg(3, 0, 5, 5, 1)
> +#define SYS_ERXMISC2_EL1 sys_reg(3, 0, 5, 5, 2)
> +#define SYS_ERXMISC3_EL1 sys_reg(3, 0, 5, 5, 3)
> #define SYS_TFSR_EL1 sys_reg(3, 0, 5, 6, 0)
> #define SYS_TFSRE0_EL1 sys_reg(3, 0, 5, 6, 1)
>=20

Reviewed-by: Miguel Luis <miguel.luis@oracle.com>

Thanks
Miguel

> --=20
> 2.34.1
>=20
>=20

