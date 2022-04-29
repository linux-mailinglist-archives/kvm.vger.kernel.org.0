Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56B15515105
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 18:41:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354648AbiD2QpA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Apr 2022 12:45:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231124AbiD2Qo7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Apr 2022 12:44:59 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5085D393CD
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 09:41:40 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23TEfD60018603;
        Fri, 29 Apr 2022 16:41:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=g7q5TppTtUJL3YJZQniRWgrDZRS5ftgov5itt5cMh3g=;
 b=A7fa2wMbQ1ZqnLn1dBvmyo2HJxDdGk+aR6/CTiJek56xqQaYm/R5XArKRZLp3nuAFYpX
 cFKMdxJ0vwvJ2S2WZnDV4so8nfXe4/arZ8tFmymk7ktefxYk0+B2Nnv7ngMZy4TJBkI9
 iwkyWbtepPFB9L8QB5bnVTbJKbzTHRiknr6G7VLasHGrnkuTYJYsr2bWxD+1Yw10VsrY
 vsz5d2OgexXs6brsk8j5T0DkkjRf4jVndmZzWIFLS5jygrqoR1FvDOahI/tGZdoGzpCE
 LjN4BtI2C0/WQk9auK+uZHbe2mkWd6DQL/pbwpfrBV+V5g5bLejkiEnY2KhP1PgFCSm8 zQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fmb5k7bkb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Apr 2022 16:41:09 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23TGUsHJ011127;
        Fri, 29 Apr 2022 16:41:08 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2176.outbound.protection.outlook.com [104.47.57.176])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fp5yqcgxb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Apr 2022 16:41:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ifs1azfKv887kwCGzIynetf22tz7BYk3XR1JbuhzathU/ptw5kljiY373S4XCvsdSc1YwDySF472AqbHaEthnkALbGQMJBDaZ1EEWPr7Im8sFUnSOM0lRfNhLfN6kz/AvmGx1Xi4Mq6dNpV4PV8PPDgKFcdrYsipFYNSQzF2GcP83e6MWGB145tAkdeEM6eRd/kO74p2sHSsy5t2iXw4RFgaMf8bGYoXB1TZ5j135xlnJbQ1rp3/RBUqbwmfQVkDHVRDkGKrUSC9VCMxZwTjJmpsCfeGIiyE6ocEbZBZagAFq5kGtT+q+Tgky1iw1G2Ns1eDNdDtd8gp7kOJHZZr9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g7q5TppTtUJL3YJZQniRWgrDZRS5ftgov5itt5cMh3g=;
 b=M+w0C4tdAx+xGy3OAUltF9nOAlyMKUEv2HXIyVeV6xbAEjONYG0OBWMChYDrchw48JR6caGyjVQhkOi4a3xpGFOdwKJVW2dQLRYZ92YeQgWOHOrC1fAK6RMohDsVyS9z+hkxFpaEPEKQ2gnseRoc7MQndFQ4ZQosESFqttms7GlDcXXmzPKEUDmm9Kc81jCKKuQKdnZXYZdnQb1c6ZfBrCY/ypqPJmbq63sNdtmK0B5mQEV4f6V1sthyBHDg8fIit1VZnlmb3qR6JoEDjiDi9+K1ZH65qzPt7MlOJeAdIIyv8jWKf5dMVWnbXFudZn4U5ShQx+Lag0+PymDalFTHIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g7q5TppTtUJL3YJZQniRWgrDZRS5ftgov5itt5cMh3g=;
 b=LdfbHgSJPeU8b+npxF1Q2jwyYQkyug0qCRtRCQSyevORjRHrhiiIILdK9JaRNr+54WEb7CQPc9ixt7y0rsbqvZR6MM6f1M4V/RJbS9S4Z9MyZ0WAISrOSetHIPx+6ep3Qk4wSj8Cgn93yXnhJscg4mCGQJ3MXFMfLHXs4jEP1bg=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by MN2PR10MB3984.namprd10.prod.outlook.com (2603:10b6:208:1bf::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.18; Fri, 29 Apr
 2022 16:41:06 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d%5]) with mapi id 15.20.5206.013; Fri, 29 Apr 2022
 16:41:06 +0000
Message-ID: <e238dd28-2449-ec1e-ee32-08446c4383a9@oracle.com>
Date:   Fri, 29 Apr 2022 17:40:56 +0100
Subject: Re: [PATCH RFC 15/19] iommu/arm-smmu-v3: Add
 set_dirty_tracking_range() support
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Robin Murphy <robin.murphy@arm.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>
References: <20220428210933.3583-1-joao.m.martins@oracle.com>
 <20220428210933.3583-16-joao.m.martins@oracle.com>
 <BN9PR11MB5276AEDA199F2BC7F13035B98CFC9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <f37924f3-ee44-4579-e4e2-251bb0557bfc@oracle.com>
 <a0331f20-9cf4-708e-a30d-6198dadd1b23@arm.com>
 <e1c92dad-c672-51c6-5acc-1a50218347ff@oracle.com>
 <20220429122352.GU8364@nvidia.com>
 <bed35e91-3b47-f312-4555-428bb8a7bd89@oracle.com>
 <20220429161134.GB8364@nvidia.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <20220429161134.GB8364@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR07CA0007.eurprd07.prod.outlook.com
 (2603:10a6:208:ac::20) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1b95416c-b6e1-41a7-3ed5-08da29ff0e56
X-MS-TrafficTypeDiagnostic: MN2PR10MB3984:EE_
X-Microsoft-Antispam-PRVS: <MN2PR10MB39840F9A34701C9F5334AFFFBBFC9@MN2PR10MB3984.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o8nA+TFROTc86TSTJ2h+SwBnWCUEQ0r2nyWkw032vh0+cJUU6/H67W6g1XYl7EVIJjY5EWuKOg6lKR5SQc4Nvso1m7WejtsUd6tNUkwf75APVhcXtaZbrGEOU3JVbcnsPPmCSTKoD4RZ8oj98Wh55uGweC6rXTIBXSfXKgqPp1r9i2tTTs2G1SmH0A5n15MJtT0IHKLgJ5U9MQW43iE6xTse2ROsAa+D+G8Dz/zjNs8tS9/TvGkEyheT1EfOshwJs9DIw6T+gXkT+eGf6MGKLdv07K31MJZn4bWussEJoyABUcJOJO+idzoRMPyCfbxrXoVlwi+QfiOB0Y8UjhyXURt3K/UvDIQd+JNj5ks0lvLcLiaklUufzwzSsMv8ytr7p/SoEaZ8lEaVY0kgXknopBwNTxKGOZ6GUOMAZ3vTqrJCeIIwD6ciLNNWiTBjWop76l71LAmSdIEz0EtgI5ZE0tcqwTYG244yESLflMxbsZ7qALXKTOhjVSjzHstqVEN2ZCyugD5utaMou4cwjh0tonlicB91DJWrpOx5/0XBTORWp9ZGSCgrE9Qjm5QabsCOsBP6VscJ2LM9Zl2EQ8n5nxflNrzwafe1kuTMEtnTPcNDSEDB0Y0l9yenfHqQHB2DGxIsJcXxbaA2vp58YnNwP/q9+mlQnlj1ZP7siU9FJDealBsNAKOYwmPYnLw2jR3nmIcaVwxQw0l1kU7/qqgN1T9RH7f9pm4y4YHClOJJ2G0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6486002)(6666004)(6512007)(26005)(6506007)(53546011)(8676002)(66476007)(66556008)(66946007)(31696002)(4326008)(508600001)(38100700002)(83380400001)(186003)(2616005)(54906003)(316002)(6916009)(2906002)(86362001)(8936002)(5660300002)(7416002)(36756003)(31686004)(14143004)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WnpLbW9FcG1hVUJVN2swS3d5bWtDb2lOMFNYbUk0NXFrTlB1RUhya1Vjd3Rk?=
 =?utf-8?B?SGoxaWFRaEJuZUlQdy83WXNKY3ozSWR4Vnh3TzFYbnlvd1dNMHVrMHI0ZDNa?=
 =?utf-8?B?aVhRWENIZE1FWHdUc25CSVR1bzNBMHpacHZjVHM4ZVFuSE5WaHAwL3plbHhH?=
 =?utf-8?B?SDlqOGFqVjlHOWdQYlE4WEtVMThHYmRZcUVwc3JRUENzazRXTFFvcXUvb21E?=
 =?utf-8?B?eXQwMzNxV0NSY3l0V005Wk5BbXk3UGhYOGNDeWxlRUcrbGRwcnhYUFRHNHNq?=
 =?utf-8?B?ZS9RMEUrZWpZOU5mWmxyU0RPWkZPM2F3ekNpV2VOeDRuSzNEM3ZNR3hYOTJv?=
 =?utf-8?B?WDMwM29TTHNrdVNxYTFzVVRGeCt0dGRrVXNLNDNTUVdwY21nOUFEc2QybDI1?=
 =?utf-8?B?U2s5d0JSdDJ2QWFRbDFTVUFYekUxZkxLZFQvUU1PL2FhME0vWHRyeDRCMjRT?=
 =?utf-8?B?azkxdzZmSkthdEJPMHh1QTlsdVp5TDlKWkpkeCtJRDdkaWVsMWxWMEEvQVJt?=
 =?utf-8?B?a1I4bEM4RGpTY055VG0rZFc3K1VCNHcxKzhtaGVKdTF6RFVxOTZicGEyTWUv?=
 =?utf-8?B?aVpzRGlKK2ZGN1VKaEc5T2hzZFJLVFBTTmNjNGZzREJudzE0ZXJxdnBudlpW?=
 =?utf-8?B?THlCWlBwbWhyOEJvcW5YcjFUd1JVelJXZjFLeWhNdUZaVi9CQ2V5MkNNOWhH?=
 =?utf-8?B?T2RTK0VNdkVDMEVPaUQ3Tmhxc0JGemVtMkdQRGhBWFVDMzZNYTBEUjdjLzdt?=
 =?utf-8?B?SHVGcUszcG55NzRUeXNzWjhxU0Vtekt0ODdSc0wwY3JXck1sb0NzR2thdjhU?=
 =?utf-8?B?ZkRQOFkvZ21CUkVrRithbFpLRG9aamZuTDBXOFRyaTdQWU9GYUorN0hVak5R?=
 =?utf-8?B?ZnVycWJWZENvV3NIQlc2NjFBMEVJdEpubFdXZW1ZdEpqYmlFdjhmd2t0R2Nq?=
 =?utf-8?B?MS96ZUE3TGcwc2JVUTdEY1VTUU9iek1vQzMyRFJGRGtnRFFmQlhQYUR1SFZ6?=
 =?utf-8?B?SGNmTkNDZCtoN1U5VmcwSHJKSEtLbDFwZDVVN0tCMmNwQWk3NGFiNEdML3Zh?=
 =?utf-8?B?dWtFKzc1aGRVMUtaT1oxSXVOREhnNzlsY2k2ZU9NSWpmcG43QjlMeWFGVmJQ?=
 =?utf-8?B?K1BETHRDdzJnelhTdHlvcEc4cVlxYWhwRHgwMFo0eXVMV2xObHRXb3p6NGJk?=
 =?utf-8?B?MjRuaDZWMUoxbDBwcDMzbU1sek14UmJOZzZoOGs1S28xcGRMODhtTzVnMkdC?=
 =?utf-8?B?azd4U0lHWmxHSFZzNVdqZE14N0NxcWFBcHlrWnhDWGxMZThaeDluRjA4Q3pM?=
 =?utf-8?B?MGsyUUZCT29oTzFzWG8ydlVueno5SUNmd01mbDZUZlFYZlhyOTJWeUk0cCt0?=
 =?utf-8?B?VzZYSHlZcnVKSnNLRkNENmRhdkJKUnZmeXM1SHRTc01JTVRYK3ZVeXVlcG1n?=
 =?utf-8?B?L3dlL1dPQ05ESXlIY1luY1ZCNlZvc2FlL081YnpLKzg5MitCMWpjMHBJU2Rq?=
 =?utf-8?B?K2w1TDZYRTVRWXk5SmkyQ0tTV2lYQlFiUEF1ZHNGSnc5eUpYZnpib2x0c2lU?=
 =?utf-8?B?M29QeEo2SlJ6aU1hUGZFVmpjeFNkempQTWtHRkxYQWc1MHpQdVNqWWoyK1hu?=
 =?utf-8?B?WU9tMDI0bVZwUXkyMUJ5U0hsVi9MS2JUclBHaERxTzRwZmZMUWkrTWVHSDJO?=
 =?utf-8?B?b2FFQ1VBYkFqd0c5S1RYanF5cDBsZmRKV3JSd0dXRVRjcFJ4WDBYUWsvK2Ey?=
 =?utf-8?B?cE1XVjZRd0FjR0RUVFBjNkQyREhHZWFucHhiNms2NzBkeUFXSEhNbE01aTN1?=
 =?utf-8?B?UEJSaXJLNmV3V3RNNWRKbUllWmRXakFTWFBjMWlDYlBOMkY2Y0g2NjA0ZWFK?=
 =?utf-8?B?ckp0ckpMTCtvVXFHTndZd2FUL0R3SVFHL3hjR3cvWDIwdUd4cE5GMXVOb2Vs?=
 =?utf-8?B?WjkzSHJzdWN3U0ZLNG1lQy92dldTTFE5SjhZRU5UM1VhWlZRZ1V5Y3VXU0Zp?=
 =?utf-8?B?ZzBmbk8xT0M3MkZQZHBRdkM2Q3p5SGNKR2dHeDIyTlJFTFNza25FTUUybVpt?=
 =?utf-8?B?WnU3MDhkc2FhbEFKd20yOGRxTThJVU8wYzNXYjRiV0ZYL1VyWG5yOUlSbTR6?=
 =?utf-8?B?OVAzMDR0V3h5djdTMXI0NWVWVG9lK3hRTzFsSTF1anU0RjY4M3BxcTRuZGdm?=
 =?utf-8?B?Y2lpTFI0NmZ5Z0l3cW5sV3lvWjYxUVpxUVNsR25XQk9hbEZLTkV1emVDWWJz?=
 =?utf-8?B?Q2YwTHc2UG1TRjlXSUNDVVgvUlV4T1p3R3lhcmlmbHBZK1lsRE9ld3BYaFZH?=
 =?utf-8?B?WU43Ky9jQzBLbnc4U1FhdEM1NFA2VGx0L1MxR2pWOWFUdFRUVGhMU0VEdTln?=
 =?utf-8?Q?YHqp5J+OWBGGw0vA=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b95416c-b6e1-41a7-3ed5-08da29ff0e56
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2022 16:41:06.2934
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 76E7SW4OX66fijYB/AxdksiYzSFt6Za4FF0TkT0JpHmq/BewfRuKM+khCY6mOE3k9pC5p5IbRQPDw/RPy34DTmeCFTzY5DxUvv25U3FxYKI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3984
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-29_06:2022-04-28,2022-04-29 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=511 mlxscore=0
 suspectscore=0 malwarescore=0 spamscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204290086
X-Proofpoint-GUID: rliTzqwqIU92rI1M7HxbKQeUqQHzXLJW
X-Proofpoint-ORIG-GUID: rliTzqwqIU92rI1M7HxbKQeUqQHzXLJW
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/29/22 17:11, Jason Gunthorpe wrote:
> On Fri, Apr 29, 2022 at 03:45:23PM +0100, Joao Martins wrote:
>> On 4/29/22 13:23, Jason Gunthorpe wrote:
>>> On Fri, Apr 29, 2022 at 01:06:06PM +0100, Joao Martins wrote:
>>>
>>>>> TBH I'd be inclined to just enable DBM unconditionally in 
>>>>> arm_smmu_domain_finalise() if the SMMU supports it. Trying to toggle it 
>>>>> dynamically (especially on a live domain) seems more trouble that it's 
>>>>> worth.
>>>>
>>>> Hmmm, but then it would strip userland/VMM from any sort of control (contrary
>>>> to what we can do on the CPU/KVM side). e.g. the first time you do
>>>> GET_DIRTY_IOVA it would return all dirtied IOVAs since the beginning
>>>> of guest time, as opposed to those only after you enabled dirty-tracking.
>>>
>>> It just means that on SMMU the start tracking op clears all the dirty
>>> bits.
>>>
>> Hmm, OK. But aren't really picking a poison here? On ARM it's the difference
>> from switching the setting the DBM bit and put the IOPTE as writeable-clean (which
>> is clearing another bit) versus read-and-clear-when-dirty-track-start which means
>> we need to re-walk the pagetables to clear one bit.
> 
> Yes, I don't think a iopte walk is avoidable?
> 
Correct -- exactly why I am still more learning towards enable DBM bit only at start
versus enabling DBM at domain-creation while clearing dirty at start.

>> It's walking over ranges regardless.
> 
> Also, keep in mind start should always come up in a 0 dirties state on
> all platforms. So all implementations need to do something to wipe the
> dirty state, either explicitly during start or restoring all clean
> during stop.
> 
> A common use model might be to just destroy the iommu_domain without
> doing stop so prefering the clearing io page table at stop might be a
> better overall design.

If we want to ensure that the IOPTE dirty state is immutable before start
and after stop maybe this behaviour could be a new flag in the set-dirty-tracking
(or be implicit as you suggest).  but ... hmm, at the same time, I wonder if
it's better to let userspace fetch the dirties that were there /right after stopping/
(via GET_DIRTY_IOVA) rather than just discarding them implicitly at SET_DIRTY_TRACKING(0|1).
