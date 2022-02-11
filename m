Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FE364B2A7F
	for <lists+kvm@lfdr.de>; Fri, 11 Feb 2022 17:37:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351573AbiBKQf5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Feb 2022 11:35:57 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351571AbiBKQf4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Feb 2022 11:35:56 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FE23D68
        for <kvm@vger.kernel.org>; Fri, 11 Feb 2022 08:35:55 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21BG16Rs015547;
        Fri, 11 Feb 2022 16:35:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=G59eiw/pguJV/zloenhhZdWLlS8NFANpUCp7nRRaGuI=;
 b=ne/ekrwk1qzO2i3HAFrHwP7Oi9f2pgKCn3J2HmGOzK/pZb4oD3cG3797xfC6VEhR6JWU
 BMxZ4XmyvMzCue8tVjPjGFoLmX4SGxNW1CAEu1IaxK+zUkum8Rkn4aAhRtWEKs/hF5kk
 yqXOSuyc4fVf1/V6qxo/3/dQRX7EyKLB3ZwxEZlGFEKzBWmIL9k8c9RD7yo5Xmk0KaQK
 uQKnAIHiKpMegBNMqUmelsjg/Dj5tumBGfRBZvz86hmxyWcmTI9sYJEor0wVNBHjMabr
 q37ScB5CbKedZa7Ch6NH4YwXtoJg7aNF4ZaY5sjTeLJu85mfosgonrZvMRZavTiyc7Ts bA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e5g989h2r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Feb 2022 16:35:18 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21BGGO3L112895;
        Fri, 11 Feb 2022 16:35:17 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
        by userp3020.oracle.com with ESMTP id 3e1jpy2p8h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Feb 2022 16:35:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KgQtZTQS03hmoiUWOQDPjeFYbxynlXiZZWQkeNmFXWzHHRPcYq+HLy1+JOXpA9+j9xYLiOTbLypVWxIWLmP8rtZFvD6a58RSVW9YjaBY08KtUlERHjvLQbOoikT03fySoqOW9i7BFBxxnD3WJb0Eu9Dwn9xvtN9g4YdY/dxzWiRfZYmKDiv4Pe3agjp3VUTjDF4ubqb7BYt0fUQZMXptnz97+asZ5XFabV2+jP4ZRi8Pi37v+lk+CDw87GJeQuf5y5ZnfIGkxTcjYANKU91O4iwW6cZaFtKQeCYL4AEjWNX8LG4IQXUdXAobNnO4qOfD8J+bPYk5xUmdE+1niFB9AQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G59eiw/pguJV/zloenhhZdWLlS8NFANpUCp7nRRaGuI=;
 b=VmXx5rS0yM27Kf2bdsRMVaqfygB8ErJCEyA5tgq2yEuIlaAN4DYfPHNOnPWgUL0f14cJnGHwZc/szHsIAShdkRRy0YLRtWQn6skkQvAfHCz5JzAT3FQ9KFuyi25vQaCx0iA8vTJ0WmdQsAK/xxslOdGR4S82xMGnBnpY8O3XU+2inZrCRxjWfGidia0x+MVkBmQBfwFAZcuVemaX07JZ75kcZQ5yEJy7/C+E6aTdaMXPJGmaAr7lfSvPLWV86iDExjc+seR0ahgglwruQWPQjqTHwQKbNGJoNqKxqCkOAA9/jkqZB4YPlveNUtgtmCopJqn7tslRNOzOLocMJEDhSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G59eiw/pguJV/zloenhhZdWLlS8NFANpUCp7nRRaGuI=;
 b=fdGF6s2r9F+l+iNDjr0BXIPG4DKs+qwsVHSNnfZNz7/yQCF1k3N/4+7udjEO8/RQh87FBi1mo1zAtzAEA8LQMAweuEGXE/w51CNJGj2yOFGxdb2vczCoDqyMcJB1diblgbPgKEOiyl/jB4pI5jjUpsSDDgqchv6Ani4N/ezCyok=
Received: from PH0PR10MB5433.namprd10.prod.outlook.com (2603:10b6:510:e0::9)
 by DM6PR10MB3995.namprd10.prod.outlook.com (2603:10b6:5:1fa::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Fri, 11 Feb
 2022 16:35:13 +0000
Received: from PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::3010:9c9e:e9d4:a6ab]) by PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::3010:9c9e:e9d4:a6ab%4]) with mapi id 15.20.4975.011; Fri, 11 Feb 2022
 16:35:13 +0000
From:   Miguel Luis <miguel.luis@oracle.com>
To:     Marc Zyngier <maz@kernel.org>
CC:     "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Haibo Xu <haibo.xu@linaro.org>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Chase Conklin <chase.conklin@arm.com>,
        "Russell King (Oracle)" <linux@armlinux.org.uk>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Karl Heubaum <karl.heubaum@oracle.com>,
        Mihai Carabas <mihai.carabas@oracle.com>,
        "kernel-team@android.com" <kernel-team@android.com>
Subject: Re: [PATCH v6 05/64] KVM: arm64: nv: Add EL2 system registers to vcpu
 context
Thread-Topic: [PATCH v6 05/64] KVM: arm64: nv: Add EL2 system registers to
 vcpu context
Thread-Index: AQHYFEFOwGH/a/x0ek6lUNd0w6xrFKyOoikA
Date:   Fri, 11 Feb 2022 16:35:12 +0000
Message-ID: <9FB6A1EB-6A7B-4DDF-A676-7C24FB64A0CC@oracle.com>
References: <20220128121912.509006-1-maz@kernel.org>
 <20220128121912.509006-6-maz@kernel.org>
In-Reply-To: <20220128121912.509006-6-maz@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: acebb263-70c5-4369-6760-08d9ed7c7a23
x-ms-traffictypediagnostic: DM6PR10MB3995:EE_
x-microsoft-antispam-prvs: <DM6PR10MB3995D76D75410E9FD482C23E91309@DM6PR10MB3995.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TLSmOjx16HkzfbEYw4Ty4JGinM+EAUS3Ps0/S46oEshtTrAJaoe1amRyGKd6k9I7AW21Tdx0AS25ovO/opgneeOamviHAL9VnrtLPv3TFTygLXAEcrUXJ4Q5WC6ICTdQndZ0QSaPLXWKMeVveJSOInNiajspRP/k852/xgpFmVdM8lG/Wz2WbVk07CLhLpviGyl0kC1+cuYpn1Q+b+LWDhpVtkeyAuuK4qO0HR4cli8OqJWbdn74HiwXVbKRrKe0GbTYljXI6Liw4/ixUtccalziYknMrukMgq0qbpHwZRz2bxTLFvGTHcsEUbZ3mGC/09bGoiJ3JeUuPgRBLS8a+mcuAqKbuyn5N88LYJ2VpFgXarx9TOEbBSjDOtzrN1JrtgjxEARiu8BJXUcMbE7S2K21AVBASjtr7B6BXATUD5dlBmxYyTXCm/UWEU4KIDOsIRyOSyht5xoy9W6JuV43kEFYY9BMOIA8maC+BmSKwgKlj9JOLdrxqSajqmsTaTIh4uWVcKKNwf/6g4ZqCZc3mGVGfNsvWiWoYyP/sBn+1iXzQhCghNJb7A5b+MC+Kj3FYzuVxU72j4Nar0ZhQ+jDza0UAF4xb5MKnv27E0zqFyFcXXHMD5iMnrLSpMuHzs8w8sFVchHTV/V8me6q2hQFPtWiCeMwDJBOm+A4+cG1EebDyF0faoprlbpabCs7JGyApYfkQxbqvL+N93V9z19DU6ABDo24i62dXyU+4EjyR2Y=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5433.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(33656002)(44832011)(2616005)(6506007)(64756008)(5660300002)(2906002)(7416002)(6512007)(66446008)(91956017)(8676002)(8936002)(4326008)(66556008)(66476007)(66946007)(53546011)(71200400001)(38070700005)(76116006)(186003)(316002)(83380400001)(6486002)(38100700002)(508600001)(122000001)(6916009)(36756003)(86362001)(54906003)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?u2OalZQjewTdJhrYJOgvdrh7p4urwmAZJWYQTXPwz3ESCKwWQs4DFtlDZ52g?=
 =?us-ascii?Q?iqC08cMZVlbqY25kRuj4qFiRPnBiRj0p7589Zp+x8sIwPMjSgUCCs1kV/ni2?=
 =?us-ascii?Q?sy3sUT4//zZPU90aHAvNbS2A8Z3p9GTSQDIEr/IEzCks3q9+1d5gjrSc26eq?=
 =?us-ascii?Q?W8zlzqE1tMp5GqikJkim+U1T5U1eCLsoIAMbYknQJjJbf+XAWk3VkNzwQXQ6?=
 =?us-ascii?Q?yGCvgqKnczaekOpnPuIMHcm0wNhZVBYDhXQRyNyIl48eykntcqf6qBEu1DhG?=
 =?us-ascii?Q?E3B6E5nqQWtSS/IdpgNYmC12o7DhBiIu0/b78fibIYIvlLsIaJoTyyelABCc?=
 =?us-ascii?Q?I4k+9uX8fe9CviYSVcKfvvO8Hg84xznuHdBcsdB8WBR/6CNilK+bHmpG07H7?=
 =?us-ascii?Q?wkjL2ocGStdwXo8sfr+FLTRVdMPzGyp1LDanFdUclgMNbmOHMmgtateKVloE?=
 =?us-ascii?Q?VCzW9gdIzGaJSZHcVzTQP8kMXfuztIR1I82mNyVrOSJLcwkR4b+e1XaumA9M?=
 =?us-ascii?Q?i9O1Qnv0efdi7cc5C3bjyHYjTht7M8C6dxw5nMBQejJPzUyqds35UrtOCeyy?=
 =?us-ascii?Q?Mpwx3jsU2DUT4IFoxmzPQNZrvsYF1Bdoiuh92AWJIpqSBORNhtoEn668ys5p?=
 =?us-ascii?Q?DcfDTZWCnx0yPQ9MVuu8ZM0buvezwMB6Wcg1T/3ZtboMysyKOIi0NWsCosR5?=
 =?us-ascii?Q?HvfTZhakQ1DaIq9rGByqiBNIzwjOHeqd0rRKScHxKUT+2X537ohGzMhkVwQg?=
 =?us-ascii?Q?b5sNxRMmsXc8Q9TYLb1jr2HCtHWUCeQpMMRVjSEc5KGdjRB2xyGsJAH5YO+U?=
 =?us-ascii?Q?p9jhlvRmBXM8Jwy5TvXXhj4noT27dh2JQbCnzZ/+4OqvDUqtbE+746VePi+N?=
 =?us-ascii?Q?n0v4SaolFluPXmbs7pUjT4FPdQClR/0mqf8M8xvH0LR5puADPdhOB5DgflDz?=
 =?us-ascii?Q?apB+9P1tKwzLeqMA+E6lvDKdUo+mcg7QZybOea+gJOCYuxfpU9miKpFetq8d?=
 =?us-ascii?Q?kqHh5Q6ccOfvxNxAJED9Z2N9Eux5K26fs+93Kezg4SdZISv3HNmE7iY++3ph?=
 =?us-ascii?Q?W33oxL9ryfrEgFGGgqLoxFpghg/UKEdVUWoFt6XfV8ridiFZnF0NTdmOBkHM?=
 =?us-ascii?Q?L0nikwaJ0ZHuJhfcthASHtl8T/xETYyoKofDkdZzEi4HQVPA4zmEeC3g98FD?=
 =?us-ascii?Q?hasAQAKznIzxi2xWWaZmiBehnSg99p5lYRIfMKcReEnKuDQ/gv11yz6N4hnT?=
 =?us-ascii?Q?c7Rjoi5k0m5kozk35CNpgvW3C2jrJ16EwW8f9GepIpeEIzpQhdRgqz0OYBZJ?=
 =?us-ascii?Q?fpoEd93xAAJzBdIY2lMTF0VjPGokEmNvu3kHyBTb6dOYPRXOxWS0xT/PxQZN?=
 =?us-ascii?Q?6lv1vtV1xo76dwBYROUfwPPG0yiGqlzGprjPt06RpSVabYaABx6T7olMJ/dL?=
 =?us-ascii?Q?/X2Eki7pFRRwXigHTcNDe4sAH2NvhjwpDR2jMyQRloNMI3+CkTqMa1s7T4//?=
 =?us-ascii?Q?DNdpwcs+8G6A/vshnlwj4Q/AGHOavHExf17ngC3FOFN1BTWXqedykel3bSEw?=
 =?us-ascii?Q?k9dslXEQpjaNfcVsBLwH7mp4XFlbGyAfpGdlrHWAJA6llB8oIFdwflLpys3m?=
 =?us-ascii?Q?arGVawEOo51yDPe0Qci5+lmRJTn7iQ96TNJxVJcIe+Cjk/dcuWiyiF0uUlYg?=
 =?us-ascii?Q?xI2HFr8xM38pI+/GSnoZjfByNiI=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D3A68567EE81FF4F830D51A373166F8B@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5433.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: acebb263-70c5-4369-6760-08d9ed7c7a23
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Feb 2022 16:35:12.9410
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3XY4TedibE1rMjbW6qxUfJJ0NuHlsDBOhveFcH9iI5n3V/uyH9YYj9bJlz12hhJ8pNynSGEGt5bdvj97k13HpA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3995
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10254 signatures=673431
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 bulkscore=0
 malwarescore=0 suspectscore=0 phishscore=0 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202110089
X-Proofpoint-GUID: DVdIpSo_FEA2ZJyeZ0iXKdSvp4m3IXcW
X-Proofpoint-ORIG-GUID: DVdIpSo_FEA2ZJyeZ0iXKdSvp4m3IXcW
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

> On 28 Jan 2022, at 11:18, Marc Zyngier <maz@kernel.org> wrote:
>=20
> Add the minimal set of EL2 system registers to the vcpu context.
> Nothing uses them just yet.
>=20
> Reviewed-by: Andre Przywara <andre.przywara@arm.com>
> Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
> arch/arm64/include/asm/kvm_host.h | 33 ++++++++++++++++++++++++++++++-
> 1 file changed, 32 insertions(+), 1 deletion(-)
>=20
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/k=
vm_host.h
> index 115e0e2caf9a..15f690c27baf 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -220,12 +220,43 @@ enum vcpu_sysreg {
> 	TFSR_EL1,	/* Tag Fault Status Register (EL1) */
> 	TFSRE0_EL1,	/* Tag Fault Status Register (EL0) */
>=20
> -	/* 32bit specific registers. Keep them at the end of the range */
> +	/* 32bit specific registers. */
> 	DACR32_EL2,	/* Domain Access Control Register */
> 	IFSR32_EL2,	/* Instruction Fault Status Register */
> 	FPEXC32_EL2,	/* Floating-Point Exception Control Register */
> 	DBGVCR32_EL2,	/* Debug Vector Catch Register */
>=20
> +	/* EL2 registers */
> +	VPIDR_EL2,	/* Virtualization Processor ID Register */
> +	VMPIDR_EL2,	/* Virtualization Multiprocessor ID Register */
> +	SCTLR_EL2,	/* System Control Register (EL2) */
> +	ACTLR_EL2,	/* Auxiliary Control Register (EL2) */
> +	HCR_EL2,	/* Hypervisor Configuration Register */
> +	MDCR_EL2,	/* Monitor Debug Configuration Register (EL2) */
> +	CPTR_EL2,	/* Architectural Feature Trap Register (EL2) */
> +	HSTR_EL2,	/* Hypervisor System Trap Register */
> +	HACR_EL2,	/* Hypervisor Auxiliary Control Register */
> +	TTBR0_EL2,	/* Translation Table Base Register 0 (EL2) */
> +	TTBR1_EL2,	/* Translation Table Base Register 1 (EL2) */
> +	TCR_EL2,	/* Translation Control Register (EL2) */
> +	VTTBR_EL2,	/* Virtualization Translation Table Base Register */
> +	VTCR_EL2,	/* Virtualization Translation Control Register */
> +	SPSR_EL2,	/* EL2 saved program status register */
> +	ELR_EL2,	/* EL2 exception link register */
> +	AFSR0_EL2,	/* Auxiliary Fault Status Register 0 (EL2) */
> +	AFSR1_EL2,	/* Auxiliary Fault Status Register 1 (EL2) */
> +	ESR_EL2,	/* Exception Syndrome Register (EL2) */
> +	FAR_EL2,	/* Hypervisor IPA Fault Address Register */

The comment for the FAR_EL2 register seems incorrect. As per D13.2.41
FAR_EL2, Fault Address Register (EL2).

Miguel

