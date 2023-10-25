Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1BEA7D6947
	for <lists+kvm@lfdr.de>; Wed, 25 Oct 2023 12:44:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234781AbjJYKov (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Oct 2023 06:44:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234661AbjJYKop (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Oct 2023 06:44:45 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFF9E93
        for <kvm@vger.kernel.org>; Wed, 25 Oct 2023 03:44:42 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39OLUUk7014935;
        Wed, 25 Oct 2023 10:44:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=6UOYFmWAZp8c6IqQ0QcfnQNV/2x36AgIsM6f7svUYHU=;
 b=FwZDyBDz8ssJvi7QTCayTUNvwHKpZABGXz/GQL868vKOGBC8fd/IlIK6aDtlYUlRCfOn
 9xj4GU7VOjiCu2/08j5Fy6T58GUzC8YwT60HP8XGMlhAlNTShyARC771bC3TIxIeDMdF
 qqEKE7IqQ/lZGTazDZSTkIm+72LhLpATFkz9hp1AITJ1f1kv7tnQn9LLvxXCcQIH3b7i
 YkkjdswlVcrPTAeAwMFdX0LkcpAO2p/RHa1LkoPK7EinIw5A7wGZrtTaG4ggNlmDGjHn
 /yHUiDzuLtCGCw0WVcOpMP64XwE1nTxXekMELJ1nnx0h69FjAFqca0uBSasJSpn6F1pd /A== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tv5jbfgh7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Oct 2023 10:44:20 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39P8UFHP001627;
        Wed, 25 Oct 2023 10:44:19 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3tv53cyfh1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Oct 2023 10:44:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XGdoYCntUpmVp9U88Cd3Sf5A688xj+r876tDVhozJzyCtw1McHptrBWSQJNTEZm/Uc6k5KJv+HL34cyuVEmXD1gLQUxvR7Cak8fj5u5Bx8eB57ZPWEUhM3vZKA/ehtzgucVRTBmfclFtbQyBVbdWAA1+s26IQWi7n6zJ4IpUwHp5CdoWMW1YwPXFqFAFjxbhUtX9cGufUT/8hwe3pD3n9PiYkd3u4XEG2hexuTIDM6j+v8DjtquWfE6x9ICsZwV5+KpYELwdKo7N9L9540ZODrCp1f/5n7kPuWt8yCO9rqQSB7xG7lH4rY54L0TOSZKBqo11FS1QdJBw+QkjyUtK8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6UOYFmWAZp8c6IqQ0QcfnQNV/2x36AgIsM6f7svUYHU=;
 b=G/moMSJwPEalEKE1d1Zu4MMhSLvqCapSJNmy1k6UyoJn/6xvKblGOtneRly6yV+aw+fYylFSAVeT7/Orpe54F3XRXisg+ZLferY9LF7YhTWO2JRq3soHrD/I2W9AFOwxiZlwEJk/tVt2pU2HZMPgFPAlcHKmenH+MUL164I8QarP3ZtmmMejRfOkWs18yAwJ1L2WL5qGOrtFOMSu3LIb1G+wRkA6X7NtH8yWzHnuWigRoxbTrPISOH9DrkS2BGdD1Ek/JHR5CTbVZbk2hSoenOrnTF04rMiCn0x/S9XQLB9/bCijckhXam6fSeajdEyLaPMhEr4brhudd/FgX/Hfzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6UOYFmWAZp8c6IqQ0QcfnQNV/2x36AgIsM6f7svUYHU=;
 b=sewAWPmyrHPO49BXY7i0xeQTvomqaxnDW8bphRRh+L88XrcN7njBatyGN47SfRVhMzQcm31hcjVqjxgmKTz3FgxNVrvL64sCnI+Cc2WtuV0Hks8QQBktySQkSboyo475M+HIjq1Vwg1oy8xnRsBLAqoV4Y0oAOtV7NIk/9a0e7M=
Received: from PH0PR10MB5433.namprd10.prod.outlook.com (2603:10b6:510:e0::9)
 by PH0PR10MB4598.namprd10.prod.outlook.com (2603:10b6:510:34::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.29; Wed, 25 Oct
 2023 10:44:18 +0000
Received: from PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::a39e:b72:a65a:a518]) by PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::a39e:b72:a65a:a518%4]) with mapi id 15.20.6907.032; Wed, 25 Oct 2023
 10:44:18 +0000
From:   Miguel Luis <miguel.luis@oracle.com>
To:     Marc Zyngier <maz@kernel.org>
CC:     "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Eric Auger <eric.auger@redhat.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 5/5] KVM: arm64: Handle AArch32 SPSR_{irq,abt,und,fiq} as
 RAZ/WI
Thread-Topic: [PATCH 5/5] KVM: arm64: Handle AArch32 SPSR_{irq,abt,und,fiq} as
 RAZ/WI
Thread-Index: AQHaBZb73GL7k0M5w0WXQj3tQ9Z//7BXuamAgAF5WICAASIsgA==
Date:   Wed, 25 Oct 2023 10:44:17 +0000
Message-ID: <FE249878-B9FF-4778-B2EB-1839B00C715B@oracle.com>
References: <20231023095444.1587322-1-maz@kernel.org>
 <20231023095444.1587322-6-maz@kernel.org>
 <7DD05DC0-164E-440F-BEB1-E5040C512008@oracle.com>
 <86jzrc3pbm.wl-maz@kernel.org>
In-Reply-To: <86jzrc3pbm.wl-maz@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR10MB5433:EE_|PH0PR10MB4598:EE_
x-ms-office365-filtering-correlation-id: c0e1721f-402f-42ba-b26a-08dbd54756d9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gUKMYtijuTbAGaeZigL8DXqV3KG99PZJ3TGBhatnnPTl0VBKs9NMv0alC07lEbmt7gUdsD0XeOw37RWKfu3Zdul/Dz5C8VnrMs3l7nrr/V7WcwtRaU3fdqFxfW60uJcgTJYUDgirqcyzLIdWoNR4C3IhqfMeaIaW8Kbm3GIJkxNXwXPGi7hhJwkAvUg+azaS4AuqCM1YL1zgWEbf0EjWgFaZv8+k29nJ9ATq9q5uHQKtHz0ZZ+LpuA+ZJRyaPGxCknWkWYYmNixMVMKGtfAx2XUxMw9VXXbaGteno4Oavs5uPqfN+UhY6lM7wASBRX5by0Kp9mldJbnZBk3y84H4Cr5uTOUj2BDkFD7LmAL7tfePBbMrBdiB0qOU0M/9EQFDNHo4jAaCYsvYNpB06mGyWXu1Iscn+RfrjunwBCDRJ9+q3wYy/8OHrcy2TGn+prceKYyLJnxUkIlPUsEyRHdFLDFhAlhj1s/elIyjKtP6dMRAXvDA62ssx5Jz4TcCyatMEm+YIT9qBuPkHyETiOjCdxOgVEdljKRDh6+O6KYPudYP0kEgfrKYTYpfmByqQTakd4OKJE1IM+g5VIaT3M3iZnqYIpsWdUvHelZl/FABVSGvFP5+ce/b0q8xMVwawBjah+5814+e5nR+dqOt457G9g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5433.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(376002)(136003)(396003)(346002)(366004)(230922051799003)(186009)(451199024)(64100799003)(1800799009)(38070700009)(26005)(76116006)(38100700002)(2906002)(41300700001)(44832011)(86362001)(5660300002)(36756003)(8936002)(8676002)(33656002)(4326008)(6916009)(54906003)(71200400001)(66946007)(64756008)(6506007)(478600001)(91956017)(66476007)(122000001)(66446008)(316002)(66556008)(6512007)(2616005)(83380400001)(53546011)(6486002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WTV0akZNa1M0Nks2VUcrWG5ob3FKamtHZ1ZHVzUyMVc4MFRJbDViWW82MW9v?=
 =?utf-8?B?NkprT1h5MWc3Ny9BVksvcmRVZzFHVWp4TjFHRG5oSWFnN2NhcHFiSjFTNDlr?=
 =?utf-8?B?VlRtUjF0eFFVdlRyOU1HL1hNZEtzTHFDdDZTdE1RcmxrK0pDM3JBSUQ2Y0o5?=
 =?utf-8?B?Wm5hbForbjI5Sjc5QzdhZnFaRE9aNXhEKzlaTlBSSy96ZUhQbWhoc0I4Z3RF?=
 =?utf-8?B?TmIzdXRFeE9FY2pueGUvdFZZNkpkK0hZakVzdkx4T2wvVWhhcnkwWEFXRUdo?=
 =?utf-8?B?MGluZFJHR3kyU2FZZmx5V251cmNtbnA2ZmI4Um5iMTcwWFhlbWllR1VtaXpI?=
 =?utf-8?B?VnRIYkhteXNsQm5pZlYzNWN4V3hKd2daQy9XRWtYbnlob2JER3Q1cFowT1lt?=
 =?utf-8?B?RGxuY0lzaUpLTW1BZ2UrTDhKOVYyaWRJWmtuSXdUMmpuV1d0V1VPN0VtNVhJ?=
 =?utf-8?B?bEw0K29vSWp1dXUraW0rUHJvbmtjejNQOXp3a0w1bEd0bDFVV2dXSWMxSlg0?=
 =?utf-8?B?STZvZ3dJNHArNVRsS3N5WStpbFZjQkZHTWMzMkVPS3VzV3YyVThnd08rdDBt?=
 =?utf-8?B?eFRTdEJEKzgvQUF2NGNxWW0zQWZyTWF0M2xjdFRiaHU2QXZVL1J6S1E0TEUr?=
 =?utf-8?B?NlpZZUJRbHR0WjNQUGRmclhTQUkveURjL21JT3ViRk55NFRxM0phRC9YSTQ2?=
 =?utf-8?B?SUFVRUoyeEpFbVBIVGZiejNTcUxCWUFHdC94c1hxVVpWR0tycVR3c2lIOU90?=
 =?utf-8?B?RkFKbWhzOXEyMldBT2FIcm5mWDdkQmhqVmtRUGErTS8xOEJnamVLNWNscnFu?=
 =?utf-8?B?S0ozcSttYUwvNUhsclk0YzM5NXBCcUEvMDhjanB0NWY1V3BlYWQ0cVZTeVVj?=
 =?utf-8?B?eWFQM0RLdVFJZldkNDFZWFllaldTenRWb3hqTFQ2WHYxdi9ROEc1OUFkcXhW?=
 =?utf-8?B?emJSTWdwcDNlUUhMYythaXNFcHhPdklSOE5XUWd5clJsRldmWkc4T3N2dFUx?=
 =?utf-8?B?WWM1TTFBTWN0c21adHR6WXA2Mzk3cno3Z2RtRVNkd3NHaE5ocXNjRS9meUs1?=
 =?utf-8?B?Mk4wWFIwZk53Y3VaemdwZHJsVjhCS3p5M1hlSHBIcStXTVhPcVZ4V1BDaUZr?=
 =?utf-8?B?YUpneWJRTnBnMDE5QmRaRzlEZXloZy8ya281Q2NYcjAwNW95MGNuRklrR2Rj?=
 =?utf-8?B?QllXakk0MFVCK0xYeWhWRS95K2I1K0pLNWlFVDFhcWpJbGtadVNhMUc1NG9l?=
 =?utf-8?B?b0JUSWI5TjFpZXpCTE1WZFpSMHJqTjIxTkhEVHQ2MUhYK004MGtZQ1lXRCtl?=
 =?utf-8?B?YytBQXZ5K1JMQTExaytIb1lyVXZHSUx5NEx2ZXRTK1dYSnNLQ21mQmd1NlF2?=
 =?utf-8?B?OCtPRzQ2THFRSTQ4T0Q3RTF1SVR5UW10ZSt6TVBDT3FDUUZUN3ZCSGhxVGd6?=
 =?utf-8?B?aHkxKzJ3UjRMcFlJaEtPMGJ5dmd2Rk5nZm5scEdqUlBlYS9haFhrK3lXcTVn?=
 =?utf-8?B?L2hjMmpGSDYveWg4NFpCQ0VrTmJqb2poSXp6QjUvM3ZjZTVKRms5UTcvU0d6?=
 =?utf-8?B?NlFpbythUW1PZ3J3SHN3TDFkUHc0Nlk5Zmh2Q2VTQmt1dWp6V3g1L0xvYWtE?=
 =?utf-8?B?WmMyL0RBSUVjTXlpMU9FUm04Y0w2Rlh4dEFROFhjaU9DUGNQOEdVMmp0YVVL?=
 =?utf-8?B?bms1L2g0Z1JTMEpLZGRNb1VhZThha29qK0kyaDJsQkhjQkhqV0tYYUNSZG5V?=
 =?utf-8?B?MWFZQUJoVm44ODRwQm9VMkVFaVlRNzcrRTRoMGdyMFE1TDZKa1ozczlaV0Va?=
 =?utf-8?B?RStEMGZTVTNKS1pvQWgzcmtTYnJqdVhTbEtCU0Z6OHZaVUFhU3JzYmhoOU8x?=
 =?utf-8?B?eVAvYmZPeVpRZE9vYytWYStRZnFpK2VyYVJFclJWbkJsak5ITHNldGd2dXBi?=
 =?utf-8?B?Uk9zTmZQMC9rclBJdmtTU0pjNUdXR284TUFXdnJ3OERTQUd4bFA1VUVKSHlS?=
 =?utf-8?B?dHNaSWJONHpRc1puQ1hhamVrT0c1WnV6UlpiNkJERWxsZ0UxWHI3czBFeUQv?=
 =?utf-8?B?RFdMa0ZUYzZNcHNKWmtuZExjdnJNb3FFRkxuNENONlFCQ2Q5MWd1L3pvSjVr?=
 =?utf-8?B?M3NWVkpub005US9ERGZCRU1mSzBWVS8xUjhQSUZBTklhZG5pdGpMNEtReFZa?=
 =?utf-8?B?R2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E3E5F6A76A5B69458CD2DBA1FCEEEC61@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?SmRvUU85WE1QSUtJaXkvbFgycDdSekVOWlJkc1dhYnE1UFYwajJZUkt6MXlj?=
 =?utf-8?B?enJ1YjVZTVJmc3JOeTQxbGc2QlVSaHg5Nmp4Zmlrb0pOSkJJYktiekovZjQ0?=
 =?utf-8?B?Z0RwOC94bTNua3NWOTNRYUg2UjVFVHMvM0tXOTIwRjQ4ZGY4di85cHZvYnkw?=
 =?utf-8?B?SXc3OEtOYk1qRzE4N1ZpVFVGL1hvZmN1dkhIZW54WHgyTXJHZHk0OWtyTFNq?=
 =?utf-8?B?TUlMR3d0QmZhUUtuaE53bm4rY0pvRGI5ZGVWRENNRlN6RDdyUGxCOW9hMlNF?=
 =?utf-8?B?NGtBSEdNMVhHS3U1MWtOeWxzTCtlaXdPS3JaelRCU25VSEFtU2lDQ2NTdGNl?=
 =?utf-8?B?amlzTUVoalo0RTFlQ1U0Z3IwOTF4VVFWb3ZETFc2N1JtRUZMM2RBVkpHYTla?=
 =?utf-8?B?K0UxcWFZUGc4Y2VvUGRIYlZiaUlEcjJZVmdneGM0WDlpWUxXcWVoenNmSlFa?=
 =?utf-8?B?VldTeHhoL0o5M3I0cWJaVVE5T2VTZUF0ajkwY1ZqV1ArYnQvVEJVWVUyRDFk?=
 =?utf-8?B?ODdscm5qQ3dKUHQrVnlxcHZ4YlI2OUdHWVJ1RVV6cCtOOGJ0cFh5blBEZkZz?=
 =?utf-8?B?L2Q3eWNlUGhmcFlqV1JBcEIvbmFlVnhxeFhuckJGSXhNaU0rNnVpak93WWZE?=
 =?utf-8?B?U1BuOWtXdGlZaStDenJZRWZKRkQ0Y2o2anpHM3RZOVFQcWltMk9sa09vRDhY?=
 =?utf-8?B?a0ZNdXN2V0JCbnV4QllBbGdFV3RYL1lSQkZjMWM5dFUrWU1RVkhzZHUxSkZy?=
 =?utf-8?B?MmViaGg5NE1GdDdkRkVMQW5sWXFySEdsT3ZxR2Z6Ukw3V2ZGZk04eTlYOWZF?=
 =?utf-8?B?a1BwQThkbHlDTFhRMGR6NU8zQkpqNzErVnhWckN3aTlvVG56blNjcXAwcDdx?=
 =?utf-8?B?VmF5N0lkVGlIeGtydTg4YnZka3JJeVpweE55aldXb2pzWWxsaFk1MkRCSVFO?=
 =?utf-8?B?ZTFPREVMZXlyZlhFSlJwdjZSTTgzV1NPSE9lYzhnY1dhbkUvYkdObWp5UDJZ?=
 =?utf-8?B?bTU4SE50MWt0eG93aXNOcXF3ZWZuZ3NPN05sM2UrQmQ2VEV5Y0ZORjVBTkQz?=
 =?utf-8?B?Y0pjTmlKNzNOdElPaCtxQXJHSXh6enRnaC9FK2lYc0ltaXFKM3lqTVowUnZW?=
 =?utf-8?B?bTJzc3MrSk0wY1BuOWM5RFN5WmpYVFo4M0h5bzlnbzIyVmhkQmkwd2YvR1JI?=
 =?utf-8?B?WVdPQ1UxZHN0MnZSdXVpNXlSbzJzUjl6TnI1cmszV3FLYW55dHRxeUxQdHJz?=
 =?utf-8?B?NmNaN3ZkanRQTGhEeFp4Q25DR3hmbytqK0psckdzdjlzTEpWSGp1N25JeldC?=
 =?utf-8?Q?JTKNnx/5oaTXc+NUugiMne0ljhj7/ibEGv?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5433.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0e1721f-402f-42ba-b26a-08dbd54756d9
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Oct 2023 10:44:17.9490
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tjDvATfAD4kT5oCLKahGRQCu9LYheR78vqksDVOUG4eS/Zwcdcv5LzEfK8+FLEhoASEfbiFpIwpDBWNqSkM5WA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4598
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-25_01,2023-10-25_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 adultscore=0 bulkscore=0 suspectscore=0 mlxscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310170001 definitions=main-2310250092
X-Proofpoint-GUID: JKKGEXhCFgQ5NGT-ShaA_ijuWKkBCbSi
X-Proofpoint-ORIG-GUID: JKKGEXhCFgQ5NGT-ShaA_ijuWKkBCbSi
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGkgTWFyYywgT2xpdmVyLA0KDQo+IE9uIDI0IE9jdCAyMDIzLCBhdCAxNzoyNSwgTWFyYyBaeW5n
aWVyIDxtYXpAa2VybmVsLm9yZz4gd3JvdGU6DQo+IA0KPiBPbiBNb24sIDIzIE9jdCAyMDIzIDE5
OjU1OjEwICswMTAwLA0KPiBNaWd1ZWwgTHVpcyA8bWlndWVsLmx1aXNAb3JhY2xlLmNvbT4gd3Jv
dGU6DQo+PiANCj4+IEhpIE1hcmMsDQo+PiANCj4+PiBPbiAyMyBPY3QgMjAyMywgYXQgMDk6NTQs
IE1hcmMgWnluZ2llciA8bWF6QGtlcm5lbC5vcmc+IHdyb3RlOg0KPj4+IA0KPj4+IFdoZW4gdHJh
cHBpbmcgYWNjZXNzZXMgZnJvbSBhIE5WIGd1ZXN0IHRoYXQgdHJpZXMgdG8gYWNjZXNzDQo+Pj4g
U1BTUl97aXJxLGFidCx1bmQsZmlxfSwgbWFrZSBzdXJlIHdlIGhhbmRsZSB0aGVtIGFzIFJBWi9X
SSwNCj4+PiBhcyBpZiBBQXJjaDMyIHdhc24ndCBpbXBsZW1lbnRlZC4NCj4+PiANCj4+PiBUaGlz
IGludm9sdmVzIGEgYml0IG9mIHJlcGFpbnRpbmcgdG8gbWFrZSB0aGUgdmlzaWJpbGl0eQ0KPj4+
IGhhbmRsZXIgbW9yZSBnZW5lcmljLg0KPj4+IA0KPj4+IFNpZ25lZC1vZmYtYnk6IE1hcmMgWnlu
Z2llciA8bWF6QGtlcm5lbC5vcmc+DQo+Pj4gLS0tDQo+Pj4gYXJjaC9hcm02NC9pbmNsdWRlL2Fz
bS9zeXNyZWcuaCB8ICA0ICsrKysNCj4+PiBhcmNoL2FybTY0L2t2bS9zeXNfcmVncy5jICAgICAg
IHwgMTYgKysrKysrKysrKysrKy0tLQ0KPj4+IDIgZmlsZXMgY2hhbmdlZCwgMTcgaW5zZXJ0aW9u
cygrKSwgMyBkZWxldGlvbnMoLSkNCj4+PiANCj4+PiBkaWZmIC0tZ2l0IGEvYXJjaC9hcm02NC9p
bmNsdWRlL2FzbS9zeXNyZWcuaCBiL2FyY2gvYXJtNjQvaW5jbHVkZS9hc20vc3lzcmVnLmgNCj4+
PiBpbmRleCA0YTIwYTdkYzViYzQuLjVlNjVmNTFjMTBkMiAxMDA2NDQNCj4+PiAtLS0gYS9hcmNo
L2FybTY0L2luY2x1ZGUvYXNtL3N5c3JlZy5oDQo+Pj4gKysrIGIvYXJjaC9hcm02NC9pbmNsdWRl
L2FzbS9zeXNyZWcuaA0KPj4+IEBAIC01MDUsNiArNTA1LDEwIEBADQo+Pj4gI2RlZmluZSBTWVNf
U1BTUl9FTDIgc3lzX3JlZygzLCA0LCA0LCAwLCAwKQ0KPj4+ICNkZWZpbmUgU1lTX0VMUl9FTDIg
c3lzX3JlZygzLCA0LCA0LCAwLCAxKQ0KPj4+ICNkZWZpbmUgU1lTX1NQX0VMMSBzeXNfcmVnKDMs
IDQsIDQsIDEsIDApDQo+Pj4gKyNkZWZpbmUgU1lTX1NQU1JfaXJxIHN5c19yZWcoMywgNCwgNCwg
MywgMCkNCj4+PiArI2RlZmluZSBTWVNfU1BTUl9hYnQgc3lzX3JlZygzLCA0LCA0LCAzLCAxKQ0K
Pj4+ICsjZGVmaW5lIFNZU19TUFNSX3VuZCBzeXNfcmVnKDMsIDQsIDQsIDMsIDIpDQo+Pj4gKyNk
ZWZpbmUgU1lTX1NQU1JfZmlxIHN5c19yZWcoMywgNCwgNCwgMywgMykNCj4+PiAjZGVmaW5lIFNZ
U19JRlNSMzJfRUwyIHN5c19yZWcoMywgNCwgNSwgMCwgMSkNCj4+PiAjZGVmaW5lIFNZU19BRlNS
MF9FTDIgc3lzX3JlZygzLCA0LCA1LCAxLCAwKQ0KPj4+ICNkZWZpbmUgU1lTX0FGU1IxX0VMMiBz
eXNfcmVnKDMsIDQsIDUsIDEsIDEpDQo+Pj4gZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQva3ZtL3N5
c19yZWdzLmMgYi9hcmNoL2FybTY0L2t2bS9zeXNfcmVncy5jDQo+Pj4gaW5kZXggMDA3MWNjY2Nh
ZjAwLi5iZTFlYmQyYzViYTAgMTAwNjQ0DQo+Pj4gLS0tIGEvYXJjaC9hcm02NC9rdm0vc3lzX3Jl
Z3MuYw0KPj4+ICsrKyBiL2FyY2gvYXJtNjQva3ZtL3N5c19yZWdzLmMNCj4+PiBAQCAtMTc5MSw4
ICsxNzkxLDggQEAgc3RhdGljIHVuc2lnbmVkIGludCBlbDJfdmlzaWJpbGl0eShjb25zdCBzdHJ1
Y3Qga3ZtX3ZjcHUgKnZjcHUsDQo+Pj4gKiBIQ1JfRUwyLkUySD09MSwgYW5kIG9ubHkgaW4gdGhl
IHN5c3JlZyB0YWJsZSBmb3IgY29udmVuaWVuY2Ugb2YNCj4+PiAqIGhhbmRsaW5nIHRyYXBzLiBH
aXZlbiB0aGF0LCB0aGV5IGFyZSBhbHdheXMgaGlkZGVuIGZyb20gdXNlcnNwYWNlLg0KPj4+ICov
DQo+Pj4gLXN0YXRpYyB1bnNpZ25lZCBpbnQgZWx4Ml92aXNpYmlsaXR5KGNvbnN0IHN0cnVjdCBr
dm1fdmNwdSAqdmNwdSwNCj4+PiAtICAgIGNvbnN0IHN0cnVjdCBzeXNfcmVnX2Rlc2MgKnJkKQ0K
Pj4+ICtzdGF0aWMgdW5zaWduZWQgaW50IGhpZGRlbl91c2VyX3Zpc2liaWxpdHkoY29uc3Qgc3Ry
dWN0IGt2bV92Y3B1ICp2Y3B1LA0KPj4+ICsgICBjb25zdCBzdHJ1Y3Qgc3lzX3JlZ19kZXNjICpy
ZCkNCj4+PiB7DQo+Pj4gcmV0dXJuIFJFR19ISURERU5fVVNFUjsNCj4+PiB9DQo+Pj4gQEAgLTE4
MDMsNyArMTgwMyw3IEBAIHN0YXRpYyB1bnNpZ25lZCBpbnQgZWx4Ml92aXNpYmlsaXR5KGNvbnN0
IHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwNCj4+PiAucmVzZXQgPSByc3QsIFwNCj4+PiAucmVnID0g
bmFtZSMjX0VMMSwgXA0KPj4+IC52YWwgPSB2LCBcDQo+Pj4gLSAudmlzaWJpbGl0eSA9IGVseDJf
dmlzaWJpbGl0eSwgXA0KPj4+ICsgLnZpc2liaWxpdHkgPSBoaWRkZW5fdXNlcl92aXNpYmlsaXR5
LCBcDQo+Pj4gfQ0KPj4+IA0KPj4+IC8qDQo+Pj4gQEAgLTIzODcsNiArMjM4NywxNiBAQCBzdGF0
aWMgY29uc3Qgc3RydWN0IHN5c19yZWdfZGVzYyBzeXNfcmVnX2Rlc2NzW10gPSB7DQo+Pj4gRUwy
X1JFRyhFTFJfRUwyLCBhY2Nlc3NfcncsIHJlc2V0X3ZhbCwgMCksDQo+Pj4geyBTWVNfREVTQyhT
WVNfU1BfRUwxKSwgYWNjZXNzX3NwX2VsMX0sDQo+Pj4gDQo+Pj4gKyAvKiBBQXJjaDMyIFNQU1Jf
KiBhcmUgUkVTMCBpZiB0cmFwcGVkIGZyb20gYSBOViBndWVzdCAqLw0KPj4+ICsgeyBTWVNfREVT
QyhTWVNfU1BTUl9pcnEpLCAuYWNjZXNzID0gdHJhcF9yYXpfd2ksDQo+Pj4gKyAgLnZpc2liaWxp
dHkgPSBoaWRkZW5fdXNlcl92aXNpYmlsaXR5IH0sDQo+Pj4gKyB7IFNZU19ERVNDKFNZU19TUFNS
X2FidCksIC5hY2Nlc3MgPSB0cmFwX3Jhel93aSwNCj4+PiArICAudmlzaWJpbGl0eSA9IGhpZGRl
bl91c2VyX3Zpc2liaWxpdHkgfSwNCj4+PiArIHsgU1lTX0RFU0MoU1lTX1NQU1JfdW5kKSwgLmFj
Y2VzcyA9IHRyYXBfcmF6X3dpLA0KPj4+ICsgIC52aXNpYmlsaXR5ID0gaGlkZGVuX3VzZXJfdmlz
aWJpbGl0eSB9LA0KPj4+ICsgeyBTWVNfREVTQyhTWVNfU1BTUl9maXEpLCAuYWNjZXNzID0gdHJh
cF9yYXpfd2ksDQo+Pj4gKyAgLnZpc2liaWxpdHkgPSBoaWRkZW5fdXNlcl92aXNpYmlsaXR5IH0s
DQo+Pj4gKw0KPj4gDQo+PiBJ4oCZbSB0cnlpbmcgdG8gdW5kZXJzdGFuZCB0aGlzIHBhdGNoIGFu
ZCBpdHMgc3Vycm91bmRpbmdzLg0KPj4gDQo+PiBUaG9zZSBTUFNSXyogcmVnaXN0ZXJzIFVOREVG
IGF0IEVMMC4gSSBkbyBub3QgdW5kZXJzdGFuZA0KPj4gd2h5IHVzZSBSRUdfSElEREVOX1VTRVIg
aW5zdGVhZCBvZiBSRUdfSElEREVOLg0KPiANCj4gVVNFUiBoZXJlIG1lYW5zIGhvc3QgdXNlcnNw
YWNlLCBub3QgZ3Vlc3QgRUwwLiBUaGF0J3MgYmVjYXVzZSB0aGUNCj4gdmFyaW91cyBTUFNSXyog
cmVnaXN0ZXJzIGFyZSBhbHJlYWR5IHZpc2libGUgZnJvbSB1c2Vyc3BhY2UgYXMNCj4gS1ZNX1JF
R19BUk1fQ09SRV9SRUcoc3BzcltLVk1fU1BTUl8qXSksIGFuZCB0aGUgYWJvdmUgZW50cmllcyBh
cmUNCj4gc29sZWx5IGZvciB0aGUgcHVycG9zZSBvZiBoYW5kbGluZyBhIHRyYXAgKGFuZCB0aHVz
IG11c3Qgbm90IGJlDQo+IGV4cG9zZWQgaW4gdGhlIGxpc3Qgb2YgYXZhaWxhYmxlIHN5c3JlZ3Mp
Lg0KPiANCj4gVGhpcyBpcyBzaW1pbGFyIHRvIHdoYXQgd2UgYXJlIGRvaW5nIGZvciB0aGUgRUx4
MiByZWdpc3RlcnMsIHdoaWNoIGFyZQ0KPiBhbHJlYWR5IGV4cG9zZWQgYXMgRUwwL0VMMSByZWdp
c3RlcnMuDQo+IA0KPj4gQWxzbywgY291bGQgeW91IHBsZWFzZSBleHBsYWluIHdoYXQgaXMgaGFw
cGVuaW5nIGF0IFBTVEFURS5FTCA9PSBFTDENCj4+IGFuZCBpZiBFTDJFbmFibGVkKCkgJiYgSENS
X0VMMi5OViA9PSDigJgx4oCZICA/DQo+IA0KPiBXZSBkaXJlY3RseSB0YWtlIHRoZSB0cmFwIGFu
ZCBub3QgZm9yd2FyZCBpdC4gVGhpcyBpc24ndCBleGFjdGx5IHRoZQ0KPiBsZXR0ZXIgb2YgdGhl
IGFyY2hpdGVjdHVyZSwgYnV0IGF0IHRoZSBzYW1lIHRpbWUsIHRyZWF0aW5nIHRoZXNlDQo+IHJl
Z2lzdGVycyBhcyBSQVovV0kgaXMgdGhlIG9ubHkgdmFsaWQgaW1wbGVtZW50YXRpb24uIEkgZG9u
J3QNCj4gaW1tZWRpYXRlbHkgc2VlIGEgcHJvYmxlbSB3aXRoIHRha2luZyB0aGlzIHNob3J0Y3V0
Lg0KPiANCg0KVGhhbmsgeW91IGZvciBleHBsYWluaW5nIGFuZCBleHBhbmRpbmcgb24gdGhpcyB0
b3BpYy4NCg0KSSB3aWxsIHRha2Ugc29tZSB0aW1lIHRvIGFic29yYiBhbGwgeW91ciBjb21tZW50
cy4NCg0KVGhhbmsgeW91DQoNCk1pZ3VlbA0KDQoNCj4gTS4NCj4gDQo+IC0tIA0KPiBXaXRob3V0
IGRldmlhdGlvbiBmcm9tIHRoZSBub3JtLCBwcm9ncmVzcyBpcyBub3QgcG9zc2libGUuDQoNCg0K
