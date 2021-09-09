Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 174DC405F7A
	for <lists+kvm@lfdr.de>; Fri, 10 Sep 2021 00:25:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347788AbhIIW0s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Sep 2021 18:26:48 -0400
Received: from mail-dm6nam12on2089.outbound.protection.outlook.com ([40.107.243.89]:53569
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1346095AbhIIW0l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Sep 2021 18:26:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IZVbE51TYj0Dht1VBRcJhjkGaKD4mQnvAJFTXcWxq++KQF0ZptD93/rZGL9Q10IBLAvNy7HpkqNxYVbJWPlIhpe4fOr+6qdMq61nHre+NFuHi21bAtCb0EjPM6W8Q899LhNLlKHKDET1+dd4Vw4KptVhAh8jWap8AVuYdlBtRCtxS51d+y5U3LiX28ZmDOS6eFD3ibTnibcjiUzE4jPgQVNkyTCKiDnvmE6Y6uoWywBZUk2DPIQ7ERRk8ve+mCOVvGwHIebX88lP6L/ZECzsQCO2UJEZblX2zHdA261r6WYHI0wOVD+GnZtija2u39NLFbf9W/v8Gg+tCcgONGtR0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=uhOMDWA+zWGkB7kXYdg1YT7vRYSiz4iRK7fJt9U9sU4=;
 b=QF0k0A4wFzt75FKD56rpX3uwQvSdYastW5qzIuA8/MVCmpdUbJ611tDDQpXmox8zbQioncZ142/zXOZ+I8hSYjYDTaViwosftA8Qsez/0aAFBwK3ol7hKBn7l97of1AhDFygrR0pzYlSfVaz/3jkN3pkFJWssAw1uhfh4fdhZoot+GRgzyqNxijmT8H/OtSTss8tyS8D1mcEBKjLa3Y+64DcjYY/lJI291fP/OzO6qRg62fpN4AX6GpTsROWIUF+U2angjz32SmKFB3u2H0G0nVlEVN/CjyubUDqebFYTorsnEdDUsBEJph78FkpL187WBtXkak0ZlPD5j4hJ9ujsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uhOMDWA+zWGkB7kXYdg1YT7vRYSiz4iRK7fJt9U9sU4=;
 b=QYsiZWWVl2JxGNprG2Mh980/TGV1PiEwfLRWZ49iSOEPwmDb1/Hb2DmXwAFvB/NRfBJzoRjWQqnq+C4+9h+FQ4cxLeP0PgW6Z3P2x15crxvTXYGZfFUF8Yfi7nPU2bUEBOBLbQI4CaqJ8C5iWDTu54+DZMlov8EwM8BAtslceyw=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4446.namprd12.prod.outlook.com (2603:10b6:806:71::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Thu, 9 Sep
 2021 22:25:27 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3%6]) with mapi id 15.20.4478.027; Thu, 9 Sep 2021
 22:25:27 +0000
Cc:     brijesh.singh@amd.com, Paolo Bonzini <pbonzini@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        John Allen <john.allen@amd.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm <kvm@vger.kernel.org>,
        linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Alper Gun <alpergun@google.com>,
        Borislav Petkov <bp@alien8.de>,
        David Rienjes <rientjes@google.com>,
        Marc Orr <marcorr@google.com>, Peter Gonda <pgonda@google.com>,
        Vipin Sharma <vipinsh@google.com>
Subject: Re: [PATCH v2 3/4] KVM: SVM: move sev_bind_asid to psp
To:     Mingwei Zhang <mizhang@google.com>,
        Sean Christopherson <seanjc@google.com>
References: <20210818053908.1907051-1-mizhang@google.com>
 <20210818053908.1907051-4-mizhang@google.com> <YTJ5wjNShaHlDVAp@google.com>
 <fcb83a85-8150-9617-01e6-c6bcc249c485@amd.com> <YTf3udAv1TZzW+xA@google.com>
 <8421f104-34e8-cc68-1066-be95254af625@amd.com> <YTpOsUAqHjQ9DDLd@google.com>
 <CAL715W+u6mt5grwoT6DBhUtzN6xx=OjWPu6M0=p0sxLZ4JTvDg@mail.gmail.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <48af420f-20e3-719a-cf5c-e651a176e7c2@amd.com>
Date:   Thu, 9 Sep 2021 17:25:25 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <CAL715W+u6mt5grwoT6DBhUtzN6xx=OjWPu6M0=p0sxLZ4JTvDg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9P221CA0007.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:806:25::12) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
Received: from [10.236.31.95] (165.204.77.1) by SA9P221CA0007.NAMP221.PROD.OUTLOOK.COM (2603:10b6:806:25::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Thu, 9 Sep 2021 22:25:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 81768016-e884-4e2b-e9a7-08d973e0b979
X-MS-TrafficTypeDiagnostic: SA0PR12MB4446:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB44463F3A7F7C9C48BD589CAFE5D59@SA0PR12MB4446.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dfcZ4quuyysqOFb5MkTDVqkUIgHQw0tASz3dXKGuVdZ/LBhN+vS4eRI03wlBF+sIzEY5K0YHHLjm5vpcF/42KZaEC1WjYN6XSAqQtDKZDBhj5FMGuxWVjxoeCU0cWx9i/iBp98E/0pkcplidWA7ZkcKlyx5OjRJ+SfpfL9+xOJFCm63sVJaw4esiOwkoMNRNA93HVto8yP/56peZRDTFYYi+2iHMVEpR491hHCOhVpK9ghmFU0LSQqGskQLgewlVt1nlF85qju1o41hcy2rC4YH1PYbBPNhHcgLeDLM7dq+yru96vlz9kIHXv1vQ4cZ7c44zqs53p27yp5OPRcFT55bVB937hsKtHXtPuSVj/Uczivk9WoLbJZ99M4SZjs3Irfj5dwNdeWpLMSyAjUaaxD2xqB0SykDf3I+pu+6YLNuLhM6jDT+kd2Uq4BfF2HWx1v0w7k+posfTPCcd5B2DeZewNOagGYNgZ4H7sSR6g5tQ2NHtKGQ0e5vMXTPjfG26O/hRGz8Efe5yW0d60lYeZrSY42VDFcniETlup6re8wC9FtpoUdOnsRRv4D2ihieV6HwP6EipwsED6HPJRHTFmBJKqAR8ckhQVelNLUExPSLqb5mxUDS7VU4F6cYJiAICUFTlLxFIQrb7WcYu+hM8XrCFAtcvONVIqFJShXzjC0lk3gFaGCaEUi+vQHjr/tRFqN3HD1ol8mJQqn/uwciUI55Z6Uez5dlJYfq9bDqPM1JcRo+sBDJAws+m6TxYaFuao6Qfn0bVnGrl6M/dsn/PUQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(346002)(39860400002)(366004)(396003)(110136005)(38350700002)(38100700002)(2906002)(31686004)(54906003)(186003)(316002)(16576012)(26005)(44832011)(5660300002)(31696002)(53546011)(66946007)(6486002)(86362001)(8936002)(478600001)(83380400001)(956004)(66556008)(2616005)(66476007)(36756003)(8676002)(4326008)(7416002)(52116002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Slc1cEtHK1ZQRlZaR1dJV2NEdU56ME5Sem1wR2Z5VjVlWmF6b3J1S2lDTld2?=
 =?utf-8?B?bGNQOWFFdVRMRHhVSWIrZVQzVW9Db2poM3I1cXZhZDkxb2d1cnVHQ0RDNWFY?=
 =?utf-8?B?MVVyd09iTjRUYmQxNHpnYW1lLzVFdklNa2dZSzlpU0hOcDR0RGJJRUhtSHkw?=
 =?utf-8?B?OUt5RUUveUVjU1ZqVDNST09WUFYwQm03cHJ5Y2JiTE1BTUlneFRQcEo5L25r?=
 =?utf-8?B?cytCQ3gwWWZZVHo3SU5tTEtXd3lOSW13blo4ZW9OUGVtOG5DOWNjVUc4ZWQw?=
 =?utf-8?B?VmpBMFRULzBhOHFFcGUzLzFWWjNQRWpkTG9NNTNCeExiZWp3OHp4czVxeVBy?=
 =?utf-8?B?YVNDMnZHMkFDSVRySFVzYm1SYXNGcm80clBkazNsS2N1OC9XWnUxOEUrNDhO?=
 =?utf-8?B?WEh1d0ZwTEIxaCtHdVVwemFHbG9XNmtnWktiVVFtVjRVWXN4aG1YZXZ0Qk5N?=
 =?utf-8?B?WFJPOUp2TXg4TTJJV0hhdXRVV2hvNlBUU0E4NldGdlNVYWY2V2hXZHZBd2lB?=
 =?utf-8?B?OTBVVHpNcm0rNTByK2VOZjloZ3VNYVIvQ2lZNGtGV3ZFaVpOMzdyaGFpZm1t?=
 =?utf-8?B?QVNXZDdpMkJVb1JocUxBczF0S0UrQnlNaXRvdXlrN0JRQ0VoQVRRQjRodW1y?=
 =?utf-8?B?TFhoWDZSNVo3NWI3ZG9OaG5HbHVWODY0OEpPRmRrQVFzUUg2WjJBMDhlcVRp?=
 =?utf-8?B?b1ZQN0p2NzhCWEVnc3c0U08zU2dkaUljR1E2eXMxeGQzLys3L3FNWVA0S2s1?=
 =?utf-8?B?QVA0dGFrZi9JcWlSREcxUEtCcUJFUkgxSWZMNmwrcVBFbGE2cW9saHZKUE0z?=
 =?utf-8?B?cFFua1lpOURxWEV4cjFUVXBlb3Voa3RPS0RJRUcwR3Y2VHlMVVBxY0FkMWZR?=
 =?utf-8?B?dWJHQUJWc1p5d0VFTlVTSW1WWVZSKzVFMnBiT1Rqc3lEZS9uMWlQZTZXVUVv?=
 =?utf-8?B?SmZNSk53ZlZXZ2V2KzRHWWc3LzZiVTdFSlhPaS9IenFoZ3Z2TklvdXl3VThl?=
 =?utf-8?B?a1gwSm1pakMwRE9sbVhPVVFpWFQyQ2hxbG95QW52eHBKT0Zlb0ZCYnUxS2Rj?=
 =?utf-8?B?SjV6R0NFTHFzSktMSHBRbDIxRldXNVBuWFZ1M05JTHpYQlJ4ZTVTMWJUYm9p?=
 =?utf-8?B?MFhWRWgxWWxKcElNWnJtMkFCd0dkcFQzTkUrRkdOeWVLWHBYTXgxNTBOZms3?=
 =?utf-8?B?YVVteHpSZ2RGY0gzeE8wNXgwSVBvd20zN05Edy83aFNCN1EwSHNIazkwbU5J?=
 =?utf-8?B?eFRSQ3IybnZEb1ZhTUJHMHlHQUJNZzVpMXNmdHErekxPMmp6WTEwMWpSc2NV?=
 =?utf-8?B?dWs1WFc5andBU29xd3QrY1VkV1FVUERxQUQwUk1Pd3RaSEtnS2N2R0lLYUx1?=
 =?utf-8?B?MXlaYi9SekRyQ3BtclUzaDgxN29EcHhCOW9pQlJXSjVRN1UyNTZyNGwvOGpw?=
 =?utf-8?B?RE1rRGUvZllLK0d4Y0kvZlcxeHJBVU83ZklTdlcvdzl5VVFOejRlejJnSjNF?=
 =?utf-8?B?SVhMUWgyaGNoV1dvbnozTC9UQVJtQ0M0RlFZTG1Xd3JFdjVIN3RaQ214NE5h?=
 =?utf-8?B?U2xLYzFHeTZTejFtOFNiWkZGV2Y4TmVzS3NnZDRaOE56SGI3VjFxajJNcjB2?=
 =?utf-8?B?czhkZ0QzTXVyS1pOR3FjMWMyYkRqQWhvRUxiY3BHYm1WT1JSY09jMHlmUnRJ?=
 =?utf-8?B?SHBMN3AyNFNrenY5RCt0UVYvOHZ5MUFBWXhuMmFNUzNqK3ZlOWt3YWhmUUJE?=
 =?utf-8?Q?ZhGxxmT6yr4/GMCwQD2J6ByUTpWXEkszKGXAzMY?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81768016-e884-4e2b-e9a7-08d973e0b979
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2021 22:25:27.3038
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 754I79nke7pkGpLAK51InqJUEwC83wncspoyPo2kyKIKyxpXU3Yx1A3jCOFDkNLydCU3apqRYuQ8JypOjodtSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4446
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 9/9/21 4:18 PM, Mingwei Zhang wrote:
>>> Most of the address field in the "struct sev_data_*" are physical
>>> addressess. The userspace will not be able to populate those fields.
>>
>> Yeah, that's my biggest hesitation to using struct sev_data_* in the API, it's
>> both confusing and gross.  But it's also why I think these helpers belong in the
>> PSP driver, KVM should not need to know the "on-the-wire" format for communicating
>> with the PSP.
>>
> 
> Did a simple checking for all struct sev_data_* fields defined in psp-sev.h:

thank you for compiling the list, let me add few more at the end of your 
list (they are part of spec but PSP/KVM does not have support for it).

I am also adding SNP specific so that we get a full picture.

> 
> The average argument is roughly 4 (103/27), detailed data appended at
> last. In addition, I believe the most used commands would be the
> following?
> 
> #data structure name: number of meaningful fields
> sev_data_launch_start: 6
> sev_data_activate: 2
> sev_data_decommission: 1
> sev_data_receive_update_data: 7
> sev_data_send_update_vmsa: 7
> sev_data_launch_measure: 3
> sev_data_launch_finish: 1
> sev_data_deactivate: 1
> 

Once the page copy, and swap in/out is implemented then it will also be 
frequently used.

sev_data_copy: 4
sev_swap_out: 12
sev_swap_in: 7

snp_data_gctx_create: 1
snp_data_activate: 2
snp_data_deactivate: 2
snp_data_decommission: 1
snp_data_launch_start: 6
snp_data_launch_update: 8
snp_data_launch_finish: 6
snp_data_page_move: 4
snp_data_page_swap_out: 8
snp_data_page_swap_in: 8
snp_data_page_reclaim: 2
snp_guest_request: 3
snp_guest_request_ext: 5


> For the above frequently-used command set, the average argument length
> is also around 3-4 (28/8) on average, 2.5 as the median.
> 

It averages around 4-5 (51/11) without snp. The good news is with snp 
the avg is still 4-5 (107/24).

Additionally, we also need to pass the sev->fd in each of these 
functions, which will increase avg to 5-6.


> So, from that perspective, I think we should just remove those
> sev_data data structures in KVM, since it is more clear to read each
> argument.
> 

I believe once we are done with it, will have 5 functions that will need 
 >=8 arguments. I don't know if its acceptable.

> In addition, having to construct each sev_data_* structure in KVM code
> is also a pain and  consumes a lot of irrelevant lines as well.
> 

Maybe I am missing something, aren't those lines will be moved from KVM 
to PSP driver?

I am in full support for restructuring, but lets look at full set of PSP 
APIs before making the final decision.

thanks

> #data structure name: number of meaningful fields
> sev_data_deactivate: 1
> sev_data_decommission: 1
> sev_data_launch_finish: 1
> sev_data_receive_finish: 1
> sev_data_send_cancel: 1
> sev_data_send_finish: 1
> sev_data_activate: 2
> sev_data_download_firmware: 2
> sev_data_get_id: 2
> sev_data_pek_csr: 2
> sev_data_init: 3
> sev_data_launch_measure: 3
> sev_data_launch_update_data: 3
> sev_data_launch_update_vmsa: 3
> sev_data_attestation_report: 4
> sev_data_dbg: 4
> sev_data_guest_status: 4
> sev_data_pdh_cert_export: 4
> sev_data_pek_cert_import: 4
> sev_data_launch_start: 6
> sev_data_receive_start: 6
> sev_data_launch_secret: 7
> sev_data_receive_update_data: 7
> sev_data_receive_update_vmsa: 7
> sev_data_send_update_data: 7
> sev_data_send_update_vmsa: 7
> sev_data_send_start: 10
> 
