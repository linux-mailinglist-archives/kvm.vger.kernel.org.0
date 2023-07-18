Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD244757945
	for <lists+kvm@lfdr.de>; Tue, 18 Jul 2023 12:30:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230219AbjGRKaq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jul 2023 06:30:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229927AbjGRKaj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jul 2023 06:30:39 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B42DB10D2
        for <kvm@vger.kernel.org>; Tue, 18 Jul 2023 03:30:30 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36IAEPt0023620;
        Tue, 18 Jul 2023 10:29:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=P/Yow9TFm/tSCrXh7DNifzZHz4SxlXBr7v00+2azCHw=;
 b=2jMAJwrtfovVtpOgAMaRexoBNI0Lq7c8D2DI1bEh1zbJP2x/tNu5VZgmsmJLWknezxbT
 hArAJADwZSZr7LjywzTGL5hG3ML1p9ExbFa+sV+X/37414aojN1nyURVIXfgDdmP4mrU
 OGl0KIJ09A/nFVQKWBOh57kYpXWEGM3dx4VUVseOYki6RRdFDaYmpDy50OEsHKVC0gOD
 EWvS7izbFk5XQ3MuvvWyiLgHGUGIXm1kPbaHp6OTR3VlhXAXJgKvXBbau/4wX1PSxY7I
 lMqE9aHorB9eOLKuNSMeJC8odvdosuFABwvkTUjpDMxBwGoBYdl4Ksv0BQQQZy5clQUr fg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3run784pwn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jul 2023 10:29:27 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36IAEEe7007746;
        Tue, 18 Jul 2023 10:29:26 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2105.outbound.protection.outlook.com [104.47.55.105])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ruhw4n756-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jul 2023 10:29:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=clVSErS+tHcxXDqqMDHIMBV+B0gca6rtA5wUwH7ELK6r3cPQRfEBE6D83g/K+mySgaTUSzUJN1jdMiNEP5mGdrN0dfHZg6bfofJ2mLJ9IoxgkSwuRg/yB68rYECQ3MPGcOg9W2vfZkSSuEB+1XYvj2WqHiwnDsdqMLH464NW2WK+VRGbq7QR7imr5MtZvpCQUbLBtSN3qOh66EzvCbKkMdTPxn4kdF5QLTo3QbehV5xhqJkvE1G99mXiG4OJl5nbrU+77POSTpEyOPL+k0AjTjYhdEEWhYs4aAOKNq6j90s8/74eIqLs3Yaj+1QWySEIJEbaZ5vcXQf69zLM9q8wGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P/Yow9TFm/tSCrXh7DNifzZHz4SxlXBr7v00+2azCHw=;
 b=hb93XH94PGsU2J3ZmiiInEuuoqPrbrZgK+4pqH7EbuuBbrAM1IAiGN8Pb0Zv8NZw4K+dyocd0xPIPhpG0hNNvJaTbOeu4cgVUk/OnCz0Uc2FxoK23FqooDZfy9wm2qenccUYRzmkjLbUy3socdB4m1Fb2NSeKvN41rbcsTKiguctQeTNiXgOoZzbOnypZees8n8D8Rord4ysv55LK/WGHnTalplSm1sa6bskbU+X/LFbePTcNdGmZJ7g+q+IpQA0oB/gTaRis4kg6Pt7U1UDQJN09JQwAPSH8XZ+6y/ZEffioRekMr+AQLT/73R0VOb5S+HvbBga6KmB0iaCyXY45g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P/Yow9TFm/tSCrXh7DNifzZHz4SxlXBr7v00+2azCHw=;
 b=qgNwfVoUbh6q6RkGEY0f15wRUo6UIr0ue3XJxYSLrtDhRrbrDag76ZuCvqBnLhCbMdiIETbE+q7BwCr1RjCipFyGu6SwIR4Qiuznzgw+4nBndDAIGMr+RzO2wzk3djVdozl0S+o28Uc9U7rePb4s22RWxk+sx1MAADiUlGhbP9o=
Received: from PH0PR10MB5433.namprd10.prod.outlook.com (2603:10b6:510:e0::9)
 by PH7PR10MB6155.namprd10.prod.outlook.com (2603:10b6:510:1f4::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.31; Tue, 18 Jul
 2023 10:29:23 +0000
Received: from PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::2cd:1872:970d:7c4e]) by PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::2cd:1872:970d:7c4e%4]) with mapi id 15.20.6588.031; Tue, 18 Jul 2023
 10:29:23 +0000
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
Thread-Index: AQHZh1MX+qQj9H8mMkuYpu12F27VUa+gCbmAgAGXRgCAEaxOgIAMaW8A
Date:   Tue, 18 Jul 2023 10:29:23 +0000
Message-ID: <D2E568CE-DBC0-4333-9215-CFE0A6654FB4@oracle.com>
References: <20230515173103.1017669-1-maz@kernel.org>
 <f19bb506-3e21-2bd6-7463-9aea8ab912f5@os.amperecomputing.com>
 <877crmzr5j.wl-maz@kernel.org>
 <AB79D154-BA63-473B-8001-97245FE99DEA@oracle.com>
In-Reply-To: <AB79D154-BA63-473B-8001-97245FE99DEA@oracle.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR10MB5433:EE_|PH7PR10MB6155:EE_
x-ms-office365-filtering-correlation-id: 5cdb4d2c-15e3-44e5-beca-08db8779daba
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Unjf6oYQ8w5VArbwVjXW3Sl0Ub4mKArCvPhhRoTHDvF4BMTJCqz4zv/bqn4Z+JRqed27g0v4PGlnj+bpe+jocK6a5na8assOrhs5UJMo9l/Q155d5J/PNrCk23LLwWPlXmWdpcApcBcppRbWP7DY2JosVKnSwWlnACvxb79K+EMN9mTDQUZkcWVXQYXx32iP2288mbNrY3RWP8pu6HwRgH1F4W5e2YKPniWFKdO0YQbs8qxIcfDA6gxrdRaoweSXTw+4cDDcMkMx/W3BpJ92labTrhBvlAjxcrTCv1s6kYoSwqrTAAkKy5qHcLup/bP7P771B/sqMdofdQ387hwN/b2XtbPesSaDFnAZIDc7nQBkQaHW0+00TR+xNCoof+0kojmkbBdzE336pEvoZL5x0RIDT0MSNkQSZEd3wDzau0ojeNfjrniz3IqNqDE5jHTbRVlp3Za/NB/DxjRyIXUlQEEHJEVGXn8piblabG0bZeT4wr9Pn2g4pmUDyj3tdBQ+Pheht3P374UGZo1OhK76VfMXHX3OrscQbS0r7GSzsNMm+LoSsU14J5LL/WfYjxG/ydBz6mqTWWY5RIRNhvsAQyr0yQgIZzefcRrcNBYRnZUzQk6q7JUoVdcxHdyi8QhCk7PBkBiebvcvpZZQrb/w3w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5433.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(346002)(366004)(39860400002)(136003)(376002)(451199021)(54906003)(71200400001)(122000001)(6486002)(38100700002)(41300700001)(8676002)(8936002)(5660300002)(6916009)(76116006)(478600001)(66476007)(66946007)(66556008)(66446008)(64756008)(316002)(4326008)(91956017)(186003)(83380400001)(6512007)(2616005)(26005)(6506007)(53546011)(86362001)(36756003)(33656002)(44832011)(38070700005)(2906002)(7416002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RC8rT2IxdEVBT1UxNkdadGpXYVZza1AzbzliZ3BRNEhnTUNzYWlNMERVMGtT?=
 =?utf-8?B?cHQ2UXFUakRUWWExSll0cFpjTU8rTmtuOGZCcmxoTklYYk5KTlVHOHNEUjlF?=
 =?utf-8?B?Z29FUDhOV2pKWGFiTGo1alVWcUZZcGFaRmtWNHVXNWxXN3JmakhHeXkrY2E3?=
 =?utf-8?B?SlhQTlVTMlRoRXFRNFFUYTUyWlRLeW1uYTFTNmtFcEFadzEyTXpaaSsrK1Zj?=
 =?utf-8?B?NXNvczJ5M2RzRy9IcEZZN3JEK3hxRXlpanJiWGV0ZzY5OElRNXV1dFo5S3Bq?=
 =?utf-8?B?U1dxdkJGaTdiTUNhUVIxK01JWWMvYWNzWFU3VmRBLzdtZjZSSXFYV0dWY0g2?=
 =?utf-8?B?anJkaUE1c0pucElLMWY5MlUxdWRiNkp4Q3ZKd28zOHZ6OTdXNVh2b2ZDSzNW?=
 =?utf-8?B?TkRlRUs1empBVnRERGhwVmtwSktNNFpRVjZnRzZsZ0pXeng1b3Y3b253MjNz?=
 =?utf-8?B?cVZ0ZTQwVm1Vbjh0N1NrSDNYUU5DL1JDQnUrMkpzeTlXNENLZGN3ajdxYU1Z?=
 =?utf-8?B?cVNzNDdhN0MrQVp0OUdxb0NVL2Y0bjdFY1VWc2xaZCtTNW9tOUVEWDZ5a1Bt?=
 =?utf-8?B?bGRJV2JPZFJ2Y01pU2lPbmhTZnBWb3pNUjZDUkdHdFgyOFFQdnp0Nkd0OHdo?=
 =?utf-8?B?R2gyN1JTUjM0cTJQQ3o0dDNLblhmSDJDdWVjQmtnbDRSWUZROW5xOWFJTEJP?=
 =?utf-8?B?VzJ0cE5qbVlkd2NDTjNrTy9URVZOd3pRaGwwdFlhOXBGSC9BNk5ySnZyZ1Vj?=
 =?utf-8?B?WlNMRktMdFhUVG1Ra0JmTG9ZdDd2alBHNDVzQ0R0bHVBOS9hOHpMbFdXUmht?=
 =?utf-8?B?RFpLdThxRDY0emZGUGZNQ0NHNzVza2svbHhORUZ0WHdtQ0MvQ0o2cnpZakt3?=
 =?utf-8?B?L3BXcDhla0VBa0lwWVphaSs1STFpdTdHYU9TTyswNFh0YXBIVnNlU0E1TWZn?=
 =?utf-8?B?UENHZHBselBOalNEMllWdzIzTHZyYWNEMmsvdnNYRUdzWFBldVBRREJPQnFV?=
 =?utf-8?B?bVV1VnI3M1dKVEZPZ21lRHBTelJxOCt3cVNSayt5QkFnb3pDUmNZbEkrVUhM?=
 =?utf-8?B?QXFibUVhT09hQ0hmL1VZd0UvMXhjdEtoMmNnRkZCWDRhc294Z0JPZlBLVGNv?=
 =?utf-8?B?dzVFODMzNTlXMk40eW1qZ1lYSWx2d085TFVXRmsyK1pDNFdJVlo2dVJsckcv?=
 =?utf-8?B?S0hmMHQxeDNxK1psL2VSZkZ2cUJNWS9iYVA1aXRrWklRc3hnM1VuNmNMdHNF?=
 =?utf-8?B?TDFaT2wyS0JUOHI3ejlMaG52eWQrU2o2ejJXTmtMRnVMSHFxR3c3akw1UnBn?=
 =?utf-8?B?bUtCamZwek5FMDVvQys5Yk5DQ3hFc09HeUxPOEtSVUpja0ZUQ0hmc2hON0ZM?=
 =?utf-8?B?ZFN3TWNCSUViSTN0b25NeWd6d2x2WmNuWGR4RldxNWVpa3RoTXFPVTdSU3ZH?=
 =?utf-8?B?cThjei94RDFNOGpEeDNkd1ZjT04zMTE2YWxuc0d5TkVkOFlHWTNDTXFkWHJG?=
 =?utf-8?B?QjJJTUQ1c0VtNER4S2NlNitlbTRCdFdmV3BhVDRnWW9yY2V4WlBTTVQ0Qkt5?=
 =?utf-8?B?VHZZemk3YVduaXBpc2tyaGJMcHdtU29vM0NHNWVDc05MNXVOUzgwYW9ncDY1?=
 =?utf-8?B?V09MeWp2UjAwU0VlTVZPbGR3YVFHb1VCbnVxOHF2N3RoUlNZUnVXNEl1cFpT?=
 =?utf-8?B?aCtvWTcrQkptMHQ3emVRSGJZU2VEUnRheWQyY3ZyVVdmOG1kT3JZKzFnRGdW?=
 =?utf-8?B?dXpVZHpSM1VzeEd5ZzVWT0poaCtyZldMcW5IU0xRb0doRENIV2g5SGFBTGE1?=
 =?utf-8?B?Q1JhZkl3U05qNFNxQkF4TzlNNW9tNTFYZ3ZFR3IrR0svMm9IUkNmMy80NExH?=
 =?utf-8?B?MzEwUUtCNjJ2dXlFUTZ1SUUwVEdsU1BETUtoaWttWmFFT3QvZTQrOWRiOTB3?=
 =?utf-8?B?VWovZEh2SnNpTS9wOGxodjNRek1kWWhPZmtpUjZDcUJMMWdwVDNJZERua3I1?=
 =?utf-8?B?VXJDR3N0alVWSUdOQ3ZqN3Bkb0VveVdkam5VdFhKSkl2NlJsOGZZNmJ6TExq?=
 =?utf-8?B?ZmdwSjltNzNRYjNLdytFeklqTjlBOU5yaVRIOGdhQXV0WGRHZ0FTQjdpMURM?=
 =?utf-8?B?NExHVk4xTk5uSHB4N0F0RlRTbzNvU1RHaXVyMG9XbUhqMFlOM1BNZWdJVm1K?=
 =?utf-8?B?MXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E2834C40231C19428D2572F0C8BBF8DF@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?SG5OU1hwVjFWSjRYU1l1Y29IdkN4bW1jUHpoUDhjTHNpOTdvV0tpVGdKV1ZJ?=
 =?utf-8?B?M2xOVTdFWEpGazZXTjQvRjJuTjlQbSt0KzJDRHZRR3BIUE52U0dPeTdZWVox?=
 =?utf-8?B?Z1Y4ajdEL04zcjViMWRDTDNkWG96d1AxbENTajlqRTRYN2R2aENVY2hXRlVR?=
 =?utf-8?B?Q1VDU3UrRGRBckEyS3dVclluSzZRdmlnTnM5ZTVHaDJKazVEVjJHc05LZkxm?=
 =?utf-8?B?ZnBIeEk1ZWJicy9haVFlQWwzVnhFeEpOR3Bpc244KzBkK1ZzdHR2c1lYa3g5?=
 =?utf-8?B?NVZNS3NJWmdJakgwTWVaazlpSWtQNUtBRE5GYzh6bTBVaDJRMEtRNUxnd08v?=
 =?utf-8?B?blFPWnRkZmlSeEVadWhKUk1nMFZWTXJFQW9JTk80MHgrM2VVUUNvNGozcFpy?=
 =?utf-8?B?a28wS1R5WVMrcWx3ZDFiWWVDQ3dDdytsc3RwSk1vNTRieGYrY3NjdGt2MHlM?=
 =?utf-8?B?OUlrMkg2bWtkTEduc1hKOVhleTZMWE9HbGpUL1NhaDVQQmFaYlJnQWNsYndz?=
 =?utf-8?B?bTAydjQyeHNxUEZ5bjR2MUttSGg5Q1pCR1IzZW1XZDlBSlVlekorZ3FqaVUx?=
 =?utf-8?B?NlUrT2owNTVKM0hsWXFJQjNySXFpekN3UFIvS0Q0UTNsMGUzbndJVUJ5SE02?=
 =?utf-8?B?SUFhckhVVEkrUXhPWCt5WDR3RmMyVmo4dnc3SmowdC85U2Q4Q1hHQ2tMYWJ0?=
 =?utf-8?B?SkxEMXBkeFhSRTlJTkR2dGg1MmVNMjExTmswMyswMWljVFpwQ2NXMjd1TEVB?=
 =?utf-8?B?V2w5UkNQTVN1UTZnOEc2Q2dRV2gvWmh0K0Fac1RZb0dkbzFYaVU1bUpPSEZn?=
 =?utf-8?B?K0JDODdNQVVJWFEwTEc1QzdqM0FQQWNDNXFxTXVzVTVXbXFXYVkzUWxpMllx?=
 =?utf-8?B?aWl3ckZiMDZYNVVSRG5tRTNZYzcxcXdoNGczVW9mY1dzNnAvZEsxbEt5MnAx?=
 =?utf-8?B?eVdRV1hlRW1jaEhBbVdOWmFhZ3RJSFZXd1FFRGxvUGVDWUhTOGltTENDRHZW?=
 =?utf-8?B?MTlJZGhLelp5Umt6L09mZHlJaERweVBENEh6bHVlRGhBeGFtSmRvRnYzbEk3?=
 =?utf-8?B?aU1DaFRtV0RXOG1iNjRRUTJ1OVpabkluZkU3QTdHWGdxMTRmTkVPRVRueUNt?=
 =?utf-8?B?bnlBbU5xanNOUGhVZXNWOVF4RUxXM1ZtQUFCMHhUUGsyTzd0YnJTSHpKN1E2?=
 =?utf-8?B?NVRuMnVVeHBBdm5HVTVvNURQSnhRTmtWd2FEYmRVWjI4Q1M4dGljTXlpcFho?=
 =?utf-8?B?SFJiL2RVWEFBNUxLdG9iancyNmtZMFFEY3lhWkpMbVlabFlwYTIrcTFrSmNN?=
 =?utf-8?B?SzNORUNJL2NiYWVaVGN5T2RpOXJsdkZRL3FHTFc1aHF2dmRsVGpNM2R3aWRh?=
 =?utf-8?B?c1VCSzc3ODhleitwRElUbVFOT1FKcDAxQU83d3RlWExLWkdFUm1qSVhVQTlT?=
 =?utf-8?B?ekhQQ1RKYnhZYTZIYXN5UmJHUzM5V0xmUmdPRGg1TWNuL2F4SnhaWnJPS21V?=
 =?utf-8?B?eGNJb2NIYVozYVNKU3ZEUnJuTlhaUEhZNnZZK1lqS29uYmRiQjB0ZWxyZWtW?=
 =?utf-8?B?R0VHQT09?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5433.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5cdb4d2c-15e3-44e5-beca-08db8779daba
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jul 2023 10:29:23.3320
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: S6HfEo7xUk2pRFH8Neq2rqZgCznOqtj+oomL1o+62cMKBpJ2WBdZfElOGAiSB5Q4pBIfmSY8iO/7OwNr0WfbFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6155
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-17_15,2023-07-18_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 spamscore=0 phishscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307180095
X-Proofpoint-ORIG-GUID: vnvlCm0FqG2SVMQVx10-I7auD3EVbMOE
X-Proofpoint-GUID: vnvlCm0FqG2SVMQVx10-I7auD3EVbMOE
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGkgTWFyYywNCg0KPiBPbiAxMCBKdWwgMjAyMywgYXQgMTI6NTYsIE1pZ3VlbCBMdWlzIDxtaWd1
ZWwubHVpc0BvcmFjbGUuY29tPiB3cm90ZToNCj4gDQo+IEhpIE1hcmMsDQo+IA0KPj4gT24gMjkg
SnVuIDIwMjMsIGF0IDA3OjAzLCBNYXJjIFp5bmdpZXIgPG1hekBrZXJuZWwub3JnPiB3cm90ZToN
Cj4+IA0KPj4gSGkgR2FuYXBhdHJhbywNCj4+IA0KPj4gT24gV2VkLCAyOCBKdW4gMjAyMyAwNzo0
NTo1NSArMDEwMCwNCj4+IEdhbmFwYXRyYW8gS3Vsa2FybmkgPGdhbmt1bGthcm5pQG9zLmFtcGVy
ZWNvbXB1dGluZy5jb20+IHdyb3RlOg0KPj4+IA0KPj4+IA0KPj4+IEhpIE1hcmMsDQo+Pj4gDQo+
Pj4gDQo+Pj4gT24gMTUtMDUtMjAyMyAxMTowMCBwbSwgTWFyYyBaeW5naWVyIHdyb3RlOg0KPj4+
PiBUaGlzIGlzIHRoZSA0dGggZHJvcCBvZiBOViBzdXBwb3J0IG9uIGFybTY0IGZvciB0aGlzIHll
YXIuDQo+Pj4+IA0KPj4+PiBGb3IgdGhlIHByZXZpb3VzIGVwaXNvZGVzLCBzZWUgWzFdLg0KPj4+
PiANCj4+Pj4gV2hhdCdzIGNoYW5nZWQ6DQo+Pj4+IA0KPj4+PiAtIE5ldyBmcmFtZXdvcmsgdG8g
dHJhY2sgc3lzdGVtIHJlZ2lzdGVyIHRyYXBzIHRoYXQgYXJlIHJlaW5qZWN0ZWQgaW4NCj4+Pj4g
IGd1ZXN0IEVMMi4gSXQgaXMgZXhwZWN0ZWQgdG8gcmVwbGFjZSB0aGUgZGlzY3JldGUgaGFuZGxp
bmcgd2UgaGF2ZQ0KPj4+PiAgZW5qb3llZCBzbyBmYXIsIHdoaWNoIGRpZG4ndCBzY2FsZSBhdCBh
bGwuIFRoaXMgaGFzIGFscmVhZHkgZml4ZWQgYQ0KPj4+PiAgbnVtYmVyIG9mIGJ1Z3MgdGhhdCB3
ZXJlIGhpZGRlbiAoYSBidW5jaCBvZiB0cmFwcyB3ZXJlIG5ldmVyDQo+Pj4+ICBmb3J3YXJkZWQu
Li4pLiBTdGlsbCBhIHdvcmsgaW4gcHJvZ3Jlc3MsIGJ1dCB0aGlzIGlzIGdvaW5nIGluIHRoZQ0K
Pj4+PiAgcmlnaHQgZGlyZWN0aW9uLg0KPj4+PiANCj4+Pj4gLSBBbGxvdyB0aGUgTDEgaHlwZXJ2
aXNvciB0byBoYXZlIGEgUzIgdGhhdCBoYXMgYW4gaW5wdXQgbGFyZ2VyIHRoYW4NCj4+Pj4gIHRo
ZSBMMCBJUEEgc3BhY2UuIFRoaXMgZml4ZXMgYSBudW1iZXIgb2Ygc3VidGxlIGlzc3VlcywgZGVw
ZW5kaW5nIG9uDQo+Pj4+ICBob3cgdGhlIGluaXRpYWwgZ3Vlc3Qgd2FzIGNyZWF0ZWQuDQo+Pj4+
IA0KPj4+PiAtIENvbnNlcXVlbnRseSwgdGhlIHBhdGNoIHNlcmllcyBoYXMgZ29uZSBsb25nZXIg
YWdhaW4uIEJvby4gQnV0DQo+Pj4+ICBob3BlZnVsbHkgc29tZSBvZiBpdCBpcyBlYXNpZXIgdG8g
cmV2aWV3Li4uDQo+Pj4+IA0KPj4+IA0KPj4+IEkgYW0gZmFjaW5nIGlzc3VlIGluIGJvb3Rpbmcg
TmVzdGVkVk0gd2l0aCBWOSBhcyB3ZWxsIHdpdGggMTAgcGF0Y2hzZXQuDQo+Pj4gDQo+Pj4gSSBo
YXZlIHRyaWVkIFY5L1YxMCBvbiBBbXBlcmUgcGxhdGZvcm0gdXNpbmcga3ZtdG9vbCBhbmQgSSBj
b3VsZCBib290DQo+Pj4gR3Vlc3QtSHlwZXJ2aXNvciBhbmQgdGhlbiBOZXN0ZWRWTSB3aXRob3V0
IGFueSBpc3N1ZS4NCj4+PiBIb3dldmVyIHdoZW4gSSB0cnkgdG8gYm9vdCB1c2luZyBRRU1VKG5v
dCB1c2luZyBFREsyL0VGSSksDQo+Pj4gR3Vlc3QtSHlwZXJ2aXNvciBpcyBib290ZWQgd2l0aCBG
ZWRvcmEgMzcgdXNpbmcgdmlydGlvIGRpc2suIEZyb20NCj4+PiBHdWVzdC1IeXBlcnZpc29yIGNv
bnNvbGUob3Igc3NoIHNoZWxsKSwgSWYgSSB0cnkgdG8gYm9vdCBOZXN0ZWRWTSwNCj4+PiBib290
IGhhbmdzIHZlcnkgZWFybHkgc3RhZ2Ugb2YgdGhlIGJvb3QuDQo+Pj4gDQo+Pj4gSSBkaWQgc29t
ZSBkZWJ1ZyB1c2luZyBmdHJhY2UgYW5kIGl0IHNlZW1zIHRoZSBHdWVzdC1IeXBlcnZpc29yIGlz
DQo+Pj4gZ2V0dGluZyB2ZXJ5IGhpZ2ggcmF0ZSBvZiBhcmNoLXRpbWVyIGludGVycnVwdHMsDQo+
Pj4gZHVlIHRvIHRoYXQgYWxsIENQVSB0aW1lIGlzIGdvaW5nIG9uIGluIHNlcnZpbmcgdGhlIEd1
ZXN0LUh5cGVydmlzb3INCj4+PiBhbmQgaXQgaXMgbmV2ZXIgZ29pbmcgYmFjayB0byBOZXN0ZWRW
TS4NCj4+PiANCj4+PiBJIGFtIHVzaW5nIFFFTVUgdmFuaWxsYSB2ZXJzaW9uIHY3LjIuMCB3aXRo
IHRvcC11cCBwYXRjaGVzIGZvciBOViBbMV0NCj4+IA0KPj4gU28gSSB3ZW50IGFoZWFkIGFuZCBn
YXZlIFFFTVUgYSBnby4gT24gbXkgc3lzdGVtcywgKm5vdGhpbmcqIHdvcmtzIChJDQo+PiBjYW5u
b3QgZXZlbiBib290IGEgTDEgd2l0aCAndmlydHVhbGl6YXRpb249b24iICh0aGUgZ3Vlc3QgaXMg
c3R1Y2sgYXQNCj4+IHRoZSBwb2ludCB3aGVyZSB2aXJ0aW8gZ2V0cyBwcm9iZWQgYW5kIHdhaXRz
IGZvciBpdHMgZmlyc3QgaW50ZXJydXB0KS4NCg0KSW4gb3JkZXIgdG8gdXNlIHRoZSBwcmV2aW91
cyBwYXRjaGVzIHlvdSBuZWVkIHRvIHVwZGF0ZSB0aGUgbGludXggaGVhZGVycw0Kb2YgUUVNVSBh
Y2NvcmRpbmcgdG8gdGhlIHRhcmdldCBrZXJuZWwgeW914oCZcmUgdGVzdGluZy4gU28geW91IHdv
dWxkIHdhbnQgdG8gcnVuDQouL3NjcmlwdHMvdXBkYXRlLWxpbnV4LWhlYWRlcnMuc2ggPGtlcm5l
bCBzcmMgZGlyPiA8cWVtdSBzcmMgZGlyPiBpbiB0aGUgcGxhY2Ugb2YNCnBhdGNoIDEgdGhlbiB5
b3Ugc2hvdWxkIGJlIGFibGUgdG8gYm9vdCB0aGUgTDEgZ3Vlc3Qgd2l0aCB2aXJ0dWFsaXphdGlv
bj1vbi4NCg0KUmVnYXJkaW5nIHRoZSBMMiBndWVzdCwgaXQgZG9lcyBub3QgYm9vdCBhbmQgSeKA
mW0gaW4gdGhlIHByb2Nlc3Mgb2YNCnVuZGVyc3RhbmRpbmcgd2h5LiBUaGUgcHJldmlvdXMgcGF0
Y2hlcyBoYWQgc29tZSBpbXByb3ZlbWVudHMgdG8gbWFrZQ0KYnV0IEkgY291bGRu4oCZdCByZWxh
dGUgdGhlbSB0byBub3QgYm9vdGluZyB0aGUgTDIgZ3Vlc3QsIHlldC4NCg0KRXJpYyBzdGF0ZWQg
YW4gaXNzdWUgd2l0aCBOViBhbmQgU1ZFIGVuYWJsZW1lbnQgd2hpY2ggSeKAmW0gc3RpbGwgbG9v
a2luZyBhdC4NCiggd2hpY2ggaXMgc2ltaWxhciB0byB0aGUgY29tbWl0DQo1YjU3OGYwODhhZGEz
YzQzMTlmNzI3NGMwMjIxYjVkOTIxNDNmZTZhIGluIHlvdXIga3ZtdG9vbCBicmFuY2ggYXJtNjQv
bnYtNS4xNiApDQoNCkFzIGEgdGVzdCBJ4oCZdmUgZGlzYWJsZWQgU1ZFIG9uIHRoZSBrZXJuZWwg
c2lkZSB3aXRoICdhcm02NC5ub3N2ZeKAmSBhbmQNCnRoZSBvdXRwdXQgbWF0Y2hlcyB0aGUgb25l
IGZyb20geW91ciBrdm10b29sOg0KDQpbICAgIDAuMDAwMDAwXSBDUFUgZmVhdHVyZXM6IFNZU19J
RF9BQTY0UEZSMF9FTDFbMzU6MzJdOiBhbHJlYWR5IHNldCB0byAwDQpbICAgIDAuMDAwMDAwXSBD
UFUgZmVhdHVyZXM6IFNZU19JRF9BQTY0WkZSMF9FTDFbNTk6NTZdOiBhbHJlYWR5IHNldCB0byAw
DQpbICAgIDAuMDAwMDAwXSBDUFUgZmVhdHVyZXM6IFNZU19JRF9BQTY0WkZSMF9FTDFbNTU6NTJd
OiBhbHJlYWR5IHNldCB0byAwDQpbICAgIDAuMDAwMDAwXSBDUFUgZmVhdHVyZXM6IFNZU19JRF9B
QTY0WkZSMF9FTDFbNDc6NDRdOiBhbHJlYWR5IHNldCB0byAwDQpbICAgIDAuMDAwMDAwXSBDUFUg
ZmVhdHVyZXM6IFNZU19JRF9BQTY0WkZSMF9FTDFbNDM6NDBdOiBhbHJlYWR5IHNldCB0byAwDQpb
ICAgIDAuMDAwMDAwXSBDUFUgZmVhdHVyZXM6IFNZU19JRF9BQTY0WkZSMF9FTDFbMzU6MzJdOiBh
bHJlYWR5IHNldCB0byAwDQpbICAgIDAuMDAwMDAwXSBDUFUgZmVhdHVyZXM6IFNZU19JRF9BQTY0
WkZSMF9FTDFbMjM6MjBdOiBhbHJlYWR5IHNldCB0byAwDQpbICAgIDAuMDAwMDAwXSBDUFUgZmVh
dHVyZXM6IFNZU19JRF9BQTY0WkZSMF9FTDFbMTk6MTZdOiBhbHJlYWR5IHNldCB0byAwDQpbICAg
IDAuMDAwMDAwXSBDUFUgZmVhdHVyZXM6IFNZU19JRF9BQTY0WkZSMF9FTDFbNzo0XTogYWxyZWFk
eSBzZXQgdG8gMA0KWyAgICAwLjAwMDAwMF0gQ1BVIGZlYXR1cmVzOiBTWVNfSURfQUE2NFpGUjBf
RUwxWzM6MF06IGFscmVhZHkgc2V0IHRvIDANCg0KVGhhdCBkaWRu4oCZdCBlbmFibGVkIHRoZSBM
MiBndWVzdCB0byBib290IG9uIFFFTVUgc28gdGhlIGlzc3VlIGZlZWxzIHN0aWxsIGluIGEgZ3Jl
eSBhcmVhLg0KDQpBcyBhIGJhc2VsaW5lIEkgdGVzdGVkIHlvdXIga3ZtdG9vbCBicmFuY2ggZm9y
IDUuMTYgYWZ0ZXIgdXBkYXRpbmcgdGhlIGluY2x1ZGVzLA0KYW5kIGFzIEkgZXhwZWN0ZWQgYm90
aCBMMSBhbmQgTDIgZ3Vlc3RzIGJvb3QuDQoNCk1pZ3VlbA0KDQo+PiANCj4+IFdvcnNlLCBib290
aW5nIGEgaFZIRSBndWVzdCByZXN1bHRzIGluIFFFTVUgZ2VuZXJhdGluZyBhbiBhc3NlcnQgYXMg
aXQNCj4+IHRyaWVzIHRvIGluamVjdCBhbiBpbnRlcnJ1cHQgdXNpbmcgdGhlIFFFTVUgR0lDdjMg
bW9kZWwsIHNvbWV0aGluZw0KPj4gdGhhdCBzaG91bGQgKk5FVkVSKiBiZSBpbiB1c2Ugd2l0aCBL
Vk0uDQo+PiANCj4+IFdpdGggaGVscCBmcm9tIEVyaWMsIEkgZ290IHRvIGEgcG9pbnQgd2hlcmUg
dGhlIGhWSEUgZ3Vlc3QgY291bGQgYm9vdA0KPj4gYXMgbG9uZyBhcyBJIGtlcHQgaW5qZWN0aW5n
IGNvbnNvbGUgaW50ZXJydXB0cywgd2hpY2ggaXMgYWdhaW4gYQ0KPj4gc3ltcHRvbSBvZiB0aGUg
dkdJQyBub3QgYmVpbmcgdXNlZC4NCj4+IA0KPj4gU28gc29tZXRoaW5nIGlzICptYWpvcmx5KiB3
cm9uZyB3aXRoIHRoZSBRRU1VIHBhdGNoZXMuIEkgZG9uJ3Qga25vdw0KPj4gd2hhdCBtYWtlcyBp
dCBwb3NzaWJsZSBmb3IgeW91IHRvIGV2ZW4gYm9vdCB0aGUgTDEgLSBpZiB0aGUgR0lDIGlzDQo+
PiBleHRlcm5hbCwgaW5qZWN0aW5nIGFuIGludGVycnVwdCBpbiB0aGUgTDIgaXMgc2ltcGx5IGlt
cG9zc2libGUuDQo+PiANCj4+IE1pZ3VlbCwgY2FuIHlvdSBwbGVhc2UgaW52ZXN0aWdhdGUgdGhp
cz8NCj4gDQo+IFllcywgSSB3aWxsIGludmVzdGlnYXRlIGl0LiBTb3JyeSBmb3IgdGhlIGRlbGF5
IGluIHJlcGx5aW5nIGFzIEkgdG9vayBhIGJyZWFrDQo+IHNob3J0IGFmdGVyIEtWTSBmb3J1bSBh
bmQgSeKAmXZlIGp1c3Qgc3RhcnRlZCB0byBzeW5jIHVwLg0KPiANCj4gVGhhbmtzLA0KPiBNaWd1
ZWwNCj4gDQo+PiANCj4+IEluIHRoZSBtZWFudGltZSwgSSdsbCBhZGQgc29tZSBjb2RlIHRvIHRo
ZSBrZXJuZWwgc2lkZSB0byByZWZ1c2UgdGhlDQo+PiBleHRlcm5hbCBpbnRlcnJ1cHQgY29udHJv
bGxlciBjb25maWd1cmF0aW9uIHdpdGggTlYuIEhvcGVmdWxseSB0aGF0DQo+PiB3aWxsIGxlYWQg
dG8gc29tZSBjbHVlcyBhYm91dCB3aGF0IGlzIGdvaW5nIG9uLg0KPj4gDQo+PiBUaGFua3MsDQo+
PiANCj4+IE0uDQo+PiANCj4+IC0tIA0KPj4gV2l0aG91dCBkZXZpYXRpb24gZnJvbSB0aGUgbm9y
bSwgcHJvZ3Jlc3MgaXMgbm90IHBvc3NpYmxlLg0KDQoNCg==
