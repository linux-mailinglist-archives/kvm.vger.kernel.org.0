Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8928F7ABD24
	for <lists+kvm@lfdr.de>; Sat, 23 Sep 2023 03:41:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230194AbjIWBlc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Sep 2023 21:41:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229807AbjIWBla (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Sep 2023 21:41:30 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A86D1A7
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 18:41:25 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38N1PX6E010635;
        Sat, 23 Sep 2023 01:40:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=vsM7kZ7ukLqYw8fnz2EgZFzaE7VCoWWb+b5NBFpkduo=;
 b=SIGd2eVpteHpnEtEqz9kAvSfWGAouG2tn5b0HU8BvQEbcnMNwmfROEwDwXIb6O5A4rH9
 RAJcefRNywZxKz0Xd4lbDkLP69u6/yQ2FbjAh12zOxpWpUjzWh4gVSB4WSJkAOCL36jf
 6exsoTM5AP81mW7FpZWN8Gb7EcTgtuOUCcFPYkkqhEDIT9F5iVL2VnjI5lpZlGALWiPb
 5nAn02BbMSbAE+quMQhtE2Xs1W5WkGXTLzmcHpGg7ErZGfvUNwXyBjFTpQoTxvSicZnl
 ptxBmG6qQjyQ9iaz0FuGUm0BvJ9yIheobGWn74uNYB9XMZCtlwSL62rwikllZWvzQr86 XQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3t8tt1k2xu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 Sep 2023 01:40:57 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 38N1XsQR005141;
        Sat, 23 Sep 2023 01:40:56 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3t9pf883kn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 Sep 2023 01:40:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mNzFpE4RnrNKuz6bQgmjXMbixSSegCMFXjjybc7orJagb+EqMz8MT5p2Ozb/XlxdTa4hY6oYfJbaQlf31gzyYOtIAsercofOV/8srGZw0Zk1QSjsdPQlcXWPRwTFh1IyhWG5wF9yFWFVA9NjVXhdqGk/iRw/7Mufiw3RqcZNqcQLZK8gH0HH3Y+x42vmIlH+VJ8b61SHwbCbVO72Fw3cuZY0fBMCLVLiYFLAgxuZMvfMAIJKkO4a0ulPnrfoyytSPCiewqeqAxkG8ufKJxCYF9doQFFRoEYI1AnPDvpNBXPpZs6xhfcIWQUUsGjUbxHjZnryl1IPWRYFguDEqBw0Ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vsM7kZ7ukLqYw8fnz2EgZFzaE7VCoWWb+b5NBFpkduo=;
 b=HQ8vw/epaq9NKY2k7cWwJRnO+/ecHkwOnBs538algqWkN1xlctBb+3b2fDKNBpnwNl9Qtv7a4VVxS8gYuEvwD4kWK7KyKy+vzj4XUo7C16SBbt06J1xArD1wW0lrIJ2acG1mEP50sWIgVXP/qygjYr4vy1i8KGAgq69Cdxgt8XoDn/G4gZo+ijna7SXc1icv/wkmyo2fU8vX1ReVHHXVcdXNMBGZVrlhkGUC90iXWSjQj6ryfEM2ZE5Cqvk665uDmmZEwNJbbBBLNI/+gL6UkLHsic1ptExC5Wx1ULG86uK9yB9f3h77HpY/7O9aI/FGdIC0pZR2KOhGIwZA8QeWfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vsM7kZ7ukLqYw8fnz2EgZFzaE7VCoWWb+b5NBFpkduo=;
 b=lPcTJi9K0+6n5pJZ5AT26JUS0AXPqi37aqSUGwQuti2Um9IwPxQt8mAxqEK7N07R0Xq9nExlrbqfD84tLGzmHV4gKCVUSwY9bqLGKKukKOdHFJGk+37SLhom52wt95fFIP56rqQmIMAOeSsg58q9f1OT2+3JiHC4UZj2Dl5WABo=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by MN2PR10MB4175.namprd10.prod.outlook.com (2603:10b6:208:1d9::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.23; Sat, 23 Sep
 2023 01:40:54 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::8adc:498c:8369:f518]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::8adc:498c:8369:f518%3]) with mapi id 15.20.6813.024; Sat, 23 Sep 2023
 01:40:54 +0000
Message-ID: <f7487df9-4e5e-4063-a9e4-7139de63718e@oracle.com>
Date:   Sat, 23 Sep 2023 02:40:45 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 07/19] iommufd: Dirty tracking data support
Content-Language: en-US
To:     iommu@lists.linux.dev
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
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
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <20230923012511.10379-8-joao.m.martins@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS4P191CA0040.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:657::9) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|MN2PR10MB4175:EE_
X-MS-Office365-Filtering-Correlation-Id: d0c691cd-f2fd-4fe8-29f2-08dbbbd61f95
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l1hONXQMx6HwEZkfC9TRcxAZscrxq8CXjGxKNJ9wlfjqNbsnxAS1LispE69gTwD3CAO9GXQHf7Dqe+VzWPqQwqz/Co5a5xluM0PCccnY1ZP/B6LJ7iFplCmjRthtHZ+gLTFhhGM0APVHUkeDhopBOOVbtiC1dUG3bV4SKQyueU0OMw/U7o/pW+uGzZQKu5xGiHNQ+HuCuTol5xsMNuxSpriedwbMa/FgQb4d97WCtwOlfJlMKhB2jS4FEhCXH9ngo5nmcQ1s/Z+rMKqkdnFh5y2XNx65JcQVHeC3qpPKPkqcNhtHKMGiCjz/rBXI/UeqrFr0KWJOY6lXImfqNpnoG6+itzeq5hr3l50221rKfgl96PagLRiyX3moCjBavAkLmBWge9uelgzwwsVt8rP06XrwuR+w5wTKj7IBAgOVGvZOGGCLqOVViO2ESQ1eNEMhMO+pgXKss67ErEBzkD+/aZLSB+dXQuUtR3HHDSFPQsLIO3aqSt9qO1KJQyyyi07YF5/q3Icadv8Ds/8aLltYDyJwGNYOkDlY03px6dEIWnScTE8bGfMlXsGZIfuZ/Pto8fNVVgnTIWRJQSo8jkUUGzjP1VInNF6O2wrOhrLfSm+aFAMDH+fI5lMfRpXrAXlBWEz4iYtlfv5CdD7X4S6VASETGK3r8ZGyYEctiqHFJKE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(39860400002)(366004)(136003)(346002)(376002)(230922051799003)(186009)(451199024)(1800799009)(2616005)(316002)(26005)(53546011)(6506007)(6512007)(6486002)(36756003)(31696002)(86362001)(38100700002)(83380400001)(6916009)(41300700001)(54906003)(66556008)(66476007)(8676002)(5660300002)(4326008)(8936002)(66946007)(7416002)(2906002)(31686004)(6666004)(478600001)(14143004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dks3WDQvT3hjVDQ0OGZuTzNCQTNiYWRWZHAxS2NRQngwa3ROU1J6MmVPdFhK?=
 =?utf-8?B?ekVLZWtkeVhoNVh5ZGgxQmxzU3plVEh4b0hZSDZVcXZjdVh5eTBWQXRFRkRw?=
 =?utf-8?B?bDFXUUJlT25Ha211dk94ZldFcTFWeDFaN3NMN0hUckR3eGFoZjl6ZHFCNWJn?=
 =?utf-8?B?cGRycmswam1BZmM3Zzc4VmNaMDdkUDNSOHBjMzVwZXgzckF0S0QrWCtwY2l3?=
 =?utf-8?B?QWpPUmFrcm1VdXduV2ppeEh4dFM3S2tYQzB6cDBqTXg5elJnaHlJaEJXWm5K?=
 =?utf-8?B?R0hzK2ZMYzR3a0pVbG53a1lFejRrM2NFOUtBZjlwaktveDE0UFpzRTNkZ2xn?=
 =?utf-8?B?dkVDU0NQdnhyckNxU25FY3RJYWVPbERadFN3bzlwRVVVdjZaeDBNVUdLWnpD?=
 =?utf-8?B?djU5eHhYR1RqTWo2RzA0dUUyRUxKU3V6SitNMXJ2TU1jZVVWZWV6NldWWWd4?=
 =?utf-8?B?TlVHcjlZV0E2R0o2Wk9kUWlJNldDK3ZVb3htb2VJT3RueHVmVUpQYko4WnRs?=
 =?utf-8?B?YmdUN0JabUR6azJMMWR5RnRyWml1QlRGZUdtTmFrTzVEa21xSFl2MnFTWFlJ?=
 =?utf-8?B?cVFxb0FvVDBiTjg2K0ZhU3ByMEVjeHBvRStIZWN0UFdXVDR2NjltMUV3dGtK?=
 =?utf-8?B?NzRGei9sYzBqVVJVSUhFZmw1RmRGWnR5c2dmdGxhQ1lSMmsyVW5jVUxWZ2VC?=
 =?utf-8?B?N1JZbHB1YUxxZXJFZ3JKaEpRcUwwUTFwSFplNWRPYnRJc1U0aWFRNzYyVU5T?=
 =?utf-8?B?TWkwZDFRS3hNdEtXcC80azdUZmxmelNlMlpnZGVnNGlpSFZYZkthSjE3WUdK?=
 =?utf-8?B?cVoxdld0ZTlwclM5alF2SW1kdnVEcHN5cnowaXNxaXkrbzhzQjFIKzlrMHlT?=
 =?utf-8?B?R0ZmeHRJMUtLNUJTcWZMMS9QRFdtOC9OSStta2VSSmNzWm5zaGwwYm5vTmJW?=
 =?utf-8?B?SXo3c0UwOFBpcVppUEo5VWNGTGNNZzRYNDhHOVRhQWowSnU3S25lUzMxMHRv?=
 =?utf-8?B?ZUVIUzJFdFg1M2dNeWdGaW8rOW85QVVUWGZSTzdaZkZqSzBnd05hN1p6b2E1?=
 =?utf-8?B?ekV0UjMvU0ZkQTEzaSs2QkhMUGF5OVh5U0RrK3pIbVNIbHpDcWFYNzZMQzF2?=
 =?utf-8?B?SjI5cTF3OGRsbVk2R29Sem5YTUhWSWR4WHg3UmU2bjI1aGFla1I2bXhoa1Z0?=
 =?utf-8?B?cmJ3VUkwdGN6K0FMNXIxSVFGOTFSY2wvaXczTzBwaXJlWGhTVkNJUzRaaHpv?=
 =?utf-8?B?QXl5aW5PaHlQdTcwZVNQcHFXYllPZXd4WTdCYS9ja1RNSmc0aUIrdE1HU085?=
 =?utf-8?B?bExBNTdmUmV0REhrL3Z0clBlQWxOb0Jnd0JLUlBuV01sRnp5L0ZGaXQvV0RN?=
 =?utf-8?B?WkFOSlFYNVRHYUp6bGRFQTRiaEpmRjBrTWlpLzJiNnBVV0hDbHVSQU5oaWdQ?=
 =?utf-8?B?amIxZmw5bTg1elhNVWtHaGJRczdvOWhwVHlmbC8xc0lRNnd5VzQvR2daTnZh?=
 =?utf-8?B?dGxlZXJuQm11UlNmNDVXMHkvNzVIOVdOSmxaeVZrandINVB5aE0wMW5GQm1h?=
 =?utf-8?B?SEh0ZklpaktRYnFKNjZRYWZMb2lYTGdaQXYvbHhzQTh3UUlmMWE1Y2FKaDZn?=
 =?utf-8?B?cTNJdTJFdFFNemMxQmRkZmtKYkRYTnd1b1NkR3YzbXJ6aEIrNWJ0SUg3Kzkx?=
 =?utf-8?B?UDg4dzZkOE5iVktlN0dLbTZRRFhWVEd1SDdmWlFmNWhRdE9hYXZMckxLR2VH?=
 =?utf-8?B?QmJyaVdubjlPbVA0Q3hCTWdhSE9kTDNUR1pOUXYzRnZGZXluVjNLamdJV3Iv?=
 =?utf-8?B?U1BGb2piQUcrNFFjL2FPSUMzV3lIU2MxWi9DbjVlOGt5Rm12RlJoa0o5cUFC?=
 =?utf-8?B?d1FlN0Q1Vld4WWFqcnJJaS9UYjBiZFRFa2pyR2xTRkdFZEJKaGcwclQwZnVQ?=
 =?utf-8?B?endrNE01MmZtcktGWDFtbWpjdDRjWlB1M0pId2xEWG9reFFoK2NSVkFjeE10?=
 =?utf-8?B?dFBwSEpzMTZhMm4vK3JFckdEcEZFaUxrdkptYnFLTzFpb3p4RmZnU29IRHZa?=
 =?utf-8?B?K0N5OEFmczRkQkNNRHNCWlc2cTdDWGVYS1hZOFByZTArNVI2b2ZlMFNEWEpV?=
 =?utf-8?B?bUhHRUJ6TEVqekU5aTJkVEUralBaVGxrVitCWVcwYTVVZXBjaUZJMWFsWmhh?=
 =?utf-8?B?UUE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?YXhUa3JXUUtNZ1BmYjdCYUNRY0lyanVibHA4b1V1cU5QQTdvZ1Y4TjBMRzAx?=
 =?utf-8?B?dExRS2hDNlFsWUlqb0FNTllLd21mTlF0TlJ0RnRhRjhQenNpRTVLcXZMUGpR?=
 =?utf-8?B?dUl3TE1EQnBXQWZZZzkxY3dta0tlNEhzV3NUdlBMdDFrNGFXTE8rWDR4T1pp?=
 =?utf-8?B?OTZnS2tETDVBdkpqVmZ2a2tMbnhjMnZXNmNhRUo2MFQwNWFIS2ZYUHp6dTZ2?=
 =?utf-8?B?S1RnVUNHRnVVTGNJUDk3YTducHVpbjhLMGtNbkQxWE1VcXRNbEVNeEZySjB3?=
 =?utf-8?B?QmF5R2t1VE5ZVDRjb0RyNGhZQzRBN1NoMDBWVkZEZ0hJdk1TaWhmL1piSk81?=
 =?utf-8?B?WjV5d3ArWUJKeXJLVnlTL1FTUURxUC9ab0FUdERNV2FCNit4b3BCK0gvV1Jx?=
 =?utf-8?B?VlFXeUVUaWdrZW4xdEhBQ05uY21ialkweHMxcEE0bGQ4ZjJ4UGF5NVVrZFYv?=
 =?utf-8?B?cXk5amlwZzZHYXRLTWVKZHBOeUYwTWYrQm5XaGFNV2dFSldwSWFxWkc5bGV4?=
 =?utf-8?B?dmttZ3V4TjkwWE9XYWJBQWJsU1dESFpPTEl1L1d1bDkwUUFXQkgrRld1TWJC?=
 =?utf-8?B?dFJzaXFDcFZ0T3lTbG1oR0JQYngrU1dtWGwyYk9ZTk94R2t1Mk94Y0NaVUta?=
 =?utf-8?B?RS94KzEvbXRaQUhWREN6Y1FqS1lvaTZHZU93d3NqQTEvVDU2NWRUbTdNSmJE?=
 =?utf-8?B?SFdoM1ZXdlNjTjEyQUF4cXhvVC92MzdWTWlOVytNQXhZR1cxUkl2RjhlMmg4?=
 =?utf-8?B?bFVHSm1CdHpPc2dUUXJiZDhnazdqMDV6S2Q5SnkyMDB1bmNNR2dEVjlCaXho?=
 =?utf-8?B?cnA4K01KcDNVUUdUM2lnR1lCbndIcHh6U1dYaXdlZTV6UEdoak9kNHFXa1Uv?=
 =?utf-8?B?bVBCVDlkUnd5SUNuT0MzOXVEM3lETmZ1cUlqTXhpZVhLSGE0UDFsSk4ycDFw?=
 =?utf-8?B?OEo4SlpMTjBpVENLMEtRWldveWhySjFwbDZERGFQclBCUnpnZ2MyMUp4aEFx?=
 =?utf-8?B?TG43a3gzLzBRNzdyYkY0K1pER2VhOStDMlFHOXU4YmR6UnVPKzBBZjFPeG0w?=
 =?utf-8?B?VGE1dEhHZVcxSHVRR0t3ZlJMSDhoU2pSMU1VcFg5TW5Mbm95OWRibmxXNjM3?=
 =?utf-8?B?aExqSkJtTGZpQVZZODZSWFRzMlVOYWpzTkc3dUF6c0h0UFpzRUFzQyt5OFU0?=
 =?utf-8?B?RDdPVCtiOU5VOHFFeHdUREFTRmNqRHFoZ2V6OFpFVW9OeUxmM3FNYm9KWklh?=
 =?utf-8?B?Q1hmMVFuZHZLeGpnaDJkT0t0QXc4Zlg3YjNSaFVLMlZtdVRlVHlROERKckFC?=
 =?utf-8?B?cGV0bFE4enNDM0pENG9QQ2svbTRMbVp2bDZvSUUwYWNHWG04NVZIaUQrNis3?=
 =?utf-8?B?NGtWMzdjMkNncTJ1a1VBRzNSem0xN3FkN2RuMFNxSkc0eDIwYlJaOFFDNVRL?=
 =?utf-8?Q?Qt1WxvnO?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0c691cd-f2fd-4fe8-29f2-08dbbbd61f95
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2023 01:40:53.6989
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wEj0PyVEb+EVkWQub37rzNTwlXfN5q9Yn8yJclpeX1WYtNIIEq2tctu/nzudWz/B8wHPbvgrvf5PjiTRE5PVZUNaZ1LHx7Amxs4emTjxLQE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4175
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-09-22_21,2023-09-21_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 mlxscore=0
 malwarescore=0 suspectscore=0 bulkscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2309230013
X-Proofpoint-GUID: bZTix7RvNUNFPVUOMCtw7iQ29UCK1MA-
X-Proofpoint-ORIG-GUID: bZTix7RvNUNFPVUOMCtw7iQ29UCK1MA-
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/09/2023 02:24, Joao Martins wrote:
> +int iopt_read_and_clear_dirty_data(struct io_pagetable *iopt,
> +				   struct iommu_domain *domain,
> +				   unsigned long flags,
> +				   struct iommufd_dirty_data *bitmap)
> +{
> +	unsigned long last_iova, iova = bitmap->iova;
> +	unsigned long length = bitmap->length;
> +	int ret = -EOPNOTSUPP;
> +
> +	if ((iova & (iopt->iova_alignment - 1)))
> +		return -EINVAL;
> +
> +	if (check_add_overflow(iova, length - 1, &last_iova))
> +		return -EOVERFLOW;
> +
> +	down_read(&iopt->iova_rwsem);
> +	ret = iommu_read_and_clear_dirty(domain, flags, bitmap);
> +	up_read(&iopt->iova_rwsem);
> +	return ret;
> +}

I need to call out that a mistake I made, noticed while submitting. I should be
walk over iopt_areas here (or in iommu_read_and_clear_dirty()) to check
area::pages. So this is a comment I have to fix for next version. I did that for
clear_dirty but not for this function hence half-backed. There are a lot of
other changes nonetheless, so didn't wanted to break what I had there. Apologies
for the distraction.

	Joao
