Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC51F7D86DB
	for <lists+kvm@lfdr.de>; Thu, 26 Oct 2023 18:39:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345135AbjJZQjz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Oct 2023 12:39:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231180AbjJZQjx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Oct 2023 12:39:53 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 213AD1AD
        for <kvm@vger.kernel.org>; Thu, 26 Oct 2023 09:39:48 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39QDim3N028746;
        Thu, 26 Oct 2023 16:39:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=IDW6ih7zn8oYWpIpcrW5tQGovSyuqtkkp1tz4Ft8RBk=;
 b=zyhah0pG1+hWnxJv9LLOZlCRHvz9gU12RV6ACRHcXEjlSXXflhN9BNnjbfG70D5bf6g3
 qKl0gPTaduTGa3Zaznc9ZXAUhK7OJcdBI3FghXwY/uHCcCbAsE2A5d6Rg67MvZ4YFb4r
 c9XuEdphe+I0dGm+2oQPCqL/pZifFkcZczI93VC+rsLT/Xft6qH/Oyi97dh8RXyDMXIp
 zkUDTJ7y/nk3ogXox3BEP+lqfkDcaOC/mAIKcDlmlMEq/47c+BpFWr5tDpzbW4VEtYDE
 Xc2gh35M4HwfiaCfaoDaQaFMQ5ImLWzp5QYmJeTG2tW/uaeAM+FkmfJobUznokaPnVNo BQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tv581ugg3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 Oct 2023 16:39:28 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39QGYBZx001631;
        Thu, 26 Oct 2023 16:39:27 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3tv53exps2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 Oct 2023 16:39:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SOVFqyPUvIRVDaFYmDKhcVIHWycGdnCiS5E+R51ztt+BbDHLEy0KVJDdJSFAc2aijg/fimHHK0rUN8XdZq+TCl8xwTntERhV/EqvirrUgEDQvDkyl4uQemfOmMc0n6i6UjZoXll2YznXufl4k0eG+UdtOSAEcz56NO0vefJXlfivX5xf/cMvYuftGm4lrJMAps/wL8eL2lMBZm8OWBARGbLI/JeTH5zj5iLu0RkP7dz5E7d+8AEXYIAeB/VRfUC8aPEjGsIiAia/3ws5/GweHbaGj82pfzU9SQth5118tvy7QUAm9w1t/A1Mr0MMn93qzZ7H828NRzhu5Mq986mcuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IDW6ih7zn8oYWpIpcrW5tQGovSyuqtkkp1tz4Ft8RBk=;
 b=nN9hdvxxr4DLK7uRC0Z+6Oo7FZynpUjsJRxUaJJe59e/nX0zG9l485gE55WzQYGCRZjp0u7PB0m1mXi0eOVsvM5djsHxwB8HpQPE1HViaXR5XHj1zIZ2Y8ah0VedqLs7jS5R7MArlfJNNq+cmMJUmoLhdVCAUSG/EjvHqt6Q5YAGi2vtf9D/wPrH/ApWGgSiNdByBHjeaRQYISljbSFPMj0qqXXMOXD6lVm9SEGlurqsBdEAba9Bm4/ihBFmeGkt7IOHKrzm8r2GiFU/APOQ/fRufZxSG7CZXxgLpvdMVd6OT4cMZDMJV0FKotiStQ7L10md+f+0oO8c07CtBuaoLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IDW6ih7zn8oYWpIpcrW5tQGovSyuqtkkp1tz4Ft8RBk=;
 b=iaVnrXXF/Y0ujYVyAS3opLMrJf/WS+XiG1imHI3FC/FfNB1qiBwAl79ZuPJukPXZnHCtq5ZEt9UWBjgqvIGh65g8blEWeYQnNwD5qyZPl86dpBBb9bkH2r9jDU7k4iRNOOcnotaI5R8Bh9DbFqCvB4GmjxoBPwZOue1tpxJsZ3c=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by BL3PR10MB6235.namprd10.prod.outlook.com (2603:10b6:208:38e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.19; Thu, 26 Oct
 2023 16:39:23 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::afac:25ec:c0ba:643]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::afac:25ec:c0ba:643%4]) with mapi id 15.20.6933.019; Thu, 26 Oct 2023
 16:39:23 +0000
Message-ID: <b6b24f07-e63b-cb07-ab74-f9a178bde91f@oracle.com>
Date:   Thu, 26 Oct 2023 09:39:24 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH] target/i386/monitor: synchronize cpu before printing
 lapic state
To:     David Woodhouse <dwmw2@infradead.org>,
        qemu-devel <qemu-devel@nongnu.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        kvm <kvm@vger.kernel.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        Thomas Huth <thuth@redhat.com>
References: <870c998c450ba7e2bc2a72c12066f1af75e507d0.camel@infradead.org>
Content-Language: en-US
From:   Dongli Zhang <dongli.zhang@oracle.com>
In-Reply-To: <870c998c450ba7e2bc2a72c12066f1af75e507d0.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR05CA0022.namprd05.prod.outlook.com
 (2603:10b6:a03:254::27) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB2663:EE_|BL3PR10MB6235:EE_
X-MS-Office365-Filtering-Correlation-Id: 5c5ca617-fb21-410b-3160-08dbd6421c35
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GSIPu7VO3S8ovBgZ5udN87ENiB4HohLSdKUkH/cY76hhqy14OvxhNPuoQq4xUcv2Ts2ghwWuOSrl/rNc/ViW7V4PiLAbjlHG0ftYngHS/zY6gD2LuDb0KaiIIOam2MMVEKE/aZoqCBegBVPwj1BkvDWAArF9pBCr+uoJxh1Yix7vNe0pJpfz5OB15RXv/pPyN/rO2CqGjQbOTjWk0SxM3f5sEgFF/l9nkW/AjgTVRpeuOHi5jDdrDODkiV+6xiVNUdXWZnnRHE+bKMmdWu1m5ScKJ1Y36laGunp53OM8Un6pLTTOoVncOpvIffNT9ZNRddIBDv2OX9MX5xmMsuzEcDZybZf/9GspMg3EIyxMjZY4NoBUb+i9VwS1qzd41T6UBkHvmLntk6taGKn4MIQ+C/8TOmhm95HaeiZmwbXQAkjrP0crhqW7Y4v1a2kJH4wztJPl8trsvsFbJoHwFaHu00zz32U7JTdr/V8Aq4D7r6YKoCbwdOxVirkXAYnU09dtPNxOQESm6ZPgMfxLw8aTzxulDbvLbNRZiNgIVyTYhJhsGPI6bR850NXIhUTXw5hddDwYXBwT3JtUX8xE3bSh+/YBF9psckgES+8DyQAekyMmXmlK9DRWGDNznmLkYqYHgoQsjWwOHYIoC/Yz3YnFXu90ureOe/fqi03h+/63UkJFN3dlrX5ZiamEaAl1J8ri
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(376002)(136003)(346002)(366004)(396003)(230922051799003)(1800799009)(451199024)(64100799003)(186009)(66476007)(2906002)(5660300002)(31686004)(41300700001)(44832011)(4326008)(8676002)(8936002)(2616005)(38100700002)(66946007)(66556008)(36756003)(54906003)(316002)(53546011)(26005)(86362001)(31696002)(6506007)(6512007)(110136005)(6486002)(966005)(478600001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WGtmK3o3a2lHaHFBWThUREZjZFZ3dFR3SUw3YlZTZSszdWZoQ0VMWFFKdFlG?=
 =?utf-8?B?eVozNjRYcVR3OTVOMGJxUWV6ckQxTjNkYkNFODRRdGZEdHU3dzIxSHZ5bXpJ?=
 =?utf-8?B?bHhTL2pIRDE4ZkJuOFgwWXpiN1VudlQwZWhETldTMlBJWVh1aEFwc2piNnVO?=
 =?utf-8?B?d1Z2eUwwOWRPQ3h4SDJkWGhCWmJ4QkpkamRCbjlxOXo1bjdpbkpCdEF5Z3M5?=
 =?utf-8?B?UFdIUkw1RlB4RE1IR3loWDRmL3h0cGdPaG14WWpBbGg3Ui9qZWdnaXRCb1FQ?=
 =?utf-8?B?RVNiemtjL0V3c0hLU3hWSUpoQjBKd3RyMHMxS1JwcVRPTVozVUVEN0YyWHFl?=
 =?utf-8?B?Z0VpblNqZldxY2hjOHc4Y0c5aVpTejNjNHZkTlZENGlmRmRYbmUzbmFZMjdU?=
 =?utf-8?B?eE5DYmlUSVJuNXBMRUIyaXRUajVnRXNyNUxLY1JDYTd3KzE5MWNvWm9WdHo0?=
 =?utf-8?B?am1JM2x3Z253SVl5TjFsbVk1Y2pLencxSE5NS2dyK3dXQ0NZZ0lsNXhqMTJB?=
 =?utf-8?B?RWRxVVBqd09Ma2tYTDErck9WS1UyVDg5V1AvQjBuT1ZJZXFiWk1VQmhzOE5G?=
 =?utf-8?B?WnovL1M3aC9qRmlTbGJZOFBsSjlJVEhnTVFTR1dqWURneWVXajhNKy8vSnE1?=
 =?utf-8?B?TmU5MExHbWhOK0FXMER2di9BQ1ZpTU0yVEIwai9IRFFGd0pFL3o3cXkyMWl0?=
 =?utf-8?B?dy9PblFnK0dZTUw3R0tDRUZPVmdBdjI0emEwS25MZTZOdVlydmYxU0NHY2ZM?=
 =?utf-8?B?OGNVYWRZYnFIWDZsVjBjQkNVYjdMTTliZE9nQmtUdzM4K1Bna3hyOGI0Mi84?=
 =?utf-8?B?ZTRVSkE2QTdBQmx2NWhZSkJZRWkwNWxHQ3FOc3I0eWRpaUlSbHgxSFgxUnZa?=
 =?utf-8?B?d1YreXdMNndDY3dacElWKzIrYzFSNTBTRWZuRmVhSWZUNmhBRG9WYWoycU1X?=
 =?utf-8?B?NlJFWkxxdXp6bkdFSUtJOHluQXlWSXFPVHRRNkx2bXlBNmYyM1lWV0kvRDdT?=
 =?utf-8?B?bHJlWi9UZmFzZlVHSUtOa3VsaGlMeXZhWmxnWVJ5Y0loc0NwQUNhUDlBZUli?=
 =?utf-8?B?UExZT3JUV0M4REZvOGVIZytielc2NWxURVBCd2pHa0xYUlRXbDgzbXpCY0pK?=
 =?utf-8?B?dW5yR1BER2ZjOTdMWUcwekxja2dNenY1RUVKTzNCa24xMG1vREJ6bzdWdHVM?=
 =?utf-8?B?YnVvZHROeXlXTmxVUFo1MmcwK0RIMWRpZTlGZERQa1lQTTJqQUNOT0xjQzlP?=
 =?utf-8?B?NWZNRDNNemdpaG8yZ012NlV1SGE5RkhuN0lIQVYyMUM3QkFyV3owVURTYTRO?=
 =?utf-8?B?Z3Y1dExWYTYzRXhZM2RFcHJXempuTWFrcXQwMG1jV2Q2aXdOMGRWd0lZRFB1?=
 =?utf-8?B?NHc1bldNbm95WWc5M0FkdjI5Q051YVFYdFpsQzNqaGxHNHYyU0NCWFhKNUhO?=
 =?utf-8?B?TTZsQzF6cTM3TzYwNTNQV3V4QzQ2Zi93ajlha1l2UTRUbTFQSm5DUThnbHdC?=
 =?utf-8?B?b3JXOUtxLzFXTFcyUkJWNzh1VVBoVmMrMUs4SVY0SDRkL0hzREYwOWVTaEdO?=
 =?utf-8?B?ZVluTGJhcWFsNWk4d2RnY0dVN3puMXROZXN6cjRTYUZoZlM5VVdXV0cxM3VP?=
 =?utf-8?B?RVNYTFk2QzZSRzhmYW9RZGFjRVQwUWFENkNldFBDOFpxNkdla3VmQzVnMDBv?=
 =?utf-8?B?Um5uQUxtRWViU0U4cFZaWWcvN3gwRjB5VElIUWhFYXNBWExsa3BETW1CNzdO?=
 =?utf-8?B?L3dnQ0hMMVNmQmM2enVnZEtWdFdkTi83MTJRZlpSYWtJU0N2ZEFCSjdNSHF3?=
 =?utf-8?B?dE50WTMwRXlkU0FPYzRHZ0ZrRnNEV1dVYnVLWUx5bWtwN3l5NWozOGVyUzIv?=
 =?utf-8?B?U1c4TVZOTzRWYnp5dVRYQ1dEWktIZG13bVdNcURTTzNMeVZZMG1XaHZFM3pN?=
 =?utf-8?B?NmJOVTN5eFhacFdWbFZiZUQvNEZ0ZGlpY3d2aGx3eHUxS2M4Ri9oVG9udnZ4?=
 =?utf-8?B?TGlTU1dqVFZsQzdiNWtIb0UxczdYT21JQi9maERJbUFrK0c1MTZEMXRVMFNG?=
 =?utf-8?B?T1UzeDRVWkRFOGVIeFZsT25YMlJoMWdzQlhrS2hoQmFTWWpwQVdXaFpHdkJv?=
 =?utf-8?B?LzVVTGZYSTAwUjZGc1dYQm9qaGMxZkk0UE10bTZRZXZmOU5sZi85WVhpczV4?=
 =?utf-8?B?Qnc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: DCUT2mx/bYTDbfDIM6Wl29RrnfQ7pbNsvTuOlodgSmAUL6b1dh5hS9ZKCkHLiO2nonnGH+PgfIUxnCSxRHj5x+DYIJL+HEw1UuWl2bvBsSKlRscO2z7090BtEf0jf9TdgsOS5Z1KEps2zHIxUhTFOn0/fGm11DAtrX0DTxvTg/86SxOpmgMzEfG2hoVhdeUpEYyh+LWcv4WmH8Cja4z9J1gD2OHVh7g1y6ripeGOOb+zEiX83PQS0qLsBN8d5sZTyYLfJEdfavrAoGdDJmYNpVjuwfht0IYCayiMqx37BnnEPJxJE5cQbRaxS9xhS1FqkxuMmnblP1E5TBFzIvw47Wp0BxcSu2dlt343yzSqw+XLAWvlbolhOVsQ/aK8ky23rLRp+APTeFKVwXDfHC8NCzESTzOSuxCeyn/j0izKybWfRnexR/bgpSvhjzrvtlzV5xuchS9Czl1nYDZnfdINz/RB2P1T70eHRIkhtoY7lJfR1CD56wwE068sZcWtzcOsA216AJYB9z1Ty1FIfFcAkxNMNwjPLctUbxlHNdyG9E1/us3hJb4ZWTUE+9TQmf4HSIbhZl/0pS6Rodh64ZtVzHa897xnRFSvGDPKdNGkADvOkqMZwJn19x1962hAWpHvKLOhcxkW1y3OG0rb+1PgJ6UY0ya+LcmigcV1gjQ8vn+Yu9znCyQxsE8YQ/84UxEjZUoyVhaoZ5nd8krXU8PNtVzl6+YwhANN4DrZtWnIctsdhJRttqmpnSPeUWA1jvoynoPzaVq7EU3i6LudURdu/ACOuG2GGSUUTtI81Q0X6f9FVG+81CRrDUXy/64qlOG1D4cKWITzX+ySrpzgFPMOwJ0j5iUjGHQiN4M9F2xPVY0aQl/QxxjFitPyyKVpwxE8zAv9m/vI7xRbb0skAxYq/Q==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c5ca617-fb21-410b-3160-08dbd6421c35
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2023 16:39:23.3905
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YBIgEoH5m2lizIPbbF+TK+JcVDV6PbGkgfIQEDrPcv14jI/c9WHvb3Bhsyv2MsKMihSOOM5zn4qzFjkYKVSQrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6235
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-26_15,2023-10-26_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 adultscore=0 bulkscore=0 suspectscore=0 mlxscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310170001 definitions=main-2310260145
X-Proofpoint-GUID: 1tTIbaWWYSDmC0Do_2DX3llnnLUCbiC0
X-Proofpoint-ORIG-GUID: 1tTIbaWWYSDmC0Do_2DX3llnnLUCbiC0
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi David,

On 10/26/23 08:39, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> Where the local APIC is emulated by KVM, we need kvm_get_apic() to pull
> the current state into userspace before it's printed. Otherwise we get
> stale values.
> 
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---
>  target/i386/monitor.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/target/i386/monitor.c b/target/i386/monitor.c
> index 6512846327..0754d699ba 100644
> --- a/target/i386/monitor.c
> +++ b/target/i386/monitor.c
> @@ -29,6 +29,7 @@
>  #include "monitor/hmp.h"
>  #include "qapi/qmp/qdict.h"
>  #include "sysemu/kvm.h"
> +#include "sysemu/hw_accel.h"
>  #include "qapi/error.h"
>  #include "qapi/qapi-commands-misc-target.h"
>  #include "qapi/qapi-commands-misc.h"
> @@ -655,6 +656,7 @@ void hmp_info_local_apic(Monitor *mon, const QDict *qdict)
>      if (qdict_haskey(qdict, "apic-id")) {
>          int id = qdict_get_try_int(qdict, "apic-id", 0);
>          cs = cpu_by_arch_id(id);
> +        cpu_synchronize_state(cs);

AFAIR, there is a case that cs may be NULL here when I was sending the similar
bugfix long time ago.

https://lore.kernel.org/qemu-devel/20210701214051.1588-1-dongli.zhang@oracle.com/

... and resend:

https://lore.kernel.org/qemu-devel/20210908143803.29191-1-dongli.zhang@oracle.com/

... and resent by Daniel as part of another patchset (after review):

https://lore.kernel.org/qemu-devel/20211028155457.967291-19-berrange@redhat.com/


This utility is helpful for the diagnostic of loss of interrupt issue.

Dongli Zhang

>      } else {
>          cs = mon_get_cpu(mon);
>      }
