Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44565766AFA
	for <lists+kvm@lfdr.de>; Fri, 28 Jul 2023 12:48:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236010AbjG1KsD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 06:48:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235916AbjG1Kr4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 06:47:56 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 106FCC0
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 03:47:54 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36S2BWg2016305;
        Fri, 28 Jul 2023 10:47:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=AN3IOo2yc1RfFo9ZtZMjgy5wjIzjLTVDu2RcywEkqDY=;
 b=DLdRefMB60JQBMkAPmLi5dhZyk+tz6+YctP6ajaLEkssyDVNNQkoItPYFr4KB2BXGljU
 2iJr3wTw9WMYgx5SB3nQO1DVnI8GbSjjB8QkoiD+dMP42yISqcAB8HMphchk3rMzkxUK
 i+pl6yrCeocoosiciflIwCGlHhqvi916S8mlKEjE3NjPSVbCGPw0Z0+ts6hdTt1FB5sY
 YyWS+ZW5XD7INXgBnhhMNE+Wsb2rFgSsTfnyMQ/vLzFwDtqGDVvx2RGdcYlREmhR3nwU
 iD9Gxc4EmyZwQgg7Ka13JOxCLG8S6Y3aFZ/Q2m014IeH2mc94W5Vo6Q55VbHktLOpv54 oA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s06qu3kqy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Jul 2023 10:47:24 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36S8xNxK030480;
        Fri, 28 Jul 2023 10:47:24 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2046.outbound.protection.outlook.com [104.47.66.46])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3s05jf69h9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Jul 2023 10:47:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R78TDqwBibohclhHxhfUnoPw4PM90EXizbQy7acIllP9lcXV/HbvmKWGh+uDwg0w43uJJ8ZgBNlMDUTCZ2c2UToL/0crvsLgIB5X1k8gI8GfCjOWsDiYsJzmYyK/3qkXVUDvSfyFrYmsacR2sKm6oH7Xq8pn7QoydZXyAp4eax7XRObXIhELroX/e7B7gUys/5GLbZdR41NiavS1hEq/4PlEQV4I4VgGKEV8KIoZ0pPi/TNqJ+0Gnl/P1qbRF+V4CEr6V+pyGxm6XNJNjj59yuU1iuI4+uo5iHZQ2sw9vw0EsXPgmoAdyGv6jPv01LJJkiEbrGKBE4mJKqB3fEXC2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AN3IOo2yc1RfFo9ZtZMjgy5wjIzjLTVDu2RcywEkqDY=;
 b=GEtdGW3OXpJ0CN9O+5t0m2NqcyCa4ruJPTC9Ms/SZ1okjziiBaQYOGZ3zVpj6kFBEhGSGBd2wAcxZmYu9Az9JGeTlIe7jhAmvbYmXBC8fbDCLS7t6hJjIevfMi2vVQfQqwhHeuJSE8e++GkFQ99YL/fA9VpKSw87sk0dXfErfNnjTbn2UtQSXZF/Z6eyMEdjHAoFtyWEPCSGj2tyuBo5OEXcOm+iKZJcbTrtbpyvxbT2Jmy9hiuXS1JEErClwTYRr3quMzj/Xd5815v6y4h7jKMJJtDhr3Dr76HTwUcOQwjo7JQV0GHGKfR3Oe8z2BtuV0AoeKth3X30IAFMEdOsgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AN3IOo2yc1RfFo9ZtZMjgy5wjIzjLTVDu2RcywEkqDY=;
 b=KpJYBexExP2VCVKKf1QBB4TRdJw8fgWhoznLvBDvgEQ2UzB1gBJBaNjr1vFl5elwBl3D51qEdxLcUA0Pl0v9oB6MUYimxoQyjeKg3YCgL8gDaqcVA4TOQclRnzt3bepx8Yo3I9Kiv44LBXdNeYrM7FaVbVOJtp6R2Jicll9+hBI=
Received: from PH0PR10MB5433.namprd10.prod.outlook.com (2603:10b6:510:e0::9)
 by DS7PR10MB5230.namprd10.prod.outlook.com (2603:10b6:5:38e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.29; Fri, 28 Jul
 2023 10:47:21 +0000
Received: from PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::2cd:1872:970d:7c4e]) by PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::2cd:1872:970d:7c4e%4]) with mapi id 15.20.6631.026; Fri, 28 Jul 2023
 10:47:20 +0000
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
Subject: Re: [PATCH v2 01/26] arm64: Add missing VA CMO encodings
Thread-Topic: [PATCH v2 01/26] arm64: Add missing VA CMO encodings
Thread-Index: AQHZwS3GXR0l5YPLf0CAO90wU3JDgq/O/1wA
Date:   Fri, 28 Jul 2023 10:47:20 +0000
Message-ID: <47D77E11-B859-4EFB-AB93-5ACD9703C990@oracle.com>
References: <20230728082952.959212-1-maz@kernel.org>
 <20230728082952.959212-2-maz@kernel.org>
In-Reply-To: <20230728082952.959212-2-maz@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR10MB5433:EE_|DS7PR10MB5230:EE_
x-ms-office365-filtering-correlation-id: 633641b7-694f-4f00-6c63-08db8f58051f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: elH/9Hsefom6NP4qwvoaDQE1dZGgyMqk0++Nd15aTuYDhw+bE4RszWDz8jGS1neiJFLR8JY7EWbO/RgyshGBXPailzePbo3QwCeyZvFs1hV8Tmh36H/AHv3xJo6DhGQLMF7Rzhh3+VyfdkbnolBMtAtq+KRLEugOYtu9vBfMbnEVZ4Z02CFYGsdQySx9+cjJDsuhTGMaJc2PEd7AtcVAACohToNqnBAAGy1CZehH4CvcSZBHkmsNhZqBelgDemhS/9X/dciVAmGpso+H6A6H3veORUdiNDvCwIA7TvSZGo8LLAZQQN3Jsy8tAzNqM1scA5HC26C5Qeo4KMpW23qfHxMq2lOPuOqmMA56KCxYsu580zeB9cc4MPW48qCzX+xQzm3ynaoFsyS5N8VDI3B4S0CNQaeVw9HeO0ITKOSWW7ea8jAf/8iYRpUTEOWE4MhdX3fHoX0GNd3BKWXXDFPudQhAljYyyp2VTw18+zLoDVJAicYP0PcTPDHq0duKL1/VO9bptMb6wq9Ru7cwKDCoDFZiWbs4YT6WjSl2rH/bCviu58WarBtx6gP6H2bKxQoZSh8jwwW+lrcXXwKBkOBg1Uy1tRaSoLuQYi2eefdtCui+IVrTLY7E3HASjOxPVLfidNvHdY+xdRyfXdctpNTsvA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5433.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(346002)(396003)(376002)(39860400002)(366004)(451199021)(41300700001)(316002)(8676002)(6916009)(4326008)(8936002)(53546011)(6506007)(33656002)(54906003)(122000001)(478600001)(66476007)(64756008)(6512007)(66946007)(76116006)(66446008)(91956017)(66556008)(71200400001)(6486002)(2906002)(38100700002)(36756003)(2616005)(38070700005)(86362001)(186003)(7416002)(44832011)(5660300002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?VRH98P60qpKP7YGr3Iu+aV70GHMgNs2hM90kPvxcBnG8bVnHfkOBY6bYWcFR?=
 =?us-ascii?Q?0l6SANoievWGJ1W0onJScL2m9Edjw/4izscbzAOlYDKRB9isPiPAzfZ6ulS8?=
 =?us-ascii?Q?1wNP9bDKpcIKWR8043YTj74cjXY2klxMy/7m/QihXbGf/H6qMFJh/ODQAWUc?=
 =?us-ascii?Q?WxOBsoubUKIY47q/6qWU1jQDWzIR/aCJ37SnykrSuWTAnsdx/g0PuR3zuP2s?=
 =?us-ascii?Q?813EFWcvFDjque//wOYN3704JSPV5O63Gp93AHwPA3jJJ5zDfFhzx2F3tOyK?=
 =?us-ascii?Q?rf8xxDfFYWdlslI6jFxuj0iE6PMFmuh174yrzkhVzEQuxsL2d/nhmc8gwpRt?=
 =?us-ascii?Q?3e0BA76+QPb8VOkoyHtTknVfbElqWFamQfWIRkiylyvbiceSyJnCVB6xjmn6?=
 =?us-ascii?Q?2kZyQ52B72EXL0/p0tGc3MjYJjaHPanu1EU/fwOtH5NifTpEBX9KuENJnU25?=
 =?us-ascii?Q?yi9jW8OtEvOQoMLavJFdtwohxcqT1YpRwvSJTAV5R0wu0vl9JGf+FeQTl+Pe?=
 =?us-ascii?Q?o2yHqybhBX7Dnz8B+D+j3RIWLRgyarRgsv3T9WHrZVEbiBD05/gGgV9Pjk90?=
 =?us-ascii?Q?lzq8/KRjFvuUkYJ5iOf1Qdfvyqsj5TWJZJw/9MGyrqnNjYwVhyr2TYz+mYa2?=
 =?us-ascii?Q?lcq3jFoOw2TCxiawhXpNTDcjssDUr8XWoZQjtwEI9sSZianDzCw5RCjjwcok?=
 =?us-ascii?Q?RArmCH8pdO6v3tj4xrT2zOCvJ0iqnyNW0hL6n6yy79oAMIHrmnblEjmgXwiJ?=
 =?us-ascii?Q?XsMLx6LhTX+JQe8MAvJYMB5Wxylgp32eHQj/nU4ME1vJDDGP8Raev81349x8?=
 =?us-ascii?Q?bLD5frGWBFuHdFBHEFRPqJlhLsdc3AvBrFSTETluSUUFLdclXaMhVIksm1gW?=
 =?us-ascii?Q?3JjfmWRVMSBBpJ97j+lSmnwJrMHiKmA7MvH8DL+f69yj7LWMaw691BMPwPVT?=
 =?us-ascii?Q?8Q49Dj8MQlD8wdWFoe5S9fvqLkQBcJtbgqFMuk99wwFMf8b/axozDTjkBF8a?=
 =?us-ascii?Q?xlMxKfne+vwgU8JTfiTd7ed5ZSRvVnq5S6/VdOutTMxUNlKQMRJZ/fHlDgab?=
 =?us-ascii?Q?uaW23is4VEVbCYiRhSuKXZ8paqETqfVnhgUz+Jh4BBisEaRWuzJre1brfuLu?=
 =?us-ascii?Q?oaNjNgxXwKxXjP3F7sjdX9uqf9DjxJbE3rwyLOBMWB8/QghwFSdrM7dv2NGB?=
 =?us-ascii?Q?VeoqybzXSNjB9lqIlCOnEyCU/L8jvOpVI+yBm0VWMn6Tun7xFExQWSrNrqrL?=
 =?us-ascii?Q?UV9q4d4mywTXIMDXSuYdk5HSJVuymYC8XfUTmbKeRw2Tn4bq0FI/ZbSrs8kV?=
 =?us-ascii?Q?rXjunfRijjFW5ExC0DdcMcbAy6GVFC785rtPh5tx9QaT6zMyQYzBx1cyjGvS?=
 =?us-ascii?Q?NnUbeqeAQtSeIVsWZdzpWjLTbpND2aNk8PkUcaplCOf4sL38gnFcIbBsYzxo?=
 =?us-ascii?Q?OG9Gr1iI78BclZmMPOs5o2KJUhlshPS4xqaCDnOb7ooctWGaBMyObjbuWoRS?=
 =?us-ascii?Q?CCnKAfPpa7sZtbDEffYe+F2Dp1DBJgNxWUx1HImv1fyBGHmspfpZJV0NY+4e?=
 =?us-ascii?Q?uYfzQfwVf6PH8elPjy5L3RKmiELIignm/Q71kIkCOfsYbFCMnSjdnEy4BIXb?=
 =?us-ascii?Q?P5YiKy5bBWYelZzjh4y+KiA=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <41B1EFAB0A87EC4EA171220111E012EF@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?6F6+2u4zryyKIqixrBlEZ78yFHJCMkT2esj4cEyfjfcwe/zZMSq8Iuga3JHo?=
 =?us-ascii?Q?g+lali/Cwr/IbqBL96D4HA1I4MvNrom+4cLDfN4TaO2ycNtmDimdyyK3xnev?=
 =?us-ascii?Q?bA2MK3U3+ZfNrD7XWq5P296wBEwL1q/gQABLt0y9KJC5ymf1/zaqP9dFbLnb?=
 =?us-ascii?Q?b+Goi54lOZ3WZJu/ORn1nIw+PkDzd65Zb1TiEBN80sLC1LulXJQO/7CZ6tDD?=
 =?us-ascii?Q?9BsPnGjpiZLqvUDknbMfGplTRuz0QYqH3aSFKdgPq+OI+3zkNSIsXXOq2GnK?=
 =?us-ascii?Q?QwDqtmgW/eGpdiimsY4vGFNB7um3VSnhXUnrIqk5j5Nqtc5itUZmcvRubwAf?=
 =?us-ascii?Q?RJ6cBtMlHQ2G1DaENrIUXUQJlssCmRtTcFHJHZnvVoUCSb+Zk6h022XgJY67?=
 =?us-ascii?Q?drx2PDllTbkZk9Ni57n9YUnrbxpWXIQLmGoDVJo0mZgMCFDCzpiH5/tmgvfF?=
 =?us-ascii?Q?3aYFV/ZgOVUUZ8gRRjBLRDLIDaLsZNnFyhl46JwnQ2fUjz1poWISiArhPs81?=
 =?us-ascii?Q?u35JL/Di6hBdU8KQou0ZEHcCLn3trxavHNaam36kIR+lcT+f7ilRAIcY+wZk?=
 =?us-ascii?Q?Nl0AAF7HF6b8zqhvyRk6g1jqYRbUQi3HGEL+avfETS+gikqEGBTCS0/EUIw2?=
 =?us-ascii?Q?zDJCeD0wudQMXWOksqBqzXXOyV6/unE7E5gE6qBuQNVDXhte7HStOy2Mj39d?=
 =?us-ascii?Q?1zqzC9YjgXXt1IJxYxsoPe7DwijeQTxlVBiYPOjBFl6MjfNXJdE2GaMXbaze?=
 =?us-ascii?Q?CYfD26u5qlyie9cfE1H6UKscqe320Demzil/FKj8+0u6GhVOZyhC7PE9L3dH?=
 =?us-ascii?Q?R1wOo9r83xjM9vU+0UeQ8sUcAW+bbgQzH66LxXwP3PpRKRO/9bgiK/Pjy/1D?=
 =?us-ascii?Q?3T/GdDDDlMt5mlvtkmss3ocuRc8xG9auyOl49mWKHvai6Q2Svz1EpajeXQV+?=
 =?us-ascii?Q?hOIU04+RQhAMwkCR4NbaAEQTivMf2HcgJmVOHZoH/TTrFlPRYTnztk0juQ16?=
 =?us-ascii?Q?stdUvHklNU5O24xW1q+9SkmtZ1RTOrUwt83KVj3z8FZ86zXr8bJORqXJ6vmQ?=
 =?us-ascii?Q?gYWDPRne?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5433.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 633641b7-694f-4f00-6c63-08db8f58051f
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jul 2023 10:47:20.8623
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KVLhZk/+cMttZWpXnvtoGVFGbKbfQQagXXEorL8HvRH+GYSXiCrT2EB5iuHEPIBjq2b/Fd/u/t84FiJxSA+h5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5230
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-27_10,2023-07-26_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 adultscore=0 suspectscore=0 phishscore=0 malwarescore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2307280098
X-Proofpoint-ORIG-GUID: ZybBHcJQ1DWIHyb74Brsv6gM2SumUcvM
X-Proofpoint-GUID: ZybBHcJQ1DWIHyb74Brsv6gM2SumUcvM
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
> Add the missing VA-based CMOs encodings.
>=20
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
> arch/arm64/include/asm/sysreg.h | 26 ++++++++++++++++++++++++++
> 1 file changed, 26 insertions(+)
>=20
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sys=
reg.h
> index b481935e9314..85447e68951a 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -124,6 +124,32 @@
> #define SYS_DC_CIGSW sys_insn(1, 0, 7, 14, 4)
> #define SYS_DC_CIGDSW sys_insn(1, 0, 7, 14, 6)
>=20
> +#define SYS_IC_IALLUIS sys_insn(1, 0, 7, 1, 0)
> +#define SYS_IC_IALLU sys_insn(1, 0, 7, 5, 0)
> +#define SYS_IC_IVAU sys_insn(1, 3, 7, 5, 1)
> +
> +#define SYS_DC_IVAC sys_insn(1, 0, 7, 6, 1)
> +#define SYS_DC_IGVAC sys_insn(1, 0, 7, 6, 3)
> +#define SYS_DC_IGDVAC sys_insn(1, 0, 7, 6, 5)
> +
> +#define SYS_DC_CVAC sys_insn(1, 3, 7, 10, 1)
> +#define SYS_DC_CGVAC sys_insn(1, 3, 7, 10, 3)
> +#define SYS_DC_CGDVAC sys_insn(1, 3, 7, 10, 5)
> +
> +#define SYS_DC_CVAU sys_insn(1, 3, 7, 11, 1)
> +
> +#define SYS_DC_CVAP sys_insn(1, 3, 7, 12, 1)
> +#define SYS_DC_CGVAP sys_insn(1, 3, 7, 12, 3)
> +#define SYS_DC_CGDVAP sys_insn(1, 3, 7, 12, 5)
> +
> +#define SYS_DC_CVADP sys_insn(1, 3, 7, 13, 1)
> +#define SYS_DC_CGVADP sys_insn(1, 3, 7, 13, 3)
> +#define SYS_DC_CGDVADP sys_insn(1, 3, 7, 13, 5)
> +
> +#define SYS_DC_CIVAC sys_insn(1, 3, 7, 14, 1)
> +#define SYS_DC_CIGVAC sys_insn(1, 3, 7, 14, 3)
> +#define SYS_DC_CIGDVAC sys_insn(1, 3, 7, 14, 5)
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

