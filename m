Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 868BF7B23E9
	for <lists+kvm@lfdr.de>; Thu, 28 Sep 2023 19:29:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231953AbjI1R3y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Sep 2023 13:29:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232009AbjI1R3q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Sep 2023 13:29:46 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 368E61A3;
        Thu, 28 Sep 2023 10:29:45 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38SGj5KL013584;
        Thu, 28 Sep 2023 17:29:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=pywk0DOZ4oeu46GYvw7QB3YCiKgdIXTG8lRo1OLbr0Q=;
 b=SLt5paB3aDZ64Mmm9QlZcgV+dwHfc35kekVHLGvnXw7U9yuChup/K6a3Y4T8hB3k/3wJ
 /fMWdn6gXA/N7rvOvwXjgPKBqGGATy3JOfONF/cY3CjgyD352DTyP7eAJI+gz9X6aXEf
 7zCGkudMShIJrwiRzHInNnil/2o/inoAPe2nDszw2i8FBFR1KxSSDfTH1kZUm6bs8JDV
 QHrjRcteu7A9b8ZE7vo+CPcT1zHs85o/lzDesjFbGOPXVEuldHhBB106mn+DbA6/ZNfM
 weBwBdr1abrN4HwaoNVcXbFNRmOEdYlOQIPtVvxolFa8lNQhiX9S+3kgRjcKy3vDHuT/ aw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3t9qwbn08m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Sep 2023 17:29:30 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 38SGxHIG015784;
        Thu, 28 Sep 2023 17:29:28 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3t9pfg0dac-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Sep 2023 17:29:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nlLHBu3hmrMyWVNh/8ylGgRF/KNFgAw3kBWTbCBNoXJOaOe9sE9kU5gNw6eqJjlTmF8OwQaUWTDoLV+Jv6W4KU0I5qrywl1cfCoFLR0BfgmzT30p1QRrZ5/hvzKE9jbtPAdYoC7VS2uHRGwHocSmSv3cDImctAr3SRJxj0UFqrccK85vIqRWrhnsFuQB7Jjoe3Y4ZoWRvqbcx8M8FXdv2ejl8tux6+l+vZxcbXOX1/GWhY2taRYskTzP08RA+snoJdy6x2+eQHYlZLU5JXhxYOF3xY2FXBW0YpO7AoLW2/OWv5nAiltUQSAwmLuIP4Rrx9kB88LPX+GTwLQOPSUpPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pywk0DOZ4oeu46GYvw7QB3YCiKgdIXTG8lRo1OLbr0Q=;
 b=R5AE4g67Hz7PszUd7wUGiUDHDw/JptcLcuxw8wF8e3SxGODNyXPCe/N1tBIyYqXkB5yHqH4V/vrZ0a93/fsWTvgDLfvKXA20ffhaohKeIp9dkp4pS2VkKOq+qz8b4WgG7G7TyHwT9gMfnvjr850xpIv/fzAtzH2U6NBLnq7myEwDJjlCxsejN2ZIt++ToQ3z7kTxife7A21HTK178D9GgNXJvR88MwCaLZnu57xo/k46lwNOXmkXbybQvngiNCrED9UuLwlIEIRrsdt3JQd6MFsD538+Ri0xm22QoBoiFxz4OTIZ7wIcwnaZ+NwcikjJHNmMFejc/GcoMtP9SoGQ6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pywk0DOZ4oeu46GYvw7QB3YCiKgdIXTG8lRo1OLbr0Q=;
 b=Hk/mZL334O9+pOjxtKiNuzzS7gF1DX96fjnMBTq4RivhzSLO9H7ZBHza3ZmpT1+GFNGm1yhw2suI6fjIICo8+TJQoT3RdF1PxyWZCW92d0EZSevfqY8SRxkNoIRfd1JxxMnB3QXA8F4RDULLnvLKcXGfWAPyrOVup+3U1vBE69s=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by SA3PR10MB7044.namprd10.prod.outlook.com (2603:10b6:806:31c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.28; Thu, 28 Sep
 2023 17:29:26 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::8adc:498c:8369:f518]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::8adc:498c:8369:f518%3]) with mapi id 15.20.6813.027; Thu, 28 Sep 2023
 17:29:26 +0000
Message-ID: <89180834-7d59-48a0-b3fe-38da6d4f59bd@oracle.com>
Date:   Thu, 28 Sep 2023 18:29:24 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 06/10] iommu/amd: KVM: SVM: Use pi_desc_addr to derive
 ga_root_ptr
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org
Cc:     iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Joerg Roedel <joro@8bytes.org>
References: <20230815213533.548732-1-seanjc@google.com>
 <20230815213533.548732-7-seanjc@google.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <20230815213533.548732-7-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0235.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a7::6) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|SA3PR10MB7044:EE_
X-MS-Office365-Filtering-Correlation-Id: d13ef48f-a0e4-4f89-5dd5-08dbc048767a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: artiIroxt2nwabn68yKb06WS3H3932N1Z20sfbemSseW6forbgjIAE/xw4y/pQt9/bhgoKp/FT2UTMaWqLr+h9xPEVEM2ZBFvJui8vGuod/BJRJ44I3h7Qjm6USfVVJfA88HfZGg6fQNMhSj//9rAX/K8D5m6bOAJVEd8GXrYNzV2zYatDBtC3nXN0xVb1dqU4zuKkUfrPKyqCru2DMa78opbdcPXeytC7RD6RdCYQRKfByMNDti3hKeLmLapRlo3Vvoa/ZC+POExybcmrOvSmcf49fmtjwsCwSJ8UE0I2HapYlAzcLZdEib1qApReYy+KvjJ+N6YvMTuzx5kpSlPjo40oJkbe5Hpv52L99eEcp3auhAdyM/32B94h4MssmTBMisIGzEdDUEwqQbxNbxSZWwh1dGrpIUfOFcmPJ8dMEECAQ5cG0VPTWurAhzC3AjzWSO1XsoZgcXrHurtxici0OgI3TucAv6sDbxQ1LcADQ1Jdx0gT4X6ZveSOE7SRU/Y4VImJhRq5zdFIDnNxRQxg9Wz8KP3J7O0ryb3DwiF3g5oA0VJoNvU535Gi3gJ/OsQ9Wrge1mgxKZfuRTJXZ5cDiH/Wf8jREvt0PgrOTb6XgH1AnvtVQCknlxSk0ghi5Tei1GsCB/hvk4U9oKmkXmDg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(376002)(39860400002)(346002)(366004)(136003)(230922051799003)(64100799003)(186009)(451199024)(1800799009)(26005)(4326008)(8676002)(8936002)(66946007)(31686004)(83380400001)(5660300002)(2906002)(38100700002)(6512007)(66476007)(6486002)(6506007)(2616005)(54906003)(66556008)(53546011)(316002)(86362001)(41300700001)(478600001)(31696002)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VHE1SFQvdzlIYVpOc2JhOWpjUW9RZEFyOVhvNS9tUnB1ZmQyOGZYdUxBTW9q?=
 =?utf-8?B?WTlWU3pzTE83Smw5eWkyWUxTUmpRWFhpN3FWd29CTTAxMG1hSXkwR0JkSTda?=
 =?utf-8?B?VmMwdVg5MXZjT0pycHBRRXNjdzk1QnBaTCtUR0RHaDd4RHlRdTQ1QVlwcHdB?=
 =?utf-8?B?cERYSFdFSU93YlI1YXRaMG5EYnNQbDZGN001K1hiQ3VCYittbklZMS8ra09T?=
 =?utf-8?B?L1lmWGVpVlJQZ2FsRUlJVS9EM2NKa3Npd1N0TDQwZnQ3cmNUN3dRYVB6OFFZ?=
 =?utf-8?B?RFhHY2JNL2tNelZXQWhwb1ZZSjJiTkdlaW9SQlRnS3NPem1Tb2dyVjBGNWY1?=
 =?utf-8?B?eld5NWxYTi9xOTcyZjl2R0pXV3FyUjE5ai82WDM3RVVSUWRkWG52SEM1eXdn?=
 =?utf-8?B?Mmh4THhnZnBTcFM1bkhhaEFuaG1HdlFHM003U1M0N3FSUHBIcENreXFhREI5?=
 =?utf-8?B?TUo2ajcrWHFGb3ducisxdlE5S1pKLzR2bVExMTNNZ0hsRjZLUEgvck1TZlQx?=
 =?utf-8?B?NVdEUFdvY0ZyNmxodmpGRDQ1bEJ3clN0VEhyT1BESzBlbXg4WDJ2SWJuZ0pF?=
 =?utf-8?B?a2lldEIzaDZhcjBxRWZiMUN4R3lOMmd5eWg4QWxCS1c3SHFHQnJRZHVsNmZx?=
 =?utf-8?B?STVrbDFHbkRYaFZzVnB4MGxLYklzYnFrZVhzcE8wVW5FRE01UHU3RTRRamNP?=
 =?utf-8?B?d3B5cW83QzFPVEZFNTZEZEN4NXg5Qk5UaGJIdXNVWFZKVGtYUms3MzlDcC8r?=
 =?utf-8?B?NWZqWTBtdy9xTEFqU0ZkZEFUSCtaaGVuQVB2RWwwTHAvcTZnQmxkV3JySk9v?=
 =?utf-8?B?aVg0VGwxMEdoRGQwekpqeG11dVNsMFI3WUZLTWxjb092azVtU2FvMVJSV3Bn?=
 =?utf-8?B?OGE1TzJRYnVmSzNXc3p4ZFMvd2JISFdScEZkT1NYeisvSmMybmUycXR2Q3dt?=
 =?utf-8?B?cTJmQTVkRzlwMXplOVJmUnZnZDd0RmxwNUtXMkN0bHhkTWZURXV6amJ4d2U1?=
 =?utf-8?B?Y3FqeW5nS3VLMGVxaXA3NEI1Um44NEJIL016ZnBrcmtZWU11V0FvQk9KMDJu?=
 =?utf-8?B?TjV2NjVDYUpjWXdTOGZoNWx2Ni82NlZzR2doakJ1aXZISlhSZ050ekd5SG4y?=
 =?utf-8?B?ZndkcHNJcWliVEUzbE1XdE5hOWMzRGpWWEswWjVOWmxhUEVyUEFYcC9aMUs1?=
 =?utf-8?B?MWoxbUEvWVEwR282V0VoOXB1VmsvbjFyWFNTOEF3MjZhck96TUtsbW5XVUZv?=
 =?utf-8?B?NTBscXluSzg5bUtUK0NybmJnU1RUNWV0eXlvSUhVN0txSEJuMkZTYjArNlBG?=
 =?utf-8?B?TUExZWxZVU9ZbmxKR3JBdTdXdE1OUlU2Z1UzZ0dTYW44d0JrL0FJVk9tR1hz?=
 =?utf-8?B?VytPVWlhaGk5MFhsZHZzMWJRSkgvSzByenVhV201SHdmZG1hMEVOVjlRWXRU?=
 =?utf-8?B?czRsUWN5OUt6Tm1GNGc4REt0NDFrTVFIZ2RFajRBMko1WkpLWUp1VjIyR0w5?=
 =?utf-8?B?R0dubm1HSHBMYStNaG9jT2xNVVczQ0EvcUhndldCSFpaWXNnbkUrcXdtWHF6?=
 =?utf-8?B?WERGMTBFanVkbDJwcU5RbWgxVHcxaElPZmZYdUpJMXNIOEExRGVXbDFOU3Ay?=
 =?utf-8?B?NXl5Zms4MWRVY1FhR1p3UHE5Rk9EU25GaUQrQ3FrRHRZZWRkKzg1aWlhQVZ1?=
 =?utf-8?B?M1Rva2ovNVR6MTNzZFRzWS96dHdjeldlYWxOZGczdXBTV3pMdW9ObzR0WWFm?=
 =?utf-8?B?djk3ZXhuczYzZjRqeWVKclRCRTFPdklUbmxaMmVsMFgvb1l1UEhVSkxOYWMz?=
 =?utf-8?B?dVEycmw0WHpWU1JqRnJZemxjYWJxZmhRaGxJWmthNFZ4b1FPaCtoOUV6SFVn?=
 =?utf-8?B?dnhNNFlQcnBXUXdSV2JQdm1adHN0V2F1S2lnTzRWZ0RjTGVnbm1qcDkzekJW?=
 =?utf-8?B?Rjk0VWVFclFuMWMxa3dmSDRsdkQrU3hKZStUN2NhYklwb2dTZlQ4TWczNmlZ?=
 =?utf-8?B?N3F5Qy9NZ29QeGVhdnFnUUljYTBSNS9SWmtMb3hkL1FiamVqNG10N2hYT24y?=
 =?utf-8?B?cjM3dFpkWkFxQk1RakF6Mm1KTHZSUU93ZDBuTnFvM0tyU2hhaFQ2OTEraGFV?=
 =?utf-8?B?aVpqT0pJcjZPb2hlZG43Yzd0MFFsVW9mWGxBWVRVUFpNM2xUcFZ5b2U1eXh2?=
 =?utf-8?B?UGc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: j5DiuiJXXy7OD7KLGon4au1ar9u756oReqb7aQr7pN5TIcROWrB1rL8ghdwK/1TOt2f9E8N5GBZaONTbMtY1df/hCQItzmwutVLgy917xT5eMTW8J0AbhZQvjpbjHXDPEOvCOznqyd01QzS5wnntMqttWAXsNlZgsqSbW7VI4M4pw/j8bN4rH0ibWkK6v0GUp2HCg3MZOQtO9la92umTki2Gvb0QhW7ImHHX/hVenwA5YKKHt/e/IztFUU+IMtV111UnZQYFMLXF2rywiMGOAA08agxX0MbHMx0fwfjzqgej1PfHyLh+hTcQbjKGGk5NbHS9pXBXbmNJCA1IZYPWIRwG2vvuBHTQ1IcsUNKl0HlV1RVcKg9CiP+x4i79JCguikykCTPzfZgUqGSY2jDL7/37lEV7YP6jM//UTbuT2XqxMd10dCA1xwFK9xSZ6SeFBhqlLKvClQ7ccZPWd0P5Y1gd/sGBpa6199wAW4edlirpPSklpcEIaEhFi4ENRI4I8csZpN2+JgUsvTtjIrw1xQcNfwim6ras6pZDAv6U9nLhrJcjyxLYXqukJm+ue/yOudqvbtfkeRk0YKIV7KKyG4mi4l/+xoZUgcg+DKkVIjzfeUoXYtaRS1DUmOv32GAkFat9owN34UvGFSWYRwQgmPjtRtZbs0twrFVEMn96D7c4P+zmTD4yP2MOtWn8asf8rJQqchpajqyqjYPYK6JnqQqXuEPZCuSyobLF4ActX7D5bceSsK2TTANsSQf271c3Lhlx+HE53v/TF+14WntVkREWM4piDb3u5t0b8mzxpMU+P1Ikc2JKIgXzyJroWqyAhbZBTItex5/pHZIllun88TotuBW+0LlIzwKezsNTM7MfnAf4N6XPAVbTAatyldsAbxf15Wstn3bEMXMMYIcZVA==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d13ef48f-a0e4-4f89-5dd5-08dbc048767a
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2023 17:29:26.2843
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GoZGmGYjbzDN+w82A8+JLoo6C1AbWgnzgILcfJb+U2NB2EgObAgLNxaXpvDm+1tAR5PPOivIr9tQDVZKU4oWfBRpu3YBydACwhhOxAX8PCQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR10MB7044
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-09-28_16,2023-09-28_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 mlxscore=0
 malwarescore=0 suspectscore=0 bulkscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2309280153
X-Proofpoint-GUID: D6uWqR3B1H0FC6bUwna3iTkkGuNiD7f8
X-Proofpoint-ORIG-GUID: D6uWqR3B1H0FC6bUwna3iTkkGuNiD7f8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 15/08/2023 22:35, Sean Christopherson wrote:
> Use vcpu_data.pi_desc_addr instead of amd_iommu_pi_data.base to get the
> GA root pointer.  KVM is the only source of amd_iommu_pi_data.base, and
> KVM's one and only path for writing amd_iommu_pi_data.base computes the
> exact same value for vcpu_data.pi_desc_addr and amd_iommu_pi_data.base,
> and fills amd_iommu_pi_data.base if and only if vcpu_data.pi_desc_addr is
> valid, i.e. amd_iommu_pi_data.base is fully redundant.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Nice cleanup,

Reviewed-by: Joao Martins <joao.m.martins@oracle.com>

> ---
>  arch/x86/kvm/svm/avic.c   | 1 -
>  drivers/iommu/amd/iommu.c | 2 +-
>  include/linux/amd-iommu.h | 1 -
>  3 files changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index e49b682c8469..bd81e3517838 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -919,7 +919,6 @@ int avic_pi_update_irte(struct kvm *kvm, unsigned int host_irq,
>  			struct amd_iommu_pi_data pi;
>  
>  			/* Try to enable guest_mode in IRTE */
> -			pi.base = avic_get_backing_page_address(svm);
>  			pi.ga_tag = AVIC_GATAG(to_kvm_svm(kvm)->avic_vm_id,
>  						     svm->vcpu.vcpu_id);
>  			pi.is_guest_mode = true;
> diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
> index c3b58a8389b9..9814df73b9a7 100644
> --- a/drivers/iommu/amd/iommu.c
> +++ b/drivers/iommu/amd/iommu.c
> @@ -3622,7 +3622,7 @@ static int amd_ir_set_vcpu_affinity(struct irq_data *data, void *vcpu_info)
>  
>  	pi_data->prev_ga_tag = ir_data->cached_ga_tag;
>  	if (pi_data->is_guest_mode) {
> -		ir_data->ga_root_ptr = (pi_data->base >> 12);
> +		ir_data->ga_root_ptr = (vcpu_pi_info->pi_desc_addr >> 12);
>  		ir_data->ga_vector = vcpu_pi_info->vector;
>  		ir_data->ga_tag = pi_data->ga_tag;
>  		ret = amd_iommu_activate_guest_mode(ir_data);
> diff --git a/include/linux/amd-iommu.h b/include/linux/amd-iommu.h
> index 953e6f12fa1c..30d19ad0e8a9 100644
> --- a/include/linux/amd-iommu.h
> +++ b/include/linux/amd-iommu.h
> @@ -20,7 +20,6 @@ struct amd_iommu;
>  struct amd_iommu_pi_data {
>  	u32 ga_tag;
>  	u32 prev_ga_tag;
> -	u64 base;
>  	bool is_guest_mode;
>  	struct vcpu_data *vcpu_data;
>  	void *ir_data;
