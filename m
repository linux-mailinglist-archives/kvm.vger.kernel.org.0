Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD6D7771DCE
	for <lists+kvm@lfdr.de>; Mon,  7 Aug 2023 12:15:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbjHGKPt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Aug 2023 06:15:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbjHGKPr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Aug 2023 06:15:47 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43D4410EA
        for <kvm@vger.kernel.org>; Mon,  7 Aug 2023 03:15:46 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 376NA0QH026780;
        Mon, 7 Aug 2023 10:15:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=yC6rLj84Npd7RQWP0u5s+dnIP33HhUtW39cEfm93L5k=;
 b=SIzRBK1SA6p1uscuXEoGJrvCUJUTB7yuXvrV8+wNlMT5X7KGfx0TFdvV5rQjoaFnDc+y
 IGSJqEtVtv0gY1QmhwlvS/o2cxojiOfZaIwMoRYe9jLbVDdxRQNT04guy6jzp/R8+bEd
 qcFRUJY9HZmSneSRvOfqqfr1l0UKoC0kmbxknG3zmxUfw3T1vk3IRAsLR0s1L3CC3VMD
 RFf3alTQIMlR3G8Uo2mILWyJLkIRePVI5z38vF8EfLnF/uvMNe01IC+RNtLAUuCJwQxD
 N+yK6+4tatI1Agg6lbRokZaadi79xgGj9+eqLDQdP4XOGV3H5gtNrYS/ewD4L/BDXIiH HA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s9d12adqv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Aug 2023 10:15:09 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 377A3h2R031197;
        Mon, 7 Aug 2023 10:15:08 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3s9cvab7q1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Aug 2023 10:15:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fsc1fnfX+g6i6YskY57Jtd0CptvU/33ESKVa77b3l4lpkh00KomQRMh01oH66+cWd6zlITC10R2X2OA/w06KP4NhMO1mgtlEAREuhriYD45wRysWlr0Da4lc/y2AAzTA5fdWAC51knNwNuV8H8foHC2/c06R/Er8KMCFj4PDlQEiM2RVUuUCu7k8tAGDSa/N6lx2cOq/u7ejUSewM8bMNFJ78i4Um+pog2y0mj2DtszLyHUVfguWWMCJxQROURBduPTHD66pqmqVqH8NhxIwKChBR9Qkwk68IG8nmOJgnHefAS/4Dvg0bwRSIsVKW3TGa/DljczkzJ0p0hVjA1R8jQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yC6rLj84Npd7RQWP0u5s+dnIP33HhUtW39cEfm93L5k=;
 b=VEwi2Dp7CJbDQq2Vel1CJ0winDaVM/e3Y8rDJuWcn07DOy8CxWqwRmMZHKZugFrHoFlxxpXbRpfBKWoKqry7qF6Z6RKhSEgDH23ouOL6s/aGk6cJtuDOGxKYrnayHPyIJxoXaiKkyvJ+Mp6Jtsc56Unh5VHNu38bonKTwputOohluFUVKcgvTfRlYaDZXD0Mcy0FT7hwHCYuBgZOkDq/1yfDadeB1UogeTsyz1RWrUltxYu7gubZe/6X7f9AZWRAEtvkzpQSy5psRQvFWNzsuTcmuj0hvd0wJAroXF22Tc8Jzj0ulV8u7RjU6UVwOe/ROOXimImMhpRwYR70nk1dug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yC6rLj84Npd7RQWP0u5s+dnIP33HhUtW39cEfm93L5k=;
 b=f1H+lPWxgZyWEIcXACAI8r5mlMqMkH1T7MBA67anPX+iSRtjfnsymIKBHamvgwUgjUxj05mfh4VZbsuaIo9wS1L9asmLpdfUcmQzBMv5KDtmofaSeXbNxrI/VemxFKGiQ0+CVUKXI5+MNiBuxsZP69CBWaUqQJFXS2o5xqe1HLo=
Received: from PH0PR10MB5433.namprd10.prod.outlook.com (2603:10b6:510:e0::9)
 by BLAPR10MB5219.namprd10.prod.outlook.com (2603:10b6:208:321::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.27; Mon, 7 Aug
 2023 10:15:05 +0000
Received: from PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::76c:cb31:2005:d10c]) by PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::76c:cb31:2005:d10c%5]) with mapi id 15.20.6652.026; Mon, 7 Aug 2023
 10:15:05 +0000
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
Subject: Re: [PATCH v2 13/26] KVM: arm64: Restructure FGT register switching
Thread-Topic: [PATCH v2 13/26] KVM: arm64: Restructure FGT register switching
Thread-Index: AQHZwTAl2LrSXDadl0aOaoTrk5jKEK/erZ6A
Date:   Mon, 7 Aug 2023 10:15:05 +0000
Message-ID: <02048256-C2AC-4B51-82D7-CA490232CBF3@oracle.com>
References: <20230728082952.959212-1-maz@kernel.org>
 <20230728082952.959212-14-maz@kernel.org>
In-Reply-To: <20230728082952.959212-14-maz@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR10MB5433:EE_|BLAPR10MB5219:EE_
x-ms-office365-filtering-correlation-id: 844d2615-12cf-48c6-b5c0-08db972f2bd0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rHBoGIxMHbyqp/A7HTftzYsTf8JOt+Xj2MhbHr4tjOJLXxHWPTjooPdnBKOtQoKR7Y3ou/qd9p91f6SDRYLcONhzLghPj/LFbDmzcwgyG6XmfnrsIK1f8rBXwf2WncpmI4w9LiRi9o201Nm/Y+2kmJ2L2sfdCdm7ppRqVKwhmZT06HV1uvivQ9bqn920DeqmhElJ3u9bPuOhlyE3QEIh8kjfj+ex3W0L1WAN6xf4tAQ8yVw3cCBp5V5Pu7W7Zt2y/YZhWJ2j5izyHUYy8GxIEHz1fjcdJy3uNnnA6R8VQDeMMVdGGi3qD7Os3T/ytOZgL9WnAV4NDhF8QNAGtGH1cPQk+FFgeNFxCNzt9avq4Os4+B9IAunWTXgRZvcMgvMxZVkDgln4McfV/7Y00pREaTfViijaoL4pUajwqbPs5aFI9908tFAffUxg6dCRwRMP40OQ0bl3g72W392I4TxVnJm7GSbGaEXvOcaqncdEytXV+Oq/m2Iq3gq9Y9wjZMF1UyofaM59QBq1LX6hHvMiN4ZvESYD7KjaRvc0WIsT82LZwxS/KKBpFEHi1x0NKu/6oUq11Xn3Cze/1TqpFGLqZEXbMYSEYJxi/qqqHBGIvLdXgB2sVEpSIpCkxDmJvpcN61y2tys5wk13gKStdSMMyw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5433.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(376002)(39860400002)(346002)(396003)(366004)(451199021)(1800799003)(186006)(71200400001)(2616005)(6486002)(6512007)(86362001)(478600001)(33656002)(122000001)(26005)(36756003)(6506007)(53546011)(41300700001)(316002)(5660300002)(7416002)(44832011)(8676002)(8936002)(38070700005)(54906003)(19627235002)(4326008)(38100700002)(6916009)(2906002)(66446008)(91956017)(64756008)(76116006)(66556008)(66476007)(66946007)(83380400001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?PVmdl9cRZ087o+N8+Fp7juxlMhePWlrdQzWT5w4DEvD22li46Qmhgvnu0QLU?=
 =?us-ascii?Q?MOezpvYMmVJfHOJSjngmiulhGJOpH1Jryl1OYNfPxpWQgejivHCFzjsU2jzX?=
 =?us-ascii?Q?maeVmG/TILKmRJMbQBfUJpN+2EGFr7QA8OtigZfqJYLOTu07QaCiRcTxPRMB?=
 =?us-ascii?Q?tINMrqZ4nkHoQzc35e/dViPOkRQnDGyhcOKZph2yjAkZsxzddbnznGbXQg38?=
 =?us-ascii?Q?6/8ldFRQ/lMT7L+BXX2zLmS5bokoZjWX02kyiyO+b/Q+B9iNtnd6M+alWRht?=
 =?us-ascii?Q?HXkbekwf0SYacEXqUOh6iJ9LSb5Ui1qF5f4fEcsSE+5u0/i4XOr/CKA9QPFh?=
 =?us-ascii?Q?kRSpWWkztETMEKLAL0CVJAfFW1rdOQv9+HP57el0x41zHAtex4aY3KyhBgmb?=
 =?us-ascii?Q?u6ZbB+IW2wnnkN+Yed+qFBvJnT450+8SMfvnMuWmXRJvIbIiVjwGPq8l2opL?=
 =?us-ascii?Q?zu07ETTNWqtxkYCg7qElXtc99cnZMdzmnCDwHNm6kMSrqjNIpOrKHhTSOiAe?=
 =?us-ascii?Q?2YWKFaeaEyEVBDn/mXhzFM80JmpHD0vi63a8YkWmeTMg487sy053iIdY/v3W?=
 =?us-ascii?Q?kxVljTKRn4TTQSedHbEJgmoMTgubz223k4Ow1yMbyPz8jiWbksV/tGSwneKs?=
 =?us-ascii?Q?sVaRAEmDFPCL0b99wsXizCcL7GL2KO8kP8/wpA6O15FVoM0ZSw8kVG7yAzsa?=
 =?us-ascii?Q?im8lxWeQ/8M8OHEbe2KAcc7zaWo3vInx0TAnzFhMAY2IhKxy1sYa+JPYnpcM?=
 =?us-ascii?Q?hvjXvpLpN76B8+oXo6kr0XyUYEHmDcxCc/8O7Ehj5NjAvIyrOqxdFwLuekIw?=
 =?us-ascii?Q?F7ooCKCRTt+Lgxr8BjTXpXWYi/MBF0IpNWP9HBq7vk+DfY9AMs0BbbBmBq4L?=
 =?us-ascii?Q?AYHcx0Ru1wyPf1bXs9x/5GY39+d3otjIRScEmlN6Ijqg0RsrzhyRSO043Fdg?=
 =?us-ascii?Q?cys+mHQQcP94xFPQEfCDBDqo2p7I9k8OKQsvDFEj1so/uZ99x3wwtNS7STT1?=
 =?us-ascii?Q?q3teVsYYaiMaYebiScfhEmES1u2GyUtROxL7PYhfiuSJQY82vs2Xt0tdO6tR?=
 =?us-ascii?Q?1HTr2tfoVf2kZ08Wj4Hh9PfY93W/1kWI2YxA388cgawOOJok6tHlscCXecgc?=
 =?us-ascii?Q?RfPHYBxmUwUpB7FQ9NSQe5bxRYNnE8Mu77jHW6oElaYO3jl0VJR3hB8Rpuq8?=
 =?us-ascii?Q?mjbqVAqM7H1PtoR+mV5WF625pxyGH6YL7axhIneUeF06or8w3G27Ta+/6aZP?=
 =?us-ascii?Q?72nG8mh/b6Co+MrEwtKk0W7S9rkrCntTLihTSilS44xdjy36Zh2zpoXmq0mu?=
 =?us-ascii?Q?pLUmIVVLNhGhnyeLA6VRJdkb3yuxrpBbj8F4sEsDPqmoVLROFPwlNmkpVF06?=
 =?us-ascii?Q?XahjT0Fd5J76BCR2AqpGk2ekVohkofz/TZ5D0ehcPf29QnFZ2DZl3p53X8WS?=
 =?us-ascii?Q?EWKdIZKxupyQeqaZ8F+UY9gtfHD0zjojsqLwUfTYf9OJMnwdupRQcbaQ1GPJ?=
 =?us-ascii?Q?+GOnyN8fcgJdqhOBYNncDBGELprQTZuhqrt5Jk+YU2iyORsvH3ZW0QoTaczT?=
 =?us-ascii?Q?LGlVxLEgCip/VJCCIekRZqZ8uSnwKD499TEPuYutlLK05mhkaokv4hRILWxh?=
 =?us-ascii?Q?9w=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7F0850CE1E38CD4F9AA2F931A736155B@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?BjxQcVFNNeIVwr5UO7kjQYZaab/YI9aEjjfXpl3I7IK5JjnDiJ5UcZndHhwh?=
 =?us-ascii?Q?Nvco6FsZh5KQSnLM6eOKcTC94638LKZCLyn/QVbFx1PSfVGlOvJk5uAKx9Qp?=
 =?us-ascii?Q?OAglXkLf8kFG1pMPFc9Ukvpp+cEJQoqhgI6KIvn94lHvk9AWobfiqomJeeV+?=
 =?us-ascii?Q?BEACzwXvL+qZo7umto532NAIoDGRy+ozrPMh8JWBwsN1RkL1m36IyZO6zl9f?=
 =?us-ascii?Q?K/Yx4SyEdZnxAtcEPmJq87vQov4w+M536TIzLPLPIXbuGeGMMN2n6DsmckO0?=
 =?us-ascii?Q?t+pZJOdLA+nUqJXgzmUDwUbSwA11wQY6mEvQ0UhWbFhuN18++2k7VUYUeOek?=
 =?us-ascii?Q?pQSGPhSrUs9+62/mTNhg8ft7isPzfdrsglP/q//Fs9SO1UwiHFvqBOrfvBfW?=
 =?us-ascii?Q?OgVVRHpvZyIR+W60HuUMSeEBWLLwCJfzhQuHFE+D5eSpLTqn5vesQrhyoIa3?=
 =?us-ascii?Q?0WOpZWwsEVLk6IAbHKRrMsjJig7ifxGbo+5yheaBaOGukBOZAkolC9vkwEAh?=
 =?us-ascii?Q?w/49F7bbhZvwG7EfQkOIzX8YBV2EPhEurI8eHbR0Wqc1mQ2s/CY4QM4Qu/Co?=
 =?us-ascii?Q?pMZut0a+orq6M5lOtArtwouV39Hsj3dhEFcpyrOO/A7KAFOB/4Ragbom1mfo?=
 =?us-ascii?Q?EZ+JVvBEGilfrYDkrmRtie0mlTe3aP0Uq1t4fBWXWJA8r4uheR+nH7l9OJ58?=
 =?us-ascii?Q?Fmk2sThuHpHZri6Rg+SrSqZ8nAXwI3aqgQ+N4zFEDVVl7N5SL7y1RkYTmTZG?=
 =?us-ascii?Q?RO8LDbrLTm3+w0tWzAmQ5clTtMtNm/GdJdWXQMSrzjXHerByTqccmDKE7aqX?=
 =?us-ascii?Q?1QZkwsIvDrSxSnlLC0RjOWxmmFJPmn5Ku7/NMLh8JIGgL6yBEO//AIEqz63+?=
 =?us-ascii?Q?lpSaCFiHirKeBQ2EQYMlYwceSzVxlI5nEqqdWlbfuegh/+4HxGzggx5VTSVF?=
 =?us-ascii?Q?S4WhQW8SLseA3j+z96vbr5xMmxT3md4fYgp2VjII2pOfZMWt9JM8KEmlIzGQ?=
 =?us-ascii?Q?hgshXusBK7BQdfor0pWI9hJZ2qCt80y2ArINwvdHk3pUQuQ=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5433.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 844d2615-12cf-48c6-b5c0-08db972f2bd0
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Aug 2023 10:15:05.6958
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Fy1op1+yI2LwfKYP7BqUi4V5dJPvh1McY37xljbgrImLyEEknb2TjmisYqkW1/1qDDNEq+N1dr+3v7x3eP6wzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5219
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-08-07_09,2023-08-03_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 spamscore=0
 mlxscore=0 bulkscore=0 phishscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2308070095
X-Proofpoint-GUID: q-UT0c15YSWEFYSfmyDYli_sNKjbmnCN
X-Proofpoint-ORIG-GUID: q-UT0c15YSWEFYSfmyDYli_sNKjbmnCN
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

> On 28 Jul 2023, at 08:29, Marc Zyngier <maz@kernel.org> wrote:
>=20
> As we're about to majorly extend the handling of FGT registers,
> restructure the code to actually save/restore the registers
> as required. This is made easy thanks to the previous addition
> of the EL2 registers, allowing us to use the host context for
> this purpose.
>=20
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
> arch/arm64/include/asm/kvm_arm.h        | 21 ++++++++++
> arch/arm64/kvm/hyp/include/hyp/switch.h | 56 +++++++++++++------------
> 2 files changed, 50 insertions(+), 27 deletions(-)
>=20
> diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kv=
m_arm.h
> index 028049b147df..85908aa18908 100644
> --- a/arch/arm64/include/asm/kvm_arm.h
> +++ b/arch/arm64/include/asm/kvm_arm.h
> @@ -333,6 +333,27 @@
> BIT(18) | \
> GENMASK(16, 15))
>=20
> +/*
> + * FGT register definitions
> + *
> + * RES0 and polarity masks as of DDI0487J.a, to be updated as needed.
> + * We're not using the generated masks as they are usually ahead of
> + * the published ARM ARM, which we use as a reference.
> + *
> + * Once we get to a point where the two describe the same thing, we'll
> + * merge the definitions. One day.
> + */
> +#define __HFGRTR_EL2_RES0 (GENMASK(63, 56) | GENMASK(53, 51))
> +#define __HFGRTR_EL2_MASK GENMASK(49, 0)
> +#define __HFGRTR_EL2_nMASK (GENMASK(55, 54) | BIT(50))
> +
> +#define __HFGWTR_EL2_RES0 (GENMASK(63, 56) | GENMASK(53, 51) | \
> + BIT(46) | BIT(42) | BIT(40) | BIT(28) | \
> + GENMASK(26, 25) | BIT(21) | BIT(18) | \
> + GENMASK(15, 14) | GENMASK(10, 9) | BIT(2))
> +#define __HFGWTR_EL2_MASK GENMASK(49, 0)
> +#define __HFGWTR_EL2_nMASK (GENMASK(55, 54) | BIT(50))
> +
> /* Hyp Prefetch Fault Address Register (HPFAR/HDFAR) */
> #define HPFAR_MASK (~UL(0xf))
> /*
> diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp=
/include/hyp/switch.h
> index 4bddb8541bec..966295178aee 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> @@ -70,20 +70,19 @@ static inline void __activate_traps_fpsimd32(struct k=
vm_vcpu *vcpu)
> }
> }
>=20
> -static inline bool __hfgxtr_traps_required(void)
> -{
> - if (cpus_have_final_cap(ARM64_SME))
> - return true;
> -
> - if (cpus_have_final_cap(ARM64_WORKAROUND_AMPERE_AC03_CPU_38))
> - return true;
>=20
> - return false;
> -}
>=20
> -static inline void __activate_traps_hfgxtr(void)
> +static inline void __activate_traps_hfgxtr(struct kvm_vcpu *vcpu)
> {
> + struct kvm_cpu_context *hctxt =3D &this_cpu_ptr(&kvm_host_data)->host_c=
txt;
> u64 r_clr =3D 0, w_clr =3D 0, r_set =3D 0, w_set =3D 0, tmp;
> + u64 r_val, w_val;
> +
> + if (!cpus_have_final_cap(ARM64_HAS_FGT))
> + return;
> +
> + ctxt_sys_reg(hctxt, HFGRTR_EL2) =3D read_sysreg_s(SYS_HFGRTR_EL2);
> + ctxt_sys_reg(hctxt, HFGWTR_EL2) =3D read_sysreg_s(SYS_HFGWTR_EL2);
>=20
> if (cpus_have_final_cap(ARM64_SME)) {
> tmp =3D HFGxTR_EL2_nSMPRI_EL1_MASK | HFGxTR_EL2_nTPIDR2_EL0_MASK;
> @@ -98,26 +97,31 @@ static inline void __activate_traps_hfgxtr(void)
> if (cpus_have_final_cap(ARM64_WORKAROUND_AMPERE_AC03_CPU_38))
> w_set |=3D HFGxTR_EL2_TCR_EL1_MASK;
>=20
> - sysreg_clear_set_s(SYS_HFGRTR_EL2, r_clr, r_set);
> - sysreg_clear_set_s(SYS_HFGWTR_EL2, w_clr, w_set);
> +
> + /* The default is not to trap amything but ACCDATA_EL1 */
> + r_val =3D __HFGRTR_EL2_nMASK & ~HFGxTR_EL2_nACCDATA_EL1;
> + r_val |=3D r_set;
> + r_val &=3D ~r_clr;
> +
> + w_val =3D __HFGWTR_EL2_nMASK & ~HFGxTR_EL2_nACCDATA_EL1;
> + w_val |=3D w_set;
> + w_val &=3D ~w_clr;
> +
> + write_sysreg_s(r_val, SYS_HFGRTR_EL2);
> + write_sysreg_s(w_val, SYS_HFGWTR_EL2);
> }
>=20
> -static inline void __deactivate_traps_hfgxtr(void)
> +static inline void __deactivate_traps_hfgxtr(struct kvm_vcpu *vcpu)
> {
> - u64 r_clr =3D 0, w_clr =3D 0, r_set =3D 0, w_set =3D 0, tmp;
> + struct kvm_cpu_context *hctxt =3D &this_cpu_ptr(&kvm_host_data)->host_c=
txt;
>=20
> - if (cpus_have_final_cap(ARM64_SME)) {
> - tmp =3D HFGxTR_EL2_nSMPRI_EL1_MASK | HFGxTR_EL2_nTPIDR2_EL0_MASK;
> + if (!cpus_have_final_cap(ARM64_HAS_FGT))
> + return;
>=20
> - r_set |=3D tmp;
> - w_set |=3D tmp;
> - }
> + write_sysreg_s(ctxt_sys_reg(hctxt, HFGRTR_EL2), SYS_HFGRTR_EL2);
> + write_sysreg_s(ctxt_sys_reg(hctxt, HFGWTR_EL2), SYS_HFGWTR_EL2);
>=20
> - if (cpus_have_final_cap(ARM64_WORKAROUND_AMPERE_AC03_CPU_38))
> - w_clr |=3D HFGxTR_EL2_TCR_EL1_MASK;
>=20
> - sysreg_clear_set_s(SYS_HFGRTR_EL2, r_clr, r_set);
> - sysreg_clear_set_s(SYS_HFGWTR_EL2, w_clr, w_set);
> }
>=20
> static inline void __activate_traps_common(struct kvm_vcpu *vcpu)
> @@ -145,8 +149,7 @@ static inline void __activate_traps_common(struct kvm=
_vcpu *vcpu)
> vcpu->arch.mdcr_el2_host =3D read_sysreg(mdcr_el2);
> write_sysreg(vcpu->arch.mdcr_el2, mdcr_el2);
>=20
> - if (__hfgxtr_traps_required())
> - __activate_traps_hfgxtr();
> + __activate_traps_hfgxtr(vcpu);
> }
>=20
> static inline void __deactivate_traps_common(struct kvm_vcpu *vcpu)
> @@ -162,8 +165,7 @@ static inline void __deactivate_traps_common(struct k=
vm_vcpu *vcpu)
> vcpu_clear_flag(vcpu, PMUSERENR_ON_CPU);
> }
>=20
> - if (__hfgxtr_traps_required())
> - __deactivate_traps_hfgxtr();
> + __deactivate_traps_hfgxtr(vcpu);

Reviewed-by: Miguel Luis <miguel.luis@oracle.com>

Thanks

Miguel

> }
>=20
> static inline void ___activate_traps(struct kvm_vcpu *vcpu)
> --=20
> 2.34.1
>=20

