Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F026D7CAB2E
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 16:16:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233517AbjJPOPu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 10:15:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233686AbjJPOPl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 10:15:41 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51341B9
        for <kvm@vger.kernel.org>; Mon, 16 Oct 2023 07:15:33 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39GCco82018815;
        Mon, 16 Oct 2023 14:15:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=kUOdzDKccISPxhES5Exfl6vjAHFp5frduQhFWgJMgUI=;
 b=zGIucQwyzIt6eSA/ObkCxBxckHxSjVzE6fhklVO2GJoIzTIDyKMxqgNf9BQzHphase7/
 yv46/EZygIX+qht7+sAntXuHfespDtmwvLVitwns84rBiKXMgwh3YtlROnLUItv71ooK
 6gk8WCC8WVn2rQfkate2mXnmv01KsHVeKgq/m2874Lp++DlJrZYkMvWPQm3GK4depKq+
 N4R8Mn9CDwJRkBSlS4u9SP+pE/ZsCk2oQd8obk25Fs4cWXwQJ5+f1GqMEZO7czFQI1mg
 QP90pl806TvNjomAhWZo4oUloiUGQHHh6iZtS6KoFpe4MBbYlmNmfp4CzichRvmGR9ZP HA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tqk1bjubn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Oct 2023 14:15:05 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39GDbwC5010293;
        Mon, 16 Oct 2023 14:15:05 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2041.outbound.protection.outlook.com [104.47.73.41])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3trg0ke5ky-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Oct 2023 14:15:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MGh1VlsPt3XatEr/iUzDVEKi5IbcCUuD+68niWng4N4zb5uWiEdpeAWgDuwJcV2lHieg2IWXkQgDkeU2PnksuW10vn2+RSyPtogb6nxRabqPKDvLBCWNfhjWKuH9yebjzv2a0jk7yM3lZRZeHRw8iTLm1YVzygnBZYK76QA+t6cJ1JbkTiG9HUYUULbIxOe3AlWbDw03i5H00wKWUw+ieXcDuDK9Y7HReTTFADPfzJm2oGO84ROvWmgnJz4mJsfkBEbI2RtZBwyxOpW4WWPNjp0dEyeLcqqW5jMls5jlEZt+VPfiayuQ3uIDR6N6Nii9hTdG8oCR35SVbFUj0tD69Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kUOdzDKccISPxhES5Exfl6vjAHFp5frduQhFWgJMgUI=;
 b=MdPgzfv3KSSnkPXzh1koCZDQ4KUTGn5d2R9WLW5F7jLqJS+Tdos3giEM1eFToKuY0WGHoQdP4FDjGGWA7wdZr2bHyh40AgaeMum7JRoDuwK6chLhh/P5se3jUG3ggTmJw9wb1GrwppqpToDa6fks93MedoMaqnOsVkIVF7ISg0jeqyBuy5Wcpf+cvYUWColYx5Y3S9mYa/q2S1ao9ON7NxBnFh0V8kX0EAYZ7QiuzfNzZfn1inoWxXwameZtQCTnZN4DUYbk8Arn9srzwYwfdTjjoQq2O7AP2VRTIFCvwGSnHO8L+f6CbB/P80oX9ghEikREuEGUlgIE1jObGMQMcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kUOdzDKccISPxhES5Exfl6vjAHFp5frduQhFWgJMgUI=;
 b=ab7inRKJMtP9RqE50GVv6hAvA540uNOREiTtKj0sFL5y28FAjqvdbz8l4wyFkKaTLQMNDkSLLl4CWy5rXiJS5AqBTsEiFHIESzoAPaclQ/tkug3jmZ9SD9TsJK6XYwuA0BkxxXGdPdcUCJ0Q/q8UcqpWWkwTs3MC1mYd3z2NIwU=
Received: from PH0PR10MB5433.namprd10.prod.outlook.com (2603:10b6:510:e0::9)
 by BY5PR10MB4370.namprd10.prod.outlook.com (2603:10b6:a03:20b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.37; Mon, 16 Oct
 2023 14:15:03 +0000
Received: from PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::9e2f:88c3:ca28:45a3]) by PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::9e2f:88c3:ca28:45a3%3]) with mapi id 15.20.6886.034; Mon, 16 Oct 2023
 14:15:02 +0000
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
Thread-Index: AQHZ/iVQE1gHMU77jkK9IYV16YtlFrBMefUA
Date:   Mon, 16 Oct 2023 14:15:02 +0000
Message-ID: <41C20D2D-BA87-41C5-85BE-611EF53FB5DC@oracle.com>
References: <20231013223311.3950585-1-maz@kernel.org>
In-Reply-To: <20231013223311.3950585-1-maz@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR10MB5433:EE_|BY5PR10MB4370:EE_
x-ms-office365-filtering-correlation-id: 2183a98a-67dc-445c-f5d4-08dbce524a20
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +YM8PiOANvuGY5QNt61acewJMfBvcEbdAzY5djJouXm82+kWKDqm8y916lYAnmOHmeZk35hlnQfbW8hyU3c2C5rTmOwpWLoMzxqEWvUkPz4KitRcU3Ym7X/A6sblRJuRQ25rXuCiFRkXAiB1SrmLZL04qPGtzI0lt2+tirhnTnbR7J1wuy71u7vz2KKo/89TzJzXFGB1Xb/Jqu22LSpLAOqziAF6GSh51dNxwxbdozHGbMeboDD/n0rf+hOu8pMpTDEvJRe9lmYsutuNSVu7+J8f6ltpR2Etupgmk5c/n4rtvuvaBsFxQzVIedA8w9MMzHv88vYvmrpFDxO8PUJn+nWaBhrX0bSKlafQ8wCYN3L6pG43mVq3AYlUByyT+6QFkxetTDuLq6EUquB5fkEEQUHrB91Z0ZCC7qfjxMHezQYMwbG7Ky+Cs6ECh1iS4Rj9CHHYVOHl24nNr4DWlR8lKQDssmh64iZx/X2bq96lEHzKB3j0Hxd386xS7607NgQUC5d1s9zKlEEeSTzjHhY3M5TcZ5umNsmbcaCI8t2O82BHXLbZDur25s0PKX51u7vYWmHPeezzSpJ2iUwwWOc0x1Uiotle5D55S5DEEi6hs5eBRTacyEx+Lf1wCr/jAVunFdXvS5Gn9x3SlfoxY9Sdnw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5433.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(39860400002)(376002)(346002)(136003)(230922051799003)(1800799009)(451199024)(186009)(64100799003)(38070700005)(5660300002)(8676002)(41300700001)(122000001)(8936002)(4326008)(44832011)(33656002)(86362001)(2906002)(478600001)(6506007)(6512007)(83380400001)(36756003)(6916009)(66556008)(53546011)(66946007)(71200400001)(2616005)(316002)(66446008)(66476007)(64756008)(54906003)(76116006)(91956017)(38100700002)(6486002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?K8eqOj6mW+BAmQHjHTnK2/BflKRELw+IA8Dclj3Cseep6Sksq1I47KFIwp33?=
 =?us-ascii?Q?buI/P61bIGI48Vzwbc+RQfM1PesniC8SegMVKdLzwyYzTGiVLLv1dW24PLXt?=
 =?us-ascii?Q?CGV04uG7cS0EpF3Ukv2xt6SPQa/CX/Fbj1rSZ31HwlSms/oKs9eorjRVc5b/?=
 =?us-ascii?Q?guyBn7H1l6lul+3s6SImEHdCzB646/E8gDkvSPtYv+WHEAnOCAbQWtNKPh9Y?=
 =?us-ascii?Q?G5RWX4ue1VYHbCf23Mb4/Jxuk+opUuoDZJqwlRCvA+48Lc6+Tgr9hNKyf5xR?=
 =?us-ascii?Q?F36+4kh8Rl0Y8ar2XvzFPLVJinh6qMwgAuagGX+lUWNmDP9iBx3U6Pu2ku4V?=
 =?us-ascii?Q?Y7fvlLnySlyMBa0tliDEyMMMbkjat5/D4urPnPiGlCGenUKFc072FFtCmFGd?=
 =?us-ascii?Q?oX2UoBI/xZrMLF1ALJ6RI64oPmrCiBZQtP8sSLWGu+dXJnbQv5C6xrsrD8I7?=
 =?us-ascii?Q?ql5o3ZqOBceJTHSpzSOcwVYNg8RXaIILewt6QysJGRIqa4HelwoMdspjpx8o?=
 =?us-ascii?Q?JgiETLV3VO7w/gEgp4vVJ6dlrCE3Aila3AToUFkHOJHys1GJqtbmXJn0QEWE?=
 =?us-ascii?Q?PzEIge7Evapz7/ZesoO0T5fXJV56EoGQnhUHdElX6Fwu8AoEbMT8zf0W3PWh?=
 =?us-ascii?Q?TaH9MIzVzlFReImoeBNEDXzVSRKrOyS1hJx3W8s7uiJQu/7A/MgcZoYXjPsw?=
 =?us-ascii?Q?JmlgxWjju7HmHXVyYwk3vyGp6rgonYkUUOqKl37eGD8tfZCcbHO/iG27ClZK?=
 =?us-ascii?Q?nfu4jxjt2N5MpJA153iYEtmNNsG29fy09n454z3qNARru4NWNIS0eRwpCNuJ?=
 =?us-ascii?Q?MVPbQtuJfQDO1aQz1dAR6nR0Wh+5hmhyBnPjHfLCGJ3ZnCKjcGfhW7Nd/SjH?=
 =?us-ascii?Q?5Vg/i7r+D/mAGbDl/WsmzeG9F0s9vkAeP6H2XEFQ3znBOijvI/ZOuhnngF1c?=
 =?us-ascii?Q?LGTUBgF1fHua4BQfbr84KvqEkD+ifI/HKfTDlJClxte5vTWkpEkTVWrgv7Aw?=
 =?us-ascii?Q?6EbiqrwE9tOIWKoh2MXQ2yUF94sNMf920hljc+10vQfZ4oEfM/9yMV+kQNx9?=
 =?us-ascii?Q?W036SPf1Sv7Vcpgy55m6+yPpq9xrI8Fm88gJR8ox2cYusS9bS44RdbaU4By6?=
 =?us-ascii?Q?DMRdpQt7iLYEZykPIFuPPAy/eApinGy4r4yH6cjIV+qx2h/RwENcmuehqyu/?=
 =?us-ascii?Q?ziV1IM2WquzED11ecrvHeGLsN+C76vmaYg22dNoonNWaTwUdmZ7EsqANz1cU?=
 =?us-ascii?Q?hLLKygdWqszXxrH0eBcj1O3f32zwgH9p+TF2Qm9toRSZ2NdqzhXSvbudZR0X?=
 =?us-ascii?Q?l7I/fPwd8/Oc6kzMOA2lhNWWaf6BFl9DqcxaWS8JVEHPZC2JYktREEEF0Qps?=
 =?us-ascii?Q?X2cduF1ugHmUEBWQSLbzNx6pjXub4Kf91B3pGX3PA7EwJJi2XFRx52yUw8WL?=
 =?us-ascii?Q?EVMWNQhANTYegq3eTGgqVgCDpupO2IiYarWR8ZMVYBSTMhi5RIEs2Z5YagdZ?=
 =?us-ascii?Q?SKvGPSCzzsqV/wNiHYoJ+z9kd0U9enkbYks+EPfN2JueSuC2sFVSqWkTpmw2?=
 =?us-ascii?Q?uFj4huTOfJCXBFfOaqF81SdWtaZzbnTq+cP2PBGoKkosbcNUxvqoCxiS6x8P?=
 =?us-ascii?Q?WIdcGeb7LAE0efC9vJcISCs=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <88311FBDFB27454F96CA1E761DC052C8@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?n8dhQSQy+KWH7OX+ci0iYkbGr8gYT30QejT4PvTsRiXqMkj4EKPvwcvFvdrz?=
 =?us-ascii?Q?IoRXNzjjnToPHB1M757DYlAhaNRN1i9lS/aWjXQNdaQFGLyAEaMfxi/1B7+K?=
 =?us-ascii?Q?OX9XJ1MhbG11oqQrcQyTyICHJgYgbDYGEHIpwG+vt9ZiIHctacdY58fI9po8?=
 =?us-ascii?Q?aFzS8Y+Fvq/NUp+Hj0ubECdRT4rQiSD93yJpmaZJbRarTbIOpt4dNEXhfXA5?=
 =?us-ascii?Q?dFmOn5GVK1eYLiKtbBZC6VfuclW2YBWuwApzm6isDJ8UCgCw6fJz2JxlsMQs?=
 =?us-ascii?Q?VrszNcVrpvWK3KyB5HLfV8JbnqJCG8QoHvzS2wn8dQ/tWbF9i4jhD9jhfXc3?=
 =?us-ascii?Q?Ou7KpyntUVgGnWxCACDzR0SD+4IDwny2fUQs1a0rod3s4Ox+vaSRvxYj07V3?=
 =?us-ascii?Q?Iff3cfrtnAjIXR9ErJFGBpL7QQkYfY1kcicnEp14bcuck81l8OgMBdQ9PFJs?=
 =?us-ascii?Q?Bf6BlTK0NBu0QKC+9fdIF5hWly1GfgNjUr37v4uxrQXAhA2zEc5vyQ/K+m3p?=
 =?us-ascii?Q?dqd3CkFbiPLA+s66mMZjM3rKpSyg0pVxFBWsNbhevzvzFxNF18uhTxuV1qDa?=
 =?us-ascii?Q?sUhwvS365WZl4HyL4w7hM7pkO++SiSE3n8KLXmsQZoP2+Uv1wpcBSs9pvxmf?=
 =?us-ascii?Q?bdgLqvQKhcY/Yqc0Ce5IhFmvgAv98SDDREa5Il07eE64GVl9TRR9HjiMCihu?=
 =?us-ascii?Q?CPFxB67ql11HurePtH9CeI001jxYNuThGXBpUcrYcrCuSxGIKW/e+ux5Guh4?=
 =?us-ascii?Q?oBAhZ/chI4URLYpMYxWtafEi6cJoceTLHpeIv+ws8CXZovA5ZhyRiikGDeFn?=
 =?us-ascii?Q?MP23bEpnCzTx9y3+pXfB8G2lhHt740Mjy+rqGm7sEdC9ofIRejpwc6UfSCFL?=
 =?us-ascii?Q?w0K1P/TNniTcsslJvdae4I4cVC5VzYPMnL4nb4fjQqdD0asZLTcKS37UbRaF?=
 =?us-ascii?Q?okYQXw3Iycd7jP3b7BzEXw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5433.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2183a98a-67dc-445c-f5d4-08dbce524a20
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Oct 2023 14:15:02.8928
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6yoCPSn6BVoFCI6ChN5qYzxPzL5NdjtGtWt76mgpedU0x4qbjHks6d2nqPodPNJsQtI/cjkW+uNmfDQxebK4Dw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4370
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-16_07,2023-10-12_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 malwarescore=0
 adultscore=0 suspectscore=0 mlxscore=0 mlxlogscore=751 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310160123
X-Proofpoint-GUID: XHsBHGqO8SApwF33BabBQ7cLlOdDvemU
X-Proofpoint-ORIG-GUID: XHsBHGqO8SApwF33BabBQ7cLlOdDvemU
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

> On 13 Oct 2023, at 22:33, Marc Zyngier <maz@kernel.org> wrote:
>=20
> DBGVCR32_EL2, DACR32_EL2, IFSR32_EL2 and FPEXC32_EL2 are required to
> UNDEF when AArch32 isn't implemented, which is definitely the case when
> running NV.
>=20
> Given that this is the only case where these registers can trap,
> unconditionally inject an UNDEF exception.
>=20
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
> arch/arm64/kvm/sys_regs.c | 8 ++++----
> 1 file changed, 4 insertions(+), 4 deletions(-)
>=20
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 0afd6136e275..0071ccccaf00 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1961,7 +1961,7 @@ static const struct sys_reg_desc sys_reg_descs[] =
=3D {
> // DBGDTR[TR]X_EL0 share the same encoding
> { SYS_DESC(SYS_DBGDTRTX_EL0), trap_raz_wi },
>=20
> - { SYS_DESC(SYS_DBGVCR32_EL2), NULL, reset_val, DBGVCR32_EL2, 0 },
> + { SYS_DESC(SYS_DBGVCR32_EL2), trap_undef, reset_val, DBGVCR32_EL2, 0 },
>=20
> { SYS_DESC(SYS_MPIDR_EL1), NULL, reset_mpidr, MPIDR_EL1 },
>=20
> @@ -2380,18 +2380,18 @@ static const struct sys_reg_desc sys_reg_descs[] =
=3D {
> EL2_REG(VTTBR_EL2, access_rw, reset_val, 0),
> EL2_REG(VTCR_EL2, access_rw, reset_val, 0),
>=20
> - { SYS_DESC(SYS_DACR32_EL2), NULL, reset_unknown, DACR32_EL2 },
> + { SYS_DESC(SYS_DACR32_EL2), trap_undef, reset_unknown, DACR32_EL2 },
> EL2_REG(HDFGRTR_EL2, access_rw, reset_val, 0),
> EL2_REG(HDFGWTR_EL2, access_rw, reset_val, 0),
> EL2_REG(SPSR_EL2, access_rw, reset_val, 0),
> EL2_REG(ELR_EL2, access_rw, reset_val, 0),
> { SYS_DESC(SYS_SP_EL1), access_sp_el1},
>=20
> - { SYS_DESC(SYS_IFSR32_EL2), NULL, reset_unknown, IFSR32_EL2 },
> + { SYS_DESC(SYS_IFSR32_EL2), trap_undef, reset_unknown, IFSR32_EL2 },
> EL2_REG(AFSR0_EL2, access_rw, reset_val, 0),
> EL2_REG(AFSR1_EL2, access_rw, reset_val, 0),
> EL2_REG(ESR_EL2, access_rw, reset_val, 0),
> - { SYS_DESC(SYS_FPEXC32_EL2), NULL, reset_val, FPEXC32_EL2, 0x700 },
> + { SYS_DESC(SYS_FPEXC32_EL2), trap_undef, reset_val, FPEXC32_EL2, 0x700 =
},
>=20

Should SDER32_EL2 be considered to this same list?

Thanks,
Miguel

> EL2_REG(FAR_EL2, access_rw, reset_val, 0),
> EL2_REG(HPFAR_EL2, access_rw, reset_val, 0),
> --=20
> 2.34.1
>=20
>=20

