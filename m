Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3AA6308FF1
	for <lists+kvm@lfdr.de>; Fri, 29 Jan 2021 23:23:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233540AbhA2WRd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Jan 2021 17:17:33 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:54190 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233199AbhA2WR2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Jan 2021 17:17:28 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10TMFY2u150827;
        Fri, 29 Jan 2021 22:16:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=FPDTNP7IUUai3YIZazEGEOzlM0TNqusyudVGZjcsV9w=;
 b=REkn36Vaig8kUtlbrgtVPkcUTE5ppKmlzeQ49fMHLc8e6VDQ/PqLeECxSWOATwJ+f1hw
 SydjXkIq4grcHdULLKdP1JWzMJHUlTWJTYFqs8hq1qM/8CQJKC4BkrVzsY4/wrnusbjL
 VPM/aIIxbdqLd2W/CXWAAYMmIlTXY4ovCz3bTPNdQEdAkBDghyitcXE89eAdjveWM7TY
 GudDjjvFsV8n53Ux26r2Tkop6KZyJEWZS/WwyTEiRZj6BlcuWvSn9bLdELHMLZKupGVj
 uiG0HMjGUdie8KvQPLHTWWdZ41r/jtI8orsDKl66kt0Arcm8UfSdmb9+H3ZHHnqqEZpq Og== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 3689ab3mbq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Jan 2021 22:16:41 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10TM5GJo095782;
        Fri, 29 Jan 2021 22:14:41 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
        by aserp3030.oracle.com with ESMTP id 368wcstyba-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Jan 2021 22:14:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ny4P4rEhCXesEt2RNJEJkCbjKVC7HZvE8epoTRPN+Hv2YJbWTW5XnQYi5zJau2pB8nHcrs+ltzWbua+rLVNDAYFvB5DLy5vbY4IGItZ7Gz9ojxWpXv22MEiEh5P6mMampNO4QtsQ+rNmwAO4u8tjUG7+eHf7GmXf4WYO0WJul56K5eYxLU8m61IROmAvgjOKBp1yEMiyKkmdoHzP0BFszGR+jvSJEq6LyC1uNPWanaDwlFSwF5ABfFwmJZMvBWUnnHKl3YqcXgK/vE3DAanoSbyXXP+uk9BcJosnrcah94ScgAk/5CM3WwETwTwl3X6AWxQyafObgCTueHMXcvz5AA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FPDTNP7IUUai3YIZazEGEOzlM0TNqusyudVGZjcsV9w=;
 b=R2pbZEy6F+Ph+meV3D0ZIDxWYJQyhGSTjO0lmnfhU7cE+zqrWdBVCA1SmOuWmHMlGtoCLlrGBgl1IuS3l8higeWhiDigNHroSxIxe8Pk5qAD8hoAvBPxhE2DhNs2gwGZiH3Y4/PyL5jZOj0nYTx4ld97wNstF//1E9CMoUbdQZ4g+1TYbdCIqz8Syo3O4BYYNMEPZwOv+Q+f7gqKQxtF+Ub7Ad0EWnu/EPq7zd5ZDcA3g5kndYP74XorNaEuPFkfytgkTR4mpQXxgwc/Y90kWxePphnTtmHi1LJmsJ1FD+djMG4+STsIdgcUl45iMCZkvH1laO+bIbjOunJMSYUC+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FPDTNP7IUUai3YIZazEGEOzlM0TNqusyudVGZjcsV9w=;
 b=QISgnrLer+hnETaOeuuFxUxmAFGuuLna5alBiJ8ZEaC3r/V/wEnVTTu/BRTAYaQ3b4aA0cXqz8O2uRM6vpQOjmApWakz36eHeCuVv0ogg1qNcTUexg6Kf7uQ7HmKJHYec7J0ADbXi7eT4lI8/jzAigNQ2jXqMzRdDEa12TkOU0E=
Received: from BYAPR10MB3240.namprd10.prod.outlook.com (2603:10b6:a03:155::17)
 by BYAPR10MB3429.namprd10.prod.outlook.com (2603:10b6:a03:81::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.13; Fri, 29 Jan
 2021 22:14:39 +0000
Received: from BYAPR10MB3240.namprd10.prod.outlook.com
 ([fe80::9123:2652:e975:aa26]) by BYAPR10MB3240.namprd10.prod.outlook.com
 ([fe80::9123:2652:e975:aa26%5]) with mapi id 15.20.3805.022; Fri, 29 Jan 2021
 22:14:39 +0000
Subject: Re: [PATCH V3 0/9] vfio virtual address update
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>
References: <1611939252-7240-1-git-send-email-steven.sistare@oracle.com>
 <20210129145550.566d5369@omen.home.shazbot.org>
From:   Steven Sistare <steven.sistare@oracle.com>
Organization: Oracle Corporation
Message-ID: <acd670f3-acee-cf8a-0dfd-bcf7f3e49087@oracle.com>
Date:   Fri, 29 Jan 2021 17:14:34 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
In-Reply-To: <20210129145550.566d5369@omen.home.shazbot.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [24.62.106.7]
X-ClientProxiedBy: MW4PR04CA0397.namprd04.prod.outlook.com
 (2603:10b6:303:80::12) To BYAPR10MB3240.namprd10.prod.outlook.com
 (2603:10b6:a03:155::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.92] (24.62.106.7) by MW4PR04CA0397.namprd04.prod.outlook.com (2603:10b6:303:80::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17 via Frontend Transport; Fri, 29 Jan 2021 22:14:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f0b66a75-238b-4172-a63b-08d8c4a3456a
X-MS-TrafficTypeDiagnostic: BYAPR10MB3429:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB3429528920CF9F5796293073F9B99@BYAPR10MB3429.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H79Vqka7UtiJtdPEQSu4JfHkfsp+p7rQsoSgB/dytzUV5AFjvIGfq0/nsyqIfBBt7scYT052onjPJneDBAMqjigJBs1Vx8XuffBKVmqUVeq6+2vVbg7HWalapZZqyE7QvRbnVWdjED4xP8J36kYUqigzIQNZZSh2XXC64cCTUROqfPp46PGjpxFS2PS+5KRgrjua6IOyRkqLxZGt4B+17mT0CeZVa6C5+LpkYe0FzKWrkgTwyYj4aynjeI/rTg4fqLOCBPJtrXpgf+uQtOlVMpnb9CSA/zBtrms02vNgjp3D5yvLwFSbq6Trh7hUi8Q9YTqZZW3wW3A5p/L6DaoC22OcUckTCoIVWZQkc0ylceLsJlC6geDFnFJAfiwmIsPIFC8pA//8DFnS53g0Qx6hVyB8XkS1HZXyunOflBrzDbkyzeT4vM7j/kBz+FxnaF4hlofaSTuTLOcMtoBOnsXSzZMHECDAmpFnE0B+5LW/iGAujA41mrStrph7sPTNzttoGDgvc7dO0Az3y7UnS/ryWqvJHpPcNV2vI3mx9WpM2CH4xay9wsQOqUDw+uD2J2/ANjiRE380es0wPz7rdmc2EqK22IeG/sgBxXRQugiXeAtDFdq5Ad9YEtilbTSdfgZ91dD1qFmiP+2mz87bG7HjC2FrSe27gzaQV8kzqw+d8Xy5FTBYP9X0n7X2zgFmvdEO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3240.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(376002)(346002)(39860400002)(396003)(15650500001)(54906003)(5660300002)(16526019)(956004)(44832011)(53546011)(26005)(6916009)(2616005)(31696002)(6486002)(16576012)(36756003)(186003)(86362001)(4326008)(66556008)(6666004)(31686004)(316002)(2906002)(966005)(66946007)(8936002)(36916002)(478600001)(66476007)(83380400001)(8676002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?eEJTcVEvNjJxazQ3TXR4TzU1a2tkNFRUcDR3YTlUT2JxZWx0N1oyZkt3SHNQ?=
 =?utf-8?B?QURMeU15VStadEoxbUZVQmlQbXBtK0ZaT2NlZkRHWFVscVZRbFdTQWllM1RK?=
 =?utf-8?B?WVF2NFhuU1JsUDVvcHA3TTZjZzdQRFRUeUdDTHFETkRQY1ZCVEVWWitkUlVu?=
 =?utf-8?B?bmJFZ3phY3IzcEJlbStWZmJybEpJQTliSU4rMEd0UTQwMEI5QVdIMy9ERkxF?=
 =?utf-8?B?Q0NXUm5Sd2Z6c2hRTWdkUXE5UFhvUHNYMHdhY2k4ZkpnMUpiN0ozV1Z0YVhK?=
 =?utf-8?B?RmNnMzc3SzV4N0lmS0wwNDNvSnJKbWtBWWxwWjltcjFKMEhkc0hucXF5SkVM?=
 =?utf-8?B?OVg2UStWenhQaGsxQytSYndTeWVQTW9WNEQzS1krSnJSY3R5UU84akx5ekFP?=
 =?utf-8?B?NUdDV1BIWmVMazN3Ym9qTkZNclQrdHArNzJ2QjZheDZ5ajFqVEUwbGFOOWlZ?=
 =?utf-8?B?enlsSldDRWZOSG91ME5PSHJ4ZUEyOXB4aVRlNGlxcmdsMU5iWVNrNFU2Tnoy?=
 =?utf-8?B?QVdXbHoyaGhkRG94azVSTlJZWGxHdXpDcE9ieG9oVzgycDF1aldiMU5SWFZI?=
 =?utf-8?B?dVExbjdUOTNZQjUvRG9vdWhVbHVOd0lvaGhsNFMybllVMzNpL294M2VndEpo?=
 =?utf-8?B?RzR0QWtGMktUTEFrNnpFRHNjOUg3SG1Qc01QR0VLeHBqY2x5TndMMFJMYWw0?=
 =?utf-8?B?WnNiRENLc0E5dkNvZDRRdlRyeGtWWWtVZktoZGx3UThYOTRSM01Gdktrdzk3?=
 =?utf-8?B?Q2wyY3JhWTFkMW5uZFpSa0RvVzYzOTdyVjFRNkdDSVlMaHRVNjRlRU5lVklQ?=
 =?utf-8?B?THJyU3hnZHZMN0hUNVc3V2tJcE1wWkVabWcvWFo0QVQxTVR5NGYyRThVU3dy?=
 =?utf-8?B?ZXVYWktYdFpHV3lEaUgyVlc3NjJTSXdHeXh6OVVwY3AvUDRSdjFxSUZmbnBx?=
 =?utf-8?B?akxOR1lPYzQ3aDNTU2RabWxMUG1MajZyUWF6RXBTV3g4U3A3SmhaQ1pvOWFs?=
 =?utf-8?B?M0llLzRuMktZU1ZnNUZhUFJCbzRGU0NXZWRCd2VDUnUrVlFwbU5PWkhOTzM1?=
 =?utf-8?B?N3MxQ2ZCN0lBNkd2bW5TcitIV0RncUNYOWE3SVFmS2ROYVdNemRBcTQ5V01V?=
 =?utf-8?B?dVFnK3FWdHhGN244WWFZano5Wlg2dGNMcUg0ckY2bFpNQml4VGVKaXN1Y2R2?=
 =?utf-8?B?MWxxZlBodHRyN0FYZU9DNUdBdXdab0h4R3FQOWp2TnpEL3NKUVV4MFR0NC9C?=
 =?utf-8?B?UzBXTzBNWStRdXB2Yjlod0lQeVhWb0xwVFpSSCt5bGg0S0Fod21iSTYyeVk3?=
 =?utf-8?B?UXBpL1NEN2p6aDdBcVlJa21FS2h3QzVEOCtKMndhWnFHdmV2ZW9QUWJ3OTl2?=
 =?utf-8?B?L0pVdWhybkxiS2tSVkhsMFowMzJ3U0lKQlJLYzI0OVIrNjR3OVA4SE9EMWxM?=
 =?utf-8?Q?T3llxYy6?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0b66a75-238b-4172-a63b-08d8c4a3456a
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3240.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2021 22:14:39.8204
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dzV7Wne/WH6SIEB3VouQskkKHFwNLr4UT9h/HYA+/akcdny5O18QonImAT01yA4Nv8Ht4Db8qGMbOldskoHN8PhBhCGcSf7zfReQ9bBrmeY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3429
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9879 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101290107
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9879 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 lowpriorityscore=0 mlxlogscore=999 clxscore=1015 phishscore=0 bulkscore=0
 spamscore=0 priorityscore=1501 mlxscore=0 suspectscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101290108
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/29/2021 4:55 PM, Alex Williamson wrote:
> On Fri, 29 Jan 2021 08:54:03 -0800
> Steve Sistare <steven.sistare@oracle.com> wrote:
> 
>> Add interfaces that allow the underlying memory object of an iova range
>> to be mapped to a new virtual address in the host process:
>>
>>   - VFIO_DMA_UNMAP_FLAG_VADDR for VFIO_IOMMU_UNMAP_DMA
>>   - VFIO_DMA_MAP_FLAG_VADDR flag for VFIO_IOMMU_MAP_DMA
>>   - VFIO_UPDATE_VADDR for VFIO_CHECK_EXTENSION
>>   - VFIO_DMA_UNMAP_FLAG_ALL for VFIO_IOMMU_UNMAP_DMA
>>   - VFIO_UNMAP_ALL for VFIO_CHECK_EXTENSION
>>
>> Unmap-vaddr invalidates the host virtual address in an iova range and blocks
>> vfio translation of host virtual addresses, but DMA to already-mapped pages
>> continues.  Map-vaddr updates the base VA and resumes translation.  The
>> implementation supports iommu type1 and mediated devices.  Unmap-all allows
>> all ranges to be unmapped or invalidated in a single ioctl, which simplifies
>> userland code.
>>
>> This functionality is necessary for live update, in which a host process
>> such as qemu exec's an updated version of itself, while preserving its
>> guest and vfio devices.  The process blocks vfio VA translation, exec's
>> its new self, mmap's the memory object(s) underlying vfio object, updates
>> the VA, and unblocks translation.  For a working example that uses these
>> new interfaces, see the QEMU patch series "[PATCH V2] Live Update" at
>> https://lore.kernel.org/qemu-devel/1609861330-129855-1-git-send-email-steven.sistare@oracle.com
>>
>> Patches 1-3 define and implement the flag to unmap all ranges.
>> Patches 4-6 define and implement the flags to update vaddr.
>> Patches 7-9 add blocking to complete the implementation.
> 
> Hi Steve,
> 
> It looks pretty good to me, but I have some nit-picky comments that
> I'll follow-up with on the individual patches.  However, I've made the
> changes I suggest in a branch that you can find here:
> 
> git://github.com/awilliam/linux-vfio.git vaddr-v3
> 
> If the changes look ok, just send me an ack, I don't want to attribute
> something to you that you don't approve of.  Thanks,

Thanks Alex, it's great to be down to nits!  I am done for today but I will
look at the vaddr-v3 branch and respond to all your comments tomorrow.

- Steve
