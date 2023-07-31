Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0C65769280
	for <lists+kvm@lfdr.de>; Mon, 31 Jul 2023 11:57:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232152AbjGaJ5e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jul 2023 05:57:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232134AbjGaJ4v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jul 2023 05:56:51 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 321A710C6
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 02:56:38 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36V6xWAd029736;
        Mon, 31 Jul 2023 09:56:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=a0tBG/jPcb5kB58Gzg+1vwufDEJdOOVdZGlxfsSg48k=;
 b=UZMMqfM6gvD/ZDAS1iH2pxMqmowjSMTiW6WY0KXZ8LCwzc7HdwzCe0xAQjgQ2uX1DQav
 NRyjggEUFgHkyBKWcYDKtufBP7vffUUgLKjlq24o0Ui99xAEEQmrg0uWRZBsG1Uy4WJw
 Ew2Lso/l+5k9LfjWD21wFx4t2tTO1En0I3v3bDg+R+lB7J2FN7Lbe7kPIL68P98KPaPk
 PdZai3qQWay+9bb+KoNf9dwybKgD7kSlJEtErpq7IAFeE081yr65ky5UajwGZOhIkw8X
 ZkSKTy2AFQXrqT2jW4pI8r3WN7dhBenjTA6RF+90+9p/Z8+D6K5BoZSlrxnVnGG7QGSe NQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s4s6e2877-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Jul 2023 09:56:03 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36V9hKxr013737;
        Mon, 31 Jul 2023 09:56:02 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3s4s74hqe8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Jul 2023 09:56:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eJ93NUrMHazbI6afB+WHGyfkaKl+WgdbjbESlByEkbk6wdMKCeNpJgvia38nbPI0pB/ll9IqMPimUAzioS68HByQxz1Cy3iOXyGSPLVIMwVbbnrgmNICKWB+SAWISUnfQ7He1MmoZxfx0L99i8yheldCyFnIlDyAeh91gLfPMKTlzYSkH38v9ubDZViOzdnAxecv3oGO9sNprVjKJiU2wMFq/ttniaHfphVitsOQARnBD1j1mTTB/CsbMiWaGNFDX4oqC91R82CDaIszFAEJVOeXbyU8hdMm0/a5hVAuFKLLkgl6d71k1sAiUpJLxPfFBWNqWRXiY9kUJ64hci0mfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a0tBG/jPcb5kB58Gzg+1vwufDEJdOOVdZGlxfsSg48k=;
 b=eVaBMEl5VZgDLD7dg4418zocUrN5MXs5FsilJcHfGNRjjToykQib0MP21OdkmC7Id10z6wuy5KXD1XlBKS1XWyWMGsrqNpu4WVKi+vjSEQAD7jZ033IrxEo1Bdrr45FsuV+IwGIeDou/IUDFW75LFajD8m/SeAJzk6DW6HoZWL5n6LLAvVr/z1kYmRLRABSo0gOM5rDTk6OD59kEtEQTRv6jxsUfBLDXCHsjC1TeKLvn9UpOngW/ZuMgf+vZF6WtHacgPSFf9h4JNXsJgFSlTFqg+/pJ/sisTHvgwvasT5vWlym/JLiJEmd9Lzp5g4JNxIf+1T80CrtaPsziDfztHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a0tBG/jPcb5kB58Gzg+1vwufDEJdOOVdZGlxfsSg48k=;
 b=AIzl/WJBJaoXwimJn3JbD2FNCKT32bsJ3CLmlhNEnOq+JI/prGmctnIUqXlpQPokg/bNtwYNcMAWjfBRgN2Kuuqc3b/grn0UaMRdfrtC7FZwTKV0woiZQLUGcuujyr7T2KTB9mgNbvaIqnpb8Ywm4SkgeQf0M5xCrZbheIvqxbI=
Received: from PH0PR10MB5433.namprd10.prod.outlook.com (2603:10b6:510:e0::9)
 by PH8PR10MB6357.namprd10.prod.outlook.com (2603:10b6:510:1bc::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.42; Mon, 31 Jul
 2023 09:55:59 +0000
Received: from PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::76c:cb31:2005:d10c]) by PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::76c:cb31:2005:d10c%4]) with mapi id 15.20.6631.042; Mon, 31 Jul 2023
 09:55:59 +0000
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
Subject: Re: [PATCH v2 05/26] arm64: Add AT operation encodings
Thread-Topic: [PATCH v2 05/26] arm64: Add AT operation encodings
Thread-Index: AQHZwS3NrfP771kIBkWDTe42nk6eVK/TqAKA
Date:   Mon, 31 Jul 2023 09:55:59 +0000
Message-ID: <39309D90-B8B0-415C-A9B8-89E472D61D31@oracle.com>
References: <20230728082952.959212-1-maz@kernel.org>
 <20230728082952.959212-6-maz@kernel.org>
In-Reply-To: <20230728082952.959212-6-maz@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR10MB5433:EE_|PH8PR10MB6357:EE_
x-ms-office365-filtering-correlation-id: c3602cf9-6639-464e-a305-08db91ac57d0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6EyjMHGa7XPVWERBr4AYbkyRTUPx64+2LhpnBYEtyCFrSKeZLiL//gYx99Y35/S09Ien/HPDHJDx8LObJ2DasaUJFTA/81/EY3axHj9NhZOTx+y5R+DQgdFo0SqXdkQotlX467Zz38RTOVcKjmZ+DwNhKqYZ7WbVvrBzm950v1hTYo27VHBajIFBkJ8KfKDtXlSOINMf8FVqO1va66tpoPdhOvcUVuWflWprxju7MK6hPFHZGc6hd85D0EAhD/CcGGo7mIKI0D0WWiLKGz8MqQeA1KMjvv5YZDSZh2WCr6gMvQmHD7XI6sPHXnNH4tFdhLJuW2JkRyaohcYw6fH6e/oHWEywF4fJMZxm0927G/cbRRfwwufcITKP4m1wBlyB7z42pWDklSjebufqEJU/3jm4uGfhX7BujIFPRI0CkV9AwD0cIvOhqwUidaU1e4UeL47Qj40/DnI8t3zVlyoTwJYA2rfUwJEKR1n3zLAPYJPBVT7HH31YowFccTbbtgjYTl/YAupErHFkLW5Gx5PFWmJZSGN4LFwsA6Cs61igwq5ebyWc5eD7rxC492Vkd3K/w8+rGHzjDeuqP56ac/OLLGNOVEA/sSdkSZ9EIbMbiB736I2aazNbMONeCy9ovhVfx5ykLxmoYMr62MUFk93mZQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5433.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(346002)(39860400002)(136003)(396003)(376002)(451199021)(6512007)(6486002)(36756003)(53546011)(2616005)(6506007)(186003)(44832011)(33656002)(76116006)(91956017)(66946007)(66556008)(7416002)(38070700005)(122000001)(54906003)(86362001)(66476007)(316002)(4326008)(64756008)(66446008)(5660300002)(6916009)(8676002)(8936002)(41300700001)(38100700002)(2906002)(71200400001)(478600001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?66IewtfD7e5MgKbGOLZjaGOHUTMQ45jV9qdkpvNd6VW9oTARn5xlQ9rftF1+?=
 =?us-ascii?Q?APBAl5JPBkECEBQ9cNsaLWgq9XxJn3p2dIezO5rbXbAImqXm4Re9PjnT0+VO?=
 =?us-ascii?Q?31VjIzMS2pNsdPOVOY8g8vzyYgmXPlC/gygegtw4rzSGoGscO4Njawa4YDCW?=
 =?us-ascii?Q?oieyf5T98hWBKGynLTlN5gBGR/0zPGGie24MoT8+BepTYWGH8u3gpfTtFYFj?=
 =?us-ascii?Q?KmBmus97m5cBD7B/jQvOVbkT+lkbtNwrvXtOsHghF/i8+5+mjcmM+OVrIiYE?=
 =?us-ascii?Q?oVam5+XRxM/A7ymHM0Xfab2LHm/UWbkwcy1DB6de33eL+xFf8gN2oilSrMly?=
 =?us-ascii?Q?hUe/Wb4fZTWfDOWXmlBZGVPJry+i7d5zm1KxW6ouz6WbUetqbipyeknAljv8?=
 =?us-ascii?Q?Z8eKVYhKoo/iDb/usEY+kROkm7DsURDvzspxVeZpmPOwl1EtDku7tDLqkkc1?=
 =?us-ascii?Q?tUgO/lCf6007Ml3l9eotgz7/AxhYfWRianrDSTIi3+NkbtN+rnb5GPwi0cCV?=
 =?us-ascii?Q?t/0vUC/tFr3Kr8SykzJrDSg1A+THd3y6yP5wD08/flvN19+1qMYNpVa/1LMk?=
 =?us-ascii?Q?P1mgXyFeZcmdtRjXKBSv980+HdOlz7HFIyd7NPAo3y4+ky9rukIKOVNFywgj?=
 =?us-ascii?Q?0ctKk7nldDyM/SASzg/B2AkijiM2jp9zNB9Y21iAooCx8B2oy0EMG8gWaT3y?=
 =?us-ascii?Q?zx04beijIU3JDdDbqFb0FZ0/42S842Iz2KWCYvL2KVd3EYz6Lue2vDHHDeIe?=
 =?us-ascii?Q?iqEZEFlFTVBxjOvYcY49zWX9+P07Z+rFZQeCXXwkuNnz/rzc04/T3a1gaY98?=
 =?us-ascii?Q?826FRkwnlUnOSRmFy8kQcOgyWH2dKQtVJnMBB794KThofX5oxAc48ym//Xqw?=
 =?us-ascii?Q?ElZBgaia+NChVZurNR10314lCoOwH7P7wMoVucqigKgYqwGAYW8oEFHKAajs?=
 =?us-ascii?Q?gg/4ZsqNO4ZUZmUtPe22MSo7Z+DS1tqZBYf0PM45NaduWqM3UB9Gd2EaQxK0?=
 =?us-ascii?Q?vlauwAdZihtNucXhMP5kQ7GzUMAsE5i7aX7pFYwAvl0w5T2mm3I/fELfDRyu?=
 =?us-ascii?Q?uRERIuFCib5P3knIMj7fqrO05DCuYnUy54oOZnGZvnGtbUy62SseYwsMl2Mj?=
 =?us-ascii?Q?TGQf9A+4o4aCNx96QHRMwxQCQtGH6RdCR2wv56KyIKc6AzNHvjbRpDEtT9ab?=
 =?us-ascii?Q?HQKFc4S6cAWmNP+as050rx6fcC6j4cam+xvJpFBDktpAqmIwa9vuYgdAHZez?=
 =?us-ascii?Q?yJ1A2KNYhvmEK6lae6BX/St/fQ8jrCCTsxeJ5ESwuMc5Jz2gSp0pae24LWg0?=
 =?us-ascii?Q?15IcSuOe7mxe42OeqUapIMclREJ6MlNZVfgMZFklS4LN8DCEF6pDbCUipY3i?=
 =?us-ascii?Q?8FFY86KVEXj1j2Hh3cU82acqtOQ7gFQUDdUeZ6Y7I3q/sYsT19GObeLwFs59?=
 =?us-ascii?Q?wXlbo42GE/e3hLoOt8IAcZ1dRlfbyCN07/Kwm9ORO66LFbXO/7xi8kL/P4DK?=
 =?us-ascii?Q?W1OWpT1Fh79/gy/nXJ1YGba9sHG/DV30mCzO/0Aem0DpohYYgSLsrtPerXk/?=
 =?us-ascii?Q?Gmb+65A4OVRiYrqQYq2KSFLGTQ0gjocSUhpC1HPetnaF1aZQM3LYx8qSQCJF?=
 =?us-ascii?Q?9EFk9NIxiHAqaDCdFnvTnxc=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C55A9D82EC03D2408D821FAA1CDB9F4A@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?Picf8KVKWDoDNTIQvRvvQMeHZNkg5P1zmgHut+GUzIDlKohVfpEkYKN2Twt4?=
 =?us-ascii?Q?UtnCIO3/CoKkRUEdbKDctc7OK4E9P4kfiVqIAO0DsiUETFI9fChk6T3LZ3tb?=
 =?us-ascii?Q?t4getus8AOmevWjw5ZGYNY3Wq0fd2zA8KzOITmzl29DlXCNPTMY+IkmjDelX?=
 =?us-ascii?Q?BPjLhHg9THpwIxu6DUA+uV3VYvDW1joa2xYLKHT7AZWhMqGUyIvch026LJUt?=
 =?us-ascii?Q?wVsXckp3JJdDsFNVptcfQDhP5bm4/AaPMsFEQZMunwcXEc6FL5QJla1eoA1f?=
 =?us-ascii?Q?L50o1bJ2tKan9hzhuJ4d3yfB1r+KhbAoQBYwW3oiH8L4oDgKlC5x1TIkySrA?=
 =?us-ascii?Q?/MKnYodgxtjW4Xh4rjCoRj7zjl51814WtUnC2gfzlw6pzKHwlwZmyMwM2mDw?=
 =?us-ascii?Q?04j7WAMJ+BX+xHLBxJfArQuLyuJEEOv33ryX32J4h5g4VFzKikXpuD8a8Gt/?=
 =?us-ascii?Q?gOv53w72IC/M88c3UZNUPkNz4sbD+jWuciPjQKyQpx8D449B7NOfAGHjQcQC?=
 =?us-ascii?Q?04LS3EAuRmI7vR2zo1pWcFmWATm1sOe06N9I3HFhCBXeZVugfSWVJCuIN6Do?=
 =?us-ascii?Q?qO76fxmzA+ruyKemupDpyOf6bBfz0tcdFGkx2dSeFOwubx/Cy2wsPB43sdPR?=
 =?us-ascii?Q?RFDg+cYkus0ZiewYJNnMtu14umvqV0qZRS+VMjAIEfh3kqWDloJBx9DA4y4y?=
 =?us-ascii?Q?+HPnm/BxFYFDieMBOHR06W9uYGi0cv6JKz4paXeN21bk6Vv5PnvxeOC0rPr+?=
 =?us-ascii?Q?klHjDvopuc/Y3Lg4fabBDCy8itZ0f2bLL1btGPgqf3hyA6sid0q53160dUA0?=
 =?us-ascii?Q?lAN2XcQvQddsKlOaXsYcB7q26/PsRYP8PF4N8fBtq7LkPkqSRHTfUjBC4mxe?=
 =?us-ascii?Q?KsOQQ+FUXG+3jqfSA+xnSwfaaoy4SsScw+PN3KE9fxyLt0yVSTxsJF5LHHKu?=
 =?us-ascii?Q?Ivhgkdjc0fnR7OzErEpBUE/5WBXbog6u0W/1FeQwYC3Py24yittEPWk8njF+?=
 =?us-ascii?Q?dsPoB4ArhDJXvYFJ51hEq4WKVXX3JDv74HyI3wSnerpKUVo=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5433.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3602cf9-6639-464e-a305-08db91ac57d0
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jul 2023 09:55:59.6316
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wi4ietqnIbNJiu9e3rLI8u9KWNjPbK6gDihfvRVnFFvBc3VscBhoVbv6pnsHrcfZWZAg9Z8GwBa6jHLyMzxwyg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6357
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-31_03,2023-07-26_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 adultscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307310089
X-Proofpoint-GUID: 9dh4MF-anRHgodrPBK_DoPnYOzTzBcvO
X-Proofpoint-ORIG-GUID: 9dh4MF-anRHgodrPBK_DoPnYOzTzBcvO
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
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
> Add the encodings for the AT operation that are usable from NS.
>=20
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
> arch/arm64/include/asm/sysreg.h | 17 +++++++++++++++++
> 1 file changed, 17 insertions(+)
>=20
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sys=
reg.h
> index 72e18480ce62..76289339b43b 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -514,6 +514,23 @@
>=20
> #define SYS_SP_EL2 sys_reg(3, 6,  4, 1, 0)
>=20
> +/* AT instructions */
> +#define AT_Op0 1
> +#define AT_CRn 7
> +
> +#define OP_AT_S1E1R sys_insn(AT_Op0, 0, AT_CRn, 8, 0)
> +#define OP_AT_S1E1W sys_insn(AT_Op0, 0, AT_CRn, 8, 1)
> +#define OP_AT_S1E0R sys_insn(AT_Op0, 0, AT_CRn, 8, 2)
> +#define OP_AT_S1E0W sys_insn(AT_Op0, 0, AT_CRn, 8, 3)
> +#define OP_AT_S1E1RP sys_insn(AT_Op0, 0, AT_CRn, 9, 0)
> +#define OP_AT_S1E1WP sys_insn(AT_Op0, 0, AT_CRn, 9, 1)
> +#define OP_AT_S1E2R sys_insn(AT_Op0, 4, AT_CRn, 8, 0)
> +#define OP_AT_S1E2W sys_insn(AT_Op0, 4, AT_CRn, 8, 1)
> +#define OP_AT_S12E1R sys_insn(AT_Op0, 4, AT_CRn, 8, 4)
> +#define OP_AT_S12E1W sys_insn(AT_Op0, 4, AT_CRn, 8, 5)
> +#define OP_AT_S12E0R sys_insn(AT_Op0, 4, AT_CRn, 8, 6)
> +#define OP_AT_S12E0W sys_insn(AT_Op0, 4, AT_CRn, 8, 7)
> +

Reviewed-by: Miguel Luis <miguel.luis@oracle.com>

Thanks

Miguel

> /* TLBI instructions */
> #define OP_TLBI_VMALLE1OS sys_insn(1, 0, 8, 1, 0)
> #define OP_TLBI_VAE1OS sys_insn(1, 0, 8, 1, 1)
> --=20
> 2.34.1
>=20

