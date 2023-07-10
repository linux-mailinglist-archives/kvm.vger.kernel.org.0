Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B73F674D612
	for <lists+kvm@lfdr.de>; Mon, 10 Jul 2023 14:57:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231383AbjGJM5n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jul 2023 08:57:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230301AbjGJM5e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jul 2023 08:57:34 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E865FE6
        for <kvm@vger.kernel.org>; Mon, 10 Jul 2023 05:57:32 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36AANppI014138;
        Mon, 10 Jul 2023 12:56:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=hXH49Xdt1QehBoK9EKuaeyDUHC4d/U5i/M3h3ABh34U=;
 b=IbddCttl/y38qAHZTaw6XjROsAL419gSVKg39BqnTK4ofAqfmqE+dPc3H/oYbCmAxATC
 psWsjsV6Kz+xlQt/xOH7SAq55eTafJA4zSpMQXJmF15cAM94uhe9uD6xPGHdncmW6xh9
 tYNiQxsOTdggDyG7YpDIT+2XHpmYwp/4Et7D3uj/Jd743RnYr3fKXW/3/MpWx4lu4MU7
 +THZ2Wi3v9V1wku8sIm58uvfMLr0RGZ25rdaorLQYo+veEdtSDnCfEabavqdha8s1Uyn
 5ZjzpfM1GiGg/dpng+OSoJ05/91GLvu8Ufm+E0abtJv/m7mF4/pQu10UgRoXuVPUZQYC 1w== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rrea2recx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Jul 2023 12:56:58 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36AC7aUN002541;
        Mon, 10 Jul 2023 12:56:57 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2174.outbound.protection.outlook.com [104.47.73.174])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3rqd27nvrf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Jul 2023 12:56:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DiPjrbReOciK5j6aF7JrlEivwhFKYEK/uhFWeaZdSpj7Lgh1Bh31Ym73aZOuC9CMncCapu/oP74TDSHtCQmftzrH07cpZd84j7MQMWd/xRRsuSOgy+YYTfKEa9nu18bBV7sPEht9M7Lg+VGPuU3rYUFNRwBf67GL0c/ocg2B3ktmdkFVBMiOo0omdOT/bib7UYjom/kXbX29oJjZtBDJIu4Mxx/OhmIv+5N17xrbt4eotU9Pmw1dKkgSQ68WPqvGXpVI6LTvL/p7bgxCQgm5BkpFTgnFj6Qx+Oy3ijW4stxrA1NpT0uqhcltteEXfw+z19jO5o+1cDl32FpGS0pECw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hXH49Xdt1QehBoK9EKuaeyDUHC4d/U5i/M3h3ABh34U=;
 b=eihOYDV4uvWhYXbcglDpaFw4pS4GOOkjppimISG4yDK4pPLxe5b2JIi6NeVfK2mQCQXLnLx9O/rhmcDW0Rs1sDCbENfw4EGlRqozoQdkanQTWElinzH+v+A/xLpnziAZqsmH6XdiHc29RvVmMnrJHGyhETuIjzaxLCPeKt3K9pufMpNNKtzl1XX/AgJTmqzShMzuus3yETFdQ9GbSTq16qplZc7bUMyU+g2cYaKqJVxWhXZw+cvaXvDsFivDXXmt4L3s1Kd096Uq6SIkxPA8GDIUJjT1c6OgLRRMKP4act9NbWrCoFGO8oMokjzwwPj7kfzAotT0fJCWIYrNnkoQnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hXH49Xdt1QehBoK9EKuaeyDUHC4d/U5i/M3h3ABh34U=;
 b=zBAMST+d220KE9pl2r3Yebmtwjbg0XRL2t56taHdtWvq3CTTKCC5/wFsSyMwyR6nB9lvRIVm5JDdJs5ClCXkEU7A5N1mxJejoLZB6tKfOPh/VJIjO4Q0oDo3QzeQhhtdD67zx/f48DVhbSCAlmvudaw0iLc179LyuVOrmAWjqLA=
Received: from CO6PR10MB5426.namprd10.prod.outlook.com (2603:10b6:5:35e::22)
 by DM4PR10MB6864.namprd10.prod.outlook.com (2603:10b6:8:103::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6565.30; Mon, 10 Jul
 2023 12:56:54 +0000
Received: from CO6PR10MB5426.namprd10.prod.outlook.com
 ([fe80::5f21:adb6:761b:7a17]) by CO6PR10MB5426.namprd10.prod.outlook.com
 ([fe80::5f21:adb6:761b:7a17%6]) with mapi id 15.20.6565.026; Mon, 10 Jul 2023
 12:56:54 +0000
From:   Miguel Luis <miguel.luis@oracle.com>
To:     Marc Zyngier <maz@kernel.org>
CC:     Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Chase Conklin <chase.conklin@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Darren Hart <darren@os.amperecomputing.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Eric Auger <eauger@redhat.com>
Subject: Re: [PATCH v10 00/59] KVM: arm64: ARMv8.3/8.4 Nested Virtualization
 support
Thread-Topic: [PATCH v10 00/59] KVM: arm64: ARMv8.3/8.4 Nested Virtualization
 support
Thread-Index: AQHZh1MX+qQj9H8mMkuYpu12F27VUa+gCbmAgAGXRgCAEaxOgA==
Date:   Mon, 10 Jul 2023 12:56:54 +0000
Message-ID: <AB79D154-BA63-473B-8001-97245FE99DEA@oracle.com>
References: <20230515173103.1017669-1-maz@kernel.org>
 <f19bb506-3e21-2bd6-7463-9aea8ab912f5@os.amperecomputing.com>
 <877crmzr5j.wl-maz@kernel.org>
In-Reply-To: <877crmzr5j.wl-maz@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO6PR10MB5426:EE_|DM4PR10MB6864:EE_
x-ms-office365-filtering-correlation-id: ba7920cd-869a-490f-7c79-08db81452340
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MsywiibvgK4Fe1DSYrNmbtSfQGe9WXMU0767UnGR/QY+l7JQ3A1AMPEl4RFhyvKOs56qCS8nNFqPlcxVd6ty+vmjjZRALRyIP5sT9KuQ+uzsIPzMv6BwZ0yNNHcDscIPWCZA2iDqIudwG92xjBQKGJb/qLhBUwEghJ5ecnxC0q16Cpm21Tg4PVhgTUXx9oRxOvd9TLIK3S5mKX/EqYSXqKa9NuBCnv3SCIuogo6yv2cnf8c0wBP58wSQ16fELuNcevkE17SWc/+3C+jALjLuj+hN+sXhhGOrHEQRSD8Q5oGVYb1b94Tmmt1TyfdWcrXJeXlJn0s85J+wSwMCVVmIJ4t4oxos8s1HBFM4lTA591PyeZDAkI+aHfdGKJiA/IlOmfcgvcAPMIj2gyASh+wa6cDwZWmlZ96lg0K+yM4qkpqyLfQHsRSYuz26McykpQZWjYv6ZI3/nYMAPHa+uk9ZvYSijDHrN5tHDvMK6oHWgWPfckUTr8yDKZ2zXR54KYWQmtQp+ocjxyU/IQQUqRBY1XZZp+eFokEzssO66eS4yE+YV33ELciFBte4nM7THNhujGCPh4yoIxLCSJyQU465WU2aQiN02z8EZ75djZpE05FYwMwMiNxxMbm1kCuNiUG0j3pKondaatmCvt3kOt/fJw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5426.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(366004)(39860400002)(136003)(396003)(346002)(451199021)(6486002)(478600001)(76116006)(54906003)(71200400001)(91956017)(36756003)(38070700005)(33656002)(86362001)(2616005)(2906002)(66946007)(53546011)(6506007)(186003)(6512007)(38100700002)(122000001)(8676002)(64756008)(4326008)(66446008)(5660300002)(316002)(6916009)(66556008)(66476007)(41300700001)(8936002)(44832011)(7416002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?L2w4NHlId3FzTitaTlhqamlDS21SUTh2UlBwNXV5c2JnQk9WN08yNzVhZzlS?=
 =?utf-8?B?dlZoaEpreWVFYWU4YjFKbzZJd2JSQUI3RDkxLzFWNFpKSnBxZjhSRjFOY2ov?=
 =?utf-8?B?NDZOcldLbXFQZUdFSkxGa0JCTzRyZWQzekJUTTd3c3lqaHlxTDQ4VnZJTDdi?=
 =?utf-8?B?NEtZS2k2NHYvRWtkaVNRU2l3cUxJV2NRZmVxVG5vOEsxWlRxbDlEWGVrMXYz?=
 =?utf-8?B?TnRlVU1JN2xINkVzT1RrdnVqajRyeUNGRjNpTTQrUU13d3orbVYwTXRHcWQ1?=
 =?utf-8?B?TktRakg0M3JHWXV1K0Z4M24zTlRtU2xOUFJ3UWpxMHlvVjZrTERJcDNuWVpa?=
 =?utf-8?B?UnB4SjlwS3dhSHhGQmIxVHY1OEtBZjgzSHk0bGF4a2J1VUgwL0JDRnhpamJ3?=
 =?utf-8?B?bjloTWo4RVpNU2RSTDZCMDlHQW15NjRaUmxFcTJORUdaNllTVGNMai9lTlNF?=
 =?utf-8?B?NS9nOVNsd3hzSU13bEV0eUZXc1dRMHBxSWZjWThJL0JxV2pZNXpXZXFBaGFW?=
 =?utf-8?B?QThlSy9aSVNNRXlvNzB6angwU3RyMUx4ZUFaRGZEZkV0SE9XbTV1MU1Icnlr?=
 =?utf-8?B?WWY5eWR2WHBIMVJRMkVMVlErK2w5Z3VIbVF0ei9WZG5QT3U0K2k5ekxITkZr?=
 =?utf-8?B?S0JqVVo1U0k4WVBPbjNTMDdrYXJQbVhZQmUrL2NwdlFrRG5OR29sZ3huSFJS?=
 =?utf-8?B?NHhWdlpMNStBaXJMeVZScHZoL1Z4RjNzZUJUcDRmditUQ3NrMjUzRlpBK1BB?=
 =?utf-8?B?SXdrTzZpenJBVms1d2lFU3VFWGJ6RkNXMy8rVXl5UVYyMk1mb1h1UXZXcUpV?=
 =?utf-8?B?SnIzc1pMeG80dGpFL3hEZUN4VHdhS2U2V0FLenhMa2t6OGhXYjF6aXZxTjNt?=
 =?utf-8?B?bGpDMmxXN21HUjVtcXRRcHVvSFk4TDkvMDBnWVRJb0o5dkh2dzA5eG01NEdE?=
 =?utf-8?B?QktGajVVUms0NGhva2liY3FWRFVLbGdpYTMyaDhmN21RT3ZSdkRKZ0JkQjJh?=
 =?utf-8?B?b2w4Z3lNU3lFTmF4Z2NWRUVqWm4vWHRNOGFweFhRYVZuVG03aCtJSVBwRnpp?=
 =?utf-8?B?ekhxbG91Q3NCaEhsOW45QlpIZVdTRFBqT0pQL0VGVG5mNnVhYW1JMVlGM2xV?=
 =?utf-8?B?eFlFOHcvaFJ4TFJ4RVFwZnZiY3ExYXBneUlqa1o3NHVocE50Znp5Q3UrWlJR?=
 =?utf-8?B?KzJEZ1J3azJPWEwrWWJid1BHZ2NvckJQd202bGpDdElobWlZTXZWNXJoY2xI?=
 =?utf-8?B?MEFva0xFOEtOVHkzajM2SnR6VDhOU2kzc3ArU054bUxSSkVXNlF1cjFoRFZI?=
 =?utf-8?B?a1RkNHlYOFIxTmk3bmFEbE5TKytGWUQ5VVcwMi9GcjhzZndaU3dpUzcrVnUz?=
 =?utf-8?B?TGEvVThVQ1hQRjMzVjhaTmJsZFBIcDRJTUMyY0lpanZNaVhxOStHNm1MNHZz?=
 =?utf-8?B?OEtUNk1NNnhuWENHbDlZanI1L0FYNTJKWlBuQjlTZmNSczN0bkVTU0ZDUXB3?=
 =?utf-8?B?S2ZZU2ZsT0VyYzVXZ0NXdlczNFdDeWkrU1V2dllOejRoN0FiQ0wrcGRmWTN4?=
 =?utf-8?B?MG5sNFV5NmJ4WnlkSkVHc1BJR2NFd3BPdkUrQ3gvdi85VG1sV2U1bWhhbWZk?=
 =?utf-8?B?UVlmd05JSklKbkRoTlliV1g2R1BMQVpyK1ZLWEVsRHF4ZkJDZCtPK3NYSk5j?=
 =?utf-8?B?RGduTmlzdmdzL3YyQzJ0cmJtSDlpcFRRbmtWeVlYMTEyb3hsNFRsMWROMDFB?=
 =?utf-8?B?bDVXNlNaWjhRMXVuUzV1aVJhcFExMk9rUTIxRDFRQ3JVdzNIMFJPMXhoYVRm?=
 =?utf-8?B?OG16QmNMcllxenZEZlNaVzUyL0QySXpYcnVkeTJiRGdCYkpDUWJ4U2prQllX?=
 =?utf-8?B?WWluWDVxS1h4UHhCVDA1U2piemZWQ3BkRnNuQ1NSVGRKYXBaNnBleGVPNEw0?=
 =?utf-8?B?NDA2N0lITmUrWUU2UUNTSitHZE44bjB2WEJLT0V1WjlISUFvWTJOWHYydUMv?=
 =?utf-8?B?ZDhkd2NCWURaeXJyREZ2eGw1cGZFZGZXaVRpSG5lUnFGMUlLcHNsV0ZnLzFU?=
 =?utf-8?B?blF6T1ZjSmZIOWtKZERUeVF2ekkwVGdKRktOUTNnWW83clB3WUN3STRybVZq?=
 =?utf-8?B?eGJCRyszQ2V4L2R0RFd5UlhXS1UyUmJqS3ZhR1RNZStvN3FQLzFoeVhUcVp3?=
 =?utf-8?Q?kloNjIdHmjl31M+bMWqt3y8=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A41D4E31486150498EA0C734354A1D3C@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?K0JWNDhlaGttM2Y4dlZ3WFlMZHY5dEdSYnBhQlpPa3VnaVp0RUtGUzVRLzkz?=
 =?utf-8?B?Ny96M3cxT3BMQ3d1R1U3U1RFamxhRU9OYW5zczVOeU9QdmJjMjlOWW1SNXlL?=
 =?utf-8?B?TEJ0VnNVSWo5dUIxSVRPYzg0Njg2QUoyT29LTDJBQ3FlZzVGQTVmWFo0emY2?=
 =?utf-8?B?RHk2eUZEOFd5aTZIRUkzZjFWSkRLUGFVOElucGpwendhT0pkVEgvUVBPQUxH?=
 =?utf-8?B?eWRsOURnb3FtQm5FSlViM2o4R2VvQ3ZRdmRQYXJoWkJTckcveEdGUXZZUjNh?=
 =?utf-8?B?Z0RFVmppdVZ5V0pDNXB5dXhxaGM1TjZsU1hqcVFKRklHdThTMTRRNmE1MUJa?=
 =?utf-8?B?bEw2THdIcTRVaHpYcGlHejNHSGt6VkpMeUEwaFc0NktMSkpqLzNWaWcwSkJY?=
 =?utf-8?B?UUhmSXRvZlFaZnJFZkdET3JobDFab0t3YUtHTHpQTG1ldGlvMTYrZFhrRm5F?=
 =?utf-8?B?QnBqSkYyQTR3TGxaVllHQ0VOclkvRkhJWDZPVnZyMkkvTnQ1U2N5bTZzT1V6?=
 =?utf-8?B?dkVnZ1pPaFlCcnZlTTZlLzJzUXNaQmZ3Z2xYYTZUWG5oaFFETHRSV2NwUTY4?=
 =?utf-8?B?VzhOcXhmNmt2cGZXVWZHOG9ZWTB1c0lOMDUzKzM4dmsrV0V5VUN4UnRTaVRD?=
 =?utf-8?B?Mll1WC8vOHI3enlSWmMreTNzbGlHRm5TQnB6aFJLMVBuZGpmTmc1eXJzK1ZQ?=
 =?utf-8?B?UnBPS3Y4UmRiYnQrZjVpNWdRVWlQTFZrbzQvckJYRXZLdTdicFozclU5cVlo?=
 =?utf-8?B?VGgydEdrR0liSjFqTTVEOVptcStuZzJGK2RFd1lDSkEzN2FQUEtHUVlqWmNC?=
 =?utf-8?B?Rk5laGFYaUozUEVsUlR4Vnk2ZllFU3daUUY1bUpOSVhFTklFbzF3MG9CUnpV?=
 =?utf-8?B?ZlgvSXdESjZhWUIrU2V1OTBIbEdSR1BVejdtZ1Bacml0YkhwOFdKV2NuLy9s?=
 =?utf-8?B?YlNqQVc0cEwxYXgyNnBHQ25LWUlwaDVxTkpEWE5qQW1qQkJobUdjSjhnMC9w?=
 =?utf-8?B?TU5GaVJuSEM2QUZBelhrVHdxb0JCL1F3TC93RE5MY1BjN3ZyVmk3aGk5NC9s?=
 =?utf-8?B?N1dJYXhvNTVOVFVUa0ozSGVSYmlpM3VmaEZ5N1VwbTVPa0J6ejA1VXRnazUy?=
 =?utf-8?B?azBwQWdMSFVWaXh5TSszVDR6enlIN3RDbUM0TG5OUWRvS3FIWlpxV1JxMllZ?=
 =?utf-8?B?dmwzRGJSdm4zU1ZvTXk2SVhyeWZnZUszUEs1Yml4RkZGZEVWR3Zxa3FENFF6?=
 =?utf-8?B?RmtNVnlXcFVHNU1nYXozbVNOVXRVd09nQVVYMEY2N2JhYllPaERmSVUyeVdM?=
 =?utf-8?B?ZHEwa2c2VG1xOW9NQ0JyNCsvQit2ZHk5WHVlU05UR3cwOEppc08rdGUyTjZw?=
 =?utf-8?B?cVJwSkdPWkNaWGpYUnYxdjlOcTQ5TWtLNkhVdk5IMC83UEY4bWhkaVN2NXlD?=
 =?utf-8?B?NkpuUy9MR1R3QmRiMFY4UkVUZTY2YjR5MTdXRGczNXkwM3pyMmprbEhWSlJR?=
 =?utf-8?B?SWpYK1pML2JkRy9ZcnMyazhGbG5VRHVCanV6dUdNSFJCUUdwOWlVVStrNXJu?=
 =?utf-8?B?Nzh0UT09?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5426.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba7920cd-869a-490f-7c79-08db81452340
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jul 2023 12:56:54.6764
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jd9Liw2+oUUQGl7Ndgo2tw+AqPbOq8resQOK9/5tM5MH19R8i6DR9U7R7acgffzbIA5Q2jY6glQ87aGrQLao/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6864
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-10_09,2023-07-06_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 mlxscore=0 suspectscore=0 phishscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2307100117
X-Proofpoint-GUID: GsX2f7NtR3F31Q7Ep52Vqthpa55z3Wau
X-Proofpoint-ORIG-GUID: GsX2f7NtR3F31Q7Ep52Vqthpa55z3Wau
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGkgTWFyYywNCg0KPiBPbiAyOSBKdW4gMjAyMywgYXQgMDc6MDMsIE1hcmMgWnluZ2llciA8bWF6
QGtlcm5lbC5vcmc+IHdyb3RlOg0KPiANCj4gSGkgR2FuYXBhdHJhbywNCj4gDQo+IE9uIFdlZCwg
MjggSnVuIDIwMjMgMDc6NDU6NTUgKzAxMDAsDQo+IEdhbmFwYXRyYW8gS3Vsa2FybmkgPGdhbmt1
bGthcm5pQG9zLmFtcGVyZWNvbXB1dGluZy5jb20+IHdyb3RlOg0KPj4gDQo+PiANCj4+IEhpIE1h
cmMsDQo+PiANCj4+IA0KPj4gT24gMTUtMDUtMjAyMyAxMTowMCBwbSwgTWFyYyBaeW5naWVyIHdy
b3RlOg0KPj4+IFRoaXMgaXMgdGhlIDR0aCBkcm9wIG9mIE5WIHN1cHBvcnQgb24gYXJtNjQgZm9y
IHRoaXMgeWVhci4NCj4+PiANCj4+PiBGb3IgdGhlIHByZXZpb3VzIGVwaXNvZGVzLCBzZWUgWzFd
Lg0KPj4+IA0KPj4+IFdoYXQncyBjaGFuZ2VkOg0KPj4+IA0KPj4+IC0gTmV3IGZyYW1ld29yayB0
byB0cmFjayBzeXN0ZW0gcmVnaXN0ZXIgdHJhcHMgdGhhdCBhcmUgcmVpbmplY3RlZCBpbg0KPj4+
ICAgZ3Vlc3QgRUwyLiBJdCBpcyBleHBlY3RlZCB0byByZXBsYWNlIHRoZSBkaXNjcmV0ZSBoYW5k
bGluZyB3ZSBoYXZlDQo+Pj4gICBlbmpveWVkIHNvIGZhciwgd2hpY2ggZGlkbid0IHNjYWxlIGF0
IGFsbC4gVGhpcyBoYXMgYWxyZWFkeSBmaXhlZCBhDQo+Pj4gICBudW1iZXIgb2YgYnVncyB0aGF0
IHdlcmUgaGlkZGVuIChhIGJ1bmNoIG9mIHRyYXBzIHdlcmUgbmV2ZXINCj4+PiAgIGZvcndhcmRl
ZC4uLikuIFN0aWxsIGEgd29yayBpbiBwcm9ncmVzcywgYnV0IHRoaXMgaXMgZ29pbmcgaW4gdGhl
DQo+Pj4gICByaWdodCBkaXJlY3Rpb24uDQo+Pj4gDQo+Pj4gLSBBbGxvdyB0aGUgTDEgaHlwZXJ2
aXNvciB0byBoYXZlIGEgUzIgdGhhdCBoYXMgYW4gaW5wdXQgbGFyZ2VyIHRoYW4NCj4+PiAgIHRo
ZSBMMCBJUEEgc3BhY2UuIFRoaXMgZml4ZXMgYSBudW1iZXIgb2Ygc3VidGxlIGlzc3VlcywgZGVw
ZW5kaW5nIG9uDQo+Pj4gICBob3cgdGhlIGluaXRpYWwgZ3Vlc3Qgd2FzIGNyZWF0ZWQuDQo+Pj4g
DQo+Pj4gLSBDb25zZXF1ZW50bHksIHRoZSBwYXRjaCBzZXJpZXMgaGFzIGdvbmUgbG9uZ2VyIGFn
YWluLiBCb28uIEJ1dA0KPj4+ICAgaG9wZWZ1bGx5IHNvbWUgb2YgaXQgaXMgZWFzaWVyIHRvIHJl
dmlldy4uLg0KPj4+IA0KPj4gDQo+PiBJIGFtIGZhY2luZyBpc3N1ZSBpbiBib290aW5nIE5lc3Rl
ZFZNIHdpdGggVjkgYXMgd2VsbCB3aXRoIDEwIHBhdGNoc2V0Lg0KPj4gDQo+PiBJIGhhdmUgdHJp
ZWQgVjkvVjEwIG9uIEFtcGVyZSBwbGF0Zm9ybSB1c2luZyBrdm10b29sIGFuZCBJIGNvdWxkIGJv
b3QNCj4+IEd1ZXN0LUh5cGVydmlzb3IgYW5kIHRoZW4gTmVzdGVkVk0gd2l0aG91dCBhbnkgaXNz
dWUuDQo+PiBIb3dldmVyIHdoZW4gSSB0cnkgdG8gYm9vdCB1c2luZyBRRU1VKG5vdCB1c2luZyBF
REsyL0VGSSksDQo+PiBHdWVzdC1IeXBlcnZpc29yIGlzIGJvb3RlZCB3aXRoIEZlZG9yYSAzNyB1
c2luZyB2aXJ0aW8gZGlzay4gRnJvbQ0KPj4gR3Vlc3QtSHlwZXJ2aXNvciBjb25zb2xlKG9yIHNz
aCBzaGVsbCksIElmIEkgdHJ5IHRvIGJvb3QgTmVzdGVkVk0sDQo+PiBib290IGhhbmdzIHZlcnkg
ZWFybHkgc3RhZ2Ugb2YgdGhlIGJvb3QuDQo+PiANCj4+IEkgZGlkIHNvbWUgZGVidWcgdXNpbmcg
ZnRyYWNlIGFuZCBpdCBzZWVtcyB0aGUgR3Vlc3QtSHlwZXJ2aXNvciBpcw0KPj4gZ2V0dGluZyB2
ZXJ5IGhpZ2ggcmF0ZSBvZiBhcmNoLXRpbWVyIGludGVycnVwdHMsDQo+PiBkdWUgdG8gdGhhdCBh
bGwgQ1BVIHRpbWUgaXMgZ29pbmcgb24gaW4gc2VydmluZyB0aGUgR3Vlc3QtSHlwZXJ2aXNvcg0K
Pj4gYW5kIGl0IGlzIG5ldmVyIGdvaW5nIGJhY2sgdG8gTmVzdGVkVk0uDQo+PiANCj4+IEkgYW0g
dXNpbmcgUUVNVSB2YW5pbGxhIHZlcnNpb24gdjcuMi4wIHdpdGggdG9wLXVwIHBhdGNoZXMgZm9y
IE5WIFsxXQ0KPiANCj4gU28gSSB3ZW50IGFoZWFkIGFuZCBnYXZlIFFFTVUgYSBnby4gT24gbXkg
c3lzdGVtcywgKm5vdGhpbmcqIHdvcmtzIChJDQo+IGNhbm5vdCBldmVuIGJvb3QgYSBMMSB3aXRo
ICd2aXJ0dWFsaXphdGlvbj1vbiIgKHRoZSBndWVzdCBpcyBzdHVjayBhdA0KPiB0aGUgcG9pbnQg
d2hlcmUgdmlydGlvIGdldHMgcHJvYmVkIGFuZCB3YWl0cyBmb3IgaXRzIGZpcnN0IGludGVycnVw
dCkuDQo+IA0KPiBXb3JzZSwgYm9vdGluZyBhIGhWSEUgZ3Vlc3QgcmVzdWx0cyBpbiBRRU1VIGdl
bmVyYXRpbmcgYW4gYXNzZXJ0IGFzIGl0DQo+IHRyaWVzIHRvIGluamVjdCBhbiBpbnRlcnJ1cHQg
dXNpbmcgdGhlIFFFTVUgR0lDdjMgbW9kZWwsIHNvbWV0aGluZw0KPiB0aGF0IHNob3VsZCAqTkVW
RVIqIGJlIGluIHVzZSB3aXRoIEtWTS4NCj4gDQo+IFdpdGggaGVscCBmcm9tIEVyaWMsIEkgZ290
IHRvIGEgcG9pbnQgd2hlcmUgdGhlIGhWSEUgZ3Vlc3QgY291bGQgYm9vdA0KPiBhcyBsb25nIGFz
IEkga2VwdCBpbmplY3RpbmcgY29uc29sZSBpbnRlcnJ1cHRzLCB3aGljaCBpcyBhZ2FpbiBhDQo+
IHN5bXB0b20gb2YgdGhlIHZHSUMgbm90IGJlaW5nIHVzZWQuDQo+IA0KPiBTbyBzb21ldGhpbmcg
aXMgKm1ham9ybHkqIHdyb25nIHdpdGggdGhlIFFFTVUgcGF0Y2hlcy4gSSBkb24ndCBrbm93DQo+
IHdoYXQgbWFrZXMgaXQgcG9zc2libGUgZm9yIHlvdSB0byBldmVuIGJvb3QgdGhlIEwxIC0gaWYg
dGhlIEdJQyBpcw0KPiBleHRlcm5hbCwgaW5qZWN0aW5nIGFuIGludGVycnVwdCBpbiB0aGUgTDIg
aXMgc2ltcGx5IGltcG9zc2libGUuDQo+IA0KPiBNaWd1ZWwsIGNhbiB5b3UgcGxlYXNlIGludmVz
dGlnYXRlIHRoaXM/DQoNClllcywgSSB3aWxsIGludmVzdGlnYXRlIGl0LiBTb3JyeSBmb3IgdGhl
IGRlbGF5IGluIHJlcGx5aW5nIGFzIEkgdG9vayBhIGJyZWFrDQpzaG9ydCBhZnRlciBLVk0gZm9y
dW0gYW5kIEnigJl2ZSBqdXN0IHN0YXJ0ZWQgdG8gc3luYyB1cC4NCg0KVGhhbmtzLA0KTWlndWVs
DQoNCj4gDQo+IEluIHRoZSBtZWFudGltZSwgSSdsbCBhZGQgc29tZSBjb2RlIHRvIHRoZSBrZXJu
ZWwgc2lkZSB0byByZWZ1c2UgdGhlDQo+IGV4dGVybmFsIGludGVycnVwdCBjb250cm9sbGVyIGNv
bmZpZ3VyYXRpb24gd2l0aCBOVi4gSG9wZWZ1bGx5IHRoYXQNCj4gd2lsbCBsZWFkIHRvIHNvbWUg
Y2x1ZXMgYWJvdXQgd2hhdCBpcyBnb2luZyBvbi4NCj4gDQo+IFRoYW5rcywNCj4gDQo+IE0uDQo+
IA0KPiAtLSANCj4gV2l0aG91dCBkZXZpYXRpb24gZnJvbSB0aGUgbm9ybSwgcHJvZ3Jlc3MgaXMg
bm90IHBvc3NpYmxlLg0KDQoNCg==
