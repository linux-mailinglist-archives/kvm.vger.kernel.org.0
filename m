Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FC5C7CACCE
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 17:02:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233582AbjJPPCS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 11:02:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233425AbjJPPCQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 11:02:16 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7283E6
        for <kvm@vger.kernel.org>; Mon, 16 Oct 2023 08:02:13 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39GCdNPC023931;
        Mon, 16 Oct 2023 15:01:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=wGvYEHQipmSUmZbkwxt0ERhYzSGJAItPX4C+8HSOm9M=;
 b=TfIBCaW5cuXmodiQVdtnQksoBYzF7IuryE8InVB3WN+mIayP6t/bFQceTP9NfGONbi0N
 RjkroWw4QwMeBeemnE9M7ISLVNNcg9srebUI6Kz++XwxfuGuNPYZE/ADud6t+/14+paV
 0ZHJbD6RA3cEY4xAtf9VSNdpSvf+bfKMIzCQX62JAJ1hclpP16JKn24asSfPn7xCOyUa
 qzT3JybfwMtPBPkT9+hn0kOjrPJnrkrGXC0TBCcXC4zSpTDJjkx8mMgQuydf50+vMNMU
 cWbJ+VKO7F+/x4qhI1l6zC2iPuVkAQ+NhDZcHhfDDpPGjr3DV316s6ARQTsTIfe74b2t 5w== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tqk3jjy9b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Oct 2023 15:01:47 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39GDdZ1Y027184;
        Mon, 16 Oct 2023 15:01:46 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3trg52j1c6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Oct 2023 15:01:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZikPJKv/M46z1WLKauHtIbTHjRZNo0wLkmdHWL0HZ28wZ7WSmiMm+kpzTblcsDkEKwWDXkrFsT6rrSOLEGT59+KtpUARpF4O0eXAF30k30lgoKYMS7vr5UpLAxbhktuuAkJRwRiTt6SfcgyxEGrUXp0kU8faQccbDV6MYFXQ/bPs7o7DjdzQL4ufZZz/Pls7Q7pF4Exp70rQw7qCp94GbRtbOvQT+cUZDOK3QkoQu1LlyvHvFiXxVMVd1nxdJAi/5ePwrpnDGkS/v4zbYg9SLzJAReB9YTMfELu9Gbd4zxewqhx3oeulftYKXuNwilz5/ibhdN7h/R2EYWbwPy6Jhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wGvYEHQipmSUmZbkwxt0ERhYzSGJAItPX4C+8HSOm9M=;
 b=aUO4BShFa10Mx38dvod2dqeTWG15xUFD1ATAYbuGF3cP5QHPdJHGaFuC3MzWnfwMf/JqVA9fdNRMVawsQcH9jDj8R0gIC7BF56ljusxzNQhK3OltKPH/Sdc1V+ZUSKrxFcVLG0WQVBYQ2lzy65dXhAHTDexBaCQMmq4u0Fid4Ke0KUcfutEbVEJOD1eY7xF9kscAURHrbHlx5cO1NLjuJQst2XKSfZsk7OaiTiSV1/aZhmsuiM6Ucttm2mcjPsofPKpt1rgipDpPKE6Yw2148tqSiSDflcn3wJQL/rG6eN6Izk6doYrKJ5HvgNbwFa5w0XKKyb6GMFAeUH/epDV6qA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wGvYEHQipmSUmZbkwxt0ERhYzSGJAItPX4C+8HSOm9M=;
 b=nvle0cBIGVOWxodv9O+A3vOE94fWFaVxnQM/hEpQkG/r05yHKMo6WLst6Rq2owMVHS9SE6g4WVbgGrZ1opDdZC2nUa1NfVXr5w51OV3xzlPMlE+f8LFAPQ95Zk4a4/8LDeKVo0CuiluWc3d+KLgM84CB/iKeQuV1cvCdvCgwz8M=
Received: from PH0PR10MB5433.namprd10.prod.outlook.com (2603:10b6:510:e0::9)
 by CO1PR10MB4435.namprd10.prod.outlook.com (2603:10b6:303:6c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.34; Mon, 16 Oct
 2023 15:01:44 +0000
Received: from PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::9e2f:88c3:ca28:45a3]) by PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::9e2f:88c3:ca28:45a3%3]) with mapi id 15.20.6886.034; Mon, 16 Oct 2023
 15:01:44 +0000
From:   Miguel Luis <miguel.luis@oracle.com>
To:     Marc Zyngier <maz@kernel.org>
CC:     "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH] KVM: arm64: Do not let a L1 hypervisor access the *32_EL2
 sysregs
Thread-Topic: [PATCH] KVM: arm64: Do not let a L1 hypervisor access the
 *32_EL2 sysregs
Thread-Index: AQHZ/iVQE1gHMU77jkK9IYV16YtlFrBMefUAgAADsgCAAAlbgA==
Date:   Mon, 16 Oct 2023 15:01:44 +0000
Message-ID: <69203F5C-1D5C-4E21-AA98-1DA2433A25A2@oracle.com>
References: <20231013223311.3950585-1-maz@kernel.org>
 <41C20D2D-BA87-41C5-85BE-611EF53FB5DC@oracle.com>
 <1DFF1105-A2C0-4249-9F71-3C9636C8FBCE@kernel.org>
In-Reply-To: <1DFF1105-A2C0-4249-9F71-3C9636C8FBCE@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR10MB5433:EE_|CO1PR10MB4435:EE_
x-ms-office365-filtering-correlation-id: f95832de-b677-4751-0787-08dbce58d007
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /ary2W8w8RBm0SXFnx1yZjxBxScbgK4dZ0oEaJWUqA5n2YHonbkJimkr9Bhe4FDfJv3F6Np+7oFWARkq2DQ+fmPJdLBAd6lDwNBQPLT5JzZ34zBADhyJHPa3uMtGJJX+QPmvFDFWtHvBR/RC+RP2RNwughPEyzCf6kfY9L/ejjtxCVLP0sOKVVuL6zvMTkA2f5o3uE+bXWaCXRaixSSxx9Afqz1XSPLRyiRR6UeyBODyJWQWeiA0OwqKZEikjclo6Ngqyeqzl9H39kWNbpIf6RtYaRDVTW/LdtjAmvtAmAmbfWcjqgNfywMnrkGZGGxYol8kPuvhPxpBiPht5C2lQAJOqcMLQ6fIDG/SoFodQZtNkXh/lrfiMa7WB2Dc8dlfmJ/FQH63c5VkacCOgHpjI/Pen94x/bfR3SrU2K1rQJ3uzGxNAG+pGQhnJKfZgAZNCnI2n2TsKIWJzt1iTHFJpvEVSmfBQDv/V0Fg24LWRqvgHhjrEWP+4hQz51Y6Evd0t6n/gteg9YDn2voGInMI4Kfw/0lB/rr+tXujCs1VB3xKgRbgi+oimRaZ3HuuiiGMH0UOprpz6uH7wCxW7onnUwQuwgAOSbTYvxCj24G8UnOKyksHc1v0on7f2Q86u0kpzQFWXBWJa/h/BucT4fJvFg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5433.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(376002)(366004)(39860400002)(346002)(136003)(230922051799003)(186009)(1800799009)(451199024)(64100799003)(478600001)(53546011)(2616005)(6506007)(76116006)(64756008)(6512007)(66476007)(66946007)(83380400001)(41300700001)(8676002)(44832011)(4326008)(8936002)(2906002)(66556008)(91956017)(54906003)(66446008)(316002)(6916009)(5660300002)(38100700002)(71200400001)(6486002)(38070700005)(122000001)(33656002)(86362001)(36756003)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?yeNh/vwhVbACWGfMPERXHpSTtwutunRdNxuXJIXwfmhor+NKQ0M746HZJ505?=
 =?us-ascii?Q?zB5T4YGWSoRuGuhD7lm+YY8C+It7KDNETffj8XtlT/rEfQPUwiqPL6FbFPwa?=
 =?us-ascii?Q?TJFZeDuqNO+/rS/V26oRSyXNH+zMmMOpLXEx21HHIRRFEhTI4qnT8NbH35Nm?=
 =?us-ascii?Q?ZFR4Tg/1K7zwL3SMqqbXhbCo8Cdkm8azSJlLfwV43DjEn/5J3ZUJPzCW2GRb?=
 =?us-ascii?Q?46IqpLm/9dPrxAueZyPQU9z6Yllc4fWxTXiKkEMSO5BVk5a3xn5LOr5RGeHV?=
 =?us-ascii?Q?jc4fuojSuUzsYrgczPsTVAM0i9PfU3QMenOxoJhxNw6LG2a2K3CdSZCB7Yov?=
 =?us-ascii?Q?GWFpO7aoJx6LaXVQR6LqFcuejSFMDUXuiQJQ48Ael1pCbu74jhNQk5dJ0VA0?=
 =?us-ascii?Q?/htjjB7bphcheUMp/DUiwAkT7Oyd1LjoeZD69WjScfL7QXPblU13s6WfqIjl?=
 =?us-ascii?Q?JrTLzrnUCcaw0GVwksI5tCGGaXe+ZO/iL8BQ7KPnzBMvMPL1b6ElJW6H9mYi?=
 =?us-ascii?Q?oKQnmix21j8dx8HD26ShcenfdM7eU81KYjr9l5amd5gIgbDrkmVZJsrA16Jt?=
 =?us-ascii?Q?olAp2jZSNWOFCAReqwJSQm30yq41SKZo9DeO3499B9mILWJYFS9svBZRQuw4?=
 =?us-ascii?Q?mc5MRAc4NKs2c4k5f7xq3GOsXmlTtBmmPQJc2GQmAGB5ppjCxZE/TAiujhPr?=
 =?us-ascii?Q?E0baGG+rKpcGxIrLHFNuJxSGv9niFJHDpwDNtZavvnJbRy9+2SJaEyo0fZQs?=
 =?us-ascii?Q?daUfcvgP0bH81zEzsyW5ScejK73PLBO7GbYOdV9LPEFUt5RiGJthnCi4xcwh?=
 =?us-ascii?Q?BBeALnZdF+6U1gvrPgJx7D/IULOA49HYc7bKiAjPABcqVFatx8hLibGMacyT?=
 =?us-ascii?Q?lOmvB3Gff8hcwqECk9t9HXxFbvzWMyC6/K61v3Bq9dne4nP9dcy4Gf//R18a?=
 =?us-ascii?Q?HZFNVJGTnXyfWNXeL1pZS2wGos7Nh4V5McVKEpkz5UQk3myIG8ytYtGhMXBR?=
 =?us-ascii?Q?7q/gcykdWbLZE5K+EfLasqa2sw9tSSVRGBZSw/MHEbQ3lB+j3auudc8JHvlY?=
 =?us-ascii?Q?4weD4A56K6Q01Z4zr5xNxrQE/Xq62fC56iKf5KvFEcG94qY7ZfbnRtd3VAqG?=
 =?us-ascii?Q?0qg+2Aj9QShCNS5LpdLERqgxRe1fsewL2CPNJhtkXYJGjBJQhilWBxwCZfB0?=
 =?us-ascii?Q?SluLbKWCz0Ffkg733oKodf6xBmkFF62B4hxvb+TS4w4VNIj32nZ92a0dqoJb?=
 =?us-ascii?Q?/tv4bxDZoQftbxNsIE6L+V4Dkw2TEtfMY+LTSSh/lnj/JnQDHQdKlSBR+IRD?=
 =?us-ascii?Q?aBIQzAeEjDDXIFEmj6jaxkzz4ngo6ePoHFstQOSoiTpe52vLqWGUjLjCnYNN?=
 =?us-ascii?Q?3kfYLagfOYeWCAJd0aSj4mwQbYR0/cSYxQJ8vuZHQ72UmYL/q9j/Hfr6yyuJ?=
 =?us-ascii?Q?0uNmcToRUEVzO7fnrhcYp5D2UAC9hKZH6BAt1SsM7gqWWmjjDgYAYUL3e20S?=
 =?us-ascii?Q?gjJ2tpZH6AGjlKLY1f60zil1RJahoROzx2buZpHXFrrpoF4sA9qzX2EbnwG8?=
 =?us-ascii?Q?F04rFddOCcgFNGAP3eUg/RK3ozjxH59yfFxJihoTfhPR/LTQkTmMQmg4OoG5?=
 =?us-ascii?Q?qpX/6sIXYJToqW6LV9rhQBI=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <77BDE1FDAB450F43AF1C3910B34F5302@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?D+SOrszH0l7jjI5t7PV1h18sJ17gDIVAOhlj2mdUuZpG4+M0sthSpo/6D0p+?=
 =?us-ascii?Q?WLePX3De9ACtNcKCHTBfaaZj3eCvAyG4Mo6srM0jSwE1amYzF1Ktz7yQOGxj?=
 =?us-ascii?Q?d5epSFV912ti/7KpwjdTSN5YlydVYAB9Zz5kVIAOgdVfPb6d+j1tCXs6uul7?=
 =?us-ascii?Q?vKB+ZXQoxxqRLZbhvqqVhFevL/242aHDCP+tE4TaXsq+fGmTVOii+PUtIuJU?=
 =?us-ascii?Q?uuizIx9xV6PvvYHkEcWR8wQ+oW/FHeDIe4NUMi2R8PNlgFh36VJ1lQeiTyAr?=
 =?us-ascii?Q?WYakcXZxI7ftJbu9ul2oZ3m1YFuuWJ+op+Xg2gXSRtoIpJX8dpym5aXmHmkR?=
 =?us-ascii?Q?/mTnm2t254TR+dSk8OaTSDOMfZNqDGKYcqBFxOGNjkssKqSerHDXPcCgEbNx?=
 =?us-ascii?Q?/4ax2pAMAwp6E0775tZz8wptaDEuGw1LMearPPfV3ibLYcouTeY/a4qRV45b?=
 =?us-ascii?Q?1iGuCb0W5qSofZc6HB7DWOFtUJGj+eLMmCcAbEoXUPchoI8uezE4lhX6R3By?=
 =?us-ascii?Q?cU3ocXBYIsT/cJMCH0h1hL+uBR3Ou4WeTvjzklaFo1whDS4RCkYIJdiMyLM+?=
 =?us-ascii?Q?jJAUZqPnhnUGPElTc+Jmh+l+3p9LYq+bhXV6+yb7RrddOCbwtTa7dS9mM3Jj?=
 =?us-ascii?Q?arBNd4OX+J1Q0iIgBRyusvsn77KBsygDiMfPrx/q0A50UvZ7ubBaZSDfiGdj?=
 =?us-ascii?Q?7+qafM/V2ri2Z66ViWjP/lQwpe1ZKZL37o7PBdHWk/oprrBb2XB7PalA2Umc?=
 =?us-ascii?Q?5AKS7DqoBuJGHwdVIzlnAtFHazXBSpvv/5N7+O5zPw94PcPy9Jj+M4kbvb8Q?=
 =?us-ascii?Q?B9k9rswrwIOtkTbiO+UdB/Agakiom7dyebl31udRlR0L9Ahssr48dftALc/4?=
 =?us-ascii?Q?0f36IDFHMJs+YhwhXH+4uPs+jFYLoxiAIna2hdUcBnK0f0SX4/jcnGvmBzOU?=
 =?us-ascii?Q?jIYnwIhZ8VjvcxyjvTuP6Q=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5433.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f95832de-b677-4751-0787-08dbce58d007
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Oct 2023 15:01:44.5289
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xLq09lAepE7McN+JO1/R9IIYGdt71KlnUNGXfJkqqZ6UwUwJpbv+yctPAHizAalRwNmzN6uvZ9I/PGu6in8Ugg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4435
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-16_08,2023-10-12_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 phishscore=0
 malwarescore=0 suspectscore=0 mlxlogscore=809 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310160129
X-Proofpoint-GUID: yJ3Ah274LxgbYLVlLvjEmYyl6tT-QwjB
X-Proofpoint-ORIG-GUID: yJ3Ah274LxgbYLVlLvjEmYyl6tT-QwjB
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

> On 16 Oct 2023, at 14:28, Marc Zyngier <maz@kernel.org> wrote:
>=20
>=20
>=20
> On 16 October 2023 15:15:02 BST, Miguel Luis <miguel.luis@oracle.com> wro=
te:
>> Hi Marc,
>>=20
>>> On 13 Oct 2023, at 22:33, Marc Zyngier <maz@kernel.org> wrote:
>>>=20
>>> DBGVCR32_EL2, DACR32_EL2, IFSR32_EL2 and FPEXC32_EL2 are required to
>>> UNDEF when AArch32 isn't implemented, which is definitely the case when
>>> running NV.
>>>=20
>>> Given that this is the only case where these registers can trap,
>>> unconditionally inject an UNDEF exception.
>>>=20
>>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>>> ---
>>> arch/arm64/kvm/sys_regs.c | 8 ++++----
>>> 1 file changed, 4 insertions(+), 4 deletions(-)
>>>=20
>>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>>> index 0afd6136e275..0071ccccaf00 100644
>>> --- a/arch/arm64/kvm/sys_regs.c
>>> +++ b/arch/arm64/kvm/sys_regs.c
>>> @@ -1961,7 +1961,7 @@ static const struct sys_reg_desc sys_reg_descs[] =
=3D {
>>> // DBGDTR[TR]X_EL0 share the same encoding
>>> { SYS_DESC(SYS_DBGDTRTX_EL0), trap_raz_wi },
>>>=20
>>> - { SYS_DESC(SYS_DBGVCR32_EL2), NULL, reset_val, DBGVCR32_EL2, 0 },
>>> + { SYS_DESC(SYS_DBGVCR32_EL2), trap_undef, reset_val, DBGVCR32_EL2, 0 =
},
>>>=20
>>> { SYS_DESC(SYS_MPIDR_EL1), NULL, reset_mpidr, MPIDR_EL1 },
>>>=20
>>> @@ -2380,18 +2380,18 @@ static const struct sys_reg_desc sys_reg_descs[=
] =3D {
>>> EL2_REG(VTTBR_EL2, access_rw, reset_val, 0),
>>> EL2_REG(VTCR_EL2, access_rw, reset_val, 0),
>>>=20
>>> - { SYS_DESC(SYS_DACR32_EL2), NULL, reset_unknown, DACR32_EL2 },
>>> + { SYS_DESC(SYS_DACR32_EL2), trap_undef, reset_unknown, DACR32_EL2 },
>>> EL2_REG(HDFGRTR_EL2, access_rw, reset_val, 0),
>>> EL2_REG(HDFGWTR_EL2, access_rw, reset_val, 0),
>>> EL2_REG(SPSR_EL2, access_rw, reset_val, 0),
>>> EL2_REG(ELR_EL2, access_rw, reset_val, 0),
>>> { SYS_DESC(SYS_SP_EL1), access_sp_el1},
>>>=20
>>> - { SYS_DESC(SYS_IFSR32_EL2), NULL, reset_unknown, IFSR32_EL2 },
>>> + { SYS_DESC(SYS_IFSR32_EL2), trap_undef, reset_unknown, IFSR32_EL2 },
>>> EL2_REG(AFSR0_EL2, access_rw, reset_val, 0),
>>> EL2_REG(AFSR1_EL2, access_rw, reset_val, 0),
>>> EL2_REG(ESR_EL2, access_rw, reset_val, 0),
>>> - { SYS_DESC(SYS_FPEXC32_EL2), NULL, reset_val, FPEXC32_EL2, 0x700 },
>>> + { SYS_DESC(SYS_FPEXC32_EL2), trap_undef, reset_val, FPEXC32_EL2, 0x70=
0 },
>>>=20
>>=20
>> Should SDER32_EL2 be considered to this same list?
>>=20
>=20
> This wouldn't make much sense.
>=20
> This register is only available when running in secure mode, and KVM is f=
irmly non-secure.
>=20

Thanks for clarifying.

Miguel

> Thanks,
>=20
>        M.
>=20
> Jazz is not dead, it just smells funny

