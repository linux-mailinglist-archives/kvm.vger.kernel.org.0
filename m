Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0022375837F
	for <lists+kvm@lfdr.de>; Tue, 18 Jul 2023 19:31:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232290AbjGRRbH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jul 2023 13:31:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230215AbjGRRbF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jul 2023 13:31:05 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AFC310CB
        for <kvm@vger.kernel.org>; Tue, 18 Jul 2023 10:31:04 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36IHP6Sf001554;
        Tue, 18 Jul 2023 17:30:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=s6qqAM0JW8a+1UVLHjmr4nYgMi062ZpBeUqk+EVoC4U=;
 b=OtvTLcAfcZAQrMPnMlgx3qQ9OU0dFabFp6ocIaT0vEO6e2TxN2oZjw6mdxbhBlXyFM2R
 TkMF9gZtxtSRPvD31FxsvkdB7Qd4J1VzIN0VgLxZQZP4obiuyt4Zw7c+l2cB1RBtGv6F
 qwhoAr3vWsjIiz4HxQJARf5V9raTzctLxrf+zuRQp43l32HTvE7kgmCCwfvsOFu46jFN
 UZOPc3Qrp6TEudjBItBLVsuOcaoduSGhNa8jTiTAssWi3lbU35nb/NG0/2L4s+YB1A0w
 PebJxpZS8hMxEA9m+k4vh4otUjC4ZxjAsFjlj1OuO9hNzn0wKcB3jLkPCyrN+JBhizc1 TQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3run8a5qwh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jul 2023 17:30:25 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36IGhgl2019336;
        Tue, 18 Jul 2023 17:30:24 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2175.outbound.protection.outlook.com [104.47.59.175])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ruhw5xjsw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jul 2023 17:30:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FFn/MteblDW1dG/MKCDbsrekOZAoRpd6w0zjr/LB0QtdK6EF+fQ4tYgY8jvft9qQJSeMZrKMwZfBkhzbXJPyIs6aSQ6zk41bPPVp9aU2rEFiwYl1AX2GyNwFKk4sB2P273n1ecTbSpMuhD8U62fXF05zLe4AinJQYcS94g4cmtaV1x8HperTeZvK4zwud/ibYnyGNa0dMXNW7/C8Wvhv5nGEuIwTqIcDX9/Np0SwPKl6TuG7VIF6YGGI10+4+lHxXo0xsIIdY4YD9FuruBntpUVMf42snw/zPcp8Okxpa740jUJfuBqe14/h3TEGkjBPphvc9ePFK51kP9gffPouKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s6qqAM0JW8a+1UVLHjmr4nYgMi062ZpBeUqk+EVoC4U=;
 b=J7uJGwXWIn610OItDZbBqsrlwC+unG4+GjVtJ1lbtqvGcdwPNt+u8TZNINTaG4qFRsZzXy6mRBkHlf0OKGbzsn1ZOoesZZeE6kyhovwTMsLC4nNK6tOaHXpV2BAv5SZUzY6nx8zENT9jzi3ZokcoZ7p0PoJWq7qlmy5P+WPklLYQT8coYwa51ogn2FCv+Q3X/WOMhUbqJa4prTxc73lFYEtfNnFnXIG/irSeIapcGZHLsWGTj1H7+dxKp52V3mnF5YAlMVLfpKyrbAbUvNS5avcxvzl6TwNK5ahLJSWQ7KUoSgZ1uS9L5Y1Mc59GT9B1BIrJbgE25dd1oMI8EKe4yA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s6qqAM0JW8a+1UVLHjmr4nYgMi062ZpBeUqk+EVoC4U=;
 b=qe2kDMn1Shx558gO5ucbecFJOYQpOmlzzu4BjhV7KeOvxITJ2Ud9bu4ehRioceOVBuayTD2/xbW7ofD2kLEMQy1K9aPad/V7lT2MG55VnXo1I+hpXxrLm747bPuf6bczWNCU6rwudIflHBSur0EPkqOafsDrCVnEh+QJ56UsWIs=
Received: from PH0PR10MB5433.namprd10.prod.outlook.com (2603:10b6:510:e0::9)
 by PH7PR10MB6458.namprd10.prod.outlook.com (2603:10b6:510:1ed::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.33; Tue, 18 Jul
 2023 17:30:21 +0000
Received: from PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::2cd:1872:970d:7c4e]) by PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::2cd:1872:970d:7c4e%4]) with mapi id 15.20.6588.031; Tue, 18 Jul 2023
 17:30:21 +0000
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
Subject: Re: [PATCH 07/27] arm64: Add missing BRB/CFP/DVP/CPP instructions
Thread-Topic: [PATCH 07/27] arm64: Add missing BRB/CFP/DVP/CPP instructions
Thread-Index: AQHZtNFiQ6aHaOBpxECmuo9EmLnuv6+/0V4A
Date:   Tue, 18 Jul 2023 17:30:21 +0000
Message-ID: <D66F8916-F5D8-4E2C-B3DB-D8A00FFF677E@oracle.com>
References: <20230712145810.3864793-1-maz@kernel.org>
 <20230712145810.3864793-8-maz@kernel.org>
In-Reply-To: <20230712145810.3864793-8-maz@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR10MB5433:EE_|PH7PR10MB6458:EE_
x-ms-office365-filtering-correlation-id: 2da8137b-faad-4b89-3f36-08db87b4a9fc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Tc3JPqmja1OCpsRrOIttFZjLaYnS2pW/S48kEh8y/MwyU2FftPPBgOS4UEpyWxFNsi9X41MkfKqrPZLoYyTzpgaJrcewMc0JgGC+FdddxpB6RkK6+8wA/1KuzKc8/F9wed/VLWWSxFE0hN/g3fdj6Ji3bY97SwV0Jm46zY9BTcJoDIofA8Iz3Z/+JfmGC7LIGZD6EP3MGxsoz1JrafMrFI3DfTUORjJv1/2ilHCJ/uDqV1LSDVsDwiIU0N8GtIE+XuEqVo/EoElCOoc2d4d8067/mW7MIytYPZdlqlKnMbPRRx+1UHMhkX4i+0LBrjd4xYLOWugACjkIUpIcvoFhEqVOWqhTGfTA28UvG3py+YSo9H6EEPZM0HX8wPMdJNAvIKvWRMMsChjzm16W7fDxLeNPAquGI4P6b4tB6phTQM/tPqdGocmm6Y3EJrMaahvEwuhjfo8N3VUy2hRgfut317vdH6L7WyjCXH3oKDhPxDhDCN8fj2J2RA+m6avO+emIowHpzOlWGV85R5F6mUMVFCChm9JN98rvuipFqWricl08SeDcoqMZMlRHI/yN1X4GqyKSv+voT8JXf9vQNv5rmeWFqdiVYIASx7mK2AFtlVVi07PIOSe8QXzUdkRAFNLQLQ2PNMO1KXLHwN1PPHl1EQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5433.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(366004)(376002)(39860400002)(396003)(346002)(451199021)(86362001)(2906002)(33656002)(36756003)(38070700005)(44832011)(7416002)(186003)(53546011)(6506007)(26005)(38100700002)(54906003)(122000001)(6486002)(66946007)(91956017)(4326008)(6512007)(66476007)(66446008)(64756008)(66556008)(316002)(2616005)(6916009)(478600001)(71200400001)(76116006)(41300700001)(8676002)(8936002)(5660300002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?OVeC3ZIkZk7zsT92CDmmhr8C56OnICWGcSJmgLNtCSWFTetOkKj4TrTRa7G7?=
 =?us-ascii?Q?GHdfZ8BSznMAbaUIZyftXybcGl53Sy5Pf9bGuwzvWloG+XWa/u+HDNQX60UO?=
 =?us-ascii?Q?uuA2RMk1r5csuvpGs6sPqjeW1yaxPRafuaZiSFGRa5iaPmcqA1VbUO57d1bz?=
 =?us-ascii?Q?P/q65JwRrhoFsT6/nmj+aIBYVP7eqVQ8cX0cF08yTqeBWizkOHax+fNy98NR?=
 =?us-ascii?Q?zx1IN8TGLfTVaiU4xujEZS3Y2PbSDTO3oj0JUS5Rzr2pirLxOzXoVECoM2gX?=
 =?us-ascii?Q?ISOqUeFCJxPAKFioJqfJvtWC78DDv0XaR6wKtK7klCNqPWExwg570YtmfhyH?=
 =?us-ascii?Q?7Krrwj/GiBvcnDbXaXhVyISQb9/UKiFujg7xybA7WatktcllUVWu4BkyEbvp?=
 =?us-ascii?Q?Fc4EUmWs6tcsHmfz/YtHfe/KHmA2XWSQEFDdELhbAtFrk+x/7AGr/6AKPwjj?=
 =?us-ascii?Q?wT8NV4eYLygIHy9NW1+bmG8PaWI+RHEK5UoTWTE/Ie1J2EjGq6N74SleaNaO?=
 =?us-ascii?Q?U2I7HCWVihxEgx7wuhSzaFRTIJgEzgrgYCKq2Fox/eALBmRIVwv7mhcEFWrf?=
 =?us-ascii?Q?i3qTVzNEHPneSVb0uGLYMbX+4UVJ1G/KdSHUZQ5poA05QhIDzVTdhjeX6hWs?=
 =?us-ascii?Q?+56hCqYC/nJBT48JTGxC7d+lBscvD9MSzxELSKt2sZ2S7Y0OlTYUYDo2LC05?=
 =?us-ascii?Q?WEFpHdJVs2NQEJlFGQL/sApj7jlt/+54JO2gSy9nZ6/1q22IS7kHujbJ4gMy?=
 =?us-ascii?Q?RoF8B9SAqwqLHTDINIEnCkU8Ef/Yy+vsHFWGp1hMuwwbwMoj4Haurmr/JLhf?=
 =?us-ascii?Q?c7ra0cmtFjxkl0ShOPO/MWEfyjb2++TMf0c8kEylipDS/SrWERyxR4gfRWHN?=
 =?us-ascii?Q?o1PE7XzF79XWCKjbgyGc9d9tRFpZRkZ8hWFCuEIc7cg01pCbZ+c1x5Ecb3Ut?=
 =?us-ascii?Q?g9bOpIQxZBDYt9zWg3pwUkEr2G2try0ZO59RXS7TWa78bAGuX/Darqu9cX86?=
 =?us-ascii?Q?Y3od7sjsxpVyhQz2MegewJuLJ2eAVO4kwZGMAY/sJst9NpWBQrmCSuAoig2r?=
 =?us-ascii?Q?G+9SNz3mgol1zlyAwXf86lpKtOW03gLcAxMxhclChTxJXTHofTGN7ahY4b87?=
 =?us-ascii?Q?I/ckdDrDkplVq8nAJgylvup8h2ZRWkuoG/yt5fVszaI4l1fsHOfP2AM7n2l9?=
 =?us-ascii?Q?lb6k+aGFizT2EpJrp24oCefOnZGJPJG7HYPd40EtKHOJQ05LloRHgYQeFaMg?=
 =?us-ascii?Q?wDrFfW9H4PLaAluVfhS3AccWlZDWh24jVhjqbDRbrLG10K4iKg3RLyjc9v0S?=
 =?us-ascii?Q?ngbIh2vVdvlJzbjA54HTI5aE/qxuc+M2TOeH3okE67uaTtGwbIYlrtxc6qb/?=
 =?us-ascii?Q?XaKCCjc9fKA4YvaB0321+NVstTmEsVDa+z/VtWiLKznwj50S5ZjeylAbLypY?=
 =?us-ascii?Q?MxvFOSQznvZ8OOTlY2E1hwZR7BVmZbO1ArjmTGgQfKSL3qOMKLfV/kHDoc8j?=
 =?us-ascii?Q?UjgvpmgY9DmfyMIZaWJv9N079vvQk/Li0fUAr25YfLsb8ceFS4X6M42m8Ph4?=
 =?us-ascii?Q?WYpOpXPwIzZIA0JVhTgDcxRnEWfDsEfC1/WHaklLjK6D8QrJjOkcYTd/EYiP?=
 =?us-ascii?Q?8Q=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <739C6BCF1865E74E88C2DE6673AD373B@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?7Fp0uWTsZna2dEPdB3aL5jTGuq90nVlImJtKGfAiWHomvI8oVEFqjUGV/D1P?=
 =?us-ascii?Q?8ZKgS8Z+16kch/DFBaov+3qOxKJYtC4MdZGkUHMoTZqBqB0wOwxGw+QwBz3H?=
 =?us-ascii?Q?6mJqsoJGXKhobrmriRUjlgIOCCCv/8VadJKVQgJqDy0KstTyeUBwAq0lMUT7?=
 =?us-ascii?Q?5xGz228JUALUDwa4nKXQqETmRhE14MBanJvgOzAtAan28Vxw30SC/H1XHOmh?=
 =?us-ascii?Q?PW9fK3NhZ7WQ3hPUeYYm0LPj4fsxL+l/sI38zCEP4cERsqJHW6vV0pZuI+9z?=
 =?us-ascii?Q?guq7GIiBsS+3IEYT4bUc7kDTs/svW2vcdvSOsnHNlW7csbkX4vlJ0npihnx9?=
 =?us-ascii?Q?okaeORD/T248IWqIEr74W1cWQ6DmhCPnSeL5xb2aErhKkVIdd9j0BdRMkSWV?=
 =?us-ascii?Q?uxwhhqqmvTPDhg5HANp6B9q7VMSDzT8Wq1S0iAvsUwNEISNuG7DxRX1FD/XS?=
 =?us-ascii?Q?ZqjQ5Ea/qeghDRT8J3gALddOaF4U2HO2DIEzyUvSk3aVtnsuZEEXn0I2V0N2?=
 =?us-ascii?Q?BgIIlXcUp04sRk6ir9MK+d0Y4YlPX0Go0QpqYUzN6QuF2VLfLoF7hs5ZBJp2?=
 =?us-ascii?Q?CJQ+UDf3loTWlT9C2qAFroJcejwOcFSc+8rfRxoBdOJVmmEEs0YO9X2PJMNQ?=
 =?us-ascii?Q?8Fa52QMO80rIqYGDr2RAmE9lTpLKYjevzBurY7WmCFKrc7fhflRmuT3obD3S?=
 =?us-ascii?Q?J/J+SA3+06sRCOZevkSBDv100lzvQPMbyfvKKzMgudF61Kn1nFB8VF6HS516?=
 =?us-ascii?Q?+A7lYGE9FXVKSD2m0Gl3XwfZtgNYJpI0M034G30U8RfCbIcM4dX2c3R/bmyA?=
 =?us-ascii?Q?eu372gLhw+6ZqTGtXGfzC1BCmlyMaUcoEUrYcL5l+Jap3Qwax+Uh+w+hCCRn?=
 =?us-ascii?Q?jMr811uqRiYlHV0XxOPoNeFwZLUBJSz8vQJ2Ebr+4skZJFwszo0B3hh/z2RM?=
 =?us-ascii?Q?6uzjnReMECi7W5+NHsvER2JkqyHQcRPe7bIMXHjCTvQaD3tBQFXZZZSsazKG?=
 =?us-ascii?Q?rXvb4W+LmemNmsMqo0a4KMOPJx7+m5qXA0QDj5zkPPOe5+g=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5433.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2da8137b-faad-4b89-3f36-08db87b4a9fc
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jul 2023 17:30:21.8265
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tFs3PGpiTQcDvPFd50j7z9nDAKi9g3NAMyalWpvjd8DzASS8saNoNosDFczRojYyuEIT1ThCMpN+5ryPpdGi0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6458
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-18_13,2023-07-18_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxscore=0 adultscore=0 spamscore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2307180160
X-Proofpoint-GUID: CS7R6BQYCdq_lFNGNy9NSUx19YLKd0OL
X-Proofpoint-ORIG-GUID: CS7R6BQYCdq_lFNGNy9NSUx19YLKd0OL
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

> On 12 Jul 2023, at 14:57, Marc Zyngier <maz@kernel.org> wrote:
>=20
> HFGITR_EL2 traps a bunch of instructions for which we don't have
> encodings yet. Add them.
>=20
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
> arch/arm64/include/asm/sysreg.h | 7 +++++++
> 1 file changed, 7 insertions(+)
>=20
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sys=
reg.h
> index 9dfd127be55a..e2357529c633 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -737,6 +737,13 @@
> #define OP_TLBI_VALE2NXS sys_insn(1, 4, 9, 7, 5)
> #define OP_TLBI_VMALLS12E1NXS sys_insn(1, 4, 9, 7, 6)
>=20
> +/* Misc instructions */
> +#define OP_BRB_IALL sys_insn(1, 1, 7, 2, 4)
> +#define OP_BRB_INJ sys_insn(1, 1, 7, 2, 5)
> +#define OP_CFP_RCTX sys_insn(1, 3, 7, 3, 4)
> +#define OP_DVP_RCTX sys_insn(1, 3, 7, 3, 5)
> +#define OP_CPP_RCTX sys_insn(1, 3, 7, 3, 7)
> +

As documented in DDI0487J.a

Reviewed-by: Miguel Luis <miguel.luis@oracle.com>

Miguel

> /* Common SCTLR_ELx flags. */
> #define SCTLR_ELx_ENTP2 (BIT(60))
> #define SCTLR_ELx_DSSBS (BIT(44))
> --=20
> 2.34.1
>=20

