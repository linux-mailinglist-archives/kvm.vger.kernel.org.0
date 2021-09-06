Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3214E401F6B
	for <lists+kvm@lfdr.de>; Mon,  6 Sep 2021 20:04:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244390AbhIFSFK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Sep 2021 14:05:10 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:1586 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244385AbhIFSFJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 6 Sep 2021 14:05:09 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 186H3unx025573;
        Mon, 6 Sep 2021 18:03:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 cc : references : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=1wDBYweWxWoV6IAeVw0hh0qSubjHjLciNGi7iYWacDw=;
 b=iOnsGg5FsMxYalhWK80SNxNovjp5cABTGV9Tf3nQhzq3LIpfU9snj1e8IlFTbMnsAHHx
 B/zzyxMGp3Jo9GjDD11zlFy7xxegfIy4vOKnnx/qXEiGX0CshL9KGMSTyhJMmItEQvcY
 idhW6g32y+uBIpsi7Popg8hCTtk8jaogbV/Vumz8wuwI/nVP8W11NFdGnhEjNWfH4O3H
 Jbrz80ph2IcA6AaPkD1kdwEbBZBK3Dn48qwk/dkQWeQVXxBL+OVbvpB3WIJCynKTo+X0
 QNieN0w7qEef0vANDztuI494I1BN2O926+gVMU80g0pmpd1pMueuKekgmJpByxHBI9d1 Kg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 cc : references : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=1wDBYweWxWoV6IAeVw0hh0qSubjHjLciNGi7iYWacDw=;
 b=GRYmrvwZC9+Egl+RU8XqUU+bhF5FHAQ72N1/DAZnbeOP8CImQzuVKV1MpIKjT4d0uIfY
 3k7l6/Zyu3izxWkGPZahn/ixPLo+vEmKFcOpd2XFNz5n4kEkUa8yFT3rwlbubAFHinQN
 WIg0yXq9EkTQLcLZwXGwosoSYZiFgy2sG9fl0X3ROz/lrfvTlvzhBjegTdE2Bt5dVJze
 wrDT5EIpXOAFfMLxqOOspwQ4ZzE9lAEbKV57XJ3tgnBQmQbBCr/GrcsDZIhjAMWdp9jS
 l1ynaADubMXbgI0E8qdY5r1Z/Ewin7VhadQollZw3MaQe6/sVFsLhoTIr+PxIZj3drsQ 4w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3awq29g273-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Sep 2021 18:03:59 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 186I0jAQ085134;
        Mon, 6 Sep 2021 18:03:58 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
        by userp3030.oracle.com with ESMTP id 3auwwvp30d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Sep 2021 18:03:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZvvL9ubpsvIo53RPAWTFUZbzBwgF0hLEs3M7Yw3+rzkOyOtr/1nXXR6dRNhUA4r9PkcWSwjUQMd0Rdyywgbu6VacygMDktI3hVJsMB5ySmsIpOaChG16RSMpy+nkQP02Qb/Sgoerfyq8lFJoLdHBbcc7AFXGojC2KLEu7M9JF+cPOBgFKxLCLTPZIGCixLQTOLw1JPAzAqbhCU/uljShVp2bFbMSAqQ59ben65hkxYymYYcim+2ugk7G5bfz/8LQXdk8jnTj4qLo1sBCsUMEF/Sqyejxp/XB6zR7JtkMpjGKPl1/NAi52TPvwKnIE1lQxjl7pWMBjlWjwtamZrKzjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=1wDBYweWxWoV6IAeVw0hh0qSubjHjLciNGi7iYWacDw=;
 b=Pg0HEVd4/yOmHhWcUqZVNSJXdDL5qgsSSwT6jZLG81oLxRHXV/25XNeQPhVHynBUJWxE9cHfbQSYGKiZ101ZrOLKdr5y61F8tTq6tTNAh852oV3xN8LvvtJfPM/XFpQtuwfCgTpvsyTozpNxC/Xotbyh4UGL+V1S7Z4meSKIDlKIbJrT2+douzkvXXuUbdhLKETKSyQ938A8XrcJY5MjBA9OZWrZytkef/RaRgsLDGpuPnZotj4pqGOoqjysgikvPJLEHuxC93MKMPIo+CDEjTLKI7xD71AtRJodTVskxES30O2dfRlOQJoCqDbINOW75+HA9CxOflbmDbIGVyWFng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1wDBYweWxWoV6IAeVw0hh0qSubjHjLciNGi7iYWacDw=;
 b=RqHhhpVVvLVTMKb8spuIhWpsDNi3PdR5m6eH0xszwPqe5c4N38IBTdjyQryd/JAiYuu1gfcwMqWYQ2sP7/NmUUPN67mwSLU1o4folXsEpkSj1qxdbMHhEUhRbc2oZw5vnC2xBqMNZjPDj0sgTjn4qM0yMpZb/wsfbun1cls+X6I=
Authentication-Results: lists.cs.columbia.edu; dkim=none (message not signed)
 header.d=none;lists.cs.columbia.edu; dmarc=none action=none
 header.from=oracle.com;
Received: from CH2PR10MB4008.namprd10.prod.outlook.com (2603:10b6:610:c::22)
 by CH0PR10MB5243.namprd10.prod.outlook.com (2603:10b6:610:dc::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.24; Mon, 6 Sep
 2021 18:03:56 +0000
Received: from CH2PR10MB4008.namprd10.prod.outlook.com
 ([fe80::18f4:28d6:63f1:58e8]) by CH2PR10MB4008.namprd10.prod.outlook.com
 ([fe80::18f4:28d6:63f1:58e8%5]) with mapi id 15.20.4478.025; Mon, 6 Sep 2021
 18:03:56 +0000
From:   "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
Subject: Re: [PATCH 2/2] KVM: selftests: build the memslot tests for arm64
To:     Ricardo Koller <ricarkol@google.com>
Cc:     drjones@redhat.com, Paolo Bonzini <pbonzini@redhat.com>,
        maz@kernel.org, oupton@google.com, jingzhangos@google.com,
        pshier@google.com, rananta@google.com, reijiw@google.com,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
References: <20210903231154.25091-1-ricarkol@google.com>
 <20210903231154.25091-3-ricarkol@google.com>
Message-ID: <bd8c25e3-3516-ad9f-b3c0-d8829c951c47@oracle.com>
Date:   Mon, 6 Sep 2021 20:03:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <20210903231154.25091-3-ricarkol@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM3PR03CA0063.eurprd03.prod.outlook.com
 (2603:10a6:207:5::21) To CH2PR10MB4008.namprd10.prod.outlook.com
 (2603:10b6:610:c::22)
MIME-Version: 1.0
Received: from [172.20.10.2] (37.248.175.250) by AM3PR03CA0063.eurprd03.prod.outlook.com (2603:10a6:207:5::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.19 via Frontend Transport; Mon, 6 Sep 2021 18:03:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d06d4e23-c30b-4e95-b947-08d97160b1dd
X-MS-TrafficTypeDiagnostic: CH0PR10MB5243:
X-Microsoft-Antispam-PRVS: <CH0PR10MB524360EBC36070E818F9B9C1FFD29@CH0PR10MB5243.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1923;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bfmGuh/rkmYGI0s42N/A9I1Y7mpB6dzaVH/XmWPvihSOwMRqCclBCIu1fm+YSA724MFTAdCuOrV0Z0/nBhNblrpxCbvruZgpEodvYj9vFbg4fUpNeuCaI312hV7SpeTcsaSGlGd7NVleS11imKWzi5KoFhhWZisXd2el4eG76sazcOOrYMRemqs4oiYa1lzGUW8pvJWoy2dsCRMEuWFu599UwvRB2MZqrNyAyjJtzdFluJ5RmtlaOpVSuyNbLiSVLovpnNf/Zaam5nsFWh/YG3Mf6xsl/IIi4b+3p9TNSJf47qBBluU5IdPkYyVfa3JOTnUU+GHIRcOxs6tmfQjYpQYmqKTC21NGLXZBw8VvWk+KQyDFHZvBRLcmHj23knW39Qe6ukE3as4oezs/cAhxjBkfqXRL1PU6YMlXtSbvcb7aBPSKXqRpSOKbV6FvTjtznDtxPlZ/KjvU7EOoluM+G5GTwkE4rI56ziAmIeqkOlg4jRNI1w7iVuxSwNAIRvBnKZgIUjtlaBO0ngsJG8pJHTND+76H/6tOFtGKYpN8rfm7zT4tB/sB5L/kVyBOdphTyYpU1kBGY3XifRn0JUlKXf2knV8jb8I0rOKzu3rKh9KouXIJ8ge94XM2TqssuI0YRRLBbojwVUVGlAgdthTWmtgP3h/76dVHquNBBhwvRjYYHE/0LgYJrQoIiTiRetKld8ZUbKmfeYKvdN3/ZONn9QSe9zytZixdg8KMTyUj3BY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR10MB4008.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(376002)(39860400002)(346002)(396003)(53546011)(2616005)(8936002)(7416002)(4326008)(31686004)(38100700002)(86362001)(558084003)(5660300002)(31696002)(6916009)(36756003)(6666004)(316002)(8676002)(66946007)(186003)(6486002)(66476007)(66556008)(956004)(26005)(478600001)(16576012)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NjYzNEc5RFZQL3QxOXBmYVFJL1p2U1lscW42alVyRStscjBCYS8vNlZaNnNQ?=
 =?utf-8?B?N3NiekZ4YWExN3BKSTAwbGlWZFc0TU1VclJ0NDg2RE0zSDhtNGN5ckZJaitp?=
 =?utf-8?B?WEhyWXBlaFl4c01laDNCWnI1ZTlYdWZFWjFlUDNkeXZnNUFiNnVDL1UvL2xr?=
 =?utf-8?B?bmVDK2JtUWtXR2hmSW9IcU81REVrTWo3THFBNTBoWFc0enJad2dnaThka0Zj?=
 =?utf-8?B?aWFubUdkaG1KOTNjM1BYVWg1WFFkc1MyWHlDNkIvNitCRTlPR2ZLL2FOMkZJ?=
 =?utf-8?B?b0hTMFphMVFNZnFoYmtSVTJHM2x4LzJxTE1abVdqQWZrMkkzZjZPeWoyeTg5?=
 =?utf-8?B?SmRPYXhraHZHbGNrZGRpQmhlN0pwUm55Q2tVcGtTNWdZQ2hkKzJNSXNoTTlr?=
 =?utf-8?B?K25Xemo5RGZvNHVLRzU2Wm13aEJZcVdremxzL1RwTG1ucmNsazhNUGEzcmp2?=
 =?utf-8?B?QTZFWnFPdWlzSHBZVVpDckYxMS9DYkdLRlR6T21RVmc0V3JFcFR3SE1abHhS?=
 =?utf-8?B?aWdGeHFsemR3ZHhyTVl5ZnhiQmd5ZU5DUXVTWlFIa2gzRy9KamFKZ0RqbmFx?=
 =?utf-8?B?MXJNdnQ0UUZYSWM2QzA5WGpyTjJQSjYrV2xQbzQwUWF4SjdZdm1CMmxLMFRj?=
 =?utf-8?B?YmRPUFhLcFhyT244b2l2MDBaQXBUTm9XMkhZY0tyWjVieFBsK1ZrQmE0Y0Rp?=
 =?utf-8?B?cWlUMUliMW92WWF6RW5ZNXorYVgwZWtJU0NmK1RZekcyRVc2VFR2MXc3cHhx?=
 =?utf-8?B?ZWt3T09CSnFoQnF1dnFhUUVXeVJXdFhRQVI2RjUvZ1VDNDRBQ2l4TE5FaC83?=
 =?utf-8?B?clgycVhwVEUyQys5VjVNV3JnL2tOWTNFZVE4Mk5XQ2ZxYkF2MTFISnYvTDVP?=
 =?utf-8?B?M1RQWFVCTktBNEExelBqMXpOTGtYbHF3UkFHSHZEVU1FSmNvRVVDeTl0U3BB?=
 =?utf-8?B?U3o1Znc0Z1pOeGIzWkxkbk9JdUJRUmV0elZzOUNrcG5uWnp5TWJLQitENmVM?=
 =?utf-8?B?a2RWZUZxbGZqSjk4bmVJZmwxck9xZnRiRkp2NzB6UDhyWGpBUTNJZ1ZVUlJ5?=
 =?utf-8?B?SUZGOU5zT1FZZUpGMjQ0MGR6eWYydXB6cDFCQTRIR2k5THptZExOZ0NudFFF?=
 =?utf-8?B?Q2JIK0N1SGZzQTR1WU0rVkFTWElpZ0dscSt3b2EyQUVERjBtR0ErcjFkWkUw?=
 =?utf-8?B?U0hpZGVoOENtQWVPMkFLV0VLMGUzTUJGaUhjRWF5QXBUZ3Z4dlBLQkh6MHJp?=
 =?utf-8?B?K1liS2x1YjFCV1dPU3pteStHVHAvYnJlM0xaY2pTVU96azhTY3hDQmFoTzd5?=
 =?utf-8?B?Um41d2YvS1V2TCtJbUVrQzJnYi9sY2pvdmRIVW1HQW1mUFAyTThKSWs3S2lH?=
 =?utf-8?B?U0k4KzY4c2psK3VobmpGZFRRRFJxYmNTTmhvMGpjaXVicGVzSmtUZDcvcXNz?=
 =?utf-8?B?a3lkMHJseFA4VHU3UmtTMEVublpqZkQ3SlRSdXpRbW9mN0dvd2JMUWN1Tmtl?=
 =?utf-8?B?QlVpNkNab2Jsa0QwaWwxeE1LL29IMkttYlBieFcwQ0xxWEJwTUxPbzlFRUpL?=
 =?utf-8?B?M2tuTGo1TkJVM0RpNHRUdUdpd1pxaHphQUZBWU00N2ZQYnpkMldtSE1UMDVS?=
 =?utf-8?B?OCtZeGRYSkIwdkVGc3JEM2plZGpuT0l2ZnZialdUblBrR1YydnI2eGtXQmM5?=
 =?utf-8?B?Mmw0VWFSOTBUUkNTc0dzWXNHdWpNZE5rZGhpMDBMQllGd2w1RWhOa2dRRkd1?=
 =?utf-8?Q?KqxhTOd0eonPPz51qWwksYsM0K55IXDuy42knr1?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d06d4e23-c30b-4e95-b947-08d97160b1dd
X-MS-Exchange-CrossTenant-AuthSource: CH2PR10MB4008.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2021 18:03:56.5922
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Lw6rShJ8MYBHhCNR6LonSV+p6LZy4wttMfc1ExfXi1VZTMT3d9lV+s6GiYq70BUuqW9PnV3+PHEzBloC/l1YTfYtHCjxc18PqKgk41B/oZQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5243
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10099 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 mlxlogscore=999
 adultscore=0 bulkscore=0 suspectscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2108310000
 definitions=main-2109060115
X-Proofpoint-ORIG-GUID: f64cUaWeBNzQd4_0ea1UXV5bPkieAyYz
X-Proofpoint-GUID: f64cUaWeBNzQd4_0ea1UXV5bPkieAyYz
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04.09.2021 01:11, Ricardo Koller wrote:
> Add memslot_perf_test and memslot_modification_stress_test to the list
> of aarch64 selftests.
> 
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---

Reviewed-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>

Thanks,
Maciej
