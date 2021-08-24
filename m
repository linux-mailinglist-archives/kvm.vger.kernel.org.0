Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7948D3F6B95
	for <lists+kvm@lfdr.de>; Wed, 25 Aug 2021 00:11:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234720AbhHXWMc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Aug 2021 18:12:32 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:42084 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230177AbhHXWMb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 24 Aug 2021 18:12:31 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17OLmaqU000921;
        Tue, 24 Aug 2021 22:11:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 cc : references : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=Wor+K+OCWXVBXj3hTMD7rr6wFy0edP217mblMMn37vs=;
 b=lglBvAInFJotcsn3rv8GyB3u+4JoLbYsEuPVmhbH2u/KLTHD80r8y6j4RsxV+sEMY3Br
 uFrMnZmTAPuW2X4DGYu1Y2saTfAndUkB0bBQtiye/RLiv6a0c15DdGWd4yALoFYpOQAY
 YRD/401jA0xGyuzkmrtP8DkcVeckBn31fF69ujpYeba0VHMxZQTdrY65e91OMXzrcAlA
 +JzXtSbc7lj6iARQr8M+eTygJygFzKhElBFDG6oydKLRw77LLNEenBK0WAUD0zE6NzrF
 U3tSv/b4Oq8FPOm/R23dsRiOBJKhGa7vEVqtL2Y3InYRrSKzB1b5m/ru9AwxIvtSp7ef Cw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 cc : references : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=Wor+K+OCWXVBXj3hTMD7rr6wFy0edP217mblMMn37vs=;
 b=JzhZ5nlkHd2GIQ8UPyqmJ7Bvo8NNqBkwALsrvRbIjPIBqn+eeqJxkkVftLOY0ORDEqc5
 MvTHcvUlXQsEF9O8Xw/AcbyBNFYRlifWdIgdy31VItEKpzRmjNkfwMX/Wl2t7thwU8jr
 uYir2pmhAASk597Q/LqTp/rfP9MzDAjurtj06XqCAIABMGL0kixqK1woqpYru5TPxLzO
 2DNw46WZJE6p0QZshtJpwVCfp9i2NBRyLoEjjvJgHsBbwTV8ueP/b13zzjoQE60+wIqs
 6Y9QHK8biWSkNi9tYsEcPYGVj6krKS6/m9RTc4A/iPmBIrALKPrLr3jaak6R9kjRfO6c pg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3amwpd9v1d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Aug 2021 22:11:33 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17OMBMkf054386;
        Tue, 24 Aug 2021 22:11:33 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2177.outbound.protection.outlook.com [104.47.59.177])
        by aserp3030.oracle.com with ESMTP id 3ajqhfd8bg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Aug 2021 22:11:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZAsqUt539p2Z14Wkapo/5i7td5Atn5F29a8n5/7NP0ReWZKpwwqkWpxYr5POAMLCTGchnwPx8JyqXDu0r1qE4KHcTNnEfsEywI1o19D93oLyNOKot4DO/+BVGzKQOdUEusufFYBa8Kje7x7Zxl/EIpPL/t2JJ4/1AWerLxelyeR1+MyGD8+QW453IfCHljXR+RJnQOYVDPOUMHWvPjOSG3Fw2IjxeWdn9QoljBbOr4XdexxRAA4sNpB7lGACJ0BPWvaLuSvL1QQozPHyUCKphd5z804s2aVNmDeZPnBGqHNtrbmDmZGXDnWFwp+Ka6gu0dwGqRVHQtsFXjpfweLyTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wor+K+OCWXVBXj3hTMD7rr6wFy0edP217mblMMn37vs=;
 b=B3lb4/KFNHatuEhwxNXDNlaj+jjHbWdjRwtj3hEFecGUloizErloyDF8Rf4bYSXRv7EV0GKJe8EmVBjgmUmGr5Sb4oQMUu0Bfab90eKH1X8Jbhisyb/gJAUgCecNsa+mVntDk+k3iAH/tEvc6FfiVjXobTtqcLwmovvj0kXdir7vWHbJqYhHprB2ZHxyp8y5OCJ/7gasmKjkY/KEYfNyXePl8sYA/5tirBskEXyDyZJ9hkqKNsnKfpIdnwda5DmRz6uBnVSqqQlYFx1E/9GSHhIoG40y1my+QYi93jqPXK4haD45ikpwQE2jSFY8tqmZKiWfYMPmFn3Cd7Rds7hZTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wor+K+OCWXVBXj3hTMD7rr6wFy0edP217mblMMn37vs=;
 b=xdXmJ6CRIySBUWQ5MkXvvLIYQzOUY7xNrCzGu/363R6zK4qUR7imnZLG5TxjK35eswYvuHiWQ4Ss2KhN8sasX5GL7UYorz8OcvMCAdpuFC9CY1c/odnslLLYy3FZCtZUyoIr5ZXXPyEQY6u5MKqAOuNhAQceCe5t9c1jMsfJxBE=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from DM6PR10MB3019.namprd10.prod.outlook.com (2603:10b6:5:6f::23) by
 DM8PR10MB5400.namprd10.prod.outlook.com (2603:10b6:8:27::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4436.19; Tue, 24 Aug 2021 22:11:31 +0000
Received: from DM6PR10MB3019.namprd10.prod.outlook.com
 ([fe80::f9b8:94dd:1c44:cb2b]) by DM6PR10MB3019.namprd10.prod.outlook.com
 ([fe80::f9b8:94dd:1c44:cb2b%7]) with mapi id 15.20.4415.023; Tue, 24 Aug 2021
 22:11:31 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Subject: Re: [kvm-unit-tests PATCH v2 5/6] cstart64.S: x86_64 bootstrapping
 after exiting EFI
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
 <20210819113400.26516-6-varad.gautam@suse.com>
Message-ID: <6cba72a3-3db7-674d-29e2-43fa7d117a1a@oracle.com>
Date:   Tue, 24 Aug 2021 15:11:27 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
In-Reply-To: <20210819113400.26516-6-varad.gautam@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: SA0PR11CA0026.namprd11.prod.outlook.com
 (2603:10b6:806:d3::31) To DM6PR10MB3019.namprd10.prod.outlook.com
 (2603:10b6:5:6f::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (2606:b400:8301:1010::16aa) by SA0PR11CA0026.namprd11.prod.outlook.com (2603:10b6:806:d3::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17 via Frontend Transport; Tue, 24 Aug 2021 22:11:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: de728109-ae05-49e3-fbf7-08d9674c209d
X-MS-TrafficTypeDiagnostic: DM8PR10MB5400:
X-Microsoft-Antispam-PRVS: <DM8PR10MB540012A603E92F9E806E9B2A81C59@DM8PR10MB5400.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mCTkKS/Nb/rjFF5pEd3Fkm2gm1P8pPCwnlt3Drcm48u+JPwMktzXEFaypcHCA74fNRmUms6uXPCrFcBrA0jo9dTIFt8EYPSUIHjZ0MfRP0OyV1HyfssD5KWd7AVINY+lSFp4kAEZtfXBd6lWZ1/fkfiwOpmbmJZQz9aMt572X1aCzUrmus5nSgSFhDpeBQ+Vva9LhjagbxUsKzEdnvb0KH5q1d/owwCeUze6xPY8OdRQtEFlFOrcgk9lWerzvAL67FQdlc+gSpkrNGSmp4lt6/QEjY9ppID7h7Hix7T32ccXieoXtm5uS09pjWbR/AJ4hMi866IrD7G0ki1jKXHYR1KmuKLKSi83KNHqrjzRKqVgs+iyZqf0PfwqVn6ZspownQH7cJc4DjQJWmlIKIRvzDKY4W/p1Je7Xqb6E3zGQSWkjXiKPRKSRgBhgTqg1fbgxuzPz95zFPSUPmli6197jyJJDO9SWejeVp8dWDma1VXO2aYT2IJawHXHr8xfkj0yaz9dEvt65/jXI7gqu08Bt6A0e7SbssOMOnjQiNo/JdbNU8nICI8N0MPLHDFObThaCBQa4daawdFFw+q3Opj88rI5Pg1Br3sT7nahVPyUeW7LHfmwu1etbCRus/oHBudmqlEtFj5HeKcf6fbc+pd1sopU2f1LKLntyb8ktBbc34fy+xZyxk6HIzkT8sEGstrTwWDpYblDmQokCu1ozXmarrOx2CaRhoi1EBxeL9jxlKgB2LXAxMCjZthGu8RUQ6Ul
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB3019.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(376002)(346002)(39860400002)(136003)(478600001)(2906002)(921005)(5660300002)(83380400001)(86362001)(2616005)(8676002)(31686004)(8936002)(316002)(31696002)(4326008)(6506007)(36756003)(110136005)(53546011)(6486002)(66556008)(66476007)(66946007)(44832011)(6512007)(7416002)(186003)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bHFFKzlzanJFemc3a1BUcGI1Z0s2MHhmYWllMFI5V21jVEpvcmJkRERnMWln?=
 =?utf-8?B?bk9NNGZSM1ZyOVJUMlRNZDdwd2NESHY4MVc1SFB5YWx2aEwxMXlEZlZDSTVH?=
 =?utf-8?B?d202dElJSkprVzkyclp5M2hHME1Sb2hNMGhjUHRLQ0xXaU5NTklGN3hDM2pq?=
 =?utf-8?B?VWFrSW01NGR5NnpZdnUxUlVkUWxFZERSUW1MTnV1dUlQcGpZQW1VdEIwTk9Q?=
 =?utf-8?B?OEhMNkcxNVlkTW4ySjA2NE5QcGkyamxiMWdGUFpka2NJMWFKVFk1TER1Zndo?=
 =?utf-8?B?ellMQk9rL3kzZjBqNUhRNGt4ZjFmL3ZwWUprTWgzYnY4MHZrSFBxK3J6aWpu?=
 =?utf-8?B?MExsd2kxRVdlKzBRdE84TDBUOGtqYjhJZ2EvL09GbGJNVmJvc3BSbDdPd3pJ?=
 =?utf-8?B?Zm50UTArcThUWC9ENHRwS01YcERzT3V4NzRMeXlLbzMxSWdReDhzci9hWFhn?=
 =?utf-8?B?QU5tU2t0OGx2Tjh1TWVkcTl4V3VEWTk3K2FDSTYyR0xmRmxjK2U0T3hlSlJY?=
 =?utf-8?B?ZEt3elgzd3gyb2RVc1RIUWNkZitMcXJmUTVsOS8vSVZDUGI1VmpBYTlwUG03?=
 =?utf-8?B?T25WcU5TaFNrcW5VZGZKN3VsNDdEQm53MkJDK3I2N1NkRmNzR3pmdVQxcmZ5?=
 =?utf-8?B?M2dvbURBQlJKekRXQXAySWEwTUl6VWU2WUlQTUJsaFc3NU11QnJUN2dkMlpM?=
 =?utf-8?B?T3hXdWdGaUptMFM1My82UGdRYkZmVmRpTFByRWtTQVFqR3Z0Zkl2OGE3V2NQ?=
 =?utf-8?B?VnFtazBMT20rMzVNYUM1RWU2aXBzQnJ0d241Q0lSMVlURXFGVEVXcWZlUUZn?=
 =?utf-8?B?Z3A2VVVvWlcyZFZENXk2VjZkK0VvRWlpTW5MY2xpMTI5Y0xramtVTWFSOVA3?=
 =?utf-8?B?VzBGQUZGam0yaU05UEh1UzRvWkh1ZWh5TFdxMWlYV1pDdzkrRHFDU21ucmVm?=
 =?utf-8?B?RjJwOUxUZmRuZXNJRVUvWFZRQk1aQkNOUG9iRXpHaXYzdU1vZ0trclJVZmlE?=
 =?utf-8?B?dk1NMmo4RkZQMFd1UzhWVzlvZW5yMXZZSmNnMlAxNzRvalFQTWRSNWZ3Wllr?=
 =?utf-8?B?eklCMnB2VWpTT04xMmFLT09POEMvYTR0UHp1a1ZIUjNuZHZpUUdDN3hEZWV3?=
 =?utf-8?B?eERCYXpWQVczaXE3bHp2dUUyT2tWaEJNY1J0WmpEK0VTdzB6R0trSzZQQ2JM?=
 =?utf-8?B?RmFiemZFdVFXSlNTTFpNOGV5WURTTXQxbjFaWlFSME53NGtWNUpuak9uTE50?=
 =?utf-8?B?L3paL2tlM2hvM2JtRk10VlFvc2xnT3hON3NRcnVUekRxM2hTVndyRHBuZE9r?=
 =?utf-8?B?MXhUZFdxem0vdUR1TVh3M3pDRHlVRXlXVTYrMGpxVy93cWZlTFRJRTE0YUN6?=
 =?utf-8?B?MkJmU1RoZEJ2NVNQaW9NaFFlM0JWd2Y2b2NyMEtidUE5N2pMTTRDRURjd2pJ?=
 =?utf-8?B?ZDNlQU5QMVNVcGZSUVBCVDBjWDQ3VlEzQlV6UGw0NytVcGdBL2RtNjV1a3BO?=
 =?utf-8?B?ZithY1NIeHhmVFFERGp1a2Z4emZISVJ6cCtnMjZZUUVPVThuWHRsTzhjUmd5?=
 =?utf-8?B?ZzNIYzlqVnc3aEZDREo1RGlqN0JyYlNNZU9mVTIxdDlyOE1vS3ZxUUlLOTlk?=
 =?utf-8?B?ZUZVUGtzVE02aUkxdXQxZ1NsQzZ5TW1wc1FBK3FRNkRKbXp0M3MzNTl2cUxT?=
 =?utf-8?B?dGZrZDBGVTlMa2tJNlhzVVVYK2lCMThjZkdyTmFnemkxWDNHbTdXWkhONzMx?=
 =?utf-8?B?RXJwWm95blV4TGo3QURwTE9XdW1aQ01zdzhFVVZEby9WRVFlTEZ4dTBuNVRE?=
 =?utf-8?B?b25OMk9nZEhXZXVDa0hKdz09?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de728109-ae05-49e3-fbf7-08d9674c209d
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB3019.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2021 22:11:31.3365
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GFOFqEU8JMQ/lI3VFk8Kz49WV1yVlVGRdWP+ksRqP7tzud2qCRLpn91iMdQHCXGhfAcHZ3BO66hya3tIOD57xCqGlGJ43BQRUfl1Xr1nMm0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR10MB5400
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10086 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 spamscore=0 adultscore=0 mlxlogscore=999 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108240139
X-Proofpoint-ORIG-GUID: WUUheKqtUFXFJzq6VjCsGHn4BT9qONNf
X-Proofpoint-GUID: WUUheKqtUFXFJzq6VjCsGHn4BT9qONNf
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 8/19/21 4:33 AM, Varad Gautam wrote:
> EFI sets up long mode with arbitrary state before calling the
> image entrypoint. To run the testcases at hand, it is necessary
> to redo some of the bootstrapping to not rely on what EFI
> provided.
>
> Adapt start64() for EFI testcases to fixup %rsp/GDT/IDT/TSS and
> friends, and jump here after relocation from efi_main. Switch to
> RIP-relative addressing where necessary.
>
> Initially leave out:
> - AP init - leave EFI to single CPU
> - Testcase arg passing
>
> Signed-off-by: Varad Gautam<varad.gautam@suse.com>
> ---
> v2: Fix TSS setup in cstart64 on CONFIG_EFI.
>
>   x86/cstart64.S | 70 +++++++++++++++++++++++++++++++++++++++++++++-----
>   x86/efi_main.c |  1 +
>   2 files changed, 65 insertions(+), 6 deletions(-)
>
> diff --git a/x86/cstart64.S b/x86/cstart64.S
> index 98e7848..547f3fb 100644
> --- a/x86/cstart64.S
> +++ b/x86/cstart64.S


I am wondering if it's cleaner to create a separate .S file for EFI 
because so many #ifdefs are reducing readability of the code.

> @@ -242,16 +242,17 @@ ap_start32:
>   
>   .code64
>   save_id:
> -#ifndef CONFIG_EFI
>   	movl $(APIC_DEFAULT_PHYS_BASE + APIC_ID), %eax
>   	movl (%rax), %eax
>   	shrl $24, %eax
> +#ifdef CONFIG_EFI
> +	lock btsl %eax, online_cpus(%rip)
> +#else
>   	lock btsl %eax, online_cpus
>   #endif
>   	retq
>   
>   ap_start64:
> -#ifndef CONFIG_EFI
>   	call reset_apic
>   	call load_tss
>   	call enable_apic
> @@ -259,12 +260,38 @@ ap_start64:
>   	call enable_x2apic
>   	sti
>   	nop
> +#ifdef CONFIG_EFI
> +	lock incw cpu_online_count(%rip)
> +#else
>   	lock incw cpu_online_count
>   #endif
> +
>   1:	hlt
>   	jmp 1b
>   
>   #ifdef CONFIG_EFI
> +setup_gdt64:
> +	lgdt gdt64_desc(%rip)
> +	call load_tss
> +
> +	setup_segments
> +
> +	movabsq $flush_cs, %rax
> +	pushq $0x8
> +	pushq %rax
> +	retfq
> +flush_cs:
> +	ret
> +
> +setup_idt64:
> +	lidtq idt_descr(%rip)
> +	ret
> +
> +setup_cr3:
> +	movabsq $ptl4, %rax
> +	mov %rax, %cr3
> +	ret
> +
>   .globl _efi_pe_entry
>   _efi_pe_entry:
>   	# EFI image loader calls this with rcx=efi_handle,
> @@ -276,15 +303,27 @@ _efi_pe_entry:
>   	pushq   %rsi
>   
>   	call efi_main
> -#endif
>   
> +.globl start64
>   start64:
> -#ifndef CONFIG_EFI
> +	cli
> +	lea stacktop(%rip), %rsp
> +
> +	setup_percpu_area
> +	call setup_gdt64
> +	call setup_idt64
> +	call setup_cr3
> +#else
> +start64:
> +#endif
>   	call reset_apic
> +#ifndef CONFIG_EFI
>   	call load_tss
> +#endif
>   	call mask_pic_interrupts
>   	call enable_apic
>   	call save_id
> +#ifndef CONFIG_EFI
>   	mov mb_boot_info(%rip), %rbx
>   	mov %rbx, %rdi
>   	call setup_multiboot
> @@ -292,18 +331,24 @@ start64:
>   	mov mb_cmdline(%rbx), %eax
>   	mov %rax, __args(%rip)
>   	call __setup_args
> +#endif
>   
>   	call ap_init
>   	call enable_x2apic
>   	call smp_init
>   
> +#ifdef CONFIG_EFI
> +	mov $0, %edi
> +	mov $0, %rsi
> +	mov $0, %rdx
> +#else
>   	mov __argc(%rip), %edi
>   	lea __argv(%rip), %rsi
>   	lea __environ(%rip), %rdx
> +#endif
>   	call main
>   	mov %eax, %edi
>   	call exit
> -#endif
>   
>   .globl setup_5level_page_table
>   setup_5level_page_table:
> @@ -330,6 +375,7 @@ online_cpus:
>   load_tss:
>   #ifndef CONFIG_EFI
>   	lidtq idt_descr
> +#endif
>   	mov $(APIC_DEFAULT_PHYS_BASE + APIC_ID), %eax
>   	mov (%rax), %eax
>   	shr $24, %eax
> @@ -337,6 +383,18 @@ load_tss:
>   	shl $4, %ebx
>   	mov $((tss_end - tss) / max_cpus), %edx
>   	imul %edx
> +#ifdef CONFIG_EFI
> +	lea tss(%rip), %rax
> +	lea tss_descr(%rip), %rcx
> +	add %rbx, %rcx
> +	mov %ax, 2(%rcx)
> +	shr $16, %rax
> +	mov %al, 4(%rcx)
> +	shr $8, %rax
> +	mov %al, 7(%rcx)
> +	shr $8, %rax
> +	mov %eax, 8(%rcx)
> +#else
>   	add $tss, %rax
>   	mov %ax, tss_descr+2(%rbx)
>   	shr $16, %rax
> @@ -345,9 +403,9 @@ load_tss:
>   	mov %al, tss_descr+7(%rbx)
>   	shr $8, %rax
>   	mov %eax, tss_descr+8(%rbx)
> +#endif
>   	lea tss_descr-gdt64(%rbx), %rax
>   	ltr %ax
> -#endif
>   	ret
>   
>   ap_init:
> diff --git a/x86/efi_main.c b/x86/efi_main.c
> index be3f9ab..c542fb9 100644
> --- a/x86/efi_main.c
> +++ b/x86/efi_main.c
> @@ -7,6 +7,7 @@ efi_system_table_t *efi_system_table = NULL;
>   
>   extern char ImageBase;
>   extern char _DYNAMIC;
> +extern void start64(void);
>   
>   static void efi_free_pool(void *ptr)
>   {
