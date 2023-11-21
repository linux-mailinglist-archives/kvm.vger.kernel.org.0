Return-Path: <kvm+bounces-2198-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6998B7F3439
	for <lists+kvm@lfdr.de>; Tue, 21 Nov 2023 17:51:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 45A68B22051
	for <lists+kvm@lfdr.de>; Tue, 21 Nov 2023 16:50:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE20C54F9F;
	Tue, 21 Nov 2023 16:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="f87u6UhT";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="FHY0j8QS"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CE6692
	for <kvm@vger.kernel.org>; Tue, 21 Nov 2023 08:50:43 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3ALFoFal026806;
	Tue, 21 Nov 2023 16:49:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=CZf7+0Gf51poGhudlRXJSz9/vIritvaoAA/B0ggXZ9U=;
 b=f87u6UhTvM0NyRwb2vvjazoLc/s3bG4IIOgHPR+PgbhFydxoqYFTpnpYuyOcX4dC6FUa
 +Nmeynbc3cZd1kSQJfPiZGOLxNdE1UD4vLM3AzOP8JcHcNIkJhtQKWLHVfHVFIpeQQ0K
 0K1kaxiwhTIEYMgMfdX0Yzgk/gucq73jI/l1eGalPiQD7IBN4rRmalK4yjKWMZIFaEE2
 41KNnnl9RzwhPrjA1JBnJeHkAjC8ca5HR6Ehs+yIiBaYGawq+9y5jzTJ98qIBvDpbZbH
 HzzGyMPRXOCQSneQ/6dlIBFnVP83gvYajfHkNiitZcIumQfqvj1+LBCPSGnhI8OMSuwK CQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3uekv2wjnr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Nov 2023 16:49:56 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3ALFosmC023639;
	Tue, 21 Nov 2023 16:49:54 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3uekq7ab1a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Nov 2023 16:49:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oYBpOAOl/C14YApOh4VpZFz5iLdE3FgvisvKfzMtsdhZVDqAL7pZkdwunoVM2hdv0FO1JsRxxTUoYTF89BpyDR71IXyF1uUcV5ezLZI6xtwaycjqzMs/LplVWd9V+Xt8zFPCsqyG0wEgytD79q0A5HI05ZPArL1fALZSP7/+BiDfgMc86XWLcWv2j/aq5VnaNDPXFgFFswgP7akgSVppBcLgynHgBu9wkOEpMzj+fEjy8AdIvc46vTgJpFcHKZR+LnRDzrSc3KIEBZrA796WezmO9tVLzcjhJCJjGhEwR24/D0ab4w4LovAFuf7auxuqBD99ZpMbydvh+xA4f+QBgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CZf7+0Gf51poGhudlRXJSz9/vIritvaoAA/B0ggXZ9U=;
 b=NeXwU/6LbYuny2f1l0Bswow87yS2zdakKaIbIRrpqXP+k1sx51U/FhWhZToERgvpdON1e53PZoh1yfiROmXxqeyonY7RA6GyjhSXjauC54U2hCnJBeZqk+yuI7vJH9fRwchrm0a9OCQBmT+bkliWQ8H67fDib239zuk5uPBfRkNBHvkU+18xAGMPQrvQQdzZwKPsduSHACn7y8n4Nq14/J990GrvVmEPAoxSE27Q07bFcnxQ5KCVlkMqHhhCGIhDpda9BEvVJZNR482Nn4lSLRynkJbV2cORuSlQiFpEpLugm5QYgZBLoikW681MWKn0oXHyREQ0ACHe709F785gRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CZf7+0Gf51poGhudlRXJSz9/vIritvaoAA/B0ggXZ9U=;
 b=FHY0j8QSR2IaURkMV8TrwDwDMb98AQyFABCjf7kEXIeUuBwHyULlRUO8EiVvFgColgPGLGrM1fUy7UPjwTW+rx2eb7FLF6TvGERjD2bMBwhQUnQVm3nQ4QKr5BVSxaWpPEO3d+vNAAd51svCVL4fzr9jlbr58w883p/+VcFhlZw=
Received: from PH0PR10MB5433.namprd10.prod.outlook.com (2603:10b6:510:e0::9)
 by DS7PR10MB7279.namprd10.prod.outlook.com (2603:10b6:8:e2::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7002.28; Tue, 21 Nov
 2023 16:49:52 +0000
Received: from PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::cef0:d8a0:3eb1:66b2]) by PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::cef0:d8a0:3eb1:66b2%4]) with mapi id 15.20.7002.028; Tue, 21 Nov 2023
 16:49:52 +0000
From: Miguel Luis <miguel.luis@oracle.com>
To: Marc Zyngier <maz@kernel.org>
CC: "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
        "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
        Alexandru Elisei
	<alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Chase
 Conklin <chase.conklin@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Darren Hart
	<darren@os.amperecomputing.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton
	<oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v11 00/43] KVM: arm64: Nested Virtualization support
 (FEAT_NV2 only)
Thread-Topic: [PATCH v11 00/43] KVM: arm64: Nested Virtualization support
 (FEAT_NV2 only)
Thread-Index: AQHaG7L/0SySzEvvDUqvWro5gTy1j7CE/goA
Date: Tue, 21 Nov 2023 16:49:52 +0000
Message-ID: <DB1E4B70-0FA0-4FA4-85AE-23B034459675@oracle.com>
References: <20231120131027.854038-1-maz@kernel.org>
In-Reply-To: <20231120131027.854038-1-maz@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR10MB5433:EE_|DS7PR10MB7279:EE_
x-ms-office365-filtering-correlation-id: a75d8379-dc31-44cc-3fb7-08dbeab1e1c3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 yOPxb6/xTOnkEzR00AecFNMA2fM6OYUKJ+Ib1dB7KrrAb9pdNaMXtL+2PhvkcFBjzytLBO1sEYUZvLkgqFgHfl24jHIjWcMiQDsQHNiXoO7+G8M/7P42KzwiL4o7y4nS9mrTCAux/LTFoyab0fi5o7fGLOJpse6KxifRHC3l7zFnInm7aqu1vsyvumyeng91hjBqe7Sw1CI4wJ2uNn6Ck5P5Ruj6AkX/aQhdIMwpe/R9h9DYGHmxV5zX39OxbK1q3yzs3EGIt0Hp3M+8dtFOVWXh6XqZodEXRRbU/CduOjm7QTuz2Kud6HOddmUahz0McoY8agrU1e3rSjU+5FyMl1bYYKVznOiKTui0x5QbFw4CJMJXlrD2sWc2dmAFdxtnMgsY9uQj+uC7/enB7eecTinpuED1HKRa2LcHMaLuDsQjhCWYOpqZOrJlj7XwRW4ZYjVQOQY1N2zmlOL6Xxxj81QrFstXm0M7t1AxXKcl5ghDz4jnoeUcT1jPZrbKHU97AC7vHvMqXyat60+0nQZPqWYGs2M3f5hgYw64hjc8pwAN4Hlu5ITR+xHD4XOkyTogDzT3pIB9LPayawFMZbn9/xSvt6+ECCYYbMkER4b8mkwR8FLyoKTcls/OecmJ16RQtFR1D1BYJnA4xyWOlDQox5NFAMDHaAFtsoX/wsTOvLp7+/kd6/hrcv0m76x7Y+jK
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5433.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(376002)(396003)(366004)(136003)(39860400002)(230922051799003)(64100799003)(451199024)(186009)(1800799012)(66899024)(316002)(6916009)(91956017)(54906003)(66476007)(66946007)(66556008)(64756008)(76116006)(66446008)(53546011)(6512007)(6506007)(2616005)(38070700009)(966005)(6486002)(478600001)(71200400001)(38100700002)(122000001)(83380400001)(33656002)(86362001)(36756003)(44832011)(2906002)(7416002)(5660300002)(8936002)(8676002)(4326008)(41300700001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?us-ascii?Q?TywOnujG/pQg+q+oaJR3itJu8XkqrPnTMlb90zOA7I1wksZ0zWdf1BqWjcg8?=
 =?us-ascii?Q?+n1qAaIwIfhvtROYdt7UrgMPPPDenZ5OBoIyvF9+8I3EFUZ3VTg4wlpa8ytn?=
 =?us-ascii?Q?iS+gY4WnHTjsxgbloX36+3P0iKstpX921SKpKFKsnOd+7xbZKDqIrBLdG0q5?=
 =?us-ascii?Q?Mr1aM2j6TDF50WCtaCo9Iaa02jv1R90AkS+9zxlPszgMhJfDEOl2d+j1MjEe?=
 =?us-ascii?Q?kG8OES2WmybO9x209I4KdgBRoF3w5EizrVPtM++JVzu3LXfjq2jEY9fgUGhW?=
 =?us-ascii?Q?fKT6xUMwiSKK4icnzAwoilYOBcL9N7FgNzLH5Vt3r2OaPg6tPgbriXWXTInb?=
 =?us-ascii?Q?EXqLk/YrHQlW137z416USFtxAGkf+8081yMlDr9oJ6ApmV0gCUfCidz7s3I1?=
 =?us-ascii?Q?oO59VFJSH7vGHpkBqoEUqjdcVE6ux2oW+Q0DrGpK9/PCH9be1t7mAsbj/rnX?=
 =?us-ascii?Q?NpxbCzkFNMNTxWiYfXXtbtJxgljKycnOHl5Hnf+xeBg+T/mp//Z2ZNj5KCL1?=
 =?us-ascii?Q?bquQnjcYjJTsP1dH6rMhyfIzjhjDyKlZgVWni/VZZh0Mr3m7CVQfMJ55Z9g6?=
 =?us-ascii?Q?K3frXMzs+PtwTSId55JoK0KK1wEySL3rkImxOO7CcIvqNyUo5paypGrk/iZK?=
 =?us-ascii?Q?Dkr5eybMoD6eYA4j90hPMvsKC5ceXJFHLQjehRI+cdVudffuhRKOuCVhiTs0?=
 =?us-ascii?Q?PU9JM6D42SbHFlWnQfZIdx5DJ9YoNM87qGmcPK+8TIW6HFRgzXgwKJ/PPxYx?=
 =?us-ascii?Q?8b7aCVXuknRklaIHrUrOuB9hdzc7hf50YsHJXVtI9g+x4iEUGTJbXpwH6nqg?=
 =?us-ascii?Q?wTzCuhdaEyerRjpMRTpY/SW0WN6+G0IbAfU2+DkCOlv05F9AKBGw71tPjjvr?=
 =?us-ascii?Q?JALysPFKWsFMOc9m5UzKj0fw+aMFcAzCME98vZe/zZqSPVDGy7YM64DpWi8c?=
 =?us-ascii?Q?xNPGXOOShCqhyWDDfEI8v+lmMMxET1aRqG2K6cYqYXDmUuwuFeL/wrbinVEh?=
 =?us-ascii?Q?qffmO4yf9AoWi717jxx2wEUxSjyA0lk+rWGew9SR/PrsFp06VyQYZNKK81r4?=
 =?us-ascii?Q?TEapseUOAc0xGQB3NNIzqRicUNCbca3XzNU+2imm0blDP1M3lBrba/jOk330?=
 =?us-ascii?Q?aMC04ZH6fIJxxeP7APy750xUiwO8DFMY/cuKiTcSwPffU+zA78i1tJh9fbFx?=
 =?us-ascii?Q?RiTX+MmMNPoRc4js0zWbIW3D+DK8nb+Mc7+NJGF8/RupTHAdmHs0hqgVLmJv?=
 =?us-ascii?Q?K/rYeMqZWwLcG5VTEvk3n1i+zMcWSH3QYpe0U8VsvWUSE1Ws6xX2uG5bE6UL?=
 =?us-ascii?Q?aegmNY0AcE/8TPQzHPVFJm/qIZvAGUW7kvT3lxDVDVCKahjwB9ZEVbVBiglf?=
 =?us-ascii?Q?XAS8Yiep2+/zUadHgFoX8Nh2el3WQm+EiZaEXvZ67zGGLmY9YMlWlY2Y3aYH?=
 =?us-ascii?Q?lwWBfm9y5d7+mXPOKK3vXsMazwlHqLt/38ixUBKqkvrZqEV2pjCHQIjO1jxS?=
 =?us-ascii?Q?foFbwYctWt5yQdxnPD0ftOCU13fp3DZfrTNPP7v7tNJzfTA6BKv/0kkyc6Zs?=
 =?us-ascii?Q?6GdOIKVyO7XRxnBYqlO2m3tLVN2ggzMu/w79X+Dj+mwzfTJVAyRz/81xFbgN?=
 =?us-ascii?Q?0kkO57VRpQ+WUiobscqAoE0=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <DC9DBA823B3B7549B4AAE50799791A90@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	=?us-ascii?Q?CQu6fk7BdFfCV6Gcl3D3r+l4lR5SnlCIBJ7SavetaPCA6Qh29UvouM2CMSXM?=
 =?us-ascii?Q?Vzx0PNWzzmTwjLx0ZiB8hnDDJuagH/EV60WDYmJbL8xFjlDq7M8TAYriVSFD?=
 =?us-ascii?Q?1h+eXQd9S1lnEDiJUQhf0G7w3qSVFByd4nyXWqGB9mT/nmct4HBK98rMxTK2?=
 =?us-ascii?Q?YvtaFVqPHdsmpMJbxFCNZPnLj6NiNnqCQUOHaPo/q1G1IwAMi549Wb5MjTr+?=
 =?us-ascii?Q?rgoMFkBv6idjvye7OL7z4B6bMZSkj9iYVo8tHtvjXADsJj7jpCHawb9Zzl3P?=
 =?us-ascii?Q?YTnFJaINmfkLA1Hp5Wsb3jlWKjcECmNdxvNOXbnqxoCDL58p66SHwq7Jtwf8?=
 =?us-ascii?Q?N97oYAiU0W9bcjY1Gyx+X6nLZkIGWyNCSDkt9t7Fg1ldkD6UdkyA0KsFDwz9?=
 =?us-ascii?Q?TW1dUvfZ/3su5+mDWM2Pi4rqRJRSvPgjS0YFsXQPe+vkoubM7ZyAP7kKOF7G?=
 =?us-ascii?Q?nsR3XwO5gQ+vP+OVcI+Q4Oh4E1u/caihSNUdl4fmp1r7dtTpzGwIcKP60QO7?=
 =?us-ascii?Q?ufDC/7Yl6w1nCUbBYS1f3uSgqJ0AFaOgX585DsOfvtEu+Q5YiHGPrY3MxBeJ?=
 =?us-ascii?Q?noHN4N/3MGYndjQyiaOkr7KUhkgKZXpNViOiDW3m2hvENmvxsW+MFYg7NtX4?=
 =?us-ascii?Q?c+aYmGQ69boulMNWz+FeSnhUIuaZxiKMnK7YAgF1lSJ37wgTnpwFkMLqMwOi?=
 =?us-ascii?Q?SB60WQ/hD9aSa5yc4Tt2qQGEkxMbeDYmeOTGNH0PfzGrg/fLr1KEgT5lmDAr?=
 =?us-ascii?Q?RWyscH6kCm041XFr/3I28ExobXUGPv8eeBDJZbjDn1uxvFWl5PRNA3BXlfeu?=
 =?us-ascii?Q?kH/gdYLvloZLu2z2X6jFLBZ67jGOxInCX3LD3wObbGtMHtrS6y6XIj+oymJq?=
 =?us-ascii?Q?QGvIjRDbWGUtEd4pqHwLDFqkiTwVTtkOfGJY+oc/uxHUsyexX9DI4RJiee9l?=
 =?us-ascii?Q?Tn/3OSq4sY5+Y7QPC3FIWJaiITQQHx1xfnowplqnB+gjcsO2i434lmCk2Kk/?=
 =?us-ascii?Q?m+VY4/mI1yn7mKtcsRgHIs75iAlHZPOBHugwikeEyeMWiINPxnZJsodKUAq1?=
 =?us-ascii?Q?RRKtiHnowN/yqgd79Wn44yOWoXjPWuU83lhvX4SZDzAYhdjlQ/k=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5433.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a75d8379-dc31-44cc-3fb7-08dbeab1e1c3
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2023 16:49:52.0305
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PIhdg3+g56Z499v+ai2YCug6n2BVQMI88YYjuUjdOfsNewiNTD9rSqqthqjVV/0Cv0QEfYGZr3vlDwH2c5TEhg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB7279
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-21_10,2023-11-21_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=999 phishscore=0 malwarescore=0 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311060000
 definitions=main-2311210132
X-Proofpoint-GUID: KGslg5qCGVvc8TB_Z0l82LDS6eTBFDwH
X-Proofpoint-ORIG-GUID: KGslg5qCGVvc8TB_Z0l82LDS6eTBFDwH

Hi Marc,

> On 20 Nov 2023, at 12:09, Marc Zyngier <maz@kernel.org> wrote:
>=20
> This is the 5th drop of NV support on arm64 for this year, and most
> probably the last one for this side of Christmas.
>=20
> For the previous episodes, see [1].
>=20
> What's changed:
>=20
> - Drop support for the original FEAT_NV. No existing hardware supports
>  it without FEAT_NV2, and the architecture is deprecating the former
>  entirely. This results in fewer patches, and a slightly simpler
>  model overall.
>=20
> - Reorganise the series to make it a bit more logical now that FEAT_NV
>  is gone.
>=20
> - Apply the NV idreg restrictions on VM first run rather than on each
>  access.
>=20
> - Make the nested vgic shadow CPU interface a per-CPU structure rather
>  than per-vcpu.
>=20
> - Fix the EL0 timer fastpath
>=20
> - Work around the architecture deficiencies when trapping WFI from a
>  L2 guest.
>=20
> - Fix sampling of nested vgic state (MISR, ELRSR, EISR)
>=20
> - Drop the patches that have already been merged (NV trap forwarding,
>  per-MMU VTCR)
>=20
> - Rebased on top of 6.7-rc2 + the FEAT_E2H0 support [2].
>=20
> The branch containing these patches (and more) is at [3]. As for the
> previous rounds, my intention is to take a prefix of this series into
> 6.8, provided that it gets enough reviewing.
>=20
> [1] https://lore.kernel.org/r/20230515173103.1017669-1-maz@kernel.org
> [2] https://lore.kernel.org/r/20231120123721.851738-1-maz@kernel.org
> [3] https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git=
/log/?h=3Dkvm-arm64/nv-6.8-nv2-only
>=20

While I was testing this with kvmtool for 5.16 I noted the following on dme=
sg:

[  803.014258] kvm [19040]: Unsupported guest sys_reg access at: 8129fa50 [=
600003c9]
                { Op0( 3), Op1( 5), CRn( 1), CRm( 0), Op2( 2), func_read },

This is CPACR_EL12.

Still need yet to debug.

As for QEMU, it is having issues enabling _EL2 feature although EL2 is supp=
orted by
checking KVM_CAP_ARM_EL2; need yet to debug this.

Thanks

Miguel

> Andre Przywara (1):
>  KVM: arm64: nv: vgic: Allow userland to set VGIC maintenance IRQ
>=20
> Christoffer Dall (2):
>  KVM: arm64: nv: Implement nested Stage-2 page table walk logic
>  KVM: arm64: nv: Unmap/flush shadow stage 2 page tables
>=20
> Jintack Lim (3):
>  KVM: arm64: nv: Respect virtual HCR_EL2.TWX setting
>  KVM: arm64: nv: Respect virtual CPTR_EL2.{TFP,FPEN} settings
>  KVM: arm64: nv: Trap and emulate TLBI instructions from virtual EL2
>=20
> Marc Zyngier (37):
>  arm64: cpufeatures: Restrict NV support to FEAT_NV2
>  KVM: arm64: nv: Hoist vcpu_has_nv() into is_hyp_ctxt()
>  KVM: arm64: nv: Compute NV view of idregs as a one-off
>  KVM: arm64: nv: Drop EL12 register traps that are redirected to VNCR
>  KVM: arm64: nv: Add non-VHE-EL2->EL1 translation helpers
>  KVM: arm64: nv: Add include containing the VNCR_EL2 offsets
>  KVM: arm64: Introduce a bad_trap() primitive for unexpected trap
>    handling
>  KVM: arm64: nv: Add EL2_REG_VNCR()/EL2_REG_REDIR() sysreg helpers
>  KVM: arm64: nv: Map VNCR-capable registers to a separate page
>  KVM: arm64: nv: Handle virtual EL2 registers in
>    vcpu_read/write_sys_reg()
>  KVM: arm64: nv: Handle HCR_EL2.E2H specially
>  KVM: arm64: nv: Handle CNTHCTL_EL2 specially
>  KVM: arm64: nv: Save/Restore vEL2 sysregs
>  KVM: arm64: nv: Configure HCR_EL2 for FEAT_NV2
>  KVM: arm64: nv: Support multiple nested Stage-2 mmu structures
>  KVM: arm64: nv: Handle shadow stage 2 page faults
>  KVM: arm64: nv: Restrict S2 RD/WR permissions to match the guest's
>  KVM: arm64: nv: Set a handler for the system instruction traps
>  KVM: arm64: nv: Trap and emulate AT instructions from virtual EL2
>  KVM: arm64: nv: Hide RAS from nested guests
>  KVM: arm64: nv: Add handling of EL2-specific timer registers
>  KVM: arm64: nv: Sync nested timer state with FEAT_NV2
>  KVM: arm64: nv: Publish emulated timer interrupt state in the
>    in-memory state
>  KVM: arm64: nv: Load timer before the GIC
>  KVM: arm64: nv: Nested GICv3 Support
>  KVM: arm64: nv: Don't block in WFI from nested state
>  KVM: arm64: nv: Fold GICv3 host trapping requirements into guest setup
>  KVM: arm64: nv: Deal with broken VGIC on maintenance interrupt
>    delivery
>  KVM: arm64: nv: Add handling of FEAT_TTL TLB invalidation
>  KVM: arm64: nv: Invalidate TLBs based on shadow S2 TTL-like
>    information
>  KVM: arm64: nv: Tag shadow S2 entries with nested level
>  KVM: arm64: nv: Allocate VNCR page when required
>  KVM: arm64: nv: Fast-track 'InHost' exception returns
>  KVM: arm64: nv: Fast-track EL1 TLBIs for VHE guests
>  KVM: arm64: nv: Use FEAT_ECV to trap access to EL0 timers
>  KVM: arm64: nv: Accelerate EL0 timer read accesses when FEAT_ECV is on
>  KVM: arm64: nv: Allow userspace to request KVM_ARM_VCPU_NESTED_VIRT
>=20
> .../virt/kvm/devices/arm-vgic-v3.rst          |  12 +-
> arch/arm64/include/asm/esr.h                  |   1 +
> arch/arm64/include/asm/kvm_arm.h              |   3 +
> arch/arm64/include/asm/kvm_asm.h              |   4 +
> arch/arm64/include/asm/kvm_emulate.h          |  53 +-
> arch/arm64/include/asm/kvm_host.h             | 223 +++-
> arch/arm64/include/asm/kvm_hyp.h              |   2 +
> arch/arm64/include/asm/kvm_mmu.h              |  12 +
> arch/arm64/include/asm/kvm_nested.h           | 130 ++-
> arch/arm64/include/asm/sysreg.h               |   7 +
> arch/arm64/include/asm/vncr_mapping.h         | 102 ++
> arch/arm64/include/uapi/asm/kvm.h             |   1 +
> arch/arm64/kernel/cpufeature.c                |  22 +-
> arch/arm64/kvm/Makefile                       |   4 +-
> arch/arm64/kvm/arch_timer.c                   | 115 +-
> arch/arm64/kvm/arm.c                          |  46 +-
> arch/arm64/kvm/at.c                           | 219 ++++
> arch/arm64/kvm/emulate-nested.c               |  48 +-
> arch/arm64/kvm/handle_exit.c                  |  29 +-
> arch/arm64/kvm/hyp/include/hyp/switch.h       |   8 +-
> arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h    |   5 +-
> arch/arm64/kvm/hyp/nvhe/switch.c              |   2 +-
> arch/arm64/kvm/hyp/nvhe/sysreg-sr.c           |   2 +-
> arch/arm64/kvm/hyp/vgic-v3-sr.c               |   6 +-
> arch/arm64/kvm/hyp/vhe/switch.c               | 211 +++-
> arch/arm64/kvm/hyp/vhe/sysreg-sr.c            | 133 ++-
> arch/arm64/kvm/hyp/vhe/tlb.c                  |  83 ++
> arch/arm64/kvm/mmu.c                          | 248 ++++-
> arch/arm64/kvm/nested.c                       | 813 ++++++++++++++-
> arch/arm64/kvm/reset.c                        |   7 +
> arch/arm64/kvm/sys_regs.c                     | 978 ++++++++++++++++--
> arch/arm64/kvm/vgic/vgic-init.c               |  35 +
> arch/arm64/kvm/vgic/vgic-kvm-device.c         |  29 +-
> arch/arm64/kvm/vgic/vgic-v3-nested.c          | 270 +++++
> arch/arm64/kvm/vgic/vgic-v3.c                 |  35 +-
> arch/arm64/kvm/vgic/vgic.c                    |  29 +
> arch/arm64/kvm/vgic/vgic.h                    |  10 +
> arch/arm64/tools/cpucaps                      |   2 +
> include/clocksource/arm_arch_timer.h          |   4 +
> include/kvm/arm_arch_timer.h                  |  19 +
> include/kvm/arm_vgic.h                        |  16 +
> include/uapi/linux/kvm.h                      |   1 +
> tools/arch/arm/include/uapi/asm/kvm.h         |   1 +
> 43 files changed, 3725 insertions(+), 255 deletions(-)
> create mode 100644 arch/arm64/include/asm/vncr_mapping.h
> create mode 100644 arch/arm64/kvm/at.c
> create mode 100644 arch/arm64/kvm/vgic/vgic-v3-nested.c
>=20
> --=20
> 2.39.2
>=20


