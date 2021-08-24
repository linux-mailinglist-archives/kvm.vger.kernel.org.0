Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 511143F6B8B
	for <lists+kvm@lfdr.de>; Wed, 25 Aug 2021 00:09:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237202AbhHXWKH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Aug 2021 18:10:07 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:17666 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236014AbhHXWKH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 24 Aug 2021 18:10:07 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17OKGrix001041;
        Tue, 24 Aug 2021 22:08:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 cc : references : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=+OC6y0vky+IYDnqszTf7uHDq+ht13toxZ6BZtgp/Hpg=;
 b=HctUmOKaFKod2s64xb/Dh6DqXruMc+WN15siOVXILTRII6SFyTvd8NhZmSqbfHx61Fag
 yHxtCikcvWvG8o/QNpTDNAoDxQ7h2qF6/7yoRBf8CJMJafnH1g4Ivq9vTZ9VYRxcFTfV
 XKUzoj4IW8drtSGjAB+akFngRKsElH3kOZP4z4EHUxCmQQ/Pz8ssgwyhPVXzY+HR2l6u
 OhQ/i993upu62388Fb4inZizQecVwpqb61ZaqyEdGbKj7a/44nyy1ow0KutFNN5Jpwpn
 FAozVLvQFmHu/gKp36VSUKttc3QYEPMLz9tCGNkNu1Nra28+aghlll2YIWqrQ4Cy4IrM ug== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 cc : references : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=+OC6y0vky+IYDnqszTf7uHDq+ht13toxZ6BZtgp/Hpg=;
 b=I1Fby9Yx5754ytK7nTEoxTWz58JNLBPm7IxbP3WOILEE9junODRBR6JetOM+DdmDjB8+
 MEIzJTMm+AU23KB9aV8c2UNWtcy2fEdM1pU/p2cCPyFuuB5vQX8pv8Wg7X7xLVBKwmbL
 lwvt2/ykgOToaeEeBJBZ2bfsYVW6/2tenlmit4ciNBDZ4G4qobZBGJx1toARErX7Kv1X
 UL12TNIRToONAbgV6Z1dj16uuocNWKfofeMuVN3T2N8FsQHfihYRXfbzt8O4qc6pQDqK
 4lcW7PXS9Y3o00FX8k2wPFidA9QY2U4LYJOTPgbHNZ7KPZHzA+GrbB3ZVS+aXPfzcmPd ag== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3amvtvt39k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Aug 2021 22:08:58 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17OM5FdX134854;
        Tue, 24 Aug 2021 22:08:56 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2105.outbound.protection.outlook.com [104.47.55.105])
        by aserp3020.oracle.com with ESMTP id 3ajsa62e67-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Aug 2021 22:08:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mUIREXjKyUIN0QHoJwsToAcFrOmbZVJZHtvAr/kxFE+tS8adnPlUWkI2C97uVYU3IQGUcLATJyrImYJFoKOYh+EEKxArNmuQMC6qG+FxgFwk017vTMv1R49mlIKdShnFUAA1nXrkHNLEhGfeEa2mHT9a/ksPHi7ire7l4JwBt9yE8uNTPZQQx2Li6gLuVIaI2Z+YV6i6DDwNtZCh2YHQAddfN9qYv3KVm3A8xJBgfuzm1PF1a1UPak4cOJrIcwUBtXL7bFNAQlj4CA9tdZRohi6lpelemJJhu//9XjLrmEa+wf+MB0ZTtdKGPJ4Rk9e85HWpMEpIRJiw1D+sgf37iQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+OC6y0vky+IYDnqszTf7uHDq+ht13toxZ6BZtgp/Hpg=;
 b=iw5tb8TzGAn6xE2oEPnDytqZq/34gD8qUqiw0B6cd+VQ2ho/tRZOpdu1f4D+PLhgLoBBORIhFx8zRaM6PPNBZcGihPALDmMCDwIkegIjw8qaZWohXiWKkj7Xj7Dl+3w9nQ2S5Uwi1Mo8nCMcaEnwwrMAsn6LKyrvyfs/AM5xLr/lSgvpWm2x5g2K8AdGVHabEc/id408PQVqjSV25o1YZw8D4I8a/1jxOreiq+NBZ+rCpDzXiEtvqO6meLcyPqecnQZrkEhJGvbbNstIbQrh0iBW5MQx5u2ErfCwscictszmovsQ5Nn5uvLTOk12ggl8CoJgwOrZmvoPXfCZEM819Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+OC6y0vky+IYDnqszTf7uHDq+ht13toxZ6BZtgp/Hpg=;
 b=I2pPUq8EsWr3rK/4DLUJhVKjcbXA7CNuBQ33IA6c0hX9eAYp3T8jEPFw8X/6odsVzq5+I2BxmH3OHH8FGXH6OSYdRF7owGiDmekZX1RtNOUDbxuaVAink/rau5/BtZy+CdEcKvHxtg89NYPhlp7lXEHSZGNCutLaYRjW2QBbvtk=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from DM6PR10MB3019.namprd10.prod.outlook.com (2603:10b6:5:6f::23) by
 DM5PR10MB1756.namprd10.prod.outlook.com (2603:10b6:4:7::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4436.19; Tue, 24 Aug 2021 22:08:53 +0000
Received: from DM6PR10MB3019.namprd10.prod.outlook.com
 ([fe80::f9b8:94dd:1c44:cb2b]) by DM6PR10MB3019.namprd10.prod.outlook.com
 ([fe80::f9b8:94dd:1c44:cb2b%7]) with mapi id 15.20.4415.023; Tue, 24 Aug 2021
 22:08:53 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Subject: Re: [kvm-unit-tests PATCH v2 2/6] x86: Call efi_main from
 _efi_pe_entry
To:     Varad Gautam <varadgautam@gmail.com>,
        Zixuan Wang <zixuanwang@google.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        Marc Orr <marcorr@google.com>, Joerg Roedel <jroedel@suse.de>,
        kvm list <kvm@vger.kernel.org>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <drjones@redhat.com>, bp@suse.de,
        Thomas.Lendacky@amd.com, brijesh.singh@amd.com,
        Hyunwook Baek <baekhw@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Tom Roeder <tmroeder@google.com>
Cc:     Varad Gautam <varad.gautam@suse.com>
References: <20210819113400.26516-1-varad.gautam@suse.com>
 <20210819113400.26516-3-varad.gautam@suse.com>
Message-ID: <61ee15ee-c415-c24b-c886-b7f6ba2be149@oracle.com>
Date:   Tue, 24 Aug 2021 15:08:49 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
In-Reply-To: <20210819113400.26516-3-varad.gautam@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: SJ0PR05CA0140.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::25) To DM6PR10MB3019.namprd10.prod.outlook.com
 (2603:10b6:5:6f::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (2606:b400:8301:1010::16aa) by SJ0PR05CA0140.namprd05.prod.outlook.com (2603:10b6:a03:33d::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.6 via Frontend Transport; Tue, 24 Aug 2021 22:08:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5d8d9a57-8731-4880-890f-08d9674bc225
X-MS-TrafficTypeDiagnostic: DM5PR10MB1756:
X-Microsoft-Antispam-PRVS: <DM5PR10MB17568F819BDB55E85B00637781C59@DM5PR10MB1756.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BOeaM7enAfU4dxm9smAJFfY2JVbm0f5YRyC7AYqh2TvBN7DwI1Z8H3DhocBH3HEYpa9Qthlfus76Ha/xzoEL6VLN+BJaY9+HdttRaCFTwkN+PP/23+f8DWsFQZew2fM4Fl18vBKM+RFS+znSyJNtrgCS8lY9Q6eERaoJvdr+PUO8x6gPMOFQXtRUemw9zfEF5jhKyRcsFvBmskDIwgqxBCzqIfW3qQerD9caIFwU1hX8jRn+yhQYzmXgfWpFaDfhf42R93kgFwbIxEB+IXEmHnB10NtnVHdxkAF1md+KwvTJet9laGzFR2HHRYlJtffA9etm01tHP6QkvpFamcYzidQmY97T+oMxypiHt4cMkRuWzo2nximVOs7iMtCW1WT+18M60TN9T4ACdq5ACbMWDsJLsjMx0PC5cGaHKmttydTttWqbgtTMm5lN+h8OWkzvqdMCdRi/7FHJWmjxPLt4/GCiebucFClWe2Ia8sevBxx221a9ygTrbdwILPdKjYbznq1d8J8q6tA23MzEQYZXR0XSZj7m6Rgck1adAyZaYAiAO5sG+Gfr8K4ujTxvk/WJePlF71tYolwaCbnZjeAE7qYEjqYZPRm/r0YxQEC/VYZf9l9nvRH/GfvNqfpD4ts7vM00g6FnFM875FHj02Pudc6cNAZfU8rfBrHy+1MUGXmrbZLe15uKqyer+OBp3l5+VEU8UY9lFl+hRTgGDsZcYmxw+ctNKA/DTyRC9qJ8drR4by/4DWwX6cg142R/EnRz
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB3019.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(366004)(39860400002)(136003)(396003)(36756003)(478600001)(4326008)(8676002)(30864003)(8936002)(316002)(7416002)(38100700002)(2616005)(110136005)(31686004)(44832011)(5660300002)(921005)(86362001)(66476007)(31696002)(6486002)(66946007)(83380400001)(186003)(2906002)(6512007)(53546011)(66556008)(6506007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bVpVbGk3VFpnYVFpRHhneHNFWk4xb2VXV1RwSncrbEo0T3hWalkvYURoYTkz?=
 =?utf-8?B?NlN0WFlGT0pxQ1U2bHUwdXN6TFdpSDNnT3R5Vkp1dG1XUm5VNE9rOVNqT01C?=
 =?utf-8?B?VUQ1L1lpTnAxaVg4U01ZVEk0bEswZi9kQVFnVklydVpLNXlzYjBwQ3lyRkRt?=
 =?utf-8?B?OU54L0pKbkl6R2pkajRTb1BkbWkxR0RMTkhZRysrQ3d0N2Izd2RuTUQ3L2Er?=
 =?utf-8?B?SzA4RXA5Z1U5TkcraHlrVmJTNWhQYW5nZ0hZcVkwVUJFcnNhelNHdlNwSWtx?=
 =?utf-8?B?NC95RDRvMXVMa0NVZzB0bWZWTFJYbHhEN2ZlU0o2MHB2NUNjTUtaR0NDdE8y?=
 =?utf-8?B?V3VjeWV0U05KU1N4OVFoOGxMZUZJSlgxekNxVmN6a2lNeTBoYmhxREZ6MTBv?=
 =?utf-8?B?S25ubVlQVlRzMkUvTDdLdkRaOWJzMGxCSnhlNUhSNEU0VTVLaXpqRDg3Rnlh?=
 =?utf-8?B?ckFtRS90TEVoZUhORjNOa2N6Yld6VGNjRVJaUjA0a25XbTBDa1RaZWNUNnFj?=
 =?utf-8?B?cm5hVExtdUd2T1ZxN2R4czZiSkk0aFpjYVVaRHhVdjJtUzZyN1BjYlhoNnZK?=
 =?utf-8?B?djlrYjlPZzdPUEozdmpWeUpha1U2MXpLUGREV0hWNVFtYkQ5Vks2RTNvWklD?=
 =?utf-8?B?SGtNU1VmR1pKck9KTFBJZTJhS3VjK2pmQ3ZFY01GY3JtNGZGVERMaFI1cy8z?=
 =?utf-8?B?Z0hmVmtxOWZDb1gzd3c2Wk1zSGVZdE5LYzhHazRZN1ZmbmdqNDVUQjgzMWF2?=
 =?utf-8?B?Lyt6YldTQVBPOHFVVm9IcDloeWg4YlNDOThtdUg0TThBcmIwOVRmUmZWRTBy?=
 =?utf-8?B?c2FZdlFiVWw1UTVoRWFaV0FpUE5WRDJIalVLTm9UcThSUWJMS3Y0OWtReE1n?=
 =?utf-8?B?V3VZclhCRU5BYUJlZEtzeTJHVUYxVlhtalkrTGJJVHBCK0lJYmxhQ1hTS2lm?=
 =?utf-8?B?S29xek5ZMWJMMHZTOHJyZTFUa3VpTHJVdFFZZmxHYlhHeE5qeXRrQVEyZlla?=
 =?utf-8?B?dVZTTkFxekFuMmFVNDJIMG05SEhXbm01d09QUUM5c2dPS2liOWsyeEdtYU9C?=
 =?utf-8?B?bVU3STZwTURuNTZFajF0UkFJdkhvWngvNkVZdEk2WThYVFdSaHFUZStrV1dE?=
 =?utf-8?B?ekVLYzVxbWZ5dHdqWlI2Zy9Rb2V2Wkw4RGtjRlFDaEYyL0dMQ3hxYVdHV2F1?=
 =?utf-8?B?MGJQSkMyRWh6UjZxVlJCY2wvbTNvMFI5cGhMR2R0b2M0c0d0aDk4QThxMG40?=
 =?utf-8?B?OEs2eXkvR2owMTZRZmRaeGt4RDBQM3JiL3B5b2hxYW8wUDlpNlVwRjE1QTJt?=
 =?utf-8?B?eU1IVVZhVTcxYVYybVc5bzh5ZTc3WTdRYlFvbGw1bzRPK0hWV2EwaDRvYXM1?=
 =?utf-8?B?aUNWNjMxYWZneHNTMkhFR1VudVZ0VzJaZEl6REowNDlWc2pxM0xJZWtMOHps?=
 =?utf-8?B?VnU4TEJVRWxjLzUvL0M1SEI0WkRXZ3QrZ2dtUEk3WjFXNk1sT0Jha09IODVV?=
 =?utf-8?B?aTRvUWpZb3ZLTCthaHhYYjQ2SlNEREo0Q0h5bk1iTXZnSFFXbUpmSkNtWk9m?=
 =?utf-8?B?aW0wTEZIRm5QbUZqbSt1MmkxNWIvWWZtenlIODBsZFE5R1pCQ0Z6cVREaUpK?=
 =?utf-8?B?K1BKT09qcGVKNEVRWG91clB1cUJzOTZGMktqeXM1T1ZUa2lCc0kyVzJIalUy?=
 =?utf-8?B?L1RCQWk2RVo4T3JaSkZFV0haSDYxN1NqWGQ3VkNQa0RlOUdqRlcrdjVNWm9h?=
 =?utf-8?B?U2NUTm9SbVRSVmtiWldXUVhHNTAxemQ1Yjd6YnhiQ1RMQUNkTHhTQzR3NjUy?=
 =?utf-8?B?TU4zaEQyWGwwZy9IbGxNQT09?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d8d9a57-8731-4880-890f-08d9674bc225
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB3019.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2021 22:08:52.9152
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BXBsaYmFqjC1PXS23gpaLwsDM9Qy9SCm3HjCvKTDkXzidV8ecxpTVFNGK1895EpqrHHwQ+YO3DJhoAMplB2y8D8Svet+3Yl2Z1/xl9TSyys=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB1756
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10086 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 adultscore=0 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108240138
X-Proofpoint-ORIG-GUID: CSP6h_XnMQSeS2niXVyEE8jv00yUkM7G
X-Proofpoint-GUID: CSP6h_XnMQSeS2niXVyEE8jv00yUkM7G
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 8/19/21 4:33 AM, Varad Gautam wrote:
> EFI calls _efi_pe_entry in long mode with the location of EFI
> handle/system table. Add an efi_main() C handler to make it easier
> to communicate with EFI for initial setup. efi_main will later,
> 1. Acquire the efi memmap
> 2. Call ExitBootServices
> 3. Perform remaining bootstrapping before calling the testcase main()
>
> Signed-off-by: Varad Gautam<varad.gautam@suse.com>
> ---
>   lib/linux/uefi.h    | 518 ++++++++++++++++++++++++++++++++++++++++++++
>   x86/Makefile.common |   2 +-
>   x86/cstart64.S      |  10 +-
>   x86/efi_main.c      |  11 +
>   4 files changed, 539 insertions(+), 2 deletions(-)
>   create mode 100644 lib/linux/uefi.h
>   create mode 100644 x86/efi_main.c
>
> diff --git a/lib/linux/uefi.h b/lib/linux/uefi.h
> new file mode 100644
> index 0000000..15692eb
> --- /dev/null
> +++ b/lib/linux/uefi.h
> @@ -0,0 +1,518 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/* Relevant definitions from linux/efi.h. */
> +
> +#ifndef __LINUX_UEFI_H
> +#define __LINUX_UEFI_H
> +
> +#define BITS_PER_LONG 64
> +
> +#define EFI_SUCCESS		0
> +#define EFI_LOAD_ERROR		( 1 | (1UL << (BITS_PER_LONG-1)))
> +#define EFI_INVALID_PARAMETER	( 2 | (1UL << (BITS_PER_LONG-1)))
> +#define EFI_UNSUPPORTED		( 3 | (1UL << (BITS_PER_LONG-1)))
> +#define EFI_BAD_BUFFER_SIZE	( 4 | (1UL << (BITS_PER_LONG-1)))
> +#define EFI_BUFFER_TOO_SMALL	( 5 | (1UL << (BITS_PER_LONG-1)))
> +#define EFI_NOT_READY		( 6 | (1UL << (BITS_PER_LONG-1)))
> +#define EFI_DEVICE_ERROR	( 7 | (1UL << (BITS_PER_LONG-1)))
> +#define EFI_WRITE_PROTECTED	( 8 | (1UL << (BITS_PER_LONG-1)))
> +#define EFI_OUT_OF_RESOURCES	( 9 | (1UL << (BITS_PER_LONG-1)))
> +#define EFI_NOT_FOUND		(14 | (1UL << (BITS_PER_LONG-1)))
> +#define EFI_TIMEOUT		(18 | (1UL << (BITS_PER_LONG-1)))
> +#define EFI_ABORTED		(21 | (1UL << (BITS_PER_LONG-1)))
> +#define EFI_SECURITY_VIOLATION	(26 | (1UL << (BITS_PER_LONG-1)))
> +
> +typedef unsigned long efi_status_t;
> +typedef u8 efi_bool_t;
> +typedef u16 efi_char16_t;		/* UNICODE character */
> +typedef u64 efi_physical_addr_t;
> +typedef void *efi_handle_t;
> +
> +#define __efiapi __attribute__((ms_abi))
> +
> +/*
> + * The UEFI spec and EDK2 reference implementation both define EFI_GUID as
> + * struct { u32 a; u16; b; u16 c; u8 d[8]; }; and so the implied alignment
> + * is 32 bits not 8 bits like our guid_t. In some cases (i.e., on 32-bit ARM),
> + * this means that firmware services invoked by the kernel may assume that
> + * efi_guid_t* arguments are 32-bit aligned, and use memory accessors that
> + * do not tolerate misalignment. So let's set the minimum alignment to 32 bits.
> + *
> + * Note that the UEFI spec as well as some comments in the EDK2 code base
> + * suggest that EFI_GUID should be 64-bit aligned, but this appears to be
> + * a mistake, given that no code seems to exist that actually enforces that
> + * or relies on it.
> + */
> +typedef struct {
> +	u8 b[16];
> +} guid_t;
> +typedef guid_t efi_guid_t;
> +
> +#define EFI_GUID(a, b, c, d...) (efi_guid_t){ {					\
> +	(a) & 0xff, ((a) >> 8) & 0xff, ((a) >> 16) & 0xff, ((a) >> 24) & 0xff,	\
> +	(b) & 0xff, ((b) >> 8) & 0xff,						\
> +	(c) & 0xff, ((c) >> 8) & 0xff, d } }
> +
> +/*
> + * Generic EFI table header
> + */
> +typedef	struct {
> +	u64 signature;
> +	u32 revision;
> +	u32 headersize;
> +	u32 crc32;
> +	u32 reserved;
> +} efi_table_hdr_t;
> +
> +/*
> + * Memory map descriptor:
> + */
> +
> +/* Memory types: */
> +#define EFI_RESERVED_TYPE		 0
> +#define EFI_LOADER_CODE			 1
> +#define EFI_LOADER_DATA			 2
> +#define EFI_BOOT_SERVICES_CODE		 3
> +#define EFI_BOOT_SERVICES_DATA		 4
> +#define EFI_RUNTIME_SERVICES_CODE	 5
> +#define EFI_RUNTIME_SERVICES_DATA	 6
> +#define EFI_CONVENTIONAL_MEMORY		 7
> +#define EFI_UNUSABLE_MEMORY		 8
> +#define EFI_ACPI_RECLAIM_MEMORY		 9
> +#define EFI_ACPI_MEMORY_NVS		10
> +#define EFI_MEMORY_MAPPED_IO		11
> +#define EFI_MEMORY_MAPPED_IO_PORT_SPACE	12
> +#define EFI_PAL_CODE			13
> +#define EFI_PERSISTENT_MEMORY		14
> +#define EFI_MAX_MEMORY_TYPE		15
> +
> +/* Attribute values: */
> +#define EFI_MEMORY_UC		((u64)0x0000000000000001ULL)	/* uncached */
> +#define EFI_MEMORY_WC		((u64)0x0000000000000002ULL)	/* write-coalescing */
> +#define EFI_MEMORY_WT		((u64)0x0000000000000004ULL)	/* write-through */
> +#define EFI_MEMORY_WB		((u64)0x0000000000000008ULL)	/* write-back */
> +#define EFI_MEMORY_UCE		((u64)0x0000000000000010ULL)	/* uncached, exported */
> +#define EFI_MEMORY_WP		((u64)0x0000000000001000ULL)	/* write-protect */
> +#define EFI_MEMORY_RP		((u64)0x0000000000002000ULL)	/* read-protect */
> +#define EFI_MEMORY_XP		((u64)0x0000000000004000ULL)	/* execute-protect */
> +#define EFI_MEMORY_NV		((u64)0x0000000000008000ULL)	/* non-volatile */
> +#define EFI_MEMORY_MORE_RELIABLE \
> +				((u64)0x0000000000010000ULL)	/* higher reliability */
> +#define EFI_MEMORY_RO		((u64)0x0000000000020000ULL)	/* read-only */
> +#define EFI_MEMORY_SP		((u64)0x0000000000040000ULL)	/* soft reserved */
> +#define EFI_MEMORY_CPU_CRYPTO	((u64)0x0000000000080000ULL)	/* supports encryption */
> +#define EFI_MEMORY_RUNTIME	((u64)0x8000000000000000ULL)	/* range requires runtime mapping */
> +#define EFI_MEMORY_DESCRIPTOR_VERSION	1
> +
> +#define EFI_PAGE_SHIFT		12
> +#define EFI_PAGE_SIZE		(1UL << EFI_PAGE_SHIFT)
> +#define EFI_PAGES_MAX		(U64_MAX >> EFI_PAGE_SHIFT)
> +
> +typedef struct {
> +	u32 type;
> +	u32 pad;
> +	u64 phys_addr;
> +	u64 virt_addr;
> +	u64 num_pages;
> +	u64 attribute;
> +} efi_memory_desc_t;
> +
> +typedef struct {
> +	efi_guid_t guid;
> +	u32 headersize;
> +	u32 flags;
> +	u32 imagesize;
> +} efi_capsule_header_t;
> +
> +/*
> + * EFI capsule flags
> + */
> +#define EFI_CAPSULE_PERSIST_ACROSS_RESET	0x00010000
> +#define EFI_CAPSULE_POPULATE_SYSTEM_TABLE	0x00020000
> +#define EFI_CAPSULE_INITIATE_RESET		0x00040000
> +
> +struct capsule_info {
> +	efi_capsule_header_t	header;
> +	efi_capsule_header_t	*capsule;
> +	int			reset_type;
> +	long			index;
> +	size_t			count;
> +	size_t			total_size;
> +	struct page		**pages;
> +	phys_addr_t		*phys;
> +	size_t			page_bytes_remain;
> +};
> +
> +int __efi_capsule_setup_info(struct capsule_info *cap_info);
> +
> +/*
> + * Types and defines for Time Services
> + */
> +#define EFI_TIME_ADJUST_DAYLIGHT 0x1
> +#define EFI_TIME_IN_DAYLIGHT     0x2
> +#define EFI_UNSPECIFIED_TIMEZONE 0x07ff
> +
> +typedef struct {
> +	u16 year;
> +	u8 month;
> +	u8 day;
> +	u8 hour;
> +	u8 minute;
> +	u8 second;
> +	u8 pad1;
> +	u32 nanosecond;
> +	s16 timezone;
> +	u8 daylight;
> +	u8 pad2;
> +} efi_time_t;
> +
> +typedef struct {
> +	u32 resolution;
> +	u32 accuracy;
> +	u8 sets_to_zero;
> +} efi_time_cap_t;
> +
> +typedef void *efi_event_t;
> +/* Note that notifications won't work in mixed mode */
> +typedef void (__efiapi *efi_event_notify_t)(efi_event_t, void *);
> +
> +typedef enum {
> +	EfiTimerCancel,
> +	EfiTimerPeriodic,
> +	EfiTimerRelative
> +} EFI_TIMER_DELAY;
> +
> +/*
> + * EFI Device Path information
> + */
> +#define EFI_DEV_HW			0x01
> +#define  EFI_DEV_PCI				 1
> +#define  EFI_DEV_PCCARD				 2
> +#define  EFI_DEV_MEM_MAPPED			 3
> +#define  EFI_DEV_VENDOR				 4
> +#define  EFI_DEV_CONTROLLER			 5
> +#define EFI_DEV_ACPI			0x02
> +#define   EFI_DEV_BASIC_ACPI			 1
> +#define   EFI_DEV_EXPANDED_ACPI			 2
> +#define EFI_DEV_MSG			0x03
> +#define   EFI_DEV_MSG_ATAPI			 1
> +#define   EFI_DEV_MSG_SCSI			 2
> +#define   EFI_DEV_MSG_FC			 3
> +#define   EFI_DEV_MSG_1394			 4
> +#define   EFI_DEV_MSG_USB			 5
> +#define   EFI_DEV_MSG_USB_CLASS			15
> +#define   EFI_DEV_MSG_I20			 6
> +#define   EFI_DEV_MSG_MAC			11
> +#define   EFI_DEV_MSG_IPV4			12
> +#define   EFI_DEV_MSG_IPV6			13
> +#define   EFI_DEV_MSG_INFINIBAND		 9
> +#define   EFI_DEV_MSG_UART			14
> +#define   EFI_DEV_MSG_VENDOR			10
> +#define EFI_DEV_MEDIA			0x04
> +#define   EFI_DEV_MEDIA_HARD_DRIVE		 1
> +#define   EFI_DEV_MEDIA_CDROM			 2
> +#define   EFI_DEV_MEDIA_VENDOR			 3
> +#define   EFI_DEV_MEDIA_FILE			 4
> +#define   EFI_DEV_MEDIA_PROTOCOL		 5
> +#define EFI_DEV_BIOS_BOOT		0x05
> +#define EFI_DEV_END_PATH		0x7F
> +#define EFI_DEV_END_PATH2		0xFF
> +#define   EFI_DEV_END_INSTANCE			0x01
> +#define   EFI_DEV_END_ENTIRE			0xFF
> +
> +struct efi_generic_dev_path {
> +	u8				type;
> +	u8				sub_type;
> +	u16				length;
> +} __packed;
> +
> +typedef struct efi_generic_dev_path efi_device_path_protocol_t;


BTW, the following syntax is also allowed by gcc and you can use it here:

+typedef struct efi_generic_dev_path {
+	u8				type;
+	u8				sub_type;
+	u16				length;
+} __packed, efi_device_path_protocol_t;

> +
> +/*
> + * EFI Boot Services table
> + */
> +union efi_boot_services {
> +	struct {
> +		efi_table_hdr_t hdr;
> +		void *raise_tpl;
> +		void *restore_tpl;
> +		efi_status_t (__efiapi *allocate_pages)(int, int, unsigned long,
> +							efi_physical_addr_t *);
> +		efi_status_t (__efiapi *free_pages)(efi_physical_addr_t,
> +						    unsigned long);
> +		efi_status_t (__efiapi *get_memory_map)(unsigned long *, void *,
> +							unsigned long *,
> +							unsigned long *, u32 *);
> +		efi_status_t (__efiapi *allocate_pool)(int, unsigned long,
> +						       void **);
> +		efi_status_t (__efiapi *free_pool)(void *);
> +		efi_status_t (__efiapi *create_event)(u32, unsigned long,
> +						      efi_event_notify_t, void *,
> +						      efi_event_t *);
> +		efi_status_t (__efiapi *set_timer)(efi_event_t,
> +						  EFI_TIMER_DELAY, u64);
> +		efi_status_t (__efiapi *wait_for_event)(unsigned long,
> +							efi_event_t *,
> +							unsigned long *);
> +		void *signal_event;
> +		efi_status_t (__efiapi *close_event)(efi_event_t);
> +		void *check_event;
> +		void *install_protocol_interface;
> +		void *reinstall_protocol_interface;
> +		void *uninstall_protocol_interface;
> +		efi_status_t (__efiapi *handle_protocol)(efi_handle_t,
> +							 efi_guid_t *, void **);
> +		void *__reserved;
> +		void *register_protocol_notify;
> +		efi_status_t (__efiapi *locate_handle)(int, efi_guid_t *,
> +						       void *, unsigned long *,
> +						       efi_handle_t *);
> +		efi_status_t (__efiapi *locate_device_path)(efi_guid_t *,
> +							    efi_device_path_protocol_t **,
> +							    efi_handle_t *);
> +		efi_status_t (__efiapi *install_configuration_table)(efi_guid_t *,
> +								     void *);
> +		void *load_image;
> +		void *start_image;
> +		efi_status_t (__efiapi *exit)(efi_handle_t,
> +							 efi_status_t,
> +							 unsigned long,
> +							 efi_char16_t *);
> +		void *unload_image;
> +		efi_status_t (__efiapi *exit_boot_services)(efi_handle_t,
> +							    unsigned long);
> +		void *get_next_monotonic_count;
> +		efi_status_t (__efiapi *stall)(unsigned long);
> +		void *set_watchdog_timer;
> +		void *connect_controller;
> +		efi_status_t (__efiapi *disconnect_controller)(efi_handle_t,
> +							       efi_handle_t,
> +							       efi_handle_t);
> +		void *open_protocol;
> +		void *close_protocol;
> +		void *open_protocol_information;
> +		void *protocols_per_handle;
> +		void *locate_handle_buffer;
> +		efi_status_t (__efiapi *locate_protocol)(efi_guid_t *, void *,
> +							 void **);
> +		void *install_multiple_protocol_interfaces;
> +		void *uninstall_multiple_protocol_interfaces;
> +		void *calculate_crc32;
> +		void *copy_mem;
> +		void *set_mem;
> +		void *create_event_ex;


It's probably better to group the function pointers together for 
readability purposes.

> +	};
> +	struct {
> +		efi_table_hdr_t hdr;
> +		u32 raise_tpl;
> +		u32 restore_tpl;
> +		u32 allocate_pages;
> +		u32 free_pages;
> +		u32 get_memory_map;
> +		u32 allocate_pool;
> +		u32 free_pool;
> +		u32 create_event;
> +		u32 set_timer;
> +		u32 wait_for_event;
> +		u32 signal_event;
> +		u32 close_event;
> +		u32 check_event;
> +		u32 install_protocol_interface;
> +		u32 reinstall_protocol_interface;
> +		u32 uninstall_protocol_interface;
> +		u32 handle_protocol;
> +		u32 __reserved;
> +		u32 register_protocol_notify;
> +		u32 locate_handle;
> +		u32 locate_device_path;
> +		u32 install_configuration_table;
> +		u32 load_image;
> +		u32 start_image;
> +		u32 exit;
> +		u32 unload_image;
> +		u32 exit_boot_services;
> +		u32 get_next_monotonic_count;
> +		u32 stall;
> +		u32 set_watchdog_timer;
> +		u32 connect_controller;
> +		u32 disconnect_controller;
> +		u32 open_protocol;
> +		u32 close_protocol;
> +		u32 open_protocol_information;
> +		u32 protocols_per_handle;
> +		u32 locate_handle_buffer;
> +		u32 locate_protocol;
> +		u32 install_multiple_protocol_interfaces;
> +		u32 uninstall_multiple_protocol_interfaces;
> +		u32 calculate_crc32;
> +		u32 copy_mem;
> +		u32 set_mem;
> +		u32 create_event_ex;
> +	} mixed_mode;


Just curious why we need mixed mode because we are building the tests as 
64-bit UEFI executable.

> +};
> +
> +typedef union efi_boot_services efi_boot_services_t;
> +
> +/*
> + * Types and defines for EFI ResetSystem
> + */
> +#define EFI_RESET_COLD 0
> +#define EFI_RESET_WARM 1
> +#define EFI_RESET_SHUTDOWN 2
> +
> +/*
> + * EFI Runtime Services table
> + */
> +#define EFI_RUNTIME_SERVICES_SIGNATURE ((u64)0x5652453544e5552ULL)
> +#define EFI_RUNTIME_SERVICES_REVISION  0x00010000
> +
> +typedef struct {
> +	efi_table_hdr_t hdr;
> +	u32 get_time;
> +	u32 set_time;
> +	u32 get_wakeup_time;
> +	u32 set_wakeup_time;
> +	u32 set_virtual_address_map;
> +	u32 convert_pointer;
> +	u32 get_variable;
> +	u32 get_next_variable;
> +	u32 set_variable;
> +	u32 get_next_high_mono_count;
> +	u32 reset_system;
> +	u32 update_capsule;
> +	u32 query_capsule_caps;
> +	u32 query_variable_info;
> +} efi_runtime_services_32_t;
> +
> +typedef efi_status_t efi_get_time_t (efi_time_t *tm, efi_time_cap_t *tc);
> +typedef efi_status_t efi_set_time_t (efi_time_t *tm);
> +typedef efi_status_t efi_get_wakeup_time_t (efi_bool_t *enabled, efi_bool_t *pending,
> +					    efi_time_t *tm);
> +typedef efi_status_t efi_set_wakeup_time_t (efi_bool_t enabled, efi_time_t *tm);
> +typedef efi_status_t efi_get_variable_t (efi_char16_t *name, efi_guid_t *vendor, u32 *attr,
> +					 unsigned long *data_size, void *data);
> +typedef efi_status_t efi_get_next_variable_t (unsigned long *name_size, efi_char16_t *name,
> +					      efi_guid_t *vendor);
> +typedef efi_status_t efi_set_variable_t (efi_char16_t *name, efi_guid_t *vendor,
> +					 u32 attr, unsigned long data_size,
> +					 void *data);
> +typedef efi_status_t efi_get_next_high_mono_count_t (u32 *count);
> +typedef void efi_reset_system_t (int reset_type, efi_status_t status,
> +				 unsigned long data_size, efi_char16_t *data);
> +typedef efi_status_t efi_set_virtual_address_map_t (unsigned long memory_map_size,
> +						unsigned long descriptor_size,
> +						u32 descriptor_version,
> +						efi_memory_desc_t *virtual_map);
> +typedef efi_status_t efi_query_variable_info_t(u32 attr,
> +					       u64 *storage_space,
> +					       u64 *remaining_space,
> +					       u64 *max_variable_size);
> +typedef efi_status_t efi_update_capsule_t(efi_capsule_header_t **capsules,
> +					  unsigned long count,
> +					  unsigned long sg_list);
> +typedef efi_status_t efi_query_capsule_caps_t(efi_capsule_header_t **capsules,
> +					      unsigned long count,
> +					      u64 *max_size,
> +					      int *reset_type);
> +typedef efi_status_t efi_query_variable_store_t(u32 attributes,
> +						unsigned long size,
> +						bool nonblocking);
> +
> +typedef union {
> +	struct {
> +		efi_table_hdr_t				hdr;
> +		efi_get_time_t __efiapi			*get_time;
> +		efi_set_time_t __efiapi			*set_time;
> +		efi_get_wakeup_time_t __efiapi		*get_wakeup_time;
> +		efi_set_wakeup_time_t __efiapi		*set_wakeup_time;
> +		efi_set_virtual_address_map_t __efiapi	*set_virtual_address_map;
> +		void					*convert_pointer;
> +		efi_get_variable_t __efiapi		*get_variable;
> +		efi_get_next_variable_t __efiapi	*get_next_variable;
> +		efi_set_variable_t __efiapi		*set_variable;
> +		efi_get_next_high_mono_count_t __efiapi	*get_next_high_mono_count;
> +		efi_reset_system_t __efiapi		*reset_system;
> +		efi_update_capsule_t __efiapi		*update_capsule;
> +		efi_query_capsule_caps_t __efiapi	*query_capsule_caps;
> +		efi_query_variable_info_t __efiapi	*query_variable_info;
> +	};
> +	efi_runtime_services_32_t mixed_mode;
> +} efi_runtime_services_t;
> +
> +#define EFI_SYSTEM_TABLE_SIGNATURE ((u64)0x5453595320494249ULL)
> +
> +#define EFI_2_30_SYSTEM_TABLE_REVISION  ((2 << 16) | (30))
> +#define EFI_2_20_SYSTEM_TABLE_REVISION  ((2 << 16) | (20))
> +#define EFI_2_10_SYSTEM_TABLE_REVISION  ((2 << 16) | (10))
> +#define EFI_2_00_SYSTEM_TABLE_REVISION  ((2 << 16) | (00))
> +#define EFI_1_10_SYSTEM_TABLE_REVISION  ((1 << 16) | (10))
> +#define EFI_1_02_SYSTEM_TABLE_REVISION  ((1 << 16) | (02))
> +
> +typedef struct {
> +	efi_table_hdr_t hdr;
> +	u64 fw_vendor;	/* physical addr of CHAR16 vendor string */
> +	u32 fw_revision;
> +	u32 __pad1;
> +	u64 con_in_handle;
> +	u64 con_in;
> +	u64 con_out_handle;
> +	u64 con_out;
> +	u64 stderr_handle;
> +	u64 stderr;
> +	u64 runtime;
> +	u64 boottime;
> +	u32 nr_tables;
> +	u32 __pad2;
> +	u64 tables;
> +} efi_system_table_64_t;
> +
> +typedef struct {
> +	efi_table_hdr_t hdr;
> +	u32 fw_vendor;	/* physical addr of CHAR16 vendor string */
> +	u32 fw_revision;
> +	u32 con_in_handle;
> +	u32 con_in;
> +	u32 con_out_handle;
> +	u32 con_out;
> +	u32 stderr_handle;
> +	u32 stderr;
> +	u32 runtime;
> +	u32 boottime;
> +	u32 nr_tables;
> +	u32 tables;
> +} efi_system_table_32_t;
> +
> +typedef union efi_simple_text_input_protocol efi_simple_text_input_protocol_t;
> +typedef union efi_simple_text_output_protocol efi_simple_text_output_protocol_t;
> +
> +typedef union {
> +	struct {
> +		efi_table_hdr_t hdr;
> +		unsigned long fw_vendor;	/* physical addr of CHAR16 vendor string */
> +		u32 fw_revision;
> +		unsigned long con_in_handle;
> +		efi_simple_text_input_protocol_t *con_in;
> +		unsigned long con_out_handle;
> +		efi_simple_text_output_protocol_t *con_out;
> +		unsigned long stderr_handle;
> +		unsigned long stderr;
> +		efi_runtime_services_t *runtime;
> +		efi_boot_services_t *boottime;
> +		unsigned long nr_tables;
> +		unsigned long tables;
> +	};
> +	efi_system_table_32_t mixed_mode;
> +} efi_system_table_t;
> +
> +struct efi_boot_memmap {
> +	efi_memory_desc_t       **map;
> +	unsigned long           *map_size;
> +	unsigned long           *desc_size;
> +	u32                     *desc_ver;
> +	unsigned long           *key_ptr;
> +	unsigned long           *buff_size;
> +};
> +
> +#define efi_bs_call(func, ...)						\
> +	efi_system_table->boottime->func(__VA_ARGS__)
> +
> +#endif /* __LINUX_UEFI_H */
> diff --git a/x86/Makefile.common b/x86/Makefile.common
> index fc9a693..ca33e8e 100644
> --- a/x86/Makefile.common
> +++ b/x86/Makefile.common
> @@ -50,7 +50,7 @@ FLATLIBS = lib/libcflat.a
>   	$(OBJCOPY) -O elf32-i386 $^ $@
>   	@chmod a-x $@
>   
> -%.so: %.o $(FLATLIBS) $(cstart.o)
> +%.so: %.o $(FLATLIBS) $(TEST_DIR)/efi_main.o $(cstart.o)
>   	$(LD) -shared -nostdlib -znocombreloc -Bsymbolic -T $(SRCDIR)/x86/efi.lds $^ \
>   		-o $@ $(FLATLIBS)
>   	@chmod a-x $@
> diff --git a/x86/cstart64.S b/x86/cstart64.S
> index 404fcac..98e7848 100644
> --- a/x86/cstart64.S
> +++ b/x86/cstart64.S
> @@ -267,7 +267,15 @@ ap_start64:
>   #ifdef CONFIG_EFI
>   .globl _efi_pe_entry
>   _efi_pe_entry:
> -	ret
> +	# EFI image loader calls this with rcx=efi_handle,
> +	# rdx=efi_system_table. Pass these to efi_main.
> +	mov     %rcx, %rdi
> +	mov     %rdx, %rsi
> +
> +	pushq   %rdi
> +	pushq   %rsi
> +
> +	call efi_main
>   #endif
>   
>   start64:
> diff --git a/x86/efi_main.c b/x86/efi_main.c
> new file mode 100644
> index 0000000..00e7086
> --- /dev/null
> +++ b/x86/efi_main.c
> @@ -0,0 +1,11 @@
> +#include <linux/uefi.h>
> +
> +unsigned long __efiapi efi_main(efi_handle_t handle, efi_system_table_t *sys_tab);
> +efi_system_table_t *efi_system_table = NULL;
> +
> +unsigned long __efiapi efi_main(efi_handle_t handle, efi_system_table_t *sys_tab)
> +{
> +	efi_system_table = sys_tab;
> +
> +	return 0;
> +}
