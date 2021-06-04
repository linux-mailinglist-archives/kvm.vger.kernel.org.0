Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDB7C39BB8C
	for <lists+kvm@lfdr.de>; Fri,  4 Jun 2021 17:18:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230320AbhFDPTs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Jun 2021 11:19:48 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:46106 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbhFDPTq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Jun 2021 11:19:46 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 154FFhg1118927;
        Fri, 4 Jun 2021 15:17:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=lkdmvMJ0L79F4fBteLVyjOkCyOTa9DFq93wn9vo2NQw=;
 b=atmPTtnGVqca3OzUIAYDIwHdaJlVvXS0ujseLq6jYYZfgHnOmToxenPNp1wJDDRRd0i9
 AYZrlxX7fb4Wk5qca+pWFwckbc1o+QT4vZufBQohvsfwDh/RviY7YyO1QbBFpL/eKheC
 gxMGQcNnAH/MmGkCQycUdR5BVYH9j8Jrf7CdOeUIg1IOd8qkUZXevufr9ZSl7xL/4Z43
 3jWiCKWPrTpeLb6KcVYU6FOabl3W4J6qNoINFYhYCSap4MNsWomY7LzIHlKPfOEkV3dl
 E2QdrxIqZxf9wK46W0jFps8qW0XesytDtGPt7mNWkaCzEhewjhOELF7CN+hiJr7BXx7q Nw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 38udjmx82b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Jun 2021 15:17:29 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 154FFelU022346;
        Fri, 4 Jun 2021 15:17:29 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2108.outbound.protection.outlook.com [104.47.58.108])
        by aserp3020.oracle.com with ESMTP id 38xyn3uxn2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Jun 2021 15:17:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AU6QKuORwFicpWZzYar2VtN/c19QCBPa3sq6EgJteHWvlkgozJlc420NEIzZAgSVmhwFf9PkpWtrt6PtGSwe5x8yG2jyoU75gyZp48YT/e3w0t0lx48rb2NY5CqAsNUZXznjSXX+Xk5OysaT8L6/3IySssGOVsge/7Wil+jJOKlIpkIa5qWZYfACOuOFe12zjtHIXD5B6h2/Alp8XJKiTF3ibyoQ92gMAHKYFGn/WZehJIh1EXhUPy6JKlioqYMOkfxUqZE6sH/xACRIVDbbh/haCg6lt/8aJ+gHmiLWfQaup9TneyjETQYHoEvz6cbI1x2dCiQOafJAe8XkEx6jig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lkdmvMJ0L79F4fBteLVyjOkCyOTa9DFq93wn9vo2NQw=;
 b=k9ymQy5yPKDLwF8QQlpxSlcHpwPeY1mX3JQ1zXll0UVBbt3XMrQhplw041NCh0YRXN+GQrF7NqbdvRmeLInEwQ6tYA7X8xJ1QJDt4d0kZSBN+9nY2FqM8UjxdkNkyXH61KSViurNQYaUs+A5DdLNGmw065Va6Xrp1DprYsZgj4keY2evS38ipoedRBbTbP4bamI8Dk5E6PVfQUj9uQC+l/To8Vk5xgMpqy3huNV/fGoaIAVQ4QrAiBnvJkzUXuCkYx6/5CB8lpbaa0cRgFtWgJKjxgC3/D46U63BZUSWxrCSwSGy/+M2NahXUbgbiwM8WTq/t8e3W0JjQRSZa4GXmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lkdmvMJ0L79F4fBteLVyjOkCyOTa9DFq93wn9vo2NQw=;
 b=cf/5aAY9XWDc52kUyoJpJztwIIrT8IvXVsSMoRDUU6XCnUdGfOqO9kA/K0+29uxg5WBkdMGTpEKGw868aCdjKlUmzC7ZquB4raN7/R5MBgaxvAudmUgwDOcqNZlwgX7yw4/w6Un2VNrwzC4w5jQL1lcmreLT/CaSNF9ifmaYl0Q=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB2999.namprd10.prod.outlook.com (2603:10b6:a03:85::27)
 by BY5PR10MB3971.namprd10.prod.outlook.com (2603:10b6:a03:1f6::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.22; Fri, 4 Jun
 2021 15:17:26 +0000
Received: from BYAPR10MB2999.namprd10.prod.outlook.com
 ([fe80::8111:d8f1:c262:808d]) by BYAPR10MB2999.namprd10.prod.outlook.com
 ([fe80::8111:d8f1:c262:808d%6]) with mapi id 15.20.4173.027; Fri, 4 Jun 2021
 15:17:26 +0000
Subject: Re: [RFC PATCH 0/7] Untrusted device support for virtio
To:     Jason Wang <jasowang@redhat.com>
Cc:     mst@redhat.com, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, xieyongji@bytedance.com,
        stefanha@redhat.com, file@sect.tu-berlin.de, ashish.kalra@amd.com,
        martin.radev@aisec.fraunhofer.de, kvm@vger.kernel.org
References: <20210421032117.5177-1-jasowang@redhat.com>
 <YInOQt1l/59zzPJK@Konrads-MacBook-Pro.local>
 <9b089e3b-7d7a-b9d6-a4a1-81a6eff2e425@redhat.com>
From:   Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Message-ID: <e8a35789-5001-3e17-1546-80fa9daa5ab1@oracle.com>
Date:   Fri, 4 Jun 2021 11:17:13 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.2
In-Reply-To: <9b089e3b-7d7a-b9d6-a4a1-81a6eff2e425@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [160.34.113.159]
X-ClientProxiedBy: BY5PR13CA0008.namprd13.prod.outlook.com
 (2603:10b6:a03:180::21) To BYAPR10MB2999.namprd10.prod.outlook.com
 (2603:10b6:a03:85::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Konrads-MacBook-Pro.local (160.34.113.159) by BY5PR13CA0008.namprd13.prod.outlook.com (2603:10b6:a03:180::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.9 via Frontend Transport; Fri, 4 Jun 2021 15:17:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e7f79873-eb85-4c83-3471-08d9276bdc55
X-MS-TrafficTypeDiagnostic: BY5PR10MB3971:
X-Microsoft-Antispam-PRVS: <BY5PR10MB39710CECDF621A624DD82309893B9@BY5PR10MB3971.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: De4mhXAwhA6hIeBmz+F6y4Jad/A95QDjh3NruzXUpHqI2BnKN/SvJLjexWjUEJ9/8Fsna43rghRsaEcqT+BqAcS+Im3n6pLQOwGCqmxYsNKruJXMNIS0EbDn5mhlXnkr/Ipw91XrQHHNTc7X6KPY64u2I0IdWXP3grWPLDMwvhmaJt45nmdUzOld/5nTtXpnmK7qTb56EBfUGv+ZH8fbyikqbmJFIjX/oE476ZvbRkN6gWTaEoODeJ3Vll7W+Gky9AJ5yr+v8mk/07JZ0X/HYwXRWOd3IIiyzm3lk8PmusBJJhEhCILcnkqrb5R+pSqOcJrwhHgVrJx+I+/b6wZcrS2kytbr1oSy7FgT94BELW1LeSr7oI5seFuzhXJrM8wVnwLiAHuGuZu2RI/znK+Uc+ZJ+A9MXRcaQwCAyvNTMml+3GlCceOKuVQu0tvosfXC6uxzji06+KS+oHnyxQ0xzSJe5JGtPKFkQs/ZEA6swlxkOZfvuIcR5IwYMe7WVkSnOcIq/W+S4OeYfVCI9TxAnrUDkoTYVUvuLr23Lz/tyJIj6lxO0nyGEvFBJDm117HgtC36L98BgeRQT0wigYtOoibVC1nbBpiNep0JNQMHhRgCq/nW/JR6IFq+JZBxn8WmtQFlDDwtddws+BkB9ZmI0euwZYl1rWHZLqv1QHOPgch5ycew4b+IN5GCsrhDPaa6zEtYjCtHWDi+f1Erdb+gw9aC3KmR9eQ2cGqMgMuJR7SFM/JZlJtXBf8YhIFxLqcZkFPGLnReJiPK/TwLos7qksVZrUGMIy7dtO40U/JwaBo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2999.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39860400002)(376002)(396003)(346002)(136003)(6666004)(6916009)(5660300002)(6486002)(31686004)(6512007)(38100700002)(83380400001)(36756003)(53546011)(86362001)(31696002)(6506007)(956004)(966005)(2616005)(7416002)(4326008)(316002)(2906002)(26005)(66946007)(66476007)(8936002)(16526019)(478600001)(8676002)(66556008)(186003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Nk0yVTJycjlRSFhSN0N4TTNHcGNNcXF6Z0xXV040NFR3S2x6UGJYWktGdGdZ?=
 =?utf-8?B?VDhxd2lLajFLanozUzlrR3JTZjBCWUNGSS95NEhKU21wNjRSU0IwaW5oK2Vt?=
 =?utf-8?B?b2RIVk4rSlh5MTU1Q2dEQW92TmdXY2FjQkhqRHdISTdFYW5zZWdlSjdnL3Jz?=
 =?utf-8?B?NDg1ZUJWYUFUaEhOYm9ZMnVqSHhSRVY0VUpjaHpjQVlQV2JhcFFMYlppcmlo?=
 =?utf-8?B?Yy9QdHVSZTEvcHM1ZmNBODVrVkppRngyNE1KVk16YU5LQnpSNU9NbCtUNjIz?=
 =?utf-8?B?c1dnVmVaQlJPNTZyK2Q2V3RiR080RGJJWmUrNHZHK3piYlZZYi9WZ2R2SEpK?=
 =?utf-8?B?Qno3UU5jVkJLSDUzM2x0UE9LazFEUk11dittSUMxZlRNMTdxbGY1UlM2L3lD?=
 =?utf-8?B?UVBOOTd1WGVRdUdFcWpLM1hWaFN5NkgxSjk3a29kTHdXblVYZEUxTjl5eUJj?=
 =?utf-8?B?dDZvSE9ldUNjOERVWDk2MHhXcnArcE9yaWRCTUtmcDQ4NUxyaEJJRFg3MFdp?=
 =?utf-8?B?SHBzbENLWllhSzdnV1dqZlU0Y1JqS1NlWjFQZUdKQWlHeDYxbmVuS2Y1ZjV5?=
 =?utf-8?B?dm5rYXRIbzh2dC9tWnNqWHllMGhaNzhKK0d4Q1hoMEZ3NyswVmxtNXhtUHlQ?=
 =?utf-8?B?QXN4ZURUQnV5Vzc0QTVzc3NGdXBhWFprTHNuK2JZZ0tUQk1KZ3lIU1EyUDJB?=
 =?utf-8?B?bXc1ekN5UnkvT2hFY04wdXNTUkVsMmRnLzBmeDNUUFMzMnJrWWx3VFhxQkc4?=
 =?utf-8?B?QUQvUmhlNFUyaW9wcFV4VC9zaXlQUUloT3RCUm9hOFMxNFBFRE51MmZOQW1a?=
 =?utf-8?B?OUxqd1dieFhtTHBFNmlFZ2dHWnFvZXMwT1RkcDJOSzg5VU80amhRZE5jZm5O?=
 =?utf-8?B?d2FUbFc5L3A0T2JobklVMDNTVVppTmNqMEtWTEovWjA0WVNYTENueVo5dkcv?=
 =?utf-8?B?VWgvUG1WTnFidW1qUTdGZXRrYkNNdUZNbCthNEtGenV3TUpta0RPSnQreXlp?=
 =?utf-8?B?TjQ1NTFwSG1QQ3FPU25WNTVoTlpKbVp4SlpSZjJWQThnWWFROVdPZDFBNy9C?=
 =?utf-8?B?eDlidnJVWml1SkZXekZDQ1Bjd0VIb1FpQ2FqRDVEbnc2a0ttVGNQaHFEQTZ0?=
 =?utf-8?B?RFlnUXlyRzdWeTkrS0V2cndGWWhLSVFrMXNvQndRT05SWkNiajBmOVZ5MVJ2?=
 =?utf-8?B?MFBBVnNiSmVmcmVRU3VZU0QyclNvZ3VUWTdHUW9wUllPeVpOZFhyOGJnUFlQ?=
 =?utf-8?B?Z0FUSU9zVlo1bURaKzQyNkdVQ1RybE5IYU5Xek5vSFRUODdJN3k4bHNIYWpz?=
 =?utf-8?B?WkV0VFo4V0oyUVFEUEkyamQxNDloR0Z4ZjR1V3czYjA1aXdQZmdtOWM5RXp5?=
 =?utf-8?B?V2RZQ2Z0VXk0SmwySTRZd3VwYUp2S3crbGdMMDRhZmxmTGpNZUVoSUxscjVJ?=
 =?utf-8?B?clprSnpaY1VaMTIrS1VtQ0J3VUZ0bGVLMTlGWUhhN3ZhVzU0bjhyY0M5NG5i?=
 =?utf-8?B?ZHdRQWltNHhVRVIzRlRNSVVqTXBBVERNclBzVjYzSDFnclNnSTdSb0JmZWNl?=
 =?utf-8?B?d2ZnUStKWGMxMmY3bkdRVkgyT3QrSWsyMUtzK00xNm5hZjRNci9OWjYxQzN3?=
 =?utf-8?B?UHpseUxrMUFBeXFPVkZNQUFGNXFCRXF1WnhBeHFLQWZLbXZJQzU1eHpQUDlW?=
 =?utf-8?B?a29FaERiT0RyOGhJSk5vNzRBT3loMWh3cXBvamUzV1B2OUpxR1d5K1FQL29x?=
 =?utf-8?Q?jlOvWABn+Lfe2VdRN7s//PxydUsQnzG+/wtCMUy?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7f79873-eb85-4c83-3471-08d9276bdc55
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2999.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2021 15:17:26.2030
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xnVh+4zYFtARLnDHhx+QAGcO7utjOBStIVlyQVSPOes/Gl3vQU7m8moNmK/7PJNiWLhjvS+ejEDL0uHAjjVVew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3971
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10005 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 bulkscore=0 suspectscore=0 mlxscore=0 malwarescore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106040113
X-Proofpoint-GUID: xWAyF49LS7lSjX8NkiqydekofsMfSr0B
X-Proofpoint-ORIG-GUID: xWAyF49LS7lSjX8NkiqydekofsMfSr0B
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10005 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 impostorscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 adultscore=0 spamscore=0
 suspectscore=0 bulkscore=0 priorityscore=1501 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106040113
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/29/21 12:16 AM, Jason Wang wrote:
> 
> 在 2021/4/29 上午5:06, Konrad Rzeszutek Wilk 写道:
>> On Wed, Apr 21, 2021 at 11:21:10AM +0800, Jason Wang wrote:
>>> Hi All:
>>>
>>> Sometimes, the driver doesn't trust the device. This is usually
>>> happens for the encrtpyed VM or VDUSE[1]. In both cases, technology
>>> like swiotlb is used to prevent the poking/mangling of memory from the
>>> device. But this is not sufficient since current virtio driver may
>>> trust what is stored in the descriptor table (coherent mapping) for
>>> performing the DMA operations like unmap and bounce so the device may
>>> choose to utilize the behaviour of swiotlb to perform attacks[2].
>> We fixed it in the SWIOTLB. That is it saves the expected length
>> of the DMA operation. See
>>
>> commit daf9514fd5eb098d7d6f3a1247cb8cc48fc94155
>> Author: Martin Radev <martin.b.radev@gmail.com>
>> Date:   Tue Jan 12 16:07:29 2021 +0100
>>
>>      swiotlb: Validate bounce size in the sync/unmap path
>>      The size of the buffer being bounced is not checked if it happens
>>      to be larger than the size of the mapped buffer. Because the size
>>      can be controlled by a device, as it's the case with virtio devices,
>>      this can lead to memory corruption.
> 
> 
> Good to know this, but this series tries to protect at different level. 
> And I believe such protection needs to be done at both levels.
> 

My apologies for taking so long to respond, somehow this disappeared in 
one of the folders.
> 
>>> For double insurance, to protect from a malicous device, when DMA API
>>> is used for the device, this series store and use the descriptor
>>> metadata in an auxiliay structure which can not be accessed via
>>> swiotlb instead of the ones in the descriptor table. Actually, we've
>> Sorry for being dense here, but how wold SWIOTLB be utilized for
>> this attack?
> 
> 
> So we still behaviors that is triggered by device that is not trusted. 
> Such behavior is what the series tries to avoid. We've learnt a lot of 
> lessons to eliminate the potential attacks via this. And it would be too 
> late to fix if we found another issue of SWIOTLB.
> 
> Proving "the unexpected device triggered behavior is safe" is very hard 
> (or even impossible) than "eliminating the unexpected device triggered 
> behavior totally".
> 
> E.g I wonder whether something like this can happen: Consider the DMA 
> direction of unmap is under the control of device. The device can cheat 
> the SWIOTLB by changing the flag to modify the device read only buffer. 

<blinks> Why would you want to expose that to the device? And wouldn't 
that be specific to Linux devices - because surely Windows DMA APIs are 
different and this 'flag' seems very Linux-kernel specific?

> If yes, it is really safe?

Well no? But neither is rm -Rf / but we still allow folks to do that.
> 
> The above patch only log the bounce size but it doesn't log the flag. 

It logs and panics the system.

> Even if it logs the flag, SWIOTLB still doesn't know how each buffer is 
> used and when it's the appropriate(safe) time to unmap the buffer, only 
> the driver that is using the SWIOTLB know them.

Fair enough. Is the intent to do the same thing for all the other 
drivers that could be running in an encrypted guest and would require 
SWIOTLB.

Like legacy devices that KVM can expose (floppy driver?, SVGA driver)?

> 
> So I think we need to consolidate on both layers instead of solely 
> depending on the SWIOTLB.

Please make sure that this explanation is in part of the cover letter
or in the commit/Kconfig.

Also, are you aware of the patchset than Andi been working on that tries 
to make the DMA code to have extra bells and whistles for this purpose?

Thank you.
> Thanks
> 
> 
>>
>>> almost achieved that through packed virtqueue and we just need to fix
>>> a corner case of handling mapping errors. For split virtqueue we just
>>> follow what's done in the packed.
>>>
>>> Note that we don't duplicate descriptor medata for indirect
>>> descriptors since it uses stream mapping which is read only so it's
>>> safe if the metadata of non-indirect descriptors are correct.
>>>
>>> The behaivor for non DMA API is kept for minimizing the performance
>>> impact.
>>>
>>> Slightly tested with packed on/off, iommu on/of, swiotlb force/off in
>>> the guest.
>>>
>>> Please review.
>>>
>>> [1] 
>>> https://lore.kernel.org/netdev/fab615ce-5e13-a3b3-3715-a4203b4ab010@redhat.com/T/ 
>>>
>>> [2] 
>>> https://yhbt.net/lore/all/c3629a27-3590-1d9f-211b-c0b7be152b32@redhat.com/T/#mc6b6e2343cbeffca68ca7a97e0f473aaa871c95b 
>>>
>>>
>>> Jason Wang (7):
>>>    virtio-ring: maintain next in extra state for packed virtqueue
>>>    virtio_ring: rename vring_desc_extra_packed
>>>    virtio-ring: factor out desc_extra allocation
>>>    virtio_ring: secure handling of mapping errors
>>>    virtio_ring: introduce virtqueue_desc_add_split()
>>>    virtio: use err label in __vring_new_virtqueue()
>>>    virtio-ring: store DMA metadata in desc_extra for split virtqueue
>>>
>>>   drivers/virtio/virtio_ring.c | 189 ++++++++++++++++++++++++++---------
>>>   1 file changed, 141 insertions(+), 48 deletions(-)
>>>
>>> -- 
>>> 2.25.1
>>>
> 

