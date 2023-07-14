Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52E45753B77
	for <lists+kvm@lfdr.de>; Fri, 14 Jul 2023 15:06:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235252AbjGNNGM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jul 2023 09:06:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231362AbjGNNGL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jul 2023 09:06:11 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD08730CA;
        Fri, 14 Jul 2023 06:06:09 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36ECwupe004785;
        Fri, 14 Jul 2023 13:05:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=A1ay7Piws9ZMbO7U6oOQ44F1An/UsNr5LHosM87Fibw=;
 b=fnANVVQl6uWYMHpZMvlBxIhWRDBb9ZbE4HNKxYyGa1j8RpnD+CftNF7DI0tnkz3RRGri
 3bN//pfcktLVktUjJa8WyIO7ZcO7UbVcqhEVjjpHykrYeYl53qWlYiAAN7Oub5rBaLzL
 2ArRCPZ/wn1jLG+seaAW3gWqbSRTvxeJQDnKrpLqF6spsDg14gGBUYHPkidfKhiUkB5t
 UlMoRaNigmKFXKu0zq/8OdtK0ZL89S1YiQCSFFZfD5hPE/emz2cVjwpinJqiLqY/pLJz
 +FY9kW0tLJ+gDn6MnSbdjiA3sdZ38tQUCNF5jV9OljW0iywdvPHjARL3qXbt2aCv5d2S 7w== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rtpth1fh8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jul 2023 13:05:37 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36ECXsOe039252;
        Fri, 14 Jul 2023 13:05:37 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2106.outbound.protection.outlook.com [104.47.58.106])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3rtpvxv6a4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jul 2023 13:05:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dCwaBtr44JyIwtU4Mymbg1jDYuDSntt+tuZLWkz9ZQuJaJ1RheSOEU2o5CAiRl9RY1Fb5iuH7llLVvp/pzTJJBqzIf37S6JoH9b+Rp/ok2KlV7OAMKGfWAxZWO9Inutk1z6kDX5ereSNZkc0i9xe5X4YYMWV5nrb/CTo2qzyXHxKygjLpWZ4g2RzzqQisN5Bp2FjkJ37uG4pz48se8AK8QcffVqAWdTrFbRhmr5HhKOT01SQ+4j52Qr9mcclpy22IQJxcw/aCuMQV+gXt1+6nNpU0isB6gD2K4HL9q4G6RsSBAw+dTvr9FqT+J4+MX7cmhfIqQpKXVMm0qE7NVKW7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A1ay7Piws9ZMbO7U6oOQ44F1An/UsNr5LHosM87Fibw=;
 b=H3SJKHHNZQ2mbapLf5FvmBu3bgc/rRA4yQ6ouTt5ni1cIN5/MQcJovXiVg2fpu9jJLqVAjnmhiJ4fvBCaJVu1GJ3ubwz7L/N2rYyK6K7eqKkHiqRcigmFyvvFLryp5kSkWaNvBUfmjUfNriPRIovSErah/xn6AiScJ/lTzuA/0IC+04Ppd3B+Rlk/f/AMcFM4YGXSq6SK/GtV9QwE9FMhyCxnhI9RcPxKIq1LX2kw8BySCxm2DoZfjrML+YulX+ym5ZNBt644vjm7l7O+En2Db7o/B+bJ5Zdpc307TKt4vSBR/hbZxeiN67f7i837FCRA5DOsZPGzbLODUiQ0noCUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A1ay7Piws9ZMbO7U6oOQ44F1An/UsNr5LHosM87Fibw=;
 b=E4/tcpVyJKln37IHX5FmelYgM/zutoUevPEtyCQ4TSdOA98f9TC7uH9gNF0T9/tGhPPBDWX7c+7Hri+lGJ8rCBveW2OfozqbLjAbersyUGigEdbp4CSTex/boBkQ0iUNz2ptQjVEP7+iXnE6tDZPkmVpRUeZ3ZoWaPk2bEXJZkg=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by PH7PR10MB6154.namprd10.prod.outlook.com (2603:10b6:510:1f5::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.27; Fri, 14 Jul
 2023 13:05:34 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::6db1:c2a8:9ec4:4bbf]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::6db1:c2a8:9ec4:4bbf%4]) with mapi id 15.20.6588.028; Fri, 14 Jul 2023
 13:05:34 +0000
Message-ID: <bae58fd3-34b0-641a-a18b-010d48c792f0@oracle.com>
Date:   Fri, 14 Jul 2023 14:05:27 +0100
Subject: Re: [PATCH] KVM: SVM: Update destination when updating pi irte
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        "dengqiao.joey" <dengqiao.joey@bytedance.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
References: <3d05fcf1-dad3-826e-03e9-599ced7524b4@oracle.com>
 <20230518035806.938517-1-dengqiao.joey@bytedance.com>
 <2f6210acca81090146bc1decf61996aae2a0bfcf.camel@redhat.com>
 <36295675-2139-266d-4b07-9e029ac88fef@oracle.com>
 <ZJ4HJhQytonABUMl@google.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <ZJ4HJhQytonABUMl@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0561.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:33b::10) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|PH7PR10MB6154:EE_
X-MS-Office365-Filtering-Correlation-Id: 6c5e0770-0bc7-4f6d-0f7e-08db846b02a0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: apdl6lE3I6sG+PUoxPubmxZMZ8zxR+SfNqE9TJmmpJPkRswSgVy7FZ5g6lY4yamOSAGUJMeE8uB2vrfxboZOuPnllX733MTeJD6ILw2E3o7DTTzgws0HCfbsTNIxCv2VPo8JoYVWGoPxQNYV4/TScbJK6+9+8Bi/orYIjbdS9FizHtMiScSP7PHtcLtatvJx/O3nIMhDjXke9yTidZq/jCiLLMK5tMdZvxf7a5OCqicz5mS2pWLdZBLjLRGbO1nTJ/L+nDrNjGLN8+cdlxiqOP3L/WnbSqBFlivEMJu0Skcca6L6jmK5BsL+TxuiEuR4TFavQD+7Pvrj9ivsjdpyy6+JEkjquM5gyBuIIePv+EDLmcqiES4h+jktvsJKEM9DHRrKxd6f9pWDWRV/ttJVP7EcfFKYsAjMfjits2tU47lVhla4yKm9eDIWKRAVux0sIWJ0DSenMc3d6UuyVHjrEq89jbom/DE1QXA8CkERfs7pKsaorTirOt0092T3sO3xMw2k5zJcY4SG0VCsEhsRMcQcmyYSrDsizXQ95PQ37KvR/Y1Ic1/k8zz/Bxfy5ucklE3AuPY9491kHXy96jkdk4UaWyHdUQ9A65RwphcLiskdqFqbTjC2N6hIbHVNusB9
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(396003)(376002)(366004)(136003)(346002)(451199021)(6512007)(6486002)(6666004)(83380400001)(186003)(2616005)(36756003)(38100700002)(31696002)(86362001)(26005)(53546011)(6506007)(66556008)(66476007)(4326008)(66946007)(54906003)(41300700001)(6916009)(15650500001)(5660300002)(31686004)(316002)(8936002)(8676002)(2906002)(478600001)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OUJKMzl1S2ZXUlhBWXpWT0FtWnV6ZkNOb3BIUEVocDdpWGVCR2hpbmUzWXJG?=
 =?utf-8?B?Z2FwQjFYa0xmN2hvckg2c21ieGhuRmhudlRwZEZHb0lvU092RHR1RmZwZS82?=
 =?utf-8?B?dEdLejB0akRSMERxc2V1dXpNanZUakJKNjZXNElMMGpHNFdENnZORjRkSHQw?=
 =?utf-8?B?RkgvWGduczVUWGJNZVkxU1NCeWlNSXYzN2MvS2xYbkUzK2lvdU1Mckx4WG1y?=
 =?utf-8?B?VW94aUtUZlVWQm12ZzFUUVF3b2FkWjBLYitTOGNTRDhFb2d6c1FTMWdPUXFW?=
 =?utf-8?B?YXNHSDg5ZGpZOWZxczYzSzdjZWdFTW90MURZSWw4ZkRQREIwSmdnelZWVkth?=
 =?utf-8?B?RlNnaE9nYStJMmx1dUFyL2k4cXRENFV0emxmNEJNcm9sUW5HbWhEMmNwRVVT?=
 =?utf-8?B?NFl3SnpmQXVCZVAyQzFZTWI0Z3lING4xUis3YitZUVNSQnN0N0xWRTJ0b214?=
 =?utf-8?B?a0Y5UmFNdDZ1OEtWWm1oQ0VjSzFJSlR5c2VENmpwK051cHBqWmNqUjVJVzBk?=
 =?utf-8?B?RUVvd2VEVFRDTHEwZ3pPZWsvQmxaQ0JRUm9LS1RReURvVDFQK3JHTlF2MkZM?=
 =?utf-8?B?R1RDWUlMcUxZUlM4dy9NejJjK0oxWEJRRkdPVjhDLzEvamhCeDhZWDA4R3Mz?=
 =?utf-8?B?Y0lhb2hrdjJlOFlwWGU2MmZjUTJlU3Y5eDFVL2RZa3BIR0NTWjJvcmxXVFp0?=
 =?utf-8?B?aEhDa2JYcDdJeFB5R3YzWEEwTUkveUtjOTczNFpmWmlXSzlaVkcvcGYyRVR3?=
 =?utf-8?B?WXprK0kybjRQcmV6dzkxbGtTWHNlZDRsK0lIb3R0M284SGhzYm1PcnZZd3pS?=
 =?utf-8?B?SDdyVVE5VUtyUnRiL3YxSEJ3d2hya205aDlNUTNuV3AxYmhubm5wZGZwUlR3?=
 =?utf-8?B?RmdDYjlja2g2QUsxeW8xN0RIaEJrdTZzTWREQ3M4SVhWVnBjUUYwRHhwQW02?=
 =?utf-8?B?ZzBxaGNRRklZU3hZMTBNUXJKejN5OCszdFBFeDVWendnSGJkbGZMU2ZpUG9p?=
 =?utf-8?B?clY4RjJDT2pmc2lWK2tsRG84eFJHYWluMnFQOHNiWkNrSUNob0lOVzRFZ3JO?=
 =?utf-8?B?YmtNb0xlaDNwbnJYYU1IL2Jjby80WmpPaE1qbE9wa0FpZjFVdlg0bHFMTHFV?=
 =?utf-8?B?ZzN1OTNBek9YN3NjQVdNNXRSLzByQ3RtSTB5cEVPcnA0Ui96YXJuUGNBZzBp?=
 =?utf-8?B?NmxMVTJndzBRaDRxNjRqbmEyVFZMcjlYRTZhVjR0UWREcFJmTVlYMEhHNVRB?=
 =?utf-8?B?TWpVWVJKV09IbzVRaFVmcXNzaGYybHF0d3g0cytUU09GRVNSTEJ5OC8zcGdL?=
 =?utf-8?B?WDNkSmxyemxKMVprRk04VmZVenZUam4vbEpSY3BDSHhJOG4yZHRhT1dNYXhT?=
 =?utf-8?B?M090RDN4aXJBT1VlYnRGam9NWDFicUw0SENOUWF1dXg1MDZtZDNUSTVySWI4?=
 =?utf-8?B?dG1DT1F4azhJVGlucm1MY1B6cUhWS3ZxbStINUxsRWdrQzBYV21XbVBNbzk1?=
 =?utf-8?B?TzU0c0lRbG16dFl3VnpjYXQwR3lsUlJYd1ZzUVBnak9qVDZybUV5MnJleVps?=
 =?utf-8?B?NXFucm9KZzIxYTVDODJ4U0JPTHhuenFUeHlsNXlqWHRvbUg5VWwyOWJ1QkRs?=
 =?utf-8?B?WUwzVjRITGFRanhDMGxEa2x3a2FyWGFlM29iTE52TE1yN3RpeTQvbCtkdmxo?=
 =?utf-8?B?UmhIVXMvR3dEVXB6NGVnZWV5cENZQlJGZG5zbzMyYXRPdjdsRks5WGJkR21v?=
 =?utf-8?B?a1l0SmdDRHMrMWg1R1pXWUpPNklrbURCb2FQaldjdnlCN2hNdS95SDBhcmd0?=
 =?utf-8?B?cmd4VkVOQW9VSW5YeFRTcXVTWHp0NkpNaENiUFE2cFN4cWltRDdtOSs5U2VQ?=
 =?utf-8?B?QnFpMnBRbjFhVFpRWjVpMkx5M0hEVk9aeGJOdGExMmoyMFkzT0lpQWMyeUZD?=
 =?utf-8?B?TDRBQVFSK3V6UUFKWkF1SWFBMWR5aTZjUXROSjRrYU5Sdi9wcjQ0QS90Rnd3?=
 =?utf-8?B?MEFId05zRjFwWVZlc3ZpSnlSSWhUMXhERFUwZklpbmZnVDhJeGw5cERVM24y?=
 =?utf-8?B?YSt3V2tGMWliWGdvamhDY1VOQ2ZYQmJyU1FXQVpBc0d1ZmVma3pMU0RORHJz?=
 =?utf-8?B?VzI4c0VEeWx4RmN3U1ZpU21RY3UzbnpzYU8wZitrQ2lGM1JkMUlTeENvMXNh?=
 =?utf-8?B?R3c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: Z/oDw1vi2BthZc3cOgIp8h1GPWSHVFD331SQS08i+w6WGOdn1BfxqQNOFVYnccFVGpazjiCzkgoGEyaAl+61bkQFCb36kzwpDP3ofUYjdwv+xXHc8RdugNmgw0Hoz1o9J4KVdyBkr1bDN3EpHWv5suyf9opHpsMCnhMXN+xvQDNTKmuy3dW0oExJCJrtrlIdg0BRZLK3/FUsJO/hYbgZoD6GPY4mf12OPOtjQT+KNU1iGqDQxjzVjFJ5DeiK/02kQbcZm+bEKjuKclunhi1k9GokLD4dK+HPQbHYNuhpEH/JNY/lZg6JZNiJmvWGUA9VDWwJQuTFAbg+DFDsZ0dHqviZVlQ+ZxVd59ZK/yLK73dxR0fBByS6rAZgg5AaIrukStX56cbJG4/NEdT88n15mvJKlGqpmMpJ9VAwNvaE6v4yQElxJOY2x3mT+US4o7ejGz2TYioGpnOxpOA6X4EbDrRdqQmbiWfVH1huXWqITHqO+UNvv4a7twzFihgKl3nJinRBXCNmmMSuj29KlRv8aqmL+0vZ8QYooP+/dBDE8BPA8G/aIbBWx88ppM0DMCHTurV8I9MGMt6sbsDlRgBi4ZfQ2VHGU58B5wlVPxGL0pnB5BW9BCCCCoFZDrYxfIf16Y8mrn9SEZqRacePfQe3B/8iK7tJzQJqHwhrkgTbSOe+d92+Q+waGn/KsVXbxcWEe4AYbh4x0hbOCyM8RBgBALX5QCEltplKpGu96RB2qqGwCFLk54dYvJfmpDXRmfENPJDWbryG7GuaftrNFWEkXaGB6GgtkGX2QzDX8gRsLgxyWPKMnT9ROeot6a9vVGH03eajr/gaU2uBVeeEp3rv+iKp3cXGHKyaCzpRHgj0cy9JI79QgFD5a0vIvU4J2cJh
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c5e0770-0bc7-4f6d-0f7e-08db846b02a0
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2023 13:05:34.5529
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qkwqJdA8UFumnmtF/zvKA/4gQR0tJNhR2aolYGAWYTgNS/cRCTNSwCHn7S07bh+8XpUgFbGBZdNgEPX+i+5z9Ke/N+vaMBeHk3n+SNKoz3E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6154
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-14_06,2023-07-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 suspectscore=0
 mlxscore=0 spamscore=0 malwarescore=0 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307140118
X-Proofpoint-GUID: JvmuxwE0jRlfNpeigKNq0xmJpJ6Xhc7k
X-Proofpoint-ORIG-GUID: JvmuxwE0jRlfNpeigKNq0xmJpJ6Xhc7k
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

+Suravee, +Alejandro

On 29/06/2023 23:35, Sean Christopherson wrote:
> On Thu, May 18, 2023, Joao Martins wrote:
>> On 18/05/2023 09:19, Maxim Levitsky wrote:
>>> I think that we do need to a flag indicating if the vCPU is currently
>>> running and if yes, then use svm->vcpu.cpu (or put -1 to it when it not
>>> running or something) (currently the vcpu->cpu remains set when vCPU is
>>> put)
>>>
>>> In other words if a vCPU is running, then avic_pi_update_irte should put
>>> correct pCPU number, and if it raced with vCPU put/load, then later should
>>> win and put the correct value.  This can be done either with a lock or
>>> barriers.
>>>
>> If this could be done, it could remove cost from other places and avoid this
>> little dance of the galog (and avoid its usage as it's not the greatest design
>> aspect of the IOMMU). We anyways already need to do IRT flushes in all these
>> things with regards to updating any piece of the IRTE, but we need some care
>> there two to avoid invalidating too much (which is just as expensive and per-VCPU).
> 
> ...
> 
>> But still quite expensive (as many IPIs as vCPUs updated), but it works as
>> intended and guest will immediately see the right vcpu affinity. But I honestly
>> prefer going towards your suggestion (via vcpu.pcpu) if we can have some
>> insurance that vcpu.cpu is safe to use in pi_update_irte if protected against
>> preemption/blocking of the VCPU.
> 
> I think we have all the necessary info, and even a handy dandy spinlock to ensure
> ordering.  Disclaimers: compile tested only, I know almost nothing about the IOMMU
> side of things, and I don't know if I understood the needs for the !IsRunning cases.
> 
I was avoiding grabbing that lock, but now that I think about it it shouldn't do
much harm.

My only concern has mostly been whether we mark the IRQ isRunning=1 on a vcpu
that is about to block as then the doorbell rang by the IOMMU won't do anything
to the guest. But IIUC the physical ID cache read-once should cover that

> Disclaimers aside, this should point the IOMMU at the right pCPU when the target
> vCPU changes and the new vCPU is actively running.
> 
Yeap, it should. I am gonna see if we can test this next week (even if not me,
but someone from my team)

> ---
>  arch/x86/kvm/svm/avic.c | 44 +++++++++++++++++++++++++++++++++--------
>  1 file changed, 36 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index cfc8ab773025..703ad9af73eb 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -791,6 +791,7 @@ static int svm_ir_list_add(struct vcpu_svm *svm, struct amd_iommu_pi_data *pi)
>  	int ret = 0;
>  	unsigned long flags;
>  	struct amd_svm_iommu_ir *ir;
> +	u64 entry;
>  
>  	/**
>  	 * In some cases, the existing irte is updated and re-set,
> @@ -824,6 +825,18 @@ static int svm_ir_list_add(struct vcpu_svm *svm, struct amd_iommu_pi_data *pi)
>  	ir->data = pi->ir_data;
>  
>  	spin_lock_irqsave(&svm->ir_list_lock, flags);
> +
> +	/*
> +	 * Update the target pCPU for IOMMU doorbells if the vCPU is running.
> +	 * If the vCPU is NOT running, i.e. is blocking or scheduled out, KVM
> +	 * will update the pCPU info when the vCPU awkened and/or scheduled in.
> +	 * See also avic_vcpu_load().
> +	 */
> +	entry = READ_ONCE(*(svm->avic_physical_id_cache));
> +	if (entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK)
> +		amd_iommu_update_ga(entry & AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK,
> +				    true, pi->ir_data);
> +

Ah! Totally forgot about the ID cache from AVIC. And it's already paired with
barriers Maxim was alluding to. Much better than trying to get a safe read of
vcpu::cpu.

>  	list_add(&ir->node, &svm->ir_list);
>  	spin_unlock_irqrestore(&svm->ir_list_lock, flags);
>  out:
> @@ -986,10 +999,11 @@ static inline int
>  avic_update_iommu_vcpu_affinity(struct kvm_vcpu *vcpu, int cpu, bool r)
>  {
>  	int ret = 0;
> -	unsigned long flags;
>  	struct amd_svm_iommu_ir *ir;
>  	struct vcpu_svm *svm = to_svm(vcpu);
>  
> +	lockdep_assert_held(&svm->ir_list_lock);
> +
>  	if (!kvm_arch_has_assigned_device(vcpu->kvm))
>  		return 0;
>  
> @@ -997,19 +1011,15 @@ avic_update_iommu_vcpu_affinity(struct kvm_vcpu *vcpu, int cpu, bool r)
>  	 * Here, we go through the per-vcpu ir_list to update all existing
>  	 * interrupt remapping table entry targeting this vcpu.
>  	 */
> -	spin_lock_irqsave(&svm->ir_list_lock, flags);
> -
>  	if (list_empty(&svm->ir_list))
> -		goto out;
> +		return 0;
>  
>  	list_for_each_entry(ir, &svm->ir_list, node) {
>  		ret = amd_iommu_update_ga(cpu, r, ir->data);
>  		if (ret)
> -			break;
> +			return ret;
>  	}
> -out:
> -	spin_unlock_irqrestore(&svm->ir_list_lock, flags);
> -	return ret;
> +	return 0;
>  }
>  
>  void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
> @@ -1017,6 +1027,7 @@ void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>  	u64 entry;
>  	int h_physical_id = kvm_cpu_get_apicid(cpu);
>  	struct vcpu_svm *svm = to_svm(vcpu);
> +	unsigned long flags;
>  
>  	lockdep_assert_preemption_disabled();
>  
> @@ -1033,6 +1044,15 @@ void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>  	if (kvm_vcpu_is_blocking(vcpu))
>  		return;
>  
> +	/*
> +	 * Grab the per-vCPU interrupt remapping lock even if the VM doesn't
> +	 * _currently_ have assigned devices, as that can change.  Holding
> +	 * ir_list_lock ensures that either svm_ir_list_add() will consume
> +	 * up-to-date entry information, or that this task will wait until
> +	 * svm_ir_list_add() completes to set the new target pCPU.
> +	 */
> +	spin_lock_irqsave(&svm->ir_list_lock, flags);
> +
>  	entry = READ_ONCE(*(svm->avic_physical_id_cache));
>  	WARN_ON_ONCE(entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK);
>  
> @@ -1042,12 +1062,15 @@ void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>  
>  	WRITE_ONCE(*(svm->avic_physical_id_cache), entry);
>  	avic_update_iommu_vcpu_affinity(vcpu, h_physical_id, true);
> +
> +	spin_unlock_irqrestore(&svm->ir_list_lock, flags);
>  }
>  
>  void avic_vcpu_put(struct kvm_vcpu *vcpu)
>  {
>  	u64 entry;
>  	struct vcpu_svm *svm = to_svm(vcpu);
> +	unsigned long flags;
>  
>  	lockdep_assert_preemption_disabled();
>  
> @@ -1057,10 +1080,15 @@ void avic_vcpu_put(struct kvm_vcpu *vcpu)
>  	if (!(entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK))
>  		return;
>  
> +	spin_lock_irqsave(&svm->ir_list_lock, flags);
> +
>  	avic_update_iommu_vcpu_affinity(vcpu, -1, 0);
>  
>  	entry &= ~AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK;
>  	WRITE_ONCE(*(svm->avic_physical_id_cache), entry);
> +
> +	spin_unlock_irqrestore(&svm->ir_list_lock, flags);
> +
>  }

Other than that, looks to be good. To some extent we are doing an update_ga()
just like Dengqiao was doing, but with the right protection both from IR
perspective and safe read of the VCPU cpu.
