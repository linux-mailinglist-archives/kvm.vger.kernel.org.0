Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B06E27CC91D
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 18:52:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232644AbjJQQwZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Oct 2023 12:52:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230343AbjJQQwX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Oct 2023 12:52:23 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFE81B0
        for <kvm@vger.kernel.org>; Tue, 17 Oct 2023 09:52:21 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39HGDkM1024769;
        Tue, 17 Oct 2023 16:51:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=pQF1gwmK+my7q57RoLocLrWCVRLiXLRLmVCSlVhWkDk=;
 b=F5voDssDWhXoJCZkj/H778O9zxe3ZT6dkhk/C/dy6aGULnKQGbUzmaR1I3cyLIBy5Mmt
 iMTIrae8arCBQnuOCfZ8rXlC0QaZ8NQUvTfr/sBsUS6ZEwud2r8h2tv958qWpzqHe3kh
 uFWOGoEv588NWoadhjj/G0JssywN9f3IEvm/yYAE3iuu1+mvU+/d8NRmhwamrEGved0B
 QiMBsYWBlsiOTGdxZOfoh4udXT7etZK79ynIf9//hK3h4sShRAtq4KQVnpbXWsBKUwPD
 OVhudaaZZEpLVtRS+ZKHETOrA5IGOywgYOyegMyGus1nT+VI9ADl22L0+REYcxy2MXoF 9w== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tqjyndp8a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Oct 2023 16:51:59 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39HGUZgn015439;
        Tue, 17 Oct 2023 16:51:58 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2041.outbound.protection.outlook.com [104.47.56.41])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3trg1farju-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Oct 2023 16:51:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UFeYucYEa1xK8RQQddDWTcVd+rm/cvA0XUc1jZzw4oKKgEGrSS3qJaCFwqtG14w2pKv0aj0oVdvn7vuG5U20/pvl9SoI2UNUV0ALoi8x0wQMiHo4B4aCE/PijrJlWiDZonkOySLqTs1IYMO9VRyEgZ0VPE7zkcf7kJVXtyK8XQq9LU1PknMXUlNvcRLTqpB5+0nH95NqXsaIU3SZomklcP+FsFYldWlQzIorcepw7hhdn+d+ZWR9XN1j2TbJImiVIet6QRYTXc8n+mE4PE+Co9LzeUjFMCXKDqtBAOZI3QSsRQD33l2udvwsWXb9x+tWr1AECVnh1xCjEGel+MSpRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pQF1gwmK+my7q57RoLocLrWCVRLiXLRLmVCSlVhWkDk=;
 b=Qu0WKOsfJbx2GvPsi+qRcC1j8hkxYpTMqIS+ZsBwS6YHsMo0drInYFCmhamsqlDvscAwjTGloxKV3SFnTBrKA0Lok/5VWkZzpiT3JWrADgX81RTSba5hXYvXms86cxtexPZaoxGPF/JFxIpBPkqVc6oQm+E8YRadzs4d34V4vIbFV9jlEtVdOciHpna1RbomW/SqYR7cNxp3+If0M5obvAM7c+2rD6/6CpCQyc9siaNmXCIMGKCahkaq07vrjbdESi1PeFtESP72U+F8eCbuEc1RHLEylI6S7Ry3QZ8eQqysqyitcm1GmgVOjOmfvxnvFdr5Kch/+icn/UiUCCw7aA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pQF1gwmK+my7q57RoLocLrWCVRLiXLRLmVCSlVhWkDk=;
 b=JgJ7dZNECCmO52tJ9atcsvGUnN9w2nw3uY4Sjx5C2EPNCMWQZ4Kruj8diU20gDUSVNV+DxOCnqaJ3vRifBwI3octxxhL5LgLHcEtqQTLo8WvD2hjC0zFTOKuqU5djgawut0YDo8hWrY+xLW/ZH/fUIUdpSU0a2MCNWqUPNtvXWY=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by CH3PR10MB7281.namprd10.prod.outlook.com (2603:10b6:610:12e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.36; Tue, 17 Oct
 2023 16:51:56 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d%5]) with mapi id 15.20.6886.038; Tue, 17 Oct 2023
 16:51:56 +0000
Message-ID: <765e01f2-c0c5-4d6b-885a-e368e415f8f2@oracle.com>
Date:   Tue, 17 Oct 2023 17:51:49 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 07/19] iommufd: Dirty tracking data support
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     iommu@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
References: <20230923012511.10379-1-joao.m.martins@oracle.com>
 <20230923012511.10379-8-joao.m.martins@oracle.com>
 <f7487df9-4e5e-4063-a9e4-7139de63718e@oracle.com>
 <8688b543-6214-4c55-a0c6-6ecab06179c6@oracle.com>
 <20231017152924.GD3952@nvidia.com>
 <df105d06-e21b-4472-ba1e-49e79f2c0fd4@oracle.com>
 <20231017160151.GI3952@nvidia.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <20231017160151.GI3952@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO0P123CA0006.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:354::8) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|CH3PR10MB7281:EE_
X-MS-Office365-Filtering-Correlation-Id: 009db169-c47d-4ec2-b063-08dbcf315f1f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +PFzB7znfC9wDt0+vkG7/b99aTE40mAxSYGUFpb9ORXFBx16u5czldlh5G4EOsAN1mPFm3MsmLoD8hVHbZzwkM8b5O8EwhSLnX0UGtwExkSOqCufMfp1NXKRZUPsFvT8HrL0zUGbGANZ4sUhcsKKDhOLfmfVws0aSAlLgZKEI98m0fVzrkpBt8vKFjegAPSfIPDEuju+0ZkO2ucQzBP0bAGtlSsTNTr6l8LGRFj7vmnlKCwohKkaxwxxNSyV3QZ1sIptkFM8wzSYmKD03vaFoKoHLj8YBhFd0KmK97wzOUpPKrg6BAnbDUOlfaTy63lwrMpp0KzMULuTgzr/y3Y3IMCno/NMWiBTJrqO5WLgn2n6jkkYoNJSdYEE45/BoXg1A6s3cclyfhEc0ZCDTT/au6Nur1X8gxibt8l41husMmZU+jVVdO6m9OpXpAsZxa5a/Uid8/ewoL2+ry43WhFKvih1MDLki79KsicNqU4BvpINu4/YRgYntJ/zYvuB59v6Ib0FbnApu6uIHu5NYH8qHvtXvHOcv7IotHhswgoDEMclPwZ5grdMLWYh+Lgcl9fwi0CdoRFgRM7dwkaKEdr2Na5m6AsLwez21ESHw21JsFm9c5f0cJeDwEZ3ZB+3Rr4YsypWcBQaE34kqOuQCV5NV1/0kDtn3IK84mczt9LPajo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(39860400002)(376002)(136003)(366004)(396003)(230922051799003)(64100799003)(1800799009)(451199024)(186009)(4326008)(2616005)(66476007)(66556008)(6916009)(54906003)(66946007)(26005)(316002)(6486002)(6666004)(478600001)(6506007)(6512007)(53546011)(5660300002)(41300700001)(86362001)(7416002)(31696002)(2906002)(83380400001)(8676002)(8936002)(38100700002)(36756003)(31686004)(14143004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MjFwYm9CVkplamdJNTRmdWhab1QzQ3BnaTRKbEIyb0pFQ05PbzJMVEc1b21U?=
 =?utf-8?B?ZHUwcG9FOTNoZURFK0RRWkxJT3J0SUM1KzN0R04zcXFtZzJsWEFuSzdkNlpj?=
 =?utf-8?B?WnhacnRneWVPcU1NQ3NxdkU5MU50ZG1uZ2NVZmd6Sm5Bd1ljU0htOXhxWE5B?=
 =?utf-8?B?UThQeE42d2hoNXI5TlZvOVJNZTBUa0EzOEZDSHBIeHptSVh1WU1POWJmTnNy?=
 =?utf-8?B?U0ZvQjRRWm1kaTYxei94RkVFYmhmcEdMd1h4VXRvL2xLUmxaVmY0TFo4aGNp?=
 =?utf-8?B?bHo5Sld4ZmxWYzdIQU1TSmJLZnZ6Y3g4TDVkdzhnUjNtZlRTL0YrVGFwajg0?=
 =?utf-8?B?NUxxc3Rod0c3MVFuWStKOVA0bzZRM1lSaHRxYXpaR1lmZnRGRXkyMC9CcnEw?=
 =?utf-8?B?enpScjMxbVNjbjc0SXFDaG95cjhPSjFQNzg2OFZZNmJ6UTI5dG0zb3paWFlO?=
 =?utf-8?B?c1loZWl0bDMzRStISHl0bDhIRkJzdVd1L0VDNFZ5SXJiRHJGdXpuS0NDZ3VM?=
 =?utf-8?B?YUkvYWJvdGtQUlp5ZGk0UG9nUDdXQXluTVFBUm42RFVIb0Vpb1cxSFM4MnJu?=
 =?utf-8?B?OUxBSlJTSkJuZUJLM1lqRmZKSXlPck1Yb1d2YjNVczZzUkYrS3hmdTBHd0w2?=
 =?utf-8?B?bVNIMWNTKzZtZWdlWkkwTHBsZ3liUzdOc2VrL2habDc2SUhCdFVDdXpwQitW?=
 =?utf-8?B?Zk5WeUVGaDF4UktKdVNOaDlwbE43TktyTmVyMUZzUkR4WWFxTVlhMWFnUkcz?=
 =?utf-8?B?Ui9jRzFxNWt6WVk3L2d0UlJub0NSQjlHdnZLMEpaZTd4U2xrb01LYW9leExS?=
 =?utf-8?B?Q05JOWxVMmRReSsxWVhpTTJOck5NQURReXlPU3E1SlhSU2hzRUIyVHh3U0NZ?=
 =?utf-8?B?T0VjNUJNNEtOV1hEWS8wUVN3UkdnZmgyS1kwS0dIRG5lcmJ6TkRNYUh1UXJs?=
 =?utf-8?B?Y3RqNllEOCtwZnlqOWo3QWR3OUpwTk9pbFJoSWN6NjJrKzFxNjF0bndkUnRw?=
 =?utf-8?B?SWlrUVpQZXZZSVNYeHYzb0s1aEM1Z2c2QkN2c0FLWksvZWo5LzhreDdrVVZn?=
 =?utf-8?B?a3Z1NFBxUlRTRHlXZUZlRnI4Z2M2SlpVcHEwQ1M2d0NXaHlEaERpRnVGUG0x?=
 =?utf-8?B?UUZMS2lzT1Nma2hWeTVmM0RibHNmY1lHNG45bmhSbFpVZkN5K2xqeFhFam15?=
 =?utf-8?B?dUt2bGJUa2J3Z1NFYkI3dWhoVWJWZUd3akhwTFdFMVpZT2MvaXdXRjhSOXpO?=
 =?utf-8?B?cFNFQU1qVk1GYnFwa2laVWZFUHYxQTJ3QkhDK3RlTFYwSUNtSWVteW5sMzNM?=
 =?utf-8?B?aDZISm40WUNJMS9VdHptVDk3M2lqTU82eGFndE55cWZnK3JZZUtVVzBMaU5Z?=
 =?utf-8?B?UU5IbU4wWk95WDJSMzM4RlVCeEZiWHRibnhlMjdSSUcxYWRoaTVyMnZJd2ox?=
 =?utf-8?B?TFpnc0pSUlRXWmFYbkJJYkJxanlqb0FoL2s3RjhDcWFUZFF4VGJsQzlIL0Ry?=
 =?utf-8?B?ek9qMEpUS1ZNdjdvZEpvWEF2c2ovQTBGM1RPQkp3V3hIMlFrUVdITXpENTNo?=
 =?utf-8?B?V1hpd1c0OWM4VEY3cTQrZXN5VDAyTkQxV1NETzRGZGI4a0czMGFsVEt2YXVw?=
 =?utf-8?B?dkg4SmgxbkpjSVpCNlB5MVlyVFRsWXJwV0U5SFZOL013U3VpTk1lTU4rOHJy?=
 =?utf-8?B?anZ4Y0FySm9TOFI2ei92OXBpZVREbytwWW4zUXBScTZrM1BjdnRXUEFZVHZM?=
 =?utf-8?B?WkRmcm42cVZBQ3pTVzRlMzZUcWR0cEhEbEl3d3NGeFY0b3k5MzNhUHIva25n?=
 =?utf-8?B?a0JLR2o2eHQzeENGdXJRRlFkeVZORTBNNUFHV28ra1BZTDgxUms5R1I4QnhE?=
 =?utf-8?B?YmNWUlJraUNPZEpmZ3lqcXZIalg1RWNKS0VEM3pNWmNGZnBJcEZtZEE0SVVD?=
 =?utf-8?B?NmZQUEpvMVJTY1h2VStWK3NGSzFxSlZtVVU5cERxN04zSlo3cm5hSHplVFRI?=
 =?utf-8?B?RlIzRERCUTFLd1V4cVVrTWZKOUVTZ0srWVYyMDBPVUY1WGlzUXM4eHk2VGpT?=
 =?utf-8?B?dVVmdkhyNVhTRGtCT0xXNHNPbFBPd3dLQm5ZRmlTclIyT0JVb1I4MWNGSTBR?=
 =?utf-8?B?b0dzTGhnTTBTRkNpMzVHcWlWQW5WeUJkUWxER09nd2lRV3EwbkNUWjJEcDBt?=
 =?utf-8?B?bmc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?d2NmN1M0ZnF3UGhQVHFrOC9xMW1KUmIzTWdQUTdZOTZWd3o2UzNUYm9IaFdw?=
 =?utf-8?B?cEZRYVdyb2NBTkZkMitRTE9McTBsNVFZTXo4VUFUcEVlY0czNGZ1aFd1UEdt?=
 =?utf-8?B?T3dFQ0pIUFJnTHFDYThGV0tETzlncHE3QnNmUFlOU3lmdVFQZ21tWDdxdmhq?=
 =?utf-8?B?VGh0WDdKYTVOYVBrSExPa3N0ZHZheTh5bkFXUDZ1TXhwOEI1ZkRnS2RNSitO?=
 =?utf-8?B?aldMdEJlT3g3UnZ2OXdaQVhsZ3k3NjRyYjdyZHI3T1RHMFo5bVBZMEdrSmtN?=
 =?utf-8?B?NHpadGVLN3pmVE9EWDBvS05TUUgzWlU3TndnK3VBZmpKUkxDaVFBZVp5Qlha?=
 =?utf-8?B?NFBIcmNtWWVjc1hvdE01U0QrejNMRkRPMWpKZmIrUEVVYmVGOXU2dFY3dHl4?=
 =?utf-8?B?VDhlclJKOWNoaU93UTE1YUhHaW9zenZTNmd0S3Y1ckNSWU5mNUMveHY3WWdh?=
 =?utf-8?B?WGk0ZjRIRGwwMVBCSThiUlJvZU1KUmNSL0VoTVBidDR3NFhvOTdZYzh6SmRh?=
 =?utf-8?B?ZEVCb29rQXdVQkFhckNsSVl1N3k5TWhrR0lOVFZFVDlIWTZENTMzS0JaZ0Rx?=
 =?utf-8?B?MWlNc3JudnpXeGlIelFobkh5SnhaYkt0OXdQOExycnRUOFdrUXlaRmhuK3RO?=
 =?utf-8?B?T2J0VTNsOEY1ZWR3VVhJV282c29MSTVlREhTRnZjUVdNNHdtTkJhNlQxVm42?=
 =?utf-8?B?VXNlNTFUaTQ2dlNvOXo3aFhlSEZtc2hSNlVuTWlReE4ySkgrWEprTDNNdTJW?=
 =?utf-8?B?M1k2S29EZDNxamhHSW5iWGZBTTZHVzUwOGFnR1lmRFE5bk8wWjdvbElEYXdN?=
 =?utf-8?B?S0U3ZFpKNEY3Qno2VmRaZjRuMnZaRGlPWWx3MW93UjVOeU9YQ0R2VE4vTlVy?=
 =?utf-8?B?dEU1bml6UDR6dXB0bzVpdWlJY2RFTVFpNytpNUJmR1pIMGNaNVkwRDFJYksz?=
 =?utf-8?B?Mk9nRWw0clpPS0wraFVMbm5tQ0NYL25CU3FUeXVieXJxb1E0WHQzaElpVG5x?=
 =?utf-8?B?RGdibXZoU0JPVHdXZStHQTYvZWZmRXllTmdhWmdsTk83ODI2UmJUclpTaHdh?=
 =?utf-8?B?dzc2WG5KcnpLbWJ4Y3NQMEFOMDdtV1VYVXZwU3pDeXg2NHU0MTNTQytwMm8x?=
 =?utf-8?B?RGxDUlBhaXhCekhaaGcyL2tWOHlFSnhoMHNBenVURHJYY2F1OGw0dTRLcW1p?=
 =?utf-8?B?VmRNTDBVemJLMzY4U01YWWxHREJKbXVjVGlrR2V2WmxNYTZ6SDZ1dllmTWli?=
 =?utf-8?B?Z243UG9QUWFsYlJFcU1VdGRGM3ZKcTZpL0hsd0hlR244TTR0YVFjczIrMzhO?=
 =?utf-8?B?QVVZaGZRV3dHbnQ0dlcvNkZVMDd6TSs1RXVwRlFSZlJnbzF2am56NzNJWmhq?=
 =?utf-8?B?SFVDdjgvbVlJK2F2ZkV2UEJaZklPcHZMRk9Rb1JrTHllMVBTYTRDM0pLNFAv?=
 =?utf-8?Q?zdzVuCH2?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 009db169-c47d-4ec2-b063-08dbcf315f1f
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2023 16:51:56.2293
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WYRbJbliZpf2XpFoy9oHUpYf5PH8Xxt0fofqr2f7/YqIUT2itksgoAepHZHSKXrHkmSrhnGatHGdM7uQyCuhWxUHJjG4HNqLRqY8yBJRp1Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7281
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-17_03,2023-10-17_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 suspectscore=0
 mlxscore=0 mlxlogscore=951 bulkscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310170142
X-Proofpoint-GUID: 4GedgaXMNQubVBIl-rAewJgCdoQdU8CV
X-Proofpoint-ORIG-GUID: 4GedgaXMNQubVBIl-rAewJgCdoQdU8CV
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/10/2023 17:01, Jason Gunthorpe wrote:
> On Tue, Oct 17, 2023 at 04:51:25PM +0100, Joao Martins wrote:
>> On 17/10/2023 16:29, Jason Gunthorpe wrote:
>>> On Tue, Oct 17, 2023 at 01:06:12PM +0100, Joao Martins wrote:
>>>> On 23/09/2023 02:40, Joao Martins wrote:
>>>>> On 23/09/2023 02:24, Joao Martins wrote:
>>>>>> +int iopt_read_and_clear_dirty_data(struct io_pagetable *iopt,
>>>>>> +				   struct iommu_domain *domain,
>>>>>> +				   unsigned long flags,
>>>>>> +				   struct iommufd_dirty_data *bitmap)
>>>>>> +{
>>>>>> +	unsigned long last_iova, iova = bitmap->iova;
>>>>>> +	unsigned long length = bitmap->length;
>>>>>> +	int ret = -EOPNOTSUPP;
>>>>>> +
>>>>>> +	if ((iova & (iopt->iova_alignment - 1)))
>>>>>> +		return -EINVAL;
>>>>>> +
>>>>>> +	if (check_add_overflow(iova, length - 1, &last_iova))
>>>>>> +		return -EOVERFLOW;
>>>>>> +
>>>>>> +	down_read(&iopt->iova_rwsem);
>>>>>> +	ret = iommu_read_and_clear_dirty(domain, flags, bitmap);
>>>>>> +	up_read(&iopt->iova_rwsem);
>>>>>> +	return ret;
>>>>>> +}
>>>>>
>>>>> I need to call out that a mistake I made, noticed while submitting. I should be
>>>>> walk over iopt_areas here (or in iommu_read_and_clear_dirty()) to check
>>>>> area::pages. So this is a comment I have to fix for next version. 
>>>>
>>>> Below is how I fixed it.
>>>>
>>>> Essentially the thinking being that the user passes either an mapped IOVA area
>>>> it mapped *or* a subset of a mapped IOVA area. This should also allow the
>>>> possibility of having multiple threads read dirties from huge IOVA area splitted
>>>> in different chunks (in the case it gets splitted into lowest level).
>>>
>>> What happens if the iommu_read_and_clear_dirty is done on unmapped
>>> PTEs? It fails?
>>
>> If there's no IOPTE or the IOPTE is non-present, it keeps walking to the next
>> base page (or level-0 IOVA range). For both drivers in this series.
> 
> Hum, so this check doesn't seem quite right then as it is really an
> input validation that the iova is within the tree. It should be able
> to span contiguous areas.
> 
> Write it with the intersection logic:
> 
> for (area = iopt_area_iter_first(iopt, iova, iova_last); area;
>      area = iopt_area_iter_next(area, iova, iova_last)) {
>     if (!area->pages)
>        // fail
> 
>     if (cur_iova < area_first)
>        // fail
> 
>     if (last_iova <= area_last)
>        // success, do iommu_read_and_clear_dirty()
> 
>     cur_iova = area_last + 1;
> }
> 
> // else fail if not success
> 

Perhaps that could be rewritten as e.g.

	ret = -EINVAL;
	iopt_for_each_contig_area(&iter, area, iopt, iova, last_iova) {
		// do iommu_read_and_clear_dirty();
	}

	// else fail.

Though OTOH, the places you wrote as to fail are skipped instead.
