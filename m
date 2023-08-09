Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B58A776737
	for <lists+kvm@lfdr.de>; Wed,  9 Aug 2023 20:29:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230080AbjHIS3H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Aug 2023 14:29:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjHIS3G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Aug 2023 14:29:06 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE2DEA3
        for <kvm@vger.kernel.org>; Wed,  9 Aug 2023 11:29:04 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 379IEhmg014101;
        Wed, 9 Aug 2023 18:28:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=Fd15xHK0jiXpDKR2EcUo224nUPNkJaE4n8OyZtOoq3o=;
 b=1oHg49Qad2hCZShkilO3/w4t472PxtxndEg3GhQknPJtvmvBlNwpYnHAbvHs3gm6Xqu3
 jQbjIpzu3n28nIFskOzJQMgYbfGLExiVlpyu+kDc8/tlVhY3SbaLvKKkwhjv64DQlBRD
 lT7spaSE0NLBC61831pHFuXugfNWUD2SaXnqOtyEdZ9u1fUF/kxdc/c+CQKCnSSJUGeK
 MYx2CpwYzgxVz3dngVY+X5eeWW6+cNS0oQFs72UHCp2Fd5EIiFCQEYRbCFyN7W63MPRU
 fCPrjZmbWH+V265+TVQfEotaMEyiwrbbYMA57M1Ze4OB/t11B4B+TscEkRha+mu/TlCr CA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s9eaasdu6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Aug 2023 18:28:33 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 379HLMcm006528;
        Wed, 9 Aug 2023 18:28:32 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3s9cvedskr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Aug 2023 18:28:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JJNvgq9BwGbLYsSa3RBrTe47rHGST5z8nFZ8uqbmhT8MtiU6SmPByD6sSqHDUnpHNe4IQnj0bhYWVq5zOk5IxzLqsAooEgsj8zDHpMptdYDBZrf+kpmcPpyd7h6UffxoPbtB5K2Wm/1Eqllp06DarPVs3johI5WxTt0CrPutgua+7ttRiAYaX0MovCB1DBbdq2cv1wlmiEuJPNL0wndehP7+eyzwLNUTm/L0KpFA20WzyLJ3iBcN/mRfBHsxlAiBH0PwDoqggXLXhJuR3R8+e+izAiArVTC6ScXF2RlBV0f9M0IZ1OyAIYbZm3m4dW880qZZbvw6pKC6spwWEfCwwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fd15xHK0jiXpDKR2EcUo224nUPNkJaE4n8OyZtOoq3o=;
 b=R5SBm4v/+hkSkUdu13KvyKy/KgtI1AxPDrnFhM4RFeGzVPQRkqeW0C8rquGkUTRj6g3i9OE8bti5hXjReXdAisc5v+VGiYTpo1IRK2U8oJ6qPT9aq+1HEfuF2NdRJmB2gMi0lvj+Z8WuSBbiNH6/hV4I1w/fGGtgeKnxcGsmXaBsHxEihev+pshRKzNTFwPK2tKd/pCwx/M3FoHIfGGKbO78JF8KxBjn3A3JJ00OUdkUgvQYOABwf7MLua3L+4nPaRI8G9sbmEijgz5JGnuohx3m4cWSzgCiotUl2O1FYgLfpIbVKp351oG5JYQfbwHWYgk1goP3xk89INfADO6/Bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fd15xHK0jiXpDKR2EcUo224nUPNkJaE4n8OyZtOoq3o=;
 b=kJ4Vi8MnvCfjPKk24n+MmviEO5qquwY9ive9pjXAB2ewtWvniT7gr0/Bg258hgfNnzlkuWZwnWlsqdUhLuSYNtLvaPU0r/8yHcmgB9CSkyP2EbnWfeBEhPChOrjXgYd4yUwhixIMoS+9Je9TYqwzckaURw7VPxmn9S7roxq0OtI=
Received: from PH0PR10MB5433.namprd10.prod.outlook.com (2603:10b6:510:e0::9)
 by CH3PR10MB7743.namprd10.prod.outlook.com (2603:10b6:610:1bd::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.28; Wed, 9 Aug
 2023 18:28:08 +0000
Received: from PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::76c:cb31:2005:d10c]) by PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::76c:cb31:2005:d10c%5]) with mapi id 15.20.6652.028; Wed, 9 Aug 2023
 18:28:08 +0000
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
Subject: Re: [PATCH v3 14/27] KVM: arm64: nv: Add trap forwarding
 infrastructure
Thread-Topic: [PATCH v3 14/27] KVM: arm64: nv: Add trap forwarding
 infrastructure
Thread-Index: AQHZye5DKsDWpClFD0qW3DmHGMEP+K/iSpIA
Date:   Wed, 9 Aug 2023 18:28:08 +0000
Message-ID: <65770FF0-A864-4678-8280-AE9BD666CC12@oracle.com>
References: <20230808114711.2013842-1-maz@kernel.org>
 <20230808114711.2013842-15-maz@kernel.org>
In-Reply-To: <20230808114711.2013842-15-maz@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR10MB5433:EE_|CH3PR10MB7743:EE_
x-ms-office365-filtering-correlation-id: 6ebe6fc9-db3a-4431-5406-08db9906615b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mzn9CF6lTGfkEuW3FMniSZ7nKegjptolh8ZFRxNAXUJZhx/q/h3srv0WbYLpfIrh08vSXagS5uYZB60TBakPebwHUfNzMj4e8mkcT5jJxjEJwXnWO2Cx0OhyRBLhFtq8DcyUOhx1NPnkmv4MMyZt7u56Onwy6HdoPFjNlKK9C+At6+qTV+M166IHGZuu5JOI/854k1FbrPySAS47iEWNBoKcUU8mDi+SSs4beJD20ZvDl6jxIcuNk09QjM2J5coWrSecr0dMfbg/g6uRVmheWLrTv9Urlk74t/FOsGooZNfX43DV4mYc4xHmYIYIbVmjGqkByOrhL9i5RWwAYMttbP2UoPBUGEh1U6TuzJ7eHM3LtyZa3Prt2bV6BwBRZLRsLTc7GdxplxYF74AN+mcB08gN/rH1AfN5sndExP/7nF/ZspQP+6c7ohYvVE1sRT0gw+z7iHaRgtwWFDxkiilD39peKlH+ZyKO5pIxhu62ay6BR9pTynTIKCvPfXLfk0J/RKA9E7a6Y5KNLekq2iFa9MxhOZzX4eA/nXiRopTnIfZseir17pPbFQQZt19FNUc/zi9fMDVvmRiKwR1eNMkkjOMcrJFYvLF8wsKu9Xd/JINjeWWgHKtZK9+fsKg0RteqajLVtn6KVt1yAP6at9O+xA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5433.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(366004)(346002)(39860400002)(376002)(136003)(451199021)(1800799006)(186006)(83380400001)(66556008)(66476007)(66946007)(91956017)(64756008)(76116006)(66446008)(5660300002)(86362001)(30864003)(2906002)(38100700002)(8676002)(8936002)(7416002)(122000001)(44832011)(41300700001)(38070700005)(478600001)(4326008)(6916009)(54906003)(6512007)(316002)(6506007)(26005)(71200400001)(33656002)(36756003)(6486002)(2616005)(53546011)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?5gISh7YMIpQNzc3A4/v2X6CPWg0XluTw1VMomqEtiaX4F5cMprGosSrqpgps?=
 =?us-ascii?Q?X9zi5Cq1UomJgVu8hX4SuA/ODCwUU31s7NOdIgy5iYey1HlsVEM27H+gKJWI?=
 =?us-ascii?Q?jU+Skrk5VctZYHucfq/yGYx9pyiNI+2uL6jHO74iFr1WGeKgMtMyOidyiiFE?=
 =?us-ascii?Q?xrjrRxcb0b2zX76HdMqZr4QqcmuLabw73wln5swXMe6yuQ9WWQgyIS6DkX9L?=
 =?us-ascii?Q?VO9wENzjNDVrQf5qKFtSwfl3q2DdZnqOBcL1phJN+AVsteffc4TY+hOUfYbN?=
 =?us-ascii?Q?iwNd4ym7Vtrw0QX3z1TntOpwY5PHsr6bLKYQ3EC2lxLsq2R044WInguD+5SC?=
 =?us-ascii?Q?8A+RKyGNoH2GS9XhJgKdMTsUqgQsW0Nh6rXfMY3lhA/WinkemxFxNGr1zYzL?=
 =?us-ascii?Q?Byg0trMsPk3cM7hmRdoF7ETe+CICHlnxUPjmUC0dlTYYrJzvboqbdNz/4kbG?=
 =?us-ascii?Q?RIrJFTLMAP/kqK+gl/CtDKY9gC4UI5oIuuYQhnvQxbBK9MQwBEW+u6gzG/GE?=
 =?us-ascii?Q?Bkej/oOtWAnrC699xQVUtej7AL93UKMc3iA4sOdSjjTJGYwPnxyqlzvrBIUE?=
 =?us-ascii?Q?bfzq90xnOBUHfObBj5qiMu99Y7CXa30VcZu+BGG3kfLH+xfnuazUicpTrlqM?=
 =?us-ascii?Q?Mm5nZq1IgBaRBZqKhypWOz5CdV8l45JhOQEOvWKAn9aKjftKSTEDDnGs2kui?=
 =?us-ascii?Q?4O59mGplkwxeUdMeOzolMxeUvtiYWy2KYGfTr44pcLnoZwbeldbRBOAe2Whz?=
 =?us-ascii?Q?UgN29KJbTC9z939+iWNs/XILejC/4Drg0CyF6d87NjCz3BQbaObyXrztGKWT?=
 =?us-ascii?Q?E+vS0NWyajowD0JRvWTLKNxjA/gLhVUZy2VeLGOkXCTmJVe17eoXk11WbOeq?=
 =?us-ascii?Q?93BIsZpTCrLjbuqM7gLNJYYFltQtI/KUugcRcYvpBRpOiGpc7mLwiua/J6ux?=
 =?us-ascii?Q?DLpH0g4K2dDjMAi5sHatkb6JRxG0XCh36168wLDJDNeRc1NASCrgQydf9APs?=
 =?us-ascii?Q?l7IawGTqAEMqoOu0RbT+X7D3w71I6Fo2HSvMlmzanzqgwC2fkWfgBhAlOJqz?=
 =?us-ascii?Q?di8vPUQAiiFeIaSqzwSx21FwSP9TmrIQBH7M6gdW59DJrB/CGXbubdQV7xUd?=
 =?us-ascii?Q?I1WZ0k+665Pj69X+aKEDVMjevihzsvc7zxFZDUnPDvucicfZohS2awsxtGIW?=
 =?us-ascii?Q?/wYGC1FPxJTlRWKIvPZCnXc2lRIVjIQ/oLwil3e6NbHN1PtX/uyhjnnarCWs?=
 =?us-ascii?Q?O04SpJ6EFD9bJeYbOFInOdLCMixSh2VNfz5ZLT0AYjYENNP1NfXVtTk/ox63?=
 =?us-ascii?Q?bHItmPfuIbuMz9iiueoRavmmDAOitUXT/dfuw/PgqCDR3wQQAkLV1vVvqv2v?=
 =?us-ascii?Q?w1Tj9emb9KtuqGXzj6dWTNhqTRGAGptLmzEyzwTS/7fM8N2jRjpdgiL3WuW3?=
 =?us-ascii?Q?NvM5D1Roy8cS3q927/hDCu0nGGTNLr6cZcoC8SCrzz4K9cvUAty2MzEjZ3+l?=
 =?us-ascii?Q?WXtf80IK4e3KAaxsByom194mzt7DqamXPs3ijeXOcaEVACnewmqt+jbFCXKb?=
 =?us-ascii?Q?jZghF+D7QL9yBKlgZQsADW2zl8svRzwuwuknMC5F8e41TLCl7UEhow+47ezR?=
 =?us-ascii?Q?Zw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6FBCA0D332A4F342B8BC076B5E2960D2@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?7Nf48HmiIHmUYCu3SIgwBatD45ezqB4hsixkInR+4K3RE8rPBBFpllVQaNw1?=
 =?us-ascii?Q?6pCwj4Cno1I98ejrFxeZgvXiTlGJFAGOh4W4wDv6Lc7rl75QB7KB6HwKNfDw?=
 =?us-ascii?Q?HGTz7/X0/btx99asDPZskhMVa7dWkeyTAbYXVa79XJ5GHulW48PRO9OY0Kta?=
 =?us-ascii?Q?3S6VRnG4KvoG6sCN4Vd0HPdphJeOM48vBukgkWjMM4BrIjpQAqF4welVUNDt?=
 =?us-ascii?Q?4nhUEENlmue4LM7CSTK72DXWcnkMj9tGCyWWAmvnt98Mb53PqCdUtxyQ9reP?=
 =?us-ascii?Q?uEhRCimuKasR7IZp9RlzlkTPLRERLUmtpormjy5m9Q74uoJOTJrsoITdXERa?=
 =?us-ascii?Q?5G4FsNHrygF/YZ4iTK/GjyGBVCL+qPCuCf2wLvT/wb3L/4R1wQ81aZciYDYo?=
 =?us-ascii?Q?0FemWJEt0WiHIVnhAB8I+5cjcRbLqD7/uIiE29JH+94EorBLjZL/nufusXxS?=
 =?us-ascii?Q?4yDv/kCzE6UyvkbQ8iaQ6lR56JDiGPIefhZvKF1WA9HuO30vZOu6R+4qOB8X?=
 =?us-ascii?Q?Yv4wgWXtNdSaokuGNTd6FraLIruFSvRvz0QouPSrpr+ZwteQf9VFWUyXowXs?=
 =?us-ascii?Q?+dLlgIy6JEUdzNbRP6qBb796X2amEkNioh4Atq70txHuDr5oZmN9HJOmqxgI?=
 =?us-ascii?Q?ZjQ7hifF9jid2MxxjOsKCxvnzowzYmgv9gCS/ij4d1wqNYPzK+LXTiBDmcyV?=
 =?us-ascii?Q?GS8/Q2UcWPfzr0wqMz5UsIy5Zekh3kWCc2zGpK99ItvKetD8CNvhSBwylula?=
 =?us-ascii?Q?Tg7faw7qpQyARXwfj+IYkm+WTLF2wf+Ug0qhHoQCu2Aw3aisqY+GjqWaTAqW?=
 =?us-ascii?Q?G3eqKC9pBbo7Gqb1hhtdgUXwWtsgM5yA1FwoQ0yqnqxQq5qhanv/Sai3Ba4B?=
 =?us-ascii?Q?PLJZhsy/SPeg9eVH+UKWCPytzXzMNqsNFLP9XNqDFc9tTNznAjeEFxkIqyUM?=
 =?us-ascii?Q?jdHVjOUd0TiI4uLbp0xzJ22JE7ie+OFj90Y1/cIhtnV8x2zISMnka7U1NCnK?=
 =?us-ascii?Q?2xBxaEnUb8C8ZhYr+BZhqP08kssdQfaS1uNuGeqwooQMuSg=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5433.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ebe6fc9-db3a-4431-5406-08db9906615b
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Aug 2023 18:28:08.5000
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: G03hrF/3p9zLbfebjZLIxFZMWb6XkvX08d8zgcbxIgtqlYgYlDPenmfZ5DR7dCWk0wRkd0wzeKc0ts0betTmYA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7743
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-08-09_16,2023-08-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 adultscore=0 mlxlogscore=999 bulkscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2308090162
X-Proofpoint-ORIG-GUID: Hw6GIvfKEV5o86rqejhaVNhIWKdiCO9l
X-Proofpoint-GUID: Hw6GIvfKEV5o86rqejhaVNhIWKdiCO9l
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

> On 8 Aug 2023, at 11:46, Marc Zyngier <maz@kernel.org> wrote:
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
> arch/arm64/kvm/emulate-nested.c     | 262 ++++++++++++++++++++++++++++
> arch/arm64/kvm/sys_regs.c           |   6 +
> arch/arm64/kvm/trace_arm.h          |  26 +++
> 5 files changed, 297 insertions(+)
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
> index b96662029fb1..1b1148770d45 100644
> --- a/arch/arm64/kvm/emulate-nested.c
> +++ b/arch/arm64/kvm/emulate-nested.c
> @@ -14,6 +14,268 @@
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
> +enum trap_group {
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
> + * Anything after this point is a combination of trap controls,
> + * which all must be evaluated to decide what to do.
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
> + __NR_TRAP_GROUP_IDS__
> +};
> +
> +static const struct trap_bits coarse_trap_bits[] =3D {
> +};
> +
> +#define MCB(id, ...) \
> + [id - __MULTIPLE_CONTROL_BITS__] =3D \
> + (const enum trap_group []){ \
> + __VA_ARGS__, __RESERVED__ \
> + }
> +
> +static const enum trap_group *coarse_control_combo[] =3D {
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
> + * [9:0] enum trap_group (10 bits)
> + * [13:10] enum fgt_group_id (4 bits)
> + * [19:14] bit number in the FGT register (6 bits)
> + * [20] trap polarity (1 bit)
> + * [62:21] Unused (42 bits)
> + * [63] RES0 - Must be zero, as lost on insertion in the xarray
> + */
> +#define TC_CGT_BITS 10
> +#define TC_FGT_BITS 4
> +
> +union trap_config {
> + u64 val;
> + struct {
> + unsigned long cgt:TC_CGT_BITS; /* Coarse trap id */
> + unsigned long fgt:TC_FGT_BITS; /* Fing Grained Trap id */
> + unsigned long bit:6; /* Bit number */
> + unsigned long pol:1; /* Polarity */
> + unsigned long unk:42; /* Unknown */
> + unsigned long mbz:1; /* Must Be Zero */
> + };
> +};
> +
> +struct encoding_to_trap_config {
> + const u32 encoding;
> + const u32 end;
> + const union trap_config tc;
> +};
> +
> +#define SR_RANGE_TRAP(sr_start, sr_end, trap_id) \
> + { \
> + .encoding =3D sr_start, \
> + .end =3D sr_end, \
> + .tc =3D { \
> + .cgt =3D trap_id, \
> + }, \
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
> +int __init populate_nv_trap_config(void)
> +{
> + int ret =3D 0;
> +
> + BUILD_BUG_ON(sizeof(union trap_config) !=3D sizeof(void *));
> + BUILD_BUG_ON(__NR_TRAP_GROUP_IDS__ > BIT(TC_CGT_BITS));
> +
> + for (int i =3D 0; i < ARRAY_SIZE(encoding_to_cgt); i++) {
> + const struct encoding_to_trap_config *cgt =3D &encoding_to_cgt[i];
> + void *prev;
> +
> + prev =3D xa_store_range(&sr_forward_xa, cgt->encoding, cgt->end,
> +      xa_mk_value(cgt->tc.val), GFP_KERNEL);
> +
> + if (prev) {
> + kvm_err("Duplicate CGT for (%d, %d, %d, %d, %d)\n",
> + sys_reg_Op0(cgt->encoding),
> + sys_reg_Op1(cgt->encoding),
> + sys_reg_CRn(cgt->encoding),
> + sys_reg_CRm(cgt->encoding),
> + sys_reg_Op2(cgt->encoding));
> + ret =3D -EINVAL;
> + }
> + }
> +
> + kvm_info("nv: %ld coarse grained trap handlers\n",
> + ARRAY_SIZE(encoding_to_cgt));
> +
> + for (int id =3D __MULTIPLE_CONTROL_BITS__;
> +     id < (__COMPLEX_CONDITIONS__ - 1);

This condition seems to be discarding the last MCB from being checked,
which IIUC it must also be checked.

Thanks,
Miguel

> +     id++) {
> + const enum trap_group *cgids;
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
> +static enum trap_behaviour __do_compute_trap_behaviour(struct kvm_vcpu *=
vcpu,
> +       const enum trap_group id,
> +       enum trap_behaviour b)
> +{
> + switch (id) {
> + const enum trap_group *cgids;
> +
> + case __RESERVED__ ... __MULTIPLE_CONTROL_BITS__ - 1:
> + if (likely(id !=3D __RESERVED__))
> + b |=3D get_behaviour(vcpu, &coarse_trap_bits[id]);
> + break;
> + case __MULTIPLE_CONTROL_BITS__ ... __COMPLEX_CONDITIONS__ - 1:
> + /* Yes, this is recursive. Don't do anything stupid. */
> + cgids =3D coarse_control_combo[id - __MULTIPLE_CONTROL_BITS__];
> + for (int i =3D 0; cgids[i] !=3D __RESERVED__; i++)
> + b |=3D __do_compute_trap_behaviour(vcpu, cgids[i], b);
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
> + return __do_compute_trap_behaviour(vcpu, tc.cgt, b);
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
> + * for this sysreg, and that it cannot be forwareded. In this
> + * situation, let's cut it short.
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
> index f5baaa508926..dfd72b3a625f 100644
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
> + populate_nv_trap_config();
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
> #endif /* _TRACE_ARM_ARM64_KVM_H */
>=20
> #undef TRACE_INCLUDE_PATH
> --=20
> 2.34.1
>=20
>=20

