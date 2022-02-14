Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2715A4B5058
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 13:40:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240860AbiBNMj4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 07:39:56 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229718AbiBNMjz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 07:39:55 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39EC44A90B
        for <kvm@vger.kernel.org>; Mon, 14 Feb 2022 04:39:48 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21EB5gvl003692;
        Mon, 14 Feb 2022 12:39:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=m8DZKp7RrG5AVXm8wy2phZIl5LvyoqoTzioQ3yDtl1s=;
 b=w91i93mlAbYrK3D4YwEAhoLFh9mJrAAborZrPzbSQ+I1V70i7VrIUMvS+FwIgL/4kx6E
 gbFfrbnrHRBP+W+ENyWbW/JfgcEhFbKB8zNpDT3uQa1J33s5M1Yk6eoKl1vbPxNR0nF6
 YQYX/1jZ43rdZ7RB718HKVDG7Rl12062mR6GasAS7RtD4G2TgTN7E/8tPI9UxynA+6aj
 PpStIwhPFy/G8lovRnGt2K7+0SW081VfFATrqiBMQBmZKNLnzwgv9iZZRdqWKYzuUBdH
 IS48nWXWBXVhHo6wP69cCxMTZ61AUqqB6O3E5MBw0rNoWhJDU+BqZ/GFqAZ2UHcMB8Ms Vg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e63ad4b7c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Feb 2022 12:39:11 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21ECUfe5135005;
        Mon, 14 Feb 2022 12:39:10 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2103.outbound.protection.outlook.com [104.47.58.103])
        by userp3030.oracle.com with ESMTP id 3e620vw8yv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Feb 2022 12:39:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nayednLvwaal5kEojgNlV2dEWnrAUkndvU81z3WuMvpakQ/eD+CP8UyzG3dy0qHKhZR17ZXXT52llhZdDYFW1C474YXUaF42/SSTzFXyvnwPuhtOyH1hXpdnO753RQuBdbHikOmbr744JmLfz8qGYXC50j/bjtKyxXq3pylO1ADuDHaMglvUCCYYoNDu8oDVZQLVoQf802PPaZs4043KddO4/F7or6TdFaWZZC26SF6ACootCusU5taxpO61/PRjb1XqeVjCccnV8XFu3iMTN1hZckx/Wd+xdXesgzvtVrq/qh50CwYyTR3fddxYH1nt8pORZvrwda4HT7y7m6SLOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m8DZKp7RrG5AVXm8wy2phZIl5LvyoqoTzioQ3yDtl1s=;
 b=TtouQ3o3IWBEH7aaVIYtni0m9QJVD7oYdNizhbFbFfAwVoQ2sPQ8msKRPsjjC1eYSkWzo6hQYWHETHUpcwv4VzuQjLxRb026mAWnZucjFaBwies7TOGbozyos6UOqk5nN2w2oMm6oQBDE0t8zuPCq7MAKUnY359ODmTBJkogJAPrlD0JykZOUfdOB+JrJovTXoDSchaozZF3NCqFrz/gANvt9Qz9jeTR73RmINgzI3EkX5Gnejp71abChBwxWdjKU2mZoOCuiYD6Mz6PsVjwiA4w+1bw0AJVLzZFbbJpW1QRv3SqfVEkx1ezafbn9nOzlKs8b76B+LTTp0i430jGNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m8DZKp7RrG5AVXm8wy2phZIl5LvyoqoTzioQ3yDtl1s=;
 b=ye1BWmQMvw+9t7r+nOJJfQyIr7Z+keRhP7F8+g8AqjVBRdg/R1sWirmc0iEzkO1+QgX7aZqXEEQME987w8zb7+uFF4Bfx/Ho7W+zwKz6DiYWaDj+zEnZUPUjqj3U1BW0DoWwD5ZeVko1OeIwNgpqv1K8d6JmkpLBotI+RuxpzJk=
Received: from PH0PR10MB5433.namprd10.prod.outlook.com (2603:10b6:510:e0::9)
 by BN8PR10MB3603.namprd10.prod.outlook.com (2603:10b6:408:b9::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.12; Mon, 14 Feb
 2022 12:39:08 +0000
Received: from PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::3010:9c9e:e9d4:a6ab]) by PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::3010:9c9e:e9d4:a6ab%4]) with mapi id 15.20.4975.019; Mon, 14 Feb 2022
 12:39:06 +0000
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
Subject: Re: [PATCH v6 06/64] KVM: arm64: nv: Add nested virt VCPU primitives
 for vEL2 VCPU state
Thread-Topic: [PATCH v6 06/64] KVM: arm64: nv: Add nested virt VCPU primitives
 for vEL2 VCPU state
Thread-Index: AQHYFEFOCTNNdqyqr02nPKJycKECW6yTFzGA
Date:   Mon, 14 Feb 2022 12:39:06 +0000
Message-ID: <9724047B-0890-4C23-95CF-3AD553C4C63D@oracle.com>
References: <20220128121912.509006-1-maz@kernel.org>
 <20220128121912.509006-7-maz@kernel.org>
In-Reply-To: <20220128121912.509006-7-maz@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ac7060ab-8790-4cf1-63f8-08d9efb6fd63
x-ms-traffictypediagnostic: BN8PR10MB3603:EE_
x-microsoft-antispam-prvs: <BN8PR10MB3603B3188AEA6587493FF8AA91339@BN8PR10MB3603.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cGG3ggj0GO/yxe7kF2+r3hBqczFKUv/LmY06DJInI/VAuHB6EtskbxsINik0/KSJcqX51L5hPVQq82B3nBBjnMul91BCk3Zq16jMth8Jqkh+AfDw9rPdWWzQ9dpvBNBiFxGXCgyTERcpWhHPoWHABjPCn/uoy3DNbUdSN13sOBllbosEIXXPXNZDHEvn5MCGA/Edhxx/ztu7nSf/KGspVXYya5XgqAipTzjIqt7t3QH9J07dlHh6kn33jftmq4WCHSX2d0qoEc0QCXAmI2arp2RdX5bE/XgmUS3iXBHQ7fbWO7QivWvVN7o3qSR2Pf4ROB8kHhZxcUrocFt00aCAFMCMRQS0DMZALQGyGRPf92gpD5zhLWvbOJBVaF+ixS3HlrTfdGto6tlqjudU5fcMfLHL3T+cXPY3czBySfeZVGLke0BZo33phTwfNjaOdeqVPleaeZkh4mAkjg1i5+HIX5tVBunXS4H+WxS9HCZxBJAojADrznc+jPivBXdd/sUyN3S2dYxatBZaWUlSlliTRJRgudmFfOgLwTRW19zrpoCbGYCv86rANv84kPTL2tNfna3GEV6ZiV4SEs8/vDzkDIXMyaleGM2R9ZQsAzmibxgKrbpQ87hA69NkfKDCRHw2/YvCeJtznI56EFpuuJroBMll4J6/u+Z/C8I/N5E2YOKxcLKgiGhknWKWhk9n2YD2XHi0k39SS619Eyn9i8rmjO+H5vwlWfNV5U0008vJww4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5433.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(33656002)(2906002)(508600001)(71200400001)(6486002)(44832011)(7416002)(5660300002)(36756003)(38100700002)(38070700005)(316002)(66946007)(66476007)(76116006)(86362001)(4326008)(66556008)(8676002)(8936002)(66446008)(91956017)(64756008)(54906003)(6512007)(122000001)(2616005)(186003)(6916009)(6506007)(53546011)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?iPeWqZQnhGeum4lNzAwH3wFVny7rAq/cNlQeLAJSDpsFV/AsBdu1CHdDVH2z?=
 =?us-ascii?Q?bbiDHmgxP9AlmJ3VizlJrxhdRzs/FZynFJtX7kcuarU6qjImqtXjdTCYqmmq?=
 =?us-ascii?Q?27hpctM/GYOgvtafRe5E1PkfkhVT/5V52yYCUfuupUbTSjN0yEpdkUS+IQQr?=
 =?us-ascii?Q?PI4ybWNDGU1nF4+ebl6pSllUY/Tj8o1rNCMwIcHKkGPAwmMY46s4Mr1RY8XF?=
 =?us-ascii?Q?WeKMQK70lBvezg208rLBkNoxzNLiyqjBc/rFTKpO3owbWIZX9nroH01HLAtF?=
 =?us-ascii?Q?8tscZPk/WpmeLAJU4HwiSN5BJ1jSmNg+YvwevMt1A8JnuNvg2U8Cca1ERPam?=
 =?us-ascii?Q?2elyX8YT+C9MTP6nuqkiBzavtEzp8udhrDHSHZkKfMaLOL8jFnBKoXdlh1A8?=
 =?us-ascii?Q?k0UIu/dDx49pKM1VnyDzUXu3pAh3ZsQOmyzIwPJVcplvZdYNIVWXkxxJfnsK?=
 =?us-ascii?Q?WkS/RZ1sPwPwEw7ea7MODrQF0vzo+7U3/3ybhlxMx4ZgBDLxPX+NHYpmcO+p?=
 =?us-ascii?Q?KoTaJ9PCtQ35x9t2mDqbfvHKwkb4vit+XC/G/M9cYjP5XwfcWDWb0wbxcaeh?=
 =?us-ascii?Q?5fp0gmVKeEcS66OhoRkSdf9RoaOg1moDrCGBHKaZVSfU4YbKjiWVWmtoC5oq?=
 =?us-ascii?Q?/ig5g+jk7l+Fx5OTAyUUb6c5Vwu7z0PIkh1zIBbB6T8Y1OnChJiy4fEgRjR0?=
 =?us-ascii?Q?f6aQV5398JxGEl7Gv0wMcPBmOr25KgTGe5dcTUN9DWYb5ku4R64/gJRrbIgs?=
 =?us-ascii?Q?o0/sslMdnetGfro82cZtbISl9gHQIFKwIiZGl26ut+nd2MMiq9bNCZeE1b7A?=
 =?us-ascii?Q?NUR03/sxuKiLs9WqLgf6mGq+rs2neONxZaZCDaLQvkNsNVYzQAHVRDSibTY8?=
 =?us-ascii?Q?uZZ1YYbv+1ytdW3HLRMGfpG3dDY16MxpjuN3VuH3mt7etmzh+3p/ft1US8P/?=
 =?us-ascii?Q?izVW6rxNoYPb1FLTLZ6yp+VwyeBkVt7TJPIBM39pU2U8xM47/lPZymfHZ643?=
 =?us-ascii?Q?uaGW7Mck+4d1rBGqbkttTchpKa3yoR1OCWwuz+1c1OSJEHN7EzdbUS+MkHKo?=
 =?us-ascii?Q?HIPwjgmSl4eInLQXKet8jTX7iCAoL9Aas0IkIUxuDJGTkFD6vZ+PofaFhpEU?=
 =?us-ascii?Q?hhdHU/zPVFqpeoZVp652hQ+RpaIwpBh9/hqAPYtU8lQS5bh8bs02D8cfMRgK?=
 =?us-ascii?Q?h+gvGqjqFIsSImoYBtlSn2KQ7+qwipndY1VkO2BCfXpF5YUdGaSwi1Gw7AXw?=
 =?us-ascii?Q?jd1EWKSuw3KC0o7+lQ8pG7wLeGPRsyNhe3IPEwOzgP8L/tltBabNUU2w5rLQ?=
 =?us-ascii?Q?OQ5/J6t6iHHqvDpclZXpqiCfvg33CmClH/h3MeH6a2Fv8DjLH+f/DrpRm1A0?=
 =?us-ascii?Q?ivGPOHRDBfcE/g6yNFrDCW6QlXd2Ip347qGLT4DjVVQeXX3i09cvaFK8efxI?=
 =?us-ascii?Q?PJkgHobShqEgiUo8XiZcierxEbQz5wcKc1mQCT/vnJfMNEu1KRGF3oO/RRDO?=
 =?us-ascii?Q?YGL99lCwh6yKybFEAoN2yncIOCRvs96rke3uvAedIH2ii8Nj06FfgHcS+1v1?=
 =?us-ascii?Q?i6Il0eknx1RwjoxM5iP2AZfwC3wU58st1OjKdcAKqrgFnEL3Quh0jNYg37ze?=
 =?us-ascii?Q?kj4un64chReYhCE1aHHp0Ce4WD/YjeTuU90otZTq2C3/esNe2cY3NWjwLqdz?=
 =?us-ascii?Q?ksdcOkMx2aIAUJC5tyoRsYk1rn8=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D4BE1007056E63408855C892345E9704@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5433.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac7060ab-8790-4cf1-63f8-08d9efb6fd63
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Feb 2022 12:39:06.2777
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: r2XWdM1+BZ6eacpp6v6EOgm9pdT+/IzuRn2bda6QJO4wfudEr8DMusv2XMM9jyP92QHJK9HE2lQu6uA4zNfDTw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR10MB3603
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10257 signatures=673431
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 spamscore=0 adultscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202140076
X-Proofpoint-GUID: 2evxkv6KHpw6bZzyqOzcyteTmAfr2GAS
X-Proofpoint-ORIG-GUID: 2evxkv6KHpw6bZzyqOzcyteTmAfr2GAS
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
> From: Christoffer Dall <christoffer.dall@arm.com>
>=20
> When running a nested hypervisor we commonly have to figure out if
> the VCPU mode is running in the context of a guest hypervisor or guest
> guest, or just a normal guest.
>=20
> Add convenient primitives for this.
>=20
> Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
> arch/arm64/include/asm/kvm_emulate.h | 53 ++++++++++++++++++++++++++++
> 1 file changed, 53 insertions(+)
>=20
> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/as=
m/kvm_emulate.h
> index d62405ce3e6d..ea9a130c4b6a 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -178,6 +178,59 @@ static __always_inline void vcpu_set_reg(struct kvm_=
vcpu *vcpu, u8 reg_num,
> 		vcpu_gp_regs(vcpu)->regs[reg_num] =3D val;
> }
>=20
> +static inline bool vcpu_is_el2_ctxt(const struct kvm_cpu_context *ctxt)
> +{
> +	switch (ctxt->regs.pstate & (PSR_MODE32_BIT | PSR_MODE_MASK)) {
> +	case PSR_MODE_EL2h:
> +	case PSR_MODE_EL2t:
> +		return true;
> +	default:
> +		return false;
> +	}
> +}

PSR_MODE_EL2{h,t} values the least significant nibble, so why the PSR_MODE3=
2_BIT in the condition?

For the scope of this function as is, may I suggest:

	switch (ctxt->regs.pstate & PSR_MODE_MASK) {

which should be sufficient to check if vcpu_is_el2_ctx.

Thank you.

	Miguel

> +
> +static inline bool vcpu_is_el2(const struct kvm_vcpu *vcpu)
> +{
> +	return vcpu_is_el2_ctxt(&vcpu->arch.ctxt);
> +}
> +
> +static inline bool __vcpu_el2_e2h_is_set(const struct kvm_cpu_context *c=
txt)
> +{
> +	return ctxt_sys_reg(ctxt, HCR_EL2) & HCR_E2H;
> +}
> +
> +static inline bool vcpu_el2_e2h_is_set(const struct kvm_vcpu *vcpu)
> +{
> +	return __vcpu_el2_e2h_is_set(&vcpu->arch.ctxt);
> +}
> +
> +static inline bool __vcpu_el2_tge_is_set(const struct kvm_cpu_context *c=
txt)
> +{
> +	return ctxt_sys_reg(ctxt, HCR_EL2) & HCR_TGE;
> +}
> +
> +static inline bool vcpu_el2_tge_is_set(const struct kvm_vcpu *vcpu)
> +{
> +	return __vcpu_el2_tge_is_set(&vcpu->arch.ctxt);
> +}
> +
> +static inline bool __is_hyp_ctxt(const struct kvm_cpu_context *ctxt)
> +{
> +	/*
> +	 * We are in a hypervisor context if the vcpu mode is EL2 or
> +	 * E2H and TGE bits are set. The latter means we are in the user space
> +	 * of the VHE kernel. ARMv8.1 ARM describes this as 'InHost'
> +	 */
> +	return vcpu_is_el2_ctxt(ctxt) ||
> +		(__vcpu_el2_e2h_is_set(ctxt) && __vcpu_el2_tge_is_set(ctxt)) ||
> +		WARN_ON(__vcpu_el2_tge_is_set(ctxt));
> +}
> +
> +static inline bool is_hyp_ctxt(const struct kvm_vcpu *vcpu)
> +{
> +	return __is_hyp_ctxt(&vcpu->arch.ctxt);
> +}
> +
> /*
>  * The layout of SPSR for an AArch32 state is different when observed fro=
m an
>  * AArch64 SPSR_ELx or an AArch32 SPSR_*. This function generates the AAr=
ch32
> --=20
> 2.30.2
>=20

