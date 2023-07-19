Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E912C75A1B4
	for <lists+kvm@lfdr.de>; Thu, 20 Jul 2023 00:20:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230008AbjGSWUU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jul 2023 18:20:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbjGSWUS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jul 2023 18:20:18 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE8571FDC;
        Wed, 19 Jul 2023 15:20:16 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36JFOp4M008954;
        Wed, 19 Jul 2023 22:20:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=LxB92oFlEnOstlUb2jCTCTIQ1W2TfTyUxTXyxU5tR6M=;
 b=fvypz8SwUZ6Z6irydXRuEBTnX9NHborn5HUs4sQL+CIVo8yMN7S+FN1RX3EwHNMD70rC
 WhnqWlwLzxRnRiv51pPK+J2DU0zQAtq1ot+hfVmtWF7q7zbDnjIWXzxJYND5cMaq9nHM
 KCXOifxmxM4ltavO3LNwi6ELmW4ElfwDaorG6iKd2dKDKM2lNePiSNJ6INB23CYn+N9V
 Tw1PC7EQ/nUa9/0HWzpabHZJyqSyqQTrriLr2gdqcC+wWXlweTxde1KM5J65vnXvoxi3
 hzJ/bqPDmijbPINf/UOMtRiiuPmoKRGsm5quJo+F3+qY5Hk8JWnWaliLYtileHdKGbhi Aw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3run780hw5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Jul 2023 22:20:10 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36JLmxPu023888;
        Wed, 19 Jul 2023 22:20:09 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2172.outbound.protection.outlook.com [104.47.59.172])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ruhw7v1wv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Jul 2023 22:20:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G8SuHAZ9FgZ1ut6/EShB3pk86CYJW1k0sWzbJ0S3IqF3X+GciOqlWTagLA7Zvwo4xJUD3Jo3ylcUtPaW70RmJAK2drSKBp6yyA2qxV1dKwIk7lMMpxLtieFl/57G/127vWm6wTpHsznueaE7GZeZrnO/XRKu592AY7Z8akjZDfS/IYtVqnvF4KYyVjhHZxDBYpNM1o2H6pbp37tgZMBtTP9X8PvbEAM78tK1U2e/gipD71eQrbCCLJfxXy2TN1DDFUw3AdZHOUZksLBBGw3iGxs4WCoDAj/hfYgdewPwTkJh+Mf9ZAjZh8eIq9EWnwjAxzx8NAm8g/mdDnR9iYxpow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LxB92oFlEnOstlUb2jCTCTIQ1W2TfTyUxTXyxU5tR6M=;
 b=YEMd5NJUTo6+n0m4QYgqjBf3Ueo0x8NY1upLgsJh58kVjwyatZlFARYB3qtbaBrpTf78O7VcdCwy2qr4XWGQIhbgoe2hB2VjUsA/zd066ttH248+l93AkIGu2amLBLfiTplT8xXiQaQVpOchPI/1gDh11Bdh/Y2K26QVY2vIRcgwk8l/Xq2VLoB6eMO5N/gZXHAyyXNA0qsFATnDfaQqsA8uoGzcLQBnIVIrlArvUQ6cKG6FApu7XByX/8F3LUnissqoFjciP8dUKB4Vj6VrFLJYjUpaclJKhzgvCAe1kJQDcECeQX3+5zSryyDX9n8esSjqNnnUJVosNuaDIcqzaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LxB92oFlEnOstlUb2jCTCTIQ1W2TfTyUxTXyxU5tR6M=;
 b=IBIg9LPMRS2DTwmSa8KpFoyHr9XO1yY1SQxyoHiJ8p5m/RxdJ5KT1FiubvfXa6NsTyR1Y27R8qTKsk36PWq6MAlbkSdWZad1DI4wKW/4jJl1D2F2lONF1o/o3300a0injjjFRIJ1CWkaInf+EC1AdVLc7AbjPUyu9IVwx8nho4w=
Received: from MW4PR10MB6535.namprd10.prod.outlook.com (2603:10b6:303:225::12)
 by CO1PR10MB4722.namprd10.prod.outlook.com (2603:10b6:303:9e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.24; Wed, 19 Jul
 2023 22:20:06 +0000
Received: from MW4PR10MB6535.namprd10.prod.outlook.com
 ([fe80::a11b:61fb:cdea:424a]) by MW4PR10MB6535.namprd10.prod.outlook.com
 ([fe80::a11b:61fb:cdea:424a%5]) with mapi id 15.20.6588.031; Wed, 19 Jul 2023
 22:20:06 +0000
Message-ID: <1fdf73cb-f23e-0c34-f95f-f1bac74332da@oracle.com>
Date:   Wed, 19 Jul 2023 15:20:03 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH] vdpa: reject F_ENABLE_AFTER_DRIVER_OK if backend does not
 support it
Content-Language: en-US
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Shannon Nelson <shannon.nelson@amd.com>
Cc:     kvm@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Eugenio Perez Martin <eperezma@redhat.com>
References: <20230703142218.362549-1-eperezma@redhat.com>
 <20230703105022-mutt-send-email-mst@kernel.org>
 <CAJaqyWf2F_yBLBjj1RiPeJ92_zfq8BSMz8Pak2Vg6QinN8jS1Q@mail.gmail.com>
 <20230704063646-mutt-send-email-mst@kernel.org>
 <CAJaqyWfdPpkD5pY4tfzQdOscLBcrDBhBqzWjMbY_ZKsoyiqGdA@mail.gmail.com>
 <20230704114159-mutt-send-email-mst@kernel.org>
 <CACGkMEtWjOMtsbgQ2sx=e1BkuRSyDmVfXDccCm-QSiSbacQyCA@mail.gmail.com>
 <CAJaqyWd0QC6x9WHBT0x9beZyC8ZrF2y=d9HvmT0+05RtGc8_og@mail.gmail.com>
 <eff34828-545b-956b-f400-89b585706fe4@amd.com>
 <20230706020603-mutt-send-email-mst@kernel.org>
From:   Si-Wei Liu <si-wei.liu@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20230706020603-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA9PR11CA0014.namprd11.prod.outlook.com
 (2603:10b6:806:6e::19) To MW4PR10MB6535.namprd10.prod.outlook.com
 (2603:10b6:303:225::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW4PR10MB6535:EE_|CO1PR10MB4722:EE_
X-MS-Office365-Filtering-Correlation-Id: 7d425658-0544-44e1-ba90-08db88a64e8c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nP+33mMYMaxmqFo+WsxvRwmbGQj/Gasq/4z8zNP+7mINQl5PW9YVazM5ikN5+Q/+EdJIzz4dUAg4xQjHSvbfPeZBYmNxQ1OBfw5CLpLhIJTikwexuMRbP+8CIqyGMYG+ZfBGz4LOBqwa465DbgQxZ2qoO1lqKpSkez7gY/IkgBBp88I5MGCz7/BOTNmoh0dcRKBVnfNMh8sWcHXZ7xVc+Lh2+jw9sRly92Tz8cNMfXgbVuV2CHyUpFS/pUTL12GmZ91kJOeLTJ2Y1jrKSmJFKVU5P7Wuai5dQZyYLxQM/SFERB7Y4j9iePRNJJzX93D9b+sFzMUnwWqtrdEpz90LvMr8jKbHz2oB3jcHJN22j4Ia+SrAYmWy4DIKfxcnGSXfPQlMufwltQp5oso682Awxrwz8TxRqLHTgc/LFHXszhh9Lt4KNXR1jJwkG/ZpCbYysRPZuf23HYOs4bbXtBL3OSKWdhY6kAC1uU5Nn6eFSX8VVAPv/qEk0Yjrzlzh5fZ5fbxS/Iy2T+fdXnSgxXVWrLjlXm6XDlWMQGVwGSrnW/OhiliRFGMvHxTzyD9W+GriemDKLjtO8UC8OQ8B3BFECQzV3G1DhH4vG23auTkrHtRKxSwTkjeQNEFg986IrXRVYSlsPFqkzZRTexolO3TB/LR6HN9abKCGboJwJDGsYov4JOPJBDsSDfyb7XHZH6v0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR10MB6535.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(376002)(396003)(136003)(346002)(39860400002)(451199021)(53546011)(36756003)(478600001)(110136005)(66899021)(6666004)(6512007)(6486002)(966005)(36916002)(186003)(26005)(6506007)(86362001)(31696002)(41300700001)(66946007)(4326008)(316002)(66556008)(66476007)(31686004)(8936002)(8676002)(38100700002)(5660300002)(2616005)(66574015)(2906002)(84970400001)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WTF6by9uOFBYMHdneW10cE1ZVTh5eUVnVjI3TTc1bG9CVUZuajNHZndLa29t?=
 =?utf-8?B?UGZRSnJrMnhZbmxKaHR3cjJKTzNPTmsyZjFuVkxUWEt1ajVGRlRVOWpmeVZi?=
 =?utf-8?B?eFBUR2ZnRk5SWjJvQTVYRlduNWlnN2FuTFVOQTAvUDVCRXpPbFNaaGxwcDA3?=
 =?utf-8?B?VEd1NnN0eEZJR1dqeERoNkQ2UlNVTGl0MjVVSlR3YzUzNEhYcjVrU2NPVjlS?=
 =?utf-8?B?a3BwZGlrREEzak0weEtmd2JRbm01a2hDbHFMNlI2aThBcTNzdGpUNjNJOGpI?=
 =?utf-8?B?YmRtUnFDdy8vcWJjSmJ1dGhQV0JkcE1kQ0JkWC8wVWVKZzU3TENVelBiTDNW?=
 =?utf-8?B?L25rc2NuZXFhaEkyZmRJdnlLTFZUL3BiREpwUy9ocVF0MDBObVNoZUp2ZVR4?=
 =?utf-8?B?bUs3d3pSV01vemphVUx6VTVaMWpKK3hBU3JLSjZyTkpUVkFmZ25OZXArNitI?=
 =?utf-8?B?QTBXTVQxcWhqV2Jjczk3T1BzRzdQY3o2aXZzbGx0Qk9NZFFwVzQxaEZIT3dk?=
 =?utf-8?B?eDYrMnR5TTdkOHphWm83cG9pNUVmQlBNSDM4SG8xV3F4dmpJUHN2SVZzNHhL?=
 =?utf-8?B?N0IwM3d5NkxNWC96ZVJJTjlzUnNaNnFCTE9odHV3WTlCaEhkR1JVdkN4alUw?=
 =?utf-8?B?TC8wOFk0Vm1ZWVdSdkF1NkNPYnZFc1RoWGNRUVhLRDFDalU3dlFHalB4OCt5?=
 =?utf-8?B?WGVTTm1lRzJvVHgvRVFRbXhvdWJpV3BzT2htNXhGeStLL29LZnlFRkx6YlBD?=
 =?utf-8?B?eUZ6S0V4NXpYTXo1ODZmd1dSSEE4K2dsSHUzaVhyTmRLb1RDZHRZemxJMW9p?=
 =?utf-8?B?UWdFdVpZTkM3SUVOZjRkbzlVL3cyamdhTU5uU2pvRFlNa2xpQ0pIWGJXRFRS?=
 =?utf-8?B?MFNHVFNtbjZQcktpWkx4clhTZWk5NmhYRGdlSmpHWCthbjE1VzQ2TXpsLzRF?=
 =?utf-8?B?WElNUWxkVHc5SFN3bnNRTk5zRXlyS09uNXEzdXV4NFBuZ0Z4cC9PZnRrdmc5?=
 =?utf-8?B?aHdJeSttZWNvMHpMYXoxQ1Z0U2FlZG1Tc2MzOXJkZ0lINmlBWEx6TkgrNEZn?=
 =?utf-8?B?SnRtZS9oL3NGWDRPWG5JcHArS2R4Vy9udy9tb2ZDNm5BazBwZnFMTjdGTHlZ?=
 =?utf-8?B?VDZtTGRQTEJnd2I2YkdSVHN1RVBsVEhMZGUwelU0M3htRHdHTE5waHJVYUN6?=
 =?utf-8?B?QjJiRktIL0hzTE8xMlA4V29UWHRpdmQ2QjFvcndQZyswdFlYRjArRU5YNE5R?=
 =?utf-8?B?dC9pY2VuSVhUNzh6OThpRDJNQ0VBaWZnRXg4ZFQ3QlR6KzRzU2hBWXZ4M2tJ?=
 =?utf-8?B?ZnNoeThmNVBPUnFjUkJvSFZKT0ljL0hQR0FyVTFCRW80K2k2cSt6YkRrQUl6?=
 =?utf-8?B?R1M5ZFJSWWVZZHpVdFF1RDhaVXg3WGI5SHZ3bURyaFA3MTVzdjdPQVArcWtQ?=
 =?utf-8?B?dFVxcXE3QUNRZ0dYRkhod3NZWjhJbWsvdG1WMi9kMGg4UVdkL2l3NWliMzI2?=
 =?utf-8?B?K0tqUzZkOFF4WHhiVCtVM2x6QTl0L3BTMnRJZDNxeFNIaWM5cGoxbmZuYlBz?=
 =?utf-8?B?Mklwa1o2cmZzd2NTdmtQV2YxNldkTkRaN09PYXcxTGkzRDh5OHQrY1Q3SmhW?=
 =?utf-8?B?NGtPOVBYZzZ2MFlXUUNTZXFwWEQvWThWV25YNDdEeHI4Q0xvaGpaNDBKNnY1?=
 =?utf-8?B?REJ5UFNwVEZGbExRRzlyNkRBOC9TWUxFOTlHcTByWXpBZlVORVdBcmhYbE5a?=
 =?utf-8?B?SGtqMzhEdXRuVmgzTnZJZTZVeHUva09TWFB1SnVxcWNtWHppWFJva1U1dTd1?=
 =?utf-8?B?U2RKcm03T3hmclRWOGE2RVBpcnpzeVQ2dkx4dEpobnJ0RXdoT3cwSndIWjRy?=
 =?utf-8?B?NHZDYzlxTXBDT2dQMTU0cW5QaTF6NDQvUXNTQVZpVEZQbThtUFhBbEg3VU5l?=
 =?utf-8?B?SGJqcGlHRHphUjFKU3JuRzJjVUdLa3I2aFgxRlczNzBKUDVDVWtKMmJOZksx?=
 =?utf-8?B?ZzBBSTlEYnFUQkhuWXhkeUw0MXhJVzFYdjZRdDIyQnZ3bzk3ajd1UEFYaG5r?=
 =?utf-8?B?ODk1eWQ5ZnhqLzBtOGVha2R2Snd0UkVoMXk4RWYzWXNvZ1gySjJrUVkvK1FD?=
 =?utf-8?Q?JgmozVpzrN6R2cFjXkjnbhki+?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: V/d1MyE72PcyFYyvWYe5PzGQ3ixiNsFe/dCpKjbzXOojzBpJpet3rird4DiR36X5BWhWPSXq9WiPBEEw1bL8J1l+q2OAskdw2D9F5enC66ugFNmCNMA8XcZHkCu30NzOMbeKn7zlibbFPz5WQT3z4UbgRklTIQC2pg6GVhQ3YYA2OpY4CeXSXVimKETYqzarIjaCKpN4DJiMBTiTBmdN2jibhkTJ6I3M1NizhPAB0mFNBPNSIxfKfE3AcECfMLSo29c/Svo+W/WpFUIR2sbk7wuXTiFFdGhA7u333Mhve6HOICaM3rdQnE0x0IMG5kTUoRQ1FscTq6nxLaEfq8Zl8V8VlFoDZ7WSUeWUpO0RhA7wIlJslF+zpre6DZFWrzT1bisrZJMmN9Utan0kIwVxeBPRtBSd0uERic8RPsTuZTTMzlp9FZXZaiANsKcejrsp7dEb2RBaSWytPFiFE7jX3N3ebc2MjEh+pVQJUnYvERiDWC83bn418Pq580D072fPm/mA2pMDqS4/mDGMHkrpk1ljL68qUohpQgi7cpO58GUaHEjJRoh2DAXBYA+pwEKWLj+4WEM6zVMGz4LT8NnGUojACbQGLCbmogwZ7NthIrq6RIPEN8bBozKajIvPPzuPw4W4HS3gwnV0hNx3xMt7/SNdQrXNdMfEn+xVh6VN2zxKnRLaFDir2pMV9UjMWVf3Fr7+15HBLu91tbQ+8nfW+8m0tOAn3Lqw++JYxsBPLbrFzpr3z6BLweSRjko4oQckO9ZUKy4XtOgz3P6eRSqnBoazvt9GH5Ncmeu8ra1WcsFtFFUAvhgs+nG9tRWd2o83F8t3VnD2xmWI7YorXoNIdrTMEsmhv1G3L0pS0pVZnue1UDh4GvcHn4DR1HNNa086
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d425658-0544-44e1-ba90-08db88a64e8c
X-MS-Exchange-CrossTenant-AuthSource: MW4PR10MB6535.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2023 22:20:06.8827
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0mSGvvdMfSRzd6BSFxnybB2pDTV5RAQczAClxFAzlogkq7evo5XH3BnH+l5aQ70OP/VAHgXgdbUSntUe+zGRAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4722
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-19_16,2023-07-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0 mlxscore=0
 bulkscore=0 spamscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307190201
X-Proofpoint-GUID: TXPq1pf1swUxewoNCWLAnV5US7xgdc-g
X-Proofpoint-ORIG-GUID: TXPq1pf1swUxewoNCWLAnV5US7xgdc-g
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7/5/2023 11:07 PM, Michael S. Tsirkin wrote:
> On Wed, Jul 05, 2023 at 05:07:11PM -0700, Shannon Nelson wrote:
>> On 7/5/23 11:27 AM, Eugenio Perez Martin wrote:
>>> On Wed, Jul 5, 2023 at 9:50 AM Jason Wang <jasowang@redhat.com> wrote:
>>>> On Tue, Jul 4, 2023 at 11:45 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>>>>> On Tue, Jul 04, 2023 at 01:36:11PM +0200, Eugenio Perez Martin wrote:
>>>>>> On Tue, Jul 4, 2023 at 12:38 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>>>>>>> On Tue, Jul 04, 2023 at 12:25:32PM +0200, Eugenio Perez Martin wrote:
>>>>>>>> On Mon, Jul 3, 2023 at 4:52 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>>>>>>>>> On Mon, Jul 03, 2023 at 04:22:18PM +0200, Eugenio Pérez wrote:
>>>>>>>>>> With the current code it is accepted as long as userland send it.
>>>>>>>>>>
>>>>>>>>>> Although userland should not set a feature flag that has not been
>>>>>>>>>> offered to it with VHOST_GET_BACKEND_FEATURES, the current code will not
>>>>>>>>>> complain for it.
>>>>>>>>>>
>>>>>>>>>> Since there is no specific reason for any parent to reject that backend
>>>>>>>>>> feature bit when it has been proposed, let's control it at vdpa frontend
>>>>>>>>>> level. Future patches may move this control to the parent driver.
>>>>>>>>>>
>>>>>>>>>> Fixes: 967800d2d52e ("vdpa: accept VHOST_BACKEND_F_ENABLE_AFTER_DRIVER_OK backend feature")
>>>>>>>>>> Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
>>>>>>>>> Please do send v3. And again, I don't want to send "after driver ok" hack
>>>>>>>>> upstream at all, I merged it in next just to give it some testing.
>>>>>>>>> We want RING_ACCESS_AFTER_KICK or some such.
>>>>>>>>>
>>>>>>>> Current devices do not support that semantic.
>>>>>>> Which devices specifically access the ring after DRIVER_OK but before
>>>>>>> a kick?
>> The PDS vdpa device can deal with a call to .set_vq_ready after DRIVER_OK is
>> set.  And I'm told that our VQ activity should start without a kick.
>>
>> Our vdpa device FW doesn't currently have support for VIRTIO_F_RING_RESET,
>> but I believe it could be added without too much trouble.
>>
>> sln
>>
> OK it seems clear at least in the current version pds needs
> VHOST_BACKEND_F_ENABLE_AFTER_DRIVER_OK.
> However can we also code up the RING_RESET path as the default?
What's the rationale of making RING_RESET path the default? Noted this 
is on a performance critical path (for live migration downtime), did we 
ever get consensus from every or most hardware vendors that RING_RESET 
has lower cost in terms of latency overall than ENABLE_AFTER_DRIVER_OK? 
I think (RING)RESET in general falls on the slow path for hardware, 
while I assume either RING_RESET or ENABLE_AFTER_DRIVER_OK doesn't 
matters much on software backed vdpa e.g. vp_vdpa. Maybe should make 
ENABLE_AFTER_DRIVER_OK as the default?

-Siwei

> Then down the road vendors can choose what to do.
>
>
>
>
>
>>>>>> Previous versions of the QEMU LM series did a spurious kick to start
>>>>>> traffic at the LM destination [1]. When it was proposed, that spurious
>>>>>> kick was removed from the series because to check for descriptors
>>>>>> after driver_ok, even without a kick, was considered work of the
>>>>>> parent driver.
>>>>>>
>>>>>> I'm ok to go back to this spurious kick, but I'm not sure if the hw
>>>>>> will read the ring before the kick actually. I can ask.
>>>>>>
>>>>>> Thanks!
>>>>>>
>>>>>> [1] https://lists.nongnu.org/archive/html/qemu-devel/2023-01/msg02775.html
>>>>> Let's find out. We need to check for ENABLE_AFTER_DRIVER_OK too, no?
>>>> My understanding is [1] assuming ACCESS_AFTER_KICK. This seems
>>>> sub-optimal than assuming ENABLE_AFTER_DRIVER_OK.
>>>>
>>>> But this reminds me one thing, as the thread is going too long, I
>>>> wonder if we simply assume ENABLE_AFTER_DRIVER_OK if RING_RESET is
>>>> supported?
>>>>
>>> The problem with that is that the device needs to support all
>>> RING_RESET, like to be able to change vq address etc after DRIVER_OK.
>>> Not all HW support it.
>>>
>>> We just need the subset of having the dataplane freezed until all CVQ
>>> commands have been consumed. I'm sure current vDPA code already
>>> supports it in some devices, like MLX and PSD.
>>>
>>> Thanks!
>>>
>>>> Thanks
>>>>
>>>>>
>>>>>
>>>>>>>> My plan was to convert
>>>>>>>> it in vp_vdpa if needed, and reuse the current vdpa ops. Sorry if I
>>>>>>>> was not explicit enough.
>>>>>>>>
>>>>>>>> The only solution I can see to that is to trap & emulate in the vdpa
>>>>>>>> (parent?) driver, as talked in virtio-comment. But that complicates
>>>>>>>> the architecture:
>>>>>>>> * Offer VHOST_BACKEND_F_RING_ACCESS_AFTER_KICK
>>>>>>>> * Store vq enable state separately, at
>>>>>>>> vdpa->config->set_vq_ready(true), but not transmit that enable to hw
>>>>>>>> * Store the doorbell state separately, but do not configure it to the
>>>>>>>> device directly.
>>>>>>>>
>>>>>>>> But how to recover if the device cannot configure them at kick time,
>>>>>>>> for example?
>>>>>>>>
>>>>>>>> Maybe we can just fail if the parent driver does not support enabling
>>>>>>>> the vq after DRIVER_OK? That way no new feature flag is needed.
>>>>>>>>
>>>>>>>> Thanks!
>>>>>>>>
>>>>>>>>>> ---
>>>>>>>>>> Sent with Fixes: tag pointing to git.kernel.org/pub/scm/linux/kernel/git/mst
>>>>>>>>>> commit. Please let me know if I should send a v3 of [1] instead.
>>>>>>>>>>
>>>>>>>>>> [1] https://lore.kernel.org/lkml/20230609121244-mutt-send-email-mst@kernel.org/T/
>>>>>>>>>> ---
>>>>>>>>>>    drivers/vhost/vdpa.c | 7 +++++--
>>>>>>>>>>    1 file changed, 5 insertions(+), 2 deletions(-)
>>>>>>>>>>
>>>>>>>>>> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
>>>>>>>>>> index e1abf29fed5b..a7e554352351 100644
>>>>>>>>>> --- a/drivers/vhost/vdpa.c
>>>>>>>>>> +++ b/drivers/vhost/vdpa.c
>>>>>>>>>> @@ -681,18 +681,21 @@ static long vhost_vdpa_unlocked_ioctl(struct file *filep,
>>>>>>>>>>    {
>>>>>>>>>>         struct vhost_vdpa *v = filep->private_data;
>>>>>>>>>>         struct vhost_dev *d = &v->vdev;
>>>>>>>>>> +     const struct vdpa_config_ops *ops = v->vdpa->config;
>>>>>>>>>>         void __user *argp = (void __user *)arg;
>>>>>>>>>>         u64 __user *featurep = argp;
>>>>>>>>>> -     u64 features;
>>>>>>>>>> +     u64 features, parent_features = 0;
>>>>>>>>>>         long r = 0;
>>>>>>>>>>
>>>>>>>>>>         if (cmd == VHOST_SET_BACKEND_FEATURES) {
>>>>>>>>>>                 if (copy_from_user(&features, featurep, sizeof(features)))
>>>>>>>>>>                         return -EFAULT;
>>>>>>>>>> +             if (ops->get_backend_features)
>>>>>>>>>> +                     parent_features = ops->get_backend_features(v->vdpa);
>>>>>>>>>>                 if (features & ~(VHOST_VDPA_BACKEND_FEATURES |
>>>>>>>>>>                                  BIT_ULL(VHOST_BACKEND_F_SUSPEND) |
>>>>>>>>>>                                  BIT_ULL(VHOST_BACKEND_F_RESUME) |
>>>>>>>>>> -                              BIT_ULL(VHOST_BACKEND_F_ENABLE_AFTER_DRIVER_OK)))
>>>>>>>>>> +                              parent_features))
>>>>>>>>>>                         return -EOPNOTSUPP;
>>>>>>>>>>                 if ((features & BIT_ULL(VHOST_BACKEND_F_SUSPEND)) &&
>>>>>>>>>>                      !vhost_vdpa_can_suspend(v))
>>>>>>>>>> --
>>>>>>>>>> 2.39.3
> _______________________________________________
> Virtualization mailing list
> Virtualization@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/virtualization

