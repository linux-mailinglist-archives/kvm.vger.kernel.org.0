Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F39AD76EB48
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 15:55:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235452AbjHCNzq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 09:55:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234127AbjHCNzo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 09:55:44 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82BC8196
        for <kvm@vger.kernel.org>; Thu,  3 Aug 2023 06:55:41 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 373ChDsa011653;
        Thu, 3 Aug 2023 13:55:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=3DJWIeOqcUGFz09JMTONnDSxhkQbccaolnrv/s+GKi0=;
 b=f90sMgnpAgW7QBSTe1SUbnf5qVMMLCp1orH2F1BK/J/7TaDv9CWJB9UNtvArg/WecSNO
 f8f3PvOQ1R/FDpHwTdXHJkrhheEInOw+XXPxFU25msVKbDfDrIKJQc/7/PKc2VhNMBiq
 PzKdzv/s6phlAo6jdvu4jkpoTlCwxsUfOwl3E9aXXkhPYkOLEG3MrFHfS2lFYwe4q3rd
 BayOtrj+8xscs3gkJTB6DsMUauUGIr8VQ8CvM0dXcQN4zeBJxoSFieJuYIEndomEz3fv
 Cb+n6uX//sWEwNCKrOYWJ26eHv9NA03VXUJLKVmm0IM+FQRFoDoEc2q+gtZ53MwRMkXf dg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s4tnbhnta-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Aug 2023 13:55:10 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 373Do6B0015688;
        Thu, 3 Aug 2023 13:55:09 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2173.outbound.protection.outlook.com [104.47.59.173])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3s4s79n4hr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Aug 2023 13:55:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l8O4AZluHfLVU98e+lI8wQ6xTBckc1eENiEA83VXibYr8euNekfQZAiQVFefV7VVR/IYjFe2w1sjOTdqY5S9aW/KDrSCCimGb6Nw0yrrQj+8GylHkqEhGkkFPfdzuDZn33ADUS9UmOSUMDFrpMAQShwcMXm9p2uHYsU6WpIA1F0eUV2ogPKRjznTmCpaP0VWvrnEsfNRdScL8sMR03fPo0Qxb4pO6tV6sYu/nYHw3ZhbpoSTFB1902OU9c5Q+OKvwfeARTo35gWLAjEQFMGOQfWfocjh0SSO3LvWiIJ8SIrAuh2NKByGZbAuxgNFX0AbRQlBln8O8ZNr4LMf51SLFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3DJWIeOqcUGFz09JMTONnDSxhkQbccaolnrv/s+GKi0=;
 b=VMmvebEw+bv1tXYOaV2fuTWInFe5C6Uhin6D0RsbzjD4kw2VZCoxhI1w4UU0iyjQfqsgqNx6IFjsX5pjI+viXsMu7xq87Ikzxolm6RhTuxqWDWb7e0ZlzL6+RSHZhV+7bMloHJXN0g14uCuyvYeee7wpB5mGglhRTpcDatmDPsT1dtCqXLxR6QokQ4W6U3lOweMXkeEaH61FjxfoqjRQTcDXjakZ/iEXPUZKLs5Ctwq110iuKiNeA+Nk4hAvVKuCulI27Z6ACsgxSLkJFskKj0sbUNSlM8MDzCFCJVB3b6l8LcrhfJJnX0w59TwNC0ENANshW0V0jcvSQf1cUrG5jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3DJWIeOqcUGFz09JMTONnDSxhkQbccaolnrv/s+GKi0=;
 b=VckajWnN8Q4zQSp7+tyDlQM7Biy5XjWcglH1Fv7K7aR50YyYDBrlxyU1wcSE0pJ96ifmSfebiP4yUxDi2GOfHDOnqYSbp5yL0ugoPXsuLFufowYFqN6JJOJZFXEJdUw+Bm+tLxIicCmI5l5I3eYsxvjbqelcpSAkU2Y/UEJQWYE=
Received: from PH0PR10MB5433.namprd10.prod.outlook.com (2603:10b6:510:e0::9)
 by SA2PR10MB4649.namprd10.prod.outlook.com (2603:10b6:806:119::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.47; Thu, 3 Aug
 2023 13:55:07 +0000
Received: from PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::76c:cb31:2005:d10c]) by PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::76c:cb31:2005:d10c%4]) with mapi id 15.20.6631.046; Thu, 3 Aug 2023
 13:55:07 +0000
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
Subject: Re: [PATCH v2 10/26] KVM: arm64: Correctly handle ACCDATA_EL1 traps
Thread-Topic: [PATCH v2 10/26] KVM: arm64: Correctly handle ACCDATA_EL1 traps
Thread-Index: AQHZwTAiPt/Rjwrs9E288p2+Hmw97K/YocmA
Date:   Thu, 3 Aug 2023 13:55:07 +0000
Message-ID: <5774FF39-A26C-4F4C-BEA4-431921EFDD07@oracle.com>
References: <20230728082952.959212-1-maz@kernel.org>
 <20230728082952.959212-11-maz@kernel.org>
In-Reply-To: <20230728082952.959212-11-maz@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR10MB5433:EE_|SA2PR10MB4649:EE_
x-ms-office365-filtering-correlation-id: c1cf8c07-fd3f-4103-a03a-08db94293ec1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4UGah2WckkkHOy2yR1Oz6kJZVSzDCYpw8448Bxy02jecZe4Vqk5veCnm6SMxDv/WFeqMOBF51p/HF5pU49upDP/xiKNuMlDFvDoOcJ22qNHwqNZnPulkAuIKviWZG445YqiB2FzHHFt2YPm6g//p1QO7prf1wV8uVxVzCvceuXY7YJ8KHqYBVBx7Xg6q24EvXBYk3NDsju+bGWlUlAbvg77HfCu025QJ9hfLVurTT7PW1MGBIVlnBvkPq2YYi/CBAFgEeeuiH8e6ZWZOFeUjxCS3zYgzX5T6ph0y/kDXJOFjYBCM9cY9XOyTvi+2AwCWX2ByPzALYz1xSOCR4PiH3SwiXVPew3AlUKvQn9NpqKiqMXbg5W0Q1HOv3vwDJbBrsBM2PMRXz0Egze9LHaL3frXnTYZ5rfaBpPMzZvBUfubK9tKnZ3sWuENtPUSdHUX2WI5a8Ra63Z2zCd+wP1FO39gqz7UNDIM230pnZx1d9xczic0zkHZnya0tH5Xu1SmE3WpANcGlZq4eUWWqUcEWGdA6nRUzjydtXLFUBFS3RuUQp6x2tgNLvBOtEwWPiZDkIVg3+kAbbv5bQc18H7GtBc94Swr7pXMgFiq7L/+i+vPhJTzB0/Jfk0FXhG+bSt5wxb4y1OsqK1psiqDez4SlAA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5433.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(366004)(39860400002)(346002)(396003)(136003)(451199021)(36756003)(38070700005)(86362001)(33656002)(54906003)(478600001)(38100700002)(122000001)(2616005)(6506007)(186003)(83380400001)(53546011)(8676002)(8936002)(44832011)(41300700001)(6512007)(6486002)(71200400001)(6916009)(316002)(66446008)(66476007)(66556008)(5660300002)(4326008)(7416002)(64756008)(66946007)(2906002)(91956017)(76116006)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?UhCZGUemyit7G2fPHtD/e57jdPvtiHIcAswjc/ma9CDNDF/4RXrRp/GP1Zk9?=
 =?us-ascii?Q?ag3pOEFqNIXEYL23BJx1a2iYb2Wp/qmIXh/vli8G3UOc+EdjY7gd//Bjrudb?=
 =?us-ascii?Q?cpyB1i25WXWtB3aWyy+rSNsV3KoxE9zrdNf04ou5pJwPNKyz9VVJcbVbN8z/?=
 =?us-ascii?Q?7K9m84HCq/yWjSWfZwkc6ZChk8TaZ7rn6wprRMhdv33mfo9akVU+hxWiDnbi?=
 =?us-ascii?Q?k1fcMyQn7t3RftF63USHl0ovXMvZ+/DErLaFylyivC9OxNmd6HoT8oPn2uhj?=
 =?us-ascii?Q?xUdBbCnTRttO6kWsAomuh3/+A3pMNaMNYulscZDgv8lSW+klLadKGLCa0qeh?=
 =?us-ascii?Q?tSpOPymJWWUUYSgbwq/zGVnexdxiOSvoDU8ADJws7UqnzURzNo1CLbhfaZH9?=
 =?us-ascii?Q?P12jkZJOCyLEEaWXYRou2xV2yZIKLVgMbAoP/oURw2d5rxpLHeggJhslQjeb?=
 =?us-ascii?Q?8L7qQrmOEU0veh6C+ibVUal8UyhAKJ3Ft8iNQSN4Ppe8hg0syDqlGeAiQtdm?=
 =?us-ascii?Q?S8JeRgso63imugjN5P9UOvwn8SSoMKRs3csBzluTFreFYBfFg4V6XYkkCVMx?=
 =?us-ascii?Q?6sUxGE84VkrCBNwI81aE3p4mO1qwpaiSDtfHJ4guG5trSZtJWhvddEnCRZ/S?=
 =?us-ascii?Q?uNaOe9NoXKNOyflHGarX2t7miu74xWRZspTTRfyRXDxb9DVAEcdyID4T53X4?=
 =?us-ascii?Q?AL4Ksw+HUQxunKBKbPEwhV/u9qaLG9vY4D3IVF0trp3/GxbNS8XRerdGCCxY?=
 =?us-ascii?Q?GLW4CS82jfJhwLurqJlwhSeDPsBWMBqgQ4wB8Dvetcjx94Qk31CkRu/gGukK?=
 =?us-ascii?Q?yW4iJpuUE0b3iGoTPkAcGFPDRJ61EeVA7Dsv8qbmIR4XeFXIzR+q6sGyNw6c?=
 =?us-ascii?Q?UtTLZUL0nRaYCQf/EQfAD4TVVcvHVoIqsrLZ5OcKUdZLRx77WhP5aUaHUxwV?=
 =?us-ascii?Q?wQCumvjjbNWMlrw19ircqkXNSkManEocVfgnYxbMoMWigsPxzq6xuDI3jfGa?=
 =?us-ascii?Q?FSseyNFAKXWl7fALrwvB1uCv7Xr09d/sla2q262vHaKfIR6EdT6SVTn53uQo?=
 =?us-ascii?Q?10bquwqOhJWJCpTzptP7SlcxeAbVaKVdLLeQShXG25B3lz0ODIF3LJUe2cVU?=
 =?us-ascii?Q?UU0sOr1IbLWEXJzPtJ2a+UuFtGIVGKeyWqhWJbMqqfLY3gLXEyPoWYiLT8qA?=
 =?us-ascii?Q?hWuTRAhrtxPqXulLSppv0PzsvAlltiuonKP9VsrOve10Y1QqJmYBfV8O+UtE?=
 =?us-ascii?Q?aEDq7pI/Q/srzfbP5wY4cqhkWhgFzNT0mXPeeHTFvTOpERlYfg73lrWKenq9?=
 =?us-ascii?Q?5v7+JDnn2X/Ys/2c6e3AxcYcb56/Nzc3fmsONjBwmf2W7J2SVkiV0o9cB5pH?=
 =?us-ascii?Q?O3K46qB6rr4NEwtQTu7Mza5Fvw11sYUZlmtqbVV97BTBwECYktywdcon9VmY?=
 =?us-ascii?Q?VQZVJ8u+iYgkKN1l9P8tC29n4hmEFtGV2S7f/S71sb680O0ldebpiVYqehnI?=
 =?us-ascii?Q?8XBg0tMRO/Sqqyh/JNQyneByLzf6RbiywB9aEQlvBhdJf6j6q6rCvmiMRnuQ?=
 =?us-ascii?Q?iOff+zcIOxXrI4N4vI7alEm7ru0AY5OTHsPPL4ZcBZve+3rsN1JRrZ3+DklR?=
 =?us-ascii?Q?4UvlwwE2XNT5LVLKdW3yppY=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <193656710CAE8D49B4AABACF0238605A@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?QJ4q0SyAY/eYdkqG8oaNKCc540M2RoeWJ7biONjZ0oWRs9jQyQFbavDgHclN?=
 =?us-ascii?Q?wDkMKR2LPbj5noTdG/Hzp0yfUAn+Qjoa6PPo/JH1i0y6kKpCodAjfPVDXyCP?=
 =?us-ascii?Q?uDOoq3TbWiFY9qDcw8O5mO66aUqKj0K2B31fS1ap+r4ky9uYMBocD1jRmNZ/?=
 =?us-ascii?Q?E5mjy0D2l9Cxmmc13PdFeW4jIAwKcsfMZQNPQ2zhH/N6/8SsoeRD9akuc6Yk?=
 =?us-ascii?Q?GiAPwagnC3uAD64YVF5FttmNLX8bagC2Fl1kecZtaMa698qpXUDHgynP/vcO?=
 =?us-ascii?Q?nnt/Tejr6WnA2ubeFB8sMWu8VQk22enQyMUK5h7A+FAuDIba1l1YZgIU35xy?=
 =?us-ascii?Q?8kEdZN6QdbW/DwG09hnRw6i9KwXYg0gCOdgfzMEuECyKxy1MVkkv6Qo/t4Ou?=
 =?us-ascii?Q?N0qtNuyYRjN9T6JpIL2eyrZwAAkT+R3H6qxec0TbTVCVjUzDozdd6AWx6dgA?=
 =?us-ascii?Q?EzJIOh6i03mIzPiCt/apavvf7JFvLXiMlh2hJXjVlD1QTlz5+nWejbzHspKa?=
 =?us-ascii?Q?jv+CmC4dxV7C0qzjDsyyXeWt2NTOFBQYoOmDjhGF8P22Fwz8LOc/7YedkZgd?=
 =?us-ascii?Q?hvN5S9mktMOj4xW9yys1FagjelyqSL/2D7enYrxqaFKOOdwK/gsI6Lv3m4GI?=
 =?us-ascii?Q?Y1Q+Owhy9VQPLaOHJ8DE+29CSHRkSR12TTqNiJcXZIRJO7Vd/pUfqwpSDZtr?=
 =?us-ascii?Q?U8KyyvhU6Y/C8p45+c5RV5F/poMtHyEVOX2xAWoPqVO7H5bi5jLxY2kWNxkZ?=
 =?us-ascii?Q?Am1dDpvkELBWJipaD1YfuQKGSqR71oQIzeM0i8aXvO87jjzhYurAqtKU82eO?=
 =?us-ascii?Q?q1BxSJMeDLwHQCi1VunweepXt/lFk5zP9ST+Su5/bjMkZlUJtGZeAK5ovsr+?=
 =?us-ascii?Q?B1/NzJ/qfrrL72S1dBbUHdCybcGlUCovtP9DpI87xl6YUJwntrdqUYOqNoO3?=
 =?us-ascii?Q?3Ikp2hJgWNKbgqiqtMIOHeQxZvyLwj50GvCbo2vHhW0en0HpEsx4SiTZ2FHr?=
 =?us-ascii?Q?JXBG6y+Ljqb8hqwjNbFqO5QqoCfjf5wz1l2ELduQkbRKSSw=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5433.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1cf8c07-fd3f-4103-a03a-08db94293ec1
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Aug 2023 13:55:07.0106
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4g39YWUa+dFmgPl8vrW4IIyfXLijN40SmuHkIzKQ7vvs13gnr5cqqtk1ZVIpAHgncP5qAltm14AV09PKW1u1yA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4649
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-08-03_13,2023-08-03_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 adultscore=0 bulkscore=0 suspectscore=0 spamscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2308030125
X-Proofpoint-ORIG-GUID: myEMWN22mJbRrxZdZbZ25r2AiTkl9VzF
X-Proofpoint-GUID: myEMWN22mJbRrxZdZbZ25r2AiTkl9VzF
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
> As we blindly reset some HFGxTR_EL2 bits to 0, we also randomly trap
> unsuspecting sysregs that have their trap bits with a negative
> polarity.
>=20
> ACCDATA_EL1 is one such register that can be accessed by the guest,
> causing a splat on the host as we don't have a proper handler for
> it.
>=20
> Adding such handler addresses the issue, though there are a number
> of other registers missing as the current architecture documentation
> doesn't describe them yet.
>=20
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
> arch/arm64/include/asm/sysreg.h | 2 ++
> arch/arm64/kvm/sys_regs.c       | 2 ++
> 2 files changed, 4 insertions(+)
>=20
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sys=
reg.h
> index 6d3d16fac227..d528a79417a0 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -389,6 +389,8 @@
> #define SYS_ICC_IGRPEN0_EL1 sys_reg(3, 0, 12, 12, 6)
> #define SYS_ICC_IGRPEN1_EL1 sys_reg(3, 0, 12, 12, 7)
>=20
> +#define SYS_ACCDATA_EL1 sys_reg(3, 0, 13, 0, 5)
> +
> #define SYS_CNTKCTL_EL1 sys_reg(3, 0, 14, 1, 0)
>=20
> #define SYS_AIDR_EL1 sys_reg(3, 1, 0, 0, 7)
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 2ca2973abe66..38f221f9fc98 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -2151,6 +2151,8 @@ static const struct sys_reg_desc sys_reg_descs[] =
=3D {
> { SYS_DESC(SYS_CONTEXTIDR_EL1), access_vm_reg, reset_val, CONTEXTIDR_EL1,=
 0 },
> { SYS_DESC(SYS_TPIDR_EL1), NULL, reset_unknown, TPIDR_EL1 },
>=20
> + { SYS_DESC(SYS_ACCDATA_EL1), undef_access },
> +

Per DDI0487J.a, adding ACCDATA_EL1 completes the list of sysregs
that would trap with a negative polarity bit on HFGxTR_EL2.

Reviewed-by: Miguel Luis <miguel.luis@oracle.com>

Thanks

Miguel


> { SYS_DESC(SYS_SCXTNUM_EL1), undef_access },
>=20
> { SYS_DESC(SYS_CNTKCTL_EL1), NULL, reset_val, CNTKCTL_EL1, 0},
> --=20
> 2.34.1
>=20

