Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CDE877F4C2
	for <lists+kvm@lfdr.de>; Thu, 17 Aug 2023 13:07:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350153AbjHQLGy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Aug 2023 07:06:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350144AbjHQLGk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Aug 2023 07:06:40 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75A0E269F
        for <kvm@vger.kernel.org>; Thu, 17 Aug 2023 04:06:38 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37HAO0Bk032492;
        Thu, 17 Aug 2023 11:05:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=eL4pCBFEj7AML+T4uUybt9aQNg2KfxuYMv2TRKrHNCA=;
 b=haQaW0fSpMkbxqErnu8m4izHoRiTSzWUTuPXCrDa/MGt43jP8Pf1EMvVd05zbNZkdVKi
 nTTxvTNXq91FTerdlkYB5pANjJqvwDpnD0OkroXV0wJwECdFXNtANKon2NswR3CdAd1A
 VTB77aIdax8bvnes9Bkd3xyFzbBFsLF+gaxutNAbehHk26/8rvQQTwb2xdqnq9E3w7ua
 Z6NeVxtLxlNciQa4zM1RfLFZ7B8ZPfG1Ry0in4mpHymnjNlSh+GyYjXD/jAhKx6IFnIQ
 AU9KFodBeNNpEkrtgZegfRjQ3M6akY+sX6cEhO+nizlo/Pae0IhiFRM/7ZFwYgEOPPLi mg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3se349h8t9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Aug 2023 11:05:53 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 37H9tYeO040165;
        Thu, 17 Aug 2023 11:05:52 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2044.outbound.protection.outlook.com [104.47.57.44])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3sey0tea7c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Aug 2023 11:05:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SgZ5/JzD0NaeuhI8is2RVcfDU9zEmQS+w3+41G+Wp3E8HIdC02qchvXvKhmiSqLTDt9IoFyJcpyDJu20ibcYiYCscb3sJ4gOI/VWLjyr9ODYSKqHF6T1vdVurSrw6u5a8FWi0DEi6Ftq9UERlqHpx+wJXglKdJzz1pddC7pX1XxOW6xibJRbYvnPq/IktGhGEpNwSXgzDFye1pMBZz/GiBo4srGJsZvERnJpNJSfEr6U6LqtfWF7vP82CRGjZxl7ORDX+cGVrP57awbbwDUVxmHCRwDge7NO754lpVNHeVnqbNtpzSM30RL3hdiJ67idFemytV5/m7Oq+V0/gztLrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eL4pCBFEj7AML+T4uUybt9aQNg2KfxuYMv2TRKrHNCA=;
 b=QUoolnqgtFKpr7gsmqUQiEIj7GoxbDaDu4TcnGSA9cIPnBf4YKxxjm1JDZdNxC9/YApdaPfTCzxgywPU86Rsv7esYY+/rGpBzKCbCAOqbg7h4vci1egCdA12u458Kc224y/8HsJevPdo2cL87X9Z4nuO9PB8tcCvrY4/Tsg7HAjKfIfPNIj+rFWiqNBJM5gmMxiE2NnloUPeyvfQwowXLG6rR0DMAX3BvoCuUxRhqb5Y5gWWIFzFCHg0nLplyi7XVqEsfiI8sml3mObTTxH50QlIKl2CNSJxPHYzGHvalaIKjnDigvDfD8bh1BCxEM1G6jgnXg9wLdfMnRKmjAnTTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eL4pCBFEj7AML+T4uUybt9aQNg2KfxuYMv2TRKrHNCA=;
 b=h4eHZOcAFqctC39HmgE2ifgCEyGwyX9n5Mr0nJaGdKrmsL/d1tnRJK5OG3vEqEB/T5XZp4LjwrzOr87P9l72zQXzswozKkScyfTM7Pz7dDHcdokoaTMdlAdl07J7e8WFNHGngBcIoEZdXatHEhmd1vfCLoRZdFJpXj9TKONTAoM=
Received: from CO6PR10MB5426.namprd10.prod.outlook.com (2603:10b6:5:35e::22)
 by DS7PR10MB7190.namprd10.prod.outlook.com (2603:10b6:8:db::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6678.31; Thu, 17 Aug
 2023 11:05:49 +0000
Received: from CO6PR10MB5426.namprd10.prod.outlook.com
 ([fe80::556c:8a1:8889:c0d9]) by CO6PR10MB5426.namprd10.prod.outlook.com
 ([fe80::556c:8a1:8889:c0d9%4]) with mapi id 15.20.6678.031; Thu, 17 Aug 2023
 11:05:49 +0000
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
Subject: Re: [PATCH v4 15/28] KVM: arm64: nv: Add trap forwarding for HCR_EL2
Thread-Topic: [PATCH v4 15/28] KVM: arm64: nv: Add trap forwarding for HCR_EL2
Thread-Index: AQHZz6j8FVkRvNtG+kqTUjiTutrpaK/uVi0A
Date:   Thu, 17 Aug 2023 11:05:49 +0000
Message-ID: <7B337015-DEB4-4E04-9A7A-AEDA0ECED71B@oracle.com>
References: <20230815183903.2735724-1-maz@kernel.org>
 <20230815183903.2735724-16-maz@kernel.org>
In-Reply-To: <20230815183903.2735724-16-maz@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO6PR10MB5426:EE_|DS7PR10MB7190:EE_
x-ms-office365-filtering-correlation-id: 7bc95dbc-00f4-4dec-b62d-08db9f11ea0f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: y+FMe4EVeuHDJSvau99Hn9geStL2CZ1LdTvsy3QNRBMXYuaLQK/ZY3nwNfolEcvs5kld03jPiqJhyyZa+WNWCjV4ol4lzxoH0+8sKtETDuWReL9fLJJ6eHaHj213AgFV/9LdAQKWAQsV1UJ5GQPf9t8dYnPqXJ6sEydHGKtwyviuQqG8zT/8s8oJIsUQ3fqlbjHsExIzuEc2z5yrjP3Pyf+r+7fMZULR/R0Wqus2QKw0PRwirkne5MajoP2SEnf6jYKh6tv+s3i1g10NwxsDd/92x3x7Thi3TyHMj7BwNYJVEyYw98lB4doJZWO6eYG1FW73I8YR5OlRCKLw7o1geDICJPxfr3lwANz5BsJEfcrTUL1lSZlYqXZAQZbma4FFevlmUiCcbjY7qmCxoT8xZ/qnuMtVi8J6Yc8Pl3VFgMXEMtwI1sA5rKzdrHxJib5cH3K6juoiRjuih0pIYcoj8q5ljvPs2eOV6yPgZd6sw8nlKHSJ4M1HZHNVWOTNQAq2DxyQo8ksECVA7Ygc1u6IGaTWCOFjFtNjbBkela/uxNnCpOVp8bWDxjGumm0rPWltmvcKswF/daXhCFDWNveTaWVvbYiTGHLqUg8v7Qc0pBY1sRHracaaxgpixaFG7V8/1Q8+fdpckhmn7QFaEdkyLA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5426.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(346002)(396003)(376002)(366004)(136003)(451199024)(1800799009)(186009)(86362001)(36756003)(33656002)(38070700005)(38100700002)(122000001)(5660300002)(44832011)(2616005)(6486002)(91956017)(66946007)(66446008)(66476007)(66556008)(478600001)(76116006)(6916009)(64756008)(53546011)(316002)(6506007)(71200400001)(54906003)(6512007)(41300700001)(4326008)(8936002)(8676002)(7416002)(30864003)(2906002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?sgyan83tvD3+J6IOWDE1MKmUMAGDfo2ZaM24fBSR+tcbF67e4PF2bN2bzlvn?=
 =?us-ascii?Q?UbYXKbssiml+s5+1kDvv0Dx8noQ52GHCVsEqno68JXnlL77qGXIKGGio8acG?=
 =?us-ascii?Q?/kHuoIV0YiEMZkmB0EGqKCPlJXlaIoa6v2OwSjI1GknzSr0Ft/qToVojSYFM?=
 =?us-ascii?Q?u/lHF/lN3TzjsOaHfECcK8Wk3h8hQi8YhJVY9+cgXq1Y5M78z24E9LKZn2Qa?=
 =?us-ascii?Q?mOZ0lYQB5vfMGxtGDM43gaM+HfPw5b3eIhcp9EdTiJAYP+FCxhQu7/3LI/9B?=
 =?us-ascii?Q?Huz6uNW7JO5Lw3GTCWpYdJNRvF2hO8WhngMdy0fiBZE6UG8f0BuJeMkq4SpJ?=
 =?us-ascii?Q?rzPwenZ2r/eTgEe/G1PecyG2ATIF9ftxhtGgYsmKnK5ZMrEdt45i2YAicORj?=
 =?us-ascii?Q?NEg86D6VNj80/wOXpwhORCgHDr+PkGMpYHu9J47sBlKS8T+a/hlFKESVz5Rq?=
 =?us-ascii?Q?+CTfqPtIsUKSvzF/1YQGVpFjKt5xp1SRg3xIgK5Kgxe0DV60WZkkLSFsEELp?=
 =?us-ascii?Q?wtvw8iiCdWgDtxogYbc2zCjuA/q8DOmYkNhexDq4Pz0ggr1725pe57fjYcYR?=
 =?us-ascii?Q?iQv1sTj3ECdU7hDSQenuhLOZwlx4D49VyV/j+472+YrAfJjTbdJiVypTtizy?=
 =?us-ascii?Q?f45tqwoyPWV5LHCWVL2lTI77ewI8XrCDVY4pfi+pKrU7lot3nzTpdVOJA/nm?=
 =?us-ascii?Q?IWoxpTzgNSdlzAuj4Hvq1iGstetVn2gZKsGmGUQ8XnzzZ+dkPVwvTBUmwuRm?=
 =?us-ascii?Q?csEWmDjbxwAmhNtJWTjK+vXhqIdgB+px48yBteRmzQhsrmVEgGFjwcN1EiC1?=
 =?us-ascii?Q?2R5HLJYeoSoxPJiixilcwEEhQsZ8s9UXtyeSS4oq4Kj2RAmCaqd4K3dEmIrT?=
 =?us-ascii?Q?xBOWJH/URNycsiExw6+kQ2DjuOOR7QxWJ1yo37R4QeGJUrKiC6h6WVKDF/xU?=
 =?us-ascii?Q?+thLbJgSrYTjPNdD/06jxJLanhVlQEPnMSd9B/gaScmqZ7zTL+2brOwLwlhZ?=
 =?us-ascii?Q?N6ne2pHD1KLeEoXPpCWydPEFA2RxfcegmatPEPZ5tFc6U1HxVIgo3K/XgztC?=
 =?us-ascii?Q?/suqSlQh7kJHN3V0QdamLRD9+D1boBXATtLGDC4EJ3VhoUyPl82R77tCXkAn?=
 =?us-ascii?Q?OMAUx6zOisHfaIuSZjZBNiwq3FCc9eB7JzGE9N3nvphMZJOoz8a6t8TnfWE+?=
 =?us-ascii?Q?R2jkJkyMCYmL3+6dg8NqGyIDjUiqRma14GNeklC4EkT0/OSyCJkkRmz7CpFw?=
 =?us-ascii?Q?XSlksT1XPpEsZ966bfpz8XtJ71UlEPxoS2sCd7Mlux3vWosex4cs802IQgGn?=
 =?us-ascii?Q?+Uu+yc7nMcFZ9Uq73kCCiHAdCtlbdd1E9UJmnlaPMBAbcA3hvcUwvgeqZNWN?=
 =?us-ascii?Q?TW6fqtqXeVmmUZUU1FN0GtjVLz8Mseu+p5LroPn4sU70L4gG341J5XSzF+ev?=
 =?us-ascii?Q?9ZyCKcLr2MpK16mTqtroBSs5351E1id+wjHE2toIh3ziARljNnXPR8jqWBhY?=
 =?us-ascii?Q?aeElcbO8jdtnMTvHkUMXifU4lnZfZ1f/ha0V27mSeIeuMC1uU7pUbkyAbnmq?=
 =?us-ascii?Q?XIGOV4EH2BgX8qujmVpGL6dUP4dNOqYfEjilm5ppsP+kxI/RqVLSaAdK7jna?=
 =?us-ascii?Q?YUILunebKHRaAGOIc7bguoU=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E1A62EDFDAFED7438B7C30BF24E03AFF@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?PXf1Tq2hn+gE//5DbWi43SsNuvc0Rs/8hbd/2BQ/GnYy3pHUTe2Mml3l/7YM?=
 =?us-ascii?Q?2YePfSPLG3mjE4tO12CFUWF4yzlA4VJzCbQHPYP3EAeJCTbR4tLgt3s5Qn1m?=
 =?us-ascii?Q?SWHvLyHpLjqNaUCPuyNP+H7FYFWa5Xe7p6dqTGDfMbtrELTYhaQ57ItSC8MB?=
 =?us-ascii?Q?2+qyrtofltZD6ZT8q+9IEr0EFDmjseshfwbyznfzsXOtQlivSrK383w6JAoi?=
 =?us-ascii?Q?POSRVYPKpAb10gA40g1/vzODjyOOLxKi0B4lNYTiJgyazzrPaq4davtfd4zy?=
 =?us-ascii?Q?IaPydvRN9EbMViJ1bLvWiQivj2wWLwqX9xqExs8PhyaHKcPMecjo2wOsP0Lx?=
 =?us-ascii?Q?ZckCgm1hn8AEknjQD1JMvY++wNu4jwuntnadWpCvqZN3w5osfQXhfIA7jcnL?=
 =?us-ascii?Q?+v2ZOYuTIhTER+e6Ew+fFBpJmoh84QwTFjGNq5nEbCCLoDlnpppmtaoXjXPk?=
 =?us-ascii?Q?PfFsMfBB+859BTHtS/u92O1Tdbj3ohNr+kTL7GsLu0EB18cGsqhzj39/AFSb?=
 =?us-ascii?Q?z7ZZMB/x9cW4XaqAfrMIWXbQu594RZ/zrLED1cuhjrD9p9VUWNy3WA/xLIWq?=
 =?us-ascii?Q?DtuQ/LHkMCVgsj/DKySoKM8vhPXmwBdMqg5NhAcxy/hT43TSlu4Iibj7A7my?=
 =?us-ascii?Q?kL2DLIfkUSlijE7wO/fUKtlNvEND9q/ztaqvft9zw3dydBynkdXPZyOEKb1h?=
 =?us-ascii?Q?8Vwk72cpys4wN9m2S0EL5odZtpYjfhOlNYJVkY2YPR9Lk3h4/aMh8peP76Td?=
 =?us-ascii?Q?BkoZDjmgg+/DjY+R6tBQeZHZyiPDVgDNWiHNEX2HRs86upxbMgd00oadncT5?=
 =?us-ascii?Q?uz95Gl3HAW9JHbZwQoOoOY/AQUQeTKXyobeZNmHbNbx51r6Fa0cMxMbxd0EU?=
 =?us-ascii?Q?vA/w/QHant4aBeJ+4quRU+0DG0dbKwjKarf5LqO7TRB4imV8qPYckCKyR7xg?=
 =?us-ascii?Q?48LUErCC86pWhgFcxTlLAsefJhkpacmnjSLaCBPohsEhcE69sXlYOZrHyTEB?=
 =?us-ascii?Q?9xRNlNejoWYtdXW8KBwOs2m1GuTqs3EcesbtnPnLOgLAGOF41g1ykY52b7Dz?=
 =?us-ascii?Q?vHh8OQsetzj7Gmi9KthkNEYkhTVNEg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5426.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7bc95dbc-00f4-4dec-b62d-08db9f11ea0f
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Aug 2023 11:05:49.2836
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zeF/8KL9X/8rcwZh5w0cmQAl4fmnWH2Xx0uWYNVgVJtBfDdMQzaP+/F7TdjdzVRGt6waAVNOx7IWhHOmHVx2FQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB7190
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-17_03,2023-08-17_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 mlxscore=0
 spamscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2308170100
X-Proofpoint-GUID: 23_xIWBTuqK6DNYuoylwlF3KTJLOsa2k
X-Proofpoint-ORIG-GUID: 23_xIWBTuqK6DNYuoylwlF3KTJLOsa2k
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        UPPERCASE_75_100 autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

> On 15 Aug 2023, at 18:38, Marc Zyngier <maz@kernel.org> wrote:
>=20
> Describe the HCR_EL2 register, and associate it with all the sysregs
> it allows to trap.
>=20
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
> arch/arm64/kvm/emulate-nested.c | 488 ++++++++++++++++++++++++++++++++
> 1 file changed, 488 insertions(+)
>=20
> diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nes=
ted.c
> index d5837ed0077c..975a30ef874a 100644
> --- a/arch/arm64/kvm/emulate-nested.c
> +++ b/arch/arm64/kvm/emulate-nested.c
> @@ -38,12 +38,48 @@ enum cgt_group_id {
> * on their own instead of being part of a combination of
> * trap controls.
> */
> + CGT_HCR_TID1,
> + CGT_HCR_TID2,
> + CGT_HCR_TID3,
> + CGT_HCR_IMO,
> + CGT_HCR_FMO,
> + CGT_HCR_TIDCP,
> + CGT_HCR_TACR,
> + CGT_HCR_TSW,
> + CGT_HCR_TPC,
> + CGT_HCR_TPU,
> + CGT_HCR_TTLB,
> + CGT_HCR_TVM,
> + CGT_HCR_TDZ,
> + CGT_HCR_TRVM,
> + CGT_HCR_TLOR,
> + CGT_HCR_TERR,
> + CGT_HCR_APK,
> + CGT_HCR_NV,
> + CGT_HCR_NV_nNV2,
> + CGT_HCR_NV1_nNV2,
> + CGT_HCR_AT,
> + CGT_HCR_nFIEN,
> + CGT_HCR_TID4,
> + CGT_HCR_TICAB,
> + CGT_HCR_TOCU,
> + CGT_HCR_ENSCXT,
> + CGT_HCR_TTLBIS,
> + CGT_HCR_TTLBOS,
>=20
> /*
> * Anything after this point is a combination of coarse trap
> * controls, which must all be evaluated to decide what to do.
> */
> __MULTIPLE_CONTROL_BITS__,
> + CGT_HCR_IMO_FMO =3D __MULTIPLE_CONTROL_BITS__,
> + CGT_HCR_TID2_TID4,
> + CGT_HCR_TTLB_TTLBIS,
> + CGT_HCR_TTLB_TTLBOS,
> + CGT_HCR_TVM_TRVM,
> + CGT_HCR_TPU_TICAB,
> + CGT_HCR_TPU_TOCU,
> + CGT_HCR_NV1_nNV2_ENSCXT,
>=20
> /*
> * Anything after this point requires a callback evaluating a
> @@ -56,6 +92,174 @@ enum cgt_group_id {
> };
>=20
> static const struct trap_bits coarse_trap_bits[] =3D {
> + [CGT_HCR_TID1] =3D {
> + .index =3D HCR_EL2,
> + .value =3D HCR_TID1,
> + .mask =3D HCR_TID1,
> + .behaviour =3D BEHAVE_FORWARD_READ,
> + },
> + [CGT_HCR_TID2] =3D {
> + .index =3D HCR_EL2,
> + .value =3D HCR_TID2,
> + .mask =3D HCR_TID2,
> + .behaviour =3D BEHAVE_FORWARD_ANY,
> + },
> + [CGT_HCR_TID3] =3D {
> + .index =3D HCR_EL2,
> + .value =3D HCR_TID3,
> + .mask =3D HCR_TID3,
> + .behaviour =3D BEHAVE_FORWARD_READ,
> + },
> + [CGT_HCR_IMO] =3D {
> + .index =3D HCR_EL2,
> + .value =3D HCR_IMO,
> + .mask =3D HCR_IMO,
> + .behaviour =3D BEHAVE_FORWARD_WRITE,
> + },
> + [CGT_HCR_FMO] =3D {
> + .index =3D HCR_EL2,
> + .value =3D HCR_FMO,
> + .mask =3D HCR_FMO,
> + .behaviour =3D BEHAVE_FORWARD_WRITE,
> + },
> + [CGT_HCR_TIDCP] =3D {
> + .index =3D HCR_EL2,
> + .value =3D HCR_TIDCP,
> + .mask =3D HCR_TIDCP,
> + .behaviour =3D BEHAVE_FORWARD_ANY,
> + },
> + [CGT_HCR_TACR] =3D {
> + .index =3D HCR_EL2,
> + .value =3D HCR_TACR,
> + .mask =3D HCR_TACR,
> + .behaviour =3D BEHAVE_FORWARD_ANY,
> + },
> + [CGT_HCR_TSW] =3D {
> + .index =3D HCR_EL2,
> + .value =3D HCR_TSW,
> + .mask =3D HCR_TSW,
> + .behaviour =3D BEHAVE_FORWARD_ANY,
> + },
> + [CGT_HCR_TPC] =3D { /* Also called TCPC when FEAT_DPB is implemented */
> + .index =3D HCR_EL2,
> + .value =3D HCR_TPC,
> + .mask =3D HCR_TPC,
> + .behaviour =3D BEHAVE_FORWARD_ANY,
> + },
> + [CGT_HCR_TPU] =3D {
> + .index =3D HCR_EL2,
> + .value =3D HCR_TPU,
> + .mask =3D HCR_TPU,
> + .behaviour =3D BEHAVE_FORWARD_ANY,
> + },
> + [CGT_HCR_TTLB] =3D {
> + .index =3D HCR_EL2,
> + .value =3D HCR_TTLB,
> + .mask =3D HCR_TTLB,
> + .behaviour =3D BEHAVE_FORWARD_ANY,
> + },
> + [CGT_HCR_TVM] =3D {
> + .index =3D HCR_EL2,
> + .value =3D HCR_TVM,
> + .mask =3D HCR_TVM,
> + .behaviour =3D BEHAVE_FORWARD_WRITE,
> + },
> + [CGT_HCR_TDZ] =3D {
> + .index =3D HCR_EL2,
> + .value =3D HCR_TDZ,
> + .mask =3D HCR_TDZ,
> + .behaviour =3D BEHAVE_FORWARD_ANY,
> + },
> + [CGT_HCR_TRVM] =3D {
> + .index =3D HCR_EL2,
> + .value =3D HCR_TRVM,
> + .mask =3D HCR_TRVM,
> + .behaviour =3D BEHAVE_FORWARD_READ,
> + },
> + [CGT_HCR_TLOR] =3D {
> + .index =3D HCR_EL2,
> + .value =3D HCR_TLOR,
> + .mask =3D HCR_TLOR,
> + .behaviour =3D BEHAVE_FORWARD_ANY,
> + },
> + [CGT_HCR_TERR] =3D {
> + .index =3D HCR_EL2,
> + .value =3D HCR_TERR,
> + .mask =3D HCR_TERR,
> + .behaviour =3D BEHAVE_FORWARD_ANY,
> + },
> + [CGT_HCR_APK] =3D {
> + .index =3D HCR_EL2,
> + .value =3D 0,
> + .mask =3D HCR_APK,
> + .behaviour =3D BEHAVE_FORWARD_ANY,
> + },
> + [CGT_HCR_NV] =3D {
> + .index =3D HCR_EL2,
> + .value =3D HCR_NV,
> + .mask =3D HCR_NV,
> + .behaviour =3D BEHAVE_FORWARD_ANY,
> + },
> + [CGT_HCR_NV_nNV2] =3D {
> + .index =3D HCR_EL2,
> + .value =3D HCR_NV,
> + .mask =3D HCR_NV | HCR_NV2,
> + .behaviour =3D BEHAVE_FORWARD_ANY,
> + },
> + [CGT_HCR_NV1_nNV2] =3D {
> + .index =3D HCR_EL2,
> + .value =3D HCR_NV | HCR_NV1,
> + .mask =3D HCR_NV | HCR_NV1 | HCR_NV2,
> + .behaviour =3D BEHAVE_FORWARD_ANY,
> + },
> + [CGT_HCR_AT] =3D {
> + .index =3D HCR_EL2,
> + .value =3D HCR_AT,
> + .mask =3D HCR_AT,
> + .behaviour =3D BEHAVE_FORWARD_ANY,
> + },
> + [CGT_HCR_nFIEN] =3D {
> + .index =3D HCR_EL2,
> + .value =3D 0,
> + .mask =3D HCR_FIEN,
> + .behaviour =3D BEHAVE_FORWARD_ANY,
> + },
> + [CGT_HCR_TID4] =3D {
> + .index =3D HCR_EL2,
> + .value =3D HCR_TID4,
> + .mask =3D HCR_TID4,
> + .behaviour =3D BEHAVE_FORWARD_ANY,
> + },
> + [CGT_HCR_TICAB] =3D {
> + .index =3D HCR_EL2,
> + .value =3D HCR_TICAB,
> + .mask =3D HCR_TICAB,
> + .behaviour =3D BEHAVE_FORWARD_ANY,
> + },
> + [CGT_HCR_TOCU] =3D {
> + .index =3D HCR_EL2,
> + .value =3D HCR_TOCU,
> + .mask =3D HCR_TOCU,
> + .behaviour =3D BEHAVE_FORWARD_ANY,
> + },
> + [CGT_HCR_ENSCXT] =3D {
> + .index =3D HCR_EL2,
> + .value =3D 0,
> + .mask =3D HCR_ENSCXT,
> + .behaviour =3D BEHAVE_FORWARD_ANY,
> + },
> + [CGT_HCR_TTLBIS] =3D {
> + .index =3D HCR_EL2,
> + .value =3D HCR_TTLBIS,
> + .mask =3D HCR_TTLBIS,
> + .behaviour =3D BEHAVE_FORWARD_ANY,
> + },
> + [CGT_HCR_TTLBOS] =3D {
> + .index =3D HCR_EL2,
> + .value =3D HCR_TTLBOS,
> + .mask =3D HCR_TTLBOS,
> + .behaviour =3D BEHAVE_FORWARD_ANY,
> + },
> };
>=20
> #define MCB(id, ...) \
> @@ -65,6 +269,14 @@ static const struct trap_bits coarse_trap_bits[] =3D =
{
> }
>=20
> static const enum cgt_group_id *coarse_control_combo[] =3D {
> + MCB(CGT_HCR_IMO_FMO, CGT_HCR_IMO, CGT_HCR_FMO),
> + MCB(CGT_HCR_TID2_TID4, CGT_HCR_TID2, CGT_HCR_TID4),
> + MCB(CGT_HCR_TTLB_TTLBIS, CGT_HCR_TTLB, CGT_HCR_TTLBIS),
> + MCB(CGT_HCR_TTLB_TTLBOS, CGT_HCR_TTLB, CGT_HCR_TTLBOS),
> + MCB(CGT_HCR_TVM_TRVM, CGT_HCR_TVM, CGT_HCR_TRVM),
> + MCB(CGT_HCR_TPU_TICAB, CGT_HCR_TPU, CGT_HCR_TICAB),
> + MCB(CGT_HCR_TPU_TOCU, CGT_HCR_TPU, CGT_HCR_TOCU),
> + MCB(CGT_HCR_NV1_nNV2_ENSCXT, CGT_HCR_NV1_nNV2, CGT_HCR_ENSCXT),
> };
>=20
> typedef enum trap_behaviour (*complex_condition_check)(struct kvm_vcpu *)=
;
> @@ -121,6 +333,282 @@ struct encoding_to_trap_config {
>  * re-injected in the nested hypervisor.
>  */
> static const struct encoding_to_trap_config encoding_to_cgt[] __initconst=
 =3D {
> + SR_TRAP(SYS_REVIDR_EL1, CGT_HCR_TID1),
> + SR_TRAP(SYS_AIDR_EL1, CGT_HCR_TID1),
> + SR_TRAP(SYS_SMIDR_EL1, CGT_HCR_TID1),
> + SR_TRAP(SYS_CTR_EL0, CGT_HCR_TID2),
> + SR_TRAP(SYS_CCSIDR_EL1, CGT_HCR_TID2_TID4),
> + SR_TRAP(SYS_CCSIDR2_EL1, CGT_HCR_TID2_TID4),
> + SR_TRAP(SYS_CLIDR_EL1, CGT_HCR_TID2_TID4),
> + SR_TRAP(SYS_CSSELR_EL1, CGT_HCR_TID2_TID4),
> + SR_RANGE_TRAP(SYS_ID_PFR0_EL1,
> +      sys_reg(3, 0, 0, 7, 7), CGT_HCR_TID3),
> + SR_TRAP(SYS_ICC_SGI0R_EL1, CGT_HCR_IMO_FMO),
> + SR_TRAP(SYS_ICC_ASGI1R_EL1, CGT_HCR_IMO_FMO),
> + SR_TRAP(SYS_ICC_SGI1R_EL1, CGT_HCR_IMO_FMO),
> + SR_RANGE_TRAP(sys_reg(3, 0, 11, 0, 0),
> +      sys_reg(3, 0, 11, 15, 7), CGT_HCR_TIDCP),
> + SR_RANGE_TRAP(sys_reg(3, 1, 11, 0, 0),
> +      sys_reg(3, 1, 11, 15, 7), CGT_HCR_TIDCP),
> + SR_RANGE_TRAP(sys_reg(3, 2, 11, 0, 0),
> +      sys_reg(3, 2, 11, 15, 7), CGT_HCR_TIDCP),
> + SR_RANGE_TRAP(sys_reg(3, 3, 11, 0, 0),
> +      sys_reg(3, 3, 11, 15, 7), CGT_HCR_TIDCP),
> + SR_RANGE_TRAP(sys_reg(3, 4, 11, 0, 0),
> +      sys_reg(3, 4, 11, 15, 7), CGT_HCR_TIDCP),
> + SR_RANGE_TRAP(sys_reg(3, 5, 11, 0, 0),
> +      sys_reg(3, 5, 11, 15, 7), CGT_HCR_TIDCP),
> + SR_RANGE_TRAP(sys_reg(3, 6, 11, 0, 0),
> +      sys_reg(3, 6, 11, 15, 7), CGT_HCR_TIDCP),
> + SR_RANGE_TRAP(sys_reg(3, 7, 11, 0, 0),
> +      sys_reg(3, 7, 11, 15, 7), CGT_HCR_TIDCP),
> + SR_RANGE_TRAP(sys_reg(3, 0, 15, 0, 0),
> +      sys_reg(3, 0, 15, 15, 7), CGT_HCR_TIDCP),
> + SR_RANGE_TRAP(sys_reg(3, 1, 15, 0, 0),
> +      sys_reg(3, 1, 15, 15, 7), CGT_HCR_TIDCP),
> + SR_RANGE_TRAP(sys_reg(3, 2, 15, 0, 0),
> +      sys_reg(3, 2, 15, 15, 7), CGT_HCR_TIDCP),
> + SR_RANGE_TRAP(sys_reg(3, 3, 15, 0, 0),
> +      sys_reg(3, 3, 15, 15, 7), CGT_HCR_TIDCP),
> + SR_RANGE_TRAP(sys_reg(3, 4, 15, 0, 0),
> +      sys_reg(3, 4, 15, 15, 7), CGT_HCR_TIDCP),
> + SR_RANGE_TRAP(sys_reg(3, 5, 15, 0, 0),
> +      sys_reg(3, 5, 15, 15, 7), CGT_HCR_TIDCP),
> + SR_RANGE_TRAP(sys_reg(3, 6, 15, 0, 0),
> +      sys_reg(3, 6, 15, 15, 7), CGT_HCR_TIDCP),
> + SR_RANGE_TRAP(sys_reg(3, 7, 15, 0, 0),
> +      sys_reg(3, 7, 15, 15, 7), CGT_HCR_TIDCP),
> + SR_TRAP(SYS_ACTLR_EL1, CGT_HCR_TACR),
> + SR_TRAP(SYS_DC_ISW, CGT_HCR_TSW),
> + SR_TRAP(SYS_DC_CSW, CGT_HCR_TSW),
> + SR_TRAP(SYS_DC_CISW, CGT_HCR_TSW),
> + SR_TRAP(SYS_DC_IGSW, CGT_HCR_TSW),
> + SR_TRAP(SYS_DC_IGDSW, CGT_HCR_TSW),
> + SR_TRAP(SYS_DC_CGSW, CGT_HCR_TSW),
> + SR_TRAP(SYS_DC_CGDSW, CGT_HCR_TSW),
> + SR_TRAP(SYS_DC_CIGSW, CGT_HCR_TSW),
> + SR_TRAP(SYS_DC_CIGDSW, CGT_HCR_TSW),
> + SR_TRAP(SYS_DC_CIVAC, CGT_HCR_TPC),
> + SR_TRAP(SYS_DC_CVAC, CGT_HCR_TPC),
> + SR_TRAP(SYS_DC_CVAP, CGT_HCR_TPC),
> + SR_TRAP(SYS_DC_CVADP, CGT_HCR_TPC),
> + SR_TRAP(SYS_DC_IVAC, CGT_HCR_TPC),
> + SR_TRAP(SYS_DC_CIGVAC, CGT_HCR_TPC),
> + SR_TRAP(SYS_DC_CIGDVAC, CGT_HCR_TPC),
> + SR_TRAP(SYS_DC_IGVAC, CGT_HCR_TPC),
> + SR_TRAP(SYS_DC_IGDVAC, CGT_HCR_TPC),
> + SR_TRAP(SYS_DC_CGVAC, CGT_HCR_TPC),
> + SR_TRAP(SYS_DC_CGDVAC, CGT_HCR_TPC),
> + SR_TRAP(SYS_DC_CGVAP, CGT_HCR_TPC),
> + SR_TRAP(SYS_DC_CGDVAP, CGT_HCR_TPC),
> + SR_TRAP(SYS_DC_CGVADP, CGT_HCR_TPC),
> + SR_TRAP(SYS_DC_CGDVADP, CGT_HCR_TPC),
> + SR_TRAP(SYS_IC_IVAU, CGT_HCR_TPU_TOCU),
> + SR_TRAP(SYS_IC_IALLU, CGT_HCR_TPU_TOCU),
> + SR_TRAP(SYS_IC_IALLUIS, CGT_HCR_TPU_TICAB),
> + SR_TRAP(SYS_DC_CVAU, CGT_HCR_TPU_TOCU),
> + SR_TRAP(OP_TLBI_RVAE1, CGT_HCR_TTLB),
> + SR_TRAP(OP_TLBI_RVAAE1, CGT_HCR_TTLB),
> + SR_TRAP(OP_TLBI_RVALE1, CGT_HCR_TTLB),
> + SR_TRAP(OP_TLBI_RVAALE1, CGT_HCR_TTLB),
> + SR_TRAP(OP_TLBI_VMALLE1, CGT_HCR_TTLB),
> + SR_TRAP(OP_TLBI_VAE1, CGT_HCR_TTLB),
> + SR_TRAP(OP_TLBI_ASIDE1, CGT_HCR_TTLB),
> + SR_TRAP(OP_TLBI_VAAE1, CGT_HCR_TTLB),
> + SR_TRAP(OP_TLBI_VALE1, CGT_HCR_TTLB),
> + SR_TRAP(OP_TLBI_VAALE1, CGT_HCR_TTLB),
> + SR_TRAP(OP_TLBI_RVAE1NXS, CGT_HCR_TTLB),
> + SR_TRAP(OP_TLBI_RVAAE1NXS, CGT_HCR_TTLB),
> + SR_TRAP(OP_TLBI_RVALE1NXS, CGT_HCR_TTLB),
> + SR_TRAP(OP_TLBI_RVAALE1NXS, CGT_HCR_TTLB),
> + SR_TRAP(OP_TLBI_VMALLE1NXS, CGT_HCR_TTLB),
> + SR_TRAP(OP_TLBI_VAE1NXS, CGT_HCR_TTLB),
> + SR_TRAP(OP_TLBI_ASIDE1NXS, CGT_HCR_TTLB),
> + SR_TRAP(OP_TLBI_VAAE1NXS, CGT_HCR_TTLB),
> + SR_TRAP(OP_TLBI_VALE1NXS, CGT_HCR_TTLB),
> + SR_TRAP(OP_TLBI_VAALE1NXS, CGT_HCR_TTLB),
> + SR_TRAP(OP_TLBI_RVAE1IS, CGT_HCR_TTLB_TTLBIS),
> + SR_TRAP(OP_TLBI_RVAAE1IS, CGT_HCR_TTLB_TTLBIS),
> + SR_TRAP(OP_TLBI_RVALE1IS, CGT_HCR_TTLB_TTLBIS),
> + SR_TRAP(OP_TLBI_RVAALE1IS, CGT_HCR_TTLB_TTLBIS),
> + SR_TRAP(OP_TLBI_VMALLE1IS, CGT_HCR_TTLB_TTLBIS),
> + SR_TRAP(OP_TLBI_VAE1IS, CGT_HCR_TTLB_TTLBIS),
> + SR_TRAP(OP_TLBI_ASIDE1IS, CGT_HCR_TTLB_TTLBIS),
> + SR_TRAP(OP_TLBI_VAAE1IS, CGT_HCR_TTLB_TTLBIS),
> + SR_TRAP(OP_TLBI_VALE1IS, CGT_HCR_TTLB_TTLBIS),
> + SR_TRAP(OP_TLBI_VAALE1IS, CGT_HCR_TTLB_TTLBIS),
> + SR_TRAP(OP_TLBI_RVAE1ISNXS, CGT_HCR_TTLB_TTLBIS),
> + SR_TRAP(OP_TLBI_RVAAE1ISNXS, CGT_HCR_TTLB_TTLBIS),
> + SR_TRAP(OP_TLBI_RVALE1ISNXS, CGT_HCR_TTLB_TTLBIS),
> + SR_TRAP(OP_TLBI_RVAALE1ISNXS, CGT_HCR_TTLB_TTLBIS),
> + SR_TRAP(OP_TLBI_VMALLE1ISNXS, CGT_HCR_TTLB_TTLBIS),
> + SR_TRAP(OP_TLBI_VAE1ISNXS, CGT_HCR_TTLB_TTLBIS),
> + SR_TRAP(OP_TLBI_ASIDE1ISNXS, CGT_HCR_TTLB_TTLBIS),
> + SR_TRAP(OP_TLBI_VAAE1ISNXS, CGT_HCR_TTLB_TTLBIS),
> + SR_TRAP(OP_TLBI_VALE1ISNXS, CGT_HCR_TTLB_TTLBIS),
> + SR_TRAP(OP_TLBI_VAALE1ISNXS, CGT_HCR_TTLB_TTLBIS),
> + SR_TRAP(OP_TLBI_VMALLE1OS, CGT_HCR_TTLB_TTLBOS),
> + SR_TRAP(OP_TLBI_VAE1OS, CGT_HCR_TTLB_TTLBOS),
> + SR_TRAP(OP_TLBI_ASIDE1OS, CGT_HCR_TTLB_TTLBOS),
> + SR_TRAP(OP_TLBI_VAAE1OS, CGT_HCR_TTLB_TTLBOS),
> + SR_TRAP(OP_TLBI_VALE1OS, CGT_HCR_TTLB_TTLBOS),
> + SR_TRAP(OP_TLBI_VAALE1OS, CGT_HCR_TTLB_TTLBOS),
> + SR_TRAP(OP_TLBI_RVAE1OS, CGT_HCR_TTLB_TTLBOS),
> + SR_TRAP(OP_TLBI_RVAAE1OS, CGT_HCR_TTLB_TTLBOS),
> + SR_TRAP(OP_TLBI_RVALE1OS, CGT_HCR_TTLB_TTLBOS),
> + SR_TRAP(OP_TLBI_RVAALE1OS, CGT_HCR_TTLB_TTLBOS),
> + SR_TRAP(OP_TLBI_VMALLE1OSNXS, CGT_HCR_TTLB_TTLBOS),
> + SR_TRAP(OP_TLBI_VAE1OSNXS, CGT_HCR_TTLB_TTLBOS),
> + SR_TRAP(OP_TLBI_ASIDE1OSNXS, CGT_HCR_TTLB_TTLBOS),
> + SR_TRAP(OP_TLBI_VAAE1OSNXS, CGT_HCR_TTLB_TTLBOS),
> + SR_TRAP(OP_TLBI_VALE1OSNXS, CGT_HCR_TTLB_TTLBOS),
> + SR_TRAP(OP_TLBI_VAALE1OSNXS, CGT_HCR_TTLB_TTLBOS),
> + SR_TRAP(OP_TLBI_RVAE1OSNXS, CGT_HCR_TTLB_TTLBOS),
> + SR_TRAP(OP_TLBI_RVAAE1OSNXS, CGT_HCR_TTLB_TTLBOS),
> + SR_TRAP(OP_TLBI_RVALE1OSNXS, CGT_HCR_TTLB_TTLBOS),
> + SR_TRAP(OP_TLBI_RVAALE1OSNXS, CGT_HCR_TTLB_TTLBOS),
> + SR_TRAP(SYS_SCTLR_EL1, CGT_HCR_TVM_TRVM),
> + SR_TRAP(SYS_TTBR0_EL1, CGT_HCR_TVM_TRVM),
> + SR_TRAP(SYS_TTBR1_EL1, CGT_HCR_TVM_TRVM),
> + SR_TRAP(SYS_TCR_EL1, CGT_HCR_TVM_TRVM),
> + SR_TRAP(SYS_ESR_EL1, CGT_HCR_TVM_TRVM),
> + SR_TRAP(SYS_FAR_EL1, CGT_HCR_TVM_TRVM),
> + SR_TRAP(SYS_AFSR0_EL1, CGT_HCR_TVM_TRVM),
> + SR_TRAP(SYS_AFSR1_EL1, CGT_HCR_TVM_TRVM),
> + SR_TRAP(SYS_MAIR_EL1, CGT_HCR_TVM_TRVM),
> + SR_TRAP(SYS_AMAIR_EL1, CGT_HCR_TVM_TRVM),
> + SR_TRAP(SYS_CONTEXTIDR_EL1, CGT_HCR_TVM_TRVM),
> + SR_TRAP(SYS_DC_ZVA, CGT_HCR_TDZ),
> + SR_TRAP(SYS_DC_GVA, CGT_HCR_TDZ),
> + SR_TRAP(SYS_DC_GZVA, CGT_HCR_TDZ),
> + SR_TRAP(SYS_LORSA_EL1, CGT_HCR_TLOR),
> + SR_TRAP(SYS_LOREA_EL1, CGT_HCR_TLOR),
> + SR_TRAP(SYS_LORN_EL1, CGT_HCR_TLOR),
> + SR_TRAP(SYS_LORC_EL1, CGT_HCR_TLOR),
> + SR_TRAP(SYS_LORID_EL1, CGT_HCR_TLOR),
> + SR_TRAP(SYS_ERRIDR_EL1, CGT_HCR_TERR),
> + SR_TRAP(SYS_ERRSELR_EL1, CGT_HCR_TERR),
> + SR_TRAP(SYS_ERXADDR_EL1, CGT_HCR_TERR),
> + SR_TRAP(SYS_ERXCTLR_EL1, CGT_HCR_TERR),
> + SR_TRAP(SYS_ERXFR_EL1, CGT_HCR_TERR),
> + SR_TRAP(SYS_ERXMISC0_EL1, CGT_HCR_TERR),
> + SR_TRAP(SYS_ERXMISC1_EL1, CGT_HCR_TERR),
> + SR_TRAP(SYS_ERXMISC2_EL1, CGT_HCR_TERR),
> + SR_TRAP(SYS_ERXMISC3_EL1, CGT_HCR_TERR),
> + SR_TRAP(SYS_ERXSTATUS_EL1, CGT_HCR_TERR),
> + SR_TRAP(SYS_APIAKEYLO_EL1, CGT_HCR_APK),
> + SR_TRAP(SYS_APIAKEYHI_EL1, CGT_HCR_APK),
> + SR_TRAP(SYS_APIBKEYLO_EL1, CGT_HCR_APK),
> + SR_TRAP(SYS_APIBKEYHI_EL1, CGT_HCR_APK),
> + SR_TRAP(SYS_APDAKEYLO_EL1, CGT_HCR_APK),
> + SR_TRAP(SYS_APDAKEYHI_EL1, CGT_HCR_APK),
> + SR_TRAP(SYS_APDBKEYLO_EL1, CGT_HCR_APK),
> + SR_TRAP(SYS_APDBKEYHI_EL1, CGT_HCR_APK),
> + SR_TRAP(SYS_APGAKEYLO_EL1, CGT_HCR_APK),
> + SR_TRAP(SYS_APGAKEYHI_EL1, CGT_HCR_APK),
> + /* All _EL2 registers */
> + SR_RANGE_TRAP(sys_reg(3, 4, 0, 0, 0),
> +      sys_reg(3, 4, 3, 15, 7), CGT_HCR_NV),
> + /* Skip the SP_EL1 encoding... */
> + SR_RANGE_TRAP(sys_reg(3, 4, 4, 1, 1),
> +      sys_reg(3, 4, 10, 15, 7), CGT_HCR_NV),
> + SR_RANGE_TRAP(sys_reg(3, 4, 12, 0, 0),
> +      sys_reg(3, 4, 14, 15, 7), CGT_HCR_NV),

Should SPSR_EL2 and ELR_EL2 be considered also?

Thanks,
Miguel

> + /* All _EL02, _EL12 registers */
> + SR_RANGE_TRAP(sys_reg(3, 5, 0, 0, 0),
> +      sys_reg(3, 5, 10, 15, 7), CGT_HCR_NV),
> + SR_RANGE_TRAP(sys_reg(3, 5, 12, 0, 0),
> +      sys_reg(3, 5, 14, 15, 7), CGT_HCR_NV),
> + SR_TRAP(OP_AT_S1E2R, CGT_HCR_NV),
> + SR_TRAP(OP_AT_S1E2W, CGT_HCR_NV),
> + SR_TRAP(OP_AT_S12E1R, CGT_HCR_NV),
> + SR_TRAP(OP_AT_S12E1W, CGT_HCR_NV),
> + SR_TRAP(OP_AT_S12E0R, CGT_HCR_NV),
> + SR_TRAP(OP_AT_S12E0W, CGT_HCR_NV),
> + SR_TRAP(OP_TLBI_IPAS2E1, CGT_HCR_NV),
> + SR_TRAP(OP_TLBI_RIPAS2E1, CGT_HCR_NV),
> + SR_TRAP(OP_TLBI_IPAS2LE1, CGT_HCR_NV),
> + SR_TRAP(OP_TLBI_RIPAS2LE1, CGT_HCR_NV),
> + SR_TRAP(OP_TLBI_RVAE2, CGT_HCR_NV),
> + SR_TRAP(OP_TLBI_RVALE2, CGT_HCR_NV),
> + SR_TRAP(OP_TLBI_ALLE2, CGT_HCR_NV),
> + SR_TRAP(OP_TLBI_VAE2, CGT_HCR_NV),
> + SR_TRAP(OP_TLBI_ALLE1, CGT_HCR_NV),
> + SR_TRAP(OP_TLBI_VALE2, CGT_HCR_NV),
> + SR_TRAP(OP_TLBI_VMALLS12E1, CGT_HCR_NV),
> + SR_TRAP(OP_TLBI_IPAS2E1NXS, CGT_HCR_NV),
> + SR_TRAP(OP_TLBI_RIPAS2E1NXS, CGT_HCR_NV),
> + SR_TRAP(OP_TLBI_IPAS2LE1NXS, CGT_HCR_NV),
> + SR_TRAP(OP_TLBI_RIPAS2LE1NXS, CGT_HCR_NV),
> + SR_TRAP(OP_TLBI_RVAE2NXS, CGT_HCR_NV),
> + SR_TRAP(OP_TLBI_RVALE2NXS, CGT_HCR_NV),
> + SR_TRAP(OP_TLBI_ALLE2NXS, CGT_HCR_NV),
> + SR_TRAP(OP_TLBI_VAE2NXS, CGT_HCR_NV),
> + SR_TRAP(OP_TLBI_ALLE1NXS, CGT_HCR_NV),
> + SR_TRAP(OP_TLBI_VALE2NXS, CGT_HCR_NV),
> + SR_TRAP(OP_TLBI_VMALLS12E1NXS, CGT_HCR_NV),
> + SR_TRAP(OP_TLBI_IPAS2E1IS, CGT_HCR_NV),
> + SR_TRAP(OP_TLBI_RIPAS2E1IS, CGT_HCR_NV),
> + SR_TRAP(OP_TLBI_IPAS2LE1IS, CGT_HCR_NV),
> + SR_TRAP(OP_TLBI_RIPAS2LE1IS, CGT_HCR_NV),
> + SR_TRAP(OP_TLBI_RVAE2IS, CGT_HCR_NV),
> + SR_TRAP(OP_TLBI_RVALE2IS, CGT_HCR_NV),
> + SR_TRAP(OP_TLBI_ALLE2IS, CGT_HCR_NV),
> + SR_TRAP(OP_TLBI_VAE2IS, CGT_HCR_NV),
> + SR_TRAP(OP_TLBI_ALLE1IS, CGT_HCR_NV),
> + SR_TRAP(OP_TLBI_VALE2IS, CGT_HCR_NV),
> + SR_TRAP(OP_TLBI_VMALLS12E1IS, CGT_HCR_NV),
> + SR_TRAP(OP_TLBI_IPAS2E1ISNXS, CGT_HCR_NV),
> + SR_TRAP(OP_TLBI_RIPAS2E1ISNXS, CGT_HCR_NV),
> + SR_TRAP(OP_TLBI_IPAS2LE1ISNXS, CGT_HCR_NV),
> + SR_TRAP(OP_TLBI_RIPAS2LE1ISNXS, CGT_HCR_NV),
> + SR_TRAP(OP_TLBI_RVAE2ISNXS, CGT_HCR_NV),
> + SR_TRAP(OP_TLBI_RVALE2ISNXS, CGT_HCR_NV),
> + SR_TRAP(OP_TLBI_ALLE2ISNXS, CGT_HCR_NV),
> + SR_TRAP(OP_TLBI_VAE2ISNXS, CGT_HCR_NV),
> + SR_TRAP(OP_TLBI_ALLE1ISNXS, CGT_HCR_NV),
> + SR_TRAP(OP_TLBI_VALE2ISNXS, CGT_HCR_NV),
> + SR_TRAP(OP_TLBI_VMALLS12E1ISNXS,CGT_HCR_NV),
> + SR_TRAP(OP_TLBI_ALLE2OS, CGT_HCR_NV),
> + SR_TRAP(OP_TLBI_VAE2OS, CGT_HCR_NV),
> + SR_TRAP(OP_TLBI_ALLE1OS, CGT_HCR_NV),
> + SR_TRAP(OP_TLBI_VALE2OS, CGT_HCR_NV),
> + SR_TRAP(OP_TLBI_VMALLS12E1OS, CGT_HCR_NV),
> + SR_TRAP(OP_TLBI_IPAS2E1OS, CGT_HCR_NV),
> + SR_TRAP(OP_TLBI_RIPAS2E1OS, CGT_HCR_NV),
> + SR_TRAP(OP_TLBI_IPAS2LE1OS, CGT_HCR_NV),
> + SR_TRAP(OP_TLBI_RIPAS2LE1OS, CGT_HCR_NV),
> + SR_TRAP(OP_TLBI_RVAE2OS, CGT_HCR_NV),
> + SR_TRAP(OP_TLBI_RVALE2OS, CGT_HCR_NV),
> + SR_TRAP(OP_TLBI_ALLE2OSNXS, CGT_HCR_NV),
> + SR_TRAP(OP_TLBI_VAE2OSNXS, CGT_HCR_NV),
> + SR_TRAP(OP_TLBI_ALLE1OSNXS, CGT_HCR_NV),
> + SR_TRAP(OP_TLBI_VALE2OSNXS, CGT_HCR_NV),
> + SR_TRAP(OP_TLBI_VMALLS12E1OSNXS,CGT_HCR_NV),
> + SR_TRAP(OP_TLBI_IPAS2E1OSNXS, CGT_HCR_NV),
> + SR_TRAP(OP_TLBI_RIPAS2E1OSNXS, CGT_HCR_NV),
> + SR_TRAP(OP_TLBI_IPAS2LE1OSNXS, CGT_HCR_NV),
> + SR_TRAP(OP_TLBI_RIPAS2LE1OSNXS, CGT_HCR_NV),
> + SR_TRAP(OP_TLBI_RVAE2OSNXS, CGT_HCR_NV),
> + SR_TRAP(OP_TLBI_RVALE2OSNXS, CGT_HCR_NV),
> + SR_TRAP(OP_CPP_RCTX, CGT_HCR_NV),
> + SR_TRAP(OP_DVP_RCTX, CGT_HCR_NV),
> + SR_TRAP(OP_CFP_RCTX, CGT_HCR_NV),
> + SR_TRAP(SYS_SP_EL1, CGT_HCR_NV_nNV2),
> + SR_TRAP(SYS_VBAR_EL1, CGT_HCR_NV1_nNV2),
> + SR_TRAP(SYS_ELR_EL1, CGT_HCR_NV1_nNV2),
> + SR_TRAP(SYS_SPSR_EL1, CGT_HCR_NV1_nNV2),
> + SR_TRAP(SYS_SCXTNUM_EL1, CGT_HCR_NV1_nNV2_ENSCXT),
> + SR_TRAP(SYS_SCXTNUM_EL0, CGT_HCR_ENSCXT),
> + SR_TRAP(OP_AT_S1E1R, CGT_HCR_AT),
> + SR_TRAP(OP_AT_S1E1W, CGT_HCR_AT),
> + SR_TRAP(OP_AT_S1E0R, CGT_HCR_AT),
> + SR_TRAP(OP_AT_S1E0W, CGT_HCR_AT),
> + SR_TRAP(OP_AT_S1E1RP, CGT_HCR_AT),
> + SR_TRAP(OP_AT_S1E1WP, CGT_HCR_AT),
> + SR_TRAP(SYS_ERXPFGF_EL1, CGT_HCR_nFIEN),
> + SR_TRAP(SYS_ERXPFGCTL_EL1, CGT_HCR_nFIEN),
> + SR_TRAP(SYS_ERXPFGCDN_EL1, CGT_HCR_nFIEN),
> };
>=20
> static DEFINE_XARRAY(sr_forward_xa);
> --=20
> 2.34.1
>=20
>=20

