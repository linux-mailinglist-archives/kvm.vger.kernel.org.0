Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9724D77DD60
	for <lists+kvm@lfdr.de>; Wed, 16 Aug 2023 11:36:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243388AbjHPJfa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Aug 2023 05:35:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243495AbjHPJf2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Aug 2023 05:35:28 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99B8726AB
        for <kvm@vger.kernel.org>; Wed, 16 Aug 2023 02:35:21 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37FNOeEm020082;
        Wed, 16 Aug 2023 09:34:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=Ma4Q/Masgsh3etiKF2eCgqgvPG42TXuedmwq2uGy1CU=;
 b=jtQZx4qlupBInPUCXTZqELcKbMoMxIn41GfvgpQ6JF2wgDcKcpjd+gcE8y7KA/8ytelh
 hHg0tf2dFCzSh0AEnE8kni6Zxf/+MW+K5GVDSd+ke2r6aUI0/I+cbNr5ozTain5I4nBb
 AiLkk4E3JGekKjMYSEja6dLbM1g7Pls93z6ta6AH+6wd2/UCW9qIzkVr4VCxDzhmNFky
 1mM+EiVQoVfsugNs4J1m/+M/b1gEo+oJs6jKDemx9Sxk2v7UjKRNBeOdyrJxhOIyj5wJ
 evVfm1JPwpt5sAIytdiCBhCpzejokotXotcCZXKQd3ht4Fp/Wwejqba1eZEsbnEx9RYc MA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3se2w5xn1p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Aug 2023 09:34:33 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 37G98H3b003697;
        Wed, 16 Aug 2023 09:34:31 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2176.outbound.protection.outlook.com [104.47.55.176])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3sexyjyy23-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Aug 2023 09:34:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BLxIUOhFpIt6LlO89jdOH40ADhaAgKt7zoxVVP8KyPL4u7lYzjxWa9D9v/WVP6jUiPLHaqVcbCw6KXCl2QwOal+XpxhukLBd07yCqjrZ5Pz89xsAUJEh3YT2p2TnECPcyOoFuS9Fx6kRMMxr70u6ngOMkP3RIfXIgL5VR+Vu/VXxRUhXpoml4OM0+rW9Zhh6I/8ENHIpB207Qhls79ls1iOd+U9dQftYAXVHbFvUTkQ+FaYzo/TRlmOdqBfhBKn9GjpUC1BDFRKIiOntlKdE8Sabr+iIXfuxYC8w50m1egF+YSsW0EEPUaA3dJonWQPHuQ42/3D+tOVdOJAqxR2GPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ma4Q/Masgsh3etiKF2eCgqgvPG42TXuedmwq2uGy1CU=;
 b=O1/qjCOGnCMm45T5eUszypb4t/cY/8wVPp/Xo+DJ9vAd38B3o+/Y2gPil5Q3PJ5Ec72Hvwr+vBjGWKExCvGE8rLafXhvLJPc4NtTxU231ByVi1qmcrHttXNUDtt9Qz9XmbrKFaIOH7CbU1i2NCNDyYXWWHi8Olb3rE1k/yyeOShUfa6TkgSSOnNEzJ5VMkHjkjpkX5E1LGcyJNBXA+EVr7otWZJ7DrRn8rgxoFNSgv4OOcOUQww+ptIC+tYXgEMFq9rXKMPRVa7TdyH6G0zLQdEhU0EFQfKDQ10QlVLxIniM51cKuT7rWSSMBoixNPVYY8CcqwtQo/OuhHQAglSJqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ma4Q/Masgsh3etiKF2eCgqgvPG42TXuedmwq2uGy1CU=;
 b=zc2+7q9BVIeJNirkpGAlghL6oeq1B2ODz6S0a6W7rrhGjjkclRpAVFlcukUHGSTg7iquDnfeXzsQMV9krmzOPJvck4B9a9iInLihk540Sy7tQBZKUZKJjrPRSf92SKxzo9Sxhl7U2xXAr44kdE6ntqSvEvmf680QQP5BQynNDb0=
Received: from PH0PR10MB5433.namprd10.prod.outlook.com (2603:10b6:510:e0::9)
 by DS0PR10MB7935.namprd10.prod.outlook.com (2603:10b6:8:1b3::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6678.26; Wed, 16 Aug
 2023 09:34:29 +0000
Received: from PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::76c:cb31:2005:d10c]) by PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::76c:cb31:2005:d10c%5]) with mapi id 15.20.6678.029; Wed, 16 Aug 2023
 09:34:29 +0000
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
        Jing Zhang <jingzhangos@google.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v4 14/28] KVM: arm64: nv: Add trap forwarding
 infrastructure
Thread-Topic: [PATCH v4 14/28] KVM: arm64: nv: Add trap forwarding
 infrastructure
Thread-Index: AQHZz6j5LTOWX/ON70iSNKabHLvnSK/sqlYA
Date:   Wed, 16 Aug 2023 09:34:29 +0000
Message-ID: <A7165A2C-1673-45AA-8FE6-73E4B436B891@oracle.com>
References: <20230815183903.2735724-1-maz@kernel.org>
 <20230815183903.2735724-15-maz@kernel.org>
In-Reply-To: <20230815183903.2735724-15-maz@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR10MB5433:EE_|DS0PR10MB7935:EE_
x-ms-office365-filtering-correlation-id: 933bb705-3fef-46bc-f7af-08db9e3bfd5f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: G0CtIP3Y6zsH9TCNofxmnrC3GTivy6URU63ZUcgU32GX65K23AYXtpdUDe0l7LHTXtKdCjYlJRi8Z8epZHMirsnERRqPJ1EPMX6vWp80KhI3O2kmHfKdpkPxLn3Fo00haPaKWGcPXucrGChzsaWNX37rYrNdrT0+fTx+lLEFfoZfX8YYAqyZuCiLFoei7xTks5GmNcWHjdReOg2bYvizBF/EZxKYNg81oHWP0FGyDd1A8Hk6Y37z46YMhbwfSPb7OQx697isOX/GbukCIyysYBXK1h3scE3/RrizVV/ICfPoMvJpaV/vgfbF7pgvnhvqJaPDUgmYkvnkKOBlEbjbvM9MXaZccwXnO5PKEAfqcvFDM7bJvkSPGE18aWRZlomIs2R4hujI5ZLBDOLI84j4b0VZrNDi5vnNwwtnuK6cUDrX15mFojl4ptgeNLPdPn4jY48kI5NcmHTICoqXB/B96et56KCHvCGWzTvnRTeFq5yv88mC8FPYoHKShFW15S4SGinYI0mrDwGUSbHyyigCZaxWIPxK+zTnq8AyYS2Bh2VLh09xaKaAk63MXCvXsOAFpTTqaCZYeymsh2KDUnju11EmR3qjOI0oetiVA5NzWpr0XV2n+Qr3mmoprd8avZz1bZm7EBKSqVY8/g2iVmN+ng==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5433.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(366004)(396003)(136003)(376002)(39860400002)(1800799009)(451199024)(186009)(2906002)(83380400001)(30864003)(7416002)(86362001)(478600001)(36756003)(2616005)(6486002)(6506007)(71200400001)(33656002)(6512007)(53546011)(5660300002)(44832011)(41300700001)(122000001)(6916009)(316002)(54906003)(66946007)(66556008)(66476007)(66446008)(64756008)(91956017)(76116006)(4326008)(8676002)(8936002)(38100700002)(38070700005)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?fiZbhO02bImiKUEU6BMzKge7Iz+Iq3CeqPul8cSpcei9MFpGTWbcZCxbWAQq?=
 =?us-ascii?Q?X4BivUOmQPtoouVM1gabB0FpmE4fPWtpQhdr9mAGW/39VzqUtcx0Ov2rs9Lv?=
 =?us-ascii?Q?7bFFTVY5ueId7FQV+KHg0y/UIBU0pMqAtLLFusrHtSQMjkyeHP/ouongCGZW?=
 =?us-ascii?Q?RKCPVteidx+bLYTHlZUwenNCgYQd/htAT6jKIPZqh5xEYfgZm0asd7anekCz?=
 =?us-ascii?Q?yL4XybLHpzXAxZBGXEpDFlUYYPZaC+Etmcry5GnTAYjPaRpQgEB1gIgfxnMH?=
 =?us-ascii?Q?lO9nqqaD5KZxjRhaVDZ0tAdGaYJdBjjCBHG2tyfLrNm8a+lmT5MApr9nYbWF?=
 =?us-ascii?Q?kJ+3G8Rd3ChMNA1pR2omQyvtFWd2jUF+PDddgjY9HRckz0hhtpg+dce7X31m?=
 =?us-ascii?Q?dTq3t4woP3r3BCAEbjgYwpcAPGxQADx9OJPp+i48cFESnYPiRDNisnZJIJ+m?=
 =?us-ascii?Q?YCBK5AUpL1Dx6gp9Leu2g1uVylKgpGK1lWPNv4Nc0cFs1UVpmJs7RtDBmwrk?=
 =?us-ascii?Q?EjClWkSxyBeYHYOWnPEKIEAbi7SgDklu5R6E24QTeJMEbGLJO/NlOs7XEnNx?=
 =?us-ascii?Q?oHG5adw7LUnUV1OZwgWtsoE705nVtNP2gNtZageSnzdoY6+Vg71SZlSQgEaD?=
 =?us-ascii?Q?km1Ic+aSA1kXI4w7X8qwPtJ/D2H4Hc1b3LZajZr/G+g77lqI8fR+8856SXX/?=
 =?us-ascii?Q?TIRa9/qUjE/b+ZX3gzA5xNAratHnkjkGUb2PYB5HUZie0d8n+3CiixX2H3ej?=
 =?us-ascii?Q?L+1Fr0+p4m6JYvp0xFM7NMnQpquFWPAwkPrnHTa8DAUmbU1zJy2A0IekJfTZ?=
 =?us-ascii?Q?ebVbioOM9AN5Fb+m8X9JDQyqEBugSrbvHp5w56C9JaLT9Plkd4us7v6CIma8?=
 =?us-ascii?Q?o4XFmGRTCe5z53KblDsl72IowcRjbCCkN0XGgyr2iZll/rwYmHBBt11AD0kZ?=
 =?us-ascii?Q?Uel33m7P8Sk6yGkIRaowapjGCl/T4Dl9/EYPTKoqZZdpDBO5l3Lgy/jC53kk?=
 =?us-ascii?Q?t2eM1tnSnMS8iLyriVqv9k9N4rugxCXmToJlbxSq5gq2xkQOzWgjoPIE1f6n?=
 =?us-ascii?Q?nHenZpEmGRU3ljdUD6SA2O4NVD3O541eJTVXHsFzQVz6VQQoglxi4EJLeiqE?=
 =?us-ascii?Q?Tag81Xntkjzk96Wpuf2s3RgmGyashsae8Aq2FDk6Lee2ykxrZ9cCWn5ZrtII?=
 =?us-ascii?Q?WijfLdDBbbdCmsa0w8JIXAl1XIdFLuiZLhkamdl82zeJRI59k3agPYAtPZEG?=
 =?us-ascii?Q?wzwwizIqd2dP7I9CUhK9Szkq4El6OInYFTqtlWflFvUJkSsJbYNvH9RorbT7?=
 =?us-ascii?Q?LPtkPhR/KXP4fGE4dulMDq+LhqCWl7HxFhOyOgqzR/lxD/bgwRPrt4MxuIRN?=
 =?us-ascii?Q?VPo76iRvHCQLyyiDscWqyYVbEL40q4cRmex3H/yeFIZZf1/aWUX52LdyqWJp?=
 =?us-ascii?Q?Jk4o9rI71RTWFVYSndeJ9Crk6ZaOVVg6N2iK68dnEHFSb6BLfL/3ZPLEYH0C?=
 =?us-ascii?Q?omJZI5/lR9tQF/p/eJJWGmY1ONvMytSzNJ6SqlxerfK1uqHSg+wBAOxKvIuX?=
 =?us-ascii?Q?CwTX+9tmNYjfgxPfctNfPCkUj+NL1dBT5M+CKLQblmGmSgpePONaiIuP+dSM?=
 =?us-ascii?Q?Rgm3r7Deu0nnwMi0cd/sS4s=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <192CB0BE10A1084EA8C20D203745D47A@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?9uCmD4m8uxh3MJayojJN2UHT6RT8ACN9+Sml0UHPF6QQZmDfZsXPFY2vgCfk?=
 =?us-ascii?Q?imdmNu5OP6t2ZtdEp5Hg0U9x0xGL/meLpQfbJh99z6h++lZoL+8VoPpPLjHt?=
 =?us-ascii?Q?9sSF6BSsKpF6+zNbNDB4zAaiBOgAMIPeQo5onIh6ekExPAQbu3V0xIEthpg/?=
 =?us-ascii?Q?bpaxFy0OnGKxzA5dn6Nm9Mqff/lHf4klFt1b8BnhexEUuoiS9Sk7epf8G09N?=
 =?us-ascii?Q?BTSib2I2SEoHf892P5flK0tKaPUEh0K2ChvTslz8ZCmx9b+CyeWdF03D1VO3?=
 =?us-ascii?Q?1OO6YrxJ8b5s+9iyVJrWRtnE5F2FdU0N9x4U7oVECTu9ZvLQkg9th5uR13CM?=
 =?us-ascii?Q?3vaLwG3DCbyEV8dEBjU8Olh7No8qpso7xSqg4fCt3IL9Zydr5waDNvISFsuN?=
 =?us-ascii?Q?tDNz5Ptk0R7DYkS2EQSliJHBRKLpbM6UNk89Mww2rtYGYIGfx/uUksjTTskP?=
 =?us-ascii?Q?fqIpLMXbO0KC++fUDLRVi2I2Hcak4OabVk1nBOvbnG1yibyNYkSmErNJKF5z?=
 =?us-ascii?Q?lxmNCD3WWZ4fsuuDlRdKpYgux3R/ykxRz50XNW4y1BP5RA2ZN8LBs6BLKOxH?=
 =?us-ascii?Q?aLyO/n1R+uHxsf5858RFBuVXCGXPjP8lYBHpkvGlNVCOk+0ORL4l+UGLYMtP?=
 =?us-ascii?Q?mtUvydifH3raaR/IEJrQvcqATQ0vQCXWXIaiEvS+bnbhdWV3P2qp9P+Hxz76?=
 =?us-ascii?Q?5pEF+z0vvboj8JSWVud6Dpjf+Bl171/jioCt2VQujJ/0CEO5sbPGVOwB+/WL?=
 =?us-ascii?Q?SxlMmT50u960OQlT4N6VhqxL7KEssmme2yE5Fxb0c13fvGhracs2jVr69VJA?=
 =?us-ascii?Q?RtFlvuwOMOHuKfKdvcAA/GA9qRM1UsgAuOg46XOq25OktVW13NUDnkNX21yi?=
 =?us-ascii?Q?NscyPUx6FTFQ3QkmCLBntaezlLOly2BK8F4ZgdtfhscgUqavLBRPhGusTK0h?=
 =?us-ascii?Q?0BLTvcxO51TgBrIRIGpGWLB4n5OPOLcbYLvPjax8Q8/mQ9PVVwes11jugkKQ?=
 =?us-ascii?Q?JTuCJgEaGqgz65od8ulUP7dJuqFfAJgA3DfYYfAfk64lgjH42ULuvcwUjQtX?=
 =?us-ascii?Q?rzN159gzc8YH51NtqRANzy+rfMpFPA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5433.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 933bb705-3fef-46bc-f7af-08db9e3bfd5f
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Aug 2023 09:34:29.3752
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eAzHwRdn3gr/547/MbzNGNuqZa1WEBaCGf/sK4Ku7eBUBNo4ar7p8HbKR9Afcn4l5CY+BVIIIicekV5gXg6UYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7935
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-16_07,2023-08-15_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 bulkscore=0 phishscore=0 suspectscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2308160085
X-Proofpoint-ORIG-GUID: 2u_VyNtyToN6K0fQEw0jdhQ__J_75Tbl
X-Proofpoint-GUID: 2u_VyNtyToN6K0fQEw0jdhQ__J_75Tbl
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

> On 15 Aug 2023, at 18:38, Marc Zyngier <maz@kernel.org> wrote:
>=20
> A significant part of what a NV hypervisor needs to do is to decide
> whether a trap from a L2+ guest has to be forwarded to a L1 guest
> or handled locally. This is done by checking for the trap bits that
> the guest hypervisor has set and acting accordingly, as described by
> the architecture.
>=20
> A previous approach was to sprinkle a bunch of checks in all the
> system register accessors, but this is pretty error prone and doesn't
> help getting an overview of what is happening.
>=20
> Instead, implement a set of global tables that describe a trap bit,
> combinations of trap bits, behaviours on trap, and what bits must
> be evaluated on a system register trap.
>=20
> Although this is painful to describe, this allows to specify each
> and every control bit in a static manner. To make it efficient,
> the table is inserted in an xarray that is global to the system,
> and checked each time we trap a system register while running
> a L2 guest.
>=20
> Add the basic infrastructure for now, while additional patches will
> implement configuration registers.
>=20
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
> arch/arm64/include/asm/kvm_host.h   |   1 +
> arch/arm64/include/asm/kvm_nested.h |   2 +
> arch/arm64/kvm/emulate-nested.c     | 282 ++++++++++++++++++++++++++++
> arch/arm64/kvm/sys_regs.c           |   6 +
> arch/arm64/kvm/trace_arm.h          |  26 +++
> 5 files changed, 317 insertions(+)
>=20
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/k=
vm_host.h
> index 721680da1011..cb1c5c54cedd 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -988,6 +988,7 @@ int kvm_handle_cp10_id(struct kvm_vcpu *vcpu);
> void kvm_reset_sys_regs(struct kvm_vcpu *vcpu);
>=20
> int __init kvm_sys_reg_table_init(void);
> +int __init populate_nv_trap_config(void);
>=20
> bool lock_all_vcpus(struct kvm *kvm);
> void unlock_all_vcpus(struct kvm *kvm);
> diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm=
/kvm_nested.h
> index 8fb67f032fd1..fa23cc9c2adc 100644
> --- a/arch/arm64/include/asm/kvm_nested.h
> +++ b/arch/arm64/include/asm/kvm_nested.h
> @@ -11,6 +11,8 @@ static inline bool vcpu_has_nv(const struct kvm_vcpu *v=
cpu)
> test_bit(KVM_ARM_VCPU_HAS_EL2, vcpu->arch.features));
> }
>=20
> +extern bool __check_nv_sr_forward(struct kvm_vcpu *vcpu);
> +
> struct sys_reg_params;
> struct sys_reg_desc;
>=20
> diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nes=
ted.c
> index b96662029fb1..d5837ed0077c 100644
> --- a/arch/arm64/kvm/emulate-nested.c
> +++ b/arch/arm64/kvm/emulate-nested.c
> @@ -14,6 +14,288 @@
>=20
> #include "trace.h"
>=20
> +enum trap_behaviour {
> + BEHAVE_HANDLE_LOCALLY =3D 0,
> + BEHAVE_FORWARD_READ =3D BIT(0),
> + BEHAVE_FORWARD_WRITE =3D BIT(1),
> + BEHAVE_FORWARD_ANY =3D BEHAVE_FORWARD_READ | BEHAVE_FORWARD_WRITE,
> +};
> +
> +struct trap_bits {
> + const enum vcpu_sysreg index;
> + const enum trap_behaviour behaviour;
> + const u64 value;
> + const u64 mask;
> +};
> +
> +/* Coarse Grained Trap definitions */
> +enum cgt_group_id {
> + /* Indicates no coarse trap control */
> + __RESERVED__,
> +
> + /*
> + * The first batch of IDs denote coarse trapping that are used
> + * on their own instead of being part of a combination of
> + * trap controls.
> + */
> +
> + /*
> + * Anything after this point is a combination of coarse trap
> + * controls, which must all be evaluated to decide what to do.
> + */
> + __MULTIPLE_CONTROL_BITS__,
> +
> + /*
> + * Anything after this point requires a callback evaluating a
> + * complex trap condition. Hopefully we'll never need this...
> + */
> + __COMPLEX_CONDITIONS__,
> +
> + /* Must be last */
> + __NR_CGT_GROUP_IDS__
> +};
> +
> +static const struct trap_bits coarse_trap_bits[] =3D {
> +};
> +
> +#define MCB(id, ...) \
> + [id - __MULTIPLE_CONTROL_BITS__] =3D \
> + (const enum cgt_group_id[]){ \
> + __VA_ARGS__, __RESERVED__ \
> + }
> +
> +static const enum cgt_group_id *coarse_control_combo[] =3D {
> +};
> +
> +typedef enum trap_behaviour (*complex_condition_check)(struct kvm_vcpu *=
);
> +
> +#define CCC(id, fn) \
> + [id - __COMPLEX_CONDITIONS__] =3D fn
> +
> +static const complex_condition_check ccc[] =3D {
> +};
> +
> +/*
> + * Bit assignment for the trap controls. We use a 64bit word with the
> + * following layout for each trapped sysreg:
> + *
> + * [9:0] enum cgt_group_id (10 bits)
> + * [62:10] Unused (53 bits)
> + * [63] RES0 - Must be zero, as lost on insertion in the xarray
> + */
> +#define TC_CGT_BITS 10
> +
> +union trap_config {
> + u64 val;
> + struct {
> + unsigned long cgt:TC_CGT_BITS; /* Coarse Grained Trap id */
> + unsigned long unused:53; /* Unused, should be zero */
> + unsigned long mbz:1; /* Must Be Zero */
> + };
> +};
> +
> +struct encoding_to_trap_config {
> + const u32 encoding;
> + const u32 end;
> + const union trap_config tc;
> + const unsigned int line;
> +};
> +
> +#define SR_RANGE_TRAP(sr_start, sr_end, trap_id) \
> + { \
> + .encoding =3D sr_start, \
> + .end =3D sr_end, \
> + .tc =3D { \
> + .cgt =3D trap_id, \
> + }, \
> + .line =3D __LINE__, \
> + }
> +
> +#define SR_TRAP(sr, trap_id) SR_RANGE_TRAP(sr, sr, trap_id)
> +
> +/*
> + * Map encoding to trap bits for exception reported with EC=3D0x18.
> + * These must only be evaluated when running a nested hypervisor, but
> + * that the current context is not a hypervisor context. When the
> + * trapped access matches one of the trap controls, the exception is
> + * re-injected in the nested hypervisor.
> + */
> +static const struct encoding_to_trap_config encoding_to_cgt[] __initcons=
t =3D {
> +};
> +
> +static DEFINE_XARRAY(sr_forward_xa);
> +
> +static union trap_config get_trap_config(u32 sysreg)
> +{
> + return (union trap_config) {
> + .val =3D xa_to_value(xa_load(&sr_forward_xa, sysreg)),
> + };
> +}
> +
> +static __init void print_nv_trap_error(const struct encoding_to_trap_con=
fig *tc,
> +       const char *type, int err)
> +{
> + kvm_err("%s line %d encoding range "
> + "(%d, %d, %d, %d, %d) - (%d, %d, %d, %d, %d) (err=3D%d)\n",
> + type, tc->line,
> + sys_reg_Op0(tc->encoding), sys_reg_Op1(tc->encoding),
> + sys_reg_CRn(tc->encoding), sys_reg_CRm(tc->encoding),
> + sys_reg_Op2(tc->encoding),
> + sys_reg_Op0(tc->end), sys_reg_Op1(tc->end),
> + sys_reg_CRn(tc->end), sys_reg_CRm(tc->end),
> + sys_reg_Op2(tc->end),
> + err);
> +}
> +
> +int __init populate_nv_trap_config(void)
> +{
> + int ret =3D 0;
> +
> + BUILD_BUG_ON(sizeof(union trap_config) !=3D sizeof(void *));
> + BUILD_BUG_ON(__NR_CGT_GROUP_IDS__ > BIT(TC_CGT_BITS));
> +
> + for (int i =3D 0; i < ARRAY_SIZE(encoding_to_cgt); i++) {
> + const struct encoding_to_trap_config *cgt =3D &encoding_to_cgt[i];
> + void *prev;
> +
> + if (cgt->tc.val & BIT(63)) {
> + kvm_err("CGT[%d] has MBZ bit set\n", i);
> + ret =3D -EINVAL;
> + }
> +
> + if (cgt->encoding !=3D cgt->end) {
> + prev =3D xa_store_range(&sr_forward_xa,
> +      cgt->encoding, cgt->end,
> +      xa_mk_value(cgt->tc.val),
> +      GFP_KERNEL);
> + } else {
> + prev =3D xa_store(&sr_forward_xa, cgt->encoding,
> + xa_mk_value(cgt->tc.val), GFP_KERNEL);
> + if (prev && !xa_is_err(prev)) {
> + ret =3D -EINVAL;
> + print_nv_trap_error(cgt, "Duplicate CGT", ret);
> + }
> + }
> +
> + if (xa_is_err(prev)) {
> + ret =3D xa_err(prev);
> + print_nv_trap_error(cgt, "Failed CGT insertion", ret);
> + }
> + }
> +
> + kvm_info("nv: %ld coarse grained trap handlers\n",
> + ARRAY_SIZE(encoding_to_cgt));
> +
> + for (int id =3D __MULTIPLE_CONTROL_BITS__; id < __COMPLEX_CONDITIONS__;=
 id++) {
> + const enum cgt_group_id *cgids;
> +
> + cgids =3D coarse_control_combo[id - __MULTIPLE_CONTROL_BITS__];
> +
> + for (int i =3D 0; cgids[i] !=3D __RESERVED__; i++) {
> + if (cgids[i] >=3D __MULTIPLE_CONTROL_BITS__) {
> + kvm_err("Recursive MCB %d/%d\n", id, cgids[i]);
> + ret =3D -EINVAL;
> + }
> + }
> + }
> +
> + if (ret)
> + xa_destroy(&sr_forward_xa);
> +
> + return ret;
> +}
> +
> +static enum trap_behaviour get_behaviour(struct kvm_vcpu *vcpu,
> + const struct trap_bits *tb)
> +{
> + enum trap_behaviour b =3D BEHAVE_HANDLE_LOCALLY;
> + u64 val;
> +
> + val =3D __vcpu_sys_reg(vcpu, tb->index);
> + if ((val & tb->mask) =3D=3D tb->value)
> + b |=3D tb->behaviour;
> +
> + return b;
> +}
> +
> +static enum trap_behaviour __compute_trap_behaviour(struct kvm_vcpu *vcp=
u,
> +    const enum cgt_group_id id,
> +    enum trap_behaviour b)
> +{
> + switch (id) {
> + const enum cgt_group_id *cgids;
> +
> + case __RESERVED__ ... __MULTIPLE_CONTROL_BITS__ - 1:
> + if (likely(id !=3D __RESERVED__))
> + b |=3D get_behaviour(vcpu, &coarse_trap_bits[id]);
> + break;
> + case __MULTIPLE_CONTROL_BITS__ ... __COMPLEX_CONDITIONS__ - 1:
> + /* Yes, this is recursive. Don't do anything stupid. */
> + cgids =3D coarse_control_combo[id - __MULTIPLE_CONTROL_BITS__];
> + for (int i =3D 0; cgids[i] !=3D __RESERVED__; i++)
> + b |=3D __compute_trap_behaviour(vcpu, cgids[i], b);
> + break;
> + default:
> + if (ARRAY_SIZE(ccc))
> + b |=3D ccc[id -  __COMPLEX_CONDITIONS__](vcpu);
> + break;
> + }
> +
> + return b;
> +}
> +
> +static enum trap_behaviour compute_trap_behaviour(struct kvm_vcpu *vcpu,
> +  const union trap_config tc)
> +{
> + enum trap_behaviour b =3D BEHAVE_HANDLE_LOCALLY;
> +
> + return __compute_trap_behaviour(vcpu, tc.cgt, b);
> +}
> +
> +bool __check_nv_sr_forward(struct kvm_vcpu *vcpu)
> +{
> + union trap_config tc;
> + enum trap_behaviour b;
> + bool is_read;
> + u32 sysreg;
> + u64 esr;
> +
> + if (!vcpu_has_nv(vcpu) || is_hyp_ctxt(vcpu))
> + return false;
> +
> + esr =3D kvm_vcpu_get_esr(vcpu);
> + sysreg =3D esr_sys64_to_sysreg(esr);
> + is_read =3D (esr & ESR_ELx_SYS64_ISS_DIR_MASK) =3D=3D ESR_ELx_SYS64_ISS=
_DIR_READ;
> +
> + tc =3D get_trap_config(sysreg);
> +
> + /*
> + * A value of 0 for the whole entry means that we know nothing
> + * for this sysreg, and that it cannot be re-injected into the
> + * nested hypervisor. In this situation, let's cut it short.
> + *
> + * Note that ultimately, we could also make use of the xarray
> + * to store the index of the sysreg in the local descriptor
> + * array, avoiding another search... Hint, hint...
> + */
> + if (!tc.val)
> + return false;
> +
> + b =3D compute_trap_behaviour(vcpu, tc);
> +
> + if (((b & BEHAVE_FORWARD_READ) && is_read) ||
> +    ((b & BEHAVE_FORWARD_WRITE) && !is_read))
> + goto inject;
> +
> + return false;
> +
> +inject:
> + trace_kvm_forward_sysreg_trap(vcpu, sysreg, is_read);
> +
> + kvm_inject_nested_sync(vcpu, kvm_vcpu_get_esr(vcpu));
> + return true;
> +}
> +
> static u64 kvm_check_illegal_exception_return(struct kvm_vcpu *vcpu, u64 =
spsr)
> {
> u64 mode =3D spsr & PSR_MODE_MASK;
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index f5baaa508926..9556896311db 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -3177,6 +3177,9 @@ int kvm_handle_sys_reg(struct kvm_vcpu *vcpu)
>=20
> trace_kvm_handle_sys_reg(esr);
>=20
> + if (__check_nv_sr_forward(vcpu))
> + return 1;
> +
> params =3D esr_sys64_to_params(esr);
> params.regval =3D vcpu_get_reg(vcpu, Rt);
>=20
> @@ -3594,5 +3597,8 @@ int __init kvm_sys_reg_table_init(void)
> if (!first_idreg)
> return -EINVAL;
>=20
> + if (kvm_get_mode() =3D=3D KVM_MODE_NV)
> + return populate_nv_trap_config();
> +
> return 0;
> }
> diff --git a/arch/arm64/kvm/trace_arm.h b/arch/arm64/kvm/trace_arm.h
> index 6ce5c025218d..8ad53104934d 100644
> --- a/arch/arm64/kvm/trace_arm.h
> +++ b/arch/arm64/kvm/trace_arm.h
> @@ -364,6 +364,32 @@ TRACE_EVENT(kvm_inject_nested_exception,
>  __entry->hcr_el2)
> );
>=20
> +TRACE_EVENT(kvm_forward_sysreg_trap,
> +    TP_PROTO(struct kvm_vcpu *vcpu, u32 sysreg, bool is_read),
> +    TP_ARGS(vcpu, sysreg, is_read),
> +
> +    TP_STRUCT__entry(
> + __field(u64, pc)
> + __field(u32, sysreg)
> + __field(bool, is_read)
> +    ),
> +
> +    TP_fast_assign(
> + __entry->pc =3D *vcpu_pc(vcpu);
> + __entry->sysreg =3D sysreg;
> + __entry->is_read =3D is_read;
> +    ),
> +
> +    TP_printk("%llx %c (%d,%d,%d,%d,%d)",
> +      __entry->pc,
> +      __entry->is_read ? 'R' : 'W',
> +      sys_reg_Op0(__entry->sysreg),
> +      sys_reg_Op1(__entry->sysreg),
> +      sys_reg_CRn(__entry->sysreg),
> +      sys_reg_CRm(__entry->sysreg),
> +      sys_reg_Op2(__entry->sysreg))
> +);
> +

Reviewed-by: Miguel Luis <miguel.luis@oracle.com>

Thanks
Miguel

> #endif /* _TRACE_ARM_ARM64_KVM_H */
>=20
> #undef TRACE_INCLUDE_PATH
> --=20
> 2.34.1
>=20

