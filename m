Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC7CB77CF85
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 17:49:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238246AbjHOPsd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 11:48:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234339AbjHOPsA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 11:48:00 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2741198A
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 08:47:36 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37FBInC3031592;
        Tue, 15 Aug 2023 15:46:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=Z1txaAX7PF1akZGNVdYd2SRD9BVkjrZXjvTGnm/bWBM=;
 b=PnhuzyxJdGBFCay7fqmF27BIotZP/OO25wXXgICTFY7Wqf9H5OR9/OLpMajff1t4mU2M
 ImWbmtlIf/+FBWMJ/PVfv5j6TiK36dQNsRfjjaj7uSEcf+77s2aZyMTPF05lVCdeKcPw
 gkO1JrwUOB58h571N3V/F0hBLY7U6Fl3AV2cPty1OdV+ercbIpd037kmEeuNBZXl8/YN
 BdXmE/oyhtGrufp3Qg3qTO62/nAhIxgOomY/7ncdkPB2R1tHdzo/pG/JiLN7uZDnHZVx
 7QETAbw0fAkewQdE0mHFmAI4P/Xx1KFU6QTmH8YBwq0XywCO0j5d7TFMqXxR0T9OwcHW eg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3se31451ma-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Aug 2023 15:46:26 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 37FFiHFl003799;
        Tue, 15 Aug 2023 15:46:25 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2043.outbound.protection.outlook.com [104.47.66.43])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3sexyj0fdq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Aug 2023 15:46:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D2SfKw5TudoK8sAsqWhGJKf3wOX2koFxTZJF6hRuw22Vn0EMkjjy0THGu3Hy0rcty19z4ln9j7PHvX6syAKdjJywOxL7uGGUPyovk5hkRhhFLbWYdB+BBa3pNmJZZsMLMrrXjbrzwbYvLbLG51LQ0OIyCcCVuEY64r4sZRz8sWq6sNTRbfbehXGvYoYkH7ZmNtAZInRzQGVf7E6SGFWFm9gNALE7pLILee/sIYWsL5KtYykxxzFemziPEzM2Mb3pE/NM/euItEJ9mgxnRVeb4NFUYcdUWEFAi5doEMk4X5qS/TxTUDzkXRljM6PTc8vo2EQl5jopY8dgxObSleZK3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z1txaAX7PF1akZGNVdYd2SRD9BVkjrZXjvTGnm/bWBM=;
 b=DkRDKzpiiKOigBJvgJ/UDlSidUx7jzt9xGoldfwfAeADSLOsRNkZeiJdCZWTtfgq3vv65zVBZvWvn6kqv8a3GneVqkzamn5kxydnSJ4Xj9AkncmZ2AX3OPB37X1e3Uhbdb1kwRUDp5YJdWVBxsVhitEQ9u4Q/wnKEIy+zqSWUZ1G8pPJy87rceNJ9uTtEqpdwhA+BTj5STyf/elTu4O/DWU/NFdu5Q+KersjbRb3YyCJFuBcHkPPX9ojWMAgIwgrP5TQKMZNOSQr3tyAiMgkDpPaAbJDS2iRmHIKOqec8E7ltlw3Z2kcAChvdQjOVjS8mj8qLXWlvZeyRrvyugPl8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z1txaAX7PF1akZGNVdYd2SRD9BVkjrZXjvTGnm/bWBM=;
 b=kOx27JyHjazu8qq9hJ+kUM/V5avsDPuEVgOF3hO4c2pGC5PhTiFoBX/gjf9OcKoAu+58SK0tkqpF1fhnWIFV6gsMGf4lmhwPdlT6bnFF585LLN/BblZ71eU1Gi4r3wFOHZGu3P0GmsElQfJiSnAE6K808elFUliTgKJX6r/Vzgc=
Received: from PH0PR10MB5433.namprd10.prod.outlook.com (2603:10b6:510:e0::9)
 by DS0PR10MB6975.namprd10.prod.outlook.com (2603:10b6:8:146::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6678.26; Tue, 15 Aug
 2023 15:46:22 +0000
Received: from PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::76c:cb31:2005:d10c]) by PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::76c:cb31:2005:d10c%5]) with mapi id 15.20.6678.025; Tue, 15 Aug 2023
 15:46:21 +0000
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
Subject: Re: [PATCH v3 15/27] KVM: arm64: nv: Add trap forwarding for HCR_EL2
Thread-Topic: [PATCH v3 15/27] KVM: arm64: nv: Add trap forwarding for HCR_EL2
Thread-Index: AQHZye43LjWt3BICTk+WXyaA4d4s1a/ri1wA
Date:   Tue, 15 Aug 2023 15:46:21 +0000
Message-ID: <0A8ED162-EF6C-44F4-836B-7421183EA9A0@oracle.com>
References: <20230808114711.2013842-1-maz@kernel.org>
 <20230808114711.2013842-16-maz@kernel.org>
In-Reply-To: <20230808114711.2013842-16-maz@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR10MB5433:EE_|DS0PR10MB6975:EE_
x-ms-office365-filtering-correlation-id: ddfbc74b-e954-421c-7d71-08db9da6c613
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DhDB4kto8mMQJMvcOfJEFaFpCdKq0ymD5eU9P45YbkwuV/VBLZOoint9Z4vPrwKJBprBhXC2wo9UKYZqC/ZrfaYXamRieKNAC5U3cGXDIEvpmaLEoKIYPyeTfCJSB12eBg5EYGNAU/3Q8fMmuHFLXeBND71c6onPNiDrHvrgBn9WeDzqqvgBNax5CPmBNFJGBJox2Auk58Zu17HVoIQnceW+HNDIxJ7GsHWuD+sJIbsDsdMHcO84xslaEdK5xBr4co5VmbbnTswyxg8lFTLXjYLqWMmh3kULr5nHV2RoNX/aGk9iOJpro4yg4tovNuNXp21Bw3lM+MeP1ZNLI9X+rli47k38Lhl/KyLvKX5RMUmgjczdukiOntkgR66TZrLb9WC762D8nJoE0cR6LkGpqh3+CvRNp9DpaW2BQvLiJhZTSqoSERB+eKrneXayvrLNRxOfMeQLvmt2l/Yjj/AiFlW7LYvXNOnXBfleQr6m7mJZT5Lvdl4tEf9tWzQqeN1a2ARi8FLR1ECYGUQYutKcAO7GcRxYqapGXixYRiqbV6Bgvh+sca0Bf26TyPDPffI9/hYb8iOzdQTcYPRny9K1Bu7GhRVBDUkiocjxMfTtIy4v8dF1DydE8k8P66LpW5bl0rtl7E6qoYDxIK8wCpy6EA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5433.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(136003)(366004)(396003)(376002)(346002)(451199024)(1800799009)(186009)(38070700005)(64756008)(5660300002)(4326008)(30864003)(26005)(7416002)(66446008)(66556008)(54906003)(41300700001)(6916009)(478600001)(8936002)(66946007)(8676002)(91956017)(86362001)(122000001)(2906002)(33656002)(2616005)(6486002)(71200400001)(53546011)(6512007)(36756003)(6506007)(44832011)(76116006)(66476007)(38100700002)(316002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?slK6taZ7AyL4zomjpw//EtXQfLyFhunuAUQRM2uCLb68OGcoLTIwasu3qlI+?=
 =?us-ascii?Q?l9LIeLeshZ9ULJFb3X1LZeNVybq4UOG1o/xGciXaYTSLo7Tkc5v+2Zkc/5eq?=
 =?us-ascii?Q?YzRVESiQ/UqJur1NWJJ07XHLGtRlBybw/3FHdew40yzI4aTqXHSHi8nEI1gb?=
 =?us-ascii?Q?C1Oz+sPXFxce7cYRvbv+7EvJFPR8iQdcdH3IWzxpRFXaZzXbJoe7drLs7ct8?=
 =?us-ascii?Q?+5OxDeeHbD2Y2lyjsuaqqOrJ53Kf5HihMKC0gLkpiq2bHH8ntWoKVxZ1fbwE?=
 =?us-ascii?Q?DBbuS5splYreLynCilvxw5sQbL6JJ+QTpjf/b1KrTb733fU9ATqkUQY/fl4c?=
 =?us-ascii?Q?mLsvG9rfrZGezINg5UfmOMxS6ks8A1jPBnN5PN/oL8uqL7TilXqUJkKhdUEm?=
 =?us-ascii?Q?8sHEEGD7n6fgpXf/ehGIS2YNRXmgvHVB+xAYlpW/tFs9SRw0/lwGKZ6Deg2b?=
 =?us-ascii?Q?WZLcOvRxoVfe858qwI9dqNRvekZzeN4zT46ObpU6LxiufrT71d51oGkRLmNs?=
 =?us-ascii?Q?TxJyB3oj+/EqHaagwXbuTH/JTWlwPdrMbZr2pQXQc5h1Oz9RNZqO+dBSpOrv?=
 =?us-ascii?Q?wMF+iyHawT0FnW0HyGduxrqBzpd6HNZRNyJTivHHR7wD0389kLFo4A298yyO?=
 =?us-ascii?Q?6I5GFulcGTa2sL1Ah59USTYf8WTsvbOnVY3bOe6NKLAVRmdfBpo1jmF46OIw?=
 =?us-ascii?Q?4T3/hcrrgU2Fi6G3HLWmoXoKdWJvVyfjr+pDfFyezTzSDoqQVmZYipj/qXD9?=
 =?us-ascii?Q?TzqKqZSj2WVQF40frM8uAd6gTc+luAiKz26bF8IpyzghCSEC5ZTLulzMxSiS?=
 =?us-ascii?Q?HjWxvOQK6d+L19TPq7+PaAivIwUdhteh0mHBYUiN5QYG8AGsFLVREkJdVgAM?=
 =?us-ascii?Q?hEstx6O6AFcCfXYgYcIROobtAg/VTdYIcWNtU/mAbMU6u7dtTb6Bddoq8Agm?=
 =?us-ascii?Q?CgHixVGIx4AejtsbR3bKxbq7Putx3jO8PaQXcUL1Y4PEgZg4Vp/p6yVx4WIk?=
 =?us-ascii?Q?vuY0Ckt0i+TpDay6xpRH3nf5GYxKzZd5vox1TP1BfcH89IGwj1a3kfsA75hq?=
 =?us-ascii?Q?ONGGvDtDRVr1H3g2Gs+/3f5O46iqAgMKGBSDZF/U9F5d/r4t/usuqybWkcpJ?=
 =?us-ascii?Q?FMpB6EuqcF7EPawBnDOzxlmi9GVt7Uuy0YpiKQQapqxDgcZc9S8VBMN+m3De?=
 =?us-ascii?Q?e5xdy9lSx7u0YZe88+u3iicwD2MSbIDwuc8jkngDWb6tQePltHnLweRutk4L?=
 =?us-ascii?Q?nyEJt/Sd7Aesr9zhB1+3shRjf/T795aKDrQ7gWPuRAtZG1WM9SDujW5frNYM?=
 =?us-ascii?Q?SG4CEnneK4Lgap93HdjAmCC2QoG2pyru/ifZf/EnPQcHaoGEXGYk86zBcjal?=
 =?us-ascii?Q?hqXedjosBnJ8Mdwb9Ia1HaX/ueuyRKxdo7S4ZqokbqShz7sY0dpa5V3/cLGw?=
 =?us-ascii?Q?ucLggHY2VQZI3ZN/8a34eWposavzBNhv3d5jgCaF4qyFO6MjsyOKQH2M8TrM?=
 =?us-ascii?Q?FDu6tsf9x7E5AQt2f/I/43JrTu6yBmTV58EphGZdzraPYAJ0EpNWSl6rnWit?=
 =?us-ascii?Q?yWCi0DgjXYjxGA4gPAcBQkYpDrugiqvcJT6bJJS3oRo3P+td2kF55slxLTMk?=
 =?us-ascii?Q?HA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <ACEE7042121499458D6E8F784B529670@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?c5jEcfiYZ+dqylx/CD2V9bn+te5OyictWI4l+A2D7tpK1JoDuIhNeAJok4Us?=
 =?us-ascii?Q?irhe7n+2dfLWuiTEV4CWjPWYJ2jWuBidpr7djNVi2JD9qSNrvflIbOFcSwXp?=
 =?us-ascii?Q?RhVrsyw77tCWu/gWQl/Amj94ml6XlseepHxUeOckETwa7HV3mTFywzRs9YWU?=
 =?us-ascii?Q?zP3NODofYId0YQ5Dj700EDuxUsHwAPEx66b5PfXetvcgCdXcdM4cPMeEGcJZ?=
 =?us-ascii?Q?DORbtHE8oqtJhQd9zIv8h7Cqgb/0qxlfgBMZUW8Kxj2VmUkZ6Av2YJhLspqS?=
 =?us-ascii?Q?le3rl32R9Fh3t1g5UXnpdph8APg/brGdxB7wm38kyTMSGCQlcph9nb12ARjL?=
 =?us-ascii?Q?YRRJnozyCqIzh6b5tjUVMjYV22JgsUyAifNhdVuW2OgmcnC7ZXH5O7tU9en3?=
 =?us-ascii?Q?rMBqa92ddVi3PcEU8lrh/kkudGfzsKVRhBYaUNJ3aiPGApzpQDpQB52LzTLs?=
 =?us-ascii?Q?fyL/QGkCatsKEMo2bqnPpNyaFMUlS8EcHrcgxkaqgvJ59D4ZacbaiC3wp5m9?=
 =?us-ascii?Q?yttKP5weebJ3HWQW6hkNMtnXii+XIXYfNxe9jLDgq0fTwBNtLxVMbWh51F0v?=
 =?us-ascii?Q?xkU/kcVJqHr3JlI91qENfHNHF1cccMGs2v/K0SRE+y1sIsgLvJC/NZzpSswG?=
 =?us-ascii?Q?AdB6rKHBz6LhmCjq7wf2cU5OQyYPXr8dGpQIqzLN9an+l9sDTaBK9w8PyEJh?=
 =?us-ascii?Q?gSW409DHU3I8cYWBOvztSkUKqxOqpoXFWeCPeuCdRH+QLQ/QG1YaoPOBxKZs?=
 =?us-ascii?Q?7evlCDCB9wffVhZeQbXLotDdlz0JXJzE2azdxh5ibSTA3zYUd5qRZfhRq+AH?=
 =?us-ascii?Q?lzU3j2JUCb2hHeaLz3YS+bYLSI29TNeW0MPyXOb7KWUghuzEf1AlqhZJaMfi?=
 =?us-ascii?Q?XmGKEUI5NSP/EDOkUf4FUk7t8P42ZurYS9kfe0ABuvxO5j5jgDtVv2wXEzlC?=
 =?us-ascii?Q?do+FPQYN8NYIzujGTuDIevaTla+OnNqb+GxEPeWFAjJkMoTmUaoLbnwr6s27?=
 =?us-ascii?Q?Wmf77ecKV+Mf71pgVNxyOwYOkcouz5WFdQnHERyNc0Btj+U=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5433.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ddfbc74b-e954-421c-7d71-08db9da6c613
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Aug 2023 15:46:21.5833
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8MiBbA6XGeAhhB6QWR1SN6kj2Y9gRUoLsB08Kp6+kAw78EFjp9BfKerawm539JtfpFl7aVu6T8kDJk0Fvja7KA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6975
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-15_16,2023-08-15_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 bulkscore=0 phishscore=0 suspectscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2308150141
X-Proofpoint-GUID: BJxHndOpdssmG5odwmKE4lIha-cbSVb8
X-Proofpoint-ORIG-GUID: BJxHndOpdssmG5odwmKE4lIha-cbSVb8
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        UPPERCASE_75_100 autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

> On 8 Aug 2023, at 11:46, Marc Zyngier <maz@kernel.org> wrote:
>=20
> Describe the HCR_EL2 register, and associate it with all the sysregs
> it allows to trap.
>=20
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
> arch/arm64/kvm/emulate-nested.c | 486 ++++++++++++++++++++++++++++++++
> 1 file changed, 486 insertions(+)
>=20
> diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nes=
ted.c
> index 1b1148770d45..2122d16bdeeb 100644
> --- a/arch/arm64/kvm/emulate-nested.c
> +++ b/arch/arm64/kvm/emulate-nested.c
> @@ -37,12 +37,48 @@ enum trap_group {
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
> + CGT_HCR_FIEN,
> + CGT_HCR_TID4,
> + CGT_HCR_TICAB,
> + CGT_HCR_TOCU,
> + CGT_HCR_ENSCXT,
> + CGT_HCR_TTLBIS,
> + CGT_HCR_TTLBOS,
>=20
> /*
> * Anything after this point is a combination of trap controls,
> * which all must be evaluated to decide what to do.
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
> @@ -55,6 +91,174 @@ enum trap_group {
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
> + [CGT_HCR_FIEN] =3D {
> + .index =3D HCR_EL2,
> + .value =3D HCR_FIEN,

Should this value be 0 ?

Thanks,
Miguel

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
> @@ -64,6 +268,14 @@ static const struct trap_bits coarse_trap_bits[] =3D =
{
> }
>=20
> static const enum trap_group *coarse_control_combo[] =3D {
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
> @@ -125,6 +337,280 @@ struct encoding_to_trap_config {
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
> +      sys_reg(3, 4, 10, 15, 7), CGT_HCR_NV),
> + SR_RANGE_TRAP(sys_reg(3, 4, 12, 0, 0),
> +      sys_reg(3, 4, 14, 15, 7), CGT_HCR_NV),
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
> + SR_TRAP(SYS_ERXPFGF_EL1, CGT_HCR_FIEN),
> + SR_TRAP(SYS_ERXPFGCTL_EL1, CGT_HCR_FIEN),
> + SR_TRAP(SYS_ERXPFGCDN_EL1, CGT_HCR_FIEN),
> + SR_TRAP(SYS_SCXTNUM_EL0, CGT_HCR_ENSCXT),
> };
>=20
> static DEFINE_XARRAY(sr_forward_xa);
> --=20
> 2.34.1
>=20

