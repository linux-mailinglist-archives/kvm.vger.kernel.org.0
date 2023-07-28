Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C6D6766B93
	for <lists+kvm@lfdr.de>; Fri, 28 Jul 2023 13:20:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234238AbjG1LUq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 07:20:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232825AbjG1LUo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 07:20:44 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A40613E
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 04:20:41 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36S1ZbjW028997;
        Fri, 28 Jul 2023 11:20:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=Y500sJintrefQj4fBNYtbOMdQB/gRmp2bUPG/H3MTmI=;
 b=uqT8UzF0JMHd//Q/R2jM6H1vWDl9+5wcCRI8zwUyGxeXXx14YJXDrFm5mitGzJ6NsYE+
 VmamfE+9bBcWDjHX9zLNNP9HdaWhxI5QEzGXh7n8oOjTQJ92IiMMY4gmxVE4nj/zMjoK
 Ofkx9/qeMu3cHDQeA8RWGCfSHyPQr3RkciXTsP5/Pn/hnW+cuhILq/p+3HTpdJ+BEJdS
 1YOwAOJhDefnlMboSAH6Fqtgo2R8AUNuQLxHDd1SvU+qRs66GS7b7YYDnQAQ60UZngqs
 zNrrnPK+Dds/onppNAq16cZLvyl8ZhhjibE0ZHhsAGx2TvRr7/qJQY+Ij4Ct8YNaOTjP EA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s05he3mc1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Jul 2023 11:20:15 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36S9x4Hj011878;
        Fri, 28 Jul 2023 11:20:15 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3s05j95kd9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Jul 2023 11:20:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HIyQFMb+3Iao0TQ4bNrIhwoGqY0om3iQ+5WPqwTY+y8nLS66GQBZb3uqIzomP3hdNHavpP/uMCuUY2SMJODQJDm4HDJmZ5+JRJYgzWKd16wmesfC/o5WjcYrb6uZ8CxCFXdHGwynh/PnVbbBRUUaghTIC1qKLEpcmxQJ0Q/EwdaPBhUb3CVIy9yxKNlM/8CJwGr8XYaqxFaan1yK8jRkaxPyNVL4vKZ7+j91nqxaJcwV4v6gAlb9Wb3XqAJc72ehymjHVpZ182TYJamB46CS834O1xNzAZXdJD1rBATKdNKGdOuUijQa4nsuABAc/j2vj5gmETmLATvMFurlQUJ3Dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y500sJintrefQj4fBNYtbOMdQB/gRmp2bUPG/H3MTmI=;
 b=dwjZlyQImpUOgl/8gUo/ncIxbnaUbC1dEGY8fhwcno/v7kQhhh0MMqe8rUCLB2QiZ3ErsnbqS9XyESdVBnWOhHZUpUbG7Jzk2m4z+39VeNMMtrK4qni2zOR2tdgS3aJ06FP9XShOyOrJtybJLJQAqYLbt5yqkp+SyWAZNfL2oCP2M+sow3qG4Qzh6ID35bm3IfYToCqFWb3745gW4LXBl1/kUZpqwAyVAujyr4zR2Lw+MUm/ThvmQ7CPcnDJtqTcnD7398HTfDr4n8RQjZiFZkyLqw/lfEe8f3vPnK8uW5sJUg4C9mGztPnvJgYY0jwKZYf3VKH/hnMnRSRWMsLbFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y500sJintrefQj4fBNYtbOMdQB/gRmp2bUPG/H3MTmI=;
 b=aWQ3o5lWHMiC59RCi8gRPS7XyJj687RqSPpCu+eifDmS+kw2b0MmF9WgwwoBhz4nfWWC6KbHweQQCILWagGG2JoJiahgjrKx5Hv1BxRDE81uPBTSAz1Wlif3cyJYnwVWVzTvA6Cfoxzn1cz+soCkcgLwOuxc0WqMQ6hMxwvjmoQ=
Received: from PH0PR10MB5433.namprd10.prod.outlook.com (2603:10b6:510:e0::9)
 by SA1PR10MB7596.namprd10.prod.outlook.com (2603:10b6:806:389::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.29; Fri, 28 Jul
 2023 11:20:13 +0000
Received: from PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::2cd:1872:970d:7c4e]) by PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::2cd:1872:970d:7c4e%4]) with mapi id 15.20.6631.026; Fri, 28 Jul 2023
 11:20:13 +0000
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
Subject: Re: [PATCH v2 03/26] arm64: Add missing DC ZVA/GVA/GZVA encodings
Thread-Topic: [PATCH v2 03/26] arm64: Add missing DC ZVA/GVA/GZVA encodings
Thread-Index: AQHZwS23LDe68ZoHQUe4/T7HhckeCa/PCIkA
Date:   Fri, 28 Jul 2023 11:20:13 +0000
Message-ID: <EF417F02-B32C-4959-B6CB-40C6D8962370@oracle.com>
References: <20230728082952.959212-1-maz@kernel.org>
 <20230728082952.959212-4-maz@kernel.org>
In-Reply-To: <20230728082952.959212-4-maz@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR10MB5433:EE_|SA1PR10MB7596:EE_
x-ms-office365-filtering-correlation-id: ebc668dc-905f-4f0f-47c9-08db8f5c9cc8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YsPkWJjqam7ZJj0cJ/jaiQDPNsaNzY/vatsgzs3CUG7EIFvjoEzVYNPJ+wJB2xyHb1OMgKPlPaCkpuIu1pPer5qq/opB7dH1a/79L4yvp1+BkAJL0ODiOTBwgPL3ZufJ/0mNFca+J27EuBK3zYWzKWnlGdi8kYPKhzl+3NOaw0INnr4LMEPbIx7aHmkuODuyf7SausPfwN88WYmL7fIt3qrDhG7ojtGPsWePdZNDTw0P1K6EhcK5oB+5ADhHtG0vldweuLZPXnR4RM5P/A68rk7VIX9H/oZ07xm3Qry+YKgp9wx+xCsuL6PA9IM3KvFxuajAAIhJGFcQl8j1VEQqPeaMuBCKzy1duXRmGlCmYIjiZ2e67YBRFZIzjm8xWthMgXDGhuZTYwv9HF2TlgEK9RaT+XhpSyDoPgJcWCEHqfBEEaEHQovVwI7VHLPlCF6hl1njGnuEXVH4rKvYVF/3bIVCluVXQ5ygcs14CDRegfC9gEDz18xxHDOZhzNK4a9u3kMr9n8nYF+KGsodfUtvSKHABGRyE7cPVquKpg3wMmoEeJjdUGUa4ii4ctlQWR30mVCh4fnppMu8PhYJOQ81A2h8C3vrNTIyewHziicnFU96BXsJhTJbqijmAKEyFbX+ibr/sMIeLQy0FxcrS8vw6A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5433.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(39860400002)(346002)(366004)(376002)(136003)(451199021)(91956017)(316002)(8676002)(6916009)(122000001)(54906003)(6512007)(478600001)(38100700002)(6486002)(71200400001)(5660300002)(41300700001)(66476007)(66446008)(66556008)(4326008)(64756008)(66946007)(8936002)(76116006)(2616005)(6506007)(53546011)(186003)(86362001)(44832011)(2906002)(7416002)(4744005)(33656002)(38070700005)(36756003)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?qXzmHT6iKwvPeaSUKw5zXN0TpWxMT67tLjQlm1MhGWkxQRkJ1j4F+gDWTzoe?=
 =?us-ascii?Q?i0RxRuANUC2q4xYHx08Nr4uBlHbELGlYy2To/w58mxrUPcu3wol1yXmXi7Po?=
 =?us-ascii?Q?mErD5Nfdspg8xOLBN7ukOrnp2m4uSd9IgqzRFPU9jBEeHAcpr23BBoRI9jQT?=
 =?us-ascii?Q?/K/Ig3bGtwE7YwbtUSg1oWX18Y2IwIpmP25k48v48Nx5Jmzpg3zLn9Q10pop?=
 =?us-ascii?Q?6mgO2j41M1+84qGiZYUytWQiVPH8/imrRgvpclthGNeXvqfLv5CR/rj/Y71f?=
 =?us-ascii?Q?vPJQUKL4Kk3IJXDfPQDYlYZlT69J1yniDaKA33R3n0nzcVzzSo/+SQCiOmpa?=
 =?us-ascii?Q?nJF+WAihsoVDQj0pMIzfVvEFWRmMUouxQZjud/1McTK9TgOq23KTib2ag/1L?=
 =?us-ascii?Q?O2BUPwqZmYY0g/oZslizgUmj9tARO+jYCewE7F0CjcGloVwEyUqKUnT4N7Jb?=
 =?us-ascii?Q?nxHeu3soH+eRLJySbMh82XvEutiiaD+kVtg4+H7+GheJSeg6g54iW/MAyQKt?=
 =?us-ascii?Q?lwSFohthUBEiZiP+Y0VPDHzcwTvVtUzhVUp0/QdseNaeRDdQ4LJoA3ymTGVw?=
 =?us-ascii?Q?1RFEC5d/Pgim0mBHfZA7nJyHxIW2E2AImq1kD3kq2M4RgHGjcojuR9TEXaIM?=
 =?us-ascii?Q?ma6okWlMolod3Quae5U/aIHcGst+dr53r3g+brooPsOUit0LbfqAJbzaPu5d?=
 =?us-ascii?Q?ynLEliP9vJQx6DMbLF4qsxknb0O9Iw+7QBmXW8EVJo8f2IhOuhdxnQnOzXRk?=
 =?us-ascii?Q?tkflAffG5hweCvsxxyWA/pEV4s5uGDuwthO/NhBnPNz2bnFh4EZ2S+Gg5Bse?=
 =?us-ascii?Q?3rAA+GSj87fZPO+lxAVKOG/HCj9m7tqjqOBRIuKSXRmkAMYY4zdzNSRu1ATk?=
 =?us-ascii?Q?pvuNHzffn4WLNSSjrC50AwIZD7AMyra1icvir4MVKM6En8IcFsTKFqJyCoXX?=
 =?us-ascii?Q?eOawage5GGxR2YZHUETjTGVzK7NiEy04SMHjW4CSEd3/RiI0vWvM2sswg8mg?=
 =?us-ascii?Q?Kx6TcNIO8VV3iwimaHbCje0zDqmvJbtRcrIJ8wszmY9kK77Szzu6x2I/tCis?=
 =?us-ascii?Q?Z0n0ueJA2h9+/BkBqxyJneAPwyJv73Sx3Gzx9zfutN1gNkfFRRPBBi7NFjMA?=
 =?us-ascii?Q?UZZXyUS1SQAusyoe4sJ8/xO1ddIpW6FOYAJpf5DVyjG/mUC0GkDu2nSeoq7W?=
 =?us-ascii?Q?9Y5EyZ94SF5n+ho/sWIOOgZuVXj9qOp060JQFXa4bN3OuIvkm1XjSlQyRnR9?=
 =?us-ascii?Q?1E4htZ6+imNmV8cxBQZ+IBAdjZ7Tj7ZDeznWQKVvcC//InsRphW5Fn/hb8Qn?=
 =?us-ascii?Q?UThxo0nrWnHkX0fDi3RhP1ndlVOLe+m6bDtMhk808EZCIZ5OyiYNkUtu+GFj?=
 =?us-ascii?Q?Mxx1863OLaioJadyUN2nldPYzFLNQZ8IufrwaP5MCDl5FwQVfsgVHKjKvY2T?=
 =?us-ascii?Q?Xz3OQQDDwSULELbmsJi800CbC2mlp/gTpW/nqcW/CmVHJIRjZ+f34zbS3gM5?=
 =?us-ascii?Q?2nBoJ3ee4vaJTVjbfMfkGoxx2vjBlBTltjupf9cTGZILhbBaXLqac/JtEQGB?=
 =?us-ascii?Q?aCTDq5OsICTz049587k0JpZqac09YlXUdxhYgf3zaSb1VbdGc83PGE2bL38R?=
 =?us-ascii?Q?sBW1dX2K/UCysgvg9zQIwyM=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0EAD1DC17199BB44B238183B3692A433@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?LdMrbv1Z8lr7nQ27IvniPKJWIJtnA+QcdzRJlvrRGueyrn3wnbsIMT0o41eI?=
 =?us-ascii?Q?N3Fyk2I48JRSvnbtld4HGXgoR1qR6V46H7LIgktEXPBSCAJEX/Q84p3qrzHx?=
 =?us-ascii?Q?eSbLw+V+0scGwuO2Q46bNWsUO/ubv367Hv5y0lqQbzLudX6Fgk5UxIkdC6fH?=
 =?us-ascii?Q?AGcafuU7qMnWdsBNeh3Mm7YhurdyJ2/oz4nbcICqxhjjNkCylWtnx445Y5DH?=
 =?us-ascii?Q?JcGllKrselrM48bKThhD43+n7ldAqHnmNDuO1R0tx1PSB49FgxTlvBCIRgZD?=
 =?us-ascii?Q?dMPQzbCFZPfdNrsJov8j64FhCrOi9or1Kry9BqBZZ32992JOHmuAk148GKBT?=
 =?us-ascii?Q?uYMgLvoT+1Wh4UiUoB4Y1i+gFHg/RK62/w/kEk5MvgBEA9Wr/7Ia1enOoxr4?=
 =?us-ascii?Q?d4mjdxoJ2R6DtE1mrxN1kMabRNYBZkPb3Mdf1L9voXGcCCuMk9WMjx8fQ5a7?=
 =?us-ascii?Q?s2mP/Y2m4hbPg+S6hQ7GhG8Gn3t3fsOfX50pWCQqyA35pQvfgAJ7Vq7BAhFq?=
 =?us-ascii?Q?wWzRfppEDDu0juncgX6vqmqkQ5LUnAxMqIGKibvc/HMp+guwhynhWSgtjBOx?=
 =?us-ascii?Q?iW0EpD5FTfQRrfv2wWyBLXnDZL9bp9I5tNJjh5RjL7EvxGMoDyMJ2ysTZ/oM?=
 =?us-ascii?Q?2/pQyJTLnQPp7PkU1QwMTgnRHRZpDT3vTJQs95aBU8SY7ELi0U+fmroUPFRm?=
 =?us-ascii?Q?Jh/6+ulQ3l3sUbOyDj4X1/NUUFdgYR4D5pjCC5e8W5HZn4lvtlo/ejgXDGSM?=
 =?us-ascii?Q?7djIL8Y91FQCZhIwiCBxidehXDNMw867veVrzQWwLgfb2nf4JipW5B5RumWE?=
 =?us-ascii?Q?ViuftYLMj/hJRWQrs2/xchLn2IVod71qf/Z2UQl1TorWWozvUiYrsdllvrRY?=
 =?us-ascii?Q?6yE8AAfnKkrvFZs2Cfah0aUp/uKo+XP84+vyssb9TS74epbfvT2CrwYN66ZQ?=
 =?us-ascii?Q?5aSECm/8y+mKKLu91Pru79vYYkEbQ4RFgzi1F7dFPC9HZman41nXdb212NSL?=
 =?us-ascii?Q?XIPp/AatZMEuxIWLnNiSRUYIlCWNRlDX5RXulkTPv3x7rry1MP8aO7MsgcLV?=
 =?us-ascii?Q?gzs4Vo+L?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5433.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ebc668dc-905f-4f0f-47c9-08db8f5c9cc8
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jul 2023 11:20:13.3006
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: u59KIyh056Z8XbTLoxWr0g87PVvohaRY77e7XqRt7lLRuM6Q3D56ooOTA9wJsl7DiSOKd6qWUGPAgYbxGxocww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB7596
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-27_10,2023-07-26_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307280104
X-Proofpoint-ORIG-GUID: aE8jcP5Xey4q_l138NjxAyYU64IE17Cg
X-Proofpoint-GUID: aE8jcP5Xey4q_l138NjxAyYU64IE17Cg
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

> On 28 Jul 2023, at 08:29, Marc Zyngier <maz@kernel.org> wrote:
>=20
> Add the missing DC *VA encodings.
>=20
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
> arch/arm64/include/asm/sysreg.h | 5 +++++
> 1 file changed, 5 insertions(+)
>=20
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sys=
reg.h
> index ed2739897859..5084add86897 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -150,6 +150,11 @@
> #define SYS_DC_CIGVAC sys_insn(1, 3, 7, 14, 3)
> #define SYS_DC_CIGDVAC sys_insn(1, 3, 7, 14, 5)
>=20
> +/* Data cache zero operations */
> +#define SYS_DC_ZVA sys_insn(1, 3, 7, 4, 1)
> +#define SYS_DC_GVA sys_insn(1, 3, 7, 4, 3)
> +#define SYS_DC_GZVA sys_insn(1, 3, 7, 4, 4)
> +

Reviewed-by: Miguel Luis <miguel.luis@oracle.com>

Thanks
Miguel

> /*
>  * Automatically generated definitions for system registers, the
>  * manual encodings below are in the process of being converted to
> --=20
> 2.34.1
>=20

