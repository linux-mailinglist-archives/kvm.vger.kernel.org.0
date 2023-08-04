Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B266770261
	for <lists+kvm@lfdr.de>; Fri,  4 Aug 2023 15:58:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231193AbjHDN6Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Aug 2023 09:58:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbjHDN6X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Aug 2023 09:58:23 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65028CC
        for <kvm@vger.kernel.org>; Fri,  4 Aug 2023 06:58:22 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 374Bxn4J029576;
        Fri, 4 Aug 2023 13:57:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=IK3dbLCDA6fXxbTlohFneHQ8e/f+NLu9z2eCdtSpWZw=;
 b=jjIGfROkVcC0QZba4f+H4PcgNr2LyU8Qfd0uS8JQlwHl6yytaSXWKCAOGMMlFhk/GNW6
 tCJEZksgeIDJneR5HnKEpb/Aq/qqwOs22D/GheGhEsEwGXlmF4yyPGWVJuQXsAcnh6ll
 wQPaQuTayA020aPgBJgU1geAZB8IvHXe9C2tFhTG4Czfw/6hJvl4Q4feWvcYYkfRGVNg
 mxM98ObHt/jgsCJoQVFIuW9imosDn9XS3IlU2KuQqLe9xn7vnO64vG4kfClH7BiVOQCR
 N3YTZ4tKx9xKae/giFRz38mR3TISS4jc0yJNWGJytCkCcd6YawKgCH5/hhZXd+HxYNqR Ig== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s4s6ebruh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Aug 2023 13:57:45 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 374CnPTt021219;
        Fri, 4 Aug 2023 13:57:45 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2041.outbound.protection.outlook.com [104.47.56.41])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3s8kqevhm6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Aug 2023 13:57:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HnT9YU5iMc7nl2H2cvVuEJoOqS4PDe1P6my76aBefZcvD9eZYJovjlfJgBYxB/CmhsU7JZR6BHeoy34eJuQik21vKyoHyauDP0Gh+SuNjZovUFT8oOCxb52PcRrw5AY0SzzhgAsRRBDXjuxwo6Ws8T8RyPUhWrYMqtHj78mcFxCxe/IgMR/RinvsILI/fRX8Mzy2vZ4xHmZMXgG53Qqqp3FjYxnlfAwQxbazHR7U6WeI+fSsDowvKjSJHJQOUs7fBZHUxs+DTDt68VDCYWAIRBanBY+kq1211hp7q9unnmOmxxil2OK6oYPbOlvZ97JkWBUVP+jcmbyqO9GrICMLeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IK3dbLCDA6fXxbTlohFneHQ8e/f+NLu9z2eCdtSpWZw=;
 b=cp94i0kZUpPkKu3R9sF52gCEN/hl7U6lPWarR7a8rVi3gK4ATwllJHkNw0VyxlZLbc0l0BjCErCW677iG32+0dXj0qwEVFPhvcFyPQaa0Gpw5XOy+fsBKH4DNYgtoD7bdI9Wo4eFI/LN6in6q9owpN24gZKUBEnQ+qYO6Jx4nLQjHCZchoolu7hBPicG8KTWX9bLHaq0a3c1lYhv3scVvOavE+N3eJ12TEnqGaw1cEaSb6GhR50MSLFy8p/24I/KQdUYURSz9cgpmKzaNkzAltzUBrF5PJ108C3kwyxzw/UVk7PSJ9TVmIyVtVR7J+wMXwvrAzjTYvIFLuohnKVlRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IK3dbLCDA6fXxbTlohFneHQ8e/f+NLu9z2eCdtSpWZw=;
 b=d6r8z+yhOuAyc2PsieH8QX5i3H4K3xUmUydXBrkbh9L3Gz0Gix1C6pZ9jvbKYEqx6kuAygFI+2HKuCVmbD6w/TFcUYbQN25ST2axpSXlBm+BGuAu6VqeyBjGhp7f8hC2DMCsUA0MWG5I1r+ZLi1GSNYXrZjGDXCG+O7UZ+UVplw=
Received: from PH0PR10MB5433.namprd10.prod.outlook.com (2603:10b6:510:e0::9)
 by PH7PR10MB6225.namprd10.prod.outlook.com (2603:10b6:510:1f2::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.20; Fri, 4 Aug
 2023 13:57:42 +0000
Received: from PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::76c:cb31:2005:d10c]) by PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::76c:cb31:2005:d10c%5]) with mapi id 15.20.6652.021; Fri, 4 Aug 2023
 13:57:42 +0000
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
Subject: Re: [PATCH v2 11/26] KVM: arm64: Add missing HCR_EL2 trap bits
Thread-Topic: [PATCH v2 11/26] KVM: arm64: Add missing HCR_EL2 trap bits
Thread-Index: AQHZwTAXRIwwKlNKCk6MpWmM9wHQZK/aNNcA
Date:   Fri, 4 Aug 2023 13:57:42 +0000
Message-ID: <322690FC-5A3A-4D48-89C4-A05E12B6CE42@oracle.com>
References: <20230728082952.959212-1-maz@kernel.org>
 <20230728082952.959212-12-maz@kernel.org>
In-Reply-To: <20230728082952.959212-12-maz@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR10MB5433:EE_|PH7PR10MB6225:EE_
x-ms-office365-filtering-correlation-id: 97cd9655-2379-42bc-6c0e-08db94f2c5aa
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WRn/Mzkpm/WHb9JJLGh10WLDh2mtckXf0327NeeQn/rKyK4cDKDfEsI3S0pxhyo3PXlKA8zglouSkrWU7aHl3M/OzeF4gv0WFcUP7PV2htHI5EDYgrcEp8b1D2ZKyJXlWgCtMly9Rd4Wf69rJ5D/84H1b8/9RqrZPR8EbkFnJeAB9GGMAwfWm0lYy/b2QuYvcGz2okvFCCDG8p9qagvhX+qyfA3ywIHTKmjpRVSbhVNqbnQ4wZAJaslifHN48csgQ8OVa+C859j7Admskb5DO1uQHUCSXY6LE/JM6XKXPGVOujjSsOdr7aDD26pSWMDLEO6YqYh/eRL3SXbebvW7R5VmTUAtVJeuYYtZuAz4Tpt97c1SfTX2ry/3exCuhooWzJ9mMA9acN1DxRaaSAi/ZOtaQnpKamAl9Oql1ZDqwdpnaHCDRxmwfo4Sj/ZGMaxc5gi7CkOGeEPcDDGAAFsUU0wapIu1Dzc31qcXMjlesacaEqXk7U2wYwkwKuM7FYIPtRMNocV9vIzZvWq0pBO9Hld/EnbDJ+iDadPBJs1PlksovwUijP7Ab8TUcVcY6tF3kSGjlZglcHSpy+zmmAN67RvJen39ZQCLkKYn2SU8oc2qAJBhqtG4MNOTaI6pJ0NZ3axOQDaFp/kkeBDKxaSyVQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5433.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(39860400002)(376002)(366004)(346002)(396003)(451199021)(1800799003)(186006)(2616005)(53546011)(8676002)(6506007)(4326008)(2906002)(66476007)(316002)(91956017)(76116006)(66946007)(5660300002)(6916009)(66446008)(64756008)(66556008)(44832011)(7416002)(8936002)(41300700001)(71200400001)(6486002)(6512007)(478600001)(122000001)(54906003)(38100700002)(33656002)(36756003)(86362001)(38070700005)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?UZVA2yF1qwaELPVZgiWbFYDh7CwTlwNR4d//jURSjxdUPxrAdySVudYZXLOP?=
 =?us-ascii?Q?t6vmdDR6ekkDMqhlwF4GbftqapRw3iYvrDF8GrSuTSDmTaOWl9lMnt1vS6Gr?=
 =?us-ascii?Q?6KAp/U9k34cCkXIPe3a31BcFXU/l9WlScMmDpZEwb9NVRAM8B27L9jQ1J8CR?=
 =?us-ascii?Q?wNfepBVK7Qo76+CsfXA8jOJ3ckOnXFwmGa1dA5+Fr+m/DeqnHVDvGq4/3D/9?=
 =?us-ascii?Q?/sRPIA3fu0dD/PYRCq4KzI65wSZSiymxAbo71Q9zskG2o0D+/lup7wrVGphp?=
 =?us-ascii?Q?U20w0JkS3OQdUEa4yOVbE24KjYJeunWlbopIcOXjeSj2OVAlD/q0iuBif3LH?=
 =?us-ascii?Q?F4p8JDtYiPKH+B40jVcvpHmNHQ2wMAAo92PzK8gyTDwuh7fxoelvrHzMEZ+2?=
 =?us-ascii?Q?w6PWjeRBvEY1//09V3ro69FumDa3t6/rPWIcSa7eWH/gLeL4dnuo4ZjeXWAM?=
 =?us-ascii?Q?oqEp8/m6cdgmk5ibTHJkHQHB75xLZH8uOqiagi6aC5Mzm/dPLBIPooZst/Hp?=
 =?us-ascii?Q?S3gnJrBjtY1P/0uY/gBDsXZXLsYji0wlPuez01FlLEh2dU8t0KeBffVx+03z?=
 =?us-ascii?Q?J4qii7V+z6wXVvs7PdreQSF956zdxhzogTrRoKtNN78R2ay4bxlfKjViNQPD?=
 =?us-ascii?Q?+J6oJlM2aBS9cttjlP+0r3bWNCclbNmYll3MZuYprNlb0mkrYCYSxCmB2h7E?=
 =?us-ascii?Q?2188Z9lVechnG85QYLaJr5KIyjNRhEgOQR2aVe4WhZbK1jsQNC5cWHUbNwbQ?=
 =?us-ascii?Q?GRPv2FCU9SMkWBNMXCeM4gb61Pkuj5L/ZUhUYeyWFh9OiL3Yn2E9IW4ga+OI?=
 =?us-ascii?Q?LFBWeAMf01VvR4HGU3DBNATHJIXMcbEl8CwSINow8KPq6XE9KbV/wMAltYnp?=
 =?us-ascii?Q?4wXNnAJ0zObX4ZNNv3eTNlHuwAN+RyZwoJfFaMXqy2tHpjtEbwJN/GvtoTlQ?=
 =?us-ascii?Q?TiAlMsX+y3hLbTVoRpsCCB+zceCqDt27AtBCZPOdgY+t9suC0pJ2DcsQEQ2f?=
 =?us-ascii?Q?ZpFdFRI502LvB3rE3xZMm7Qm+FSCMO6yW/xrus/RPLgvLsDtAnYtxn63Hwic?=
 =?us-ascii?Q?rqGaEF3UwAdFUcILy5lUwmZA+RIVRbwpqvhkVhDGJwEN40EgjEXNMpcgTWx7?=
 =?us-ascii?Q?TR+FaxLagDDllGta9l/HD80ahgsYIpMUZljYOCs/2oaPgz2tHu4eQBRcEQF4?=
 =?us-ascii?Q?7MmRLo+jtoZ48kEb9o9/4OWNK9O2gXkaLLn6m4sBEmsk9smbewC0oUhyI1ge?=
 =?us-ascii?Q?SXI2/FKHAToW98ctuFIwdwhO8T9ydeMx3JEx9IlpYft1PHdZx4F5OXAKHAog?=
 =?us-ascii?Q?E18YUHCCqX6x+Cynnv7XCsSM0qCK7fJLzkQ2r4npUHrCltcJ0EeOsZtapV2F?=
 =?us-ascii?Q?wr4zK9p1GF0PNLTgtgXtXdVoePkq/ikayMtoAl5P0x9OjhF4sJQhQXfL1g5c?=
 =?us-ascii?Q?X0TaSBklwIzzCp+UPsPOXPxQ3Oudk05kEi5PB7y8cMGFqoYCLm+XYiA02w/v?=
 =?us-ascii?Q?+3j23VsnHmDgZIE4TJkW53OiFk9f551JeGVRGBE2yNpUWkPKljt5SlgugIoV?=
 =?us-ascii?Q?326wG0XaXJL2FWAytl8CMLAGPrASOl9C1obRfIcUeQjwAiX9TuCzA1bu/PwP?=
 =?us-ascii?Q?crMimkzLpGPi9zn4finyv9I=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <35CCDC8C8A959444B0A6A93D87BE4B05@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?wefeh4G6pQ89xZN5BOX6wlGrDwkyr3ioZWQmg9l/C8iOsGmZM0FwCcOq2x+C?=
 =?us-ascii?Q?2lQ6hW0Gkl6m77ebLGHK/1lgrb9aekPEATbnt+cJNEXvEJm2TzKU5QpqUxxI?=
 =?us-ascii?Q?fGOZp6oEznvMcyxjIdyouB5GdxWL8BJlbn0PG8trQecR5pZATWWfpm+++NG8?=
 =?us-ascii?Q?1a/CpO10PjybGbG42na/5VzPWy6qW0ROOsp0rbxhVnCpZmJ7y1C0j4XLOPHk?=
 =?us-ascii?Q?7iB0JfP9FoQfk3CmJj1Ej0HQC0Og6NT9T5cbf7Ixm9qu3afbu53ovaDWyj+l?=
 =?us-ascii?Q?FDvSQbEAcHREfCFTef4ZTUjX//kiljM4bH9JY6jUB6J3S18R5nw6U28nh+qB?=
 =?us-ascii?Q?TxwO2aenCLj1i8M1duSLV9YsGULgaFbx08pzARAAiu8HzKFGg1J+4l4ePDqq?=
 =?us-ascii?Q?vWm8AaXi4UN9mqH91tI4MI9MwTVztAx746veA+GmGk4BtAey1AuoS3Gu6mQI?=
 =?us-ascii?Q?iDMvbEQ4KTkG2bivdv8Hfco+xujz2LJTauFHzXdIJJXHWovqUdlLXHOSmo/k?=
 =?us-ascii?Q?5Z1tLg30VR/bVLAZKy/vRwQkJHMza5O925Z2iV3QQz22MzJIbOnOXjPFoXLC?=
 =?us-ascii?Q?Gacvepaivc63rDo4Y4KPB/LOFGwDtZvw7/PXtZ+Eq/ei05zgPr0z+F23sgNc?=
 =?us-ascii?Q?k1TsbQjrKz6gQh3KMLctTeX01Z9sZn/CdgxecGRelNAbNs/lgd3MhZfUk/Qo?=
 =?us-ascii?Q?pqVMBmfF4RU9hI92PqBloCXkKaybwxbWXEUWBe9fqyJuoMOo9kLUISwwkVOW?=
 =?us-ascii?Q?M+2wHrlXaedOARocvMLeBM+Q6k8nwHUUhr+IopdEXl8Ut87rC8aHq2yXmmQG?=
 =?us-ascii?Q?PtRGeGOR17Vj8JNyQ1/FC/hNFQRg+r5g+r1nPdWnxvydCMQWwBsweQksL2le?=
 =?us-ascii?Q?JWiwxzOp0A/rmGtNrCJUCreOykCBse6hH7r1kf6d5kiiW4v3WnckvQHYRjgI?=
 =?us-ascii?Q?YWdsNZUWNrk7sUIqdEjtJkT6ADWysedoCD+QsqaxEH4VJGdCRtTN/1w0nprv?=
 =?us-ascii?Q?Ox6je4wd6TSW4TDZ3fCOm/HK+1a9pbTP0wDM99fyoiiv9gE=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5433.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 97cd9655-2379-42bc-6c0e-08db94f2c5aa
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Aug 2023 13:57:42.1798
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZjNQ+RuAAQoHXfr24r5QerVPONJLooDi+Zj5S6pad2aJc6e15To/3c6YipyLjpPJgXOHoDufZWnkghDAYW2M2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6225
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-08-04_13,2023-08-03_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 adultscore=0
 phishscore=0 spamscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2308040124
X-Proofpoint-GUID: 74IbJpjqVkqJa0QliJ1Ee_kvvTHDtqHY
X-Proofpoint-ORIG-GUID: 74IbJpjqVkqJa0QliJ1Ee_kvvTHDtqHY
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
> We're still missing a handfull of HCR_EL2 trap bits. Add them.
>=20
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
> arch/arm64/include/asm/kvm_arm.h | 9 +++++++++
> 1 file changed, 9 insertions(+)
>=20
> diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kv=
m_arm.h
> index 58e5eb27da68..028049b147df 100644
> --- a/arch/arm64/include/asm/kvm_arm.h
> +++ b/arch/arm64/include/asm/kvm_arm.h
> @@ -18,10 +18,19 @@
> #define HCR_DCT (UL(1) << 57)
> #define HCR_ATA_SHIFT 56
> #define HCR_ATA (UL(1) << HCR_ATA_SHIFT)
> +#define HCR_TTLBOS (UL(1) << 55)
> +#define HCR_TTLBIS (UL(1) << 54)
> +#define HCR_ENSCXT (UL(1) << 53)
> +#define HCR_TOCU (UL(1) << 52)
> #define HCR_AMVOFFEN (UL(1) << 51)
> +#define HCR_TICAB (UL(1) << 50)
> #define HCR_TID4 (UL(1) << 49)
> #define HCR_FIEN (UL(1) << 47)
> #define HCR_FWB (UL(1) << 46)
> +#define HCR_NV2 (UL(1) << 45)
> +#define HCR_AT (UL(1) << 44)
> +#define HCR_NV1 (UL(1) << 43)
> +#define HCR_NV (UL(1) << 42)

Reviewed-by: Miguel Luis <miguel.luis@oracle.com>

Thanks
Miguel

> #define HCR_API (UL(1) << 41)
> #define HCR_APK (UL(1) << 40)
> #define HCR_TEA (UL(1) << 37)
> --=20
> 2.34.1
>=20

