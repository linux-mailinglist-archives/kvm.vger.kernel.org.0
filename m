Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8D227CCFDA
	for <lists+kvm@lfdr.de>; Wed, 18 Oct 2023 00:05:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232068AbjJQWFZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Oct 2023 18:05:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230056AbjJQWFX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Oct 2023 18:05:23 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ED6EB0
        for <kvm@vger.kernel.org>; Tue, 17 Oct 2023 15:05:22 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39HJx8vm013021;
        Tue, 17 Oct 2023 22:04:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : from : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=G935sKdwoyZmqCDixcpLevFfaB/yby5AKU67IU7iNRw=;
 b=01y/Ib/veDjA597PVGlko8RqHlQJjsxjS4zOjeP/UWl2k9ZhA2sF3nRd9Lx4Q7nTYSA9
 Aqzi5j4Fs7REFueEPRi6BoqnBztWMte82vSNKP3AbnT/Pe89MySdb79twfCXE0m4UM1G
 fFZyPvn4LPv4R1ofdXs7g/WeLBX+0G9JXSh4cEVKQZ6uz/Ym9Q8Qu/iusGv+9LVZcSmW
 g6pdcb/R3EC4RmPgU04am2uHnd6wl7TGT1AG9tiTcG26t+1CpjA9LcoGV8A4/l74oBjE
 8x/eqblkc8mt5O2YA4+UnISb6iMa6SVpXl+2O4EGGmkyv3HYZoZnGjTUWRP1ocHinOox EQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tqk3jpag0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Oct 2023 22:04:56 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39HKG6bb015354;
        Tue, 17 Oct 2023 22:04:55 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3trg1fp1gy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Oct 2023 22:04:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lHB2BbWmqn8Epw+xvJ37orbj9KplW89kWoF/lIy1bySBP8o6TzeFxGKOzOMQQR5tMu0d/tk84aDxcFi2DEHxnMqxVuhKiYn96MYUwNwBZtEiYCRQkJvg0NRTKK/rP7Q1TDC8eRHnSaIDds+XZ1JZu1FxA9B4rlllF+7HKE0gigg8FlhYCbhWFKs8RsoBSxKLWkDNvPRrtlmWoyfwKrnblVue8ROxW11daNbRqKlM/PouUwN5KUt9/hyKMR0x4dOOTPE4iESlPk1WoM20x7T7d8nWEvq0uoTJ6aGFSbu2pyIm3InmAfcQh6kkhYTkOONiTcWrRX2T2oLByi7xa0i9Rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G935sKdwoyZmqCDixcpLevFfaB/yby5AKU67IU7iNRw=;
 b=jMQ2ykrY3l0bGAAODKbxJkYDmV8dE4oS9t9n900yw4P6qNm0eXI5NZ4OZPLzMkHtQOPDlXanRRrswDHJIts8C5RONSKKPSl+RnjngJQJUsmoqIjIC7OKEniUO8Ok8yLX71vGIQMct4IaCnNAMw2u9GgZs5026CC/Sm57opzkoDjMBvci4LEYuBEmKOls8aBraxAVlbp/NlCusSKRJUA0tfc/p6wWZLo2RZsZ+ngxbBbs8sz5TCJl5IlmSkgIbdEXueKB6Xfauhzep6tceqRUDmnxE7HaGItxG9Eg4WDopXLAGAf7isUnEiHY2GLhWtY2/PS2J2Imws4us+Lv+d++oQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G935sKdwoyZmqCDixcpLevFfaB/yby5AKU67IU7iNRw=;
 b=LddZ+Qp/8SwmvZaS5uIcQnOd6/edW7UtCL9e5S0/QtipRxry+/8XP5wUfShfj8dLp8SCBHxlCgPMNuZ3sGLml1YguHwEv6xVD9f3x9MfiCnzm8rQXEJN4u2huyBFj5pP50sHvgd9Yw05UqkoBfHFyeiIz0Ru3fYnjsXxWT4xMrs=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by SJ0PR10MB5646.namprd10.prod.outlook.com (2603:10b6:a03:3d0::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.38; Tue, 17 Oct
 2023 22:04:52 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d%5]) with mapi id 15.20.6886.038; Tue, 17 Oct 2023
 22:04:52 +0000
Message-ID: <50f80389-6075-406b-9bb8-e4472e1b2205@oracle.com>
Date:   Tue, 17 Oct 2023 23:04:46 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 17/19] iommu/amd: Access/Dirty bit support in IOPTEs
Content-Language: en-US
From:   Joao Martins <joao.m.martins@oracle.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        "Suthikulpanit, Suravee" <suravee.suthikulpanit@amd.com>
Cc:     Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, iommu@lists.linux.dev
References: <20230923012511.10379-1-joao.m.martins@oracle.com>
 <20230923012511.10379-18-joao.m.martins@oracle.com>
 <e6730de4-aac6-72e8-7f6a-f20bb9e4f026@amd.com>
 <37ba5a6d-b0e7-44d2-ab4b-22e97b24e5b8@oracle.com>
 <f359ffac-5f8e-4b8c-a624-6aeca4a20b8f@oracle.com>
 <20231017184928.GO3952@nvidia.com>
 <30c20c7f-c805-4208-9550-eaf2c9b21dad@oracle.com>
In-Reply-To: <30c20c7f-c805-4208-9550-eaf2c9b21dad@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO6P123CA0020.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:313::8) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|SJ0PR10MB5646:EE_
X-MS-Office365-Filtering-Correlation-Id: b8487723-5eab-4fca-a850-08dbcf5d1680
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: URoC1hTCDbiIrHLoOwgs527n9YjM76jAI8HsbHSBWPdYiIry+F81F0EiR+xPZu5OecmQY5mUDqHAdxqM3w20Git1WG6obfvnyJC3cL3QejsJ62Vcw4jDl9MO+hfP1j1rWdFHR5UCZ3kvR033wnLUCgPZ9uXVsWnjr8usemsTclermHTuhoMo3mRAcQldcftBibE5fUNspXjlkI4LYKSPphInk93otpD9RFI7NwKmjBoWbllRGi82+ySfQpgeU8Lsy+4hnlvudRh9qIoDjnnXpWPZJxw+eLURtJWpBF2YBr26ucXANRjqgdZ6k8zljMLcZnxuoTH/P8PvO2JoXZUBZxJ5FSrBsCGQUKn1XeYLkM7NK77oEAqBKK2DvCNOMuIpdOKkPSqTy5QIjLUuKf2ABHLh0mIos3QLM0j8Ha/gAiMJ9Iw8Jdk9GgP6gC/gaIXJ3G27gbSONcs0xc3Uh3XjJKNaYMfJLJlPXMdfM1HCC639dakf7Uqq9oL1qvf6BgcdF8UBvtKXlwVWnoPCrcs1EgE0TFsrj1tKZB7qcT4/9hsvU7TVF77u2Q4u4S2ZE76T4qz3y3o1Rwsv6+oE8tRXzQf009J9HZ3lsoCNqg77xDnc9Autuyj0YxGOJ9bpQbCXVdMDZkpr1DuHgC6m8gID7DO6O/NmzsIKU08gCEnf9yQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(366004)(136003)(396003)(376002)(346002)(230922051799003)(451199024)(64100799003)(1800799009)(186009)(66946007)(31686004)(6512007)(53546011)(6486002)(26005)(86362001)(38100700002)(36756003)(478600001)(6666004)(31696002)(2616005)(2906002)(8676002)(7416002)(54906003)(6506007)(4326008)(66556008)(41300700001)(66476007)(316002)(110136005)(5660300002)(8936002)(14143004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Mi9qMnIvNVZ3VHFzSVRtZ1dzc3M1aTNIQjdsVWdqdHY2ZElIVDEvZkYwdVk5?=
 =?utf-8?B?ZldTOHdkMFoxUm4vNGdMMmlkNDN1N3JGVHIxYk1GMEVza1VqdWFjQTI0RXpv?=
 =?utf-8?B?ZkxhUDl6bUgrbVUvazFPQi9uc0F3N2I4Qm5MOHlPYkczVnE0em5KWjQvZTNl?=
 =?utf-8?B?b2s5bWdDQ3RmMWd6RmJKckNHeHBtdmMwdTl6cXdOTnl6UGtDRVRtQWJLSFRO?=
 =?utf-8?B?bkpyOWdKRElSN202clozc3ltRlJXbGZkcWF1U1hZZ0k0aDRwM083VnNiaGtS?=
 =?utf-8?B?YWQzUHNNRWlqK01LTTcyQkRrcEd2Qy90dkwvbFhrTVQyK1Rpdm9SZ1NzRzQ3?=
 =?utf-8?B?bUlITDY5c2xBeVdvZnpONnF0bWJMVWdlQnFNeWQwYUJWRStLUHJpUklFUWVH?=
 =?utf-8?B?YlZadGJwS0ZHRVNPL2xsN3p5eEEveE03N3U4K1NXSThmc3c3L2hadWY0Q0xx?=
 =?utf-8?B?cmgrMmpRcUFvQnFsenJxekFmVkFwZWhlSThnUHVHTm94OXltUWJ4NzNOdGtU?=
 =?utf-8?B?ZFU4bkZlNEpGOUJwWHdIejRpV0hsTUZWME5idWZnbmU0NjBIbHlBR1FoejdO?=
 =?utf-8?B?TzNnTTQwTWg4N1hESmcvQmJNVzAxSFVKbGZvN3R0WjYxbCtxRzArL3dLWFEw?=
 =?utf-8?B?bTNFOFhpMmlKNXV5M3I2ZUphWWlkb0MxdWdBK3h1RjRsbnZhSVppbytjUEo2?=
 =?utf-8?B?U1NFQXROTkUveVlFZC96TXhuQW51M0xkY0U5TnFqMHlnU0IxZDhtNGpqZkFJ?=
 =?utf-8?B?OXlVSGYySHI1ZnNqZGkrVUozR09LcjhKTk8rdWNzTFYyTWdpSVZ5ck9wV0cy?=
 =?utf-8?B?ejFWMjdyT0M0SDkyZVVCcm5mbEdSWnpIR01CbjZiV1c5R204UXAySWViWXo1?=
 =?utf-8?B?Q3psdEVNb0FuS1hlMWNSNkh1ZnQxcWkvcWpwb04rNDdjSVYreTBEVUpnRDFu?=
 =?utf-8?B?eVdJV2pxOG9wVElNSmNxYk1ta1pOM3A5Rzk1elJQNXI2d3ZJWUtUaFVzT2Y3?=
 =?utf-8?B?L2Y5a3ZaVkk0UTFwVHdMVmdGRTI0OHFBQ1pTbGkvYnd2V3pTdE4rY1h5YjYr?=
 =?utf-8?B?ckJXN3p3cFZEb1pjRnlxY0Uxa2RHQUw5cFZoM1N5TkpzS0ZsUy9FMnpDQjd5?=
 =?utf-8?B?VnhpNjk5ZmRnRnFheDVkYU1wYlU2bVBTSG5qUG8yYlZKZ3hkZWtCSzVOaXJL?=
 =?utf-8?B?MjF5TlhOeW1wY0xLOVhpVnFJL3Fic0s1MkNUUjhGUzZUNGlzQmdWTG5oYllw?=
 =?utf-8?B?cjFoZlc4NkI4bHVkL1IvOXFYS3ZwdWdGTEtFS0tFUFQxNjNxOVhjdXZhekcy?=
 =?utf-8?B?S2NiMDdydXhUYllSTFJ0bWY5dlMzMy9YbTFqVlRHZWI0aHlQYW5QWGE1Z3Z0?=
 =?utf-8?B?Sk0rSFVzMDhYY2VVVWUzQURtZnY2ZFNUUHJvOFFGSFJTd1hOK1BnQXRXd0hT?=
 =?utf-8?B?bDd6dXc3ZUpwNy8xM3NUMUxnYndQaFFxUDBzT1RtY2tvbXZQUFFhVmxnSzdj?=
 =?utf-8?B?eHJQcllwUzlPeTBzTi9yblEyc2FlcTlNN2NSWE42RDRGWGdNRHJ5dUprVmdy?=
 =?utf-8?B?NlRXbUJQdW5tSmxYMVZ3VjNOT09BUzVya1BTVU1ZZnlWQklXQUJqK0NwTUd5?=
 =?utf-8?B?eFlBMFU0Yzk3QUFpdGFOUnpqb1VwZ0RXcEErSGRlQS91czJsMS9hbnJYVmZv?=
 =?utf-8?B?TzFtVnFxdEVGem95aDZMQlRXN2lOeW0zQ05xZ0V6RjJvVTQyUXV4WE9wTFdC?=
 =?utf-8?B?WXBuT3JMS1hQT2dRbiswMW5nVm1GWTduRGt6UFRLa3FadWNPMnJrQmpKKzFF?=
 =?utf-8?B?OW5pYU1KQTZhL2RXZldHMlcrSWgxVVlpMVpzb3J0TUhUTWIxcjlGT0ZEVFM1?=
 =?utf-8?B?cG9YOGdsOXdCRml3ZXhMRGpNNFdtZVhzWHpWdDBxNENIMDgxeHY4SFJtajVX?=
 =?utf-8?B?azJad0VoeS9EbG5iMWhFWHh5anp3bUpENnBQYUk2azNrOGpaR3FneWxZMUo0?=
 =?utf-8?B?d0phVllzd09DV1ZHdWpWUEdVYnF1UktuSUZkVjRrdE5FeEVvUE9FWVZXNEhS?=
 =?utf-8?B?R0ovRUpsU3RKcjdZRnJUMmEzckZtbjM0ZDhjejZDWVVkTXRmOFhNQXhEZjlF?=
 =?utf-8?B?dkpIUXg4cWRET1FDMHhsYVhOOGJXUEJ5TytkWlUyVE9MVVhlQXlsQXNzbTdE?=
 =?utf-8?B?cXc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?M0Z6WUN0ZGlHeVlaeERRRTJkQ0V5RlJHZ3NXeXcraFp6S0RPZUV2SzdDdHRn?=
 =?utf-8?B?Wlh1Qm5USXoxelZybnNwci9xQ25hb2hNbWV3bG5nU3JJM0xzYmpkQTRNdFQ1?=
 =?utf-8?B?aVc0Qk82bU1aeWVGemNFNTZZeFZhM2ZoUnh1RFhLazE0Ukc3dWI0MTRnVkM1?=
 =?utf-8?B?V1l3MldCZXU2a3RqaElveUFuRWVqcmx6b01BT0lCT1h3MGFLN0ZRa3hsaHlZ?=
 =?utf-8?B?dER4VkxEMXR6a0l2WG5vWUMzMHZGSDFDL2VDWVpwOE9ZQ1daWjJYWThmS090?=
 =?utf-8?B?TVFXeElwVlovMkFVMThhVS9SV0tBY0xITUNDenRaYW5YelUvNm5wQWNLMWpB?=
 =?utf-8?B?VE1BS3VvdGZKWGxOSmFsdmlZTUp1bEpwbzhrZ2grMkpQMy9lUUl2R3dJOUhN?=
 =?utf-8?B?SFRFT29CVXRES21ES2tSZXFVMTk5VGFmUWhocDZPM1pxUEZya0ZRVzBxTkZr?=
 =?utf-8?B?cS9YV1RlOEFPNWFTZnZ1cThER3dHZmZpSzJHUkxMODhlTGVKc2N1YUR5Rms2?=
 =?utf-8?B?TzRSQmVaUHZ3NVhsTzljb1dEWmlqelN6ajhFcmdIaUszQU1CcTIrSTdZaHl4?=
 =?utf-8?B?Ukwrc3N3djh4VldybG1nTmZKdVhJdmFMaHorcEFuTEYyZFpzRnp3Z1ZnQnk4?=
 =?utf-8?B?dWxobVR3U1hyWVlaTTJrN0FuYzl5d0l5TGZRN2o1YjYvNEtLa1RvSDJYYnhX?=
 =?utf-8?B?MG5WbFlhMkFLS01JSTNVcXZndm95VmExKzVHMVlJbUh3L3lEQWVicUNNTUdr?=
 =?utf-8?B?clZFbmFZTThoWUNMVU1UQ1YzNFNTWC8xcHl2TC92ZEU4R1M2dDdsOU12QWhZ?=
 =?utf-8?B?dXpDMlMvaXJhRWk1OFpYWXVzaVJQL29UV2hwVkUxTklTbTlpeWpwZ2RnbXht?=
 =?utf-8?B?Q01JMGdPaS9mWXowMytnY3IyUmNYMi9LZlpVZFFMNlFGRUhiSDFIbkx6bll4?=
 =?utf-8?B?dGVuOWJSQmlWV3FFVDFwN2h3Rmt4c0x3OG94QUxoSlh1bmVITThpOGxNazRG?=
 =?utf-8?B?UTgwRk9ORzcrVjZEQTdQeUJxZk5qSFB3L1pKY3RxdlZqRFBUMjFhRis0RFVM?=
 =?utf-8?B?TldRbk0xQkVrRFMybDVkYTJ1YWZma2lGaFRWYUlaeFIvdGROelVVcDVxYmJ6?=
 =?utf-8?B?MlpwRk1QVjczRU1rNXdPSm1ZSVRZcWtHbG00YWFpb1NSRXhocDlhaDNKc09j?=
 =?utf-8?B?NWNHODZQUlQxb1ZsY2hZZ0Z3SWN5SUJqY1ZhR2dOVjdzYjMwT2tENEk5aGY0?=
 =?utf-8?B?T3hCcFR3LzFKbXJBci96dktnQVZBSVNJK3VMK20xc2pVOVBMQjkzUnp1NTUx?=
 =?utf-8?B?YlIrektFdDk0VkV2WDBVTGZtdGowUnFaY01wcVhHQis2L3U3QXZQY0duZDEy?=
 =?utf-8?B?VFpWSjFxb00xT3Z1OEhDNnBTVjJrdTZuUS9La0t5UkIwREpEV3BTblJZMjBB?=
 =?utf-8?Q?gZeb+2Td?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8487723-5eab-4fca-a850-08dbcf5d1680
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2023 22:04:52.2374
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rZ6sd8dV7+jQ38c64dSNXqo6Nvewm8W6uHZScY9OJ6XPFnCrkZX3RGKlt6v6iIpIyo5xZvBvS1CBMQLMgn6vgNCAY/U6JoqLUzNtDKSy1zo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5646
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-17_06,2023-10-17_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 suspectscore=0
 mlxscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310170186
X-Proofpoint-GUID: VaC6qMBfc9jQ_0MCjZScVsk6xlmE8gCe
X-Proofpoint-ORIG-GUID: VaC6qMBfc9jQ_0MCjZScVsk6xlmE8gCe
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/10/2023 20:03, Joao Martins wrote:
> On 17/10/2023 19:49, Jason Gunthorpe wrote:
>> On Tue, Oct 17, 2023 at 07:32:31PM +0100, Joao Martins wrote:
>>
>>> Jason, how do we usually handle this cross trees? check_feature() doesn't exist
>>> in your tree, but it does in Joerg's tree; meanwhile
>>> check_feature_on_all_iommus() gets renamed to check_feature(). Should I need to
>>> go with it, do I rebase against linux-next? I have been assuming that your tree
>>> must compile; or worst-case different maintainer pull each other's trees.
>>
>> We didn't make any special preparation to speed this, so I would wait
>> till next cycle to take the AMD patches
>>
>> Thus we should look at the vt-d patches if this is to go in this
>> cycle.
>>
>>> Alternatively: I can check the counter directly to replicate the amd_iommu_efr
>>> check under the current helper I made (amd_iommu_hd_support) and then change it
>>> after the fact... That should lead to less dependencies?
>>
>> Or this
>>
> I think I'll go with this (once Suravee responds)
> 

Or just keep current code -- which is valid -- at this point and doesn't involve
replicating anything

>> We are fast running out of time though :)
> 
> Yeah, I know :( I am trying to get this out tomorrow
> 
> Still trying to get the AMD patches too, as that's the hardware I have been
> testing (and has more mass for external people to play around) and I also have a
> higher degree of confidence there.
> 
> 	Joao
