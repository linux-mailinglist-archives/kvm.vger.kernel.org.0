Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC66B7703B5
	for <lists+kvm@lfdr.de>; Fri,  4 Aug 2023 16:57:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231716AbjHDO5T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Aug 2023 10:57:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229848AbjHDO5R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Aug 2023 10:57:17 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B75C949CC
        for <kvm@vger.kernel.org>; Fri,  4 Aug 2023 07:57:16 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 374EiDHQ002954;
        Fri, 4 Aug 2023 14:56:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=Wz3WAIGoLZ3lDMhTUYehp3ljffJx4pxv23CFNwSnKgY=;
 b=dfvRXT+AgM9IRuJ0WYdioVkZSDqMM3zdXK/PZwMSxF0a2Si0ckYHVgE+rgOTkZCCEHGr
 IkhpuKJOHBuFd7ms4UxnePeXn+GCRM6S4M1f8JN1zJeb9fWqVQfZMNtJ90qlQERwN80s
 PTIUVE+oddQowHwClb7Co88D8u+Nb3yH9Fi7FaNr2wQaMmf57/X+7XkhHGtIGo5ESQnq
 2dtNjstL3H3ykthjIpsJSlMqXs3djgxLTPSGPdwPFiw6sA1xp7GUxt3Tae/zgmL4rONL
 0wtydECcNzU5ffkavrGpeBlhdUIJfsQ9x7AMuJC4Jd24gYJexaH2gjxJZyWKQ3n+tyVB dg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s4spcc1j7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Aug 2023 14:56:42 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 374EkElG034978;
        Fri, 4 Aug 2023 14:56:40 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3s8m09e78v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Aug 2023 14:56:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OowuU5MbZPefEVpRgifA3B/lWR3saxErYyu+mQeXVe0PiaIf1eKhV1+5UzkO3zPy9NhKBZQBx37/i4ieZKYqAFPld+qneryrNZWcAC2VKWNl7qgKZUiOcKo3BHubuG6V5l8HuV6rA8x0yJtzcG7+W1S3t0e9X1/cdbQV+RzlaUvNb50OOl/Jxj70QVTyZzCAm0Kh9h0lxpxCULI0zQ4kojZ9o/rv4ohpL84EsPiQU2bb0JGORFJycjN9s4OqMu4/THCM0y/Ta1oyL8+0qRfJhcpTgrfuNc5X6zuUe2FEKlwbttj7Kcmm2RrCTUCRTkyQ1Rq3qHOxtCjTOJNl30hvKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wz3WAIGoLZ3lDMhTUYehp3ljffJx4pxv23CFNwSnKgY=;
 b=IuEEKxm0EXkT1gLPSw00OpfznOFHTAa9/Cjs+z3OPkixuQN5rdnRJuOJaNGfan3kXOZRYy40txHo9n5fKBraZVP/cZTcpWSI26VXOC+UMagMAKciLgP6WSfPOn8/VFuH458//Azlaje1w/CLONhN0Ue+IInfwfqYBR1+Xo3T0vXxmBTOYEiIJiTe74y+WC+SVPu47HU2wJNRwUT7mIdF7uoabX9LO7gSzDUMvkNuXJsGmLlc2IURk255O9H0qdodIyp2FQZIrLd4ik6pPLZRY99lgRI7c6ljhEQiKyT6GJvNC3g4+3PqCaUrN5aP9ZX24shO7wTSXcJ3UrgzLIbrXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wz3WAIGoLZ3lDMhTUYehp3ljffJx4pxv23CFNwSnKgY=;
 b=djBHgrI+yuJ2v47x4tLIe0tf2Iw2f6upTx/wohLol1HYLtm1jC/dxAbbgIUdZaH6E1zOmbQ/KNIYLuAZBx7+P/eGOGyhUpXduylgAJTXNWhpNNuiMu/bxPibB+QJfr7OGQxkR8lqYPWthUzFuFp7RPGDPjaogL/usMBJHNrPmLI=
Received: from PH0PR10MB5433.namprd10.prod.outlook.com (2603:10b6:510:e0::9)
 by SJ0PR10MB4720.namprd10.prod.outlook.com (2603:10b6:a03:2d7::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.20; Fri, 4 Aug
 2023 14:56:38 +0000
Received: from PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::76c:cb31:2005:d10c]) by PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::76c:cb31:2005:d10c%5]) with mapi id 15.20.6652.021; Fri, 4 Aug 2023
 14:56:38 +0000
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
Subject: Re: [PATCH v2 12/26] KVM: arm64: nv: Add FGT registers
Thread-Topic: [PATCH v2 12/26] KVM: arm64: nv: Add FGT registers
Thread-Index: AQHZwTARuPClEJLq1UmTRJRRl2VB+K/aRVCA
Date:   Fri, 4 Aug 2023 14:56:38 +0000
Message-ID: <C0ECFDAC-5AC1-43C1-8D27-244C2FCCC65D@oracle.com>
References: <20230728082952.959212-1-maz@kernel.org>
 <20230728082952.959212-13-maz@kernel.org>
In-Reply-To: <20230728082952.959212-13-maz@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR10MB5433:EE_|SJ0PR10MB4720:EE_
x-ms-office365-filtering-correlation-id: 2a187d43-19fc-4f64-f59b-08db94fb0192
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SdQOdp6st3XxvDbqy81yAsi37Y6PJsqjAWahgvpyZJmFoG2FZ14VB88Fdviq3F7/TXjiMs9fmMDb553MEl0RCOHOy9osX2EJGOkxdtKT/zaX9i6IKOQ0FRJ9wGD/iSS7+w79Q67V6gP/a8RoDiF9m0A1YwWhOUmWVVjKmlEs+/ieJKrcbuka7j9L9azLu5Uh0mOAS44oSQAAx77qClAwpUyxuGvvgUxtLlJYwz3VRTB/o47671Cbm7XK60z+e0s/1jv7qmYPwe8Pa+v24KApyHs3GtSvMDGsOu43tdLt8GOUlHU8G5M4rFKzpHSAklfX3ayPRn5UW7u65U33Jhbt8u3LOtkRD6h9SgyKxuX9IfbaLtNrlz3G68H6zvgc+YpkHYQMXPN14UR/K9Cohii02rxQK4PvqFS2+GM+dG4XN4MnFUkD3nLnwskMG1c7bmvPbs9DPCH7MaXggU5WR4/aV3k+XpWtxjkUjyL0j4l5ifO2zlW+WKFWNSUc9MwXjAwTgIYwqgSapaYw8WWEa1N3wKyoL3BBs2QZ5OK3CEqUyimyGaEcAUGN/lhDMlABBUcLFe9GePTfBBGcxffXMCHhgkRX95OYp+41sAwpLH3NGi9lKkV0ifmnNCEaK3appeOs9CAx22W/Uk51XQz96g62Zg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5433.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(346002)(366004)(396003)(136003)(376002)(451199021)(1800799003)(186006)(41300700001)(8936002)(8676002)(83380400001)(53546011)(6506007)(86362001)(2616005)(38100700002)(122000001)(38070700005)(316002)(6512007)(478600001)(66446008)(6486002)(54906003)(6916009)(71200400001)(91956017)(33656002)(36756003)(4326008)(64756008)(76116006)(2906002)(66476007)(5660300002)(66946007)(66556008)(44832011)(7416002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?+ivmwDhASlQhyV78oDVj7NXTurqd6swCNIPrrA3IQTG7b4x0zkLCUTz4ogbs?=
 =?us-ascii?Q?MLmRiTogAY14moIoo3IcF5ALeirF/lfDl7C0XwkIK5J8za3SjFQWCIZP+ME7?=
 =?us-ascii?Q?zUKqxmu6zXROpdqslKqvC1PnA1xcVZnhzcXWQB/RTzGP6aXnbXvo2FmNtzWQ?=
 =?us-ascii?Q?BFQGIvamBIIZznz/dy22IzwOg/rcMzlL9WYXmlxHxOB/P9ZJZcL8fbl3wSFp?=
 =?us-ascii?Q?b+Hj2P4/yeLIsnsa6djzLlgfY/AP/OF9U/PQeaqzO0pHFdCAcnJ/dqNh/TUz?=
 =?us-ascii?Q?5WAkL4IKoJNL7TOxjeXo9miNmO/MsIlLEfpsmnuNB/El3hsw+fPxm4PX/agx?=
 =?us-ascii?Q?xa9z1euuJIjwBOjIQK5c+nhQwo6FFa/Gcz0lyggjN0sOjOfKfrrlkGGcqgFv?=
 =?us-ascii?Q?gwbw6wrgv82ZTYt9ewyoL0K8aNaVyhBe98g98Xf0O6mMyzfWVah3p1Lr7TIB?=
 =?us-ascii?Q?V3Xq0HdQ9YZLJbE0sCutO2ymKeh/W1eEEXqWAdU7QZtRl6+jYZruKqQwtunm?=
 =?us-ascii?Q?d6YXSWwBN6qyDfUMbzuU4Fvr7Dtfgr1/w6OMJuh12yvCEVfdpnvUhZs6Dez3?=
 =?us-ascii?Q?9RLWDGQJJqss3yd0/N15DI9bStankBOI4QnziWWLwM+TGw91BiD6lxhLC8wl?=
 =?us-ascii?Q?mO85iab5+Yc760d30A7fRyFnK88GurtJ7zJlAyE/rwZAbCQJvlSvyLQYxMss?=
 =?us-ascii?Q?JHuiGdmHPKB5igQyxAlx2TXL+f9z8je8qkoaN6aCbSLshHD+vHJnMHdu1KYK?=
 =?us-ascii?Q?M4ht5I7OhnmCr7PrYrcl0cH2VS5OzNVKVYSpm80qbMPoHX2A6x7+wmh7qQl5?=
 =?us-ascii?Q?UsFZURqLOdnsbthGbTGQkGjqeUvJ5w66bYP+Q6cof/uf9JSLnwFMhW8wnif9?=
 =?us-ascii?Q?axOx+/837m2SVvw8SKSH4ak3GcPGPZ9gxR7dkALEoXVwshPjd3DYnpoqtUgE?=
 =?us-ascii?Q?lmvckJMqnWEuB2/QMqPB1Fgz8u/kNpq9xGyYSbZn6MTIqlGSTucQrdLy3xCv?=
 =?us-ascii?Q?eXVgQcexr3FieQc9WR+t0TaE571HcHWKR6EFitWxdh6pKzAmA49aGbQ1/9Il?=
 =?us-ascii?Q?Ahz+Wfm2mmLDKJdvuNkI8A11l+bIh4EpN1r1iBEvyG6ZsE2vCDAqfUz+PhrE?=
 =?us-ascii?Q?aGBZIWEWewTB+4zLHAsl6QSGsL0qtkLEMl4HhAbQchfxxZn60WCgTY3cshDU?=
 =?us-ascii?Q?GlDO7j/EOJc9M6fUfiyIABCFBHbwHimDxsSZQINe3I90NRIrqnOmF9VCXzil?=
 =?us-ascii?Q?NgQqG/sMx4wv+8tIVzXYiih62Of0Go47FXAQuQSC/zKyZ1/ZW9YHCMhDAh85?=
 =?us-ascii?Q?jATBNuOBIQkm1ey5+VEIuBM9ytfmTxGsPnYNJekyr+ROzP5YmRyTpTOZxU+z?=
 =?us-ascii?Q?1XwSMBlxF3Kp8sITjYjvfNgsBQftVD5rqCFQTGtuu6G5a0sck/MTqJFRX3DP?=
 =?us-ascii?Q?QfF/+id2iRTxDJqjPhMz1KI4k7OIP/HVhHEuffKgs6dpNHI5rC8Hwrk8VbMa?=
 =?us-ascii?Q?4LO2cpieclVAc53c6Ufn2MuzLik/bB0k5B+PeDEwbNdDpZnI2Wex10SKWuuk?=
 =?us-ascii?Q?JqO3S0CP3QP9haHvrw/jI/v3RTqabUCG+LvOcJlpTCLp8XLKTXjyUTfNaVec?=
 =?us-ascii?Q?HD/QDLj6DehrttVKfFGwQPc=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B4A26D31EB95A945BDC671A091AE9DB0@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?PhBBo/MluDTPGNwxhW84O0xpVpQta4YIjIyX9S76m4KMX9sYjU3UKGtGZnmy?=
 =?us-ascii?Q?1aODAZG26npRi393/FgaApRc3pqtVXnO/mclydoC1Pta+60aE6LT4MM7SLl9?=
 =?us-ascii?Q?FHjct2vsAVBo7KUgT6pV5ZHkemZ3OISKLuawLymjQejptm03R7tWRwNvQu/Q?=
 =?us-ascii?Q?hn5Cc8txj5TP9pkxBBJBnitjcea0WJ7odX99jVurXhDTexA57nfnOrLAdNJC?=
 =?us-ascii?Q?HhMOZVdqNxa/PzCgo+Tcm6RrJ1tvQ52Nbi2jkIxQjlNz8ydGYD4cgpgAwOS2?=
 =?us-ascii?Q?856FggjysLbG1WBMlT+IjAyoO44+InhtwVxroApZESQfyIy4QjUKWo7ukZWA?=
 =?us-ascii?Q?2YP88awKO/tvjqPLjp9bmXyLVXF2Em2Wf0BnEL4N/YPcwrWft3CUWm6/9HkN?=
 =?us-ascii?Q?zzUPMCtsNvNao/Y9jaYbZ3JnKhiXT4dOT8iROUAN7+hvrZs9JD/7pckyy7uE?=
 =?us-ascii?Q?K9/SjckdnlqLsKwnKmyIcIRdKokp1wghNlqQ9vLrOiCGubHKAhEnzG4vl2fl?=
 =?us-ascii?Q?ePvrVk05N3wTRpLVfOZN1mfHFbbkltEUMLadEspuDs9utG38GcSM6txLJoOr?=
 =?us-ascii?Q?/BwFicAGJz0t9r2j6tnmeoz5MxSSYcdcFVG09sOKHh6DZmF2hdGJ/oF0o3xD?=
 =?us-ascii?Q?8I7XBAsV+1y/ny/iDXaGO2+xux4Ue/K2JQ8s1qLncRfifBKbLEcWZTr4xHUZ?=
 =?us-ascii?Q?+qfOnsRPYPRRfBpZ8BsvOcnevS4ZBW/xlfuGrWt1h57BTBE+acEvx2O6xrk/?=
 =?us-ascii?Q?GInuuPruN87zJm8WwgNLxVxClqQu4xtDW4in9YdidtXcbrHEf9rCIDW5onKf?=
 =?us-ascii?Q?IMcMOeyYkwKmnDmoYYd42uOKgazwaPaSPgUk8Q7xXaCJU6RXfAnr8nop/q5L?=
 =?us-ascii?Q?7YAPJfAf3VQgY4e7dDmLfqFF8s4Q8HHk6XtXw8VeHDSdIyR5ZDnpUUad6fu+?=
 =?us-ascii?Q?UOpWBM5BbDt7q60/xxKpsv+6+BTEMPze2U0rsby3T0fGltrcZYlKf/ltHS3M?=
 =?us-ascii?Q?Q9U3/qZlzCUjbqV4uZR+k3Ken+NDAQdTCN+rJgJCqffPoa0=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5433.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a187d43-19fc-4f64-f59b-08db94fb0192
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Aug 2023 14:56:38.6877
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: M8yCQGCflBJUGlWHtqEOO4thKF3QSNbds8/RCPEUyBsvfxWbu1unT8NKaf4mc1uq2u1yw67jUaVmZj3UJ9zxPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4720
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-08-04_14,2023-08-03_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 bulkscore=0 suspectscore=0 mlxlogscore=999 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2308040133
X-Proofpoint-ORIG-GUID: CPIiQ2JAI_rgXJ_1bxEdIjYiP7Vtcv2I
X-Proofpoint-GUID: CPIiQ2JAI_rgXJ_1bxEdIjYiP7Vtcv2I
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
> Add the 5 registers covering FEAT_FGT. The AMU-related registers
> are currently left out as we don't have a plan for them. Yet.
>=20
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
> arch/arm64/include/asm/kvm_host.h | 5 +++++
> arch/arm64/kvm/sys_regs.c         | 5 +++++
> 2 files changed, 10 insertions(+)
>=20
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/k=
vm_host.h
> index d3dd05bbfe23..721680da1011 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -400,6 +400,11 @@ enum vcpu_sysreg {
> TPIDR_EL2, /* EL2 Software Thread ID Register */
> CNTHCTL_EL2, /* Counter-timer Hypervisor Control register */
> SP_EL2, /* EL2 Stack Pointer */
> + HFGRTR_EL2,
> + HFGWTR_EL2,
> + HFGITR_EL2,
> + HDFGRTR_EL2,
> + HDFGWTR_EL2,
> CNTHP_CTL_EL2,
> CNTHP_CVAL_EL2,
> CNTHV_CTL_EL2,
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 38f221f9fc98..f5baaa508926 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -2367,6 +2367,9 @@ static const struct sys_reg_desc sys_reg_descs[] =
=3D {
> EL2_REG(MDCR_EL2, access_rw, reset_val, 0),
> EL2_REG(CPTR_EL2, access_rw, reset_val, CPTR_NVHE_EL2_RES1),
> EL2_REG(HSTR_EL2, access_rw, reset_val, 0),
> + EL2_REG(HFGRTR_EL2, access_rw, reset_val, 0),
> + EL2_REG(HFGWTR_EL2, access_rw, reset_val, 0),
> + EL2_REG(HFGITR_EL2, access_rw, reset_val, 0),
> EL2_REG(HACR_EL2, access_rw, reset_val, 0),
>=20
> EL2_REG(TTBR0_EL2, access_rw, reset_val, 0),
> @@ -2376,6 +2379,8 @@ static const struct sys_reg_desc sys_reg_descs[] =
=3D {
> EL2_REG(VTCR_EL2, access_rw, reset_val, 0),
>=20
> { SYS_DESC(SYS_DACR32_EL2), NULL, reset_unknown, DACR32_EL2 },
> + EL2_REG(HDFGRTR_EL2, access_rw, reset_val, 0),
> + EL2_REG(HDFGWTR_EL2, access_rw, reset_val, 0),

Reviewed-by: Miguel Luis <miguel.luis@oracle.com>

Thanks
Miguel

> EL2_REG(SPSR_EL2, access_rw, reset_val, 0),
> EL2_REG(ELR_EL2, access_rw, reset_val, 0),
> { SYS_DESC(SYS_SP_EL1), access_sp_el1},
> --=20
> 2.34.1
>=20

