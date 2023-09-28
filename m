Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3732D7B23E5
	for <lists+kvm@lfdr.de>; Thu, 28 Sep 2023 19:29:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231446AbjI1R3a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Sep 2023 13:29:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjI1R32 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Sep 2023 13:29:28 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5475BE5;
        Thu, 28 Sep 2023 10:29:24 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38SGjDDf029393;
        Thu, 28 Sep 2023 17:28:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=j6KG7qQ/Koug1PPyxsJClNoDkYaip8M/7DR8VJD/4V0=;
 b=pkhcWFId/dHkdKDW6CexZecLvzvXWNyUdGYB9iGt9Mk5TIQuFd4p0pBcuS2JcbKyzpgN
 /vgtNwxSC46zO6+nWQ2++s3NacXGl3FOaLXf4gKOsqtPrEMdFVk8Yq7kI1jEHSdEEJrv
 UzXOrFHdwZEtS/LuTxifTeQ1Inbl4uHQDEiTR11ONlC/+r9B1bFQyF7qvrmZfhi5UfHj
 eIVgF+aUqGhPw1KsYebaP9TSIstWUnbh/oLehrM1hNfh5bKRqlUkf/4P7sv8uIh77S5C
 GIkB2yZf0O+muICl0b2CpaacKKSTKYwMHNl3I9jLO+z1Ex96u02+ENcZkp8yGkVRhNzM cQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3t9rjun33c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Sep 2023 17:28:37 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 38SH2MDh004871;
        Thu, 28 Sep 2023 17:28:37 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2177.outbound.protection.outlook.com [104.47.59.177])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3t9pfafgy2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Sep 2023 17:28:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iYsSnXXuul9INSKnSSmlQmFbtmQP1J1Y4tR8+6lpX7BzmSS/mJPQ3qWETbrQnPY/NR3qXBEzpDk2Su+e6gvccFEGFj3rxzOkpPMICrlyifFI643fp+aq2zgybviSRB0YvlkIzTMhJwwp3qDuu3TcXzYGtWcbLQdO/43HluKUa42uEykvlzf2Lx5qGDjpyFwvx2z6QRrl76DlYhOS6KTB8Akvitzpnn8GZI5s8VyeASBJq2zqU8wa9Ss7b0Nkkm6BSzA1o/IKaSS5BACVwym4I2yWIXZFBsxhwsRlQM6oNJLeUs2kvC8Jh2jXOfrEfBeKFLAMtyG4wyxaJfl8O3lnsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j6KG7qQ/Koug1PPyxsJClNoDkYaip8M/7DR8VJD/4V0=;
 b=kTeHbMVIjfvi4vuPLChKDQzpQHCE5jNNWS3lP2ZFIpwXFKIjlK3o0XLCxeNC+0wPCcuzYn61/3JGYw2Dzg7KKWxOVfa/WYIDf7vU5vsjm+Ha3Peq8NUfVtKU3WwIPTvlRvOL6iDxdpqdW70NFWuMThxXZvVEGVAPHDB1noYnZSoci28b5qwmb1TRjiskAWL67C6vsjxllMY+ps+exScHe8BOVyMz/1ANS/Ow9z41T5/CPqiLbxaqd4mrZNdWSmIlTD6Y/2gGZF0L3kWST27q1Npj9a6bMQYMLF6lB9IDVC4QdJB7N4lxHogMF++MIyzqMQsmi8JPsCKhnUFtOqvI/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j6KG7qQ/Koug1PPyxsJClNoDkYaip8M/7DR8VJD/4V0=;
 b=iRKWi3q82hINwl3wgZwZUeNV3khM2+D0OjuyB5XJOyddP3JeBacVG2Sj3UEA3NjCTIiI4Mw/mC1KHd0QDXTWEUoLEqpgbESNrjQfYBtnBxZUjgrArOEG78dquQVbHHNf7fsa7x43SMXcAUNYGNotD0COz2F6d3xq8j8DsYam1lo=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by SA3PR10MB7044.namprd10.prod.outlook.com (2603:10b6:806:31c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.28; Thu, 28 Sep
 2023 17:28:05 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::8adc:498c:8369:f518]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::8adc:498c:8369:f518%3]) with mapi id 15.20.6813.027; Thu, 28 Sep 2023
 17:28:04 +0000
Message-ID: <b12b9b4b-4a2a-4499-8c71-73b8d2338dec@oracle.com>
Date:   Thu, 28 Sep 2023 18:27:57 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/5] iommu/amd: skip updating the IRTE entry when is_run
 is already false
Content-Language: en-US
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     Will Deacon <will@kernel.org>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>, x86@kernel.org,
        Robin Murphy <robin.murphy@arm.com>, iommu@lists.linux.dev,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <seanjc@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
References: <20230928150428.199929-1-mlevitsk@redhat.com>
 <20230928150428.199929-5-mlevitsk@redhat.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <20230928150428.199929-5-mlevitsk@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0235.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a7::6) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|SA3PR10MB7044:EE_
X-MS-Office365-Filtering-Correlation-Id: 2fd17e12-718d-4da0-b88c-08dbc04845e8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KMDnst0wETaQTNgYpoYra3WeMGsJFaQJWDV10mVXskl/uTR7Du/UGYbQaMqcvkhPqQz6mKLY7r+VhRUK6QwXA/RWrDQJMOWWsvSoTEuD/tN0thFR9yKZUEeVyrox/w2uagX+ah5728SgGrkymmdKG9q2UxcG46E9cehS6pN4mVPFGU2VOJmonlfkngkv2Fv3oInOtM5/J8fwoD4sk2fhykCp2RDR9/T+u2UzNRmXStw8xqC0kZbe+Ho2O0b3EJz3xj+CvVlky7XNT+78WOCvWWibSJFxaDc8WyK1mTXSI9JhsxyJtpDK9cbAiHWrVHsvSpxwYmWqwqtdBWstRpCnx3ZZQv6KTmdO8xUJkNhvZd9opl/6WnN4Y91e1DCM/llgdEFwIHf04dt1/LAZNhTyEH7Lj5EaNvHmRWGpUQs/PTWwOBaRIXlPhRCARQlvPzSMoqoLcIJitK1TfWXkxpRqaBVj8oqbB76e3tm+PbLTTbIM38r+Hfnsd9GOn5yhi5ewiutStwiLx7lE8YC4L8e/DfYTYcClAgOpyEhUMv5FQ8cPPRk5xodaGzMHNRln+yeqZLK9S1EGL9BeOJ52QaQlpqNnUkJ3ROvo7TPbPF/bQC+CXREIqABBJjIBnmC27XYaAPrL2GPMRTJPTrF3gva5qA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(376002)(39860400002)(346002)(366004)(136003)(230922051799003)(64100799003)(186009)(451199024)(1800799009)(26005)(4326008)(8676002)(8936002)(66946007)(31686004)(83380400001)(5660300002)(2906002)(38100700002)(6512007)(66476007)(6486002)(6506007)(2616005)(54906003)(66556008)(53546011)(7416002)(316002)(86362001)(41300700001)(478600001)(31696002)(6666004)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NFhkZ1F1cDJML3R2K1lIYkl2TWhDVGxjdmZod3NMckc3Sm1qQTJ0blNLMSsw?=
 =?utf-8?B?RFdJRUxkMkNycWlUbXcrQWdUaUhJUDFZTUdiaVVPM0Z5SmQ4MTE5ajlEWWVK?=
 =?utf-8?B?UEY2YWFoTDEzN3NCbGlHcnFOdWJyd1B3Wkc0a0hIZnR3Z3lnUXE0WXJiZW1D?=
 =?utf-8?B?ZFZuZWNqZDI3UGJFQzE0VEl1UmRadHhRYXg0WGorT2hJaTFUOTZyQ3lsSTdw?=
 =?utf-8?B?UjR6WDhRWUpPdzBucnlsbnE2a0N0SGN5WFZFZkdJbzhSMmtyT1FsaktxUU85?=
 =?utf-8?B?czhISHg4cUx4cUNEQjV4eUNXRDhwNUhJbjAzUloxQys1ODBHUnRyQ1hrR29p?=
 =?utf-8?B?S1dMa1BZcEVIU1Nwd2ZjNDY1NlRGbjJFaEZRQy8rR0JaOTZib3kvTVk5cDZt?=
 =?utf-8?B?U2tDRll6VWU4dStESVBKdTNicDZEQW0zc2pyTGg3N3pQSmczQVBsZnBPbm9z?=
 =?utf-8?B?QzI5b0JlNlMzZjZBeGV5QVZuL3JnRnZrL3Vsa2NJUFR5cTNUaS9OblkrL0Nj?=
 =?utf-8?B?N291QVFGL202dXF0ZTBYdEg5OWdBUmRkZnpjT0pBL0tzTWF0YldLeExWRnJL?=
 =?utf-8?B?MTJHNGIxY3pOSE5OZXFxam9McWU2RkpaSlpiTjAxUnZmQmRqTkNsS0JNTmtZ?=
 =?utf-8?B?d0R4dlFLWVpGRHJNZCtSc0p1SDBaOW5Dd3V0RnF2TENoK2xyMG9xOU5kM3FY?=
 =?utf-8?B?YWF3VTQ0K3BoOER1QW5hMHJwVTFidDdVMW83MzF6VzRXNjRsbVlaRDBLUU1u?=
 =?utf-8?B?OTBBUHMwTklFVUF5bnN4cUo4dW50YmpnZ0xLZFhCZlFjSjhwVnIySDVyWDg0?=
 =?utf-8?B?MnFZbmhoYzJyZ1RieExBNkRFTUlIaTZOV3dGVmZ0VnJtWmpMQ3hXWGZuWDgv?=
 =?utf-8?B?YWR3QUtDaXNYSTNvQnBxd1ltS0hwNGNxWHFCZTR4am5oWW9odWc3NjNEU2JD?=
 =?utf-8?B?Mm9YdmJOUm9GVVpEeEVvQWhrZUQydW9SSVhZYk1VTWN3YlF5RFAwR1pITGhJ?=
 =?utf-8?B?L0FDQ3pMQ2oxWGpweVIzbWY0WGVEenVoZXJDMG9QMnFFM1hsRHFrd0VMTERO?=
 =?utf-8?B?MG9SQzUvYjVMV25vaE14cGpqOUZBWG9TSVR3RUtIN1RuY0NwRnlMVVdCSlJv?=
 =?utf-8?B?eEIzQ1BlUDI0WTJ3MXV6YUJhT2QzSjBPcWMxSXlPa2JiZlBVRGRFbG1vekZr?=
 =?utf-8?B?a0hXVE4xeW1mTFc3WXNYY2lMK215Y0NUOXFzMXpZZ1BxZ0pHUUU0U3luWWZq?=
 =?utf-8?B?VkJXSTZYVUVLNEhKSHFwQUQyWGRRSXFTWkJILzV4aVlPN1RIYWs1c2tpblZP?=
 =?utf-8?B?a2RtcDY1MU5EVlpHTWhaSklGOHl0RWw4WWc2TUQ4VFkrQnNsQzNlNktDVlAv?=
 =?utf-8?B?QStzcGtRR3hJa2tzOFBEVit2YjFtOHFVdG5remM3YUZJSXYxWURhKzB2MElq?=
 =?utf-8?B?aE14MHkzY0NJQmxGS1dXemg4RHRPQmtWaVNoN1MvTUVyNTNvUzc5T2YvUWtX?=
 =?utf-8?B?QzMreFVMaTZmNmh2N1Zma0grblVSUlJRTG45SG5NMTZiL1lsRFRCUENvYVZD?=
 =?utf-8?B?WiszbzNKc3EvbVdZWWRyOTlvcHRJSEk0akpiYWoxNjI5M3NoTkhoMkg3MHFP?=
 =?utf-8?B?ajVQSVNZN2lHNlZ0ZmhCWE1LSDA3TlF6QmlLNjk1YnQ4ZnhGeFhoK1p0RUdm?=
 =?utf-8?B?Vitsem9LdWtNaGpwd2Z0OFVMUXE2TjRkSXA4b0JPL084YllFU3MvRzlTb21M?=
 =?utf-8?B?NWFQWG5FcEpCYm9GYklFRzhyeDBzYmkwZnZrRDNYb3pTd0JvYTNPMHNrYldV?=
 =?utf-8?B?K2s3UjVFN0lobk9WL1FPSWg4SmxsbDNETWxEdHlINnh0Rk94QTVncVNhU1d6?=
 =?utf-8?B?R0IvS25oYllUM2kwR21LUnV2WlVQb2hWY01jd3d0cnNZQmZmVEUvdkdEZVpi?=
 =?utf-8?B?N01HMlQ1RElpdDVnazRhb0p4V1U2djhUTnZyVWU3S1pMcUVYM1pMNDR6OEcy?=
 =?utf-8?B?cnQrcGUwSTlxQm1ielZ4eTZlMFpHQTJyUjVvVG1Dc1F4TFJKaGtHMEtlV0JI?=
 =?utf-8?B?eVcyOThpWm92UTlVbWE1V2FSRmJPeVBWNXJVZjV0U2xJN2prdGh3enB0YVhO?=
 =?utf-8?B?U2xtbGJtcGdOMHgyMGxHWnZzMy9hdExGYnoxTk9QaDE0ZGZXdDB4aThFNVFN?=
 =?utf-8?B?Nmc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?TWx2Ym9PN1drcGExemVzVEtYOXRhTmVXV3N5ZVVoQUs4QWpwMisxVkxnOFh4?=
 =?utf-8?B?Vk5xSUtrVmpNTkV3NnNTUUREZkMvUmlUZ2Z2bDl6WUJ2NHhuUTVIc3NoNHBG?=
 =?utf-8?B?TjFNUFRySEtEUFJENmJZTVpOUFNSWWJNQ2NOVkRFeG96ZERKUFZLbE5iWWZk?=
 =?utf-8?B?WTFabTFSREE5eWFHcHpsK040VmY5Wk1CTEhHeWw0NUNpa21xQmYwYWxZVno4?=
 =?utf-8?B?UUZuNE95dTBwcGRRcWJRTnRGcENLK0pmWGp6eGlhWWVuOVFZNzRueDRRYTVF?=
 =?utf-8?B?NTR3L2ZYdkN3RmZEZENYV1l4aTYzREMvVjhiSnNlWG00V1JDZmZZdE0xeXd4?=
 =?utf-8?B?N0ZTdzhIdTRZdFRUQ3FTYnk2Ulg5UHU0V0NuZ1k3aXJSSTgyM0ZXejRiczJ0?=
 =?utf-8?B?WGM0a1ZoVlhBRlQ2bVE5RzVVeEM3NExIWGQ3RElSYlBBcEJvNTMxSFBYVDB3?=
 =?utf-8?B?MFlDMGh5djMwQlJMcHBGT2xtdndjRGFrRVJucFh3K2Y4amZpRGFwaXJWWVlq?=
 =?utf-8?B?QnpJaytjSldBL3BLQW05THFwTWhxV1ltbFF4R2NMWitRcXl6MlU0eStBcDlq?=
 =?utf-8?B?OW55RzAvWUZldEdHWXY3MzR0cEhUbGVMaEwxN0FGWTMxL1ZtczJoTjdORlJE?=
 =?utf-8?B?QVFXZTVLS2p3YWdRL0cwRHpuOFRMR1VwQUEyZFNiWDl1NnNRdVM4d2NmSnpI?=
 =?utf-8?B?cGVmM0xiRVdvMTlHV3pCQ2JHOTdvWUhFMEZDYWlUa29SeTE5a1ZrcE9VTFpG?=
 =?utf-8?B?M2FmVGJucjRUWWZ6TjU2MVBKOVJBUlNOcGRFa003YmlwZ0Jwd0xTNUxHZTI0?=
 =?utf-8?B?cDdiR1N4dlVIV2E1SGtvSkFmQ0lFK243Qk9aVXZoVzhJZ2Q1ZmxxNGZoM05D?=
 =?utf-8?B?cUd2c2hEUVY5a1BxOVdhRkhjcWtLOG9Pek5DTUhhTnorU1lQSnVuNStCU3M2?=
 =?utf-8?B?OWFDekhvZE9TU3dJYzFTQkY2MHJzYy85bUU5WkIxa3BHcEhkTm5IRUJvQnRa?=
 =?utf-8?B?ZWlXaGIwVkFqZUV6THdIMEI0ZlF0SHFObDhHdEtsRjZsbmNFUTNPT1Z5WU10?=
 =?utf-8?B?RzFWN051Sk9iVlJ2VnVFMnM1bjFvTlQxbkw0U28zaVhCWUVrbmNrM0xRdC9Z?=
 =?utf-8?B?MW1mNjFYaVQ3dG54ZkRVaHNGak9TRWVzMmVrbkE5bWx0UVhaQUVEemY5Rm1P?=
 =?utf-8?B?K3Vtam9MQ2kwWmlaSXV5M1dmNWRhL09CQmFSY2lLUUJsNW9wWmdCa2VwZnRk?=
 =?utf-8?B?R1lJSEdEK2ZKb2RWRnp2K1FOc0VmVUdrT2pMd3RXbi9zUHVDZVBuTzFHc0NO?=
 =?utf-8?B?dzZ5bnNnNkZzT0c3eFR1dkRZSUdCenZJbGpTTFRpMWQ3bEYxS1pRTHU2MUl3?=
 =?utf-8?B?ZTY5VFQ4VjU2aGdyc1ZXeWphOW9jUDFYZE95amlHRHJqYkFzVWJVeDdSR0xL?=
 =?utf-8?B?M1owTkpjeFRsTWw2UllUYzczWXFEUTZLVFR5T3RnPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fd17e12-718d-4da0-b88c-08dbc04845e8
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2023 17:28:04.8578
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +l78SEHnz5/nv1YBQ+PW+wIMWG3Ru/5B5XN+hEXAuOABo5iYly7GMYPsCZdGY9IbAVGzO5m+TcDvSCYyWcG6O2kKIHVG20MCYVyvsbci1Vg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR10MB7044
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-09-28_16,2023-09-28_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 adultscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2309280153
X-Proofpoint-ORIG-GUID: DYoA10H2DDG-87lONjd02TvObVThpD5B
X-Proofpoint-GUID: DYoA10H2DDG-87lONjd02TvObVThpD5B
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/09/2023 16:04, Maxim Levitsky wrote:
> When vCPU affinity of an IRTE which already has
> is_run == false, is updated and the update also sets is_run to false,
> there is nothing to do.
> 
> The goal of this patch is to make a call to 'amd_iommu_update_ga()'
> to be relatively cheap if there is nothing to do.
> 
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>

Reviewed-by: Joao Martins <joao.m.martins@oracle.com>

> ---
>  drivers/iommu/amd/iommu.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
> index 95bd7c25ba6f366..10bcd436e984672 100644
> --- a/drivers/iommu/amd/iommu.c
> +++ b/drivers/iommu/amd/iommu.c
> @@ -3774,6 +3774,15 @@ int amd_iommu_update_ga(int cpu, bool is_run, void *data)
>  		entry->hi.fields.destination =
>  					APICID_TO_IRTE_DEST_HI(cpu);
>  	}
> +
> +	if (!is_run && !entry->lo.fields_vapic.is_run) {
> +		/*
> +		 * No need to notify the IOMMU about an entry which
> +		 * already has is_run == False
> +		 */
> +		return 0;
> +	}
> +
>  	entry->lo.fields_vapic.is_run = is_run;
>  
>  	return modify_irte_ga(ir_data->iommu, ir_data->irq_2_irte.devid,
