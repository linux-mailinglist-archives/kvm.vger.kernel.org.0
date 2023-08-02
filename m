Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE10476C900
	for <lists+kvm@lfdr.de>; Wed,  2 Aug 2023 11:09:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232100AbjHBJJS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Aug 2023 05:09:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233992AbjHBJJJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Aug 2023 05:09:09 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1DB4272A
        for <kvm@vger.kernel.org>; Wed,  2 Aug 2023 02:09:04 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 371LKR0f002554;
        Wed, 2 Aug 2023 09:08:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=uVQuN90PEBbnyORvKwORGSECoY8ZU6JZYZkUt5jOIe0=;
 b=Qqx/Dzu4CTGcOIK69dKbbcFpieu2r+b9lOLpfaBaXA34GYY5ooPTvtq5SE0+qBz14iyx
 gXzxZZWdnTBX/BrI85oEH3iQXHsSR68nqis4nAcD4s7BMyUUM6864Xs6b7lX6luh8uII
 hpN3t441gYqjFbVqGdNM6NooyNEz3t08SC/AQVZRF2o9kF/8Zlo1BZl9/FefprCncrth
 oNM184wT0ByK8IFv7Fv02VVxFPH6nCrVMeGl/ethkIAG/TofA/t/JeKNT8Fad9NjOeJb
 58KM00Y/QLI2NBjRcuPhQBJsPziw5hZG3TtQoXDLtYswUTqt43Kk2Mks9hZ5czhX96SZ sA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s79vbrtq5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Aug 2023 09:08:30 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3727lcwH020517;
        Wed, 2 Aug 2023 09:08:29 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2102.outbound.protection.outlook.com [104.47.55.102])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3s4s77wept-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Aug 2023 09:08:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UTydF+8mdYuetHPcpan1Rp5/zJNExnPhYX8EVE85AE6dHqXEQxgAyy1UAJXDgkBaAkBvdhr68aqVrqde5n82vr09rDM7H84qlxbkMH23eecml9UEoxlSfrzpTyDkMno/Efkzws7VwqxtBxz155KnGUcWlgm3JGM1COx0lhMtljawJeG0dd5JwFAr8kV0wL4RA5ig8gM7J6BzrHWPCMpfPxsc5fCFJzEc/7UGU9e4dBG62fLtMUQMwCaK8kRcvbnPLhoC9jdvzx9FKQEXGQluIp3j9/IKH5XmgRiLXTyifpQGxT3Bt4TnWSKG2nY4glSg3iLoxqtqYqDPUlrdszHurg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uVQuN90PEBbnyORvKwORGSECoY8ZU6JZYZkUt5jOIe0=;
 b=OrrXr4J9jd21cgpK5C1djlReoSur8/YNWYlPhNFbxR4BnfuqJlCydrVfYPQLDJJCkraa/29AMsZMcNhHV1XhvWyRE/DJ6Q7ARRJZygif2Uo4+vBcnXIXluYASvrQzFu+qQgK+BDF1Htf0aCqTt7XufiRTzKpAHMZdWFr6aiSTr5KztYkP1jM2jcQ0KXsJ0vBIsglxojMDQaJuvLB44j2/WIFojT3hADUlPi4T8/UFnF13Lw2vXseB0MLmq7PY7JmSlH0l/1M9e2Y4rQavKVV+a95m0ELCMZj8vojXBYqp6v6j5JZHqZecDcSUapHYWqxQd9ARF6fEBsUsM/HkMAmHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uVQuN90PEBbnyORvKwORGSECoY8ZU6JZYZkUt5jOIe0=;
 b=IeyLZrdT5rKTa01fH4J1UmoNBecVUqJC5dBAchkTYtfTz0D+3eszY0jl3qrQ1QtTIyL+LLvAiW4ph9oWFgWAcTuk0kDXrHdMkf3AS5oATE3qmT96KF7BMF1XjgwGvjb+Cl4oJecOpntRkU98wLV5vHsWAcE2LkWnd+NVwBKOfEs=
Received: from PH0PR10MB5433.namprd10.prod.outlook.com (2603:10b6:510:e0::9)
 by IA1PR10MB6265.namprd10.prod.outlook.com (2603:10b6:208:3a3::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.45; Wed, 2 Aug
 2023 09:08:26 +0000
Received: from PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::76c:cb31:2005:d10c]) by PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::76c:cb31:2005:d10c%4]) with mapi id 15.20.6631.045; Wed, 2 Aug 2023
 09:08:26 +0000
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
Subject: Re: [PATCH v2 08/26] arm64: Add HDFGRTR_EL2 and HDFGWTR_EL2 layouts
Thread-Topic: [PATCH v2 08/26] arm64: Add HDFGRTR_EL2 and HDFGWTR_EL2 layouts
Thread-Index: AQHZwS24sbWBJoZgeUWNQT4VGw+jIq/Wv2MA
Date:   Wed, 2 Aug 2023 09:08:26 +0000
Message-ID: <BBCEC5DE-4368-4546-8553-A7B8F23DA43D@oracle.com>
References: <20230728082952.959212-1-maz@kernel.org>
 <20230728082952.959212-9-maz@kernel.org>
In-Reply-To: <20230728082952.959212-9-maz@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR10MB5433:EE_|IA1PR10MB6265:EE_
x-ms-office365-filtering-correlation-id: 54d0ead7-013b-4f68-bde2-08db93380826
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RZC9lMhfKEB2wgoxr05yzokYhbytZCOoHzqF7whwGdDn0s73w1WLqF8Cq/0drb2AOART6YPsVARL5paczIS4/2w57XF3K6MyOKja069FoPXnYhkVu9EC8tqXSZ7QETV5zm2EqCUo7rxsYTnnYBYGbmt0ANapkQ3l9FroKavJrdGhPRu869FuiMo/LUcwK/jlOMuOOtN+KjNnuXNETjJrRtOhREAngts39ZymyLYp5qxaxK5uf8ux+rHA9YWf12sNaFTrfrkN3qHNgJ29tMV6n1lkWtQlFXr0PSbHxhHsDglQH5fJzx/EdM1+cnMlHjQtC7vD9/0ESKt4eFfXiMaLV6Dnm0m6qTWEwI9BTL5TN3ixhZ5oELUZ3iRBA9rGkS5ZpEGh/ikQVM+oK9bu4U3rN9YvI71afo7qTisSDGibhPqWeXV6H8E3Mtt9m7mW9jIjCDF4FW7i9TEG9pnQ1c+ZMXzsjXQjxJGAA/M/Unoqeva4QD53cwd455qH3h9fPxdSjLeQH4Wj5Apgrf1czfVfhj43xqMvbvZpri/gOEvWs8jvL0nh+7q2JmDum3zFw18RPop7fuxxKuO+mENiuAlCn6FfpSwdlVTgE7KZQeIRYECm/GjvX6qCycbLtqqPwIWEORISrYVmpqbQbDCgQ1C2Rw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5433.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(346002)(376002)(39860400002)(136003)(366004)(451199021)(54906003)(71200400001)(8676002)(8936002)(6486002)(478600001)(76116006)(91956017)(64756008)(6916009)(66476007)(66446008)(316002)(66946007)(66556008)(4326008)(83380400001)(6512007)(38100700002)(122000001)(41300700001)(186003)(36756003)(7416002)(44832011)(6506007)(53546011)(5660300002)(86362001)(2906002)(38070700005)(2616005)(33656002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?9RY3wbXrduP8xZkNNXj6RClPhzmyRro9FTTHYQ7hpnXZR16YB2+dTnVCkcUV?=
 =?us-ascii?Q?GuPk8j8EkIbKzdDzgRxKTHvv99PxnqhHbQOt2u6C2X/27TvsTtH3rzwhcEiG?=
 =?us-ascii?Q?GQVhoBOAJ9xPnZpLAwwyp5VxtUa4m75VwPdis9VEgpTZM9prDfO8ggYFbNtG?=
 =?us-ascii?Q?XVp3qyRd1xoyuAG8Hkz0S/qqHvusQvnanjBe6lRXdv8KErnkav3P7gCmYnSI?=
 =?us-ascii?Q?iOPXpU9F85iB3Eu9ftPsY/m9iZGKiVwsxAZ/bxQMB7hC9UwFDOnh1rt+tOZA?=
 =?us-ascii?Q?NHEKgyqGQzjiTYBQKOJPkdKqykXyWSGU8k8HgCgoiiLTMooyKFZYECmw6zxB?=
 =?us-ascii?Q?TNcet/PtpSrM0Wauun58gXCvinqb9Lt0pO8OWTe8aPca3Af/LBEekouYWe7G?=
 =?us-ascii?Q?3iyM94VQFTQvGGE+S/spawoybleB0y/U65JBKjQ583VVnpRHPtK+AktsBLKT?=
 =?us-ascii?Q?vO1/gwmctjZ1EKaUKWgX8hkdlImUzm81vDblnDKW0gzyp7I20rvEc1FnUHhH?=
 =?us-ascii?Q?H27YLkwsu/PEHvOn6g1J92uzAHRKFxilBZq99jScx/38/B7ZZEeISvAC6V/q?=
 =?us-ascii?Q?PEXPoVBLWr5AtmyhDuDJCGk2JXRQ4X8ry59ZCnBgEDWJgBXcC4H3n+FaZoxI?=
 =?us-ascii?Q?4ap1BXDEanTnoAYazL0DpC2YdYC5zvXATfkEWcmnmA3KMo4Ulxa+OsQethtV?=
 =?us-ascii?Q?RYuI8ABVQuKwBBebSxmbb8QIMuVKjcX2fGSjMEqxzKqquFRW0Jms/hKJgqWU?=
 =?us-ascii?Q?QsxQh3DPpxc4paaeBJscts5JisDUoKD+qF1J8AA4GAwGf2ax+/p6eZca40pg?=
 =?us-ascii?Q?bDdJUgubss0lmdeeSGLE7+u6PBIVkLc0kmwMgURhlvpSae/CgfwIfbvcfC13?=
 =?us-ascii?Q?d/5cvmc/26quENID5SQrHXTrxIM7h05g94SSM0iK9FKtuEFj79pPLg+5QlDc?=
 =?us-ascii?Q?0j+3wTRDlQWannIIyMANtu3thPn47JC2sYtLQHnre/DMG/4iidIw9XRXa/r8?=
 =?us-ascii?Q?z+nmbSBeuHBELHDspCUCAotJUWYqkmptctHShX0gDh5Pjl7DmfgFuHJtlt6u?=
 =?us-ascii?Q?2oLcvzpi0OB/RJD5xX/YiXmD71zMqySB90JFF4HWq5suQIsnnu1L0LVu3Qrb?=
 =?us-ascii?Q?BKy+fmN43sHAh1x6ef9HhT2eGpu76bbWv9U1kefqF5Ehr54MabIyeHGdIf9b?=
 =?us-ascii?Q?oJ0puuZAxPQ7DUGBLKEA3cWqeymOw7zu7FGJyqT03RZLYq5B/iP4DE22RwMu?=
 =?us-ascii?Q?WT5HP0fluTjvjMOgW6VXT6XkaMm+O2dk8+G/KqxoF9Ocds2T98r6QnmjREO8?=
 =?us-ascii?Q?zkb1ucar8EtsKlp3t/WZQphxG65owbNiH5b+V5rQPfxR8mFwuSZKdCuGSnXu?=
 =?us-ascii?Q?+m7cQ6yMz9ERAf1khxqWs6ERiE2fhc5V+0tGKTdNyyFTrxeO3EFe6VnuOnJv?=
 =?us-ascii?Q?HEC+48Sh0++IhE5YKudS5j8TXCNQM6XBwTN5fGItf6pQLleR41pCB5yAvXbs?=
 =?us-ascii?Q?pQ55aTjUmIN6ctfb3/QSO9gJvSpWNVSYK9bgode9CsaMaG0lvPN2AZQ1oZ4g?=
 =?us-ascii?Q?fxy5sQrgu9cXFqJzlhM9JusQD1f0iLb4GLG1jKwavY0n3SGoZU+OUilN3vsr?=
 =?us-ascii?Q?wdP9OhunlBv1e51xVdjQqvw=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <FEF42701F1CB2F45A2ADC68DFF38C608@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?qqL84YiivxZuuNiieh0wfyy/Xp1V+aGIbdlG7d42izbP30PwIdmN/bvT1l+7?=
 =?us-ascii?Q?CQIOP8mhJlsyY9x1nXn6WqhUn1/C0wD2lGEWin0xZiU99U+Dv/o0ZNv5livv?=
 =?us-ascii?Q?Qw9tB0UuDvjkQ9BRUAm8dZ3qhj/rzxxWFz6vb5HMZ7wG2N6lUBOg/dE6LCIQ?=
 =?us-ascii?Q?TcNK0NiAtMxLmNoR59mS81rtaJIY4/vrn6vdLenY/wnkqDxHCRLIv3+un2eZ?=
 =?us-ascii?Q?3n4nGlBUDx1c2e1Suz1hS7BXlD/EpQyLhjX9iNDeaXKiYMynPIReb/MnE40/?=
 =?us-ascii?Q?3KSlccz79HN9QjIicUN1cSMyyqtpsj8SftosSiA2T1etPYy60I4/2fph0lfd?=
 =?us-ascii?Q?mEZd80i5Q/UIICoNtD/5CUQugeFZIpz3k29SlPtIN0txnB+6c5NAVr54hdzT?=
 =?us-ascii?Q?p7R9Q/kPFLqvEQ7rdltrmBlkmv/7R3fyWchwSKO0RU9GZOQaXS09K2liV3hL?=
 =?us-ascii?Q?qpmcsfwHxN0RNkLN5RsJds95dLWHhVQPAaYKebTEU4THAH8w7Uayj7u0VfNn?=
 =?us-ascii?Q?wUkhBqPb4j42mF8pI7RXKiIJSOwcjpFGvwNnLPabW7+ruXJgTKweIo3Y2jEL?=
 =?us-ascii?Q?yfJge9USz4vJi4vh41eOoBSUZux/71Zrf95MAm96mD3CitA9Pf9ZhnNsQo/7?=
 =?us-ascii?Q?MZ1HbaiBM8mYVuP2+M2UnOeYIhLXPIBe8rovAKgmk7US1cYBVorLUV9hTjwi?=
 =?us-ascii?Q?S9tmuMaBfrqcIGVjZupV/OtjDDV6WeHKNoZjuoiqC3Zd2FhHwj2RMakHl7Bp?=
 =?us-ascii?Q?SxNO2LlsAkJibJCB5grNGh9xRZNMU5p80rGElvNEFlxyp2hFeIRcBAe4Ky3O?=
 =?us-ascii?Q?lKi565BvQvQ7yvH+pcSC1CZF191n9pzTF+d2tmQMRiFadfuqk9AL0hbStcxC?=
 =?us-ascii?Q?TMcNwo4jFPwUjI2KyEDZViZUAHGERwfnJ5gSTOIW88LkeqdpRkGNWv5vwKHV?=
 =?us-ascii?Q?GM11czOfzr5BTu9VDaqaQxJGWMTLYu9jdhoi0yvifmXlSE4n+e8DbcJpk7eR?=
 =?us-ascii?Q?6UniyLFudu8EFW+Welfy3WRGbDfFpufvK/NdnmrBUFaIE08=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5433.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54d0ead7-013b-4f68-bde2-08db93380826
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Aug 2023 09:08:26.6739
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: n2SL+MrI/LAWPitmzYOM+V1yekjypqpev3VbFhUUkBgF6rHUbqJ+NwWZhyaqsXtZ3wcfYXXEikcLgFA6WZc+3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6265
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-08-02_03,2023-08-01_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 adultscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2308020081
X-Proofpoint-GUID: n1vLYxcPQnOrGWH-J6N8njZ6T9u0GAPQ
X-Proofpoint-ORIG-GUID: n1vLYxcPQnOrGWH-J6N8njZ6T9u0GAPQ
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
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
> As we're about to implement full support for FEAT_FGT, add the
> full HDFGRTR_EL2 and HDFGWTR_EL2 layouts.
>=20
> Reviewed-by: Mark Brown <broonie@kernel.org>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
> arch/arm64/include/asm/sysreg.h |   2 -
> arch/arm64/tools/sysreg         | 129 ++++++++++++++++++++++++++++++++
> 2 files changed, 129 insertions(+), 2 deletions(-)
>=20
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sys=
reg.h
> index e2357529c633..6d3d16fac227 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -497,8 +497,6 @@
> #define SYS_VTCR_EL2 sys_reg(3, 4, 2, 1, 2)
>=20
> #define SYS_TRFCR_EL2 sys_reg(3, 4, 1, 2, 1)
> -#define SYS_HDFGRTR_EL2 sys_reg(3, 4, 3, 1, 4)
> -#define SYS_HDFGWTR_EL2 sys_reg(3, 4, 3, 1, 5)
> #define SYS_HAFGRTR_EL2 sys_reg(3, 4, 3, 1, 6)
> #define SYS_SPSR_EL2 sys_reg(3, 4, 4, 0, 0)
> #define SYS_ELR_EL2 sys_reg(3, 4, 4, 0, 1)
> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
> index 65866bf819c3..2517ef7c21cf 100644
> --- a/arch/arm64/tools/sysreg
> +++ b/arch/arm64/tools/sysreg
> @@ -2156,6 +2156,135 @@ Field 1 ICIALLU
> Field 0 ICIALLUIS
> EndSysreg
>=20
> +Sysreg HDFGRTR_EL2 3 4 3 1 4
> +Field 63 PMBIDR_EL1
> +Field 62 nPMSNEVFR_EL1
> +Field 61 nBRBDATA
> +Field 60 nBRBCTL
> +Field 59 nBRBIDR
> +Field 58 PMCEIDn_EL0
> +Field 57 PMUSERENR_EL0
> +Field 56 TRBTRG_EL1
> +Field 55 TRBSR_EL1
> +Field 54 TRBPTR_EL1
> +Field 53 TRBMAR_EL1
> +Field 52 TRBLIMITR_EL1
> +Field 51 TRBIDR_EL1
> +Field 50 TRBBASER_EL1
> +Res0 49
> +Field 48 TRCVICTLR
> +Field 47 TRCSTATR
> +Field 46 TRCSSCSRn
> +Field 45 TRCSEQSTR
> +Field 44 TRCPRGCTLR
> +Field 43 TRCOSLSR
> +Res0 42
> +Field 41 TRCIMSPECn
> +Field 40 TRCID
> +Res0 39:38
> +Field 37 TRCCNTVRn
> +Field 36 TRCCLAIM
> +Field 35 TRCAUXCTLR
> +Field 34 TRCAUTHSTATUS
> +Field 33 TRC
> +Field 32 PMSLATFR_EL1
> +Field 31 PMSIRR_EL1
> +Field 30 PMSIDR_EL1
> +Field 29 PMSICR_EL1
> +Field 28 PMSFCR_EL1
> +Field 27 PMSEVFR_EL1
> +Field 26 PMSCR_EL1
> +Field 25 PMBSR_EL1
> +Field 24 PMBPTR_EL1
> +Field 23 PMBLIMITR_EL1
> +Field 22 PMMIR_EL1
> +Res0 21:20
> +Field 19 PMSELR_EL0
> +Field 18 PMOVS
> +Field 17 PMINTEN
> +Field 16 PMCNTEN
> +Field 15 PMCCNTR_EL0
> +Field 14 PMCCFILTR_EL0
> +Field 13 PMEVTYPERn_EL0
> +Field 12 PMEVCNTRn_EL0
> +Field 11 OSDLR_EL1
> +Field 10 OSECCR_EL1
> +Field 9 OSLSR_EL1
> +Res0 8
> +Field 7 DBGPRCR_EL1
> +Field 6 DBGAUTHSTATUS_EL1
> +Field 5 DBGCLAIM
> +Field 4 MDSCR_EL1
> +Field 3 DBGWVRn_EL1
> +Field 2 DBGWCRn_EL1
> +Field 1 DBGBVRn_EL1
> +Field 0 DBGBCRn_EL1
> +EndSysreg
> +
> +Sysreg HDFGWTR_EL2 3 4 3 1 5
> +Res0 63
> +Field 62 nPMSNEVFR_EL1
> +Field 61 nBRBDATA
> +Field 60 nBRBCTL
> +Res0 59:58
> +Field 57 PMUSERENR_EL0
> +Field 56 TRBTRG_EL1
> +Field 55 TRBSR_EL1
> +Field 54 TRBPTR_EL1
> +Field 53 TRBMAR_EL1
> +Field 52 TRBLIMITR_EL1
> +Res0 51
> +Field 50 TRBBASER_EL1
> +Field 49 TRFCR_EL1
> +Field 48 TRCVICTLR
> +Res0 47
> +Field 46 TRCSSCSRn
> +Field 45 TRCSEQSTR
> +Field 44 TRCPRGCTLR
> +Res0 43
> +Field 42 TRCOSLAR
> +Field 41 TRCIMSPECn
> +Res0 40:38
> +Field 37 TRCCNTVRn
> +Field 36 TRCCLAIM
> +Field 35 TRCAUXCTLR
> +Res0 34
> +Field 33 TRC
> +Field 32 PMSLATFR_EL1
> +Field 31 PMSIRR_EL1
> +Res0 30
> +Field 29 PMSICR_EL1
> +Field 28 PMSFCR_EL1
> +Field 27 PMSEVFR_EL1
> +Field 26 PMSCR_EL1
> +Field 25 PMBSR_EL1
> +Field 24 PMBPTR_EL1
> +Field 23 PMBLIMITR_EL1
> +Res0 22
> +Field 21 PMCR_EL0
> +Field 20 PMSWINC_EL0
> +Field 19 PMSELR_EL0
> +Field 18 PMOVS
> +Field 17 PMINTEN
> +Field 16 PMCNTEN
> +Field 15 PMCCNTR_EL0
> +Field 14 PMCCFILTR_EL0
> +Field 13 PMEVTYPERn_EL0
> +Field 12 PMEVCNTRn_EL0
> +Field 11 OSDLR_EL1
> +Field 10 OSECCR_EL1
> +Res0 9
> +Field 8 OSLAR_EL1
> +Field 7 DBGPRCR_EL1
> +Res0 6
> +Field 5 DBGCLAIM
> +Field 4 MDSCR_EL1
> +Field 3 DBGWVRn_EL1
> +Field 2 DBGWCRn_EL1
> +Field 1 DBGBVRn_EL1
> +Field 0 DBGBCRn_EL1
> +EndSysreg
> +

Reviewed-by: Miguel Luis <miguel.luis@oracle.com>

Thanks

Miguel

> Sysreg ZCR_EL2 3 4 1 2 0
> Fields ZCR_ELx
> EndSysreg
> --=20
> 2.34.1
>=20

