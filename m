Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE1C276CC1A
	for <lists+kvm@lfdr.de>; Wed,  2 Aug 2023 13:54:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232731AbjHBLym (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Aug 2023 07:54:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232415AbjHBLyk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Aug 2023 07:54:40 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7463F10C1
        for <kvm@vger.kernel.org>; Wed,  2 Aug 2023 04:54:39 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 372AjIob002573;
        Wed, 2 Aug 2023 11:54:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=T/U4i9VRE4wrdUP+VXXPEU3IA5H1KvmjWs95YqaJoIw=;
 b=AYIYtrBNLai6ie3rqLldUwTSGcjAA7ntp6bxym6Kcof8TcksgtARaLMZj7hx5m2bUP4U
 s5Qhl4UY1jdIrJwgOZdcodCenGs03eMY7CWsMRiSp/DNZZL1QOwx5zkcRFjO+d6WHiBd
 0tH95lm/AIF07YcRdhuPhwMuXVAXNbqp3TcTJ8AdbBqJ8x+cAXYya8hWUpGCTIT64f38
 MZpbIvdE+cwBRHpD/BoiYFJUtmOl81XUr7W1noq4DvQljP9ZsHJmRgd4Z7oppjnXzR46
 QxS2vRi083FwyJbvvBMxvZ9o9T/2i9dYoODgaVBoZxW/7NzKwpnATRcsDr0ZDRnLJtel qQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s79vbs3qw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Aug 2023 11:54:16 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 372BiWe9006676;
        Wed, 2 Aug 2023 11:54:10 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2046.outbound.protection.outlook.com [104.47.66.46])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3s4s77un8w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Aug 2023 11:54:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AqMtN53rwY/J+o99aa2CgsmNolDZ7t/2pJDHyDq9KdH5voda5WUx0xfQXhOwTReymfGKLUJKDctzYoUWh5sMZBwGf1SfQSIde/iHbHlW6vBRWabwxDKPvF6U1NgYrMqT4tFCDwdRR0hfAsvvruDIcDidiHTAr1gZvvljyOten1h2YLq39qm1AZFHfgWQG2QbweHRAqUNKYZYT5ktN5Fgq0V+JM8QDhLYqMZlSNA+Xz5oxmUE59HUpSXn4HXEzuHxeZIYrhylJ3St+j4yTe98PktM7jzm4jehCdxGZxQye5p5dG1o0uTfZb1umHSq0lFHjj+WpK8LFTsAUhCjdyuYAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T/U4i9VRE4wrdUP+VXXPEU3IA5H1KvmjWs95YqaJoIw=;
 b=a9rhSjFDZRb+09FWagLWOozyGTyKU26NDFuErDiSuk945psUutpgo4+ROmDCU5Tg15EGJbGxbtdHPAb8Tmls97HOWWtTIBN4YOtX9Gbqtl0UISnBlRfl48CVnU7mK0Q3DG3z21qvQLAVpfppZGzlLq/Rw64cXw8VIfev7s0hFPeDg8UR8DB+pSavFw9rH5jegNoDpO2jU687ABeBCiFu6tDp8EgstarVenUTf2JJrmCupMdpy5x3PAEZfgWRRXvsSORsH++aVdx95mOtVTjchm9E7jOPOO5gv13bmuoWqmjWJv/lf/Xr1XfKh1mdk9BN9sOg87PLBgrnKrUWyp/9Vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T/U4i9VRE4wrdUP+VXXPEU3IA5H1KvmjWs95YqaJoIw=;
 b=Z6xfCeHoOftl82xhJ5L1fTri9CB7w7hL/klAaSN5Q58oFZQZUAoZxTVkPPvrA1ZzYepbyUcdjoLa0wzoM8mrw6WHIoELRORFB+nAMPN16+vrrCAiSwaPFn6wKZXZwzkb+PHIHF4Q9m3c3Z2iJXMHW2uuaM6H4FkCDe6L1uSeFC8=
Received: from PH0PR10MB5433.namprd10.prod.outlook.com (2603:10b6:510:e0::9)
 by BN0PR10MB5317.namprd10.prod.outlook.com (2603:10b6:408:127::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.47; Wed, 2 Aug
 2023 11:54:07 +0000
Received: from PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::76c:cb31:2005:d10c]) by PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::76c:cb31:2005:d10c%4]) with mapi id 15.20.6631.045; Wed, 2 Aug 2023
 11:54:07 +0000
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
Subject: Re: [PATCH v2 09/26] arm64: Add feature detection for fine grained
 traps
Thread-Topic: [PATCH v2 09/26] arm64: Add feature detection for fine grained
 traps
Thread-Index: AQHZwS24iRB8D3ukO02JMxHhdlVpK6/W7aoA
Date:   Wed, 2 Aug 2023 11:54:07 +0000
Message-ID: <D3B99600-27CB-45E4-94F5-58249C91D4FC@oracle.com>
References: <20230728082952.959212-1-maz@kernel.org>
 <20230728082952.959212-10-maz@kernel.org>
In-Reply-To: <20230728082952.959212-10-maz@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR10MB5433:EE_|BN0PR10MB5317:EE_
x-ms-office365-filtering-correlation-id: 7a52386c-3a56-46a6-53fb-08db934f2d25
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7wEQAtSUItZMgP6r6XazqNHttkvr7gozv13YS3zQxZ9fFBZRhUWNDH2uPNa4yUKWg2VtXiMklN7Sw7R5wsJUxuH7CkyFbyFZ4vSZyc9fcTNrlgaVWLxcF4do5pUZo/VXFRBWgzer9JXfnyr/HcY/Va/YwzyK3np+hzWqQU0+S3u5F5uiN9792G6r+AaIl81eMyNvmgGuK0QRST+VIB0tA8geQF3RXPbnL4miIzZS0guNf1t8KvsDR0lbsY+uoC6JtstjzfQB8cbqZZi7GwOYRFNB/PUWS8ivJ3nRr3SgdPUwvHuJtNOEJfhCecQicKm1i1l2vsi9oYoAAZNYqz8EyE4saaTvU57By91a3u1LYsU15wu9uadfXc5PVHJbDq+IVuA3+5dJjzG25iI8TeuRiZZ4Zpx/80+OWqvSkifFi/EFvgjcN3+NCSW11TkGkZzxYazBOclN49Go3VJYUlZDeTTrMTNuGazubHuIV81kKj3QBTdZf/4Hvhp8cZHrnv/R6+MaCIKsPErko1EkJO2esfpAVS75Ci7sfX9ElFmQCYm5/q5m8M3Q/qRkXEAzt23qZGE1DFnnsiipScYh3bS+2Y1x1GThUmxsmhm1OWbXm0SdW+qj5WV34oIEJgh10GIsIDho/ZFi10/Feni890umDg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5433.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(136003)(39860400002)(346002)(376002)(366004)(451199021)(44832011)(64756008)(66446008)(66556008)(4326008)(66476007)(6916009)(66946007)(91956017)(76116006)(2906002)(38100700002)(2616005)(122000001)(53546011)(186003)(6506007)(38070700005)(7416002)(83380400001)(54906003)(86362001)(478600001)(33656002)(36756003)(6512007)(966005)(71200400001)(6486002)(41300700001)(8936002)(8676002)(5660300002)(316002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?rrDlcNe5O3u2jvrmIshiu0UiP21QPMJb2wgeDJhi7JYcDVEJsVvRjOrtMJh0?=
 =?us-ascii?Q?TWVa8jlLQEVSplISzJrOT+BnLt6p9PZMj51ethlc46OX51ZBRACC19z2tioS?=
 =?us-ascii?Q?ml9jNEnsXxPFa1qfeEyaT4GEYfxxEutHuQSxzcELBzSxWouuevdA6jDlArVz?=
 =?us-ascii?Q?fn7yJvDsI8YtkvtzOJiOGZEXzAxPFp6HPqV8zUWUfvxdktyVNBDYzqLOr1KV?=
 =?us-ascii?Q?2TyOReijl8TNtSSnUZXE9+S290sH7qrxNUSrRp2xnDj3ANgW6JfBxiWCCJ2G?=
 =?us-ascii?Q?WjqcBICZRx0Yq6N8DCq5GgPVN8OYi/QIoip5XXtRrLADns7hzmZRJ3eus3B/?=
 =?us-ascii?Q?dukUCyqb29M04JUqYhKDBb6nmrK07IxMgAfX+hGbBQ0co7MjuMsjjtZFsTOD?=
 =?us-ascii?Q?oLpWCH+dMhLjxzBHhJ7HSHcJPNYaJuFjC+k0w85bj24vDEmMmKdzpxCFJR94?=
 =?us-ascii?Q?TC7145w7YULJfdBx6vKHcHkgMNtcGKZqO1yKO8SyGR2cgw8nMzGxMj1fVsgq?=
 =?us-ascii?Q?s9qcwj4wwXntTIIlePEL1cYmTrqZcX2tlZvTOx1zggOT/xNBbjZEGuKWxCYW?=
 =?us-ascii?Q?4Y5Emg3T8hrY80k5sffxzbYAksUKRexEslOegAeHKP2/jJiBFi8s2z5tMfvh?=
 =?us-ascii?Q?i1s5pEo/lWKsUJDUUWgx2chwO4+91xByuYFgSUeuKlidF/YOa2Ul5WcW6oUr?=
 =?us-ascii?Q?8wEVckAJUrneRDwuIm1rJUT8jufGEXBxjZLsHdZZbck51JsQcR99kge9Zbya?=
 =?us-ascii?Q?EfsTVAWcZ6c8qil+fcgkzOOErsoLI6mN5Xq2xLbGNEjePqAOz6+tHvQ81gA+?=
 =?us-ascii?Q?QMK5Ebh4j8AgWB9JJ1AGJQejXkfPjgHQM7rsz8PK7iRBY2S0hyTNFQPoZ1Fz?=
 =?us-ascii?Q?PudUBxen3H6qDvAauJOskvQIl/5/9QMaOWnA08OVKxqQ3G9RBmnd1HmdNu4O?=
 =?us-ascii?Q?jmYkLEsiompLfPcB6uu1jZkZSDCPP4o/YVhzuDnAMfqWi0IrLg3+AUtZZ/x7?=
 =?us-ascii?Q?eCKAlk5wEzlRMnRJu/BJAUw+Is2HPyTdTsvXbw/op57Y9tB39kNnL8f1GI+B?=
 =?us-ascii?Q?HIovSq6M0UNd8d1lVF9gjR7efG+LoQcBV2iMjmCf26SoUP+zPx4Mchq0qf+l?=
 =?us-ascii?Q?E3mu/aQJmLm/AqgqV/yZKhQC9chI1ue4B1kM54xU+3qYvX7xiFLehNIWU7ey?=
 =?us-ascii?Q?QnxX2cMWnCy5iyqHZNXyEBCgur08n+6HeEESS/Cg8YgiXKlVFTa4v3wQ+xIG?=
 =?us-ascii?Q?hBvRUXzILPWDwfDvRyW18h4ea4T5k4z85UngeQ4ffSCDd0W+DgYVc5MfQnn7?=
 =?us-ascii?Q?8P/mQw22TVOJajun0tlZYsqajNGwQPJ2M7xjYBZo0gZHU8S6+a+d5rxEnO65?=
 =?us-ascii?Q?iOMkQjf3cG9QUAzJBD+ZVx08aC9Q8NDLIec8ZfAea3yYq3w8osrjYbtHQL/x?=
 =?us-ascii?Q?rotILK4B7n20n+ktGuWJ5qwQXNL/d0flAXAcyshkDEWWvZB5jrPI9YmH3EjY?=
 =?us-ascii?Q?UDQnLzDeIQDTgLrwo5lltFowXeirr+iqiaai/0zW96mDU+RtVZWqPmLroeVS?=
 =?us-ascii?Q?zCidhVOw7AZWpaqqOTPVaaSN4fboia6bRVtOBtMGGE8tMI2XVauwOi79Corb?=
 =?us-ascii?Q?SD5izWVH+1AvZFnyGVFk5ts=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5392E2273BD42A41AC1720F8FE33E86F@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?hlBmZ8xs+N1vmLDVzpgyn8dAa4vsHF/T33lgbquD6Gq1Hf/62WVf2g+RLu19?=
 =?us-ascii?Q?VJtDNcLQqZZmVbbJFDk4frSh/lXsTIJfO24jVQjWyvgY/bWbBLxrqOP6pBl6?=
 =?us-ascii?Q?r4b6xjRHUIZPWhGsK04Hy2d0YgbCz0vyB/Wi+4l9G3TlXTzTbXjGSKbKPFwi?=
 =?us-ascii?Q?ggXrxOocn1u67F2Z+ACe/lCXL8ohkeLH0ZC8E/T0ldAvyfjOPNNt1negXj6g?=
 =?us-ascii?Q?xZPEnAH0nGo707ozQ8lun1q0R3Dj+EQWyQ/8a0D534KIAv+FBH6n5BUxDd2c?=
 =?us-ascii?Q?1jr7v0CkHQz4cJnbJsku8UA6Wsyvvf4748Jfw4/rzxbpceWGcm5HfK7rnvhX?=
 =?us-ascii?Q?4WkRvheP6xXayL9iVXbdoaG0VncLcGW0ZWYtHRQzUm3nqRYdAdnkiDB9W0aV?=
 =?us-ascii?Q?5MXU+hoZUOxrFYm9l3zGRBtpYbEweQMFtnPrMB3RWQ1L37b6lcLZx/2XrXuI?=
 =?us-ascii?Q?H5qWh8XNsm/FoveMjm0PAiDCSMUQOS0SXbhkeiOnzNNz9HFuXZ0wDdMTwOMB?=
 =?us-ascii?Q?ab2G2rQ1jBSDRe8iNBCLmddwBr0uTUdWZL+J9LpoH9iBRcHyxgjZ7fINjzuZ?=
 =?us-ascii?Q?8YulL0NxlmDno8oB/4yjMu88kJiGnHYdXM7rWQr+YQobVXusAt9WPDhRsT++?=
 =?us-ascii?Q?wUGpbBECSB0gRlho6hSuLwsf+YrZQ46TGDyWcCHCDy67KFBcSovsjA0veKY3?=
 =?us-ascii?Q?i9ktmRVo6iRUueoIrkBmWs/mkD01xTTF5WX/J2VYYNXxfVZ7+9SQvMDiui00?=
 =?us-ascii?Q?EXbiVPfueaIhuZKzU2NGeZp3Y5vlNFy454xf255kKvqreXnw7qMVUHLUBUrI?=
 =?us-ascii?Q?YxeJbnlPG8MhmdW4RyNNtXTGfznRFPlYrbNKO/unhX6lXH/d1eTm0Dke3oKd?=
 =?us-ascii?Q?tqPurNAjNnPZbkvxKQz7ViX4r2X1XvqhpMYjno2MVs6pnO7Ez35L6Sc5xBgj?=
 =?us-ascii?Q?JrVbjDssl3bNINjCme2WR0x4Ve0CWOiDuuHdssJZaTe6qLPMZjZnTNavp5GE?=
 =?us-ascii?Q?UkVI6nr4o/rYz3nwNrqLsolCiXWzFjwVHW3b4Rr70Xe6P+k=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5433.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a52386c-3a56-46a6-53fb-08db934f2d25
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Aug 2023 11:54:07.2041
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: q9IaaB7vL3EnYayq+o7VQUvhyeoD4MrtTsy0WNW5Gp8aMjcT/rRL1iJLqyesDcGYdLeZjZckKpsVSDFQl5liVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5317
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-08-02_07,2023-08-01_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 mlxlogscore=999 malwarescore=0 mlxscore=0 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2308020106
X-Proofpoint-GUID: cVVYBhi-BjgCjv26TLWdoDu5VDQeENH0
X-Proofpoint-ORIG-GUID: cVVYBhi-BjgCjv26TLWdoDu5VDQeENH0
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
> From: Mark Brown <broonie@kernel.org>
>=20
> In order to allow us to have shared code for managing fine grained traps
> for KVM guests add it as a detected feature rather than relying on it
> being a dependency of other features.
>=20
> Acked-by: Catalin Marinas <catalin.marinas@arm.com>
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Mark Brown <broonie@kernel.org>
> [maz: converted to ARM64_CPUID_FIELDS()]
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Link: https://lore.kernel.org/r/20230301-kvm-arm64-fgt-v4-1-1bf8d235ac1f@=
kernel.org
> ---
> arch/arm64/kernel/cpufeature.c | 7 +++++++
> arch/arm64/tools/cpucaps       | 1 +
> 2 files changed, 8 insertions(+)
>=20
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeatur=
e.c
> index f9d456fe132d..668e2872a086 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -2627,6 +2627,13 @@ static const struct arm64_cpu_capabilities arm64_f=
eatures[] =3D {
> .matches =3D has_cpuid_feature,
> ARM64_CPUID_FIELDS(ID_AA64ISAR1_EL1, LRCPC, IMP)
> },
> + {
> + .desc =3D "Fine Grained Traps",
> + .type =3D ARM64_CPUCAP_SYSTEM_FEATURE,
> + .capability =3D ARM64_HAS_FGT,
> + .matches =3D has_cpuid_feature,
> + ARM64_CPUID_FIELDS(ID_AA64MMFR0_EL1, FGT, IMP)
> + },
> #ifdef CONFIG_ARM64_SME
> {
> .desc =3D "Scalable Matrix Extension",
> diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
> index c80ed4f3cbce..c3f06fdef609 100644
> --- a/arch/arm64/tools/cpucaps
> +++ b/arch/arm64/tools/cpucaps
> @@ -26,6 +26,7 @@ HAS_ECV
> HAS_ECV_CNTPOFF
> HAS_EPAN
> HAS_EVT
> +HAS_FGT

Reviewed-by: Miguel Luis <miguel.luis@oracle.com>

Thanks

Miguel

> HAS_GENERIC_AUTH
> HAS_GENERIC_AUTH_ARCH_QARMA3
> HAS_GENERIC_AUTH_ARCH_QARMA5
> --=20
> 2.34.1
>=20

